EnableExplicit

Structure canvasitem
  img.i
  x.w
  y.w
  width.w
  height.w
  drag_x.w
  drag_y.w
  alphatest.b
EndStructure

Enumeration
  #MyCanvas = 1   ; just to test whether a number different from 0 works now
EndEnumeration

Define Event.i, x.i, y.i, drag.i, hole.i

Define *currentItem.canvasitem
NewList Images.canvasitem()

Procedure AddImage (List Images.canvasitem(), x, y, img, alphatest = #False)
  If AddElement(Images())
    If alphatest And ImageDepth(img) < 32
      alphatest = #False
    EndIf
    Images()\img    = img
    Images()\x      = x
    Images()\y      = y
    Images()\width  = ImageWidth(img)
    Images()\height = ImageHeight(img)
    Images()\alphatest = alphatest
  EndIf
EndProcedure

Procedure DrawCanvas (canvas.i, List Images.canvasitem(), bgColor.l = $ffffff)
  Shared *currentItem, drag
  Protected shadow, *i.canvasitem = *currentItem
  If drag And *i
    shadow = CopyImage(*i\img, #PB_Any)
    StartDrawing(ImageOutput(shadow))
    Box(0, 0, *i\width, *i\height, 0)
    StopDrawing()
  EndIf
  If StartDrawing(CanvasOutput(canvas))
    Box(0, 0, GadgetWidth(canvas), GadgetHeight(canvas), bgColor)
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    ForEach Images()
      *i = Images()
      If drag And *i = *currentItem
        DrawAlphaImage(ImageID(shadow), *i\x + 3, *i\y + 3, 30)
      EndIf
      DrawImage(ImageID(*i\img), *i\x, *i\y) ; draw all images with z-order
    Next
    StopDrawing()
  EndIf
  If shadow
    FreeImage(shadow)
  EndIf
EndProcedure

Procedure.i HitTest (List Images.canvasitem(), x, y, prepareFordrag = #False) ; search for hit, starting from end (z-order)
  Protected hit_x.w, hit_y.w, alpha.b, *i.canvasitem = LastElement(Images())
  While *i
    hit_x = x - *i\x
    hit_y = y - *i\y
    If hit_x >= 0 And hit_y >= 0 And hit_x < *i\width And hit_y < *i\height
      alpha = 255
      If *i\alphatest And StartDrawing(ImageOutput(*i\img))
        DrawingMode(#PB_2DDrawing_AlphaChannel)
        alpha = Point(hit_x, hit_y) >> 24 ; get alpha
        StopDrawing()
      EndIf
      If alpha
        If prepareFordrag
          MoveElement(Images(), #PB_List_Last)
          *i\drag_x = hit_x
          *i\drag_y = hit_y          
        EndIf
        Break
      EndIf
    EndIf
    *i = PreviousElement(Images())
  Wend
  ProcedureReturn *i
EndProcedure


AddImage(Images(),  10, 10, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/PureBasic.bmp"))
AddImage(Images(), 100,100, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/GeeBee2.bmp"))
AddImage(Images(),  50,200, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))

hole = CreateImage(#PB_Any,100,100,32)
If StartDrawing(ImageOutput(hole))
  DrawingMode(#PB_2DDrawing_AllChannels)
  Box(0,0,100,100,RGBA($00,$00,$00,$00))
  Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
  Circle(50,50,30,RGBA($00,$00,$00,$00))
  StopDrawing()
EndIf
AddImage(Images(),170,70,hole,#True)

If OpenWindow(0, 0, 0, 420, 420, "Move/drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) = 0
  MessageRequester("Fatal error", "Program terminated.")
  End
EndIf

CanvasGadget(#MyCanvas, 10, 10, 400, 400)
DrawCanvas(#MyCanvas, Images(), $f0fff0)

Repeat
  Event = WaitWindowEvent()
  
  If Event = #PB_Event_Gadget And EventGadget() = #MyCanvas
    Select EventType()
      Case #PB_EventType_LeftButtonDown
        x = GetGadgetAttribute(#MyCanvas, #PB_Canvas_MouseX)
        y = GetGadgetAttribute(#MyCanvas, #PB_Canvas_MouseY)
        *currentItem = HitTest(Images(), x, y, #True)
        If *currentItem
          drag = #True
          DrawCanvas(#MyCanvas, Images(), $f0fff0)
        EndIf
      Case #PB_EventType_LeftButtonUp
        drag = #False
        DrawCanvas(#MyCanvas, Images(), $f0fff0)
        
        ResizeImage(Images()\img, Images()\width, Images()\height)

      Case #PB_EventType_MouseMove
        x = GetGadgetAttribute(#MyCanvas, #PB_Canvas_MouseX)
        y = GetGadgetAttribute(#MyCanvas, #PB_Canvas_MouseY)
        If drag
          *currentItem\x = x - *currentItem\drag_x
          *currentItem\y = y - *currentItem\drag_y
          DrawCanvas(#MyCanvas, Images(), $f0fff0)
        ElseIf HitTest(Images(), x, y)
          SetGadgetAttribute(#MyCanvas, #PB_Canvas_Cursor, #PB_Cursor_Hand) 
        Else
          SetGadgetAttribute(#MyCanvas, #PB_Canvas_Cursor, #PB_Cursor_Default) 
        EndIf
    EndSelect
  EndIf   
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ----
; EnableXP