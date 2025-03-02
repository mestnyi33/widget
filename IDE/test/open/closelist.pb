EnableExplicit

Global Window_0=-1, 
       Window_0_ScrollArea_0=-1, 
       Window_0_Tree_0=-1, 
       Window_0_Panel_0=-1, 
       Window_0_Splitter_0=-1, 
       Window_0_Splitter_1=-1

Declare Window_0_Events()

Procedure Window_0_Open(ParentID.i=#False)
  If Not IsWindow(Window_0)
    Window_0 = OpenWindow(#PB_Any, 7, 7, 501, 401, "Window_0", #PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_SizeGadget, ParentID)                                                                                                                                                                                
    Window_0_ScrollArea_0 = ScrollAreaGadget(#PB_Any, 0, 0, 241, 391, 330, 440, 2)  
    CloseGadgetList()
    Window_0_Tree_0 = TreeGadget(#PB_Any, 245, 0, 241, 192)   
    Window_0_Panel_0 = PanelGadget(#PB_Any, 245, 199, 241, 192)  
    CloseGadgetList()
    
    BindEvent(#PB_Event_Gadget, @Window_0_Events(), Window_0)
  EndIf

  ProcedureReturn Window_0
EndProcedure

Procedure Window_0_Events()
  Select Event()
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Select EventGadget()
             
          EndSelect
      EndSelect
  EndSelect
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  Window_0_Open()

  While IsWindow(Window_0)
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        If IsWindow(EventWindow())
          CloseWindow(EventWindow())
        Else
          CloseWindow(Window_0)
        EndIf
    EndSelect
  Wend
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 13
; FirstLine = 6
; Folding = --
; EnableXP
; DPIAware