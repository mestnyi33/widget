Procedure LoadWindow(WindowKey$, Window, x, y, Width, Height, Title$, Flags)
  OpenPreferences("WindowState.dat")
  PreferenceGroup(WindowKey$)
  x=ReadPreferenceLong("x", x)
  y=ReadPreferenceLong("y", y)
  Width=ReadPreferenceLong("Width", Width)
  Height=ReadPreferenceLong("Height", Height)
  ClosePreferences()
  
  ProcedureReturn OpenWindow(Window, x, y, Width, Height, Title$, Flags)
EndProcedure



Enumeration FormWindow
  #Window1
  #Window2
  #Window3
EndEnumeration

Enumeration FormGadget
  #Text1 : #String1
  #Text2 : #String2
  #Text3 : #String3
  #Text4 : #String4
  
  #Text5 : #String5
  #Text6 : #String6
  #Text7 : #String7
  #Text8 : #String8
  
  #SimpleField1
  #SimpleField2
  #SimpleField3
  #SimpleField4
EndEnumeration





LoadWindow("Окно 1", #Window1, 0, 0, 320, 240, "Первое окно", #PB_Window_SystemMenu)
TextGadget(#Text1, 4, 4, 96, 20, "Текст 1") : StringGadget(#String1, 104, 4, 196, 20, "Строка 1")
TextGadget(#Text2, 4, 30, 96, 20, "Текст 2") : StringGadget(#String2, 104, 30, 196, 20, "Строка 2")
TextGadget(#Text3, 4, 56, 96, 20, "Текст 3") : StringGadget(#String3, 104, 56, 196, 20, "Строка 3")
TextGadget(#Text4, 4, 82, 96, 20, "Текст 4") : StringGadget(#String4, 104, 82, 196, 20, "Строка 4")

LoadWindow("Окно 2", #Window2, 320, 0, 320, 240, "Второе окно", #PB_Window_SystemMenu)
TextGadget(#Text5, 4, 4, 96, 20, "Текст 5") : StringGadget(#String5, 104, 4, 196, 20, "Строка 1")
TextGadget(#Text6, 4, 30, 96, 20, "Текст 6") : StringGadget(#String6, 104, 30, 196, 20, "Строка 2")
TextGadget(#Text7, 4, 56, 96, 20, "Текст 3") : StringGadget(#String7, 104, 56, 196, 20, "Строка 3")
TextGadget(#Text8, 4, 82, 96, 20, "Текст 4") : StringGadget(#String8, 104, 82, 196, 20, "Строка 4")



Procedure SimpleFieldGadget(Gadget, x, y, Title$, DefaultString$)
  Result=StringGadget(Gadget, x+100, y, 196, 20, DefaultString$)
  If Gadget=#PB_Any
    Gadget=Result
  EndIf
  
  If Gadget
    TitleGadget=TextGadget(#PB_Any, x, y, 96, 20, Title$)
  EndIf
  
  ProcedureReturn Gadget
EndProcedure



LoadWindow("Окно 3", #Window3, 0, 240, 320, 240, "Третье окно", #PB_Window_SystemMenu)
SimpleFieldGadget(#SimpleField1, 4, 4, "Поле 1", "Строка в поле 1")
SimpleFieldGadget(#SimpleField2, 4, 30, "Поле 2", "Строка в поле 2")
SimpleFieldGadget(#SimpleField3, 4, 56, "Поле 3", "Строка в поле 3")
SimpleFieldGadget(#SimpleField4, 4, 82, "Поле 4", "Строка в поле 4")


Procedure OpenRegisterForm(x, y)
  RegisterForm=LoadWindow("Register", #PB_Any, x, y, 320, 240, "Форма регистрации", #PB_Window_SystemMenu)
  SimpleFieldGadget(#PB_Any, 4, 4, "Имя", "Лю Кенг")
  SimpleFieldGadget(#PB_Any, 4, 30, "E-mail", "Liu.Kang@mail.mc")
  SimpleFieldGadget(#PB_Any, 4, 56, "Пароль", "")
  SimpleFieldGadget(#PB_Any, 4, 82, "Повторите пароль", "")
EndProcedure

OpenRegisterForm(320, 240)



Repeat
Until WaitWindowEvent()=#PB_Event_CloseWindow




; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 89
; FirstLine = 44
; Folding = -
; EnableXP
; CompileSourceDirectory