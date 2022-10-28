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
            
          Case #PB_GadgetType_ComboBox
            Protected Height = GadgetHeight( Gadget )
            
            ;             ; Из-за бага когда устанавливаешь фоновый рисунок (например точки на кантейнер)
            ;             Case #PB_GadgetType_Container 
            ;               SetGadgetColor( Gadget, #PB_Gadget_BackColor, GetSysColor_( #COLOR_BTNFACE ))
            ;               
            ;             ; Для панел гаджета темный фон убирать
            ;             Case #PB_GadgetType_Panel 
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
      
      SetWindowPos_( GadgetID, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
    EndIf
    
  EndIf
  
  ProcedureReturn GadgetID
EndProcedure
Procedure ClipGadgets( WindowID )
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    EnumChildWindows_( WindowID, @GadgetsClipCallBack(), 0 )
  CompilerEndIf
EndProcedure

; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 14
; Folding = --
; EnableXP