CompilerIf Not Defined(constants, #PB_Module)
   DeclareModule constants
      Macro BinaryFlag(_variable_, _Constant_, _State_ = #True)
         Bool(Bool(((_variable_) & _Constant_) = _Constant_) = _State_)
      EndMacro
      
      ;- - CONSTANTs
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
      #__bar_toggle_line_size = 2
      #__bar_splitter_size = 9
      #__ButtonRound  = 7
      #__bar_button_size   = 16
      
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
      
      ;-\\ Direction 
      #__left = 0
      #__top = 1
      #__right = 2
      #__bottom = 3
      
      #__sOC = SizeOf(Character)
      
      ;-\\ Anchors
      #__a_anchors_Size = 7
      
      ; a_Index( )
      #__a_Left         = 1
      #__a_top          = 2
      #__a_Right        = 3
      #__a_Bottom       = 4
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
      
      #__mouse_leave    = - 1    ;-1   leave
      #__mouse_enter    = 1 << 0 ; 1   enter
      #__mouse_left     = 1 << 1 ; 2   move to left
      #__mouse_top      = 1 << 2 ; 4   move to top
      #__mouse_right    = 1 << 3 ; 8   move to right
      #__mouse_bottom   = 1 << 4 ; 16  move to bottom
      #__mouse_press    = 1 << 5 ; 32  button press
      #__mouse_release  = 1 << 6 ; 64  button release
      #__mouse_update   = 1 << 7 ; 128 enter inner
      
      ; #__mouse_move     = 1 << 8 ; 256 enter frame
      ; #__mouse_wheel    = 1 << 9 ; 512 wheel
      
      
      
      
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
         ;#__event_Create
         #__event_Focus
         #__event_LostFocus
         ;
         #__event_MouseEnter
         #__event_MouseLeave
         #__event_MouseMove
         #__event_MouseWheel
         ;
         #__event_Down
         #__event_LeftDown
         #__event_MiddleDown
         #__event_RightDown
         ;
         #__event_Up
         #__event_LeftUp
         #__event_MiddleUp
         #__event_RightUp
         ;
         #__event_LeftClick
         #__event_Left2Click
         #__event_Left3Click
         #__event_RightClick
         #__event_Right2Click
         #__event_Right3Click
         ;
         #__event_Change
         #__event_CursorChange
         #__event_StatusChange
         #__event_ScrollChange
         ;
         #__event_KeyDown
         #__event_Input
         #__event_Return
         #__event_KeyUp
         ;
         #__event_DragStart
         #__event_Drop
         ;
         #__event_Draw
         ;
         #__event_ResizeBegin
         #__event_Resize
         #__event_ResizeEnd
         #__event_Maximize
         #__event_Minimize
         #__event_Restore
         ;
         #__event_Close
         #__event_Free
         #__event
      EndEnumeration
      
      
      ;     #__eventmask_Create       = 1<<#__event_Create
      ;     #__eventmask_enter        = 1<<#__event_MouseEnter
      ;     #__eventmask_Focus        = 1<<#__event_Focus
      ;     #__eventmask_Down         = 1<<#__event_Down
      ;     #__eventmask_MiddleDown   = 1<<#__event_MiddleDown
      ;     #__eventmask_LeftDown     = 1<<#__event_LeftDown
      ;     #__eventmask_RightDown    = 1<<#__event_RightDown
      ;     #__eventmask_Dragstart    = 1<<#__event_Dragstart
      ;     #__eventmask_Mousemove    = 1<<#__event_MouseMove
      ;     #__eventmask_wheel        = 1<<#__event_MouseWheel
      ;     #__eventmask_Leave        = 1<<#__event_MouseLeave
      ;     #__eventmask_Drop         = 1<<#__event_Drop
      ;     #__eventmask_Up           = 1<<#__event_Up
      ;     #__eventmask_MiddleUp     = 1<<#__event_MiddleUp
      ;     #__eventmask_LeftUp       = 1<<#__event_LeftUp
      ;     #__eventmask_RightUp      = 1<<#__event_RightUp
      ;     #__eventmask_LeftClick    = 1<<#__event_LeftClick
      ;     #__eventmask_RightClick   = 1<<#__event_RightClick
      ;     #__eventmask_Left2Click   = 1<<#__event_Left2Click
      ;     #__eventmask_Right2Click  = 1<<#__event_Right2Click
      ;     #__eventmask_Left3Click   = 1<<#__event_Left3Click
      ;     #__eventmask_Right3Click  = 1<<#__event_Right3Click
      ;     #__eventmask_Lostfocus    = 1<<#__event_LostFocus
      ;     #__eventmask_Change       = 1<<#__event_Change
      ;     #__eventmask_CursorChange = 1<<#__event_CursorChange
      ;     #__eventmask_StatusChange = 1<<#__event_StatusChange
      ;     #__eventmask_ScrollChange = 1<<#__event_ScrollChange
      ;     #__eventmask_KeyDown      = 1<<#__event_KeyDown
      ;     #__eventmask_Input        = 1<<#__event_Input
      ;     #__eventmask_Return       = 1<<#__event_Return
      ;     #__eventmask_KeyUp        = 1<<#__event_KeyUp
      ;     #__eventmask_Draw         = 1<<#__event_Draw
      ;     #__eventmask_Maximize     = 1<<#__event_Maximize
      ;     #__eventmask_Minimize     = 1<<#__event_Minimize
      ;     #__eventmask_Restore      = 1<<#__event_Restore
      ;     #__eventmask_Resizebegin  = 1<<#__event_ResizeBegin
      ;     #__eventmask_Resize       = 1<<#__event_Resize
      ;     #__eventmask_Resizeend    = 1<<#__event_ResizeEnd
      ;     #__eventmask_Close        = 1<<#__event_Close
      ;     #__eventmask_Free         = 1<<#__event_Free  ; Destroy
      
      ;
      ;-\\ create-type
      #__type_Root          = - 1
      #__type_Window        = - 2
      #__type_Message       = - 3
      #__type_PopupBar      = - 4
      #__type_MenuBar       = - 5
      #__type_ToolBar       = - 6
      #__type_TabBar        = - 7
      #__type_StatusBar     = - 8
      #__type_Properties    = - 9
      ;
      ; #__type_Toggled       = - 10
      ; #__type_ImageButton   = - 11
      ; #__type_StringButton  = - 12
      ; #__type_Hiasm         = - 13
      ;
      #__type_Unknown       = #PB_GadgetType_Unknown       ; 0
      #__type_Button        = #PB_GadgetType_Button        ; 1
      #__type_String        = #PB_GadgetType_String        ; 2
      #__type_Text          = #PB_GadgetType_Text          ; 3
      #__type_CheckBox      = #PB_GadgetType_CheckBox      ; 4
      #__type_Option        = #PB_GadgetType_Option        ; 5
      #__type_ListView      = #PB_GadgetType_ListView      ; 6
      #__type_Frame         = #PB_GadgetType_Frame         ; 7
      #__type_ComboBox      = #PB_GadgetType_ComboBox      ; 8
      #__type_Image         = #PB_GadgetType_Image         ; 9
      #__type_HyperLink     = #PB_GadgetType_HyperLink     ; 10
      #__type_Container     = #PB_GadgetType_Container     ; 11
      #__type_ListIcon      = #PB_GadgetType_ListIcon      ; 12
      #__type_IPAddress     = #PB_GadgetType_IPAddress     ; 13
      #__type_Progress      = #PB_GadgetType_ProgressBar   ; 14   ;
      #__type_Scroll        = #PB_GadgetType_ScrollBar     ; 15   ;
      #__type_ScrollArea    = #PB_GadgetType_ScrollArea    ; 16
      #__type_Track         = #PB_GadgetType_TrackBar      ; 17   ;
      #__type_Web           = #PB_GadgetType_Web           ; 18
      #__type_ButtonImage   = #PB_GadgetType_ButtonImage   ; 19
      #__type_Calendar      = #PB_GadgetType_Calendar      ; 20
      #__type_Date          = #PB_GadgetType_Date          ; 21
      #__type_Editor        = #PB_GadgetType_Editor        ; 22
      #__type_ExplorerList  = #PB_GadgetType_ExplorerList  ; 23
      #__type_ExplorerTree  = #PB_GadgetType_ExplorerTree  ; 24
      #__type_ExplorerCombo = #PB_GadgetType_ExplorerCombo ; 25
      #__type_Spin          = #PB_GadgetType_Spin          ; 26
      #__type_Tree          = #PB_GadgetType_Tree          ; 27
      #__type_Panel         = #PB_GadgetType_Panel         ; 28
      #__type_Splitter      = #PB_GadgetType_Splitter      ; 29
      #__type_MDI           = #PB_GadgetType_MDI           ; 30
      ;
      #__type_Scintilla     = #PB_GadgetType_Scintilla     ; 31
      #__type_Shortcut      = #PB_GadgetType_Shortcut      ; 32
      #__type_Canvas        = #PB_GadgetType_Canvas        ; 33
      #__type_OpenGL        = #PB_GadgetType_OpenGL        ; 34
      
      ;
      ;-\\ create-flags
      ; #__flag_ = 1<<0
      #__flag_button_Default   = 1<<0
      ; #__flag_ = 1<<1
      ; #__flag_ = 1<<2
      ; #__flag_ = 1<<3
      ; #__flag_ = 1<<4
      ; #__flag_ = 1<<5
      ; #__flag_ = 1<<6
      #__flag_Collapsed       = 1<<6
      #__flag_OptionBoxes     = 1<<7
      ; #__flag_ = 1<<8
      #__flag_CheckBoxes      = 1<<8 
      ; #__flag_ = 1<<9
      ; #__flag_ = 1<<10
      ; #__flag_ = 1<<11
      ; #__flag_ = 1<<12
      #__flag_ThreeState      = 1<<12 
      ; #__flag_ = 1<<13
      ; #__flag_ = 1<<14
      ; #__flag_ = 1<<15
      #__flag_RowClickSelect  = 1<<16   
      ; #__flag_ = 1<<17
      ; #__flag_ = 1<<18
      ; #__flag_ = 1<<19
      ; #__flag_ = 1<<20
      ; #__flag_ = 1<<21
      #__flag_RowMultiSelect  = 1<<21
      ; #__flag_ = 1<<22
      #__flag_RowFullSelect   = 1<<22
      ; #__flag_ = 1<<23
      ; #__flag_ = 1<<24
      ; #__flag_ = 1<<25
      #__flag_GridLines       = 1<<25
      #__flag_BorderRaised    = 1<<26
      #__flag_BorderDouble    = 1<<27
      ; #__flag_ = 1<<28
      #__flag_BorderSingle    = 1<<29  
      ; #__flag_ = 1<<30
      #__flag_Borderless      = 1<<31
      #__flag_BorderFlat      = 1<<32
      ;
      #__flag_Child           = 1<<33
      #__flag_Invert          = 1<<34
      #__flag_Vertical        = 1<<35
      #__flag_Transparent     = 1<<36
      ;
      #__flag_NoFocus         = 1<<37
      #__flag_NoLines         = 1<<38 ; 50 BUG
      #__flag_NoButtons       = 1<<39 ; 50 BUG
      #__flag_NoGadgets       = 1<<40
      #__flag_NoScrollBars    = 1<<41
      ;
      #__flag_TextPassword    = 1<<42
      #__flag_TextWordWrap    = 1<<43
      #__flag_TextMultiLine   = 1<<44
      #__flag_TextInLine      = 1<<45
      #__flag_TextNumeric     = 1<<46
      #__flag_TextReadonly    = 1<<47
      #__flag_TextLowerCase   = 1<<48
      #__flag_TextUpperCase   = 1<<49
      ;
      ; #__flag_Modal         = 1<<50
      ; #__flag_AllEvents     = 1<<51
      ; #__flag_              = 1<<52
      
      ;- \\ align-flag
      #__align_top            = 1<<53
      #__align_Bottom         = 1<<54
      #__align_Left           = 1<<55
      #__align_Right          = 1<<56
      #__align_Center         = 1<<57 
      #__align_auto           = 1<<58
      ;
      #__align_Full           = 1<<59
      #__align_proportional   = 1<<60
      #__align_text           = 1<<61
      #__align_image          = 1<<62
      #__align_none           = 0
      ; #__flag_Limit         = 1<<63
      ;
      
      #__flag_Left             = #__align_Left
      #__flag_Top              = #__align_Top
      #__flag_Right            = #__align_Right
      #__flag_Bottom           = #__align_Bottom
      #__flag_Center           = #__align_Center
      #__flag_AutoSize         = #__align_Auto
      ;
      
;       ;
;       #__window_Normal         = #PB_Window_Normal
;       #__window_Maximize       = #PB_Window_Maximize       ; Opens the window maximized. (Note ; on Linux, Not all Windowmanagers sUpport this)
;       #__window_Minimize       = #PB_Window_Minimize       ; Opens the window minimized.
;       #__window_SystemMenu     = #PB_Window_SystemMenu     ; Enables the system menu on the window title bar (Default).
;       #__window_MinimizeGadget = #PB_Window_MinimizeGadget ; Adds the minimize gadget To the window title bar. #PB_window_SystemMenu is automatically added.
;       #__window_MaximizeGadget = #PB_Window_MaximizeGadget ; Adds the maximize gadget To the window title bar. #PB_window_SystemMenu is automatically added.
;       #__window_SizeGadget     = #PB_Window_SizeGadget     ; Adds the sizeable feature To a window.
;       #__window_Invisible      = #PB_Window_Invisible      ; Creates the window but don't display.
;       #__window_TitleBar       = #PB_Window_TitleBar       ; Creates a window with a titlebar.
;       #__window_Tool           = #PB_Window_Tool           ; Creates a window with a smaller titlebar And no taskbar entry.
;       #__window_BorderLess     = #PB_Window_BorderLess        ; Creates a window without any borders.
;       #__window_ScreenCentered = #PB_Window_ScreenCentered ; Centers the window in the middle of the screen. x,y parameters are ignored.
;       #__window_WindowCentered = #PB_Window_WindowCentered ; Centers the window in the middle of the parent window ('ParentWindowID' must be specified). x,y parameters are ignored.
;       #__window_NoGadgets      = #PB_Window_NoButtons         ; Prevents the creation of a GadgetList. UseGadgetList() can be used To do this later.
;       #__window_NoActivate     = #PB_Window_NoActivate     ; Don't activate the window after opening.
      
      ;
      ;-\\ Window
      #__window_FrameSize      = 4
      #__window_CaptionHeight  = 24
     
      ;-\\ Text
      #__flag_TextInvert       = #__align_text|#__flag_Invert
      #__flag_TextVertical     = #__align_text|#__flag_Vertical
      ;  alignment
      #__flag_TextLeft         = #__align_text|#__align_Left
      #__flag_TextTop          = #__align_text|#__align_Top
      #__flag_TextRight        = #__align_text|#__align_Right
      #__flag_TextBottom       = #__align_text|#__align_Bottom
      #__flag_TextCenter       = #__align_text|#__align_Center
      
      ;-\\ Image
      #__image_BackGround      = 1
      #__image_Pressed         = 2
      #__image_Released        = 3
      ;  alignment
      #__flag_ImageLeft        = #__align_image|#__align_Left
      #__flag_ImageTop         = #__align_image|#__align_top
      #__flag_ImageRight       = #__align_image|#__align_Right
      #__flag_ImageBottom      = #__align_image|#__align_Bottom
      #__flag_ImageCenter      = #__align_image|#__align_Center
      
     ;-
      ;-\\ Bar
      ; attribute
      #__bar_Minimum           = 1
      #__bar_Maximum           = 2
      #__bar_PageLength        = 3
      #__bar_ScrollStep        = 5
      #__bar_ButtonSize        = 6
      #__bar_Direction         = 7
      #__bar_Invert            = #__flag_invert
      
      ;-\\ Tree
      #__flag_property         = 1<<50
      
      ;-\\ Spin
      #__spin_Vertical         = #__Flag_Vertical
      #__spin_Left             = 1<<1
      #__spin_Right            = 1<<2
      #__spin_Plus             = 1<<3
      #__spin_Mirror           = 1<<4
      
      
      
      ; Debug #PB_Checkbox_Unchecked ; 0
      ; Debug #PB_Checkbox_Checked   ; 1
      ; Debug #PB_Checkbox_Inbetween ; -1
      ; Debug #PB_CheckBox_threeState ; 4
      
      ;-\\ ListView
      
      
      ;     ; tree state
      ;     #__flag_Selected  = #PB_Tree_Selected   ; 1
      ;     #__flag_expanded  = #PB_Tree_Expanded   ; 2 ; развернуто
      ;     #__flag_Checked   = #PB_Tree_Checked    ; 4
      ;     #__flag_Collapsed = #PB_Tree_Collapsed  ; 8 ; свернуто
      ;     #__flag_Inbetween = #PB_Tree_Inbetween  ; 16
      
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
      ;       ;#__editor_Inline = #__flag_InLine
      ;       #__editor_Readonly = #__flag_Readonly
      ;       #__editor_wordwrap = #__flag_Textwordwrap
      ;       ;#__editor_nomultiline   = #__flag_nolines
      ;       ;#__editor_numeric       = #__flag_numeric | #__flag_TextMultiline
      ;       ;#__editor_Fullselection = #__flag_Fullselection
      ;       ;#__editor_gridlines     = #__flag_gridLines
      ;       ;#__editor_Borderless    = #__flag_Borderless
      ;       
      ; ;       ;-\\ String
      ;       #__string_Right     = #__flag_TextRight
      ;       #__string_Center    = #__flag_TextCenter
      ;       #__string_numeric   = #__flag_Textnumeric
      ;       #__string_password  = #__flag_Textpassword
      ;       #__string_Readonly  = #__flag_TextReadonly
      ;       #__string_Uppercase = #__flag_TextUppercase
      ;       #__string_Lowercase = #__flag_TextLowercase
      ;       #__string_Multiline = #__flag_TextMultiline
      ;       ;#__string_Borderless = #__flag_Borderless
      
      
      ;       If (#__flag_Limit >> 1) > 2147483647 ; 8589934592
      ;          Debug "Исчерпан лимит в x32 (" + Str(#__flag_Limit >> 1) + ")"
      ;       EndIf
      
      ;- \\ ToolBar
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
         #PB_ToolBar_Large = 1<<1;??? 2
      CompilerEndIf
      CompilerIf Not Defined(PB_ToolBar_Text, #PB_Constant)
         #PB_ToolBar_Text = 1<<2;??? 4
      CompilerEndIf
      CompilerIf Not Defined(PB_ToolBar_InlineText, #PB_Constant)
         #PB_ToolBar_InlineText = 1<<3;??? 8
      CompilerEndIf
      
      #PB_ToolBar_Buttons = 1<<4
      #PB_ToolBar_Left    = 1<<5
      #PB_ToolBar_Right   = 1<<6
      #PB_ToolBar_Bottom  = 1<<7
      
      ;       Debug #PB_ToolBar_Small
      ;       Debug #PB_ToolBar_Large
      ;       Debug #PB_ToolBar_Text ; Text will be displayed below the button
      ;       Debug #PB_ToolBar_InlineText
      ;       Debug #PB_ToolBar_Buttons
      ;       ;
      ;       Debug ""
      ;       Debug #PB_ToolBar_Normal
      ;       Debug #PB_ToolBar_Toggle
      
      #__flag_BarNormal     = #PB_ToolBar_Normal
      #__flag_BarSmall      = #PB_ToolBar_Small
      #__flag_BarLarge      = #PB_ToolBar_Large
      #__flag_BarText       = #PB_ToolBar_Text
      #__flag_BarInLineText = #PB_ToolBar_InlineText
      #__flag_BarButtons    = #PB_ToolBar_Buttons
      #__flag_BarLeft       = #PB_ToolBar_Left
      #__flag_BarRight      = #PB_ToolBar_Right
      #__flag_BarBottom     = #PB_ToolBar_Bottom
      
      
      
      
      ;- \\ Message
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
      
      #__Message_Cancel = #PB_MessageRequester_Cancel           ; 2
      #__Message_Info = #PB_MessageRequester_Info               ; 4
      #__Message_Error = #PB_MessageRequester_Error             ; 8
      #__Message_Warning = 32                                   ;#PB_MessageRequester_Warning
      #__Message_ScreenCentered = 256                           ;#PB_Window_ScreenCentered ; 64
                                                                ;#__Message_WindowCentered = #PB_Window_WindowCentered ; 256
      
      #__Message_Ok = #PB_MessageRequester_Ok                   ; 0
      #__Message_YesNo = #PB_MessageRequester_YesNo             ; 1
      #__Message_YesNoCancel = #PB_MessageRequester_YesNoCancel ; 2
      #__Message_Yes = #PB_MessageRequester_Yes                 ; 6
      #__Message_No = #PB_MessageRequester_No                   ; 7
      
      ;-\\ Attribute
      #__DisplayMode = 1<<13
      ;     #PB_Image      = 1<<13
      ;     #PB_text       = 1<<14
      ;     #PB_Flag       = 1<<15
      ;     #PB_State      = 1<<16
      
      
   EndDeclareModule
   Module Constants
   EndModule
   
   ;UseModule Constants
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 32
; FirstLine = 24
; Folding = ----
; Optimizer
; EnableXP
; DPIAware