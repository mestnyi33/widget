IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  UseWidgets( )
  EnableExplicit
  test_redraw_items = 0
  
  Define a, Event, LN=3000; количесвто итемов 
  
  If OpenWindow(0, 100, 50, 530, 700, "editorGadget", #PB_Window_SystemMenu)
     EditorGadget(0, 10, 10, 250, 680)
    
     SetGadgetFont(#PB_All, GetGadgetFont(0))
    Open(0, 270, 0, 260, 700)
    Define *w = Editor(0, 10, 250, 680) 
    
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
    
    Repaint( ) 
    
    
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
    
    WaitClose()
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 30
; FirstLine = 18
; Folding = --
; EnableXP
; DPIAware