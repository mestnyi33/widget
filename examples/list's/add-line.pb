; 
; demo state

IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, *g._s_WIDGET, g, CountItems=9; количесвто итемов 
   
   If Open(1, 100, 50, 525, 435+40, "demo add item", #PB_Window_SystemMenu)
      ; demo gadget
      g = EditorGadget(#PB_Any, 10, 10, 250, 450)
      AddGadgetItem(g, 0, "0_0", 0 )
      AddGadgetItem(g, 1, "1_0_1", 0, 1) 
      AddGadgetItem(g, 4, "4_0_3", 0, 2) 
      AddGadgetItem(g, 5, "5_0_4", 0, 2) 
      AddGadgetItem(g, 6, "6_0_4_1", 0, 3) 
      AddGadgetItem(g, 8, "8_0_4_1_1 [------------------]", 0, 4) 
      AddGadgetItem(g, 7, "7_0_4_2", 0, 3) 
      AddGadgetItem(g, 2, "2_0_2", 0, 1) 
      AddGadgetItem(g, 3, "3_0_2_1", 0, 4) 
      ;
      ;
      AddGadgetItem(g, 9, "9_2",0 )
      AddGadgetItem(g, 10, "10_3", 0 )
      AddGadgetItem(g, 11, "11_4", 0 )
      AddGadgetItem(g, 12, "12_5", 0 )
      ;
      ; comment\uncomment
      AddGadgetItem(g, 8, "8_add",0 )
      ;
      AddGadgetItem(g, 13, "13_6", 0 )
      AddGadgetItem(g, 14, "14_7", 0 )
      
      ; demo widget
      *g = Editor(265, 10, 250, 450 ) 
      AddItem(*g, 0, "0_0", -1 )
      AddItem(*g, 1, "1_0_1", 0, 1) 
      AddItem(*g, 4, "4_0_3", -1, 2) 
      AddItem(*g, 5, "5_0_4", -1, 2) 
      AddItem(*g, 6, "6_0_4_1", -1, 3) 
      AddItem(*g, 8, "8_0_4_1_1 [------------------]", -1, 4) 
      AddItem(*g, 7, "7_0_4_2", -1, 3) 
      AddItem(*g, 2, "2_0_2", -1, 1) 
      AddItem(*g, 3, "3_0_2_1", -1, 4) 
      ;       ;
      ;       ;
      AddItem(*g, 9, "9_2",-1 )
      AddItem(*g, 10, "10_3", -1 )
      AddItem(*g, 11, "11_4", -1 )
      AddItem(*g, 12, "12_5", -1 )
      ;       ;
      ; comment\uncomment
      AddItem(*g, 8, "8_add", -1 )
      ;
      AddItem(*g, 13, "13_6", -1 )
      AddItem(*g, 14, "14_7", -1 )
      
      ; 
      ForEach *g\__lines( )
         Debug ""+*g\__lines( )\index +" "+*g\__lines( )\text\string
      Next
      
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 61
; FirstLine = 37
; Folding = -
; EnableXP
; DPIAware