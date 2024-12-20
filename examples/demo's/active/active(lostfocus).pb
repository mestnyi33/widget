XIncludeFile "../../../widgets.pbi" 
UseWidgets( )

Global group.i,cost.i

Procedure Events( )
   Select EventWidget( )
      Case group
         Message("Warning", "Group code must be four characters", #PB_MessageRequester_Error)
         ;MessageRequester("Warning", "Group code must be four characters", #PB_MessageRequester_Error)
         
      Case cost
         Message("Warning", "Cost must be positive And Not more than 999.99", #PB_MessageRequester_Error)
         ;MessageRequester("Warning", "Cost must be positive And Not more than 999.99", #PB_MessageRequester_Error)
         
   EndSelect
EndProcedure


win.i = Open(0, #PB_Ignore, #PB_Ignore, 475, 210, "Test", #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

group.i  = String( 150, 60, 100, 25, "ABC")
cost.i   = String( 150, 95, 100, 25, "1000")

Bind( group, @Events( ), #__event_LostFocus )
Bind( cost, @Events( ), #__event_LostFocus )

SetActive(group.i)
SetActiveGadget(GetCanvasGadget())

WaitClose( )
End
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 13
; FirstLine = 1
; Folding = -
; EnableXP
; DPIAware