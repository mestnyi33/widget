; 
; demo state

IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, *first, *last, *added, *reset, *w1, *w2, *g1, *g2, CountItems=9; количесвто итемов 
   
    Procedure.b SetItemState_( *this._s_WIDGET, Item.l, State.b )
       ProcedureReturn SetItemState( *this, Item, State )
       Protected result
         
         If *this\type = #__type_Editor
          ;  result = edit_SetItemState( *this, Item, state )
         EndIf
         
         If *this\type = #__type_Tree Or
                *this\type = #__type_ListView Or
                *this\type = #__type_ListIcon Or
                *this\type = #__type_Properties
                
            If *this\countitems
               If is_no_select_item_( *this\__rows( ), Item )
                  ProcedureReturn #False
               EndIf
               
               Protected *row._s_ROWS
               *row = *this\__rows( )
               ;
               If State & #PB_Tree_Selected
                  *row\_focus = 1
                  If *this\focus
                     *row\ColorState( ) = #__s_2
                  Else
                     *row\ColorState( ) = #__s_3
                  EndIf
               Else
                  *row\_focus = 0
                  *row\ColorState( ) = #__s_0
               EndIf
               ;
               If State & #PB_Tree_Inbetween 
                  *row\checkbox\checked = #PB_Checkbox_Inbetween
               ElseIf State & #PB_Tree_Checked
                  *row\checkbox\checked = #PB_Checkbox_Checked
               Else
                  *row\checkbox\checked = #PB_Checkbox_Unchecked
               EndIf
               ;
               If *row\childrens
                  If State & #PB_Tree_Expanded Or State & #PB_Tree_Collapsed 
                     *row\buttonbox\checked = Bool( State & #PB_Tree_Collapsed )
                     *this\WidgetChange( )             = #True
                     
                     PushListPosition( *this\__rows( ))
                     While NextElement( *this\__rows( ))
                        If *this\__rows( )\RowParent( )
                           *this\__rows( )\hide = Bool( *this\__rows( )\RowParent( )\buttonbox\checked | *this\__rows( )\RowParent( )\hide )
                        EndIf
                        
                        If *this\__rows( )\sublevel = *row\sublevel
                           Break
                        EndIf
                     Wend
                     PopListPosition( *this\__rows( ))
                  EndIf
                  ;
                  ProcedureReturn #True
               EndIf
            EndIf
            
         EndIf
         
         If *this\type = #__type_ToolBar Or
            *this\type = #__type_MenuBar Or
            *this\type = #__type_PopupBar Or
            *this\type = #__type_TabBar
            ;
            If is_no_select_item_( *this\__tabs( ), Item )
               ProcedureReturn #False
            EndIf
            
            If State & #PB_Tree_Selected = #PB_Tree_Selected
;                If bar_tab_SetState( *this, Item )
;                   result = #True
;                EndIf
            EndIf
         EndIf
         
         ProcedureReturn result
      EndProcedure
     
   ;\\
   Procedure SetGadgetState_(gadget, state)
;       CompilerSelect #PB_Compiler_OS
;          CompilerCase #PB_OS_MacOS
;             If state >= 0
;                CocoaMessage(0, GadgetID(gadget), "scrollRowToVisible:", state )
;             EndIf
;       CompilerEndSelect 
      
      SetGadgetState(gadget, state)
   EndProcedure
   
   Procedure SetGadgetItemState_(gadget, item, state)
      SetGadgetItemState(gadget, item, state)
   EndProcedure
   
   ;\\
   Procedure AddGadgetItem_(gadget, position, Text.s, imageID=0, flags=0)
      AddGadgetItem(gadget, position, Text, imageID, flags)
      
      ;     If GetGadgetState(gadget) >= 0
      ;       SetGadgetState_( gadget, CountGadgetItems(gadget) - 1 )
      ;     EndIf
   EndProcedure
   
   ;\\
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
   
   Procedure widget_events()
      Protected item, itemstate
      Select WidgetEvent( )
         Case #__event_Free
            ProcedureReturn #True
            
         Case #__event_LeftClick
            item = GetState(EventWidget( ))
            itemstate = GetItemState(*w1, item)
            
            If itemstate & #PB_Tree_Selected
               Debug " #PB_Tree_Selected "
            EndIf
            
            If itemstate & #PB_Tree_Checked
               Debug " #PB_Tree_Checked "
            EndIf
            
            If itemstate & #PB_Tree_Inbetween
               Debug " #PB_Tree_Inbetween "
            EndIf
            
            If itemstate & #PB_Tree_Expanded
               Debug " #PB_Tree_Expanded "
            EndIf
            
            If itemstate & #PB_Tree_Collapsed
               Debug " #PB_Tree_Collapsed "
            EndIf
            
            If itemstate = #PB_Tree_Checked | #PB_Tree_Selected
               Debug " = #PB_Tree_Checked | #PB_Tree_Selected "
            EndIf
            
            If itemstate & (#PB_Tree_Checked | #PB_Tree_Selected)
               Debug " & (#PB_Tree_Checked | #PB_Tree_Selected) "
            EndIf
            
            Debug "w item "+item+" state "+itemstate
            If item = 1
               If itemstate & #PB_Tree_Selected
                  itemstate &~ #PB_Tree_Selected
               Else
                  itemstate | #PB_Tree_Selected
               EndIf
            ElseIf item = 2
               If itemstate & #PB_Tree_Checked
                  itemstate &~ #PB_Tree_Checked
               Else
                  itemstate | #PB_Tree_Checked
               EndIf
            ElseIf item = 3
               If itemstate & #PB_Tree_Inbetween
                  itemstate &~ #PB_Tree_Inbetween
               Else
                  itemstate | #PB_Tree_Inbetween
               EndIf
            ElseIf item = 4
               If itemstate & #PB_Tree_Collapsed
                  itemstate &~ #PB_Tree_Collapsed
                  itemstate | #PB_Tree_Expanded
               ElseIf itemstate & #PB_Tree_Expanded
                  itemstate &~ #PB_Tree_Expanded
                  itemstate | #PB_Tree_Collapsed
               EndIf
            EndIf
            Debug "      item "+item+" state "+itemstate
            
            If item = CountItems( *w1 ) - 1
               SetItemState(*w1, item, #PB_Tree_Selected)
            Else
               SetItemState(*w1, item, itemstate)
               ;SetItemState_(*w1, item, itemstate &~ #PB_Tree_Selected)
            EndIf
      EndSelect
   EndProcedure
   
   Procedure gadget_events()
      Protected item, itemstate
      Select EventType( )
         Case #PB_EventType_LeftClick
            item = GetGadgetState(EventGadget())
            itemstate = GetGadgetItemState(*g1, item )
            
            If itemstate & #PB_Tree_Selected
               Debug " #PB_Tree_Selected "
            EndIf
            
            If itemstate & #PB_Tree_Checked
               Debug " #PB_Tree_Checked "
            EndIf
            
            If itemstate & #PB_Tree_Inbetween
               Debug " #PB_Tree_Inbetween "
            EndIf
            
            If itemstate & #PB_Tree_Expanded
               Debug " #PB_Tree_Expanded "
            EndIf
            
            If itemstate & #PB_Tree_Collapsed
               Debug " #PB_Tree_Collapsed "
            EndIf
            
            If itemstate = #PB_Tree_Checked | #PB_Tree_Selected
               Debug " = #PB_Tree_Checked | #PB_Tree_Selected "
            EndIf
            
            If itemstate & (#PB_Tree_Checked | #PB_Tree_Selected)
               Debug " & (#PB_Tree_Checked | #PB_Tree_Selected) "
            EndIf
            
            Debug "g item "+item+" state "+itemstate
            If item = 1
               If itemstate & #PB_Tree_Selected
                  itemstate &~ #PB_Tree_Selected
               Else
                  itemstate | #PB_Tree_Selected
               EndIf
            ElseIf item = 2
               If itemstate & #PB_Tree_Checked
                  itemstate &~ #PB_Tree_Checked
               Else
                  itemstate | #PB_Tree_Checked
               EndIf
            ElseIf item = 3
               If itemstate & #PB_Tree_Inbetween
                  itemstate &~ #PB_Tree_Inbetween
               Else
                  itemstate | #PB_Tree_Inbetween
               EndIf
            ElseIf item = 4
               If itemstate & #PB_Tree_Collapsed
                  itemstate &~ #PB_Tree_Collapsed
                  itemstate | #PB_Tree_Expanded
               ElseIf itemstate & #PB_Tree_Expanded
                  itemstate &~ #PB_Tree_Expanded
                  itemstate | #PB_Tree_Collapsed
               EndIf
            EndIf
            Debug "      item "+item+" state "+itemstate
            
            If item = CountGadgetItems( *g1 ) - 1
               SetGadgetItemState_(*g1, item, #PB_Tree_Selected)
            Else
               SetGadgetItemState_(*g1, item, itemstate )
               ; SetGadgetItemState_(*g1, item, itemstate &~#PB_Tree_Selected)
            EndIf
      EndSelect
   EndProcedure
   
   If Open(1, 100, 50, 525, 435+40, "demo tree state", #PB_Window_SystemMenu)
      ; demo gadget
      *g1 = TreeGadget_(#PB_Any, 10, 10, 250, 100, #PB_Tree_CheckBoxes|#PB_Tree_ThreeState|#PB_Tree_AlwaysShowSelection);;|#PB_Tree_NoLines)
      *g2 = TreeGadget_(#PB_Any, 10, 115, 250, 310)                                                                     ;, #PB_Tree_NoButtons|#PB_Tree_NoLines|#PB_Tree_AlwaysShowSelection)
      
      For a = 0 To CountItems
         If a =< 4
            AddGadgetItem_(*g1, -1, "Item "+Str(a), 0)
         Else
            AddGadgetItem_(*g1, -1, "Item "+Str(a), 0, 1)
         EndIf
         If a = 1
            AddGadgetItem_(*g2, -1, "Item "+Str(a) +" (нажмите чтобы убрать Selected)", 0)
         ElseIf a = 2
            AddGadgetItem_(*g2, -1, "Item "+Str(a) +" (нажмите чтобы убрать Checked)", 0)
         ElseIf a = 3
            AddGadgetItem_(*g2, -1, "Item "+Str(a) +" (нажмите чтобы убрать Inbetween)", 0)
         ElseIf a = 4
            AddGadgetItem_(*g2, -1, "Item "+Str(a) +" (нажмите чтобы убрать Collapsed)", 0)
         Else
            AddGadgetItem_(*g2, -1, "Item "+Str(a), 0)
         EndIf
      Next
      
      SetGadgetItemState_(*g1, - 1, #PB_Tree_Selected )
      SetGadgetItemState_(*g1, CountItems + 1, #PB_Tree_Selected )
      SetGadgetItemState_(*g1, 1, #PB_Tree_Selected )
      SetGadgetItemState_(*g1, 2, #PB_Tree_Selected|#PB_Tree_Checked )
      SetGadgetItemState_(*g1, 3, #PB_Tree_Selected|#PB_Tree_Inbetween )
      SetGadgetItemState_(*g1, 4, #PB_Tree_Selected|#PB_Tree_Inbetween|#PB_Tree_Expanded)
      
      ; баг или не баг
      SetGadgetState_(*g1, 0) 
      SetGadgetItemState_(*g1, 0, 0 )
      
      BindGadgetEvent(*g2, @gadget_events())
      
      ; demo widget
      *w1 = Tree(265, 10, 250, 100, #PB_Tree_CheckBoxes|#PB_Tree_ThreeState ) 
      *w2 = Tree(265, 115, 250, 310 )
      
      For a = 0 To CountItems
         If a =< 4
            AddItem(*w1, -1, "Item "+Str(a), -1)
         Else
            AddItem(*w1, -1, "Item "+Str(a), -1, 1)
         EndIf
         If a = 1
            AddItem(*w2, -1, "Item "+Str(a) +" (нажмите чтобы убрать Selected)", -1)
         ElseIf a = 2
            AddItem(*w2, -1, "Item "+Str(a) +" (нажмите чтобы убрать Checked)", -1)
         ElseIf a = 3
            AddItem(*w2, -1, "Item "+Str(a) +" (нажмите чтобы убрать Inbetween)", -1)
         ElseIf a = 4
            AddItem(*w2, -1, "Item "+Str(a) +" (нажмите чтобы убрать Collapsed)", -1)
         Else
            AddItem(*w2, -1, "Item "+Str(a), -1)
         EndIf
      Next
      SetItemState(*w1, 3, #PB_Tree_Collapsed )
      
      SetItemState(*w1, - 1, #PB_Tree_Selected )
      SetItemState(*w1, CountItems + 1, #PB_Tree_Selected )
      SetItemState(*w1, 1, #PB_Tree_Selected )
      SetItemState(*w1, 2, #PB_Tree_Selected|#PB_Tree_Checked )
      SetItemState(*w1, 3, #PB_Tree_Selected|#PB_Tree_Inbetween )
      SetItemState(*w1, 4, #PB_Tree_Selected|#PB_Tree_Inbetween|#PB_Tree_Expanded)
      
      Bind(*w2, @widget_events())
       
      ;     *reset = Button( 10, 435, 100, 30, "reset [all] selected")
      ;     *first = Button( 525 - (10+120)*3, 435, 120, 30, "select [first] item", #__flag_ButtonToggle)
      ;     *last = Button( 525 - (10+120)*2, 435, 120, 30, "select [last] item", #__flag_ButtonToggle)
      ;     *added = Button( 525 - (10+120)*1, 435, 120, 30, "add [new] item")
      ;     
      ;     SetState( *reset, 1)
      ;     SetState( *last, 1)
      ;     
      ;     Bind(*reset, @button_events(), #__event_Up)
      ;     Bind(*first, @button_events(), #__event_Up)
      ;     Bind(*last, @button_events(), #__event_Up)
      ;     Bind(*added, @button_events(), #__event_Up)
      
      WaitClose()
   EndIf
CompilerEndIf

; ; 
; ; demo state
; 
; IncludePath "../../"
; XIncludeFile "widgets.pbi"
; 
; CompilerIf #PB_Compiler_IsMainFile
;    EnableExplicit
;    UseWidgets( )
;    
;    Global a, *first, *last, *added, *reset, *w1, *w2, *g1, *g2, CountItems=9; количесвто итемов 
;    
;    ;\\
;    Procedure SetGadgetState_(gadget, state)
; ;       CompilerSelect #PB_Compiler_OS
; ;          CompilerCase #PB_OS_MacOS
; ;             If state >= 0
; ;                CocoaMessage(0, GadgetID(gadget), "scrollRowToVisible:", state )
; ;             EndIf
; ;       CompilerEndSelect 
;       
;       SetGadgetState(gadget, state)
;    EndProcedure
;    
;    Procedure SetGadgetItemState_(gadget, item, state)
;       SetGadgetItemState(gadget, item, state)
;    EndProcedure
;    
;    ;\\
;    Procedure AddGadgetItem_(gadget, position, Text.s, imageID=0, flags=0)
;       AddGadgetItem(gadget, position, Text, imageID, flags)
;       
;       ;     If GetGadgetState(gadget) >= 0
;       ;       SetGadgetState_( gadget, CountGadgetItems(gadget) - 1 )
;       ;     EndIf
;    EndProcedure
;    
;    ;\\
;    Procedure TreeGadget_(gadget, X,Y,Width,Height,flag=0)
;       Protected g = PB(TreeGadget)(gadget, X,Y,Width,Height,flag)
;       If gadget =- 1 : gadget = g : EndIf
;       
;       CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
;          Define RowHeight.CGFloat = 20
;          ; CocoaMessage(@RowHeight, GadgetID(0), "rowHeight")
;          CocoaMessage(0, GadgetID(gadget), "setRowHeight:@", @RowHeight)
;       CompilerElse
;       CompilerEndIf
;       
;       ProcedureReturn gadget
;    EndProcedure
;    
;    Procedure widget_events()
;       Protected item, itemstate
;       Select WidgetEvent( )
;          Case #__event_LeftClick
;             item = GetState(EventWidget( ))
;             itemstate = GetItemState(*w1, item)
;             Debug "w "+item+" "+itemstate
;             
;             If itemstate & #PB_Tree_Selected
;                Debug " #PB_Tree_Selected "
;             EndIf
;             
;             If itemstate & #PB_Tree_Checked
;                Debug " #PB_Tree_Checked "
;             EndIf
;             
;             If itemstate & #PB_Tree_Inbetween
;                Debug " #PB_Tree_Inbetween "
;             EndIf
;             
;             If itemstate & #PB_Tree_Expanded
;                Debug " #PB_Tree_Expanded "
;             EndIf
;             
;             If itemstate & #PB_Tree_Collapsed
;                Debug " #PB_Tree_Collapsed "
;             EndIf
;             
;             If itemstate = #PB_Tree_Checked | #PB_Tree_Selected
;                Debug " = #PB_Tree_Checked | #PB_Tree_Selected "
;             EndIf
;             
;             If itemstate & (#PB_Tree_Checked | #PB_Tree_Selected)
;                Debug " & (#PB_Tree_Checked | #PB_Tree_Selected) "
;             EndIf
;             
;             
;             If item = CountItems( *w1 ) - 1
;                SetItemState(*w1, item, #PB_Tree_Selected)
;             Else
;                SetItemState(*w1, item, itemstate &~ #PB_Tree_Selected)
;             EndIf
;       EndSelect
;    EndProcedure
;    
;    Procedure gadget_events()
;       Protected item, itemstate
;       Select EventType( )
;          Case #PB_EventType_LeftClick
;             item = GetGadgetState(EventGadget())
;             itemstate = GetGadgetItemState(*g1, item )
;             Debug "g "+item+" "+itemstate
;             
;             If itemstate & #PB_Tree_Selected
;                Debug " #PB_Tree_Selected "
;             EndIf
;             
;             If itemstate & #PB_Tree_Checked
;                Debug " #PB_Tree_Checked "
;             EndIf
;             
;             If itemstate & #PB_Tree_Inbetween
;                Debug " #PB_Tree_Inbetween "
;             EndIf
;             
;             If itemstate & #PB_Tree_Expanded
;                Debug " #PB_Tree_Expanded "
;             EndIf
;             
;             If itemstate & #PB_Tree_Collapsed
;                Debug " #PB_Tree_Collapsed "
;             EndIf
;             
;             If itemstate = #PB_Tree_Checked | #PB_Tree_Selected
;                Debug " = #PB_Tree_Checked | #PB_Tree_Selected "
;             EndIf
;             
;             If itemstate & (#PB_Tree_Checked | #PB_Tree_Selected)
;                Debug " & (#PB_Tree_Checked | #PB_Tree_Selected) "
;             EndIf
;             
;             If item = CountGadgetItems( *g1 ) - 1
;                SetGadgetItemState_(*g1, item, #PB_Tree_Selected)
;             Else
;                SetGadgetItemState_(*g1, item, itemstate &~#PB_Tree_Selected)
;             EndIf
;       EndSelect
;    EndProcedure
;    
;    If Open(1, 100, 50, 525, 435+40, "demo tree state", #PB_Window_SystemMenu)
;       ; demo gadget
;       *g1 = TreeGadget_(#PB_Any, 10, 10, 250, 100, #PB_Tree_CheckBoxes|#PB_Tree_ThreeState|#PB_Tree_AlwaysShowSelection);;|#PB_Tree_NoLines)
;       *g2 = TreeGadget_(#PB_Any, 10, 115, 250, 310)                                                                     ;, #PB_Tree_NoButtons|#PB_Tree_NoLines|#PB_Tree_AlwaysShowSelection)
;       
;       For a = 0 To CountItems
;          If a =< 4
;             AddGadgetItem_(*g1, -1, "Item "+Str(a), 0)
;          Else
;             AddGadgetItem_(*g1, -1, "Item "+Str(a), 0, 1)
;          EndIf
;          If a > 0 And a < 5
;             AddGadgetItem_(*g2, -1, "Item "+Str(a) +" (нажмите чтобы убрать выделение)", 0)
;          Else
;             AddGadgetItem_(*g2, -1, "Item "+Str(a), 0)
;          EndIf
;       Next
;       
;       SetGadgetItemState_(*g1, 2, #PB_Tree_Checked )
;       SetGadgetItemState_(*g1, 2, #PB_Tree_Selected )
;       
; ;       SetGadgetItemState_(*g1, - 1, #PB_Tree_Selected )
; ;       SetGadgetItemState_(*g1, CountItems + 1, #PB_Tree_Selected )
; ;       SetGadgetItemState_(*g1, 1, #PB_Tree_Selected )
; ;       SetGadgetItemState_(*g1, 2, #PB_Tree_Selected|#PB_Tree_Checked )
; ;       SetGadgetItemState_(*g1, 3, #PB_Tree_Selected|#PB_Tree_Inbetween )
; ;       SetGadgetItemState_(*g1, 4, #PB_Tree_Selected|#PB_Tree_Inbetween|#PB_Tree_Expanded)
;       
;       ; баг или не баг
;       SetGadgetState_(*g1, 0) 
;       SetGadgetItemState_(*g1, 0, 0 )
;       
;       BindGadgetEvent(*g2, @gadget_events())
;       
;       ; demo widget
;       *w1 = Tree(265, 10, 250, 100, #PB_Tree_CheckBoxes|#PB_Tree_ThreeState ) 
;       *w2 = Tree(265, 115, 250, 310 )
;       
;       For a = 0 To CountItems
;          If a =< 4
;             AddItem(*w1, -1, "Item "+Str(a), -1)
;          Else
;             AddItem(*w1, -1, "Item "+Str(a), -1, 1)
;          EndIf
;          If a > 0 And a < 5
;             AddItem(*w2, -1, "Item "+Str(a) +" (нажмите чтобы убрать выделение)", 0)
;          Else
;             AddItem(*w2, -1, "Item "+Str(a), -1)
;          EndIf
;       Next
;       SetItemState(*w1, 4, #PB_Tree_Collapsed )
;       
;       SetItemState(*w1, 2, #PB_Tree_Checked )
;       SetItemState(*w1, 2, #PB_Tree_Selected )
;       
; ;       SetItemState(*w1, - 1, #PB_Tree_Selected )
; ;       SetItemState(*w1, CountItems + 1, #PB_Tree_Selected )
;        
; ;       SetItemState(*w1, 2, #PB_Tree_Selected|#PB_Tree_Checked )
; ;       SetItemState(*w1, 3, #PB_Tree_Selected|#PB_Tree_Inbetween )
; ;       SetItemState(*w1, 4, #PB_Tree_Selected|#PB_Tree_Inbetween|#PB_Tree_Expanded)
; ;       ;SetState(*w1, 0) 
;       
;       Bind(*w2, @widget_events())
;       
;       ;     *reset = Button( 10, 435, 100, 30, "reset [all] selected")
;       ;     *first = Button( 525 - (10+120)*3, 435, 120, 30, "select [first] item", #PB_Button_Toggle)
;       ;     *last = Button( 525 - (10+120)*2, 435, 120, 30, "select [last] item", #PB_Button_Toggle)
;       ;     *added = Button( 525 - (10+120)*1, 435, 120, 30, "add [new] item")
;       ;     
;       ;     SetState( *reset, 1)
;       ;     SetState( *last, 1)
;       ;     
;       ;     Bind(*reset, @button_events(), #__event_Up)
;       ;     Bind(*first, @button_events(), #__event_Up)
;       ;     Bind(*last, @button_events(), #__event_Up)
;       ;     Bind(*added, @button_events(), #__event_Up)
;       
;       WaitClose()
;    EndIf
; CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 211
; FirstLine = 152
; Folding = --P9--0---
; EnableXP
; DPIAware