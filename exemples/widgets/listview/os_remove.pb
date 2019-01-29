If OpenWindow(0, 0, 0, 270, 140, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   ListViewGadget(0, 10, 10, 250, 120)
    
    For a = 1 To 100
      AddGadgetItem (0, -1, "Item " + Str(a) + " of the Listview") ; define listview content
    Next
    
    Define time = ElapsedMilliseconds()
    count = CountGadgetItems(0) 
    
    Debug " gadget items count "+count
    
    For a = 0 To count 
      RemoveGadgetItem(0, a) 
    Next 
    
    Debug Str(ElapsedMilliseconds()-time) + " - remove gadget items time"
    Debug " after remove items count - " + CountGadgetItems(0)
  
  
    Debug "  "
  
    NewList el.i()
    
    For a = 1 To 100
      AddElement(el()) 
      el() = i
    Next
    
    Define time = ElapsedMilliseconds()
    count = ListSize(el()) 
    
    Debug " elements count "+count
    
    For a = 0 To count 
      PushListPosition(el())
      If SelectElement(el(), a)
        DeleteElement(el(), 1) 
      EndIf
      PopListPosition(el())
    Next 
    
    Debug Str(ElapsedMilliseconds()-time) + " - remove elements time"
    Debug " after remove element count - " + ListSize(el()) 
  
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP