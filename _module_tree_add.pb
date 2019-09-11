;IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "_module_tree_12.pb"
;XIncludeFile "_module_tree_7.pb"

UseModule Tree
LN=500; количесвто итемов 
Global *w._S_widget

  Procedure events_tree_gadget()
    ;Debug " gadget - "+EventGadget()+" "+EventType()
    Protected EventGadget = EventGadget()
    Protected EventType = EventType()
    Protected EventData = EventData()
    Protected EventItem = GetGadgetState(EventGadget)
    
    Select EventType
      Case #PB_EventType_ScrollChange : Debug "gadget scroll change data "+ EventData
      Case #PB_EventType_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_DragStart : Debug "gadget dragStart item = " + EventItem +" data "+ EventData
      Case #PB_EventType_Change    : Debug "gadget change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_LeftClick : Debug "gadget click item = " + EventItem +" data "+ EventData
      EndSelect
  EndProcedure
        
  Procedure events_tree_widget()
    ;Debug " widget - "+*event\widget+" "+*event\type
    Protected EventGadget = *event\widget
    Protected EventType = *event\type
    Protected EventData = *event\data
    Protected EventItem = GetState(EventGadget)
    
    Select EventType
      Case #PB_EventType_ScrollChange : Debug "widget scroll change data "+ EventData
      Case #PB_EventType_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_DragStart : Debug "widget dragStart item = " + EventItem +" data "+ EventData
      Case #PB_EventType_Change    : Debug "widget change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_LeftClick : Debug "widget click item = " + EventItem +" data "+ EventData
    EndSelect
  EndProcedure

  
If OpenWindow(0, 100, 50, 530, 700, "ListViewGadget", #PB_Window_SystemMenu)
  ListViewGadget(0, 10, 10, 250, 680, #PB_ListView_MultiSelect)
  *w=Gadget(1, 270, 10, 250, 680, #PB_Flag_GridLines|#PB_Tree_NoButtons|#PB_Tree_NoLines |#PB_Flag_MultiSelect)
  
  a=0
  *w\hide = 1
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddItem (*w, -1, "Item "+Str(a), 0)
    
    If a & $f=$f
      WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If a & $8ff=$8ff
      WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - widget add items time count - " + CountItems(*w)
  *w\hide = 0
  Redraw(*w)
      
   HideGadget(0, 1)
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0)
    
    If a & $f=$f
      WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If a & $8ff=$8ff
      WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - gadget add items time count - " + CountGadgetItems(0)
   HideGadget(0, 0)
  
  BindGadgetEvent(0, @events_tree_gadget())
  Bind(*w, @events_tree_widget())
      
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = 7-
; EnableXP