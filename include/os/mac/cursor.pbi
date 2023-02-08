;\\
XIncludeFile "../cursors.pbi"

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
    ;SetThemeCursor(CursorType.i)
    CGCursorIsVisible()
  EndImport
  
  ImportC ""
    CFRunLoopGetCurrent()
    CFRunLoopAddCommonMode(rl, mode)
    
    GetCurrentProcess(*psn)
    CGEventTapCreateForPSN(*psn, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
    CGEventTapCreate(tap.i, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
  EndImport
  
  Global eventTap, psn, EnteredID 
  
  ProcedureC  Proc(proxy, eType, event, refcon)
    Protected handle
    Shared EnteredID
    Static PressedID
    
    If eType = #NSLeftMouseDown
      PressedID = Mouse::Gadget(Mouse::Window())
      
    ElseIf eType = #NSLeftMouseUp
      handle = Mouse::Gadget(Mouse::Window())
      
      If handle <> PressedID
        If PressedID  
          Cursor::change(PressedID, 0)
        EndIf
        If handle  
          Cursor::change( handle, 1)
        EndIf
      EndIf
      
      EnteredID = handle
      PressedID = #Null
      
    ElseIf eType = #NSMouseMoved
      handle = Mouse::Gadget(Mouse::Window())
      
      If EnteredID <> handle
        ; Debug ""+#PB_Compiler_Procedure+" "+EnteredID +" "+ handle
        If EnteredID
          Cursor::change(EnteredID, 0)
        EndIf
        
        EnteredID = handle
        
        If EnteredID 
          Cursor::change(EnteredID, 1)
        EndIf
      EndIf
      
    Else ; appKitDefined
      If eType = #NSCursorUpdate
        Debug "#NSCursorUpdate"
      EndIf
      
      CompilerIf #PB_Compiler_IsMainFile
        ; event =  __NSCFType
        Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
        Debug ""+eType +" "+ event +" "+ NSEvent ;+" "+ ID::ClassName(NSEvent) ; GetWindowTitle(GetActiveWindow())
                                                 ;CocoaMessage(0, WindowID(GetActiveWindow()), "disableCursorRects")
        ;Debug CocoaMessage(0, 0, "eventType:", event)
          
;         If EnteredID 
;           Cursor::change(EnteredID, 1)
;         EndIf
      CompilerEndIf
    EndIf
  EndProcedure
  
  GetCurrentProcess(@psn)
  ;eventTap = CGEventTapCreateForPSN(@psn, 0, 1, #NSMouseMovedMask | #NSLeftMouseDownMask | #NSLeftMouseUpMask | #NSCursorUpdateMask | #NSAppKitDefinedMask, @Proc( ), #NUL)
  eventTap = CGEventTapCreateForPSN(@psn, 0, 1, #NSAnyEventMask, @Proc( ), #NUL)
  If eventTap
    CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopDefaultMode")
  EndIf
  
  Global NewMap images.i()
  
  ;-\\
  Procedure   Image( type.i = 0 )
    Protected image
    
    If type = #PB_Cursor_Drop
      image = CatchImage( #PB_Any, ?add, 601 )
    ElseIf type = #PB_Cursor_Drag
      image = CatchImage( #PB_Any, ?copy, 530 )
    EndIf
    
    If Not image
      image = CreateImage( #PB_Any, 16, 16, 32, #PB_Image_Transparent )
    EndIf
    
    DataSection
      add: ; memory_size - ( 601 )
      Data.q $0A1A0A0D474E5089, $524448490D000000, $1A00000017000000, $0FBDF60000000408, $4D416704000000F5, $61FC0B8FB1000041,
             $5248632000000005, $800000267A00004D, $80000000FA000084, $EA000030750000E8, $170000983A000060, $0000003C51BA9C70,
             $87FF0044474B6202, $7009000000BFCC8F, $00C8000000735948, $ADE7FA6300C80000, $454D497407000000, $450A0F0B1308E307,
             $63100000000C6AC0, $0020000000764E61, $0002000000200000, $000C8D7E6F010000, $3854414449300100, $1051034ABB528DCB,
             $58DB084146C5293D, $82361609B441886C, $AA4910922C455E92, $C2C105F996362274, $FC2FF417B0504FC2, $DEF7BB3BB9ACF1A0,
             $B99CE66596067119, $2DB03A16C1101E67, $12D0B4D87B0D0B8F, $11607145542B450C, $190D04A4766FDCAA, $4129428FD14DCD04,
             $98F0D525AEFE8865, $A1C4924AD95B44D0, $26A2499413E13040, $F4F9F612B8726298, $62A6ED92C07D5B54, $E13897C2BE814222,
             $A75C5C6365448A6C, $D792BBFAE41D2925, $1A790C0B8161DC2F, $224D78F4C611BD60, $A1E8C72566AB9F6F, $2023A32BDB05D21B,
             $0E3BC7FEBAF316E4, $8E25C73B08CF01B1, $385C7629FEB45FBE, $8BB5746D80621D9F, $9A5AC7132FE2EC2B, $956786C4AE73CBF3,
             $FE99E13C707BB5EB, $C2EA47199109BF48, $01FE0FA33F4D71EF, $EE0F55B370F8C437, $F12CD29C356ED20C, $CBC4BD4A70C833B1,
             $FFCD97200103FC1C, $742500000019D443, $3A65746164745845, $3200657461657263, $312D38302D393130, $3A35313A31315439,
             $30303A30302B3930, $25000000B3ACC875, $6574616474584574, $00796669646F6D3A, $2D38302D39313032, $35313A3131543931,
             $303A30302B35303A, $0000007B7E35C330, $6042AE444E454900
      Data.b $82
      add_end:
      ;     EndDataSection
      ;
      ;     DataSection
      copy: ; memory_size - ( 530 )
      Data.q $0A1A0A0D474E5089, $524448490D000000, $1A00000010000000, $1461140000000408, $4D4167040000008C, $61FC0B8FB1000041,
             $5248632000000005, $800000267A00004D, $80000000FA000084, $EA000030750000E8, $170000983A000060, $0000003C51BA9C70,
             $87FF0044474B6202, $7009000000BFCC8F, $00C8000000735948, $ADE7FA6300C80000, $454D497407000000, $450A0F0B1308E307,
             $63100000000C6AC0, $0020000000764E61, $0002000000200000, $000C8D7E6F010000, $2854414449E90000, $1040C20A31D27DCF,
             $8B08226C529FD005, $961623685304458D, $05E8A288B1157A4A, $785858208E413C44, $AD03C2DE8803C505, $74CCDD93664D9893,
             $5C25206CCCECC7D9, $0AF51740A487B038, $E4950624ACF41B10, $0B03925602882A0F, $504520607448C0E1, $714E75682A0F7A22,
             $1EC4707FBC91940F, $EF1F26F801E80C33, $6FE840E84635C148, $47D13D78D54EC071, $5BDF86398A726F4D, $7DD0539F268C6356,
             $39B40B3759101A3E, $2EEB2D02D7DBC170, $49172CA44A415AD2, $52B82E69FF1E0AC0, $CC0D0D97E9B7299E, $046FA509CA4B09C0,
             $CB03993630382B86, $5E4840261A49AA98, $D3951E21331B30CF, $262C1B127F8F8BD3, $250000007DB05216, $6574616474584574,
             $006574616572633A, $2D38302D39313032, $35313A3131543931, $303A30302B37303A, $000000EED7F72530, $7461647458457425,
             $796669646F6D3A65, $38302D3931303200, $313A31315439312D, $3A30302B35303A35, $00007B7E35C33030, $42AE444E45490000
      Data.b $60, $82
      copy_end:
    EndDataSection
    
      
;   DataSection
;     cross:
;     ;IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/macOSBigSur/cross.png"
;     IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/cross1.png"
;     cross_end:
;     
;     hand:
;     IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/macOSBigSur/hand2.png"
;     hand_end:
;     
;     move:
;     IncludeBinary "/Users/as/Documents/GitHub/widget/include/cursors/macOSBigSur/hand1.png"
;     move_end:
;     
;   EndDataSection

    ProcedureReturn image
  EndProcedure
   
  Procedure New( icursor.i )
    If Not FindMapElement(images(), Str(icursor))
      AddMapElement(images(), Str(icursor))
      images() = Create(ImageID(Image( icursor )))
    EndIf
    
    ProcedureReturn images()
  EndProcedure
  
  Procedure   Free(hCursor.i) 
    ; Debug "cursor-free "+hCursor
    
    If hCursor >= 0 And hCursor <= 255
      If FindMapElement(images(), Str(hCursor))
        DeleteMapElement(images());, Str(hCursor))
      EndIf
    Else
      If MapSize(images())
        PushMapPosition(images())
        ForEach images()
          If hCursor = images()
            DeleteMapElement(images())
          EndIf
        Next
        PopMapPosition(images())
      EndIf
      ProcedureReturn CocoaMessage(0, hCursor, "release")
    EndIf
  EndProcedure
  
  Procedure   isHiden()
    ProcedureReturn Bool( CGCursorIsVisible( ) = 0 )
  EndProcedure
  
  Procedure   Hide(state.b)
    If state
      CocoaMessage(0, 0, "NSCursor hide")
    Else
      CocoaMessage(0, 0, "NSCursor unhide")
    EndIf
  EndProcedure
  
  Procedure.i Create(ImageID.i, x.l = 0, y.l = 0)
    Protected *ic, Hotspot.NSPoint
    Debug "---------------- create-cursor -----------------"
    If ImageID
      Hotspot\x = x
      Hotspot\y = y
      *ic = CocoaMessage(0, 0, "NSCursor alloc")
      CocoaMessage(0, *ic, "initWithImage:", ImageID, "hotSpot:@", @Hotspot)
    EndIf
    
    ProcedureReturn *ic
  EndProcedure
  
  Procedure   Change( GadgetID.i, state.b )
    ;If Not CocoaMessage(0, 0, "NSEvent pressedMouseButtons")
    Protected *cursor._s_cursor = objc_getAssociatedObject_(GadgetID, "__cursor")
    If *cursor And *cursor\hcursor
      ; reset
      If state = 0 
        CocoaMessage(0, *cursor\windowID, "enableCursorRects")
        If *cursor\hcursor = - 1
          CocoaMessage(0, 0, "NSCursor unhide")
        EndIf
      EndIf
      
      ; set
      If *cursor\hcursor <> CocoaMessage(0, 0, "NSCursor currentCursor")
        If state = 1 
          CocoaMessage(0, *cursor\windowID, "disableCursorRects")
          If *cursor\hcursor = - 1
            CocoaMessage(0, 0, "NSCursor hide")
          Else
            CocoaMessage(0, *cursor\hcursor, "set") 
          EndIf
        EndIf
        
        CompilerIf #PB_Compiler_IsMainFile
          Debug "changeCursor"
        CompilerEndIf
      EndIf
    EndIf
    ;EndIf
  EndProcedure
  
  Procedure   Set(Gadget.i, icursor.i)
    If Gadget >= 0
      Protected *cursor._s_cursor
      Protected GadgetID = GadgetID(Gadget)
      CompilerIf #PB_Compiler_IsMainFile
        Debug "setCursor "+ icursor
      CompilerEndIf
      
      *cursor = objc_getAssociatedObject_(GadgetID, "__cursor")
      
      If Not *cursor
        *cursor = AllocateStructure(_s_cursor)
        *cursor\windowID = ID::GetWindowID(GadgetID)
        objc_setAssociatedObject_(GadgetID, "__cursor", *cursor, 0) 
      EndIf
      ;Debug "------------- "+*cursor\icursor +" "+ icursor
        
      If *cursor\icursor <> icursor
        *cursor\icursor = icursor
        
        If icursor >= 0 And icursor <= 255
;           ; if ishidden cursor show cursor
;           If isHiden( )
;             CocoaMessage(0, 0, "NSCursor unhide")
;           EndIf
          
          Select icursor
            Case #PB_Cursor_Invisible : *cursor\hcursor = - 1
            Case #PB_Cursor_Busy 
              SetAnimatedThemeCursor(#kThemeWatchCursor, 0)
              
            Case #PB_Cursor_Default   : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor arrowCursor")
            Case #PB_Cursor_IBeam     : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor IBeamCursor")
            Case #PB_Cursor_Denied    : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor disappearingItemCursor")
              
            Case #PB_Cursor_Hand      : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor pointingHandCursor")
            Case #PB_Cursor_Cross     : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor crosshairCursor")
            Case #PB_Cursor_Arrows      : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor closedHandCursor")
              
            Case #PB_Cursor_Left      : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeLeftCursor")
            Case #PB_Cursor_Right     : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeRightCursor")
            Case #PB_Cursor_LeftRight : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeLeftRightCursor")
              
            Case #PB_Cursor_Up        : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeUpCursor")
            Case #PB_Cursor_Down      : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeDownCursor")
            Case #PB_Cursor_UpDown    : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeUpDownCursor")
;             Case #PB_Cursor_UpDown       
;               
;               
;               Define x = 0
;               Define y = 0
;               Define width = 16
;               Define height = 16;7
;               Define fcolor = $ffFFFFFF
;               Define bcolor = $ff000000
;               Define img = CreateImage(#PB_Any, width, height, 32, #PB_Image_Transparent)
;               Macro DrawUp2(x, y, size, bcolor, fcolor)
;                 Line(x+7, y, 2, 1, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;                 Plot(x+6, y+1, fcolor ) : Line(x+7, y+1, 2, 1, bcolor) : Plot(x+9, y+1, fcolor )                                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
;                 Plot(x+5, y+2, fcolor ) : Line(x+6, y+2, 4, 1, bcolor) : Plot(x+10, y+2, fcolor )                                  ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
;                 Plot(x+4, y+3, fcolor ) : Line(x+5, y+3, 6, 1, bcolor) : Plot(x+11, y+3, fcolor )                                  ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
;                 Line(x+4, y+4, 3, 1, fcolor) : Line(x+7, y+4, 2, 1, bcolor) : Line(x+size/2+1, y+4, 3 , 1, fcolor)                 ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
;                 Plot(x+size/2-2, y+5, fcolor ) : Line(x+7, y+5, 2, 1, bcolor) : Plot(x+size/2+1, y+5, fcolor )                     ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
;               EndMacro
;               Macro DrawCursorSplitterUp2(x, y, width, bcolor, fcolor)
;                 Line(x, y+6, width/2-1 , 1, fcolor) : Line(x+7, y+6, 2, 1, bcolor) : Line(x+width/2+1, y+6, width/2-1, 1, fcolor)   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
;                 Plot(x, y+7, fcolor ) : Line(x+1, y+7, width-2, 1, bcolor) : Plot(x+width-1, y+7, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
;               EndMacro
;               If StartDrawing(ImageOutput(img))
;                 DrawingMode(#PB_2DDrawing_AlphaBlend)
;                 Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
;                 ; up                                                 
;                 DrawUp2(x, y, width, bcolor, fcolor)
;                 DrawCursorSplitterUp2(x,y,width, bcolor, fcolor )
;                 Plot(x, y+8, fcolor ) : Line(x+1, y+8, width-2, 1, bcolor) : Plot(x+width-1, y+8, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
;                 Line(x, y + 9, width , 1, fcolor)                                                                                   ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;                 StopDrawing()
;               EndIf
;               
;               *cursor\hcursor = Create(ImageID(img), width/2, height/2)
              
            
              
            Case #PB_Cursor_LeftDownRightUp, #PB_Cursor_LeftDown, #PB_Cursor_RightUp
              *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeUpDownCursor")
            Case #PB_Cursor_LeftUpRightDown, #PB_Cursor_LeftUp, #PB_Cursor_RightDown 
              *cursor\hcursor = CocoaMessage(0, 0, "NSCursor resizeUpDownCursor")
              
            Case #PB_Cursor_Drag : *cursor\hcursor = New( icursor )
              ;Case #PB_Cursor_Drop      : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor dragCopyCursor")
            Case #PB_Cursor_Drop : *cursor\hcursor = New( icursor )
              
            Case #PB_Cursor_Grab      : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor openHandCursor")
            Case #PB_Cursor_Grabbing  : *cursor\hcursor = CocoaMessage(0, 0, "NSCursor closedHandCursor")
              
            EndSelect 
         Else
           *cursor\hcursor = icursor 
         EndIf
      EndIf
      
      If *cursor\hcursor And 
         GadgetID = mouse::Gadget(*cursor\windowID)
         EnteredID = GadgetID
         Change( GadgetID, 1 )
        ProcedureReturn #True
      EndIf
    EndIf
  EndProcedure
  
  Procedure   Get()
    Protected result.i, currentSystemCursor
    
    ;Debug ""+ CocoaMessage(@currentSystemCursor, 0, "NSCursor currentSystemCursor") +" "+ currentSystemCursor+" "+ CocoaMessage(0, 0, "NSCursor currentCursor")
    
    If isHiden( ) 
      result = #PB_Cursor_Invisible
    Else
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
    EndIf
    
    ProcedureReturn result
  EndProcedure
EndModule  
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --7f7---
; EnableXP