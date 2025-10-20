XIncludeFile "../../../widgets.pbi" 
UseWidgets( )
test_focus_set = 1
test_focus_draw = 1

Global group.i,cost.i
Declare OpenMessage( title.s, Text.s, flags = 0, parentID = 0)

Procedure FocusEvents( )
   Select EventWidget( )
      Case group
         Debug "--- focus ABC"
         
      Case cost
         Debug "--- focus 1000"
         
      Default  
         Debug "------- focus "+GetClass(EventWidget())
         
   EndSelect
EndProcedure

Procedure LostFocusEvents( )
   Select EventWidget( )
      Case group
         If ActiveWindow( ) = GetWindow( EventWidget( ))
         ;If ActiveGadget( ) <> EventWidget( )
            Debug "--- lostfocus ABC"
            OpenMessage("Warning", "Group code must be four characters", #PB_MessageRequester_Error)
         Else
            Debug "LOST1  "+ActiveGadget( )\class +" "+ EventWidget( )\class
         EndIf
         
      Case cost
         
         If ActiveWindow( ) = GetWindow( EventWidget( ))
         ;If ActiveGadget( ) <> EventWidget( )
            Debug "--- lostfocus 1000"
            OpenMessage("Warning", "Cost must be positive And Not more than 999.99", #PB_MessageRequester_Error )
         Else
            Debug "LOST2  "+ActiveGadget( )\class +" "+ EventWidget( )\class
         EndIf
         
      Default
         Debug "lostfocus "+GetClass(EventWidget( ))
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
   test_focus_draw = 0
   ;Define Message = Message(title, Text, flags, parentID ) 
   ; Define Message = MessageRequester(title, Text, flags, parentID );
   
   ;SetActive( cost )
   ; Debug 111111
   ; ReDraw(GetRoot(cost))
   ; SetActiveGadget(-1)
   ; SetActiveGadget(EventGadget())
   
   Define Message = Message(title, Text, flags, parentID ) 
   ; WaitQuit()
   test_focus_draw = 1
   ProcedureReturn Message
EndProcedure



win.i = Open(0, #PB_Ignore, #PB_Ignore, 475, 210, "Test", #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
StickyWindow( 0, #True )
: SetClass(widget(), "mainroot" )

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
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 66
; FirstLine = 46
; Folding = --
; EnableXP
; DPIAware