EnableExplicit
Global Window_0=-1

Declare Window_0_Events(Event.i)

Procedure Window_0_CallBack()
  Window_0_Events(Event())
EndProcedure

Procedure Window_0_Open(ParentID.i=0, Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If IsWindow(Window_0)
    SetActiveWindow(Window_0)
    ProcedureReturn Window_0
  EndIf
  
  Window_0 = OpenWindow(#PB_Any, 21, 430, 301, 201, "Window_0", Flag, ParentID)
  
  ProcedureReturn Window_0
EndProcedure

Procedure Window_0_Events(Event.i)
  Select Event
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Select EventGadget()
             
          EndSelect
      EndSelect
  EndSelect
  
  ProcedureReturn Event
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
  Window_0_Open()
  
  While IsWindow(Window_0)
    Define.i Event = WaitWindowEvent()
    
    Select EventWindow()
      Case Window_0
        If Window_0_Events( Event ) = #PB_Event_CloseWindow
          CloseWindow(Window_0)
          Break
        EndIf
        
    EndSelect
  Wend
CompilerEndIf