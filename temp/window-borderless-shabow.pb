Global DWMEnabled

;\\
Procedure WndCallback(hWnd, Msg, wParam, lParam)
  Protected Result = #PB_ProcessPureBasicEvents, *minmaxinfo.MINMAXINFO, CXSIZEFRAME, CYSIZEFRAME, CYCAPTION, *nccalcsize_params.NCCALCSIZE_PARAMS, WorkAreaRect.RECT, *WindowRect.RECT, WindowRect.RECT, WindowWidth, WindowHeight, MouseX, MouseY, IsCaption, IsTop, IsBottom, IsLeft, IsRight
  
  Select Msg
    
    Case #WM_GETMINMAXINFO
      
      Result = #False
      
      *minmaxinfo = lParam
      *minmaxinfo\ptMinTrackSize\x =0;GetSystemMetrics_(#SM_CXMINTRACK)
      *minmaxinfo\ptMinTrackSize\y = 0;BorderHeight * 2 + TitleBarHeight + 1
      *minmaxinfo\ptMaxSize\y=0
      
    Case #WM_SIZE
      Protected lpRect.rect
      GetWindowRect_(hWnd, @lpRect)
      lpRect\bottom-29
      
      sx = lParam; //ширина
      sy = lParam&16; //высота
      Debug ""+sx +""+ sy +" "+Str(lpRect\right-lpRect\left) +" "+Str(lpRect\bottom-lpRect\top)
     ; SetWindowPos_(hWnd, 0, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOZORDER|#SWP_NOCOPYBITS)
        ; SetWindowPos_(hWnd, 0, 0, 0, lpRect\right-lpRect\left-6, lpRect\bottom-lpRect\top-29, #SWP_NOMOVE|#SWP_NOZORDER|#SWP_NOCOPYBITS)
           
    Case #WM_NCCALCSIZE
      
      Result = #False
      
      If wParam = #True
        
        CXSIZEFRAME = GetSystemMetrics_(#SM_CXSIZEFRAME)
        CYSIZEFRAME = GetSystemMetrics_(#SM_CYSIZEFRAME)
        CYCAPTION = GetSystemMetrics_(#SM_CYCAPTION)
        
        *nccalcsize_params = lParam
        *nccalcsize_params\rgrc[0]\left - CXSIZEFRAME
        *nccalcsize_params\rgrc[0]\top - CYCAPTION - CYSIZEFRAME
        *nccalcsize_params\rgrc[0]\right + CXSIZEFRAME
        *nccalcsize_params\rgrc[0]\bottom + CYSIZEFRAME-50
        
        ;ProcedureReturn #PB_ProcessPureBasicEvents
      EndIf
        Case #WM_CREATE:
      
;     Case #WM_NCCALCSIZE
;       If wParam
;         SetWindowLong_(hwnd, #DWL_MSGRESULT, 0);
;         ProcedureReturn 1
;       EndIf
;       ProcedureReturn 0
      
  EndSelect
  
  ProcedureReturn Result
EndProcedure

;\\
hwnd = OpenWindow(0, 0, 0, 0, 0, "", #PB_Window_BorderLess)
ButtonGadget(2,0,0,320,20,"button")
SetWindowCallback(@WndCallback(), 0)

;\\
Define  margins.RECT 
SetRect_(@margins.RECT, 0, 0, 1, 0)
If OpenLibrary(0, "dwmapi.dll")
  CallFunction(0, "DwmExtendFrameIntoClientArea", WindowID(0), @margins)
  CallFunction(0, "DwmIsCompositionEnabled", @DWMEnabled)
  If DWMEnabled=0
    MessageRequester("Info", "Desktop composition is disabled! Sorry, no shadow...")
    SetWindowTheme_(WindowID(0), "", "")
  EndIf
  CloseLibrary(0)
EndIf
SetWindowLongPtr_(hwnd, #GWL_STYLE, GetWindowLongPtr_(hwnd, #GWL_STYLE )|#WS_CAPTION );
SetWindowPos_(hwnd, 0, 0, 0, 0, 0, #SWP_NOZORDER | #SWP_NOOWNERZORDER | #SWP_NOMOVE | #SWP_NOSIZE | #SWP_FRAMECHANGED);

;\\
ResizeWindow(0, 300, 300, 320, 20)

While WaitWindowEvent() <> #PB_Event_CloseWindow : Wend

; IDE Options = PureBasic 5.72 (Windows - x64)
; Folding = -
; EnableXP