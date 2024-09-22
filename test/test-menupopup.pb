XIncludeFile "../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile 
   
   EnableExplicit
   UseLIB(widget)
   
   Global  *menu, *button_menu
   
   Open(0, 0, 0, 300, 200, "popup menu test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   *menu = CreatePopupMenuBar( )
   If *menu                  ; creation of the pop-up menu begins...
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
   
;    Procedure button_tab_events( )
;       Select GetText( EventWidget( ) )
;          Case "popup menu"
;             DisplayPopupMenuBar( *menu, EventWidget( ), 10, 32 )
;             
;          
;       EndSelect
;    EndProcedure 
   
   *button_menu = Button( 10, 5, 120, 25, "popup menu")
;    Bind(*button_menu, @button_tab_events( ), #__event_Down )
   
   Repaint(root( ))
     ;; Root( )\canvas\post = 0
               
   DisplayPopupMenuBar( *menu, *button_menu, 10, 32 )
            
   WaitClose( )
   
CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 37
; FirstLine = 6
; Folding = -
; EnableXP
; DPIAware