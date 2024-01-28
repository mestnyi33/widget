XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global._s_widget *BackColor, *FrameColor, *position, *size, *grid
  
  Procedure events_widgets( )
    Protected *this._s_widget = EventWidget( )
    
    Select WidgetEventType( )
      Case #__event_LeftClick
        Select *this 
          Case *FrameColor
            
          Case *BackColor
            
        EndSelect
        
      Case #__event_StatusChange
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
            
          Case *grid
            mouse( )\steps = GetState(*grid)
            
        EndSelect
  EndSelect
  
  Debug a_focused( )
  EndProcedure
  

  If Open(0, 0, 0, 230+230+15, 230, "anchor-demos", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Container( 10,10,220,210 )
    a_init( widget( ),5 )
    
    image( 5,5,60,60, -1 )
    Bind( widget( ), @events_widgets( ), #__event_StatusChange )
    Define *a._s_widget = Container( 50,45,135,95, #__flag_nogadgets )
    Bind( widget( ), @events_widgets( ), #__event_StatusChange )
    image( 150,110,60,60, -1 )
    Bind( widget( ), @events_widgets( ), #__event_StatusChange )
    a_set( *a )
    CloseList( )
    
    Define y = 0
    ;Window( 235,10,230,190+y, "preferences", #PB_Window_TitleBar ) : widget( )\barHeight = 19 : SetFrame( widget( ), 1)
    Container( 235,10,230,210, #PB_Container_BorderLess )
    ;Frame( 0,0,230,210, " preferences " )
    
    y = 20
    Text( 10,10+y,100,18, "grid size", #PB_Text_Border )
    *grid = Spin( 10,30+y,100,30, 0,100 )
    
    Text( 10,70+y,100,18, "anchor size", #PB_Text_Border )
    *size = Spin( 10,90+y,100,30, 0,30 )
    
    Text( 10,130+y,100,18, "anchor position", #PB_Text_Border )
    *position = Spin( 10,150+y,100,30, 0,59 )
    
    
    *FrameColor = Button( 120,90+y,100,30, "FrameColor" )
    *BackColor = Button( 120,150+y,100,30, "BackColor" )
    
    
    If a_focused( )
      SetState(*grid, mouse( )\steps )
      SetState(*size, a_focused( )\anchors\size )
      SetState(*position, a_focused( )\anchors\pos )
    EndIf
    
    ;\\
    Bind( *grid, @events_widgets( ), #__event_Change )
    Bind( *size, @events_widgets( ), #__event_Change )
    Bind( *position, @events_widgets( ), #__event_Change )
    Bind( *BackColor, @events_widgets( ), #__event_LeftClick )
    Bind( *FrameColor, @events_widgets( ), #__event_LeftClick )
    
    WaitClose( )
  EndIf
  
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 47
; FirstLine = 18
; Folding = --
; EnableXP