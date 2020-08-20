IncludePath "../../" : XIncludeFile "widgets.pbi"
; XIncludeFile "../empty5.pb"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseLib(widget)
  EnableExplicit
  
  UsePNGImageDecoder()
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Procedure events_gadgets()
    Protected String.s
    
    Select EventType()
      Case #PB_EventType_Focus
        String.s = "focus "+EventGadget()+" "+EventType()
      Case #PB_EventType_LostFocus
        String.s = "lostfocus "+EventGadget()+" "+EventType()
      Case #PB_EventType_Change
        String.s = "change "+EventGadget()+" "+EventType()
    EndSelect
    
    If EventType() = #PB_EventType_Focus
      Debug String.s +" - gadget" +" get text - "+ GetGadgetText(EventGadget()) ; Bug in mac os
    Else
      Debug String.s +" - gadget"
    EndIf
  EndProcedure
  
  Procedure events_widgets()
    Protected String.s
    
    Select this()\event
      Case #PB_EventType_Focus
        String.s = "focus "+Str(this()\widget\index-1)+" "+this()\event
      Case #PB_EventType_LostFocus
        String.s = "lostfocus "+Str(this()\widget\index-1)+" "+this()\event
      Case #PB_EventType_Change
        String.s = "change "+Str(this()\widget\index-1)+" "+this()\event
    EndSelect
    
    If this()\event = #PB_EventType_Focus
      Debug String.s +" - widget" +" get text - "+ GetText(this()\widget)
    Else
      Debug String.s +" - widget"
    EndIf
    
  EndProcedure
  
  ; Alignment text
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    ImportC ""
      gtk_entry_set_alignment(Entry.i, Xalign.f)
      gtk_label_set_yalign(*Label.GtkLabel, Yalign.F)
  EndImport
CompilerEndIf
  
  Procedure SetTextAlignment()
    ; Alignment text
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      CocoaMessage(0,GadgetID(1),"setAlignment:", 2)
      CocoaMessage(0,GadgetID(2),"setAlignment:", 1)
      
      CocoaMessage(0, CocoaMessage(0, GadgetID(8), "cell"), "_setVerticallyCentered:", #True)
      CocoaMessage(0, GadgetID(8), "setNeedsDisplay:", #True)
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      
      If OSVersion() > #PB_OS_Windows_XP
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE) & $FFFFFFFC | #SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLongPtr_(GadgetID(2), #GWL_STYLE) & $FFFFFFFC | #ES_RIGHT) 
      Else
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_RIGHT)
      EndIf
      
      SetWindowLongPtr_(GadgetID(8), #GWL_STYLE, GetWindowLong_(GadgetID(8), #GWL_STYLE)|#SS_CENTERIMAGE)
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      ;       ImportC ""
      ;         gtk_entry_set_alignment(Entry.i, XAlign.f)
      ;       EndImport
      
      gtk_label_set_yalign(GadgetID(8), 0.5)
        
      gtk_entry_set_alignment(GadgetID(1), 0.5)
      gtk_entry_set_alignment(GadgetID(2), 1)
    CompilerEndIf
  EndProcedure
  
  Define height=60, Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget H"
  
  If Open(OpenWindow(#PB_Any, 0, 0, 615, (height+5)*8+20+90, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    StringGadget(0, 8, 10, 290, height, "Read-only StringGadget...", #PB_String_ReadOnly)
    StringGadget(1, 8, (height+5)*1+10, 290, height, "1234567", #PB_String_Numeric)
    StringGadget(2, 8, (height+5)*2+10, 290, height, "Right-text StringGadget")
    StringGadget(3, 8, (height+5)*3+10, 290, height, "LOWERCASE...", #PB_String_LowerCase)
    StringGadget(4, 8, (height+5)*4+10, 290, height, "uppercase...", #PB_String_UpperCase)
    StringGadget(5, 8, (height+5)*5+10, 290, height, "Borderless StringGadget", #PB_String_BorderLess)
    StringGadget(6, 8, (height+5)*6+10, 290, height, "Password", #PB_String_Password)
    StringGadget(7, 8, (height+5)*7+10, 290, height, "")
    StringGadget(8, 8, (height+5)*8+10, 290, 90, Text)
    
    Define i
    For i=0 To 8
      BindGadgetEvent(i, @events_gadgets())
    Next
    
    
    SetTextAlignment()
    SetGadgetText(6, "GaT")
    Debug GetGadgetText(6)+" - get gadget text"
    
    String(305+8, 10, 290, height, "Read-only StringGadget...", #__string_readonly)
    String(305+8, (height+5)*1+10, 290, height, "123-only-4567", #__string_numeric|#__string_center)
    String(305+8, (height+5)*2+10, 290, height, "Right-text StringGadget", #__string_right)
    String(305+8, (height+5)*3+10, 290, height, "LOWERCASE...", #__string_lowercase)
    String(305+8, (height+5)*4+10, 290, height, "uppercase...", #__string_uppercase)
    String(305+8, (height+5)*5+10, 290, height, "Borderless StringGadget", #__flag_borderless)
    String(305+8, (height+5)*6+10, 290, height, "Password", #__string_password)
    String(305+8, (height+5)*7+10, 290, height, "")
    String(305+8, (height+5)*8+10, 290, 90, Text)
    
    SetText(GetWidget(6), "GaT")
    Debug GetText(GetWidget(6))+"- get widget text"
    
    For i=0 To 8
      Bind(GetWidget(i), @events_widgets())
    Next
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ---
; EnableXP