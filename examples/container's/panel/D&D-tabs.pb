; ------------------------------------------------------------------
;
;   Example for Drag & Drop inside a PanelGadget to reorder items.
;
;   Requires 4.10 beta or newer to run
;
; ------------------------------------------------------------------
IncludePath "../../../"
XIncludeFile "widgets.pbi"

EnableExplicit
UseWidgets( )

Global *Panel 
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
#PB_Item_Sublevel = #PB_Tree_SubLevel

Procedure events( )
  Protected i, Text$, Level, CountItems
  
  If EventWidget( ) = *Panel                     
    Select WidgetEvent( ) 
      Case #PB_EventType_DragStart 
        ; 
        ; The DragStart event tells us that the user clicked on an item and
        ; wants to start draging it. We save this item for later use and
        ; start our private drag
        ;
        ; Событие DragStart сообщает нам, что пользователь щелкнул элемент и
        ; хочет начать тащить его. Мы сохраняем этот элемент для последующего использования и
        ; начать нашу частную перетаскивание
        ;
        SourceItem = GetState(*Panel)
        DragPrivate(#PrivateType, #PB_Drag_Move)
        
      Case #PB_EventType_Drop 
        ;
        ; Here we get a drop event. Make sure it is on the right gadget and of right type,
        ; especially if you have multiple Drag & Drop stuff in your program.
        ;
        ; Здесь мы получаем событие падения. Убедитесь, что он находится на правильном гаджете и имеет правильный тип,
        ; особенно если в вашей программе есть несколько элементов Drag & Drop.
        ;
        If EventDropType( ) = #PB_Drop_Private And EventDropPrivate( ) = #PrivateType
          TargetItem = GetState(*Panel)        
          
          ; nothing to do if source and target are equal
          ;
          ; ничего не делать, если источник и цель равны
          ;
          If SourceItem <> TargetItem        
            CountItems = CountItems(*Panel) - 1
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
              
            ElseIf Left( GetItemTextWidget(*Panel, TargetItem), 4 ) = "Item"      
              ; if dropped on an "Item", move right after this item
              ;
              ; если упал на «предмет», переместиться сразу после этого предмета
              TargetLevel = GetItemAttribute(*Panel, TargetItem, #PB_Item_SubLevel)
              TargetItem  + 1
              
            Else
              ; if dropped on a "Directory", move into the directory and to the end of it
              ; all this can be easily done by examining the sublevel
              ;
              ; если вы попали в «Каталог», перейдите в каталог и в его конец
              ; все это можно легко сделать, изучив подуровень
              TargetLevel = GetItemAttribute(*Panel, TargetItem, #PB_Item_Sublevel) + 1
              TargetItem + 1
              While GetItemAttribute(*Panel, TargetItem, #PB_Item_Sublevel) >= TargetLevel
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
            SourceLevel = GetItemAttribute(*Panel, SourceItem, #PB_Item_Sublevel)          
            ChildCount  = 0
            For i = SourceItem+1 To CountItems
              If GetItemAttribute(*Panel, i, #PB_Item_Sublevel) > SourceLevel 
                ChildCount + 1
              Else
                Break
              EndIf
            Next i
            
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
                Text$ = GetItemTextWidget(*Panel, SourceItem+i)              
                Level = GetItemAttribute(*Panel, SourceItem+i, #PB_Item_Sublevel) - SourceLevel + TargetLevel
                AddItem(*Panel, TargetItem+i, Text$, 0, Level)              
              Next i
              
              ; We apply the state of each item AFTER all items are copied.
              ; This must be in a separate loop, as else the "expanded" state of the items is 
              ; not preserved, as the childs were not added yet in the above loop.
              ;
              ; Мы применяем состояние каждого элемента ПОСЛЕ того, как все элементы скопированы.
              ; Это должно быть в отдельном цикле, иначе "расширенное" состояние элементов
              ; не сохраняется, так как дочерние элементы еще не были добавлены в указанный выше цикл.
              For i = 0 To ChildCount
                SetItemState(*Panel, TargetItem+i, GetItemState(*Panel, SourceItem+i))
              Next i
              
              ; remove the source item. This automatically removes all children as well.
              ; удалить исходный элемент. Это также автоматически удаляет всех детей.
              RemoveItem(*Panel, SourceItem)
              
              ; select the target. Note that the index is now 'ChildCount+1' less
              ; because of the remove of the source which was before the target
              ;
              ; выберите цель. Обратите внимание, что индекс теперь меньше на «ChildCount+1».
              ; из-за удаления источника, который был до цели
              SetState(*Panel, TargetItem - ChildCount - 1)
              
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
                Text$ = GetItemTextWidget(*Panel, SourceItem+i*2)
                Level = GetItemAttribute(*Panel, SourceItem+i*2, #PB_Item_Sublevel) - SourceLevel + TargetLevel
                AddItem(*Panel, TargetItem+i, Text$, 0, Level)
              Next i
              
              ; Loop for the states. Note that here the index of the sourceitems is 
              ; 'ChildCount+1' higher than before because of the added targets
              ;
              ; Цикл для состояний. Обратите внимание, что здесь индекс исходных элементов
              ; 'ChildCount+1' больше, чем раньше, из-за добавленных целей
              ;
              For i = 0 To ChildCount
                SetItemState(*Panel, TargetItem+i, GetItemState(*Panel, SourceItem+ChildCount+1+i))
              Next i            
              
              ; remove source and select target. Here the target index is not affected by the remove as it is lower
              ;
              ; удалить источник и выбрать цель. Здесь целевой индекс не затрагивается удалением, так как он ниже
              RemoveItem(*Panel, SourceItem+ChildCount+1)          
              SetState(*Panel, TargetItem)
              
            EndIf
            
          EndIf      
        EndIf
    EndSelect
    
  EndIf
  
  
EndProcedure

If OpenRootWidget(#Window, 0, 0, 300, 500, "TreeGadget Drag & Drop", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)
  *Panel = PanelWidget( 10, 10, 280, 480)
  
  ; Add some items. We will be able to move items into the
  ; "Directory" ones.
  ;
  ; Добавьте несколько предметов. Мы сможем перемещать предметы в
  ; "справочные".
  ;
  Define i, event
  For i = 0 To 20
    If i % 5 = 0
      AddItem(*Panel, -1, "Directory" + Str(i), 0, 0)
    Else
      AddItem(*Panel, -1, "Item" + Str(i), 0, 0)
    EndIf
  Next i
  
  ; this enables dropping our private type with a move operation
  ; это позволяет переместить наш частный тип с помощью операции перемещения
  EnableDDrop(*Panel, #PB_Drop_Private, #PB_Drag_Move, #PrivateType)
  
  BindWidgetEvent( *Panel, @events( ) )
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
EndIf

End
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 235
; FirstLine = 209
; Folding = --
; EnableXP