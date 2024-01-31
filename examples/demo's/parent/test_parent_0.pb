IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(widget)
   
   Global._s_WIDGET *CONT, *but
   
   If Open( 0, 0, 0, 600, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ;
      *CONT = Container( 10, 10, 200, 150) : SetClass(widget( ), "CONT1" ) 
      Button( 10,5,80,25, "*btn1_1" )  : SetClass(widget( ), "btn1_1" ) 
;       Button( 10,35,80,25, "*btn1_2" )  : SetClass(widget( ), "btn1_2" ) 
;       Button( 10,65,80,25, "*btn1_3" )  : SetClass(widget( ), "btn1_3" ) 
      CloseList()
;       ;
;       Container( 220, 10, 200, 150) : SetClass(widget( ), "CONT2" ) 
; ;       Button( 10,5,80,25, "*btn2_1" )  : SetClass(widget( ), "btn2_1" ) 
; ;       Button( 10,35,80,25, "*btn2_2" )  : SetClass(widget( ), "btn2_2" ) 
; ;       Button( 10,65,80,25, "*btn2_3" )  : SetClass(widget( ), "btn2_3" ) 
;       CloseList()
;       ;
;       Container( 430, 10, 200, 150) : SetClass(widget( ), "CONT3" ) 
; ;       Button( 10,5,80,25, "*btn3_1" )  : SetClass(widget( ), "btn3_1" ) 
; ;       Button( 10,35,80,25, "btn3_2" )  : SetClass(widget( ), "btn3_2" ) 
; ;       Button( 10,65,80,25, "*btn3_3" )  : SetClass(widget( ), "btn3_3" ) 
;       CloseList()
      
      
      *but = Button( 100,35,80,25, "*btn1_added" ) : SetClass(widget( ), "btn1_added" ) 
      Button( 100,35,80,25, "*btn77" ) : SetClass(widget( ), "btn77" ) 
      
      ;\\
      SetParent( *but, *CONT, 0 )
      
      ;       ;\\
;       SetPosition( *but0, #PB_List_Before )
;       SetPosition( *but0, #PB_List_Before )
;       SetPosition( *but0, #PB_List_Before )
;   
      
      Debug "----CONT all childrens-----"
      If StartEnumerate( *CONT )
         Debug widget( )\text\string
         
         StopEnumerate( )
      EndIf
      
      Debug "----all childrens-----"
      ForEach __widgets( )
         Debug  __widgets( )\class
      Next
      
      ;\\
      Define line.s
      Debug "---->>"
      ForEach __widgets( )
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
      
     
      WaitClose( )
   EndIf   
CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 33
; FirstLine = 16
; Folding = -
; EnableXP