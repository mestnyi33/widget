DeclareModule b
  Declare b(a,b)
EndDeclareModule

DeclareModule a
  Declare a()
  Declare a2(a,b)
EndDeclareModule

Module a
  Procedure a()
    ProcedureReturn 2
  EndProcedure
  
  Procedure a2(a,b)
    ProcedureReturn b::b(a,b)
  EndProcedure
EndModule

Module b
  Procedure b(a,b)
    ProcedureReturn (a+b)/a::a()
  EndProcedure
EndModule


Debug b::b(5,10)
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --
; EnableXP