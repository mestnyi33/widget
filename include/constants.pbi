CompilerIf Not Defined(constants, #PB_Module)
  DeclareModule constants
    Macro _check_(_variable_, _constant_, _state_ = #True)
      Bool(_state_ = Bool(((_variable_) & _constant_) = _constant_))
    EndMacro
    
    ;- - CONSTANTs
    ;{
    
    Enumeration
      #__action_create
      #__action_add_items
    EndEnumeration
    
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
    
    
    ; list mode
    #__m_checkselect  = 1
    #__m_clickselect  = 2
    #__m_multiselect  = 3
    #__m_optionselect = 4
    
    ;-\\ Anchors
    #__a_left         = 1
    #__a_right        = 3
    #__a_top          = 2
    #__a_bottom       = 4
    #__a_left_top     = 5
    #__a_left_bottom  = 8
    #__a_right_top    = 6
    #__a_right_bottom = 7
    ;
    #__a_line_left   = 10
    #__a_line_right  = 11
    #__a_line_top    = 12
    #__a_line_bottom = 13
    ; a_mode_
    EnumerationBinary 1
      #__a_position
      #__a_width
      #__a_height
      #__a_corner
    EndEnumeration
    #__a_edge = #__a_width | #__a_height
    #__a_full = #__a_position | #__a_corner | #__a_edge
    ;
    #__a_size  = 7
    #__a_moved = 9
    #__a_count = #__a_moved + 4
    
    ;
    ; default values
    ;
    #__window_frame_size     = 4
    #__window_caption_height = 24
    #__border_scroll         = 10
    
    #__panel_height = 24 ;+ 4
    #__panel_width  = 85
    
    #__menu_height = 25
    
    #__from_mouse_state = 0
    #__focus_state      = 1
    
    ;#__splitter_buttonsize = 9
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      #__splitter_buttonsize = 9
    CompilerEndIf
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      #__splitter_buttonsize = 9;4
    CompilerEndIf
    CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      #__splitter_buttonsize = 9;4;4
    CompilerEndIf
    #__scroll_buttonsize = 16
    
    #__arrow_type = 1 ; ;-1 ;0 ;1
    #__arrow_size = 4 ;
    
    #__sOC = SizeOf(Character)
    
    
    ; splitter
    #__split_0 = 0
    #__split_1 = 1
    #__split_2 = 2
    
    #__split_b1 = 1
    #__split_b2 = 2
    #__split_b3 = 3
    
    ;
    #__tab_1 = 1 ; entered item
    #__tab_2 = 2 ; selected item
    
    ;-\\ Errors editor
    Enumeration 1
      #__error_text_input
      #__error_text_back
      #__error_text_return
    EndEnumeration
    
    ;-\\  Constant edit selection
    #__sel_to_line   = 1
    #__sel_to_first  = 2
    #__sel_to_remove = - 1
    #__sel_to_last   = - 2
    #__sel_to_set    = 5
    
    ;-\\ Bar buttons
    Enumeration
      #__b_1 = 1
      #__b_2 = 2
      #__b_3 = 3
    EndEnumeration
    
    ;window bar buttons
    Enumeration
      #__wb_close
      #__wb_maxi
      #__wb_mini
      #__wb_help
    EndEnumeration
    
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
    
    ;-\\ Resize (state)
    EnumerationBinary
      #__resize_x
      #__resize_y
      #__resize_width
      #__resize_height
      
      #__resize_change
      
      #__resize_restore
      #__resize_minimize
      #__resize_maximize
      #__resize_start
    EndEnumeration
    
    ;-\\ Constant create-flags
    EnumerationBinary 4096 ; 2
      
      #__flag_numeric
      #__flag_readonly
      #__flag_lowercase
      #__flag_uppercase
      #__flag_password
      #__flag_wordwrap
      #__flag_multiline
      
      #__flag_fullselection
      #__flag_nolines
      #__flag_nobuttons
      #__flag_checkboxes
      #__flag_optionboxes
      #__flag_gridlines
      #__flag_threeState
      #__flag_clickselect
      
      ;#__flag_inline
      ;#__flag_invisible
      ;#__flag_sizegadget
      
      
      ;\\
      #__flag_child
      #__flag_invert
      #__flag_vertical
      
      ;\\
      #__flag_transparent
      #__flag_noscrollbars
      #__flag_anchorsgadget
      
      ;\\
      #__flag_borderless
      #__flag_flat
      #__flag_double
      #__flag_raised
      #__flag_single
      
      ;\\
      #__flag_left
      #__flag_top
      #__flag_right
      #__flag_bottom
      #__flag_center
      #__flag_full
      #__flag_autoSize
      #__flag_proportional
      
      #__flag_limit
    EndEnumeration
    
    ;\\
    #__flag_nogadgets = #__flag_nobuttons
    
    ;     #__flag_autoright  = #__flag_autosize | #__flag_right
    ;     #__flag_autobottom = #__flag_autosize | #__flag_bottom
    
    ;- _c_align
    ; align type
    #__align_widget = 1
    #__align_text   = 2
    #__align_image  = 3
    
    #__align_none   = 0
    #__align_left   = #__flag_left
    #__align_top    = #__flag_top
    #__align_right  = #__flag_right
    #__align_bottom = #__flag_bottom
    #__align_center = #__flag_center
    
    #__align_full         = #__flag_full
    #__align_auto         = #__flag_autoSize
    #__align_proportional = #__flag_proportional
    
    
    ;-
    ;-\\ Bar
    #__bar_minus      = 1
    #__bar_minimum    = 1
    #__bar_maximum    = 2
    #__bar_pagelength = 3
    #__bar_scrollstep = 5
    
    ;\\ binary
    #__bar_buttonsize = 8
    #__bar_direction  = 16
    #__bar_invert     = #__flag_invert
    #__bar_vertical   = #__flag_vertical
    #__bar_nobuttons  = #__flag_nogadgets
    
    
    ;-\\ Text
    #__text_left      = #__flag_left
    #__text_top       = #__flag_top
    #__text_right     = #__flag_right
    #__text_bottom    = #__flag_bottom
    #__text_center    = #__flag_center
    #__text_invert    = #__flag_invert
    #__text_vertical  = #__flag_vertical
    #__text_multiline = #__flag_multiline
    #__text_wordwrap  = #__flag_wordwrap
    #__text_numeric   = #__flag_numeric
    #__text_password  = #__flag_password
    #__text_readonly  = #__flag_readonly
    #__text_lowercase = #__flag_lowercase
    #__text_uppercase = #__flag_uppercase
    
    ;     ;                            ; m/l ; w         ;
    ;     Debug #PB_text_right         ;  1  ; 2         ;
    ;     Debug #PB_text_center        ;  2  ; 1         ;
    ;     Debug #PB_text_border        ;  4  ; 131072    ;
    ;
    ;     Debug #PB_button_right       ;  1  ; 512       ;
    ;     Debug #PB_button_left        ;  2  ; 256       ;
    ;     Debug #PB_button_toggle      ;  4  ; 4099      ;
    ;     Debug #PB_button_Default     ;  8  ; 1         ;
    ;     Debug #PB_button_multiLine   ;  16 ; 8192      ;
    ;
    ;     Debug #PB_string_password    ;  1  ; 32        ;
    ;     Debug #PB_string_readOnly    ;  2  ; 2048      ;
    ;     Debug #PB_string_UpperCase   ;  4  ; 8         ;
    ;     Debug #PB_string_lowerCase   ;  8  ; 16        ;
    ;     Debug #PB_string_numeric     ;  16 ; 8192      ;
    ;     Debug #PB_string_borderLess  ;  32 ; 131072    ;
    ;
    ;     Debug #PB_Editor_readOnly    ;  1  ; 2048      ;
    ;     Debug #PB_Editor_wordWrap    ;  2  ; 268435456 ;
    
    
    ;-\\ Image
    #__image_released   = 1
    #__image_pressed    = 2
    #__image_background = 3
    #__image_left       = #__flag_left
    #__image_top        = #__flag_top
    #__image_center     = #__flag_center
    #__image_right      = #__flag_right
    #__image_bottom     = #__flag_bottom
    
    ;-\\ MDI
    #__mdi_editable = #__flag_anchorsgadget ; win - 4294967296
    
    ;-\\ Window
    ;     #__window_nogadgets = #__flag_nogadgets
    ;     #__window_borderless = #__flag_borderless
    ;     #__window_systemmenu = #__flag_systemmenu
    ;     #__window_sizegadget = #__flag_sizegadget
    ;     #__window_screencentered = #__align_center
    
    #__window_child          = #__flag_child
    #__window_normal         = #PB_Window_Normal
    #__window_systemMenu     = #PB_Window_SystemMenu     ; Enables the system menu on the window title bar (Default).
    #__window_close          = #__window_systemMenu
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
    #__window_maximize       = #PB_Window_Maximize       ; Opens the window maximized. (Note ; on Linux, Not all Windowmanagers support this)
    #__window_minimize       = #PB_Window_Minimize       ; Opens the window minimized.
    #__window_noGadgets      = #PB_Window_NoGadgets      ; Prevents the creation of a GadgetList. UseGadgetList() can be used To do this later.
    #__window_noActivate     = #PB_Window_NoActivate     ; Don't activate the window after opening.
                                                         ;     #__window_closeGadget    = #PB_window_noActivate<<2
                                                         ;     #__window_close          = #PB_window_noActivate<<2
                                                         ;#PB_window                 = #PB_window_noActivate<<2
    
    ;-\\  Spin
    #__spin_barsize      = #__scroll_buttonsize + 3
    #__spin_vertical     = #__bar_vertical
    #__spin_left         = 1 << 1
    #__spin_right        = 1 << 2
    #__spin_plus         = 1 << 3
    
    ;     ;-
    ; Debug #PB_checkbox_Unchecked ; 0
    ; Debug #PB_checkbox_checked   ; 1
    ; Debug #PB_checkbox_inbetween ; -1
    ; Debug #PB_checkBox_threeState ; 4

    ;-\\ Tree
    #PB_Item_Sublevel = #PB_Tree_SubLevel
    
    #PB_tree_Collapse    = 32
    #PB_tree_OptionBoxes = 64
    #PB_tree_GridLines   = 128
    ;#PB_tree_itemPosition = 256
    
    #__tree_nolines     = #__flag_nolines
    #__tree_nobuttons   = #__flag_nogadgets
    #__tree_checkboxes  = #__flag_checkboxes
    #__tree_threestate  = #__flag_threeState
    #__tree_optionboxes = #__flag_optionboxes
    #__tree_gridlines   = #__flag_gridLines
    #__tree_multiselect = #__flag_multiline
    
    #__tree_clickselect = #__flag_clickselect  ; #PB_listView_clickSelect ;
    #__tree_collapse    = #PB_tree_collapse
    
    #__tree_property = #__flag_numeric
    #__tree_listview = #__flag_readonly
    #__tree_toolbar  = #__flag_password
    
    ; tree attribute
    #__tree_sublevel = #PB_Tree_SubLevel   ; 1
    
    ; tree state
    #__tree_selected  = #PB_Tree_Selected   ; 1
    #__tree_expanded  = #PB_Tree_Expanded   ; 2
    #__tree_checked   = #PB_Tree_Checked    ; 4
    #__tree_collapsed = #PB_Tree_Collapsed  ; 8
    #__tree_inbetween = #PB_Tree_Inbetween  ; 16
                                            ;
                                            ;     ;- TREE CONSTANTs
                                            ;   #__tree_noLines = #PB_tree_noLines                         ; 1 2 Hide the little lines between each nodes.
                                            ;   #__tree_noButtons = #PB_tree_noButtons                     ; 2 1 Hide the '+' node buttons.
                                            ;   #__tree_checkBoxes = #PB_tree_checkBoxes                   ; 4 256 Add a checkbox before each Item.
                                            ;   #__tree_threeState = #PB_tree_threeState                   ; 8 65535 The checkboxes can have an "in between" state.
                                            ;
                                            ;   EnumerationBinary 16
                                            ;     #__tree_collapse
                                            ;     #__tree_clickSelect
                                            ;     #__tree_multiSelect
                                            ;     #__tree_GridLines
                                            ;     #__tree_OptionBoxes
                                            ;     #__tree_borderLess
                                            ;     #__tree_fullSelection
                                            ;   EndEnumeration
                                            ;
                                            ;   #PB_tree_collapse = #__tree_collapse
                                            ;   #PB_tree_GridLines = #__tree_GridLines
    
    ; LIST_ELEMENT
    ;     CompilerIf #PB_compiler_OS = #PB_OS_macOS
    ;       Debug #PB_listView_multiSelect  ; 1
    ;       Debug #PB_listView_clickSelect  ; 2
    
    ;       Debug #PB_tree_alwaysShowSelection ; 0
    ;       Debug #PB_tree_noLines    ; 1
    ;       Debug #PB_tree_selected   ; 1
    ;       Debug #PB_tree_subLevel   ; 1
    ;       Debug #PB_tree_noButtons  ; 2
    ;       Debug #PB_tree_Expanded   ; 2
    ;       Debug #PB_tree_checkBoxes ; 4
    ;       Debug #PB_tree_checked    ; 4
    ;       Debug #PB_tree_threeState ; 8
    ;       Debug #PB_tree_collapsed  ; 8
    ;       Debug #PB_tree_inbetween  ; 16
    
    ;       Debug #PB_listIcon_alwaysShowSelection ; 0
    ;       Debug #PB_listIcon_selected   ; 1
    ;       Debug #PB_listIcon_checkBoxes ; 2
    ;       Debug #PB_listIcon_checked    ; 2
    ;       Debug #PB_listIcon_inbetween  ; 4
    ;       Debug #PB_listIcon_threeState ; 8
    ;     CompilerEndIf
    
    ;- _c_listview
    #__listview_clickselect = #__tree_clickselect
    #__listview_multiselect = #__tree_multiselect
    
    ;-\\ Editor
    ;#__editor_inline = #__flag_inLine
    #__editor_readonly      = #__text_readonly
    #__editor_wordwrap      = #__text_wordwrap
    ;#__editor_nomultiline   = #__flag_nolines
    ;#__editor_numeric       = #__flag_numeric | #__text_multiline
    ;#__editor_fullselection = #__flag_fullselection
    ;#__editor_gridlines     = #__flag_gridLines
    #__editor_borderless    = #__flag_borderless
    
    ;- _c_string
    #__string_right      = #__text_right
    #__string_center     = #__text_center
    #__string_numeric    = #__text_numeric
    #__string_password   = #__text_password
    #__string_readonly   = #__text_readonly
    #__string_uppercase  = #__text_uppercase
    #__string_lowercase  = #__text_lowercase
    #__string_borderless = #__flag_borderless
    #__string_multiline  = #__text_multiline
    
    ;-\\ Button
    #__button_toggle    = #PB_Button_Toggle
    #__button_default   = #PB_Button_Default
    #__button_multiline = #PB_Button_MultiLine
    #__button_left      = #__text_left
    #__button_right     = #__text_right
    #__button_vertical  = #__text_vertical
    #__button_invert    = #__text_invert
    
    
    If (#__flag_limit >> 1) > 2147483647 ; 8589934592
      Debug "Исчерпан лимит в x32 (" + Str(#__flag_limit >> 1) + ")"
    EndIf
    
    
    Enumeration #PB_Event_FirstCustomValue
      #PB_Event_create
      #PB_Event_mouseMove
      #PB_Event_leftButtonDown
      #PB_Event_leftButtonUp
      #PB_Event_Destroy
    EndEnumeration
    
    ;- Constant event-type
    Enumeration #PB_EventType_FirstCustomValue
      #PB_EventType_create
      #PB_EventType_repaint
      CompilerIf Not Defined(PB_EventType_resize, #PB_Constant)
        #PB_EventType_Resize
      CompilerEndIf
      CompilerIf Not Defined(PB_EventType_returnKey, #PB_Constant)
        #PB_EventType_returnKey
      CompilerEndIf
      
      #PB_EventType_resizeBegin
      #PB_EventType_resizeEnd
      
      #PB_EventType_Draw
      #PB_EventType_free
      #PB_EventType_Drop
      
      #PB_EventType_scrollChange
      
      #PB_EventType_closeWindow
      #PB_EventType_maximizeWindow
      #PB_EventType_minimizeWindow
      #PB_EventType_restoreWindow
      
      #PB_EventType_mouseWheelX
      #PB_EventType_mouseWheelY
      
      #PB_EventType_left3Click
      #PB_EventType_right3Click
      
      #PB_EventType_mouseStatus ; temp
      #PB_EventType_statusChangeEdit
      ;       #PB_EventType_timerStart
      ;       #PB_EventType_timerStop
      ;;;; #PB_EventType_colorChange
      ; #PB_EventType_cursorUpdate
      #PB_EventType_cursorChange
    EndEnumeration
    
    #__event_cursorChange = #PB_EventType_cursorChange
    #__event_resizeBegin  = #PB_EventType_resizeBegin
    #__event_resizeEnd    = #PB_EventType_resizeEnd
    
    #__event_free     = #PB_EventType_free
    #__event_Drop     = #PB_EventType_Drop
    #__event_create   = #PB_EventType_create
    #__event_sizeitem = #PB_EventType_SizeItem
    
    #__event_repaint      = #PB_EventType_repaint
    #__event_resizeEnd    = #PB_EventType_resizeEnd
    #__event_scrollChange = #PB_EventType_scrollChange
    
    #__event_closeWindow    = #PB_EventType_closeWindow
    #__event_maximizewindow = #PB_EventType_maximizeWindow
    #__event_minimizewindow = #PB_EventType_minimizeWindow
    #__event_restorewindow  = #PB_EventType_restoreWindow
    
    #__event_mouseEnter      = #PB_EventType_MouseEnter       ; The mouse cursor entered the gadget
    #__event_mouseLeave      = #PB_EventType_MouseLeave       ; The mouse cursor left the gadget
    #__event_mouseMove       = #PB_EventType_MouseMove        ; The mouse cursor moved
    #__event_mouseWheel      = #PB_EventType_MouseWheel       ; The mouse wheel was moved
    #__event_leftButtonDown  = #PB_EventType_LeftButtonDown   ; The left mouse button was pressed
    #__event_leftButtonUp    = #PB_EventType_LeftButtonUp     ; The left mouse button was released
    #__event_leftDoubleClick = #PB_EventType_LeftDoubleClick  ; A double-click With the left mouse button
    #__event_left3Click      = #PB_EventType_left3Click       ; A click With the left mouse button
    #__event_left2Click      = #PB_EventType_LeftDoubleClick  ; A double-click With the left mouse button
    #__event_leftClick       = #PB_EventType_LeftClick        ; A click With the left mouse button
    
    #__event_rightButtonDown  = #PB_EventType_RightButtonDown  ; The right mouse button was pressed
    #__event_rightButtonUp    = #PB_EventType_RightButtonUp    ; The right mouse button was released
    #__event_rightDoubleClick = #PB_EventType_RightDoubleClick ; A double-click With the right mouse button
    #__event_right3Click      = #PB_EventType_right3Click      ; A click With the right mouse button
    #__event_right2Click      = #PB_EventType_RightDoubleClick ; A double-click With the right mouse button
    #__event_rightClick       = #PB_EventType_RightClick       ; A click With the right mouse button
    
    #__event_middleButtonDown = #PB_EventType_MiddleButtonDown ; The middle mouse button was pressed
    #__event_middleButtonUp   = #PB_EventType_MiddleButtonUp   ; The middle mouse button was released
    #__event_focus            = #PB_EventType_Focus            ; The gadget gained keyboard focus
    #__event_lostFocus        = #PB_EventType_LostFocus        ; The gadget lost keyboard focus
    #__event_KeyDown          = #PB_EventType_KeyDown          ; A key was pressed
    #__event_KeyUp            = #PB_EventType_KeyUp            ; A key was released
    #__event_input            = #PB_EventType_Input            ; Text input was generated
    #__event_resize           = #PB_EventType_Resize           ; The gadget has been resized
    #__event_statusChange     = #PB_EventType_StatusChange
    #__event_titleChange      = #PB_EventType_TitleChange
    #__event_change           = #PB_EventType_Change
    #__event_DragStart        = #PB_EventType_DragStart
    #__event_returnKey        = #PB_EventType_returnKey
    #__event_closeItem        = #PB_EventType_CloseItem
    
    #__event_Down = #PB_EventType_Down
    #__event_Up   = #PB_EventType_Up
    
    #__event_mouseWheelX = #PB_EventType_mouseWheelX
    #__event_mouseWheelY = #PB_EventType_mouseWheelY
    
    #__event_Draw = #PB_EventType_Draw
    
    
    ;- Constant create-type
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
      #__type_mDI           = #PB_GadgetType_MDI           ; 30
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
    
    
    
    
    
    
    
    
    
    
    
    ;     ; temp
    ;     #__c_0 = 0
    ;     #__c_1 = 1
    ;     #__c_2 = 2
    ;     #__c_3 = 3
    ;     #__c_4 = 4
    ;     #__c_5 = 5
    ;     #__c_6 = 6
    
    
    #__text_update = - 124
    
    #debug                       = 0
    #debug_draw_font             = #debug
    #debug_draw_font_change      = #debug
    #debug_draw_item_font_change = #debug
    #__debug_events_tab          = 0
    
    #__draw_scroll_box     = 0
    #__test_scrollbar_size = 0
    
    #debug_update_text = 0
    #debug_multiline   = 0
    #debug_repaint     = 0 ; Debug " - -  Canvas repaint - -  "
                           ;-
                           ;- GLOBAL
                           ;-
    
    Global test_draw_box_clip_type  = #PB_All
    Global test_draw_box_clip1_type = #PB_All
    Global test_draw_box_clip2_type = #PB_All
    
    Global test_draw_box_screen_type ;= #PB_all
    Global test_draw_box_inner_type  ;= #PB_all
    Global test_draw_box_frame_type  ;= #PB_all
    
    ;     test_draw_box_clip_type = #__type_listview
    ;     test_draw_box_clip1_type = #__type_listview
    ;     test_draw_box_clip2_type = #__type_listview
    
    ;     test_draw_box_clip_type = #__type_tree
    ;     test_draw_box_clip1_type = #__type_tree
    ;     test_draw_box_clip2_type = #__type_tree
    ;
    ;     test_draw_box_clip_type = #__type_mdi
    ;     test_draw_box_clip1_type = #__type_mdi
    ;     test_draw_box_clip2_type = #__type_mdi
    
    ;     test_draw_box_clip_type = #__type_scrollarea
    ;     test_draw_box_clip1_type = #__type_scrollarea
    ;     test_draw_box_clip2_type = #__type_scrollarea
    
    
    test_draw_box_clip_type  = #__type_scrollbar
    test_draw_box_clip1_type = #__type_scrollbar
    test_draw_box_clip2_type = #__type_scrollbar
    
    
    
    
    
    
    
    
    ; ;
    ; ;
    ; ;     EnumerationBinary
    ; ;       #__systemMenu
    ; ;
    ; ;       #__titleBar
    ; ;       #__sizeGadget
    ; ;       #__maximizeGadget
    ; ;       #__minimizeGadget
    ; ;
    ; ;       #__screenCentered
    ; ;       #__tool
    ; ;
    ; ;       #__Default
    ; ;
    ; ;       #__minimize
    ; ;       #__maximize
    ; ;       #__invisible
    ; ;
    ; ;       #__vertical
    ; ;       #__left
    ; ;       #__top
    ; ;       #__center
    ; ;       #__right
    ; ;       #__bottom
    ; ;
    ; ;       #__Editable
    ; ;       #__numeric
    ; ;       #__password
    ; ;       #__readOnly
    ; ;       #__lowerCase
    ; ;       #__UpperCase
    ; ;
    ; ;
    ; ;       #__borderLess
    ; ;       #__border
    ; ;       #__flat
    ; ;       #__raised
    ; ;       #__single
    ; ;       #__Double
    ; ;
    ; ;       #__wordWrap
    ; ;       #__multiLine
    ; ;
    ; ;       #__threeState
    ; ;       #__multiSelect
    ; ;       #__clickSelect
    ; ;
    ; ;
    ; ;       #__image
    ; ;
    ; ;       #__Underline
    ; ;
    ; ;       #__checkBoxes
    ; ;
    ; ;
    ; ;       #__GridLines
    ; ;       #__HeaderDragDrop
    ; ;       #__fullRowSelect
    ; ;       #__alwaysShowSelection
    ; ;
    ; ;
    ; ;       #__noLines
    ; ;       #__noButtons
    ; ;       #__noFiles
    ; ;       #__noFolders
    ; ;       #__noParentFolder
    ; ;       #__noDirectoryChange
    ; ;       #__noDriveRequester
    ; ;       #__noMyDocuments
    ; ;       #__noSort
    ; ;       #__autoSort
    ; ;       #__HiddenFiles
    ; ;
    ; ;       #__separator
    ; ;       #__firstFixed
    ; ;       #__secondFixed
    ; ;
    ; ;       #__container
    ; ;       #__clipMouse
    ; ;
    ; ;       #__Keyboard
    ; ;       #__DrawFocus
    ; ;
    ; ;       ;;;;;;;;;;;
    ; ;       #__flag_limit
    ; ;
    ; ;
    ; ;     EndEnumeration
    ; ;
    ; ;     #__normal  = #__Default
    ; ;     #__windowCentered = #__center
    ; ;
    ; ;     #__noActivate = #__noLines
    ; ;     #__noGadgets = #__noButtons
    ; ;
    ; ;     #__toggle = #__DrawFocus
    ; ;
    ; ;     #__ticks = #__DrawFocus
    ; ;     #__smooth = #__DrawFocus
    ; ;
    ; ;     #__UpDown = #__DrawFocus
    ; ;
    ; ;     Debug #__flag_limit>>1
    ; ;     If (#__flag_limit>>1) > 2147483647 ; 8589934592
    ; ;       Debug "Исчерпан лимит в x32 ("+Str(#__flag_limit>>1)+")"
    ; ;     EndIf
    
    
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
    
    
    CompilerIf Not Defined(PB_toolBar_small, #PB_Constant)
      #PB_ToolBar_Small = 1 << 0
    CompilerEndIf
    CompilerIf Not Defined(PB_messageRequester_info, #PB_Constant)
      #PB_MessageRequester_Info = 1 << 2
    CompilerEndIf
    CompilerIf Not Defined(PB_messageRequester_Error, #PB_Constant)
      #PB_MessageRequester_Error = 1 << 3
    CompilerEndIf
    CompilerIf Not Defined(PB_messageRequester_warning, #PB_Constant)
      #PB_MessageRequester_Warning = 1 << 4
    CompilerEndIf
    CompilerIf Not Defined(PB_canvas_container, #PB_Constant)
      #PB_Canvas_Container = 1 << 5
    CompilerEndIf
  EndDeclareModule
  
  
  Module Constants
    
  EndModule
  
  ;UseModule Constants
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP