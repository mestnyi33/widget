XIncludeFile "../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile 
  
  EnableExplicit
  UseLIB(widget)
  
  test_draw_repaint = 1
  
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
        ;             If Not *this\child
        ;                If *this\index > 0 And  *this\index < 5
        ;                   Debug "8476575788484 "+*this\class
        ;                   a_set( *this, #__a_full )
        ;                EndIf 
        ;             EndIf 
        
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
  ;    Define *toolbar = ToolBar( *root )
  ;     
  ;     If *toolbar
  ;       ToolBarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
  ;       ToolBarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_Toolbar_Normal, "open")
  ;       ToolBarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"));, #PB_Toolbar_Normal, "save")
  ;       
  ;       Separator( )
  ;       
  ;       ToolBarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
  ;       ; ToolTip(*toolbar, 3, "Cut")
  ;       
  ;       ToolBarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
  ;       ; ToolTip(*toolbar, 4, "Copy")
  ;       
  ;       ToolBarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
  ;       ; ToolTip(*toolbar, 5, "Paste")
  ;       
  ;       Separator( )
  ;       
  ;       ToolBarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
  ;       ; ToolTip(*toolbar, 6, "Find a document")
  ;    EndIf


  ;BindWidgetEvent( *root, @HandlerEvents( ) )
  view = Container(10, 10, 406, 238, #PB_Container_Flat)
  SetColor(view, #PB_Gadget_BackColor, RGB(213, 213, 213))
  a_init( view, 8 )

  Define *a0._s_WIDGET = Button( 10, 10, 60, 60, "Button" )
  CloseList( )
  
;   Define *toolbar ;= ToolBar( view, #PB_ToolBar_Small|#PB_ToolBar_InlineText )
;   
;   If *toolbar
;     ToolBarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
;     ToolBarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "open")
;     ToolBarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"));, #PB_Toolbar_Normal, "save")
;     
;     Separator( )
;     
;     ToolBarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
;     ; ToolTip(*toolbar, 3, "Cut")
;     
;     ToolBarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
;     ; ToolTip(*toolbar, 4, "Copy")
;     
;     ToolBarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
;     ; ToolTip(*toolbar, 5, "Paste")
;     
;     Separator( )
;     
;     ToolBarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
;     ; ToolTip(*toolbar, 6, "Find a document")
;   EndIf
;   
;   
  a_set( *a0, -1, 10)

  
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
  
  a_set( *a3, -1, 10)
  
  CloseList( )
  size_value  = Track(56, 262, 240, 26, 0, 30)
  pos_value   = Track(56, 292, 240, 26, 0, 30)
  grid_value  = Track(56, 320, 240, 26, 0, 30)
  back_color  = Button(304, 264, 112, 32, "BackColor")
  frame_color = Button(304, 304, 112, 32, "FrameColor")
  size_text   = Text(8, 256, 40, 24, "0")
  pos_text    = Text(8, 288, 40, 24, "0")
  grid_text   = Text(8, 320, 40, 24, "0")
  
  If a_focused( )
    SetState(grid_value, mouse( )\steps )
    SetState(size_value, a_focused( )\anchors\size )
    SetState(pos_value, a_focused( )\anchors\pos )
    
    SetText(grid_text, Str(mouse( )\steps) )
    SetText(size_text, Str(a_focused( )\anchors\size) )
    SetText(pos_text, Str(a_focused( )\anchors\pos) )
  EndIf
  
  
  Bind( Root( ), @anchor_events( ) )
  
  OpenWindow(#window, 0, 0, 400, 300, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
 
  ;\\ Open Root0
  Define *root0._s_WIDGET = Open(#window, 10, 10, 300 - 20, 300 - 20): *root0\class = "root0": SetText(*root0, "root0")
  ;BindWidgetEvent( *root2, @HandlerEvents( ) )
  Global *menu._S_WIDGET = CreateMenuBar( *root0 ) : SetClass(*menu, "*root_MenuBar" )
  
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
  ;    BarItem(5, "title-2-item-1")
  ;    BarItem(6, "title-2-item-2")
  
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
  

  Define i, *combobox._S_WIDGET = ComboBox( 10, 125, 120, 25)
   AddItem(*combobox, -1, "combo")
   For i = 0 To 9
      AddItem(*combobox, -1, "item_"+Str(i))
   Next
   SetState(*combobox, 0)
   
   Repaint(root( ))
   
   
   DisplayPopupMenuBar( *combobox\PopupBar( ), *menu, 10, 190 )
   ;DisplayPopupMenuBar( *combobox\PopupBar( ), *combobox, 10, 150 )
   
;   
;   SetActive( *menu )
;   SetActiveGadget( *menu\root\canvas\gadget )
;   
;   SelectElement(*menu\__tabs( ), 0)
;   ;*menu\__tabs( )\focus = 1
;   *menu\FocusedTab( ) = *menu\__tabs( )
;   
;   DisplayPopupMenuBar( *menu\__tabs( )\menu, root(), 10, 32 )
  
;    
;   *menu = CreatePopupMenuBar( )
;   If *menu                  ; creation of the pop-up menu begins...
;     BarItem(1, "Open")      ; You can use all commands for creating a menu
;     BarItem(2, "Save")      ; just like in a normal menu...
;     BarItem(3, "Save as")
;     BarItem(4, "event-Quit")
;     BarSeparator( )
;     OpenBar("Recent files")
;     BarItem(5, "PureBasic.exe")
;     BarItem(6, "event-Test")
;     CloseBar( )
;   EndIf
;   
;   Bind(*menu, @TestHandler(), #__event_LeftClick, 6)
;   Bind(*menu, @QuitHandler(), #__event_LeftClick, 4)
;   
;   
; ;   
; ;   ;\\
; ;   Define *root1._s_WIDGET = Open(#window, 300, 10, 300 - 20, 300 - 20): *root1\class = "root1": SetText(*root1, "root1")
; ;   ;BindWidgetEvent( *root1, @HandlerEvents( ) )
; ;   ;\\Close( )
; ;   
; ;   Define *root2._s_WIDGET = Open(#window, 10, 300, 300 - 20, 300 - 20): *root2\class = "root2": SetText(*root2, "root2")
; ;   ;BindWidgetEvent( *root2, @HandlerEvents( ) )
; ;   ;\\Close( )
; ;   
; ;   
; ;   Define *root3._s_WIDGET = Open(#window, 300, 300, 300 - 20, 300 - 20): *root3\class = "root3": SetText(*root3, "root3")
; ;   ;BindWidgetEvent( *root3, @HandlerEvents( ) )
; ;   ;\\Close( )
; ;   
; ;   Define *root4._s_WIDGET = Open(#window, 590, 10, 200, 600 - 20): *root4\class = "root4": SetText(*root4, "root4")
; ;   ;BindWidgetEvent( *root4, @HandlerEvents( ) )
; ;   ;\\Close( )
;   


  *menu = CreatePopupMenuBar( )
  If *menu                  ; creation of the pop-up menu begins...
    BarItem(1, "Open")      ; You can use all commands for creating a menu
    BarItem(2, "Save")      ; just like in a normal menu...
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
  Define Text.s, m.s   = #LF$, a
  AddItem(*button_panel, -1, "1")
  *g = Editor(0, 0, 0, 0, #__flag_gridlines | #__flag_autosize)
  ;*g                 = Editor(10, 10, 200 + 60, 200, #__flag_gridlines);, #__flag_autosize)
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
  a  = - 1
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
  
  *g = String(10, 220, 200, 50, "string gadget text text 1234567890 text text long long very long", #__text_password | #__text_right)
  
  ;\\
  Global *button_item1, *button_item2, *button_menu
  Procedure button_tab_events( )
    Select GetText( EventWidget( ) )
      Case "popup menu"
        DisplayPopupMenuBar( *menu, EventWidget( ), mouse( )\x, mouse( )\y )
        
      Case "1"
        SetState(*button_panel, 0)
        SetState(*button_item2, 0)
      Case "2"
        SetState(*button_panel, 1)
        SetState(*button_item1, 0)
    EndSelect
  EndProcedure 
  
  *button_menu = Button( 180, 5, 87, 25, "popup menu")
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
  
   WaitClose( )
  
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile = 555
   
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
            ;             If Not *this\child
            ;                If *this\index > 0 And  *this\index < 5
            ;                   Debug "8476575788484 "+*this\class
            ;                   a_set( *this, #__a_full )
            ;                EndIf 
            ;             EndIf 
            
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
   ;    Define *toolbar = ToolBar( *root )
   ;     
   ;     If *toolbar
   ;       ToolBarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
   ;       ToolBarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_Toolbar_Normal, "open")
   ;       ToolBarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"));, #PB_Toolbar_Normal, "save")
   ;       
   ;       Separator( )
   ;       
   ;       ToolBarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
   ;       ; ToolTip(*toolbar, 3, "Cut")
   ;       
   ;       ToolBarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
   ;       ; ToolTip(*toolbar, 4, "Copy")
   ;       
   ;       ToolBarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
   ;       ; ToolTip(*toolbar, 5, "Paste")
   ;       
   ;       Separator( )
   ;       
   ;       ToolBarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
   ;       ; ToolTip(*toolbar, 6, "Find a document")
   ;    EndIf
   
   ;BindWidgetEvent( *root, @HandlerEvents( ) )
   view = Container(10, 50, 406, 238, #PB_Container_Flat)
   SetColor(view, #PB_Gadget_BackColor, RGB(213, 213, 213))
   ;a_init( view, 8 )
   
   
   Global *menu = CreateMenuBar( view ) : SetClass(*menu, "*root_MenuBar" )
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
   ;    BarItem(5, "title-2-item-1")
   ;    BarItem(6, "title-2-item-2")
   
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

   WaitClose( )
   
CompilerEndIf
   
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 68
; FirstLine = 68
; Folding = -------
; EnableXP
; DPIAware