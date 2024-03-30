Procedure Open( id, flag=0 )
   Static x,y
   OpenWindow( id, x,y,200,200,"window_"+Str(id), #PB_Window_SystemMenu|flag)
   CanvasGadget( id, 40,40,200-80,55, #PB_Canvas_Keyboard | #PB_Canvas_Container) : CloseGadgetList()
   CanvasGadget( 10+id, 40,110,200-80,55, #PB_Canvas_Keyboard)
   x + 100
   y + 100
EndProcedure


Open(1, #PB_Window_NoActivate)
Open(2, #PB_Window_NoActivate)
Open(3, #PB_Window_NoActivate)


Repeat
   event = WaitWindowEvent(1)
   
   Select event
      Case #PB_Event_ActivateWindow
         Debug "active - "+ EventWindow()
      Case #PB_Event_DeactivateWindow
         Debug "deactive - "+ EventWindow()
         
      Case #PB_Event_Gadget
         Select EventType()
            Case #PB_EventType_Focus
               Debug "focus - "+EventGadget()
            Case #PB_EventType_LostFocus
               Debug "lostfocus - "+EventGadget()
               
               
            Case #PB_EventType_LeftButtonDown
               Debug "down - "+EventGadget()
               
            Case #PB_EventType_LeftButtonUp
               Debug "up - "+EventGadget()
               
         EndSelect
         
   EndSelect
   
Until event = #PB_Event_CloseWindow

; result
; ; windows
; active - 1
; focus - 1
; deactive - 1
; active - 3
; lostfocus - 1
; focus - 3
; deactive - 3
; lostfocus - 3
; focus - 1
; active - 1
; deactive - 1
; lostfocus - 1
;
; ; linux
; active - 1
; focus - 1
; deactive - 1
; lostfocus - 1
; active - 3
; focus - 3
; deactive - 3
; lostfocus - 3
; active - 1
; focus - 1
; deactive - 1
; lostfocus - 1
;
; ; macos
; active - 3
; deactive - 3
; active - 1
; focus - 1
; deactive - 1
; active - 3
; focus - 3
; deactive - 3
; active - 1
; deactive - 1
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 9
; Folding = -
; EnableXP