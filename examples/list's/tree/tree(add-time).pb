﻿
; macos
; update_items_( )
; 2303
; 2559
; 2815
; 3071
; 3327
; 3583
; 3839
; 4095
; 95 - add widget items time count - 5001
; 2303
; 2559
; 2815
; 3071
; 3327
; 3583
; 3839
; 4095
; 3814 - add gadget items time count - 5001
; update_items_( )

XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  UseWidgets( )
  EnableExplicit
  test_redraw_items = 0
  
  
  Define *w,a, Event
  Define gLN=1500
  Define LN=gLN
  
  
  If Open(0, 100, 50, 530, 700, "TreeGadget", #PB_Window_SystemMenu)
    *w = Tree(270, 10, 250, 680, #__Tree_NoLines|#__Tree_NoButtons) 
    
    Define time = ElapsedMilliseconds()
    For a = 0 To LN
       AddItem (*w, -1, "Item "+Str(a), 0,0) 
       
      If A & $f=$f
        WindowEvent() ; это нужно чтобы немного обновлялся
      EndIf
      If A & $8ff=$8ff
        WindowEvent() ; это позволяет показывать скоко циклов пройшло
        Debug a
      EndIf
    Next
    Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + CountItems(*w)
     ; ReDraw( GetRoot(*w)) 
    PostReDraw( root( ) )
       
        
    ; ListViewGadget(0, 10, 10, 250, 680, #PB_Tree_NoLines|#PB_Tree_NoButtons)
    TreeGadget(0, 10, 10, 250, 680, #PB_Tree_NoLines|#PB_Tree_NoButtons)
    
    ; HideGadget(0, 1)
    Define time = ElapsedMilliseconds()
    For a = 0 To gLN
      AddGadgetItem (0, -1, "Item "+Str(a), 0, 0)
      If A & $f=$f
        WindowEvent() 
      EndIf
      If A & $8ff=$8ff
        WindowEvent()
        Debug a
      EndIf
    Next
    Debug Str(ElapsedMilliseconds()-time) + " - add gadget items time count - " + CountGadgetItems(0)
    ; HideGadget(0, 0)
    
    WaitClose()
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Linux - x64)
; CursorPosition = 44
; FirstLine = 27
; Folding = --
; EnableXP