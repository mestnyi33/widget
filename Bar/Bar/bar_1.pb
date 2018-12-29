EnableExplicit

Structure canvasitem
  img.i
  x.i
  y.i
  Width.i
  Height.i
  alphatest.i
  Zoom.f
  Rotate.f
EndStructure

Enumeration
  #MyCanvas = 1   ; just to test whether a number different from 0 works now
EndEnumeration

Define isCurrentItem=#False
Define currentItemXOffset.i, currentItemYOffset.i
Define Event.i, x.i, y.i, hole.i
NewList Images.canvasitem()
Global Drag.i

Procedure AddImage (List Images.canvasitem(), x, y, img, alphatest=0)
  If AddElement(Images())
    Images()\img    = img
    Images()\x      = x
    Images()\y      = y
    Images()\Width  = ImageWidth(img)
    Images()\Height = ImageHeight(img)
    Images()\alphatest = alphatest
    Images()\Zoom      = 1
  EndIf
EndProcedure

Procedure DrawCanvas (canvas.i, List Images.canvasitem())
  If StartDrawing(CanvasOutput(canvas))
      Box(0, 0, GadgetWidth(canvas), GadgetHeight(canvas), RGB(255,255,255))
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      ForEach Images()
        With Images()
          \Width  = ImageWidth(\img)*\Zoom
          \Height = ImageHeight(\img)*\Zoom
          DrawImage(ImageID(\img), \x, \y, \Width, \Height) ; draw all images with z-order
        EndWith
      Next
      If Not Drag
        With Images()
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\x, \y, \Width, \Height, #Blue)
          DrawingMode(#PB_2DDrawing_Default)
          Box(\x-5, \y-5, 10, 10, #Blue)
          Box(\x + \Width-5, \y-5, 10, 10, #Blue)
          Box(\x + \Width-5, \y + \Height-5, 10, 10, #Blue)
          Box(\x-5, \y + \Height-5, 10, 10, #Blue)
        EndWith
      Else
        With Images()
          DrawingMode(#PB_2DDrawing_AlphaBlend)
          Box(\x+5, \y+5, \Width, \Height, RGBA($42, $42, $42, $50))
          
          DrawImage(ImageID(\img), \x, \y, \Width, \Height)
        EndWith
      EndIf
    StopDrawing()
  EndIf
EndProcedure

Procedure.i HitTest (List Images.canvasitem(), x, y)
  Shared currentItemXOffset.i, currentItemYOffset.i
  Protected Alpha.i, isCurrentItem.i = #False
  
  If LastElement(Images()) ; search for hit, starting from end (z-order)
    Repeat
      If x >= Images()\x And x < Images()\x + Images()\Width
        If y >= Images()\y And y < Images()\y + Images()\Height
          Alpha = 255
          If Images()\alphatest And ImageDepth(Images()\img)>31
            If StartDrawing(ImageOutput(Images()\img))
                DrawingMode(#PB_2DDrawing_AlphaChannel)
                Alpha = Alpha(Point(x-Images()\x,y-Images()\y)) ; get alpha
              StopDrawing()
            EndIf
          EndIf
          If Alpha
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
AddImage(Images(),  50,200, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))

hole = CreateImage(#PB_Any,100,100,32)
If StartDrawing(ImageOutput(hole))
    DrawingMode(#PB_2DDrawing_AllChannels)
    Box(0,0,100,100,RGBA($00,$00,$00,$00))
    Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
    Circle(50,50,30,RGBA($00,$00,$00,$00))
  StopDrawing()
EndIf
AddImage(Images(),170,70,hole,1)

If OpenWindow(0, 0, 0, 420, 420, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) = 0
  MessageRequester("Fatal error", "Program terminated.")
  End
EndIf

CanvasGadget(#MyCanvas, 10, 10, 400, 400, #PB_Canvas_Keyboard)
DrawCanvas(#MyCanvas, Images())

Repeat
  Event = WaitWindowEvent()
  
  If Event = #PB_Event_Gadget And EventGadget() = #MyCanvas

    x = GetGadgetAttribute(#MyCanvas, #PB_Canvas_MouseX)
    y = GetGadgetAttribute(#MyCanvas, #PB_Canvas_MouseY)
    
    Select EventType()
      Case #PB_EventType_MouseWheel
        If HitTest(Images(), x, y)
          If isCurrentItem
            Select GetGadgetAttribute(#MyCanvas, #PB_Canvas_WheelDelta)
              Case 1 : Images()\Zoom + 0.05
              Default: Images()\Zoom - 0.05
            EndSelect
            If Images()\Zoom < 0.1
              Images()\Zoom = 0.1
            EndIf
            DrawCanvas(#MyCanvas, Images())
          EndIf
        EndIf
        
      Case #PB_EventType_LeftButtonDown
        isCurrentItem = HitTest(Images(), x, y)
        If isCurrentItem
          DrawCanvas(#MyCanvas, Images())
        EndIf
        Drag = #True
      Case #PB_EventType_LeftButtonUp
        Drag = #False
        DrawCanvas(#MyCanvas, Images())
;         DrawCanvas(#MyCanvas, Images(), $f0fff0)
;         ResizeImage(Images()\img, Images()\width, Images()\height)

      Case #PB_EventType_MouseMove
        If Drag = #True
          If isCurrentItem
            If LastElement(Images())
              Images()\x = x - currentItemXOffset
              Images()\y = y - currentItemYOffset
              DrawCanvas(#MyCanvas, Images())
            EndIf
          EndIf
        Else   
          If HitTest(Images(), x, y)
            SetGadgetAttribute(#MyCanvas, #PB_Canvas_Cursor, #PB_Cursor_Hand)
          Else
            SetGadgetAttribute(#MyCanvas, #PB_Canvas_Cursor, #PB_Cursor_Default)
          EndIf
        EndIf
    EndSelect
  EndIf   
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -----
; EnableXP