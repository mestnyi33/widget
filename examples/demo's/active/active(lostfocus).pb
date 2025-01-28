XIncludeFile "../../../widgets.pbi" 
UseWidgets( )
test_focus_set = 1
test_focus_show = 1

Global group.i,cost.i
Declare OpenMessage( title.s, Text.s, flags = 0, parentID = 0)

Procedure FocusEvents( )
   Select EventWidget( )
      Case group
         Debug "focus group"
         
      Case cost
         Debug "focus cost"
         
      Default  
         Debug "focus "+GetClass(EventWidget())
         
   EndSelect
EndProcedure

Procedure LostFocusEvents( )
   Select EventWidget( )
      Case group
         If ActiveWindow( ) = GetWindow( EventWidget())
            Debug "lostfocus group"
            OpenMessage("Warning", "Group code must be four characters", #PB_MessageRequester_Error)
         EndIf
         
      Case cost
         If ActiveWindow( ) = GetWindow( EventWidget())
            Debug "lostfocus cost"
            OpenMessage("Warning", "Cost must be positive And Not more than 999.99", #PB_MessageRequester_Error )
         EndIf
         
      Default
         Debug "lostfocus "+GetClass(EventWidget())
   EndSelect
EndProcedure

Procedure OpenMessage( title.s, Text.s, flags = 0, parentID = 0)
;    Open(10, #PB_Ignore, #PB_Ignore, 275, 110, "Test", #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered , WindowID(0)) ; | #PB_Window_NoActivate
;    Define *g_11 = String(150, 60, 100, 25, "focus") 
;    Define *g_12 = String(150, 95, 100, 25, "focus") 
;    
;    Bind( *g_12, @LostFocusEvents( ), #__event_LostFocus )
;    Bind( *g_12, @FocusEvents( ), #__event_Focus )
;    
;    Bind( *g_11, @LostFocusEvents( ), #__event_LostFocus )
;    Bind( *g_11, @FocusEvents( ), #__event_Focus )
;    
;     Debug " open message"
;     SetActive(*g_11)
; ;    
  ProcedureReturn Message(title, Text, flags, parentID )
   Define Message = MessageRequester(title, Text, flags, parentID );
   SetActiveGadget(GetWindowData(0))
   ProcedureReturn Message
EndProcedure



win.i = Open(0, #PB_Ignore, #PB_Ignore, 475, 210, "Test", #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

group.i  = String( 150, 60, 100, 25, "ABC") : SetClass(widget(), GetText(widget()) )
cost.i   = String( 150, 95, 100, 25, "1000") : SetClass(widget(), GetText(widget()) )

Bind( group, @FocusEvents( ), #__event_Focus )
Bind( cost, @FocusEvents( ), #__event_Focus )

Bind( group, @LostFocusEvents( ), #__event_LostFocus )
Bind( cost, @LostFocusEvents( ), #__event_LostFocus )

 SetActive(group.i)
; SetActiveGadget(GetCanvasGadget())

;OpenMessage("Warning", "Group code must be four characters", #PB_MessageRequester_Error)
         
WaitClose( )
End
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 55
; FirstLine = 45
; Folding = --
; EnableXP
; DPIAware