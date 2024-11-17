
XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   
   EnableExplicit
   UseWidgets( )
   
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
   
   Procedure OpenGadget( x,y,width,height )
      Protected *PARENT 
      ;*PARENT = PanelWidget( x,y,width,height*2 ) : AddItem(*PARENT, - 1, "item_0" )
      *PARENT = ContainerWidget( x,y,width,height ) 
      ProcedureReturn *PARENT
   EndProcedure
   
   If OpenRootWidget(10, 0, 0, 220, 620, "demo set  new parent", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      OpenGadget(10,10,160,30) : SetWidgetClass(widget(), "(Window)")
      ButtonWidget(5,5,70,30,"Button1") : SetWidgetClass(widget(), "(w>0)")  
      ButtonWidget(15,15,70,30,"Button2") : SetWidgetClass(widget(), "(w>1)")  
      ButtonWidget(25,25,70,30,"Button3") : SetWidgetClass(widget(), "(w>2)")  
      
      OpenGadget(10,10,160,30) : SetWidgetClass(widget(), "(Container)")
      ButtonWidget(5,5,70,30,"Button1") : SetWidgetClass(widget(), "(c>0)")  
      ButtonWidget(15,15,70,30,"Button2") : SetWidgetClass(widget(), "(c>1)")  
      ButtonWidget(25,25,70,30,"Button3") : SetWidgetClass(widget(), "(c>2)")  
      
      *PARENT = OpenGadget(10,10,160,30) : SetWidgetClass(widget(), "(ScrollArea)")
      ButtonWidget(5,5,70,30,"Button1") : SetWidgetClass(widget(), "(s>0)")  
      ButtonWidget(15,15,70,30,"Button2") : SetWidgetClass(widget(), "(s>1)")  
      ButtonWidget(25,25,70,30,"Button3") : SetWidgetClass(widget(), "(s>2)")  
      CloseWidgetList( )
      
      CloseWidgetList( )
      
      CloseWidgetList()
      
      ButtonWidget(5,5,70,30,"Button1") : SetWidgetClass(widget(), "(r>0)")  
      ButtonWidget(15,15,70,30,"Button2") : SetWidgetClass(widget(), "(r>1)")  
      ButtonWidget(25,25,70,30,"Button3") : SetWidgetClass(widget(), "(r>2)")  
      ;  
      
      
      Debug "--- enumerate all gadgets ---"
      If StartEnum( root( ) )
         If Not is_window_( widget(  ) )
         Debug "     gadget - "+ widget( )\index +" "+ widget( )\class +"               ("+ widget( )\parent\class +") " ;+" - ("+ widget( )\text\string +")"
      EndIf
         StopEnum( )
      EndIf
      
      Debug "--- enumerate all gadgets ScrollArea ---"
      If StartEnum( *PARENT )
         Debug "     gadget - "+ widget( )\index +" "+ widget( )\class +"               ("+ widget( )\parent\class +") " ;+" - ("+ widget( )\text\string +")"
         StopEnum( )
      EndIf
      
      ; Show_DEBUG()
      
      WaitCloseRootWidget()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 112
; FirstLine = 91
; Folding = ---
; EnableXP
; DPIAware