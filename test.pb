XIncludeFile "widgets.pbi"
CompilerIf #PB_Compiler_IsMainFile 
  
  EnableExplicit
  UseLIB(widget)
  
  Enumeration
    #window_0
    #window
  EndEnumeration
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    LoadFont(6, "Arial", 21)
    
  CompilerElse
    LoadFont(6, "Arial", 17)
    
  CompilerEndIf
  
  ;-\\ ANCHORS
  Global view, size_value, pos_value, grid_value, back_color, frame_color, size_text, pos_text, grid_text
  
  Procedure anchor_events( )
    Protected change
    Protected *this._s_widget = EventWidget( )
    
    Select WidgetEvent( )
      Case #__event_Create
        ;       If Not *this\child
        ;        If *this\index > 0 And *this\index < 5
        ;          Debug "8476575788484 "+*this\class
        ;          a_set( *this, #__a_full )
        ;        EndIf 
        ;       EndIf 
        
      Case #__event_LeftClick
        Select *this
          Case frame_color
            
          Case back_color
            
        EndSelect
        
      Case #__event_Focus
        change = 1
        
      Case #__event_StatusChange
        Debug "a_StatusChange"
        If size_value And *this\anchors
          SetState(size_value, *this\anchors\size )
        EndIf
        
        If pos_value And *this\anchors
          SetState(pos_value, *this\anchors\pos )
        EndIf
        
        If grid_value And *this\anchors
          SetState(grid_value, mouse( )\steps )
        EndIf
        
        change = 1
        
      Case #__event_Change
        Select *this
          Case size_value
            If a_focused( )\anchors\size <> GetState(*this)
              a_set( a_focused( ), #__a_full, GetState(*this), a_focused( )\anchors\pos )
            EndIf
            
          Case pos_value
            If a_focused( )\anchors\pos <> GetState(*this)
              a_set( a_focused( ), #__a_full, a_focused( )\anchors\size, GetState(*this))
            EndIf
            
          Case grid_value
            mouse( )\steps = GetState(grid_value)
            
        EndSelect
        
        change = 1
        
    EndSelect
    
    If change
      If a_focused( )
        SetState(grid_value, mouse( )\steps )
        SetState(size_value, a_focused( )\anchors\size )
        SetState(pos_value, a_focused( )\anchors\pos )
        
        SetText(grid_text, Str(mouse( )\steps) )
        SetText(size_text, Str(a_focused( )\anchors\size) )
        SetText(pos_text, Str(a_focused( )\anchors\pos) )
      EndIf
    EndIf
    
  EndProcedure
  
  OpenWindow(#window_0, 0, 0, 424, 352, "AnchorsGadget", #PB_Window_SystemMenu )
  
  Define i
  Define *w._s_WIDGET, *g._s_WIDGET, editable.q = #__flag_BorderFlat
  Define *root._s_WIDGET = Open(#window_0, 0, 0, 424, 352): *root\class = "root": SetText(*root, "root")
  
  ;  
  ;  
  ;  Define *toolbar = ToolBar( *root )
  ;   
  ;   If *toolbar
  ;    ToolBarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
  ;    ToolBarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_Toolbar_Normal, "open")
  ;    ToolBarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"));, #PB_Toolbar_Normal, "save")
  ;    
  ;    Separator( )
  ;    
  ;    ToolBarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
  ;    ; ToolTip(*toolbar, 3, "Cut")
  ;    
  ;    ToolBarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
  ;    ; ToolTip(*toolbar, 4, "Copy")
  ;    
  ;    ToolBarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
  ;    ; ToolTip(*toolbar, 5, "Paste")
  ;    
  ;    Separator( )
  ;    
  ;    ToolBarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
  ;    ; ToolTip(*toolbar, 6, "Find a document")
  ;  EndIf
  
  ;BindWidgetEvent( *root, @HandlerEvents( ) )
  view = Container(10, 10, 406, 238, #PB_Container_Flat)
  SetColor(view, #PB_Gadget_BackColor, RGB(213, 213, 213))
  a_init( view, 8 )
  
  Define *toolbar = ToolBar( view, #PB_ToolBar_Small|#PB_ToolBar_InlineText )
  
  If *toolbar
    ToolBarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
    ToolBarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "open")
    ToolBarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"));, #PB_Toolbar_Normal, "save")
    
    Separator( )
    
    ToolBarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
    ; ToolTip(*toolbar, 3, "Cut")
    
    ToolBarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
    ; ToolTip(*toolbar, 4, "Copy")
    
    ToolBarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
    ; ToolTip(*toolbar, 5, "Paste")
    
    Separator( )
    
    ToolBarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
    ; ToolTip(*toolbar, 6, "Find a document")
  EndIf
  
  Define *a0._s_WIDGET = Button( 10, 10, 60, 60, "Button" )
  Define *a1._s_WIDGET = Panel( 5 + 170, 5 + 140, 160, 160, #__flag_nogadgets )
  ;Define *a2._s_WIDGET = Container( 50,45,135,95, #__flag_nogadgets )
  Define *a2._s_WIDGET = ScrollArea( 50, 45, 135, 95, 300, 300, 1, #__flag_nogadgets )
  Define *a3._s_WIDGET = image( 150, 110, 60, 60, -1 )
  
  a_set( *a3, -1, (10))
  
  CloseList( )
  size_value = Track(56, 262, 240, 26, 0, 30)
  pos_value  = Track(56, 292, 240, 26, 0, 30)
  grid_value = Track(56, 320, 240, 26, 0, 30)
  back_color = Button(304, 264, 112, 32, "BackColor")
  frame_color = Button(304, 304, 112, 32, "FrameColor")
  size_text  = Text(8, 256, 40, 24, "0")
  pos_text  = Text(8, 288, 40, 24, "0")
  grid_text  = Text(8, 320, 40, 24, "0")
  
  If a_focused( )
    SetState(grid_value, mouse( )\steps )
    SetState(size_value, a_focused( )\anchors\size )
    SetState(pos_value, a_focused( )\anchors\pos )
    
    SetText(grid_text, Str(mouse( )\steps) )
    SetText(size_text, Str(a_focused( )\anchors\size) )
    SetText(pos_text, Str(a_focused( )\anchors\pos) )
  EndIf
  
  
  Bind( root( ), @anchor_events( ) )
  
  ;\\Close( )
  
  
  OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ;\\ Open root0
  Define *root0._s_WIDGET = Open(#window, 10, 10, 300 - 20, 300 - 20): *root0\class = "root0": SetText(*root0, "root0")
  ;BindWidgetEvent( *root2, @HandlerEvents( ) )
  Global *menu = CreateMenuBar( *root0 ) : SetClass(*menu, "*root_MenuBar" )
  SetColor( *menu, #__color_back, $FFC8ECF0 )
  
  BarTitle("Title-1")
  BarItem(1, "title-1-item-1")
  BarSeparator( )  
  ;
  OpenBar("title-1-sub-item")
  BarItem(3, "title-1-item")
  BarSeparator( )
  ;
  OpenBar("title-2-sub-item")  
  BarItem(13, "title-2-item")
  BarSeparator( )
  ;
  OpenBar("title-3-sub-item")  
  BarItem(23, "title-3-item")
  CloseBar( ) 
  ;
  BarSeparator( )
  BarItem(14, "title-2-item")
  CloseBar( ) 
  ;
  BarSeparator( )
  BarItem(4, "title-1-item")
  CloseBar( ) 
  ;
  BarSeparator( )
  BarItem(2, "title-1-item-2")
  
  BarTitle("Title-2")
  ;  BarItem(5, "title-2-item-1")
  ;  BarItem(6, "title-2-item-2")
  
  BarTitle("Title-event-test")
  BarItem(7, "test")
  BarSeparator( )
  BarItem(8, "quit")
  
  BarTitle("Title-4")
  BarItem(9, "title-4-item-1")
  BarItem(10, "title-4-item-2")
  
  Procedure TestHandler()
    Debug "Test menu event"
  EndProcedure
  
  Procedure QuitHandler()
    Debug "Quit menu event"
    ; End
  EndProcedure
  
  Bind(*menu, @TestHandler(), -1, 7)
  Bind(*menu, @QuitHandler(), -1, 8)
  
  *menu = CreatePopupMenuBar( )
  If *menu         ; creation of the pop-up menu begins...
    BarItem(1, "Open")   ; You can use all commands for creating a menu
    BarItem(2, "Save")   ; just like in a normal menu...
    BarItem(3, "Save as")
    BarItem(4, "event-Quit")
    BarSeparator( )
    OpenBar("Recent files")
    BarItem(5, "PureBasic.exe")
    BarItem(6, "event-Test")
    CloseBar( )
  EndIf
  
  Bind(*menu, @TestHandler(), #__event_LeftClick, 6)
  Bind(*menu, @QuitHandler(), #__event_LeftClick, 4)
  
  
  ;\\
  Global *button_panel = Panel(10, 10, 200 + 60, 200)
  Define Text.s, m.s  = #LF$, a
  AddItem(*button_panel, -1, "1")
  *g = Editor(0, 0, 0, 0, #__flag_gridlines | #__flag_autosize)
  ;*g         = Editor(10, 10, 200 + 60, 200, #__flag_gridlines);, #__flag_autosize)
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
  
  SetText(*g, Text.s)
  For a = 0 To 2
    AddItem(*g, a, Str(a) + " Line " + Str(a))
  Next
  AddItem(*g, 7 + a, "_")
  For a = 4 To 6
    AddItem(*g, a, Str(a) + " Line " + Str(a))
  Next
  
  ;\\
  AddItem(*button_panel, -1, "2")
  *g = Tree(0, 0, 0, 0, #__flag_gridlines | #__flag_autosize)
  a = - 1
  AddItem(*g, a, "This is a long line.")
  AddItem(*g, a, "Who should show.")
  AddItem(*g, a, "")
  AddItem(*g, a, "")
  AddItem(*g, a, "")
  AddItem(*g, a, "I have to write the text in the box or not.")
  AddItem(*g, a, "")
  AddItem(*g, a, "")
  AddItem(*g, a, "")
  AddItem(*g, a, "The string must be very long.")
  AddItem(*g, a, "Otherwise it will not work.")
  For a = 0 To 2
    AddItem(*g, a, Str(a) + " Line " + Str(a))
  Next
  AddItem(*g, 7 + a, "_")
  For a = 4 To 6
    AddItem(*g, a, Str(a) + " Line " + Str(a))
  Next
  ;\\
  AddItem(*button_panel, -1, "3")
  *g = ListIcon(0, 0, 0, 0, "Column_1", 90, #__flag_autosize | #__Flag_FullSelection | #__Flag_GridLines | #__Flag_CheckBoxes) ;: *g = GetGadgetData(g)
  For a = 1 To 2
    AddColumn(*g, a, "Column_" + Str(a + 1), 90)
  Next
  For a = 0 To 15
    AddItem(*g, a, Str(a) + "_Column_1" + #LF$ + Str(a) + "_Column_2" + #LF$ + Str(a) + "_Column_3" + #LF$ + Str(a) + "_Column_4", 0)
  Next
  
  SetState(*button_panel, 2)
  CloseList( ) ; close panel lists
  
  *g = String(10, 220, 200, 50, "string gadget text text 1234567890 text text long long very long", #__flag_textpassword | #__text_right)
  
  ;\\
  Global *button_item1, *button_item2, *button_menu
  Procedure button_tab_events( )
    Select GetText( EventWidget( ) )
      Case "popup menu"
        DisplayPopupMenuBar( *menu, EventWidget( ) );, GetMouseX( ), GetMouseY( ) )
        
      Case "1"
        SetState(*button_panel, 0)
        SetState(*button_item2, 0)
      Case "2"
        SetState(*button_panel, 1)
        SetState(*button_item1, 0)
    EndSelect
  EndProcedure 
  
  *button_menu = Button( 120, 5, 150, 25, "popup menu")
  Bind(*button_menu, @button_tab_events( ), #__event_Down )
  *button_item1 = Button( 220, 220, 25, 50, "1", #PB_Button_Toggle)
  *button_item2 = Button( 220 + 25, 220, 25, 50, "2", #PB_Button_Toggle)
  Bind(*button_item1, @button_tab_events( ), #__event_Down )
  Bind(*button_item2, @button_tab_events( ), #__event_Down )
  ;\\Close( )
  
  ;\\
  Define *root1._s_WIDGET = Open(#window, 300, 10, 300 - 20, 300 - 20): *root1\class = "root1": SetText(*root1, "root1")
  ;BindWidgetEvent( *root1, @HandlerEvents( ) )
  
  ;\\Close( )
  
  Define *root2._s_WIDGET = Open(#window, 10, 300, 300 - 20, 300 - 20): *root2\class = "root2": SetText(*root2, "root2")
  ;BindWidgetEvent( *root2, @HandlerEvents( ) )
  
  HyperLink( 10, 10, 80, 40, "HyperLink", RGB(105, 245, 44) )
  String( 60, 20, 60, 40, "String" )
  *w = ComboBox( 108, 30, 152, 40, #PB_ComboBox_Editable )
  For i = 1 To 100;0000
    AddItem(*w, i, "text-" + Str(i))
  Next
  SetState( *w, 3 )
  ;\\Close( )
  
  
  Define *root3._s_WIDGET = Open(#window, 300, 300, 300 - 20, 300 - 20): *root3\class = "root3": SetText(*root3, "root3")
  ;BindWidgetEvent( *root3, @HandlerEvents( ) )
  ;\\Close( )
  
  Define *root4._s_WIDGET = Open(#window, 590, 10, 200, 600 - 20): *root4\class = "root4": SetText(*root4, "root4")
  ;BindWidgetEvent( *root4, @HandlerEvents( ) )
  ;\\Close( )
  
  
  
  Define count = 2;0000
  #st     = 1
  Global mx  = #st, my = #st
  
  Define time = ElapsedMilliseconds( )
  
  Global *c, *p, *panel._s_WIDGET
  Procedure hide_show_panel_events( )
    Select WidgetEvent( )
      Case #__event_LeftClick
        
        Select GetText( EventWidget( ) )
          Case "hide_children"
            hide(*p, 1)
            ; Disable(*c, 1)
            
          Case "show_children"
            hide(*p, 0)
            
          Case "hide_parent"
            hide(*c, GetState( EventWidget( ) ))
            
        EndSelect
        
        ;     ;Case #__event_LeftButtonUp
        ;     ClearDebugOutput( )
        ;     If StartEnumerate(*panel);root( ))
        ;      If Not hide(widget( )) ;And GetParent(widget( )) = *panel
        ;       Debug " class - " + widget( )\Class ;+" ("+ widget( )\item +" - parent_item)"
        ;      EndIf
        ;      StopEnumerate( )
        ;     EndIf
        
        
    EndSelect
  EndProcedure
  
  OpenList( *root1 )
  *panel = Panel(20, 20, 180 + 40, 180 + 60, editable) : SetText(*panel, "1")
  AddItem( *panel, -1, "item_1" )
  ;Button( 20,20, 80,80, "item_1")
  *g = Editor(0, 0, 0, 0, #__flag_autosize)
  For a = 0 To 2
    AddItem(*g, a, "Line " + Str(a))
  Next
  AddItem(*g, 3 + a, "")
  AddItem(*g, 4 + a, ~"define W_0 = Window( 282, \"Window_0\" )")
  AddItem(*g, 5 + a, "")
  For a = 6 To 8
    AddItem(*g, a, "Line " + Str(a))
  Next
  
  AddItem( *panel, -1, "(hide&show)-test" ) : SetItemFont(*panel, 1, 6)
  ; Button( 10,10, 80,80, "item_2")
  Bind(CheckBox( 5, 5, 95, 22, "hide_parent"), @hide_show_panel_events( ))
  Bind(Option( 5, 30, 95, 22, "hide_children"), @hide_show_panel_events( ))
  Bind(Option( 5, 55, 95, 22, "show_children", #PB_Button_Toggle ), @hide_show_panel_events( ))
  ;SetState(widget( ), 1)
  
  *c = Panel(110, 5, 150, 155)
  AddItem(*c, -1, "0")
  *p = Panel(10, 5, 150, 65)
  AddItem(*p, -1, "item-1")
  Container(10, 5, 150, 55, #PB_Container_Flat)
  Container(10, 5, 150, 55, #PB_Container_Flat)
  Button(10, 5, 50, 25, "butt1")
  CloseList( )
  CloseList( )
  AddItem(*p, -1, "item-2")
  Container(10, 5, 150, 55, #PB_Container_Flat)
  Container(10, 5, 150, 55, #PB_Container_Flat)
  Button(10, 5, 50, 25, "butt2")
  CloseList( )
  CloseList( )
  AddItem(*c, -1, "1")
  CloseList( )
  
  Container(10, 75, 150, 55, #PB_Container_Flat)
  Container(10, 5, 150, 55, #PB_Container_Flat)
  Container(10, 5, 150, 55, #PB_Container_Flat)
  Button(10, 5, 50, 45, "butt1")
  CloseList( )
  CloseList( )
  CloseList( )
  CloseList( )
  
  AddItem( *panel, -1, "(enter&leave)-test" )
  
  Procedure enter_leave_containers_events( )
    Protected repaint
    Protected colorback = colors::*this\blue\fore,
              colorframe = colors::*this\blue\frame,
              colorback1 = $ff00ff00,
              colorframe1 = $ff0000ff
    
    Select WidgetEvent( )
      Case #__event_MouseEnter,
           #__event_MouseLeave,
           #__event_MouseMove
        
        If EventWidget( ) <> root( )
          If EventWidget( )\mouseenter
            If EventWidget( )\color\frame <> colorframe1
              repaint          = 1
              EventWidget( )\color\frame = colorframe1
            EndIf
            
            If MouseEnter( EventWidget( ) )
              If EventWidget( )\color\back <> colorback1
                repaint          = 1
                EventWidget( )\color\back = colorback1
              EndIf
            Else
              If EventWidget( )\color\back = colorback1
                repaint          = 1
                EventWidget( )\color\back = colorback
              EndIf
            EndIf
          Else
            If EventWidget( )\color\back <> colorback
              repaint          = 1
              EventWidget( )\color\back = colorback
            EndIf
            If EventWidget( )\color\frame = colorframe1
              repaint          = 1
              EventWidget( )\color\frame = colorframe
            EndIf
          EndIf
        EndIf
        
    EndSelect
    
    If repaint
      ; Debug "change state"
    EndIf
  EndProcedure
  
  SetText(ScrollArea(5, 5, 210, 210, 500, 500, 1, editable), "4")
  SetText(Container(70, 10, 70, 180, #__Flag_NoGadgets | editable), "5")
  SetText(Container(40, 20, 180, 180, editable), "6")
  Define seven = Container(20, 20, 180, 180, editable)
  SetText(seven, "   7")
  
  SetText(Container(5, 30, 180, 30, #__Flag_NoGadgets | editable), "   8")
  SetText(Container(5, 45, 180, 30, #__Flag_NoGadgets | editable), "   9")
  SetText(Container(5, 60, 180, 30, #__Flag_NoGadgets | editable), "   10")
  
  CloseList( ) ; 7
  CloseList( ) ; 6
  SetText(Container(10, 45, 70, 180, editable), "11")
  SetText(Container(10, 10, 70, 30, #__Flag_NoGadgets | editable), "12")
  SetText(Container(10, 20, 70, 30, #__Flag_NoGadgets | editable), "13")
  SetText(Container(10, 30, 170, 130, #__Flag_NoGadgets | editable), "14")
  
  SetText(Container(10, 45, 70, 180, editable), "15")
  SetText(Container(10, 5, 70, 180, editable), "16")
  SetText(Container(10, 5, 70, 180, editable), "17")
  SetText(Container(10, 10, 70, 30, #__Flag_NoGadgets | editable), "18")
  CloseList( ) ; 17
  CloseList( ) ; 16
  CloseList( ) ; 15
  CloseList( ) ; 11
  CloseList( ) ; 1
  
  ;\\
  OpenList( seven )
  ;  Define split_1 = Container(0,0,0,0, #__Flag_NoGadgets|editable)
  ;  Define split_2 = Container(0,0,0,0, #__Flag_NoGadgets|editable)
  ;  Define split_3 = Splitter(5, 80, 180, 50,split_1,split_2,editable)
  ;  Define split_4 = Container(0,0,0,0, #__Flag_NoGadgets|editable)
  ;  SetText(Splitter(5, 80, 180, 50,split_3,split_4,#PB_Splitter_Vertical|editable), "10-1")
  SetText(Container( - 5, 80, 180, 50, #__Flag_NoGadgets | editable), "container-7")
  CloseList( ) ; 7
  
  ;\\
  If *panel\root
    If StartEnumerate( *panel, 2 )
      Bind(widget( ), @enter_leave_containers_events( ), #__event_MouseEnter)
      Bind(widget( ), @enter_leave_containers_events( ), #__event_MouseMove)
      Bind(widget( ), @enter_leave_containers_events( ), #__event_MouseLeave)
      StopEnumerate( )
    EndIf
  EndIf
  
  ;\\
  ;OpenList( *panel )
  AddItem( *panel, -1, "item_4" )
  Button( 30, 30, 80, 80, "item_4")
  AddItem( *panel, -1, "item_5" )
  Button( 40, 40, 80, 80, "item_5")
  CloseList( ) ; *panel
  CloseList( ) ; *root1
  
  ; SetState( *panel, 2 )
  
  ;\\\
  OpenList( *root2 )
  SetText(*root2, "*root2" )
  ;  ;Define *p3._s_WIDGET = Container( 80,80, 150,150 )
  ;  Define *p3._s_WIDGET = ScrollArea( 80,80, 150+30,150+30, 300,300 )
  ;  SetText(*p3, "12" )
  ;  SetText(Container( 40,-30, 50,50, #__Flag_NoGadgets ), "13" )
  ;
  ;  Define *p2._s_WIDGET = Container( 40,40, 70,70 ) : SetText(*p2, "4" )
  ;  SetText(Container( 5,5, 70,70 ), "5" )
  ;  SetText(Container( -30,40, 50,50, #__Flag_NoGadgets ), "6")
  ;  CloseList( )
  ;  Define *c1._s_WIDGET = Container( 40,-30, 50,50, #__Flag_NoGadgets ) : SetText(*c1, "3" )
  ;  CloseList( )
  ;
  ;  SetText(Container( 50,130, 50,50, #__Flag_NoGadgets ), "14" )
  ;  SetText(Container( -30,40, 50,50, #__Flag_NoGadgets ), "15" )
  ;  SetText(Container( 130,50, 50,50, #__Flag_NoGadgets ), "16" )
  ;  CloseList( )
  ;  CloseList( )
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4, Splitter_5
  ;  Button_0 = Button(0, 0, 0, 0, "Button 0") ; as they will be sized automatically
  ;  Button_1 = Button(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  ;  Splitter_0 = widget::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
  
  
  Button_2 = ComboBox( 20, 20, 150, 40)
  For i = 1 To 100;0000
    AddItem(Button_2, i, "text-" + Str(i))
  Next
  SetState( Button_2, 3 )
  
  ;Button_2 = Button(0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
  Button_3  = Button(0, 0, 0, 0, "Button 3") ; as they will be sized automatically
  Splitter_1 = widget::Splitter(0, 0, 0, 0, Button_2, Button_3, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
  widget::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
  widget::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
  ;Button_4 = Button(0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
  Button_4  = Progress(0, 0, 0, 0, 0, 100) : SetState(Button_4, 50) ; No need to specify size or coordinates
  Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, Button_4)
  Button_5  = Button(0, 0, 0, 0, "Button 5") ; as they will be sized automatically
  Splitter_3 = widget::Splitter(0, 0, 0, 0, Button_5, Splitter_2)
  Splitter_4 = widget::Splitter(0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
  Splitter_5 = widget::Splitter(10, 80, 250, 120, 0, Splitter_4, #PB_Splitter_Vertical)
  SetState(Splitter_5, 50)
  SetState(Splitter_4, 50)
  SetState(Splitter_3, 40)
  SetState(Splitter_1, 50)
  
  Spin(10, 210, 250, 25, 25, 30, #__text_right )
  Spin(10, 240, 250, 25, 5, 30, #__spin_Plus)
  
  ;\\
  OpenList( *root3 )
  Define *tree = Tree( 10, 20, 150, 200, #__tree_checkboxes)
  For i = 1 To 100;0000
    AddItem(*tree, i, "text-" + Str(i))
  Next
  SetState(*tree, 5 - 1)
  Container( 70, 180, 80, 80): CloseList( )
  SetItemFont(*tree, 1, 6)
  SetItemFont(*tree, 4, 6)
  
  ;\\
  *w = Tree( 100, 30, 100, 260 - 20 + 300, #__flag_borderless | #__flag_multiselect) ; |#__flag_gridlines
  SetColor( *w, #__color_back, $FF07EAF6 )
  For i = 1 To 10;00000
    AddItem(*w, i, "text-" + Str(i))
  Next
  SetState(*w, i - 1 )
  SetItemFont(*w, 4, 6)
  SetItemFont(*w, 5, 6)
  
  ;\\
  *w = Tree( 180, 40, 100, 260 - 20 + 300, #__flag_clickselect )
  For i = 1 To 100;0000
    If (i & 5)
      AddItem(*w, i, "text-" + Str(i), -1, 1 )
    Else
      AddItem(*w, i, "text-" + Str(i))
    EndIf
  Next
  SetFont(*w, 6)
  
  Debug "-------- time --------- " + Str(ElapsedMilliseconds( ) - time)
  
  
  ;\\
  Define *window._s_WIDGET
  Define i, y = 5
  OpenList( *root4 )
  For i = 1 To 4
    Window(5, y, 150, 95 + 2, "Window_" + Trim(Str(i)), #PB_Window_SystemMenu | #PB_Window_MaximizeGadget)
    ;Container(5, y, 150, 95 + 2)
    If i = 2
      Disable( widget( ), 1)
    EndIf
    Container(5, 5, 120 + 2, 85 + 2) ;, #PB_Container_Flat)
    If i = 3
      CheckBox(10, 10, 100, 30, "CheckBox_" + Trim(Str(i + 10)))
      SetState( widget( ), 1 )
    ElseIf i = 4
      Option(10, 10, 100, 30, "Option_" + Trim(Str(i + 10)))
    Else
      Button(10, 10, 100, 30, "Button_" + Trim(Str(i + 10)))
    EndIf
    If i = 3
      Disable( widget( ), 1)
    EndIf
    If i = 4 Or i = 3
      Option(10, 45, 100, 30, "Option_" + Trim(Str(i + 20)))
      SetState( widget( ), 1 )
    Else
      Button(10, 45, 100, 30, "Button_" + Trim(Str(i + 20)))
    EndIf
    If i = 3
      Disable( widget( ), 1)
    EndIf
    CloseList( )
    ;CloseList( )
    y + 130
  Next
  
  WaitClose( )
  
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 630
; FirstLine = 609
; Folding = --------
; EnableXP
; DPIAware