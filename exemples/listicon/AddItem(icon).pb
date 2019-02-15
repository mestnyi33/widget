IncludePath "../../"
XIncludeFile "widgets.pbi"
UseModule Widget

Global *w
LN=1500; количесвто итемов 

; Procedure ReDraw(Canvas)
;   If IsGadget(Canvas) And StartDrawing(CanvasOutput(Canvas))
;     ;       DrawingMode(#PB_2DDrawing_Default)
;     ;       Box(0,0,OutputWidth(),OutputHeight(), winBackColor)
;     FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
;     
;     Draw(*w)
;     
;     StopDrawing()
;   EndIf
; EndProcedure

Procedure Canvas_CallBack()
  Protected Canvas.i=EventGadget()
  Protected EventType.i = EventType()
  Protected Repaint, iWidth, iHeight
  Protected Width = GadgetWidth(Canvas)
  Protected Height = GadgetHeight(Canvas)
  Protected mouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
  Protected mouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
  Protected *w = GetGadgetData(Canvas)
  
  Select EventType
    Case #PB_EventType_Repaint : Repaint = 1 
    Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
      Resize(*w, #PB_Ignore, #PB_Ignore, Width, Height)  
      Repaint = 1 
  EndSelect
  
  Repaint | CallBack(at(*w, mouseX,mouseY), EventType, mouseX,mouseY)
  
  If Repaint
    ReDraw(Canvas)
  EndIf
EndProcedure

If OpenWindow(0, 100, 50, 530, 700, "treeGadget", #PB_Window_SystemMenu)
  CanvasGadget(100, 270, 10, 250, 680, #PB_Canvas_Keyboard )
  BindGadgetEvent(100, @Canvas_CallBack())
  OpenList(0, 100)
  
  *w=listicon(0, 0, 250, 680, "column_0", 200, #PB_Flag_FullSelection)
  
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddItem (*w, -1, "Item "+Str(a), -1);,Random(5)+1)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + CountItems(*w)
  
  Redraw(100)
  
  ListIconGadget(0, 10, 10, 250, 680, "column_0", 200)
  ; HideGadget(0, 1)
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0 );,Random(5)+1)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug Str(ElapsedMilliseconds()-time) + " - add gadget items time count - " + CountGadgetItems(0)
  ; HideGadget(0, 0)
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP