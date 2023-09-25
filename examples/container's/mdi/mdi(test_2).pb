XIncludeFile "../../../widgets3.pbi"

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
  Uselib(widget)
  
  EnableExplicit
  Global Event.i, MyCanvas, *spl1,*spl2
  Global x=100,y=100, width=420, height=420 , focus
  
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
  
  Define *mdi = MDI(x,y,width, height);, #__flag_autosize)
  ; a_init( *mdi )
  
  Define *g0 = AddItem(*mdi, -1, "form_0")
;   Button(10,10,80,80,"button_0")
;   
;   Define *g1 = AddItem(*mdi, -1, "form_1")
;   Button(10,10,80,80,"button_1")
;   
;   Define *g2 = AddItem(*mdi, -1, "form_2")
;   Button(10,10,80,80,"button_2")
;   
;   Define *g3 = AddItem(*mdi, -1, "form_3")
;   BinD(Button(10,10,80,80,"button_3"), @button_3_events(), #__event_LeftButtonDown)
  
;   ; use root list
;   OpenList(Root())
  
;   *spl1 = Splitter(x,y,width,height, *mdi, #Null, #PB_Splitter_Vertical)
;   *spl2 = Splitter(x,y,width,height, *spl1, #Null);, #__flag_autosize)
;   
;   SetState(*spl1, width - 150)
;   SetState(*spl2, height - 150)
  
  ; test
  Debug " ----- test -----"
  ;Resize(*g0,#PB_Ignore,#PB_Ignore,242,#PB_Ignore )
  ;Resize(*g0,#PB_Ignore,#PB_Ignore,243,#PB_Ignore )
  ;Resize(*g0,#PB_Ignore,#PB_Ignore,#PB_Ignore,202 )
  ;Resize(*g0,#PB_Ignore,#PB_Ignore,#PB_Ignore,203 )
  ;Resize(*mdi,#PB_Ignore,#PB_Ignore,#PB_Ignore,270 )
  ;Resize(*mdi,#PB_Ignore,#PB_Ignore,270,270 )
  ; widgets2
;   resize - Root 0 0 620 620
;   resize - MDI 100 100 420 420
;   resize - MDI-0-vertical-v 494 110 16 388
;   resize - MDI-0-horizontal-h 110 494 388 16
;   resize - Window 110 110 288 212
;   resize - MDI-0-horizontal-h 110 494 400 16
;   resize - MDI-0-vertical-v 494 110 16 400
;   ----- test -----
;   resize - MDI 100 100 270 270
;   resize - MDI-0-vertical-v 344 110 16 238
;   resize - MDI-0-horizontal-h 110 344 238 16
;   Draw - Root
;   reClip - Root
;   Draw - MDI
;   reClip - MDI
;   Draw scrolbar MDI-0-vertical-v 344 110 16 238
;   Draw scrolbar MDI-0-horizontal-h 110 344 238 16
;   Draw - Window
;   reClip - Window
;   
; widgets3
;   resize - Root 0 0 620 620
;   resize - MDI 100 100 420 420
;   resize - MDI-0-vertical-v 494 110 16 400
;   resize - MDI-0-horizontal-h 110 494 400 16
;   resize - Window 110 110 288 212
;   ----- test -----
;   resize - MDI 100 100 270 270
;   resize - MDI-0-vertical-v 344 110 16 238
;   resize - MDI-0-horizontal-h 110 344 238 16
;   Draw - Root
;   reClip - Root
;   Draw - MDI
;   reClip - MDI
;   Draw scrolbar MDI-0-vertical-v 344 110 16 238
;   Draw scrolbar MDI-0-horizontal-h 110 344 238 16
;   Draw - Window
;   reClip - Window
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 81
; FirstLine = 58
; Folding = -
; EnableXP