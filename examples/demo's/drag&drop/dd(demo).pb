XIncludeFile "../../../widgets.pbi" 

EnableExplicit
Uselib( Widget )

Enumeration   1 ; Images
  #ImageGadget_Source
  #ImageGadget_Target
EndEnumeration

#PrivateType_0 = 0
#PrivateType_1 = 1
#PrivateType_2 = 2

Global ChildCount
Global SourceItem, SourceLevel
Global TargetItem, TargetLevel
Global Gadget_SourceText,
       Gadget_SourceImage,
       Gadget_SourceFiles,
       Gadget_SourceItem,
       Gadget_SourcePrivate,
       Gadget_TargetText,
       Gadget_TargetImage,
       Gadget_TargetFiles,
       Gadget_TargetItem,
       Gadget_TargetPrivate1,
       Gadget_TargetPrivate2

Global i, Event, font = LoadFont( 0, "Aria", 13 )

;
; Create some images for the image demonstration
; 
CreateImage( #ImageGadget_Source, 136, 136 )
If StartDrawing( ImageOutput( #ImageGadget_Source ) )
  DrawingFont( font )
  
  Box( 0, 0, 136, 136, $FFFFFF )
  DrawText( 5, 5, "Drag this image", $000000, $FFFFFF )        
  For i = 45 To 1 Step -1
    Circle( 70, 80, i, Random( $FFFFFF ) )
  Next i        
  
  StopDrawing( )
EndIf  

CreateImage( #ImageGadget_Target, 136, 136 )
If StartDrawing( ImageOutput( #ImageGadget_Target ) )
  DrawingFont( font )
  
  Box( 0, 0, 136, 136, $FFFFFF )
  DrawText( 5, 5, "Drop images here", $000000, $FFFFFF )
  StopDrawing( )
EndIf  

Procedure Events( )
  Protected EventWidget.i = EventWidget( ),
            EventType.i = WidgetEventType( );,
                                            ;EventItem.i = this( )\item, 
                                            ;EventData.i = this( )\data
  
  Protected i, Text$, Files$, Count
  
  ; DragStart event on the Gadget_Source s, initiate a drag & drop
  ;
  Select EventType
    Case #PB_EventType_DragStart
      Debug  "Drag - " + EventWidget
      
      Select EventWidget
        Case Gadget_SourceItem
          Protected Level, CountItems
  ; 
        ; The DragStart event tells us that the user clicked on an item and
        ; wants to start draging it. We save this item for later use and
        ; start our private drag
        ;
        ; Событие DragStart сообщает нам, что пользователь щелкнул элемент и
        ; хочет начать тащить его. Мы сохраняем этот элемент для последующего использования и
        ; начать нашу частную перетаскивание
        ;
        SourceItem = GetState(Gadget_SourceItem)
        If DragPrivate(#PrivateType_0, #PB_Drag_Move)
          Protected img =- 1
          SelectElement(EventWidget( )\_rows( ), SourceItem)
          img = CreateImage(#PB_Any, EventWidget( )\_rows( )\text\width, EventWidget( )\_rows( )\text\height, 32, #PB_Image_Transparent )
          StartDrawing(ImageOutput(img))
          DrawingMode( #PB_2DDrawing_AllChannels)
          DrawText(0, 0, EventWidget( )\_rows( )\text\string, $ff000000)
          StopDrawing()
          If IsImage(img)
            SetCursor( Gadget_SourceItem, CreateCursor( ImageID(img), EventWidget( )\_rows( )\text\width/2, EventWidget( )\_rows( )\text\height/2 ))
          EndIf
        EndIf
        
        Case Gadget_SourceText
          Text$ = GetItemText( Gadget_SourceText, GetState( Gadget_SourceText ) )
          DragText( Text$ )
          
        Case Gadget_SourceImage
          DragImage( #ImageGadget_Source )
          
        Case Gadget_SourceFiles
          Files$ = ""       
          For i = 0 To CountItems( Gadget_SourceFiles )-1
            If GetItemState( Gadget_SourceFiles, i ) & #PB_Explorer_Selected
              ;; i = GetState( Gadget_SourceFiles )
              Files$ + GetText( Gadget_SourceFiles ) + GetItemText( Gadget_SourceFiles, i ) ; + Chr( 10 )
            EndIf
          Next i 
          
          If Files$ <> ""
            DragFiles( Files$ )
          EndIf
          
          ; "Private" Drags only work within the program, everything else
          ; also works with other applications ( Explorer, Word, etc )
          ;
        Case Gadget_SourcePrivate
          If GetState( Gadget_SourcePrivate ) = 0
            DragPrivate( 1 )
          Else
            DragPrivate( 2 )
          EndIf
          
      EndSelect
      
      ; Drop event on the Gadget_Target gadgets, receive the EventDrop data
      ;
    Case #PB_EventType_Drop
      Debug  "Drop - " + EventWidget
      ; clearitems(EventWidget)
      
      Select EventWidget
        Case Gadget_TargetItem
          ;
          ; Here we get a drop event. Make sure it is on the right gadget and of right type,
        ; especially if you have multiple Drag & Drop stuff in your program.
        ;
        ; Здесь мы получаем событие падения. Убедитесь, что он находится на правильном гаджете и имеет правильный тип,
        ; особенно если в вашей программе есть несколько элементов Drag & Drop.
        ;
        If EventDropType( ) = #PB_Drop_Private And
           EventDropPrivate( ) = #PrivateType_0
          Debug "start drop - "+ GetState(Gadget_TargetItem) +" "+ GetText(Gadget_TargetItem) +" "+ GetItemText(Gadget_TargetItem, GetState(Gadget_TargetItem))
          
          TargetItem = GetState(Gadget_TargetItem)        
          
          ; nothing to do if source and target are equal
          ;
          ; ничего не делать, если источник и цель равны
          ;
          If SourceItem <> TargetItem        
            CountItems = CountItems(Gadget_TargetItem) - 1
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
              
            ElseIf Left( GetItemText(Gadget_TargetItem, TargetItem), 4 ) = "Item"      
              ; if dropped on an "Item", move right after this item
              ;
              ; если упал на «предмет», переместиться сразу после этого предмета
              TargetLevel = GetItemAttribute(Gadget_TargetItem, TargetItem, #PB_Tree_SubLevel)
              TargetItem  + 1
              
            Else
              ; if dropped on a "Directory", move into the directory and to the end of it
              ; all this can be easily done by examining the sublevel
              ;
              ; если вы попали в «Каталог», перейдите в каталог и в его конец
              ; все это можно легко сделать, изучив подуровень
              TargetLevel = GetItemAttribute(Gadget_TargetItem, TargetItem, #PB_Tree_SubLevel) + 1
              TargetItem + 1
              While GetItemAttribute(Gadget_TargetItem, TargetItem, #PB_Tree_SubLevel) >= TargetLevel
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
            SourceLevel = GetItemAttribute(Gadget_TargetItem, SourceItem, #PB_Tree_SubLevel)          
            ChildCount  = 0
            For i = SourceItem+1 To CountItems
              If GetItemAttribute(Gadget_TargetItem, i, #PB_Tree_SubLevel) > SourceLevel 
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
                Text$ = GetItemText(Gadget_TargetItem, SourceItem+i)              
                Level = GetItemAttribute(Gadget_TargetItem, SourceItem+i, #PB_Tree_SubLevel) - SourceLevel + TargetLevel
                AddItem(Gadget_TargetItem, TargetItem+i, Text$, 0, Level)              
              Next i
              
              ; We apply the state of each item AFTER all items are copied.
              ; This must be in a separate loop, as else the "expanded" state of the items is 
              ; not preserved, as the childs were not added yet in the above loop.
              ;
              ; Мы применяем состояние каждого элемента ПОСЛЕ того, как все элементы скопированы.
              ; Это должно быть в отдельном цикле, иначе "расширенное" состояние элементов
              ; не сохраняется, так как дочерние элементы еще не были добавлены в указанный выше цикл.
              For i = 0 To ChildCount
                SetItemState(Gadget_TargetItem, TargetItem+i, GetItemState(Gadget_TargetItem, SourceItem+i))
              Next i
              
              ; remove the source item. This automatically removes all children as well.
              ; удалить исходный элемент. Это также автоматически удаляет всех детей.
              RemoveItem(Gadget_TargetItem, SourceItem)
              
              ; select the target. Note that the index is now 'ChildCount+1' less
              ; because of the remove of the source which was before the target
              ;
              ; выберите цель. Обратите внимание, что индекс теперь меньше на «ChildCount+1».
              ; из-за удаления источника, который был до цели
              SetState(Gadget_TargetItem, TargetItem - ChildCount - 1)
              
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
                Text$ = GetItemText(Gadget_TargetItem, SourceItem+i*2)
                Level = GetItemAttribute(Gadget_TargetItem, SourceItem+i*2, #PB_Tree_SubLevel) - SourceLevel + TargetLevel
                AddItem(Gadget_TargetItem, TargetItem+i, Text$, 0, Level)
              Next i
              
              ; Loop for the states. Note that here the index of the sourceitems is 
              ; 'ChildCount+1' higher than before because of the added targets
              ;
              ; Цикл для состояний. Обратите внимание, что здесь индекс исходных элементов
              ; 'ChildCount+1' больше, чем раньше, из-за добавленных целей
              ;
              For i = 0 To ChildCount
                SetItemState(Gadget_TargetItem, TargetItem+i, GetItemState(Gadget_TargetItem, SourceItem+ChildCount+1+i))
              Next i            
              
              ; remove source and select target. Here the target index is not affected by the remove as it is lower
              ;
              ; удалить источник и выбрать цель. Здесь целевой индекс не затрагивается удалением, так как он ниже
              RemoveItem(Gadget_TargetItem, SourceItem+ChildCount+1)          
              SetState(Gadget_TargetItem, TargetItem)
              
            EndIf
            
          EndIf      
          Debug "stop drop - "+ GetState(Gadget_TargetItem) +" "+ GetText(Gadget_TargetItem) +" "+ GetItemText(Gadget_TargetItem, GetState(Gadget_TargetItem))
          
          Debug ""
          ;ClearDebugOutput()
          Define *this._s_widget = Gadget_TargetItem
          ForEach *this\_rows( )
            Debug ""+ *this\_rows( )\index +" "+ ListIndex(*this\_rows( )) +" "+ *this\_rows( )\text\string +""
          Next
        EndIf
        
        Case Gadget_TargetText
          ;;Debug "EventDropText - "+ EventDropText( )
          If EnteredItem( )
            AddItem( Gadget_TargetText, EnteredItem( )\index, EventDropText( ) )
          Else
            AddItem( Gadget_TargetText, - 1, EventDropText( ) )
          EndIf
          
        Case Gadget_TargetImage
          If EventDropImage( #ImageGadget_Target )
            If StartDrawing( ImageOutput( #ImageGadget_Target ) )
              DrawingFont( font )
              
              Box( 5,5,OutputWidth(),30, $FFFFFF)
              DrawText( 5, 5, "EventDrop image", $000000, $FFFFFF )        
              
              StopDrawing( )
            EndIf  
            
            SetState( Gadget_TargetImage, ( #ImageGadget_Target ) )
          EndIf
          
        Case Gadget_TargetFiles
          Files$ = EventDropFiles( )
          Count  = CountString( Files$, Chr( 10 ) ) + 1
          
          For i = 1 To Count
            AddItem( Gadget_TargetFiles, -1, StringField( Files$, i, Chr( 10 ) ) )
          Next i
          
        Case Gadget_TargetPrivate1
          AddItem( Gadget_TargetPrivate1, -1, "Private type 1 EventDrop" )
          
        Case Gadget_TargetPrivate2
          AddItem( Gadget_TargetPrivate2, -1, "Private type 2 EventDrop" )
          
      EndSelect
      
      ;       If EventWidget = DD_DropPrivate( )
      ;         AddItem( DD_DropPrivate( ), -1, "Private type 2 EventDrop" )
      ;       EndIf
      
  EndSelect
  
EndProcedure

If Open( #PB_Any, 50, 50, 760+150, 310, "Drag & Drop", #PB_Window_SystemMenu )   
  ;Bind(, #PB_Default )
  ; Create and fill the Gadget_Source s
  ;
  Gadget_SourceText = ListIcon( 10, 10, 140, 140, "Drag Text here", 130 )   
  Gadget_SourceImage = Image( 160, 10, 140, 140, ( #ImageGadget_Source ), #PB_Image_Border ) 
  Gadget_SourceFiles = ExplorerList( 310, 10, 290, 140, GetHomeDirectory( ), #PB_Explorer_MultiSelect )
  Gadget_SourcePrivate = ListIcon( 610, 10, 140, 140, "Drag private stuff here", 260 )
  Gadget_SourceItem = ListIcon( 760, 10, 140, 290, "Drag item here", 130 )   
  
  SetFrame( Gadget_SourceText, 1 )
  SetFrame( Gadget_SourceImage, 1 )
  SetFrame( Gadget_SourceFiles, 1 )
  SetFrame( Gadget_SourcePrivate, 1 )
  SetFrame( Gadget_SourceItem, 1 )
  
;   ;
;   ;
   SetCursor( Gadget_SourceText, #PB_Cursor_Hand )
;   SetCursor( Gadget_SourceImage, #PB_Cursor_Hand )
;   SetCursor( Gadget_SourceFiles, #PB_Cursor_Hand )
;   SetCursor( Gadget_SourcePrivate, #PB_Cursor_Hand )
  
  ;
  AddItem( Gadget_SourceText, -1, "hello world" )
  AddItem( Gadget_SourceText, -1, "The quick brown fox jumped over the lazy dog" )
  AddItem( Gadget_SourceText, -1, "abcdefg" )
  AddItem( Gadget_SourceText, -1, "123456789" )
  AddItem( Gadget_SourceText, -1, "123456789" )
  AddItem( Gadget_SourceText, -1, "123456789" )
  AddItem( Gadget_SourceText, -1, "123456789" )
  AddItem( Gadget_SourceText, -1, "123456789" )
  AddItem( Gadget_SourceText, -1, "123456789" )
  AddItem( Gadget_SourceText, -1, "123456789" )
  AddItem( Gadget_SourceText, -1, "123456789" )
  
  For i = 0 To 20
    If i % 5 = 0
      AddItem(Gadget_SourceItem, -1, "Directory" + Str(i), 0, 0)
    Else
      AddItem(Gadget_SourceItem, -1, "Item" + Str(i), 0, 0)
    EndIf
  Next i
  
  AddItem( Gadget_SourcePrivate, -1, "Private type 1" )
  AddItem( Gadget_SourcePrivate, -1, "Private type 2" )
  
  ; Create the Gadget_Target s
  ;
  Gadget_TargetText = ListIcon( 10, 160, 140, 140, "Drop Text here", 130 )
  Gadget_TargetImage = Image( 160, 160, 140, 140, ( #ImageGadget_Target ), #PB_Image_Border ) 
  Gadget_TargetFiles = ListIcon( 310, 160, 140, 140, "Drop Files here", 130 )
  Gadget_TargetPrivate1 = ListIcon( 460, 160, 140, 140, "Drop Private Type 1 here", 130 )
  Gadget_TargetPrivate2 = ListIcon( 610, 160, 140, 140, "Drop Private Type 2 here", 130 )
  Gadget_TargetItem = Gadget_SourceItem
  
  
  SetFrame( Gadget_TargetText, 1 )
  SetFrame( Gadget_TargetImage, 1 )
  SetFrame( Gadget_TargetFiles, 1 )
  ;SetFrame( Gadget_TargetPrivate1, 1 )
  SetFrame( Gadget_TargetPrivate2, 1 )
  ; Now enable the dropping on the Gadget_Target s
  ;
  EnableDrop( Gadget_TargetText,     #PB_Drop_Text,    #PB_Drag_Copy )
  EnableDrop( Gadget_TargetImage,    #PB_Drop_Image,   #PB_Drag_Copy )
  EnableDrop( Gadget_TargetFiles,    #PB_Drop_Files,   #PB_Drag_Copy )
  EnableDrop( Gadget_TargetItem,     #PB_Drop_Private, #PB_Drag_Move, #PrivateType_0 )
  EnableDrop( Gadget_TargetPrivate1, #PB_Drop_Private, #PB_Drag_Copy, #PrivateType_1 )
  EnableDrop( Gadget_TargetPrivate2, #PB_Drop_Private, #PB_Drag_Copy, #PrivateType_2 )
  
  ; Bind( -1, @Events( ) )
  ;
  Bind( Gadget_SourceImage, @Events( ), #PB_EventType_DragStart )
  Bind( Gadget_TargetImage, @Events( ), #PB_EventType_Drop )
  
  Bind( Gadget_SourceText, @Events( ), #PB_EventType_DragStart )
  Bind( Gadget_TargetText, @Events( ), #PB_EventType_Drop )
  
  Bind( Gadget_SourceItem, @Events( ), #PB_EventType_DragStart )
  Bind( Gadget_TargetItem, @Events( ), #PB_EventType_Drop )
  
  Bind( Gadget_SourcePrivate, @Events( ), #PB_EventType_DragStart )
  Bind( Gadget_TargetPrivate1, @Events( ), #PB_EventType_Drop )
  Bind( Gadget_TargetPrivate2, @Events( ), #PB_EventType_Drop )
  
  ; main loop
  ;
  WaitClose( )
  ;   ReDraw( Root( ) )
  ;   
  ;   Repeat
  ;     Event = WaitWindowEvent( )
  ;   Until Event = #PB_Event_CloseWindow
EndIf

End
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --f-
; EnableXP