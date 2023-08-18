This is portable program that lets you control menus via autorun.inf files.
It also serves as a portable enforcer for semi-portable programs that don't need installation but do otherwise leave leftovers forever
(i.e. it portabilize non portable apps).
 
Inspired by the late 2002 **Net-burner's AMenu**, only with a user-customized menu, unlimited buttons, control over special buttons, native support for "working folders", an ability to delete leftovers by the launched programs, and much more.
You can even submit your own ideas.

## Usage
All you have to do is launch **AutoRun_x64.exe** or **AutoRun_x32.exe** (see [difference](#what-is-the-difference-between-the-32-bit-and-the-64-bit-version)).

This presents a menu based on the local **autorun.inf** file. One of the menu's options is to edit this file and thus control the menu.

For those who don't like menus, you can uncomment `;skiptobutton=x` to choose a pre-defined button instead of opening the menu. For example, `skiptobutton=4` will always launch button 4 without opening the menu.

## System requirements
Windows 200X, Windows XP, Windows Vista, Windows 7-11

## Screenshots
<img src="https://github.com/lwcorp/lwmenu/assets/1773306/b8e0822b-07f1-41b5-a6fa-d2bbaefd27af" alt="The program" width="40%">

<img src="https://github.com/lwcorp/lwmenu/assets/1773306/66b48f5b-7a29-4e00-b40f-db2c96b5e446" alt="Editing settings" width="60%">

## Comparison

|                                                                              | AutoRun LWMenu (latest)                                                                                                                                            |  Net-burner's AMenu v1.1                                             |  PStart v2.11                                                               | yaP 0.7.1                                                                           |
|------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------|-----------------------------------------------------------------------------|------------------------------------------------------------------------------------|
|  Button style                                                                | Large/3D                                                                                                                                                           | Large/3D                                                             | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) Iconic/2D | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus         |
|  Can backup/restore apps' registry/folders/files                                                               | Yes                                                                                                                                                           | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No                                                             | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No | Yes         |
|  Can work without menus                                                                | Yes                                                                                                                                                           | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No                                                             | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No | Yes         |
|  Accepting user-defined menu properties                                      |  ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                            | No                                                                   | No                                                                          | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus         |
|  Accepting user-defined button properties                                    |  ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                            | No                                                                   | No                                                                          | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus         |
|  Regular buttons                                                             |  ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Unlimited                                                                                      | 1-8                                                                  | Unlimited, but with scrolling                                               | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus         |
|  Special buttons                                                             |  ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) 1-3                                                                                            | 2                                                                    | None                                                                        | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus         |
|  Sub-menus                                                                   |  ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                            | No                                                                   | Yes, but with scrolling                                                     | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus         |
| Reloading an updated menu dynamically (i.e. without having to relaunch it)   | Yes                                                                                                                                                                | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No | Yes                                                                         | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus         |
|  Support for closing the menu after launching a program                      | Yes                                                                                                                                                                | Yes                                                                  | Yes                                                                         | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus         |
| Commands are stored in                                                       |  ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) autorun.inf (even when blocked by the OS, plus compatible with AMenu's autorun.inf and instantly editable via a special button)  | autorun.inf                                                          | An additional XML file                                                      | An additional folder and INI file for each and every launcher (as there's no menu) |
|  Support for OS shortcuts (e.g. "winword")                                   |  ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                            | No                                                                   | No                                                                          | No                                                                                 |
|  Support for "working folders" (i.e. "run from")                             | Yes                                                                                                                                                                | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No | Yes                                                                         | Yes                                                                                |
|  Support for relative folders (e.g. "..\..\")                                | Yes                                                                                                                                                                | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No        | Yes                                                                                |
|  Support for environment variables (e.g. "%SystemRoot%\notepad.exe")         | Yes                                                                                                                                                                | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No | ![Gold color](https://placeholder.antonshell.me/img?width=15&color_bg=FFD700&text=+) Partial  | Yes                                                                                |
|  Writing to the disk on each use / tracking usage                            | No                                                                                                                                                                 | No                                                                   | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) Yes       | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) Yes                                                                                 |
| Graying out buttons that refer to non existing programs                      |  ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                            | No                                                                   | No                                                                          | No, as there's no menu. But a warning pops up                                 |
|  Deleting programs' registry leftovers                                       | Yes                                                                                                                                                                | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No        | Yes                                                                                |
|  Deleting programs' file/folder leftovers                                    | Yes                                                                                                                                                                | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No        | Yes                                                                                |
|  Re-creating empty folders                                                   | Yes                                                                                                                                                                | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No        | Yes                                                                                |

## FAQ

### General
#### How is it different from other similar apps?
It offers a unique combination of usually standalone features. See [comparison](#comparison).

#### Is the program portable?
Yes, no installation is involved. You need to run the main program, see [usage](#usage).

#### What is the difference between the 32-bit and the 64-bit version?
There are no intentional differences. Even more so, the 32-bit version can still be used in 64-bit operating systems. But the 64-bit version is compiled specifically for such systems.

#### Must I use menus?
No, you can uncomment `;skiptobutton=X` to choose a pre-defined button instead of opening the menu. For example, `skiptobutton=4` will always launch button 4 without opening the menu.

#### Can I create sub-menus?
(v1.1+) Each menu displays a link to its parent menu (if such exists). Also, each menu can detect menus in its sub-folders. Alternatively, specify relativepathandfilename=folder to load that folder's menu (if it lacks a menu, the folder would be launched regularly).
 
(v1.0) No, but the program can launch shortcuts. Therefore, you can spread autorun.inf and autorun.lnk (which calls the actual program) files all over your system, then use relativepathandfilename=folder\autorun.lnk to call one menu from another.

### Misc
#### Can the menu open automatically in anything other than DRIVE_CDROM?

While outside of the scope of program, it's understandable why users of this program would want the menu to open automatically in DRIVE_FIXED and DRIVE_REMOVABLE (e.g. USB flash drive). Therefore, here's a summary (based on [Inf handling in Wikipedia](https://en.wikipedia.org/wiki/Autorun.inf#Inf_handling)):

| Version of Windows            | Inf handling of autorun.inf's [AutoRun] section                                                                            |
|-------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| **Windows 9X/Me**             |                                                                                                                            |
| DRIVE_CDROM                   |  ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) "open" command is executed automatically               |
| DRIVE_REMOVABLE / DRIVE_FIXED |  ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) "open" command is executed automatically               |
| **Windows XP/XP SP1**         |                                                                                                                            |
| DRIVE_CDROM                   |  ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) "open" command is executed automatically               |
| DRIVE_REMOVABLE / DRIVE_FIXED | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) "open" command is disabled                               |
| **Windows XP SP2/SP3+**       |                                                                                                                            |
| DRIVE_CDROM                   |  ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) "open" command is executed automatically               |
| DRIVE_REMOVABLE / DRIVE_FIXED | ![Yellow color](https://placeholder.antonshell.me/img?width=15&color_bg=FFFF00&text=+) "open" command can be enabled by "**action=My menu**" |
| **Windows Vista**             |                                                                                                                            |
| DRIVE_CDROM                   | ![Yellow color](https://placeholder.antonshell.me/img?width=15&color_bg=FFFF00&text=+) "open" command can be enabled by "**action=My menu**" |
| DRIVE_REMOVABLE / DRIVE_FIXED | ![Yellow color](https://placeholder.antonshell.me/img?width=15&color_bg=FFFF00&text=+) "open" command can be enabled by "**action=My menu**" |
| **Windows 7+**                 |                                                                                                                            |
| DRIVE_CDROM                   | ![Yellow color](https://placeholder.antonshell.me/img?width=15&color_bg=FFFF00&text=+) "open" command can be enabled by "**action=My menu**" |
| DRIVE_REMOVABLE / DRIVE_FIXED | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) "open" command is disabled                               |
 
**Conclusion:** Starting from Windows XP, Microsoft tried to limit the "open" command support to DRIVE_CDROM. While later versions did back down somewhat, Windows 7 once again completely disabled it. So if your audiences use Windows 7 and above, you'll have to teach them how to browse for autorun.exe manually. For older audiences or CDROMs, you can still use the "action" trick.

### License
#### Is the program free?
Yes, it's open source (as of version 1.3.4).
<br />Prior to that, it was a freeware (starting in version 1.3.1).
<br />Originally it was a time unlimited shareware with a possibility to register.

#### Registered version (no longer needed)

##### What were the benefits of registering?

These features are now free, but originally they only worked for registered users:

* No "trial mode" in the title.
* Support for deleting leftover files/folders (including re-creating empty folders).
* Ability to hide special buttons.
* Supporting future development.

##### What was the definition of "Life" in Life license?
Before the program was free, users could choose between 1 year and Life. The latter meant the life of the product. That is, updates for as long as there are updates.
Choosing the license showed dedication and support for future versions. The price was not too expensive anyway, so there was no a big loss even if there were no more updates.

##### Did it phone home?
Before the program was free, it didn't phone home per se. But it did validate one's license key every once in a while. Product activation ([see Wikipedia](https://en.wikipedia.org/wiki/Product_activation)) is the only way to combat crackers. It's not the best way so much as it's the only realistic way. Validation only occurred seldom and was quick and automated. It did alert to its presence to maintain full disclosure. Precautions were made so only abnormal long Internet connection dropouts would result in the need to re-register one's license key (once the connection was finally back).
