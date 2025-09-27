XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_widget *BackColor, *FrameColor, *position, *size, *grid, *gridType
   
   Procedure events_widgets( )
      Protected *this._s_widget = EventWidget( )
      
      Select WidgetEvent( )
         Case #__event_LeftClick
            Select *this 
               Case *FrameColor
                  
               Case *BackColor
                  
            EndSelect
            
         Case #__event_StatusChange
            Debug " StatusChange"
            
            If *size
               SetState(*size, a_getsize( *this ))
            EndIf
            
            If *position
               SetState(*position, a_getpos( *this ))
            EndIf
            
            If *grid
               SetState(*grid, DesktopUnscaledX(mouse( )\steps) )
            EndIf
            
         Case #__event_Change
           ; Debug ""+ GetState(*size) +" "+  GetState(*position)
            
            Select *this 
               Case *size
                  a_set( a_focused( ), #__a_full, GetState(*this), GetState(*position))
                  
               Case *position
                  a_set( a_focused( ), #__a_full, GetState(*size), GetState(*this))
                  
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
      
      Image( 5,5,60,60, -1 )
      Define *a._s_widget = Container( 50,45,135,95, #__flag_nogadgets )
      Image( 150,110,60,60, -1 )
      a_set( *a )
      CloseList( )
      
      Bind( ID(1), @events_widgets( ), #__event_StatusChange )
      Bind( ID(2), @events_widgets( ), #__event_StatusChange )
      Bind( ID(3), @events_widgets( ), #__event_StatusChange )
      
      Define Y = 0
      ;Window( 235,10,230,190+y, "preferences", #PB_Window_TitleBar ) : widget( )\barHeight = 19 : SetFrame( widget( ), 1)
      Container( 235,10,230,210, #PB_Container_BorderLess )
      ;Frame( 0,0,230,210, " preferences " )
      
      Y = 20
      Text( 10,10+Y,100,18, "grid size");, #PB_Text_Border )
      *grid = Spin( 10,30+Y,100,30, 0,100 )
      
      Text( 10,70+Y,100,18, "anchor size");, #PB_Text_Border )
      *size = Spin( 10,90+Y,100,30, 0,30 )
      
      Text( 10,130+Y,100,18, "anchor position");, #PB_Text_Border )
      *position = Spin( 10,150+Y,100,30, 0,59 )
      ;test_event_send=1
      ;\\
      *gridType = ComboBox( 120,30+Y,100,30 )
      AddItem(*gridType, -1, "grid [point]" )
      AddItem(*gridType, -1, "grid [line]" )
      ;SetState(*gridType, 0)
      
      *FrameColor = Button( 120,90+Y,100,30, "FrameColor" )
      *BackColor = Button( 120,150+Y,100,30, "BackColor" )
      
;      ;
       Post( a_focused( ), #__event_StatusChange )
;        
      ;\\
      Bind( *grid, @events_widgets( ), #__event_Change )
      Bind( *size, @events_widgets( ), #__event_Change )
      Bind( *position, @events_widgets( ), #__event_Change )
      ;
      Bind( *gridType, @events_widgets( ), #__event_Change )
      Bind( *BackColor, @events_widgets( ), #__event_LeftClick )
      Bind( *FrameColor, @events_widgets( ), #__event_LeftClick )
      
      
      
      ;Post( *gridType, #__event_Change )
       ;SetState(*gridType, 1)
      
      WaitClose( )
   EndIf
   
   
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 36
; FirstLine = 25
; Folding = --
; EnableXP
; DPIAware