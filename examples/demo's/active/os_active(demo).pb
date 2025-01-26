Global group.i,cost.i
Declare Message( title.s, Text.s, flags = 0, parentID = 0)

Procedure LostFocusEvents( )
  Select EventGadget( )
    Case group
       If GetActiveWindow() = EventWindow()
          Debug "lostfocus group"
          Message("Warning", "Group code must be four characters", #PB_MessageRequester_Error)
       EndIf
   
    Case cost
       If GetActiveWindow() = EventWindow()
          Debug "lostfocus cost"
          Message("Warning", "Cost must be positive And Not more than 999.99", #PB_MessageRequester_Error)
       EndIf
       
    Default  
      Debug "lostfocus"
      
  EndSelect
EndProcedure

Procedure FocusEvent( )
  Select EventGadget( )
    Case group
      Debug "focus group"
      
    Case cost
      Debug "focus cost"
      
    Default  
      Debug "focus"
      
  EndSelect
EndProcedure

Procedure Message( title.s, Text.s, flags = 0, parentID = 0)
  OpenWindow(10, #PB_Ignore, #PB_Ignore, 275, 110, "Test", #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  StringGadget(11, 150, 60, 100, 25, "focus") 
  StringGadget(12, 150, 95, 100, 25, "focus") 
  
  BindGadgetEvent( 12, @LostFocusEvents( ), #PB_EventType_LostFocus )
  BindGadgetEvent( 12, @FocusEvent( ), #PB_EventType_Focus )
  
  BindGadgetEvent( 11, @LostFocusEvents( ), #PB_EventType_LostFocus )
  BindGadgetEvent( 11, @FocusEvent( ), #PB_EventType_Focus )
  
  SetActiveGadget(11)
  
  ; MessageRequester(title, Text, flags, parentID )
EndProcedure

Procedure WaitClose( )
  Protected event
  Repeat 
    event = WaitWindowEvent( ) 
    
    If event = #PB_Event_CloseWindow
      If EventWindow( ) = 0
        Break
      Else
        CloseWindow( EventWindow( ) )
      EndIf
    EndIf
  ForEver
EndProcedure


win.i = OpenWindow(0, #PB_Ignore, #PB_Ignore, 475, 210, "Test", #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

group.i  = StringGadget(#PB_Any, 150, 60, 100, 25, "ABC") 
cost.i   = StringGadget(#PB_Any, 150, 95, 100, 25, "1000") 

BindGadgetEvent( group, @LostFocusEvents( ), #PB_EventType_LostFocus )
BindGadgetEvent( cost, @LostFocusEvents( ), #PB_EventType_LostFocus )

BindGadgetEvent( group, @FocusEvent( ), #PB_EventType_Focus )
BindGadgetEvent( cost, @FocusEvent( ), #PB_EventType_Focus )

SetActiveGadget(group.i)

WaitClose( )
End
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 9
; Folding = --
; EnableXP