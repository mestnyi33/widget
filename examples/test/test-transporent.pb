XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
	UseWidgets( )
	
	Global *Button_0, *String_0, *String_0, *String_1, *String_2, *String_3, *String_4
	
	Procedure gadget_evnts( ) 
		; ; 		Open_Window_0() ; Вызываем процедуру.
		; ; 		
		; ; 		Repeat ; Начало цикла Repeat - Until.
		; 			Event  = WaitWindowEvent() ; Узнаём текущее событие в программе.
		Gadget = EventWidget( ) ; EventGadget()		 ; Узнаём идентификатор активного гаджета.
		Type   = WidgetEvent( ) ; EventType()			 ; Узнаём тип события.
																; 			
																; 			If Event=#PB_Event_Gadget ; Условие будет выполнено если произойдёт событие в одном из гаджетов
																; 				
		If type = #__event_LeftClick
			If Gadget=*Button_0 ; Условие будет выполнено если нажата экранная кнопка "Рассчитать"
													; Читаем текст из полей ввода данных (StringGadget)
				
				String0.s=GetText(*String_0) ; Поле "Радиус роторной пластины"
				String1.s=GetText(*String_1) ; Поле Радиус выреза в статорной пластине"
				String2.s=GetText(*String_2) ; Поле "Расстояние между пластинами"
				String3.s=GetText(*String_3) ; Поле "Число пластин"
																		 ; Преобразовываем текст в числа
				R.f=ValF(String0) : R1.f=ValF(String1)
				D.f=ValF(String2) : N.f   = ValF(String3)
				; Условие будет выполнено при ошибке в заполнении поля
				If R=0 Or R1=0 Or D=0 Or N=0
					MessageRequester("Ошибка","Одно из полей не заполнено или введены некорректные значения!",16)
				Else
					; Если ошибок нет, тогда производим вычисления
					C.f=0.14*(( Pow(R,2)-Pow(R1,2) )*(N-1))/D
					SetText(*String_4,StrF(C,2)) ; Выводим на экран результат
					SetColor(*String_4 , #PB_Gadget_BackColor , RGB(244, 245, 244) ) ; Делаем белым фон в гаджете с идентификатором *String_4
				EndIf
			EndIf
		EndIf
		
		; Условие будет выполнено при событии в одном из полей ввода данных (кроме того, в котором отображается результат)
		If Type=#__event_Change ; Был изменён текст.
			If Gadget=*String_0 Or Gadget=*String_1 Or Gadget=*String_2 Or Gadget=*String_3
				SetColor(*String_4 , #__Color_Back , RGB(255, 175, 174) ) ; Делаем красным фон в гаджете с идентификатором *String_4
			EndIf
		EndIf
		; 				
		; 			EndIf
		; ; 			
		; ; 		Until Event=#PB_Event_CloseWindow ; Прерываем работу программы при попытке закрыть окно.
		; ; 		End																; Завершаем работу программы.
	EndProcedure
	
	
	
	
	
	If Open(0, 247, 153, 355, 250, "Расчёт КПЕ",  #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered )
		Text(15, 20, 180, 15, "Радиус роторной пластины  см.:", #__flag_Transparent)
		Text(15, 45, 225, 15, "Радиус выреза в статорной пластине  см.:", #__flag_Transparent)
		Text(15, 70, 195, 15, "Расстояние между пластинами  см.:", #__flag_Transparent)
		Text(15, 95, 85, 15, "Число пластин:", #__flag_Transparent)
		Text(15, 190, 200, 30, "Максимальная ёмкость переменного конденсатора  пф.:", #__flag_Transparent)
		*String_0 = String(255, 15, 85, 20, " ")
		*String_1 = String(255, 40, 85, 20, " ")
		*String_2 = String(255, 65, 85, 20, " ")
		*String_3 = String(255, 90, 85, 20, " ")
		*String_4 = String(255, 195, 85, 20, " ")
		*Button_0 = Button(130, 130, 80, 30, "Рассчитать")
		; ToolTip(#Button_1, "Узнаём результат расчета")
		
		Bind(#PB_All, @gadget_evnts())
		
		
		;SetColor(root(), #__color_back, $FFF7F7F7)
		
		; 		If StartEnumerate( root( ))
		; 			If WidgetType( widget( ) ) = #__type_Text
		; 				widget()\color\back =- 1
		; 				; SetColor(widget(), #__color_back, Root()\color\back)
		; 			EndIf
		; 			StopEnumerate( )
		; 		EndIf
	EndIf
	
	WaitClose( )
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 13
; FirstLine = 9
; Folding = --
; EnableXP
; DPIAware