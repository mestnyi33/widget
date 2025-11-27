XIncludeFile "../../widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile ;= 100
  UseWidgets( )
  EnableExplicit
  
  Global ide_window, 
       ide_g_inspector_VIEW,
       ide_g_canvas

Global ide_root,
       ide_main_SPLITTER,
       ide_SPLITTER, 
       ide_toolbar_container, 
       ide_toolbar, 
       ide_popup_lenguage,
       ide_menu

Global ide_design_SPLITTER,
       ide_design_PANEL, 
       ide_design_MDI,
       ide_design_CODE, 
       ide_design_HIASM, 
       ide_design_DEBUG 

Global ide_inspector_SPLITTER,
       ide_inspector_VIEW, 
       ide_inspector_panel_SPLITTER, 
       ide_inspector_PANEL,
       ide_inspector_ELEMENTS,
       ide_inspector_PROPERTIES, 
       ide_inspector_EVENTS,
       ide_inspector_HELP

  
  Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget
  ide_window = GetCanvasWindow(Open(0, 100,100,800,600, "ide", flag))
 
   Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4, Splitter_5
   
   Splitter_1 = widget::Splitter(0, 0, 0, 0, Button_2, Button_3, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
   Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, Button_4)
   Splitter_3 = widget::Splitter(0, 0, 0, 0, Button_5, Splitter_2)
   Splitter_4 = widget::Splitter(0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
   Splitter_5 = widget::Splitter(0, 0, 0, 0, Button_0, Splitter_4, #PB_Splitter_Vertical)
   ;Splitter_5 = widget::Splitter(10, 10, 450, 350, Button_0, Splitter_4, #PB_Splitter_Vertical)
   
   Resize( Splitter_5, 10, 10, 350, 250 )
   widget::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
   widget::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
   
   SetState(Splitter_5, 50)
   SetState(Splitter_4, 50)
   SetState(Splitter_3, 40)
   SetState(Splitter_1, 50)
   
   Splitter_1 = widget::Splitter(0, 0, 0, 0, Button_2, Button_3, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
   Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, Button_4)
   Splitter_3 = widget::Splitter(0, 0, 0, 0, Button_5, Splitter_2)
   Splitter_4 = widget::Splitter(0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
   Splitter_5 = widget::Splitter(0, 0, 0, 0, Button_0, Splitter_4, #PB_Splitter_Vertical)
   ;Splitter_5 = widget::Splitter(10, 10, 450, 350, Button_0, Splitter_4, #PB_Splitter_Vertical)
   
   widget::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
   widget::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
   
   SetState(Splitter_5, 50)
   SetState(Splitter_4, 50)
   SetState(Splitter_3, 40)
   SetState(Splitter_1, 50)
   Resize( Splitter_5, 400, 10, 350, 250 )
   
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 54
; FirstLine = 34
; Folding = -
; EnableXP
; DPIAware