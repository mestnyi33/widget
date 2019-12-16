
Define m.s=#LF$
Global Text.s = "aaa bbb ccc "+m.s+"ddd eee fff "+m.s
Define String.s

Text.s = "This is a long line." + m.s +
           "Who should show." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "I have to write the text in the box or not." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work." ;+ m.s; +
  
#__sOC = SizeOf(Character)

item = 0

Procedure.s add(item, Text.s)
  Static len
  Protected i, l, String.s
  
  String.s = StringField(Text, item+1, #LF$)
  len = Len(String)
            
  Define *Sta.Character = @Text
  Define *End.Character = @Text
  ll = len
  
  While *End\c 
    If *End\c = #LF 
      If item = i
        Break 
      Else
        ll + (*End-*Sta)/#__sOC
      EndIf
      i+1
      
      *Sta = *End + #__sOC 
    EndIf 
    *End + #__sOC 
  Wend
  
  Debug ll
  
  len = ll+Item-len
  If item=10
    String = InsertString(text, "_"+#LF$, len+1)
  Else
    String = InsertString(text, "Line_"+Str(item)+#LF$, len+1)
  EndIf
  l = Len(Text.s) + 1
  Len + l
        
  ProcedureReturn String
EndProcedure


Procedure.s add1(item, Text.s)
  Static len
  Protected i, String.s
  
  String.s = StringField(Text, item+1, #LF$)
  len = Len(String)
            
  For i = item - 1 To 0 Step - 1
    String = StringField(Text, i+1, #LF$) + String
  Next
  
  Debug  Len(String)
  
  len = Len(String)+Item-len
  If item=10
    String = InsertString(text, "_"+#LF$, len+1)
  Else
    String = InsertString(text, "Line_"+Str(item)+#LF$, len+1)
  EndIf
  Len + Len(text) + 1
        
  ProcedureReturn String
EndProcedure

String = Text
For a = 0 To 2
  String = add(a, String) 
Next
String = add(7+a, String) 
For a = 4 To 6
  String = add(a, String) 
Next

Debug  String
Debug "-------------"

; String = add1(0, Text.s)
; String = add1(1, String)
; Debug add1(6, String)

String = Text
For a = 0 To 2
  String = add1(a, String) 
Next
String = add1(7+a, String) 
For a = 4 To 6
  String = add1(a, String) 
Next

Debug  String
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --
; EnableXP