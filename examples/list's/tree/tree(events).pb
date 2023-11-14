XIncludeFile "../../../widgets.pbi" 
Uselib(widget)

Global g,*g._s_widget, *g2._s_widget

Procedure events_gadgets()
  Select EventType()
    Case #PB_EventType_DragStart
      Debug  ""+ EventGadget() +" - gadget DragStart "+GetGadgetState(EventGadget())
      
    Case #PB_EventType_Change
      Debug  ""+ EventGadget() +" - gadget Change "+GetGadgetState(EventGadget())
      
    Case #PB_EventType_LeftClick
      Debug  ""+ EventGadget() +" - gadget LeftClick "+GetGadgetState(EventGadget())
      
    Case #PB_EventType_LeftDoubleClick
      Debug  ""+ EventGadget() +" - gadget LeftDoubleClick "+GetGadgetState(EventGadget())
      
    Case #PB_EventType_RightClick
      Debug  ""+ EventGadget() +" - gadget RightClick "+GetGadgetState(EventGadget())
      
  EndSelect
EndProcedure

Procedure events_widgets()
  ;; ClearDebugOutput()
  
  Select WidgetEventType()
    Case #__event_Focus
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( FOCUS ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
    Case #__event_LostFocus
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( LOSTFOCUS ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Drop
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( DROP ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_DragStart
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( DRAGSTART ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Up
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( UP ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Down
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( DOWN ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Change
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( CHANGE ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_ScrollChange
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( SCROLL ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_StatusChange
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( STATUS ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_LeftClick
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( LEFTCLICK ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Left2Click
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( LEFT2CLICK ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_RightClick
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( RIGHTCLICK ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #__event_Right2Click
      Debug  ""+GetIndex(EventWidget())+" "+GetClass(EventWidget())+" - event( RIGHT2CLICK ) "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
  EndSelect
EndProcedure

#PB_Tree_ClickSelect = 0;#PB_ListView_ClickSelect
#PB_Tree_MultiSelect = 0;#PB_ListView_MultiSelect

If Open(OpenWindow(#PB_Any, 0, 0, 360, 460, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  Define i,a
  *g = Tree(10, 10, 165, 440, #__flag_gridLines)
  For a = 0 To 5
    AddItem (*g, -1, "Item " + Str(a) + " of the Tree", -1, 0) ; define Tree content
    AddItem (*g, -1, "Subitem " + Str(a) + " of the Tree", -1, 1) ; define Tree content
    
    i = (CountItems( *g )-1)
    If i%2
      SetItemState(*g, i, #PB_Tree_Selected) 
    EndIf
  Next
  
  Bind(*g, @events_widgets())
  
  *g2 = Tree(185, 10, 165, 440, #__flag_checkboxes)
  For a = 0 To 5
    AddItem (*g2, -1, "Item " + Str(a) + " of the Tree", -1, 0) ; define Tree content
    AddItem (*g2, -1, "Subitem " + Str(a) + " of the Tree", -1, 1) ; define Tree content
    
    i = (CountItems( *g2 )-1)
    If i%2
      SetItemState(*g2, i, #PB_Tree_Selected) 
    EndIf
  Next
  
  Bind(*g2, @events_widgets())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 53
; FirstLine = 28
; Folding = --
; EnableXP