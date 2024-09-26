XIncludeFile "../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile 
   
   EnableExplicit
   UseLIB(widget)
   test_event_resize = 1
   
   Global._S_WIDGET  *menu, *button_menu
   
   Open(0, 0, 0, 300, 200, "popup menu test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   *menu = CreatePopupMenuBar( )
   If *menu                  ; creation of the pop-up menu begins...
      SetColor(*menu, #__Color_Back, RGB(213, 213, 213))
      SetItemColor(*menu, -1, #__Color_Back, $FFBF33C3, 1)
   
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
            DisplayPopupMenuBar( *menu, EventWidget( ), mouse( )\x, mouse( )\y )
            
            
      EndSelect
   EndProcedure 
   
   ;
   *button_menu = Button( 10, 5, 120, 25, "popup menu")
   Bind(*button_menu, @button_tab_events( ), #__event_Down )
   
   Repaint(root( ))
   
   
   DisplayPopupMenuBar( *menu, *button_menu, 140, 20 )
   ;DisplayPopupMenuBar( *menu, root(), 10, 32 )
   
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
   
   WaitClose( )
   
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 41
; FirstLine = 28
; Folding = -
; EnableXP
; DPIAware