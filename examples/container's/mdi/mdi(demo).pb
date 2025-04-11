XIncludeFile "../../../widgets.pbi"

; #PB_MDI_Arrange
; #PB_MDI_AutoSize
; #PB_MDI_BorderLess
; #PB_MDI_Cascade
; #PB_MDI_Hide
; #PB_MDI_ItemHeight
; #PB_MDI_ItemWidth
; #PB_MDI_Maximize
; #PB_MDI_Minimize
; #PB_MDI_Next
; #PB_MDI_Normal
; #PB_MDI_NoScrollBars
; #PB_MDI_Previous
; #PB_MDI_Show
; #PB_MDI_SizedItem
; #PB_MDI_TileHorizontally
; #PB_MDI_TileVertically

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  EnableExplicit
  Global Event.i, MyCanvas, *mdi._s_widget, *spl1,*spl2
  Global X=100,Y=100, Width=420, Height=420 , focus
  test_focus_set = 1
  
  Procedure all_events()
     Debug *mdi\scroll\v\bar\page\pos
  EndProcedure
  
  If Not OpenWindow(0, 0, 0, Width+X*2+20, Height+Y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  Procedure button_3_events( )
     Static click, state1, state2
     
     If click = 0
        click = 1
        state1 = GetState(*spl1)
        state2 = GetState(*spl2)
        SetState(*spl1, Width)
        SetState(*spl2, Height)
     Else
        click = 0
        SetState(*spl1, state1)
        SetState(*spl2, state2)
     EndIf
     
  EndProcedure
  
  MyCanvas = GetCanvasGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  *mdi = MDI(X,Y,Width, Height);, #__flag_autosize)
  ; a_init( *mdi,1 )
  
  Define *g0 = AddItem(*mdi, -1, "form_0")
  Button(10,10,80,80,"button_0")
  
  Define *g1 = AddItem(*mdi, -1, "form_1")
  Button(10,10,80,80,"button_1")
  
  Define *g2 = AddItem(*mdi, -1, "form_2")
  Button(10,10,80,80,"button_2")
  
  Define *g3 = AddItem(*mdi, -1, "form_3")
  Bind(Button(10,10,80,80,"test"), @button_3_events(), #__event_LeftDown)
  
  ; use root list
  OpenList(root())
  
  *spl1 = Splitter(X,Y,Width,Height, *mdi, #Null, #PB_Splitter_Vertical)
  *spl2 = Splitter(X,Y,Width,Height, *spl1, #Null);, #__flag_autosize)
  
  SetState(*spl1, Width); - 150)
  SetState(*spl2, Height); - 150)
  
  Resize(*g3, 300, -150, #PB_Ignore, #PB_Ignore)
  Resize(*g3, 10, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  
  Bind(#PB_All, @all_events(), #__event_down)
  Bind(#PB_All, @all_events(), #__event_dragstart)
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 27
; FirstLine = 9
; Folding = -
; EnableXP
; DPIAware