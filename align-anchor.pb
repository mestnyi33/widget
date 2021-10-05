XIncludeFile "widgets.pbi"

DeclareModule Align
  Declare.i Widget( x = 10, y = 10, width = 120, height = 140 )
EndDeclareModule

Module Align
  Global *AlignWidget.structures::_s_widget
  Global L_Button, T_Button, R_Button, B_Button
  Global LT_Button, RT_Button, LB_Button, RB_Button
  Global C_Button, S_Screen, C_Add1, C_Add2, C_Add3
  
  Procedure   Events( )
    Protected left, right, top, bottom
    
    Select widget::WidgetEventType( )
      Case #PB_EventType_LeftClick
        Select widget::EventWidget( )
          Case C_Button
            widget::SetState( L_Button, 0 )
            widget::SetState( T_Button, 0 )
            widget::SetState( R_Button, 0 )
            widget::SetState( B_Button, 0 )
            
          Case LT_Button
            If Not widget::GetState( LB_Button ) Or widget::GetState( RB_Button )
              widget::SetState( L_Button, widget::GetState( LT_Button ) )
            EndIf
            If Not widget::GetState( RT_Button ) Or widget::GetState( RB_Button )
              widget::SetState( T_Button, widget::GetState( LT_Button ) )
            EndIf
            
          Case RT_Button
            If Not widget::GetState( RB_Button ) Or widget::GetState( LB_Button )
              widget::SetState( R_Button, widget::GetState( RT_Button ) )
            EndIf
            If Not widget::GetState( LT_Button ) Or widget::GetState( LB_Button )
              widget::SetState( T_Button, widget::GetState( RT_Button ) )
            EndIf
            
          Case LB_Button
            If Not widget::GetState( LT_Button ) Or widget::GetState( RT_Button )
              widget::SetState( L_Button, widget::GetState( LB_Button ) )
            EndIf
            If Not widget::GetState( RB_Button ) Or widget::GetState( RT_Button )
              widget::SetState( B_Button, widget::GetState( LB_Button ) )
            EndIf
            
          Case RB_Button
            If Not widget::GetState( RT_Button ) Or widget::GetState( LT_Button )
              widget::SetState( R_Button, widget::GetState( RB_Button ) )
            EndIf
            If Not widget::GetState( LB_Button ) Or widget::GetState( LT_Button )
              widget::SetState( B_Button, widget::GetState( RB_Button ) )
            EndIf
            
        EndSelect
        
        If widget::GetState( L_Button ) And widget::GetState( T_Button )
          widget::SetState( LT_Button, 1 )
        Else
          widget::SetState( LT_Button, 0 )
        EndIf
        If widget::GetState( R_Button ) And widget::GetState( T_Button )
          widget::SetState( RT_Button, 1 )
        Else
          widget::SetState( RT_Button, 0 )
        EndIf
        If widget::GetState( L_Button ) And widget::GetState( B_Button )
          widget::SetState( LB_Button, 1 )
        Else
          widget::SetState( LB_Button, 0 )
        EndIf
        If widget::GetState( R_Button ) And widget::GetState( B_Button )
          widget::SetState( RB_Button, 1 )
        Else
          widget::SetState( RB_Button, 0 )
        EndIf
        
        left = widget::GetState( L_Button )
        top = widget::GetState( T_Button )
        right = widget::GetState( R_Button )
        bottom = widget::GetState( B_Button )
        
        widget::SetAlignment( *AlignWidget, left, top, right, bottom )
    EndSelect
  EndProcedure
  
  Procedure.i Widget( x = 10, y = 10, width = 120, height = 140 )
    Protected butt_size = 15, screen_size = 50, pos = 1
    Protected widget = widget::Container( x, y, width, height )
    
    ;
    S_Screen = widget::Container( x+pos+butt_size, y+pos+butt_size, screen_size, screen_size ) ;:Disable( S_Screen,1 )
    *AlignWidget = widget::Button( 0, 0, butt_size+2, butt_size+2, "" ) : widget::SetAlignment( *AlignWidget, 1,1,0,0 )
    widget::CloseList( )
    
    ;
    L_Button  = widget::Button( x, y+pos+butt_size, butt_size, screen_size, " ", constants::#__button_Toggle|constants::#__button_vertical, -1, 7 )                                              ;:ToolTip(L_Button,  "Включить привязку (влево)")
    T_Button  = widget::Button( x+pos+butt_size, y, screen_size, butt_size, " ", constants::#__button_Toggle, -1, 7 )                                                                 ;:ToolTip(T_Button,  "Включить привязку (верх)")
    R_Button  = widget::Button( x+pos+pos+butt_size+screen_size, y+pos+butt_size, butt_size, screen_size, " ", constants::#__button_Toggle|constants::#__button_vertical|constants::#__text_invert, -1, 7 ) ;:ToolTip(R_Button,  "Включить привязку (вправо)")
    B_Button  = widget::Button( x+pos+butt_size, y+pos+pos+butt_size+screen_size, screen_size, butt_size, " ", constants::#__button_Toggle|constants::#__text_invert, -1, 7 )                    ;:ToolTip(B_Button,  "Включить привязку (вниз)")
    LT_Button = widget::Button( x, y, butt_size, butt_size, " ", constants::#__button_Toggle, -1, 7 )                                                                                 ;:ToolTip(LT_Button, "Включить привязку (влево верх)")
    RT_Button = widget::Button( x+pos+pos+butt_size+screen_size, y, butt_size, butt_size, " ", constants::#__button_Toggle, -1, 7 )                                                   ;:ToolTip(RT_Button, "Включить привязку (вправо верх)")
    LB_Button = widget::Button( x, y+pos+pos+butt_size+screen_size, butt_size, butt_size, " ", constants::#__button_Toggle, -1, 7 )                                                   ;:ToolTip(LB_Button, "Включить привязку (влево вниз)")
    RB_Button = widget::Button( x+pos+pos+butt_size+screen_size, y+pos+pos+butt_size+screen_size, butt_size, butt_size, " ", constants::#__button_Toggle, -1, 7 )                     ;:ToolTip(RB_Button, "Включить привязку (вправо вниз)")
    C_Button  = widget::Button( x+pos+(screen_size+butt_size)/2, y+pos+(screen_size+butt_size)/2, butt_size, butt_size, "", 0, -1, 7 )                                     ;:ToolTip(C_Button,  "Включить привязку (вцентре)")
    
    ;
    widget::SetState( L_Button, 1 )
    widget::SetState( T_Button, 1 )
    widget::SetState( LT_Button, 1 )
    
    ;
    ;y+10
    C_Add1 = widget::Option( x, y+pos+pos+pos+butt_size+butt_size+screen_size, butt_size, butt_size*2, "auto", constants::#__text_center)
    C_Add2 = widget::Option( x+pos+(screen_size+butt_size)/2, y+pos+pos+pos+butt_size+butt_size+screen_size, butt_size, butt_size*2, "prop", constants::#__text_center );+#LF+"ortional", constants::#__text_center|constants::#__text_multiline)
    C_Add3 = widget::Option( x+pos+pos+butt_size+screen_size, y+pos+pos+pos+butt_size+butt_size+screen_size, butt_size, butt_size*2, "full", constants::#__text_center )
    
    ;widget::SetState( C_Add2, 1 )
    ;;widget::SetColor( C_Add1, #PB_Gadget_FrontColor, $DCE89F1F )
    widget::SetColor( C_Add2, #PB_Gadget_FrontColor, $DCE89F1F )
    ;;widget::SetColor( C_Add3, #PB_Gadget_FrontColor, $DCE89F1F )
    
    ;widget::Bind( C_Add,@Additinal( ) )
    widget::Bind( #PB_All, @Events( ) )
    widget::bind( -1,-1 )
    widget::CloseList( )
    
    ProcedureReturn *AlignWidget
  EndProcedure
EndModule

UseLib( widget )
Global *this._s_widget, Window_3, AlignWidget, AlignParentWidget, demo, demo_p
  
Procedure ShowAlignWindow( )
  x = 200;DesktopMouseX( )+20
  y = 200;DesktopMouseY( )-10
  ResizeWindow( Window_3, x, y, #PB_Ignore, #PB_Ignore )
  HideWindow( Window_3, 0 )
EndProcedure

Window_3 = OpenWindow( #PB_Any, 0, 0, 400, 300, "Привязка выбраных гаджетов", #PB_Window_SystemMenu | #PB_Window_Tool | #PB_Window_Invisible )
Open( Window_3 )
demo_p = Container(0,0,400,300)
SetColor( widget( ), #PB_Gadget_BackColor, $4737D53F )
;demo = Button( 120, 130, 60, 20, "demo" )  
demo = Button( 10, 0, 60, 20, "demo" )  
SetAlignment( demo, 1, 1, 0, 0 )
CloseList( )

AlignWidget = Align::Widget( )
AlignParentWidget = GetParent( GetParent( AlignWidget ) )

Splitter( 0,0,400,300, demo_p, AlignParentWidget, #PB_Splitter_Vertical )
SetState( widget( ), 400-130)

Procedure Sha_Events( )
    Protected left, right, top, bottom
    
    If EventWidget( )\align
      left = EventWidget( )\align\anchor\left
      top = EventWidget( )\align\anchor\top
      right = EventWidget( )\align\anchor\right
      bottom = EventWidget( )\align\anchor\bottom
    EndIf
    
    Debug ""+left +" "+ top +" "+ right +" "+ bottom
    SetAlignment( demo, left, top, right, bottom )
EndProcedure

Bind( AlignWidget, @Sha_Events( ), #__event_resize )

ShowAlignWindow( )

Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --f-
; EnableXP