; https://www.purebasic.fr/english/viewtopic.php?t=82672&sid=617d110a9bad6a98646731cef0460b04

Procedure WndProc(hWnd, uMsg, wParam, lParam)
 result = #PB_ProcessPureBasicEvents 
 Select uMsg   
  Case #WM_DROPFILES
    *dropFiles = wParam
    f$ = Space(#MAX_PATH)
    DragQueryFile_(*dropFiles , 0, f$, #MAX_PATH)
    AddGadgetItem(1,-1,f$)
    DragFinish_(*dropFiles)
  EndSelect
   
  ProcedureReturn result 
EndProcedure

If OpenWindow(0, 0, 0, 600, 400, "Drag & Drop", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)

  EditorGadget(1, 10, 10, 580, 380)
  
  DragAcceptFiles_(WindowID(0), 1)
  SetWindowCallback(@WndProc()) 
  
  Repeat
    Select WaitWindowEvent ()
      Case #PB_Event_CloseWindow
          Quit = 1
    EndSelect
    
  Until Quit = 1
EndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 8
; Folding = -
; EnableXP