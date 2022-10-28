CompilerIf #PB_Compiler_IsMainFile
  DeclareModule constants
    Enumeration #PB_EventType_FirstCustomValue
      #PB_EventType_Drop
      #PB_EventType_CursorChange
      #PB_EventType_MouseWheelX
      #PB_EventType_MouseWheelY
    EndEnumeration
  EndDeclareModule
  Module constants
  EndModule
CompilerEndIf

XIncludeFile "id.pbi"
XIncludeFile "mouse.pbi"
XIncludeFile "parent.pbi"

DeclareModule Cursor
  Enumeration 
    #PB_Cursor_Default         ; = 0
    #PB_Cursor_Cross           ; = 1
    #PB_Cursor_IBeam           ; = 2
    #PB_Cursor_Hand            ; = 3
    #PB_Cursor_Busy            ; = 4
    #PB_Cursor_Denied          ; = 5
    #PB_Cursor_Arrows          ; = 6
    #PB_Cursor_LeftRight       ; = 7
    #PB_Cursor_UpDown          ; = 8
    #PB_Cursor_LeftUpRightDown ; = 9
    #PB_Cursor_LeftDownRightUp ; = 10
    #PB_Cursor_Invisible       ; = 11
    #PB_Cursor_Left
    #PB_Cursor_Right
    #PB_Cursor_Up
    #PB_Cursor_Down
    #PB_Cursor_Grab
    #PB_Cursor_Grabbing
    #PB_Cursor_Drag
    #PB_Cursor_Drop
    #PB_Cursor_VIBeam
  EndEnumeration
  
  UsePNGImageDecoder()
  
  Structure _s_cursor
    icursor.a
    *hcursor
    *windowID
  EndStructure
  
  Declare   isHiden()
  Declare.i Create(ImageID.i, x.l = 0, y.l = 0)
  Declare   Free(hCursor.i)
  Declare   Hide(state.b)
  Declare   Get()
  Declare   Change(Gadget.i, state.b )
  Declare   Set(Gadget.i, cursor.i)
EndDeclareModule
Module Cursor 
  Global OldProc
  Declare Proc(hWnd, uMsg, wParam, lParam)
  
  Procedure   Free(hCursor.i)
    ProcedureReturn DestroyCursor_( hCursor )
  EndProcedure
  
  Procedure   isHiden()
    ProcedureReturn 0
  EndProcedure
  
  Procedure   Hide(state.b)
    ProcedureReturn ShowCursor_(#True)
  EndProcedure
  
  Procedure.i Create(ImageID.i, x.l = 0, y.l = 0)
    Protected *ic, ico.ICONINFO
    ico\fIcon = 0
    ico\xHotspot = x 
    ico\yHotspot = y 
    ico\hbmMask = ImageID
    ico\hbmColor = ImageID
    *ic = CreateIconIndirect_( ico ) : If Not *ic : *ic = ImageID : EndIf
    ProcedureReturn *ic
  EndProcedure
  
  Procedure Change( Gadget.i, state.b )
    CompilerIf #PB_Compiler_IsMainFile
      Debug "changeCursor"
    CompilerEndIf
    
    Protected *cursor._s_cursor = GetProp_(GadgetID(Gadget), "__cursor") ; GetGadgetData(EnteredGadget())
    If *cursor And 
       *cursor\hcursor  
      
      ; reset
      If state = 0 
        ; SetClassLongPtr_( *cursor\windowID, #GCL_HCURSOR, LoadCursor_(0,#IDC_ARROW) )
        SetCursor_( LoadCursor_(0,#IDC_ARROW) )
      EndIf
      
      ; set
      If state = 1 
        ; SetClassLongPtr_( *cursor\windowID, #GCL_HCURSOR, *cursor\hcursor )
        ; SetClassLongPtr_( GadgetID( gadget ), #GCL_HCURSOR, *cursor\hcursor )
        SetCursor_( *cursor\hcursor )
      EndIf
    EndIf
    
  EndProcedure
  
  Macro GadgetMouseX(_canvas_, _mode_ = #PB_Gadget_ScreenCoordinate)
    ; GetGadgetAttribute(_canvas_, #PB_Canvas_MouseX)
    DesktopMouseX() - GadgetX(_canvas_, _mode_)
    ; WindowMouseX(window) - GadgetX(_canvas_, #PB_Gadget_WindowCoordinate)  
  EndMacro
  Macro GadgetMouseY(_canvas_, _mode_ = #PB_Gadget_ScreenCoordinate)
    ; GetGadgetAttribute(_canvas_, #PB_Canvas_MouseY)
    DesktopMouseY() - GadgetY(_canvas_, _mode_)
    ; WindowMouseY(window) - GadgetY(_canvas_, #PB_Gadget_WindowCoordinate)
  EndMacro
  Global *dragged=-1, *entered=-1, *focused=-1, *pressed=-1, *setcallback
  
  Macro DraggedGadget() : *dragged : EndMacro
  Macro EnteredGadget() : *entered : EndMacro
  Macro FocusedGadget() : *focused : EndMacro
  Macro PressedGadget() : *pressed : EndMacro
  
  DraggedGadget() =- 1 
  EnteredGadget() =- 1 
  PressedGadget() =- 1 
  FocusedGadget() =- 1 
  #NSLeftMouseDown = #WM_LBUTTONDOWN
  #NSLeftMouseUp = #WM_LBUTTONUP 
  #NSScrollWheel = #WM_MOUSEWHEEL
  
  Procedure Events();gadget,eventtype)
    Select EventType()
      Case #PB_EventType_MouseEnter
        Debug 444
        ;  PostEvent(#PB_Event_Gadget, EventWindow(), EnteredGadget, constants::#PB_EventType_CursorChange, 1)
        Cursor::Change(EventGadget(), 1 )
          
      Case #PB_EventType_MouseLeave
        Debug 555
        Cursor::Change(EventGadget(), 0 )
          
        ;  PostEvent(#PB_Event_Gadget, EventWindow(), EnteredGadget, constants::#PB_EventType_CursorChange, 0)
    EndSelect
    

    ;Debug ""+gadget +" "+ type
  EndProcedure
  
  Procedure  eventTapFunction(eType, refcon)
    Protected Point.Point
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
              CallFunctionFast(refcon, EnteredGadget(), constants::#PB_EventType_Drop)
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
            
            CallFunctionFast(refcon, EnteredGadget() , #PB_EventType_MouseLeave)
          EndIf
          
          EnteredGadget() = gadget
          
          If EnteredGadget() >= 0 ;And GadgetType(EnteredGadget()) = #PB_GadgetType_Canvas
            If Not MouseDrag
              Cursor::change(EnteredGadget(), 1)
            EndIf
            
            CallFunctionFast(refcon, EnteredGadget(), #PB_EventType_MouseEnter)
          EndIf
        Else
          ; mouse drag start
          If MouseDrag > 0
            If EnteredGadget() >= 0 And
               DraggedGadget() <> PressedGadget()
              DraggedGadget() = PressedGadget()
              CallFunctionFast(refcon, PressedGadget(), #PB_EventType_DragStart)
              DeltaX = GadgetX(PressedGadget()) 
              DeltaY = GadgetY(PressedGadget())
            EndIf
          EndIf
          
          If MouseDrag And EnteredGadget() <> PressedGadget()
            CallFunctionFast(refcon, PressedGadget(), #PB_EventType_MouseMove)
          EndIf
          
          If EnteredGadget() >= 0
            CallFunctionFast(refcon, EnteredGadget(), #PB_EventType_MouseMove)
            
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
              CallFunctionFast(refcon, FocusedGadget(), #PB_EventType_Focus)
            EndIf
          EndIf
          
          If FocusedGadget() >= 0 And 
             FocusedGadget() <> PressedGadget()
            CallFunctionFast(refcon, FocusedGadget(), #PB_EventType_LostFocus)
            
            FocusedGadget() = PressedGadget()
            CallFunctionFast(refcon, FocusedGadget(), #PB_EventType_Focus)
          EndIf
          
          CallFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftButtonDown)
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
          CallFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftButtonUp)
          
          ;           If LeftDoubleClick
          ;             CallFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftDoubleClick)
          ;           Else
          ;             If PressedGadget() <> DraggedGadget()
          ;               If PressedGadget() >= 0 And EnteredID = GadgetID(PressedGadget())
          ;                 CallFunctionFast(refcon, PressedGadget(), #PB_EventType_LeftClick)
          ;               EndIf
          ;             EndIf
          ;           EndIf
        EndIf
        
        ; PressedGadget() =- 1
        DraggedGadget() =- 1
      EndIf
      
      ;         ;
      ;         If eType = #PB_EventType_LeftDoubleClick
      ;           CallFunctionFast(refcon, EnteredGadget(), #PB_EventType_LeftDoubleClick)
      ;         EndIf
      
      If eType = #NSScrollWheel
        Protected NSEvent ;= CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
        
        If NSEvent
          Protected scrollX ;= CocoaMessage(0, NSEvent, "scrollingDeltaX")
          Protected scrollY ;= CocoaMessage(0, NSEvent, "scrollingDeltaY")
          
          If scrollX And Not scrollY
            ; Debug "X - scroll"
            If EnteredGadget() >= 0
              CompilerIf Defined(constants::PB_EventType_MouseWheelY, #PB_Constant) 
                CallFunctionFast(refcon, EnteredGadget(), constants::#PB_EventType_MouseWheelX, scrollX)
              CompilerEndIf
            EndIf
          EndIf
          
          If scrollY And Not scrollX
            ; Debug "Y - scroll"
            If EnteredGadget() >= 0
              CompilerIf Defined(constants::PB_EventType_MouseWheelX, #PB_Constant) 
                CallFunctionFast(refcon, EnteredGadget(), constants::#PB_EventType_MouseWheelY, scrollY)
              CompilerEndIf
            EndIf
          EndIf
        EndIf
      EndIf
      
      
      ;           If eType = #PB_EventType_Resize
      ;             ; CallFunctionFast(refcon, EventGadget(), #PB_EventType_Resize)
      ;           EndIf
      ;           CompilerIf Defined(PB_EventType_Repaint, #PB_Constant) And Defined(constants, #PB_Module)
      ;             If eType = #PB_EventType_Repaint
      ;               CallFunctionFast(refcon, EventGadget(), #PB_EventType_Repaint)
      ;             EndIf
      ;           CompilerEndIf
      ;           
    EndIf
    
  EndProcedure
  
  Procedure Proc(hWnd, uMsg, wParam, lParam)
     
    ; Debug ID::ClassName( wParam)
    Select uMsg
      ; Case #WM_MOUSEMOVE
        ; eventTapFunction(uMsg, @Events())
        
      Case #WM_SETCURSOR
        ; Debug " -  #WM_SETCURSOR "+wParam +" "+ lParam
        Protected *cursor._s_cursor = GetProp_(wParam, "__cursor")
        If *cursor
          SetCursor_( *cursor\hcursor )
        EndIf
        
      Default
        result = CallWindowProc_(OldProc, hWnd, uMsg, wParam, lParam)
    EndSelect
    
    ProcedureReturn result
  EndProcedure
  
  Procedure WindowCallback(hWnd, uMsg, wParam, lParam) 
    Select uMsg 
      Case #WM_MOUSEMOVE
         eventTapFunction(uMsg, @Events())
       
      Case #WM_SETCURSOR
        ;Debug "#WM_SETCURSOR"
        
        Result  = #PB_ProcessPureBasicEvents
      Default 
        Result  = #PB_ProcessPureBasicEvents
    EndSelect 
    ProcedureReturn Result 
  EndProcedure 
  
  ;SetWindowCallback(@WindowCallback());,1)
  
  Procedure Set(Gadget.i, cursor.i)
    If Gadget >= 0
      Protected *cursor._s_cursor
      Protected GadgetID = GadgetID(Gadget)
      CompilerIf #PB_Compiler_IsMainFile
        Debug "setCursor"
      CompilerEndIf
      
      *cursor = GetProp_(GadgetID, "__cursor")
      
      If Not *cursor
        *cursor = AllocateStructure(_s_cursor)
        *cursor\windowID = ID::GetWindowID(GadgetID)
        SetProp_(GadgetID, "__cursor", *cursor) 
      EndIf
      
      If *cursor\icursor <> cursor
        *cursor\icursor = cursor
        
        If cursor >= 0 And cursor <= 255
          Select cursor
            Case #PB_Cursor_Default   : *cursor\hcursor = LoadCursor_(0,#IDC_ARROW)
            Case #PB_Cursor_IBeam     : *cursor\hcursor = LoadCursor_(0,#IDC_IBEAM)
              
            Case #PB_Cursor_Cross     : *cursor\hcursor = LoadCursor_(0,#IDC_CROSS)
            Case #PB_Cursor_Hand      : *cursor\hcursor = LoadCursor_(0,#IDC_HAND)
              
            Case #PB_Cursor_UpDown    : *cursor\hcursor = LoadCursor_(0,#IDC_SIZEWE)
            Case #PB_Cursor_LeftRight : *cursor\hcursor = LoadCursor_(0,#IDC_SIZENS)
              
            Case #PB_Cursor_Drag      : *cursor\hcursor = LoadCursor_(0,#IDC_ARROW)
            Case #PB_Cursor_Drop      : *cursor\hcursor = LoadCursor_(0,#IDC_ARROW)
            Case #PB_Cursor_Denied    : *cursor\hcursor = LoadCursor_(0,#IDC_ARROW)
              
            Case #PB_Cursor_Grab      : *cursor\hcursor = LoadCursor_(0,#IDC_ARROW)
            Case #PB_Cursor_Grabbing  : *cursor\hcursor = LoadCursor_(0,#IDC_ARROW)
              
            Case #PB_Cursor_Left      : *cursor\hcursor = LoadCursor_(0,#IDC_ARROW)
            Case #PB_Cursor_Right     : *cursor\hcursor = LoadCursor_(0,#IDC_ARROW)
              
            Case #PB_Cursor_Up        : *cursor\hcursor = LoadCursor_(0,#IDC_ARROW)
            Case #PB_Cursor_Down      : *cursor\hcursor = LoadCursor_(0,#IDC_ARROW)
          EndSelect 
        Else
          If cursor
            *cursor\hcursor = Create(cursor)
          EndIf
        EndIf
      EndIf
      
;       SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS | #WS_CLIPCHILDREN )
;       SetWindowPos_( GadgetID, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
      
      OldProc = SetWindowLong_(GadgetID, #GWL_WNDPROC, @Proc())
      BindGadgetEvent(Gadget, @Events())
      
      If *cursor\hcursor And GadgetID = mouse::Gadget(*cursor\windowID)
        Change( Gadget, 1 )
        ProcedureReturn #True
      EndIf
    EndIf
  EndProcedure
  
  Procedure   Get()
    Protected result.i, currentSystemCursor
    
    If isHiden()
      result = #PB_Cursor_Invisible
    Else
      Select GetCursor_()
        Case LoadCursor_(0,#IDC_ARROW) : result = #PB_Cursor_Default
        Case LoadCursor_(0,#IDC_IBEAM) : result = #PB_Cursor_IBeam
          
        Case LoadCursor_(0,#IDC_ARROW) : result = #PB_Cursor_Drop
        Case LoadCursor_(0,#IDC_ARROW) : result = #PB_Cursor_Drag
        Case LoadCursor_(0,#IDC_ARROW) : result = #PB_Cursor_Denied
          
        Case LoadCursor_(0,#IDC_CROSS) : result = #PB_Cursor_Cross
        Case LoadCursor_(0,#IDC_HAND) : result = #PB_Cursor_Hand
        Case LoadCursor_(0,#IDC_ARROW) : result = #PB_Cursor_Grab
        Case LoadCursor_(0,#IDC_ARROW) : result = #PB_Cursor_Grabbing
          
        Case LoadCursor_(0,#IDC_ARROW) : result = #PB_Cursor_Up
        Case LoadCursor_(0,#IDC_ARROW) : result = #PB_Cursor_Down
        Case LoadCursor_(0,#IDC_SIZEWE) : result = #PB_Cursor_UpDown
          
        Case LoadCursor_(0,#IDC_ARROW) : result = #PB_Cursor_Left
        Case LoadCursor_(0,#IDC_ARROW) : result = #PB_Cursor_Right
        Case LoadCursor_(0,#IDC_SIZENS) : result = #PB_Cursor_LeftRight
      EndSelect 
    EndIf
    
    ProcedureReturn result
  EndProcedure
  
  ;       DataSection
  ;         cross:
  ;         ;IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/macOSBigSur/cross.png"
  ;         IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/cross1.png"
  ;         cross_end:
  ;         
  ;         hand:
  ;         IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/macOSBigSur/hand2.png"
  ;         hand_end:
  ;         
  ;         move:
  ;         IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/macOSBigSur/hand1.png"
  ;         move_end:
  ;         
  ;       EndDataSection
EndModule   

;-\\ example
CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "ClipGadgets.pbi"
  UseModule constants
  ;UseModule events
  
  Define event
  Define g1,g2
  
  Procedure   DrawCanvasBack(Gadget, color)
    If GadgetType(Gadget) = #PB_GadgetType_Canvas
      StartDrawing(CanvasOutput(Gadget))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,0,OutputWidth(), OutputHeight(), color)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure   DrawCanvasFrame(Gadget, color)
    If GadgetType(Gadget) = #PB_GadgetType_Canvas
      StartDrawing(CanvasOutput(Gadget))
      If GetGadgetState(Gadget)
        DrawImage(0,0, GetGadgetState(Gadget))
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
        deltax = GadgetMouseX(eventobject, #PB_Gadget_WindowCoordinate)
        deltay = GadgetMouseY(eventobject, #PB_Gadget_WindowCoordinate)
        Debug ""+eventobject + " #PB_EventType_DragStart " + "x="+ deltax +" y="+ deltay
        
      Case #PB_EventType_Drop
        dropx = GadgetMouseX(eventobject, #PB_Gadget_ScreenCoordinate)
        dropy = GadgetMouseY(eventobject, #PB_Gadget_ScreenCoordinate)
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
        ;         If DraggedGadget() = 1
        ;           Debug ""+eventobject + " #PB_EventType_MouseMove " 
        ;           ResizeGadget(DraggedGadget(), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
        ;         EndIf
        ;         ;         If DraggedGadget() = 0
        ;         ;           ResizeGadget(DraggedGadget(), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
        ;         ;         EndIf
        
    EndSelect
  EndProcedure
  
  Procedure OpenWindow_(window, x,y,width,height, title.s, flag=0)
    Protected result = OpenWindow(window, x,y,width,height, title.s, flag|#PB_Window_SizeGadget)
    If window >= 0
      WindowID = WindowID(window)
    Else
      WindowID = result
    EndIf
    ;Debug 77
    ;CocoaMessage(0, WindowID, "disableCursorRects")
    ProcedureReturn result
  EndProcedure
  
  Macro OpenWindow(window, x,y,width,height, title, flag=0)
    OpenWindow_(window, x,y,width,height, title, flag)
  EndMacro
  
  ;events::SetCallback(@EventHandler())
  ;/// first
  OpenWindow(1, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
  CanvasGadget(0, 240, 10, 60, 60, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  ButtonGadget(100, 60,240,60,60,"")
  g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  g2=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  SplitterGadget(111,10,240,60,60, g1,g2)
  
  ; If Set((111),#PB_Cursor_UpDown)
  ;   Debug "updown"           
  ; EndIf       
  
  If cursor::Set((100),#PB_Cursor_Hand)
    Debug "setCursorHand"           
  EndIf       
  
  If cursor::Set((g1),#PB_Cursor_IBeam)
    Debug "setCursorIBeam"           
  EndIf       
  
  If cursor::Set((g2),#PB_Cursor_IBeam)
    Debug "setCursorIBeam"           
  EndIf       
  
  If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png") = 0
    MessageRequester("Error",
                     "Loading of image World.png failed!",
                     #PB_MessageRequester_Error)
    End
  EndIf
  If cursor::Set((0), ImageID(0))
    Debug "setCursorImage"           
  EndIf       
  
  If cursor::Set((1),#PB_Cursor_Hand)
    Debug "setCursorHand - " ;+CocoaMessage(0, 0, "NSCursor currentCursor")
  EndIf       
  
  If cursor::Set((11),#PB_Cursor_Cross)
    Debug "setCursorCross"           
  EndIf       
  
  
  ClipGadgets(UseGadgetList(0))
  ;/// second
  OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  g1=StringGadget(-1,0,0,0,0,"StringGadget")
  g2=HyperLinkGadget(-1,0,0,0,0,"HyperLinkGadget", 0)
  SplitterGadget(2, 10, 10, 200, 200, g1,g2)
  BindEvent(#PB_Event_SizeWindow, @Resize_2(), 2)
  
  ;   If cursor::Set((g1),#PB_Cursor_IBeam)
  ;     Debug "setCursorIBeam"           
  ;   EndIf       
  ;   
  ;   If cursor::Set((g2),#PB_Cursor_Hand)
  ;     Debug "setCursorHand"           
  ;   EndIf       
  ;   
  ;   If cursor::Set((2),#PB_Cursor_UpDown)
  ;     Debug "setCursorHand"           
  ;   EndIf       
  
  
  ClipGadgets(UseGadgetList(0))
  ;/// third
  OpenWindow(3, 450+50, 200+50, 220, 220, "window_3", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  g2=StringGadget(-1,0,0,0,0,"StringGadget")
  SplitterGadget(3,10, 10, 200, 200, g1,g2)
  BindEvent(#PB_Event_SizeWindow, @Resize_3(), 3)
  
  If cursor::Set((g1),#PB_Cursor_IBeam)
    Debug "setCursorIBeam"           
  EndIf       
  
  ;   If cursor::Set((g2),#PB_Cursor_IBeam)
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
  
  Cursor::Set((left2), Cursor::#PB_Cursor_LeftRight ) 
  Cursor::Set((right2), Cursor::#PB_Cursor_LeftRight ) 
  Cursor::Set((lt), Cursor::#PB_Cursor_LeftUpRightDown ) 
  Cursor::Set((rb), Cursor::#PB_Cursor_LeftUpRightDown ) 
  Cursor::Set((up2), Cursor::#PB_Cursor_UpDown ) 
  Cursor::Set((down2), Cursor::#PB_Cursor_UpDown ) 
  Cursor::Set((rt), Cursor::#PB_Cursor_LeftDownRightUp ) 
  Cursor::Set((lb), Cursor::#PB_Cursor_LeftDownRightUp ) 
  Cursor::Set((left), Cursor::#PB_Cursor_Left ) 
  Cursor::Set((up), Cursor::#PB_Cursor_Up ) 
  Cursor::Set((right), Cursor::#PB_Cursor_Right ) 
  Cursor::Set((down), Cursor::#PB_Cursor_Down ) 
  Cursor::Set((c), Cursor::#PB_Cursor_Up ) 
  Cursor::Set((Canvas_16), Cursor::#PB_Cursor_Cross ) 
  Cursor::Set((Canvas_0), Cursor::#PB_Cursor_Drag ) 
  Cursor::Set((Canvas_32), Cursor::#PB_Cursor_Denied ) 
  Cursor::Set((Canvas_192), Cursor::#PB_Cursor_Drop ) 
  
  ClipGadgets(UseGadgetList(0))
  ;-
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
    ;Debug width
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
  
  Define EnteredGadget =- 1
  Define LeavedGadget =- 1 
  Define buttons = 0
  
  Repeat 
    event = WaitWindowEvent()
    EnteredGadget = ID::Gadget(Mouse::Gadget(Mouse::Window()))
    
    If LeavedGadget <> EnteredGadget And buttons = 0
      ; Debug  CocoaMessage(0, CocoaMessage(0,0,"NSApplication sharedApplication"), "NSEvent")
      
      If LeavedGadget >= 0
        ; Debug GetGadgetAttribute(LeavedGadget, #PB_Canvas_Buttons)
        EventHandler(LeavedGadget, #PB_EventType_MouseLeave, 0)
        ;Cursor::Change(LeavedGadget, 0 )
        PostEvent(#PB_Event_Gadget, EventWindow(), LeavedGadget, #PB_EventType_CursorChange, 0)
      EndIf
      
      If EnteredGadget >= 0
        ; Debug GetGadgetAttribute(EnteredGadget, #PB_Canvas_Buttons)
        EventHandler(EnteredGadget, #PB_EventType_MouseEnter, 1)
        ;Cursor::Change(EnteredGadget, 1 )
        PostEvent(#PB_Event_Gadget, EventWindow(), EnteredGadget, #PB_EventType_CursorChange, 1)
      EndIf
      LeavedGadget = EnteredGadget
    EndIf
    
    If event = #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_CursorChange
          ;Cursor::Change(EventGadget(), EventData() )
          
        Case #PB_EventType_LeftButtonDown
          buttons = 1
          
        Case #PB_EventType_LeftButtonUp
          buttons = 0
      EndSelect
    EndIf
    
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 1295
; FirstLine = 1265
; Folding = -------------------------
; EnableXP