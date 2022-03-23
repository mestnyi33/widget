; https://www.purebasic.fr/english/viewtopic.php?f=13&t=77230
Global Dim CountArray.a(2048) ; Array of Unsigned Byte 0..2048

For i = 0 To 10
  CountArray(i) = i
Next

Structure ArrayOfUByte
  a.a[0] ; Size [0] -> Array if unsigned byte with unknown size
EndStructure

Structure ThreadParameterStructure
  Thread.i
  Semaphore.i
  FinishReason$
  Exit.i
  ; Way one
  Array CountArray.a(0)
  ; Way Two
  *pCountArray.ArrayOfUByte
EndStructure

Define ThreadParameter.ThreadParameterStructure

; Way one by copy
CopyArray(CountArray(), ThreadParameter\CountArray())
Debug ArraySize(ThreadParameter\CountArray()) + 1

; Way two bei pointer
ThreadParameter\pCountArray = @CountArray()
For i = 0 To 11
  Debug ThreadParameter\pCountArray\a[i]
Next


; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP