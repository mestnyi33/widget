EnableExplicit

Enumeration FormWindow 
   #WINDOW_IMAGE 
EndEnumeration

Enumeration FormGadget
   #IMAGE_VIEW
   #BUTTON_OPEN
   #BUTTON_SAVE
   #BUTTON_COPY
   #BUTTON_CUT
   #BUTTON_PASTE
   #BUTTON_OK
   #BUTTON_CANCEL
EndEnumeration

Procedure Open_WINDOW_IMAGE( )
   OpenWindow( #WINDOW_IMAGE, 7, 7, 372, 232, "Редактор изображения" )
   ImageGadget( #IMAGE_VIEW, 7, 7, 253, 218, 0 )
   ButtonGadget( #BUTTON_OPEN, 266, 7, 99, 22, "Открыть" )
   ButtonGadget( #BUTTON_SAVE, 266, 35, 99, 22, "Сохранить" )
   ButtonGadget( #BUTTON_COPY, 266, 77, 99, 22, "Копировать" )
   ButtonGadget( #BUTTON_CUT, 266, 105, 99, 22, "Вырезать" )
   ButtonGadget( #BUTTON_PASTE, 266, 133, 99, 22, "Вставить" )
   ButtonGadget( #BUTTON_OK, 266, 175, 99, 22, "Ок" )
   ButtonGadget( #BUTTON_CANCEL, 266, 203, 99, 22, "Отмена" )
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_IMAGE( )
   
   Define event
   While IsWindow( #WINDOW_IMAGE )
      event = WaitWindowEvent( )
      
      Select EventWindow( )
         Case #WINDOW_IMAGE
      EndSelect
      
      Select event
         Case #PB_Event_CloseWindow
            If #WINDOW_IMAGE = EventWindow( )
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
; CursorPosition = 43
; FirstLine = 16
; Folding = --
; EnableXP
; DPIAware