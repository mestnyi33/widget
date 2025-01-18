
IncludePath "../../../" : XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  EnableExplicit
  test_draw_area = 1
  
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
    Protected eventtype = WidgetEvent( )
    
    Select eventtype
      Case #__event_Focus
        String.s = "focus "+Str(EventWidget( )\index-1)+" "+eventtype
      Case #__event_LostFocus
        String.s = "lostfocus "+Str(EventWidget( )\index-1)+" "+eventtype
      Case #__event_Change
        String.s = "change "+Str(EventWidget( )\index-1)+" "+eventtype
    EndSelect
    
    If eventtype = #__event_Focus
      Debug String.s +" - widget" +" get text - "+ GetText(EventWidget( ))
    Else
      ; Debug String.s +" - widget"
    EndIf
    
  EndProcedure
  
  ; Alignment text
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    ImportC ""
      gtk_entry_set_alignment(Entry.i, Xalign.f)
      gtk_label_set_yalign(*Label.GtkLabel, Yalign.F)
    EndImport
  CompilerEndIf
  
  Procedure SetTextWordWrap( gadget,state )
    CompilerIf Subsystem("qt")
      QtScript(~"gadget("+gadget+").wordWrap = "+state+"")
    CompilerEndIf
  EndProcedure
  
  Procedure SetTextAlignment()
    ; Alignment text
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      CocoaMessage(0,GadgetID(1),"setAlignment:", #NSCenterTextAlignment)
      CocoaMessage(0,GadgetID(2),"setAlignment:", #NSRightTextAlignment)
      
      CocoaMessage(0, CocoaMessage(0, GadgetID(0), "cell"), "_setVerticallyCentered:", #True)
      CocoaMessage(0, CocoaMessage(0, GadgetID(1), "cell"), "_setVerticallyCentered:", #True)
      CocoaMessage(0, CocoaMessage(0, GadgetID(2), "cell"), "_setVerticallyCentered:", #True)
      CocoaMessage(0, CocoaMessage(0, GadgetID(3), "cell"), "_setVerticallyCentered:", #True)
      CocoaMessage(0, CocoaMessage(0, GadgetID(4), "cell"), "_setVerticallyCentered:", #True)
      CocoaMessage(0, CocoaMessage(0, GadgetID(5), "cell"), "_setVerticallyCentered:", #True)
      CocoaMessage(0, CocoaMessage(0, GadgetID(6), "cell"), "_setVerticallyCentered:", #True)
      CocoaMessage(0, CocoaMessage(0, GadgetID(7), "cell"), "_setVerticallyCentered:", #True)
      
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
      
;       SetWindowLongPtr_(GadgetID(0), #GWL_STYLE, GetWindowLong_(GadgetID(0), #GWL_STYLE)|#SS_CENTERIMAGE)
;       SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTERIMAGE)
;       SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_CENTERIMAGE)
;       SetWindowLongPtr_(GadgetID(3), #GWL_STYLE, GetWindowLong_(GadgetID(3), #GWL_STYLE)|#SS_CENTERIMAGE)
;       SetWindowLongPtr_(GadgetID(4), #GWL_STYLE, GetWindowLong_(GadgetID(4), #GWL_STYLE)|#SS_CENTERIMAGE)
;       SetWindowLongPtr_(GadgetID(5), #GWL_STYLE, GetWindowLong_(GadgetID(5), #GWL_STYLE)|#SS_CENTERIMAGE)
;       SetWindowLongPtr_(GadgetID(6), #GWL_STYLE, GetWindowLong_(GadgetID(6), #GWL_STYLE)|#SS_CENTERIMAGE)
;       SetWindowLongPtr_(GadgetID(7), #GWL_STYLE, GetWindowLong_(GadgetID(7), #GWL_STYLE)|#SS_CENTERIMAGE)
;       
;       SetWindowLongPtr_(GadgetID(8), #GWL_STYLE, GetWindowLong_(GadgetID(8), #GWL_STYLE)|#SS_CENTERIMAGE)
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      ;       ImportC ""
      ;         gtk_entry_set_alignment(Entry.i, XAlign.f)
      ;       EndImport
      
      ;gtk_text_view_set_justification_(GadgetID(Editor), #GTK_JUSTIFY_CENTER)
      
      gtk_label_set_yalign(GadgetID(8), 0.5)
      
      gtk_entry_set_alignment(GadgetID(1), 0.5)
      gtk_entry_set_alignment(GadgetID(2), 1)
    CompilerEndIf
  EndProcedure
  
  Define Height=60, Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget H"
  
  Macro EString(X,Y,Width,Height, Text, flag=0)
    String(X,Y,Width,Height, Text, flag)
    ; Editor(x,y,width,height, flag) : setText(widget(), text)
  EndMacro
  
  Define null$ = "" ;"00000 00000 00000 00000"
    
  If Open(0, 0, 0, 615, (Height+5)*8+20+90, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    StringGadget(0, 8, 10, 290, Height, "Read-only StringGadget..."+null$ + null$, #PB_String_ReadOnly)
    StringGadget(1, 8, (Height+5)*1+10, 290, Height, null$ + " 123-only-4567 " + null$, #PB_String_Numeric)
    StringGadget(2, 8, (Height+5)*2+10, 290, Height, null$ + null$ + " ...Right-text StringGadget")
    StringGadget(3, 8, (Height+5)*3+10, 290, Height, "LOWERCASE...", #PB_String_LowerCase)
    StringGadget(4, 8, (Height+5)*4+10, 290, Height, "uppercase...", #PB_String_UpperCase)
    StringGadget(5, 8, (Height+5)*5+10, 290, Height, "Borderless StringGadget", #PB_String_BorderLess)
    StringGadget(6, 8, (Height+5)*6+10, 290, Height, "Password", #PB_String_Password)
    StringGadget(7, 8, (Height+5)*7+10, 290, Height, "")
    StringGadget(8, 8, (Height+5)*8+10, 290, 90, Text)
    
    Define i
    For i=0 To 8
      BindGadgetEvent(i, @events_gadgets())
    Next
    
    
    SetTextAlignment( )
    ;SetGadgetText(6, "pas")
    Debug GetGadgetText(6)+" - get gadget text"
    
    EString(305+8, 10, 290, Height, "Read-only StringGadget..." + null$ + null$, #PB_String_ReadOnly)
    EString(305+8, (Height+5)*1+10, 290, Height, null$ + " 123-only-4567 "+null$, #PB_String_Numeric|#__text_Center)
    EString(305+8, (Height+5)*2+10, 290, Height, null$ + null$ + " ...Right-text StringGadget", #__text_Right)
    EString(305+8, (Height+5)*3+10, 290, Height, "LOWERCASE...", #PB_String_LowerCase)
    EString(305+8, (Height+5)*4+10, 290, Height, "uppercase...", #PB_String_UpperCase)
    EString(305+8, (Height+5)*5+10, 290, Height, "Borderless StringGadget", #PB_String_BorderLess)
    EString(305+8, (Height+5)*6+10, 290, Height, "Password", #PB_String_Password)
    EString(305+8, (Height+5)*7+10, 290, Height, "")
    EString(305+8, (Height+5)*8+10, 290, 90, Text)
    
    ;SetText(ID(6+1), "pas")
    Debug GetText(ID(6+1))+"- get widget text"
    
    For i=0 To 8
      Bind(ID(i), @events_widgets())
    Next
    
    ;WaitClose( ) 
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 152
; FirstLine = 148
; Folding = ---
; EnableXP
; DPIAware