;
; ------------------------------------------------------------
;
;   PureBasic - Image example file
;
;    (c) Fantaisie Software
;
; ------------------------------------------------------------
;

Procedure draws( text.s )
  DrawingMode(#PB_2DDrawing_Default)
  Box( 0, 0, OutputWidth(), OutputHeight(), $FFFFFF)
  DrawingMode(#PB_2DDrawing_Outlined)
  Box( 0, 0, OutputWidth(), OutputHeight(), $000000)
  FrontColor($000000) ; print the text to white !
  DrawText(8, 8,text)
EndProcedure

Procedure event_gadget()
  Protected canvas = EventGadget() 
  
  If EventType() = #PB_EventType_LeftButtonDown
    StartDrawing(CanvasOutput(canvas))
    draws("event down")
    StopDrawing() 
  EndIf
  
EndProcedure

Procedure event_repaint()
  Debug "#PB_Event_Repaint " + EventWindow( )
EndProcedure

 BindEvent( #PB_Event_Repaint, @event_repaint() );, 100 )
 
If OpenWindow(100, 100, 100, 500, 300, "PureBasic - Image", #PB_Window_SizeGadget)
  
  If CreateImage(0, 255, 255)
    
    StartDrawing(ImageOutput(0))
    
    For k=0 To 255
      FrontColor(RGB(k,0, k))  ; a rainbow, from black to pink
      Line(0, k, 255, 1)
    Next
    
    DrawingMode(#PB_2DDrawing_Transparent)
    FrontColor(RGB(255,255,255)) ; print the text to white !
    DrawText(40, 50, "An image easily created !")
    
    StopDrawing() ; This is absolutely needed when the drawing operations are finished !!! Never forget it !
    
  EndIf
  
  CopyImage(0, 1)
  ResizeImage(1, 100, 100)
  
  GrabImage(0, 2, 100, 60, 150, 40)
  
;   Define canvas = CanvasGadget(#PB_Any, 500-100, 300-40, 90,30 )
;   BindGadgetEvent( canvas, @event_gadget() )
;   StartDrawing(CanvasOutput(canvas))
;   draws("CanvasButton")
;   StopDrawing() ;
  
  
  ;   ResizeWindow( 0, #PB_Ignore, #PB_Ignore, 550, #PB_Ignore)
  ;   ResizeWindow( 0, #PB_Ignore, #PB_Ignore, 500, #PB_Ignore)
  
  Repeat
    Event = WaitWindowEvent()
    
    If event = #PB_Event_Repaint
      Debug "Event_Repaint " + EventWindow( )
      StartDrawing(WindowOutput(EventWindow( )))
      DrawImage(ImageID(0), 20, 10)
      DrawImage(ImageID(1), 320, 80)
      DrawImage(ImageID(2), 320, 200)
      StopDrawing()  
    EndIf
    
  Until Event = #PB_Event_CloseWindow  ; If the user has pressed on the close button
  
EndIf

End   ; All the opened windows are closed automatically by PureBasic
; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 34
; FirstLine = 28
; Folding = --
; EnableXP