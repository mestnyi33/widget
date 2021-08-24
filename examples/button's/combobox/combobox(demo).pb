IncludePath "../../../" : XIncludeFile "widgets.pbi"
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
    Protected ComboBox.s
    
    Select EventType()
      Case #PB_EventType_Focus
        ComboBox.s = "focus "+EventGadget()+" "+EventType()
      Case #PB_EventType_LostFocus
        ComboBox.s = "lostfocus "+EventGadget()+" "+EventType()
      Case #PB_EventType_Change
        ComboBox.s = "change "+EventGadget()+" "+EventType()
    EndSelect
    
    If EventType() = #PB_EventType_Focus
      Debug ComboBox.s +" - gadget" +" get text - "+ GetGadgetText(EventGadget()) ; Bug in mac os
    Else
      Debug ComboBox.s +" - gadget"
    EndIf
  EndProcedure
  
  Procedure events_widgets()
    Protected ComboBox.s
    Protected eventtype = WidgetEventType( )
    
    Select eventtype
      Case #PB_EventType_Focus
        ComboBox.s = "focus "+Str(EventWidget( )\index-1)+" "+eventtype
      Case #PB_EventType_LostFocus
        ComboBox.s = "lostfocus "+Str(EventWidget( )\index-1)+" "+eventtype
      Case #PB_EventType_Change
        ComboBox.s = "change "+Str(EventWidget( )\index-1)+" "+eventtype
    EndSelect
    
    If eventtype = #PB_EventType_Focus
      Debug ComboBox.s +" - widget" +" get text - "+ GetText(EventWidget( ))
    Else
      Debug ComboBox.s +" - widget"
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
      
      SetWindowLongPtr_(GadgetID(0), #GWL_STYLE, GetWindowLong_(GadgetID(0), #GWL_STYLE)|#SS_CENTERIMAGE)
      SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTERIMAGE)
      SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_CENTERIMAGE)
      SetWindowLongPtr_(GadgetID(3), #GWL_STYLE, GetWindowLong_(GadgetID(3), #GWL_STYLE)|#SS_CENTERIMAGE)
      SetWindowLongPtr_(GadgetID(4), #GWL_STYLE, GetWindowLong_(GadgetID(4), #GWL_STYLE)|#SS_CENTERIMAGE)
      SetWindowLongPtr_(GadgetID(5), #GWL_STYLE, GetWindowLong_(GadgetID(5), #GWL_STYLE)|#SS_CENTERIMAGE)
      SetWindowLongPtr_(GadgetID(6), #GWL_STYLE, GetWindowLong_(GadgetID(6), #GWL_STYLE)|#SS_CENTERIMAGE)
      SetWindowLongPtr_(GadgetID(7), #GWL_STYLE, GetWindowLong_(GadgetID(7), #GWL_STYLE)|#SS_CENTERIMAGE)
      
      SetWindowLongPtr_(GadgetID(8), #GWL_STYLE, GetWindowLong_(GadgetID(8), #GWL_STYLE)|#SS_CENTERIMAGE)
      
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
  
  Define height=60, Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline ComboBoxGadget H"
  UsePNGImageDecoder()
  LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png")
  LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp")
  LoadImage(2, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp")
  
  
  If Open(OpenWindow(#PB_Any, 0, 0, 615, (height+5)*8+20+90, "ComboBox on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
; ;     ComboBoxGadget(0, 8, 10, 290, height, #PB_ComboBox_ReadOnly)
; ;     AddGadgetItem(0, -1, "Read-only ComboBoxGadget...00000 00000 00000 00000 00000 00000 00000 00000")
; ;     ComboBoxGadget(1, 8, (height+5)*1+10, 290, height, #PB_ComboBox_Numeric)
; ;     AddGadgetItem(1, -1, "00000 00000 00000 00000 123-only-4567 00000 00000 00000 00000")
; ;     ComboBoxGadget(2, 8, (height+5)*2+10, 290, height)
; ;     AddGadgetItem(2, -1, "00000 00000 00000 00000 00000 00000 00000 00000 ...Right-text ComboBoxGadget")
; ;     ComboBoxGadget(3, 8, (height+5)*3+10, 290, height, #PB_ComboBox_LowerCase)
; ;     AddGadgetItem(3, -1, "LOWERCASE...")
; ;     ComboBoxGadget(4, 8, (height+5)*4+10, 290, height, #PB_ComboBox_UpperCase)
; ;     AddGadgetItem(4, -1, "uppercase...")
; ;     ComboBoxGadget(5, 8, (height+5)*5+10, 290, height, #PB_ComboBox_BorderLess)
; ;     AddGadgetItem(5, -1, "Borderless ComboBoxGadget")
; ;     ComboBoxGadget(6, 8, (height+5)*6+10, 290, height, #PB_ComboBox_Password)
; ;     AddGadgetItem(6, -1, "Password")
; ;     ComboBoxGadget(7, 8, (height+5)*7+10, 290, height)
; ;     AddGadgetItem(7, -1, "")
; ;     ComboBoxGadget(8, 8, (height+5)*8+10, 290, 90)
; ;     AddGadgetItem(8, -1, Text)
; ;     
; ;     Define i
; ;     For i=0 To 8
; ;       BindGadgetEvent(i, @events_gadgets())
; ;     Next
; ;     
; ;     
; ;     SetTextAlignment()
; ;     SetGadgetText(6, "pas")
; ;     Debug GetGadgetText(6)+" - get gadget text"
    Define a
    ComboBoxGadget(0, 10, 10, 250, 21, #PB_ComboBox_Editable)
      For a = 1 To 5
        AddGadgetItem(0, -1,"ComboBox item " + Str(a))
      Next

    ComboBoxGadget(1, 10, 40, 250, 21, #PB_ComboBox_Image)
      AddGadgetItem(1, -1, "ComboBox item with image1", ImageID(0))
      AddGadgetItem(1, -1, "ComboBox item with image2", ImageID(1))
      AddGadgetItem(1, -1, "ComboBox item with image3", ImageID(2))

    ComboBoxGadget(2, 10, 70, 250, 21)
      AddGadgetItem(2, -1, "ComboBox editable...1")
      AddGadgetItem(2, -1, "ComboBox editable...2")
      AddGadgetItem(2, -1, "ComboBox editable...3")

    SetGadgetState(0, 2)
    SetGadgetState(1, 0)
    SetGadgetState(2, 0)    ; set (beginning with 0) the third item as active one
    
    
; ;     ComboBox(305+8, 10, 290, height, #__ComboBox_readonly)
; ;     AddItem(widget(), -1, "Read-only ComboBoxGadget...00000 00000 00000 00000 00000 00000 00000 00000")
; ;     ComboBox(305+8, (height+5)*1+10, 290, height, #__ComboBox_numeric|#__ComboBox_center)
; ;     AddItem(widget(), -1, "00000 00000 00000 00000 123-only-4567 00000 00000 00000 00000")
; ;     ComboBox(305+8, (height+5)*2+10, 290, height, #__ComboBox_right)
; ;     AddItem(widget(), -1, "00000 00000 00000 00000 00000 00000 00000 00000 ...Right-text ComboBoxGadget")
; ;     ComboBox(305+8, (height+5)*3+10, 290, height, #__ComboBox_lowercase)
; ;     AddItem(widget(), -1, "LOWERCASE...")
; ;     ComboBox(305+8, (height+5)*4+10, 290, height, #__ComboBox_uppercase)
; ;     AddItem(widget(), -1, "uppercase...")
; ;     ComboBox(305+8, (height+5)*5+10, 290, height, #__flag_borderless)
; ;     AddItem(widget(), -1, "Borderless ComboBoxGadget")
; ;     ComboBox(305+8, (height+5)*6+10, 290, height, #__ComboBox_password)
; ;     AddItem(widget(), -1, "Password")
; ;     ComboBox(305+8, (height+5)*7+10, 290, height)
; ;     AddItem(widget(), -1, "")
; ;     ComboBox(305+8, (height+5)*8+10, 290, 90)
; ;     AddItem(widget(), -1, Text)
; ;     
; ;     SetText(GetWidget(6), "pas")
; ;     Debug GetText(GetWidget(6))+"- get widget text"
; ;     
; ;     For i=0 To 8
; ;       Bind(GetWidget(i), @events_widgets())
; ;     Next
    ComboBox(305+10, 10, 250, 21, #PB_ComboBox_Editable)
      For a = 1 To 5
        AddItem(widget(), -1,"ComboBox item " + Str(a))
      Next

    ComboBox(305+10, 40, 250, 21, #PB_ComboBox_Image)
      AddItem(widget(), -1, "ComboBox item with image1", ImageID(0))
      AddItem(widget(), -1, "ComboBox item with image2", ImageID(1))
      AddItem(widget(), -1, "ComboBox item with image3", ImageID(2))

    ComboBox(305+10, 70, 250, 21)
     AddItem(widget(), -1, "ComboBox editable...1")
     AddItem(widget(), -1, "ComboBox editable...2")
     AddItem(widget(), -1, "ComboBox editable...3")

    SetState(getwidget(0), 2)
    SetState(getwidget(1), 0)
    SetState(getwidget(2), 0)    ; set (beginning with 0) the third item as active one
    
    bind(-1,-1)
    ;WaitClose( ) 
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP