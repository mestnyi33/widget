XIncludeFile "../../../widgets.pbi" 

Uselib(widget)

Define *win, width=500, height=400

If Open(OpenWindow(#PB_Any, 100, 200, width, height, "demo activate windows", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))

  *win = Window(10, 10, 260, 90, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  string(10,10,170,30,"1")
    string(10,50,170,30,"4")
    *win = Window(10, 10, 260, 90, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget, *win)
  string(10,10,170,30,"1")
    string(10,50,170,30,"4")
    *win = Window(10, 10, 260, 90, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget, *win)
  string(10,10,170,30,"1")
    string(10,50,170,30,"4")
    
  ; OpenList( root( ) )
  
  *win = Window(290, 10, 190, 90, "110", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  string(10,10,170,30,"1")
    string(10,50,170,30,"4")
    *win = Window(10, 10, 190, 90, "120", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget, *win)
  string(10,10,170,30,"1")
    string(10,50,170,30,"4")
    *win = Window(10, 10, 190, 90, "130", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget, *win)
  string(10,10,170,30,"1")
    string(10,50,170,30,"4")
    
  WaitClose()
EndIf

End  
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP