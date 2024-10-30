CompilerIf #PB_Compiler_DPIAware And #PB_Compiler_OS = #PB_OS_Windows
  Macro PB(Function)
    Function
  EndMacro
  
  Global DPISCALEDX.d = (GetDeviceCaps_(GetDC_(0),#LOGPIXELSX)/96)
  Global DPISCALEDY.d = (GetDeviceCaps_(GetDC_(0),#LOGPIXELSY)/96)
  
  Macro DPIResolutionX( )
    DPISCALEDX;(GetDeviceCaps_(GetDC_(0),#LOGPIXELSX)/96)
  EndMacro
  Macro DPIResolutionY( )
    DPISCALEDY;(GetDeviceCaps_(GetDC_(0),#LOGPIXELSY)/96)
  EndMacro
  Macro DPIScaledX( _x_ )
    ((_x_) * DPIResolutionX( )) ; DesktopScaledX(_x_) ; 
  EndMacro
  Macro DPIScaledY( _y_ )
    ((_y_) * DPIResolutionY( )) ; DesktopScaledY(_y_) ; 
  EndMacro
  Macro DPIUnscaledX( _x_ )
    ((_x_)/DPIResolutionX( )) ; DesktopUnscaledX(_x_) ; 
  EndMacro
  Macro DPIUnscaledY( _y_ )
    ((_y_)/DPIResolutionY( )) ; DesktopUnscaledY(_y_) ; 
  EndMacro
  
  Macro _dq_
    "
  EndMacro
  
  Macro ImageWidth( _image_  )
    DPIUnscaledX(PB(ImageWidth)( _image_ ))
  EndMacro
  
  Macro ImageHeight( _image_  )
    DPIUnscaledY(PB(ImageHeight)( _image_ ))
  EndMacro
  
  Macro CreateImage( _image_, _width_, _height_, _depth_= 24, _backcolor_= #PB_Image_Transparent   )
    PB(CreateImage)( _image_, DPIScaledX(_width_), DPIScaledY(_height_), _depth_, _backcolor_ )
  EndMacro
  
  Macro DrawImage(_imageID_, _x_, _y_, _width_= #PB_Ignore, _height_= #PB_Ignore)
    CompilerIf _dq_#_width_#_dq_ = "" And _dq_#_height_#_dq_ = ""
      PB(DrawImage)(_imageID_, DPIScaledX(_x_), DPIScaledY(_y_))
    CompilerElseIf  _dq_#_height_#_dq_ = ""
      PB(DrawImage)(_imageID_, DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_width_))
    CompilerElse 
      PB(DrawImage)(_imageID_, DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_width_), DPIScaledY(_height_))
    CompilerEndIf
  EndMacro
  
  Macro DrawAlphaImage(_imageID_, _x_, _y_, _alpha_ = 255)
    PB(DrawAlphaImage)(_imageID_, DPIScaledX(_x_), DPIScaledY(_y_), _alpha_)
  EndMacro
  
  Macro TextWidth( _Text_  )
    DPIUnscaledX(PB(TextWidth)( _Text_ ))
  EndMacro
  
  Macro TextHeight( _Text_  )
    DPIUnscaledY(PB(TextHeight)( _Text_ ))
  EndMacro
  
  Macro DrawText(_x_, _y_, _text_, _frontcolor_= , _backcolor_= )
    CompilerIf _dq_#_frontcolor_#_dq_ = "" And _dq_#_backcolor_#_dq_ = ""
      PB(DrawText)(DPIScaledX(_x_), DPIScaledY(_y_), _text_)
    CompilerElseIf _dq_#_backcolor_#_dq_ = ""
      PB(DrawText)(DPIScaledX(_x_), DPIScaledY(_y_), _text_, _frontcolor_)
    CompilerElse
      PB(DrawText)(DPIScaledX(_x_), DPIScaledY(_y_), _text_, _frontcolor_, _backcolor_)
    CompilerEndIf
  EndMacro 
  
  Macro DrawRotatedText(_x_, _y_, _text_, _angle_, _color_= )
    CompilerIf _dq_#_color_#_dq_ = "" 
      PB(DrawRotatedText)(DPIScaledX(_x_), DPIScaledY(_y_), _text_, _angle_)
    CompilerElse
      PB(DrawRotatedText)(DPIScaledX(_x_), DPIScaledY(_y_), _text_, _angle_, _color_)
    CompilerEndIf
  EndMacro 
  
  Macro ClipOutput(_x_, _y_, _width_, _height_)
    PB(ClipOutput)(DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_width_), DPIScaledY(_height_))
  EndMacro
  
  Macro Circle( _x_, _y_, _radius_, _color_= )
    CompilerIf _dq_#_color_#_dq_ = "" 
      PB(Circle)( DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_radius_) )
    CompilerElse
      PB(Circle)( DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_radius_), _color_ )
    CompilerEndIf
  EndMacro
  
  Macro CircularGradient( _x_, _y_, _radius_)
    PB(CircularGradient)( DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_radius_) )
  EndMacro
  
  Macro ConicalGradient( _x_, _y_, _angle_)
    PB(ConicalGradient)( DPIScaledX(_x_), DPIScaledY(_y_), _angle_ )
  EndMacro
  
  Macro Line(_x_, _y_, _width_, _height_, _color_= )
    CompilerIf _dq_#_color_#_dq_ = "" 
      PB(Line)(DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_width_), DPIScaledY(_height_))
    CompilerElse
      PB(Line)(DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_width_), DPIScaledY(_height_), _color_)
    CompilerEndIf
  EndMacro
  
  Macro LineXY(_x1_, _y1_, _x2_, _y2_, _color_= )
    CompilerIf _dq_#_color_#_dq_ = "" 
      PB(LineXY)(DPIScaledX(_x1_), DPIScaledY(_y1_), DPIScaledX(_x2_), DPIScaledY(_y2_))
    CompilerElse
      PB(LineXY)(DPIScaledX(_x1_), DPIScaledY(_y1_), DPIScaledX(_x2_), DPIScaledY(_y2_), _color_)
    CompilerEndIf
  EndMacro
  
  Macro LinearGradient(_x1_, _y1_, _x2_, _y2_)
    PB(LinearGradient)(DPIScaledX(_x1_), DPIScaledY(_y1_), DPIScaledX(_x2_), DPIScaledY(_y2_))
  EndMacro
  
  Macro Box(_x_, _y_, _width_, _height_, _color_= )
    ;   Line(_x_, _y_, _width_, _height_, _color_ )
    CompilerIf _dq_#_color_#_dq_ = "" 
      PB(Box)(DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_width_), DPIScaledY(_height_))
    CompilerElse
      PB(Box)(DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_width_), DPIScaledY(_height_), _color_)
    CompilerEndIf
  EndMacro
  
  Macro BoxedGradient(_x_, _y_, _width_, _height_)
    PB(BoxedGradient)(DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_width_), DPIScaledY(_height_))
  EndMacro
  
  Macro RoundBox(_x_, _y_, _width_, _height_, _roundx_,roundy_, _color_= )
    CompilerIf _dq_#_color_#_dq_ = "" 
      PB(RoundBox)(DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_width_), DPIScaledY(_height_), DPIScaledX(_roundx_), DPIScaledY(roundy_))
    CompilerElse
      PB(RoundBox)(DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_width_), DPIScaledY(_height_), DPIScaledX(_roundx_), DPIScaledY(roundy_), _color_)
    CompilerEndIf
  EndMacro
  
  Macro Ellipse(_x_, _y_, _radiusx_,radiusy_, _color_= )
    CompilerIf _dq_#_color_#_dq_ = "" 
      PB(Ellipse)(DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_radiusx_), DPIScaledY(radiusy_))
    CompilerElse
      PB(Ellipse)(DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_radiusx_), DPIScaledY(radiusy_), _color_)
    CompilerEndIf
  EndMacro
  
  Macro EllipticalGradient(_x_, _y_, _radiusx_, radiusy_)
    PB(EllipticalGradient)(DPIScaledX(_x_), DPIScaledY(_y_), DPIScaledX(_radiusx_), DPIScaledY(radiusy_))
  EndMacro
  
  Macro FillArea(_x_, _y_, _outlinecolor_, _color_= )
    CompilerIf _dq_#_color_#_dq_ = "" 
      PB(FillArea)(DPIScaledX(_x_), DPIScaledY(_y_), _outlinecolor_)
    CompilerElse
      PB(FillArea)(DPIScaledX(_x_), DPIScaledY(_y_), _outlinecolor_, _color_)
    CompilerEndIf
  EndMacro 
  
  Macro OutputWidth( )
    DPIUnscaledX(PB(OutputWidth)( ))
  EndMacro
  
  Macro OutputHeight( )
    DPIUnscaledY(PB(OutputHeight)( ))
  EndMacro
  
  Macro GetOriginX( )
    DPIUnscaledX(PB(GetOriginX)( ))
  EndMacro
  
  Macro GetOriginY( )
    DPIUnscaledY(PB(GetOriginY)( ))
  EndMacro
  
  Macro SetOrigin(_x_, _y_)
    PB(SetOrigin)(DPIScaledX(_x_), DPIScaledY(_y_))
  EndMacro 
  
  Macro Plot(_x_, _y_, _color_= )
    Box(_x_, _y_, 1,1, _color_)
    ; Line(_x_, _y_, 1,1, _color_)
    
    ;        CompilerIf _dq_#_color_#_dq_ = "" 
    ;          PB(Plot)(DPIScaledX(_x_), DPIScaledY(_y_))
    ;        CompilerElse
    ;          PB(Plot)(DPIScaledX(_x_), DPIScaledY(_y_), _color_)
    ;        CompilerEndIf
  EndMacro 
  
  Macro Point(_x_, _y_)
    PB(Point)(DPIScaledX(_x_), DPIScaledY(_y_))
  EndMacro 
CompilerEndIf 
; 0,0,0,0,0,0,0,0,0,0,0,0,0
; 0,1,0,0,0,0,0,0,0,0,0,1,0
; 0,1,1,0,0,0,0,0,0,0,1,1,0
; 0,1,1,1,0,0,0,0,0,1,1,1,0
; 0,1,1,1,1,0,0,0,1,1,1,1,0
; 0,1,1,1,1,1,0,1,1,1,1,1,0
; 0,1,1,1,1,1,1,1,1,1,1,1,0
; 0,1,1,1,1,1,1,1,1,1,1,1,0
; 0,1,1,1,1,1,1,1,1,1,1,1,0
; 0,0,1,1,1,1,1,1,1,1,1,0,0
; 0,0,0,1,1,1,1,1,1,1,0,0,0
; 0,0,0,0,1,1,1,1,1,0,0,0,0
; 0,0,0,0,0,1,1,1,0,0,0,0,0
; 0,0,0,0,0,0,1,0,0,0,0,0,0
; 0,0,0,0,0,0,0,0,0,0,0,0,0


; 0,0,0,0,0,0,0
; 0,1,0,0,0,1,0
; 0,1,1,0,1,1,0
; 0,1,1,1,1,1,0
; 0,1,1,1,1,1,0
; 0,0,1,1,1,0,0
; 0,0,0,1,0,0,0

Procedure.b Draw_ArrowFrame(  x.l, y.l, size.a, direction.a, mode.b = 1, color = $ffffffff  )
  Protected i.w, j.w, thickness.a
  size / 2
  x + size
  y + size
  
  thickness.a = 2
  
  If direction = 0 ; left
    Box( x + thickness, y - size,  - thickness, size * 2, Color )
  EndIf
  If direction = 2 ; right
    Box( x, y - size, thickness, size * 2, Color )
  EndIf
  If direction = 1 ; up
    Box( x - size, y + thickness, size * 2,  - thickness, Color )
  EndIf
  If direction = 3 ; down
    Box( x - size, y, size * 2, thickness, Color )
  EndIf
  
  thickness + 1
  
  For i = - size To size
    If direction = 0 ; left
      If i > 0
        Box( x + i - size + thickness - 1, y + i * 1,  - thickness, 1, Color )
      Else
        Box( x - i - size + thickness - 1, y + i * 1,  - thickness, 1, Color )
      EndIf
    EndIf
    If direction = 2 ; right
      If i < 0
        Box( x + i + size, y + i * 1, thickness, 1, Color )
      Else
        Box( x - i + size, y + i * 1, thickness, 1, Color )
      EndIf
    EndIf
    
    If direction = 1 ; up
      If i > 0
        Box( x + i * 1, y + i - size + thickness - 1, 1,  - thickness, Color )
      Else
        Box( x + i * 1, y - i - size + thickness - 1, 1,  - thickness, Color )
      EndIf
    EndIf
    
    If direction = 3 ; down
      If i < 0
        Box( x + i * 1, y + i + size, 1, thickness, Color )
      Else
        Box( x + i * 1, y - i + size, 1, thickness, Color )
      EndIf
    EndIf
  Next
EndProcedure

Procedure.b Draw_Arrow(  x.l, y.l, size.a, direction.a, mode.b = 1, Color = $ff000000  )
  Protected i.w, j.w, thickness.a
  
  If mode
    If mode = - 1
      size / 2
      x + size
      y + size
      
      thickness.a = size / 2 + 2
      
      For i = - size To size
        If direction = 0 ; left
          If i > 0
            Box( x + i, y + i * 1,  - thickness, 1, Color )
          Else
            Box( x - i, y + i * 1,  - thickness, 1, Color )
          EndIf
        EndIf
        If direction = 2 ; right
          If i < 0
            Box( x + i, y + i * 1, thickness, 1, Color )
          Else
            Box( x - i, y + i * 1, thickness, 1, Color )
          EndIf
        EndIf
        
        If direction = 1 ; up
          If i > 0
            Box( x + i * 1, y + i, 1,  - thickness, Color )
          Else
            Box( x + i * 1, y - i, 1,  - thickness, Color )
          EndIf
        EndIf
        
        If direction = 3 ; down
          If i < 0
            Box( x + i * 1, y + i, 1, thickness, Color )
          Else
            Box( x + i * 1, y - i, 1, thickness, Color )
          EndIf
        EndIf
      Next
      
    Else
      
      For i = 0 To size
        For j = i To size - i 
          If direction = 0 ; left
            Box( x + size / 2 - i * mode, y + j, mode, 1, Color )
          EndIf
          If direction = 1 ; up
            Box( x + j, y + size / 2 - i * mode, 1, mode, Color )
          EndIf
          If direction = 2 ; right
            Box( x + size / 2 + i * mode, y + j, mode, 1, Color )
          EndIf
          If direction = 3 ; down
            Box( x + j, y + size / 2 + i * mode, 1, mode, Color )
          EndIf
        Next  
      Next
      
    EndIf
  EndIf
EndProcedure


Procedure.b Arrow( direction.a, x.l, y.l, size.a, mode.b = 1, Color = $ff000000, framesize=2 )
  Protected i.w, j.w, thickness.a
  
  If mode
    x + size/2
    y + size/2
    
    If mode = 2
      x + size/2 + framesize
      y + size/2 + framesize
    EndIf
    
    If mode = 3
      x + size + framesize * 2
      y + size + framesize * 2
    EndIf
    
    
    If mode = - 1
      thickness.a = 2 + size/4
      
      x - thickness + 1
      y - thickness + 1 
      
      If framesize
        x + framesize*2
        y + framesize*2
        
        Color = $ffffff
        For i = - (size+framesize)/2 To (size+framesize)/2
          If direction = 0 ; left
            If i > 0
              Box( x + i + framesize, y + i * 1, - (thickness+framesize*2), 1, Color )
            Else
              Box( x - i + framesize, y + i * 1, - (thickness+framesize*2), 1, Color )
            EndIf
          EndIf
          If direction = 2 ; right
            If i < 0
              Box( x + i - framesize, y + i * 1, (thickness+framesize*2), 1, Color )
            Else
              Box( x - i - framesize, y + i * 1, (thickness+framesize*2), 1, Color )
            EndIf
          EndIf
          If direction = 1 ; up
            If i > 0
              Box( x + i * 1, y + i + framesize, 1, - (thickness+framesize*2), Color )
            Else
              Box( x + i * 1, y - i + framesize, 1, - (thickness+framesize*2), Color )
            EndIf
          EndIf
          If direction = 3 ; down
            If i < 0
              Box( x + i * 1, y + i - framesize, 1, (thickness+framesize*2), Color )
            Else
              Box( x + i * 1, y - i - framesize, 1, (thickness+framesize*2), Color )
            EndIf
          EndIf
        Next
        Color = $000000
      EndIf
      
      For i = - size/2 To size/2
        If direction = 0 ; left
          If i > 0
            Box( x + i, y + i * 1, - (thickness), 1, Color )
          Else
            Box( x - i, y + i * 1, - (thickness), 1, Color )
          EndIf
        EndIf
        If direction = 2 ; right
          If i < 0
            Box( x + i, y + i * 1, (thickness), 1, Color )
          Else
            Box( x - i, y + i * 1, (thickness), 1, Color )
          EndIf
        EndIf
        If direction = 1 ; up
          If i > 0
            Box( x + i * 1, y + i, 1, - (thickness), Color )
          Else
            Box( x + i * 1, y - i, 1, - (thickness), Color )
          EndIf
        EndIf
        If direction = 3 ; down
          If i < 0
            Box( x + i * 1, y + i, 1, (thickness), Color )
          Else
            Box( x + i * 1, y - i, 1, (thickness), Color )
          EndIf
        EndIf
      Next
      
    Else
      
      If framesize
        Color = $ffffff
        For i = - framesize/2 To size 
          For j = i - framesize To size - i + framesize
            If direction = 0 ; left
              Box( x - i * mode + framesize, y + j-size/2, mode, 1, Color )
            EndIf
            If direction = 1 ; up
              Box( x + j-size/2, y - i * mode + framesize, 1, mode, Color )
            EndIf
            If direction = 2 ; right
              Box( x + i * mode - framesize, y + j-size/2, mode, 1, Color )
            EndIf
            If direction = 3 ; down
              Box( x + j-size/2, y + i * mode - framesize, 1, mode, Color )
            EndIf
          Next 
        Next
        Color = $000000
      EndIf
      
      For i = 0 To size
        For j = i To size - i 
          If direction = 0 ; left
            Box( x - i * mode + framesize, y + j-size/2, mode, 1, Color )
          EndIf
          If direction = 1 ; up
            Box( x + j-size/2, y - i * mode + framesize, 1, mode, Color )
          EndIf
          If direction = 2 ; right
            Box( x + i * mode - framesize, y + j-size/2, mode, 1, Color )
          EndIf
          If direction = 3 ; down
            Box( x + j-size/2, y + i * mode - framesize, 1, mode, Color )
          EndIf
        Next 
      Next
      
    EndIf
  EndIf
EndProcedure


size = 30
d=size+10
pos = 10

; display mode
mode = 1 
;   mode = 2 
;   mode = 3 
;   mode = - 1


If OpenWindow(0, 0, 0, 400, 400, "2DDrawing Example DPI", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  If CreateImage(0, 400, 400, 24, $BFBFE8) And StartDrawing(ImageOutput(0))
    
    x=pos
    y=d+pos
    Arrow(0, x,y, size, mode)
    x=d*2+pos
    Arrow(2, x,y, size, mode)
    
    y=pos
    x=d+pos
    Arrow(1, x,y, size, mode)
    y=d*2+pos
    Arrow(3, x,y, size, mode)
    
    
    StopDrawing() 
    ImageGadget(0, 0, 0, 200, 200, ImageID(0))      
  EndIf
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 521
; FirstLine = 492
; Folding = -----------------
; EnableXP
; DPIAware