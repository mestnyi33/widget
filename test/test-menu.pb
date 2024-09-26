XIncludeFile "../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile 
  
  EnableExplicit
  UseLIB(widget)
  
  test_draw_repaint = 1
  
  Enumeration
    #window_0
    #window
  EndEnumeration
  
  ;-\\ ANCHORS
  Global view
  
  OpenWindow(#window_0, 0, 0, 424, 352, "AnchorsGadget", #PB_Window_SystemMenu )
  
  Define i
  Define *w._s_WIDGET, *g._s_WIDGET, editable.q = #__flag_BorderFlat
  Define *root._s_WIDGET = Open(#window_0, 0, 0, 424, 352): *root\class = "root": SetText(*root, "root")
  
  ;BindWidgetEvent( *root, @BindEvents( ) )
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
  
  ;\\Close( )
  
  
  OpenWindow(#window, 0, 0, 400, 300, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ;\\ Open Root0
  Define *root0._s_WIDGET = Open(#window, 10, 10, 300 - 20, 300 - 20): *root0\class = "root0": SetText(*root0, "root0")
  ;BindWidgetEvent( *root2, @BindEvents( ) )
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
; ;   ;BindWidgetEvent( *root1, @BindEvents( ) )
; ;   ;\\Close( )
; ;   
; ;   Define *root2._s_WIDGET = Open(#window, 10, 300, 300 - 20, 300 - 20): *root2\class = "root2": SetText(*root2, "root2")
; ;   ;BindWidgetEvent( *root2, @BindEvents( ) )
; ;   ;\\Close( )
; ;   
; ;   
; ;   Define *root3._s_WIDGET = Open(#window, 300, 300, 300 - 20, 300 - 20): *root3\class = "root3": SetText(*root3, "root3")
; ;   ;BindWidgetEvent( *root3, @BindEvents( ) )
; ;   ;\\Close( )
; ;   
; ;   Define *root4._s_WIDGET = Open(#window, 590, 10, 200, 600 - 20): *root4\class = "root4": SetText(*root4, "root4")
; ;   ;BindWidgetEvent( *root4, @BindEvents( ) )
; ;   ;\\Close( )
;   

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
      
      Select WidgetEventType( )
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
   
   ;BindWidgetEvent( *root, @BindEvents( ) )
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
; CursorPosition = 128
; FirstLine = 95
; Folding = X---
; EnableXP
; DPIAware