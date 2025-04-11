XIncludeFile "../../../widgets.pbi" 
; commit 1,628 ok

EnableExplicit
UseWidgets( )
test_focus_show = 1
test_focus_set = 1

Define *win0,*win1,*win2, Width=500, Height=400

If Open(0, 100, 200, Width, Height, "demo activate windows", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
   a_init(root())
   
   *win0 = Window(10, 10, 260, 90, "0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), GetText(widget()))
   String(10,10,170,30,"01") : SetClass(widget(), GetText(widget()))
   String(10,50,170,30,"02") : SetClass(widget(), GetText(widget()))
   *win1 = Window(100, 100, 260, 90, "1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), GetText(widget()))
   String(10,10,170,30,"11") : SetClass(widget(), GetText(widget()))
   String(10,50,170,30,"12") : SetClass(widget(), GetText(widget()))
   *win2 = Window(200, 200, 260, 90, "2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) : SetClass(widget(), GetText(widget()))
   String(10,10,170,30,"21") : SetClass(widget(), GetText(widget()))
   String(10,50,170,30,"22") : SetClass(widget(), GetText(widget()))
   
   WaitClose()
EndIf

End  
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 11
; Folding = -
; EnableXP