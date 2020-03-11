Procedure GetCurrentEvent()
    Protected app = CocoaMessage(0,0,"NSApplication sharedApplication")
    If app
        ProcedureReturn CocoaMessage(0,app,"currentEvent")
    EndIf
EndProcedure

Procedure.CGFloat GetWheelDeltaX()
    Protected wheelDeltaX.CGFloat = 0.0
    Protected currentEvent = GetCurrentEvent()
    If currentEvent
        CocoaMessage(@wheelDeltaX,currentEvent,"scrollingDeltaX")
    EndIf
    ProcedureReturn wheelDeltaX
EndProcedure

Procedure.CGFloat GetWheelDeltaY()
    Protected wheelDeltaY.CGFloat = 0.0
    Protected currentEvent = GetCurrentEvent()
    If currentEvent
        CocoaMessage(@wheelDeltaY,currentEvent,"scrollingDeltaY")
    EndIf
    ProcedureReturn wheelDeltaY
EndProcedure

If OpenWindow(0, 0, 0, 700, 400, "ScrollAreaGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ScrollAreaGadget(0, 10, 10, 680, 380, 1000, 1000, 30)
    CanvasGadget  (5, 200, 200, 500, 500)
    ButtonGadget  (1, 10, 10, 230, 30,"Button 1")
    ButtonGadget  (2, 50, 50, 230, 30,"Button 2")
    ButtonGadget  (3, 90, 90, 230, 30,"Button 3")
    CloseGadgetList()
    StartDrawing(CanvasOutput(5))
    Box(0,0,500,500,$FF0000)
    StopDrawing()
    
    Repeat
        Select WaitWindowEvent()
            Case  #PB_Event_CloseWindow
                End
            Case  #PB_Event_Gadget
                Select EventGadget()
                    Case 1
                        MessageRequester("Info","Button 1 was pressed!",#PB_MessageRequester_Ok)
                    Case 2
                        MessageRequester("Info","Button 2 was pressed!",#PB_MessageRequester_Ok)
                    Case 3
                        MessageRequester("Info","Button 3 was pressed!",#PB_MessageRequester_Ok)
                    Case 5
                        If EventType() = #PB_EventType_MouseWheel
                            wheelX.CGFloat = GetWheelDeltaX()
                            wheelY.CGFloat = GetWheelDeltaY()
                            If wheelX
                                SetGadgetAttribute(0, #PB_ScrollArea_X, GetGadgetAttribute(0, #PB_ScrollArea_X) - wheelX)
                            EndIf
                            If wheelY
                                SetGadgetAttribute(0, #PB_ScrollArea_Y, GetGadgetAttribute(0, #PB_ScrollArea_Y) - wheelY)
                            EndIf
                        EndIf
                       
                EndSelect
        EndSelect
    ForEver
EndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ---
; EnableXP