EnableExplicit

Global TEST = - 1

Enumeration 
   #R1Y1G1B1
   #R1Y1G1B1P1
   #R1Y1G1B1P2
   #R1Y1G1B1P3
   #R1Y1G1B1P4
   #R1Y1G1B2
   #R1Y1G1B2P1
   #R1Y1G1B2P2
   #R1Y1G1B2P3
   #R1Y1G1B2P4
EndEnumeration


Procedure Open_TEST( )
   TEST = OpenWindow( #PB_Any, 7, 7, 575, 316, "window_test" )
   ContainerGadget( #R1Y1G1B1, 7, 7, 50, 50,  #PB_Container_Single  )
   ContainerGadget( #R1Y1G1B1P1, 7, 7, 15, 15,  #PB_Container_Single  )
   CloseGadgetList( )
   
   ContainerGadget( #R1Y1G1B1P2, 28, 7, 15, 15,  #PB_Container_Single  )
   CloseGadgetList( )
   
   ContainerGadget( #R1Y1G1B1P3, 7, 28, 15, 15,  #PB_Container_Single  )
   CloseGadgetList( )
   
   ;ButtonGadget( #R1Y1G1B1P4, 28, 28, 15, 15,  "butt"  )
   ContainerGadget( #R1Y1G1B1P4, 28, 28, 15, 15,  #PB_Container_Single  )
   CloseGadgetList( )
   CloseGadgetList( )
   
   ContainerGadget( #R1Y1G1B2, 63, 7, 50, 50,  #PB_Container_Single  )
   ContainerGadget( #R1Y1G1B2P1, 7, 7, 15, 15,  #PB_Container_Single  )
   CloseGadgetList( )
   
   ContainerGadget( #R1Y1G1B2P2, 28, 7, 15, 15,  #PB_Container_Single  )
   CloseGadgetList( )
   
   ContainerGadget( #R1Y1G1B2P3, 7, 28, 15, 15,  #PB_Container_Single  )
   CloseGadgetList( )
   
   ContainerGadget( #R1Y1G1B2P4, 28, 28, 15, 15,  #PB_Container_Single  )
   CloseGadgetList( )
   CloseGadgetList( )
   
   
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_TEST( )
   
   Define event
   While IsWindow( TEST )
      event = WaitWindowEvent( )
      
      Select EventWindow( )
         Case TEST
      EndSelect
      
      Select event
         Case #PB_Event_CloseWindow
            If EventWindow( ) = TEST
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
; CursorPosition = 47
; FirstLine = 15
; Folding = --
; EnableXP
; DPIAware