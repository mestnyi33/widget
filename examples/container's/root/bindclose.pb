
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   ;\\
   Procedure gadget_CallBack( )
      Select WidgetEvent( )
         Case #__event_close
            Debug "close - event " + EventWidget( )\class +" --- "+ #PB_Compiler_Procedure
           ; ProcedureReturn #PB_Ignore
           ProcedureReturn 0
           
         Case #__event_Down
            Debug "down - event " + EventWidget( )\class +" --- "+ #PB_Compiler_Procedure 
            
            Send(EventWidget( ), #__event_close)
   ;             ;\\ to send not down
            ;                      ProcedureReturn 1
            ProcedureReturn #PB_Ignore
           
      EndSelect
   EndProcedure
   
   ;\\
   Procedure window_CallBack( )
      Select WidgetEvent( )
         Case #__event_close
            Debug "close - event " + EventWidget( )\class +" --- "+ #PB_Compiler_Procedure
            ;ProcedureReturn 3
           
         Case #__event_Down
            Debug "down - event " + EventWidget( )\class +" --- "+ #PB_Compiler_Procedure 
            
            ;             ;\\ to send not down
            ;                      ProcedureReturn 1
            ProcedureReturn #PB_Ignore
           
      EndSelect
   EndProcedure
   
   ;\\
   Procedure root_CallBack( )
      Select WidgetEvent( )
         Case #__event_close
            Debug "close - event " + EventWidget( )\class +" --- "+ #PB_Compiler_Procedure
            ;ProcedureReturn 4
           
         Case #__event_Down
            Debug "down - event " + EventWidget( )\class +" --- "+ #PB_Compiler_Procedure 
            
            ;             ;\\ to send not down
           ProcedureReturn #PB_Ignore
            
      EndSelect
   EndProcedure
   
   Procedure buttonEvent( )
      If #PB_MessageRequester_Yes = MessageRequester( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
         Close( #PB_All )
      EndIf
   EndProcedure
   
   ;\\
   Open(0, 400, 200, 510, 200, "window_0", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "root_0" )
   ButtonGadget(1, 10,10,200,50, "Button_2_close")
   BindGadgetEvent(1, @buttonEvent( ))
   
   
   Define window = Window(220,10,300-20-8,200-20-32,"window_0", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   SetClass(widget( ), "window_0" )
   
   Define gadget = Button(10,10,200,50,"Button_0_close")
   SetClass(widget( ), "Button_0_close" )
   
   
   Bind(#PB_All, @root_CallBack())
   Bind(window, @window_CallBack())
   Bind(gadget, @gadget_CallBack())
   
   ;post(gadget, #__event_close)
   
   ;\\
   WaitClose( )
   
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 14
; FirstLine = 10
; Folding = --
; EnableXP