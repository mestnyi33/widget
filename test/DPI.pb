CompilerIf #PB_Compiler_DPIAware 
  Macro PB(Function)
    Function
  EndMacro
  
  Macro ImageWidth( _image_  )
    DesktopUnscaledX(PB(ImageWidth)( _image_ ))
  EndMacro
  
  Macro ImageHeight( _image_  )
    DesktopUnscaledY(PB(ImageHeight)( _image_ ))
  EndMacro
  
  Macro CreateImage( _image_, _width_, _height_, _depth_= 24, _backcolor_= -1  )
    PB(CreateImage)( _image_, DesktopScaledX(_width_), DesktopScaledY(_height_), _depth_, _backcolor_ )
  EndMacro
  
  Macro DrawImage(_imageID_, _x_, _y_, _width_, _height_)
    PB(DrawImage)(_imageID_, DesktopScaledX(_x_), DesktopScaledX(_y_), DesktopScaledX(_width_), DesktopScaledY(_height_))
  EndMacro
  
  Macro DrawAlphaImage(_imageID_, _x_, _y_, _alpha_=255)
    PB(DrawAlphaImage)(_imageID_, DesktopScaledX(_x_), DesktopScaledX(_y_), _alpha_)
  EndMacro
  
  Macro DrawText(_x_, _y_, _text_, _frontcolor_= -1, _backcolor_= -1)
    PB(DrawText)(DesktopScaledX(_x_), DesktopScaledX(_y_), _text_, _frontcolor_, _backcolor_)
  EndMacro 
  
  Macro DrawRotatedText(_x_, _y_, _text_, _angle_, _color_= -1)
    PB(DrawRotatedText)(DesktopScaledX(_x_), DesktopScaledX(_y_), _text_, _angle_, _color_)
  EndMacro 
  
  Macro ClipOutput(_x_, _y_, _width_, _height_)
    PB(ClipOutput)(DesktopScaledX(_x_), DesktopScaledX(_y_), DesktopScaledX(_width_), DesktopScaledY(_height_))
  EndMacro
  
  Macro Circle( _x_, _y_, _radius_, _color_= -1)
    PB(Circle)( DesktopScaledX(_x_), DesktopScaledX(_y_), DesktopScaledX(_radius_), _color_ )
  EndMacro
  
  Macro CircularGradient( _x_, _y_, _radius_)
    PB(CircularGradient)( DesktopScaledX(_x_), DesktopScaledX(_y_), DesktopScaledX(_radius_) )
  EndMacro
  
  Macro ConicalGradient( _x_, _y_, _angle_)
    PB(ConicalGradient)( DesktopScaledX(_x_), DesktopScaledX(_y_), _angle_ )
  EndMacro
  
  Macro Line(_x_, _y_, _width_, _height_, _color_= -1)
    PB(Line)(DesktopScaledX(_x_), DesktopScaledX(_y_), DesktopScaledX(_width_), DesktopScaledY(_height_), _color_)
  EndMacro
  
  Macro LineXY(_x1_, _y1_, _x2_, _y2_, _color_= -1)
    PB(LineXY)(DesktopScaledX(_x1_), DesktopScaledX(_y1_), DesktopScaledX(_x2_), DesktopScaledY(_y2_), _color_)
  EndMacro
  
  Macro Box(_x_, _y_, _width_, _height_, _color_= -1)
    PB(Box)(DesktopScaledX(_x_), DesktopScaledX(_y_), DesktopScaledX(_width_), DesktopScaledY(_height_), _color_)
  EndMacro
  
  Macro BoxedGradient(_x_, _y_, _width_, _height_)
    PB(BoxedGradient)(DesktopScaledX(_x_), DesktopScaledX(_y_), DesktopScaledX(_width_), DesktopScaledY(_height_))
  EndMacro
  
  Macro RoundBox(_x_, _y_, _width_, _height_, _roundx_,roundy_, _color_= -1)
    PB(RoundBox)(DesktopScaledX(_x_), DesktopScaledX(_y_), DesktopScaledX(_width_), DesktopScaledY(_height_), DesktopScaledX(_roundx_), DesktopScaledY(roundy_), _color_)
  EndMacro
  
  Macro Ellipse(_x_, _y_, _radiusx_,radiusy_, _color_= -1)
    PB(Ellipse)(DesktopScaledX(_x_), DesktopScaledX(_y_), DesktopScaledX(_radiusx_), DesktopScaledY(radiusy_), _color_)
  EndMacro
  
  Macro EllipticalGradient(_x_, _y_, _radiusx_,radiusy_)
    PB(EllipticalGradient)(DesktopScaledX(_x_), DesktopScaledX(_y_), DesktopScaledX(_radiusx_), DesktopScaledY(radiusy_))
  EndMacro
  
  Macro FillArea(_x_, _y_, _outlinecolor_, _color_= -1)
    PB(FillArea)(DesktopScaledX(_x_), DesktopScaledX(_y_), _outlinecolor_, _color_)
  EndMacro 
  
  Macro OutputWidth( )
    DesktopUnscaledX(PB(OutputWidth)( ))
  EndMacro
  
  Macro OutputHeight( )
    DesktopUnscaledY(PB(OutputHeight)( ))
  EndMacro
  
  Macro GetOriginX( )
    DesktopUnscaledX(PB(GetOriginX)( ))
  EndMacro
  
  Macro GetOriginY( )
    DesktopUnscaledY(PB(GetOriginY)( ))
  EndMacro
  
  Macro SetOrigin(_x_, _y_)
    PB(SetOrigin)(DesktopScaledX(_x_), DesktopScaledX(_y_))
  EndMacro 
  
  Macro Plot(_x_, _y_, _color_= -1)
    PB(Plot)(DesktopScaledX(_x_), DesktopScaledX(_y_), _color_)
  EndMacro 
  
  Macro Point(_x_, _y_)
    PB(Point)(DesktopScaledX(_x_), DesktopScaledX(_y_))
  EndMacro 
CompilerEndIf 




If OpenWindow(0, 0, 0, 200, 200, "2DDrawing Example DPI", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    If CreateImage(0, 200, 200, 24, $FFFFFF) And StartDrawing(ImageOutput(0))
        
      ; Draw the same figure at different locations by moving the drawing origin
      For x = 0 To 120 Step 40
        For y = 0 To 120 Step 60
          
          SetOrigin(x, y)
          ; Debug ""+ x +" "+ GetOriginX() +" "+ y +" "+ GetOriginY()
          
          ; comment\uncomment to see
          ; color = Point(x, y) : Debug color
          
          Box(0, 0, 30, 30, $FF0000)
          Circle(15, 15, 10, $00FF00)
          
          Circle(15, 15, 5, color)
          
        Next y
      Next x   
         
      StopDrawing() 
      ImageGadget(0, 0, 0, 200, 200, ImageID(0))      
    EndIf
    
    Repeat
      Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; FirstLine = 114
; Folding = ------
; EnableXP
; DPIAware