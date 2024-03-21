
XIncludeFile "../../../widgets.pbi"

;- example 1
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(Widget)
   
   Global i = 0
   Global._s_widget *PANEL_1, *PANEL_2
   
   Procedure BarPosition_( *this._s_widget, position.i, size.i = #PB_Default )
     *this = *this\parent
     
     ; reset position
    *this\fs[1] = 0
    *this\fs[2] = 0
    *this\fs[3] = 0
    *this\fs[4] = 0
    
    If position = 4
      *this\TabBox( )\hide = 1
    Else
      *this\TabBox( )\hide = 0
    EndIf
    
    If position = 1
      *this\TabBox( )\bar\vertical = 1
      If size = #PB_Default
        *this\fs[1] = #__panel_width
      Else
        *this\fs[1] = size
      EndIf
    EndIf
    
    If position = 3
      *this\TabBox( )\bar\vertical = 1
      If size = #PB_Default
        *this\fs[3] = #__panel_width
      Else
        *this\fs[3] = size
      EndIf
    EndIf
    
    If position = 0
      *this\TabBox( )\bar\vertical = 0
      If size = #PB_Default
        *this\fs[2] = #__panel_height
      Else
        *this\fs[2] = size
      EndIf
    EndIf
    
    If position = 2
      *this\TabBox( )\bar\vertical = 0
      If size = #PB_Default
        *this\fs[4] = #__panel_height
      Else
        *this\fs[4] = size
      EndIf
    EndIf
    
;     *this\TabBoxSize( ) = 40;*this\fs[1]
;     *this\fs[1] = 30
    
    If Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      PostEventRepaint( *this\root )
    EndIf
  EndProcedure
  
  If Open( 3, 0, 0, 750, 300, "Panel add childrens hide state", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
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
      
      BarPosition_( *PANEL_1\TabBox( ), 1 )
;       *PANEL_1\TabBox( )\bar\vertical = 1
;       Resize( *PANEL_1, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      
      
      *PANEL_1 = Panel( 30+340+10, 30, 340, 240 )
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
; Folding = ---
; EnableXP