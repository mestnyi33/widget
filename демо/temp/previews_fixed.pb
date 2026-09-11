п»ї?EnableExplicit

; --- Г‘Г’ГђГ“ГЉГ’Г“ГђГ› ---

; Г„Г«Гї Г®ГЄГ®Г­ ГЁ ГЈГ Г¤Г¦ГҐГІГ®Гў (Г± ГЈГҐГ®Г¬ГҐГІГ°ГЁГҐГ©)
Structure ControlParams
  ID.i
  X.i
  Y.i
  W.i
  H.i
  Text$
  Flag.i
  Param1.i
  Param2.i
  Param3.i
EndStructure

; Г„Г«Гї Г±ГҐГ°ГўГЁГ±Г­Г»Гµ ГґГіГ­ГЄГ¶ГЁГ© ГЁ ГЄГ®Г¬Г Г­Г¤ ГіГЇГ°Г ГўГ«ГҐГ­ГЁГї
Structure FunctionParams
  ID.i
  Value.i
  Text$
  Param1.i
  Param2.i
EndStructure


; --- ГЏГђГЋГ–Г…Г„Г“ГђГ› ГЏГЂГђГ‘Г€ГЌГѓГЂ ---

; ГЋГ·ГЁГ±ГІГЄГ  Г±ГІГ°Г®ГЄ (Г®Г±ГІГ ГҐГІГ±Гї ГЎГҐГ§ ГЁГ§Г¬ГҐГ­ГҐГ­ГЁГ©)
Procedure.s CleanArg(Value$)
  Value$ = Trim(Value$)
  Value$ = RemoveString(Value$, Chr(34))
  ProcedureReturn Value$
EndProcedure

; Г“Г¬Г­Г»Г© ГўГ»Г·ГЁГ±Г«ГЁГІГҐГ«Гј Г Г°ГЈГіГ¬ГҐГ­ГІГ®Гў. ГЏГ®Г­ГЁГ¬Г ГҐГІ Г·ГЁГ±Г«Г , ГЄГ®Г­Г±ГІГ Г­ГІГ» ГЁ ГґГіГ­ГЄГ¶ГЁГЁ RGB/RGBA
Procedure.i EvaluateArg(Value$)
  Value$ = Trim(Value$)
  Value$ = RemoveString(Value$, Chr(34)) ; Г“ГЎГЁГ°Г ГҐГ¬ ГЄГ ГўГ»Г·ГЄГЁ, ГҐГ±Г«ГЁ Г®Г­ГЁ ГЇГ°Г®Г±ГЄГ®Г·ГЁГ«ГЁ
  Protected LowVal$ = LCase(Value$)
  
  ; 1. ГЋГЃГђГЂГЃГЋГ’ГЉГЂ Г‘Г€Г‘Г’Г…ГЊГЌГ›Г• ГЉГЋГЌГ‘Г’ГЂГЌГ’ PUREBASIC
  If Left(LowVal$, 4) = "#pb_"
    Select LowVal$
      ; ГЉГ®Г­Г±ГІГ Г­ГІГ» ГІГЁГЇГ®Гў Г¶ГўГҐГІГ  ГЈГ Г¤Г¦ГҐГІГ®Гў
      Case "#pb_gadget_frontcolor" : ProcedureReturn 0
      Case "#pb_gadget_backcolor"  : ProcedureReturn 1
      Case "#pb_gadget_linecolor"  : ProcedureReturn 2
        
      ; ГЉГ®Г­Г±ГІГ Г­ГІГ» ГґГ«Г ГЈГ®Гў Г®ГЄГ®Г­ (Г¤Г«Гї ГЇГ°ГЁГ¬ГҐГ°Г , Г¬Г®Г¦Г­Г® Г°Г Г±ГёГЁГ°ГїГІГј)
      Case "#pb_window_systemmenu"     : ProcedureReturn #PB_Window_SystemMenu
      Case "#pb_window_screencentered" : ProcedureReturn #PB_Window_ScreenCentered
        
      ; ГЉГ®Г­Г±ГІГ Г­ГІГ» ГЇГ®Г§ГЁГ¶ГЁГ© Г¤Г«Гї AddGadgetItem
      Case "#pb_any" : ProcedureReturn #PB_Any
    EndSelect
  EndIf
  
  ; 2. ГЋГЃГђГЂГЃГЋГ’ГЉГЂ Г„Г€ГЌГЂГЊГ€Г—Г…Г‘ГЉГ€Г• Г”Г“ГЌГЉГ–Г€Г‰ Г–Г‚Г…Г’ГЂ
  Protected BracketPos = FindString(LowVal$, "(")
  If BracketPos
    Protected Func$ = Trim(Left(LowVal$, BracketPos - 1))
    Protected Args$ = Mid(Value$, BracketPos + 1)
    If Right(Args$, 1) = ")" : Args$ = Left(Args$, Len(Args$) - 1) : EndIf
    
    Select Func$
      Case "rgb"
        Protected R = Val(Trim(StringField(Args$, 1, ",")))
        Protected G = Val(Trim(StringField(Args$, 2, ",")))
        Protected B = Val(Trim(StringField(Args$, 3, ",")))
        ProcedureReturn RGB(R, G, B)
        
      Case "rgba"
        Protected R2 = Val(Trim(StringField(Args$, 1, ",")))
        Protected G2 = Val(Trim(StringField(Args$, 2, ",")))
        Protected B2 = Val(Trim(StringField(Args$, 3, ",")))
        Protected A2 = Val(Trim(StringField(Args$, 4, ",")))
        ProcedureReturn RGBA(R2, G2, B2, A2)
    EndSelect
  EndIf
  
  ; 3. ГЋГЃГ›Г—ГЌГЋГ… Г—Г€Г‘Г‹ГЋ (ГЁГ«ГЁ ГЎГЁГІГ®ГўГ»ГҐ Г¬Г Г±ГЄГЁ, ГҐГ±Г«ГЁ Г®Г­ГЁ Г±ГЄГ«ГҐГҐГ­Г» ГЄГ ГЄ Г±ГІГ°Г®ГЄГЁ)
  ; Г…Г±Г«ГЁ Гў Г±ГІГ°Г®ГЄГҐ Г®Г±ГІГ Г«Г±Гї Г°Г Г§Г¤ГҐГ«ГЁГІГҐГ«Гј "|" Г®ГІ ГЄГ®Г­Г±ГІГ Г­ГІ, Г±Г·ГЁГІГ ГҐГ¬ ГЁГµ Г±ГіГ¬Г¬Гі
  If FindString(Value$, "|")
    Protected i, Sum = 0, PartsCount = CountString(Value$, "|") + 1
    For i = 1 To PartsCount
      Sum | EvaluateArg(StringField(Value$, i, "|"))
    Next i
    ProcedureReturn Sum
  EndIf
  
  ProcedureReturn Val(Value$)
EndProcedure
; ГЏГ Г°Г±ГҐГ° В№1: Г„Г«Гї ГЅГ«ГҐГ¬ГҐГ­ГІГ®Гў ГіГЇГ°Г ГўГ«ГҐГ­ГЁГї (Г‚Г Гё Г®ГЇГІГЁГ¬ГЁГ§ГЁГ°Г®ГўГ Г­Г­Г»Г© ГўГ Г°ГЁГ Г­ГІ)
Procedure ParseControlParams(Args$, *Result.ControlParams)
  Protected Tail$, CleanTail$, LastQuote, Pos
  Protected.s arg1, arg2, arg3, arg4, arg5
  
  arg1 = StringField(Args$, 1, ",")
  arg2 = StringField(Args$, 2, ",")
  arg3 = StringField(Args$, 3, ",")
  arg4 = StringField(Args$, 4, ",")
  arg5 = StringField(Args$, 5, ",")
  
  *Result\Id = Val(CleanArg(arg1))
  *Result\X  = Val(CleanArg(arg2))
  *Result\Y  = Val(CleanArg(arg3))
  *Result\W  = Val(CleanArg(arg4))
  *Result\H  = Val(CleanArg(arg5))
  
  *Result\Text$  = "" : *Result\Flag = 0 : *Result\Param1 = 0 : *Result\Param2 = 0 : *Result\Param3 = 0
  
  If CountString(Args$, ",") > 4
    Protected HeadLen = Len(arg1+","+arg2+","+arg3+","+arg4+","+arg5)
    Pos = FindString(Args$, ",", HeadLen + 1)
    
    If Pos > 0
      Tail$ = Trim(Mid(Args$, Pos + 1))
      
      If Left(Tail$, 1) = Chr(34)
        LastQuote = FindString(Tail$, Chr(34), 2)
        If LastQuote
          *Result\Text$ = Mid(Tail$, 2, LastQuote - 2)
          CleanTail$ = Trim(Mid(Tail$, LastQuote + 1))
          If Left(CleanTail$, 1) = "," : CleanTail$ = Mid(CleanTail$, 2) : EndIf
          
          *Result\Flag   = Val(CleanArg(StringField(CleanTail$, 1, ",")))
          *Result\Param1 = Val(CleanArg(StringField(CleanTail$, 2, ",")))
          *Result\Param2 = Val(CleanArg(StringField(CleanTail$, 3, ",")))
          *Result\Param3 = Val(CleanArg(StringField(CleanTail$, 4, ",")))
        EndIf
      Else
        *Result\Flag   = Val(CleanArg(StringField(Tail$, 1, ",")))
        *Result\Param1 = Val(CleanArg(StringField(Tail$, 2, ",")))
        *Result\Param2 = Val(CleanArg(StringField(Tail$, 3, ",")))
        *Result\Param3 = Val(CleanArg(StringField(Tail$, 4, ",")))
      EndIf
    EndIf
  EndIf
EndProcedure

; ГЏГ Г°Г±ГҐГ° В№2: Г“Г­ГЁГўГҐГ°Г±Г Г«ГјГ­Г»Г© Г°Г Г§ГЎГ®Г° Г¤Г«Гї ГґГіГ­ГЄГ¶ГЁГ© (AddGadgetItem, SetGadgetText ГЁ ГІ.Г¤.)
Procedure ParseFunctionParams(Args$, *Result.FunctionParams)
  Protected FirstQ, LastQ
  
  ; ГЏГ® ГіГ¬Г®Г«Г·Г Г­ГЁГѕ Г®ГЎГ­ГіГ«ГїГҐГ¬ Г±ГІГ°ГіГЄГІГіГ°Гі
  *Result\Id = 0 : *Result\Value = 0 : *Result\Text$ = "" : *Result\Param1 = 0 : *Result\Param2 = 0
  
  ; ГЏГҐГ°ГўГ»ГҐ Г¤ГўГ  ГЇГ Г°Г Г¬ГҐГІГ°Г  Гі ГґГіГ­ГЄГ¶ГЁГ© ГЇГ®Г·ГІГЁ ГўГ±ГҐГЈГ¤Г  Г·ГЁГ±Г«Г  (ID ГЈГ Г¤Г¦ГҐГІГ , ГЇГ®Г§ГЁГ¶ГЁГї/Г±Г®Г±ГІГ®ГїГ­ГЁГҐ)
  *Result\Id    = Val(CleanArg(StringField(Args$, 1, ",")))
  *Result\Value = Val(CleanArg(StringField(Args$, 2, ",")))
  
  ; ГЃГҐГ§Г®ГЇГ Г±Г­Г® ГўГ»ГІГ Г±ГЄГЁГўГ ГҐГ¬ ГІГҐГЄГ±ГІ ГЁГ§ ГЄГ ГўГ»Г·ГҐГЄ, ГҐГ±Г«ГЁ Г®Г­ ГўГ®Г®ГЎГ№ГҐ ГҐГ±ГІГј Гў Г Г°ГЈГіГ¬ГҐГ­ГІГ Гµ
  FirstQ = FindString(Args$, Chr(34))
  LastQ  = FindString(Args$, Chr(34), FirstQ + 1)
  If FirstQ And LastQ
    *Result\Text$ = Mid(Args$, FirstQ + 1, LastQ - FirstQ - 1)
    
    ; Г…Г±Г«ГЁ ГЇГ®Г±Г«ГҐ ГЄГ ГўГ»Г·ГҐГЄ ГҐГ±ГІГј ГҐГ№ГҐ ГЇГ Г°Г Г¬ГҐГІГ°Г» Г·ГҐГ°ГҐГ§ Г§Г ГЇГїГІГіГѕ
    Protected Tail$ = Trim(Mid(Args$, LastQ + 1))
    If Left(Tail$, 1) = "," : Tail$ = Mid(Tail$, 2) : EndIf
    *Result\Param1 = Val(CleanArg(StringField(Tail$, 1, ",")))
    *Result\Param2 = Val(CleanArg(StringField(Tail$, 2, ",")))
  Else
    ; Г…Г±Г«ГЁ ГЄГ ГўГ»Г·ГҐГЄ Г± ГІГҐГЄГ±ГІГ®Г¬ Г­ГҐГІ, Г¤Г®ГЎГЁГ°Г ГҐГ¬ Г®Г±ГІГ ГўГёГЁГҐГ±Гї ГЇГ Г°Г Г¬ГҐГІГ°Г» ГЄГ ГЄ Г·ГЁГ±Г«Г 
    *Result\Param1 = Val(CleanArg(StringField(Args$, 3, ",")))
    *Result\Param2 = Val(CleanArg(StringField(Args$, 4, ",")))
  EndIf
EndProcedure


; Г”ГіГ­ГЄГ¶ГЁГї ГўГЁГ§ГіГ Г«ГЁГ§Г Г¶ГЁГЁ ГЇГ°ГҐГўГјГѕ (ГўГ®Г§ГўГ°Г Г№Г ГҐГІ ГўГ­ГіГІГ°ГҐГ­Г­ГЁГ© ID Г±Г®Г§Г¤Г Г­Г­Г®ГЈГ® Г®ГЄГ­Г )
Procedure.i ExecuteGuiPreview(Code$)
  Protected Count, i, Line$, Cmd$, Args$
  Protected PreviewWindowID = 0
  Protected G.ControlParams
  Protected F.FunctionParams
      
  Code$ = ReplaceString(Code$, #CRLF$, #LF$)
  Count = CountString(Code$, #LF$) + 1
  
  ; Г‘Г®ГµГ°Г Г­ГїГҐГ¬ ГІГҐГЄГіГ№ГҐГҐ Г±Г®Г±ГІГ®ГїГ­ГЁГҐ Г±Г®Г§Г¤Г Г­ГЁГї ГЈГ Г¤Г¦ГҐГІГ®Гў IDE
  Protected OldGadgetList = UseGadgetList(0)
  
  For i = 1 To Count
    Line$ = Trim(StringField(Code$, i, #LF$))
    If Line$ = "" Or Left(Line$, 1) = ";" : Continue : EndIf
    
    Protected LowLine$ = LCase(Line$)
    If Left(LowLine$, 2) = "if" : Line$ = Trim(Mid(Line$, 3)) : EndIf
    If Left(LowLine$, 5) = "endif" Or Left(LowLine$, 6) = "repeat" Or Left(LowLine$, 5) = "until" : Continue : EndIf
    
    Protected BracketPos = FindString(Line$, "(")
    If BracketPos
      Cmd$ = LCase(Trim(Left(Line$, BracketPos - 1)))
      Args$ = Mid(Line$, BracketPos + 1)
      
      If Right(Args$, 1) = ")" : Args$ = Left(Args$, Len(Args$) - 1) : EndIf
      If FindString(Args$, ")") : Args$ = StringField(Args$, 1, ")") : EndIf
      
      ; --- Г’Г…ГЏГ…ГђГњ ГЏГЂГђГ‘Г€ГЊ Г‚Г‘ВЁ Г—Г…ГђГ…Г‡ ГЋГ„ГЌГ“ Г”Г“ГЌГЉГ–Г€Гћ ---
      Select Cmd$
         ; ГѓГ°ГіГЇГЇГ  ГЂ: Г‚ГЁГ§ГіГ Г«ГјГ­Г»ГҐ ГЄГ®Г­ГІГ°Г®Г«Г» Г± ГЈГҐГ®Г¬ГҐГІГ°ГЁГҐГ©
         Case "openwindow",
              "buttongadget", 
              "stringgadget",
              "textgadget",
              "panelgadget",
              "scrollareagadget"
            ParseControlParams(Args$, @G)
            
            ; ГѓГ°ГіГЇГЇГ  ГЃ: Г”ГіГ­ГЄГ¶ГЁГЁ ГіГЇГ°Г ГўГ«ГҐГ­ГЁГї ГЁ Г¤ГЁГ­Г Г¬ГЁГ·ГҐГ±ГЄГ®ГЈГ® Г­Г ГЇГ®Г«Г­ГҐГ­ГЁГї
         Case "addgadgetitem", 
              "setgadgettext", 
              "setgadgetstate", 
              "setgadgetcolor", 
              "setgadgetfont"
            ParseFunctionParams(Args$, @F)
      EndSelect
      
      If Cmd$ = "openwindow"
        ; Г…Г±Г«ГЁ ГЅГІГ® Г®ГЄГ­Г®, ГЇГ°ГЁГ¬ГҐГ­ГїГҐГ¬ Г§Г Г№ГЁГІГ­Г»ГҐ Г§Г­Г Г·ГҐГ­ГЁГї ГЇГ® ГіГ¬Г®Г«Г·Г Г­ГЁГѕ, ГҐГ±Г«ГЁ ГЇГ Г°Г±ГҐГ° ГўГ»Г¤Г Г« Г­ГіГ«ГЁ
        If G\W = 0 : G\W = 300 : EndIf
        If G\H = 0 : G\H = 150 : EndIf
        If G\Text$ = "" : G\Text$ = "ГЏГ°ГҐГўГјГѕ ГЄГ®Г¤Г " : EndIf
        
        ; Г‘Г®Г§Г¤Г ГҐГ¬ ГЁГ§Г®Г«ГЁГ°Г®ГўГ Г­Г­Г®ГҐ Г®ГЄГ­Г® (ГґГ«Г ГЈГЁ Г¬Г®Г¦Г­Г® Г®Г±ГІГ ГўГЁГІГј ГґГЁГЄГ±ГЁГ°Г®ГўГ Г­Г­Г»Г¬ГЁ)
        PreviewWindowID = OpenWindow(#PB_Any, G\X, G\Y, G\W, G\H, G\Text$, #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
        
      Else
        ; Г„Г«Гї ГўГ±ГҐГµ Г®Г±ГІГ Г«ГјГ­Г»Гµ ГЄГ®Г¬Г Г­Г¤ ГЇГ°Г®ГўГҐГ°ГїГҐГ¬, Г·ГІГ® Г®ГЄГ­Г® ГЇГ°ГҐГўГјГѕ ГіГ¦ГҐ Г±Г®Г§Г¤Г Г­Г®
        If PreviewWindowID
          UseGadgetList(WindowID(PreviewWindowID))
          
          Select Cmd$
            Case "buttongadget"     : ButtonGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$)
            Case "stringgadget"     : StringGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$)
            Case "textgadget"       : TextGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$)
            Case "panelgadget"      : PanelGadget(G\Id, G\X, G\Y, G\W, G\H)
            Case "scrollareagadget" : ScrollAreaGadget(G\Id, G\X, G\Y, G\W, G\H, G\Flag, G\Param1, G\Param2)
              
            ; Г„ГЁГ­Г Г¬ГЁГ·ГҐГ±ГЄГ®ГҐ Г­Г ГЇГ®Г«Г­ГҐГ­ГЁГҐ
            Case "addgadgetitem"   : AddGadgetItem(F\Id, F\Value, F\Text$)
            Case "setgadgettext"   : SetGadgetText(F\Id, F\Text$)
            Case "setgadgetstate"  : SetGadgetState(F\Id, F\Value)
              
            ; ГЌГЋГ‚ГЂГџ ГЉГЋГЊГЂГЌГ„ГЂ: Г“Г±ГІГ Г­Г®ГўГЄГ  Г¶ГўГҐГІГ 
            ; Г‘ГЁГ­ГІГ ГЄГ±ГЁГ± PB: SetGadgetColor(#Gadget, ColorType, Color)
            ; Г‚ Г­Г ГёГҐГ© Г±ГІГ°ГіГЄГІГіГ°ГҐ: F\Id = #Gadget, F\Value = ColorType, F\Param1 = Color (Г°ГҐГ§ГіГ«ГјГІГ ГІ RGB/Г§Г­Г Г·ГҐГ­ГЁГҐ)
            Case "setgadgetcolor"  : SetGadgetColor(F\Id, F\Value, F\Param1)
              
            ; ГЌГЋГ‚ГЂГџ ГЉГЋГЊГЂГЌГ„ГЂ: Г“Г±ГІГ Г­Г®ГўГЄГ  ГёГ°ГЁГґГІГ 
            ; Г‘ГЁГ­ГІГ ГЄГ±ГЁГ± PB: SetGadgetFont(#Gadget, FontID)
            ; Г‚ Г­Г ГёГҐГ© Г±ГІГ°ГіГЄГІГіГ°ГҐ: F\Id = #Gadget, F\Value = FontID
            Case "setgadgetfont"   : SetGadgetFont(F\Id, F\Value)
               
            Case "closegadgetlist"
              CloseGadgetList()
              
          EndSelect
        EndIf
      EndIf
      
    EndIf
  Next i
  
  ; Г‚Г®Г§ГўГ°Г Г№Г ГҐГ¬ ГЄГ®Г­ГІГҐГЄГ±ГІ Г±Г®Г§Г¤Г Г­ГЁГї ГЈГ Г¤Г¦ГҐГІГ®Гў Г®ГЎГ°Г ГІГ­Г® Гў IDE
  If OldGadgetList : UseGadgetList(OldGadgetList) : EndIf
  
  ; Г…Г±Г«ГЁ Г®ГЄГ­Г® ГіГ±ГЇГҐГёГ­Г® Г±Г®Г§Г¤Г Г­Г®, Г¤ГҐГ«Г ГҐГ¬ ГҐГЈГ® Г ГЄГІГЁГўГ­Г»Г¬ ГЇГ®ГўГҐГ°Гµ IDE
  If PreviewWindowID
    SetActiveWindow(PreviewWindowID)
  EndIf
  
  ProcedureReturn PreviewWindowID
EndProcedure
; --- Г„Г…ГЊГЋГЌГ‘Г’ГђГЂГ–Г€Гџ Г–Г€ГЉГ‹ГЂ ГђГЂГЃГЋГ’Г› Г‚ IDE ---

#MainWindow = 10
#BtnLaunchPreview = 10
#EditorField = 20

; ГЋГІГЄГ°Г»ГўГ ГҐГ¬ ГЈГ«Г ГўГ­Г®ГҐ Г®ГЄГ­Г® ГўГ ГёГҐГ© IDE
OpenWindow(#MainWindow, 50, 50, 500, 400, "ГЉГ®Г­Г±ГІГ°ГіГЄГІГ®Г° ГЁГ­ГІГҐГ°ГґГҐГ©Г±Г  (IDE)", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
EditorGadget(#EditorField, 10, 10, 480, 320)
ButtonGadget(#BtnLaunchPreview, 10, 340, 480, 50, "ГЏГЋГ‘ГЊГЋГ’ГђГ…Г’Гњ Г€ГЌГ’Г…ГђГ”Г…Г‰Г‘ (ГЏГђГЂГ‚ГЉГЂ ГЉГЋГ„ГЂ)")

; Г‡Г ГЇГ®Г«Г­ГїГҐГ¬ ГЇГ®Г«ГҐ Г°ГҐГ¤Г ГЄГІГ®Г°Г  Г­Г Г·Г Г«ГјГ­Г»Г¬ ГЄГ®Г¤Г®Г¬
Define DefaultCode$ = "If OpenWindow(0, 100, 100, 300, 150, " + Chr(34) + "Г’ГҐГ±ГІГ®ГўГ®ГҐ ГЋГЄГ­Г®" + Chr(34) + ", #PB_Window_SystemMenu)" + #CRLF$ +
                      "  ButtonGadget(1, 20, 30, 260, 35, " + Chr(34) + "ГЌГ Г¦Г¬ГЁ Г¬ГҐГ­Гї" + Chr(34) + ")" + #CRLF$ +
                      "  StringGadget(2, 20, 80, 260, 30, " + Chr(34) + "Г’ГҐГЄГ±ГІ..." + Chr(34) + ")" + #CRLF$ +
                      "EndIf"
                      
                      ; Г‚ ГЅГІГ®Г¬ ГІГҐГ±ГІГҐ ГЇГ°Г®ГўГҐГ°ГїГҐГ¬ Г±Г°Г Г§Гі: ГЋГЄГ­Г®, ГЉГ­Г®ГЇГЄГі, ГЏГ Г­ГҐГ«Гј (5 ГЇГ Г°Г Г¬ГҐГІГ°Г®Гў) ГЁ ГўГЄГ«Г Г¤ГЄГЁ AddGadgetItem
Define DefaultCode$ = "If OpenWindow(0, 100, 100, 360, 250, " + Chr(34) + "Г’ГҐГ±ГІ ГЇГ Г­ГҐГ«ГҐГ© ГЁ ГЄГ­Г®ГЇГ®ГЄ" + Chr(34) + ", #PB_Window_SystemMenu)" + #CRLF$ +
                          "  PanelGadget(1, 10, 10, 340, 180)" + #CRLF$ +
                          "    AddGadgetItem(1, -1, " + Chr(34) + "Г‚ГЄГ«Г Г¤ГЄГ  1" + Chr(34) + ")" + #CRLF$ +
                          "      ButtonGadget(2, 20, 30, 150, 40, " + Chr(34) + "ГЉГ­Г®ГЇГЄГ  Г­Г  ГІГ ГЎГҐ 1" + Chr(34) + ")" + #CRLF$ +
                          "      StringGadget(3, 20, 90, 200, 30, " + Chr(34) + "Г’ГҐГЄГ±ГІ..." + Chr(34) + ")" + #CRLF$ +
                          "    AddGadgetItem(1, -1, " + Chr(34) + "Г‚ГЄГ«Г Г¤ГЄГ  2" + Chr(34) + ")" + #CRLF$ +
                          "      TextGadget(4, 20, 30, 200, 20, " + Chr(34) + "ГЉГ®Г­ГІГҐГ­ГІ ГўГІГ®Г°Г®Г© ГўГЄГ«Г Г¤ГЄГЁ" + Chr(34) + ")" + #CRLF$ +
                          "  CloseGadgetList()" + #CRLF$ +
                          "  ButtonGadget(5, 10, 200, 340, 40, " + Chr(34) + "ГЋГЎГ№Г Гї ГЄГ­Г®ГЇГЄГ  ГўГ­ГЁГ§Гі" + Chr(34) + ")" + #CRLF$ +
                          "EndIf"

SetGadgetText(#EditorField, DefaultCode$)

Define CurrentPreview = 0

; ГѓГ«Г ГўГ­Г»Г© Г¶ГЁГЄГ« Г®ГЎГ°Г ГЎГ®ГІГЄГЁ Г±Г®ГЎГ»ГІГЁГ© IDE
Repeat
  Define Event = WaitWindowEvent()
  Define EventWindow = EventWindow()
  
  Select Event
    Case #PB_Event_Gadget
      ; 1. ГЏГ°Г®ГўГҐГ°ГїГҐГ¬ Г±Г®ГЎГ»ГІГЁГї Г­Г  ГЈГ«Г ГўГ­Г®Г¬ Г®ГЄГ­ГҐ IDE
      If EventWindow = #MainWindow
        If EventGadget() = #BtnLaunchPreview
          
          ; Г…Г±Г«ГЁ ГЇГ®Г«ГјГ§Г®ГўГ ГІГҐГ«Гј Г§Г ГЎГ»Г« Г§Г ГЄГ°Г»ГІГј Г±ГІГ Г°Г®ГҐ ГЇГ°ГҐГўГјГѕ В— Г§Г ГЄГ°Г»ГўГ ГҐГ¬ ГҐГЈГ® ГЇГ°ГЁГ­ГіГ¤ГЁГІГҐГ«ГјГ­Г®
          If CurrentPreview And IsWindow(CurrentPreview)
            CloseWindow(CurrentPreview)
          EndIf
          
          ; ГЃГҐГ°ГҐГ¬ ГІГҐГЄГіГ№ГЁГ© ГЁГ§Г¬ГҐГ­ГҐГ­Г­Г»Г© ГІГҐГЄГ±ГІ ГЁГ§ Г°ГҐГ¤Г ГЄГІГ®Г°Г  ГЁ Г§Г ГЇГіГ±ГЄГ ГҐГ¬ ГЇГ°ГҐГўГјГѕ
          Define UserCode$ = GetGadgetText(#EditorField)
          CurrentPreview = ExecuteGuiPreview(UserCode$)
          
        EndIf
        
      ; 2. ГЏГ°Г®ГўГҐГ°ГїГҐГ¬ Г±Г®ГЎГ»ГІГЁГї ГўГ­ГіГІГ°ГЁ Г®ГЄГ­Г  ГЏГђГ…Г‚ГњГћ
      ElseIf EventWindow = CurrentPreview
        ; Г‡Г¤ГҐГ±Гј Г¬Г®Г¦Г­Г® Г®ГІГ±Г«ГҐГ¦ГЁГўГ ГІГј ГЁГ­ГІГҐГ°Г ГЄГІГЁГўГ­Г®Г±ГІГј ГЄГ­Г®ГЇГ®ГЄ ГЁГ§ ГЇГ°ГҐГўГјГѕ, ГҐГ±Г«ГЁ ГЇГ®ГІГ°ГҐГЎГіГҐГІГ±Гї
        ; ГЌГ ГЇГ°ГЁГ¬ГҐГ°: If EventGadget() = 1 : Debug "ГЌГ Г¦Г ГІГ  ГЄГ­Г®ГЇГЄГ  ГЁГ§ ГЇГ°ГҐГўГјГѕ!" : EndIf
      EndIf
      
    Case #PB_Event_CloseWindow
      ; ГЉГ®Г°Г°ГҐГЄГІГ­Г® Г°Г Г§Г¤ГҐГ«ГїГҐГ¬ Г§Г ГЄГ°Г»ГІГЁГҐ Г®ГЄГ®Г­
      If EventWindow = #MainWindow
        End ; Г‡Г ГЄГ°Г»Г«ГЁ IDE -> Г‚Г»ГµГ®Г¤ ГЁГ§ ГЇГ°Г®ГЈГ°Г Г¬Г¬Г»
      ElseIf EventWindow = CurrentPreview
        CloseWindow(CurrentPreview) ; Г‡Г ГЄГ°Г»Г«ГЁ ГЏГ°ГҐГўГјГѕ -> ГЏГ°Г®Г±ГІГ® ГіГ­ГЁГ·ГІГ®Г¦Г ГҐГ¬ ГҐГЈГ®, IDE Г¦ГЁГўГҐГІ
        CurrentPreview = 0
      EndIf
      
  EndSelect
ForEver
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; Folding = -------
; EnableXP
; DPIAware