IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_WIDGET *panel1, *but0
   
   If Open( 0, 0, 0, 400, 170, "( openlist( ) ) add object in PANEL item", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ;
      *panel1 = Panel( 10, 10, 200, 150) : SetClass(widget( ), "CONT1" ) 
      ;
      AddItem(*panel1, -1, "item1" )
      Button( 10,5,80,25, "*btn1_1" )  : SetClass(widget( ), "btn1_1" ) 
      Button( 10,35,80,25, "*btn1_2" )  : SetClass(widget( ), "btn1_2" ) 
      Button( 10,65,80,25, "*btn1_3" )  : SetClass(widget( ), "btn1_3" ) 
      ;
      AddItem(*panel1, -1, "item2" )
      Button( 10,5,80,25, "*btn2_4" )  : SetClass(widget( ), "btn2_4" ) 
      Button( 10,35,80,25, "*btn2_5" )  : SetClass(widget( ), "btn2_5" ) 
      Button( 10,65,80,25, "*btn2_6" )  : SetClass(widget( ), "btn2_6" ) 
      ;
      AddItem(*panel1, -1, "item3" )
      Button( 10,5,80,25, "*btn3_7" )  : SetClass(widget( ), "btn3_7" ) 
      Button( 10,35,80,25, "*btn3_8" )  : SetClass(widget( ), "btn3_8" ) 
      Button( 10,65,80,25, "*btn3_9" )  : SetClass(widget( ), "btn3_9" ) 
      ;
      CloseList()
      
      ;\\ test
      OpenList( *panel1, 0 )
      *but0 = Button( 100,35,80,25, "*btn1_added" ) : SetClass(widget( ), "btn1_added" ) 
      CloseList( )
      
      ;\\
      Debug "----panel all childrens-----"
      If StartEnum( *panel1 )
         Debug widget( )\txt\string
         
         StopEnum( )
      EndIf
      
      ;\\ 
      Define line.s
      Debug "---->>"
      ForEach widgets( )
         line = "  ";+ widgets( )\class +" "
         
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

      
      WaitClose( )
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 58
; FirstLine = 45
; Folding = -
; EnableXP