EnableExplicit

Procedure SplitL3(*c.Character, List StringList(), *jc.Character)
	Protected *t.Character = *c
	ClearList(StringList())
	While *c\c
		If *c\c = *jc\c
			*c\c = 0
			*c + SizeOf(Character)
			If *c\c
				AddElement(StringList())
				StringList() = *t
				*t = *c
			Else
				Break
			EndIf
		EndIf
		*c + SizeOf(Character)
	Wend
	AddElement(StringList())
	StringList() = *t
EndProcedure

Define St.s = "This is a test string to see if split and join are working."

NewList WordsList()
SplitL3(@St, WordsList(), @" ")

ForEach WordsList()
    Debug PeekS(WordsList())
Next
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 26
; Folding = -
; EnableXP