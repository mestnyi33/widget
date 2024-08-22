;
; ------------------------------------------------------------
;
;   PureBasic - 2D Drawing example file
;
;    (c) 2005 - Fantaisie Software
;
; ------------------------------------------------------------
;

If OpenWindow(0, 100, 200, 300, 200, "2D Drawing Test")

  ; Create an offscreen image, with a green circle in it.
  ; It will be displayed later
  ;
  If CanvasGadget(0,0,0, 300, 200 )
    If StartDrawing(CanvasOutput(0))
;       DrawingMode(#PB_2DDrawing_AlphaBlend)
;       Box(0,0, OutputWidth(),OutputHeight(), $FF79C7D7)
      
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      Circle(100,100,50, RGBA(0,0,255,255))  ; a nice blue circle...

      Box(150,20,20,20, RGBA(0,255,0,255))  ; and a green box
      
      FrontColor(RGBA(255,0,0,255)) ; Finally, red lines..
      For k=0 To 20
        LineXY(10,10+k*8,200, 0)
      Next
      
      DrawingMode(#PB_2DDrawing_Transparent)
      BackColor(RGBA(0,155,155,255)) ; Change the text back and front colour
      FrontColor(RGBA(255,255,255,255)) 
      DrawText(10,50,"Hello, this is a test")
      
      GrabDrawingImage(5, 0,0, OutputWidth(),OutputHeight())
      StopDrawing()
    EndIf
    
;     If StartDrawing(CanvasOutput(0))
;       DrawingMode(#PB_2DDrawing_AllChannels)
;       Box(0,0, OutputWidth(),OutputHeight(), $FF79C7D7)
;       DrawAlphaImage(ImageID(5), 0,0)
;       StopDrawing()
;     EndIf
  EndIf

  
  ;
  ; This is the 'event loop'. All the user actions are processed here.
  ; It's very easy to understand: when an action occurs, the Event
  ; isn't 0 and we just have to see what have happened...
  ;
  
  Repeat
    Event = WaitWindowEvent() 
  Until Event = #PB_Event_CloseWindow  ; If the user has pressed on the window close button
  
EndIf

End   ; All the opened windows are closed automatically by PureBasic

; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = -
; EnableXP