XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  EnableExplicit
  Global *mdi, MyCanvas, x=100, y=100, width=320, height=320
  
  Procedure MDIImage_Events( )
    Static Drag
    
    Select WidgetEventType( )
      Case #PB_EventType_LeftButtonUp 
        Drag = #False
        
      Case #PB_EventType_LeftButtonDown
        Drag = #True
        
      Case #PB_EventType_MouseMove, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
        If Drag = #True
          If Resize( EventWidget( ), mouse()\x-mouse()\delta\x, mouse()\y-mouse()\delta\y, #PB_Ignore, #PB_Ignore)
            ProcedureReturn #PB_EventType_Repaint
          EndIf
        EndIf
        
    EndSelect
  EndProcedure
  
  Procedure MDIImage_Add( *mdi, x, y, img, alphatest=0, round = 0 )
    Protected *this._s_widget = AddItem( *mdi, -1, "", img, #__flag_BorderLess )
    Resize(*this, x, y, ImageWidth( img ), ImageHeight( img ))
    SetClass(*this, "image-"+Str(img))
    SetCursor( *this, #PB_Cursor_Hand )
    
    Bind( *this, @MDIImage_Events(), #PB_EventType_LeftButtonUp )
    Bind( *this, @MDIImage_Events(), #PB_EventType_LeftButtonDown )
    Bind( *this, @MDIImage_Events(), #PB_EventType_MouseMove )
  EndProcedure
  
  If Not OpenWindow(0, 0, 0, width+x*2+20, height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  Define hole = CreateImage( #PB_Any,100,100,32 )
  If StartDrawing( ImageOutput( hole ) )
    DrawingMode( #PB_2DDrawing_AllChannels )
    Box( 0,0,OutputWidth(),OutputHeight(),RGBA( $00,$00,$00,$00 ) )
    Circle( 50,50,48,RGBA( $00,$FF,$FF,$FF ) )
    Circle( 50,50,30,RGBA( $00,$00,$00,$00 ) )
    StopDrawing( )
  EndIf
  
  MyCanvas = GetGadget(Open(0, 10, 10))
  *mdi = MDI(x,y,width,height);, #__flag_autosize)
                              ;a_init( *mdi )
  
  MDIImage_Add( *mdi, -80, -20, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp" ) )
  MDIImage_Add( *mdi, 100, 100, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp" ) )
  MDIImage_Add( *mdi, 210, 250, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp" ) )
  MDIImage_Add( *mdi,180,180,hole, #True, 100 )
  
  ;
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP