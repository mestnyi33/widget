XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure active()
      Debug " "+ EventWidget( )\class +"_"+ #PB_Compiler_Procedure 
   EndProcedure
   
   Procedure deactive()
      Debug "   "+ EventWidget( )\class +"_"+ #PB_Compiler_Procedure 
   EndProcedure
   
   Define Width=570, Height=300
   
   ;\\
   If OpenRootWidget(0, 50, 50, Width, Height, "Root_0_Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      SetWidgetClass(root( ), "root_0" )
      
      ;\\
      WindowWidget(10, 10, 250, 200, "window_0_root_0", #PB_Window_SystemMenu ) : SetWidgetClass(widget( ), "window_0_root_0" )
      WindowWidget(10, 10, 200, 150, "window_1_root_0", #PB_Window_SystemMenu|#__flag_child, widget()) : SetWidgetClass(widget( ), "window_1_root_0" )
      WindowWidget(10, 10, 150, 100, "window_2_root_0", #PB_Window_SystemMenu|#__flag_child, widget()) : SetWidgetClass(widget( ), "window_2_root_0" )
      
      TreeWidget(5,5,70,90) : SetWidgetClass(widget( ), "tree_3_window_2_root_0" )
      AddItem(widget( ), -1, "item_0_tree_3_window_2_root_0" )
      AddItem(widget( ), -1, "item_1_tree_3_window_2_root_0" )
      AddItem(widget( ), -1, "item_2_tree_3_window_2_root_0" )
      
      TreeWidget(80,5,70,90) : SetWidgetClass(widget( ), "tree_4_window_2_root_0" )
      AddItem(widget( ), -1, "item_0_tree_4_window_2_root_0" )
      AddItem(widget( ), -1, "item_1_tree_4_window_2_root_0" )
      AddItem(widget( ), -1, "item_2_tree_4_window_2_root_0" )
      
      ;\\
      OpenWidgetList( root( ) )
      WindowWidget(300, 10, 250, 200, "window_5_root_0", #PB_Window_SystemMenu ) : SetWidgetClass(widget( ), "window_5_root_0" )
      WindowWidget(10, 10, 200, 150, "window_6_root_0", #PB_Window_SystemMenu|#__flag_child, widget()) : SetWidgetClass(widget( ), "window_6_root_0" )
      WindowWidget(10, 10, 150, 100, "window_7_root_0", #PB_Window_SystemMenu|#__flag_child, widget()) : SetWidgetClass(widget( ), "window_7_root_0" )
      
      TreeWidget(5,5,70,90) : SetWidgetClass(widget( ), "tree_8_window_7_root_0" )
      AddItem(widget( ), -1, "item_0_tree_8_window_7_root_0" )
      AddItem(widget( ), -1, "item_1_tree_8_window_7_root_0" )
      AddItem(widget( ), -1, "item_2_tree_8_window_7_root_0" )
      
      TreeWidget(80,5,70,90) : SetWidgetClass(widget( ), "tree_9_window_7_root_0" )
      AddItem(widget( ), -1, "item_0_tree_9_window_7_root_0" )
      AddItem(widget( ), -1, "item_1_tree_9_window_7_root_0" )
      AddItem(widget( ), -1, "item_2_tree_9_window_7_root_0" )
      
      ;\\
      OpenWidgetList( root( ) )
      ButtonWidget( 14, 250, 250,40, "button_10_root_0") : SetWidgetClass(widget( ), "button_10_root_0" )
      ButtonWidget( 304, 250, 250,40, "button_11_root_0") : SetWidgetClass(widget( ), "button_11_root_0" )
      
      
      SetActive( widget( ) )
      ;SetActive( WidgetID( 4 ) )
      
      ;\\
      BindWidgetEvent( #PB_All, @active(), #__event_Focus)
      BindWidgetEvent( #PB_All, @deactive(), #__event_LostFocus)
      
   EndIf
   
   ;\\
   If OpenRootWidget(1, 50, 400, Width, Height, "Root_1_Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      SetWidgetClass(root( ), "root_1" )
      
      ;\\
      WindowWidget(10, 10, 250, 200, "window_0_root_1", #PB_Window_SystemMenu ) : SetWidgetClass(widget( ), "window_0_root_1" )
      WindowWidget(10, 10, 200, 150, "window_1_root_1", #PB_Window_SystemMenu|#__flag_child, widget()) : SetWidgetClass(widget( ), "window_1_root_1" )
      WindowWidget(10, 10, 150, 100, "window_2_root_1", #PB_Window_SystemMenu|#__flag_child, widget()) : SetWidgetClass(widget( ), "window_2_root_1" )
      
      TreeWidget(5,5,70,90) : SetWidgetClass(widget( ), "tree_3_window_2_root_1" )
      AddItem(widget( ), -1, "item_0_tree_3_window_2_root_1" )
      AddItem(widget( ), -1, "item_1_tree_3_window_2_root_1" )
      AddItem(widget( ), -1, "item_2_tree_3_window_2_root_1" )
      
      TreeWidget(80,5,70,90) : SetWidgetClass(widget( ), "tree_4_window_2_root_1" )
      AddItem(widget( ), -1, "item_0_tree_4_window_2_root_1" )
      AddItem(widget( ), -1, "item_1_tree_4_window_2_root_1" )
      AddItem(widget( ), -1, "item_2_tree_4_window_2_root_1" )
      
      ;\\
      OpenWidgetList( root( ) )
      WindowWidget(300, 10, 250, 200, "window_5_root_1", #PB_Window_SystemMenu ) : SetWidgetClass(widget( ), "window_5_root_1" )
      WindowWidget(10, 10, 200, 150, "window_6_root_1", #PB_Window_SystemMenu|#__flag_child, widget()) : SetWidgetClass(widget( ), "window_6_root_1" )
      WindowWidget(10, 10, 150, 100, "window_7_root_1", #PB_Window_SystemMenu|#__flag_child, widget()) : SetWidgetClass(widget( ), "window_7_root_1" )
      
      TreeWidget(5,5,70,90) : SetWidgetClass(widget( ), "tree_8_window_7_root_1" )
      AddItem(widget( ), -1, "item_0_tree_8_window_7_root_1" )
      AddItem(widget( ), -1, "item_1_tree_8_window_7_root_1" )
      AddItem(widget( ), -1, "item_2_tree_8_window_7_root_1" )
      
      TreeWidget(80,5,70,90) : SetWidgetClass(widget( ), "tree_9_window_7_root_1" )
      AddItem(widget( ), -1, "item_0_tree_9_window_7_root_1" )
      AddItem(widget( ), -1, "item_1_tree_9_window_7_root_1" )
      AddItem(widget( ), -1, "item_2_tree_9_window_7_root_1" )
      
      ;\\
      OpenWidgetList( root( ) )
      ButtonWidget( 14, 250, 250,40, "button_10_root_1") : SetWidgetClass(widget( ), "button_10_root_1" )
      ButtonWidget( 304, 250, 250,40, "button_11_root_1") : SetWidgetClass(widget( ), "button_11_root_1" )
      
      
      SetActive( widget( ) )
      ;SetActive( WidgetID( 4 ) )
      
      ;\\
      BindWidgetEvent( #PB_All, @active(), #__event_Focus)
      BindWidgetEvent( #PB_All, @deactive(), #__event_LostFocus)
      
   EndIf
   
   ;\\
   WaitCloseRootWidget( )
   
   End 
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 108
; FirstLine = 89
; Folding = -
; EnableXP
; DPIAware