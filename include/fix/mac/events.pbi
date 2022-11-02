CompilerIf #PB_Compiler_IsMainFile
  DeclareModule constants
    Enumeration #PB_EventType_FirstCustomValue
      #PB_EventType_Drop
      #PB_EventType_MouseWheelX
      #PB_EventType_MouseWheelY
    EndEnumeration
  EndDeclareModule
  Module constants
  EndModule
CompilerEndIf

XIncludeFile "../../os/modules.pbi"

DeclareModule events
  EnableExplicit
  
  CompilerIf #PB_Compiler_IsMainFile
    Macro PB(Function)
      Function
    EndMacro
  CompilerEndIf
  
  Macro GadgetMouseX(_canvas_, _mode_ = #PB_Gadget_ScreenCoordinate)
    ; GetGadgetAttribute(_canvas_, #PB_Canvas_MouseX)
    DesktopMouseX() - GadgetX(_canvas_, _mode_)
    ; WindowMouseX(ID::Window(ID::GetWindowID(GadgetID(_canvas_)))) - GadgetX(_canvas_, #PB_Gadget_WindowCoordinate)  
  EndMacro
  Macro GadgetMouseY(_canvas_, _mode_ = #PB_Gadget_ScreenCoordinate)
    ; GetGadgetAttribute(_canvas_, #PB_Canvas_MouseY)
    DesktopMouseY() - GadgetY(_canvas_, _mode_)
    ; WindowMouseY(ID::Window(ID::GetWindowID(GadgetID(_canvas_)))) - GadgetY(_canvas_, #PB_Gadget_WindowCoordinate)
  EndMacro
  
;   Macro ResizeGadget(_gadget_,_x_,_y_,_width_,_height_)
;     PB(ResizeGadget)(_gadget_,_x_,_y_,_width_,_height_)
; ;     
; ;     If *setcallback ;And GadgetType(_gadget_) = #PB_GadgetType_Canvas
; ;       CompilerIf #PB_Compiler_IsMainFile
; ;        ; Debug "resize - " + _gadget_
; ;       CompilerEndIf
; ;       
; ;       CallCFunctionFast(*setcallback, _gadget_, #PB_EventType_Resize)
; ;     EndIf
;   EndMacro
  
  
  Global *dragged=-1, *entered=-1, *focused=-1, *pressed=-1, *setcallback
  
  Macro DraggedGadget() : events::*dragged : EndMacro
  Macro EnteredGadget() : events::*entered : EndMacro
  Macro FocusedGadget() : events::*focused : EndMacro
  Macro PressedGadget() : events::*pressed : EndMacro
  
  DraggedGadget() =- 1 
  EnteredGadget() =- 1 
  PressedGadget() =- 1 
  FocusedGadget() =- 1 
  
  Declare.i WaitEvent(event.i, second.i=0)
  ;   Declare DrawCanvasFrame(gadget, color)
  ;   Declare DrawCanvasBack(gadget, color)
  Declare SetCallBack(*callback)
EndDeclareModule
Module events
  ;   #NSLeftMouseDown      = 1
  ;   #NSLeftMouseUp        = 2
  ;   #NSRightMouseDown     = 3
  ;   #NSRightMouseUp       = 4
  ;   #NSMouseMoved         = 5
  ;   #NSLeftMouseDragged   = 6
  ;   #NSRightMouseDragged  = 7
  ;   #NSMouseEntered       = 8
  ;   #NSMouseExited        = 9
  ;   #NSKeyDown            = 10
  ;   #NSKeyUp              = 11
  ;   #NSFlagsChanged       = 12
  ;   #NSAppKitDefined      = 13
  ;   #NSSystemDefined      = 14
  ;   #NSApplicationDefined = 15
  ;   #NSPeriodic           = 16
  ;   #NSCursorUpdate       = 17
  ;   #NSScrollWheel        = 22
  ;   #NSTabletPoint        = 23
  ;   #NSTabletProximity    = 24
  ;   #NSOtherMouseDown     = 25
  ;   #NSOtherMouseUp       = 26
  ;   #NSOtherMouseDragged  = 27
  ;   #NSEventTypeGesture   = 29
  ;   #NSEventTypeMagnify   = 30
  ;   #NSEventTypeSwipe     = 31
  ;   #NSEventTypeRotate    = 18
  ;   #NSEventTypeBeginGesture = 19
  ;   #NSEventTypeEndGesture   = 20
  ;   #NSEventTypeSmartMagnify = 32
  ;   #NSEventTypeQuickLook   = 33
  
  Global psn.q, mask, key.s
  
  Global event_window =- 1
  Global event_gadget =- 1
  
  ImportC ""
    CFRunLoopGetCurrent()
    CFRunLoopAddCommonMode(rl, mode)
    
    CGEventTapCreate(tap.i, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
    
;     GetCurrentProcess(*psn)
;     CGEventTapCreateForPSN(*psn, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
    CGEventTapCreateForPSN(*ProcessSerialNumber, CGEventTapPlacement.i, CGEventTapOptions.i, CGEventMask.Q, CGEventTapCallback.i, *UserData)
    GetCurrentProcess(*ProcessSerialNumber)
  EndImport
  
  ProcedureC  eventTapFunction(proxy, eType, event, refcon) ; CGEventTapProxy.i, CGEventType.i, CGEvent.i,  *UserData
    Protected Point.CGPoint
    Protected *cursor.cursor::_s_cursor = #Null
    ; Debug "eventTapFunction - "+ID::ClassName(event)
    
    If refcon
      Static LeftClick, ClickTime, MouseDrag, MouseMoveX, MouseMoveY, DeltaX, DeltaY, LeftDoubleClickTime
      Protected MouseMove, MouseX, MouseY, MoveStart, LeftDoubleClick, EnteredID, gadget =- 1
      
      ;       If eType = #NSMouseEntered
      ;         Debug "en "+proxy+" "+CocoaMessage(0, CocoaMessage(0, NSEvent, "window"), "contentView") +" "+CocoaMessage(0, NSEvent, "windowNumber")
      ;       EndIf
      ;       If eType = #NSMouseExited
      ;         Debug "le "+proxy+" "+ CocoaMessage(0, NSEvent, "windowNumber")
      ;       EndIf
      
      If eType = #NSLeftMouseDown
        ;Debug CocoaMessage(0, Mouse::Gadget(Mouse::Window()), "pressedMouseButtons")
        MouseDrag = 1
      ElseIf eType = #NSLeftMouseUp
        MouseDrag = 0
        If EnteredGadget() >= 0 
          If DraggedGadget() >= 0 And DraggedGadget() = PressedGadget() 
            CompilerIf Defined(constants::PB_EventType_Drop, #PB_Constant) 
              CallCFunctionFast(refcon, EnteredGadget(), constants::#PB_EventType_Drop)
            CompilerEndIf
          EndIf
          
          If Not (LeftDoubleClickTime And ElapsedMilliseconds() - LeftDoubleClickTime < DoubleClickTime())
            LeftDoubleClickTime = ElapsedMilliseconds() 
          Else
            LeftDoubleClick = 1
          EndIf
        EndIf
      EndIf
      
      If MouseDrag >= 0 
        EnteredID = Mouse::Gadget(Mouse::Window())
      EndIf
      
      ;
      If EnteredID
        gadget = ID::Gadget(EnteredID)
        
        If gadget >= 0
          Mousex = GadgetMouseX(gadget)
          Mousey = GadgetMouseY(gadget)
        Else
          Mousex =- 1
          Mousey =- 1
        EndIf
      Else
        Mousex =- 1
        Mousey =- 1
      EndIf
      
      ;
      If MouseDrag And
         Mousex =- 1 And Mousey =- 1
        
        If PressedGadget() >= 0
          Mousex = GadgetMouseX(PressedGadget())
          Mousey = GadgetMouseY(PressedGadget())
        EndIf
      EndIf
      
      If MouseMoveX <> Mousex
        MouseMoveX = Mousex
        MouseMove = #True
      EndIf
      
      If MouseMoveY <> Mousey
        MouseMoveY = Mousey
        MouseMove = #True
      EndIf
      
      ;
      If MouseMove 
        If MouseDrag >= 0 And 
           EnteredGadget() <> gadget
          If EnteredGadget() >= 0 ;And GadgetType(EnteredGadget()) = #PB_GadgetType_Canvas
            If Not MouseDrag
              Cursor::change(EnteredGadget(), 0)
            EndIf
            
            CallCFunctionFast(refcon, EnteredGadget() , #PB_EventType_MouseLeave)
          EndIf
          
          EnteredGadget() = gadget
          
          If EnteredGadget() >= 0 ;And GadgetType(EnteredGadget()) = #PB_GadgetType_Canvas
            If Not MouseDrag
              Cursor::change(EnteredGadget(), 1)
            EndIf
            
            CallCFunctionFast(refcon, EnteredGadget(), #PB_EventType_MouseEnter)
          EndIf
        Else
          ; mouse drag start
          If MouseDrag > 0
            If EnteredGadget() >= 0 And
               DraggedGadget() <> PressedGadget()
              DraggedGadget() = PressedGadget()
              CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_DragStart)
              DeltaX = GadgetX(PressedGadget()) 
              DeltaY = GadgetY(PressedGadget())
            EndIf
          EndIf
          
          If MouseDrag And EnteredGadget() <> PressedGadget()
            CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_MouseMove)
          EndIf
          
          If EnteredGadget() >= 0
            CallCFunctionFast(refcon, EnteredGadget(), #PB_EventType_MouseMove)
            
            ; if move gadget x&y position
            If MouseDrag > 0 And PressedGadget() = EnteredGadget() 
              If DeltaX <> GadgetX(PressedGadget()) Or 
                 DeltaY <> GadgetY(PressedGadget())
                MouseDrag =- 1
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
      
      ;
      If eType = #NSLeftMouseDown
        PressedGadget() = EnteredGadget() ; EventGadget()
                                          ;Debug CocoaMessage(0, Mouse::Window(), "focusView")
        
        If PressedGadget() >= 0
          If FocusedGadget() =- 1
            FocusedGadget() = PressedGadget() ; GetActiveGadget()
            If GadgetType(FocusedGadget()) = #PB_GadgetType_Canvas
              CallCFunctionFast(refcon, FocusedGadget(), #PB_EventType_Focus)
            EndIf
          EndIf
          
          If FocusedGadget() >= 0 And 
             FocusedGadget() <> PressedGadget()
            CallCFunctionFast(refcon, FocusedGadget(), #PB_EventType_LostFocus)
            
            FocusedGadget() = PressedGadget()
            CallCFunctionFast(refcon, FocusedGadget(), #PB_EventType_Focus)
          EndIf
          
          CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftButtonDown)
        EndIf
      EndIf
      
      ;
      If eType = #NSLeftMouseUp
        If PressedGadget() >= 0 And 
           PressedGadget() <> gadget  
          Cursor::change(PressedGadget(), 0)
        EndIf
        
        If gadget >= 0 And 
           gadget <> PressedGadget()
          EnteredGadget() = gadget
          Cursor::change(EnteredGadget(), 1)
        EndIf
        
        If PressedGadget() >= 0 
          CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftButtonUp)
          
          ;           If LeftDoubleClick
          ;             CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftDoubleClick)
          ;           Else
          ;             If PressedGadget() <> DraggedGadget()
          ;               If PressedGadget() >= 0 And EnteredID = GadgetID(PressedGadget())
          ;                 CallCFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftClick)
          ;               EndIf
          ;             EndIf
          ;           EndIf
        EndIf
        
        ; PressedGadget() =- 1
        DraggedGadget() =- 1
      EndIf
      
      ;         ;
      ;         If eType = #PB_EventType_LeftDoubleClick
      ;           CallCFunctionFast(refcon, EnteredGadget(), #PB_EventType_LeftDoubleClick)
      ;         EndIf
      
      If eType = #NSScrollWheel
        Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
        
        If NSEvent
          Protected scrollX = CocoaMessage(0, NSEvent, "scrollingDeltaX")
          Protected scrollY = CocoaMessage(0, NSEvent, "scrollingDeltaY")
          
          If scrollX And Not scrollY
            ; Debug "X - scroll"
            If EnteredGadget() >= 0
              CompilerIf Defined(constants::PB_EventType_MouseWheelY, #PB_Constant) 
                CallCFunctionFast(refcon, EnteredGadget(), constants::#PB_EventType_MouseWheelX, scrollX)
              CompilerEndIf
            EndIf
          EndIf
          
          If scrollY And Not scrollX
            ; Debug "Y - scroll"
            If EnteredGadget() >= 0
              CompilerIf Defined(constants::PB_EventType_MouseWheelX, #PB_Constant) 
                CallCFunctionFast(refcon, EnteredGadget(), constants::#PB_EventType_MouseWheelY, scrollY)
              CompilerEndIf
            EndIf
          EndIf
        EndIf
      EndIf
      
      
      ;           If eType = #PB_EventType_Resize
      ;             ; CallCFunctionFast(refcon, EventGadget(), #PB_EventType_Resize)
      ;           EndIf
      ;           CompilerIf Defined(PB_EventType_Repaint, #PB_Constant) And Defined(constants, #PB_Module)
      ;             If eType = #PB_EventType_Repaint
      ;               CallCFunctionFast(refcon, EventGadget(), #PB_EventType_Repaint)
      ;             EndIf
      ;           CompilerEndIf
      ;           
    EndIf
    
  EndProcedure
  
  Procedure ResizeEvent( )
    If EventType() = #PB_EventType_Resize
      CallCFunctionFast(*setcallback, EventGadget(), EventType())
    EndIf
  EndProcedure
  
  Procedure.i WaitEvent(event.i, second.i=0)
    If *setcallback And event = #PB_Event_Gadget
      Protected EventType = EventType()
      Protected EventGadget = EventGadget()
      CompilerIf Defined(constants::PB_EventType_Repaint, #PB_Constant) 
        If EventType = constants::#PB_EventType_Repaint
          CallCFunctionFast(*setcallback, EventGadget, EventType)
        EndIf
      CompilerEndIf
      CompilerIf Defined(constants::PB_EventType_Create, #PB_Constant) 
        If EventType = constants::#PB_EventType_Create
          CallCFunctionFast(*setcallback, EventGadget, EventType)
        EndIf
      CompilerEndIf
;       If EventType = #PB_EventType_MouseEnter
;         ; Debug " e - "+Mouse::Window() +" "+ WindowID(EventWindow())
;         If Mouse::Window() = WindowID(EventWindow())
;           CallCFunctionFast(*setcallback, EventGadget, EventType)
;         EndIf
;       EndIf
      If EventType = #PB_EventType_KeyDown Or
         EventType = #PB_EventType_KeyUp Or
         EventType = #PB_EventType_Input
        
        CallCFunctionFast(*setcallback, EventGadget, EventType)
      EndIf
    EndIf
    
    ProcedureReturn event
  EndProcedure
  
  Procedure   SetCallBack(*callback)
    *setcallback = *callback
    
    Protected mask, EventTap
    mask = #NSMouseMovedMask | #NSScrollWheelMask
    mask | #NSMouseEnteredMask | #NSMouseExitedMask 
    mask | #NSLeftMouseDownMask | #NSLeftMouseUpMask 
    mask | #NSRightMouseDownMask | #NSRightMouseDownMask 
    mask | #NSLeftMouseDraggedMask | #NSRightMouseDraggedMask   ;| #NSCursorUpdateMask
    
    #cghidEventTap = 0              ; Указывает, что отвод события размещается в точке, где системные события HID поступают на оконный сервер.
    #cgSessionEventTap = 1          ; Указывает, что отвод события размещается в точке, где события системы HID и удаленного управления входят в сеанс входа в систему.
    #cgAnnotatedSessionEventTap = 2 ; Указывает, что отвод события размещается в точке, где события сеанса были аннотированы для передачи в приложение.
    
    #headInsertEventTap = 0         ; Указывает, что новое касание события должно быть вставлено перед любым ранее существовавшим касанием события в том же месте.
    #tailAppendEventTap = 1         ; Указывает, что новое касание события должно быть вставлено после любого ранее существовавшего касания события в том же месте
    
    
     GetCurrentProcess(@psn): eventTap = CGEventTapCreateForPSN(@psn, #headInsertEventTap, 1, mask, @eventTapFunction( ), *callback)
     
     ; с ним mousemove не происходит если приложение не активно
     ;eventTap = CGEventTapCreate(2, 0, 1, mask, @eventTapFunction(), *callback)
    
    If eventTap
      CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopDefaultMode")
    EndIf
    ; CFRelease_(eventTap)
    
    BindEvent(#PB_Event_Gadget, @ResizeEvent( ))
  EndProcedure
EndModule

;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule constants
  ;UseModule events
  
  Define event
  Define g1,g2
  
  Procedure   DrawCanvasBack(gadget, color)
    If GadgetType(gadget) = #PB_GadgetType_Canvas
      StartDrawing(CanvasOutput(gadget))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(), OutputHeight(), color)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure   DrawCanvasFrame(gadget, color)
    If GadgetType(gadget) = #PB_GadgetType_Canvas
      StartDrawing(CanvasOutput(gadget))
      If GetGadgetState(gadget)
        DrawImage(0,0, GetGadgetState(gadget))
      EndIf
      If Not color
        color = Point(10,10)
      EndIf
      If color 
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(0,0,OutputWidth(), OutputHeight(), color)
      EndIf
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Resize_2()
    Protected canvas = 2
    ResizeGadget(canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(canvas)*2, WindowHeight(EventWindow()) - GadgetY(canvas)*2)
  EndProcedure
  
  Procedure Resize_3()
    Protected canvas = 3
    ResizeGadget(canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(canvas)*2, WindowHeight(EventWindow()) - GadgetY(canvas)*2)
  EndProcedure
  
  Procedure EventHandler(eventobject, eventtype, eventdata)
    Protected window = EventWindow()
    Protected dropx, dropy
    Static deltax, deltay
    
    Select eventtype
      Case #PB_EventType_MouseWheelX
        Debug ""+eventobject + " #PB_EventType_MouseWheelX " +eventdata
        
      Case #PB_EventType_MouseWheelY
        Debug ""+eventobject + " #PB_EventType_MouseWheelY " +eventdata
        
      Case #PB_EventType_DragStart
        deltax = events::GadgetMouseX(eventobject, #PB_Gadget_WindowCoordinate)
        deltay = events::GadgetMouseY(eventobject, #PB_Gadget_WindowCoordinate)
        Debug ""+eventobject + " #PB_EventType_DragStart " + "x="+ deltax +" y="+ deltay
        
      Case #PB_EventType_Drop
        dropx = events::GadgetMouseX(eventobject, #PB_Gadget_ScreenCoordinate)
        dropy = events::GadgetMouseY(eventobject, #PB_Gadget_ScreenCoordinate)
        Debug ""+eventobject + " #PB_EventType_Drop " + "x="+ dropx +" y="+ dropy
        
      Case #PB_EventType_Focus
        Debug ""+eventobject + " #PB_EventType_Focus " 
        DrawCanvasBack(eventobject, $FFA7A4)
        DrawCanvasFrame(eventobject, $2C70F5)
        
      Case #PB_EventType_LostFocus
        Debug ""+eventobject + " #PB_EventType_LostFocus " 
        DrawCanvasBack(eventobject, $FFFFFF)
        
      Case #PB_EventType_LeftButtonDown
        Debug ""+eventobject + " #PB_EventType_LeftButtonDown " 
        
      Case #PB_EventType_LeftButtonUp
        Debug ""+eventobject + " #PB_EventType_LeftButtonUp " 
        
      Case #PB_EventType_LeftClick
        Debug ""+eventobject + " #PB_EventType_LeftClick " 
        
      Case #PB_EventType_LeftDoubleClick
        Debug ""+eventobject + " #PB_EventType_LeftDoubleClick " 
        
      Case #PB_EventType_MouseEnter
        Debug ""+eventobject + " #PB_EventType_MouseEnter " ;+ CocoaMessage(0, WindowID(window), "isActive") 
        DrawCanvasFrame(eventobject, $00A600)
        
      Case #PB_EventType_MouseLeave
        Debug ""+eventobject + " #PB_EventType_MouseLeave "
        DrawCanvasFrame(eventobject, 0)
        
      Case #PB_EventType_Resize
        Debug ""+eventobject + " #PB_EventType_Resize " 
        
      Case #PB_EventType_MouseMove
        If events::DraggedGadget() = 1
          Debug ""+eventobject + " #PB_EventType_MouseMove " 
          ResizeGadget(events::DraggedGadget(), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
        EndIf
        ;         If events::DraggedGadget() = 0
        ;           ResizeGadget(events::DraggedGadget(), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
        ;         EndIf
        
    EndSelect
  EndProcedure
  
  Procedure OpenWindow_(window, x,y,width,height, title.s, flag=0)
    Protected result = OpenWindow(window, x,y,width,height, title.s, flag)
    If window >= 0
      WindowID = WindowID(window)
    Else
      WindowID = result
    EndIf
    Debug 77
    ;CocoaMessage(0, WindowID, "disableCursorRects")
    ProcedureReturn result
  EndProcedure
  
  Macro OpenWindow(window, x,y,width,height, title, flag=0)
    OpenWindow_(window, x,y,width,height, title, flag)
  EndMacro
  
  events::SetCallback(@EventHandler())
  ;/// first
  OpenWindow(1, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
  CanvasGadget(0, 240, 10, 60, 60, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  ButtonGadget(100, 60,240,60,60,"")
  g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  g2=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  SplitterGadget(111,10,240,60,60, g1,g2)
  
  ; If set((111),#PB_Cursor_UpDown)
  ;   Debug "updown"           
  ; EndIf       
  
  If cursor::set((100),#PB_Cursor_Hand)
    Debug "setCursorHand"           
  EndIf       
  
  If cursor::set((g1),#PB_Cursor_IBeam)
    Debug "setCursorIBeam"           
  EndIf       
  
  If cursor::set((g2),#PB_Cursor_IBeam)
    Debug "setCursorIBeam"           
  EndIf       
  
  If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png") = 0
    MessageRequester("Error",
                     "Loading of image World.png failed!",
                     #PB_MessageRequester_Error)
    End
  EndIf
  If cursor::set((0), ImageID(0))
    Debug "setCursorImage"           
  EndIf       
  
  If cursor::set((1),#PB_Cursor_Hand)
    Debug "setCursorHand - " +CocoaMessage(0, 0, "NSCursor currentCursor")
  EndIf       
  
  If cursor::set((11),#PB_Cursor_Cross)
    Debug "setCursorCross"           
  EndIf       
  
  
  
  ;/// second
  OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  g1=StringGadget(-1,0,0,0,0,"StringGadget")
  g2=HyperLinkGadget(-1,0,0,0,0,"HyperLinkGadget", 0)
  SplitterGadget(2, 10, 10, 200, 200, g1,g2)
  BindEvent(#PB_Event_SizeWindow, @Resize_2(), 2)
  
  ;   If cursor::set((g1),#PB_Cursor_IBeam)
  ;     Debug "setCursorIBeam"           
  ;   EndIf       
  ;   
  ;   If cursor::set((g2),#PB_Cursor_Hand)
  ;     Debug "setCursorHand"           
  ;   EndIf       
  ;   
  ;   If cursor::set((2),#PB_Cursor_UpDown)
  ;     Debug "setCursorHand"           
  ;   EndIf       
  
  
  
  ;/// third
  OpenWindow(3, 450+50, 200+50, 220, 220, "window_3", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  g2=StringGadget(-1,0,0,0,0,"StringGadget")
  SplitterGadget(3,10, 10, 200, 200, g1,g2)
  BindEvent(#PB_Event_SizeWindow, @Resize_3(), 3)
  
  If cursor::set((g1),#PB_Cursor_IBeam)
    Debug "setCursorIBeam"           
  EndIf       
  
  ;   If cursor::set((g2),#PB_Cursor_IBeam)
  ;     Debug "setCursorIBeam"           
  ;   EndIf       
  
  
  ;Debug "currentCursor - "+CocoaMessage(0, 0, "NSCursor currentCursor") ; CocoaMessage(0, 0, "NSCursor systemCursor") +" "+ 
  ;;events::SetCallback(@EventHandler())
  
  OpenWindow(#PB_Any, 550, 300, 328, 328, "window_1", #PB_Window_SystemMenu)
  Canvas_0 = CanvasGadget(#PB_Any, 8, 8, 56, 56)
  ;;Canvas_1 = CanvasGadget(#PB_Any, 8, 72, 56, 56)
  left = CanvasGadget(#PB_Any, 8, 136, 24, 56)
  left2 = CanvasGadget(#PB_Any, 8+24+8, 136, 24, 56)
  ;;Canvas_3 = CanvasGadget(#PB_Any, 8, 200, 56, 56)
  Canvas_32 = CanvasGadget(#PB_Any, 8, 264, 56, 56)
  
  ;   Canvas_4 = CanvasGadget(#PB_Any, 72, 8, 56, 56)
  lt = CanvasGadget(#PB_Any, 72, 72, 56, 56)
  l = CanvasGadget(#PB_Any, 72, 136, 56, 56)
  lb = CanvasGadget(#PB_Any, 72, 200, 56, 56)
  ;   Canvas_72 = CanvasGadget(#PB_Any, 72, 264, 56, 56)
  
  up = CanvasGadget(#PB_Any, 136, 8, 56, 24)
  up2 = CanvasGadget(#PB_Any, 136, 8+24+8, 56, 24)
  t = CanvasGadget(#PB_Any, 136, 72, 56, 56)
  c = CanvasGadget(#PB_Any, 136, 136, 56, 56)
  b = CanvasGadget(#PB_Any, 136, 200, 56, 56)
  down = CanvasGadget(#PB_Any, 136, 264+8+24, 56, 24)
  down2 = CanvasGadget(#PB_Any, 136, 264, 56, 24)
  
  ;   Canvas_12 = CanvasGadget(#PB_Any, 200, 8, 56, 56)
  rt = CanvasGadget(#PB_Any, 200, 72, 56, 56)
  r = CanvasGadget(#PB_Any, 200, 136, 56, 56)
  rb = CanvasGadget(#PB_Any, 200, 200, 56, 56)
  ;   Canvas_152 = CanvasGadget(#PB_Any, 200, 264, 56, 56)
  
  Canvas_16 = CanvasGadget(#PB_Any, 264, 8, 56, 56)
  ;;Canvas_17 = CanvasGadget(#PB_Any, 264, 72, 56, 56)
  right = CanvasGadget(#PB_Any, 264+8+24, 136, 24, 56)
  right2 = CanvasGadget(#PB_Any, 264, 136, 24, 56)
  ;;Canvas_19 = CanvasGadget(#PB_Any, 264, 200, 56, 56)
  Canvas_192 = CanvasGadget(#PB_Any, 264, 264, 56, 56)
  
  Cursor::set((left2), Cursor::#PB_Cursor_LeftRight ) 
  Cursor::set((right2), Cursor::#PB_Cursor_LeftRight ) 
  Cursor::set((lt), Cursor::#PB_Cursor_LeftUpRightDown ) 
  Cursor::set((rb), Cursor::#PB_Cursor_LeftUpRightDown ) 
  Cursor::set((up2), Cursor::#PB_Cursor_UpDown ) 
  Cursor::set((down2), Cursor::#PB_Cursor_UpDown ) 
  Cursor::set((rt), Cursor::#PB_Cursor_LeftDownRightUp ) 
  Cursor::set((lb), Cursor::#PB_Cursor_LeftDownRightUp ) 
  Cursor::set((left), Cursor::#PB_Cursor_Left ) 
  Cursor::set((up), Cursor::#PB_Cursor_Up ) 
  Cursor::set((right), Cursor::#PB_Cursor_Right ) 
  Cursor::set((down), Cursor::#PB_Cursor_Down ) 
  Cursor::set((c), Cursor::#PB_Cursor_Up ) 
  Cursor::set((Canvas_16), Cursor::#PB_Cursor_Cross ) 
  Cursor::set((Canvas_0), Cursor::#PB_Cursor_Drag ) 
  Cursor::set((Canvas_32), Cursor::#PB_Cursor_Denied ) 
  Cursor::set((Canvas_192), Cursor::#PB_Cursor_Drop ) 
  
  Macro DrawUp(x, y, size, bcolor, fcolor)
    Line(x+7, y, 2, 1, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    Plot(x+6, y+1, fcolor ) : Line(x+7, y+1, 2, 1, bcolor) : Plot(x+9, y+1, fcolor )                                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x+5, y+2, fcolor ) : Line(x+6, y+2, 4, 1, bcolor) : Plot(x+10, y+2, fcolor )                                  ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
    Plot(x+4, y+3, fcolor ) : Line(x+5, y+3, 6, 1, bcolor) : Plot(x+11, y+3, fcolor )                                  ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
    Line(x+4, y+4, 3, 1, fcolor) : Line(x+7, y+4, 2, 1, bcolor) : Line(x+size/2+1, y+4, 3 , 1, fcolor)                 ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x+size/2-2, y+5, fcolor ) : Line(x+7, y+5, 2, 1, bcolor) : Plot(x+size/2+1, y+5, fcolor )                     ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
  EndMacro
  Macro DrawDown(x, y, size, bcolor, fcolor)
    Plot(x+size/2-2, y+4, fcolor ) : Line(x+7, y+4, 2, 1, bcolor) : Plot(x+size/2+1, y+4, fcolor )                     ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Line(x+4, y+5, 3, 1, fcolor) : Line(x+7, y+5, 2, 1, bcolor) : Line(x+size/2+1, y+5, 3, 1, fcolor)                  ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x+4, y+6, fcolor ) : Line(x+5, y+6, 6, 1, bcolor) : Plot(x+11, y+6, fcolor )                                  ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
    Plot(x+5, y+7, fcolor ) : Line(x+6, y+7, 4, 1, bcolor) : Plot(x+10, y+7, fcolor )                                  ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
    Plot(x+6, y+8, fcolor ) : Line(x+7, y+8, 2, 1, bcolor) : Plot(x+9, y+8, fcolor )                                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Line(x+7, y+9, 2, 1, fcolor)                                                                                       ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  EndMacro
  Macro DrawLeft(x, y, width, bcolor, fcolor)
    Line(x, y+7, 1, 2, fcolor)                                                                                          ; 0,0,0,0,0,0,0,0,0
    Plot(x+1, y+6, fcolor ) : Line(x+1, y+7, 1, 2, bcolor) : Plot(x+1, y+9, fcolor )                                    ; 1,0,0,0,0,0,0,0,0
    Plot(x+2, y+5, fcolor ) : Line(x+2, y+6, 1, 4, bcolor) : Plot(x+2, y+10, fcolor )                                   ; 1,0,0,0,0,0,0,0,0
    Plot(x+3, y+4, fcolor ) : Line(x+3, y+5, 1, 6, bcolor) : Plot(x+3, y+11, fcolor )                                   ; 1,0,0,0,0,0,0,0,0
    Line(x+4, y+4, 1, 3, fcolor) : Line(x+4, y+7, 1, 2, bcolor) : Line(x+4, y+width/2+1, 1, 3, fcolor)                  ; 1,0,0,0,0,0,0,0,0
    Plot(x+5, y+width/2-2, fcolor ) : Line(x+5, y+7, 1, 2, bcolor) : Plot(x+5, y+width/2+1, fcolor )                    ; 1,0,0,0,0,1,0,0,0
  EndMacro  
  Macro DrawRight(x, y, width, bcolor, fcolor)
    Plot(x+4, y+width/2-2, fcolor ) : Line(x+4, y+7, 1, 2, bcolor) : Plot(x+4, y+width/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Line(x+5, y+4, 1, 3, fcolor) : Line(x+5, y+7, 1, 2, bcolor) : Line(x+5, y+width/2+1, 1, 3, fcolor)                  ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x+6, y+4, fcolor ) : Line(x+6, y+5, 1, 6, bcolor) : Plot(x+6, y+11, fcolor )                                   ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
    Plot(x+7, y+5, fcolor ) : Line(x+7, y+6, 1, 4, bcolor) : Plot(x+7, y+10, fcolor )                                   ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
    Plot(x+8, y+6, fcolor ) : Line(x+8, y+7, 1, 2, bcolor) : Plot(x+8, y+9, fcolor )                                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Line(x+9, y+7, 1, 2, fcolor)                                                                                        ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  EndMacro
  
  Macro DrawCursor2(x, y, width, height, bcolor, fcolor)
    DrawUp(x, y, size, bcolor, fcolor)
    DrawDown(x, y+height-2, size, bcolor, fcolor)
    
    LineXY(x,y+1,x+5,y+6,bcolor)
    LineXY(x+1,y+1,x+5,y+5,bcolor)
    ;     Plot(x+1, y+2, bcolor )
    ;     Plot(x+2, y+1, bcolor )
    ;     
    ;     Plot(x+2, y+3, bcolor )
    ;     Plot(x+3, y+2, bcolor )
    ;     
    ;     Plot(x+3, y+4, bcolor )
    ;     Plot(x+4, y+3, bcolor )
    ;     
    ;     Plot(x+4, y+5, bcolor )
    ;     Plot(x+5, y+4, bcolor )
  EndMacro  
  Macro DrawCursor6(x, y, width, bcolor, fcolor)
    ;     Plot(x+4, y+width/2-2, fcolor ) : Line(x+4, y+7, 1, 2, bcolor) : Plot(x+4, y+width/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    ;     Line(x+5, y+3, 1, width/3-1, fcolor) : Line(x+5, y+7, 1, 2, bcolor) : Line(x+5, y+width/2+1, 1, width/3-1, fcolor)  ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    ;     Plot(x+6, y+4, fcolor ) : Line(x+6, y+5, 1, 6, bcolor) : Plot(x+6, y+11, fcolor )                                   ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
    ;     Plot(x+7, y+5, fcolor ) : Line(x+7, y+6, 1, 4, bcolor) : Plot(x+7, y+10, fcolor )                                   ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
    ;     Plot(x+8, y+6, fcolor ) : Line(x+8, y+7, 1, 2, bcolor) : Plot(x+8, y+9, fcolor )                                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    ;     Line(x+9, y+7, 1, 2, fcolor)                                                                                        ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  EndMacro
  
  Macro DrawCursorSplitterV(x, y, width, height, bcolor, fcolor)
    DrawUp(x, y, width, bcolor, fcolor)
    DrawCursorSplitterUp(x,y,width, bcolor, fcolor )
    DrawCursorSplitterDown(x,y+height-1,width, bcolor, fcolor )
    DrawDown(x, y+height-1, width, bcolor, fcolor)
  EndMacro
  Macro DrawCursorSplitterH(x, y, height, width, bcolor, fcolor)
    DrawLeft(x, y, width, bcolor, fcolor)
    DrawCursorSplitterLeft(x,y,width, bcolor, fcolor )
    DrawCursorSplitterRight(x,y+height-1,width, bcolor, fcolor )
    DrawRight(x, y+height-1, width, bcolor, fcolor)
  EndMacro
  
  Macro DrawCursorUp(x, y, width, bcolor, fcolor)
    DrawUp(x, y, width, bcolor, fcolor)
    Plot(x+width/2-2, y+6, fcolor ) : Line(x+7, y+6, 2, 1, bcolor) : Plot(x+width/2+1, y+6, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x+width/2-2, y+7, fcolor ) : Line(x+7, y+7, 2, 1, bcolor) : Plot(x+width/2+1, y+7, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
  EndMacro
  Macro DrawCursorDown(x, y, width, bcolor, fcolor)
    Plot(x+width/2-2, y+2, fcolor ) : Line(x+7, y+2, 2, 1, bcolor) : Plot(x+width/2+1, y+2, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x+width/2-2, y+3, fcolor ) : Line(x+7, y+3, 2, 1, bcolor) : Plot(x+width/2+1, y+3, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    DrawDown(x, y, width, bcolor, fcolor)
  EndMacro
  Macro DrawCursorLeft(x, y, width, bcolor, fcolor)
    DrawLeft(x, y, width, bcolor, fcolor)
    Plot(x+6, y+width/2-2, fcolor ) : Line(x+6, y+7, 1, 2, bcolor) : Plot(x+6, y+width/2+1, fcolor )                    ; 1,0,0,0,0,1,0,0,0
    Plot(x+7, y+width/2-2, fcolor ) : Line(x+7, y+7, 1, 2, bcolor) : Plot(x+7, y+width/2+1, fcolor )                    ; 1,0,0,0,0,1,0,0,0
  EndMacro  
  Macro DrawCursorRight(x, y, width, bcolor, fcolor)
    Plot(x+2, y+width/2-2, fcolor ) : Line(x+2, y+7, 1, 2, bcolor) : Plot(x+2, y+width/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x+3, y+width/2-2, fcolor ) : Line(x+3, y+7, 1, 2, bcolor) : Plot(x+3, y+width/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    DrawRight(x, y, width, bcolor, fcolor)
  EndMacro
  
  Macro DrawCursorSplitterUp(x, y, width, bcolor, fcolor)
    Line(x, y+6, width/2-1 , 1, fcolor) : Line(x+7, y+6, 2, 1, bcolor) : Line(x+width/2+1, y+6, width/2-1, 1, fcolor)   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    Plot(x, y+7, fcolor ) : Line(x+1, y+7, width-2, 1, bcolor) : Plot(x+width-1, y+7, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
  EndMacro
  Macro DrawCursorSplitterDown(x, y, width, bcolor, fcolor)
    Plot(x, y+2, fcolor ) : Line(x+1, y+2, width-2, 1, bcolor) : Plot(x+width-1, y+2, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
    Line(x, y+3, width/2-1, 1, fcolor) : Line(x+7, y+3, 2, 1, bcolor) : Line(x+width/2+1, y+3, width/2-1 , 1, fcolor)   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
  EndMacro
  Macro DrawCursorSplitterLeft(x, y, width, bcolor, fcolor)
    Debug width
    DrawLeft(x, y, width, bcolor, fcolor)
    Line(x+6, y , 1, width/2-1, fcolor) : Line(x+6, y+7, 1, 2, bcolor) : Line(x+6, y+width/2+1, 1, width/2-1, fcolor)   ; 1,0,0,0,0,1,1,0,0
    Plot(x+7, y, fcolor ) : Line(x+7, y+1, 1, width-2, bcolor) : Plot(x+7, y+width-1, fcolor )                          ; 1,1,1,1,1,1,1,1,0
  EndMacro  
  Macro DrawCursorSplitterRight(x, y, width, bcolor, fcolor)
    Plot(x+2, y, fcolor ) : Line(x+2, y+1, 1, width-2, bcolor) : Plot(x+2, y+width-1, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
    Line(x+3, y, 1, width/2-1, fcolor) : Line(x+3, y+7, 1, 2, bcolor) : Line(x+3, y+width/2+1, 1, width/2-1, fcolor)    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
    DrawRight(x, y, width, bcolor, fcolor)
  EndMacro
  
  fcolor = $FFFFFF
  bcolor = $000000
  width = 16
  height = 7
  
  If StartDrawing(CanvasOutput(lt))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-width)/2
    ; 
    LineXY(x+3,y+2,x+13,y+12,bcolor)
    LineXY(x+2,y+2,x+13,y+13,bcolor)
    LineXY(x+2,y+3,x+12,y+13,bcolor)
    
    Plot(x+12,y+10,bcolor)
    Plot(x+10,y+12,bcolor)
    Plot(x+5,y+3,bcolor)
    Plot(x+3,y+5,bcolor)
    
    Line(x+2,y+4,1,3,bcolor)
    Line(x+4,y+2,3,1,bcolor)
    Line(x+9,y+13,3,1,bcolor)
    Line(x+13,y+9,1,3,bcolor)
    
    ;
    LineXY(x+6,y+4,x+11,y+9,fcolor)
    LineXY(x+4,y+6,x+9,y+11,fcolor)
    
    LineXY(x+2,y+7,x+3,y+6,fcolor)
    LineXY(x+7,y+2,x+6,y+3,fcolor)
    LineXY(x+8,y+13,x+9,y+12,fcolor)
    LineXY(x+13,y+8,x+12,y+9,fcolor)
    
    Line(x+1,y+2,1,6,fcolor)
    Line(x+14,y+8,1,6,fcolor)
    Line(x+2,y+1,6,1,fcolor)
    Line(x+8,y+14,6,1,fcolor)
    
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(rb))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-width)/2
    ; 
    LineXY(x+3,y+2,x+13,y+12,bcolor)
    LineXY(x+2,y+2,x+13,y+13,bcolor)
    LineXY(x+2,y+3,x+12,y+13,bcolor)
    
    Plot(x+12,y+10,bcolor)
    Plot(x+10,y+12,bcolor)
    Plot(x+5,y+3,bcolor)
    Plot(x+3,y+5,bcolor)
    
    Line(x+2,y+4,1,3,bcolor)
    Line(x+4,y+2,3,1,bcolor)
    Line(x+9,y+13,3,1,bcolor)
    Line(x+13,y+9,1,3,bcolor)
    
    ;
    LineXY(x+6,y+4,x+11,y+9,fcolor)
    LineXY(x+4,y+6,x+9,y+11,fcolor)
    
    LineXY(x+2,y+7,x+3,y+6,fcolor)
    LineXY(x+7,y+2,x+6,y+3,fcolor)
    LineXY(x+8,y+13,x+9,y+12,fcolor)
    LineXY(x+13,y+8,x+12,y+9,fcolor)
    
    Line(x+1,y+2,1,6,fcolor)
    Line(x+14,y+8,1,6,fcolor)
    Line(x+2,y+1,6,1,fcolor)
    Line(x+8,y+14,6,1,fcolor)
    
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(rt))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-width)/2
    ; 
    LineXY(x+2,y+12,x+12,y+2,bcolor)
    LineXY(x+2,y+13,x+13,y+2,bcolor)
    LineXY(x+3,y+13,x+13,y+3,bcolor)
    
    Plot(x+3,y+10,bcolor)
    Plot(x+10,y+3,bcolor)
    Plot(x+5,y+12,bcolor)
    Plot(x+12,y+5,bcolor)
    
    Line(x+2,y+9,1,3,bcolor)
    Line(x+9,y+2,3,1,bcolor)
    Line(x+4,y+13,3,1,bcolor)
    Line(x+13,y+4,1,3,bcolor)
    
    ;
    LineXY(x+4,y+9,x+9,y+4,fcolor)
    LineXY(x+6,y+11,x+11,y+6,fcolor)
    
    LineXY(x+2,y+8,x+3,y+9,fcolor)
    LineXY(x+8,y+2,x+9,y+3,fcolor)
    LineXY(x+6,y+12,x+7,y+13,fcolor)
    LineXY(x+12,y+6,x+13,y+7,fcolor)
    
    Line(x+1,y+8,1,6,fcolor)
    Line(x+8,y+1,6,1,fcolor)
    Line(x+2,y+14,6,1,fcolor)
    Line(x+14,y+2,1,6,fcolor)
    
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(lb))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-width)/2
    ; 
    LineXY(x+2,y+12,x+12,y+2,bcolor)
    LineXY(x+2,y+13,x+13,y+2,bcolor)
    LineXY(x+3,y+13,x+13,y+3,bcolor)
    
    Plot(x+3,y+10,bcolor)
    Plot(x+10,y+3,bcolor)
    Plot(x+5,y+12,bcolor)
    Plot(x+12,y+5,bcolor)
    
    Line(x+2,y+9,1,3,bcolor)
    Line(x+9,y+2,3,1,bcolor)
    Line(x+4,y+13,3,1,bcolor)
    Line(x+13,y+4,1,3,bcolor)
    
    ;
    LineXY(x+4,y+9,x+9,y+4,fcolor)
    LineXY(x+6,y+11,x+11,y+6,fcolor)
    
    LineXY(x+2,y+8,x+3,y+9,fcolor)
    LineXY(x+8,y+2,x+9,y+3,fcolor)
    LineXY(x+6,y+12,x+7,y+13,fcolor)
    LineXY(x+12,y+6,x+13,y+7,fcolor)
    
    Line(x+1,y+8,1,6,fcolor)
    Line(x+8,y+1,6,1,fcolor)
    Line(x+2,y+14,6,1,fcolor)
    Line(x+14,y+2,1,6,fcolor)
    
    StopDrawing()
  EndIf
  
  ; splitter
  If StartDrawing(CanvasOutput(left))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-height)/2
    y = (OutputHeight()-width)/2
    
    ; left                                                 
    DrawCursorSplitterLeft(x,y,width, bcolor, fcolor )
    Plot(x+8, y, fcolor ) : Line(x+8, y+1, 1, width-2, bcolor) : Plot(x+8, y+width-1, fcolor )                        ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
    Line(x + 9, y, 1, width, fcolor)                                                                                  ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    StopDrawing()
  EndIf
  If StartDrawing(CanvasOutput(left2))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-(height*2))/2
    y = (OutputHeight()-width)/2
    
    ; left2                                                 
    DrawCursorSplitterLeft(x,y,width, bcolor, fcolor )
    DrawCursorSplitterRight(x+height-1,y,width, bcolor, fcolor )
    StopDrawing()
  EndIf
  If StartDrawing(CanvasOutput(right2))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-(height*2))/2
    y = (OutputHeight()-width)/2
    
    ; right2                                                 
    DrawCursorSplitterLeft(x,y,width, bcolor, fcolor )
    DrawCursorSplitterRight(x+height-1,y,width, bcolor, fcolor )
    StopDrawing()
  EndIf
  If StartDrawing(CanvasOutput(right))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-height)/2
    y = (OutputHeight()-width)/2
    
    ; right                                                 
    Line(x, y, 1, width, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    Plot(x+1, y, fcolor ) : Line(x+1, y+1, 1, width-2, bcolor) : Plot(x+1, y+width-1, fcolor )                           ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
    DrawCursorSplitterRight(x,y,width, bcolor, fcolor )
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(c))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-(height*2))/2
    
    ; down2                                                 
    Box(x+6,y+5,4,4, fcolor)
    DrawCursorUp(x,y-2,width, bcolor, fcolor )
    DrawCursorDown(x,y+height-1,width, bcolor, fcolor )
    
    DrawCursorLeft(x-1,y-1,width, bcolor, fcolor )
    DrawCursorRight(x+7,y-1,width, bcolor, fcolor )
    Box(x+7,y+6,2,2, bcolor)
    
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(l))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-(height*2))/2
    y = (OutputHeight()-width)/2
    ; ver-size
    DrawCursorLeft(x-1,y,width, bcolor, fcolor )
    DrawCursorRight(x+height-2,y,width, bcolor, fcolor )
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(t))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-(height*2))/2
    ; hor-size
    DrawCursorUp(x,y-1,width, bcolor, fcolor )
    DrawCursorDown(x,y+height-2,width, bcolor, fcolor )
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(r))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    ;     x = (OutputWidth()-width)/2
    ;     y = (OutputHeight()-(height*2))/2
    ;     
    ;     ; down2                                                 
    ;     ;Box(x+6,y+5,4,4, fcolor)
    
    x = (OutputWidth()-(height*2))/2
    y = (OutputHeight()-width)/2
    
    DrawCursorLeft(x-1,y,width, bcolor, fcolor )
    DrawCursorRight(x+height-2,y,width, bcolor, fcolor )
    ;Box(x+6,y+7,2,2, bcolor)
    
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(b))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-(height*2))/2
    
    ; down2                                                 
    ; Box(x+6,y+5,4,4, fcolor)
    DrawCursorUp(x,y-1,width, bcolor, fcolor )
    DrawCursorDown(x,y+height-2,width, bcolor, fcolor )
    
    ;     x = (OutputWidth()-(height*2))/2
    ;     y = (OutputHeight()-width)/2
    ;     ;Box(x+6,y+7,2,2, bcolor)
    
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(up))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-height)/2
    
    ; up                                                 
    DrawUp(x, y, width, bcolor, fcolor)
    DrawCursorSplitterUp(x,y,width, bcolor, fcolor )
    Plot(x, y+8, fcolor ) : Line(x+1, y+8, width-2, 1, bcolor) : Plot(x+width-1, y+8, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
    Line(x, y + 9, width , 1, fcolor)                                                                                   ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(up2))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-(height*2))/2
    
    ; down2                                                 
    DrawCursorSplitterV(x,y,width,height, bcolor, fcolor )
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(down2))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-(height*2))/2
    
    ; down2                                                 
    DrawCursorSplitterV(x,y,width,height, bcolor, fcolor )
    StopDrawing()
  EndIf
  
  If StartDrawing(CanvasOutput(down))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    x = (OutputWidth()-width)/2
    y = (OutputHeight()-height)/2
    
    ; down                                                 
    Line(x, y, width, 1, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    Plot(x, y+1, fcolor ) : Line(x+1, y+1, width-2, 1, bcolor) : Plot(x+width-1, y+1, fcolor )                           ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
    DrawCursorSplitterDown(x,y,width, bcolor, fcolor )
    DrawDown(x, y, width, bcolor, fcolor)
    StopDrawing()
  EndIf
  
  
  If StartDrawing(CanvasOutput(Canvas_16))
    Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
    ;       img = CocoaMessage(0, 0, "NSCursor resizeUpCursor")
    ;       ;DrawImage(img, 0,0)
    width = 13
    Line(OutputWidth()/2-1, OutputHeight()/2-width/2, 1, width, fcolor)
    Line(OutputWidth()/2+1, OutputHeight()/2-width/2, 1, width, fcolor)
    
    Line(OutputWidth()/2-width/2, OutputHeight()/2-1, width, 1, fcolor)
    Line(OutputWidth()/2-width/2, OutputHeight()/2+1, width, 1, fcolor)
    
    Line(OutputWidth()/2, OutputHeight()/2-width/2, 1, width, bcolor)
    Line(OutputWidth()/2-width/2, OutputHeight()/2, width, 1, bcolor)
    StopDrawing()
  EndIf
  
  Repeat 
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -94Xx-48-v-----------
; EnableXP