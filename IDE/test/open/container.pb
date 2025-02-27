EnableExplicit

Global TEST = - 1

Global R1 = - 1
Global R1Y1 = - 1
Global R1Y1G1 = - 1
Global R1Y1G1B1 = - 1
Global R1Y1G1B1P1 = - 1
Global R1Y1G1B1P2 = - 1
Global R1Y1G1B1P3 = - 1
Global R1Y1G1B1P4 = - 1
Global R1Y1G1B2 = - 1
Global R1Y1G1B2P1 = - 1
Global R1Y1G1B2P2 = - 1
Global R1Y1G1B2P3 = - 1
Global R1Y1G1B2P4 = - 1
Global R1Y1G1B3 = - 1
Global R1Y1G1B3P1 = - 1
Global R1Y1G1B3P2 = - 1
Global R1Y1G1B3P3 = - 1
Global R1Y1G1B3P4 = - 1
Global R1Y1G1B4 = - 1
Global R1Y1G1B4P1 = - 1
Global R1Y1G1B4P2 = - 1
Global R1Y1G1B4P3 = - 1
Global R1Y1G1B4P4 = - 1
Global R1Y1G2 = - 1
Global R1Y1G2B1 = - 1
Global R1Y1G2B1P1 = - 1
Global R1Y1G2B1P2 = - 1
Global R1Y1G2B1P3 = - 1
Global R1Y1G2B1P4 = - 1
Global R1Y1G2B2 = - 1
Global R1Y1G2B2P1 = - 1
Global R1Y1G2B2P2 = - 1
Global R1Y1G2B2P3 = - 1
Global R1Y1G2B2P4 = - 1
Global R1Y1G2B3 = - 1
Global R1Y1G2B3P1 = - 1
Global R1Y1G2B3P2 = - 1
Global R1Y1G2B3P3 = - 1
Global R1Y1G2B3P4 = - 1
Global R1Y1G2B4 = - 1
Global R1Y1G2B4P1 = - 1
Global R1Y1G2B4P2 = - 1
Global R1Y1G2B4P3 = - 1
Global R1Y1G2B4P4 = - 1
Global R1Y1G3 = - 1
Global R1Y1G3B1 = - 1
Global R1Y1G3B1P1 = - 1
Global R1Y1G3B1P2 = - 1
Global R1Y1G3B1P3 = - 1
Global R1Y1G3B1P4 = - 1
Global R1Y1G3B2 = - 1
Global R1Y1G3B2P1 = - 1
Global R1Y1G3B2P2 = - 1
Global R1Y1G3B2P3 = - 1
Global R1Y1G3B2P4 = - 1
Global R1Y1G3B3 = - 1
Global R1Y1G3B3P1 = - 1
Global R1Y1G3B3P2 = - 1
Global R1Y1G3B3P3 = - 1
Global R1Y1G3B3P4 = - 1
Global R1Y1G3B4 = - 1
Global R1Y1G3B4P1 = - 1
Global R1Y1G3B4P2 = - 1
Global R1Y1G3B4P3 = - 1
Global R1Y1G3B4P4 = - 1
Global R1Y1G4 = - 1
Global R1Y1G4B1 = - 1
Global R1Y1G4B1P1 = - 1
Global R1Y1G4B1P2 = - 1
Global R1Y1G4B1P3 = - 1
Global R1Y1G4B1P4 = - 1
Global R1Y1G4B2 = - 1
Global R1Y1G4B2P1 = - 1
Global R1Y1G4B2P2 = - 1
Global R1Y1G4B2P3 = - 1
Global R1Y1G4B2P4 = - 1
Global R1Y1G4B3 = - 1
Global R1Y1G4B3P1 = - 1
Global R1Y1G4B3P2 = - 1
Global R1Y1G4B3P3 = - 1
Global R1Y1G4B3P4 = - 1
Global R1Y1G4B4 = - 1
Global R1Y1G4B4P1 = - 1
Global R1Y1G4B4P2 = - 1
Global R1Y1G4B4P3 = - 1
Global R1Y1G4B4P4 = - 1


Procedure Open_TEST( )
   TEST = OpenWindow( #PB_Any, 0, 0, 582, 582, "",  #PB_Window_SystemMenu | #PB_Window_ScreenCentered  )
      R1 = ContainerGadget( #PB_Any, 7, 7, 568, 568,  #PB_Container_Single  )
         R1Y1 = ContainerGadget( #PB_Any, 7, 7, 274, 274,  #PB_Container_Single  )
            R1Y1G1 = ContainerGadget( #PB_Any, 7, 7, 127, 127,  #PB_Container_Single  )
               R1Y1G1B1 = ContainerGadget( #PB_Any, 7, 7, 50, 50,  #PB_Container_Single  )
                  R1Y1G1B1P1 = ContainerGadget( #PB_Any, 7, 7, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
                  
                  R1Y1G1B1P2 = ContainerGadget( #PB_Any, 28, 7, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
                  
                  R1Y1G1B1P3 = ContainerGadget( #PB_Any, 7, 28, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
                  
                  R1Y1G1B1P4 = ContainerGadget( #PB_Any, 28, 28, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
               CloseGadgetList( )
               
               R1Y1G1B2 = ContainerGadget( #PB_Any, 63, 7, 50, 50,  #PB_Container_Single  )
                  R1Y1G1B2P1 = ContainerGadget( #PB_Any, 7, 7, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
                  
                  R1Y1G1B2P2 = ContainerGadget( #PB_Any, 28, 7, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
                  
                  R1Y1G1B2P3 = ContainerGadget( #PB_Any, 7, 28, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
                  
                  R1Y1G1B2P4 = ContainerGadget( #PB_Any, 28, 28, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
               CloseGadgetList( )
               
               R1Y1G1B3 = ContainerGadget( #PB_Any, 7, 63, 50, 50,  #PB_Container_Single  )
                  R1Y1G1B3P1 = ContainerGadget( #PB_Any, 7, 7, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
                  
                  R1Y1G1B3P2 = ContainerGadget( #PB_Any, 28, 7, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
                  
                  R1Y1G1B3P3 = ContainerGadget( #PB_Any, 7, 28, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
                  
                  R1Y1G1B3P4 = ContainerGadget( #PB_Any, 28, 28, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
               CloseGadgetList( )
               
               R1Y1G1B4 = ContainerGadget( #PB_Any, 63, 63, 50, 50,  #PB_Container_Single  )
                  R1Y1G1B4P1 = ContainerGadget( #PB_Any, 7, 7, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
                  
                  R1Y1G1B4P2 = ContainerGadget( #PB_Any, 28, 7, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
                  
                  R1Y1G1B4P3 = ContainerGadget( #PB_Any, 7, 28, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
                  
                  R1Y1G1B4P4 = ContainerGadget( #PB_Any, 28, 28, 15, 15,  #PB_Container_Single  )
                  CloseGadgetList( )
               CloseGadgetList( )
            CloseGadgetList( )
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
            If TEST = EventWindow( )
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
; CursorPosition = 150
; FirstLine = 128
; Folding = --
; EnableXP
; DPIAware