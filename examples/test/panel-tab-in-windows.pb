XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global i, x = 220, panel, butt1, butt2
  Global._s_WIDGET *panel, *butt0, *butt1, *butt2
  
  Procedure events()
    If EventWidget( )\TabBox( )
        Debug "TabBox( ) "+EventWidget( )\TabBox( )\draw_x( ) +" "+ EventWidget( )\TabBox( )\draw_y( ) +" "+ EventWidget( )\TabBox( )\draw_width( ) +" "+ EventWidget( )\TabBox( )\draw_height( )
      Else
        Debug ""+EventWidget( )\class +" "+ EventWidget( )\draw_x( ) +" "+ EventWidget( )\draw_y( ) +" "+ EventWidget( )\draw_width( ) +" "+ EventWidget( )\draw_height( )
      EndIf
  EndProcedure
  
  If Open( #PB_Any, 0, 0, x+170, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )

    ;
    *panel = Panel( x, 65, 160,95 ) 
      AddItem( *panel, 0, Hex(0) ) 
      AddItem( *panel, 1, Hex(1) ) 
       Button( 10,5,80,35, "_"+Str(1) ) 
     CloseList( )
     
     
    Debug "----panel all childrens-----"
    If StartEnum( root())
      Debug widget( )\text\string
      
      If widget( )\TabBox( )
        Debug "TabBox( ) "+widget( )\TabBox( )\draw_x( ) +" "+ widget( )\TabBox( )\draw_y( ) +" "+ widget( )\TabBox( )\draw_width( ) +" "+ widget( )\TabBox( )\draw_height( )
        Bind(widget( ), @events(), #__event_down)
        Bind(widget( ), @events(), #__event_up)
        Bind(widget( )\TabBox( ), @events(), #__event_down)
        Bind(widget( )\TabBox( ), @events(), #__event_up)
      Else
        Debug ""+widget( )\class +" "+ widget( )\draw_x( ) +" "+ widget( )\draw_y( ) +" "+ widget( )\draw_width( ) +" "+ widget( )\draw_height( )
      EndIf
      StopEnum( )
    EndIf
    
    
    Repeat: Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf   
CompilerEndIf
;    Исчерпан лимит в x32 (17592186044416)
; --0 0 390 170
; ====220 65 160 0 95 170
; 160 65
; --TabBox( ) 220 65 160 95
; ----panel all childrens-----
; 
; TabBox( ) 220 65 160 95
; _1
; Button 0 0 0 0
; 220 65 160 95
; ====221 90 158 95 24 159
; 90 90
; --221 90 158 0
; 221 90 158 0
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 40
; FirstLine = 24
; Folding = --
; EnableXP