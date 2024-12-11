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
          SetState(*size, *this\anchors\size )
        EndIf
        
        If *position
          SetState(*position, *this\anchors\pos )
        EndIf
        
        If *grid
          SetState(*grid, mouse( )\steps )
        EndIf
        
      Case #__event_Change
        Select *this 
          Case *size
            a_set( a_focused( ), #__a_full, GetState(*this), GetState(*position))
            
          Case *position
            a_set( a_focused( ), #__a_full, GetState(*size), GetState(*this))
            
           Case *grid, *gridType
            mouse( )\steps = DPIScaled(GetState(*grid))
            
;             If IsImage( a_transform( )\grid_image )
;               FreeImage( a_transform( )\grid_image )
;             EndIf
;             a_transform( )\grid_image = a_grid_image( mouse( )\steps, GetState(*gridType) )
;             SetBackgroundImage( a_transform( )\grid_widget, a_transform( )\grid_image )
            
;             ; 
;             If StartEnum( a_transform( )\grid_widget )
;               Resize(widget(), 
;                      DPIUnScaled(widget()\container_x()),
;                      DPIUnScaled(widget()\container_y()),
;                      DPIUnScaled(widget()\container_width()),
;                      DPIUnScaled(widget()\container_height()))
;               StopEnum( )
;             EndIf
;             ;Resize(a_transform( )\grid_widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            
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
    
    Text( 10,70+Y,100,18, "anchor size", #PB_Text_Border )
    *size = Spin( 10,90+Y,100,30, 0,30 )
    
    Text( 10,130+Y,100,18, "anchor position", #PB_Text_Border )
    *position = Spin( 10,150+Y,100,30, 0,59 )
    
    ;\\
    *gridType = ComboBox( 120,30+Y,100,30 )
    AddItem(*gridType, -1, "grid [point]" )
   AddItem(*gridType, -1, "grid [line]" )
   SetState(*gridType, 1)
   
    *FrameColor = Button( 120,90+Y,100,30, "FrameColor" )
    *BackColor = Button( 120,150+Y,100,30, "BackColor" )
    
    ; 
    If a_focused( )
      SetState(*grid, DPIUnScaled(mouse( )\steps) )
      SetState(*size, a_focused( )\anchors\size )
      SetState(*position, a_focused( )\anchors\pos )
    EndIf
    
    ;\\
    Bind( *grid, @events_widgets( ), #__event_Change )
    Bind( *size, @events_widgets( ), #__event_Change )
    Bind( *position, @events_widgets( ), #__event_Change )
    ;
    Bind( *gridType, @events_widgets( ), #__event_Change )
    Bind( *BackColor, @events_widgets( ), #__event_LeftClick )
    Bind( *FrameColor, @events_widgets( ), #__event_LeftClick )
    
    WaitClose( )
  EndIf
  
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 88
; FirstLine = 76
; Folding = --
; EnableXP
; DPIAware