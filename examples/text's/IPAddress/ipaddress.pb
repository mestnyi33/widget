XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global *S_0
  Global *S_1
  Global *S_2
  
  
  If Open(0, 0, 0, 615, 235, "IPAddressGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ;\\
    IPAddressGadget(0, 8,  10, 290, 40)
    IPAddressGadget(1, 8,  55, 290, 40)
    IPAddressGadget(2, 8,  100, 290, 40)
    
    ;\\
    CompilerSelect #PB_Compiler_OS 
       CompilerCase #PB_OS_MacOS 
          CocoaMessage(0,GadgetID(0),"setAlignment:", 0)
          CocoaMessage(0,GadgetID(2),"setAlignment:", 1)
          
       CompilerCase #PB_OS_Windows
          If OSVersion() > #PB_OS_Windows_XP
             SetWindowLongPtr_(GadgetID(0), #GWL_STYLE, GetWindowLong_(GadgetID(0), #GWL_STYLE) & $FFFFFFFC | #SS_LEFT)
             SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLongPtr_(GadgetID(2), #GWL_STYLE) & $FFFFFFFC | #ES_RIGHT) 
          Else
             SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTER)
             SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_RIGHT)
          EndIf
          
       CompilerCase #PB_OS_Linux
          ImportC ""
             gtk_entry_set_alignment(Entry.i, XAlign.f)
          EndImport
          gtk_entry_set_alignment(GadgetID(0), 0)
          gtk_entry_set_alignment(GadgetID(2), 1)
          
    CompilerEndSelect
    
    ;\\
    SetGadgetState(0, MakeIPAddress(127, 0, 30, 1))   ; set a valid ip address
    SetGadgetState(1, MakeIPAddress(127, 190, 0, 1))   ; set a valid ip address
    SetGadgetState(2, MakeIPAddress(127, 0, 0, 1))   ; set a valid ip address
    
    Debug GetGadgetState(0)
    
    ;\\
    IPAddress(18+290,  10, 290, 40)
    IPAddress(18+290,  55, 290, 40, #__text_Center)
    IPAddress(18+290,  100, 290, 40, #__text_Right)
    
    ;\\
    SetState(ID(0), MakeIPAddress(127, 0, 30, 1))   ; set a valid ip address
    SetState(ID(1), MakeIPAddress(127, 190, 0, 1))   ; set a valid ip address
    SetState(ID(2), MakeIPAddress(127, 0, 0, 1))   ; set a valid ip address
    
    Debug GetState(ID(0))
    
     Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 50
; FirstLine = 33
; Folding = 8
; EnableXP
; DPIAware