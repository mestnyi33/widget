﻿; If OpenWindow(0, 0, 0, 200, 200, "Главное окно", #PB_Window_ScreenCentered)
; ;    Window_1 = OpenWindow(#PB_Any, 0, 0, 200, 200, "Первое окно")
; ;    
; ;    Window_2 = OpenWindow(#PB_Any, 200, 0, 200, 200, "Второе окно")
;    
;    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
; EndIf

EnableExplicit

Enumeration 
   #WINDOW_0 
   #WINDOW_1
   #WINDOW_2
EndEnumeration

Global BUTTON_0 = - 1
Global BUTTON_1 = - 1
Global BUTTON_2 = - 1
Global BUTTON_3 = - 1
Global BUTTON_4 = - 1
Global BUTTON_5 = - 1

Procedure Open_WINDOW_0( )
   OpenWindow( #WINDOW_0, 10, 10, 148, 175, "WINDOW_0",  #PB_Window_SystemMenu  )
   SetWindowColor( #WINDOW_0, $A3E9ED )
   
   BUTTON_0 = ButtonGadget( #PB_Any, 14, 14, 120, 64, "button_8" )
   BUTTON_1 = ButtonGadget( #PB_Any, 14, 91, 120, 71, "button_9" )
EndProcedure

Procedure Open_WINDOW_1( )
   OpenWindow( #WINDOW_1, 60, 120, 148, 175, "WINDOW_1",  #PB_Window_SystemMenu  )
   SetWindowColor( #WINDOW_1, $A3E9ED )
   
   BUTTON_2 = ButtonGadget( #PB_Any, 14, 14, 120, 64, "button_8" )
   BUTTON_3 = ButtonGadget( #PB_Any, 14, 91, 120, 71, "button_9" )
EndProcedure

Procedure Open_WINDOW_2( )
   OpenWindow( #WINDOW_2, 110, 240, 148, 175, "WINDOW_2",  #PB_Window_SystemMenu  )
   SetWindowColor( #WINDOW_2, $A3E9ED )
   
   BUTTON_4 = ButtonGadget( #PB_Any, 14, 14, 120, 64, "button_8" )
   BUTTON_5 = ButtonGadget( #PB_Any, 14, 91, 120, 71, "button_9" )
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_0( )
   Open_WINDOW_1( )
   Open_WINDOW_2( )
   
   Define exit
   Define event
   
   While Not exit
      event = WaitWindowEvent( )
      
      Select event
         Case #PB_Event_CloseWindow
            CloseWindow( EventWindow( ) )
            
            Debug GetActiveWindow( )
            Debug IsWindow(GetActiveWindow( ))
            exit = Bool( Not IsWindow(GetActiveWindow( )))
            
      EndSelect
   Wend
   
   End
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 41
; FirstLine = 18
; Folding = -
; EnableXP
; DPIAware