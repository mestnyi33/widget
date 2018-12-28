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


CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
  ;  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
  ;  IncludePath "/Users/a/Documents/GitHub/Widget/"
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_draw.pbi"
  
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_scroll.pbi"
  XIncludeFile "module_text.pbi"
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
CompilerEndIf

DeclareModule Editor
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  ;- - DECLAREs MACROs
  Macro Resize(_adress_, _x_,_y_,_width_,_height_) : Text::Resize(_adress_, _x_,_y_,_width_,_height_) : EndMacro
  Declare.i Update(*This.Widget_S)
  
  ;- DECLARE
  Declare.i SetItemState(*This.Widget_S, Item.i, State.i)
  Declare GetState(*This.Widget_S)
  Declare.s GetText(*This.Widget_S)
  Declare.i ClearItems(*This.Widget_S)
  Declare.i CountItems(*This.Widget_S)
  Declare.i RemoveItem(*This.Widget_S, Item.i)
  Declare SetState(*This.Widget_S, State.i)
  Declare GetAttribute(*This.Widget_S, Attribute.i)
  Declare SetAttribute(*This.Widget_S, Attribute.i, Value.i)
  Declare SetText(*This.Widget_S, Text.s, Item.i=0)
  Declare SetFont(*This.Widget_S, FontID.i)
  Declare.i AddItem(*This.Widget_S, Item.i,Text.s,Image.i=-1,Flag.i=0)
  
  Declare.i Make(*This.Widget_S)
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s="", Flag.i=0, Radius.i=0)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
  Declare.i ReDraw(*This.Widget_S, Canvas =- 1, BackColor=$FFF0F0F0)
  Declare.i Draw(*This.Widget_S)
EndDeclareModule

Module Editor
  Global *Buffer = AllocateMemory(10000000)
  Global *Pointer = *Buffer
  
  Procedure.i Update(*This.Widget_S)
    *This\Text\String.s = PeekS(*Buffer)
    *This\Text\Change = 1
  EndProcedure
  ; ;   UseModule Constant
  ;- PROCEDURE
  ;-
  
  Declare.i Canvas_CallBack()
  
  ;-
  ;- PUBLIC
  Procedure.i Caret(*This.Widget_S, Line.i = 0)
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
  
  Procedure.i Change(*This.Widget_S, Pos.i, Len.i)
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
  
  Procedure SelectionText(*This.Widget_S) ; Ok
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
  
  Procedure.i SelReset(*This.Widget_S)
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
  
  
  Procedure.i SelLimits(*This.Widget_S)
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
  
  ;-
  Procedure Move(*This.Widget_S, Width)
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
  
  Procedure.i Make(*This.Widget_S)
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
  
  Procedure.i Paste(*This.Widget_S, Chr.s, Count.i=0)
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
  
  Procedure.i Insert(*This.Widget_S, Chr.s)
    Static Dot, Minus, Color.i
    Protected Repaint, Input, Input_2, String.s, Count.i
    
    With *This
      Chr.s = Text::Make(*This, Chr.s)
      
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
  
  Procedure.i Cut(*This.Widget_S)
    ProcedureReturn Paste(*This.Widget_S, "")
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
  Procedure AddLine(*This.Widget_S, Line.i, String.s) ;,Image.i=-1,Sublevel.i=0)
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
  
  Procedure.i MultiLine(*This.Widget_S)
    Protected Repaint, String.s, text_width, Len.i
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
        
        If \Text\Count[1] <> \Text\Count Or \Text\Vertical
          \Text\Count[1] = \Text\Count
          
          ; Scroll hight reset 
          \Scroll\Height = 0
          ClearList(\Items())
          
          If \Text\Vertical
            For IT = \Text\Count To 1 Step - 1
              If AddElement(\Items())
                \Items() = AllocateStructure(Rows_S)
                String = StringField(\Text\String.s[2], IT, #LF$)
                
                \Items()\Focus =- 1
                \Items()\Index[1] =- 1
                
                If \Type = #PB_GadgetType_Button
                  \Items()\Text\Width = TextWidth(RTrim(String))
                Else
                  \Items()\Text\Width = TextWidth(String)
                EndIf
                
                If \Text\Align\Right
                  Text_X=(Width-\Items()\Text\Width) 
                ElseIf \Text\Align\Horizontal
                  Text_X=(Width-\Items()\Text\Width-Bool(\Items()\Text\Width % 2))/2 
                EndIf
                
                \Items()\x = \X[2]+\Text\Y+\Scroll\Height+Text_Y
                \Items()\y = \Y[2]+\Text\X+Text_X
                \Items()\Width = \Text\Height
                \Items()\Height = Width
                \Items()\Index = ListIndex(\Items())
                
                \Items()\Text\Editable = \Text\Editable 
                \Items()\Text\Vertical = \Text\Vertical
                If \Text\Rotate = 270
                  \Items()\Text\x = \Image\Width+\Items()\x+\Text\Height+\Text\X
                  \Items()\Text\y = \Items()\y
                Else
                  \Items()\Text\x = \Image\Width+\Items()\x
                  \Items()\Text\y = \Items()\y+\Items()\Text\Width
                EndIf
                \Items()\Text\Height = \Text\Height
                \Items()\Text\String.s = String.s
                \Items()\Text\Len = Len(String.s)
                
                _set_scroll_height_(*This)
              EndIf
            Next
          Else
            Protected time = ElapsedMilliseconds()
            
            ; 239
            If CreateRegularExpression(0, ~".*\n?")
              If ExamineRegularExpression(0, \Text\String.s[2])
                While NextRegularExpressionMatch(0) 
                  If AddElement(\Items())
                    \Items() = AllocateStructure(Rows_S)
        
                    \Items()\Text\String.s = Trim(RegularExpressionMatchString(0), #LF$)
                    ;\Items()\Text\Width = TextWidth(\Items()\Text\String.s) ; 
                    
                    \Items()\Focus =- 1
                    \Items()\Index[1] =- 1
                    \Items()\Color\State = 1 ; Set line default colors
                    \Items()\Radius = \Radius
                    \Items()\Index = ListIndex(\Items())
                    
                    ; Update line pos in the text
                    _set_line_pos_(*This)
                    
                    _set_content_X_(*This)
                    _line_resize_X_(*This)
                    _line_resize_Y_(*This)
                    
                    ; Scroll width length
                    _set_scroll_width_(*This)
                    
                    ; Scroll hight length
                    _set_scroll_height_(*This)
                  EndIf
                Wend
              EndIf
              
              FreeRegularExpression(0)
            Else
              Debug RegularExpressionError()
            EndIf

            
            
            
;             ;; 294 ; 124
;             Protected *Sta.Character = @\Text\String.s[2], *End.Character = @\Text\String.s[2] : #SOC = SizeOf (Character)
            ;While *End\c 
;               If *End\c = #LF And AddElement(\Items())
;                 Len = (*End-*Sta)>>#PB_Compiler_Unicode
;                 
;                 \Items()\Text\String.s = PeekS (*Sta, Len) ;Trim(, #LF$)
;                 
; ;                 If \Type = #PB_GadgetType_Button
; ;                   \Items()\Text\Width = TextWidth(RTrim(\Items()\Text\String.s))
; ;                 Else
; ;                   \Items()\Text\Width = TextWidth(\Items()\Text\String.s)
; ;                 EndIf
;                 
;                 \Items()\Focus =- 1
;                 \Items()\Index[1] =- 1
;                 \Items()\Color\State = 1 ; Set line default colors
;                 \Items()\Radius = \Radius
;                 \Items()\Index = ListIndex(\Items())
;                 
;                 ; Update line pos in the text
;                 ; _set_line_pos_(*This)
;                 \Items()\Text\Pos = \Text\Pos - Bool(\Text\MultiLine = 1)*\Items()\index ; wordwrap
;                 \Items()\Text\Len = Len                                                  ; (\Items()\Text\String.s)
;                 \Text\Pos + \Items()\Text\Len + 1                                        ; Len(#LF$)
;                 
;                 ; Debug "f - "+String.s +" "+ CountString(String, #CR$) +" "+ CountString(String, #LF$) +" - "+ \Items()\Text\Pos +" "+ \Items()\Text\Len
;                 
;                 _set_content_X_(*This)
;                 _line_resize_X_(*This)
;                 _line_resize_Y_(*This)
;                 
;                 ; Scroll width length
;                 _set_scroll_width_(*This)
;                 
;                 ; Scroll hight length
;                 _set_scroll_height_(*This)
;                 
;                 *Sta = *End + #SOC 
;               EndIf 
;               
;               *End + #SOC 
;             Wend
          ;;;;  FreeMemory(*End)
            
            ;  MessageRequester("", Str(ElapsedMilliseconds()-time) + " text parse time ")
           Debug Str(ElapsedMilliseconds()-time) + " text parse time "
          EndIf
        Else
          Protected time2 = ElapsedMilliseconds()
          
          If CreateRegularExpression(0, ~".*\n?")
            If ExamineRegularExpression(0, \Text\String.s[2])
              While NextRegularExpressionMatch(0) : IT+1
                String.s = Trim(RegularExpressionMatchString(0), #LF$)
                
                If SelectElement(\Items(), IT-1)
                  If \Items()\Text\String.s <> String.s
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
  
  Procedure PlotX(X, Y, SourceColor, TargetColor)
    Protected Color
    
    If x%2
      Select TargetColor
        Case $FFECAE62, $FFECB166, $FFFEFEFE, $FFE89C3D, $FFF3CD9D
          Color = $FFFEFEFE
        Default
          Color = SourceColor
      EndSelect
    Else
      Color = TargetColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure PlotY(X, Y, SourceColor, TargetColor)
    Protected Color
    
    If y%2
      Select TargetColor
        Case $FFECAE62, $FFECB166, $FFFEFEFE, $FFE89C3D, $FFF3CD9D
          Color = $FFFEFEFE
        Case $FFF1F1F1, $FFF3F3F3, $FFF5F5F5, $FFF7F7F7, $FFF9F9F9, $FFFBFBFB, $FFFDFDFD, $FFFCFCFC, $FFFEFEFE, $FF7E7E7E
          Color = TargetColor
        Default
          Color = SourceColor
      EndSelect
    Else
      Color = TargetColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure.i Draw(*This.Widget_S)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    Protected angle.f
    
    If Not *This\Hide
      
      With *This
        If \Text\FontID 
          DrawingFont(\Text\FontID) 
        EndIf
        
        
        ; Then changed text
        If \Text\Change
          If set_text_width
            SetTextWidth(set_text_width, Len(set_text_width))
            set_text_width = ""
          EndIf
          
          \Text\Height[1] = TextHeight("A") + Bool(\Text\Count<>1 And \Flag\GridLines)
          If \Type = #PB_GadgetType_Tree
            \Text\Height = 20
          Else
            \Text\Height = \Text\Height[1]
          EndIf
          \Text\Width = TextWidth(\Text\String.s)
          
          If \sci\margin\width 
            \Text\Count = CountString(\Text\String.s, #LF$)
            \sci\margin\width = TextWidth(Str(\Text\Count))+11
            ;  Scroll::Resizes(\Scroll, \x[2]+\sci\margin\width+1,\Y[2],\Width[2]-\sci\margin\width-1,\Height[2])
          EndIf
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
                 Scroll::SetAttribute(\Scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height - Bool(\Flag\GridLines)) 
                
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
                 Scroll::SetAttribute(\Scroll\h, #PB_ScrollBar_Maximum, \Scroll\Width)
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
            _draw_plots_(*This, *This\Items(), *This\x+*This\Scroll\X, \box\y+\box\height/2)
            
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
                DrawText(*This\sci\margin\width-TextWidth(Str(\Index))-3, \Y+*This\Scroll\Y, Str(\Index), *This\sci\margin\Color\Front);, *This\sci\margin\Color\Back)
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
          ;              Scroll::SetAttribute(\Scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height - Bool(\Flag\GridLines))
          ;             Scroll::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;           EndIf
          ;           If \Scroll\h And \Scroll\h\Max<>\Scroll\Width And 
          ;              Scroll::SetAttribute(\Scroll\h, #PB_ScrollBar_Maximum, \Scroll\Width)
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
        
        If \Text\Change : \Text\Change = 0 : EndIf
        If \Resize : \Resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i ReDraw(*This.Widget_S, Canvas =- 1, BackColor=$FFF0F0F0)
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
  Procedure.i ToUp(*This.Widget_S)
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
  
  Procedure.i ToDown(*This.Widget_S)
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
  
  Procedure.i ToLeft(*This.Widget_S) ; Ok
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
        
      ElseIf ToUp(*This.Widget_S)
        \Text\Caret = \Items()\Text\Len
        \Text\Caret[1] = \Text\Caret
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToRight(*This.Widget_S) ; Ok
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
  
  Procedure.i ToInput(*This.Widget_S)
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
  
  Procedure.i ToReturn(*This.Widget_S) ; Ok
    
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
  
  Procedure.i ToBack(*This.Widget_S)
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
  
  Procedure.i ToDelete(*This.Widget_S)
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
  
  Procedure.i ToPos(*This.Widget_S, Pos.i, Len.i)
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
  Procedure.i Text_AddLine(*This.Widget_S, Line.i, Text.s)
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
  
  Procedure.i AddItem(*This.Widget_S, Item.i,Text.s,Image.i=-1,Flag.i=0)
    Static adress.i, first.i
    Protected *Item, subLevel, hide
    
    If *This
      With *This
        If \Type = #PB_GadgetType_Tree
          subLevel = Flag
        EndIf
        
        ;{ Генерируем идентификатор
        If Item < 0 Or Item > ListSize(\Items()) - 1
          LastElement(\Items())
          *Item = AddElement(\Items()) 
          Item = ListIndex(\Items())
        Else
          SelectElement(\Items(), Item)
          If \Items()\sublevel>sublevel
            sublevel=\Items()\sublevel 
          EndIf
          *Item = InsertElement(\Items())
          
          ; Исправляем идентификатор итема  
          PushListPosition(\Items())
          While NextElement(\Items())
            \Items()\Index = ListIndex(\Items())
          Wend
          PopListPosition(\Items())
        EndIf
        ;}
        
        If *Item
          ;\Items() = AllocateMemory(SizeOf(Rows_S) )
          \Items() = AllocateStructure(Rows_S)
          
          If Item = 0
            First = *Item
          EndIf
          
          If subLevel
            If sublevel>Item
              sublevel=Item
            EndIf
            
            PushListPosition(\Items())
            While PreviousElement(\Items()) 
              If subLevel = \Items()\subLevel
                adress = \Items()\handle
                Break
              ElseIf subLevel > \Items()\subLevel
                adress = @\Items()
                Break
              EndIf
            Wend 
            If adress
              ChangeCurrentElement(\Items(), adress)
              If subLevel > \Items()\subLevel
                sublevel = \Items()\sublevel + 1
                \Items()\handle[1] = *Item
                \Items()\childrens + 1
                \Items()\collapsed = 1
                hide = 1
              EndIf
            EndIf
            PopListPosition(\Items())
            
            \Items()\sublevel = sublevel
            \Items()\hide = hide
          Else                                      
            ; ChangeCurrentElement(\Items(), *Item)
            ; PushListPosition(\Items()) 
            ; PopListPosition(\Items())
            adress = first
          EndIf
          
          \Items()\handle = adress
          \Items()\change = Bool(\Type = #PB_GadgetType_Tree)
          ;\Items()\Text\FontID = \Text\FontID
          \Items()\Index[1] =- 1
          \Items()\focus =- 1
          \Items()\lostfocus =- 1
          \Items()\text\change = 1
          
          If IsImage(Image)
            
            Select \Attribute
              Case #PB_Attribute_LargeIcon
                \Items()\Image\width = 32
                \Items()\Image\height = 32
                ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
                
              Case #PB_Attribute_SmallIcon
                \Items()\Image\width = 16
                \Items()\Image\height = 16
                ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
                
              Default
                \Items()\Image\width = ImageWidth(Image)
                \Items()\Image\height = ImageHeight(Image)
            EndSelect   
            
            \Items()\Image\handle = ImageID(Image)
            \Items()\Image\handle[1] = Image
            
            \Image\width = \Items()\Image\width
          EndIf
          
          ; add lines
          AddLine(*This, Item.i, Text.s)
          \Text\Change = 1 ; надо посмотрет почему надо его вызивать раньше вед не нужно было
                           ;           \Items()\Color = Colors
                           ;           \Items()\Color\State = 1
                           ;           \Items()\Color\Fore[0] = 0 
                           ;           \Items()\Color\Fore[1] = 0
                           ;           \Items()\Color\Fore[2] = 0
          
          If Item = 0
            If Not \Repaint : \Repaint = 1
              PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
            EndIf
          EndIf
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *Item
  EndProcedure
  
  Procedure SetAttribute(*This.Widget_S, Attribute.i, Value.i)
    With *This
      
    EndWith
  EndProcedure
  
  Procedure GetAttribute(*This.Widget_S, Attribute.i)
    Protected Result
    
    With *This
      ;       Select Attribute
      ;         Case #PB_ScrollBar_Minimum    : Result = \Scroll\min
      ;         Case #PB_ScrollBar_Maximum    : Result = \Scroll\max
      ;         Case #PB_ScrollBar_PageLength : Result = \Scroll\pageLength
      ;       EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemState(*This.Widget_S, Item.i, State.i)
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
  
  Procedure.i SetState(*This.Widget_S, State.i)
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
  
  Procedure GetState(*This.Widget_S)
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
  
  Procedure ClearItems(*This.Widget_S)
    Text::ClearItems(*This)
    ProcedureReturn 1
  EndProcedure
  
  Procedure.i CountItems(*This.Widget_S)
    ProcedureReturn Text::CountItems(*This)
  EndProcedure
  
  Procedure.i RemoveItem(*This.Widget_S, Item.i)
    Text::RemoveItem(*This, Item)
  EndProcedure
  
  Procedure.s GetText(*This.Widget_S)
    ProcedureReturn Text::GetText(*This)
  EndProcedure
  
  Procedure.i SetText(*This.Widget_S, Text.s, Item.i=0)
    Protected i
    
    With *This
      If Text::SetText(*This, Text.s)
        If Not \Repaint : \Repaint = 1
          PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
        EndIf
        ProcedureReturn 1
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i SetFont(*This.Widget_S, FontID.i)
    
    With *This
      If Text::SetFont(*This, FontID)
        If Not Bool(\Text\Count[1] And \Text\Count[1] <> \Text\Count)
          Redraw(*This, \Canvas\Gadget)
        EndIf
        ProcedureReturn 1
      EndIf
    EndWith
    
  EndProcedure
  
  ;-
  Procedure SelSet(*This.Widget_S, Line.i)
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
  
  Procedure.i Editable(*This.Widget_S, EventType.i)
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
  
  Procedure.i Events(*This.Widget_S, EventType.i)
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
                Text::SelLimits(*This)      ; Выделяем слово
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
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
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
        If Bool(Flag&#PB_Text_WordWrap)
          Flag&~#PB_Text_MultiLine
        EndIf
        
        If Bool(Flag&#PB_Text_MultiLine)
          Flag&~#PB_Text_WordWrap
        EndIf
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fSize = Bool(Not Flag&#PB_Flag_BorderLess)+1
        \bSize = \fSize
        
        \flag\buttons = Bool(flag&#PB_Flag_NoButtons)
        \Flag\Lines = Bool(flag&#PB_Flag_NoLines)
        \Flag\FullSelection = Bool(Not flag&#PB_Flag_FullSelection)*7
        \Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
        \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12 ; Это еще будет размер чек бокса
        \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
        
        \Text\Vertical = Bool(Flag&#PB_Flag_Vertical)
        \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
        
        If Bool(Flag&#PB_Text_WordWrap)
          \Text\MultiLine = 1
        ElseIf Bool(Flag&#PB_Text_MultiLine)
          \Text\MultiLine = 2
        Else
          \Text\MultiLine =- 1
        EndIf
        
        \Flag\MultiSelect = 1
        ;\Text\Numeric = Bool(Flag&#PB_Text_Numeric)
        \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
        \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
        \Text\Pass = Bool(Flag&#PB_Text_Password)
        
        \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
        \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
        \Text\Align\Right = Bool(Flag&#PB_Text_Right)
        \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
        
        If \Text\Vertical
          \Text\X = \fSize 
          \Text\y = \fSize+2
        Else
          \Text\X = \fSize+2
          \Text\y = \fSize
        EndIf
        
        
        \Color = Colors
        \Color\Fore[0] = 0
        
        \sci\margin\width = Bool(Flag&#PB_Flag_Numeric)
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
    Protected *Widget, *This.Widget_S = AllocateStructure(Widget_S)
    
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
    Protected Repaint, *This.Widget_S = GetGadgetData(EventGadget())
    
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
    Protected *This.Widget_S = AllocateStructure(Widget_S)
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
  
  Define a,i
  Define g, Text.s
  ; Define m.s=#CRLF$
  Define m.s=#CRLF$;#LF$
  
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
                                         ;            m.s +
                                         ;            "Schol is a beautiful thing." + m.s +
                                         ;            "You ned it, that's true." + m.s +
                                         ;            "There was a group of monkeys siting on a fallen tree."
                                         ;  Text.s = "This is a long line. Who should show, i have to write the text in the box or not. The string must be very long. Otherwise it will not work."
                                         ; ;   ;Text.s + m + m                   ; " + m + "
                                         ; ;   Text.s + "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789" + m ; + m
                                         ; ;   Text.s + "The main features of PureBasic" + m
  
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
  
  If OpenWindow(0, 0, 0, 422, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ButtonGadget(100, 490-60,490-30,67,25,"~wrap")
    
    EditorGadget(0, 8, 8, 306, 233) : SetGadgetText(0, Text.s)    ; , #PB_Editor_WordWrap
                                                                  ;     For a = 0 To 2
                                                                  ;       AddGadgetItem(0, a, "Line "+Str(a))
                                                                  ;     Next
                                                                  ;     AddGadgetItem(0, a, "")
                                                                  ;     For a = 4 To 6
                                                                  ;       AddGadgetItem(0, a, "Line "+Str(a))
                                                                  ;     Next
                                                                  ;     SetGadgetFont(0, FontID(0))
    
    
    g=16
    Editor::Gadget(g, 8, 133+5+8, 306, 233, #PB_Flag_GridLines|#PB_Flag_Numeric);|#PB_Text_Right)  #PB_Text_WordWrap|  #PB_Flag_FullSelection);|
    *w.Widget_S=GetGadgetData(g)
    
    Editor::SetText(*w, Text.s) 
    
    ;     ;*w\text\count = CountString(*w\text\string)
    ;     *w\text\change = 1
    Debug *w\text\string
    Debug "------------ "+Len(*w\text\string)
    Debug *w\text\string[2]
    Debug "------------ "+Len(*w\text\string[2])
    
    ;     For a = 0 To 2
    ;       Editor::AddItem(*w, a, "Line "+Str(a))
    ;     Next
    ;     Editor::AddItem(*w, a, "")
    ;     For a = 4 To 6
    ;       Editor::AddItem(*w, a, "Line "+Str(a))
    ;     Next
    ;     Editor::SetFont(*w, FontID(0))
    
    
    SplitterGadget(10,8, 8, 306, 491-16, 0,g)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug no linux
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    ;Debug ""+GadgetHeight(0) +" "+ GadgetHeight(g)
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_Gadget
          If EventGadget() = 100
            Select EventType()
              Case #PB_EventType_LeftClick
                Define *E.Widget_S = GetGadgetData(g)
                Debug Len(*e\text[2]\String)
                Debug *e\text[2]\String
                ; ;                 If *w\index[2]-1 > 0
                ; ;                   SelectElement(*w\Items(), *w\index[2]-1)
                ; ;                   count = CountString(*w\items()\text\string, #CR$)
                ; ;                 EndIf
                ; ;                 
                ; ;                 SelectElement(*w\Items(), *w\index[2])
                ; ;                 ; если в предыдущей строке нет #CR$ то в начало получаемой строки добавляем #CR$
                ; ;                 ;                 Debug CountString(*w\items()\text\string, #CR$)
                ; ;                 ;                 Debug CountString(*w\items()\text\string, #LF$)
                ; ;                 
                ; ;                 If Not count
                ; ;                   Debug "string - "+#CR$+Mid(*w\text\string, *w\items()\text\pos+1, 2)
                ; ;                 Else
                ; ;                   Debug "string - "+Mid(*w\text\string, *w\items()\text\pos, 3)
                ; ;                 EndIf
                ; ;                 Debug "string2 - "+Mid(*w\text\string[2], *w\items()\text\pos+*w\items()\index, 3)
                ; ;                 
                ; ;                 
                ; ;                 ; ;                 With *w 
                ; ;                 ; ;                   Debug Left(\Text\String.s, \Items()\Text\Pos+\text\caret)
                ; ;                 ; ;                   Debug "----"
                ; ;                 ; ;                   Debug Right(\Text\String.s, \Text\Len-(\Items()\Text\Pos+\text\caret))
                ; ;                 ; ;                   Debug " ===== "+ \text\count
                ; ;                 ; ;                   Debug Left(\Text\String.s[2], \Items()\Text\Pos+\items()\index+\text\caret)
                ; ;                 ; ;                   Debug "----"
                ; ;                 ; ;                   Debug Right(\Text\String.s[2], Len(\Text\String.s[2])-(\Items()\Text\Pos+\items()\index+\text\caret))
                ; ;                 ; ;                 EndWith
                ; ;                 
                ; ;                 ;                With *w 
                ; ;                 ;                 Debug Left(\Text\String.s, \Items()\Text\Pos) + \Items()\Text[1]\String.s
                ; ;                 ;                 Debug "----"
                ; ;                 ;                 Debug \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Pos+\Items()\Text\Len))
                ; ;                 ;                 Debug " ====="
                ; ;                 ;                 Debug Left(\Text\String.s[2], \Items()\Text\Pos+\items()\index) + \Items()\Text[1]\String.s
                ; ;                 ;                 Debug "----"
                ; ;                 ;                 Debug \Items()\Text[3]\String.s + Right(\Text\String.s[2], Len(\Text\String.s[2])-(\Items()\Text\Pos+\items()\index+\Items()\Text\Len))
                ; ;                 ;                EndWith
                
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
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -------------------0f-f----------------------------
; EnableXP
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ----------vn--v8-------4---+-f------------8----------------
; EnableXP