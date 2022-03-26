CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_MacOS
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
      #PB_Cursor_OpenHand
      #PB_Cursor_ClosedHand
      #PB_Cursor_Drag
      #PB_Cursor_Drop
    EndEnumeration
    
    ImportC ""
      SetAnimatedThemeCursor(CursorType.i, AnimationStep.i)
      SetThemeCursor(CursorType.i)
    EndImport
    
    Procedure GetCursor( )
      Protected result.i
      
      Select CocoaMessage(0, 0, "NSCursor currentCursor")
        Case CocoaMessage(0, 0, "NSCursor arrowCursor") : result = #PB_Cursor_Default
          
        Case CocoaMessage(0, 0, "NSCursor dragCopyCursor") : result = #PB_Cursor_Drop
        Case CocoaMessage(0, 0, "NSCursor operationNotAllowedCursor") : result = #PB_Cursor_Drag
        Case CocoaMessage(0, 0, "NSCursor disappearingItemCursor") : result = #PB_Cursor_Denied
          
        Case CocoaMessage(0, 0, "NSCursor closedHandCursor") : result = #PB_Cursor_Arrows
        Case CocoaMessage(0, 0, "NSCursor crosshairCursor") : result = #PB_Cursor_Cross
        Case CocoaMessage(0, 0, "NSCursor pointingHandCursor") : result = #PB_Cursor_Hand
          
        Case CocoaMessage(0, 0, "NSCursor resizeUpCursor") : result = #PB_Cursor_Up
        Case CocoaMessage(0, 0, "NSCursor resizeDownCursor") : result = #PB_Cursor_Down
        Case CocoaMessage(0, 0, "NSCursor resizeUpDownCursor") : result = #PB_Cursor_UpDown
          
        Case CocoaMessage(0, 0, "NSCursor resizeLeftCursor") : result = #PB_Cursor_Left
        Case CocoaMessage(0, 0, "NSCursor resizeRightCursor") : result = #PB_Cursor_Right
        Case CocoaMessage(0, 0, "NSCursor resizeLeftRightCursor") : result = #PB_Cursor_LeftRight
          
      EndSelect 
      
      ProcedureReturn result
    EndProcedure
    
    Procedure SetCursor( cursor.i )
      Protected result
      ; if is hiden cursor show cursor
      CocoaMessage(0, 0, "NSCursor unhide")
         
      Select cursor
        Case #PB_Cursor_Invisible 
          CocoaMessage(0, 0, "NSCursor hide")
          
        Case #PB_Cursor_Busy 
          SetAnimatedThemeCursor( 7, 0 )
          
        Case #PB_Cursor_Default : result = CocoaMessage(0, 0, "NSCursor arrowCursor")
          
        Case #PB_Cursor_Drag : result = CocoaMessage(0, 0, "NSCursor operationNotAllowedCursor")
        Case #PB_Cursor_Drop : result = CocoaMessage(0, 0, "NSCursor dragCopyCursor")
        Case #PB_Cursor_Denied : result = CocoaMessage(0, 0, "NSCursor disappearingItemCursor")
          
        Case #PB_Cursor_Arrows : result = CocoaMessage(0, 0, "NSCursor closedHandCursor")
        Case #PB_Cursor_Cross : result = CocoaMessage(0, 0, "NSCursor crosshairCursor")
        Case #PB_Cursor_Hand : result = CocoaMessage(0, 0, "NSCursor pointingHandCursor")
          
        Case #PB_Cursor_Left : result = CocoaMessage(0, 0, "NSCursor resizeLeftCursor")
        Case #PB_Cursor_Right : result = CocoaMessage(0, 0, "NSCursor resizeRightCursor")
        Case #PB_Cursor_LeftRight : result = CocoaMessage(0, 0, "NSCursor resizeLeftRightCursor")
          
        Case #PB_Cursor_Up : result = CocoaMessage(0, 0, "NSCursor resizeUpCursor")
        Case #PB_Cursor_Down : result = CocoaMessage(0, 0, "NSCursor resizeDownCursor")
        Case #PB_Cursor_UpDown : result = CocoaMessage(0, 0, "NSCursor resizeUpDownCursor")
      EndSelect 
      
      If result
        CocoaMessage(0, result, "set")
      EndIf
      
      ProcedureReturn cursor
    EndProcedure
    
CompilerEndSelect


OpenWindow(1, 200, 100, 328, 328, "window_1", #PB_Window_SystemMenu)
;   Canvas_0 = CanvasGadget(#PB_Any, 8, 8, 56, 56)
;   Canvas_1 = CanvasGadget(#PB_Any, 8, 72, 56, 56)
  left = CanvasGadget(#PB_Any, 8, 136, 56, 56)
;   Canvas_3 = CanvasGadget(#PB_Any, 8, 200, 56, 56)
;   Canvas_32 = CanvasGadget(#PB_Any, 8, 264, 56, 56)
  
;   Canvas_4 = CanvasGadget(#PB_Any, 72, 8, 56, 56)
  lt = CanvasGadget(#PB_Any, 72, 72, 56, 56)
  l = CanvasGadget(#PB_Any, 72, 136, 56, 56)
  lb = CanvasGadget(#PB_Any, 72, 200, 56, 56)
;   Canvas_72 = CanvasGadget(#PB_Any, 72, 264, 56, 56)
  
  up = CanvasGadget(#PB_Any, 136, 8, 56, 56)
  t = CanvasGadget(#PB_Any, 136, 72, 56, 56)
  c = CanvasGadget(#PB_Any, 136, 136, 56, 56)
  b = CanvasGadget(#PB_Any, 136, 200, 56, 56)
  down = CanvasGadget(#PB_Any, 136, 264, 56, 56)
  
;   Canvas_12 = CanvasGadget(#PB_Any, 200, 8, 56, 56)
  rt = CanvasGadget(#PB_Any, 200, 72, 56, 56)
  r = CanvasGadget(#PB_Any, 200, 136, 56, 56)
  rb = CanvasGadget(#PB_Any, 200, 200, 56, 56)
;   Canvas_152 = CanvasGadget(#PB_Any, 200, 264, 56, 56)
  
;   Canvas_16 = CanvasGadget(#PB_Any, 264, 8, 56, 56)
;   Canvas_17 = CanvasGadget(#PB_Any, 264, 72, 56, 56)
  right = CanvasGadget(#PB_Any, 264, 136, 56, 56)
;   Canvas_19 = CanvasGadget(#PB_Any, 264, 200, 56, 56)
;   Canvas_192 = CanvasGadget(#PB_Any, 264, 264, 56, 56)

; ; OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
; ; CanvasGadget(2, 10, 10, 200, 200, #PB_Canvas_Keyboard|#PB_Canvas_Container);|#PB_Canvas_DrawFocus)
; ;                                                                            ; EnableGadgetDrop( 2, #PB_Drop_Private, #PB_Drag_Copy, #PB_Drop_Private )

OpenWindow(3, 450+50, 200+50, 220, 220, "window_3", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
CanvasGadget(3, 10, 10, 200, 200, #PB_Canvas_Keyboard|#PB_Canvas_Container);|#PB_Canvas_DrawFocus)
                                                                           ; EnableGadgetDrop( 2, #PB_Drop_Private, #PB_Drag_Copy, #PB_Drop_Private )
Define drag, getCursor =- 1, dragCursor = #PB_Cursor_Hand
Repeat 
  event = WaitWindowEvent( )
  
  If event = #PB_Event_Gadget
    Select EventType( )
      Case #PB_EventType_LeftButtonDown
        drag = 1
        dragCursor = #PB_Cursor_Arrows
        
      Case #PB_EventType_LeftButtonUp
        drag = 0
        If dragCursor = #PB_Cursor_Arrows
          SetCursor( #PB_Cursor_Default )
        EndIf
        dragCursor = #PB_Cursor_UpDown
        
      Case #PB_EventType_MouseMove
        If drag ; GetGadgetAttribute( EventGadget( ), #PB_Canvas_Buttons )
          If GetCursor( ) <> dragCursor
            Debug " update cursor - "+GetGadgetAttribute( EventGadget( ), #PB_Canvas_Cursor )
            ; SetGadgetAttribute( EventGadget( ), #PB_Canvas_Cursor, dragCursor )
            SetCursor( dragCursor )
          EndIf
        EndIf
        
      Case #PB_EventType_MouseEnter
        
        Select EventGadget( )
          Case l, r : SetCursor( #PB_Cursor_LeftRight ) 
          Case lt,rb : SetCursor( #PB_Cursor_LeftUpRightDown ) 
          Case t, b : SetCursor( #PB_Cursor_UpDown ) 
          Case rt,lb : SetCursor( #PB_Cursor_LeftDownRightUp ) 
          Case left : SetCursor( #PB_Cursor_Left ) 
          Case up : SetCursor( #PB_Cursor_Up ) 
          Case right : SetCursor( #PB_Cursor_Right ) 
          Case down : SetCursor( #PB_Cursor_Down ) 
          Case c : SetCursor( #PB_Cursor_Hand ) 
;           Case 0 : SetCursor( #PB_Cursor_Busy ) 
;           Case 0 : SetCursor( #PB_Cursor_Busy ) 
            
          Case 1  
            SetCursor( #PB_Cursor_Drag )
            
          Case 11  
            SetCursor( #PB_Cursor_Denied )
            
          Case 2 
            SetCursor( #PB_Cursor_Drop )
            
          Case 3 
            ; SetCursor( dragCursor )
            SetGadgetAttribute( EventGadget( ), #PB_Canvas_Cursor, dragCursor )
            
        EndSelect
        
      Case #PB_EventType_MouseLeave
        ;Debug GetCursor( )
        SetCursor( #PB_Cursor_Default )
        
    EndSelect
  EndIf
  
  If event =- 1
    If getCursor <> GetCursor( )
      getCursor = GetCursor( )
      Debug " get "+getCursor
    EndIf
  EndIf
  
Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP