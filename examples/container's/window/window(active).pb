XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   Uselib(widget)
   
   Procedure active()
      Debug " "+ EventWidget( )\text\string +"_"+ #PB_Compiler_Procedure 
   EndProcedure
   
   Procedure deactive()
      Debug "   "+ EventWidget( )\text\string +"_"+ #PB_Compiler_Procedure 
   EndProcedure
   
   Define width=570, height=200
   
   ;\\
   If Open(0, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      ; If Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      
      ;\\
      Window(10, 10, 250, 150, "Window_0", #PB_Window_SystemMenu )
      Window(10, 10, 200, 100, "Window_1", #PB_Window_SystemMenu|#__flag_child, widget())
      Window(10, 10, 150, 50, "Window_2", #PB_Window_SystemMenu|#__flag_child, widget())
      Button(10,5,100,20,"window_0_butt_1")
      Button(10,30,100,20,"window_0_butt_1")
      
      ;\\
      Openlist( Root( ) )
      Window(300, 10, 250, 150, "Window_10", #PB_Window_SystemMenu )
      Window(10, 10, 200, 100, "Window_11", #PB_Window_SystemMenu|#__flag_child, widget())
      Window(10, 10, 150, 50, "Window_12", #PB_Window_SystemMenu|#__flag_child, widget())
      Button(10,5,100,20,"window_0_butt_1")
      Button(10,30,100,20,"window_0_butt_1")
      
      ;\\
      Bind( #PB_All, @active(), #__event_Focus)
      Bind( #PB_All, @deactive(), #__event_LostFocus)
      
      ;\\
      WaitClose()
   EndIf
   
   End 
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 24
; FirstLine = 4
; Folding = -
; EnableXP