DeclareModule ID
  Declare.i Window( WindowID.i )
  Declare.i Gadget( GadgetID.i )
  Declare.i IsWindowID( handle.i )
  Declare.i GetWindowID( handle.i )
EndDeclareModule

Module ID
  ;XIncludeFile "../import.pbi"
  Import ""
    PB_Window_GetID(hWnd) 
  EndImport
   
  Procedure.s ClassName( handle.i )
    Protected Result
    CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
    
    If Result
      ProcedureReturn PeekS( Result, - 1, #PB_UTF8 )
    EndIf
  EndProcedure
  
  Procedure.i GetWindowID( handle.i ) ; Return the handle of the parent window from the handle
    ProcedureReturn CocoaMessage( 0, handle, "window" )
  EndProcedure
  
  Procedure.i IsWindowID( handle.i )
    If ClassName( handle ) = "PBWindow"
      ProcedureReturn 1
    EndIf
  EndProcedure
  
  Procedure.i Window( WindowID.i ) ; Return the id of the window from the window handle
    ProcedureReturn PB_Window_GetID( WindowID )
  EndProcedure
  
  Procedure.i Gadget( GadgetID.i )  ; Return the id of the gadget from the gadget handle
    ProcedureReturn CocoaMessage(0, GadgetID, "tag")
  EndProcedure
EndModule
;;XIncludeFile "id.pbi"

;XIncludeFile "get.pbi"
Global setCursor = #PB_Cursor_Hand

CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_MacOS
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
      
      Declare.i CreateCursor( ImageID.i, x.l = 0, y.l = 0 )
      Declare   FreeCursor( hCursor.i )
      Declare   HideCursor( state.b )
      Declare   GetCursor( )
      Declare   UpdateCursor( gadget.i )
      Declare   SetCursor( gadget.i, cursor.i )
    EndDeclareModule
    
    Module Cursor 
      #kThemeArrowCursor                   = 0
      #kThemeCopyArrowCursor               = 1
      #kThemeAliasArrowCursor              = 2
      #kThemeContextualMenuArrowCursor     = 3
      #kThemeIBeamCursor                   = 4
      #kThemeCrossCursor                   = 5
      #kThemePlusCursor                    = 6
      #kThemeWatchCursor                   = 7
      #kThemeClosedHandCursor              = 8
      #kThemeOpenHandCursor                = 9
      #kThemePointingHandCursor            = 10
      #kThemeCountingUpHandCursor          = 11
      #kThemeCountingDownHandCursor        = 12
      #kThemeCountingUpAndDownHandCursor   = 13
      #kThemeSpinningCursor                = 14
      #kThemeResizeLeftCursor              = 15
      #kThemeResizeRightCursor             = 16
      #kThemeResizeLeftRightCursor         = 17
      
      ImportC ""
        SetAnimatedThemeCursor(CursorType.i, AnimationStep.i)
        SetThemeCursor(CursorType.i)
        CGCursorIsVisible( )
      EndImport
      
      
      Procedure   FreeCursor( hCursor.i )
        CocoaMessage( 0, hCursor, "release" )
      EndProcedure
      
      Procedure   IsHideCursor( )
        CGCursorIsVisible( )
      EndProcedure
      
      Procedure   HideCursor( state.b )
        If state
          CocoaMessage(0, 0, "NSCursor hide")
        Else
          CocoaMessage(0, 0, "NSCursor unhide")
        EndIf
      EndProcedure
      
      Procedure.i CreateCursor( ImageID.i, x.l = 0, y.l = 0 )
        Protected *ic
        Protected Hotspot.NSPoint
        
        If ImageID
          Hotspot\x = x
          Hotspot\y = y
          *ic = CocoaMessage( 0, 0, "NSCursor alloc" )
          CocoaMessage( 0, *ic, "initWithImage:", ImageID, "hotSpot:@", @Hotspot )
        EndIf
        
        ProcedureReturn *ic
      EndProcedure
      
      Procedure   GetCurrentCursor( )
        ;Debug ""+CocoaMessage(0, 0, "NSCursor systemCursor") +" "+ CocoaMessage(0, 0, "NSCursor currentCursor")
        ProcedureReturn CocoaMessage(0, 0, "NSCursor currentCursor")
      EndProcedure
      
      Procedure   GetCursor( )
        Protected result.i
        ;Debug ""+CocoaMessage(0, 0, "NSCursor systemCursor") +" "+ CocoaMessage(0, 0, "NSCursor currentCursor")
        
        If CGCursorIsVisible( ) ;  GetGadgetAttribute( EventGadget( ), #PB_Canvas_CustomCursor ) ; 
          Select CocoaMessage(0, 0, "NSCursor currentCursor")
            Case CocoaMessage(0, 0, "NSCursor arrowCursor") : result = #PB_Cursor_Default
            Case CocoaMessage(0, 0, "NSCursor IBeamCursor") : result = #PB_Cursor_IBeam
              ; Case CocoaMessage(0, 0, "NSCursor IBeamCursorForVerticalLayoutCursor") : result = #PB_Cursor_VIBeam
              
            Case CocoaMessage(0, 0, "NSCursor dragCopyCursor") : result = #PB_Cursor_Drop
            Case CocoaMessage(0, 0, "NSCursor operationNotAllowedCursor") : result = #PB_Cursor_Drag
            Case CocoaMessage(0, 0, "NSCursor disappearingItemCursor") : result = #PB_Cursor_Denied
              
            Case CocoaMessage(0, 0, "NSCursor crosshairCursor") : result = #PB_Cursor_Cross
            Case CocoaMessage(0, 0, "NSCursor pointingHandCursor") : result = #PB_Cursor_Hand
            Case CocoaMessage(0, 0, "NSCursor openHandCursor") : result = #PB_Cursor_Grab
            Case CocoaMessage(0, 0, "NSCursor closedHandCursor") : result = #PB_Cursor_Grabbing
              
            Case CocoaMessage(0, 0, "NSCursor resizeUpCursor") : result = #PB_Cursor_Up
            Case CocoaMessage(0, 0, "NSCursor resizeDownCursor") : result = #PB_Cursor_Down
            Case CocoaMessage(0, 0, "NSCursor resizeUpDownCursor") : result = #PB_Cursor_UpDown
              
            Case CocoaMessage(0, 0, "NSCursor resizeLeftCursor") : result = #PB_Cursor_Left
            Case CocoaMessage(0, 0, "NSCursor resizeRightCursor") : result = #PB_Cursor_Right
            Case CocoaMessage(0, 0, "NSCursor resizeLeftRightCursor") : result = #PB_Cursor_LeftRight
          EndSelect 
        Else
          result = #PB_Cursor_Invisible
        EndIf
        
        ProcedureReturn result
      EndProcedure
      
      Procedure SetCursor( handle.i, cursor.i )
        Protected result, windowID
        Protected gadget.i =- 1, window.i =- 1
        
        If GetCursor( ) <> cursor
          If id::IsWindowID( handle )
            window = id::Window( handle )
            windowID = handle
          Else
            gadget = id::Gadget( handle )
            windowID = id::GetWindowID( handle )
          EndIf
          
          ; if ishidden cursor show cursor
          If Not CGCursorIsVisible( )
            CocoaMessage(0, 0, "NSCursor unhide")
          EndIf
          setCursor = cursor
          
          Select cursor
            Case #PB_Cursor_Invisible 
              CocoaMessage(0, 0, "NSCursor hide")
              ; SetGadgetAttribute( EventGadget( ), #PB_Canvas_Cursor, cursor )
              
            Case #PB_Cursor_Busy 
              SetAnimatedThemeCursor( #kThemeWatchCursor, 0 )
              
            Case #PB_Cursor_Default : result = CocoaMessage(0, 0, "NSCursor arrowCursor")
            Case #PB_Cursor_IBeam : result = CocoaMessage(0, 0, "NSCursor IBeamCursor")
              ; Case #PB_Cursor_VIBeam : result = CreateCursor(ImageID(CatchImage(#PB_Any, ?cross, ?cross_end-?cross)), -8,-8) ; CocoaMessage(0, 0, "NSCursor IBeamCursorForVerticalLayoutCursor")
              ;result = CreateCursor(ImageID(CatchImage(#PB_Any, ?hand, ?hand_end-?hand))) ; : 
            Case #PB_Cursor_Drag : result = CocoaMessage(0, 0, "NSCursor operationNotAllowedCursor")
            Case #PB_Cursor_Drop : result = CocoaMessage(0, 0, "NSCursor dragCopyCursor")
            Case #PB_Cursor_Denied : result = CocoaMessage(0, 0, "NSCursor disappearingItemCursor")
              
            Case #PB_Cursor_Cross : result = CocoaMessage(0, 0, "NSCursor crosshairCursor")
            Case #PB_Cursor_Hand : result = CocoaMessage(0, 0, "NSCursor pointingHandCursor")
            Case #PB_Cursor_Grab : result = CocoaMessage(0, 0, "NSCursor openHandCursor")
            Case #PB_Cursor_Grabbing : result = CocoaMessage(0, 0, "NSCursor closedHandCursor")
              
            Case #PB_Cursor_Left : result = CocoaMessage(0, 0, "NSCursor resizeLeftCursor")
            Case #PB_Cursor_Right : result = CocoaMessage(0, 0, "NSCursor resizeRightCursor")
            Case #PB_Cursor_LeftRight : result = CocoaMessage(0, 0, "NSCursor resizeLeftRightCursor")
              
            Case #PB_Cursor_Up : result = CocoaMessage(0, 0, "NSCursor resizeUpCursor")
            Case #PB_Cursor_Down : result = CocoaMessage(0, 0, "NSCursor resizeDownCursor")
            Case #PB_Cursor_UpDown : result = CocoaMessage(0, 0, "NSCursor resizeUpDownCursor")
          EndSelect 
          
          If result
            Debug "pbi.cursor( "+ GetCursor( ) +" - " +cursor +" ) "+GetCurrentCursor( ) +" - "+ result
            
            CocoaMessage(0, result, "set") ; for the no actived-window gadget
;             If gadget >= 0
;               SetGadgetAttribute( gadget, #PB_Canvas_CustomCursor, result )
;             EndIf
            If cursor = #PB_Cursor_Default
              CocoaMessage(0, windowID, "enableCursorRects")
            Else
              CocoaMessage(0, windowID, "disableCursorRects") 
            EndIf
            ; CocoaMessage(0, CocoaMessage( 0, GadgetID( gadget ), "window" ), "discardCursorRects") 
            ; CocoaMessage(0, CocoaMessage( 0, GadgetID( gadget ), "window" ), "resetCursorRects") ; for the actived-window gadget
          EndIf
        EndIf
      
        ProcedureReturn cursor
      EndProcedure
      
      Procedure UpdateCursor( gadget.i )
;         Protected currentCursor = CocoaMessage( 0, 0, "NSCursor currentCursor" )
;         Protected currentCanvasCursor = GetGadgetAttribute( gadget, #PB_Canvas_CustomCursor )
;         
;         If currentCursor <> currentCanvasCursor
;           If currentCanvasCursor =- 1
;             SetGadgetAttribute( gadget, #PB_Canvas_CustomCursor, currentCursor )
;           Else
;             CocoaMessage( 0, currentCanvasCursor, "set" )
;           EndIf
;           ProcedureReturn 1
;         EndIf
      EndProcedure
      
      DataSection
        cross:
        ;IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/macOSBigSur/cross.png"
        IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/cross1.png"
        cross_end:
        
        hand:
        IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/macOSBigSur/hand2.png"
        hand_end:
        
        move:
        IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/macOSBigSur/hand1.png"
        move_end:
        
      EndDataSection
    EndModule   
CompilerEndSelect

CompilerIf #PB_Compiler_IsMainFile
  UseModule  Cursor
  
  Procedure TestCursor( cursor, x,y,width,height )
    Protected text.s, NewCursor
    Protected g = CanvasGadget(#PB_Any, x,y,width,height)
    
    ;     Select Cursor
    ;       Case #PB_Cursor_Arrows : text = "Arrows" : img = 
    ;       Case #PB_Cursor_Hand : text = "Hand"
    ;       Case #PB_Cursor_Help : text = "Help"
    ;       Case #PB_Cursor_Busy : text = "Arrows"
    ;       Case #PB_Cursor_Cross : text = "Arrows"
    ;       Case #PB_Cursor_Denied : text = "Arrows"
    ;       Case #PB_Cursor_IBeam : text = "Arrows"
    ;       Case #PB_Cursor_LeftDownRightUp : text = "Arrows"
    ;       Case #PB_Cursor_LeftUpRightDown : text = "Arrows"
    ;       Case #PB_Cursor_LeftRight : text = "LeftRight"
    ;       Case #PB_Cursor_UpDown : text = "UpDown"
    ;         
    ;       Case #PB_Cursor_Arrows : text = "Arrows"
    ;       Case #PB_Cursor_Arrows : text = "Arrows"
    ;       Case #PB_Cursor_Arrows : text = "Arrows"
    ;       Case #PB_Cursor_Arrows : text = "Arrows"
    ;       Case #PB_Cursor_Arrows : text = "Arrows"
    ;       Case #PB_Cursor_Arrows : text = "Arrows"
    ;       Case #PB_Cursor_Arrows : text = "Arrows"
    ;         
    ;     EndSelect
    
    ;     Select cursor
    ;           Case #PB_Cursor_Busy : NewCursor = LoadCursor_( 0, #IDC_WAIT )
    ;             
    ;           Case #PB_Cursor_Default : NewCursor = LoadCursor_( 0, #IDC_ARROW )
    ;           Case #PB_Cursor_IBeam : NewCursor = LoadCursor_( 0, #IDC_IBEAM )
    ;             ; Case #PB_Cursor_VIBeam : NewCursor = LoadCursor_( 0, #IDC_ARROW )
    ;             
    ;           Case #PB_Cursor_Help : NewCursor = LoadCursor_( 0, #IDC_HELP )
    ;             
    ;           Case #PB_Cursor_Drag : NewCursor = LoadCursor_( 0, #IDC_ARROW )
    ;           Case #PB_Cursor_Drop : NewCursor = LoadCursor_( 0, #IDC_ARROW )
    ;           Case #PB_Cursor_Denied : NewCursor = LoadCursor_( 0, #IDC_NO )
    ;             
    ;           Case #PB_Cursor_Cross : NewCursor = LoadCursor_( 0, #IDC_CROSS )
    ;           Case #PB_Cursor_Hand : NewCursor = CreateCursor( LoadCursor_( 0, #IDC_HAND ) )
    ;           Case #PB_Cursor_Grab : NewCursor = LoadCursor_( 0, #IDC_ARROW )
    ;           Case #PB_Cursor_Grabbing : NewCursor = LoadCursor_( 0, #IDC_ARROW )
    ;             
    ;           Case #PB_Cursor_Left : NewCursor = LoadCursor_( 0, #IDC_ARROW )
    ;           Case #PB_Cursor_Right : NewCursor = LoadCursor_( 0, #IDC_ARROW )
    ;           Case #PB_Cursor_LeftRight : NewCursor = LoadCursor_( 0, #IDC_SIZEWE )
    ;             
    ;           Case #PB_Cursor_Up : NewCursor = LoadCursor_( 0, #IDC_ARROW )
    ;           Case #PB_Cursor_Down : NewCursor = LoadCursor_( 0, #IDC_ARROW )
    ;           Case #PB_Cursor_UpDown : NewCursor = LoadCursor_( 0, #IDC_SIZENS )
    ;             
    ;           Case #PB_Cursor_Arrows : NewCursor = LoadCursor_( 0, #IDC_SIZEALL )
    ;           Case #PB_Cursor_LeftDownRightUp : NewCursor = LoadCursor_( 0, #IDC_SIZENESW )
    ;           Case #PB_Cursor_LeftUpRightDown : NewCursor = LoadCursor_( 0, #IDC_SIZENWSE )
    ;         EndSelect 
    ;         ;     
    ;     
    ;     If StartDrawing(CanvasOutput(g))
    ;       DrawText(5,5,text)
    ;       DrawImage( NewCursor, 5,5)
    ;       StopDrawing()
    ;     EndIf
    
    ProcedureReturn g
  EndProcedure
  
  OpenWindow(1, 200, 100, 328, 328, "window_1", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
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
  
  up = TestCursor(#PB_Cursor_UpDown, 136, 8, 56, 56)
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
  
  OpenWindow(2, 450, 380, 328, 328, "window_1", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  busy = CanvasGadget(#PB_Any, 8, 8, 56, 56)
  IBeam = CanvasGadget(#PB_Any, 8, 72, 56, 56)
  none = CanvasGadget(#PB_Any, 8, 136, 56, 56)
  ; ;   Canvas_3 = CanvasGadget(#PB_Any, 8, 200, 56, 56)
  ; ;   Canvas_32 = CanvasGadget(#PB_Any, 8, 264, 56, 56)
  ;   
  iDrag = CanvasGadget(#PB_Any, 72, 8, 56, 56)
  Hand = TestCursor(#PB_Cursor_Hand, 72, 72, 56, 56)
  ;   l = CanvasGadget(#PB_Any, 72, 136, 56, 56)
  ;   lb = CanvasGadget(#PB_Any, 72, 200, 56, 56)
  ; ;   Canvas_72 = CanvasGadget(#PB_Any, 72, 264, 56, 56)
  
  Denied = CanvasGadget(#PB_Any, 136, 8, 56, 56)
  Grab = CanvasGadget(#PB_Any, 136, 72, 56, 56)
  ;   c = CanvasGadget(#PB_Any, 136, 136, 56, 56)
  ;   b = CanvasGadget(#PB_Any, 136, 200, 56, 56)
  ;   down = CanvasGadget(#PB_Any, 136, 264, 56, 56)
  
  iDrop = CanvasGadget(#PB_Any, 200, 8, 56, 56)
  Grabbing = CanvasGadget(#PB_Any, 200, 72, 56, 56)
  ;   r = CanvasGadget(#PB_Any, 200, 136, 56, 56)
  ;   rb = CanvasGadget(#PB_Any, 200, 200, 56, 56)
  ; ;   Canvas_152 = CanvasGadget(#PB_Any, 200, 264, 56, 56)
  
  cross = CanvasGadget(#PB_Any, 264, 8, 56, 56)
  ; ;   Canvas_17 = CanvasGadget(#PB_Any, 264, 72, 56, 56)
  ;   right = CanvasGadget(#PB_Any, 264, 136, 56, 56)
  ; ;   Canvas_19 = CanvasGadget(#PB_Any, 264, 200, 56, 56)
  ; ;   Canvas_192 = CanvasGadget(#PB_Any, 264, 264, 56, 56)
  
  Define handle, dragButtons, getCursor =- 1
  Repeat 
    event = WaitWindowEvent( )
    
    If event = #PB_Event_Gadget
      handle = GadgetID( EventGadget( ) )
          
      Select EventType( )
        Case #PB_EventType_LeftButtonDown
          dragButtons = 1
          
        Case #PB_EventType_LeftButtonUp
          dragButtons = 0
          If GetCursor( ) = setCursor 
            SetCursor( handle, #PB_Cursor_Default )
          EndIf
          
        Case #PB_EventType_MouseMove
          If dragButtons ; GetGadgetAttribute(1, #PB_Canvas_Buttons)
            If UpdateCursor( handle )
              Debug "update " 
            EndIf
          EndIf
          
        Case #PB_EventType_MouseEnter
          Select EventGadget( )
            Case l, r : SetCursor( handle,#PB_Cursor_LeftRight ) 
            Case lt,rb : SetCursor( handle,#PB_Cursor_LeftUpRightDown ) 
            Case t, b : SetCursor( handle,#PB_Cursor_UpDown ) 
            Case rt,lb : SetCursor( handle,#PB_Cursor_LeftDownRightUp ) 
            Case left : SetCursor( handle,#PB_Cursor_Left ) 
            Case up : SetCursor( handle,#PB_Cursor_Up ) 
            Case right : SetCursor( handle,#PB_Cursor_Right ) 
            Case down : SetCursor( handle,#PB_Cursor_Down ) 
              ; Case c : SetCursor( handle,#PB_Cursor_Arrows ) 
              
            Case Busy : SetCursor( handle,#PB_Cursor_Busy )
            Case Cross : SetCursor( handle,#PB_Cursor_Cross )
            Case Denied : SetCursor( handle,#PB_Cursor_Denied )
            Case iDrag : SetCursor( handle,#PB_Cursor_Drag )
            Case iDrop : SetCursor( handle,#PB_Cursor_Drop )
            Case IBeam : SetCursor( handle,#PB_Cursor_IBeam )
            Case Hand : SetCursor( handle,#PB_Cursor_Hand )
            Case Grab : SetCursor( handle,#PB_Cursor_Grab )
            Case Grabbing : SetCursor( handle,#PB_Cursor_Grabbing )
            Case none : SetCursor( handle,#PB_Cursor_Invisible )
              
          EndSelect
          
          ; SetGadgetAttribute( handle, #PB_Canvas_Cursor, setCursor )
        ;;;  Debug CocoaMessage(0, 0, "NSCursor currentCursor")
          
        Case #PB_EventType_MouseLeave
          If Not dragButtons
           ; SetCursor( handle,#PB_Cursor_Default )
            SetCursor( WindowID(EventWindow()), #PB_Cursor_Cross)
          EndIf
          
      EndSelect
    EndIf
    
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -------
; EnableXP