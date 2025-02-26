EnableExplicit

Procedure Open_WINDOW_IMAGE( )
   OpenWindow( 1, 7, 7, 372, 232, "Редактор изображения" )
   ImageGadget( 1, 7, 7, 253, 218, 0 )
   ButtonGadget( 2, 266, 7, 99, 22, "Открыть" )
   ButtonGadget( 3, 266, 35, 99, 22, "Сохранить" )
   ButtonGadget( 4, 266, 77, 99, 22, "Копировать" )
   ButtonGadget( 5, 266, 105, 99, 22, "Вырезать" )
   ButtonGadget( 6, 266, 133, 99, 22, "Вставить" )
   ButtonGadget( 7, 266, 175, 99, 22, "Ок" )
   ButtonGadget( 8, 266, 203, 99, 22, "Отмена" )
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_IMAGE( )
   
   Define event
   While IsWindow( 1 )
      event = WaitWindowEvent( )
      
      Select EventWindow( )
         Case 1
      EndSelect
      
      Select event
         Case #PB_Event_CloseWindow
            If 1 = EventWindow( )
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
; CursorPosition = 27
; Folding = --
; EnableXP
; DPIAware