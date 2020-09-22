XIncludeFile "../../widgets.pbi"
; надо исправить перемещение детей с помощью скроллбара

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  EnableExplicit
  Global Event.i, MyCanvas
  Global x=100,y=100, width=420, height=420 , focus
  
  If Not OpenWindow(0, 0, 0, width+x*2+20, height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  Define *mdi = MDI(x,y,width, height);, #__flag_autosize)
  
  Define *g0 = AddItem(*mdi, -1, "form_0")
  Button(10,10,80,80,"button_0")
  
  Define *g1 = AddItem(*mdi, -1, "form_1")
  Button(10,10,80,80,"button_1")
  
  Define *g2 = AddItem(*mdi, -1, "form_2")
  Button(10,10,80,80,"button_2")
  
  ; use root list
  OpenList(Root())
  ;;CloseList()
  
  Define *spl1 = Splitter(x,y,width,height, *mdi, #Null, #PB_Splitter_Vertical)
  Define *spl2 = Splitter(x,y,width,height, *spl1, #Null);, #__flag_autosize)
  
  SetState(*spl1, width - 150)
  SetState(*spl2, height - 150)
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP