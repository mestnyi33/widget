
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global *menu._s_widget
   ;-
   Procedure TestHandler()
      ;ClearDebugOutput()
      Debug "Test menu event"
   EndProcedure
   
   Procedure QuitHandler()
      ;ClearDebugOutput()
      Debug "Quit menu event"
      ; End
   EndProcedure
   
   ;\\
   Define WindowID = OpenWindow( 0, 100, 100, 500, 350, "main window_0", #PB_Window_SystemMenu|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget)
   
   CreateMenu(0, WindowID(0))
   MenuTitle("Title-1")
   MenuItem(1, "title-1-item-1")
   MenuBar()
   ;
   OpenSubMenu("title-1-sub-item")   
   MenuItem(3, "title-1-item")
   MenuBar()
   ;
   OpenSubMenu("title-2-sub-item")   
   MenuItem(13, "title-2-item")
   MenuBar()
   ;
   OpenSubMenu("title-3-sub-item")   
   MenuItem(23, "title-3-item")
   CloseSubMenu( ) 
   ;
   MenuBar()
   MenuItem(24, "title-2-item")
   CloseSubMenu( ) 
   ;
   MenuBar()
   MenuItem(14, "title-1-item")
   CloseSubMenu( ) 
   ;
   MenuBar()
   MenuItem(2, "title-1-item-2")
   
   MenuTitle("Title-2")
   ;    MenuItem(5, "title-2-item-1")
   ;    MenuItem(6, "title-2-item-2")
   
   MenuTitle("Title-event-test")
   MenuItem(7, "test")
   MenuBar( )
   MenuItem(8, "quit")
   
   MenuTitle("Title-4")
   MenuItem(9, "title-4-item-1")
   MenuItem(10, "title-4-item-2")
   
   BindMenuEvent(0, 7, @TestHandler())
   BindMenuEvent(0, 8, @QuitHandler())
   
   ;\\
   Open(0, 50,50,400,250)
   *menu = CreateMenuBar( root( ) ) : SetClass(widget( ), "root_MenuBar" )
   
   BarTitle("Title-1")
   BarItem(1, "title-1-item-1")
   BarSeparator( )
   
   OpenSubBar("title-1-sub-item")
   BarItem(3, "title-1-item")
   BarSeparator( )
   ;
   OpenSubBar("title-2-sub-item")   
   BarItem(13, "title-2-item")
   BarSeparator( )
   ;
   OpenSubBar("title-3-sub-item")   
   BarItem(23, "title-3-item")
   CloseSubBar( ) 
   ;
   BarSeparator( )
   BarItem(14, "title-2-item")
   CloseSubBar( ) 
   ;
   BarSeparator( )
   BarItem(4, "title-1-item")
   CloseSubBar( ) 
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
   
   Bind(*menu, @TestHandler(), -1, 7)
   Bind(*menu, @QuitHandler(), -1, 8)
   
   ;\\
   Define a
   ComboBox(100, 10, 250, 21, #PB_ComboBox_Editable)
   For a = 0 To 30
      AddItem(widget(), -1,"ComboBox editable..." + Str(a))
   Next
   
   ComboBox(100, 40, 250, 21, #PB_ComboBox_Image)
   AddItem(widget(), -1, "ComboBox item0 with image0", (0))
   AddItem(widget(), -1, "ComboBox item1 with image1", (1))
   AddItem(widget(), -1, "ComboBox item2 with image2", (2))
   
   ComboBox(100, 70, 250, 21)
   AddItem(widget(), -1, "ComboBox item0")
   AddItem(widget(), -1, "ComboBox item1")
   AddItem(widget(), -1, "ComboBox item3")
   
   SetState(ID(0), 2)
   SetState(ID(1), 1)
   SetState(ID(2), 0)    ; set (beginning with 0) the third item as active one
   
   Procedure ClickHandler()
      Debug "DisplayPopupBar"
      DisplayPopupBar( *menu, EventWidget())
   EndProcedure
   Container(100,100,250,100)
   SetText(widget(), "  click mouse button to see popup menu")
   Bind(widget(), @ClickHandler(), #__event_leftclick)
   *menu = CreatePopupBar( )
   If *menu                  ; creation of the pop-up menu begins...
      BarItem(1, "Open")     ; You can use all commands for creating a menu
      BarItem(2, "Save")     ; just like in a normal menu...
      BarItem(3, "Save as")
      BarItem(4, "Quit")
      BarBar( )
      OpenSubBar("Recent files")
      BarItem(5, "PureBasic.exe")
      BarItem(6, "Test.txt")
      CloseSubBar( )
   EndIf
   CloseList()
   
   Define Event
   Repeat
      Event = WaitWindowEvent()
      If Event = #PB_Event_Gadget
         If EventGadget() = 777
            Debug " -777- event "
         EndIf
      EndIf
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 68
; FirstLine = 48
; Folding = --
; EnableXP
; DPIAware