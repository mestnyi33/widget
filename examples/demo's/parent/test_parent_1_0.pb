IncludePath "../../../"
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
   EndProcedure
   
   If Open( 0, 100, 100, 470, 200, " CONT1 create in CONT2", #PB_Window_SystemMenu )
      a_init(root())
      ;
      *CONT2 = ContainerWidget( 220, 10, 200, 150) : SetWidgetClass(widget( ), "CONT2" ) 
      ButtonWidget( 10,5,80,25, "*btn2_1" )  : SetWidgetClass(widget( ), "btn2_1" ) 
      ButtonWidget( 10,35,80,25, "*btn2_2" )  : SetWidgetClass(widget( ), "btn2_2" ) 
      ButtonWidget( 10,65,80,25, "*btn2_3" )  : SetWidgetClass(widget( ), "btn2_3" ) 
      ;
      *CONT1 = ContainerWidget( 10, 10, 200, 150) : SetWidgetClass(widget( ), "CONT1" ) 
      ButtonWidget( 10,5,80,25, "*btn1_1" )  : SetWidgetClass(widget( ), "btn1_1" ) 
      ButtonWidget( 10,35,80,25, "*btn1_2" )  : SetWidgetClass(widget( ), "btn1_2" ) 
      ButtonWidget( 10,65,80,25, "*btn1_3" )  : SetWidgetClass(widget( ), "btn1_3" ) 
      CloseList()
      CloseList()
      ;
     
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
; CursorPosition = 26
; FirstLine = 13
; Folding = -
; EnableXP