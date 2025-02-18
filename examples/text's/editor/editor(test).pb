
 XIncludeFile "../../../widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
 EnableExplicit
  UseWidgets( )
  
  Define a,i
  Global  g, Text.s
  ; Define m.s=#CRLF$
  Define m.s=#LF$
  Global Splitter
  
  Text.s = "This is a long line" + m.s +
           "Who should show," + m.s +
           "I have to write the text in the box or not." + m.s +
           "The string must be very long" + m.s +
           "Otherwise it will not work."
 
  Procedure ResizeCallBack()
    Resize(Splitter, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-16, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
  EndProcedure
  
  Procedure Event_s( )
     Select WidgetEvent( )
        Case #__event_Change
           SetGadgetText(10, "set change text")
           SetText(g, "set change text")
            
     EndSelect
  EndProcedure
  
  LoadFont(0, "Courier", 14)
  If OpenWindow(0, 0, 0, 522, 490, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    Open(0, 30, 30 )
    EditorGadget(10, 8, 8, 306, 133) 
    SetGadgetText(10, Text.s)
    For a = 0 To 5
      AddGadgetItem(10, a, "Line "+Str(a))
    Next
    SetGadgetFont(10, FontID(0))
   
    g=Editor(8, 133+5+8, 306, 133) 
    SetText(g, Text.s)
    For a = 0 To 5
      AddItem(g, a, "Line "+Str(a))
    Next
    SetFont(g, (0))
   
    Splitter = Splitter(8, 8, 306, 276, 10,g)
    
    ReDraw(root())
    
    
    
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    Bind(#PB_All, @Event_s( ))
    Repeat
      Define Event = WaitWindowEvent()
     
      Select Event
         Case #PB_Event_Gadget
            If EventGadget() = 10
               Select EventType()
                  Case #PB_EventType_Focus    
                     SetGadgetText(10, "settext")
                     SetText(g, "settext")
                     ReDraw(root())
               EndSelect
            EndIf
            
         Case #PB_Event_LeftClick 
            SetActiveGadget(10)
            SetGadgetText(10, Text)
            SetText(g, Text)
            
         Case #PB_Event_RightClick
            SetActiveGadget(20)
      EndSelect
   Until Event = #PB_Event_CloseWindow
EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 48
; FirstLine = 35
; Folding = --
; EnableXP
; DPIAware