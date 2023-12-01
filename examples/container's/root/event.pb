
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(widget)
   
   Procedure CallBack( )
      Select WidgetEventType( )
         Case #__event_maximize
            Debug "event-maximize" 
            ProcedureReturn 1
            
         Case #__event_minimize
            Debug "event-minimize" 
            ProcedureReturn 1
            
         Case #__event_restore
            Debug "event-restore" 
            
        Case #__event_close
           Debug "event-close "+ GetWindowTitle( EventWindow( ) )
           ;\\
            CloseWindow( EventWindow( ) )
           
           ;\\
;             If #PB_MessageRequester_Yes = MessageRequester( "Сообщение", "Закрыть окно?", 
;                #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
;                ProcedureReturn 0
;             Else
;                ProcedureReturn 1
;             EndIf
            
         Case #__event_resize
            Debug "event-resize " + EventWidget( )\class +"( "+ EventWidget( )\x +" "+ EventWidget( )\y +" "+ EventWidget( )\width +" "+ EventWidget( )\height +" ) "; + EventWidget( )\root\canvas\gadget
            
         Case #__event_free
            Debug "event-free" 
            ; ProcedureReturn 1
      EndSelect
   EndProcedure
   
   ;\\
   Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                         #PB_Window_SizeGadget |
                                         #PB_Window_MinimizeGadget |
                                         #PB_Window_MaximizeGadget )
   SetClass(Root( ), "window_0_root" )
   
   ;\\
   Open(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                         #PB_Window_SizeGadget |
                                         #PB_Window_MinimizeGadget |
                                         #PB_Window_MaximizeGadget )
   
   SetClass(Root( ), "window_1_root" )
   ;\\
   Open(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu |
                                         #PB_Window_SizeGadget |
                                         #PB_Window_MinimizeGadget |
                                         #PB_Window_MaximizeGadget )
   SetClass(Root( ), "window_2_root" )
   
;    If MapSize( Root( ) ) > 0
;       Free( Root( ) )
;    Else
;       End
;    EndIf
   WaitEvent( #PB_All, @CallBack( ) )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 25
; FirstLine = 12
; Folding = -
; EnableXP