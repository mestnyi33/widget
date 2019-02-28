Structure add
  x.i
  y.i
  color.i
EndStructure

#size = 50
NewList objects.add()

AddElement(objects())
objects()\x = 10
objects()\y = 10
objects()\color = $0000CC

AddElement(objects())
objects()\x = 50
objects()\y = 200
objects()\color = $0000CC

Define x,y, offset_x, offset_y
Define e
Define drag ;flag


Macro DrawBoxes()
   Box(0,0,500,500,$FFFFFF)
   ForEach objects()
      Box(objects()\x, objects()\y, #size, #size, objects()\color)
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
               If drag
                  StartDrawing(CanvasOutput(0))
                  ChangeCurrentElement(objects(), drag)
                  objects()\x = x-offset_x
                  objects()\y = y-offset_y
                  objects()\color = $FF9900
                  DrawBoxes()
                  StopDrawing()
               EndIf 
               
               
            Case #PB_EventType_LeftButtonDown
               ForEach objects()
                  If x>objects()\x And x<objects()\x+#size And y>objects()\y And y<objects()\y+#size
                     drag = @objects()
                     offset_x = x - objects()\x 
                     offset_y = y - objects()\y 
                    ; DeleteElement(objects())
                  EndIf 
               Next 
               
            Case #PB_EventType_LeftButtonUp
               
              If drag
                ChangeCurrentElement(objects(), drag)
                objects()\color = $0000CC
                
                drag=#False
              Else 
                AddElement(objects())
                objects()\x = x-#size/2
                objects()\y = y-#size/2
                objects()\color = $0000CC
              EndIf 
              
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