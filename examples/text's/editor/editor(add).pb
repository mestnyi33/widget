XIncludeFile "../../../widgets.pbi"
;IncludePath "../../../": XIncludeFile "-widgets-editor.pbi
;XIncludeFile "../../../-widgets-edit.pbi"
;XIncludeFile "../../../-widgets.pbi"
;XIncludeFile "../../../widget-events.pbi"
 ;XIncludeFile "editor(code).pb"
 ;XIncludeFile "empty.pb"



; Исчерпан лимит в x32 (4294967296)
;  - -  Canvas repaint - -  
; get thumb size - ?????
; #PB_Event_Repaint
; 2303
; 2559
; 2815
; 3071
; 3327
; 3583
; 3839
; 4095
; 1428 - add widget items time count - 5001
; #PB_Event_Repaint
; 2303
; 2559
; 2815
; 3071
; 3327
; 3583
; 3839
; 4095
; 6278 - add gadget items time count - 5001
; EventDeactive( )
; get thumb size - ?????
; #PB_Event_Repaint



UseWidgets( )

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Define a, Event
  Define gLN=5000      ;0; количесвто итемов 
  Define LN=5000;0
  
   Procedure event_repaint( )
    Debug "#PB_Event_Repaint "+ EventGadget( )
    
   ; Repaints( ) 
    
  EndProcedure
  
 
  If OpenWindow(0, 100, 50, 530, 700, "editorGadget", #PB_Window_SystemMenu)
    BindEvent( #PB_Event_Repaint, @event_repaint( ))
    
    EditorGadget(0, 0, 0, 0, 0)
    SetGadgetFont(#PB_All, GetGadgetFont(0))
    FreeGadget(0)
    Open(0, 270, 10, 250, 680)
    Define *w = Editor(0, 0, 250, 680) 
    
    Define time = ElapsedMilliseconds()
    For a = 0 To LN
      AddItem (*w, -1, "Item "+Str(a), 0,1)
    Next
    Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + CountItems(*w)
    
    
    EditorGadget(10, 10, 10, 250, 680)
    ; HideGadget(0, 1)
    Define time = ElapsedMilliseconds()
    For a = 0 To gLN
      AddGadgetItem (10, -1, "Item "+Str(a), 0, Random(5)+1)
    Next
    Debug Str(ElapsedMilliseconds()-time) + " - add gadget items time count - " + CountGadgetItems(10)
    ; HideGadget(0, 0)
    
    ;     ;   If Not *w\Repaint : *w\Repaint = 1
;     ;     PostEvent(#PB_Event_Gadget, 
;     ;               *w\Canvas\Window, 
;     ;               *w\Canvas\Gadget,
;     ;               #PB_EventType_Repaint)
;     ;     ; While WindowEvent() : Wend
;     ;   EndIf
;     ; Editor::SetFont(*w, FontID(LoadFont(#PB_Any, "Impact", 18 , #PB_Font_HighQuality)))
    ;
    Repeat 
      Event=WaitWindowEvent()
    Until  Event= #PB_Event_CloseWindow
  EndIf
  
  
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 69
; FirstLine = 54
; Folding = -
; EnableXP
; DPIAware