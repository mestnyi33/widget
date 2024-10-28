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

size = 30
d=5


Procedure Arrow( x, y, size, direction, mode=1, color = 0 )
  For x1 = 0 To size
    For y1 = x1/mode To size-x1/mode
      If direction = 0 ; left
        Box(x+size/2-x1,y+y1,1,1, color)
      EndIf
      If direction = 2 ; right
        Box(x+size/2+x1,y+y1,1,1, color)
      EndIf
      If direction = 1 ; up
        Box(x+y1,y+size/2-x1,1,1, color)
      EndIf
      If direction = 3 ; down
        Box(x+y1,y+size/2+x1,1,1, color)
      EndIf
    Next  
  Next
EndProcedure

If OpenWindow(0, 0, 0, 400, 400, "2DDrawing Example DPI", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  If CreateImage(0, 200, 200, 24, $FFFFFF) And StartDrawing(ImageOutput(0))
    SetOrigin(size/2,size/2)
    FrontColor($ff0000)
    
;     x=50+d
;     y=50
;     
;     Arrow(x,y, size, 3)
;     
;     x=50
;     y=50+d
;     
;     
;     Arrow(x,y, size, 2)
;     
;     x=50+size+d*2
;     
;     Arrow(x,y, size, 0)
;     
;     x=50+d
;     y=50+size+d*2
;     
;     Arrow(x,y, size, 1)
;     ;     
    
    x=0
    y=size*2+d
    Arrow(x,y, size, 0,2)
    x=size*2+d*2+size*2
    Arrow(x,y, size, 2,2)
    
    y=0
    x=size*2+d
    Arrow(x,y, size, 1)
    y=size*2+d*2+size*2
    Arrow(x,y, size, 3)
   
    StopDrawing() 
    ImageGadget(0, 0, 0, 200, 200, ImageID(0))      
  EndIf
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 41
; FirstLine = 18
; Folding = --
; EnableXP
; DPIAware