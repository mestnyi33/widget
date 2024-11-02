 IncludePath "../../../" : XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  EnableExplicit
  Global Event.i, MyCanvas, *mdi._s_widget, vButton, hButton
  Global x=200,y=150, width=320, height=320 , focus
  
  Procedure Gadgets_Events()
    ;     Select Event
    ;       Case #PB_Event_Gadget
    Select EventGadget()
      Case 2
        If GetGadgetState(2)
          SetGadgetState(3, GetAttribute(*mdi\scroll\v, #__bar_invert))
        Else
          SetGadgetState(3, GetAttribute(*mdi\scroll\h, #__bar_invert))
        EndIf
        
      Case 3
        If GetGadgetState(2)
          SetAttribute(*mdi\scroll\v, #__bar_invert, Bool(GetGadgetState(3)))
          SetWindowTitle(0, Str(GetState(*mdi\scroll\v)))
        Else
          SetAttribute(*mdi\scroll\h, #__bar_invert, Bool(GetGadgetState(3)))
          SetWindowTitle(0, Str(GetState(*mdi\scroll\h)))
        EndIf
        ; Canvas_Draw(MyCanvas, Images( ))
        
      Case 4
        If GetGadgetState(2)
          SetAttribute(*mdi\scroll\v, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * vButton)
          SetWindowTitle(0, Str(GetState(*mdi\scroll\v)))
        Else
          SetAttribute(*mdi\scroll\h, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * hButton)
          SetWindowTitle(0, Str(GetState(*mdi\scroll\h)))
        EndIf
        ; Canvas_Draw(MyCanvas, Images( ))
        
      Case 5
        ; Canvas_Draw(MyCanvas, Images( ))
        
    EndSelect
    ;     EndSelect
    
  EndProcedure
  
  Macro Area_Draw( _this_ )
    ;     widget::bar_updates( _this_,
    ;                          _this_\scroll\h\x, 
    ;                          _this_\scroll\v\y, 
    ;                          (_this_\scroll\v\x+_this_\scroll\v\width)-_this_\scroll\h\x,
    ;                          (_this_\scroll\h\y+_this_\scroll\h\height)-_this_\scroll\v\y )
    ;     
    ;     If Not _this_\scroll\v\hide
    ;       widget::Draw( _this_\scroll\v )
    ;     EndIf
    ;     If Not _this_\scroll\h\hide
    ;       widget::Draw( _this_\scroll\h )
    ;     EndIf
    
    UnclipOutput( )
    DrawingMode( #PB_2DDrawing_Outlined )
    Box( x, y, Width, Height, RGB( 0,255,0 ) )
    Box( _this_\scroll\h\x, _this_\scroll\v\y, _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, RGB( 0,0,255 ) )
    
    ; Box( _this_\x[#__c_required], _this_\y[#__c_required], _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, RGB( 255,0,0 ) )
    Box( _this_\scroll\h\x -_this_\scroll\h\bar\page\pos, _this_\scroll\v\y - _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, RGB( 255,0,0 ) )
  EndMacro
  
  Procedure CustomEvents( )
    Static DragWidget
    
    Select WidgetEvent( )
;       Case #__event_MouseEnter
;         SetCursor( EventWidget( ), #PB_Cursor_Hand )
;         
;       Case #__event_MouseLeave
;         SetCursor( EventWidget( ), #PB_Cursor_Default )
        
      Case #__event_LeftButtonUp 
        DragWidget = #Null
        
      Case #__event_LeftButtonDown
;         ; get alpha
;         If EventWidget( )\image[#__img_background]\id And
;            EventWidget( )\image[#__img_background]\depth > 31 And 
;            StartDrawing( ImageOutput( EventWidget( )\image[#__img_background]\img ) )
;           
;            DrawingMode( #PB_2DDrawing_AlphaChannel )
;            If Alpha( Point( Mouse( )\x - EventWidget( )\x[#__c_inner], Mouse( )\y - EventWidget( )\y[#__c_inner] ) )
;              DragWidget = EventWidget( )
;            EndIf
;           
;           StopDrawing( )
;         Else
;           DragWidget = EventWidget( )
;         EndIf
        DragWidget = EventWidget( )
        
      Case #__event_MouseMove
        If DragWidget = EventWidget( )
          Resize( EventWidget( ), mouse()\x-mouse()\delta\x, mouse()\y-mouse()\delta\y, #PB_Ignore, #PB_Ignore)
        EndIf
        
      Case #__event_Draw
        
        ; Demo draw on element
        UnclipOutput()
        DrawingMode(#PB_2DDrawing_Outlined)
        
        Protected draw_color 
        If Eventwidget()\width[#__c_draw] > 0 And
           Eventwidget()\height[#__c_draw] > 0
          draw_color = $ff00ff00
        Else
          draw_color = $ff00ffff
        EndIf
        
        If Eventwidget()\round
          RoundBox(Eventwidget()\x,Eventwidget()\y,Eventwidget()\width,Eventwidget()\height, Eventwidget()\round, Eventwidget()\round, draw_color)
        Else
          Box(Eventwidget()\x,Eventwidget()\y,Eventwidget()\width,Eventwidget()\height, draw_color)
        EndIf
        
        Area_Draw( EventWidget( )\parent )
        
    EndSelect
    
  EndProcedure
  
  Procedure Canvas_AddImage( *mdi, x, y, img, round=0 )
    Protected *this._s_widget
    *this = AddItem( *mdi, -1, "", img, #__flag_BorderLess )
    *this\class = "image-"+Str(img)
    *this\round = round
    Static count
    Select count
      Case 0, 4
        *this\cursor = #PB_Cursor_Hand
      Case 1
        *this\cursor = #PB_Cursor_Cross
    EndSelect
    count + 1
    *this\fs = 10
    ;SetCursor( *this, #PB_Cursor_Hand )
    Resize(*this, x, y, ImageWidth( img ), ImageHeight( img ))
    
    Bind( *this, @CustomEvents(), #__event_LeftButtonUp )
    Bind( *this, @CustomEvents(), #__event_LeftButtonDown )
    Bind( *this, @CustomEvents(), #__event_MouseMove )
    Bind( *this, @CustomEvents(), #__event_MouseEnter )
    Bind( *this, @CustomEvents(), #__event_MouseLeave )
    Bind( *this, @CustomEvents(), #__event_Draw )
    Bind( #PB_All, @CustomEvents(), #__event_Repaint )
  EndProcedure
  
  Procedure Canvas_resize( )
    ;Protected width = GadgetWidth( EventGadget() )
    Protected width = WindowWidth( EventWindow() )
    Resize( Root(), #PB_Ignore, #PB_Ignore, width, #PB_Ignore )
    Resize( *mdi, #PB_Ignore, #PB_Ignore, width-x*2, #PB_Ignore )
  EndProcedure
  
  Define yy = 90
  Define xx = 0
  If Not OpenWindow( 0, 0, 0, Width+x*2+20+xx, Height+y*2+20+yy, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered ) 
    MessageRequester( "Fatal error", "Program terminated." )
    End
  EndIf
  
  ;BindEvent(#PB_Event_SizeWindow, @Window_Resize(), 0)
  ;
  CheckBoxGadget(2, 10, 10, 80,20, "vertical") : SetGadgetState(2, 1)
  CheckBoxGadget(3, 10, 30, 80,20, "invert")
  CheckBoxGadget(4, 10, 50, 80,20, "noButtons")
  CheckBoxGadget(5, 10, 70, 80,20, "clipoutput") : SetGadgetState(5, 1)
  
  If CreateImage(0, 200, 80)
    
    StartDrawing(ImageOutput(0))
    
    FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
    
    DrawingMode(#PB_2DDrawing_Default)
    Box(5, 10, 30, 2, RGB( 0,255,0 ))
    Box(5, 10+25, 30, 2, RGB( 0,0,255 ))
    Box(5, 10+50, 30, 2, RGB( 255,0,0 ))
    
    DrawingMode(#PB_2DDrawing_Transparent)
    DrawText(40, 5, "frame - (coordinate color)",0,0)
    DrawText(40, 30, "page - (coordinate color)",0,0)
    DrawText(40, 55, "max - (coordinate color)",0,0)
    
    StopDrawing() ; This is absolutely needed when the drawing operations are finished !!! Never forget it !
    
  EndIf
  ImageGadget(#PB_Any, Width+x*2+20-210,10,200,80, ImageID(0) )
  
  Define round = 50
  Define hole = CreateImage( #PB_Any,100,100,32 )
  If StartDrawing( ImageOutput( hole ) )
    DrawingMode( #PB_2DDrawing_AllChannels )
    ; transporent back 
    Box( 0,0,OutputWidth(),OutputHeight(),RGBA( $00,$00,$00,$00 ) )
    
    Circle( 50,50,round,RGBA( $00,$FF,$FF,$FF ) )
    Circle( 50,50,30,RGBA( $00,$00,$00,$00 ) )
    StopDrawing( )
  EndIf
  
  Define hole2 = CreateImage( #PB_Any,200,60,32 )
  If StartDrawing( ImageOutput( hole2 ) )
    DrawingMode( #PB_2DDrawing_AllChannels )
    ; transporent back 
    Box( 0,0,OutputWidth(),OutputHeight(),RGBA( $00,$00,$00,$00 ) )
    
    DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AllChannels )
    RoundBox( 0,0,OutputWidth(),OutputHeight(),100,100,RGBA(213, 55, 109, 71) )
    DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AllChannels )
    RoundBox( 0,0,OutputWidth(),OutputHeight(),100,100,RGBA(213, 55, 109, 218) )
    
    StopDrawing( )
  EndIf
  
  ;
  MyCanvas = GetGadget(Open(0, xx+10, yy+10, Width+x*2, Height+y*2 ) )
  SetColor(root(), #__color_back, $ffffffff)
  
  ;   ;BindGadgetEvent(MyCanvas, @Canvas_resize(), #PB_EventType_Resize )
  ;   ;BindEvent(#PB_Event_SizeWindow, @Canvas_resize());, GetWindow(Root()), MyCanvas, #PB_EventType_Resize )
  
  *mdi = MDI(x,y,width,height);, #__flag_autosize)
                              ;a_init( *mdi )
  SetColor(*mdi, #__color_back, $ffffffff)
  ;SetColor(*mdi, #__color_frame, $ffffffff)
  
  Define b=19;20        
  *mdi\scroll\v\round = 11
  *mdi\scroll\v\bar\button[1]\round = *mdi\scroll\v\round
  *mdi\scroll\v\bar\button[2]\round = *mdi\scroll\v\round
  *mdi\scroll\v\bar\button\round = *mdi\scroll\v\round
  SetAttribute(*mdi\scroll\v, #__bar_buttonsize, b)
  
  *mdi\scroll\h\round = 11
  *mdi\scroll\h\bar\button[1]\round = *mdi\scroll\h\round
  *mdi\scroll\h\bar\button[2]\round = *mdi\scroll\h\round
  *mdi\scroll\h\bar\button\round = *mdi\scroll\h\round
  SetAttribute(*mdi\scroll\h, #__bar_buttonsize, b)
  
  ;Debug *mdi\Scroll\v\round
  vButton = GetAttribute(*mdi\Scroll\v, #__bar_buttonsize);+1
  hButton = GetAttribute(*mdi\Scroll\h, #__bar_buttonsize);+1
  
  Canvas_AddImage( *mdi, -50, 90, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp" ) )
  Canvas_AddImage( *mdi, 100, 80, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp" ) )
  Canvas_AddImage( *mdi, 210, 250, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp" ) )
  
  Canvas_AddImage( *mdi,-70,240,hole, round )
  Canvas_AddImage( *mdi,90,30,hole2, 100 )
  
  BindEvent( #PB_Event_Gadget, @Gadgets_Events() )
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 70
; FirstLine = 70
; Folding = --v+
; EnableXP
; DPIAware