; adapted from https://www.autohotkey.clengthom/board/topic/95860-sub-menus-from-file/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance Force
#Include Lib/WatchFolder.ahk
; StringCaseSense, ON
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;****************************************************************************************
;SETUP
;****************************************************************************************
; Read settings from settings.ini
    IniRead, company,	 				settings.ini, Simple, company

	;Where on the network the template files are found
	IniRead, mentitff,			 		settings.ini, Advanced, mentitff	

	;What country the template files should come from
	IniRead, templatecountry, 			settings.ini, Simple, templatecountry

	;Where on the network the template files are found
	IniRead, networkpath, 				settings.ini, Advanced, networkpath

	;Get the Menu Name
	IniRead, menuName,					settings.ini, Simple, menuName
	
	;Reads the settings file and sets the hotkey to launch the menu accordingly	
	IniRead, MenuButtonMouse,	 		settings.ini, Advanced, MenuButtonMouse
	IniRead, MenuButtonKeyboard,	 	settings.ini, Advanced, MenuButtonKeyboard
	IniRead, ReloadButton,				settings.ini, Advanced, ReloadButton
	IniRead, NewTemplateButton,		    settings.ini, Advanced, NewTemplateButton
	IniRead, EditTemplateButton,		settings.ini, Advanced, EditTemplateButton
	IniRead, HelpButton,				settings.ini, Advanced, HelpButton
	IniRead, FolderButton,				settings.ini, Advanced, FolderButton
	IniRead, SettingsButton,			settings.ini, Advanced, SettingsButton
	IniRead, hotstringadderButton,		settings.ini, Advanced, hotstringadderButton

	;Load default email signature shortcut
	IniRead, DefaultSig,				settings.ini, Advanced, emailSignature
	
	;Load keywords
	IniRead SIGNATURE,					settings.ini, Keywords, SignatureKey
	IniRead GREETING,					settings.ini, Keywords, GreetingKey
	IniRead CLOSINGDATE,				settings.ini, Keywords, ClosingDateKEy

	;Read default signature settings
	IniRead, name,		 				names.ini, DefaultSig, username
	IniRead, EmailGreeting,		 		names.ini, DefaultSig, emailGreeting
	IniRead, EmailClosing,				names.ini, DefaultSig, emailClosing
	IniRead, position,		 			names.ini, DefaultSig, position
    IniRead, department,	 			names.ini, DefaultSig, department

; Read names from names.ini file
	IniRead, nameList,					names.ini

; Read list of hotkeys
	IniRead, hotkeyList,				hotkeys.ini

; Read Custom hotstrings
	IniRead, hotstringList,				hotstrings.ini

; Define script directory as watch folder directory
WatchedFolder := A_ScriptDir

; Watch for changes in this directory
WatchFolder(WatchedFolder,"AutoReloadChanges", true, 1 | 2 | 8 | 16)

; Define hotstring file
hotstringfile := A_ScriptDir "\hotstrings.ini"
;****************************************************************************************
; GUI Creation (Help Menu)
;****************************************************************************************
; Create GUI to display hotkey and hotstrings
hotkeyDescriptions := {}
hotstringsDescriptions := {} ; create list to generate custom hotstrings
Loop, parse, hotkeyList, `n ; add all the hotkeys into a dictionary
{
	IniRead, currKey,						hotkeys.ini, %A_LoopField%, keycombo
	IniRead, currDescription,				hotkeys.ini, %A_LoopField%, Description
	IniRead, curralternate,					hotkeys.ini, %A_LoopField%, alternate
	if (curralternate != "ERROR") ; if there is an alternate hotkey add it
	{
		currKey := currKey "/" curralternate ;add alternate hotkeys
	}
	hotkeyDescriptions.Push({"Hotkey":currKey, "Comment":currDescription})
}

Loop, parse, hotstringList, `n ; add all the hotkeys into a dictionary
{
	IniRead, currKey,						hotstrings.ini, %A_LoopField%, keycombo
	IniRead, currDescription,				hotstrings.ini, %A_LoopField%, Description
	IniRead, curralternate,					hotstrings.ini, %A_LoopField%, alternate
	IniRead, curraction,					hotstrings.ini, %A_LoopField%, action
	if (curralternate != "ERROR") ; if there is an alternate hotkey add it
	{
		guiKey := currKey "/" curralternate ;add alternate hotkeys
		hotstringsDescriptions.Push({"keycombo":curralternate, "action":curraction})
	} else {
		guiKey := currKey
	}
	hotkeyDescriptions.Push({"Hotkey":guiKey, "Comment":currDescription})
	hotstringsDescriptions.Push({"keycombo":currKey, "action":curraction})
}

; Create blank listview GUI
Gui HelpMenu:Default
GuiTitle := "List of Hotkeys and Hotstrings"
Gui, Add, ListView,h330 w700, Hotkey/Hotstring|Comment
for Index, Element in hotkeyDescriptions ; add elements to GUI
    LV_Add("",Element.Hotkey, Element.Comment)
LV_ModifyCol()

;****************************************************************************************
; GUI Creation (Add hotstring menu)
;****************************************************************************************
GuiHotstringTitle := "Add new hotstring"
createhotstringGUI()
;****************************************************************************************
;CREATE HOTKEYS
;****************************************************************************************
; Create Signature text
Loop, parse, nameList, `n
{
	IniRead, currentUser,		 			names.ini, %A_LoopField%, username
	if InStr(currentUser,A_UserName)
	{	
		name := A_LoopField
		splitName := StrSplit(A_LoopField, [A_Space,"-"])
		FirstName := splitName[1]
		IniRead, EmailGreeting,		 		names.ini, %A_LoopField%, emailGreeting
		IniRead, EmailClosing,				names.ini, %A_LoopField%, emailClosing
		IniRead, position,		 			names.ini, %A_LoopField%, position
		IniRead, department,	 			names.ini, %A_LoopField%, department
	}

}
;Create Email Signatures
EmailSignature := EmailClosing ", `n" name "`n" position "`n" department
SimpleSignature := EmailClosing ", `n" name
CasualSignature := EmailClosing ", `n" FirstName

;Create Ticket template
TicketTemplate := "{GREETING} ,`n`nINSERT TEXT HERE `n`n{SIGNATURE}"

;Create Generic Ticket
GeneralTicket := EmailGreeting " ,`n`nINSERT TEXT HERE `n`n" EmailSignature

;Create Hotkeys
Hotkey, %MenuButtonMouse%, Showmenu
Hotkey, %MenuButtonKeyboard%, Showmenu
HotKey, %ReloadButton%, ReloadThisScript
Hotkey, %NewTemplateButton%, MakeNewTemplate
Hotkey, %EditTemplateButton%, Showeditmenu
Hotkey, %HelpButton%, Showhelpmenu
Hotkey, %FolderButton%, Showrootfolder
Hotkey, %SettingsButton%, Showsettingsmenu
Hotkey, %hotstringadderButton%, Showstringadder

;Create Hotstrings
for index,element in hotstringsDescriptions {
	key := ":*:" element.keycombo
	Hotstring(key, element.action)
}
;****************************************************************************************
;TEMPLATE MENU AND EDIT MENU
;****************************************************************************************
aboutsection =
(
Templates for replying to ServiceNow tickets
)

abouteditsection =
(
Menu for editing selected templates
)

aboutsettingssection =
(
Templates for replying to ServiceNow tickets
)
;Checks if network folder for template files exists
IfNotExist, %A_ScriptDir%\Templates\
	{
		msgbox, 16, Can't find template folder locally or on the netowrk. The program will be terminated.
		Goto, FileNotFound
	}
	
	else
		IfNotExist, %networkpath%
			{
				; MsgBox, 0,, Couldn't find folder in the network path. Local files will be used instead.
				curcofold = %A_ScriptDir%\Templates\
			}
		else
			{
				curcofold = %networkpath%\%templatecountry%\
			}
;Create Menu Names
editmenuName := menuName " Edits"
settingsmenuName := menuName " Settings"

;Creates the template menu and edit menu
Menu, MyMenu, Add, menuName, About ; Menutitle for the program
Menu, EditMenu, Add, editmenuName, AboutEdit ; Menutitle for the program
Menu, SettingsMenu, Add, settingsmenuName, AboutSettings ; Menutitle for the program

;Adds two separators after the menu title 
Menu, MyMenu, Add, 
Menu, EditMenu, Add,
Menu, SettingsMenu, Add,

;Create Settings Menu
Menu, SettingsMenu, Add, Settings, editsettings
Menu, SettingsMenu, Add, Names, editsettings
Menu, SettingsMenu, Add, Hotkeys, editsettings

I = 1 ;index for template menu
N = 1
k = 1
SetWorkingDir %curcofold% 

; Find files in folders
Loop, Files, %a_workingdir%\*.*, FD
{
   if A_LoopFileAttrib contains D 
   {
	Loop, Files, %a_workingdir%\%A_LoopFileName%\*.txt*,F
	{
		extension := InStr(A_LoopFileName, ".") ; finds position of first period, looks for the extension period
		subMenuName := SubStr(A_LoopFileName, 1, (extension - 1)) ; parses out the type
		Menu, Submenu%I%, Add, %subMenuName%, textfromfile ; Select file.
		Menu, Subeditmenu%I%, Add, %subMenuName%, edittemplate ; Select file.
	}
	Menu, MyMenu, Add, %A_LoopFileName%, :Submenu%I%
	Menu, EditMenu, Add, %A_LoopFileName%, :Subeditmenu%I%
	Report%A_Index% := A_LoopFileName
   } else if A_LoopFileExt containts TXT {
	extension := InStr(A_LoopFileName, ".") ; finds position of first period, looks for the extension period
	MenuName := SubStr(A_LoopFileName, 1, (extension - 1)) ; parses out the type
	TopLevelTemp%N% := MenuName
	N++
   }
   I++
 }
; Add top level files last
while (k < N)
{
	MenuName := TopLevelTemp%k%
	Menu, MyMenu, Add, %MenuName%, textfromfile ; Select file.
	Menu, EditMenu, Add, %MenuName%, edittemplate ; edit file
	k++
}

; Add new template option to LTSS Autotemplates
Menu, EditMenu, Add
Menu, EditMenu, Add, Create New Template, MakeNewTemplate
return

;***************************************************************************************
;FUNCTIONS and HOTSTRINGS
;***************************************************************************************
;Sends the text in the file the user has clicked on
textfromfile:
	Index := SubStr(A_ThisMenu, 8)
	templatefolder := Report%Index% 
	if (templatefolder = "") {
		templatefolder := curcofold
	}

	fileName := A_ThisMenuItem ".txt"
	FileRead, filecontent, % templatefolder "/" fileName ;reads the file according to the menu option that has been chosen
	filecontent := RegExReplace(filecontent, "m`a)(?=^;).*")  ;Removes comments before sending file
	filecontent := RegExReplace(filecontent,"^\s*","") ; remove the first

	;Replace signature and greeting and closing date of ticket if specified
	If InStr(filecontent, SIGNATURE)
		if InStr(DefaultSig, "emailSignature") {
			filecontent := StrReplace(filecontent, SIGNATURE, EmailSignature)
		} else if InStr(DefaultSig, "simpleSignature") {
			filecontent := StrReplace(filecontent, SIGNATURE, SimpleSignature)
		} else if InStr(DefaultSig, "casualSignature") {
			filecontent := StrReplace(filecontent, SIGNATURE, CasualSignature)
		} else {
			filecontent := StrReplace(filecontent, SIGNATURE, EmailSignature)
		}
	If InStr(filecontent, GREETING)
		filecontent := StrReplace(filecontent, GREETING, EmailGreeting)

	If InStr(filecontent, CLOSINGDATE)
		TicketClosingDate := weekdays(3) ;computes ticket closing date 3 business days later
		FormatTime, TimeString, %TicketClosingDate%, dddd MMMM d
		filecontent := StrReplace(filecontent, CLOSINGDATE, TimeString)

	Clipboard = %filecontent%
	Sleep, 100
	Send ^v 
	Sleep, 100
	Clipboard = %oldclipboard% ; restore clipboard 
return

; Create hotstring adder menu
createhotstringGUI() {
	Gui HotstringMenu:New
	Gui, add, Text,, Enter Name:
	Gui, Add, Edit, w400 vname
	Gui, add, Text,, Enter key combo:
	Gui, Add, Edit, w400 vkeycombo
	Gui, add, Text,, Enter replacement text:
	Gui, Add, Edit, w400 vaction
	Gui, add, Text,, Enter description:
	Gui, Add, Edit, w400 vdescription
	Gui, Add, Button, Default w80 gSubmit, OK
}

; Opens file that the user clicked on in the menu
edittemplate:
	Index := SubStr(A_ThisMenu, 12)
	templatefolder := Report%Index% 
	fileName := A_ThisMenuItem ".txt"
	if (templatefolder = "") {
		filepath := curcofold "\" fileName
	} else {
		filepath := curcofold templatefolder "\" fileName
	} 

	Run, notepad.exe %filepath% ;opens the selected file in notepad for editing
return

; Opens file that the user clicked on in the menu
editsettings:
	StringLower, menuLowerCase, A_ThisMenuItem
	fileName := menuLowerCase ".ini"
	filepath := A_ScriptDir "\" fileName
	Run, notepad.exe %filepath% ;opens the selected file in notepad for editing
return

; Copy and paste text
fastShortcut(text){
	oldclipboard := ClipboardAll ; copy clipboard to variable
	Clipboard = text
	Sleep, 100
	Send ^v 
	Sleep, 100
	Clipboard = %oldclipboard% ; restore clipboard 	
}

; Outputs a date x weekdays from the current date
weekDays(skip,date=""){
	; taken from https://www.autohotkey.com/boards/viewtopic.php?t=24445
    d:=(date)?date:A_Now
    t:=d,i:=0
    t+=1,D
    while % (Abs(skip)!=i) {
        FormatTime,r,%t%,WDay
        s.=r
        t+=1,D
        i:=(r=1||r=7)?i:i+1   
    }
    h:=StrLen(s),l:=SubStr(s,0)
    h:=(l="7")?h+2:(l="1")?h+1:         
    if (skip>0)  
        d+=h,D
    else 
        d+=-h,D
    return d
}

; Checks for errors and adds new hotstring to file
Submit:
	failed := False
	; Submit responses
	Gui, Submit, NoHide
	fields := Object("Name",name,"Key Combo",keycombo,"Replacement Text",action,"Description", description)
	for field,value in fields ; loop through the list
	{
		If !(value) {
			MsgBox Do not leave %field% field empty ; show error message
			failed := True
		} ; if the value of the variable whose name is saved in A_LoopField is empty
	}
	if !(failed) {
		; Delete menu and create a new one
		IniWrite, %keycombo%, %hotstringfile%, %name%, keycombo 
		IniWrite, %action%, %hotstringfile%, %name%, action 
		IniWrite, %description%, %hotstringfile%, %name%, Description 
		; Destroy UI once done
		Gui, hotstringMenu:Destroy

		; Create a new one
		createhotstringGUI()
	}
	Return

; Auto reload script if changes are detected
AutoReloadChanges(Folder, Changes) {
	; if (Changes.length > 0) {
	; 	; Reload
	; 	; Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
	; 	; MsgBox, 4,, The script could not be reloaded and will need to be manually restarted. Would you like Exit?
	; 	; IfMsgBox, Yes, ExitApp
	; 	MsgBox Change Detected
	; }
	For Each, Change In Changes {
		Reload
		Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
		MsgBox, 4,, The script could not be reloaded and will need to be manually restarted. Would you like Exit?
		IfMsgBox, Yes, ExitApp
	}
	Return
}

;Shows about the program message if you click on the menu title
About:
	msgbox	%aboutsection%
return

AboutEdit:
	msgbox	%abouteditsection%
return

AboutSettings:
	msgbox %aboutsettingssection%
return

;Define hotstrings for phrases
:*:whoami::
	SendInput, %A_UserName%
Return
:*:\emsig::
	oldclipboard := ClipboardAll ; copy clipboard to variable
	Clipboard = %EmailSignature%
	Sleep, 100
	Send ^v 
	Sleep, 100
	Clipboard = %oldclipboard% ; restore clipboard 	
Return
:*:\simsig::
	SendInput, %SimpleSignature%
Return
:*:\casusig::
	SendInput, %CasualSignature%
Return
:*:\temptick::
	oldclipboard := ClipboardAll ; copy clipboard to variable
	Clipboard = %TicketTemplate%
	Sleep, 100
	Send ^v 
	Sleep, 100
	Clipboard = %oldclipboard% ; restore clipboard 	
Return
:*:\gentick::
	oldclipboard := ClipboardAll ; copy clipboard to variable
	Clipboard = %GeneralTicket%
	Sleep, 100
	Send ^v 
	Sleep, 100
	Clipboard = %oldclipboard% ; restore clipboard 	
Return

:*:\greet::Thank you for contacting Teaching and Learning Services.

; Define hotstring for abbreviations
:*:\ltss::Learning Technology Support Specialist
:*:\ltc::Learning Technology Consultant
:*:\lta::Learning Technology Analyst
:*:\ltcs::Learning Technology Consultants
:*:\ltas::Learning Technology Analysts
:*:\tls::Teaching and Learning Services
:*:\tlkb::Teaching and Learning Knowledge Base
:*:\tlblog::Teaching for Learning Blog
return

; Taken from https://www.autohotkey.com/board/topic/55105-reload-this-script-option-for-compiled-autohotke/
; Reloads the script
ReloadThisScript:
	Reload
	Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
	MsgBox, 4,, The script could not be reloaded and will need to be manually restarted. Would you like Exit?
	IfMsgBox, Yes, ExitApp
return

; Opens notepad and pastes a blank template
MakeNewTemplate:
	Run notepad
	WinWaitActive, Untitled - Notepad,, 2
	oldclipboard := ClipboardAll ; copy clipboard to variable
	Clipboard = %TicketTemplate%
	Sleep, 100
	Send ^v 
	Sleep, 100
	Clipboard = %oldclipboard% ; restore clipboard 	
return

;Shows the menu after pressing set hotkey
Showmenu:
	oldclipboard := ClipboardAll ; copy clipboard to variable
	Clipboard =
	Menu, MyMenu, Show ; Show menu
return

;Shows the template menu for editing a template
Showeditmenu:
	Menu, EditMenu, Show ; Show menu
return

; Shows the hotkeys and hotstrings in the script
Showhelpmenu:
	Gui, HelpMenu:Show, xCenter yCenter, %GuiTitle%
return

; Shows the hotstring adder menu
Showstringadder:
	Gui, hotstringMenu:Show, xCenter yCenter, %GuiHotstringTitle%
return

; Opens settings menu to change settings
Showsettingsmenu:
	Menu, SettingsMenu, Show ;show menu
return

; Opens the root folder with the settings and templates
Showrootfolder:
	Run, explorer.exe %A_ScriptDir%
return

MenuHandler:
return

FileNotFound:
ExitApp