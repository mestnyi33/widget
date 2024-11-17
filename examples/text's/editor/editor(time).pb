IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  UseWidgets( )
  EnableExplicit
  Define a, Event, LN=10000; количесвто итемов 
  
  If OpenWindow(0, 100, 50, 530, 700, "editorGadget", #PB_Window_SystemMenu)
    EditorGadget(0, 10, 10, 250, 680)
    
    OpenRootWidget(0, 270, 10, 250, 680)
    Define *w = EditorWidget(0, 0, 250, 680) 
    
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
    
    ; HideGadget(0, 1)
    Define time = ElapsedMilliseconds()
    For a = 0 To LN
      AddGadgetItem (0, -1, "Item "+Str(a), 0, Random(5)+1)
      If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
      EndIf
      If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
        Debug a
      EndIf
    Next
    Debug Str(ElapsedMilliseconds()-time) + " - add gadget items time count - " + CountGadgetItems(0)
    ; HideGadget(0, 0)
    
    WaitCloseRootWidget()
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 21
; FirstLine = 17
; Folding = --
; EnableXP