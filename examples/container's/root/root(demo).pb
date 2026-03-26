IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   EnableExplicit
   
   Procedure Test( *root._s_ROOT, X,Y,w,h, title.s )
      SetFrame(*root,1)
      OpenList(*root)
      Button(X,Y,w,h, title.s)
      CloseList()
   EndProcedure
   
   Global *r, *r1,*r2,*r3,*r4,*r5, *g
   ; --- Создаем 2 окна ---
   *r = Open(#PB_Any, 100, 200, 200, 200, "Окно 1")
   Test(*r, 20,20,60,60,"Квадрат окна 1")
   ;Draw(*r)
   
   *r = Open(#PB_Any, 350, 200, 200, 200, "Окно 2")
   Test(*r, 100,100,80,40,"Квадрат окна 2")
   ;Draw(*r)
   
   ; В одном окне
   Global win = OpenWindow(#PB_Any, 600, 100, 410, 410, "4 Холста в одном окне")
   
   ; Создаем 4 независимых корня/холста
   *r1 = Open(win, 0,   0,   200, 200, "Топ-Лево")
   *r2 = Open(win, 205, 0,   200, 200, "Топ-Право")
   *r3 = Open(win, 0,   205, 200, 200, "Бот-Лево")
   *r4 = Open(win, 205, 205, 200, 200, "Бот-Право")
   *r5 = Open(win, 40,   40,   230, 230, "Топ-Лево")
   
   *g = Test(*r1, 20,20,60,60,"Квадрат 1")
   Test(*r2, 20,20,60,60,"Квадрат 2")
   Test(*r3, 20,20,60,60,"Квадрат 3")
   Test(*r4, 20,20,60,60,"Квадрат 4")
   Test(*r5, 40,40,120,120,"Квадрат 5")
   
   ;SetBackgroundColor( *r5, $fff0f0)
   
   ReDraw(Root( ))
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 9
; FirstLine = 6
; Folding = -
; EnableXP
; DPIAware