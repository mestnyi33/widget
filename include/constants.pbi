CompilerIf Not Defined(constants, #PB_Module)
  DeclareModule constants
    Macro _check_(_variable_, _constant_, _state_=#True)
      Bool(_state_ = Bool(((_variable_) & _constant_) = _constant_))
    EndMacro
    
    ;- - CONSTANTs
    ;{
    #__height = 21
    #__bsize = 3
    #__window_frame = #__height+#__bsize*2
    
    #__from_mouse_state = 0
    
    
    #__arrow_type = 1
    #__arrow_size = 4
    
    #__spin_padding_text = 5
    #__spin_buttonsize2 = 15
    #__spin_buttonsize = 18
    
    #__splitter_buttonsize = 9
    #__scroll_buttonsize = 16
    #__test_scrollbar_size = 0
    
    #__round = 7
    #__draw_clip_box = 0
    #__draw_scroll_box = 1
    #__debug_events_tab = 0
    #__sOC = SizeOf(Character)
    #__border_scroll = 2
    
    #__anchors = 9+4
    
    #__a_moved = 9
    
    ; errors
    Enumeration 1
      #__error_text_input
      #__errors_text_back
      #__errors_text_return
    EndEnumeration
    
    ;bar buttons
    Enumeration
      #__b_1 = 1
      #__b_2 = 2
      #__b_3 = 3
    EndEnumeration
    
    ;window buttons
    Enumeration
      #__wb_close
      #__wb_maxi
      #__wb_mini
      #__wb_help
    EndEnumeration
    
;     ;bar position
;     Enumeration
;       #__bp_0 = 0
;       #__bp_1 = 1
;       #__bp_2 = 2
;       #__bp_3 = 3
;     EndEnumeration
    
;     ;element position
;     Enumeration
;       #last =- 1
;       #first = 0
;       #prev = 1
;       #next = 2
;       #__before = 3
;       #__after = 4
;     EndEnumeration
    
    ;element coordinate 
    Enumeration
      #__c_0 = 0 ; 
      #__c_1 = 1 ; frame
      #__c_2 = 2 ; inner
      #__c_3 = 3 ; container
      #__c_4 = 4 ; clip
      #__c_5 = 5 ; clip frame
      #__c_6 = 6 ; clip inner
      #__c_7 = 7 ; scroll 
      #__c = 8
      
    EndEnumeration
    
    ;state
    EnumerationBinary
      #__s_normal
      #__s_entered
      #__s_selected
      #__s_disabled
      #__s_focused
      #__s_toggled
      
      
      #__s_front
      #__s_back
      #__s_frame
      #__s_fore
      #__s_line
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
    
    
;     EnumerationBinary 
;       #__vertical
;       
;       #__Full
;       
;       #__left   
;       #__top    
;       #__right  
;       #__bottom 
;       
;       #__center 
;       #__Proportional
;     EndEnumeration
    
    ;- _c_flag
    EnumerationBinary _c_align 2
      #__flag_vertical ;= 1
      
      #__flag_left
      #__flag_top
      #__flag_right
      #__flag_bottom
      
      #__flag_full
      ; #__flag_autosize
      #__flag_center
      #__flag_proportional
      
      
      #__flag_numeric
      #__flag_readonly
      #__flag_lowercase 
      #__flag_uppercase
      #__flag_password
      #__flag_wordwrap
      #__flag_multiline 
      
      
      ; #__flag_inline
      #__flag_nolines
      #__flag_gridLines
      #__flag_threeState
      #__flag_checkboxes 
      #__flag_optionboxes
      #__flag_clickselect 
      #__flag_multiselect
      #__flag_fullselection
      
      ; common
      #__flag_nobuttons
      #__flag_inverted
      #__flag_noactivate
      #__flag_autosize
      ;#__flag_invisible
      ;#__flag_sizegadget
      ;#__flag_systemmenu
      #__flag_anchorsgadget
      
      #__flag_borderless
      ;         #__flag_double
      ;         #__flag_flat
      ;         #__flag_raised
      ;         #__flag_Single
      
      
      #__flag_noscrollbars
      #__flag_limit
    EndEnumeration
    
    ;#__flag_checkboxes = #__flag_clickselect
    #__flag_noGadget = #__flag_nobuttons
    
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
    EnumerationBinary 4
      #__bar_minimum 
      #__bar_maximum 
      #__bar_pagelength 
      #__bar_buttonsize 
      #__bar_scrollstep
      #__bar_direction 
      
      ;#__bar_arrowSize 
      ;#__bar_reverse
      
       #__bar_ticks
      #__bar_vertical
      #__bar_child
    EndEnumeration
     
    #__bar_nobuttons = #__flag_nobuttons
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
;     #__window_nogadget = #__flag_nobuttons
;     #__window_borderless = #__flag_borderless
;     #__window_systemmenu = #__flag_systemmenu
;     #__window_sizegadget = #__flag_sizegadget
;     #__window_screencentered = #__align_center
    
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
    
    
    ;- _c_tree
    ;#__tree_collapsed = #__flag_collapsed
    #__tree_optionboxes = #__flag_optionboxes
    #__tree_alwaysselection = #__flag_alwaysselection
    #__tree_checkboxes = #__flag_checkboxes
    #__tree_nolines = #__flag_nolines
    #__tree_nobuttons = #__flag_nobuttons
    #__tree_gridlines = #__flag_gridLines
    #__tree_threestate = #__flag_threeState
    #__tree_borderless = #__flag_borderless
    
    ;- _c_tree_attribute
    #__tree_SubLevel  = #PB_Tree_SubLevel   ; 1
    #__tree_Selected  = #PB_Tree_Selected   ; 1
    #__tree_Expanded  = #PB_Tree_Expanded   ; 2
    #__tree_checked   = #PB_Tree_Checked    ; 4
    #__tree_collapsed = #PB_Tree_Collapsed  ; 8
    #__tree_Inbetween = #PB_Tree_Inbetween  ; 16
    
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
    #__listview_clickselect = #__flag_clickselect
    #__listview_multiselect = #__flag_multiselect
   
    ;- _c_editor
    ;#__editor_inline = #__flag_InLine
    #__editor_wordwrap = #__flag_wordwrap
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
    #__button_multiline = #__text_multiline;#__text_wordwrap
    
    
    If (#__flag_limit>>1) > 2147483647 ; 8589934592
      Debug "Исчерпан лимит в x32 ("+Str(#__flag_limit>>1)+")"
    EndIf
    
    
    
    ;- _c_event
    
    Enumeration #PB_EventType_FirstCustomValue
      CompilerIf Not Defined(PB_EventType_resize, #PB_Constant)
        #PB_EventType_Resize
      CompilerEndIf
      CompilerIf Not Defined(PB_EventType_returnKey, #PB_Constant)
        #PB_EventType_returnKey
      CompilerEndIf
      
      #__Event_Free         
      #__Event_create
      #__Event_Drop
      
      #__Event_repaint
      #__Event_ScrollChange
      
      #__Event_closeWindow
      #__Event_MaximizeWindow
      #__Event_MinimizeWindow
      #__Event_restoreWindow
    EndEnumeration
    
    #PB_EventType_Free     = #__Event_Free    
    #PB_EventType_create   = #__Event_create
    #PB_EventType_Drop     = #__Event_Drop
    
    
    #PB_EventType_repaint      = #__Event_repaint
    #PB_EventType_ScrollChange = #__Event_ScrollChange
    
    #PB_EventType_closeWindow  = #__Event_closeWindow
    #PB_EventType_MaximizeWindow = #__Event_MaximizeWindow
    #PB_EventType_MinimizeWindow = #__Event_MinimizeWindow
    #PB_EventType_restoreWindow  =#__Event_restoreWindow
    
    
    #__Event_MouseEnter       = #PB_EventType_MouseEnter       ; The mouse cursor entered the gadget
    #__Event_MouseLeave       = #PB_EventType_MouseLeave       ; The mouse cursor left the gadget
    #__Event_MouseMove        = #PB_EventType_MouseMove        ; The mouse cursor moved
    #__Event_MouseWheel       = #PB_EventType_MouseWheel       ; The mouse wheel was moved
    #__Event_leftButtonDown   = #PB_EventType_LeftButtonDown   ; The left mouse button was pressed
    #__Event_leftButtonUp     = #PB_EventType_LeftButtonUp     ; The left mouse button was released
    #__Event_leftClick        = #PB_EventType_LeftClick        ; A click With the left mouse button
    #__Event_leftDoubleClick  = #PB_EventType_LeftDoubleClick  ; A double-click With the left mouse button
    #__Event_rightButtonDown  = #PB_EventType_RightButtonDown  ; The right mouse button was pressed
    #__Event_rightButtonUp    = #PB_EventType_RightButtonUp    ; The right mouse button was released
    #__Event_rightClick       = #PB_EventType_RightClick       ; A click With the right mouse button
    #__Event_rightDoubleClick = #PB_EventType_RightDoubleClick ; A double-click With the right mouse button
    #__Event_MiddleButtonDown = #PB_EventType_MiddleButtonDown ; The middle mouse button was pressed
    #__Event_MiddleButtonUp   = #PB_EventType_MiddleButtonUp   ; The middle mouse button was released
    #__Event_Focus            = #PB_EventType_Focus            ; The gadget gained keyboard focus
    #__Event_lostFocus        = #PB_EventType_LostFocus        ; The gadget lost keyboard focus
    #__Event_KeyDown          = #PB_EventType_KeyDown          ; A key was pressed
    #__Event_KeyUp            = #PB_EventType_KeyUp            ; A key was released
    #__Event_Input            = #PB_EventType_Input            ; Text input was generated
    #__Event_resize           = #PB_EventType_Resize           ; The gadget has been resized
    #__Event_StatusChange     = #PB_EventType_StatusChange
    #__Event_titleChange      = #PB_EventType_TitleChange
    #__Event_change           = #PB_EventType_Change
    #__Event_DragStart        = #PB_EventType_DragStart
    #__Event_returnKey        = #PB_EventType_returnKey
    
    #PB_Event_create = #PB_Event_FirstCustomValue
    
    ;- _c_type
    #PB_GadgetType_tabBar = 100
    #PB_GadgetType_tree_Properties = 127
    
    #__type_root          =- 5
    #__type_Property      =- 4
    #__type_Popup         =- 3
    #__type_Menu          =- 2
    #__type_Window        =- 1
    #__type_tabBar        = #PB_GadgetType_tabBar
    
    #__type_Unknown       = #PB_GadgetType_Unknown
    #__type_button        = #PB_GadgetType_Button
    #__type_buttonImage   = #PB_GadgetType_ButtonImage
    #__type_calendar      = #PB_GadgetType_Calendar
    #__type_canvas        = #PB_GadgetType_Canvas
    #__type_checkBox      = #PB_GadgetType_CheckBox
    #__type_comboBox      = #PB_GadgetType_ComboBox
    #__type_container     = #PB_GadgetType_Container
    #__type_Date          = #PB_GadgetType_Date
    #__type_Editor        = #PB_GadgetType_Editor
    #__type_ExplorerCombo = #PB_GadgetType_ExplorerCombo
    #__type_ExplorerList  = #PB_GadgetType_ExplorerList
    #__type_ExplorerTree  = #PB_GadgetType_ExplorerTree
    #__type_Frame         = #PB_GadgetType_Frame
    #__type_HyperLink     = #PB_GadgetType_HyperLink
    #__type_Image         = #PB_GadgetType_Image
    #__type_IPAddress     = #PB_GadgetType_IPAddress
    #__type_listIcon      = #PB_GadgetType_ListIcon
    #__type_listView      = #PB_GadgetType_ListView
    #__type_MDI           = #PB_GadgetType_MDI
    #__type_Option        = #PB_GadgetType_Option
    #__type_Panel         = #PB_GadgetType_Panel
    #__type_ProgressBar   = #PB_GadgetType_ProgressBar
    #__type_Scintilla     = #PB_GadgetType_Scintilla
    #__type_ScrollArea    = #PB_GadgetType_ScrollArea
    #__type_ScrollBar     = #PB_GadgetType_ScrollBar
    #__type_Shortcut      = #PB_GadgetType_Shortcut
    #__type_Spin          = #PB_GadgetType_Spin
    #__type_Splitter      = #PB_GadgetType_Splitter
    #__type_String        = #PB_GadgetType_String
    #__type_text          = #PB_GadgetType_Text
    #__type_trackBar      = #PB_GadgetType_TrackBar
    #__type_tree          = #PB_GadgetType_Tree
    #__type_Web           = #PB_GadgetType_Web
    #__type_OpenGL        = #PB_GadgetType_OpenGL
    #__type_tree_Properties    = #PB_GadgetType_tree_Properties
    ;}
    
  EndDeclareModule 
  
  
  Module Constants
    
  EndModule 
  
  ;UseModule Constants
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP