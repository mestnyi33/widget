; Отключаем отладчик для чистоты теста скорости (или оставьте включенным, но с ним будет медленнее)
; #PB_Compiler_Debugger = 0 

Structure MyData
  ID.l
  Value.s
  *NextItem.MyData ; Для третьего варианта
EndStructure

#ElementCount = 500000

; =================================================================
; 1. ВСТРОЕННЫЙ СПИСОК (NewList)
; =================================================================
NewList MyList.MyData()

; Запись
StartWrite = ElapsedMilliseconds()
For i = 1 To #ElementCount
  AddElement(MyList())
  MyList()\Id = i
  MyList()\Value = "Запись №" + Str(i)
Next
TimeListWrite = ElapsedMilliseconds() - StartWrite

; Чтение
StartRead = ElapsedMilliseconds()
ForEach MyList()
  ; Просто имитируем чтение данных, чтобы процессор выполнил работу
  TargetId = MyList()\Id
  TargetStr$ = MyList()\Value
Next
TimeListRead = ElapsedMilliseconds() - StartRead

; =================================================================
; 2. МАССИВ УКАЗАТЕЛЕЙ (AllocateStructure)
; =================================================================
Dim *Array.MyData(#ElementCount)

; Запись
StartWrite = ElapsedMilliseconds()
For i = 1 To #ElementCount
  *Array(i) = AllocateStructure(MyData)
  *Array(i)\Id = i
  *Array(i)\Value = "Запись №" + Str(i)
Next
TimeArrWrite = ElapsedMilliseconds() - StartWrite

; Чтение
StartRead = ElapsedMilliseconds()
For i = 1 To #ElementCount
  TargetId = *Array(i)\Id
  TargetStr$ = *Array(i)\Value
Next
TimeArrRead = ElapsedMilliseconds() - StartRead

; Очистка памяти
For i = 1 To #ElementCount
  FreeStructure(*Array(i))
Next

; =================================================================
; 3. ЦЕПОЧКА УКАЗАТЕЛЕЙ (AllocateStructure)
; =================================================================
; Запись
StartWrite = ElapsedMilliseconds()
*FirstItem.MyData = AllocateStructure(MyData)
*FirstItem\Id = 1
*FirstItem\Value = "Запись №1"
*CurrentItem.MyData = *FirstItem

For i = 2 To #ElementCount
  *NewItem.MyData = AllocateStructure(MyData)
  *NewItem\Id = i
  *NewItem\Value = "Запись №" + Str(i)
  *CurrentItem\NextItem = *NewItem 
  *CurrentItem = *NewItem           
Next
TimeChainWrite = ElapsedMilliseconds() - StartWrite

; Чтение
StartRead = ElapsedMilliseconds()
*CurrentItem = *FirstItem
While *CurrentItem <> #Null
  TargetId = *CurrentItem\Id
  TargetStr$ = *CurrentItem\Value
  *CurrentItem = *CurrentItem\NextItem 
Wend
TimeChainRead = ElapsedMilliseconds() - StartRead

; Очистка памяти
*CurrentItem = *FirstItem
While *CurrentItem <> #Null
  *Next.MyData = *CurrentItem\NextItem
  FreeStructure(*CurrentItem)
  *CurrentItem = *Next
Wend

; =================================================================
; ВЫВОД РЕЗУЛЬТАТОВ
; =================================================================
            Debug "--- РЕЗУЛЬТАТЫ НА 500 000 ЭЛЕМЕНТОВ ---"
Debug "[NewList]          Запись: " + Str(TimeListWrite) + " мс | Чтение: " + Str(TimeListRead) + " мс"
Debug "[Массив указ.]     Запись: " + Str(TimeArrWrite)  + " мс | Чтение: " + Str(TimeArrRead)  + " мс"
Debug "[Цепочка указ.]    Запись: " + Str(TimeChainWrite) + " мс | Чтение: " + Str(TimeChainRead) + " мс"

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 96
; FirstLine = 10
; Folding = -
; EnableXP
; DPIAware