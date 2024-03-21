
XIncludeFile "../../../widgets.pbi"

;- example 1
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(Widget)
   
   Global i = 0
   Global._s_widget *PANEL_1, *PANEL_2
   
   If Open( 3, 0, 0, 400, 300, "Panel add childrens hide state", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      SetColor(root(), #__color_back, $FF82E5F8 )
     
      *PANEL_1 = Panel( 30, 30, 340, 240 )
      ;\\
      AddItem( *PANEL_1, 1, "*PANEL_1 - 1" )
      Button( 10,10,80,30,"Button1" )
      Button( 10,45,80,30,"Button2" )
      Button( 10,80,80,30,"Button3" )
      
      ;\\
      AddItem( *PANEL_1, i, "*PANEL_1 - 2" )
      Button( 0,0,80,80,"Button" )
      
      ;\\
      CloseList( ) ; close *PANEL_1 list
      
      ;\\
      SetState( *PANEL_1, 1 )
      
      ;\\
      AddItem( *PANEL_1, i, "*PANEL_1 - 3" )
      Button( 200,10,80,30,"Button4" )
      Button( 200,45,80,30,"Button5" )
      Button( 200,80,80,30,"Button6" )
      
      ;\\
      CloseList( ) ; close *PANEL_1 list
      
      Debug "items count "+CountItems( *PANEL_1 )
      
      ; reset selected items
      SetState( *PANEL_1, - 1 )
      
      WaitClose( )
   EndIf   
CompilerEndIf

; example 2
CompilerIf #PB_Compiler_IsMainFile = 99
   EnableExplicit
   UseLib(Widget)
   
   Global i = 0
   Global._s_widget *PANEL_1, *PANEL_2
   
   If Open( 3, 0, 0, 400, 300, "Panel add childrens hide state", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      
      *PANEL_1 = Panel( 30, 30, 340, 240 )
      
      For i=0 To 100
         AddItem( *PANEL_1, i, "item_"+Str(i) )
      Next
      
      Debug "items count "+CountItems( *PANEL_1 )
      
      WaitClose( )
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = -
; EnableXP