; 
; demo state

IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, *g1._s_WIDGET,*g2, g1,g2, CountItems=21; количесвто итемов 
   
   Procedure TreeGadget_(gadget, X,Y,Width,Height,flag=0)
      Protected g = PB(TreeGadget)(gadget, X,Y,Width,Height,flag)
      If gadget =- 1 : gadget = g : EndIf
      
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
         Define RowHeight.CGFloat = 20
         ; CocoaMessage(@RowHeight, GadgetID(0), "rowHeight")
         CocoaMessage(0, GadgetID(gadget), "setRowHeight:@", @RowHeight)
      CompilerElse
      CompilerEndIf
      
      ProcedureReturn gadget
   EndProcedure
   
   
   Procedure RemoveItem_( *this._s_WIDGET, Item.l )
      ProcedureReturn RemoveItem( *this, Item )
      
      Protected result
      
      ;          If *this\type = #__type_Editor
      ;             edit_RemoveItem( *this, Item )
      ;             
      ;             result = #True
      ;          EndIf
      
      ; - widget::tree_remove_item( )
      If *this\type = #__type_Tree Or
         *this\type = #__type_ListIcon Or
         *this\type = #__type_ListView
         
         If is_no_select_item_( *this\__rows( ), Item )
            ProcedureReturn #False
         EndIf
         
         ;\\
         Protected removecount = 1
         Protected sublevel = *this\__rows( )\sublevel
         Protected *rowParent._s_ROWS = *this\__rows( )\RowParent( )
         Protected *row._s_ROWS = *this\__rows( )
         Debug "remove "+ Item +" "+ *row\text\string
     
         ; if is last parent item then change to the prev element of his level
         If *rowParent And *rowParent\_last = *row
            PushListPosition( *this\__rows( ))
            While PreviousElement( *this\__rows( ))
               If *rowParent = *this\__rows( )\RowParent( )
                  *rowParent\_last = *this\__rows( )
                  Break
               EndIf
            Wend
            PopListPosition( *this\__rows( ))
            
            ; if the remove last parent children's
            If *rowParent\_last = *row
               *rowParent\childrens = #False
               *rowParent\_last      = #Null
            Else
               *rowParent\childrens = #True
            EndIf
         EndIf
         
         ; before deleting a parent, we delete its children's
         If *row\childrens
            PushListPosition( *this\__rows( ))
            While NextElement( *this\__rows( ))
               If *this\__rows( )\sublevel > sublevel
                  ; 
                  If *this\RowFocused( ) = *this\__rows( )
                     *this\RowFocused( ) = *row
                  EndIf
                  ;
                  DeleteElement( *this\__rows( ))
                  *this\countitems - 1
                  removecount + 1
               Else
                  Break
               EndIf
            Wend
            PopListPosition( *this\__rows( ))
         EndIf
         
         ; 
         If *this\RowFirstLevelFirst( ) = *row
            PushListPosition( *this\__rows( ))
            If NextElement( *this\__rows( ))
               *this\RowFirstLevelFirst( ) = *this\__rows( )
            Else
               *this\RowFirstLevelFirst( ) = 0
            EndIf
            PopListPosition( *this\__rows( ))
         EndIf
         
         ; 
         If *this\RowFirstLevelLast( ) = *row
            PushListPosition( *this\__rows( ))
            If PreviousElement( *this\__rows( ))
               If *this\__rows( )\sublevel = *row\sublevel
                  *this\RowFirstLevelLast( ) = *this\__rows( )
               Else
                  *rowParent = *this\__rows( )\RowParent( )
                  While *rowParent
                     If *rowParent\sublevel = *row\sublevel
                        Break
                     Else
                        *rowParent = *rowParent\RowParent( )
                     EndIf
                  Wend
                  *this\RowFirstLevelLast( ) = *rowParent
               EndIf
            Else
               *this\RowFirstLevelLast( ) = 0
            EndIf
            PopListPosition( *this\__rows( ))
         EndIf
         
         ;
         PushListPosition( *this\__rows( ))
         While NextElement( *this\__rows( ))
            *this\__rows( )\lindex - removecount ; = ListIndex( *this\__rows( ) ) 
         Wend
         PopListPosition(*this\__rows( ))
         
         
         If *this\RowFocused( ) = *this\__rows( )
            *this\RowFocused( )\_focus = 0 
            *this\RowFocused( )\ColorState( ) = 0
            ; DoEvents( *this, #__event_StatusChange, *this\RowFocused( )\rindex, *this\RowFocused( )\ColorState( ))
            
            ; if he is a parent then we find the next item of his level
            PushListPosition( *this\__rows( ))
            While NextElement( *this\__rows( ))
               If *this\__rows( )\sublevel =< *this\RowFocused( )\sublevel
                  Break
               EndIf
            Wend
            
            ; if we remove the last selected then
            If *this\RowFocused( ) = *this\__rows( )
               PreviousElement( *this\__rows( ))
            EndIf
            *this\RowFocused( ) = *this\__rows( )
            PopListPosition( *this\__rows( ))
            
            If *this\RowFocused( )
               If *this\RowFocused( )\RowParent( ) 
                  If *this\RowFocused( )\RowParent( )\buttonbox  
                     If *this\RowFocused( )\RowParent( )\buttonbox\checked
                        *this\RowFocused( ) = *this\RowFocused( )\RowParent( )
                     EndIf
                  EndIf
               EndIf
               
               *this\RowFocused( )\_focus = *this\focus
               *this\RowFocused( )\ColorState( ) = *this\focus
               ; DoEvents( *this, #__event_StatusChange, *this\RowFocused( )\rindex, *this\RowFocused( )\ColorState( ))
            EndIf
         EndIf
         
         ;
         DeleteElement( *this\__rows( ))
         
         *this\WidgetChange( ) = 1
         *this\countitems - 1
         PostRepaint( *this\root )
         result = #True
      EndIf
      
      ;          If *this\type = #__type_Panel
      ;             result = bar_tab_removeItem( *this\tabbar, Item )
      ;             
      ;          ElseIf is_bar_( *this ) Or *this\type = #__type_TabBar
      ;             result = bar_tab_removeItem( *this, Item )
      ;             
      ;          EndIf
      
      ProcedureReturn result
   EndProcedure
   
   
   
   Procedure gadget_events()
      Protected item
      
      Select EventType( )
         Case #PB_EventType_Change
            If g1 = EventGadget()
               Debug "change "
            EndIf
            
         Case #PB_EventType_LeftClick
            If g2 = EventGadget()
               item = GetGadgetState(EventGadget())
               
               RemoveGadgetItem(g1, item)
               RemoveGadgetItem(g2, item)
               
;                For a = 0 To CountGadgetItems(g1)-1
;                   Debug ""+a+" "+GetGadgetItemText(g1,a)
;                Next
            EndIf
         
      EndSelect
   EndProcedure
   
   Procedure widget_events()
      Protected item
      
      Select WidgetEvent( )
         Case #__event_Change
            If *g1 = EventWidget( )
               Debug "change "+ WidgetEventItem( )
            EndIf
            
         Case #__event_LeftClick
            If *g2 = EventWidget( )
               item = GetState(EventWidget( ))
               
               RemoveItem_(*g1, item)
               RemoveItem_(*g2, item)
               
;                ;                   For a = 0 To CountItems(*g1)-1
;                ;                      Debug ""+a+" "+GetItemText(*g1,a)
;                ;                   Next
;                
;                ForEach *g1\__rows( )
;                   Debug ""+*g1\__rows( )\index +" "+*g1\__rows( )\text\string
;                Next
            EndIf
      EndSelect
            
;       Select EventWidget( )
;          Case *g1
;             Select WidgetEvent( )
;                Case #__event_RightClick
;                   Debug "----->-----"
;                   ;                   If *g1\RowEntered( )
;                   ;                      Debug "e "+*g1\RowEntered( )\enter +" "+ *g1\RowEntered( )\press +" "+ *g1\RowEntered( )\focus
;                   ;                   EndIf
;                   ;                   If *g1\RowPressed( )
;                   ;                      Debug "p "+*g1\RowPressed( )\enter +" "+ *g1\RowPressed( )\press +" "+ *g1\RowPressed( )\focus
;                   ;                   EndIf
;                   ;                   If *g1\RowFocused( )
;                   ;                      Debug "f "+*g1\RowFocused( )\enter +" "+ *g1\RowFocused( )\press +" "+ *g1\RowFocused( )\focus
;                   ;                   EndIf
;                   
;                   If *g1\RowFirstLevelFirst( )
;                      Debug "sub first "+*g1\RowFirstLevelFirst( )\index
;                   EndIf
;                   If *g1\RowLast( )
;                      Debug "last "+*g1\RowLast( )\index
;                   EndIf
;                   If *g1\RowFirstLevelLast( )
;                      Debug "sub last "+*g1\RowFirstLevelLast( )\index
;                   EndIf
;                   Debug "-----<-----"
;             EndSelect
;       EndSelect
   EndProcedure
   
   If Open(1, 100, 50, 525, 435+40, "demo remove item", #PB_Window_SystemMenu)
      ; demo gadget
      g1 = TreeGadget_(#PB_Any, 10, 10, 250, 225, #PB_Tree_CheckBoxes|#PB_Tree_ThreeState|#PB_Tree_AlwaysShowSelection)
      g2 = TreeGadget_(#PB_Any, 10, 240, 250, 225);, #PB_Tree_NoButtons|#PB_Tree_NoLines)                                                                     
      
      For a = 0 To CountItems
         If a > 4
            If a > 10
               If a > 14
                  AddGadgetItem(g1, -1, "Item "+Str(a), 0, 1)
                  AddGadgetItem(g2, -1, "индекс итема чтобы удалить "+Str(a), 0, 1)
               Else
                  AddGadgetItem(g1, -1, "Item "+Str(a), 0, 0)
                  AddGadgetItem(g2, -1, "индекс итема чтобы удалить "+Str(a), 0, 0)
               EndIf
            Else
               AddGadgetItem(g1, -1, "Item "+Str(a), 0, 1)
               AddGadgetItem(g2, -1, "индекс итема чтобы удалить "+Str(a), 0, 1)
            EndIf
         Else
            AddGadgetItem(g1, -1, "Item "+Str(a), 0, 0)
            AddGadgetItem(g2, -1, "индекс итема чтобы удалить "+Str(a), 0, 0)
         EndIf
         
         ; AddGadgetItem(g2, -1, "индекс итема чтобы удалить "+Str(a), 0)
      Next
      
      BindGadgetEvent(g1, @gadget_events())
      BindGadgetEvent(g2, @gadget_events())
      
      ; demo widget
      *g1 = Tree(265, 10, 250, 225, #PB_Tree_CheckBoxes|#PB_Tree_ThreeState ) 
      *g2 = Tree(265, 240, 250, 225);, #PB_Tree_NoButtons|#PB_Tree_NoLines )
      
      For a = 0 To CountItems
         If a > 4
            If a > 10
               If a > 14
                  AddItem(*g1, -1, "Item "+Str(a), -1, 1)
                  AddItem(*g2, -1, "индекс итема чтобы удалить "+Str(a), -1, 1)
               Else
                  AddItem(*g1, -1, "Item "+Str(a), -1, 0)
                  AddItem(*g2, -1, "индекс итема чтобы удалить "+Str(a), -1, 0)
               EndIf
            Else
               AddItem(*g1, -1, "Item "+Str(a), -1, 1)
               AddItem(*g2, -1, "индекс итема чтобы удалить "+Str(a), -1, 1)
            EndIf
         Else
            AddItem(*g1, -1, "Item "+Str(a), -1, 0)
            AddItem(*g2, -1, "индекс итема чтобы удалить "+Str(a), -1, 0)
         EndIf
         
         ;   AddItem(*g2, -1, "индекс итема чтобы удалить "+Str(a), -1)
      Next
      
      SetItemState(*g1, 4, #PB_Tree_Collapsed )
      SetItemState(*g1, 14, #PB_Tree_Collapsed )
      SetItemState(*g2, 4, #PB_Tree_Collapsed )
      SetItemState(*g2, 14, #PB_Tree_Collapsed )
      
      Bind(*g1, @widget_events())
      Bind(*g2, @widget_events())
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 28
; FirstLine = 18
; Folding = -t2----
; EnableXP
; DPIAware