
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_WIDGET *panel1, *but0
   
   If OpenRootWidget( 0, 0, 0, 220, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ;
      *panel1 = PanelWidget( 10, 10, 200, 150) : SetWidgetClass(widget( ), "CONT1" ) 
      AddItem(*panel1, -1, "item0" )
      ;
      AddItem(*panel1, -1, "item1" )
      ButtonWidget( 10,5,80,25, "*btn1_1" )  : SetWidgetClass(widget( ), "btn1_1" ) 
      ;ButtonWidget( 10,35,80,25, "*btn1_2" )  : SetWidgetClass(widget( ), "btn1_2" ) 
      ;ButtonWidget( 10,65,80,25, "*btn1_3" )  : SetWidgetClass(widget( ), "btn1_3" ) 
      ;
      AddItem(*panel1, -1, "item2" )
      ButtonWidget( 10,5,80,25, "*btn2_4" )  : SetWidgetClass(widget( ), "btn2_4" ) 
      ;ButtonWidget( 10,35,80,25, "*btn2_5" )  : SetWidgetClass(widget( ), "btn2_5" ) 
      ;ButtonWidget( 10,65,80,25, "*btn2_6" )  : SetWidgetClass(widget( ), "btn2_6" ) 
      ;
      AddItem(*panel1, -1, "item3" )
      ButtonWidget( 10,5,80,25, "*btn3_7" )  : SetWidgetClass(widget( ), "btn3_7" ) 
      ;ButtonWidget( 10,35,80,25, "*btn3_8" )  : SetWidgetClass(widget( ), "btn3_8" ) 
      ;ButtonWidget( 10,65,80,25, "*btn3_9" )  : SetWidgetClass(widget( ), "btn3_9" ) 
      ;
      CloseWidgetList()
      
      ;\\ test 
      OpenWidgetList( *panel1, 0 )
      Debug " reParent "
      *but0 = ButtonWidget( 100,35,80,25, "*btn0_added" ) : SetWidgetClass(widget( ), "btn0_added" ) 
      CloseWidgetList( )
      
;       *butt0 = ButtonWidget( 20,25,80,35, "*btn0_added" ) : SetWidgetClass(widget( ), "btn0_added" ) 
;        Debug " reparent "
;        SetParent( *butt0, *panel1, 0 )
      
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
      
      
      WaitCloseRootWidget( )
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 65
; FirstLine = 52
; Folding = -
; EnableXP