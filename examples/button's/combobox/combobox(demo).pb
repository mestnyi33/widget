IncludePath "../../../" 
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseLib(widget)
  EnableExplicit
  Define a,i, height=60
  
  UsePNGImageDecoder()
  LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png")
  LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp")
  LoadImage(2, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp")
  CopyImage(1,3)
  CopyImage(2,4)
  ResizeImage(3, 32, 32)
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Define ImageSize.NSSize
    ImageSize\width = 16
    ImageSize\height = 16
    CocoaMessage(0, ImageID(4), "setSize:@", @ImageSize)
  CompilerElse
    ResizeImage(4, 16, 16)
  CompilerEndIf

  
  Procedure events_gadgets()
    Protected ComboBox.s
    ClearDebugOutput()
    
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
    If eventtype = #__event_Draw Or eventtype = #__event_MouseMove
      ProcedureReturn 
    EndIf
    If EventWidget( ) = EventWidget( )\_root( )
      ProcedureReturn 
    EndIf
    
    ;ClearDebugOutput()
    
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
      If ComboBox.s <> "" 
        Debug ComboBox.s +" - widget " + EventWidget( )\class
        ComboBox.s = ""
      EndIf
    EndIf
    
  EndProcedure
  
  
  If Open(OpenWindow(#PB_Any, 0, 0, 615, 120, "ComboBox on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    ;\\
    ComboBoxGadget(0, 10, 10, 250, 21, #PB_ComboBox_Editable)
    For a = 1 To 31 ; xp=31 ;linux-qt=11 ; mac = 5
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
    SetGadgetState(1, 1)
    SetGadgetState(2, 0)    ; set (beginning with 0) the third item as active one
    
    
    For i = 0 To 2
      BindGadgetEvent(i, @events_gadgets())
    Next
    
    ;\\
    ComboBox(305+10, 10, 250, 21, #PB_ComboBox_Editable)
    For a = 1 To 31
      AddItem(widget(), -1,"ComboBox item " + Str(a))
    Next
    
    ComboBox(305+10, 40, 250, 21, #PB_ComboBox_Image)
    AddItem(widget(), -1, "ComboBox item with image1", (0))
    AddItem(widget(), -1, "ComboBox item with image2", (1))
    AddItem(widget(), -1, "ComboBox item with image3", (2))
    
    ComboBox(305+10, 70, 250, 21)
    AddItem(widget(), -1, "ComboBox editable...1")
    AddItem(widget(), -1, "ComboBox editable...2")
    AddItem(widget(), -1, "ComboBox editable...3")
    
    SetState(getwidget(0), 2)
    SetState(getwidget(1), 1)
    SetState(getwidget(2), 0)    ; set (beginning with 0) the third item as active one
    
    For i = 0 To 2
      Bind(getwidget(i), @events_widgets())
    Next
    
    WaitClose( ) 
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP