; -------------------------------------------------- ---------------
; Пример простого управления языком для программ
; -------------------------------------------------- ---------------
;
; Преимущества этого решения:
; - Строки идентифицируются строкой группы и имени, что позволяет
; организуйте их с описательными именами и упростите кодирование.
;
; - Строки сортируются и индексируются при загрузке, что дает
; быстрый доступ, даже если к ним обращаются по имени.
;
; - Язык по умолчанию определен в коде (DataSection), так что даже если
; внешние языковые файлы отсутствуют или устарели, всегда есть
; присутствует резервная строка.
;
; - Список строк легко расширить. Просто добавьте новую запись в
; DataSection и языковые файлы и используйте новую группу и имя.
;
; - Дополнительные языковые файлы находятся в формате PB Preference, что делает
; их легко поддерживать.
;
; Использование:
; - определить язык по умолчанию в DataSection, как показано ниже
; - Используйте LoadLanguage() хотя бы один раз, чтобы загрузить язык по умолчанию или внешний файл.
; - Используйте Language(Group$, Name$) для доступа к языковым строкам
;
; -------------------------------------------------- ---------------

; Какие-то разное...
;
Global NbLanguageGroups, NbLanguageStrings

Structure LanguageGroup
  Name$
  GroupStart.l
  GroupEnd.l
  IndexTable.l[256]
EndStructure

; Эта процедура загружает язык из файла или язык по умолчанию.
; Его необходимо вызвать хотя бы один раз, прежде чем использовать какие-либо языковые строки.
;
; Он делает это:
; - загрузить и отсортировать включенный язык по умолчанию
; - загрузить любой дополнительный язык из файла
;
; Таким образом, вы всегда получаете языковую строку, даже если файл не найден.
; или в файле отсутствует строковая запись. Вы все равно получите значение по умолчанию
; язык при использовании команды Language().
;
; Эту функцию можно вызывать несколько раз, чтобы изменить используемый язык.
; во время выполнения.
;
Procedure LoadLanguage(FileName$ = "")
  
  ; сначала сделайте быстрый подсчет в разделе данных:
  ;
  NbLanguageGroups = 0
  NbLanguageStrings = 0
  
  Restore Language
  Repeat
    
    Read.s Name$
    Read.s String$
    
    Name$ = UCase(Name$)
    
    If Name$ = "_GROUP_"
      NbLanguageGroups + 1
    ElseIf Name$ = "_END_"
      Break
    Else
      NbLanguageStrings + 1
    EndIf
    
  ForEver
  
  Global Dim LanguageGroups.LanguageGroup(NbLanguageGroups)  ; все здесь базируются
  Global Dim LanguageStrings.s(NbLanguageStrings)
  Global Dim LanguageNames.s(NbLanguageStrings)
  
  ; Теперь загрузите стандартный язык:
  ;  
  Group = 0
  StringIndex = 0  
  
  Restore Language
  Repeat
    
    Read.s Name$
    Read.s String$
    
    Name$ = UCase(Name$)
    
    If Name$ = "_GROUP_"
      LanguageGroups(Group)\GroupEnd   = StringIndex
      Group + 1
      
      LanguageGroups(Group)\Name$      = UCase(String$)
      LanguageGroups(Group)\GroupStart = StringIndex + 1
      For i = 0 To 255
        LanguageGroups(Group)\IndexTable[i] = 0
      Next i
      
    ElseIf Name$ = "_END_"
      Break
      
    Else
      StringIndex + 1
      LanguageNames(StringIndex)   = Name$ + Chr(1) + String$  ; держите имя и строку вместе для облегчения сортировки
      
    EndIf
    
  ForEver
  
  LanguageGroups(Group)\GroupEnd   = StringIndex ; установить конец для последней группы!
  
  ; Теперь выполните сортировку и индексацию для каждой группы.
  ;
  For Group = 1 To NbLanguageGroups
    If LanguageGroups(Group)\GroupStart <= LanguageGroups(Group)\GroupEnd  ; проверка работоспособности.. проверка на наличие пустых групп
      
      SortArray(LanguageNames(), 0, LanguageGroups(Group)\GroupStart, LanguageGroups(Group)\GroupEnd)
      
      char = 0
      For StringIndex = LanguageGroups(Group)\GroupStart To LanguageGroups(Group)\GroupEnd
        LanguageStrings(StringIndex) = StringField(LanguageNames(StringIndex), 2, Chr(1)) ; отделить значение от имени
        LanguageNames(StringIndex)   = StringField(LanguageNames(StringIndex), 1, Chr(1))
        
        If Asc(Left(LanguageNames(StringIndex), 1)) <> char
          char = Asc(Left(LanguageNames(StringIndex), 1))
          LanguageGroups(Group)\IndexTable[char] = StringIndex
        EndIf
      Next StringIndex
      
    EndIf
  Next Group
  
  ; Теперь попробуйте загрузить файл внешнего языка
  ;       
  If FileName$ <> ""
    
    If OpenPreferences(FileName$)
      For Group = 1 To NbLanguageGroups
        If LanguageGroups(Group)\GroupStart <= LanguageGroups(Group)\GroupEnd  ; проверка работоспособности.. проверка на наличие пустых групп
          PreferenceGroup(LanguageGroups(Group)\Name$)
          
          For StringIndex = LanguageGroups(Group)\GroupStart To LanguageGroups(Group)\GroupEnd
            LanguageStrings(StringIndex) = ReadPreferenceString(LanguageNames(StringIndex), LanguageStrings(StringIndex))
          Next StringIndex
        EndIf
      Next Group
      ClosePreferences()   
      
      ProcedureReturn #True
    EndIf    
    
  EndIf
  
  ProcedureReturn #True
EndProcedure


; Эта функция возвращает строку на текущем языке
; Каждая строка идентифицируется группой и именем (оба значения нечувствительны к регистру).
;
; Если строка не найдена (даже на включенном языке по умолчанию),
; возвращается "##### Строка не найдена! #####", что помогает обнаружить ошибки в
; код языка легко.
;
Procedure.s Language(Group$, Name$)
  Static Group.l ; для более быстрого доступа при использовании одной и той же группы более одного раза
  Protected String$, StringIndex, Result
  
  Group$  = UCase(Group$)
  Name$   = UCase(Name$)
  String$ = "##### String not found! #####" ; чтобы помочь найти ошибки
  
  If LanguageGroups(Group)\Name$ <> Group$  ; проверьте, является ли это той же группой, что и в прошлый раз 
    For Group = 1 To NbLanguageGroups
      If Group$ = LanguageGroups(Group)\Name$
        Break
      EndIf
    Next Group
    
    If Group > NbLanguageGroups ; проверить, была ли найдена группа
      Group = 0
    EndIf
  EndIf
  
  If Group <> 0
    StringIndex = LanguageGroups(Group)\IndexTable[ Asc(Left(Name$, 1)) ]
    If StringIndex <> 0
      
      Repeat
        Result = CompareMemoryString(@Name$, @LanguageNames(StringIndex))
        
        If Result = 0
          String$ = LanguageStrings(StringIndex)
          Break
          
        ElseIf Result = -1 ; строка не найдена!
          Break
          
        EndIf
        
        StringIndex + 1
      Until StringIndex > LanguageGroups(Group)\GroupEnd
      
    EndIf
    
  EndIf
  
  ProcedureReturn String$
EndProcedure


DataSection
  
  ; Здесь указывается язык по умолчанию. Это список групп, пар имен,
  ; с некоторыми специальными ключевыми словами для группы:
  ;
  ; "_GROUP_" укажет на новую группу в datasection, второе значение - имя группы
  ; «_END_» будет означать конец списка языков (поскольку фиксированного номера нет)
  ;
  ; Примечание. Строки идентификаторов нечувствительны к регистру, чтобы упростить жизнь :)
  
  Language:
  
  ; ===================================================
  Data$ "_GROUP_",            "MenuTitle"
  ; ===================================================
  
  Data$ "File",             "File"
  Data$ "Edit",             "Edit"
  
  ; ===================================================
  Data$ "_GROUP_",            "MenuItem"
  ; ===================================================
  
  Data$ "New",              "New"
  Data$ "Open",             "Open..."
  Data$ "Save",             "Save"
  
  ; ===================================================
  Data$ "_END_",              ""
  ; ===================================================
  
EndDataSection

; -----------------------------------------------------------------
; Пример:
; -----------------------------------------------------------------

LoadLanguage() ; загрузить язык по умолчанию
               ; LoadLanguage("german.prefs" ); раскомментируйте это, чтобы загрузить немецкий файл

; получить некоторые языковые строки
;
Debug Language("MenuTitle", "Edit")
Debug Language("MenuItem", "Save")

; -----------------------------------------------------------------

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP