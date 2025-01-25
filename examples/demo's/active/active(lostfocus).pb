XIncludeFile "../../../widgets.pbi" 
UseWidgets( )
test_focus_set = 1
   test_focus_show = 1
   
Global group.i,cost.i

Procedure Events( )
   Select EventWidget( )
      Case group
         Debug 66
         ;Open(10, #PB_Ignore, #PB_Ignore, 275, 110, "Test", #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
         ;Message("Warning", "Group code must be four characters", #PB_MessageRequester_Error)
         ;MessageRequester("Warning", "Group code must be four characters", #PB_MessageRequester_Error)
          
      Case cost
         Debug 77
         ; Message("Warning", "Cost must be positive And Not more than 999.99", #PB_MessageRequester_Error)
         ;MessageRequester("Warning", "Cost must be positive And Not more than 999.99", #PB_MessageRequester_Error)
         
   EndSelect
EndProcedure


win.i = Open(0, #PB_Ignore, #PB_Ignore, 475, 210, "Test", #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

group.i  = String( 150, 60, 100, 25, "ABC") : SetClass(widget(), GetText(widget()) )
cost.i   = String( 150, 95, 100, 25, "1000") : SetClass(widget(), GetText(widget()) )

Bind( group, @Events( ), #__event_LostFocus )
Bind( cost, @Events( ), #__event_LostFocus )

SetActive(group.i)
SetActiveGadget(GetCanvasGadget())

WaitClose( )
End
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 11
; FirstLine = 4
; Folding = -
; EnableXP
; DPIAware