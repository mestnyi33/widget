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
  Global x=100,y=100, width=420, height=420 , focus
  
  Procedure events()
     Debug *mdi\scroll\v\bar\page\pos
  EndProcedure
  
  If Not OpenWindow(0, 0, 0, width+x*2+20, height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  Procedure button_3_events( )
     Static click, state1, state2
     
     If click = 0
        click = 1
        state1 = GetState(*spl1)
        state2 = GetState(*spl2)
        SetState(*spl1, width)
        SetState(*spl2, height)
     Else
        click = 0
        SetState(*spl1, state1)
        SetState(*spl2, state2)
     EndIf
     
  EndProcedure
  
  MyCanvas = GetGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  *mdi = MDI(x,y,width, height);, #__flag_autosize)
  ; a_init( *mdi,1 )
  
  Define *g0 = AddItem(*mdi, -1, "form_0")
  Button(10,10,80,80,"button_0")
  
  Define *g1 = AddItem(*mdi, -1, "form_1")
  Button(10,10,80,80,"button_1")
  
  Define *g2 = AddItem(*mdi, -1, "form_2")
  Button(10,10,80,80,"button_2")
  
  Define *g3 = AddItem(*mdi, -1, "form_3")
  BinD(Button(10,10,80,80,"test"), @button_3_events(), #__event_LeftButtonDown)
  
  ; use root list
  OpenList(Root())
  
  *spl1 = Splitter(x,y,width,height, *mdi, #Null, #PB_Splitter_Vertical)
  *spl2 = Splitter(x,y,width,height, *spl1, #Null);, #__flag_autosize)
  
  SetState(*spl1, width); - 150)
  SetState(*spl2, height); - 150)
  
  Resize(*g3, 300, -150, #PB_Ignore, #PB_Ignore)
  Resize(*g3, 10, #PB_Ignore, #PB_Ignore, #PB_Ignore)
;   mouse( )\buttons = 1
;   Resize(*g2, 110, #PB_Ignore, #PB_Ignore, #PB_Ignore)
;   mouse( )\buttons = 0
;   ;Resize(*g3, #PB_Ignore, 100, #PB_Ignore, #PB_Ignore)
;   Resize(*g1, 30, #PB_Ignore, #PB_Ignore, #PB_Ignore)
;   
  Bind(#PB_All, @events(), #__event_down)
  Bind(#PB_All, @events(), #__event_dragstart)
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 79
; FirstLine = 62
; Folding = -
; EnableXP
; DPIAware