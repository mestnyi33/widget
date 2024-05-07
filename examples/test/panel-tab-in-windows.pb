XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(widget)
  
  Global i, x = 220, panel, butt1, butt2
  Global._s_WIDGET *panel, *butt0, *butt1, *butt2
  
  Procedure events()
    If eventwidget( )\TabBox( )
        Debug "TabBox( ) "+eventwidget( )\TabBox( )\draw_x( ) +" "+ eventwidget( )\TabBox( )\draw_y( ) +" "+ eventwidget( )\TabBox( )\draw_width( ) +" "+ eventwidget( )\TabBox( )\draw_height( )
      Else
        Debug ""+eventwidget( )\class +" "+ eventwidget( )\draw_x( ) +" "+ eventwidget( )\draw_y( ) +" "+ eventwidget( )\draw_width( ) +" "+ eventwidget( )\draw_height( )
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
    If StartEnumerate( Root())
      Debug widget( )\text\string
      
      If widget( )\TabBox( )
        Debug "TabBox( ) "+widget( )\TabBox( )\draw_x( ) +" "+ widget( )\TabBox( )\draw_y( ) +" "+ widget( )\TabBox( )\draw_width( ) +" "+ widget( )\TabBox( )\draw_height( )
        bind(widget( ), @events(), #__event_down)
        bind(widget( ), @events(), #__event_up)
        bind(widget( )\TabBox( ), @events(), #__event_down)
        bind(widget( )\TabBox( ), @events(), #__event_up)
      Else
        Debug ""+widget( )\class +" "+ widget( )\draw_x( ) +" "+ widget( )\draw_y( ) +" "+ widget( )\draw_width( ) +" "+ widget( )\draw_height( )
      EndIf
      StopEnumerate( )
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
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 26
; FirstLine = 23
; Folding = --
; EnableXP