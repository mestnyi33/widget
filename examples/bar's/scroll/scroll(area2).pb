XIncludeFile "../../../widgets-bar.pbi"
;XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib( widget )
  
  Structure IMAGES Extends _s_COORDINATE
    img.i
    alphatest.i
  EndStructure
  
  Global MyCanvas
  Global *current=#False
  Global currentItemXOffset.i, currentItemYOffset.i
  Global Event.i, drag.i, hole.i
  Global x=100,y=100, Width=420, Height=420 , focus
  
  Global NewList Images.IMAGES( )
  Global *this.allocate( widget )
  
  Macro DrawArea( _this_ )
    If Not _this_\scroll\v\hide
      Draw( _this_\scroll\v )
    EndIf
    If Not _this_\scroll\h\hide
      Draw( _this_\scroll\h )
    EndIf
    
    UnclipOutput( )
    DrawingMode( #PB_2DDrawing_Outlined )
    Box( x, y, Width, Height, RGB( 0,255,255 ) )
    ;;Box( _this_\x[#__c_required], _this_\y[#__c_required], _this_\width[#__c_required], _this_\height[#__c_required], RGB( 255,0,255 ) )
    ;;Box( _this_\x[#__c_required], _this_\y[#__c_required], _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, RGB( 255,0,0 ) )
    Box( _this_\scroll\h\x -_this_\scroll\h\bar\page\pos, _this_\scroll\v\y-_this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, RGB( 255,0,0 ) )
    Box( _this_\scroll\h\x, _this_\scroll\v\y, _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, RGB( 255,255,0 ) )
  EndMacro
  
  Macro CreateArea( _parent_, _x_, _y_, _width_, _height_, _size_, _callback_, _flag_=#Null)
    _parent_\scroll\v = widget::scroll( _x_+_width_-_size_, _y_, _size_, 0, 0, 0, 0, #__bar_Vertical|_flag_, 11 )
    _parent_\scroll\h = widget::scroll( _x_, _y_+_height_-_size_, 0,  _size_, 0, 0, 0, _flag_, 11 )
    
    If _callback_
      Bind( _parent_\scroll\v, _callback_ )
      Bind( _parent_\scroll\h, _callback_ )
    EndIf
  EndMacro                                                  
  
  ;-
  Macro Canvas_Change( _this_, _x_, _y_, _width_, _height_ )
    _this_\x[#__c_required] = Images( )\x 
    _this_\y[#__c_required] = Images( )\Y
    _this_\width[#__c_required] = Images( )\x+Images( )\width - _this_\x[#__c_required]
    _this_\height[#__c_required] = Images( )\Y+Images( )\height - _this_\y[#__c_required]
    
    PushListPosition( Images( ) )
    ForEach Images( )
      If _this_\x[#__c_required] > Images( )\x : _this_\x[#__c_required] = Images( )\x : EndIf
      If _this_\y[#__c_required] > Images( )\y : _this_\y[#__c_required] = Images( )\y : EndIf
    Next
    ForEach Images( )
      If _this_\width[#__c_required] < Images( )\x+Images( )\width - _this_\x[#__c_required] : _this_\width[#__c_required] = Images( )\x+Images( )\width - _this_\x[#__c_required] : EndIf
      If _this_\height[#__c_required] < Images( )\Y+Images( )\height - _this_\y[#__c_required] : _this_\height[#__c_required] = Images( )\Y+Images( )\height - _this_\y[#__c_required] : EndIf
    Next
    PopListPosition( Images( ) )
    
    widget::bar_Updates( *this, _x_, _y_, _width_, _height_ )
              
    ; SetWindowTitle( EventWindow( ), Str( Images( )\x )+" "+Str( Images( )\width )+" "+Str( Images( )\x+Images( )\width ) )
  EndMacro
  
  Procedure Canvas_Draw( canvas.i, List Images.IMAGES( ) )
    If StartDrawing( CanvasOutput( canvas ) )
      DrawingMode( #PB_2DDrawing_Default )
      Box( 0, 0, OutputWidth( ), OutputHeight( ), RGB( 255,255,255 ) )
      
      ;ClipOutput( *this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\bar\page\len, *this\scroll\v\bar\page\len )
      
      DrawingMode( #PB_2DDrawing_AlphaBlend )
      ForEach Images( )
        DrawImage( ImageID( Images( )\img ), Images( )\x, Images( )\y ) ; draw all images with z-order
      Next
      
      DrawArea( *this )
      
      StopDrawing( )
    EndIf
  EndProcedure
  
  Procedure.i Canvas_AtPoint( List Images.IMAGES( ), x, y )
    Shared currentItemXOffset.i, currentItemYOffset.i
    Protected alpha.i, *current = #False
    Protected scroll_x ; = *this\scroll\h\bar\Page\Pos
    Protected scroll_y ;= *this\scroll\v\bar\Page\Pos
    
    If LastElement( Images( ) ) ; search for hit, starting from end ( z-order )
      Repeat
        If x >= Images( )\x - scroll_x And x < Images( )\x+ Images( )\width - scroll_x 
          If y >= Images( )\y - scroll_y And y < Images( )\y + Images( )\height - scroll_y
            alpha = 255
            
            If Images( )\alphatest And ImageDepth( Images( )\img )>31
              If StartDrawing( ImageOutput( Images( )\img ) )
                DrawingMode( #PB_2DDrawing_AlphaChannel )
                alpha = Alpha( Point( x-Images( )\x - scroll_x, y-Images( )\y - scroll_y ) ) ; get alpha
                StopDrawing( )
              EndIf
            EndIf
            
            If alpha
              MoveElement( Images( ), #PB_List_Last )
              *current = @Images( )
              currentItemXOffset = x - Images( )\x - scroll_x
              currentItemYOffset = y - Images( )\y - scroll_y
              Break
            EndIf
          EndIf
        EndIf
      Until PreviousElement( Images( ) ) = 0
    EndIf
    
    ProcedureReturn *current
  EndProcedure
  
  Procedure Canvas_AddImage ( List Images.IMAGES( ), x, y, img, alphatest=0 )
    If AddElement( Images( ) )
      Images( )\img    = img
      Images( )\x      = x
      Images( )\y      = y
      Images( )\width  = ImageWidth( img )
      Images( )\height = ImageHeight( img )
      Images( )\alphatest = alphatest
    EndIf
  EndProcedure
  
  Procedure Canvas_CallBack( )
    Static set_cursor 
    Protected cursor
    Protected Repaint
    Protected Event = EventType( )
    Protected Canvas = EventGadget( )
    Protected MouseX = GetGadgetAttribute( Canvas, #PB_Canvas_MouseX )
    Protected MouseY = GetGadgetAttribute( Canvas, #PB_Canvas_MouseY )
    ;   Protected Buttons = GetGadgetAttribute( EventGadget( ), #PB_Canvas_Buttons )
    ;   Protected WheelDelta = GetGadgetAttribute( EventGadget( ), #PB_Canvas_WheelDelta )
    
    widget::EventHandler( )
    
    Width = GadgetWidth( Canvas ) - x*2
    Height = GadgetHeight( Canvas ) - y*2
    
    Select Event
      Case #PB_EventType_LeftButtonUp : Drag = #False
        SetGadgetAttribute( MyCanvas, #PB_Canvas_Cursor, #PB_Cursor_Default )
        
      Case #PB_EventType_LeftButtonDown
        If Not _is_selected_( EventWidget( ) )
          Drag = Bool( Canvas_AtPoint( Images( ), Mousex, Mousey ) )
          If Drag 
            SetGadgetAttribute( MyCanvas, #PB_Canvas_Cursor, #PB_Cursor_Arrows )
            Repaint = #True 
          EndIf
        EndIf
        
      Case #PB_EventType_MouseMove
        If Drag = #True
          If LastElement( Images( ) )
            If Images( )\x <> Mousex - currentItemXOffset
              Images( )\x = Mousex - currentItemXOffset
              Repaint = #True
            EndIf
            
            If Images( )\y <> Mousey - currentItemYOffset
              Images( )\y = Mousey - currentItemYOffset
              Repaint = #True
            EndIf
            
            If Repaint
              
              Canvas_Change( *this, x, y, width, height )
              
            EndIf
          EndIf
          
        ElseIf Not _is_selected_( EventWidget( ) )
          If Bool( Canvas_AtPoint( Images( ), Mousex, Mousey ) ) 
            ;If widget::_from_point_( Mousex, Mousey, Images( ), [3] )
            cursor = #PB_Cursor_Hand
            ;EndIf
          Else 
            cursor = #PB_Cursor_Default
          EndIf
          
          If set_cursor <> cursor
            set_cursor = cursor
            SetGadgetAttribute( MyCanvas, #PB_Canvas_Cursor, cursor )
          EndIf
          
        EndIf
        
      Case #PB_EventType_Resize 
        ResizeGadget( Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore ) ; Bug ( 562 )
        
        widget::bar_Resizes( *this, x, y, width, height )
        
        Repaint = #True
    EndSelect
    
    If Repaint 
      Canvas_Draw( MyCanvas, Images( ) ) 
    EndIf
  EndProcedure
  
  ;-
  Procedure Scroll_Events( )
    
    Select WidgetEventType( )
      Case #PB_EventType_Change
        PostEvent( #PB_Event_Repaint, EventWindow( ), EventGadget( ), #PB_EventType_Repaint, EventWidget( )\bar\page\change )
    EndSelect
    
  EndProcedure
  
  
  
  Define yy = 90
  Define xx = 0
  Procedure ResizeCallBack()
    ResizeGadget(MyCanvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-10-100)
  EndProcedure
 
  If Not OpenWindow( 0, 0, 0, Width+x*2+20+xx, Height+y*2+20+yy, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered ) 
    MessageRequester( "Fatal error", "Program terminated." )
    End
  EndIf
  
  BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
 ;
  CheckBoxGadget(2, 10, 10, 80,20, "vertical") : SetGadgetState(2, 1)
  CheckBoxGadget(3, 10, 30, 80,20, "invert")
  CheckBoxGadget(4, 10, 50, 80,20, "noButtons")
 
  If CreateImage(0, 200, 80)
    
    StartDrawing(ImageOutput(0))
    
    FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
    
    Box(5, 10, 30, 2, RGB( 0,255,255 ))
    Box(5, 10+20, 30, 2, RGB( 255,0,255 ))
    Box(5, 10+40, 30, 2, RGB( 255,0,0 ))
    Box(5, 10+60, 30, 2, RGB( 255,255,0 ))
    
    DrawingMode(#PB_2DDrawing_Transparent)
    ;FrontColor(RGB(0,0,0)) ; print the text to white !
    DrawText(40, 5, "frame - (coordinate color)",0,0)
    DrawText(40, 25, "scroll - (coordinate color)",0,0)
    DrawText(40, 45, "max - (coordinate color)",0,0)
    DrawText(40, 65, "page - (coordinate color)",0,0)
    
    StopDrawing() ; This is absolutely needed when the drawing operations are finished !!! Never forget it !
    ImageGadget(#PB_Any, Width+x*2+20-210,10,200,80, ImageID(0) )
  EndIf
  
  MyCanvas = GetGadget( Open( 0, xx+10, yy+10, Width+x*2, Height+y*2, "", #PB_Canvas_Keyboard, @Canvas_CallBack( ) ) )
  
  Canvas_AddImage( Images( ), x-80, y-20, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp" ) )
  Canvas_AddImage( Images( ), x+100,y+100, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp" ) )
  Canvas_AddImage( Images( ), x+310,y+350, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp" ) )
  
  hole = CreateImage( #PB_Any,100,100,32 )
  If StartDrawing( ImageOutput( hole ) )
    DrawingMode( #PB_2DDrawing_AllChannels )
    Box( 0,0,100,100,RGBA( $00,$00,$00,$00 ) )
    Circle( 50,50,48,RGBA( $00,$FF,$FF,$FF ) )
    Circle( 50,50,30,RGBA( $00,$00,$00,$00 ) )
    StopDrawing( )
  EndIf
  Canvas_AddImage( Images( ),x+170,y+70,hole,1 )
  
  
  CreateArea( *this, x,y,width,height, 20, @Scroll_Events( ) )
  Canvas_Change( *this, x, y, width-x*2, height-y*2  )
  
  Define vButton = GetAttribute(*this\Scroll\v, #__bar_buttonsize)
  Define hButton = GetAttribute(*this\Scroll\h, #__bar_buttonsize)
 
  Repeat
    Event = WaitWindowEvent( )
    
    If event = #PB_Event_Repaint
      Select EventType( )
        Case #PB_EventType_Repaint
          PushListPosition(  Images( )  )
          If EventWidget( )\vertical
            ForEach Images( ) : Images( )\Y + EventData( ) : Next
          Else
            ForEach Images( ) : Images( )\X + EventData( ) : Next
          EndIf
          PopListPosition( Images( ) )
          
          Canvas_Draw( MyCanvas, Images( ) ) 
          
      EndSelect
    EndIf
    
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 2
            If GetGadgetState(2)
              SetGadgetState(3, GetAttribute(*this\scroll\v, #__Bar_Inverted))
            Else
              SetGadgetState(3, GetAttribute(*this\scroll\h, #__Bar_Inverted))
            EndIf
           
          Case 3
            If GetGadgetState(2)
              SetAttribute(*this\scroll\v, #__Bar_Inverted, Bool(GetGadgetState(3)))
              SetWindowTitle(0, Str(GetState(*this\scroll\v)))
            Else
              SetAttribute(*this\scroll\h, #__Bar_Inverted, Bool(GetGadgetState(3)))
              SetWindowTitle(0, Str(GetState(*this\scroll\h)))
            EndIf
            Canvas_Draw(MyCanvas, Images( ))
           
          Case 4
            If GetGadgetState(2)
              SetAttribute(*this\scroll\v, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * vButton)
              SetWindowTitle(0, Str(GetState(*this\scroll\v)))
            Else
              SetAttribute(*this\scroll\h, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * hButton)
              SetWindowTitle(0, Str(GetState(*this\scroll\h)))
            EndIf
            Canvas_Draw(MyCanvas, Images( ))
            
        EndSelect
    EndSelect
  
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --------
; EnableXP