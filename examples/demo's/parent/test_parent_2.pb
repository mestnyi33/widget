IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(widget)
   
   Global._s_WIDGET *CONT1, *CONT2 
   
   If Open( 0, 100, 100, 600, 600, "", #PB_Window_SystemMenu | #PB_Window_SizeGadget )
      a_init(root())
      ;
      *CONT1 = Container( 10, 10, 200, 150) : SetClass(widget( ), "CONT1" ) 
      Button( 10,5,80,25, "*btn1_1" )  : SetClass(widget( ), "btn1_1" ) 
      Button( 10,35,80,25, "*btn1_2" )  : SetClass(widget( ), "btn1_2" ) 
      Button( 10,65,80,25, "*btn1_3" )  : SetClass(widget( ), "btn1_3" ) 
      CloseList()
      ;
      *CONT2 = Container( 220, 10, 200, 150) : SetClass(widget( ), "CONT2" ) 
      Button( 10,5,80,25, "*btn2_1" )  : SetClass(widget( ), "btn2_1" ) 
      Button( 10,35,80,25, "*btn2_2" )  : SetClass(widget( ), "btn2_2" ) 
      Button( 10,65,80,25, "*btn2_3" )  : SetClass(widget( ), "btn2_3" ) 
      CloseList()
      
      ;CloseList()
      
      ;\\
      SetParent( *CONT1, *CONT2 )
      SetParent( *CONT1, root( ) )
      
      ;\\
      Define line.s
      Debug "---->>"
      ForEach __widgets( )
         ;Debug __widgets( )\class
         line = "  ";+ __widgets( )\class +" "
         
         If __widgets( )\before\widget
            line + __widgets( )\before\widget\class +" <<  "    ;  +"_"+__widgets( )\before\widget\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + __widgets( )\class ; __widgets( )\text\string
         
         If __widgets( )\after\widget
            line +"  >> "+ __widgets( )\after\widget\class ;+"_"+__widgets( )\after\widget\text\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      Next
      Debug "<<----"
      
;       result
;       ---->>
;       -------- <<  CONT2  >> CONT1
;       -------- <<  btn2_1  >> btn2_2
;       btn2_1 <<  btn2_2  >> btn2_3
;       btn2_2 <<  btn2_3  >> --------
;       CONT2 <<  CONT1  >> --------
;       -------- <<  btn1_1  >> btn1_2
;       btn1_1 <<  btn1_2  >> btn1_3
;       btn1_2 <<  btn1_3  >> --------
;       <<----

      WaitClose( )
   EndIf   
CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 64
; FirstLine = 35
; Folding = -
; EnableXP