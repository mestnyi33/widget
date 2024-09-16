CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
   Procedure.s ClassName( handle.i )
      Protected Result
      CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
      If Result
         ProcedureReturn PeekS( Result, -1, #PB_UTF8 )
      EndIf
   EndProcedure
   
   Procedure Gadget( WindowID )
      Protected.i handle, superview, ContentView, Point.CGPoint
      
      If  WindowID 
         ContentView = CocoaMessage(0,  WindowID , "contentView")
         CocoaMessage(@Point,  WindowID , "mouseLocationOutsideOfEventStream")
         
         ; func hitTest(_ point: NSPoint) -> NSView? ; Point.NSPoint ; hitTest(_:) 
         handle = CocoaMessage(0, ContentView, "hitTest:@", @Point)
         
         If handle
            Select ClassName(handle)
               Case "PBFlippedWindowView"
                  handle = 0
               Case "NSStepper" 
                  handle = CocoaMessage( 0, handle, "superview" )     ; PB_SpinView
                  handle = CocoaMessage(0, handle, "subviews")
                  handle = CocoaMessage(0, handle, "objectAtIndex:", 0)
                  
               Case "NSTableHeaderView" 
                  handle = CocoaMessage(0, handle, "tableView") ; PB_NSTableView
                  
               Case "NSScroller"                                 ;
                                                                 ; PBScrollView
                  handle = CocoaMessage(0, handle, "superview")  ; NSScrollView
                                                                 ;
                  Select ClassName(handle) 
                     Case "WebDynamicScrollBarsView"
                        handle = CocoaMessage(0, handle, "superview") ; WebFrameView
                        handle = CocoaMessage(0, handle, "superview") ; PB_WebView
                        
                     Case "PBTreeScrollView"
                        handle = CocoaMessage(0, handle, "documentView")
                        
                     Case "NSScrollView"
                        superview = CocoaMessage(0, handle, "superview")
                        If ClassName(superview) = "PBScintillaView"
                           handle = superview ; PBScintillaView
                        Else
                           handle = CocoaMessage(0, handle, "documentView")
                        EndIf
                        
                  EndSelect
                  
               Case "_NSRulerContentView", "SCIContentView" 
                  handle = CocoaMessage(0, handle, "superview") ; NSClipView
                  handle = CocoaMessage(0, handle, "superview") ; NSScrollView
                  handle = CocoaMessage(0, handle, "superview") ; PBScintillaView
                  
               Case "NSView" 
                  handle = CocoaMessage(0, handle, "superview") ; PB_NSBox
                  
               Case "NSTextField", "NSButton"
                  handle = CocoaMessage(0, handle, "superview") ; PB_DateView
                  
               Case "WebHTMLView" 
                  handle = CocoaMessage(0, handle, "superview") ; WebClipView
                  handle = CocoaMessage(0, handle, "superview") ; WebDynamicScrollBarsView
                  handle = CocoaMessage(0, handle, "superview") ; WebFrameView
                  handle = CocoaMessage(0, handle, "superview") ; PB_WebView
                  
               Case "PB_NSFlippedView"                           ;
                                                                 ; container
                  handle = CocoaMessage(0, handle, "superview")  ; NSClipView
                                                                 ; scrollarea
                  If ClassName(handle) = "NSClipView"            ;
                     handle = CocoaMessage(0, handle, "superview") ; PBScrollView
                  EndIf
                  ;           Default
                  ;             Debug "-"  
                  ;             Debug  Get::ClassName(handle) ; PB_NSTextField
                  ;             Debug "-"
            EndSelect
         EndIf
      EndIf
      
      ;Debug ClassName(handle)
      If handle
         Protected Gadget = CocoaMessage(0, handle, "tag")
         If IsGadget( Gadget ) And GadgetID( Gadget ) = handle
            ProcedureReturn Gadget
         EndIf
         ProcedureReturn - 1
      Else
         ProcedureReturn - 1
      EndIf
      ProcedureReturn handle
   EndProcedure
CompilerEndIf

Procedure Open( id, flag=0 )
   Static x,y
   OpenWindow( id, x,y,200,200,"window_"+Str(id), #PB_Window_SystemMenu|flag)
   CanvasGadget( id, 40,40,200-80,55, #PB_Canvas_Keyboard | #PB_Canvas_Container) : CloseGadgetList()
   CanvasGadget( 10+id, 40,110,200-80,55, #PB_Canvas_Keyboard)
   x + 100
   y + 100
EndProcedure


Open(1, #PB_Window_NoActivate)
Open(2, #PB_Window_NoActivate)
;Open(3, #PB_Window_NoActivate)

Define gadget, down
Repeat
   event = WaitWindowEvent(1)
   
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      If down
         If Not CocoaMessage(0, 0, "NSEvent pressedMouseButtons")
            If IsGadget(down)
               PostEvent(#PB_Event_Gadget,  EventWindow(), down, #PB_EventType_LeftButtonUp )
               gadget = gadget(WindowID(EventWindow()))
               If IsGadget(gadget)
                  PostEvent(#PB_Event_Gadget,  EventWindow(), gadget, #PB_EventType_LeftClick )
               EndIf
            EndIf
            down = 0
         EndIf
      EndIf
   CompilerEndIf

   Select event
      Case #PB_Event_ActivateWindow
         Debug "active - "+ EventWindow() 
         
         CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            gadget = gadget(WindowID(EventWindow()))
            If IsGadget(gadget)
               SetActiveGadget(gadget)
               PostEvent(#PB_Event_Gadget,  EventWindow(), gadget, #PB_EventType_LeftButtonDown )
               down = gadget
            EndIf
         CompilerEndIf

      Case #PB_Event_DeactivateWindow
         Debug "deactive - "+ EventWindow()
         
      Case #PB_Event_Gadget
         Select EventType()
            Case #PB_EventType_Focus
               Debug "focus - "+EventGadget()
               
            Case #PB_EventType_LostFocus
               Debug "lostfocus - "+EventGadget()
               
            Case #PB_EventType_LeftButtonDown
               Debug "down - "+EventGadget()
               
            Case #PB_EventType_LeftButtonUp
               Debug "up - "+EventGadget()
               
            Case #PB_EventType_LeftClick
               Debug "click - "+EventGadget()
               
         EndSelect
         
   EndSelect
   
Until event = #PB_Event_CloseWindow

; result
; ; windows
; active - 1
; focus - 1
; deactive - 1
; active - 3
; lostfocus - 1
; focus - 3
; deactive - 3
; lostfocus - 3
; focus - 1
; active - 1
; deactive - 1
; lostfocus - 1
;
; ; linux
; active - 1
; focus - 1
; deactive - 1
; lostfocus - 1
; active - 3
; focus - 3
; deactive - 3
; lostfocus - 3
; active - 1
; focus - 1
; deactive - 1
; lostfocus - 1
;
; ; macos
; active - 3
; deactive - 3
; active - 1
; focus - 1
; deactive - 1
; active - 3
; focus - 3
; deactive - 3
; active - 1
; deactive - 1
; IDE Options = PureBasic 6.04 LTS (Windows - x64)
; CursorPosition = 111
; FirstLine = 8
; Folding = 4---
; EnableXP