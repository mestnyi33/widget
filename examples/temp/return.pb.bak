; Возврат из процедуры двух координат, значения каждой могут быть -32768 to +32767
Procedure.l u()  ; число 0-65535
Protected w.w, h.w
w=32767 
h=-32768
ProcedureReturn w+h*65536 
EndProcedure

; здесь обязательно тип .U ---- НЕТ, ТИП W для отрицательных значений
w1.w=u()
h1.w=u()>>16
Debug ""+Str(w1)+"  "+Str(h1)

; Возврат из процедуры двух координат, значения каждой могут быть -32768 to +32767
; Но можно и расширить диапазон значений
Procedure.l u1()
  Protected w.w, h.w, res.l
  w=32767
  h=-32768
  PokeW (@res, w)
  PokeW (@res+2, h)
  ProcedureReturn res
EndProcedure

result.l=u1()

Debug ""
Debug ""+PeekW (@result) +" "+ PeekW (@result+2)
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 3
; Folding = -
; EnableXP