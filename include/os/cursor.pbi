CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "id.pbi"
   XIncludeFile "mouse.pbi"
CompilerEndIf

;-\\ DECLARE
DeclareModule Cursor
   EnableExplicit
   UsePNGImageDecoder()
   #test_cursor = 0
   
   Enumeration 
      #__cursor_Default         ; = 0 
      #__cursor_Cross           ; = 1 
      #__cursor_IBeam           ; = 2 
      #__cursor_Hand            ; = 3  
      #__cursor_Busy            ; = 4  
      #__cursor_Denied          ; = 5  
      #__cursor_Arrows          ; = 6  
      
      #__cursor_UpDown          ; = 7 
      #__cursor_LeftRight       ; = 8 
      #__cursor_Diagonal1       ; = 9
      #__cursor_Diagonal2       ; = 10
      
      #__cursor_Invisible       ; = 11
      
      #__cursor_SplitUp 
      #__cursor_SplitDown           
      #__cursor_SplitLeft  
      #__cursor_SplitRight           
      #__cursor_SplitUpDown      
      #__cursor_SplitLeftRight  
      
      #__cursor_LeftUp
      #__cursor_RightUp
      #__cursor_LeftDown
      #__cursor_RightDown
      
      #__cursor_Drag
      #__cursor_Drop
      
      #__cursor_Grab            
      #__cursor_Grabbing
      #__cursor_VIBeam
      ;#__cursor_Arrow 
      
      CompilerIf #PB_Compiler_OS = #PB_OS_Linux
         #__cursor_Up 
         #__cursor_Down           
         #__cursor_Left  
         #__cursor_Right           
      CompilerEndIf
   EndEnumeration
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or 
              #PB_Compiler_OS = #PB_OS_MacOS
      #__cursor_Up    = #__cursor_UpDown
      #__cursor_Down  = #__cursor_UpDown       
      #__cursor_Left  = #__cursor_LeftRight
      #__cursor_Right = #__cursor_LeftRight        
   CompilerEndIf
   
   #__cursor_LeftUpRightDown = #__cursor_Diagonal1
   #__cursor_LeftDownRightUp = #__cursor_Diagonal2
   
   Structure _s_cursor
      Type.a
      *hcursor
      windowID.i
   EndStructure
   
   ;Declare   isHiden( )
   ;Declare   Hide( state.b )
   Declare   Free( *cursor )
   ;Declare   Get( )
   ;Declare   Clip( x.l,y.l,width.l,height.l )
   Declare   Image( Type.a = 0 )
   Declare   Set( Gadget.i, *cursor );, x.i = 0, y.i = 0)
   Declare   Change( GadgetID.i, state.b )
   Declare.i Create( ImageID.i, X.l = 0, Y.l = 0 )
   
   
   ;\\
   Macro DI_Up(X, Y, size, bcolor, fcolor)
      Line(X+size/2-1, Y  , 2, 1, fcolor)                                                                                       ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      Plot(X+size/2-2, Y+1, fcolor )      : Line(X+size/2-1, Y+1, 2, 1, bcolor) : Plot(X+size/2+1, Y+1, fcolor )                ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X+size/2-3, Y+2, fcolor )      : Line(X+size/2-2, Y+2, 4, 1, bcolor) : Plot(X+size/2+2, Y+2, fcolor )                ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
      Plot(X+size/2-4, Y+3, fcolor )      : Line(X+size/2-3, Y+3, 6, 1, bcolor) : Plot(X+size/2+3, Y+3, fcolor )                ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
      Line(X+size/2-4, Y+4, 3, 1, fcolor) : Line(X+size/2-1, Y+4, 2, 1, bcolor) : Line(X+size/2+1, Y+4, 3 , 1, fcolor)          ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X+size/2-2, Y+5, fcolor )      : Line(X+size/2-1, Y+5, 2, 1, bcolor) : Plot(X+size/2+1, Y+5, fcolor )                ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
   EndMacro
   Macro DI_Down(X, Y, size, bcolor, fcolor)
      Plot(X+size/2-2, Y+4, fcolor )      : Line(X+size/2-1, Y+4, 2, 1, bcolor) : Plot(X+size/2+1, Y+4, fcolor )                     ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Line(X+size/2-4, Y+5, 3, 1, fcolor) : Line(X+size/2-1, Y+5, 2, 1, bcolor) : Line(X+size/2+1, Y+5, 3, 1, fcolor)                ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X+size/2-4, Y+6, fcolor )      : Line(X+size/2-3, Y+6, 6, 1, bcolor) : Plot(X+size/2+3, Y+6, fcolor )                     ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
      Plot(X+size/2-3, Y+7, fcolor )      : Line(X+size/2-2, Y+7, 4, 1, bcolor) : Plot(X+size/2+2, Y+7, fcolor )                     ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
      Plot(X+size/2-2, Y+8, fcolor )      : Line(X+size/2-1, Y+8, 2, 1, bcolor) : Plot(X+size/2+1, Y+8, fcolor )                     ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Line(X+size/2-1, Y+9, 2, 1, fcolor)                                                                                            ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   EndMacro
   Macro DI_Left(X, Y, size, bcolor, fcolor)
      Line(X  , Y+size/2-1, 1, 2, fcolor)                                                                                          ; 0,0,0,0,0,0,0,0,0
      Plot(X+1, Y+size/2-2, fcolor )      : Line(X+1, Y+size/2-1, 1, 2, bcolor) : Plot(X+1, Y+size/2+1, fcolor )                   ; 1,0,0,0,0,0,0,0,0
      Plot(X+2, Y+size/2-3, fcolor )      : Line(X+2, Y+size/2-2, 1, 4, bcolor) : Plot(X+2, Y+size/2+2, fcolor )                   ; 1,0,0,0,0,0,0,0,0
      Plot(X+3, Y+size/2-4, fcolor )      : Line(X+3, Y+size/2-3, 1, 6, bcolor) : Plot(X+3, Y+size/2+3, fcolor )                   ; 1,0,0,0,0,0,0,0,0
      Line(X+4, Y+size/2-4, 1, 3, fcolor) : Line(X+4, Y+size/2-1, 1, 2, bcolor) : Line(X+4, Y+size/2+1, 1, 3, fcolor)              ; 1,0,0,0,0,0,0,0,0
      Plot(X+5, Y+size/2-2, fcolor )      : Line(X+5, Y+size/2-1, 1, 2, bcolor) : Plot(X+5, Y+size/2+1, fcolor )                   ; 1,0,0,0,0,1,0,0,0
   EndMacro  
   Macro DI_Right(X, Y, size, bcolor, fcolor)
      Plot(X+4, Y+size/2-2, fcolor )      : Line(X+4, Y+size/2-1, 1, 2, bcolor) : Plot(X+4, Y+size/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Line(X+5, Y+size/2-4, 1, 3, fcolor) : Line(X+5, Y+size/2-1, 1, 2, bcolor) : Line(X+5, Y+size/2+1, 1, 3, fcolor)               ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X+6, Y+size/2-4, fcolor )      : Line(X+6, Y+size/2-3, 1, 6, bcolor) : Plot(X+6, Y+size/2+3, fcolor )                    ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
      Plot(X+7, Y+size/2-3, fcolor )      : Line(X+7, Y+size/2-2, 1, 4, bcolor) : Plot(X+7, Y+size/2+2, fcolor )                    ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
      Plot(X+8, Y+size/2-2, fcolor )      : Line(X+8, Y+size/2-1, 1, 2, bcolor) : Plot(X+8, Y+size/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Line(X+9, Y+size/2-1, 1, 2, fcolor)                                                                                           ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   EndMacro
   
   ;-
   Macro DI_CursorUp(X, Y, size, bcolor, fcolor)
      cursor::DI_Up(X, Y, size, bcolor, fcolor)
      Plot(X+size/2-2, Y+6, fcolor ) : Line(X+7, Y+6, 2, 1, bcolor) : Plot(X+size/2+1, Y+6, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X+size/2-2, Y+7, fcolor ) : Line(X+7, Y+7, 2, 1, bcolor) : Plot(X+size/2+1, Y+7, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
   EndMacro
   Macro DI_CursorDown(X, Y, size, bcolor, fcolor)
      Plot(X+size/2-2, Y+2, fcolor ) : Line(X+7, Y+2, 2, 1, bcolor) : Plot(X+size/2+1, Y+2, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X+size/2-2, Y+3, fcolor ) : Line(X+7, Y+3, 2, 1, bcolor) : Plot(X+size/2+1, Y+3, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      cursor::DI_Down(X, Y, size, bcolor, fcolor)
   EndMacro
   Macro DI_CursorLeft(X, Y, size, bcolor, fcolor)
      cursor::DI_Left(X, Y, size, bcolor, fcolor)
      Plot(X+6, Y+size/2-2, fcolor ) : Line(X+6, Y+7, 1, 2, bcolor) : Plot(X+6, Y+size/2+1, fcolor )                    ; 1,0,0,0,0,1,0,0,0
      Plot(X+7, Y+size/2-2, fcolor ) : Line(X+7, Y+7, 1, 2, bcolor) : Plot(X+7, Y+size/2+1, fcolor )                    ; 1,0,0,0,0,1,0,0,0
   EndMacro  
   Macro DI_CursorRight(X, Y, size, bcolor, fcolor)
      Plot(X+2, Y+size/2-2, fcolor ) : Line(X+2, Y+7, 1, 2, bcolor) : Plot(X+2, Y+size/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X+3, Y+size/2-2, fcolor ) : Line(X+3, Y+7, 1, 2, bcolor) : Plot(X+3, Y+size/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      cursor::DI_Right(X, Y, size, bcolor, fcolor)
   EndMacro
   
   ;-
   Macro DI_CursorSplitUp(X, Y, size, bcolor, fcolor)
      cursor::DI_Up(X, Y, size, bcolor, fcolor)
      Line(X, Y+6, size/2-1 , 1, fcolor) : Line(X+size/2-1, Y+6, 2, 1, bcolor) : Line(X+size/2+1, Y+6, size/2-1, 1, fcolor)   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X, Y+7, fcolor ) : Line(X+1, Y+7, size-2, 1, bcolor) : Plot(X+size-1, Y+7, fcolor )                                ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
   EndMacro
   Macro DI_CursorSplitDown(X, Y, size, bcolor, fcolor)
      Plot(X, Y+2, fcolor ) : Line(X+1, Y+2, size-2, 1, bcolor) : Plot(X+size-1, Y+2, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      Line(X, Y+3, size/2-1, 1, fcolor) : Line(X+size/2-1, Y+3, 2, 1, bcolor) : Line(X+size/2+1, Y+3, size/2-1 , 1, fcolor)   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      cursor::DI_Down(X, Y, size, bcolor, fcolor)
   EndMacro
   Macro DI_CursorSplitLeft(X, Y, size, bcolor, fcolor)
      cursor::DI_Left(X, Y, size, bcolor, fcolor)
      Line(X+6, Y , 1, size/2-1, fcolor) : Line(X+6, Y+size/2-1, 1, 2, bcolor) : Line(X+6, Y+size/2+1, 1, size/2-1, fcolor)   ; 1,0,0,0,0,1,1,0,0
      Plot(X+7, Y, fcolor ) : Line(X+7, Y+1, 1, size-2, bcolor) : Plot(X+7, Y+size-1, fcolor )                                ; 1,1,1,1,1,1,1,1,0
   EndMacro  
   Macro DI_CursorSplitRight(X, Y, size, bcolor, fcolor)
      Plot(X+2, Y, fcolor ) : Line(X+2, Y+1, 1, size-2, bcolor) : Plot(X+2, Y+size-1, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      Line(X+3, Y, 1, size/2-1, fcolor) : Line(X+3, Y+size/2-1, 1, 2, bcolor) : Line(X+3, Y+size/2+1, 1, size/2-1, fcolor)    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      cursor::DI_Right(X, Y, size, bcolor, fcolor)
   EndMacro
   
   ;-
   Macro DI_CursorSplitV(X, Y, Width, Height, bcolor, fcolor)
      cursor::DI_Up(X, Y, Width, bcolor, fcolor)
      cursor::DI_CursorSplitUp(X,Y,Width, bcolor, fcolor )
      cursor::DI_CursorSplitDown(X,Y+Height-1,Width, bcolor, fcolor )
      cursor::DI_Down(X, Y+Height-1, Width, bcolor, fcolor)
   EndMacro
   Macro DI_CursorSplitH(X, Y, Height, Width, bcolor, fcolor)
      cursor::DI_Left(X, Y, Width, bcolor, fcolor)
      cursor::DI_CursorSplitLeft(X,Y,Width, bcolor, fcolor )
      cursor::DI_CursorSplitRight(X,Y+Height-1,Width, bcolor, fcolor )
      cursor::DI_Right(X, Y+Height-1, Width, bcolor, fcolor)
   EndMacro
   
   Macro DI_CursorDiagonal1(X, Y, size, bcolor, fcolor)
      LineXY(X+3,Y+2,X+13,Y+12,bcolor)
      LineXY(X+2,Y+2,X+13,Y+13,bcolor)
      LineXY(X+2,Y+3,X+12,Y+13,bcolor)
      
      Plot(X+12,Y+10,bcolor)
      Plot(X+10,Y+12,bcolor)
      Plot(X+5,Y+3,bcolor)
      Plot(X+3,Y+5,bcolor)
      
      Line(X+2,Y+4,1,3,bcolor)
      Line(X+4,Y+2,3,1,bcolor)
      Line(X+9,Y+13,3,1,bcolor)
      Line(X+13,Y+9,1,3,bcolor)
      
      ;
      LineXY(X+6,Y+4,X+11,Y+9,fcolor)
      LineXY(X+4,Y+6,X+9,Y+11,fcolor)
      
      LineXY(X+2,Y+7,X+3,Y+6,fcolor)
      LineXY(X+7,Y+2,X+6,Y+3,fcolor)
      LineXY(X+8,Y+13,X+9,Y+12,fcolor)
      LineXY(X+13,Y+8,X+12,Y+9,fcolor)
      
      Line(X+1,Y+2,1,6,fcolor)
      Line(X+14,Y+8,1,6,fcolor)
      Line(X+2,Y+1,6,1,fcolor)
      Line(X+8,Y+14,6,1,fcolor)
   EndMacro
   Macro DI_CursorDiagonal2(X, Y, size, bcolor, fcolor)
      LineXY(X+2,Y+12,X+12,Y+2,bcolor)
      LineXY(X+2,Y+13,X+13,Y+2,bcolor)
      LineXY(X+3,Y+13,X+13,Y+3,bcolor)
      
      Plot(X+3,Y+10,bcolor)
      Plot(X+10,Y+3,bcolor)
      Plot(X+5,Y+12,bcolor)
      Plot(X+12,Y+5,bcolor)
      
      Line(X+2,Y+9,1,3,bcolor)
      Line(X+9,Y+2,3,1,bcolor)
      Line(X+4,Y+13,3,1,bcolor)
      Line(X+13,Y+4,1,3,bcolor)
      
      ;
      LineXY(X+4,Y+9,X+9,Y+4,fcolor)
      LineXY(X+6,Y+11,X+11,Y+6,fcolor)
      
      LineXY(X+2,Y+8,X+3,Y+9,fcolor)
      LineXY(X+8,Y+2,X+9,Y+3,fcolor)
      LineXY(X+6,Y+12,X+7,Y+13,fcolor)
      LineXY(X+12,Y+6,X+13,Y+7,fcolor)
      
      Line(X+1,Y+8,1,6,fcolor)
      Line(X+8,Y+1,6,1,fcolor)
      Line(X+2,Y+14,6,1,fcolor)
      Line(X+14,Y+2,1,6,fcolor)
   EndMacro
   
   
EndDeclareModule

Module Cursor
   ;-
   ;- >>> [MACOS] <<<
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
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
               DI_CursorUp(0,-1,Height, bcolor, fcolor )
               DI_CursorDown(0,7,Height, bcolor, fcolor )
               ;         
               DI_CursorLeft(-1,0,Width, bcolor, fcolor )
               DI_CursorRight(7,0,Width, bcolor, fcolor )
               Box(7,7,2,2, bcolor)
            EndIf
            
            ;\\
            If Type = #__cursor_LeftUp Or
               Type = #__cursor_RightDown Or
               Type = #__cursor_Diagonal1 
               X = 7
               Y = 7
               DI_CursorDiagonal1(0,0, size, bcolor, fcolor )
            EndIf
            If Type = #__cursor_LeftDown Or
               Type = #__cursor_RightUp Or
               Type = #__cursor_Diagonal2 
               X = 7
               Y = 7
               DI_CursorDiagonal2(0,0, size, bcolor, fcolor )
            EndIf
            
            ;\\
            If Type = #__cursor_SplitUp
               X = 8
               Y = 6
               DI_Up(0,-1,Height, bcolor, fcolor )
               DI_CursorSplitUp(0,-1,Height, bcolor, fcolor )
               Plot(0, 7, fcolor ) : Line(1, 7, Width-2, 1, bcolor) : Plot(Width-1, 7, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
               Line(0, 8, Width , 1, fcolor)                                                                             ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
            EndIf
            If Type = #__cursor_UpDown
               X = 8
               Y = 6
               DI_CursorUp(0,-1,Height, bcolor, fcolor )
               DI_CursorDown(0,5,Height, bcolor, fcolor )
            EndIf
            If Type = #__cursor_SplitUpDown
               X = 8
               Y = 6
               DI_CursorSplitUp(0,-1,Height, bcolor, fcolor )
               DI_CursorSplitDown(0,5,Height, bcolor, fcolor )
            EndIf
            If Type = #__cursor_SplitDown
               X = 8
               Y = 6
               Line(0, 0, Width, 1, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
               Plot(0, 1, fcolor ) : Line(1, 1, Width-2, 1, bcolor) : Plot(Width-1, 1, fcolor )                                     ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
               DI_CursorSplitDown(0,0,Height, bcolor, fcolor )
               DI_Down(0,0,Height, bcolor, fcolor )
            EndIf
            
            ;\\
            If Type = #__cursor_SplitLeft
               X = 6
               Y = 8
               DI_Left(-1,0,Width, bcolor, fcolor )
               DI_CursorSplitLeft(-1,0,Width, bcolor, fcolor )
               Plot(7, 0, fcolor ) : Line(7, 1, 1, Height-2, bcolor) : Plot(7, Height-1, fcolor )                        ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
               Line(8, 0, 1, Height, fcolor)                                                                             ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
            EndIf
            If Type = #__cursor_LeftRight
               X = 6
               Y = 8
               DI_CursorLeft(-1,0,Width, bcolor, fcolor )
               DI_CursorRight(5,0,Width, bcolor, fcolor )
            EndIf
            If Type = #__cursor_SplitLeftRight
               X = 6
               Y = 8
               DI_CursorSplitLeft(-1,0,Width, bcolor, fcolor )
               DI_CursorSplitRight(5,0,Width, bcolor, fcolor )
            EndIf
            If Type = #__cursor_SplitRight
               X = 6
               Y = 8
               Line(0, 0, 1, Width, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
               Plot(1, 0, fcolor ) : Line(1, 1, 1, Width-2, bcolor) : Plot(1, Width-1, fcolor )                                     ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
               DI_CursorSplitRight(0,0,Width, bcolor, fcolor )
               DI_Right(0,0,Width, bcolor, fcolor )
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
   CompilerEndIf
   
   ;-
   ;- >>> [WINDOWS] <<<
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      #test_cursor = 0
      #SM_CXCURSOR = 13
      #SM_CYCURSOR = 14 
      
      CompilerIf #PB_Compiler_Version =< 546
         #CURSOR_SHOWING = 1
         
         Macro DesktopResolutionX( )
            (GetDeviceCaps_(GetDC_(0),#LOGPIXELSX) / 96)
         EndMacro
         Macro DesktopResolutionY( )
            (GetDeviceCaps_(GetDC_(0),#LOGPIXELSY) / 96)
         EndMacro
         Macro DesktopScaledX( _x_ )
            (_x_ * DesktopResolutionX( ))
         EndMacro
         Macro DesktopScaledY( _y_ )
            (_y_ * DesktopResolutionY( ))
         EndMacro
         Macro DesktopUnscaledX( _x_ )
            ( _x_ / DesktopResolutionX( ))
         EndMacro
         Macro DesktopUnscaledY( _y_ )
            (_y_ / DesktopResolutionY( ))
         EndMacro
         
      CompilerEndIf
      
      
      Procedure   Proc(hWnd, uMsg, wParam, lParam)
         Protected result
         Protected oldproc = GetProp_(hWnd, "#__oldproc_cursor")
         
         Select uMsg
            Case #WM_DESTROY
               Debug "event( DESTROY ) "+hwnd
               ;       Case #WM_NCDESTROY
               ;         Debug "event( NC_DESTROY ) "+hwnd
               RemoveProp_(hwnd, "#__cursor")
               RemoveProp_(hwnd, "#__oldproc_cursor")
               
            Case #WM_SETCURSOR
               ; Debug " -  #WM_SETCURSOR "+wParam +" "+ lParam +" "+ Mouse::Gadget(Mouse::Window( ))
               Cursor::Change( wParam, 1 )
               
            Default
               result = CallWindowProc_(oldproc, hWnd, uMsg, wParam, lParam)
         EndSelect
         
         ProcedureReturn result
      EndProcedure
      
      Global NewMap images.i( )
      
      Procedure   Draw( Type.a )
         Protected Image
         Protected X = 0
         Protected Y = 0
         Protected size = (16)
         Protected Width = (size)
         Protected Height = (size)
         Protected fcolor = $ffFFFFFF
         Protected bcolor = $ff000000
         
         ; https://rusproject.narod.ru/winapi/g/getsystemmetrics.html
         ;     Width = GetSystemMetrics_( #SM_CXCURSOR )
         ;     Height = GetSystemMetrics_( #SM_CYCURSOR )
         
         ;\\
         Image = CreateImage(#PB_Any, Width, Height, 32, #PB_Image_Transparent)
         
         ;\\
         If StartDrawing(ImageOutput(Image))
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            Box(0,0,OutputWidth( ),OutputHeight( ), $A9B7B6)
            
            If Type = #__cursor_Arrows
               Box(6,6,4,4, fcolor)
               DI_CursorUp(0,-1,Height, bcolor, fcolor )
               DI_CursorDown(0,7,Height, bcolor, fcolor )
               ;         
               DI_CursorLeft(-1,0,Width, bcolor, fcolor )
               DI_CursorRight(7,0,Width, bcolor, fcolor )
               Box(7,7,2,2, bcolor)
            EndIf
            
            ;\\
            If Type = #__cursor_LeftUp Or
               Type = #__cursor_RightDown Or
               Type = #__cursor_Diagonal1 
               DI_CursorDiagonal1(0,0, size, bcolor, fcolor )
            EndIf
            If Type = #__cursor_LeftDown Or
               Type = #__cursor_RightUp Or
               Type = #__cursor_Diagonal2 
               DI_CursorDiagonal2(0,0, size, bcolor, fcolor )
            EndIf
            
            ;\\
            If Type = #__cursor_SplitUp
               DI_Up(0,0,Height, bcolor, fcolor )
               DI_CursorSplitUp(0,0,Height, bcolor, fcolor )
               Plot(0, 8, fcolor ) : Line(1, 8, Width-2, 1, bcolor) : Plot(Width-1, 8, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
               Line(0, 9, Width , 1, fcolor)                                                                             ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
            EndIf
            If Type = #__cursor_UpDown
               DI_CursorUp(0,-1,Height, bcolor, fcolor )
               DI_CursorDown(0,5,Height, bcolor, fcolor )
            EndIf
            If Type = #__cursor_SplitUpDown
               DI_CursorSplitUp(0,-1,Height, bcolor, fcolor )
               DI_CursorSplitDown(0,5,Height, bcolor, fcolor )
            EndIf
            If Type = #__cursor_SplitDown
               Line(0, 0, Width, 1, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
               Plot(0, 1, fcolor ) : Line(1, 1, Width-2, 1, bcolor) : Plot(Width-1, 1, fcolor )                                     ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
               DI_CursorSplitDown(0,0,Height, bcolor, fcolor )
               DI_Down(0,0,Height, bcolor, fcolor )
            EndIf
            
            ;\\
            If Type = #__cursor_SplitLeft
               DI_Left(0,0,Width, bcolor, fcolor )
               DI_CursorSplitLeft(0,0,Width, bcolor, fcolor )
               Plot(8, 0, fcolor ) : Line(8, 1, 1, Height-2, bcolor) : Plot(8, Height-1, fcolor )                        ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
               Line(9, 0, 1, Height, fcolor)                                                                             ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
            EndIf
            If Type = #__cursor_LeftRight
               X = 6
               Y = 8
               DI_CursorLeft(-1,0,Width, bcolor, fcolor )
               DI_CursorRight(5,0,Width, bcolor, fcolor )
            EndIf
            If Type = #__cursor_SplitLeftRight
               DI_CursorSplitLeft(-1,0,Width, bcolor, fcolor )
               DI_CursorSplitRight(5,0,Width, bcolor, fcolor )
            EndIf
            If Type = #__cursor_SplitRight
               Line(0, 0, 1, Width, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
               Plot(1, 0, fcolor ) : Line(1, 1, 1, Width-2, bcolor) : Plot(1, Width-1, fcolor )                                     ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
               DI_CursorSplitRight(0,0,Width, bcolor, fcolor )
               DI_Right(0,0,Width, bcolor, fcolor )
            EndIf
            
            StopDrawing( )
         EndIf
         
         ;\\ https://www.purebasic.fr/english/viewtopic.php?t=78093
         ;     Define dimensions.bitmap,icon.iconinfo
         ;     If Not GetObject_(Image,SizeOf(dimensions),@dimensions)
         ;        GetIconInfo_(Image,icon)
         ;        GetObject_(icon\hbmMask,SizeOf(dimensions),@dimensions)
         ;     EndIf
         ; GetIconInfo_(hIcon, iconinfo.ICONINFO)
         ; GetObject_(iconinfo\hbmMask, SizeOf(BITMAP), bitmap.BITMAP)
         ; 
         ; Width = bitmap\bmWidth
         ; Height = bitmap\bmHeight
         
         If DesktopScaledX(Width) <> GetSystemMetrics_( #SM_CXCURSOR ) And 
            DesktopScaledY(Height) <> GetSystemMetrics_( #SM_CYCURSOR) 
            If DesktopResolutionX( ) = 2.0 And DesktopResolutionY( ) = 2.0
               Width = 32                  ;GetSystemMetrics_( #SM_CXCURSOR )
               Height = 32                 ;GetSystemMetrics_( #SM_CYCURSOR )
               ResizeImage(Image, Width, Height, #PB_Image_Raw )
            EndIf
         EndIf
         
         If Type = #__cursor_Arrows Or
            Type = #__cursor_UpDown Or
            Type = #__cursor_LeftRight Or
            Type = #__cursor_SplitUpDown Or
            Type = #__cursor_SplitLeftRight 
            X = Width/2
            Y = Height/2
         EndIf
         
         ;\\
         If Type = #__cursor_LeftDown Or
            Type = #__cursor_LeftUp Or
            Type = #__cursor_RightDown Or
            Type = #__cursor_RightUp Or
            Type = #__cursor_Diagonal1 Or
            Type = #__cursor_Diagonal2 
            X = Width/2 - 1
            Y = Height/2 - 1
         EndIf
         
         ;\\
         If Type = #__cursor_SplitUp  
            X = Width/2 
            Y = Height/2 - 1
         EndIf
         If Type = #__cursor_SplitDown 
            X = Width/2 
            Y = 1
         EndIf
         If Type = #__cursor_SplitLeft 
            X = Width/2 - 1
            Y = Height/2
         EndIf
         If Type = #__cursor_SplitRight
            X = 1
            Y = Height/2
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
         
         If DesktopResolutionX( ) = 2.0 And DesktopResolutionY( ) = 2.0
            ResizeImage(Image, DesktopScaledY(ImageWidth(Image)), DesktopScaledY(ImageHeight(Image)), #PB_Image_Raw )
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
      
      Procedure   Free( *cursor ) 
         ;Debug "cursor-free "+*cursor
         
         If *cursor >= 0 And *cursor <= 255
            If FindMapElement(images( ), Str(*cursor))
               DeleteMapElement(images( ));, Str(*cursor))
            EndIf
         Else
            If MapSize(images( ))
               ForEach images( )
                  If *cursor = images( )
                     DeleteMapElement(images( ))
                     Break 
                  EndIf
               Next
            EndIf
            ProcedureReturn DestroyCursor_( *cursor )
         EndIf
      EndProcedure
      
      Procedure   isHiden( )
         Protected cursor_info.CURSORINFO 
         cursor_info\cbSize = SizeOf(CURSORINFO)
         GetCursorInfo_(@cursor_info)
         ProcedureReturn Bool(cursor_info\flags & #CURSOR_SHOWING)
      EndProcedure
      
      Procedure   Hide(state.b)
         ProcedureReturn ShowCursor_(state)
      EndProcedure
      
      Procedure   Clip( X.l,Y.l,Width.l,Height.l )
         Protected rect.RECT
         ;GetWindowRect_(GadgetID,rect.RECT)
         SetRect_(rect,X,Y,X+Width,Y+Height)
         ProcedureReturn ClipCursor_(rect)
      EndProcedure
      
      Procedure.i Create(ImageID.i, X.l = 0, Y.l = 0)
         Protected *create_icon, cursor_info.ICONINFO
         cursor_info\fIcon = 0
         cursor_info\xHotspot = X 
         cursor_info\yHotspot = Y 
         cursor_info\hbmMask = ImageID
         cursor_info\hbmColor = ImageID
         *create_icon = CreateIconIndirect_( @cursor_info ) 
         If Not *create_icon : *create_icon = ImageID : EndIf
         ProcedureReturn *create_icon
      EndProcedure
      
      Procedure   Change( GadgetID.i, state.b )
         Protected result, *cursor._s_cursor = GetProp_(GadgetID, "#__cursor")
         If *cursor And
            *cursor\hcursor
            
            ;\\ reset
            If state = 0 
               ; SetClassLongPtr_( *cursor\windowID, #GCL_HCURSOR, LoadCursor_(0,#IDC_ARROW) )
               result = SetCursor_( LoadCursor_(0,#IDC_ARROW) )
            EndIf
            
            ;\\ set
            ; If *cursor\hcursor <> GetCursor_( )
            If state > 0
               If *cursor\hcursor =- 1
                  If GetCursor_( )
                     result = SetCursor_( #NUL )
                  Else
                     result = *cursor\hcursor
                  EndIf
               Else
                  ; SetClassLongPtr_( *cursor\windowID, #GCL_HCURSOR, *cursor\hcursor )
                  ; SetClassLongPtr_( GadgetID( gadget ), #GCL_HCURSOR, *cursor\hcursor )
                  result = SetCursor_( *cursor\hcursor )
               EndIf
            EndIf
            
            If result <> *cursor\hcursor
               CompilerIf #test_cursor
                  Debug " :: changeCursor "+ state +" "+ GadgetID +" "+ result +" "+ *cursor\hcursor
               CompilerEndIf
            EndIf
            ; EndIf
         EndIf
      EndProcedure
      
      Procedure   Set( Gadget.i, *cursor )
         Protected *memory._s_cursor
         
         With *memory
            If IsGadget( Gadget )
               Protected GadgetID = GadgetID( Gadget )
               CompilerIf #test_cursor
                  Debug " :: setCursor "+ GadgetType( Gadget ) +" "+ *cursor ; +" "+ GadgetID +"="+ mouse::Gadget( ID::GetWindowID(GadgetID) ) +" mousebuttonsstate-"+ CocoaMessage(0, 0, "NSEvent pressedMouseButtons")
               CompilerEndIf
               
               *memory = GetProp_( GadgetID, "#__cursor" )
               
               If Not *memory
                  *memory = AllocateStructure( _s_cursor )
                  \windowID = ID::GetWindowID( GadgetID )
                  SetProp_( GadgetID, "#__cursor", *memory ) 
                  SetProp_( GadgetID, "#__oldproc_cursor", SetWindowLongPtr_(GadgetID, #GWL_WNDPROC, @Proc( )))
               EndIf
               
               If \type <> *cursor
                  If \hcursor > 0
                     Select \type
                        Case #__cursor_Drag, #__cursor_Drop,
                             #__cursor_SplitUpDown, #__cursor_SplitUp, #__cursor_SplitDown,
                             #__cursor_SplitLeftRight, #__cursor_SplitLeft, #__cursor_SplitRight
                           cursor::Free( \hcursor )
                     EndSelect
                  EndIf
                  \type = *cursor
                  
                  ;\\
                  If *cursor > 255
                     \hcursor = *cursor 
                  Else
                     Select *cursor
                        Case #__cursor_Invisible : \hcursor =- 1
                        Case #__cursor_Busy      : \hcursor = LoadCursor_(0,#IDC_WAIT)
                           
                        Case #__cursor_Default   : \hcursor = LoadCursor_(0,#IDC_ARROW)
                        Case #__cursor_IBeam     : \hcursor = LoadCursor_(0,#IDC_IBEAM)
                        Case #__cursor_Denied    : \hcursor = LoadCursor_(0,#IDC_NO)
                           
                        Case #__cursor_Hand      : \hcursor = LoadCursor_(0,#IDC_HAND)
                        Case #__cursor_Cross     : \hcursor = LoadCursor_(0,#IDC_CROSS)
                        Case #__cursor_Arrows    : \hcursor = LoadCursor_(0,#IDC_SIZEALL)
                           
                        Case #__cursor_UpDown    : \hcursor = LoadCursor_(0,#IDC_SIZENS)
                        Case #__cursor_LeftRight : \hcursor = LoadCursor_(0,#IDC_SIZEWE)
                           
                        Case #__cursor_Diagonal1,
                             #__cursor_LeftUp,
                             #__cursor_RightDown 
                           \hcursor = LoadCursor_(0,#IDC_SIZENWSE)
                           
                        Case #__cursor_Diagonal2,
                             #__cursor_RightUp,
                             #__cursor_LeftDown 
                           \hcursor = LoadCursor_(0,#IDC_SIZENESW)
                           
                           ;\\  custom cursors
                        Case #__cursor_SplitUpDown, #__cursor_SplitUp, #__cursor_SplitDown,
                             #__cursor_SplitLeftRight, #__cursor_SplitLeft, #__cursor_SplitRight
                           
                           \hcursor = New( *cursor, Draw( *cursor ) )
                           
                        Case #__cursor_Drag : \hcursor = New( *cursor, Create(ImageID(Image( *cursor ))) )
                        Case #__cursor_Drop : \hcursor = New( *cursor, Create(ImageID(Image( *cursor ))) )
                           
                        Case #__cursor_Grab      : \hcursor = LoadCursor_(0,#IDC_ARROW)
                        Case #__cursor_Grabbing  : \hcursor = LoadCursor_(0,#IDC_ARROW)
                           
                     EndSelect 
                  EndIf
               EndIf
               
               If \hcursor And 
                  GadgetID = mouse::Gadget( \windowID )
                  cursor::Change( GadgetID, 1 )
                  ProcedureReturn #True
               EndIf
            EndIf
         EndWith
      EndProcedure
      
      Procedure   Get( )
         Protected result.i
         Protected cursor_info.CURSORINFO 
         cursor_info\cbSize = SizeOf(CURSORINFO)
         GetCursorInfo_(@cursor_info)
         
         If cursor_info\flags & #CURSOR_SHOWING
            Select cursor_info\hCursor ; GetCursor_( )
               Case LoadCursor_(0,#IDC_ARROW) : result = #__cursor_Default
               Case LoadCursor_(0,#IDC_IBEAM) : result = #__cursor_IBeam
               Case LoadCursor_(0,#IDC_NO) : result = #__cursor_Denied
                  
               Case LoadCursor_(0,#IDC_HAND) : result = #__cursor_Hand
               Case LoadCursor_(0,#IDC_CROSS) : result = #__cursor_Cross
               Case LoadCursor_(0,#IDC_SIZEALL) : result = #__cursor_Arrows
                  
               Case LoadCursor_(0,#IDC_SIZEWE) : result = #__cursor_SplitUp
               Case LoadCursor_(0,#IDC_SIZEWE) : result = #__cursor_SplitDown
               Case LoadCursor_(0,#IDC_SIZEWE) : result = #__cursor_SplitUpDown
                  
               Case LoadCursor_(0,#IDC_SIZENS) : result = #__cursor_SplitLeft
               Case LoadCursor_(0,#IDC_SIZENS) : result = #__cursor_SplitRight
               Case LoadCursor_(0,#IDC_SIZENS) : result = #__cursor_SplitLeftRight
                  
               Case LoadCursor_(0,#IDC_SIZENESW) : result = #__cursor_Diagonal2
               Case LoadCursor_(0,#IDC_SIZENWSE) : result = #__cursor_Diagonal1
                  
               Case LoadCursor_(0,#IDC_ARROW) : result = #__cursor_Drop
               Case LoadCursor_(0,#IDC_ARROW) : result = #__cursor_Drag
                  
               Case LoadCursor_(0,#IDC_ARROW) : result = #__cursor_Grab
               Case LoadCursor_(0,#IDC_ARROW) : result = #__cursor_Grabbing
            EndSelect 
         Else
            result = #__cursor_Invisible
         EndIf
         
         ProcedureReturn result
      EndProcedure
   CompilerEndIf
   
   ;-
   ;- >>> [LINUX] <<<
   CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      ; https://www.manpagez.com/html/gdk/gdk-3.12.0/gdk3-Cursors.php#GdkCursorType
      ; LINUX:
      ;   GDK_X_CURSOR 		  = 0,
      ;   GDK_ARROW 		  = 2,
      ;   GDK_BASED_ARROW_DOWN    = 4,
      ;   GDK_BASED_ARROW_UP 	  = 6,
      ;   GDK_BOAT 		  = 8,
      ;   GDK_BOGOSITY 		  = 10,
      ;   GDK_BOTTOM_LEFT_CORNER  = 12,
      ;   GDK_BOTTOM_RIGHT_CORNER = 14,
      ;   GDK_BOTTOM_SIDE 	  = 16,
      ;   GDK_BOTTOM_TEE 	  = 18,
      ;   GDK_BOX_SPIRAL 	  = 20,
      ;   GDK_CENTER_PTR 	  = 22,
      ;   GDK_CIRCLE 		  = 24,
      ;   GDK_CLOCK	 	  = 26,
      ;   GDK_COFFEE_MUG 	  = 28,
      ;   GDK_CROSS 		  = 30,
      ;   GDK_CROSS_REVERSE 	  = 32,
      ;   GDK_CROSSHAIR 	  = 34,
      ;   GDK_DIAMOND_CROSS 	  = 36,
      ;   GDK_DOT 		  = 38,
      ;   GDK_DOTBOX 		  = 40,
      ;   GDK_DOUBLE_ARROW 	  = 42,
      ;   GDK_DRAFT_LARGE 	  = 44,
      ;   GDK_DRAFT_SMALL 	  = 46,
      ;   GDK_DRAPED_BOX 	  = 48,
      ;   GDK_EXCHANGE 		  = 50,
      ;   GDK_FLEUR 		  = 52,
      ;   GDK_GOBBLER 		  = 54,
      ;   GDK_GUMBY 		  = 56,
      ;   GDK_HAND1 		  = 58,
      ;   GDK_HAND2 		  = 60,
      ;   GDK_HEART 		  = 62,
      ;   GDK_ICON 		  = 64,
      ;   GDK_IRON_CROSS 	  = 66,
      ;   GDK_LEFT_PTR 		  = 68,
      ;   GDK_LEFT_SIDE 	  = 70,
      ;   GDK_LEFT_TEE 		  = 72,
      ;   GDK_LEFTBUTTON 	  = 74,
      ;   GDK_LL_ANGLE 		  = 76,
      ;   GDK_LR_ANGLE 	 	  = 78,
      ;   GDK_MAN 		  = 80,
      ;   GDK_MIDDLEBUTTON 	  = 82,
      ;   GDK_MOUSE 		  = 84,
      ;   GDK_PENCIL 		  = 86,
      ;   GDK_PIRATE 		  = 88,
      ;   GDK_PLUS 		  = 90,
      ;   GDK_QUESTION_ARROW 	  = 92,
      ;   GDK_RIGHT_PTR 	  = 94,
      ;   GDK_RIGHT_SIDE 	  = 96,
      ;   GDK_RIGHT_TEE 	  = 98,
      ;   GDK_RIGHTBUTTON 	  = 100,
      ;   GDK_RTL_LOGO 		  = 102,
      ;   GDK_SAILBOAT 		  = 104,
      ;   GDK_SB_DOWN_ARROW 	  = 106,
      ;   GDK_SB_H_DOUBLE_ARROW   = 108,
      ;   GDK_SB_LEFT_ARROW 	  = 110,
      ;   GDK_SB_RIGHT_ARROW 	  = 112,
      ;   GDK_SB_UP_ARROW 	  = 114,
      ;   GDK_SB_V_DOUBLE_ARROW   = 116,
      ;   GDK_SHUTTLE 		  = 118,
      ;   GDK_SIZING 		  = 120,
      ;   GDK_SPIDER		  = 122,
      ;   GDK_SPRAYCAN 		  = 124,
      ;   GDK_STAR 		  = 126,
      ;   GDK_TARGET 		  = 128,
      ;   GDK_TCROSS 		  = 130,
      ;   GDK_TOP_LEFT_ARROW 	  = 132,
      ;   GDK_TOP_LEFT_CORNER 	  = 134,
      ;   GDK_TOP_RIGHT_CORNER 	  = 136,
      ;   GDK_TOP_SIDE 		  = 138,
      ;   GDK_TOP_TEE 		  = 140,
      ;   GDK_TREK 		  = 142,
      ;   GDK_UL_ANGLE 		  = 144,
      ;   GDK_UMBRELLA 		  = 146,
      ;   GDK_UR_ANGLE 		  = 148,
      ;   GDK_WATCH 		  = 150,
      ;   GDK_XTERM 		  = 152
      #GDK_BLANK_CURSOR = -2 ; пустой курсор
                             ;   GDK_CURSOR_IS_PIXMAP = -1
      
      ; https://www.manpagez.com/html/gdk/gdk-3.12.0/gdk3-Cursors.php 
      ;   GdkКурсор  *	gdk_cursor_new  ( )
      ;   GdkКурсор  *	gdk_cursor_new_from_pixbuf  ( )
      ;   GdkКурсор  *	gdk_cursor_new_from_surface  ( )
      ;   GdkКурсор  *	gdk_cursor_new_from_name  ( )
      ;   GdkКурсор  *	gdk_cursor_new_for_display  ( )
      ;   GdkDisplay  *	gdk_cursor_get_display  ( )
      ;   GdkPixbuf  *	gdk_cursor_get_image  ( )
      ;   cairo_surface_t  *	gdk_cursor_get_surface  ( )
      ;   GdkCursorType	gdk_cursor_get_cursor_type  ( )
      ;   GdkКурсор  *	gdk_cursor_ref  ( )
      ;                	gdk_cursor_unref  ( )
      
      ; gdk_cursor_get_image( GdkCursor *cursor);  Возвращает GdkPixbuf с изображением, используемым для отображения курсора.
      
      ImportC ""
         gtk_widget_get_window(*widget.GtkWidget)
         gdk_cursor_get_cursor_type(*cursor.GDKCursor)
         gdk_window_get_cursor(*widget.GtkWidget)
         g_object_set_data(*Widget.GtkWidget, strData.p-utf8, *userdata)
      EndImport
      ;     ImportC "" ; -gtk"
      ;     g_object_set_data_(*Widget.GtkWidget, strData.p-utf8, *userdata) As "g_object_set_data"
      ;     g_object_get_data_(*Widget.GtkWidget, strData.p-utf8) As "g_object_get_data"
      ;   EndImport
      
      
      Global NewMap images.i( )
      
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
               DI_CursorUp(0,-1,Height, bcolor, fcolor )
               DI_CursorDown(0,7,Height, bcolor, fcolor )
               ;         
               DI_CursorLeft(-1,0,Width, bcolor, fcolor )
               DI_CursorRight(7,0,Width, bcolor, fcolor )
               Box(7,7,2,2, bcolor)
            EndIf
            
            ;\\
            If Type = #__cursor_LeftUp Or
               Type = #__cursor_RightDown Or
               Type = #__cursor_Diagonal1 
               X = 7
               Y = 7
               DI_CursorDiagonal1(0,0, size, bcolor, fcolor )
            EndIf
            If Type = #__cursor_LeftDown Or
               Type = #__cursor_RightUp Or
               Type = #__cursor_Diagonal2 
               X = 7
               Y = 7
               DI_CursorDiagonal2(0,0, size, bcolor, fcolor )
            EndIf
            
            ;\\
            If Type = #__cursor_SplitUp
               X = 8
               Y = 6
               DI_Up(0,-1,Height, bcolor, fcolor )
               DI_CursorSplitUp(0,-1,Height, bcolor, fcolor )
               Plot(0, 7, fcolor ) : Line(1, 7, Width-2, 1, bcolor) : Plot(Width-1, 7, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
               Line(0, 8, Width , 1, fcolor)                                                                             ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
            EndIf
            If Type = #__cursor_UpDown
               X = 8
               Y = 6
               DI_CursorUp(0,-1,Height, bcolor, fcolor )
               DI_CursorDown(0,5,Height, bcolor, fcolor )
            EndIf
            If Type = #__cursor_SplitUpDown
               X = 8
               Y = 6
               DI_CursorSplitUp(0,-1,Height, bcolor, fcolor )
               DI_CursorSplitDown(0,5,Height, bcolor, fcolor )
            EndIf
            If Type = #__cursor_SplitDown
               X = 8
               Y = 6
               Line(0, 0, Width, 1, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
               Plot(0, 1, fcolor ) : Line(1, 1, Width-2, 1, bcolor) : Plot(Width-1, 1, fcolor )                                     ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
               DI_CursorSplitDown(0,0,Height, bcolor, fcolor )
               DI_Down(0,0,Height, bcolor, fcolor )
            EndIf
            
            ;\\
            If Type = #__cursor_SplitLeft
               X = 6
               Y = 8
               DI_Left(-1,0,Width, bcolor, fcolor )
               DI_CursorSplitLeft(-1,0,Width, bcolor, fcolor )
               Plot(7, 0, fcolor ) : Line(7, 1, 1, Height-2, bcolor) : Plot(7, Height-1, fcolor )                        ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
               Line(8, 0, 1, Height, fcolor)                                                                             ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
            EndIf
            If Type = #__cursor_LeftRight
               X = 6
               Y = 8
               DI_CursorLeft(-1,0,Width, bcolor, fcolor )
               DI_CursorRight(5,0,Width, bcolor, fcolor )
            EndIf
            If Type = #__cursor_SplitLeftRight
               X = 6
               Y = 8
               DI_CursorSplitLeft(-1,0,Width, bcolor, fcolor )
               DI_CursorSplitRight(5,0,Width, bcolor, fcolor )
            EndIf
            If Type = #__cursor_SplitRight
               X = 6
               Y = 8
               Line(0, 0, 1, Width, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
               Plot(1, 0, fcolor ) : Line(1, 1, 1, Width-2, bcolor) : Plot(1, Width-1, fcolor )                                     ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
               DI_CursorSplitRight(0,0,Width, bcolor, fcolor )
               DI_Right(0,0,Width, bcolor, fcolor )
            EndIf
            
            StopDrawing( )
         EndIf
         
         ProcedureReturn Create( ImageID( Image ), X, Y )
      EndProcedure
      
      Procedure Image( Type.a = 0 )
         Protected Image
         
         If Type = #__cursor_Drop
            Image = CatchImage( #PB_Any, ?add, 601 )
         ElseIf Type = #__cursor_Drag
            Image = CatchImage( #PB_Any, ?copy, 530 )
         EndIf
         
         If Not Image
            Image = CreateImage( #PB_Any, 16, 16, 32, #PB_Image_Transparent )
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
         
         ProcedureReturn Image
      EndProcedure
      
      Procedure New( Type.a, ImageID.i )
         If Not FindMapElement(images( ), Str(Type))
            AddMapElement(images( ), Str(Type))
            images( ) = ImageID
         EndIf
         
         ProcedureReturn ImageID
      EndProcedure
      
      Procedure   Free( *cursor )
         Debug "cursor-free "+*cursor
         
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
            ;     ; Используйте g_object_unref( )
            ;     ProcedureReturn gdk_cursor_unref_(*cursor)
         EndIf
      EndProcedure
      
      Procedure   isHiden( )
         ProcedureReturn 0;Bool( gdk_cursor_get_cursor_type(gdk_window_get_cursor( gdk_display_get_default_( ) )) = #GDK_BLANK_CURSOR )
      EndProcedure
      
      Procedure   Hide( state.b )
         ; Чтобы сделать курсор невидимым, используйте GDK_BLANK_CURSOR.
         If state
            gdk_cursor_new_for_display_(gdk_display_get_default_( ),gdk_cursor_new_(#GDK_BLANK_CURSOR)) ; #GDK_BLANK_CURSOR = -2
                                                                                                        ;gdk_cursor_new_from_name("none")
         Else
            gdk_cursor_new_for_display_(gdk_display_get_default_( ),gdk_cursor_new_(#GDK_ARROW))
         EndIf
      EndProcedure
      
      Procedure.i Create( ImageID.i, X.l = 0, Y.l = 0 )
         ProcedureReturn gdk_cursor_new_from_pixbuf_( gdk_display_get_default_( ), ImageID, X, Y)
      EndProcedure
      
      Procedure Change( GadgetID.i, state.b )
         Protected *cursor._s_cursor = g_object_get_data_(GadgetID, "__cursor") ; GetGadgetData(EnteredGadget( ))
         If *cursor And 
            *cursor\hcursor  
            
            ; reset 
            If state = 0 
               gdk_window_set_cursor_( gtk_widget_get_window(*cursor\windowID), gdk_cursor_new_(#GDK_ARROW))
            EndIf
            
            ; set
            If state = 1 
               gdk_window_set_cursor_( gtk_widget_get_window(*cursor\windowID), 0) ; bug
               gdk_window_set_cursor_( gtk_widget_get_window(*cursor\windowID), *cursor\hcursor)
            EndIf
            
            CompilerIf #test_cursor
               Debug " ::changeCursor"
            CompilerEndIf
         EndIf
      EndProcedure
      
      Procedure Set( Gadget.i, *cursor )
         Protected *memory._s_cursor
         
         With *memory
            If IsGadget( Gadget )
               Protected GadgetID = GadgetID( Gadget )
               CompilerIf #test_cursor
                  Debug " ::setCursor "+ GadgetType( Gadget ) +" "+ *cursor ; +" "+ GadgetID +"="+ mouse::Gadget( ID::GetWindowID(GadgetID) ) +" mousebuttonsstate-"+ CocoaMessage(0, 0, "NSEvent pressedMouseButtons")
               CompilerEndIf
               
               *memory = g_object_get_data_(GadgetID, "__cursor")
               
               If Not *memory
                  *memory = AllocateStructure(_s_cursor)
                  \windowID = ID::GetWindowID(GadgetID)
                  g_object_set_data(GadgetID, "__cursor", *memory) 
               EndIf
               
               If \type <> *cursor
                  If \hcursor > 0
                     Select \type
                        Case #__cursor_Drag, #__cursor_Drop,
                             #__cursor_LeftRight, #__cursor_UpDown, 
                             #__cursor_Diagonal1, #__cursor_Diagonal2 
                           cursor::Free( \hcursor )
                     EndSelect
                  EndIf
                  \type = *cursor
                  
                  ;\\
                  If *cursor > 255
                     \hcursor = *cursor 
                  Else
                     Select *cursor
                           ;;Case #__cursor_Invisible : \hcursor = gdk_cursor_new_for_display_(gdk_display_get_default_( ), #GDK_BLANK_CURSOR)
                        Case #__cursor_Invisible      : \hcursor = gdk_cursor_new_(#GDK_BLANK_CURSOR); GDK_UR_ANGLE ; GDK_TOP_RIGHT_CORNER ; GDK_LL_ANGLE ; GDK_BOTTOM_LEFT_CORNER
                        Case #__cursor_Busy           : \hcursor = gdk_cursor_new_(#GDK_WATCH)
                           
                        Case #__cursor_Default        : \hcursor = gdk_cursor_new_(#GDK_LEFT_PTR) ; GDK_LEFT_PTR ; GDK_RIGHT_PTR ; GDK_CENTER_PTR
                        Case #__cursor_Cross          : \hcursor = gdk_cursor_new_(#GDK_CROSS)    ; GDK_TCROSS ; GDK_CROSS ; GDK_CROSSHAIR ; GDK_PLUS
                        Case #__cursor_IBeam          : \hcursor = gdk_cursor_new_(#GDK_XTERM)
                           
                        Case #__cursor_Hand           : \hcursor = gdk_cursor_new_(#GDK_HAND2) ; GDK_HAND1 ; GDK_HAND2
                        Case #__cursor_Denied         : \hcursor = gdk_cursor_new_(#GDK_X_CURSOR)
                        Case #__cursor_Arrows         : \hcursor = gdk_cursor_new_(#GDK_FLEUR)
                           
                        Case #__cursor_SplitLeft      : \hcursor = gdk_cursor_new_(#GDK_SB_LEFT_ARROW) 
                        Case #__cursor_SplitRight     : \hcursor = gdk_cursor_new_(#GDK_SB_RIGHT_ARROW)
                        Case #__cursor_SplitLeftRight : \hcursor = gdk_cursor_new_(#GDK_SB_H_DOUBLE_ARROW)
                           
                        Case #__cursor_SplitUp        : \hcursor = gdk_cursor_new_(#GDK_SB_UP_ARROW) 
                        Case #__cursor_SplitDown      : \hcursor = gdk_cursor_new_(#GDK_SB_DOWN_ARROW) 
                        Case #__cursor_SplitUpDown    : \hcursor = gdk_cursor_new_(#GDK_SB_V_DOUBLE_ARROW)
                           
                        Case #__cursor_Left           : \hcursor = gdk_cursor_new_(#GDK_LEFT_SIDE) ; GDK_LEFT_TEE ; GDK_LEFT_SIDE ; #GDK_SB_LEFT_ARROW
                        Case #__cursor_Right          : \hcursor = gdk_cursor_new_(#GDK_RIGHT_SIDE); GDK_RIGHT_TEE ; GDK_RIGHT_SIDE ; #GDK_SB_RIGHT_ARROW
                        Case #__cursor_Up             : \hcursor = gdk_cursor_new_(#GDK_TOP_SIDE)  ; GDK_TOP_TEE ; GDK_TOP_SIDE ; GDK_SB_UP_ARROW 
                        Case #__cursor_Down           : \hcursor = gdk_cursor_new_(#GDK_BOTTOM_SIDE) ; GDK_BOTTOM_TEE ; GDK_BOTTOM_SIDE ; GDK_SB_DOWN_ARROW
                           
                        Case #__cursor_LeftUp         : \hcursor = gdk_cursor_new_for_display_(gdk_display_get_default_( ), #GDK_TOP_LEFT_CORNER);gdk_cursor_new_(#GDK_TOP_LEFT_CORNER)
                        Case #__cursor_RightUp        : \hcursor = gdk_cursor_new_for_display_(gdk_display_get_default_( ), #GDK_TOP_RIGHT_CORNER)
                        Case #__cursor_LeftDown       : \hcursor = gdk_cursor_new_for_display_(gdk_display_get_default_( ), #GDK_BOTTOM_LEFT_CORNER)
                        Case #__cursor_RightDown      : \hcursor = gdk_cursor_new_for_display_(gdk_display_get_default_( ), #GDK_BOTTOM_RIGHT_CORNER)
                           
                        Case #__cursor_LeftRight, #__cursor_UpDown, 
                             #__cursor_Diagonal1, #__cursor_Diagonal2 
                           
                           \hcursor = New( *cursor, Draw( *cursor ) )
                           
                        Case #__cursor_Drag          : \hcursor = New( *cursor, Create(ImageID(Image( *cursor ))) )
                        Case #__cursor_Drop          : \hcursor = New( *cursor, Create(ImageID(Image( *cursor ))) )
                           
                        Case #__cursor_Grab          : \hcursor = gdk_cursor_new_(#GDK_ARROW)
                        Case #__cursor_Grabbing      : \hcursor = gdk_cursor_new_(#GDK_ARROW)
                     EndSelect 
                  EndIf
               EndIf
               
               If \hcursor And 
                  GadgetID = mouse::Gadget( \windowID )
                  cursor::Change( GadgetID, 1 )
                  ProcedureReturn #True
               EndIf
            EndIf
         EndWith
      EndProcedure
      
      Procedure   Get( )
         ;    ; gdk_cursor_get_cursor_type_(GdkCursor *cursor) ; Возвращает тип курсора для этого курсора.
         Protected result.i, currentSystemCursor
         ;     
         ;     ;Debug ""+ CocoaMessage(@currentSystemCursor, 0, "NSCursor currentSystemCursor") +" "+ currentSystemCursor+" "+ CocoaMessage(0, 0, "NSCursor currentCursor")
         ;     
         ;     If isHiden( ) ;  GetGadgetAttribute(EventGadget( ), #PB_Canvas_CustomCursor) ; 
         ;       result = #__cursor_Invisible
         ;     Else
         ;       Select gdk_window_get_cursor( gdk_display_get_default_( ) )
         ;         Case gdk_cursor_new_(#GDK_LEFT_PTR) : result = #__cursor_Default
         ;         Case gdk_cursor_new_(#GDK_XTERM) : result = #__cursor_IBeam
         ;           
         ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #__cursor_Drop
         ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #__cursor_Drag
         ;         Case gdk_cursor_new_(#GDK_X_CURSOR) : result = #__cursor_Denied
         ;           
         ;         Case gdk_cursor_new_(#GDK_CROSS) : result = #__cursor_Cross
         ;         Case gdk_cursor_new_(#GDK_HAND2) : result = #__cursor_Hand
         ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #__cursor_Grab
         ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #__cursor_Grabbing
         ;           
         ;         Case gdk_cursor_new_(#GDK_FLEUR) : result = #__cursor_Arrows
         ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #__cursor_SplitUp
         ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #__cursor_SplitDown
         ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #__cursor_SplitUpDown
         ;           
         ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #__cursor_SplitLeft
         ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #__cursor_SplitRight
         ;         Case gdk_cursor_new_(#GDK_ARROW) : result = #__cursor_SplitLeftRight
         ;       EndSelect 
         ;     EndIf
         ;     
         ProcedureReturn result
      EndProcedure
   CompilerEndIf
   
EndModule

CompilerIf Not Defined( constants, #PB_Module )
   DeclareModule constants
      CompilerIf #PB_Compiler_Version =< 546
         #PB_MessageRequester_Error = 1<<5
         #PB_EventType_Resize = 6
      CompilerEndIf
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

;-
;- >>> [EXAMPLE] <<<
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      XIncludeFile "ClipGadgets.pbi"
   CompilerEndIf
   
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
      Protected Canvas = 2
      ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(Canvas)*2, WindowHeight(EventWindow()) - GadgetY(Canvas)*2)
   EndProcedure
   
   Procedure Resize_3()
      Protected Canvas = 3
      ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(Canvas)*2, WindowHeight(EventWindow()) - GadgetY(Canvas)*2)
   EndProcedure
   
   Procedure EventHandler(eventobject, eventtype, eventdata)
      Protected window = EventWindow()
      Protected DropX, DropY
      Static deltax, deltay
      
      Select eventtype
         Case #PB_EventType_MouseWheelX
            Debug ""+eventobject + " #PB_EventType_MouseWheelX " +eventdata
            
         Case #PB_EventType_MouseWheelY
            Debug ""+eventobject + " #PB_EventType_MouseWheelY " +eventdata
            
         Case #PB_EventType_DragStart
            deltax = mouse::GadgetMouseX(eventobject, #PB_Gadget_WindowCoordinate)
            deltay = mouse::GadgetMouseY(eventobject, #PB_Gadget_WindowCoordinate)
            Debug ""+eventobject + " #PB_EventType_DragStart " + "x="+ deltax +" y="+ deltay
            
         Case #PB_EventType_Drop
            DropX = mouse::GadgetMouseX(eventobject, #PB_Gadget_ScreenCoordinate)
            DropY = mouse::GadgetMouseY(eventobject, #PB_Gadget_ScreenCoordinate)
            Debug ""+eventobject + " #PB_EventType_Drop " + "x="+ DropX +" y="+ DropY
            
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
            ;Debug ""+eventobject + " #PB_EventType_MouseEnter " ;+ CocoaMessage(0, WindowID(window), "isActive") 
            DrawCanvasFrame(eventobject, $00A600)
            
         Case #PB_EventType_MouseLeave
            ;Debug ""+eventobject + " #PB_EventType_MouseLeave "
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
   
   Procedure OpenWindow_(window, X,Y,Width,Height, title.s, Flag=0)
      Protected WindowID
      Protected result = OpenWindow(window, X,Y,Width,Height, title.s, Flag|#PB_Window_SizeGadget)
      If window >= 0
         WindowID = WindowID(window)
      Else
         WindowID = result
      EndIf
      ;Debug 77
      ;CocoaMessage(0, WindowID, "disableCursorRects")
      ProcedureReturn result
   EndProcedure
   
   Macro OpenWindow(window, X,Y,Width,Height, title, Flag=0)
      OpenWindow_(window, X,Y,Width,Height, title, Flag)
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
   
   ; If Set((111),#__cursor_SplitUpDown)
   ;   Debug "updown"           
   ; EndIf       
   
   If cursor::Set((100),cursor::#__cursor_Hand)
      Debug "setCursorHand"           
   EndIf       
   
   If cursor::Set((g1),cursor::#__cursor_IBeam)
      Debug "setCursorIBeam"           
   EndIf       
   
   If cursor::Set((g2),cursor::#__cursor_IBeam)
      Debug "setCursorIBeam"           
   EndIf       
   
   If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png") = 0
      MessageRequester("Error",
                       "Loading of image World.png failed!",
                       #PB_MessageRequester_Error)
      End
   EndIf
   If cursor::set((0), cursor::Create(ImageID(0)))
      Debug "setCursorImage"           
   EndIf       
   
   If cursor::Set((1),cursor::#__cursor_Hand)
      Debug "setCursorHand - " ;+CocoaMessage(0, 0, "NSCursor currentCursor")
   EndIf       
   
   If cursor::Set((11),cursor::#__cursor_Cross)
      Debug "setCursorCross"           
   EndIf       
   
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ClipGadgets(UseGadgetList(0))
   CompilerEndIf
   ;/// second
   OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
   Define g1=StringGadget(-1,0,0,0,0,"StringGadget")
   Define g2=HyperLinkGadget(-1,0,0,0,0,"HyperLinkGadget", 0)
   SplitterGadget(2, 10, 10, 200, 200, g1,g2)
   BindEvent(#PB_Event_SizeWindow, @Resize_2(), 2)
   
   ;   If cursor::Set((g1),cursor::#__cursor_IBeam)
   ;     Debug "setCursorIBeam"           
   ;   EndIf       
   ;   
   ;   If cursor::Set((g2),cursor::#__cursor_Hand)
   ;     Debug "setCursorHand"           
   ;   EndIf       
   ;   
   ;   If cursor::Set((2),cursor::#__cursor_SplitUpDown)
   ;     Debug "setCursorHand"           
   ;   EndIf       
   
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ClipGadgets(UseGadgetList(0))
   CompilerEndIf
   ;/// third
   OpenWindow(3, 450+50, 200+50, 220, 220, "window_3", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
   g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
   g2=StringGadget(-1,0,0,0,0,"StringGadget")
   SplitterGadget(3,10, 10, 200, 200, g1,g2)
   BindEvent(#PB_Event_SizeWindow, @Resize_3(), 3)
   
   If cursor::Set((g1),cursor::#__cursor_IBeam)
      Debug "setCursorIBeam"           
   EndIf       
   
   ;   If cursor::Set((g2),cursor::#__cursor_IBeam)
   ;     Debug "setCursorIBeam"           
   ;   EndIf       
   
   
   ;Debug "currentCursor - "+CocoaMessage(0, 0, "NSCursor currentCursor") ; CocoaMessage(0, 0, "NSCursor systemCursor") +" "+ 
   ;;events::SetCallback(@EventHandler())
   
   ;-\\ OPENWINDOW
   OpenWindow(4, 550, 300, 328, 328, "window_4", #PB_Window_SystemMenu)
   Define Invisible = CanvasGadget(#PB_Any, 8, 8, 86, 86) : GadgetToolTip( Invisible, "#__cursor_Invisible")
   Define Denied = CanvasGadget(#PB_Any, 8, 264, 56, 56) : GadgetToolTip( Denied, "#__cursor_Denied")
   Define Cross = CanvasGadget(#PB_Any, 264, 8, 56, 56) : GadgetToolTip( Cross, "#__cursor_Cross")
   Define Busy = CanvasGadget(#PB_Any, 264, 264, 56, 56) : GadgetToolTip( Busy, "#__cursor_Busy")
   
   ;   Canvas_4 = CanvasGadget(#PB_Any, 72, 8, 56, 56)
   Define lt = CanvasGadget(#PB_Any, 72, 72, 56, 56) : GadgetToolTip( lt, "#__cursor_LeftUp")
   Define lb = CanvasGadget(#PB_Any, 72, 200, 56, 56) : GadgetToolTip( lb, "#__cursor_LeftDown")
   ;   Canvas_72 = CanvasGadget(#PB_Any, 72, 264, 56, 56)
   
   Define up = CanvasGadget(#PB_Any, 136, 8, 56, 24) : GadgetToolTip( up, "#__cursor_Up")
   Define up2 = CanvasGadget(#PB_Any, 136, 8+24+8, 56, 24) : GadgetToolTip( up2, "#__cursor_SplitUpDown")
   Define up3 = CanvasGadget(#PB_Any, 136, 72, 56, 56) : GadgetToolTip( up3, "#__cursor_UpDown")
   
   Define left = CanvasGadget(#PB_Any, 8, 136, 24, 56) : GadgetToolTip( left, "#__cursor_Left")
   Define left2 = CanvasGadget(#PB_Any, 8+24+8, 136, 24, 56) : GadgetToolTip( left2, "#__cursor_SplitLeftRight")
   Define left3 = CanvasGadget(#PB_Any, 72, 136, 56, 56) : GadgetToolTip( left3, "#__cursor_LeftRight")
   
   Define Arrows = CanvasGadget(#PB_Any, 136, 136, 56, 56) : GadgetToolTip( Arrows, "#__cursor_Arrows")
   
   Define right = CanvasGadget(#PB_Any, 264+8+24, 136, 24, 56) : GadgetToolTip( right, "#__cursor_Right")
   Define right2 = CanvasGadget(#PB_Any, 264, 136, 24, 56) : GadgetToolTip( right2, "#__cursor_SplitLeftRight")
   Define right3 = CanvasGadget(#PB_Any, 200, 136, 56, 56) : GadgetToolTip( right3, "#__cursor_LeftRight")
   
   Define down3 = CanvasGadget(#PB_Any, 136, 200, 56, 56) : GadgetToolTip( down3, "#__cursor_UpDown")
   Define down2 = CanvasGadget(#PB_Any, 136, 264, 56, 24) : GadgetToolTip( down2, "#__cursor_SplitUpDown")
   Define down = CanvasGadget(#PB_Any, 136, 264+8+24, 56, 24) : GadgetToolTip( down, "#__cursor_Down")
   
   ;   Canvas_12 = CanvasGadget(#PB_Any, 200, 8, 56, 56)
   Define rt = CanvasGadget(#PB_Any, 200, 72, 56, 56) : GadgetToolTip( rt, "#__cursor_RightUp")
   Define rb = CanvasGadget(#PB_Any, 200, 200, 56, 56) : GadgetToolTip( rb, "#__cursor_RightDown")
   ;   Canvas_152 = CanvasGadget(#PB_Any, 200, 264, 56, 56)
   
   ;;Canvas_1 = CanvasGadget(#PB_Any, 8, 72, 56, 56)
   
   ;;Canvas_3 = CanvasGadget(#PB_Any, 8, 200, 56, 56)
   ;;Canvas_17 = CanvasGadget(#PB_Any, 264, 72, 56, 56)
   ;;Canvas_19 = CanvasGadget(#PB_Any, 264, 200, 56, 56)
   
   
   Cursor::Set((lt), Cursor::#__cursor_LeftUp ) 
   Cursor::Set((rt), Cursor::#__cursor_RightUp ) 
   Cursor::Set((lb), Cursor::#__cursor_LeftDown ) 
   Cursor::Set((rb), Cursor::#__cursor_RightDown ) 
   
   Cursor::Set((up), Cursor::#__cursor_SplitUp ) 
   Cursor::Set((down), Cursor::#__cursor_SplitDown ) 
   Cursor::Set((left), Cursor::#__cursor_SplitLeft ) 
   Cursor::Set((right), Cursor::#__cursor_SplitRight ) 
   
   Cursor::Set((up2), Cursor::#__cursor_SplitUpDown ) 
   Cursor::Set((down2), Cursor::#__cursor_SplitUpDown ) 
   Cursor::Set((left2), Cursor::#__cursor_SplitLeftRight ) 
   Cursor::Set((right2), Cursor::#__cursor_SplitLeftRight ) 
   
   Cursor::Set((up3), Cursor::#__cursor_Up ) 
   Cursor::Set((down3), Cursor::#__cursor_Down ) 
   Cursor::Set((left3), Cursor::#__cursor_Left ) 
   Cursor::Set((right3), Cursor::#__cursor_Right ) 
   
   Cursor::Set((Cross), Cursor::#__cursor_Cross ) 
   Cursor::Set((Arrows), Cursor::#__cursor_Arrows ) 
   Cursor::Set((Invisible), Cursor::#__cursor_Invisible ) 
   Cursor::Set((Denied), Cursor::#__cursor_Denied ) 
   Cursor::Set((Busy), Cursor::#__cursor_Busy ) 
   
   
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ClipGadgets(UseGadgetList(0))
   CompilerEndIf
   
   
   ;-
   
   
   
   Define EnteredGadget =- 1
   Define LeavedGadget =- 1 
   Define buttons = 0
   Define X,Y
   Define fcolor = $FFFFFF
   Define bcolor = $000000
   Define Width = 16
   Define Height = 7
   
   
   ;-\\
   If StartDrawing(CanvasOutput(Arrows))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-Width)/2
      
      ; down2                                                 
      Box(X+6,Y+6,4,4, fcolor)
      cursor::DI_CursorUp(X,Y-1,Width, bcolor, fcolor )
      cursor::DI_CursorDown(X,Y+7,Width, bcolor, fcolor )
      
      cursor::DI_CursorLeft(X-1,Y,Width, bcolor, fcolor )
      cursor::DI_CursorRight(X+7,Y,Width, bcolor, fcolor )
      Box(X+7,Y+7,2,2, bcolor)
      
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(Cross))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      ;       img = CocoaMessage(0, 0, "NSCursor resizeUpCursor")
      ;       ;DrawImage(img, 0,0)
      Width = 13
      Line(OutputWidth()/2-1, OutputHeight()/2-Width/2, 1, Width, fcolor)
      Line(OutputWidth()/2+1, OutputHeight()/2-Width/2, 1, Width, fcolor)
      
      Line(OutputWidth()/2-Width/2, OutputHeight()/2-1, Width, 1, fcolor)
      Line(OutputWidth()/2-Width/2, OutputHeight()/2+1, Width, 1, fcolor)
      
      Line(OutputWidth()/2, OutputHeight()/2-Width/2, 1, Width, bcolor)
      Line(OutputWidth()/2-Width/2, OutputHeight()/2, Width, 1, bcolor)
      StopDrawing()
   EndIf
   
   Define Width = 16
   Define Height = 7
   
   ;-\\ Dioganal1
   If StartDrawing(CanvasOutput(lt))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-Width)/2
      ;
      cursor::DI_CursorDiagonal1(X,Y,Width, bcolor, fcolor)
      
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(rb))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-Width)/2
      ;
      cursor::DI_CursorDiagonal1(X,Y,Width, bcolor, fcolor)
      
      StopDrawing()
   EndIf
   
   ;-\\ Dioganal2
   If StartDrawing(CanvasOutput(rt))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-Width)/2
      ; 
      cursor::DI_CursorDiagonal2(X,Y,Width, bcolor, fcolor)
      
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(lb))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-Width)/2
      ; 
      cursor::DI_CursorDiagonal2(X,Y,Width, bcolor, fcolor)
      
      StopDrawing()
   EndIf
   
   ;-\\ Vertical
   If StartDrawing(CanvasOutput(up))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-Height)/2
      
      ; up                                                 
      cursor::DI_Up(X, Y, Width, bcolor, fcolor)
      cursor::DI_CursorSplitUp(X,Y,Width, bcolor, fcolor )
      Plot(X, Y+8, fcolor ) : Line(X+1, Y+8, Width-2, 1, bcolor) : Plot(X+Width-1, Y+8, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      Line(X, Y + 9, Width , 1, fcolor)                                                                                   ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(up2))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-(Height*2))/2
      
      ; down2                                                 
      cursor::DI_CursorSplitV(X,Y,Width,Height, bcolor, fcolor )
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(up3))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-(Height*2))/2
      
      cursor::DI_CursorUp(X,Y-1,Width, bcolor, fcolor )
      cursor::DI_CursorDown(X,Y+Height-2,Width, bcolor, fcolor )
      StopDrawing()
   EndIf
   
   If StartDrawing(CanvasOutput(down))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-Height)/2
      
      ; down                                                 
      Line(X, Y, Width, 1, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      Plot(X, Y+1, fcolor ) : Line(X+1, Y+1, Width-2, 1, bcolor) : Plot(X+Width-1, Y+1, fcolor )                           ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      cursor::DI_CursorSplitDown(X,Y,Width, bcolor, fcolor )
      cursor::DI_Down(X, Y, Width, bcolor, fcolor)
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(down2))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-(Height*2))/2
      
      ; down2                                                 
      cursor::DI_CursorSplitV(X,Y,Width,Height, bcolor, fcolor )
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(down3))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-(Height*2))/2
      
      ; down2                                                 
      ; Box(x+6,y+5,4,4, fcolor)
      cursor::DI_CursorUp(X,Y-1,Width, bcolor, fcolor )
      cursor::DI_CursorDown(X,Y+Height-2,Width, bcolor, fcolor )
      
      ;     x = (OutputWidth()-(height*2))/2
      ;     y = (OutputHeight()-width)/2
      ;     ;Box(x+6,y+7,2,2, bcolor)
      
      StopDrawing()
   EndIf
   
   ;-\\ Horizontal
   If StartDrawing(CanvasOutput(left))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Height)/2
      Y = (OutputHeight()-Width)/2
      
      ; left                                                 
      cursor::DI_CursorSplitLeft(X,Y,Width, bcolor, fcolor )
      Plot(X+8, Y, fcolor ) : Line(X+8, Y+1, 1, Width-2, bcolor) : Plot(X+8, Y+Width-1, fcolor )                        ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      Line(X + 9, Y, 1, Width, fcolor)                                                                                  ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(left2))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-(Height*2))/2
      Y = (OutputHeight()-Width)/2
      Debug ""+X+" "+Y
      ; left2                                                 
      cursor::DI_CursorSplitLeft(X,Y,Width, bcolor, fcolor )
      cursor::DI_CursorSplitRight(X+Height-1,Y,Width, bcolor, fcolor )
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(left3))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-(Height*2))/2
      Y = (OutputHeight()-Width)/2
      ; ver-size
      cursor::DI_CursorLeft(X-1,Y,Width, bcolor, fcolor )
      cursor::DI_CursorRight(X+Height-2,Y,Width, bcolor, fcolor )
      StopDrawing()
   EndIf
   
   If StartDrawing(CanvasOutput(right))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Height)/2
      Y = (OutputHeight()-Width)/2
      
      ; right                                                 
      Line(X, Y, 1, Width, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      Plot(X+1, Y, fcolor ) : Line(X+1, Y+1, 1, Width-2, bcolor) : Plot(X+1, Y+Width-1, fcolor )                           ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      cursor::DI_CursorSplitRight(X,Y,Width, bcolor, fcolor )
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(right2))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-(Height*2))/2
      Y = (OutputHeight()-Width)/2
      
      ; right2                                                 
      cursor::DI_CursorSplitLeft(X,Y,Width, bcolor, fcolor )
      cursor::DI_CursorSplitRight(X+Height-1,Y,Width, bcolor, fcolor )
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(right3))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      ;     x = (OutputWidth()-width)/2
      ;     y = (OutputHeight()-(height*2))/2
      ;     
      ;     ; down2                                                 
      ;     ;Box(x+6,y+5,4,4, fcolor)
      
      X = (OutputWidth()-(Height*2))/2
      Y = (OutputHeight()-Width)/2
      
      cursor::DI_CursorLeft(X-1,Y,Width, bcolor, fcolor )
      cursor::DI_CursorRight(X+Height-2,Y,Width, bcolor, fcolor )
      ;Box(x+6,y+7,2,2, bcolor)
      
      StopDrawing()
   EndIf
   
   ;-
   Repeat 
      event = WaitWindowEvent()
      EnteredGadget = ID::Gadget(mouse::Gadget(mouse::Window()))
      
      If LeavedGadget <> EnteredGadget And buttons = 0
         ; Debug  CocoaMessage(0, CocoaMessage(0,0,"NSApplication sharedApplication"), "NSEvent")
         
         If LeavedGadget >= 0
            ; Debug GetGadgetAttribute(LeavedGadget, #PB_Canvas_Buttons)
            EventHandler(LeavedGadget, #PB_EventType_MouseLeave, 0)
            ;Cursor::Change(GadgetID(LeavedGadget), 0 )
            CompilerSelect #PB_Compiler_OS 
               CompilerCase #PB_OS_Windows
                  PostEvent(#PB_Event_Gadget, EventWindow( ), LeavedGadget, #PB_EventType_CursorChange, 0)
               CompilerCase #PB_OS_Linux
                  PostEvent(#PB_Event_Gadget, EventWindow( ), LeavedGadget, #PB_EventType_CursorChange, 0)
            CompilerEndSelect
         EndIf
         
         If EnteredGadget >= 0
            ; Debug GetGadgetAttribute(EnteredGadget, #PB_Canvas_Buttons)
            EventHandler(EnteredGadget, #PB_EventType_MouseEnter, 1)
            ;Cursor::Change(GadgetID(EnteredGadget), 1 )
            CompilerSelect #PB_Compiler_OS 
               CompilerCase #PB_OS_Windows
                  PostEvent(#PB_Event_Gadget, EventWindow( ), EnteredGadget, #PB_EventType_CursorChange, 1)
               CompilerCase #PB_OS_Linux  
                  PostEvent(#PB_Event_Gadget, EventWindow( ), EnteredGadget, #PB_EventType_CursorChange, 1)
            CompilerEndSelect
         EndIf
         LeavedGadget = EnteredGadget
      EndIf
      
      If event = #PB_Event_Gadget
         Select EventType( )
            Case #PB_EventType_CursorChange
               Cursor::Change(GadgetID(EventGadget( )), EventData( ) )
               
            Case #PB_EventType_LeftButtonDown
               buttons = 1
               
            Case #PB_EventType_LeftButtonUp
               buttons = 0
         EndSelect
      EndIf
      
   Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 1031
; FirstLine = 844
; Folding = ---f----------------------------------------
; Optimizer
; EnableXP
; DPIAware