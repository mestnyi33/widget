;/////////////////////////PureBasic 4.30///////////////////////////////////////
; https://mirashic.narod.ru/zagryzka.htm

EnableExplicit
Enumeration
   #Window_0
EndEnumeration

Enumeration
   #Gadget_image
   #Gadget_info
EndEnumeration

Global Image

Macro Wait( _time_ )
   WindowEvent()
   Delay(_time_)
EndMacro

Procedure DrawProgressBarWidget( Image, Width, Height, color, reverse=0)
   Protected i
   For i=0 To Width Step 2
      If StartDrawing(ImageOutput(Image))
         If reverse
            Line(Width - i, 0, 1,Height ,color)
         Else
            Line(i, 0, 1,Height ,color)
         EndIf
         StopDrawing()
         SetGadgetState(#Gadget_image,ImageID(Image))
         Wait(15)
      EndIf
   Next i
   
EndProcedure

;//////////////////////////////////////////////////////////////
Image = CreateImage(#PB_Any, 324, 20)

OpenWindow(#Window_0, 0, 0, 350, 80, "Индикатор", #PB_Window_ScreenCentered | #PB_Window_BorderLess )
SetWindowColor(#Window_0, $000000)

ImageGadget(#Gadget_image,10, 10, 324,20, ImageID(Image))
TextGadget(#Gadget_info, 10, 45, 324, 15, "Подключение к сети", #PB_Text_Center)

SetGadgetColor(#Gadget_info, #PB_Gadget_FrontColor, $055AE6)
SetGadgetColor(#Gadget_info, #PB_Gadget_BackColor, $000000)

DrawProgressBarWidget(Image, 324, 20, $E3031C)

SetGadgetText(#Gadget_info, "Загрузка информации из сети")

DrawProgressBarWidget(Image, 324, 20, $0302FC, 1)

SetGadgetText(#Gadget_info,  "Не предвиденный сбой")

DrawProgressBarWidget(Image, 324, 20, $000000)

SetGadgetFont(#Gadget_info, LoadFont(301, "Microsoft Sans Serif", 14))
ResizeGadget(#Gadget_info, #PB_Ignore, 40, #PB_Ignore, 30)
SetGadgetText(#Gadget_info, "Ошибка")
Wait(2000)


OpenWindow(#Window_0, 0, 0, 350, 350, "Заголовок", #PB_Window_ScreenCentered | #PB_Window_SystemMenu )

Define Event
Repeat
   Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
End
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 57
; FirstLine = 28
; Folding = -
; EnableXP