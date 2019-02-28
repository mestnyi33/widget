Structure point
  x.i
  y.i
EndStructure

#size = 50
NewList objects.point()

AddElement(objects())
objects()\x = 10
objects()\y = 10

AddElement(objects())
objects()\x = 50
objects()\y = 200

Define x,y, offset_x, offset_y
Define e
Define drag ;flag


Macro DrawBoxes()
   Box(0,0,500,500,$FFFFFF)
   ForEach objects()
      Box(objects()\x, objects()\y, #size, #size, $0000CC)
   Next 
EndMacro  

OpenWindow(0, 0, 0, 500, 500, "LMB = Place & Move, RMB = Delete", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
CanvasGadget(0, 0, 0, 500, 500)


StartDrawing(CanvasOutput(0))
DrawBoxes()
StopDrawing()

Repeat
   e=WaitWindowEvent()
   If e=#PB_Event_Gadget
      If EventGadget()=0
         x = GetGadgetAttribute(0, #PB_Canvas_MouseX)
         y = GetGadgetAttribute(0, #PB_Canvas_MouseY)
         Select EventType()
               
            Case #PB_EventType_MouseMove 
               If drag=#True
                  StartDrawing(CanvasOutput(0))
                  DrawBoxes()
                  Box(x-offset_x, y-offset_y, #size, #size, $FF9900)
                  StopDrawing()
               EndIf 
               
               
            Case #PB_EventType_LeftButtonDown
               ForEach objects()
                  If x>objects()\x And x<objects()\x+#size And y>objects()\y And y<objects()\y+#size
                     drag = #True
                     offset_x = x - objects()\x 
                     offset_y = y - objects()\y 
                     DeleteElement(objects())
                  EndIf 
               Next 
               
            Case #PB_EventType_LeftButtonUp
               
               AddElement(objects())
               If drag=#True
                  objects()\x = x-offset_x
                  objects()\y = y-offset_y
               Else 
                  objects()\x = x-#size/2
                  objects()\y = y-#size/2
               EndIf 
               drag=#False
               StartDrawing(CanvasOutput(0))
               DrawBoxes()
               StopDrawing()
               
            Case #PB_EventType_RightButtonUp   
               ForEach objects()
                  If x>objects()\x And x<objects()\x+#size And y>objects()\y And y<objects()\y+#size
                     DeleteElement(objects())
                  EndIf 
               Next 
               StartDrawing(CanvasOutput(0))
               DrawBoxes()
               StopDrawing()
               
         EndSelect
      EndIf 
   EndIf 
Until e=#PB_Event_CloseWindow
End
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP