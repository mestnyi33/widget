Macro RectToStr(R) 
  "" + R\left + ", " + R\top + ", " + R\right + ", " + R\bottom 
EndMacro 

Macro DebugX(Message) 
  AddGadgetItem(0, -1, Message) : SetGadgetState(0, CountGadgetItems(0)-1) 
EndMacro 


Procedure WinCallback(hWnd, uMsg, WParam, LParam) 
  Protected *rc.RECT, w, h, dbg$  
  
  If uMsg = #WM_SIZE 
    dbg$ = "#WM_SIZE -- " 
    Select WParam 
      Case #SIZE_MINIMIZED : dbg$ + "Window was minimized " 
      Case #SIZE_RESTORED  : dbg$ + "Window was restored  " 
      Case #SIZE_MAXIMIZED : dbg$ + "Window was maximized " 
    EndSelect 
    w = LParam & $FFFF
    h = (LParam >> 16) & $FFFF
    Debugx(dbg$ + Str(w) + ", " + Str(h)) 
    ResizeGadget(0, #PB_Ignore, #PB_Ignore, w-4, h-4) 

  ElseIf uMsg = #WM_SIZING  : dbg$ = "#WM_SIZING -- " 

    *rc = LParam 

    Select WParam 
      Case #WMSZ_BOTTOM       : dbg$ + "Bottom edge         " 
      Case #WMSZ_BOTTOMLEFT   : dbg$ + "Bottom-left corner  " 
      Case #WMSZ_BOTTOMRIGHT  : dbg$ + "Bottom-right corner " 
      Case #WMSZ_LEFT         : dbg$ + "Left edge           " 
      Case #WMSZ_RIGHT        : dbg$ + "Right edge          " 
      Case #WMSZ_TOP          : dbg$ + "Top edge            " 
      Case #WMSZ_TOPLEFT      : dbg$ + "Top-left corner     " 
      Case #WMSZ_TOPRIGHT     : dbg$ + "Top-right corner    " 
    EndSelect 
    dbg$ + RectToStr(*rc) 
    DebugX(dbg$) 

    ; you can change the *rc\ values here if you need to 
    ; 
    ; MSDN: 
    ; To change the size or position of the drag rectangle, an application must change the members of this structure. 
    ; An application should return TRUE if it processes this message. 

  EndIf 

  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 


If OpenWindow(0, 0, 0, 200, 100, "Messages", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
  StickyWindow(0, 1)  ; don't hide the window behind the IDE :)  

  ListViewGadget(0, 2, 2, 200-4, 100-4, $4000)  ; my debug output list 

  SetWindowCallback(@WinCallback(), 0) ; set the callback

  Repeat 
    Select WaitWindowEvent() 
      Case #PB_Event_CloseWindow 
        Break 
      Case #PB_Event_SizeWindow 
        DebugX("#PB_Event_SizeWindow ") 
    EndSelect 
  ForEver   
EndIf 


; IDE Options = PureBasic 6.04 LTS (Windows - x64)
; CursorPosition = 41
; FirstLine = 10
; Folding = --
; EnableXP