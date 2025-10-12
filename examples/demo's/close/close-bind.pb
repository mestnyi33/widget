
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure OpenMessage( title.s, Text.s, flags = 0, parentID = 0)
      ; ProcedureReturn Message(title, Text, flags, parentID )
      ProcedureReturn MessageRequester(title, Text, flags, parentID );
   EndProcedure
   
   ;\\
   Procedure gadget_CallBack( )
      Select WidgetEvent( )
         Case #__event_close
            Debug " close - event " + EventWidget( )\class +" --- "+ #PB_Compiler_Procedure
            
         Case #__event_Down
            Debug " down - event " + EventWidget( )\class +" --- "+ #PB_Compiler_Procedure 
            
            Post( GetWindow( EventWidget( ) ), #__event_Close )
            
            ;\\ to not down send after window_CallBack( )
            ProcedureReturn #PB_Ignore
            
      EndSelect
   EndProcedure
   
   ;\\
   Procedure window_CallBack( )
      Select WidgetEvent( )
         Case #__event_close
            Debug "close - event " + EventWidget( )\class +" --- "+ #PB_Compiler_Procedure
            
         Case #__event_Down
            If is_window_( EventWidget( ))
               ;\\ to not down send after root_CallBack( )
               ProcedureReturn #PB_Ignore
            Else
               Debug "down - event " + EventWidget( )\class +" --- "+ #PB_Compiler_Procedure 
            EndIf
            
      EndSelect
   EndProcedure
   
   ;\\
   Procedure root_CallBack( )
      Select WidgetEvent( )
         Case #__event_close
            Debug "close - event " + EventWidget( )\class +" --- "+ #PB_Compiler_Procedure
            ProcedureReturn #True
            
         Case #__event_Down
            Debug "down - event " + EventWidget( )\class +" --- "+ #PB_Compiler_Procedure 
            
      EndSelect
   EndProcedure
   
   Procedure buttonEvent( )
      If #PB_MessageRequester_Yes = OpenMessage( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
         
         CloseRootWindow( #PB_All )
         
      EndIf
   EndProcedure
   
   ;\\
   Open(0, 400, 200, 510, 200, "window_0", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "root_0" )
   SetBackColor( root( ), $FFB3FDFF )
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
   
   
   ;\\
   WaitClose( )
   
   
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 64
; FirstLine = 42
; Folding = --
; EnableXP