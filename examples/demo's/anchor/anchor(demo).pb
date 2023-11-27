XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global._s_widget *BackColor, *FrameColor, *position, *size, *grid
  
  Procedure events_widgets( )
    Protected *this._s_widget = EventWidget( )
    
    Select WidgetEventType( )
      Case #__event_StatusChange
        If *size
          SetText(*size, Str(*this\anchors\size) )
        EndIf
        
        If *position
          SetText(*position, Str(*this\anchors\pos) )
        EndIf
        
        If *grid
          SetText(*grid, Str(a_transform( )\grid_size) )
        EndIf
        
      Case #__event_Change
        Select *this 
          Case *size
            a_set( a_focused( ), #__a_full, Val(GetText(*this)))
            SetText(*position, Str(a_focused( )\anchors\pos) )
            
          Case *position
            a_set( a_focused( ), #__a_full, Val(GetText(*size)), Val(GetText(*position)))
            SetText(*size, Str(a_focused( )\anchors\size) )
            
          Case *grid
            a_init(a_main(), Val(GetText(*grid)))
            
        EndSelect
    EndSelect
  EndProcedure
  
  Global _temp_spin_min_, _temp_spin_max_
  Procedure _temp_spin_events_( )
    Protected *val, *widget = GetData( EventWidget( ) )
    
    Select WidgetEventType( )
      Case #__Event_LeftClick
        *val = Val( GetText( *widget ) )
        
        Select GetText( EventWidget( ) ) 
          Case "+"
            *val + 1
            If *val <= _temp_spin_max_
              SetText( *widget, Str(*val))
            EndIf
          Case "-"
            *val - 1
            If *val >= _temp_spin_min_
              SetText( *widget, Str(*val))
            EndIf
            
        EndSelect
        
        Post(GetData(widget( )), #__Event_Change )
      Case #__Event_Change
    EndSelect
  EndProcedure
  
  Procedure _temp_spin_(x,y,width,height, min, max)
    _temp_spin_min_ = min 
    _temp_spin_max_ = max
    
    Protected w=20, h=height/2-1
    Protected *string._s_widget = String(x, y, width-w-1,height,"0")
    
    Button(x+width-w, y, w,h,"+")
    SetData(widget( ), *string)
    Bind( widget( ), @_temp_spin_events_( ), #__Event_LeftClick )
    
    Button(x+width-w, y+height-h, w,h,"-")
    SetData(widget( ), *string)
    Bind( widget( ), @_temp_spin_events_( ), #__Event_LeftClick )
    
    ChangeCurrentElement(widget( ), *string\address)
    ProcedureReturn *string
  EndProcedure
  
;   Macro Spin(x,y,width,height, min, max)
;     _temp_spin_(x,y,width,height, min, max)
;   EndMacro
  
  If Open(0, 0, 0, 230+230+15, 230, "anchor-demos", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Container( 10,10,220,210 )
    a_init( widget( ),0 )
    
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
    *size = Spin( 10,90+y,100,30, 0,100 )
    
    Text( 10,130+y,100,18, "anchor position", #PB_Text_Border )
    *position = Spin( 10,150+y,100,30, 0,100 )
    
    *BackColor = Button( 120,90+y,100,30, "BackColor" )
    
    *FrameColor = Button( 120,150+y,100,30, "FrameColor" )
    
    If a_focused( )
      SetState(*grid, a_transform( )\grid_size )
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
; CursorPosition = 125
; FirstLine = 99
; Folding = ---
; EnableXP