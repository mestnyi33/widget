Procedure BindHScrollDatas()
  SetWindowTitle(0, "ScrollBarGadget (" + GetGadgetState(0) + ")" )
  SetGadgetState   (10,  GetGadgetState(0))
  EndProcedure

  If OpenWindow(0, 0, 0, 400, 400, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
    TextGadget       (2,  10, 25, 350,  30, "ScrollBar Standard  (start = 50, page = 30/100)")
    ScrollBarGadget  (10,  10, 50, 350,  20, 20, 50, 8)
    ScrollBarGadget  (0,  10, 70, 350,  20, 20, 50, 8)
    
    BindGadgetEvent(0, @ BindHScrollDatas())
    
    Repeat 
      Select WaitWindowEvent() 
        Case  #PB_Event_CloseWindow 
          End 
        Case  #PB_Event_Gadget 
          
      EndSelect
    ForEver 
  EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP