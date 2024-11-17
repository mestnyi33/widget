CompilerIf #PB_Compiler_IsMainFile
  ;   UseModule constants
  ;   ;UseModule events
  ;   
  Define event
  Define g1,g2
  
  Procedure Resize_2()
    Protected canvas = 2
    ResizeGadget(canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(canvas)*2, WindowHeight(EventWindow()) - GadgetY(canvas)*2)
  EndProcedure
  
  Procedure Resize_3()
    Protected canvas = 3
    ResizeGadget(canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(canvas)*2, WindowHeight(EventWindow()) - GadgetY(canvas)*2)
  EndProcedure
  
  Procedure EventHandler(eventobject, eventtype, eventdata)
    ;     Protected window = EventWindow()
    ;     Protected dropx, dropy
    ;     Static deltax, deltay
    ;     
    ;     Select eventtype
    ;       Case #PB_EventType_MouseWheelX
    ;         Debug ""+eventobject + " #PB_EventType_MouseWheelX " +eventdata
    ;         
    ;       Case #PB_EventType_MouseWheelY
    ;         Debug ""+eventobject + " #PB_EventType_MouseWheelY " +eventdata
    ;         
    ;       Case #PB_EventType_DragStart
    ;         deltax = events::GadgetMouseX(eventobject, #PB_Gadget_WindowCoordinate)
    ;         deltay = events::GadgetMouseY(eventobject, #PB_Gadget_WindowCoordinate)
    ;         Debug ""+eventobject + " #PB_EventType_DragStart " + "x="+ deltax +" y="+ deltay
    ;         
    ;       Case #PB_EventType_Drop
    ;         dropx = events::GadgetMouseX(eventobject, #PB_Gadget_ScreenCoordinate)
    ;         dropy = events::GadgetMouseY(eventobject, #PB_Gadget_ScreenCoordinate)
    ;         Debug ""+eventobject + " #PB_EventType_Drop " + "x="+ dropx +" y="+ dropy
    ;         
    ;       Case #PB_EventType_Focus
    ;         Debug ""+eventobject + " #PB_EventType_Focus " 
    ;         events::DrawCanvasBack(eventobject, $FFA7A4)
    ;         events::DrawCanvasFrameWidget(eventobject, $2C70F5)
    ;         
    ;       Case #PB_EventType_LostFocus
    ;         Debug ""+eventobject + " #PB_EventType_LostFocus " 
    ;         events::DrawCanvasBack(eventobject, $FFFFFF)
    ;         
    ;       Case #PB_EventType_LeftButtonDown
    ;         Debug ""+eventobject + " #PB_EventType_LeftButtonDown " 
    ;         
    ;       Case #PB_EventType_LeftButtonUp
    ;         Debug ""+eventobject + " #PB_EventType_LeftButtonUp " 
    ;         
    ;       Case #PB_EventType_LeftClick
    ;         Debug ""+eventobject + " #PB_EventType_LeftClick " 
    ;         
    ;       Case #PB_EventType_LeftDoubleClick
    ;         Debug ""+eventobject + " #PB_EventType_LeftDoubleClick " 
    ;         
    ;       Case #PB_EventType_MouseEnter
    ;         Debug ""+eventobject + " #PB_EventType_MouseEnter " ;+ CocoaMessage(0, WindowID(window), "isActive") 
    ;         events::DrawCanvasFrameWidget(eventobject, $2C70F5)
    ;         
    ;       Case #PB_EventType_MouseLeave
    ;         Debug ""+eventobject + " #PB_EventType_MouseLeave "
    ;         events::DrawCanvasFrameWidget(eventobject, 0)
    ;         
    ;       Case #PB_EventType_Resize
    ;         Debug ""+eventobject + " #PB_EventType_Resize " 
    ;         
    ;       Case #PB_EventType_MouseMove
    ;         If events::DraggedGadget() = 1
    ;           Debug ""+eventobject + " #PB_EventType_MouseMove " 
    ;           ResizeGadget(events::DraggedGadget(), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
    ;         EndIf
    ;         ;         If events::DraggedGadget() = 0
    ;         ;           ResizeGadget(events::DraggedGadget(), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
    ;         ;         EndIf
    ;         
    ;     EndSelect
  EndProcedure
  
  Procedure Window1Callback(hWnd, uMsg, wParam, lParam) 
    Select uMsg 
      Case #WM_CREATE
        Debug "#WM_CREATE"
      
      Case #WM_CLOSE 
        Debug "#WM_CLOSE"
        DestroyWindow_(hWnd) 
        
      Case #WM_DESTROY 
        PostQuitMessage_(0) 
        Result  = 0 
        
      Default 
        Result  = #PB_ProcessPureBasicEvents
    EndSelect 
    ProcedureReturn Result 
  EndProcedure 
  
  Procedure Window1Callback2(hWnd, uMsg, wParam, lParam) 
    Select uMsg 
      Case #WM_CREATE
        Debug "2#WM_CREATE"
      
      Case #WM_CLOSE 
        Debug "2#WM_CLOSE"
        DestroyWindow_(hWnd) 
        
      Case #WM_DESTROY 
        PostQuitMessage_(0) 
        Result  = 0 
        
      Default 
        Result  = #PB_ProcessPureBasicEvents
    EndSelect 
    ProcedureReturn Result 
  EndProcedure 
  
  Procedure OpenWindow_(window, x,y,width,height, title.s, flag=0)
    Protected result = OpenWindow(window, x,y,width,height, title.s, flag)
    If window >= 0
      WindowID = WindowID(window)
    Else
      WindowID = result
    EndIf
    Debug "open - "+WindowID
    ;CocoaMessage(0, WindowID, "disableCursorRects")
    ProcedureReturn result
  EndProcedure
  
  Macro OpenWindow(window, x,y,width,height, title, flag=0)
    OpenWindow_(window, x,y,width,height, title, flag)
  EndMacro
  
  
  SetWindowCallback(@Window1Callback());,1)
  SetWindowCallback(@Window1Callback2());,1)
  
  ;;events::SetCallback(@EventHandler())
  ;/// first
  OpenWindow(1, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
  CanvasGadget(0, 240, 10, 60, 60, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  ButtonGadget(100, 60,240,60,60,"")
  g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  g2=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  SplitterGadget(111,10,240,60,60, g1,g2)
  
  ;   ; If setCursor(GadgetID(111),#PB_Cursor_UpDown)
  ;   ;   Debug "updown"           
  ;   ; EndIf       
  ;   
  ;   If cursor::setCursor(GadgetID(100),#PB_Cursor_Hand)
  ;     Debug "setCursorHand"           
  ;   EndIf       
  ;   
  ;   If cursor::setCursor(GadgetID(g1),#PB_Cursor_IBeam)
  ;     Debug "setCursorIBeam"           
  ;   EndIf       
  ;   
  ;   If cursor::setCursor(GadgetID(g2),#PB_Cursor_IBeam)
  ;     Debug "setCursorIBeam"           
  ;   EndIf       
  ;   
  ;   If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png") = 0
  ;     MessageRequester("Error",
  ;                      "Loading of image World.png failed!",
  ;                      #PB_MessageRequester_Error)
  ;     End
  ;   EndIf
  ;   If cursor::setCursor(GadgetID(0), #PB_Default, ImageID(0))
  ;     Debug "setCursorImage"           
  ;   EndIf       
  ;   
  ;   If cursor::setCursor(GadgetID(1),#PB_Cursor_Hand)
  ;     Debug "setCursorHand - " ;+CocoaMessage(0, 0, "NSCursor currentCursor")
  ;   EndIf       
  ;   
  ;   If cursor::setCursor(GadgetID(11),#PB_Cursor_Cross)
  ;     Debug "setCursorCross"           
  ;   EndIf       
  ;   
  
  
  ;/// second
  OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  g1=StringGadget(-1,0,0,0,0,"StringGadget")
  g2=HyperLinkGadget(-1,0,0,0,0,"HyperLinkGadget", 0)
  SplitterGadget(2, 10, 10, 200, 200, g1,g2)
  BindEvent(#PB_Event_SizeWindow, @Resize_2(), 2)
  
  ;   If cursor::setCursor(GadgetID(g1),#PB_Cursor_IBeam)
  ;     Debug "setCursorIBeam"           
  ;   EndIf       
  ;   
  ;   If cursor::setCursor(GadgetID(g2),#PB_Cursor_Hand)
  ;     Debug "setCursorHand"           
  ;   EndIf       
  ;   
  ;   If cursor::setCursor(GadgetID(2),#PB_Cursor_UpDown)
  ;     Debug "setCursorHand"           
  ;   EndIf       
  
  
  
  ;/// third
  OpenWindow(3, 450+50, 200+50, 220, 220, "window_3", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
  g2=StringGadget(-1,0,0,0,0,"StringGadget")
  SplitterGadget(3,10, 10, 200, 200, g1,g2)
  BindEvent(#PB_Event_SizeWindow, @Resize_3(), 3)
  ;   
  ;   If cursor::setCursor(GadgetID(g1),#PB_Cursor_IBeam)
  ;     Debug "setCursorIBeam"           
  ;   EndIf       
  ;   
  ;   ;   If cursor::setCursor(GadgetID(g2),#PB_Cursor_IBeam)
  ;   ;     Debug "setCursorIBeam"           
  ;   ;   EndIf       
  ;   
  ;   
  ;   ;Debug "currentCursor - "+CocoaMessage(0, 0, "NSCursor currentCursor") ; CocoaMessage(0, 0, "NSCursor systemCursor") +" "+ 
  ;   events::SetCallback(@EventHandler())
  ;   
  ;   Repeat 
  ;     event = WaitWindowEvent()
  ;   Until event = #PB_Event_CloseWindow
  
  While GetMessage_(msg.MSG, #Null, 0, 0 ) 
    TranslateMessage_(msg) 
    DispatchMessage_(msg) 
  Wend 
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 142
; FirstLine = 137
; Folding = --
; EnableXP