XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  EnableExplicit
  Global Event.i, MyCanvas, *spl1,*spl2
  Global x=100,y=100, width=420, height=420 , focus
  
  If Not OpenWindow(0, 0, 0, width+x*2+20, height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  Define *mdi = MDI(x,y,width, height);, #__flag_autosize)
  ;a_init( *mdi )
  
  Define *g0 = AddItem(*mdi, -1, "form_0")
  
  ; Debug " - test show and size scroll bars - "
  ; Resize(*mdi,#PB_Ignore,#PB_Ignore,307,#PB_Ignore )
  ; Resize(*mdi,#PB_Ignore,#PB_Ignore,#PB_Ignore,231 )
  ; Resize(*mdi,#PB_Ignore,#PB_Ignore,307,231 )
  
  
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
; CursorPosition = 66
; FirstLine = 2
; Folding = -
; EnableXP