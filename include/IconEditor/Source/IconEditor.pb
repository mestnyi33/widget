﻿; AZJIO (24.11.2023)

EnableExplicit

#Window = 0
#Win1 = 1
#Menu = 0

;- Enumeration
Enumeration Gadget
   #cnvPalette
   #cnvScene
   ; 	#btnOpenLevel
   #btnSave
   #btnOpenImg
   #btnClear
   #Opt1
   #Opt2
   #Opt3
   #btnCan
   #btnPen
   #btnMenu
   #HexColor
   #btnColor
   
   #tbgTone
   #tbgBrightness
   #tbgSaturation
EndEnumeration

Enumeration Image
   #Image
   #imgColor
   #imgCan
   #imgPen
   #imgSave
   #imgOpen
   #imgClear
   #imgLeft
   #imgRight
   #imgMirrorH
   #imgMirrorV
   #imgTone
   #imgTitle
   #imgDummy
EndEnumeration

Enumeration item
   #mUndo
   #mRotateL
   #mRotateR
   #mMirrorH
   #mMirrorV
   #mTBS
EndEnumeration

UseGIFImageDecoder()
UsePNGImageDecoder()
UsePNGImageEncoder()


;- Declare
Declare DrawPixel(selectedColor)
Declare Border()
Declare DrawArea(x, y)
Declare DrawCan()
Declare hsb_to_rgb()
Declare rgb_to_hsb()
Declare GUI2()
Declare OpenImg(tmp$)
Declare Rotate(Direction)
Declare SetColorBox(Color)

;- Global
Global tmp, i, j, y, x, selectedColor, StyleBox
Global mxxOld, myyOld, pendown, delmode, mxx, myy
Global tmp$
Global ImagePlugin
Global DrawingTool = 1
Global Dim arr_rgb(2)
Global Dim arr_hsb(2)
Global w, h
Global ClickColor
Global CountUndo
Global indent


#Transparency = $010203
Global CELLSIZEW
Global CELLSIZEH
Global XXX
Global YYY
Global flgOpen

Global BoxAreaX
      Global BoxAreaY
      Global AreaX
      Global AreaY
      
Global UserIntLang$
      
selectedColor = $7DC4DF

Global DPI.d = 1
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
   Define hDC0 = GetWindowDC_(0)
   DPI.d = GetDeviceCaps_(hDC0, #LOGPIXELSY) / 96
   ReleaseDC_(0, hDC0)
CompilerEndIf





; Определение языка интерфейса и применение
; Определяет язык ОС
CompilerSelect #PB_Compiler_OS
   CompilerCase #PB_OS_Windows
      Global *Lang
      If OpenLibrary(0, "kernel32.dll")
         *Lang = GetFunction(0, "GetUserDefaultUILanguage")
         If *Lang
            If 1049 = CallFunctionFast(*Lang)
               UserIntLang$ = "ru"
            EndIf
         EndIf
         CloseLibrary(0)
      EndIf
   CompilerCase #PB_OS_Linux
      If ExamineEnvironmentVariables()
         While NextEnvironmentVariable()
            If Left(EnvironmentVariableName(), 4) = "LANG"
               ; 		    		LANG=ru_RU.UTF-8
               ; 		    		LANGUAGE=ru
               UserIntLang$ = Left(EnvironmentVariableValue(), 2)
               Break
            EndIf
         Wend
      EndIf
   CompilerCase #PB_OS_MacOS
      
CompilerEndSelect


;- Lang
Global Dim Lng.s(13)
; Строки интерфейса даже если языковой файл не найден


If UserIntLang$ = "ru"
   Lng(0) = "Сплошной"
   Lng(1) = "Квадрат"
   Lng(2) = "Округлый"
   Lng(3) = "Повернуть влево"
   Lng(4) = "Повернуть вправо"
   Lng(5) = "Тон, яркость, насыщенность"
   Lng(6) = "Файл создан"
   Lng(7) = "Ошибка"
   Lng(8) = "Не удалось сохранить файл"
   Lng(9) = "Да"
   Lng(10) = "Нет"
   Lng(11) = "Отмена"
   Lng(12) = "Отразить по горизонтали"
   Lng(13) = "Отразить по вертикали"
   ; 	Lng(9) = "Тон"
   ; 	Lng(10) = "Насыщенность"
   ; 	Lng(11) = "Яркость"
Else
   Lng(0) = "Solid"
   Lng(1) = "Box"
   Lng(2) = "Round"
   Lng(3) = "Rotate Left"
   Lng(4) = "Rotate Right"
   Lng(5) = "Tone, Brightness, Saturation"
   Lng(6) = "File created"
   Lng(7) = "Error"
   Lng(8) = "Failed to save file"
   Lng(9) = "Yes"
   Lng(10) = "No"
   Lng(11) = "Cancel"
   Lng(12) = "Flip horizontally"
   Lng(13) = "Flip Vertical"
EndIf

      
      
      ; XXX = 24
      ; YYY = 24
      ; CELLSIZEW = 20
      ; CELLSIZEH = 20
      
      
      
      
      XXX = 48
      YYY = 48
      CELLSIZEW = 10
      CELLSIZEH = 10
      
      tmp$ = ProgramParameter()
      If Asc(tmp$) And FileSize(tmp$) > 4
         flgOpen = 1
      Else
         Select MessageRequester("16x16?", Lng(9) + " = 16x16" + #LF$ + Lng(10) + " = 32x32" + #LF$ + Lng(11) + " = 48x48", #PB_MessageRequester_YesNoCancel)
            Case #PB_MessageRequester_Yes
               XXX = 16
               YYY = 16
               CELLSIZEW = 30
               CELLSIZEH = 30
            Case #PB_MessageRequester_No
               XXX = 32
               YYY = 32
               CELLSIZEW = 15
               CELLSIZEH = 15
         EndSelect
      EndIf
      
      
      ; Global Dim aPicturePx(XXX, YYY)
      Global Dim aPicturePx(XXX + 1, YYY + 1)
      Global Dim aPicPxOld(XXX + 1, YYY + 1)
      

      BoxAreaX = CELLSIZEW * XXX
      BoxAreaY = CELLSIZEH * YYY
      AreaX = BoxAreaX / DPI
      AreaY = BoxAreaY / DPI
      
      
      Border()
      
      For y = 1 To YYY
         For x = 1 To XXX
            aPicturePx(x, y) = #Transparency
         Next
      Next
      
      XIncludeFile "ForIconEditor.pb"
      
      Global isINI
      Global PathConfig$
      Global ini$
      ;- ini
      Global PathConfig$ = GetPathPart(ProgramFilename())
      If FileSize(PathConfig$ + "IconEditor.ini") = -1
         CompilerSelect #PB_Compiler_OS
            CompilerCase #PB_OS_Windows
               PathConfig$ = GetHomeDirectory() + "AppData\Roaming\IconEditor\"
            CompilerCase #PB_OS_Linux
               PathConfig$ = GetHomeDirectory() + ".config/IconEditor/"
               ; 		CompilerCase #PB_OS_MacOS
               ; 			PathConfig$ = GetHomeDirectory() + "Library/Application Support/IconEditor/"
         CompilerEndSelect
      EndIf
      Global ini$ = PathConfig$ + "IconEditor.ini"
      
      ; Создаём ini-файл, если не существует
      If FileSize(ini$) = -1 And ForceDirectories(GetPathPart(ini$)) And SaveFile_Buff(ini$, ?ini, ?ini_end - ?ini)
         ; 	Debug 1
      EndIf
      
      Procedure RangeCheck(value, min, max)
         If value < min
            value = min
         ElseIf value > max
            value = max
         EndIf
         ProcedureReturn value
      EndProcedure
      
      If FileSize(ini$) > 8 And OpenPreferences(ini$) ; 8 байт, чтобы не читать пустышку
         isINI = 1
         
         PreferenceGroup("set")
         ; 	selectedColor = ReadPreferenceInteger("color", selectedColor)
         selectedColor = ColorValidate(ReadPreferenceString("color", "DFC47D")) ; $7DC4DF
         StyleBox = ReadPreferenceInteger("box", StyleBox)
         StyleBox = RangeCheck(StyleBox, 0, 2)
         ClosePreferences()
      EndIf
      
      DataSection
         ini:
         IncludeBinary "sample.ini"
         ini_end:
      EndDataSection
      
      DataSection
         Can:
         IncludeBinary "images" + #PS$ + "Can.gif"
         Pen:
         IncludeBinary "images" + #PS$ + "Pen.gif"
         Clear:
         IncludeBinary "images" + #PS$ + "Clear.gif"
         Save:
         IncludeBinary "images" + #PS$ + "Save.gif"
         Open:
         IncludeBinary "images" + #PS$ + "Open.gif"
         Left:
         IncludeBinary "images" + #PS$ + "Left.gif"
         Right:
         IncludeBinary "images" + #PS$ + "Right.gif"
         MirrorH:
         IncludeBinary "images" + #PS$ + "MirrorH.gif"
         MirrorV:
         IncludeBinary "images" + #PS$ + "MirrorV.gif"
         Tone:
         IncludeBinary "images" + #PS$ + "Tone.gif"
      EndDataSection
      
      CatchImage(#imgCan, ?Can)
      CatchImage(#imgPen, ?Pen)
      CatchImage(#imgClear, ?Clear)
      CatchImage(#imgSave, ?Save)
      CatchImage(#imgOpen, ?Open)
      CatchImage(#imgLeft, ?Left)
      CatchImage(#imgRight, ?Right)
      CatchImage(#imgMirrorH, ?MirrorH)
      CatchImage(#imgMirrorV, ?MirrorV)
      CatchImage(#imgTone, ?Tone)
      
      
      CompilerSelect #PB_Compiler_OS
         CompilerCase #PB_OS_Linux
            ; https://www.purebasic.fr/english/viewtopic.php?p=531374#p531374
            ImportC ""
               gtk_window_set_icon(a.l, b.l)
            EndImport
            
            DataSection
               IconTitle:
               IncludeBinary "IconEditor.png"
               IconTitleend:
            EndDataSection
            CatchImage(#imgTitle, ?IconTitle)
      CompilerEndSelect
      
      ;- GUI
      OpenWindow(#Window, 0, 0, AreaX + 110, AreaY + 4, "IconEditor   (" + Str(XXX) + "x" + Str(YYY) + ")", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
      CompilerIf #PB_Compiler_OS = #PB_OS_Linux
         gtk_window_set_icon_(WindowID(#Window), ImageID(#imgTitle)) ; назначаем иконку в заголовке
      CompilerEndIf
      ; SetWindowColor(#Window, 0)
      
      
      AddKeyboardShortcut(#Window, #PB_Shortcut_Control | #PB_Shortcut_Z, #mUndo)
      
      indent = 102 / DPI
      CompilerIf #PB_Compiler_OS = #PB_OS_Linux
         CreateImage(#imgDummy, 1, 1)
      CompilerEndIf
      If CreateImage(#imgColor, 33, 33)
         If StartDrawing(ImageOutput(#imgColor))
            Box(0, 0, 33, 33, selectedColor)
            StopDrawing()
         EndIf
      EndIf
      ButtonImageGadget(#btnColor, AreaX + 6, indent + 4, 33, 33 , ImageID(#imgColor))
      
      StringGadget(#HexColor, AreaX + 6, indent + 44, 99, 24, RSet(Hex(RGBtoBGR(selectedColor)), 6, "0"))
      
      OptionGadget(#Opt1, AreaX + 11, indent + 70, 98, 20, Lng(0))
      OptionGadget(#Opt2, AreaX + 11, indent + 90, 98, 20, Lng(1))
      OptionGadget(#Opt3, AreaX + 11, indent + 110, 98, 20, Lng(2))
      SetGadgetState(#Opt1 + StyleBox, 1)
      
      ButtonImageGadget(#btnCan, AreaX + 6, indent + 140, 33, 33 , ImageID(#imgCan), #PB_Button_Toggle)
      ButtonImageGadget(#btnPen, AreaX + 40, indent + 140, 33, 33 , ImageID(#imgPen), #PB_Button_Toggle)
      SetGadgetState(#btnPen, 1)
      
      ButtonImageGadget(#btnClear, AreaX + 74, indent + 140, 33, 33 , ImageID(#imgClear))
      
      ButtonGadget(#btnMenu, AreaX + 6, indent + 174, 33, 33 , Chr($2630))
      
      ; 280
      ButtonImageGadget(#btnOpenImg, AreaX + 6, AreaY - 35, 33, 33 , ImageID(#imgOpen))
      ButtonImageGadget(#btnSave, AreaX + 40, AreaY - 35, 33, 33 , ImageID(#imgSave))
      
      
      
      If CreatePopupImageMenu(#Menu)
         MenuItem(#mRotateL, Lng(3), ImageID(#imgLeft))
         MenuItem(#mRotateR, Lng(4), ImageID(#imgRight))
         MenuItem(#mMirrorH, Lng(12), ImageID(#imgMirrorH))
         MenuItem(#mMirrorV, Lng(13), ImageID(#imgMirrorV))
         MenuItem(#mTBS, Lng(5), ImageID(#imgTone))
         ; 	MenuItem(#mTBS, "Тон, яркость, насыщенность")
      EndIf
      
      
      ; холст Сцена
      CanvasGadget(#cnvScene, 0, 0, AreaX + 4, AreaY + 4, #PB_Canvas_Border)
      If StartDrawing(CanvasOutput(#cnvScene))
         Box(0, 0, BoxAreaX, BoxAreaY, #Transparency)
         StopDrawing()
      EndIf
      
      
      
      ; холст Палитра
      CanvasGadget(#cnvPalette, AreaX + 4, 2, 104 * DPI, indent)
      
      If StartDrawing(CanvasOutput(#cnvPalette))
         
         CompilerIf #PB_Compiler_OS = #PB_OS_Windows
            Box(0, 0, 106 * DPI, indent * DPI, GetSysColor_(#COLOR_3DFACE))
         CompilerEndIf
         
         
         
         ; Спектр
         w = 100
         h = 10
         arr_hsb(1) = 100
         arr_hsb(2) = 100
         
         For i = 100 To 0 Step - 1
            Line(93, 100 - i, 10, 1, RGB(i * 2.5, i * 2.5, i * 2.5))
         Next
         ; 	For i=0 To 255
         ; 		Line(91, i, 10, 1, RGB(i, i, i))
         ; 	Next
         
         For j = 0 To 90
            arr_hsb(2) = 100 - j
            For i = 0 To w
               arr_hsb(0) = i * 360 / w
               hsb_to_rgb()
               Plot(j, i, RGB(arr_rgb(0), arr_rgb(1), arr_rgb(2)))
            Next
         Next
         
         
         ; 	Box(0, 0, 110, 30, selectedColor)
         ; 	Box(27, 8, 32, 32, $FFFFFF)
         ; 	Box(28, 9, 30, 30, selectedColor)
         
         StopDrawing()
         
      EndIf
      
      ;; init palette end
      If flgOpen
         OpenImg(tmp$)
      EndIf
      
      
      
      ;- Loop
      Repeat
         Select WaitWindowEvent():
            Case #PB_Event_CloseWindow
               CloseWindow(#Window)
               If isINI And OpenPreferences(ini$)
                  PreferenceGroup("set")
                  selectedColor = RGBtoBGR(selectedColor)
                  WritePreferenceString("color", RSet(Hex(selectedColor), 6, "0"))
                  WritePreferenceInteger("box", StyleBox)
                  ClosePreferences()
               EndIf
               End
               
               ;- Loop Menu	
            Case #PB_Event_Menu
               Select EventMenu()
                  Case #mTBS
                     GUI2()
                  Case #mMirrorH
                     Rotate(2)
                  Case #mMirrorV
                     Rotate(3)
                  Case #mRotateL
                     Rotate(0)
                  Case #mRotateR
                     Rotate(1)
                  Case #mUndo
                     CountUndo + 1
                     If CountUndo > 1
                        Continue ; не позволяем делать отмену дважды
                     EndIf
                     CopyArray(aPicPxOld(), aPicturePx())
                     If StartDrawing(CanvasOutput(#cnvScene))
                        Box(0, 0, BoxAreaX, BoxAreaY, 0)
                        
                        For y = 1 To YYY
                           For x = 1 To XXX
                              Select StyleBox
                                 Case 0
                                    Box((x - 1) * CELLSIZEW, (y - 1) * CELLSIZEH, CELLSIZEW, CELLSIZEH, aPicturePx(x, y))
                                 Case 1
                                    Box((x - 1) * CELLSIZEW, (y - 1) * CELLSIZEH, CELLSIZEW - 1, CELLSIZEH - 1, aPicturePx(x, y))
                                 Case 2
                                    RoundBox((x - 1) * CELLSIZEW + 1, (y - 1) * CELLSIZEH + 1, CELLSIZEW - 2, CELLSIZEH - 2, 2, 2, aPicturePx(x, y))
                              EndSelect
                           Next
                        Next
                        StopDrawing()
                     EndIf
               EndSelect
               
               
               
               ;  $00FF99
               ;- Loop_Gadget
            Case #PB_Event_Gadget
               Select EventGadget()
                  Case #btnColor
                     tmp = ColorRequester(selectedColor)
                     If tmp > -1
                        SetColorBox(tmp)
                        SetGadgetText(#HexColor, RSet(Hex(RGBtoBGR(tmp)), 6, "0"))
                        selectedColor = tmp
                     EndIf
                  Case #HexColor
                     If EventType() = #PB_EventType_Change
                        tmp$ = GetGadgetText(#HexColor)
                        tmp = Len(tmp$)
                        If tmp > 6
                           tmp$ = RSet(tmp$, 6)
                           SetGadgetText(#HexColor, tmp$)
                        EndIf
                        If RemoveNonHexChars(@tmp$)
                           SetGadgetText(#HexColor , tmp$)
                        EndIf
                        If Len(tmp$) = 6
                           selectedColor = RGBtoBGR(Val("$" + tmp$))
                           SetColorBox(selectedColor)
                        EndIf
                     EndIf
                  Case #btnMenu
                     DisplayPopupMenu(#Menu, WindowID(#Window))
                  Case #btnCan
                     DrawingTool = 2
                     SetGadgetState(#btnPen, 0)
                     SetGadgetState(#imgCan, 1)
                  Case #btnPen
                     DrawingTool = 1
                     SetGadgetState(#imgCan, 0)
                     SetGadgetState(#btnPen, 1)
                     
                  Case #Opt1
                     StyleBox = 0
                     If StartDrawing(CanvasOutput(#cnvScene))
                        Box(0, 0, BoxAreaX, BoxAreaY, 0)
                        For y = 1 To YYY
                           For x = 1 To XXX
                              Box((x - 1) * CELLSIZEW, (y - 1) * CELLSIZEH, CELLSIZEW, CELLSIZEH, aPicturePx(x, y))
                           Next
                        Next
                        StopDrawing()
                     EndIf
                  Case #Opt2
                     StyleBox = 1
                     If StartDrawing(CanvasOutput(#cnvScene))
                        Box(0, 0, BoxAreaX, BoxAreaY, 0)
                        For y = 1 To YYY
                           For x = 1 To XXX
                              Box((x - 1) * CELLSIZEW, (y - 1) * CELLSIZEH, CELLSIZEW - 1, CELLSIZEH - 1, aPicturePx(x, y))
                           Next
                        Next
                        StopDrawing()
                     EndIf
                  Case #Opt3
                     StyleBox = 2
                     If StartDrawing(CanvasOutput(#cnvScene))
                        Box(0, 0, BoxAreaX, BoxAreaY, 0)
                        For y = 1 To YYY
                           For x = 1 To XXX
                              RoundBox((x - 1) * CELLSIZEW + 1, (y - 1) * CELLSIZEH + 1, CELLSIZEW - 2, CELLSIZEH - 2, 2, 2, aPicturePx(x, y))
                           Next
                        Next
                        StopDrawing()
                     EndIf
                     
                     ; 				Case #btnOpenLevel
                     ; 					tmp$ = OpenFileRequester("Открыть уровень", GetCurrentDirectory(), "txt|*.txt", 0)
                     ; 					If Asc(tmp$)
                     ; 					EndIf
                  Case #btnClear
                     For y = 1 To YYY
                        For x = 1 To XXX
                           aPicturePx(x, y) = #Transparency
                        Next
                     Next
                     CopyArray(aPicturePx() , aPicPxOld())
                     If StartDrawing(CanvasOutput(#cnvScene))
                        Box(0, 0, BoxAreaX, BoxAreaY, #Transparency)
                        StopDrawing()
                     EndIf
                  Case #btnOpenImg
                     tmp$ = OpenFileRequester("Open file", GetCurrentDirectory(), "img|*.bmp;*.png;*.gif;*.ico", 0)
                     If Asc(tmp$)
                        OpenImg(tmp$)
                     EndIf
                  Case #btnSave
                     If StartDrawing(CanvasOutput(#cnvScene))
                        DrawingMode(#PB_2DDrawing_Transparent)
                        For y = 1 To YYY
                           For x = 1 To XXX
                              tmp = Point(x * CELLSIZEW - CELLSIZEW / 2, y * CELLSIZEH - CELLSIZEH / 2)
                              aPicturePx(x, y) = tmp
                           Next
                        Next
                        StopDrawing()
                        If CreateImage(#Image, XXX, YYY, 24, #PB_Image_Transparent)
                           ; 						If CreateImage(#Image, XXX, YYY)
                           If StartDrawing(ImageOutput(#Image))
                              DrawingMode(#PB_2DDrawing_Transparent)
                              For y = 1 To YYY
                                 For x = 1 To XXX
                                    If aPicturePx(x, y) <> #Transparency
                                       Plot(x - 1, y - 1, aPicturePx(x, y))
                                    EndIf
                                 Next
                              Next
                              StopDrawing()
                              ; tmp$ = SaveFileRequester("Выберите файл для сохранения", GetCurrentDirectory(), "img|*.bmp;*.png;*.gif;*.ico", 0)
                              tmp$ = SaveFileRequester("Select file to save", GetCurrentDirectory(), "*.bmp|*.bmp|*.png|*.png", 0)
                              If Asc(tmp$)
                                 Select GetExtensionPart(tmp$)
                                    Case "png"
                                       ImagePlugin = #PB_ImagePlugin_PNG ; не сохраняет в png а движок жрёт 150 кб исполняемого файла, убрал пока
                                    Case "bmp"
                                       ImagePlugin = #PB_ImagePlugin_BMP
                                    Default
                                       tmp$ + ".bmp"
                                       ImagePlugin = #PB_ImagePlugin_BMP
                                 EndSelect
                                 ; 									Debug tmp$
                                 ; 									выводим на холст палитры, всё нормально с изображением
                                 ; 									If StartDrawing(CanvasOutput(#cnvPalette))
                                 ; 										DrawImage(ImageID(#Image), 1, 1)
                                 ; 										StopDrawing()
                                 ; 									EndIf
                                 If SaveImage(#Image, tmp$, ImagePlugin)
                                    MessageRequester(Lng(6), tmp$)
                                 Else
                                    MessageRequester(Lng(7), Lng(8))
                                 EndIf
                              EndIf
                           EndIf
                           FreeImage(#Image)
                        EndIf
                     EndIf
                     
                     ;- Canvas Palette (event)
                  Case #cnvPalette
                     ; 					ecnv = EventType()
                     Select EventType()
                        Case #PB_EventType_MouseWheel
                           ; 							Debug
                           mxx = GetGadgetAttribute(#cnvPalette, #PB_Canvas_MouseX)
                           myy = GetGadgetAttribute(#cnvPalette, #PB_Canvas_MouseY)
                           If mxx >= 0 And mxx <= 90 And myy >= 0 And myy <= 100
                              arr_hsb(1) + GetGadgetAttribute(#cnvPalette, #PB_Canvas_WheelDelta) * 5
                              If arr_hsb(1) < 0
                                 arr_hsb(1) = 0
                                 Continue
                              ElseIf arr_hsb(1) > 100
                                 arr_hsb(1) = 100
                                 Continue
                              EndIf
                              ; 								Debug arr_hsb(1)
                              If StartDrawing(CanvasOutput(#cnvPalette))
                                 For j = 0 To 90
                                    arr_hsb(2) = 100 - j
                                    For i = 0 To w
                                       arr_hsb(0) = i * 360 / w
                                       hsb_to_rgb()
                                       Plot(j, i, RGB(arr_rgb(0), arr_rgb(1), arr_rgb(2)))
                                    Next
                                 Next
                                 StopDrawing()
                              EndIf
                           EndIf
                        Case #PB_EventType_LeftClick
                           mxx = GetGadgetAttribute(#cnvPalette, #PB_Canvas_MouseX)
                           myy = GetGadgetAttribute(#cnvPalette, #PB_Canvas_MouseY)
                           ; 							Debug mxx
                           ; 							Debug myy
                           If mxx >= 0 And mxx <= 90 And myy >= 0 And myy <= 100
                              If StartDrawing(CanvasOutput(#cnvPalette))
                                 selectedColor = Point(GetGadgetAttribute(#cnvPalette, #PB_Canvas_MouseX), GetGadgetAttribute(#cnvPalette, #PB_Canvas_MouseY))
                                 StopDrawing()
                                 SetColorBox(selectedColor)
                                 SetGadgetText(#HexColor, RSet(Hex(RGBtoBGR(selectedColor)), 6, "0"))
                              EndIf
                           EndIf
                           If mxx >= 93 And mxx <= 103 And myy >= 0 And myy <= 100
                              arr_hsb(1) = 100 - myy
                              ; 								Debug arr_hsb(1)
                              If StartDrawing(CanvasOutput(#cnvPalette))
                                 For j = 0 To 90
                                    arr_hsb(2) = 100 - j
                                    For i = 0 To w
                                       arr_hsb(0) = i * 360 / w
                                       hsb_to_rgb()
                                       Plot(j, i, RGB(arr_rgb(0), arr_rgb(1), arr_rgb(2)))
                                    Next
                                 Next
                                 StopDrawing()
                              EndIf
                           EndIf
                     EndSelect
                     
                     
                     
                     
                     ;- Canvas Scene (event)		
                  Case #cnvScene
                     ; 					ecnv = EventType()
                     Select EventType()
                        Case #PB_EventType_RightButtonDown
                           delmode = 1
                           DrawPixel(0)
                           pendown = 1
                        Case #PB_EventType_LeftButtonDown
                           If GetGadgetAttribute(#cnvScene, #PB_Canvas_Modifiers) & #PB_Canvas_Control
                              x = GetGadgetAttribute(#cnvScene, #PB_Canvas_MouseX)
                              y = GetGadgetAttribute(#cnvScene, #PB_Canvas_MouseY)
                              If StartDrawing(CanvasOutput(#cnvScene))
                                 selectedColor = Point(x, y)
                                 StopDrawing()
                                 SetColorBox(selectedColor)
                                 SetGadgetText(#HexColor, RSet(Hex(RGBtoBGR(selectedColor)), 6, "0"))
                              EndIf
                           Else
                              Select DrawingTool
                                 Case 1
                                    DrawPixel(selectedColor)
                                    pendown = 1
                                 Case 2
                                    DrawCan()
                                    ; 										DrawCan2() ; mode = Solid
                              EndSelect
                           EndIf
                           
                        Case #PB_EventType_LeftButtonUp, #PB_EventType_RightButtonUp
                           CountUndo = 0
                           pendown = 0
                           delmode = 0
                        Case #PB_EventType_MouseMove
                           If pendown = 1
                              x = Int(GetGadgetAttribute(#cnvScene, #PB_Canvas_MouseX) / CELLSIZEW)
                              y = Int(GetGadgetAttribute(#cnvScene, #PB_Canvas_MouseY) / CELLSIZEH)
                              ; 								защиты выхода за пределы массива предотвращая запись в границы -3 иного значения
                              If x < 0 Or x > XXX - 1 Or y < 0 Or y > YYY - 1
                                 Continue
                              EndIf
                              ; преобразование в позицию квадратов x, y, чтобы сравнить являются ли квадраты на одной линии
                              mxx = x * CELLSIZEW
                              myy = y * CELLSIZEH
                              If mxxOld = mxx And myyOld = myy
                                 Continue
                              Else
                                 mxxOld = mxx
                                 myyOld = myy
                              EndIf
                              
                              If StartDrawing(CanvasOutput(#cnvScene))
                                 If delmode
                                    aPicturePx(x + 1, y + 1) = 0
                                    Select StyleBox
                                       Case 0
                                          Box(mxx, myy, CELLSIZEW, CELLSIZEH, 0)
                                       Case 1
                                          Box(mxx, myy, CELLSIZEW - 1, CELLSIZEH - 1, 0)
                                       Case 2
                                          RoundBox(mxx + 1, myy + 1, CELLSIZEW - 2, CELLSIZEH - 2, 2, 2, 0)
                                    EndSelect
                                 Else
                                    aPicturePx(x + 1, y + 1) = selectedColor
                                    Select StyleBox
                                       Case 0
                                          Box(mxx, myy, CELLSIZEW, CELLSIZEH, selectedColor)
                                       Case 1
                                          Box(mxx, myy, CELLSIZEW - 1, CELLSIZEH - 1, selectedColor)
                                       Case 2
                                          RoundBox(mxx + 1, myy + 1, CELLSIZEW - 2, CELLSIZEH - 2, 2, 2, selectedColor)
                                    EndSelect
                                 EndIf
                                 StopDrawing()
                              EndIf
                           EndIf
                     EndSelect
               EndSelect
         EndSelect
      ForEver
      
      
      
      
      Procedure RotateColor(Gadget)
         Protected tmp
         For y = 1 To YYY
            For x = 1 To XXX
               If aPicPxOld(x, y) <> #Transparency
                  arr_rgb(0) = Red(aPicPxOld(x, y))
                  arr_rgb(1) = Green(aPicPxOld(x, y))
                  arr_rgb(2) = Blue(aPicPxOld(x, y))
                  rgb_to_hsb()
                  tmp = GetGadgetState(Gadget)
                  ; 			Debug tmp
                  Select Gadget
                     Case #tbgTone
                        arr_hsb(0) + tmp
                     Case #tbgBrightness
                        arr_hsb(1) = tmp
                     Case #tbgSaturation
                        arr_hsb(2) = tmp
                  EndSelect
                  hsb_to_rgb()
                  aPicturePx(x, y) = RGB(arr_rgb(0), arr_rgb(1), arr_rgb(2))
               EndIf
            Next
         Next
         
         If StartDrawing(CanvasOutput(#cnvScene))
            Box(0, 0, BoxAreaX, BoxAreaY, 0)
            
            For y = 1 To YYY
               For x = 1 To XXX
                  Select StyleBox
                     Case 0
                        Box((x - 1) * CELLSIZEW, (y - 1) * CELLSIZEH, CELLSIZEW, CELLSIZEH, aPicturePx(x, y))
                     Case 1
                        Box((x - 1) * CELLSIZEW, (y - 1) * CELLSIZEH, CELLSIZEW - 1, CELLSIZEH - 1, aPicturePx(x, y))
                     Case 2
                        RoundBox((x - 1) * CELLSIZEW + 1, (y - 1) * CELLSIZEH + 1, CELLSIZEW - 2, CELLSIZEH - 2, 2, 2, aPicturePx(x, y))
                  EndSelect
               Next
            Next
            StopDrawing()
         EndIf
      EndProcedure
      
      
      Procedure GUI2()
         
         CopyArray(aPicturePx(), aPicPxOld())
         DisableWindow(#Window, #True)
         
         
         OpenWindow(#Win1, 0, 0, 380, 110, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered, WindowID(#Window))
         ; 	Tone, Brightness, Saturation
         TrackBarGadget(#tbgTone, 10, 10, 360, 30, 0, 360)
         TrackBarGadget(#tbgBrightness, 10, 40, 360, 30, 0, 100)
         TrackBarGadget(#tbgSaturation, 10, 70, 360, 30, 0, 100)
         SetGadgetState(#tbgBrightness, 100)
         SetGadgetState(#tbgSaturation, 100)
         
         Repeat
            Select WaitWindowEvent()
               Case #PB_Event_Gadget
                  Select EventGadget()
                     Case #tbgTone
                        RotateColor(#tbgTone)
                     Case #tbgBrightness
                        RotateColor(#tbgBrightness)
                     Case #tbgSaturation
                        RotateColor(#tbgSaturation)
                  EndSelect
               Case #PB_Event_CloseWindow
                  Break
            EndSelect
         ForEver
         
         DisableWindow(#Window, #False)
         CloseWindow(#Win1)
      EndProcedure
      
      
      Procedure OpenImg(tmp$)
         If LoadImage(#Image, tmp$)
            If StartDrawing(CanvasOutput(#cnvScene))
               If GetExtensionPart(tmp$) = "ico"
                  XXX = ImageWidth(#Image)
                  YYY = ImageHeight(#Image)
                  ; Debug XXX
                  ; Debug YYY
                  Box(0, 0, XXX + 1, YYY + 1, #Transparency) ; стираем холст цветом, который задан как прозрачный
                  Dim aPicturePx(XXX + 1, YYY + 1)           ; пересоздаём массив, в отличии от ReDim Dim стирает данные, но они и не нужны.
                  Dim aPicPxOld(XXX + 1, YYY + 1)            ; пересоздаём массив, в отличии от ReDim Dim стирает данные, но они и не нужны.
                  Border()
                  CELLSIZEW = BoxAreaX / XXX
                  CELLSIZEH = BoxAreaY / YYY
               Else
                  ResizeImage(#Image, XXX , YYY, #PB_Image_Smooth)
                  ; 									ResizeImage(#Image, AreaX , AreaY, #PB_Image_Raw)
               EndIf
               SetWindowTitle(#Window, "IconEditor   (" + Str(XXX) + "x" + Str(YYY) + ")")
               DrawImage(ImageID(#Image), 0, 0)
               ; 	считываем пиксели рисунка в массив
               For y = 0 To YYY - 1
                  For x = 0 To XXX - 1
                     tmp = Point(x, y)
                     ; 										Debug tmp
                     aPicturePx(x + 1, y + 1) = tmp
                  Next
               Next
               Box(0, 0, BoxAreaX, BoxAreaY, #Transparency) ; стираем холст
               For y = 1 To YYY
                  For x = 1 To XXX
                     Select StyleBox
                        Case 0
                           Box((x - 1) * CELLSIZEW, (y - 1) * CELLSIZEH, CELLSIZEW, CELLSIZEH, aPicturePx(x, y))
                        Case 1
                           Box((x - 1) * CELLSIZEW, (y - 1) * CELLSIZEH, CELLSIZEW - 1, CELLSIZEH - 1, aPicturePx(x, y))
                        Case 2
                           RoundBox((x - 1) * CELLSIZEW + 1, (y - 1) * CELLSIZEH + 1, CELLSIZEW - 2, CELLSIZEH - 2, 2, 2, aPicturePx(x, y))
                     EndSelect
                  Next
               Next
               StopDrawing()
            EndIf
            FreeImage(#Image)
         EndIf
      EndProcedure
      
      
      Procedure Border()
         ; массив данных ограничен с краёв линией со значением -3
         y = 0
         For x = 0 To XXX + 1
            aPicturePx(x, y) = -3
         Next
         y = YYY + 1
         For x = 0 To XXX + 1
            aPicturePx(x, y) = -3
         Next
         x = 0
         For y = 0 To YYY + 1
            aPicturePx(x, y) = -3
         Next
         x = XXX + 1
         For y = 0 To YYY + 1
            aPicturePx(x, y) = -3
         Next
      EndProcedure
      
      
      Procedure DrawPixel(selectedColor)
         Protected myy, mxx, x, y
         CopyArray(aPicturePx() , aPicPxOld())
         x = Int(GetGadgetAttribute(#cnvScene, #PB_Canvas_MouseX) / CELLSIZEW) + 1
         y = Int(GetGadgetAttribute(#cnvScene, #PB_Canvas_MouseY) / CELLSIZEH) + 1
         ; защиты выхода за пределы массива предотвращая запись в границы -3 иного значения
         If x < 1 Or x > XXX Or y < 1 Or y > YYY
            ProcedureReturn
         EndIf
         aPicturePx(x, y) = selectedColor
         ; преобразование в позицию квадратов x, y, чтобы сравнить являются ли квадраты на одной линии
         mxx = (x - 1) * CELLSIZEW
         myy = (y - 1) * CELLSIZEH
         If StartDrawing(CanvasOutput(#cnvScene))
            Select StyleBox
               Case 0
                  Box(mxx, myy, CELLSIZEW, CELLSIZEH, selectedColor)
               Case 1
                  Box(mxx, myy, CELLSIZEW - 1, CELLSIZEH - 1, selectedColor)
               Case 2
                  RoundBox(mxx + 1, myy + 1, CELLSIZEW - 2, CELLSIZEH - 2, 2, 2, selectedColor)
            EndSelect
            StopDrawing()
         EndIf
         CountUndo = 0
      EndProcedure
      
      
      Procedure DrawArea(x, y)
         If aPicturePx(x - 1, y) = ClickColor
            aPicturePx(x - 1, y) = -1
            DrawArea(x - 1, y)
         EndIf
         
         If aPicturePx(x, y - 1) = ClickColor
            aPicturePx(x, y - 1) = -1
            DrawArea(x, y - 1)
         EndIf
         
         If aPicturePx(x + 1, y) = ClickColor
            aPicturePx(x + 1, y) = -1
            DrawArea(x + 1, y)
         EndIf
         
         If aPicturePx(x, y + 1) = ClickColor
            aPicturePx(x, y + 1) = -1
            DrawArea(x, y + 1)
         EndIf
      EndProcedure
      
      
      Procedure DrawCan()
         Protected myy, mxx, x, y
         CopyArray(aPicturePx(), aPicPxOld())
         ; 	реальные координаты в пикселах
         x = GetGadgetAttribute(#cnvScene, #PB_Canvas_MouseX)
         y = GetGadgetAttribute(#cnvScene, #PB_Canvas_MouseY)
         
         If StartDrawing(CanvasOutput(#cnvScene))
            ClickColor = Point(x, y)
            
            ; 		массив создаётся заранее, поэтому сграбливать его не надо
            ; 		DrawingMode(#PB_2DDrawing_Transparent)
            ; 		For y = 1 To YYY
            ; 			For x = 1 To XXX
            ; 				tmp = Point(x * CELLSIZEW - CELLSIZEW / 2, y * CELLSIZEH - CELLSIZEH / 2)
            ; 				aPicturePx(x, y) = tmp
            ; 				Debug
            ; 			Next
            ; 		Next
            StopDrawing()
         EndIf
         
         
         ; 	If ClickColor = #Transparency ; Or ClickColor = 0
         ; 		ProcedureReturn
         ; 	EndIf
         
         ; преобразование в позицию квадратов x, y, чтобы сравнить являются ли квадраты на одной линии
         mxx = Int(x / CELLSIZEW) + 1
         myy = Int(y / CELLSIZEH) + 1
         ; защиты выхода за пределы массива
         ; 	If mxx < 0 Or mxx > XXX Or myy < 0 Or myy > YYY
         ; 		ProcedureReturn
         ; 	EndIf
         DrawArea(mxx, myy)
         aPicturePx(mxx, myy) = -1
         ; 	Debug  aPicturePx(mxx, myy)
         ; 	Debug ClickColor
         ; 	Debug mxx
         ; 	Debug myy
         
         If StartDrawing(CanvasOutput(#cnvScene))
            For y = 1 To YYY
               For x = 1 To XXX
                  If aPicturePx(x, y) = -1
                     aPicturePx(x, y) = selectedColor
                     Select StyleBox
                        Case 0
                           Box((x - 1) * CELLSIZEW, (y - 1) * CELLSIZEH, CELLSIZEW, CELLSIZEH, selectedColor)
                        Case 1
                           Box((x - 1) * CELLSIZEW, (y - 1) * CELLSIZEH, CELLSIZEW - 1, CELLSIZEH - 1, selectedColor)
                        Case 2
                           RoundBox((x - 1) * CELLSIZEW + 1, (y - 1) * CELLSIZEH + 1, CELLSIZEW - 2, CELLSIZEH - 2, 2, 2, selectedColor)
                     EndSelect
                  EndIf
               Next
            Next
            StopDrawing()
         EndIf
         CountUndo = 0
      EndProcedure
      
      ; Procedure DrawCan2()
      ; 	Protected x, y
      ; 	CopyArray(aPicturePx() , aPicPxOld())
      ; ; 	реальные координаты в пикселах
      ; 	x = GetGadgetAttribute(#cnvScene, #PB_Canvas_MouseX)
      ; 	y = GetGadgetAttribute(#cnvScene, #PB_Canvas_MouseY)
      ; 
      ; 	If StartDrawing(CanvasOutput(#cnvScene))
      ; 		FillArea(x, y, -1, selectedColor)
      ; 		StopDrawing()
      ; 	EndIf
      ; EndProcedure
      
      
      Procedure Rotate(Direction)
         CopyArray(aPicturePx(), aPicPxOld())
         For y = 1 To YYY
            For x = 1 To XXX
               Select Direction
                  Case 0
                     aPicturePx(x, y) = aPicPxOld(y, XXX - x + 1)
                  Case 1
                     aPicturePx(x, y) = aPicPxOld(YYY - y + 1, x)
                  Case 2
                     aPicturePx(x, y) = aPicPxOld(XXX - x + 1, y)
                  Case 3
                     aPicturePx(x, y) = aPicPxOld(x, YYY - y + 1)
               EndSelect
               
               ; 			If Direction
               ; 				aPicturePx(x, y) = aPicPxOld(YYY - y + 1, x)
               ; 			Else
               ; 				aPicturePx(x, y) = aPicPxOld(y, XXX - x + 1)
               ; 			EndIf
            Next
         Next
         If StartDrawing(CanvasOutput(#cnvScene))
            Box(0, 0, BoxAreaX, BoxAreaY, 0)
            
            For y = 1 To YYY
               For x = 1 To XXX
                  Select StyleBox
                     Case 0
                        Box((x - 1) * CELLSIZEW, (y - 1) * CELLSIZEH, CELLSIZEW, CELLSIZEH, aPicturePx(x, y))
                     Case 1
                        Box((x - 1) * CELLSIZEW, (y - 1) * CELLSIZEH, CELLSIZEW - 1, CELLSIZEH - 1, aPicturePx(x, y))
                     Case 2
                        RoundBox((x - 1) * CELLSIZEW + 1, (y - 1) * CELLSIZEH + 1, CELLSIZEW - 2, CELLSIZEH - 2, 2, 2, aPicturePx(x, y))
                  EndSelect
               Next
            Next
            StopDrawing()
         EndIf
      EndProcedure
      
      
      Procedure SetColorBox(Color)
         If StartDrawing(ImageOutput(#imgColor))
            Box(0, 0, 33, 33, Color)
            StopDrawing()
            CompilerIf #PB_Compiler_OS = #PB_OS_Linux
               SetGadgetAttribute(#btnColor, #PB_Button_Image, ImageID(#imgDummy))
            CompilerEndIf
            SetGadgetAttribute(#btnColor, #PB_Button_Image, ImageID(#imgColor))
         EndIf
      EndProcedure
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 920
; FirstLine = 920
; Folding = ------------------
; EnableAsm
; EnableXP
; DPIAware
; UseIcon = icon.ico
; Executable = IconEditor.exe
; CompileSourceDirectory
; EnableBuildCount = 1
; IncludeVersionInfo
; VersionField0 = 1.0.0.%BUILDCOUNT
; VersionField2 = AZJIO
; VersionField3 = IconEditor
; VersionField4 = 1.0.0
; VersionField6 = IconEditor
; VersionField9 = AZJIO