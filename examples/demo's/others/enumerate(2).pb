IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   ;\\
   Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                       #PB_Window_SizeGadget |
                                       #PB_Window_MinimizeGadget |
                                       #PB_Window_MaximizeGadget )
   
   SetWidgetClass(root( ), "window_0_root" )
   ButtonWidget(10,10,200,50,"window_0_root_butt_1")
   SetWidgetClass(widget( ), "window_0_root_butt_1" )
   ButtonWidget(10,65,200,50,"window_0_root_butt_2")
   SetWidgetClass(widget( ), "window_0_root_butt_2" )
   
   ;\\
   Open(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetWidgetClass(root( ), "window_1_root" )
   ButtonWidget(10,10,200,50,"window_1_root_butt_1")
   SetWidgetClass(widget( ), "window_1_root_butt_1" )
   ButtonWidget(10,65,200,50,"window_1_root_butt_2")
   SetWidgetClass(widget( ), "window_1_root_butt_2" )
   
   ;\\
   Open(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetWidgetClass(root( ), "window_2_root" )
   ButtonWidget(10,10,200,50,"window_2_root_butt_1")
   SetWidgetClass(widget( ), "window_2_root_butt_1" )
   ButtonWidget(10,65,200,50,"window_2_root_butt_2")
   SetWidgetClass(widget( ), "window_2_root_butt_2" )
   
   
   
   ;\\
   Debug "--- enumerate all widgets ---"
   ForEach roots( )
      Debug "     window "+ roots( )\class
      If StartEnum( roots( ) )
         Debug "       gadget - "+ widget()\class
         StopEnum( )
      EndIf
   Next
   
   
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 52
; FirstLine = 30
; Folding = -
; EnableXP