
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   
   EnableExplicit
   UseLib(widget)
   
   Global  pos_x = 10
   Global._S_widget *PARENT, *WINDOW, *CONTAINER, *SCROLLAREA, *CONTAINER_0, *SCROLLAREA_0
   Global._S_widget *CHILD, *WINDOW_0, *PARENT0, *PARENT1, *PARENT2, *PARENT_0, *PARENT_1, *PARENT_2
   
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
      
      If *after\parent <> *parent ;And *after\LastWidget( )\AddedTabIndex( ) > tabindex
         *last = *after
      Else
         *last = GetPositionLast( *after, tabindex )
      EndIf
      
;       Debug "*this - "+*CHILD+" before "+ *CHILD\before\widget +" after "+ *CHILD\after\widget
;       Debug "*after - "+*after+" before "+ *after\before\widget +" after "+ *after\after\widget
;       Debug "*last - "+*last+" before "+ *last\before\widget +" after "+ *last\after\widget
       Debug "     *after "+ *after\class +" - "+ *last\class +" *last"
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
   
   Procedure OpenGadget( x,y,width,height )
      Protected *PARENT 
      ;*PARENT = Panel( x,y,width,height*2 ) : AddItem(*PARENT, - 1, "item_0" )
      *PARENT = Container( x,y,width,height ) 
      ProcedureReturn *PARENT
   EndProcedure
   
   If Open(10, 0, 0, 220, 620, "demo set  new parent", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      *PARENT = Panel(10,145,200,160)  : SetClass(*PARENT, "PANEL") 
      AddItem(*PARENT, -1, "item (0)")
      ;              ;
      ;              OpenGadget(10,90,160,30) : SetClass(widget(), "(Panel(0))")
      ;              OpenGadget(10,90,160,30) : SetClass(widget(), "((0>))")
      ;              OpenGadget(10,90,160,30) : SetClass(widget(), "((0>>))") : CloseList( )
      ;              CloseList( )
      ;              CloseList( )
      ;              ;
      AddItem(*PARENT, -1, "item (1)")
      ;
      OpenGadget(10,90,160,30) : SetClass(widget(), "(Panel(1))")
      OpenGadget(10,90,160,30) : SetClass(widget(), "((1>))")
      OpenGadget(10,90,160,30) : SetClass(widget(), "((1>>))") : CloseList( )
      CloseList( )
      CloseList( )
      ;
      AddItem(*PARENT, -1, "item (2)") ;: *PARENT_2 = Button(20,90,160,30,"(Panel(2))") : SetClass(*PARENT_2, GetText(*PARENT_2)) 
                                      ;
      OpenGadget(10,90,160,30) : SetClass(widget(), "(Panel(2))")
      OpenGadget(10,90,160,30) : SetClass(widget(), "((2>))")
      OpenGadget(10,90,160,30) : SetClass(widget(), "((2>>))") : CloseList( )
      CloseList( )
      CloseList( )
      
      CloseList()
      
      ;
      Debug ">"
      OpenList( *PARENT, 0 )
      OpenGadget(10,90,160,30) : SetClass(widget(), "(Panel(0))")
      OpenGadget(10,90,160,30) : SetClass(widget(), "((0>))")
      OpenGadget(10,90,160,30) : SetClass(widget(), "((0>>))") : CloseList( )
      CloseList( )
      CloseList( )
      CloseList( )
      Debug "<"
      
      *CHILD = OpenGadget(10,10,160,70) : SetClass(*CHILD, "CHILD") 
      OpenGadget(10,10,160,70) : SetClass(widget(), "(CH>)") 
      OpenGadget(10,10,160,70) : SetClass(widget(), "(CH>>)") 
      Button(5,5,70,30,"Button1") : SetClass(widget(), "(CH>>>0)")  
      ;       Button(15,15,70,30,"Button2") : SetClass(widget(), "(CH>>>1)")  
      ;       Button(25,25,70,30,"Button3") : SetClass(widget(), "(CH>>>2)")  
      CloseList( )
      CloseList( )
      CloseList( )
      ;  
      
      
      Show_DEBUG()
      
      SetParent(*CHILD, *PARENT, 0) : Show_DEBUG()
      
      SetParent(*CHILD, *PARENT, 1) : Show_DEBUG()
      
      SetParent(*CHILD, *PARENT, 2) : Show_DEBUG()
      
      SetParent(*CHILD, *PARENT, 1) : Show_DEBUG()
      
      SetParent(*CHILD, *PARENT, 0) : Show_DEBUG()
      
      SetParent(*CHILD, root( )) : Show_DEBUG()
      
      
      
     
;       ; test - 1 bug - fixed
;       SetParent(*CHILD, *PARENT, 0) : Show_DEBUG()
;       SetParent(*CHILD, *PARENT, 1) : Show_DEBUG()
;       SetParent(*CHILD, *PARENT, 0) : Show_DEBUG()
;     
;       ; test - 2 good
;       SetParent(*CHILD, *PARENT, 0) : Show_DEBUG()
;       SetParent(*CHILD, *PARENT, 1) : Show_DEBUG()
;       SetParent(*CHILD, *PARENT, 2) : Show_DEBUG()
;       SetParent(*CHILD, *PARENT, 0) : Show_DEBUG()
;     
;       ; test - 3 bug
;       SetParent(*CHILD, *PARENT, 2) : Show_DEBUG()
;       SetParent(*CHILD, root( )) : Show_DEBUG()
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 2
; Folding = f-
; EnableXP
; DPIAware