XIncludeFile "PBEdit_1_0_10.pb"
UseModule PBEdit
Global PBEdit_OpenWindow
Macro Open( window, x,y,width,height )
  PBEdit_OpenWindow = window
  ContainerGadget( -1, x,y,width,height )
EndMacro
Macro Editor( x,y,width,height, flag=0 )
  PBEdit_Gadget( PBEdit_OpenWindow, x,y,width,height )
EndMacro
Macro SetText( editor, Text )
  PBEdit_SetGadgetText(editor, Text)
EndMacro
Macro AddItem( editor, a, Text, img=0, mode=0 )
  PBEdit_AddGadgetItem(editor, a, Text)
EndMacro
Macro GetText( editor )
  PBEdit_GetSelectedText(editor)
EndMacro
Macro RemoveItem( editor, Position )
  PBEdit_RemoveGadgetItem(editor, Position)
EndMacro
Macro CountItems( editor )
  PBEdit_CountGadgetItems(editor)
EndMacro
Macro CloseList( )
  CloseGadgetList()
EndMacro

Structure _S_widget
  i.i
EndStructure


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Define a, Event
  Define gLN=500;0      ;0; количесвто итемов 
  Define LN=500;0;0

  If OpenWindow(0, 100, 50, 530, 700, "editorGadget", #PB_Window_SystemMenu)
    Open(0, 270, 10, 250, 680)
    Define *w = Editor(0, 0, 250, 680) 
    
    Define time = ElapsedMilliseconds()
    For a = 0 To LN
      AddItem (*w, -1, "Item "+Str(a), 0,1)
      If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
      EndIf
      If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
        Debug a
      EndIf
    Next
    Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + CountItems(*w)
    CloseList()
    
    
    EditorGadget(0, 10, 10, 250, 680)
    ; HideGadget(0, 1)
    Define time = ElapsedMilliseconds()
    For a = 0 To gLN
      AddGadgetItem (0, -1, "Item "+Str(a), 0, Random(5)+1)
      If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
      EndIf
      If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
        Debug a
      EndIf
    Next
    Debug Str(ElapsedMilliseconds()-time) + " - add gadget items time count - " + CountGadgetItems(0)
    ; HideGadget(0, 0)
    
    ;     ;   If Not *w\Repaint : *w\Repaint = 1
;     ;     PostEvent(#PB_Event_Gadget, 
;     ;               *w\Canvas\Window, 
;     ;               *w\Canvas\Gadget,
;     ;               #PB_EventType_Repaint)
;     ;     ; While WindowEvent() : Wend
;     ;   EndIf
;     ; Editor::SetFont(*w, FontID(LoadFont(#PB_Any, "Impact", 18 , #PB_Font_HighQuality)))
    Repeat 
      Event=WaitWindowEvent()
    Until  Event= #PB_Event_CloseWindow
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 78
; FirstLine = 55
; Folding = ---
; EnableXP