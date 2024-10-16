﻿IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(widget)
   
   Global._s_WIDGET *panel1
   
   If Open( 0, 0, 0, 220, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ;
      *panel1 = Panel( 10, 10, 200, 150) : SetClass(widget( ), "CONT1" ) 
      AddItem(*panel1, -1, "item1" )
      Button( 10,5,80,25, "*btn1_1" )  : SetClass(widget( ), "btn1_1" ) 
      Button( 10,35,80,25, "*btn1_2" )  : SetClass(widget( ), "btn1_2" ) 
      Button( 10,65,80,25, "*btn1_3" )  : SetClass(widget( ), "btn1_3" ) 
      AddItem(*panel1, -1, "item2" )
      Button( 10,5,80,25, "*btn1_4" )  : SetClass(widget( ), "btn1_4" ) 
      Button( 10,35,80,25, "*btn1_5" )  : SetClass(widget( ), "btn1_5" ) 
      Button( 10,65,80,25, "*btn1_6" )  : SetClass(widget( ), "btn1_6" ) 
      AddItem(*panel1, -1, "item3" )
      Button( 10,5,80,25, "*btn1_7" )  : SetClass(widget( ), "btn1_7" ) 
      Button( 10,35,80,25, "*btn1_8" )  : SetClass(widget( ), "btn1_8" ) 
      Button( 10,65,80,25, "*btn1_9" )  : SetClass(widget( ), "btn1_9" ) 
      CloseList()
      
      ;\\ 
      Define line.s
      Debug "---->>"
      ForEach widgets( )
         line = "  ";+ widgets( )\class +" "
         
         If widgets( )\before\widget
            line + widgets( )\before\widget\class +" <<  "    ;  +"_"+widgets( )\before\widget\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\text\string
         
         If widgets( )\after\widget
            line +"  >> "+ widgets( )\after\widget\class ;+"_"+widgets( )\after\widget\text\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      Next
      Debug "<<----"
      
      ;\\
      ;       result
      ;       ---->>
      ;       -------- <<  CONT1  >> --------
      ;       -------- <<  btn1_1  >> btn1_2
      ;       btn1_1 <<  btn1_2  >> btn1_3
      ;       btn1_2 <<  btn1_3  >> --------
      ;       -------- <<  btn1_4  >> btn1_5
      ;       btn1_4 <<  btn1_5  >> btn1_6
      ;       btn1_5 <<  btn1_6  >> --------
      ;       -------- <<  btn1_7  >> btn1_8
      ;       btn1_7 <<  btn1_8  >> btn1_9
      ;       btn1_8 <<  btn1_9  >> --------
      ;       <<----
      
      WaitClose( )
   EndIf   
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 41
; FirstLine = 28
; Folding = -
; EnableXP