This is portable program that lets you control menus via autorun.inf files.
It also serves as a portable enforcer for semi-portable programs that don't need installation but do otherwise leave leftovers forever
(i.e. it portabilize non portable apps).
 
Inspired by the late 2002 **Net-burner's AMenu**, only with a user-customized menu, unlimited buttons, control over special buttons, native support for "working folders", an ability to delete leftovers by the launched programs, and much more.
You can even submit your own ideas.

## Usage
All you have to do is launch **AutoRun_x64.exe** or **AutoRun_x32.exe** (see [difference](#what-is-the-difference-between-the-32-bit-and-the-64-bit-version)).

This presents a menu based on an  **autorun.inf** file in the same folder. One of the menu's options is to edit this file and thus control the menu.

Various menu button examples are included in the download.

### Advanced
* Command line parameters can be used, use the help menu to show them or run the launched with `/?`.
* Present a menu from another folder using `-ini=c:\another folder\`.
* For those who don't like menus, you can uncomment `;skiptobutton=X` to choose a pre-defined button instead of opening the menu. For example, `skiptobutton=4` will always launch button 4 without opening the menu. It can also be done with a command line parameter `/skiptobutton=X`, meaning you can keep all settings in 1 file, but use multiple shortcuts, each for a another button.
* A filename can be passed as a command line parameter, to be passed tothe launched program. This can work well with `skiptobutton=X` when associating the launcher to certain file extensions.
* Alternatively, you can define an alternate default button using `focusbutton=X` (e.g. `focusbutton=5`) instead of the first button. It can also be done with the command line `/focusbutton=X`.
* For those who don't like tray icons, you can uncomment `;hidetrayicon=1` to run without it.
* You can define registry values, folders and files (even using wildcards) to delete after the launched program exists. If that program expects certain registry values/folders/files to exist before it runs, you can have blank entries created automatically by appending the values with `+` (e.g. registry=+HKCU\Software\Test) or also use `backuppath=some_folder` (e.g. `backuppath=.` or `backuppath=c:\folder\backup`), which will automatically backup and restore before/after running the program.
  * For registry entries specifically, you can skip a whole backup and just create basic entries like `registry=+HKCU\Software\advanced,accept,1`
* If you like to just trick a non portable program, you can define (multiple) `symlink=symlink|target` to link a non portable file/folder into writing into a portable - note this requires defining `backuppath=` and running the entire launcher as an administrator. This spares the extra write action and possible data loss of backup and restore! Likewise, you can define (multiple) `setenv=variable|value` to fake environmental variables during the session.
* You can run a program after another program by using `buttonafter=X` (e.g. `buttonafter=4` will run button 4 after another button) and it's possible to chain multiple buttons like that - you can use `hidefrommenu=1` to hide such buttons from the menu
* You can enforce a single instance of launched programs by using `singlerun=1` (either globally or per button).
* You can use `blinktaskbarwhendone=1` (globally or for individual buttons) to blink the taskbar upon completion of the launched program.
* You can use `netaccess=0/1` (globally or for individual buttons) whereas 0 will block network access from the launched progrram from, while 1 will give it one-time network access.
* If an external settings file doesn't exist, a default one will be created.
* If you like to launch progras as admin, you can define `admin=1` (globally or for individual buttons).
* If you like to experiment, you can define `simulate=1` inside entries or run the whole launcher with `/simulate` command line parameter). Clicking buttons in that mode will just report what would have happened instead of actually doing anything.

## System requirements
Windows 200X, Windows XP, Windows Vista, Windows 7-11

## Screenshots
<img src="https://github.com/lwcorp/lwmenu/assets/1773306/4d517703-b17c-4013-96d2-527692bb3721" alt="The program" width="40%">

<img src="https://github.com/lwcorp/lwmenu/assets/1773306/4c76a89c-e85f-469c-a32a-d8c04fa1b5e3" alt="Editing settings" width="70%">

## Comparison

| Feature / Benefit                                                                                                                                                                 | AutoRun LWMenu ([latest](/../../releases/latest))                                                                                                                                                                    | PortableApps.com Platform 29.5                                                                 | yaP 0.7.1                                                                                                                                           | PStart v2.11                                                                                                     | Net-burner's AMenu v1.1                                                                |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------|
| Last updated                                                                                                                                                                      | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) 2024                                                                                                                            | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) 2024      | 2016                                                                                                                                                | 2011                                                                                                             | 2002                                                                                   |
| Button style                                                                                                                                                                      | Large/3D                                                                                                                                                                                                             | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) Iconic/2D  | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus                                                        | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) Iconic/2D                    | Large/3D                                                                               |
| Deleting programs' registry leftovers                                                                                                                                             | Yes                                                                                                                                                                                                                  | Yes                                                                                            | Yes                                                                                                                                                 | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No                           | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No |
| Deleting programs' file/folder leftovers                                                                                                                                          | Yes                                                                                                                                                                                                                  | Yes                                                                                            | Yes                                                                                                                                                 | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No                           | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No |
| Can backup/restore apps' registry/folders/files                                                                                                                                   | Yes                                                                                                                                                                                                                  | Yes                                                                                            | Yes                                                                                                                                                 | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No                           | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No |
| Can work without menus (skip to a specific button)                                                                                                                                | Yes                                                                                                                                                                                                                  | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No         | Yes                                                                                                                                                 | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No                           | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No |
| Can specify which button to initially focus on                                                                                                                                    | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                                                             | No                                                                                             | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus                                                        | No                                                                                                               | No                                                                                     |
| Accepting user-defined menu properties                                                                                                                                            | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                                                             | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes       | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus                                                        | No                                                                                                               | No                                                                                     |
| Accepting user-defined button properties                                                                                                                                          | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                                                             | No                                                                                             | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus                                                        | No                                                                                                               | No                                                                                     |
| Regular buttons                                                                                                                                                                   | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Unlimited                                                                                                                       | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Unlimited | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus                                                        | Unlimited, but with scrolling                                                                                    | 1-8                                                                                    |
| Special buttons                                                                                                                                                                   | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) 1-3                                                                                                                             | No                                                                                             | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus                                                        | None                                                                                                             | 2                                                                                      |
| Sub-menus                                                                                                                                                                         | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Unlimited                                                                                                                       | ![Gold color](https://placeholder.antonshell.me/img?width=15&color_bg=FFD700&text=+) 1 level   | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus                                                        | Yes, but with scrolling                                                                                          | No                                                                                     |
| Reloading an updated menu dynamically (i.e. without having to relaunch it)                                                                                                        | Yes                                                                                                                                                                                                                  | Yes                                                                                            | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus                                                        | Yes                                                                                                              | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No |
| Support for closing the menu after launching a program                                                                                                                            | Yes                                                                                                                                                                                                                  | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No         | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No Menus                                                        | Yes                                                                                                              | Yes                                                                                    |
| Commands are stored in                                                                                                                                                            | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) autorun.inf (even when blocked by the OS, plus compatible with AMenu's autorun.inf and instantly editable via a special button) | Nowhere, they're just automatically loaded from sub-folders                                    | An additional folder and INI file for each and every launcher (as there's no menu)                                                                  | An additional XML file                                                                                           | autorun.inf                                                                            |
| Support for OS paths (e.g. "notepad" instead of "%windir%\notepad.exe")                                                                                                           | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                                                             | Not relevant since they're loaded from sub-folders                                             | No                                                                                                                                                  | No                                                                                                               | No                                                                                     |
| Support for "working folders" (i.e. "run from")                                                                                                                                   | Yes                                                                                                                                                                                                                  | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No         | Yes                                                                                                                                                 | Yes                                                                                                              | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No |
| Support for relative folders (e.g. "..\..\")                                                                                                                                      | Yes                                                                                                                                                                                                                  | Yes, because they're loaded from sub-folders of the launcher, wherever it is                   | Yes                                                                                                                                                 | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No                           | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No |
| Support for creating temporary symlinks i.e. symbolic links (tricking a non portable program to write to a portable path) - requires running as admin plus defining `backuppath=` | Yes                                                                                                                                                                                                                  | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No         | Yes                                                                                                                                                 | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No                           | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No |
| Support for environment variables (e.g. "%SystemRoot%\notepad.exe")                                                                                                               | Yes                                                                                                                                                                                                                  | Not relevant since they're loaded from sub-folders                                             | Yes                                                                                                                                                 | ![Gold color](https://placeholder.antonshell.me/img?width=15&color_bg=FFD700&text=+) Partial, from a closed list | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No |
| Support for draft buttons                                                                                                                                                         | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                                                             | Not relevant since they're loaded from sub-folders                                             | No                                                                                                                                                  | No                                                                                                               | No                                                                                     |
| Support for chaining together a sequence of commands                                                                                                                              | Yes                                                                                                                                                                                                                  | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No         | Yes                                                                                                                                                 | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No                           | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) No |
| Support for enforcing a single instance of launched programs                                                                                                                      | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                                                             | No                                                                                             | ![Gold color](https://placeholder.antonshell.me/img?width=15&color_bg=FFD700&text=+) Partial, by making them close first through a separate command | No                                                                                                               | No                                                                                     |
| Allow running without a tray icon                                                                                                                                                 | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                                                             | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes       | No                                                                                                                                                  | No                                                                                                               | No                                                                                     |
| Writing to the disk on each use / tracking usage                                                                                                                                  | No                                                                                                                                                                                                                   | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) Yes        | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) Yes                                                             | ![Red Color](https://placeholder.antonshell.me/img?width=15&color_bg=FF0000&text=+) Yes                          | No                                                                                     |
| Graying out buttons that refer to non existing programs                                                                                                                           | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                                                             | Not relevant since they're loaded from sub-folders                                             | No, as there's no menu. But a warning pops up                                                                                                       | No                                                                                                               | No                                                                                     |
| Support for blinking the taskbar upon completion of the launched program                                                                                                          | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                                                             | No                                                                                             | No, as there's no menu. But a warning pops up                                                                                                       | No                                                                                                               | No                                                                                     |
| Embeddeding a default settings file in case of a missing external file                                                                                                            | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                                                             | Not relevant since they're loaded from sub-folders                                             | No, as there's no menu. But a warning pops up                                                                                                       | No                                                                                                               | No                                                                                     |
| Can launch programs as admin                                                                                                                                          | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                                                             | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                             | No                                                                                                                                                  | No                                                                                                               | No                                                                                     |
| Can either block or allow network access                                                                                                                                         | ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                                                             | No                                                                                             | No                                                                                                                                                  | No                                                                                                               | No     
| Can launch multiple configurations with a single launcher                                                                                                                                          |  ![Green Color](https://placeholder.antonshell.me/img?width=15&color_bg=green&text=+) Yes                                                                                                                             | No                                                                                             | No                                                                                                                                                  | No                                                                                                               | No                                                                                  |

## FAQ

### General
#### How is it different from other similar apps?
It offers a unique combination of usually standalone features. See [comparison](#comparison).

#### Is the program portable?
Yes, no installation is involved. You need to run the main program, see [usage](#usage).

#### What is the difference between the 32-bit and the 64-bit version?
There are no intentional differences. Even more so, the 32-bit version can still be used in 64-bit operating systems. But the 64-bit version is compiled specifically for such systems.

#### Can I restore a launched program's settings before launching it?
Yes, this will allow you to portabilize completely non portable programs. See [usage](#usage) how to backup/restore all kinds of settings.

#### Is there a way to try out deleting/creating leftovers without actually deleting/creating anything?
Yes, see [usage](#usage) on how to activate simulation mode per item or per the entire launcher.

#### Must I use menus?
No, you can avoid menus altogether either by the command line parameter `/skiptobutton=X` or just uncomment `;skiptobutton=X` to choose a pre-defined button instead of opening the menu. For example, `skiptobutton=4` will always launch button 4 without opening the menu.

#### Can I create sub-menus?
Each menu displays a link to its parent menu (if such exists). Also, each menu can detect menus in its sub-folders. Alternatively, specify `relativepathandfilename=folder` to load that folder's menu (if it lacks a menu, the folder would be launched regularly).

Until v1.1, it had to be done indirectly by spreading autorun.inf and autorun.lnk (which calls the actual program) files all over your system, then use `relativepathandfilename=folder\autorun.lnk` to call one menu from another.

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
