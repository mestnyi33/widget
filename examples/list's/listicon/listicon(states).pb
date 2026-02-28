
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
   
  
  Global a, *first, *last, *added, *reset, *g1, *g3, *g2, *g4, *g5, *g6, *g7, *g8, g1, g3, g2, g4, g5, g6, g7, g8, CountItems=4; количесвто итемов 
  
  ;\\
  Procedure SetGadgetState_(gadget, state)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
        ; ExplorerListGadget, ListIconGadget и ListIconGadget — все три построены на одном и том же классе Cocoa (NSTableView).
        ; CocoaMessage(0, GadgetID(gadget), "scrollColumnToVisible:", state)
        If state >= 0
          CocoaMessage(0, GadgetID(gadget), "scrollRowToVisible:", state )
        EndIf
        
        ;       CompilerCase #PB_OS_Windows
        ;         Select GadgetType(gadget)
        ;           Case #PB_GadgetType_ListIcon
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
  Procedure AddGadgetItem_(gadget, position, Text.s, imageID=0, flags=0)
    AddGadgetItem(gadget, position, Text, imageID, flags)
    
    ;     CompilerSelect #PB_Compiler_OS
    ;       CompilerCase #PB_OS_MacOS
    If GetGadgetState(gadget) >= 0
      SetGadgetState_( gadget, CountGadgetItems(gadget) - 1 )
    EndIf
    ;     CompilerEndSelect
  EndProcedure
  
  ;\\
  Procedure ListIconGadget_(gadget, X,Y,Width,Height, titleText.s, titleWidth, Flag=0)
    Protected g = PB(ListIconGadget)(gadget, X,Y,Width,Height, titleText, titleWidth,Flag)
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
;         Debug  ""+EventGadget()+" - gadget focus "+GetGadgetState(EventGadget())
;       Case #PB_EventType_LostFocus
;         Debug  ""+EventGadget()+" - gadget lost-focus "+GetGadgetState(EventGadget())
;         
;       Case #PB_EventType_DragStart
;         Debug  ""+ EventGadget() +" - gadget DragStart "+GetGadgetState(EventGadget())
        
      Case #PB_EventType_Change
        Debug  ""+ EventGadget() +" - gadget Change "+GetGadgetState(EventGadget())
        
      Case #PB_EventType_LeftClick
        Debug  ""+ EventGadget() +" - gadget LeftClick "+GetGadgetState(EventGadget())
        
;       Case #PB_EventType_LeftDoubleClick
;         Debug  ""+ EventGadget() +" - gadget LeftDoubleClick "+GetGadgetState(EventGadget())
;         
;       Case #PB_EventType_RightClick
;         Debug  ""+ EventGadget() +" - gadget RightClick "+GetGadgetState(EventGadget())
        
    EndSelect
  EndProcedure
  
  Procedure events_widgets()
    Select WidgetEvent()
;       Case #__event_Focus
;         Debug  ""+Index(EventWidget())+" - widget focus "+GetState(EventWidget())
;       Case #__event_LostFocus
;         Debug  ""+Index(EventWidget())+" - widget lost-focus "+GetState(EventWidget())
;         
;       Case #__event_Up
;         Debug  ""+Index(EventWidget())+" - widget Up "+GetState(EventWidget())
;         
;       Case #__event_Down
;         Debug  ""+Index(EventWidget())+" - widget Down "+GetState(EventWidget())
;         
;       Case #__event_ScrollChange
;         Debug  ""+Index(EventWidget())+" - widget ScrollChange "+GetState(EventWidget()) +" "+ WidgetEventItem()
        
;       Case #__event_StatusChange
;         ; Debug  ""+Index(EventWidget())+" - widget StatusChange "+GetState(EventWidget()) +" "+ WidgetEventItem()
;         
;       Case #__event_DragStart
;         Debug  ""+Index(EventWidget())+" - widget DragStart "+GetState(EventWidget()) +" "+ WidgetEventItem()
;         
      Case #__event_Change
        Debug  ""+Index(EventWidget())+" - widget Change "+GetState(EventWidget()) +" "+ WidgetEventItem()
;         
      Case #__event_LeftClick
        Debug  ""+Index(EventWidget())+" - widget LeftClick "+GetState(EventWidget()) +" "+ WidgetEventItem()
        
;       Case #__event_Left2Click
;         Debug  ""+Index(EventWidget())+" - widget LeftDoubleClick "+GetState(EventWidget()) +" "+ WidgetEventItem()
;         
;       Case #__event_RightClick
;         Debug  ""+Index(EventWidget())+" - widget RightClick "+GetState(EventWidget()) +" "+ WidgetEventItem()
        
    EndSelect
  EndProcedure
  
  If Open(1, 100, 50, 520, 755, "demo ListIcon state", #PB_Window_SystemMenu)
    ;\\ demo gadget
    g1 = ListIconGadget_(#PB_Any, 10, 10, 120, 180, "column", 100 )
    g2 = ListIconGadget_(#PB_Any, 10+125, 10, 120, 180, "column", 100)
    
    ;\\
    g3 = ListIconGadget_(#PB_Any, 10, 195, 120, 180, "column", 100)
    g4 = ListIconGadget_(#PB_Any, 10+125, 195, 120, 180, "column", 100)
    
    ;\\
    g5 = ListIconGadget_(#PB_Any, 10, 380, 120, 180, "column", 100)
    g6 = ListIconGadget_(#PB_Any, 10+125, 380, 120, 180, "column", 100)
    
    ;\\
    g7 = ListIconGadget_(#PB_Any, 10, 565, 120, 180, "column", 100)
    g8 = ListIconGadget_(#PB_Any, 10+125, 565, 120, 180, "column", 100)
    
    ;\\
    For a = 0 To CountItems
      AddGadgetItem_(g1, -1, "Item "+Str(a), 0)
      AddGadgetItem_(g3, -1, "Item "+Str(a), 0)
      AddGadgetItem_(g5, -1, "Item "+Str(a), 0)
      AddGadgetItem_(g7, -1, "Item "+Str(a), 0)
    Next
    For a = 0 To CountItems*10
      AddGadgetItem_(g2, -1, "Item "+Str(a), 0)
      AddGadgetItem_(g4, -1, "Item "+Str(a), 0)
      AddGadgetItem_(g6, -1, "Item "+Str(a), 0)
      AddGadgetItem_(g8, -1, "Item "+Str(a), 0)
    Next
    
    ;\\
    SetGadgetState_(g1, CountItems-1)
    SetGadgetState_(g3, CountItems-1) 
    SetGadgetState_(g5, CountItems-1) 
    SetGadgetState_(g7, CountItems-1) 
    
    ;\\ demo widget
    *g1 = Widget::ListIcon(265, 10, 120, 180, "column", 100 )
    *g2 = Widget::ListIcon(265+125, 10, 120, 180, "column", 100 )
    
    ;\\
    *g3 = Widget::ListIcon(265, 195, 120, 180, "column", 100, #__flag_RowClickSelect )
    *g4 = Widget::ListIcon(265+125, 195, 120, 180, "column", 100, #__flag_RowClickSelect )
    
    ;\\
    *g5 = Widget::ListIcon(265, 380, 120, 180, "column", 100, #__flag_RowMultiSelect )
    *g6 = Widget::ListIcon(265+125, 380, 120, 180, "column", 100, #__flag_RowMultiSelect )
    
    ;\\
    *g7 = Widget::ListIcon(265, 565, 120, 180, "column", 100, #__flag_RowMultiSelect|#__flag_RowClickSelect )
    *g8 = Widget::ListIcon(265+125, 565, 120, 180, "column", 100, #__flag_RowMultiSelect|#__flag_RowClickSelect )
    
    ;\\
    For a = 0 To CountItems
      Widget::AddItem(*g1, -1, "Item "+Str(a), 0)
      Widget::AddItem(*g3, -1, "Item "+Str(a), 0)
      Widget::AddItem(*g5, -1, "Item "+Str(a), 0)
      Widget::AddItem(*g7, -1, "Item "+Str(a), 0)
    Next
    For a = 0 To CountItems*10
      Widget::AddItem(*g2, -1, "Item "+Str(a), 0)
      Widget::AddItem(*g4, -1, "Item "+Str(a), 0)
      Widget::AddItem(*g6, -1, "Item "+Str(a), 0)
      Widget::AddItem(*g8, -1, "Item "+Str(a), 0)
    Next
    
    ;\\
    Widget::SetState(*g1, CountItems-1)
    Widget::SetState(*g3, CountItems-1) 
    Widget::SetState(*g5, CountItems-1) 
    Widget::SetState(*g7, CountItems-1) 
    
    ;\\
    SetActive( *g5 )
    SetActiveGadget( g5 )
    SetActive( *g5 )
    
    ;\\
    BindGadgetEvent(g1, @events_gadgets())
    BindGadgetEvent(g2, @events_gadgets())
    BindGadgetEvent(g3, @events_gadgets())
    BindGadgetEvent(g4, @events_gadgets())
    BindGadgetEvent(g5, @events_gadgets())
    BindGadgetEvent(g6, @events_gadgets())
    ;\\
    Bind(*g1, @events_widgets())
    Bind(*g2, @events_widgets())
    Bind(*g3, @events_widgets())
    Bind(*g4, @events_widgets())
    Bind(*g5, @events_widgets())
    Bind(*g6, @events_widgets())
    
    Widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 225
; FirstLine = 200
; Folding = ---
; EnableXP
; DPIAware