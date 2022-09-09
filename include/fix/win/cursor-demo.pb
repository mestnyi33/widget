EnableExplicit

UsePNGImageDecoder()
DeclareModule Get
  Declare.s ClassName( handle.i )
EndDeclareModule
Module Get
  Procedure.s ClassName( handle.i )
    Protected Class$ = Space( 16 )
    GetClassName_( handle, @Class$, Len( Class$ ) )
    ProcedureReturn Class$
  EndProcedure
EndModule
;///
DeclareModule ID
  Declare.i Window( WindowID.i )
  Declare.i Gadget( GadgetID.i )
  Declare.i IsWindowID( handle.i )
  Declare.i GetWindowID( handle.i )
EndDeclareModule
Module ID
  Procedure.s ClassName( handle.i )
    Protected Class$ = Space( 16 )
    GetClassName_( handle, @Class$, Len( Class$ ) )
    ProcedureReturn Class$
  EndProcedure
  
  Procedure.i GetWindowID( handle.i ) ; Return the handle of the parent window from the handle
    ProcedureReturn GetAncestor_( handle, #GA_ROOT )
  EndProcedure
  
  Procedure.i IsWindowID( handle.i )
    If ClassName( handle ) = "PBWindow"
      ProcedureReturn 1
    EndIf
  EndProcedure
  
  Procedure.i Window( WindowID.i ) ; Return the id of the window from the window handle
    Protected Window = GetProp_( WindowID, "PB_WindowID" ) - 1
    If IsWindow( Window ) And WindowID( Window ) = WindowID
      ProcedureReturn Window
    EndIf
    ProcedureReturn - 1
  EndProcedure
  
  Procedure.i Gadget( GadgetID.i )  ; Return the id of the gadget from the gadget handle
    Protected gadget = GetProp_( GadgetID, "PB_ID" )
    If IsGadget( gadget ) And GadgetID( gadget ) = GadgetID
      ProcedureReturn gadget
    EndIf
    ProcedureReturn - 1
  EndProcedure
EndModule
;///
DeclareModule Mouse
  Declare.i Window( )
  Declare.i Gadget( WindowID )
EndDeclareModule
Module Mouse
  Procedure Window( )
    Protected Cursorpos.q, handle
    GetCursorPos_( @Cursorpos )
    handle = WindowFromPoint_( Cursorpos )
    ProcedureReturn GetAncestor_( handle, #GA_ROOT )
  EndProcedure
  
  Procedure Gadget( WindowID )
    Protected Cursorpos.q, handle, GadgetID
    GetCursorPos_( @Cursorpos )
    
    If WindowID
      GadgetID = WindowFromPoint_( Cursorpos )
      
      If IsGadget( ID::Gadget( GadgetID ) )
        handle = GadgetID
      Else
        ScreenToClient_( WindowID, @Cursorpos ) 
        handle = ChildWindowFromPoint_( WindowID, Cursorpos )
        
        ; spin-buttons
        If handle = GadgetID 
          If handle = WindowID
            ; in the window
            ProcedureReturn 0
          Else
            handle = GetWindow_( GadgetID, #GW_HWNDPREV )
          EndIf
        Else
          ; MDIGadget childrens
          ;           If IsWindow( IDWindow( GadgetID ) )
          ;             If handle = WindowID
          ;               ; in the window
          ;               ProcedureReturn 0
          ;             Else
          ;               ;;handle = GetParent_( handle )
          ;             EndIf
          ;           EndIf
        EndIf
      EndIf
      
      ProcedureReturn handle
    Else
      ProcedureReturn 0
    EndIf
  EndProcedure
EndModule
;///


If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png") = 0
  MessageRequester("Error",
                   "Loading of image World.png failed!",
                   #PB_MessageRequester_Error)
  End
EndIf


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

;
#MaskLeftMouseDown      = 1<<1
#MaskLeftMouseUp        = 1<<2
#MaskRightMouseDown     = 1<<3
#MaskRightMouseUp       = 1<<4
#MaskMouseMoved         = 1<<5
#MaskLeftMouseDragged   = 1<<6
#MaskRightMouseDragged  = 1<<7
#MaskMouseEntered       = 1<<9
#MaskMouseExited        = 1<<8
#MaskKeyDown            = 1<<10
#MaskKeyUp              = 1<<11
#MaskFlagsChanged       = 1<<12
#MaskAppKitDefined      = 1<<13
#MaskSystemDefined      = 1<<14
#MaskApplicationDefined = 1<<15
#MaskPeriodic           = 1<<16
#MaskCursorUpdate       = 1<<17
#MaskScrollWheel        = 1<<22
#MaskTabletPoint        = 1<<23
#MaskTabletProximity    = 1<<24

#MaskOtherMouseDown     = 1<<25
#MaskOtherMouseUp       = 1<<26
#MaskOtherMouseDragged  = 1<<27

#MaskEventTypeGesture   = 1<<29
#MaskEventTypeMagnify   = 1<<30
#MaskEventTypeSwipe     = 1<<31
#MaskEventTypeRotate    = 1<<18
#MaskEventTypeBeginGesture = 1<<19
#MaskEventTypeEndGesture   = 1<<20
#MaskEventTypeSmartMagnify = 1<<32
#MaskEventTypeQuickLook    = 1<<33

Global eventTap, mask = #MaskMouseEntered | #MaskMouseExited | #MaskMouseMoved | #MaskCursorUpdate |#MaskLeftMouseDown|#MaskLeftMouseUp|#MaskLeftMouseDragged

Structure cursor
  index.i
  ;*windowID
  ;*gadgetID
  *cursor
  ;button.b
  ;state.b
  change.b
EndStructure

Declare WinCallback(WindowID, Message, WParam, LParam)

Global *entered=-1, *pressed=-1;, *dragged=-1, *focused=-1, *setcallback
Macro EnteredGadget( ) : *entered : EndMacro
Macro PressedGadget( ) : *pressed : EndMacro
;   Macro DraggedGadget( ) : *dragged : EndMacro
;   Macro FocusedGadget( ) : *focused : EndMacro

Global OldProc
Declare Proc(hWnd, uMsg, wParam, lParam)

Procedure underGadget(NSWindow)
  If NSWindow
    Protected handle = Mouse::Gadget(NSWindow)
    If handle
      ProcedureReturn ID::Gadget(handle)
    EndIf
  EndIf
  
  ProcedureReturn - 1
EndProcedure

Procedure.i createCursor( ImageID.i, x.l = 0, y.l = 0 )
  Protected iCursor.ICONINFO
  iCursor\fIcon = #False
  iCursor\xHotspot = 1
  iCursor\yHotspot = 1
  iCursor\hbmColor = ImageID
  iCursor\hbmMask = ImageID
  ProcedureReturn CreateIconIndirect_(iCursor)
EndProcedure

Procedure setCursor( gadget, cursor, ImageID.i=0 )
  If IsGadget(gadget)
    Protected GadgetID = GadgetID(gadget)
    Protected *cursor.cursor = AllocateStructure(cursor)
    Protected NSWindow = ID::GetWindowID( GadgetID )
    *cursor\index = cursor
    
    If cursor >= 0
      Select cursor
        Case #PB_Cursor_Default   : *cursor\cursor = LoadCursor_(0,#IDC_ARROW)
        Case #PB_Cursor_IBeam     : *cursor\cursor = LoadCursor_(0,#IDC_IBEAM)
        Case #PB_Cursor_Cross     : *cursor\cursor = LoadCursor_(0,#IDC_CROSS)
        Case #PB_Cursor_Hand      : *cursor\cursor = LoadCursor_(0,#IDC_HAND)
        Case #PB_Cursor_UpDown    : *cursor\cursor = LoadCursor_(0,#IDC_SIZEWE)
        Case #PB_Cursor_LeftRight : *cursor\cursor = LoadCursor_(0,#IDC_SIZENS)
      EndSelect 
    Else
      If ImageID
        *cursor\cursor = createCursor(ImageID)
      EndIf
    EndIf
    
    SetGadgetData(gadget, *cursor)
    
    ;     OldProc = SetWindowLong_(GadgetID, #GWL_WNDPROC, @Proc())
    
    SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS | #WS_CLIPCHILDREN )
    SetWindowPos_( GadgetID, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
    
    If *cursor\cursor And GadgetID = mouse::Gadget(NSWindow)
      Debug 888
      ;SetClassLongPtr_(GadgetID, #GCL_HCURSOR, *cursor\cursor)
      SetCursor_( *cursor\cursor )
      *cursor\change = 1
      ProcedureReturn #True
    EndIf
    
  EndIf
EndProcedure

Procedure LoWord(value)
  ProcedureReturn value & $FFFF
EndProcedure

Procedure HiWord(value)
  ProcedureReturn value >> 16 & $FFFF
EndProcedure

Procedure Proc(hWnd, uMsg, wParam, lParam)
  Protected gadget =- 1
  Protected *cursor.cursor
  Protected result = 0
  
  Select uMsg
    Case #WM_LBUTTONDOWN
        PressedGadget() = underGadget(hWnd)
        
      Case #WM_LBUTTONUP
        gadget = underGadget(hWnd)
        
        If PressedGadget() >= 0 And 
           PressedGadget() <> gadget  
          
          *cursor.cursor = GetGadgetData(PressedGadget())
          If *cursor And
             *cursor\cursor And 
             *cursor\change = 1
            *cursor\change = 0
            Debug "p-"
            SetCursor_(LoadCursor_(0,#IDC_ARROW)) 
          EndIf
        EndIf
        
        If gadget >= 0 And 
           gadget <> PressedGadget()
          
          EnteredGadget() = gadget
          *cursor.cursor = GetGadgetData(gadget)
          If *cursor And
             *cursor\cursor
            *cursor\change = 1
            Debug "p+"
            SetCursor_(*cursor\cursor) 
          EndIf
        EndIf
        
        PressedGadget() =- 1
        
;       Case #WM_MOUSEMOVE
;         If PressedGadget() =- 1
;           gadget = underGadget(hWnd)
;           Debug gadget
;           ;
;           If EnteredGadget( ) <> gadget
;             If EnteredGadget( ) >= 0 
;               *cursor.cursor = GetGadgetData(EnteredGadget( ))
;               If *cursor And 
;                  *cursor\cursor And *cursor\change = 1
;                 *cursor\change = 0
;                 Debug "e-"
;                 SetCursor_(LoadCursor_(0,#IDC_ARROW)) 
;               EndIf
;             EndIf
;             
;             EnteredGadget( ) = gadget
;             
;             If EnteredGadget( ) >= 0 
;               *cursor.cursor = GetGadgetData(EnteredGadget( ))
;               If *cursor And
;                  *cursor\cursor And *cursor\change = 0
;                 *cursor\change = 1
;                 Debug "e+"
;                 SetCursor_(*cursor\cursor) 
;               EndIf
;             EndIf
;           EndIf
;         EndIf
;         
;         ; result = CallWindowProc_(OldProc, hWnd, uMsg, wParam, lParam)
   
  Case #WM_SETCURSOR
    Debug " -  #WM_SETCURSOR "+wParam +" "+ lParam
;       If IsGadget(EnteredGadget( ))
;         If GadgetType( EnteredGadget( )) = #PB_GadgetType_Splitter
;           result = CallWindowProc_(OldProc, hWnd, uMsg, wParam, lParam)
;         Else
;           ;Debug "#WM_SETCURSOR - " + EnteredGadget( )
; ;           *cursor.cursor = GetGadgetData(EnteredGadget( ))
; ;           If *cursor And
; ;              *cursor\cursor 
; ;             Debug "e++"
; ;             SetCursor_(*cursor\cursor) 
; ;           EndIf
;           result = 1
;         EndIf
;       EndIf
      
    
    If PressedGadget() =- 1
      gadget = underGadget(hWnd)
      Debug gadget
      ;
      If EnteredGadget( ) <> gadget
        If EnteredGadget( ) >= 0 
          *cursor.cursor = GetGadgetData(EnteredGadget( ))
          If *cursor And 
             *cursor\cursor And *cursor\change = 1
            *cursor\change = 0
            Debug "e-"
            SetCursor_(LoadCursor_(0,#IDC_ARROW)) 
          Else
              result = CallWindowProc_(OldProc, hWnd, uMsg, wParam, lParam)
          EndIf
        EndIf
        
        EnteredGadget( ) = gadget
        
        If EnteredGadget( ) >= 0 
          *cursor.cursor = GetGadgetData(EnteredGadget( ))
          If *cursor And
             *cursor\cursor And *cursor\change = 0
            *cursor\change = 1
            Debug "e+"
            SetCursor_(*cursor\cursor) 
          Else
              result = CallWindowProc_(OldProc, hWnd, uMsg, wParam, lParam)
          EndIf
        EndIf
      EndIf
    EndIf
    
    Default
      result = CallWindowProc_(OldProc, hWnd, uMsg, wParam, lParam)
  EndSelect
  
  ProcedureReturn result
EndProcedure



;-
Procedure WinCallback(WindowID, Message, WParam, LParam)
  Protected Result = #PB_ProcessPureBasicEvents
  
  Select Message
    Case #WM_SETCURSOR ; = 32
      Proc(WindowID, Message, WParam, LParam)
      
  EndSelect
  
  ProcedureReturn Result  
EndProcedure

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  ; Для виндовс чтобы приклепить гаджеты на место
  ; надо вызывать процедуру в конце создания всех гаджетов
  ; 
  Procedure ClipGadgetsCallBack( GadgetID, lParam )
    ; https://www.purebasic.fr/english/viewtopic.php?t=64799
    ; https://www.purebasic.fr/english/viewtopic.php?f=5&t=63915#p475798
    ; https://www.purebasic.fr/english/viewtopic.php?t=63915&start=15
    If GadgetID
      Protected Gadget = ID::Gadget(GadgetID)
      
      If IsGadget(Gadget)
        OldProc = SetWindowLong_(GadgetID, #GWL_WNDPROC, @Proc())
      EndIf
      ;       If IsGadget( Gadget ) And GadgetID = GadgetID( Gadget )
      ;         Debug "Gadget "+ Gadget +"  -  "+ GadgetID
      ;       Else
      ;         Debug "- Gadget   -  "+ GadgetID
      ;       EndIf
      
      If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
        If IsGadget( Gadget ) 
          Select GadgetType( Gadget )
            Case #PB_GadgetType_ComboBox
              Protected Height = GadgetHeight( Gadget )
              
              ;             ; Из-за бага когда устанавливаешь фоновый рисунок (например точки на кантейнер)
              ;             Case #PB_GadgetType_Container 
              ;               SetGadgetColor( Gadget, #PB_Gadget_BackColor, GetSysColor_( #COLOR_BTNFACE ))
              ;               
              ;             ; Для панел гаджета темный фон убирать
              ;             Case #PB_GadgetType_Panel 
              ;               If Not IsGadget( Gadget ) And (GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
              ;                 SetWindowLongPtr_(GadgetID, #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
              ;               EndIf
              ;               ; SetClassLongPtr_(GadgetID, #GCL_HBRBACKGROUND, GetStockObject_(#NULL_BRUSH))
              
          EndSelect
        EndIf
        
        SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS | #WS_CLIPCHILDREN )
        
        If Height
          ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height )
        EndIf
        
        SetWindowPos_( GadgetID, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
      EndIf
      
    EndIf
    
    ProcedureReturn GadgetID
  EndProcedure
CompilerEndIf


Procedure ClipGadgets( WindowID )
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    EnumChildWindows_( WindowID, @ClipGadgetsCallBack(), 0 )
  CompilerEndIf
EndProcedure


;   ProcedureC eventTapFunction(proxy, type, event, refcon)
;     Static *widget
;     Protected Point.CGPoint
;     Protected ContentView
;     Protected handle
;     Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
;     Protected *cursor.cursor = #Null
;     
;     If NSEvent
;       Protected NSWindow, gadget =- 1
;       NSWindow = Mouse::Window( ) 
;       ;NSWindow = CocoaMessage(0, NSEvent, "window")
;       
;       If type = #NSLeftMouseDown
;         PressedGadget() = underGadget(NSWindow)
;         
;       ElseIf type = #NSLeftMouseUp
;         gadget = underGadget(NSWindow)
;         
;         If PressedGadget() >= 0 And 
;            PressedGadget() <> gadget  
;           
;           *cursor.cursor = GetGadgetData(PressedGadget())
;           If *cursor And
;              *cursor\cursor And 
;              *cursor\change = 1
;             *cursor\change = 0
;             Debug "p-"
;             CocoaMessage(0, NSWindow, "enableCursorRects")
;             CocoaMessage(0, CocoaMessage(0, 0, "NSCursor arrowCursor"), "set") 
;           EndIf
;         EndIf
;         
;         If gadget >= 0 And 
;            gadget <> PressedGadget()
;           
;           EnteredGadget() = gadget
;           *cursor.cursor = GetGadgetData(gadget)
;           If *cursor And
;              *cursor\cursor
;             Debug "p+"
;             CocoaMessage(0, NSWindow, "disableCursorRects")
;             CocoaMessage(0, *cursor\cursor, "set") 
;             *cursor\change = 1
;           EndIf
;         EndIf
;         
;         PressedGadget() =- 1
;         
;       ElseIf type = #NSMouseMoved
;         gadget = underGadget(NSWindow)
;         
;         If EnteredGadget( ) <> gadget
;           If EnteredGadget( ) >= 0 
;             *cursor.cursor = GetGadgetData(EnteredGadget( ))
;             If *cursor And 
;                *cursor\cursor And 
;                *cursor\change = 1
;               *cursor\change = 0
;               Debug "e-"
;               CocoaMessage(0, NSWindow, "enableCursorRects")
;               CocoaMessage(0, CocoaMessage(0, 0, "NSCursor arrowCursor"), "set") 
;             EndIf
;           EndIf
;           
;           EnteredGadget( ) = gadget
;           
;           If EnteredGadget( ) >= 0 
;             *cursor.cursor = GetGadgetData(EnteredGadget( ))
;             If *cursor And
;                *cursor\cursor And 
;                *cursor\change = 0
;               *cursor\change = 1
;               Debug "e+"
;               CocoaMessage(0, NSWindow, "disableCursorRects")
;               CocoaMessage(0, *cursor\cursor, "set") 
;             EndIf
;           EndIf
;         EndIf
;         
;         ;       ElseIf type = #NSCursorUpdate
;         ;         Debug 999999
;       EndIf
;     EndIf           
;   EndProcedure
;   
;   #cghidEventTap = 0              ; Указывает, что отвод события размещается в точке, где системные события HID поступают на оконный сервер.
;   #cgSessionEventTap = 1          ; Указывает, что отвод события размещается в точке, где события системы HID и удаленного управления входят в сеанс входа в систему.
;   #cgAnnotatedSessionEventTap = 2 ; Указывает, что отвод события размещается в точке, где события сеанса были аннотированы для передачи в приложение.
;   
;   #headInsertEventTap = 0         ; Указывает, что новое касание события должно быть вставлено перед любым ранее существовавшим касанием события в том же месте.
;   #tailAppendEventTap = 1         ; Указывает, что новое касание события должно быть вставлено после любого ранее существовавшего касания события в том же месте
;   
;   eventTap = CGEventTapCreate_(#cgAnnotatedSessionEventTap, #headInsertEventTap, 1, mask, @eventTapFunction(), 0) 
;   If eventTap
;     CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopCommonModes")
;   EndIf

;///
;/// demo
;///
Define g1,g2
Procedure Resize_2( )
  Protected canvas = 2
  ResizeGadget( canvas, #PB_Ignore, #PB_Ignore, WindowWidth( EventWindow( )) - GadgetX( canvas )*2, WindowHeight( EventWindow( )) - GadgetY( canvas )*2 )
EndProcedure

Procedure Resize_3( )
  Protected canvas = 3
  ResizeGadget( canvas, #PB_Ignore, #PB_Ignore, WindowWidth( EventWindow( )) - GadgetX( canvas )*2, WindowHeight( EventWindow( )) - GadgetY( canvas )*2 )
EndProcedure


;/// first
OpenWindow(1, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
CanvasGadget(0, 240, 10, 60, 60, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus )
CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
ButtonGadget(100, 60,240,60,60,"")
g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
g2=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
SplitterGadget(111,10,240,60,60, g1,g2)

; If setCursor(111,#PB_Cursor_UpDown)
;   Debug "updown"           
; EndIf       

If setCursor(100,#PB_Cursor_Hand)
  Debug "setCursorHand"           
EndIf       

If setCursor(g1,#PB_Cursor_IBeam)
  Debug "setCursorIBeam"           
EndIf       

If setCursor(g2,#PB_Cursor_IBeam)
  Debug "setCursorIBeam"           
EndIf       

If setCursor(0, #PB_Default, ImageID(0))
  Debug "setCursorImage"           
EndIf       

If setCursor(1,#PB_Cursor_Hand)
  Debug "setCursorHand - " ;+CocoaMessage(0, 0, "NSCursor currentCursor")
EndIf       

If setCursor(11,#PB_Cursor_Cross)
  Debug "setCursorCross"           
EndIf       

ClipGadgets( UseGadgetList(0) )


;/// second
OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
g1=StringGadget(-1,0,0,0,0,"StringGadget")
g2=HyperLinkGadget(-1,0,0,0,0,"HyperLinkGadget", 0)
SplitterGadget(2, 10, 10, 200, 200, g1,g2)
BindEvent( #PB_Event_SizeWindow, @Resize_2(), 2 )

If setCursor(g1,#PB_Cursor_IBeam)
  Debug "setCursorIBeam"           
EndIf       

If setCursor(g2,#PB_Cursor_IBeam)
  Debug "setCursorIBeam"           
EndIf       

ClipGadgets( UseGadgetList(0) )


;/// third
OpenWindow(3, 450+50, 200+50, 220, 220, "window_3", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
g2=StringGadget(-1,0,0,0,0,"StringGadget")
SplitterGadget(3,10, 10, 200, 200, g1,g2)
BindEvent( #PB_Event_SizeWindow, @Resize_3( ), 3 )

If setCursor(g1,#PB_Cursor_IBeam)
  Debug "setCursorIBeam"           
EndIf       

If setCursor(g2,#PB_Cursor_IBeam)
  Debug "setCursorIBeam"           
EndIf       

ClipGadgets( UseGadgetList(0) )



Debug "currentCursor - ";+CocoaMessage(0, 0, "NSCursor currentCursor") ; CocoaMessage(0, 0, "NSCursor systemCursor") +" "+ 
SetWindowCallback(@WinCallback());, 0)

; OldProc = SetWindowLong_(GadgetID(0), #GWL_WNDPROC, @Proc())
; OldProc = SetWindowLong_(GadgetID(1), #GWL_WNDPROC, @Proc())

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      If EventGadget() = 0 And EventType() = #PB_EventType_LeftClick
      EndIf
  EndSelect
ForEver
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ------X------
; EnableXP