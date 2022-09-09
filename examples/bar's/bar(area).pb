XIncludeFile "../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
 
  Structure canvasitem
    img.i
    x.i
    y.i
    width.i
    height.i
    alphatest.i
  EndStructure
 
  Enumeration
    #MyCanvas = 1   ; just to test whether a number different from 0 works now
  EndEnumeration
  
  
  Global *this._s_widget  
  
  Global isCurrentItem=#False
  Global currentItemXOffset.i, currentItemYOffset.i
  Global Event.i, x.i, y.i, drag.i, hole.i, Width, Height
  Global NewList Images.canvasitem()
  
  ;;;;;;;;;;;;;;;;;;;;
  Macro EnterButton( )
    EnteredButton( )
  EndMacro
  Macro bar_hide_( )
    hide
    ;bar\hide
  EndMacro
  #__Bar_Inverted = #__Bar_Invert
  #__Bar_NoButtons = #__bar_buttonsize
  ;\bar_hide_() = \bar\bar_hide_()
  ;;;;;;;;;;;;;;;;;;;
  
  Procedure AddImage (List Images.canvasitem(), x, y, img, alphatest=0)
    If AddElement(Images())
      Images()\img    = img
      Images()\x      = x
      Images()\y      = y
      Images()\width  = ImageWidth(img)
      Images()\height = ImageHeight(img)
      Images()\alphatest = alphatest
    EndIf
  EndProcedure
 
  Procedure _Draw (canvas.i)
    Protected iWidth = X(*this\scroll\v), iHeight = Y(*this\scroll\h)
   
    If StartDrawing(CanvasOutput(canvas))
     
      ClipOutput(0,0, iWidth, iHeight)
     
      FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
     
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      ForEach Images()
        DrawImage(ImageID(Images()\img),Images()\x - *this\scroll\h\bar\page\pos,Images()\y - *this\scroll\v\bar\page\pos) ; draw all images with z-order
      Next
     
      UnclipOutput()
     
      If Not *this\scroll\v\bar_hide_()
        Draw(*this\scroll\v)
      EndIf
      If Not *this\scroll\h\bar_hide_()
        Draw(*this\scroll\h)
      EndIf
     
      StopDrawing()
    EndIf
  EndProcedure
 
  Procedure.i HitTest (List Images.canvasitem(), x, y)
    Shared currentItemXOffset.i, currentItemYOffset.i
    Protected alpha.i, isCurrentItem.i = #False
   
    If LastElement(Images()) ; search for hit, starting from end (z-order)
      Repeat
        If x >= Images()\x - *this\scroll\h\bar\page\pos And x < Images()\x - *this\scroll\h\bar\page\pos + Images()\width
          If y >= Images()\y - *this\scroll\v\bar\page\pos And y < Images()\y - *this\scroll\v\bar\page\pos + Images()\height
            alpha = 255
           
            If Images()\alphatest And ImageDepth(Images()\img)>31
              If StartDrawing(ImageOutput(Images()\img))
                DrawingMode(#PB_2DDrawing_AlphaChannel)
                alpha = Alpha(Point(x-Images()\x, y-Images()\y)) ; get alpha
                StopDrawing()
              EndIf
            EndIf
           
            If alpha
              MoveElement(Images(), #PB_List_Last)
              isCurrentItem = #True
              currentItemXOffset = x - Images()\x
              currentItemYOffset = y - Images()\y
              Break
            EndIf
          EndIf
        EndIf
      Until PreviousElement(Images()) = 0
    EndIf
   
    ProcedureReturn isCurrentItem
  EndProcedure
 
  AddImage(Images(),  10, 10, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/PureBasic.bmp"))
  AddImage(Images(), 100,100, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/GeeBee2.bmp"))
  AddImage(Images(),  250,350, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))
 
  hole = CreateImage(#PB_Any,100,100,32)
  If StartDrawing(ImageOutput(hole))
    DrawingMode(#PB_2DDrawing_AllChannels)
    Box(0,0,100,100,RGBA($00,$00,$00,$00))
    Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
    Circle(50,50,30,RGBA($00,$00,$00,$00))
    StopDrawing()
  EndIf
  AddImage(Images(),170,70,hole,1)
 
 
  Macro GetScrollCoordinate()
    ScrollX = Images()\x
    ScrollY = Images()\Y
    ScrollWidth = Images()\x+Images()\width
    ScrollHeight = Images()\Y+Images()\height
   
    PushListPosition(Images())
    ForEach Images()
      If ScrollX > Images()\x : ScrollX = Images()\x : EndIf
      If ScrollY > Images()\Y : ScrollY = Images()\Y : EndIf
      If ScrollWidth < Images()\x+Images()\width : ScrollWidth = Images()\x+Images()\width : EndIf
      If ScrollHeight < Images()\Y+Images()\height : ScrollHeight = Images()\Y+Images()\height : EndIf
    Next
    PopListPosition(Images())
  EndMacro
 
  Procedure ScrollUpdates( *this._S_widget, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height )
    With *this\scroll
      Protected iWidth = X(*this\scroll\v), iHeight = Y(*this\scroll\h)
      Static hPos, vPos : vPos = *this\scroll\v\bar\page\pos : hPos = *this\scroll\h\bar\page\pos
     
      ; Вправо работает как надо
      If ScrollArea_Width<*this\scroll\h\bar\page\pos+iWidth
        ScrollArea_Width=*this\scroll\h\bar\page\pos+iWidth
        ; Влево работает как надо
      ElseIf ScrollArea_X>*this\scroll\h\bar\page\pos And
             ScrollArea_Width=*this\scroll\h\bar\page\pos+iWidth
        ScrollArea_Width = iWidth
      EndIf
     
      ; Вниз работает как надо
      If ScrollArea_Height<*this\scroll\v\bar\page\pos+iHeight
        ScrollArea_Height=*this\scroll\v\bar\page\pos+iHeight
        ; Верх работает как надо
      ElseIf ScrollArea_Y>*this\scroll\v\bar\page\pos And
             ScrollArea_Height=*this\scroll\v\bar\page\pos+iHeight
        ScrollArea_Height = iHeight
      EndIf
     
      If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
      If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
     
      If ScrollArea_X<*this\scroll\h\bar\page\pos : ScrollArea_Width-ScrollArea_X : EndIf
      If ScrollArea_Y<*this\scroll\v\bar\page\pos : ScrollArea_Height-ScrollArea_Y : EndIf
     
      If *this\scroll\v\bar\max<>ScrollArea_Height : SetAttribute(*this\scroll\v, #__Bar_Maximum, ScrollArea_Height) : EndIf
      If *this\scroll\h\bar\max<>ScrollArea_Width : SetAttribute(*this\scroll\h, #__Bar_Maximum, ScrollArea_Width) : EndIf
     
      If *this\scroll\v\bar\page\len<>iHeight : SetAttribute(*this\scroll\v, #__Bar_PageLength, iHeight) : EndIf
      If *this\scroll\h\bar\page\len<>iWidth : SetAttribute(*this\scroll\h, #__Bar_PageLength, iWidth) : EndIf
     
      If ScrollArea_Y<0 : SetState(*this\scroll\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      If ScrollArea_X<0 : SetState(*this\scroll\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
     
      \v\bar_hide_() = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\bar_hide_()) * \h\height) - \v\y+Bool(Not \h\bar_hide_() And \v\round And \h\round)*(\v\width/4))
      \h\bar_hide_() = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\bar_hide_()) * \v\width) - \h\x+Bool(Not \v\bar_hide_() And \v\round And \h\round)*(\h\height/4), #PB_Ignore)
     
      ;   If *this\scroll\v\bar_hide_() : *this\scroll\v\bar\page\pos = 0 : Else : *this\scroll\v\bar\page\pos = vPos : *this\scroll\h\width = iWidth+*this\scroll\v\width : EndIf
      ;   If *this\scroll\h\bar_hide_() : *this\scroll\h\bar\page\pos = 0 : Else : *this\scroll\h\bar\page\pos = hPos : *this\scroll\v\height = iHeight+*this\scroll\h\height : EndIf
     
      If *this\scroll\v\bar_hide_() : *this\scroll\v\bar\page\pos = 0 : If vPos : *this\scroll\v\bar_hide_() = vPos : EndIf : Else : *this\scroll\v\bar\page\pos = vPos : EndIf
      If *this\scroll\h\bar_hide_() : *this\scroll\h\bar\page\pos = 0 : If hPos : *this\scroll\h\bar_hide_() = hPos : EndIf : Else : *this\scroll\h\bar\page\pos = hPos : EndIf
     
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  Macro bar_change(_this_, _x_,_y_, _width_, _height_)
    _this_\x[#__c_required] = _x_
    _this_\y[#__c_required] = _y_
    _this_\width[#__c_required] = _x_+_width_
    _this_\height[#__c_required] = _y_+_height_
    
    PushListPosition(Images())
    ForEach Images()
      If _this_\x[#__c_required] > Images()\x 
        _this_\x[#__c_required] = Images()\x 
      EndIf
      If _this_\y[#__c_required] > Images()\y 
        _this_\y[#__c_required] = Images()\y 
      EndIf
;     Next
;     PopListPosition(Images())
;     
;     PushListPosition(Images())
;     ForEach Images()
      If _this_\width[#__c_required] < Images()\x + Images()\width ;- _this_\x[#__c_required] 
        _this_\width[#__c_required] = Images()\x + Images()\width ;- _this_\x[#__c_required] 
      EndIf
      If _this_\height[#__c_required] < Images()\y + Images()\height ;- _this_\y[#__c_required] 
        _this_\height[#__c_required] = Images()\y + Images()\height ;- _this_\y[#__c_required] 
      EndIf
    Next
    PopListPosition(Images())
    
    
  EndMacro

  Procedure.i Canvas_CallBack( ) ; Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint
    Protected Canvas = EventGadget()
    Protected EventType = EventType()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected ScrollX, ScrollY, ScrollWidth, ScrollHeight
   
;     If CallBack(*this\scroll\v, EventType, MouseX, MouseY, WheelDelta)
;       Repaint = #True
;     EndIf
;     If CallBack(*this\scroll\h, EventType, MouseX, MouseY, WheelDelta)
;       Repaint = #True
;     EndIf
   
    Select EventType
      Case #PB_EventType_LeftButtonUp
        GetScrollCoordinate()
       
        If (ScrollX<0 Or ScrollY<0)
          PushListPosition(Images())
          ForEach Images()
            If ScrollX<0
              *this\scroll\h\bar\page\pos =- ScrollX
              Images()\X-ScrollX
            EndIf
            If ScrollY<0
              *this\scroll\v\bar\page\pos =- ScrollY
              Images()\Y-ScrollY
            EndIf
          Next
          PopListPosition(Images())
        EndIf
       
    EndSelect     
   
   
    If Not GetButtons( 0 ) And EnterButton( ) ; EnterButton( );(*this\scroll\h\bar\index Or *this\scroll\v\bar\index)
      Select EventType
        Case #PB_EventType_LeftButtonUp
          Debug "----------Up---------"
          GetScrollCoordinate()
          ScrollUpdates(*this, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
          ;           Protected iWidth = Width-Width(*this\scroll\v), iHeight = Height-Height(*this\scroll\h)
          ;   
          ;         Debug ""+*this\scroll\h\bar_hide_()+" "+ScrollX+" "+Str(ScrollWidth-iWidth)
          ;         Debug ""+*this\scroll\v\bar_hide_()+" "+ScrollY+" "+Str(ScrollHeight-iHeight)
         
          PushListPosition(Images())
          ForEach Images()
            ;           If *this\scroll\h\bar_hide_() And (ScrollWidth-Width)>0 : Images()\X-(ScrollWidth-Width) : EndIf
            ;           If *this\scroll\v\bar_hide_() And (ScrollHeight-Height)>0 : Images()\Y-(ScrollHeight-Height) : EndIf
            If *this\scroll\h\bar_hide_()>1 : Images()\X-*this\scroll\h\bar_hide_() : EndIf
            If *this\scroll\v\bar_hide_()>1 : Images()\Y-*this\scroll\v\bar_hide_() : EndIf
          Next
          PopListPosition(Images())
         
         
      EndSelect
    Else
      Select EventType
        Case #PB_EventType_LeftButtonUp : Drag = #False
        Case #PB_EventType_LeftButtonDown
          isCurrentItem = HitTest(Images(), Mousex, Mousey)
          If isCurrentItem
            Repaint = #True
            Drag = #True
          EndIf
         
        Case #PB_EventType_MouseMove
          If Drag = #True
            If isCurrentItem
              If LastElement(Images())
                Images()\x = Mousex - currentItemXOffset
                Images()\y = Mousey - currentItemYOffset
                SetWindowTitle(EventWindow(), Str(Images()\x))
               
;                 GetScrollCoordinate()
;                 *this\x[#__c_required] = ScrollX
;                 *this\y[#__c_required] = ScrollY
;                 *this\Width[#__c_required] = ScrollWidth
;                 *this\Height[#__c_required] = ScrollHeight
;                 
                bar_change(*this, Images()\x, Images()\y, Images()\width, Images()\height)
                
                ; Bar_Updates(*this, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
                Bar_Updates(*this, 0, 0, Width, Height) ; change
                Repaint = 1
              EndIf
            EndIf
          EndIf
         
        Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          GetScrollCoordinate()
         
          If *this\scroll\h\bar\max<>ScrollWidth : SetAttribute(*this\scroll\h, #__Bar_Maximum, ScrollWidth) : EndIf
          If *this\scroll\v\bar\max<>ScrollHeight : SetAttribute(*this\scroll\v, #__Bar_Maximum, ScrollHeight) : EndIf
         
          Bar_Resizes(*this, 0, 0, Width, Height)
          Repaint = #True
         
      EndSelect
    EndIf
   
    If Repaint
      _Draw(#MyCanvas)
      ReDraw(Root( ))
    EndIf
  EndProcedure
 
  Procedure ResizeCallBack()
    ResizeGadget(#MyCanvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20-100)
  EndProcedure
 
 
  If Not OpenWindow(0, 0, 0, 420, 420+100, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
 
  ;
  CheckBoxGadget(2, 10, 10, 80,20, "vertical") : SetGadgetState(2, 1)
  CheckBoxGadget(3, 10, 30, 80,20, "invert")
  CheckBoxGadget(4, 10, 50, 80,20, "noButtons")
 
  Open(0, 10, 110, 400, 400, "", 0, @Canvas_CallBack(), #MyCanvas)
  
  *this.allocate( widget )
  *this\scroll\v = Scroll( 380, 0,  20, 380, 0, 0, 0, #__Bar_Vertical|#__Bar_Inverted, 9 )
  *this\scroll\h = Scroll( 0, 380, 380,  20, 0, 0, 0, 0, 9 )
  ;Bind(*this\scroll\v,  )
  
  If GetGadgetState(2)
    SetGadgetState(3, GetAttribute(*this\scroll\v, #__Bar_Inverted))
  Else
    SetGadgetState(3, GetAttribute(*this\scroll\h, #__Bar_Inverted))
  EndIf
 
  Define vButton = GetAttribute(*this\scroll\v, #__Bar_NoButtons)
  Define hButton = GetAttribute(*this\scroll\h, #__Bar_NoButtons)
 
  ;PostEvent(#PB_Event_Gadget, 0,#MyCanvas, #PB_EventType_Resize)
  ;BindGadgetEvent(#MyCanvas, @Canvas_CallBack())
  BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
 
  Repeat
    Event = WaitWindowEvent()
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
            _Draw(#MyCanvas)
           
          Case 4
            If GetGadgetState(2)
              SetAttribute(*this\scroll\v, #__Bar_NoButtons, Bool( Not GetGadgetState(4)) * vButton)
              SetWindowTitle(0, Str(GetState(*this\scroll\v)))
            Else
              SetAttribute(*this\scroll\h, #__Bar_NoButtons, Bool( Not GetGadgetState(4)) * hButton)
              SetWindowTitle(0, Str(GetState(*this\scroll\h)))
            EndIf
            _Draw(#MyCanvas)
            
        EndSelect
    EndSelect
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = vv-+-v-----
; EnableXP