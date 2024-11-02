; https://www.purebasic.fr/english/viewtopic.php?t=82870&start=15
EnableExplicit

;\\ 1 example
Structure DayStruc
   Days.i[12]
EndStructure

Define *NumDays.DayStruc = ?DaysInMonth
Define month.i

For month = 1 To 12
   Debug Str(month) + ") " + *NumDays\Days[month-1] + " days"
Next


DataSection
   DaysInMonth:
   Data.i 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
EndDataSection

;\\ 2 example
Debug "2-----"
Define a$, i
Structure ArrayOfMonthNames
  Month.s[13]
EndStructure

; Read Only Names! Never write to Names
Define *Names.ArrayOfMonthNames = ?MonthName

For i = 1 To 12
  a$ = *Names\Month[i]
  Debug a$
Next

DataSection
  
  M0:
  Data.s ""
  M1: 
  Data.s "January"
  M2:
  Data.s "February"
  M3:
  Data.s "March"
  M4:
  Data.s "April"
  M5:
  Data.s "May"
  M6:
  Data.s "June"
  M7:
  Data.s "July"
  M8:
  Data.s "August"
  M9:
  Data.s "September"
  M10:
  Data.s "October"
  M11:
  Data.s "November"
  M12:
  Data.s "December"
  
  ; Pointer array to strings
  MonthName:
  Data.i ?M0, ?M1, ?M2, ?M3, ?M4, ?M5, ?M6, ?M7, ?M8, ?M9, ?M10, ?M11, ?M12
EndDataSection


;\\ 3 example
Debug "3-----"
Structure ArrayOfMonthNames3
  Month.s[13]
EndStructure

; Read Only Names! Never write to Names
Global *MonthNames.ArrayOfMonthNames = ?MonthName3
Macro GetMonthName(_Month_)
  PeekS(*MonthNames\Month[_Month_])
EndMacro

For i = 1 To 12
  a$ = *MonthNames\Month[i]
  ;a$ = GetMonthName(i)
  Debug a$
Next

DataSection
  
  MonthName3:
  Data.i @""
  Data.i @"January"
  Data.i @"February"
  Data.i @"March"
  Data.i @"April"
  Data.i @"May"
  Data.i @"June"
  Data.i @"July"
  Data.i @"August"
  Data.i @"September"
  Data.i @"October"
  Data.i @"November"
  Data.i @"December"
  
EndDataSection

;\\ 4 example
Debug "4-----"
Dim MonthNames.s(11)

Restore MonthNames
For i = 0 To 11
	Read.s MonthNames(i)
	Debug MonthNames(i)
Next

DataSection
	MonthNames:
	Data.s "January", 
	       "February", 
	       "March",
	       "April", 
	       "May",
	       "June",
	       "July", 
	       "August",
	       "September",
	       "October",
	       "November",
	       "December"
EndDataSection

;\\ 5 example
Debug "5-----"
; Read Only Names! Never write to Names
Dim MonthNames.s(13)

Procedure linkStringsFromDataSection(Array strings.s(1), *label.Character, stopAtZeroString.i = #True)
	Protected index.i = 0, *element.Integer = @strings()
		
	While (*label\c Or (Not stopAtZeroString)) And index <= ArraySize(strings())
		; Used to clear entries that already exist
		If *element\i And *element\i <> *label
			ClearStructure(*element, String)
		EndIf
		*element\i = *label
		*element + SizeOf(Integer)
		index + 1
		*label + MemoryStringLength(*label, #PB_ByteLength) + SizeOf(Character)
	Wend
EndProcedure

MonthNames(0) = "test"
; Set last parameter to #False to link as many strings as the array is long and not stop at an empty string
linkStringsFromDataSection(MonthNames(), ?MonthNames2, #True)
Define i.i
For i = 0 To ArraySize(MonthNames())
	Debug MonthNames(i)
Next

DataSection
	MonthNames2:
		Data.s "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
		Data.s "", "after the zero length string"
EndDataSection




; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 169
; FirstLine = 24
; Folding = 4o
; EnableXP