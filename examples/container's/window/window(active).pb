XIncludeFile "../../../widgets.pbi" 

UseWidgets( )
test_focus_show = 1
test_event_focus = 1

Define *win0,*win1,*win2, width=500, height=400

If OpenRoot(0, 100, 200, width, height, "demo activate windows", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
   
   *win0 = WindowWidget(10, 10, 260, 90, "0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
   StringWidget(10,10,170,30,"01")
   StringWidget(10,50,170,30,"02")
   *win1 = WindowWidget(100, 100, 260, 90, "1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget);, *win)
   StringWidget(10,10,170,30,"11")
   StringWidget(10,50,170,30,"12")
   *win2 = WindowWidget(200, 200, 260, 90, "2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget);, *win)
   StringWidget(10,10,170,30,"21")
   StringWidget(10,50,170,30,"22")
   
   WaitCloseRoot()
EndIf

End  
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 11
; Folding = -
; EnableXP