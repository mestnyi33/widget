﻿EnableExplicit

Global WINDOW_IMAGE = - 1

Procedure Open_WINDOW_IMAGE( X = 47, Y = 47, Width = 372, Height = 232, Text.s = "test variable and plus")
   WINDOW_IMAGE = OpenWindow( #PB_Any, X, Y, Width, Height, Text )
   ButtonGadget( #PB_Any,372-100-10,30,100,30,"btn")
   ButtonGadget( -1,10+30+50,80,100,30,"x=10+30+50")
   ButtonGadget( -1,10-30-50,140,100,30,"()x=10-30-50")
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
            If EventWindow( ) = WINDOW_IMAGE
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



; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 8
; Folding = --
; EnableXP
; DPIAware