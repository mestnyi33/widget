
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global a, *first, *last, *added, *reset,
         *w1, *w3, *w2, *w4, *w5, *w6, *w7, *w8,
         *g1, *g3, *g2, *g4, *g5, *g6, *g7, *g8, countitems=6; количесвто итемов 
  
  ;\\
  Procedure SetGadGetWidgetState_(gadget, state)
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
    
    SetGadGetWidgetState(gadget, state)
  EndProcedure
  
  ;\\
  Procedure AddGadgetItem_(gadget, position, text.s, imageID=0, flags=0)
    AddGadgetItem(gadget, position, text, imageID, flags)
    
    ;     CompilerSelect #PB_Compiler_OS
    ;       CompilerCase #PB_OS_MacOS
    If GetGadGetWidgetState(gadget) >= 0
      SetGadGetWidgetState_( gadget, CountGadgetItems(gadget) - 1 )
    EndIf
    ;     CompilerEndSelect
  EndProcedure
  
  ;\\
  Procedure ListViewGadget_(gadget, x,y,width,height,flag=0)
    Protected g = PB(ListViewGadget)(gadget, x,y,width,height,flag)
    ;Protected g = PB(TreeGadget)(gadget, x,y,width,height,flag)
    ;Protected g = PB(ListIconGadget)(gadget, x,y,width,height,"title",width, flag)
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
  
  ;-
  Procedure events_gadgets()
    Select EventType()
;       Case #PB_EventType_Focus
;         Debug  ""+EventGadget()+" - gadget focus "+GetGadGetWidgetState(EventGadget())
;       Case #PB_EventType_LostFocus
;         Debug  ""+EventGadget()+" - gadget lost-focus "+GetGadGetWidgetState(EventGadget())
;         
      Case #PB_EventType_DragStart
        If *g1 = EventGadget()
          PB(DragText)( "drag" )
          Debug  ""+ EventGadget() +" - gadget DragStart "+GetGadGetWidgetState(EventGadget())
        EndIf
      
      Case #PB_EventType_Change
        Debug  ""+ EventGadget() +" - gadget Change "+GetGadGetWidgetState(EventGadget())
        
      Case #PB_EventType_LeftClick
        Debug  ""+ EventGadget() +" - gadget LeftClick "+GetGadGetWidgetState(EventGadget())
        
;       Case #PB_EventType_LeftDoubleClick
;         Debug  ""+ EventGadget() +" - gadget LeftDoubleClick "+GetGadGetWidgetState(EventGadget())
;         
;       Case #PB_EventType_RightClick
;         Debug  ""+ EventGadget() +" - gadget RightClick "+GetGadGetWidgetState(EventGadget())
        
    EndSelect
  EndProcedure
  
  Procedure events_widgets()
    Select WidgetEvent()
;       Case #__event_Focus
;         Debug  ""+GetIndex(EventWidget())+" - widget focus "+GetWidgetState(EventWidget())
;       Case #__event_LostFocus
;         Debug  ""+GetIndex(EventWidget())+" - widget lost-focus "+GetWidgetState(EventWidget())
;         
;       Case #__event_Up
;         Debug  ""+GetIndex(EventWidget())+" - widget Up "+GetWidgetState(EventWidget())
;         
;       Case #__event_Down
;         Debug  ""+GetIndex(EventWidget())+" - widget Down "+GetWidgetState(EventWidget())
;         
;       Case #__event_ScrollChange
;         Debug  ""+GetIndex(EventWidget())+" - widget ScrollChange "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
        
;       Case #__event_StatusChange
;         ; Debug  ""+GetIndex(EventWidget())+" - widget StatusChange "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
;         
      Case #__event_DragStart
        If *w1 = EventWidget()
          DragTextWidget( GetWidgetItemText(EventWidget(), GetWidgetState(EventWidget())) )
          Debug  ""+GetIndex(EventWidget())+" - widget DragStart "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
        EndIf
      
      Case #__event_Drop
        If *w3 = EventWidget()
          Debug  ""+GetIndex(EventWidget())+" - widget Drop "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem() +" "+ EventDropTextWidget( )
          AddItem( *w3, EventWidget( )\RowEntered( )\_index + 1, EventDropTextWidget( ) )
          SetActiveWidget( *w3 )
        EndIf
      
      Case #__event_Change
        Debug  ""+GetIndex(EventWidget())+" - widget Change "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
;         
      Case #__event_LeftClick
        Debug  ""+GetIndex(EventWidget())+" - widget LeftClick "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
        
;       Case #__event_Left2Click
;         Debug  ""+GetIndex(EventWidget())+" - widget LeftDoubleClick "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
;         
;       Case #__event_RightClick
;         Debug  ""+GetIndex(EventWidget())+" - widget RightClick "+GetWidgetState(EventWidget()) +" "+ WidgetEventItem()
        
    EndSelect
  EndProcedure
  
  If OpenRoot(1, 100, 50, 520, 755, "demo ListView state", #PB_Window_SystemMenu)
    ;\\ demo gadget
    *g1 = ListViewGadget_(#PB_Any, 10, 10, 120, 180 )
    *g2 = ListViewGadget_(#PB_Any, 10+125, 10, 120, 180)
    
    ;\\
    *g3 = ListViewGadget_(#PB_Any, 10, 195, 120, 180, #PB_ListView_ClickSelect)
    *g4 = ListViewGadget_(#PB_Any, 10+125, 195, 120, 180, #PB_ListView_ClickSelect)
    
    ;\\
    *g5 = ListViewGadget_(#PB_Any, 10, 380, 120, 180, #PB_ListView_MultiSelect)
    *g6 = ListViewGadget_(#PB_Any, 10+125, 380, 120, 180, #PB_ListView_MultiSelect)
    
    ;\\
    *g7 = ListViewGadget_(#PB_Any, 10, 565, 120, 180, #PB_ListView_MultiSelect|#PB_ListView_ClickSelect)
    *g8 = ListViewGadget_(#PB_Any, 10+125, 565, 120, 180, #PB_ListView_MultiSelect|#PB_ListView_ClickSelect)
    
    ;\\
    a = 0
    For a = 0 To countitems
      AddGadgetItem_(*g1, -1, "D&D item "+Str(a), 0)
      AddGadgetItem_(*g3, -1, "Drop item "+Str(a), 0)
      AddGadgetItem_(*g5, -1, "Item "+Str(a), 0)
      AddGadgetItem_(*g7, -1, "Item "+Str(a), 0)
    Next
    a = 0
    For a = 0 To countitems*10
      AddGadgetItem_(*g2, -1, "Item "+Str(a), 0)
      AddGadgetItem_(*g4, -1, "Item "+Str(a), 0)
      AddGadgetItem_(*g6, -1, "Item "+Str(a), 0)
      AddGadgetItem_(*g8, -1, "Item "+Str(a), 0)
    Next
    a = 0
    For a = 0 To countitems
      SetGadGetWidgetState_(*g1, a)
      SetGadGetWidgetState_(*g3, a)
      SetGadGetWidgetState_(*g5, a)
      SetGadGetWidgetState_(*g7, a)
    Next
    
;     ;\\
;     SetGadGetWidgetState_(*g1, countitems-1)
;     SetGadGetWidgetState_(*g3, countitems-1) 
;     SetGadGetWidgetState_(*g5, countitems-1) 
;     SetGadGetWidgetState_(*g7, countitems-1) 
    
    ;\\ demo widget
    *w1 = widget::ListViewWidget(265, 10, 120, 180 )
    *w2 = widget::ListViewWidget(265+125, 10, 120, 180 )
    
    ;\\
    *w3 = widget::ListViewWidget(265, 195, 120, 180, #PB_ListView_ClickSelect )
    *w4 = widget::ListViewWidget(265+125, 195, 120, 180, #PB_ListView_ClickSelect )
    
    ;\\
    *w5 = widget::ListViewWidget(265, 380, 120, 180, #PB_ListView_MultiSelect )
    *w6 = widget::ListViewWidget(265+125, 380, 120, 180, #PB_ListView_MultiSelect )
    
    ;\\
    *w7 = widget::ListViewWidget(265, 565, 120, 180, #PB_ListView_MultiSelect|#PB_ListView_ClickSelect )
    *w8 = widget::ListViewWidget(265+125, 565, 120, 180, #PB_ListView_MultiSelect|#PB_ListView_ClickSelect )
    
    ;\\
    a = 0 
    For a = 0 To countitems
      widget::AddItem(*w1, -1, "D&D item "+Str(a), 0)
      widget::AddItem(*w3, -1, "Drop item "+Str(a), 0)
      widget::AddItem(*w5, -1, "Item "+Str(a), 0)
      widget::AddItem(*w7, -1, "Item "+Str(a), 0)
    Next
    a = 0 
    For a = 0 To countitems*10
      widget::AddItem(*w2, -1, "Item "+Str(a), 0)
      widget::AddItem(*w4, -1, "Item "+Str(a), 0)
      widget::AddItem(*w6, -1, "Item "+Str(a), 0)
      widget::AddItem(*w8, -1, "Item "+Str(a), 0)
    Next
    a = 0 
    For a = 0 To countitems
      widget::SetWidgetState(*w1, a)
      widget::SetWidgetState(*w3, a)
      widget::SetWidgetState(*w5, a)
      widget::SetWidgetState(*w7, a)
    Next
    
;     ;\\
;     widget::SetWidgetState(*w1, countitems-1)
;     widget::SetWidgetState(*w3, countitems-1) 
;     widget::SetWidgetState(*w5, countitems-1) 
;     widget::SetWidgetState(*w7, countitems-1) 
    
    ;\\
    EnableDDrop( *w3, #PB_Drop_Text, #PB_Drag_Copy )
    
    ;\\
    SetActiveWidget( *w5 )
    SetActiveGadget( *g5 )
    SetActiveWidget( *w5 )
    
    ;\\
    BindGadgetEvent(*g1, @events_gadgets())
    BindGadgetEvent(*g2, @events_gadgets())
    BindGadgetEvent(*g3, @events_gadgets())
    BindGadgetEvent(*g4, @events_gadgets())
    BindGadgetEvent(*g5, @events_gadgets())
    BindGadgetEvent(*g6, @events_gadgets())
    ;\\
    BindWidgetEvent(*w1, @events_widgets())
    BindWidgetEvent(*w2, @events_widgets())
    BindWidgetEvent(*w3, @events_widgets())
    BindWidgetEvent(*w4, @events_widgets())
    BindWidgetEvent(*w5, @events_widgets())
    BindWidgetEvent(*w6, @events_widgets())
    
    widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 241
; FirstLine = 181
; Folding = V--
; EnableXP
; DPIAware