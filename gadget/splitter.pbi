
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
      Protected *r.structures::_s_ROOT = key::GetData( GadgetID(gadget) )
      If *r
         ProcedureReturn widgets::SetAttribute(*r, Attribute, Value)
      Else
         ProcedureReturn PB(SetGadgetAttribute)(Gadget, Attribute, Value)
      EndIf
   Else
      ProcedureReturn widgets::SetAttribute(Gadget, Attribute, Value)
   EndIf
EndProcedure


Procedure SetGadgetState_(Gadget, State)
   If PB(IsGadget)(Gadget)
      Protected *r.structures::_s_ROOT = key::GetData( GadgetID(gadget) )
      If *r
         ProcedureReturn widgets::SetState(*r, State)
      Else
         ProcedureReturn PB(SetGadgetState)(Gadget, State)
      EndIf
   Else
      ProcedureReturn widgets::SetState(Gadget, State)
   EndIf
EndProcedure


Procedure GadgetWidth_(Gadget, mode)
   If PB(IsGadget)(Gadget)
      Protected *r.structures::_s_ROOT = key::GetData( GadgetID(gadget) )
      If *r
         ProcedureReturn widgets::Width(*r, mode)
      Else
         ProcedureReturn PB(GadgetWidth)(Gadget, mode)
      EndIf
   Else
      ProcedureReturn widgets::Width(Gadget, mode)
   EndIf
EndProcedure

Procedure GadgetHeight_(Gadget, mode)
   If PB(IsGadget)(Gadget)
      Protected *r.structures::_s_ROOT = key::GetData( GadgetID(gadget) )
      If *r
         ProcedureReturn widgets::Height(*r, mode)
      Else
         ProcedureReturn PB(GadgetHeight)(Gadget, mode)
      EndIf
   Else
      ProcedureReturn widgets::Height(Gadget, mode)
   EndIf
EndProcedure

Procedure SplitterGadget_(Gadget, X,Y,Width,Height, gadget1, gadget2, Flags=0)
   ;    CompilerIf 
   ProcedureReturn widgets::Gadget(#PB_GadgetType_Splitter, Gadget, X,Y,Width,Height, "", gadget1,gadget2,0, Flags)
   ;    CompilerElse
   ;       ProcedureReturn SplitterGadget(Gadget, X,Y,Width,Height, gadget1, gadget2, Flags)
   ;    CompilerEndIf
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

Macro SplitterGadget(G, X,Y,W,H, G1,G2, F=0) : SplitterGadget_(G, X,Y,W,H, G1,G2, F) : EndMacro : UseWidgets( )

CompilerIf #PB_Compiler_IsMainFile 
   
   EnableExplicit
   #__FLAG_Border = #PB_Text_Border
   
   Macro GetIndex( this )
      MacroExpandedCount
   EndMacro
   Macro GetParent( this )
      MacroExpandedCount*2
   EndMacro
   
   ; Procedure.l GetIndex( *this._S_widget )
   ;     ; ProcedureReturn *this\index - 1
   ;   EndProcedure
   
   Global window_ide, canvas_ide, fixed=1, state=1, minsize=1
   Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
   Global s_desi, s_tbar, s_view, s_help, s_list,s_insp
   
   Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget  
   OpenWindow(#PB_Any, 100,100,800,600, "ide", flag)
   ;   widgets::Open()
   ;   window_ide = widgets::GetCanvasWindow(root())
   ;   canvas_ide = widgets::GetCanvasGadget(root())
   
   s_tbar = TextGadget(#PB_Any, 0,0,0,0,"", #__FLAG_Border)
   s_desi = TextGadget(#PB_Any, 0,0,0,0,"", #__FLAG_Border)
   s_view = TextGadget(#PB_Any, 0,0,0,0,"", #__FLAG_Border)
   s_list = TextGadget(#PB_Any, 0,0,0,0,"", #__FLAG_Border)
   s_insp = TextGadget(#PB_Any, 0,0,0,0,"", #__FLAG_Border)
   s_help  = TextGadget(#PB_Any, 0,0,0,0,"", #__FLAG_Border)
   
   Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4, Splitter_5
   Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
   Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
   
   Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
   Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
   Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
   Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
   
   ;Splitter_0 = widgets::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
   Splitter_0 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
   Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
   SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
   SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
   Splitter_2 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5)
   Splitter_3 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2)
   Splitter_4 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
   Splitter_5 = SplitterGadget(#PB_Any, 0, 0, 0, 0, s_desi, Splitter_4, #PB_Splitter_Vertical)
   
   Splitter_design = SplitterGadget(#PB_Any, 0,0,0,0, s_tbar,Splitter_5, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
   ;Splitter_inspector = widgets::Splitter(0,0,0,0, s_list,s_insp, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
   Splitter_inspector = SplitterGadget(#PB_Any, 0,0,0,0, s_list,s_insp, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
   splitter_debug = SplitterGadget(#PB_Any, 0,0,0,0, Splitter_design,s_view, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
   splitter_help = SplitterGadget(#PB_Any, 0,0,0,0, Splitter_inspector,s_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
   Splitter_ide = SplitterGadget(#PB_Any, 0,0,800,600, splitter_debug,splitter_help, #PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
   
   If minsize
      ;         ; set splitter default minimum size
      ;     widgets::SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 20)
      ;     widgets::SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 10)
      ;     widgets::SetAttribute(splitter_help, #PB_Splitter_FirstMinimumSize, 20)
      ;     widgets::SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 10)
      ;     widgets::SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 20)
      ;     widgets::SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 10)
      ;     widgets::SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 20)
      ;     widgets::SetAttribute(Splitter_inspector, #PB_Splitter_SecondMinimumSize, 10)
      ;     widgets::SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
      ;     widgets::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 10)
      
      ;   ; set splitter default minimum size
      SetGadgetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
      SetGadgetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
      SetGadgetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
      ; widgets::SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 300)
      SetGadgetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
      SetGadgetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
      SetGadgetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
      SetGadgetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 200)
      ;widgets::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
   EndIf
   
   If state
      ; set splitters dafault positions
      ;widgets::SetState(Splitter_ide, -130)
      SetGadgetState(Splitter_ide, GadgetWidth(Splitter_ide)-220)
      SetGadgetState(splitter_help, GadgetHeight(splitter_help)-80)
      SetGadgetState(splitter_debug, GadgetHeight(splitter_debug)-150)
      SetGadgetState(Splitter_inspector, 200)
      SetGadgetState(Splitter_design, 30)
      SetGadgetState(Splitter_5, 120)
      
      SetGadgetState(Splitter_1, 20)
   EndIf
   
   ;widgets::Resize(Splitter_ide, 0,0,820,620)
   
   SetGadgetText(s_tbar, "size: ("+Str(GadgetWidth(s_tbar))+"x"+Str(GadgetHeight(s_tbar))+") - " + Str(GetIndex( GetParent( s_tbar ))) )
   SetGadgetText(s_desi, "size: ("+Str(GadgetWidth(s_desi))+"x"+Str(GadgetHeight(s_desi))+") - " + Str(GetIndex( GetParent( s_desi ))))
   SetGadgetText(s_view, "size: ("+Str(GadgetWidth(s_view))+"x"+Str(GadgetHeight(s_view))+") - " + Str(GetIndex( GetParent( s_view ))))
   SetGadgetText(s_list, "size: ("+Str(GadgetWidth(s_list))+"x"+Str(GadgetHeight(s_list))+") - " + Str(GetIndex( GetParent( s_list ))))
   SetGadgetText(s_insp, "size: ("+Str(GadgetWidth(s_insp))+"x"+Str(GadgetHeight(s_insp))+") - " + Str(GetIndex( GetParent( s_insp ))))
   SetGadgetText(s_help, "size: ("+Str(GadgetWidth(s_help))+"x"+Str(GadgetHeight(s_help))+") - " + Str(GetIndex( GetParent( s_help ))))
   
   Repeat 
   Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 55
; FirstLine = 42
; Folding = ----
; EnableXP