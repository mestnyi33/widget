
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
         
         If widgets( )\beforeWidget( )
            line + widgets( )\beforeWidget( )\class +" <<  "    ;  +"_"+widgets( )\BeforeWidget( )\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\text\string
         
         If widgets( )\afterWidget( )
            line +"  >> "+ widgets( )\afterWidget( )\class ;+"_"+widgets( )\AfterWidget( )\text\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      Next
      Debug "<<----"
   EndProcedure
   
   Procedure OpenGadget( X,Y,Width,Height )
      Protected *PARENT 
      ;*PARENT = Panel( x,y,width,height*2 ) : AddItem(*PARENT, - 1, "item_0" )
      *PARENT = Container( X,Y,Width,Height ) 
      ProcedureReturn *PARENT
   EndProcedure
   
   
   
   Macro StartEnum2( _parent_, _item_ = #PB_All )
         Bool( _parent_\haschildren And _parent_\FirstWidget( ) )
         PushListPosition( widgets( ) )
         ;
         If _parent_\FirstWidget( )\address
            ChangeCurrentElement( widgets( ), _parent_\FirstWidget( )\address )
         Else
            ResetList( widgets( ) )
         EndIf
         ;
;          ;\\
;          If _item_ > 0
;             Repeat
;                If widgets( ) = _parent_\AfterWidget( ) 
;                   Break
;                EndIf
;                If widgets( )\root <> _parent_\root
;                   Break    
;                EndIf
;                If widgets( )\parent = _parent_  
;                   If widgets( )\TabIndex( ) = _item_
;                      Break
;                   EndIf
;                EndIf
;             Until Not NextElement( widgets( ) ) 
;          EndIf
;          ;
         ;\\
         If widgets( )\parent = _parent_
            Repeat
               If widgets( ) = _parent_\AfterWidget( ) 
                  Debug 666
                  Break
               EndIf
               If widgets( )\root <> _parent_\root
                  Debug 777
                  Break    
               EndIf
               
               If  widgets( )\level < _parent_\level
                  Debug 111
                  Break
               EndIf
               
               If _item_ >= 0 And 
                  widgets( )\parent = _parent_ And 
                  _item_ <> widgets( )\TabIndex( )
                  Debug 888
                  Break
               EndIf
               ;
               widget( ) = widgets( )
            EndMacro
            ;
            Macro AbortEnumerate2( )
               Break
            EndMacro
            ;
            Macro StopEnum2( )
            Until Not NextElement( widgets( ) )
         EndIf
         PopListPosition( widgets( ) )
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
      If StartEnum( root( ) )
         If Not is_window_( widget(  ) )
         Debug "     gadget - "+ widget( )\index +" "+ widget( )\class +"               ("+ widget( )\parent\class +") " ;+" - ("+ widget( )\text\string +")"
      EndIf
         StopEnum( )
      EndIf
      
      Debug "--- enumerate2 all gadgets PANEL ---"
      If StartEnum2( *PARENT )
         Debug "     gadget - "+ widget( )\index +" "+ widget( )\class +"               ("+ widget( )\parent\class +") " ;+" - ("+ widget( )\text\string +")"
         StopEnum2( )
      EndIf
      
      Show_DEBUG()
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 57
; FirstLine = 29
; Folding = ---
; EnableXP
; DPIAware