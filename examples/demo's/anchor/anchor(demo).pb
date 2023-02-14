XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global._s_widget *BackColor, *FrameColor, *position, *size, *grid
  
  Procedure events_widgets( )
    Select WidgetEventType( )
      Case #PB_EventType_LeftClick
      Case #PB_EventType_Change
        Debug 555
    EndSelect
  EndProcedure
  
  Procedure _temp_spin_events_( )
    Protected *val, *widget = GetData( EventWidget( ) )
    
    Select WidgetEventType( )
      Case #__Event_LeftClick
        *val = Val( GetText( *widget ) )
          
        Select GetText( EventWidget( ) ) 
          Case "+"
            *val + 1
            SetText( *widget, Str(*val))
          Case "-"
            *val - 1
            SetText( *widget, Str(*val))
            
        EndSelect
        
        Post(GetData(widget( )), #__Event_Change )
      Case #__Event_Change
    EndSelect
  EndProcedure
  
  Procedure _temp_spin_(x,y,width,height, min, max)
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
  
  Macro Spin(x,y,width,height, min, max)
    _temp_spin_(x,y,width,height, min, max)
  EndMacro
  
  If Open(0, 0, 0, 230+230+15, 230, "anchor-demos", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Container( 10,10,220,210 )
    a_init( widget( ), 15 )
    image( 5,5,60,60, -1 )
    Define *a._s_widget = Container( 50,45,135,95, #__flag_nogadgets )
    image( 150,110,60,60, -1 )
    a_set( *a )
    CloseList( )
    
    Define y = 0
    Window( 235,10,230,190+y, "preferences", #PB_Window_TitleBar ) : widget( )\barHeight = 19 : SetFrame( widget( ), 1)
    ;Container( 235,10,230,205, #PB_Container_BorderLess )
    ;Frame( 0,0,230-2,205-2, "preferences" )
    Text( 10,10+y,100,18, "grid", #PB_Text_Border )
    *grid = Spin( 10,30+y,100,30, 0,100 )
    Bind( *grid, @events_widgets( ), #PB_EventType_Change )
    
    Text( 10,70+y,100,18, "size", #PB_Text_Border )
    *size = Spin( 10,90+y,100,30, 0,100 )
    Bind( *size, @events_widgets( ), #PB_EventType_Change )
    
    Text( 10,130+y,100,18, "position", #PB_Text_Border )
    *position = PB(Spin)( 10,150+y,100,30, 0,100 )
    Bind( *position, @events_widgets( ), #PB_EventType_Change )
    
    *BackColor = Button( 120,90+y,100,30, "BackColor" )
    Bind( *BackColor, @events_widgets( ), #PB_EventType_LeftClick )
    
    *FrameColor = Button( 120,150+y,100,30, "FrameColor" )
    Bind( *FrameColor, @events_widgets( ), #PB_EventType_LeftClick )
    
    WaitClose( )
  EndIf
  
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP