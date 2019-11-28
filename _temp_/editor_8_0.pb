; ++ надо исправить на последней строке ентер дает ошибку
; + если есть вертикальный скроллбар авто прокручивает в конец файла
; + горизонтальный скролл не перемешает текст если строка выбрана
; - при выделении не прокручивает текст
; - при перемещении корета вниз не прокручивается страница
; + если добавить слова в конец текста и нажать ентер есть ошибки
; + если добавить букву в конец текста потом убрать с помошью бекспейс затем нажать ентер то переносится удаленная буква
; + если выделить слова в одной строке и нажать бекспейс затем нажать ентер то переносятся удаленые слова
; + При переходе на предыдущую строку если переходящая строка длинее предыдушего была ошибка перемещения корета на предыдущей строке
; + когда выделяем 2-3 строки затем вырезаем затем ставляем, курсон не перемещается правильно
; + после запуска если шелкнуть в начале строки курсор оказывается в конце строки и строка выделяется полностью
; - если текст веденный спомощью settext() шире ширины виджета то additem() не работает

; Home - переместить курсор в начало строки 
; End - переместить курсор в конец строки 
; Ctrl-Home - переместить курсор в начало первой строки
; Ctrl-End - переместить курсор в конец последней строки 

; Crtl-A - Выбрать все 
; Crtl-C - копировать выделенный текст в буфер обмена 
; Crtl-V - вставить буфер обмена в позицию курсора 
; Crtl-X - вырезать и копировать выделенный текст в буфер обмена 


; Crtl-Up - переместить курсор в начало предыдущего абзаца.
; Ctrl-Down - переместить курсор в начало следующего абзаца 
; Crtl-Left - переместить курсор в начало предыдущего слова 
; Crtl-Right - переместить курсор в начало следующего слова. 



; http://www.hot-keys.ru/comment_1235822771.html
; Использование горячих клавиш для работы с текстом возможно практически в любой программе на вашем компьютере.
; Особенно примечательно то, что именно при работе с текстом, выгодно использовать клавиатуру «по полной программе», поскольку руки уже на ней!
; Для того, что б выделить, вырезать, вставить, удалить или переместить фрагмент текста, совершенно не обязательно каждый раз переносить руку на мышь. И, конечно, эти сочетания работают во всех текстовых редакторах. И в самом простом Notepad, и в профессиональном Word.
; Здесь и сейчас я приведу горячие клавиши для работы с обычным блокнотом – Notepad.
; Вызвать его из командной строки, то есть без помощи мышки можно следующим образом:
; Сначала нажатием клавиш Win+R вызвать командную строку (клавиша Win с логотипом windows – окном, в последней версии окно уже пластиковое :-). Ввести в командную строку слово notepad и нажать клавишу Enter.
; Обязательно сделайте это прямо сейчас!
; Получилось? Теперь скопируйте текст ниже, из этой страницы в блокнот! Запомнить все, сразу применив на практике, легче! Да еще и в самой программе.
; Собственно пройти этот урок вы можете в любое время, если сохраните этот открытый файл .txt со вставленным текстом. Тогда и Интернет отключать не придется :-)
; Урок по использованию горячих клавиш для работы с текстом:
; Перемещение: (< ^ > v этими закорючками обозначены клавиши стрелки, не путаете с символами возле Б и Ю)
; < ^ > v Попробуйте перемещать курсор, при помощи клавиш-стрелок.
; Конечно, этим Вас не удивишь, но все равно попрыгаете по тексту вниз, вправо, влево, вверх и вернитесь назад, нажав Ctrl+Home.
; Ctrl+>< Перемещение курсора на одно слово вправо или влево. Уже веселее! Перемещение по словам, происходит куда быстрее, чем по буквам. Надеюсь, Вы уже пробуете нажимать на стрелки вправо, влево, удерживая Ctrl.
; Попробовали? Опять нажмите Ctrl+Home и попробуйте перемещаться в конец и начало строки, нажимая клавиши:
; End и Home (обычно эти кнопки находятся чуть выше клавиш-стрелок)
; Попробовали? Получается?...
; Ctrl+Home перемещает курсор в начало текста, это Вы уже знаете, а вот
; Ctrl+End переместит курсор в самый конец текста! Тоже нажмите, не забыв вернуться :-)
; Назначение клавиш End и Home понятно из названия, а вот то, что они работают везде и всегда возьмите на заметку. Проверить сможете на любой странице в Интернет...
; Tab добавит 10 пробелов (все знают, никто не считал), соответственно Backspase вернет курсор на десять пробелов назад, а нажатие Enter перенесет курсор к следующей строке, обычно нажатием Enter заканчивают строку.
; А вот если курсор переместить в середину текста и нажать Enter, он тоже перейдет на следующую строку причем вместе с тем текстом, который справа от него. Backspase вернет все на место.
; Попробуйте все это, немного "покалечив" этот текст.
; Выделение:
; Ctrl+A Выделит весь текст, всегда и везде! А именно здесь выделит все, с одновременным переносом курсора в конец текста.
; Нажмите сейчас Ctrl+A, потом Ctrl+C, потом Win+R (в строке должна была сохраниться запись - notepad) если да, жмем Enter (если нет, набираем notepad, потом жмем Enter), потом Ctrl+V, теперь Alt+F4, стрелку (>)вправо и Enter.
; Этим мы выделили весь текст, скопировали его, вызвали блокнот через командную строку, вставили в новый документ весь текст, потом удовлетворенно, закрыли новый документ, не сохранив, ничего.
; Могли и сохранить, конечно, но и так забежали немного вперед.
; Забежали, чтоб понять, в каком случае часто применяется сочетание Ctrl+A (выделить все!).
; Shift+>< Выделение по буквам. Удерживание Shift во время перемещения клавишами стрелками будет выделять текст в зависимости от направления стрелки. Вправо-влево выделение по одной букве, вниз-вверх по одной строке. Попробовать это, чтоб понять, намного легче, чем вникать в любые объяснения. Посему, попробуйте!
; Часто выделить мышью с точностью до одной буквы просто не возможно! С Шифтом такого не бывает!
; Помните, удерживая Ctrl, мы перемещали курсор по словам? Так вот, если "разбавить" эту комбинацию Шифтом, мы будем выделять по словам, соответственно.
; Пробуйте сейчас!
; Так же по аналогии:
; Shift+Home Выделить до начала строки
; Shift+End Выделить до конца строки
; Ctrl+Shift+Home Выделить до начала текста
; Ctrl+Shift+End Выделить до конца текста
; Попробуйте все четыре, в зависимости от места расположения курсора...
; Удаление:
; Delete удаление символа справа от курсора или удаление чего-то выделенного.
; Backspace и Shift+Delete удаление символа слева от курсора.
; Ctrl+Delete удаление символов справа до конца строки.
; Кнопка тоже говорит сама за себя и используется вместе с модификаторами Ctrl и Shift.
; Запомнить не трудно, посему и потренируйтесь на этой строке... удалив ее.
; Группа сочетаний "под левую руку"
; Вырезание:
; Ctrl+X вырезать предварительно выделенное.
; Вырезают понятно для того, что б, куда нибудь вставить. Вырезать можно один раз, а вставить несколько.
; Отмена:
; Ctrl+Z отменить последнее действие. Самое время вспомнить об этом сочетании, поскольку нужда в нем возникает, обычно после удаления или вырезания.
; Благодаря этому сочетанию "отмерять семь раз" совсем не обязательно!
; Это действие дает возможность исправить любую ошибку, просто отменив ошибочное действие и вернув все в исходное состояние. Проверим?
; Нажмите Ctrl+А теперь внимание! Запомнили о Ctrl+Z ? Нажмите Delete, а потом Ctrl+Z !!! Надеюсь, мы снова вместе...
; Копирование, Вставка:
; Ctrl+C копировать! Это мы любим... В Интернет часто работают такие сочетания Ctrl+А плюс Ctrl+C плюс Ctrl+V = плагиат :-)
; Ctrl+V вставить! Эти сочетания, во истину лидеры среди себе подобных. Не использовать их просто грех :-) Насколько я помню, Вы уже делали копи-паст выше по тексту.
; Касается работы с текстом и вставка символа:
; Alt+Число вставить символ! Удерживая Alt, наберите любое число на дополнительной цифровой клавиатуре. Например, у меня при наборе Alt+753 появляется буква ё, хотя её и в помине нет на моей клавиатуре (я нахожусь в Армении)
; А символ "собака" получается нажатием Alt+64. В общем, с этим сочетанием экспериментируйте...
; Сохранение:
; Ctrl+S сохранить!
; Ничего особенного вроде бы нет, но когда после 15 минут (а то и больше) работы с документом отключат свет, Вы вспомните, что Ctrl+S(свет) надо было время от времени нажимать.
; Я, например, нажимаю после каждой записанной законченной мысли. Хотя если вы за ноутбуком, Вам это не грозит, как и при наличии "бесперебойника".
; Во всех других случаях, если Вы творите, а не созерцаете, время от времени прижимайте Ctrl+S(свет), работает почти везде.
; Поиск и замена:
; Ну и напоследок пару слов о поиске текста. Иногда бывает нужно организовать поиск слова или фразы по одному единственному документу. Делается это в две секунды нажатием:
; Ctrl+F найти букву, слово, текст. Попробуйте найти в этом тексте слово Собака (кроме этого)
; Получилось? :-) Внимательно рассмотрите диалоговое окно поиска, авось пригодится.
; Ctrl+H найти и заменить используется редко, но зато находит и заменяет метко! Об этом не мешает знать.

;                                                                              MAC — OS
;                                                              Page Up и Page Down — прокрутка содержимого страницы вверх или вниз.
;                              fn + Backspace — аналог клавиши Delete в Windows PC — удаление символов в тексте, если курсор находится перед словом.
;                                                  Alt + Page Up и Alt + Page Down — прокрутка текста вверх и вниз с шагом в один экран.
;                                     ⌘Cmd + стрелка влево и ⌘Cmd + стрелка вправо — перемещение курсора в начало или конец строки.
;                   ⌥Option (Alt) + стрелка влево и ⌥Option (Alt) + стрелка вправо — перемещение курсора в начало или конец слова.
;                     ⌥Option (Alt) + стрелка вверх и ⌥Option (Alt) + стрелка вниз — перемещение курсора в начало или конец текущего абзаца.
;                                       ⌘Cmd + стрелка вверх и ⌘Cmd + стрелка вниз — перемещение курсора в начало или конец текста.
;                                 ⇧Shift + стрелка влево и ⇧Shift + стрелка вправо — посимвольное выделение текста слева или справа от курсора.
; ⇧Shift + ⌥Option (Alt) + стрелка влево и ⇧Shift + ⌥Option (Alt) + стрелка вправо — выделение текста слева или справа от курсора по словам.
;                   ⇧Shift + ⌘Cmd + стрелка влево и ⇧Shift + ⌘Cmd + стрелка вправо — выделение текста влево или вправо от курсора до конца строки.
;                                   ⇧Shift + стрелка вверх и ⇧Shift + стрелка вниз — выделение текста от курсора вверх или вниз по строчкам.
;   ⇧Shift + ⌥Option (Alt) + стрелка вверх и ⇧Shift + ⌥Option (Alt) + стрелка вниз — выделение текста от курсора вверх или вниз до начала или конца абзаца.
;                     ⇧Shift + ⌘Cmd + стрелка вверх и ⇧Shift + ⌘Cmd + стрелка вниз — выделение текста от курсора вверх или вниз до начала или конца текста.
;                                                           ⌥Option (Alt) + Delete — удаление всех символов слева от курсора в пределах слова.
;                                                                    ⌘Cmd + Delete — удаление всех символов слева от курсора в пределах строки.

DeclareModule Macros
  Macro isItem(_item_, _list_)
    Bool(_item_ >= 0 And _item_ < ListSize(_list_))
  EndMacro
  
  Macro itemSelect(_item_, _list_)
    Bool(isItem(_item_, _list_) And _item_ <> ListIndex(_list_) And SelectElement(_list_, _item_))
  EndMacro
  
  Macro add_widget(_widget_, _hande_)
    If _widget_ =- 1 Or _widget_ > ListSize(List()) - 1
      LastElement(List())
      _hande_ = AddElement(List()) 
      _widget_ = ListIndex(List())
    Else
      _hande_ = SelectElement(List(), _widget_)
      ; _hande_ = InsertElement(List())
      PushListPosition(List())
      While NextElement(List())
        List()\widget\index = ListIndex(List())
      Wend
      PopListPosition(List())
    EndIf
  EndMacro
  
  Macro _frame_(_this_, _x_,_y_,_width_,_height_, _color_1_, _color_2_);, _round_=0)
    ClipOutput(_x_-1,_y_-1,_width_+1,_height_+1)
    RoundBox(_x_-1,_y_-1,_width_+2,_height_+2, _this_\round,_this_\round, _color_1_)  
    
    ClipOutput(_x_+_this_\round/3,_y_+_this_\round/3,_width_+2,_height_+2)
    RoundBox(_x_-1,_y_-1,_width_+2,_height_+2,_this_\round,_this_\round, _color_2_)  
    
    ;     If _round_ And _this_\round : RoundBox(_x_,_y_-1,_width_,_height_+1,_this_\round,_this_\round,_color_1_) : EndIf  ; Сглаживание краев )))
    ;     If _round_ And _this_\round : RoundBox(_x_-1,_y_-1,_width_+1,_height_+1,_this_\round,_this_\round,_color_1_) : EndIf  ; Сглаживание краев )))
    
    UnclipOutput() ;: _clip_output_(_this_, _this_\x[1]-1,_this_\y[1]-1,_this_\width[1]+2,_this_\height[1]+2)
  EndMacro
  
  Macro BoxGradient(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _round_=0, _alpha_=255)
    BackColor(_color_1_&$FFFFFF|_alpha_<<24)
    FrontColor(_color_2_&$FFFFFF|_alpha_<<24)
    If _type_
      LinearGradient(_x_,_y_, (_x_+_width_), _y_)
    Else
      LinearGradient(_x_,_y_, _x_, (_y_+_height_))
    EndIf
    RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
  EndMacro
  
  Macro _colors_(_adress_, _i_, _ii_, _iii_)
    ; Debug ""+_i_+" "+ _ii_+" "+ _iii_
    
    If _adress_\color[_i_]\line[_ii_]
      _adress_\color[_i_]\line[_iii_] = _adress_\color[_i_]\line[_ii_]
    Else
      _adress_\color[_i_]\line[_iii_] = _adress_\color[0]\line[_ii_]
    EndIf
    
    If _adress_\color[_i_]\fore[_ii_]
      _adress_\color[_i_]\fore[_iii_] = _adress_\color[_i_]\fore[_ii_]
    Else
      _adress_\color[_i_]\fore[_iii_] = _adress_\color[0]\fore[_ii_]
    EndIf
    
    If _adress_\color[_i_]\back[_ii_]
      _adress_\color[_i_]\back[_iii_] = _adress_\color[_i_]\back[_ii_]
    Else
      _adress_\color[_i_]\back[_iii_] = _adress_\color[0]\back[_ii_]
    EndIf
    
    If _adress_\color[_i_]\front[_ii_]
      _adress_\color[_i_]\front[_iii_] = _adress_\color[_i_]\front[_ii_]
    Else
      _adress_\color[_i_]\front[_iii_] = _adress_\color[0]\front[_ii_]
    EndIf
    
    If _adress_\color[_i_]\frame[_ii_]
      _adress_\color[_i_]\frame[_iii_] = _adress_\color[_i_]\frame[_ii_]
    Else
      _adress_\color[_i_]\frame[_iii_] = _adress_\color[0]\frame[_ii_]
    EndIf
  EndMacro
  
  Macro ResetColor(_adress_)
    
    _colors_(_adress_, 0, 1, 0)
    
    _colors_(_adress_, 1, 1, 0)
    _colors_(_adress_, 2, 1, 0)
    _colors_(_adress_, 3, 1, 0)
    
    _colors_(_adress_, 1, 1, 1)
    _colors_(_adress_, 2, 1, 1)
    _colors_(_adress_, 3, 1, 1)
    
    _colors_(_adress_, 1, 2, 2)
    _colors_(_adress_, 2, 2, 2)
    _colors_(_adress_, 3, 2, 2)
    
    _colors_(_adress_, 1, 3, 3)
    _colors_(_adress_, 2, 3, 3)
    _colors_(_adress_, 3, 3, 3)
    
  EndMacro
  
  Macro Distance(_mouse_x_, _mouse_y_, _position_x_, _position_y_, _round_)
    Bool(Sqr(Pow(((_position_x_+_round_) - _mouse_x_),2) + Pow(((_position_y_+_round_) - _mouse_y_),2)) =< _round_)
  EndMacro
  
  Macro Max(_a_, _b_)
    ((_a_) * Bool((_a_) > = (_b_)) + (_b_) * Bool((_b_) > (_a_)))
  EndMacro
  
  Macro Min(_a_, _b_)
    ((_a_) * Bool((_a_) < = (_b_)) + (_b_) * Bool((_b_) < (_a_)))
  EndMacro
  
  Macro SetBit(_var_, _bit_) ; Установка бита.
    _var_ | (_bit_)
  EndMacro
  
  Macro ClearBit(_var_, _bit_) ; Обнуление бита.
    _var_ & (~(_bit_))
  EndMacro
  
  Macro InvertBit(_var_, _bit_) ; Инвертирование бита.
    _var_ ! (_bit_)
  EndMacro
  
  Macro TestBit(_var_, _bit_) ; Проверка бита (#True - установлен; #False - обнулен).
    Bool(_var_ & (_bit_))
  EndMacro
  
  Macro NumToBit(_num_) ; Позиция бита по его номеру.
    (1<<(_num_))
  EndMacro
  
  Macro GetBits(_var_, _start_pos_, _end_pos_)
    ((_var_>>(_start_pos_))&(NumToBit((_end_pos_)-(_start_pos_)+1)-1))
  EndMacro
  
  Macro CheckFlag(_mask_, _flag_)
    ((_mask_ & _flag_) = _flag_)
  EndMacro
  
  Macro _set_scroll_height_(_this_)
    If Not _this_\hide And Not _this_\items()\hide
      _this_\scroll\height+_this_\text\height
      ; _this_\scroll\v\max = _this_\scroll\height
    EndIf
  EndMacro
  
  Macro _set_scroll_width_(_this_)
    If Not _this_\items()\hide And
       _this_\scroll\width<(_this_\items()\text\x+_this_\items()\text\width)-_this_\x
      _this_\scroll\width=(_this_\items()\text\x+_this_\items()\text\width)-_this_\x
      
      _this_\text\_scroll_line_index = _this_\items()\index ; Позиция в тексте самой длинной строки
      
      ; _this_\scroll\h\max = _this_\scroll\width
      ; Debug "   "+_this_\width +" "+ _this_\scroll\width
    EndIf
  EndMacro
  
  ;   Macro _set_line_pos_(_this_)
  ;     _this_\items()\text\pos = _this_\text\pos
  ;     _this_\items()\text\len = Len(_this_\items()\text\string.s)
  ;     _this_\text\pos + _this_\items()\text\len + 1 ; Len(#LF$)
  ;   EndMacro
  
  Macro RowBackColor(_this_, _state_)
    _this_\row\color\back[_state_]&$FFFFFFFF|_this_\row\color\alpha<<24
  EndMacro
  Macro RowForeColor(_this_, _state_)
    _this_\row\color\fore[_state_]&$FFFFFFFF|_this_\row\color\alpha<<24
  EndMacro
  Macro RowFrameColor(_this_, _state_)
    _this_\row\color\frame[_state_]&$FFFFFFFF|_this_\row\color\alpha<<24
  EndMacro
  Macro RowFontColor(_this_, _state_)
    _this_\color\front[_state_]&$FFFFFFFF|_this_\row\color\alpha<<24
  EndMacro
  
  Macro _set_open_box_XY_(_this_, _items_, _x_, _y_)
    If (_this_\flag\buttons Or _this_\flag\lines) 
      _items_\box\width = _this_\flag\buttons
      _items_\box\height = _this_\flag\buttons
      _items_\box\x = _x_+_items_\sublevellen-(_items_\box\width)/2
      _items_\box\y = (_y_+_items_\height)-(_items_\height+_items_\box\height)/2
    EndIf
  EndMacro
  
  Macro _set_check_box_XY_(_this_, _items_, _x_, _y_)
    If _this_\flag\checkBoxes
      _items_\box\width[1] = _this_\flag\checkBoxes
      _items_\box\height[1] = _this_\flag\checkBoxes
      _items_\box\x[1] = _x_+(_items_\box\width[1])/2
      _items_\box\y[1] = (_y_+_items_\height)-(_items_\height+_items_\box\height[1])/2
    EndIf
  EndMacro
  
  Macro _draw_plots_(_this_, _items_, _x_, _y_)
    ; Draw plot
    If _this_\sublevellen And _this_\flag\lines 
      Protected line_size = _this_\flag\lines
      Protected x_point=_x_+_items_\sublevellen
      
      If x_point>_this_\x[2] 
        Protected y_point=_y_
        
        If Drawing
          ; Horizontal plot
          DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@PlotX())
          Line(x_point,y_point,line_size,1, $FF000000)
        EndIf
        
        ; Vertical plot
        If _items_\handle
          Protected start = _items_\sublevel
          
          ; это нужно если линия уходит за предели границы виджета
          If _items_\handle[1]
            PushListPosition(_items_)
            ChangeCurrentElement(_items_, _items_\handle[1]) 
            ;If \hide : Drawing = 2 : EndIf
            PopListPosition(_items_)
          EndIf
          
          PushListPosition(_items_)
          ChangeCurrentElement(_items_, _items_\handle) 
          If Drawing  
            If start
              If _this_\sublevellen > 10
                start = (_items_\y+_items_\height+_items_\height/2) + _this_\scroll\y - line_size
              Else
                start = (_items_\y+_items_\height/2) + _this_\scroll\y
              EndIf
            Else 
              start = (_this_\y[2]+_items_\height/2)+_this_\scroll\y
            EndIf
            
            DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@PlotY())
            Line(x_point,start,1, (y_point-start), $FF000000)
          EndIf
          PopListPosition(_items_)
        EndIf
      EndIf
    EndIf
  EndMacro
  
  ; val = %10011110
  ; Debug Bin(GetBits(val, 0, 3))
  
EndDeclareModule 

Module Macros
  
EndModule 

UseModule Macros


DeclareModule Constants
  #VectorDrawing = 0
  
  ;CompilerIf #VectorDrawing
  ;  UseModule Draw
  ;CompilerEndIf
  
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  
  ;- - DECLAREs CONSTANTs
  ;{
  #__round = 7
  #__draw_clip_box = 0
  #__draw_scroll_box = 1
  #__debug_events_tab = 0
  #__padding_text = 5
  #__sOC = SizeOf(Character)
  #__border_scroll = 2
  #__spin_buttonsize2 = 15
  #__spin_buttonsize = 18
  
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    CompilerIf (#PB_Compiler_Version<547) : #PB_EventType_Resize : CompilerEndIf
    
    #PB_EventType_Free
    #PB_EventType_create
    #PB_EventType_Drop
    
    #PB_EventType_Repaint
    #PB_EventType_ScrollChange
  EndEnumeration
  
  #__Anchors = 9+4
  
  #__A_moved = 9
  #__Arrow_type = 1
  
  ;bar buttons
  Enumeration
    #__b_1 = 1
    #__b_2 = 2
    #__b_3 = 3
  EndEnumeration
  
  ;bar position
  Enumeration
    #__bp_0 = 0
    #__bp_1 = 1
    #__bp_2 = 2
    #__bp_3 = 3
  EndEnumeration
  
  ;element position
  Enumeration
    #last =- 1
    #first = 0
    #prev = 1
    #next = 2
    #__before = 3
    #__After = 4
  EndEnumeration
  
  ;element coordinate 
  Enumeration
    #__c_0 = 0 ; 
    #__c_1 = 1 ; frame
    #__c_2 = 2 ; inner
    #__c_3 = 3 ; container
    #__c_4 = 4 ; clip
  EndEnumeration
  
  ;color state
  Enumeration
    #__s_0
    #__s_1
    #__s_2
    #__s_3
  EndEnumeration
  
  ;color state
  Enumeration
    #Normal
    #Entered
    #__selected
    #__disabled
  EndEnumeration
  
  Enumeration 1
    #__Color_Front
    #__Color_Back
    #__Color_Line
    #__Color_TitleFront
    #__Color_TitleBack
    #__Color_GrayText 
    #__Color_Frame
  EndEnumeration
  
  #PB_GadgetType_Popup =- 10
  #PB_GadgetType_Property = 40
  #PB_GadgetType_Window =- 1
  #PB_GadgetType_Root =- 5
  ;
  #__flag_NoButtons = #PB_Tree_NoButtons                     ; 2 1 Hide the '+' node buttons.
  #__flag_NoLines = #PB_Tree_NoLines                         ; 1 2 Hide the little lines between each nodes.
  #__flag_Checkboxes = #PB_Tree_CheckBoxes                   ; 4 256 Add a checkbox before each Item.
                                                             ; #__flag_ThreeState = #PB_Tree_ThreeState                   ; 8 65535 The checkboxes can have an "in between" state.
  
  EnumerationBinary
    #___Text
    #___Image
    
    #___Center
    #___Right
    #___Left
    #___Top
    #___Bottom
    #___Vertical 
    #___Horizontal
  EndEnumeration
  
  EnumerationBinary WidgetFlags
    #__flag_Center
    #__flag_Right
    #__flag_Left
    #__flag_Top
    #__flag_Bottom
    #__flag_Vertical 
    #__flag_Horizontal
    
    #__flag_AutoSize
    ;#__flag_AutoRight
    ;#__flag_AutoBottom
    
    #__flag_Numeric
    #__flag_ReadOnly
    #__flag_LowerCase 
    #__flag_UpperCase
    #__flag_Password
    #__flag_WordWrap
    #__flag_MultiLine 
    #__flag_InLine
    
    #__flag_BorderLess
    ;         #__flag_Double
    ;         #__flag_Flat
    ;         #__flag_Raised
    ;         #___s_flagingle
    
    #__flag_AnchorsGadget
    
    
    #__flag_OptionBoxes
    #__flag_ThreeState
    #__flag_Collapse
    
    #__flag_GridLines
    #__flag_Invisible
    
    #__flag_MultiSelect
    #__flag_ClickSelect
    
    #__flag_FullSelection
    #__flag_NoGadget
    #__flag_NoActivate
    
    ;#__flag_Default
    #__flag_Inverted
    ;#__flag_Middle
    #__flag_AlwaysSelection ; = 32 ; #PB_Tree_AlwaysShowSelection ; 0 32 Even If the gadget isn't activated, the selection is still visible.
    
    
    #__flag_Limit
  EndEnumeration
  
  #__tree_Collapse = #__flag_Collapse
  #__tree_OptionBoxes = #__flag_OptionBoxes
  #__tree_AlwaysSelection = #__flag_FullSelection
  #__tree_CheckBoxes = 512
  #__tree_NoLines = #__flag_NoLines
  #__tree_NoButtons = #__flag_NoButtons
  #__tree_GridLines = #__flag_GridLines
  #__tree_ThreeState = #__flag_ThreeState
  #__tree_ClickSelect = #__flag_ClickSelect
  #__tree_MultiSelect = #__flag_MultiSelect
  #__tree_BorderLess = #__flag_BorderLess
  
  
  EnumerationBinary #__flag_Numeric;1
    #__bar_Minimum 
    #__bar_Maximum 
    #__bar_PageLength 
    
    ;#__bar_ArrowSize 
    #__bar_ButtonSize 
    #___s_barcrollStep
    #__bar_Direction 
    #__bar_Ticks
    #__bar_Reverse
    #__bar_Inverted 
    
    #__bar_Vertical = #__flag_Vertical
  EndEnumeration
  
  If (#__flag_Limit>>1) > 2147483647 ; 8589934592
    Debug "Исчерпан лимит в x32 ("+Str(#__flag_Limit>>1)+")"
  EndIf
  
  #__flag_Full = #__flag_Left|#__flag_Right|#__flag_Top|#__flag_Bottom
  
  
  ;   ; Set/Get Attribute
  #__DisplayMode = 1<<13
  ;   #PB_Image = 1<<13
  ;   #PB_Text = 1<<14
  ;   #PB_Flag = 1<<15
  ;   #PB_State = 1<<16
  
  
  EnumerationBinary Text
    #__text_Center = #__flag_Horizontal
    #__text_Right = #__flag_Right
    ;     #PB_Button_Toggle = 4
    ;     #PB_Button_Default = 8
    
    #__text_MultiLine = #__flag_MultiLine
    #__text_Numeric = #__flag_Numeric
    
    ;     #PB_Widget_BorderLess = #PB_String_BorderLess 
    ;     #PB_Widget_Vertical
    
    #__text_Password = #__flag_Password; = 128
    #__text_ReadOnly = #__flag_ReadOnly
    #__text_LowerCase = #__flag_LowerCase
    #__text_UpperCase = #__flag_UpperCase
    #__text_WordWrap = #__flag_WordWrap
    
    #__text_Bottom = #__flag_Bottom
    #__text_Middle = #__flag_Vertical
    #__text_Left = #__flag_Left
    #__text_Top = #__flag_Top
    
    #__text_Invert = #__flag_Inverted
    
    
    #__button_default 
    #__button_toggle
  EndEnumeration
  
  ;}
  
EndDeclareModule 

Module Constants
  
EndModule 

UseModule Constants

;-
DeclareModule Structures
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    ; PB Interne Struktur Gadget MacOS
    Structure sdkGadget
      *gadget
      *container
      *vt
      UserData.i
      Window.i
      Type.i
      Flags.i
    EndStructure
  CompilerEndIf
  
  ;- STRUCTURE
  ;- - _s_point
  Structure _s_point
    y.i
    x.i
  EndStructure
  
  ;- - _s_coordinate
  Structure _s_coordinate
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
  EndStructure
  
  ;- - _s_mouse
  Structure _s_mouse
    X.i
    Y.i
    from.i ; at point widget
    Wheel.i; delta
    Buttons.i ; state
    *Delta._s_mouse
  EndStructure
  
  ;- - _S_keyboard
  Structure _S_keyboard
    change.b
    input.c
    key.i[2]
  EndStructure
  
  ;- - _s_align
  Structure _s_align
    Right.b
    Bottom.b
    Vertical.b
    Horizontal.b
  EndStructure
  
  ;- - _s_page
  Structure _s_page
    Pos.i
    len.i
    *end
    ScrollStep.i
  EndStructure
  
  ;- - _s_color
  Structure _s_color
    State.b
    Front.i[4]
    Fore.i[4]
    Back.i[4]
    Line.i[4]
    Frame.i[4]
    Alpha.a[2]
  EndStructure
  
  ;- - _s_flag
  Structure _s_flag
    InLine.b
    Lines.b
    Buttons.b
    GridLines.b
    CheckBoxes.b
    FullSelection.b
    AlwaysSelection.b
    MultiSelect.b
    ClickSelect.b
  EndStructure
  
  ;- - _s_image
  Structure _s_image Extends _s_coordinate
    handle.i[2]
    change.b
    Align._s_align
  EndStructure
  
  ;- - _S_caret
  Structure _S_caret
    x.l
    y.l
    width.l
    height.l
    
    len.l
    
    *pos
    *end
  EndStructure
  
  ;- - _s_text
  Structure _s_text Extends _s_coordinate
    ;     ;     Char.c
    
    _scroll_line_index.l
    
    pos.l
    len.l
    caret._S_caret
    
    fontID.i
    string.s[3]
    change.b
    count.l
    
    pass.b
    lower.b
    upper.b
    numeric.b
    editable.b
    multiLine.b
    rotate.f
    padding.l
    
    align._S_align
  EndStructure
  
  ;- - _s_bar
  Structure _s_bar Extends _s_coordinate
    *s._s_scroll
    Type.i
    Widget.i
    round.i
    ArrowSize.b[3]
    ArrowType.b[3]
    
    from.i
    
    Hide.b[2]
    Disable.b[2]
    
    Max.i
    Min.i
    Vertical.b
    Page._s_page
    Area._s_page
    Thumb._s_page
    Button._s_page
    Color._s_color[4]
  EndStructure
  
  ;- - _s_events
  Structure _s_post
    Gadget.i
    Window.i
    Widget.i
    Type.i
    Event.i
    *Function
  EndStructure
  
  ;- - _s_scroll
  Structure _s_scroll Extends _s_coordinate
    Post._s_post
    
    *v._s_bar
    *h._s_bar
  EndStructure
  
  ;- - _s_margin
  Structure _s_margin
    FonyID.i
    Width.i
    Color._s_color
  EndStructure
  
  ;- - _s_scintilla
  Structure _s_scintilla
    Margin._s_margin
  EndStructure
  
  ;- - _s_row
  Structure _s_row Extends _s_coordinate
    Color._s_color
  EndStructure
  
  ;- - _s_color
  Structure Colors_S
    State.b
    ;     Front.i[4]
    ;     Fore.i[4]
    ;     Back.i[4]
    ;     Line.i[4]
    ;     Frame.i[4]
    ;      Alpha.a[2]
  EndStructure
  
  ;- - _s_rows
  Structure _s_rows Extends _s_coordinate
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    handle.i[2]
    
    Color.Colors_S
    Text._s_text[4]
    Image._s_image
    box._s_coordinate
    
    Hide.b[2]
    ;Caret.i[3] ; 0 = Pos ; 1 = PosFixed
    
    Focus.i
    LostFocus.i
    
    Checked.b[2]
    Vertical.b
    round.i
    
    draw.l
    change.b
    sublevel.l
    sublevellen.l
    
    collapsed.b
    childrens.i
    *data  ; set/get item data
  EndStructure
  
  ;- - _s_widget
  Structure _s_widget Extends _s_coordinate
    type.l
    handle.i    ; Adress of new list element
    index.l[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    
    *widget._s_widget
    *root._s_root
    
    Sci._s_scintilla
    color._s_color
    text._s_text[4]
    clip._s_coordinate
    scroll._s_scroll
    image._s_image
    flag._s_flag
    
    bs.b
    fs.b[2]
    hide.b[2]
    disable.b[2]
    interact.b ; будет ли взаимодействовать с пользователем?
    cursor.i[2]
    
    countitems.l
    
    focus.i
    
    Drag.b[2]
    Resize.b ; 
    
    *data
    change.b
    round.i
    vertical.b
    sublevellen.i
    
    attribute.i
    
    *Default
    row._s_row
    List Items._s_rows()
    List Lines._s_rows()
    List Columns._s_widget()
    Repaint.i ; Будем посылать сообщение что надо перерисовать а после надо сбрасывать переменую
  EndStructure
  
  ;- - _s_root
  Structure _s_root
    canvas.i
    window.i
    
    mouse._s_mouse
    keyboard._S_keyboard
  EndStructure
  
  ;-
  ;- Colors
  ; $FF24B002 ; $FFD5A719 ; $FFE89C3D ; $FFDE9541 ; $FFFADBB3 ;
  Global Colors._s_color
  With Colors                          
    \state = 0
    
    ;- Серые цвета 
    ;     ; Цвета по умолчанию
    ;     \front[0] = $FF000000
    ;     \fore[0] = $FFFCFCFC ; $FFF6F6F6 
    ;     \back[0] = $FFE2E2E2 ; $FFE8E8E8 ; 
    ;     \line[0] = $FFA3A3A3
    ;     \frame[0] = $FFA5A5A5 ; $FFBABABA
    ;     
    ;     ; Цвета если мышь на виджете
    ;     \front[1] = $FF000000
    ;     \fore[1] = $FFF5F5F5 ; $FFF5F5F5 ; $FFEAEAEA
    ;     \back[1] = $FFCECECE ; $FFEAEAEA ; 
    ;     \line[1] = $FF5B5B5B
    ;     \frame[1] = $FF8F8F8F
    ;     
    ;     ; Цвета если нажали на виджет
    ;     \front[2] = $FFFFFFFF
    ;     \fore[2] = $FFE2E2E2
    ;     \back[2] = $FFB4B4B4
    ;     \line[2] = $FFFFFFFF
    ;     \frame[2] = $FF6F6F6F
    
    ;- Зеленые цвета
    ;             ; Цвета по умолчанию
    ;             \front[0] = $FF000000
    ;             \fore[0] = $FFFFFFFF
    ;             \back[0] = $FFDAFCE1  
    ;             \frame[0] = $FF6AFF70 
    ;             
    ;             ; Цвета если мышь на виджете
    ;             \front[1] = $FF000000
    ;             \fore[1] = $FFE7FFEC
    ;             \back[1] = $FFBCFFC5
    ;             \frame[1] = $FF46E064 ; $FF51AB50
    ;             
    ;             ; Цвета если нажали на виджет
    ;             \front[2] = $FFFEFEFE
    ;             \fore[2] = $FFC3FDB7
    ;             \back[2] = $FF00B002
    ;             \frame[2] = $FF23BE03
    
    ;- Синие цвета
    ; Цвета по умолчанию
    \front[0] = $80000000
    \fore[0] = $FFF8F8F8 
    \back[0] = $80E2E2E2
    \frame[0] = $80C8C8C8
    
    ; Цвета если мышь на виджете
    \front[1] = $80000000
    \fore[1] = $FFFAF8F8
    \back[1] = $80FCEADA
    \frame[1] = $80FFC288
    
    ; Цвета если нажали на виджет
    \front[2] = $FFFEFEFE
    \fore[2] = $FFE9BA81;$C8FFFCFA
    \back[2] = $FFE89C3D; $80E89C3D
    \frame[2] = $FFDC9338; $80DC9338
    
    ;         ;- Синие цвета 2
    ;         ; Цвета по умолчанию
    ;         \front[0] = $FF000000
    ;         \fore[0] = $FFF8F8F8 ; $FFF0F0F0 
    ;         \back[0] = $FFE5E5E5
    ;         \frame[0] = $FFACACAC 
    ;         
    ;         ; Цвета если мышь на виджете
    ;         \front[1] = $FF000000
    ;         \fore[1] = $FFFAF8F8 ; $FFFCF4EA
    ;         \back[1] = $FFFAE8DB ; $FFFCECDC
    ;         \frame[1] = $FFFC9F00
    ;         
    ;             ; Цвета если нажали на виджет
    ;             \front[2] = $FF000000;$FFFFFFFF
    ;             \fore[2] = $FFFDF7EF
    ;             \back[2] = $FFFBD9B7
    ;             \frame[2] = $FFE59B55
    
  EndWith
  
  Global *Focus._s_widget
  Global NewList List._s_widget()
  Global Use_List_Canvas_Gadget
  
EndDeclareModule 

Module Structures 
  
EndModule 

UseModule Structures

DeclareModule Scroll
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  ; ; DeclareModule Scroll
  ; ;   EnableExplicit
  ; ;   
  ; ;   ;- - STRUCTUREs
  ; ;   ;- - _s_coordinate
  ; ;   Structure _s_coordinate
  ; ;     y.i[4]
  ; ;     x.i[4]
  ; ;     height.i[4]
  ; ;     width.i[4]
  ; ;   EndStructure
  ; ;   
  ; ;   ;- - _s_color
  ; ;   Structure _s_color
  ; ;     State.b ; entered; selected; focused; lostfocused
  ; ;     Front.i[4]
  ; ;     Line.i[4]
  ; ;     Fore.i[4]
  ; ;     Back.i[4]
  ; ;     Frame.i[4]
  ; ;     Alpha.a[2]
  ; ;   EndStructure
  ; ;   
  ; ;   ;- - _s_page
  ; ;   Structure _s_page
  ; ;     Pos.i
  ; ;     len.i
  ; ;     ScrollStep.i
  ; ;   EndStructure
  ; ;   
  ; ;   ;- - _s_bar
  ; ;   Structure _s_bar Extends _s_coordinate
  ; ;     *s._s_scroll
  ; ;     Type.i
  ; ;     Widget.i
  ; ;     round.i
  ; ;     ArrowSize.b[3]
  ; ;     ArrowType.b[3]
  ; ;     
  ; ;     Buttons.i
  ; ;     Both.b ; we see both scrolbars
  ; ;     
  ; ;     Hide.b[2]
  ; ;     Disable.b[2]
  ; ;     Vertical.b
  ; ;     
  ; ;     Max.i
  ; ;     Min.i
  ; ;     Page._s_page
  ; ;     Area._s_page
  ; ;     Thumb._s_page
  ; ;     Button._s_page
  ; ;     Color._s_color[4]
  ; ;   EndStructure
  ; ;   
  ; ;   ;- - _s_mouse
  ; ;   Structure _s_mouse
  ; ;     X.i
  ; ;     Y.i
  ; ;     at.i ; at point widget
  ; ;     Wheel.i ; delta
  ; ;     Buttons.i ; state
  ; ;   ;  *Delta._s_mouse
  ; ;   EndStructure
  ; ;   
  ; ;   ;- - Event_S
  ; ;   Structure _s_post
  ; ;     Gadget.i
  ; ;     Window.i
  ; ;     Type.i
  ; ;     Event.i
  ; ;     *Function
  ; ;   EndStructure
  ; ;   
  ; ;   ;- - _s_scroll
  ; ;   Structure _s_scroll Extends _s_coordinate
  ; ;     *Mouse._s_mouse
  ; ;     Post._s_post
  ; ;     
  ; ;     *v._s_bar
  ; ;     *h._s_bar
  ; ;   EndStructure
  ; ;   
  ; ;   ;-
  ; ;   ;- - CONSTANTs
  ; ;   Enumeration #PB_Event_FirstCustomValue
  ; ;     #PB_Event_Widget
  ; ;   EndEnumeration
  ; ;   
  ; ;   Enumeration #PB_EventType_FirstCustomValue
  ; ;     #PB_EventType_ScrollChange
  ; ;   EndEnumeration
  ; ;   
  ; ;   #PB_Gadget_FrameColor = 10
  ; ;   
  ; ;   ;-
  ; ;   ;- - DECLAREs MACROs
  ; ;   Macro BoxGradient(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _round_=0, _alpha_=255)
  ; ;     BackColor(_color_1_&$FFFFFF|_alpha_<<24)
  ; ;     FrontColor(_color_2_&$FFFFFF|_alpha_<<24)
  ; ;     If _type_
  ; ;       LinearGradient(_x_,_y_, (_x_+_width_), _y_)
  ; ;     Else
  ; ;       LinearGradient(_x_,_y_, _x_, (_y_+_height_))
  ; ;     EndIf
  ; ;     RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
  ; ;     BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
  ; ;   EndMacro
  
  Macro is(_scroll_) : Bool(((_scroll_\v And _scroll_\v\from) Or (_scroll_\h And _scroll_\h\from))) : EndMacro
  ;Macro is(_scroll_) : Bool((((_scroll_\v And Not _scroll_\v\from) Or Not _scroll_\v) And ((_scroll_\h And Not _scroll_\h\from) Or Not _scroll_\h))) : EndMacro
  ;Macro is(_scroll_) : Bool( Bool((_scroll_\v And Not _scroll_\v\from) And (_scroll_\h And Not _scroll_\h\from)) Or Not Bool(_scroll_\v And _scroll_\h)) : EndMacro
  ;   Macro x(_this_) : _this_\x+Bool(_this_\hide[1] Or Not _this_\color\alpha)*_this_\width : EndMacro
  ;   Macro y(_this_) : _this_\y+Bool(_this_\hide[1] Or Not _this_\color\alpha)*_this_\height : EndMacro
  Macro width(_this_) : Bool(Not _this_\hide[1] And _this_\color\alpha)*_this_\width : EndMacro
  Macro height(_this_) : Bool(Not _this_\hide[1] And _this_\color\alpha)*_this_\height : EndMacro
  
  ;- - DECLAREs
  Declare.i Draw(*this._s_bar)
  Declare.i Y(*this._s_bar)
  Declare.i X(*this._s_bar)
  ;   Declare.i Width(*this._s_bar)
  ;   Declare.i Height(*this._s_bar)
  Declare.b SetState(*this._s_bar, ScrollPos.i)
  Declare.i SetAttribute(*this._s_bar, Attribute.i, Value.i)
  Declare.b CallBack(*this._s_bar, EventType.i, mouseX=0, mouseY=0)
  Declare.i Draws(*Scroll._s_scroll, ScrollHeight.i, ScrollWidth.i)
  Declare.i SetColor(*this._s_bar, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.b Resize(*this._s_bar, iX.i,iY.i,iWidth.i,iHeight.i, *that._s_bar=#Null)
  Declare.i Bar(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, round.i=0)
  
  Declare.b Resizes(*Scroll._s_scroll, X.i,Y.i,Width.i,Height.i)
  Declare.b Updates(*Scroll._s_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  ;Declare.i Editor(*Scroll._s_scroll, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, round.i=0)
  Declare.i Bars(*Scroll._s_scroll, Size.i, round.i, Both.b)
  Declare Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
EndDeclareModule

Module Scroll
  Global Colors._s_color
  
  With Colors                          
    \state = 0
    ;- Синие цвета
    ; Цвета по умолчанию
    \front[0] = $80000000
    \fore[0] = $FFF8F8F8 
    \back[0] = $80E2E2E2
    \frame[0] = $80C8C8C8
    
    ; Цвета если мышь на виджете
    \front[1] = $80000000
    \fore[1] = $FFFAF8F8
    \back[1] = $80FCEADA
    \frame[1] = $80FFC288
    
    ; Цвета если нажали на виджет
    \front[2] = $FFFEFEFE
    \fore[2] = $C8E9BA81;$C8FFFCFA
    \back[2] = $C8E89C3D; $80E89C3D
    \frame[2] = $C8DC9338; $80DC9338
  EndWith
  
  Macro ThumbLength(_this_)
    Round(_this_\area\len - (_this_\area\len / (_this_\max-_this_\min))*((_this_\max-_this_\min) - _this_\page\len), #PB_Round_Nearest)
  EndMacro
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\area\pos + Round((_scroll_pos_-_this_\min) * (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Nearest)) : If _this_\Vertical : _this_\y[3] = _this_\thumb\pos : _this_\height[3] = _this_\thumb\len : Else : _this_\x[3] = _this_\thumb\pos : _this_\width[3] = _this_\thumb\len : EndIf
  EndMacro
  Macro ScrollEnd(_this_)
    Bool(_this_\page\pos = ((_this_\max-_this_\min)-_this_\page\len))
  EndMacro
  
  Procedure Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
    Protected I
    
    If Length=0
      Thickness = - 1
    EndIf
    Length = (Size+2)/2
    
    
    If Direction = 1 ; top
      If Thickness > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size 
          LineXY((X+1+i)+Size,(Y+i-1)-(Thickness),(X+1+i)+Size,(Y+i-1)+(Thickness),Color)         ; Левая линия
          LineXY(((X+1+(Size))-i),(Y+i-1)-(Thickness),((X+1+(Size))-i),(Y+i-1)+(Thickness),Color) ; правая линия
        Next
      Else : x-1 : y-1
        For i = 1 To Length 
          If Thickness =- 1
            LineXY(x+i, (Size+y), x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y), x+Length, y, Color)
          Else
            LineXY(x+i, (Size+y)-i/2, x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y)-i/2, x+Length, y, Color)
          EndIf
        Next 
        i = Bool(Thickness =- 1) 
        LineXY(x, (Size+y)+Bool(i=0), x+Length, y+1, Color) 
        LineXY(x+Length*2, (Size+y)+Bool(i=0), x+Length, y+1, Color) ; bug
      EndIf
    ElseIf Direction = 3 ; bottom
      If Thickness > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size
          LineXY((X+1+i),(Y+i)-(Thickness),(X+1+i),(Y+i)+(Thickness),Color) ; Левая линия
          LineXY(((X+1+(Size*2))-i),(Y+i)-(Thickness),((X+1+(Size*2))-i),(Y+i)+(Thickness),Color) ; правая линия
        Next
      Else : x-1 : y+1
        For i = 0 To Length 
          If Thickness =- 1
            LineXY(x+i, y, x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y, x+Length, (Size+y), Color)
          Else
            LineXY(x+i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
          EndIf
        Next
      EndIf
    ElseIf Direction = 0 ; в лево
      If Thickness > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в лево
          LineXY(((X+1)+i)-(Thickness),(((Y+1)+(Size))-i),((X+1)+i)+(Thickness),(((Y+1)+(Size))-i),Color) ; правая линия
          LineXY(((X+1)+i)-(Thickness),((Y+1)+i)+Size,((X+1)+i)+(Thickness),((Y+1)+i)+Size,Color)         ; Левая линия
        Next  
      Else : x-1 : y-1
        For i = 1 To Length
          If Thickness =- 1
            LineXY((Size+x), y+i, x, y+Length, Color)
            LineXY((Size+x), y+Length*2-i, x, y+Length, Color)
          Else
            LineXY((Size+x)-i/2, y+i, x, y+Length, Color)
            LineXY((Size+x)-i/2, y+Length*2-i, x, y+Length, Color)
          EndIf
        Next 
        i = Bool(Thickness =- 1) 
        LineXY((Size+x)+Bool(i=0), y, x+1, y+Length, Color) 
        LineXY((Size+x)+Bool(i=0), y+Length*2, x+1, y+Length, Color)
      EndIf
    ElseIf Direction = 2 ; в право
      If Thickness > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в право
          LineXY(((X+2)+i)-(Thickness),((Y+1)+i),((X+2)+i)+(Thickness),((Y+1)+i),Color) ; Левая линия
          LineXY(((X+2)+i)-(Thickness),(((Y+1)+(Size*2))-i),((X+2)+i)+(Thickness),(((Y+1)+(Size*2))-i),Color) ; правая линия
        Next
      Else : y-1 : x+1
        For i = 0 To Length 
          If Thickness =- 1
            LineXY(x, y+i, Size+x, y+Length, Color)
            LineXY(x, y+Length*2-i, Size+x, y+Length, Color)
          Else
            LineXY(x+i/2-Bool(i=0), y+i, Size+x, y+Length, Color)
            LineXY(x+i/2-Bool(i=0), y+Length*2-i, Size+x, y+Length, Color)
          EndIf
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
    If Grid 
      Value = Round((Value/Grid), #PB_Round_Nearest) * Grid 
      If Value>Max 
        Value=Max 
      EndIf
    EndIf
    
    ProcedureReturn Value
  EndProcedure
  
  Procedure.i Pos(*this._s_bar, ThumbPos.i)
    Protected ScrollPos.i
    
    With *this
      ScrollPos = Match( \min + Round((ThumbPos - \area\pos) / ( \area\len / ( \max-\min)), #PB_Round_Nearest), \page\scrollStep) 
      If ( \Vertical And \type = #PB_GadgetType_TrackBar) : ScrollPos = (( \max-\min)-ScrollPos) : EndIf
    EndWith
    
    ProcedureReturn ScrollPos
  EndProcedure
  
  ;-
  Procedure.i X(*this._s_bar)
    Protected Result.l
    
    If *this
      With *this
        If Not \hide[1] And \color\alpha
          Result = \x
        Else
          Result = \x+\width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Y(*this._s_bar)
    Protected Result.l
    
    If *this
      With *this
        If Not \hide[1] And \color\alpha
          Result = \y ; -(\height-\round/2)+1
        Else
          Result = \y+\height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Draw(*this._s_bar)
    With *this
      If *this And Not \hide And \color\alpha
        
        ; Draw scroll bar background
        If \color[0]\back[\color[0]\state]<>-1
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox( \x[0], \y[0], \width[0], \height[0], \round, \round, \color[0]\back[\color[0]\state]&$FFFFFF|\color\alpha<<24)
        EndIf
        
        ; Draw line
        If \color[0]\line[\color[0]\state]<>-1
          If \s
            If \Vertical
              ; Draw left line
              If Not \s\h\hide
                ; "Это пустое пространство между двумя скроллами тоже закрашиваем если скролл бара кнопки не круглые"
                If Not \round : Box( \x[2], \y[2]+\height[2]+1, \width[2], \height[2], \color[0]\back[\color[0]\state]&$FFFFFF|\color\alpha<<24) : EndIf
                Line( \x[0], \y[0],1, \height[0]-\round/2,\color[0]\line[\color[0]\state]&$FFFFFF|\color\alpha<<24)
              Else
                Line( \x[0], \y[0],1, \height[0],\color[0]\line[\color[0]\state]&$FFFFFF|\color\alpha<<24)
              EndIf
            Else
              ; Draw top line
              If Not \s\v\hide
                Line( \x[0], \y[0], \width[0]-\round/2,1,\color[0]\line[\color[0]\state]&$FFFFFF|\color\alpha<<24)
              Else
                Line( \x[0], \y[0], \width[0],1,\color[0]\line[\color[0]\state]&$FFFFFF|\color\alpha<<24)
              EndIf
            EndIf
          EndIf
        EndIf
        
        If \thumb\len 
          ; Draw thumb  
          If \color[3]\back[\color[3]\state]<>-1
            If \color[3]\fore[\color[3]\state]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            BoxGradient( \Vertical, \x[3], \y[3], \width[3], \height[3], \color[3]\fore[\color[3]\state], \color[3]\back[\color[3]\state], \round, \color\alpha)
          EndIf
          
          ; Draw thumb frame
          If \color[3]\frame[\color[3]\state] 
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \x[3], \y[3], \width[3], \height[3], \round, \round, \color[3]\frame[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        If \button\len 
          ; Draw buttons
          If \color[1]\back[\color[1]\state]<>-1
            If \color[1]\fore[\color[1]\state]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            BoxGradient( \Vertical, \x[1], \y[1], \width[1], \height[1], \color[1]\fore[\color[1]\state], \color[1]\back[\color[1]\state], \round, \color\alpha)
            If \color[2]\fore[\color[2]\state]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            BoxGradient( \Vertical, \x[2], \y[2], \width[2], \height[2], \color[2]\fore[\color[2]\state], \color[2]\back[\color[2]\state], \round, \color\alpha)
          EndIf
          
          ; Draw buttons frame
          If \color[1]\frame[\color[1]\state]
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \x[1], \y[1], \width[1], \height[1], \round, \round, \color[1]\frame[\color[1]\state]&$FFFFFF|\color\alpha<<24)
          EndIf
          If \color[2]\frame[\color[2]\state]
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \x[2], \y[2], \width[2], \height[2], \round, \round, \color[2]\frame[\color[2]\state]&$FFFFFF|\color\alpha<<24)
          EndIf
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow( \x[1]+( \width[1]-\arrowSize[1])/2, \y[1]+( \height[1]-\arrowSize[1])/2, \arrowSize[1], Bool( \Vertical), \color[1]\front[\color[1]\state]&$FFFFFF|\color\alpha<<24, \arrowType[1])
          Arrow( \x[2]+( \width[2]-\arrowSize[2])/2, \y[2]+( \height[2]-\arrowSize[2])/2, \arrowSize[2], Bool( \Vertical)+2, \color[2]\front[\color[2]\state]&$FFFFFF|\color\alpha<<24, \arrowType[2])
        EndIf
        
        If \color[3]\fore[\color[3]\state]  ; Draw thumb lines
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \Vertical
            Line( \x[3]+( \width[3]-8)/2, \y[3]+\height[3]/2-3,9,1, \color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line( \x[3]+( \width[3]-8)/2, \y[3]+\height[3]/2,9,1, \color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line( \x[3]+( \width[3]-8)/2, \y[3]+\height[3]/2+3,9,1, \color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Else
            Line( \x[3]+\width[3]/2-3, \y[3]+( \height[3]-8)/2,1,9, \color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line( \x[3]+\width[3]/2, \y[3]+( \height[3]-8)/2,1,9, \color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line( \x[3]+\width[3]/2+3, \y[3]+( \height[3]-8)/2,1,9, \color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draws(*Scroll._s_scroll, ScrollHeight.i, ScrollWidth.i)
    ;     Protected Repaint
    
    With *Scroll
      UnclipOutput()
      If \v And \v\page\len And \v\max<>ScrollHeight And 
         SetAttribute(\v, #__bar_Maximum, ScrollHeight)
        Resizes(*Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      If \h And \h\page\len And \h\max<>ScrollWidth And
         SetAttribute(\h, #__bar_Maximum, ScrollWidth)
        Resizes(*Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      If \v And Not \v\hide
        Draw(\v)
      EndIf
      If \h And Not \h\hide
        Draw(\h)
      EndIf
    EndWith
    
    ;     ProcedureReturn Repaint
  EndProcedure
  
  Procedure.b SetState(*this._s_bar, ScrollPos.i)
    Protected Result.b, Direction.i ; Направление и позиция скролла (вверх,вниз,влево,вправо)
    
    With *this
      If *this
        If ( \Vertical And \type = #PB_GadgetType_TrackBar) : ScrollPos = (( \max-\min)-ScrollPos) : EndIf
        
        If ScrollPos < \min : ScrollPos = \min : EndIf
        If ScrollPos > (\max-\page\len) ; ((\max-\min) - \page\len)
          ScrollPos = (\max-\page\len)
        EndIf
        
        If \page\pos <> ScrollPos 
          If \page\pos > ScrollPos
            Direction =- ScrollPos
          Else
            Direction = ScrollPos
          EndIf
          \page\pos = ScrollPos
          
          \thumb\pos = ThumbPos(*this, ScrollPos)
          
          If \s
            If \Vertical
              \s\y =- \page\pos
            Else
              \s\x =- \page\pos
            EndIf
            
            If \s\post\event
              If \s\post\widget
                PostEvent(\s\post\event, \s\post\window, \s\post\widget, #PB_EventType_ScrollChange, Direction) 
              Else
                PostEvent(\s\post\event, \s\post\window, \s\post\gadget, #PB_EventType_ScrollChange, Direction) 
              EndIf
            EndIf
          EndIf
          
          Result = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetAttribute(*this._s_bar, Attribute.i, Value.i)
    Protected Result.i
    
    With *this
      If *this
        Select Attribute
          Case #__bar_Minimum
            If \min <> Value 
              \min = Value
              \page\pos = Value
              Result = #True
            EndIf
            
          Case #__bar_Maximum
            If \max <> Value
              If \min > Value
                \max = \min + 1
              Else
                \max = Value
              EndIf
              
              If \s
                If \Vertical
                  \s\height = \max
                Else
                  \s\width = \max
                EndIf
              EndIf
              
              \page\scrollStep = ( \max-\min) / 100
              
              Result = #True
            EndIf
            
          Case #__bar_PageLength
            If \page\len <> Value
              If Value > ( \max-\min) 
                If Not \max 
                  \max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает 
                EndIf
                
                \page\len = ( \max-\min)
              Else
                \page\len = Value
              EndIf
              
              Result = #True
            EndIf
            
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetColor(*this._s_bar, ColorType.i, Color.i, State.i=0, Item.i=0)
    Protected Result, Count 
    State =- 1
    If Item < 0 
      Item = 0 
    ElseIf Item > 3 
      Item = 3 
    EndIf
    
    With *this
      If State =- 1
        Count = 2
        \color\state = 0
      Else
        Count = State
        \color\state = State
      EndIf
      
      For State = \color\state To Count
        
        Select ColorType
          Case #__Color_Line
            If \color[Item]\line[State] <> Color 
              \color[Item]\line[State] = Color
              Result = #True
            EndIf
            
          Case #__Color_Back
            If \color[Item]\back[State] <> Color 
              \color[Item]\back[State] = Color
              Result = #True
            EndIf
            
          Case #__Color_Front
            If \color[Item]\front[State] <> Color 
              \color[Item]\front[State] = Color
              Result = #True
            EndIf
            
          Case #__Color_Frame
            If \color[Item]\frame[State] <> Color 
              \color[Item]\frame[State] = Color
              Result = #True
            EndIf
            
        EndSelect
        
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b Resize(*this._s_bar, X.i,Y.i,Width.i,Height.i, *that._s_bar=#Null)
    Protected Lines.i, ScrollPage.i
    
    With *this
      ScrollPage = ((\max-\min) - \page\len)
      Lines = Bool(\type=#PB_GadgetType_ScrollBar)
      
      ;
      If *this <> *that And *that And *that\hide
        If \Vertical
          If Height=#PB_Ignore 
            Height=(*that\y+*that\height)-\y 
          EndIf
        Else
          If Width=#PB_Ignore
            Width=(*that\x+*that\width)-\x 
          EndIf
        EndIf
      EndIf
      
      ;
      If X=#PB_Ignore : X = \x[0] : EndIf 
      If Y=#PB_Ignore : Y = \y[0] : EndIf 
      If Width=#PB_Ignore : Width = \width[0] : EndIf 
      If Height=#PB_Ignore : Height = \height[0] : EndIf
      
      ; 
      \hide[1] = Bool(Not (\page\len And (\max-\min) > \page\len))
      
      If Not \hide[1]
        If \Vertical
          \area\pos = Y+\button\len
          \area\len = (Height-\button\len*2)
        Else
          \area\pos = X+\button\len
          \area\len = (Width-\button\len*2)
        EndIf
        
        If \area\len
          \thumb\len = ThumbLength(*this)
          
          If (\area\len > \button\len)
            If \button\len
              If (\thumb\len < \button\len)
                \area\len = Round( \area\len - ( \button\len-\thumb\len), #PB_Round_Nearest)
                \thumb\len = \button\len 
              EndIf
            Else
              If ( \thumb\len < 7)
                \area\len = Round( \area\len - (7-\thumb\len), #PB_Round_Nearest)
                \thumb\len = 7
              EndIf
            EndIf
          Else
            \thumb\len = \area\len 
          EndIf
          
          If \area\len > 0
            ; Debug " scroll set state "+\max+" "+\page\len+" "+Str( \thumb\pos+\thumb\len) +" "+ Str( \area\len+\button\len)
            If ( \type <> #PB_GadgetType_TrackBar) And (\thumb\pos+\thumb\len) >= (\area\pos+\area\len)
              SetState(*this, ScrollPage)
            EndIf
            
            \thumb\pos = ThumbPos(*this, \page\pos)
          EndIf
        EndIf
      EndIf
      
      \x[0] = X : \y[0] = Y : \width[0] = Width : \height[0] = Height                                          ; Set scroll bar coordinate
      
      If \Vertical
        \x[1] = X + Lines : \y[1] = Y : \width[1] = Width - Lines : \height[1] = \button\len                   ; Top button coordinate on scroll bar
        \x[2] = X + Lines : \width[2] = Width - Lines : \height[2] = \button\len : \y[2] = Y+Height-\height[2] ; Botom button coordinate on scroll bar
        \x[3] = X + Lines : \width[3] = Width - Lines : \y[3] = \thumb\pos : \height[3] = \thumb\len           ; Thumb coordinate on scroll bar
      Else
        \x[1] = X : \y[1] = Y + Lines : \width[1] = \button\len : \height[1] = Height - Lines                  ; Left button coordinate on scroll bar
        \y[2] = Y + Lines : \height[2] = Height - Lines : \width[2] = \button\len : \x[2] = X+Width-\width[2]  ; Right button coordinate on scroll bar
        \y[3] = Y + Lines : \height[3] = Height - Lines : \x[3] = \thumb\pos : \width[3] = \thumb\len          ; Thumb coordinate on scroll bar
      EndIf
      
      ProcedureReturn \hide[1]
    EndWith
  EndProcedure
  
  Procedure.b Updates(*Scroll._s_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    Protected iWidth = X(*Scroll\v)-(*Scroll\v\width-*Scroll\v\round/2)+1, iHeight = Y(*Scroll\h)-(*Scroll\h\height-*Scroll\h\round/2)+1
    Static hPos, vPos : vPos = *Scroll\v\page\pos : hPos = *Scroll\h\page\pos
    
    ; Вправо работает как надо
    If ScrollArea_Width<*Scroll\h\page\pos+iWidth 
      ScrollArea_Width=*Scroll\h\page\pos+iWidth
      ; Влево работает как надо
    ElseIf ScrollArea_X>*Scroll\h\page\pos And
           ScrollArea_Width=*Scroll\h\page\pos+iWidth 
      ScrollArea_Width = iWidth 
    EndIf
    
    ; Вниз работает как надо
    If ScrollArea_Height<*Scroll\v\page\pos+iHeight
      ScrollArea_Height=*Scroll\v\page\pos+iHeight 
      ; Верх работает как надо
    ElseIf ScrollArea_Y>*Scroll\v\page\pos And
           ScrollArea_Height=*Scroll\v\page\pos+iHeight 
      ScrollArea_Height = iHeight 
    EndIf
    
    If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
    If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
    
    If ScrollArea_X<*Scroll\h\page\pos : ScrollArea_Width-ScrollArea_X : EndIf
    If ScrollArea_Y<*Scroll\v\page\pos : ScrollArea_Height-ScrollArea_Y : EndIf
    
    If *Scroll\v\max<>ScrollArea_Height : SetAttribute(*Scroll\v, #__bar_Maximum, ScrollArea_Height) : EndIf
    If *Scroll\h\max<>ScrollArea_Width : SetAttribute(*Scroll\h, #__bar_Maximum, ScrollArea_Width) : EndIf
    
    If *Scroll\v\page\len<>iHeight : SetAttribute(*Scroll\v, #__bar_PageLength, iHeight) : EndIf
    If *Scroll\h\page\len<>iWidth : SetAttribute(*Scroll\h, #__bar_PageLength, iWidth) : EndIf
    
    If ScrollArea_Y<0 : SetState(*Scroll\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
    If ScrollArea_X<0 : SetState(*Scroll\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
    
    *Scroll\v\hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h) 
    *Scroll\h\hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\v)
    
    If *Scroll\v\hide : *Scroll\v\page\pos = 0 : If vPos : *Scroll\v\hide = vPos : EndIf : Else : *Scroll\v\page\pos = vPos : *Scroll\h\width = iWidth+*Scroll\v\width : EndIf
    If *Scroll\h\hide : *Scroll\h\page\pos = 0 : If hPos : *Scroll\h\hide = hPos : EndIf : Else : *Scroll\h\page\pos = hPos : *Scroll\v\height = iHeight+*Scroll\h\height : EndIf
    
    ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
  EndProcedure
  
  Procedure.b Resizes(*Scroll._s_scroll, X.i,Y.i,Width.i,Height.i)
    If Not Bool(*Scroll\v And *Scroll\h) 
      If *Scroll\v
        If Width<>#PB_Ignore
          X = Width-*Scroll\v\width
        EndIf
        ProcedureReturn Resize(*Scroll\v, X,#PB_Ignore,#PB_Ignore,Height.i)
      ElseIf *Scroll\h
        If Height<>#PB_Ignore
          Y = Height-*Scroll\h\height
        EndIf
        ProcedureReturn Resize(*Scroll\h, #PB_Ignore,Y,Width.i,#PB_Ignore)
      Else
        *Scroll\width[2] = Width
        *Scroll\height[2] = Height
        ProcedureReturn - 1
      EndIf
    EndIf
    
    If *Scroll\v And Y<>#PB_Ignore And *Scroll\v\max <> *Scroll\height
      SetAttribute(*Scroll\v, #__bar_Maximum, *Scroll\height)
    EndIf
    If *Scroll\h And X<>#PB_Ignore And *Scroll\h\max <> *Scroll\width
      SetAttribute(*Scroll\h, #__bar_Maximum, *Scroll\width)
    EndIf
    
    If Width=#PB_Ignore : Width = *Scroll\v\x : Else : Width+x-*Scroll\v\width : EndIf
    If Height=#PB_Ignore : Height = *Scroll\h\y : Else : Height+y-*Scroll\h\height : EndIf
    
    Protected iWidth = x(*Scroll\v)-*Scroll\h\x, iHeight = y(*Scroll\h)-*Scroll\v\y
    
    If *Scroll\v\width And *Scroll\v\page\len<>iHeight : SetAttribute(*Scroll\v, #__bar_PageLength, iHeight) : EndIf
    If *Scroll\h\height And *Scroll\h\page\len<>iWidth : SetAttribute(*Scroll\h, #__bar_PageLength, iWidth) : EndIf
    
    *Scroll\v\hide = Resize(*Scroll\v, Width, Y, #PB_Ignore, #PB_Ignore, *Scroll\h) : iWidth = x(*Scroll\v)-*Scroll\h\x
    *Scroll\h\hide = Resize(*Scroll\h, X, Height, #PB_Ignore, #PB_Ignore, *Scroll\v) : iHeight = y(*Scroll\h)-*Scroll\v\y
    
    If *Scroll\v\width And *Scroll\v\page\len<>iHeight : SetAttribute(*Scroll\v, #__bar_PageLength, iHeight) : EndIf
    If *Scroll\h\height And *Scroll\h\page\len<>iWidth : SetAttribute(*Scroll\h, #__bar_PageLength, iWidth) : EndIf
    
    If *Scroll\v\width : *Scroll\v\hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h) : EndIf
    If *Scroll\h\height : *Scroll\h\hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\v) : EndIf
    
    If *Scroll\v\hide : *Scroll\v\page\pos = 0 : *Scroll\y = 0 : Else
      If *Scroll\h\round : Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, (*Scroll\v\x-*Scroll\h\x)+Bool(*Scroll\v\round)*4, #PB_Ignore) : EndIf
    EndIf
    If *Scroll\h\hide : *Scroll\h\page\pos = 0 : *Scroll\x = 0 : Else
      If *Scroll\v\round : Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\h\y-*Scroll\v\y)+Bool(*Scroll\h\round)*4) : EndIf
    EndIf
    
    *Scroll\width[2] = x(*Scroll\v)-*Scroll\h\x
    *Scroll\height[2] = y(*Scroll\h)-*Scroll\v\y
    
    ProcedureReturn Bool(Not Bool(*Scroll\v\hide|*Scroll\h\hide))
  EndProcedure
  
  
  Procedure.i Events(*this._s_bar, EventType.i, mouseX.i, mouseY.i, at.i)
    Static delta, cursor
    Protected Repaint.i
    Protected window = EventWindow()
    Protected canvas = EventGadget()
    
    ;Debug EventType
    
    If *this
      With *this
        Select EventType
          Case #PB_EventType_LeftDoubleClick 
            Select at
              Case - 1
                ; If \height > ( \y[2]+\height[2])
                If \Vertical
                  Repaint = SetState(*this, Pos(*this, (mouseY-\thumb\len/2)))
                Else
                  Repaint = SetState(*this, Pos(*this, (mouseX-\thumb\len/2)))
                EndIf
                ; EndIf
            EndSelect
            
          Case #PB_EventType_LeftButtonUp : delta = 0
          Case #PB_EventType_LeftButtonDown 
            Select at
              Case 1 : Repaint = SetState(*this, ( \page\pos - \page\scrollStep))
              Case 2 : Repaint = SetState(*this, ( \page\pos + \page\scrollStep))
              Case 3 
                If \Vertical
                  delta = mouseY - \thumb\pos
                Else
                  delta = mouseX - \thumb\pos
                EndIf
            EndSelect
            
          Case #PB_EventType_MouseMove
            If delta
              If \Vertical
                Repaint = SetState(*this, Pos(*this, (mouseY-delta)))
              Else
                Repaint = SetState(*this, Pos(*this, (mouseX-delta)))
              EndIf
            EndIf
        EndSelect
        
        Select EventType
          Case #PB_EventType_MouseLeave
            If at > 0
              \color[at]\state = 0
            Else
              ; Debug ""+*this +" "+ EventType +" "+ at
              
              If cursor <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                SetGadgetAttribute(canvas, #PB_Canvas_Cursor, cursor)
              EndIf
              
              \color[1]\state = 0
              \color[2]\state = 0
              \color[3]\state = 0
            EndIf
            Repaint = #True
            
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter
            If at>0
              \color[at]\state = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
              
              Repaint = #True
            Else
              ; Debug ""+*this +" "+ EventType +" "+ at
              
              If Not cursor
                cursor = GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
              EndIf
              SetGadgetAttribute(canvas, #PB_Canvas_Cursor, #PB_Cursor_Default)
              
            EndIf
        EndSelect
      EndWith
    EndIf  
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.b CallBack(*this._s_bar, EventType.i, mouseX=0, mouseY=0)
    Protected repaint
    Static Last, Down, *Scroll._s_bar, *Last._s_bar, mouseB, mouseat
    
    With *this
      If *this And Not \hide And \color\alpha And \type = #PB_GadgetType_ScrollBar
        If Not mouseX
          mouseX = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX)
        EndIf
        If Not mouseY
          mouseY = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY)
        EndIf
        
        ; get at point buttons
        If mouseB
        ElseIf (mouseX>=\x And mouseX<\x+\width And mouseY>\y And mouseY=<\y+\height) 
          If (mouseX>\x[1] And mouseX=<\x[1]+\width[1] And  mouseY>\y[1] And mouseY=<\y[1]+\height[1])
            \from = 1
          ElseIf (mouseX>\x[3] And mouseX=<\x[3]+\width[3] And mouseY>\y[3] And mouseY=<\y[3]+\height[3])
            \from = 3
          ElseIf (mouseX>\x[2] And mouseX=<\x[2]+\width[2] And mouseY>\y[2] And mouseY=<\y[2]+\height[2])
            \from = 2
          Else
            \from =- 1
          EndIf 
          
          Select EventType 
            Case #PB_EventType_MouseEnter : EventType = #PB_EventType_MouseMove
            Case #PB_EventType_MouseLeave : EventType = #PB_EventType_MouseMove
          EndSelect
          
          mouseat = *this
        Else
          \from = 0
          
          Select EventType 
            Case #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
              If \Vertical
                If \s And \s\h And \s\h\from
                  If \s\h\from > 0
                    repaint | Events(\s\h, EventType, mouseX, mouseY, \s\h\from)
                  EndIf
                  repaint | Events(\s\h, EventType, mouseX, mouseY, - 1)
                  If EventType = #PB_EventType_MouseLeave
                    *Scroll = 0
                  EndIf
                  
                  \s\h\from = 0
                EndIf
              EndIf     
              
              EventType = #PB_EventType_MouseMove
          EndSelect
          
          If \Vertical
            If \s And \s\h And \s\h\from
              If \color[2]\state
                repaint | Events(*this, #PB_EventType_MouseLeave, mouseX, mouseY, \from)
                ;                   repaint | Events(*this, #PB_EventType_MouseLeave, - 1)
                ;                   repaint | Events(\s\h, #PB_EventType_MouseEnter, - 1)
                repaint | Events(\s\h, #PB_EventType_MouseEnter, mouseX, mouseY, \s\h\from)
                \color[2]\state = 0
              EndIf
            Else
              mouseat = 0
            EndIf
          Else
            If \s And \s\v And \s\v\from
              If \color[2]\state
                repaint | Events(*this, #PB_EventType_MouseLeave, mouseX, mouseY, \from)
                ;                   repaint | Events(*this, #PB_EventType_MouseLeave, - 1)
                ;                   repaint | Events(\s\v, #PB_EventType_MouseEnter, - 1)
                repaint | Events(\s\v, #PB_EventType_MouseEnter, mouseX, mouseY, \s\v\from)
                \color[2]\state = 0
              EndIf
            Else
              mouseat = 0
            EndIf
          EndIf
          
        EndIf
        
        If *Scroll <> mouseat And 
           *this = mouseat
          *Last = *Scroll
          *Scroll = mouseat
        EndIf
        
        If *Scroll = *this
          If Last <> \from
            ;
            ; Debug ""+Last +" "+ *this\from +" "+ *this +" "+ *Last
            If Last > 0 Or (Last = 2 And \from =- 1 And *Last)
              repaint | Events(*this, #PB_EventType_MouseLeave, mouseX, mouseY, Last) : *Last = 0
            EndIf
            If Not \from Or (Last = 2 And \from =- 1 And *Last)
              repaint | Events(*this, #PB_EventType_MouseLeave, mouseX, mouseY, - 1) : *Last = 0
            EndIf
            
            If Not last ; Or (Last =- 1 And \from = 2 And *Last)
              repaint | Events(*this, #PB_EventType_MouseEnter, mouseX, mouseY, - 1)
            EndIf
            If \from > 0
              repaint | Events(*this, #PB_EventType_MouseEnter, mouseX, mouseY, \from)
            EndIf
            
            Last = \from
          EndIf
          
          Select EventType 
            Case #PB_EventType_LeftButtonDown
              mouseB = 1
              If \from
                Down = \from
                repaint | Events(*this, EventType, mouseX, mouseY, \from)
              EndIf
              
            Case #PB_EventType_LeftButtonUp 
              mouseB = 0
              If Down
                repaint | Events(*this, EventType, mouseX, mouseY, Down)
                Down = 0
              EndIf
              
            Case #PB_EventType_LeftDoubleClick, 
                 #PB_EventType_LeftButtonDown, 
                 #PB_EventType_MouseMove
              
              If \from
                repaint | Events(*this, EventType, mouseX, mouseY, \from)
              EndIf
          EndSelect
        EndIf
        
        ; ; ;           If AutoHide =- 1 : *Scroll = 0
        ; ; ;             AutoHide = Bool(EventType() = #PB_EventType_MouseLeave)
        ; ; ;           EndIf
        ; ; ;           
        ; ; ;           ; Auto hides
        ; ; ;           If (AutoHide And Not Drag And Not at) 
        ; ; ;             If \color\alpha <> \color\alpha[1] : \color\alpha = \color\alpha[1] 
        ; ; ;               repaint =- 1
        ; ; ;             EndIf 
        ; ; ;           EndIf
        ; ; ;           If EventType = #PB_EventType_MouseEnter And (*thisis = *this Or Not *Scroll)
        ; ; ;             If \color\alpha < 255 : \color\alpha = 255
        ; ; ;               
        ; ; ;               If *Scroll
        ; ; ;                 If \Vertical
        ; ; ;                   Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\y+*Scroll\height)-\y) 
        ; ; ;                 Else
        ; ; ;                   Resize(*this, #PB_Ignore, #PB_Ignore, (*Scroll\x+*Scroll\width)-\x, #PB_Ignore) 
        ; ; ;                 EndIf
        ; ; ;               EndIf
        ; ; ;               
        ; ; ;               repaint =- 2
        ; ; ;             EndIf 
        ; ; ;           EndIf
        
      EndIf
    EndWith
    
    ProcedureReturn repaint
  EndProcedure
  
  Procedure.i Bar(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, round.i=0)
    Protected *this._s_bar = AllocateStructure(_s_bar)
    
    With *this
      \x =- 1
      \y =- 1
      \round = round
      \Vertical = Bool(Flag=#__bar_Vertical)
      \type = #PB_GadgetType_ScrollBar
      
      \arrowSize[1] = 4
      \arrowSize[2] = 4
      \arrowType[1] =- 1 ; -1 0 1
      \arrowType[2] =- 1 ; -1 0 1
      
      ; Цвет фона скролла
      \color\alpha = 255
      \color\alpha[1] = 0
      \color[0]\state = 0
      \color[0]\back[0] = $FFF9F9F9
      \color[0]\frame[0] = \color\back[0]
      \color[0]\line[0] = $FFFFFFFF
      
      \color[1] = Colors
      \color[2] = Colors
      \color[3] = Colors
      
      If \Vertical
        If width < 21
          \button\len = width - 1
        Else
          \button\len = 17
        EndIf
      Else
        If height < 21
          \button\len = height - 1
        Else
          \button\len = 17
        EndIf
      EndIf
      
      If \min <> Min : SetAttribute(*this, #__bar_Minimum, Min) : EndIf
      If \max <> Max : SetAttribute(*this, #__bar_Maximum, Max) : EndIf
      If \page\len <> Pagelength : SetAttribute(*this, #__bar_PageLength, Pagelength) : EndIf
    EndWith
    
    Resize(*this, X,Y,Width,Height)
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Bars(*Scroll._s_scroll, Size.i, round.i, Both.b)
    *Scroll\v = Bar(#PB_Ignore,#PB_Ignore,Size,#PB_Ignore, 0,0,0, #__bar_Vertical, round)
    *Scroll\v\hide = *Scroll\v\hide[1]
    *Scroll\v\s = *Scroll
    
    If Both
      *Scroll\h = Bar(#PB_Ignore,#PB_Ignore,#PB_Ignore,Size, 0,0,0, 0, round)
      *Scroll\h\hide = *Scroll\h\hide[1]
    Else
      *Scroll\h._s_bar = AllocateStructure(_s_bar)
      *Scroll\h\hide = 1
    EndIf
    *Scroll\h\s = *Scroll
    
    With *Scroll     
      If \post\function And \post\event
        UnbindEvent(\post\event, \post\function, \post\window, \post\gadget)
        BindEvent(\post\event, \post\function, \post\window, \post\gadget)
      EndIf
    EndWith
    
    ProcedureReturn *Scroll
  EndProcedure
EndModule

;-
DeclareModule Editor
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  ;- - DECLAREs MACROs
  ;Declare.i Update(*this._s_widget)
  
  ;- DECLARE
  Declare.i SetItemState(*this._s_widget, Item.i, State.i)
  Declare GetState(*this._s_widget)
  Declare.s GetText(*this._s_widget)
  Declare.i ClearItems(*this._s_widget)
  Declare.i CountItems(*this._s_widget)
  Declare.i RemoveItem(*this._s_widget, Item.i)
  Declare SetState(*this._s_widget, State.i)
  Declare GetAttribute(*this._s_widget, Attribute.i)
  Declare SetAttribute(*this._s_widget, Attribute.i, Value.i)
  Declare SetText(*this._s_widget, Text.s, Item.i=0)
  Declare SetFont(*this._s_widget, FontID.i)
  Declare.i AddItem(*this._s_widget, Item.i,Text.s,Image.i=-1,Flag.i=0)
  Declare ReDraw(*this._s_widget, Canvas =- 1, BackColor=$FFF0F0F0)
  
  ;Declare.i Make(*this._s_widget)
  Declare.i CallBack(*this._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s="", Flag.i=0, round.i=0)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
  Declare.i ReDraw(*this._s_widget, Canvas =- 1, BackColor=$FFF0F0F0)
  Declare.i Draw(*this._s_widget)
EndDeclareModule

Module Editor
  ;   Global *Buffer = AllocateMemory(10000000)
  ;   Global *Pointer = *Buffer
  ;   
  ;   Procedure.i Update(*this._s_widget)
  ;     *this\text\string.s = PeekS(*Buffer)
  ;     *this\text\change = 1
  ;   EndProcedure
  ; ;   UseModule Constant
  ;- PROCEDURE
  ;-
  
  Declare.i Canvas_CallBack()
  
  Procedure.i __Make(*this._s_widget)
    Protected String1.s, String2.s, String3.s, Count.i
    
    With *this
      If ListSize(\lines())
        \countitems = 0;CountString(\text\string, #LF$)
        
        ForEach \lines()
          If \lines()\index =- 1 : \countitems + 1
            If String1.s
              String1.s +#LF$+ \lines()\text\string.s 
            Else
              String1.s + \lines()\text\string.s
            EndIf
          EndIf
        Next : String1.s + #LF$
        
        ForEach \lines()
          If \lines()\index = \countitems
            If String2.s
              String2.s +#LF$+ \lines()\text\string.s 
            Else
              String2.s + \lines()\text\string.s
            EndIf
            DeleteElement(\lines())
          EndIf
        Next : String2.s + #LF$
        
        ForEach \lines()
          If \lines()\index > 0
            If String3.s
              String3.s +#LF$+ \lines()\text\string.s 
            Else
              String3.s + \lines()\text\string.s
            EndIf
          EndIf
        Next : String3.s + #LF$
        
        \text\string.s = String1.s + String2.s + \text\string.s + String3.s
        \countitems = CountString(\text\string, #LF$)
        \text\len = Len(\text\string.s)
        \text\change = 1
        
        ; ;         ForEach \lines()
        ; ;         ;  Text_AddLine(*this,\lines()\index, \lines()\text\string.s)
        ; ;         Next 
        ClearList(\lines())
      EndIf
    EndWith
  EndProcedure
  
  Procedure __AddLine(*this._s_widget, Line.i, String.s) ;,Image.i=-1,Sublevel.i=0)
    Protected Image_Y, Image_X, Text_X, Text_Y, Height, Width, Indent = 4
    
    Macro _set_content_Y_(_this_)
      If _this_\image\handle
        If _this_\flag\inLine
          Text_Y=((Height-(_this_\text\height*_this_\countitems))/2)
          Image_Y=((Height-_this_\image\height)/2)
        Else
          If _this_\text\align\bottom
            Text_Y=((Height-_this_\image\height-(_this_\text\height*_this_\countitems))/2)-Indent/2
            Image_Y=(Height-_this_\image\height+(_this_\text\height*_this_\countitems))/2+Indent/2
          Else
            Text_Y=((Height-(_this_\text\height*_this_\countitems)+_this_\image\height)/2)+Indent/2
            Image_Y=(Height-(_this_\text\height*_this_\countitems)-_this_\image\height)/2-Indent/2
          EndIf
        EndIf
      Else
        If _this_\text\align\bottom
          Text_Y=(Height-(_this_\text\height*_this_\countitems)-Text_Y-Image_Y) 
        ElseIf _this_\text\align\Vertical
          Text_Y=((Height-(_this_\text\height*_this_\countitems))/2)
        EndIf
      EndIf
    EndMacro
    
    Macro _set_content_X_(_this_)
      If _this_\image\handle
        If _this_\flag\inLine
          If _this_\text\align\right
            Text_X=((Width-_this_\image\width-_this_\items()\text\width)/2)-Indent/2
            Image_X=(Width-_this_\image\width+_this_\items()\text\width)/2+Indent
          Else
            Text_X=((Width-_this_\items()\text\width+_this_\image\width)/2)+Indent
            Image_X=(Width-_this_\items()\text\width-_this_\image\width)/2-Indent
          EndIf
        Else
          Image_X=(Width-_this_\image\width)/2 
          Text_X=(Width-_this_\items()\text\width)/2 
        EndIf
      Else
        If _this_\text\align\right
          Text_X=(Width-_this_\items()\text\width)
        ElseIf _this_\text\align\horizontal
          Text_X=(Width-_this_\items()\text\width-Bool(_this_\items()\text\width % 2))/2 
        Else
          Text_X=_this_\sci\margin\width
        EndIf
      EndIf
    EndMacro
    
    Macro _line_resize_X_(_this_)
      _this_\items()\x = _this_\x[2]+_this_\text\x
      _this_\items()\width = Width
      _this_\items()\text\x = _this_\items()\x+Text_X
      
      _this_\image\x = _this_\x[2]+_this_\text\x+Image_X
      _this_\items()\image\x = _this_\items()\x+Image_X-4
    EndMacro
    
    Macro _line_resize_Y_(_this_)
      _this_\items()\y = _this_\y[1]+_this_\text\y+_this_\scroll\height+Text_Y
      _this_\items()\height = _this_\text\height - Bool(_this_\countitems<>1 And _this_\flag\gridLines)
      _this_\items()\text\y = _this_\items()\y + (_this_\text\height-_this_\text\height[1])/2 - Bool(#PB_Compiler_OS <> #PB_OS_MacOS And _this_\countitems<>1)
      _this_\items()\text\height = _this_\text\height[1]
      
      _this_\image\y = _this_\y[1]+_this_\text\y+Image_Y
      _this_\items()\image\y = _this_\items()\y + (_this_\text\height-_this_\items()\image\height)/2 + Image_Y
    EndMacro
    
    Macro _set_line_pos_(_this_)
      _this_\items()\text\pos = _this_\text\pos
      _this_\items()\text\len = Len(_this_\items()\text\string.s)
      _this_\text\pos + _this_\items()\text\len + 1 ; Len(#LF$)
    EndMacro
    
    
    With *this
      \countitems = ListSize(\items())
      
      If \vertical
        Width = \height[1]-\text\x*2 
        Height = \width[1]-\text\y*2
      Else
        CompilerIf Not Defined(Scroll, #PB_Module)
          \scroll\width[2] = \width[2]-\sci\margin\width
          \scroll\height[2] = \height[2]
        CompilerEndIf
      EndIf
      
      width = \scroll\width[2]
      height = \scroll\height[2]
      
      \items()\index[1] =- 1
      \items()\focus =- 1
      \items()\index = Line
      \items()\round = \round
      \items()\text\string.s = String.s
      
      ; Set line default color state           
      \items()\color\state = 1
      
      ; Update line pos in the text
      _set_line_pos_(*this)
      
      _set_content_X_(*this)
      _line_resize_X_(*this)
      _line_resize_Y_(*this)
      
      ;       ; Is visible lines
      ;       \items()\hide = Bool(Not Bool(\items()\y>=\y[2] And (\items()\y-\y[2])+\items()\height=<\height[2]))
      
      ; Scroll width length
      _set_scroll_width_(*this)
      
      ; Scroll hight length
      _set_scroll_height_(*this)
      
      
      If \index[2] = ListIndex(\items())
        ;Debug " string "+String.s
        \items()\text[1]\string.s = Left(\items()\text\string.s, \text\caret\pos ) : \items()\text[1]\change = #True
        \items()\text[3]\string.s = Right(\items()\text\string.s, \items()\text\len-(\text\caret\pos + \items()\text[2]\len)) : \items()\text[3]\change = #True
      EndIf
    EndWith
    
    ProcedureReturn Line
  EndProcedure
  
  
  ;-
  ;- PUBLIC
  Procedure.i caret(*this._s_widget)
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, MouseX.i, Distance.f, MinDistance.f = Infinity()
    
    With *this
      
      FontID = \items()\text\fontID
      If Not FontID : FontID = \text\fontID : EndIf
      MouseX = \root\mouse\x - (\items()\text\x+\scroll\x)
      
      ;If StartDrawing(CanvasOutput(\root\canvas)) 
      If FontID : DrawingFont(FontID) : EndIf
      
      ; Get caret pos & len
      For i = 0 To \items()\text\len
        X = TextWidth(Left(\items()\text\string, i))
        Distance = (MouseX-X)*(MouseX-X)
        
        If MinDistance > Distance 
          MinDistance = Distance
          \text\caret\len = X ; len
          Position = i        ; pos
          \text\caret\x = (\items()\text\x-\scroll\h\page\pos) + \text\caret\len - Bool(#PB_Compiler_OS = #PB_OS_Windows)
          \text\caret\y = \items()\y-\scroll\v\page\pos
          
        EndIf
      Next 
      
      ;             StopDrawing()
      ;           EndIf
      
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Macro _text_select_(_this_, _pos_, _len_)
    _this_\items()\text[2]\pos = _pos_
    _this_\items()\text[2]\len = _len_
    
    ; string/pos/len/state
    ;If _this_\items()\text[1]\len = _pos_
    _this_\items()\text[1]\len = _pos_
    _this_\items()\text[1]\change = #True
    _this_\items()\text[1]\string.s = Left(_this_\items()\text\string.s, _this_\items()\text[1]\len) 
    ;EndIf
    
    ;If _this_\items()\text[3]\pos <> _pos_ + _len_
    _this_\items()\text[3]\pos = _pos_ + _len_
    _this_\items()\text[3]\change = #True
    _this_\items()\text[3]\len = (_this_\items()\text\len-_this_\items()\text[3]\pos)
    _this_\items()\text[3]\string.s = Right(_this_\items()\text\string.s, _this_\items()\text[3]\len) 
    ;EndIf
    
    ; text/pos/len/state
    If (_this_\index[2] >= _this_\items()\index)
      _this_\text[1]\change = #True
      _this_\text[1]\len = (_this_\items()\text\pos+_this_\items()\text[2]\pos)
      _this_\text[1]\string.s = Left(_this_\text\string.s, _this_\text[1]\len) 
      _this_\text[2]\pos = _this_\text[1]\len
    EndIf
    
    If (_this_\index[2] =< _this_\items()\index)
      _this_\text[3]\change = #True
      _this_\text[3]\pos = (_this_\items()\text\pos+_this_\items()\text[3]\pos)
      _this_\text[3]\len = (_this_\text\len - _this_\text[3]\pos)
      _this_\text[3]\string.s = Right(_this_\text\string.s, _this_\text[3]\len)
      _this_\text[2]\len = (_this_\text[3]\pos-_this_\text[2]\pos)
    EndIf
    
    If _len_
      _this_\items()\text[2]\change = #True 
      _this_\items()\text[2]\string.s = Mid(_this_\items()\text\string.s, 1 + _this_\items()\text[2]\pos, _this_\items()\text[2]\len) 
      
      _this_\text[2]\change = #True 
      _this_\text[2]\string.s = Mid(_this_\text\string.s, 1 + _this_\text[2]\pos, _this_\text[2]\len) 
    EndIf
  EndMacro
  
  Procedure text_setsel(*this._s_widget) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Pos.i, Len.i
    
    With *this
      ;Debug "7777    "+\text\caret\pos +" "+ \text\caret\end +" "+\index[1] +" "+ \index[2] +" "+ \items()\text\string
      
      If (Caret <> \text\caret\pos Or Line <> \index[1] Or (\text\caret\end >= 0 And Caret1 <> \text\caret\end))
        
        Line = \index[1]
        Caret = \text\caret\pos 
        Caret1 = \text\caret\end
        
        If \index[2] = \index[1]
          If \text\caret\end = \text\caret\pos 
            Pos = \text\caret\end
            len = 0
            ; Если выделяем справо на лево
          ElseIf \text\caret\end > \text\caret\pos 
            ; |<<<<<< to left
            Pos = \text\caret\pos 
            Len = (\text\caret\end-Pos)
          Else 
            ; >>>>>>| to right
            Pos = \text\caret\end
            Len = (\text\caret\pos -Pos)
          EndIf
          
          ; Если выделяем снизу вверх
        ElseIf \index[2] > \index[1]
          ; |^^^^^
          Pos = \text\caret\pos 
          Len = (\items()\text\len-Pos) ; - Bool(\items()\text\len=Pos) ; 
        Else
          ; VVVVV|
          Pos = 0
          Len = \text\caret\pos 
        EndIf
        
        _text_select_(*this, Pos, Len)
        
        ProcedureReturn 1
      EndIf
    EndWith
    
    ProcedureReturn Pos
  EndProcedure
  
  Procedure.i text_selreset(*this._s_widget)
    With *this
      PushListPosition(\items())
      ForEach \items() 
        If \items()\text[2]\len <> 0
          \items()\text[2]\len = 0 
          \items()\text[2]\width[2] = 0 
          \items()\text[1]\string = ""
          \items()\text[2]\string = "" 
          \items()\text[3]\string = ""
          \items()\text[2]\width = 0 
        EndIf
      Next
      PopListPosition(\items())
    EndWith
  EndProcedure
  
  Procedure.i text_sellimits(*this._s_widget)
    Protected i, char.i
    
    Macro _text_selend_(_char_)
      Bool((_char_ > = ' ' And _char_ = < '/') Or 
           (_char_ > = ':' And _char_ = < '@') Or 
           (_char_ > = '[' And _char_ = < 96) Or 
           (_char_ > = '{' And _char_ = < '~'))
    EndMacro
    
    With *this
      char = Asc(Mid(\items()\text\string.s, \text\caret\pos + 1, 1))
      If _text_selend_(char)
        \text\caret\pos + 1
        \items()\text[2]\len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \text\caret\pos To 1 Step - 1
          char = Asc(Mid(\items()\text\string.s, i, 1))
          If _text_selend_(char)
            Break
          EndIf
        Next 
        
        \text\caret\end = i
        
        ; >>>>>>| right edge of the word
        For i = \text\caret\pos To \items()\text\len
          char = Asc(Mid(\items()\text\string.s, i, 1))
          If _text_selend_(char)
            Break
          EndIf
        Next 
        
        \text\caret\pos = i - 1
        \items()\text[2]\len = \text\caret\end - \text\caret\pos 
      EndIf
    EndWith           
  EndProcedure
  
  Procedure.s text_insert_make(*this._s_widget, Text.s)
    Protected String.s, i.i, Len.i
    
    With *this
      If \text\Numeric And Text.s <> #LF$
        Static Dot, Minus
        Protected Chr.s, Input.i, left.s, count.i
        
        Len = Len(Text.s) 
        For i = 1 To Len 
          Chr = Mid(Text.s, i, 1)
          Input = Asc(Chr)
          
          Select Input
            Case '0' To '9', '.','-'
            Case 'Ю','ю','Б','б',44,47,60,62,63 : Input = '.' : Chr = Chr(Input)
            Default
              Input = 0
          EndSelect
          
          If Input
            If \type = #PB_GadgetType_IPAddress
              left.s = Left(\text\string, \text\caret\pos )
              Select CountString(left.s, ".")
                Case 0 : left.s = StringField(left.s, 1, ".")
                Case 1 : left.s = StringField(left.s, 2, ".")
                Case 2 : left.s = StringField(left.s, 3, ".")
                Case 3 : left.s = StringField(left.s, 4, ".")
              EndSelect                                           
              count = Len(left.s+Trim(StringField(Mid(\text\string, \text\caret\pos +1), 1, "."), #LF$))
              If count < 3 And (Val(left.s) > 25 Or Val(left.s+Chr.s) > 255)
                Continue
                ;               ElseIf Mid(\text\string, \text\caret\pos + 1, 1) = "."
                ;                 \text\caret\pos + 1 : \text\caret\end=\text\caret\pos 
              EndIf
            EndIf
            
            If Not Dot And Input = '.' And Mid(\text\string, \text\caret\pos + 1, 1) <> "."
              Dot = 1
            ElseIf Input <> '.' And count < 3
              Dot = 0
            Else
              Continue
            EndIf
            
            If Not Minus And Input = '-' And Mid(\text\string, \text\caret\pos + 1, 1) <> "-"
              Minus = 1
            ElseIf Input <> '-'
              Minus = 0
            Else
              Continue
            EndIf
            
            String.s + Chr
          EndIf
        Next
        
      ElseIf \text\pass
        Len = Len(Text.s) 
        For i = 1 To Len : String.s + "●" : Next
        
      Else
        Select #True
          Case \text\lower : String.s = LCase(Text.s)
          Case \text\Upper : String.s = UCase(Text.s)
          Default
            String.s = Text.s
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn String.s
  EndProcedure
  
  Procedure.l text_scroll(*this._s_widget, Width.l)
    Protected.l Left,Right
    
    With *this
      ; Если строка выходит за предели виджета
      PushListPosition(\items())
      If SelectElement(\items(), \text\_scroll_line_index) ;And \items()\text\x+\items()\text\width > \items()\x+\items()\width
        Protected Caret.i =- 1, i.i, cursor_x.i, Distance.f, MinDistance.f = Infinity()
        Protected String.s = \items()\text\string.s
        Protected string_len.i = \items()\text\len
        Protected mouse_x.i = \root\mouse\x-(\items()\text\x+\scroll\x)
        
        For i = 0 To string_len
          cursor_x = TextWidth(Left(String.s, i))
          Distance = (mouse_x-cursor_x)*(mouse_x-cursor_x)
          
          If MinDistance > Distance 
            MinDistance = Distance
            Right =- cursor_x
            Caret = i
          EndIf
        Next
        
        Left = (Width + Right)
        \items()\text[3]\width = TextWidth(Right(String.s, string_len-Caret))
        
        If \scroll\x < Right
          Scroll::SetState(\scroll\h, -Right) ;: \scroll\x = Right
        ElseIf \scroll\x > Left
          Scroll::SetState(\scroll\h, -Left) ;: \scroll\x = Left
        ElseIf (\scroll\x < 0 And \root\keyboard\input = 65535 ) : \root\keyboard\input = 0
          \scroll\x = (Width-\items()\text[3]\width) + Right
          If \scroll\x>0 : \scroll\x=0 : EndIf
        EndIf
      EndIf
      PopListPosition(\items())
    EndWith
    
    ProcedureReturn Left
  EndProcedure
  
  Procedure.b text_paste(*this._s_widget, Chr.s, Count.l=0)
    Protected Repaint.b
    
    With *this
      If \index[1] <> \index[2] ; Это значить строки выделени
        If \index[2] > \index[1] : Swap \index[2], \index[1] : EndIf
        
        text_selreset(*this)
        
        If Count
          \index[2] + Count
          \text\caret\pos = Len(StringField(Chr.s, 1 + Count, #LF$))
        ElseIf Chr.s = #LF$ ; to return
          \index[2] + 1
          \text\caret\pos = 0
        Else
          \text\caret\pos = \items()\text[1]\len + Len(Chr.s)
        EndIf
        
        \text\caret\end = \text\caret\pos 
        \index[1] = \index[2]
        \text\change =- 1 ; - 1 post event change widget
        Repaint = #True 
      EndIf
      
      \text\string.s = \text[1]\string + Chr.s + \text[3]\string
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.b text_insert(*this._s_widget, Chr.s)
    Static Dot, Minus, Color.i
    Protected Repaint.b, Input, Input_2, String.s, Count.i
    
    With *this
      Chr.s = text_insert_make(*this, Chr.s)
      
      If Chr.s
        Count = CountString(Chr.s, #LF$)
        
        If Not text_paste(*this, Chr.s, Count)
          If \items()\text[2]\len 
            If \text\caret\pos > \text\caret\end : \text\caret\pos = \text\caret\end : EndIf
            \items()\text[2]\len = 0 : \items()\text[2]\string.s = "" : \items()\text[2]\change = 1
          EndIf
          
          \items()\text[1]\change = 1
          \items()\text[1]\string.s + Chr.s
          \items()\text[1]\len = Len(\items()\text[1]\string.s)
          
          \items()\text\string.s = \items()\text[1]\string.s + \items()\text[3]\string.s
          \items()\text\len = \items()\text[1]\len + \items()\text[3]\len : \items()\text\change = 1
          
          If Count
            \index[2] + Count
            \index[1] = \index[2] 
            \text\caret\pos = Len(StringField(Chr.s, 1 + Count, #LF$))
          Else
            \text\caret\pos + Len(Chr.s) 
          EndIf
          
          \text\string.s = \text[1]\string + Chr.s + \text[3]\string
          \text\caret\end = \text\caret\pos 
          ; \countitems = CountString(\text\string.s, #LF$)
          \text\change =- 1 ; - 1 post event change widget
        EndIf
        
        SelectElement(\items(), \index[2]) 
        Repaint = 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.b text_cut(*this._s_widget)
    ProcedureReturn text_paste(*this._s_widget, "")
  EndProcedure
  
  Procedure.s text_wrap(Text.s, Width.i, Mode.i=-1, nl$=#LF$, DelimList$=" "+Chr(9))
    Protected.i CountString, i, start, ii, found, length
    Protected line$, ret$="", LineRet$=""
    
    ;     Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CR$, #LF$)
    ;     Text.s + #LF$
    ;     
    CountString = CountString(Text.s, #LF$) ;+ 1
    
    For i = 1 To CountString
      line$ = StringField(Text.s, i, #LF$)
      start = Len(line$)
      length = start
      
      ; Get text len
      While length > 1
        If width > TextWidth(RTrim(Left(line$, length)))
          Break
        Else
          length - 1 
        EndIf
      Wend
      
      While start > length 
        If mode
          For ii = length To 0 Step - 1
            If mode = 2 And CountString(Left(line$,ii), " ") > 1     And width > 71 ; button
              found + FindString(delimList$, Mid(RTrim(line$),ii,1))
              If found <> 2
                Continue
              EndIf
            Else
              found = FindString(delimList$, Mid(line$,ii,1))
            EndIf
            
            If found
              start = ii
              Break
            EndIf
          Next
        EndIf
        
        If found
          found = 0
        Else
          start = length
        EndIf
        
        LineRet$ + Left(line$, start) + nl$
        line$ = LTrim(Mid(line$, start+1))
        start = Len(line$)
        length = start
        
        ; Get text len
        While length > 1
          If width > TextWidth(RTrim(Left(line$, length)))
            Break
          Else
            length - 1 
          EndIf
        Wend
      Wend
      
      ret$ + LineRet$ + line$ + nl$
      LineRet$=""
    Next
    
    If Width > 1
      ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
    EndIf
  EndProcedure
  
  Procedure.i text_multiline_make(*this._s_widget)
    Static string_out.s
    Protected Repaint, String.s, text_width
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    With *this
      If \vertical
        Width = \height[2]
        Height = \width[2]
      Else
        width = \width[2]-\sci\margin\width
        height = \height[2]
      EndIf
      
      If \text\multiLine > 0
        String.s = text_wrap(\text\string.s+#LF$, Width, \text\multiLine)
      Else
        String.s = \text\string.s
      EndIf
      
      
      If string_out <> String.s 
        string_out = String.s
        \countitems = CountString(String.s, #LF$)
        
        ; reset 
        \text\pos = 0
        \scroll\width = 0
        _set_content_Y_(*this)
        
        ; 
        If ListSize(\items()) 
          Protected Left = text_scroll(*this, Width)
        EndIf
        
        If \text\count <> \countitems 
          \text\count = \countitems
          
          ; Scroll hight reset 
          \scroll\height = 0
          ClearList(\items())
          
          
          Protected *Sta.Character = @string_out, *End.Character = @string_out 
          ;Protected *Sta.Character = @string, *End.Character = @string 
          Protected time = ElapsedMilliseconds()
          ; ;           While *End\c : If *End\c = #LF : String = PeekS (*Sta, (*End-*Sta)/#__sOC)
          
          If CreateRegularExpression(0, ~".*\n?")
            ; If CreateRegularExpression(0, ~"^.*", #PB_RegularExpression_MultiLine)
            If ExamineRegularExpression(0, string_out)
              While NextRegularExpressionMatch(0)  ; 239
                String.s = Trim(RegularExpressionMatchString(0), #LF$)
                
                
                If AddElement(\items())
                  If \type = #PB_GadgetType_Button
                    \items()\text\width = TextWidth(RTrim(String.s))
                  Else
                    \items()\text\width = TextWidth(String.s)
                  EndIf
                  
                  \items()\draw = 1
                  
                  \items()\focus =- 1
                  \items()\index[1] =- 1
                  \items()\color\state = 1 ; Set line default colors
                  \items()\round = \round
                  \items()\text\string.s = String.s
                  \items()\index = ListIndex(\items())
                  
                  ; Update line pos in the text
                  _set_line_pos_(*this)
                  
                  ; Debug "f - "+String.s +" "+ CountString(String, #CR$) +" "+ CountString(String, #LF$) +" - "+ \items()\text\pos +" "+ \items()\text\len
                  
                  _set_content_X_(*this)
                  _line_resize_X_(*this)
                  _line_resize_Y_(*this)
                  
                  ; Scroll width length
                  _set_scroll_width_(*this)
                  
                  ; Scroll hight length
                  _set_scroll_height_(*this)
                  
                  ;                     If \index[2] = ListIndex(\items())
                  ;                       ;Debug " string "+String.s
                  ;                       \items()\text[1]\string.s = Left(\items()\text\string.s, \text\caret\pos ) : \items()\text[1]\change = #True
                  ;                       \items()\text[3]\string.s = Right(\items()\text\string.s, \items()\text\len-(\text\caret\pos + \items()\text[2]\len)) : \items()\text[3]\change = #True
                  ;                     EndIf
                EndIf
                
              Wend
            EndIf
            
            FreeRegularExpression(0)
          Else
            Debug RegularExpressionError()
          EndIf
          
          
          ; ;           *Sta = *End + #__sOC : EndIf : *End + #__sOC : Wend
          
          ;  MessageRequester("", Str(ElapsedMilliseconds()-time) + " text parse time ")
          Debug Str(ElapsedMilliseconds()-time) + " text parse time "
          
        Else
          Protected time2 = ElapsedMilliseconds()
          
          ; If CreateRegularExpression(0, ~".*\n?\r?")
          If CreateRegularExpression(0, ~".*\n?")
            ; If CreateRegularExpression(0, ~"^.*", #PB_RegularExpression_MultiLine)
            If ExamineRegularExpression(0, string_out)
              While NextRegularExpressionMatch(0)
                String.s = Trim(RegularExpressionMatchString(0), #LF$)
                
                ;         Debug "    Position: " + Str(RegularExpressionMatchPosition(0))
                ;         Debug "    Length: " + Str(RegularExpressionMatchLength(0))
                IT+1
                If SelectElement(\items(), IT-1)
                  If \items()\text\string.s <> String.s Or \items()\text\change
                    \items()\text\string.s = String.s
                    
                    If \type = #PB_GadgetType_Button
                      \items()\text\width = TextWidth(RTrim(String.s))
                    Else
                      \items()\text\width = TextWidth(String.s)
                    EndIf
                  EndIf
                  
                  ; Update line pos in the text
                  _set_line_pos_(*this)
                  
                  ; Resize item
                  If (Left And Not  Bool(\scroll\x = Left))
                    _set_content_X_(*this)
                  EndIf
                  
                  _line_resize_X_(*this)
                  
                  ; Set scroll width length
                  _set_scroll_width_(*this)
                EndIf
                
              Wend
            EndIf
            
            FreeRegularExpression(0)
          Else
            Debug RegularExpressionError()
          EndIf
          
          Debug Str(ElapsedMilliseconds()-time2) + " text parse time2 "
          
        EndIf
      Else
        ; Scroll hight reset 
        \scroll\height = 0
        _set_content_Y_(*this)
        
        ForEach \items()
          If Not \items()\hide
            _set_content_X_(*this)
            _line_resize_X_(*this)
            _line_resize_Y_(*this)
            
            ; Scroll hight length
            _set_scroll_height_(*this)
          EndIf
        Next
      EndIf
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  ;- - DRAWINGs
  Procedure.i Draw(*this._s_widget)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    Protected angle.f
    
    If Not *this\hide
      
      With *this
        If \text\fontID 
          DrawingFont(\text\fontID) 
        EndIf
        
        
        If \text\change And \sci\margin\width ; = 1 Or \text\change
          \countitems = CountString(\text\string.s, #LF$)
          \sci\margin\width = TextWidth(Str(\countitems))+11
          ;  Scroll::Resizes(\scroll, \x[2]+\sci\margin\width+1,\y[2],\width[2]-\sci\margin\width-1,\height[2])
        EndIf
        
        
        ; Then changed text
        If \text\change
          \text\height[1] = TextHeight("A") + Bool(\countitems<>1 And \flag\gridLines)
          If \type = #PB_GadgetType_Tree
            \text\height = 20
          Else
            \text\height = \text\height[1]
          EndIf
          \text\width = TextWidth(\text\string.s)
        EndIf
        
        ; Then resized widget
        If \resize
          ; Посылаем сообщение об изменении размера 
          PostEvent(#PB_Event_Widget, \root\window, *this, #PB_EventType_Resize, \resize)
          CompilerIf Defined(Scroll, #PB_Module)
            ;  Scroll::Resizes(\scroll, \x[2]+\sci\margin\width,\y[2],\width[2]-\sci\margin\width,\height[2])
            Scroll::Resizes(\scroll, \x[2],\y[2],\width[2],\height[2])
          CompilerElse
            \scroll\width[2] = \width[2]
            \scroll\height[2] = \height[2]
          CompilerEndIf
        EndIf
        
        ; Widget inner coordinate
        iX=\x[2]
        iY=\y[2]
        iwidth = \scroll\width[2]
        iheight = \scroll\height[2]
        
        ; Make output multi line text
        If (\text\change Or \resize)
          text_multiline_make(*this)
          
          ;This is for the caret and scroll when entering the key - (enter & beckspace)
          If \text\change And \index[2] >= 0 And \index[2] < ListSize(\items())
            SelectElement(\items(), \index[2])
            
            CompilerIf Defined(Scroll, #PB_Module)
              If \scroll\v And \scroll\v\max <> \scroll\height And 
                 Scroll::SetAttribute(\scroll\v, #__bar_Maximum, \scroll\height - Bool(\flag\gridLines)) 
                
                \scroll\v\page\scrollStep = \text\height
                
                If \text\editable And (\items()\y >= (\scroll\height[2]-\items()\height))
                  ; This is for the editor widget when you enter the key - (enter & backspace)
                  Scroll::SetState(\scroll\v, (\items()\y-((\scroll\height[2]+\text\y)-\items()\height)))
                EndIf
                
                Scroll::Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                
                If \scroll\v\hide 
                  \scroll\width[2] = \width[2]
                  \items()\width = \scroll\width[2]
                  iwidth = \scroll\width[2]
                  
                  ;  Debug ""+\scroll\v\hide +" "+ \scroll\height
                EndIf
              EndIf
              
              If \scroll\h And \scroll\h\max<>\scroll\width And 
                 Scroll::SetAttribute(\scroll\h, #__bar_Maximum, \scroll\width)
                Scroll::Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                ;  \scroll\width[2] = \width[2] - Bool(Not \scroll\v\hide)*\scroll\v\width : iwidth = \scroll\width[2]
              EndIf
              
              
              ; При вводе текста перемещать ползунок
              If \root\keyboard\input And \items()\text\x+\items()\text\width > \items()\x+\items()\width
                Debug ""+\scroll\h\max +" "+ Str(\items()\text\x+\items()\text\width)
                
                If \scroll\h\max = (\items()\text\x+\items()\text\width)
                  Scroll::SetState(\scroll\h, \scroll\h\max)
                Else
                  Scroll::SetState(\scroll\h, \scroll\h\page\pos + TextWidth(Chr(\root\keyboard\input)))
                EndIf
              EndIf
              
            CompilerEndIf
          EndIf
        EndIf 
        
        ;
        If \text\editable And ListSize(\items())
          If \text\change =- 1
            \text[1]\change = 1
            \text[3]\change = 1
            \text\len = Len(\text\string.s)
            _text_select_(*this, \text\caret\pos , 0)
            
            ; Посылаем сообщение об изменении содержимого 
            PostEvent(#PB_Event_Widget, \root\window, *this, #PB_EventType_Change)
          EndIf
          
          ; Caaret pos & len
          If \items()\text[1]\change : \items()\text[1]\change = #False
            \items()\text[1]\width = TextWidth(\items()\text[1]\string.s)
            
            ; demo
            ;             Protected caret1, caret = \text\caret\len
            
            ; Положение карета
            If \text\caret\end = \text\caret\pos 
              \text\caret\len = \items()\text[1]\width
              ;               caret1 = \text\caret\len
            EndIf
            
            ; Если перешли за границы итемов
            If \index[1] =- 1
              \text\caret\len = 0
            ElseIf \index[1] = ListSize(\items())
              \text\caret\len = \items()\text\width
            ElseIf \items()\text\len = \items()\text[2]\len
              \text\caret\len = \items()\text\width
            EndIf
            
            ;             If Caret<>\text\caret\len
            ;               Debug "Caret change " + caret +" "+ caret1 +" "+ \text\caret\len +" "+\index[1] +" "+\index[2]
            ;               caret = \text\caret\len
            ;             EndIf
            
          EndIf
          
          If \items()\text[2]\change : \items()\text[2]\change = #False 
            \items()\text[2]\x = \items()\text\x+\items()\text[1]\width
            \items()\text[2]\width = TextWidth(\items()\text[2]\string.s) ; + Bool(\items()\text[2]\len =- 1) * \flag\fullSelection ; TextWidth() - bug in mac os
            
            \items()\text[3]\x = \items()\text[2]\x+\items()\text[2]\width
          EndIf 
          
          If \items()\text[3]\change : \items()\text[3]\change = #False 
            \items()\text[3]\width = TextWidth(\items()\text[3]\string.s)
          EndIf 
          
          If (\focus = *this And \root\mouse\buttons And (Not \scroll\v\from And Not \scroll\h\from)) 
            Protected Left = text_scroll(*this, \items()\width)
          EndIf
        EndIf
        
        ; Draw back color
        If \color\fore[\color\state]
          DrawingMode(#PB_2DDrawing_Gradient)
          BoxGradient(\Vertical,\x[1],\y[1],\width[1],\height[1],\color\fore[\color\state],\color\back[\color\state],\round)
        Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round,\color\back[\color\state])
        EndIf
        
        ; Draw margin back color
        If \sci\margin\width
          DrawingMode(#PB_2DDrawing_Default)
          Box(ix, iy, \sci\margin\width, \height[2], \sci\margin\color\back); $C8D7D7D7)
        EndIf
      EndWith 
      
      ; Draw Lines text
      With *this\items()
        If ListSize(*this\items())
          PushListPosition(*this\items())
          ForEach *this\items()
            ; Is visible lines ---
            Drawing = Bool(\y+\height+*this\scroll\y>*this\y[2] And (\y-*this\y[2])+*this\scroll\y<iheight)
            ;\hide = Bool(Not Drawing)
            
            If \hide
              Drawing = 0
            EndIf
            
            If Drawing
              If \text\fontID 
                DrawingFont(\text\fontID) 
                ;               ElseIf *this\text\fontID 
                ;                 DrawingFont(*this\text\fontID) 
              EndIf
              
              If \text\change : \text\change = #False
                \text\width = TextWidth(\text\string.s) 
                
                If \text\fontID 
                  \text\height = TextHeight("A") 
                Else
                  \text\height = *this\text\height[1]
                EndIf
              EndIf 
              
              If \text[1]\change : \text[1]\change = #False
                \text[1]\width = TextWidth(\text[1]\string.s) 
              EndIf 
              
              If \text[3]\change : \text[3]\change = #False 
                \text[3]\width = TextWidth(\text[3]\string.s)
              EndIf 
              
              If \text[2]\change : \text[2]\change = #False 
                \text[2]\x = \text\x+\text[1]\width
                ; Debug "get caret "+\text[3]\len
                \text[2]\width = TextWidth(\text[2]\string.s) + Bool(\text\len = \text[2]\len Or \text[2]\len =- 1 Or \text[3]\len = 0) * *this\flag\fullSelection ; TextWidth() - bug in mac os
                \text[3]\x = \text[2]\x+\text[2]\width
              EndIf 
            EndIf
            
            
            If \change = 1 : \change = 0
              Protected indent = 8 + Bool(*this\image\width)*4
              ; Draw coordinates 
              \sublevellen = *this\text\x + (7 - *this\sublevellen) + ((\sublevel + Bool(*this\flag\buttons)) * *this\sublevellen) + Bool(*this\flag\checkBoxes)*17
              \image\x + \sublevellen + indent
              \text\x + \sublevellen + *this\image\width + indent
              
              ; Scroll width length
              _set_scroll_width_(*this)
            EndIf
            
            Height = \height
            Y = \y+*this\scroll\y
            Text_X = \text\x+*this\scroll\x
            Text_Y = \text\y+*this\scroll\y
            ; Debug Text_X
            
            ; expanded & collapsed box
            _set_open_box_XY_(*this, *this\items(), *this\x+*this\scroll\x, Y)
            
            ; checked box
            _set_check_box_XY_(*this, *this\items(), *this\x+*this\scroll\x, Y)
            
            ; Draw selections
            If Drawing And (\index=*this\index[1] Or \index=\focus Or \index=\index[1]) ; \color\state;
              If *this\row\color\back[\color\state]<>-1                                 ; no draw transparent
                If *this\row\color\fore[\color\state]
                  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                  BoxGradient(\Vertical,*this\x[2],Y,iwidth,\height,RowForeColor(*this, \color\state) ,RowBackColor(*this, \color\state) ,\round)
                Else
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  RoundBox(*this\x[2],Y,iwidth,\height,\round,\round,RowBackColor(*this, \color\state) )
                EndIf
              EndIf
              
              If *this\row\color\frame[\color\state]<>-1 ; no draw transparent
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(*this\x[2],Y,iwidth,\height,\round,\round, RowFrameColor(*this, \color\state) )
              EndIf
            EndIf
            
            ; Draw plot
            ;_draw_plots_(*this, *this\items(), *this\x+*this\scroll\x, \box\y+\box\height/2)
            
            If Drawing
              ; Draw boxes
              If *this\flag\buttons And \childrens
                DrawingMode(#PB_2DDrawing_Default)
                CompilerIf Defined(Scroll, #PB_Module)
                  Scroll::Arrow(\box\x[0]+(\box\width[0]-6)/2,\box\y[0]+(\box\height[0]-6)/2, 6, Bool(Not \collapsed)+2, RowFontColor(*this, \color\state), 0,0) 
                CompilerEndIf
              EndIf
              
              ; Draw image
              If \image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\image\handle, \image\x+*this\scroll\x, \image\y+*this\scroll\y, *this\row\color\alpha)
              EndIf
              
              ; Draw text
              Angle = Bool(\vertical)**this\text\rotate
              Protected Front_BackColor_1 = RowFontColor(*this, *this\color\state) ; *this\color\front[*this\color\state]&$FFFFFFFF|*this\row\color\alpha<<24
              Protected Front_BackColor_2 = RowFontColor(*this, 2)                 ; *this\color\front[2]&$FFFFFFFF|*this\row\color\alpha<<24
              
              ; Draw string
              If \text[2]\len And *this\color\front <> *this\row\color\front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*this\text\caret\end > *this\text\caret\pos And *this\index[2] = *this\index[1]) Or
                     (\index = *this\index[1] And *this\index[2] > *this\index[1])
                    \text[3]\x = \text\x+TextWidth(Left(\text\string.s, *this\text\caret\end)) 
                    
                    If *this\index[2] = *this\index[1]
                      \text[2]\x = \text[3]\x-\text[2]\width
                    EndIf
                    
                    If \text[3]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\text[3]\x+*this\scroll\x, Text_Y, \text[3]\string.s, angle, Front_BackColor_1)
                    EndIf
                    
                    If *this\row\color\fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      BoxGradient(\Vertical,\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height,RowForeColor(*this, 2),RowBackColor(*this, 2),\round)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height, RowBackColor(*this, 2) )
                    EndIf
                    
                    If \text[2]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \text[1]\string.s+\text[2]\string.s, angle, Front_BackColor_2)
                    EndIf
                    
                    If \text[1]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \text[1]\string.s, angle, Front_BackColor_1)
                    EndIf
                  Else
                    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                    DrawRotatedText(Text_X, Text_Y, \text\string.s, angle, Front_BackColor_1)
                    
                    If *this\row\color\fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      BoxGradient(\Vertical,\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height,RowForeColor(*this, 2),RowBackColor(*this, 2),\round)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height, RowBackColor(*this, 2))
                    EndIf
                    
                    If \text[2]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\text[2]\x+*this\scroll\x, Text_Y, \text[2]\string.s, angle, Front_BackColor_2)
                    EndIf
                  EndIf
                CompilerElse
                  If \text[1]\string.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \text[1]\string.s, angle, Front_BackColor_1)
                  EndIf
                  
                  If *this\row\color\fore[2]
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    BoxGradient(\Vertical,\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height,RowForeColor(*this, 2),RowBackColor(*this, 2),\round)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height, RowBackColor(*this, 2))
                  EndIf
                  
                  If \text[2]\string.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\text[2]\x+*this\scroll\x, Text_Y, \text[2]\string.s, angle, Front_BackColor_2)
                  EndIf
                  
                  If \text[3]\string.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\text[3]\x+*this\scroll\x, Text_Y, \text[3]\string.s, angle, Front_BackColor_1)
                  EndIf
                CompilerEndIf
                
              Else
                If \text[2]\len
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\text[2]\x+*this\scroll\x, Y, \text[2]\width+\text[2]\width[2], Height, RowBackColor(*this, 2))
                EndIf
                
                If \color\state = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \text[0]\string.s, angle, Front_BackColor_2)
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \text[0]\string.s, angle, Front_BackColor_1)
                EndIf
              EndIf
              
              ; Draw margin
              If *this\sci\margin\width
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(*this\sci\margin\width-TextWidth(Str(\index))-3, \y+*this\scroll\y, Str(\index), *this\sci\margin\color\front)
              EndIf
            EndIf
          Next
          PopListPosition(*this\items()) ; 
        EndIf
      EndWith  
      
      
      With *this
        ; Draw caret
        If \text\editable And \focus = *this : DrawingMode(#PB_2DDrawing_XOr)             
          ;  Line((\items()\text\x-\scroll\h\page\pos) + \text\caret\len - Bool(#PB_Compiler_OS = #PB_OS_Windows) - Bool(Left < \scroll\x), \items()\y+\scroll\y, 1, Height, $FFFFFFFF)
          ;  Line(\text\caret\x - Bool(Left < \scroll\x), \text\caret\y, \text\caret\width, \text\caret\height, $FFFFFFFF)
          Line(\text\caret\x - Bool(Left < \scroll\x), \text\caret\y, 1, height, $FFFFFFFF)
        EndIf
        
        ; Draw scroll bars
        CompilerIf Defined(Scroll, #PB_Module)
          Scroll::Draw(\scroll\v)
          Scroll::Draw(\scroll\h)
        CompilerEndIf
      EndWith
      
      ; Draw frames
      With *this
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If \focus = *this
          If \color\state = 2
            RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round,\color\front[2])
            If \round : RoundBox(\x[1],\y[1]-1,\width[1],\height[1]+2,\round,\round,\color\front[2]) : EndIf  ; Сглаживание краев )))
          Else
            RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round,\color\frame[2])
            If \round : RoundBox(\x[1],\y[1]-1,\width[1],\height[1]+2,\round,\round,\color\frame[2]) : EndIf  ; Сглаживание краев )))
          EndIf
          RoundBox(\x[1]-1,\y[1]-1,\width[1]+2,\height[1]+2,\round,\round,\color\frame[2])
        ElseIf \fs
          Select \fs[1] 
            Case 1 ; Flat
              RoundBox(iX-1,iY-1,iWidth+2,iHeight+2,\round,\round, $FFE1E1E1)  
              
            Case 2 ; Single
              _frame_(*this, iX,iY,iWidth,iHeight, $FFE1E1E1, $FFFFFFFF)
              
            Case 3 ; Double
              _frame_(*this, iX-1,iY-1,iWidth+2,iHeight+2, $FF888888, $FFFFFFFF)
              If \round : RoundBox(iX-1,iY-1-1,iWidth+2,iHeight+2+1,\round,\round,$FF888888) : EndIf  ; Сглаживание краев )))
              If \round : RoundBox(iX-2,iY-1-1,iWidth+3,iHeight+2+1,\round,\round,$FF888888) : EndIf  ; Сглаживание краев )))
              _frame_(*this, iX,iY,iWidth,iHeight, $FF888888, $FFE1E1E1)
              
            Case 4 ; Raised
              _frame_(*this, iX-1,iY-1,iWidth+2,iHeight+2, $FFE1E1E1, $FF9E9E9E)
              If \round : RoundBox(iX-1,iY-1,iWidth+3,iHeight+2+1,\round,\round,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              If \round : RoundBox(iX-1,iY-1,iWidth+2,iHeight+2+1,\round,\round,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              _frame_(*this, iX,iY,iWidth,iHeight, $FFFFFFFF, $FF888888)
              
            Default 
              RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round,\color\frame[\color\state])
              
          EndSelect
        EndIf
        
        If \Default
          ; DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawFilterCallback())
          If \Default = *this : \Default = 0
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\x[1]-1,\y[1]-1,\width[1]+2,\height[1]+2,\round,\round,$FF004DFF)
            If \round : RoundBox(\x[1],\y[1]-1,\width[1],\height[1]+2,\round,\round,$FF004DFF) : EndIf
            RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round,$FF004DFF)
          Else
            If \color\state = 2
              RoundBox(\x[1]+2,\y[1]+2,\width[1]-4,\height[1]-4,\round,\round,\color\front[2])
            Else
              RoundBox(\x[1]+2,\y[1]+2,\width[1]-4,\height[1]-4,\round,\round,\color\frame[2])
            EndIf
          EndIf
        EndIf
        
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        ; Scroll area coordinate
        ;Box(\scroll\x, \scroll\y, \scroll\width, \scroll\height, $FFFF0000)
        ; Debug ""+\scroll\x +" "+ \scroll\y +" "+ \scroll\width +" "+ \scroll\height
        Box(\scroll\h\x-\scroll\h\page\pos, \scroll\v\y-\scroll\v\page\pos, \scroll\h\max, \scroll\v\max, $FFFF0000)
        
        ; page coordinate
        Box(\scroll\h\x, \scroll\v\y, \scroll\h\page\len, \scroll\v\page\len, $FF00FF00)
        
        
        
        If \text\change : \text\change = 0 : EndIf
        If \resize : \resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i ReDraw(*this._s_widget, Canvas =- 1, BackColor=$FFF0F0F0)
    If *this
      With *this
        If Canvas =- 1 
          Canvas = \root\canvas 
        ElseIf Canvas <> \root\canvas
          ProcedureReturn 0
        EndIf
        
        If StartDrawing(CanvasOutput(Canvas))
          Draw(*this)
          StopDrawing()
        EndIf
      EndWith
    Else
      If IsGadget(Canvas) And StartDrawing(CanvasOutput(Canvas))
        DrawingMode(#PB_2DDrawing_Default)
        Box(0,0,OutputWidth(),OutputHeight(), BackColor)
        
        With List()\widget
          ForEach List()
            If Canvas = \root\canvas
              Draw(List()\widget)
            EndIf
          Next
        EndWith
        
        StopDrawing()
      EndIf
    EndIf
  EndProcedure
  
  ;-
  ;- - KEYBOARDs
  Procedure.i ToUp(*this._s_widget)
    Protected Repaint
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *this
      If (\index[2] > 0 And \index[1] = \index[2]) : \index[2] - 1 : \index[1] = \index[2]
        SelectElement(\items(), \index[2])
        ;If (\items()\y+\scroll\y =< \y[2])
        Scroll::SetState(\scroll\v, (\items()\y-((\scroll\height[2]+\text\y)-\items()\height)))
        ;EndIf
        ; При вводе перемещаем текста
        If \items()\text\x+\items()\text\width > \items()\x+\items()\width
          Scroll::SetState(\scroll\h, (\items()\text\x+\items()\text\width))
        Else
          Scroll::SetState(\scroll\h, 0)
        EndIf
        ;_text_select_(*this, \text\caret\pos , 0)
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToDown(*this._s_widget)
    Static Line
    Protected Repaint, Shift.i = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Shift)
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *this
      If Shift
        
        If \index[1] = \index[2]
          SelectElement(\items(), \index[1]) 
          _text_select_(*this, \text\caret\end, \items()\text\len-\text\caret\end)
        Else
          SelectElement(\items(), \index[2]) 
          _text_select_(*this, 0, \items()\text\len)
        EndIf
        ; Debug \text\caret\end
        \index[2] + 1
        ;         \text\caret\pos = text_caret(*this, \index[2]) 
        ;         \text\caret\end = \text\caret\pos 
        SelectElement(\items(), \index[2]) 
        _text_select_(*this, 0, \text\caret\end) 
        text_setsel(*this)
        Repaint = 1 
        
      Else
        If (\index[1] < ListSize(\items()) - 1 And \index[1] = \index[2]) : \index[2] + 1 : \index[1] = \index[2]
          SelectElement(\items(), \index[2]) 
          ;If (\items()\y >= (\scroll\height[2]-\items()\height))
          Scroll::SetState(\scroll\v, (\items()\y-((\scroll\height[2]+\text\y)-\items()\height)))
          ;EndIf
          
          If \items()\text\x+\items()\text\width > \items()\x+\items()\width
            Scroll::SetState(\scroll\h, (\items()\text\x+\items()\text\width))
          Else
            Scroll::SetState(\scroll\h, 0)
          EndIf
          
          ;_text_select_(*this, \text\caret\pos , 0)
          Repaint =- 1 
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToLeft(*this._s_widget) ; Ok
    Protected Repaint.i, Shift.i = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Shift)
    
    With *this
      If \items()\text[2]\len And Not Shift
        If \index[2] > \index[1] 
          Swap \index[2], \index[1]
          
          If SelectElement(\items(), \index[2]) 
            \items()\text[1]\string.s = Left(\items()\text\string.s, \text\caret\end) 
            \items()\text[1]\change = #True
          EndIf
        ElseIf \index[1] > \index[2] And 
               \text\caret\end > \text\caret\pos 
          Swap \text\caret\end, \text\caret\pos 
        ElseIf \text\caret\pos > \text\caret\end 
          Swap \text\caret\pos , \text\caret\end
        EndIf
        
        If \index[1] <> \index[2]
          text_selreset(*this)
          \index[1] = \index[2]
        Else
          \text\caret\end = \text\caret\pos 
        EndIf 
        Repaint =- 1
        
      ElseIf \text\caret\pos > 0
        If \text\caret\pos > \items()\text\len
          \text\caret\pos = \items()\text\len
        EndIf
        \text\caret\pos - 1 
        
        If Not Shift
          \text\caret\end = \text\caret\pos 
        EndIf
        
        Repaint =- 1 
        
      ElseIf ToUp(*this._s_widget)
        \text\caret\pos = \items()\text\len
        \text\caret\end = \text\caret\pos 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToRight(*this._s_widget) ; Ok
    Protected Repaint.i, Shift.i = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Shift)
    
    With *this
      ;       If \index[1] <> \index[2]
      ;         If Shift 
      ;           \text\caret\pos + 1
      ;           Swap \index[2], \index[1] 
      ;         Else
      ;           If \index[1] > \index[2] 
      ;             Swap \index[1], \index[2] 
      ;             Swap \text\caret\pos , \text\caret\end
      ;             
      ;             If SelectElement(\items(), \index[2]) 
      ;               \items()\text[1]\string.s = Left(\items()\text\string.s, \text\caret\end) 
      ;               \items()\text[1]\change = #True
      ;             EndIf
      ;             
      ;             text_selreset(*this)
      ;             \text\caret\pos = \text\caret\end 
      ;             \index[1] = \index[2]
      ;           EndIf
      ;           
      ;         EndIf
      ;         Repaint =- 1
      ;         
      ;       ElseIf \items()\text[2]\len
      ;         If \text\caret\end > \text\caret\pos 
      ;           Swap \text\caret\end, \text\caret\pos 
      ;         EndIf
      ;         
      ;         If Not Shift
      ;           \text\caret\end = \text\caret\pos 
      ;         Else
      ;           \text\caret\pos + 1
      ;         EndIf
      ;         
      ;         Repaint =- 1
      If \items()\text[2]\len And Not Shift
        If \index[1] > \index[2] 
          Swap \index[1], \index[2] 
          Swap \text\caret\pos , \text\caret\end
          
          If SelectElement(\items(), \index[2]) 
            \items()\text[1]\string.s = Left(\items()\text\string.s, \text\caret\end) 
            \items()\text[1]\change = #True
          EndIf
          
          ;           text_selreset(*this)
          ;           \text\caret\pos = \text\caret\end 
          ;           \index[1] = \index[2]
        EndIf
        
        If \index[1] <> \index[2]
          text_selreset(*this)
          \index[1] = \index[2]
        Else
          \text\caret\pos = \text\caret\end 
        EndIf 
        Repaint =- 1
        
        
      ElseIf \text\caret\pos < \items()\text\len
        \text\caret\pos + 1
        
        If Not Shift
          \text\caret\end = \text\caret\pos 
        EndIf
        
        Repaint =- 1 
      ElseIf ToDown(*this)
        \text\caret\pos = 0
        \text\caret\end = \text\caret\pos 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.b ToInput(*this._s_widget)
    With *this
      If \root\keyboard\input
        
        If text_insert(*this, Chr(\root\keyboard\input))
          ProcedureReturn #True
        Else
          \Default = *this
        EndIf
        
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i ToReturn(*this._s_widget) ; Ok
    
    With  *this
      If Not text_paste(*this, #LF$)
        \index[2] + 1
        \text\caret\pos = 0
        \index[1] = \index[2]
        \text\caret\end = \text\caret\pos 
        \text\change =- 1 ; - 1 post event change widget
      EndIf
    EndWith
    
    ProcedureReturn #True
  EndProcedure
  
  Procedure.i ToBack(*this._s_widget)
    Protected Repaint, String.s, Cut.i
    
    If *this\root\keyboard\input : *this\root\keyboard\input = 0
      ToInput(*this) ; Сбросить Dot&Minus
    EndIf
    *this\root\keyboard\input = 65535
    
    With *this 
      If Not text_cut(*this)
        If \items()\text[2]\len
          
          If \text\caret\pos > \text\caret\end : \text\caret\pos = \text\caret\end : EndIf
          \items()\text[2]\len = 0 : \items()\text[2]\string.s = "" : \items()\text[2]\change = 1
          
          \items()\text\string.s = \items()\text[1]\string.s + \items()\text[3]\string.s
          \items()\text\len = \items()\text[1]\len + \items()\text[3]\len : \items()\text\change = 1
          
          \text\string.s = \text[1]\string + \text[3]\string
          \text\change =- 1 ; - 1 post event change widget
          
        ElseIf \text\caret\end > 0 : \text\caret\pos - 1 
          \items()\text[1]\string.s = Left(\items()\text\string.s, \text\caret\pos )
          \items()\text[1]\len = Len(\items()\text[1]\string.s) : \items()\text[1]\change = 1
          
          \items()\text\string.s = \items()\text[1]\string.s + \items()\text[3]\string.s
          \items()\text\len = \items()\text[1]\len + \items()\text[3]\len : \items()\text\change = 1
          
          \text\string.s = Left(\text\string.s, \items()\text\pos+\text\caret\pos ) + \text[3]\string
          \text\change =- 1 ; - 1 post event change widget
        Else
          ; Если дошли до начала строки то 
          ; переходим в конец предыдущего итема
          If \index[2] > 0 
            \text\string.s = RemoveString(\text\string.s, #LF$, #PB_String_CaseSensitive, \items()\text\pos+\text\caret\pos , 1)
            
            ToUp(*this)
            
            \text\caret\pos = \items()\text\len
            \text\change =- 1 ; - 1 post event change widget
          EndIf
          
        EndIf
      EndIf
      
      If \text\change
        \text\caret\end = \text\caret\pos 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToDelete(*this._s_widget)
    Protected Repaint, String.s
    
    With *this 
      If Not text_cut(*this)
        If \items()\text[2]\len
          If \text\caret\pos > \text\caret\end : \text\caret\pos = \text\caret\end : EndIf
          \items()\text[2]\len = 0 : \items()\text[2]\string.s = "" : \items()\text[2]\change = 1
          
          \items()\text\string.s = \items()\text[1]\string.s + \items()\text[3]\string.s
          \items()\text\len = \items()\text[1]\len + \items()\text[3]\len : \items()\text\change = 1
          
          \text\string.s = \text[1]\string + \text[3]\string
          \text\change =- 1 ; - 1 post event change widget
          
        ElseIf \text\caret\end < \items()\text\len 
          \items()\text[3]\string.s = Right(\items()\text\string.s, \items()\text\len - \text\caret\pos - 1)
          \items()\text[3]\len = Len(\items()\text[3]\string.s) : \items()\text[3]\change = 1
          
          \items()\text\string.s = \items()\text[1]\string.s + \items()\text[3]\string.s
          \items()\text\len = \items()\text[1]\len + \items()\text[3]\len : \items()\text\change = 1
          
          \text[3]\string = Right(\text\string.s, \text\len - (\items()\text\pos + \text\caret\pos ) - 1)
          \text[3]\len = Len(\text[3]\string.s)
          
          \text\string.s = \text[1]\string + \text[3]\string
          \text\change =- 1 ; - 1 post event change widget
        Else
          If \index[2] < (\countitems-1) ; ListSize(\items()) - 1
            \text\string.s = RemoveString(\text\string.s, #LF$, #PB_String_CaseSensitive, \items()\text\pos+\text\caret\pos , 1)
            \text\change =- 1 ; - 1 post event change widget
          EndIf
        EndIf
      EndIf
      
      If \text\change
        \text\caret\end = \text\caret\pos 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToPos(*this._s_widget, Pos.i, Len.i)
    Protected Repaint
    
    With *this
      text_selreset(*this)
      
      If Len
        Select Pos
          Case 1 : FirstElement(\items()) : \text\caret\pos = 0
          Case - 1 : LastElement(\items()) : \text\caret\pos = \items()\text\len
        EndSelect
        
        \index[1] = \items()\index
        Scroll::SetState(\scroll\v, (\items()\y-((\scroll\height[2]+\text\y)-\items()\height)))
      Else
        SelectElement(\items(), \index[1]) 
        \text\caret\pos = Bool(Pos =- 1) * \items()\text\len 
        Scroll::SetState(\scroll\h, Bool(Pos =- 1) * \scroll\h\max)
      EndIf
      
      \text\caret\end = \text\caret\pos 
      \index[2] = \index[1] 
      Repaint =- 1 
      
    EndWith
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  ;- - (SET&GET)s
  Procedure.i AddItem(*this._s_widget, Item.i,Text.s,Image.i=-1,Flag.i=0)
    Static len
    Protected l, i, String.s
    
    If *this
      With *this
        If (Item > 0 And Item < \countitems - 1)
          String.s = StringField(\text\string, item+1, #LF$)
          len = Len(String)
          
          For i = item - 1 To 0 Step - 1
            String = StringField(\text\string, i+1, #LF$) + String
          Next
          
          len = Len(String)+Item-len
        EndIf
        
        \text\string = InsertString(\text\string, Text.s+#LF$, len+1)
        l = Len(Text.s) + 1
        \text\change = 1
        \countitems + 1
        \text\len + l 
        Len + l
      EndWith
    EndIf
    
    ProcedureReturn *this\countitems
  EndProcedure
  
  Procedure SetAttribute(*this._s_widget, Attribute.i, Value.i)
    With *this
      
    EndWith
  EndProcedure
  
  Procedure GetAttribute(*this._s_widget, Attribute.i)
    Protected Result
    
    With *this
      ;       Select Attribute
      ;         Case #__bar_Minimum    : Result = \scroll\min
      ;         Case #__bar_Maximum    : Result = \scroll\max
      ;         Case #__bar_PageLength : Result = \scroll\pageLength
      ;       EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemState(*this._s_widget, Item.i, State.i)
    Protected Result
    
    With *this
      PushListPosition(\items())
      Result = SelectElement(\items(), Item) 
      If Result 
        \items()\index[1] = \items()\index
        \text\caret\pos = State
        \text\caret\end = \text\caret\pos 
      EndIf
      PopListPosition(\items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(*this._s_widget, State.i)
    Protected String.s, *Line
    
    With *this
      PushListPosition(\items())
      ForEach \items()
        If String.s
          String.s +#LF$+ \items()\text\string.s 
        Else
          String.s + \items()\text\string.s
        EndIf
      Next : String.s+#LF$
      PopListPosition(\items())
      
      If \text\string.s <> String.s
        \text\string.s = String.s
        \text\len = Len(String.s)
        Redraw(*this, \root\canvas)
      EndIf
      
      If State <> #PB_Ignore
        \focus = *this
        If GetActiveGadget() <> \root\canvas
          SetActiveGadget(\root\canvas)
        EndIf
        
        PushListPosition(\items())
        If State =- 1
          \index[1] = \countitems - 1
          *Line = LastElement(\items())
          \text\caret\pos = \items()\text\len
        Else
          \index[1] = CountString(Left(String, State), #LF$)
          *Line = SelectElement(\items(), \index[1])
          If *Line
            \text\caret\pos = State-\items()\text\pos
          EndIf
        EndIf
        
        ;If *Line
        ;         \index[2] = \index[1]
        ;         \text[1]\change = 1
        ;         \text[3]\change = 1
        ;         _text_select_(*this, \text\caret\pos , 0)
        
        \items()\text[1]\string = Left(\items()\text\string, \text\caret\pos )
        \items()\text[1]\change = 1
        \text\caret\end = \text\caret\pos 
        
        \items()\index[1] = \items()\index 
        Scroll::SetState(\scroll\v, (\items()\y-((\scroll\height[2]+\text\y)-\items()\height))) ;((\index[1] * \text\height)-\scroll\v\height) + \text\height)
        
        ;         If Not \repaint : \repaint = 1
        ;           PostEvent(#PB_Event_Gadget, \root\window, \root\canvas, #PB_EventType_Repaint)
        ;         EndIf
        Redraw(*this)
        ;EndIf
        PopListPosition(\items())
        
        ; Debug \index[2]
        
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetState(*this._s_widget)
    Protected Result
    
    With *this
      PushListPosition(\items())
      ForEach \items()
        If \items()\index[1] = \items()\index
          Result = \items()\text\pos + \text\caret\pos 
        EndIf
      Next
      PopListPosition(\items())
      
      ; Debug \text[1]\len
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure ClearItems(*this._s_widget)
    *this\countitems = 0
    *this\text\change = 1 
    If *this\text\editable
      *this\text\string = #LF$
    EndIf
    If Not *this\repaint : *this\repaint = 1
      PostEvent(#PB_Event_Gadget, *this\root\window, *this\root\canvas, #PB_EventType_Repaint)
    EndIf
    ProcedureReturn 1
  EndProcedure
  
  Procedure.i CountItems(*this._s_widget)
    ProcedureReturn   *this\countitems
  EndProcedure
  
  Procedure.i RemoveItem(*this._s_widget, Item.i)
    *this\countitems - 1
    *this\text\change = 1
    If *this\countitems =- 1 
      *this\countitems = 0 
      *this\text\string = #LF$
      If Not *this\repaint : *this\repaint = 1
        PostEvent(#PB_Event_Gadget, *this\root\window, *this\root\canvas, #PB_EventType_Repaint)
      EndIf
    Else
      *this\text\string = RemoveString(*this\text\string, StringField(*this\text\string, item+1, #LF$) + #LF$)
    EndIf
  EndProcedure
  
  Procedure.s GetText(*this._s_widget)
    With *this
      If \text\pass
        ProcedureReturn \text\string.s[1]
      Else
        ProcedureReturn \text\string
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i text_setText(*this._s_widget, Text.s)
    Protected Result.i, Len.i, String.s, i.i
    If Text.s="" : Text.s=#LF$ : EndIf
    
    With *this
      If \text\string.s <> Text.s
        \text\string.s = text_insert_make(*this, Text.s)
        
        If \text\string.s
          \text\string.s[1] = Text.s
          
          If \text\multiLine
            Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
            Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
            Text.s = ReplaceString(Text.s, #CR$, #LF$)
            
            \text\string.s = Text.s
            \countitems = CountString(\text\string.s, #LF$)
          Else
            \text\string.s = RemoveString(\text\string.s, #LF$) + #LF$
            ; \text\string.s = RTrim(ReplaceString(\text\string.s, #LF$, " ")) + #LF$
          EndIf
          
          \text\len = Len(\text\string.s)
          \text\change = #True
          Result = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetText(*this._s_widget, Text.s, Item.i=0)
    Protected i
    
    With *this
      If text_setText(*this, Text.s)
        If Not \repaint : \repaint = 1
          PostEvent(#PB_Event_Gadget, \root\window, \root\canvas, #PB_EventType_Repaint)
        EndIf
        ProcedureReturn 1
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i SetFont(*this._s_widget, FontID.i)
    
    With *this
      If \text\fontID <> FontID 
        \text\fontID = FontID
        \text\change = 1
        
        If Not Bool(\text\count And \text\count <> \countitems)
          Redraw(*this, \root\canvas)
        EndIf
        ProcedureReturn 1
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i Resize(*this._s_widget, X.i,Y.i,Width.i,Height.i)
    With *this
      If X<>#PB_Ignore And 
         \x[0] <> X
        \x[0] = X 
        \x[2]=\x[0]+\bs
        \x[1]=\x[2]-\fs
        \resize = 1<<1
      EndIf
      If Y<>#PB_Ignore And 
         \y[0] <> Y
        \y[0] = Y
        \y[2]=\y[0]+\bs
        \y[1]=\y[2]-\fs
        \resize = 1<<2
      EndIf
      If Width<>#PB_Ignore And
         \width[0] <> Width 
        \width[0] = Width 
        \width[2] = \width[0]-\bs*2
        \width[1] = \width[2]+\fs*2
        \resize = 1<<3
      EndIf
      If Height<>#PB_Ignore And 
         \height[0] <> Height
        \height[0] = Height 
        \height[2] = \height[0]-\bs*2
        \height[1] = \height[2]+\fs*2
        \resize = 1<<4
      EndIf
      
      ProcedureReturn \resize
    EndWith
  EndProcedure
  
  ;-
  Procedure editor_setsel(*this._s_widget, Line.i)
    Protected Repaint.i
    
    With *this
      Static _selected_line_=-1
      Protected _caret_, Pos, len, Selection
      Protected _index_ = Line
      Protected _selected_index_ = *this\index[2]
      
      If StartDrawing(CanvasOutput(*this\root\canvas)) 
        If *this\text\fontID 
          DrawingFont(*this\text\fontID) 
        EndIf
        
        If *this\index[1] <> _index_ 
          
          If *this\index[2] = *this\index[1] 
            SelectElement(*this\items(), *this\index[2]) 
            
            *this\text\caret\pos = Bool(_index_>*this\index[1]) * *this\items()\text\len
            
            If \text\caret\end > \text\caret\pos 
              ; |<<<<<< to top
              _text_select_(*this, *this\text\caret\pos, *this\text\caret\end-*this\text\caret\pos)
            Else 
              ; >>>>>>| to bottom
              _text_select_(*this, *this\text\caret\end, *this\text\caret\pos-*this\text\caret\end)
            EndIf
          EndIf
          
        EndIf
        
        ; select enter mouse item
        If _index_ >= 0 And 
           _index_ < *this\countitems And 
           _index_ <> ListIndex(\items())
          SelectElement(*this\items(), _index_) 
        EndIf
        
        *this\text\caret\pos = caret(*this) 
        Repaint | text_setsel(*this)
        

        If *this\index[1] <> _index_ 
          *this\index[1] = _index_
          
          ;PushListPosition(\items()) 
          ForEach *this\items()
            
            If Bool((_selected_index_ > *this\items()\index And _index_ < *this\items()\index) Or   ; верх
                    (_selected_index_ < *this\items()\index And _index_ > *this\items()\index))     ; вниз
              
              ; Выделения целых строк
              _text_select_(*this, 0, *this\items()\text\len - Bool(Not *this\items()\text\len))    ; Выделение пустой строки
              
            ElseIf (*this\items()\text[2]\len And _selected_index_ <> *this\items()\index And _index_ <> *this\items()\index)
              
              ; Сброс выделения целых строк
              ; _text_select_(*this, 0, 0)
              
              \items()\text[1]\len = 0 
              \items()\text[2]\len = 0 
              \items()\text[3]\len = 0 
              
              \items()\text[1]\pos = 0 
              \items()\text[2]\pos = 0 
              \items()\text[3]\pos = 0 
              
              \items()\text[1]\width = 0 
              \items()\text[2]\width = 0 
              \items()\text[3]\width = 0 
              
              \items()\text[1]\string = ""
              \items()\text[2]\string = "" 
              \items()\text[3]\string = ""
              
            EndIf
          Next
          ;PopListPosition(*this\items()) 
          
          Repaint = #True
        EndIf
        
        StopDrawing()
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i events_key_editor(*this._S_widget, eventtype.l, mouse_x.l, mouse_y.l) ; Editable(*this._s_widget, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s, Shift.i
    
    With *this
      Shift = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Shift)
      
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
        Control = Bool((\root\keyboard\key[1] & #PB_Canvas_Control) Or (\root\keyboard\key[1] & #PB_Canvas_Command)) * #PB_Canvas_Control
      CompilerElse
        Control = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Control) * #PB_Canvas_Control
      CompilerEndIf
      
      Select EventType
        Case #PB_EventType_Input ; - Input (key)
          If Not Control         ; And Not Shift
            Repaint = ToInput(*this)
          EndIf
          
        Case #PB_EventType_KeyUp ; Баг в мак ос не происходить событие если зажать cmd
                                 ;  Debug "#PB_EventType_KeyUp "
                                 ;           If \items()\text\Numeric
                                 ;             \items()\text\string.s[1]=\items()\text\string.s 
                                 ;           EndIf
                                 ;           Repaint = #True 
          
        Case #PB_EventType_KeyDown
          Select \root\keyboard\key
            Case #PB_Shortcut_Home : Repaint = ToPos(*this, 1, Control)
            Case #PB_Shortcut_End : Repaint = ToPos(*this, - 1, Control)
            Case #PB_Shortcut_PageUp : Repaint = ToPos(*this, 1, 1)
            Case #PB_Shortcut_PageDown : Repaint = ToPos(*this, - 1, 1)
              
            Case #PB_Shortcut_A
              If Control And (\text[2]\len <> \text\len) ; Or Not \text[2]\len)
                ForEach \items()
                  \items()\text[2]\len = \items()\text\len - Bool(Not \items()\text\len) ; Выделение пустой строки
                  \items()\text[2]\string = \items()\text\string : \items()\text[2]\change = 1
                  \items()\text[1]\string = "" : \items()\text[1]\len = 0 : \items()\text[1]\change = 1
                  \items()\text[3]\string = "" : \items()\text[3]\len = 0 : \items()\text[3]\change = 1
                Next
                
                \text[1]\len = 0 
                \text[1]\string = ""
                
                \text[2]\len = \text\len
                \text[2]\string = \text\string 
                
                \text[3]\len = 0 
                \text[3]\string = ""
                
                \index[2] = 0 
                \index[1] = \countitems - 1
                
                \text\caret\pos = \text[2]\len 
                \text\caret\end = \text\caret\pos 
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_Up     : Repaint = ToUp(*this)      ; Ok
            Case #PB_Shortcut_Left   : Repaint = ToLeft(*this)    ; Ok
            Case #PB_Shortcut_Right  : Repaint = ToRight(*this)   ; Ok
            Case #PB_Shortcut_Down   : Repaint = ToDown(*this)    ; Ok
            Case #PB_Shortcut_Back   : Repaint = ToBack(*this)
            Case #PB_Shortcut_Return : Repaint = ToReturn(*this) 
            Case #PB_Shortcut_Delete : Repaint = ToDelete(*this)
              
            Case #PB_Shortcut_C, #PB_Shortcut_X
              If Control
                SetClipboardText(\text[2]\string)
                
                If \root\keyboard\key = #PB_Shortcut_X
                  Repaint = text_cut(*this)
                EndIf
              EndIf
              
            Case #PB_Shortcut_V
              If \text\editable And Control
                Repaint = text_insert(*this, GetClipboardText())
              EndIf
              
          EndSelect 
          
      EndSelect
      
      If Repaint =- 1
        If \text\caret\pos < \text\caret\end
          ; Debug \text\caret\end-\text\caret\pos 
          _text_select_(*this, \text\caret\pos , \text\caret\end-\text\caret\pos )
        Else
          ; Debug \text\caret\pos -\text\caret\end
          _text_select_(*this, \text\caret\end, \text\caret\pos-\text\caret\end)
        EndIf
      EndIf                                                  
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i events_editor(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l)
    Static DoubleClick.i=-1
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *this
      Repaint | Scroll::CallBack(\scroll\v, EventType, \root\mouse\x, \root\mouse\y)
      Repaint | Scroll::CallBack(\scroll\h, EventType, \root\mouse\x, \root\mouse\y)
      
      If *this And (Not *this\scroll\v\from And Not *this\scroll\h\from)
        If ListSize(*this\items())
          If Not \hide And Not \Disable And \interact
            ; Get line position
            If \root\mouse\buttons
              If \root\mouse\y < \y
                Item.i =- 1
              Else
                Item.i = ((\root\mouse\y-\y-\text\y-\scroll\y) / \text\height)
              EndIf
            EndIf
            
            Select EventType 
              Case #PB_EventType_LeftDoubleClick 
                \items()\text\caret\end =- 1 ; Запоминаем что сделали двойной клик
                text_sellimits(*this)        ; Выделяем слово
                text_setsel(*this)
                
                ;                 \items()\text[2]\change = 1
                ;                 \items()\text[2]\len - Bool(Not \items()\text\len) ; Выделение пустой строки
                
                Repaint = 1
                
              Case #PB_EventType_LeftButtonDown
                ;itemSelect(Item, \items())
                ;Caret = text_caret(*this, Item)
                If Item > 0 And 
                   Item < \countitems - 1 And 
                   SelectElement(\items(), Item) And
                   StartDrawing(CanvasOutput(\root\canvas)) 
                  
                  If \text\fontID 
                    DrawingFont(\text\fontID) 
                    ;               ElseIf *this\text\fontID 
                    ;                 DrawingFont(*this\text\fontID) 
                  EndIf
                  
                  Caret = caret(*this)
                  
                  StopDrawing()
                EndIf
                
                
                If \items()\text\caret\end =- 1 : \items()\text\caret\end = 0
                  *this\text\caret\end = 0
                  *this\text\caret\pos = \items()\text\len
                  text_setsel(*this)
                  Repaint = 1
                  
                Else
                  text_selreset(*this)
                  
                  If \items()\text[2]\len
                    
                    
                    
                  Else
                    
                    \text\caret\pos = Caret
                    \text\caret\end = \text\caret\pos 
                    \index[1] = \items()\index 
                    \index[2] = \index[1]
                    
                    PushListPosition(\items())
                    ForEach \items() 
                      If \index[2] <> ListIndex(\items())
                        \items()\text[1]\string = ""
                        \items()\text[2]\string = ""
                        \items()\text[3]\string = ""
                      EndIf
                    Next
                    PopListPosition(\items())
                    
                    If \text\caret\pos = DoubleClick
                      DoubleClick =- 1
                      \text\caret\end = \items()\text\len
                      \text\caret\pos = 0
                    EndIf 
                    
                    text_setsel(*this)
                    Repaint = #True
                  EndIf
                EndIf
                
              Case #PB_EventType_MouseMove  
                If \root\mouse\buttons & #PB_Canvas_LeftButton 
                  Repaint = editor_setsel(*this, Item)
                EndIf
                
              Case #PB_EventType_LeftButtonUp  
                
                Debug 7777
                ; Выделение конца строки
                PushListPosition(\items()) 
                ForEach \items()
                  If \items()\text[2]\len
                    Debug \items()\text[2]\string
                  EndIf
                  ;         If Bool((_selected_index_ > \items()\index And _index_ < \items()\index) Or   ; верх
                  ;                   (_selected_index_ < \items()\index And _index_ > \items()\index))   ; вниз
                  ;             
                  ;           _text_select_(*this, 0, (\items()\text\len - Bool(Not \items()\text\len)))
                  ;           Repaint = #True
                  ;           
                  ;         ElseIf (\items()\text[2]\len And _selected_index_ <> \items()\index And _index_ <> \items()\index)
                  ;           
                  ;           _text_select_(*this, 0, 0)
                  ;           
                  ;         EndIf
                Next
                PopListPosition(\items()) 
                
              Default
                itemSelect(\index[2], \items())
            EndSelect
          EndIf
          
          ; edit events
          If *Focus = *this And (*this\text\editable Or \text\editable)
            Repaint | events_key_editor(*this, EventType, \root\mouse\x, \root\mouse\y)
          EndIf
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ < (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ < (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
  
  Procedure.i Text_Events(*Function, *this._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Static *Last._s_widget, *Widget._s_widget    ; *Focus._s_widget, 
    Static Text$, DoubleClick, LastX, LastY, Last, Drag
    Protected.i Result, Repaint, Control, Buttons, Widget
    
    ; widget_events_type
    If *this
      With *this
        If Canvas=-1 
          Widget = *this
          Canvas = EventGadget()
        Else
          Widget = Canvas
        EndIf
        ;         If Canvas <> \root\canvas
        ;           ProcedureReturn 
        ;         EndIf
        ;         Macro From(_this_, _buttons_=0)
        ;     Bool(_this_\root\mouse\x>=_this_\x[_buttons_] And _this_\root\mouse\x<_this_\x[_buttons_]+_this_\width[_buttons_] And 
        ;          _this_\root\mouse\y>=_this_\y[_buttons_] And _this_\root\mouse\y<_this_\y[_buttons_]+_this_\height[_buttons_])
        ;   EndMacro
        
        
        ; Get at point widget
        ;\root\mouse\from = From(*this)
        \root\mouse\from = _from_point_(\root\mouse\x, \root\mouse\y, *this)
        
        Select EventType 
          Case #PB_EventType_LeftButtonUp 
            If *Last = *this
              If *Widget <> *Focus
                ProcedureReturn 0 
              EndIf
            EndIf
            
          Case #PB_EventType_LeftClick 
            ; Debug ""+\root\mouse\buttons+" Last - "+*Last +" Widget - "+*Widget +" Focus - "+*Focus +" This - "+*this
            If *Last = *this : *Last = *Widget
              If *Widget <> *Focus
                ProcedureReturn 0 
              EndIf
            EndIf
            
            If Not *this\root\mouse\from 
              ProcedureReturn 0
            EndIf
        EndSelect
        
        If Not \hide And Not \Disable And \interact And Widget <> Canvas And CanvasModifiers 
          Select EventType 
            Case #PB_EventType_Focus : ProcedureReturn 0 ; Bug in mac os because it is sent after the mouse left down
            Case #PB_EventType_MouseMove, #PB_EventType_LeftButtonUp
              If Not \root\mouse\buttons 
                If \root\mouse\from
                  If *Last <> *this 
                    If *Last
                      If (*Last\index > *this\index)
                        ProcedureReturn 0
                      Else
                        ; Если с нижнего виджета перешли на верхный, 
                        ; то посылаем событие выход для нижнего
                        Text_Events(*Function, *Last, #PB_EventType_MouseLeave, Canvas, 0)
                        *Last = *this
                      EndIf
                    Else
                      *Last = *this
                    EndIf
                    
                    EventType = #PB_EventType_MouseEnter
                    *Widget = *Last
                  EndIf
                  
                ElseIf (*Last = *this)
                  If EventType = #PB_EventType_LeftButtonUp 
                    Text_Events(*Function, *Widget, #PB_EventType_LeftButtonUp, Canvas, 0)
                  EndIf
                  
                  EventType = #PB_EventType_MouseLeave
                  *Last = *Widget
                  *Widget = 0
                EndIf
              EndIf
              
            Case #PB_EventType_LostFocus
              If (*Focus = *this)
                *Last = *Focus
                Text_Events(*Function, *Focus, #PB_EventType_LostFocus, Canvas, 0)
                *Last = *Widget
              EndIf
              
            Case #PB_EventType_LeftButtonDown
              If (*Last = *this)
                PushListPosition(List())
                ForEach List()
                  If List()\widget\focus = List()\widget And List()\widget <> *this 
                    
                    List()\widget\focus = 0
                    *Last = List()\widget
                    Text_Events(*Function, List()\widget, #PB_EventType_LostFocus, List()\widget\root\canvas, 0)
                    *Last = *Widget 
                    
                    ; 
                    If Not List()\widget\repaint : List()\widget\repaint = 1
                      PostEvent(#PB_Event_Gadget, List()\widget\root\window, List()\widget\root\canvas, #PB_EventType_Repaint)
                    EndIf
                    Break 
                  EndIf
                Next
                PopListPosition(List())
                
                If *this <> \focus : \focus = *this : *Focus = *this
                  Text_Events(*Function, *this, #PB_EventType_Focus, Canvas, 0)
                EndIf
              EndIf
              
          EndSelect
        EndIf
        
        If (*Last = *this) 
          Select EventType
            Case #PB_EventType_LeftButtonDown
              If Not \root\mouse\Delta
                \root\mouse\Delta = AllocateStructure(_s_mouse)
                \root\mouse\Delta\x = \root\mouse\x
                \root\mouse\Delta\y = \root\mouse\y
                \root\mouse\delta\from = \root\mouse\from
                \root\mouse\Delta\buttons = \root\mouse\buttons
              EndIf
              
            Case #PB_EventType_LeftButtonUp : \Drag = 0
              FreeStructure(\root\mouse\Delta) : \root\mouse\Delta = 0
              ; ResetStructure(\root\mouse\Delta, _s_mouse)
              
            Case #PB_EventType_MouseMove
              If \Drag = 0 And \root\mouse\buttons And \root\mouse\Delta And 
                 (Abs((\root\mouse\x-\root\mouse\Delta\x)+(\root\mouse\y-\root\mouse\Delta\y)) >= 6) : \Drag=1
                ; PostEvent(#PB_Event_Widget, \root\window, \root\canvas, #PB_EventType_DragStart)
              EndIf
              
            Case #PB_EventType_MouseLeave
              If CanvasModifiers 
                ; Если перешли на другой виджет
                PushListPosition(List())
                ForEach List()
                  If List()\widget\root\canvas = Canvas And List()\widget\focus <> List()\widget And List()\widget <> *this
                    List()\widget\root\mouse\from = _from_point_(List()\widget\root\mouse\x, List()\widget\root\mouse\y, List()\widget)
                    
                    If List()\widget\root\mouse\from
                      If *Last
                        Text_Events(*Function, *Last, #PB_EventType_MouseLeave, Canvas, 0)
                      EndIf     
                      
                      *Last = List()\widget
                      *Widget = List()\widget
                      ProcedureReturn Text_Events(*Function, *Last, #PB_EventType_MouseEnter, Canvas, 0)
                    EndIf
                  EndIf
                Next
                PopListPosition(List())
              EndIf
              
              If \cursor[1] <> GetGadgetAttribute(\root\canvas, #PB_Canvas_Cursor)
                SetGadgetAttribute(\root\canvas, #PB_Canvas_Cursor, \cursor[1])
                \cursor[1] = 0
              EndIf
              
            Case #PB_EventType_MouseEnter    
              If Not \cursor[1] 
                \cursor[1] = GetGadgetAttribute(\root\canvas, #PB_Canvas_Cursor)
              EndIf
              SetGadgetAttribute(\root\canvas, #PB_Canvas_Cursor, \cursor)
              
            Case #PB_EventType_MouseMove ; bug mac os
              If \root\mouse\buttons And #PB_Compiler_OS = #PB_OS_MacOS ; And \cursor <> GetGadgetAttribute(\root\canvas, #PB_Canvas_Cursor)
                                                                        ; Debug 555
                SetGadgetAttribute(\root\canvas, #PB_Canvas_Cursor, \cursor)
              EndIf
              
          EndSelect
        EndIf 
        
      EndWith
    EndIf
    
    If (*Last = *this) Or (*Focus = *this And *this\text\editable); Or (*Last = *Focus)
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        Result | CallFunctionFast(*Function, *this, eventtype, *this\root\mouse\x, *this\root\mouse\y)
      CompilerElse
        Result | CallCFunctionFast(*Function, *this, eventtype, *this\root\mouse\x, *this\root\mouse\y)
      CompilerEndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Text_CallBack(*Function, *this._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
    If Canvas =- 1
      With *this
        Select EventType
          Case #PB_EventType_Repaint
            Debug " -- Canvas repaint -- "
          Case #PB_EventType_Input 
            \root\keyboard\input = GetGadgetAttribute(\root\canvas, #PB_Canvas_Input)
            \root\keyboard\key[1] = GetGadgetAttribute(\root\canvas, #PB_Canvas_Modifiers)
          Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
            \root\keyboard\key = GetGadgetAttribute(\root\canvas, #PB_Canvas_Key)
            \root\keyboard\key[1] = GetGadgetAttribute(\root\canvas, #PB_Canvas_Modifiers)
          Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
            \root\mouse\x = GetGadgetAttribute(\root\canvas, #PB_Canvas_MouseX)
            \root\mouse\y = GetGadgetAttribute(\root\canvas, #PB_Canvas_MouseY)
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
               #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
               #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
            
            CompilerIf #PB_Compiler_OS = #PB_OS_Linux
              \root\mouse\buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                    (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                    (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
            CompilerElse
              \root\mouse\buttons = GetGadgetAttribute(\root\canvas, #PB_Canvas_Buttons)
            CompilerEndIf
        EndSelect
      EndWith
    EndIf
    
    ; Это из за ошибки в мак ос и линукс
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS Or #PB_Compiler_OS = #PB_OS_Linux
      Select EventType 
        Case #PB_EventType_MouseEnter 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) Or MouseLeave =- 1
            EventType = #PB_EventType_MouseMove
            MouseLeave = 0
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons)
            EventType = #PB_EventType_MouseMove
            MouseLeave = 1
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If GetActiveGadget()<>EventGadget
            SetActiveGadget(EventGadget)
          EndIf
          
        Case #PB_EventType_LeftButtonUp
          If MouseLeave = 1 And Not Bool((MouseX>=0 And MouseX<Width) And (MouseY>=0 And MouseY<Height))
            MouseLeave = 0
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              Result | Text_Events(*Function, *this, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | Text_Events(*Function, *this, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    Result | Text_Events(*Function, *this, EventType, Canvas, CanvasModifiers)
    
    ProcedureReturn Result
  EndProcedure
  
  
  Procedure.i CallBack(*this._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text_CallBack(@events_editor(), *this, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure.i Editor(X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, round.i=0)
    Protected *this._s_widget = AllocateStructure(_s_widget)
    
    If *this
      With *this
        \type = #PB_GadgetType_Editor
        \cursor = #PB_Cursor_IBeam
        ;\DrawingMode = #PB_2DDrawing_Default
        \round = round
        \color\alpha = 255
        \interact = 1
        \text\caret\end =- 1
        \index[1] =- 1
        \x =- 1
        \y =- 1
        
        ; Set the Default widget flag
        If Bool(Flag&#__text_WordWrap)
          Flag&~#__text_MultiLine
        EndIf
        
        If Bool(Flag&#__text_MultiLine)
          Flag&~#__text_WordWrap
        EndIf
        
        If Not \text\fontID
          \text\fontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fs = Bool(Not Flag&#__flag_BorderLess)+1
        \bs = \fs
        
        \flag\buttons = Bool(flag&#__flag_NoButtons)
        \flag\lines = Bool(flag&#__flag_NoLines)
        \flag\fullSelection = Bool(Not flag&#__flag_FullSelection)*7
        \flag\alwaysSelection = Bool(flag&#__flag_AlwaysSelection)
        \flag\checkBoxes = Bool(flag&#__flag_CheckBoxes)*12 ; Это еще будет размер чек бокса
        \flag\gridLines = Bool(flag&#__flag_GridLines)
        
        \vertical = Bool(Flag&#__flag_Vertical)
        \text\editable = Bool(Not Flag&#__text_ReadOnly)
        
        If Bool(Flag&#__text_WordWrap)
          \text\multiLine = 1
        ElseIf Bool(Flag&#__text_MultiLine)
          \text\multiLine = 2
        Else
          \text\multiLine =- 1
        EndIf
        
        \flag\multiSelect = 1
        ;\text\Numeric = Bool(Flag&#__text_Numeric)
        \text\lower = Bool(Flag&#__text_LowerCase)
        \text\Upper = Bool(Flag&#__text_UpperCase)
        \text\pass = Bool(Flag&#__text_Password)
        
        \text\align\horizontal = Bool(Flag&#__text_Center)
        \text\align\Vertical = Bool(Flag&#__text_Middle)
        \text\align\right = Bool(Flag&#__text_Right)
        \text\align\bottom = Bool(Flag&#__text_Bottom)
        
        If \vertical
          \text\x = \fs 
          \text\y = \fs+2
        Else
          \text\x = \fs+2
          \text\y = \fs
        EndIf
        
        
        \color = Colors
        \color\fore[0] = 0
        
        \sci\margin\width = Bool(Flag&#__flag_Numeric)
        \sci\margin\color\back = $C8F0F0F0 ; \color\back[0] 
        
        \row\color\alpha = 255
        \row\color = Colors
        \row\color\fore[0] = 0
        \row\color\fore[1] = 0
        \row\color\fore[2] = 0
        \row\color\back[0] = \row\color\back[1]
        \row\color\frame[0] = \row\color\frame[1]
        ;\color\back[1] = \color\back[0]
        
        
        
        If \text\editable
          \color\back[0] = $FFFFFFFF 
        Else
          \color\back[0] = $FFF0F0F0  
        EndIf
        
      EndIf
      
      ; create scrollbars
      Scroll::Bars(\scroll, 16, 7, Bool(\text\multiLine <> 1))
      
      Resize(*this, X,Y,Width,Height)
      ;       \text\string = #LF$
      ;       \text\change = 1  
      If Text
        SetText(*this, Text.s)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s="", Flag.i=0, round.i=0)
    Protected *Widget, *this._s_widget = AllocateStructure(_s_widget)
    
    If *this
      add_widget(Widget, *Widget)
      
      
      *this = Editor(x, y, Width, Height, Text.s, Flag, round)
      *this\index = Widget
      *this\handle = *Widget
      List()\widget = *this
      
      *this\root = AllocateStructure(_s_root)
      *this\root\canvas = Canvas
      If Not *this\root\window
        *this\root\window = GetActiveWindow() ; GetGadgetData(Canvas)
      EndIf
      
      ;If Not *this\repaint : *this\repaint = 1
      PostEvent(#PB_Event_Gadget, *this\root\window, *this\root\canvas, #PB_EventType_Repaint, *this)
      ;EndIf
      ;       PostEvent(#PB_Event_Widget, *this\root\window, *this, #PB_EventType_Create)
      ;       BindEvent(#PB_Event_Widget, @Widget_CallBack(), *this\root\window, *this, #PB_EventType_Create)
      ;       SetGadgetData(Canvas, *this)
      ;       BindGadgetEvent(Canvas, @Canvas_CallBack())
    EndIf
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure Canvas_CallBack()
    Protected Repaint, *this._s_widget = GetGadgetData(EventGadget())
    
    With *this
      Select EventType()
        Case #PB_EventType_Repaint 
          If *this\repaint : *this\repaint = 0
            Repaint = 1
          EndIf
          
        Case #PB_EventType_Resize : ResizeGadget(\root\canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint | Resize(*this, #PB_Ignore, #PB_Ignore, GadgetWidth(\root\canvas), GadgetHeight(\root\canvas))
      EndSelect
      
      Repaint | CallBack(*this, EventType())
      
      If Repaint 
        ReDraw(*this)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
    Protected *this._s_widget = AllocateStructure(_s_widget)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *this
      With *this
        *this = Editor(0, 0, Width, Height, "", Flag)
        *this\root = AllocateStructure(_s_root)
        *this\root\canvas = Gadget
        If Not *this\root\window
          *this\root\window = GetActiveWindow() ; GetGadgetData(Canvas)
        EndIf
        ;         PostEvent(#PB_Event_Widget, *this\root\window, *this, #PB_EventType_Create)
        ;         BindEvent(#PB_Event_Widget, @Widget_CallBack(), *this\root\window, *this, #PB_EventType_Create)
        
        SetGadgetData(Gadget, *this)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
  
EndModule



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  
  Define a,i, *g._s_widget
  Define g, Text.s
  ; Define m.s=#CRLF$
  Define m.s=#LF$
  
  Text.s = "This is a long line" + m.s +
           "Who should show," + m.s +
           "I have to write the text in the box or not." + m.s +
           "The string must be very long" + m.s +
           "Otherwise it will not work."
  
  Procedure ResizeCallBack()
    ResizeGadget(100, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-62, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-30, #PB_Ignore, #PB_Ignore)
    ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    CompilerIf #PB_Compiler_Version =< 546
      PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
    CompilerEndIf
  EndProcedure
  
  Procedure SplitterCallBack()
    PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 16)
  CompilerElse
    LoadFont(0, "Arial", 11)
  CompilerEndIf 
  
  
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
  
  If OpenWindow(0, 0, 0, 422, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ButtonGadget(100, 490-60,490-30,67,25,"~wrap")
    
    EditorGadget(0, 8, 8, 306, 133, #PB_Editor_WordWrap) 
    SetGadgetText(0, Text.s) 
    For a = 0 To 2
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    AddGadgetItem(0, 7+a, "_")
    For a = 4 To 6
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    ;SetGadgetFont(0, FontID(0))
    
    
    g=16
    Editor::Gadget(g, 8, 133+5+8, 306, 133, #__flag_GridLines|#__flag_Numeric|#__text_WordWrap) 
    *g._s_widget=GetGadgetData(g)
    
    Editor::SetText(*g, Text.s) 
    ;Text::Redraw(*w)
    
    For a = 0 To 2
      Editor::AddItem(*g, a, "Line "+Str(a))
    Next
    Editor::AddItem(*g, 7+a, "_")
    For a = 4 To 6
      Editor::AddItem(*g, a, "Line "+Str(a))
    Next
    ;Editor::SetFont(*g, FontID(0))
    
    SplitterGadget(10,8, 8, 306, 491-16, 0,g)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    Debug ""+GadgetHeight(0) +" "+ GadgetHeight(g)
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_Gadget
          If EventGadget() = 100
            Select EventType()
              Case #PB_EventType_LeftClick
                Define *E._s_widget = GetGadgetData(g)
                
                ClearDebugOutput()
                If *E\text[1]\string
                  Debug "1) -"+*E\text[1]\string
                  Debug "<<<<<<<<<<<"
                EndIf
                If *E\text[2]\string
                  Debug "2) -"+*E\text[2]\string
                EndIf
                If *E\text[3]\string
                  Debug ">>>>>>>>>>>"
                  Debug "3) -"+*E\text[3]\string
                EndIf
                
                ; ; ;                 *E\text\multiLine !- 1
                ; ; ;                 If  *E\text\multiLine = 1
                ; ; ;                   SetGadgetText(100,"~wrap")
                ; ; ;                 Else
                ; ; ;                   SetGadgetText(100,"wrap")
                ; ; ;                 EndIf
                ; ; ;                 
                ; ; ;                 CompilerSelect #PB_Compiler_OS
                ; ; ;                   CompilerCase #PB_OS_Linux
                ; ; ;                     If  *E\text\multiLine = 1
                ; ; ;                       gtk_text_view_set_wrap_mode_(GadgetID(0), #GTK_WRAP_WORD)
                ; ; ;                     Else
                ; ; ;                       gtk_text_view_set_wrap_mode_(GadgetID(0), #GTK_WRAP_NONE)
                ; ; ;                     EndIf
                ; ; ;                     
                ; ; ;                   CompilerCase #PB_OS_MacOS
                ; ; ;                     
                ; ; ;                     If  *E\text\multiLine = 1
                ; ; ;                       EditorGadget(0, 8, 8, 306, 133, #PB_Editor_WordWrap)
                ; ; ;                     Else
                ; ; ;                       EditorGadget(0, 8, 8, 306, 133) 
                ; ; ;                     EndIf
                ; ; ;                     
                ; ; ;                     SetGadgetText(0, Text.s) 
                ; ; ;                     For a = 0 To 5
                ; ; ;                       AddGadgetItem(0, a, "Line "+Str(a))
                ; ; ;                     Next
                ; ; ;                     SetGadgetFont(0, FontID(0))
                ; ; ;                     
                ; ; ;                     SplitterGadget(10,8, 8, 306, 276, 0,g)
                ; ; ;                     
                ; ; ;                     CompilerIf #PB_Compiler_Version =< 546
                ; ; ;                       BindGadgetEvent(10, @SplitterCallBack())
                ; ; ;                     CompilerEndIf
                ; ; ;                     PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
                ; ; ;                     BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
                ; ; ;                     
                ; ; ;                     ; ;                     ImportC ""
                ; ; ;                     ; ;                       GetControlProperty(Control, PropertyCreator, PropertyTag, BufferSize, *ActualSize, *PropertyBuffer)
                ; ; ;                     ; ;                       TXNSetTXNObjectControls(TXNObject, ClearAll, ControlCount, ControlTags, ControlData)
                ; ; ;                     ; ;                     EndImport
                ; ; ;                     ; ;                     
                ; ; ;                     ; ;                     Define TXNObject.i
                ; ; ;                     ; ;                     Dim ControlTag.i(0)
                ; ; ;                     ; ;                     Dim ControlData.i(0)
                ; ; ;                     ; ;                     
                ; ; ;                     ; ;                     ControlTag(0) = 'wwrs' ; kTXNWordWrapStateTag
                ; ; ;                     ; ;                     ControlData(0) = 0     ; kTXNAutoWrap
                ; ; ;                     ; ;                     
                ; ; ;                     ; ;                     If GetControlProperty(GadgetID(0), 'PURE', 'TXOB', 4, 0, @TXNObject) = 0
                ; ; ;                     ; ;                       TXNSetTXNObjectControls(TXNObject, #False, 1, @ControlTag(0), @ControlData(0))
                ; ; ;                     ; ;                     EndIf
                ; ; ;                   CompilerCase #PB_OS_Windows
                ; ; ;                     SendMessage_(GadgetID(0), #EM_SETTARGETDEVICE, 0, 0)
                ; ; ;                 CompilerEndSelect
                
                
            EndSelect
          EndIf
          
        Case #PB_Event_LeftClick  
          SetActiveGadget(0)
        Case #PB_Event_RightClick 
          SetActiveGadget(10)
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ---------------------------------------------v8------------------------------------4--------------------
; EnableXP