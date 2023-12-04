XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  UsePNGImageDecoder()
  
  Global *window
  
  Procedure   SetParent2( *this._S_widget, *parent._S_widget, tabindex.l = 0 )
      Protected ReParent.b, x,y, *last._S_widget, *lastParent._S_widget, NewList *D._S_widget( ), NewList *C._S_widget( )
      
      If *parent
        If *this\parent = *parent And
           *this\TabIndex( ) = tabindex
          ProcedureReturn #False
        EndIf
        
        ;TODO
        If tabindex < 0 
          If *parent\TabBox( )
            tabindex = *parent\TabBox( )\OpenedTabIndex( )
          Else
            tabindex = 0
          EndIf
          
        ElseIf tabindex
          If *parent\type = #__type_Splitter
            If tabindex%2
              *parent\split_1(  ) = *this
              *parent\split_1_is(  ) = Bool( PB(IsGadget)( *this ))
              Update( *parent )
              If *parent\split_1_is(  )
                ProcedureReturn 0
              EndIf
            Else
              *parent\split_2(  ) = *this
              *parent\split_2_is(  ) = Bool( PB(IsGadget)( *this ))
              Update( *parent )
              If *parent\split_2_is(  )
                ProcedureReturn 0
              EndIf
            EndIf    
          EndIf    
        EndIf
        
        *this\TabIndex( ) = tabindex
        
        ; set hide state 
        If *parent\TabBox( )
          ; hide all children except the selected tab
          *this\hide = Bool( *parent\TabBox( )\OpenedTabIndex( ) <> tabindex)
        Else
          *this\hide = *parent\hide
        EndIf
        
        If *parent\last\widget
          *last = GetLast( *parent, tabindex )
          
        EndIf
        
        If *this And 
           *this\parent
          
          If *this\address
            *lastParent = *this\parent
            *lastParent\haschildren - 1
            
            ChangeCurrentElement(  *this\_widgets( ), *this\address )
            AddElement( *D( ) ) : *D( ) =  *this\_widgets( )
            
            If *this\haschildren
              PushListPosition(  *this\_widgets( ) )
              While NextElement(  *this\_widgets( ) )
                If Not IsChild(  *this\_widgets( ), *this ) 
                  Break
                EndIf
                
                AddElement( *D( ) )
                *D( ) =  *this\_widgets( )
                *D( )\window = *parent\window
                *D( )\root = *parent\root
                ;; Debug " children - "+ *D( )\data +" - "+ *this\data
                
              Wend 
              PopListPosition(  *this\_widgets( ) )
            EndIf
            
            ; move with a parent and his children
            If *this\root = *parent\root
              ; move inside the list
              LastElement( *D( ) )
              Repeat
                ChangeCurrentElement(  *this\_widgets( ), *D( )\address )
                MoveElement(  *this\_widgets( ), #PB_List_After, *last\address )
              Until PreviousElement( *D( ) ) = #False
            Else
              ForEach *D( )
                ChangeCurrentElement(  *this\_widgets( ), *D( )\address )
                ; go to the end of the list to split the list
                MoveElement(  *this\_widgets( ), #PB_List_Last ) 
              Next
              
              ; now we split the list and transfer it to another list
              ChangeCurrentElement(  *this\_widgets( ), *this\address )
              SplitList(  *this\_widgets( ), *D( ) )
              
              ; move between lists
              ChangeCurrentElement( *parent\_widgets( ) , *last\address )
              MergeLists( *D( ), *parent\_widgets( ) , #PB_List_After )
            EndIf
            
            ReParent = #True 
          EndIf
          
          ; position in list
          If *this\after\widget
            *this\after\widget\before\widget = *this\before\widget
          EndIf
          If *this\before\widget
            *this\before\widget\after\widget = *this\after\widget
          EndIf
          If *this\parent\first\widget = *this
            ;             If *this\after\widget
            *this\parent\first\widget = *this\after\widget
            ;             Else
            ;               *this\parent\first\widget = *this\parent ; if last type
            ;             EndIf
          EndIf 
          If *this\parent\last\widget = *this
            If *this\before\widget
              *this\parent\last\widget = *this\before\widget
            Else
              *this\parent\last\widget = *this\parent ; if last type
            EndIf
          EndIf 
        Else
          If *parent\root
            If *last
              ChangeCurrentElement( *parent\_widgets( ) , *last\address )
            Else
              LastElement( *parent\_widgets( )  )
            EndIf
            
            AddElement( *parent\_widgets( )  ) 
            *parent\_widgets( )  = *this
            *this\index = ListIndex( *parent\_widgets( )  ) 
            *this\address = @*parent\_widgets( ) 
          EndIf
          
          *this\last\widget = *this ; if last type
        EndIf
        
        If *parent\last\widget = *parent
          *parent\first\widget = *this
          *parent\last\widget = *this
          *this\before\widget = #Null
          *this\after\widget = #Null
        Else
          ; if the parent had the last item
          ; then we make it "previous" instead of "present"
          ; and "present" becomes "subsequent" instead of "previous"
          If *this\parent
            *this\before\widget = *last
            ; for the panel element
            If *last\TabIndex( ) = *this\TabIndex( )
              *this\after\widget = *last\after\widget
            EndIf
          Else
            ; for the panel element
            If *parent\last\widget And *parent\last\widget\TabIndex( ) = *this\TabIndex( )
              *this\before\widget = *parent\last\widget
            EndIf
            *parent\last\widget = *this
            *this\after\widget = #Null
          EndIf
          If *this\before\widget
            *this\before\widget\after\widget = *this
          EndIf
        EndIf
        
        
        ;           
        *parent\haschildren + 1
        If *parent <> *parent\root
          *parent\root\haschildren + 1
        EndIf
        
        ;
        *this\root = *parent\root
        If is_window_( *parent ) 
          *this\window = *parent
        Else
          *this\window = *parent\window
        EndIf
        *this\parent = *parent
        
        ;
        *this\level = *parent\level + 1
        ;*this\count\parents = *parent\count\parents + 1
        
        
        ; TODO
        If *this\window
          Static NewMap typecount.l( )
          
          *this\count\index = typecount( Hex( *this\window + *this\type ))
          typecount( Hex( *this\window + *this\type )) + 1
          
          If *parent\anchors
            *this\count\type = typecount( Hex( *parent ) + "_" + Hex( *this\type ))
            typecount( Hex( *parent ) + "_" + Hex( *this\type )) + 1
          EndIf
        EndIf
        
;         ; set transformation for the child
;         If Not *this\_a_\transform And *parent\_a_\transform 
;           a_set_transform_state_( *this, Bool( *parent\_a_\transform ) )
;           
;           *this\_a_\mode = #__a_full | #__a_position
;           a_set( *this, #__a_size )
;         EndIf
        
        ;
        If ReParent
          ; resize
          x = *this\x[#__c_container]
          y = *this\y[#__c_container]
          
          ; for the scrollarea container children
          ; if new parent - scrollarea container
          If *parent\scroll And *parent\scroll\v And *parent\scroll\h
            x - *parent\scroll\h\bar\page\pos
            y - *parent\scroll\v\bar\page\pos
          EndIf
          ; if last parent - scrollarea container
          If *LastParent\scroll And *LastParent\scroll\v And *LastParent\scroll\h
            x + *LastParent\scroll\h\bar\page\pos
            y + *LastParent\scroll\v\bar\page\pos
          EndIf
          
          Resize( *this, x - *parent\scroll_x(  ), y - *parent\scroll_y(  ), #PB_Ignore, #PB_Ignore )
          
;           If *this\root\canvas\ResizeBeginWidget
;             ; Debug "   end - resize " + #PB_Compiler_Procedure
;             Post( *this\root\canvas\ResizeBeginWidget, #PB_EventType_ResizeEnd )
;             *this\root\canvas\ResizeBeginWidget = #Null
;           EndIf
          
          PostEventCanvasRepaint( *parent )
          PostEventCanvasRepaint( *lastParent )
          
          ;           ChangeCurrentRoot(*parent\root\canvas\address)
          ;           ReDraw(Root())
          ;           ChangeCurrentRoot(*lastParent\root\canvas\address)
          ;           ReDraw(Root())
          
        EndIf
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Open(#PB_Any, 150, 150, 500, 400, "demo close", #__Window_SizeGadget | #__Window_SystemMenu)
  Define *root._S_root = root()
  Define *widget._S_WIDGET
  
  *window = Window(100,100,200,200,"window", #__window_systemmenu|#__window_maximizegadget|#__window_minimizegadget)
  ;   AddElement(*root\_widgets( ))
  ;   *root\_widgets( ) = AllocateStructure(_S_WIDGET)
  ;   *root\_widgets( )\_root() = *root
  ;   *root\_widgets( )\_parent() = *root
  ;   *root\_widgets( )\class="button1"
  ;   *root\haschildren + 1
  ;*window = Button(10, 10, 90,30,"button")
  Free(*window)
;  *widget = AllocateStructure(_S_WIDGET)
;  *widget\class="button2"
; ;  AddElement(*root\_widgets( )) 
; ;   *root\_widgets( ) = *widget
; ;   *root\_widgets( )\_root() = *root
; ;   *root\_widgets( )\_parent() = *root
; ;    *root\haschildren + 1
;   SetParent2(*widget, *root)
  
  ;Debug Root()\last\widget
  *window = Button(10, 10, 90,30,"button")
  
  Debug " >> "
  ForEach widget()
    Debug widget()\class
  Next
  Debug "<<"
  
  
    
  
  LastElement( *root\_widgets( )) 
    Repeat   
      If *root\_widgets( )\root\canvas\gadget = *root\canvas\gadget And *root\_widgets( ) < 0
        
        Break
      EndIf
    Until PreviousElement( *root\_widgets( )) = #False 
  
  WaitClose()
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 285
; FirstLine = 256
; Folding = -------
; EnableXP