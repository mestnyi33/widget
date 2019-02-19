; Mac os
; 100 65537
; 10 65537
; 1 65537
; 100 65540
; 100 2048 - #PB_EventType_DragStart
; 100 65538
; 10 65538
; 1 65538
; 100 65541

; 200 65537
; 20 65537
; 10 65537
; 1 65537
; 200 65540
; 200 256   - #PB_EventType_Focus
; 200 2048  - #PB_EventType_DragStart
; 200 65538
; 20 65538  - #PB_EventType_Leave
; 10 65538
; 1 65538
; 200 65541

; 1 65537
; 10 65537
; 100 65537
; 100 65540
; 100 65541
; 100 0
; 100 65538
; 10 65538
; 1 65538

; Windows
; 100 65537
; 100 65540
; 100 65541
; 100 65538

; 200 65537
; 200 14000
; 200 65540
; 200 65541
; 200 65538
; 200 14001

; 1 65537
; 1 65538
; 10 65537
; 10 65538
; 100 65537
; 100 65540
; 100 65541
; 100 0
; 100 65538
; 10 65537
; 10 65538
; 1 65537
; 1 65538

; Linux
; ; ; ; 100 6
; ; ; ; 10 6
; ; ; ; 1 6
; ; ; ; 200 6
; ; ; ; 20 6
; 1 65537
; 10 65537
; 100 65537
; 100 65540
; 100 65538
; 100 65541
; 100 0
; 100 65538
; 10 65538
; 1 65538

; 1 65537
; 10 65537
; 20 65537
; 200 65537
; 200 65540
; 200 256
; 200 65538
; 200 65541
; 200 0
; 200 65538
; 20 65538
; 10 65538
; 1 65538
; 200 512- #PB_EventType_LostFocus

; 1 65537
; 1 65538
; 10 65537
; 10 65538
; 100 65537
; 100 65540
; 100 65541
; 100 0
; 100 65538
; 10 65537
; 10 65538
; 1 65537
; 1 65538

Procedure Canvas_Events(EventGadget.i, EventType.i)
  Select Event()
    Case #PB_Event_Gadget
      If EventType <> #PB_EventType_MouseMove ;Not (EventType() = #PB_EventType_MouseMove And Not GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons))
        Debug ""+EventGadget+" "+EventType
      EndIf
      
  EndSelect
EndProcedure

Procedure.i Canvas_CallBack()
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    Protected EventType.i = EventType()
;     Protected x = GadgetX(EventGadget, #PB_Gadget_ScreenCoordinate)
;     Protected y = GadgetY(EventGadget, #PB_Gadget_ScreenCoordinate)
;     Protected Width = GadgetWidth(EventGadget)
;     Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = DesktopMouseX()
    Protected MouseY = DesktopMouseY()
    
    ; Это из за ошибки в мак ос и линукс
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS Or #PB_Compiler_OS = #PB_OS_Linux
      Select EventType 
        Case #PB_EventType_MouseEnter 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) Or MouseLeave =- 1
            EventType = #PB_EventType_MouseMove
            MouseLeave = 0
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) And GetActiveGadget()=EventGadget
            EventType = #PB_EventType_MouseMove
            MouseLeave = 1
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If GetActiveGadget()<>EventGadget
            SetActiveGadget(EventGadget)
          EndIf
          
        Case #PB_EventType_LeftButtonUp
          If MouseLeave = 1 ; And Not Bool((MouseX>=x And MouseX<x+Width) And (MouseY>=y And MouseY<y+Height))
            MouseLeave = 0
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    
    If EventType = #PB_EventType_MouseMove
;             Static Last_X, Last_Y
;             If Last_Y <> Mousey
;               Last_Y = Mousey
       Result | Canvas_Events(EventGadget, EventType)
;             EndIf
;             If Last_x <> Mousex
;               Last_x = Mousex
;               Result | Canvas_Events(EventGadget, EventType)
;             EndIf
    Else
      Result | Canvas_Events(EventGadget, EventType)
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
Procedure Handler()
  Select Event()
    Case #PB_Event_Gadget
      If EventType() <> #PB_EventType_MouseMove ;Not (EventType() = #PB_EventType_MouseMove And Not GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons))
        Debug "  "+EventGadget()+" "+EventType()
      EndIf
      
  EndSelect
EndProcedure


Procedure Button(Gadget, X.i,Y.i,Width.i,Height.i, Text.s, Flag=0)
  CanvasGadget(Gadget, X.i,Y.i,Width.i,Height.i, #PB_Canvas_Keyboard|#PB_Canvas_Border|Flag)
  
  If StartDrawing(CanvasOutput(Gadget))
    DrawText(2,0, Text, 0, $FFFFFF)
    StopDrawing()
  EndIf
EndProcedure


 ;BindEvent(#PB_Event_Gadget, @Handler())
 BindEvent(#PB_Event_Gadget, @Canvas_CallBack())

OpenWindow(0, 100, 100, 220, 220, "Window_0", #PB_Window_SystemMenu);, WindowID(100))
Button(1, 20, 20, 180, 180, "1", #PB_Canvas_Container)
Button(10, 20, 20, 180, 180, "10", #PB_Canvas_Container)
Button(100, 20, 20, 180, 50, "100")

Button(20, 20, 70, 180, 180, "20", #PB_Canvas_Container)
Button(200, 20, 20, 180, 50, "200")

SetActiveGadget(20)

Repeat
  Event = WaitWindowEvent()
  
  Select Event
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick 
          Select EventGadget()
          EndSelect
      EndSelect
  EndSelect
  
Until Event = #PB_Event_CloseWindow


; Mac os
; right >> 100             ; right >> 100  
; 20 256                   ; 20 14000
; 100 65537                ; 100 65537
; 10 65537
; 1 65537
; 
;   100 65539              ;   100 65539
;   10 65539
;   1 65539
;   100 65539              ;   100 65539
;   10 65539
;   1 65539
; 
; 100 65540                ; 20 14001
; 20 512                   ; 100 14000
; 100 256                  ; 100 65540
; 100 2048
; 
;   100 65539              ;   100 65539
; 
; 100 65538
; 
;   100 65539              ;   100 65539
;                          
; 10 65538
; 
;   100 65539              ;   100 65539
; 
; 1 65538
; 
;   100 65539              ;   100 65539
; 
; 100 65541                ; 100 65541
                           ; 100 65538
                           ; 100 14001

; mac
; top in
; 1 65537
; 10 65537
; 100 65537
; 100 65538
; 10 65538
; 1 65538

;right in
; 100 65537
; 10 65537
; 1 65537
; 100 65538
; 10 65538
; 1 65538

; win
; top
; 1 65537
; 1 65538
; 10 65537
; 10 65538
; 100 65537
; 100 65538
; 10 65537
; 10 65538
; 1 65537
; 1 65538

; right
; 100 65537
; 100 65538

; lin
; top
; 1 65537
; 1 65538
; 10 65537
; 10 65538
; 100 65537
; 100 65538
; 10 65537
; 10 65538
; 1 65537
; 1 65538

; right
; 1 65537
; 10 65537
; 100 65537
; 100 65538
; 10 65538
; 1 65538

; mac
; 20 256
; 1 65537
; 1 65540
; 20 512
; 1 256
; 1 2048
; 1 65541
; 100 65537
; 10 65537

;win
; 20 14000
; 1 65537
; 20 14001
; 1 14000
; 1 65540
; 1 65541
; 1 0
; 100 65537
; 1 65538

; lin
; 20 256
; 1 65537
; 1 65540
; 20 512
; 1 256
; 1 65538
; 1 65541
; 1 0
; 1 65538
; 10 65537
; 100 65537
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ----
; EnableXP