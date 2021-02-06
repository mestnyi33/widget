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
    Box( _this_\x[#__c_required], _this_\y[#__c_required], _this_\width[#__c_required], _this_\height[#__c_required], RGB( 255,0,255 ) )
    Box( _this_\x[#__c_required], _this_\y[#__c_required], _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, RGB( 255,0,0 ) )
    Box( _this_\scroll\h\x, _this_\scroll\v\y, _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, RGB( 255,255,0 ) )
  EndMacro
  
  Procedure.i HitTest ( List Images.IMAGES( ), x, y )
    Shared currentItemXOffset.i, currentItemYOffset.i
    Protected alpha.i, *current = #False
    Protected scroll_x ; = Root()\scroll\h\bar\Page\Pos
    Protected scroll_y ;= Root()\scroll\v\bar\Page\Pos
    
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
  
  Procedure AddImage ( List Images.IMAGES( ), x, y, img, alphatest=0 )
    If AddElement( Images( ) )
      Images( )\img    = img
      Images( )\x          = x
      Images( )\y          = y
      Images( )\width  = ImageWidth( img )
      Images( )\height = ImageHeight( img )
      Images( )\alphatest = alphatest
    EndIf
  EndProcedure
  
  AddImage( Images( ),  x-80, y-20, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp" ) )
  AddImage( Images( ), x+100,y+100, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp" ) )
  ;AddImage( Images( ),  x+221,y+200, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp" ) )
  ;AddImage( Images( ),  x+210,y+321, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp" ) )
  ;AddImage( Images( ),  x,y-1, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp" ) )
  AddImage( Images( ),  x+310,y+350, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp" ) )
  
  hole = CreateImage( #PB_Any,100,100,32 )
  If StartDrawing( ImageOutput( hole ) )
    DrawingMode( #PB_2DDrawing_AllChannels )
    Box( 0,0,100,100,RGBA( $00,$00,$00,$00 ) )
    Circle( 50,50,48,RGBA( $00,$FF,$FF,$FF ) )
    Circle( 50,50,30,RGBA( $00,$00,$00,$00 ) )
    StopDrawing( )
  EndIf
  AddImage( Images( ),x+170,y+70,hole,1 )
  
  
  Macro Canvas_Change( _this_, x, y, width, height )
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
    
    widget::bar_Updates( _this_, x, y, width, height )
    
    ; SetWindowTitle( EventWindow( ), Str( Images( )\x )+" "+Str( Images( )\width )+" "+Str( Images( )\x+Images( )\width ) )
  EndMacro
  
  Procedure Canvas_Draw( canvas.i, List Images.IMAGES( ) )
    If StartDrawing( CanvasOutput( canvas ) )
      DrawingMode( #PB_2DDrawing_Default )
      Box( 0, 0, OutputWidth( ), OutputHeight( ), RGB( 255,255,255 ) )
      
      ;ClipOutput( Root()\scroll\h\x, Root()\scroll\v\y, Root()\scroll\h\bar\page\len, Root()\scroll\v\bar\page\len )
      
      DrawingMode( #PB_2DDrawing_AlphaBlend )
      ForEach Images( )
        DrawImage( ImageID( Images( )\img ), Images( )\x, Images( )\y ) ; draw all images with z-order
      Next
      
      DrawArea( root( ) )
      
      StopDrawing( )
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
    
    Width = GadgetWidth( Canvas ) - x*2
    Height = GadgetHeight( Canvas ) - y*2
    
    Select Event
      Case #PB_EventType_LeftButtonUp : Drag = #False
        SetGadgetAttribute( MyCanvas, #PB_Canvas_Cursor, #PB_Cursor_Default )
        
      Case #PB_EventType_LeftButtonDown
        If Not ( EventWidget( ) And EventWidget( )\bar\index > 0 )
          Drag = Bool( HitTest( Images( ), Mousex, Mousey ) )
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
              Canvas_Change( root( ), x, y, width, height )
            EndIf
          EndIf
        Else
          If Bool( HitTest( Images( ), Mousex, Mousey ) ) 
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
        
        Canvas_Change( root( ), x, y, width, height )
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
        
        PushListPosition(  Images( )  )
        If EventWidget( )\vertical
          ForEach Images( ) : Images( )\Y + EventWidget( )\bar\page\change : Next
          Root()\y[#__c_required] =- EventWidget( )\bar\page\pos + EventWidget( )\y
          
        Else
          ForEach Images( ) : Images( )\X + EventWidget( )\bar\page\change : Next
          ; Root()\x[#__c_required] =- EventWidget( )\bar\page\pos + EventWidget( )\x
          
        EndIf
        PopListPosition( Images( ) )
        
        ;  Debug EventWidget( )\bar\page\change
        ; StopDrawing()
        ; Canvas_Draw( MyCanvas, Images( ) ) 
        
        PostEvent( #PB_Event_Repaint, EventWindow( ), EventGadget( ), #PB_EventType_Change, EventWidget( )\bar\page\change )
    EndSelect
    
  EndProcedure
  
  Macro CreateArea( _parent_, _x_, _y_, _width_, _height_, _size_, _callback_, _flag_=#Null)
    _parent_\scroll\v = widget::scroll( _x_+_width_-_size_, _y_, _size_, 0, 0, 0, 0, #__bar_Vertical|_flag_, 11 )
    _parent_\scroll\h = widget::scroll( _x_, _y_+_height_-_size_, 0,  _size_, 0, 0, 0, _flag_, 11 )
    
    If _callback_
      Bind( _parent_\scroll\v, _callback_ )
      Bind( _parent_\scroll\h, _callback_ )
    EndIf
  EndMacro                                                  
  
  
  If Not OpenWindow( 0, 0, 0, Width+x*2+20, Height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered ) 
    MessageRequester( "Fatal error", "Program terminated." )
    End
  EndIf
  
  MyCanvas = GetGadget( Open( 0, 10, 10, #PB_Ignore, #PB_Ignore, "", #PB_Canvas_Keyboard, @Canvas_CallBack( ) ) )
  
  CreateArea( Root(), x,y,width,height, 20, @Scroll_Events( ) )
  
  
  Repeat
    Event = WaitWindowEvent( )
    If event = #PB_Event_Repaint
      If EventData()
        Debug 888
        ; Canvas_Draw( MyCanvas, Images( ) ) 
      EndIf
    EndIf
    
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --0---
; EnableXP