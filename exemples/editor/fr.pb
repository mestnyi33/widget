EnableExplicit
DisableDebugger

Global Text.s, String.s, a,f,f1,l,time.i, c.s = #LF$ + #CR$
Global LN.i=500000;0
                ;Global Text.s, String.s, a,f,f1,l,time.i, c.s = #CR$ + #LF$, LN.i=5;00000;0
Global NewList String.s()

Global *Buffer = AllocateMemory(LN*100)
Global *Pointer = *Buffer
Global pos,len

Define m.s=#LF$ ; #CRLF$;

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
         "Otherwise it will not work." ;+ m.s +




time = ElapsedMilliseconds()
For a = 0 To LN
  Text.s = "Item "+Str(a) + c
  CopyMemoryString(PeekS(@Text), @*Pointer) ; 3
Next
Text = PeekS(*Buffer)
;Text.s = Trim(Text.s, c)
Text.s = Trim(Text.s, #LF$)
; Text.s = Trim(Text.s, #CR$)
;Text.s = Trim(Text.s, #LF$)
;Debug Str(ElapsedMilliseconds()-time) + " text collection time"


time = ElapsedMilliseconds()
;If CreateRegularExpression(0, ~"^.*", #PB_RegularExpression_MultiLine)
;If CreateRegularExpression(0, ~"(^.*)?", #PB_RegularExpression_MultiLine)
If CreateRegularExpression(0, ~".*\n?")
  If ExamineRegularExpression(0, Trim(Text.s, #CR$))
    While NextRegularExpressionMatch(0)
      
      AddElement(String()) 
      String() =  Trim(RegularExpressionMatchString(0), #LF$) ; RegularExpressionMatchString(0), #CR$)
;       pos = RegularExpressionMatchPosition(0)
;       len = RegularExpressionMatchLength(0)
      ; Debug "g - "+CountString(String(), #CR$) +" "+ CountString(String(), #LF$) +" "+ RegularExpressionMatchPosition(0) +" "+ RegularExpressionMatchLength(0) +" "+ String() 
    Wend
  EndIf
Else
  Debug RegularExpressionError()
EndIf

MessageRequester( "", Str(ElapsedMilliseconds()-time) + " text parse time "+#CRLF$+"all count "+ListSize(String()))

; ForEach String()
;     Debug "get - "+String() +" "+ CountString(String(), #CR$)
;  Next
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -
; EnableXP