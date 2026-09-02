Structure MyData
  ID.l
  Value.s
EndStructure

#ElementCount = 500000
; Создаем массив, который будет хранить только числовые адреса (указатели)
Dim *Array.MyData(#ElementCount)

; --- ЗАПОЛНЕНИЕ ---
StartTime = ElapsedMilliseconds()
For i = 1 To #ElementCount
  ; Выделяем память под структуру и инициализируем строку .s
  *Array(i) = AllocateStructure(MyData)
  
  ; Заполняем данные, обращаясь через указатель в массиве
  *Array(i)\Id = i
  *Array(i)\Value = "Запись №" + Str(i)
Next
FillTime = ElapsedMilliseconds() - StartTime

; --- ЧТЕНИЕ ---
StartTime = ElapsedMilliseconds()
For i = 1 To #ElementCount
  If *Array(i)\Id = 1 Or *Array(i)\Id = #ElementCount
    Debug "[Указатели-Массив] ID = " + Str(*Array(i)\Id) + " | " + *Array(i)\Value
  EndIf
Next

Debug "Время массива указателей: " + Str(FillTime) + " мс" +" "+ Str(ElapsedMilliseconds() - StartTime)


StartTime = ElapsedMilliseconds()
; --- ОЧИСТКА (Обязательно вручную) ---
For i = 1 To #ElementCount
  FreeStructure(*Array(i))
Next
Debug Str(ElapsedMilliseconds() - StartTime)

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 30
; Folding = -
; EnableXP
; DPIAware