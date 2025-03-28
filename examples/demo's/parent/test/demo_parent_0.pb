﻿IncludePath "../../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   If Open( 0, 0, 0, 370, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ;
      Container( 10, 10, 100, 100) : SetClass(widget( ), "CONT1" ) 
      Button( 10,5,80,25, "*btn1_1" )  : SetClass(widget( ), "btn1_1" ) 
      Button( 10,35,80,25, "*btn1_2" )  : SetClass(widget( ), "btn1_2" ) 
      Button( 10,65,80,25, "*btn1_3" )  : SetClass(widget( ), "btn1_3" ) 
      CloseList()
      ;
      Container( 120, 10, 100, 100) : SetClass(widget( ), "CONT2" ) 
      Button( 10,5,80,25, "*btn2_1" )  : SetClass(widget( ), "btn2_1" ) 
      Button( 10,35,80,25, "*btn2_2" )  : SetClass(widget( ), "btn2_2" ) 
      Button( 10,65,80,25, "*btn2_3" )  : SetClass(widget( ), "btn2_3" ) 
      CloseList()
      ;
      Container( 230, 10, 100, 100) : SetClass(widget( ), "CONT3" ) 
      Button( 10,5,80,25, "*btn3_1" )  : SetClass(widget( ), "btn3_1" ) 
      Button( 10,35,80,25, "btn3_2" )  : SetClass(widget( ), "btn3_2" ) 
      Button( 10,65,80,25, "*btn3_3" )  : SetClass(widget( ), "btn3_3" ) 
      CloseList()
      
      
      ;\\
      Define line.s
      Debug "---->>"
      ForEach widgets( )
         line = "  ";+ widgets( )\class +" "
         
         If widgets( )\BeforeWidget( )
            line + widgets( )\BeforeWidget( )\class +" <<  "    ;  +"_"+widgets( )\BeforeWidget( )\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\text\string
         
         If widgets( )\AfterWidget( )
            line +"  >> "+ widgets( )\AfterWidget( )\class ;+"_"+widgets( )\AfterWidget( )\text\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      Next
      Debug "<<----"
      
      ;\\
      ;       result
      ;       ---->>
      ;       -------- <<  CONT1  >> CONT2
      ;       -------- <<  btn1_1  >> btn1_2
      ;       btn1_1 <<  btn1_2  >> btn1_3
      ;       btn1_2 <<  btn1_3  >> --------
      ;       CONT1 <<  CONT2  >> CONT3
      ;       -------- <<  btn2_1  >> btn2_2
      ;       btn2_1 <<  btn2_2  >> btn2_3
      ;       btn2_2 <<  btn2_3  >> --------
      ;       CONT2 <<  CONT3  >> --------
      ;       -------- <<  btn3_1  >> btn3_2
      ;       btn3_1 <<  btn3_2  >> btn3_3
      ;       btn3_2 <<  btn3_3  >> --------
      ;       <<----
      
      WaitClose( )
   EndIf   
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 43
; FirstLine = 31
; Folding = -
; EnableXP