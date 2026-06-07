
IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure EventsHandler( )
      Protected event = WidgetEvent( ) 
      Protected g = EventWidget( )
   EndProcedure
   
   If Open(0, 0, 0, 500, 500, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ; 2. Создаем второй пустой контейнер
      Define CONTAINER_1 = Panel( 5, 170, 200, 150 )
      AddItem(CONTAINER_1, -1, "0-tab")
      Define BUTTON_0 = Button( 10, 10, 180, 50, "B1")
      AddItem(CONTAINER_1, -1, "1-tab")
      CloseList( )
      
       SetParent(BUTTON_0, CONTAINER_1, 1)
       SetParent(BUTTON_0, CONTAINER_1, 0)
;       ;SetParent(BUTTON_0, CONTAINER_1, 1) : SetState(CONTAINER_1, 1)
      
      Debug "----------next------------"
      Define *root._s_ROOT = Root( )
      Define *e._s_WIDGET = *root\first
      While *e
         Debug "  "+*e\class +" "+ *e\text\Str(0)
         *e = *e\next[0]
      Wend
      Debug "----------prev------------"
      Define._s_WIDGET *e = GetLast(*root) ; *root\last\last ; 
      While *e
         Debug "  "+*e\class +" "+ *e\text\Str(0)
         *e = *e\prev[0]
         If *e = *root : Break : EndIf
      Wend
      Debug "----------end-------------"
      
      WaitClose( @EventsHandler( ))
   EndIf
CompilerEndIf
; 
; IncludePath "../../../"
; XIncludeFile "widgets.pbi"
; 
; ;- EXAMPLE
; CompilerIf #PB_Compiler_IsMainFile
;    EnableExplicit
;    UseWidgets( )
;    
;    Procedure EventsHandler( )
;       Protected event = WidgetEvent( ) 
;       Protected g = EventWidget( )
;    EndProcedure
;    
;    If Open(0, 0, 0, 500, 500, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
;       ; 1. Создаем первый пустой контейнер
;       Define CONTAINER_0 = Container( 5, 5, 200, 150 )
;       Define BUTTON_0 = Button( 10, 10, 180, 50, "B0")
;       CloseList( )
;       
;       ; 2. Создаем второй пустой контейнер
;       Define CONTAINER_1 = Panel( 5, 170, 200, 150 )
;       AddItem(CONTAINER_1, -1, "0-tab")
;       AddItem(CONTAINER_1, -1, "1-tab")
;       CloseList( )
;       
;       ; 3. Создаем второй пустой контейнер
;       Define CONTAINER_2 = Container( 5, 340, 200, 150 )
;       CloseList( )
;       
;       ; --- ПРОВЕРКА 1 ---
;       ; Динамически добавляем ПЕРВУЮ кнопку в CONTAINER_0 (тут *after = #Null)
;       OpenList( CONTAINER_1,0 )
;       Define BUTTON_0 = Button( 10, 10, 180, 50, "B1")
;       CloseList( )
;       
;       ; --- ПРОВЕРКА 2 ---
;       ; Динамически добавляем ПЕРВУЮ кнопку в CONTAINER_1 (тут *after = #Null)
;       OpenList( CONTAINER_2 )
;       Define BUTTON_2 = Button( 10, 10, 180, 50, "B3")
;       CloseList( )
;       
;       ; --- ПРОВЕРКА 3 ---
;       ; Добавляем ВТОРУЮ кнопку в CONTAINER_0, чтобы проверить, что цепочка не порвалась
;       OpenList( CONTAINER_1,1 )
;       Define BUTTON_1 = Button( 10, 70, 180, 50, "B2")
;       CloseList( )
;       
;       ;1. TEST
;        Hide(CONTAINER_1, 1)
;        Hide(CONTAINER_1, 0)
;       
;       ;          Debug GetText(GetLast(CONTAINER_1,0))
;       ;          Debug GetText(GetLast(CONTAINER_1,1))
;       ;          Debug GetClass(GetLast(CONTAINER_1,0))
;       ;          Debug GetClass(GetLast(CONTAINER_1,1))
;       
;       Debug "----------next------------"
;       Define *root._s_ROOT = Root( )
;       Define *e._s_WIDGET = *root\first
;       While *e
;          Debug "  "+*e\class +" "+ *e\text\Str(0)
;          *e = *e\next[0]
;       Wend
;       Debug "----------prev------------"
;       Define._s_WIDGET *e = GetLast(*root) ; BUTTON_2
;       While *e
;          Debug "  "+*e\class +" "+ *e\text\Str(0)
;          *e = *e\prev[0]
;       Wend
;       Debug "----------end-------------"
;       
;       WaitClose( @EventsHandler( ))
;    EndIf
; CompilerEndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 34
; FirstLine = 12
; Folding = -
; EnableXP
; DPIAware