Structure PB_ImageDecoder
	*Check;
	*Decode;
	*GetWidth;
	*GetHeight;
EndStructure


Structure PB_ImageEncoder
	ID.i
	*Encode;
EndStructure

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  Import ""
CompilerElse
  ImportC ""
CompilerEndIf
PB_ImageDecoder_Register(*Decoder.PB_ImageDecoder)
PB_ImageEncoder_Register(*Decoder.PB_ImageEncoder)
EndImport

;TailBite directive:
;--TB_ADD_PBLIB_ImagePlugin
; IDE Options = PureBasic 4.30 (Windows - x64)
; CursorPosition = 9
; Folding = -
; EnableXP