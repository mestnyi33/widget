CompilerIf Not Defined(constants, #PB_Module)
  DeclareModule constants
    ;- - CONSTANTs
    ;{
    #__round = 7
    #__draw_clip_box = 0
    #__draw_scroll_box = 1
    #__debug_events_tab = 0
    #__sOC = SizeOf(Character)
    #__border_scroll = 2
    
    #__spin_padding_text = 5
    #__spin_buttonsize2 = 15
    #__spin_buttonsize = 18
    
    Enumeration #PB_Event_FirstCustomValue
      #PB_Event_widget
    EndEnumeration
    
    Enumeration #PB_EventType_FirstCustomValue
      CompilerIf (#PB_Compiler_Version<547) : #PB_EventType_Resize : CompilerEndIf
      
      #PB_EventType_free
      #PB_EventType_create
      #PB_EventType_Drop
      
      #PB_EventType_repaint
      #PB_EventType_ScrollChange
    EndEnumeration
    
    #__anchors = 9+4
    
    #__a_moved = 9
    #__arrow_type = 1
    
    ;bar buttons
    Enumeration
      #__b_1 = 1
      #__b_2 = 2
      #__b_3 = 3
    EndEnumeration
    
    ;bar position
    Enumeration
      #__bp_0 = 0
      #__bp_1 = 1
      #__bp_2 = 2
      #__bp_3 = 3
    EndEnumeration
    
    ;element position
    Enumeration
      #last =- 1
      #first = 0
      #prev = 1
      #next = 2
      #__before = 3
      #__after = 4
    EndEnumeration
    
    ;element coordinate 
    Enumeration
      #__c_0 = 0 ; 
      #__c_1 = 1 ; frame
      #__c_2 = 2 ; inner
      #__c_3 = 3 ; container
      #__c_4 = 4 ; clip
    EndEnumeration
    
    ;color state
    Enumeration
      #__s_0
      #__s_1
      #__s_2
      #__s_3
    EndEnumeration
    
    Enumeration 1
      #__color_front
      #__color_back
      #__color_line
      #__color_titlefront
      #__color_titleback
      #__color_graytext 
      #__color_frame
    EndEnumeration
    
    #PB_GadgetType_popup =- 10
    #PB_GadgetType_property = 40
    #PB_GadgetType_window =- 1
    #PB_GadgetType_root =- 5
    ;
    
    #__flag_vertical = 1
    
    EnumerationBinary _c_align 2
      #__align_left
      #__align_top
      #__align_right
      #__align_bottom
      #__align_center
      #__align_text
      #__flag_autoSize
      
    EndEnumeration
    
    #__align_full = #__align_left|#__align_top|#__align_right|#__align_bottom
    
    EnumerationBinary _c_flag 256 ; 128
      
      #__flag_numeric
      #__flag_readonly
      #__flag_lowercase 
      #__flag_uppercase
      #__flag_password
      #__flag_wordwrap
      #__flag_multiline 
      
      #__flag_inline
      #__flag_nolines
      #__flag_checkboxes
      #__flag_optionboxes
      #__flag_threeState
      #__flag_collapse
      #__flag_gridLines
      #__flag_multiselect
      #__flag_clickselect
      #__flag_fullselection
      
      #__flag_nobuttons
      #__flag_inverted
      
      ; common
      ;#__flag_autoRight
      ;#__flag_autoBottom
      #__flag_noActivate
      ;#__flag_invisible
      #__flag_sizegadget
      #__flag_systemmenu
      #__flag_anchorsGadget
      #__flag_borderless
      ;         #__flag_Double
      ;         #__flag_flat
      ;         #__flag_raised
      ;         #__flag_Single
      
      
      
      #__flag_limit
    EndEnumeration
    
    #__flag_noGadget = #__flag_nobuttons
    #__flag_autoright = #__flag_autosize|#__align_right
    #__flag_autobottom = #__flag_autosize|#__align_bottom
    
    #__flag_default = #__flag_nolines|#__flag_nobuttons|#__flag_checkboxes
    #__flag_alwaysselection = #__flag_lowercase|#__flag_uppercase
    
    ; text
    #__text_left = #__align_text|#__align_left
    #__text_top = #__align_text|#__align_top
    #__text_center = #__align_text|#__align_center
    #__text_right = #__align_text|#__align_right
    #__text_bottom = #__align_text|#__align_bottom
    
    #__text_vertical = #__flag_vertical
    #__text_multiline = #__flag_multiline
    #__text_numeric = #__flag_numeric
    #__text_password = #__flag_password
    #__text_readonly = #__flag_readonly
    #__text_lowercase = #__flag_lowercase
    #__text_uppercase = #__flag_uppercase
    #__text_wordwrap = #__flag_wordwrap
    #__text_invert = #__flag_inverted
    
    ; window
    #__window_nogadget = #__flag_nobuttons
    #__window_borderless = #__flag_borderless
    #__window_systemmenu = #__flag_systemmenu
    #__window_sizegadget = #__flag_sizegadget
    #__window_screencentered = #__align_center
    
    ; tree
    #__tree_collapse = #__flag_collapse
    #__tree_optionboxes = #__flag_optionboxes
    #__tree_alwaysselection = #__flag_alwaysselection
    #__tree_checkboxes = #__flag_checkboxes
    #__tree_nolines = #__flag_nolines
    #__tree_nobuttons = #__flag_nobuttons
    #__tree_gridlines = #__flag_gridLines
    #__tree_threestate = #__flag_threeState
    #__tree_clickselect = #__flag_clickselect
    #__tree_multiselect = #__flag_multiselect
    #__tree_borderless = #__flag_borderless
    
    ; editor
    #__editor_inline = #__flag_InLine
    #__editor_wordwrap = #__flag_wordwrap
    #__editor_numeric = #__flag_numeric
    #__editor_fullselection = #__flag_fullselection
    #__editor_alwaysselection = #__flag_alwaysselection
    #__editor_gridlines = #__flag_gridLines
    #__editor_borderless = #__flag_borderless
    
    ; string
    #__string_right = #__text_right
    #__string_center = #__text_center
    #__string_numeric = #__text_numeric
    #__string_password = #__text_password
    #__string_readonly = #__text_readonly
    #__string_uppercase = #__text_uppercase
    #__string_lowercase = #__text_lowercase
    #__string_borderless = #__flag_borderless
    #__string_multiline = #__text_multiline
    
    ; button
    #__button_left = #__text_left
    #__button_right = #__text_right
    #__button_toggle = #__flag_collapse
    #__button_default = #__flag_default
    #__button_vertical = #__text_vertical
    #__button_inverted = #__flag_inverted
    #__button_multiline = #__text_multiline
    
    ; bar
    EnumerationBinary #__flag_numeric;1
      #__bar_minimum 
      #__bar_maximum 
      #__bar_pageLength 
      
      ;#__bar_arrowSize 
      #__bar_buttonSize 
      #__bar_ScrollStep
      #__bar_Direction 
      #__bar_ticks
      #__bar_reverse
      #__bar_inverted = #__flag_inverted
      
      #__bar_vertical = #__flag_vertical
      #__bar_nobuttons = #__bar_buttonSize
    EndEnumeration
    
    
    If (#__flag_limit>>1) > 2147483647 ; 8589934592
      Debug "Исчерпан лимит в x32 ("+Str(#__flag_limit>>1)+")"
    EndIf
    
    
    
    ;   ; Set/Get Attribute
    #__DisplayMode = 1<<13
    ;   #PB_Image = 1<<13
    ;   #PB_text = 1<<14
    ;   #PB_flag = 1<<15
    ;   #PB_State = 1<<16
    
    
    ;}
    
  EndDeclareModule 
  
  
  Module Constants
    
  EndModule 
  
  ;UseModule Constants
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --
; EnableXP