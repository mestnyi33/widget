
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(widget)
   
   Procedure CallBack( )
      Select WidgetEventType( )
         Case #__event_close
            Debug "close - event " + EventWidget( )\class +" --- "+ GetWindowTitle( EventWindow( ) )
            ;\\
            ; CloseWindow( EventWindow( ) )
            
; ;             ;\\ demo main window
; ;             If EventWindow( ) = 0 
;                If #PB_MessageRequester_Yes = MessageRequester( "Сообщение", "Закрыть окно?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
;                   CloseWindow( EventWindow( ) )
;                   ProcedureReturn 0
;                Else
;                   ProcedureReturn 1
;                EndIf
; ;             Else
; ;                ; demo close window
; ;                If EventWindow( ) = 1 
; ;                   CloseWindow( EventWindow( ) )
; ;                   ProcedureReturn 1
; ;                EndIf   
; ;                
; ;                ; demo no closed window
; ;                If EventWindow( ) = 2 
; ;                   ProcedureReturn 1
; ;                EndIf   
; ;             EndIf
            
         Case #__event_free
            Debug "free - event " + EventWidget( )\class 
            
;             ;\\ to send not free
;             If IsWindow( EventWindow( ) )
;                ProcedureReturn 1
;             EndIf
            
      EndSelect
   EndProcedure
   
   ;\\
   Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                         #PB_Window_SizeGadget |
                                         #PB_Window_MinimizeGadget |
                                         #PB_Window_MaximizeGadget )
   SetClass(Root( ), "window_0_root" )
   Button(10,10,200,50,"window_0_root_butt_1")
   SetClass(widget( ), "window_0_root_butt_1" )
   
   ;\\
   Open(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                         #PB_Window_SizeGadget |
                                         #PB_Window_MinimizeGadget |
                                         #PB_Window_MaximizeGadget )
   
   SetClass(Root( ), "window_1_root" )
   Button(10,10,200,50,"window_1_root_butt_1")
   SetClass(widget( ), "window_1_root_butt_1" )
   
   ;\\
   Open(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu |
                                         #PB_Window_SizeGadget |
                                         #PB_Window_MinimizeGadget |
                                         #PB_Window_MaximizeGadget )
   SetClass(Root( ), "window_2_root" )
   Button(10,10,200,50,"window_2_root_butt_1")
   SetClass(widget( ), "window_2_root_butt_1" )
   
   WaitEvent( #PB_All, @CallBack( ) )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 35
; FirstLine = 7
; Folding = -
; EnableXP