Procedure.s ObjectInheritance(Object)
  
  Protected.i Result
  Protected.i MutableArray = CocoaMessage(0, 0, "NSMutableArray arrayWithCapacity:", 10)
  
  Repeat
    CocoaMessage(0, MutableArray, "addObject:", CocoaMessage(0, Object, "className"))
    CocoaMessage(@Object, Object, "superclass")
  Until Object = 0
  
  CocoaMessage(@Result, MutableArray, "componentsJoinedByString:$", @"  -->  ")
  CocoaMessage(@Result, Result, "UTF8String")
  
  ProcedureReturn PeekS(Result, -1, #PB_UTF8)
  
EndProcedure


If OpenWindow(0, 0, 0, 220, 200, "Object Inheritance", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ;ButtonGadget(0, 10, 10, 200, 20, "text")  ; PBButtonGadgetView  -->  NSButton  -->  NSControl  -->  NSView  -->  NSResponder  -->  NSObject
  StringGadget(0, 10, 10, 200, 20, "text")   ; PBStringGadgetTextField  -->  NSTextField  -->  NSControl  -->  NSView  -->  NSResponder  -->  NSObject
  ;SpinGadget(0, 10, 10, 200, 20, 0,100)     ; PB_NSTextField  -->  NSTextField  -->  NSControl  -->  NSView  -->  NSResponder  -->  NSObject
  
  Debug ObjectInheritance(GadgetID(0))
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP