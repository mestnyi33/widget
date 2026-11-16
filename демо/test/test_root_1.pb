XIncludeFile "../../widgets.pbi" 
CompilerIf #PB_Compiler_IsMainFile ;= 99
   EnableExplicit
   UseWidgets( )
   
   ; test_focus_set = 2
   
   Procedure all_events( )
      Protected event$
      If WidgetEvent( ) = #__event_MouseMove
         ProcedureReturn 0
      EndIf
      ;
      event$ = EventString(WidgetEvent( ))
      
      Debug " ["+GetClass(EventWidget( )) +"] "+ event$ +" "+ WidgetEventData( )
      ProcedureReturn #PB_Ignore
   EndProcedure
   
   Define Flag.q = #PB_Canvas_DrawFocus
   
   Procedure TestRoot( Gadget, X,Y,Width,Height, Flag )
      Protected *g
      *g = Open(0, X,Y,Width,Height,"", Flag, 0, Gadget) 
      SetText(*g, Str(Gadget))
      SetClass(*g, Str(Gadget))
   EndProcedure
   
   If OpenWindow(0, 0, 0, 370, 370, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      TestRoot(10, 10, 10, 150, 150,Flag) 
      
      TestRoot(20, 210, 10, 150, 150,Flag) 
      
      TestRoot(30, 10, 210, 150, 150,Flag) 
      
      TestRoot(40, 210, 210, 150, 150,Flag) 
      
      
      Bind( #PB_All, @all_events( ))
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 14
; FirstLine = 7
; Folding = -
; EnableXP
; DPIAware