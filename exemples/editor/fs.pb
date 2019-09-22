EnableExplicit
DisableDebugger

Global Text.s, String.s, a,f,f1,l,time.i, c.s = #LF$ + #CR$, LN.i=50000
Global NewList String.s()

Global *Buffer = AllocateMemory(LN*100)
Global *Pointer = *Buffer
Global pos,len

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
           "Otherwise it will not work." ;+ m.s +
  
  time = ElapsedMilliseconds()
For a = 0 To LN
  Text.s = "Item "+Str(a) + c
  CopyMemoryString(PeekS(@Text), @*Pointer) ; 3
Next
Text = PeekS(*Buffer)
Text.s = Trim(Text.s, #LF$)
Text.s = Trim(Text.s, #CR$)
; Debug Str(ElapsedMilliseconds()-time) + " text collection time"


  LN = CountString(Text, #LF$)
  
time = ElapsedMilliseconds()
For a = 1 To LN
;   f=f1 : f1 = FindString(Text.s, c, f1+1) : l=f1-f
;   
;   If a = LN
;     String.s = Trim(Mid(Text.s, f1-l), c)
;   Else
;     String.s = Mid(Text.s, f1-l+1, l)
;   EndIf
  
  
  String.s = StringField(Text.s, a, #LF$)
;   Len = Len(String)
;   Debug "f - "+ CountString(String, #CR$) +" "+ CountString(String, #LF$) +" - "+ Pos +" "+ Len +" "+ String.s
;   pos + Len + 1
                    
  AddElement(String()) 
  String() = String.s
Next

MessageRequester( "", Str(ElapsedMilliseconds()-time) + " text parse time "+#CRLF$+"all count "+ListSize(String()))


; IDE Options = PureBasic 5.62 (MacOS X - x64)
; EnableXP