EnableExplicit

Structure ABCD
  a.s
  b.s
  c.s
  d.s
EndStructure

Global test.ABCD
Global *string.String

*string = @test + OffsetOf(ABCD\a)
*string\s = "aTest!"

*string = @test + OffsetOf(ABCD\b)
*string\s = "bTest!"

*string = @test + OffsetOf(ABCD\c)
*string\s = "cTest!"

*string = @test + OffsetOf(ABCD\d)
*string\s = "dTest!"

Debug test\a
Debug test\b
Debug test\c
Debug test\d

End
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP