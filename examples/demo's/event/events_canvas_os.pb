CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Procedure.s PBClassFromEvent( event.i )
    Protected result.s
    
    Select event
      Case #PB_EventType_MouseEnter       : result.s = "MouseEnter"           ; The mouse cursor entered the gadget
      Case #PB_EventType_MouseLeave       : result.s = "MouseLeave"           ; The mouse cursor left the gadget
      Case #PB_EventType_MouseMove        : result.s = "MouseMove"            ; The mouse cursor moved
      Case #PB_EventType_MouseWheel       : result.s = "MouseWheel"           ; The mouse wheel was moved
        
      Case #PB_EventType_LeftButtonDown   : result.s = "LeftButtonDown"   ; The left mouse button was pressed
      Case #PB_EventType_LeftButtonUp     : result.s = "LeftButtonUp"     ; The left mouse button was released
      Case #PB_EventType_LeftClick        : result.s = "LeftClick"        ; A click With the left mouse button
      Case #PB_EventType_LeftDoubleClick  : result.s = "LeftDoubleClick"  ; A double-click With the left mouse button
        
      Case #PB_EventType_RightButtonDown  : result.s = "RightButtonDown" ; The right mouse button was pressed
      Case #PB_EventType_RightButtonUp    : result.s = "RightButtonUp"   ; The right mouse button was released
      Case #PB_EventType_RightClick       : result.s = "RightClick"      ; A click With the right mouse button
      Case #PB_EventType_RightDoubleClick : result.s = "RightDoubleClick"; A double-click With the right mouse button
        
      Case #PB_EventType_MiddleButtonDown : result.s = "MiddleButtonDown" ; The middle mouse button was pressed
      Case #PB_EventType_MiddleButtonUp   : result.s = "MiddleButtonUp"   ; The middle mouse button was released
      Case #PB_EventType_Focus            : result.s = "Focus"            ; The gadget gained keyboard focus
      Case #PB_EventType_LostFocus        : result.s = "LostFocus"        ; The gadget lost keyboard focus
      Case #PB_EventType_KeyDown          : result.s = "KeyDown"          ; A key was pressed
      Case #PB_EventType_KeyUp            : result.s = "KeyUp"            ; A key was released
      Case #PB_EventType_Input            : result.s = "Input"            ; Text input was generated
      Case #PB_EventType_Resize           : result.s = "Resize"           ; The gadget has been resized
      Case #PB_EventType_StatusChange     : result.s = "StatusChange"
      Case #PB_EventType_Change           : result.s = "Change"
      Case #PB_EventType_DragStart        : result.s = "DragStart"
      Case #PB_EventType_TitleChange      : result.s = "TitleChange"
        ;          Case #PB_EventType_CloseItem        : result.s = "CloseItem"
        ;          Case #PB_EventType_SizeItem         : result.s = "SizeItem"
      Case #PB_EventType_Down             : result.s = "Down"
      Case #PB_EventType_Up               : result.s = "Up"
        ;                
        ;             Case #pb_eventtype_cursor : result.s = "Cursor"
        ;             Case #pb_eventtype_free : result.s = "Free"
        ;             Case #pb_eventtype_drop : result.s = "Drop"
        ;             Case #pb_eventtype_create : result.s = "Create"
        ;             Case #pb_eventtype_Draw : result.s = "Draw"
        ;                
        ;             Case #pb_eventtype_repaint : result.s = "Repaint"
        ;             Case #pb_eventtype_resizeend : result.s = "ResizeEnd"
        ;             Case #pb_eventtype_scrollchange : result.s = "ScrollChange"
        ;                
        ;             Case #pb_eventtype_close : result.s = "CloseWindow"
        ;             Case #pb_eventtype_maximize : result.s = "MaximizeWindow"
        ;             Case #pb_eventtype_minimize : result.s = "MinimizeWindow"
        ;             Case #pb_eventtype_restore : result.s = "RestoreWindow"
        ;             Case #pb_eventtype_ReturnKey : result.s = "returnKey"
        ;             Case #pb_eventtype_mousewheelX : result.s = "MouseWheelX"
        ;             Case #pb_eventtype_mousewheelY : result.s = "MouseWheelY"
    EndSelect
    
    ProcedureReturn result.s
  EndProcedure
  
  Procedure fixed_events( gadget, event )
    Debug " ["+gadget+"] "+ PBClassFromEvent(event) 
  EndProcedure
  
  Procedure windows_events( )
    fixed_events( EventGadget( ), EventType( ) )
  EndProcedure
  
  Procedure linux_events( )
    If EventType( ) = #PB_EventType_LeftButtonDown
      If GetActiveGadget( ) = EventGadget( )
        fixed_events( EventGadget( ), EventType( ) )
      EndIf
    ElseIf EventType( ) = #PB_EventType_Focus
      fixed_events( EventGadget( ), EventType( ) )
      If GetActiveGadget( ) = EventGadget( )
        fixed_events( EventGadget( ), #PB_EventType_LeftButtonDown )
      EndIf
    ElseIf EventType( ) = #PB_EventType_MouseLeave
      If Not GetGadgetAttribute( EventGadget( ), #PB_Canvas_Buttons ) 
         fixed_events( EventGadget( ), EventType( ) )
      EndIf
    Else
      fixed_events( EventGadget( ), EventType( ) )
    EndIf
  EndProcedure
  
  Procedure macos_events( )
    fixed_events( EventGadget( ), EventType( ) )
  EndProcedure
  
  Procedure all_events( )
    If EventType( ) = #PB_EventType_MouseMove
      ProcedureReturn 0
    EndIf
    ;
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      windows_events( )
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      linux_events( )
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      macos_events( )
    CompilerEndIf
  EndProcedure
  
  Define flag.q = #PB_Canvas_DrawFocus
  
  Procedure TestRoot( gadget, X,Y,Width,Height, flag )
    CanvasGadget(gadget, X,Y,Width,Height, #PB_Canvas_Keyboard ) 
    StartDrawing(CanvasOutput(gadget))
    DrawText(10,10,Str(gadget))
    StopDrawing()
    BindGadgetEvent( gadget, @all_events( ))
  EndProcedure
  
  If OpenWindow(0, 0, 0, 370, 370, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    TestRoot(10, 10, 10, 150, 150,flag) 
    
    TestRoot(20, 210, 10, 150, 150,flag) 
    
    TestRoot(30, 10, 210, 150, 150,flag) 
    
    TestRoot(40, 210, 210, 150, 150,flag) 
    
    Define gEvent, gQuit
    Repeat
      gEvent= WaitWindowEvent()
      
      Select gEvent
        Case #PB_Event_CloseWindow
          gQuit= #True
      EndSelect
      
    Until gQuit
  EndIf
  
CompilerEndIf

; [1] MouseEnter
; [1] Focus
; [1] Down
; [1] LeftButtonDown
; [1] Up
; [1] LeftButtonUp
; [1] LeftClick
; [1] Down
; [1] LeftButtonDown
; [1] DragStart
; [1] Up
; [1] LeftButtonUp
; [1] MouseLeave
; IDE Options = PureBasic 6.12 LTS (Linux - x64)
; CursorPosition = 80
; FirstLine = 62
; Folding = ---
; EnableXP
; DPIAware