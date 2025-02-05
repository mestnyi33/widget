﻿Procedure RGBtoBGR(c)
	ProcedureReturn RGB(Blue(c), Green(c), Red(c))
EndProcedure

Procedure ColorValidate(Color$)
	Protected tmp$, tmp2$, i, def
	; 	If IsHex(@Color$) ; валидация через регвыр
	Select Len(Color$)
		Case 6
			def = RGBtoBGR(Val("$" + Color$))
		Case 1
			def = Val("$" + LSet(Color$, 6, Color$))
		Case 2
			def = Val("$" + Color$ + Color$ + Color$)
		Case 3
			For i = 3 To 1 Step -1
				tmp$ = Mid(Color$, i, 1)
				tmp2$ + tmp$ + tmp$
			Next
			def = Val("$" + tmp2$)
	EndSelect
	; 	EndIf
	; 	Debug Hex(def)
	ProcedureReturn def
EndProcedure


Procedure SaveFile_Buff(File.s, *Buff, Size)
	Protected Result = #False
	Protected ID = CreateFile(#PB_Any, File)
	If ID
		If WriteData(ID, *Buff, Size) = Size
			Result = #True
		EndIf
		CloseFile(ID)
	EndIf
	ProcedureReturn Result
EndProcedure


;==================================================================
;
; Author:    ts-soft     
; Date:       March 5th, 2010
; Explain:
;     modified version from IBSoftware (CodeArchiv)
;     on vista and above check the Request for "User mode" or "Administrator mode" in compileroptions
;    (no virtualisation!)
;==================================================================
Procedure ForceDirectories(Dir.s)
	Static tmpDir.s, Init
	Protected result
	
	If Len(Dir) = 0
		ProcedureReturn #False
	Else
		If Not Init
			tmpDir = Dir
			Init   = #True
		EndIf
		If (Right(Dir, 1) = #PS$)
			Dir = Left(Dir, Len(Dir) - 1)
		EndIf
		If (Len(Dir) < 3) Or FileSize(Dir) = -2 Or GetPathPart(Dir) = Dir
			If FileSize(tmpDir) = -2
				result = #True
			EndIf
			tmpDir = ""
			Init = #False
			ProcedureReturn result
		EndIf
		ForceDirectories(GetPathPart(Dir))
		ProcedureReturn CreateDirectory(Dir)
	EndIf
EndProcedure


; Procedure hsb_to_rgb(arr_hsb)
Procedure hsb_to_rgb()
	Protected sector
	Protected.f ff, pp, qq, tt
	Protected.f Dim af_rgb(2) ; создаём массивы в которых числа будут в диапазоне 0-1
	Protected.f Dim af_hsb(2)
	; Protected Dim arr_rgb(2)

	af_hsb(2) = arr_hsb(2) / 100

	If arr_hsb(1) = 0 ; если серый, то одно значение всем
		arr_rgb(0) = Round(af_hsb(2) * 255, #PB_Round_Nearest)
		arr_rgb(1) = arr_rgb(0)
		arr_rgb(2) = arr_rgb(0)
		; ProcedureReturn arr_rgb
	EndIf

	While arr_hsb(0) >= 360 ; если тон задан большим запредельным числом, то
		arr_hsb(0) - 360
	Wend

	af_hsb(1) = arr_hsb(1) / 100
	af_hsb(0) = arr_hsb(0) / 60
	; sector = Int(arr_hsb(0))
	sector = Round(af_hsb(0), #PB_Round_Down)

	ff = af_hsb(0) - sector
	pp = af_hsb(2) * (1 - af_hsb(1))
	qq = af_hsb(2) * (1 - af_hsb(1) * ff)
	tt = af_hsb(2) * (1 - af_hsb(1) * (1 - ff))

	Select sector
		Case 0
			af_rgb(0) = af_hsb(2)
			af_rgb(1) = tt
			af_rgb(2) = pp
		Case 1
			af_rgb(0) = qq
			af_rgb(1) = af_hsb(2)
			af_rgb(2) = pp
		Case 2
			af_rgb(0) = pp
			af_rgb(1) = af_hsb(2)
			af_rgb(2) = tt
		Case 3
			af_rgb(0) = pp
			af_rgb(1) = qq
			af_rgb(2) = af_hsb(2)
		Case 4
			af_rgb(0) = tt
			af_rgb(1) = pp
			af_rgb(2) = af_hsb(2)
		Default
			af_rgb(0) = af_hsb(2)
			af_rgb(1) = pp
			af_rgb(2) = qq
	EndSelect

	; RGB
	arr_rgb(0) = Round(af_rgb(0) * 255, #PB_Round_Nearest)
	arr_rgb(1) = Round(af_rgb(1) * 255, #PB_Round_Nearest)
	arr_rgb(2) = Round(af_rgb(2) * 255, #PB_Round_Nearest)

	; BGR
	; arr_rgb(2)=Round(af_rgb(0)*255, #PB_Round_Nearest)
	; arr_rgb(1)=Round(af_rgb(1)*255, #PB_Round_Nearest)
	; arr_rgb(0)=Round(af_rgb(2)*255, #PB_Round_Nearest)

	; ProcedureReturn arr_rgb
EndProcedure


Procedure rgb_to_hsb()
	Protected.f min, max

	If arr_rgb(0) <= arr_rgb(1)
		min = arr_rgb(0)
		max = arr_rgb(1)
	Else
		min = arr_rgb(1)
		max = arr_rgb(0)
	EndIf

	If min > arr_rgb(2)
		min = arr_rgb(2)
	EndIf

	If max < arr_rgb(2)
		max = arr_rgb(2)
	EndIf

	If max = min
		arr_hsb(0) = 0
	ElseIf max = arr_rgb(0)
		arr_hsb(0) = 60 * (arr_rgb(1) - arr_rgb(2)) / (max - min)
		If arr_rgb(1) < arr_rgb(2)
			arr_hsb(0) + 360
		EndIf
	ElseIf max = arr_rgb(1)
		arr_hsb(0) = 60 * (arr_rgb(2) - arr_rgb(0)) / (max - min) + 120
	ElseIf max = arr_rgb(2)
		arr_hsb(0) = 60 * (arr_rgb(0) - arr_rgb(1)) / (max - min) + 240
	EndIf

	If max = 0
		arr_hsb(1) = 0
	Else
		arr_hsb(1) = (1 - min / max) * 100
	EndIf

	arr_hsb(2) = max / 255 * 100

	arr_hsb(0) = Round(arr_hsb(0), #PB_Round_Nearest)
	arr_hsb(1) = Round(arr_hsb(1), #PB_Round_Nearest)
	arr_hsb(2) = Round(arr_hsb(2), #PB_Round_Nearest)

	; ProcedureReturn arr_hsb
EndProcedure


Procedure RemoveNonHexChars(*c.Character)
	Protected *c2.Character
	If *c = 0 Or *c\c = 0
		ProcedureReturn 0
	EndIf
	*c2 = *c
	
	While *c\c
		Select *c\c
			Case '0' To '9', 'a' To 'f', 'A' To 'F'
				If *c2 <> *c
					*c2\c = *c\c
				EndIf
				*c2 + SizeOf(Character)
		EndSelect
		*c + SizeOf(Character)
	Wend
	If *c <> *c2
		*c2\c = 0
		ProcedureReturn 1 ; line changed
	Else
		ProcedureReturn 0
	EndIf
EndProcedure
; IDE Options = PureBasic 6.03 LTS (Windows - x64)
; CursorPosition = 218
; FirstLine = 179
; Folding = --
; EnableAsm
; EnableXP
; DPIAware
; UseIcon = icon.ico
; Executable = IconEditor.exe