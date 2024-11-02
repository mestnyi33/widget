EnableExplicit

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
  Global Workspace.i = CocoaMessage(0, 0, "NSWorkspace sharedWorkspace")
  #MB_ICONINFORMATION = $40      
  #MB_ICONWARNING     = $30
  #MB_ICONERROR       = $10
  
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux  
  #MB_ICONINFORMATION = #GTK_MESSAGE_INFO      
  #MB_ICONWARNING     = #GTK_MESSAGE_WARNING
  #MB_ICONERROR       = #GTK_MESSAGE_ERROR
CompilerEndIf


Procedure.i ToAscii(inbuf$)  ;required for Linux unicode-compiled version
  Protected *outbuf = AllocateMemory(Len(inbuf$)+1)
  If *outbuf
    PokeS(*outbuf, inbuf$, -1, #PB_Ascii)   ;perhaps this should be #PB_Utf8 seeing as thats what the Linux one wants
  EndIf
  ProcedureReturn *outbuf
EndProcedure


Procedure MsgAlert (hWnd.i, Title.s, Message.s, MB_ICON.i)   ;Supports #MB_ICONINFORMATION, #MB_ICONERROR, #MB_ICONWARNING
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    MessageBox_(hWnd, Message, Title, #MB_OK + MB_ICON)
    
  CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS    ;based on example by wilbert
    Protected Type.s, Alert.i = CocoaMessage(0, CocoaMessage(0, 0, "NSAlert new"), "autorelease")
    Select MB_ICON
      Case #MB_ICONWARNING: Type.s = "'caut'"
      Case #MB_ICONERROR: Type.s = "'stop'"
      Default: Type.s = "'note'"
    EndSelect
    CocoaMessage(0, CocoaMessage(0, Alert, "window"), "setParentWindow:", hWnd)
    CocoaMessage(0, Alert, "setMessageText:$", @Title)
    CocoaMessage(0, Alert, "setInformativeText:$", @Message)
    CocoaMessage(0, Alert, "setIcon:", CocoaMessage(0, Workspace, "iconForFileType:$", @Type))
    CocoaMessage(0, Alert, "runModal")

  CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux    ;based on example by Frarth & Guimauve
    Protected *dlgmsgbox.GtkMessageDialog, result.i, Sub1.i, Sub2.i, pMsg.i, pTitle.i
    pMsg = ToAscii(Message):  pTitle = ToAscii(Title)
    *dlgmsgbox = gtk_message_dialog_new_(hWnd, #True, MB_ICON, #GTK_BUTTONS_OK, pMsg, Sub1, Sub2)
    gtk_window_set_title_(*dlgmsgbox, pTitle)   
    result = gtk_dialog_run_(*dlgmsgbox)
    gtk_widget_destroy_(*dlgmsgbox)   
    
  CompilerEndIf
  
EndProcedure



CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  gtk_init_(0,0)
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
  InitCommonControls_()
CompilerEndIf  


Define hWnd.i = 0  ;#HWND_DESKTOP
MsgAlert(hWnd, "My INFO!", "My message line 1" + Chr($D) + Chr($A) + "Line 2", #MB_ICONINFORMATION)  ;$0A, $0D, and $0D0A all work fine on all 3 OS for messageboxes in my tests
MsgAlert(hWnd, "My ERROR!", "My message line 1" + Chr($D) + "Line 2", #MB_ICONERROR)
MsgAlert(hWnd, "My WARNING!", "My message line 1" + Chr($A) + "Line 2", #MB_ICONWARNING)
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP