EnableExplicit
;DisableDebugger

Global Text.s, String.s, a,f,f1,l,time.i, c.s = #LF$, LN.i=5;00000
Global NewList String.s()

Global *Buffer = AllocateMemory(LN*100)
Global *Pointer = *Buffer
Global pos,len

Procedure StringFields (String$, List Fields$(), Separator$)
  ;BESCHREIBUNG: Zerlegt String$ in Teilstrings, welche durch Separator$ getrennt sind und
  ;              stellt diese in die List Fields$.
  ;PARAMETER   : String$    = Der zu durchsuchende String
  ;              Fields$()  = List in die die Teilstrings gestellt werden
  ;              Separator$ = Trennzeichen (auch mehrere Zeichen)
  ;RÜCKGABEWERT: keiner
  ; ОПИСАНИЕ: разбивает строку $ на подстроки, разделенные разделителем $ и
  ; положить их в список полей $.
  ; PARAMETER: String $ = Строка для поиска
  ; Поля $ () = Список, в который помещаются подстроки
  ; Разделитель $ = разделитель (также несколько символов)
  ; ВОЗВРАЩАЕМОЕ ЗНАЧЕНИЕ: нет
  ;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
  Structure CHARARRAY : c.c[0] : EndStructure
  Protected *Sta.CHARARRAY
  Protected *End.CHARARRAY
  Protected *Sep.CHARARRAY
  Protected LenSeparator
  Protected IsMatched
  Protected i, String.s
  
  #SOC  = SizeOf (Character)
  
  *Sta = @String$
  *End = @String$
  *Sep = @Separator$
  
  LenSeparator = Len (Separator$)
  
  ;Single Sign Separator
  If LenSeparator = 1
    
    While *End\c
     ; Debug *End\c
     If *End\c = *Sep\c ;Or Not *End\c
        String = PeekS (*Sta, (*End-*Sta)/#SOC)
        
        Len = Len(String)
        Debug "f - "+ CountString(String, #CR$) +" "+ CountString(String, #LF$) +" - "+ Pos +" "+ Len +" "+ String.s
        pos + Len + 1
        
       
        AddElement (Fields$())
        Fields$() = String
        
        *Sta = *End + #SOC
      EndIf
      
      *End + #SOC
    Wend
    
    ;     AddElement (Fields$())
    ;     Fields$() = PeekS (*Sta, (*End-*Sta)/#SOC)
    
    ;Multi Sign Separator
  Else
    
    While *End\c
      IsMatched = #True
      
      For i = 0 To LenSeparator - 1
        If *End\c[i] <> *Sep\c[i]
          IsMatched = #False
          Break
        EndIf
      Next
      
      If IsMatched
        String = PeekS (*Sta, (*End-*Sta)/#SOC)
        
        Len = Len(String)
        Debug "f1 - "+ CountString(String, #CR$) +" "+ CountString(String, #LF$) +" - "+ Pos +" "+ Len +" "+ String.s
        pos + Len + 1
        
        AddElement (Fields$())
        Fields$() = String
        *Sta = *End + LenSeparator * #SOC
        *End + LenSeparator * #SOC
      Else
        *End + #SOC
      EndIf
    Wend
    ; 
    ;     AddElement (Fields$())
    ;     Fields$() = PeekS (*Sta, (*End-*Sta)/#SOC)
    
  EndIf
  
EndProcedure

Define m.s=#LF$  ; #CRLF$;

Text.s = "This is a long line." + m.s +
         "Who should show." + m.s +
         m.s +
         m.s +
         m.s +
         "I have to write the text in the box or not." + m.s +
         m.s +
         m.s +
         m.s +
         "The string must be very long." + m.s +
         "Otherwise it will not work." + m.s 

; time = ElapsedMilliseconds()
; For a = 0 To LN
;   Text.s = "Item "+Str(a) + c
;   CopyMemoryString(PeekS(@Text), @*Pointer) ; 3
; Next
; Text = PeekS(*Buffer)
; ;Text.s = Trim(Text.s, c)
; Debug Str(ElapsedMilliseconds()-time) + " text collection time"



time = ElapsedMilliseconds()
StringFields (Text, String(), c)
Debug Str(ElapsedMilliseconds()-time) + " text parse time "
Debug "all count "+ListSize(String())
; MessageRequester( "", Str(ElapsedMilliseconds()-time) + " text parse time "+#CRLF$+"all count "+ListSize(String()))


; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --
; EnableXP