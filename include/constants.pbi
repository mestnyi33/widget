CompilerIf Not Defined(constants, #PB_Module)
  DeclareModule constants
    Macro _check_(_variable_, _constant_, _state_=#True)
      Bool(_state_ = Bool(((_variable_) & _constant_) = _constant_))
    EndMacro
    
    ;- - CONSTANTs
    ;{
    
    Enumeration 
      #__action_create
      #__action_add_items
    EndEnumeration
    
    Enumeration -1
      #SelectionStyle_Default
      #SelectionStyle_None
      #SelectionStyle_Solid
      #SelectionStyle_Dotted
      #SelectionStyle_Dashed
    EndEnumeration
    #SelectionStyle_Mode       = $100
    #SelectionStyle_Completely = 0
    #SelectionStyle_Partially  = $100
    #SelectionStyle_Ignore = #PB_Ignore
    
    Enumeration 1
      #Boundary_MinX
      #Boundary_MinY
      #Boundary_MaxX
      #Boundary_MaxY
      #Boundary_MinWidth
      #Boundary_MinHeight
      #Boundary_MaxWidth
      #Boundary_MaxHeight
    EndEnumeration
    #Boundary_Ignore          = -$80000000    ; 0b10000000...
    #Boundary_Default         = -$7FFFFFFF    ; 0b01111111...
    #Boundary_None            =  $3FFFFFFF    ; 0b00111111...
    #Boundary_ParentSize      =  $60000000    ; 0b01100000...
    #Boundary_ParentSizeMask  =  $C0000000    ; 0b11000000...
    
    Enumeration 
      #_b_caption
      #_b_Menu
      #_b_tool
    EndEnumeration
    
    ; list mode
    #__M_checkselect = 1
    #__M_clickselect = 2
    #__M_Multiselect = 3
    #__M_optionselect = 4
    
    ;- _c_anchors
    #__a_Left = 1
    #__a_Right = 3
    #__a_top = 2
    #__a_bottom = 4
    #__a_Left_top = 5
    #__a_Left_bottom = 8
    #__a_Right_top = 6
    #__a_Right_bottom = 7
    
    #__a_Line_Left = 10
    #__a_Line_Right = 11
    #__a_Line_top = 12
    #__a_Line_bottom = 13
    
    ; a_Mode_
    EnumerationBinary 1
      #__a_position
      #__a_width
      #__a_height
      #__a_corner
    EndEnumeration
    #__a_edge = #__a_width | #__a_height
    #__a_full  = #__a_position | #__a_corner | #__a_edge
    
    #__a_size  = 7
    #__a_Moved = 9
    #__a_count = #__a_Moved+4
    
    ;
    ; default values 
    ;
    #__window_frame_size = 4 
    #__window_caption_height = 24
    #__border_scroll = 10
    
    #__panel_height = 24 ;+ 4
    #__panel_width = 85
    
    #__Menu_height = 25
    
    #__from_Mouse_state = 0
    #__focus_state = 1
    
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
    
    #__bar_Minus = 1
    
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
    
    
    #__tree_Linesize = 5
    
    ; errors
    Enumeration 1
      #__error_text_input
      #__error_text_back
      #__error_text_Return
    EndEnumeration
    
    ;images
    Enumeration
      #__img_Released = 1
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
      #__wb_Maxi
      #__wb_Mini
      #__wb_help
    EndEnumeration
    
    ;- coordinate 
    Enumeration _c_coordinate
      ; pos & size
      #__c_screen    = 0 ; screen
      #__c_frame     = 1 ; frame screen
      #__c_inner     = 2 ; inner screen
      #__c_container = 3 ; container
      #__c_Required  = 4 ; required
      
      #__c_draw      = 5 ; clip screen
      #__c_draw1     = 6 ; clip frame 
      #__c_draw2     = 7 ; clip inner 
      
      #__c_window    = 8 ; window ; pos
      #__c_Rootrestore = 9
      #__c
    EndEnumeration
    
    ;
    #__c_clip = #__c_draw ; temp
    #__c_clip2 = #__c_draw2 ; temp
    
    ;#__c_inner2 = #__c_inner
    ;     #__ci_frame = #__c_draw
    ;     #__ci_container = #__c_draw
    #__c_inner_b = #__c_inner
    
    ;- temp for the widgets.pbi
    Enumeration
      #__s_normal      = 0<<0  ; 0
      #__s_select    = 1<<0    ; 1
      #__s_expand    = 1<<1    ; 2
      #__s_check     = 1<<2    ; 4
      #__s_collapse   = 1<<3   ; 8
      #__s_inbetween   = 1<<4  ; 16
      
      #__s_enter     = 1<<5  ; 32
      #__s_disable    = 1<<6 ; 64
      #__s_focus     = 1<<7  ; 128 ; keyboard focus
      #__s_scroll    = 1<<8  ; 256
      
      #__s_drag     = 1<<9  ; 512
      #__s_drop   = 1<<10
      #__s_current     = 1<<11 ;
    EndEnumeration
    
    ; \__state
    EnumerationBinary 1
      #__ss_front
      #__ss_back
      #__ss_frame
      #__ss_fore
      #__ss_Line
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
      #__color_Line
      #__color_titlefront
      #__color_titleback
      #__color_graytext 
      #__color_frame
      #__color_fore
    EndEnumeration
    
    Enumeration 
      #__color_state_default
      #__color_state_entered
      #__color_state_selected
    EndEnumeration
    
    ;
    ;   ; Set/Get Attribute
    #__displayMode = 1<<13
    ;   #PB_Image = 1<<13
    ;   #PB_text = 1<<14
    ;   #PB_flag = 1<<15
    ;   #PB_State = 1<<16
    
    ;- _c_Resize
    EnumerationBinary 
      #__Resize_x
      #__Resize_y
      #__Resize_width
      #__Resize_height
      
      #__Resize_change
      
      #__Resize_Restore
      #__Resize_Minimize
      #__Resize_Maximize
      #__Resize_start
    EndEnumeration
    
    ;- Constant create-flags
    EnumerationBinary _c_align 8 ; 2
      #__flag_vertical           ;= 1
      
      #__flag_Left
      #__flag_top
      #__flag_Right
      #__flag_bottom
      #__flag_center
      
      #__flag_full
      #__flag_proportional
      
      
      #__flag_numeric
      #__flag_Readonly
      #__flag_Lowercase 
      #__flag_uppercase
      #__flag_password
      #__flag_wordwrap
      #__flag_Multiline 
      
      #__flag_fullselection
      #__flag_nolines
      #__flag_nobuttons
      #__flag_checkboxes 
      #__flag_optionboxes
      #__flag_gridlines
      
      
      ;#__flag_inline
      #__flag_threeState
      #__flag_clickselect 
      
      
      
      #__flag_invert
      #__flag_autosize
      ;#__flag_invisible
      ;#__flag_sizegadget
      ;#__flag_systemmenu
      #__flag_noscrollbars
      #__flag_child
      
      #__flag_borderless
      ;#__flag_flat
      ;#__flag_double
      ;#__flag_Raised
      ;#__flag_single
      
      
      #__flag_transparent
      #__flag_anchorsgadget
      #__flag_Limit
    EndEnumeration
    
    ;#__flag_checkboxes = #__flag_clickselect
    #__flag_nogadgets = #__flag_nobuttons
    ;#__flag_Multiselect = #__flag_Multiline
    
    #__flag_default = #__flag_nolines|#__flag_nobuttons|#__flag_checkboxes
    #__flag_alwaysselection = #__flag_Lowercase|#__flag_uppercase
    
    #__flag_autoright = #__flag_autosize|#__flag_Right
    #__flag_autobottom = #__flag_autosize|#__flag_bottom
    
    
    ;- _c_align
    ; align type
    #__align_widget                  = 1
    #__align_text                    = 2
    #__align_image                   = 3
    
    #__align_none                    = #False
    #__align_Left                    = #__flag_Left
    #__align_top                     = #__flag_top  
    #__align_Right                   = #__flag_Right
    #__align_bottom                  = #__flag_bottom
    #__align_center                  = #__flag_center
    
    #__align_full                    = #__flag_full
    #__align_auto                    = #__flag_autosize
    #__align_proportional_horizontal = #__flag_proportional
    #__align_proportional_vertical   = #__flag_vertical
    
    
    #__align_full_Left = #__align_Left | #__align_top | #__align_bottom
    #__align_full_Right = #__align_Right | #__align_top | #__align_bottom
    #__align_full_top = #__align_top | #__align_Left | #__align_Right
    #__align_full_bottom = #__align_bottom | #__align_Left | #__align_Right
    
    
    #__align_Left_proportional       = #__align_Left   |#__align_proportional_horizontal
    #__align_top_proportional        = #__align_top    |#__align_proportional_vertical
    #__align_Right_proportional      = #__align_Right  |#__align_proportional_horizontal
    #__align_bottom_proportional     = #__align_bottom |#__align_proportional_vertical
    
    #__align_Left_Right_proportional = #__align_Left   |#__align_Right  |#__align_proportional_horizontal
    #__align_top_bottom_proportional = #__align_top    |#__align_bottom |#__align_proportional_vertical
    
    
    #__align_proportional = 3
    
    ;;#__align_full = 0;#__align_Left|#__align_top|#__align_Right|#__align_bottom
    
    
    ;-
    ;- _c_bar
    #__bar_Minimum = 1
    #__bar_Maximum = 2
    #__bar_pagelength = 3
    #__bar_scrollstep = 5
    
    EnumerationBinary 8
      #__bar_buttonsize 
      #__bar_direction 
      
      ;#__bar_arrowSize 
      ;#__bar_Reverse
      ;#__bar_ticks
      
      #__bar_vertical ;= #__flag_vertical
      #__bar_invert = #__flag_invert
      ; #__bar_nobuttons = #__flag_nogadgets
    EndEnumeration
    
    
    #__alignFlagCount = 22
    #__alignFlagValue = 2147483648 >> ( #__alignFlagCount - 1 )
    
    EnumerationBinary #__alignFlagValue
      ;EnumerationBinary 64
      #__align_text_Left 
      #__align_text_top
      #__align_text_center
      #__align_text_Right 
      #__align_text_bottom 
      
      #__align_image_Left 
      #__align_image_top
      #__align_image_center
      #__align_image_Right 
      #__align_image_bottom 
      #__align_image_full
      
      #__align_image_proportional
      #__align_image_proportional_vertical
      
      #__align_widget_Left 
      #__align_widget_top
      #__align_widget_center
      #__align_widget_Right 
      #__align_widget_bottom 
      #__align_widget_auto
      #__align_widget_full
      
      #__align_widget_proportional
      #__align_widget_proportional_vertical
    EndEnumeration
    
    ;     #__ImageFlagCount = 2
    ;     #__imageFlagValue = 2147483648 >> ( #__imageFlagCount - 1 )
    ;     
    ;     EnumerationBinary #__imageFlagValue
    ;       #__image_vertical 
    ;       #__image_invert 
    ;     EndEnumeration
    
    ;-  Constant sel-edit
    #__sel_to_line = 1
    #__sel_to_first = 2
    #__sel_to_remove = - 1
    #__sel_to_last = - 2
    #__sel_to_set = 5
    
    ;- _c_text
    #__textFlagCount = 10
    #__textFlagValue = 2147483648 >> ( #__textFlagCount - 1 )
    
    EnumerationBinary #__align_text_bottom ; #__textFlagValue
      #__text_vertical 
      #__text_invert 
      
      #__text_InLine 
      #__text_Multiline 
      #__text_wordwrap 
      
      #__text_password 
      #__text_Readonly 
      #__text_uppercase 
      #__text_Lowercase 
      #__text_numeric 
    EndEnumeration
    
    ;     CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    ;       Debug #PB_Text_Right         ; 1  ; 2         ; 
    ;       Debug #PB_Text_Center        ; 2  ; 1         ; 
    ;       Debug #PB_Text_Border        ; 4  ; 131072    ; 
    ;       
    ;       Debug #PB_Button_Right       ; 1  ; 512       ; 
    ;       Debug #PB_Button_Left        ; 2  ; 256       ; 
    ;       Debug #PB_Button_Toggle      ; 4  ; 4099      ; 
    ;       Debug #PB_Button_Default     ; 8  ; 1         ; 
    ;       Debug #PB_Button_MultiLine   ; 16 ; 8192      ; 
    ;       
    ;       Debug #PB_String_Password    ; 1  ; 32        ; 
    ;       Debug #PB_String_ReadOnly    ; 2  ; 2048      ; 
    ;       Debug #PB_String_UpperCase   ; 4  ; 8         ; 
    ;       Debug #PB_String_LowerCase   ; 8  ; 16        ; 
    ;       Debug #PB_String_Numeric     ; 16 ; 8192      ; 
    ;       Debug #PB_String_BorderLess  ; 32 ; 131072    ; 
    ;       
    ;       Debug #PB_Editor_ReadOnly    ; 1  ; 2048      ; 
    ;       Debug #PB_Editor_WordWrap    ; 2  ; 268435456 ; 
    ;     CompilerEndIf
    
    #__text_border = #__flag_borderless;#PB_text_border
    
    #__text_Left = #__align_text_Left
    #__text_top = #__align_text_top
    #__text_center = #__align_text_center
    #__text_Right = #__align_text_Right
    #__text_bottom = #__align_text_bottom
    #__text_Middle = #__text_center
    
    ;     #__text_invert = #__flag_invert
    ;     #__text_vertical = #__flag_vertical
    ;     
    ;     #__text_Multiline = #__flag_Multiline
    ;     #__text_wordwrap = #__flag_wordwrap
    ;     #__text_numeric = #__flag_numeric
    ;     #__text_password = #__flag_password
    ;     #__text_Readonly = #__flag_Readonly
    ;     #__text_Lowercase = #__flag_Lowercase
    ;     #__text_uppercase = #__flag_uppercase
    
    #__image_Left = #__text_Left
    #__image_top = #__text_top
    #__image_center = #__text_center
    #__image_Right = #__text_Right
    #__image_bottom = #__text_bottom
    
    ;- _c_Mdi
    #__Mdi_editable = #__flag_anchorsgadget ; win - 4294967296
    
    ;- _c_window
    ;     #__window_nogadgets = #__flag_nobuttons
    ;     #__window_borderless = #__flag_borderless
    ;     #__window_systemmenu = #__flag_systemmenu
    ;     #__window_sizegadget = #__flag_sizegadget
    ;     #__window_screencentered = #__align_center
    
    #__window_child          = #__flag_child
    #__Window_Normal         = #PB_Window_Normal
    #__Window_SystemMenu     = #PB_Window_SystemMenu     ; Enables the system menu on the window title bar (Default).
    #__Window_Close          = #__Window_SystemMenu
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
                                                         ;#PB_Window                 = #PB_Window_NoActivate<<2
    
    ;-  SPIN
    #__spin_padding_text = 3
    #__spin_buttonsize = #__scroll_buttonsize + 3
    
    #__spin_TextLeft = #__text_Left
    #__spin_TextRight = #__text_Right
    #__spin_TextCenter = #__text_center
    
    #__spin_Numeric = #__text_numeric
    #__spin_Vertical = #__bar_vertical
    #__spin_Left = 1<<1
    #__spin_Right = 1<<2
    #__spin_Plus = 1<<3
    
    ;     ;- 
    ; Debug #PB_Checkbox_Unchecked ; 0
    ; Debug #PB_Checkbox_Checked   ; 1
    ; Debug #PB_Checkbox_Inbetween ; -1
    ; Debug #PB_CheckBox_ThreeState ; 4
    
    
    ;- LIST_ELEMENT
    ;     CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    ;       Debug #PB_ListView_MultiSelect  ; 1
    ;       Debug #PB_ListView_ClickSelect  ; 2
    
    ;       Debug #PB_Tree_AlwaysShowSelection ; 0
    ;       Debug #PB_Tree_NoLines    ; 1
    ;       Debug #PB_Tree_Selected   ; 1
    ;       Debug #PB_Tree_SubLevel   ; 1
    ;       Debug #PB_Tree_NoButtons  ; 2
    ;       Debug #PB_Tree_Expanded   ; 2
    ;       Debug #PB_Tree_CheckBoxes ; 4
    ;       Debug #PB_Tree_Checked    ; 4
    ;       Debug #PB_Tree_ThreeState ; 8
    ;       Debug #PB_Tree_Collapsed  ; 8
    ;       Debug #PB_Tree_Inbetween  ; 16
    
    ;       Debug #PB_ListIcon_AlwaysShowSelection ; 0
    ;       Debug #PB_ListIcon_Selected   ; 1
    ;       Debug #PB_ListIcon_CheckBoxes ; 2
    ;       Debug #PB_ListIcon_Checked    ; 2
    ;       Debug #PB_ListIcon_Inbetween  ; 4
    ;       Debug #PB_ListIcon_ThreeState ; 8
    ;     CompilerEndIf
    
    #__ListFlagCount = 10
    #__ListFlagValue = 2147483648 >> ( #__ListFlagCount - 1 )
    
    EnumerationBinary #__ListFlagValue
      #__List_vertical   
      #__List_NoLines    
      #__List_SubLevel   
      #__List_NoButtons  
      #__List_CheckBoxes 
      #__List_ThreeState 
      
      #__List_ClickSelect
      #__List_MultiSelect
      
      #__List_Collapsed  
      #__List_Expanded   
      ;       #__List_Checked    
      ;       #__List_Selected   
      ;       #__List_Inbetween 
    EndEnumeration
    
    ;- _c_tree
    #PB_Tree_Collapse = 32
    #PB_Tree_OptionBoxes = 64
    #PB_Tree_GridLines = 128
    ;#PB_Tree_ItemPosition = 256
    
    #__tree_alwaysselection = #__flag_alwaysselection
    #__tree_nolines = #PB_Tree_NoLines ; #__flag_nolines
    #__tree_nobuttons = #PB_Tree_NoButtons ; #__flag_nogadgets
    #__tree_checkboxes = #PB_Tree_CheckBoxes ; #__flag_checkboxes
    #__tree_threestate = #PB_Tree_ThreeState ; #__flag_threeState
    #__tree_optionboxes = #PB_Tree_OptionBoxes ; #__flag_optionboxes
    #__tree_gridlines = #PB_Tree_GridLines     ; #__flag_gridLines
    #__tree_Multiselect = #__flag_Multiline
    #__tree_clickselect = #__flag_clickselect
    #__tree_collapse = #PB_Tree_Collapse
    
    #__tree_property = #__flag_numeric
    #__tree_Listview = #__flag_Readonly
    #__tree_toolbar = #__flag_password
    
    ; tree attribute
    #__tree_sublevel  = #PB_Tree_SubLevel   ; 1
    
    ; tree state
    #__tree_selected  = #PB_Tree_Selected   ; 1 
    #__tree_expanded  = #PB_Tree_Expanded   ; 2
    #__tree_checked   = #PB_Tree_Checked    ; 4
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
    
    ;- _c_Listview
    #__Listview_clickselect = #__tree_clickselect
    #__Listview_Multiselect = #__tree_Multiselect
    
    ;- _c_editor
    ;#__editor_inline = #__flag_InLine
    #__editor_Readonly = #__text_Readonly
    #__editor_wordwrap = #__text_wordwrap
    #__editor_nomultiline = #__flag_nolines
    #__editor_numeric = #__flag_numeric|#__text_Multiline
    #__editor_fullselection = #__flag_fullselection
    #__editor_alwaysselection = #__flag_alwaysselection
    #__editor_gridlines = #__flag_gridLines
    #__editor_borderless = #__flag_borderless
    
    ;- _c_string
    #__string_Right = #__text_Right
    #__string_center = #__text_center
    #__string_numeric = #__text_numeric
    #__string_password = #__text_password
    #__string_Readonly = #__text_Readonly
    #__string_uppercase = #__text_uppercase
    #__string_Lowercase = #__text_Lowercase
    #__string_borderless = #__flag_borderless
    #__string_Multiline = #__text_Multiline
    
    ;- _c_button
    #__button_Left = #__text_Left
    #__button_Right = #__text_Right
    #__button_toggle = #__flag_threeState ; #__flag_collapsed
    #__button_default = #__flag_default
    #__button_vertical = #__text_vertical
    ;#__button_invert = #__flag_invert
    #__button_Multiline = #__text_wordwrap
    
    
    If (#__flag_Limit>>1) > 2147483647 ; 8589934592
      Debug "Исчерпан лимит в x32 ("+Str(#__flag_Limit>>1)+")"
    EndIf
    
    
    ;- Constant event-type
    Enumeration #PB_EventType_FirstCustomValue
      CompilerIf Not Defined(PB_EventType_Resize, #PB_Constant)
        #PB_EventType_Resize
      CompilerEndIf
      CompilerIf Not Defined(PB_EventType_ReturnKey, #PB_Constant)
        #PB_EventType_ReturnKey
      CompilerEndIf
      
      #PB_EventType_ResizeBegin
      #PB_EventType_ResizeEnd
      
      #PB_EventType_Draw
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
      
      #PB_EventType_Left3Click
      #PB_EventType_Right3Click
      
      #PB_EventType_MouseStatus ; temp
      #PB_EventType_StatusChangeEdit
      ;       #PB_EventType_TimerStart
      ;       #PB_EventType_TimerStop
      ;;;; #PB_EventType_ColorChange
     ; #PB_EventType_CursorUpdate
      #PB_EventType_CursorChange
    EndEnumeration
    
    #__event_Free             = #PB_EventType_Free    
    #__event_Drop             = #PB_EventType_Drop
    #__event_Create           = #PB_EventType_Create
    #__event_Sizeitem         = #PB_EventType_SizeItem
    
    #__event_Repaint          = #PB_EventType_Repaint
    #__event_ResizeEnd        = #PB_EventType_ResizeEnd
    #__event_ScrollChange     = #PB_EventType_ScrollChange
    
    #__event_CloseWindow      = #PB_EventType_CloseWindow
    #__event_Maximizewindow   = #PB_EventType_MaximizeWindow
    #__event_Minimizewindow   = #PB_EventType_MinimizeWindow
    #__event_Restorewindow    = #PB_EventType_RestoreWindow
    
    #__event_MouseEnter       = #PB_EventType_MouseEnter       ; The mouse cursor entered the gadget
    #__event_MouseLeave       = #PB_EventType_MouseLeave       ; The mouse cursor left the gadget
    #__event_MouseMove        = #PB_EventType_MouseMove        ; The mouse cursor moved
    #__event_MouseWheel       = #PB_EventType_MouseWheel       ; The mouse wheel was moved
    #__event_LeftButtonDown   = #PB_EventType_LeftButtonDown   ; The left mouse button was pressed
    #__event_LeftButtonUp     = #PB_EventType_LeftButtonUp     ; The left mouse button was released
    #__event_LeftDoubleClick  = #PB_EventType_LeftDoubleClick  ; A double-click With the left mouse button
    #__event_Left3Click       = #PB_EventType_Left3Click       ; A click With the left mouse button
    #__event_Left2Click       = #PB_EventType_LeftDoubleClick  ; A double-click With the left mouse button
    #__event_LeftClick        = #PB_EventType_LeftClick        ; A click With the left mouse button
    
    #__event_RightButtonDown  = #PB_EventType_RightButtonDown  ; The right mouse button was pressed
    #__event_RightButtonUp    = #PB_EventType_RightButtonUp    ; The right mouse button was released
    #__event_RightDoubleClick = #PB_EventType_RightDoubleClick ; A double-click With the right mouse button
    #__event_Right3Click       = #PB_EventType_Right3Click       ; A click With the right mouse button
    #__event_Right2Click = #PB_EventType_RightDoubleClick ; A double-click With the right mouse button
    #__event_RightClick       = #PB_EventType_RightClick       ; A click With the right mouse button
    
    #__event_MiddleButtonDown = #PB_EventType_MiddleButtonDown ; The middle mouse button was pressed
    #__event_MiddleButtonUp   = #PB_EventType_MiddleButtonUp   ; The middle mouse button was released
    #__event_Focus            = #PB_EventType_Focus            ; The gadget gained keyboard focus
    #__event_LostFocus        = #PB_EventType_LostFocus        ; The gadget lost keyboard focus
    #__event_KeyDown          = #PB_EventType_KeyDown          ; A key was pressed
    #__event_KeyUp            = #PB_EventType_KeyUp            ; A key was released
    #__event_Input            = #PB_EventType_Input            ; Text input was generated
    #__event_Resize           = #PB_EventType_Resize           ; The gadget has been resized
    #__event_StatusChange     = #PB_EventType_StatusChange
    #__event_TitleChange      = #PB_EventType_TitleChange
    #__event_Change           = #PB_EventType_Change
    #__event_DragStart        = #PB_EventType_DragStart
    #__event_ReturnKey        = #PB_EventType_ReturnKey
    #__event_CloseItem        = #PB_EventType_CloseItem
    
    #__event_Down             = #PB_EventType_Down
    #__event_Up               = #PB_EventType_Up
    
    #__event_MouseWheelX      = #PB_EventType_MouseWheelX
    #__event_MouseWheelY      = #PB_EventType_MouseWheelY
    
    #__event_Draw             = #PB_EventType_Draw
    
    
    ;- Constant create-type
    Enumeration - 1
      #__Type_All          
      #__Type_Unknown       = #PB_GadgetType_Unknown       ; 0
      #__Type_Button        = #PB_GadgetType_Button        ; 1
      #__Type_String        = #PB_GadgetType_String        ; 2
      #__Type_Text          = #PB_GadgetType_Text          ; 3
      #__Type_CheckBox      = #PB_GadgetType_CheckBox      ; 4
      #__Type_Option        = #PB_GadgetType_Option        ; 5
      #__Type_ListView      = #PB_GadgetType_ListView      ; 6
      #__Type_Frame         = #PB_GadgetType_Frame         ; 7
      #__Type_ComboBox      = #PB_GadgetType_ComboBox      ; 8
      #__Type_Image         = #PB_GadgetType_Image         ; 9
      #__Type_HyperLink     = #PB_GadgetType_HyperLink     ; 10
      #__Type_Container     = #PB_GadgetType_Container     ; 11
      #__Type_ListIcon      = #PB_GadgetType_ListIcon      ; 12
      #__Type_IPAddress     = #PB_GadgetType_IPAddress     ; 13
      #__Type_ProgressBar   = #PB_GadgetType_ProgressBar   ; 14
      #__Type_ScrollBar     = #PB_GadgetType_ScrollBar     ; 15
      #__Type_ScrollArea    = #PB_GadgetType_ScrollArea    ; 16
      #__Type_TrackBar      = #PB_GadgetType_TrackBar      ; 17
      #__Type_Web           = #PB_GadgetType_Web           ; 18
      #__Type_ButtonImage   = #PB_GadgetType_ButtonImage   ; 19
      #__Type_Calendar      = #PB_GadgetType_Calendar      ; 20
      #__Type_Date          = #PB_GadgetType_Date          ; 21
      #__Type_Editor        = #PB_GadgetType_Editor        ; 22
      #__Type_ExplorerList  = #PB_GadgetType_ExplorerList  ; 23
      #__Type_ExplorerTree  = #PB_GadgetType_ExplorerTree  ; 24
      #__Type_ExplorerCombo = #PB_GadgetType_ExplorerCombo ; 25
      #__Type_Spin          = #PB_GadgetType_Spin          ; 26
      #__Type_Tree          = #PB_GadgetType_Tree          ; 27
      #__Type_Panel         = #PB_GadgetType_Panel         ; 28
      #__Type_Splitter      = #PB_GadgetType_Splitter      ; 29
      #__Type_MDI           = #PB_GadgetType_MDI           ; 30
      #__Type_Scintilla     = #PB_GadgetType_Scintilla     ; 31
      #__Type_Shortcut      = #PB_GadgetType_Shortcut      ; 32
      #__Type_Canvas        = #PB_GadgetType_Canvas        ; 33
      #__Type_OpenGL        = #PB_GadgetType_OpenGL        ; 34
      
      #__Type_TabBar        = 50
      #__Type_ToolBar       
      #__Type_StatusBar 
      
      #__Type_Toggled
      #__Type_Property 
      #__Type_ImageButton
      #__Type_StringButton
      
      #__Type_Menu            
      #__Type_PopupMenu
      #__Type_Window          
      #__Type_Message   
      #__Type_Root      
      
      #__Type_Hiasm 
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
    
    
    #__text_update =- 124
    
    #debug = 0
    #debug_draw_font = #debug
    #debug_draw_font_change = #debug
    #debug_draw_item_font_change = #debug
    #__debug_events_tab = 0
    
    #__draw_scroll_box = 0
    #__test_scrollbar_size = 0
    
    #debug_update_text = 0
    #debug_Multiline = 0
    #debug_Repaint = 0 ; Debug " - -  Canvas repaint - -  "
                       ;-
                       ;- GLOBAL
                       ;-
    
    Global test_draw_box_clip_type = #PB_All
    Global test_draw_box_clip1_type = #PB_All
    Global test_draw_box_clip2_type = #PB_All
    
    Global test_draw_box_screen_type ;= #PB_All
    Global test_draw_box_inner_type  ;= #PB_All
    Global test_draw_box_frame_type  ;= #PB_All
    
    ;     test_draw_box_clip_type = #__Type_Listview
    ;     test_draw_box_clip1_type = #__Type_Listview
    ;     test_draw_box_clip2_type = #__Type_Listview
    
    ;     test_draw_box_clip_type = #__Type_tree
    ;     test_draw_box_clip1_type = #__Type_tree
    ;     test_draw_box_clip2_type = #__Type_tree
    ;     
    ;     test_draw_box_clip_type = #__Type_Mdi
    ;     test_draw_box_clip1_type = #__Type_Mdi
    ;     test_draw_box_clip2_type = #__Type_Mdi
    
    ;     test_draw_box_clip_type = #__Type_scrollarea
    ;     test_draw_box_clip1_type = #__Type_scrollarea
    ;     test_draw_box_clip2_type = #__Type_scrollarea
    
    
    test_draw_box_clip_type = #__Type_scrollbar
    test_draw_box_clip1_type = #__Type_scrollbar
    test_draw_box_clip2_type = #__Type_scrollbar
    
    
    
    
    
    
    
    
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
    ; ;       #__flag_Limit
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
    ; ;     Debug #__flag_Limit>>1
    ; ;     If (#__flag_Limit>>1) > 2147483647 ; 8589934592
    ; ;       Debug "Исчерпан лимит в x32 ("+Str(#__flag_Limit>>1)+")"
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
    
    
    CompilerIf Not Defined(PB_ToolBar_Small, #PB_Constant)
      #PB_ToolBar_Small = 1<<0
    CompilerEndIf
    CompilerIf Not Defined(PB_MessageRequester_Info, #PB_Constant)
      #PB_MessageRequester_Info = 1<<2
    CompilerEndIf
    CompilerIf Not Defined(PB_MessageRequester_Error, #PB_Constant)
      #PB_MessageRequester_Error = 1<<3
    CompilerEndIf
    CompilerIf Not Defined(PB_MessageRequester_Warning, #PB_Constant)
      #PB_MessageRequester_Warning = 1<<4
    CompilerEndIf
    CompilerIf Not Defined(PB_Canvas_Container, #PB_Constant)
      #PB_Canvas_Container = 1<<5
    CompilerEndIf
  EndDeclareModule 
  
  
  Module Constants
    
  EndModule 
  
  ;UseModule Constants
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP