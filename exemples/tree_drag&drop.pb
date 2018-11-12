CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerEndIf

XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_scroll.pbi"
XIncludeFile "module_text.pbi"
XIncludeFile "module_tree.pbi"
UseModule Tree

Enumeration
  #Window
  #Tree1
  #Tree2
  #Tree3
  #Tree4
  #TreeDragType
EndEnumeration


OpenWindow(#Window, 0, 0, 425, 345, "Drag & Drop", #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered)

Gadget(#Tree1, 10, 10, 200, 160)
Gadget(#Tree2, GadgetX(#Tree1) + GadgetWidth(#Tree1) + 5, 10, 200, 160)

For i = 0 To 5
  AddItem(#Tree1, -1, "Item "+Str(i))
Next

TreeGadget(#Tree3, 10, 175, 200, 160)
TreeGadget(#Tree4, GadgetX(#Tree3) + GadgetWidth(#Tree3) + 5, 175, 200, 160)

For i = 0 To 5
  AddGadgetItem(#Tree3, -1, "Item "+Str(i))
Next

; EnableGadgetDrop(#Tree2, #PB_Drop_, #PB_Drag_Copy, #TreeDragType)
; EnableGadgetDrop(#Tree4, #PB_Drop_, #PB_Drag_Copy, #TreeDragType)

EnableGadgetDrop(#Tree2, #PB_Drop_Text, #PB_Drag_Copy)
EnableGadgetDrop(#Tree4, #PB_Drop_Text, #PB_Drag_Copy)

Repeat
  
  event = WaitWindowEvent()
  
  Select event
      
    Case #PB_Event_Widget
      If EventType() = #PB_EventType_DragStart And EventGadget() = #Tree1
        DragText(GetText(#Tree1))
         ;  DragPrivate(#TreeDragType, #PB_Drag_Copy)
        Debug "Widget drag start "
      EndIf
      
    Case #PB_Event_Gadget
      If EventType() = #PB_EventType_DragStart And EventGadget() = #Tree3
        DragText(GetGadgetText(#Tree1))
         ;  DragPrivate(#TreeDragType, #PB_Drag_Copy)
        Debug "Gadget drag start "
      EndIf
      
    Case #PB_Event_GadgetDrop
      Debug EventDropType()
      ;       If EventDropText()
      ;       ; If EventDropPrivate() = #TreeDragType
      ;         AddItem(#Tree2, -1, "Item")
      ;         ReDraw(#Tree2)
      ;       EndIf
      
    Case #PB_Event_CloseWindow
      End
      
  EndSelect
  
ForEver
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -
; EnableXP