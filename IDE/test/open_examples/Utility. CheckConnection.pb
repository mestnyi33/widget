Procedure CheckConnection(IPAddress)
  Connection=OpenNetworkConnection(IPString(IPAddress), 80)
  If Connection
    Result=#True
    
    CloseNetworkConnection(Connection)
  EndIf
  
  ProcedureReturn Result
EndProcedure

InitNetwork()
OpenWindow(0, #PB_Ignore, #PB_Ignore, 160, 120, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
IPAddressGadget(0, 0, 0, 160, 20)
ButtonGadget(1, 0, 20, 160, 20, "Проверить соединение")
TextGadget(2, 0, 60, 160, 60, "", #PB_Text_Center)

Repeat
  Event=WaitWindowEvent()
  Select Event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 1
          IPAddress=GetGadgetState(0)
          State=CheckConnection(IPAddress)
          If State
            State$="Получилось)"
          Else
            State$="Не удалось"
          EndIf
          SetGadgetText(2, State$)
      EndSelect
      
  EndSelect
Until Event=#PB_Event_CloseWindow
; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 28
; Folding = -
; EnableXP
; Executable = C:\Users\Андреич\Desktop\Новая папка (11)\Новая папка\Пинг.exe
; CompileSourceDirectory
; EnableUnicode