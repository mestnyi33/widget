XIncludeFile "../../../-widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  EnableExplicit
  UseLIB(widget)
  
  Enumeration 
    #window_0
    #window_1
  EndEnumeration
  
  Procedure BindWidgetEvent( *this._s_widget, *callback )
    Bind( *this, *callback )
  EndProcedure
  
  
  ; Shows using of several panels...
  Procedure BindEvents( )
    Protected *this._s_WIDGET = EventWidget( )
    Protected levellen = 4
    Protected level = *this\level - 1
    Protected eventtype = WidgetEventType( )
    
    Select eventtype
        ;       Case #PB_EventType_Draw          : Debug "draw"         
      Case #PB_EventType_ScrollChange    : Debug  Space( level*levellen ) + " - "+ *this\data +" - scroll-change"
      Case #PB_EventType_StatusChange    : Debug  Space( level*levellen ) + " - "+ *this\data +" - status-change"
      Case #PB_EventType_MouseWheelX     : Debug  Space( level*levellen ) + " - "+ *this\data +" - wheel-x"
      Case #PB_EventType_MouseWheelY     : Debug  Space( level*levellen ) + " - "+ *this\data +" - wheel-y"
      Case #PB_EventType_Input           : Debug  Space( level*levellen ) + " - "+ *this\data +" - input"
        
      Case #PB_EventType_KeyDown         : Debug  Space( level*levellen ) + " - "+ *this\data +" - key-down"
      Case #PB_EventType_KeyUp           : Debug  Space( level*levellen ) + " - "+ *this\data +" - key-up"
        ClearDebugOutput()
        
      Case #PB_EventType_Focus           : Debug  Space( level*levellen ) + " - "+ *this\data +" - focus"
      Case #PB_EventType_LostFocus       : Debug  Space( level*levellen ) + " - "+ *this\data +" - lfocus"
      Case #PB_EventType_MouseEnter      : Debug  Space( level*levellen ) + " - "+ *this\data +" - enter"
      Case #PB_EventType_MouseLeave      : Debug  Space( level*levellen ) + " - "+ *this\data +" - leave"
      Case #PB_EventType_LeftButtonDown  : Debug  Space( level*levellen ) + " - "+ *this\data +" - down"
      Case #PB_EventType_DragStart       : Debug  Space( level*levellen ) + " - "+ *this\data +" - drag"
      Case #PB_EventType_Drop            : Debug  Space( level*levellen ) + " - "+ *this\data +" - drop"
      Case #PB_EventType_LeftButtonUp    : Debug  Space( level*levellen ) + " - "+ *this\data +" - up"
      Case #PB_EventType_LeftClick       : Debug  Space( level*levellen ) + " - "+ *this\data +" - click"
      Case #PB_EventType_LeftDoubleClick : Debug  Space( level*levellen ) + " - "+ *this\data +" - 2_click"
    EndSelect
    
  EndProcedure
  
  Procedure AddContainer( )
    Define i
    Define id = Root( )\data
    SetData(Container( 80,80, 150,150 ), Val(Str( id )+"1") ) : BindWidgetEvent( widget(), @BindEvents( ) )
    SetData(Container( 40,-30, 50,50, #__Flag_NoGadgets ), Val(Str( id )+"2") ) : BindWidgetEvent( widget(), @BindEvents( ) )
    ;       SetData(Container( 40,40, 70,70 ), 13*id ) : i = 1 : BindWidgetEvent( widget(), @BindEvents( ) )
    ;         SetData(Container( 5,5, 70,70 ), 14*id ) : i = 2 : BindWidgetEvent( widget(), @BindEvents( ) )
    SetData(Container( -30,40, 50,50, #__Flag_NoGadgets ), Val(Str( id )+Str(3+i))) : BindWidgetEvent( widget(), @BindEvents( ) )
    ;         CloseList( )
    ;       CloseList( )
    SetData(Container( 50,130, 50,50, #__Flag_NoGadgets ), Val(Str( id )+Str(4+i))) : BindWidgetEvent( widget(), @BindEvents( ) )
    SetData(Container( 130,50, 50,50, #__Flag_NoGadgets ), Val(Str( id )+Str(5+i))) : BindWidgetEvent( widget(), @BindEvents( ) )
    CloseList( )
    
    
  EndProcedure
  
  
  OpenWindow(#window_0, 0, 0, 300, 300, "PanelGadget", #PB_Window_SystemMenu )
  
  OpenWindow(#window_1, 0, 0, 590, 620, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  
  
  Define *root._s_WIDGET = Open(#window_0,10,10,300-20,300-20) : SetData(*root, 1 )
  BindWidgetEvent( *root, @BindEvents( ) )
  
  
  Define *root0._s_WIDGET = Open(#window_1,10,10,570,310) : SetData(*root0, 2 )
  BindWidgetEvent( *root0, @BindEvents( ) )
  
  
  Define *root1._s_WIDGET = Open(#window_1,10,330,280,280) : SetData(*root1, 3 )
  BindWidgetEvent( *root1, @BindEvents( ) )
  
  
  Define *root2._s_WIDGET = Open(#window_1,300,330,280,280) : SetData(*root2, 4 )
  BindWidgetEvent( *root2, @BindEvents( ) )
  
  
  ;
  OpenList( *root )
  AddContainer( )
  CloseList( ) ; *root
  
  ;
  OpenList( *root0 )
  
  Define i,*panel._s_WIDGET = Panel( 10,10, *root0\width-20, *root0\height-20)
  For i = 0 To 20
    AddItem( *panel, -1, "demo-"+Str(i))
  Next
  
  SetState(*panel, 8)
  OpenList( *panel, 8 )
;   Button(10,-20,200,200,"butt")
;   Button(110,90,200,200,"butt")
  
  Define *w = Tree( 10,-20,200,200) : SetData(*w, 21 )
  For i=1 To 10;00000
    AddItem(*w, i, "tree-item-text-"+Str(i))
  Next
  BindWidgetEvent( *w, @BindEvents( ) )
  
  Define *w = Tree( 110,20,200,210) : SetData(*w, 22 )
  For i=1 To 20;00000
    AddItem(*w, i, "tree-item-text-"+Str(i))
  Next
  BindWidgetEvent( *w, @BindEvents( ) )
  
  ; CloseList()
  
; ;   AddItem( *panel, -1, "demo-1")
; ;   Define *scrollarea = ScrollArea( 10,10, *panel\width-20, *panel\height-20, 1000,1000,1)
; ;   Define *Button_0 = Button(5, 5, 160,95, "Multiline Button"+" (longer text gets automatically multiline)", #__button_multiLine ) 
; ;   Define *String_0 = String(5, 105, 160,95, "String set"+#LF$+"multi"+#LF$+"line"+#LF$+"text")                                 
; ;   Define *Text_0 = Text(5, 205, 160,95, "Text"+#LF$+"set"+#LF$+"multi"+#LF$+"line"+#LF$+"text", #__text_border)        
; ;   Define *CheckBox_0 = CheckBox(5, 305, 160,95, "CheckBox", #PB_CheckBox_ThreeState) : SetState(*CheckBox_0, #PB_Checkbox_Inbetween)
; ;   Define *Option_0 = Option(5, 405, 160,95, "Option" ) : SetState(*Option_0, 1)                                                       
; ;   Define i,*ListView_0 = ListView(5, 505, 160,95) : AddItem(*ListView_0, -1, "ListView") : For i=1 To 5 : AddItem(*ListView_0, i, "item_"+Hex(i)) : Next
; ;   ;     
; ;   Define *Frame_0 = Frame(170, 5, 160,95, "Frame_"+Hex(#PB_GadgetType_Frame) )
; ;   Define *ComboBox_0 = ComboBox(170, 105, 160,95) : AddItem(*ComboBox_0, -1, "ComboBox") : For i=1 To 5 : AddItem(*ComboBox_0, i, "item_"+Hex(i)) : Next : SetState(*ComboBox_0, 0) 
; ;   ;Define *Image_0 = Image(170, 205, 160,95, img, #PB_Image_Border ) 
; ;   Define *HyperLink_0 = HyperLink(170, 305, 160,95,"HyperLink", $00FF00, #PB_HyperLink_Underline ) 
; ;   Define *Container_0 = Container(170, 405, 160,95, #PB_Container_Flat )
; ;   Define *Option_101 = Option(10, 10, 110,20, "Container_0" )  : SetState(*Option_101, 1)  
; ;   Define *Option_102 = Option(10, 40, 110,20, "Option_widget");, #__flag_flat)  
; ;   CloseList()                                                 ; *Container_0
; ;   CloseList( )                                                ; *scrollarea
; ;   
; ;   AddItem( *panel, -1, "demo-2")
; ;   AddItem( *panel, -1, "demo-3")
; ;   AddItem( *panel, -1, "demo-4")
; ;   AddItem( *panel, -1, "demo-5")
; ;   AddItem( *panel, -1, "demo-6")
  CloseList( ) ; *panel
  
  CloseList( ) ; *root0
  
  ;
  CloseList( ) ; *root2
  AddContainer( ) ; add *root1
  
  
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