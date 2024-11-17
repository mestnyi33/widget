
; ============================================================
; Создает гаджет Splitter в текущем списке гаджетов. 
; Этот гаджет позволяет пользователю изменять размер двух дочерних гаджетов с помощью разделительной полосы.
; Параметры:
; 
; #Gadget - Номер для идентификации нового гаджета. #PB_Any - можно использовать для автоматического создания этого номера.
; x, y, width, height - Положение и размеры нового гаджета.
; #Gadget1, #Gadget2 - Гаджеты для размещения в сплиттере.
;
; [flags] (необязательно) - Флаги для изменения поведения гаджета. Это может быть комбинация следующих значений:
;    #PB_Splitter_Vertical - гаджет разделен по вертикали (а не по горизонтали, как по умолчанию).
;    #PB_Splitter_Separator - в разделителе отображается трехмерный разделитель.
;    #PB_Splitter_FirstFixed - при изменении размера гаджета-разделителя первый гаджет сохранит свой размер.
;    #PB_Splitter_SecondFixed - при изменении размера гаджета-разделителя второй гаджет сохранит свой размер.
; 
; ============================================================
; SplitterGadget() - использоваться со cледующими функция для работы:
;   GadgetToolTip() - добавить «мини-справку».
;   GetGadgetState() - получить текущую позицию разделителя в пикселях.
;   SetGadgetState() - изменить текущую позицию разделителя в пикселях.
;
;   GetGadgetAttribute() - с одним из следующих атрибутов:
;     #PB_Splitter_FirstGadget - получает номер первого гаджета.
;     #PB_Splitter_SecondGadget - получает номер второго гаджета.
;     #PB_Splitter_FirstMinimumSize - получает минимальный размер (в пикселях), который может иметь первый гаджет.
;     #PB_Splitter_SecondMinimumSize - получает минимальный размер (в пикселях), который может иметь второй гаджет.
;
;   SetGadgetAttribute(): с одним из следующих атрибутов:
;     #PB_Splitter_FirstGadget : заменяет первый гаджет новым.
;     #PB_Splitter_SecondGadget : заменяет второй гаджет новым.
;     #PB_Splitter_FirstMinimumSize : устанавливает минимальный размер (в пикселях), который может иметь первый гаджет.
;     #PB_Splitter_SecondMinimumSize: устанавливает минимальный размер (в пикселях), который может иметь второй гаджет.
;
; =============================================================
; Примечание. При замене гаджета с помощью SetGadgetAttribute() старый гаджет не освобождается автоматически. 
; Вместо этого он будет возвращен в родительское окно Splitter.
; Это позволяет переключать гаджеты между сплиттерами без необходимости пересоздавать какой-либо из них. 
; Если старый гаджет нужно освободить, его номер можно сначала получить с помощью GetGadgetAttribute(), а после замены гаджет освободить с помощью FreeGadget(). 
; Обратите внимание, что гаджет не может находиться сразу в двух сплиттерах. 
; Таким образом, чтобы переместить гаджет из одного сплиттера в другой, его сначала нужно заменить в первом сплиттере, чтобы он был в главном окне, а затем его можно было поместить во второй сплиттер.
; =============================================================

IncludePath "../"
XIncludeFile "widgets.pbi"

Procedure SetGadgetAttribute_(Gadget, Attribute, Value)
  If PB(IsGadget)(Gadget)
    If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
      ProcedureReturn widget::SetAttribute(PB(GetGadgetData)(Gadget), Attribute, Value)
    Else
      ProcedureReturn PB(SetGadgetAttribute)(Gadget, Attribute, Value)
    EndIf
  Else
    ProcedureReturn widget::SetAttribute(Gadget, Attribute, Value)
  EndIf
EndProcedure


Procedure SetGadgetState_(Gadget, State)
  If PB(IsGadget)(Gadget)
    If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
      ProcedureReturn widget::SetState(PB(GetGadgetData)(Gadget), State)
    Else
      ProcedureReturn PB(SetGadgetState)(Gadget, State)
    EndIf
  Else
    ProcedureReturn widget::SetState(Gadget, State)
  EndIf
EndProcedure


Procedure GadgetWidth_(Gadget, mode)
  If PB(IsGadget)(Gadget)
    If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
      ProcedureReturn widget::Width(PB(GetGadgetData)(Gadget), mode)
    Else
      ProcedureReturn PB(GadgetWidth)(Gadget, mode)
    EndIf
  Else
    ProcedureReturn widget::Width(Gadget, mode)
  EndIf
EndProcedure

Procedure GadgetHeight_(Gadget, mode)
  If PB(IsGadget)(Gadget)
    If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
      ProcedureReturn widget::Height(PB(GetGadgetData)(Gadget), mode)
    Else
      ProcedureReturn PB(GadgetHeight)(Gadget, mode)
    EndIf
  Else
    ProcedureReturn widget::Height(Gadget, mode)
  EndIf
EndProcedure

Macro SetGadgetAttribute(_gadget_, _attribute_, _value_)
  SetGadgetAttribute_(_gadget_, _attribute_, _value_)
EndMacro
Macro SetGadgetState(_gadget_, _state_)
  SetGadgetState_(_gadget_, _state_)
EndMacro
Macro GadgetWidth(_gadget_, _mode_ = #PB_Gadget_ActualSize)
  GadgetWidth_(_gadget_, _mode_)
EndMacro
Macro GadgetHeight(_gadget_, _mode_ = #PB_Gadget_ActualSize)
  GadgetHeight_(_gadget_, _mode_)
EndMacro
Macro SplitterGadget(_gadget_, X,Y,Width,Height, gadget1, gadget2, Flags=0)
  widget::Gadget(#PB_GadgetType_Splitter, _gadget_, X,Y,Width,Height, "", gadget1,gadget2,0, Flags)
EndMacro



; CompilerIf #PB_Compiler_IsMainFile
;   UseWidgets( )
;   
;   Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
;   
;   If OpenWindow(0, 0, 0, 850, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;     If widget::Open(0)
;      
; ;       Splitter_0 = widget::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical)
; ;       Splitter_0 = widget::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
;       Splitter_0 = widget::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
;       
;       ;       widget::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
; ;       widget::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
;       
;       Splitter_4 = widget::Splitter(430-GadgetX(GetCanvasGadget(Root())), 10-GadgetY(GetCanvasGadget(Root())), 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
;       
;       ; widget::SetState(Splitter_0, 20)
;       ; widget::SetState(Splitter_0, -20)
;       
;       TextGadget(#PB_Any, 530, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
;     EndIf
;     
;     WaitClose()
;   EndIf
;   
; CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile 
  UseWidgets( )
  EnableExplicit
  #__Text_Border = #PB_Text_Border
  
  Macro GetIndex( this )
    MacroExpandedCount
  EndMacro
  
  ; Procedure.l GetIndex( *this._S_widget )
  ;     ; ProcedureReturn *this\index - 1
  ;   EndProcedure
  
  Global window_ide, canvas_ide, fixed=1, state=1, minsize=1
  Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
  Global s_desi, s_tbar, s_view, s_help, s_list,s_insp
  
  Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget  
  OpenWindow(#PB_Any, 100,100,800,600, "ide", flag)
  ;   widget::Open()
  ;   window_ide = widget::GetCanvasWindow(root())
  ;   canvas_ide = widget::GetCanvasGadget(root())
  
  s_tbar = TextGadget(#PB_Any, 0,0,0,0,"", #__Text_Border)
  s_desi = TextGadget(#PB_Any, 0,0,0,0,"", #__Text_Border)
  s_view = TextGadget(#PB_Any, 0,0,0,0,"", #__Text_Border)
  s_list = TextGadget(#PB_Any, 0,0,0,0,"", #__Text_Border)
  s_insp = TextGadget(#PB_Any, 0,0,0,0,"", #__Text_Border)
  s_help  = TextGadget(#PB_Any, 0,0,0,0,"", #__Text_Border)
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4, Splitter_5
  Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
  Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  
  Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
  Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
  Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
  Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
  
  ;Splitter_0 = widget::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
  Splitter_0 = SplitterGadget(-1, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
  Splitter_1 = SplitterGadget(-1, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
  SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
  SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
  Splitter_2 = SplitterGadget(-1, 0, 0, 0, 0, Splitter_1, Button_5)
  Splitter_3 = SplitterGadget(-1, 0, 0, 0, 0, Button_2, Splitter_2)
  Splitter_4 = SplitterGadget(-1, 0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
  Splitter_5 = SplitterGadget(-1, 0, 0, 0, 0, s_desi, Splitter_4, #PB_Splitter_Vertical)
  
  Splitter_design = SplitterGadget(-1, 0,0,0,0, s_tbar,Splitter_5, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  ;Splitter_inspector = widget::Splitter(0,0,0,0, s_list,s_insp, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  Splitter_inspector = SplitterGadget(-1, 0,0,0,0, s_list,s_insp, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  splitter_debug = SplitterGadget(-1, 0,0,0,0, Splitter_design,s_view, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  splitter_help = SplitterGadget(-1, 0,0,0,0, Splitter_inspector,s_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  Splitter_ide = SplitterGadget(-1, 0,0,800,600, splitter_debug,splitter_help, #PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
  
  If minsize
    ;         ; set splitter default minimum size
    ;     widget::SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 20)
    ;     widget::SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 10)
    ;     widget::SetAttribute(splitter_help, #PB_Splitter_FirstMinimumSize, 20)
    ;     widget::SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 10)
    ;     widget::SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 20)
    ;     widget::SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 10)
    ;     widget::SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 20)
    ;     widget::SetAttribute(Splitter_inspector, #PB_Splitter_SecondMinimumSize, 10)
    ;     widget::SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
    ;     widget::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 10)
    
    ;   ; set splitter default minimum size
    SetGadgetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
    SetGadgetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
    SetGadgetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
    ; widget::SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 300)
    SetGadgetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
    SetGadgetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
    SetGadgetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
    SetGadgetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 200)
    ;widget::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
  EndIf
  
  If state
    ; set splitters dafault positions
    ;widget::SetState(Splitter_ide, -130)
    SetGadgetState(Splitter_ide, GadgetWidth(Splitter_ide)-220)
    SetGadgetState(splitter_help, GadgetHeight(splitter_help)-80)
    SetGadgetState(splitter_debug, GadgetHeight(splitter_debug)-150)
    SetGadgetState(Splitter_inspector, 200)
    SetGadgetState(Splitter_design, 30)
    SetGadgetState(Splitter_5, 120)
    
    SetGadgetState(Splitter_1, 20)
  EndIf
  
  ;widget::Resize(Splitter_ide, 0,0,820,620)
  
  SetGadgetText(s_tbar, "size: ("+Str(GadgetWidth(s_tbar))+"x"+Str(GadgetHeight(s_tbar))+") - " + Str(GetIndex( widget::GetParent( s_tbar ))) )
  SetGadgetText(s_desi, "size: ("+Str(GadgetWidth(s_desi))+"x"+Str(GadgetHeight(s_desi))+") - " + Str(GetIndex( widget::GetParent( s_desi ))))
  SetGadgetText(s_view, "size: ("+Str(GadgetWidth(s_view))+"x"+Str(GadgetHeight(s_view))+") - " + Str(GetIndex( widget::GetParent( s_view ))))
  SetGadgetText(s_list, "size: ("+Str(GadgetWidth(s_list))+"x"+Str(GadgetHeight(s_list))+") - " + Str(GetIndex( widget::GetParent( s_list ))))
  SetGadgetText(s_insp, "size: ("+Str(GadgetWidth(s_insp))+"x"+Str(GadgetHeight(s_insp))+") - " + Str(GetIndex( widget::GetParent( s_insp ))))
  SetGadgetText(s_help, "size: ("+Str(GadgetWidth(s_help))+"x"+Str(GadgetHeight(s_help))+") - " + Str(GetIndex( widget::GetParent( s_help ))))
  
  Repeat 
    Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ----
; EnableXP