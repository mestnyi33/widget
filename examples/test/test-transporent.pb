XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
	UseWidgets( )
	
	Global *Button_0, *String_0, *String_0, *String_1, *String_2, *String_3, *String_4
	
	Procedure gadget_evnts( ) 
		; ; 		Open_Window_0() ; �������� ���������.
		; ; 		
		; ; 		Repeat ; ������ ����� Repeat - Until.
		; 			Event  = WaitWindowEvent() ; ����� ������� ������� � ���������.
		Gadget = EventWidget( ) ; EventGadget()		 ; ����� ������������� ��������� �������.
		Type   = WidgetEvent( ) ; EventType()			 ; ����� ��� �������.
																; 			
																; 			If Event=#PB_Event_Gadget ; ������� ����� ��������� ���� ��������� ������� � ����� �� ��������
																; 				
		If type = #__event_LeftClick
			If Gadget=*Button_0 ; ������� ����� ��������� ���� ������ �������� ������ "����������"
													; ������ ����� �� ����� ����� ������ (StringGadget)
				
				String0.s=GetText(*String_0) ; ���� "������ �������� ��������"
				String1.s=GetText(*String_1) ; ���� ������ ������ � ��������� ��������"
				String2.s=GetText(*String_2) ; ���� "���������� ����� ����������"
				String3.s=GetText(*String_3) ; ���� "����� �������"
																		 ; ��������������� ����� � �����
				R.f=ValF(String0) : R1.f=ValF(String1)
				D.f=ValF(String2) : N.f   = ValF(String3)
				; ������� ����� ��������� ��� ������ � ���������� ����
				If R=0 Or R1=0 Or D=0 Or N=0
					MessageRequester("������","���� �� ����� �� ��������� ��� ������� ������������ ��������!",16)
				Else
					; ���� ������ ���, ����� ���������� ����������
					C.f=0.14*(( Pow(R,2)-Pow(R1,2) )*(N-1))/D
					SetText(*String_4,StrF(C,2)) ; ������� �� ����� ���������
					SetColor(*String_4 , #PB_Gadget_BackColor , RGB(244, 245, 244) ) ; ������ ����� ��� � ������� � ��������������� *String_4
				EndIf
			EndIf
		EndIf
		
		; ������� ����� ��������� ��� ������� � ����� �� ����� ����� ������ (����� ����, � ������� ������������ ���������)
		If Type=#__event_Change ; ��� ������ �����.
			If Gadget=*String_0 Or Gadget=*String_1 Or Gadget=*String_2 Or Gadget=*String_3
				SetColor(*String_4 , #__Color_Back , RGB(255, 175, 174) ) ; ������ ������� ��� � ������� � ��������������� *String_4
			EndIf
		EndIf
		; 				
		; 			EndIf
		; ; 			
		; ; 		Until Event=#PB_Event_CloseWindow ; ��������� ������ ��������� ��� ������� ������� ����.
		; ; 		End																; ��������� ������ ���������.
	EndProcedure
	
	
	
	
	
	If Open(0, 247, 153, 355, 250, "������ ���",  #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered )
		Text(15, 20, 180, 15, "������ �������� ��������  ��.:", #__flag_Transparent)
		Text(15, 45, 225, 15, "������ ������ � ��������� ��������  ��.:", #__flag_Transparent)
		Text(15, 70, 195, 15, "���������� ����� ����������  ��.:", #__flag_Transparent)
		Text(15, 95, 85, 15, "����� �������:", #__flag_Transparent)
		Text(15, 190, 200, 30, "������������ ������� ����������� ������������  ��.:", #__flag_Transparent)
		*String_0 = String(255, 15, 85, 20, " ")
		*String_1 = String(255, 40, 85, 20, " ")
		*String_2 = String(255, 65, 85, 20, " ")
		*String_3 = String(255, 90, 85, 20, " ")
		*String_4 = String(255, 195, 85, 20, " ")
		*Button_0 = Button(130, 130, 80, 30, "����������")
		; ToolTip(#Button_1, "����� ��������� �������")
		
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