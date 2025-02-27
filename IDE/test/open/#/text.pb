EnableExplicit

Enumeration FormWindow
   #WINDOW_0
EndEnumeration

Enumeration FormGadget
   #TEXT_0
   #TEXT_1
   #FRAME_0
   #TEXT_BITS
   #FRAME_1
   #TEXT_KERIO
   #BTN_V32
   #BTN_V64
   #FRAME_2
   #TEXT_KERIO3
   #BTN_KERIO_START
   #FRAME_3
   #TEXT_KERIO2
   #EDITOR_0
   #FRAME_4
   #TEXT_KERIO4
   #BTN_RDP_START
   #EDITOR_4
   #EDITOR_3
   #FRAME_2_COPY1
   #TEXT_KERIO5
   #BTN_AA_START
   #EDITOR_5
   #BTN_PDF_START
EndEnumeration

Enumeration FormFont
  #Font_Window_0_0
  #Font_Window_0_1
EndEnumeration
 
LoadFont(#Font_Window_0_0,"Arial", 10, #PB_Font_Bold)
LoadFont(#Font_Window_0_1,"Arial", 12, #PB_Font_Bold)

Procedure Open_WINDOW_0( )
   OpenWindow( #WINDOW_0, 0, 35, 799, 638, "software installation assistant @ Sadstar (FreeWare)",  #PB_Window_SystemMenu | #PB_Window_SizeGadget  )
      TextGadget( #TEXT_0, 7, 7, 792, 22, "Помощник по установке дистанционного доступа к рабочему компьютеру",  #PB_Text_Center | #PB_Button_Right  )
      TextGadget( #TEXT_1, 7, 28, 792, 22, " для сотрудников ООО ТРБ-Ванино",  #PB_Text_Center | #PB_Button_Right  )
      FrameGadget( #FRAME_0, 7, 49, 792, 50, "" )
      TextGadget( #TEXT_BITS, 14, 63, 771, 22, "" )
      FrameGadget( #FRAME_1, 7, 98, 792, 50, "" )
      TextGadget( #TEXT_KERIO, 14, 119, 218, 22, "1. Установить Kerio VPN Client" )
      ButtonGadget( #BTN_V32, 245, 119, 211, 29, "Установить 32-битную версию" )
      ButtonGadget( #BTN_V64, 469, 119, 211, 29, "Установить 64-битную версию" )
      FrameGadget( #FRAME_2, 7, 238, 792, 78, "" )
      TextGadget( #TEXT_KERIO3, 14, 245, 246, 22, "3. Запустить Kerio VPN Client" )
      ButtonGadget( #BTN_KERIO_START, 14, 280, 274, 29, "Запустить Kerio VPN client" )
      FrameGadget( #FRAME_3, 7, 154, 792, 78, "" )
      TextGadget( #TEXT_KERIO2, 14, 175, 190, 22, "2. Получить коды доступа" )
      EditorGadget( #EDITOR_0, 210, 175, 582, 57 )
      FrameGadget( #FRAME_4, 7, 315, 792, 155, "" )
      TextGadget( #TEXT_KERIO4, 14, 329, 386, 22, "4. Запустить Подключение к удаленному рабочему столу" )
      ButtonGadget( #BTN_RDP_START, 413, 329, 274, 29, "Подключение к удаленному рабочему столу" )
      EditorGadget( #EDITOR_4, 14, 357, 778, 106 )
      EditorGadget( #EDITOR_3, 301, 245, 491, 64 )
      FrameGadget( #FRAME_2_COPY1, 7, 469, 792, 162, "" )
      TextGadget( #TEXT_KERIO5, 14, 490, 162, 22, "5. Аварийный вариант" )
      ButtonGadget( #BTN_AA_START, 28, 518, 127, 57, "программа дистанционного администрирования",  #PB_Button_Toggle | #PB_Button_Default | #PB_Button_MultiLine | #PB_Button_Default  )
      EditorGadget( #EDITOR_5, 175, 483, 617, 141 )
      ButtonGadget( #BTN_PDF_START, 28, 595, 127, 29, "  PDF инструкция",  #PB_Button_Toggle | #PB_Button_Default | #PB_Button_MultiLine | #PB_Button_Default  )
      
      SetWindowColor(#Window_0, RGB(128,255,255))
      
      SetGadgetColor(#Text_0, #PB_Gadget_FrontColor,RGB(0,0,255))
      SetGadgetColor(#Text_0, #PB_Gadget_BackColor,RGB(255,255,128))
      SetGadgetFont(#Text_0, FontID(#Font_Window_0_0))
      
      SetGadgetColor(#Text_1, #PB_Gadget_BackColor,RGB(128,255,255))
      SetGadgetFont(#Text_1, FontID(#Font_Window_0_0))
      
      SetGadgetColor(#Text_Bits, #PB_Gadget_BackColor,RGB(128,255,255))
      SetGadgetFont(#Text_Bits, FontID(#Font_Window_0_1))
      
      SetGadgetColor(#Text_Kerio, #PB_Gadget_BackColor,RGB(128,255,255))
      SetGadgetFont(#Text_Kerio, FontID(#Font_Window_0_0))
      
      SetGadgetColor(#Text_Kerio3, #PB_Gadget_BackColor,RGB(128,255,255))
      SetGadgetFont(#Text_Kerio3, FontID(#Font_Window_0_0))
      
      SetGadgetColor(#Text_Kerio2, #PB_Gadget_BackColor,RGB(128,255,255))
      SetGadgetFont(#Text_Kerio2, FontID(#Font_Window_0_0))
      
      SetGadgetFont(#Editor_0, FontID(#Font_Window_0_0))
      
      SetGadgetColor(#Text_Kerio4, #PB_Gadget_BackColor,RGB(128,255,255))
      SetGadgetFont(#Text_Kerio4, FontID(#Font_Window_0_0))
      
      SetGadgetFont(#Editor_4, FontID(#Font_Window_0_0))
      
      SetGadgetFont(#Editor_3, FontID(#Font_Window_0_0))
      
      SetGadgetColor(#Text_Kerio5, #PB_Gadget_BackColor,RGB(128,255,255))
      SetGadgetFont(#Text_Kerio5, FontID(#Font_Window_0_0))
      
      SetGadgetFont(#Editor_5, FontID(#Font_Window_0_0))
      
   EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_0( )

   Define event
   While IsWindow( #WINDOW_0 )
      event = WaitWindowEvent( )
      
      Select EventWindow( )
         Case #WINDOW_0
      EndSelect
      
      Select event
         Case #PB_Event_CloseWindow
            If #WINDOW_0 = EventWindow( )
               If #PB_MessageRequester_Yes = MessageRequester( "Message", 
                                                               "Are you sure you want To go out?", 
                                                               #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
                  CloseWindow( EventWindow( ) )
               EndIf
            Else
               CloseWindow( EventWindow( ) )
            EndIf
      EndSelect
   Wend
   End
CompilerEndIf



; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 97
; FirstLine = 65
; Folding = --
; EnableXP
; DPIAware