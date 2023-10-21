DeclareModule Window
   Declare Open( window, x, y, width, height, title.s, flags.q = 0, parentID = 0 )
   Declare Close( WindowID.i )
   Declare WaitClose( )
EndDeclareModule

Module Window
   
   EnableExplicit
   
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Global.i app, win, appDelegate, appDelegateClass
      Global.NSSize size
      Global.NSRect rect
      Global.i myAppDelegateClass, myAppDelegate
      Global.i myWindowDelegateClass, myWindowDelegate
      Global.i pool
      
      ; TOP
      ; MacOS: Get menubar height
      
      ; #NSApplicationActivateAllWindows = 1 << 0
      ; #NSApplicationActivateIgnoringOtherApps = 1 << 1
      ; 
      ; currentApplication = CocoaMessage(0, 0, "NSRunningApplication currentApplication")
      ; CocoaMessage(0, currentApplication, "activateWithOptions:", #NSApplicationActivateAllWindows | #NSApplicationActivateIgnoringOtherApps)
      
      
      Procedure GetMenuBarHeight()
         Protected NSApp, NSMenu, Value.d
         
         NSApp = CocoaMessage(0, 0, "NSApplication sharedApplication")
         NSMenu = CocoaMessage(0, NSApp, "mainMenu")
         CocoaMessage(@Value, NSMenu, "menuBarHeight")
         ProcedureReturn Value
      EndProcedure
      
      
      ProcedureC winShouldClose(obj.i, sel.i, win.i) ; call 1
                                                     ;Protected.i app
         
         Debug "winShouldClose - " + obj +" "+sel +" - "+win
         
         ; CocoaMessage(0, win, "release")
         CocoaMessage(0, app, "stop:", win)
         ;CocoaMessage(@app, 0, "NSApplication sharedApplication")
         ;CocoaMessage(0, app, "terminate:", app)
         ;CocoaMessage(0, win, "close")
         ProcedureReturn #YES
      EndProcedure
      
      ProcedureC appShouldTerminateALWC(obj.i, sel.i, app.i) ; call 2
         Debug "appShouldTerminateALWC - " + obj +" - "+sel +" - "+app
         
         ProcedureReturn #YES
      EndProcedure
      
      ProcedureC appShouldTerminate(obj.i, sel.i, app.i) ; call 3
         Debug "appShouldTerminate - " + obj +" - "+sel +" - "+app
         
         ProcedureReturn #YES
      EndProcedure
      
      ProcedureC appWillTerminate(obj.i, sel.i, ntn.i) ; call 4
         Debug "appWillTerminate - " + obj +" - "+sel +" - "+ntn
         
         CocoaMessage(0, app, "stop:", win)
         End
         ProcedureReturn #YES
      EndProcedure
      
      
      CocoaMessage(@pool, 0, "NSAutoreleasePool alloc")
      CocoaMessage(0, pool, "init")
      
      CocoaMessage(@app, 0, "NSApplication sharedApplication")
      
      
      
      ;CocoaMessage(0, pool, "drain")
      
      ; CocoaMessage(0, app, "runModalForWindow:",win)
      ; CocoaMessage(0, app, "terminate:", app)
   CompilerEndIf
   
   Procedure Open( window, x, y, width, height, title.s, flags.q = 0, parentID = 0 )
      Protected.i win, myWindowDelegateClass, myWindowDelegate
      
      CocoaMessage(@win, 0, "NSWindow alloc")
      myWindowDelegateClass = objc_allocateClassPair_(objc_getClass_("NSObject"), "myWindowDelegate", 0)
      class_addProtocol_(myWindowDelegateClass, objc_getProtocol_("NSWindowDelegate"))
      class_addMethod_(myWindowDelegateClass, sel_registerName_("windowShouldClose:"), @winShouldClose(), "c@:@")
      ;class_addMethod_(myWindowDelegateClass, sel_registerName_("applicationShouldTerminate:"), @appShouldTerminate(), "c@:@")
      myWindowDelegate = class_createInstance_(myWindowDelegateClass, 0)
      
      ;\\
      Protected.NSRect rect
      
      ;\\
      Protected frame.NSRect
      Protected visibleFrame.NSRect
      Protected mainScreen = CocoaMessage(0,0,"NSScreen mainScreen")
      CocoaMessage(@visibleFrame.NSRect, mainScreen,"visibleFrame")
      CocoaMessage(@frame.NSRect, mainScreen,"frame")
      
      ;\\
      rect\origin\x = x
      rect\origin\y = (Frame\size\height - visibleFrame\origin\y)-height-y
      rect\size\width = width
      rect\size\height = height
      
      Protected MASK  
      If flags & #PB_Window_Tool = #PB_Window_Tool
         MASK | #NSTitledWindowMask ; 1<<0 ; 1
         ; MASK | 1<<8
         MASK | 1<<9
      EndIf
      
      If flags & #PB_Window_NoActivate = #PB_Window_NoActivate
         ;MASK | 1 << 7
      EndIf
      
;       ;\\ minimize
;       MASK | 1<<0
;           MASK | 1<<1
;           MASK | 1<<2
      
      If flags & #PB_Window_BorderLess = #PB_Window_BorderLess
         ; MASK | #NSClosableWindowMask  | #NSTitledWindowMask 
           MASK | #NSTitledWindowMask ; 1<<0
         ; MASK | #NSClosableWindowMask ; 1<<1
          ;MASK | #NSMiniaturizableWindowMask ; 1<<2
          MASK | 1<<3
          ;MASK | 1<<4
          ;MASK | 1<<5
          ;MASK | 1<<6
          ;MASK | 1<<7
          ;MASK | 1<<8
          ;MASK | 1<<9
          ;MASK | 1<<10
      Else
         If flags & #PB_Window_TitleBar = #PB_Window_TitleBar Or flags & #PB_Window_SystemMenu = #PB_Window_SystemMenu
            MASK | #NSTitledWindowMask
         EndIf
         
         If flags & #PB_Window_MinimizeGadget = #PB_Window_MinimizeGadget Or flags & #PB_Window_SystemMenu = #PB_Window_SystemMenu
            MASK | #NSMiniaturizableWindowMask ; 1<<2 ; 4
            If MASK & #NSTitledWindowMask = 0
               MASK | #NSTitledWindowMask
            EndIf
         EndIf
         
         If flags & #PB_Window_MaximizeGadget = #PB_Window_MaximizeGadget Or flags & #PB_Window_SystemMenu = #PB_Window_SystemMenu
            MASK | 1<<3 ; 8
            If MASK & #NSTitledWindowMask = 0
               MASK | #NSTitledWindowMask
            EndIf
         EndIf
         
         If flags & #PB_Window_SizeGadget = #PB_Window_SizeGadget Or flags & #PB_Window_SystemMenu = #PB_Window_SystemMenu
            MASK | #NSResizableWindowMask
         EndIf
         
         If flags & #PB_Window_SystemMenu = #PB_Window_SystemMenu
           MASK |  #NSClosableWindowMask ; 1<<1 ; 2
         EndIf
      EndIf
      
      CocoaMessage(0, win, "initWithContentRect:@", @rect, "styleMask:", MASK, "backing:", 2, "defer:", #NO)
      CocoaMessage(0, win, "makeKeyWindow")
      CocoaMessage(0, win, "makeKeyAndOrderFront:", app)
      ;CocoaMessage(0, win, "orderFront:", app)
      CocoaMessage(0, win, "setTitle:$", @title)
      
      ;\\
;       Protected.NSSize minSize
;       minSize\width = 150
;       minSize\height = 100
;       CocoaMessage(0, win, "setMinSize:@", @minSize)
      
      If flags & #PB_Window_ScreenCentered = #PB_Window_ScreenCentered
         CocoaMessage(0, win, "center")
      EndIf
      
      CocoaMessage(0, win, "update")
      CocoaMessage(0, win, "display")
      
      CocoaMessage(0, win, "setPreventsApplicationTerminationWhenModal:", #NO)
      CocoaMessage(0, win, "setReleasedWhenClosed:", #YES)
      
      CocoaMessage(0, win, "setDelegate:", myWindowDelegate)
      ProcedureReturn win
   EndProcedure
   
   Procedure Close( WindowID.i )
      CocoaMessage(0, WindowID, "release")
      CocoaMessage(0, WindowID, "close")
   EndProcedure
   
   Procedure WaitClose( )
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
         CocoaMessage(0, app, "run")
         
      CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
         ; https://www.purebasic.fr/english/viewtopic.php?p=570200&hilit=move+items#p570200
         g_signal_connect_(*this\root\canvas\window, "delete-event", @WindowCloseHandler( ), 0)
         g_signal_connect_(*this\root\canvas\window, "destroy", @WindowCloseHandler( ), 0)
         gtk_main_( )
         
      CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
         Protected msg.MSG
         ;         If PeekMessage_(@msg,0,0,0,1)
         ;           TranslateMessage_(@msg)
         ;           DispatchMessage_(@msg)
         ;         Else
         ;           Sleep_(1)
         ;         EndIf
         
         While GetMessage_(@msg, #Null, 0, 0 )
            TranslateMessage_(msg) ; - генерирует дополнительное сообщение если произошёл ввод с клавиатуры (клавиша с символом была нажата или отпущена)
            DispatchMessage_(msg)  ; посылает сообщение в функцию WindowProc.
            
            Debug "" + #PB_Compiler_Procedure + " " + msg\message + " " + msg\hwnd + " " + msg\lParam + " " + msg\wParam
            ;   If msg\wParam = #WM_QUIT
            ;     Debug "#WM_QUIT "
            ;   EndIf
         Wend
      CompilerEndIf
   EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile
   UseModule Window
   Global win1, win2, win3
   
   win1 = Open( 1, 0,0,400,100, "window1", #PB_Window_SystemMenu )
   
   win2 = Open( 2, 100,100,400,100, "window2", #PB_Window_ScreenCentered|#PB_Window_BorderLess )
   
   win3 = Open( 3, 100,100,400,100, "window3", #PB_Window_WindowCentered, win2 )
   
   WaitClose( )
   Debug "END"
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 153
; FirstLine = 135
; Folding = -----
; EnableXP