IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_WIDGET *panel1
   
   If OpenRootWidget( 0, 0, 0, 220, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
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
      
      WaitCloseRootWidget( )
   EndIf   
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 41
; FirstLine = 28
; Folding = -
; EnableXP