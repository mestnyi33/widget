XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure active()
     ; Debug " "+ EventWidget( )\class +"_"+ #PB_Compiler_Procedure 
   EndProcedure
   
   Procedure deactive()
     ; Debug "   "+ EventWidget( )\class +"_"+ #PB_Compiler_Procedure 
   EndProcedure
   
   Define width=570, height=300
   
   ;\\
   If Open(0, 50, 50, width, height, "Root_0_Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      SetClass(root( ), "root_0" )
      
      ;\\
      Window(10, 10, 250, 200, "window_0_root_0", #PB_Window_SystemMenu ) : SetClass(widget( ), "window_0_root_0" )
       Window(10, 10, 200, 150, "window_1_root_0", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_1_root_0" )
       Window(10, 10, 150, 100, "window_2_root_0", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_2_root_0" )
      
      ;\\
      Openlist( Root( ) )
      Window(300, 10, 250, 200, "window_5_root_0", #PB_Window_SystemMenu ) : SetClass(widget( ), "window_5_root_0" )
       Window(10, 10, 200, 150, "window_6_root_0", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_6_root_0" )
       Window(10, 10, 150, 100, "window_7_root_0", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_7_root_0" )
      
   EndIf
   
;    ;\\
;    If Open(1, 50, 400, width, height, "Root_1_Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
;       SetClass(root( ), "root_1" )
;       
;       ;\\
;       Window(10, 10, 250, 200, "window_0_root_1", #PB_Window_SystemMenu ) : SetClass(widget( ), "window_0_root_1" )
;        Window(10, 10, 200, 150, "window_1_root_1", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_1_root_1" )
; ;       Window(10, 10, 150, 100, "window_2_root_1", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_2_root_1" )
;       
;       ;\\
;       Openlist( Root( ) )
;       Window(300, 10, 250, 200, "window_5_root_1", #PB_Window_SystemMenu ) : SetClass(widget( ), "window_5_root_1" )
;        Window(10, 10, 200, 150, "window_6_root_1", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_6_root_1" )
; ;       Window(10, 10, 150, 100, "window_7_root_1", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_7_root_1" )
;      
;    EndIf
   
   ;\\
   WaitClose( )
   
   End 
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 54
; FirstLine = 26
; Folding = -
; EnableXP
; DPIAware