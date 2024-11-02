XIncludeFile "../../../widgets.pbi" 

Uselib(widget)
test_focus_show = 1
test_event_focus = 1

Define *win0,*win1,*win2, width=500, height=400

If Open(0, 100, 200, width, height, "demo activate windows", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
   
   *win0 = Window(10, 10, 260, 90, "0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
   string(10,10,170,30,"01")
   string(10,50,170,30,"02")
   *win1 = Window(100, 100, 260, 90, "1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget);, *win)
   string(10,10,170,30,"11")
   string(10,50,170,30,"12")
   *win2 = Window(200, 200, 260, 90, "2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget);, *win)
   string(10,10,170,30,"21")
   string(10,50,170,30,"22")
   
   WaitClose()
EndIf

End  
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 11
; Folding = -
; EnableXP