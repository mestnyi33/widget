﻿XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Structure IMAGES Extends _s_COORDINATE
      img.i
      alphatest.i
   EndStructure
   
   Global MyCanvas
   Global *current=#False
   Global currentItemXOffset.i, currentItemYOffset.i
   Global Event.i, drag.i, hole.i
   Global X=200,Y=150, Width=320, Height=320
   
   Global *this.allocate( widget )
   Global NewList Images.IMAGES( )
   Declare Canvas_Events( )
   Declare Canvas_Draw( Canvas.i, List Images.IMAGES( ) )
   
   Macro Area_Draw( _this_ )
      widget::bar_mdi_resize( _this_,
                              _this_\scroll\h\x, 
                              _this_\scroll\v\y, 
                              (_this_\scroll\v\x+_this_\scroll\v\width)-_this_\scroll\h\x,
                              (_this_\scroll\h\y+_this_\scroll\h\height)-_this_\scroll\v\y )
      
      If Not _this_\scroll\v\hide
         ; widget::Draw( _this_\scroll\v )
      EndIf
      If Not _this_\scroll\h\hide
         ; widget::Draw( _this_\scroll\h )
      EndIf
      
      UnclipOutput( )
      DrawingMode( #PB_2DDrawing_Outlined )
      Box( X, Y, Width, Height, RGB( 0,255,0 ) )
      Box( _this_\scroll\h\x, _this_\scroll\v\y, _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, RGB( 0,0,255 ) )
      
      ; Box( _this_\scroll_x( ), _this_\scroll_y( ), _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, RGB( 255,0,0 ) )
      Box( _this_\scroll\h\x -_this_\scroll\h\bar\page\pos, _this_\scroll\v\y - _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, RGB( 255,0,0 ) )
   EndMacro
   
   Macro Area_Use( _canvas_window_, _callback_, _canvas_gadget_ = #PB_Any )
      Open( _canvas_window_, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, "", 0, 0, _canvas_gadget_ )
      Bind( root( ), _callback_, #__event_Draw )
      Bind( root( ), _callback_ )
   EndMacro
   
   Macro Area_Create( _parent_, _x_, _y_, _width_, _height_, _frame_size_, _scrollbar_size_, _flag_=#Null)
      _parent_\root = root( ) 
      _parent_\class = "Area"
      _parent_\fs = _frame_size_
      
      _parent_\scroll\v = widget::Scroll( _x_+_width_-_scrollbar_size_, _y_, _scrollbar_size_, 0, 0, 0, 0, #__flag_Vertical|_flag_, 11 )
      _parent_\scroll\h = widget::Scroll( _x_, _y_+_height_-_scrollbar_size_, 0,  _scrollbar_size_, 0, 0, 0, _flag_, 11 )
   EndMacro                                                  
   
   Macro Area_Bind( _parent_, _callback_)
      If _callback_
         Bind( _parent_\scroll\v, _callback_, #__event_Change )
         Bind( _parent_\scroll\h, _callback_, #__event_Change )
      EndIf
   EndMacro                                                  
   
   Procedure Area_Events( )
      Protected change
      
      Select WidgetEvent( )
         Case #__event_Change
            change = WidgetEventData( )
            Debug "changing scroller values - " +change
            
            PushListPosition(  Images( )  )
            If EventWidget( )\bar\vertical
               ForEach Images( ) 
                  Images( )\Y + change 
               Next
            Else
               ForEach Images( ) 
                  Images( )\X + change 
               Next
            EndIf
            PopListPosition( Images( ) )
            
      EndSelect
      
   EndProcedure
   
   
   ;   Procedure bUpdate( )
   ;     Debug "  "+*this\scroll\h\x +" "+ *this\scroll\v\y +" "+ Str((*this\scroll\v\x+*this\scroll\v\width)-*this\scroll\h\x) +" "+ Str((*this\scroll\h\y+*this\scroll\h\height)-*this\scroll\v\y)
   ;     ;widget::bar_Updates( *this, *this\scroll\h\x, *this\scroll\v\y, (*this\scroll\v\x+*this\scroll\v\width)-*this\scroll\h\x, (*this\scroll\h\y+*this\scroll\h\height)-*this\scroll\v\y )
   ;   
   ;   EndProcedure
   ;   
   ;-
   Procedure Canvas_Draw( Canvas.i, List Images.IMAGES( ) )
      Protected round
      
      ;\\ Debug Images( )\x
      *this\scroll_x( ) = Images( )\x 
      *this\scroll_y( ) = Images( )\Y
      *this\scroll_width( ) = Images( )\x+Images( )\width - *this\scroll_x( )
      *this\scroll_height( ) = Images( )\Y+Images( )\height - *this\scroll_y( )
      PushListPosition( Images( ) )
      ForEach Images( )
         If *this\scroll_x( ) > Images( )\x : *this\scroll_x( ) = Images( )\x : EndIf
         If *this\scroll_y( ) > Images( )\y : *this\scroll_y( ) = Images( )\y : EndIf
      Next
      ForEach Images( )
         If *this\scroll_width( ) < Images( )\x+Images( )\width - *this\scroll_x( ) : *this\scroll_width( ) = Images( )\x+Images( )\width - *this\scroll_x( ) : EndIf
         If *this\scroll_height( ) < Images( )\Y+Images( )\height - *this\scroll_y( ) : *this\scroll_height( ) = Images( )\Y+Images( )\height - *this\scroll_y( ) : EndIf
      Next
      PopListPosition( Images( ) )
      
      
      ;\\
      DrawingMode( #PB_2DDrawing_Default )
      Box( 0, 0, OutputWidth( ), OutputHeight( ), RGB( 255,255,255 ) )
      
      ;\\
      Area_Draw( *this )
      
      ;\\
      If GetGadgetState(5)
         UnclipOutput()
         DrawingMode( #PB_2DDrawing_Outlined )
         ForEach Images( )
            round = Bool(Images( )\alphatest And ImageDepth( Images( )\img ) > 31) * 50
            RoundBox( Images( )\x, Images( )\y, Images( )\width, Images( )\height,round, round, RGB( 255,255,0 )) ; draw all images with z-order
         Next
         ClipOutput(*this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\bar\page\len, *this\scroll\v\bar\page\len )
      EndIf
      
      ;\\
      DrawingMode( #PB_2DDrawing_AlphaBlend )
      ForEach Images( )
         DrawImage( ImageID( Images( )\img ), Images( )\x, Images( )\y ) ; draw all images with z-order
      Next
   EndProcedure
   
   Procedure.i Canvas_HitTest( List Images.IMAGES( ), mouse_x, mouse_y )
      Shared currentItemXOffset.i, currentItemYOffset.i
      Protected alpha.i, *current = #False
      Protected scroll_x ; = *this\scroll\h\bar\Page\Pos
      Protected scroll_y ;= *this\scroll\v\bar\Page\Pos
      
      If LastElement( Images( ) ) And 
         Not is_atpoint_( *this\scroll\v, mouse_x, mouse_y ) And
         Not is_atpoint_( *this\scroll\h, mouse_x, mouse_y ) ; And AtBox( *this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\bar\page\len,*this\scroll\v\bar\page\len, mouse_x, mouse_y )
                                                             ; search for hit, starting from end ( z-order )
         Repeat
            If mouse_x >= Images( )\x - scroll_x And mouse_x < Images( )\x+ Images( )\width - scroll_x 
               If mouse_y >= Images( )\y - scroll_y And mouse_y < Images( )\y + Images( )\height - scroll_y
                  alpha = 255
                  
                  If Images( )\alphatest And ImageDepth( Images( )\img ) > 31
                     If StartDrawing( ImageOutput( Images( )\img ) )
                        DrawingMode( #PB_2DDrawing_AlphaChannel )
                        alpha = Alpha( Point( mouse_x - Images( )\x - scroll_x, mouse_y - Images( )\y - scroll_y ) ) ; get alpha
                        StopDrawing( )
                     EndIf
                  EndIf
                  
                  If alpha 
                     If MouseButtonPress( )
                        MoveElement( Images( ), #PB_List_Last )
                     EndIf
                     *current = @Images( )
                     currentItemXOffset = mouse_x - Images( )\x - scroll_x
                     currentItemYOffset = mouse_y - Images( )\y - scroll_y
                     Break
                  EndIf
               EndIf
            EndIf
         Until PreviousElement( Images( ) ) = 0
      EndIf
      
      ProcedureReturn *current
   EndProcedure
   
   Procedure Canvas_AddImage( List Images.IMAGES( ), X, Y, img, alphatest=0 )
      If AddElement( Images( ) )
         Images( )\img       = img
         Images( )\x         = X
         Images( )\y         = Y
         Images( )\width     = ImageWidth( img )
         Images( )\height    = ImageHeight( img )
         Images( )\alphatest = alphatest
      EndIf
   EndProcedure
   
   Procedure Canvas_Events( )
      Protected Repaint
      Protected Event = WidgetEventType( ) ; EventType( )
      Protected Canvas = GetCanvasGadget(root())      ; EventGadget( )
      
      Protected MouseX = widget::mouse( )\x
      Protected MouseY = widget::mouse( )\y
      
      Width = widget::root( )\width - X*2
      Height = widget::root( )\height - Y*2
      
      Select Event
         Case #PB_EventType_Repaint
           Canvas_Draw( MyCanvas, Images( ))
         
         Case #PB_EventType_LeftButtonUp 
            If Drag
               ChangeCursor( root( ), #PB_Cursor_Hand )
               Drag = #False
            EndIf
            
         Case #PB_EventType_LeftButtonDown
            Drag = Bool( Canvas_HitTest( Images( ), Mousex, Mousey ) )
            If Drag 
               ChangeCursor( root( ), #PB_Cursor_Arrows )
              ; Repaint = #True 
            EndIf
            
         Case #PB_EventType_MouseMove
            If Drag = #True
               If LastElement( Images( ) )
                  If Images( )\x <> Mousex - currentItemXOffset
                     Images( )\x = Mousex - currentItemXOffset
                     ; Repaint = #True
                  EndIf
                  
                  If Images( )\y <> Mousey - currentItemYOffset
                     Images( )\y = Mousey - currentItemYOffset
                     ; Repaint = #True
                  EndIf
               EndIf
            Else 
               If Not MouseButtonPress( )
                  If Bool( Canvas_HitTest( Images( ), Mousex, Mousey ) )
                     If ChangeCursor( root( ), #PB_Cursor_Hand )
                        Repaint = 1
                     EndIf
                  Else
                     If ChangeCursor( root( ), #PB_Cursor_Default )
                        Repaint = 1
                     EndIf
                  EndIf
               EndIf
            EndIf
            
         Case #PB_EventType_Resize 
            ResizeGadget( Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore ) ; Bug ( 562 )
            Resize( *this, X, Y, X+Width, Y+Height )
            
            ; Repaint = #True
      EndSelect
      
            If Repaint
;                ReDraw( root( ))
;                ; If StartDraw( root( ) )
;                ;    Drawing( )
;                ;    Canvas_Draw( MyCanvas, Images( ) ) 
;                ;    StopDraw( )
;                ; EndIf
            EndIf
   EndProcedure
   
   ;-
   
   Define yy = 90
   Define xx = 0
   
   Procedure Window_Resize()
      ResizeGadget(MyCanvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-10-100)
   EndProcedure
   
   hole = CreateImage( #PB_Any,100,100,32 )
   If StartDrawing( ImageOutput( hole ) )
      DrawingMode( #PB_2DDrawing_AllChannels )
      Box( 0,0,OutputWidth(),OutputHeight(),RGBA( $00,$00,$00,$00 ) )
      Circle( 50,50,48,RGBA( $00,$FF,$FF,$FF ) )
      Circle( 50,50,30,RGBA( $00,$00,$00,$00 ) )
      StopDrawing( )
   EndIf
   
   If Not OpenWindow( 0, 0, 0, Width+X*2+20+xx, Height+Y*2+20+yy, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered ) 
      MessageRequester( "Fatal error", "Program terminated." )
      End
   EndIf
   
   BindEvent(#PB_Event_SizeWindow, @Window_Resize(), 0)
   ;
   CheckBoxGadget(5, 10, 10, 80,20, "clipoutput") : SetGadgetState(5, 1)
   CheckBoxGadget(2, 10, 30, 100,20, "vertical bar") : SetGadgetState(2, 1)
   CheckBoxGadget(3, 30, 50, 80,20, "invert")
   CheckBoxGadget(4, 30, 70, 80,20, "noButtons")
   
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
   ImageGadget(#PB_Any, Width+X*2+20-210,10,200,80, ImageID(0) )
   
   ;
   MyCanvas = CanvasGadget( #PB_Any, xx+10, yy+10, Width+X*2, Height+Y*2, #PB_Canvas_Keyboard ) 
   Area_Use( 0, @Canvas_Events( ), MyCanvas) 
   
   ; add new images
   Canvas_AddImage( Images( ), X-80, Y-20, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp" ) )
   Canvas_AddImage( Images( ), X+100,Y+100, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp" ) )
   Canvas_AddImage( Images( ), X+210,Y+250, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp" ) )
   Canvas_AddImage( Images( ), X+180,Y+180,hole,#True )
   
   Width = GadgetWidth( MyCanvas ) - X*2
   Height = GadgetHeight( MyCanvas ) - Y*2
   
   ;
   Area_Create( *this, X,Y,Width,Height, 2,20 )
   Area_Bind( *this, @Area_Events( ) ) 
   
   Define vButton = GetAttribute(*this\Scroll\v, #__bar_buttonsize)
   Define hButton = GetAttribute(*this\Scroll\h, #__bar_buttonsize)
   ;Debug *this\Scroll\v\width
   Debug *this\root
   
   Repeat
      Event = WaitWindowEvent( )
      
      If event = #PB_Event_Repaint
         ;          Select EventType( )
         ;             Case #PB_EventType_Repaint
         ;                Canvas_Draw( MyCanvas, Images( ) ) 
         ;                
         ;          EndSelect
         
         If EventData( )
            ; Canvas_Draw( MyCanvas, Images( ) ) 
         EndIf
         
         
      EndIf
      
      Select Event
         Case #PB_Event_Gadget
            Select EventGadget()
               Case 2
                  If GetGadgetState(2)
                     SetGadgetText(2, "vertical bar")
                     SetGadgetState(3, GetAttribute(*this\scroll\v, #__flag_Invert))
                  Else
                     SetGadgetText(2, "horizontal bar")
                     SetGadgetState(3, GetAttribute(*this\scroll\h, #__flag_Invert))
                  EndIf
                  
               Case 3
                  If GetGadgetState(2)
                     SetAttribute(*this\scroll\v, #__flag_Invert, Bool(GetGadgetState(3)))
                     SetWindowTitle(0, Str(GetState(*this\scroll\v)))
                  Else
                     SetAttribute(*this\scroll\h, #__flag_Invert, Bool(GetGadgetState(3)))
                     SetWindowTitle(0, Str(GetState(*this\scroll\h)))
                  EndIf
                  ReDraw( root( ))
                  
               Case 4
                  If GetGadgetState(2)
                     SetAttribute(*this\scroll\v, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * vButton)
                     SetWindowTitle(0, Str(GetState(*this\scroll\v)))
                  Else
                     SetAttribute(*this\scroll\h, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * hButton)
                     SetWindowTitle(0, Str(GetState(*this\scroll\h)))
                  EndIf
                  ReDraw( root( ))
                  
               Case 5
                  ReDraw( root( ))
                  
            EndSelect
      EndSelect
      
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 48
; FirstLine = 45
; Folding = ---------
; EnableXP