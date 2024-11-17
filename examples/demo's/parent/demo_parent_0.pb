IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   If OpenRootWidget( 0, 0, 0, 370, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ;
      ContainerWidget( 10, 10, 100, 100) : SetWidgetClass(widget( ), "CONT1" ) 
      ButtonWidget( 10,5,80,25, "*btn1_1" )  : SetWidgetClass(widget( ), "btn1_1" ) 
      ButtonWidget( 10,35,80,25, "*btn1_2" )  : SetWidgetClass(widget( ), "btn1_2" ) 
      ButtonWidget( 10,65,80,25, "*btn1_3" )  : SetWidgetClass(widget( ), "btn1_3" ) 
      CloseWidgetList()
      ;
      ContainerWidget( 120, 10, 100, 100) : SetWidgetClass(widget( ), "CONT2" ) 
      ButtonWidget( 10,5,80,25, "*btn2_1" )  : SetWidgetClass(widget( ), "btn2_1" ) 
      ButtonWidget( 10,35,80,25, "*btn2_2" )  : SetWidgetClass(widget( ), "btn2_2" ) 
      ButtonWidget( 10,65,80,25, "*btn2_3" )  : SetWidgetClass(widget( ), "btn2_3" ) 
      CloseWidgetList()
      ;
      ContainerWidget( 230, 10, 100, 100) : SetWidgetClass(widget( ), "CONT3" ) 
      ButtonWidget( 10,5,80,25, "*btn3_1" )  : SetWidgetClass(widget( ), "btn3_1" ) 
      ButtonWidget( 10,35,80,25, "btn3_2" )  : SetWidgetClass(widget( ), "btn3_2" ) 
      ButtonWidget( 10,65,80,25, "*btn3_3" )  : SetWidgetClass(widget( ), "btn3_3" ) 
      CloseWidgetList()
      
      
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
      
      WaitCloseRootWidget( )
   EndIf   
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 43
; FirstLine = 30
; Folding = -
; EnableXP