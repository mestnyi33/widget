﻿; 
; demo state

IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global a, *first, *last, *added, *reset, *w1, *w2, *g1, *g2, countitems=9; количесвто итемов 
  
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
    CompilerElse
    CompilerEndIf
    
    ProcedureReturn gadget
  EndProcedure
  
  Procedure button_events()
    Protected count
    
    Select widget::WidgetEvent( )
      Case #__event_Up
        
        Select widget::EventWidget( )
          Case *first
            widget::SetState(*w1, 0)
            widget::SetState(*w2, 0)
            SetGadgetState_(*g1, 0)
            SetGadgetState_(*g2, 0)
            
            widget::SetState(*reset, 1)
            widget::SetState(*last, 0)
            
          Case *last
            widget::SetState(*w1, widget::CountItems( *w1 ) - 1)
            widget::SetState(*w2, widget::CountItems( *w2 ) - 1)
            SetGadgetState_(*g1, CountGadgetItems(*g1) - 1)
            SetGadgetState_(*g2, CountGadgetItems(*g2) - 1)
            
            widget::SetState(*reset, 1)
            widget::SetState(*first, 0)
            
          Case *added
            widget::AddItem(*w1, -1, "item " +Str(widget::CountItems(*w1)) +" (added)")
            widget::AddItem(*w2, -1, "item " +Str(widget::CountItems(*w2)) +" (added)")
            
            AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
            AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
            
            widget::SetState(*last, widget::GetState(*reset))
            widget::SetState(*first, 0)
            
          Case *reset
            If widget::GetState(*reset)
              count = widget::CountItems( *w1 )
              SetText(*reset, "reset state")
              widget::SetState(*last, 1)
            Else
              SetText(*reset, "set state")
              widget::SetState(*first, 0)
              widget::SetState(*last, 0)
            EndIf
            
            widget::SetState(*w1, count - 1)
            widget::SetState(*w2, count - 1)
            SetGadgetState_(*g1, count - 1)
            SetGadgetState_(*g2, count - 1)
            
            
        EndSelect
        
    EndSelect
  EndProcedure
  
  Procedure widget_events()
    Select WidgetEvent( )
      Case #__event_RightClick
        widget::AddItem(*w1, -1, "item " +Str(widget::CountItems(*w1)) +" (added)")
        widget::AddItem(*w2, -1, "item " +Str(widget::CountItems(*w2)) +" (added)")
        
        AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
        AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
        
      Case #__event_Change
        widget::SetState(*w1, widget::GetState(widget::EventWidget( )))
        
    EndSelect
  EndProcedure
  
  Procedure gadget_events()
    Select EventType( )
      Case #PB_EventType_RightClick
        widget::AddItem(*w1, -1, "item " +Str(widget::CountItems(*w1)) +" (added)")
        widget::AddItem(*w2, -1, "item " +Str(widget::CountItems(*w2)) +" (added)")
        
        AddGadgetItem_(*g1, -1, "item " +Str(CountGadgetItems(*g1)) +" (added)")
        AddGadgetItem_(*g2, -1, "item " +Str(CountGadgetItems(*g2)) +" (added)")
        
      Case #PB_EventType_Change
        SetGadgetState_(*g1, GetGadgetState(EventGadget()))
        
    EndSelect
  EndProcedure
  
  If Open(1, 100, 50, 525, 435+40, "demo ListView state", #PB_Window_SystemMenu)
    ; demo gadget
    *g1 = ListViewGadget_(#PB_Any, 10, 10, 250, 100, #PB_ListView_ClickSelect)
    *g2 = ListViewGadget_(#PB_Any, 10, 115, 250, 310, #PB_ListView_MultiSelect)
    
    For a = 0 To countitems
      AddGadgetItem_(*g1, -1, "Item "+Str(a), 0)
      AddGadgetItem_(*g2, -1, "Item "+Str(a), 0)
    Next
    
    SetGadgetState_(*g1, a-1)
    SetGadgetState_(*g2, a-1) 
    BindGadgetEvent(*g2, @gadget_events())
    
    ; demo widget
    *w1 = widget::ListView(265, 10, 250, 100, #PB_ListView_ClickSelect )
    *w2 = widget::ListView(265, 115, 250, 310, #PB_ListView_MultiSelect )
    
    For a = 0 To countitems
      widget::AddItem(*w1, -1, "Item "+Str(a), 0)
      widget::AddItem(*w2, -1, "Item "+Str(a), 0)
    Next
    
    widget::SetState(*w1, a-1)
    widget::SetState(*w2, a-1) 
    widget::Bind(*w2, @widget_events())
    widget::Bind(*w2, @widget_events(), #__event_RightClick)
    
    *reset = widget::Button( 10, 435, 100, 30, "reset state", #__flag_ButtonToggle)
    *first = widget::Button( 525 - (10+120)*3, 435, 120, 30, "first item state", #__flag_ButtonToggle)
    *last = widget::Button( 525 - (10+120)*2, 435, 120, 30, "last item state", #__flag_ButtonToggle)
    *added = widget::Button( 525 - (10+120)*1, 435, 120, 30, "add new item")
    
    widget::SetState( *reset, 1)
    widget::SetState( *last, 1)
    
    widget::Bind(*reset, @button_events(), #__event_Up)
    widget::Bind(*first, @button_events(), #__event_Up)
    widget::Bind(*last, @button_events(), #__event_Up)
    widget::Bind(*added, @button_events(), #__event_Up)
    
    widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 127
; FirstLine = 113
; Folding = ---
; EnableXP
; DPIAware