; 
; demo state
; test windows 11
; gadget items add time
;     961
;     650
; widget items add time
;     15
;     190
    
XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, *g._s_WIDGET, g, CountItems=1000
   
   If Open(1, 100, 50, 525, 435+40, "demonstration of the time when items were added", #PB_Window_SystemMenu)
      ; demo gadget
      g = EditorGadget(#PB_Any, 10, 10, 250, 450 )
      
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
      *g = Editor(265, 10, 250, 450 ) 
      
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
; CursorPosition = 9
; Folding = -
; EnableXP
; DPIAware