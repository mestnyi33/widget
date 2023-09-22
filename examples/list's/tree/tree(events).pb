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
    Case #PB_EventType_Focus
      Debug  ""+GetIndex(EventWidget())+" - widget focus "+GetState(EventWidget())
    Case #PB_EventType_LostFocus
      Debug  ""+GetIndex(EventWidget())+" - widget lost-focus "+GetState(EventWidget())
      
    Case #PB_EventType_Up
      Debug  ""+GetIndex(EventWidget())+" - widget Up "+GetState(EventWidget())
      
    Case #PB_EventType_Down
      Debug  ""+GetIndex(EventWidget())+" - widget Down "+GetState(EventWidget())
      
    Case #PB_EventType_ScrollChange
      Debug  ""+GetIndex(EventWidget())+" - widget ScrollChange "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #PB_EventType_StatusChange
      Debug  ""+GetIndex(EventWidget())+" - widget StatusChange "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #PB_EventType_DragStart
      Debug  ""+GetIndex(EventWidget())+" - widget DragStart "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #PB_EventType_Change
      Debug  ""+GetIndex(EventWidget())+" - widget Change "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #PB_EventType_LeftClick
      Debug  ""+GetIndex(EventWidget())+" - widget LeftClick "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #PB_EventType_LeftDoubleClick
      Debug  ""+GetIndex(EventWidget())+" - widget LeftDoubleClick "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
    Case #PB_EventType_RightClick
      Debug  ""+GetIndex(EventWidget())+" - widget RightClick "+GetState(EventWidget()) +" "+ WidgetEventItem()
      
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
  
  *g2 = Tree(185, 10, 165, 440)
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
; CursorPosition = 83
; FirstLine = 60
; Folding = --
; EnableXP