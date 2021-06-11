XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  EnableExplicit
  Global Event.i, MyCanvas, *mdi
  Global x=100,y=100, width=320, height=320 , focus
  
  Macro Area_Draw( _this_ )
    widget::bar_updates( _this_,
                         _this_\scroll\h\x, 
                         _this_\scroll\v\y, 
                         (_this_\scroll\v\x+_this_\scroll\v\width)-_this_\scroll\h\x,
                         (_this_\scroll\h\y+_this_\scroll\h\height)-_this_\scroll\v\y )
    
    If Not _this_\scroll\v\hide
      widget::Draw( _this_\scroll\v )
    EndIf
    If Not _this_\scroll\h\hide
      widget::Draw( _this_\scroll\h )
    EndIf
    
    UnclipOutput( )
    DrawingMode( #PB_2DDrawing_Outlined )
    Box( x, y, Width, Height, RGB( 0,255,0 ) )
    Box( _this_\scroll\h\x, _this_\scroll\v\y, _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, RGB( 0,0,255 ) )
    
    ; Box( _this_\x[#__c_required], _this_\y[#__c_required], _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, RGB( 255,0,0 ) )
    Box( _this_\scroll\h\x -_this_\scroll\h\bar\page\pos, _this_\scroll\v\y - _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, RGB( 255,0,0 ) )
  EndMacro
  
  Procedure CustomEvents( )
    Static Drag
    
    Select WidgetEventType( )
      Case #PB_EventType_Draw
        Debug 6666
        
        Area_Draw( EventWidget( )\parent )
        
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
  
  Procedure Canvas_AddImage( *mdi, x, y, img, alphatest=0 )
    Protected *this._s_widget
    
    *this = AddItem( *mdi, -1, "", img, #__flag_BorderLess )
    Resize(*this, x, y, ImageWidth( img ), ImageHeight( img ))
    *this\class = "image-"+Str(img)
    *this\cursor = #PB_Cursor_Hand
    
    If alphatest
      ;*this\image[#__img_background]\transparent = 1
      ; SetColor( *this, #__color_back, #PB_Image_Transparent )
    ;;*this\transporent = Bool( *this\image[#__img_background]\id And *this\image[#__img_background]\depth > 31 )
    EndIf
    
    Bind( *this, @CustomEvents(), #PB_EventType_LeftButtonUp )
    Bind( *this, @CustomEvents(), #PB_EventType_LeftButtonDown )
    Bind( *this, @CustomEvents(), #PB_EventType_MouseMove )
    Bind( *this, @CustomEvents(), #PB_EventType_Draw )
  EndProcedure
  
  Procedure Canvas_resize( )
    ;Protected width = GadgetWidth( EventGadget() )
    Protected width = WindowWidth( EventWindow() )
    Resize( Root(), #PB_Ignore, #PB_Ignore, width, #PB_Ignore )
    Resize( *mdi, #PB_Ignore, #PB_Ignore, width-x*2, #PB_Ignore )
    ReDraw(Root())
  EndProcedure
  
  If Not OpenWindow(0, 0, 0, width+x*2+20, height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  ;BindGadgetEvent(MyCanvas, @Canvas_resize(), #PB_EventType_Resize )
  ;BindEvent(#PB_Event_SizeWindow, @Canvas_resize());, GetWindow(Root()), MyCanvas, #PB_EventType_Resize )
  
  *mdi = MDI(x,y,width,height);, #__flag_autosize)
                                     ;a_init( *mdi )
  
  Canvas_AddImage( *mdi, -80, -20, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp" ) )
  Canvas_AddImage( *mdi, 100, 100, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp" ) )
  Canvas_AddImage( *mdi, 210, 250, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp" ) )
  
  Define hole = CreateImage( #PB_Any,100,100,32 )
  If StartDrawing( ImageOutput( hole ) )
    DrawingMode( #PB_2DDrawing_AllChannels )
    ;Debug RGBA( $00,$00,$00,$00 )
    Box( 0,0,OutputWidth(),OutputHeight(),RGBA( $00,$00,$00,$00 ) )
    Circle( 50,50,48,RGBA( $00,$FF,$FF,$FF ) )
    Circle( 50,50,30,RGBA( $00,$00,$00,$00 ) )
    StopDrawing( )
  EndIf
  Canvas_AddImage( *mdi,180,180,hole, #True )
  
  
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP