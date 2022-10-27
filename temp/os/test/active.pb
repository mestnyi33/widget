
Procedure active()
  Debug ""+EventWindow() +" "+ #PB_Compiler_Procedure + " window"
EndProcedure

Procedure deactive()
  Debug ""+EventWindow() +" "+ #PB_Compiler_Procedure + " window"
EndProcedure

Procedure events()
  Select EventType()
    Case #PB_EventType_Focus
      Debug "  "+EventGadget() +" active" + " gadget"
    Case #PB_EventType_LostFocus
      Debug "  "+EventGadget() +" deactive" + " gadget"
  EndSelect
EndProcedure

Define width=500, height=400

;   Bind(#PB_All, @active(), #PB_EventType_Focus)
;   Bind(#PB_All, @deactive(), #PB_EventType_LostFocus)

OpenWindow(10,10, 10, 190, 90, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
StringGadget(1,10, 10, 170, 30,"1")
;   ;setactivegadget(1)
;   Bind( 1, @active_0(), #PB_EventType_Focus)
;   Bind( 1, @deactive_0(), #PB_EventType_LostFocus)

StringGadget(4,10,50,170,30,"4")
;   ;setactivegadget(4)
;   Bind( 4, @active_0(), #PB_EventType_Focus)
;   Bind( 4, @deactive_0(), #PB_EventType_LostFocus)

OpenWindow(20,110, 30, 190, 90, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
StringGadget(2,10,10,170,30,"2")
;   ;setactivegadget(2)
;   Bind( 2, @active_0(), #PB_EventType_Focus)
;   Bind( 2, @deactive_0(), #PB_EventType_LostFocus)

StringGadget(5,10,50,170,30,"5")
;   ;setactivegadget(5)
;   Bind( 5, @active_0(), #PB_EventType_Focus)
;   Bind( 5, @deactive_0(), #PB_EventType_LostFocus)

OpenWindow(30,220, 50, 190, 90, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
StringGadget(3,10,10,170,30,"3")
;   ;setactivegadget(3)
;   Bind( 3, @active_0(), #PB_EventType_Focus)
;   Bind( 3, @deactive_0(), #PB_EventType_LostFocus)

StringGadget(6,10,50,170,30,"6")
;   ;setactivegadget(6)
;   Bind( 6, @active_0(), #PB_EventType_Focus)
;   Bind( 6, @deactive_0(), #PB_EventType_LostFocus)


;   Bind( #PB_All, @active_0(), #PB_EventType_Focus)
;   Bind( #PB_All, @deactive_0(), #PB_EventType_LostFocus)

BindEvent(#PB_Event_ActivateWindow, @active())
BindEvent(#PB_Event_DeactivateWindow, @deactive())


BindEvent(#PB_Event_Gadget, @events())

Repeat
  Event = WaitWindowEvent()
  
  If Event = #PB_Event_CloseWindow 
    Quit = 1
  EndIf
  
;   If Event = #PB_Event_Gadget
;     Select EventType()
;       Case #PB_EventType_Focus
;         Debug "  --- "+EventGadget() +" active" + " gadget"
;       Case #PB_EventType_LostFocus
;         Debug "  --- "+EventGadget() +" deactive" + " gadget"
;     EndSelect
;   EndIf
Until Quit



; Procedure active()
;   If Not Event() = #PB_Event_Gadget
;     Debug ""+EventWindow() +" "+ #PB_Compiler_Procedure + " window"
;   Else
;     Debug "  "+EventGadget() +" "+ #PB_Compiler_Procedure + " gadget"
;   EndIf
; EndProcedure
; 
; Procedure deactive()
;   If Not Event() = #PB_Event_Gadget
;     Debug ""+EventWindow() +" "+ #PB_Compiler_Procedure + " window"
;   Else
;     Debug "  "+EventGadget() +" "+ #PB_Compiler_Procedure + " gadget"
;   EndIf
; EndProcedure
; 
; Define width=500, height=400
; 
; ;   Bind(#PB_All, @active(), #PB_EventType_Focus)
; ;   Bind(#PB_All, @deactive(), #PB_EventType_LostFocus)
; 
;   OpenWindow(0,10, 10, 190, 90, "0", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
;   StringGadget(0,10,10,170,30,"10")
; ;   ;setactivegadget(0)
; ;   Bind( 0, @active_0(), #PB_EventType_Focus)
; ;   Bind( 0, @deactive_0(), #PB_EventType_LostFocus)
;   
;   StringGadget(1,10,50,170,30,"1")
; ;   ;setactivegadget(1)
; ;   Bind( 1, @active_0(), #PB_EventType_Focus)
; ;   Bind( 1, @deactive_0(), #PB_EventType_LostFocus)
;   
;   OpenWindow(1,110, 30, 190, 90, "1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
;   StringGadget(2,10,10,170,30,"2")
; ;   ;setactivegadget(2)
; ;   Bind( 2, @active_0(), #PB_EventType_Focus)
; ;   Bind( 2, @deactive_0(), #PB_EventType_LostFocus)
;   
;   StringGadget(3,10,50,170,30,"3")
; ;   ;setactivegadget(3)
; ;   Bind( 3, @active_0(), #PB_EventType_Focus)
; ;   Bind( 3, @deactive_0(), #PB_EventType_LostFocus)
;   
;   OpenWindow(2,220, 50, 190, 90, "2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
;   StringGadget(4,10,10,170,30,"4")
; ;   ;setactivegadget(4)
; ;   Bind( 4, @active_0(), #PB_EventType_Focus)
; ;   Bind( 4, @deactive_0(), #PB_EventType_LostFocus)
;   
;   StringGadget(5,10,50,170,30,"5")
; ;   ;setactivegadget(5)
; ;   Bind( 5, @active_0(), #PB_EventType_Focus)
; ;   Bind( 5, @deactive_0(), #PB_EventType_LostFocus)
;   
;     
; ;   Bind( #PB_All, @active_0(), #PB_EventType_Focus)
; ;   Bind( #PB_All, @deactive_0(), #PB_EventType_LostFocus)
;   
;   BindEvent(#PB_Event_ActivateWindow, @active())
;   BindEvent(#PB_Event_DeactivateWindow, @deactive())
; 
;   
;   BindEvent(#PB_Event_Gadget, @active(), 0,0,#PB_EventType_Focus)
;   BindEvent(#PB_Event_Gadget, @deactive(), 0,1,#PB_EventType_LostFocus)
; 
;   BindEvent(#PB_Event_Gadget, @active(), 1,2,#PB_EventType_Focus)
;   BindEvent(#PB_Event_Gadget, @deactive(), 1,3,#PB_EventType_LostFocus)
; 
;   BindEvent(#PB_Event_Gadget, @active(), 2,4,#PB_EventType_Focus)
;   BindEvent(#PB_Event_Gadget, @deactive(), 2,5,#PB_EventType_LostFocus)
; 
;   
;   Repeat
;     Event = WaitWindowEvent()
;     
;     If Event = #PB_Event_CloseWindow 
;       Quit = 1
;     EndIf
;     
;   Until Quit = 1
; 
; End  
; IDE Options = PureBasic 5.72 (Linux - x64)
; CursorPosition = 54
; FirstLine = 46
; Folding = -
; EnableXP