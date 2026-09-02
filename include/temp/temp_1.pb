Structure MyData
  ID.l
  Value.s
  *NextItem.MyData ; Объявляем как указатель со звездочкой
EndStructure

#ElementCount = 500000

; --- ЗАПОЛНЕНИЕ ---
StartTime = ElapsedMilliseconds()

*FirstItem.MyData = AllocateStructure(MyData)
*FirstItem\Id = 1
*FirstItem\Value = "Запись №1"

*CurrentItem.MyData = *FirstItem

For i = 2 To #ElementCount
  *NewItem.MyData = AllocateStructure(MyData)
  *NewItem\Id = i
  *NewItem\Value = "Запись №" + Str(i)
  
  ; ПРАВИЛЬНО: обращение к полю-указателю идет БЕЗ звездочки
  *CurrentItem\NextItem = *NewItem 
  *CurrentItem = *NewItem           
Next
FillTime = ElapsedMilliseconds() - StartTime
StartTime = ElapsedMilliseconds()

; --- ЧТЕНИЕ ---
*CurrentItem = *FirstItem
While *CurrentItem 
  If *CurrentItem\Id = 1 Or *CurrentItem\Id = #ElementCount
    Debug "[Указатели-Цепочка] ID = " + Str(*CurrentItem\Id) + " | " + *CurrentItem\Value
  EndIf
  *CurrentItem = *CurrentItem\NextItem 
Wend

Debug "Время цепочки указателей: " + Str(FillTime) + " мс" +" "+ Str(ElapsedMilliseconds() - StartTime)

; --- ОЧИСТКА ---
StartTime = ElapsedMilliseconds()
*CurrentItem = *FirstItem
While *CurrentItem 
  *Next.MyData = *CurrentItem\NextItem ; ПРАВИЛЬНО
  FreeStructure(*CurrentItem)
  *CurrentItem = *Next
Wend
Debug  Str(ElapsedMilliseconds() - StartTime)
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 31
; FirstLine = 24
; Folding = -
; EnableXP
; DPIAware