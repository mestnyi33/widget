;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widgets.pbi"
;XIncludeFile "../../../widget-events.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global i, *w0, *w1, *w2, *w3, *w4, *w5, *w6, *w7, *w8, *w9
  
  widget::Open(0, 10, 10, 390, 390, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
  
  ; first splitter
  *w0 = widget::Tab(0, 0, 0, 0, #__flag_Vertical )
  For i=0 To 3
    widget::AddItem(*w0, -1, "tab_0_"+Str(i))
  Next
  
  *w1 = widget::Tab(0, 0, 0, 0, #__flag_Vertical )
  For i=0 To 10
    widget::AddItem(*w1, -1, "tab_1_"+Str(i))
  Next
  
  *w2 = widget::Splitter(300, 30, 250, 70, *w0, *w1, #PB_Splitter_Separator|#PB_Splitter_Vertical)
  
  ; first splitter
  *w3 = widget::Tab(0, 0, 0, 0, #__flag_Vertical)
  For i=0 To 10
    widget::AddItem(*w3, -1, "tab_2_"+Str(i))
  Next
  
  *w4 = widget::Tab(0, 0, 0, 0, #__flag_Vertical)
  For i=0 To 10
    widget::AddItem(*w4, -1, "tab_3_"+Str(i))
  Next
  
  *w5 = widget::Splitter(30, 110, 250, 70, *w3, *w4, #PB_Splitter_Separator|#PB_Splitter_Vertical)
  
  
  *w6 = widget::Splitter(30, 30, 160, 150, *w2, 0, #PB_Splitter_Separator)
  *w7 = widget::Splitter(200, 30, 160, 150, *w5, 0, #PB_Splitter_Separator)
  widget::SetState(*w6, 250)
  widget::SetState(*w7, 250)
  
   
  *w8 = widget::Tab(30, 210, 50, 150, #__flag_Vertical)
  For i=0 To 10
    widget::AddItem(*w8, -1, "Tab "+Str(i))
  Next
  widget::bar_Tab_SetState(*w8, 6)
  
  *w9 = widget::Panel(110, 210, 250, 150, #__flag_Vertical)
  For i=0 To 10
    widget::AddItem(*w9, -1, "Sub "+Str(i))
    widget::Button(20, 60-3, 30, 30, Str(i))
  Next
  widget::CloseList()
  widget::SetState(*w9, 6)
  
  ;   widget::SetState(*w0, -10)
  ;   widget::SetState(*w1, 250-10)
  ;   widget::SetState(*w3, 250/2)
  ;   widget::SetState(*w4, 10)
  
  widget::bar_Tab_SetState(*w0, -1)
  widget::bar_Tab_SetState(*w1, 9)
  widget::bar_Tab_SetState(*w3, 6)
  widget::bar_Tab_SetState(*w4, 1)
  
  widget::WaitClose( )
  End
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 35
; FirstLine = 31
; Folding = -
; EnableXP