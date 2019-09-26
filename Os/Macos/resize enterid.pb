; *** import the required functions ***

ImportC ""
  sel_registerName(str.p-ascii)
  class_addMethod(class, selector, imp, types.p-ascii)
EndImport

; *** required variables ***

Global notificationCenter = CocoaMessage(0, 0, "NSNotificationCenter defaultCenter")
Global appDelegate = CocoaMessage(0, CocoaMessage(0, 0, "NSApplication sharedApplication"), "delegate")
Global delegateClass = CocoaMessage(0, appDelegate, "class")

Define selector


; *** Window0 resize callback ***

ProcedureC Window0_Resize(obj, sel, notification)
  ResizeGadget(0, 10, 10, WindowWidth(0) - 20, WindowHeight(0) - 20)
EndProcedure


; *** main code ***
Procedure enterID(WindowID)
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Protected pt.NSPoint
      
      Protected CV = CocoaMessage(0, WindowID, "contentView")
      CocoaMessage(@pt, WindowID, "mouseLocationOutsideOfEventStream")
      ProcedureReturn CocoaMessage(0, CV, "hitTest:@", @pt)
    CompilerEndIf
  EndProcedure
  
  
If OpenWindow(0, 0, 0, 320, 470, "Window live resize", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
  WindowID = WindowID(0)
  
  EditorGadget(0, 10, 10, 300, 150)
  
  ButtonGadget(0,10,10,100,100,"Blub1")
ButtonGadget(1,10,110,100,100,"Blub2")

CreateStatusBar(0,WindowID(0))
AddStatusBarField(#PB_Ignore)

  selector = sel_registerName("Window0_Resize:")
  class_addMethod(delegateClass, selector, @Window0_Resize(), "v@:@")
  CocoaMessage(0, notificationCenter, "addObserver:", appDelegate, "selector:", selector, "name:$", @"NSWindowDidResizeNotification", "object:", WindowID(0))
 
  Repeat
  event = WaitWindowEvent()
  
  If #PB_Event_Repaint
    Select enterID(WindowID)
      Case GadgetID(0)
        StatusBarText(0, 0, "Blub1")
      Case GadgetID(1)
        StatusBarText(0, 0, "Blub2")
      Default
        StatusBarText(0, 0, "")
    EndSelect
   
  EndIf
 
Until event = #PB_Event_CloseWindow
EndIf

CocoaMessage(0, notificationCenter, "removeObserver:", appDelegate, "name:$", @"NSWindowDidResizeNotification", "object:", #nil)
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP