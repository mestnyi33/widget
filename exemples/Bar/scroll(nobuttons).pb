IncludePath "../../"
XIncludeFile "widgets.pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule widget
  
  Global.i gEvent, gQuit, canvas
  Global *b.Bar_S;= AllocateStructure(Bar_S)
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 400, 100, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   65, 390,  30, "show scrollbar buttons", #PB_Button_Toggle)
      
      Open(0,10,10, 380, 50)
      ; canvas = _Gadget()
      ; ResizeGadget(OpenList(0), 10,10, 380, 50)
      
      *b = Scroll(5, 10, 370,  30, 20,  50, 8, #PB_Bar_NoButtons)
      *b\step = 1
      
      ReDraw(*b)
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
            SetAttribute(*b, #PB_Bar_NoButtons, GetGadgetState(0) * 17)
            
            If GetGadgetState(0)
              SetGadgetText(0, "hide scrollbar buttons")
            Else
              SetGadgetText(0, "show scrollbar buttons")
            EndIf
        EndSelect
        
;         ; Get interaction with the scroll bar
;         CallBack(*b, EventType())
;         
;         If WidgetEvent() = #PB_EventType_Change
;           Debug "Change scroll direction "+ GetAttribute(EventWidget(), #PB_Bar_Direction)
;           
;           Select EventWidget()
;               
;             Case *b
;               SetWindowTitle(0, Str(GetState(*b)))
;               SetGadgetState(1, GetState(*b))
;               
;           EndSelect
;         EndIf
        
        ReDraw(*b)
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP