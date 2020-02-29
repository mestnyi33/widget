CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/widgets()"
  XIncludeFile "../fixme(mac).pbi"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  IncludePath "/media/sf_as/Documents/GitHub/Widget/widgets()"
CompilerElse
  IncludePath "Z:/Documents/GitHub/Widget/widgets()"
CompilerEndIf


CompilerIf Not Defined(bar, #PB_Module)
  XIncludeFile "Open().pbi"
CompilerEndIf


UseModule Bar
UseModule Constants
UseModule Structures
;   Macro OpenWindow(Window, X, Y, Width, Height, Title, Flag=0, ParentID=0)
;     bar::Open_CanvasWindow(Window, X, Y, Width, Height, Title, Flag, ParentID)
;   EndMacro
;   
EnableExplicit

Structure canvasitem
  img.i
  x.i
  y.i
  width.i
  height.i
  alphatest.i
EndStructure

Global MyCanvas, *scroll._s_scroll = AllocateStructure(_s_scroll)

Global *current=#False
Global currentItemXOffset.i, currentItemYOffset.i
Global Event.i, drag.i, hole.i
Global x=150,y=50, Width=420, Height=420 , focus

Global NewList Images.canvasitem()


Procedure Draw_Canvas(canvas.i, List Images.canvasitem())
  If StartDrawing(CanvasOutput(canvas))
    
    ;ClipOutput(0,0, iWidth, iHeight)
    
    DrawingMode(#PB_2DDrawing_Default)
    Box(0, 0, OutputWidth(), OutputHeight(), RGB(255,255,255))
    
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    ForEach Images()
      DrawImage(ImageID(Images()\img), Images()\x, Images()\y) ; draw all images with z-order
    Next
    
    ;UnclipOutput()
    
    Bar::Draw(*scroll\v)
    Bar::Draw(*scroll\h)
    
    UnclipOutput()
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(x, y, Width, Height, RGB(0,255,255))
    Box(*scroll\x, *scroll\y, *scroll\width, *scroll\height, RGB(255,0,255))
    Box(*scroll\x, *scroll\y, *scroll\h\bar\max, *scroll\v\bar\max, RGB(255,0,0))
    Box(*scroll\h\x, *scroll\v\y, *scroll\h\bar\page\len, *scroll\v\bar\page\len, RGB(255,255,0))
    
    StopDrawing()
  EndIf
EndProcedure

Procedure.i HitTest (List Images.canvasitem(), x, y)
  Shared currentItemXOffset.i, currentItemYOffset.i
  Protected alpha.i, *current = #False
  Protected scroll_x ; = *scroll\h\bar\Page\Pos
  Protected scroll_y ;= *scroll\v\bar\Page\Pos
  
  If LastElement(Images()) ; search for hit, starting from end (z-order)
    Repeat
      If x >= Images()\x - scroll_x And x < Images()\x+ Images()\width - scroll_x 
        If y >= Images()\y - scroll_y And y < Images()\y + Images()\height - scroll_y
          alpha = 255
          
          If Images()\alphatest And ImageDepth(Images()\img)>31
            If StartDrawing(ImageOutput(Images()\img))
              DrawingMode(#PB_2DDrawing_AlphaChannel)
              alpha = Alpha(Point(x-Images()\x - scroll_x, y-Images()\y - scroll_y)) ; get alpha
              StopDrawing()
            EndIf
          EndIf
          
          If alpha
            MoveElement(Images(), #PB_List_Last)
            *current = @Images()
            currentItemXOffset = x - Images()\x - scroll_x
            currentItemYOffset = y - Images()\y - scroll_y
            Break
          EndIf
        EndIf
      EndIf
    Until PreviousElement(Images()) = 0
  EndIf
  
  ProcedureReturn *current
EndProcedure

Procedure AddImage (List Images.canvasitem(), x, y, img, alphatest=0)
  If AddElement(Images())
    Images()\img    = img
    Images()\x          = x
    Images()\y          = y
    Images()\width  = ImageWidth(img)
    Images()\height = ImageHeight(img)
    Images()\alphatest = alphatest
  EndIf
EndProcedure

AddImage(Images(),  x+10, y+10, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/PureBasic.bmp"))
AddImage(Images(), x+100,y+100, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/GeeBee2.bmp"))
;AddImage(Images(),  x+221,y+200, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))
;AddImage(Images(),  x+210,y+321, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))
AddImage(Images(),  x,y-1, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))

hole = CreateImage(#PB_Any,100,100,32)
If StartDrawing(ImageOutput(hole))
  DrawingMode(#PB_2DDrawing_AllChannels)
  Box(0,0,100,100,RGBA($00,$00,$00,$00))
  Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
  Circle(50,50,30,RGBA($00,$00,$00,$00))
  StopDrawing()
EndIf
AddImage(Images(),x+170,y+70,hole,1)


Procedure _8Updates(*scroll._s_scroll, x.l, y.l, width.l, height.l)
  Protected i_width = (width - Bool(*scroll\v\bar\min <> *scroll\v\bar\page\end) * *scroll\v\width)
  Protected i_height = (height - Bool(*scroll\h\bar\min <> *scroll\h\bar\page\end) * *scroll\h\height)
  
  If *scroll\x > x
    *scroll\width + (*scroll\x-x) 
    *scroll\x = x
  EndIf
  
  If *scroll\y > y
    *scroll\height + (*scroll\y-y)
    *scroll\y = y
  EndIf
  
  If *scroll\width < i_width - (*scroll\x-x)
    *scroll\width = i_width - (*scroll\x-x)
  EndIf
  
  If *scroll\height < i_height - (*scroll\y-y)
    *scroll\height = i_height - (*scroll\y-y)
  EndIf
  
  If *scroll\h\bar\Max <> *scroll\width 
    *scroll\h\bar\Max = *scroll\width
    
    If *scroll\x =< x 
      *scroll\h\bar\page\pos =- (*scroll\x-x)
      *scroll\h\bar\change = 0
    EndIf
    
    *scroll\h\hide = Bar::Update(*scroll\h) 
  EndIf
  
  If *scroll\v\bar\Max <> *scroll\height  
    *scroll\v\bar\Max = *scroll\height
    
    If *scroll\y =< y 
      *scroll\v\bar\page\pos =- (*scroll\y-y)
      *scroll\v\bar\change = 0
    EndIf
    
    *scroll\v\hide = Bar::Update(*scroll\v) 
  EndIf
  
  If *scroll\v\height <> i_height
    *scroll\v\bar\page\len = i_height
    *scroll\v\hide = Bar::Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, i_height)
  EndIf
  
  If *scroll\h\width <> i_width
    *scroll\h\bar\page\len = i_width
    *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, #PB_Ignore, i_width, #PB_Ignore)
  EndIf
  
  
  i_width = (width - Bool(*scroll\v\bar\min <> *scroll\v\bar\page\end) * *scroll\v\width)
  i_height = (height - Bool(*scroll\h\bar\min <> *scroll\h\bar\page\end) * *scroll\h\height)
  
  If Bool(*scroll\h\bar\min = *scroll\h\bar\page\end)
    *scroll\width = i_width - (*scroll\x-x)
    
    If *scroll\h\bar\Max <> *scroll\width 
      *scroll\h\bar\Max = *scroll\width
      
      If *scroll\x =< x 
        *scroll\h\bar\page\pos =- (*scroll\x-x)
        *scroll\h\bar\change = 0
      EndIf
      
      *scroll\h\hide = Bar::Update(*scroll\h) 
    EndIf
  EndIf
  
  If Bool(*scroll\v\bar\min = *scroll\v\bar\page\end)
    *scroll\height = i_height - (*scroll\y-y)
    
    If *scroll\v\bar\Max <> *scroll\height  
      *scroll\v\bar\Max = *scroll\height
      
      If *scroll\y =< y 
        *scroll\v\bar\page\pos =- (*scroll\y-y)
        *scroll\v\bar\change = 0
      EndIf
      
      *scroll\v\hide = Bar::Update(*scroll\v) 
    EndIf
  EndIf
  
  If *scroll\v\height <> i_height
    *scroll\v\bar\page\len = i_height
    *scroll\v\hide = Bar::Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, i_height)
  EndIf
  
  If *scroll\h\width <> i_width
    *scroll\h\bar\page\len = i_width
    *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, #PB_Ignore, i_width, #PB_Ignore)
  EndIf
  
  ;   *scroll\v\hide = 0
  ;   *scroll\h\hide = 0
  
EndProcedure

Procedure _7Updates(*scroll._s_scroll, x.l, y.l, width.l, height.l)
  Protected r_width
  Protected r_height
  
  Protected i_width = (width - Bool(*scroll\v\bar\min <> *scroll\v\bar\page\end) * *scroll\v\width)
  Protected i_height = (height - Bool(*scroll\h\bar\min <> *scroll\h\bar\page\end) * *scroll\h\height)
  
  If *scroll\x > x
    *scroll\width + (*scroll\x-x) 
    *scroll\x = x
  EndIf
  
  If *scroll\y > y
    *scroll\height + (*scroll\y-y)
    *scroll\y = y
  EndIf
  
  If *scroll\width < i_width - (*scroll\x-x)
    *scroll\width = i_width - (*scroll\x-x)
  EndIf
  
  If *scroll\height < i_height - (*scroll\y-y)
    *scroll\height = i_height - (*scroll\y-y)
  EndIf
  
  If *scroll\h\bar\Max <> *scroll\width 
    *scroll\h\bar\Max = *scroll\width
    
    If *scroll\x =< x 
      *scroll\h\bar\page\pos =- (*scroll\x-x)
      *scroll\h\bar\change = 0
    EndIf
    
    *scroll\h\hide = Bar::Update(*scroll\h) 
  EndIf
  
  If *scroll\v\bar\Max <> *scroll\height  
    *scroll\v\bar\Max = *scroll\height
    
    If *scroll\y =< y 
      *scroll\v\bar\page\pos =- (*scroll\y-y)
      *scroll\v\bar\change = 0
    EndIf
    
    *scroll\v\hide = Bar::Update(*scroll\v) 
  EndIf
  
  If *scroll\h\width <> i_width
    *scroll\h\bar\page\len = i_width
    *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, #PB_Ignore, i_width, #PB_Ignore)
  EndIf
  
  If *scroll\v\height <> i_height
    Debug  ""+i_height
    *scroll\v\bar\page\len = i_height
    *scroll\v\hide = Bar::Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, i_height)
  EndIf
  
  If *scroll\v\bar\min <> *scroll\v\bar\page\end
    i_width = width - *scroll\v\width
    
    If *scroll\h\bar\min = *scroll\h\bar\page\end
      *scroll\width = i_width - (*scroll\x-x)
      *scroll\h\bar\Max = *scroll\width
    EndIf
  Else
    i_width = width
  EndIf
  
  If *scroll\h\bar\min <> *scroll\h\bar\page\end
    i_height = height - *scroll\h\height
    
    If *scroll\v\bar\min = *scroll\v\bar\page\end
      *scroll\height = i_height - (*scroll\y-y)
      *scroll\v\bar\Max = *scroll\height
    EndIf
  Else
    i_height = height
  EndIf
  
  
  ; ; ;   i_width = (width - Bool(*scroll\v\bar\min <> *scroll\v\bar\page\end) * *scroll\v\width)
  ; ; ;   i_height = (height - Bool(*scroll\h\bar\min <> *scroll\h\bar\page\end) * *scroll\h\height)
  ; ;   
  ; ;   If *scroll\h\bar\min = *scroll\h\bar\page\end
  ; ;     *scroll\width = i_width - (*scroll\x-x)
  ; ;     *scroll\h\bar\Max = *scroll\width
  ; ;   EndIf
  ; ;   
  ; ;   If *scroll\v\bar\min = *scroll\v\bar\page\end
  ; ;     *scroll\height = i_height - (*scroll\y-y)
  ; ;     *scroll\v\bar\Max = *scroll\height
  ; ;   EndIf
  
  r_width = i_width + Bool(Not *scroll\v\hide And *scroll\h\round And *scroll\v\round) * (*scroll\v\width/4)
  r_height = i_height + Bool(Not *scroll\h\hide And *scroll\v\round And *scroll\h\round) * (*scroll\h\height/4)
  
  If *scroll\h\width <> r_width
    *scroll\h\bar\page\len = i_width
    *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, #PB_Ignore, r_width, #PB_Ignore)
  EndIf
  
  If *scroll\v\height <> r_height
    Debug  "  "+i_height
    *scroll\v\bar\page\len = i_height
    *scroll\v\hide = Bar::Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, r_height)
  EndIf
  
EndProcedure

Procedure _0Updates(*scroll._s_scroll, x.l, y.l, width.l, height.l)
  Protected r_width
  Protected r_height
  
  Protected i_width = (width - Bool(*scroll\v\bar\min <> *scroll\v\bar\page\end) * *scroll\v\width)
  Protected i_height = (height - Bool(*scroll\h\bar\min <> *scroll\h\bar\page\end) * *scroll\h\height)
  
  Protected rh ;= Bool(Not *scroll\h\hide And Not *scroll\v\hide And *scroll\v\round And *scroll\h\round) * (*scroll\h\height/4)
  Protected rw ;= Bool(Not *scroll\h\hide And Not *scroll\v\hide And *scroll\v\round And *scroll\h\round) * (*scroll\v\width/4)
  
  If *scroll\x > x
    *scroll\width + (*scroll\x-x) 
    *scroll\x = x
  EndIf
  
  If *scroll\y > y
    *scroll\height + (*scroll\y-y)
    *scroll\y = y
  EndIf
  
  If *scroll\v\bar\page\len <> height - Bool(*scroll\width > i_width Or *scroll\h\bar\min <> *scroll\h\bar\page\end) * *scroll\h\height
    *scroll\v\bar\page\len = height - Bool(*scroll\width > i_width Or *scroll\h\bar\min <> *scroll\h\bar\page\end) * *scroll\h\height
    *scroll\v\hide = Bar::Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *scroll\v\bar\page\len)
  EndIf
  
  If *scroll\h\bar\page\len <> width - Bool(*scroll\height > i_height Or *scroll\v\bar\min <> *scroll\v\bar\page\end) * *scroll\v\width
    *scroll\h\bar\page\len = width - Bool(*scroll\height > i_height Or *scroll\v\bar\min <> *scroll\v\bar\page\end) * *scroll\v\width
    *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, #PB_Ignore, *scroll\h\bar\page\len, #PB_Ignore)
  EndIf
  
  If *scroll\v\bar\page\len <> height - Bool(*scroll\h\bar\min <> *scroll\h\bar\page\end) * *scroll\h\height
    *scroll\v\bar\page\len = height - Bool(*scroll\h\bar\min <> *scroll\h\bar\page\end) * *scroll\h\height
    *scroll\v\hide = Bar::Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *scroll\v\bar\page\len)
  EndIf
  
  If *scroll\h\bar\page\len <> width - Bool(*scroll\v\bar\min <> *scroll\v\bar\page\end) * *scroll\v\width
    *scroll\h\bar\page\len = width - Bool(*scroll\v\bar\min <> *scroll\v\bar\page\end) * *scroll\v\width
    *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, #PB_Ignore, *scroll\h\bar\page\len, #PB_Ignore)
  EndIf
  
  If *scroll\h\y[#__c_3] <> y+*scroll\v\bar\page\len
    *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, y+*scroll\v\bar\page\len, #PB_Ignore, #PB_Ignore)
  EndIf
  
  If *scroll\v\x[#__c_3] <> x+*scroll\h\bar\page\len
    *scroll\v\hide = Bar::Resize(*scroll\v, x+*scroll\h\bar\page\len, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  EndIf
  
  If *scroll\width < *scroll\h\bar\page\len - (*scroll\x-x)
    *scroll\h\hide = #True
    *scroll\h\bar\max = *scroll\width
    *scroll\width = *scroll\h\bar\page\len - (*scroll\x-x)
  EndIf
  
  If *scroll\height < *scroll\v\bar\page\len - (*scroll\y-y)
    *scroll\v\hide = #True
    *scroll\v\bar\max = *scroll\height
    *scroll\height = *scroll\v\bar\page\len - (*scroll\y-y)
  EndIf
  
  If *scroll\width > *scroll\h\bar\page\len
    If *scroll\h\bar\Max <> *scroll\width 
      *scroll\h\bar\Max = *scroll\width
      
      If *scroll\x =< x 
        *scroll\h\bar\page\pos =- (*scroll\x-x)
        *scroll\h\bar\change = 0
      EndIf
      
      *scroll\h\hide = Bar::Update(*scroll\h) 
    EndIf
  EndIf
  
  If *scroll\height > *scroll\v\bar\page\len
    If *scroll\v\bar\Max <> *scroll\height  
      *scroll\v\bar\Max = *scroll\height
      
      If *scroll\y =< y 
        *scroll\v\bar\page\pos =- (*scroll\y-y)
        *scroll\v\bar\change = 0
      EndIf
      
      *scroll\v\hide = Bar::Update(*scroll\v) 
    EndIf
  EndIf
EndProcedure

Procedure _2Updates(*scroll._s_scroll, x.l, y.l, width.l, height.l)
  Protected r_width
  Protected r_height
  
  Protected i_width = (width); - Bool(Not *scroll\v\hide) * *scroll\v\width)
  Protected i_height = (height); - Bool(Not *scroll\h\hide) * *scroll\h\height)
  
  Protected sx, sy
  Protected rh ;= Bool(Not *scroll\h\hide And Not *scroll\v\hide And *scroll\v\round And *scroll\h\round) * (*scroll\h\height/4)
  Protected rw ;= Bool(Not *scroll\h\hide And Not *scroll\v\hide And *scroll\v\round And *scroll\h\round) * (*scroll\v\width/4)
  
  If *scroll\v\bar\page\len <> height - Bool(*scroll\width > i_width) * *scroll\h\height
    *scroll\v\bar\page\len = height - Bool(*scroll\width > i_width) * *scroll\h\height
  EndIf
  
  If *scroll\h\bar\page\len <> width - Bool(*scroll\height > i_height) * *scroll\v\width
    *scroll\h\bar\page\len = width - Bool(*scroll\height > i_height) * *scroll\v\width
  EndIf
  
  If *scroll\x > x
    sx = (*scroll\x-x) 
    *scroll\width + (*scroll\x-x) 
    *scroll\x = x
  Else
    *scroll\v\bar\page\len = height - *scroll\h\height
  EndIf
  
  If *scroll\y > y
    sy = (*scroll\y-y)
    *scroll\height + (*scroll\y-y)
    *scroll\y = y
  Else
    *scroll\h\bar\page\len = width - *scroll\v\width
  EndIf
  
  If *scroll\width =< *scroll\h\bar\page\len - (*scroll\x-x)
    *scroll\h\hide = #True
    *scroll\h\bar\max = *scroll\width
    *scroll\width = *scroll\h\bar\page\len - (*scroll\x-x)
  Else
    If *scroll\width-sx =< width And 
       *scroll\height = *scroll\v\bar\page\len - (*scroll\x-x)
      Debug "w - "+Str(*scroll\height-sx)
      *scroll\height = *scroll\v\bar\page\len - (*scroll\x-x) - *scroll\h\height
    EndIf
    
    *scroll\v\bar\page\len = height - *scroll\h\height 
  EndIf
  
  If *scroll\height =< *scroll\v\bar\page\len - (*scroll\y-y)
    *scroll\v\hide = #True
    *scroll\v\bar\max = *scroll\height
    *scroll\height = *scroll\v\bar\page\len - (*scroll\y-y)
  Else
    If *scroll\height-sy =< Height And 
       *scroll\width = *scroll\h\bar\page\len - (*scroll\x-x)
      Debug "h - "+Str(*scroll\height-sy)
      *scroll\width = *scroll\h\bar\page\len - (*scroll\x-x) - *scroll\v\width
    EndIf
    
    *scroll\h\bar\page\len = width - *scroll\v\width
  EndIf
  
  If *scroll\v\height <> *scroll\v\bar\page\len
    Debug  "v "+*scroll\v\bar\page\len
    *scroll\v\hide = Bar::Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *scroll\v\bar\page\len)
  EndIf
  
  If *scroll\h\width <> *scroll\h\bar\page\len
    Debug  "h "+*scroll\h\bar\page\len
    *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, #PB_Ignore, *scroll\h\bar\page\len, #PB_Ignore)
  EndIf
  
  ;   If *scroll\h\y[#__c_3] <> y+height-*scroll\h\height
  ;     *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, y+height-*scroll\h\height, #PB_Ignore, #PB_Ignore)
  ;   EndIf
  ;   
  ;   If *scroll\v\x[#__c_3] <> x+width-*scroll\v\width
  ;     *scroll\v\hide = Bar::Resize(*scroll\v, x+width-*scroll\v\width, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  ;   EndIf
  
  
  If *scroll\width > *scroll\h\bar\page\len
    If *scroll\h\bar\Max <> *scroll\width 
      *scroll\h\bar\Max = *scroll\width
      
      If *scroll\x =< x 
        *scroll\h\bar\page\pos =- (*scroll\x-x)
        *scroll\h\bar\change = 0
      EndIf
      
      *scroll\h\hide = Bar::Update(*scroll\h) 
    EndIf
  EndIf
  
  If *scroll\height > *scroll\v\bar\page\len
    If *scroll\v\bar\Max <> *scroll\height  
      *scroll\v\bar\Max = *scroll\height
      
      If *scroll\y =< y 
        *scroll\v\bar\page\pos =- (*scroll\y-y)
        *scroll\v\bar\change = 0
      EndIf
      
      *scroll\v\hide = Bar::Update(*scroll\v) 
    EndIf
  EndIf
  
  *scroll\v\hide = 0
EndProcedure

Procedure _Updates(*scroll._s_scroll, x.l, y.l, width.l, height.l)
  Static v_max, h_max
  
  Protected sx, sy
  Protected rh ;= Bool(Not *scroll\h\hide And Not *scroll\v\hide And *scroll\v\round And *scroll\h\round) * (*scroll\h\height/4)
  Protected rw ;= Bool(Not *scroll\h\hide And Not *scroll\v\hide And *scroll\v\round And *scroll\h\round) * (*scroll\v\width/4)
  
  If *scroll\v\bar\page\len <> height - Bool(*scroll\width > width) * *scroll\h\height
    *scroll\v\bar\page\len = height - Bool(*scroll\width > width) * *scroll\h\height
  EndIf
  
  If *scroll\h\bar\page\len <> width - Bool(*scroll\height > height) * *scroll\v\width
    *scroll\h\bar\page\len = width - Bool(*scroll\height > height) * *scroll\v\width
  EndIf
  
  If *scroll\x >= x
    sx = (*scroll\x-x) 
    *scroll\width + (*scroll\x-x) 
    *scroll\x = x
  Else
    *scroll\v\bar\page\len = height - *scroll\h\height
  EndIf
  
  If *scroll\y >= y
    sy = (*scroll\y-y)
    *scroll\height + (*scroll\y-y)
    *scroll\y = y
  Else
    *scroll\h\bar\page\len = width - *scroll\v\width
  EndIf
  
  If *scroll\width =< *scroll\h\bar\page\len - (*scroll\x-x)
    *scroll\h\bar\max = *scroll\width
    *scroll\width = *scroll\h\bar\page\len - (*scroll\x-x)
  Else
    If *scroll\width-sx =< width And *scroll\height = *scroll\v\bar\page\len - (*scroll\x-x)
      ;Debug "w - "+Str(*scroll\height-sx)
      
      ; if on the h-scroll
      If *scroll\v\bar\max > height - *scroll\h\height
        *scroll\v\bar\page\len = height - *scroll\h\height
        *scroll\h\bar\page\len = width - *scroll\v\width 
        *scroll\height = *scroll\v\bar\max
        Debug "w - "+*scroll\v\bar\max +" "+ *scroll\v\height +" "+ *scroll\v\bar\page\len
      Else
        *scroll\height = *scroll\v\bar\page\len - (*scroll\x-x) - *scroll\h\height
      EndIf
    EndIf
    
    *scroll\v\bar\page\len = height - *scroll\h\height 
  EndIf
  
  If *scroll\height =< *scroll\v\bar\page\len - (*scroll\y-y)
    *scroll\v\bar\max = *scroll\height
    *scroll\height = *scroll\v\bar\page\len - (*scroll\y-y)
  Else
    If *scroll\height-sy =< Height And *scroll\width = *scroll\h\bar\page\len - (*scroll\x-x)
      ;Debug " h - "+Str(*scroll\height-sy)
      
      ; if on the v-scroll
      If *scroll\h\bar\max > width - *scroll\v\width
        *scroll\h\bar\page\len = width - *scroll\v\width
        *scroll\v\bar\page\len = height - *scroll\h\height 
        *scroll\width = *scroll\h\bar\max
        Debug "h - "+*scroll\h\bar\max +" "+ *scroll\h\width +" "+ *scroll\h\bar\page\len
      Else
        *scroll\width = *scroll\h\bar\page\len - (*scroll\x-x) - *scroll\v\width
      EndIf
    EndIf
    
    *scroll\h\bar\page\len = width - *scroll\v\width
  EndIf
  
  If *scroll\width >= *scroll\h\bar\page\len  
    If *scroll\h\bar\Max <> *scroll\width 
      *scroll\h\bar\Max = *scroll\width
      
      If *scroll\x =< x 
        *scroll\h\bar\page\pos =- (*scroll\x-x)
        *scroll\h\bar\change = 0
      EndIf
    EndIf
    
    If *scroll\h\width <> *scroll\h\bar\page\len
      ; Debug  "h "+*scroll\h\bar\page\len
      *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, #PB_Ignore, *scroll\h\bar\page\len, #PB_Ignore)
    EndIf
  EndIf
  
  If *scroll\height >= *scroll\v\bar\page\len  
    If *scroll\v\bar\Max <> *scroll\height  
      *scroll\v\bar\Max = *scroll\height
      
      If *scroll\y =< y 
        *scroll\v\bar\page\pos =- (*scroll\y-y)
        *scroll\v\bar\change = 0
      EndIf
    EndIf
    
    If *scroll\v\height <> *scroll\v\bar\page\len
      ; Debug  "v "+*scroll\v\bar\page\len
      *scroll\v\hide = Bar::Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *scroll\v\bar\page\len)
    EndIf
  EndIf
  
  ; mac os ok but no ok windows
;   If Not *scroll\h\hide And *scroll\h\y[#__c_3] <> y+*scroll\v\bar\page\len
;     ; Debug "y"
;     *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, y+*scroll\v\bar\page\len, #PB_Ignore, #PB_Ignore)
;   EndIf
;   
;   If Not *scroll\v\hide And *scroll\v\x[#__c_3] <> x+*scroll\h\bar\page\len
;     ; Debug "x"
;     *scroll\v\hide = Bar::Resize(*scroll\v, x+*scroll\h\bar\page\len, #PB_Ignore, #PB_Ignore, #PB_Ignore)
;   EndIf
  
  If Not *scroll\h\hide And *scroll\h\y[#__c_3] <> y+height - *scroll\h\height
    ; Debug "y"
    *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, y+height - *scroll\h\height, #PB_Ignore, #PB_Ignore)
  EndIf
  
  If Not *scroll\v\hide And *scroll\v\x[#__c_3] <> x+width - *scroll\v\width
    ; Debug "x"
    *scroll\v\hide = Bar::Resize(*scroll\v, x+width - *scroll\v\width, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  EndIf
 
  If v_max <> *scroll\v\bar\Max
    v_max = *scroll\v\bar\Max
    *scroll\v\hide = Bar::Update(*scroll\v) 
  EndIf
  
  If h_max <> *scroll\h\bar\Max
    h_max = *scroll\h\bar\Max
    *scroll\h\hide = Bar::Update(*scroll\h) 
  EndIf
  
EndProcedure

Procedure _Resizes(*scroll._s_scroll, x.l, y.l, width.l, height.l)
  Protected r_width
  Protected r_height
  
  Protected i_width = (width - Bool(*scroll\v\bar\min <> *scroll\v\bar\page\end) * *scroll\v\width)
  Protected i_height = (height - Bool(*scroll\h\bar\min <> *scroll\h\bar\page\end) * *scroll\h\height)
  
  If *scroll\x > x
    *scroll\width + (*scroll\x-x) 
    *scroll\x = x
  EndIf
  
  If *scroll\y > y
    *scroll\height + (*scroll\y-y)
    *scroll\y = y
  EndIf
  
  Protected rh ;= Bool(Not *scroll\h\hide And Not *scroll\v\hide And *scroll\v\round And *scroll\h\round) * (*scroll\h\height/4)
  Protected rw ;= Bool(Not *scroll\h\hide And Not *scroll\v\hide And *scroll\v\round And *scroll\h\round) * (*scroll\v\width/4)
  
  If *scroll\v\bar\page\len <> height - Bool(*scroll\width > i_width) * *scroll\h\height
    *scroll\v\bar\page\len = height - Bool(*scroll\width > i_width) * *scroll\h\height
    *scroll\v\hide = Bar::Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *scroll\v\bar\page\len)
  EndIf
  
  If *scroll\h\bar\page\len <> width - Bool(*scroll\height > i_height) * *scroll\v\width
    *scroll\h\bar\page\len = width - Bool(*scroll\height > i_height) * *scroll\v\width
    *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, #PB_Ignore, *scroll\h\bar\page\len, #PB_Ignore)
  EndIf
  
  If *scroll\v\bar\page\len <> height - Bool(*scroll\h\bar\min <> *scroll\h\bar\page\end) * *scroll\h\height
    *scroll\v\bar\page\len = height - Bool(*scroll\h\bar\min <> *scroll\h\bar\page\end) * *scroll\h\height
    *scroll\v\hide = Bar::Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *scroll\v\bar\page\len)
  EndIf
  
  If *scroll\h\bar\page\len <> width - Bool(*scroll\v\bar\min <> *scroll\v\bar\page\end) * *scroll\v\width
    *scroll\h\bar\page\len = width - Bool(*scroll\v\bar\min <> *scroll\v\bar\page\end) * *scroll\v\width
    *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, #PB_Ignore, *scroll\h\bar\page\len, #PB_Ignore)
  EndIf
  
  If *scroll\h\y[#__c_3] <> y+*scroll\v\bar\page\len
    *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, y+*scroll\v\bar\page\len, #PB_Ignore, #PB_Ignore)
  EndIf
  
  If *scroll\v\x[#__c_3] <> x+*scroll\h\bar\page\len
    *scroll\v\hide = Bar::Resize(*scroll\v, x+*scroll\h\bar\page\len, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  EndIf
  
  If *scroll\width < *scroll\h\bar\page\len - (*scroll\x-x)
    *scroll\h\hide = #True
    *scroll\h\bar\max = *scroll\width
    *scroll\width = *scroll\h\bar\page\len - (*scroll\x-x)
  EndIf
  
  If *scroll\height < *scroll\v\bar\page\len - (*scroll\y-y)
    *scroll\v\hide = #True
    *scroll\v\bar\max = *scroll\height
    *scroll\height = *scroll\v\bar\page\len - (*scroll\y-y)
  EndIf
  
  If *scroll\width > *scroll\h\bar\page\len
    If *scroll\h\bar\Max <> *scroll\width 
      *scroll\h\bar\Max = *scroll\width
      
      If *scroll\x =< x 
        *scroll\h\bar\page\pos =- (*scroll\x-x)
        *scroll\h\bar\change = 0
      EndIf
      
      *scroll\h\hide = Bar::Update(*scroll\h) 
    EndIf
  EndIf
  
  If *scroll\height > *scroll\v\bar\page\len
    If *scroll\v\bar\Max <> *scroll\height  
      *scroll\v\bar\Max = *scroll\height
      
      If *scroll\y =< y 
        *scroll\v\bar\page\pos =- (*scroll\y-y)
        *scroll\v\bar\change = 0
      EndIf
      
      *scroll\v\hide = Bar::Update(*scroll\v) 
    EndIf
  EndIf
EndProcedure

Macro GetScrollCoordinate()
  *scroll\x = Images()\x 
  *scroll\y = Images()\Y
  *scroll\width = Images()\x+Images()\width - *scroll\x
  *scroll\height = Images()\Y+Images()\height - *scroll\y
  
  PushListPosition(Images())
  ForEach Images()
    If *scroll\x > Images()\x : *scroll\x = Images()\x : EndIf
    If *scroll\y > Images()\y : *scroll\y = Images()\y : EndIf
  Next
  ForEach Images()
    If *scroll\width < Images()\x+Images()\width - *scroll\x : *scroll\width = Images()\x+Images()\width - *scroll\x : EndIf
    If *scroll\height < Images()\Y+Images()\height - *scroll\y : *scroll\height = Images()\Y+Images()\height - *scroll\y : EndIf
  Next
  PopListPosition(Images())
  
  ;Bar::Updates(*scroll, x, y, width, height)
  _Updates(*scroll, x, y, width, height)
  
  SetWindowTitle(EventWindow(), Str(Images()\x)+" "+Str(Images()\width)+" "+Str(Images()\x+Images()\width))
EndMacro

Procedure CallBack()
  Protected Repaint
  Protected Event = EventType()
  Protected Canvas = EventGadget()
  Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
  Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
  Protected Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
  Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
  
  Width = GadgetWidth(Canvas) - x*2
  Height = GadgetHeight(Canvas) - y*2
  
  If Bar::Events(*scroll\v, Event, MouseX, MouseY, WheelDelta) 
    If *scroll\v\bar\change
      PushListPosition(Images())
      ForEach Images()
        Images()\Y + *scroll\v\bar\page\change 
      Next
      PopListPosition(Images())
      
      *scroll\y =- *scroll\v\bar\page\pos+*scroll\v\y
      *scroll\v\bar\change = 0
    EndIf
    Repaint = #True 
  EndIf
  
  If Bar::Events(*scroll\h, Event, MouseX, MouseY, WheelDelta) 
    If *scroll\h\bar\change
      PushListPosition(Images())
      ForEach Images()
        Images()\X + *scroll\h\bar\page\change
      Next
      PopListPosition(Images())
      
      *scroll\x =- *scroll\h\bar\page\pos+*scroll\h\x
      *scroll\h\bar\change = 0
    EndIf
    Repaint = #True 
  EndIf
  
  If Not (*scroll\h\from=-1 And *scroll\v\from=-1)
    ;     Select Event
    ;       Case #PB_EventType_LeftButtonUp
    ;         Debug "----------Up---------"
    ;         ;  ScrollUpdates(Width, Height)
    ;     EndSelect
  Else
    Select Event
      Case #PB_EventType_LeftButtonUp : Drag = #False
      Case #PB_EventType_LeftButtonDown
        *current = HitTest(Images(), Mousex, Mousey)
        If *current 
          Repaint = #True 
          Drag = #True
        EndIf
        
      Case #PB_EventType_MouseMove
        If Drag = #True
          If *current
            If LastElement(Images())
              Images()\x = Mousex - currentItemXOffset
              Images()\y = Mousey - currentItemYOffset
              
              GetScrollCoordinate()
              
              Repaint = #True
            EndIf
          EndIf
        EndIf
        
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
                                                                                                       ;Bar::Resizes(*scroll, x, y, width, height)
        GetScrollCoordinate()
        
        
        ;         ; ffffff
        ;         *scroll\v\hide = Bar::SetAttribute(*scroll\v, #__bar_pagelength, Height)
        ;         *scroll\h\hide = Bar::SetAttribute(*scroll\h, #__bar_pagelength, Width)
        Repaint = #True
        
    EndSelect
  EndIf 
  
  If Repaint : Draw_Canvas(MyCanvas, Images()) : EndIf
EndProcedure

Procedure ResizeCallBack()
  ResizeGadget(MyCanvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
EndProcedure


If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
  MessageRequester("Fatal error", "Program terminated.")
  End
EndIf

;
MyCanvas = Open_Canvas(0, 10, 10, Width+x*2, Width+y*2, #PB_Canvas_Keyboard)

*scroll\v = Bar::scroll(x+Width-20, y,  20, 0, 0, 0, Width-20, #__bar_Vertical, 11)
*scroll\h = Bar::scroll(x, y+Height-20, 0,  20, 0, 0, Height-20, 0, 11)

PostEvent(#PB_Event_Gadget, 0,MyCanvas,#PB_EventType_Resize)
BindGadgetEvent(MyCanvas, @CallBack())
BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = X-----------------------
; EnableXP