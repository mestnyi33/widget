;
; example demo resize draw splitter - OS gadgets   -bar
; 

XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  #__round = 7
  #__Bar_Inverted = #__Bar_Invert ;: #__Bar_NoButtons = #__bar_buttonsize
 
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 16)
  CompilerElse
    LoadFont(0, "Arial", 11)
  CompilerEndIf 
  
  Define m.s=#LF$
  Global Text.s = "This is a long line." + m.s +
           "Who should show." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "I have to write the text in the box or not." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work." ;+ m.s +
 
  Procedure Events_()
    Select WidgetEvent( )
      Case #PB_EventType_MouseEnter
        Debug "post enter - "+EventWidget( )\index
        If EnteredButtonWidget( )
          EventWidget( )\color\back = $00FF00
        Else
          EventWidget( )\color\back = $0000FF
        EndIf
        
      Case #PB_EventType_MouseLeave
        Debug "post leave - "+EventWidget( )\index
        EventWidget( )\color\back = $FF0000
        
      Case #PB_EventType_Repaint
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(2,0, Str(EventWidget( )\index), 0)
        
    EndSelect
  EndProcedure
  
  ;   If OpenRootWidget(-1, 50, 50, 220, 220, "demo enter & leave", #__flag_BorderLess)
  ;     SetData(ContainerWidget(20, 20, 180, 180), 1)
  ;     SetData(ContainerWidget(70, 10, 70, 180, #__flag_NoGadget), 9) 
  ;     SetData(ContainerWidget(20, 20, 180, 180), 2)
  ;     SetData(ContainerWidget(20, 20, 180, 180), 3)
  ;     
  ;     SetData(ContainerWidget(0, 20, 180, 30, #__flag_NoGadget), 4) 
  ;     SetData(ContainerWidget(0, 35, 180, 30, #__flag_NoGadget), 5) 
  ;     SetData(ContainerWidget(0, 50, 180, 30, #__flag_NoGadget), 6) 
  ;     SetData(Splitter(20, 70, 180, 50, ContainerWidget(0,0,0,0, #__flag_NoGadget), ContainerWidget(0,0,0,0, #__flag_NoGadget), #PB_Splitter_Vertical), 7) 
  ;     
  ;     CloseWidgetList()
  ;     CloseWidgetList()
  ;     SetData(ContainerWidget(10, 70, 70, 180), 8) 
  ;     SetData(ContainerWidget(10, 10, 70, 30, #__flag_NoGadget), 10) 
  ;     SetData(ContainerWidget(10, 20, 70, 30, #__flag_NoGadget), 11) 
  ;     SetData(ContainerWidget(10, 30, 70, 30, #__flag_NoGadget), 12) 
  ;     CloseWidgetList()
  ;     
  ;     BindWidgetEvent(@Events(), root())
  ;   EndIf
  ;   
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If OpenRootWidget(OpenWindow(#PB_Any, 0, 0, 475, 525, "Root", #PB_Window_ScreenCentered));|#__flag_AutoSize)
    Define i, *w,*w1,*w2
    
    ImageWidget(5, 5, 150, 100, 0, #__flag_Checkboxes)
    
;     ListIconWidget(5, 110, 150, 100, "column_0", 80, #__flag_Checkboxes)
;     AddColumn(widget(), -1, "column_1", 100)
;     For i=0 To 10;20
;       If i=3 Or i=8 Or i=14
;         AddItem(Widget(), i, "long_long_long_item_"+ Str(i),-1, 1)
;       Else
;         AddItem(Widget(), i, "0_item_"+ Str(i)+Chr(10)+"1_item_"+ Str(i))
;       EndIf
;     Next
    
    TreeWidget(5, 215, 150, 150, #__flag_Checkboxes)
    For i=0 To 10;20
      If i=3 Or i=8 Or i=14
        AddItem(widget(), i, "long_long_long_item_"+ Str(i),-1, 1)
      Else
        AddItem(widget(), i, "item_"+ Str(i))
      EndIf
    Next
    
    Panel     (160, 5, 150, 100)
    For i=0 To 10
      AddItem (widget(), -1, "item_"+Str(i))
    Next
    CloseWidgetList()
    SetState(widget(), 5)
    
    ; demo editor
    EditorWidget(320, 5, 150, 100)
    SetTextWidget(widget(), Text.s) 
    Define a
    For a = 0 To 2
      AddItem(widget(), a, "Line "+Str(a))
    Next
    AddItem(widget(), a, "")
    For a = 4 To 6
      AddItem(widget(), a, "Line "+Str(a))
    Next
    ;SetFont(*g, FontID(0))
    
    TreeWidget(160, 110, 150, 100, #__flag_Checkboxes)
    For i=0 To 20
      If i=3
        AddItem(widget(), i, "long_long_long_item_"+ Str(i),-1, Bool(i=3 Or i=6))
      Else
        AddItem(widget(), i, "item_"+ Str(i))
      EndIf
    Next
    
    ScrollAreaWidget(320,110,150,100, 200,200)
    ButtonWidget(10, 15, 80, 24,"Кнопка 1")
    ;     ComboBoxWidget(10, 15, 80, 24)
    ;     AddItem(Widget(), -1, "Combobox")
    ;     SetState(Widget(), 0)
    
    ButtonWidget(95, 15, 80, 24,"Кнопка 2")
    CloseWidgetList()
    
    ContainerWidget(160,215,150,150, #PB_Container_Flat) 
    ContainerWidget(10,5,150,55, #PB_Container_Flat) 
    ContainerWidget(10,5,150,55, #PB_Container_Flat) 
    ContainerWidget(10,5,150,55, #PB_Container_Flat) 
    ButtonWidget(10,5,50,35, "butt") 
    CloseWidgetList()
    CloseWidgetList()
    CloseWidgetList()
    
    ContainerWidget(10,75,150,55, #PB_Container_Flat) 
    ContainerWidget(10,5,150,55, #PB_Container_Flat) 
    ContainerWidget(10,5,150,55, #PB_Container_Flat) 
    ButtonWidget(10,5,50,35, "butt1") 
    CloseWidgetList()
    CloseWidgetList()
    CloseWidgetList()
    CloseWidgetList()
    
    ; demo bar type
    SplitterWidget(320, 215, 150, 150, SplitterWidget(0, 0, 0, 0, HyperLinkWidget(0, 0, 0, 0,"кнопка 3", $FF00FF00), ButtonWidget(0, 0, 0, 0,"кнопка 1")), ButtonWidget(0, 0, 0, 0,"кнопка 2", #__bar_Vertical), #PB_Splitter_Vertical) 
    ;Splitter(320, 215, 150, 150, SplitterWidget(0, 0, 0, 0, HyperLinkWidget(0, 0, 0, 0,"кнопка 3 "+#CRLF$+"кнопка 33", $FF00FF00), ButtonWidget(0, 0, 0, 0,"кнопка 1 "+#CRLF$+"кнопка 11")), ButtonWidget(0, 0, 0, 0,"кнопка 2 "+#CRLF$+"кнопка 22", #__bar_Vertical), #PB_Splitter_Vertical) 
    
    SpinWidget(5, 365+5, 150, 30, 0, 20)
    SetState(widget(), 5)
    SpinWidget(5, 365+40, 150, 30, 0, 20, #__bar_Vertical)
    SetState(widget(), 5)
    SpinWidget(5, 365+75, 150, 30, 0, 21);, #__bar_Reverse)
    SetState(widget(), 5)
    
    ScrollBarWidget(160, 370, 150, 20, 0, 50, 30)
    SetState(widget(), 5)
    ScrollBarWidget(160, 370+25, 150, 10, 0, 50, 30, #__bar_Invert)
    SetState(widget(), 5)
    
    TrackBarWidget(160, 370+53, 150, 20, 0, 20, #PB_TrackBar_Ticks,0)
    SetState(widget(), 5)
    TrackBarWidget(160, 370+53+25, 150, 20, 0, 20, #__bar_Invert,0)
    SetState(widget(), 5)
    
    ProgressBarWidget(160, 370+105, 150, 20, 0, 20)
    SetState(widget(), 5)
    ProgressBarWidget(160, 370+105+25, 150, 10, 0, 20, #__bar_Invert)
    SetState(widget(), 5)
    
    ScrollBarWidget(320, 370, 20, 150, 0, 50, 30, #__bar_Vertical, #__round+2)
    SetState(widget(), 5)
    ScrollBarWidget(320+25, 370, 10, 150, 0, 50, 30, #__bar_Vertical|#__bar_Invert, #__round/2+2)
    SetState(widget(), 5)
    
    TrackBarWidget(320+53, 370, 20, 150, 0, 20, #__bar_Vertical, #__round);|#__bar_Invert)
    SetState(widget(), 5)
    TrackBarWidget(320+53+25, 370, 20, 150, 0, 20, #__bar_Vertical, #__round)
    SetAttribute(widget(), #__bar_Invert, 0)
    SetState(widget(), 5)
    
    ProgressBarWidget(320+105, 370, 20, 150, 0, 20, #__bar_Vertical, #__round)
    SetAttribute(widget(), #__bar_Invert, 0)
    SetState(widget(), 5)
    ProgressBarWidget(320+105+25, 370, 10, 150, 0, 20, #__bar_Vertical|#__bar_Invert, #__round/2)
    SetState(widget(), 5)
    
    
    ;         ScrollBarWidget(160, 370, 150, 40, 0, 50, 30)
    ;         SetState(Widget(), 5)
    ;         TrackBarWidget(160, 370+55, 150, 40, 0, 20)
    ;         SetState(Widget(), 5)
    ;         ProgressBarWidget(160, 370+110, 150, 40, 0, 20)
    ;         SetState(Widget(), 5)
    ;         
    ;         ScrollBarWidget(320, 370, 40, 150, 0, 50, 30, #__bar_Vertical)
    ;         SetState(Widget(), 5)
    ;         TrackBarWidget(320+55, 370, 40, 150, 0, 20, #__bar_Vertical)
    ;         SetState(Widget(), 5)
    ;         ProgressBarWidget(320+110, 370, 40, 150, 0, 20, #__bar_Vertical)
    ;         SetState(Widget(), 5)
  EndIf
  
  WaitCloseRootWidget( )
  
  Repeat
    Define Event = WaitWindowEvent()
  Until Event= #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 86
; FirstLine = 82
; Folding = --
; EnableXP