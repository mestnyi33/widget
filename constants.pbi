CompilerIf Not Defined(constants, #PB_Module)
   DeclareModule constants
      Macro BinaryFlag(_variable_, _Constant_, _State_ = #True)
         Bool(Bool(((_variable_) & _Constant_) = _Constant_) = _State_)
      EndMacro
      
      ;-\\ CONSTANTs
      CompilerIf Not Defined(PB_Compiler_DPIAware, #PB_Constant)
         #PB_Compiler_DPIAware = 0
      CompilerEndIf
      CompilerIf Not Defined(PB_Canvas_Container, #PB_Constant)
         #PB_Canvas_Container = 1<<5
      CompilerEndIf
      CompilerIf Not Defined(PB_EventType_Resize, #PB_Constant)
         #PB_EventType_Resize = 6
      CompilerEndIf
      CompilerIf Not Defined(PB_EventType_ReturnKey, #PB_Constant)
         #PB_EventType_ReturnKey = 7
      CompilerEndIf
      CompilerIf Not Defined(PB_EventType_CloseItem, #PB_Constant)
         #PB_EventType_CloseItem = 65535
      CompilerEndIf
      CompilerIf Not Defined(PB_EventType_SizeItem, #PB_Constant)
         #PB_EventType_SizeItem = 65534
      CompilerEndIf
      ;
      ;-\\ ToolBar
      CompilerIf #PB_Compiler_Version > 573
         #PB_ToolBarIcon_Cut           = 0
         #PB_ToolBarIcon_Copy          = 1
         #PB_ToolBarIcon_Paste         = 2
         #PB_ToolBarIcon_Undo          = 3      
         #PB_ToolBarIcon_Redo          = 4
         #PB_ToolBarIcon_Delete        = 5
         #PB_ToolBarIcon_New           = 6
         #PB_ToolBarIcon_Open          = 7
         #PB_ToolBarIcon_Save          = 8
         #PB_ToolBarIcon_PrintPreview  = 9
         #PB_ToolBarIcon_Properties    = 10
         #PB_ToolBarIcon_Help          = 11
         #PB_ToolBarIcon_Find          = 12
         #PB_ToolBarIcon_Replace       = 13
         #PB_ToolBarIcon_Print         = 14
      CompilerEndIf
      CompilerIf Not Defined(PB_toolBar_Small, #PB_Constant)
         #PB_ToolBar_Small = 1<<0
      CompilerEndIf
      CompilerIf Not Defined(PB_ToolBar_Large, #PB_Constant)
         #PB_ToolBar_Large = 1<<1
      CompilerEndIf
      CompilerIf Not Defined(PB_ToolBar_Text, #PB_Constant)
         #PB_ToolBar_Text = 1<<2
      CompilerEndIf
      CompilerIf Not Defined(PB_ToolBar_InlineText, #PB_Constant)
         #PB_ToolBar_InlineText = 1<<3
      CompilerEndIf
      #PB_ToolBar_Buttons = 1<<4
      #PB_ToolBar_Left    = 1<<5
      #PB_ToolBar_Right   = 1<<6
      #PB_ToolBar_Bottom  = 1<<7
      ;
      ;-\\ Message
      CompilerIf Not Defined(PB_MessageRequester_Info, #PB_Constant)
         #PB_MessageRequester_Info = 1<<2
      CompilerEndIf
      CompilerIf Not Defined(PB_MessageRequester_Error, #PB_Constant)
         #PB_MessageRequester_Error = 1<<3
      CompilerEndIf
      CompilerIf Not Defined(PB_MessageRequester_warning, #PB_Constant)
         #PB_MessageRequester_Warning = 1<<4
      CompilerEndIf
      CompilerIf Not Defined(PB_MessageRequester_Error, #PB_Constant)
         #PB_MessageRequester_Error = 1<<5;  8
      CompilerEndIf
      #PB_MessageRequester_WindowCentered = 1<<6
      #PB_MessageRequester_ScreenCentered = 1<<7
      ;
     
      
      ;-\\ Bounds
      #__bounds_Parentsize = 0
      #__bounds_Children = 1<<0
      #__bounds_move = 1<<1
      #__bounds_size = 1<<2
      
      ;       Enumeration - 1
      ;          #SelectionStyle_Default
      ;          #SelectionStyle_none
      ;          #SelectionStyle_Solid
      ;          #SelectionStyle_Dotted
      ;          #SelectionStyle_Dashed
      ;       EndEnumeration
      ;       #SelectionStyle_Mode       = $100
      ;       #SelectionStyle_Completely = 0
      ;       #SelectionStyle_partially  = $100
      ;       #SelectionStyle_Ignore     = #PB_Ignore
      ;       
      ;       Enumeration 1
      ;          #Boundary_MinX
      ;          #Boundary_MinY
      ;          #Boundary_MaxX
      ;          #Boundary_MaxY
      ;          #Boundary_MinWidth
      ;          #Boundary_MinHeight
      ;          #Boundary_MaxWidth
      ;          #Boundary_MaxHeight
      ;       EndEnumeration
      ;       #Boundary_Ignore         = - $80000000    ; 0b10000000...
      ;       #Boundary_Default        = - $7FFFFFFF    ; 0b01111111...
      ;       #Boundary_none           = $3FFFFFFF      ; 0b00111111...
      ;       #Boundary_parentSize     = $60000000      ; 0b01100000...
      ;       #Boundary_parentSizeMask = $C0000000      ; 0b11000000...
      ;       
      ;
      ;\\ default values
      ;
      ;#__BAR_toggle_line_size = 0
      #__BAR_splitter_size = 9
      #__ButtonRound  = 7
      #__BAR_button_size   = 16
      #__tab_size   = 25;18
      
      #__Draw_plus_Size = 5
      
      
      #__SublevelSize = 16
      
      #__tracksize = 4
      #__arrow_Size = 4
      #__arrow_type = -1 ; ;-1 ;0 ;1
      
      ; caption bar buttons
      #__wb_Close = 1
      #__wb_Maxi  = 2
      #__wb_Mini  = 3
      #__wb_help  = 4
      
      #__sOC = SizeOf(Character)
      
      ;-\\ Anchors
      #__a_anchors_Size = 7
      
      ;-\\ Direction 
      #__left = 1
      #__top = 2
      #__right = 3
      #__bottom = 4
      
      ; a_Index( )
      #__a_Left         = #__left
      #__a_top          = #__top
      #__a_Right        = #__right
      #__a_Bottom       = #__bottom
      #__a_Left_top     = 5
      #__a_Right_top    = 6
      #__a_Right_Bottom = 7
      #__a_Left_Bottom  = 8
      #__a_Moved        = 9
      #__a_Moved2       = 10
      #__a_Count        = 11
      
      ; a_Selector( )
      #__a_Line_Left    = 0
      #__a_Line_top     = 1
      #__a_Line_Right   = 2
      #__a_Line_Bottom  = 3
      
      ; a_Set( ) flags
      #__a_NoDraw   = 1<<0
      #__a_Position = 1<<1 ; положение
      #__a_Width    = 1<<2 ; по ширине
      #__a_Height   = 1<<3 ; по высоте
      #__a_Corner   = 1<<4 ; по углам
      #__a_Zoom     = 1<<5 ; растянутый
      #__a_Edge     = #__a_Width | #__a_Height ; по крайам
      #__a_Size     = #__a_Corner | #__a_Edge
      #__a_Full     = #__a_position | #__a_Size
      
      ;-\\ edit errors
      Enumeration 1
         #__error_text_Input
         #__error_text_Back
         #__error_text_Return
      EndEnumeration
      
      ;-\\ edit selection
      #__sel_to_Line   = 1
      #__sel_to_First  = 2
      #__sel_to_Remove = - 1
      #__sel_to_Last   = - 2
      #__sel_to_Set    = 5
      
      ;-\\ Coordinate (pos & size)
      #__c_screen    = 0 ; screen
      #__c_frame     = 1 ; frame screen
      #__c_inner     = 2 ; inner screen
      #__c_container = 3 ; container
      #__c_required  = 4 ; required
      #__c_window    = 5 ; window
                         ;
      #__c_restore   = 6 ; 
      #__c_draw      = 7 ; clip screen
      #__c_idraw     = 8 ; clip inner
      #__c           = 9
      
      ;-\\ Color
      #__FrontColor       = #PB_Gadget_FrontColor      ; 1
      #__BackColor        = #PB_Gadget_BackColor       ; 2
      #__LineColor        = #PB_Gadget_LineColor       ; 3
      #__TitleFrontColor  = #PB_Gadget_TitleFrontColor ; 4
      #__TitleBackColor   = #PB_Gadget_BackColor       ; 5
      #__GrayTextColor    = #PB_Gadget_GrayTextColor   ; 6
      #__FrameColor       = 7
      #__ForeColor        = 8
      
      ;- 
      ;-\\ state
      ;#__s_Selected  = 1<<5  ; выделено
      ;#__s_Expanded  = 1<<6  ; развернуто
      ;#__s_Checked   = 1<<7  ; выбрано
      ;#__s_Collapsed = 1<<8  ; свернуто
      ;#__s_Inbetween = 1<<9
      ;#__s_Entered   = 1<<10 ; мышь внутри
      ;#__s_Pressed   = 1<<11 ; нажато
      #__s_nofocus    = -1 
      
      ;-\\ resize-state
      ;       ;#__resize_Restore  = 1<<1 
      ;       #__resize_Minimize = 1<<2 
      ;       #__resize_Maximize = 1<<3 
      
      ;-\\ color-state
      Enumeration
         #__s_0
         #__s_1
         #__s_2
         #__s_3
      EndEnumeration
      
      ;-\\ mouse-state
      ; #__mouse_EnterChild = - 2
      ; #__mouse_EnterInner = 2
      
      ;-
      ;-\\ event-type
      Enumeration #PB_EventType_FirstCustomValue
         #PB_EventType_Drop
         #PB_EventType_MouseWheelX
         #PB_EventType_MouseWheelY
         #PB_EventType_ScrollChange
         #PB_EventType_Repaint
      EndEnumeration
      
      Enumeration 1
         ;#__EVENT_Create
         #__EVENT_Focus
         #__EVENT_LostFocus
         ;
         #__EVENT_MouseEnter
         #__EVENT_MouseLeave
         #__EVENT_MouseMove
         #__EVENT_MouseWheel
         ;
         #__EVENT_Down
         #__EVENT_LeftDown
         #__EVENT_MiddleDown
         #__EVENT_RightDown
         ;
         #__EVENT_Up
         #__EVENT_LeftUp
         #__EVENT_MiddleUp
         #__EVENT_RightUp
         ;
         #__EVENT_LeftClick
         #__EVENT_Left2Click
         #__EVENT_Left3Click
         #__EVENT_RightClick
         #__EVENT_Right2Click
         #__EVENT_Right3Click
         ;
         #__EVENT_Change
         #__EVENT_CursorChange
         #__EVENT_StatusChange
         #__EVENT_ScrollChange
         ;
         ;#__EVENT_PageDown
         ;#__EVENT_PageUp
         ;
         #__EVENT_KeyDown
         #__EVENT_Input
         #__EVENT_Return
         #__EVENT_KeyUp
         ;
         #__EVENT_DragStart
         #__EVENT_DragStop
         #__EVENT_Drop
         ;
         #__EVENT_Draw
         ;
         ;#__EVENT_ResizeBegin
         #__EVENT_Resize
         ;#__EVENT_ResizeEnd
         #__EVENT_Maximize
         #__EVENT_Minimize
         #__EVENT_Restore
         ;
         #__EVENT_Close
         #__EVENT_Free
         #__event
      EndEnumeration
      
      ;     #__eventmask_Create       = 1<<#__EVENT_Create
      ;     #__eventmask_enter        = 1<<#__EVENT_MouseEnter
      ;     #__eventmask_Focus        = 1<<#__EVENT_Focus
      ;     #__eventmask_Down         = 1<<#__EVENT_Down
      ;     #__eventmask_MiddleDown   = 1<<#__EVENT_MiddleDown
      ;     #__eventmask_LeftDown     = 1<<#__EVENT_LeftDown
      ;     #__eventmask_RightDown    = 1<<#__EVENT_RightDown
      ;     #__eventmask_Dragstart    = 1<<#__EVENT_Dragstart
      ;     #__eventmask_Mousemove    = 1<<#__EVENT_MouseMove
      ;     #__eventmask_wheel        = 1<<#__EVENT_MouseWheel
      ;     #__eventmask_Leave        = 1<<#__EVENT_MouseLeave
      ;     #__eventmask_Drop         = 1<<#__EVENT_Drop
      ;     #__eventmask_Up           = 1<<#__EVENT_Up
      ;     #__eventmask_MiddleUp     = 1<<#__EVENT_MiddleUp
      ;     #__eventmask_LeftUp       = 1<<#__EVENT_LeftUp
      ;     #__eventmask_RightUp      = 1<<#__EVENT_RightUp
      ;     #__eventmask_LeftClick    = 1<<#__EVENT_LeftClick
      ;     #__eventmask_RightClick   = 1<<#__EVENT_RightClick
      ;     #__eventmask_Left2Click   = 1<<#__EVENT_Left2Click
      ;     #__eventmask_Right2Click  = 1<<#__EVENT_Right2Click
      ;     #__eventmask_Left3Click   = 1<<#__EVENT_Left3Click
      ;     #__eventmask_Right3Click  = 1<<#__EVENT_Right3Click
      ;     #__eventmask_Lostfocus    = 1<<#__EVENT_LostFocus
      ;     #__eventmask_Change       = 1<<#__EVENT_Change
      #__eventmask_Cursor       = 1<<#__EVENT_CursorChange
      ;     #__eventmask_StatusChange = 1<<#__EVENT_StatusChange
      ;     #__eventmask_ScrollChange = 1<<#__EVENT_ScrollChange
      ;     #__eventmask_KeyDown      = 1<<#__EVENT_KeyDown
      ;     #__eventmask_Input        = 1<<#__EVENT_Input
      ;     #__eventmask_Return       = 1<<#__EVENT_Return
      ;     #__eventmask_KeyUp        = 1<<#__EVENT_KeyUp
      #__eventmask_Draw         = 1<<#__EVENT_Draw
      ;     #__eventmask_Maximize     = 1<<#__EVENT_Maximize
      ;     #__eventmask_Minimize     = 1<<#__EVENT_Minimize
      ;     #__eventmask_Restore      = 1<<#__EVENT_Restore
      ;     #__eventmask_Resizebegin  = 1<<#__EVENT_ResizeBegin
      #__eventmask_Resize       = 1<<#__EVENT_Resize
      ;     #__eventmask_Resizeend    = 1<<#__EVENT_ResizeEnd
      ;     #__eventmask_Close        = 1<<#__EVENT_Close
      ;     #__eventmask_Free         = 1<<#__EVENT_Free  ; Destroy
      
      
      ; Если флагов станет больше 8, смените тип state.a на state.w (до 16 флагов) или state.l (до 32 флагов).
      
      ; .a (ASCII/Byte) — 8 бит (8 флагов)
      ; .w (Word) — 16 бит (16 флагов)
      ; .l (Long) — 32 бита (32 флага)
      ; .i (Integer) — 32 или 64 бита (зависит от разрядности системы x86/x64)
      ; .q (Quad) — 64 бита (64 флага)
      
      #__text_editable  = 1 << 0 ; Будет 1  (2^0)
      #__text_pass      = 1 << 1 ; Будет 2  (2^1)
      #__text_lower     = 1 << 2 ; Будет 4  (2^2)
      #__text_upper     = 1 << 3 ; Будет 8  (2^3)
      #__text_numeric   = 1 << 4 ; Будет 16 (2^4)
      #__text_multiline = 1 << 5 ; Будет 32 (2^5)
      #__text_invert    = 1 << 6 ; Будет 64 (2^6)
      #__text_vertical  = 1 << 7 ; Будет 128(2^7)
      
      ; ==============================================================================
      ;- МАСКИ - Единые битовые константы (Quad)
      ; ==============================================================================
      #__MASK_none      = 0
      #__MASK_update    = 1 << 0         ; Флаг: Требуется пересчет геометрии (для всех) (TextWidth и т.д.) нужно пересчитать координаты X для каретки/выделения.
      
      #__MASK_left      = 1 << #__left   ; 2   move to left
      #__MASK_top       = 1 << #__top    ; 4   move to top
      #__MASK_right     = 1 << #__right  ; 8   move to right
      #__MASK_bottom    = 1 << #__bottom ; 16  move to bottom
      #__MASK_center    = 1 << 5
      
      #__MASK_hover     = 1 << 6
      #__MASK_press     = 1 << 7         ; 64  button press
      #__MASK_release   = 1 << 8         ; 128 button release
      #__MASK_focus     = 1 << 9         ; Виджет в фокусе / Строка выбрана / Окно активно
      #__MASK_active    = 1 << 10        ; Виджет в фокусе / Строка выбрана / Окно активно
      #__MASK_drag      = 1 << 11        ; Состояние перетаскивания Объект в процессе перетаскивания
      #__MASK_redraw    = 1 << 12        ; Флаг: Требуется перерисовка
      
      #__MASK_hide      = 1 << 14        ; Объект скрыт изначально (базовый флаг)
      #__MASK_disable   = 1 << 15        ; Объект заблокирован изначально (базовый флаг)
      #__MASK_hidden    = 1 << 16        ; Фактическое текущее состояние скрытия
      #__MASK_disabled  = 1 << 17        ; Фактическое текущее состояние блокировки
                                         ;#__MASK_cursor    = 1 << 18
                                         ;
      #__MASK_resize    = 1 << 19
      #__MASK_minimize  = 1 << 30
      #__MASK_maximize  = 1 << 31
      
      #__maskrow_edit      = 1 << 21        ; Выделение (Строка)
      #__maskrow_change    = 1 << 22        ; текст изменился, надо перепарсить токены.
      #__maskrow_node      = 1 << 23        ; Является узлом (Строка) / Деревом (Виджет)
      #__maskrow_collapsed = 1 << 24        ; Свернуто (Узел/Ветка)
      
      #__MASK_hover_a = 1 << 25
      #__MASK_hover_in = 1 << 26
      #__MASK_visible = 1 << 27
      ;#__MASK_checked = 1 << 28
      
      ;#__MASK_tokken    = 1 << 20
      #__MASK_intersect    = 1 << 30
      ;
      ;-\\ create-type
      #__TYPE_Root          = - 1
      #__TYPE_Window        = - 2
      #__TYPE_Message       = - 3
      #__TYPE_PopupBar      = - 4
      #__TYPE_MenuBar       = - 5
      #__TYPE_ToolBar       = - 6
      #__TYPE_TabBar        = - 7
      #__TYPE_StatusBar     = - 8
      #__TYPE_Properties    = - 9
      ;
      ; #__TYPE_Toggled       = - 10
      ; #__TYPE_ImageButton   = - 11
      ; #__TYPE_StringButton  = - 12
      ; #__TYPE_Hiasm         = - 13
      ;
      #__TYPE_Unknown       = #PB_GadgetType_Unknown       ; 0
      #__TYPE_Button        = #PB_GadgetType_Button        ; 1
      #__TYPE_String        = #PB_GadgetType_String        ; 2
      #__TYPE_Text          = #PB_GadgetType_Text          ; 3
      #__TYPE_CheckBox      = #PB_GadgetType_CheckBox      ; 4
      #__TYPE_Option        = #PB_GadgetType_Option        ; 5
      #__TYPE_ListView      = #PB_GadgetType_ListView      ; 6
      #__TYPE_Frame         = #PB_GadgetType_Frame         ; 7
      #__TYPE_ComboBox      = #PB_GadgetType_ComboBox      ; 8
      #__TYPE_Image         = #PB_GadgetType_Image         ; 9
      #__TYPE_HyperLink     = #PB_GadgetType_HyperLink     ; 10
      #__TYPE_Container     = #PB_GadgetType_Container     ; 11
      #__TYPE_ListIcon      = #PB_GadgetType_ListIcon      ; 12
      #__TYPE_IPAddress     = #PB_GadgetType_IPAddress     ; 13
      #__TYPE_Progress      = #PB_GadgetType_ProgressBar   ; 14   ;
      #__TYPE_Scroll        = #PB_GadgetType_ScrollBar     ; 15   ;
      #__TYPE_ScrollArea    = #PB_GadgetType_ScrollArea    ; 16
      #__TYPE_Track         = #PB_GadgetType_TrackBar      ; 17   ;
      #__TYPE_Web           = #PB_GadgetType_Web           ; 18
      #__TYPE_ButtonImage   = #PB_GadgetType_ButtonImage   ; 19
      #__TYPE_Calendar      = #PB_GadgetType_Calendar      ; 20
      #__TYPE_Date          = #PB_GadgetType_Date          ; 21
      #__TYPE_Editor        = #PB_GadgetType_Editor        ; 22
      #__TYPE_ExplorerList  = #PB_GadgetType_ExplorerList  ; 23
      #__TYPE_ExplorerTree  = #PB_GadgetType_ExplorerTree  ; 24
      #__TYPE_ExplorerCombo = #PB_GadgetType_ExplorerCombo ; 25
      #__TYPE_Spin          = #PB_GadgetType_Spin          ; 26
      #__TYPE_Tree          = #PB_GadgetType_Tree          ; 27
      #__TYPE_Panel         = #PB_GadgetType_Panel         ; 28
      #__TYPE_Splitter      = #PB_GadgetType_Splitter      ; 29
      #__TYPE_MDI           = #PB_GadgetType_MDI           ; 30
                                                           ;
      #__TYPE_Scintilla     = #PB_GadgetType_Scintilla     ; 31
      #__TYPE_Shortcut      = #PB_GadgetType_Shortcut      ; 32
      #__TYPE_Canvas        = #PB_GadgetType_Canvas        ; 33
      #__TYPE_OpenGL        = #PB_GadgetType_OpenGL        ; 34
      
      ;
      ;-\\ create-flags
      #__FLAG_button_Default   = 1<<0
      ; #__FLAG_ = 1<<1
      ; #__FLAG_ = 1<<2
      ; #__FLAG_ = 1<<3
      ; #__FLAG_ = 1<<4
      ; #__FLAG_ = 1<<5
      ; #__FLAG_ = 1<<6
      #__FLAG_Collapsed       = 1<<6
      #__FLAG_OptionBoxes     = 1<<7
      ; #__FLAG_ = 1<<8
      #__FLAG_CheckBoxes      = 1<<8 
      ; #__FLAG_ = 1<<9
      ; #__FLAG_ = 1<<10
      ; #__FLAG_ = 1<<11
      ; #__FLAG_ = 1<<12
      #__FLAG_ThreeState      = 1<<12 
      ; #__FLAG_ = 1<<13
      ; #__FLAG_ = 1<<14
      ; #__FLAG_ = 1<<15
      #__FLAG_RowClickSelect  = 1<<16   
      ; #__FLAG_ = 1<<17
      ; #__FLAG_ = 1<<18
      ; #__FLAG_ = 1<<19
      ; #__FLAG_ = 1<<20
      ; #__FLAG_ = 1<<21
      #__FLAG_RowMultiSelect  = 1<<21
      ; #__FLAG_ = 1<<22
      #__FLAG_RowFullSelect   = 1<<22
      ; #__FLAG_ = 1<<23
      ; #__FLAG_ = 1<<24
      ; #__FLAG_ = 1<<25
      #__FLAG_GridLines       = 1<<25
      #__FLAG_BorderRaised    = 1<<26
      #__FLAG_BorderDouble    = 1<<27
      ; #__FLAG_ = 1<<28
      #__FLAG_BorderSingle    = 1<<29  
      ; #__FLAG_ = 1<<30
      #__FLAG_Borderless      = 1<<31
      #__FLAG_BorderFlat      = 1<<32
      ;
      #__FLAG_Child           = 1<<33
      #__FLAG_Invert          = 1<<34
      #__FLAG_Vertical        = 1<<35
      #__FLAG_Transparent     = 1<<36
      ;
      #__FLAG_NoFocus         = 1<<37
      #__FLAG_NoLines         = 1<<38
      #__FLAG_NoButtons       = 1<<39
      #__FLAG_NoGadgets       = 1<<40
      ;#__FLAG_NoScrollBars    = 1<<41
      ;
      #__FLAG_TextPassword    = 1<<42
      #__FLAG_TextWordWrap    = 1<<43
      #__FLAG_TextMultiLine   = 1<<44
      #__FLAG_TextInLine      = 1<<45
      #__FLAG_TextNumeric     = 1<<46
      #__FLAG_TextReadonly    = 1<<47
      #__FLAG_TextLowerCase   = 1<<48
      #__FLAG_TextUpperCase   = 1<<49
      ;
      ; #__FLAG_Modal         = 1<<50
      ; #__FLAG_AllEvents     = 1<<51
      ; #__FLAG_              = 1<<52
      ; #__FLAG_              = 1<<53
      ; #__FLAG_           = 1<<54
      ; #__FLAG_          = 1<<55
      
      ;- \\ align-flag
      #__FLAG_Left            = 1<<56
      #__FLAG_Top             = 1<<57
      #__FLAG_Right           = 1<<58
      #__FLAG_Bottom          = 1<<59
      #__FLAG_Center          = 1<<60 
      #__FLAG_AutoSize        = 1<<61
      ;
      #__FLAG_Proportional   = 1<<62
      #__FLAG_Full           = 1<<63
      #__FLAG_none           = 0
      
      ;
      ;-\\ Window
      #__window_FrameSize      = 4
      #__window_CaptionHeight  = 24
      
      ;-\\ Text
      #__FLAG_TextInvert       = #__FLAG_Invert
      #__FLAG_TextVertical     = #__FLAG_Vertical
      
      #__FLAG_TextLeft           = #__FLAG_Left
      #__FLAG_TextTop          = #__FLAG_Top
      #__FLAG_TextRight        = #__FLAG_Right
      #__FLAG_TextBottom       = #__FLAG_Bottom
      #__FLAG_TextCenter       = #__FLAG_Center
      
       ;-\\ Bar
      ; attribute
      #__BAR_Minimum           = 1
      #__BAR_Maximum           = 2
      #__BAR_PageLength        = 3
      #__BAR_ScrollStep        = 5
      #__BAR_ButtonSize        = 6
      #__BAR_Direction         = 7
      ; 
      #__BAR_Left       = #PB_ToolBar_Left
      #__BAR_Right      = #PB_ToolBar_Right
      #__BAR_Bottom     = #PB_ToolBar_Bottom
      ;
      #__FLAG_BarNormal     = #PB_ToolBar_Normal
      #__FLAG_BarSmall      = #PB_ToolBar_Small
      #__FLAG_BarLarge      = #PB_ToolBar_Large
      #__FLAG_BarInLineText = #PB_ToolBar_InlineText
      #__FLAG_BarText       = #PB_ToolBar_Text
      #__FLAG_BarButtons    = #PB_ToolBar_Buttons
      
     ;-\\ Image
      #__IMAGE_BackGround      = 1
      #__IMAGE_Pressed             = 2
      #__IMAGE_Released           = 3
     
      ;-\\ Pamel
      #__PANEL_Left            = #__FLAG_Left;1<<9
      #__PANEL_Top             = #__FLAG_Top ;1<<10
      #__PANEL_Right           = #__FLAG_Right;1<<11
      #__PANEL_Bottom          = #__FLAG_Bottom;1<<12
      
      ;-\\ Spin
      #__SPIN_Vertical         = #__FLAG_Vertical
      #__SPIN_Left             = 1<<1
      #__SPIN_Right            = 1<<2
      #__SPIN_Plus             = 1<<3
      #__SPIN_Mirror           = 1<<4
      
      
      
      ; Debug #PB_Checkbox_Unchecked ; 0
      ; Debug #PB_Checkbox_Checked   ; 1
      ; Debug #PB_Checkbox_Inbetween ; -1
      ; Debug #PB_CheckBox_threeState ; 4
      
      ;-\\ ListView
      
      
      ;     ; tree state
      ;     #__FLAG_Selected  = #PB_Tree_Selected   ; 1
      ;     #__FLAG_expanded  = #PB_Tree_Expanded   ; 2 ; развернуто
      ;     #__FLAG_Checked   = #PB_Tree_Checked    ; 4
      ;     #__FLAG_Collapsed = #PB_Tree_Collapsed  ; 8 ; свернуто
      ;     #__FLAG_Inbetween = #PB_Tree_Inbetween  ; 16
      
      ;     Флаги для изменения поведения гаджета. Это может быть комбинация следующих значений:
      ;     #PB_Tree_AlwaysShowSelection : даже если гаджет не активирован, выделение остается видимым.
      ;     #PB_Tree_NoLines : скрыть маленькие линии между узлами.
      ;     #PB_Tree_NoButtons : скрыть кнопки узлов «+».
      ;     #PB_Tree_CheckBoxes : добавьте флажок перед каждым элементом.
      ;     #PB_Tree_ThreeState : Флажки могут иметь промежуточное состояние.
      ;     Флаг #PB_Tree_ThreeState можно использовать в сочетании с флагом #PB_Tree_CheckBoxes,
      ;     чтобы получить флажки, которые могут иметь состояние «включено», «выключено» и «промежуточное».
      ;     Пользователь может выбрать только состояния «включено» или «выключено».
      ;     Промежуточное состояние можно установить программно с помощью функции SetGadgetItemState().
      ;     ;
      
      ; LIST_ELEMENT
      ;         CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      ;           Debug #PB_ListView_MultiSelect  ; 1
      ;           Debug #PB_ListView_ClickSelect  ; 2
      ;
      ;           Debug #PB_Tree_AlwaysShowSelection ; 0
      ;           Debug #PB_Tree_NoLines    ; 1
      ;           Debug #PB_Tree_Selected   ; 1
      ;           Debug #PB_Tree_SubLevel   ; 1
      
      ;           Debug #PB_Tree_NoButtons  ; 2
      ;           Debug #PB_Tree_Expanded   ; 2
      
      ;           Debug #PB_Tree_CheckBoxes ; 4
      ;           Debug #PB_Tree_Checked    ; 4
      
      ;           Debug #PB_Tree_ThreeState ; 8
      ;           Debug #PB_Tree_Collapsed  ; 8
      ;           Debug #PB_Tree_Inbetween  ; 16
      ;
      ;           Debug #PB_ListIcon_AlwaysShowSelection ; 0
      ;           Debug #PB_ListIcon_Selected   ; 1
      ;           Debug #PB_ListIcon_Checked    ; 2
      ;
      ;           Debug #PB_ListIcon_CheckBoxes ; 2
      ;           Debug #PB_ListIcon_Inbetween  ; 4
      ;           Debug #PB_ListIcon_ThreeState ; 8
      ;         CompilerEndIf
      
      ;-\\ ListIcon
      ;     Флаги для изменения поведения гаджета. Это может быть комбинация следующих значений:
      ;     #PB_ListIcon_CheckBoxes : Отображать флажки в первом столбце.
      ;     #PB_ListIcon_ThreeState : Флажки могут иметь промежуточное состояние.
      ;     #PB_ListIcon_MultiSelect : включить множественный выбор.
      ;     #PB_ListIcon_GridLines : Отображение линий-разделителей между строками и столбцами (не поддерживается в Mac OSX).
      ;     #PB_ListIcon_HeaderDragDrop : порядок столбцов можно изменить с помощью перетаскивания.
      ;     #PB_ListIcon_FullRowSelect : выделение охватывает всю строку, а не первый столбец (только для Windows).
      ;     #PB_ListIcon_AlwaysShowSelection: выбор по-прежнему виден, даже если гаджет не активирован (только для Windows).
      ;     Флаг #PB_ListIcon_ThreeState можно использовать в сочетании с флагом #PB_ListIcon_CheckBoxes, чтобы получить флажки,
      ;     которые могут иметь состояние «включено», «выключено» и «промежуточное».
      ;     Пользователь может выбрать только состояния «включено» или «выключено».
      ;     Промежуточное состояние можно установить программно с помощью функции SetItemState( ).
      ;
      ; - GetAttribute() Со следующим атрибутом:
      ;     #PB_ListIcon_ColumnCount : 3     возвращает количество столбцов в гаджете.
      ;     #PB_ListIcon_DisplayMode : 2     возвращает текущий режим отображения гаджета (только для Windows)
      ; - SetAttribute() Со следующим атрибутом:
      ;     #PB_ListIcon_DisplayMode : Изменяет отображение гаджета (только для Windows).
      ;                                Это может быть одна из следующих констант (только для Windows):
      ;     #PB_ListIcon_LargeIcon : 0      Режим больших значков
      ;     #PB_ListIcon_SmallIcon : Режим малых значков
      ;     #PB_ListIcon_List      : Режим значка списка
      ;     #PB_ListIcon_Report    : Режим отчета (столбцы, режим по умолчанию)
      
      ;       ;-\\ Editor
      ;       ;#__EDITOR_Inline = #__FLAG_InLine
      ;       #__EDITOR_Readonly = #__FLAG_Readonly
      ;       #__EDITOR_wordwrap = #__FLAG_Textwordwrap
      ;       ;#__EDITOR_nomultiline   = #__FLAG_nolines
      ;       ;#__EDITOR_numeric       = #__FLAG_numeric | #__FLAG_TextMultiline
      ;       ;#__EDITOR_Fullselection = #__FLAG_Fullselection
      ;       ;#__EDITOR_gridlines     = #__FLAG_gridLines
      ;       ;#__EDITOR_Borderless    = #__FLAG_Borderless
      ;       
      ; ;       ;-\\ String
      ;       #__STRING_Right     = #__FLAG_TextRight
      ;       #__STRING_Center    = #__FLAG_TextCenter
      ;       #__STRING_numeric   = #__FLAG_Textnumeric
      ;       #__STRING_password  = #__FLAG_Textpassword
      ;       #__STRING_Readonly  = #__FLAG_TextReadonly
      ;       #__STRING_Uppercase = #__FLAG_TextUppercase
      ;       #__STRING_Lowercase = #__FLAG_TextLowercase
      ;       #__STRING_Multiline = #__FLAG_TextMultiline
      ;       ;#__STRING_Borderless = #__FLAG_Borderless
      
      
      ;       If (#__FLAG_Limit >> 1) > 2147483647 ; 8589934592
      ;          Debug "Исчерпан лимит в x32 (" + Str(#__FLAG_Limit >> 1) + ")"
      ;       EndIf
      
      ;- \\ Message
      #__MESSAGE_Cancel = #PB_MessageRequester_Cancel          
      #__MESSAGE_Info = #PB_MessageRequester_Info                  
      #__MESSAGE_Error = #PB_MessageRequester_Error               
      #__MESSAGE_Warning = #PB_MessageRequester_Warning
      #__MESSAGE_WindowCentered = #PB_MessageRequester_WindowCentered
      #__MESSAGE_ScreenCentered = #PB_MessageRequester_ScreenCentered
      ;
      #__MESSAGE_Ok = #PB_MessageRequester_Ok                                 
      #__MESSAGE_Yes = #PB_MessageRequester_Yes                             
      #__MESSAGE_No = #PB_MessageRequester_No                                
      #__MESSAGE_YesNo = #PB_MessageRequester_YesNo                     
      #__MESSAGE_YesNoCancel = #PB_MessageRequester_YesNoCancel 
      ;
      ;-\\ Attribute
      #__MODE_Display = 1<<13
      ;     #PB_Image      = 1<<13
      ;     #PB_text       = 1<<14
      ;     #PB_Flag       = 1<<15
      ;     #PB_State      = 1<<16
      
      
      EndDeclareModule : Module Constants : EndModule
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 585
; FirstLine = 561
; Folding = ----
; Optimizer
; EnableXP
; DPIAware