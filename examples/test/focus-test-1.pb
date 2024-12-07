
XIncludeFile "../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define *menu._s_widget
   ;-
   
   Procedure test( *this._s_widget )
      If GetActive( )
         Debug "a - "+GetActive( )\class
      EndIf
      If ActiveWindow( )
         Debug "aw - "+ActiveWindow( )\class
         If ActiveGadget( )
            Debug "ag - "+ActiveGadget( )\class
         EndIf
      EndIf
      
      Debug ">"
      Debug ""+*this\class +" "+ *this\focus
      If StartEnum( *this )
         
         Debug ""+widget( )\class +" "+ widget( )\focus
         
         StopEnum( )
      EndIf
      Debug "<"
   EndProcedure
   
   Procedure TestHandler()
      ;ClearDebugOutput()
      Debug "Test menu event"
   EndProcedure
   
   Procedure QuitHandler()
      ;ClearDebugOutput()
      Debug "Quit menu event"
      ; End
   EndProcedure
   
   Procedure Handler()
     Debug ""+ClassFromEvent( WidgetEvent( ) ) +" - "+ EventWidget( )\class
   EndProcedure
   
   ;\\
   Define window = GetCanvasWindow(Open( 0, 100, 100, 500, 250, "main window_0", #__Window_SystemMenu))
   Define Container = ContainerGadget( #PB_Any, 10, 35, 80, 100-20, #PB_Container_Flat ) : CloseGadgetList( )
   
   CreateMenu(0, WindowID(window))
   
   MenuTitle("Title-1")
   MenuTitle("Title-2")
   MenuTitle("Title-event-test")
   MenuTitle("Title-4")
   
   
   
   ;\\
   Define *window._s_widget = root( )
   
   *menu = CreateMenuBar( *window ) : SetClass(widget(), "root_MenuBar" )
   
   BarTitle("Title-1")
   BarTitle("Title-2")
   BarTitle("Title-event-test")
   BarTitle("Title-4")
   
   ;\\
   Define *window._s_widget = Window(100, 50, 300, 100, "menu click test", #PB_Window_SystemMenu)
   Define *container._s_widget = Container( 10, 10, 80, 100-20, #PB_Container_Flat ) : CloseList( )
   
   *menu = CreateMenuBar( *window ) : SetClass(widget(), "window_MenuBar" )
   
   BarTitle("Title-1")
   BarTitle("Title-2")
   BarTitle("Title-event-test")
   BarTitle("Title-4")
   
   
   test( root() )
   
   Bind( root( ), @Handler(), #__event_Focus)
   Bind( root( ), @Handler(), #__event_LostFocus)
   
   Define Event
   Repeat
      Event = WaitWindowEvent()
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; Folding = --
; EnableXP