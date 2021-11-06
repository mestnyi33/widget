

CompilerIf #PB_Compiler_IsMainFile
  
  EnableExplicit
  UseLIB(widget)
  
  Enumeration 
    #window_0
    #window
  EndEnumeration
  
  
  ; Shows using of several panels...
  Procedure BindEvents( )
    Protected *this._s_WIDGET = EventWidget( )
    Protected eventtype = WidgetEventType( )
    
    Select eventtype
        ;       Case #PB_EventType_Draw          : Debug "draw"         
      Case #PB_EventType_MouseWheelX     : Debug  " - "+ *this +" - wheel-x"
      Case #PB_EventType_MouseWheelY     : Debug  " - "+ *this +" - wheel-y"
      Case #PB_EventType_Input           : Debug  " - "+ *this +" - input"
      Case #PB_EventType_KeyDown         : Debug  " - "+ *this +" - key-down"
      Case #PB_EventType_KeyUp           : Debug  " - "+ *this +" - key-up"
      Case #PB_EventType_Focus           : Debug  " - "+ *this +" - focus"
      Case #PB_EventType_LostFocus       : Debug  " - "+ *this +" - lfocus"
      Case #PB_EventType_MouseEnter      : Debug  " - "+ *this +" - enter"
      Case #PB_EventType_MouseLeave      : Debug  " - "+ *this +" - leave"
      Case #PB_EventType_LeftButtonDown  : Debug  " - "+ *this +" - down"
      Case #PB_EventType_DragStart       : Debug  " - "+ *this +" - drag"
      Case #PB_EventType_Drop            : Debug  " - "+ *this +" - drop"
      Case #PB_EventType_LeftButtonUp    : Debug  " - "+ *this +" - up"
      Case #PB_EventType_LeftClick       : Debug  " - "+ *this +" - click"
      Case #PB_EventType_LeftDoubleClick : Debug  " - "+ *this +" - 2_click"
    EndSelect
  EndProcedure
  
  OpenWindow(#window_0, 0, 0, 300, 300, "PanelGadget", #PB_Window_SystemMenu )
  
  Define *w._s_WIDGET, editable
  Define *root._s_WIDGET = Open(#window_0,10,10,300-20,300-20)
  ;BindWidgetEvent( *root, @BindEvents( ) )
  
  SetData(*root, 1 )
  Define *p._s_WIDGET = Container( 80,80, 150,150 ) : SetData(*p, 2 )
  Define *c._s_WIDGET = Container( 40,-30, 50,50, #__Flag_NoGadgets ) : SetData(*c, 3 )
  Define *p2._s_WIDGET = Container( 40,40, 70,70 ) : SetData(*p2, 4 )
  SetData(Container( 5,5, 70,70 ), 5 )
  SetData(Container( -30,40, 50,50, #__Flag_NoGadgets ), 6)
  CloseList( )
  CloseList( )
  SetData(Container( 50,130, 50,50, #__Flag_NoGadgets ), 7)
  SetData(Container( 130,50, 50,50, #__Flag_NoGadgets ), 8)
  CloseList( )
  CloseList( )
  
  SetParent( *c, *p2 )
  ;SetParentWidget( *c,*p )
  
  ;SetParentWidget( *c,*p )
  
  ; ForEach *p\child( )
  ;   Debug "*p - "+*p\child( )\x +" "+ *p\child( )\width
  ; Next
  ; 
  ; ForEach *p2\child( )
  ;   Debug "*p2 - "+*p2\child( )\x +" "+ *p2\child( )\width
  ; Next
  
  OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  
  ;{ OpenRoot0
  Define *root0._s_WIDGET = Open(#window,10,10,300-20,300-20)
  ;BindWidgetEvent( *root2, @BindEvents( ) )
  
; ;   Define *g0 = Container(10,10,200,200) : SetClass(widget( ), "form_0") : SetData(widget( ), 11)
; ;   CloseList( )
; ;   
; ;   Define *g1 = Container(30,30,200,200) : SetClass(widget( ), "form_1") : SetData(widget( ), 21)
; ;   Button(10,10,80,30,"button_1_0") : SetData(widget( ), 22)
; ;   Button(10,50,80,30,"button_1_1") : SetData(widget( ), 23)
; ;   Button(10,90,80,30,"button_1_2") : SetData(widget( ), 24)
; ;   CloseList( )
; ;   
; ;   Define *g2 = Container(50,50,220,220) : SetClass(widget( ), "form_2") : SetData(widget( ), 31)
; ;   Button(10,10,80,30,"button_2_0") : SetData(widget( ), 32)
; ;   Button(10,50,80,30,"button_2_1") : SetData(widget( ), 33)
; ;   Button(10,90,80,30,"button_2_2") : SetData(widget( ), 34)
  Define Text.s, m.s=#LF$, a,*g = Editor(10, 10, 200+60, 200);, #__flag_autosize) 
  Text.s = "This is a long line." + m.s +
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
  SetText(*g, Text.s) 
  For a = 0 To 2
    AddItem(*g, a, "Line "+Str(a))
  Next
  AddItem(*g, 7+a, "_")
  For a = 4 To 6
    AddItem(*g, a, "Line "+Str(a))
  Next
  ;SetFont(*g, FontID(0))
  *g = String(10, 220, 200+60, 50, "string gadget default")
; ;   CloseList( )
; ;   
; ;   OpenList(*g0)
; ;   Button(10,10,80,30,"button_0_0") : SetData(widget( ), 12)
; ;   Button(10,50,80,30,"button_0_1") : SetData(widget( ), 13)
; ;   Button(10,90,80,30,"button_0_2") : SetData(widget( ), 14)
; ;   CloseList( )
; ;   ;}
  
  Define *root1._s_WIDGET = Open(#window,300,10,300-20,300-20)
  ;BindWidgetEvent( *root1, @BindEvents( ) )
  
  
  Define *root2._s_WIDGET = Open(#window,10,300,300-20,300-20)
  ;BindWidgetEvent( *root2, @BindEvents( ) )
  
  
  Define *root3._s_WIDGET = Open(#window,300,300,300-20,300-20)
  ;BindWidgetEvent( *root3, @BindEvents( ) )
  
  Define *root4._s_WIDGET = Open(#window, 590, 10, 200, 600-20)
  ;BindWidgetEvent( *root4, @BindEvents( ) )
  
  
  
  Define count = 2;0000
  #st = 1
  Global  mx=#st,my=#st
  
  Define time = ElapsedMilliseconds( )
  
  OpenList( *root1 )
  Define *panel._s_widget = Panel(20, 20, 180+40, 180+60, editable) : SetData(*panel, 100)
  AddItem( *panel, -1, "item_1" )
  SetData(Container(20, 20, 180, 180, editable), 1) 
  SetData(Container(70, 10, 70, 180, #__Flag_NoGadgets|editable), 2) 
  SetData(Container(40, 20, 180, 180, editable), 3)
  SetData(Container(20, 20, 180, 180, editable), 4)
  
  SetData(Container(5, 30, 180, 30, #__Flag_NoGadgets|editable), 5) 
  SetData(Container(5, 45, 180, 30, #__Flag_NoGadgets|editable), 6) 
  SetData(Container(5, 60, 180, 30, #__Flag_NoGadgets|editable), 7) 
  
  ;   SetData(Splitter(5, 80, 180, 50, 
  ;                    Container(0,0,0,0, #__Flag_NoGadgets|editable), 
  ;                    Container(0,0,0,0, #__Flag_NoGadgets|editable),
  ;                    #PB_Splitter_Vertical|editable), 8) 
  
  CloseList( ) ; 3
  CloseList( ) ; 4
  SetData(Container(10, 45, 70, 180, editable), 11) 
  SetData(Container(10, 10, 70, 30, #__Flag_NoGadgets|editable), 12) 
  SetData(Container(10, 20, 70, 30, #__Flag_NoGadgets|editable), 13) 
  SetData(Container(10, 30, 170, 130, #__Flag_NoGadgets|editable), 14) 
  SetData(Container(10, 45, 70, 180, editable), 111) 
  SetData(Container(10, 5, 70, 180, editable), 1111) 
  SetData(Container(10, 5, 70, 180, editable), 11111) 
  SetData(Container(10, 10, 70, 30, #__Flag_NoGadgets|editable), 12) 
  CloseList( ) ; 11111
  CloseList( ) ; 1111
  CloseList( ) ; 111
  CloseList( ) ; 11
  CloseList( ) ; 1
  AddItem( *panel, -1, "item_2" )
  Button( 10,10, 80,80, "item_2")
  AddItem( *panel, -1, "item_3" )
  Button( 20,20, 80,80, "item_3")
  AddItem( *panel, -1, "item_4" )
  Button( 30,30, 80,80, "item_4")
  AddItem( *panel, -1, "item_5" )
  Button( 40,40, 80,80, "item_5")
  CloseList( ) ; *panel
  CloseList( ) ; *root1
  
  ;
  OpenList( *root2 )
  SetData(*root2, 11 )
  Define *p3._s_WIDGET = Container( 80,80, 150,150 )
  SetData(*p3, 12 )
  SetData(Container( 40,-30, 50,50, #__Flag_NoGadgets ), 13 )
  ;;Define *p3._s_WIDGET = widget( )
  SetData(Container( 50,130, 50,50, #__Flag_NoGadgets ), 14 )
  SetData(Container( -30,40, 50,50, #__Flag_NoGadgets ), 15 )
  SetData(Container( 130,50, 50,50, #__Flag_NoGadgets ), 16 )
  CloseList( )
  CloseList( )
  
  ;   ChangeCurrentRoot( *root\root\canvas\address )
  ;   Debug ""
  ;   ForEach Widget( )
  ;     If Widget( )\parent\widget
  ;       If Widget( )\before\widget
  ;         Debug " "+ Widget( )\before\widget\data +" << "+ Widget( )\data +" >>| "+ Widget( )\last\widget\data +" - "+ Widget( )\parent\widget\last\widget\data
  ;       Else
  ;         Debug "    << "+Widget( )\data +" >>| "+ Widget( )\last\widget\data +" - "+ Widget( )\parent\widget\last\widget\data
  ;       EndIf
  ;     Else
  ;       Debug " "+Widget( )\data +" - "+ Widget( )\x +" "+ Widget( )\width
  ;     EndIf
  ;   Next
  ;   
  SetParent( *p2,*p3 )
  SetParent( *p2,*p )
  SetParent( *p2,*p3 )
  SetParent( *p2,*p )
  SetParent( *p2,*p3 )
; ; ;   ;   
; ; ;   Define parent.s = "  "
; ; ;   Define first.s = "  "
; ; ;   Define before.s = "  "
; ; ;   Define after.s = "  "
; ; ;   Define last.s = "  "
; ; ;   Define parentlast.s = "  "
; ; ;   Define parentfirst.s = "  "
; ; ;   
; ; ;   ChangeCurrentRoot(*root\root\canvas\address )
; ; ;   Debug ""
; ; ;   ForEach Widget( )
; ; ;     If Widget( )\parent\widget
; ; ;       If Widget( )\before\widget
; ; ;         before = Str( Widget( )\before\widget\data )
; ; ;       Else
; ; ;         before = "  "
; ; ;       EndIf
; ; ;       If Widget( )\after\widget
; ; ;         after = Str( Widget( )\after\widget\data )
; ; ;       Else
; ; ;         after = "  "
; ; ;       EndIf
; ; ;       
; ; ;       parent = Str( Widget( )\parent\widget\data )
; ; ;       parentfirst = Str( Widget( )\parent\widget\first\widget\data )
; ; ;       parentlast = Str( Widget( )\parent\widget\last\widget\data )
; ; ;       
; ; ;     Else
; ; ;       Debug " "+Widget( )\data +" - "+ Widget( )\x +" "+ Widget( )\width
; ; ;     EndIf
; ; ;     
; ; ;     If Widget( )\first\widget
; ; ;       first = Str( Widget( )\first\widget\data )
; ; ;     Else
; ; ;       first = "  "
; ; ;     EndIf
; ; ;     
; ; ;     Debug  " "+ parentfirst +" ||<< "+ first + " |<< " + before +" << "+ Widget( )\data +" >> "+ after +" >>| "+ Widget( )\last\widget\data +" >>|| "+ parentlast +" - "+ Widget( )\root\data +" - "+ parent
; ; ;     
; ; ;   Next
; ; ;   
; ; ;   ChangeCurrentRoot(*root0\root\canvas\address )
; ; ;   Debug ""
; ; ;   ForEach Widget( )
; ; ;     If Widget( )\parent\widget
; ; ;       Debug " "+Widget( )\class +" - "+ Widget( )\data +" - "+ Widget( )\last\widget\data +" - "+ Widget( )\parent\widget\last\widget\data
; ; ;     Else
; ; ;       Debug " "+Widget( )\data +" - "+ Widget( )\x +" "+ Widget( )\width
; ; ;     EndIf
; ; ;   Next
; ; ;   
; ; ;   Define parent.s = "  "
; ; ;   Define first.s = "  "
; ; ;   Define before.s = "  "
; ; ;   Define after.s = "  "
; ; ;   Define last.s = "  "
; ; ;   Define parentlast.s = "  "
; ; ;   Define parentfirst.s = "  "
; ; ;   
; ; ;   ChangeCurrentRoot(*root2\root\canvas\address )
; ; ;   Debug ""
; ; ;   ForEach Widget( )
; ; ;     If Widget( )\parent\widget
; ; ;       If Widget( )\before\widget
; ; ;         before = Str( Widget( )\before\widget\data )
; ; ;       Else
; ; ;         before = "  "
; ; ;       EndIf
; ; ;       If Widget( )\after\widget
; ; ;         after = Str( Widget( )\after\widget\data )
; ; ;       Else
; ; ;         after = "  "
; ; ;       EndIf
; ; ;       
; ; ;       parent = Str( Widget( )\parent\widget\data )
; ; ;       parentfirst = Str( Widget( )\parent\widget\first\widget\data )
; ; ;       parentlast = Str( Widget( )\parent\widget\last\widget\data )
; ; ;       
; ; ;     Else
; ; ;       Debug " "+Widget( )\data +" - "+ Widget( )\x +" "+ Widget( )\width
; ; ;     EndIf
; ; ;     
; ; ;     If Widget( )\first\widget
; ; ;       first = Str( Widget( )\first\widget\data )
; ; ;     Else
; ; ;       first = "  "
; ; ;     EndIf
; ; ;     
; ; ;     Debug  " "+ parentfirst +" ||<< "+ first + " |<< " + before +" << "+ Widget( )\data +" >> "+ after +" >>| "+ Widget( )\last\widget\data +" >>|| "+ parentlast +" - "+ Widget( )\root\data +" - "+ parent
; ; ;     
; ; ;   Next
; ; ;   
  
  Define i
  OpenList( *root3 )
  *w = Tree( 20,20, 100,260-20+300)
  For i=1 To 10;00000
    AddItem(*w, i, "text-"+Str(i))
  Next
  
  *w = Tree( 100,30, 100,260-20+300, #__flag_borderless)
  SetColor( *w, #__color_back, $FF07EAF6 )
  For i=1 To 10;00000
    AddItem(*w, i, "text-"+Str(i))
  Next
  
  *w = Tree( 180,40, 100,260-20+300)
  For i=1 To 100;00000
    AddItem(*w, i, "text-"+Str(i))
  Next
  
  Debug "--------  time --------- "+Str(ElapsedMilliseconds( ) - time)
  
  
  ;
  Define *window._s_WIDGET
  Define i,y = 5
  OpenList( *root4 )
  For i = 1 To 4
    Window(5, y, 150, 95+2, "Window_" + Trim(Str(i)));, #PB_Window_SystemMenu | #PB_Window_MaximizeGadget)  ; Open  i, 
    Container(5, 5, 120+2,85+2)                      ;, #PB_Container_Flat)                                                                         ; Gadget(i, 
    Button(10,10,100,30,"Button_" + Trim(Str(i+10))) ; Gadget(i+10,
    Button(10,45,100,30,"Button_" + Trim(Str(i+20))) ; Gadget(i+20,
    CloseList( )                                     ; Gadget
    y + 130
  Next
  
  ; Define Window, Gadget
  ; Debug "Begen enumerate window"
  ; If StartWindow( )
  ;   While NextWindow( @Window )
  ;     Debug "Window "+Window
  ;   Wend
  ;   AbortWindow( )
  ; EndIf
  ; ;   
  ; ;   Debug "Begen enumerate all gadget"
  ; ;   If StartGadget( )
  ; ;     While NextGadget( @Gadget )
  ; ;       Debug "Gadget "+Gadget
  ; ;     Wend
  ; ;     AbortGadget( )
  ; ;   EndIf
  ; ;   
  ; ;   Window = 8
  ; ;   
  ; ;   Debug "Begen enumerate gadget window = "+ Str(Window)
  ; ;   If StartGadget( )
  ; ;     While NextGadget( @Gadget, Window )
  ; ;       Debug "Gadget "+Str(Gadget) +" Window "+ Window
  ; ;     Wend
  ; ;     AbortGadget( )
  ; ;   EndIf
  ; ;   
  ; ;   
  ; ;   Debug "Begen enumerate alls"
  ; ;   ForEach Widget( )
  ; ;     If is_window_( widget( ) )
  ; ;       Debug "window "+ Widget( )\index
  ; ;     Else
  ; ;       Debug "  gadget - "+ Widget( )\index
  ; ;     EndIf
  ; ;   Next
  ; ;   
  ; ;  Debug "Begen enumerate window"
  ; ;   If StartEnumerate( Root( ) )
  ; ;     ;If is_window_( widget( ) )
  ; ;     Debug "window " + widget( )
  ; ; ; ;     *window = widget( )
  ; ;     ;EndIf
  ; ;     StopEnumerate( )
  ; ;   EndIf
  ; ;   
  ; ; ;   Debug "Begen enumerate all gadget"
  ; ; ;   If StartEnumerate( Root( ) )
  ; ; ;     ;If Not is_window_( widget( ) )
  ; ; ;       Debug "gadget - "+widget( )
  ; ; ;     ;EndIf
  ; ; ;     StopEnumerate( )
  ; ; ;   EndIf
  ; ;   
  ; ; ;   Define Window = 8
  ; ; ;   ;*window = GetWidget( Window )
  ; ; ;   
  ; ; ;   Debug "Begen enumerate gadget window = "+ Window
  ; ; ;   Debug "window "+ Window
  ; ; ;   If StartEnumerate( *window )
  ; ; ;     Debug "  gadget - "+ widget( )
  ; ; ;     StopEnumerate( )
  ; ; ;   EndIf
  ; ; ;   
  ; ; ;   
  ; ; ;   Debug "Begen enumerate alls"
  ; ; ;   If StartEnumerate( Root( ) )
  ; ; ;     If is_window_( widget( ) )
  ; ; ;       Debug "window "+ Widget( )\index
  ; ; ;     Else
  ; ; ;       Debug "  gadget - "+ Widget( )\index
  ; ; ;     EndIf
  ; ; ;     StopEnumerate( )
  ; ; ;   EndIf
  
  Define event, handle, enter, result
  Repeat 
    event = WaitWindowEvent( )
    If event = #PB_Event_Gadget
      If EventType( ) = #PB_EventType_MouseMove
        ;       enter = EnterGadgetID( )
        ;       
        ;       If handle <> enter
        ;         handle = enter
        ;         
        ;         ChangeCurrentRoot( handle )
        ;       EndIf
        ;             ElseIf EventType( ) = #PB_EventType_MouseEnter ; bug do't send mouse enter event then press mouse buttons
        ;               Root( ) = GetRoot( GadgetID( EventGadget( ) ) )
      EndIf
      
      ;     WidgetsEvents( EventType( ) )
    EndIf
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP