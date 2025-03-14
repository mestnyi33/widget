﻿XIncludeFile "../../../widgets.pbi"
UseWidgets( )

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Define i, a, *g, g =- 1, *g1, g1 =- 1
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  Define item = 2
  Define sublevel = 2
  
  If OpenWindow(0, 0, 0, 450, 455, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    g = TreeGadget(#PB_Any, 10, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes)                                         
    g1 = TreeGadget(#PB_Any, 230, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes)                                         
    
    ; 1_example
    AddGadgetItem(g, -1, "Node "+Str(a), ImageID(0), 0)  
    SetGadgetState(g, 0)
    ;SetGadgetItemState(g, 0, #PB_Tree_Selected)
    
    AddGadgetItem(g, -1, "Sub-Item 1", 0, 1)         
    AddGadgetItem(g, -1, "Sub-Item 3", 0, 3)
    AddGadgetItem(g, -1, "Sub-Item 2", 0, 2)
    AddGadgetItem(g, -1, "Sub-Item 4", 0, 4)
    
    ; 2_example
    AddGadgetItem(g1, 0, "Node "+Str(a), ImageID(0), 0)      
    AddGadgetItem(g1, 1, "Sub-Item 1", 0, 1)         
    AddGadgetItem(g1, 3, "Sub-Item 3", 0, 3)
    AddGadgetItem(g1, 2, "Sub-Item 2", 0, 2)
    AddGadgetItem(g1, 4, "Sub-Item 4", 0, 4)
  EndIf
  
  
  If Open(0, 0, 225, #PB_Ignore, 230)
    
    *g = Tree(10, 10, 210, 210, #__tree_CheckBoxes)                                         
    *g1 = Tree(230, 10, 210, 210, #__tree_CheckBoxes)                                         
    
    ; 1_example
    AddItem (*g, -1, "Node "+Str(a), 0, 0)                                         
    SetState(*g, 0)
    ;SetItemState(*g, 0, #PB_Tree_Selected)
    
    AddItem (*g, -1, "Sub-Item 1", -1, 1)                                           
    AddItem (*g, -1, "Sub-Item 3", -1, 3)
    AddItem (*g, -1, "Sub-Item 2", -1, 2)
    AddItem (*g, -1, "Sub-Item 4", -1, 4)
    
      
    
  ; 2_example
    AddItem (*g1, 0, "Node "+Str(a), 0, 0)                                         
    SetState(*g1, 0)
    AddItem (*g1, 1, "Sub-Item 1", -1, 1)                                           
    AddItem (*g1, 3, "Sub-Item 3", -1, 3)
    AddItem (*g1, 2, "Sub-Item 2", -1, 2)
    AddItem (*g1, 4, "Sub-Item 4", -1, 4)
    
;         ; example 1 - 2
;     AddItem (*g, 0, "window_0", -1, 0) 
;     AddItem (*g, 1, "container_0", -1, 1) 
;     AddItem (*g, 2, "button_0", -1, 2) 
;     AddItem (*g, 3, "button_1", -1, 1) 
;     
;     AddItem (*g, 3, "container_1", -1, 2) 
;     AddItem (*g, 4, "button_2", -1, 3) 
;     
;     AddItem (*g, 6, "button_3", -1, 1) 
;     

  EndIf
  
;   AddGadgetItem(g, item, "Add-Item "+Str(item), 0, sublevel)
;   AddItem (*g, item, "Add-Item "+Str(item), -1, sublevel)
;   
;   AddGadgetItem(g1, item, "Add-Item "+Str(item), 0, sublevel)
;   AddItem (*g1, item, "Add-Item "+Str(item), -1, sublevel)
;   
; ; ;   
; ; ;   item = 4
; ; ;   Debug "g - "+ GetGadgetItemData(g, item) +" "+ GetGadgetItemText(g, item)
; ; ;   Debug "w - "+ GetItemData(*g, item) +" "+ GetItemText(*g, item)
; ; ;   
; ; ;   Debug "g1 - "+ GetGadgetItemData(g1, item) +" "+ GetGadgetItemText(g1, item)
; ; ;   Debug "w1 - "+ GetItemData(*g1, item) +" "+ GetItemText(*g1, item)
  
  For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
  For i=0 To CountGadgetItems(g1) : SetGadgetItemState(g1, i, #PB_Tree_Expanded) : Next
  
  Repeat
    Select WaitWindowEvent()   
      Case #PB_Event_CloseWindow
        CloseWindow(EventWindow()) 
        Break
    EndSelect
  ForEver
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 91
; FirstLine = 75
; Folding = -
; EnableXP