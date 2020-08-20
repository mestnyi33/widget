EnableExplicit

Procedure.s TrimRight(*a, n)
	Protected *p.string = @*a
	*p\s = Left(*p\s, Len(*p\s) - n)
EndProcedure

Procedure.s TrimLeft(*a, n)
	Protected *p.string = @*a
	*p\s = Right(*p\s, Len(*p\s) - n)
EndProcedure

Define x.s = "Привет"
TrimRight(@x, 2)
Debug x
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP