;*******************************************
;*
;*   Filename:    IDE_Tool_Helper.pbi
;*   Version:     V1.0
;*   Date:        06.04.2015
;*   Author:      HeX0R
;*                http://hex0rs.coderbu.de
;*
;*   License:     MIT
;*                http://opensource.org/licenses/mit-license.php
;*
;*   OS:          [x] Windows
;*                [x] Linux
;*                [?] MacOS (untested)
;*
;*   Description: can be used to add
;*                Installation functionality
;*                to your PB IDE Tools.
;*
;*
;*******************************************

DeclareModule IDETOOL
	Enumeration
		#TRIGGER_SHORTCUT
		#TRIGGER_EDITOR_START
		#TRIGGER_EDITOR_END
		#TRIGGER_BEFORE_COMPILING
		#TRIGGER_AFTER_COMPILING
		#TRIGGER_START_COMPILED_PROGRAM
		#TRIGGER_BEFORE_EXE_CREATION
		#TRIGGER_AFTER_EXE_CREATION
		#TRIGGER_SOURCE_LOADED
		#TRIGGER_SOURCE_SAVED
		#TRIGGER_REPLACE_FILEVIEWER_SHOW_ALL
		#TRIGGER_REPLACE_FILEVIEWER_UNKNOWN_FILE
		#TRIGGER_REPLACE_FILEVIEWER_SPECIAL_FILES
		#TRIGGER_SOURCE_CLOSED
		#TRIGGER_NEW_SOURCE_CREATED
	EndEnumeration
	
	Enumeration
		#ERROR_NONE
		#ERROR_USER_ABORTED
		#ERROR_CANT_OPEN_TOOL_PREFERENCES
		#ERROR_TOOL_ALREADY_INSTALLED
	EndEnumeration
	
	Enumeration
		#RELOAD_SOURCE_NO
		#RELOAD_SOURCE_IN_NEW_FILE
		#RELOAD_SOURCE_IN_CURRENT_FILE
	EndEnumeration
	
	#FLAG_NONE           = $0000
	#FLAG_WAIT_FOR_TOOL  = $0001
	#FLAG_START_HIDDEN   = $0002
	
		
	Declare GetLastError()
	Declare Install(ToolName.s, Arguments.s, WorkingDir.s, iTrigger, iFlags, iReloadSource, bHideEditor, bUseShortcut, bHideFromMenu, bUpdateTool = #False, iDefaultShortcut = 0, bSourceSpecific = 0, bDeactivate = 0, ConfigLine.s = "")
	Declare Uninstall(ToolName.s)
	Declare RenameTool(ToolName.s, NewToolName.s)
	Declare FindTool(ToolName.s)
	
EndDeclareModule

Module IDETOOL
	EnableExplicit
	
	Global LastError = #ERROR_NONE
	Global ToolPrefs.s
	
	Macro CheckForToolsPrefs
		If FileSize(Result + "tools.prefs") = -1
			SetGadgetText(Text, "There is no tools.prefs (yet). A new file will be created in this folder.")
		Else
			SetGadgetText(Text, "There is a tools.prefs in this folder. We will add our tool here.")
		EndIf
		StatusBarText(StatusBar, 0, Result)
	EndMacro
	
	Procedure.s GetDefaultToolFolder()
		Protected Result.s
		
		CompilerIf #PB_Compiler_OS = #PB_OS_Windows
			Result = GetEnvironmentVariable("APPDATA") + "\PureBasic\"
		CompilerElse
			Result = GetEnvironmentVariable("HOME") + "/.purebasic/"
		CompilerEndIf
		
		ProcedureReturn Result
	EndProcedure
	
	Procedure.s OpenToolPathRequester(InitialPath.s)
		Protected Win, PathGadget, FileGadget, ApplyButton, Text, Result.s, StatusBar

		Win         = OpenWindow(#PB_Any, 0, 0, 500, 360, "Select Path to tools.prefs", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
		PathGadget  = ExplorerTreeGadget(#PB_Any, 5, 5, 240, 250, InitialPath, #PB_Explorer_NoFiles | #PB_Explorer_NoDriveRequester | #PB_Explorer_AlwaysShowSelection | #PB_Explorer_HiddenFiles)
		FileGadget  = ExplorerListGadget(#PB_Any, 250, 5, 240, 250, InitialPath, #PB_Explorer_NoFolders | #PB_Explorer_NoParentFolder)
		Text        = TextGadget(#PB_Any, 5, 260, 490, 30, "")
		ApplyButton = ButtonGadget(#PB_Any, 200, 300, 100, 26, "Apply", #PB_Button_Default)
		Result      = InitialPath
		StatusBar   = CreateStatusBar(#PB_Any, WindowID(Win))
		AddStatusBarField(#PB_Ignore)
		SetActiveGadget(PathGadget)
		CheckForToolsPrefs
	
		Repeat
			Select WaitWindowEvent()
				Case #PB_Event_CloseWindow
					Result = ""
					Break
				Case #PB_Event_Gadget
					Select EventGadget()
						Case PathGadget
							Result = GetGadgetText(PathGadget)
							SetGadgetText(FileGadget, Result)
							CheckForToolsPrefs
						Case ApplyButton
							Break
					EndSelect
			EndSelect
		ForEver

		CloseWindow(Win)
	
		ProcedureReturn Result
	EndProcedure
	
	Procedure OpenShortcutRequester(Shortcut, FirstRun)
		Protected Win, Text, Title.s, GadgetShortcut, ButtonApply, Result
		Protected w, h
		
		If FirstRun
			Title = "Select Shortcut:"
		Else
			Title = "Shortcut in use!"
		EndIf
		
		Win            = OpenWindow(#PB_Any, 0, 0, 300, 160, Title, #PB_Window_Tool | #PB_Window_ScreenCentered | #PB_Window_SystemMenu | #PB_Window_Invisible)
		Text           = TextGadget(#PB_Any, 5, 5, 290, 40, "Please select another shortcut for this tool:")
		GadgetShortcut = ShortcutGadget(#PB_Any, 80, 50, 160, 25, Shortcut)
		ButtonApply    = ButtonGadget(#PB_Any, 80, 80, 80, 25, "Apply", #PB_Button_Default)
		
		ResizeGadget(Text, #PB_Ignore, #PB_Ignore, GadgetWidth(Text, #PB_Gadget_RequiredSize), GadgetHeight(Text, #PB_Gadget_RequiredSize))
		ResizeGadget(GadgetShortcut, (GadgetWidth(Text) + 10) / 2 - 80, GadgetHeight(Text) + 10, #PB_Ignore, #PB_Ignore)
		ResizeGadget(ButtonApply, (GadgetWidth(Text) + 10) / 2 - 40, GadgetY(GadgetShortcut) + 30, #PB_Ignore, #PB_Ignore)
		ResizeWindow(Win, #PB_Ignore, #PB_Ignore, GadgetWidth(Text) + 10, GadgetY(ButtonApply) + 30)
		SetActiveGadget(GadgetShortcut)
		HideWindow(Win, 0)
		
		Repeat
			Select WaitWindowEvent()
				Case #PB_Event_CloseWindow
					Break
				Case #PB_Event_Gadget
					If EventGadget() = ButtonApply
						Result = GetGadgetState(GadgetShortcut)
						Break
					EndIf
			EndSelect
		ForEver
		
		CloseWindow(Win)
		ProcedureReturn Result
	EndProcedure
	
	Procedure GetLastError()
		ProcedureReturn LastError
	EndProcedure
	;-{Install Procedure}
	
	Procedure Install(ToolName.s, Arguments.s, WorkingDir.s, iTrigger, iFlags, iReloadSource, bHideEditor, bUseShortcut, bHideFromMenu, bUpdateTool = #False, iDefaultShortcut = 0, bSourceSpecific = 0, bDeactivate = 0, ConfigLine.s = "")
		Protected a$, i, ToolCount, ShortcutCount, GoOn, Result, ToolAlreadyInstalled, PreviousShortcut, ToolPos, FirstRun, PrefCreated
		
		;Install your tool quite easy
		;Parameters:
		;ToolName         = Name of your tool (must be unique)
		;Arguments        = Arguments for the tool, e.g. #CRLF$ + "%TEMPFILE" + #CRLF$
		;WorkingDir       = This will be the current directory for the tool (if needed)
		;iTrigger         = see above the #TRIGGER_ constants
		;iFlags           = see above the #FLAG_ constants
		;iReloadSource    = see above the #RELOAD_SOURCE_ constants
		;bHideEditor      = if true, Editor will be hidden while tool is running
		;bUseShortcut     = if true, this tool will use a shortcut (see also DefaultShortcut)
		;bHideFromMenu    = if true, the tool will not be shown in the IDE-list
		;bUpdateTool      = if true, the tool will be installed even if it has been installed already (will update/refresh the parameters then)
		;iDefaultShortcut = if UseShortcut = #True, you can select a default shortcut here (use #PB_Shortcut_ constants). If this shortcut is already used, a requester will pop up.
		;bSourceSpecific  = if true, this tool will be activated in the compiler options. Advantage is, that you can activate this tool only for some special source codes.
		;bDeactivate      = if true this tool is deactivated
		;ConfigLine       = if Trigger = #TRIGGER_REPLACE_FILEVIEWER_SPECIAL_FILES, this line will contain the file-extensions to handle (separated by commas).

		Dim Shortcuts.i(512) ;<- will save all existing PB shortcuts
		LastError = #ERROR_NONE
		If ToolPrefs = ""
			;this is the first call, we have no idea where the tools.prefs is
			;open a requester for the user to select the path
			ToolPrefs = OpenToolPathRequester(GetDefaultToolFolder())
			If ToolPrefs
				ToolPrefs + "tools.prefs"
			EndIf
		EndIf
		If ToolPrefs = ""
			LastError = #ERROR_USER_ABORTED ;<- user decided not to install it, lets jump out
			ProcedureReturn 0
		EndIf
		If OpenPreferences(ToolPrefs) = 0
			If CreatePreferences(ToolPrefs) = 0
				LastError = #ERROR_CANT_OPEN_TOOL_PREFERENCES
				ProcedureReturn 0
			Else
				;new tools.prefs, add the default comments to the top
				PreferenceComment("  PureBasic IDE ToolsMenu Configuration")
				PreferenceComment("")
				PrefCreated = #True
			EndIf
		EndIf

		;Start Installing.
		PreferenceGroup("ToolsInfo")
		ToolCount            = ReadPreferenceInteger("ToolCount", 0)
		ToolAlreadyInstalled = #False
		If PrefCreated
			;make sure the new created tools.prefs has the same comment-structure
			WritePreferenceInteger("ToolCount", 0)
			PreferenceComment("")
			PreferenceComment("")
		EndIf
		;first check if this tool maybe already exists
		For i = 1 To ToolCount
			PreferenceGroup("Tool_" + Str(i - 1))
			;we also save all used shortcuts, to make sure not to select one already in use.
			Shortcuts(i) = ReadPreferenceInteger("Shortcut", 0)
			If ReadPreferenceString("MenuItemName", "") = ToolName
				;this tool is already here
				ToolAlreadyInstalled = #True
				If bUpdateTool
					ToolPos          = i
					PreviousShortcut = Shortcuts(i)
					Shortcuts(i)     = 0
				EndIf
			EndIf
		Next i
		If ToolAlreadyInstalled = #False Or bUpdateTool
			;lets install (or update) it
			If bUseShortcut
				;go for shortcut selection
				If iDefaultShortcut = 0
					If bUpdateTool And PreviousShortcut
						iDefaultShortcut = PreviousShortcut
					Else
						iDefaultShortcut = #PB_Shortcut_Shift | #PB_Shortcut_F1
					EndIf
				EndIf
				;o.k. now we need to read all shortcuts from the PB IDE
				ClosePreferences()
				ShortcutCount = ToolCount
				If OpenPreferences(GetPathPart(ToolPrefs) + "PureBasic.prefs")
					PreferenceGroup("Shortcuts")
					If ExaminePreferenceKeys()
						While NextPreferenceKey()
							ShortcutCount + 1
							Shortcuts(ShortcutCount) = Val(PreferenceKeyValue())
						Wend
					EndIf
					ClosePreferences()
				EndIf
				OpenPreferences(ToolPrefs)
				GoOn     = #True
				FirstRun = #True
				While GoOn
					GoOn = #False
					For i = 1 To ShortcutCount
						If Shortcuts(i) = iDefaultShortcut
							GoOn = #True
							Break
						EndIf
					Next i
					If GoOn
						;o.k. this shortcut is already used.
						;open select window requester for user
						iDefaultShortcut = OpenShortcutRequester(iDefaultShortcut, FirstRun)
						FirstRun        = #False
						If iDefaultShortcut = 0
							;canceled
							LastError = #ERROR_USER_ABORTED
							ClosePreferences()
							ProcedureReturn 0
						EndIf
					EndIf
				Wend
			EndIf
			If bUpdateTool
				ToolCount = ToolPos - 1
			EndIf
			;let's save it!
			PreferenceGroup("Tool_" + Str(ToolCount))
			WritePreferenceString("Command",         ProgramFilename())
			WritePreferenceString("Arguments",       Arguments)
			WritePreferenceString("WorkingDir",      WorkingDir)
			WritePreferenceString("MenuItemName",    ToolName)
			WritePreferenceInteger("Shortcut",       iDefaultShortcut)
			WritePreferenceString("ConfigLine",      ConfigLine) ;<-used, when trigger = #TRIGGER_REPLACE_FILEVIEWER_SPECIAL_FILES
			WritePreferenceInteger("Trigger",        iTrigger)
			WritePreferenceInteger("Flags",          iFlags)
			WritePreferenceInteger("ReloadSource",   iReloadSource)
			WritePreferenceInteger("HideEditor",     bHideEditor)
			WritePreferenceInteger("HideFromMenu",   bHideFromMenu)
			WritePreferenceInteger("SourceSpecific", bSourceSpecific)
			WritePreferenceInteger("Deactivate",     bDeactivate)
			PreferenceComment("")
			PreferenceComment("")
			If bUpdateTool = #False
				PreferenceGroup("ToolsInfo")
				WritePreferenceInteger("ToolCount", ToolCount + 1)
			EndIf
			Result = #True
		Else
			LastError = #ERROR_TOOL_ALREADY_INSTALLED
		EndIf
		ClosePreferences()
		
		ProcedureReturn Result
	EndProcedure
	
	Procedure RenameTool(ToolName.s, NewToolName.s)
		Protected ToolCount, i, Result
		
		If ToolPrefs = ""
			;this is the first call, we have no idea where the tools.prefs is
			;open a requester for the user to select the path
			ToolPrefs = OpenToolPathRequester(GetDefaultToolFolder())
			If ToolPrefs
				ToolPrefs + "tools.prefs"
			EndIf
		EndIf
		If ToolPrefs = ""
			LastError = #ERROR_USER_ABORTED ;<- user decided not to install it, lets jump out
			ProcedureReturn 0
		EndIf
		If OpenPreferences(ToolPrefs)
			PreferenceGroup("ToolsInfo")
			ToolCount = ReadPreferenceInteger("ToolCount", 0)
			For i = 1 To ToolCount - 1
				PreferenceGroup("Tool_" + Str(i - 1))
				If ReadPreferenceString("MenuItemName", "") = ToolName
					WritePreferenceString("MenuItemName", NewToolName)
					Result = #True
					Break
				EndIf
			Next i
			ClosePreferences()
		EndIf
		
		ProcedureReturn Result
		
	EndProcedure
	
	Procedure FindTool(ToolName.s)
		Protected ToolCount, i, Result

		If ToolPrefs = ""
			;this is the first call, we have no idea where the tools.prefs is
			;open a requester for the user to select the path
			ToolPrefs = OpenToolPathRequester(GetDefaultToolFolder())
			If ToolPrefs
				ToolPrefs + "tools.prefs"
			EndIf
		EndIf
		If ToolPrefs = ""
			LastError = #ERROR_USER_ABORTED ;<- user decided not to install it, lets jump out
			ProcedureReturn 0
		EndIf
		If OpenPreferences(ToolPrefs)
			PreferenceGroup("ToolsInfo")
			ToolCount = ReadPreferenceInteger("ToolCount", 0)
			For i = 1 To ToolCount - 1
				PreferenceGroup("Tool_" + Str(i - 1))
				If ReadPreferenceString("MenuItemName", "") = ToolName
					Result = i
					Break
				EndIf
			Next i
			ClosePreferences()
		EndIf
		
		ProcedureReturn Result
		
	EndProcedure
	
	Procedure Uninstall(ToolName.s)
		Protected ToolCount, i, ToolFound, Result
		Protected Command.s, Arguments.s, WorkingDir.s, Shortcut.i, ConfigLine.s, Trigger.i, Flags.i, ReloadSource.i, HideEditor.i, HideFromMenu.i, SourceSpecific.i, Deactivate.i
		
		
		ToolPrefs = GetDefaultToolFolder() + "tools.prefs"
		If OpenPreferences(ToolPrefs)
			PreferenceGroup("ToolsInfo")
			ToolCount = ReadPreferenceInteger("ToolCount", 0)
			For i = 1 To ToolCount - 1
				PreferenceGroup("Tool_" + Str(i - 1))
				If ReadPreferenceString("MenuItemName", "") = ToolName
					ToolFound = i
					Break
				EndIf
			Next i
			If ToolFound = -1
				ClosePreferences()
				ProcedureReturn 0
			EndIf
			For i = ToolCount - 1 To ToolFound + 1 Step -1
				;save data
				PreferenceGroup("Tool_" + Str(i))
				Command        = ReadPreferenceString("Command", "")
				Arguments      = ReadPreferenceString("Arguments", "")
				WorkingDir     = ReadPreferenceString("WorkingDir", "")
				ToolName       = ReadPreferenceString("MenuItemName", "")
				Shortcut       = ReadPreferenceInteger("Shortcut", 0)
				ConfigLine     = ReadPreferenceString("ConfigLine", "")
				Trigger        = ReadPreferenceInteger("Trigger", 0)
				Flags          = ReadPreferenceInteger("Flags", 0)
				ReloadSource   = ReadPreferenceInteger("ReloadSource", 0)
				HideEditor     = ReadPreferenceInteger("HideEditor", 0)
				HideFromMenu   = ReadPreferenceInteger("HideFromMenu", 0)
				SourceSpecific = ReadPreferenceInteger("SourceSpecific", 0)
				Deactivate     = ReadPreferenceInteger("Deactivate", 0)
				
				PreferenceGroup("Tool_" + Str(i - 1))
				WritePreferenceString("Command",         Command)
				WritePreferenceString("Arguments",       Arguments)
				WritePreferenceString("WorkingDir",      WorkingDir)
				WritePreferenceString("MenuItemName",    ToolName)
				WritePreferenceInteger("Shortcut",       Shortcut)
				WritePreferenceString("ConfigLine",      ConfigLine)
				WritePreferenceInteger("Trigger",        Trigger)
				WritePreferenceInteger("Flags",          Flags)
				WritePreferenceInteger("ReloadSource",   ReloadSource)
				WritePreferenceInteger("HideEditor",     HideEditor)
				WritePreferenceInteger("HideFromMenu",   HideFromMenu)
				WritePreferenceInteger("SourceSpecific", SourceSpecific)
				WritePreferenceInteger("Deactivate",     Deactivate)
				
			Next i
			;remove last tool
			RemovePreferenceGroup("Tool_" + Str(ToolCount - 1))
			PreferenceGroup("ToolsInfo")
			WritePreferenceInteger("ToolCount", ToolCount - 1)
			Result = #True
			
			ClosePreferences()
		EndIf
		
		ProcedureReturn Result
	EndProcedure

	
EndModule

CompilerIf #PB_Compiler_IsMainFile
	
	Procedure main()
		Protected a$
		
		a$ = ProgramParameter()
		If a$ <> "BLA"
			;install me
			If IDETOOL::Install("MyTest0815", #DQUOTE$ + "%FILE" + #DQUOTE$, "", IDETOOL::#TRIGGER_SHORTCUT, IDETOOL::#FLAG_WAIT_FOR_TOOL, IDETOOL::#RELOAD_SOURCE_NO, 0, #True, 0, 0, #PB_Shortcut_F1 | #PB_Shortcut_Shift)
				MessageRequester("Success!", "Successfully installed tool 'MyTest0815'!" + #LF$ + 
				                             "If your IDE is open, please restart it." + #LF$ + 
				                             "Remember: If you compile this temporarily the exe will probably be no longer there, after restarting the IDE!")
			EndIf
		Else
			MessageRequester("Info", "Test-Tool online...")
		EndIf
	EndProcedure
	
	main()
	
CompilerEndIf
