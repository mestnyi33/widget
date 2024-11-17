
XIncludeFile "../../../widgets.pbi"

;- example 1
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global i = 0
   Global._s_widget *PANEL_1, *PANEL_2
     
      If OpenRootWidget( 3, 0, 0, 750, 300, "Panel add childrens hide state", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      SetWidgetColor(root(), #__color_back, $FFF2F2F2)
   
      *PANEL_1 = PanelWidget( 30, 30, 340, 240 )
      ;\\
      AddItem( *PANEL_1, 1, "*PANEL_1 - 1" )
      ButtonWidget( 10,10,80,30,"Button1" )
      ButtonWidget( 10,45,80,30,"Button2" )
      ButtonWidget( 10,80,80,30,"Button3" )
      
      ;\\
      AddItem( *PANEL_1, i, "*PANEL_1 - 2" )
      ButtonWidget( 0,0,80,80,"Button" )
      
      ;\\
      CloseWidgetList( ) ; close *PANEL_1 list
      
      ;\\
      SetState( *PANEL_1, 1 )
      
      ;\\
      AddItem( *PANEL_1, i, "*PANEL_1 - 3" )
      ButtonWidget( 200,10,80,30,"Button4" )
      ButtonWidget( 200,45,80,30,"Button5" )
      ButtonWidget( 200,80,80,30,"Button6" )
      
      ;\\
      CloseWidgetList( ) ; close *PANEL_1 list
      
      Debug "items count "+CountItems( *PANEL_1 )
      
      ; reset selected items
      SetState( *PANEL_1, - 1 )
      
      BarPosition( *PANEL_1\TabBox( ), 1, 100 )
;       *PANEL_1\TabBox( )\bar\vertical = 1
;       ResizeWidget( *PANEL_1, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      
      
      *PANEL_1 = PanelWidget( 30+340+10, 30, 340, 240 )
      ;\\
      AddItem( *PANEL_1, 1, "*PANEL_1 - 1" )
      ButtonWidget( 10,10,80,30,"Button1" )
      ButtonWidget( 10,45,80,30,"Button2" )
      ButtonWidget( 10,80,80,30,"Button3" )
      
      ;\\
      AddItem( *PANEL_1, i, "*PANEL_1 - 2" )
      ButtonWidget( 0,0,80,80,"Button" )
      
      ;\\
      CloseWidgetList( ) ; close *PANEL_1 list
      
      ;\\
      SetState( *PANEL_1, 1 )
      
      ;\\
      AddItem( *PANEL_1, i, "*PANEL_1 - 3" )
      ButtonWidget( 200,10,80,30,"Button4" )
      ButtonWidget( 200,45,80,30,"Button5" )
      ButtonWidget( 200,80,80,30,"Button6" )
      
      ;\\
      CloseWidgetList( ) ; close *PANEL_1 list
      
      Debug "items count "+CountItems( *PANEL_1 )
      
      ; reset selected items
      SetState( *PANEL_1, - 1 )
      
      WaitCloseRootWidget( )
   EndIf   
CompilerEndIf

; example 2
CompilerIf #PB_Compiler_IsMainFile = 99
   EnableExplicit
   UseWidgets( )
   
   Global i = 0
   Global._s_widget *PANEL_1, *PANEL_2
   
   If OpenRootWidget( 3, 0, 0, 400, 300, "Panel add childrens hide state", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      
      *PANEL_1 = PanelWidget( 30, 30, 340, 240 )
      
      For i=0 To 100
         AddItem( *PANEL_1, i, "item_"+Str(i) )
      Next
      
      Debug "items count "+CountItems( *PANEL_1 )
      
      WaitCloseRootWidget( )
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 45
; FirstLine = 34
; Folding = -
; EnableXP