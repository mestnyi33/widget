;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widgets.pbi"



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global i, *w0._S_WIDGET, *w1, *w2, *w3, *w4, *w5, *w6, *w7, *w8, *w9
  
  widget::OpenRoot(0, 10, 10, 850, 210, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  
  ; first splitter
  *w0 = widget::TabBarWidget(0, 0, 0, 0)
  For i=0 To 3
    widget::AddItem(*w0, -1, "tab_"+Str(i))
  Next
  
  *w1 = widget::TabBarWidget(0, 0, 0, 0)
  For i=0 To 10
    widget::AddItem(*w1, -1, "tab_"+Str(i))
  Next
  
  *w2 = widget::SplitterWidget(300, 30, 250, 70, *w0, *w1, #PB_Splitter_Separator)
  
  ; first splitter
  *w3 = widget::TabBarWidget(0, 0, 0, 0)
  For i=0 To 10
    widget::AddItem(*w3, -1, "tab_rrrrrrrr"+Str(i))
  Next
  
  *w4 = widget::TabBarWidget(0, 0, 0, 0)
  For i=0 To 10
    widget::AddItem(*w4, -1, "tab_"+Str(i))
  Next
  
  *w5 = widget::SplitterWidget(30, 110, 250, 70, *w3, *w4, #PB_Splitter_Separator)
  
  
  *w6 = widget::SplitterWidget(30, 30, 250, 70, *w2, 0, #PB_Splitter_Separator|#PB_Splitter_Vertical)
  *w7 = widget::SplitterWidget(30, 110, 250, 70, *w5, 0, #PB_Splitter_Separator|#PB_Splitter_Vertical)
  widget::SetWidgetState(*w6, 250)
  widget::SetWidgetState(*w7, 250)
  
   
  *w8 = widget::TabBarWidget(300, 30, 250, 30)
  For i=0 To 10
    widget::AddItem(*w8, -1, "Tab "+Str(i))
  Next
  widget::bar_Tab_SetWidgetState(*w8, 6)
  
  *w9 = widget::PanelWidget(300, 70, 250, 110)
  For i=0 To 10
    widget::AddItem(*w9, -1, "Sub "+Str(i))
    widget::ButtonWidget(110-3, 5, 30, 30, Str(i))
  Next
  widget::CloseWidgetList()
  widget::SetWidgetState(*w9, 6)
  
  ;   widget::SetWidgetState(*w0, -10)
  ;   widget::SetWidgetState(*w1, 250-10)
  ;   widget::SetWidgetState(*w3, 250/2)
  ;   widget::SetWidgetState(*w4, 10)
  
  widget::bar_Tab_SetWidgetState(*w0, -1)
  *w0\bar\page\pos = *w0\bar\max
  
  widget::bar_Tab_SetWidgetState(*w1, 9)
  widget::bar_Tab_SetWidgetState(*w3, 6)
  widget::bar_Tab_SetWidgetState(*w4, 1)
  
  widget::WaitClose( )
  End
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 11
; FirstLine = 7
; Folding = -
; EnableXP