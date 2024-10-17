; ------------------------------------------------------------------
;
;   Example for Drag & Drop inside a TreeGadget to reorder items.
;
;   Requires 4.10 beta or newer to run
;
; ------------------------------------------------------------------
IncludePath "../../../"
XIncludeFile "widgets.pbi"

EnableExplicit
Uselib(widget)




Global *tree 
Global ChildCount
Global SourceItem, SourceLevel
Global TargetItem, TargetLevel

#Window = 0

; If you want to do multiple drag&drop in different Gadgets of your program,
; you can use different values here so the events do not collide.
; (ie so the user cannot drag to the wrong gadget)
;
; Если вы хотите сделать несколько перетаскиваний в разные гаджеты вашей программы,
; вы можете использовать здесь разные значения, чтобы события не сталкивались.
; (т.е. чтобы пользователь не мог перетащить не тот гаджет)
#PrivateType = 0

#TabsDistance = 0

#ColTab = 8421504
#ColSwp = 255
#ColBar = 16777215

Structure TAB
  height.i
  y.i
  OffsetMove   .i
  OffsetMoveMin.i
  OffsetMoveMax.i
  Text         .s
EndStructure

;Global NewList Tabs.TAB()
Global *TabSwap    ._s_ROWS
Global *Tab        ._s_ROWS
Global BarWi       .i
Global MouseX      .i
Global MouseY      .i
Global MouseDownX  .i
Global MouseDownY  .i
Global TabsWi      .i

Macro Tabs( )
  *this\_rows( )
EndMacro

Procedure DrawBar (*this._s_widget)
  Protected Y.i, x
  Protected *Tab      ._s_ROWS
  ;ProcedureReturn 
  ;Calc Y
;   If *TabSwap = 0
;     ForEach Tabs()
;       Tabs()\Y = Y + *this\y[#__c_inner]
;       Y + Tabs()\height + #TabsDistance
;     Next
;   EndIf
  
 ; StartDrawing (CanvasOutput (*this\_root( )\canvas\gadget))
  x = *this\x[#__c_inner]
  y = *this\y[#__c_inner]
  
  ;Draw background
  DrawingMode (#PB_2DDrawing_Default)
  ;Box (0, 0, GadgetWidth (*this\_root( )\canvas\gadget), GadgetHeight (*this\_root( )\canvas\gadget), #ColBar)
  
;   ;Draw tabs
;   ForEach  Tabs() 
;     If Tabs() <> *TabSwap
;       DrawingMode (#PB_2DDrawing_Default)
;       Box      ( x+Tabs()\x, y+Tabs()\Y + Tabs()\OffsetMove, 280-20, Tabs()\height, #ColTab)
;       DrawingMode (#PB_2DDrawing_Transparent)
;       DrawText ( x+Tabs()\x + Tabs()\text\x, y+Tabs()\y + Tabs()\text\y + Tabs()\OffsetMove + 2, Tabs()\text\string)
;     EndIf
;   Next
  
  ;Draw swapping tab
  If *TabSwap
    DrawingMode (#PB_2DDrawing_AlphaBlend)
    Box      ( x+*TabSwap\x, y+*TabSwap\Y + *TabSwap\OffsetMove, 280-20, *TabSwap\height, $70000000 | #ColSwp)
    DrawingMode (#PB_2DDrawing_Transparent)
    DrawText ( x+*TabSwap\x + *TabSwap\text\x, y+*TabSwap\Y + *TabSwap\text\y + *TabSwap\OffsetMove + 2, *TabSwap\text\string)
  EndIf
  
 ; StopDrawing ()
  
EndProcedure


Procedure DrawBarEvents( )
  Protected y, *this._s_widget = EventWidget( )
  Protected EventType = WidgetEvent( )
  
  MouseX = Mouse()\x 
  MouseY = Mouse()\y 
  ;Debug MouseY
  
    
  ;_________
  ;Left down
  ;¯¯¯¯¯¯¯¯¯
  
  If EventType = #__event_LeftButtonDown
    ;\\ Store MouseDown
    MouseDownX = MouseX
    MouseDownY = MouseY
    
;     ;\\ Find TabSwap
;     ForEach Tabs() 
;       If MouseX >= Tabs()\Y And 
;          MouseX < Tabs()\Y + Tabs()\height
;         *TabSwap = @Tabs()
;       EndIf
;     Next
    
    *TabSwap = *this\RowEntered( )
    
    If *TabSwap
;       ;\\ Align all tabs to bottom (without TabSwap)
;       ForEach Tabs() 
;         If Tabs() = *TabSwap 
;           Break 
;         EndIf
;         Tabs()\Y + *TabSwap\height + #TabsDistance
;       Next
      
      ;Calc OffsetMoveMin/Max
      ForEach Tabs() 
        If Tabs() <> *TabSwap
          Tabs()\OffsetMoveMin = *this\scroll_height( ) - Tabs()\Y
          Tabs()\OffsetMoveMax = 0;Tabs()\OffsetMoveMin + *TabSwap\height + #TabsDistance
          ;TabsWi = *this\scroll_height( ) ;+ Tabs()\height + #TabsDistance
          Debug "  Min/Max "+Tabs()\OffsetMoveMin +" "+ Tabs()\OffsetMoveMax
        EndIf
      Next
      
      ;Calc OffsetMoveMin/Max for TabSwap
      *TabSwap\OffsetMoveMin = - *TabSwap\Y
      *TabSwap\OffsetMoveMax = *TabSwap\OffsetMoveMin - *TabSwap\height + *this\scroll_height( )
      Debug "Min/Max "+*TabSwap\OffsetMoveMin +" "+ *TabSwap\OffsetMoveMax
    EndIf
    
  EndIf
  
  ;__________
  ;Mouse move
  ;¯¯¯¯¯¯¯¯¯¯
  
  If EventType = #__event_MouseMove
    If *TabSwap
      ;*TabSwap\OffsetMove = (MouseY - MouseDownY)
      
      ForEach Tabs() 
        ;\\ Calc OffsetMove
        If Tabs() = *TabSwap
          Tabs()\OffsetMove = (MouseY - MouseDownY)
        Else
          Tabs()\OffsetMove = Tabs()\Y - *TabSwap\OffsetMove 
          Tabs()\OffsetMove - *TabSwap\Y - (*TabSwap\height + #TabsDistance)
          Tabs()\OffsetMove * (*TabSwap\height + #TabsDistance) / (Tabs()\height + #TabsDistance)
        EndIf
        
        ;Limit OffsetMove to minimum
        If Tabs()\OffsetMove < Tabs()\OffsetMoveMin
          Tabs()\OffsetMove = Tabs()\OffsetMoveMin
        EndIf
        
        ;Limit OffsetMove to maximum
        If Tabs()\OffsetMove > Tabs()\OffsetMoveMax
          Tabs()\OffsetMove = Tabs()\OffsetMoveMax
        EndIf
      Next
      
      ;     ;\\ Draw bar
      ;     DrawBar (*this)
    EndIf
  EndIf
  
  ;_______
  ;Left up
  ;¯¯¯¯¯¯¯
  
  If EventType = #__event_LeftButtonUp
    
    ;Sum-up Offsets and sort list
    ForEach Tabs()
      Tabs()\Y + Tabs()\OffsetMove
      ;Debug ""+Tabs()\OffsetMove+" "+Tabs()\text\string
      Tabs()\OffsetMove = 0
    Next
    
    SortStructuredList (Tabs(), #PB_Sort_Ascending, OffsetOf (Tab\Y), TypeOf (Tab\Y))
    
    ;Resets variables
    TabsWi         = 0
    *TabSwap       = 0
    MouseDownX     = 0
    MouseDownY     = 0
    
;     ;Draw bar
;     DrawBar (*this)
    
  EndIf
  
  
  If EventType = #__event_Draw
    If *this
      ;Draw bar
    DrawBar (*this)
  EndIf
EndIf
  
EndProcedure

Procedure events( )
  Protected i, Text$, Level, CountItems
  
  If EventWidget( ) = *tree                     
    Select WidgetEvent( ) 
      Case #__event_Change
        Debug "change - "+ GetState(*tree) +" "+ GetText(*tree) +" "+ GetItemText(*tree, GetState(*tree))
        
      Case #__event_DragStart 
        ; 
        ; The DragStart event tells us that the user clicked on an item and
        ; wants to start draging it. We save this item for later use and
        ; start our private drag
        ;
        ; Событие DragStart сообщает нам, что пользователь щелкнул элемент и
        ; хочет начать тащить его. Мы сохраняем этот элемент для последующего использования и
        ; начать нашу частную перетаскивание
        ;
        SourceItem = GetState(*tree)
        If DragPrivate(#PrivateType, #PB_Drag_Move)
          Protected img =- 1
          SelectElement(EventWidget( )\_rows( ), SourceItem)
          img = CreateImage(#PB_Any, EventWidget( )\_rows( )\text\width, EventWidget( )\_rows( )\text\height, 32, #PB_Image_Transparent )
          StartDrawing(ImageOutput(img))
          DrawingMode( #PB_2DDrawing_AllChannels)
          DrawText(0, 0, EventWidget( )\_rows( )\text\string, $ff000000)
          StopDrawing()
          If IsImage(img)
            SetCursor( *tree, Cursor::Create( ImageID(img), EventWidget( )\_rows( )\text\width/2, EventWidget( )\_rows( )\text\height/2 ))
          EndIf
        EndIf
        
      Case #__event_Drop 
        ;
        ; Here we get a drop event. Make sure it is on the right gadget and of right type,
        ; especially if you have multiple Drag & Drop stuff in your program.
        ;
        ; Здесь мы получаем событие падения. Убедитесь, что он находится на правильном гаджете и имеет правильный тип,
        ; особенно если в вашей программе есть несколько элементов Drag & Drop.
        ;
        If EventDropType( ) = #PB_Drop_Private And
           EventDropPrivate( ) = #PrivateType
          Debug "start drop - "+ GetState(*tree) +" "+ GetText(*tree) +" "+ GetItemText(*tree, GetState(*tree))
          
          TargetItem = GetState(*tree)        
          
          ; nothing to do if source and target are equal
          ;
          ; ничего не делать, если источник и цель равны
          ;
          If SourceItem <> TargetItem        
            CountItems = CountItems(*tree) - 1
            ; Find out to which index and sublevel to move the item
            ;
            ; Узнайте, на какой индекс и подуровень переместить элемент
            ;
            If TargetItem = - 1
              ; if dropped on the empty area, append at the end
              ;
              ; если упал на пустое место, добавить в конце
              TargetItem  = CountItems + 1
              TargetLevel = 0
              
            ElseIf Left( GetItemText(*tree, TargetItem), 4 ) = "Item"      
              ; if dropped on an "Item", move right after this item
              ;
              ; если упал на «предмет», переместиться сразу после этого предмета
              TargetLevel = GetItemAttribute(*tree, TargetItem, #PB_Tree_SubLevel)
              TargetItem  + 1
              
            Else
              ; if dropped on a "Directory", move into the directory and to the end of it
              ; all this can be easily done by examining the sublevel
              ;
              ; если вы попали в «Каталог», перейдите в каталог и в его конец
              ; все это можно легко сделать, изучив подуровень
              TargetLevel = GetItemAttribute(*tree, TargetItem, #PB_Tree_SubLevel) + 1
              TargetItem + 1
              While GetItemAttribute(*tree, TargetItem, #PB_Tree_SubLevel) >= TargetLevel
                TargetItem + 1
              Wend
            EndIf
            
            ; Find out how many children our source item has, as we want to
            ; move them all. If you do not allow moving of directory nodes, it gets 
            ; much simpler as there is only one delete + add then.
            ;
            ; childnodes are all directly following ones with a higher level
            ;
            ; Узнайте, сколько дочерних элементов имеет наш исходный элемент, поскольку мы хотим
            ; переместить их всех. Если вы не разрешаете перемещение узлов каталога, он получает
            ; намного проще, так как есть только одно удаление + добавление.
            ;
            ; дочерние узлы следуют непосредственно за узлами с более высоким уровнем
            ;
            SourceLevel = GetItemAttribute(*tree, SourceItem, #PB_Tree_SubLevel)          
            ChildCount  = 0
            For i = SourceItem+1 To CountItems
              If GetItemAttribute(*tree, i, #PB_Tree_SubLevel) > SourceLevel 
                ChildCount + 1
              Else
                Break
              EndIf
            Next i
            
            ;Debug "   ChildCount "+ ChildCount +" "+ SourceItem
            
            ; Note: because by adding new items, the index of our old ones changes,
            ;   we need to make a distinction here wether we move before or after our old item.
            ;   Note also that we cannot move an item into one of its childs, which we
            ;   prevent by this check as well.
            ;
            ; We copy first the source item and all children to the new location and then
            ; delete the source item.
            ;
            ; Примечание: поскольку при добавлении новых элементов изменяется индекс наших старых,
            ; нам нужно сделать различие здесь, перемещаемся ли мы до или после нашего старого элемента.
            ; Обратите также внимание, что мы не можем переместить элемент в один из его дочерних элементов, что мы
            ; предотвратить с помощью этой проверки, а также.
            ;
            ; Сначала мы копируем исходный элемент и все дочерние элементы в новое место, а затем
            ; удалить исходный элемент.
            ;
            If TargetItem > SourceItem + ChildCount + 1
              ;
              ; The target index is higher than the source one, so the source items are not
              ; affected by adding the new items in this case...
              ;
              ; Целевой индекс выше исходного, поэтому исходные элементы не
              ; затронуты добавлением новых элементов в этом случае...
              ;
              For i = 0 To ChildCount  
                ; copy everything here (also colors and GetItemData() etc if you use that)                
                ;
                ; скопируйте все сюда (также цвета и GetItemData() и т. д., если вы используете это)
                Text$ = GetItemText(*tree, SourceItem+i)              
                Level = GetItemAttribute(*tree, SourceItem+i, #PB_Tree_SubLevel) - SourceLevel + TargetLevel
                AddItem(*tree, TargetItem+i, Text$, 0, Level)              
              Next i
              
              ; We apply the state of each item AFTER all items are copied.
              ; This must be in a separate loop, as else the "expanded" state of the items is 
              ; not preserved, as the childs were not added yet in the above loop.
              ;
              ; Мы применяем состояние каждого элемента ПОСЛЕ того, как все элементы скопированы.
              ; Это должно быть в отдельном цикле, иначе "расширенное" состояние элементов
              ; не сохраняется, так как дочерние элементы еще не были добавлены в указанный выше цикл.
              For i = 0 To ChildCount
                SetItemState(*tree, TargetItem+i, GetItemState(*tree, SourceItem+i))
              Next i
              
              ; remove the source item. This automatically removes all children as well.
              ; удалить исходный элемент. Это также автоматически удаляет всех детей.
              RemoveItem(*tree, SourceItem)
              
              ; select the target. Note that the index is now 'ChildCount+1' less
              ; because of the remove of the source which was before the target
              ;
              ; выберите цель. Обратите внимание, что индекс теперь меньше на «ChildCount+1».
              ; из-за удаления источника, который был до цели
              SetState(*tree, TargetItem - ChildCount - 1)
              
            ElseIf TargetItem <= SourceItem
              ; 
              ; Second case: Target is lower than source. This means that each time
              ; we add a target item, the source items index increases by 1 as well,
              ; this is why we read the source items with the "SourceItem+i*2"
              ;
              ; Второй случай: цель ниже источника. Это означает, что каждый раз
              ; мы добавляем целевой элемент, индекс исходных элементов также увеличивается на 1,
              ; вот почему мы читаем исходные элементы с "SourceItem+i*2"
              ;
              For i = 0 To ChildCount
                Text$ = GetItemText(*tree, SourceItem+i*2)
                Level = GetItemAttribute(*tree, SourceItem+i*2, #PB_Tree_SubLevel) - SourceLevel + TargetLevel
                AddItem(*tree, TargetItem+i, Text$, 0, Level)
              Next i
              
              ; Loop for the states. Note that here the index of the sourceitems is 
              ; 'ChildCount+1' higher than before because of the added targets
              ;
              ; Цикл для состояний. Обратите внимание, что здесь индекс исходных элементов
              ; 'ChildCount+1' больше, чем раньше, из-за добавленных целей
              ;
              For i = 0 To ChildCount
                SetItemState(*tree, TargetItem+i, GetItemState(*tree, SourceItem+ChildCount+1+i))
              Next i            
              
              ; remove source and select target. Here the target index is not affected by the remove as it is lower
              ;
              ; удалить источник и выбрать цель. Здесь целевой индекс не затрагивается удалением, так как он ниже
              RemoveItem(*tree, SourceItem+ChildCount+1)          
              SetState(*tree, TargetItem)
              
            EndIf
            
          EndIf      
          Debug "stop drop - "+ GetState(*tree) +" "+ GetText(*tree) +" "+ GetItemText(*tree, GetState(*tree))
          
          Debug ""
          ;ClearDebugOutput()
          Define *this._s_widget = *tree
          ForEach *this\_rows( )
            Debug ""+ *this\_rows( )\index +" "+ ListIndex(*this\_rows( )) +" "+ *this\_rows( )\text\string +""
          Next
        EndIf
        
        
    EndSelect
    
  EndIf
  
  
EndProcedure

If Open(#Window, 0, 0, 300, 500, "TreeGadget Drag & Drop", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)
  *tree = Tree( 10, 10, 280, 480, #PB_Tree_NoLines|#PB_Tree_NoButtons|#__flag_GridLines)
  
  ; Add some items. We will be able to move items into the
  ; "Directory" ones.
  ;
  ; Добавьте несколько предметов. Мы сможем перемещать предметы в
  ; "справочные".
  ;
  Define i, event
  ;   For i = 0 To 20
  ;     If i % 5 = 0
  ;       AddItem(*tree, -1, "Directory" + Str(i), 0, 0)
  ;     Else
  ;       AddItem(*tree, -1, "Item" + Str(i), 0, 0)
  ;     EndIf
  ;   Next i
  
  ;   AddItem(*tree, -1, "Directory" + Str(0), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(1), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(2), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(3), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(4), 0, 0)
  ;   AddItem(*tree, -1, "Directory" + Str(5), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(6), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(7), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(8), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(9), 0, 0)
  ;   AddItem(*tree, -1, "Directory" + Str(10), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(11), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(12), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(13), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(14), 0, 0)
  ;   AddItem(*tree, -1, "Directory" + Str(15), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(16), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(17), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(18), 0, 0)
  ;   AddItem(*tree, -1, "Item" + Str(19), 0, 0)
  ;   AddItem(*tree, -1, "Directory" + Str(20), 0, 0)
  ;   
  
;   AddItem(*tree, -1, "Directory" + Str(0), 0, 0)
;   AddItem(*tree, -1, "Item" + Str(1), 0, 0)
;   AddItem(*tree, -1, "Item" + Str(2), 0, 0)
;   AddItem(*tree, -1, "Item" + Str(3), 0, 0)
;   AddItem(*tree, -1, "Item" + Str(7), 0, 0)
;   AddItem(*tree, -1, "Item" + Str(8), 0, 0)
;   AddItem(*tree, -1, "Item" + Str(9), 0, 0)
;   AddItem(*tree, -1, "Directory" + Str(10), 0, 0)
;   AddItem(*tree, -1, "Directory" + Str(5), 0, 1)
;   AddItem(*tree, -1, "Item" + Str(4), 0, 1)
;   AddItem(*tree, -1, "Item" + Str(6), 0, 1)
;   AddItem(*tree, -1, "Item" + Str(11), 0, 0)
;   AddItem(*tree, -1, "Item" + Str(12), 0, 0)
;   AddItem(*tree, -1, "Item" + Str(13), 0, 0)
;   AddItem(*tree, -1, "Item" + Str(14), 0, 0)
;   AddItem(*tree, -1, "Directory" + Str(15), 0, 0)
;   AddItem(*tree, -1, "Item" + Str(16), 0, 0)
;   AddItem(*tree, -1, "Item" + Str(17), 0, 0)
;   AddItem(*tree, -1, "Item" + Str(18), 0, 0)
;   AddItem(*tree, -1, "Item" + Str(19), 0, 0)
;   AddItem(*tree, -1, "Directory" + Str(20), 0, 0)
  
  AddItem(*tree, -1, "0 - 20", 0, 0)
  AddItem(*tree, -1, "1 - 20", 0, 0)
  AddItem(*tree, -1, "2 - 20", 0, 0)
  AddItem(*tree, -1, "3 - 20", 0, 0)
  AddItem(*tree, -1, "4 - 20", 0, 0)
  SetFrame(*tree, 0)
  
  ; this enables dropping our private type with a move operation
  ; это позволяет переместить наш частный тип с помощью операции перемещения
  EnableDrop(*tree, #PB_Drop_Private, #PB_Drag_Move, #PrivateType)
  
  ;Bind( *tree, @events( ) )
  
  Bind( *tree, @DrawBarEvents( ), #__event_Draw )
  Bind( *tree, @DrawBarEvents( ), #__event_LeftButtonDown )
  Bind( *tree, @DrawBarEvents( ), #__event_LeftButtonUp )
  Bind( *tree, @DrawBarEvents( ), #__event_MouseMove )
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
EndIf

End
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 130
; FirstLine = 127
; Folding = -----
; EnableXP
; DPIAware