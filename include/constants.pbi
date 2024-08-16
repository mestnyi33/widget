CompilerIf Not Defined(constants, #PB_Module)
   DeclareModule constants
      Macro _check_(_variable_, _constant_, _state_ = #True)
         Bool(_state_ = Bool(((_variable_) & _constant_) = _constant_))
      EndMacro
      
      ;- - CONSTANTs
      CompilerIf Not Defined(PB_canvas_container, #PB_Constant)
         #PB_Canvas_Container = 1 << 5
      CompilerEndIf
      
      
      
      ;-\\ DD
      ;#PB_Drag_Resize = - 1; #PB_Drag_Move
      
      ;{
      
      Enumeration - 1
         #SelectionStyle_Default
         #SelectionStyle_none
         #SelectionStyle_solid
         #SelectionStyle_Dotted
         #SelectionStyle_Dashed
      EndEnumeration
      #SelectionStyle_mode       = $100
      #SelectionStyle_completely = 0
      #SelectionStyle_partially  = $100
      #SelectionStyle_ignore     = #PB_Ignore
      
      Enumeration 1
         #Boundary_minX
         #Boundary_minY
         #Boundary_maxX
         #Boundary_maxY
         #Boundary_minWidth
         #Boundary_minHeight
         #Boundary_maxWidth
         #Boundary_maxHeight
      EndEnumeration
      #Boundary_ignore         = - $80000000    ; 0b10000000...
      #Boundary_Default        = - $7FFFFFFF    ; 0b01111111...
      #Boundary_none           = $3FFFFFFF      ; 0b00111111...
      #Boundary_parentSize     = $60000000      ; 0b01100000...
      #Boundary_parentSizeMask = $C0000000      ; 0b11000000...
      
      
      ;
      ;\\ default values
      ;
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
         #__splitter_buttonsize = 9
      CompilerEndIf
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
         #__splitter_buttonsize = 9;4
      CompilerEndIf
      CompilerIf #PB_Compiler_OS = #PB_OS_Linux
         #__splitter_buttonsize = 9;4;4
      CompilerEndIf
      
      
      #__panel_height = 24 ;+ 4
      #__panel_width  = 85
      
      #__menu_height = 25
      
      #__scroll_border = 2
      #__scroll_buttonsize = 16
      
      #__arrow_type = 1 ; ;-1 ;0 ;1
      #__arrow_size = 4 ;
      
      #__sOC = SizeOf(Character)
      
      ;-\\ edit errors
      Enumeration 1
         #__error_text_input
         #__error_text_back
         #__error_text_return
      EndEnumeration
      
      ;-\\ edit selection
      #__sel_to_line   = 1
      #__sel_to_first  = 2
      #__sel_to_remove = - 1
      #__sel_to_last   = - 2
      #__sel_to_set    = 5
      
      ;-\\ Coordinate (pos & size)
      Enumeration _c_coordinate
         #__c_screen    = 0 ; screen
         #__c_frame     = 1 ; frame screen
         #__c_inner     = 2 ; inner screen
         #__c_container = 3 ; container
         #__c_required  = 4 ; required
         #__c_window    = 5 ; window
         #__c_draw      = 6 ; clip screen
         #__c_draw1     = 7 ; clip frame
         #__c_draw2     = 8 ; clip inner
         #__c_restore   = 9
         #__c
      EndEnumeration
      
      ;-\\ Color
      Enumeration 1
         #__color_front
         #__color_back
         #__color_line
         #__color_titlefront
         #__color_titleback
         #__color_graytext
         #__color_frame
         #__color_fore
      EndEnumeration
      
      ;-\\ Color (state)
      Enumeration
         #__s_0
         #__s_1
         #__s_2
         #__s_3
      EndEnumeration
      
      ;-\\ Attribute
      #__displayMode = 1 << 13
      ;   #PB_image = 1<<13
      ;   #PB_text = 1<<14
      ;   #PB_flag = 1<<15
      ;   #PB_state = 1<<16
      
      ;-\\ resize-state
      EnumerationBinary
         #__resize_restore
         #__resize_minimize
         #__resize_maximize
      EndEnumeration
      
      ;-\\ create-flags
      EnumerationBinary 1<<18 
         ; text
         #__flag_textnumeric
         #__flag_textreadonly
         #__flag_textlowercase
         #__flag_textuppercase
         #__flag_textpassword
         #__flag_textwordwrap
         #__flag_textmultiline
         ;
         #__flag_textleft
         #__flag_texttop
         #__flag_textright
         #__flag_textbottom
         #__flag_textcenter
         #__flag_textinline
         
         
         ; list
         #__flag_fullselection
         #__flag_nolines
         #__flag_nobuttons
         #__flag_checkboxes
         #__flag_gridlines
         #__flag_threeState
         #__flag_clickselect
         #__flag_multiselect
         
         
         ; element
         #__flag_child
         #__flag_invert
         #__flag_vertical
         ;#__flag_transparent
         ;#__flag_invisible
         #__flag_noscrollbars
         #__flag_autoSize
         
         ;frame
         #__flag_borderless
         #__flag_borderflat
         #__flag_bordersingle
         #__flag_borderraised
         #__flag_borderdouble
         ;#__flag_sizegadget
         #__flag_anchorsgadget
         
         #__flag_limit
      EndEnumeration
      
      ;\\
      #__flag_nogadgets = #__flag_nobuttons
      #__flag_numeric = #__flag_textnumeric
      #__flag_wordwrap = #__flag_textwordwrap
      #__flag_readonly = #__flag_textreadonly
      #__flag_lowercase = #__flag_textlowercase
      #__flag_uppercase = #__flag_textuppercase
      #__flag_password = #__flag_textpassword
      #__flag_center = #__flag_textcenter
      #__flag_multiline = #__flag_textmultiline
      
      ;     #__flag_autoright  = #__flag_autosize | #__flag_right
      ;     #__flag_autobottom = #__flag_autosize | #__flag_bottom
      
      ;- \\ align-ment
      #__align_none         = 0
      #__align_left         = 1 << 1 
      #__align_top          = 1 << 2 
      #__align_right        = 1 << 3 
      #__align_bottom       = 1 << 4 
      #__align_center       = 1 << 5 
      #__align_proportional = 1 << 6
      #__align_full         = 1 << 7
      #__align_auto         = 1 << 8 ; #__flag_autoSize
      
      ;-
      ;-\\ Bar
      #__bar_minus      = 1
      #__bar_minimum    = 1
      #__bar_maximum    = 2
      #__bar_pagelength = 3
      #__bar_scrollstep = 5
      ;
      ;\\ binary
      #__bar_buttonsize = 8
      #__bar_direction  = 16
      #__bar_invert     = #__flag_invert
      #__bar_vertical   = #__flag_vertical
      #__bar_nobuttons  = #__flag_nogadgets
      ;
      #__bar_horizontal = 2
      
      
      ;-\\ Text
      #__text_invert    = #__flag_invert
      #__text_vertical  = #__flag_vertical
      ;
      #__text_left      = #__flag_textleft
      #__text_top       = #__flag_texttop
      #__text_right     = #__flag_textright
      #__text_bottom    = #__flag_textbottom
      #__text_center    = #__flag_textcenter
      ;
      #__text_multiline = #__flag_textmultiline
      #__text_wordwrap  = #__flag_textwordwrap
      #__text_numeric   = #__flag_textnumeric
      #__text_password  = #__flag_textpassword
      #__text_readonly  = #__flag_textreadonly
      #__text_lowercase = #__flag_textlowercase
      #__text_uppercase = #__flag_textuppercase
      
      
      
      
      ;-\\ Image
      #__image_released   = 1
      #__image_pressed    = 2
      #__image_background = 3
      #__image_left       = #__flag_textleft
      #__image_top        = #__flag_texttop
      #__image_center     = #__flag_textcenter
      #__image_right      = #__flag_textright
      #__image_bottom     = #__flag_textbottom
      
      ;-\\ MDI
      #__mdi_editable = #__flag_anchorsgadget ; win - 4294967296
      
      ;-\\ Window
      ; caption bar buttons
      #__wb_close = 1
      #__wb_maxi  = 2
      #__wb_mini  = 3
      #__wb_help  = 4
      
      #__window_frame_size     = 4
      #__window_caption_height = 24
      ;     #__window_nogadgets = #__flag_nogadgets
      ;     #__window_borderless = #__flag_borderless
      ;     #__window_systemmenu = #__flag_systemmenu
      ;     #__window_sizegadget = #__flag_sizegadget
      ;     #__window_screencentered = #__align_center
      
;       #__window_normal         = #PB_Window_Normal
;       #__window_maximize       = #PB_Window_Maximize       ; Opens the window maximized. (Note ; on Linux, Not all Windowmanagers support this)
;       #__window_minimize       = #PB_Window_Minimize       ; Opens the window minimized.
      
      #__window_child          = #__flag_child
      #__window_systemMenu     = #PB_Window_SystemMenu     ; Enables the system menu on the window title bar (Default).
      
      #__window_minimizeGadget = #PB_Window_MinimizeGadget ; Adds the minimize gadget To the window title bar. #PB_window_systemMenu is automatically added.
      #__window_maximizeGadget = #PB_Window_MaximizeGadget ; Adds the maximize gadget To the window title bar. #PB_window_systemMenu is automatically added.
                                                           ; (MacOS only ; #PB_window_sizeGadget will be also automatically added).
      #__window_sizeGadget     = #PB_Window_SizeGadget     ; Adds the sizeable feature To a window.
      #__window_invisible      = #PB_Window_Invisible      ; Creates the window but don't display.
      #__window_titleBar       = #PB_Window_TitleBar       ; Creates a window with a titlebar.
      #__window_tool           = #PB_Window_Tool           ; Creates a window with a smaller titlebar And no taskbar entry.
      #__window_borderLess     = #PB_Window_BorderLess     ; Creates a window without any borders.
      #__window_screenCentered = #PB_Window_ScreenCentered ; Centers the window in the middle of the screen. x,y parameters are ignored.
      #__window_windowCentered = #PB_Window_WindowCentered ; Centers the window in the middle of the parent window ('ParentWindowID' must be specified). x,y parameters are ignored.
      #__window_noGadgets      = #PB_Window_NoGadgets      ; Prevents the creation of a GadgetList. UseGadgetList() can be used To do this later.
      #__window_noActivate     = #PB_Window_NoActivate     ; Don't activate the window after opening.
                                                           ;     #__window_closeGadget    = #PB_window_noActivate<<2
                                                           ;     #__window_close          = #PB_window_noActivate<<2
                                                           ;#PB_window                 = #PB_window_noActivate<<2
      
      ;-\\  Spin
      #__spin_barsize  = #__scroll_buttonsize + 5
      #__spin_vertical = #__bar_vertical
      #__spin_left     = 1 << 1
      #__spin_right    = 1 << 2
      #__spin_plus     = 1 << 3
      
      ;     ;-
      ; Debug #PB_checkbox_Unchecked ; 0
      ; Debug #PB_checkbox_checked   ; 1
      ; Debug #PB_checkbox_inbetween ; -1
      ; Debug #PB_checkBox_threeState ; 4
      
      ;-\\ ListView
      ; list mode
      #__m_checkselect  = 1
      #__m_clickselect  = 2
      #__m_multiselect  = 3
      #__m_optionselect = 4
      
      ;-\\ Tree
      #__tree_nolines     = #__flag_nolines
      #__tree_nobuttons   = #__flag_nogadgets
      #__tree_checkboxes  = #__flag_checkboxes
      #__tree_threestate  = #__flag_threeState
      #__tree_collapse    = 32
      #__tree_optionboxes = 64
      
      #__tree_property = #__flag_numeric
      #__tree_listview = #__flag_readonly
      #__tree_toolbar  = #__flag_password
      
      
      ;     ; tree state
      ;     #__tree_selected  = #PB_Tree_Selected   ; 1
      ;     #__tree_expanded  = #PB_Tree_Expanded   ; 2 ; развернуто
      ;     #__tree_checked   = #PB_Tree_Checked    ; 4
      ;     #__tree_collapsed = #PB_Tree_Collapsed  ; 8 ; свернуто
      ;     #__tree_inbetween = #PB_Tree_Inbetween  ; 16
      
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
      ;       ;#__editor_inline = #__flag_inLine
      ;       #__editor_readonly = #__flag_readonly
      ;       #__editor_wordwrap = #__flag_textwordwrap
      ;       ;#__editor_nomultiline   = #__flag_nolines
      ;       ;#__editor_numeric       = #__flag_numeric | #__text_multiline
      ;       ;#__editor_fullselection = #__flag_fullselection
      ;       ;#__editor_gridlines     = #__flag_gridLines
      ;       ;#__editor_borderless    = #__flag_borderless
      ;       
      ; ;       ;-\\ String
      ;       #__string_right     = #__text_right
      ;       #__string_center    = #__text_center
      ;       #__string_numeric   = #__text_numeric
      ;       #__string_password  = #__text_password
      ;       #__string_readonly  = #__text_readonly
      ;       #__string_uppercase = #__text_uppercase
      ;       #__string_lowercase = #__text_lowercase
      ;       #__string_multiline = #__text_multiline
      ;       ;#__string_borderless = #__flag_borderless
      
      ;-\\ Button
      #__button_toggle    = #PB_Button_Toggle
      #__button_default   = #PB_Button_Default
      #__button_multiline = #PB_Button_MultiLine
      #__button_left      = #__flag_textleft
      #__button_right     = #__flag_textright
      #__button_vertical  = #__flag_vertical
      #__button_invert    = #__flag_invert
      
      
      ;       If (#__flag_limit >> 1) > 2147483647 ; 8589934592
      ;          Debug "Исчерпан лимит в x32 (" + Str(#__flag_limit >> 1) + ")"
      ;       EndIf
      
      
      ;-\\ event-type
      CompilerIf Not Defined(PB_EventType_resize, #PB_Constant)
         #PB_EventType_Resize = 6
      CompilerEndIf
      CompilerIf Not Defined(PB_EventType_ReturnKey, #PB_Constant)
         #PB_EventType_ReturnKey = 7
      CompilerEndIf
      Enumeration #PB_EventType_FirstCustomValue
         #PB_EventType_Drop
         #PB_EventType_Repaint
         #PB_EventType_MouseWheelX
         #PB_EventType_MouseWheelY
      EndEnumeration
      
      
      Enumeration 1
         #__event_create
         #__event_enter
         #__event_focus
         #__event_down
         #__event_middledown
         #__event_leftdown
         #__event_rightdown
         #__event_dragstart
         #__event_mousemove
         #__event_wheel
         #__event_wheelx
         #__event_wheely
         #__event_leave
         #__event_drop
         #__event_up
         #__event_middleup
         #__event_leftup
         #__event_rightup
         #__event_leftclick
         #__event_rightclick
         #__event_left2click
         #__event_right2click
         #__event_left3click
         #__event_right3click
         #__event_lostfocus
         #__event_resizebegin
         #__event_resize
         #__event_resizeend
         #__event_change
         #__event_statuschange
         #__event_scrollchange
         #__event_cursor
         #__event_keydown
         #__event_input
         #__event_return
         #__event_keyup
         #__event_draw
         #__event_repaint
         #__event_maximize
         #__event_minimize
         #__event_restore
         #__event_close
         
         ;          #__event_titlechange ;
         ;          #__event_closeItem
         ;          #__event_sizeitem
         
         #__event_free
         #__event_count
      EndEnumeration
      
      EnumerationBinary
         #__eventmask_create       = 1 << #__event_create
         #__eventmask_enter        = 1 << #__event_enter
         #__eventmask_focus        = 1 << #__event_focus
         #__eventmask_down         = 1 << #__event_down
         #__eventmask_middledown   = 1 << #__event_middledown
         #__eventmask_leftdown     = 1 << #__event_leftdown
         #__eventmask_rightdown    = 1 << #__event_rightdown
         #__eventmask_dragstart    = 1 << #__event_dragstart
         #__eventmask_mousemove    = 1 << #__event_mousemove
         #__eventmask_wheel        = 1 << #__event_wheel
         #__eventmask_wheelx       = 1 << #__event_wheelx
         #__eventmask_wheely       = 1 << #__event_wheely
         #__eventmask_leave        = 1 << #__event_leave
         #__eventmask_drop         = 1 << #__event_drop
         #__eventmask_up           = 1 << #__event_up
         #__eventmask_middleup     = 1 << #__event_middleup
         #__eventmask_leftup       = 1 << #__event_leftup
         #__eventmask_rightup      = 1 << #__event_rightup
         #__eventmask_leftclick    = 1 << #__event_leftclick
         #__eventmask_rightclick   = 1 << #__event_rightclick
         #__eventmask_left2click   = 1 << #__event_left2click
         #__eventmask_right2click  = 1 << #__event_right2click
         #__eventmask_left3click   = 1 << #__event_left3click
         #__eventmask_right3click  = 1 << #__event_right3click
         #__eventmask_lostfocus    = 1 << #__event_lostfocus
         #__eventmask_resizebegin  = 1 << #__event_resizebegin
         #__eventmask_resize       = 1 << #__event_resize
         #__eventmask_resizeend    = 1 << #__event_resizeend
         #__eventmask_change       = 1 << #__event_change
         #__eventmask_statuschange = 1 << #__event_statuschange
         #__eventmask_scrollchange = 1 << #__event_scrollchange
         #__eventmask_cursorchange = 1 << #__event_cursor
         #__eventmask_keydown      = 1 << #__event_keydown
         #__eventmask_input        = 1 << #__event_input
         #__eventmask_return       = 1 << #__event_return
         #__eventmask_keyup        = 1 << #__event_keyup
         #__eventmask_draw         = 1 << #__event_draw
         #__eventmask_repaint      = 1 << #__event_repaint
         #__eventmask_maximize     = 1 << #__event_maximize
         #__eventmask_minimize     = 1 << #__event_minimize
         #__eventmask_restore      = 1 << #__event_restore
         #__eventmask_close        = 1 << #__event_close
         #__eventmask_free         = 1 << #__event_free  ; Destroy
      EndEnumeration
      
      ; TEMP
      #__event_mouseenter  = #__event_enter
      #__event_mouseleave  = #__event_leave
      #__event_mousewheel  = #__event_wheel
      #__event_mousewheelX = #__event_wheelx
      #__event_mousewheely = #__event_wheely
      ;
      #__event_leftbuttondown   = #__event_leftdown
      #__event_middlebuttondown = #__event_middledown
      #__event_rightbuttondown  = #__event_rightdown
      #__event_leftbuttonup     = #__event_leftup
      #__event_middlebuttonup   = #__event_middleup
      #__event_rightbuttonup    = #__event_rightup
      #__event_leftdoubleclick  = #__event_left2click
      #__event_rightdoubleclick = #__event_right2click
      ;
      #__event_returnkey    = #__event_return
      ;
      ;       #__event_maximizewindow = #__event_maximize
      ;       #__event_minimizewindow = #__event_minimize
      ;       #__event_restorewindow = #__event_restore
      ;       #__event_closewindow = #__event_close
      
      ;-\\ create-type
      Enumeration - 1
         #__type_all
         #__type_Unknown       = #PB_GadgetType_Unknown       ; 0
         #__type_button        = #PB_GadgetType_Button        ; 1
         #__type_string        = #PB_GadgetType_String        ; 2
         #__type_text          = #PB_GadgetType_Text          ; 3
         #__type_checkBox      = #PB_GadgetType_CheckBox      ; 4
         #__type_Option        = #PB_GadgetType_Option        ; 5
         #__type_listView      = #PB_GadgetType_ListView      ; 6
         #__type_frame         = #PB_GadgetType_Frame         ; 7
         #__type_comboBox      = #PB_GadgetType_ComboBox      ; 8
         #__type_image         = #PB_GadgetType_Image         ; 9
         #__type_HyperLink     = #PB_GadgetType_HyperLink     ; 10
         #__type_container     = #PB_GadgetType_Container     ; 11
         #__type_listIcon      = #PB_GadgetType_ListIcon      ; 12
         #__type_iPAddress     = #PB_GadgetType_IPAddress     ; 13
         #__type_progressBar   = #PB_GadgetType_ProgressBar   ; 14
         #__type_scrollBar     = #PB_GadgetType_ScrollBar     ; 15
         #__type_scrollArea    = #PB_GadgetType_ScrollArea    ; 16
         #__type_trackBar      = #PB_GadgetType_TrackBar      ; 17
         #__type_web           = #PB_GadgetType_Web           ; 18
         #__type_buttonImage   = #PB_GadgetType_ButtonImage   ; 19
         #__type_calendar      = #PB_GadgetType_Calendar      ; 20
         #__type_Date          = #PB_GadgetType_Date          ; 21
         #__type_Editor        = #PB_GadgetType_Editor        ; 22
         #__type_ExplorerList  = #PB_GadgetType_ExplorerList  ; 23
         #__type_ExplorerTree  = #PB_GadgetType_ExplorerTree  ; 24
         #__type_ExplorerCombo = #PB_GadgetType_ExplorerCombo ; 25
         #__type_spin          = #PB_GadgetType_Spin          ; 26
         #__type_tree          = #PB_GadgetType_Tree          ; 27
         #__type_panel         = #PB_GadgetType_Panel         ; 28
         #__type_splitter      = #PB_GadgetType_Splitter      ; 29
         #__type_MDI           = #PB_GadgetType_MDI           ; 30
         #__type_scintilla     = #PB_GadgetType_Scintilla     ; 31
         #__type_shortcut      = #PB_GadgetType_Shortcut      ; 32
         #__type_canvas        = #PB_GadgetType_Canvas        ; 33
         #__type_OpenGL        = #PB_GadgetType_OpenGL        ; 34
         
         #__type_tabBar = 50
         #__type_toolBar
         #__type_statusBar
         
         #__type_toggled
         #__type_property
         #__type_imageButton
         #__type_stringButton
         
         #__type_menu
         #__type_popupMenu
         #__type_window
         #__type_message
         #__type_root
         
         #__type_Hiasm
      EndEnumeration
      
      ;}
      
      
      
      #__text_update = - 124
      
      
      
      ;-\\ Anchors
      #__a_anchors_size = 7
      
      ; a_index( )
      #__a_left         = 1
      #__a_top          = 2
      #__a_right        = 3
      #__a_bottom       = 4
      #__a_left_top     = 5
      #__a_right_top    = 6
      #__a_right_bottom = 7
      #__a_left_bottom  = 8
      #__a_moved        = 9
      
      ; a_selector( )
      #__a_line_left    = 0
      #__a_line_top     = 1
      #__a_line_right   = 2
      #__a_line_bottom  = 3
      
      ; a_set( ) flags
      EnumerationBinary 1
         #__a_position ; положение
         #__a_width    ; по ширине
         #__a_height   ; по высоте
         #__a_corner   ; по углам
         #__a_zoom     ; по растянутый
         #__a_nodraw
      EndEnumeration
      ;
      #__a_edge = #__a_width | #__a_height ; по крайам
      #__a_size = #__a_corner | #__a_edge
      #__a_full = #__a_position | #__a_size
      
      ;-
      ;- GLOBAL
      ;-
      ; ;
      ; ;   #PB_window_titleBar
      ; ;   #PB_window_borderLess
      ; ;   #PB_window_systemMenu
      ; ;   #PB_window_maximizeGadget
      ; ;   #PB_window_minimizeGadget
      ; ;   #PB_window_screenCentered
      ; ;   #PB_window_sizeGadget
      ; ;   #PB_window_windowCentered
      ; ;   #PB_window_tool
      ; ;   #PB_window_normal
      ; ;   #PB_window_minimize
      ; ;   #PB_window_maximize
      ; ;   #PB_window_invisible
      ; ;   #PB_window_noActivate
      ; ;   #PB_window_noGadgets
      ; ;
      ; ;   #PB_button_Default
      ; ;   #PB_button_toggle
      ; ;   #PB_button_left
      ; ;   #PB_button_center
      ; ;   #PB_button_right
      ; ;   #PB_button_multiLine
      ; ;
      ; ;   #PB_string_borderLess
      ; ;   #PB_string_numeric
      ; ;   #PB_string_password
      ; ;   #PB_string_readOnly
      ; ;   #PB_string_lowerCase
      ; ;   #PB_string_UpperCase
      ; ;
      ; ;   #PB_text_left
      ; ;   #PB_text_center
      ; ;   #PB_text_right
      ; ;   #PB_text_border
      ; ;
      ; ;   #PB_checkBox_right
      ; ;   #PB_checkBox_center
      ; ;   #PB_checkBox_threeState
      ; ;
      ; ;   #PB_listView_multiSelect
      ; ;   #PB_listView_clickSelect
      ; ;
      ; ;   #PB_frame_single
      ; ;   #PB_frame_Double
      ; ;   #PB_frame_flat
      ; ;
      ; ;   #PB_comboBox_Editable
      ; ;   #PB_comboBox_lowerCase
      ; ;   #PB_comboBox_UpperCase
      ; ;   #PB_comboBox_image
      ; ;
      ; ;   #PB_image_border
      ; ;   #PB_image_raised
      ; ;
      ; ;   #PB_HyperLink_Underline
      ; ;
      ; ;   #PB_listIcon_checkBoxes
      ; ;   #PB_listIcon_threeState
      ; ;   #PB_listIcon_multiSelect
      ; ;   #PB_listIcon_GridLines
      ; ;   #PB_listIcon_fullRowSelect
      ; ;   #PB_listIcon_HeaderDragDrop
      ; ;   #PB_listIcon_alwaysShowSelection
      ; ;
      ; ;   #PB_progressBar_smooth
      ; ;   #PB_progressBar_vertical
      ; ;
      ; ;   #PB_scrollBar_vertical
      ; ;
      ; ;   #PB_container_borderLess
      ; ;   #PB_container_flat
      ; ;   #PB_container_raised
      ; ;   #PB_container_single
      ; ;   #PB_container_Double
      ; ;
      ; ;   #PB_scrollArea_borderLess
      ; ;   #PB_scrollArea_flat
      ; ;   #PB_scrollArea_raised
      ; ;   #PB_scrollArea_single
      ; ;   #PB_scrollArea_center
      ; ;
      ; ;   #PB_trackBar_ticks
      ; ;   #PB_trackBar_vertical
      ; ;
      ; ;   #PB_calendar_borderless
      ; ;
      ; ;   #PB_Date_UpDown
      ; ;
      ; ;   #PB_Editor_readOnly
      ; ;   #PB_Editor_wordWrap
      ; ;
      ; ;   #PB_Explorer_borderLess
      ; ;   #PB_Explorer_alwaysShowSelection
      ; ;   #PB_Explorer_multiSelect
      ; ;   #PB_Explorer_GridLines
      ; ;   #PB_Explorer_HeaderDragDrop
      ; ;   #PB_Explorer_fullRowSelect
      ; ;   #PB_Explorer_noFiles
      ; ;   #PB_Explorer_noFolders
      ; ;   #PB_Explorer_noParentFolder
      ; ;   #PB_Explorer_noDirectoryChange
      ; ;   #PB_Explorer_noDriveRequester
      ; ;   #PB_Explorer_noSort
      ; ;   #PB_Explorer_noMyDocuments
      ; ;   #PB_Explorer_autoSort
      ; ;   #PB_Explorer_HiddenFiles
      ; ;
      ; ;   #PB_tree_alwaysShowSelection
      ; ;   #PB_tree_noLines
      ; ;   #PB_tree_noButtons
      ; ;   #PB_tree_checkBoxes
      ; ;   #PB_tree_threeState
      ; ;
      ; ;   #PB_splitter_vertical
      ; ;   #PB_splitter_separator
      ; ;   #PB_splitter_firstFixed
      ; ;   #PB_splitter_secondFixed
      ; ;
      ; ;   #PB_canvas_border
      ; ;   #PB_canvas_container
      ; ;   #PB_canvas_clipMouse
      ; ;   #PB_canvas_Keyboard
      ; ;   #PB_canvas_DrawFocus
      ; ;
      
      ;- \\ ToolBar
      CompilerIf Not Defined(PB_toolBar_small, #PB_Constant)
         #PB_ToolBar_Small = 1 << 0
      CompilerEndIf
      CompilerIf Not Defined(PB_ToolBar_Large, #PB_Constant)
         #PB_ToolBar_Large = 1 << 1;??? 2
      CompilerEndIf
      CompilerIf Not Defined(PB_ToolBar_Text, #PB_Constant)
         #PB_ToolBar_Text = 1 << 2;??? 4
      CompilerEndIf
      CompilerIf Not Defined(PB_ToolBar_InlineText, #PB_Constant)
         #PB_ToolBar_InlineText = 1 << 3;??? 8
      CompilerEndIf
;     
;      #PB_ToolBar_child
;       #PB_ToolBar_vertical
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




      
      ;- \\ Message
      CompilerIf Not Defined(PB_messageRequester_info, #PB_Constant)
         #PB_MessageRequester_Info = 1 << 2
      CompilerEndIf
      CompilerIf Not Defined(PB_messageRequester_Error, #PB_Constant)
         #PB_MessageRequester_Error = 1 << 3
      CompilerEndIf
      CompilerIf Not Defined(PB_messageRequester_warning, #PB_Constant)
         #PB_MessageRequester_Warning = 1 << 4
      CompilerEndIf
      CompilerIf Not Defined(PB_MessageRequester_Error, #PB_Constant)
         #PB_MessageRequester_Error = 1 << 5;  8
      CompilerEndIf
      
      #__message_Cancel = #PB_MessageRequester_Cancel           ; 2
      #__message_Info = #PB_MessageRequester_Info               ; 4
      #__message_Error = #PB_MessageRequester_Error             ; 8
      #__message_Warning = 32;#PB_MessageRequester_Warning
      #__message_ScreenCentered = 256;#PB_Window_ScreenCentered ; 64
      ;#__message_WindowCentered = #PB_Window_WindowCentered ; 256
      
      #__message_Ok = #PB_MessageRequester_Ok                   ; 0
      #__message_YesNo = #PB_MessageRequester_YesNo             ; 1
      #__message_YesNoCancel = #PB_MessageRequester_YesNoCancel ; 2
      #__message_Yes = #PB_MessageRequester_Yes                 ; 6
      #__message_No = #PB_MessageRequester_No                   ; 7
      
      
   EndDeclareModule
   Module Constants
   EndModule
   
   ;UseModule Constants
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 506
; FirstLine = 484
; Folding = ----
; EnableXP