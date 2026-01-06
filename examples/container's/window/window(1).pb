XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure Events_widgets( )
      Debug "event "+ EventString(WidgetEvent( )) +" "+ EventWidget( )\index
      ;
      ProcedureReturn #PB_Ignore
   EndProcedure
   
   ;
   Window(100, 100, 200, 200, "window_0", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
   Button(0,0,80,20,"button")
   Button(200-80,200-20,80,20,"button")
   
   Window(#PB_Ignore, #PB_Ignore, 200, 200, "window_1", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
   Button(0,0,80,20,"button")
   Button(200-80,200-20,80,20,"button")
   
   Window(#PB_Ignore, #PB_Ignore, 200, 200, "window_1", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
   Button(0,0,80,20,"button")
   Button(200-80,200-20,80,20,"button")
   
   WaitClose( @Events_widgets( ) )
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile = 99
   EnableExplicit
   UseWidgets( )
   
   Procedure Events_widgets( )
      Debug "event "+ EventString(WidgetEvent( )) +" "+ EventWidget( )\index
      ;
      ProcedureReturn #PB_Ignore
   EndProcedure
   
   ;
   Window(100, 100, 200, 200, "window_0", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
   Button(0,0,80,20,"button")
   Button(200-80,200-20,80,20,"button")
   
   WaitClose( @Events_widgets( ) )
CompilerEndIf

; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 21
; FirstLine = 1
; Folding = -
; EnableXP
; DPIAware