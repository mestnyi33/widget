EnableExplicit

; --- ÑÒÐÓÊÒÓÐÛ ---

; Äëÿ îêîí è ãàäæåòîâ (ñ ãåîìåòðèåé)
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

; Äëÿ ñåðâèñíûõ ôóíêöèé è êîìàíä óïðàâëåíèÿ
Structure FunctionParams
  ID.i
  Value.i
  Text$
  Param1.i
  Param2.i
EndStructure


; --- ÏÐÎÖÅÄÓÐÛ ÏÀÐÑÈÍÃÀ ---

; Î÷èñòêà ñòðîê (îñòàåòñÿ áåç èçìåíåíèé)
Procedure.s CleanArg(Value$)
  Value$ = Trim(Value$)
  Value$ = RemoveString(Value$, Chr(34))
  ProcedureReturn Value$
EndProcedure

; Óìíûé âû÷èñëèòåëü àðãóìåíòîâ. Ïîíèìàåò ÷èñëà, êîíñòàíòû è ôóíêöèè RGB/RGBA
Procedure.i EvaluateArg(Value$)
  Value$ = Trim(Value$)
  Value$ = RemoveString(Value$, Chr(34)) ; Óáèðàåì êàâû÷êè, åñëè îíè ïðîñêî÷èëè
  Protected LowVal$ = LCase(Value$)
  
  ; 1. ÎÁÐÀÁÎÒÊÀ ÑÈÑÒÅÌÍÛÕ ÊÎÍÑÒÀÍÒ PUREBASIC
  If Left(LowVal$, 4) = "#pb_"
    Select LowVal$
      ; Êîíñòàíòû òèïîâ öâåòà ãàäæåòîâ
      Case "#pb_gadget_frontcolor" : ProcedureReturn 0
      Case "#pb_gadget_backcolor"  : ProcedureReturn 1
      Case "#pb_gadget_linecolor"  : ProcedureReturn 2
        
      ; Êîíñòàíòû ôëàãîâ îêîí (äëÿ ïðèìåðà, ìîæíî ðàñøèðÿòü)
      Case "#pb_window_systemmenu"     : ProcedureReturn #PB_Window_SystemMenu
      Case "#pb_window_screencentered" : ProcedureReturn #PB_Window_ScreenCentered
        
      ; Êîíñòàíòû ïîçèöèé äëÿ AddGadgetItem
      Case "#pb_any" : ProcedureReturn #PB_Any
    EndSelect
  EndIf
  
  ; 2. ÎÁÐÀÁÎÒÊÀ ÄÈÍÀÌÈ×ÅÑÊÈÕ ÔÓÍÊÖÈÉ ÖÂÅÒÀ
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
  
  ; 3. ÎÁÛ×ÍÎÅ ×ÈÑËÎ (èëè áèòîâûå ìàñêè, åñëè îíè ñêëååíû êàê ñòðîêè)
  ; Åñëè â ñòðîêå îñòàëñÿ ðàçäåëèòåëü "|" îò êîíñòàíò, ñ÷èòàåì èõ ñóììó
  If FindString(Value$, "|")
    Protected i, Sum = 0, PartsCount = CountString(Value$, "|") + 1
    For i = 1 To PartsCount
      Sum | EvaluateArg(StringField(Value$, i, "|"))
    Next i
    ProcedureReturn Sum
  EndIf
  
  ProcedureReturn Val(Value$)
EndProcedure
; Ïàðñåð ¹1: Äëÿ ýëåìåíòîâ óïðàâëåíèÿ (Âàø îïòèìèçèðîâàííûé âàðèàíò)
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

; Ïàðñåð ¹2: Óíèâåðñàëüíûé ðàçáîð äëÿ ôóíêöèé (AddGadgetItem, SetGadgetText è ò.ä.)
Procedure ParseFunctionParams(Args$, *Result.FunctionParams)
  Protected FirstQ, LastQ
  
  ; Ïî óìîë÷àíèþ îáíóëÿåì ñòðóêòóðó
  *Result\Id = 0 : *Result\Value = 0 : *Result\Text$ = "" : *Result\Param1 = 0 : *Result\Param2 = 0
  
  ; Ïåðâûå äâà ïàðàìåòðà ó ôóíêöèé ïî÷òè âñåãäà ÷èñëà (ID ãàäæåòà, ïîçèöèÿ/ñîñòîÿíèå)
  *Result\Id    = Val(CleanArg(StringField(Args$, 1, ",")))
  *Result\Value = Val(CleanArg(StringField(Args$, 2, ",")))
  
  ; Áåçîïàñíî âûòàñêèâàåì òåêñò èç êàâû÷åê, åñëè îí âîîáùå åñòü â àðãóìåíòàõ
  FirstQ = FindString(Args$, Chr(34))
  LastQ  = FindString(Args$, Chr(34), FirstQ + 1)
  If FirstQ And LastQ
    *Result\Text$ = Mid(Args$, FirstQ + 1, LastQ - FirstQ - 1)
    
    ; Åñëè ïîñëå êàâû÷åê åñòü åùå ïàðàìåòðû ÷åðåç çàïÿòóþ
    Protected Tail$ = Trim(Mid(Args$, LastQ + 1))
    If Left(Tail$, 1) = "," : Tail$ = Mid(Tail$, 2) : EndIf
    *Result\Param1 = Val(CleanArg(StringField(Tail$, 1, ",")))
    *Result\Param2 = Val(CleanArg(StringField(Tail$, 2, ",")))
  Else
    ; Åñëè êàâû÷åê ñ òåêñòîì íåò, äîáèðàåì îñòàâøèåñÿ ïàðàìåòðû êàê ÷èñëà
    *Result\Param1 = Val(CleanArg(StringField(Args$, 3, ",")))
    *Result\Param2 = Val(CleanArg(StringField(Args$, 4, ",")))
  EndIf
EndProcedure


; Ôóíêöèÿ âèçóàëèçàöèè ïðåâüþ (âîçâðàùàåò âíóòðåííèé ID ñîçäàííîãî îêíà)
Procedure.i ExecuteGuiPreview(Code$)
  Protected Count, i, Line$, Cmd$, Args$
  Protected PreviewWindowID = 0
  Protected G.ControlParams
  Protected F.FunctionParams
      
  Code$ = ReplaceString(Code$, #CRLF$, #LF$)
  Count = CountString(Code$, #LF$) + 1
  
  ; Ñîõðàíÿåì òåêóùåå ñîñòîÿíèå ñîçäàíèÿ ãàäæåòîâ IDE
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
      
      ; --- ÒÅÏÅÐÜ ÏÀÐÑÈÌ ÂÑ¨ ×ÅÐÅÇ ÎÄÍÓ ÔÓÍÊÖÈÞ ---
      Select Cmd$
         ; Ãðóïïà À: Âèçóàëüíûå êîíòðîëû ñ ãåîìåòðèåé
         Case "openwindow",
              "buttongadget", 
              "stringgadget",
              "textgadget",
              "panelgadget",
              "scrollareagadget"
            ParseControlParams(Args$, @G)
            
            ; Ãðóïïà Á: Ôóíêöèè óïðàâëåíèÿ è äèíàìè÷åñêîãî íàïîëíåíèÿ
         Case "addgadgetitem", 
              "setgadgettext", 
              "setgadgetstate", 
              "setgadgetcolor", 
              "setgadgetfont"
            ParseFunctionParams(Args$, @F)
      EndSelect
      
      If Cmd$ = "openwindow"
        ; Åñëè ýòî îêíî, ïðèìåíÿåì çàùèòíûå çíà÷åíèÿ ïî óìîë÷àíèþ, åñëè ïàðñåð âûäàë íóëè
        If G\W = 0 : G\W = 300 : EndIf
        If G\H = 0 : G\H = 150 : EndIf
        If G\Text$ = "" : G\Text$ = "Ïðåâüþ êîäà" : EndIf
        
        ; Ñîçäàåì èçîëèðîâàííîå îêíî (ôëàãè ìîæíî îñòàâèòü ôèêñèðîâàííûìè)
        PreviewWindowID = OpenWindow(#PB_Any, G\X, G\Y, G\W, G\H, G\Text$, #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
        
      Else
        ; Äëÿ âñåõ îñòàëüíûõ êîìàíä ïðîâåðÿåì, ÷òî îêíî ïðåâüþ óæå ñîçäàíî
        If PreviewWindowID
          UseGadgetList(WindowID(PreviewWindowID))
          
          Select Cmd$
            Case "buttongadget"     : ButtonGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$)
            Case "stringgadget"     : StringGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$)
            Case "textgadget"       : TextGadget(G\Id, G\X, G\Y, G\W, G\H, G\Text$)
            Case "panelgadget"      : PanelGadget(G\Id, G\X, G\Y, G\W, G\H)
            Case "scrollareagadget" : ScrollAreaGadget(G\Id, G\X, G\Y, G\W, G\H, G\Flag, G\Param1, G\Param2)
              
            ; Äèíàìè÷åñêîå íàïîëíåíèå
            Case "addgadgetitem"   : AddGadgetItem(F\Id, F\Value, F\Text$)
            Case "setgadgettext"   : SetGadgetText(F\Id, F\Text$)
            Case "setgadgetstate"  : SetGadgetState(F\Id, F\Value)
              
            ; ÍÎÂÀß ÊÎÌÀÍÄÀ: Óñòàíîâêà öâåòà
            ; Ñèíòàêñèñ PB: SetGadgetColor(#Gadget, ColorType, Color)
            ; Â íàøåé ñòðóêòóðå: F\Id = #Gadget, F\Value = ColorType, F\Param1 = Color (ðåçóëüòàò RGB/çíà÷åíèå)
            Case "setgadgetcolor"  : SetGadgetColor(F\Id, F\Value, F\Param1)
              
            ; ÍÎÂÀß ÊÎÌÀÍÄÀ: Óñòàíîâêà øðèôòà
            ; Ñèíòàêñèñ PB: SetGadgetFont(#Gadget, FontID)
            ; Â íàøåé ñòðóêòóðå: F\Id = #Gadget, F\Value = FontID
            Case "setgadgetfont"   : SetGadgetFont(F\Id, F\Value)
               
            Case "closegadgetlist"
              CloseGadgetList()
              
          EndSelect
        EndIf
      EndIf
      
    EndIf
  Next i
  
  ; Âîçâðàùàåì êîíòåêñò ñîçäàíèÿ ãàäæåòîâ îáðàòíî â IDE
  If OldGadgetList : UseGadgetList(OldGadgetList) : EndIf
  
  ; Åñëè îêíî óñïåøíî ñîçäàíî, äåëàåì åãî àêòèâíûì ïîâåðõ IDE
  If PreviewWindowID
    SetActiveWindow(PreviewWindowID)
  EndIf
  
  ProcedureReturn PreviewWindowID
EndProcedure
; --- ÄÅÌÎÍÑÒÐÀÖÈß ÖÈÊËÀ ÐÀÁÎÒÛ Â IDE ---

#MainWindow = 10
#BtnLaunchPreview = 10
#EditorField = 20

; Îòêðûâàåì ãëàâíîå îêíî âàøåé IDE
OpenWindow(#MainWindow, 50, 50, 500, 400, "Êîíñòðóêòîð èíòåðôåéñà (IDE)", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
EditorGadget(#EditorField, 10, 10, 480, 320)
ButtonGadget(#BtnLaunchPreview, 10, 340, 480, 50, "ÏÎÑÌÎÒÐÅÒÜ ÈÍÒÅÐÔÅÉÑ (ÏÐÀÂÊÀ ÊÎÄÀ)")

; Çàïîëíÿåì ïîëå ðåäàêòîðà íà÷àëüíûì êîäîì
Define DefaultCode$ = "If OpenWindow(0, 100, 100, 300, 150, " + Chr(34) + "Òåñòîâîå Îêíî" + Chr(34) + ", #PB_Window_SystemMenu)" + #CRLF$ +
                      "  ButtonGadget(1, 20, 30, 260, 35, " + Chr(34) + "Íàæìè ìåíÿ" + Chr(34) + ")" + #CRLF$ +
                      "  StringGadget(2, 20, 80, 260, 30, " + Chr(34) + "Òåêñò..." + Chr(34) + ")" + #CRLF$ +
                      "EndIf"
                      
                      ; Â ýòîì òåñòå ïðîâåðÿåì ñðàçó: Îêíî, Êíîïêó, Ïàíåëü (5 ïàðàìåòðîâ) è âêëàäêè AddGadgetItem
Define DefaultCode$ = "If OpenWindow(0, 100, 100, 360, 250, " + Chr(34) + "Òåñò ïàíåëåé è êíîïîê" + Chr(34) + ", #PB_Window_SystemMenu)" + #CRLF$ +
                          "  PanelGadget(1, 10, 10, 340, 180)" + #CRLF$ +
                          "    AddGadgetItem(1, -1, " + Chr(34) + "Âêëàäêà 1" + Chr(34) + ")" + #CRLF$ +
                          "      ButtonGadget(2, 20, 30, 150, 40, " + Chr(34) + "Êíîïêà íà òàáå 1" + Chr(34) + ")" + #CRLF$ +
                          "      StringGadget(3, 20, 90, 200, 30, " + Chr(34) + "Òåêñò..." + Chr(34) + ")" + #CRLF$ +
                          "    AddGadgetItem(1, -1, " + Chr(34) + "Âêëàäêà 2" + Chr(34) + ")" + #CRLF$ +
                          "      TextGadget(4, 20, 30, 200, 20, " + Chr(34) + "Êîíòåíò âòîðîé âêëàäêè" + Chr(34) + ")" + #CRLF$ +
                          "  CloseGadgetList()" + #CRLF$ +
                          "  ButtonGadget(5, 10, 200, 340, 40, " + Chr(34) + "Îáùàÿ êíîïêà âíèçó" + Chr(34) + ")" + #CRLF$ +
                          "EndIf"

SetGadgetText(#EditorField, DefaultCode$)

Define CurrentPreview = 0

; Ãëàâíûé öèêë îáðàáîòêè ñîáûòèé IDE
Repeat
  Define Event = WaitWindowEvent()
  Define EventWindow = EventWindow()
  
  Select Event
    Case #PB_Event_Gadget
      ; 1. Ïðîâåðÿåì ñîáûòèÿ íà ãëàâíîì îêíå IDE
      If EventWindow = #MainWindow
        If EventGadget() = #BtnLaunchPreview
          
          ; Åñëè ïîëüçîâàòåëü çàáûë çàêðûòü ñòàðîå ïðåâüþ  çàêðûâàåì åãî ïðèíóäèòåëüíî
          If CurrentPreview And IsWindow(CurrentPreview)
            CloseWindow(CurrentPreview)
          EndIf
          
          ; Áåðåì òåêóùèé èçìåíåííûé òåêñò èç ðåäàêòîðà è çàïóñêàåì ïðåâüþ
          Define UserCode$ = GetGadgetText(#EditorField)
          CurrentPreview = ExecuteGuiPreview(UserCode$)
          
        EndIf
        
      ; 2. Ïðîâåðÿåì ñîáûòèÿ âíóòðè îêíà ÏÐÅÂÜÞ
      ElseIf EventWindow = CurrentPreview
        ; Çäåñü ìîæíî îòñëåæèâàòü èíòåðàêòèâíîñòü êíîïîê èç ïðåâüþ, åñëè ïîòðåáóåòñÿ
        ; Íàïðèìåð: If EventGadget() = 1 : Debug "Íàæàòà êíîïêà èç ïðåâüþ!" : EndIf
      EndIf
      
    Case #PB_Event_CloseWindow
      ; Êîððåêòíî ðàçäåëÿåì çàêðûòèå îêîí
      If EventWindow = #MainWindow
        End ; Çàêðûëè IDE -> Âûõîä èç ïðîãðàììû
      ElseIf EventWindow = CurrentPreview
        CloseWindow(CurrentPreview) ; Çàêðûëè Ïðåâüþ -> Ïðîñòî óíè÷òîæàåì åãî, IDE æèâåò
        CurrentPreview = 0
      EndIf
      
  EndSelect
ForEver
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 349
; Folding = -------
; EnableXP
; DPIAware