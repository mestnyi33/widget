EnableExplicit

Global WINDOW_IMAGE = - 1

Global IMAGE_VIEW = - 1
Global BUTTON_OPEN = - 1
Global BUTTON_SAVE = - 1
Global BUTTON_COPY = - 1
Global BUTTON_CUT = - 1
Global BUTTON_PASTE = - 1
Global BUTTON_OK = - 1
Global BUTTON_CANCEL = - 1

Procedure Open_WINDOW_IMAGE( )
   WINDOW_IMAGE = OpenWindow( #PB_Any, 7, 7, 372, 232, "Редактор изображения" )
   IMAGE_VIEW = ContainerGadget( #PB_Any, 7, 7, 253, 218, #PB_Container_Flat ) : CloseGadgetList( )
   ;IMAGE_VIEW = ImageGadget( #PB_Any, 7, 7, 253, 218, 0 )
   BUTTON_OPEN = ButtonGadget( #PB_Any, 266, 7, 99, 22, "Открыть" ) ;: widget: :CloseList( )
   BUTTON_SAVE = ButtonGadget( #PB_Any, 266, 35, 99, 22, "Сохранить" )
   BUTTON_COPY = ButtonGadget( #PB_Any, 266, 77, 99, 22, "Копировать" )
   BUTTON_CUT = ButtonGadget( #PB_Any, 266, 105, 99, 22, "Вырезать" )
   BUTTON_PASTE = ButtonGadget( #PB_Any, 266, 133, 99, 22, "Вставить" )
   BUTTON_OK = ButtonGadget( #PB_Any, 266, 175, 99, 22, "Ок" )
   BUTTON_CANCEL = ButtonGadget( #PB_Any, 266, 203, 99, 22, "Отмена" )
   
   ; SetGadgetColor( IMAGE_VIEW, #PB_Gadget_BackColor, $BA54EDDE )
   SetGadgetColor( IMAGE_VIEW, #PB_Gadget_BackColor, RGBA(222, 237, 84, 186) )
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_IMAGE( )
   
   Define event
   While IsWindow( WINDOW_IMAGE )
      event = WaitWindowEvent( )
      
      Select EventWindow( )
         Case WINDOW_IMAGE
      EndSelect
      
      Select event
         Case #PB_Event_CloseWindow
            If WINDOW_IMAGE = EventWindow( )
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
; CursorPosition = 17
; FirstLine = 13
; Folding = --
; EnableXP
; DPIAware