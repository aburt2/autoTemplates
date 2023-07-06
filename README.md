# autoTemplates
Scripts and Macros in Autohotkey for pasting templates

## Getting Started
Download the Source Code and run the AutoTemplates.ahk

### Configure Signature
1. Start AutoTemplates.ahk
2. Open the __names.ini__ file
3. Copy the `fullname` section.
4. Replace `[fullname]` to your name keeping the brackets.
5. Replace username with `whoami`. That should autoreplace it with your Windows username.
6. Configure the other settings accordingly.
7. Save the __names.ini__ file.

You should now see your name when you use either hotstrings/hotkeys that output a signature.

### Adding Templates
Create a text file in the Templates folder to add a new template. You can also use the `NewTemplateButton` hotkey to open a text file in notepad with `GreetingKey` and `SignatureKey` already added.
## Settings
The settings are split accross multiple files.
### General Settings
The __settings.ini__ file contains the general settings for AutoTemplates.ahk
| **Setting Name**     | **Description**                                                        | **Default**     |
|----------------------|------------------------------------------------------------------------|-----------------|
| company              | Company Name (optional)                                                | Cabbage Corp    |
| templateCountry      | Name of Template folder for network folder                             | Templates       |
| menuName             | Name of Template menu                                                  | AutoTemplates   |
| defaultSignature     | Default signature to use when printing signature.<br /> Options: `simpleSignature, emailSignature, casualSignature`                     | simpleSignature |
| networkpath          | Path to network folder                                                 | unknown         |
| MenuButtonMouse      | Hotkey which opens menu to select multiple templates for tickets       | ^RButton        |
| MenuButtonKeyboard   | Hotkey which opens menu to select multiple templates for tickets       | ^!j             |
| ReloadButton         | Hotkey for reloading script                                            | ^!r             |
| NewTemplateButton    | Hotkey for creating a blank template in Notepad                        | ^!t             |
| EditTemplateButton   | Hotkey for opening a menu for editing templates in the template folder | ^!e             |
| HelpButton           | Hotkey for opening help menu                                           | ^!h             |
| FolderButton         | Hotkey for opening root folder where the script is located             | ^!f             |
| SettingsButton       | Hotkey for opening settings.ini                                        | ^!s             |
| hotstringadderButton | Hotkey for adding custom hotstring button                              | ^!w             |
| SignatureKey         | Replaced with signature                                                | {SIGNATURE}     |
| GreetingKey          | Replaced with `emailGreeting` from __names.ini__                                          | {GREETING}      |
| closingDatekey       | Replaced with date three business days away                            | {DATE}          |

### Signature Settings
The signature settings are located in the __names.ini__ file.
| **Setting Name** | **Description**                                                 | **Default**              |
|------------------|-----------------------------------------------------------------|--------------------------|
| [fullname]        | Your name                                                       | [fullname]             |
| username         | Windows username (this is how the script identifies you)        | Cabbage Employee         |
| emailGreeting    | Default email greeting, used when `{GREETING}` used in template | Hello                    |
| emailClosing     | Default email closer, used when generating signature, when `{SIGNATURE}` is used in template            | Thanks                   |
| position         | Third line of email signature                                   | Cabbage Agent            |
| department       | Fourth line of email signature                                  | Cabbage Customer Service |

#### Signature Structure
Here is the structure for each signature type defined in `defaultSignature`.
- `emailSignature`: 
    - `emailClosing`
    - `fullname`
    - `position`
    - `department`
- `simpleSignature`:
    - `emailClosing`
    - `fullname`
- `casualSignature`: 
    - `emailClosing`
    - `first name`

### Custom Hotstring Settings
The __hotstring.ini__ file stores custom hotstrings. You can also use the `hotstringadderButton` for generating hotstrings.
| **Setting Name** | **Description**                                  |
|------------------|--------------------------------------------------|
| keycombo         | Key combo that activates hotstring (ie: \custom) |
| action           | Text that appears when `keycombo` is used        |
| Description      | Description of hotstrings for GUI                |

### Hotkey GUI Settings
The __hotkeys.ini__ file stores information about all the built in hotstrings and hotkeys.

| **Setting Name**     | **Description**                 |
|----------------------|---------------------------------|
| keycombo             | Key combo that activates hotkey |
| alternate (optional) | Alternate hotkey for the action |
| Description          | Description of hotkey for GUI   |