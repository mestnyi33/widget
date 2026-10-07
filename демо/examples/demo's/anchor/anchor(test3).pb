 XIncludeFile "../../../../widgets.pbi"
; fixed 778 commit
;-
CompilerIf #PB_Compiler_IsMainFile ;= 100
  UseWidgets( )
  EnableExplicit
  #__flag_TextBorder = #PB_Text_Border
  
  Global window_ide, canvas_ide, fixed=1, state=1, minsize=1
  Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
  Global s_desi, s_tbar, s_view, s_help, s_list,s_insp
  
  Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget  
  Open(0, 100,100,800,600, "ide", flag)
  window_ide = GetCanvasWindow(Root())
  canvas_ide = GetCanvasGadget(Root())
  a_init(Root())
  
  s_tbar = Text(0,0,0,0,"", #__flag_TextBorder)
  s_desi = Text(0,0,0,0,"", #__flag_TextBorder)
  s_view = Text(0,0,0,0,"", #__flag_TextBorder)
  s_list = Text(0,0,0,0,"", #__flag_TextBorder)
  s_insp = Text(0,0,0,0,"", #__flag_TextBorder)
  s_help  = Text(0,0,0,0,"", #__flag_TextBorder)
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4, Splitter_5
  Button_0 = Button(0, 0, 0, 0, "Button 0") ; as they will be sized automatically
  ;Button_1 = Button(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  Button_1 = Container(0, 0, 0, 0) ; as they will be sized automatically
  Button(10, 10, 50, 50, "Button 1")
  CloseList( )
  
  Button_2 = Button(0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
  Button_3 = Button(0, 0, 0, 0, "Button 3") ; as they will be sized automatically
  Button_4 = Button(0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
  Button_5 = Button(0, 0, 0, 0, "Button 5") ; as they will be sized automatically
  
  Splitter_0 = Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
  Splitter_1 = Splitter(0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
  SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
  SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
  Splitter_2 = Splitter(0, 0, 0, 0, Splitter_1, Button_5)
  Splitter_3 = Splitter(0, 0, 0, 0, Button_2, Splitter_2)
  Splitter_4 = Splitter(0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
  Splitter_5 = Splitter(0, 0, 0, 0, s_desi, Splitter_4, #PB_Splitter_Vertical)
  
  Splitter_design = Splitter(0,0,0,0, s_tbar,Splitter_5, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  Splitter_inspector = Splitter(0,0,0,0, s_list,s_insp, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  splitter_debug = Splitter(0,0,0,0, Splitter_design,s_view, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  splitter_help = Splitter(0,0,0,0, Splitter_inspector,s_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  Splitter_ide = Splitter(50,50,700,500, splitter_debug,splitter_help, #PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
  
  If minsize
;         ; set splitter default minimum size
;     SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 20)
;     SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 10)
;     SetAttribute(splitter_help, #PB_Splitter_FirstMinimumSize, 20)
;     SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 10)
;     SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 20)
;     SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 10)
;     SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 20)
;     SetAttribute(Splitter_inspector, #PB_Splitter_SecondMinimumSize, 10)
;     SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
;     SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 10)
    
;   ; set splitter default minimum size
    SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
    SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
    SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
   ; SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 300)
    SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
    SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
    SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
    SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 200)
    ;SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
  EndIf

  If state
    ; set splitters dafault positions
    ;SetState(Splitter_ide, -130)
    SetState(Splitter_ide, Width(Splitter_ide)-220)
    SetState(splitter_help, Height(splitter_help)-80)
    SetState(splitter_debug, Height(splitter_debug)-150)
    SetState(Splitter_inspector, 200)
    SetState(Splitter_design, 30)
    SetState(Splitter_5, 120)
    
    SetState(Splitter_1, 20)
  EndIf
  
  ;Resize(Splitter_ide, 0,0,820,620)
  
  SetText(s_tbar, "size: ("+Str(Width(s_tbar))+"x"+Str(Height(s_tbar))+") - " );+ Str(Index( GetParent( s_tbar ))) )
  SetText(s_desi, "size: ("+Str(Width(s_desi))+"x"+Str(Height(s_desi))+") - " );+ Str(Index( GetParent( s_desi ))))
  SetText(s_view, "size: ("+Str(Width(s_view))+"x"+Str(Height(s_view))+") - " );+ Str(Index( GetParent( s_view ))))
  SetText(s_list, "size: ("+Str(Width(s_list))+"x"+Str(Height(s_list))+") - " );+ Str(Index( GetParent( s_list ))))
  SetText(s_insp, "size: ("+Str(Width(s_insp))+"x"+Str(Height(s_insp))+") - " );+ Str(Index( GetParent( s_insp ))))
  SetText(s_help, "size: ("+Str(Width(s_help))+"x"+Str(Height(s_help))+") - " );+ Str(Index( GetParent( s_help ))))
  
  ;WaitClose( )
  Define event
  Repeat 
    event = WaitWindowEvent( )
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 97
; FirstLine = 73
; Folding = -
; Optimizer
; EnableXP
; DPIAware