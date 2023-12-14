
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(widget)
   
   Procedure MessageEvents( )
      Select WidgetEventType( )
         Case #__event_LostFocus 
            If is_widget_( EventWidget( ) )
               Debug " " + WidgetEventType( ) +" "+  EventWidget( )\root\class
               ;                If EventWidget( )\root\canvas\repaint = 0
               ;                 ;  EventWidget( )\root\canvas\repaint = 1
               ;                EndIf
               ;                
               ;                PushMapPosition( EnumRoot( ) )
               ;                EventHandler( #PB_Event_Repaint, #PB_All, #PB_All, EventWidget( )\root\canvas\gadgetID )
               ;                PopMapPosition( EnumRoot( ) )
            EndIf
            
         Case #__event_Focus
            ;Debug " " + WidgetEventType( ) +" "+  EventWidget( )\root\class
            If EventWidget( )\root\canvas\repaint = 0
               EventWidget( )\root\canvas\repaint = 1
            EndIf
            If EventWidget( )\before\root
               EventHandler( #PB_Event_Repaint, #PB_All, #PB_All, EventWidget( )\before\root\canvas\gadgetID )
            EndIf
            EventHandler( #PB_Event_Repaint, #PB_All, #PB_All, EventWidget( )\root\canvas\gadgetID )
            
         Case #__event_Down, 
              #__event_Up, 
              #__event_MouseEnter, 
              #__event_MouseLeave
            
            If EventWidget( )\root\repaint = 1
               EventWidget( )\root\repaint = 0
               
               If EventWidget( )\root\canvas\repaint = 0
                  EventWidget( )\root\canvas\repaint = 1
               EndIf
               
               EventHandler( #PB_Event_Repaint, #PB_All, #PB_All, EventWidget( )\root\canvas\gadgetID )
               ;ReDraw( EventWidget( )\root )
            EndIf
            
         Case #__event_LeftClick
            Protected *ew._S_WIDGET = EventWidget( )
            Protected *message._S_WIDGET = *ew\window
            
            Select GetText( *ew )
               Case "No"     : SetData( *message, #__message_No )     ; no
               Case "Yes"    : SetData( *message, #__message_Yes )    ; yes
               Case "Cancel" : SetData( *message, #__message_Cancel ) ; cancel
            EndSelect
            
            Unbind( *message, @MessageEvents( ), #__event_LeftClick )
            
            ;\\
            PostQuit( *message )
            
      EndSelect
      
      ProcedureReturn #PB_Ignore
   EndProcedure
   
   Procedure CallBack( )
      Select WidgetEventType( )
         Case #__event_Create
            Debug "create - event " + EventWidget( )\class
            
         Case #__event_Focus
            Debug "focus - event " + EventWidget( )\class
            EventHandler( #PB_Event_Repaint, #PB_All, #PB_All, EventWidget( )\root\canvas\gadgetID )
            
         Case #__event_LostFocus
            Debug "lostfocus - event " + EventWidget( )\class
            EventHandler( #PB_Event_Repaint, #PB_All, #PB_All, EventWidget( )\root\canvas\gadgetID )
            
         Case #__event_Maximize
            Debug "maximize - event " + EventWidget( )\class
            
         Case #__event_Minimize
            Debug "minimize - event " + EventWidget( )\class
            
         Case #__event_Restore
            Debug "restore - event " + EventWidget( )\class 
            
         Case #__event_Close
            Debug "close - event " + EventWidget( )\class 
            
         Case #__event_Resize
            Debug "resize - event " + EventWidget( )\class +"( "+ EventWidget( )\x +" "+ EventWidget( )\y +" "+ EventWidget( )\width +" "+ EventWidget( )\height +" ) "; + EventWidget( )\root\canvas\gadget
            
         Case #__event_Free
            Debug "free - event " + EventWidget( )\class 
            
         Case #__event_Down, 
              #__event_Up, 
              #__event_MouseEnter, 
              #__event_MouseLeave
            
            If EventWidget( )\root\repaint = 1
               EventWidget( )\root\repaint = 0
               
               If EventWidget( )\root\canvas\repaint = 0
                  EventWidget( )\root\canvas\repaint = 1
               EndIf
               
               EventHandler( #PB_Event_Repaint, #PB_All, #PB_All, EventWidget( )\root\canvas\gadgetID )
               ;ReDraw( EventWidget( )\root )
            EndIf
            
            
      EndSelect
      
      ; ProcedureReturn 1
   EndProcedure
   
   ;\\
   Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                       #PB_Window_SizeGadget |
                                       #PB_Window_MinimizeGadget |
                                       #PB_Window_MaximizeGadget )
   
   SetClass(Root( ), "window_0_root" )
   Button(10,10,200,50,"window_0_root_butt_1")
   SetClass(widget( ), "window_0_root_butt_1" )
   Button(10,65,200,50,"window_0_root_butt_2")
   SetClass(widget( ), "window_0_root_butt_2" )
   
   ;\\
   Open(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(Root( ), "window_1_root" )
   Button(10,10,200,50,"window_1_root_butt_1")
   SetClass(widget( ), "window_1_root_butt_1" )
   Button(10,65,200,50,"window_1_root_butt_2")
   SetClass(widget( ), "window_1_root_butt_2" )
   
   ;\\
   Open(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(Root( ), "window_2_root" )
   Button(10,10,200,50,"window_2_root_butt_1")
   SetClass(widget( ), "window_2_root_butt_1" )
   Button(10,65,200,50,"window_2_root_butt_2")
   SetClass(widget( ), "window_2_root_butt_2" )
   
   Bind( #PB_All, @CallBack( ) )
   
   
   WaitQuit( )
   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 163
; FirstLine = 127
; Folding = ---
; EnableXP