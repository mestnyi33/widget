EnableExplicit

Global Text.s, String.s, a,f,f1,l,time.i, c.s = #LF$, LN.i=5;00000;0
Global NewList String.s()

Global *Buffer = AllocateMemory(LN*100)
Global *Pointer = *Buffer

time = ElapsedMilliseconds()
For a = 0 To LN
  Text.s = "Item "+Str(a) + c
  CopyMemoryString(PeekS(@Text), @*Pointer) ; 3
Next
Text = PeekS(*Buffer)
Text.s = Trim(Text.s, c)
Debug Str(ElapsedMilliseconds()-time) + " text collection time"



time = ElapsedMilliseconds()

; This expression will match every word of 3 letter which begin by a lower case letter,
  ; followed with the character 'b' and which ends with an uppercase letter. ex: abC
  ; Each match is printed with its position in the original string.
  ;    
;If CreateRegularExpression(0, ~".*\n?")
If CreateRegularExpression(0, ~"^.*", #PB_RegularExpression_MultiLine)
  If ExamineRegularExpression(0, Text.s)
    While NextRegularExpressionMatch(0)
      ;String.s = RegularExpressionMatchString(0)
     ; String.s = Trim(RegularExpressionMatchString(0), c)
      ;         Debug "    Position: " + Str(RegularExpressionMatchPosition(0))
      ;         Debug "    Length: " + Str(RegularExpressionMatchLength(0))
      
      AddElement(String()) 
      String() =  RegularExpressionMatchString(0) ;Trim(RegularExpressionMatchString(0), c)
      
    Wend
  EndIf
Else
  Debug RegularExpressionError()
EndIf

;String.s = StringField(Text.s, a+1, c) + c
  
  Debug Str(ElapsedMilliseconds()-time) + " text parse time "
Debug "all count "+ListSize(String())

ForEach String()
    Debug "get - "+String()
 Next
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -
; EnableXP