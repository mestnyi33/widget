IncludePath "../../"
XIncludeFile "widgets.pbi"

UseModule Widget
Procedure Gadget(Window, X,Y,Width,Height, Flag=0)
  ;Open(0, X,Y,Width,Height,"")
  Root() = Tree(x, y, Width,Height, Flag)
  PostEvent(#PB_Event_Gadget, 0, RootGadget(), #PB_EventType_Repaint)
  ProcedureReturn Root()\Canvas
EndProcedure
#PB_Flag_AlwaysSelection=40
#PB_Flag_BorderLess = 1
; Macro GetGadgetData(Gadget)
;   Root()
; EndMacro

Enumeration
  #Window
  
  
  #Tree3
  #Tree4
  #TreeDragType
EndEnumeration


OpenWindow(#Window, 0, 0, 425, 345, "Drag & Drop", #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered)
Open(#Window, 0, 0, 425, 345,"")
; PostEvent(#PB_Event_Gadget, RootWindow(), RootGadget(), #PB_EventType_Repaint)
   
Tree1 = Tree(10, 10, 200, 160)

Tree2 = Tree(X(Tree1) + Width(Tree1) + 5, 10, 200, 160)

For i = 0 To 5
  AddItem(Tree1, -1, "Item "+Str(i))
Next

TreeGadget(#Tree3, 10, 175, 200, 160)
TreeGadget(#Tree4, GadgetX(#Tree3) + GadgetWidth(#Tree3) + 5, 175, 200, 160)

For i = 0 To 5
  AddGadgetItem(#Tree3, -1, "Item "+Str(i))
Next

; EnableGadgetDrop(Tree2, #PB_Drop_, #PB_Drag_Copy, #TreeDragType)
; EnableGadgetDrop(#Tree4, #PB_Drop_, #PB_Drag_Copy, #TreeDragType)

EnableDrop(Tree2, #PB_Drop_Text, #PB_Drag_Copy)
EnableGadgetDrop(#Tree4, #PB_Drop_Text, #PB_Drag_Copy)

Redraw(Root())

Repeat
  
  event = WaitWindowEvent()
  
  Select event
      
    Case #PB_Event_Widget
      If EventType() = #PB_EventType_DragStart And EventGadget() = Tree1
        DragText(GetText(Tree1))
         ;  DragPrivate(#TreeDragType, #PB_Drag_Copy)
        Debug "Widget drag start "
      EndIf
      
    Case #PB_Event_Gadget
      If EventType() = #PB_EventType_DragStart And EventGadget() = #Tree3
        DragText(GetGadgetText(Tree1))
         ;  DragPrivate(#TreeDragType, #PB_Drag_Copy)
        Debug "Gadget drag start "
      EndIf
      
    Case #PB_Event_GadgetDrop
      Debug EventDropType()
      ;       If EventDropText()
      ;       ; If EventDropPrivate() = #TreeDragType
      ;         AddItem(Tree2, -1, "Item")
      ;         ReDraw(Tree2)
      ;       EndIf
      
    Case #PB_Event_CloseWindow
      End
      
  EndSelect
  
ForEver
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP