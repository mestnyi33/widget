;-TOP

; Comment : RunLoopTimer; None blocking GUI
; Author  : mk-soft
; Source  : Thanks to Wilbert, 25.10.2015
; Version : 1.02.0
; Create  : 14.02.2021
; Update  : 19.03.2021

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
  
  ; Syntax Callback:
  ; - ProcedureC MyTimerCallback(timer, *info)
  
  ImportC ""
    CFRelease(object)
    CFAbsoluteTimeGetCurrent.d()
    CFRunLoopAddCommonMode(rl, mode)
    CFRunLoopAddTimer(rl, timer, mode)
    CFRunLoopGetCurrent()
    CFRunLoopGetMain()
    CFRunLoopTimerGetNextFireDate.d(timer)
    CFRunLoopRemoveTimer(rl, timer, mode)
    CFRunLoopTimerCreate(allocator, fireDate.d, interval.d, flags, order, callout, *context)
    dlsym(handle, symbol.p-utf8)
  EndImport
  
  Structure struct_CFRunLoopTimerContext
    Version.i
    *Info
    *Retain
    *Release
    *copyDescription
  EndStructure
  
  Structure struct_CFRunLoopTimers
    Timer.i
    Context.struct_CFRunLoopTimerContext
  EndStructure
  
  Global *NSEventTrackingRunLoopMode.Integer = dlsym(-2, "NSEventTrackingRunLoopMode")
  Global *NSModalPanelRunLoopMode.Integer = dlsym(-2, "NSModalPanelRunLoopMode")
  Global *kCFRunLoopCommonModes.Integer = dlsym(-2, "kCFRunLoopCommonModes")
  
  Global NewMap RunLoopTimers.struct_CFRunLoopTimers()
  
  Procedure RunLoopRemoveTimer(Timer)
    Protected runLoop
    If FindMapElement(RunLoopTimers(), Str(Timer))
      myTimer = RunLoopTimers()\Timer
      runLoop = CFRunLoopGetCurrent()
      CFRunLoopRemoveTimer(runLoop, myTimer, *kCFRunLoopCommonModes\i)
      CFRelease(myTimer)
      DeleteMapElement(RunLoopTimers())
    EndIf
  EndProcedure
  
  Procedure RunLoopAddTimer(Timer, Timeout, TimerCallbackC, *Info = 0)
    Static runLoop
    Protected time.d, myTimer
    If Not runLoop
      runLoop = CFRunLoopGetCurrent()
      CFRunLoopAddCommonMode(runLoop, *NSEventTrackingRunLoopMode\i)
    EndIf
    RunLoopRemoveTimer(Timer)
    If AddMapElement(RunLoopTimers(), Str(Timer))
      RunLoopTimers()\Context\Info = *Info
      time = Timeout / 1000.0
      myTimer = CFRunLoopTimerCreate(#Null, CFAbsoluteTimeGetCurrent(), time, 0, 0, TimerCallbackC, RunLoopTimers()\Context)
      If myTimer
        RunLoopTimers()\Timer = myTimer
        CFRunLoopAddTimer(runLoop, myTimer, *kCFRunLoopCommonModes\i)
      Else
        DeleteMapElement(RunLoopTimers())
      EndIf
    EndIf
    ProcedureReturn myTimer
  EndProcedure
  
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  
  Define start_counter = 1
  
  ; Timer callback
  
  ProcedureC MyTimerCallback(timer, *info)
    AddGadgetItem(0, 0, "Start " + Str(*info) + #LF$ + StrD(CFRunLoopTimerGetNextFireDate(timer), 1))
  EndProcedure
  
  ; Window resize callback
  
  Procedure UpdateWindow()
    ResizeGadget(0, 10, 10, WindowWidth(0) - 20, WindowHeight(0) - 20)
  EndProcedure
  
  ; Main
  
  If OpenWindow(0, 0, 0, 400, 300, "Runloop Timer Example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
    CreateMenu(0, WindowID(0))
    MenuTitle("Timer")
    MenuItem(0, "Start")
    MenuItem(1, "Stop")
    
    ListIconGadget(0, 10, 10, 380, 280, "Info", 140)
    AddGadgetColumn(0, 1, "Next Time", 200)
    
    BindEvent(#PB_Event_SizeWindow, @UpdateWindow())
    
    RunLoopAddTimer(1, 500, @MyTimerCallback(), start_counter)
    
    Repeat
      Select WaitWindowEvent()
        Case #PB_Event_CloseWindow
          Break
        Case #PB_Event_Menu
          Select EventMenu()
            Case 0
              start_counter + 1
              RunLoopAddTimer(1, 500, @MyTimerCallback(), start_counter)
            Case 1
              RunLoopRemoveTimer(1)
          EndSelect
      EndSelect
    ForEver
    RunLoopRemoveTimer(1)
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP