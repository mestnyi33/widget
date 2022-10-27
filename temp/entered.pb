Import ""
  PB_Window_GetID(hWnd) 
EndImport

        
;         Protected Point.NSPoint
;         ; class func windowNumber(at point: NSPoint, belowWindowWithWindowNumber windowNumber: Int) -> Int
;         ; CocoaMessage(0, 0, "NSWindow windowNumberAtPoint:@", @Point, "belowWindowWithWindowNumber:", 0)
;         
;         ; func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?
;         ; CocoaMessage(0, contentView, "hitTest:@", @Point)
;         
;         ; CocoaMessage(@Point, NSEvent, "locationInWindow")
;         CocoaMessage(@Point, NSWindow, "mouseLocationOutsideOfEventStream")
;         
;         ; @property(strong) __kindof NSView *contentView;
;         CocoaMessage(0, NSWindow, "contentView")
        
;         ProcedureReturn CocoaMessage(0, contentView, "hitTest:@", @Point)

      Procedure.s GetClassName( handle.i )
        Protected Result
        CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
        If Result
          ProcedureReturn PeekS( Result, -1, #PB_UTF8 )
        EndIf
      EndProcedure
      
Procedure IDWindow(Handle)
  ProcedureReturn PB_Window_GetID(Handle)
EndProcedure

Procedure IDGadget(Handle)
  ProcedureReturn CocoaMessage(0, Handle, "tag")
EndProcedure

Procedure WindowNumberUnderMouse()
  Protected Point.CGPoint
  CocoaMessage(@Point, 0, "NSEvent mouseLocation")
  ProcedureReturn CocoaMessage(0, 0, "NSWindow windowNumberAtPoint:@", @Point, "belowWindowWithWindowNumber:", 0)
  ; class func windowNumber(at point: NSPoint, belowWindowWithWindowNumber windowNumber: Int) -> Int
EndProcedure

Procedure WindowNumber( WindowID )
  ProcedureReturn CocoaMessage(0, WindowID, "windowNumber")
EndProcedure

Procedure NSWindow( NSApp, WindowNumber )
  ProcedureReturn CocoaMessage(0, NSApp, "windowWithWindowNumber:", WindowNumber)
EndProcedure

Procedure GetWindowUnderMouse()
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Protected.i NSApp, NSWindow, WindowNumber, Point.CGPoint
    
    WindowNumber = WindowNumberUnderMouse( )
    NSApp = CocoaMessage(0, 0, "NSApplication sharedApplication")
    NSWindow = CocoaMessage(0, NSApp, "windowWithWindowNumber:", WindowNumber)
    
    ProcedureReturn NSWindow
  CompilerEndIf
  
EndProcedure

Procedure GetObjectUnderMouse( NSWindow )
  
  Protected.i ContentView, NSApp, WindowNumber, Point.CGPoint
  
  If NSWindow
    CocoaMessage(@Point, NSWindow, "mouseLocationOutsideOfEventStream")
    ContentView = CocoaMessage(0, NSWindow, "contentView")
    ProcedureReturn CocoaMessage(0, ContentView, "hitTest:@", @Point)
  Else
    ProcedureReturn 0
  EndIf
  
EndProcedure

Procedure enterID()
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Protected.i NSWindow = GetWindowUnderMouse( )
    Protected NsGadget = GetObjectUnderMouse( NSWindow )
    
    If NsGadget <> CV And NsGadget
      If CV = CocoaMessage(0, NsGadget, "superview")
        ProcedureReturn IDGadget(NsGadget)
      Else
        ProcedureReturn IDGadget(CocoaMessage(0, NsGadget, "superview"))
      EndIf
    Else
      ProcedureReturn IDWindow(NSWindow)
    EndIf
    
  CompilerEndIf
EndProcedure

Procedure GetObject()
 
  Protected i,CV, w, id, pt.NSPoint
  
  Protected app =  CocoaMessage(0, 0, "NSApplication sharedApplication")
  Protected windows = CocoaMessage(0, app, "windows")
  Protected count = CocoaMessage(0, windows, "count") -1
  
  For i=count To 0 Step -1
    NSWindow = CocoaMessage(0, windows, "objectAtIndex:", i)
    
    If GetObjectUnderMouse( NSWindow )
      Break
    EndIf
  Next
  
  ProcedureReturn NSWindow
EndProcedure


OpenWindow(1,100,100,120,120,"Window1",#PB_Window_SystemMenu)
ButtonGadget(1,10,10,100,100,"Button1")
OpenWindow(2,200,200,120,120,"Window2",#PB_Window_SystemMenu)
ButtonGadget(2,10,10,100,100,"Button2")
OpenWindow(3,300,300,120,120,"Window3",#PB_Window_SystemMenu)
ButtonGadget(3,10,10,100,100,"Button3")

Repeat
  event = WaitWindowEvent()
 
;   If event = #PB_Event_Repaint
    Select GetObjectUnderMouse( GetWindowUnderMouse())
      Case GadgetID(1):
        Debug "Button1 " +GetObject()
      Case GadgetID(2):
        Debug "Button2 " +GetObject()
      Case GadgetID(3):
        Debug "Button3 " +GetObject()
    EndSelect        
;   Else
;    ; Debug event
;   EndIf
 
Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ----
; EnableXP