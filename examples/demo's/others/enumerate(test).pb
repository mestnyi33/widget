
XIncludeFile "../../../widgets.pbi" 
;Macro widget( ) : enumwidget( ) : EndMacro

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
   
   
   
   Macro StartEnumerate2( _parent_, _item_ = #PB_All )
         Bool( _parent_\haschildren And _parent_\FirstWidget( ) )
         PushListPosition( __widgets( ) )
         ;
         If _parent_\FirstWidget( )\address
            ChangeCurrentElement( __widgets( ), _parent_\FirstWidget( )\address )
         Else
            ResetList( __widgets( ) )
         EndIf
         ;
;          ;\\
;          If _item_ > 0
;             Repeat
;                If __widgets( ) = _parent_\AfterWidget( ) 
;                   Break
;                EndIf
;                If __widgets( )\root <> _parent_\root
;                   Break    
;                EndIf
;                If __widgets( )\parent = _parent_  
;                   If __widgets( )\TabIndex( ) = _item_
;                      Break
;                   EndIf
;                EndIf
;             Until Not NextElement( __widgets( ) ) 
;          EndIf
;          ;
         ;\\
         If __widgets( )\parent = _parent_
            Repeat
               If __widgets( ) = _parent_\AfterWidget( ) 
                  Debug 666
                  Break
               EndIf
               If __widgets( )\root <> _parent_\root
                  Debug 777
                  Break    
               EndIf
               
               If  __widgets( )\level < _parent_\level
                  Debug 111
                  Break
               EndIf
               
               If _item_ >= 0 And 
                  __widgets( )\parent = _parent_ And 
                  _item_ <> __widgets( )\TabIndex( )
                  Debug 888
                  Break
               EndIf
               ;
               widget( ) = __widgets( )
            EndMacro
            ;
            Macro AbortEnumerate2( )
               Break
            EndMacro
            ;
            Macro StopEnumerate2( )
            Until Not NextElement( __widgets( ) )
         EndIf
         PopListPosition( __widgets( ) )
      EndMacro
      
   If Open(10, 0, 0, 220, 620, "demo set  new parent", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      OpenGadget(10,10,160,30) : SetClass(widget(), "(Window)")
      Button(5,5,70,30,"Button1") : SetClass(widget(), "(w>0)")  
;       Button(15,15,70,30,"Button2") : SetClass(widget(), "(w>1)")  
;       Button(25,25,70,30,"Button3") : SetClass(widget(), "(w>2)")  
      
      *PARENT = OpenGadget(10,10,160,30) : SetClass(widget(), "(ScrollArea)")
      Button(5,5,70,30,"Button1") : SetClass(widget(), "(s>0)")  
;       Button(15,15,70,30,"Button2") : SetClass(widget(), "(s>1)")  
;       Button(25,25,70,30,"Button3") : SetClass(widget(), "(s>2)")  
      CloseList( )
      
      CloseList()
      
      Button(5,5,70,30,"Button1") : SetClass(widget(), "(r>0)")  
;       Button(15,15,70,30,"Button2") : SetClass(widget(), "(r>1)")  
;       Button(25,25,70,30,"Button3") : SetClass(widget(), "(r>2)")  
;       ;  
      
      
      Debug "--- enumerate all gadgets ---"
      If StartEnumerate( root( ) )
         If Not is_window_( enumWidget( ) )
         Debug "     gadget - "+ enumWidget()\index +" "+ enumWidget()\class +"               ("+ enumWidget()\parent\class +") " ;+" - ("+ enumWidget()\text\string +")"
      EndIf
         StopEnumerate( )
      EndIf
      
      Debug "--- enumerate all gadgets PANEL ---"
      If StartEnumerate2( *PARENT )
         Debug "     gadget - "+ enumWidget()\index +" "+ enumWidget()\class +"               ("+ enumWidget()\parent\class +") " ;+" - ("+ enumWidget()\text\string +")"
         StopEnumerate2( )
      EndIf
      
      Show_DEBUG()
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 97
; FirstLine = 57
; Folding = f--
; EnableXP