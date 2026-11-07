
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   ;test_StatusChange  = 1
      
   Global a, CountItems = 10
   Global._s_WIDGET *g, *g1, *g2
   
   Procedure  DoEvent_Status2( status$, *this._s_WIDGET, *btn = #PB_All, *data = #Null )
      ; 1. Логирование отладки
      If test_StatusChange 
         Debug "[" + Str(*btn) + "] " + status$ 
      EndIf
      
      Protected._s_ROW *row = *data
      ; Защита: если данные строки не переданы, ничего не делаем
      If Not *row : ProcedureReturn : EndIf
      
      ; 2. Расчет визуального состояния строки (ColorState) на основе масок
      
      If *row\mask & #__MASK_Press
         *row\ColorState( ) = #__s_2 ; Цвет выделения/нажатия
      ElseIf *row\mask & #__MASK_Active
         ; Если строка активна (имеет фокус ввода)
         If *row = *this\RowFocused( ) And Not MousePress( )
;             If  MousePress( )
;                *row\ColorState( ) = #__s_3 ; Неактивное выделение (блеклый цвет)
;             Else
               If *this\mask & #__MASK_Active 
                  *row\ColorState( ) = #__s_2 ; Активное выделение (яркий цвет)
               EndIf
;             EndIf
         Else
            *row\ColorState( ) = #__s_3 ; Неактивное выделение (блеклый цвет)
         EndIf
      ElseIf *row\mask & #__MASK_Hover
        *row\ColorState( ) = #__s_1 ; Обычный цвет наведения (подсветка)
      Else
         ; Дефолтное состояние (мыши нет, фокуса нет)
          *row\ColorState( ) = #__s_0 ; Обычный цвет строки
      EndIf
      
      ; 3. Инвалидация (запрос на перерисовку виджета)
      repaint_set( *this )
      If  ListSize(__GUI\event\binds( ))
         Post(*this, #__EVENT_StatusChange, *btn, *data )
      Else
         AddEvents(*this, #__EVENT_StatusChange, *btn, *data )
      EndIf
   EndProcedure
   
   Procedure   PropertiesButton_Events( )
   EndProcedure
   
   Procedure   PropertiesButton_Resize( *g2._s_WIDGET )
      Protected._s_ROW *row = *g2\RowFocused( )
      Protected._s_WIDGET *this = GetData( *g2 )
      Protected result
      
      If *row
         If *this
            Debug 777
            result = Resize( *this,
                             *row\x,
                             *row\y + *g2\scroll_y( ),
                             *g2\inner_width( ),
                             *row\height, 0 )
         EndIf
      EndIf
      
      ProcedureReturn result
   EndProcedure
   
   Procedure   PropertiesButton_Free(*g2._s_WIDGET)
      Protected._s_WIDGET *this = GetData( *g2 )
      If *this
         Unbind(*this, @PropertiesButton_Events( ))
         Free( @*this )
      EndIf
   EndProcedure
   
   Procedure   PropertiesButton_Create( *g2._s_WIDGET,  *row._s_ROW )
      If *row
         Protected *this._s_WIDGET
         Protected Type = GetItemData( *g2, *row\index )
         Protected X = DesktopUnscaledX(*row\x)
         Protected Y = DesktopUnscaledY(*row\y + *g2\scroll_y( ))
         Protected Width = DesktopUnscaledX(*g2\inner_width( ))
         Protected Height = DesktopUnscaledY(*row\height)
         
         PropertiesButton_Free(*g2)
         OpenList(*g2)
         *this = Button(X,Y,Width,Height, *row\txt(0)\text)
         CloseList()
         If *this
            SetData( *g2, *this )
            SetData( *this, *row\index )
            Bind( *this, @PropertiesButton_Events( ))
         EndIf
         ProcedureReturn *this
      EndIf
   EndProcedure
   
   
   Procedure all_events()
      Static._s_WIDGET *this
      Protected._s_ROW *row
      *g = EventWidget( )
      *row = WidgetEventData( )
      
      If *row
         Select WidgetEvent( )
            Case #__EVENT_LeftDown
;                Debug "----"
               If *g = *g2
                  If SetState( *g, *row\index)
                     DoEvents( *g, #__EVENT_StatusChange, *row\index, *row )
                  EndIf
               EndIf
               
            Case #__EVENT_Change
              Debug "             ["+*row\index+"] "+*g\class +" change "
            ;  *this = PropertiesButton_Create(*g2, *row)
              ; Repaint()
               
            Case #__EVENT_StatusChange
               Select *g
                  Case *g1  : StatusChange( *g2, *row )
                  Case *g2  : StatusChange( *g1, *row )
               EndSelect
               ;Debug "             ["+*row\index+"] "+*g\class +" status "
               
            Case #__EVENT_Up
               ;                ForEach *g\row\__s( ) : *row = @*g\row\__s( )
               ;                   If *row\mask & #__MASK_Active
               ;                      Debug ""+*row\index +" Active" 
               ;                   EndIf
               ;                   If *row\mask & #__MASK_Press
               ;                      Debug ""+*row\index +" Press" 
               ;                   EndIf
               ;                Next
               
         EndSelect
      EndIf
   EndProcedure
   
   If Open(1, 100, 50, 400, 330, "demo items status", #PB_Window_SystemMenu)
      *g1 = Tree(10, 10, 150, 310, #__flag_nolines ) : SetClass(*g1, "*g1")
      *g2 = Tree(170, 10, 150, 310, #__flag_nolines ) : SetClass(*g2, "*g2")
      
      For a = 0 To CountItems
         AddItem(*g1, -1, "item "+Str(a), -1, 0)
      Next
      For a = 0 To CountItems
         AddItem(*g2, -1, "item "+Str(a), -1, 0)
      Next
      
      ;  
     SetState(*g1, CountItems) : SetActive(*g1)
     ; SetState(*g2, CountItems) : SetActive(*g2)
     
;      Define._s_ROW *row
;      ForEach *g1\row\__s( ) : *row = @*g1\row\__s( )
;            Debug ""+*row\index +"  " + *row\ColorState( )
;            
;            If *row\mask & #__MASK_Active
;            Debug ""+*row\index +" Active" 
;         EndIf
;         If *row\mask & #__MASK_Press
;            Debug ""+*row\index +" Press" 
;         EndIf
;      Next
     
     Button(330, 10, 60, 30,"multi")
     Button(330, 50, 60, 30,"click")
     Button(330, 90, 60, 30,"single")
      ;
      Bind(*g1, @all_events(), #__EVENT_LeftDown)
      Bind(*g2, @all_events(), #__EVENT_LeftDown)
      Bind(*g1, @all_events(), #__EVENT_Up)
      Bind(*g2, @all_events(), #__EVENT_Up)
      
      Bind(*g1, @all_events(), #__EVENT_StatusChange)
      Bind(*g2, @all_events(), #__EVENT_StatusChange)
      
      Bind(*g1, @all_events(), #__EVENT_Change)
      Bind(*g2, @all_events(), #__EVENT_Change)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 181
; FirstLine = 131
; Folding = 0----
; EnableXP
; DPIAware