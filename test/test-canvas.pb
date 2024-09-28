; fixed
XIncludeFile "../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile 
   
   EnableExplicit
   UseLIB(widget)
   Global event,mouse_x
   
   Global._S_WIDGET  *menu, *button_menu
   Open(0, 0, 0, 300, 200, "popup menu test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      *menu = CreatePopupMenuBar( )
   If *menu                  ; creation of the pop-up menu begins...
      ;SetColor(*menu, #__Color_Back, RGB(213, 213, 213))
      ;SetItemColor(*menu, -1, #__Color_Back, $FFBF33C3, 1)
   
      BarItem(1, "Open")     ; You can use all commands for creating a menu
      BarItem(2, "Save")     ; just like in a normal menu...
      BarItem(3, "Save as")
      BarItem(4, "event-Quit")
      BarSeparator( )
      
      OpenBar("Recent files")
      BarItem(5, "PureBasic.exe")
      BarItem(6, "event-Test")
      CloseBar( )
   EndIf
   
   Procedure button_tab_events( )
      Select GetText( EventWidget( ) )
         Case "popup menu"
            ; DisplayPopupMenuBar( *menu, EventWidget( ), mouse( )\x, mouse( )\y )
            ; DisplayPopupMenuBar( *menu, EventWidget( ), GetMouseX( ), GetMouseY( ) )
            
            Debug "mouse_x = "+DesktopMouseX( ) +" gadget_x = "+ GadgetX(EventGadget(), #PB_Gadget_ScreenCoordinate) +" window_x = "+ WindowX(EventWindow(), #PB_Window_InnerCoordinate)
         
            DisplayPopupMenuBar( *menu, EventWidget( ), DesktopMouseX( ), DesktopMouseY( ) )
            
            
      EndSelect
   EndProcedure 
   
   ;
   *button_menu = Button( 10, 5, 120, 25, "popup menu")
   Bind(*button_menu, @button_tab_events( ), #__event_Down )
   Button( 140, 5, 150, 25, "button")
   
   Define i, *combobox._S_WIDGET = ComboBox( 10, 125, 120, 25)
   AddItem(*combobox, -1, "combo")
   For i = 0 To 5;9
      AddItem(*combobox, -1, "item_"+Str(i))
   Next
   SetState(*combobox, 0)
   
   Repaint(root( ))
   
   
   DisplayPopupMenuBar( *combobox\PopupBar( ), *button_menu, GadgetX(GetGadget(*button_menu), #PB_Gadget_ScreenCoordinate)+10, GadgetY(GetGadget(*button_menu), #PB_Gadget_ScreenCoordinate)+125+25 )
   ; DisplayPopupMenuBar( *combobox\PopupBar( ), *button_menu, x(*button_menu, #__c_screen), y(*button_menu, #__c_screen)+25 )
   ; DisplayPopupMenuBar( *combobox\PopupBar( ), *button_menu, 10, 125+25 )
   ;DisplayPopupMenuBar( *combobox\PopupBar( ), *combobox, 10, 150 )
   
   DisplayPopupMenuBar( *menu, *button_menu, GadgetX(GetGadget(*button_menu), #PB_Gadget_ScreenCoordinate)+140, GadgetY(GetGadget(*button_menu), #PB_Gadget_ScreenCoordinate)+20 )
   ;DisplayPopupMenuBar( *menu, *button_menu, 140, 20 )
   ;DisplayPopupMenuBar( *menu, root(), 10, 32 )
   
   Repeat 
   event = WaitWindowEvent()
   If event = #PB_Event_Gadget
      If EventType() = #PB_EventType_LeftButtonDown
         mouse_x = DesktopMouseX()
        ; ResizeWindow(EventWindow(), mouse_x, #PB_Ignore, #PB_Ignore, #PB_Ignore)
         Debug "mouse_x = "+mouse_x +" gadget_x = "+ GadgetX(EventGadget(), #PB_Gadget_ScreenCoordinate)
         
      EndIf
   EndIf
Until event = #PB_Event_CloseWindow

CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 10
; Folding = --
; EnableXP