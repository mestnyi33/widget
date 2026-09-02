IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   Global *win_1, *but_1, *but_2, *but_3
   
   Procedure widget_events( )
      Debug ""+#PB_Compiler_Procedure +"( Procedure )"
      
      If *but_1 = EventWidget( )
         ProcedureReturn #PB_Ignore ; no send to (window & root) - event
      EndIf
   EndProcedure
   
   Procedure window_events( )
      Debug "  "+#PB_Compiler_Procedure +"( PROCEDURE )"
      
      If *but_2 = EventWidget( )
         ProcedureReturn #PB_Ignore ; no send to (root) - event
      EndIf
   EndProcedure
   
   Procedure root_events( )
      Debug "    "+#PB_Compiler_Procedure +"( PROCEDURE )"
   EndProcedure
   
   ;\\
   If OpenWindow(0, 0, 0, 500, 500, "Demo bind events", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      If Open(0, 30,30, 440, 440)
         *win_1 = Window(65,  70, 300, 290, "press mouse buttons to see", #PB_Window_SystemMenu)
         *but_1 = Button(30,  30, 240, 70, "post event for one procedure")
         *but_2 = Button(30, 110, 240, 70, "post event for to two procedure")
         *but_3 = Button(30, 190, 240, 70, "post event for all procedures")
         
         Bind(#PB_All, @root_events(), #__event_Down )
         Bind(*win_1, @window_events(), #__event_Down)
         ;
         Bind(*but_1, @widget_events(), #__event_Down)
         Bind(*but_2, @widget_events(), #__event_Down)
         Bind(*but_3, @widget_events(), #__event_Down)
      EndIf
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 30
; FirstLine = 24
; Folding = --
; EnableXP
; DPIAware