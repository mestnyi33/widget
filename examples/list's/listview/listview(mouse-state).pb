
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global a, *first, *last, *added, *reset, *w1, *w2, *w3, *w4, *g1, *g2, *g3, *g4, countitems=6; количесвто итемов 
  
  ;\\
  Procedure SetGadgetState_(gadget, state)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
        ; ExplorerListGadget, ListIconGadget и ListViewGadget — все три построены на одном и том же классе Cocoa (NSTableView).
        ; CocoaMessage(0, GadgetID(gadget), "scrollColumnToVisible:", state)
        If state >= 0
          CocoaMessage(0, GadgetID(gadget), "scrollRowToVisible:", state )
        EndIf
        
        ;       CompilerCase #PB_OS_Windows
        ;         Select GadgetType(gadget)
        ;           Case #PB_GadgetType_ListView
        ;            ; SendMessage_(GadgetID(gadget), #LVM_SCROLL, #Null, CountGadgetItems(gadget) - 1)
        ;           Case #PB_GadgetType_ListIcon
        ;             SendMessage_(GadgetID(gadget), #LVM_ENSUREVISIBLE, CountGadgetItems(gadget) - 1, #Null)
        ;           Case #PB_GadgetType_Editor
        ;             SendMessage_(GadgetID(gadget), #EM_SCROLLCARET, #SB_BOTTOM, 0)
        ;         EndSelect
        
        ;       CompilerCase #PB_OS_Linux
        ;         Protected *Adjustment.GtkAdjustment
        ;         *Adjustment = gtk_scrolled_window_get_vadjustment_(gtk_widget_get_parent_(GadgetID(gadget)))
        ;         *Adjustment\value = *Adjustment\upper
        ;         gtk_adjustment_value_changed_(*Adjustment)
    CompilerEndSelect 
    
    SetGadgetState(gadget, state)
  EndProcedure
  
  ;\\
  Procedure AddGadgetItem_(gadget, position, text.s, imageID=0, flags=0)
    AddGadgetItem(gadget, position, text, imageID, flags)
    
    ;     CompilerSelect #PB_Compiler_OS
    ;       CompilerCase #PB_OS_MacOS
    If GetGadgetState(gadget) >= 0
      SetGadgetState_( gadget, CountGadgetItems(gadget) - 1 )
    EndIf
    ;     CompilerEndSelect
  EndProcedure
  
  ;\\
  Procedure ListViewGadget_(gadget, x,y,width,height,flag=0)
    Protected g = PB(ListViewGadget)(gadget, x,y,width,height,flag)
    If gadget =- 1 : gadget = g : EndIf
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Define RowHeight.CGFloat = 20
      ; CocoaMessage(@RowHeight, GadgetID(0), "rowHeight")
      CocoaMessage(0, GadgetID(gadget), "setRowHeight:@", @RowHeight)
      CocoaMessage(0, GadgetID(gadget), "setUsesAlternatingRowBackgroundColors:", #YES)
      CocoaMessage(0, GadgetID(gadget), "sizeLastColumnToFit")
    CompilerElse
    CompilerEndIf
    
    ProcedureReturn gadget
  EndProcedure
  
  
  If Open(1, 100, 50, 525, 435+40, "demo ListView state", #PB_Window_SystemMenu)
    ; demo gadget
    *g1 = ListViewGadget_(#PB_Any, 10, 10, 120, 205, #PB_ListView_ClickSelect)
    *g4 = ListViewGadget_(#PB_Any, 10+125, 10, 120, 205, #PB_ListView_ClickSelect)
    
    *g2 = ListViewGadget_(#PB_Any, 10, 220, 120, 205, #PB_ListView_MultiSelect)
    For a = 0 To countitems
      AddGadgetItem_(*g1, -1, "Item "+Str(a), 0)
      AddGadgetItem_(*g2, -1, "Item "+Str(a), 0)
    Next
    SetGadgetState_(*g1, a-1)
    SetGadgetState_(*g2, a-1) 
    
    *g3 = ListViewGadget_(#PB_Any, 10+125, 220, 120, 205, #PB_ListView_MultiSelect)
    For a = 0 To 300
      AddGadgetItem_(*g3, -1, "Item "+Str(a), 0)
      AddGadgetItem_(*g4, -1, "Item "+Str(a), 0)
    Next
    
    
    ; demo widget
    *w1 = widget::ListView(265, 10, 120, 205, #PB_ListView_ClickSelect )
    *w4 = widget::ListView(265+125, 10, 120, 205, #PB_ListView_ClickSelect )
    
    *w2 = widget::ListView(265, 220, 120, 205, #PB_ListView_MultiSelect )
    For a = 0 To countitems
      widget::AddItem(*w1, -1, "Item "+Str(a), 0)
      widget::AddItem(*w2, -1, "Item "+Str(a), 0)
    Next
    widget::SetState(*w1, a-1)
    widget::SetState(*w2, a-1) 
    
    ;\\
    *w3 = widget::ListView(265+125, 220, 120, 205, #PB_ListView_MultiSelect )
    For a = 0 To 300
      widget::AddItem(*w3, -1, "Item "+Str(a), 0)
      widget::AddItem(*w4, -1, "Item "+Str(a), 0)
    Next
    
    ;     ;\\
    ;     Define i, *tree = Tree( 520+10, 20, 150, 200, #__tree_multiselect)
    ;     For i = 1 To 100;0000
    ;       AddItem(*tree, i, "text-" + Str(i))
    ;     Next
    ;     SetState(*tree, 5 - 1)
    
    SetActive( *w2 )
    SetActiveGadget( *g2 )
    SetActive( *w2 )
    
    widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP