XIncludeFile "../../widgets.pbi"

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
   Global x=200,y=150, Width=320, Height=320
   
   Global *this.allocate( widget )
   Global NewList Images.IMAGES( )
   Declare Canvas_Draw( canvas.i, List Images.IMAGES( ) )
   
   Macro Area_Draw( _this_, _objects_ )
      ;\\
      widget::bar_area_Change( *this, _objects_ )
      
      ;widget::bar_area_Draw( *this )
      
      If Not _this_\scroll\v\hide
         widget::Draw( _this_\scroll\v )
      EndIf
      If Not _this_\scroll\h\hide
         widget::Draw( _this_\scroll\h )
      EndIf
      
      ;\\
      UnclipOutput( )
      DrawingMode( #PB_2DDrawing_Outlined )
      
      Box(*this\frame_x( ), *this\frame_y( ), *this\frame_width( ), *this\frame_height( ), RGB( 0,0,255 ) )
      Box(*this\inner_x( ), *this\inner_y( ), *this\inner_width( ), *this\inner_height( ), RGB( 0,255,0 ) )
      Box( *this\scroll_x( ), *this\scroll_y( ), *this\scroll_width( ), *this\scroll_height( ), RGB( 255,0,0 ) )
      
   EndMacro
   
   Macro Area_Use( _canvas_window_, _callback_, _canvas_gadget_ = #PB_Any )
      Open( _canvas_window_, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, "", 0, 0, _canvas_gadget_ )
      BindGadgetEvent( GetGadget( Root( ) ), _callback_ )
   EndMacro
   
   Macro Area_Create( _parent_, _x_, _y_, _width_, _height_, _frame_size_, _scrollbar_size_, _flag_=#Null)
      _parent_\class = "Area"
      _parent_\fs = _frame_size_
      ;
      SetParent( _parent_, root( ) )
      ;
      OpenList( _parent_ )
      ;       _parent_\scroll\v = widget::scroll( _x_+_width_-_scrollbar_size_, _y_, _scrollbar_size_, 0, 0, 0, 0, #__bar_Vertical|#__flag_child|_flag_, 11 )
      ;       _parent_\scroll\h = widget::scroll( _x_, _y_+_height_-_scrollbar_size_, 0, _scrollbar_size_, 0, 0, 0, #__flag_child|_flag_, 11 )
      bar_area_create_( _parent_, 1, 0, 0, _width_, _height_, _scrollbar_size_ )
      CloseList( )
      ;
      Resize( _parent_, _x_, _y_, _width_, _height_ )
   EndMacro                                                  
   
   Macro Area_Bind( _parent_, _callback_ )
      If _callback_
         Bind( _parent_, _callback_, #__event_ScrollChange )
         Bind( _parent_, _callback_, #__event_Draw )
      EndIf
   EndMacro                                                  
   
   #Font = 0
   LoadFont(#Font, "Arial", 12)
   Procedure.i HSVA(Hue.i, Saturation.i, Value.i, Aplha.i=255) ; [0,360], [0,100], [0,255], [0,255]
      Protected H.i = Int(Hue/60)
      Protected f.f = (Hue/60-H)
      Protected p = Value * (1-Saturation/100.0)
      Protected q = Value * (1-Saturation/100.0*f)
      Protected t = Value * (1-Saturation/100.0*(1-f))
      Select H
         Case 1 : ProcedureReturn RGBA(q,Value,p, Aplha)
         Case 2 : ProcedureReturn RGBA(p,Value,t, Aplha)
         Case 3 : ProcedureReturn RGBA(p,q,Value, Aplha)  
         Case 4 : ProcedureReturn RGBA(t,p,Value, Aplha)
         Case 5 : ProcedureReturn RGBA(Value,p,q, Aplha)  
         Default : ProcedureReturn RGBA(Value,t,p, Aplha)
      EndSelect
   EndProcedure
   Procedure Button_DrawCallback(*Object._s_widget, Width.i, Height.i, DataValue.i)
      Protected Text.s = GetText(*Object)
      Protected Hue = DataValue
      
      Protected enter = Bool(*object\enter > 0)
      Protected press = Bool(*object\press > 0 And enter)
      
      If a_index( )
         enter = 0
         press = 0
      EndIf
      
      ; Box background
      AddPathBox(0.0, 0.0, Width, Height)
      VectorSourceLinearGradient(0.0, 0.0, 0.0, Height)
      If press And Not *object\disable
         VectorSourceGradientColor(HSVA(Hue, 10, $FF), 0.00)
         VectorSourceGradientColor(HSVA(Hue, 20, $F8), 0.45)
         VectorSourceGradientColor(HSVA(Hue, 30, $F0), 0.50)
         VectorSourceGradientColor(HSVA(Hue, 40, $E8), 1.00)
      ElseIf enter And Not *object\disable
         VectorSourceGradientColor(HSVA(Hue, 5, $FF), 0.00)
         VectorSourceGradientColor(HSVA(Hue, 10, $F8), 0.45)
         VectorSourceGradientColor(HSVA(Hue, 15, $F0), 0.50)
         VectorSourceGradientColor(HSVA(Hue, 20, $E8), 1.00)
      Else
         VectorSourceGradientColor(HSVA(0, 0, $F8), 0.00)
         VectorSourceGradientColor(HSVA(0, 0, $F0), 0.45)
         VectorSourceGradientColor(HSVA(0, 0, $E8), 0.50)
         VectorSourceGradientColor(HSVA(0, 0, $D8), 1.00)
      EndIf
      FillPath( )
      
      
      ; Box frame
      If *object\disable
         AddPathBox(0.5, 0.5, Width-1, Height-1)
         VectorSourceColor(HSVA(0, 0, $D0))
         StrokePath(1)
         AddPathBox(1.5, 1.5, Width-3, Height-3)
         VectorSourceColor(HSVA(0, 0, $F0))
         StrokePath(1)
      ElseIf press
         AddPathBox(0.5, 0.5, Width-1, Height-1)
         VectorSourceColor(HSVA(Hue, 100, $80))
         StrokePath(1)
         AddPathBox(1.5, 1.5, Width-3, Height-3)
         VectorSourceColor(HSVA(Hue, 50, $FF))
         StrokePath(1)
      ElseIf enter
         AddPathBox(0.5, 0.5, Width-1, Height-1)
         VectorSourceColor(HSVA(0, 0, $A0))
         StrokePath(1)
         AddPathBox(1.5, 1.5, Width-3, Height-3)
         VectorSourceColor(HSVA(Hue, 10, $FF))
         StrokePath(1)
      Else
         AddPathBox(0.5, 0.5, Width-1, Height-1)
         VectorSourceColor(HSVA(0, 0, $A0))
         StrokePath(1)
         AddPathBox(1.5, 1.5, Width-3, Height-3)
         VectorSourceColor(HSVA(0, 0, $FF))
         StrokePath(1)
      EndIf
      
      ; Text
      AddPathBox(0.0, 0.0, Width, Height)
      ClipPath( )
      VectorFont(FontID(#Font))
      If *object\disable
         VectorSourceColor($40000000)
      Else
         VectorSourceColor($FF000000)
      EndIf
      If Height - 6 > 0 And Width - 6 > 0
         If press
            MovePathCursor(3, (Height-VectorParagraphHeight(Text, Width-6, Height-6))/2)
         Else
            MovePathCursor(3, (Height-VectorParagraphHeight(Text, Width-6, Height-6))/2-1)
         EndIf
         DrawVectorParagraph(Text, Width-6, Height-6, #PB_VectorParagraph_Center)
      EndIf
      
   EndProcedure
   Procedure Area_Events( )
      Protected change
      
      Select WidgetEventType( )
         Case #__event_Draw
            StartVectorDrawing( CanvasVectorOutput( EventWidget( )\root\canvas\gadget ))
            TranslateCoordinates(EventWidget( )\x[#__c_frame], EventWidget( )\y[#__c_frame])
            Button_DrawCallback(EventWidget( ), EventWidget( )\width[#__c_frame], EventWidget( )\height[#__c_frame], EventWidget( )\data)
            StopVectorDrawing( )
            
         Case #__event_ScrollChange
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
   
   ;-
   Procedure Canvas_Draw( canvas.i, List Images.IMAGES( ) )
      Protected round
      
      ;\\
      DrawingStart( canvas ) 
      If Drawing( )
         DrawingMode( #PB_2DDrawing_Default )
         Box( 0, 0, OutputWidth( ), OutputHeight( ), RGB( 255,255,255 ) )
         
         ;\\
         If GetGadgetState(5)
            UnclipOutput()
            DrawingMode( #PB_2DDrawing_Outlined )
            ForEach Images( )
               round = Bool(Images( )\alphatest And ImageDepth( Images( )\img ) > 31) * 50
               RoundBox( Images( )\x, Images( )\y, Images( )\width, Images( )\height,round, round, RGB( 255,255,0 )) ; draw all images with z-order
            Next
            ClipOutput(*this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\bar\page\len, *this\scroll\v\bar\page\len )
            ;ClipOutput(*this\inner_x( ), *this\inner_y( ), *this\inner_width( ), *this\inner_height( ) )
         EndIf
         
         ;\\
         DrawingMode( #PB_2DDrawing_AlphaBlend )
         ForEach Images( )
            DrawImage( ImageID( Images( )\img ), Images( )\x, Images( )\y ) ; draw all images with z-order
         Next
         
         ;\\
         Area_Draw( *this, Images( ) )
         
         
         ;            StartVectorDrawing( CanvasVectorOutput( *this\root\canvas\gadget ))
         ;             TranslateCoordinates(*this\x[#__c_frame], *this\y[#__c_frame])
         ;             Button_DrawCallback(*this, *this\width[#__c_frame], *this\height[#__c_frame], *this\data)
         ;             StopVectorDrawing( )
         ;           
         DrawingStop( )
      EndIf
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
                     MoveElement( Images( ), #PB_List_Last )
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
   
   Procedure Canvas_AddImage( List Images.IMAGES( ), x, y, img, alphatest=0 )
      If AddElement( Images( ) )
         Images( )\img       = img
         Images( )\x         = x
         Images( )\y         = y
         Images( )\width     = ImageWidth( img )
         Images( )\height    = ImageHeight( img )
         Images( )\alphatest = alphatest
      EndIf
   EndProcedure
   
   Procedure Canvas_SetCursor( mouse_x, mouse_y, cur = #PB_Cursor_Default )
      Static set_cursor 
      Protected cursor
      
      If cur <> #PB_Cursor_Default
         cursor = cur
      Else
         If Not Mouse( )\buttons
            If Bool( Canvas_HitTest( Images( ), mouse_x, mouse_y ) ) 
               cursor = #PB_Cursor_Hand
            Else 
               cursor = #PB_Cursor_Default
            EndIf
         EndIf
      EndIf
      
      If set_cursor <> cursor
         set_cursor = cursor
         SetGadgetAttribute( MyCanvas, #PB_Canvas_Cursor, cursor )
      EndIf
   EndProcedure
   
   Procedure Canvas_Events( )
      Protected Repaint
      Protected Event = EventType( )
      Protected Canvas = EventGadget( )
      Protected MouseX ;= GetGadgetAttribute( Canvas, #PB_Canvas_MouseX )
      Protected MouseY ;= GetGadgetAttribute( Canvas, #PB_Canvas_MouseY )
      Width = GadgetWidth( Canvas ) - x*2
      Height = GadgetHeight( Canvas ) - y*2
      
      widget::EventHandler( #PB_Event_Gadget, Canvas, Event )
      
      MouseX = widget::Mouse( )\x
      MouseY = widget::Mouse( )\y
      ;     Width = widget::Root( )\width - x*2
      ;     Height = widget::Root( )\height - y*2
      
      Select Event
            ;          Case #PB_EventType_Repaint
            ;             Repaint = #True
            ;             
         Case #PB_EventType_LeftButtonUp : Drag = #False
            If Canvas_HitTest( Images( ), Mousex, Mousey )
               ChangeCursor( *this, #PB_Cursor_Cross )
            Else
               ChangeCursor( *this, #PB_Cursor_Default )
            EndIf
               
         Case #PB_EventType_LeftButtonDown
            If Canvas_HitTest( Images( ), Mousex, Mousey ) 
               ChangeCursor( *this, #PB_Cursor_Hand )
               Repaint = #True 
               Drag = #True
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
               EndIf
               
               ChangeCursor( *this, #PB_Cursor_Arrows )
            Else
               If Canvas_HitTest( Images( ), Mousex, Mousey )
                  ChangeCursor( *this, #PB_Cursor_Cross )
               Else
                  ChangeCursor( *this, #PB_Cursor_Default )
               EndIf
            EndIf
            
         Case #PB_EventType_Resize 
            ResizeGadget( Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore ) ; Bug ( 562 )
            Resize( *this, x, y, width, height )
            
            Repaint = #True
      EndSelect
      
      If Repaint
         Canvas_Draw( MyCanvas, Images( ) ) 
         ; PostRepaint( Root( ) )
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
   
   If Not OpenWindow( 0, 0, 0, Width+x*2+20+xx, Height+y*2+20+yy, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered ) 
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
      Box(5, 10, 30, 2, RGB( 0,0,255 ))
      Box(5, 10+25, 30, 2, RGB( 0,255,0 ))
      Box(5, 10+50, 30, 2, RGB( 255,0,0 ))
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(40, 5, "frame - (coordinate color)",0,0)
      DrawText(40, 30, "page - (coordinate color)",0,0)
      DrawText(40, 55, "max - (coordinate color)",0,0)
      
      StopDrawing() ; This is absolutely needed when the drawing operations are finished !!! Never forget it !
      
   EndIf
   ImageGadget(#PB_Any, Width+x*2+20-210,10,200,80, ImageID(0) )
   
   ;
   MyCanvas = CanvasGadget( #PB_Any, xx+10, yy+10, Width+x*2, Height+y*2, #PB_Canvas_Keyboard ) 
   Area_Use( 0, @Canvas_Events(), MyCanvas) 
   ; *this = Root( ) 
   ; MyCanvas = GetGadget( Root( ) )
   
   
   ; add new images
   Canvas_AddImage( Images( ), x-80, y-20, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp" ) )
   Canvas_AddImage( Images( ), x+100,y+100, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp" ) )
   Canvas_AddImage( Images( ), x+210,y+250, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp" ) )
   Canvas_AddImage( Images( ), x+180,y+180,hole,#True )
   
   Width = GadgetWidth( MyCanvas ) - x*2
   Height = GadgetHeight( MyCanvas ) - y*2
   
   ;
   Area_Create( *this, x,y,width,height, 2,20 )
   Area_Bind( *this, @Area_Events( ) ) 
   
   Define vButton = GetAttribute(*this\Scroll\v, #__bar_buttonsize)
   Define hButton = GetAttribute(*this\Scroll\h, #__bar_buttonsize)
   ;Debug *this\Scroll\v\width
   
   Repeat
      Event = WaitWindowEvent( )
      
      If event = #PB_Event_Repaint
         ;          Select EventType( )
         ;             Case #PB_EventType_Repaint
         If EventData( )
            Canvas_Draw( MyCanvas, Images( ) ) 
         EndIf
         
         ;          EndSelect
      EndIf
      
      Select Event
         Case #PB_Event_Gadget
            Select EventGadget()
               Case 2
                  If GetGadgetState(2)
                     SetGadgetText(2, "vertical bar")
                     SetGadgetState(3, GetAttribute(*this\scroll\v, #__bar_invert))
                  Else
                     SetGadgetText(2, "horizontal bar")
                     SetGadgetState(3, GetAttribute(*this\scroll\h, #__bar_invert))
                  EndIf
                  
               Case 3
                  If GetGadgetState(2)
                     SetAttribute(*this\scroll\v, #__bar_invert, Bool(GetGadgetState(3)))
                     SetWindowTitle(0, Str(GetState(*this\scroll\v)))
                  Else
                     SetAttribute(*this\scroll\h, #__bar_invert, Bool(GetGadgetState(3)))
                     SetWindowTitle(0, Str(GetState(*this\scroll\h)))
                  EndIf
                  ; Canvas_Draw(MyCanvas, Images( ))
                  PostRepaint( Root( ) )
                  
               Case 4
                  If GetGadgetState(2)
                     SetAttribute(*this\scroll\v, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * vButton)
                     SetWindowTitle(0, Str(GetState(*this\scroll\v)))
                  Else
                     SetAttribute(*this\scroll\h, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * hButton)
                     SetWindowTitle(0, Str(GetState(*this\scroll\h)))
                  EndIf
                  ; Canvas_Draw(MyCanvas, Images( ))
                  PostRepaint( Root( ) )
                  
               Case 5
                  ; Canvas_Draw(MyCanvas, Images( ))
                  PostRepaint( Root( ) )
                  
            EndSelect
      EndSelect
      
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 345
; FirstLine = 334
; Folding = ----------
; EnableXP