XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  EnableExplicit
  UseWidgets( )
  
  Enumeration 
    #window_0
    #window
  EndEnumeration
  
  
  ; Shows using of several panels...
  Procedure HandlerEvents( )
    Protected *this._S_widget = EventWidget( )
    Protected eventtype = WidgetEvent( )
    
    Select eventtype
        ;       Case #__event_Draw          : Debug "draw"         
      Case #__event_MouseWheelX     : Debug  " - "+ *this +" - wheel-x"
      Case #__event_MouseWheelY     : Debug  " - "+ *this +" - wheel-y"
      Case #__event_Input           : Debug  " - "+ *this +" - input"
      Case #__event_KeyDown         : Debug  " - "+ *this +" - key-down"
      Case #__event_KeyUp           : Debug  " - "+ *this +" - key-up"
      Case #__event_Focus           : Debug  " - "+ *this +" - focus"
      Case #__event_LostFocus       : Debug  " - "+ *this +" - lfocus"
      Case #__event_MouseEnter      : Debug  " - "+ *this +" - enter"
      Case #__event_MouseLeave      : Debug  " - "+ *this +" - leave"
      Case #__event_LeftDown  : Debug  " - "+ *this +" - down"
      Case #__event_DragStart       : Debug  " - "+ *this +" - drag"
      Case #__event_Drop            : Debug  " - "+ *this +" - drop"
      Case #__event_LeftUp    : Debug  " - "+ *this +" - up"
      Case #__event_LeftClick       : Debug  " - "+ *this +" - click"
      Case #__event_Left2Click : Debug  " - "+ *this +" - 2_click"
    EndSelect
  EndProcedure
  
  
  OpenWindow(#window_0, 0, 0, 424, 352, "AnchorsGadget", #PB_Window_SystemMenu )
  
  Define i
  Define *w._S_widget, *g._S_widget, editable
  Define *root._S_widget = OpenRoot(#window_0,0,0,424, 352): *root\class = "root": SetWidgetText(*root, "root")
  
  ;BindWidgetEvent( *root, @HandlerEvents( ) )
  Global view, size_value, pos_value, grid_value, back_color, frame_color, size_text, pos_text, grid_text
  view = ContainerWidget(10, 10, 406, 238, #PB_Container_Flat)
  SetWidgetColor(view, #PB_Gadget_BackColor,RGB(213,213,213))
  ;a_enable( widget( ), 15 )
  a_init( view, 15 )
  
  Define *a1._s_widget = ImageWidget( 5+170,5+140,60,60, -1 )
  Define *a2._s_widget = ContainerWidget( 50,45,135,95, #__flag_nogadgets )
  Define *a3._s_widget = ImageWidget( 150,110,60,60, -1 )
  
  ; a_init( *a, 15 )
  a_set( *a1 )
  
  CloseWidgetList()
  size_value = TrackBarWidget(56, 262, 240, 26, 0, 30)
  pos_value = TrackBarWidget(56, 292, 240, 26, 0, 30)
  grid_value = TrackBarWidget(56, 320, 240, 26, 0, 30)
  back_color = ButtonWidget(304, 264, 112, 32, "BackColor")
  frame_color = ButtonWidget(304, 304, 112, 32, "FrameColor")
  size_text = TextWidget(8, 256, 40, 24, "0")
  pos_text = TextWidget(8, 288, 40, 24, "0")
  grid_text = TextWidget(8, 320, 40, 24, "0")
  
  
  OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  
  ;{ OpenRoot0
  Define *root0._S_widget = OpenRoot(#window,10,10,300-20,300-20): *root0\class = "root0": SetWidgetText(*root0, "root0")
  ;BindWidgetEvent( *root2, @HandlerEvents( ) )
  
  Define Text.s, m.s=#LF$, a
  *g = EditorWidget(10, 10, 200+60, 200, #__flag_gridlines);, #__flag_autosize) 
  Text.s = "This is a long line." + m.s +
           "Who should show." + m.s +
           m.s +
           m.s +
           m.s +
           "I have to write the text in the box or not." + m.s +
           m.s +
           m.s +
           m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work."
  
  SetWidgetText(*g, Text.s) 
  For a = 0 To 2
    AddItem(*g, a, "Line "+Str(a))
  Next
  AddItem(*g, 7+a, "_")
  For a = 4 To 6
    AddItem(*g, a, "Line "+Str(a))
  Next 
  
  *g = StringWidget(10, 220, 200+60, 50, "string gadget text text 1234567890 text text long long very long", #PB_String_Password|#__flag_Textright)
  
  
  Define *root1._S_widget = OpenRoot(#window,300,10,300-20,300-20): *root1\class = "root1": SetWidgetText(*root1, "root1")
  ;BindWidgetEvent( *root1, @HandlerEvents( ) )
  
  
  Define *root2._S_widget = OpenRoot(#window,10,300,300-20,300-20): *root2\class = "root2": SetWidgetText(*root2, "root2")
  ;BindWidgetEvent( *root2, @HandlerEvents( ) )
  
  *w = ComboBoxWidget( 20,20, 150,40)
  For i=1 To 100;0000
    AddItem(*w, i, "text-"+Str(i))
  Next
  
  
  Define *root3._S_widget = OpenRoot(#window,300,300,300-20,300-20): *root3\class = "root3": SetWidgetText(*root3, "root3")
  ;BindWidgetEvent( *root3, @HandlerEvents( ) )
  
  Define *root4._S_widget = OpenRoot(#window, 590, 10, 200, 600-20): *root4\class = "root4": SetWidgetText(*root4, "root4")
  ;BindWidgetEvent( *root4, @HandlerEvents( ) )
  
  
  
  Define count = 2;0000
  #st = 1
  Global  mx=#st,my=#st
  
  Define time = ElapsedMilliseconds( )
  
  OpenWidgetList( *root1 )
  Define *panel._S_widget = PanelWidget(20, 20, 180+40, 180+60, editable) : SetWidgetText(*panel, "1")
  AddItem( *panel, -1, "item_1" )
  ButtonWidget( 20,20, 80,80, "item_1")
  AddItem( *panel, -1, "item_2" )
  ButtonWidget( 10,10, 80,80, "item_2")
  AddItem( *panel, -1, "item_3" )
  
  SetWidgetText(ContainerWidget(20, 20, 180, 180, editable), "4") 
  SetWidgetText(ContainerWidget(70, 10, 70, 180, #__Flag_NoGadgets|editable), "5") 
  SetWidgetText(ContainerWidget(40, 20, 180, 180, editable), "6")
  Define seven = ContainerWidget(20, 20, 180, 180, editable)
  SetWidgetText(seven, "      7")
  
  SetWidgetText(ContainerWidget(5, 30, 180, 30, #__Flag_NoGadgets|editable), "     8") 
  SetWidgetText(ContainerWidget(5, 45, 180, 30, #__Flag_NoGadgets|editable), "     9") 
  SetWidgetText(ContainerWidget(5, 60, 180, 30, #__Flag_NoGadgets|editable), "     10") 
  
  CloseWidgetList( ) ; 7
  CloseWidgetList( ) ; 6
  SetWidgetText(ContainerWidget(10, 45, 70, 180, editable), "11") 
  SetWidgetText(ContainerWidget(10, 10, 70, 30, #__Flag_NoGadgets|editable), "12") 
  SetWidgetText(ContainerWidget(10, 20, 70, 30, #__Flag_NoGadgets|editable), "13") 
  SetWidgetText(ContainerWidget(10, 30, 170, 130, #__Flag_NoGadgets|editable), "14") 
  
  SetWidgetText(ContainerWidget(10, 45, 70, 180, editable), "15") 
  SetWidgetText(ContainerWidget(10, 5, 70, 180, editable), "16") 
  SetWidgetText(ContainerWidget(10, 5, 70, 180, editable), "17") 
  SetWidgetText(ContainerWidget(10, 10, 70, 30, #__Flag_NoGadgets|editable), "18") 
  CloseWidgetList( ) ; 17
  CloseWidgetList( ) ; 16
  CloseWidgetList( ) ; 15
  CloseWidgetList( ) ; 11
  CloseWidgetList( ) ; 1
  
   OpenWidgetList( seven )
;   Define split_1 = ContainerWidget(0,0,0,0, #__Flag_NoGadgets|editable)
;   Define split_2 = ContainerWidget(0,0,0,0, #__Flag_NoGadgets|editable)
;   Define split_3 = SplitterWidget(5, 80, 180, 50,split_1,split_2,editable)
;   Define split_4 = ContainerWidget(0,0,0,0, #__Flag_NoGadgets|editable)
;   SetWidgetText(Splitter(5, 80, 180, 50,split_3,split_4,#PB_Splitter_Vertical|editable), "10-1") 
   SetWidgetText(ContainerWidget( 5, 80, 180, 50, #__Flag_NoGadgets|editable), "container-7")
  CloseWidgetList( ) ; 7
  
   OpenWidgetList( *panel )

  AddItem( *panel, -1, "item_4" )
  ButtonWidget( 30,30, 80,80, "item_4")
  AddItem( *panel, -1, "item_5" )
  ButtonWidget( 40,40, 80,80, "item_5")
  CloseWidgetList( ) ; *panel
  CloseWidgetList( ) ; *root1
  SetWidgetState( *panel, 2 )
  ;
  OpenWidgetList( *root2 )
  SetWidgetText(*root2, "*root2" )
  ;Define *p3._S_widget = ContainerWidget( 80,80, 150,150 )
  Define *p3._S_widget = ScrollAreaWidget( 80,80, 150+30,150+30, 300,300 )
  SetWidgetText(*p3, "12" )
  SetWidgetText(ContainerWidget( 40,-30, 50,50, #__Flag_NoGadgets ), "13" )
  
  Define *p2._S_widget = ContainerWidget( 40,40, 70,70 ) : SetWidgetText(*p2, "4" )
  SetWidgetText(ContainerWidget( 5,5, 70,70 ), "5" )
  SetWidgetText(ContainerWidget( -30,40, 50,50, #__Flag_NoGadgets ), "6")
  CloseWidgetList( )
  Define *c._S_widget = ContainerWidget( 40,-30, 50,50, #__Flag_NoGadgets ) : SetWidgetText(*c, "3" )
  CloseWidgetList( )
  
  SetWidgetText(ContainerWidget( 50,130, 50,50, #__Flag_NoGadgets ), "14" )
  SetWidgetText(ContainerWidget( -30,40, 50,50, #__Flag_NoGadgets ), "15" )
  SetWidgetText(ContainerWidget( 130,50, 50,50, #__Flag_NoGadgets ), "16" )
  CloseWidgetList( )
  CloseWidgetList( )
  
  OpenWidgetList( *root3 )
  *w = TreeWidget( 10,20, 150,200, #__flag_RowMultiSelect)
  For i=1 To 100;0000
    AddItem(*w, i, "text-"+Str(i))
  Next
  ContainerWidget( 70,180, 80,80): CloseWidgetList( )
  
  *w = TreeWidget( 100,30, 100,260-20+300, #__flag_borderless)
  SetWidgetColor( *w, #__color_back, $FF07EAF6 )
  For i=1 To 10;00000
    AddItem(*w, i, "text-"+Str(i))
  Next
  
  *w = TreeWidget( 180,40, 100,260-20+300)
  For i=1 To 100;0000
    AddItem(*w, i, "text-"+Str(i))
  Next
  
  Debug "--------  time --------- "+Str(ElapsedMilliseconds( ) - time)
  
  
  ;
  Define *window._S_widget
  Define i,y = 5
  OpenWidgetList( *root4 )
  For i = 1 To 4
    WindowWidget(5, y, 150, 95+2, "Window_" + Trim(Str(i)));, #PB_Window_SystemMenu | #PB_Window_MaximizeGadget)  ; Open  i, 
    ContainerWidget(5, 5, 120+2,85+2)                      ;, #PB_Container_Flat)                                                                         ; Gadget(i, 
    ButtonWidget(10,10,100,30,"Button_" + Trim(Str(i+10))) ; Gadget(i+10,
    ButtonWidget(10,45,100,30,"Button_" + Trim(Str(i+20))) ; Gadget(i+20,
    CloseWidgetList( )                                     ; Gadget
    y + 130
  Next
  
  ; 
  WaitCloseRoot( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 54
; FirstLine = 48
; Folding = -
; EnableXP
; DPIAware