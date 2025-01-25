Global group.i,cost.i

Procedure Message( title.s, Text.s, flags = 0, parentID = 0)
   ;Open(10, #PB_Ignore, #PB_Ignore, 275, 110, "Test", #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
         
    MessageRequester(title, Text, flags, parentID )
EndProcedure

Procedure Events( )
   Select EventGadget( )
      Case group
         Debug 66
         Message("Warning", "Group code must be four characters", #PB_MessageRequester_Error)
          
      Case cost
         Debug 77
         Message("Warning", "Cost must be positive And Not more than 999.99", #PB_MessageRequester_Error)
         
   EndSelect
EndProcedure

Procedure WaitClose( )
     Repeat 
     Until WaitWindowEvent( ) = #PB_Event_CloseWindow
  EndProcedure
  
  
win.i = OpenWindow(0, #PB_Ignore, #PB_Ignore, 475, 210, "Test", #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

group.i  = StringGadget(#PB_Any, 150, 60, 100, 25, "ABC") 
cost.i   = StringGadget(#PB_Any, 150, 95, 100, 25, "1000") 

BindGadgetEvent( group, @Events( ), #PB_EventType_LostFocus )
BindGadgetEvent( cost, @Events( ), #PB_EventType_LostFocus )

SetActiveGadget(group.i)

WaitClose( )
End
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 5
; Folding = -
; EnableXP