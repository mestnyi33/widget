XIncludeFile "../../../-widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  EnableExplicit
  UseLIB(widget)
  
  Enumeration 
    #window_0
    #window
  EndEnumeration
  
  Macro OpenCanvas( window,gadget, x,y,width,height )
    Open(  window, x,y,width,height )
  EndMacro
  
  Procedure BindWidgetEvent( this, callback )
    Bind( this, callback )
  EndProcedure
  
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
  
  
  Define *w, editable
  Define *root._s_WIDGET = OpenCanvas(#window_0,-1, 10,10,300-20,300-20)
  ;BindWidgetEvent( *root, @BindEvents( ) )
  
  Container( 80,80, 150,150 )
  Container( 40,-30, 50,50, #__Flag_NoGadgets )
  Container( 50,130, 50,50, #__Flag_NoGadgets )
  Container( -30,40, 50,50, #__Flag_NoGadgets )
  Container( 130,50, 50,50, #__Flag_NoGadgets )
  CloseList( )
  CloseList( )
  
  OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  
  Define *w, editable
  Define *root1._s_WIDGET = OpenCanvas(#window,-1, 10,10,300-20,300-20)
  ;BindWidgetEvent( *root1, @BindEvents( ) )
  
  
  Define *root2._s_WIDGET = OpenCanvas(#window,-1, 10,300,300-20,300-20)
  ;BindWidgetEvent( *root2, @BindEvents( ) )
  
  
  Define *root3._s_WIDGET = OpenCanvas(#window,-1, 300,10,300-20,600-20)
  ;BindWidgetEvent( *root3, @BindEvents( ) )
  
  Define *root4._s_WIDGET = OpenCanvas(#window,-1, 590, 10, 200, 600-20)
  ;BindWidgetEvent( *root4, @BindEvents( ) )
  
  
  
  Define count = 2;0000
  #st = 1
  Global  mx=#st,my=#st
  
  Define time = ElapsedMilliseconds( )
  
  OpenList( *root1 )
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
  
  CloseList( )
  CloseList( )
  SetData(Container(10, 45, 70, 180, editable), 11) 
  SetData(Container(10, 10, 70, 30, #__Flag_NoGadgets|editable), 12) 
  SetData(Container(10, 20, 70, 30, #__Flag_NoGadgets|editable), 13) 
  SetData(Container(10, 30, 170, 130, #__Flag_NoGadgets|editable), 14) 
  SetData(Container(10, 45, 70, 180, editable), 11) 
  SetData(Container(10, 5, 70, 180, editable), 11) 
  SetData(Container(10, 5, 70, 180, editable), 11) 
  SetData(Container(10, 10, 70, 30, #__Flag_NoGadgets|editable), 12) 
  CloseList( )
  CloseList( )
  CloseList( )
  CloseList( )
  
  ;
  OpenList( *root2 )
  Container( 80,80, 150,150 )
  Container( 40,-30, 50,50, #__Flag_NoGadgets )
  Container( 50,130, 50,50, #__Flag_NoGadgets )
  Container( -30,40, 50,50, #__Flag_NoGadgets )
  Container( 130,50, 50,50, #__Flag_NoGadgets )
  CloseList( )
  CloseList( )
  
  Define i
  OpenList( *root3 )
  *w = Tree( 20,20, 100,260-20+300)
  For i=1 To 10;00000
    AddItem(*w, i, "text-"+Str(i))
  Next
  
  *w = Tree( 100,30, 100,260-20+300)
  For i=1 To 10;00000
    AddItem(*w, i, "text-"+Str(i))
  Next
  
  Debug "time - "+Str(ElapsedMilliseconds( ) - time)
  
  
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
  
  
  Define event, handle, enter, result
  Repeat 
    event = WaitWindowEvent( )
    If event = #PB_Event_Widget
      Select EventType( )
          ;       Case #PB_EventType_Draw          : Debug "draw"         
        Case #PB_EventType_MouseWheelX     : Debug  " -- "+ EventWidget( ) +" - wheel-x"
        Case #PB_EventType_MouseWheelY     : Debug  " -- "+ EventWidget( ) +" - wheel-y"
        Case #PB_EventType_Input           : Debug  " -- "+ EventWidget( ) +" - input"
        Case #PB_EventType_KeyDown         : Debug  " -- "+ EventWidget( ) +" - key-down"
        Case #PB_EventType_KeyUp           : Debug  " -- "+ EventWidget( ) +" - key-up"
        Case #PB_EventType_Focus           : Debug  " -- "+ EventWidget( ) +" - focus"
        Case #PB_EventType_LostFocus       : Debug  " -- "+ EventWidget( ) +" - lfocus"
        Case #PB_EventType_MouseEnter      : Debug  " -- "+ EventWidget( ) +" - enter"
        Case #PB_EventType_MouseLeave      : Debug  " -- "+ EventWidget( ) +" - leave"
        Case #PB_EventType_LeftButtonDown  : Debug  " -- "+ EventWidget( ) +" - down"
        Case #PB_EventType_DragStart       : Debug  " -- "+ EventWidget( ) +" - drag"
        Case #PB_EventType_Drop            : Debug  " -- "+ EventWidget( ) +" - drop"
        Case #PB_EventType_LeftButtonUp    : Debug  " -- "+ EventWidget( ) +" - up"
        Case #PB_EventType_LeftClick       : Debug  " -- "+ EventWidget( ) +" - click"
        Case #PB_EventType_LeftDoubleClick : Debug  " -- "+ EventWidget( ) +" - 2_click"
      EndSelect
    EndIf
    If event = #PB_Event_Gadget
      ;     If EventType( ) = #PB_EventType_MouseMove
      ;       enter = EnterGadgetID( )
      ;       
      ;       If handle <> enter
      ;         handle = enter
      ;         
      ;         ChangeCurrentRootWidget( handle )
      ;       EndIf
      ;       ;       ElseIf EventType( ) = #PB_EventType_MouseEnter ; bug do't send mouse enter event then press mouse buttons
      ;       ;         RootWidget( ) = GetRootWidget( GadgetID( EventGadget( ) ) )
      ;     EndIf
      ;     
      ;     WidgetsEvents( EventType( ) )
    EndIf
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP