XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   Uselib(widget)
   
   Procedure active()
      Debug " "+ EventWidget( )\class +"_"+ #PB_Compiler_Procedure 
   EndProcedure
   
   Procedure deactive()
      Debug "   "+ EventWidget( )\class +"_"+ #PB_Compiler_Procedure 
   EndProcedure
   
   Define width=570, height=250
   
   ;\\
   If Open(0, 100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      ; If Window(100, 200, width, height, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      
      ;\\
      Window(10, 10, 250, 200, "Window_0", #PB_Window_SystemMenu ) : SetClass(widget( ), "window_0" )
      Window(10, 10, 200, 150, "Window_1", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_1" )
      Window(10, 10, 150, 100, "Window_2", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_2" )
      
      Tree(5,5,70,90) : SetClass(widget( ), "window_2_tree_1" )
      AddItem(widget( ), -1, "item_0" )
      AddItem(widget( ), -1, "item_1" )
      AddItem(widget( ), -1, "item_2" )
      
      Tree(80,5,70,90) : SetClass(widget( ), "window_2_tree_2" )
      AddItem(widget( ), -1, "item_3" )
      AddItem(widget( ), -1, "item_4" )
      AddItem(widget( ), -1, "item_5" )
      
      ;\\
      Openlist( Root( ) )
      Window(300, 10, 250, 200, "Window_3", #PB_Window_SystemMenu ) : SetClass(widget( ), "window_3" )
      Window(10, 10, 200, 150, "Window_4", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_4" )
      Window(10, 10, 150, 100, "Window_5", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_5" )
      
      Tree(5,5,70,90) : SetClass(widget( ), "window_5_tree_1" )
      AddItem(widget( ), -1, "item_6" )
      AddItem(widget( ), -1, "item_7" )
      AddItem(widget( ), -1, "item_8" )
      
      Tree(80,5,70,90) : SetClass(widget( ), "window_5_tree_2" )
      AddItem(widget( ), -1, "item_9" )
      AddItem(widget( ), -1, "item_10" )
      AddItem(widget( ), -1, "item_11" )
      
      SetActive( GetWidget( 4 ) )
      
      ;\\
      Bind( #PB_All, @active(), #__event_Focus)
      Bind( #PB_All, @deactive(), #__event_LostFocus)
      
      ;\\
      WaitClose()
   EndIf
   
   End 
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 51
; FirstLine = 26
; Folding = -
; EnableXP