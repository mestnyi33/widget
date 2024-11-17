IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_WIDGET *panel1, *but0
   
   If OpenRootWidget( 0, 0, 0, 400, 170, "( OpenWidgetList( ) ) add object in PANEL item", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ;
      *panel1 = PanelWidget( 10, 10, 200, 150) : SetWidgetClass(widget( ), "CONT1" ) 
      ;
      AddItem(*panel1, -1, "item1" )
      ButtonWidget( 10,5,80,25, "*btn1_1" )  : SetWidgetClass(widget( ), "btn1_1" ) 
      ButtonWidget( 10,35,80,25, "*btn1_2" )  : SetWidgetClass(widget( ), "btn1_2" ) 
      ButtonWidget( 10,65,80,25, "*btn1_3" )  : SetWidgetClass(widget( ), "btn1_3" ) 
      ;
      AddItem(*panel1, -1, "item2" )
      ButtonWidget( 10,5,80,25, "*btn2_4" )  : SetWidgetClass(widget( ), "btn2_4" ) 
      ButtonWidget( 10,35,80,25, "*btn2_5" )  : SetWidgetClass(widget( ), "btn2_5" ) 
      ButtonWidget( 10,65,80,25, "*btn2_6" )  : SetWidgetClass(widget( ), "btn2_6" ) 
      ;
      AddItem(*panel1, -1, "item3" )
      ButtonWidget( 10,5,80,25, "*btn3_7" )  : SetWidgetClass(widget( ), "btn3_7" ) 
      ButtonWidget( 10,35,80,25, "*btn3_8" )  : SetWidgetClass(widget( ), "btn3_8" ) 
      ButtonWidget( 10,65,80,25, "*btn3_9" )  : SetWidgetClass(widget( ), "btn3_9" ) 
      ;
      CloseWidgetList()
      
      ;\\ test
      *but0 = ButtonWidget( 100,35,80,25, "*btn2_added" ) : SetWidgetClass(widget( ), "btn2_added" ) 
      SetParent( *but0, *panel1, 1 )
      
      ;\\ test
      OpenWidgetList( *panel1, 0 )
      *but0 = ButtonWidget( 100,35,80,25, "*btn1_added" ) : SetWidgetClass(widget( ), "btn1_added" ) 
      CloseWidgetList( )
      
      ;\\
      Debug "----panel all childrens-----"
      If StartEnum( *panel1 )
         Debug widget( )\text\string
         
         StopEnum( )
      EndIf
      
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
      ;       ----panel all childrens-----
      ;       *btn1_1
      ;       *btn1_2
      ;       *btn1_3
      ;       *btn1_added
      ;       *btn2_4
      ;       *btn2_5
      ;       *btn2_6
      ;       *btn3_7
      ;       *btn3_8
      ;       *btn3_9
      ;       ---->>
      ;       -------- <<  CONT1  >> --------
      ;       -------- <<  btn1_1  >> btn1_2
      ;       btn1_1 <<  btn1_2  >> btn1_3
      ;       btn1_2 <<  btn1_3  >> btn1_added
      ;       btn1_3 <<  btn1_added  >> --------
      ;       -------- <<  btn2_4  >> btn2_5
      ;       btn2_4 <<  btn2_5  >> btn2_6
      ;       btn2_5 <<  btn2_6  >> --------
      ;       -------- <<  btn3_7  >> btn3_8
      ;       btn3_7 <<  btn3_8  >> btn3_9
      ;       btn3_8 <<  btn3_9  >> --------
      ;       <<----

      
      WaitCloseRootWidget( )
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 62
; FirstLine = 37
; Folding = -
; EnableXP
; DPIAware