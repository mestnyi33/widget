EnableExplicit
Define ww, wh, style, win, canvas, event, quit

ww=800
wh=600
style | #PB_Window_ScreenCentered
style | #PB_Window_SystemMenu
style | #PB_Window_MinimizeGadget

win = OpenWindow(#PB_Any, 50, 100, ww, wh, "", style)
AddKeyboardShortcut(win, #PB_Shortcut_Escape, 10)
canvas = CanvasGadget(#PB_Any, 0, 0, ww, wh, #PB_Canvas_Keyboard)
SetActiveGadget(canvas)

Structure line
  x1.i
  y1.i
  x2.i
  y2.i
EndStructure

Define lining = #False
Define currentLine.line
NewList lines.line()

Procedure thickLineXY (start_x,start_y,end_x,end_y,whatcolor,thickness)
  Protected xyz
  Protected err_x = 0 
  Protected err_y = 0 
  Protected inc_x = 0 
  Protected inc_y = 0
  Protected distance
  Protected delta_x = end_x - start_x;
  Protected delta_y = end_y - start_y;
  
  
  If(delta_x > 0) :inc_x = 1:ElseIf (delta_x = 0) :inc_x = 0: Else :inc_x = -1:EndIf  
  If(delta_y > 0) :inc_y = 1:ElseIf (delta_y = 0) :inc_y = 0: Else :inc_y = -1:EndIf          
  
  delta_x = Abs(delta_x);
  delta_y = Abs(delta_y);
  
  If(delta_x > delta_y) 
    distance = delta_x;
  Else 
    distance = delta_y;
  EndIf  
  
  For  xyz = 0 To  distance+1 Step 1
    
    ; modified to place a circle at the pixel location to get a thick line
    
    ;Plot(start_x,start_y,whatcolor)     
    Circle(start_x,start_y,thickness,whatcolor)     
    
    err_x = err_x + delta_x
    err_y = err_y + delta_y
    
    If (err_x > distance)
      err_x = err_x - distance
      start_x = start_x + inc_x
    EndIf
    
    If (err_y > distance)
      err_y = err_y - distance
      start_y = start_y +inc_y
    EndIf  
    
  Next
  
EndProcedure

Macro line_xy( _x1_, _y1_, _x2_, _y2_, _color_, _thickness_ = 1 )
  If _color_
    VectorSourceColor( _color_ )
  EndIf
  MovePathCursor( _x1_, _y1_ )
  AddPathLine( _x2_, _y2_ )
  StrokePath( _thickness_, #PB_Path_RoundEnd )
  
  ;LineXY( _x1_, _y1_, _x2_, _y2_, _color_ )
EndMacro

Procedure redrawCanvas()
  Shared canvas, lining, currentLine, lines()
  Protected thickness = 2
  
;     ; 2d drawing
;     If StartDrawing(CanvasOutput(canvas))
;       DrawingMode(#PB_2DDrawing_AllChannels)
;       Box(0, 0, OutputWidth(), OutputHeight(), $00ffffff)
;       DrawingMode(#PB_2DDrawing_AlphaBlend)
;       thickLineXY(currentLine\x1, currentLine\y1, currentLine\x2, currentLine\y2, $66660000, thickness)
;       ForEach lines()
;         thickLineXY(lines()\x1, lines()\y1, lines()\x2, lines()\y2, $66000066, thickness)
;       Next
;       StopDrawing()
;     EndIf
;   
  ; vector drawing
  If StartVectorDrawing(CanvasVectorOutput(canvas))
    VectorSourceColor($ffffffff)
    FillVectorOutput()
    
    If lining
      line_xy( currentLine\x1, currentLine\y1, currentLine\x2, currentLine\y2, $66ff0000, thickness )
    EndIf
    
    ;VectorSourceColor($660000ff)
    ForEach lines()
      line_xy( lines()\x1, lines()\y1, lines()\x2, lines()\y2, $660000ff, thickness )
    Next
    
    StopVectorDrawing()
  EndIf
  
EndProcedure

Repeat
  If IsWindow(win) ;{
    Repeat
      event = WaitWindowEvent(100)
      Select event
        Case #PB_Event_CloseWindow
          quit = #True
        Case #PB_Event_Menu
          Select EventMenu()
            Case 10
              quit = #True
          EndSelect
        Case #PB_Event_Gadget
          Select EventGadget()
            Case canvas
              Select EventType()
                Case #PB_EventType_MouseMove
                  If lining
                    currentLine\x2 = GetGadgetAttribute(canvas, #PB_Canvas_MouseX)
                    currentLine\y2 = GetGadgetAttribute(canvas, #PB_Canvas_MouseY)
                    redrawCanvas()
                  EndIf
                Case #PB_EventType_LeftButtonDown
                  If Not lining
                    lining = #True
                    currentLine\x1 = GetGadgetAttribute(canvas, #PB_Canvas_MouseX)
                    currentLine\y1 = GetGadgetAttribute(canvas, #PB_Canvas_MouseY)
                    currentLine\x2 = GetGadgetAttribute(canvas, #PB_Canvas_MouseX)
                    currentLine\y2 = GetGadgetAttribute(canvas, #PB_Canvas_MouseY)
                    redrawCanvas()
                  EndIf
                  ;                 Case #PB_EventType_LeftButtonUp
                  ;                   If lining
                  ;                     AddElement(lines())
                  ; ;                     lines()\x1 = currentLine\x1
                  ; ;                     lines()\y1 = currentLine\y1
                  ; ;                     lines()\x2 = currentLine\x2
                  ; ;                     lines()\y2 = currentLine\y2
                  ;                     lines() = currentLine
                  ;                     lining = #False
                  ;                     redrawCanvas()
                  ;                   EndIf
                Case #PB_EventType_LeftButtonUp
                  If lining
                    AddElement(lines())
                    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                      CopyStructure(currentLine, lines(), line)
                    CompilerElse
                      lines() = currentLine
                    CompilerEndIf
                    lining = #False
                    redrawCanvas()
                  EndIf
              EndSelect
          EndSelect
      EndSelect
    Until Not event
    ;}
  EndIf
  redrawCanvas()
  
Until quit
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ----
; EnableXP