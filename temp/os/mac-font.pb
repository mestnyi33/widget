EnableExplicit


Procedure.s PeekNSString(string)
    ;
    ; converts NSString to PB string
    ;
    #NSASCIIStringEncoding   = 1
    #NSUTF8StringEncoding    = 4
    #NSUnicodeStringEncoding = 10
    
    Protected result.s, length, *buffer
    If string
        length = CocoaMessage(0,string,"length")
        If length
            length + 1
            length * SizeOf(Character)
            *buffer = AllocateMemory(length)
            If *buffer
                CompilerIf #PB_Compiler_Unicode
                    CocoaMessage(0,string,"getCString:@",@*buffer,"maxLength:@",@length,"encoding:",#NSUnicodeStringEncoding)
                    result = PeekS(*buffer,-1,#PB_Unicode)
                CompilerElse
                    CocoaMessage(0,string,"getCString:@",@*buffer,"maxLength:@",@length,"encoding:",#NSASCIIStringEncoding)
                    result = PeekS(*buffer,-1,#PB_Ascii)
                CompilerEndIf
                FreeMemory(*buffer)
            EndIf
        EndIf
    EndIf
    ProcedureReturn result
EndProcedure


Procedure.s GetFontName(FontID)
    ;
    ; returns the font name of FontID
    ;
    Protected name.s, string
    If FontID
        string = CocoaMessage(0,FontID,"displayName") ; "familyName" and "fontName" for internal use
                                                      ; use "displayName" for the real name
        If string
            ProcedureReturn PeekNSString(string)
        EndIf
    EndIf
EndProcedure



Procedure.s GetDefaultFontName()
    ;
    ; returns the font name used for ButtonGadget()
    ;
    ; call at program start to get the default font name for PB gadgets
    ;
    Protected name.s
    Protected win = OpenWindow(#PB_Any,0,0,0,0,"",#PB_Window_Invisible)
    If win
        Protected btn = ButtonGadget(#PB_Any,0,0,0,0,"text") ; alternative: TextGadget()
        If btn
            name = GetFontName( GetGadgetFont(btn) )
            FreeGadget(btn)
        EndIf
        CloseWindow(win)
    EndIf
    ProcedureReturn name
EndProcedure


Procedure.CGFloat GetFontSize(FontID)
    ;
    ; returns the font size of FontID
    ;
    Protected pointSize.CGFloat = 0.0
    If FontID
        CocoaMessage(@pointSize,FontID,"pointSize")
    EndIf
    ProcedureReturn pointSize
EndProcedure


Procedure.CGFloat GetDefaultFontSize()
    ;
    ; returns the font size used for ButtonGadget()
    ;
    ; call at program start to get the default font size for PB gadgets
    ;
    Protected size.CGFloat = 0.0
    Protected win = OpenWindow(#PB_Any,0,0,0,0,"",#PB_Window_Invisible)
    If win
        Protected btn = ButtonGadget(#PB_Any,0,0,0,0,"text") ; alternative: TextGadget()
        If btn
            size = GetFontSize( GetGadgetFont(btn) )
            FreeGadget(btn)
        EndIf
        CloseWindow(win)
    EndIf
    ProcedureReturn size
EndProcedure


Procedure IsFontFixedPitch(FontID)
    ;
    ; returns true if FontID is a monospaced font
    ;
    If FontID
        ProcedureReturn CocoaMessage(0,FontID,"isFixedPitch")
    EndIf
EndProcedure


Procedure.CGFloat GetSystemFontSize()
    ;
    ; returns Mac OS X default system font size
    ;
    Protected size.CGFLoat = 0.0
    CocoaMessage(@size,0,"NSFont systemFontSize")
    ProcedureReturn size
EndProcedure


Procedure.CGFloat GetSmallSystemFontSize()
    ;
    ; returns Mac OS X default small system font size
    ;
    Protected size.CGFLoat = 0.0
    CocoaMessage(@size,0,"NSFont smallSystemFontSize")
    ProcedureReturn size
EndProcedure


Procedure.CGFloat GetLabelFontSize()
    ;
    ; returns Mac OS X default font size used for labels (TextGadget in PB)
    ;
    Protected size.CGFLoat = 0.0
    CocoaMessage(@size,0,"NSFont labelFontSize")
    ProcedureReturn size
EndProcedure



Debug "Default PB font:"
Debug GetDefaultFontName()
Debug GetDefaultFontSize()


Debug "System font sizes:"
Debug GetSystemFontSize()
Debug GetSmallSystemFontSize()
Debug GetLabelFontSize()
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ----
; EnableXP