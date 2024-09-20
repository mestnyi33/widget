; https://www.purebasic.fr/english/viewtopic.php?p=580773

Procedure events( )
   
EndProcedure

If OpenWindow(0, 0, 0, 600, 400, "Modal Window", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   ButtonGadget(0,95,70,80,24,"button")
   
   dummywin = OpenWindow(#PB_Any, WindowX(0), WindowY(0), WindowWidth(0), WindowHeight(0), "", #PB_Window_BorderLess ,WindowID(0))
   SetWindowLongPtr_(WindowID(dummywin),#GWL_EXSTYLE,GetWindowLongPtr_(WindowID(dummywin),#GWL_EXSTYLE)|#WS_EX_LAYERED) 
   SetLayeredWindowAttributes_(WindowID(dummywin),0,1,#LWA_ALPHA)
   
   OpenWindow(11,0,0,250,100,"Enter Value", #PB_Window_WindowCentered | #PB_Window_Tool,WindowID(dummywin))
   UseGadgetList(WindowID(11))
   TextGadget(22,10,10,230,40,"Some Digits Here",#PB_Text_Center)
   StringGadget(33,105,40,60,24,"",#PB_String_Numeric)
   ButtonGadget(44,95,70,80,24,"Insert")
   
   Repeat
      Select WaitWindowEvent()
         Case #PB_Event_CloseWindow
            Quit = 1
            
         Case #PB_Event_ActivateWindow
            Debug "active - "+EventWindow()
            If EventWindow() = dummywin
               SetForegroundWindow_(WindowID(11))
            EndIf
            
         Case #PB_Event_DeactivateWindow
            Debug "deactive - "+EventWindow()
            
         Case #PB_Event_Gadget
            Select EventGadget()          
               Case 0
                  OpenWindow(11,0,0,250,100,"Enter Value", #PB_Window_WindowCentered | #PB_Window_Tool,WindowID(dummywin))
                  UseGadgetList(WindowID(11))
                  TextGadget(22,10,10,230,40,"Some Digits Here",#PB_Text_Center)
                  StringGadget(33,105,40,60,24,"",#PB_String_Numeric)
                  ButtonGadget(44,95,70,80,24,"Insert")
                  
               Case 44
                  
                  If GetGadgetText(33) <> ""
                     CloseWindow(11)
                     HideWindow(dummywin,1)
                     DisableWindow(0, 0)
                  EndIf
                  
            EndSelect
      EndSelect
      
   Until Quit = 1
   CloseWindow(dummywin)
EndIf

; 
; ExamineDesktops()
; 
; If OpenWindow(0, 0, 0, 600, 400, "Modal Window", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;   dummywin = OpenWindow(#PB_Any, 0, 0, DesktopWidth(0),DesktopHeight(0), "", #PB_Window_BorderLess ,WindowID(0))
;   SetWindowLongPtr_(WindowID(dummywin),#GWL_EXSTYLE,GetWindowLongPtr_(WindowID(dummywin),#GWL_EXSTYLE)|#WS_EX_LAYERED) 
;   SetLayeredWindowAttributes_(WindowID(dummywin),0,1,#LWA_ALPHA)
;   
;   OpenWindow(11,0,0,250,100,"Enter Value", #PB_Window_WindowCentered | #PB_Window_Tool,WindowID(dummywin))
;   value_win_id=WindowID(11)
;   UseGadgetList(value_win_id)
;   TextGadget(22,10,10,230,40,"Some Digits Here",#PB_Text_Center)
;   StringGadget(33,105,40,60,24,"",#PB_String_Numeric)
;   ButtonGadget(44,95,70,80,24,"Insert")
;   
;   Repeat
;     Select WaitWindowEvent(1)
;     
;       Case 0
;       
;         If IsWindow_(value_win_id) And GetForegroundWindow_()<>value_win_id
;           SetForegroundWindow_(value_win_id)
;         EndIf
;     
;       Case #PB_Event_CloseWindow
;         Quit = 1
;         
;       Case #PB_Event_Gadget
;         Select EventGadget()          
;           Case 44
;             If GetGadgetText(33) <> ""
;               CloseWindow(11)
;               HideWindow(dummywin,1)
;               DisableWindow(0, 0)
;             EndIf
;             
;         EndSelect
;     EndSelect
;     
;   Until Quit = 1
;   CloseWindow(dummywin)
; EndIf

; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 11
; Folding = --
; EnableXP