
XIncludeFile "../../../widgets.pbi" 
;Macro widget( ) : enumwidget( ) : EndMacro

CompilerIf #PB_Compiler_IsMainFile
   
   EnableExplicit
   UseLib(widget)
   
   Global  pos_x = 10
   Global._S_widget *PARENT, *CHILD1, *CHILD2
   
   UsePNGImageDecoder()
   
   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
      End
   EndIf
   
   If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   
   Procedure Last( *parent._s_WIDGET, tabindex )
      Define._s_WIDGET *last, *after
      
      *after = GetPositionAfter( *parent, tabindex )
      ;*last = GetPositionLast( *after, tabindex )
      
      If *after\parent <> *parent And *after\LastWidget( )\TabIndex( ) > tabindex
         *last = *after
      Else
         *last = GetPositionLast( *after, tabindex )
      EndIf
      
      Debug "after "+ *after\class
      ; Debug "*last "+ *last\class
   EndProcedure
   
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
      ;Button(10,10,80,20,"((0>>))") : SetClass(widget(), "((0>>))") 
      *CHILD1 = Button(10,10,80,20,"((1>>))") : SetClass(widget(), "((1>>))") 
      *CHILD2 = Button(10,30,80,20,"((2>>))") : SetClass(widget(), "((2>>))") 
      
      Show_DEBUG()
      
;       ;\\ test 1 ok
;       *PARENT = Container( 10, 60, 150, 150)
;       SetParent( *CHILD1, *PARENT )
;       SetParent( *CHILD2, *PARENT )
      
      ;\\ test 2
     *PARENT = Splitter( 10, 60, 150, 150, *CHILD1, *CHILD2 )
      
      Debug ""+*PARENT\first\widget\class
      Debug ""+*PARENT\last\widget\class
      
      Show_DEBUG()
      
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 28
; FirstLine = 9
; Folding = f-
; EnableXP