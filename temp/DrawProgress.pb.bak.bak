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

Global image

Macro Wait( _time_ )
   WindowEvent()
   Delay(_time_)
EndMacro

Procedure DrawProgress( image, width, height, color, reverse=0)
   Protected i
   For i=0 To width Step 2
      If StartDrawing(ImageOutput(image))
         If reverse
            Line(width - i, 0, 1,height ,color)
         Else
            Line(i, 0, 1,height ,color)
         EndIf
         StopDrawing()
         SetGadgetState(#Gadget_image,ImageID(image))
         Wait(15)
      EndIf
   Next i
   
EndProcedure

;//////////////////////////////////////////////////////////////
image = CreateImage(#PB_Any, 324, 20)

OpenWindow(#Window_0, 0, 0, 350, 80, "Индикатор", #PB_Window_ScreenCentered | #PB_Window_BorderLess )
SetWindowColor(#Window_0, $000000)

ImageGadget(#Gadget_image,10, 10, 324,20, ImageID(image))
TextGadget(#Gadget_info, 10, 45, 324, 15, "Подключение к сети", #PB_Text_Center)

SetGadgetColor(#Gadget_info, #PB_Gadget_FrontColor, $055AE6)
SetGadgetColor(#Gadget_info, #PB_Gadget_BackColor, $000000)

DrawProgress(image, 324, 20, $E3031C)

SetGadgetText(#Gadget_info, "Загрузка информации из сети")

DrawProgress(image, 324, 20, $0302FC, 1)

SetGadgetText(#Gadget_info,  "Не предвиденный сбой")

DrawProgress(image, 324, 20, $000000)

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
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 68
; FirstLine = 35
; Folding = -
; EnableXP