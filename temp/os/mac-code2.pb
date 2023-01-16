Enumeration CGWindowLevelKey
   #kCGBaseWindowLevelKey = 0
   #kCGMinimumWindowLevelKey
   #kCGDesktopWindowLevelKey
   #kCGBackstopMenuLevelKey
   #kCGNormalWindowLevelKey
   #kCGFloatingWindowLevelKey
   #kCGTornOffMenuWindowLevelKey
   #kCGDockWindowLevelKey
   #kCGMainMenuWindowLevelKey
   #kCGStatusWindowLevelKey
   #kCGModalPanelWindowLevelKey
   #kCGPopUpMenuWindowLevelKey
   #kCGDraggingWindowLevelKey
   #kCGScreenSaverWindowLevelKey
   #kCGMaximumWindowLevelKey
   #kCGOverlayWindowLevelKey
   #kCGHelpWindowLevelKey
   #kCGUtilityWindowLevelKey
   #kCGDesktopIconWindowLevelKey
   #kCGCursorWindowLevelKey
   #kCGAssistiveTechHighWindowLevelKey
   #kCGNumberOfWindowLevelKeys
EndEnumeration

#NSFloatingWindowLevel          = #kCGFloatingWindowLevelKey


#NSBorderlessWindowMask         = 0
#NSTitledWindowMask             = 1 << 0
#NSClosableWindowMask           = 1 << 1
#NSMiniaturizableWindowMask     = 1 << 2
#NSResizableWindowMask          = 1 << 3
#NSUtilityWindowMask            = 1 << 4
#NSDocModalWindowMask           = 1 << 6
#NSNonactivatingPanelMask       = 1 << 7
#NSTexturedBackgroundWindowMask = 1 << 8
#NSHUDWindowMask                = 1 << 13

w1=OpenWindow(#PB_Any, 80, 280, 100, 300, "v")
;Window_0 = OpenWindow(#PB_Any, 100, 300, 150, 300, "Utility");,WindowID(w1))
;NSPanel = WindowID(Window_0)

Procedure App()
    Protected app
    CocoaMessage(@app,0,"NSApplication sharedApplication")
    ProcedureReturn app
EndProcedure

Procedure InitRect(*rect.NSRect,x,y,width,height)
    If *rect
        *rect\origin\x = x
        *rect\origin\y = y
        *rect\size\width = width
        *rect\size\height = height
    EndIf
EndProcedure


Procedure Panel(x,y,width,height,title.s,mask,center=0)
    Protected size.NSSize, rect.NSRect, win, view
    CocoaMessage(@win,0,"NSPanel alloc")
    If win
        InitRect(@rect,x,y,width,height)
        CocoaMessage(0,win,"initWithContentRect:@",@rect,"styleMask:",mask,"backing:",2,"defer:",#NO)
        ;CocoaMessage(0,win,"makeKeyWindow")
        CocoaMessage(0,Win,"makeKeyAndOrderFront:",App())
        CocoaMessage(0,win,"setTitle:$",@title)
        ;InitSize(@size,width,height)
        ;CocoaMessage(0,win,"setMinSize:",size)
        
        CocoaMessage(0,win,"setPreventsApplicationTerminationWhenModal:",#NO)
        CocoaMessage(0,win,"setReleasedWhenClosed:",#YES)
        
        CocoaMessage(@view,0,"NSView alloc")
        If view
            InitRect(@rect,0,0,width,height)
            CocoaMessage(@view,view,"initWithFrame:@",@rect)
            CocoaMessage(0,win,"setContentView:",view)
        EndIf
        
        If center
            CocoaMessage(0,win,"center")
        EndIf
        CocoaMessage(0,win,"update")
        CocoaMessage(0,win,"display")
    EndIf
    ProcedureReturn win
EndProcedure


Procedure OnBtnClick()
    End
EndProcedure

NSPanel = Panel(100,300,200,300,"Utility",#NSUtilityWindowMask|
                                          #NSTitledWindowMask|
                                          #NSClosableWindowMask|
                                          #NSMiniaturizableWindowMask|
                                          ;#NSTexturedBackgroundWindowMask|
                                          ;#NSNonactivatingPanelMask|
                                          #NSResizableWindowMask)

;CocoaMessage(0, NSPanel, "setStyleMask:", #NSUtilityWindowMask|
;                                          #NSTitledWindowMask|
;                                          #NSClosableWindowMask|
;                                          #NSMiniaturizableWindowMask|
;                                          ;#NSTexturedBackgroundWindowMask|
;                                          #NSResizableWindowMask) 

;CocoaMessage(0, NSPanel, "setFloatingPanel:",#YES)
;CocoaMessage(0, NSPanel, "setShowsResizeIndicator:",#YES)
CocoaMessage(0, NSPanel, "setMovableByWindowBackground:",#YES)
CocoaMessage(0, NSPanel, "setLevel:",#NSFloatingWindowLevel) ; stay on top

UseGadgetList( NSPanel )
ButtonGadget(1,10,10,150,25,"eXit")

BindGadgetEvent(1,@OnBtnClick())

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP