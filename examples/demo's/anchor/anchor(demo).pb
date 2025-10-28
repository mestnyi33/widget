XIncludeFile "../../../widgets.pbi"    

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_focus_draw = 0
   
   Global._s_widget *BackColor, *FrameColor, *BackColorType, *FrameColorType, *position, *size, *grid, *gridType
   Global ColorState
Global ColorType 

   Procedure events_widgets( )
      Protected *this._s_widget = EventWidget( )
      
      Select WidgetEvent( )
         Case #__event_Focus
            Debug " Focus"
            
            If *size
               SetState(*size, a_getsize( *this ))
            EndIf
            
            If *position
               SetState(*position, a_getpos( *this ))
            EndIf
            
            If *grid
               SetState(*grid, DesktopUnscaledX(mouse( )\steps) )
            EndIf
            
         Case #__event_LeftClick
            Define Message$, Color.l 
            
            Select *this
               Case *FrameColor
                  color = a_anchors( )\framecolor[GetState(*FrameColorType)] & $FFFFFF
               Case *BackColor
                  color = a_anchors( )\backcolor[GetState(*BackColorType)] & $FFFFFF
            EndSelect
            
            Define Message$, Color.l = ColorRequester( Color )
            
            If Color > - 1
               Message$ = "Вы выбрали следующее значение цвета:"   + #LF$
               Message$ + "32 Bit value: " + Str(Color)            + #LF$
               Message$ + "Red значение:    " + Str(Red(Color))    + #LF$
               Message$ + "Green значение:  " + Str(Green(Color))  + #LF$
               Message$ + "Blue значение:  " + Str(Blue(Color))  + #LF$
               Message$ + "Alpha значение:  " + Str(Alpha(Color))
               
               Select *this
                  Case *FrameColor
                     a_anchors( )\framecolor[GetState(*FrameColorType)] = Color & $FFFFFF | 255 << 24
                  Case *BackColor
                     a_anchors( )\backcolor[GetState(*BackColorType)] = Color & $FFFFFF | 255 << 24
               EndSelect
            Else
               Message$ = "Запрос был отменён."
            EndIf
            ; MessageRequester("Инфо", Message$, 0)
            
            
                     
         Case #__event_Change
            Debug "CHANGE "+ GetState(*size) +" "+  GetState(*position) +" "+*this\class
            
            Select *this 
               Case *size
                  ; a_set( a_focused( ), #__a_full, GetState(*this), GetState(*position))
                  a_setsize( a_focused( ), GetState(*this) )
                  
               Case *position
                  ; a_set( a_focused( ), #__a_full, GetState(*size), GetState(*this))
                  a_setpos( a_focused( ), GetState(*this) )
                  
               Case *grid, *gridType
                  mouse( )\steps = DPIScaled(GetState(*grid))
                  a_anchors( )\grid_type = GetState(*gridType)
;                  ; Debug 66666;                   ; remove background image
;                   ;                   SetBackgroundImage( a_focused( )\parent, - 1 )
;                   ;                   If IsImage( a_anchors( )\grid_image )
;                   ;                      FreeImage( a_anchors( )\grid_image )
;                   ;                      a_anchors( )\grid_image = - 1
;                   ;                   EndIf
;                   RemoveImage( a_focused( )\parent, a_anchors( )\grid_image )
;                   
;                   a_anchors( )\grid_image = a_grid_image( mouse( )\steps - 1, a_anchors( )\grid_type, $FF000000, 0,0);*this\fs, *this\fs )
;                   SetBackgroundImage( a_focused( )\parent, a_anchors( )\grid_image )
;                   Resize( a_focused( )\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
;                   ;ReDraw( a_focused( )\root )
            EndSelect
      EndSelect
   EndProcedure
   
   
   If Open(0, 0, 0, 230+230+15, 230, "anchor-demos", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Container( 10,10,220,210 )
      a_init( widget( ),5 )
      
      Define *a1._s_widget = Image( 5,5,60,60, -1 )
      Define *a2._s_widget = Container( 50,45,135,95, #__flag_nogadgets )
      Define *a3._s_widget = Image( 150,110,60,60, -1 )
      
      a_setpos( *a1, 2 )
      a_setsize( *a1, 6 )
      a_set( *a1 )
      
      a_setpos( *a2, 8 )
      a_setsize( *a2, 12 )
      a_set( *a2 )
      CloseList( )
      
      Bind( ID(1), @events_widgets( ), #__event_Focus )
      Bind( ID(2), @events_widgets( ), #__event_Focus )
      Bind( ID(3), @events_widgets( ), #__event_Focus )
      
      Define Y = 20
      Window( 235,10,230,185, "preferences", #PB_Window_TitleBar ) : SetFrame( widget( ), 1) : Y - 25
      ;Container( 235,10,230,210, #PB_Container_BorderLess )
      ;Frame( 0,0,230,210, " preferences " )
      
      Text( 10,10+Y,100,18, "grid size:");, #PB_Text_Border )
      *grid = Spin( 10,30+Y,70,30, 0,100 ) : SetClass(*grid,"GRID" )
      
      Text( 10,70+Y,100,18, "anchor size:");, #PB_Text_Border )
      *size = Spin( 10,90+Y,70,30, 0,30 ) : SetClass(*size,"SIZE" )
      
      Text( 10,130+Y,100,18, "anchor pos:");, #PB_Text_Border )
      *position = Spin( 10,150+Y,70,30, 0,59 ) : SetClass(*position,"POSITION" )
      
      ;test_event_send=1
      ;\\
      Text( 90,10+Y,130,18, "grid type");, #PB_Text_Border )
      *gridType = ComboBox( 90,30+Y,130,30 )
      AddItem(*gridType, -1, "grid [point]" )
      AddItem(*gridType, -1, "grid [line]" )
      SetState(*gridType, 0)
      
      Text( 90,70+Y,130,18, "anchor frame color type");, #PB_Text_Border )
      *FrameColorType = ComboBox( 90,90+Y,100,30 )
      AddItem(*FrameColorType, -1, "default" )
      AddItem(*FrameColorType, -1, "entered" )
      AddItem(*FrameColorType, -1, "pressed" )
      SetState(*FrameColorType, 0)
      *FrameColor = Button( 190,90+Y,30,30, "..." )
      
      Text( 90,130+Y,130,18, "anchor back color type");, #PB_Text_Border )
      *BackColorType = ComboBox( 90,150+Y,100,30 )
      AddItem(*BackColorType, -1, "default" )
      AddItem(*BackColorType, -1, "entered" )
      AddItem(*BackColorType, -1, "pressed" )
      SetState(*BackColorType, 0)
      *BackColor = Button( 190,150+Y,30,30, "..." )
      
      ;\\
      Bind( *grid, @events_widgets( ), #__event_Change )
      Bind( *size, @events_widgets( ), #__event_Change )
      Bind( *position, @events_widgets( ), #__event_Change )
      ;
      Bind( *gridType, @events_widgets( ), #__event_Change )
      Bind( *BackColorType, @events_widgets( ), #__event_Change )
      Bind( *FrameColorType, @events_widgets( ), #__event_Change )
      Bind( *BackColor, @events_widgets( ), #__event_LeftClick )
      Bind( *FrameColor, @events_widgets( ), #__event_LeftClick )
      
      
      
      ;Post( *gridType, #__event_Change )
       ;SetState(*gridType, 1)
      
      WaitClose( )
   EndIf
   
   
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 128
; FirstLine = 107
; Folding = --
; EnableXP
; DPIAware