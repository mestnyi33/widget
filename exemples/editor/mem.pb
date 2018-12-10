Global TestString.s, *Pointer, *Buffer

TestString = "This is a test string"
*Buffer = AllocateMemory(10000000)
*Pointer = *Buffer

Global TextCount, TextString.s

Procedure.i Text_memAddLine(*This, Line.i, Text.s)
    Protected Result.i, String.s, i.i
    
;     With *This
      If (Line > TextCount Or Line < 0)
        Line = TextCount
      EndIf
      
      For i = 0 To TextCount
        If Line = i
          If String.s
            String.s +#LF$+ Text
          Else
            String.s + Text
          EndIf
        EndIf
        
        If String.s
          String.s +#LF$+ StringField(TextString, i + 1, #LF$) 
        Else
          String.s + StringField(TextString, i + 1, #LF$)
        EndIf
      Next : TextCount = i
      
      If TextString <> String.s
        TextString = String.s
;         \Text\Len = Len(String.s)
;         \Text\Change = 1
        Result = 1
      EndIf
;     EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  Define time = ElapsedMilliseconds()
For a = 0 To 15000
  
  ;s.s+TestString ; 8928
  CopyMemoryString(PeekS(@TestString), @*Pointer) ; 3
  
Next

Debug "time "+Str(ElapsedMilliseconds()-time) +" "+ PeekS(*Buffer)

; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --
; EnableXP