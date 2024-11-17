IncludePath "../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile 
   
   EnableExplicit
   UseWidgets( )
   
   test_event_resize = 1
   ;test_atpoint = 1
   ;test_draw_repaint = 1
   ;test_event_entered = 1
   ;test_event_canvas = 1
   test_scrollbars_resize = 1
   
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
   Define i
   Define *w._s_WIDGET, *g._s_WIDGET, editable.q = #__flag_BorderFlat
   Global view, size_value, pos_value, grid_value, back_color, frame_color, size_text, pos_text, grid_text
   
   
   OpenWindow(#window, 0, 0, 300, 300, "test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   ;\\ Open Root0
   Define *root0._s_WIDGET = Open(#window, 10, 10, 300 - 20, 300 - 20): *root0\class = "root0": SetText(*root0, "root0")
   
;    Global *menu = CreateBar( *root0 ) : SetClass(*menu, "*root_MenuBar" )
;    SetColor( *menu, #__color_back, $FFC8ECF0 )
;    
;    BarTitle("Title-1")
;    BarItem(1, "title-1-item-1")
;    BarSeparator( )   
;    ;
;    OpenSubBar("title-1-sub-item")
;    BarItem(3, "title-1-item")
;    BarSeparator( )
;    ;
;    OpenSubBar("title-2-sub-item")   
;    BarItem(13, "title-2-item")
;    BarSeparator( )
;    ;
;    OpenSubBar("title-3-sub-item")   
;    BarItem(23, "title-3-item")
;    CloseSubBar( ) 
;    ;
;    BarSeparator( )
;    BarItem(14, "title-2-item")
;    CloseSubBar( ) 
;    ;
;    BarSeparator( )
;    BarItem(4, "title-1-item")
;    CloseSubBar( ) 
;    ;
;    BarSeparator( )
;    BarItem(2, "title-1-item-2")
;    
;    BarTitle("Title-2")
;    ;    BarItem(5, "title-2-item-1")
;    ;    BarItem(6, "title-2-item-2")
;    
;    BarTitle("Title-event-test")
;    BarItem(7, "test")
;    BarSeparator( )
;    BarItem(8, "quit")
;    
;    BarTitle("Title-4")
;    BarItem(9, "title-4-item-1")
;    BarItem(10, "title-4-item-2")
;    
;    Procedure TestHandler()
;       Debug "Test menu event"
;    EndProcedure
;    
;    Procedure QuitHandler()
;       Debug "Quit menu event"
;       ; End
;    EndProcedure
;    
;    Bind(*menu, @TestHandler(), -1, 7)
;    Bind(*menu, @QuitHandler(), -1, 8)
;    
;    *menu = CreatePopupBar( )
;    If *menu                  ; creation of the pop-up menu begins...
;       BarItem(1, "Open")     ; You can use all commands for creating a menu
;       BarItem(2, "Save")     ; just like in a normal menu...
;       BarItem(3, "Save as")
;       BarItem(4, "event-Quit")
;       BarSeparator( )
;       OpenSubBar("Recent files")
;       BarItem(5, "PureBasic.exe")
;       BarItem(6, "event-Test")
;       CloseSubBar( )
;    EndIf
;    
;    Bind(*menu, @TestHandler(), #__event_LeftClick, 6)
;    Bind(*menu, @QuitHandler(), #__event_LeftClick, 4)
;    
;    ;\\
;    *g = ListIcon(0, 0, 0, 0, "Column_1", 90, #__flag_autosize | #__flag_RowFullSelect | #__Flag_GridLines | #__Flag_CheckBoxes) ;: *g = GetGadgetData(g)
   *g = ListIcon(10, 10, 260, 235, "Column_1", 90, #__flag_RowFullSelect | #__Flag_GridLines | #__Flag_CheckBoxes) ;: *g = GetGadgetData(g)
   
   Define a
   For a = 1 To 2
      AddColumn(*g, a, "Column_" + Str(a + 1), 90)
   Next
   For a = 0 To 15
      AddItem(*g, a, Str(a) + "_Column_1" + #LF$ + Str(a) + "_Column_2" + #LF$ + Str(a) + "_Column_3" + #LF$ + Str(a) + "_Column_4", 0)
   Next
   
   ReDraw( root( ) )
   
   ;\\Close( )
   ;Debug  *g\scroll\v\hide
  
   WaitClose( )
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 94
; FirstLine = 90
; Folding = -
; EnableXP
; DPIAware