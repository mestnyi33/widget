; fixed
XIncludeFile "../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile 
   
   EnableExplicit
   UseWidgets( )
   ;test_event_resize = 1
   ;test_atpoint = 1
   ;test_draw_repaint = 1
   ;test_event_entered = 1
   ;test_event_canvas = 1
   
   Global._S_WIDGET  *menu, *button_menu
   
   OpenWindow(0, 0, 0, 300, 200, "popup menu test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   Open(0, 10, 10, 280, 180)
   
   Procedure button_tab_events( )
      Select GetText( EventWidget( ) )
         Case "popup menu"
            ; DisplayPopupMenuBar( *menu, EventWidget( ), DesktopUnscaledX(mouse( )\x - EventWidget( )\x[#__c_inner]), mouse( )\y - EventWidget( )\y[#__c_inner] )
            ; DisplayPopupMenuBar( *menu, EventWidget( ), mouse( )\x, mouse( )\y )
            ;DisplayPopupMenuBar( *menu, EventWidget( ), GetMouseX( ), GetMouseY( ) )
            
            ; Debug "mouse_x = "+DesktopMouseX( ) +" gadget_x = "+ GadgetX(EventGadget(), #PB_Gadget_ScreenCoordinate) +" window_x = "+ WindowX(EventWindow(), #PB_Window_InnerCoordinate)
            
            ; DisplayPopupMenuBar( *menu, EventWidget( ) );, DesktopMouseX( ), DesktopMouseY( ) )
            
            Protected  mouse_x
            mouse_x = GetMouseX( ) ; mouse( )\x ; DesktopMouseX()
            Resize(EventWidget(), mouse_x, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            Debug "mouse_x = "+mouse_x +" gadget_x = "+ Str(WidgetX(EventWidget(), #__c_Screen) )
;             Resize(EventWidget(), DesktopUnscaledX(mouse_x), #PB_Ignore, #PB_Ignore, #PB_Ignore)
;             Debug "mouse_x = "+mouse_x +" gadget_x = "+ Str(DesktopScaledX(WidgetX(EventWidget(), #__c_Screen) ))
            
      EndSelect
   EndProcedure 
   
   ;
   *button_menu = Button( 10, 5, 120, 25, "popup menu")
   Bind(*button_menu, @button_tab_events( ), #__event_Down )
   
   ReDraw(root( ))
   
   ; WaitClose( )
   
   Define Event
   Repeat
      Event = WaitWindowEvent( )
      If event = #PB_Event_LeftClick
         Debug 888
      EndIf
   Until Event = #PB_Event_CloseWindow
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 43
; FirstLine = 29
; Folding = -
; Optimizer
; EnableXP