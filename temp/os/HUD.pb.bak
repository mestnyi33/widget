EnableExplicit

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

ImportC ""
  class_addMethod(Class.I, Selector.I, *Callback, Types.P-ASCII)
  sel_registerName(MethodName.P-ASCII)
EndImport

Define w1=OpenWindow(#PB_Any, 80, 280, 100, 300, "")
HideWindow(w1,#True)
;Window_0 = OpenWindow(#PB_Any, 100, 300, 150, 300, "Utility");,WindowID(w1))
;NSPanel = WindowID(w1)

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

Procedure Panel(x,y,width,height,title.s,mask,center=#True)
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
  PostEvent(#PB_Event_CloseWindow)
EndProcedure

ProcedureC PanelShouldCloseCallback(Object.I, Selector.I, Sender.I)
  PostEvent(#PB_Event_CloseWindow)
EndProcedure

Define NSPanel = Panel(100,300,500,300,"HUD Window", #NSUtilityWindowMask|
                                              #NSTitledWindowMask|
                                              #NSClosableWindowMask|
                                              #NSMiniaturizableWindowMask|
                                              ;#NSTexturedBackgroundWindowMask|
                                              ;#NSNonactivatingPanelMask|
                                              #NSResizableWindowMask|
                                              #NSHUDWindowMask)
                                         

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

ButtonGadget(0,340,5,150,25,"Exit")
;Filter  = CocoaMessage(0, 0, "CIFilter filterWithName:$", @"CIColorMonochrome") ; create a CIColorMonochrome filter
;CocoaMessage(0, Filter, "setDefaults")                                          ; set the default values for the filter
;Color = CocoaMessage(0, 0, "CIColor colorWithString:$", @"0.1 0.1 0.1 1.0")     ; create a CIColor object from a RGBA string
;CocoaMessage(0, Filter, "setValue:", Color, "forKey:$", @"inputColor")          ; assign the color to the filter
;FilterArray = CocoaMessage(0, 0, "NSArray arrayWithObject:", Filter)            ; create an array with only the filter
 
;Button = GadgetID(0)
;CocoaMessage(0, Button, "setWantsLayer:", #YES)                                 ; the gadget needs a layer for the filter to work
;CocoaMessage(0, Button, "setContentFilters:", FilterArray)                      ; set the filter Array

;// Field 1
TextGadget(2,10,250,250,20,"Field 1:"): SetGadgetColor(2, #PB_Gadget_FrontColor, $FFFFFF)
StringGadget(3,65,252,100,20,""): SetGadgetColor(3, #PB_Gadget_FrontColor, $FFFFFF): SetGadgetColor(3, #PB_Gadget_BackColor, $555555)

;// Field 2
TextGadget(4,10,220,250,20,"Field 2:"): SetGadgetColor(4, #PB_Gadget_FrontColor, $FFFFFF)
StringGadget(5,65,222,100,20,""): SetGadgetColor(5, #PB_Gadget_FrontColor, $FFFFFF): SetGadgetColor(5, #PB_Gadget_BackColor, $555555)

;// Option Gadgets
OptionGadget(6,10,190,100,20,"Option 1"): SetGadgetColor(6, #PB_Gadget_FrontColor, $FFFFFF): SetGadgetColor(6, #PB_Gadget_BackColor, $555555)
OptionGadget(7,120,190,100,20,"Option 2"): SetGadgetColor(7, #PB_Gadget_FrontColor, $FFFFFF): SetGadgetColor(7, #PB_Gadget_BackColor, $555555)

;// Circular Slider
TrackBarGadget(8,250,240,36,36,0,12)
Define Cell = CocoaMessage(0, GadgetID(8), "cell"): SetGadgetColor(8, #PB_Gadget_FrontColor, $FFFFFF): SetGadgetColor(8, #PB_Gadget_BackColor, $555555)
CocoaMessage(8, Cell, "setSliderType:", 1); circular slider
CocoaMessage(8, Cell, "setNumberOfTickMarks:", 12)
CocoaMessage(8, Cell, "setAllowsTickMarkValuesOnly:", #YES)

;// ListViewGadget
ListViewGadget(9,10,60,200,120): SetGadgetColor(9, #PB_Gadget_FrontColor, $FFFFFF): SetGadgetColor(9, #PB_Gadget_BackColor, $555555)
Define a
For a=1 To 12
  AddGadgetItem(9,-1,"Item " + Str(a) +" of the ListView")
Next
SetGadgetState(9,4)

;// Horizontal Scrollbar
ScrollBarGadget(10,230,42,150,20,0,100,30)
SetGadgetState(10,50)

;// Vertical Scrollbar
ScrollBarGadget(11,380,42,20,150,0,100,30)
SetGadgetState(11,100)

BindGadgetEvent(0,@OnBtnClick())

class_addMethod_(CocoaMessage(0, NSPanel, "class"), sel_registerName_("windowShouldClose:"), @PanelShouldCloseCallback(), "v@:@")

Define AppDelegate = App() : CocoaMessage(0, WindowID(w1), "setDelegate:", AppDelegate)

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP