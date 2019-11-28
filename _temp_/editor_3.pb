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

DeclareModule Macros
  Macro StartDrawingCanvas(_canvas_)
    Bool(IsGadget(_canvas_) And StartDrawing(CanvasOutput(_canvas_)))
  EndMacro
  
  Macro StopDrawingCanvas()
    Bool(ListSize(List()) And IsGadget(List()\Widget\Canvas\Gadget) And Not StopDrawing())
  EndMacro
  
  Macro From(_this_, _buttons_=0)
    Bool(_this_\Canvas\Mouse\X>=_this_\x[_buttons_] And _this_\Canvas\Mouse\X<_this_\x[_buttons_]+_this_\Width[_buttons_] And 
         _this_\Canvas\Mouse\Y>=_this_\y[_buttons_] And _this_\Canvas\Mouse\Y<_this_\y[_buttons_]+_this_\Height[_buttons_])
  EndMacro
  
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
        List()\Widget\Index = ListIndex(List())
      Wend
      PopListPosition(List())
    EndIf
  EndMacro
  
  Macro _clip_output_(_this_, _x_,_y_,_width_,_height_)
    If _x_<>#PB_Ignore : _this_\Clip\X = _x_ : EndIf
    If _y_<>#PB_Ignore : _this_\Clip\Y = _y_ : EndIf
    If _width_<>#PB_Ignore : _this_\Clip\Width = _width_ : EndIf
    If _height_<>#PB_Ignore : _this_\Clip\Height = _height_ : EndIf
    
    CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
     ; ClipOutput(_this_\Clip\X,_this_\Clip\Y,_this_\Clip\Width,_this_\Clip\Height)
    CompilerEndIf
  EndMacro
  
  Macro _frame_(_this_, _x_,_y_,_width_,_height_, _color_1_, _color_2_);, _radius_=0)
    ClipOutput(_x_-1,_y_-1,_width_+1,_height_+1)
    RoundBox(_x_-1,_y_-1,_width_+2,_height_+2, _this_\Radius,_this_\Radius, _color_1_)  
    
    ClipOutput(_x_+_this_\Radius/3,_y_+_this_\Radius/3,_width_+2,_height_+2)
    RoundBox(_x_-1,_y_-1,_width_+2,_height_+2,_this_\Radius,_this_\Radius, _color_2_)  
    
;     If _radius_ And _this_\Radius : RoundBox(_x_,_y_-1,_width_,_height_+1,_this_\Radius,_this_\Radius,_color_1_) : EndIf  ; Сглаживание краев )))
;     If _radius_ And _this_\Radius : RoundBox(_x_-1,_y_-1,_width_+1,_height_+1,_this_\Radius,_this_\Radius,_color_1_) : EndIf  ; Сглаживание краев )))
    
    UnclipOutput() : _clip_output_(_this_, _this_\X[1]-1,_this_\Y[1]-1,_this_\Width[1]+2,_this_\Height[1]+2)
  EndMacro
  
  Macro BoxGradient(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _radius_=0, _alpha_=255)
    BackColor(_color_1_&$FFFFFF|_alpha_<<24)
    FrontColor(_color_2_&$FFFFFF|_alpha_<<24)
    If _type_
      LinearGradient(_x_,_y_, (_x_+_width_), _y_)
    Else
      LinearGradient(_x_,_y_, _x_, (_y_+_height_))
    EndIf
    RoundBox(_x_,_y_,_width_,_height_, _radius_,_radius_)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
  EndMacro
  
  Macro _colors_(_adress_, _i_, _ii_, _iii_)
    ; Debug ""+_i_+" "+ _ii_+" "+ _iii_
    
    If _adress_\Color[_i_]\Line[_ii_]
      _adress_\Color[_i_]\Line[_iii_] = _adress_\Color[_i_]\Line[_ii_]
    Else
      _adress_\Color[_i_]\Line[_iii_] = _adress_\Color[0]\Line[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Fore[_ii_]
      _adress_\Color[_i_]\Fore[_iii_] = _adress_\Color[_i_]\Fore[_ii_]
    Else
      _adress_\Color[_i_]\Fore[_iii_] = _adress_\Color[0]\Fore[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Back[_ii_]
      _adress_\Color[_i_]\Back[_iii_] = _adress_\Color[_i_]\Back[_ii_]
    Else
      _adress_\Color[_i_]\Back[_iii_] = _adress_\Color[0]\Back[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Front[_ii_]
      _adress_\Color[_i_]\Front[_iii_] = _adress_\Color[_i_]\Front[_ii_]
    Else
      _adress_\Color[_i_]\Front[_iii_] = _adress_\Color[0]\Front[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Frame[_ii_]
      _adress_\Color[_i_]\Frame[_iii_] = _adress_\Color[_i_]\Frame[_ii_]
    Else
      _adress_\Color[_i_]\Frame[_iii_] = _adress_\Color[0]\Frame[_ii_]
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
  
  Macro Distance(_mouse_x_, _mouse_y_, _position_x_, _position_y_, _radius_)
    Bool(Sqr(Pow(((_position_x_+_radius_) - _mouse_x_),2) + Pow(((_position_y_+_radius_) - _mouse_y_),2)) =< _radius_)
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
    If Not _this_\hide And Not _this_\Items()\Hide
     _this_\Scroll\Height+_this_\Text\Height
     ; _this_\scroll\v\max = _this_\scroll\Height
    EndIf
  EndMacro
  
  Macro _set_scroll_width_(_this_)
    If Not _this_\items()\hide And
       _this_\Scroll\width<(_this_\items()\text\x+_this_\items()\text\width)-_this_\x
      _this_\scroll\width=(_this_\items()\text\x+_this_\items()\text\width)-_this_\x
      _this_\Text\Big = _this_\Items()\Index ; Позиция в тексте самой длинной строки
      _this_\Text\Big[1] = _this_\Items()\Text\Pos ; Может и не понадобятся
      _this_\Text\Big[2] = _this_\Items()\Text\Len ; Может и не понадобятся
      
          
     ; _this_\scroll\h\max = _this_\scroll\width
      ; Debug "   "+_this_\width +" "+ _this_\scroll\width
    EndIf
  EndMacro
  
;   Macro _set_line_pos_(_this_)
;     _this_\Items()\Text\Pos = _this_\Text\Pos
;     _this_\Items()\Text\Len = Len(_this_\Items()\Text\String.s)
;     _this_\Text\Pos + _this_\Items()\Text\Len + 1 ; Len(#LF$)
;   EndMacro
  
  Macro RowBackColor(_this_, _state_)
    _this_\Row\Color\Back[_state_]&$FFFFFFFF|_this_\row\color\alpha<<24
  EndMacro
  Macro RowForeColor(_this_, _state_)
    _this_\Row\Color\Fore[_state_]&$FFFFFFFF|_this_\row\color\alpha<<24
  EndMacro
  Macro RowFrameColor(_this_, _state_)
    _this_\Row\Color\Frame[_state_]&$FFFFFFFF|_this_\row\color\alpha<<24
  EndMacro
  Macro RowFontColor(_this_, _state_)
    _this_\Color\Front[_state_]&$FFFFFFFF|_this_\row\color\alpha<<24
  EndMacro
  
  Macro _set_open_box_XY_(_this_, _items_, _x_, _y_)
    If (_this_\flag\buttons Or _this_\Flag\Lines) 
      _items_\box\width = _this_\flag\buttons
      _items_\box\height = _this_\flag\buttons
      _items_\box\x = _x_+_items_\sublevellen-(_items_\box\width)/2
      _items_\box\y = (_y_+_items_\height)-(_items_\height+_items_\box\height)/2
    EndIf
  EndMacro
  
  Macro _set_check_box_XY_(_this_, _items_, _x_, _y_)
    If _this_\Flag\CheckBoxes
      _items_\box\width[1] = _this_\Flag\CheckBoxes
      _items_\box\height[1] = _this_\Flag\CheckBoxes
      _items_\box\x[1] = _x_+(_items_\box\width[1])/2
      _items_\box\y[1] = (_y_+_items_\height)-(_items_\height+_items_\box\height[1])/2
    EndIf
  EndMacro
  
  Macro _draw_plots_(_this_, _items_, _x_, _y_)
    ; Draw plot
    If _this_\sublevellen And _this_\Flag\Lines 
      Protected line_size = _this_\Flag\Lines
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
            ;If \Hide : Drawing = 2 : EndIf
            PopListPosition(_items_)
          EndIf
          
          PushListPosition(_items_)
          ChangeCurrentElement(_items_, _items_\handle) 
          If Drawing  
            If start
              If _this_\sublevellen > 10
                start = (_items_\y+_items_\height+_items_\height/2) + _this_\Scroll\Y - line_size
              Else
                start = (_items_\y+_items_\height/2) + _this_\Scroll\Y
              EndIf
            Else 
              start = (_this_\y[2]+_items_\height/2)+_this_\Scroll\Y
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
    ;         #__flag_Single
    
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
    #__bar_ScrollStep
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
  ;- - Point_S
  Structure Point_S
    y.i
    x.i
  EndStructure
  
  ;- - Coordinate_S
  Structure Coordinate_S
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
  EndStructure
  
  ;- - Mouse_S
  Structure Mouse_S
    X.i
    Y.i
    at.i ; at point widget
    Wheel.i ; delta
    Buttons.i ; state
    *Delta.Mouse_S
  EndStructure
  
  ;- - Align_S
  Structure Align_S
    Right.b
    Bottom.b
    Vertical.b
    Horizontal.b
  EndStructure
  
  ;- - Page_S
  Structure Page_S
    Pos.i
    len.i
    ScrollStep.i
  EndStructure
  
  ;- - Color_S
  Structure Color_S
    State.b
    Front.i[4]
    Fore.i[4]
    Back.i[4]
    Line.i[4]
    Frame.i[4]
    Alpha.a[2]
  EndStructure
  
  ;- - Flag_S
  Structure Flag_S
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
  
  ;- - Image_S
  Structure Image_S Extends Coordinate_S
    handle.i[2]
    change.b
    Align.Align_S
  EndStructure
  
  ;- - Text_S
  Structure Text_S Extends Coordinate_S
    Big.i[3]
    ;     Char.c
    Pos.i
    Len.i
    Caret.i[3] ; 0 = Pos ; 1 = PosFixed
    
    FontID.i
    String.s[3]
    Count.i[2]
    Change.b
    
    Lower.b
    Upper.b
    Pass.b
    Editable.b
    Numeric.b
    MultiLine.b
    Vertical.b
    Rotate.f
    
    Align.Align_S
  EndStructure
    
  ;- - Bar_S
  Structure Bar_S Extends Coordinate_S
    *s.Scroll_S
    Type.i
    Widget.i
    Radius.i
    ArrowSize.b[3]
    ArrowType.b[3]
    
    at.i
    
    Hide.b[2]
    Disable.b[2]
    
    Max.i
    Min.i
    Vertical.b
    Page.Page_S
    Area.Page_S
    Thumb.Page_S
    Button.Page_S
    Color.Color_S[4]
  EndStructure
  
  ;- - Event_S
  Structure Post_S
    Gadget.i
    Window.i
    Widget.i
    Type.i
    Event.i
    *Function
  EndStructure
  
  ;- - Scroll_S
  Structure Scroll_S Extends Coordinate_S
    Post.Post_S
    
    *v.Bar_S
    *h.Bar_S
  EndStructure
  
  ;- - Canvas_S
  Structure Canvas_S
    Mouse.Mouse_S
    Gadget.i[3]
    Window.i
    Widget.i
    
    Input.c
    Key.i[2]
  EndStructure
  
  ;- - Scintilla_S
  Structure Margin_S
    FonyID.i
    Width.i
    Color.Color_S
  EndStructure
  
  ;- - Scintilla_S
  Structure Scintilla_S
    Margin.Margin_S
  EndStructure
  
  ;- - Row_S
  Structure Row_S Extends Coordinate_S
    Color.Color_S
  EndStructure
  
  ;- - Color_S
  Structure Colors_S
    State.b
;     Front.i[4]
;     Fore.i[4]
;     Back.i[4]
;     Line.i[4]
;     Frame.i[4]
;      Alpha.a[2]
  EndStructure
  
  ;- - Rows_S
  Structure Rows_S Extends Coordinate_S
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    handle.i[2]
    
    Color.Colors_S
    Text.Text_S[4]
    Image.Image_S
    box.Coordinate_S
    
    Hide.b[2]
    Caret.i[3] ; 0 = Pos ; 1 = PosFixed
    
    Focus.i
    LostFocus.i
    
    Checked.b[2]
    Vertical.b
    Radius.i
    
    change.b
    sublevel.i
    ;sublevelpos.i
    sublevellen.i
    
    collapsed.b
    childrens.i
    *data  ; set/get item data
  EndStructure
  
  ;- - _s_widget
  Structure _s_widget Extends Coordinate_S
    Type.i
    handle.i    ; Adress of new list element
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
   ;;; line.i[3]   ; 
    
    Sci.Scintilla_S
    *Widget._s_widget
    Canvas.Canvas_S
    Color.Color_S
    Text.Text_S[4]
    Clip.Coordinate_S
    *tooltip.Text_S
    scroll.Scroll_S
    image.Image_S
    flag.Flag_S
    
    bSize.b
    fSize.b[2]
    Hide.b[2]
    Disable.b[2]
    Interact.b ; будет ли взаимодействовать с пользователем?
    Cursor.i[2]
    
    
    Focus.i
    LostFocus.i
    
    Drag.b[2]
    Resize.b ; 
    Toggle.b ; 
    Buttons.i
    
    *data
    change.b
    radius.i
    vertical.b
    checked.b[2]
    sublevellen.i
    
    attribute.i
    
    *Default
    row.Row_S
    List Items.Rows_S()
    List Lines.Rows_S()
    List Columns._s_widget()
    Repaint.i ; Будем посылать сообщение что надо перерисовать а после надо сбрасывать переменую
  EndStructure
  
  ;-
  ;- Colors
  ; $FF24B002 ; $FFD5A719 ; $FFE89C3D ; $FFDE9541 ; $FFFADBB3 ;
  Global Colors.Color_S
  With Colors                          
    \State = 0
    
    ;- Серые цвета 
    ;     ; Цвета по умолчанию
    ;     \Front[0] = $FF000000
    ;     \Fore[0] = $FFFCFCFC ; $FFF6F6F6 
    ;     \Back[0] = $FFE2E2E2 ; $FFE8E8E8 ; 
    ;     \Line[0] = $FFA3A3A3
    ;     \Frame[0] = $FFA5A5A5 ; $FFBABABA
    ;     
    ;     ; Цвета если мышь на виджете
    ;     \Front[1] = $FF000000
    ;     \Fore[1] = $FFF5F5F5 ; $FFF5F5F5 ; $FFEAEAEA
    ;     \Back[1] = $FFCECECE ; $FFEAEAEA ; 
    ;     \Line[1] = $FF5B5B5B
    ;     \Frame[1] = $FF8F8F8F
    ;     
    ;     ; Цвета если нажали на виджет
    ;     \Front[2] = $FFFFFFFF
    ;     \Fore[2] = $FFE2E2E2
    ;     \Back[2] = $FFB4B4B4
    ;     \Line[2] = $FFFFFFFF
    ;     \Frame[2] = $FF6F6F6F
    
    ;- Зеленые цвета
    ;             ; Цвета по умолчанию
    ;             \Front[0] = $FF000000
    ;             \Fore[0] = $FFFFFFFF
    ;             \Back[0] = $FFDAFCE1  
    ;             \Frame[0] = $FF6AFF70 
    ;             
    ;             ; Цвета если мышь на виджете
    ;             \Front[1] = $FF000000
    ;             \Fore[1] = $FFE7FFEC
    ;             \Back[1] = $FFBCFFC5
    ;             \Frame[1] = $FF46E064 ; $FF51AB50
    ;             
    ;             ; Цвета если нажали на виджет
    ;             \Front[2] = $FFFEFEFE
    ;             \Fore[2] = $FFC3FDB7
    ;             \Back[2] = $FF00B002
    ;             \Frame[2] = $FF23BE03
    
    ;- Синие цвета
    ; Цвета по умолчанию
    \Front[0] = $80000000
    \Fore[0] = $FFF8F8F8 
    \Back[0] = $80E2E2E2
    \Frame[0] = $80C8C8C8
    
    ; Цвета если мышь на виджете
    \Front[1] = $80000000
    \Fore[1] = $FFFAF8F8
    \Back[1] = $80FCEADA
    \Frame[1] = $80FFC288
    
    ; Цвета если нажали на виджет
    \Front[2] = $FFFEFEFE
    \Fore[2] = $FFE9BA81;$C8FFFCFA
    \Back[2] = $FFE89C3D ; $80E89C3D
    \Frame[2] = $FFDC9338; $80DC9338
    
    ;         ;- Синие цвета 2
    ;         ; Цвета по умолчанию
    ;         \Front[0] = $FF000000
    ;         \Fore[0] = $FFF8F8F8 ; $FFF0F0F0 
    ;         \Back[0] = $FFE5E5E5
    ;         \Frame[0] = $FFACACAC 
    ;         
    ;         ; Цвета если мышь на виджете
    ;         \Front[1] = $FF000000
    ;         \Fore[1] = $FFFAF8F8 ; $FFFCF4EA
    ;         \Back[1] = $FFFAE8DB ; $FFFCECDC
    ;         \Frame[1] = $FFFC9F00
    ;         
;             ; Цвета если нажали на виджет
;             \Front[2] = $FF000000;$FFFFFFFF
;             \Fore[2] = $FFFDF7EF
;             \Back[2] = $FFFBD9B7
;             \Frame[2] = $FFE59B55
    
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
  ; ;   ;- - Coordinate_S
  ; ;   Structure Coordinate_S
  ; ;     y.i[4]
  ; ;     x.i[4]
  ; ;     height.i[4]
  ; ;     width.i[4]
  ; ;   EndStructure
  ; ;   
  ; ;   ;- - Color_S
  ; ;   Structure Color_S
  ; ;     State.b ; entered; selected; focused; lostfocused
  ; ;     Front.i[4]
  ; ;     Line.i[4]
  ; ;     Fore.i[4]
  ; ;     Back.i[4]
  ; ;     Frame.i[4]
  ; ;     Alpha.a[2]
  ; ;   EndStructure
  ; ;   
  ; ;   ;- - Page_S
  ; ;   Structure Page_S
  ; ;     Pos.i
  ; ;     len.i
  ; ;     ScrollStep.i
  ; ;   EndStructure
  ; ;   
  ; ;   ;- - Bar_S
  ; ;   Structure Bar_S Extends Coordinate_S
  ; ;     *s.Scroll_S
  ; ;     Type.i
  ; ;     Widget.i
  ; ;     Radius.i
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
  ; ;     Page.Page_S
  ; ;     Area.Page_S
  ; ;     Thumb.Page_S
  ; ;     Button.Page_S
  ; ;     Color.Color_S[4]
  ; ;   EndStructure
  ; ;   
  ; ;   ;- - Mouse_S
  ; ;   Structure Mouse_S
  ; ;     X.i
  ; ;     Y.i
  ; ;     at.i ; at point widget
  ; ;     Wheel.i ; delta
  ; ;     Buttons.i ; state
  ; ;   ;  *Delta.Mouse_S
  ; ;   EndStructure
  ; ;   
  ; ;   ;- - Event_S
  ; ;   Structure Post_S
  ; ;     Gadget.i
  ; ;     Window.i
  ; ;     Type.i
  ; ;     Event.i
  ; ;     *Function
  ; ;   EndStructure
  ; ;   
  ; ;   ;- - Scroll_S
  ; ;   Structure Scroll_S Extends Coordinate_S
  ; ;     *Mouse.Mouse_S
  ; ;     Post.Post_S
  ; ;     
  ; ;     *v.Bar_S
  ; ;     *h.Bar_S
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
  ; ;   Macro BoxGradient(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _radius_=0, _alpha_=255)
  ; ;     BackColor(_color_1_&$FFFFFF|_alpha_<<24)
  ; ;     FrontColor(_color_2_&$FFFFFF|_alpha_<<24)
  ; ;     If _type_
  ; ;       LinearGradient(_x_,_y_, (_x_+_width_), _y_)
  ; ;     Else
  ; ;       LinearGradient(_x_,_y_, _x_, (_y_+_height_))
  ; ;     EndIf
  ; ;     RoundBox(_x_,_y_,_width_,_height_, _radius_,_radius_)
  ; ;     BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
  ; ;   EndMacro
  
  Macro is(_scroll_) : Bool(((_scroll_\v And _scroll_\v\at) Or (_scroll_\h And _scroll_\h\at))) : EndMacro
  ;Macro is(_scroll_) : Bool((((_scroll_\v And Not _scroll_\v\at) Or Not _scroll_\v) And ((_scroll_\h And Not _scroll_\h\at) Or Not _scroll_\h))) : EndMacro
  ;Macro is(_scroll_) : Bool( Bool((_scroll_\v And Not _scroll_\v\at) And (_scroll_\h And Not _scroll_\h\at)) Or Not Bool(_scroll_\v And _scroll_\h)) : EndMacro
;   Macro x(_this_) : _this_\X+Bool(_this_\hide[1] Or Not _this_\color\alpha)*_this_\Width : EndMacro
;   Macro y(_this_) : _this_\Y+Bool(_this_\hide[1] Or Not _this_\color\alpha)*_this_\Height : EndMacro
  Macro width(_this_) : Bool(Not _this_\hide[1] And _this_\color\alpha)*_this_\Width : EndMacro
  Macro height(_this_) : Bool(Not _this_\hide[1] And _this_\color\alpha)*_this_\Height : EndMacro
  
  ;- - DECLAREs
  Declare.i Draw(*This.Bar_S)
  Declare.i Y(*This.Bar_S)
  Declare.i X(*This.Bar_S)
;   Declare.i Width(*This.Bar_S)
;   Declare.i Height(*This.Bar_S)
  Declare.b SetState(*This.Bar_S, ScrollPos.i)
  Declare.i SetAttribute(*This.Bar_S, Attribute.i, Value.i)
  Declare.b CallBack(*This.Bar_S, EventType.i, mouseX=0, mouseY=0)
  Declare.i Draws(*Scroll.Scroll_S, ScrollHeight.i, ScrollWidth.i)
  Declare.i SetColor(*This.Bar_S, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.b Resize(*This.Bar_S, iX.i,iY.i,iWidth.i,iHeight.i, *That.Bar_S=#Null)
  Declare.i Bar(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
  
  Declare.b Resizes(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i)
  Declare.b Updates(*Scroll.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  ;Declare.i Widget(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
  Declare.i Bars(*Scroll.Scroll_S, Size.i, Radius.i, Both.b)
  Declare Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
EndDeclareModule

Module Scroll
  Global Colors.Color_S
  
  With Colors                          
    \State = 0
    ;- Синие цвета
    ; Цвета по умолчанию
    \Front[0] = $80000000
    \Fore[0] = $FFF8F8F8 
    \Back[0] = $80E2E2E2
    \Frame[0] = $80C8C8C8
    
    ; Цвета если мышь на виджете
    \Front[1] = $80000000
    \Fore[1] = $FFFAF8F8
    \Back[1] = $80FCEADA
    \Frame[1] = $80FFC288
    
    ; Цвета если нажали на виджет
    \Front[2] = $FFFEFEFE
    \Fore[2] = $C8E9BA81;$C8FFFCFA
    \Back[2] = $C8E89C3D; $80E89C3D
    \Frame[2] = $C8DC9338; $80DC9338
  EndWith
  
  Macro ThumbLength(_this_)
    Round(_this_\Area\len - (_this_\Area\len / (_this_\Max-_this_\Min))*((_this_\Max-_this_\Min) - _this_\Page\len), #PB_Round_Nearest)
  EndMacro
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\Area\Pos + Round((_scroll_pos_-_this_\Min) * (_this_\Area\len / (_this_\Max-_this_\Min)), #PB_Round_Nearest)) : If _this_\Vertical : _this_\Y[3] = _this_\Thumb\Pos : _this_\Height[3] = _this_\Thumb\len : Else : _this_\X[3] = _this_\Thumb\Pos : _this_\Width[3] = _this_\Thumb\len : EndIf
  EndMacro
  Macro ScrollEnd(_this_)
    Bool(_this_\Page\Pos = ((_this_\Max-_this_\Min)-_this_\Page\len))
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
  
  Procedure.i Pos(*This.Bar_S, ThumbPos.i)
    Protected ScrollPos.i
    
    With *This
      ScrollPos = Match( \Min + Round((ThumbPos - \Area\Pos) / ( \Area\len / ( \Max-\Min)), #PB_Round_Nearest), \Page\ScrollStep) 
      If ( \Vertical And \Type = #PB_GadgetType_TrackBar) : ScrollPos = (( \Max-\Min)-ScrollPos) : EndIf
    EndWith
    
    ProcedureReturn ScrollPos
  EndProcedure
  
  ;-
  Procedure.i X(*This.Bar_S)
    Protected Result.l
    
    If *This
      With *This
        If Not \Hide[1] And \color\Alpha
          Result = \X
        Else
          Result = \X+\Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Y(*This.Bar_S)
    Protected Result.l
    
    If *This
      With *This
        If Not \Hide[1] And \color\Alpha
          Result = \Y ; -(\Height-\Radius/2)+1
        Else
          Result = \Y+\Height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Draw(*This.Bar_S)
    With *This
      If *This And Not \hide And \color\alpha
        
        ; Draw scroll bar background
        If \Color[0]\Back[\Color[0]\State]<>-1
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox( \X[0], \Y[0], \Width[0], \Height[0], \Radius, \Radius, \Color[0]\Back[\Color[0]\State]&$FFFFFF|\color\alpha<<24)
        EndIf
        
        ; Draw line
        If \Color[0]\Line[\Color[0]\State]<>-1
           If \s
           If \Vertical
            ; Draw left line
            If Not \s\h\hide
              ; "Это пустое пространство между двумя скроллами тоже закрашиваем если скролл бара кнопки не круглые"
              If Not \Radius : Box( \X[2], \Y[2]+\Height[2]+1, \Width[2], \Height[2], \Color[0]\Back[\Color[0]\State]&$FFFFFF|\color\alpha<<24) : EndIf
              Line( \X[0], \Y[0],1, \Height[0]-\Radius/2,\Color[0]\Line[\Color[0]\State]&$FFFFFF|\color\alpha<<24)
            Else
              Line( \X[0], \Y[0],1, \Height[0],\Color[0]\Line[\Color[0]\State]&$FFFFFF|\color\alpha<<24)
            EndIf
          Else
            ; Draw top line
              If Not \s\v\hide
                Line( \X[0], \Y[0], \Width[0]-\Radius/2,1,\Color[0]\Line[\Color[0]\State]&$FFFFFF|\color\alpha<<24)
              Else
                Line( \X[0], \Y[0], \Width[0],1,\Color[0]\Line[\Color[0]\State]&$FFFFFF|\color\alpha<<24)
              EndIf
            EndIf
          EndIf
        EndIf
        
        If \Thumb\len 
          ; Draw thumb  
          If \Color[3]\back[\Color[3]\State]<>-1
            If \Color[3]\Fore[\Color[3]\State]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            BoxGradient( \Vertical, \X[3], \Y[3], \Width[3], \Height[3], \Color[3]\Fore[\Color[3]\State], \Color[3]\Back[\Color[3]\State], \Radius, \color\alpha)
          EndIf
        
          ; Draw thumb frame
          If \Color[3]\Frame[\Color[3]\State] 
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \X[3], \Y[3], \Width[3], \Height[3], \Radius, \Radius, \Color[3]\Frame[\Color[3]\State]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        If \Button\len 
          ; Draw buttons
          If \Color[1]\back[\Color[1]\State]<>-1
            If \Color[1]\Fore[\Color[1]\State]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            BoxGradient( \Vertical, \X[1], \Y[1], \Width[1], \Height[1], \Color[1]\Fore[\Color[1]\State], \Color[1]\Back[\Color[1]\State], \Radius, \color\alpha)
            If \Color[2]\Fore[\Color[2]\State]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            BoxGradient( \Vertical, \X[2], \Y[2], \Width[2], \Height[2], \Color[2]\Fore[\Color[2]\State], \Color[2]\Back[\Color[2]\State], \Radius, \color\alpha)
          EndIf
        
          ; Draw buttons frame
          If \Color[1]\Frame[\Color[1]\State]
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color[1]\Frame[\Color[1]\State]&$FFFFFF|\color\alpha<<24)
          EndIf
          If \Color[2]\Frame[\Color[2]\State]
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color[2]\Frame[\Color[2]\State]&$FFFFFF|\color\alpha<<24)
          EndIf
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow( \X[1]+( \Width[1]-\ArrowSize[1])/2, \Y[1]+( \Height[1]-\ArrowSize[1])/2, \ArrowSize[1], Bool( \Vertical), \Color[1]\Front[\Color[1]\State]&$FFFFFF|\color\alpha<<24, \ArrowType[1])
          Arrow( \X[2]+( \Width[2]-\ArrowSize[2])/2, \Y[2]+( \Height[2]-\ArrowSize[2])/2, \ArrowSize[2], Bool( \Vertical)+2, \Color[2]\Front[\Color[2]\State]&$FFFFFF|\color\alpha<<24, \ArrowType[2])
        EndIf
        
        If \Color[3]\Fore[\Color[3]\State]  ; Draw thumb lines
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \Vertical
            Line( \X[3]+( \Width[3]-8)/2, \Y[3]+\Height[3]/2-3,9,1, \Color[3]\Front[\Color[3]\State]&$FFFFFF|\color\alpha<<24)
            Line( \X[3]+( \Width[3]-8)/2, \Y[3]+\Height[3]/2,9,1, \Color[3]\Front[\Color[3]\State]&$FFFFFF|\color\alpha<<24)
            Line( \X[3]+( \Width[3]-8)/2, \Y[3]+\Height[3]/2+3,9,1, \Color[3]\Front[\Color[3]\State]&$FFFFFF|\color\alpha<<24)
          Else
            Line( \X[3]+\Width[3]/2-3, \Y[3]+( \Height[3]-8)/2,1,9, \Color[3]\Front[\Color[3]\State]&$FFFFFF|\color\alpha<<24)
            Line( \X[3]+\Width[3]/2, \Y[3]+( \Height[3]-8)/2,1,9, \Color[3]\Front[\Color[3]\State]&$FFFFFF|\color\alpha<<24)
            Line( \X[3]+\Width[3]/2+3, \Y[3]+( \Height[3]-8)/2,1,9, \Color[3]\Front[\Color[3]\State]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draws(*Scroll.Scroll_S, ScrollHeight.i, ScrollWidth.i)
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
  
  Procedure.b SetState(*This.Bar_S, ScrollPos.i)
    Protected Result.b, Direction.i ; Направление и позиция скролла (вверх,вниз,влево,вправо)
    
    With *This
      If *This
        If ( \Vertical And \Type = #PB_GadgetType_TrackBar) : ScrollPos = (( \Max-\Min)-ScrollPos) : EndIf
        
        If ScrollPos < \Min : ScrollPos = \Min : EndIf
        If ScrollPos > (\Max-\Page\len) ; ((\Max-\Min) - \Page\len)
          ScrollPos = (\Max-\Page\len)
        EndIf
        
        If \Page\Pos <> ScrollPos 
          If \Page\Pos > ScrollPos
            Direction =- ScrollPos
          Else
            Direction = ScrollPos
          EndIf
          \Page\Pos = ScrollPos
          
          \Thumb\Pos = ThumbPos(*This, ScrollPos)
          
          If \s
            If \Vertical
              \s\y =- \Page\Pos
            Else
              \s\x =- \Page\Pos
            EndIf
            
            If \s\Post\event
              If \s\Post\widget
                PostEvent(\s\Post\event, \s\Post\window, \s\Post\widget, #PB_EventType_ScrollChange, Direction) 
              Else
                PostEvent(\s\Post\event, \s\Post\window, \s\Post\gadget, #PB_EventType_ScrollChange, Direction) 
              EndIf
            EndIf
          EndIf
          
          Result = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetAttribute(*This.Bar_S, Attribute.i, Value.i)
    Protected Result.i
    
    With *This
      If *This
        Select Attribute
          Case #__bar_Minimum
            If \Min <> Value 
              \Min = Value
              \Page\Pos = Value
              Result = #True
            EndIf
            
          Case #__bar_Maximum
            If \Max <> Value
              If \Min > Value
                \Max = \Min + 1
              Else
                \Max = Value
              EndIf
              
              If \s
                If \Vertical
                  \s\height = \Max
                Else
                  \s\width = \Max
                EndIf
              EndIf
              
              \Page\ScrollStep = ( \Max-\Min) / 100
              
              Result = #True
            EndIf
            
          Case #__bar_PageLength
            If \Page\len <> Value
              If Value > ( \Max-\Min) 
                If Not \Max 
                  \Max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает 
                EndIf
                
                \Page\len = ( \Max-\Min)
              Else
                \Page\len = Value
              EndIf
              
              Result = #True
            EndIf
            
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetColor(*This.Bar_S, ColorType.i, Color.i, State.i=0, Item.i=0)
    Protected Result, Count 
    State =- 1
    If Item < 0 
      Item = 0 
    ElseIf Item > 3 
      Item = 3 
    EndIf
    
    With *This
      If State =- 1
        Count = 2
        \Color\State = 0
      Else
        Count = State
        \Color\State = State
      EndIf
      
      For State = \Color\State To Count
        
        Select ColorType
          Case #__Color_Line
            If \Color[Item]\Line[State] <> Color 
              \Color[Item]\Line[State] = Color
              Result = #True
            EndIf
            
          Case #__Color_Back
            If \Color[Item]\Back[State] <> Color 
              \Color[Item]\Back[State] = Color
              Result = #True
            EndIf
            
          Case #__Color_Front
            If \Color[Item]\Front[State] <> Color 
              \Color[Item]\Front[State] = Color
              Result = #True
            EndIf
            
          Case #__Color_Frame
            If \Color[Item]\Frame[State] <> Color 
              \Color[Item]\Frame[State] = Color
              Result = #True
            EndIf
            
        EndSelect
        
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b Resize(*This.Bar_S, X.i,Y.i,Width.i,Height.i, *That.Bar_S=#Null)
    Protected Lines.i, ScrollPage.i
    
    With *This
      ScrollPage = ((\Max-\Min) - \Page\len)
      Lines = Bool(\Type=#PB_GadgetType_ScrollBar)
      
      ;
      If *This <> *That And *That And *That\hide
        If \Vertical
          If Height=#PB_Ignore 
            Height=(*That\Y+*That\Height)-\Y 
          EndIf
        Else
          If Width=#PB_Ignore
            Width=(*That\X+*That\Width)-\X 
          EndIf
        EndIf
      EndIf
      
      ;
      If X=#PB_Ignore : X = \X[0] : EndIf 
      If Y=#PB_Ignore : Y = \Y[0] : EndIf 
      If Width=#PB_Ignore : Width = \Width[0] : EndIf 
      If Height=#PB_Ignore : Height = \Height[0] : EndIf
      
      ; 
      \hide[1] = Bool(Not (\Page\Len And (\Max-\Min) > \Page\len))
      
      If Not \hide[1]
        If \Vertical
          \Area\Pos = Y+\Button\len
          \Area\len = (Height-\Button\len*2)
        Else
          \Area\Pos = X+\Button\len
          \Area\len = (Width-\Button\len*2)
        EndIf
        
        If \Area\len
          \Thumb\len = ThumbLength(*This)
          
          If (\Area\len > \Button\len)
            If \Button\len
              If (\Thumb\len < \Button\len)
                \Area\len = Round( \Area\len - ( \Button\len-\Thumb\len), #PB_Round_Nearest)
                \Thumb\len = \Button\len 
              EndIf
            Else
              If ( \Thumb\len < 7)
                \Area\len = Round( \Area\len - (7-\Thumb\len), #PB_Round_Nearest)
                \Thumb\len = 7
              EndIf
            EndIf
          Else
            \Thumb\len = \Area\len 
          EndIf
          
          If \Area\len > 0
            ; Debug " scroll set state "+\Max+" "+\Page\len+" "+Str( \Thumb\Pos+\Thumb\len) +" "+ Str( \Area\len+\Button\len)
            If ( \Type <> #PB_GadgetType_TrackBar) And (\Thumb\Pos+\Thumb\len) >= (\Area\Pos+\Area\len)
              SetState(*This, ScrollPage)
            EndIf
            
            \Thumb\Pos = ThumbPos(*This, \Page\Pos)
          EndIf
        EndIf
      EndIf
      
      \X[0] = X : \Y[0] = Y : \Width[0] = Width : \Height[0] = Height                                          ; Set scroll bar coordinate
      
      If \Vertical
        \X[1] = X + Lines : \Y[1] = Y : \Width[1] = Width - Lines : \Height[1] = \Button\len                   ; Top button coordinate on scroll bar
        \X[2] = X + Lines : \Width[2] = Width - Lines : \Height[2] = \Button\len : \Y[2] = Y+Height-\Height[2] ; Botom button coordinate on scroll bar
        \X[3] = X + Lines : \Width[3] = Width - Lines : \Y[3] = \Thumb\Pos : \Height[3] = \Thumb\len           ; Thumb coordinate on scroll bar
      Else
        \X[1] = X : \Y[1] = Y + Lines : \Width[1] = \Button\len : \Height[1] = Height - Lines                  ; Left button coordinate on scroll bar
        \Y[2] = Y + Lines : \Height[2] = Height - Lines : \Width[2] = \Button\len : \X[2] = X+Width-\Width[2]  ; Right button coordinate on scroll bar
        \Y[3] = Y + Lines : \Height[3] = Height - Lines : \X[3] = \Thumb\Pos : \Width[3] = \Thumb\len          ; Thumb coordinate on scroll bar
      EndIf
      
      ProcedureReturn \hide[1]
    EndWith
  EndProcedure
  
  Procedure.b Updates(*Scroll.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    Protected iWidth = X(*Scroll\v)-(*Scroll\v\Width-*Scroll\v\Radius/2)+1, iHeight = Y(*Scroll\h)-(*Scroll\h\Height-*Scroll\h\Radius/2)+1
    Static hPos, vPos : vPos = *Scroll\v\Page\Pos : hPos = *Scroll\h\Page\Pos
    
    ; Вправо работает как надо
    If ScrollArea_Width<*Scroll\h\Page\Pos+iWidth 
      ScrollArea_Width=*Scroll\h\Page\Pos+iWidth
      ; Влево работает как надо
    ElseIf ScrollArea_X>*Scroll\h\Page\Pos And
           ScrollArea_Width=*Scroll\h\Page\Pos+iWidth 
      ScrollArea_Width = iWidth 
    EndIf
    
    ; Вниз работает как надо
    If ScrollArea_Height<*Scroll\v\Page\Pos+iHeight
      ScrollArea_Height=*Scroll\v\Page\Pos+iHeight 
      ; Верх работает как надо
    ElseIf ScrollArea_Y>*Scroll\v\Page\Pos And
           ScrollArea_Height=*Scroll\v\Page\Pos+iHeight 
      ScrollArea_Height = iHeight 
    EndIf
    
    If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
    If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
    
    If ScrollArea_X<*Scroll\h\Page\Pos : ScrollArea_Width-ScrollArea_X : EndIf
    If ScrollArea_Y<*Scroll\v\Page\Pos : ScrollArea_Height-ScrollArea_Y : EndIf
    
    If *Scroll\v\max<>ScrollArea_Height : SetAttribute(*Scroll\v, #__bar_Maximum, ScrollArea_Height) : EndIf
    If *Scroll\h\max<>ScrollArea_Width : SetAttribute(*Scroll\h, #__bar_Maximum, ScrollArea_Width) : EndIf
    
    If *Scroll\v\Page\len<>iHeight : SetAttribute(*Scroll\v, #__bar_PageLength, iHeight) : EndIf
    If *Scroll\h\Page\len<>iWidth : SetAttribute(*Scroll\h, #__bar_PageLength, iWidth) : EndIf
    
    If ScrollArea_Y<0 : SetState(*Scroll\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
    If ScrollArea_X<0 : SetState(*Scroll\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
    
    *Scroll\v\hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h) 
    *Scroll\h\hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\v)
    
    If *Scroll\v\hide : *Scroll\v\Page\Pos = 0 : If vPos : *Scroll\v\hide = vPos : EndIf : Else : *Scroll\v\Page\Pos = vPos : *Scroll\h\Width = iWidth+*Scroll\v\Width : EndIf
    If *Scroll\h\hide : *Scroll\h\Page\Pos = 0 : If hPos : *Scroll\h\hide = hPos : EndIf : Else : *Scroll\h\Page\Pos = hPos : *Scroll\v\Height = iHeight+*Scroll\h\Height : EndIf
    
    ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
  EndProcedure
  
  Procedure.b Resizes(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i)
    If Not Bool(*Scroll\v And *Scroll\h) 
      If *Scroll\v
        If Width<>#PB_Ignore
          X = Width-*Scroll\v\Width
        EndIf
        ProcedureReturn Resize(*Scroll\v, X,#PB_Ignore,#PB_Ignore,Height.i)
      ElseIf *Scroll\h
        If Height<>#PB_Ignore
          Y = Height-*Scroll\h\Height
        EndIf
        ProcedureReturn Resize(*Scroll\h, #PB_Ignore,Y,Width.i,#PB_Ignore)
      Else
        *Scroll\Width[2] = Width
        *Scroll\Height[2] = Height
        ProcedureReturn - 1
      EndIf
    EndIf
    
    If *Scroll\v And Y<>#PB_Ignore And *Scroll\v\Max <> *Scroll\Height
      SetAttribute(*Scroll\v, #__bar_Maximum, *Scroll\Height)
    EndIf
    If *Scroll\h And X<>#PB_Ignore And *Scroll\h\Max <> *Scroll\Width
      SetAttribute(*Scroll\h, #__bar_Maximum, *Scroll\Width)
    EndIf
    
    If Width=#PB_Ignore : Width = *Scroll\v\X : Else : Width+x-*Scroll\v\Width : EndIf
    If Height=#PB_Ignore : Height = *Scroll\h\Y : Else : Height+y-*Scroll\h\Height : EndIf
    
    Protected iWidth = x(*Scroll\v)-*Scroll\h\x, iHeight = y(*Scroll\h)-*Scroll\v\y
    
    If *Scroll\v\width And *Scroll\v\Page\len<>iHeight : SetAttribute(*Scroll\v, #__bar_PageLength, iHeight) : EndIf
    If *Scroll\h\height And *Scroll\h\Page\len<>iWidth : SetAttribute(*Scroll\h, #__bar_PageLength, iWidth) : EndIf
    
    *Scroll\v\Hide = Resize(*Scroll\v, Width, Y, #PB_Ignore, #PB_Ignore, *Scroll\h) : iWidth = x(*Scroll\v)-*Scroll\h\x
    *Scroll\h\Hide = Resize(*Scroll\h, X, Height, #PB_Ignore, #PB_Ignore, *Scroll\v) : iHeight = y(*Scroll\h)-*Scroll\v\y
    
    If *Scroll\v\width And *Scroll\v\Page\len<>iHeight : SetAttribute(*Scroll\v, #__bar_PageLength, iHeight) : EndIf
    If *Scroll\h\height And *Scroll\h\Page\len<>iWidth : SetAttribute(*Scroll\h, #__bar_PageLength, iWidth) : EndIf
    
    If *Scroll\v\width : *Scroll\v\Hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h) : EndIf
    If *Scroll\h\height : *Scroll\h\Hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\v) : EndIf
    
    If *Scroll\v\Hide : *Scroll\v\Page\Pos = 0 : *Scroll\Y = 0 : Else
      If *Scroll\h\Radius : Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, (*Scroll\v\x-*Scroll\h\x)+Bool(*Scroll\v\Radius)*4, #PB_Ignore) : EndIf
    EndIf
    If *Scroll\h\Hide : *Scroll\h\Page\Pos = 0 : *Scroll\X = 0 : Else
      If *Scroll\v\Radius : Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\h\y-*Scroll\v\y)+Bool(*Scroll\h\Radius)*4) : EndIf
    EndIf
    
    *Scroll\Width[2] = x(*Scroll\v)-*Scroll\h\x
    *Scroll\Height[2] = y(*Scroll\h)-*Scroll\v\y
    
    ProcedureReturn Bool(Not Bool(*Scroll\v\Hide|*Scroll\h\Hide))
  EndProcedure
  
  
  Procedure.i Events(*This.Bar_S, EventType.i, mouseX.i, mouseY.i, at.i)
    Static delta, cursor
    Protected Repaint.i
    Protected window = EventWindow()
    Protected canvas = EventGadget()
    
    ;Debug EventType
    
    If *This
      With *This
        Select EventType
          Case #PB_EventType_LeftDoubleClick 
            Select at
              Case - 1
                ; If \Height > ( \Y[2]+\Height[2])
                If \Vertical
                  Repaint = SetState(*This, Pos(*This, (mouseY-\Thumb\len/2)))
                Else
                  Repaint = SetState(*This, Pos(*This, (mouseX-\Thumb\len/2)))
                EndIf
                ; EndIf
            EndSelect
            
          Case #PB_EventType_LeftButtonUp : delta = 0
          Case #PB_EventType_LeftButtonDown 
            Select at
              Case 1 : Repaint = SetState(*This, ( \Page\Pos - \Page\ScrollStep))
              Case 2 : Repaint = SetState(*This, ( \Page\Pos + \Page\ScrollStep))
              Case 3 
                If \Vertical
                  delta = mouseY - \Thumb\Pos
                Else
                  delta = mouseX - \Thumb\Pos
                EndIf
            EndSelect
            
          Case #PB_EventType_MouseMove
            If delta
              If \Vertical
                Repaint = SetState(*This, Pos(*This, (mouseY-delta)))
              Else
                Repaint = SetState(*This, Pos(*This, (mouseX-delta)))
              EndIf
            EndIf
        EndSelect
        
        Select EventType
          Case #PB_EventType_MouseLeave
            If at > 0
              \Color[at]\State = 0
            Else
              ; Debug ""+*This +" "+ EventType +" "+ at
              
              If cursor <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                SetGadgetAttribute(canvas, #PB_Canvas_Cursor, cursor)
              EndIf
              
              \Color[1]\State = 0
              \Color[2]\State = 0
              \Color[3]\State = 0
            EndIf
            Repaint = #True
            
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter
            If at>0
              \Color[at]\State = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
              
              Repaint = #True
            Else
              ; Debug ""+*This +" "+ EventType +" "+ at
              
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
  
  Procedure.b CallBack(*This.Bar_S, EventType.i, mouseX=0, mouseY=0)
    Protected repaint
    Static Last, Down, *Scroll.Bar_S, *Last.Bar_S, mouseB, mouseat
    
    With *This
      If *This And Not \hide And \color\alpha And \Type = #PB_GadgetType_ScrollBar
        If Not mouseX
          mouseX = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX)
        EndIf
        If Not mouseY
          mouseY = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY)
        EndIf
        
        ; get at point buttons
        If mouseB
        ElseIf (mouseX>=\X And mouseX<\X+\Width And mouseY>\Y And mouseY=<\Y+\Height) 
          If (mouseX>\X[1] And mouseX=<\X[1]+\Width[1] And  mouseY>\Y[1] And mouseY=<\Y[1]+\Height[1])
            \at = 1
          ElseIf (mouseX>\X[3] And mouseX=<\X[3]+\Width[3] And mouseY>\Y[3] And mouseY=<\Y[3]+\Height[3])
            \at = 3
          ElseIf (mouseX>\X[2] And mouseX=<\X[2]+\Width[2] And mouseY>\Y[2] And mouseY=<\Y[2]+\Height[2])
            \at = 2
          Else
            \at =- 1
          EndIf 
          
          Select EventType 
            Case #PB_EventType_MouseEnter : EventType = #PB_EventType_MouseMove
            Case #PB_EventType_MouseLeave : EventType = #PB_EventType_MouseMove
          EndSelect
          
          mouseat = *This
        Else
          \at = 0
          
          Select EventType 
            Case #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
              If \Vertical
                If \s And \s\h And \s\h\at
                  If \s\h\at > 0
                    repaint | Events(\s\h, EventType, mouseX, mouseY, \s\h\at)
                  EndIf
                  repaint | Events(\s\h, EventType, mouseX, mouseY, - 1)
                  If EventType = #PB_EventType_MouseLeave
                    *Scroll = 0
                  EndIf
                  
                  \s\h\at = 0
                EndIf
              EndIf     
              
              EventType = #PB_EventType_MouseMove
          EndSelect
          
          If \Vertical
            If \s And \s\h And \s\h\at
              If \Color[2]\State
                repaint | Events(*This, #PB_EventType_MouseLeave, mouseX, mouseY, \at)
                ;                   repaint | Events(*This, #PB_EventType_MouseLeave, - 1)
                ;                   repaint | Events(\s\h, #PB_EventType_MouseEnter, - 1)
                repaint | Events(\s\h, #PB_EventType_MouseEnter, mouseX, mouseY, \s\h\at)
                \Color[2]\State = 0
              EndIf
            Else
              mouseat = 0
            EndIf
          Else
            If \s And \s\v And \s\v\at
              If \Color[2]\State
                repaint | Events(*This, #PB_EventType_MouseLeave, mouseX, mouseY, \at)
                ;                   repaint | Events(*This, #PB_EventType_MouseLeave, - 1)
                ;                   repaint | Events(\s\v, #PB_EventType_MouseEnter, - 1)
                repaint | Events(\s\v, #PB_EventType_MouseEnter, mouseX, mouseY, \s\v\at)
                \Color[2]\State = 0
              EndIf
            Else
              mouseat = 0
            EndIf
          EndIf
          
        EndIf
        
        If *Scroll <> mouseat And 
           *This = mouseat
          *Last = *Scroll
          *Scroll = mouseat
        EndIf
        
        If *Scroll = *This
          If Last <> \at
            ;
            ; Debug ""+Last +" "+ *This\at +" "+ *This +" "+ *Last
            If Last > 0 Or (Last = 2 And \at =- 1 And *Last)
              repaint | Events(*This, #PB_EventType_MouseLeave, mouseX, mouseY, Last) : *Last = 0
            EndIf
            If Not \at Or (Last = 2 And \at =- 1 And *Last)
              repaint | Events(*This, #PB_EventType_MouseLeave, mouseX, mouseY, - 1) : *Last = 0
            EndIf
            
            If Not last ; Or (Last =- 1 And \at = 2 And *Last)
              repaint | Events(*This, #PB_EventType_MouseEnter, mouseX, mouseY, - 1)
            EndIf
            If \at > 0
              repaint | Events(*This, #PB_EventType_MouseEnter, mouseX, mouseY, \at)
            EndIf
            
            Last = \at
          EndIf
          
          Select EventType 
            Case #PB_EventType_LeftButtonDown
              mouseB = 1
              If \at
                Down = \at
                repaint | Events(*This, EventType, mouseX, mouseY, \at)
              EndIf
              
            Case #PB_EventType_LeftButtonUp 
              mouseB = 0
              If Down
                repaint | Events(*This, EventType, mouseX, mouseY, Down)
                Down = 0
              EndIf
              
            Case #PB_EventType_LeftDoubleClick, 
                 #PB_EventType_LeftButtonDown, 
                 #PB_EventType_MouseMove
              
              If \at
                repaint | Events(*This, EventType, mouseX, mouseY, \at)
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
        ; ; ;           If EventType = #PB_EventType_MouseEnter And (*Thisis = *This Or Not *Scroll)
        ; ; ;             If \color\alpha < 255 : \color\alpha = 255
        ; ; ;               
        ; ; ;               If *Scroll
        ; ; ;                 If \Vertical
        ; ; ;                   Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\Y+*Scroll\Height)-\Y) 
        ; ; ;                 Else
        ; ; ;                   Resize(*This, #PB_Ignore, #PB_Ignore, (*Scroll\X+*Scroll\Width)-\X, #PB_Ignore) 
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
  
  Procedure.i Bar(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
    Protected *This.Bar_S = AllocateStructure(Bar_S)
    
    With *This
      \X =- 1
      \Y =- 1
      \Radius = Radius
      \Vertical = Bool(Flag=#__bar_Vertical)
      \Type = #PB_GadgetType_ScrollBar
      
      \ArrowSize[1] = 4
      \ArrowSize[2] = 4
      \ArrowType[1] =- 1 ; -1 0 1
      \ArrowType[2] =- 1 ; -1 0 1
      
      ; Цвет фона скролла
      \color\alpha = 255
      \color\alpha[1] = 0
      \Color[0]\State = 0
      \Color[0]\Back[0] = $FFF9F9F9
      \Color[0]\Frame[0] = \Color\Back[0]
      \Color[0]\Line[0] = $FFFFFFFF
      
      \Color[1] = Colors
      \Color[2] = Colors
      \Color[3] = Colors
      
      If \Vertical
        If width < 21
          \Button\len = width - 1
        Else
          \Button\len = 17
        EndIf
      Else
        If height < 21
          \Button\len = height - 1
        Else
          \Button\len = 17
        EndIf
      EndIf
      
      If \Min <> Min : SetAttribute(*This, #__bar_Minimum, Min) : EndIf
      If \Max <> Max : SetAttribute(*This, #__bar_Maximum, Max) : EndIf
      If \Page\len <> Pagelength : SetAttribute(*This, #__bar_PageLength, Pagelength) : EndIf
    EndWith
    
    Resize(*This, X,Y,Width,Height)
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Bars(*Scroll.Scroll_S, Size.i, Radius.i, Both.b)
    *Scroll\v = Bar(#PB_Ignore,#PB_Ignore,Size,#PB_Ignore, 0,0,0, #__bar_Vertical, Radius)
    *Scroll\v\hide = *Scroll\v\hide[1]
    *Scroll\v\s = *Scroll
    
    If Both
      *Scroll\h = Bar(#PB_Ignore,#PB_Ignore,#PB_Ignore,Size, 0,0,0, 0, Radius)
      *Scroll\h\hide = *Scroll\h\hide[1]
    Else
      *Scroll\h.Bar_S = AllocateStructure(Bar_S)
      *Scroll\h\hide = 1
    EndIf
    *Scroll\h\s = *Scroll
    
    With *Scroll     
      If \Post\Function And \Post\Event
        UnbindEvent(\Post\Event, \Post\Function, \Post\Window, \Post\Gadget)
        BindEvent(\Post\Event, \Post\Function, \Post\Window, \Post\Gadget)
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
  Declare.i Update(*This._s_widget)
  
  ;- DECLARE
  Declare.i SetItemState(*This._s_widget, Item.i, State.i)
  Declare GetState(*This._s_widget)
  Declare.s GetText(*This._s_widget)
  Declare.i ClearItems(*This._s_widget)
  Declare.i CountItems(*This._s_widget)
  Declare.i RemoveItem(*This._s_widget, Item.i)
  Declare SetState(*This._s_widget, State.i)
  Declare GetAttribute(*This._s_widget, Attribute.i)
  Declare SetAttribute(*This._s_widget, Attribute.i, Value.i)
  Declare SetText(*This._s_widget, Text.s, Item.i=0)
  Declare SetFont(*This._s_widget, FontID.i)
  Declare.i AddItem(*This._s_widget, Item.i,Text.s,Image.i=-1,Flag.i=0)
  Declare ReDraw(*This._s_widget, Canvas =- 1, BackColor=$FFF0F0F0)
  
  ;Declare.i Make(*This._s_widget)
  Declare.i CallBack(*This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s="", Flag.i=0, Radius.i=0)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
  Declare.i ReDraw(*This._s_widget, Canvas =- 1, BackColor=$FFF0F0F0)
  Declare.i Draw(*This._s_widget)
EndDeclareModule

Module Editor
  Global *Buffer = AllocateMemory(10000000)
  Global *Pointer = *Buffer
  
  Procedure.i Update(*This._s_widget)
    *This\Text\String.s = PeekS(*Buffer)
    *This\Text\Change = 1
  EndProcedure
  ; ;   UseModule Constant
  ;- PROCEDURE
  ;-
  
  Declare.i Canvas_CallBack()
  
  ;-
  ;- PUBLIC
  Procedure.i Caret(*This._s_widget, Line.i = 0)
    Static LastLine.i =- 1,  LastItem.i =- 1
    Protected Item.i, SelectionLen.i
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, MouseX.i, Distance.f, MinDistance.f = Infinity()
    
    With *This
      If Line < 0 And FirstElement(*This\Items())
        ; А если выше всех линии текста,
        ; то позиция коректора начало текста.
        Position = 0
      ElseIf Line < ListSize(*This\Items()) And 
             SelectElement(*This\Items(), Line)
        ; Если находимся на линии текста, 
        ; то получаем позицию коректора.
        
        If ListSize(\Items())
          Len = \Items()\Text\Len
          FontID = \Items()\Text\FontID
          String.s = \Items()\Text\String.s
          If Not FontID : FontID = \Text\FontID : EndIf
          MouseX = \Canvas\Mouse\X - (\Items()\Text\X+\Scroll\X)
          
          If StartDrawing(CanvasOutput(\Canvas\Gadget)) 
            If FontID : DrawingFont(FontID) : EndIf
            
            ; Get caret pos & len
            For i = 0 To Len
              X = TextWidth(Left(String.s, i))
              Distance = (MouseX-X)*(MouseX-X)
              
              If MinDistance > Distance 
                MinDistance = Distance
                \Text\Caret[2] = X ; len
                Position = i       ; pos
              EndIf
            Next 
            
            ;             ; Длина переноса строки
            ;             PushListPosition(\Items())
            ;             If \Canvas\Mouse\Y < \Y+(\Text\Height/2+1)
            ;               Item.i =- 1 
            ;             Else
            ;               Item.i = ((((\Canvas\Mouse\Y-\Y-\Text\Y)-\Scroll\Y) / (\Text\Height/2+1)) - 1)/2
            ;             EndIf
            ;             
            ;             If LastLine <> \Index[1] Or LastItem <> Item
            ;               \Items()\Text[2]\Width[2] = 0
            ;               
            ;               If (\Items()\Text\String.s = "" And Item = \Index[1] And Position = len) Or
            ;                  \Index[2] > \Index[1] Or                                            ; Если выделяем снизу вверх
            ;                  (\Index[2] =< \Index[1] And \Index[1] = Item And Position = len) Or ; Если позиция курсора неже половини высоты линии
            ;                  (\Index[2] < \Index[1] And                                          ; Если выделяем сверху вниз
            ;                   PreviousElement(*This\Items()))                                    ; то выбираем предыдущую линию
            ;                 
            ;                 If Position = len And Not \Items()\Text[2]\Len : \Items()\Text[2]\Len = 1
            ;                   \Items()\Text[2]\X = \Items()\Text\X+\Items()\Text\Width
            ;                 EndIf 
            ;                 
            ;                 ; \Items()\Text[2]\Width = (\Items()\Width-\Items()\Text\Width) + TextWidth(\Items()\Text[2]\String.s)
            ;                 
            ;                 If \Flag\FullSelection
            ;                   \Items()\Text[2]\Width[2] = \Flag\FullSelection
            ;                 Else
            ;                   \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
            ;                 EndIf
            ;               EndIf
            ;               
            ;               LastItem = Item
            ;               LastLine = \Index[1]
            ;             EndIf
            ;             PopListPosition(\Items())
            
            StopDrawing()
          EndIf
        EndIf
        
      ElseIf LastElement(*This\Items())
        ; Иначе, если ниже всех линии текста,
        ; то позиция коректора конец текста.
        Position = \Items()\Text\Len
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure.i Change(*This._s_widget, Pos.i, Len.i)
    With *This
      \Items()\Text[2]\Pos = Pos
      \Items()\Text[2]\Len = Len
      
      ; text string/pos/len/state
      If (\index[2] > \index[1] Or \index[2] = \Items()\index)
        \Text[1]\Change = #True
      EndIf
      If (\index[2] < \index[1] Or \index[2] = \Items()\index) 
        \Text[3]\Change = 1
      EndIf
      
      ; lines string/pos/len/state
      \Items()\Text[1]\Change = #True
      \Items()\Text[1]\Len = \Items()\Text[2]\Pos
      \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Items()\Text[1]\Len) 
      
      \Items()\Text[3]\Change = #True
      \Items()\Text[3]\Pos = (\Items()\Text[2]\Pos + \Items()\Text[2]\Len)
      \Items()\Text[3]\Len = (\Items()\Text\Len - \Items()\Text[3]\Pos)
      \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text[3]\Len) 
      
      If \Items()\Text[1]\Len = \Items()\Text[3]\Pos
        \Items()\Text[2]\String.s = ""
        \Items()\Text[2]\Width = 0
      Else
        \Items()\Text[2]\Change = #True 
        \Items()\Text[2]\String.s = Mid(\Items()\Text\String.s, 1 + \Items()\Text[2]\Pos, \Items()\Text[2]\Len) 
      EndIf
      
      If (\Text[1]\Change Or \Text[3]\Change)
        If \Text[1]\Change
          \Text[1]\Len = (\Items()\Text[0]\Pos + \Items()\Text[1]\len)
          \Text[1]\String.s = Left(\Text\String.s, \Text[1]\Len) 
          \Text[2]\Pos = \Text[1]\Len
        EndIf
        
        If \Text[3]\Change
          \Text[3]\Pos = (\Items()\Text[0]\Pos + \Items()\Text[3]\Pos)
          \Text[3]\Len = (\Text\Len - \Text[3]\Pos)
          \Text[3]\String.s = Right(\Text\String.s, \Text[3]\Len)
        EndIf
        
        If \Text[1]\Len <> \Text[3]\Pos 
          \Text[2]\Change = 1 
          \Text[2]\Len = (\Text[3]\Pos-\Text[2]\Pos)
          \Text[2]\String.s = Mid(\Text\String.s, 1 + \Text[2]\Pos, \Text[2]\Len) 
        Else
          \Text[2]\Len = 0 : \Text[2]\String.s = ""
        EndIf
        
        \Text[1]\Change = 0 : \Text[3]\Change = 0 
      EndIf
      
      
      
      ;       If CountString(\Text[3]\String.s, #LF$)
      ;         Debug "chang "+\Items()\Text\String.s +" "+ CountString(\Text[3]\String.s, #LF$)
      ;       EndIf
      ;       
    EndWith
  EndProcedure
  
  Procedure SelectionText(*This._s_widget) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Pos.i, Len.i
    
    With *This
      ;Debug "7777    "+\Text\Caret +" "+ \Text\Caret[1] +" "+\Index[1] +" "+ \Index[2] +" "+ \Items()\Text\String
      
      If (Caret <> \Text\Caret Or Line <> \Index[1] Or (\Text\Caret[1] >= 0 And Caret1 <> \Text\Caret[1]))
        \Items()\Text[2]\String.s = ""
        
        PushListPosition(\Items())
        If \Index[2] = \Index[1]
          If \Text\Caret[1] = \Text\Caret And \Items()\Text[2]\Len 
            \Items()\Text[2]\Len = 0 
            \Items()\Text[2]\Width = 0 
          EndIf
          If PreviousElement(\Items()) And \Items()\Text[2]\Len 
            \Items()\Text[2]\Width[2] = 0 
            \Items()\Text[2]\Len = 0 
          EndIf
        ElseIf \Index[2] > \Index[1]
          If PreviousElement(\Items()) And \Items()\Text[2]\Len 
            \Items()\Text[2]\Len = 0 
          EndIf
        Else
          If NextElement(\Items()) And \Items()\Text[2]\Len 
            \Items()\Text[2]\Len = 0 
          EndIf
        EndIf
        PopListPosition(\Items())
        
        If \Index[2] = \Index[1]
          If \Text\Caret[1] = \Text\Caret 
            Pos = \Text\Caret[1]
            ;             If \Text\Caret[1] = \Items()\Text\Len
            ;              ; Debug 555
            ;             ;  Len =- 1
            ;             EndIf
            ; Если выделяем с право на лево
          ElseIf \Text\Caret[1] > \Text\Caret 
            ; |<<<<<< to left
            Pos = \Text\Caret
            Len = (\Text\Caret[1]-Pos)
          Else 
            ; >>>>>>| to right
            Pos = \Text\Caret[1]
            Len = (\Text\Caret-Pos)
          EndIf
          
          ; Если выделяем снизу вверх
        ElseIf \Index[2] > \Index[1]
          ; <<<<<|
          Pos = \Text\Caret
          Len = \Items()\Text\Len-Pos
          ; Len - Bool(\Items()\Text\Len=Pos) ; 
        Else
          ; >>>>>|
          Pos = 0
          Len = \Text\Caret
        EndIf
        
        Change(*This, Pos, Len)
        
        Line = \Index[1]
        Caret = \Text\Caret
        Caret1 = \Text\Caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Pos
  EndProcedure
  
  Procedure.i SelReset(*This._s_widget)
    With *This
      PushListPosition(\Items())
      ForEach \Items() 
        If \Items()\Text[2]\Len <> 0
          \Items()\Text[2]\Len = 0 
          \Items()\Text[2]\Width[2] = 0 
          \Items()\Text[1]\String = ""
          \Items()\Text[2]\String = "" 
          \Items()\Text[3]\String = ""
          \Items()\Text[2]\Width = 0 
        EndIf
      Next
      PopListPosition(\Items())
    EndWith
  EndProcedure
  
  
  Procedure.i SelLimits(*This._s_widget)
    Protected i, char.i
    
    Macro _is_selection_end_(_char_)
      Bool((_char_ > = ' ' And _char_ = < '/') Or 
           (_char_ > = ':' And _char_ = < '@') Or 
           (_char_ > = '[' And _char_ = < 96) Or 
           (_char_ > = '{' And _char_ = < '~'))
    EndMacro
    
    With *This
      char = Asc(Mid(\Items()\Text\String.s, \Text\Caret + 1, 1))
      If _is_selection_end_(char)
        \Text\Caret + 1
        \Items()\Text[2]\Len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \Text\Caret To 1 Step - 1
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = \Text\Caret To \Items()\Text\Len
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret = i - 1
        \Items()\Text[2]\Len = \Text\Caret[1] - \Text\Caret
      EndIf
    EndWith           
  EndProcedure
  
  Procedure.i Text_SelLimits(*This._s_widget)
    Protected i, char.i
    
;     Macro _is_selection_end_(_char_)
;       Bool((_char_ > = ' ' And _char_ = < '/') Or 
;            (_char_ > = ':' And _char_ = < '@') Or 
;            (_char_ > = '[' And _char_ = < 96) Or 
;            (_char_ > = '{' And _char_ = < '~'))
;     EndMacro
    
    With *This
      char = Asc(Mid(\Items()\Text\String.s, \Text\Caret + 1, 1))
      If _is_selection_end_(char)
        \Text\Caret + 1
        \Items()\Text[2]\Len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \Text\Caret To 1 Step - 1
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = \Text\Caret To \Items()\Text\Len
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret = i - 1
        \Items()\Text[2]\Len = \Text\Caret[1] - \Text\Caret
      EndIf
    EndWith           
  EndProcedure
  
  
  ;-
  Procedure Move(*This._s_widget, Width)
    Protected Left,Right
    
    With *This
      ; Если строка выходит за предели виджета
      PushListPosition(\items())
      If SelectElement(\items(), \Text\Big) ;And \Items()\text\x+\Items()\text\width > \Items()\X+\Items()\width
        Protected Caret.i =- 1, i.i, cursor_x.i, Distance.f, MinDistance.f = Infinity()
        Protected String.s = \Items()\Text\String.s
        Protected string_len.i = \Items()\Text\Len
        Protected mouse_x.i = \Canvas\Mouse\X-(\Items()\Text\X+\Scroll\X)
        
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
        \Items()\Text[3]\Width = TextWidth(Right(String.s, string_len-Caret))
        
        If \Scroll\X < Right
          Scroll::SetState(\Scroll\h, -Right) ;: \Scroll\X = Right
        ElseIf \Scroll\X > Left
          Scroll::SetState(\Scroll\h, -Left) ;: \Scroll\X = Left
        ElseIf (\Scroll\X < 0 And \Canvas\Input = 65535 ) : \Canvas\Input = 0
          \Scroll\X = (Width-\Items()\Text[3]\Width) + Right
          If \Scroll\X>0 : \Scroll\X=0 : EndIf
        EndIf
      EndIf
      PopListPosition(\items())
    EndWith
    
    ProcedureReturn Left
  EndProcedure
  
  Procedure.i Make(*This._s_widget)
    Protected String1.s, String2.s, String3.s, Count.i
    
    With *This
      If ListSize(\Lines())
        \Text\Count = 0;CountString(\text\string, #LF$)
        
        ForEach \Lines()
          If \Lines()\Index =- 1 : \Text\Count + 1
            If String1.s
              String1.s +#LF$+ \Lines()\Text\String.s 
            Else
              String1.s + \Lines()\Text\String.s
            EndIf
          EndIf
        Next : String1.s + #LF$
        
        ForEach \Lines()
          If \Lines()\Index = \Text\Count
            If String2.s
              String2.s +#LF$+ \Lines()\Text\String.s 
            Else
              String2.s + \Lines()\Text\String.s
            EndIf
            DeleteElement(\Lines())
          EndIf
        Next : String2.s + #LF$
        
        ForEach \Lines()
          If \Lines()\Index > 0
            If String3.s
              String3.s +#LF$+ \Lines()\Text\String.s 
            Else
              String3.s + \Lines()\Text\String.s
            EndIf
          EndIf
        Next : String3.s + #LF$
        
        \Text\String.s = String1.s + String2.s + \Text\String.s + String3.s
        \Text\Count = CountString(\Text\string, #LF$)
        \Text\Len = Len(\Text\String.s)
        \Text\Change = 1
        
        ; ;         ForEach \Lines()
        ; ;         ;  Text_AddLine(*This,\Lines()\Index, \Lines()\Text\String.s)
        ; ;         Next 
        ClearList(\Lines())
      EndIf
    EndWith
  EndProcedure
  
  Procedure.s Text_Make(*This._s_widget, Text.s)
    Protected String.s, i.i, Len.i
    
    With *This
      If \Text\Numeric And Text.s <> #LF$
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
            If \Type = #PB_GadgetType_IPAddress
              left.s = Left(\Text\String, \Text\Caret)
              Select CountString(left.s, ".")
                Case 0 : left.s = StringField(left.s, 1, ".")
                Case 1 : left.s = StringField(left.s, 2, ".")
                Case 2 : left.s = StringField(left.s, 3, ".")
                Case 3 : left.s = StringField(left.s, 4, ".")
              EndSelect                                           
              count = Len(left.s+Trim(StringField(Mid(\Text\String, \Text\Caret+1), 1, "."), #LF$))
              If count < 3 And (Val(left.s) > 25 Or Val(left.s+Chr.s) > 255)
                Continue
                ;               ElseIf Mid(\Text\String, \Text\Caret + 1, 1) = "."
                ;                 \Text\Caret + 1 : \Text\Caret[1]=\Text\Caret
              EndIf
            EndIf
            
            If Not Dot And Input = '.' And Mid(\Text\String, \Text\Caret + 1, 1) <> "."
              Dot = 1
            ElseIf Input <> '.' And count < 3
              Dot = 0
            Else
              Continue
            EndIf
            
            If Not Minus And Input = '-' And Mid(\Text\String, \Text\Caret + 1, 1) <> "-"
              Minus = 1
            ElseIf Input <> '-'
              Minus = 0
            Else
              Continue
            EndIf
            
            String.s + Chr
          EndIf
        Next
        
      ElseIf \Text\Pass
        Len = Len(Text.s) 
        For i = 1 To Len : String.s + "●" : Next
        
      Else
        Select #True
          Case \Text\Lower : String.s = LCase(Text.s)
          Case \Text\Upper : String.s = UCase(Text.s)
          Default
            String.s = Text.s
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn String.s
  EndProcedure
  
  Procedure.i Paste(*This._s_widget, Chr.s, Count.i=0)
    Protected Repaint.i
    
    With *This
      If \Index[1] <> \Index[2] ; Это значить строки выделени
        If \Index[2] > \Index[1] : Swap \Index[2], \Index[1] : EndIf
        
        SelReset(*This)
        
        If Count
          \Index[2] + Count
          \Text\Caret = Len(StringField(Chr.s, 1 + Count, #LF$))
        ElseIf Chr.s = #LF$ ; to return
          \Index[2] + 1
          \Text\Caret = 0
        Else
          \Text\Caret = \Items()\Text[1]\Len + Len(Chr.s)
        EndIf
        
        \Text\Caret[1] = \Text\Caret
        \Index[1] = \Index[2]
        \Text\Change =- 1 ; - 1 post event change widget
        Repaint = 1 
      EndIf
      
      \Text\String.s = \Text[1]\String + Chr.s + \Text[3]\String
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Insert(*This._s_widget, Chr.s)
    Static Dot, Minus, Color.i
    Protected Repaint, Input, Input_2, String.s, Count.i
    
    With *This
      Chr.s = Text_Make(*This, Chr.s)
      
      If Chr.s
        Count = CountString(Chr.s, #LF$)
        
        If Not Paste(*This, Chr.s, Count)
          If \Items()\Text[2]\Len 
            If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
            \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          EndIf
          
          \Items()\Text[1]\Change = 1
          \Items()\Text[1]\String.s + Chr.s
          \Items()\Text[1]\len = Len(\Items()\Text[1]\String.s)
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          If Count
            \Index[2] + Count
            \Index[1] = \Index[2] 
            \Text\Caret = Len(StringField(Chr.s, 1 + Count, #LF$))
          Else
            \Text\Caret + Len(Chr.s) 
          EndIf
          
          \Text\String.s = \Text[1]\String + Chr.s + \Text[3]\String
          \Text\Caret[1] = \Text\Caret 
          ; \Text\Count = CountString(\Text\String.s, #LF$)
          \Text\Change =- 1 ; - 1 post event change widget
        EndIf
        
        SelectElement(\Items(), \index[2]) 
        Repaint = 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Cut(*This._s_widget)
    ProcedureReturn Paste(*This._s_widget, "")
  EndProcedure
  
  Procedure.s Wrap (Text.s, Width.i, Mode.i=-1, nl$=#LF$, DelimList$=" "+Chr(9))
    Protected.i CountString, i, start, ii, found, length
    Protected line$, ret$="", LineRet$=""
    
    ;     Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CR$, #LF$)
    ;     Text.s + #LF$
    ;     
    CountString = CountString(Text.s, #LF$) 
    
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
      
      ret$ + LineRet$ + line$ + #CR$ + nl$
      LineRet$=""
    Next
    
    If Width > 1
      ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
    EndIf
  EndProcedure
  
  ;-
  Procedure AddLine(*This._s_widget, Line.i, String.s) ;,Image.i=-1,Sublevel.i=0)
    Protected Image_Y, Image_X, Text_X, Text_Y, Height, Width, Indent = 4
    
    Macro _set_content_Y_(_this_)
      If _this_\Image\handle
        If _this_\Flag\InLine
          Text_Y=((Height-(_this_\Text\Height*_this_\Text\Count))/2)
          Image_Y=((Height-_this_\Image\Height)/2)
        Else
          If _this_\Text\Align\Bottom
            Text_Y=((Height-_this_\Image\Height-(_this_\Text\Height*_this_\Text\Count))/2)-Indent/2
            Image_Y=(Height-_this_\Image\Height+(_this_\Text\Height*_this_\Text\Count))/2+Indent/2
          Else
            Text_Y=((Height-(_this_\Text\Height*_this_\Text\Count)+_this_\Image\Height)/2)+Indent/2
            Image_Y=(Height-(_this_\Text\Height*_this_\Text\Count)-_this_\Image\Height)/2-Indent/2
          EndIf
        EndIf
      Else
        If _this_\Text\Align\Bottom
          Text_Y=(Height-(_this_\Text\Height*_this_\Text\Count)-Text_Y-Image_Y) 
        ElseIf _this_\Text\Align\Vertical
          Text_Y=((Height-(_this_\Text\Height*_this_\Text\Count))/2)
        EndIf
      EndIf
    EndMacro
    
    Macro _set_content_X_(_this_)
      If _this_\Image\handle
        If _this_\Flag\InLine
          If _this_\Text\Align\Right
            Text_X=((Width-_this_\Image\Width-_this_\Items()\Text\Width)/2)-Indent/2
            Image_X=(Width-_this_\Image\Width+_this_\Items()\Text\Width)/2+Indent
          Else
            Text_X=((Width-_this_\Items()\Text\Width+_this_\Image\Width)/2)+Indent
            Image_X=(Width-_this_\Items()\Text\Width-_this_\Image\Width)/2-Indent
          EndIf
        Else
          Image_X=(Width-_this_\Image\Width)/2 
          Text_X=(Width-_this_\Items()\Text\Width)/2 
        EndIf
      Else
        If _this_\Text\Align\Right
          Text_X=(Width-_this_\Items()\Text\Width)
        ElseIf _this_\Text\Align\Horizontal
          Text_X=(Width-_this_\Items()\Text\Width-Bool(_this_\Items()\Text\Width % 2))/2 
        Else
          Text_X=_this_\sci\margin\width
        EndIf
      EndIf
    EndMacro
    
    Macro _line_resize_X_(_this_)
      _this_\Items()\x = _this_\X[2]+_this_\Text\X
      _this_\Items()\Width = Width
      _this_\Items()\Text\x = _this_\Items()\x+Text_X
      
      _this_\Image\X = _this_\X[2]+_this_\Text\X+Image_X
      _this_\Items()\Image\X = _this_\Items()\x+Image_X-4
    EndMacro
    
    Macro _line_resize_Y_(_this_)
      _this_\Items()\y = _this_\Y[1]+_this_\Text\Y+_this_\Scroll\Height+Text_Y
      _this_\Items()\Height = _this_\Text\Height - Bool(_this_\Text\Count<>1 And _this_\Flag\GridLines)
      _this_\Items()\Text\y = _this_\Items()\y + (_this_\Text\Height-_this_\Text\Height[1])/2 - Bool(#PB_Compiler_OS <> #PB_OS_MacOS And _this_\Text\Count<>1)
      _this_\Items()\Text\Height = _this_\Text\Height[1]
      
      _this_\Image\Y = _this_\Y[1]+_this_\Text\Y+Image_Y
      _this_\Items()\Image\Y = _this_\Items()\y + (_this_\Text\Height-_this_\Items()\Image\Height)/2 + Image_Y
    EndMacro
    
    Macro _set_line_pos_(_this_)
      _this_\Items()\Text\Pos = _this_\Text\Pos - Bool(_this_\Text\MultiLine = 1)*_this_\Items()\index ; wordwrap
      _this_\Items()\Text\Len = Len(_this_\Items()\Text\String.s)
      _this_\Text\Pos + _this_\Items()\Text\Len + 1 ; Len(#LF$)
    EndMacro
    
    
    With *This
      \Text\Count = ListSize(\Items())
      
      If \Text\Vertical
        Width = \Height[1]-\Text\X*2 
        Height = \Width[1]-\Text\y*2
      Else
        CompilerIf Not Defined(Scroll, #PB_Module)
          \Scroll\Width[2] = \width[2]-\sci\margin\width
          \Scroll\Height[2] = \height[2]
        CompilerEndIf
      EndIf
      
      width = \Scroll\width[2]
      height = \Scroll\height[2]
      
      \Items()\Index[1] =- 1
      \Items()\Focus =- 1
      \Items()\Index = Line
      \Items()\Radius = \Radius
      \Items()\Text\String.s = String.s
      
      ; Set line default color state           
      \Items()\Color\State = 1
      
      ; Update line pos in the text
      _set_line_pos_(*This)
      
      _set_content_X_(*This)
      _line_resize_X_(*This)
      _line_resize_Y_(*This)
      
      ;       ; Is visible lines
      ;       \Items()\Hide = Bool(Not Bool(\Items()\y>=\y[2] And (\Items()\y-\y[2])+\Items()\height=<\height[2]))
      
      ; Scroll width length
      _set_scroll_width_(*This)
      
      ; Scroll hight length
      _set_scroll_height_(*This)
      
      
      If \Index[2] = ListIndex(\Items())
        ;Debug " string "+String.s
        \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret) : \Items()\Text[1]\Change = #True
        \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Text\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
      EndIf
    EndWith
    
    ProcedureReturn Line
  EndProcedure
  
  Procedure.i MultiLine(*This._s_widget)
    Protected Repaint, String.s, text_width
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    With *This
      If \Text\Vertical
        Width = \Height[2]-\Text\X*2
        Height = \Width[2]-\Text\y*2
      Else
        width = \Scroll\width[2]-\Text\X*2-\sci\margin\width
        height = \Scroll\height[2]
      EndIf
      
      ; Debug ""+\Scroll\Width[2] +" "+ \Width[0] +" "+ \Width[1] +" "+ \Width[2] +" "+ Width
      ;Debug ""+\Scroll\Width[2] +" "+ \Scroll\Height[2] +" "+ \Width[2] +" "+ \Height[2] +" "+ Width +" "+ Height
      
      If \Text\MultiLine > 0
        String.s = Wrap(\Text\String.s, Width, \Text\MultiLine)
      Else
        String.s = \Text\String.s
      EndIf
      
      \Text\Pos = 0
      
      If \Text\String.s[2] <> String.s Or \Text\Vertical
        \Text\String.s[2] = String.s
        \Text\Count = CountString(String.s, #LF$)
        
        ; Scroll width reset 
        \Scroll\Width = 0
        _set_content_Y_(*This)
        
        ; 
        If ListSize(\Items()) 
          Protected Left = Move(*This, Width)
        EndIf
        
        If \Text\Count[1] <> \Text\Count 
          \Text\Count[1] = \Text\Count
          
          ; Scroll hight reset 
          \Scroll\Height = 0
          ClearList(\Items())
          
          
            Protected *Sta.Character = @\Text\String.s[2], *End.Character = @\Text\String.s[2] : #SOC = SizeOf (Character)
            Protected time = ElapsedMilliseconds()
;              ClearDebugOutput()
;             
;              Debug \Text\String.s
;              Debug "--------------------"
;             Debug \Text\String.s[2]
;             
;             Debug CountString(\Text\String.s, #CR$)
;             Debug CountString(\Text\String.s[2], #CR$)
;             Debug CountString(\Text\String.s, #LF$)
;             Debug CountString(\Text\String.s[2], #LF$)
;             
           
; ; ; ;             For IT = 1 To \Text\Count
; ; ; ;               String = StringField(\Text\String.s[2], IT, #LF$)
; ; ;             
; ; ;            ; Repeat : *End + #SOC : If *End\c = #LF Or Not *End\c : String = PeekS (*Sta, (*End-*Sta)/#SOC)
; ; ;             ; Repeat : *End + #SOC : If *End\c = #LF : String = PeekS (*Sta, (*End-*Sta)/#SOC)
           While *End\c : If *End\c = #LF : String = PeekS (*Sta, (*End-*Sta)/#SOC) ; 300
                
; ;           If CreateRegularExpression(0, ~".*\n?")
; ;            ; If CreateRegularExpression(0, ~"^.*", #PB_RegularExpression_MultiLine)
; ;               If ExamineRegularExpression(0, \Text\String.s[2])
; ;                 While NextRegularExpressionMatch(0)  ; 239
; ;                   String.s = Trim(RegularExpressionMatchString(0), #LF$)
                 
                
                  If AddElement(\Items())
                    If \Type = #PB_GadgetType_Button
                      \Items()\Text\Width = TextWidth(RTrim(String.s))
                    Else
                      \Items()\Text\Width = TextWidth(String.s)
                    EndIf
                    
                    \Items()\Focus =- 1
                    \Items()\Index[1] =- 1
                    \Items()\Color\State = 1 ; Set line default colors
                    \Items()\Radius = \Radius
                    \Items()\Text\String.s = String.s
                    \Items()\Index = ListIndex(\Items())
                    
                    ; Update line pos in the text
                    _set_line_pos_(*This)
                   
                     ; Debug "f - "+String.s +" "+ CountString(String, #CR$) +" "+ CountString(String, #LF$) +" - "+ \Items()\Text\Pos +" "+ \Items()\Text\Len
                    
                    _set_content_X_(*This)
                    _line_resize_X_(*This)
                    _line_resize_Y_(*This)
                    
                    ; Scroll width length
                    _set_scroll_width_(*This)
                    
                    ; Scroll hight length
                    _set_scroll_height_(*This)
                    
                    ;                     If \Index[2] = ListIndex(\Items())
                    ;                       ;Debug " string "+String.s
                    ;                       \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret) : \Items()\Text[1]\Change = #True
                    ;                       \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Text\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
                    ;                     EndIf
                  EndIf
                  
; ;                 Wend
; ;               EndIf
; ;               
; ;               FreeRegularExpression(0)
; ;             Else
; ;               Debug RegularExpressionError()
; ;             EndIf
               
                  
; ; ; ;              ; *Sta = *End + #SOC : EndIf : Until Not *End\c 
            *Sta = *End + #SOC : EndIf : *End + #SOC : Wend
; ; ; ;             
; ; ; ; ;             Next
           
          ;  MessageRequester("", Str(ElapsedMilliseconds()-time) + " text parse time ")
           Debug Str(ElapsedMilliseconds()-time) + " text parse time "
          
        Else
          Protected time2 = ElapsedMilliseconds()
          
          ; If CreateRegularExpression(0, ~".*\n?\r?")
          If CreateRegularExpression(0, ~".*\n?")
            ; If CreateRegularExpression(0, ~"^.*", #PB_RegularExpression_MultiLine)
                If ExamineRegularExpression(0, \Text\String.s[2])
                While NextRegularExpressionMatch(0)
                  String.s = Trim(RegularExpressionMatchString(0), #LF$)
                  
                  ;         Debug "    Position: " + Str(RegularExpressionMatchPosition(0))
                  ;         Debug "    Length: " + Str(RegularExpressionMatchLength(0))
                  IT+1
                  If SelectElement(\Items(), IT-1)
                    If \Items()\Text\String.s <> String.s Or \Items()\Text\Change
                      \Items()\Text\String.s = String.s
                      
                      If \Type = #PB_GadgetType_Button
                        \Items()\Text\Width = TextWidth(RTrim(String.s))
                      Else
                        \Items()\Text\Width = TextWidth(String.s)
                      EndIf
                    EndIf
                    
                    ; Update line pos in the text
                    _set_line_pos_(*This)
                    
                    ; Resize item
                    If (Left And Not  Bool(\Scroll\X = Left))
                      _set_content_X_(*This)
                    EndIf
                    
                    _line_resize_X_(*This)
                    
                    ; Set scroll width length
                    _set_scroll_width_(*This)
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
        \Scroll\Height = 0
        _set_content_Y_(*This)
        
        ForEach \Items()
          If Not \Items()\Hide
            _set_content_X_(*This)
            _line_resize_X_(*This)
            _line_resize_Y_(*This)
            
            ; Scroll hight length
            _set_scroll_height_(*This)
          EndIf
        Next
      EndIf
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  ;- - DRAWINGs
  Procedure CheckBox(X,Y, Width, Height, Type, Checked, Color, BackColor, Radius, Alpha=255) 
    Protected I, checkbox_backcolor
    
    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    If Checked
      BackColor = $F67905&$FFFFFF|255<<24
      BackColor($FFB775&$FFFFFF|255<<24) 
      FrontColor($F67905&$FFFFFF|255<<24)
    Else
      BackColor = $7E7E7E&$FFFFFF|255<<24
      BackColor($FFFFFF&$FFFFFF|255<<24)
      FrontColor($EEEEEE&$FFFFFF|255<<24)
    EndIf
    
    LinearGradient(X,Y, X, (Y+Height))
    RoundBox(X,Y,Width,Height, Radius,Radius)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
    
    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
    RoundBox(X,Y,Width,Height, Radius,Radius, BackColor)
    
    If Checked
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      If Type = 1
        Circle(x+5,y+5,2,Color&$FFFFFF|alpha<<24)
      ElseIf Type = 3
        For i = 0 To 1
          LineXY((X+2),(i+Y+6),(X+3),(i+Y+7),Color&$FFFFFF|alpha<<24) ; Левая линия
          LineXY((X+7+i),(Y+2),(X+4+i),(Y+8),Color&$FFFFFF|alpha<<24) ; правая линия
                                                                      ;           LineXY((X+1),(i+Y+5),(X+3),(i+Y+7),Color&$FFFFFF|alpha<<24) ; Левая линия
                                                                      ;           LineXY((X+8+i),(Y+3),(X+3+i),(Y+8),Color&$FFFFFF|alpha<<24) ; правая линия
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure Selection(X, Y, SourceColor, TargetColor)
    Protected Color, Dot.b=4, line.b = 10, Length.b = (Line+Dot*2+1)
    Static Len.b
    
    If ((Len%Length)<line Or (Len%Length)=(line+Dot))
      If (Len>(Line+Dot)) : Len=0 : EndIf
      Color = SourceColor
    Else
      Color = TargetColor
    EndIf
    
    Len+1
    ProcedureReturn Color
  EndProcedure
  
  Procedure.i Draw(*This._s_widget)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    Protected angle.f
    
    If Not *This\Hide
      
      With *This
        If \Text\FontID 
          DrawingFont(\Text\FontID) 
        EndIf
        
        
        If \Text\Change And \sci\margin\width ; = 1 Or \Text\Change
          \Text\Count = CountString(\Text\String.s, #LF$)
          \sci\margin\width = TextWidth(Str(\Text\Count))+11
         ;  Scroll::Resizes(\Scroll, \x[2]+\sci\margin\width+1,\Y[2],\Width[2]-\sci\margin\width-1,\Height[2])
         EndIf
        
        
        ; Then changed text
        If \Text\Change
          \Text\Height[1] = TextHeight("A") + Bool(\Text\Count<>1 And \Flag\GridLines)
          If \Type = #PB_GadgetType_Tree
            \Text\Height = 20
          Else
            \Text\Height = \Text\Height[1]
          EndIf
          \Text\Width = TextWidth(\Text\String.s)
        EndIf
        
        ; Then resized widget
        If \Resize
          ; Посылаем сообщение об изменении размера 
          PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_Resize, \Resize)
          CompilerIf Defined(Scroll, #PB_Module)
            ;  Scroll::Resizes(\Scroll, \x[2]+\sci\margin\width,\Y[2],\Width[2]-\sci\margin\width,\Height[2])
            Scroll::Resizes(\Scroll, \x[2],\Y[2],\Width[2],\Height[2])
          CompilerElse
            \Scroll\Width[2] = \width[2]
            \Scroll\Height[2] = \height[2]
          CompilerEndIf
        EndIf
        
        ; Widget inner coordinate
        iX=\X[2]
        iY=\Y[2]
        iwidth = \Scroll\width[2]
        iheight = \Scroll\height[2]
        
        ; Make output multi line text
        If (\Text\Change Or \Resize)
          MultiLine(*This)
          
          ;This is for the caret and scroll when entering the key - (enter & beckspace)
          If \Text\Change And \index[2] >= 0 And \index[2] < ListSize(\Items())
            SelectElement(\Items(), \index[2])
            
            CompilerIf Defined(Scroll, #PB_Module)
              If \Scroll\v And \Scroll\v\max <> \Scroll\Height And 
                 Scroll::SetAttribute(\Scroll\v, #__bar_Maximum, \Scroll\Height - Bool(\Flag\GridLines)) 
                
                \Scroll\v\Page\ScrollStep = \Text\Height
                
                If \Text\editable And (\Items()\y >= (\Scroll\height[2]-\Items()\height))
                  ; This is for the editor widget when you enter the key - (enter & backspace)
                  Scroll::SetState(\Scroll\v, (\Items()\y-((\Scroll\height[2]+\Text\y)-\Items()\height)))
                EndIf
                
                Scroll::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                
                If \Scroll\v\Hide 
                  \Scroll\width[2] = \Width[2]
                  \Items()\Width = \Scroll\width[2]
                  iwidth = \Scroll\width[2]
                  
                  ;  Debug ""+\Scroll\v\Hide +" "+ \Scroll\Height
                EndIf
              EndIf
              
              If \Scroll\h And \Scroll\h\Max<>\Scroll\Width And 
                 Scroll::SetAttribute(\Scroll\h, #__bar_Maximum, \Scroll\Width)
                Scroll::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
              ;  \Scroll\Width[2] = \width[2] - Bool(Not \Scroll\v\Hide)*\Scroll\v\Width : iwidth = \Scroll\width[2]
              EndIf
              
              
              ; При вводе текста перемещать ползунок
              If \Canvas\input And \Items()\text\x+\Items()\text\width > \Items()\X+\Items()\width
                Debug ""+\Scroll\h\Max +" "+ Str(\Items()\text\x+\Items()\text\width)
                
                If \Scroll\h\Max = (\Items()\text\x+\Items()\text\width)
                  Scroll::SetState(\Scroll\h, \Scroll\h\Max)
                Else
                  Scroll::SetState(\Scroll\h, \Scroll\h\Page\Pos + TextWidth(Chr(\Canvas\input)))
                EndIf
              EndIf
              
            CompilerEndIf
          EndIf
        EndIf 
        
        _clip_output_(*This, \X,\Y,\Width,\Height)
        
        ;
        If \Text\Editable And ListSize(\Items())
          If \Text\Change =- 1
            \Text[1]\Change = 1
            \Text[3]\Change = 1
            \Text\Len = Len(\Text\String.s)
            Change(*This, \Text\Caret, 0)
            
            ; Посылаем сообщение об изменении содержимого 
            PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_Change)
          EndIf
          
          ; Caaret pos & len
          If \Items()\Text[1]\Change : \Items()\Text[1]\Change = #False
            \Items()\Text[1]\Width = TextWidth(\Items()\Text[1]\String.s)
            
            ; demo
            ;             Protected caret1, caret = \Text\Caret[2]
            
            ; Положение карета
            If \Text\Caret[1] = \Text\Caret
              \Text\Caret[2] = \Items()\Text[1]\Width
              ;               caret1 = \Text\Caret[2]
            EndIf
            
            ; Если перешли за границы итемов
            If \index[1] =- 1
              \Text\Caret[2] = 0
            ElseIf \index[1] = ListSize(\Items())
              \Text\Caret[2] = \Items()\Text\Width
            ElseIf \Items()\Text\Len = \Items()\Text[2]\Len
              \Text\Caret[2] = \Items()\Text\Width
            EndIf
            
            ;             If Caret<>\Text\Caret[2]
            ;               Debug "Caret change " + caret +" "+ caret1 +" "+ \Text\Caret[2] +" "+\index[1] +" "+\index[2]
            ;               caret = \Text\Caret[2]
            ;             EndIf
            
          EndIf
          
          If \Items()\Text[2]\Change : \Items()\Text[2]\Change = #False 
            \Items()\Text[2]\X = \Items()\Text\X+\Items()\Text[1]\Width
            \Items()\Text[2]\Width = TextWidth(\Items()\Text[2]\String.s) ; + Bool(\Items()\Text[2]\Len =- 1) * \Flag\FullSelection ; TextWidth() - bug in mac os
            
            \Items()\Text[3]\X = \Items()\Text[2]\X+\Items()\Text[2]\Width
          EndIf 
          
          If \Items()\Text[3]\Change : \Items()\Text[3]\Change = #False 
            \Items()\Text[3]\Width = TextWidth(\Items()\Text[3]\String.s)
          EndIf 
          
          If (\Focus = *This And \Canvas\Mouse\Buttons And (Not \Scroll\v\at And Not \Scroll\h\at)) 
            Protected Left = Move(*This, \Items()\Width)
          EndIf
        EndIf
        
        ; Draw back color
        If \Color\Fore[\Color\State]
          DrawingMode(#PB_2DDrawing_Gradient)
          BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
        Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Back[\Color\State])
        EndIf
        
        ; Draw margin back color
        If \sci\margin\width
          DrawingMode(#PB_2DDrawing_Default)
          Box(ix, iy, \sci\margin\width, \Height[2], \sci\margin\Color\Back); $C8D7D7D7)
        EndIf
      EndWith 
      
      ; Draw Lines text
      With *This\Items()
        If ListSize(*This\Items())
          PushListPosition(*This\Items())
          ForEach *This\Items()
            ; Is visible lines ---
            Drawing = Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight)
            ;\Hide = Bool(Not Drawing)
            
            If \hide
              Drawing = 0
            EndIf
            
            If Drawing
              If \Text\FontID 
                DrawingFont(\Text\FontID) 
                ;               ElseIf *This\Text\FontID 
                ;                 DrawingFont(*This\Text\FontID) 
              EndIf
              _clip_output_(*This, *This\X[2], #PB_Ignore, *This\Width[2], #PB_Ignore) 
              
              If \Text\Change : \Text\Change = #False
                \Text\Width = TextWidth(\Text\String.s) 
                
                If \Text\FontID 
                  \Text\Height = TextHeight("A") 
                Else
                  \Text\Height = *This\Text\Height[1]
                EndIf
              EndIf 
              
              If \Text[1]\Change : \Text[1]\Change = #False
                \Text[1]\Width = TextWidth(\Text[1]\String.s) 
              EndIf 
              
              If \Text[3]\Change : \Text[3]\Change = #False 
                \Text[3]\Width = TextWidth(\Text[3]\String.s)
              EndIf 
              
              If \Text[2]\Change : \Text[2]\Change = #False 
                \Text[2]\X = \Text\X+\Text[1]\Width
                ; Debug "get caret "+\Text[3]\Len
                \Text[2]\Width = TextWidth(\Text[2]\String.s) + Bool(\Text\Len = \Text[2]\Len Or \Text[2]\Len =- 1 Or \Text[3]\Len = 0) * *This\Flag\FullSelection ; TextWidth() - bug in mac os
                \Text[3]\X = \Text[2]\X+\Text[2]\Width
              EndIf 
            EndIf
            
            
            If \change = 1 : \change = 0
              Protected indent = 8 + Bool(*This\Image\width)*4
              ; Draw coordinates 
              \sublevellen = *This\Text\X + (7 - *This\sublevellen) + ((\sublevel + Bool(*This\flag\buttons)) * *This\sublevellen) + Bool(*This\Flag\CheckBoxes)*17
              \Image\X + \sublevellen + indent
              \Text\X + \sublevellen + *This\Image\width + indent
              
              ; Scroll width length
              _set_scroll_width_(*This)
            EndIf
            
            Height = \Height
            Y = \Y+*This\Scroll\Y
            Text_X = \Text\X+*This\Scroll\X
            Text_Y = \Text\Y+*This\Scroll\Y
            ; Debug Text_X
            
            ; expanded & collapsed box
            _set_open_box_XY_(*This, *This\Items(), *This\x+*This\Scroll\X, Y)
            
            ; checked box
            _set_check_box_XY_(*This, *This\Items(), *This\x+*This\Scroll\X, Y)
            
            ; Draw selections
            If Drawing And (\Index=*This\Index[1] Or \Index=\focus Or \Index=\Index[1]) ; \Color\State;
              If *This\Row\Color\Back[\Color\State]<>-1                                 ; no draw transparent
                If *This\Row\Color\Fore[\Color\State]
                  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                  BoxGradient(\Vertical,*This\X[2],Y,iwidth,\Height,RowForeColor(*This, \Color\State) ,RowBackColor(*This, \Color\State) ,\Radius)
                Else
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  RoundBox(*This\X[2],Y,iwidth,\Height,\Radius,\Radius,RowBackColor(*This, \Color\State) )
                EndIf
              EndIf
              
              If *This\Row\Color\Frame[\Color\State]<>-1 ; no draw transparent
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(*This\x[2],Y,iwidth,\height,\Radius,\Radius, RowFrameColor(*This, \Color\State) )
              EndIf
            EndIf
            
            ; Draw plot
            ;_draw_plots_(*This, *This\Items(), *This\x+*This\Scroll\X, \box\y+\box\height/2)
            
            If Drawing
              ; Draw boxes
              If *This\flag\buttons And \childrens
                DrawingMode(#PB_2DDrawing_Default)
                CompilerIf Defined(Scroll, #PB_Module)
                  Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, RowFontColor(*This, \Color\State), 0,0) 
                CompilerEndIf
              EndIf
              
              ; Draw checkbox
              If *This\Flag\CheckBoxes
                DrawingMode(#PB_2DDrawing_Default)
                CheckBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, $FFFFFFFF, $FF7E7E7E, 2, 255)
              EndIf
              
              ; Draw image
              If \Image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Image\handle, \Image\x+*This\Scroll\X, \Image\y+*This\Scroll\Y, *This\row\color\alpha)
              EndIf
              
              ; Draw text
              _clip_output_(*This, \X-1, #PB_Ignore, \Width+2, #PB_Ignore) 
              ; _clip_output_(*This, *This\X[2], #PB_Ignore, *This\Scroll\Width[2], #PB_Ignore) 
              
              Angle = Bool(\Text\Vertical)**This\Text\Rotate
              Protected Front_BackColor_1 = RowFontColor(*This, *This\Color\State) ; *This\Color\Front[*This\Color\State]&$FFFFFFFF|*This\row\color\alpha<<24
              Protected Front_BackColor_2 = RowFontColor(*This, 2)                 ; *This\Color\Front[2]&$FFFFFFFF|*This\row\color\alpha<<24
              
              ; Draw string
              If \Text[2]\Len And *This\Color\Front <> *This\Row\Color\Front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*This\Text\Caret[1] > *This\Text\Caret And *This\Index[2] = *This\Index[1]) Or
                     (\Index = *This\Index[1] And *This\Index[2] > *This\Index[1])
                    \Text[3]\X = \Text\X+TextWidth(Left(\Text\String.s, *This\Text\Caret[1])) 
                    
                    If *This\Index[2] = *This\Index[1]
                      \Text[2]\X = \Text[3]\X-\Text[2]\Width
                    EndIf
                    
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\Text[3]\X+*This\Scroll\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
                    EndIf
                    
                    If *This\Row\Color\Fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      BoxGradient(\Vertical,\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2) )
                    EndIf
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s+\Text[2]\String.s, angle, Front_BackColor_2)
                    EndIf
                    
                    If \Text[1]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, angle, Front_BackColor_1)
                    EndIf
                  Else
                    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                    DrawRotatedText(Text_X, Text_Y, \Text\String.s, angle, Front_BackColor_1)
                    
                    If *This\Row\Color\Fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      BoxGradient(\Vertical,\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
                    EndIf
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\Text[2]\X+*This\Scroll\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
                    EndIf
                  EndIf
                CompilerElse
                  If \Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, angle, Front_BackColor_1)
                  EndIf
                  
                  If *This\Row\Color\Fore[2]
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    BoxGradient(\Vertical,\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
                  EndIf
                  
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[2]\X+*This\Scroll\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
                  EndIf
                  
                  If \Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[3]\X+*This\Scroll\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
                  EndIf
                CompilerEndIf
                
              Else
                If \Text[2]\Len
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
                EndIf
                
                If \Color\State = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_2)
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_1)
                EndIf
              EndIf
              
              ; Draw margin
              If *This\sci\margin\width
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(*This\sci\margin\width-TextWidth(Str(\Index))-3, \Y+*This\Scroll\Y, Str(\Index), *This\sci\margin\Color\Front)
              EndIf
            EndIf
          Next
          PopListPosition(*This\Items()) ; 
        EndIf
      EndWith  
      
      
      With *This
        ; Draw image
        If \Image\handle
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \color\alpha)
        EndIf
        
        ; Draw caret
        If ListSize(\Items()) And (\Text\Editable Or \Items()\Text\Editable) And \Focus = *This : DrawingMode(#PB_2DDrawing_XOr)             
          Line((\Items()\Text\X+\Scroll\X) + \Text\Caret[2] - Bool(#PB_Compiler_OS = #PB_OS_Windows) - Bool(Left < \Scroll\X), \Items()\Y+\Scroll\Y, 1, Height, $FFFFFFFF)
        EndIf
        
        UnclipOutput()
        
        ; Draw scroll bars
        CompilerIf Defined(Scroll, #PB_Module)
          ;           If \Scroll\v And \Scroll\v\Max <> \Scroll\Height And 
          ;              Scroll::SetAttribute(\Scroll\v, #__bar_Maximum, \Scroll\Height - Bool(\Flag\GridLines))
          ;             Scroll::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;           EndIf
          ;           If \Scroll\h And \Scroll\h\Max<>\Scroll\Width And 
          ;              Scroll::SetAttribute(\Scroll\h, #__bar_Maximum, \Scroll\Width)
          ;             Scroll::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;           EndIf
          
          Scroll::Draw(\Scroll\v)
          Scroll::Draw(\Scroll\h)
        CompilerEndIf
        
        _clip_output_(*This, \X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2)
        
      EndWith
      
      ; Draw frames
      With *This
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If \Focus = *This
          If \Color\State = 2
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\front[2])
            If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,\Color\front[2]) : EndIf  ; Сглаживание краев )))
          Else
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[2])
            If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,\Color\Frame[2]) : EndIf  ; Сглаживание краев )))
          EndIf
          RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,\Color\Frame[2])
        ElseIf \fSize
          Select \fSize[1] 
            Case 1 ; Flat
              RoundBox(iX-1,iY-1,iWidth+2,iHeight+2,\Radius,\Radius, $FFE1E1E1)  
              
            Case 2 ; Single
              _frame_(*This, iX,iY,iWidth,iHeight, $FFE1E1E1, $FFFFFFFF)
              
            Case 3 ; Double
              _frame_(*This, iX-1,iY-1,iWidth+2,iHeight+2, $FF888888, $FFFFFFFF)
              If \Radius : RoundBox(iX-1,iY-1-1,iWidth+2,iHeight+2+1,\Radius,\Radius,$FF888888) : EndIf  ; Сглаживание краев )))
              If \Radius : RoundBox(iX-2,iY-1-1,iWidth+3,iHeight+2+1,\Radius,\Radius,$FF888888) : EndIf  ; Сглаживание краев )))
              _frame_(*This, iX,iY,iWidth,iHeight, $FF888888, $FFE1E1E1)
              
            Case 4 ; Raised
              _frame_(*This, iX-1,iY-1,iWidth+2,iHeight+2, $FFE1E1E1, $FF9E9E9E)
              If \Radius : RoundBox(iX-1,iY-1,iWidth+3,iHeight+2+1,\Radius,\Radius,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              If \Radius : RoundBox(iX-1,iY-1,iWidth+2,iHeight+2+1,\Radius,\Radius,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              _frame_(*This, iX,iY,iWidth,iHeight, $FFFFFFFF, $FF888888)
              
            Default 
              RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[\Color\State])
              
          EndSelect
        EndIf
        
        If \Default
          ; DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawFilterCallback())
          If \Default = *This : \Default = 0
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,$FF004DFF)
            If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,$FF004DFF) : EndIf
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,$FF004DFF)
          Else
            If \Color\State = 2
              RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\front[2])
            Else
              RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[2])
            EndIf
          EndIf
        EndIf
        
        
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          ; Scroll area coordinate
          ;Box(\Scroll\x, \Scroll\y, \Scroll\width, \Scroll\height, $FFFF0000)
          ; Debug ""+\Scroll\x +" "+ \Scroll\y +" "+ \Scroll\width +" "+ \Scroll\height
          Box(\Scroll\h\x-\Scroll\h\page\pos, \Scroll\v\y-\Scroll\v\page\pos, \Scroll\h\max, \Scroll\v\max, $FFFF0000)
          
          ; page coordinate
          Box(\Scroll\h\x, \Scroll\v\y, \Scroll\h\page\len, \Scroll\v\page\len, $FF00FF00)
          
          
          
        If \Text\Change : \Text\Change = 0 : EndIf
        If \Resize : \Resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i ReDraw(*This._s_widget, Canvas =- 1, BackColor=$FFF0F0F0)
    If *This
      With *This
        If Canvas =- 1 
          Canvas = \Canvas\Gadget 
        ElseIf Canvas <> \Canvas\Gadget
          ProcedureReturn 0
        EndIf
        
        If StartDrawing(CanvasOutput(Canvas))
          Draw(*This)
          StopDrawing()
        EndIf
      EndWith
    Else
      If IsGadget(Canvas) And StartDrawing(CanvasOutput(Canvas))
        DrawingMode(#PB_2DDrawing_Default)
        Box(0,0,OutputWidth(),OutputHeight(), BackColor)
        
        With List()\Widget
          ForEach List()
            If Canvas = \Canvas\Gadget
              Draw(List()\Widget)
            EndIf
          Next
        EndWith
        
        StopDrawing()
      EndIf
    EndIf
  EndProcedure
  
  ;-
  ;- - KEYBOARDs
  Procedure.i ToUp(*This._s_widget)
    Protected Repaint
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *This
      If (\Index[2] > 0 And \Index[1] = \Index[2]) : \Index[2] - 1 : \Index[1] = \Index[2]
        SelectElement(\Items(), \Index[2])
        ;If (\Items()\y+\Scroll\Y =< \Y[2])
        Scroll::SetState(\Scroll\v, (\Items()\y-((\Scroll\height[2]+\Text\y)-\Items()\height)))
        ;EndIf
        ; При вводе перемещаем текста
        If \Items()\text\x+\Items()\text\width > \Items()\X+\Items()\width
          Scroll::SetState(\Scroll\h, (\Items()\text\x+\Items()\text\width))
        Else
          Scroll::SetState(\Scroll\h, 0)
        EndIf
        ;Change(*This, \Text\Caret, 0)
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToDown(*This._s_widget)
    Static Line
    Protected Repaint, Shift.i = Bool(*This\Canvas\Key[1] & #PB_Canvas_Shift)
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *This
      If Shift
        
        If \Index[1] = \Index[2]
          SelectElement(\Items(), \Index[1]) 
          Change(*This, \Text\Caret[1], \Items()\Text\Len-\Text\Caret[1])
        Else
          SelectElement(\Items(), \Index[2]) 
          Change(*This, 0, \Items()\Text\Len)
        EndIf
        ; Debug \Text\Caret[1]
        \Index[2] + 1
        ;         \Text\Caret = Caret(*This, \Index[2]) 
        ;         \Text\Caret[1] = \Text\Caret
        SelectElement(\Items(), \Index[2]) 
        Change(*This, 0, \Text\Caret[1]) 
        SelectionText(*This)
        Repaint = 1 
        
      Else
        If (\Index[1] < ListSize(\Items()) - 1 And \Index[1] = \Index[2]) : \Index[2] + 1 : \Index[1] = \Index[2]
          SelectElement(\Items(), \Index[2]) 
          ;If (\Items()\y >= (\Scroll\height[2]-\Items()\height))
          Scroll::SetState(\Scroll\v, (\Items()\y-((\Scroll\height[2]+\Text\y)-\Items()\height)))
          ;EndIf
          
          If \Items()\text\x+\Items()\text\width > \Items()\X+\Items()\width
            Scroll::SetState(\Scroll\h, (\Items()\text\x+\Items()\text\width))
          Else
            Scroll::SetState(\Scroll\h, 0)
          EndIf
          
          ;Change(*This, \Text\Caret, 0)
          Repaint =- 1 
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToLeft(*This._s_widget) ; Ok
    Protected Repaint.i, Shift.i = Bool(*This\Canvas\Key[1] & #PB_Canvas_Shift)
    
    With *This
      If \Items()\Text[2]\Len And Not Shift
        If \Index[2] > \Index[1] 
          Swap \Index[2], \Index[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
        ElseIf \Index[1] > \Index[2] And 
               \Text\Caret[1] > \Text\Caret
          Swap \Text\Caret[1], \Text\Caret
        ElseIf \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf
        
        If \Index[1] <> \Index[2]
          SelReset(*This)
          \Index[1] = \Index[2]
        Else
          \Text\Caret[1] = \Text\Caret 
        EndIf 
        Repaint =- 1
        
      ElseIf \Text\Caret > 0
        If \Text\Caret > \Items()\text\len - CountString(\Items()\Text\String.s, #CR$) ; Без нее удаляеть последнюю строку 
          \Text\Caret = \Items()\text\len - CountString(\Items()\Text\String.s, #CR$)  ; Без нее удаляеть последнюю строку 
        EndIf
        \Text\Caret - 1 
        
        If Not Shift
          \Text\Caret[1] = \Text\Caret 
        EndIf
        
        Repaint =- 1 
        
      ElseIf ToUp(*This._s_widget)
        \Text\Caret = \Items()\Text\Len
        \Text\Caret[1] = \Text\Caret
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToRight(*This._s_widget) ; Ok
    Protected Repaint.i, Shift.i = Bool(*This\Canvas\Key[1] & #PB_Canvas_Shift)
    
    With *This
      ;       If \Index[1] <> \Index[2]
      ;         If Shift 
      ;           \Text\Caret + 1
      ;           Swap \Index[2], \Index[1] 
      ;         Else
      ;           If \Index[1] > \Index[2] 
      ;             Swap \Index[1], \Index[2] 
      ;             Swap \Text\Caret, \Text\Caret[1]
      ;             
      ;             If SelectElement(\Items(), \Index[2]) 
      ;               \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
      ;               \Items()\Text[1]\Change = #True
      ;             EndIf
      ;             
      ;             SelReset(*This)
      ;             \Text\Caret = \Text\Caret[1] 
      ;             \Index[1] = \Index[2]
      ;           EndIf
      ;           
      ;         EndIf
      ;         Repaint =- 1
      ;         
      ;       ElseIf \Items()\Text[2]\Len
      ;         If \Text\Caret[1] > \Text\Caret 
      ;           Swap \Text\Caret[1], \Text\Caret 
      ;         EndIf
      ;         
      ;         If Not Shift
      ;           \Text\Caret[1] = \Text\Caret 
      ;         Else
      ;           \Text\Caret + 1
      ;         EndIf
      ;         
      ;         Repaint =- 1
      If \Items()\Text[2]\Len And Not Shift
        If \Index[1] > \Index[2] 
          Swap \Index[1], \Index[2] 
          Swap \Text\Caret, \Text\Caret[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
          
          ;           SelReset(*This)
          ;           \Text\Caret = \Text\Caret[1] 
          ;           \Index[1] = \Index[2]
        EndIf
        
        If \Index[1] <> \Index[2]
          SelReset(*This)
          \Index[1] = \Index[2]
        Else
          \Text\Caret = \Text\Caret[1] 
        EndIf 
        Repaint =- 1
        
        
      ElseIf \Text\Caret < \Items()\Text\Len - CountString(\Items()\Text\String.s, #CR$) ; Без нее удаляеть последнюю строку
        \Text\Caret + 1
        
        If Not Shift
          \Text\Caret[1] = \Text\Caret 
        EndIf
        
        Repaint =- 1 
      ElseIf ToDown(*This)
        \Text\Caret = 0
        \Text\Caret[1] = \Text\Caret
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToInput(*This._s_widget)
    Protected Repaint
    
    With *This
      If \Canvas\Input
        Repaint = Insert(*This, Chr(\Canvas\Input))
        
        If Not Repaint
          \Default = *This
        EndIf
        
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToReturn(*This._s_widget) ; Ok
    
    With  *This
      If Not Paste(*This, #LF$)
        \Index[2] + 1
        \Text\Caret = 0
        \Index[1] = \Index[2]
        \Text\Caret[1] = \Text\Caret
        \Text\Change =- 1 ; - 1 post event change widget
      EndIf
    EndWith
    
    ProcedureReturn #True
  EndProcedure
  
  Procedure.i ToBack(*This._s_widget)
    Protected Repaint, String.s, Cut.i
    
    If *This\Canvas\Input : *This\Canvas\Input = 0
      ToInput(*This) ; Сбросить Dot&Minus
    EndIf
    *This\Canvas\Input = 65535
    
    With *This 
      If Not Cut(*This)
        If \Items()\Text[2]\Len
          
          If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text\String.s = \Text[1]\String + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
          
        ElseIf \Text\Caret[1] > 0 : \Text\Caret - 1 
          \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret)
          \Items()\Text[1]\len = Len(\Items()\Text[1]\String.s) : \Items()\Text[1]\Change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text\String.s = Left(\Text\String.s, \Items()\Text\Pos+\Text\Caret) + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
        Else
          ; Если дошли до начала строки то 
          ; переходим в конец предыдущего итема
          If \Index[2] > 0 
            \Text\String.s = RemoveString(\Text\String.s, #LF$, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
            
            ToUp(*This)
            
            \Text\Caret = \Items()\Text\Len - CountString(\Items()\Text\String.s, #CR$)
            \Text\Change =- 1 ; - 1 post event change widget
          EndIf
          
        EndIf
      EndIf
      
      If \Text\Change
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToDelete(*This._s_widget)
    Protected Repaint, String.s
    
    With *This 
      If Not Cut(*This)
        If \Items()\Text[2]\Len
          If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text\String.s = \Text[1]\String + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
          
        ElseIf \Text\Caret[1] < \Items()\Text\Len - CountString(\Items()\Text\String.s, #CR$)
          \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len - \Text\Caret - 1)
          \Items()\Text[3]\Len = Len(\Items()\Text[3]\String.s) : \Items()\Text[3]\Change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text[3]\String = Right(\Text\String.s,  \Text\Len - (\Items()\Text\Pos + \Text\Caret) - 1)
          \Text[3]\len = Len(\Text[3]\String.s)
          
          \Text\String.s = \Text[1]\String + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
        Else
          If \Index[2] < (\Text\Count-1) ; ListSize(\Items()) - 1
            \Text\String.s = RemoveString(\Text\String.s, #LF$, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
            \Text\Change =- 1 ; - 1 post event change widget
          EndIf
        EndIf
      EndIf
      
      If \Text\Change
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToPos(*This._s_widget, Pos.i, Len.i)
    Protected Repaint
    
    With *This
      SelReset(*This)
      
      If Len
        Select Pos
          Case 1 : FirstElement(\items()) : \Text\Caret = 0
          Case - 1 : LastElement(\items()) : \Text\Caret = \items()\Text\Len
        EndSelect
        
        \index[1] = \items()\index
        Scroll::SetState(\Scroll\v, (\Items()\y-((\Scroll\height[2]+\Text\y)-\Items()\height)))
      Else
        SelectElement(\items(), \index[1]) 
        \Text\Caret = Bool(Pos =- 1) * \items()\Text\Len 
        Scroll::SetState(\Scroll\h, Bool(Pos =- 1) * \Scroll\h\Max)
      EndIf
      
      \Text\Caret[1] = \Text\Caret
      \index[2] = \index[1] 
      Repaint =- 1 
      
    EndWith
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  ;- - (SET&GET)s
  Procedure.i Text_AddLine(*This._s_widget, Line.i, Text.s)
    Protected Result.i, String.s, i.i
    
    With *This
      If (Line > \Text\Count Or Line < 0)
        Line = \Text\Count
      EndIf
      
      For i = 0 To \Text\Count
        If Line = i
          If String.s
            String.s +#LF$+ Text
          Else
            String.s + Text
          EndIf
        EndIf
        
        If String.s
          String.s +#LF$+ StringField(\Text\String.s, i + 1, #LF$) 
        Else
          String.s + StringField(\Text\String.s, i + 1, #LF$)
        EndIf
      Next : \Text\Count = i
      
      If \Text\String.s <> String.s
        \Text\String.s = String.s
        \Text\Len = Len(String.s)
        \Text\Change = 1
        Result = 1
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i AddItem(*This._s_widget, Item.i,Text.s,Image.i=-1,Flag.i=0)
    Static len
    Protected l
    
    If *This
      With *This
        If Item > 0 
          ; Debug Len(StringField(\text\string, Item, #LF$))
          ; Debug FindString(\text\string, #LF$, Item)
        EndIf
        
        \text\string = InsertString(\text\string, Text.s+#LF$, len+1)
        \Text\Count + 1
        ;\Text\Count = CountString(\text\string, #LF$)
        l = Len(Text.s) + 1
        \Text\len + l ;= Len(\text\string)
        Len + l
        \Text\change = 1
        
      EndWith
    EndIf
    
    ProcedureReturn *This\Text\Count
  EndProcedure
  
  Procedure SetAttribute(*This._s_widget, Attribute.i, Value.i)
    With *This
      
    EndWith
  EndProcedure
  
  Procedure GetAttribute(*This._s_widget, Attribute.i)
    Protected Result
    
    With *This
      ;       Select Attribute
      ;         Case #__bar_Minimum    : Result = \Scroll\min
      ;         Case #__bar_Maximum    : Result = \Scroll\max
      ;         Case #__bar_PageLength : Result = \Scroll\pageLength
      ;       EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemState(*This._s_widget, Item.i, State.i)
    Protected Result
    
    With *This
      PushListPosition(\Items())
      Result = SelectElement(\Items(), Item) 
      If Result 
        \Items()\Index[1] = \Items()\Index
        \Text\Caret = State
        \Text\Caret[1] = \Text\Caret
      EndIf
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(*This._s_widget, State.i)
    Protected String.s, *Line
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If String.s
          String.s +#LF$+ \Items()\Text\String.s 
        Else
          String.s + \Items()\Text\String.s
        EndIf
      Next : String.s+#LF$
      PopListPosition(\Items())
      
      If \Text\String.s <> String.s
        \Text\String.s = String.s
        \Text\Len = Len(String.s)
        Redraw(*This, \Canvas\Gadget)
      EndIf
      
      If State <> #PB_Ignore
        \Focus = *This
        If GetActiveGadget() <> \Canvas\Gadget
          SetActiveGadget(\Canvas\Gadget)
        EndIf
        
        PushListPosition(\Items())
        If State =- 1
          \Index[1] = \Text\Count - 1
          *Line = LastElement(\Items())
          \Text\Caret = \Items()\Text\Len
        Else
          \Index[1] = CountString(Left(String, State), #LF$)
          *Line = SelectElement(\Items(), \Index[1])
          If *Line
            \Text\Caret = State-\Items()\Text\Pos
          EndIf
        EndIf
        
        ;If *Line
        ;         \Index[2] = \Index[1]
        ;         \Text[1]\Change = 1
        ;         \Text[3]\Change = 1
        ;         Change(*This, \Text\Caret, 0)
        
        \Items()\Text[1]\String = Left(\Items()\Text\String, \Text\Caret)
        \Items()\Text[1]\Change = 1
        \Text\Caret[1] = \Text\Caret
        
        \Items()\Index[1] = \Items()\Index 
        Scroll::SetState(\Scroll\v, (\items()\y-((\Scroll\height[2]+\Text\y)-\items()\height))) ;((\Index[1] * \Text\Height)-\Scroll\v\Height) + \Text\Height)
        
        ;         If Not \Repaint : \Repaint = 1
        ;           PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
        ;         EndIf
        Redraw(*This)
        ;EndIf
        PopListPosition(\Items())
        
        ; Debug \Index[2]
        
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetState(*This._s_widget)
    Protected Result
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If \Items()\Index[1] = \Items()\Index
          Result = \Items()\Text\Pos + \Text\Caret
        EndIf
      Next
      PopListPosition(\Items())
      
      ; Debug \text[1]\len
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure ClearItems(*This._s_widget)
      *This\Text\Count = 0
    *This\Text\Change = 1 
    If *This\Text\Editable
      *This\Text\String = #LF$
    EndIf
    If Not *This\Repaint : *This\Repaint = 1
      PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
    EndIf
  ProcedureReturn 1
  EndProcedure
  
  Procedure.i CountItems(*This._s_widget)
    ProcedureReturn   *This\Text\Count
  EndProcedure
  
  Procedure.i RemoveItem(*This._s_widget, Item.i)
  *This\Text\Count - 1
    *This\Text\Change = 1
    If *This\Text\Count =- 1 
      *This\Text\Count = 0 
      *This\Text\String = #LF$
      If Not *This\Repaint : *This\Repaint = 1
        PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
      EndIf
    Else
      *This\Text\String = RemoveString(*This\Text\String, StringField(*This\Text\String, item+1, #LF$) + #LF$)
    EndIf
   EndProcedure
  
  Procedure.s GetText(*This._s_widget)
    With *This
      If \Text\Pass
        ProcedureReturn \Text\String.s[1]
      Else
        ProcedureReturn \Text\String
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Text_SetText(*This._s_widget, Text.s)
    Protected Result.i, Len.i, String.s, i.i
    If Text.s="" : Text.s=#LF$ : EndIf
    
    With *This
      If \Text\String.s <> Text.s
        \Text\String.s = Text_Make(*This, Text.s)
        
        If \Text\String.s
          \Text\String.s[1] = Text.s
          
          If \Text\MultiLine Or \Type = #PB_GadgetType_Editor Or \Type = #PB_GadgetType_Scintilla  ; Or \Type = #PB_GadgetType_ListView
            Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
            Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
            Text.s = ReplaceString(Text.s, #CR$, #LF$)
            Text.s + #LF$
            \Text\String.s = Text.s
            \Text\Count = CountString(\Text\String.s, #LF$)
          Else
            \Text\String.s = RemoveString(\Text\String.s, #LF$) + #LF$
            ; \Text\String.s = RTrim(ReplaceString(\Text\String.s, #LF$, " ")) + #LF$
          EndIf
          
          \Text\Len = Len(\Text\String.s)
          \Text\Change = #True
          Result = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetText(*This._s_widget, Text.s, Item.i=0)
    Protected i
    
    With *This
      If Text_SetText(*This, Text.s)
        If Not \Repaint : \Repaint = 1
          PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
        EndIf
        ProcedureReturn 1
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i SetFont(*This._s_widget, FontID.i)
    
    With *This
      If \Text\FontID <> FontID 
        \Text\FontID = FontID
        \Text\Change = 1
        
        If Not Bool(\Text\Count[1] And \Text\Count[1] <> \Text\Count)
          Redraw(*This, \Canvas\Gadget)
        EndIf
        ProcedureReturn 1
      EndIf
    EndWith
    
  EndProcedure
  
  ;-
  Procedure SelSet(*This._s_widget, Line.i)
    Protected Repaint.i
    
    With *This
      
      If \Index[1] <> Line And Line =< ListSize(\Items())
        If isItem(\Index[1], \Items()) 
          If \Index[1] <> ListIndex(\Items())
            SelectElement(\Items(), \Index[1]) 
          EndIf
          
          If \Index[1] > Line
            \Text\Caret = 0
          Else
            \Text\Caret = \Items()\Text\Len
          EndIf
          
          Repaint | SelectionText(*This)
        EndIf
        
        \Index[1] = Line
      EndIf
      
      If isItem(Line, \Items()) 
        \Text\Caret = Caret(*This, Line) 
        Repaint | SelectionText(*This)
      EndIf
      
      ; Выделение конца строки
      PushListPosition(\Items()) 
      ForEach \Items()
        If (\Index[1] = \Items()\Index Or \Index[2] = \Items()\Index)
          \Items()\Text[2]\Change = 1
          \Items()\Text[2]\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
                                                             ;           
        ElseIf ((\Index[2] < \Index[1] And \Index[2] < \Items()\Index And \Index[1] > \Items()\Index) Or
                (\Index[2] > \Index[1] And \Index[2] > \Items()\Index And \Index[1] < \Items()\Index)) 
          
          \Items()\Text[2]\Change = 1
          \Items()\Text[2]\String = \Items()\Text\String 
          \Items()\Text[2]\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
          Repaint = #True
          
        ElseIf \Items()\Text[2]\Len
          \Items()\Text[2]\Change = 1
          \Items()\Text[2]\String =  "" 
          \Items()\Text[2]\Len = 0 
        EndIf
      Next
      PopListPosition(\Items()) 
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Resize(*This._s_widget, X.i,Y.i,Width.i,Height.i)
    With *This
      If X<>#PB_Ignore And 
         \X[0] <> X
        \X[0] = X 
        \X[2]=\X[0]+\bSize
        \X[1]=\X[2]-\fSize
        \Resize = 1<<1
      EndIf
      If Y<>#PB_Ignore And 
         \Y[0] <> Y
        \Y[0] = Y
        \Y[2]=\Y[0]+\bSize
        \Y[1]=\Y[2]-\fSize
        \Resize = 1<<2
      EndIf
      If Width<>#PB_Ignore And
         \Width[0] <> Width 
        \Width[0] = Width 
        \Width[2] = \Width[0]-\bSize*2
        \Width[1] = \Width[2]+\fSize*2
        \Resize = 1<<3
      EndIf
      If Height<>#PB_Ignore And 
         \Height[0] <> Height
        \Height[0] = Height 
        \Height[2] = \Height[0]-\bSize*2
        \Height[1] = \Height[2]+\fSize*2
        \Resize = 1<<4
      EndIf
      
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  
  Procedure.i Editable(*This._s_widget, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s, Shift.i
    
    With *This
      Shift = Bool(*This\Canvas\Key[1] & #PB_Canvas_Shift)
      
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
        Control = Bool((\Canvas\Key[1] & #PB_Canvas_Control) Or (\Canvas\Key[1] & #PB_Canvas_Command)) * #PB_Canvas_Control
      CompilerElse
        Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control) * #PB_Canvas_Control
      CompilerEndIf
      
      Select EventType
        Case #PB_EventType_Input ; - Input (key)
          If Not Control         ; And Not Shift
            Repaint = ToInput(*This)
          EndIf
          
        Case #PB_EventType_KeyUp ; Баг в мак ос не происходить событие если зажать cmd
                                 ;  Debug "#PB_EventType_KeyUp "
                                 ;           If \items()\Text\Numeric
                                 ;             \items()\Text\String.s[1]=\items()\Text\String.s 
                                 ;           EndIf
                                 ;           Repaint = #True 
          
        Case #PB_EventType_KeyDown
          Select \Canvas\Key
            Case #PB_Shortcut_Home : Repaint = ToPos(*This, 1, Control)
            Case #PB_Shortcut_End : Repaint = ToPos(*This, - 1, Control)
            Case #PB_Shortcut_PageUp : Repaint = ToPos(*This, 1, 1)
            Case #PB_Shortcut_PageDown : Repaint = ToPos(*This, - 1, 1)
              
            Case #PB_Shortcut_A
              If Control And (\Text[2]\Len <> \Text\Len Or Not \Text[2]\Len)
                ForEach \items()
                  \Items()\Text[2]\Len = \Items()\Text\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
                  \Items()\Text[2]\String = \Items()\Text\String : \Items()\Text[2]\Change = 1
                  \Items()\Text[1]\String = "" : \Items()\Text[1]\Change = 1 : \Items()\Text[1]\Len = 0
                  \Items()\Text[3]\String = "" : \Items()\Text[3]\Change = 1 : \Items()\Text[3]\Len = 0
                Next
                
                \Text[1]\Len = 0 : \Text[1]\String = ""
                \Text[3]\Len = 0 : \Text[3]\String = #LF$
                \index[2] = 0 : \index[1] = ListSize(\Items()) - 1
                \Text\Caret = \Items()\Text\Len : \Text\Caret[1] = \Text\Caret
                \Text[2]\String = \Text\String : \Text[2]\Len = \Text\Len
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_Up     : Repaint = ToUp(*This)      ; Ok
            Case #PB_Shortcut_Left   : Repaint = ToLeft(*This)    ; Ok
            Case #PB_Shortcut_Right  : Repaint = ToRight(*This)   ; Ok
            Case #PB_Shortcut_Down   : Repaint = ToDown(*This)    ; Ok
            Case #PB_Shortcut_Back   : Repaint = ToBack(*This)
            Case #PB_Shortcut_Return : Repaint = ToReturn(*This) 
            Case #PB_Shortcut_Delete : Repaint = ToDelete(*This)
              
            Case #PB_Shortcut_C, #PB_Shortcut_X
              If Control
                SetClipboardText(\Text[2]\String)
                
                If \Canvas\Key = #PB_Shortcut_X
                  Repaint = Cut(*This)
                EndIf
              EndIf
              
            Case #PB_Shortcut_V
              If \Text\Editable And Control
                Repaint = Insert(*This, GetClipboardText())
              EndIf
              
          EndSelect 
          
      EndSelect
      
      If Repaint =- 1
        If \Text\Caret<\Text\Caret[1]
          ; Debug \Text\Caret[1]-\Text\Caret
          Change(*This, \Text\Caret, \Text\Caret[1]-\Text\Caret)
        Else
          ; Debug \Text\Caret-\Text\Caret[1]
          Change(*This, \Text\Caret[1], \Text\Caret-\Text\Caret[1])
        EndIf
      EndIf                                                  
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Events(*This._s_widget, EventType.i)
    Static DoubleClick.i=-1
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      Repaint | Scroll::CallBack(\Scroll\v, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
      Repaint | Scroll::CallBack(\Scroll\h, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
      
      If *This And (Not *This\Scroll\v\at And Not *This\Scroll\h\at)
        If ListSize(*This\items())
          If Not \Hide And Not \Disable And \Interact
            ; Get line position
            If \Canvas\Mouse\buttons
              If \Canvas\Mouse\Y < \Y
                Item.i =- 1
              Else
                Item.i = ((\Canvas\Mouse\Y-\Y-\Text\Y-\Scroll\Y) / \Text\Height)
              EndIf
            EndIf
            
            Select EventType 
              Case #PB_EventType_LeftDoubleClick 
                \Items()\Text\Caret[1] =- 1 ; Запоминаем что сделали двойной клик
                Text_SelLimits(*This)      ; Выделяем слово
                SelectionText(*This)
                
                ;                 \Items()\Text[2]\Change = 1
                ;                 \Items()\Text[2]\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
                
                Repaint = 1
                
              Case #PB_EventType_LeftButtonDown
                itemSelect(Item, \Items())
                Caret = Caret(*This, Item)
                
                If \Items()\Text\Caret[1] =- 1 : \Items()\Text\Caret[1] = 0
                  *This\Text\Caret[1] = 0
                  *This\Text\Caret = \Items()\Text\Len
                  SelectionText(*This)
                  Repaint = 1
                  
                Else
                  SelReset(*This)
                  
                  If \Items()\Text[2]\Len
                    
                    
                    
                  Else
                    
                    \Text\Caret = Caret
                    \Text\Caret[1] = \Text\Caret
                    \Index[1] = \Items()\Index 
                    \Index[2] = \Index[1]
                    
                    PushListPosition(\Items())
                    ForEach \Items() 
                      If \Index[2] <> ListIndex(\Items())
                        \Items()\Text[1]\String = ""
                        \Items()\Text[2]\String = ""
                        \Items()\Text[3]\String = ""
                      EndIf
                    Next
                    PopListPosition(\Items())
                    
                    If \Text\Caret = DoubleClick
                      DoubleClick =- 1
                      \Text\Caret[1] = \Items()\Text\Len
                      \Text\Caret = 0
                    EndIf 
                    
                    SelectionText(*This)
                    Repaint = #True
                  EndIf
                EndIf
                
              Case #PB_EventType_MouseMove  
                If \Canvas\Mouse\buttons & #PB_Canvas_LeftButton 
                  Repaint = SelSet(*This, Item)
                EndIf
                
              Default
                itemSelect(\Index[2], \Items())
            EndSelect
          EndIf
          
          ; edit events
          If *Focus = *This And (*This\Text\Editable Or \Text\Editable)
            Repaint | Editable(*This, EventType)
          EndIf
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Text_Events(*Function, *This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Static *Last._s_widget, *Widget._s_widget    ; *Focus._s_widget, 
    Static Text$, DoubleClick, LastX, LastY, Last, Drag
    Protected.i Result, Repaint, Control, Buttons, Widget
    
    ; widget_events_type
    If *This
      With *This
        If Canvas=-1 
          Widget = *This
          Canvas = EventGadget()
        Else
          Widget = Canvas
        EndIf
        ;         If Canvas <> \Canvas\Gadget
        ;           ProcedureReturn 
        ;         EndIf
        
        ; Get at point widget
        \Canvas\mouse\at = From(*This)
        
        Select EventType 
          Case #PB_EventType_LeftButtonUp 
            If *Last = *This
              If *Widget <> *Focus
                ProcedureReturn 0 
              EndIf
            EndIf
            
          Case #PB_EventType_LeftClick 
            ; Debug ""+\Canvas\Mouse\buttons+" Last - "+*Last +" Widget - "+*Widget +" Focus - "+*Focus +" This - "+*This
            If *Last = *This : *Last = *Widget
              If *Widget <> *Focus
                ProcedureReturn 0 
              EndIf
            EndIf
            
            If Not *This\Canvas\mouse\at 
              ProcedureReturn 0
            EndIf
        EndSelect
        
        If Not \Hide And Not \Disable And \Interact And Widget <> Canvas And CanvasModifiers 
          Select EventType 
            Case #PB_EventType_Focus : ProcedureReturn 0 ; Bug in mac os because it is sent after the mouse left down
            Case #PB_EventType_MouseMove, #PB_EventType_LeftButtonUp
              If Not \Canvas\Mouse\buttons 
                If \Canvas\mouse\at
                  If *Last <> *This 
                    If *Last
                      If (*Last\Index > *This\Index)
                        ProcedureReturn 0
                      Else
                        ; Если с нижнего виджета перешли на верхный, 
                        ; то посылаем событие выход для нижнего
                        Text_Events(*Function, *Last, #PB_EventType_MouseLeave, Canvas, 0)
                        *Last = *This
                      EndIf
                    Else
                      *Last = *This
                    EndIf
                    
                    EventType = #PB_EventType_MouseEnter
                    *Widget = *Last
                  EndIf
                  
                ElseIf (*Last = *This)
                  If EventType = #PB_EventType_LeftButtonUp 
                    Text_Events(*Function, *Widget, #PB_EventType_LeftButtonUp, Canvas, 0)
                  EndIf
                  
                  EventType = #PB_EventType_MouseLeave
                  *Last = *Widget
                  *Widget = 0
                EndIf
              EndIf
              
            Case #PB_EventType_LostFocus
              If (*Focus = *This)
                *Last = *Focus
                Text_Events(*Function, *Focus, #PB_EventType_LostFocus, Canvas, 0)
                *Last = *Widget
              EndIf
              
            Case #PB_EventType_LeftButtonDown
              If (*Last = *This)
                PushListPosition(List())
                ForEach List()
                  If List()\Widget\Focus = List()\Widget And List()\Widget <> *This 
                    
                    List()\Widget\Focus = 0
                    *Last = List()\Widget
                    Text_Events(*Function, List()\Widget, #PB_EventType_LostFocus, List()\Widget\Canvas\Gadget, 0)
                    *Last = *Widget 
                    
                    ; 
                    If Not List()\Widget\Repaint : List()\Widget\Repaint = 1
                      PostEvent(#PB_Event_Gadget, List()\Widget\Canvas\Window, List()\Widget\Canvas\Gadget, #PB_EventType_Repaint)
                    EndIf
                    Break 
                  EndIf
                Next
                PopListPosition(List())
                
                If *This <> \Focus : \Focus = *This : *Focus = *This
                  Text_Events(*Function, *This, #PB_EventType_Focus, Canvas, 0)
                EndIf
              EndIf
              
          EndSelect
        EndIf
        
        If (*Last = *This) 
          Select EventType
            Case #PB_EventType_LeftButtonDown
              If Not \Canvas\Mouse\Delta
                \Canvas\Mouse\Delta = AllocateStructure(Mouse_S)
                \Canvas\Mouse\Delta\X = \Canvas\Mouse\X
                \Canvas\Mouse\Delta\Y = \Canvas\Mouse\Y
                \Canvas\Mouse\delta\at = \Canvas\mouse\at
                \Canvas\Mouse\Delta\buttons = \Canvas\Mouse\buttons
              EndIf
              
            Case #PB_EventType_LeftButtonUp : \Drag = 0
              FreeStructure(\Canvas\Mouse\Delta) : \Canvas\Mouse\Delta = 0
              ; ResetStructure(\Canvas\Mouse\Delta, Mouse_S)
              
            Case #PB_EventType_MouseMove
              If \Drag = 0 And \Canvas\Mouse\buttons And \Canvas\Mouse\Delta And 
                 (Abs((\Canvas\Mouse\X-\Canvas\Mouse\Delta\X)+(\Canvas\Mouse\Y-\Canvas\Mouse\Delta\Y)) >= 6) : \Drag=1
                ; PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_DragStart)
              EndIf
              
            Case #PB_EventType_MouseLeave
              If CanvasModifiers 
                ; Если перешли на другой виджет
                PushListPosition(List())
                ForEach List()
                  If List()\Widget\Canvas\Gadget = Canvas And List()\Widget\Focus <> List()\Widget And List()\Widget <> *This
                    List()\Widget\Canvas\mouse\at = From(List()\Widget)
                    
                    If List()\Widget\Canvas\mouse\at
                      If *Last
                        Text_Events(*Function, *Last, #PB_EventType_MouseLeave, Canvas, 0)
                      EndIf     
                      
                      *Last = List()\Widget
                      *Widget = List()\Widget
                      ProcedureReturn Text_Events(*Function, *Last, #PB_EventType_MouseEnter, Canvas, 0)
                    EndIf
                  EndIf
                Next
                PopListPosition(List())
              EndIf
              
              If \Cursor[1] <> GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
                SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor[1])
                \Cursor[1] = 0
              EndIf
              
            Case #PB_EventType_MouseEnter    
              If Not \Cursor[1] 
                \Cursor[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
              EndIf
              SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor)
              
            Case #PB_EventType_MouseMove ; bug mac os
              If \Canvas\Mouse\buttons And #PB_Compiler_OS = #PB_OS_MacOS ; And \Cursor <> GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
                                                                          ; Debug 555
                SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor)
              EndIf
              
          EndSelect
        EndIf 
        
      EndWith
    EndIf
    
    If (*Last = *This) Or (*Focus = *This And *This\Text\Editable); Or (*Last = *Focus)
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        Result | CallFunctionFast(*Function, *This, EventType)
      CompilerElse
        Result | CallCFunctionFast(*Function, *This, EventType)
      CompilerEndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Text_CallBack(*Function, *This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
    If Canvas =- 1
      With *This
        Select EventType
          Case #PB_EventType_Repaint
            Debug " -- Canvas repaint -- "
          Case #PB_EventType_Input 
            \Canvas\Input = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Input)
            \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
            \Canvas\Key = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Key)
            \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
            \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
            \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
               #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
               #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
            
            CompilerIf #PB_Compiler_OS = #PB_OS_Linux
              \Canvas\Mouse\buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                      (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                      (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
            CompilerElse
              \Canvas\Mouse\buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
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
              Result | Text_Events(*Function, *This, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | Text_Events(*Function, *This, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    Result | Text_Events(*Function, *This, EventType, Canvas, CanvasModifiers)
    
    ProcedureReturn Result
  EndProcedure
  
 
  Procedure.i CallBack(*This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text_CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure.i Widget(*This._s_widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Editor
        \Cursor = #PB_Cursor_IBeam
        ;\DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        If Not \Canvas\Window
          \Canvas\Window = GetActiveWindow() ; GetGadgetData(Canvas)
        EndIf
        \Radius = Radius
        \color\alpha = 255
        \Interact = 1
        \Text\Caret[1] =- 1
        \Index[1] =- 1
        \X =- 1
        \Y =- 1
        
        ; Set the Default widget flag
        If Bool(Flag&#__text_WordWrap)
          Flag&~#__text_MultiLine
        EndIf
        
        If Bool(Flag&#__text_MultiLine)
          Flag&~#__text_WordWrap
        EndIf
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fSize = Bool(Not Flag&#__flag_BorderLess)+1
        \bSize = \fSize
        
        \flag\buttons = Bool(flag&#__flag_NoButtons)
        \Flag\Lines = Bool(flag&#__flag_NoLines)
        \Flag\FullSelection = Bool(Not flag&#__flag_FullSelection)*7
        \Flag\AlwaysSelection = Bool(flag&#__flag_AlwaysSelection)
        \Flag\CheckBoxes = Bool(flag&#__flag_CheckBoxes)*12 ; Это еще будет размер чек бокса
        \Flag\GridLines = Bool(flag&#__flag_GridLines)
        
        \Text\Vertical = Bool(Flag&#__flag_Vertical)
        \Text\Editable = Bool(Not Flag&#__text_ReadOnly)
        
        If Bool(Flag&#__text_WordWrap)
          \Text\MultiLine = 1
        ElseIf Bool(Flag&#__text_MultiLine)
          \Text\MultiLine = 2
        Else
          \Text\MultiLine =- 1
        EndIf
        
        \Flag\MultiSelect = 1
        ;\Text\Numeric = Bool(Flag&#__text_Numeric)
        \Text\Lower = Bool(Flag&#__text_LowerCase)
        \Text\Upper = Bool(Flag&#__text_UpperCase)
        \Text\Pass = Bool(Flag&#__text_Password)
        
        \Text\Align\Horizontal = Bool(Flag&#__text_Center)
        \Text\Align\Vertical = Bool(Flag&#__text_Middle)
        \Text\Align\Right = Bool(Flag&#__text_Right)
        \Text\Align\Bottom = Bool(Flag&#__text_Bottom)
        
        If \Text\Vertical
          \Text\X = \fSize 
          \Text\y = \fSize+2
        Else
          \Text\X = \fSize+2
          \Text\y = \fSize
        EndIf
        
        
        \Color = Colors
        \Color\Fore[0] = 0
        
        \sci\margin\width = Bool(Flag&#__flag_Numeric)
        \sci\margin\Color\Back = $C8F0F0F0 ; \Color\Back[0] 
        
        \Row\color\alpha = 255
        \Row\Color = Colors
        \Row\Color\Fore[0] = 0
        \Row\Color\Fore[1] = 0
        \Row\Color\Fore[2] = 0
        \Row\Color\Back[0] = \Row\Color\Back[1]
        \Row\Color\Frame[0] = \Row\Color\Frame[1]
        ;\Color\Back[1] = \Color\Back[0]
        
        
        
        If \Text\Editable
          \Color\Back[0] = $FFFFFFFF 
        Else
          \Color\Back[0] = $FFF0F0F0  
        EndIf
        
      EndIf
      
      ; create scrollbars
      Scroll::Bars(\Scroll, 16, 7, Bool(\Text\MultiLine <> 1))
      
      Resize(*This, X,Y,Width,Height)
      ;       \Text\String = #LF$
      ;       \Text\Change = 1  
      SetText(*This, Text.s)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s="", Flag.i=0, Radius.i=0)
    Protected *Widget, *This._s_widget = AllocateStructure(_s_widget)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius)
      ;If Not *This\Repaint : *This\Repaint = 1
      PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint, *This)
      ;EndIf
      ;       PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
      ;       BindEvent(#PB_Event_Widget, @Widget_CallBack(), *This\Canvas\Window, *This, #PB_EventType_Create)
      ;       SetGadgetData(Canvas, *This)
      ;       BindGadgetEvent(Canvas, @Canvas_CallBack())
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Canvas_CallBack()
    Protected Repaint, *This._s_widget = GetGadgetData(EventGadget())
    
    With *This
      Select EventType()
        Case #PB_EventType_Repaint 
          If *This\Repaint : *This\Repaint = 0
            Repaint = 1
          EndIf
          
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint | Resize(*This, #PB_Ignore, #PB_Ignore, GadgetWidth(\Canvas\Gadget), GadgetHeight(\Canvas\Gadget))
      EndSelect
      
      Repaint | CallBack(*This, EventType())
      
      If Repaint 
        ReDraw(*This)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
    Protected *This._s_widget = AllocateStructure(_s_widget)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        Widget(*This, Gadget, 0, 0, Width, Height, "", Flag)
        ;         PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
        ;         BindEvent(#PB_Event_Widget, @Widget_CallBack(), *This\Canvas\Window, *This, #PB_EventType_Create)
        
        SetGadgetData(Gadget, *This)
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
           "Otherwise it will not work." ;+ m.s +

  If OpenWindow(0, 0, 0, 422, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ButtonGadget(100, 490-60,490-30,67,25,"~wrap")
    
    EditorGadget(0, 8, 8, 306, 133, #PB_Editor_WordWrap) 
    SetGadgetText(0, Text.s) 
    For a = 0 To 2
       AddGadgetItem(0, a, "Line "+Str(a))
    Next
    AddGadgetItem(0, a, "")
    For a = 4 To 6
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    SetGadgetFont(0, FontID(0))
    
    
    g=16
    Editor::Gadget(g, 8, 133+5+8, 306, 133, #__flag_GridLines|#__flag_Numeric|#__text_WordWrap) 
    *g._s_widget=GetGadgetData(g)
    
    Editor::SetText(*g, Text.s) 
    ;Text::Redraw(*w)
    
    For a = 0 To 2
       Editor::AddItem(*g, a, "Line "+Str(a))
    Next
    Editor::AddItem(*g, a, "")
    For a = 4 To 6
      Editor::AddItem(*g, a, "Line "+Str(a))
    Next
    Editor::SetFont(*g, FontID(0))
    
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
                
                *E\Text\MultiLine !- 1
                If  *E\Text\MultiLine = 1
                  SetGadgetText(100,"~wrap")
                Else
                  SetGadgetText(100,"wrap")
                EndIf
                
                CompilerSelect #PB_Compiler_OS
                  CompilerCase #PB_OS_Linux
                    If  *E\Text\MultiLine = 1
                      gtk_text_view_set_wrap_mode_(GadgetID(0), #GTK_WRAP_WORD)
                    Else
                      gtk_text_view_set_wrap_mode_(GadgetID(0), #GTK_WRAP_NONE)
                    EndIf
                    
                  CompilerCase #PB_OS_MacOS
                    
                    If  *E\Text\MultiLine = 1
                      EditorGadget(0, 8, 8, 306, 133, #PB_Editor_WordWrap)
                    Else
                      EditorGadget(0, 8, 8, 306, 133) 
                    EndIf
                    
                    SetGadgetText(0, Text.s) 
                    For a = 0 To 5
                      AddGadgetItem(0, a, "Line "+Str(a))
                    Next
                    SetGadgetFont(0, FontID(0))
                    
                    SplitterGadget(10,8, 8, 306, 276, 0,g)
                    
                    CompilerIf #PB_Compiler_Version =< 546
                      BindGadgetEvent(10, @SplitterCallBack())
                    CompilerEndIf
                    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
                    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
                    
                    ; ;                     ImportC ""
                    ; ;                       GetControlProperty(Control, PropertyCreator, PropertyTag, BufferSize, *ActualSize, *PropertyBuffer)
                    ; ;                       TXNSetTXNObjectControls(TXNObject, ClearAll, ControlCount, ControlTags, ControlData)
                    ; ;                     EndImport
                    ; ;                     
                    ; ;                     Define TXNObject.i
                    ; ;                     Dim ControlTag.i(0)
                    ; ;                     Dim ControlData.i(0)
                    ; ;                     
                    ; ;                     ControlTag(0) = 'wwrs' ; kTXNWordWrapStateTag
                    ; ;                     ControlData(0) = 0     ; kTXNAutoWrap
                    ; ;                     
                    ; ;                     If GetControlProperty(GadgetID(0), 'PURE', 'TXOB', 4, 0, @TXNObject) = 0
                    ; ;                       TXNSetTXNObjectControls(TXNObject, #False, 1, @ControlTag(0), @ControlData(0))
                    ; ;                     EndIf
                  CompilerCase #PB_OS_Windows
                    SendMessage_(GadgetID(0), #EM_SETTARGETDEVICE, 0, 0)
                CompilerEndSelect
                
                
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

; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -------------------------------------------------------v--vf4------------------------------------------------
; EnableXP