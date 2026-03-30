EnableExplicit

; ;- --- КОНСТАНТЫ ---
; #PB_Tree_Selected   = 1 << 0
; #PB_Tree_Checked    = 1 << 1
; #PB_Tree_Collapsed  = 1 << 2
; #PB_Tree_Expanded   = 1 << 3
; #PB_Tree_Inbetween  = 1 << 4
; 
; #PB_Tree_AlwaysShowSelection = 1 << 5
; #PB_Tree_NoLines            = 1 << 6
; #PB_Tree_NoButtons          = 1 << 7
; #PB_Tree_CheckBoxes         = 1 << 8
; #PB_Tree_ThreeState         = 1 << 9
#PB_Tree_MultiSelect        = 1 << 10
#PB_Tree_ClickSelect        = 1 << 11

#TREE_Padding = 5
#TREE_ButtonSize = 9
#TREE_Indent   = 20 ; Шаг вложенности
#TREE_LineOffset = #TREE_Indent - #TREE_ButtonSize/2 ; - (#TREE_ButtonSize%2) ; Отступ линии от текста

;- --- СТРУКТУРЫ ---

Structure _s_TREE_ITEM
   Text.s
   SubLevel.l
   Image.i
   State.q
   IsVisible.b
   Childrens.b
   Verticalline.b          ; Флаг: последний ли это ребенок в своей ветке
   *parent._s_TREE_ITEM
   *LastChild._s_TREE_ITEM ; Указатель на последнего добавленного ребенка
   sub.l
EndStructure

Structure _s_WIDGET
   Gadget.i
   X.l : Y.l : W.l : H.l
   Flags.q
   RowHeight.l
   HoverIndex.l
   DragIndex.l
   ScrollY.l           
   List Items._s_TREE_ITEM()
EndStructure

;- --- ВНУТРЕННЯЯ ЛОГИКА ---

Procedure UpdateTreeVisibility(*this._s_WIDGET)
   Protected HideLevel = 1000
   ForEach *this\Items()
      If *this\Items()\sublevel > HideLevel
         *this\Items()\IsVisible = 0
      Else
         *this\Items()\IsVisible = 1
         If *this\Items()\State & #PB_Tree_Collapsed
            HideLevel = *this\Items()\sublevel
         Else
            HideLevel = 1000
         EndIf
      EndIf
   Next
EndProcedure

Procedure DrawTree(*this._s_WIDGET)
   ; --- ПРОВЕРКА КОНТЕКСТА ---
   ; Если объект не инициализирован или Canvas не готов к рисованию, выходим
   If Not *this Or Not StartDrawing(CanvasOutput(*this\Gadget)) : ProcedureReturn : EndIf
   
   Protected CanvasW = OutputWidth(), CanvasH = OutputHeight()
   
   ; Очистка фона (заливаем всё белым)
   Box(0, 0, CanvasW, CanvasH, $FFFFFF)
   DrawingFont(GetGadgetFont(#PB_Default)) ; Установка стандартного шрифта
   
   ; --- РАСЧЕТ НАЧАЛЬНОЙ ПОЗИЦИИ ---
   ; LocalY определяет, где рисовать первую строку с учетом вертикальной прокрутки (ScrollY)
   Protected LocalY = 2 - (*this\ScrollY * *this\RowHeight)
   Protected VisibleCount = 0
   Protected Index
   
   ForEach *this\Items()
      ; 1. Пропускаем скрытые (свернутые) элементы
      If Not *this\Items()\IsVisible : Continue : EndIf
      
      ; 2. Считаем индекс видимой строки
      VisibleCount + 1
      
      ; --- ОПТИМИЗАЦИЯ ТУТ ---
      ; Если элемент находится ВНЕ зоны видимости экрана - 
      ; мы просто обновляем координату LocalY и идем к следующему, ничего не рисуя.
      If LocalY + *this\RowHeight <= 0 Or LocalY >= CanvasH
         LocalY + *this\RowHeight
         Continue
      EndIf
      
      Index = ListIndex(*this\Items())
      Protected BgColor = $FFFFFF 
      If *this\Items()\State & #PB_Tree_Selected : BgColor = $F0D090 : EndIf
      If Index = *this\HoverIndex : BgColor = $A0A0A0 : EndIf
      If Index = *this\DragIndex : BgColor = $F5F5F5 : EndIf
      Box(0, LocalY, CanvasW, *this\RowHeight, BgColor)
      
      ; Базовый отступ текста/иконок в зависимости от уровня вложенности (sublevel)
      Protected OffsetX = *this\Items()\sublevel * #TREE_Indent + #TREE_Padding
      Protected LineColor = $D0D0D0 ; Цвет линий иерархии
      Protected MidY = LocalY + *this\RowHeight / 2 ; Середина строки по вертикали
      
      
      ; Подсветка Hover (сделай цвет чуть светлее выделения)
      If Index = *this\HoverIndex
        ; Box(0, LocalY, CanvasW, *this\RowHeight, $F5F5F5) ; Очень светло-серый
      EndIf
      ; --- ПОДСВЕТКА ВЫДЕЛЕНИЯ ---
      If *this\Items()\State & #PB_Tree_Selected
         ; Рисуем серый прямоугольник под выделенным элементом
        ; Box(0, LocalY, CanvasW, *this\RowHeight, $EAEAEA)
      EndIf
      
      ; --- БЛОК ОТРИСОВКИ ЛИНИЙ ИЕРАРХИИ ---
      If Not (*this\Flags & #PB_Tree_NoLines)
         ; Рассчитываем X для текущего уровня (работает и для 0, и для вложенных)
         Protected LineX = OffsetX - #TREE_LineOffset
         
         ; 1. Горизонтальный "отросток" к тексту/кнопке
         ; Рисуем его для всех, чтобы кнопка [+] не висела в воздухе
         Line(LineX, MidY, 10, 1, LineColor)
         
         ; 2. Вертикальная линия ВВЕРХ
         ; Рисуем её всегда, кроме самого первого элемента в дереве, 
         ; чтобы линия не торчала над самым верхним корнем.
         If Index > 0
            Line(LineX, LocalY, 1, *this\RowHeight / 2, LineColor)
         EndIf
         
         ; 3. Вертикальная линия ВНИЗ (Связующая)
         ; Если флаг Verticalline = 1, значит ниже есть "брат" того же уровня, тянем линию дальше
         If *this\Items()\Verticalline 
            Line(LineX, MidY + 1, 1, *this\RowHeight / 2, LineColor)
         EndIf
         
         ; 4. ОТРИСОВКА СКВОЗНЫХ ЛИНИЙ (для уровней выше текущего)
         ; Этот блок работает только если мы внутри какой-то ветки
         If *this\Items()\sublevel > 0
            Protected *p._s_TREE_ITEM = *this\Items()\parent
            While *p
               If *p\Verticalline
                  Protected pX = (*p\sublevel * #TREE_Indent + #TREE_Padding) - #TREE_LineOffset
                  Line(pX, LocalY, 1, *this\RowHeight, LineColor)
               EndIf
               *p = *p\parent
            Wend
         EndIf
      EndIf
      
      ; --- ОТРИСОВКА КНОПКИ [+] / [-] ---
      If Not (*this\Flags & #PB_Tree_NoButtons)
         If *this\Items()\Childrens ; Рисуем кнопку только если у элемента есть дети
            Protected HalfSize = #TREE_ButtonSize / 2
            Protected btnX = OffsetX, btnY = LocalY + (*this\RowHeight - #TREE_ButtonSize) / 2
            ; Квадратик кнопки
            Box(btnX, btnY, #TREE_ButtonSize, #TREE_ButtonSize, $A0A0A0) : Box(btnX+1, btnY+1, #TREE_ButtonSize-2, #TREE_ButtonSize-2, $FFFFFF)
            ; Замени отрисовку линий внутри кнопки на расчетные значения:
            ; Горизонтальная линия (минус) - всегда
            Line(btnX + 2, btnY + HalfSize, #TREE_ButtonSize - 4, 1, 0)
            ; Вертикальная линия (для плюса)
            If *this\Items()\State & #PB_Tree_Collapsed
               Line(btnX + HalfSize, btnY + 2, 1, #TREE_ButtonSize - 4, 0)
            EndIf
            
         EndIf
         OffsetX + #TREE_ButtonSize + 5 ; Сдвигаем текст вправо, чтобы он не наезжал на кнопку
      EndIf
      
      ; --- ОТРИСОВКА ТЕКСТА ---
      ; ВНИМАНИЕ: цвет текста $FFFFFF (белый) на белом фоне будет не виден!
      DrawText(OffsetX, LocalY + (*this\RowHeight - TextHeight("A"))/2, *this\Items()\Text, 0, $FFFFFF)
      
      ; Переходим к следующей Y-координате для следующей строки
      LocalY + *this\RowHeight
   Next
   
   ; --- ОТРИСОВКА СКРОЛЛБАРА ---
   Protected MaxRows = CanvasH / *this\RowHeight
   If VisibleCount > MaxRows
      ; Рассчитываем высоту и позицию ползунка
      Protected sH = (MaxRows * CanvasH) / VisibleCount
      Protected sY = (*this\ScrollY * CanvasH) / VisibleCount
      RoundBox(CanvasW - 8, sY, 6, sH, 3, 3, $C0C0C0)
   EndIf
   
   StopDrawing()
EndProcedure

;- --- ПУБЛИЧНЫЕ ФУНКЦИИ ---

Procedure.i Tree(X.l, Y.l, Width.l, Height.l, Flag.q = 0)
   Protected *this._s_WIDGET = AllocateStructure(_s_WIDGET)
   If *this
      *this\X=X : *this\Y=Y : *this\W=Width : *this\H=Height : *this\Flags=Flag 
      *this\RowHeight=24 
      *this\HoverIndex = -1
      *this\Gadget = CanvasGadget(#PB_Any, X, Y, Width, Height, #PB_Canvas_Keyboard | #PB_Canvas_Container)
      SetGadgetData(*this\Gadget, *this)
      ProcedureReturn *this
   EndIf
EndProcedure

Procedure AddItem(*this._s_WIDGET, position.l, Text.s, img.i = -1, sublevel.i = 0)
   If Not *this : ProcedureReturn 0 : EndIf
   
   Protected *rowLast._s_TREE_ITEM = 0
   Protected *rowParent._s_TREE_ITEM = 0
   
   ;{ Генерируем идентификатор и вставляем в позицию
   If position < 0 Or position >= ListSize(*this\Items())
      If ListSize(*this\Items()) > 0 
         LastElement(*this\Items())
         *rowLast = @*this\Items() 
      EndIf
      AddElement(*this\Items())
      position = ListIndex(*this\Items())
   Else
      *rowLast = SelectElement(*this\Items(), position)
      If sublevel > *this\Items()\sublevel
         PushListPosition( *this\Items())
         If PreviousElement( *this\Items())
            *rowLast = *this\Items()
         EndIf
         PopListPosition( *this\Items())
      Else
         sublevel = *this\Items()\sublevel
         *rowLast\Verticalline = 1
      EndIf
      InsertElement(*this\Items())
   EndIf
   ;}
   Protected *row._s_TREE_ITEM = @*this\Items()
   
   
   ;{ ТВОЙ БЛОК ЛОГИКИ ПОИСКА РОДИТЕЛЯ
   If sublevel < 0 : sublevel = 0 : EndIf
   If sublevel > position : sublevel = position : EndIf ; (опционально)
   If *rowLast
      If sublevel > *rowLast\sublevel
         sublevel = *rowLast\sublevel + 1
         *rowParent = *rowLast
      Else
         If *rowLast\Parent
            If sublevel > *rowLast\Parent\sublevel
               *rowParent = *rowLast\Parent
            Else
               If sublevel < *rowLast\sublevel
                  If *rowLast\Parent\Parent
                     *rowParent = *rowLast\Parent\Parent
                     While *rowParent
                        If sublevel = *rowParent\sublevel 
                           *rowParent = *rowParent\Parent 
                           Break
                        ElseIf sublevel > *rowParent\sublevel
                           Break
                        Else
                           *rowParent = *rowParent\Parent
                        EndIf
                     Wend
                  EndIf
               EndIf
            EndIf
         EndIf
      EndIf
   EndIf
   ;}
   
   ;{ ЗАПОЛНЕНИЕ
   If sublevel
      *row\sublevel = sublevel
   EndIf
   
   ;
   *row\Text = Text
   *row\Image = img
   *row\State = #PB_Tree_Expanded
   *row\IsVisible = 1
   
   ;
   If *rowParent 
      *row\Parent = *rowParent
      *rowParent\Childrens + 1 ; Увеличиваем счетчик у родителя
      
      ; 1. Проверяем, есть ли кто-то СРАЗУ ПОСЛЕ нас на том же уровне (вставка в середину)
      PushListPosition(*this\Items())
      If NextElement(*this\Items()) 
         If *this\Items()\sublevel = *row\sublevel
            *row\Verticalline = 1 ; Мы не последние, тянем линию вниз к следующему брату
         EndIf
      EndIf
      PopListPosition(*this\Items())
      
      ; Если у родителя уже был ребенок до этого
      If *rowParent\LastChild
         ; Старый "последний" ребенок больше не последний
         If *rowParent\LastChild\sublevel < *rowLast\SubLevel
            *rowParent\LastChild\Verticalline = 1
         EndIf
      EndIf
      ; Запоминаем новый элемент как последний добавленный для этого родителя
      *rowParent\LastChild = *row
   EndIf
   ;}
   
   ProcedureReturn *row
EndProcedure

Procedure SetItemState(*this._s_WIDGET, Item.l, State.q)
   If *this And SelectElement(*this\Items(), Item)
      *this\Items()\State = State : UpdateTreeVisibility(*this) : DrawTree(*this)
   EndIf
EndProcedure

Procedure.q GetItemState(*this._s_WIDGET, Item.l)
   If *this And SelectElement(*this\Items(), Item) : ProcedureReturn *this\Items()\State : EndIf
EndProcedure

Procedure RemoveItem(*this._s_WIDGET, Item.l)
   If *this And SelectElement(*this\Items(), Item)
      Protected *Deleting._s_TREE_ITEM = @*this\Items()
      Protected *Parent._s_TREE_ITEM = *Deleting\parent ; Используем готовую связь
      Protected Lvl = *Deleting\sublevel
      
      ;       ; 1. Удаляем сам элемент и всех его "потомков" 
      ;       ; (все следующие элементы с уровнем строго больше текущего)
      ;       DeleteElement(*this\Items()) 
      ;       While NextElement(*this\Items()) And *this\Items()\sublevel > Lvl
      ;          DeleteElement(*this\Items())
      ;       Wend
      ; 1. Удаляем сам элемент и всех детей
      ; Флаг 1 в DeleteElement перемещает указатель на следующий элемент
      DeleteElement(*this\Items(), 1) 
      While ListIndex(*this\Items()) <> -1 And *this\Items()\sublevel > Lvl
         DeleteElement(*this\Items(), 1)
      Wend
      
      ; 2. Обновляем статус родителя
      If *Parent
         Protected StillChildrens = #False
         ; Переходим к родителю
         ChangeCurrentElement(*this\Items(), *Parent)
         
         ; Проверяем, остался ли хоть кто-то сразу за родителем с уровнем больше
         PushListPosition(*this\Items())
         If NextElement(*this\Items()) And *this\Items()\sublevel > *Parent\sublevel
            StillChildrens = #True
         EndIf
         PopListPosition(*this\Items())
         
         *Parent\Childrens = StillChildrens
      EndIf
      
      UpdateTreeVisibility(*this)
      DrawTree(*this)
      ProcedureReturn #True
   EndIf
   ProcedureReturn #False
EndProcedure

Procedure ClearItems(*this._s_WIDGET)
   If *this : ClearList(*this\Items()) : DrawTree(*this) : EndIf
EndProcedure

Procedure.i GetParentItem(*this._s_WIDGET, Item.l)
   If *this And SelectElement(*this\Items(), Item)
      Protected Lvl = *this\Items()\sublevel
      While PreviousElement(*this\Items())
         If *this\Items()\sublevel < Lvl : ProcedureReturn ListIndex(*this\Items()) : EndIf
      Wend
   EndIf
   ProcedureReturn -1
EndProcedure

Procedure TreeEvents(*this._s_WIDGET, EventType)
   If Not *this : ProcedureReturn -1 : EndIf
   Protected MX = GetGadgetAttribute(*this\Gadget,#PB_Canvas_MouseX)
   Protected MY = GetGadgetAttribute(*this\Gadget,#PB_Canvas_MouseY)
   Protected Mod = GetGadgetAttribute(*this\Gadget,#PB_Canvas_Modifiers)
   Protected Wheel = GetGadgetAttribute(*this\Gadget,#PB_Canvas_WheelDelta)
   
   
   ; --- ОБРАБОТЧИК КОЛЕСИКА ---
   ; Внутри TreeEvents исправляем ограничение прокрутки вниз
   If EventType = #PB_EventType_MouseWheel
      Protected VisibleCount = 0
      ForEach *this\Items() : If *this\Items()\IsVisible : VisibleCount + 1 : EndIf : Next
      
      Protected MaxVisibleRows = *this\H / *this\RowHeight
      *this\ScrollY - Wheel
      
      ; Ограничения: не выше начала и не ниже последнего элемента
      If *this\ScrollY < 0 : *this\ScrollY = 0 : EndIf
      If *this\ScrollY > VisibleCount - MaxVisibleRows : *this\ScrollY = VisibleCount - MaxVisibleRows : EndIf
      If *this\ScrollY < 0 : *this\ScrollY = 0 : EndIf ; Если элементов меньше чем влезло
      
      DrawTree(*this)
      ProcedureReturn -1
   EndIf
   
   If EventType = #PB_EventType_MouseMove
      Protected OldHover = *this\HoverIndex
      *this\HoverIndex = (MY - 2) / *this\RowHeight + *this\ScrollY
      
      ; Ограничиваем, чтобы не вылетало за пределы списка
      If *this\HoverIndex < 0 Or *this\HoverIndex >= ListSize(*this\Items())
         *this\HoverIndex = -1
      EndIf
      
      ; Перерисовываем только если навели на новую строку
      If OldHover <> *this\HoverIndex
         DrawTree(*this)
      EndIf
   EndIf
   
     If EventType = #PB_EventType_LeftButtonUp
    *this\DragIndex = -1
 EndIf      
 
   If EventType = #PB_EventType_LeftButtonDown
      Protected CurY = 2 - (*this\ScrollY * *this\RowHeight)
      ForEach *this\Items()
         If Not *this\Items()\IsVisible : Continue : EndIf
         If MY >= CurY And MY < CurY + *this\RowHeight
            Protected ClickIdx = ListIndex(*this\Items())
            Protected SX = *this\Items()\sublevel * 22 + 5
            If MX < SX + 20 And Not (*this\Flags & #PB_Tree_NoButtons) ; Зона +/-
               *this\Items()\State ! #PB_Tree_Collapsed : UpdateTreeVisibility(*this)
            ElseIf (*this\Flags & #PB_Tree_CheckBoxes) And MX < SX + 42 ; Зона Checkbox
               *this\Items()\State ! #PB_Tree_Checked
            Else ; Выделение
               If Not (Mod & #PB_Canvas_Control)
                  PushListPosition(*this\Items()) : ForEach *this\Items() : *this\Items()\State & ~#PB_Tree_Selected : Next : PopListPosition(*this\Items())
               EndIf
               *this\Items()\State ! #PB_Tree_Selected 
               *this\DragIndex = ClickIdx
            EndIf
            DrawTree(*this) : ProcedureReturn ClickIdx
         EndIf
         CurY + *this\RowHeight
      Next
   EndIf
   ProcedureReturn -1
EndProcedure

;- --- ТЕСТ ---
OpenWindow(0,0,0,300,400,"Final Tree",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
Global *T._s_WIDGET = Tree(10,10,280,380,#PB_Tree_CheckBoxes|#PB_Tree_MultiSelect)
; ; 1. Создаем глубокую вложенность (лесенку)
; AddItem(*T, 0, "Корень", -1, 0)
; AddItem(*T, 1, "Уровень 1", -1, 1)
; AddItem(*T, 2, "Уровень 2", -1, 2)
; AddItem(*T, 3, "Уровень 3", -1, 3)
; AddItem(*T, 4, "Уровень 4", -1, 4)
; 
; ; 2. Вставляем НОВЫЙ КОРЕНЬ (ур. 0) в позицию 5 (сразу после ур. 4)
; AddItem(*T, 5, "НОВЫЙ КОРЕНЬ", -1, 0)
; ; 
; AddItem(*T, 0, "Tree_0", -1 )
; AddItem(*T, 1, "Tree_1_1", 0, 1) 
; AddItem(*T, 4, "Tree_1_1_1", -1, 2) 
; AddItem(*T, 5, "Tree_1_1_2", -1, 2) 
; AddItem(*T, 6, "Tree_1_1_2_1", -1, 3) 
; AddItem(*T, 8, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", -1, 4) 
; AddItem(*T, 7, "Tree_1_1_2_2 980980_", -1, 3) 
; AddItem(*T, 2, "Tree_1_2", -1, 1) 
; AddItem(*T, 3, "Tree_1_3", -1, 4) 
; AddItem(*T, 9, "Tree_2",-1 )
; AddItem(*T, 10, "Tree_3", -1 )
; AddItem(*T, 11, "Tree_4", -1 )
; AddItem(*T, 12, "Tree_5", -1 )
; AddItem(*T, 13, "Tree_6", -1 )
; AddItem(*T, 14, "Tree_7", -1 )
; 
; ; AddItem (*T, -1, "Node "+Str(0), 0, 0)                                         
; AddItem (*T, -1, "Sub-Item 1", -1, 1)                                           
; AddItem (*T, -1, "Sub-Item 3", -1, 3)
; AddItem (*T, -1, "Sub-Item 2", -1, 2)
; AddItem (*T, -1, "Sub-Item 4", -1, 4)
; 
; 
;     AddItem (*T, 0, "Node "+Str(0), 0, 0)                                         
;     AddItem (*T, 1, "Sub-Item 1", -1, 1)                                           
;     AddItem (*T, 3, "Sub-Item 3", -1, 3)
;     AddItem (*T, 2, "Sub-Item 2", -1, 2)
;     AddItem (*T, 4, "Sub-Item 4", -1, 4)

;     AddItem (*T, 0, "Node "+Str(0), 0, 0)                                         
;     AddItem (*T, 1, "Sub-Item 1", -1, 1)                                           
;     AddItem (*T, 2, "Sub-Item 2", -1, 2)
;     AddItem (*T, 3, "Sub-Item 3", -1, 3)
;     AddItem (*T, 4, "Sub-Item 4", -1, 4)
;     
;     AddItem(*T, 2, "ВСТАВКА", -1, 1)
; 
; AddItem(*T, 0, "Папка", -1, 0)
; AddItem(*T, 1, "Файл1", -1, 2) ; Ошибка! Пропустили уровень 1. 
; AddItem(*T, 2, "Файл2", -1, 2) ; Ошибка! Пропустили уровень 1. 

; AddItem(*T, 1, "Подпапка", -1, 1)
; AddItem(*T, 2, "-Файл1", -1, 2) ; Ошибка! Пропустили уровень 1. 
; AddItem(*T, 3, "-Файл2", -1, 2) ; Ошибка! Пропустили уровень 1. 

; AddItem(*T, 0, "Папка", -1, 0)
; AddItem(*T, 1, "Файл1", -1, 1) 
; AddItem(*T, 2, "Файл2", -1, 1) 
; 
; AddItem(*T, 1, "Подпапка", -1, 1)
; AddItem(*T, 2, "-Файл1", -1, 2)
; AddItem(*T, 3, "-Файл2", -1, 2) 

; ForEach *T\Items()
;        If *T\Items()\parent
;           Debug ""+*T\Items()\Text+" - "+*T\Items()\SubLevel+" -> "+*T\Items()\parent\Text+" - "+*T\Items()\parent\SubLevel
;          ; Debug ""+*T\Items()\Text+" - "+*T\Items()\SubLevel+" - "+*T\Items()\Verticalline+" -> "+*T\Items()\parent\Text+" - "+*T\Items()\parent\SubLevel+" - "+*T\Items()\parent\Verticalline
;        EndIf
;     Next
;     
;     ; 1. Создаем структуру
; AddItem(*T, 0, "Корень", -1, 0)
; AddItem(*T, 1, "  Папка 1", -1, 1)
; AddItem(*T, 2, "    Файл 1.1", -1, 2)
; AddItem(*T, 3, "    Файл 1.2", -1, 2)
; 
; ; 2. ВСТАВЛЯЕМ В СЕРЕДИНУ (между файлами 1.1 и 1.2)
; ; Мы хотим вставить новый Раздел (уровень 0) прямо в центр чужой ветки
; AddItem(*T, 3, "НОВЫЙ РАЗДЕЛ", -1, 0) 
; 1. Создаем корень и один вложенный элемент
; AddItem(*T, 0, "Корень 1", -1, 0)
; AddItem(*T, 1, "  Папка 1.1", -1, 1)
; 
; ; 2. ВСТАВЛЯЕМ НОВЫЙ КОРЕНЬ В СЕРЕДИНУ (перед Папкой 1.1)
; ; Индекс 1, уровень 0.
; AddItem(*T, 1, "НОВЫЙ КОРЕНЬ 2", -1, 0) 
; ; --- ПРОВЕРКА ДЕБАГОМ ---
; ForEach *T\Items()
;   Define  PText.s = "НЕТ"
;   If *T\Items()\parent : PText = *T\Items()\parent\Text : EndIf
;   Debug "Элемент: " + *T\Items()\Text + " | Уровень: " + Str(*T\Items()\sublevel) + " | Родитель: " + PText
; Next
; 
; ; 1. Создаем структуру
; AddItem(*T, 0, "РАЗДЕЛ 1", -1, 0)
; AddItem(*T, 1, "  Папка 1.1", -1, 1)
; AddItem(*T, 2, "РАЗДЕЛ 2", -1, 0) ; Специально ставим корень сразу после папки
; 
; ; 2. ПЫТАЕМСЯ ВСТАВИТЬ ФАЙЛ В КОНЕЦ ПАПКИ 1.1 (в позицию 2)
; ; Мы хотим, чтобы он был ВНУТРИ папки (уровень 2)
; AddItem(*T, 2, "    Файл 1.1.1", -1, 2) 

AddItem(*T, 0, "Tree_0", -1 )
AddItem(*T, 1, "Tree_1_1", 0, 1) 
AddItem(*T, 4, "Tree_1_1_2", -1, 2) 
AddItem(*T, 5, "Tree_1_1_3", -1, 2) 
AddItem(*T, 6, "Tree_1_1_3_1", -1, 3) 
AddItem(*T, 8, "Tree_1_1_3_1_1", -1, 4) 
AddItem(*T, 7, "Tree_1_1_3_2", -1, 3) 
AddItem(*T, 2, "Tree_1_1_1", -1, 1) 
AddItem(*T, 3, "Tree_1_1_1_1", -1, 4) 
AddItem(*T, 9, "Tree_1",-1 )
;
; --- ПРОВЕРКА ДЕБАГОМ ---
ForEach *T\Items()
   Debug "Элемент: " + *T\Items()\Text + " | Уровень: " + Str(*T\Items()\sublevel) +" Verticalline: " + *T\Items()\Verticalline
Next

UpdateTreeVisibility(*T) : DrawTree(*T)

Repeat
   Define Ev = WaitWindowEvent()
   If Ev = #PB_Event_Gadget And EventGadget() = *T\Gadget
      TreeEvents(*T, EventType())
   EndIf
Until Ev = #PB_Event_CloseWindow
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 446
; FirstLine = 22
; Folding = --------------
; EnableXP
; DPIAware