XIncludeFile "../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define *menu._s_widget
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
   Define windowID = OpenWindow( 0, 100, 100, 500, 350, "main window_0", #PB_Window_SystemMenu|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget)
   
   Open(0, 50,50,400,250)
   
   ;\\
   *menu = CreateBar( root( ) ) : SetClass(widget( ), "root_MenuBar" )
   
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
   
   ;\\
   Define a
   ComboBox(100, 10, 250, 21, #PB_ComboBox_Editable)
   For a = 1 To 31
      AddItem(widget(), -1,"ComboBox item " + Str(a))
   Next
   
   ComboBox(100, 40, 250, 21, #PB_ComboBox_Image)
   AddItem(widget(), -1, "ComboBox item with image1", (0))
   AddItem(widget(), -1, "ComboBox item with image2", (1))
   AddItem(widget(), -1, "ComboBox item with image3", (2))
   
   ComboBox(100, 70, 250, 21)
   AddItem(widget(), -1, "ComboBox editable...1")
   AddItem(widget(), -1, "ComboBox editable...2")
   AddItem(widget(), -1, "ComboBox editable...3")
   
   SetState(ID(0), 2)
   SetState(ID(1), 1)
   SetState(ID(2), 0)    ; set (beginning with 0) the third item as active one
   
   BindBarEvent(*menu, 7, @TestHandler())
   BindBarEvent(*menu, 8, @QuitHandler())
   
   ;PostEvent(-1, -1, -1, -1, 8 )
   ;Debug EventGadget()
   WaitClose( )
   
   Define Event
   Repeat
      event = WaitWindowEvent()
      
      If event = #PB_Event_Gadget
         EventHandler(EventGadget(), EventType(), EventData() )
      EndIf
      
      If Event = - 1; #PB_Event_Gadget
         If EventGadget() = -1;777
            Debug " -777- event "
         EndIf
      EndIf
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 86
; FirstLine = 80
; Folding = --
; EnableXP
; DPIAware