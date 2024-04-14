; https://www.purebasic.fr/english/viewtopic.php?t=58615

EnableExplicit

CompilerSelect #PB_Compiler_OS
   CompilerCase #PB_OS_Linux ; --------------------------------------------------
      ProcedureC ContainerResizeCallback(*Widget.GtkWidget, *Allocation.GtkAllocation, *UserData)
         Static GadgetHeight.I
         Static GadgetWidth.I
         
         If *Allocation\width <> GadgetWidth Or *Allocation\height <> GadgetHeight
            GadgetWidth = *Allocation\width
            GadgetHeight = *Allocation\height
            ResizeGadget(1, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
         EndIf
      EndProcedure
      
   CompilerCase #PB_OS_MacOS ; --------------------------------------------------
      ImportC ""
         sel_registerName(MethodName.S)
         class_addMethod(Class.I, Selector.I, Implementation.I, Types.S)
      EndImport
      
      Define AppDelegate.I = CocoaMessage(0, CocoaMessage(0, 0, "NSApplication sharedApplication"), "delegate")
      Define NotificationCenter.I = CocoaMessage(0, 0, "NSNotificationCenter defaultCenter")
      
      ProcedureC ContainerResizeCallback(Object.I, Selector.I, Sender.I)
         Debug ""+Object+" "+Selector+" "+Sender
         ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(0) - 20, WindowHeight(0) - 20)
      EndProcedure
      
      Procedure.S ConvertToUTF8(String.S)
         Protected UTF8String.S = Space(StringByteLength(String))
         PokeS(@UTF8String, String, -1, #PB_UTF8)
         ProcedureReturn UTF8String
      EndProcedure
      
   CompilerCase #PB_OS_Windows ; ------------------------------------------------
      Procedure ContainerResizeCallback()
         ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(0) - 20,
                      WindowHeight(0) - 20)
      EndProcedure
      
CompilerEndSelect ; ------------------------------------------------------------

OpenWindow(0, 270, 100, 120, 50, "Container resizing",
           #PB_Window_SystemMenu | #PB_Window_SizeGadget)
WindowBounds(0, 110, 50, #PB_Ignore, #PB_Ignore)
ContainerGadget(0, 10, 10, WindowWidth(0) - 20, WindowHeight(0) - 20)
ButtonGadget(1, 0, 0, GadgetWidth(0), GadgetHeight(0), "Test Button")

CompilerSelect #PB_Compiler_OS
   CompilerCase #PB_OS_Linux ; --------------------------------------------------
      Define SignalName.S = Space(StringByteLength("size-allocate", #PB_UTF8))
      PokeS(@SignalName, "size-allocate", -1, #PB_UTF8)
      g_signal_connect_(GadgetID(0), SignalName, @ContainerResizeCallback(), 0)
      
   CompilerCase #PB_OS_MacOS ; --------------------------------------------------
      Define selector = sel_registerName(ConvertToUTF8("ContainerResizeCallback"))
      class_addMethod(CocoaMessage(0, AppDelegate, ConvertToUTF8("class")),
                      selector,
                      @ContainerResizeCallback(), ConvertToUTF8("v@:@"))
      
      CocoaMessage(0, NotificationCenter,
                   "addObserver:", AppDelegate,
                   "selector:", selector,
                   "name:$", @"NSViewFrameDidChangeNotification",
                   "object:", GadgetID(0))
      
   CompilerCase #PB_OS_Windows ; ------------------------------------------------
      BindGadgetEvent(0, @ContainerResizeCallback(), #PB_EventType_LeftClick)
      
CompilerEndSelect ; ------------------------------------------------------------

Repeat
   Select WaitWindowEvent()
      Case #PB_Event_SizeWindow
         ResizeGadget(0, #PB_Ignore, #PB_Ignore, WindowWidth(0) - 20, WindowHeight(0) - 20)
         
      Case #PB_Event_CloseWindow
         CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            CocoaMessage(0, NotificationCenter, "removeObserver:", AppDelegate)
         CompilerEndIf
         Break
   EndSelect
ForEver
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 78
; FirstLine = 50
; Folding = --
; EnableXP