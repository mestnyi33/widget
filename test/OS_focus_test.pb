Procedure CanvasButtonGadget( gadget, x,y,width,height,text.s )
   CanvasGadget(gadget, x,y,width,height, #PB_Canvas_DrawFocus )
   
   If StartDrawing(CanvasOutput(gadget))
      DrawingFont(GetGadgetFont(-1))
      DrawText((DesktopScaledX(width)-TextWidth(text))/2, (DesktopScaledY(height)-TextHeight(text))/2, text)
      StopDrawing()
   EndIf
EndProcedure


If OpenWindow(0, 0, 0, 270, 140, "SetActiveGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   StringGadget(0, 10, 10, 250, 20, "String")
   StringGadget(1, 10, 40, 250, 21, "ComboBox")
   ;
;    CanvasButtonGadget  (0, 10, 10, 250, 20, "String")
;    CanvasButtonGadget(1, 10, 40, 250, 21, "ComboBox")
   
   CanvasButtonGadget  (2, 10,  90, 250, 20, "mouse enter to activate String")
   CanvasButtonGadget  (3, 10, 115, 250, 20, "mouse enter to activate ComboBox")
   
   Repeat
      Event = WaitWindowEvent()
      If Event = #PB_Event_Gadget
         If EventType() =  #PB_EventType_MouseEnter
            Select EventGadget()
               Case 2 : SetActiveGadget(0)   ; Activate StringGadget
               Case 3 : SetActiveGadget(1)   ; Activate ComboBoxGadget
            EndSelect
         EndIf
         
         Select EventType()
            Case #PB_EventType_Focus
               Debug "focus ["+EventGadget() +"]eventgadget ["+ GetActiveGadget() +"]getactivegadget"
               
            Case #PB_EventType_LostFocus
           Debug "lostfocus ["+EventGadget() +"]eventgadget ["+ GetActiveGadget() +"]getactivegadget"
            EndSelect
         
      EndIf
   Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 13
; FirstLine = 3
; Folding = --
; EnableXP
; DPIAware