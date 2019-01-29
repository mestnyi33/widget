IncludePath "../../../"
XIncludeFile "widgets.pbi"
UseModule Widget

Global *w

LN=15 ; количесвто итемов 
pos=12

Procedure ReDraw(Canvas)
  If IsGadget(Canvas) And StartDrawing(CanvasOutput(Canvas))
    ;       DrawingMode(#PB_2DDrawing_Default)
    ;       Box(0,0,OutputWidth(),OutputHeight(), winBackColor)
    FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
    
    Draw(*w)
    
    StopDrawing()
  EndIf
EndProcedure

Procedure Canvas_CallBack()
  Protected Canvas.i=EventGadget()
  Protected EventType.i = EventType()
  Protected Repaint, iWidth, iHeight
  Protected Width = GadgetWidth(Canvas)
  Protected Height = GadgetHeight(Canvas)
  Protected mouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
  Protected mouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
  
  Select EventType
    Case #PB_EventType_Repaint : Repaint = 1 
    Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
      Resize(*w, #PB_Ignore, #PB_Ignore, Width, Height)  
      Repaint = 1 
  EndSelect
  
  Repaint | CallBack(*w, EventType, mouseX,mouseY)
  
  If Repaint
    ReDraw(Canvas)
  EndIf
EndProcedure

If OpenWindow(0, 0, 0, 270, 270, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ListViewGadget(0, 10, 10, 250, 120)
  For a = 1 To LN
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetGadgetState(0, pos) ; set (beginning with 0) the tenth item as the active one
  
  CanvasGadget(100, 10, 140, 250, 120, #PB_Canvas_Keyboard )
  BindGadgetEvent(100, @Canvas_CallBack())
  Use(0, 100)
  
  *w=ListView(0, 0, 250, 120, #PB_Flag_GridLines)
  For a = 1 To LN
    AddItem (*w, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  SetState(*w, pos) ; set (beginning with 0) the tenth item as the active one
  Redraw(100)
  
  Debug " get state - " + GetState(*w)
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP