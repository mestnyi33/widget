; Module/File:     System_AddAppSpecFont.pb
; Function:        Adds application specific font - Linux
; Author:          freak; thanks ;-)
; Date:            Sep. 17, 2015
; Version:         0.1
; Target Compiler: PureBasic 5.22/5.31/5.40
; Target OS:       Linux: (X/K/L)ubuntu, Mint, 32/64, Ascii/Uni
; Link to topic:   http://www.purebasic.fr/english/viewtopic.php?f=13&t=63312
;--------------------------------------------------------------

EnableExplicit

ImportC "-lfontconfig"
  FcConfigAppFontAddFile.i(*config, file.p-ascii)
EndImport

;First load (and extract) a font from somewhere and place it local ...
;The set path & name here ... 
If FcConfigAppFontAddFile(#Null, "/home/charly/Downloads/AppFonts/fontawesome-webfont.ttf") = 0; always return 1 ???
	Debug "Font can't be loaded!"
	End
EndIf

LoadFont(0, "FontAwesome", 20)

; Object constants
#Win_Main = 0
#Txt1     = 0

Global.i gEvent, gQuit
Global.s S= "I " + Chr(61444) + " PureBasic! It runs on   " + Chr(61818) + "   ,   " + Chr(61817) + "   and   " + Chr(61820) + "   ." + #LF$ + Chr(61575) + " " + Chr(61604) + " freak"

If OpenWindow(#Win_Main, 0, 0, 640, 100, "Load App. spec font", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	TextGadget(#Txt1, 5, 5, 630, 90, S, #PB_Text_Center)
	SetGadgetFont(#Txt1, FontID(0))
	
	Repeat
		gEvent= WaitWindowEvent()
		
		Select gEvent
				
			Case #PB_Event_CloseWindow
				gQuit= #True
				
		EndSelect
	Until gQuit
EndIf
; IDE Options = PureBasic 5.46 LTS Beta 1 (Linux - x86)
; CursorPosition = 9
; EnableUnicode
; EnableXP
; CurrentDirectory = /home/charly-xubuntu/Programming/PureBasic/purebasic/
; IDE Options = PureBasic 5.62 (Linux - x64)
; CursorPosition = 51
; FirstLine = 2
; Folding = -
; EnableXP