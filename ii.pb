Macro HideState( _this_, _parent_ )
      ; 1. Расчет финального скрытия с учетом родителя и вкладок (Tabbar) в одно выражение
      If Bool( ( _this_\mask & #__mask_hide ) Or 
               ( _parent_ And (( _parent_\mask & #__mask_hidden ) Or ( _this_\tabindex <> #PB_Ignore And _parent_\tabbar And _parent_\tabbar\type = #__type_TabBar And _parent_\tabbar\TabState( ) <> _this_\tabindex ) ) ) )
         _this_\mask | #__mask_hidden
      Else
         _this_\mask & ~#__mask_hidden
      EndIf
      
      ; 2. Обновление дочернего элемента Tabbar
      If _this_\tabbar
         If _this_\mask & #__mask_hidden
            _this_\tabbar\mask | #__mask_hidden
         Else
            If _this_\tabbar\mask & #__mask_hide
               _this_\tabbar\mask | #__mask_hidden
            Else
               _this_\tabbar\mask & ~#__mask_hidden
            EndIf
         EndIf
      EndIf
      
      ; 3. Обновление дочернего элемента Stringbar
      If _this_\Stringbar
         If _this_\mask & #__mask_hidden
            _this_\Stringbar\mask | #__mask_hidden
         Else
            If _this_\Stringbar\mask & #__mask_hide
               _this_\Stringbar\mask | #__mask_hidden
            Else
               _this_\Stringbar\mask & ~#__mask_hidden
            EndIf
         EndIf
      EndIf
      
      ; 4. Обновление дочерних скроллбаров (v и h)
      If _this_\scroll
         If _this_\scroll\v
            If Bool( ( _this_\mask & #__mask_hidden ) Or _this_\scroll\v\bar\max <= _this_\scroll\v\bar\page\len )
               _this_\scroll\v\mask | #__mask_hidden
            Else
               If _this_\scroll\v\mask & #__mask_hide
                  _this_\scroll\v\mask | #__mask_hidden
               Else
                  _this_\scroll\v\mask & ~#__mask_hidden
               EndIf
            EndIf
         EndIf
         
         If _this_\scroll\h
            If Bool( ( _this_\mask & #__mask_hidden ) Or _this_\scroll\h\bar\max <= _this_\scroll\h\bar\page\len )
               _this_\scroll\h\mask | #__mask_hidden
            Else
               If _this_\scroll\h\mask & #__mask_hide
                  _this_\scroll\h\mask | #__mask_hidden
               Else
                  _this_\scroll\h\mask & ~#__mask_hidden
               EndIf
            EndIf
         EndIf
      EndIf
      
      ; --- 5. ЧИСТЫЙ ВЫЗОВ СИНХРОНИЗАЦИИ УКАЗАТЕЛЕЙ ---
      Views( _this_, _parent_ )
   EndMacro
   
   Procedure.b HideItem( *this._s_widget, item.l, state.b )
      If *this\type = #__type_MenuBar Or
         *this\type = #__type_PopupBar Or
         *this\type = #__type_ToolBar
         ;
         If *this\__tabs( )
            PushListPosition(*this\__tabs( ))
            ForEach *this\__tabs( )
               If *this\__tabs( )\tindex = item
                  ; Установка базового флага скрытия для вкладки панели
                  If state
                     *this\__tabs( )\mask | #__mask_hide
                  Else
                     *this\__tabs( )\mask & ~#__mask_hide
                  EndIf
                  *this\TabChange( ) = #True
                  Break
               EndIf
            Next
            PopListPosition(*this\__tabs( ))
         EndIf
         ProcedureReturn 0
      EndIf
      
      If *this\tabbar
         ForEach *this\tabbar\__tabs( )
            If *this\tabbar\__tabs( )\tindex = item
               ; Установка базового флага скрытия для вкладки таббара
               If state
                  *this\tabbar\__tabs( )\mask | #__mask_hide
               Else
                  *this\tabbar\__tabs( )\mask & ~#__mask_hide
               EndIf
               *this\tabbar\TabChange( ) = #True
               Break
            EndIf
         Next
      EndIf
      
      If *this\row
         Protected._s_ROW *row
         Protected._s_ROW *select_row = SelectElement( *this\__rows( ), item )
         
         ; Установка базового флага скрытия для выбранной строки
         If state
            *select_row\mask | #__mask_hide
         Else
            *select_row\mask & ~#__mask_hide
         EndIf
         
         ; Если у строки есть дочерние элементы — каскадно обновляем их
         If *select_row\childrens
            PushListPosition( *this\__rows( ))
            While NextElement( *this\__rows( ))
               *row = @*this\__rows( )
               ; Исправлен синтаксис оператора (<= вместо =<)
               If *row\sublevel <= *select_row\sublevel
                  Break
               EndIf
               If *row\parent
                  ; Проверяем, скрыт ли родитель или раскрыта ли кнопка дерева (чекбокс)
                  ; Для дочерних строк вычисляем финальное состояние #__mask_hidden
                  If Bool( *row\parent\buttonbox\checked Or ( *row\parent\mask & #__mask_hidden ) )
                     *row\mask | #__mask_hidden
                  Else
                     *row\mask & ~#__mask_hidden
                  EndIf
               EndIf
            Wend
            PopListPosition( *this\__rows( ))
         EndIf
         
         ; *this\WidgetChange( ) = 1
         *this\TextChange( ) = - 6
      EndIf
   EndProcedure
   
   Procedure.b Hide( *this._s_PARENT, state.b = #PB_Default, flags.q = 0 )
      Protected._s_WIDGET *e
      ; 1. Если состояние не передано — возвращаем 1 или 0 (был ли скрыт изначально)
      If state = #PB_Default 
         If *this\mask & #__mask_hide
            ProcedureReturn 1
         Else
            ProcedureReturn 0
         EndIf
      EndIf
      
      ; 2. Получаем текущее базовое состояние для проверки изменений
      If state <> Bool(*this\mask & #__mask_hide)
         ; Изменяем базовый флаг скрытия в маске
         If state : *this\mask | #__mask_hide : Else : *this\mask & ~#__mask_hide : EndIf
         
         ; Пересчитываем фактическую видимость текущего элемента
         HideState( *this, *this\parent )
         
         ; 3. Если есть дочерние элементы — каскадно обновляем их видимость
         If *this\haschildren
            If StartEnum( *this ) : *e = Widget()
               HideState( *e, *e\parent )
               StopEnum( )
            EndIf
         EndIf
         
         PostRepaint( *this\root )
         ProcedureReturn 1
      EndIf
   EndProcedure
   
   
   Procedure   IsChild( *this._s_WIDGET, *parent._s_WIDGET )
      Protected result
      ;
      If *this And 
         *this <> *parent And 
         *parent\haschildren
         ;
         Repeat
            *this = *this\parent
            If *this
               If *parent = *this
                  result = *this
                  Break
               EndIf
            Else
               Break
            EndIf
         Until is_root_( *this )
      EndIf
      ;
      ProcedureReturn result
   EndProcedure
   
   ;-
   Procedure.i GetLast( *this._s_PARENT, tabindex.l = #PB_Default )
      Protected._s_PARENT *last = #Null
      Protected._s_PARENT *v = #Null
      
      If tabindex = #PB_Default
         ; =========================================================================
         ; РЕЖИМ ГЛУБОКОГО ПОИСКА (Для вычисления границ матрешки в Z-Order)
         ; =========================================================================
         *last = *this
         
         ; Спускаемся по иерархии самых последних детей до самого упора
         While *last\LastWidget( ) And *last\LastWidget( ) <> *last
            *last = *last\LastWidget( )
         Wend
         
         ProcedureReturn *last
         
      Else
         ; =========================================================================
         ; РЕЖИМ НАХОЖДЕНИЯ ХВОСТА КОНКРЕТНОЙ ВКЛАДКИ (Поиск среди братьев)
         ; =========================================================================
         ; Начинаем поиск с самого последнего ребенка контейнера
         *v = *this\LastWidget( )
         
         While *v And *v <> *this
            ; Идем НАЗАД строго по цепочке локальных братьев [Индекс 2]
            If *v\tabindex = tabindex 
               ; Как только нашли последнего ребенка на этой вкладке, 
               ; возвращаем ЕГО крайнюю глубокую z-order точку!
               ProcedureReturn GetLast( *v, #PB_Default )
            EndIf
            
            *v = *v\prev[2] ; Используем макрос prev[2], а не prev[0]!
         Wend
         
         ; Если на этой вкладке вообще нет детей, то новой точкой вставки Z-Order 
         ; должен стать элемент, стоящий ПЕРЕД этой вкладкой (то есть хвост предыдущей)
         If tabindex > 0
            ; Рекурсивно ищем хвост предыдущей вкладки панели
            ProcedureReturn GetLast( *this, tabindex - 1 )
         EndIf
         
         ; Если это самая первая пустая вкладка — возвращаем сам родительский контейнер
         ProcedureReturn *this
      EndIf
   EndProcedure
   
   Procedure.i GetPosition( *this._s_PARENT, position.l, tabindex.l = #PB_Default )
      Protected._s_WIDGET *element
      
      If tabindex = #PB_Default
         Select position
            Case #PB_List_First    : ProcedureReturn *this\FirstWidget( )
            Case #PB_List_Before   : ProcedureReturn *this\prev[2]
            Case #PB_List_After    : ProcedureReturn *this\next[2]
            Case #PB_List_Last     : ProcedureReturn *this\LastWidget( )
         EndSelect
      Else
         ; Ищем ПЕРВЫЙ элемент на указанной вкладке
         If position = #PB_List_First
            *element = *this\FirstWidget( ) 
            If *this\tabbar And *this\haschildren And *element And *element\tabindex < tabindex
               While *element
                  If *element\tabindex >= tabindex : ProcedureReturn *element : EndIf
                  *element = *element\next[2]
               Wend
               ProcedureReturn #Null
            EndIf
            ProcedureReturn *element
         EndIf
         
         ; Ищем ПОСЛЕДНИЙ элемент на указанной вкладке
         If position = #PB_List_Last
            *element = *this\LastWidget( ) 
            If *this\tabbar And *this\haschildren And *element And *element\tabindex > tabindex
               While *element
                  If *element\tabindex <= tabindex : ProcedureReturn *element : EndIf
                  *element = *element\prev[2]
               Wend
               ProcedureReturn #Null
            EndIf
            ProcedureReturn *element
         EndIf
      EndIf
      
      ProcedureReturn #Null
   EndProcedure
   
   Procedure   SetPosition( *this._s_WIDGET, position.l, *widget._s_WIDGET = #Null ) ; Ok
      Protected *last._s_WIDGET
      ;
      If *widget = #Null
         Select Position
            Case #PB_List_Before : *widget = *this\prev[2]
            Case #PB_List_After  : *widget = *this\next[2]
            Case #PB_List_First 
               If *this\parent
                  *widget = GetPosition( *this\parent, Position, *this\tabindex )
               EndIf
            Case #PB_List_Last 
               If *this\parent
                  *widget = GetPosition( *this\parent, Position, *this\tabindex )
               EndIf
         EndSelect
      EndIf
      ;
      If *widget
         If is_level_( *this, *widget )
            If Position = #PB_List_First Or
               Position = #PB_List_Before
               
               PushListPosition( widgets( ))
               ChangeCurrentElement( widgets( ), *this\address )
               MoveElement( widgets( ), #PB_List_Before, *widget\address )
               widgets( )\layer = ListIndex( widgets( ) )
               
               If *this\haschildren
                  While PreviousElement( widgets( ))
                     If IsChild( widgets( ), *this )
                        MoveElement( widgets( ), #PB_List_After, *widget\address )
                        widgets( )\layer = ListIndex( widgets( ) )
                     EndIf
                  Wend
                  
                  While NextElement( widgets( ))
                     If IsChild( widgets( ), *this )
                        MoveElement( widgets( ), #PB_List_Before, *widget\address )
                        widgets( )\layer = ListIndex( widgets( ) )
                     EndIf
                  Wend
               EndIf
               PopListPosition( widgets( ))
            EndIf
            
            If Position = #PB_List_Last Or
               Position = #PB_List_After
               
               *last = GetLast( *widget, *widget\tabindex )
               If *last
                  PushListPosition( widgets( ))
                  ChangeCurrentElement( widgets( ), *this\address )
                  MoveElement( widgets( ), #PB_List_After, *last\address )
                  widgets( )\layer = ListIndex( widgets( ) )
                  
                  If *this\haschildren
                     While NextElement( widgets( ))
                        If IsChild( widgets( ), *this )
                           MoveElement( widgets( ), #PB_List_Before, *last\address )
                           widgets( )\layer = ListIndex( widgets( ) )
                        EndIf
                     Wend
                     
                     While PreviousElement( widgets( ))
                        If IsChild( widgets( ), *this )
                           MoveElement( widgets( ), #PB_List_After, *this\address )
                           widgets( )\layer = ListIndex( widgets( ) )
                        EndIf
                     Wend
                  EndIf
                  PopListPosition( widgets( ))
               EndIf
            EndIf
            
            ;
            If *this\prev[2]
               *this\prev[2]\next[2] = *this\next[2]
            EndIf
            If *this\next[2]
               *this\next[2]\prev[2] = *this\prev[2]
            EndIf
            If *this\parent\FirstWidget( ) = *this
               *this\parent\FirstWidget( ) = *this\next[2]
            EndIf
            If *this\parent\LastWidget( ) = *this
               *this\parent\LastWidget( ) = *this\prev[2]
            EndIf
            
            ;
            If Position = #PB_List_First Or
               Position = #PB_List_Before
               
               *this\next[2]    = *widget
               *this\prev[2]   = *widget\prev[2]
               *widget\prev[2] = *this
               
               If *this\prev[2]
                  *this\prev[2]\next[2] = *this
               Else
                  If *this\parent\FirstWidget( )
                     *this\parent\FirstWidget( )\prev[2] = *this
                  EndIf
                  *this\parent\FirstWidget( ) = *this
               EndIf
            EndIf
            
            If Position = #PB_List_Last Or
               Position = #PB_List_After
               
               *this\prev[2]  = *widget
               *this\next[2]   = *widget\next[2]
               *widget\next[2] = *this
               
               If *this\next[2]
                  *this\next[2]\prev[2] = *this
               Else
                  If *this\parent\LastWidget( )
                     *this\parent\LastWidget( )\next[2] = *this
                  EndIf
                  *this\parent\LastWidget( ) = *this
               EndIf
            EndIf
            
            ;
            If Position = #PB_List_First Or
               Position = #PB_List_Last 
               PushListPosition( widgets( ) )
               ForEach widgets( )
                  widgets( )\layer = ListIndex( widgets( ) )
               Next
               PopListPosition( widgets( ) )
            Else
               If *this\next[2]
                  *this\next[2]\layer = *this\layer + 1 + *this\haschildren
               EndIf
               If *this\prev[2]
                  *this\prev[2]\layer = *this\layer - 1 - *this\haschildren
               EndIf
            EndIf
            ProcedureReturn #True
         EndIf
      EndIf
      
   EndProcedure
   
   ;-
   Procedure   ReParent( *this._s_WIDGET, *parent._s_PARENT )
      ;\\
      If Not is_integral_( *this )
         If Not is_root_( *parent )
            *parent\haschildren + 1
         EndIf
      EndIf
      
      ;\\
      If *this\parent
         If Not is_root_( *this\parent )
            *this\parent\haschildren - 1
         EndIf
      Else
         If Not *this\child
            ; If Not is_root_( *parent )
            *parent\root\haschildren + 1
            ; EndIf
         EndIf
      EndIf
      
      ;\\
      If *parent\root
         *this\root = *parent\root
      Else
         *this\root = *parent
      EndIf
      
      ;\\
      If is_window_( *parent )
         *this\window = *parent
      Else
         *this\window = *parent\window
      EndIf
      
      ;\\
      *this\level  = *parent\level + 1
      *this\parent = *parent
      
      ;\\ is integrall scroll bars
      If *this\scroll
         If *this\scroll\v
            *this\scroll\v\root   = *this\root
            *this\scroll\v\window = *this\window
         EndIf
         If *this\scroll\h
            *this\scroll\h\root   = *this\root
            *this\scroll\h\window = *this\window
         EndIf
      EndIf
      
      ;\\ is integrall tab bar
      If *this\tabbar
         *this\tabbar\root   = *this\root
         *this\tabbar\window = *this\window
      EndIf
      If *this\menubar
         *this\menubar\root   = *this\root
         *this\menubar\window = *this\window
      EndIf
      
      ;\\ is integrall string bar
      If *this\Stringbar
         *this\Stringbar\root   = *this\root
         *this\Stringbar\window = *this\window
      EndIf
      
      ;\\
      If *parent\bounds\children
         SetSizeBounds( *this )
         SetMoveBounds( *this )
      EndIf
   EndProcedure
   
   Procedure.i GetParent( *this._s_WIDGET )
      ProcedureReturn *this\parent
   EndProcedure
   
   Procedure   SetParent( *this._s_WIDGET, *parent._s_PARENT, tabindex.l = #PB_Default )
      Protected parent, ReParent.b, X, Y
      Protected._s_WIDGET *after, *last, *lastParent, NewList *D( ), NewList *C( )
      If Not *this > 0 Or *this = *parent : ProcedureReturn 0 : EndIf
      
      If *parent > 0
         If *this\parent = *parent
            If *this\tabindex = tabindex
               ProcedureReturn 0
            EndIf
         EndIf
         ;
         If *parent\child 
            If Not *parent\container 
               tabindex = #PB_Ignore
               *parent = *parent\parent
            EndIf
         EndIf
         ;
         If tabindex = #PB_Default
            If *parent\tabbar And *parent\tabbar\type = #__type_TabBar
               tabindex = *parent\openeditem
            ElseIf *parent\openeditem = #PB_Ignore
               tabindex = *parent\openeditem
               Debug "tabindex " + tabindex
            Else
               tabindex = 0
            EndIf
         EndIf
         
         ; =========================================================================
         ; ШАГ 1: ПОЛНАЯ ИЗОЛЯЦИЯ (Вырезаем матрешку из всех трех цепочек)
         ; =========================================================================
         Protected._s_PARENT *exFirst = *this
         Protected._s_PARENT *exLast  = GetLast( *this, tabindex ) ; Крайний Z-потомок
         
         ; А) Вырезаем из абсолютного Z-Order [0]
         If *exFirst\prev[0] : *exFirst\prev[0]\next[0] = *exLast\next[0]  : EndIf
         If *exLast\next[0]  : *exLast\next[0]\prev[0]  = *exFirst\prev[0] : EndIf
         
         ; Б) Вырезаем из видимого Z-Order [1]
         If *exFirst\prev[1] : *exFirst\prev[1]\next[1] = *exLast\next[1]  : EndIf
         If *exLast\next[1]  : *exLast\next[1]\prev[1]  = *exFirst\prev[1] : EndIf
         
         ; В) Вырезаем из локального списка братьев [2]
         If *this\prev[2] : *this\prev[2]\next[2] = *this\next[2] : EndIf
         If *this\next[2] : *this\next[2]\prev[2] = *this\prev[2] : EndIf
         
         ; Г) Корректируем First/Last указатели у СТАРОГО родителя
         If *this\parent 
            If *this\parent\first = *this : *this\parent\first = *this\next[2] : EndIf
            If *this\parent\last  = *this : *this\parent\last  = *this\prev[2] : EndIf
         EndIf
         
         ; Полная изоляция вырезанного поддерева
         *exFirst\prev[0] = #Null : *exLast\next[0] = #Null
         *exFirst\prev[1] = #Null : *exLast\next[1] = #Null
         *this\prev[2]    = #Null : *this\next[2]    = #Null
         
         ; =========================================================================
         ; ШАГ 2: ВЫЧИСЛЯЕМ ПОЗИЦИЮ В ЧИСТОЙ СТРУКТУРЕ
         ; =========================================================================
         *this\tabindex = tabindex
         *after  = #Null
         *last   = #Null ; Заменили *last, чтобы не путать со структурой
         
         If *parent
            ; Находим локального брата, после которого нужно встать
            *after = GetPosition( *parent, #PB_List_Last, tabindex )
            
            If *after
               ; Точка вставки в Z-Order — это самый последний Z-потомок нашего соседа
               *last = GetLast( *after, #PB_Default ) 
            Else
               ; Если локальный список пуст, вставляем Z-Order сразу после самого родителя
               *last = *parent
            EndIf
         EndIf
         
         ; =========================================================================
         ; ШАГ 3: ВСТРОЙКА В ЛОКАЛЬНЫЙ СПИСОК НОВОГО РОДИТЕЛЯ [2]
         ; =========================================================================
         If *parent
            If *after
               ; Вставка в середину или конец локального списка
               *this\next[2] = *after\next[2]
               *this\prev[2] = *after
               
               If *after\next[2]
                  *after\next[2]\prev[2] = *this
               Else
                  ; Если после *after никого не было, значит *this становится новым хвостом
                  *parent\last = *this
               EndIf
               *after\next[2] = *this
            Else
               ; Вставка в самый старт локального списка (вкладка пустая или индекс = 0)
               *this\next[2] = *parent\first
               *this\prev[2] = #Null
               
               If *parent\first
                  *parent\first\prev[2] = *this
               Else
                  ; Если список вообще был пуст, то элемент одновременно и первый, и последний
                  *parent\last = *this
               EndIf
               *parent\first = *this
            EndIf
         EndIf
         
         ; =========================================================================
         ; ШАГ 4: СИНХРОННАЯ ВСТРОЙКА В Z-ORDER ЦЕПОЧКИ [0] и [1]
         ; =========================================================================
         If *last
            ; --- 1. Абсолютный Z-Order [0] ---
            Protected._s_PARENT *oldNext0 = *last\next[0]
            
            *last\next[0] = *exFirst
            *exFirst\prev[0] = *last
            
            *exLast\next[0]  = *oldNext0
            If *oldNext0
               *oldNext0\prev[0] = *exLast
            EndIf
            
            ; --- 2. Видимый Z-Order [1] ---
            Protected._s_PARENT *oldNext1 = *last\next[1]
            
            *last\next[1] = *exFirst
            *exFirst\prev[1] = *last
            
            *exLast\next[1]  = *oldNext1
            If *oldNext1
               *oldNext1\prev[1] = *exLast
            EndIf
         EndIf
         
         ; 
         If tabindex = #PB_Ignore
         Else
            HideState( *this, *parent )
            DisableState( *this, *parent )
         EndIf
         
         ;
         If *parent\type = #__type_Splitter
            If tabindex > 0
               If tabindex % 2
                  ;*parent\FirstWidget( ) = *this
                  *parent\split_1( )    = *this
                  bar_update( *parent, 1 )
                  If IsGadget( *parent\split_1( ) )
                     ProcedureReturn 0
                  EndIf
               Else
                  ;*parent\LastWidget( ) = *this
                  *parent\split_2( )    = *this
                  bar_update( *parent, 1 )
                  If IsGadget( *parent\split_2( ) )
                     ProcedureReturn 0
                  EndIf
               EndIf
            EndIf
         EndIf
         ;
         ;\\
         PushListPosition( widgets( ) )
         If *this And
            *this\parent
            *lastParent = *this\parent
            
            ;
            If *this\address 
               ChangeCurrentElement( widgets( ), *this\address )
               AddElement( *D( ) ) : *D( ) = widgets( )
               
               If *this\haschildren
                  PushListPosition( widgets( ) )
                  While NextElement( widgets( ) )
                     If Not IsChild( widgets( ), *this )
                        Break
                     EndIf
                     
                     AddElement( *D( ) )
                     *D( ) = widgets( )
                     
                     ; ChangeParent
                     If *parent\window
                        *D( )\window = *parent\window
                     Else
                        *D( )\window = *parent
                     EndIf
                     If *parent\root
                        *D( )\root = *parent\root
                     Else
                        *D( )\root = *parent
                     EndIf
                     ;; Debug " children's - "+ *D( )\data +" - "+ *this\data
                     
                     ;\\ integrall children's
                     If *D( )\scroll
                        If *D( )\scroll\v
                           *D( )\scroll\v\root   = *D( )\root
                           *D( )\scroll\v\window = *D( )\window
                        EndIf
                        If *D( )\scroll\h
                           *D( )\scroll\h\root   = *D( )\root
                           *D( )\scroll\h\window = *D( )\window
                        EndIf
                     EndIf
                     
                     HideState( *D( ), *D( )\parent )
                     ;Debug *D( )\mask & #__mask_hide
                     
                  Wend
                  PopListPosition( widgets( ) )
               EndIf
               
               ;\\ move with a parent and his children's
               If *last
                  PushListPosition( widgets( ) )
                  LastElement( *D( ) )
                  Repeat
                     ChangeCurrentElement( widgets( ), *D( )\address )
                     MoveElement( widgets( ), #PB_List_After, *last\address )
                  Until PreviousElement( *D( ) ) = #False
                  PopListPosition( widgets( ) )
               EndIf
               ;
               ReParent = #True
            EndIf
            ;
         Else
            ;
            If *last And *last\address
               ChangeCurrentElement( widgets( ) , *last\address )
            Else
               LastElement( widgets( ) )
            EndIf
            AddElement( widgets( ) ) : widgets( ) = *this
            *this\layer   = ListIndex( widgets( ) )
            *this\createindex   = ListIndex( widgets( ) )
            *this\address = @widgets( )
         EndIf
         PopListPosition( widgets( ) )
         ;
         ;\\
         ReParent( *this, *parent )
         ;
         ;\\ a_new( )
         If a_anchors( ) And a_main( ) And IsChild( *this, a_main( ))
            If *this\parent\type = #__type_Splitter
               ; Debug ""+*this\class +" "+ *this\parent\class
               a_free( *this )
            Else
               If Not *this\autosize
                  If Not *this\anchors
                     If *this\parent\anchors 
                        a_create( *this, #__a_full )
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
         ;
         ;\\
         If ReParent
            If is_drag_move( )
               ; *this\resize\clip = #True
               
               X = *this\frame_x( ) - *parent\inner_x( )
               Y = *this\frame_y( ) - *parent\inner_y( )
               
               If *this\anchors > 0
                  X + ( X % mouse( )\steps )
                  X = ( X / mouse( )\steps ) * mouse( )\steps
                  
                  Y + ( Y % mouse( )\steps )
                  Y = ( Y / mouse( )\steps ) * mouse( )\steps
               EndIf
               
               *this\container_x( ) = X
               *this\container_y( ) = Y
            Else
               ;\\ resize
               X = *this\container_x( )
               Y = *this\container_y( )
               
               ;\\ for the scrollarea container childrens
               ;\\ if new parent - scrollarea container
               If *parent\scroll And
                  *parent\scroll\v And *parent\scroll\h
                  X - *parent\scroll\h\bar\page\pos
                  Y - *parent\scroll\v\bar\page\pos
               EndIf
               
               ;\\ if last parent - scrollarea container
               If *LastParent\scroll And
                  *LastParent\scroll\v And *LastParent\scroll\h
                  X + *LastParent\scroll\h\bar\page\pos
                  Y + *LastParent\scroll\v\bar\page\pos
               EndIf
               
               Resize( *this, X - *parent\scroll_x( ), Y - *parent\scroll_y( ), #PB_Ignore, #PB_Ignore, 0 )
            EndIf
            
            ;\\
            PostEventsRepaint( *parent\root )
            If *parent\root <> *lastParent\root
               PostRepaint( *lastParent\root )
            EndIf
         EndIf
      EndIf
      
      Widget( ) = *this
      ProcedureReturn *this
   EndProcedure
  
   Procedure.i OpenList( *parent._s_PARENT, item.l = 0 )
      If Not *parent : ProcedureReturn #False : EndIf
      Protected *prev._s_PARENT = Opened( )
      
      ; 2. ПОДДЕРЖКА ВКЛАДОК (TabBar)
      ; Гарантируем, что индекс не отрицательный
      If Item <> #PB_Ignore
         If Item < 0 : Item = 0 : EndIf
      EndIf
      *parent\openeditem = Item
      
      ; 3. ПЕРЕКЛЮЧЕНИЕ СИСТЕМНОГО КОНТЕКСТА
      If *prev <> *parent
         If *prev
            ; 1. ЛОГИЧЕСКАЯ СВЯЗЬ (Путь назад)
            ; Если уже есть открытый контекст — запоминаем его как "предыдущий"
            *parent\opened = *prev
            
            ; Если мы переходим на другой холст (другое окно)
            If *prev\root <> *parent\root And *parent\root
               ; Указываем PureBasic, в каком окне теперь создавать гаджеты
               UseGadgetList( WindowID( *parent\root\canvas\window ))
               ; Обновляем глобальный указатель на текущий активный холст
               ChangeCurrentCanvas( GadgetID( *parent\root\canvas\gadget ))
            EndIf
         EndIf
         
         ; Устанавливаем новый текущий активный элемент (куда будут падать виджеты)
         Opened( ) = *parent
      EndIf        
      
      ; Возвращаем указатель на того, кто был активен до этого (удобно для проверок)
      ProcedureReturn *prev
   EndProcedure
   
   Procedure.i CloseList( )
      Protected *prevRoot._s_ROOT
      If Opened( )
         If Opened( )\openeditem = #PB_Ignore
            Opened( )\openeditem = 0
         EndIf      
         Protected *prev._s_PARENT = Opened( )\opened
         ; Если у текущего элемента есть записанный "путь назад"
         If *prev
            If *prev\root
               *prevRoot = *prev\root
            Else
               *prevRoot = *prev
            EndIf
            
            ; Проверяем, нужно ли переключить системное окно PB назад
            ; (если родитель находится на другом холсте)
            If *prevRoot
               If Opened( )\root <> *prevRoot
                  ; Указываем PureBasic, в каком окне теперь создавать гаджеты
                  UseGadgetList( WindowID( *prevRoot\canvas\window ))
                  ; Обновляем глобальный указатель на текущий активный холст
                  ChangeCurrentCanvas( GadgetID( *prevRoot\canvas\gadget ))
               EndIf
            EndIf
            
            ; Делаем шаг назад по логической цепочке
            Opened( ) = *prev
         EndIf
      EndIf
      
      ; Возвращаем новый текущий контекст
      ProcedureReturn Opened( )
   EndProcedure
   
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 66
; FirstLine = 66
; Folding = --4-----------------------
; EnableXP
; DPIAware