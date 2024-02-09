 XIncludeFile "../../../widgets.pbi"
 
 CompilerIf #PB_Compiler_IsMainFile
   
   EnableExplicit
   UseLIB(widget)
   
   Enumeration
      #window_0
      #window
   EndEnumeration
   
   
   ;-\\ ANCHORS
   Global view, size_value, pos_value, grid_value, back_color, frame_color, size_text, pos_text, grid_text
   
   OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   
   Define *root2._s_WIDGET = Open(#window, 10, 300, 300 - 20, 300 - 20): *root2\class = "root2": SetText(*root2, "root2")
   Global Splitter_4, Splitter_5
   
   Splitter_4 = Button(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  ; Splitter_4 = widget::Splitter(0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
   Splitter_5 = widget::Splitter(10, 80, 250, 120, 0, Splitter_4, #PB_Splitter_Vertical)
   
   
   WaitClose( )
   
CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 26
; Folding = -
; EnableXP