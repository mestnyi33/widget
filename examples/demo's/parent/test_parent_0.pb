IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   
   EnableExplicit
   UseLib(widget)
   
   Global  pos_x = 10
   Global._S_widget *PANEL, *WINDOW, *CONTAINER, *SCROLLAREA, *CONTAINER_0, *SCROLLAREA_0
   Global._S_widget *CHILD, *WINDOW_0, *PANEL0, *PANEL1, *PANEL2, *PANEL_0, *PANEL_1, *PANEL_2
   
   UsePNGImageDecoder()
   
   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
      End
   EndIf
   
   If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   
   Procedure Show_DEBUG( )
      Define line.s
      ;\\
      Debug "---->>"
      ForEach __widgets( )
         ;Debug __widgets( )\class
         line = "  "
         
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
   EndProcedure
   
   If Open(10, 0, 0, 220, 620, "demo set  new parent", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      *PANEL = Panel(10,145,200,160)  : SetClass(*PANEL, "PANEL") 
      AddItem(*PANEL, -1, "item (0)") : *PANEL_0 = Button(pos_x,90,160,30,"(Panel(0))") : SetClass(*PANEL_0, GetText(*PANEL_0))
      AddItem(*PANEL, -1, "item (1)") : *PANEL_1 = Button(pos_x+5,90,160,30,"(Panel(1))") : SetClass(*PANEL_1, GetText(*PANEL_1)) 
      AddItem(*PANEL, -1, "item (2)") : *PANEL_2 = Button(pos_x+10,90,160,30,"(Panel(2))") : SetClass(*PANEL_2, GetText(*PANEL_2)) 
      CloseList()
      
      
;       Show_DEBUG()
      
      OpenList( *PANEL, 2 )
      *CHILD = Button(pos_x,10,160,70,"(CHILD1)") : SetClass(*CHILD, "CHILD1") 
      CloseList( )
      
       Show_DEBUG()
;       
;       OpenList( *PANEL, 1 )
;       *CHILD = Button(pos_x,10,160,70,"(CHILD2)") : SetClass(*CHILD, "CHILD2") 
;       CloseList( )
;       
;       Show_DEBUG()
;       
;       OpenList( *PANEL, 2 )
;       *CHILD = Button(pos_x,10,160,70,"(CHILD3)") : SetClass(*CHILD, "CHILD3") 
;       CloseList( )
;       
;       Show_DEBUG()
;       
;       
;       ;Debug "^"+root()\first\widget\class +" "+ root()\last\widget\class +" "+ root()\last\widget\last\widget\class
;       OpenList( root( ), 0 )
;       *CHILD = Button(pos_x,10,160,70,"(CHILD4)") : SetClass(*CHILD, "CHILD4") 
;       CloseList( )
;       
;       Show_DEBUG()
;       
      WaitClose()
   EndIf
CompilerEndIf
; CompilerIf #PB_Compiler_IsMainFile
;    EnableExplicit
;    UseLib(widget)
;    
;    Global._s_WIDGET *CONT, *but
;    
;    If Open( 0, 0, 0, 600, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
;       ;
;       *CONT = Container( 10, 10, 200, 150) : SetClass(widget( ), "CONT1" ) 
;       Button( 10,5,80,25, "*btn1_1" )  : SetClass(widget( ), "btn1_1" ) 
; ;       Button( 10,35,80,25, "*btn1_2" )  : SetClass(widget( ), "btn1_2" ) 
; ;       Button( 10,65,80,25, "*btn1_3" )  : SetClass(widget( ), "btn1_3" ) 
;       CloseList()
; ;       ;
; ;       Container( 220, 10, 200, 150) : SetClass(widget( ), "CONT2" ) 
; ; ;       Button( 10,5,80,25, "*btn2_1" )  : SetClass(widget( ), "btn2_1" ) 
; ; ;       Button( 10,35,80,25, "*btn2_2" )  : SetClass(widget( ), "btn2_2" ) 
; ; ;       Button( 10,65,80,25, "*btn2_3" )  : SetClass(widget( ), "btn2_3" ) 
; ;       CloseList()
; ;       ;
; ;       Container( 430, 10, 200, 150) : SetClass(widget( ), "CONT3" ) 
; ; ;       Button( 10,5,80,25, "*btn3_1" )  : SetClass(widget( ), "btn3_1" ) 
; ; ;       Button( 10,35,80,25, "btn3_2" )  : SetClass(widget( ), "btn3_2" ) 
; ; ;       Button( 10,65,80,25, "*btn3_3" )  : SetClass(widget( ), "btn3_3" ) 
; ;       CloseList()
;       
;       
;       ; *but = Button( 100,35,80,25, "*btn1_added" ) : SetClass(widget( ), "btn1_added" ) 
;       Button( 100,35,80,25, "*btn77" ) : SetClass(widget( ), "btn77" ) 
;       
;       ;\\
;       ;SetParent( *but, *CONT, 0 )
;       OpenList( *CONT )
;       *but = Button(100,35,80,25,"*btn1_added") : SetClass(*but, "btn1_added") 
;       CloseList( )
;       
;       ;       ;\\
; ;       SetPosition( *but0, #PB_List_Before )
; ;       SetPosition( *but0, #PB_List_Before )
; ;       SetPosition( *but0, #PB_List_Before )
; ;   
;       
;       Debug "----CONT all childrens-----"
;       If StartEnumerate( *CONT )
;          Debug widget( )\text\string
;          
;          StopEnumerate( )
;       EndIf
;       
;       Debug "----all childrens-----"
;       ForEach __widgets( )
;          Debug  __widgets( )\class
;       Next
;       
;       ;\\
;       Define line.s
;       Debug "---->>"
;       ForEach __widgets( )
;          line = "  ";+ __widgets( )\class +" "
;          
;          If __widgets( )\before\widget
;             line + __widgets( )\before\widget\class +" <<  "    ;  +"_"+__widgets( )\before\widget\text\string
;          Else
;             line + "-------- <<  " 
;          EndIf
;          
;          line + __widgets( )\class ; __widgets( )\text\string
;          
;          If __widgets( )\after\widget
;             line +"  >> "+ __widgets( )\after\widget\class ;+"_"+__widgets( )\after\widget\text\string
;          Else
;             line + "  >> --------" 
;          EndIf
;          
;          Debug line
;       Next
;       Debug "<<----"
;       
;      
;       WaitClose( )
;    EndIf   
; CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 59
; FirstLine = 38
; Folding = --
; EnableXP