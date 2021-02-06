XIncludeFile "../../../widgets-bar.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global i, s_0, s_1, s_2, s_3, s_4, s_5
  
  Procedure resize_window_0()
    Protected width = WindowWidth(EventWindow())
    ; ResizeGadget(GetGadget(Root()), #PB_Ignore, #PB_Ignore, width, #PB_Ignore)
;     ResizeGadget(3, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
;     ResizeGadget(6, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
    ResizeGadget(7, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
    
;     Resize(s_0, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
;     Resize(s_1, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
    Resize(s_2, #PB_Ignore, #PB_Ignore, width - 250, #PB_Ignore)
  EndProcedure
  
  OpenWindow(0, 10, 10, 850, 250, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  BindEvent(#PB_Event_SizeWindow, @resize_window_0())
  
  widget::Open(0);, 0, 0, 510, 340)
  
  ; first splitter
  s_0 = widget::Tab(300, 30, 250, 40, 0,250,0)
  For i=0 To 10
    AddItem(widget( ), -1, "tab_"+Str(i))
  Next
  
;   Debug " -- "
;   Debug widget( )\bar\page\pos
;   Debug widget( )\bar\page\end
;   Debug widget( )\bar\percent
;   Debug widget( )\bar\area\end
;   Debug widget( )\bar\thumb\pos
;   Debug widget( )\bar\thumb\len
;   Debug ""
;   
  s_1 = widget::Tab(300, 30+50, 250, 40, 0,250,0)
  For i=0 To 10
    AddItem(widget( ), -1, "tab_"+Str(i))
  Next
  
  ; first splitter
  s_3 = widget::Tab(300, 30+100, 250, 40, 0,250,0)
  For i=0 To 10
    AddItem(widget( ), -1, "tab_"+Str(i))
  Next
  
  s_4 = widget::Tab(300, 30+150, 250, 40, 0,250,0)
  For i=0 To 10
    AddItem(widget( ), -1, "tab_"+Str(i))
  Next
  
  SetState(s_0, -10)
  SetState(s_1, 250)
  SetState(s_3, 250/2)
  SetState(s_4, 10)
  
     
  Define event
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
  End
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP