;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widgets.pbi"



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global i, *w0._S_WIDGET, *w1, *w2, *w3, *w4, *w5, *w6, *w7, *w8, *w9
  
  widget::OpenRootWidget(0, 10, 10, 850, 210, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  
  ; first splitter
  *w0 = widget::TabBarWidget(0, 0, 0, 0)
  For i=0 To 3
   widget::AddItem(*w0, -1, "tab_"+Str(i))
  Next
;   
   widget::SplitterWidget(300, 30, 300, 70, *w0, -1, #PB_Splitter_Vertical)
   
;    *w1 = widget::TabBarWidget(0, 0, 0, 0)
;   For i=0 To 10
;     widget::AddItem(*w1, -1, "tab_"+Str(i))
;   Next
;   
;   widget::SplitterWidget(300, 110, 300, 70, *w1, -1, #PB_Splitter_Vertical)
   
  ;  widget::bar_Tab_SetState(*w0, -1)
;    Debug "max "+*w0\bar\max
;  *w0\bar\page\pos = 165;*w0\bar\max
;   
   widget::bar_Tab_SetState(*w0, 9)
;   widget::bar_Tab_SetState(*w1, 6)
;   widget::bar_Tab_SetState(*w1, 1)
  
  widget::WaitClose( )
  End
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 32
; FirstLine = 12
; Folding = -
; EnableXP