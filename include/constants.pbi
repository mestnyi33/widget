CompilerIf Not Defined(constants, #PB_Module)
  DeclareModule constants
    Macro _check_(_variable_, _constant_, _state_=#True)
      Bool(_state_ = Bool(((_variable_) & _constant_) = _constant_))
    EndMacro
    
    ;- - CONSTANTs
    ;{
    ; list mode
    #__m_checkselect = 1
    #__m_clickselect = 2
    #__m_multiselect = 3
    #__m_optionselect = 4
    
    ; default values 
    #__grid_type = 0
    #__grid_size = 8 
    #__a_size = 7;13 
    #__caption_height = 24
    #__border_size = 4 
    #__border_scroll = 2
    
    #__panel_height = 25
    #__panel_width = 85
    
    
    #__from_mouse_state = 0
    #__focus_state = 1
    
    #__spin_padding_text = 1
    #__spin_buttonsize2 = 15
    #__spin_buttonsize = 18
    ;#__splitter_buttonsize = 9
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      #__splitter_buttonsize = 9
    CompilerEndIf
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      #__splitter_buttonsize = 7;4
    CompilerEndIf
    CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      #__splitter_buttonsize = 4
    CompilerEndIf
    #__scroll_buttonsize = 16
    
    #__arrow_type = 1 ;
    #__arrow_size = 4 ;
    
    #__sOC = SizeOf(Character)
    
    #__a_count = 9+4
    #__a_moved = 9
    
    #__bar_minus = 1
    
    #__tab_0 = 0
    ; splitter 
    #__split_0 = 0
    #__split_1 = 1
    #__split_2 = 2
    
    #__split_b1 = 1
    #__split_b2 = 2
    #__split_b3 = 3
    
    ; panel
    #__panel_1 = 1
    #__panel_2 = 2
    
    #__tab_1 = 1 ; entered item
    #__tab_2 = 2 ; selected item
    
    ; option
    #__option_1 = 2
    
    
    #__tree_linesize = 5
    
    ; errors
    Enumeration 1
      #__error_text_input
      #__error_text_back
      #__error_text_return
    EndEnumeration
    
    ;images
    Enumeration
      #__img_released = 1
      #__img_pressed = 2
      #__img_background = 3
    EndEnumeration
    
    ;bar buttons
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
    
    ;- coordinate 
    ;;Enumeration
    ; pos & size
    #__c_screen    = 0 ; screen
    #__c_frame     = 1 ; frame screen
    #__c_inner     = 2 ; inner screen
    #__c_container = 3 ; container
    #__c_required  = 4 ; required
    
    #__c_clip      = 5 ; clip screen
    #__c_clip1     = 6 ; clip frame 
    #__c_clip2     = 10; clip inner 
    
    ; pos
    #__c_window    = 7 ; window
    
    #__c_delta     = 9
    
    #__c           = 11
    ;;EndEnumeration
    #__c_inner2 = #__c_inner
    #__c_rootrestore = 7
    ;     #__ci_frame = #__c_draw
    ;     #__ci_container = #__c_draw
    #__c_inner_b = #__c_inner
    
    ; \_state
    EnumerationBinary
      #__s_normal
      #__s_entered  ; 1<<1
      #__s_selected
      #__s_disabled
      #__s_toggled
      
      #__s_focused
      #__s_scrolled
      #__s_dragged
      #__s_dropped ; drop enter state
      #__s_drawing
    EndEnumeration
    
    ; \__state
    EnumerationBinary 1
      #__ss_front
      #__ss_back
      #__ss_frame
      #__ss_fore
      #__ss_line
    EndEnumeration
    
    ;color state
    Enumeration
      #__s_0
      #__s_1
      #__s_2
      #__s_3
    EndEnumeration
    
    ;- _c_color
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
    
    ;
    ;   ; Set/Get Attribute
    #__displayMode = 1<<13
    ;   #PB_Image = 1<<13
    ;   #PB_text = 1<<14
    ;   #PB_flag = 1<<15
    ;   #PB_State = 1<<16
    
    ;- _c_resize
    EnumerationBinary 
      #__resize_x
      #__resize_y
      #__resize_width
      #__resize_height
      
      #__resize_change
      
      #__resize_restore
      #__resize_minimize
      #__resize_maximize
    EndEnumeration
    
    ;- _c_flag
    EnumerationBinary _c_align 2
      #__flag_vertical ;= 1
      
      #__flag_left
      #__flag_top
      #__flag_right
      #__flag_bottom
      #__flag_center
      
      #__flag_full
      #__flag_proportional
      
      
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
      
      
      ; #__flag_inline
      #__flag_threeState
      #__flag_clickselect 
      ;#__flag_multiselect 
      
      
      #__flag_inverted
      #__flag_noactivate
      #__flag_autosize
      ;#__flag_invisible
      ;#__flag_sizegadget
      ;#__flag_systemmenu
      #__flag_noscrollbars
      #__flag_child
    
      #__flag_borderless
      ;       #__flag_flat
      ;       #__flag_double
      ;       #__flag_raised
      ;       #__flag_single
      
      
      #__flag_transparent
      #__mdi_editable
      #__flag_anchorsGadget
      #__flag_limit
    EndEnumeration
    
    ;#__flag_checkboxes = #__flag_clickselect
    #__flag_nogadgets = #__flag_nobuttons
    #__flag_multiselect = #__flag_multiline
    
    #__flag_default = #__flag_nolines|#__flag_nobuttons|#__flag_checkboxes
    #__flag_alwaysselection = #__flag_lowercase|#__flag_uppercase
    
    #__flag_autoright = #__flag_autosize|#__flag_right
    #__flag_autobottom = #__flag_autosize|#__flag_bottom
    
    
    ;- _c_align
    ; align type
    #__align_widget        = 1
    #__align_text          = 2
    #__align_image         = 3
    
    #__align_none          = #False
    #__align_vertical      = #__flag_vertical
    #__align_left          = #__flag_left
    #__align_top           = #__flag_top  
    #__align_right         = #__flag_right
    #__align_bottom        = #__flag_bottom
    
    #__align_full          = #__flag_full
    #__align_auto          = #__flag_autosize
    #__align_center        = #__flag_center
    #__align_proportional  = #__flag_proportional
    
    
    ;- _c_bar
      #__bar_minimum = 1
      #__bar_maximum = 2
      #__bar_pagelength = 3
      #__bar_scrollstep = 5
      
    EnumerationBinary 8
      #__bar_buttonsize 
      #__bar_direction 
      
      ;#__bar_arrowSize 
      ;#__bar_reverse
      
      #__bar_ticks
      #__bar_vertical
    EndEnumeration
    
    ;#__bar_nobuttons = #__flag_nogadgets
    #__bar_inverted = #__flag_inverted
    
    ;- _c_text
    #__text_border = #__flag_borderless;#PB_text_border
    
    #__text_left = #__align_left
    #__text_top = #__align_top
    #__text_center = #__align_center
    #__text_right = #__align_right
    #__text_bottom = #__align_bottom
    #__text_middle = #__text_center
    
    #__text_vertical = #__flag_vertical
    #__text_multiline = #__flag_multiline
    #__text_wordwrap = #__flag_wordwrap
    #__text_numeric = #__flag_numeric
    #__text_password = #__flag_password
    #__text_readonly = #__flag_readonly
    #__text_lowercase = #__flag_lowercase
    #__text_uppercase = #__flag_uppercase
    #__text_invert = #__flag_inverted
    
    ;- _c_window
    ;     #__window_nogadgets = #__flag_nobuttons
    ;     #__window_borderless = #__flag_borderless
    ;     #__window_systemmenu = #__flag_systemmenu
    ;     #__window_sizegadget = #__flag_sizegadget
    ;     #__window_screencentered = #__align_center
    
    #__window_child          = #__flag_child
    #__Window_Normal         = #PB_Window_Normal
    #__Window_SystemMenu     = #PB_Window_SystemMenu     ; Enables the system menu on the window title bar (Default).
    #__Window_MinimizeGadget = #PB_Window_MinimizeGadget ; Adds the minimize gadget To the window title bar. #PB_Window_SystemMenu is automatically added.
    #__Window_MaximizeGadget = #PB_Window_MaximizeGadget ; Adds the maximize gadget To the window title bar. #PB_Window_SystemMenu is automatically added.
                                                         ; (MacOS only ; #PB_Window_SizeGadget will be also automatically added).
    #__Window_SizeGadget     = #PB_Window_SizeGadget     ; Adds the sizeable feature To a window.
    #__Window_Invisible      = #PB_Window_Invisible      ; Creates the window but don't display.
    #__Window_titleBar       = #PB_Window_TitleBar       ; Creates a window with a titlebar.
    #__Window_tool           = #PB_Window_Tool           ; Creates a window with a smaller titlebar And no taskbar entry. 
    #__Window_borderLess     = #PB_Window_BorderLess     ; Creates a window without any borders.
    #__Window_ScreenCentered = #PB_Window_ScreenCentered ; Centers the window in the middle of the screen. x,y parameters are ignored.
    #__Window_WindowCentered = #PB_Window_WindowCentered ; Centers the window in the middle of the parent window ('ParentWindowID' must be specified).
                                                         ;                 x,y parameters are ignored.
    #__Window_Maximize       = #PB_Window_Maximize       ; Opens the window maximized. (Note ; on Linux, Not all Windowmanagers support this)
    #__Window_Minimize       = #PB_Window_Minimize       ; Opens the window minimized.
    #__Window_NoGadgets      = #PB_Window_NoGadgets      ; Prevents the creation of a GadgetList. UseGadgetList() can be used To do this later.
    #__Window_NoActivate     = #PB_Window_NoActivate     ; Don't activate the window after opening.
                                                         ;     #__Window_closeGadget    = #PB_Window_NoActivate<<2
                                                         ;     #__Window_close          = #PB_Window_NoActivate<<2
    #PB_Window                 = #PB_Window_NoActivate<<2
    
    ;- _c_spin
    #__spin_left = #__text_left
    #__spin_right = #__text_right
    #__spin_center = #__text_center
    #__spin_numeric = #__text_numeric
    #__spin_vertical = #__bar_vertical
    
;     ;- 
; Debug #PB_Checkbox_Unchecked ; 0
; Debug #PB_Checkbox_Checked   ; 1
; Debug #PB_Checkbox_Inbetween ; -1
; Debug #PB_CheckBox_ThreeState ; 4

    ;- _c_tree
    #PB_Tree_Collapse = 32
    
    #__tree_alwaysselection = #__flag_alwaysselection
    #__tree_nolines = #__flag_nolines
    #__tree_nobuttons = #__flag_nogadgets
    #__tree_checkboxes = #__flag_checkboxes
    #__tree_threestate = #__flag_threeState
    #__tree_optionboxes = #__flag_optionboxes
    #__tree_gridlines = #__flag_gridLines
    #__tree_multiselect = #__flag_multiselect
    #__tree_clickselect = #__flag_clickselect
    #__tree_collapse = #PB_Tree_Collapse
    
    #__tree_property = #__flag_numeric
    #__tree_listview = #__flag_readonly
    #__tree_toolbar = #__flag_password
    
    ; tree attribute
    #__tree_sublevel  = #PB_Tree_SubLevel   ; 1
    
    ; tree state
    #__tree_checked   = #PB_Tree_Checked    ; 4
    #__tree_selected  = #PB_Tree_Selected   ; 1 
    #__tree_expanded  = #PB_Tree_Expanded   ; 2
    #__tree_collapsed = #PB_Tree_Collapsed  ; 8
    #__tree_inbetween = #PB_Tree_Inbetween  ; 16
                                            ;     
                                            ;     ;- TREE CONSTANTs
                                            ;   #__tree_NoLines = #PB_tree_NoLines                         ; 1 2 Hide the little lines between each nodes.
                                            ;   #__tree_NoButtons = #PB_tree_NoButtons                     ; 2 1 Hide the '+' node buttons.
                                            ;   #__tree_checkBoxes = #PB_tree_checkBoxes                   ; 4 256 Add a checkbox before each Item.
                                            ;   #__tree_threeState = #PB_tree_threeState                   ; 8 65535 The checkboxes can have an "in between" state.
                                            ;   
                                            ;   EnumerationBinary 16
                                            ;     #__tree_collapse
                                            ;     #__tree_AlwaysSelection
                                            ;     #__tree_clickSelect
                                            ;     #__tree_MultiSelect
                                            ;     #__tree_GridLines
                                            ;     #__tree_OptionBoxes
                                            ;     #__tree_borderLess
                                            ;     #__tree_FullSelection
                                            ;   EndEnumeration
                                            ;   
                                            ;   #PB_tree_collapse = #__tree_collapse
                                            ;   #PB_tree_GridLines = #__tree_GridLines
    
    ;- _c_listview
    #__listview_clickselect = #__tree_clickselect
    #__listview_multiselect = #__tree_multiselect
    
    ;- _c_editor
    ;#__editor_inline = #__flag_InLine
    #__editor_readonly = #__text_readonly
    #__editor_wordwrap = #__text_wordwrap
    #__editor_nomultiline = #__flag_nolines
    #__editor_numeric = #__flag_numeric|#__text_multiline
    #__editor_fullselection = #__flag_fullselection
    #__editor_alwaysselection = #__flag_alwaysselection
    #__editor_gridlines = #__flag_gridLines
    #__editor_borderless = #__flag_borderless
    
    ;- _c_string
    #__string_right = #__text_right
    #__string_center = #__text_center
    #__string_numeric = #__text_numeric
    #__string_password = #__text_password
    #__string_readonly = #__text_readonly
    #__string_uppercase = #__text_uppercase
    #__string_lowercase = #__text_lowercase
    #__string_borderless = #__flag_borderless
    #__string_multiline = #__text_multiline
    
    ;- _c_button
    #__button_left = #__text_left
    #__button_right = #__text_right
    #__button_toggle = #__flag_threeState ; #__flag_collapsed
    #__button_default = #__flag_default
    #__button_vertical = #__text_vertical
    #__button_inverted = #__flag_inverted
    #__button_multiline = #__text_wordwrap
    
    
    If (#__flag_limit>>1) > 2147483647 ; 8589934592
      Debug "Исчерпан лимит в x32 ("+Str(#__flag_limit>>1)+")"
    EndIf
    
    
    
    ;- _c_event
    
    Enumeration #PB_Event_FirstCustomValue
      #PB_Event_Resize
      #PB_Event_ResizeEnd
      
      #PB_Event_Free         
      #PB_Event_Create
      #PB_Event_Drop
      
      #PB_Event_ReturnKey
      #PB_Event_ScrollChange
      
      ;;#PB_Event_ActivateWindow
      ;;#PB_Event_DeactivateWindow
      ;;#PB_Event_Gadget
      ;;#PB_Event_GadgetDrop
      ;;#PB_Event_LeftClick
      ;;#PB_Event_LeftDoubleClick
      ;;#PB_Event_Menu
      
      ;;#PB_Event_MoveWindow
      ;;#PB_Event_SizeWindow
      ;;#PB_Event_SysTray
      ;;#PB_Event_Timer
      ;;#PB_Event_WindowDrop
      ;;#PB_Event_RightClick
      
      ;;#PB_Event_Repaint
      ;;#PB_Event_CloseWindow
      ;;#PB_Event_MaximizeWindow
      ;;#PB_Event_MinimizeWindow
      ;;#PB_Event_RestoreWindow
    EndEnumeration
    
    Enumeration #PB_EventType_FirstCustomValue
      CompilerIf Not Defined(PB_EventType_resize, #PB_Constant)
        #PB_EventType_Resize
      CompilerEndIf
      
      CompilerIf Not Defined(PB_EventType_returnKey, #PB_Constant)
        #PB_EventType_ReturnKey
      CompilerEndIf
      
      #PB_EventType_ResizeEnd
      
      #PB_EventType_Free         
      #PB_EventType_Create
      #PB_EventType_Drop
      
      #PB_EventType_Repaint
      #PB_EventType_ScrollChange
      
      #PB_EventType_CloseWindow
      #PB_EventType_MaximizeWindow
      #PB_EventType_MinimizeWindow
      #PB_EventType_RestoreWindow
      
      #PB_EventType_MouseWheelX
      #PB_EventType_MouseWheelY
    EndEnumeration
    
    #__event_free             = #PB_EventType_Free    
    #__event_drop             = #PB_EventType_Drop
    #__event_create           = #PB_EventType_Create
    #__event_sizeitem         = #PB_EventType_SizeItem
    
    #__event_repaint          = #PB_EventType_Repaint
    #__event_resizeend        = #PB_EventType_ResizeEnd
    #__event_scrollchange     = #PB_EventType_ScrollChange
    
    #__event_closewindow      = #PB_EventType_CloseWindow
    #__event_maximizewindow   = #PB_EventType_MaximizeWindow
    #__event_minimizewindow   = #PB_EventType_MinimizeWindow
    #__event_restorewindow    = #PB_EventType_RestoreWindow
    
    #__event_mouseenter       = #PB_EventType_MouseEnter       ; The mouse cursor entered the gadget
    #__event_mouseleave       = #PB_EventType_MouseLeave       ; The mouse cursor left the gadget
    #__event_mousemove        = #PB_EventType_MouseMove        ; The mouse cursor moved
    #__event_mousewheel       = #PB_EventType_MouseWheel       ; The mouse wheel was moved
    #__event_leftButtonDown   = #PB_EventType_LeftButtonDown   ; The left mouse button was pressed
    #__event_leftButtonUp     = #PB_EventType_LeftButtonUp     ; The left mouse button was released
    #__event_leftclick        = #PB_EventType_LeftClick        ; A click With the left mouse button
    #__event_leftdoubleclick  = #PB_EventType_LeftDoubleClick  ; A double-click With the left mouse button
    #__event_rightbuttondown  = #PB_EventType_RightButtonDown  ; The right mouse button was pressed
    #__event_rightbuttonup    = #PB_EventType_RightButtonUp    ; The right mouse button was released
    #__event_rightclick       = #PB_EventType_RightClick       ; A click With the right mouse button
    #__event_rightdoubleclick = #PB_EventType_RightDoubleClick ; A double-click With the right mouse button
    #__event_middlebuttondown = #PB_EventType_MiddleButtonDown ; The middle mouse button was pressed
    #__event_middlebuttonup   = #PB_EventType_MiddleButtonUp   ; The middle mouse button was released
    #__event_focus            = #PB_EventType_Focus            ; The gadget gained keyboard focus
    #__event_lostfocus        = #PB_EventType_LostFocus        ; The gadget lost keyboard focus
    #__event_keydown          = #PB_EventType_KeyDown          ; A key was pressed
    #__event_keyup            = #PB_EventType_KeyUp            ; A key was released
    #__event_input            = #PB_EventType_Input            ; Text input was generated
    #__event_resize           = #PB_EventType_Resize           ; The gadget has been resized
    #__event_statuschange     = #PB_EventType_StatusChange
    #__event_titlechange      = #PB_EventType_TitleChange
    #__event_change           = #PB_EventType_Change
    #__event_dragstart        = #PB_EventType_DragStart
    #__event_returnkey        = #PB_EventType_returnKey
    #__event_closeitem        = #PB_EventType_CloseItem
    
    #__event_down             = #PB_EventType_Down
    #__event_up               = #PB_EventType_Up
    
    #__event_mousewheelX = #PB_EventType_MouseWheelX
    #__event_mousewheelY = #PB_EventType_MouseWheelY
    
    ;-
    Enumeration event 1
      #__e_leftButtonDown    ; The left mouse button was pressed
      #__e_leftButtonUp      ; The left mouse button was released
      #__e_leftclick         ; A click With the left mouse button
      #__e_leftdoubleclick   ; A double-click With the left mouse button
      
      #__e_middlebuttondown  ; The middle mouse button was pressed
      #__e_middlebuttonup    ; The middle mouse button was released
      
      #__e_rightbuttondown   ; The right mouse button was pressed
      #__e_rightbuttonup     ; The right mouse button was released
      #__e_rightclick        ; A click With the right mouse button
      #__e_rightdoubleclick  ; A double-click With the right mouse button
      
      #__e_mouseenter        ; The mouse cursor entered the gadget
      #__e_mouseleave        ; The mouse cursor left the gadget
      #__e_mousemove         ; The mouse cursor moved
      #__e_mousewheel        ; The mouse wheel was moved
      
      #__e_focus             ; The gadget gained keyboard focus
      #__e_lostfocus         ; The gadget lost keyboard focus
      #__e_keydown           ; A key was pressed
      #__e_keyup             ; A key was released
      #__e_input             ; Text input was generated
      #__e_returnkey       
      
      #__e_drop             
      #__e_dragstart        
      
      #__e_change         
      #__e_titlechange      
      #__e_statuschange      
      #__e_scrollchange    
      
      #__e_free             
      #__e_create          
      #__e_repaint          
      #__e_resizestart       ; The gadget has been begin resized
      #__e_resize            ; The gadget has been resized
      #__e_resizeend         ; The gadget has been end resized
      
      #__e_down
      #__e_up       
      
      #__e_sizeitem        
      #__e_closeitem
      
      #__e_closewindow       
      #__e_maximizewindow 
      #__e_minimizewindow    
      #__e_restorewindow 
    EndEnumeration
    
    ;- _c_type
    #PB_GadgetType_All       = -1     
    #PB_GadgetType_Window    = -2       
    #PB_GadgetType_Toolbar   = -3      
    #PB_GadgetType_Menu      = -4       
    #PB_GadgetType_Root      = -5
    #PB_GadgetType_StatusBar = -6
    #PB_GadgetType_PopupMenu     = -7
    #PB_GadgetType_Message   = -8
    #PB_GadgetType_Hiasm     = -9
    
    Enumeration 50
      #PB_GadgetType_TabBar
      #PB_GadgetType_Toggled
      #PB_GadgetType_Property 
      #PB_GadgetType_ImageButton
      #PB_GadgetType_StringButton
    EndEnumeration
    
    #__type_hiasm         = #PB_GadgetType_Hiasm
    #__type_message       = #PB_GadgetType_Message
    #__type_popupmenu     = #PB_GadgetType_PopupMenu
    #__type_root          = #PB_GadgetType_Root
    #__type_statusbar     = #PB_GadgetType_StatusBar
    #__type_menu          = #PB_GadgetType_Menu
    #__type_toolbar       = #PB_GadgetType_Toolbar
    #__type_window        = #PB_GadgetType_Window
    
    #__type_tabbar        = #PB_GadgetType_TabBar
    #__type_toggled       = #PB_GadgetType_Toggled
    #__type_property      = #PB_GadgetType_Property
    
    #__type_unknown       = #PB_GadgetType_Unknown
    #__type_button        = #PB_GadgetType_Button
    #__type_buttonimage   = #PB_GadgetType_ButtonImage
    #__type_calendar      = #PB_GadgetType_Calendar
    #__type_canvas        = #PB_GadgetType_Canvas
    #__type_checkbox      = #PB_GadgetType_CheckBox
    #__type_combobox      = #PB_GadgetType_ComboBox
    #__type_container     = #PB_GadgetType_Container
    #__type_date          = #PB_GadgetType_Date
    #__type_editor        = #PB_GadgetType_Editor
    #__type_explorercombo = #PB_GadgetType_ExplorerCombo
    #__type_explorerlist  = #PB_GadgetType_ExplorerList
    #__type_explorertree  = #PB_GadgetType_ExplorerTree
    #__type_frame         = #PB_GadgetType_Frame
    #__type_hyperlink     = #PB_GadgetType_HyperLink
    #__type_image         = #PB_GadgetType_Image
    #__type_ipaddress     = #PB_GadgetType_IPAddress
    #__type_listicon      = #PB_GadgetType_ListIcon
    #__type_listview      = #PB_GadgetType_ListView
    #__type_mdi           = #PB_GadgetType_MDI
    #__type_option        = #PB_GadgetType_Option
    #__type_panel         = #PB_GadgetType_Panel
    #__type_progressbar   = #PB_GadgetType_ProgressBar
    #__type_scintilla     = #PB_GadgetType_Scintilla
    #__type_scrollarea    = #PB_GadgetType_ScrollArea
    #__type_scrollbar     = #PB_GadgetType_ScrollBar
    #__type_shortcut      = #PB_GadgetType_Shortcut
    #__type_spin          = #PB_GadgetType_Spin
    #__type_splitter      = #PB_GadgetType_Splitter
    #__type_string        = #PB_GadgetType_String
    #__type_text          = #PB_GadgetType_Text
    #__type_trackbar      = #PB_GadgetType_TrackBar
    #__type_tree          = #PB_GadgetType_Tree
    #__type_web           = #PB_GadgetType_Web
    #__type_opengl        = #PB_GadgetType_OpenGL
    ;}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ;     ; temp
    ;     #__c_0 = 0
    ;     #__c_1 = 1
    ;     #__c_2 = 2
    ;     #__c_3 = 3
    ;     #__c_4 = 4
    ;     #__c_5 = 5
    ;     #__c_6 = 6
    
    
    #__text_update =- 124
    
    #debug = 0
    #debug_draw_font = #debug
    #debug_draw_font_change = #debug
    #debug_draw_item_font_change = #debug
    #__debug_events_tab = 0
    
    #__draw_scroll_box = 0
    #__test_scrollbar_size = 0
    
    #debug_update_text = 0
    #debug_multiline = 0
    #debug_repaint = 0 ; Debug " - -  Canvas repaint - -  "
                       ;-
                       ;- GLOBAL
                       ;-
    
    Global test_draw_box_clip_type = #PB_All
    Global test_draw_box_clip1_type = #PB_All
    Global test_draw_box_clip2_type = #PB_All
    
    Global test_draw_box_screen_type ;= #PB_All
    Global test_draw_box_inner_type  ;= #PB_All
    Global test_draw_box_frame_type  ;= #PB_All
    
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
    
    
    test_draw_box_clip_type = #__type_scrollbar
    test_draw_box_clip1_type = #__type_scrollbar
    test_draw_box_clip2_type = #__type_scrollbar
    
    
    
    
    
    
    
    
    ; ;     
    ; ;     
    ; ;     EnumerationBinary 
    ; ;       #__SystemMenu
    ; ;       
    ; ;       #__TitleBar
    ; ;       #__SizeGadget
    ; ;       #__MaximizeGadget
    ; ;       #__MinimizeGadget
    ; ;       
    ; ;       #__ScreenCentered
    ; ;       #__Tool
    ; ;       
    ; ;       #__Default
    ; ;       
    ; ;       #__Minimize
    ; ;       #__Maximize
    ; ;       #__Invisible
    ; ;       
    ; ;       #__Vertical
    ; ;       #__Left
    ; ;       #__Top
    ; ;       #__Center
    ; ;       #__Right
    ; ;       #__Bottom
    ; ;       
    ; ;       #__Editable
    ; ;       #__Numeric
    ; ;       #__Password
    ; ;       #__ReadOnly
    ; ;       #__LowerCase
    ; ;       #__UpperCase
    ; ;       
    ; ;       
    ; ;       #__BorderLess
    ; ;       #__Border
    ; ;       #__Flat
    ; ;       #__Raised
    ; ;       #__Single
    ; ;       #__Double
    ; ;       
    ; ;       #__WordWrap
    ; ;       #__MultiLine
    ; ;       
    ; ;       #__ThreeState
    ; ;       #__MultiSelect
    ; ;       #__ClickSelect
    ; ;       
    ; ;       
    ; ;       #__Image
    ; ;       
    ; ;       #__Underline
    ; ;       
    ; ;       #__CheckBoxes
    ; ;       
    ; ;       
    ; ;       #__GridLines
    ; ;       #__HeaderDragDrop
    ; ;       #__FullRowSelect
    ; ;       #__AlwaysShowSelection
    ; ;       
    ; ;       
    ; ;       #__NoLines
    ; ;       #__NoButtons
    ; ;       #__NoFiles
    ; ;       #__NoFolders
    ; ;       #__NoParentFolder
    ; ;       #__NoDirectoryChange
    ; ;       #__NoDriveRequester
    ; ;       #__NoMyDocuments
    ; ;       #__NoSort
    ; ;       #__AutoSort
    ; ;       #__HiddenFiles
    ; ;       
    ; ;       #__Separator
    ; ;       #__FirstFixed
    ; ;       #__SecondFixed 
    ; ;       
    ; ;       #__Container
    ; ;       #__ClipMouse
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
    ; ;     #__Normal  = #__Default
    ; ;     #__WindowCentered = #__Center
    ; ;     
    ; ;     #__NoActivate = #__NoLines
    ; ;     #__NoGadgets = #__NoButtons
    ; ;     
    ; ;     #__Toggle = #__DrawFocus
    ; ;     
    ; ;     #__Ticks = #__DrawFocus
    ; ;     #__Smooth = #__DrawFocus
    ; ;     
    ; ;     #__UpDown = #__DrawFocus
    ; ;     
    ; ;     Debug #__flag_limit>>1
    ; ;     If (#__flag_limit>>1) > 2147483647 ; 8589934592
    ; ;       Debug "Исчерпан лимит в x32 ("+Str(#__flag_limit>>1)+")"
    ; ;     EndIf
    
    
    ; ;     
    ; ;   #PB_Window_TitleBar
    ; ;   #PB_Window_BorderLess
    ; ;   #PB_Window_SystemMenu
    ; ;   #PB_Window_MaximizeGadget
    ; ;   #PB_Window_MinimizeGadget
    ; ;   #PB_Window_ScreenCentered
    ; ;   #PB_Window_SizeGadget
    ; ;   #PB_Window_WindowCentered
    ; ;   #PB_Window_Tool
    ; ;   #PB_Window_Normal
    ; ;   #PB_Window_Minimize
    ; ;   #PB_Window_Maximize
    ; ;   #PB_Window_Invisible
    ; ;   #PB_Window_NoActivate
    ; ;   #PB_Window_NoGadgets
    ; ;   
    ; ;   #PB_Button_Default
    ; ;   #PB_Button_Toggle
    ; ;   #PB_Button_Left
    ; ;   #PB_Button_Center
    ; ;   #PB_Button_Right
    ; ;   #PB_Button_MultiLine
    ; ;   
    ; ;   #PB_String_BorderLess
    ; ;   #PB_String_Numeric
    ; ;   #PB_String_Password
    ; ;   #PB_String_ReadOnly
    ; ;   #PB_String_LowerCase
    ; ;   #PB_String_UpperCase
    ; ;   
    ; ;   #PB_Text_Left
    ; ;   #PB_Text_Center
    ; ;   #PB_Text_Right
    ; ;   #PB_Text_Border
    ; ;   
    ; ;   #PB_CheckBox_Right
    ; ;   #PB_CheckBox_Center
    ; ;   #PB_CheckBox_ThreeState
    ; ;   
    ; ;   #PB_ListView_MultiSelect
    ; ;   #PB_ListView_ClickSelect
    ; ;   
    ; ;   #PB_Frame_Single
    ; ;   #PB_Frame_Double
    ; ;   #PB_Frame_Flat
    ; ;   
    ; ;   #PB_ComboBox_Editable
    ; ;   #PB_ComboBox_LowerCase
    ; ;   #PB_ComboBox_UpperCase
    ; ;   #PB_ComboBox_Image
    ; ;   
    ; ;   #PB_Image_Border
    ; ;   #PB_Image_Raised
    ; ;   
    ; ;   #PB_HyperLink_Underline
    ; ;   
    ; ;   #PB_ListIcon_CheckBoxes
    ; ;   #PB_ListIcon_ThreeState
    ; ;   #PB_ListIcon_MultiSelect
    ; ;   #PB_ListIcon_GridLines
    ; ;   #PB_ListIcon_FullRowSelect
    ; ;   #PB_ListIcon_HeaderDragDrop
    ; ;   #PB_ListIcon_AlwaysShowSelection
    ; ;   
    ; ;   #PB_ProgressBar_Smooth
    ; ;   #PB_ProgressBar_Vertical
    ; ;   
    ; ;   #PB_ScrollBar_Vertical
    ; ;   
    ; ;   #PB_Container_BorderLess
    ; ;   #PB_Container_Flat
    ; ;   #PB_Container_Raised
    ; ;   #PB_Container_Single
    ; ;   #PB_Container_Double
    ; ;   
    ; ;   #PB_ScrollArea_BorderLess
    ; ;   #PB_ScrollArea_Flat
    ; ;   #PB_ScrollArea_Raised
    ; ;   #PB_ScrollArea_Single
    ; ;   #PB_ScrollArea_Center
    ; ;   
    ; ;   #PB_TrackBar_Ticks
    ; ;   #PB_TrackBar_Vertical
    ; ;   
    ; ;   #PB_Calendar_Borderless
    ; ;   
    ; ;   #PB_Date_UpDown
    ; ;   
    ; ;   #PB_Editor_ReadOnly
    ; ;   #PB_Editor_WordWrap
    ; ;   
    ; ;   #PB_Explorer_BorderLess
    ; ;   #PB_Explorer_AlwaysShowSelection
    ; ;   #PB_Explorer_MultiSelect
    ; ;   #PB_Explorer_GridLines
    ; ;   #PB_Explorer_HeaderDragDrop
    ; ;   #PB_Explorer_FullRowSelect
    ; ;   #PB_Explorer_NoFiles
    ; ;   #PB_Explorer_NoFolders
    ; ;   #PB_Explorer_NoParentFolder
    ; ;   #PB_Explorer_NoDirectoryChange
    ; ;   #PB_Explorer_NoDriveRequester
    ; ;   #PB_Explorer_NoSort
    ; ;   #PB_Explorer_NoMyDocuments
    ; ;   #PB_Explorer_AutoSort
    ; ;   #PB_Explorer_HiddenFiles
    ; ;   
    ; ;   #PB_Tree_AlwaysShowSelection
    ; ;   #PB_Tree_NoLines
    ; ;   #PB_Tree_NoButtons
    ; ;   #PB_Tree_CheckBoxes
    ; ;   #PB_Tree_ThreeState
    ; ;   
    ; ;   #PB_Splitter_Vertical
    ; ;   #PB_Splitter_Separator
    ; ;   #PB_Splitter_FirstFixed
    ; ;   #PB_Splitter_SecondFixed 
    ; ;   
    ; ;   #PB_Canvas_Border
    ; ;   #PB_Canvas_Container
    ; ;   #PB_Canvas_ClipMouse
    ; ;   #PB_Canvas_Keyboard
    ; ;   #PB_Canvas_DrawFocus
    ; ;   
  EndDeclareModule 
  
  
  Module Constants
    
  EndModule 
  
  ;UseModule Constants
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP