;-\\ MAC OS
CompilerIf #PB_Compiler_IsMainFile
   IncludePath "../"
   XIncludeFile "mac/id.pbi"
   XIncludeFile "mac/mouse.pbi"
   XIncludeFile "cursors.pbi"
CompilerEndIf

Module Cursor 
  #test_cursor = 0
  
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
    CGCursorIsVisible( )
  EndImport
  
  ImportC ""
    CFRunLoopGetCurrent( )
    CFRunLoopAddCommonMode(rl, mode)
    
    GetCurrentProcess(*psn)
    CGEventTapCreateForPSN(*psn, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
    CGEventTapCreate(tap.i, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
  EndImport
  
  Global eventTap, psn, EnteredID 
  
  
  ;   Structure ArrayOfMethods
  ;   i.i[0]
  ; EndStructure
  ; ImportC ""
  ;   class_copyMethodList(*Class, *p_methodCount)
  ;   ; -> An array of pointers of type Method describing
  ;   ;    the instance methods implemented by the class
  ;   ;    Any instance methods implemented by superclasses are Not included
  ;   ;    You must free the array with free( )
  ;   class_getName(*Class) ; -> UnsafePointer<Int8> -> *string
  ;   sel_getName(*Selector); -> const char *
  ;   method_getName(*Method) ; -> Selector
  ;   method_getTypeEncoding(*Method) ; -> const char *
  ;   method_getReturnType(*Method, *dst, dst_len) ; -> void
  ;   method_getNumberOfArguments(*Method)         ; -> unsigned int
  ;   method_getArgumentType(*Method, index, *dst, dst_len) ; -> void
  ;   
  ;   NSGetSizeAndAlignment(*StringPtr, *p_size, *p_align) 
  ;   ; -> const char *
  ;   ;    Obtains the actual size and the aligned size of an encoded type.
  ; EndImport
  
  ProcedureC  Proc(proxy, eType, event, refcon)
    Protected *cursor._s_cursor
    Protected handle
    Shared EnteredID
    Static PressedID
    
    If eType = #NSLeftMouseDown
      PressedID = mouse::Gadget(mouse::Window( ))
      
    ElseIf eType = #NSLeftMouseUp
      handle = mouse::Gadget(mouse::Window( ))
      
      If handle <> PressedID
        If PressedID  
          If handle
            *cursor = objc_getAssociatedObject_(handle, "__cursor")
            If Not ( *cursor And *cursor\hcursor )
              Cursor::change(PressedID, 0)
            EndIf
          Else
            Cursor::change(PressedID, 0)
          EndIf
        EndIf
        If handle 
          Cursor::change( handle, 1) 
        EndIf
      EndIf
      
      EnteredID = handle
      PressedID = #Null
      
    ElseIf eType = #NSMouseMoved
      Protected EnteredWindowID = mouse::Window( )
      handle = mouse::Gadget(EnteredWindowID)
      
      If EnteredID <> handle
        ; Debug ""+#PB_Compiler_Procedure+" "+EnteredID +" "+ handle
        If EnteredID
          If handle
            ;
            *cursor = objc_getAssociatedObject_(EnteredID, "__cursor")
            If *cursor And *cursor\hcursor = - 1
              If Not CocoaMessage(0, *cursor\windowID, "areCursorRectsEnabled")
                CocoaMessage(0, *cursor\windowID, "enableCursorRects")
              EndIf
              CocoaMessage(0, 0, "NSCursor unhide")
            EndIf
            
            ;
            *cursor = objc_getAssociatedObject_(handle, "__cursor")
            If Not ( *cursor And *cursor\hcursor ) 
              Cursor::change(EnteredID, 0)
            EndIf
          Else
            ;
            If EnteredWindowID And CocoaMessage(0, EnteredWindowID, "areCursorRectsEnabled")
              CocoaMessage(0, EnteredWindowID, "disableCursorRects")
            EndIf
            
            Cursor::change(EnteredID, 0)
            
            ;
            If EnteredWindowID And CocoaMessage(0, EnteredWindowID, "areCursorRectsEnabled")
              CocoaMessage(0, EnteredWindowID, "enableCursorRects")
            EndIf
          EndIf
        EndIf
        
        EnteredID = handle
        
        If EnteredID 
          Cursor::change(EnteredID, 1)
        EndIf
      EndIf
      
    Else ; appKitDefined
      If PressedID  
        ;        Define methodCount
        ;     Define *Methods.ArrayOfMethods = class_copyMethodList(object_getclass_(CocoaMessage(0, 0, "NSCursor currentSystemCursor")), @methodCount)
        ;     Debug *Methods\i[6]
        ;     Debug method_getName(*Methods\i[6])
        ;     Debug sel_getName(method_getName(*Methods\i[6]))
        ;     Debug PeekS(sel_getName(method_getName(*Methods\i[6])), -1, #PB_UTF8)
        ;     
        ; Debug CocoaMessage(0, 0, "NSCursor currentSystemCursor")
        ;         
        ; ;         Debug CocoaMessage(0, CocoaMessage(0, 0, "NSCursor currentSystemCursor"), "hotSpot")
        ; ;         Debug Point\x
        
        ;         Cursor::change(PressedID, 1)
        
        ;       Static count
        ;       Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
        ;         If NSEvent
        ;           Protected Window = CocoaMessage(0, NSEvent, "window")
        ;           If Window
        ;             ; If Not CocoaMessage(0, Window, "areCursorRectsEnabled")
        ;               Protected Point.NSPoint
        ;               CocoaMessage(@Point, NSEvent, "locationInWindow")
        ;               Protected contentView = CocoaMessage(0, Window, "contentView")
        ;               Protected hitTest = CocoaMessage(0, contentView, "hitTest:@", @Point)
        ;               If hitTest
        ;                 ;Debug hitTest
        ;                 If CocoaMessage(0, Window, "areCursorRectsEnabled")
        ;                   CocoaMessage(0, Window, "disableCursorRects")
        ;                 ;  CocoaMessage(0, CocoaMessage(0, 0, "NSCursor currentCursor"), "set")
        ;                 ;  Debug " reset "
        ;                 EndIf
        ;               Else
        ;                 If Not CocoaMessage(0, Window, "areCursorRectsEnabled")
        ; ;                   CocoaMessage(0, Window, "discardCursorRects")
        ; ;                   CocoaMessage(0, Window, "resetCursorRects")
        ;                   CocoaMessage(0, Window, "enableCursorRects")
        ;                 ;  CocoaMessage(0, CocoaMessage(0, 0, "NSCursor currentCursor"), "set")
        ;                  ; Debug " set "
        ;                 EndIf
        ;               EndIf
        ;               
        ;               
        ;               
        ; ;               ;CocoaMessage(0, Window, "enableCursorRects")
        ; ;               Debug ""+Window+" "+CocoaMessage(0, 0, "NSCursor currentCursor") +" "+ count
        ; ; ;               CocoaMessage(0, CocoaMessage(0, 0, "NSCursor currentCursor"), "push")
        ; ; ;                CocoaMessage(0, CocoaMessage(0, 0, "NSCursor openHandCursor"), "set")
        ; ; ;              CocoaMessage(0, CocoaMessage(0, 0, "NSCursor currentCursor"), "pop")
        ; ; ;               ;CocoaMessage(0, Window, "disableCursorRects")
        ; ;              count + 1 
        ; ; ;           
        ; ; ;           ;CocoaMessage(0, CocoaMessage(0, Window, "contentView"), "invalidateCursorRects")
        ; ; 
        ; ;           ; EndIf
        ;          EndIf
        ;         EndIf
        
      EndIf
      
      If eType = #NSCursorUpdate
        Debug "#NSCursorUpdate"
      EndIf
      
      CompilerIf #PB_Compiler_IsMainFile
        ; event =  __NSCFType
        Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
        Debug ""+eType +" "+ event +" "+ NSEvent ;+" "+ ID::ClassName(NSEvent) ; GetWindowTitle(GetActiveWindow( ))
                                                 ;CocoaMessage(0, WindowID(GetActiveWindow( )), "disableCursorRects")
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
  
  Global NewMap images.i( )
  
  ;-\\
  Procedure   Draw( Type.a )
    Protected Image
    Protected X = 0
    Protected Y = 0
    Protected size = 16
    Protected Width = size
    Protected Height = size
    Protected fcolor = $ffFFFFFF
    Protected bcolor = $ff000000
    
    ;\\
    Image = CreateImage(#PB_Any, Width, Height, 32, #PB_Image_Transparent)
    
    ;\\
    If StartDrawing(ImageOutput(Image))
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      Box(0,0,OutputWidth( ),OutputHeight( ), $A9B7B6)
      
      If Type = #__cursor_Arrows
        X = 8
        Y = 8
        Box(6,6,4,4, fcolor)
        DrawImageCursorUp(0,-1,Height, bcolor, fcolor )
        DrawImageCursorDown(0,7,Height, bcolor, fcolor )
        ;         
        DrawImageCursorLeft(-1,0,Width, bcolor, fcolor )
        DrawImageCursorRight(7,0,Width, bcolor, fcolor )
        Box(7,7,2,2, bcolor)
      EndIf
      
      ;\\
      If Type = #__cursor_LeftUp Or
         Type = #__cursor_RightDown Or
         Type = #__cursor_Diagonal1 
        X = 7
        Y = 7
        DrawImageCursorDiagonal1(0,0, size, bcolor, fcolor )
      EndIf
      If Type = #__cursor_LeftDown Or
         Type = #__cursor_RightUp Or
         Type = #__cursor_Diagonal2 
        X = 7
        Y = 7
        DrawImageCursorDiagonal2(0,0, size, bcolor, fcolor )
      EndIf
      
      ;\\
      If Type = #__cursor_SplitUp
        X = 8
        Y = 6
        DrawImageUp(0,-1,Height, bcolor, fcolor )
        DrawImageCursorSplitUp(0,-1,Height, bcolor, fcolor )
        Plot(0, 7, fcolor ) : Line(1, 7, Width-2, 1, bcolor) : Plot(Width-1, 7, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
        Line(0, 8, Width , 1, fcolor)                                                                             ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      EndIf
      If Type = #__cursor_UpDown
        X = 8
        Y = 6
        DrawImageCursorUp(0,-1,Height, bcolor, fcolor )
        DrawImageCursorDown(0,5,Height, bcolor, fcolor )
      EndIf
      If Type = #__cursor_SplitUpDown
        X = 8
        Y = 6
        DrawImageCursorSplitUp(0,-1,Height, bcolor, fcolor )
        DrawImageCursorSplitDown(0,5,Height, bcolor, fcolor )
      EndIf
      If Type = #__cursor_SplitDown
        X = 8
        Y = 6
        Line(0, 0, Width, 1, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        Plot(0, 1, fcolor ) : Line(1, 1, Width-2, 1, bcolor) : Plot(Width-1, 1, fcolor )                                     ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
        DrawImageCursorSplitDown(0,0,Height, bcolor, fcolor )
        DrawImageDown(0,0,Height, bcolor, fcolor )
      EndIf
      
      ;\\
      If Type = #__cursor_SplitLeft
        X = 6
        Y = 8
        DrawImageLeft(-1,0,Width, bcolor, fcolor )
        DrawImageCursorSplitLeft(-1,0,Width, bcolor, fcolor )
        Plot(7, 0, fcolor ) : Line(7, 1, 1, Height-2, bcolor) : Plot(7, Height-1, fcolor )                        ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
        Line(8, 0, 1, Height, fcolor)                                                                             ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      EndIf
      If Type = #__cursor_LeftRight
        X = 6
        Y = 8
        DrawImageCursorLeft(-1,0,Width, bcolor, fcolor )
        DrawImageCursorRight(5,0,Width, bcolor, fcolor )
      EndIf
      If Type = #__cursor_SplitLeftRight
        X = 6
        Y = 8
        DrawImageCursorSplitLeft(-1,0,Width, bcolor, fcolor )
        DrawImageCursorSplitRight(5,0,Width, bcolor, fcolor )
      EndIf
      If Type = #__cursor_SplitRight
        X = 6
        Y = 8
        Line(0, 0, 1, Width, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        Plot(1, 0, fcolor ) : Line(1, 1, 1, Width-2, bcolor) : Plot(1, Width-1, fcolor )                                     ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
        DrawImageCursorSplitRight(0,0,Width, bcolor, fcolor )
        DrawImageRight(0,0,Width, bcolor, fcolor )
      EndIf
      
      StopDrawing( )
    EndIf
    
    ProcedureReturn Create( ImageID( Image ), X, Y )
  EndProcedure
  
  
  Procedure   Image( Type.a = 0 )
    Protected Image
    
    If Type = #__cursor_Drop
      Image = CatchImage( #PB_Any, ?add, 601 )
    ElseIf Type = #__cursor_Drag
      Image = CatchImage( #PB_Any, ?copy, 530 )
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
    
    ProcedureReturn Image
  EndProcedure
  
  Procedure New( Type.a, ImageID.i )
    If Not FindMapElement(images( ), Str(Type))
      AddMapElement(images( ), Str(Type))
      images( ) = ImageID
    EndIf
    
    ProcedureReturn ImageID
  EndProcedure
  
  Procedure   Free(*cursor) 
    ; Debug "cursor-free "+*cursor
    
    If *cursor >= 0 And *cursor <= 255
      If FindMapElement(images( ), Str(*cursor))
        DeleteMapElement(images( ));, Str(*cursor))
      EndIf
    Else
      If MapSize(images( ))
        ForEach images( )
          If *cursor = images( )
            DeleteMapElement(images( ))
          EndIf
        Next
     EndIf
     
       ; CocoaMessage(0, *cursor, "autorelease")
        
      ProcedureReturn CocoaMessage(0, *cursor, "release")
    EndIf
  EndProcedure
  
  Procedure   isHiden( )
    ProcedureReturn Bool( CGCursorIsVisible( ) = 0 )
  EndProcedure
  
  Procedure   Hide(state.b)
    If state
      CocoaMessage(0, 0, "NSCursor hide")
    Else
      CocoaMessage(0, 0, "NSCursor unhide")
    EndIf
  EndProcedure
  
  Procedure.i Create( ImageID.i, X.l = 0, Y.l = 0 )
    Protected *ic, Hotspot.NSPoint
    If ImageID
      CompilerIf #test_cursor
        Debug " ::---------------- create-cursor -----------------"
      CompilerEndIf
      Hotspot\x = X
      Hotspot\y = Y
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
        ;         Protected EnteredWindowID = Mouse::window( )
        ;         If EnteredWindowID 
        ;           CocoaMessage(0, EnteredWindowID, "disableCursorRects")
        ;         EndIf
        If Not CocoaMessage(0, *cursor\windowID, "areCursorRectsEnabled")
          CocoaMessage(0, *cursor\windowID, "enableCursorRects")
        EndIf
        If *cursor\hcursor = - 1
          CocoaMessage(0, 0, "NSCursor unhide")
        EndIf
      EndIf
      
      
      ; set
      If *cursor\hcursor <> CocoaMessage(0, 0, "NSCursor currentCursor")
        If state > 0 
          If CocoaMessage(0, *cursor\windowID, "areCursorRectsEnabled")
            CocoaMessage(0, *cursor\windowID, "disableCursorRects")
          EndIf
          
          If *cursor\hcursor = - 1
            CocoaMessage(0, 0, "NSCursor hide")
          Else
             CocoaMessage(0, *cursor\hcursor, "set") 
          EndIf
        EndIf
        
        CompilerIf #test_cursor
          Debug " ::changeCursor " + *cursor\hcursor +" "+ state
        CompilerEndIf
        ProcedureReturn #True
      EndIf
    EndIf
    ;EndIf
  EndProcedure
  
  Procedure   Set( Gadget.i, *cursor )
    Protected *memory._s_cursor
    
    With *memory
      If IsGadget( Gadget )
        Protected GadgetID = GadgetID( Gadget )
        
        CompilerIf #test_cursor
          Debug " ::setCursor "+ GadgetType( Gadget ) +" "+ *cursor ; +" "+ GadgetID +"="+ mouse::Gadget( ID::GetWindowID(GadgetID) ) +" mousebuttonsstate-"+ CocoaMessage(0, 0, "NSEvent pressedMouseButtons")
        CompilerEndIf
        
        *memory = objc_getAssociatedObject_( GadgetID, "__cursor" )
        ; object_getInstanceVariable_(GadgetID, "__cursor", @*memory)
        
        If Not *memory
          *memory = AllocateStructure( _s_cursor )
          \windowID = ID::GetWindowID( GadgetID )
          objc_setAssociatedObject_( GadgetID, "__cursor", *memory, 0 ) 
          ; object_setInstanceVariable_(GadgetID, "__cursor", *memory)
        EndIf
        
        If \type <> *cursor
          If \hcursor > 0
            Select \type
              Case #__cursor_Drag, #__cursor_Drop,
                   #__cursor_Arrows, #__cursor_LeftRight, #__cursor_UpDown,
                   #__cursor_Diagonal1, #__cursor_LeftUp, #__cursor_RightDown, 
                   #__cursor_Diagonal2, #__cursor_RightUp, #__cursor_LeftDown
                cursor::Free( \hcursor )
            EndSelect
          EndIf
          \type = *cursor
          
          ;\\
          If *cursor > 255
            \hcursor = *cursor 
          Else
            ;           ; if ishidden cursor show cursor
            ;           If isHiden( )
            ;             CocoaMessage(0, 0, "NSCursor unhide")
            ;           EndIf
            
            Select *cursor
              Case #__cursor_Invisible : \hcursor = - 1
              Case #__cursor_Busy 
                SetAnimatedThemeCursor(#kThemeWatchCursor, 0)
                
              Case #__cursor_Default        : \hcursor = CocoaMessage(0, 0, "NSCursor arrowCursor")
              Case #__cursor_IBeam          : \hcursor = CocoaMessage(0, 0, "NSCursor IBeamCursor")
              Case #__cursor_Denied         : \hcursor = CocoaMessage(0, 0, "NSCursor disappearingItemCursor")
                
              Case #__cursor_Hand           : \hcursor = CocoaMessage(0, 0, "NSCursor pointingHandCursor")
              Case #__cursor_Cross          : \hcursor = CocoaMessage(0, 0, "NSCursor crosshairCursor")
                
              Case #__cursor_SplitLeft      : \hcursor = CocoaMessage(0, 0, "NSCursor resizeLeftCursor")
              Case #__cursor_SplitRight     : \hcursor = CocoaMessage(0, 0, "NSCursor resizeRightCursor")
              Case #__cursor_SplitLeftRight : \hcursor = CocoaMessage(0, 0, "NSCursor resizeLeftRightCursor")
                
              Case #__cursor_SplitUp        : \hcursor = CocoaMessage(0, 0, "NSCursor resizeUpCursor")
              Case #__cursor_SplitDown      : \hcursor = CocoaMessage(0, 0, "NSCursor resizeDownCursor")
              Case #__cursor_SplitUpDown    : \hcursor = CocoaMessage(0, 0, "NSCursor resizeUpDownCursor")
                
              Case #__cursor_Arrows, #__cursor_LeftRight, #__cursor_UpDown,
                   #__cursor_Diagonal1, #__cursor_LeftUp, #__cursor_RightDown, 
                   #__cursor_Diagonal2, #__cursor_RightUp, #__cursor_LeftDown 
                
                \hcursor = New( *cursor, Draw( *cursor ) )
                
              Case #__cursor_Drag : \hcursor = New( *cursor, Create(ImageID(Image( *cursor ))) )
                ;Case #__cursor_Drop      : \hcursor = CocoaMessage(0, 0, "NSCursor dragCopyCursor")
              Case #__cursor_Drop : \hcursor = New( *cursor, Create(ImageID(Image( *cursor ))) )
                
              Case #__cursor_Grab      : \hcursor = CocoaMessage(0, 0, "NSCursor openHandCursor")
              Case #__cursor_Grabbing  : \hcursor = CocoaMessage(0, 0, "NSCursor closedHandCursor")
                
            EndSelect 
          EndIf
        EndIf
        
        
        If \hcursor And 
           ( GadgetID = mouse::Gadget( \windowID ) Or
             CocoaMessage(0, 0, "NSEvent pressedMouseButtons") )
          EnteredID = GadgetID
          cursor::Change( GadgetID, 1 )
          ProcedureReturn #True
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure   Get( )
    Protected result.i, currentSystemCursor
    
    ;Debug ""+ CocoaMessage(@currentSystemCursor, 0, "NSCursor currentSystemCursor") +" "+ currentSystemCursor+" "+ CocoaMessage(0, 0, "NSCursor currentCursor")
    
    If isHiden( ) 
      result = #__cursor_Invisible
    Else
      Select CocoaMessage(0, 0, "NSCursor currentCursor")
        Case CocoaMessage(0, 0, "NSCursor arrowCursor") : result = #__cursor_Default
        Case CocoaMessage(0, 0, "NSCursor IBeamCursor") : result = #__cursor_IBeam
          ; Case CocoaMessage(0, 0, "NSCursor IBeamCursorForVerticalLayoutCursor") : result = #__cursor_VIBeam
          
        Case CocoaMessage(0, 0, "NSCursor dragCopyCursor") : result = #__cursor_Drop
        Case CocoaMessage(0, 0, "NSCursor operationNotAllowedCursor") : result = #__cursor_Drag
        Case CocoaMessage(0, 0, "NSCursor disappearingItemCursor") : result = #__cursor_Denied
          
        Case CocoaMessage(0, 0, "NSCursor crosshairCursor") : result = #__cursor_Cross
        Case CocoaMessage(0, 0, "NSCursor pointingHandCursor") : result = #__cursor_Hand
        Case CocoaMessage(0, 0, "NSCursor openHandCursor") : result = #__cursor_Grab
        Case CocoaMessage(0, 0, "NSCursor closedHandCursor") : result = #__cursor_Grabbing
          
        Case CocoaMessage(0, 0, "NSCursor resizeUpCursor") : result = #__cursor_SplitUp
        Case CocoaMessage(0, 0, "NSCursor resizeDownCursor") : result = #__cursor_SplitDown
        Case CocoaMessage(0, 0, "NSCursor resizeUpDownCursor") : result = #__cursor_SplitUpDown
          
        Case CocoaMessage(0, 0, "NSCursor resizeLeftCursor") : result = #__cursor_SplitLeft
        Case CocoaMessage(0, 0, "NSCursor resizeRightCursor") : result = #__cursor_SplitRight
        Case CocoaMessage(0, 0, "NSCursor resizeLeftRightCursor") : result = #__cursor_SplitLeftRight
      EndSelect 
    EndIf
    
    ProcedureReturn result
  EndProcedure
EndModule  
; IDE Options = PureBasic 5.46 LTS (MacOS X - x64)
; CursorPosition = 2
; Folding = -------------
; EnableXP