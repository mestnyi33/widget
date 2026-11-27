;|-------------------------------------------------------------------------------------------------
;|
;|  Title            : TabBar
;|  Version          : 1.5 Beta 2a (2019-03-25)
;|  Copyright        : UnionBytes
;|                     (Martin Guttmann alias STARGATE)
;|  PureBasic        : 5.20+
;|  String Format    : Ascii, Unicode
;|  Operating System : Windows, Linux, MacOS
;|  Processor        : x86, x64
;|
;|-------------------------------------------------------------------------------------------------
;|
;|  Description      : Gadget for displaying and using tabs like in the browser
;|
;|  Forum Topic      : http://www.purebasic.fr/german/viewtopic.php?f=8&t=24788
;|                     http://www.purebasic.fr/english/viewtopic.php?f=12&t=47588
;|  Website          : http://www.unionbytes.de/includes/TabBar/
;|
;|  Documentation    : http://help.unionbytes.de/tbg/
;|
;|-------------------------------------------------------------------------------------------------





EnableExplicit





;|??????????????????????????????????????????????????????????????????????????????????????????????????
;-  1. Constants / Konstanten
;|__________________________________________________________________________________________________
#__tab_DefaultHeight     = 1

; Positions-Konstanten fur "Item"-Befehle
Enumeration
   #__tab_item_None        = -1 
   #__tab_item_NewTab      = -2
   #__tab_item_Selected    = -3
   #__tab_item_Event       = -4
EndEnumeration

; Attribute fur das TabBar
Enumeration
   #__MASK_None                     = 0<<0
   #__MASK_Vertical                   = 1<<4
   #__MASK_NewTab                = 1<<1
   #__MASK_CloseTab          = 1<<0 
   #__MASK_CloseSelectTab    = 1<<12
   #__MASK_TabTextAlignment   = 1<<24
   #__MASK_NormalTabLength    = 1<<26 ; fur Spater
   #__MASK_MaxTabLength         = 1<<27
   #__MASK_MinTabLength         = 1<<28
   #__MASK_TabRounding          = 1<<29
   #__MASK_NoTabMoving        = 1<<5
   #__MASK_TextCutting           = 1<<2
   #__MASK_MirroredTabs         = 1<<3
   #__MASK_MultiLine               = 1<<6
   #__MASK_MultiSelect                = 1<<10
   #__MASK_BottomLine           = 1<<7
   #__MASK_PopupButton         = 1<<8
   #__MASK_Editable                   = 1<<9
   #__MASK_CheckBox                    = 1<<11
   #__MASK_ReverseOrdering      = 1<<13
   #__MASK_ImageSize                = 1<<23
   #__MASK_ScrollPosition           = 1<<25
   #__MASK_PreviousArrow        = 1<<30
   #__MASK_NextArrow            = 1<<31
EndEnumeration

; Ereignisse von TabBarEvent
Enumeration #PB_EventType_FirstCustomValue
   #__EVENT_Pushed 
   #__EVENT_Updated      ; Das Gadget hat sich aktualisiert (intern)
   #__EVENT_Change       ; Der aktive Tab wurde geandert
   #__EVENT_Resize       ; Die gro?e der Leiste hat sich geandert
   #__EVENT_NewItem      ; ein neuer Tab wird angefordert
   #__EVENT_ItemClose    ; ein Tab soll geschlossen werden
   #__EVENT_SwapItem     ; der aktive Tab wurde verschoben
   #__EVENT_EditItem     ; der Text einer Karte wurde geandert
   #__EVENT_CheckBox     ; der Status der Checkbox hat sich geandert
   #__EVENT_PopupButton  ; der Popup-Button wurde gedruckt
EndEnumeration

; Interne Konstanten
#__s_Normal    = 0
#__s_Hover       = 1
#__s_Selected  = 2
#__s_Disable   = 3
#__s_Move      = 4

; Status-Konstanten
Enumeration
   #__STATEMASK_Normal          = 0<<#__s_Normal
   #__STATEMASK_Entered         = 1<<#__s_Hover
   #__STATEMASK_Selected        = 1<<#__s_Selected
   #__STATEMASK_Disabled        = 1<<#__s_Disable
   #__STATEMASK_Checked         = 1<<#__s_Move
EndEnumeration


; Привязка к окну и холсту PureBasic
Structure _s_canvas
   Window.i      ; Номер окна (Window ID)
   Gadget.i      ; Номер гаджета (CanvasGadget ID)
EndStructure

; Вспомогательная структура для алгоритма укорачивания текста
Structure _s_SortedItem
   *Item._s_ROW  ; Указатель на вкладку
   Characters.i  ; Количество символов в тексте
EndStructure

; Текущие параметры одной строки вкладок (в многострочном режиме)
Structure _s_row_
   Length.i      ; Текущая суммарная длина строки в пикселях
   Items.i       ; Текущее количество вкладок в этой строке
EndStructure

; Цветовая палитра элемента (массивы на 4 элемента соответствуют состояниям: Normal, Hover, Selected, Disable)
Structure _s_color
   state.b       ; Битовая маска текущего состояния (entered, selected, disabled)
   front.i[4]    ; Цвет текста для каждого из 4 состояний
   line.i[4]     ; Цвет линии
   fore.i[4]     ; Основной цвет фона вкладки
   back.i[4]     ; Вторичный цвет фона (для градиента)
   Frame.i[4]    ; Цвет рамки вкладки
   alpha.a[2]    ; Значения прозрачности (альфа-канал)
EndStructure

; Внутренняя геометрия и координаты элементов одной вкладки
Structure _s_itemLayout
   X.i           ; X-координата вкладки
   Y.i           ; Y-координата вкладки
   Width.i       ; Внутренняя ширина
   Height.i      ; Внутренняя высота
   PaddingX.i    ; Увеличение отступа по X (например, для выделения активной вкладки)
   PaddingY.i    ; Увеличение отступа по Y
   CrossX.i      ; X-координата крестика закрытия
   CrossY.i      ; Y-координата крестика закрытия
   TextX.i       ; X-координата текста
   TextY.i       ; Y-координата текста
   CheckX.i      ; X-координата чекбокса
   CheckY.i      ; Y-координата чекбокса
   ImageX.i      ; X-координата иконки
   ImageY.i      ; Y-координата иконки
EndStructure


; Вкладка (отдельный элемент панели)
Structure _s_ROW
   Text.s                        ; Текст вкладки
   ShortText.s                   ; Укороченный текст (если не помещается)
   color._s_color                ; Цветовые атрибуты
   Image.i                       ; Изображение (копия оригинала)
   DrawedImage.i                 ; Отрисовываемое изображение (при необходимости повернутое)
   DataValue.i                   ; Пользовательское значение (данные)
   Attributes.i                  ; Атрибуты вкладки
   Disabled.i                    ; Флаг: вкладка отключена (неактивна)
   Selected.i                    ; Флаг: вкладка выбрана в данный момент
   Checked.i                     ; Флаг: установлена галочка (чекбокс)
   ToolTip.s                     ; Текст всплывающей подсказки
   Length.i                      ; Длина вкладки в пикселях (ВРЕМЕННОЕ)
   Row.i                         ; Номер строки, в которой находится вкладка (ВРЕМЕННОЕ)
   Position.i                    ; Позиция вкладки (ВРЕМЕННОЕ)
   Visible.i                     ; Флаг: видима и отрисовывается (ВРЕМЕННОЕ)
   Face.i                        ; Внешний вид / состояние отрисовки (ВРЕМЕННОЕ)
   Layout._s_itemLayout          ; Макет расположения элементов внутри вкладки (ВРЕМЕННОЕ)
   *PreviousSelectedItem._s_ROW  ; Указатель на предыдущую выбранную вкладку
EndStructure

; Всплывающие подсказки (Tooltips)
Structure ToolTip
   *Current                      ; Текущий адрес (указатель) подсказки
   *Old                          ; Предыдущий адрес подсказки
   ItemText.s                    ; Текст подсказки для обычной вкладки
   NewText.s                     ; Текст подсказки для кнопки «Новая вкладка»
   CloseText.s                   ; Текст подсказки для кнопки закрытия
EndStructure

; Редактор текста вкладки (при переименовании)
Structure _s_Editor
   *Item._s_ROW                  ; Указатель на редактируемую вкладку
   OldText.s                     ; Исходный текст до начала редактирования
   Cursor.i                      ; Позиция курсора
   Selection.i                   ; Длина выделенного фрагмента текста
   Selectable.i                  ; Флаг: приводит ли движение мыши к выделению текста
EndStructure

; Макет кнопок навигации на панели
Structure _s_Layout
   PreviousButtonX.i             ; Координата X стрелки навигации «Назад»
   PreviousButtonY.i             ; Координата Y стрелки навигации «Назад»
   NextButtonX.i                 ; Координата X стрелки навигации «Вперед»
   NextButtonY.i                 ; Координата Y стрелки навигации «Вперед»
   PopupButtonX.i                ; Координата X кнопки выпадающего списка вкладок
   PopupButtonY.i                ; Координата Y кнопки выпадающего списка вкладок
   ButtonWidth.i                 ; Ширина кнопок
   ButtonHeight.i                ; Высота кнопок
   ButtonSize.i                  ; Общий размер кнопок
EndStructure

; Основная структура панели вкладок (сам гаджет)
Structure _s_widget
   Canvas._s_canvas              ; Холст для отрисовки
   FontID.i                      ; Идентификатор шрифта
   DataValue.i                   ; Пользовательские данные гаджета
   Attributes.i                  ; Атрибуты панели
   List Item._s_ROW()            ; Связный список всех вкладок
   NewTabItem._s_ROW             ; Вкладка-кнопка для создания новой вкладки («+»)
   *SelectedItem._s_ROW          ; Указатель на текущую выбранную вкладку
   *MoveItem._s_ROW              ; Указатель на перетаскиваемую вкладку
   *HoverItem._s_ROW             ; Указатель на вкладку под курсором мыши
   HoverClose.i                  ; Флаг: курсор над кнопкой закрытия
   HoverCheck.i                  ; Флаг: курсор над чекбоксом
   HoverArrow.i                  ; Флаг: курсор над кнопкой навигации
   *ReadyToMoveItem._s_ROW       ; Вкладка, готовая к началу перетаскивания
   *LockedItem._s_ROW            ; Вкладка, на которой нажата кнопка мыши (для обработки клика)
   LockedClose.i                 ; Нажата кнопка закрытия
   LockedCheck.i                 ; Нажат чекбокс (в оригинале опечатка в комментарии)
   LockedArrow.i                 ; Нажата кнопка навигации
   SaveMouseX.i                  ; Сохраненная координата X мыши
   SaveMouseY.i                  ; Сохраненная координата Y мыши
   MouseX.i                      ; Текущая координата X мыши
   MouseY.i                      ; Текущая координата Y мыши
   Event.i                       ; Последнее произошедшее событие
   EventTab.i                    ; Позиция вкладки, на которой произошло последнее событие
   Shift.i                       ; Текущее смещение (прокрутка) панели
   LastShift.i                   ; Максимально возможное смещение
   FocusingSelectedTab.i         ; Флаг: нужно ли сфокусироваться на выбранной вкладке
   MaxLength.i                   ; Максимально доступная длина для вкладок
   Length.i                      ; Суммарная длина всех видимых вкладок
   Radius.i                      ; Радиус скругления углов вкладок
   MinTabLength.i                ; Минимальная длина вкладки
   MaxTabLength.i                ; Максимальная длина вкладки
   NormalTabLength.i             ; Стандартная длина вкладки
   TabTextAlignment.i            ; Выравнивание текста на вкладке
   ToolTip.ToolTip               ; Настройки всплывающих подсказок
   TabSize.i                     ; Размер (высота/ширина) одной вкладки
   Rows.i                        ; Количество строк вкладок
   Resized.i                     ; Флаг: гаджет должен изменить размер
   Editor._s_Editor              ; Данные встроенного редактора текста
   Layout._s_Layout              ; Координаты кнопок навигации
   UpdatePosted.i                ; Флаг: отправлено событие обновления (#True после PostEvent)
EndStructure

; Таймер для непрерывной прокрутки вкладок
Structure Timer
   *widget._s_widget             ; Указатель на панель вкладок (TabBar-ID)
   Type.i                        ; Режим работы (направление прокрутки)
   Mutex.i                       ; Мьютекс для потокобезопасности
EndStructure

; Глобальные настройки и параметры по умолчанию для подключаемого модуля
Structure _s_include
   TabBarColor.i                 ; Фоновый цвет самого гаджета
   color._s_color                ; Цветовая схема по умолчанию (фон, рамка, текст)
   HoverColorPlus.i              ; Изменение цвета при наведении курсора (Hover)
   ActivColorPlus.i              ; Изменение цвета для активной (выбранной) вкладки
   PaddingX.i                    ; Внутренний отступ по горизонтали (от текста до рамки)
   PaddingY.i                    ; Внутренний отступ по вертикали
   Margin.i                      ; Внешний отступ (от рамки вкладки до края гаджета)
   ImageSpace.i                  ; Отступ между иконкой и текстом
   CloseTabSize.i             ; Размер крестика закрытия вкладки
   CheckBoxSize.i                ; Размер чекбокса
   ImageSize.i                   ; Размер иконки
   ArrowSize.i                   ; Размер стрелки навигации
   ArrowWidth.i                  ; Ширина стрелки
   ArrowHeight.i                 ; Высота стрелки
   Radius.i                      ; Радиус скругления вкладки
   MinTabLength.i                ; Минимальная длина вкладки
   MaxTabLength.i                ; Максимальная длина вкладки
   TabTextAlignment.i            ; Выравнивание текста
   VerticalTextBugFix.f          ; Коэффициент коррекции вертикального положения текста
   NormalTabLength.i             ; Стандартная длина вкладки (зарезервировано на будущее)
   FadeOut.i                     ; Длина градиента затухания по краям при прокрутке
   WheelDirection.i              ; Направление прокрутки колесиком мыши
   RowDirection.i                ; Порядок расположения строк (сверху вниз или снизу вверх)
   EnableDoubleClickForNewTab.i  ; Создавать событие новой вкладки по двойному клику на пустом месте
   EnableMiddleClickForCloseTab.i; Закрывать вкладку по клику средней кнопкой мыши
   Timer.Timer                   ; Структура таймера для плавной прокрутки
EndStructure


;|??????????????????????????????????????????????????????????????????????????????????????????????????
;-  3. Initializations / Initialisierungen
;|__________________________________________________________________________________________________



Global includes._s_include
Declare Timer(Null.i)

; Diese Werte konnen sowohl im Include, als auch im Hauptcode spater uber includes\Feld geandert werden.
With includes
   CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
         \TabBarColor   = $FF<<24 | GetSysColor_(#COLOR_BTNFACE)
         \color\frame   = $FF<<24 | GetSysColor_(#COLOR_3DSHADOW)
         \color\fore     = $FF<<24 | GetSysColor_(#COLOR_BTNFACE)
         \color\front     = $FF<<24 | GetSysColor_(#COLOR_BTNTEXT)
      CompilerDefault
         \TabBarColor   = $FFD0D0D0
         \color\frame   = $FF808080
         \color\fore     = $FFD0D0D0
         \color\front     = $FF000000
   CompilerEndSelect
   \HoverColorPlus               = $FF101010
   \ActivColorPlus               = $FF101010
   
   \PaddingX                     = 6  ; Space from tab border to text
   \PaddingY                     = 5  ; Space from tab border to text
   \Margin                       = 4  ; Space from tab to border
   \ImageSpace                   = 3  ; Space from image zu text
   \ImageSize                    = 16
   \CloseTabSize              = 13 ; Size of the close cross
   \CheckBoxSize                 = 10
   \ArrowSize                    = 5  ; Size of the Arrow in the button in navigation
   \ArrowWidth                   = 12 ; Width of the Arrow-Button in navigation
   \ArrowHeight                  = 18 ; Height of the Arrow-Button in navigation
   \Radius                       = 3  ; Radius of the edge of the tab
   \TabTextAlignment             = -1
   \VerticalTextBugFix           = 1.05
   \MinTabLength                 = 0
   \MaxTabLength                 = 10000
   \NormalTabLength              = 150
   \FadeOut                      = 32 ; Length of fade out to the navi
   \WheelDirection               = -1
   \RowDirection                 = 1 ; not used
   \EnableDoubleClickForNewTab   = #True
   \EnableMiddleClickForCloseTab = #True
   \Timer\Mutex                  = CreateMutex()
   CompilerIf #PB_Compiler_Thread
      CreateThread(@Timer(), #Null)
   CompilerEndIf
EndWith






;|??????????????????????????????????????????????????????????????????????????????????????????????????
;-  4. Procedures & Macros / Prozeduren & Makros
;|__________________________________________________________________________________________________



;-  4.1 Private procedures for internal calculations ! Not for use !
;???????????????????????????????????????????????????????????????????????????????????????????????????



; Gitb die Adresse (ID) der Registerkarte zuruck.
;   Position kann eine Konstante, Position oder ID sein.
Procedure.i ItemID(*this._s_widget, Position.i) ; Code OK
   
   With *this
      
      Select Position
         Case #__tab_item_Event
            ProcedureReturn ItemID(*this, \EventTab)
         Case #__tab_item_Selected
            If \SelectedItem
               ChangeCurrentElement(\Item(), \SelectedItem)
               ProcedureReturn @\Item()
            Else
               ProcedureReturn #Null
            EndIf
         Case #__tab_item_NewTab
            ProcedureReturn @\NewTabItem
         Case #__tab_item_None
            ProcedureReturn #Null
         Default 
            If Position >= 0 And Position < ListSize(\Item())
               ProcedureReturn SelectElement(\Item(), Position)
            ElseIf Position >= ListSize(\Item())
               ForEach \Item()
                  If @\Item() = Position
                     ProcedureReturn @\Item()
                  EndIf
               Next
            EndIf
      EndSelect
      
   EndWith
   
EndProcedure



; Gibt die Ressourcen einer Registerkarte wieder frei.
Procedure ClearItem(*this._s_widget, *Item._s_ROW) ; Code OK
   
   If *Item\Image
      FreeImage(*Item\Image)
   EndIf
   If *Item\DrawedImage
      FreeImage(*Item\DrawedImage)
   EndIf
   
EndProcedure



; Wahlt die angegebene Karte aus und aktualisiert die Select-Hierarchie
Procedure SelectItem(*this._s_widget, *Item._s_ROW) ; Code OK
   
   If *this\Attributes & #__MASK_MultiSelect = #False
      ForEach *this\Item()
         *this\Item()\Selected = #False
      Next 
   EndIf
   If *Item
      *Item\Selected = #True
      If *Item <> *this\SelectedItem
         *Item\PreviousSelectedItem = *this\SelectedItem
      EndIf
      *this\FocusingSelectedTab = #True
   EndIf
   *this\SelectedItem = *Item
   
EndProcedure



; Wahlt die angegebene Karte ab und aktualisiert die Select-Hierarchie
Procedure UnselectItem(*this._s_widget, *Item._s_ROW) ; Code OK
   
   *Item\Selected = #False
   ForEach *this\Item()
      If *this\Item()\PreviousSelectedItem = *Item
         If *Item\PreviousSelectedItem <> *this\Item()
            *this\Item()\PreviousSelectedItem = *Item\PreviousSelectedItem
         Else
            *this\Item()\PreviousSelectedItem = #Null
         EndIf
      EndIf
   Next
   If *this\SelectedItem = *Item ; Auswahl muss geandert werden
      *this\SelectedItem = *Item\PreviousSelectedItem
      If *this\SelectedItem
         *this\SelectedItem\Selected = #True
      EndIf
   EndIf
   
EndProcedure



; Entfernt die Registerkarte und aktualisiert die Select-Hierarchie
Procedure RemoveItem(*this._s_widget, *Item._s_ROW) ; Code OK
   
   ClearItem(*this, *Item)
   
   If *this\SelectedItem
      UnselectItem(*this, *Item)
      
      If *this\SelectedItem = #Null
         ChangeCurrentElement(*this\Item(), *Item)
         If NextElement(*this\Item())
            SelectItem(*this, *this\Item())
         ElseIf PreviousElement(*this\Item())
            SelectItem(*this, *this\Item())
         EndIf
      EndIf
   Else
      UnselectItem(*this, *Item)
   EndIf
   
   ChangeCurrentElement(*this\Item(), *Item)
   DeleteElement(*this\Item())
   
   
   
   ;   ClearItem(*this, *Item)
   ;   UnselectItem(*this, *Item)
   ;   
   ;   ChangeCurrentElement(*this\Item(), *Item)
   ;   If NextElement(*this\Item()) Or 
   ;      PreviousElement(*this\Item())
   ;     SelectItem(*this, *this\Item())
   ;   EndIf
   ;   
   ;   ChangeCurrentElement(*this\Item(), *Item)
   ;   DeleteElement(*this\Item())
   
   
EndProcedure



; Gibt #True zuruck, wenn die Maus innerhalb des Rechtecks ist.
;   Width und Height konnen auch negativ sein.
Procedure.i MouseIn(*this._s_widget, X.i, Y.i, Width.i, Height.i) ; Code OK
   
   With *this
      
      If Width  < 0 : X + Width  : Width  * -1 : EndIf
      If Height < 0 : Y + Height : Height * -1 : EndIf
      If \MouseX >= X And \MouseX < X+Width And \MouseY >= Y And \MouseY < Y+Height
         ProcedureReturn #True
      EndIf
      
   EndWith
   
EndProcedure



; Farbaddition
Procedure.i ColorPlus(Color.i, Plus.i) ; Code OK
   
   If Color&$FF + Plus&$FF < $FF
      Color + Plus&$FF
   Else
      Color | $FF
   EndIf 
   
   If Color&$FF00 + Plus&$FF00 < $FF00
      Color + Plus&$FF00
   Else
      Color | $FF00
   EndIf 
   
   If Color&$FF0000 + Plus&$FF0000 < $FF0000
      Color + Plus&$FF0000
   Else
      Color | $FF0000
   EndIf 
   
   ProcedureReturn Color
   
EndProcedure



; Farbsubtraktion
Procedure.i ColorMinus(Color.i, Minus.i) ; Code OK
   
   If Color&$FF - Minus&$FF > 0
      Color - Minus&$FF
   Else
      Color & $FFFFFF00
   EndIf 
   
   If Color&$FF00 - Minus&$FF00 > 0
      Color - Minus&$FF00
   Else
      Color & $FFFF00FF
   EndIf 
   
   If Color&$FF0000 - Minus&$FF0000 > 0
      Color - Minus&$FF0000
   Else
      Color & $FF00FFFF
   EndIf 
   
   ProcedureReturn Color
   
EndProcedure



; Zeichnet ein (Schlie?en-)Kreuz
Procedure DrawCross(X.i, Y.i, Size.i, Color.i) ; Code OK
   
   Protected Alpha.i = Alpha(Color)/4
   
   Line(X  , Y+1     , Size-1,  Size-1, Color&$FFFFFF|Alpha<<24)
   Line(X+1, Y       , Size-1,  Size-1, Color&$FFFFFF|Alpha<<24)
   Line(X  , Y+Size-2, Size-1, -Size+1, Color&$FFFFFF|Alpha<<24)
   Line(X+1, Y+Size-1, Size-1, -Size+1, Color&$FFFFFF|Alpha<<24)
   Line(X  , Y       , Size  ,  Size  , Color)
   Line(X  , Y+Size-1, Size  , -Size  , Color)
   
EndProcedure



; Zeichnet einen Button
Procedure DrawButton(X.i, Y.i, Width.i, Height.i, Type.i, Color, Vertical.i=#False) ; Code OK
   
   If Type
      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Gradient)
      ResetGradientColors()
      If Type = 1
         GradientColor(0.0, ColorPlus(Color, $404040))
         GradientColor(0.5, Color)
         GradientColor(1.0, ColorMinus(Color, $404040))
      ElseIf Type = -1
         GradientColor(1.0, ColorPlus(Color, $404040))
         GradientColor(0.5, Color)
         GradientColor(0.0, ColorMinus(Color, $404040))
      EndIf
      If Vertical
         LinearGradient(X, Y, X+Width-1, Y)
         RoundBox(X, Y, Width, Height, 3, 3)
         DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
         RoundBox(X, Y, Width, Height, 3, 3, includes\color\frame&$FFFFFF|$80<<24)
      Else
         LinearGradient(X, Y, X, Y+Height-1)
         RoundBox(X, Y, Width, Height, 3, 3)
         DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
         RoundBox(X, Y, Width, Height, 3, 3, includes\color\frame&$FFFFFF|$80<<24)
      EndIf
      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
   EndIf
   
EndProcedure



; Zeichnet einen Pfeil
Procedure DrawArrow(X.i, Y.i, Type.i, Color.i, Attributes.i=#Null) ; Code OK
   
   Protected Index.i, Alpha.i = Alpha(Color)/4
   
   With includes
      If Attributes & #__MASK_Vertical
         If Attributes & #__MASK_MirroredTabs
            Select Type
               Case #__MASK_PopupButton
                  X - \ArrowSize/2-1
                  For Index = 1 To \ArrowSize
                     Line(X+Index, Y-Index, 1, Index*2, Color)
                  Next
                  LineXY(X, Y-1, X+\ArrowSize, Y-1-\ArrowSize, Color&$FFFFFF|Alpha<<24)
                  LineXY(X, Y, X+\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
            EndSelect
         Else
            Select Type
               Case #__MASK_PopupButton
                  X + \ArrowSize/2
                  For Index = 1 To \ArrowSize
                     Line(X-Index, Y-Index, 1, Index*2, Color)
                  Next
                  LineXY(X, Y-1, X-\ArrowSize, Y-1-\ArrowSize, Color&$FFFFFF|Alpha<<24)
                  LineXY(X, Y, X-\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
            EndSelect
         EndIf
         If Attributes & #__MASK_MirroredTabs XOr Attributes & #__MASK_ReverseOrdering
            Select Type
               Case #__MASK_PreviousArrow
                  Y - \ArrowSize/2-1
                  For Index = 1 To \ArrowSize
                     Line(X-Index, Y+Index, Index*2, 1, Color)
                  Next
                  LineXY(X-1, Y, X-1-\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
                  LineXY(X, Y, X+\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
               Case #__MASK_NextArrow
                  Y + \ArrowSize/2
                  For Index = 1 To \ArrowSize
                     Line(X-Index, Y-Index, Index*2, 1, Color)
                  Next
                  LineXY(X-1, Y, X-1-\ArrowSize, Y-\ArrowSize, Color&$FFFFFF|Alpha<<24)
                  LineXY(X, Y, X+\ArrowSize, Y-\ArrowSize, Color&$FFFFFF|Alpha<<24)
            EndSelect
         Else
            Select Type
               Case #__MASK_PreviousArrow
                  Y + \ArrowSize/2
                  For Index = 1 To \ArrowSize
                     Line(X-Index, Y-Index, Index*2, 1, Color)
                  Next
                  LineXY(X-1, Y, X-1-\ArrowSize, Y-\ArrowSize, Color&$FFFFFF|Alpha<<24)
                  LineXY(X, Y, X+\ArrowSize, Y-\ArrowSize, Color&$FFFFFF|Alpha<<24)
               Case #__MASK_NextArrow
                  Y - \ArrowSize/2-1
                  For Index = 1 To \ArrowSize
                     Line(X-Index, Y+Index, Index*2, 1, Color)
                  Next
                  LineXY(X-1, Y, X-1-\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
                  LineXY(X, Y, X+\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
            EndSelect
         EndIf
      Else
         Select Type
            Case #__MASK_PopupButton
               Y + \ArrowSize/2
               For Index = 1 To \ArrowSize
                  Line(X-Index, Y-Index, Index*2, 1, Color)
               Next
               LineXY(X-1, Y, X-1-\ArrowSize, Y-\ArrowSize, Color&$FFFFFF|Alpha<<24)
               LineXY(X, Y, X+\ArrowSize, Y-\ArrowSize, Color&$FFFFFF|Alpha<<24)
         EndSelect
         If Attributes & #__MASK_ReverseOrdering
            Select Type
               Case #__MASK_PreviousArrow
                  X + \ArrowSize/2
                  For Index = 1 To \ArrowSize
                     Line(X-Index, Y-Index, 1, Index*2, Color)
                  Next
                  LineXY(X, Y-1, X-\ArrowSize, Y-1-\ArrowSize, Color&$FFFFFF|Alpha<<24)
                  LineXY(X, Y, X-\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
               Case #__MASK_NextArrow
                  X - \ArrowSize/2-1
                  For Index = 1 To \ArrowSize
                     Line(X+Index, Y-Index, 1, Index*2, Color)
                  Next
                  LineXY(X, Y-1, X+\ArrowSize, Y-1-\ArrowSize, Color&$FFFFFF|Alpha<<24)
                  LineXY(X, Y, X+\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
            EndSelect
         Else
            Select Type
               Case #__MASK_PreviousArrow
                  X - \ArrowSize/2-1
                  For Index = 1 To \ArrowSize
                     Line(X+Index, Y-Index, 1, Index*2, Color)
                  Next
                  LineXY(X, Y-1, X+\ArrowSize, Y-1-\ArrowSize, Color&$FFFFFF|Alpha<<24)
                  LineXY(X, Y, X+\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
               Case #__MASK_NextArrow
                  X + \ArrowSize/2
                  For Index = 1 To \ArrowSize
                     Line(X-Index, Y-Index, 1, Index*2, Color)
                  Next
                  LineXY(X, Y-1, X-\ArrowSize, Y-1-\ArrowSize, Color&$FFFFFF|Alpha<<24)
                  LineXY(X, Y, X-\ArrowSize, Y+\ArrowSize, Color&$FFFFFF|Alpha<<24)
            EndSelect
         EndIf
      EndIf
   EndWith
   
EndProcedure



; Gibt die Lange der Registerkate zuruck.
Procedure.i ItemLength(*this._s_widget, *Item._s_ROW) ; Code OK
   
   Protected TextLength.i = TextWidth(*Item\ShortText)
   Protected Length.i = 2 * includes\PaddingX
   Protected Characters.i, VerticalTextBugFix.f = 1.0
   
   If *this\Attributes & #__MASK_Vertical
      TextLength * includes\VerticalTextBugFix ; 5% langer, wegen Ungenaugikeit von TextWidth bei Rotation
      VerticalTextBugFix = includes\VerticalTextBugFix
   EndIf
   If *Item\Attributes & #__MASK_CloseTab Or (*Item\Attributes & #__MASK_CloseSelectTab And *Item\Selected)
      Length + includes\CloseTabSize-4 + includes\ImageSpace
   EndIf
   If *Item\Attributes & #__MASK_CheckBox
      Length + includes\CheckBoxSize + includes\ImageSpace
   EndIf
   If *Item\Image
      If *this\Attributes & #__MASK_Vertical
         Length + ImageHeight(*Item\Image)
      Else
         Length + ImageWidth(*Item\Image)
      EndIf
      If *Item\ShortText
         Length + includes\ImageSpace
      EndIf
   ElseIf *Item = *this\NewTabItem And *Item\Text = ""
      Length + 16
   EndIf
   If *Item <> *this\NewTabItem
      If TextLength+Length < *this\MinTabLength
         Length = *this\MinTabLength-TextLength
      EndIf
      If TextLength+Length > *this\MaxTabLength
         Characters = Len(*Item\Text)
         Repeat
            Characters - 1
            TextLength = TextWidth(Left(*Item\Text, Characters)+"..")*VerticalTextBugFix
         Until Characters = 1 Or TextLength+Length <= *this\MaxTabLength
         *Item\ShortText = Left(*Item\Text, Characters) + ".."
      EndIf
   EndIf
   
   ProcedureReturn TextLength + Length
   
EndProcedure



; Gibt den maximal zur verfugungstehenden Platz fur Registerkarten zuruck.
Procedure.i MaxLength(*this._s_widget, WithNewTab.i=#True) ; Code OK
   
   Protected Length.i
   
   With *this
      If \Attributes & #__MASK_Vertical
         Length = OutputHeight() - includes\Margin*2
      Else
         Length = OutputWidth()  - includes\Margin*2
      EndIf
      If \Attributes & #__MASK_NewTab And WithNewTab
         Length - *this\NewTabItem\Length + 1
      EndIf
      If \Attributes & #__MASK_PreviousArrow
         Length - includes\ArrowWidth
      EndIf
      If \Attributes & #__MASK_NextArrow
         Length - includes\ArrowWidth
         If \Attributes & #__MASK_NewTab
            Length - includes\Margin
         EndIf
      EndIf
      If \Attributes & #__MASK_PopupButton
         Length - includes\ArrowHeight
      EndIf
   EndWith
   
   ProcedureReturn Length
   
EndProcedure



; Fuhrt eine Textkurzung durch, bis alle Karte in die Leiste passen.
Procedure.i TextCutting(*this._s_widget) ; Code OK
   
   Protected NewList SortedItem._s_SortedItem()
   Protected *SortedItem._s_SortedItem
   Protected MaxLength.i = 1, Length.i
   
   With *this
      
      ; Der Textlange nach (gro? -> klein) sortierte Eintrage anlegen.
      ForEach \Item()
         \Item()\ShortText      = \Item()\Text
         \Item()\Length         = ItemLength(*this, @\Item())
         If *this\Editor\Item <> \Item()
            LastElement(SortedItem())
            *SortedItem            = AddElement(SortedItem())
            *SortedItem\Item       = @\Item()
            *SortedItem\Characters = Len(\Item()\Text)
            While PreviousElement(SortedItem()) And *SortedItem\Item\Length > SortedItem()\Item\Length
               SwapElements(SortedItem(), @SortedItem(), *SortedItem)
               ChangeCurrentElement(SortedItem(), *SortedItem)
            Wend
         EndIf
         MaxLength + \Item()\Length - 1
      Next
      
      ; Textkurzung durchfuhren, bis alle Karte in die maximale Breite passen.
      While MaxLength > \MaxLength And FirstElement(SortedItem())
         *SortedItem = @SortedItem()
         If *SortedItem\Characters > 3 And *SortedItem\Item\Length > \MinTabLength
            *SortedItem\Characters - 1
            *SortedItem\Item\ShortText = Left(*SortedItem\Item\Text, *SortedItem\Characters)+".."
            Length = ItemLength(*this, *SortedItem\Item)
            MaxLength - (*SortedItem\Item\Length-Length)
            *SortedItem\Item\Length = Length
            While NextElement(SortedItem()) And *SortedItem\Item\Length < SortedItem()\Item\Length
               SwapElements(SortedItem(), @SortedItem(), *SortedItem)
               ChangeCurrentElement(SortedItem(), *SortedItem)
            Wend
         Else
            DeleteElement(SortedItem())
         EndIf
      Wend
      
   EndWith
   
   ProcedureReturn MaxLength
   
EndProcedure



; Rotiert das Image abhangig von der Leistenausrichtung 
Procedure RotateImage(*this._s_widget, *Item._s_ROW) ; Code OK
   
   Protected LastX.i = ImageWidth(*Item\Image)-1
   Protected LastY.i = ImageHeight(*Item\Image)-1
   Protected Dim Pixel.l(LastX, LastY)
   Protected Y.i, X.i, RotatedImage.i
   
   If *Item\DrawedImage
      FreeImage(*Item\DrawedImage)
   EndIf
   
   If *this\Attributes & #__MASK_Vertical
      If StartDrawing(ImageOutput(*Item\Image))
         DrawingMode(#PB_2DDrawing_AllChannels)
         For Y = 0 To LastY
            For X = 0 To LastX
               Pixel(X, Y) = Point(X, Y)
            Next
         Next
         StopDrawing()
      EndIf
      
      CompilerIf #PB_Compiler_Version >= 520
         *Item\DrawedImage = CreateImage(#PB_Any, includes\ImageSize, includes\ImageSize, 32, #PB_Image_Transparent)
      CompilerElse
         *Item\DrawedImage = CreateImage(#PB_Any, includes\ImageSize, includes\ImageSize, 32|#PB_Image_Transparent)
      CompilerEndIf
      
      If StartDrawing(ImageOutput(*Item\DrawedImage))
         DrawingMode(#PB_2DDrawing_AllChannels)
         If *this\Attributes & #__MASK_MirroredTabs
            For Y = 0 To LastY
               For X = 0 To LastX
                  Plot(LastY-Y, X, Pixel(X, Y))
               Next
            Next
            
         Else
            For Y = 0 To LastY
               For X = 0 To LastX
                  Plot(Y, LastX-X, Pixel(X, Y))
               Next
            Next
         EndIf
         StopDrawing()
      EndIf
   Else
      *Item\DrawedImage = CopyImage(*Item\Image, #PB_Any)
   EndIf
   
EndProcedure



; (Er-)setz ein neues Icon fur die Karte
Procedure ReplaceImage(*this._s_widget, *Item._s_ROW, NewImageID.i=#Null) ; Code OK
   
   If *Item\Image
      FreeImage(*Item\Image)
      *Item\Image = #Null
   EndIf
   If *Item\DrawedImage
      FreeImage(*Item\DrawedImage)
      *Item\DrawedImage = #Null
   EndIf
   If NewImageID
      CompilerIf #PB_Compiler_Version >= 520
         *Item\Image = CreateImage(#PB_Any, includes\ImageSize, includes\ImageSize, 32, #PB_Image_Transparent)
      CompilerElse
         *Item\Image = CreateImage(#PB_Any, includes\ImageSize, includes\ImageSize, 32|#PB_Image_Transparent)
      CompilerEndIf
      StartDrawing(ImageOutput(*Item\Image))
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      DrawImage(NewImageID, 0, 0, includes\ImageSize, includes\ImageSize)
      StopDrawing()
      RotateImage(*this, *Item)
   EndIf
   
EndProcedure



; Berechnet das Layout einer Karte
Procedure ItemLayout(*this._s_widget, *Item._s_ROW)
   
   Protected TextAreaLength.i = *Item\Length - 2 * includes\PaddingX
   Protected NextSelected.i, PreviousSelected.i
   
   PushListPosition(*this\Item())
   If *Item\Selected
      ChangeCurrentElement(*this\Item(), *Item)
      If NextElement(*this\Item()) And *this\Item()\Selected
         NextSelected = #True
      EndIf
      ChangeCurrentElement(*this\Item(), *Item)
      If PreviousElement(*this\Item()) And *this\Item()\Selected
         PreviousSelected = #True
      EndIf
   EndIf
   PopListPosition(*this\Item())
   
   With includes
      
      If *Item\Attributes & #__MASK_CloseTab Or (*Item\Attributes & #__MASK_CloseSelectTab And *Item\Selected)
         TextAreaLength - (includes\CloseTabSize-4 + includes\ImageSpace)
      EndIf
      If *Item\Attributes & #__MASK_CheckBox
         TextAreaLength - (includes\CheckBoxSize + includes\ImageSpace)
      EndIf
      If *Item\Image
         If *this\Attributes & #__MASK_Vertical
            TextAreaLength - (ImageHeight(*Item\Image)+includes\ImageSpace)
         Else
            TextAreaLength - (ImageWidth(*Item\Image)+includes\ImageSpace)
         EndIf
      EndIf
      
      If *this\Attributes & #__MASK_Vertical
         *Item\Layout\Height = *Item\Length
         *Item\Layout\Width  = *this\TabSize + 1
         If *this\Attributes & #__MASK_MirroredTabs
            *Item\Layout\X      = *this\TabSize * *Item\Row; - 1
         Else
            *Item\Layout\X      = OutputWidth() - *this\TabSize * (*Item\Row+1)
         EndIf
         If *this\Attributes & #__MASK_ReverseOrdering XOr *this\Attributes & #__MASK_MirroredTabs
            *Item\Layout\Y    = *Item\Position
         Else
            *Item\Layout\Y    = OutputHeight() - *Item\Position - *Item\Length
         EndIf
         If *Item\Selected
            *Item\Layout\Width  + \Margin
            If *this\Attributes & #__MASK_MirroredTabs = 0
               *Item\Layout\X    - \Margin
            EndIf
         EndIf
         *Item\Layout\PaddingX = \PaddingY
         *Item\Layout\PaddingY = \PaddingX
         *Item\Layout\CrossX = *Item\Layout\X + (*Item\Layout\Width-\CloseTabSize)/2
         *Item\Layout\CheckX = *Item\Layout\X + (*Item\Layout\Width-\CheckBoxSize)/2
         If *this\Attributes & #__MASK_MirroredTabs
            *Item\Layout\TextX  = *Item\Layout\X + (*Item\Layout\Width+TextHeight("|"))/2
         Else
            *Item\Layout\TextX  = *Item\Layout\X + (*Item\Layout\Width-TextHeight("|"))/2
         EndIf
         If *this\Attributes & #__MASK_MirroredTabs XOr *this\Attributes & #__MASK_ReverseOrdering
            *Item\Layout\CrossY = *Item\Layout\Y + *Item\Layout\Height - (\CloseTabSize-3) - *Item\Layout\PaddingY
            *Item\Layout\TextY = *Item\Layout\Y + *Item\Layout\PaddingY + (TextAreaLength-TextWidth(*Item\ShortText)*\VerticalTextBugFix) * (*this\TabTextAlignment+1)/2
            If *Item\Image
               *Item\Layout\ImageX = *Item\Layout\X + (*Item\Layout\Width-ImageWidth(*Item\Image))/2
               *Item\Layout\ImageY = *Item\Layout\Y + *Item\Layout\PaddingY
               *Item\Layout\TextY + ImageHeight(*Item\Image) + \ImageSpace
            EndIf
            If *Item\Attributes & #__MASK_CheckBox
               *Item\Layout\TextY + \CheckBoxSize + \ImageSpace
            EndIf
            *Item\Layout\CheckY = *Item\Layout\TextY-\CheckBoxSize-\ImageSpace ;-hier
            If *this\Attributes & #__MASK_ReverseOrdering : *Item\Layout\TextY + TextWidth(*Item\ShortText)*\VerticalTextBugFix : EndIf
         Else
            *Item\Layout\CrossY = *Item\Layout\Y + (-3) + *Item\Layout\PaddingY
            *Item\Layout\TextY = *Item\Layout\Y + *Item\Layout\Height - *Item\Layout\PaddingY - (TextAreaLength-TextWidth(*Item\ShortText)*\VerticalTextBugFix) * (*this\TabTextAlignment+1)/2
            If *Item\Image
               *Item\Layout\ImageX = *Item\Layout\X + (*Item\Layout\Width-ImageWidth(*Item\Image))/2
               *Item\Layout\ImageY = *Item\Layout\Y + *Item\Layout\Height-ImageHeight(*Item\Image) - *Item\Layout\PaddingY
               *Item\Layout\TextY - ImageHeight(*Item\Image) - \ImageSpace
            EndIf
            If *Item\Attributes & #__MASK_CheckBox
               *Item\Layout\TextY - \CheckBoxSize - \ImageSpace
            EndIf
            *Item\Layout\CheckY = *Item\Layout\TextY+\ImageSpace
            If *this\Attributes & #__MASK_ReverseOrdering : *Item\Layout\TextY - TextWidth(*Item\ShortText)*\VerticalTextBugFix : EndIf
         EndIf
         If *Item\Selected
            If *this\Attributes & #__MASK_MirroredTabs XOr *this\Attributes & #__MASK_ReverseOrdering
               If PreviousSelected = #False 
                  *Item\Layout\Y - \Margin/2
                  *Item\Layout\Height + \Margin/2
               EndIf
               If NextSelected = #False 
                  *Item\Layout\Height + \Margin/2
               EndIf
            Else
               If NextSelected = #False 
                  *Item\Layout\Y - \Margin/2
                  *Item\Layout\Height + \Margin/2
               EndIf
               If PreviousSelected = #False 
                  *Item\Layout\Height + \Margin/2
               EndIf
            EndIf
         EndIf
      Else
         *Item\Layout\Width  = *Item\Length
         *Item\Layout\Height = *this\TabSize + 1
         If *this\Attributes & #__MASK_ReverseOrdering
            *Item\Layout\X      = OutputWidth() - *Item\Position - *Item\Length
         Else
            *Item\Layout\X      = *Item\Position
         EndIf
         If *this\Attributes & #__MASK_MirroredTabs
            *Item\Layout\Y      = *this\TabSize * *Item\Row; - 1
         Else
            *Item\Layout\Y      = OutputHeight() - *this\TabSize * (*Item\Row+1)
         EndIf
         If *Item\Selected
            *Item\Layout\Height + \Margin
            If *this\Attributes & #__MASK_MirroredTabs = 0
               *Item\Layout\Y    - \Margin
            EndIf
         EndIf
         *Item\Layout\PaddingX = \PaddingX
         *Item\Layout\PaddingY = \PaddingY
         *Item\Layout\CrossY = *Item\Layout\Y + (*Item\Layout\Height-\CloseTabSize)/2
         *Item\Layout\CheckY = *Item\Layout\Y + (*Item\Layout\Height-\CheckBoxSize)/2
         *Item\Layout\TextY  = *Item\Layout\Y + (*Item\Layout\Height-TextHeight("|"))/2
         If *this\Attributes & #__MASK_ReverseOrdering
            *Item\Layout\CrossX = *Item\Layout\X + (-3) + *Item\Layout\PaddingX
            *Item\Layout\TextX = *Item\Layout\X + *Item\Layout\Width-TextWidth(*Item\ShortText) - *Item\Layout\PaddingX - (TextAreaLength-TextWidth(*Item\ShortText)) * (*this\TabTextAlignment+1)/2
            If *Item\Image
               *Item\Layout\ImageX = *Item\Layout\X + *Item\Layout\Width-ImageWidth(*Item\Image) - *Item\Layout\PaddingX
               *Item\Layout\ImageY = *Item\Layout\Y + (*Item\Layout\Height-ImageHeight(*Item\Image))/2
               *Item\Layout\TextX - ImageWidth(*Item\Image) - \ImageSpace
            EndIf
            If *Item\Attributes & #__MASK_CheckBox
               *Item\Layout\TextX - \CheckBoxSize - \ImageSpace
            EndIf
            *Item\Layout\CheckX = *Item\Layout\TextX + TextWidth(*Item\ShortText) + \ImageSpace
         Else
            *Item\Layout\CrossX = *Item\Layout\X + *Item\Layout\Width - (\CloseTabSize-3) - *Item\Layout\PaddingX
            *Item\Layout\TextX = *Item\Layout\X + *Item\Layout\PaddingX + (TextAreaLength-TextWidth(*Item\ShortText)) * (*this\TabTextAlignment+1)/2
            If *Item\Image
               *Item\Layout\ImageX = *Item\Layout\X + *Item\Layout\PaddingX
               *Item\Layout\ImageY = *Item\Layout\Y + (*Item\Layout\Height-ImageHeight(*Item\Image))/2
               *Item\Layout\TextX + ImageWidth(*Item\Image) + \ImageSpace
            EndIf
            If *Item\Attributes & #__MASK_CheckBox
               *Item\Layout\TextX + \CheckBoxSize + \ImageSpace
            EndIf
            *Item\Layout\CheckX = *Item\Layout\TextX - \CheckBoxSize - \ImageSpace
         EndIf
         If *Item\Selected
            If *this\Attributes & #__MASK_ReverseOrdering
               If NextSelected = #False 
                  *Item\Layout\X - \Margin/2
                  *Item\Layout\Width + \Margin/2
               EndIf
               If PreviousSelected = #False 
                  *Item\Layout\Width + \Margin/2
               EndIf
            Else
               If PreviousSelected = #False 
                  *Item\Layout\X - \Margin/2
                  *Item\Layout\Width + \Margin/2
               EndIf
               If NextSelected = #False 
                  *Item\Layout\Width + \Margin/2
               EndIf
            EndIf
         EndIf
      EndIf
      
   EndWith
   
EndProcedure



; Berechnet das Layout
Procedure Layout(*this._s_widget)
   
   Protected Shift.i
   
   With includes
      
      If *this\Attributes & #__MASK_MirroredTabs
         Shift = -includes\Margin
      Else
         Shift = includes\Margin
      EndIf
      
      If *this\Attributes & #__MASK_Vertical
         *this\Layout\ButtonHeight = \ArrowWidth
         *this\Layout\ButtonWidth  = \ArrowHeight
         *this\Layout\ButtonSize   = \ArrowHeight
         If *this\Attributes & #__MASK_MirroredTabs XOr *this\Attributes & #__MASK_ReverseOrdering
            If *this\Attributes & #__MASK_PopupButton
               *this\Layout\PopupButtonX = (OutputWidth()+Shift) / 2
               *this\Layout\PopupButtonY = OutputHeight() - *this\Layout\ButtonSize / 2
            EndIf
            If *this\Attributes & #__MASK_PreviousArrow
               *this\Layout\PreviousButtonX = (OutputWidth()+Shift) / 2
               *this\Layout\PreviousButtonY = *this\Layout\ButtonHeight / 2
            EndIf
            If *this\Attributes & #__MASK_NextArrow
               *this\Layout\NextButtonX = (OutputWidth()+Shift) / 2
               *this\Layout\NextButtonY = OutputHeight() - *this\Layout\ButtonHeight / 2
               If *this\Attributes & #__MASK_NewTab
                  *this\Layout\NextButtonY - *this\NewTabItem\Length-includes\Margin
               EndIf
               If *this\Attributes & #__MASK_PopupButton
                  *this\Layout\NextButtonY - *this\Layout\ButtonSize
               EndIf
            EndIf
         Else
            If *this\Attributes & #__MASK_PopupButton
               *this\Layout\PopupButtonX = (OutputWidth()+Shift) / 2
               *this\Layout\PopupButtonY = *this\Layout\ButtonSize / 2
            EndIf
            If *this\Attributes & #__MASK_PreviousArrow
               *this\Layout\PreviousButtonX = (OutputWidth()+Shift) / 2
               *this\Layout\PreviousButtonY = OutputHeight() - *this\Layout\ButtonHeight / 2
            EndIf
            If *this\Attributes & #__MASK_NextArrow
               *this\Layout\NextButtonX = (OutputWidth()+Shift) / 2
               *this\Layout\NextButtonY = *this\Layout\ButtonHeight / 2
               If *this\Attributes & #__MASK_NewTab
                  *this\Layout\NextButtonY + *this\NewTabItem\Length+includes\Margin
               EndIf
               If *this\Attributes & #__MASK_PopupButton
                  *this\Layout\NextButtonY + *this\Layout\ButtonSize
               EndIf
            EndIf
         EndIf
      Else
         *this\Layout\ButtonHeight = \ArrowHeight
         *this\Layout\ButtonWidth  = \ArrowWidth
         *this\Layout\ButtonSize   = \ArrowHeight
         If *this\Attributes & #__MASK_ReverseOrdering
            If *this\Attributes & #__MASK_PopupButton
               *this\Layout\PopupButtonX = *this\Layout\ButtonSize / 2
               *this\Layout\PopupButtonY = (OutputHeight()+Shift) / 2
            EndIf
            If *this\Attributes & #__MASK_PreviousArrow
               *this\Layout\PreviousButtonX = OutputWidth() - *this\Layout\ButtonWidth / 2
               *this\Layout\PreviousButtonY = (OutputHeight()+Shift) / 2
            EndIf
            If *this\Attributes & #__MASK_NextArrow
               *this\Layout\NextButtonX = *this\Layout\ButtonWidth / 2
               *this\Layout\NextButtonY = (OutputHeight()+Shift) / 2
               If *this\Attributes & #__MASK_NewTab
                  *this\Layout\NextButtonX + *this\NewTabItem\Length+includes\Margin
               EndIf
               If *this\Attributes & #__MASK_PopupButton
                  *this\Layout\NextButtonX + *this\Layout\ButtonSize
               EndIf
            EndIf
         Else
            If *this\Attributes & #__MASK_PopupButton
               *this\Layout\PopupButtonX = OutputWidth() - *this\Layout\ButtonSize / 2
               *this\Layout\PopupButtonY = (OutputHeight()+Shift) / 2
            EndIf
            If *this\Attributes & #__MASK_PreviousArrow
               *this\Layout\PreviousButtonX = *this\Layout\ButtonWidth / 2
               *this\Layout\PreviousButtonY = (OutputHeight()+Shift) / 2
            EndIf
            If *this\Attributes & #__MASK_NextArrow
               *this\Layout\NextButtonX = OutputWidth() - *this\Layout\ButtonWidth / 2
               *this\Layout\NextButtonY = (OutputHeight()+Shift) / 2
               If *this\Attributes & #__MASK_NewTab
                  *this\Layout\NextButtonX - *this\NewTabItem\Length-includes\Margin
               EndIf
               If *this\Attributes & #__MASK_PopupButton
                  *this\Layout\NextButtonX - *this\Layout\ButtonSize
               EndIf
            EndIf
         EndIf
         
      EndIf
      
   EndWith
   
EndProcedure



; Zeichnet eine Karte
Procedure DrawItem(*this._s_widget, *Item._s_ROW)
   
   Protected X.i, Y.i, LayoutX.i, LayoutY.i, LayoutWidth.i, LayoutHeight.i, Padding.i
   Protected Color.i, Width.i, Height.i, Text.s, Len.i, Angle.i
   
   With includes
      
      ; Orientierung der Registerkarte
      If *this\Attributes & #__MASK_Vertical
         If *this\Attributes & #__MASK_MirroredTabs
            LayoutX = -*this\Radius-1
         EndIf
         LayoutWidth = *this\Radius
      Else
         If *this\Attributes & #__MASK_MirroredTabs
            LayoutY = -*this\Radius-1
         EndIf
         LayoutHeight = *this\Radius
      EndIf
      
      ; Aussehen
      ResetGradientColors()
      If *this\Attributes & #__MASK_Vertical
         If *this\Attributes & #__MASK_MirroredTabs
            LinearGradient(*Item\Layout\X+*Item\Layout\Width-1, 0, *Item\Layout\X, 0)
         Else
            LinearGradient(*Item\Layout\X, 0, *Item\Layout\X+*Item\Layout\Width-1, 0)
         EndIf
      Else
         If #False ;*this\Attributes & #__MASK_MirroredTabs
            LinearGradient(0, *Item\Layout\Y+*Item\Layout\Height-1, 0, *Item\Layout\Y)
         Else
            LinearGradient(0, *Item\Layout\Y, 0, *Item\Layout\Y+*Item\Layout\Height-1)
         EndIf
      EndIf
      
      Select *Item\color\state
         Case #__s_Move
            Color = ColorPlus(*Item\color\back, \ActivColorPlus)
            GradientColor(0.0, ColorPlus(Color, $FF101010)&$FFFFFF|$C0<<24)
            GradientColor(0.5, Color&$FFFFFF|$C0<<24)
            GradientColor(1.0, ColorMinus(Color, $FF101010)&$FFFFFF|$C0<<24)
            
         Case #__s_Disable
            GradientColor(0.0, ColorPlus(*Item\color\back, $FF202020)&$FFFFFF|$80<<24)
            GradientColor(0.5, *Item\color\back&$FFFFFF|$80<<24)
            GradientColor(0.6, ColorMinus(*Item\color\back, $FF101010)&$FFFFFF|$80<<24)
            GradientColor(1.0, ColorMinus(*Item\color\back, $FF303030)&$FFFFFF|$80<<24)
            
         Case #__s_Normal
            GradientColor(0.0, ColorPlus(*Item\color\back, $FF202020))
            GradientColor(0.5, *Item\color\back)
            GradientColor(0.6, ColorMinus(*Item\color\back, $FF101010))
            GradientColor(1.0, ColorMinus(*Item\color\back, $FF303030))
            
         Case #__s_Hover
            Color = ColorPlus(*Item\color\back, \HoverColorPlus)
            GradientColor(0.0, ColorPlus(Color, $FF202020))
            GradientColor(0.5, Color)
            GradientColor(0.6, ColorMinus(Color, $FF101010))
            GradientColor(1.0, ColorMinus(Color, $FF303030))
            
         Case #__s_Selected
            Color = ColorPlus(*Item\color\back, \ActivColorPlus)
            GradientColor(0.0, ColorPlus(Color, $FF101010))
            GradientColor(0.5, Color)
            GradientColor(1.0, ColorMinus(Color, $FF101010))
      EndSelect
      
      ; 		; andere ausgewahlte Nachbarn
      ; 		If *Item <> *this\NewTabItem And *Item\Selected
      ; 			PushListPosition(*this\Item())
      ; 			ChangeCurrentElement(*this\Item(), *Item)
      ; 			If NextElement(*this\Item()) And *this\Item()\Selected
      ; 				LayoutWidth - \Margin/2
      ; 			EndIf
      ; 			ChangeCurrentElement(*this\Item(), *Item)
      ; 			If PreviousElement(*this\Item()) And *this\Item()\Selected
      ; 				LayoutX     + \Margin/2
      ; 				LayoutWidth - \Margin/2
      ; 			EndIf
      ; 			PopListPosition(*this\Item())
      ; 		EndIf
      
      ; Registerkarte zeichnen
      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Gradient)
      RoundBox(*Item\Layout\X+LayoutX, *Item\Layout\Y+LayoutY, *Item\Layout\Width+LayoutWidth, *Item\Layout\Height+LayoutHeight, *this\Radius, *this\Radius)
      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Outlined)
      If *Item\Disabled
         RoundBox(*Item\Layout\X+LayoutX, *Item\Layout\Y+LayoutY, *Item\Layout\Width+LayoutWidth, *Item\Layout\Height+LayoutHeight, *this\Radius, *this\Radius, \color\frame&$FFFFFF|$80<<24)
      Else
         RoundBox(*Item\Layout\X+LayoutX, *Item\Layout\Y+LayoutY, *Item\Layout\Width+LayoutWidth, *Item\Layout\Height+LayoutHeight, *this\Radius, *this\Radius, \color\frame)
      EndIf
      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
      
      If *this\Attributes & #__MASK_Vertical
         Angle = 90 + 180*Bool(*this\Attributes&#__MASK_MirroredTabs)
         If *Item\Image
            If *Item\DrawedImage = #Null
               *Item\DrawedImage = RotateImage(*Item\Image, Angle)
            EndIf
            If *Item\Disabled
               DrawAlphaImage(ImageID(*Item\DrawedImage), *Item\Layout\ImageX, *Item\Layout\ImageY, $40)
            Else
               DrawAlphaImage(ImageID(*Item\DrawedImage), *Item\Layout\ImageX, *Item\Layout\ImageY, $FF)
            EndIf
         EndIf
         If *Item\Disabled
            DrawRotatedText(*Item\Layout\TextX, *Item\Layout\TextY, *Item\ShortText, Angle, *Item\color\front&$FFFFFF|$40<<24)
         Else
            DrawRotatedText(*Item\Layout\TextX, *Item\Layout\TextY, *Item\ShortText, Angle, *Item\color\front)
         EndIf
      Else
         If *Item\Image
            If *Item\Disabled
               DrawAlphaImage(ImageID(*Item\Image), *Item\Layout\ImageX, *Item\Layout\ImageY, $40)
            Else
               DrawAlphaImage(ImageID(*Item\Image), *Item\Layout\ImageX, *Item\Layout\ImageY, $FF)
            EndIf
         EndIf
         If *Item\Disabled
            DrawText(*Item\Layout\TextX, *Item\Layout\TextY, *Item\ShortText, *Item\color\front&$FFFFFF|$40<<24)
         Else
            DrawText(*Item\Layout\TextX, *Item\Layout\TextY, *Item\ShortText, *Item\color\front)
            If *this\Editor\Item = *Item
               DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_XOr)
               If *this\Editor\Selection < 0
                  LayoutX = TextWidth(Left(*Item\Text, *this\Editor\Cursor+*this\Editor\Selection))-1
                  LayoutWidth = TextWidth(Left(*Item\Text, *this\Editor\Cursor)) - LayoutX
                  Box(*Item\Layout\TextX+LayoutX, *Item\Layout\TextY, LayoutWidth, TextHeight("|"))
               Else
                  LayoutX = TextWidth(Left(*Item\Text, *this\Editor\Cursor))-1
                  LayoutWidth = TextWidth(Left(*Item\Text, *this\Editor\Cursor+*this\Editor\Selection)) - LayoutX
                  Box(*Item\Layout\TextX+LayoutX, *Item\Layout\TextY, LayoutWidth, TextHeight("|"))
               EndIf
               DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Transparent)
            EndIf
         EndIf
      EndIf
      
      ; CheckBox
      If *Item\Attributes & #__MASK_CheckBox
         DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Outlined)
         If *this\HoverItem = *Item And *this\HoverCheck
            RoundBox(*Item\Layout\CheckX, *Item\Layout\CheckY, \CheckBoxSize, \CheckBoxSize, 2, 2, *Item\color\front)
         ElseIf *Item\Disabled
            RoundBox(*Item\Layout\CheckX, *Item\Layout\CheckY, \CheckBoxSize, \CheckBoxSize, 2, 2, \color\frame&$FFFFFF|$40<<24)
         Else
            RoundBox(*Item\Layout\CheckX, *Item\Layout\CheckY, \CheckBoxSize, \CheckBoxSize, 2, 2, \color\frame)
         EndIf
         If *Item\Checked
            DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Gradient)
            LinearGradient(*Item\Layout\CheckX+2, *Item\Layout\CheckY+2, *Item\Layout\CheckX+\CheckBoxSize-2, *Item\Layout\CheckY+\CheckBoxSize-2)
            ResetGradientColors()
            If *Item\Disabled
               GradientColor(0, *Item\color\front&$FFFFFF|$20000000)
               GradientColor(0.5, *Item\color\front&$FFFFFF|$30000000)
               GradientColor(1, *Item\color\front&$FFFFFF|$20000000)
            Else
               GradientColor(0, *Item\color\front&$FFFFFF|$80000000)
               GradientColor(0.5, *Item\color\front&$FFFFFF|$C0000000)
               GradientColor(1, *Item\color\front&$FFFFFF|$80000000)
            EndIf
            Box(*Item\Layout\CheckX+2, *Item\Layout\CheckY+2, \CheckBoxSize-4, \CheckBoxSize-4)
         EndIf
         DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Transparent)
      EndIf
      
      ; Schlie?en-Schaltflache
      If *Item\Attributes & #__MASK_CloseTab Or (*Item\Attributes & #__MASK_CloseSelectTab And *Item\Selected)
         If *this\HoverItem = *Item And *this\HoverClose
            If *this\LockedClose And *this\LockedItem = *Item
               DrawButton(*Item\Layout\CrossX, *Item\Layout\CrossY, \CloseTabSize, \CloseTabSize, -1, *Item\color\back, *this\Attributes & #__MASK_Vertical)
            Else
               DrawButton(*Item\Layout\CrossX, *Item\Layout\CrossY, \CloseTabSize, \CloseTabSize, 1, *Item\color\back, *this\Attributes & #__MASK_Vertical)
            EndIf
         EndIf
         If *Item\Disabled
            DrawCross(*Item\Layout\CrossX+3, *Item\Layout\CrossY+3, \CloseTabSize-6, *Item\color\front&$FFFFFF|$40<<24)
         Else
            DrawCross(*Item\Layout\CrossX+3, *Item\Layout\CrossY+3, \CloseTabSize-6, *Item\color\front)
         EndIf
      EndIf
      
   EndWith
   
EndProcedure



; Verwaltet die Ereignisse beim Editieren einer Karte
Procedure Examine_Editor(*this._s_widget)
   
   Protected MinDistance.i, Distance.i, Index.i
   
   With *this
      
      If \Editor\Item
         
         If MouseIn(*this, \Editor\Item\Layout\X, \Editor\Item\Layout\Y,  \Editor\Item\Layout\Width, \Editor\Item\Layout\Height)
            SetGadgetAttribute(\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_IBeam)
         Else
            SetGadgetAttribute(\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
         EndIf
         
         Select EventType()
            Case #PB_EventType_LeftDoubleClick
               If \Editor\Item = \HoverItem
                  \Editor\Cursor = 0
                  \Editor\Selection = Len(\Editor\Item\Text)
                  \Editor\Selectable = #False
               EndIf
            Case #PB_EventType_LeftButtonDown
               If \Editor\Item = \HoverItem
                  \Editor\Cursor = 0
                  \Editor\Selection = 0
                  \Editor\Selectable = #True
                  MinDistance = $FFFF
                  For Index = Len(\Editor\Item\Text) To 0 Step -1
                     Distance = Abs(\Editor\Item\Layout\TextX+TextWidth(Left(\Editor\Item\Text, Index))-\MouseX)
                     If Distance < MinDistance
                        \Editor\Cursor = Index
                        MinDistance = Distance
                     EndIf
                  Next
               Else
                  If \Editor\OldText <> \Editor\Item\Text
                     ChangeCurrentElement(\Item(), \Editor\Item)
                     PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #__EVENT_EditItem, ListIndex(\Item()))
                  EndIf
                  \Editor\Item = #Null
                  ProcedureReturn #Null
               EndIf
            Case #PB_EventType_MouseMove
               If \Editor\Item = \HoverItem And \Editor\Selectable
                  \Editor\Selection = 0
                  MinDistance = $FFFF
                  For Index = Len(\Editor\Item\Text) To 0 Step -1
                     Distance = Abs(\Editor\Item\Layout\TextX+TextWidth(Left(\Editor\Item\Text, Index))-\MouseX)
                     If Distance < MinDistance
                        \Editor\Selection = Index-\Editor\Cursor
                        MinDistance = Distance
                     EndIf
                  Next
               EndIf
            Case #PB_EventType_LeftButtonUp
               \Editor\Selectable = #False
            Case #PB_EventType_Input
               If \Editor\Selection > 0
                  \Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor) + Mid(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection+1)
                  \Editor\Selection = 0
               ElseIf \Editor\Selection < 0
                  \Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection) + Mid(\Editor\Item\Text, \Editor\Cursor+1)
                  \Editor\Cursor + \Editor\Selection
                  \Editor\Selection = 0
               EndIf
               \Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor) + Chr(GetGadgetAttribute(\canvas\gadget, #PB_Canvas_Input)) + Mid(\Editor\Item\Text, \Editor\Cursor+1)
               \Editor\Item\ShortText = \Editor\Item\Text
               \Editor\Cursor + 1
            Case #PB_EventType_KeyDown
               Select GetGadgetAttribute(\canvas\gadget, #PB_Canvas_Key)
                  Case #PB_Shortcut_Return
                     If \Editor\OldText <> \Editor\Item\Text
                        ChangeCurrentElement(\Item(), \Editor\Item)
                        PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #__EVENT_EditItem, ListIndex(\Item()))
                     EndIf
                     \Editor\Item = #Null
                     ProcedureReturn #Null
                  Case #PB_Shortcut_Escape
                     \Editor\Item\Text = \Editor\OldText
                     \Editor\Item\ShortText = \Editor\Item\Text
                     \Editor\Item = #Null
                     ProcedureReturn #Null
                  Case #PB_Shortcut_Left
                     If GetGadgetAttribute(\canvas\gadget, #PB_Canvas_Modifiers) & #PB_Canvas_Shift
                        If \Editor\Cursor+\Editor\Selection > 0
                           \Editor\Selection - 1
                        EndIf
                     Else
                        \Editor\Selection = 0
                        If \Editor\Cursor > 0
                           \Editor\Cursor - 1
                        EndIf
                     EndIf
                  Case #PB_Shortcut_Right
                     If GetGadgetAttribute(\canvas\gadget, #PB_Canvas_Modifiers) & #PB_Canvas_Shift
                        If \Editor\Cursor+\Editor\Selection < Len(\Editor\Item\Text)
                           \Editor\Selection + 1
                        EndIf
                     Else
                        \Editor\Selection = 0
                        If \Editor\Cursor < Len(\Editor\Item\Text)
                           \Editor\Cursor + 1
                        EndIf
                     EndIf
                  Case #PB_Shortcut_Home
                     \Editor\Cursor = 0
                  Case #PB_Shortcut_End
                     \Editor\Cursor = Len(\Editor\Item\Text)
                  Case #PB_Shortcut_Back
                     If \Editor\Selection > 0
                        \Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor) + Mid(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection+1)
                        \Editor\Selection = 0
                     ElseIf \Editor\Selection < 0
                        \Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection) + Mid(\Editor\Item\Text, \Editor\Cursor+1)
                        \Editor\Cursor + \Editor\Selection
                        \Editor\Selection = 0
                     ElseIf \Editor\Cursor > 0
                        \Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor-1) + Mid(\Editor\Item\Text, \Editor\Cursor+1)
                        \Editor\Cursor - 1
                     EndIf
                  Case #PB_Shortcut_Delete
                     If \Editor\Selection > 0
                        \Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor) + Mid(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection+1)
                        \Editor\Selection = 0
                     ElseIf \Editor\Selection < 0
                        \Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection) + Mid(\Editor\Item\Text, \Editor\Cursor+1)
                        \Editor\Cursor + \Editor\Selection
                        \Editor\Selection = 0
                     ElseIf \Editor\Cursor < Len(\Editor\Item\Text)
                        \Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor) + Mid(\Editor\Item\Text, \Editor\Cursor+2)
                     EndIf
                  Case #PB_Shortcut_C
                     If GetGadgetAttribute(\canvas\gadget, #PB_Canvas_Modifiers) & #PB_Canvas_Control
                        If \Editor\Selection > 0
                           SetClipboardText(Mid(\Editor\Item\Text, \Editor\Cursor+1, \Editor\Selection))
                        ElseIf \Editor\Selection < 0
                           SetClipboardText(Mid(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection+1, -\Editor\Selection))
                        EndIf
                     EndIf
                  Case #PB_Shortcut_V
                     If GetGadgetAttribute(\canvas\gadget, #PB_Canvas_Modifiers) & #PB_Canvas_Control
                        If \Editor\Selection > 0
                           \Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor) + Mid(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection+1)
                           \Editor\Selection = 0
                        ElseIf \Editor\Selection < 0
                           \Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor+\Editor\Selection) + Mid(\Editor\Item\Text, \Editor\Cursor+1)
                           \Editor\Cursor + \Editor\Selection
                           \Editor\Selection = 0
                        EndIf
                        \Editor\Item\Text = Left(\Editor\Item\Text, \Editor\Cursor) + GetClipboardText() + Mid(\Editor\Item\Text, \Editor\Cursor+1)
                        \Editor\Item\ShortText = \Editor\Item\Text
                        \Editor\Cursor + Len(GetClipboardText())
                     EndIf
               EndSelect
               \Editor\Item\ShortText = \Editor\Item\Text
            Case #PB_EventType_LostFocus
               If \Editor\OldText <> \Editor\Item\Text
                  ChangeCurrentElement(\Item(), \Editor\Item)
                  PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #__EVENT_EditItem, ListIndex(\Item()))
               EndIf
               \Editor\Item = #Null
         EndSelect
         
      Else
         
         SetGadgetAttribute(\canvas\gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
         
      EndIf
      
   EndWith
   
EndProcedure



; Ermittelt das Aussehen und die Lage der Tabs
Procedure Examine(*this._s_widget)
   
   Protected MinLength.i, X.i, Y.i, Shift.i, MousePosition.i, Row.i
   Protected Index.i, Distance.i, MinDistance.i
   
   With *this
      
      ; Initialisierung
      \ToolTip\Current = #Null
      \MouseX      = GetGadgetAttribute(\canvas\gadget, #PB_Canvas_MouseX)
      \MouseY      = GetGadgetAttribute(\canvas\gadget, #PB_Canvas_MouseY)
      \Event       = #Null
      \EventTab    = #__tab_item_None
      \HoverItem   = #Null
      \HoverClose  = #False
      \HoverCheck  = #False
      \HoverArrow  = #Null
      DrawingFont(\FontID)
      
      ; Hover bei Registerkarten
      If \MoveItem = #Null
         
         ForEach \Item()
            If \Item()\Visible And MouseIn(*this, \Item()\Layout\X, \Item()\Layout\Y,  \Item()\Layout\Width-1, \Item()\Layout\Height-1)
               \HoverItem = \Item()
            EndIf
         Next
         If \Attributes & #__MASK_NewTab And MouseIn(*this, \NewTabItem\Layout\X, \NewTabItem\Layout\Y, \NewTabItem\Layout\Width-1, \NewTabItem\Layout\Height-1)
            \HoverItem = \NewTabItem
         EndIf
         
      EndIf
      
      ; Navigation
      If \Attributes & (#__MASK_PreviousArrow|#__MASK_NextArrow)
         
         If EventType() = #PB_EventType_MouseWheel
            \Shift + includes\WheelDirection * GetGadgetAttribute(\canvas\gadget, #PB_Canvas_WheelDelta)
            If \Shift < 0
               \Shift = 0
            ElseIf \Shift > \LastShift
               \Shift = \LastShift
            EndIf
         EndIf
         
         LockMutex(includes\Timer\Mutex)
         includes\Timer\Type = #Null
         If \Attributes & #__MASK_PreviousArrow
            If MouseIn(*this, \Layout\PreviousButtonX-\Layout\ButtonWidth/2, \Layout\PreviousButtonY-\Layout\ButtonHeight/2, \Layout\ButtonWidth, \Layout\ButtonHeight)
               \HoverArrow = #__MASK_PreviousArrow
               \HoverItem = #Null
               includes\Timer\Type = #__MASK_PreviousArrow
               Select EventType()
                  Case #PB_EventType_LeftButtonDown
                     \LockedArrow = #__MASK_PreviousArrow
                     includes\Timer\widget = *this
                  Case #PB_EventType_LeftButtonUp
                     If \LockedArrow = \HoverArrow And \Shift > 0
                        \Shift - 1
                     EndIf
               EndSelect
            EndIf
         EndIf
         If \Attributes & #__MASK_NextArrow
            If MouseIn(*this, \Layout\NextButtonX-\Layout\ButtonWidth/2, \Layout\NextButtonY-\Layout\ButtonHeight/2, \Layout\ButtonWidth, \Layout\ButtonHeight)
               \HoverArrow = #__MASK_NextArrow
               \HoverItem = #Null
               includes\Timer\Type = #__MASK_NextArrow
               Select EventType()
                  Case #PB_EventType_LeftButtonDown
                     \LockedArrow = #__MASK_NextArrow
                     includes\Timer\widget = *this
                  Case #PB_EventType_LeftButtonUp
                     If \LockedArrow = \HoverArrow And \Shift < \LastShift
                        \Shift + 1
                     EndIf
               EndSelect
            EndIf
         EndIf
         UnlockMutex(includes\Timer\Mutex)
         
      EndIf
      
      ; Popup-Button
      If \Attributes & #__MASK_PopupButton
         If MouseIn(*this, \Layout\PopupButtonX-\Layout\ButtonSize/2, \Layout\PopupButtonY-\Layout\ButtonSize/2, \Layout\ButtonSize, \Layout\ButtonSize)
            \HoverArrow = #__MASK_PopupButton
            \HoverItem = #Null
            Select EventType()
               Case #PB_EventType_LeftButtonDown
                  \LockedArrow = #__MASK_PopupButton
               Case #PB_EventType_LeftButtonUp
                  If \LockedArrow = \HoverArrow 
                     PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #__EVENT_PopupButton, -1)
                  EndIf
            EndSelect
         EndIf
      EndIf
      
      ; Registerkarten
      If \HoverItem
         
         ; Tooltip aktualisieren & Schlie?enbutton & Checkbox
         If \HoverItem\ToolTip
            \ToolTip\Current = @\HoverItem\ToolTip
         Else
            \ToolTip\Current = @\HoverItem\Text
         EndIf
         If ( \HoverItem\Attributes & #__MASK_CloseTab Or (\HoverItem\Attributes & #__MASK_CloseSelectTab And \HoverItem\Selected) ) And \Editor\Item <> \HoverItem
            If MouseIn(*this, \HoverItem\Layout\CrossX, \HoverItem\Layout\CrossY, includes\CloseTabSize, includes\CloseTabSize)
               \HoverClose = \HoverItem
               \ToolTip\Current = @\ToolTip\CloseText
               Select EventType()
                  Case #PB_EventType_LeftButtonDown
                     \LockedClose = \HoverItem
                  Case #PB_EventType_LeftButtonUp
                     If \LockedClose = \HoverClose
                        ChangeCurrentElement(\Item(), \LockedClose)
                        \EventTab = ListIndex(\Item())
                        PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #__EVENT_ItemClose, \EventTab)
                     EndIf
               EndSelect
            EndIf
         EndIf
         If \HoverItem\Attributes & #__MASK_CheckBox And \HoverItem\Disabled = #False And \Editor\Item <> \HoverItem
            If MouseIn(*this, \HoverItem\Layout\CheckX, \HoverItem\Layout\CheckY, includes\CheckBoxSize, includes\CheckBoxSize)
               \HoverCheck = \HoverItem
               Select EventType()
                  Case #PB_EventType_LeftButtonDown
                     \LockedCheck = \HoverItem
                  Case #PB_EventType_LeftButtonUp
                     If \LockedCheck = \HoverCheck
                        ChangeCurrentElement(\Item(), \LockedCheck)
                        \EventTab = ListIndex(\Item())
                        PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #__EVENT_CheckBox, \EventTab)
                        \HoverItem\Checked = 1 - \HoverItem\Checked
                     EndIf
               EndSelect
            EndIf
         EndIf
         
         ; Ereignisverwaltung
         If \HoverItem = \NewTabItem
            \EventTab = #__tab_item_NewTab
            \ToolTip\Current = @\ToolTip\NewText
         Else
            ChangeCurrentElement(\Item(), \HoverItem)
            \EventTab = ListIndex(\Item())
         EndIf
         Select EventType()
            Case #PB_EventType_LeftButtonDown
               \LockedItem = \HoverItem
               If \LockedItem = \NewTabItem 
                  PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #__EVENT_NewItem, \EventTab)
               ElseIf \LockedClose = #False And \LockedCheck = #False
                  If \HoverItem\Disabled = #False
                     If \Attributes & #__MASK_MultiSelect And GetGadgetAttribute(\canvas\gadget, #PB_Canvas_Modifiers) & #PB_Canvas_Control
                        If \HoverItem\Selected 
                           UnselectItem(*this, \HoverItem)
                        Else
                           SelectItem(*this, \HoverItem)
                        EndIf
                        PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #__EVENT_Change, \EventTab)
                     Else
                        ForEach \Item()
                           \Item()\Selected = #False
                        Next 
                        If \SelectedItem <> \HoverItem
                           PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #__EVENT_Change, \EventTab)
                        EndIf
                        SelectItem(*this, \HoverItem)
                     EndIf
                  EndIf
                  If Not \Attributes & #__MASK_NoTabMoving And \Editor\Item = #Null
                     \ReadyToMoveItem = \HoverItem
                     \SaveMouseX = \MouseX
                     \SaveMouseY = \MouseY
                  EndIf
               EndIf
            Case #PB_EventType_MiddleButtonDown
               \LockedItem = \HoverItem
            Case #PB_EventType_MiddleButtonUp
               If includes\EnableMiddleClickForCloseTab And \LockedItem = \HoverItem And \LockedItem <> \NewTabItem And \LockedItem <> \Editor\Item
                  PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #__EVENT_ItemClose, \EventTab)
                  \MoveItem        = #Null
                  \ReadyToMoveItem = #Null
               EndIf
               \LockedItem = #Null
            Case #PB_EventType_MouseMove
               If \ReadyToMoveItem
                  If Abs(\SaveMouseX-\MouseX) > 4 Or Abs(\SaveMouseY-\MouseY) > 4
                     \MoveItem = \ReadyToMoveItem
                     If \Attributes & (#__MASK_NextArrow|#__MASK_PreviousArrow)
                        LockMutex(includes\Timer\Mutex)
                        includes\Timer\widget = *this
                        UnlockMutex(includes\Timer\Mutex)
                     EndIf
                  EndIf
               EndIf
            Case #PB_EventType_LeftDoubleClick
               If \Attributes & #__MASK_Editable And \HoverItem\Disabled = #False
                  \Editor\Item    = \HoverItem
                  \Editor\OldText = \Editor\Item\Text
               EndIf
         EndSelect
         
      EndIf
      
      ; Editor
      Examine_Editor(*this)
      
      ; Sonstiges
      Select EventType()
         Case #PB_EventType_LeftButtonUp
            \LockedClose     = #False
            \LockedCheck     = #False
            \MoveItem        = #Null
            \ReadyToMoveItem = #Null
            \LockedArrow     = #Null
            LockMutex(includes\Timer\Mutex)
            includes\Timer\widget = #Null
            UnlockMutex(includes\Timer\Mutex)
         Case #PB_EventType_MouseLeave
            \HoverItem       = #Null
         Case #PB_EventType_LeftDoubleClick
            If includes\EnableDoubleClickForNewTab And \HoverArrow = #Null And \HoverItem = #Null
               PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #__EVENT_NewItem, \EventTab)
            EndIf
      EndSelect
      If (\Shift <= 0 And \HoverArrow = #__MASK_PreviousArrow) Or (\Shift >= \LastShift And \HoverArrow = #__MASK_NextArrow)
         \HoverArrow = #False
      EndIf
      
      ; Registerkartenverschiebung: Verschiebungspartner suchen und tauschen
      If \MoveItem
         \EventTab = \MoveItem
         If \Attributes & #__MASK_Vertical
            If \Attributes & #__MASK_MultiLine
               If \Attributes & #__MASK_MirroredTabs
                  Row = Int((\MouseX-includes\Margin)/\TabSize)
               Else
                  Row = Int(\Rows-(\MouseX-includes\Margin)/\TabSize)
               EndIf
               If Row < 0 : Row = 0 : ElseIf Row >= \Rows : Row = \Rows-1 : EndIf
               MousePosition = Row*\MaxLength + \MouseY
            Else
               MousePosition = \MouseY
            EndIf
            If Not (\Attributes & #__MASK_MirroredTabs XOr \Attributes & #__MASK_ReverseOrdering)
               MousePosition = OutputHeight() - MousePosition
            EndIf
         Else
            If \Attributes & #__MASK_MultiLine
               If \Attributes & #__MASK_MirroredTabs
                  Row = Int((\MouseY-includes\Margin)/\TabSize)
               Else
                  Row = Int(\Rows-(\MouseY-includes\Margin)/\TabSize)
               EndIf
               If Row < 0 : Row = 0 : ElseIf Row >= \Rows : Row = \Rows-1 : EndIf
               MousePosition = Row*\MaxLength + \MouseX
            Else
               MousePosition = \MouseX
            EndIf
            If \Attributes & #__MASK_ReverseOrdering
               MousePosition = OutputWidth() - MousePosition
            EndIf
         EndIf
         If Not \Event
            ChangeCurrentElement(\Item(), \MoveItem)
            While NextElement(\Item())
               If MousePosition > \Item()\Position + \MaxLength*\Item()\Row
                  SwapElements(\Item(), @\Item(), \MoveItem)
                  \Item()\Position = \MoveItem\Position
                  \MoveItem\Position = \Item()\Position + \Item()\Length
                  \Event = #__EVENT_SwapItem
                  PushListPosition(\Item())
                  ChangeCurrentElement(\Item(), \MoveItem)
                  \EventTab = ListIndex(\Item())
                  PopListPosition(\Item())
               EndIf
            Wend
         EndIf
         If Not \Event
            ChangeCurrentElement(\Item(), \MoveItem)
            While PreviousElement(\Item()) And ListIndex(\Item()) >= \Shift-1
               If \MoveItem\Length < \Item()\Length
                  MinLength = \MoveItem\Length
               Else
                  MinLength = \Item()\Length 
               EndIf
               If MousePosition < \Item()\Position + \MaxLength*\Item()\Row + MinLength
                  SwapElements(\Item(), @\Item(), \MoveItem)
                  \MoveItem\Position = \Item()\Position
                  \Item()\Position = \MoveItem\Position + \MoveItem\Length
                  \Event = #__EVENT_SwapItem
                  PushListPosition(\Item())
                  ChangeCurrentElement(\Item(), \MoveItem)
                  \EventTab = ListIndex(\Item())
                  PopListPosition(\Item())
               EndIf
            Wend
         EndIf
         If \Event = #__EVENT_SwapItem
            PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #__EVENT_SwapItem, \EventTab)
         EndIf
      EndIf
      
      ; ToolTip aktualisieren
      If \ToolTip\Current <> \ToolTip\Old
         If \ToolTip\Current = #Null
            GadgetToolTip(\canvas\gadget, "")
         ElseIf \ToolTip\Current = @\ToolTip\NewText Or \ToolTip\Current =  @\ToolTip\CloseText
            GadgetToolTip(\canvas\gadget, PeekS(\ToolTip\Current))
         ElseIf \HoverItem And \ToolTip\Current = @\HoverItem\ToolTip
            GadgetToolTip(\canvas\gadget, PeekS(\ToolTip\Current))
         Else
            GadgetToolTip(\canvas\gadget, ReplaceString(\ToolTip\ItemText, "%ITEM", PeekS(\ToolTip\Current)))
         EndIf
         \ToolTip\Old = \ToolTip\Current
      EndIf
      
   EndWith
   
EndProcedure



; Ermittelt das Aussehen und die Lage der Tabs
Procedure Update(*this._s_widget)
   
   Protected FocusingSelectedTab.i
   Protected ShowLength.i, X.i
   Protected OldAttributes.i
   Protected Difference.f, Factor.f, Position.i, Length.i, MaxWidth.i, MousePosition.i
   Protected *Item._s_ROW, Row.i, Rows.i=1
   Protected *Current, *Last, AddLength.i, RowCount.i
   Protected Dim Row._s_row_(0)
   
   With *this
      
      ; Vorbereitung
      DrawingFont(\FontID)
      \Attributes & ~(#__MASK_PreviousArrow|#__MASK_NextArrow) ; erstmal keine Navigation
      If \TabSize = 0
         If \Attributes & #__MASK_Vertical
            If GadgetWidth(\canvas\gadget) > 1
               \TabSize = OutputWidth() - includes\Margin
            Else
               \TabSize = TextHeight("|") + includes\PaddingY*2
            EndIf
         Else
            If GadgetHeight(\canvas\gadget) > 1
               \TabSize = OutputHeight() - includes\Margin
            Else
               \TabSize = TextHeight("|") + includes\PaddingY*2
            EndIf
         EndIf
      EndIf
      If \Attributes & #__MASK_NewTab
         \NewTabItem\Length = ItemLength(*this, \NewTabItem)
         \NewTabItem\Row = 0
      EndIf
      
      ; Mehrzeilige Registerkartenleiste
      If \Attributes & #__MASK_MultiLine
         
         \MaxLength = MaxLength(*this)
         \Length    = \MaxLength
         \Shift     = 0
         
         ; Breiten ermitteln
         Length = 1
         ForEach \Item()
            \Item()\Row = 0
            \Item()\Length  = ItemLength(*this, \Item())
            \Item()\Visible = #True
            Length - 1 + \Item()\Length
         Next
         
         ; Mehrere Zeilen einrichten
         If Length > \MaxLength
            Row = 0
            Row(Row)\Length = 1
            ForEach \Item()
               If NextElement(\Item())
                  PreviousElement(\Item())
                  MaxWidth = MaxLength(*this, #False)
               Else
                  LastElement(\Item())
                  MaxWidth = MaxLength(*this)
               EndIf
               If Row(Row)\Length-1+\Item()\Length > MaxWidth And Row(Row)\Items > 0
                  Row + 1
                  ReDim Row(Row)
                  Row(Row)\Length = 1
               EndIf
               Row(Row)\Length - 1 + \Item()\Length
               Row(Row)\Items + 1
               \Item()\Row = Row
            Next
         Else
            Row(Row)\Length = Length
         EndIf
         Rows = Row+1
         
         ; Verbreitern
         If Rows > 1
            MaxWidth = MaxLength(*this, #False)
            ForEach \Item()
               AddLength = (MaxWidth-Row(\Item()\Row)\Length)/Row(\Item()\Row)\Items
               If \Item()\Row <> Rows-1 Or AddLength < 0
                  \Item()\Length + AddLength
                  Row(\Item()\Row)\Length + AddLength
                  Row(\Item()\Row)\Items - 1
               EndIf
            Next
         EndIf
         
         ; Positionen errechnen
         Length = includes\Margin
         Row = 0
         ForEach \Item()
            If Row <> \Item()\Row
               Row + 1
               Length = includes\Margin
            EndIf
            \Item()\Position = Length
            Length + \Item()\Length - 1
         Next
         If Row(Rows-1)\Length > MaxLength(*this) And LastElement(\Item())
            \Item()\Length = MaxLength(*this, #False)
            Rows + 1
            \NewTabItem\Row = Rows-1
            \NewTabItem\Position = includes\Margin
         Else
            \NewTabItem\Row = Rows-1
            \NewTabItem\Position = includes\Margin+Row(\NewTabItem\Row)\Length - 1
         EndIf
         
         ; Einzeilige Registerkartenleiste
      Else
         
         \MaxLength = MaxLength(*this)
         
         ; ggf. Textkurzung
         If \Attributes & #__MASK_TextCutting
            \Length = TextCutting(*this)
            If \Length <= \MaxLength
               \Shift = 0
            EndIf
         EndIf
         
         ; Breiten ermitteln
         \Length = 1
         ForEach \Item()
            \Item()\Length = ItemLength(*this, \Item())
            \Item()\Row    = 0
            \Length + \Item()\Length-1
         Next
         
         ; Navigation notig ?
         If \Length > \MaxLength
            \Attributes | (#__MASK_PreviousArrow | #__MASK_NextArrow)
            \MaxLength = MaxLength(*this)
         Else
            ;\Shift = 0
         EndIf
         
         ; LastShift ermitteln
         If LastElement(\Item())
            \LastShift = ListIndex(\Item())
            ShowLength = \Item()\Length
            While PreviousElement(\Item())
               If ShowLength + \Item()\Length - 1 > \MaxLength - Bool(ListIndex(\Item())>0)*includes\FadeOut
                  Break
               Else
                  ShowLength + \Item()\Length - 1
                  \LastShift - 1
               EndIf
            Wend
         Else
            \LastShift = 0
         EndIf
         
         ; ggf. aktuell ausgewahlte Registerkarte in den sichtbaren Bereich bringen
         If \FocusingSelectedTab And \SelectedItem
            ChangeCurrentElement(\Item(), \SelectedItem)
            If ListIndex(\Item()) <= \Shift
               \Shift = ListIndex(\Item())
            Else
               While \Shift < \LastShift And SelectElement(\Item(), \Shift)
                  ShowLength = \Item()\Length
                  If \Item() = \SelectedItem
                     Break
                  EndIf
                  While NextElement(\Item())
                     If ShowLength + \Item()\Length - 1 > \MaxLength - (Bool(\Shift>0)+Bool(\Shift<\LastShift))*includes\FadeOut
                        \Shift + 1
                        Break
                     ElseIf \Item() = \SelectedItem
                        Break 2
                     EndIf
                     ShowLength + \Item()\Length - 1
                  Wend
               Wend
            EndIf
            \FocusingSelectedTab = #False
         EndIf
         
         If \Shift > \LastShift
            \Shift = \LastShift
         EndIf
         \MaxLength - (Bool(\Shift>0)+Bool(\Shift<\LastShift))*includes\FadeOut
         
         ; Position der Tabs
         
         ; vorherige Registerkarte
         If \Attributes & #__MASK_PreviousArrow
            If \Shift > 0
               ForEach \Item()
                  \Item()\Position = -$FFFF
                  \Item()\Visible  = #False
                  If ListIndex(\Item()) >= \Shift-1 : Break : EndIf
               Next
               Position = includes\ArrowWidth + includes\Margin + includes\FadeOut
               SelectElement(\Item(), \Shift-1)
               \Item()\Position = Position - \Item()\Length + 1
               \Item()\Visible  = #True
            Else
               Position = includes\ArrowWidth + includes\Margin
            EndIf
         Else
            Position = includes\Margin
         EndIf
         
         ; sichtbare Registerkarten
         \Length = 0
         If SelectElement(\Item(), \Shift)
            Repeat
               \Item()\Position = Position + \Length
               \Item()\Visible  = #True
               If \Length + \Item()\Length - 1 > \MaxLength
                  Break
               EndIf
               \Length + \Item()\Length - 1
            Until Not NextElement(\Item())
         EndIf
         
         ; nachste Registerkarte
         If \Attributes & #__MASK_NextArrow And ListIndex(\Item()) <> -1
            If ListIndex(\Item()) <> ListSize(\Item())-1
               \Item()\Position = Position + \Length
               \Length + \Item()\Length - 1
               \Item()\Visible  = #True
               If NextElement(\Item())
                  \Item()\Position = Position + \Length
                  \Item()\Visible  = #True
               EndIf
            EndIf
            If \Attributes & #__MASK_NewTab
               If \Attributes & #__MASK_Vertical
                  \NewTabItem\Position = OutputHeight()-\NewTabItem\Length-includes\Margin/2
               Else
                  \NewTabItem\Position = OutputWidth()-\NewTabItem\Length-includes\Margin/2
               EndIf
               If \Attributes & #__MASK_PopupButton
                  \NewTabItem\Position - includes\ArrowHeight
               EndIf
            EndIf
            While NextElement(\Item())
               \Item()\Position = $FFFF
               \Item()\Visible  = #False
            Wend
         Else
            If \Attributes & #__MASK_NewTab
               \NewTabItem\Position = Position + \Length
            EndIf
         EndIf
         
         Row(0)\Length = Position - includes\Margin+\Length+1
         
      EndIf
      
      ; Gro?enanderung des Gadgets
      If Rows <> \Rows And (EventType() >= #PB_EventType_FirstCustomValue Or GetGadgetAttribute(\canvas\gadget, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton = #False)
         StopDrawing()
         If \Attributes & #__MASK_Vertical
            ResizeGadget(\canvas\gadget, #PB_Ignore, #PB_Ignore, Rows*\TabSize+includes\Margin, #PB_Ignore)
         Else
            ResizeGadget(\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Rows*\TabSize+includes\Margin)
         EndIf
         PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #__EVENT_Resize, -1)
         StartDrawing(CanvasOutput(\canvas\gadget))
         DrawingFont(\FontID)
         \Resized = #True
         \Rows = Rows
      EndIf
      
      ; Animation der bewegten Registerkarte
      If \MoveItem
         If \Attributes & #__MASK_Vertical
            If \Attributes & #__MASK_MirroredTabs XOr \Attributes & #__MASK_ReverseOrdering
               MousePosition = \MouseY
            Else
               MousePosition = OutputHeight()-\MouseY-1
            EndIf
         Else
            If \Attributes & #__MASK_ReverseOrdering
               MousePosition = OutputWidth()-\MouseX-1
            Else
               MousePosition = \MouseX
            EndIf
         EndIf
         Difference = Abs(\MoveItem\Position-(MousePosition-\MoveItem\Length/2))
         If Difference > 24
            Position = MousePosition - \MoveItem\Length/2
         Else
            Factor = Pow(Difference/24, 2)
            Position = \MoveItem\Position*(1-Factor) + (MousePosition-\MoveItem\Length/2)*Factor
         EndIf
         If \Attributes & #__MASK_PreviousArrow = #Null 
            If Position < includes\Margin
               Position = includes\Margin
            EndIf
         ElseIf \Shift <= 0 And Position < includes\Margin + includes\ArrowWidth
            Position = includes\Margin + includes\ArrowWidth
         EndIf
         If (\Attributes & #__MASK_NextArrow = #Null Or \Shift >= \LastShift) And Position + \MoveItem\Length + 1 - includes\Margin > Row(\MoveItem\Row)\Length - 1
            Position = Row(\MoveItem\Row)\Length + includes\Margin - \MoveItem\Length
         EndIf
         \MoveItem\Position = Position
      EndIf
      
      ; Aussehen
      ForEach \Item()
         If \Item()\Disabled
            \Item()\color\state = #__s_Disable
         ElseIf \Item() = \MoveItem
            \Item()\color\state = #__s_Move
         ElseIf \Item() = \SelectedItem Or \Item()\Selected
            \Item()\color\state = #__s_Selected
         ElseIf \Item() = \HoverItem
            \Item()\color\state = #__s_Hover
         Else
            \Item()\color\state = #__s_Normal
         EndIf
         ItemLayout(*this, \Item())
      Next
      
      If \NewTabItem = \HoverItem
         \NewTabItem\color\state = #__s_Hover
      Else
         \NewTabItem\color\state = #__s_Normal
      EndIf
      ItemLayout(*this, \NewTabItem)
      
      Layout(*this)
      
      *this\UpdatePosted = #False
      
   EndWith
   
EndProcedure



; Zeichnet das gesamte TabBar
Procedure Draw(*this._s_widget)
   
   Protected X.i, Y.i, Size.i, SelectedItemDrawed.i, MoveItemDrawed.i, Row.i, *LastItem
   
   With *this
      
      ; Initialisierung
      DrawingFont(\FontID)
      DrawingMode(#PB_2DDrawing_AllChannels)
      Box(0, 0, OutputWidth(), OutputHeight(), includes\TabBarColor)
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      
      ; Sichtbare Registerkarten
      *LastItem = LastElement(\Item())
      For Row = \Rows-1 To 0 Step -1
         If *LastItem
            PushListPosition(\Item())
            While \Item()\Row >= Row
               If \Item()\Visible And \Item()\Selected = #False And \Item() <> \MoveItem
                  DrawItem(*this, \Item())
               EndIf
               If Not PreviousElement(\Item())
                  Break
               EndIf
            Wend
         EndIf
         ; ggf. "Neu"-Registerkarte (wenn keine Navigation)
         If \NewTabItem\Row = Row And \Attributes & #__MASK_NewTab And \Attributes & #__MASK_NextArrow = #Null
            DrawItem(*this, \NewTabItem)
         EndIf
         ; ggf. Unterlinien
         If Row = 0 And \Attributes & #__MASK_BottomLine
            If \Attributes & #__MASK_Vertical
               If \Attributes & #__MASK_MirroredTabs
                  Line(0, 0, 1, OutputHeight(), includes\color\frame)
               Else
                  Line(OutputWidth()-1, 0, 1, OutputHeight(), includes\color\frame)
               EndIf
            Else
               If \Attributes & #__MASK_MirroredTabs
                  Line(0, 0, OutputWidth(), 1, includes\color\frame)
               Else
                  Line(0, OutputHeight()-1, OutputWidth(), 1, includes\color\frame)
               EndIf
            EndIf
         EndIf
         ; ggf. aktive Registerkarte
         If *LastItem
            PopListPosition(\Item())
            While \Item()\Row >= Row
               If \Item()\Visible And \Item()\Selected = #True And \Item() <> \MoveItem
                  DrawItem(*this, \Item())
               EndIf
               If Not PreviousElement(\Item())
                  Break
               EndIf
            Wend
         EndIf
         ; ggf. bewegte Registerkarte
         If \MoveItem And \MoveItem\Row = Row
            DrawItem(*this, \MoveItem)
         EndIf
      Next
      
      ; Navigationsausblendung
      DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Gradient)
      ResetGradientColors()
      GradientColor(0.0, includes\TabBarColor&$FFFFFF)
      GradientColor(0.5, includes\TabBarColor&$FFFFFF|$A0<<24)
      GradientColor(1.0, includes\TabBarColor&$FFFFFF|$FF<<24)
      
      Size = includes\Margin + includes\ArrowWidth + includes\FadeOut
      If \Attributes & #__MASK_PreviousArrow And \Shift
         If \Attributes & #__MASK_Vertical
            If \Attributes & #__MASK_MirroredTabs XOr \Attributes & #__MASK_ReverseOrdering
               LinearGradient(0, Size, 0, Size-includes\FadeOut)
               Box(0, 0, OutputWidth(), Size)
            Else
               LinearGradient(0, OutputHeight()-Size, 0, OutputHeight()-Size+includes\FadeOut)
               Box(0, OutputHeight()-Size, OutputWidth(), Size)
            EndIf
         Else
            If \Attributes & #__MASK_ReverseOrdering
               LinearGradient(OutputWidth()-Size, 0, OutputWidth()-Size+includes\FadeOut, 0)
               Box(OutputWidth()-Size, 0, Size, OutputHeight())
            Else
               LinearGradient(Size, 0, Size-includes\FadeOut, 0)
               Box(0, 0, Size, OutputHeight())
            EndIf
         EndIf
      EndIf
      If \Attributes & #__MASK_NextArrow And \Shift < \LastShift
         If \Attributes & #__MASK_NewTab
            Size + \NewTabItem\Length+includes\Margin
         EndIf
         If \Attributes & #__MASK_PopupButton
            Size + includes\ArrowHeight
         EndIf
         If \Attributes & #__MASK_Vertical
            If \Attributes & #__MASK_MirroredTabs XOr \Attributes & #__MASK_ReverseOrdering
               LinearGradient(0, OutputHeight()-Size, 0, OutputHeight()-Size+includes\FadeOut)
               Box(0, OutputHeight()-Size, OutputWidth(), Size)
            Else
               LinearGradient(0, Size, 0, Size-includes\FadeOut)
               Box(0, 0, OutputWidth(), Size)
            EndIf
         Else
            If \Attributes & #__MASK_ReverseOrdering
               LinearGradient(Size, 0, Size-includes\FadeOut, 0)
               Box(0, 0, Size, OutputHeight())
            Else
               LinearGradient(OutputWidth()-Size, 0, OutputWidth()-Size+includes\FadeOut, 0)
               Box(OutputWidth()-Size, 0, Size, OutputHeight())
            EndIf
         EndIf
      EndIf
      
      ; Navigation
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      If \Attributes & #__MASK_PreviousArrow
         If \HoverArrow = #__MASK_PreviousArrow
            If \HoverArrow = \LockedArrow
               DrawButton(\Layout\PreviousButtonX-\Layout\ButtonWidth/2, \Layout\PreviousButtonY-\Layout\ButtonHeight/2, \Layout\ButtonWidth, \Layout\ButtonHeight, -1, includes\color\fore, *this\Attributes & #__MASK_Vertical)
            Else
               DrawButton(\Layout\PreviousButtonX-\Layout\ButtonWidth/2, \Layout\PreviousButtonY-\Layout\ButtonHeight/2, \Layout\ButtonWidth, \Layout\ButtonHeight, 1, includes\color\fore, *this\Attributes & #__MASK_Vertical)
            EndIf
            DrawArrow(\Layout\PreviousButtonX, \Layout\PreviousButtonY, #__MASK_PreviousArrow, includes\color\front, *this\Attributes)
         ElseIf \Shift > 0
            DrawArrow(\Layout\PreviousButtonX, \Layout\PreviousButtonY, #__MASK_PreviousArrow, includes\color\front&$FFFFFF|$80<<24, *this\Attributes)
         Else
            DrawArrow(\Layout\PreviousButtonX, \Layout\PreviousButtonY, #__MASK_PreviousArrow, includes\color\front&$FFFFFF|$20<<24, *this\Attributes)
         EndIf
      EndIf
      If \Attributes & #__MASK_NextArrow
         If \HoverArrow = #__MASK_NextArrow
            If \HoverArrow = \LockedArrow
               DrawButton(\Layout\NextButtonX-\Layout\ButtonWidth/2, \Layout\NextButtonY-\Layout\ButtonHeight/2, \Layout\ButtonWidth, \Layout\ButtonHeight, -1, includes\color\fore, *this\Attributes & #__MASK_Vertical)
            Else
               DrawButton(\Layout\NextButtonX-\Layout\ButtonWidth/2, \Layout\NextButtonY-\Layout\ButtonHeight/2, \Layout\ButtonWidth, \Layout\ButtonHeight, 1, includes\color\fore, *this\Attributes & #__MASK_Vertical)
            EndIf
            DrawArrow(\Layout\NextButtonX, \Layout\NextButtonY, #__MASK_NextArrow, includes\color\front, *this\Attributes)
         ElseIf \Shift < \LastShift
            DrawArrow(\Layout\NextButtonX, \Layout\NextButtonY, #__MASK_NextArrow, includes\color\front&$FFFFFF|$80<<24, *this\Attributes)
         Else
            DrawArrow(\Layout\NextButtonX, \Layout\NextButtonY, #__MASK_NextArrow, includes\color\front&$FFFFFF|$20<<24, *this\Attributes)
         EndIf
      EndIf
      
      ; "Neu"-Registerkarten (wenn Navigation)
      If \Attributes & #__MASK_NewTab And \Attributes & #__MASK_NextArrow 
         DrawItem(*this, \NewTabItem)
      EndIf
      
      ; Popup-Button
      If \Attributes & #__MASK_PopupButton
         If \HoverArrow = #__MASK_PopupButton
            If \HoverArrow = \LockedArrow
               DrawButton(\Layout\PopupButtonX-\Layout\ButtonSize/2, \Layout\PopupButtonY-\Layout\ButtonSize/2, \Layout\ButtonSize, \Layout\ButtonSize, -1, includes\color\fore, *this\Attributes & #__MASK_Vertical)
            Else
               DrawButton(\Layout\PopupButtonX-\Layout\ButtonSize/2, \Layout\PopupButtonY-\Layout\ButtonSize/2, \Layout\ButtonSize, \Layout\ButtonSize, 1, includes\color\fore, *this\Attributes & #__MASK_Vertical)
            EndIf
            DrawArrow(\Layout\PopupButtonX, \Layout\PopupButtonY, #__MASK_PopupButton, includes\color\front, *this\Attributes)
         Else
            DrawArrow(\Layout\PopupButtonX, \Layout\PopupButtonY, #__MASK_PopupButton, includes\color\front&$FFFFFF|$80<<24, *this\Attributes)
         EndIf
      EndIf
      
   EndWith
   
EndProcedure



; Dauerschleife fur das automatische Scrollen in der Navigation
Procedure Timer(Null.i) ; Code OK
   
   With includes\Timer
      Repeat
         If \widget
            Delay(250)
            Repeat
               LockMutex(\Mutex)
               If \widget
                  PostEvent(#PB_Event_Gadget, \widget\canvas\window, \widget\canvas\gadget, #__EVENT_Pushed, \Type)
                  UnlockMutex(\Mutex)
               Else
                  UnlockMutex(\Mutex)
                  Break
               EndIf
               Delay(150)
            ForEver
         Else
            Delay(50)
         EndIf
      ForEver
   EndWith
   
EndProcedure



; Sendet ein Ereignis, um die Registerkarte zu aktualisieren.
Procedure PostUpdate(*this._s_widget) ; Code OK
   
   If *this\UpdatePosted = #False
      *this\UpdatePosted = #True
      PostEvent(#PB_Event_Gadget, *this\canvas\window, *this\canvas\gadget, #__EVENT_Updated, -1)
   EndIf
   
EndProcedure



; Callback fur BindGadgetEvent()
Procedure Callback() ; Code OK
   Protected *this._s_widget = GetGadgetData(EventGadget())
   
   If EventType() >= #PB_EventType_FirstCustomValue
      *this\EventTab = EventData()
      Select EventType()
         Case #__EVENT_Pushed
            Select EventData()
               Case #__MASK_PreviousArrow
                  If *this\Shift > 0
                     *this\Shift - 1
                  EndIf
               Case #__MASK_NextArrow
                  If *this\Shift < *this\LastShift
                     *this\Shift + 1
                  EndIf
            EndSelect
            If StartDrawing(CanvasOutput(*this\canvas\gadget))
               Update(*this)
               Draw(*this)
               StopDrawing()
            EndIf
         Case #__EVENT_Updated
            If StartDrawing(CanvasOutput(*this\canvas\gadget))
               Update(*this)
               Draw(*this)
               StopDrawing()
            EndIf
      EndSelect
   Else
      If StartDrawing(CanvasOutput(*this\canvas\gadget))
         Examine(*this)
         Update(*this)
         Draw(*this)
         StopDrawing()
      EndIf
   EndIf
   
EndProcedure

;-  4.2 Procedures for the TabBar
; Fuhrt eine Aktualisierung (Neuzeichnung) des Gadgets durch.
Procedure ReDraw (*this._s_widget) ; Code OK, Hilfe OK
   If StartDrawing(CanvasOutput(*this\canvas\gadget))
      Update(*this)
      Draw(*this)
      StopDrawing()
   EndIf
EndProcedure

; Gibt das angegebene TabBar wieder frei.
Procedure Free(*this._s_widget) ; Code OK, Hilfe OK
   ForEach *this\Item()
      ClearItem(*this, *this\Item())
   Next
   ClearStructure(*this, _s_widget)
   FreeMemory(*this)
   FreeGadget(*this)
EndProcedure

; Erstellt ein neus TabBar.
Procedure.i TabBar(Gadget, X.i, Y.i, Width.i, Height.i, Attributes.i, Window.i) ; Code OK
   Protected *this._s_widget = AllocateMemory(SizeOf(_s_widget))
   Protected Result.i, OldGadgetList.i, DummyGadget
   
   InitializeStructure(*this, _s_widget)
   OldGadgetList = UseGadgetList(WindowID(Window))
   Result = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard)
   UseGadgetList(OldGadgetList)
   If Gadget = #PB_Any
      Gadget = Result
   EndIf
   SetGadgetData(Gadget, *this)
   
   With *this
      \Attributes                  = Attributes
      \canvas\gadget                      = Gadget
      \canvas\window                      = Window
      \NewTabItem\color\front      = includes\color\front
      \NewTabItem\color\back       = includes\color\fore
      \Radius                      = includes\Radius
      \MinTabLength                = includes\MinTabLength
      \MaxTabLength                = includes\MaxTabLength
      \NormalTabLength             = includes\NormalTabLength
      \TabTextAlignment            = includes\TabTextAlignment
      CompilerSelect #PB_Compiler_OS
         CompilerCase #PB_OS_Windows
            \FontID                  = GetGadgetFont(#PB_Default)
         CompilerDefault
            DummyGadget = TextGadget(#PB_Any, 0, 0, 10, 10, "Dummy")
            \FontID                  = GetGadgetFont(DummyGadget)
            FreeGadget(DummyGadget)
      CompilerEndSelect
      \EventTab                    = #__tab_item_None
   EndWith
   
   BindGadgetEvent(Gadget, @Callback())
   ;BindEvent(#PB_Event_Gadget, @Callback(), #PB_All, Gadget, #PB_All) ; Aktuelle nicht benutzbar
   ReDraw (*this)
   
   ProcedureReturn *this
   
EndProcedure



; Fugt eine Registerkarte an die angegebenen Position ein.
Procedure.i AddItem(*this._s_widget, Position.i, Text.s, ImageID.i=#Null, DataValue.i=#Null) ; Code OK, Hilfe OK
   Protected *Item._s_ROW
   
   If Position = #__tab_item_NewTab
      *this\Attributes | #__MASK_NewTab
      *Item = @*this\NewTabItem
   ElseIf ItemID(*this, Position)
      *Item = InsertElement(*this\Item())
   Else
      LastElement(*this\Item())
      *Item = AddElement(*this\Item())
      Position = ListIndex(*this\Item())
   EndIf
   
   With *Item
      \Text             = Text
      \ShortText        = Text
      ReplaceImage(*this, *Item, ImageID)
      \DataValue        = DataValue
      \color\front       = includes\color\front
      \color\back = includes\color\fore
      If *Item <> @*this\NewTabItem
         \Attributes       = *this\Attributes
      EndIf
   EndWith
   
   PostUpdate(*this)
   
   ProcedureReturn Position
   
EndProcedure




; Entfernt die Registerkarte mit der angegebenen Position.
Procedure Remove_Item(*this._s_widget, Position.i) ; Code OK, Hilfe OK
   
   
   
   If Position = #__tab_item_NewTab
      *this\Attributes & ~#__MASK_NewTab
   ElseIf ItemID(*this, Position)
      RemoveItem(*this, *this\Item())
   EndIf
   
   PostUpdate(*this)
   
EndProcedure



; Entfernt alle Registerkarten aus der Leiste.
Procedure ClearItems(*this._s_widget) ; Code OK, Hilfe OK
   
   
   
   ForEach *this\Item()
      ClearItem(*this, *this\Item())
   Next
   ClearList(*this\Item())
   *this\SelectedItem = #Null
   
   PostUpdate(*this)
   
EndProcedure



; Gibt die Anzahl der Registerkarten zuruck.
Procedure.i CountItems(*this._s_widget) ; Code OK, Hilfe OK
   
   ProcedureReturn ListSize(*this\Item())
   
EndProcedure


; Setz einen ToolTip fur die Registerkartenleiste (fur die Registerkarten, die "Neu"-Registerkarte und den Schlie?enbutton)
Procedure ToolTip(*this._s_widget, ItemText.s="", NewText.s="", CloseText.s="") ; Code OK, Hilfe OK
   *this\ToolTip\ItemText  = ItemText
   *this\ToolTip\NewText   = NewText
   *this\ToolTip\CloseText = CloseText
EndProcedure



; Setz einen ToolTip fur die Registerkarte.
Procedure ItemToolTip(*this._s_widget, Tab.i, Text.s) ; Code OK, Hilfe OK
   
   Protected *Item._s_ROW = ItemID(*this, Tab)
   
   If *Item
      *Item\ToolTip = Text
   EndIf
   
EndProcedure



; Andert den Wert eines Attributs der Registerkartenleiste.
Procedure SetAttribute(*this._s_widget, Attribute.i, Value.i, Overwrite.i=#True) ; Code OK, Hilfe OK
   
   Select Attribute
      Case #__MASK_CloseTab, #__MASK_CloseSelectTab, #__MASK_NewTab, #__MASK_NoTabMoving, #__MASK_BottomLine,
           #__MASK_MultiLine, #__MASK_PopupButton, #__MASK_Editable, #__MASK_CheckBox, #__MASK_ReverseOrdering,
           #__MASK_MultiSelect, #__MASK_TextCutting, #__MASK_MirroredTabs, #__MASK_Vertical
         
         If Value
            *this\Attributes | Attribute
         Else
            *this\Attributes & ~Attribute
            
            If Attribute = #__MASK_MultiSelect
               ForEach *this\Item()
                  *this\Item()\Selected = #False
               Next
               If *this\SelectedItem
                  *this\SelectedItem\Selected = #True
               EndIf
               
            ElseIf Attribute = #__MASK_TextCutting
               ForEach *this\Item()
                  *this\Item()\ShortText = *this\Item()\Text
               Next
            EndIf 
            
         EndIf
         
   EndSelect
   
   
   Select Attribute
      Case #__MASK_CloseTab, #__MASK_CloseSelectTab, #__MASK_NewTab, #__MASK_NoTabMoving, #__MASK_BottomLine,
           #__MASK_MultiLine, #__MASK_PopupButton, #__MASK_Editable, #__MASK_CheckBox, #__MASK_ReverseOrdering
         
         If Overwrite
            If Value
               ForEach *this\Item()
                  *this\Item()\Attributes | Attribute
               Next
            Else
               ForEach *this\Item()
                  *this\Item()\Attributes & ~Attribute
               Next
            EndIf
         EndIf
         
      Case #__MASK_MirroredTabs, #__MASK_Vertical
         *this\Rows = 0
         ForEach *this\Item()
            If *this\Item()\Image
               RotateImage(*this, *this\Item())
            EndIf
         Next
         If *this\NewTabItem\Image
            RotateImage(*this, *this\NewTabItem)
         EndIf
         
      Case #__MASK_TabRounding
         *this\Radius = Value
      Case #__MASK_MinTabLength
         *this\MinTabLength = Value
      Case #__MASK_TabTextAlignment
         *this\TabTextAlignment = Value
      Case #__MASK_MaxTabLength
         ForEach *this\Item()
            *this\Item()\ShortText = *this\Item()\Text
         Next
         *this\MaxTabLength = Value
         
      Case #__MASK_ScrollPosition
         If Value < 0
            *this\Shift = 0
         ElseIf Value > *this\LastShift
            *this\Shift = *this\LastShift
         Else
            *this\Shift = Value
         EndIf
   EndSelect
   
   PostUpdate(*this)
   
EndProcedure



; Gibt den Wert eines Attributs der Registerkartenleiste zuruck.
Procedure.i GetAttribute(*this._s_widget, Attribute.i) ; Code OK, Hilfe OK
   
   
   
   Select Attribute
      Case #__MASK_CloseTab, #__MASK_CloseSelectTab, #__MASK_NewTab, #__MASK_MirroredTabs, #__MASK_TextCutting,
           #__MASK_NoTabMoving, #__MASK_BottomLine, #__MASK_MultiLine, #__MASK_PopupButton, #__MASK_Editable,
           #__MASK_MultiSelect, #__MASK_Vertical, #__MASK_CheckBox, #__MASK_ReverseOrdering
         If *this\Attributes & Attribute
            ProcedureReturn #True
         Else
            ProcedureReturn #False
         EndIf
      Case #__MASK_TabRounding
         ProcedureReturn *this\Radius
      Case #__MASK_MinTabLength
         ProcedureReturn *this\MinTabLength
      Case #__MASK_MaxTabLength
         ProcedureReturn *this\MaxTabLength
      Case #__MASK_ScrollPosition
         ProcedureReturn *this\Shift
      Case #__MASK_TabTextAlignment
         ProcedureReturn *this\TabTextAlignment
   EndSelect
   
EndProcedure



; Andert den Daten-Wert der Registerkartenleiste.
Procedure SetData(*this._s_widget, DataValue.i) ; Code OK, Hilfe OK
   
   *this\DataValue = DataValue
   
EndProcedure



; Gibt den Daten-Wert der Registerkartenleiste zuruck.
Procedure.i GetData(*this._s_widget) ; Code OK, Hilfe OK
   
   ProcedureReturn *this\DataValue
   
EndProcedure



; Andert die zu nutzende Schrift.
Procedure SetFont(*this._s_widget, FontID.i) ; Code OK, Hilfe OK
   
   If FontID = #PB_Default
      *this\FontID = GetGadgetFont(#PB_Default)
   Else
      *this\FontID = FontID
   EndIf
   
   PostUpdate(*this)
   
EndProcedure



; Andert den Status der Registerkartenleiste.
Procedure SetState(*this._s_widget, State.i) ; Code OK, Hilfe OK
   
   
   Protected *Item._s_ROW
   
   ForEach *this\Item()
      *this\Item()\Selected = #False
   Next
   Select State
      Case #__tab_item_None, #__tab_item_NewTab
         *this\SelectedItem = #Null
      Case #__tab_item_Selected
      Default
         *Item = ItemID(*this, State)
         If *Item
            SelectItem(*this, *Item)
         EndIf
   EndSelect
   
   PostUpdate(*this)
   
EndProcedure



; Gibt den Status der Registerkartenleiste zuruck.
Procedure.i GetState(*this._s_widget) ; Code OK, Hilfe OK
   
   If *this\SelectedItem
      ChangeCurrentElement(*this\Item(), *this\SelectedItem)
      ProcedureReturn ListIndex(*this\Item())
   EndIf
   
   ProcedureReturn #__tab_item_None
   
EndProcedure



; Wechselt zur der Registerkarte mit dem angegebenen Text
Procedure SetText(*this._s_widget, Text.s) ; Code OK
   
   *this\SelectedItem = #Null
   ForEach *this\Item()
      If *this\Item()\Text = Text
         SetState(*this, @*this\Item())
         Break
      EndIf
   Next
   
EndProcedure



; Gibt den Text der aktuell ausgewahlten Registerkarte zuruck.
Procedure.s GetText(*this._s_widget) ; Code OK, Hilfe OK
   
   If *this\SelectedItem
      ProcedureReturn *this\SelectedItem\Text
   EndIf
   
EndProcedure



; Andert die Attribute der angegebenen Registerkarte.
Procedure SetItemAttribute(*this._s_widget, Tab.i, Attribute.i, Value.i)
   Protected *Item._s_ROW = ItemID(*this, Tab)
   
   If *Item And *Item <> *this\NewTabItem
      Select Attribute
         Case #__MASK_CloseTab, #__MASK_CloseSelectTab, #__MASK_CheckBox
            If Value
               *Item\Attributes | Attribute
            Else
               *Item\Attributes & ~Attribute
            EndIf
      EndSelect
      PostUpdate(*this)
   EndIf
   
EndProcedure



; Gibt den Status der angegebenen Registerkarte zuruck.
Procedure.i GetItemAttribute(*this._s_widget, Tab.i, Attribute.i)
   Protected *Item._s_ROW = ItemID(*this, Tab)
   Protected State.i
   
   If *Item
      Select Attribute
         Case #__MASK_CloseTab, #__MASK_CloseSelectTab, #__MASK_CheckBox
            If *Item\Attributes & Attribute
               ProcedureReturn #True
            Else
               ProcedureReturn #False
            EndIf
      EndSelect
   EndIf
   
EndProcedure



; Andert den Datenwert der angegebenen Registerkarte.
Procedure SetItemData(*this._s_widget, Tab.i, DataValue.i) ; Code OK, Hilfe OK
   Protected *Item._s_ROW = ItemID(*this, Tab)
   
   If *Item
      *Item\DataValue = DataValue
   EndIf
   
EndProcedure



; Gibt den Datenwert der angegebenen Registerkarte zuruck.
Procedure.i GetItemData(*this._s_widget, Tab.i) ; Code OK, Hilfe OK
   
   Protected *Item._s_ROW = ItemID(*this, Tab)
   
   If *Item
      ProcedureReturn *Item\DataValue
   EndIf
   
EndProcedure



; Andert die Farbe der angegebenen Registerkarte.
Procedure SetItemColor(*this._s_widget, Tab.i, Type.i, Color.i) ; Code OK, Hilfe OK
   Protected *Item._s_ROW = ItemID(*this, Tab)
   
   If *Item
      Select Type
         Case #PB_Gadget_FrontColor
            If Color = #PB_Default
               Color = includes\color\front
            EndIf
            *Item\color\front = Color | $FF<<24
         Case #PB_Gadget_BackColor
            If Color = #PB_Default
               Color = includes\color\fore
            EndIf
            *Item\color\back = Color | $FF<<24
      EndSelect
      PostUpdate(GetGadgetData(*this\Canvas\Gadget))
   EndIf
   
EndProcedure



; Gibt die Farbe der angegebenen Registerkarte zuruck.
Procedure.i GetItemColor(*this._s_widget, Tab.i, Type.i) ; Code OK, Hilfe OK
   Protected *Item._s_ROW = ItemID(*this, Tab)
   
   If *Item
      Select Type
         Case #PB_Gadget_FrontColor
            ProcedureReturn *Item\color\front
         Case #PB_Gadget_BackColor
            ProcedureReturn *Item\color\back
      EndSelect
   EndIf
   
EndProcedure



; Andert das Icon der angegebenen Registerkarte.
Procedure SetItemImage(*this._s_widget, Tab.i, ImageID.i) ; Code OK, Hilfe OK
   Protected *Item._s_ROW = ItemID(*this, Tab)
   
   If *Item
      ReplaceImage(*this, *Item, ImageID)
      PostUpdate(*this)
   EndIf
   
EndProcedure



; Andert die Position der angegebenen Registerkarte (die Registerkarte wird also verschoben).
Procedure SetItemPosition(*this._s_widget, Tab.i, Position.i) ; Code OK, Hilfe OK
   Protected *NewItem._s_ROW = ItemID(*this, Position)
   Protected *Item._s_ROW = ItemID(*this, Tab)
   
   If *Item And *Item <> *this\NewTabItem
      If *NewItem And *NewItem <> *this\NewTabItem
         If Position > Tab
            MoveElement(*this\Item(), #PB_List_After, *NewItem)
         Else
            MoveElement(*this\Item(), #PB_List_Before, *NewItem)
         EndIf
      Else
         MoveElement(*this\Item(), #PB_List_Last)
      EndIf
      PostUpdate(*this)
   EndIf
   
EndProcedure



; Gibt die Position der angegebenen Registerkarte zuruck.
Procedure GetItemPosition(*this._s_widget, Tab.i) ; Code OK, Hilfe OK
   With *this
      
      Select Tab
         Case #__tab_item_Event
            ProcedureReturn \EventTab
            
         Case #__tab_item_Selected
            If \SelectedItem
               ChangeCurrentElement(\Item(), \SelectedItem)
               ProcedureReturn ListIndex(\Item())
            Else
               ProcedureReturn #__tab_item_None
            EndIf
         Case #__tab_item_NewTab, #__tab_item_None
            ProcedureReturn Tab
            
         Default 
            If Tab >= 0 And Tab < ListSize(\Item())
               ProcedureReturn Tab
            ElseIf Tab >= ListSize(\Item())
               ForEach \Item()
                  If @\Item() = Tab
                     ProcedureReturn ListIndex(\Item())
                  EndIf
               Next
               ProcedureReturn #__tab_item_None
            EndIf
      EndSelect
      
   EndWith
   
EndProcedure

; Andert den Status der angegebenen Registerkarte.
Procedure SetItemState(*this._s_widget, Tab.i, State.i, Mask.i=#__STATEMASK_Disabled|#__STATEMASK_Selected|#__STATEMASK_Checked) ; Code OK, Hilfe OK
   Protected *Item._s_ROW = ItemID(*this, Tab)
   If *Item And *Item <> *this\NewTabItem
      If Mask & #__STATEMASK_Disabled
         *Item\Disabled = Bool(State&#__STATEMASK_Disabled)
      EndIf
      If Mask & #__STATEMASK_Checked
         *Item\Checked = Bool(State&#__STATEMASK_Checked)
      EndIf
      If Mask & #__STATEMASK_Selected
         If State & #__STATEMASK_Selected
            SelectItem(*this, *Item)
         Else
            UnselectItem(*this, *Item)
         EndIf
      EndIf
      PostUpdate(*this)
   EndIf
EndProcedure

; Gibt den Status der angegebenen Registerkarte zuruck.
Procedure.i GetItemState(*this._s_widget, Tab.i) ; Code OK, Hilfe OK
   Protected *Item._s_ROW = ItemID(*this, Tab)
   If *Item
      ProcedureReturn (*Item\Disabled*#__STATEMASK_Disabled) | (*Item\Selected*#__STATEMASK_Selected) | (*Item\Checked*#__STATEMASK_Checked)
   EndIf
EndProcedure

; Andert den Text der angegebenen Registerkarte.
Procedure SetItemText(*this._s_widget, Tab.i, Text.s) ; Code OK, Hilfe OK
   Protected *Item._s_ROW = ItemID(*this, Tab)
   If *Item
      *Item\Text      = Text
      *Item\ShortText = Text
      PostUpdate(GetGadgetData(*this\Canvas\Gadget))
   EndIf
EndProcedure

; Gibt den Text der angegebenen Registerkarte zuruck.
Procedure.s GetItemText(*this._s_widget, Tab.i) ; Code OK, Hilfe OK
   Protected *Item._s_ROW = ItemID(*this, Tab)
   If *Item
      ProcedureReturn *Item\Text
   EndIf
EndProcedure














;-
;XIncludeFile "TabBar.pbi"
Global *tab1
Enumeration
   #Window
   #Image
   #Gadget_TabBar
   #Gadget_Vertical
   #Gadget_CloseTab
   #Gadget_CloseSelectTab
   #Gadget_EmptyButton
   #Gadget_MirroredTabs
   #Gadget_TextCutting
   #Gadget_NoTabMoving
   #Gadget_TabRounding
   #Gadget_MultiLine
   #Gadget_BottomLine
   #Gadget_Editable
   #Gadget_MultiSelect
   #Gadget_CheckBox
   #Gadget_ReverseOrdering
   #Gadget_TabTextAlignment
   #Gadget_MinTabLength
   #Gadget_MaxTabLength
   #Gadget_Item
   #Gadget_ItemBackColor
   #Gadget_ItemFrontColor
   #Gadget_ItemText
   #Gadget_ItemImage
   #Gadget_ItemDisabled
   #Gadget_ItemSelected
   #Gadget_ItemChecked
   #Gadget_ItemCloseTab
   #Gadget_ItemCheckBox
   #Gadget_Events
   #Gadget_Container
EndEnumeration

Procedure BorderGadget(ID.i, X.i, Y.i, Width.i, Height.i, Text.s)
   Protected Result.i
   If ID = #PB_Any
      Result = ContainerGadget(ID, X, Y, Width, Height)
      SetGadgetData(Result, FrameGadget(#PB_Any, 0, 0, Width, Height, Text))
   Else
      Result = ContainerGadget(ID, X, Y, Width, Height)
      SetGadgetData(ID, FrameGadget(#PB_Any, 0, 0, Width, Height, Text))
   EndIf
   ProcedureReturn Result
EndProcedure

Procedure GetItemGadgetState()
   Select GetGadgetState(#Gadget_Item)
      Case -1
         ProcedureReturn #__tab_item_None
      Case 0
         ProcedureReturn #__tab_item_NewTab
      Default
         ProcedureReturn GetGadgetState(#Gadget_Item)-1
   EndSelect
EndProcedure

Procedure UpdateItemAttributes(Position)
   If GetGadgetText(#Gadget_ItemText) <> GetItemText(*tab1, Position)
      SetGadgetText(#Gadget_ItemText, GetItemText(*tab1, Position))
   EndIf
   SetGadgetState(#Gadget_ItemDisabled, (GetItemState(*tab1, Position)&#__STATEMASK_Disabled))
   SetGadgetState(#Gadget_ItemSelected, (GetItemState(*tab1, Position)&#__STATEMASK_Selected))
   SetGadgetState(#Gadget_ItemChecked, (GetItemState(*tab1, Position)&#__STATEMASK_Checked))
   SetGadgetState(#Gadget_ItemCloseTab, GetItemAttribute(*tab1, Position, #__MASK_CloseTab))
   SetGadgetState(#Gadget_ItemCheckBox, GetItemAttribute(*tab1, Position, #__MASK_CheckBox))
EndProcedure

Procedure UpdateItemGadget(Position)
   Protected Index
   ClearGadgetItems(#Gadget_Item)
   AddGadgetItem(#Gadget_Item, #PB_Default, "NewTab")
   For Index = 1 To CountItems(*tab1)
      AddGadgetItem(#Gadget_Item, #PB_Default, "Position "+Str(Index-1))
   Next
   SetState(*tab1, Position)
   SetGadgetState(#Gadget_Item, Position+1)
   UpdateItemAttributes(GetItemGadgetState())
EndProcedure


Define Color.i, FileName.s, Position.i

UsePNGImageDecoder()

OpenWindow(#Window, 0, 0, 650, 650, "Панель вкладок (TabBar)", #PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_SizeGadget)

*tab1 = TabBar(#Gadget_TabBar, 0, 0, WindowWidth(#Window), #__tab_DefaultHeight, #__MASK_None, #Window)
AddItem(*tab1, #PB_Default, "В этом")
AddItem(*tab1, #PB_Default, "примере")
AddItem(*tab1, #PB_Default, "вы можете")
AddItem(*tab1, #PB_Default, "ощутить")
AddItem(*tab1, #PB_Default, "мощь")
AddItem(*tab1, #PB_Default, "Pure Basic")
AddItem(*tab1, #PB_Default, "и модуля")
AddItem(*tab1, #PB_Default, "TabBar")
AddItem(*tab1, #PB_Default, "для вкладок")
;ToolTip(*tab1, "%ITEM", "новая", "закрыть")

If ContainerGadget(#Gadget_Container, 0, GadgetHeight(#Gadget_TabBar), WindowWidth(#Window), WindowHeight(#Window)-GadgetHeight(#Gadget_TabBar), #PB_Container_Flat)
   
   If BorderGadget(#PB_Any, 5, 5, 170, 370, "Атрибуты панели")
      CheckBoxGadget(#Gadget_CloseTab, 10, 20, 130, 20, "кнопка закрытия вкладки")
      CheckBoxGadget(#Gadget_CloseSelectTab, 10, 40, 130, 20, "закрытие только активной")
      CheckBoxGadget(#Gadget_EmptyButton, 10, 60, 130, 20, "кнопка «новая» вкладка")
      CheckBoxGadget(#Gadget_CheckBox, 10, 80, 130, 20, "чекбокс на вкладке")
      CheckBoxGadget(#Gadget_Vertical, 10, 100, 130, 20, "вертикальная панель")
      CheckBoxGadget(#Gadget_MirroredTabs, 10, 120, 130, 20, "отзеркалить панель")
      CheckBoxGadget(#Gadget_ReverseOrdering, 10, 140, 130, 20, "обратный порядок")
      CheckBoxGadget(#Gadget_MultiLine, 10, 160, 130, 20, "многострочная панель")
      CheckBoxGadget(#Gadget_TextCutting, 10, 180, 130, 20, "обрезание текста")
      CheckBoxGadget(#Gadget_Editable, 10, 200, 130, 20, "редактирование текста")
      CheckBoxGadget(#Gadget_MultiSelect, 10, 220, 130, 20, "мультивыбор")
      CheckBoxGadget(#Gadget_NoTabMoving, 10, 240, 130, 20, "запрет перетаскивания")
      CheckBoxGadget(#Gadget_BottomLine, 10, 260, 130, 20, "нижняя линия")
      TextGadget(#PB_Any, 10, 285, 90, 20, "выравнивание:")
      SpinGadget(#Gadget_TabTextAlignment, 100, 280, 60, 20, -1, 1, #PB_Spin_Numeric)
      SetGadgetState(#Gadget_TabTextAlignment, GetAttribute(*tab1, #__MASK_TabTextAlignment))
      TextGadget(#PB_Any, 10, 305, 90, 20, "скругление углов:")
      SpinGadget(#Gadget_TabRounding, 100, 300, 60, 20, 0, 20, #PB_Spin_Numeric)
      SetGadgetState(#Gadget_TabRounding, GetAttribute(*tab1, #__MASK_TabRounding))
      TextGadget(#PB_Any, 10, 325, 90, 20, "мин. длина вкладки:")
      SpinGadget(#Gadget_MinTabLength, 100, 320, 60, 20, 0, 1000, #PB_Spin_Numeric)
      SetGadgetState(#Gadget_MinTabLength, GetAttribute(*tab1, #__MASK_MinTabLength))
      TextGadget(#PB_Any, 10, 345, 90, 20, "макс. длина вкладки:")
      SpinGadget(#Gadget_MaxTabLength, 100, 340, 60, 20, 0, 1000, #PB_Spin_Numeric)
      SetGadgetState(#Gadget_MaxTabLength, GetAttribute(*tab1, #__MASK_MaxTabLength))
      CloseGadgetList()
   EndIf
   
   If BorderGadget(#PB_Any, 180, 5, 375, 195, "Вкладки")
      TextGadget(#PB_Any, 10, 28, 50, 20, "Позиция:")
      ComboBoxGadget(#Gadget_Item, 60, 25, 100, 20)
      ButtonGadget(#Gadget_ItemBackColor, 10, 50, 100, 20, "цвет фона")
      ButtonGadget(#Gadget_ItemFrontColor, 115, 50, 100, 20, "цвет текста")
      TextGadget(#PB_Any, 10, 78, 30, 20, "Текст:")
      StringGadget(#Gadget_ItemText, 40, 75, 175, 20, GetText(*tab1))
      CheckBoxGadget(#Gadget_ItemDisabled, 10, 100, 100, 20, "отключена")
      CheckBoxGadget(#Gadget_ItemSelected, 10, 120, 100, 20, "выбрана")
      CheckBoxGadget(#Gadget_ItemChecked, 10, 140, 100, 20, "отмечена")
      CheckBoxGadget(#Gadget_ItemCloseTab, 210, 100, 100, 20, "кнопка закрытия")
      CheckBoxGadget(#Gadget_ItemCheckBox, 210, 120, 100, 20, "чекбокс")
      ButtonGadget(#Gadget_ItemImage, 10, 165, 100, 20, "картинка/иконка", #PB_Button_Toggle)
      CloseGadgetList()
   EndIf
   
   If BorderGadget(#PB_Any, 180, 210, 225, 120, "События")
      EditorGadget(#Gadget_Events, 10, 20, 200, 90, #PB_Editor_ReadOnly)
      CloseGadgetList()
   EndIf
   
   UpdateItemGadget(0)
   
EndIf

Procedure Window_Resize()
   
   If GetAttribute(*tab1, #__MASK_Vertical)
      ResizeGadget(#Gadget_TabBar, 10, 10, #PB_Ignore, WindowHeight(#Window)-20)
   Else
      ResizeGadget(#Gadget_TabBar, 10, 10, WindowWidth(#Window)-20, #PB_Ignore)
   EndIf
   
   ReDraw (*tab1)
   ResizeGadget(#Gadget_Container, 100, 100, WindowWidth(#Window)-150, WindowHeight(#Window)-150)
   
EndProcedure

BindEvent(#PB_Event_SizeWindow, @Window_Resize())
Window_Resize()


Repeat
   
   Select WaitWindowEvent()
         
      Case #PB_Event_CloseWindow
         
         End
         
      Case #PB_Event_SizeWindow
         
      Case #PB_Event_Gadget
         
         Select EventGadget()
            Case #Gadget_TabBar
               Select EventType()
                  Case #__EVENT_Change
                     AddGadgetItem(#Gadget_Events, 0, "Смена вкладки: "+Str(GetItemPosition(*tab1, #__tab_item_Event)))
                  Case #__EVENT_CheckBox
                     AddGadgetItem(#Gadget_Events, 0, "Чекбокс: "+Str(GetItemPosition(*tab1, #__tab_item_Event)))
                  Case #__EVENT_EditItem
                     AddGadgetItem(#Gadget_Events, 0, "Редактирование текста: "+Str(GetItemPosition(*tab1, #__tab_item_Event)))
                  Case #__EVENT_SwapItem
                     AddGadgetItem(#Gadget_Events, 0, "Перемещение вкладки: "+Str(GetItemPosition(*tab1, #__tab_item_Event)))
                  Case #__EVENT_NewItem
                     AddGadgetItem(#Gadget_Events, 0, "Новая вкладка: "+Str(GetItemPosition(*tab1, #__tab_item_Event)))
                     Position = AddItem(*tab1, #PB_Default, "Новая вкладка")
                     UpdateItemGadget(Position)
                  Case #__EVENT_ItemClose
                     AddGadgetItem(#Gadget_Events, 0, "Закрытие вкладки: "+Str(GetItemPosition(*tab1, #__tab_item_Event)))
                     Remove_Item(*tab1, #__tab_item_Event)
                  Case #__EVENT_Resize
                     AddGadgetItem(#Gadget_Events, 0, "Изменение размера")
                     Window_Resize()
               EndSelect
               UpdateItemAttributes(GetItemGadgetState())
            Case #Gadget_CloseTab
               SetAttribute(*tab1, #__MASK_CloseTab, GetGadgetState(#Gadget_CloseTab))
            Case #Gadget_CloseSelectTab
               SetAttribute(*tab1, #__MASK_CloseSelectTab, GetGadgetState(#Gadget_CloseSelectTab))
            Case #Gadget_EmptyButton
               SetAttribute(*tab1, #__MASK_NewTab, GetGadgetState(#Gadget_EmptyButton))
            Case #Gadget_Vertical
               SetAttribute(*tab1, #__MASK_Vertical, GetGadgetState(#Gadget_Vertical))
               Window_Resize()
            Case #Gadget_MirroredTabs
               SetAttribute(*tab1, #__MASK_MirroredTabs, GetGadgetState(#Gadget_MirroredTabs))
            Case #Gadget_TextCutting
               SetAttribute(*tab1, #__MASK_TextCutting, GetGadgetState(#Gadget_TextCutting))
            Case #Gadget_NoTabMoving
               SetAttribute(*tab1, #__MASK_NoTabMoving, GetGadgetState(#Gadget_NoTabMoving))
            Case #Gadget_TabRounding
               SetAttribute(*tab1, #__MASK_TabRounding, GetGadgetState(#Gadget_TabRounding))
            Case #Gadget_MultiLine
               SetAttribute(*tab1, #__MASK_MultiLine, GetGadgetState(#Gadget_MultiLine))
            Case #Gadget_BottomLine
               SetAttribute(*tab1, #__MASK_BottomLine, GetGadgetState(#Gadget_BottomLine))
            Case #Gadget_Editable
               SetAttribute(*tab1, #__MASK_Editable, GetGadgetState(#Gadget_Editable))
            Case #Gadget_MultiSelect
               SetAttribute(*tab1, #__MASK_MultiSelect, GetGadgetState(#Gadget_MultiSelect))
            Case #Gadget_CheckBox
               SetAttribute(*tab1, #__MASK_CheckBox, GetGadgetState(#Gadget_CheckBox))
            Case #Gadget_ReverseOrdering
               SetAttribute(*tab1, #__MASK_ReverseOrdering, GetGadgetState(#Gadget_ReverseOrdering))
            Case #Gadget_MinTabLength
               SetAttribute(*tab1, #__MASK_MinTabLength, GetGadgetState(#Gadget_MinTabLength))
            Case #Gadget_MaxTabLength
               SetAttribute(*tab1, #__MASK_MaxTabLength, GetGadgetState(#Gadget_MaxTabLength))
            Case #Gadget_TabTextAlignment
               SetAttribute(*tab1, #__MASK_TabTextAlignment, GetGadgetState(#Gadget_TabTextAlignment))
            Case #Gadget_Item
               SetGadgetText(#Gadget_ItemText, GetItemText(*tab1, GetItemGadgetState()))
               UpdateItemAttributes(GetItemGadgetState())
            Case #Gadget_ItemBackColor
               Color = GetItemColor(*tab1, GetState(*tab1), #PB_Gadget_BackColor)
               Color = ColorRequester(Color)
               If Color > -1
                  SetItemColor(*tab1, GetItemGadgetState(), #PB_Gadget_BackColor, Color)
               EndIf
            Case #Gadget_ItemFrontColor
               Color = GetItemColor(*tab1, GetState(*tab1), #PB_Gadget_FrontColor)
               Color = ColorRequester(Color)
               If Color > -1
                  SetItemColor(*tab1, GetItemGadgetState(), #PB_Gadget_FrontColor, Color)
               EndIf
            Case #Gadget_ItemText
               SetItemText(*tab1, GetItemGadgetState(), GetGadgetText(#Gadget_ItemText))
            Case #Gadget_ItemDisabled
               SetItemState(*tab1, GetItemGadgetState(), GetGadgetState(#Gadget_ItemDisabled)*#__STATEMASK_Disabled, #__STATEMASK_Disabled)
            Case #Gadget_ItemSelected
               SetItemState(*tab1, GetItemGadgetState(), GetGadgetState(#Gadget_ItemSelected)*#__STATEMASK_Selected, #__STATEMASK_Selected)
            Case #Gadget_ItemChecked
               SetItemState(*tab1, GetItemGadgetState(), GetGadgetState(#Gadget_ItemChecked)*#__STATEMASK_Checked, #__STATEMASK_Checked)
            Case #Gadget_ItemCloseTab
               SetItemAttribute(*tab1, GetItemGadgetState(), #__MASK_CloseTab, GetGadgetState(#Gadget_ItemCloseTab))
            Case #Gadget_ItemCheckBox
               SetItemAttribute(*tab1, GetItemGadgetState(), #__MASK_CheckBox, GetGadgetState(#Gadget_ItemCheckBox))
            Case #Gadget_ItemImage
               If GetGadgetState(#Gadget_ItemImage)
                  FileName = OpenFileRequester("Image", "", "Images (*.bmp;*.png)|*.bmp;*.png", 0)
                  If FileName And LoadImage(#Image, FileName)
                     SetItemImage(*tab1, GetItemGadgetState(), ImageID(#Image))
                  EndIf
               Else
                  SetItemImage(*tab1, GetItemGadgetState(), #Null)
               EndIf
         EndSelect
         
   EndSelect
   
ForEver
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 3125
; FirstLine = 3122
; Folding = --------------------------------------------------------------------------------
; Optimizer
; EnableXP