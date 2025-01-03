; 
; demo state
; test windows 11
; gadget items add time
;     857
;     2619
; widget items add time
;     9
;     112

XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, *g._s_WIDGET, g, CountItems=1000
   
   If Open(1, 100, 50, 525, 435+40, "demonstration of the time when items were added", #PB_Window_SystemMenu)
      ; demo gadget
      g = TreeGadget(#PB_Any, 10, 10, 250, 450, #PB_Tree_CheckBoxes|#PB_Tree_ThreeState|#PB_Tree_AlwaysShowSelection)
      
      Debug "gadget items add time"
      Define time = ElapsedMilliseconds()
      For a=0 To CountItems
        AddGadgetItem(g, -1, Str(a) ) 
      Next
      Debug "    "+Str(ElapsedMilliseconds()-time)
      
      Define time = ElapsedMilliseconds()
      For a=0 To CountItems
        AddGadgetItem(g, 1, "1_"+Str(a) ) 
      Next
      Debug "    "+Str(ElapsedMilliseconds()-time)
      
      
      
      ; demo widget
      *g = Tree(265, 10, 250, 450, #PB_Tree_CheckBoxes|#PB_Tree_ThreeState ) 
      
      Debug "widget items add time"
      Define time = ElapsedMilliseconds()
      For a=0 To CountItems
        AddItem(*g, -1, Str(a) ) 
      Next
      Debug "    "+Str(ElapsedMilliseconds()-time)
      
      Define time = ElapsedMilliseconds()
      For a=0 To CountItems
        AddItem(*g, 1, "1_"+Str(a) ) 
      Next
      Debug "    "+Str(ElapsedMilliseconds()-time)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 3
; Folding = -
; EnableXP
; DPIAware