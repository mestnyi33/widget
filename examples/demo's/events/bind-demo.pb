IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure events_widget( )
      ;ClearDebugOutput( )
      Debug ""+#PB_Compiler_Procedure +"( PROCEDURE )"
      
      If Index( EventWidget( ) ) = 1
         ProcedureReturn #PB_Ignore ; no send to (window & root) - event
      EndIf
   EndProcedure
   
   Procedure events_window( )
      Debug "  "+#PB_Compiler_Procedure +"( PROCEDURE )"
      
      If Index( EventWidget( ) ) = 2
         ProcedureReturn #PB_Ignore ; no send to (root) - event
      EndIf
   EndProcedure
   
   Procedure events_root( )
      Debug "    "+#PB_Compiler_Procedure +"( PROCEDURE )"
   EndProcedure
   
   ;\\
   If OpenWindow(0, 0, 0, 500, 500, "Demo bind events", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      If Open(0, 10,10, 480, 480)
         Bind(#PB_All, @events_root(), #__event_Down )
         Bind(Window(80, 100, 300, 280, "Window_2", #PB_Window_SystemMenu), @events_window(), #__event_Down)
         
         Bind(Button(10,  10, 280, 80, "post event for one procedure"), @events_widget(), #__event_Down)
         Bind(Button(10, 100, 280, 80, "post event for to two procedure"), @events_widget(), #__event_Down)
         Bind(Button(10, 190, 280, 80, "post event for all procedures"), @events_widget(), #__event_Down)
      EndIf
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 13
; FirstLine = 11
; Folding = --
; EnableXP
; DPIAware