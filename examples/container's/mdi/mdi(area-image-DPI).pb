XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   EnableExplicit
   Global Event.i, MyCanvas, *mdi._s_widget, vButton, hButton
   Global X=200,Y=150, Width=320, Height=320 , focus
   
   CompilerIf #PB_Compiler_DPIAware
     Procedure LoadImage__( _image_, _filename_.s, _flags_=-1 )
       Protected result = PB(LoadImage)( _image_, _filename_, _flags_ )
       If _image_ = #PB_Any 
         _image_ = result
       EndIf
       ResizeImage(_image_, DesktopScaledX(PB(ImageWidth)(_image_)), DesktopScaledY(PB(ImageHeight)(_image_)))
       ProcedureReturn result
     EndProcedure
     Macro LoadImage( _image_, _filename_, _flags_=-1 )
       LoadImage__( _image_, _filename_, _flags_ )
     EndMacro
     
     Macro CreateImage( _image_, _width_, _height_, _depth_=24, _backcolor_=-1  )
       PB(CreateImage)( _image_, DesktopScaledX(_width_), DesktopScaledY(_height_), _depth_, _backcolor_ )
     EndMacro
     
     Macro OutputWidth( )
       DesktopUnscaledX(PB(OutputWidth)( ))
     EndMacro
     
     Macro OutputHeight( )
       DesktopUnscaledY(PB(OutputHeight)( ))
     EndMacro
     
     Macro ImageWidth( _image_  )
       DesktopUnscaledX(PB(ImageWidth)( _image_ ))
     EndMacro
     
     Macro ImageHeight( _image_  )
       DesktopUnscaledY(PB(ImageHeight)( _image_ ))
     EndMacro
     
     Macro Circle( _x_, _y_, _radius_, _color_= -1)
       PB(Circle)( DesktopScaledX(_x_), DesktopScaledX(_y_), DesktopScaledX(_radius_), _color_ )
     EndMacro
     
     Macro Box(_x_, _y_, _width_, _height_, _color_= -1)
       PB(Box)(DesktopScaledX(_x_), DesktopScaledX(_y_), DesktopScaledX(_width_), DesktopScaledY(_height_), _color_)
     EndMacro
     
     Macro RoundBox(_x_, _y_, _width_, _height_, _roundx_,roundy_, _color_= -1)
       PB(RoundBox)(DesktopScaledX(_x_), DesktopScaledX(_y_), DesktopScaledX(_width_), DesktopScaledY(_height_), DesktopScaledX(_roundx_), DesktopScaledY(roundy_), _color_)
     EndMacro
     
     Macro DrawText(_x_, _y_, _text_, _frontcolor_= -1, _backcolor_= -1)
       PB(DrawText)(DesktopScaledX(_x_), DesktopScaledX(_y_), _text_, _frontcolor_, _backcolor_)
     EndMacro
   CompilerEndIf
;    
   
   ;-
   Procedure MDI_ImageEvents( )
      Protected *ew._s_widget = EventWidget( )
      Static DragWidget
      
      Select WidgetEvent( )
            ;       Case #__event_MouseEnter
            ;         SetCursor( *ew, #PB_Cursor_Hand )
            ;         
            ;       Case #__event_MouseLeave
            ;         SetCursor( *ew, #PB_Cursor_Default )
            
         Case #__event_LeftUp 
            DragWidget = #Null
            
         Case #__event_LeftDown
            DragWidget = *ew
            
         Case #__event_MouseMove
            If DragWidget = *ew
               Resize( *ew, MouseMoveX( ), MouseMoveY( ), #PB_Ignore, #PB_Ignore);, 0)
            EndIf
            
         Case #__Event_Draw
            Protected ex=DPIUnScaled(*ew\x), ey=DPIUnScaled(*ew\y), ew=DPIUnScaled(*ew\width), eh=DPIUnScaled(*ew\height)
            ; Demo draw line on the element
            UnclipOutput()
            DrawingMode(#PB_2DDrawing_Outlined)
            
            Protected draw_color 
            If *ew\width[#__c_draw] > 0 And
               *ew\height[#__c_draw] > 0
               draw_color = $ff00ff00
            Else
               draw_color = $ff00ffff
            EndIf
            
            If *ew\round
               RoundBox(ex,ey,ew,eh, DPIUnScaled(*ew\round), DPIUnScaled(*ew\round), draw_color)
            Else
               Box(ex,ey,ew,eh, draw_color)
            EndIf
            
            With *ew\parent\scroll
               Box( (X), (Y), (Width), (Height), RGB( 0,255,0 ) )
               Box( DPIUnScaled(\h\x), DPIUnScaled(\v\y), DPIUnScaled(\h\bar\page\len), DPIUnScaled(\v\bar\page\len), RGB( 0,0,255 ) )
               Box( DPIUnScaled(\h\x-\h\bar\page\pos), DPIUnScaled(\v\y - \v\bar\page\pos), DPIUnScaled(\h\bar\max), DPIUnScaled(\v\bar\max), RGB( 255,0,0 ) )
            EndWith
      EndSelect
      
   EndProcedure
   
   Procedure MDI_AddImage( *mdi, X, Y, img, round=0 )
      Protected *this._s_widget, Width, Height
      
      Width = ImageWidth( img )
      Height = ImageHeight( img )
      
      ;ResizeImage(img, DpiScaled(width), DPIScaled(height) )
      
      *this = AddItem( *mdi, -1, "", img, #__flag_BorderLess|#__flag_Transparent )
      *this\class = "image-"+Str(img)
      *this\cursor = #PB_Cursor_Hand
      *this\round = DPIScaled(round)
      
      Resize(*this, X, Y, Width, Height )
      
      Bind( *this, @MDI_ImageEvents(), #__event_LeftUp )
      Bind( *this, @MDI_ImageEvents(), #__event_LeftDown )
      Bind( *this, @MDI_ImageEvents(), #__event_MouseMove )
      Bind( *this, @MDI_ImageEvents(), #__event_MouseEnter )
      Bind( *this, @MDI_ImageEvents(), #__event_MouseLeave )
      Bind( *this, @MDI_ImageEvents(), #__Event_Draw )
      
      ProcedureReturn *this
   EndProcedure
   
   ;- \\
   Procedure Canvas_resize( )
      ;Protected width = GadgetWidth( EventGadget() )
      Protected Width = WindowWidth( EventWindow() )
      Resize( Root(), #PB_Ignore, #PB_Ignore, Width, #PB_Ignore )
      Resize( *mdi, #PB_Ignore, #PB_Ignore, Width-X*2, #PB_Ignore )
   EndProcedure
   
   Procedure Gadgets_Events()
      Select EventGadget()
         Case 2
            If GetGadgetState(2)
                  SetGadgetText(2, "vertical bar")
              SetGadgetState(3, GetAttribute(*mdi\scroll\v, #__flag_Invert))
            Else
                SetGadgetText(2, "horizontal bar")
                SetGadgetState(3, GetAttribute(*mdi\scroll\h, #__flag_Invert))
            EndIf
               Repaint( )
         
         Case 3
            If GetGadgetState(2)
               SetAttribute(*mdi\scroll\v, #__flag_Invert, Bool(GetGadgetState(3)))
               SetWindowTitle(0, Str(GetState(*mdi\scroll\v)))
            Else
               SetAttribute(*mdi\scroll\h, #__flag_Invert, Bool(GetGadgetState(3)))
               SetWindowTitle(0, Str(GetState(*mdi\scroll\h)))
            EndIf
              Repaint( )
         
         Case 4
            If GetGadgetState(2)
               SetAttribute(*mdi\scroll\v, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * vButton)
               SetWindowTitle(0, Str(GetState(*mdi\scroll\v)))
            Else
               SetAttribute(*mdi\scroll\h, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * hButton)
               SetWindowTitle(0, Str(GetState(*mdi\scroll\h)))
            EndIf
               Repaint( )
         
         Case 5
            
      EndSelect
   EndProcedure
   
   Define yy = 90
   Define xx = 0
   Define Text.s
   CompilerIf #PB_Compiler_DPIAware
     Text.s = " enable DPIAware"
   CompilerElse
     Text.s = " disable DPIAware"
   CompilerEndIf
   If Not OpenWindow( 0, 0, 0, Width+X*2+20+xx, Height+Y*2+20+yy, "Move/Drag Canvas Image"+Text, #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered ) 
      MessageRequester( "Fatal error", "Program terminated." )
      End
   EndIf
   
   ;BindEvent(#PB_Event_SizeWindow, @Window_Resize(), 0)
   ;
   CheckBoxGadget(5, 10, 10, 80,20, "clipoutput") : SetGadgetState(5, 1)
   CheckBoxGadget(2, 10, 30, 80,20, "vertical bar") : SetGadgetState(2, 1)
   CheckBoxGadget(3, 30, 50, 80,20, "invert")
   CheckBoxGadget(4, 30, 70, 80,20, "noButtons")
   
   If CreateImage(0, 200, 80)
      
      StartDrawing(ImageOutput(0))
      
      FillMemory(DrawingBuffer(), DrawingBufferPitch() * DesktopScaledY(OutputHeight()), $FF)
      
      DrawingMode(#PB_2DDrawing_Default)
      Box(5, 15, 30, 2, RGB( 0,255,0 ))
      Box(5, 15+25, 30, 2, RGB( 0,0,255 ))
      Box(5, 15+50, 30, 2, RGB( 255,0,0 ))
      
      DrawingFont( GetGadgetFont( #PB_Default ) )
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(40, 5, "frame - (coordinate color)",0,0)
      DrawText(40, 30, "page - (coordinate color)",0,0)
      DrawText(40, 55, "max - (coordinate color)",0,0)
      
      StopDrawing() ; This is absolutely needed when the drawing operations are finished !!! Never forget it !
      
   EndIf
   ImageGadget(#PB_Any, Width+X*2+20-210,10,200,80, ImageID(0) )
   
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
   MyCanvas = GetCanvasGadget(Open(0, xx+10, yy+10, Width+X*2, Height+Y*2 ) )
   SetColor(Root(), #PB_Gadget_BackColor, $ffffffff)
   
   ;BindGadgetEvent(MyCanvas, @Canvas_resize(), #PB_EventType_Resize )
   ;   ;BindEvent(#PB_Event_SizeWindow, @Canvas_resize());, GetCanvasWindow(Root()), MyCanvas, #PB_EventType_Resize )
   
   *mdi = MDI(X,Y,Width,Height);, #__flag_autosize)
                               ;a_init( *mdi )
   SetColor(*mdi, #PB_Gadget_BackColor, $ffffffff)
   ;SetColor(*mdi, #__FrameColor, $ffffffff)
   
   Define b=DPIScaled(19);20        
   *mdi\scroll\v\round = DPIScaled(11)
   *mdi\scroll\v\bar\button[1]\round = *mdi\scroll\v\round
   *mdi\scroll\v\bar\button[2]\round = *mdi\scroll\v\round
   *mdi\scroll\v\bar\button\round = *mdi\scroll\v\round
   SetAttribute(*mdi\scroll\v, #__bar_buttonsize, b)
   
   *mdi\scroll\h\round = DPIScaled(11)
   *mdi\scroll\h\bar\button[1]\round = *mdi\scroll\h\round
   *mdi\scroll\h\bar\button[2]\round = *mdi\scroll\h\round
   *mdi\scroll\h\bar\button\round = *mdi\scroll\h\round
   SetAttribute(*mdi\scroll\h, #__bar_buttonsize, b)
   
   ;Debug *mdi\Scroll\v\round
   vButton = GetAttribute(*mdi\Scroll\v, #__bar_buttonsize);+1
   hButton = GetAttribute(*mdi\Scroll\h, #__bar_buttonsize);+1
   
   MDI_AddImage( *mdi, -80, -20, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp" ) )
   MDI_AddImage( *mdi, 100, 120, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp" ) )
   MDI_AddImage( *mdi, 210, 250, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp" ) )
   
   MDI_AddImage( *mdi,50,150,hole, round )
   MDI_AddImage( *mdi,90,30,hole2, 100 )
   
   BindEvent( #PB_Event_Gadget, @Gadgets_Events() )
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 155
; FirstLine = 127
; Folding = ------
; EnableXP
; DPIAware