
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   
   EnableExplicit
   UseWidgets( )
   
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
   
   If OpenRootWidget(10, 0, 0, 220, 620, "demo set  new parent", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ;ButtonWidget(10,10,80,20,"((0>>))") : SetWidgetClass(widget(), "((0>>))") 
      *CHILD1 = ButtonWidget(10,10,80,20,"((1>>))") : SetWidgetClass(widget(), "((1>>))") 
      *CHILD2 = ButtonWidget(10,30,80,20,"((2>>))") : SetWidgetClass(widget(), "((2>>))") 
      
      Show_DEBUG()
      
;       ;\\ test 1 ok
;       *PARENT = ContainerWidget( 10, 60, 150, 150)
;       SetParent( *CHILD1, *PARENT )
;       SetParent( *CHILD2, *PARENT )
      
      ;\\ test 2
     *PARENT = SplitterWidget( 10, 60, 150, 150, *CHILD1, *CHILD2 )
      
      Debug ""+*PARENT\first\widget\class
      Debug ""+*PARENT\last\widget\class
      
      Show_DEBUG()
      
      
      WaitCloseRootWidget()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 41
; FirstLine = 37
; Folding = --
; EnableXP
; DPIAware