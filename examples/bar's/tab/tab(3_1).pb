XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global i
  Global._s_widget *s_1, *s_2, *s_3, *s_4
  
  widget::Open(OpenWindow(#PB_Any, 10, 10, 850, 250, "TAB-demos", #PB_Window_ScreenCentered | #PB_Window_SystemMenu))
  
 
  
  ; first splitter
  *s_1 = widget::TabBarWidget(300, 30, 250, 40);, 0,250,0)
  AddItem(widget( ), 1, "tab_"+Str(1))
  AddItem(widget( ), 2, "tab_"+Str(2))
  AddItem(widget( ), 3, "tab_"+Str(3))
  AddItem(widget( ), 4, "tab_"+Str(4))
  AddItem(widget( ), 5, "tab_"+Str(5))
  AddItem(widget( ), 6, "tab_"+Str(6))
  AddItem(widget( ), 7, "tab_"+Str(7))
  AddItem(widget( ), 8, "tab_"+Str(8))
  AddItem(widget( ), 9, "tab_"+Str(9))
  AddItem(widget( ), 10, "tab_"+Str(10))
  AddItem(widget( ), 0, "tab_"+Str(0))
  
;   Debug " -- "
;   Debug widget( )\bar\page\pos
;   Debug widget( )\bar\page\end
;   Debug widget( )\bar\percent
;   Debug widget( )\bar\area\end
;   Debug widget( )\bar\thumb\pos
;   Debug widget( )\bar\thumb\len
;   Debug ""
;   
  *s_2 = widget::TabBarWidget(300, 30+50, 250, 40);, 0,250,0)
  For i=0 To 10
    AddItem(widget( ), -1, "tab_"+Str(i))
  Next
  
  ; first splitter
  *s_3 = widget::TabBarWidget(300, 30+100, 250, 40);, 0,250,0)
  For i=0 To 10
    AddItem(widget( ), -1, "tab_"+Str(i))
  Next
  
  *s_4 = widget::TabBarWidget(300, 30+150, 250, 40);, 0,250,0)
  For i=0 To 10
    AddItem(widget( ), -1, "tab_"+Str(i))
  Next
  
  ;SetState(*s_1, -10)
  SetState(*s_2, 9);250)
  SetState(*s_3, 5);250/2)
  SetState(*s_4, 1);10)
  
  Debug "-"
  Debug ""+*s_1\FocusedTabBarWidget( )+" "+*s_1\FocusedTabBarWidget( )\index+" "+*s_1\FocusedTabBarWidget( )\text\string
  Debug ""+*s_2\FocusedTabBarWidget( )+" "+*s_2\FocusedTabBarWidget( )\index
  Debug ""+*s_3\FocusedTabBarWidget( )+" "+*s_3\FocusedTabBarWidget( )\index
  Debug ""+*s_4\FocusedTabBarWidget( )+" "+*s_4\FocusedTabBarWidget( )\index
  Debug "-"
  
  Define event
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
  End
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 4
; Folding = -
; EnableXP