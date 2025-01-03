; 
; demo state

IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, *g1._s_WIDGET,*g2, g1,g2, CountItems=9; количесвто итемов 
   
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
   
   Procedure gadget_events()
      Protected item
      
      Select EventType( )
         Case #PB_EventType_Change
            item = GetGadgetState(EventGadget())
            
            RemoveGadgetItem(g1, item)
      EndSelect
   EndProcedure
   
   Procedure widget_events()
      Protected item
      
      Select EventWidget( )
         Case *g2
            Select WidgetEvent( )
               Case #__event_LeftClick
                  item = GetState(EventWidget( ))
                  
                  RemoveItem(*g1, item)
            EndSelect
            
         Case *g1
            Select WidgetEvent( )
               Case #__event_RightClick
                  Debug "----->-----"
;                   If *g1\RowEntered( )
;                      Debug "e "+*g1\RowEntered( )\enter +" "+ *g1\RowEntered( )\press +" "+ *g1\RowEntered( )\focus
;                   EndIf
;                   If *g1\RowPressed( )
;                      Debug "p "+*g1\RowPressed( )\enter +" "+ *g1\RowPressed( )\press +" "+ *g1\RowPressed( )\focus
;                   EndIf
;                   If *g1\RowFocused( )
;                      Debug "f "+*g1\RowFocused( )\enter +" "+ *g1\RowFocused( )\press +" "+ *g1\RowFocused( )\focus
;                   EndIf
                  
                  If *g1\RowFirstLevelFirst( )
                     Debug "sub first "+*g1\RowFirstLevelFirst( )\index
                  EndIf
                  If *g1\RowLast( )
                     Debug "last "+*g1\RowLast( )\index
                  EndIf
                  If *g1\RowFirstLevelLast( )
                     Debug "sub last "+*g1\RowFirstLevelLast( )\index
                  EndIf
                  Debug "-----<-----"
            EndSelect
      EndSelect
   EndProcedure
   
   If Open(1, 100, 50, 525, 435+40, "demo remove item", #PB_Window_SystemMenu)
      ; demo gadget
      g1 = TreeGadget_(#PB_Any, 10, 10, 250, 225, #PB_Tree_CheckBoxes|#PB_Tree_ThreeState|#PB_Tree_AlwaysShowSelection)
      g2 = TreeGadget_(#PB_Any, 10, 240, 250, 225)                                                                     
      
      For a = 0 To CountItems
         If a =< 4
            AddGadgetItem(g1, -1, "Item "+Str(a), 0)
         Else
            AddGadgetItem(g1, -1, "Item "+Str(a), 0, 1)
         EndIf
         
         AddGadgetItem(g2, -1, "индекс итема чтобы удалить "+Str(a), 0)
      Next
      
      BindGadgetEvent(g2, @gadget_events())
      
      ; demo widget
      *g1 = Tree(265, 10, 250, 225, #PB_Tree_CheckBoxes|#PB_Tree_ThreeState ) 
      *g2 = Tree(265, 240, 250, 225 )
      
      For a = 0 To CountItems
         If a =< 4
            AddItem(*g1, -1, "Item "+Str(a), -1)
         Else
            AddItem(*g1, -1, "Item "+Str(a), -1, 1)
         EndIf
         
         AddItem(*g2, -1, "индекс итема чтобы удалить "+Str(a), -1)
      Next
      SetItemState(*g1, 4, #PB_Tree_Collapsed )
      
      Bind(*g1, @widget_events())
      Bind(*g2, @widget_events())
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 64
; FirstLine = 80
; Folding = ---
; EnableXP
; DPIAware