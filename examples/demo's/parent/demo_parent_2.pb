IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_WIDGET *panel1, *panel2, *panel3
   
   If OpenRoot( 0, 0, 0, 600, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ;
      *panel1 = PanelWidget( 10, 10, 200, 150) : SetWidgetClass(widget( ), "CONT1" ) 
      AddItem(*panel1, -1, "item1" )
      ButtonWidget( 10,5,80,25, "*btn1_1" )  : SetWidgetClass(widget( ), "btn1_1" ) 
      ButtonWidget( 10,35,80,25, "*btn1_2" )  : SetWidgetClass(widget( ), "btn1_2" ) 
      ButtonWidget( 10,65,80,25, "*btn1_3" )  : SetWidgetClass(widget( ), "btn1_3" ) 
      AddItem(*panel1, -1, "item2" )
      ButtonWidget( 10,5,80,25, "*btn1_4" )  : SetWidgetClass(widget( ), "btn1_4" ) 
      ButtonWidget( 10,35,80,25, "*btn1_5" )  : SetWidgetClass(widget( ), "btn1_5" ) 
      ButtonWidget( 10,65,80,25, "*btn1_6" )  : SetWidgetClass(widget( ), "btn1_6" ) 
      AddItem(*panel1, -1, "item3" )
      ButtonWidget( 10,5,80,25, "*btn1_7" )  : SetWidgetClass(widget( ), "btn1_7" ) 
      ButtonWidget( 10,35,80,25, "*btn1_8" )  : SetWidgetClass(widget( ), "btn1_8" ) 
      ButtonWidget( 10,65,80,25, "*btn1_9" )  : SetWidgetClass(widget( ), "btn1_9" ) 
      CloseWidgetList()
      ;
      *panel2 = PanelWidget( 220, 10, 200, 150) : SetWidgetClass(widget( ), "CONT2" ) 
      AddItem(*panel2, -1, "item1" )
      ButtonWidget( 10,5,80,25, "*btn2_1" )  : SetWidgetClass(widget( ), "btn2_1" ) 
      ButtonWidget( 10,35,80,25, "*btn2_2" )  : SetWidgetClass(widget( ), "btn2_2" ) 
      ButtonWidget( 10,65,80,25, "*btn2_3" )  : SetWidgetClass(widget( ), "btn2_3" ) 
      AddItem(*panel2, -1, "item2" )
      ButtonWidget( 10,5,80,25, "*btn2_4" )  : SetWidgetClass(widget( ), "btn2_4" ) 
      ButtonWidget( 10,35,80,25, "*btn2_5" )  : SetWidgetClass(widget( ), "btn2_5" ) 
      ButtonWidget( 10,65,80,25, "*btn2_6" )  : SetWidgetClass(widget( ), "btn2_6" ) 
      AddItem(*panel2, -1, "item3" )
      ButtonWidget( 10,5,80,25, "*btn2_7" )  : SetWidgetClass(widget( ), "btn2_7" ) 
      ButtonWidget( 10,35,80,25, "*btn2_8" )  : SetWidgetClass(widget( ), "btn2_8" ) 
      ButtonWidget( 10,65,80,25, "*btn2_9" )  : SetWidgetClass(widget( ), "btn2_9" ) 
      CloseWidgetList()
      ;
      *panel3 = PanelWidget( 430, 10, 200, 150) : SetWidgetClass(widget( ), "CONT3" ) 
      AddItem(*panel3, -1, "item1" )
      ButtonWidget( 10,5,80,25, "*btn3_1" )  : SetWidgetClass(widget( ), "btn3_1" ) 
      ButtonWidget( 10,35,80,25, "*btn3_2" )  : SetWidgetClass(widget( ), "btn3_2" ) 
      ButtonWidget( 10,65,80,25, "*btn3_3" )  : SetWidgetClass(widget( ), "btn3_3" ) 
      AddItem(*panel3, -1, "item2" )
      ButtonWidget( 10,5,80,25, "*btn3_4" )  : SetWidgetClass(widget( ), "btn3_4" ) 
      ButtonWidget( 10,35,80,25, "*btn3_5" )  : SetWidgetClass(widget( ), "btn3_5" ) 
      ButtonWidget( 10,65,80,25, "*btn3_6" )  : SetWidgetClass(widget( ), "btn3_6" ) 
      AddItem(*panel3, -1, "item3" )
      ButtonWidget( 10,5,80,25, "*btn3_7" )  : SetWidgetClass(widget( ), "btn3_7" ) 
      ButtonWidget( 10,35,80,25, "*btn3_8" )  : SetWidgetClass(widget( ), "btn3_8" ) 
      ButtonWidget( 10,65,80,25, "*btn3_9" )  : SetWidgetClass(widget( ), "btn3_9" ) 
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
      ;       -------- <<  btn1_4  >> btn1_5
      ;       btn1_4 <<  btn1_5  >> btn1_6
      ;       btn1_5 <<  btn1_6  >> --------
      ;       -------- <<  btn1_7  >> btn1_8
      ;       btn1_7 <<  btn1_8  >> btn1_9
      ;       btn1_8 <<  btn1_9  >> --------
      ;       CONT1 <<  CONT2  >> CONT3
      ;       -------- <<  btn2_1  >> btn2_2
      ;       btn2_1 <<  btn2_2  >> btn2_3
      ;       btn2_2 <<  btn2_3  >> --------
      ;       -------- <<  btn2_4  >> btn2_5
      ;       btn2_4 <<  btn2_5  >> btn2_6
      ;       btn2_5 <<  btn2_6  >> --------
      ;       -------- <<  btn2_7  >> btn2_8
      ;       btn2_7 <<  btn2_8  >> btn2_9
      ;       btn2_8 <<  btn2_9  >> --------
      ;       CONT2 <<  CONT3  >> --------
      ;       -------- <<  btn3_1  >> btn3_2
      ;       btn3_1 <<  btn3_2  >> btn3_3
      ;       btn3_2 <<  btn3_3  >> --------
      ;       -------- <<  btn3_4  >> btn3_5
      ;       btn3_4 <<  btn3_5  >> btn3_6
      ;       btn3_5 <<  btn3_6  >> --------
      ;       -------- <<  btn3_7  >> btn3_8
      ;       btn3_7 <<  btn3_8  >> btn3_9
      ;       btn3_8 <<  btn3_9  >> --------
      ;       <<----
      
      WaitCloseRoot( )
   EndIf   
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 71
; FirstLine = 59
; Folding = -
; EnableXP