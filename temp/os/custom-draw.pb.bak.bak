EnableExplicit
Define ww, wh, style, win, canvas, event, quit

ww=800
wh=600
style | #PB_Window_ScreenCentered
style | #PB_Window_SystemMenu
style | #PB_Window_MinimizeGadget

win = OpenWindow(#PB_Any, 50, 100, ww, wh, "", style)
AddKeyboardShortcut(win, #PB_Shortcut_Escape, 10)
canvas = CanvasGadget(#PB_Any, 0, 0, ww, wh)

Procedure filter(x, y, sourceColor, targetColor)
  Protected resultColor
  Protected.f r, g, b, a
  
      r = (  Red(sourceColor) * (Alpha(sourceColor) / 255.0) +   Red(targetColor) * (1 - (Alpha(sourceColor) / 255.0)))
      g = (Green(sourceColor) * (Alpha(sourceColor) / 255.0) + Green(targetColor) * (1 - (Alpha(sourceColor) / 255.0)))
      b = ( Blue(sourceColor) * (Alpha(sourceColor) / 255.0) +  Blue(targetColor) * (1 - (Alpha(sourceColor) / 255.0)))
      a = (Alpha(sourceColor) + Alpha(targetColor)) * (1.0 - Alpha(sourceColor))
      resultColor = RGBA(r, g, b, a)
   
  ProcedureReturn resultColor
EndProcedure

; Create 3 image of circle (because I use brush image ;)) (so, those 3 images are 3 brush with different colors for example)
Define i =0, c=0,w=60
For i=0 To 2
  CreateImage(i,w,w,32,#PB_Image_Transparent)
  If StartDrawing(ImageOutput(i))
    DrawingMode(#PB_2DDrawing_AllChannels)
    Select i 
      Case 0
        c = RGBA(255,0,0,255)
      Case 1
        c = RGBA(0,255,0,255)
      Case 2
        c = RGBA(0,0,255,255)
    EndSelect
    
    Circle(w/2, w/2, w/2-1, c)
    StopDrawing()
  EndIf
Next

; draw on image 4 (the image 4 is the layer)
CreateImage(4,ww,wh,32,#PB_Image_Transparent)
If StartDrawing(ImageOutput(4))
  DrawingMode(#PB_2DDrawing_AlphaBlend)
  For i = 0 To 3
    DrawAlphaImage(ImageID(0),50,50)
    DrawAlphaImage(ImageID(1),90,50)
    DrawAlphaImage(ImageID(2),70,70)
  Next
  DrawingMode(#PB_2DDrawing_CustomFilter)
  CustomFilterCallback(@filter())
  For i =0 To 3
    DrawAlphaImage(ImageID(0),250,50)
    DrawAlphaImage(ImageID(1),290,50)
    DrawAlphaImage(ImageID(2),270,70)
  Next
  StopDrawing()
EndIf

; and draw the result (the layer) on the canvas
StartDrawing(CanvasOutput(canvas))
DrawingMode(#PB_2DDrawing_AllChannels)
Box(0, 0, OutputWidth(), OutputHeight(), RGBA(200,200,200,255))
DrawAlphaImage(ImageID(4),0,0)
StopDrawing()

Repeat
  event = WaitWindowEvent(10)
  Select event
    Case #PB_Event_CloseWindow
      quit = #True
    Case #PB_Event_Menu
      Select EventMenu()
        Case 10
          quit = #True
      EndSelect
  EndSelect
Until quit


; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP