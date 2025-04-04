﻿IncludePath "../../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_WIDGET *CONT1, *CONT2 
   
   Procedure Show_DEBUG( )
      Define line.s
      ;\\
      Debug "---->>"
      ForEach widgets( )
         ;Debug widgets( )\class
         line = "  "
         
         If widgets( )\BeforeWidget( )
            line + widgets( )\BeforeWidget( )\class +" <<  "    ;  +"_"+widgets( )\BeforeWidget( )\txt\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\txt\string
         
         If widgets( )\AfterWidget( )
            line +"  >> "+ widgets( )\AfterWidget( )\class ;+"_"+widgets( )\AfterWidget( )\txt\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      Next
      Debug "<<----"
   EndProcedure
   
   If Open( 0, 100, 100, 470, 200, " CONT1 set in CONT2", #PB_Window_SystemMenu )
      a_init(root())
      ;
      *CONT2 = Container( 220, 10, 200, 150) : SetClass(widget( ), "CONT2" ) 
      Button( 10,5,80,25, "*btn2_1" )  : SetClass(widget( ), "btn2_1" ) 
      Button( 10,35,80,25, "*btn2_2" )  : SetClass(widget( ), "btn2_2" ) 
      Button( 10,65,80,25, "*btn2_3" )  : SetClass(widget( ), "btn2_3" ) 
      CloseList()
      ;
      *CONT1 = Container( 10, 10, 200, 150) : SetClass(widget( ), "CONT1" ) 
      Button( 10,5,80,25, "*btn1_1" )  : SetClass(widget( ), "btn1_1" ) 
      Button( 10,35,80,25, "*btn1_2" )  : SetClass(widget( ), "btn1_2" ) 
      Button( 10,65,80,25, "*btn1_3" )  : SetClass(widget( ), "btn1_3" ) 
      CloseList()
      
      ;\\
      SetParent( *CONT1, *CONT2 )
      
      ;\\
      show_DEBUG( )
      
      ;       result
      ;       ---->>
      ;       -------- <<  CONT2  >> --------
      ;       -------- <<  btn2_1  >> btn2_2
      ;       btn2_1 <<  btn2_2  >> btn2_3
      ;       btn2_2 <<  btn2_3  >> CONT1
      ;       btn2_3 <<  CONT1  >> --------
      ;       -------- <<  btn1_1  >> btn1_2
      ;       btn1_1 <<  btn1_2  >> btn1_3
      ;       btn1_2 <<  btn1_3  >> --------
      ;       <<----
      
      WaitClose( )
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; Folding = -
; EnableXP