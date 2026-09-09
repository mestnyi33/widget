XIncludeFile "../widgets.pbi" 
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
      If WidgetEvent( ) = #__event_MouseWheel
         If MouseDirection( ) > 0
            event$ = "MouseWheelVertical"
         Else
            event$ = "MouseWheelHorizontal"
         EndIf
      Else
         event$ = EventString(WidgetEvent( ))
      EndIf
      
      Debug " ["+GetClass(EventWidget( )) +"] "+ event$ +" "+ WidgetEventData( )
      ProcedureReturn #PB_Ignore
   EndProcedure
   
   Define Flag.q = #PB_Canvas_DrawFocus
   
   Procedure TestRoot( gadget, X,Y,Width,Height, Flag )
      Protected *g
      *g = Open(0, X,Y,Width,Height,"", Flag, 0, gadget) 
      SetText(*g, Str(gadget))
      SetClass(*g, Str(gadget))
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
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 1
; Folding = --
; EnableXP
; DPIAware