OpenWindow(0, 0, 0, 450, 160, "Structured DPI Demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
ContainerGadget(-1, 260,10,200,160)
   ; Добавляем текстовые подписи и трекбары под холстом
   TextGadget(#LabelR, 10,  90, 60, 20, "R: 52")
   TrackBarGadget(#SliderR, 75,  90, 195, 25, 0, 255, #PB_TrackBar_Vertical)
   SetGadgetState(#SliderR, CurrentR)
   
   TextGadget(#LabelG, 10, 140, 60, 20, "G: 152")
   TrackBarGadget(#SliderG, 75, 140, 195, 25, 0, 255, #PB_TrackBar_Vertical)
   SetGadgetState(#SliderG, CurrentG)
   
   TextGadget(#LabelB, 10, 190, 60, 20, "B: 219")
   TrackBarGadget(#SliderB, 75, 190, 195, 25, 0, 255, #PB_TrackBar_Vertical)
   SetGadgetState(#SliderB, CurrentB)
   
   TextGadget(#LabelA, 10, 240, 60, 20, "A: 200")
   TrackBarGadget(#SliderA, 75, 240, 195, 25, 0, 255, #PB_TrackBar_Vertical)
   SetGadgetState(#SliderA, CurrentA)
   CloseGadgetList()
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 1
; EnableXP
; DPIAware