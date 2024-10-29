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

size = 60
d=5


Procedure.b Draw_Arrow( x.l, y.l, size.a, direction.a, style.b = 1, Color = $ffffffff )
  ;ProcedureReturn 
  Protected x1.l, y1.l
  
  If Style
    If Style =- 1
      ; ProcedureReturn Arrow( x, y, Size, Direction, Color )
    Else
      
      For x1 = 0 To size
        For y1 = x1 To size-x1 
          If direction = 0 ; left
            Box(x+size/2-x1*Style,y+y1,Style,1, Color)
          EndIf
          If direction = 1 ; up
            Box(x+y1,y+size/2-x1*Style,1,Style, Color)
          EndIf
          If direction = 2 ; right
            Box(x+size/2+x1*Style,y+y1,Style,1, Color)
          EndIf
          If direction = 3 ; down
            Box(x+y1,y+size/2+x1*Style,1,Style, Color)
          EndIf
        Next  
      Next
      
    EndIf
  EndIf
EndProcedure
Procedure.b Draw_ArrowFrame( x.l, y.l, size.a, direction.a, style.b = 1, Color = $ff000000 )
  Protected x1.l, y1.l
  
  If Style
    If Style =- 1
      ; ProcedureReturn Arrow( x, y, Size, Direction, Color )
    Else
      Protected framesize = 4
      
      ;Draw_Arrow( x-framesize, y-framesize, size+framesize*2, direction, style, Color )
      For x1 = -framesize/2 To size ; - framesize
        
        For y1 = x1-framesize To size-x1+framesize
          If direction = 0 ; left
            Box(x+size/2-x1*Style,y+y1,Style,1, Color)
          EndIf
          If direction = 1 ; up
            Box(x+y1,y+size/2-x1*Style,1,Style, Color)
          EndIf
          If direction = 2 ; right
            Box(x+size/2+x1*Style,y+y1,Style,1, Color)
          EndIf
          If direction = 3 ; down
            Box(x+y1,y+size/2+x1*Style,1,Style, Color)
          EndIf
        Next  
      Next
      
    EndIf
  EndIf
EndProcedure


If OpenWindow(0, 0, 0, 400, 400, "2DDrawing Example DPI", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  If CreateImage(0, 400, 400, 24, $BFBFEC) And StartDrawing(ImageOutput(0))
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
    pos = 10
    x=pos
    y=pos+size*2+d
    Draw_ArrowFrame(x,y, size, 0,2)
    Draw_Arrow(x,y, size, 0,2)
    x=pos+size*2+d*2+size*2
    Draw_ArrowFrame(x,y, size, 2,2)
    Draw_Arrow(x,y, size, 2,2)
    
    y=pos
    x=pos+size*2+d
    Draw_ArrowFrame(x,y, size, 1)
    Draw_Arrow(x,y, size, 1)
    y=pos+size*2+d*2+size*2
    Draw_ArrowFrame(x,y, size, 3)
    Draw_Arrow(x,y, size, 3)
    
    StopDrawing() 
    ImageGadget(0, 0, 0, 200, 200, ImageID(0))      
  EndIf
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 41
; FirstLine = 31
; Folding = ---
; EnableXP
; DPIAware