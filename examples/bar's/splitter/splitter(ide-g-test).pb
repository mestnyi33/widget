XIncludeFile "../../../widgets.pbi"


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
  ide_window = GetCanvasWindow(Open(0, 100,100,900,700, "ide", flag))
  
  ide_toolbar = TextGadget(#PB_Any, 0,0,0,0,"", #PB_Text_Border)
  ide_design_MDI = TextGadget(#PB_Any, 0,0,0,0,"", #PB_Text_Border)
  ide_design_DEBUG = TextGadget(#PB_Any, 0,0,0,0,"", #PB_Text_Border)
  ide_inspector_VIEW = TextGadget(#PB_Any, 0,0,0,0,"", #PB_Text_Border)
  ide_inspector_PANEL = TextGadget(#PB_Any, 0,0,0,0,"", #PB_Text_Border)
  ide_inspector_HELP  = TextGadget(#PB_Any, 0,0,0,0,"", #PB_Text_Border)
   
   Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4, Splitter_5
   
   Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "0")
   Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "1")
   Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "2")
   Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "3")
   Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "4")
   Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "5")
   ide_design_PANEL = ContainerGadget(#PB_Any, 0,0,0,0)
   Splitter_1 = SplitterGadget(#PB_Any, 0,0,0,0, Button_2, Button_3, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
   Splitter_2 = SplitterGadget(#PB_Any, 0,0,0,0, Splitter_1, Button_4)
   Splitter_3 = SplitterGadget(#PB_Any, 0,0,0,0, Button_5, Splitter_2)
   Splitter_4 = SplitterGadget(#PB_Any, 0,0,0,0, Button_1, Splitter_3, #PB_Splitter_Vertical)
   Splitter_5 = SplitterGadget(#PB_Any, 0,0,0,0, Button_0, Splitter_4, #PB_Splitter_Vertical)
   ;Splitter_5 = SplitterGadget(#PB_Any, 10, 10, 450, 350, Button_0, Splitter_4, #PB_Splitter_Vertical)
   
   SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
   SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
   
   ResizeGadget( Splitter_5, 10, 10, 620, 230 )
   SetGadgetState(Splitter_5, 50)
   SetGadgetState(Splitter_4, 50)
   SetGadgetState(Splitter_3, 40)
   SetGadgetState(Splitter_1, 30)
   
   Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "0")
   Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "1")
   Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "2")
   Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "3")
   Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "4")
   Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "5")
   Splitter_1 = SplitterGadget(#PB_Any, 0,0,0,0, Button_2, Button_3, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
   Splitter_2 = SplitterGadget(#PB_Any, 0,0,0,0, Splitter_1, Button_4)
   Splitter_3 = SplitterGadget(#PB_Any, 0,0,0,0, Button_5, Splitter_2)
   Splitter_4 = SplitterGadget(#PB_Any, 0,0,0,0, Button_1, Splitter_3, #PB_Splitter_Vertical)
   Splitter_5 = SplitterGadget(#PB_Any, 0,0,0,0, Button_0, Splitter_4, #PB_Splitter_Vertical)
    
   SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
   SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
   
   SetGadgetState(Splitter_5, 50)
   SetGadgetState(Splitter_4, 50)
   SetGadgetState(Splitter_3, 40)
   SetGadgetState(Splitter_1, 30)
   ResizeGadget( Splitter_5, 10, 250, 620, 230 )
   CloseGadgetList( )
   
   ;ide_design_PANEL = Splitter_5
  ;
   ;\\ main splitter 2 example 
   ide_inspector_panel_SPLITTER = SplitterGadget(#PB_Any,  0,0,0,0, ide_inspector_PANEL, ide_inspector_HELP, #PB_Splitter_SecondFixed ) ; SetClass(ide_inspector_panel_SPLITTER, "ide_inspector_panel_SPLITTER" )
   ide_inspector_SPLITTER = SplitterGadget(#PB_Any,  0,0,0,0, ide_inspector_VIEW, ide_inspector_panel_SPLITTER) ; SetClass(ide_inspector_SPLITTER, "ide_inspector_SPLITTER" )
   ide_design_SPLITTER = SplitterGadget(#PB_Any,  0,0,0,0, ide_design_PANEL, ide_design_DEBUG, #PB_Splitter_SecondFixed ) ; SetClass(ide_design_SPLITTER, "ide_design_SPLITTER" )
   ide_SPLITTER = SplitterGadget(#PB_Any,  0,0,0,0, ide_inspector_SPLITTER, ide_design_SPLITTER, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical | #PB_Splitter_Separator ) ; SetClass(ide_SPLITTER, "ide_SPLITTER" )
   ide_main_SPLITTER = SplitterGadget(#PB_Any,  0,0,900,700, ide_toolbar, ide_SPLITTER, #PB_Splitter_FirstFixed ) ; SetClass(ide_main_SPLITTER, "ide_main_SPLITTER" )
   
   ; set splitters default minimum size
   SetGadgetAttribute( ide_inspector_panel_SPLITTER, #PB_Splitter_FirstMinimumSize, 100 )
   SetGadgetAttribute( ide_inspector_panel_SPLITTER, #PB_Splitter_SecondMinimumSize, 30 )
   SetGadgetAttribute( ide_inspector_SPLITTER, #PB_Splitter_FirstMinimumSize, 100 )
   SetGadgetAttribute( ide_inspector_SPLITTER, #PB_Splitter_SecondMinimumSize, 200 )
   SetGadgetAttribute( ide_design_SPLITTER, #PB_Splitter_FirstMinimumSize, 300 )
   SetGadgetAttribute( ide_design_SPLITTER, #PB_Splitter_SecondMinimumSize, 100 )
   SetGadgetAttribute( ide_SPLITTER, #PB_Splitter_FirstMinimumSize, 120 )
   SetGadgetAttribute( ide_SPLITTER, #PB_Splitter_SecondMinimumSize, 540 )
   SetGadgetAttribute( ide_main_SPLITTER, #PB_Splitter_FirstMinimumSize, 20 )
   SetGadgetAttribute( ide_main_SPLITTER, #PB_Splitter_SecondMinimumSize, 500 )
   
   ; set splitters dafault positions
   SetGadgetState( ide_main_SPLITTER, 10)
   SetGadgetState( ide_SPLITTER, 250 )
   SetGadgetState( ide_design_SPLITTER, GadgetHeight( ide_design_SPLITTER )-180 )
   SetGadgetState( ide_inspector_SPLITTER, 150 )
   
   ;
   If ide_toolbar
      SetGadgetText(ide_toolbar, "size: ( "+Str(GadgetWidth(ide_toolbar))+" x "+Str(GadgetHeight(ide_toolbar))+" )" )
   EndIf
   If ide_design_MDI
      SetGadgetText(ide_design_MDI, "size: ( "+Str(GadgetWidth(ide_design_MDI))+" x "+Str(GadgetHeight(ide_design_MDI))+" )" )
   EndIf
   If ide_design_DEBUG
      SetGadgetText(ide_design_DEBUG, "size: ( "+Str(GadgetWidth(ide_design_DEBUG))+" x "+Str(GadgetHeight(ide_design_DEBUG))+" )" )
   EndIf
   If ide_inspector_VIEW
      SetGadgetText(ide_inspector_VIEW, "size: ( "+Str(GadgetWidth(ide_inspector_VIEW))+" x "+Str(GadgetHeight(ide_inspector_VIEW))+" )" )
   EndIf
   If ide_inspector_PANEL
      SetGadgetText(ide_inspector_PANEL, "size: ( "+Str(GadgetWidth(ide_inspector_PANEL))+" x "+Str(GadgetHeight(ide_inspector_PANEL))+" )" )
   EndIf
   If ide_inspector_HELP
      SetGadgetText(ide_inspector_HELP, "size: ( "+Str(GadgetWidth(ide_inspector_HELP))+" x "+Str(GadgetHeight(ide_inspector_HELP))+" )" )
   EndIf
   
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 82
; FirstLine = 63
; Folding = --
; EnableXP
; DPIAware