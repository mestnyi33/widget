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
  ide_window = GetCanvasWindow(Open(0, 100,100,800,600, "ide", flag))
  
   ide_toolbar = Text(0,0,0,0,"", #__flag_BorderFlat)
;   ide_design_MDI = Text(0,0,0,0,"", #__flag_BorderFlat)
;   ide_design_DEBUG = Text(0,0,0,0,"", #__flag_BorderFlat)
;   ide_inspector_VIEW = Text(0,0,0,0,"", #__flag_BorderFlat)
;   ide_inspector_PANEL = Text(0,0,0,0,"", #__flag_BorderFlat)
;   ide_inspector_HELP  = Text(0,0,0,0,"", #__flag_BorderFlat)
  
  ;
   ;\\ main splitter 2 example 
   Define Transparent ;= #__flag_Transparent
   ide_inspector_panel_SPLITTER = Splitter( 0,0,0,0, ide_inspector_PANEL, ide_inspector_HELP, #PB_Splitter_SecondFixed|Transparent ) : SetClass(ide_inspector_panel_SPLITTER, "ide_inspector_panel_SPLITTER" )
   ide_inspector_SPLITTER = Splitter( 0,0,0,0, ide_inspector_VIEW, ide_inspector_panel_SPLITTER, Transparent) : SetClass(ide_inspector_SPLITTER, "ide_inspector_SPLITTER" )
   ide_design_SPLITTER = Splitter( 0,0,0,0, ide_design_PANEL, ide_design_DEBUG, #PB_Splitter_SecondFixed|Transparent ) : SetClass(ide_design_SPLITTER, "ide_design_SPLITTER" )
   ide_SPLITTER = Splitter( 0,0,0,0, ide_inspector_SPLITTER, ide_design_SPLITTER, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical | #PB_Splitter_Separator|Transparent ) : SetClass(ide_SPLITTER, "ide_SPLITTER" )
   ide_main_SPLITTER = Splitter( 0,0,0,0, ide_toolbar_container, ide_SPLITTER,#__flag_autosize | #PB_Splitter_FirstFixed|Transparent ) : SetClass(ide_main_SPLITTER, "ide_main_SPLITTER" )
   
   ; set splitters default minimum size
   SetAttribute( ide_inspector_panel_SPLITTER, #PB_Splitter_FirstMinimumSize, 100 )
   SetAttribute( ide_inspector_panel_SPLITTER, #PB_Splitter_SecondMinimumSize, 30 )
   SetAttribute( ide_inspector_SPLITTER, #PB_Splitter_FirstMinimumSize, 100 )
   SetAttribute( ide_inspector_SPLITTER, #PB_Splitter_SecondMinimumSize, 200 )
   SetAttribute( ide_design_SPLITTER, #PB_Splitter_FirstMinimumSize, 300 )
   SetAttribute( ide_design_SPLITTER, #PB_Splitter_SecondMinimumSize, 100 )
   SetAttribute( ide_SPLITTER, #PB_Splitter_FirstMinimumSize, 120 )
   SetAttribute( ide_SPLITTER, #PB_Splitter_SecondMinimumSize, 540 )
   SetAttribute( ide_main_SPLITTER, #PB_Splitter_FirstMinimumSize, 20 )
   SetAttribute( ide_main_SPLITTER, #PB_Splitter_SecondMinimumSize, 500 )
;    
;    ; set splitters dafault positions
;    SetState( ide_main_SPLITTER, Height( ide_toolbar ))
;    SetState( ide_SPLITTER, 250 )
;    SetState( ide_design_SPLITTER, Height( ide_design_SPLITTER )-180 )
;    SetState( ide_inspector_SPLITTER, 150 )
   
;   
;   SetText(ide_toolbar, "size: ("+Str(Width(ide_toolbar))+"x"+Str(Height(ide_toolbar))+") - " + Str(Index( GetParent( ide_toolbar ))) )
;   SetText(ide_design_MDI, "size: ("+Str(Width(ide_design_MDI))+"x"+Str(Height(ide_design_MDI))+") - " + Str(Index( GetParent( ide_design_MDI ))))
;   SetText(ide_design_DEBUG, "size: ("+Str(Width(ide_design_DEBUG))+"x"+Str(Height(ide_design_DEBUG))+") - " + Str(Index( GetParent( ide_design_DEBUG ))))
;   SetText(ide_inspector_VIEW, "size: ("+Str(Width(ide_inspector_VIEW))+"x"+Str(Height(ide_inspector_VIEW))+") - " + Str(Index( GetParent( ide_inspector_VIEW ))))
;   SetText(ide_inspector_PANEL, "size: ("+Str(Width(ide_inspector_PANEL))+"x"+Str(Height(ide_inspector_PANEL))+") - " + Str(Index( GetParent( ide_inspector_PANEL ))))
;   SetText(ide_inspector_HELP, "size: ("+Str(Width(ide_inspector_HELP))+"x"+Str(Height(ide_inspector_HELP))+") - " + Str(Index( GetParent( ide_inspector_HELP ))))
;   
  ;Bind(-1,-1)
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 59
; FirstLine = 37
; Folding = -
; EnableXP
; DPIAware