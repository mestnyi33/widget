XIncludeFile "../../../widgets.pbi"
;   WordWrap ! 1
;         SetGadgetAttribute(0, #PB_Editor_WordWrap, WordWrap)
      
CompilerIf #PB_Compiler_IsMainFile
 EnableExplicit
  UseLib(widget)
  
  Define a,i
  Define g, Text.s
  ; Define m.s=#CRLF$
  Define m.s=#LF$
  Global splitter
  
  Text.s = "This is a long line" + m.s +
           "Who should show," + m.s +
           "I have to write the text in the box or not." + m.s +
           "The string must be very long" + m.s +
           "Otherwise it will not work."
 
  Procedure ResizeCallBack()
    Resize(splitter, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-16, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
  EndProcedure
 
  LoadFont(0, "Courier", 14)
  If Open(0, 0, 0, 522, 490, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    
    EditorGadget(0, 8, 8, 306, 133) 
    SetGadgetText(0, Text.s)
    For a = 0 To 5
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    SetGadgetFont(0, FontID(0))
   
    g=Editor(8, 133+5+8, 306, 133) 
    SetText(g, Text.s)
    For a = 0 To 5
      AddItem(g, a, "Line "+Str(a))
    Next
    SetFont(g, FontID(0))
   
    splitter = Splitter(8, 8, 306, 276, 0,g)
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
   
    Repeat
      Define Event = WaitWindowEvent()
     
      Select Event
        Case #PB_Event_LeftClick 
          SetActiveGadget(0)
        Case #PB_Event_RightClick
          SetActiveGadget(10)
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 2
; Folding = -
; EnableXP