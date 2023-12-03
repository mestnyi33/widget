Global Old

Procedure WndProc_Splitter(hWnd, uMsg, wParam, lParam)
  
  If uMsg = #WM_SETCURSOR
    If hWnd <> wParam
      ProcedureReturn 0
    EndIf
  EndIf
  
  ProcedureReturn CallWindowProc_(Old, hWnd, uMsg, wParam, lParam)
EndProcedure

If OpenWindow(0, 0, 0, 230, 180, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  #Button1  = 0
  #Button2  = 1
  #Splitter = 2
  
  ButtonGadget(#Button1, 0, 0, 0, 0, "Button 1") ; No need to specify size or coordinates
  ButtonGadget(#Button2, 0, 0, 0, 0, "Button 2") ; as they will be sized automatically
  SplitterGadget(#Splitter, 5, 5, 220, 120, #Button1, #Button2, #PB_Splitter_Vertical)
  
  TextGadget(3, 10, 135, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
  
  Old = SetWindowLongPtr_(GadgetID(2), #GWLP_WNDPROC, @WndProc_Splitter())
  
  Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP