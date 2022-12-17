;XIncludeFile "../../../widgets.pbi"
XIncludeFile "../../../widget-events.pbi"

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
      Case #PB_EventType_LeftClick
        *val = Val( GetText( *widget ) )
          
        Select GetText( EventWidget( ) ) 
          Case "+"
            *val + 1
            SetText( *widget, Str(*val))
          Case "-"
            *val - 1
            SetText( *widget, Str(*val))
            
        EndSelect
        
      Case #PB_EventType_Change
    EndSelect
  EndProcedure
  
  Procedure _temp_spin_(x,y,width,height, min, max)
    Protected w=20, h=height/2-1
    Protected *string._s_widget = String(x, y, width-w-1,height,"0")
    
    Button(x+width-w, y, w,h,"+")
    SetData(widget( ), *string)
    Bind( widget( ), @_temp_spin_events_( ), #PB_EventType_LeftClick )
    
    Button(x+width-w, y+height-h, w,h,"-")
    SetData(widget( ), *string)
    Bind( widget( ), @_temp_spin_events_( ), #PB_EventType_LeftClick )
    
    ChangeCurrentElement(widget( ), *string\address)
    ProcedureReturn *string
  EndProcedure
  
  Macro Spin(x,y,width,height, min, max)
    _temp_spin_(x,y,width,height, min, max)
  EndMacro
  
  If OpenWindow(0, 0, 0, 230+230+15, 210, "anchor-demos", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Open(0, 0, 0, 230+230+15, 210)
    Container( 10,10,220,190 )
    a_init( widget( ), 15 )
    image( 5,5,60,60, -1 )
    Define *a._s_widget = Container( 50,45,135,95, #__flag_nogadgets )
    image( 150,110,60,60, -1 )
    a_set( *a )
    CloseList( )
    
    Container( 235,10,230,190 )
    Frame( 5,5,230,190, "preferences" )
    Text( 10,10,100,20, "grid", #__text_border )
    *grid = Spin( 10,30,100,30, 0,100 )
    Bind( *grid, @events_widgets( ), #PB_EventType_Change )
    
    Text( 10,70,100,20, "size", #__text_border )
    *size = Spin( 10,90,100,30, 0,100 )
    Bind( *size, @events_widgets( ), #PB_EventType_Change )
    
    Text( 10,130,100,20, "position", #__text_border )
    *position = Spin( 10,150,100,30, 0,100 )
    Bind( *position, @events_widgets( ), #PB_EventType_Change )
    
    *BackColor = Button( 120,90,100,30, "BackColor" )
    Bind( *BackColor, @events_widgets( ), #PB_EventType_LeftClick )
    
    *FrameColor = Button( 120,150,100,30, "FrameColor" )
    Bind( *FrameColor, @events_widgets( ), #PB_EventType_LeftClick )
    
    WaitClose( )
  EndIf
  
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP