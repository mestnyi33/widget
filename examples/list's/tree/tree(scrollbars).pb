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
   a_init( root(), 0 )
  
  ;Define *Tree = TreeWidget(0,0,0,0,#__flag_autosize)
  ;Define *Tree = TreeWidget(x,y,width, height)
  Define *Tree = TreeWidget(10, 10, 160,95) 
  ; 
  Debug " * "+WidgetWidth(*Tree, #__c_inner)+" "+WidgetHeight(*Tree, #__c_inner)
  
  ; 
  ; a_init( *Tree )
  
  ; add childrens to Tree gadget
  Define i, horizontal$ = " & horizontal"
  For i = 0 To 12
     AddItem(*Tree, i, Str(i)+" line vertical"+horizontal$)
  Next
  
;   Debug ""
;   ResizeWidget(*Tree,15,15,#PB_Ignore,#PB_Ignore )
;   ResizeWidget(*Tree,25,#PB_Ignore,#PB_Ignore,#PB_Ignore )
;   ResizeWidget(*Tree,#PB_Ignore,35,#PB_Ignore,#PB_Ignore )
;   Debug ""
;   ResizeWidget(*Tree,#PB_Ignore,#PB_Ignore,150,150 )
;   ResizeWidget(*Tree,#PB_Ignore,#PB_Ignore,250,#PB_Ignore )
  ResizeWidget(*Tree,#PB_Ignore,#PB_Ignore,350,#PB_Ignore )
  
;   
;   ; Debug " - test parent - Tree show and size scroll bars - "
;   ; ResizeWidget(*Tree,#PB_Ignore,#PB_Ignore,308,232 )
;   ; ResizeWidget(*Tree,#PB_Ignore,#PB_Ignore,307,#PB_Ignore )
;   ; ResizeWidget(*Tree,#PB_Ignore,#PB_Ignore,#PB_Ignore,231 )
;   ; ResizeWidget(*Tree,#PB_Ignore,#PB_Ignore,307,231 )
;   
;   ; Debug " - test child - Tree show and size scroll bars - "
;   ; ResizeWidget(*g0,#PB_Ignore,#PB_Ignore,392,368 )
;   ; ResizeWidget(*g0,113,#PB_Ignore,#PB_Ignore,#PB_Ignore )
;   ; ResizeWidget(*g0,#PB_Ignore,189,#PB_Ignore,#PB_Ignore )
;   ; ResizeWidget(*g0,113,189,#PB_Ignore,#PB_Ignore )

  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP