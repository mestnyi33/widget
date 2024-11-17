; fixed
XIncludeFile "../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile 
   
   EnableExplicit
   UseWidgets( )
   ;test_event_resize = 1
   ;test_atpoint = 1
   ;test_draw_repaint = 1
   ;test_event_entered = 1
   test_event_canvas = 1
   
   Global._S_WIDGET  *menu, *button_menu
   
   OpenWindow(0, 0, 0, 300, 200, "popup menu test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   Open(0, 10, 10, 280, 180)
   *menu = CreatePopupBar( )
   If *menu                  ; creation of the pop-up menu begins...
      ;SetColor(*menu, #__Color_Back, RGB(213, 213, 213))
      ;SetItemColor(*menu, -1, #__Color_Back, $FFBF33C3, 1)
   
      BarItem(1, "Open")     ; You can use all commands for creating a menu
      BarItem(2, "Save")     ; just like in a normal menu...
      BarItem(3, "Save as")
      BarItem(4, "event-Quit")
      BarSeparator( )
      
      OpenSubBar("Recent files")
      BarItem(5, "PureBasic.exe")
      BarItem(6, "event-Test")
      CloseSubBar( )
   EndIf
   
   Procedure button_tab_events( )
      Select GetText( EventWidget( ) )
         Case "popup menu"
          ;Protected mouse_x = DesktopUnscaledX(DesktopMouseX( )) - GadgetX( EventGadget(), #PB_Gadget_ScreenCoordinate )
         ; Protected mouse_x = DesktopUnscaledX(WindowMouseX( EventWindow())) - GadgetX( EventGadget(), #PB_Gadget_WindowCoordinate )
;           Protected mouse_x = DesktopUnscaledX(GetGadgetAttribute( EventGadget(), #PB_Canvas_MouseX ))
;           DisplayPopupBar( *menu, EventWidget( ), Mouse_x, GetMouseY( ) )
          
             ;DisplayPopupBar( *menu, EventWidget( ), mouse( )\x, mouse( )\y )
             ;DisplayPopupBar( *menu, EventWidget( ), GetMouseX( ), GetMouseY( ) )
             ;DisplayPopupBar( *menu, EventWidget( ), DesktopMouseX( ), DesktopMouseY( ) )
            
           ; Debug "mouse_x = "+DesktopMouseX( ) +" gadget_x = "+ GadgetX(EventGadget(), #PB_Gadget_ScreenCoordinate) +" window_x = "+ WindowX(EventWindow(), #PB_Window_InnerCoordinate)
            DisplayPopupBar( *menu, EventWidget( ) )
            
            
      EndSelect
   EndProcedure 
   
   ;
   *button_menu = Button( 10, 5, 120, 25, "popup menu")
   Bind(*button_menu, @button_tab_events( ), #__event_Down )
   Button( 140, 5, 130, 25, "button")
   
   Define i, *combobox._S_WIDGET = ComboBox( 10, 125, 120, 25)
   AddItem(*combobox, -1, "combo")
   For i = 0 To 5;9
      AddItem(*combobox, -1, "item_"+Str(i))
   Next
   SetState(*combobox, 0)
   
   ReDraw(root( ))
   
   
   DisplayPopupBar( *combobox\PopupBar( ), *button_menu, 10, 125+25 )
   ;DisplayPopupBar( *combobox\PopupBar( ), *combobox, 10, 150 )
   
   DisplayPopupBar( *menu, *button_menu, 140, 20 )
   ;DisplayPopupBar( *menu, root(), 10, 32 )
   
   ;     Debug ""+
   ;             *menu\text\string +" "+
   ;             *menu\x +" "+
   ;             *menu\y +" "+
   ;             *menu\width +" "+
   ;             *menu\height
   
   ;    Debug "------->>--------"
   ;    ForEach *menu\__tabs( )
   ;       Debug ""+
   ;             *menu\__tabs( )\text\string +" "+
   ;             *menu\__tabs( )\x +" "+
   ;             *menu\__tabs( )\y +" "+
   ;             *menu\__tabs( )\width +" "+
   ;             *menu\__tabs( )\height
   ;       
   ;    Next
   ;    Debug "-------<<--------"
   
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
; CursorPosition = 72
; FirstLine = 49
; Folding = -
; EnableXP
; DPIAware