XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  EnableExplicit
  Global Event.i, MyCanvas
  Global x=100,y=100, Width=420, Height=420 , focus
  
  If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  Define *mdi = MDI(x,y,Width, height);, #__flag_autosize)
  
  Define *g0 = AddItem(*mdi, -1, "form_0")
  Button(10,10,80,80,"button_0")
  
  Define *g1 = AddItem(*mdi, -1, "form_1")
  Button(10,Height(*g1, #__c_inner)-80-10,80,80,"button_1")
  
  Define *g2 = AddItem(*mdi, -1, "form_2")
  Button(Width(*g2, #__c_inner)-80-10,10,80,80,"button_2")
  

  Resize(*g1, X(*g0, #__c_container) + Width(*g0, #__c_frame) + 5, -30, #PB_Ignore, #PB_Ignore)
  Resize(*g2, -100, Y(*g0, #__c_container) + Height(*g0, #__c_frame) + 5, #PB_Ignore, #PB_Ignore)
    
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP