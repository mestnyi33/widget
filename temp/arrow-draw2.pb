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
    For y1 = x1 To size-x1
      If direction = 0 ; left
        Box(x+size/2-x1*mode,y+y1,mode,1, color)
      EndIf
      If direction = 2 ; right
        Box(x+size/2+x1*mode,y+y1,mode,1, color)
      EndIf
      If direction = 1 ; up
        Box(x+y1,y+size/2-x1*mode,1,mode, color)
      EndIf
      If direction = 3 ; down
        Box(x+y1,y+size/2+x1*mode,1,mode, color)
      EndIf
    Next  
  Next
EndProcedure

If OpenWindow(0, 0, 0, 400, 400, "2DDrawing Example DPI", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  If CreateImage(0, 200, 200, 24, $FFFFFF) And StartDrawing(ImageOutput(0))
    SetOrigin(size/2,size/2)
    FrontColor($ff0000)
    
x=0
    y=size*2+d
    Arrow(x,y, size+size/2, 0)
    x=size*2+d*2+size*2
    Arrow(x,y, size+size/2, 2)
    
    y=0
    x=size*2+d
    Arrow(x,y, size, 1,2)
    y=size*2+d*2;+size*2
    Arrow(x,y, size, 3,4)
   
   
    StopDrawing() 
    ImageGadget(0, 0, 0, 200, 200, ImageID(0))      
  EndIf
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 31
; FirstLine = 27
; Folding = --
; EnableXP
; DPIAware