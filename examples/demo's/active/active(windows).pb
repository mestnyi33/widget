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
   
   Define width=570, height=300
   
   ;\\
   If Open(0, 50, 50, width, height, "Root_0_Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      SetClass(root( ), "root_0" )
      
      ;\\
      Window(10, 10, 250, 200, "window_0_root_0", #PB_Window_SystemMenu ) : SetClass(widget( ), "window_0_root_0" )
      Window(10, 10, 200, 150, "window_1_root_0", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_1_root_0" )
      Window(10, 10, 150, 100, "window_2_root_0", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_2_root_0" )
      
      Tree(5,5,70,90) : SetClass(widget( ), "tree_3_window_2_root_0" )
      AddItem(widget( ), -1, "item_0_tree_3_window_2_root_0" )
      AddItem(widget( ), -1, "item_1_tree_3_window_2_root_0" )
      AddItem(widget( ), -1, "item_2_tree_3_window_2_root_0" )
      
      Tree(80,5,70,90) : SetClass(widget( ), "tree_4_window_2_root_0" )
      AddItem(widget( ), -1, "item_0_tree_4_window_2_root_0" )
      AddItem(widget( ), -1, "item_1_tree_4_window_2_root_0" )
      AddItem(widget( ), -1, "item_2_tree_4_window_2_root_0" )
      
      ;\\
      Openlist( Root( ) )
      Window(300, 10, 250, 200, "window_5_root_0", #PB_Window_SystemMenu ) : SetClass(widget( ), "window_5_root_0" )
      Window(10, 10, 200, 150, "window_6_root_0", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_6_root_0" )
      Window(10, 10, 150, 100, "window_7_root_0", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_7_root_0" )
      
      Tree(5,5,70,90) : SetClass(widget( ), "tree_8_window_7_root_0" )
      AddItem(widget( ), -1, "item_0_tree_8_window_7_root_0" )
      AddItem(widget( ), -1, "item_1_tree_8_window_7_root_0" )
      AddItem(widget( ), -1, "item_2_tree_8_window_7_root_0" )
      
      Tree(80,5,70,90) : SetClass(widget( ), "tree_9_window_7_root_0" )
      AddItem(widget( ), -1, "item_0_tree_9_window_7_root_0" )
      AddItem(widget( ), -1, "item_1_tree_9_window_7_root_0" )
      AddItem(widget( ), -1, "item_2_tree_9_window_7_root_0" )
      
      ;\\
      Openlist( Root( ) )
      Button( 14, 250, 250,40, "button_10_root_0") : SetClass(widget( ), "button_10_root_0" )
      Button( 304, 250, 250,40, "button_11_root_0") : SetClass(widget( ), "button_11_root_0" )
      
      
      SetActive( widget( ) )
      ;SetActive( WidgetID( 4 ) )
      
      ;\\
      Bind( #PB_All, @active(), #__event_Focus)
      Bind( #PB_All, @deactive(), #__event_LostFocus)
      
   EndIf
   
   ;\\
   If Open(1, 50, 400, width, height, "Root_1_Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      SetClass(root( ), "root_1" )
      
      ;\\
      Window(10, 10, 250, 200, "window_0_root_1", #PB_Window_SystemMenu ) : SetClass(widget( ), "window_0_root_1" )
      Window(10, 10, 200, 150, "window_1_root_1", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_1_root_1" )
      Window(10, 10, 150, 100, "window_2_root_1", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_2_root_1" )
      
      Tree(5,5,70,90) : SetClass(widget( ), "tree_3_window_2_root_1" )
      AddItem(widget( ), -1, "item_0_tree_3_window_2_root_1" )
      AddItem(widget( ), -1, "item_1_tree_3_window_2_root_1" )
      AddItem(widget( ), -1, "item_2_tree_3_window_2_root_1" )
      
      Tree(80,5,70,90) : SetClass(widget( ), "tree_4_window_2_root_1" )
      AddItem(widget( ), -1, "item_0_tree_4_window_2_root_1" )
      AddItem(widget( ), -1, "item_1_tree_4_window_2_root_1" )
      AddItem(widget( ), -1, "item_2_tree_4_window_2_root_1" )
      
      ;\\
      Openlist( Root( ) )
      Window(300, 10, 250, 200, "window_5_root_1", #PB_Window_SystemMenu ) : SetClass(widget( ), "window_5_root_1" )
      Window(10, 10, 200, 150, "window_6_root_1", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_6_root_1" )
      Window(10, 10, 150, 100, "window_7_root_1", #PB_Window_SystemMenu|#__flag_child, widget()) : SetClass(widget( ), "window_7_root_1" )
      
      Tree(5,5,70,90) : SetClass(widget( ), "tree_8_window_7_root_1" )
      AddItem(widget( ), -1, "item_0_tree_8_window_7_root_1" )
      AddItem(widget( ), -1, "item_1_tree_8_window_7_root_1" )
      AddItem(widget( ), -1, "item_2_tree_8_window_7_root_1" )
      
      Tree(80,5,70,90) : SetClass(widget( ), "tree_9_window_7_root_1" )
      AddItem(widget( ), -1, "item_0_tree_9_window_7_root_1" )
      AddItem(widget( ), -1, "item_1_tree_9_window_7_root_1" )
      AddItem(widget( ), -1, "item_2_tree_9_window_7_root_1" )
      
      ;\\
      Openlist( Root( ) )
      Button( 14, 250, 250,40, "button_10_root_1") : SetClass(widget( ), "button_10_root_1" )
      Button( 304, 250, 250,40, "button_11_root_1") : SetClass(widget( ), "button_11_root_1" )
      
      
      SetActive( widget( ) )
      ;SetActive( WidgetID( 4 ) )
      
      ;\\
      Bind( #PB_All, @active(), #__event_Focus)
      Bind( #PB_All, @deactive(), #__event_LostFocus)
      
   EndIf
   
   ;\\
   WaitClose( )
   
   End 
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 108
; FirstLine = 72
; Folding = -
; EnableXP
; DPIAware