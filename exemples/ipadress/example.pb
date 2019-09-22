IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule Widget
  
  Global *S_0.Widget_S = AllocateStructure(Widget_S)
  Global *S_1.Widget_S = AllocateStructure(Widget_S)
  Global *S_2.Widget_S = AllocateStructure(Widget_S)
  
  Procedure Events()
    Debug ""+EventGadget()+" "+EventType()
  EndProcedure
  
  If OpenWindow(0, 0, 0, 615, 235, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    IPAddressGadget(0, 8,  10, 290, 20)
    IPAddressGadget(1, 8,  35, 290, 20)
    IPAddressGadget(2, 8,  60, 290, 20)
    
    SetGadgetState(0, MakeIPAddress(127, 0, 30, 1))   ; set a valid ip address
    SetGadgetState(1, MakeIPAddress(127, 190, 0, 1))   ; set a valid ip address
    SetGadgetState(2, MakeIPAddress(127, 0, 0, 1))   ; set a valid ip address
    Debug "gadget make IP address "+GetGadgetState(0)
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      CocoaMessage(0,GadgetID(0),"setAlignment:", 0)
      CocoaMessage(0,GadgetID(2),"setAlignment:", 1)
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      If OSVersion() > #PB_OS_Windows_XP
        SetWindowLongPtr_(GadgetID(0), #GWL_STYLE, GetWindowLong_(GadgetID(0), #GWL_STYLE) & $FFFFFFFC | #SS_LEFT)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLongPtr_(GadgetID(2), #GWL_STYLE) & $FFFFFFFC | #ES_RIGHT) 
      Else
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_RIGHT)
      EndIf
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      ImportC ""
        gtk_entry_set_alignment(Entry.i, XAlign.f)
      EndImport
      gtk_entry_set_alignment(GadgetID(0), 0)
      gtk_entry_set_alignment(GadgetID(2), 1)
    CompilerEndIf
    
    ; Demo draw IPAddress on the canvas
    Open(0,  305, 0, 310, 235)
    
    *S_0 = IPAddress(8,  10, 290, 20)
    *S_1 = IPAddress(8,  35, 290, 20)
    *S_2 = IPAddress(8,  60, 290, 20)
    
    SetState(*S_0, MakeIPAddress(127, 0, 30, 1))
    SetState(*S_1, MakeIPAddress(127, 190, 0, 1))
    SetState(*S_2, MakeIPAddress(127, 0, 0, 1))
    
    Debug "widget make IP address "+GetState(*S_0)
    
    ; Bind(@Events())
    ReDraw(Root())
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP