# ChatBox
A Light Weight Minetest Mod For Servers Adding Various Chat Commands
![screenshot](https://github.com/mrtechtroid/ChatBox/blob/main/screenshot.png?raw=true)
## List Of New Privilages
1. `announce` - Allows You To Send Messages Prefixed With `[Server]` Prefix. 
2. `youtuber` - Allows A Special Prefix `[YT]` For Popular Youtubers
3. `invis` - Allows You To Use `/invis` Command
4. `effects` - Allows You To Gain Additional Player Effects And Enhancements. 

## List Of New Commands  
 Sr No | Command | Details | Usage | Privilages |
|---| -------- |--------- |------- |----------- |
|1. |`\m` | Sends A Private Message To A Player | `\m <reciever><message>` |`shout`
|2. |`\pm` | Sends A Private Message To A Player  | `\pm <reciever><message>`  | `shout`
|3. |`\r` | Sends A Private Message To A Player Who Sent Last Message  |`\r <message>` |`shout`
|4. |`\disable_pchat` | Disables Private Chat For All Players  |`\disable_pchat`  | `server`
|5. |`\mx` | Move In X Coordinates  |`\mx <position>`  | `teleport`
|6. |`\my` | Move In Y Coordinates  |`\my <position>`  |`teleport`
|7. |`\mz` | Move In Z Coordinates  |`\mz <position>`  | `teleport`
|8. |`\announce` | Allows Admins To Announce Special Message To Server Prefixed with `[Server]` | `\announce <message>` | `announce`
|9. |`\make_mod` | Allows You To Make A Player A Mod With One Command | `\make_mod <playername>` | `server`
|10.|`\make_basic` | Removes All Extra Privilages Of Player Keeping The Bare Necessities | `\make_basic <playername>` | `server`
|11.| `\t` | Easier Change Of Time Of Day (D= Day,M = Midday,N=Night) | `\t <d/m/n>` | `settime`
|12.| `\tp` | An Alternative to  `\teleport` Command  | `\tp ` | `teleport`
|13.| `\invis` | Make Yourself Invisible To Other Players | `\invis` | `invis`
|14.| `\search` | Search For A Block Near Your Area | `\search <blockid>`| `server`
|15.| `\h` | Fills The Health Of The Player | `\h`| `effects`
|16.| `\immortal` | Makes A Player Immortal To All Kinds Of Damages | `\immortal` | `effects`
|17.| `\hp` | Sets A Custom HP Of The Player| `\hp <hp>` |`effects`
|18.| `\bnight` | Makes Nights Look As Day For A Single Player | `\bnight` | `effects`
|19.| `\ncol` | Sets A Custom Player Name Tag Color For A Player Using RGB.(Removed On LogOff) | `\ncol <r> <g> <b>` | `effects`
|20.| `\warn` | Makes A Player Immortal To All Kinds Of Damages | `\warn <message>` | `announce`
|21.| `\rules` | View The Rules Of The Server In A GUI Interface | `\rules` | No Privilage Needed
|22.| `\cbox` | View Additional Details About The Mod | `\cbox` | No Privilage Needed

## Additional Features
1. A Custom Colored Chat With The Ability To Use "!" Infront Of Messages To Make Them Green.
2. Roles Appear On The Main Public Chat With A Red Color. 
3. Death Messages Informing The Last Death Location To The Player. 


### Rules
To Modify The Rules Of The Server Change the `rules.txt` File In The Directory

## Licensing And Copyright
Copyright © 2022 Mr Techtroid  
Released Under MIT License  

