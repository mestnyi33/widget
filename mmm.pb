EnableExplicit

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
  Structure Point : x.i : y.i : EndStructure
CompilerEndIf

Structure Box
  x.i : y.i
  w.i : h.i
  handle.Point
EndStructure

Global currentPoint.Point, lastPoint.Point, resize

Global *b.Box = AllocateStructure(Box)
With *b
  \x = 200 : \y = 150
  \w = 100 : \h = 125
  \handle\x = \x + (\w / 2)
  \handle\y = \y - 3
EndWith

Procedure DrawCanvas()
  If StartDrawing(CanvasOutput(0))
    Box(0, 0, OutputWidth(), OutputHeight(), RGB(0, 0, 0))
    Box(*b\x, *b\y, *b\w, *b\h, RGB(0, 0, 255))
    Box(*b\handle\x, *b\handle\y, 3, 3, RGB(255, 255, 255))
    DrawingMode(#PB_2DDrawing_Transparent)
    DrawText(50, 50, "Height: " + Str(*b\h), RGB(255, 255, 255))
    StopDrawing()
  EndIf
EndProcedure

Procedure OnCanvasEvents()
  Protected offset.Point, newY, newH
  
  Select EventType()
    Case #PB_EventType_MouseMove
      currentPoint\x = GetGadgetAttribute(0, #PB_Canvas_MouseX)
      currentPoint\y = GetGadgetAttribute(0, #PB_Canvas_MouseY)
      
      If resize & GetGadgetAttribute(0, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton
        offset\y = currentPoint\y - lastPoint\y
        
        newY = *b\y : newH = *b\h
        newY + offset\y
        newH - offset\y
        
        If newH > 0
          *b\y = newY
          *b\h = newH
          *b\handle\y = *b\y - 3
        EndIf
        
        DrawCanvas()
      Else
        If Not resize And (currentPoint\x >= *b\handle\x And currentPoint\x < *b\handle\x + 3 And
           currentPoint\y >= *b\handle\y And currentPoint\y < *b\handle\y + 3)
            resize = Bool(SetGadgetAttribute(0, #PB_Canvas_Cursor, #PB_Cursor_UpDown))
          Else
            resize = 0
          SetGadgetAttribute(0, #PB_Canvas_Cursor, #PB_Cursor_Default)
        EndIf
      EndIf
      
      lastPoint\x = currentPoint\x ; GetGadgetAttribute(0, #PB_Canvas_MouseX)
      lastPoint\y = currentPoint\y ; GetGadgetAttribute(0, #PB_Canvas_MouseY)
    
    Case #PB_EventType_LeftButtonUp
      resize = 0
      SetGadgetAttribute(0, #PB_Canvas_Cursor, #PB_Cursor_Default)
      
    Case #PB_EventType_KeyDown
      Select GetGadgetAttribute(0, #PB_Canvas_Key)
        Case #PB_Shortcut_Escape : End
      EndSelect
      
      DrawCanvas()
  EndSelect
EndProcedure

If OpenWindow(0, 0, 0, 640, 480, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CanvasGadget(0, 0, 0, 640, 480, #PB_Canvas_Keyboard)
  DrawCanvas()
  SetActiveGadget(0)
  BindGadgetEvent(0, @OnCanvasEvents(), #PB_All)
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---
; EnableXP