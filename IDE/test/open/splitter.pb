EnableExplicit

Global WINDOW_0 = - 1

Global SCROLLAREA_0 = - 1
Global TREE_0 = - 1
Global PANEL_0 = - 1
Global SPLITTER_0 = - 1
Global SPLITTER_1 = - 1

Procedure Open_WINDOW_0( )
   WINDOW_0 = OpenWindow( #PB_Any, 7, 7, 505, 400, "WINDOW_0",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered  )
      SCROLLAREA_0 = ScrollAreaGadget( #PB_Any, 0, 0, 241, 393, 241, 391, 0 )
      CloseGadgetList( )
      TREE_0 = TreeGadget( #PB_Any, 0, 0, 241, 192 )
      PANEL_0 = PanelGadget( #PB_Any, 0, 201, 241, 192 )
      CloseGadgetList( )
         
       SPLITTER_0 = SplitterGadget( #PB_Any, 250, 0, 241, 393, TREE_0, 0 )
;       SPLITTER_0 = SplitterGadget( #PB_Any, 250, 0, 241, 393, TREE_0, PANEL_0 )
;       SPLITTER_1 = SplitterGadget( #PB_Any, 7, 7, 491, 386, SCROLLAREA_0, SPLITTER_0, #PB_Splitter_Vertical )
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_0( )

   Define event
   While IsWindow( WINDOW_0 )
      event = WaitWindowEvent( )
      
      Select EventWindow( )
         Case WINDOW_0
      EndSelect
      
      Select event
         Case #PB_Event_CloseWindow
            If EventWindow( ) = WINDOW_0
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
; CursorPosition = 20
; FirstLine = 3
; Folding = --
; EnableXP
; DPIAware