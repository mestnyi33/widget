

;  resize - MDI 10 10 160 95
;  resize - MDI-0-vertical-v 144 20 16 63
;  resize - MDI-0-horizontal-h 20 79 128 16
; 
;  resize - Window 20 20 288 212
;   --- area_resize MDI 124 59
;   --- mdi_resize MDI 124 59
;  resize - Window 24 48 288 212
;   --- mdi_resize MDI 124 59
;   Draw - MDI 124 59
;    reClip - MDI 620 620
;   Draw - Window 280 180
;    reClip - Window 124 59
;   Draw - Window 280 180
;   reClip - Window 124 59
;------------------------------------------
;  resize - MDI 10 10 160 95
;  resize - MDI-0-vertical-v 144 20 16 63
;  resize - MDI-0-horizontal-h 20 79 128 16
;   --- area_resize MDI 124 59
;  resize - MDI-0-horizontal-h 20 79 140 16
;  resize - MDI-0-vertical-v 144 20 16 75
;   --- mdi_resize MDI 140 75
; 
;  resize - Window 20 20 288 212
;  resize - MDI-0-horizontal-h 20 79 128 16
;  resize - MDI-0-vertical-v 144 20 16 63
;   --- mdi_resize MDI 124 59
;  resize - Window 24 48 288 212
;   --- mdi_resize MDI 124 59
;   Draw - MDI 124 59
;    reClip - MDI 620 620
;   Draw - Window 280 180
;    reClip - Window 124 59
;   Draw - Window 280 180
;   reClip - Window 124 59

 XIncludeFile "../../../widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  EnableExplicit
  Global Event.i, MyCanvas, *spl1,*spl2
  Global x=100,y=100, width=420, height=420 , focus
  
  If Not OpenWindow(0, 0, 0, width+x*2+20, height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetCanvasGadget(OpenRoot(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
   a_init( root(),0 )
  
  ;Define *mdi = MDIWidget(0,0,0,0,#__flag_autosize)
  ;Define *mdi = MDIWidget(x,y,width, height)
  Define *mdi = MDIWidget(100, 300, 160,95) 
  ; 
  Debug " * "+ WidgetWidth(*mdi, #__c_inner)+" "+ WidgetHeight(*mdi, #__c_inner)
  
  ; 
  ; a_init( *mdi )
  
  ; add childrens to mdi gadget
  Define *g0 = AddItem(*mdi, -1, "form_0")
  ;Define *g1 = AddItem(*mdi, -1, "form_1")
  
  
;   Debug ""
;   ResizeWidget(*mdi,15,15,#PB_Ignore,#PB_Ignore )
;   ResizeWidget(*mdi,25,#PB_Ignore,#PB_Ignore,#PB_Ignore )
;   ResizeWidget(*mdi,#PB_Ignore,35,#PB_Ignore,#PB_Ignore )
;   Debug ""
;   ResizeWidget(*mdi,#PB_Ignore,#PB_Ignore,150,150 )
;   ResizeWidget(*mdi,#PB_Ignore,#PB_Ignore,250,#PB_Ignore )
 ; ResizeWidget(*mdi,#PB_Ignore,#PB_Ignore,#PB_Ignore,350 )
  
;   
;   ; Debug " - test parent - mdi show and size scroll bars - "
;   ; ResizeWidget(*mdi,#PB_Ignore,#PB_Ignore,308,232 )
;   ; ResizeWidget(*mdi,#PB_Ignore,#PB_Ignore,307,#PB_Ignore )
;   ; ResizeWidget(*mdi,#PB_Ignore,#PB_Ignore,#PB_Ignore,231 )
;   ; ResizeWidget(*mdi,#PB_Ignore,#PB_Ignore,307,231 )
;   
;   ; Debug " - test child - mdi show and size scroll bars - "
;   ; ResizeWidget(*g0,#PB_Ignore,#PB_Ignore,392,368 )
;   ; ResizeWidget(*g0,113,#PB_Ignore,#PB_Ignore,#PB_Ignore )
;   ; ResizeWidget(*g0,#PB_Ignore,189,#PB_Ignore,#PB_Ignore )
;   ; ResizeWidget(*g0,113,189,#PB_Ignore,#PB_Ignore )
;   
;   ; widgets2
; ;   resize - Root 0 0 620 620
; ;   resize - MDI 100 100 420 420
; ;   resize - MDI-0-vertical-v 494 110 16 388
; ;   resize - MDI-0-horizontal-h 110 494 388 16
; ;   resize - Window 110 110 288 212
; ;   resize - MDI-0-horizontal-h 110 494 400 16
; ;   resize - MDI-0-vertical-v 494 110 16 400
; ;   ----- test -----
; ;   resize - MDI 100 100 270 270
; ;   resize - MDI-0-vertical-v 344 110 16 238
; ;   resize - MDI-0-horizontal-h 110 344 238 16
; ;   Draw - Root
; ;   reClip - Root
; ;   Draw - MDI
; ;   reClip - MDI
; ;   Draw scrolbar MDI-0-vertical-v 344 110 16 238
; ;   Draw scrolbar MDI-0-horizontal-h 110 344 238 16
; ;   Draw - Window
; ;   reClip - Window
; ;   
; ; widgets3
; ;   resize - Root 0 0 620 620
; ;   resize - MDI 100 100 420 420
; ;   resize - MDI-0-vertical-v 494 110 16 400
; ;   resize - MDI-0-horizontal-h 110 494 400 16
; ;   resize - Window 110 110 288 212
; ;   ----- test -----
; ;   resize - MDI 100 100 270 270
; ;   resize - MDI-0-vertical-v 344 110 16 238
; ;   resize - MDI-0-horizontal-h 110 344 238 16
; ;   Draw - Root
; ;   reClip - Root
; ;   Draw - MDI
; ;   reClip - MDI
; ;   Draw scrolbar MDI-0-vertical-v 344 110 16 238
; ;   Draw scrolbar MDI-0-horizontal-h 110 344 238 16
; ;   Draw - Window
; ;   reClip - Window
;   
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 61
; FirstLine = 57
; Folding = -
; EnableXP
; DPIAware