-- ChatBox By Mr Techtroid
-- Released Under MIT License
-- Version 1.0.1 (2022)
-- Copyright (C) 2022 Mr Techtroid
chatbox = {
    vno = "1.0.1",
    author = "Mr Techtroid",
    license = "MIT License",
    copyright = "Copyright (C) 2022 Mr Techtroid",
}
replyto = {}
invisiblity = {}
imortality = {}
disable_chat = 0
local modpath = minetest.get_modpath("chatbox")
local rulesfile = io.open(modpath .. "/rules.txt","r")
local rulescontent
if rulesfile then
    rulescontent = rulesfile:read("*all")
end
rulesfile:close()
-- General Functions For Disabling Chat, Getting And Splitting Parameters And Chat Handler
local function dischat()
    if disable_chat == 0 then
        disable_chat = 1
    else
        disable_chat = 0
    end
end
local function rulesfunc()
    local formspec = {
        "formspec_version[4]",
        "size[12,12]",
        "label[5.5,0.5;Rules]",
        "textarea[1,1;10,10;;", minetest.formspec_escape(rulescontent), ";]",
        "button_exit[5,11;3,0.8;close;Close]",
    }
    return table.concat(formspec,"")
end
local function getopts(command, param)
	local opts = ""
	local args = {}
	for match in param:gmatch("%S+") do
		if match:byte(1) == 45 then -- 45 = '-'
			local second = match:byte(2)
			if second == 45 then
				return false, S("Invalid parameters (see /help @1).", command)
			elseif second and (second < 48 or second > 57) then -- 48 = '0', 57 = '9'
				opts = opts .. match:sub(2)
			else
				-- numeric, add it to args
				args[#args + 1] = match
			end
		else
			args[#args + 1] = match
		end
	end
	return opts, args
end
local function rgb_to_hex(r, g, b)
    --%02x: 0 means replace " "s with "0"s, 2 is width, x means hex
	return string.format("#%02x%02x%02x", 
		math.floor(r*255),
		math.floor(g*255),
		math.floor(b*255))
end
function rgbToHex(r,g,b)
    local rgb = (r * 0x10000) + (g * 0x100) + b
    return "#" .. string.format("%x", rgb)
end

local function sndMsg(sender,reciever,message)
    replyto[sender] = reciever
    replyto[reciever] = sender
    
    local modtext = ""
    if not minetest.check_player_privs(sender, {shout = true}) then
        minetest.chat_send_player(sender,minetest.colorise("#FF0000","You Dont Have Privilege To Send Messages"))
    end
    if minetest.check_player_privs(sender, {youtuber = true}) then
        modtext = minetest.colorize("#FF0000","[YT]")
    end
    if minetest.check_player_privs(sender, {moderator = true}) then
        modtext = minetest.colorize("#FF0000","[S]")
    end
    if minetest.check_player_privs(sender, {server = true}) then
        modtext = minetest.colorize("#FF0000","[Admin]")
    end
    if minetest.get_player_by_name(reciever) then
        if disable_chat == 0 then
            if message == nil then
                minetest.chat_send_player(sender,minetest.colorize("#FF0000","Messages Cant Be Empty"))
            else
                minetest.chat_send_player(reciever,minetest.colorize("#006400","PM From") .. " "..modtext .. minetest.colorize("#00FF00",sender)..": "..minetest.colorize("#006400",message))  
            end
        else
            if minetest.check_player_privs(sender, {server = true}) then
                if message == nil then
                    minetest.chat_send_player(sender,minetest.colorize("#FF0000","Messages Cant Be Empty"))
                else
                    minetest.chat_send_player(reciever,minetest.colorize("#006400","PM From") .. " "..modtext .. minetest.colorize("#00FF00",sender)..": "..minetest.colorize("#006400",message))  
                end
            else
                minetest.chat_send_player(sender,minetest.colorize("#FF0000","Private Chats Are Disabled")) 
            end
        end 
    else
        minetest.chat_send_player(sender,minetest.colorize("#FF0000",reciever .. " Is Not Online"))
    end
end
local function invischeck(name,vars)
    invisiblity[name] = vars
    local gt  
    local player = minetest.get_player_by_name(name)
    
    if vars == true then
        gt = {visual_size = {x = 0,y = 0}}
        local nametag = player:get_nametag_attributes()
		nametag.color.a = 0
		player:set_nametag_attributes(nametag)
    else
        gt = {visual_size = {x = 1, y = 1}}
        local nametag = player:get_nametag_attributes()
		nametag.color.a = 255
		player:set_nametag_attributes(nametag)
    end
    player:set_properties(gt)
end
-- Chat Messaging /m /pm For Private Messaging
minetest.register_chatcommand("m",{
    params = "<reciever><message>",
    description = "Sends A Private Message To A Player",
    func = function(name,param)
        -- minetest.chat_send_player(name,param)
        opts, args = getopts("m",param)
        sndMsg(name,args[1],args[2])
    end,
    privs = {shout = true,},
})
minetest.register_chatcommand("pm",{
    params = "<reciever><message>",
    description = "Sends A Private Message To A Player",
    func = function(name,param)
        -- minetest.chat_send_player(name,param)
        opts, args = getopts("pm",param)
        sndMsg(name,args[1],args[2])
    end,
    privs = {shout = true,},
})

-- Chat Messaging /r For Easier Convienient Chat Messaging
minetest.register_chatcommand("r",{
    params = "<message>",
    description = "Sends A Private Message To A Player Who Sent Last Message",
    func = function(name,param)
        if replyto[name] ~= nil then
            sndMsg(name,replyto[name],param)
        else
            minetest.chat_send_player(name,minetest.colorize("#FF0000","You Must Write To Someone Before Replying"))
        end
    end,
    privs = {shout = true,},
})

-- Chat Messaging /disable_pchat For Disabling Private Chat Between Players
minetest.register_chatcommand("disable_pchat",{
    privs = {server = true,},
    description = "Disables Private Chat For All Players Connected",
    func = function()
        dischat()
    end,
})
-- Removal Of /msg Replaced By /m /pm
minetest.unregister_chatcommand("msg")

-- Teleportations /mx /my /mz For Easier Teleportation. Allows To Pass Trough Walls For Moderators
minetest.register_chatcommand("mx",{
    params = "<position>",
    description = "Move In X Coordinates",
    func = function(name,param)
        local player = minetest.get_player_by_name(name)
        local pos = player:get_pos()
        if pos.x+param>31007 then
            minetest.chat_send_player(name,minetest.colorize("#FF0000","Out Of Map Bonds"))
        else
        player:set_pos({x=pos.x+param,y=pos.y,z=pos.z})
        end
    end,
    privs = {teleport = true,},
})
minetest.register_chatcommand("my",{
    params = "<position>",
    description = "Move In Y Coordinates",
    func = function(name,param)
        local player = minetest.get_player_by_name(name)
        local pos = player:get_pos()
        if pos.y+param>31007 then
            minetest.chat_send_player(name,minetest.colorize("#FF0000","Out Of Map Bonds"))
        else
        player:set_pos({x=pos.x,y=pos.y+param,z=pos.z})
        end
    end,
    privs = {teleport = true,},
})
minetest.register_chatcommand("mz",{
    params = "<position>",
    description = "Move In Z Coordinates",
    func = function(name,param)
        local player = minetest.get_player_by_name(name)
        local pos = player:get_pos()
        if pos.z+param>31007 then
            minetest.chat_send_player(name,minetest.colorize("#FF0000","Out Of Map Bonds"))
        else
        player:set_pos({x=pos.x,y=pos.y,z=pos.z+param})
        end
    end,
    privs = {teleport = true,},
})

-- Announce Privilage And Command - Allows You To Control Messages Sent By Server
minetest.register_privilege("announce",{
    description = "Allows Admins To Announce Special Messages To Server Chat",
    give_to_admin = true,
    on_grant = function(name,granter_name)
        minetest.chat_send_player(name,minetest.colorize("#FF0000","You Have Been Granted The Announce Privilage"))
    end,
    on_revoke = function(name,granter_name)
        minetest.chat_send_player(name,minetest.colorize("#FF0000","Your Privilage Of Announce Have Been Removed"))
    end,
})
minetest.register_chatcommand("announce",{
    params = "<message>",
    description = "Allows Admins To Announce Special Message To Server",
    func = function(name,param)
        -- if not param == "" then
            minetest.chat_send_all(minetest.colorize("#FF0000","[Server]") .. minetest.colorize("#BFFF00",": "..param))
        -- end
    end,
    privs = {announce = true,},
})

-- Youtuber Privilage - Allows A Special Prefix [YT] For Popular Youtubers
minetest.register_privilege("youtuber",{
    description = "Grants A Special Tag To Youtubers",
    on_grant = function(name,granter_name)
        minetest.chat_send_player(name,minetest.colorize("#FF0000","You Have Been Granted The Youtuber Privilage"))
    end,
    on_revoke = function(name,granter_name)
        minetest.chat_send_player(name,minetest.colorize("#FF0000","Your Privilage Of Youtuber Have Been Removed"))
    end,
})

-- Moderation - Allows You To Make A Player A Mod With One Command
minetest.register_chatcommand("make_mod",{
    privs = {server = true,},
    params = "<playername>",
    description = "Adds A Player As A Moderator To Server",
    func = function(name,param)
        minetest.set_player_privs(param,{shout=true,interact=true,moderator=true,ban=true,teleport=true,fast=true,fly=true})
    end,
})
-- Moderation - Removes All Extra Privilages Of Player Keeping The Bare Necessities
minetest.register_chatcommand("make_basic",{
    privs = {server = true,},
    params = "<playername>",
    description = "Revoke All Privilages Of A Player Leaving Only Basic Privilages",
    func = function(name,param)
        minetest.set_player_privs(param,{shout=true,interact=true})
    end,
})

-- Clean Up Of ReplyTo Database To Prevent Overload after player leaves. 
minetest.register_on_leaveplayer(function(ObjectRef, timed_out)
    pname = ObjectRef:get_player_name()
    replyto[pname] = nil
    invisiblity[pname] = nil
    imortality[pname] = nil
    player = minetest.get_player_by_name(pname)
    player:override_day_night_ratio(nil)
    -- minetest.chat_send_all(dump(replyto))
end
)
-- Time - /t - Easier Changes In Time Of Day
minetest.register_chatcommand("t",{
    privs = {settime = true},
    params = "<d|m|n>",
    description = "Easier Change Of Time Of Day",
    func = function(name,param)
        if param == "d" then
            minetest.set_timeofday(0.3)
        else
            if param == "n" then
                minetest.set_timeofday(0)
            else
                if param == "m" then
                    minetest.set_timeofday(0.5)
                else
                    minetest.chat_send_player(name,minetest.colorize("#FF0000","Invalid Time Of Day"))
                end
            end
        end
    end,
})

-- Teleportation - /tp - Shorter Command For Teleportation
minetest.register_chatcommand("tp",{
    params = "",
    description = "Alternative For Teleport Command",
    func = function(name,params)
        tpc = minetest.chatcommands["teleport"]
        if  minetest.check_player_privs(name, "teleport") then
            return tpc.func(name,params)
        else
            return false, "Your privileges are insufficient."
        end
        
    end,
    privs = {teleport = true}
})

-- Invisiblity - /invis Hides Your Textures For Others
minetest.register_privilege("invis",{
    description = "Allows Admins To Become Invisible",
    give_to_admin = true,
    on_grant = function(name,granter_name)
        minetest.chat_send_player(name,minetest.colorize("#FF0000","You Have Been Granted The Invisiblity Privilage"))
    end,
    on_revoke = function(name,granter_name)
        minetest.chat_send_player(name,minetest.colorize("#FF0000","Your Privilage Of Invisiblity Have Been Removed"))
    end,
})
minetest.register_chatcommand("invis",{
    params = "<name>",
    description = "Allows Admins To Become Invisible",
    func = function(name,params)
        local named = name
        if param == nil then
            named = name
        else
            if minetest.get_player_by_name(params) then
                named = params
            else
                minetest.chat_send_player(name,minetest.colorize("#FF0000","Player Not Online"))
                return false
            end
        end
        if invisiblity[named] then
            invischeck(named,nil)
        else
            invischeck(named,true)
        end
    end,
    privs = {invis = true},
})

-- Search - Used For Searching For Certain Blocks
minetest.register_chatcommand("search",{
    params = "<block>",
    description = "Allows Admins To Search For Certain Blocks Nearby",
    privs = {server = true},
    func = function(name,params)
        local player = minetest.get_player_by_name(name)
        local pos = player:get_pos()
        local nodepos = minetest.find_node_near(pos,20,{params},true)
        if nodepos == nil then
            minetest.chat_send_player(name,"Block Not Found Nearby")
        else
            minetest.chat_send_player(name,"Nearest Block At: " .. nodepos.x .. ","..nodepos.y..","..nodepos.z)
        end
    end
})
-- Effects Privilage For Commands /h and /immortal
minetest.register_privilege("effects",{
    description = "Allows Players To Have Additional Enhancements",
    give_to_admin = true,
    on_grant = function(name,granter_name)
        minetest.chat_send_player(name,minetest.colorize("#FF0000","You Have Been Granted The Effects Privilage"))
    end,
    on_revoke = function(name,granter_name)
        minetest.chat_send_player(name,minetest.colorize("#FF0000","Your Privilage Of Effects Have Been Removed"))
    end,
})
-- Health Regen - /h - Allows You To Fill The Health Of Player
minetest.register_chatcommand("h",{
    params = "",
    description = "Fill The Health Of Player",
    func = function(name,param)
        local player = minetest.get_player_by_name(name)
        player:set_hp(20)
    end,
    privs = {effects = true},
})

-- Custom Health - /hp - Allows You To Set A Custom HP Of Player
minetest.register_chatcommand("hp",{
    params = "<hp>",
    description = "Set A Custom HP Of Player",
    func = function(name,param)
        local player = minetest.get_player_by_name(name)
        player:set_hp(param)
    end,
    privs = {effects = true},
})
-- Immortal - /immortal - Makes You Resistant To All Damages
minetest.register_chatcommand("immortal",{
    params = "",
    description = "Makes You Immortal",
    func = function(name,param)
        local player = minetest.get_player_by_name(name)
        local armour = player:get_armor_groups()
        if imortality[name] then
            player:set_armor_groups({})
            imortality[name] = nil
        else
            if armour then
                armour.fleshy = 0
                imortality[name] = true
                armour.fall_damage_add_percent = -100
                player:set_armor_groups(armour)
                minetest.chat_send_player(name,minetest.colorize("#FF0000","You Are Now Immortal"))
            end
        end
    end,
    privs = {effects = true},
})
-- About /cbox - Gives Info On The Mod
minetest.register_chatcommand("cbox",{
    params = "",
    description = "Info About ChatBox Mod",
    func = function(name)
        minetest.chat_send_player(name,minetest.colorize("#FF0000","---------------------------------------"))
        minetest.chat_send_player(name,minetest.colorize("#BFFF00","ChatBox By Mr Techtroid"))
        minetest.chat_send_player(name,minetest.colorize("#BFFF00","Version:" .. chatbox["vno"] ))
        minetest.chat_send_player(name,minetest.colorize("#BFFF00","Released Under ".. chatbox["license"]))
        minetest.chat_send_player(name,minetest.colorize("#FF0000","---------------------------------------"))
    end,
    privs = {},
})

-- Rules /rules - Gives A List Of All Rules In A GUI
minetest.register_chatcommand("rules",{
    params = "",
    description = "Display The Server Rules",
    func = function(name,params)
        rulesfunc()
        minetest.show_formspec(name, "chatbox:rules", rulesfunc())
    end,
    privs = {},
})

-- Bright Night /bnight - Increases The Day Night Ratio For That Player
minetest.register_chatcommand("bnight",{
    params = "",
    privs = {effects = true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player:get_day_night_ratio() == 1 then
            player:override_day_night_ratio(nil)
        else
            player:override_day_night_ratio(1)
        end
    end,
    description = "Increases The Day Night Ratio For That Player"
})

-- NameTag Color /ncol - Allows Players To Change Their Nametag Colors
minetest.register_chatcommand("ncol",{
    params = "<r> <g> <b>",
    privs = {effects = true},
    func = function(name,params)
        local player = minetest.get_player_by_name(name)
        local nametag = player:get_nametag_attributes()
        opts, args = getopts("ncol",params)
        nametag.color.a = 255
        nametag.color.r = args[1]
        nametag.color.g = args[2]
        nametag.color.b = args[3]
        player:set_nametag_attributes(nametag)
    end,
    description = "Changes The Name Tag Color"
})

-- Colored Multiplayer Chat 

minetest.register_on_chat_message(function(name, message)
    local  modtext = ""
    local  msgcolor = "#FFFFFF"
    local player = minetest.get_player_by_name(name)
    local nametag = player:get_nametag_attributes()
    local nt = nametag.color
    if not minetest.check_player_privs(name, {shout = true}) then
        minetest.chat_send_player(name,minetest.colorise("#FF0000","You Dont Have Privilege To Send Messages"))
    end
    if minetest.check_player_privs(name, {youtuber = true}) then
        modtext = minetest.colorize("#FF0000","[YT]")
    end
    if minetest.check_player_privs(name, {moderator = true}) then
        modtext = minetest.colorize("#FF0000","[S]")
    end
    if minetest.check_player_privs(name, {server = true}) then
        modtext = minetest.colorize("#FF0000","[Admin]")
    end
    if minetest.check_player_privs(name, {moderator = true}) or minetest.check_player_privs(name, {server = true}) then
        if string.sub(message,1,1) == "!" then
            msgcolor = "#006400"
            message = message:sub(2,message:len())
        end
    end
    minetest.chat_send_all(modtext .. " " .. minetest.colorize(rgbToHex(nt.r, nt.g, nt.b),name)..": "..minetest.colorize(msgcolor,message)) 
    return true
end
)

-- Death Coordinates
minetest.register_on_dieplayer(function(ObjectRef, reason)
    local name = ObjectRef:get_player_name()
    local position = ObjectRef:getpos()
    minetest.chat_send_player(name,minetest.colorize("#FF0000","You Died At "..math.floor(position.x) .. ", " .. math.floor(position.y) .. ", " .. math.floor(position.z) .. " Coordinates"))
    return true
end
)

-- Warn /warn Allows Admins To Warn Players
minetest.register_chatcommand("warn",{
    params = "<message>",
    description = "Allows Admins To Warn Players Over Chat",
    func = function(name,param)
        -- if not param == "" then
            minetest.chat_send_all(minetest.colorize("#FF0000","[WARNING]") .. minetest.colorize("#FF0000",": "..param))
        -- end
    end,
    privs = {announce = true,},
})

