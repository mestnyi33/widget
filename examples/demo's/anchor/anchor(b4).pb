;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../widget-events.pbi" 

EnableExplicit
Uselib(widget)
Global alpha = 192

; Constants for the context menu.
Enumeration 1
  #Menu
  #MenuItem_ZOrder_Top
  #MenuItem_ZOrder_Up
  #MenuItem_ZOrder_Down
  #MenuItem_ZOrder_Bottom
EndEnumeration

Procedure menu_events()
  ;Case #PB_Event_Menu
  Protected CurrentObject = a_enter_widget( )
  
  If CurrentObject
    Select EventMenu()
      Case #MenuItem_ZOrder_Top
        SetPosition(CurrentObject, #PB_List_Last) 
      Case #MenuItem_ZOrder_Up
        SetPosition(CurrentObject, #PB_List_After) 
      Case #MenuItem_ZOrder_Down
        SetPosition(CurrentObject, #PB_List_Before) 
      Case #MenuItem_ZOrder_Bottom
        SetPosition(CurrentObject, #PB_List_First) 
    EndSelect
    
    Redraw( root( ) )
    ; Repaints( )
  EndIf
  
EndProcedure

Procedure right_events()
  ;Case #EventType_RightMouseClick
  DisplayPopupMenu(#Menu, WindowID(EventWindow())) ; The context menu is displayed.
  
EndProcedure

If Open(#PB_Any, 0, 0, 800, 450, "Example 4: Changing the order of the objects (context menu via right click)", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ; Creation of the context menu to change the layer position of the selected object.
  CreatePopupMenu(#Menu)
  MenuItem(#MenuItem_ZOrder_Top, "Push to top most layer")
  MenuItem(#MenuItem_ZOrder_Up, "Push one layer up")
  MenuItem(#MenuItem_ZOrder_Down, "Push one layer down")
  MenuItem(#MenuItem_ZOrder_Bottom, "Push to the deepest layer")
  
  Container(0, 0, 800, 450) 
  a_init(widget() , 8)
  SetColor(widget(), #__color_back, RGBA(255, 255, 255, alpha))
  
  a_object(20, 20, 200, 100, "Layer = 1", RGBA(64, 128, 192, alpha))
  a_object(50, 50, 200, 100, "Layer = 2", RGBA(192, 64, 128, alpha))
  a_object(80, 80, 200, 100, "Layer = 3", RGBA(128, 192, 64, alpha))
  a_object(110, 110, 200, 100, "Layer = 4", RGBA(192, 128, 64, alpha))
  a_object(140, 140, 200, 100, "Layer = 5", RGBA(128, 64, 192, alpha))
  
  BindEvent( #PB_Event_Gadget, @right_events(), getwindow(root()), getgadget(root()), #PB_EventType_RightButtonUp )
  BindEvent( #PB_Event_Menu, @menu_events())
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP