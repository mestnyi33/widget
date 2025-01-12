﻿;
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
        If EnteredButton( )
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
  
  ;   If Open(-1, 50, 50, 220, 220, "demo enter & leave", #__flag_BorderLess)
  ;     SetData(Container(20, 20, 180, 180), 1)
  ;     SetData(Container(70, 10, 70, 180, #__flag_NoGadget), 9) 
  ;     SetData(Container(20, 20, 180, 180), 2)
  ;     SetData(Container(20, 20, 180, 180), 3)
  ;     
  ;     SetData(Container(0, 20, 180, 30, #__flag_NoGadget), 4) 
  ;     SetData(Container(0, 35, 180, 30, #__flag_NoGadget), 5) 
  ;     SetData(Container(0, 50, 180, 30, #__flag_NoGadget), 6) 
  ;     SetData(Splitter(20, 70, 180, 50, Container(0,0,0,0, #__flag_NoGadget), Container(0,0,0,0, #__flag_NoGadget), #PB_Splitter_Vertical), 7) 
  ;     
  ;     CloseList()
  ;     CloseList()
  ;     SetData(Container(10, 70, 70, 180), 8) 
  ;     SetData(Container(10, 10, 70, 30, #__flag_NoGadget), 10) 
  ;     SetData(Container(10, 20, 70, 30, #__flag_NoGadget), 11) 
  ;     SetData(Container(10, 30, 70, 30, #__flag_NoGadget), 12) 
  ;     CloseList()
  ;     
  ;     Bind(@Events(), root())
  ;   EndIf
  ;   
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Open(OpenWindow(#PB_Any, 0, 0, 475, 525, "Root", #PB_Window_ScreenCentered));|#__flag_AutoSize)
    Define i, *w,*w1,*w2
    
    Image(5, 5, 150, 100, 0, #__flag_Checkboxes)
    
;     ListIcon(5, 110, 150, 100, "column_0", 80, #__flag_Checkboxes)
;     AddColumn(widget(), -1, "column_1", 100)
;     For i=0 To 10;20
;       If i=3 Or i=8 Or i=14
;         AddItem(Widget(), i, "long_long_long_item_"+ Str(i),-1, 1)
;       Else
;         AddItem(Widget(), i, "0_item_"+ Str(i)+Chr(10)+"1_item_"+ Str(i))
;       EndIf
;     Next
    
    Tree(5, 215, 150, 150, #__flag_Checkboxes)
    For i=0 To 10;20
      If i=3 Or i=8 Or i=14
        AddItem(Widget(), i, "long_long_long_item_"+ Str(i),-1, 1)
      Else
        AddItem(Widget(), i, "item_"+ Str(i))
      EndIf
    Next
    
    Panel     (160, 5, 150, 100)
    For i=0 To 10
      AddItem (Widget(), -1, "item_"+Str(i))
    Next
    CloseList()
    SetState(Widget(), 5)
    
    ; demo editor
    Editor(320, 5, 150, 100)
    SetText(Widget(), Text.s) 
    Define a
    For a = 0 To 2
      AddItem(Widget(), a, "Line "+Str(a))
    Next
    AddItem(Widget(), a, "")
    For a = 4 To 6
      AddItem(Widget(), a, "Line "+Str(a))
    Next
    ;SetFont(*g, FontID(0))
    
    Tree(160, 110, 150, 100, #__flag_Checkboxes)
    For i=0 To 20
      If i=3
        AddItem(Widget(), i, "long_long_long_item_"+ Str(i),-1, Bool(i=3 Or i=6))
      Else
        AddItem(Widget(), i, "item_"+ Str(i))
      EndIf
    Next
    
    ScrollArea(320,110,150,100, 200,200)
    Button(10, 15, 80, 24,"Кнопка 1")
    ;     Combobox(10, 15, 80, 24)
    ;     AddItem(Widget(), -1, "Combobox")
    ;     SetState(Widget(), 0)
    
    Button(95, 15, 80, 24,"Кнопка 2")
    CloseList()
    
    Container(160,215,150,150, #PB_Container_Flat) 
    Container(10,5,150,55, #PB_Container_Flat) 
    Container(10,5,150,55, #PB_Container_Flat) 
    Container(10,5,150,55, #PB_Container_Flat) 
    Button(10,5,50,35, "butt") 
    CloseList()
    CloseList()
    CloseList()
    
    Container(10,75,150,55, #PB_Container_Flat) 
    Container(10,5,150,55, #PB_Container_Flat) 
    Container(10,5,150,55, #PB_Container_Flat) 
    Button(10,5,50,35, "butt1") 
    CloseList()
    CloseList()
    CloseList()
    CloseList()
    
    ; demo bar type
    Splitter(320, 215, 150, 150, Splitter(0, 0, 0, 0, HyperLink(0, 0, 0, 0,"кнопка 3", $FF00FF00), Button(0, 0, 0, 0,"кнопка 1")), Button(0, 0, 0, 0,"кнопка 2", #__bar_Vertical), #PB_Splitter_Vertical) 
    ;Splitter(320, 215, 150, 150, Splitter(0, 0, 0, 0, HyperLink(0, 0, 0, 0,"кнопка 3 "+#CRLF$+"кнопка 33", $FF00FF00), Button(0, 0, 0, 0,"кнопка 1 "+#CRLF$+"кнопка 11")), Button(0, 0, 0, 0,"кнопка 2 "+#CRLF$+"кнопка 22", #__bar_Vertical), #PB_Splitter_Vertical) 
    
    Spin(5, 365+5, 150, 30, 0, 20)
    SetState(Widget(), 5)
    Spin(5, 365+40, 150, 30, 0, 20, #__bar_Vertical)
    SetState(Widget(), 5)
    Spin(5, 365+75, 150, 30, 0, 21);, #__bar_Reverse)
    SetState(Widget(), 5)
    
    Scroll(160, 370, 150, 20, 0, 50, 30)
    SetState(Widget(), 5)
    Scroll(160, 370+25, 150, 10, 0, 50, 30, #__bar_Invert)
    SetState(Widget(), 5)
    
    Track(160, 370+53, 150, 20, 0, 20, #PB_TrackBar_Ticks,0)
    SetState(Widget(), 5)
    Track(160, 370+53+25, 150, 20, 0, 20, #__bar_Invert,0)
    SetState(Widget(), 5)
    
    Progress(160, 370+105, 150, 20, 0, 20)
    SetState(Widget(), 5)
    Progress(160, 370+105+25, 150, 10, 0, 20, #__bar_Invert)
    SetState(Widget(), 5)
    
    Scroll(320, 370, 20, 150, 0, 50, 30, #__bar_Vertical, #__round+2)
    SetState(Widget(), 5)
    Scroll(320+25, 370, 10, 150, 0, 50, 30, #__bar_Vertical|#__bar_Invert, #__round/2+2)
    SetState(Widget(), 5)
    
    Track(320+53, 370, 20, 150, 0, 20, #__bar_Vertical, #__round);|#__bar_Invert)
    SetState(Widget(), 5)
    Track(320+53+25, 370, 20, 150, 0, 20, #__bar_Vertical, #__round)
    SetAttribute(Widget(), #__bar_Invert, 0)
    SetState(Widget(), 5)
    
    Progress(320+105, 370, 20, 150, 0, 20, #__bar_Vertical, #__round)
    SetAttribute(Widget(), #__bar_Invert, 0)
    SetState(Widget(), 5)
    Progress(320+105+25, 370, 10, 150, 0, 20, #__bar_Vertical|#__bar_Invert, #__round/2)
    SetState(Widget(), 5)
    
    
    ;         Scroll(160, 370, 150, 40, 0, 50, 30)
    ;         SetState(Widget(), 5)
    ;         Track(160, 370+55, 150, 40, 0, 20)
    ;         SetState(Widget(), 5)
    ;         Progress(160, 370+110, 150, 40, 0, 20)
    ;         SetState(Widget(), 5)
    ;         
    ;         Scroll(320, 370, 40, 150, 0, 50, 30, #__bar_Vertical)
    ;         SetState(Widget(), 5)
    ;         Track(320+55, 370, 40, 150, 0, 20, #__bar_Vertical)
    ;         SetState(Widget(), 5)
    ;         Progress(320+110, 370, 40, 150, 0, 20, #__bar_Vertical)
    ;         SetState(Widget(), 5)
  EndIf
  
  WaitClose( )
  
  Repeat
    Define Event = WaitWindowEvent()
  Until Event= #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 226
; FirstLine = 203
; Folding = --
; EnableXP