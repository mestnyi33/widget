
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
      
      ;       Debug "*this - "+*CHILD+" before "+ *CHILD\BeforeWidget( ) +" after "+ *CHILD\AfterWidget( )
      ;       Debug "*after - "+*after+" before "+ *after\BeforeWidget( ) +" after "+ *after\AfterWidget( )
      ;       Debug "*last - "+*last+" before "+ *last\BeforeWidget( ) +" after "+ *last\AfterWidget( )
      Debug "     *after "+ *after\class +" - "+ *last\class +" *last"
   EndProcedure
   
   Procedure Show_DEBUG( )
      Define line.s
      ;\\
      Debug "---->>"
      ForEach widgets( )
         ;Debug widgets( )\class
         line = "  "
         
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
   EndProcedure
   
   Procedure OpenGadget( x,y,width,height )
      Protected *PARENT 
      ;*PARENT = PanelWidget( x,y,width,height*2 ) : AddItem(*PARENT, - 1, "item_0" )
      *PARENT = ContainerWidget( x,y,width,height ) 
      ProcedureReturn *PARENT
   EndProcedure
   
   If OpenRoot(10, 0, 0, 220, 620, "demo set  new parent", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      *PARENT = PanelWidget(10,145,200,160)  : SetWidgetClass(*PARENT, "PANEL") 
      AddItem(*PARENT, -1, "item (0)")
      ;              ;
      ;              OpenGadget(10,10,160,30) : SetWidgetClass(widget(), "(PanelWidget(0))")
      ;              OpenGadget(10,10,160,30) : SetWidgetClass(widget(), "((0>))")
      ;              OpenGadget(10,10,160,30) : SetWidgetClass(widget(), "((0>>))") : CloseWidgetList( )
      ;              CloseWidgetList( )
      ;              CloseWidgetList( )
      ;              ;
      AddItem(*PARENT, -1, "item (1)")
      ;       ;
      ;       OpenGadget(10,10,160,30) : SetWidgetClass(widget(), "(PanelWidget(1))")
      ;       OpenGadget(10,10,160,30) : SetWidgetClass(widget(), "((1>))")
      ;       OpenGadget(10,10,160,30) : SetWidgetClass(widget(), "((1>>))") : CloseWidgetList( )
      ;       CloseWidgetList( )
      ;       CloseWidgetList( )
      ;       ;
      AddItem(*PARENT, -1, "item (2)") ;: *PARENT_2 = ButtonWidget(20,90,160,30,"(PanelWidget(2))") : SetWidgetClass(*PARENT_2, GetWidgetText(*PARENT_2)) 
                                       ;
      OpenGadget(10,10,160,30) : SetWidgetClass(widget(), "(PanelWidget(2))")
      OpenGadget(10,10,160,30) : SetWidgetClass(widget(), "((2>))")
      OpenGadget(10,10,160,30) : SetWidgetClass(widget(), "((2>>))") : CloseWidgetList( )
      CloseWidgetList( )
      CloseWidgetList( )
      
      CloseWidgetList()
      
      ;
      Debug ">"
      OpenWidgetList( *PARENT, 0 )
      OpenGadget(10,10,160,30) : SetWidgetClass(widget(), "(PanelWidget(0))")
      OpenGadget(10,10,160,30) : SetWidgetClass(widget(), "((0>))")
      OpenGadget(10,10,160,30) : SetWidgetClass(widget(), "((0>>))") : CloseWidgetList( )
      CloseWidgetList( )
      CloseWidgetList( )
      CloseWidgetList( )
      Debug "<"
      
      *CHILD = OpenGadget(10,10,160,70) : SetWidgetClass(*CHILD, "CHILD") 
      OpenGadget(10,10,160,70) : SetWidgetClass(widget(), "(CH>)") 
      OpenGadget(10,10,160,70) : SetWidgetClass(widget(), "(CH>>)") 
      ButtonWidget(5,5,70,30,"Button1") : SetWidgetClass(widget(), "(CH>>>0)")  
      ;       ButtonWidget(15,15,70,30,"Button2") : SetWidgetClass(widget(), "(CH>>>1)")  
      ;       ButtonWidget(25,25,70,30,"Button3") : SetWidgetClass(widget(), "(CH>>>2)")  
      CloseWidgetList( )
      CloseWidgetList( )
      CloseWidgetList( )
      ;  
      
      
      Debug "--- enumerate all gadgets ---"
      If StartEnum( root( ) )
         If Not is_window_( widget(  ) )
            Debug "     gadget - "+ widget( )\index +" "+ widget( )\class
         EndIf
         StopEnum( )
      EndIf
      
      Debug "--- enumerate all gadgets PANEL ---"
      If StartEnum( *PARENT )
         Debug "     gadget - "+ widget( )\index +" "+ widget( )\class
         StopEnum( )
      EndIf
      
      Debug "--- enumerate all (item 0) PANEL ---"
      If StartEnum( *PARENT, 0 )
         Debug "     gadget - "+ widget( )\index +" "+ widget( )\class
         StopEnum( )
      EndIf
      
      Debug "--- enumerate all (item 1) PANEL ---"
      If StartEnum( *PARENT, 1 )
         Debug "     gadget - "+ widget( )\index +" "+ widget( )\class
         StopEnum( )
      EndIf
      
      Debug "--- enumerate all (item 2) PANEL ---"
      If StartEnum( *PARENT, 2 )
         Debug "     gadget - "+ widget( )\index +" "+ widget( )\class
         StopEnum( )
      EndIf
      
      WaitCloseRoot()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 57
; FirstLine = 34
; Folding = ---
; EnableXP