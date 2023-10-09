XIncludeFile "../../../widgets3.pbi"

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
   a_init( root() )
  
  ;Define *Tree = Tree(0,0,0,0,#__flag_autosize)
  ;Define *Tree = Tree(x,y,width, height)
  Define *Tree = Tree(10, 10, 160,95) 
  ; 
  Debug " * "+width(*Tree, #__c_inner)+" "+height(*Tree, #__c_inner)
  
  ; 
  ; a_init( *Tree )
  
  ; add childrens to Tree gadget
  Define i, horizontal$ = " & horizontal"
  For i = 0 To 12
     AddItem(*Tree, i, Str(i)+" line vertical"+horizontal$)
  Next
  
;   Debug ""
;   Resize(*Tree,15,15,#PB_Ignore,#PB_Ignore )
;   Resize(*Tree,25,#PB_Ignore,#PB_Ignore,#PB_Ignore )
;   Resize(*Tree,#PB_Ignore,35,#PB_Ignore,#PB_Ignore )
;   Debug ""
;   Resize(*Tree,#PB_Ignore,#PB_Ignore,150,150 )
;   Resize(*Tree,#PB_Ignore,#PB_Ignore,250,#PB_Ignore )
  Resize(*Tree,#PB_Ignore,#PB_Ignore,350,#PB_Ignore )
  
;   
;   ; Debug " - test parent - Tree show and size scroll bars - "
;   ; Resize(*Tree,#PB_Ignore,#PB_Ignore,308,232 )
;   ; Resize(*Tree,#PB_Ignore,#PB_Ignore,307,#PB_Ignore )
;   ; Resize(*Tree,#PB_Ignore,#PB_Ignore,#PB_Ignore,231 )
;   ; Resize(*Tree,#PB_Ignore,#PB_Ignore,307,231 )
;   
;   ; Debug " - test child - Tree show and size scroll bars - "
;   ; Resize(*g0,#PB_Ignore,#PB_Ignore,392,368 )
;   ; Resize(*g0,113,#PB_Ignore,#PB_Ignore,#PB_Ignore )
;   ; Resize(*g0,#PB_Ignore,189,#PB_Ignore,#PB_Ignore )
;   ; Resize(*g0,113,189,#PB_Ignore,#PB_Ignore )

  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 39
; FirstLine = 23
; Folding = -
; EnableXP