IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule widget
  
  Global.i gEvent, gQuit
  Global *Bar_0.Bar_S=AllocateStructure(Bar_S)
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 400, 100, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   65, 390,  30, "set  standart scrollbar", #PB_Button_Toggle)
      
      Open(0, 10,10, 380, 50)
      
      *Bar_0 = Scroll(5, 10, 370, 30, 20, 50, 8, #PB_Bar_Inverted)
      *Bar_0\step = 1
      
      ReDraw(*Bar_0)
    EndIf
  EndProcedure
  
  Window_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            SetAttribute(*Bar_0, #PB_Bar_Inverted, Bool(Not GetGadgetState(0)))
            SetWindowTitle(0, Str(GetState(*Bar_0)))
            If GetGadgetState(0)
              SetGadgetText(0, "set inverted scrollbar")
            Else
              SetGadgetText(0, "set standart scrollbar")
            EndIf
        EndSelect
        
        ; Get interaction with the scroll bar
        CallBack(*Bar_0, EventType())
        
        If WidgetEvent() = #PB_EventType_Change
          Debug "Change scroll direction "+ GetAttribute(EventWidget(), #PB_Bar_Direction)
          
          Select EventWidget()
              
            Case *Bar_0
              SetWindowTitle(0, Str(GetState(*Bar_0)))
              
          EndSelect
        EndIf
        
        ReDraw(*Bar_0)
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP