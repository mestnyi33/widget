CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  XIncludeFile "id.pbi"
CompilerEndIf

Procedure GadgetsClipCallBack( GadgetID, lParam )
  ; https://www.purebasic.fr/english/viewtopic.php?t=64799
  ;
  ; Для виндовс чтобы приклепить гаджеты на место
  ; надо вызывать процедуру в конце создания всех гаджетов
  ; надо вызвать после создания всех гаджетов
  ; 
  If GadgetID
    Protected Gadget = ID::Gadget(GadgetID)
          
    If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
      If IsGadget( Gadget ) 
        Select GadgetType( Gadget )
          Case #PB_GadgetType_Spin
            Protected SpinNext = GetWindow_( GadgetID( gadget ), #GW_HWNDNEXT )
            SetWindowLongPtr_( SpinNext, #GWL_STYLE, GetWindowLongPtr_( SpinNext, #GWL_STYLE ) | #WS_CLIPSIBLINGS | #WS_CLIPCHILDREN )
            SetWindowPos_( SpinNext, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
            
          Case #PB_GadgetType_Panel
           SetWindowLongPtr_( GadgetID( gadget ), #GWL_EXSTYLE, GetWindowLongPtr_( GadgetID( gadget ), #GWL_EXSTYLE ) | #WS_EX_COMPOSITED )
         Case #PB_GadgetType_ComboBox
            Protected Height = GadgetHeight( Gadget )
            
            ;             Case #PB_GadgetType_Container 
            ;             ; Из-за бага когда устанавливаешь фоновый рисунок (например точки на кантейнер)
            ;               SetGadGetWidgetColor( Gadget, #PB_Gadget_BackColor, GetSysColor_( #COLOR_BTNFACE ))
            ;               
            ;             Case #PB_GadgetType_Panel 
            ;             ; Для панел гаджета темный фон убирать
            ;               If Not IsGadget( Gadget ) And (GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
            ;                 SetWindowLongPtr_(GadgetID, #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
            ;               EndIf
            ;               ; SetClassLongPtr_(GadgetID, #GCL_HBRBACKGROUND, GetStockObject_(#NULL_BRUSH))
            
        EndSelect
      EndIf
      
      SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS | #WS_CLIPCHILDREN )
      
      If Height
        ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height )
      EndIf
      
      SetWindowPos_( GadgetID, #HWND_TOP, 0,0,0,0, #SWP_NOMOVE | #SWP_NOSIZE )
    Else
      If IsGadget( Gadget ) 
        Select GadgetType( Gadget )
          Case #PB_GadgetType_Panel
           SetWindowLongPtr_( GadgetID, #GWL_EXSTYLE, GetWindowLongPtr_( GadgetID, #GWL_EXSTYLE ) | #WS_EX_COMPOSITED )
        EndSelect
      EndIf
    EndIf
    
  EndIf
  
  ProcedureReturn GadgetID
EndProcedure
Procedure ClipGadgets( WindowID )
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    EnumChildWindows_( WindowID, @GadgetsClipCallBack(), 0 )
    SetWindowLongPtr_( WindowID, #GWL_STYLE, GetWindowLongPtr_( WindowID, #GWL_STYLE ) | #WS_CLIPSIBLINGS | #WS_CLIPCHILDREN )
    SetWindowPos_( WindowID, #HWND_TOP, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
  CompilerEndIf
EndProcedure

;\\ example 1
CompilerIf #PB_Compiler_IsMainFile = 1
  EnableExplicit
  
  Procedure onCallback_Canvas()
    Debug "onCallback_Canvas " + EventGadget()
  EndProcedure
  
  
  Procedure Gadgets( WindowID )
    Protected I
    UseGadgetList( WindowID )
    CanvasGadget(1, 8, 8, 210, 30, #PB_Canvas_Border)   
    CanvasGadget(2, 16, 16, 180, 60, #PB_Canvas_Border)  
    CanvasGadget(3, 16, 16, 150, 90, #PB_Canvas_Border)  
    CanvasGadget(4, 16, 16, 120, 120, #PB_Canvas_Border)  
    CanvasGadget(5, 16, 16, 90, 150, #PB_Canvas_Border)  
    CanvasGadget(6, 16, 16, 60, 180, #PB_Canvas_Border)  
    CanvasGadget(7, 16, 16, 30, 210, #PB_Canvas_Border)  
    
    For i=1 To 7
      If IsGadget(i) And StartDrawing(CanvasOutput(i))
        Box(0,0,OutputWidth(),OutputHeight(), RGB(Random(255), Random(255), Random(255)))
        StopDrawing()
        BindGadgetEvent(i, @onCallback_Canvas())
      EndIf
    Next
  EndProcedure
  
  
  ;after use SetParent_(win2,win1) , how correctly show win2 ?
  Define win1=OpenWindow(1,0,0,380,350,"",#PB_Window_ScreenCentered)
     
  ButtonGadget(20,11,11,252,22,"Button")
  TextGadget(21,11,41,252,22,"Text")
  StringGadget(22,11,71,252,22,"String")
  
  ContainerGadget(210, 8, 98, 306, 133, #PB_Container_Raised)
  ButtonGadget(211, 10, 15, 80, 24, "Button 11")
  ButtonGadget(212, 95, 15, 80, 24, "Button 12")
  CloseGadgetList()
  
  
  Define win2=OpenWindow(2,0,0,225, 212,"2",#PB_Window_SystemMenu);,#PB_Window_WindowCentered,w1)
  ButtonGadget(252, 25, 15, 80, 24, "Button 12")
  
  SetParent_(win2,win1)
  
    Gadgets( win2 )
    ;     SpinGadget     (310, 20, 20, 100, 25, 0, 1000)
    ;     SetGadGetWidgetState (310, 5) 
    ;     SetGadGetWidgetText(310, "5")   ; set initial value
    ;     ComboBoxGadget (2100, 20, 35, 100, 155)
    
  SetWindowColor(2,RGB(255,255,0))
  
  ClipGadgets(win1)
  ClipGadgets(win2)
  
  Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow
CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 4
; Folding = -4+
; EnableXP