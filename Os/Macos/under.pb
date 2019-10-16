Procedure.s GetClass(handle.i)
  Protected Result
  
  If handle
    Result = CocoaMessage(0, handle, "className")
    CocoaMessage(@Result, Result, "UTF8String")
  EndIf
  
  If Result
    ProcedureReturn PeekS(Result, -1, #PB_UTF8)
  EndIf
EndProcedure

Procedure WindowNumberUnderMouse()
  Protected Point.CGPoint
  CocoaMessage(@Point, 0, "NSEvent mouseLocation")
  ProcedureReturn CocoaMessage(0, 0, "NSWindow windowNumberAtPoint:@", @Point, "belowWindowWithWindowNumber:", 0)
EndProcedure

Procedure WindowNumber(PBWindow)
  ProcedureReturn CocoaMessage(0, WindowID(PBWindow), "windowNumber")
EndProcedure

Procedure enterID()
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Protected.i NSApp, NSWindow, WindowNumber, Point.CGPoint
    
    CocoaMessage(@Point, 0, "NSEvent mouseLocation")
    WindowNumber = CocoaMessage(0, 0, "NSWindow windowNumberAtPoint:@", @Point, "belowWindowWithWindowNumber:", 0)
    NSApp = CocoaMessage(0, 0, "NSApplication sharedApplication")
    NSWindow = CocoaMessage(0, NSApp, "windowWithWindowNumber:", WindowNumber)
    
    Protected pt.NSPoint
    
    If NSWindow
      Protected CV = CocoaMessage(0, NSWindow, "contentView")
      CocoaMessage(@pt, NSWindow, "mouseLocationOutsideOfEventStream")
      Protected NsGadget = CocoaMessage(0, CV, "hitTest:@", @pt)
    EndIf
    ;       Debug GetClass(NSWindow)
    ;       Debug WindowNumber;GetClass(WindowNumber)
    ;       Debug GetClass(CV)
    
    If NsGadget <> CV And NsGadget
      If CV = CocoaMessage(0, NsGadget, "superview")
        ;Debug CocoaMessage(0, NsGadget, "superview")
        ProcedureReturn NsGadget
      Else
        ProcedureReturn CocoaMessage(0, NsGadget, "superview")
      EndIf
    Else
      ProcedureReturn NSWindow
    EndIf
    
  CompilerEndIf
EndProcedure


OpenWindow(0,100,100,300,300,"",#PB_Window_SystemMenu)
OpenWindow(1,200,200,300,300,"",#PB_Window_SystemMenu)
OpenWindow(2,300,300,995, 455,"",#PB_Window_SystemMenu)

UsePNGImageDecoder()

If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
  End
EndIf

If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
  End
EndIf

ButtonGadget(#PB_GadgetType_Button, 5, 5, 160,70, "ButtonGadget_"+Str(#PB_GadgetType_Button) ) ; ok
  StringGadget(#PB_GadgetType_String, 5, 80, 160,70, "StringGadget_"+Str(#PB_GadgetType_String)) ; ok
  TextGadget(#PB_GadgetType_Text, 5, 155, 160,70, "TextGadget_"+Str(#PB_GadgetType_Text))        ; ok
  CheckBoxGadget(#PB_GadgetType_CheckBox, 5, 230, 160,70, "CheckBoxGadget_"+Str(#PB_GadgetType_CheckBox) ) ; ok
  OptionGadget(#PB_GadgetType_Option, 5, 305, 160,70, "OptionGadget_"+Str(#PB_GadgetType_Option) )         ; ok
  ListViewGadget(#PB_GadgetType_ListView, 5, 380, 160,70 ):AddGadgetItem(#PB_GadgetType_ListView, -1, "ListViewGadget_"+Str(#PB_GadgetType_ListView))                                                 ; ok
  
  FrameGadget(#PB_GadgetType_Frame, 170, 5, 160,70, "FrameGadget_"+Str(#PB_GadgetType_Frame) )
  ComboBoxGadget(#PB_GadgetType_ComboBox, 170, 80, 160,70 ):AddGadgetItem(#PB_GadgetType_ComboBox, -1, "ListViewGadget_"+Str(#PB_GadgetType_ComboBox)) 
  ImageGadget(#PB_GadgetType_Image, 170, 155, 160,70,0,#PB_Image_Border ) ; ok
  HyperLinkGadget(#PB_GadgetType_HyperLink, 170, 230, 160,70,"HyperLinkGadget_"+Str(10),0,#PB_HyperLink_Underline ) ; ok
  ContainerGadget(#PB_GadgetType_Container, 170, 305, 160,70,#PB_Container_Flat ) :ButtonGadget(101, 0, 0, 150,20, "ContainerGadget_"+Str(#PB_GadgetType_Container) ):CloseGadgetList()
  ListIconGadget(#PB_GadgetType_ListIcon, 170, 380, 160,70,"ListIconGadget_"+Str(#PB_GadgetType_ListIcon),120 )                           ; ok
  
  IPAddressGadget(#PB_GadgetType_IPAddress, 335, 5, 160,70 ) : SetGadgetState(#PB_GadgetType_IPAddress, MakeIPAddress(1, 2, 3, 4))    ; ok
  ProgressBarGadget(#PB_GadgetType_ProgressBar, 335, 80, 160,70,0,0 )
  ScrollBarGadget(#PB_GadgetType_ScrollBar, 335, 155, 160,70,0,100,10 )
  ScrollAreaGadget(#PB_GadgetType_ScrollArea, 335, 230, 160,70,180,90,1,#PB_ScrollArea_Flat ):ButtonGadget(201, 0, 0, 150,20, "ScrollAreaGadget_"+Str(#PB_GadgetType_ScrollArea) ):CloseGadgetList()
  TrackBarGadget(#PB_GadgetType_TrackBar, 335, 305, 160,70,0,0 )
  WebGadget(#PB_GadgetType_Web, 335, 380, 160,70,"" )
  
  ButtonImageGadget(#PB_GadgetType_ButtonImage, 500, 5, 160,70,0 )
  CalendarGadget(#PB_GadgetType_Calendar, 500, 80, 160,70 )
  DateGadget(#PB_GadgetType_Date, 500, 155, 160,70 )
  EditorGadget(#PB_GadgetType_Editor, 500, 230, 160,70 ):AddGadgetItem(#PB_GadgetType_Editor, -1, "EditorGadget_"+Str(#PB_GadgetType_Editor))  
  ExplorerListGadget(#PB_GadgetType_ExplorerList, 500, 305, 160,70,"" )
  ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 380, 160,70,"" )
  
  ExplorerComboGadget(#PB_GadgetType_ExplorerCombo, 665, 5, 160,70,"" )
  SpinGadget(#PB_GadgetType_Spin, 665, 80, 160,70,0,10)
  TreeGadget(#PB_GadgetType_Tree, 665, 155, 160,70 )
  PanelGadget(#PB_GadgetType_Panel, 665, 230, 160,70 ) :AddGadgetItem(#PB_GadgetType_Panel, -1, "PanelGadget_"+Str(#PB_GadgetType_Panel)) 
  ButtonGadget(255, 0, 0, 90,20, "ButtonGadget" )
  CloseGadgetList()
  
  ButtonGadget(291, 0, 0, 0,20, "ButtonGadget" )
  StringGadget(292, 0, 0, 0,20, "StringGadget")
  SplitterGadget(#PB_GadgetType_Splitter, 665, 305, 160,70,292,291 ) 
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    MDIGadget(#PB_GadgetType_MDI, 665, 380, 160,70,1, 2);, #PB_MDI_AutoSize)
  CompilerEndIf
  InitScintilla()
  ScintillaGadget(#PB_GadgetType_Scintilla, 830, 5, 160,70,0 )
  ShortcutGadget(#PB_GadgetType_Shortcut, 830, 80, 160,70 ,-1)
  CanvasGadget(#PB_GadgetType_Canvas, 830, 155, 160,70 )
  
  Define  i : For i = 1 To #PB_GadgetType_Canvas
    ;   Disable_Os_Event( i )
    ;       If i = #PB_GadgetType_ScrollArea
    ;       Else
    ;         FreeGadget(i)
    ;       EndIf
  Next

SetWindowTitle(0, Str(WindowNumber(0)))
SetWindowTitle(1, Str(WindowNumber(1)))
SetWindowTitle(2, Str(WindowNumber(2)))

Repeat
  event = WaitWindowEvent()
  
  If #PB_Event_Repaint
    Debug enterID() ; WindowNumberUnderMouse()
  EndIf
  
Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---
; EnableXP