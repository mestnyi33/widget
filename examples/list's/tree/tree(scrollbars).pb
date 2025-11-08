XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  EnableExplicit
  Global Event.i, MyCanvas, *spl1,*spl2
  Global X=100,Y=100, Width=420, Height=420 , focus
  
  If Not OpenWindow(0, 0, 0, Width+X*2+20, Height+Y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetCanvasGadget(Open(0, 10, 10))
   a_init( root(), 0 )
  
  ;Define *Tree = Tree(0,0,0,0,#__flag_autosize)
  ;Define *Tree = Tree(x,y,width, height)
  Define *Tree = Tree(10, 10, 160,95) 
  ; 
  Debug " * "+Width(*Tree, #__c_inner)+" "+Height(*Tree, #__c_inner)
  
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
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 14
; FirstLine = 4
; Folding = -
; EnableXP