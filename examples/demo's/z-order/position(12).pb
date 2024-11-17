﻿XIncludeFile "../../../-widgets.pbi"
; надо исправить scroll\v draw width

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  EnableExplicit
  Global Event.i, MyCanvas
  Global x=100,y=100, Width=420, Height=420 , focus
  
  If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetCanvasGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  Define *g = window(10,10,200,200, "window", #PB_Window_SystemMenu|#__flag_autosize) : SetClass(widget(), "window")
  
  Define *g0 = Container(10,10,200,200) : SetClass(widget(), "form_0")
  CloseList()
  
  Define *g1 = Container(30,30,200,200) : SetClass(widget(), "form_1")
  Button(10,10,80,30,"button_1_0") : SetClass(widget(), GetText(widget()))
  Button(10,50,80,30,"button_1_1") : SetClass(widget(), GetText(widget()))
  Button(10,90,80,30,"button_1_2") : SetClass(widget(), GetText(widget()))
  CloseList()
  
  Define *g2 = Container(50,50,200,200) : SetClass(widget(), "form_2")
  Button(10,10,80,30,"button_2_0") : SetClass(widget(), GetText(widget()))
  Button(10,50,80,30,"button_2_1") : SetClass(widget(), GetText(widget()))
  Button(10,90,80,30,"button_2_2") : SetClass(widget(), GetText(widget()))
  CloseList()
  
  OpenList(*g0)
  Button(10,10,80,30,"button_0_0") : SetClass(widget(), GetText(widget()))
  Button(10,50,80,30,"button_0_1") : SetClass(widget(), GetText(widget()))
  Button(10,90,80,30,"button_0_2") : SetClass(widget(), GetText(widget()))
  CloseList()
  
  ;SortStructuredList(widget(), #PB_Sort_Ascending, OffsetOf(_s_count\index), TypeOf(_s_count\index))
            
           
;   Resize(*g2, #PB_Ignore, 300, #PB_Ignore, #PB_Ignore)
;   Resize(*g1, 300, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  Debug "---->>"
  ForEach widget()
    Debug "  "+ widget()\class
  Next
  Debug "<<----"
  
  WaitClose( )
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP