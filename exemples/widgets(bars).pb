IncludePath "../"
;  XIncludeFile "widgets().pbi"
 XIncludeFile "widgets.pbi"
;XIncludeFile "widgets(_align_0_0_0).pbi"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule widget
   UseModule constants
;   UseModule structures
  
  Procedure _Events()
    Select *event\type
      Case #__Event_MouseEnter
        Debug "post enter - "+*event\widget\index
        If GetButtons(*event\widget)
          *event\widget\color\back = $00FF00
        Else
          *event\widget\color\back = $0000FF
        EndIf
        
      Case #__Event_MouseLeave
        Debug "post leave - "+*event\widget\index
        *event\widget\color\back = $FF0000
        
      Case #__Event_Repaint
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(2,0, Str(*event\widget\index), 0)
        
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
  ;     Redraw(Root())
  ;   EndIf
  ;   
  If Open(-1, 0, 0, 475, 525, "Root", #__flag_BorderLess|#__flag_AnchorsGadget|#PB_Window_ScreenCentered);|#__flag_AutoSize)
    Define *w,*w1,*w2
    Define i
    
    Spin(5, 5, 150, 30, 0, 20)
    SetState(Widget(), 5)
    Spin(5, 40, 150, 30, 0, 20, #__bar_Vertical)
    SetState(Widget(), 5)
    Spin(5, 75, 150, 30, 0, 20, #__bar_Reverse)
    SetState(Widget(), 5)
    
;     Tree(5, 110, 150, 410, #__flag_Checkboxes)
;     For i=0 To 10;20
;       If i=3 Or i=8 Or i=14
;         AddItem(Widget(), i, "long_long_long_item_"+ Str(i),-1, 1)
;       Else
;         AddItem(Widget(), i, "item_"+ Str(i))
;       EndIf
;     Next
    
    Panel     (160, 5, 150, 100)
    For i=0 To 10
      AddItem (Widget(), -1, "item_"+Str(i))
    Next
    CloseList()
    SetState(Widget(), 5)
    
    Editor(320, 5, 150, 100)
    ; settext(Widget(), "settext")
    ; Debug  Widget()\text\string
    
    For i=0 To 20
      If i=3
        AddItem(Widget(), i, "long_long_long_item_"+ Str(i),-1, Bool(i=3 Or i=6))
      Else
        AddItem(Widget(), i, "item_"+ Str(i))
      EndIf
    Next
    
;     Tree(160, 110, 150, 100, #__flag_Checkboxes)
;     For i=0 To 20
;       If i=3
;         AddItem(Widget(), i, "long_long_long_item_"+ Str(i),-1, Bool(i=3 Or i=6))
;       Else
;         AddItem(Widget(), i, "item_"+ Str(i))
;       EndIf
;     Next
    
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
    
    
    Splitter(320, 215, 150, 150, Splitter(0, 0, 0, 0, HyperLink(0, 0, 0, 0,"кнопка 3 "+#CRLF$+"кнопка 33", $FF00FF00), Button(0, 0, 0, 0,"кнопка 1 "+#CRLF$+"кнопка 11")), Button(0, 0, 0, 0,"кнопка 2 "+#CRLF$+"кнопка 22", #__bar_Vertical), #PB_Splitter_Vertical) 
    
    Scroll(160, 370, 150, 20, 0, 50, 30)
    SetState(Widget(), 5)
    Scroll(160, 370+25, 150, 20, 0, 50, 30, #__bar_Inverted)
    SetState(Widget(), 5)
    
    Track(160, 370+53, 150, 20, 0, 20, #__bar_ticks)
    SetState(Widget(), 5)
    Track(160, 370+53+25, 150, 20, 0, 20, #__bar_Inverted|#__bar_ticks)
    SetState(Widget(), 5)
    
    Progress(160, 370+105, 150, 20, 0, 20)
    SetState(Widget(), 5)
    Progress(160, 370+105+25, 150, 20, 0, 20, #__bar_Inverted)
    SetState(Widget(), 5)
    
    Scroll(320, 370, 20, 150, 0, 50, 30, #__bar_Vertical)
    SetState(Widget(), 5)
    ;SetAttribute(Widget(), #__bar_Inverted, 0)
    Scroll(320+25, 370, 20, 150, 0, 50, 30, #__bar_Vertical|#__bar_Inverted)
    SetState(Widget(), 5)
    
    Track(320+53, 370, 20, 150, 0, 20, #__bar_Vertical|#__bar_ticks)
    SetState(Widget(), 5)
    SetAttribute(Widget(), #__bar_Inverted, 0)
    Track(320+53+25, 370, 20, 150, 0, 20, #__bar_Vertical|#__bar_Inverted|#__bar_ticks)
    SetState(Widget(), 5)
    
    Progress(320+105, 370, 20, 150, 0, 20, #__bar_Vertical)
    SetState(Widget(), 5)
    SetAttribute(Widget(), #__bar_Inverted, 0)
    Progress(320+105+25, 370, 20, 150, 0, 20, #__bar_Vertical|#__bar_Inverted)
    SetState(Widget(), 5)
    
    
    ;     Scroll(160, 370, 150, 40, 0, 50, 30)
    ;     SetState(Widget(), 5)
    ;     Track(160, 370+55, 150, 40, 0, 20)
    ;     SetState(Widget(), 5)
    ;     Progress(160, 370+110, 150, 40, 0, 20)
    ;     SetState(Widget(), 5)
    ;     
    ;     Scroll(320, 370, 40, 150, 0, 50, 30, #__bar_Vertical)
    ;     SetState(Widget(), 5)
    ;     Track(320+55, 370, 40, 150, 0, 20, #__bar_Vertical)
    ;     SetState(Widget(), 5)
    ;     Progress(320+110, 370, 40, 150, 0, 20, #__bar_Vertical)
    ;     SetState(Widget(), 5)
    
    ReDraw(Root())
  EndIf
  
  Repeat
    Define Event = WaitWindowEvent()
  Until Event= #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --
; EnableXP