XIncludeFile "../../../widgets.pbi"

UseWidgets( )

If OpenWindow(0, 0, 0, 230+230, 200, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  #Button0  = 0
  #Button1  = 1
  #Splitter2 = 2
  #Splitter4 = 4
  
  Open(0, 230,0, 230,200)
  Define *Button0 = Button(0, 0, 0, 0, "Button 0") ; No need to specify size or coordinates
  Define *Button1 = Button(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  Define *Splitter2 = Splitter(5, 75, 220, 120, *Button0, *Button1, #PB_Splitter_Separator)
  
  SetAttribute(*Splitter2, #PB_Splitter_FirstGadget, *Button1)
  SetAttribute(*Splitter2, #PB_Splitter_SecondGadget, *Button0)
  SetState(*Splitter2, 30)
  
  ButtonGadget(#Button0, 0, 0, 0, 0, "Button 0") ; No need to specify size or coordinates
  ButtonGadget(#Button1, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  SplitterGadget(#Splitter2, 5, 75, 220, 120, #Button0, #Button1, #PB_Splitter_Separator)
  
  SetGadgetAttribute(#Splitter2, #PB_Splitter_FirstGadget, #Button1)
  SetGadgetAttribute(#Splitter2, #PB_Splitter_SecondGadget, #Button0)
  SetGadgetState(#Splitter2, 30)
  
  WaitClose( )
EndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 14
; Folding = -
; EnableXP
; DPIAware