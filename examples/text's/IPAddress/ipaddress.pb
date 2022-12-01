;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../widget-events.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib( widget )
  
  Global *S_0
  Global *S_1
  Global *S_2
  
  Macro  SetState(widget, State)
    SetText(widget,
            Str(IPAddressField(State,0))+"."+
            Str(IPAddressField(State,1))+"."+
            Str(IPAddressField(State,2))+"."+
            Str(IPAddressField(State,3)))
  EndMacro
  
  Macro IPAddress( x,y,width,height, flag=0 )
    String( x,y,width,height, "", #__text_numeric);|flag )
    widget( )\fs = 1
    Resize( widget( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
    ;widget( )\type = #__type_IPAddress
  EndMacro
  
  If Open(0, 0, 0, 615, 235, "IPAddressGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ;\\
    IPAddressGadget(0, 8,  10, 290, 20)
    IPAddressGadget(1, 8,  35, 290, 20)
    IPAddressGadget(2, 8,  60, 290, 20)
    
    SetGadgetState(0, MakeIPAddress(127, 0, 30, 1))   ; set a valid ip address
    SetGadgetState(1, MakeIPAddress(127, 190, 0, 1))   ; set a valid ip address
    SetGadgetState(2, MakeIPAddress(127, 0, 0, 1))   ; set a valid ip address
    
    Debug GetGadgetState(0)
    
    ;\\
    IPAddress(18+290,  10, 290, 20)
    IPAddress(18+290,  35, 290, 20, #__text_Center)
    IPAddress(18+290,  60, 290, 20, #__text_Right)
    
    SetState(GetWidget(0), MakeIPAddress(127, 0, 30, 1))   ; set a valid ip address
    SetState(GetWidget(1), MakeIPAddress(127, 190, 0, 1))   ; set a valid ip address
    SetState(GetWidget(2), MakeIPAddress(127, 0, 0, 1))   ; set a valid ip address
    
    Debug GetState(GetWidget(0))
    
    ;\\
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
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = v-
; EnableXP