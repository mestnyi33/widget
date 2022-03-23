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
;

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  #path = "/Users/as/Documents/GitHub/widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  #path = "/media/sf_as/Documents/GitHub/widget"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows 
  #path = "Z:/Documents/GitHub/widget"
  ;#path "C:\Users\as\Desktop\Widget_15_08_2020"
CompilerEndIf

IncludePath #path

CompilerIf Not Defined(constants, #PB_Module)
  DeclareModule constants
    Macro _check_(_variable_, _constant_, _state_=#True)
      Bool(_state_ = Bool(((_variable_) & _constant_) = _constant_))
    EndMacro
    
    ;- - CONSTANTs
    ;{
    
    
    
    ; default values 
    #__window_caption_height = 21
    #__window_frame_size = 4 
    
    ;#__splitter_buttonsize = 9
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      #__splitter_buttonsize = 9
    CompilerEndIf
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      #__splitter_buttonsize = 7;4
    CompilerEndIf
    CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      #__splitter_buttonsize = 9
    CompilerEndIf
    
    #__sOC = SizeOf(Character)
    
    
    ; splitter 
    #__split_0 = 0
    #__split_1 = 1
    #__split_2 = 2
    #__split_3 = 3
    #__bar_minus = 1
    
    
    ;- coordinate 
    Enumeration _c_coordinate
      ; pos & size
      #__c_screen    = 0 ; screen
      #__c_frame     = 1 ; frame screen
      #__c_inner     = 2 ; inner screen
      #__c_container = 3 ; container
      #__c_required  = 4 ; required
      
      #__c_clip      = 5 ; clip screen
      #__c_clip1     = 6 ; clip frame 
      #__c_clip2     = 7 ; clip inner 
      
      #__c_window    = 8 ; window ; pos
      
      
      #__c
    EndEnumeration
    
    
    #__c_inner2 = #__c_inner
    #__c_rootrestore = 7
    ;     #__ci_frame = #__c_draw
    ;     #__ci_container = #__c_draw
    #__c_inner_b = #__c_inner
    
    ;- \_state
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
      #__s_drop     = 1<<10 ; 1024 ; drop enter state
      
      #__s_current     = 1<<11 ;
    EndEnumeration
    
    
    ;     Macro _get_state_index_( _adress_ )
    ;       ( Bool( _adress_\_state & #__s_enter ) * 1 | 
    ;         Bool( _adress_\_state & #__s_select ) * 2 | 
    ;         Bool( _adress_\_state & #__s_disable ) * 3 )
    ;     EndMacro
    
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
    EnumerationBinary _c_align 8 ; 2
      #__flag_vertical           ;= 1
      
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
      ;#__flag_raised
      ;#__flag_single
      
      
      #__flag_transparent
      #__flag_anchorsgadget
      #__flag_limit
    EndEnumeration
    
    ;#__flag_checkboxes = #__flag_clickselect
    #__flag_nogadgets = #__flag_nobuttons
    ;#__flag_multiselect = #__flag_multiline
    
    #__flag_default = #__flag_nolines|#__flag_nobuttons|#__flag_checkboxes
    #__flag_alwaysselection = #__flag_lowercase|#__flag_uppercase
    
    #__flag_autoright = #__flag_autosize|#__flag_right
    #__flag_autobottom = #__flag_autosize|#__flag_bottom
    
    
    
    ;-
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
      ;#__bar_ticks
      
      #__bar_vertical ;= #__flag_vertical
      #__bar_invert = #__flag_invert
      ; #__bar_nobuttons = #__flag_nogadgets
    EndEnumeration
    
    
    ;- _c_event_type
    Enumeration #PB_Event_FirstCustomValue
      #PB_Event_Widget
      
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
      CompilerIf Not Defined(PB_EventType_Resize, #PB_Constant)
        #PB_EventType_Resize
      CompilerEndIf
      CompilerIf Not Defined(PB_EventType_ReturnKey, #PB_Constant)
        #PB_EventType_ReturnKey
      CompilerEndIf
      
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
      
      #PB_EventType_MouseStatus
      #PB_EventType_StatusChangeEdit
      ;       #PB_EventType_TimerStart
      ;       #PB_EventType_TimerStop
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
    #__event_returnkey        = #PB_EventType_ReturnKey
    #__event_closeitem        = #PB_EventType_CloseItem
    
    #__event_down             = #PB_EventType_Down
    #__event_up               = #PB_EventType_Up
    
    #__event_mousewheelX = #PB_EventType_MouseWheelX
    #__event_mousewheelY = #PB_EventType_MouseWheelY
    
    #__event_draw = #PB_EventType_Draw
    
    
    ;- _c_object_type
    #PB_GadgetType_All       = -1     
    #PB_GadgetType_Window    = -2       
    #PB_GadgetType_Toolbar   = -3      
    #PB_GadgetType_Menu      = -4       
    #PB_GadgetType_Root      = -5
    #PB_GadgetType_StatusBar = -6
    #PB_GadgetType_PopupMenu = -7
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
    
    #__type_unknown       = #PB_GadgetType_Unknown  ;
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
    
    
    
  EndDeclareModule 
  
  
  Module Constants
    
  EndModule 
  
  ;UseModule Constants
CompilerEndIf

;-
CompilerIf Not Defined(Structures, #PB_Module)
  DeclareModule Structures
    Prototype pFunc( )
    
    ;{ 
    ;- - _S_value
    Structure _S_value
      s.s
      i.i
    EndStructure
    
    ;     structure _S_coordinate_type
    ;       pos.l
    ;       size.l
    ;     Endstructure
    
    ;- - _S_point
    Structure _S_point
      y.l[5] ; убрать 
      x.l[constants::#__c]
    EndStructure
    
    ;- - _S_size
    Structure _S_size
      width.l
      height.l
    EndStructure
    
    ;- - _S_coordinate
    Structure _S_coordinate 
      y.l
      x.l
      width.l
      height.l
    EndStructure
    
    ;- - _S_position
    Structure _S_position
      *left
      *top
      *right
      *bottom
    EndStructure
    ;--     state
    Structure _S_state
      *flag           ;& normal; entered; selected; disabled
      
      hide.b      ; panel childrens real hide state
      disable.b
      
      enter.b
      press.b
      focus.b
      drag.b
      
      ;active.b
      repaint.b
      click.b
      
      create.b
    EndStructure
    ;--     objecttype
    Structure _S_objecttype
      *root._S_root
      *row._S_rowS
      *last._S_widget
      *widget._S_widget
      *button._S_BUTTONS
    EndStructure
    ;--     mouse
    Structure _S_mouse Extends _S_point
      interact.b ; determines the behavior of the mouse in a clamped (pushed) state
      
      entered._S_objecttype      ; mouse entered element
      pressed._S_objecttype      ; mouse button's pushed element
      leaved._S_objecttype       ; mouse leaved element
      
      wheel._S_point
      delta._S_point
      
      *_drag._S_dd
      *_transform._S_transform
      
      *grid
      buttons.l                ; 
      change.b                 ; if moved mouse this value #true
    EndStructure
    ;--     keyboard
    Structure _S_keyboard ; Ok
      *window._S_widget   ; active window element ; GetActive( )\
      focused._S_objecttype   ; keyboard focus element
      change.b
      input.c
      key.i[2]
    EndStructure
    ;- - _S_color
    Structure _S_color
      state.b ; entered; selected; disabled;
      front.i[4]
      line.i[4]
      fore.i[4]
      back.i[4]
      frame.i[4]
      _alpha.a[2]
      *alpha._S_color
    EndStructure
    
    ;- - _S_align
    Structure _S_align 
      width.l
      height.l
      delta._S_coordinate             
      anchor._S_position ; align the anchor to the left;right;top;bottom
      auto._S_position
      indent._S_position
    EndStructure
    
    ;- - _S_arrow
    Structure _S_ARROW
      size.a
      type.b
      direction.b
    EndStructure
    
    ;- - _S_page
    Structure _S_page
      pos.l
      len.l
      *end
      change.f
    EndStructure
    
    ;- - _S_caret
    Structure _S_caret Extends _S_coordinate
      direction.b
      
      pos.l[4]
      time.l
      
      
      line.l[2]
      change.b
    EndStructure
    
    ;- - _S_edit
    Structure _S_edit Extends _S_coordinate
      pos.l
      len.l
      
      string.s
      change.b
      
      *color._S_color
    EndStructure
    
    ;- - _S_syntax
    Structure _S_syntax
      List *word._S_edit( )
    EndStructure
    
    ;- - _S_text
    Structure _S_text Extends _S_edit
      ;     ;     Char.c
      *fontID ; .i[2]
      
      ;StructureUnion
      pass.b
      lower.b
      upper.b
      numeric.b
      ;EndStructureUnion
      
      editable.b
      multiline.b
      
      invert.b
      vertical.b
      
      ; short._S_edit ; ".."
      edit._S_edit[4]
      caret._S_caret
      syntax._S_syntax
      
      ; short._S_text ; сокращенный текст
      
      rotate.f
      align._S_align
      padding._S_point
    EndStructure
    
    ;- - _S_image
    Structure _S_image Extends _S_coordinate
      *id  ; - ImageID( ) 
      *img ; - Image( )
      
      ;;*output;transparent.b
      depth.a
      change.b
      size.w  ; icon small/large
      
      ;;rotate.f
      align._S_align
      padding._S_point
      ;       
      ;       
      ;       *pressed._S_image
      ;       *released._S_image
      ;       *background._S_image
    EndStructure
    
    ;     ;- - _S_anchor
    ;     structure _S_anchor extends _S_coordinate
    ;       round.a
    ;       *cursor
    ;       color._S_color;[4]
    ;     Endstructure
    ;- - _S_buttons
    Structure _S_BUTTONS Extends _S_coordinate 
      state._S_state
      index.l ; - anchors
      *cursor ; anchor buttons
      
      size.l 
      ___state.l  ; temp
      
      fixed.l 
      
      hide.b
      round.a
      interact.b
      
      arrow._S_arrow
      color._S_color[4]
    EndStructure
    
    ;     ;- - _S_button
    ;     structure _S_button 
    ;       pushed.l
    ;       entered.l
    ;       id._S_buttons[3]
    ;     Endstructure
    
    ;- - _S_margin
    Structure _S_margin Extends _S_coordinate
      color._S_color
      hide.b
    EndStructure
    
    ;- - _S_tabs
    Structure _S_TABS ;extends _S_coordinate
      state._S_state
      
      y.l[constants::#__c]
      x.l[constants::#__c]
      height.l[constants::#__c]
      width.l[constants::#__c]
      ; transporent.b
      
      index.l  ; Index of new list element
      hide.b
      visible.b
      round.a
      
      text._S_text
      image._S_image
      color._S_color
      
      checkbox._S_buttons ; \box[1]\ -> \checkbox\
    EndStructure
    
    ;- - _S_count
    Structure _S_count
      index.l
      type.l
      items.l
      events.l
      parents.b
      childrens.l
    EndStructure
    
    ;- - _S_rows
    Structure _S_rowS Extends _S_TABS
      ;;state._S_state
      count._S_count
      
      sublevel.w
      sublevelsize.a
      
      button._S_buttons ;temp \box[0]\ -> \button\
      collapsebox._S_buttons ; \box[0]\ -> \button\ -> \collapsebox\
                             ;;checkbox._S_buttons ; \box[1]\ -> \checkbox\
      
      *last._S_rows   ; if parent - \last\child ; if child - \parent\last\child
      *_parent._S_rows
      parent._S_objecttype
      
      *option_group._S_rows
      
      ; edit
      margin._S_edit
      
      *data  ; set/get item data
      
      
    EndStructure
    Structure _S_VISIBLEITEMS
      *first._S_rows           ; first draw-elemnt in the list 
      *last._S_rows            ; last draw-elemnt in the list 
      List *_s._S_rows( )      ; all draw-elements
    EndStructure
    ;- - _S_row
    Structure _S_row
      sublevel.w
      sublevelsize.a
      
      *_tt._S_tt
      
      List _s._S_rows( )
      
      *first._S_rows           ; first elemnt in the list 
      *last._S_rows            ; last elemnt in the list 
      *last_add._S_rows        ; last added last element
      
      *active._S_rows          ; focused item
      *pressed._S_rows         ; pushed item
      *entered._S_rows         ; entered item
      *leaved._S_rows          ; leaved item
      
      visible._S_VISIBLEITEMS
      
      margin._S_margin
      
      count.l
      ;index.l
      box._S_buttons           ; editor - edit rectangle
      
    EndStructure
    
    ;- - _S_column
    Structure _S_column Extends _S_coordinate
      
    EndStructure
    
    ;- - _S_bar
    Structure _S_bar
      *widget._S_widget
      
      fixed.l ; splitter fixed button index  
              ;;mode.i ;;; temp
      
      max.l
      min.l[3]
      ; hide.b
      
      ;; change.b ;????
      percent.f
      ;; scroll\increment.f
      ; vertical.b
      invert.b
      direction.l
      
      page._S_page
      area._S_page
      thumb._S_page  
      button._S_buttons[4]
      
      ; tab
      *pressed._S_rows ; _get_bar_active_item_
      *active._S_rows  ; _get_bar_active_item_
      *hover._S_rows   ; _get_bar_active_item_
      
      change_tab_items.b ; tab items to redraw
      
      ;;*selected._S_tabs     ;???????????????   ; at point pushed item
      ; *leaved._S_tabs         ; pushed last entered item
      ; *entered._S_tabs         ; pushed last entered item
      
      List *_s._S_tabs( )
      List *draws._S_tabs( )
      
      
      index.i
    EndStructure
    
    ;     ;- - _S_tab
    ;     structure _S_tab
    ;       bar._S_bar
    ;       ;List *_s._S_tabs( )
    ;     Endstructure
    
    ;- - _S_dotted
    Structure _S_dotted
      ;draw.b
      dot.l
      line.l
      space.l
    EndStructure
    
    ;- - _S_grid
    Structure _S_grid
      *widget
      *image
      size.l
      type.l
    EndStructure
    
    ; multi group
    Structure _S_group Extends _S_coordinate
      *widget._S_widget
    EndStructure
    
    ;- - _S_anchors
    Structure _S_transform
      *main._S_widget
      *widget._S_widget
      *_a_widget._S_widget
      List *group._S_group( )
      
      *type
      *grab ; grab image handle
      
      pos.l
      size.l
      index.l
      
      grid._S_grid
      dotted._S_dotted
      ;id._S_buttons[constants::#__a_count+1]
    EndStructure
    
    Structure _S_a
      pos.l
      size.l
      
      index.b
      transform.b
      mode.i
      ;*id._S_buttons[constants::#__a_moved+1]
    EndStructure
    
    ;- - _S_mode
    Structure _S_mode
      ;       SystemMenu.b     ; 13107200   - #PB_Window_SystemMenu      ; Enables the system menu on the Window Title bar (Default).
      ;       MinimizeGadget.b ; 13238272   - #PB_Window_minimizeGadget  ; Adds the minimize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
      ;       MaximizeGadget.b ; 13172736   - #PB_Window_maximizeGadget  ; Adds the maximize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
      ;       sizeGadget.b     ; 12845056   - #PB_Window_sizeGadget      ; Adds the sizeable feature To a Window.
      ;       Invisible.b      ; 268435456  - #PB_Window_invisible       ; creates the Window but don't display.
      ;       TitleBar.b       ; 12582912   - #PB_Window_titleBar        ; creates a Window With a titlebar.
      ;       Tool.b           ; 4          - #PB_Window_tool            ; creates a Window With a smaller titlebar And no taskbar entry. 
      ;       Borderless.b     ; 2147483648 - #PB_Window_borderless      ; creates a Window without any borders.
      ;       ScreenCentered.b ; 1          - #PB_Window_ScreenCentered  ; Centers the Window in the middle of the screen. X,Y parameters are ignored.
      ;       WindowCentered.b ; 2          - #PB_Window_windowCentered  ; Centers the Window in the middle of the Parent Window ('ParentWindowID' must be specified).
      ;                        ;                X,Y parameters are ignored.
      ;       Maximize.b       ; 16777216   - #PB_Window_maximize        ; Opens the Window maximized. (Note  ; on Linux, Not all Windowmanagers support this)
      ;       Minimize.b       ; 536870912  - #PB_Window_minimize        ; Opens the Window minimized.
      ;       NoGadgets.b      ; 8          - #PB_Window_noGadgets       ; Prevents the creation of a GadgetList. UseGadgetList( ) can be used To do this later.
      ;       NoActivate.b     ; 33554432   - #PB_Window_noActivate      ; Don't activate the window after opening.
      
      ;inline.b
      lines.b
      buttons.b
      gridlines.b
      
      check.b  
      
      fullselection.b
      alwaysselection.b
      
      collapse.b
      
      threestate.b
      
      
    EndStructure
    
    ;- - _S_caption
    Structure _S_caption
      y.l[5]
      x.l[5]
      height.l[5]
      width.l[5]
      ; transporent.b
      
      text._S_text
      button._S_buttons[4]
      color._S_color
      
      interact.b
      hide.b
      round.b
      _padding.b
    EndStructure
    
    ;- - _S_line_
    Structure _S_line_
      v._S_coordinate
      h._S_coordinate
    EndStructure
    
    ;- - _S_tt
    Structure _S_tt Extends _S_coordinate
      window.i
      gadget.i
      
      visible.b
      
      text._S_text
      image._S_image
      color._S_color
    EndStructure
    
    ;- - _S_scroll
    Structure _S_scroll Extends _S_coordinate
      align._S_align
      ;padding.b
      
      state.b    ; set state status
      
      increment.f      ; scrollarea
      *v._S_widget     ; vertical scrollbar
      *h._S_widget     ; horizontal scrollbar
    EndStructure
    
    ;- - _S_popup
    Structure _S_popup
      gadget.i
      window.i
      
      ; *widget._S_widget
    EndStructure
    
    
    ;     ;- - _S_items
    ;     structure _S_items extends _S_coordinate
    ;       index.l
    ;       *parent._S_items
    ;       draw.b
    ;       hide.b
    ;       
    ;       image._S_image
    ;       text._S_text[4]
    ;       box._S_buttons[2]
    ;       color._S_color
    ;       
    ;       ;state.b
    ;       round.a
    ;       
    ;       sublevel.w
    ;       childrens.l
    ;       sublevelsize.l
    ;       
    ;       *data      ; set/get item data
    ;     Endstructure
    ;     
    ;- - _S_dd
    Structure _S_Drop
      privatetype.i
      format.i
      actions.i
    EndStructure
    
    Structure _S_dd Extends _S_Drop
      y.l
      x.l
      width.l
      height.l
      
      *value
      string.s
    EndStructure
    
    ;- - _S_drag
    Structure _S_drag
      start.b
      *address._S_dd
    EndStructure
    
    ;- - _S_eventdata
    Structure _S_eventdata
      *back.pFunc
      
      *id
      ; *widget._S_widget
      *type ; eventType( )
      *item ; eventItem( )
      *data ; eventdata( )
    EndStructure
    
    ;- - _S_BIND 
    Structure _S_eventbind 
      *func.pFunc
      List *type( )
    EndStructure
    
    ;- - _S_event
    Structure _S_event ; extends _S_eventdata
      List *post._S_eventdata( )
      
      List *call._S_eventdata( )
      List *_call._S_eventbind( )
      List *queue._S_eventdata( )
    EndStructure
    
    ;- - _S_TAB_widget
    Structure _S_objecttype_ex Extends _S_objecttype
      index.i ; parent-tab item index
    EndStructure
    
    ;--      bound
    Structure _S_boundvalue
      min.i
      max.i
    EndStructure
    Structure _S_boundmove
      x._S_boundvalue
      y._S_boundvalue
    EndStructure
    Structure _S_boundsize
      width._S_boundvalue
      height._S_boundvalue
    EndStructure
    Structure _S_bounds
      *move._S_boundmove
      *size._S_boundsize
    EndStructure
    ;- - _S_attach
    Structure _S_attach Extends _S_coordinate
      mode.a
      parent._S_objecttype
    EndStructure
    
    ;- - _S_widget
    Structure _S_widget
      state._S_state
      
      *drop._S_dd
      *attach._S_attach
      bounds._S_boundS
      
      _a_mode.i
      _a_transform.b ; add anchors on the widget (to size and move)
                     ;*_a_id_._S_buttons[constants::#__a_moved+1]
      _a_._S_a
      
      
      fs.a[5] ; frame size; [1] - inner left; [2] - inner top; [3] - inner right; [4] - inner bottom
      bs.a    ; border size
      
      __state.w ; #_S_ss_ (font; back; frame; fore; line)
      __draw.b 
      
      BarWidth.w ; bar v size
      BarHeight.w; bar h size 
      MenuBarHeight.w
      ToolBarHeight.w
      StatusBarHeight.w
      
      y.l[constants::#__c]
      x.l[constants::#__c]
      height.l[constants::#__c]
      width.l[constants::#__c]
      ; transporent.b
      
      ; placing layout
      first._S_objecttype
      last._S_objecttype
      after._S_objecttype
      before._S_objecttype
      
      parent._S_objecttype_ex
      tab._S_objecttype_ex
      
      ; 
      *position ; ;#PB_List_First; #PB_List_Last
      
      
      *index[3]  
      ; \index[0] - widget index 
      ; \index[1] - panel opened tab index
      ; \index[2] - panel selected item index
      ; \index[1] - tab entered item index
      ; \index[2] - tab selected item index
      
      *address          ; widgets list address
      *root._S_root     ; this root
      *window._S_widget ; this parent window       ; root( )\active\window
      
      
      *container        ; 
      count._S_count
      
      ;StructureUnion
      *_owner._S_widget; this window owner parent
      *_group._S_widget; = option( ) groupbar gadget  
                       ;EndStructureUnion
      
      *_tt._S_tt          ; notification = уведомление
      *_popup._S_widget   ; combobox( ) list-view gadget
      scroll._S_scroll    ; vertical & horizontal scrollbars
      
      *gadget._S_widget[3] 
      ; \root\gadget[0] - active gadget
      ; \gadget[0] - window active child gadget 
      ; \gadget[1] - splitter( ) first gadget
      ; \gadget[2] - splitter( ) second gadget
      
      image._S_image[4]       
      ; \image[0] - draw image
      ; \image[1] - released image
      ; \image[2] - pressed image
      ; \image[3] - background image
      
      *flag
      *data
      *cursor
      
      draw_widget.b
      
      child.b ; is the widget composite?
      
      level.l 
      class.s  
      change.l
      vertical.b
      type.b
      hide.b[2] 
      round.a
      
      repaint.i
      resize.i
      
      *errors
      notify.l ; оповестить об изменении
      interact.i 
      
      mode._S_mode
      caption._S_caption
      color._S_color[4]
      
      text._S_text 
      
      *bar._S_bar
      *row._S_row ; multi-text; buttons; lists; - gadgets
      *_box_._S_buttons ; checkbox; optionbox
      
      *combo_list._S_widget
      
      *align._S_align
      
      *time_click
      *time_down
      *time
      
      *event._S_event
      events._S_eventdata ;?????????
      
      List *column._S_column( )
    EndStructure
    ;- - _S_canvas
    Structure _S_canvas
      *cursor             ; current visible cursor
      *fontID             ; current drawing fontid
      *address            ; root list address
      
      window.i            ; canvas window
      gadget.i            ; canvas gadget
      container.i         ; 
      
      repaint.b
      postevent.b         ; post evet canvas repaint
      bindevent.b         ; bind canvas event
      
      List *child._S_widget( )    ; widget( )\
      event._S_eventdata          ; 
      List *events._S_eventdata( ); 
    EndStructure
    
    ;- - _S_sticky
    Structure _S_sticky
      *widget._S_widget  ; popup gadget element
      *window._S_widget  ; top level window element
      *message._S_widget ; message window element
      *tooltip._S_widget ; tool tip element
    EndStructure
    
    ;- - _S_root
    Structure _S_root Extends _S_widget
      canvas._S_canvas
    EndStructure
    
    ;--      struct
    Structure _S_struct 
      *drawing
      *action_widget._S_widget
      action_type.s
      
      *opened._S_widget             ; last list opened element
      *closed._S_widget             ; last list opened element
      
      *root._S_root       ; 
      Map *roots._S_root( )         ; 
      mouse._S_mouse                ; mouse( )\
      keyboard._S_keyboard          ; keyboard( )\
      sticky._S_sticky              ; sticky( )\
      
      *widget._S_widget             ; eventwidget( )\ 
      event._S_eventdata            ; widgetevent( )\ ; \type ; \item ; \data
      
      
      ; для совместимости
      List *_root._S_root( )        ; 
      List *_address._S_widget( )   ; widget( )\
    EndStructure
    
    ;Global *event._S_events = Allocatestructure(_S_events)
    ;}
    
  EndDeclareModule 
  
  Module Structures 
    
  EndModule 
CompilerEndIf

CompilerIf Not Defined( func, #PB_Module )
  XIncludeFile "include/func.pbi"
CompilerEndIf

CompilerIf Not Defined( colors, #PB_Module )
  XIncludeFile "include/colors.pbi"
CompilerEndIf

CompilerIf Not Defined( fix, #PB_Module )
  ; fix all pb bug's
  XIncludeFile "include/fix.pbi"
CompilerEndIf


CompilerIf Not Defined( Widget, #PB_Module )
  ;-  >>>
  DeclareModule Widget
    EnableExplicit
    UseModule constants
    UseModule structures
    ;UseModule functions
    
    CompilerIf Defined( fix, #PB_Module )
      UseModule fix
    CompilerElse
      Macro PB(Function)
        Function
      EndMacro
      
      Macro PB_(Function)
        Function
      EndMacro
    CompilerEndIf
    
    UseModule events
    
    ;-  ----------------
    ;-   DECLARE_macros
    ;- Replacement >> PB( )
    Macro CreateCursor( _imageID_, _x_, _y_ )
      func::CreateCursor( _imageID_, _x_, _y_ )
    EndMacro
    
    ;-
    Macro allocate( _struct_name_, _struct_type_= )
      _S_#_struct_name_#_struct_type_ = AllocateStructure( _S_#_struct_name_ )
    EndMacro
    
    Macro PB( _pb_function_name_ ) : _pb_function_name_: EndMacro
    Macro Root( ) : widget::*canvas\roots( ): EndMacro
    Macro Mouse( ) : widget::*canvas\mouse: EndMacro
    Macro Keyboard( ) : widget::*canvas\keyboard: EndMacro
    Macro Drawing( ): widget::*canvas\drawing : EndMacro
    
    Macro parent( ): parent\widget: EndMacro ; Returns last created widget 
    Macro widget( ): WidgetList( Root( ) ): EndMacro ; Returns last created widget 
    Macro enumRoot( ) : widget::*canvas\root: EndMacro
    Macro enumWidget( ): WidgetList( enumRoot( ) ): EndMacro ; Returns last created widget 
    Macro enumParent( ): enumWidget( )\parent( ): EndMacro   ; Returns last created widget 
    
    Macro thisW( ): WidgetList( *this\root ): EndMacro
    Macro thisP( ): WidgetList( *this\parent( )\root ): EndMacro
    
    Macro EventList( _address_ ): _address_\canvas\events( ): EndMacro
    Macro WidgetList( _address_ ): _address_\canvas\child( ): EndMacro
    Macro RowList( _this_ ): _this_\row\_s( ): EndMacro
    Macro TabList( _this_ ): _this_\bar\_s( ): EndMacro
    
    Macro EnteredRow( _this_ ): _this_\row\entered: EndMacro; Returns mouse entered widget
    Macro LeavedRow( _this_ ): _this_\row\leaved: EndMacro  ; Returns mouse entered widget
    Macro PressedRow( _this_ ): _this_\row\pressed: EndMacro; Returns key focus item address
    Macro FocusedRow( _this_ ): _this_\row\active: EndMacro ; Returns key focus item address
    
    Macro VisibleRowList( _this_ ): _this_\row\visible\_s( ): EndMacro
    Macro VisibleFirstRow( _this_ ): _this_\row\visible\first: EndMacro
    Macro VisibleLastRow( _this_ ): _this_\row\visible\last: EndMacro
    
    Macro EnteredRowindex( _this_ ): _this_\index[#__S_1]: EndMacro ; Returns mouse entered row
    Macro PressedRowindex( _this_ ): _this_\index[#__S_2]: EndMacro ; Returns mouse pressed row
    
    ;     Macro SR1( ) : *this\bar\button[#__split_1]: EndMacro
    ;     Macro SR2( ) : *this\bar\button[#__split_2]: EndMacro
    ;     Macro SR3( ) : *this\bar\button[#__split_3]: EndMacro
    ;     
    Macro BB1( ) : *this\bar\button[#__split_1]: EndMacro
    Macro BB2( ) : *this\bar\button[#__split_2]: EndMacro
    Macro BB3( ) : *this\bar\button[#__split_3]: EndMacro
    ;     Macro BSR1( ) : *bar\button[#__split_1]: EndMacro
    ;     Macro BSR2( ) : *bar\button[#__split_2]: EndMacro
    ;     Macro BSR3( ) : *bar\button[#__split_3]: EndMacro
    Macro BBB1( ) : *bar\button[#__split_1]: EndMacro
    Macro BBB2( ) : *bar\button[#__split_2]: EndMacro
    Macro BB( _address_, _index_ ) : _address_\button[_index_]: EndMacro
    
    Macro EnteredButton( ) : Mouse( )\entered\button: EndMacro
    Macro PressedButton( ) : Keyboard( )\focused\button: EndMacro
    Macro FocusedButton( ) : Keyboard( )\focused\button: EndMacro
    
    Macro FocusedTabindex( _this_ ): _this_\index[2]: EndMacro ; 
    
    Macro ParentTabIndex( _this_ ): _this_\parent\index: EndMacro       ; 
    Macro OpenTabIndex( _this_ ): _this_\tab\index: EndMacro            ; 
    
    Macro EnteredWidget( ) : Mouse( )\entered\widget: EndMacro ; Returns mouse entered widget
    Macro LeavedWidget( ) : Mouse( )\leaved\widget: EndMacro   ; Returns mouse leaved widget
    Macro PressedWidget( ) : Mouse( )\pressed\widget: EndMacro
    Macro FocusedWidget( ) : Keyboard( )\focused\widget: EndMacro ; Returns keyboard focus widget
    
    Macro LastOpenedWidget( _this_ ) 
      ;widget::*canvas\closed
      _this_\parent\last 
    EndMacro
    Macro OpenedWidget( ) : widget::*canvas\opened: EndMacro
    Macro StickyWindow( ) : widget::*canvas\sticky\window: EndMacro
    Macro PopupWidget( ) : widget::*canvas\sticky\widget: EndMacro
    
    Macro EventWidget( ) : widget::*canvas\widget: EndMacro
    Macro EventIndex( ) : EventWidget( )\index: EndMacro
    
    Macro WidgetEvent( ) : widget::*canvas\event: EndMacro
    Macro WidgetEventType( ) : WidgetEvent( )\type: EndMacro
    Macro WidgetEventItem( ) : WidgetEvent( )\item: EndMacro
    Macro WidgetEventData( ) : WidgetEvent( )\data: EndMacro
    
    Macro  ChangeCurrentRoot(_canvas_gadget_address_ )
      FindMapElement( Root( ), Str( _canvas_gadget_address_ ) )
      If MapSize( Root( ) )
        enumRoot( ) = Root( )
      EndIf
    EndMacro
    
    Macro WaitWindowEvent( waittime = 0 )
      events::WaitEvent( @EventHandler( ), PB(WaitWindowEvent)( waittime ) )
    EndMacro
    
    
    ;-
    Macro Clip( _address_, _mode_=[#__c_clip] )
      CompilerIf Not ( #PB_Compiler_OS = #PB_OS_MacOS And Not Defined( fix, #PB_Module ))
        PB(ClipOutput)( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_ )
      CompilerEndIf
    EndMacro
    Macro UnClip( )
      PB(UnclipOutput)( )
    EndMacro
    
    Macro _content_clip_( _address_, _mode_= )
      CompilerIf Not ( #PB_Compiler_OS = #PB_OS_MacOS And Not Defined( fix, #PB_Module ))
        ; ClipOutput( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_ )
      CompilerEndIf
    EndMacro
    
    Macro _content_clip2_( _address_, _mode_= )
      CompilerIf Not ( #PB_Compiler_OS = #PB_OS_MacOS And Not Defined( fix, #PB_Module ))
        ; ClipOutput( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_ )
        Clip( _address_, _mode_ )
        
        ; ; Post( _address_, #PB_EventType_Draw ) 
        
      CompilerEndIf
    EndMacro
    
    
    Macro Repaints( )
      PostEventRepaint( Root( ) )
    EndMacro
    
    Macro PostEventRepaint( _address_ ) 
      If _address_\root\state\repaint = #False
        _address_\root\state\repaint = #True
        ;;; Debug "-- post --- event -- repaint --"
        PostEvent( #PB_Event_Gadget, _address_\root\canvas\window, _address_\root\canvas\gadget, #PB_EventType_Repaint, _address_\root )
      ElseIf _address_\state\repaint = #False
        _address_\state\repaint = #True
      EndIf
    EndMacro
    
    
    ;-
    Macro GetActive( ): Keyboard( )\window: EndMacro   ; Returns activeed window
    Macro GetMouseX( _mode_ = #__c_screen ): Mouse( )\x[_mode_]: EndMacro ; Returns mouse x
    Macro GetMouseY( _mode_ = #__c_screen ): Mouse( )\y[_mode_]: EndMacro ; Returns mouse y
    
    ;-
    Macro scroll_x_( _this_ ): _this_\x[#__c_required]: EndMacro
    Macro scroll_y_( _this_ ):  _this_\y[#__c_required]: EndMacro
    Macro scroll_width_( _this_ ): _this_\width[#__c_required]: EndMacro
    Macro scroll_height_( _this_ ): _this_\height[#__c_required]: EndMacro
    
    ;-
    Macro StartEnumerate( _parent_ )
      Bool( _parent_\count\childrens )
      enumRoot( ) = _parent_\root
      
      ;       PushMapPosition( Root( ) )
      ;       ChangeCurrentRoot(_parent_\root\canvas\address )
      PushListPosition( enumWidget( ) )
      
      If _parent_\address
        ChangeCurrentElement( enumWidget( ), _parent_\address )
      Else
        ResetList( enumWidget( ))
      EndIf
      
      While NextElement( enumWidget( ))
        If IsChild( enumWidget( ), _parent_ ) ; Not ( _parent_\after\widget And _parent_\after\widget = enumWidget( )) ; 
        EndMacro
        
        Macro AbortEnumerate( )
          Break
        EndMacro
        
        Macro StopEnumerate( ) 
        Else
          Break
        EndIf
      Wend
      PopListPosition( enumWidget( ))
      ;       PushMapPosition( Root( ) )
    EndMacro
    
    
    ;-
    Macro _get_colors_( ) : colors::*this\blue : EndMacro
    
    ;- 
    Macro is_root_(_this_ ) : Bool( _this_ > 0 And _this_ = _this_\root ): EndMacro
    Macro is_item_( _this_, _item_ ) : Bool( _item_ >= 0 And _item_ < _this_\count\items ) : EndMacro
    Macro is_widget_( _this_ ) : Bool( _this_ > 0 And _this_\address ) : EndMacro
    Macro is_window_( _this_ ) : Bool( is_widget_( _this_ ) And _this_\type = constants::#__type_window ) : EndMacro
    
    Macro is_parent_( _this_, _parent_ )
      Bool( _parent_ = _this_\parent( ) And ( _parent_\tab\widget And ParentTabIndex( _this_ ) = FocusedTabindex( _parent_\tab\widget ) ))
    EndMacro
    Macro is_parent_one_( _address_1, _address_2 )
      Bool( _address_1 <> _address_2 And _address_1\parent( ) = _address_2\parent( ) And ParentTabIndex( _address_1 ) = ParentTabIndex( _address_2 ) )
    EndMacro
    
    Macro is_root_container_( _this_ )
      Bool( _this_ = _this_\root\canvas\container )
    EndMacro
    
    Macro Splitter_FirstGadget_( _this_ ): _this_\gadget[#__split_1]: EndMacro
    Macro Splitter_SecondGadget_( _this_ ): _this_\gadget[#__split_2]: EndMacro
    Macro Splitter_IsFirstGadget_( _this_ ): _this_\index[#__split_1]: EndMacro
    Macro Splitter_IsSecondGadget_( _this_ ): _this_\index[#__split_2]: EndMacro
    
    Macro is_scrollbars_( _this_ ) 
      Bool( _this_\parent( ) And _this_\parent( )\scroll And ( _this_\parent( )\scroll\v = _this_ Or _this_\parent( )\scroll\h = _this_ )) 
    EndMacro
    
    Macro is_integral_( _this_ ) ; It is an integral part
      Bool( _this_\child = 1 )
    EndMacro
    
    Macro is_at_box_v_( _position_y_, _size_height_, _mouse_y_ )
      Bool( _mouse_y_ > _position_y_ And _mouse_y_ <= ( _position_y_ + _size_height_ ) And ( _position_y_ + _size_height_ ) > 0 )
    EndMacro
    
    Macro is_at_box_h_( _position_x_, _size_width_, _mouse_x_ )
      Bool( _mouse_x_ > _position_x_ And _mouse_x_ <= ( _position_x_ + _size_width_ ) And ( _position_x_ + _size_width_ ) > 0 )
    EndMacro
    
    Macro is_at_box_( _position_x_, _position_y_, _size_width_, _size_height_, _mouse_x_, _mouse_y_ )
      Bool( is_at_box_h_( _position_x_, _size_width_, _mouse_x_ ) And is_at_box_v_( _position_y_, _size_height_, _mouse_y_ ) )
    EndMacro
    
    Macro is_at_circle_( _position_x_, _position_y_, _mouse_x_, _mouse_y_, _circle_radius_ )
      Bool( Sqr( Pow((( _position_x_ + _circle_radius_ ) - _mouse_x_ ), 2 ) + Pow((( _position_y_ + _circle_radius_ ) - _mouse_y_ ), 2 )) <= _circle_radius_ )
    EndMacro
    
    Macro is_at_point_y_( _address_, _mouse_y_, _mode_ = )
      is_at_box_v_( _address_\y#_mode_, _address_\height#_mode_, _mouse_y_ )
    EndMacro
    
    Macro is_at_point_x_( _address_, _mouse_x_, _mode_ = )
      is_at_box_v_( _address_\x#_mode_, _address_\width#_mode_, _mouse_x_ )
    EndMacro
    
    Macro is_at_point_( _address_, _mouse_x_, _mouse_y_, _mode_ = )
      Bool( is_at_point_x_( _address_, _mouse_x_, _mode_ ) And is_at_point_y_( _address_, _mouse_y_, _mode_ ))
    EndMacro
    
    Macro is_inter_rect_( _address_1_x_, _address_1_y_, _address_1_width_, _address_1_height_,
                          _address_2_x_, _address_2_y_, _address_2_width_, _address_2_height_ )
      
      Bool(( _address_1_x_ + _address_1_width_ ) > _address_2_x_ And _address_1_x_ < ( _address_2_x_ + _address_2_width_ ) And 
           ( _address_1_y_ + _address_1_height_ ) > _address_2_y_ And _address_1_y_ < ( _address_2_y_ + _address_2_height_ ))
    EndMacro
    
    Macro is_inter_sect_( _address_1_, _address_2_, _address_1_mode_ = )
      Bool(( _address_1_\x#_address_1_mode_ + _address_1_\width#_address_1_mode_ ) > _address_2_\x And _address_1_\x#_address_1_mode_ < ( _address_2_\x + _address_2_\width ) And 
           ( _address_1_\y#_address_1_mode_ + _address_1_\height#_address_1_mode_ ) > _address_2_\y And _address_1_\y#_address_1_mode_ < ( _address_2_\y + _address_2_\height ))
    EndMacro
    
    Macro is_text_gadget_( _this_ )
      Bool( _this_\type = #PB_GadgetType_Editor Or
            _this_\type = #PB_GadgetType_HyperLink Or
            _this_\type = #PB_GadgetType_IPAddress Or
            _this_\type = #PB_GadgetType_CheckBox Or
            _this_\type = #PB_GadgetType_Option Or
            _this_\type = #PB_GadgetType_Button Or
            _this_\type = #PB_GadgetType_String Or
            _this_\type = #PB_GadgetType_Text )
    EndMacro
    
    Macro is_list_gadget_( _this_ )
      Bool( _this_\type = #PB_GadgetType_Tree Or
            _this_\type = #PB_GadgetType_ListView Or
            _this_\type = #PB_GadgetType_ListIcon Or
            _this_\type = #PB_GadgetType_ExplorerTree Or
            _this_\type = #PB_GadgetType_ExplorerList )
    EndMacro
    
    Macro is_no_select_item_( _list_, _item_ )
      Bool( _item_ < 0 Or _item_ >= ListSize( _list_ ) Or (ListIndex( _list_ ) <> _item_ And Not SelectElement( _list_, _item_ ) )) 
      ; Bool( _item_ >= 0 And ListIndex( _list_ ) <> _item_ And Not SelectElement( _list_, _item_ )) 
    EndMacro
    
    Macro _select_prev_item_( _address_, _index_ )
      SelectElement( _address_, _index_ - 1 )
      
      If _address_\hide
        While PreviousElement( _address_ )
          If Not _address_\hide
            Break
          EndIf
        Wend
      EndIf
    EndMacro
    
    Macro _select_next_item_( _address_, _index_ )
      SelectElement( _address_, _index_ + 1 )
      
      If _address_\hide
        While NextElement( _address_ )
          If Not _address_\hide
            Break
          EndIf
        Wend
      EndIf
    EndMacro
    
    Macro _check_expression_( _result_, _address_, _key_ )
      Bool( ListSize( _address_ ))
      _result_ = #False
      ForEach _address_
        If _address_#_key_ 
          _result_ = #True
          Break
        EndIf
      Next
    EndMacro
    
    Macro _post_repaint_items_( _this_ )
      If _this_\count\items = 0 Or 
         ( Not _this_\hide And _this_\row\count And 
           ( _this_\count\items % _this_\row\count ) = 0 )
        
        Debug #PB_Compiler_Procedure
        _this_\change = 1
        _this_\row\count = _this_\count\items
        PostEventCanvas( _this_\root )
      EndIf  
    EndMacro
    
    Macro text_rotate_( _address_ )
      _address_\rotate = Bool( Not _address_\invert ) * ( Bool( _address_\vertical ) * 90 ) + Bool( _address_\invert ) * ( Bool( _address_\vertical ) * 270 + Bool( Not _address_\vertical ) * 180 )
    EndMacro
    
    Macro get_image_width( _image_id_ )
      func::GetImageWidth( _image_id_ )
    EndMacro
    
    Macro get_image_height( _image_id_ )
      func::GetImageHeight( _image_id_ )
    EndMacro
    
    Macro resize_image( _image_id_, _width_, _height_ )
      func::SetImageWidth( _image_id_, _width_ )
      func::SetImageHeight( _image_id_, _height_ )
    EndMacro
    
    ;-
    Macro CanvasMouseX( _canvas_ )
      ; GetGadgetAttribute( _canvas_, #PB_Canvas_MouseX )
      DesktopMouseX( ) - GadgetX( _canvas_, #PB_Gadget_ScreenCoordinate )
      ; WindowMouseX( window ) - GadgetX( _canvas_, #PB_Gadget_WindowCoordinate )  
    EndMacro
    
    Macro CanvasMouseY( _canvas_ )
      ; GetGadgetAttribute( _canvas_, #PB_Canvas_MouseY )
      DesktopMouseY( ) - GadgetY( _canvas_, #PB_Gadget_ScreenCoordinate )
      ; WindowMouseY( window ) - GadgetY( _canvas_, #PB_Gadget_WindowCoordinate )
    EndMacro
    
    ;-
    Macro draw_box_( _x_,_y_,_width_,_height_, _color_ = $ffffffff )
      Box( _x_,_y_,_width_,_height_, _color_ )
    EndMacro
    
    Macro draw_roundbox_( _x_,_y_,_width_,_height_, _round_x_,_round_y_, _color_ = $ffffffff )
      If _round_x_ Or _round_y_
        RoundBox( _x_,_y_,_width_,_height_, _round_x_,_round_y_, _color_ ) ; bug _round_y_ = 0 
      Else
        draw_box_( _x_,_y_,_width_,_height_, _color_ )
      EndIf
    EndMacro
    
    Macro drawing_mode_( _mode_ )
      ;       If enumWidget( )\_drawing <> _mode_
      ;         enumWidget( )\_drawing = _mode_
      ;Debug _mode_
      DrawingMode( _mode_ )
      ;       EndIf
    EndMacro
    
    Macro drawing_mode_alpha_( _mode_ )
      ;       If enumWidget( )\_draw_alpha <> _mode_
      ;         enumWidget( )\_draw_alpha = _mode_
      
      drawing_mode_( _mode_ | #PB_2DDrawing_AlphaBlend )
      ;       EndIf
    EndMacro
    
    ;-  -----------------
    ;-   DECLARE_globals
    ;-  -----------------
    Global _macro_call_count_
    Global *canvas.allocate( STRUCT )
    
    ;-  -------------------
    ;-   DECLARE_functions
    ;-  -------------------
    ;{
    ; Requester
    Global resize_one
    Declare   EventHandler ( canvas.i=- 1, eventtype.i =- 1 )
    Declare   WaitClose( *this = #PB_Any, waittime.l = 0 )
    
    Declare.l x( *this, mode.l = #__c_frame )
    Declare.l Y( *this, mode.l = #__c_frame )
    Declare.l Width( *this, mode.l = #__c_frame )
    Declare.l Height( *this, mode.l = #__c_frame )
    
    Declare.b Resize( *this, ix.l, iy.l, iwidth.l, iheight.l )
    Declare.i GetWindow( *this )
    Declare.i GetGadget( *this = #Null )
    
    Declare.f GetState( *this )
    Declare.b SetState( *this, state.f )
    
    Declare.i GetParent( *this )
    Declare   SetParent( *this, *parent, tabindex.l = 0 )
    
    Declare.i GetAttribute( *this, Attribute.l )
    Declare.i SetAttribute( *this, Attribute.l, *value )
    
    Declare   SetCursor( *this, *cursor )
    
    Declare.i Splitter( x.l,y.l,width.l,height.l, First.i, Second.i, Flag.i = 0 )
    
    
    Declare.i CloseList( )
    Declare.i OpenList( *this, item.l = 0 )
    
    
    ;
    Declare   DoEvents( *this, eventtype.l, *button = #PB_All, *data = #Null ) ;, mouse_x.l, mouse_y.l
    Declare   Open( Window, x.l = 0,y.l = 0,width.l = #PB_Ignore,height.l = #PB_Ignore, title$ = #Null$, flag.i = #Null, *callback = #Null, canvas = #PB_Any )
    ;}
    
  EndDeclareModule
  
  Module Widget
    ;-
    ;- DECLARE_private_functions
    ;-
    
    Procedure   IsChild( *this._S_widget, *parent._S_widget )
      Protected result 
      
      If *this And 
         ; *this <> *parent And 
        *parent\count\childrens
        
        Repeat
          If *parent = *this\parent( )
            result = *this
            Break
          EndIf
          
          *this = *this\parent( )
        Until *this = *this\root  ; is_root_( *this )
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    
    
    ;-
    ;-  BARs
    
    Macro bar_in_stop_( _bar_ ) 
      Bool( _bar_\thumb\pos >= _bar_\area\end )
    EndMacro
    
    Macro bar_in_start_( _bar_ ) 
      Bool( _bar_\thumb\pos <= _bar_\area\pos )
    EndMacro
    
    Macro bar_page_pos_( _bar_, _thumb_pos_ )
      ( _bar_\min + Round((( _thumb_pos_ ) - _bar_\area\pos ) / _bar_\percent, #PB_Round_Nearest ))
    EndMacro
    
    Macro bar_thumb_pos_( _bar_, _scroll_pos_ )
      Round((( _scroll_pos_ ) - _bar_\min - _bar_\min[1] ) * _bar_\percent, #PB_Round_Nearest ) 
    EndMacro
    
    Macro bar_scroll_pos_( _this_, _pos_, _len_ )
      Bool( Bool(((( _pos_ ) + _this_\bar\min ) - _this_\bar\page\pos ) < 0 And bar_SetState( _this_\bar, (( _pos_ ) + _this_\bar\min ) )) Or
            Bool(( (( _pos_ ) + _this_\bar\min ) - _this_\bar\page\pos ) > ( _this_\bar\page\len - ( _len_ )) And bar_SetState( _this_\bar, (( _pos_ ) + _this_\bar\min ) - ( _this_\bar\page\len - ( _len_ ) ))) )
    EndMacro
    
    Macro bar_invert_page_pos_( _bar_, _scroll_pos_ )
      ( Bool( _bar_\invert ) * ( _bar_\page\end - ( _scroll_pos_ - _bar_\min )) + Bool( Not _bar_\invert ) * ( _scroll_pos_ ))
    EndMacro
    
    Macro bar_invert_thumb_pos_( _bar_, _thumb_pos_ )
      ( Bool( _bar_\invert ) * ( _bar_\area\end - _thumb_pos_ ) +
        Bool( Not _bar_\invert ) * ( _bar_\area\pos + _thumb_pos_ ))
    EndMacro
    
    
    ;-
    Procedure.b bar_splitter_draw( *this._S_widget )
      Protected circle_x, circle_y
      Protected._s_BUTTONS *SB1, *SB2, *SB3
      *SB3 = *this\bar\button[#__split_3]
      
      ; if there is no first child
      If Not ( Splitter_IsFirstGadget_( *this ) Or 
               Splitter_FirstGadget_( *this ) )
        *SB1 = *this\bar\button[#__split_1]
      EndIf
      
      ; if there is no second child
      If Not ( Splitter_IsSecondGadget_( *this ) Or
               Splitter_SecondGadget_( *this ) )
        *SB2 = *this\bar\button[#__split_2]
      EndIf
      
      drawing_mode_alpha_( #PB_2DDrawing_Default )
      
      ; draw the splitter background
      draw_box_( *SB3\x, *SB3\y, *SB3\width, *SB3\height, *this\color\back[*SB3\color\state]&$ffffff|210<<24 )
      
      ; draw the first\second background
      If *SB1 : draw_box_( *SB1\x, *SB1\y, *SB1\width, *SB1\height, *this\color\frame[*SB1\color\state] ) : EndIf
      If *SB2 : draw_box_( *SB2\x, *SB2\y, *SB2\width, *SB2\height, *this\color\frame[*SB2\color\state] ) : EndIf
      
      drawing_mode_( #PB_2DDrawing_Outlined )
      
      ; draw the frame
      If *SB1 : draw_box_( *SB1\x, *SB1\y, *SB1\width, *SB1\height, *this\color\frame[*SB1\color\state] ) : EndIf
      If *SB2 : draw_box_( *SB2\x, *SB2\y, *SB2\width, *SB2\height, *this\color\frame[*SB2\color\state] ) : EndIf
      
      ; 
      If *this\bar\thumb\len
        If *this\vertical
          circle_y = ( *this\y + *SB3\height / 2 )
          circle_x = *this\x[#__c_frame] + ( *this\width[#__c_frame] - *SB3\round ) / 2 + Bool( *this\width % 2 )
        Else
          circle_x = ( *SB3\x + *SB3\width / 2 ) ; - *this\x
          circle_y = *this\y[#__c_frame] + ( *this\height[#__c_frame] - *SB3\round ) / 2 + Bool( *this\height % 2 )
        EndIf
        
        If *this\vertical ; horisontal line
          If *SB3\width > 35
            Circle( circle_x - ( *SB3\round * 2 + 2 ) * 2 - 2, circle_y, *SB3\round, *SB3\color\frame[#__S_2] )
            Circle( circle_x + ( *SB3\round * 2 + 2 ) * 2 + 2, circle_y, *SB3\round, *SB3\color\frame[#__S_2] )
          EndIf
          If *SB3\width > 20
            Circle( circle_x - ( *SB3\round * 2 + 2 ), circle_y, *SB3\round, *SB3\color\frame[#__S_2] )
            Circle( circle_x + ( *SB3\round * 2 + 2 ), circle_y, *SB3\round, *SB3\color\frame[#__S_2] )
          EndIf
        Else
          If *SB3\height > 35
            Circle( circle_x, circle_y - ( *SB3\round * 2 + 2 )*2 - 2, *SB3\round, *SB3\color\frame[#__S_2] )
            Circle( circle_x, circle_y + ( *SB3\round * 2 + 2 )*2 + 2, *SB3\round, *SB3\color\frame[#__S_2] )
          EndIf
          If *SB3\height > 20
            Circle( circle_x, circle_y - ( *SB3\round * 2 + 2 ), *SB3\round, *SB3\color\frame[#__S_2] )
            Circle( circle_x, circle_y + ( *SB3\round * 2 + 2 ), *SB3\round, *SB3\color\frame[#__S_2] )
          EndIf
        EndIf
        
        Circle( circle_x, circle_y, *SB3\round, *SB3\color\frame[#__S_2] )
      EndIf
    EndProcedure
    
    ;-
    Procedure.b Update( *this._S_widget, mode.b = 1 )
      Protected fixed.l, result.b, ScrollPos.f, ThumbPos.i
      Protected *bar._S_BAR = *this\bar
      Protected width = *this\width[#__c_frame]
      Protected height = *this\height[#__c_frame]
      
      
      If mode > 0
        ; get area size
        If *this\vertical
          *bar\area\len = height 
        Else
          *bar\area\len = width 
        EndIf
        
        If Not *bar\max And
           Not *bar\page\len
          
          ; get thumb size
          *bar\thumb\len = *bar\button[#__split_3]\size
          If *bar\thumb\len > *bar\area\len
            *bar\thumb\len = *bar\area\len
          EndIf
          
          ; one set end
          If ( Not *bar\page\end And *bar\area\len )
            *bar\page\end = *bar\area\len - *bar\thumb\len
            
            If Not *bar\page\pos
              *bar\page\pos = *bar\page\end / 2 
            EndIf
            
;             ; if splitter fixed 
;             ; set splitter pos to center
            If *bar\fixed = #__split_1
              *bar\button[*bar\fixed]\fixed = *bar\page\pos
            ElseIf *bar\fixed = #__split_2
              *bar\button[*bar\fixed]\fixed = *bar\page\end - *bar\page\pos
            EndIf
            
            ; get page end
          ElseIf ( *bar\page\change Or *bar\fixed = #__split_1 )
            *bar\page\end = *bar\area\len - *bar\thumb\len 
          EndIf
        EndIf
        
        *bar\area\pos = ( BBB1( )\size + *bar\min[1] )
        *bar\thumb\end = *bar\area\len - ( BBB1( )\size + BBB2( )\size )
        If *bar\page\end
          *bar\percent = ( *bar\thumb\end - *bar\thumb\len ) / ( *bar\page\end - *bar\min )
        Else
          *bar\percent = ( *bar\thumb\end - *bar\thumb\len ) / ( *bar\min )
        EndIf
        *bar\area\end = *bar\area\len - *bar\thumb\len - ( BBB2( )\size + *bar\min[2] )
      EndIf
      
      If mode < 2
        ; get thumb pos
        If *bar\fixed And Not *bar\page\change
          If *bar\fixed = #__split_1
            ThumbPos = *bar\button[*bar\fixed]\fixed
            
            If ThumbPos > *bar\area\end
              If *bar\min[1] < *bar\area\end
                ThumbPos = *bar\area\end
              Else
                If *bar\min[1] > ( *bar\area\end + *bar\min[2] )
                  ThumbPos = ( *bar\area\end + *bar\min[2] )
                Else
                  ThumbPos = *bar\min[1]
                EndIf
              EndIf
            EndIf
            
          Else 
            ThumbPos = ( *bar\area\end + *bar\min[2] ) - *bar\button[*bar\fixed]\fixed
            
            If ThumbPos < *bar\min[1]
              If *bar\min[1] > ( *bar\area\end + *bar\min[2] )
                ThumbPos = ( *bar\area\end + *bar\min[2] )
              Else
                ThumbPos = *bar\min[1]
              EndIf
            EndIf
          EndIf
          
          If *bar\thumb\pos <> ThumbPos
            *bar\thumb\change = *bar\thumb\pos - ThumbPos
            *bar\thumb\pos = ThumbPos
          EndIf
          
        Else
          ; fixed mac-OS splitterGadget
          If *bar\page\pos < *bar\min
            If *bar\max > *bar\page\len 
              If *bar\page\end 
                *bar\page\pos = *bar\page\end + *bar\page\pos
              Else
                Debug "error page\end - "+*bar\page\end
              EndIf
            EndIf
          EndIf
          
          ; for the scrollarea childrens
          If *bar\page\end And *bar\page\pos > *bar\page\end 
            Debug " bar end change - " + *bar\page\pos +" "+ *bar\page\end 
            *bar\page\change = *bar\page\pos - *bar\page\end
            *bar\page\pos = *bar\page\end
          EndIf
          
          ;
          If Not *bar\thumb\change
            ThumbPos = bar_thumb_pos_( *bar, *bar\page\pos )
            ThumbPos = bar_invert_thumb_pos_( *bar, ThumbPos )
            
            If ThumbPos < *bar\area\pos : ThumbPos = *bar\area\pos : EndIf
            If ThumbPos > *bar\area\end : ThumbPos = *bar\area\end : EndIf
            
            If *bar\thumb\pos <> ThumbPos
              *bar\thumb\change = *bar\thumb\pos - ThumbPos
              *bar\thumb\pos = ThumbPos
            EndIf
          EndIf
        EndIf
        
        
        ; get fixed size then spltter-bar move
        If *bar\page\change 
          If *bar\fixed = #__split_1
            *bar\button[#__split_1]\fixed = *bar\thumb\pos
          ElseIf *bar\fixed = #__split_2
            *bar\button[#__split_2]\fixed = *bar\area\len - *bar\thumb\len - *bar\thumb\pos
          EndIf
        EndIf
        
        
        
        ;
        If *this\type = #__type_Splitter 
          If *bar\thumb\len 
            If *this\vertical
              *bar\button[#__split_3]\x = *this\x[#__c_frame]           + 1 ; white line size 
              *bar\button[#__split_3]\width = *this\width[#__c_frame]   - 1 ; white line size 
              *bar\button[#__split_3]\y = *this\y[#__c_inner_b] + *bar\thumb\pos
              *bar\button[#__split_3]\height = *bar\thumb\len                              
            Else
              *bar\button[#__split_3]\y = *this\y[#__c_frame]           + 1 ; white line size
              *bar\button[#__split_3]\height = *this\height[#__c_frame] - 1 ; white line size
              *bar\button[#__split_3]\x = *this\x[#__c_inner_b] + *bar\thumb\pos 
              *bar\button[#__split_3]\width = *bar\thumb\len                                  
            EndIf
          EndIf
          
          If *this\vertical
            *bar\button[#__split_1]\width    = *this\width[#__c_frame]
            *bar\button[#__split_1]\height   = *bar\thumb\pos
            
            *bar\button[#__split_1]\x        = *this\x[#__c_frame]
            *bar\button[#__split_2]\x        = *this\x[#__c_frame]
            
            If Not (( #PB_Compiler_OS = #PB_OS_MacOS ) And Splitter_IsFirstGadget_( *this ) And Not *this\parent( ) )
              *bar\button[#__split_1]\y      = *this\y[#__c_frame] 
              *bar\button[#__split_2]\y      = ( *bar\thumb\pos + *bar\thumb\len ) + *this\y[#__c_frame] 
            Else
              *bar\button[#__split_1]\y      = *this\height[#__c_frame] - *bar\button[#__split_1]\height
            EndIf
            
            *bar\button[#__split_2]\height   = *this\height[#__c_frame] - ( *bar\button[#__split_1]\height + *bar\thumb\len )
            *bar\button[#__split_2]\width    = *this\width[#__c_frame]
            
          Else
            *bar\button[#__split_1]\width    = *bar\thumb\pos
            *bar\button[#__split_1]\height   = *this\height[#__c_frame]
            
            *bar\button[#__split_1]\y        = *this\y[#__c_frame]
            *bar\button[#__split_2]\y        = *this\y[#__c_frame]
            *bar\button[#__split_1]\x        = *this\x[#__c_frame]
            *bar\button[#__split_2]\x        = ( *bar\thumb\pos + *bar\thumb\len ) + *this\x[#__c_frame]
            
            *bar\button[#__split_2]\width    = *this\width[#__c_frame] - ( *bar\button[#__split_1]\width + *bar\thumb\len )
            *bar\button[#__split_2]\height   = *this\height[#__c_frame]
            
          EndIf
          
          
          ; Splitter childrens auto resize       
          If Splitter_FirstGadget_( *this )
            If Splitter_IsFirstGadget_( *this )
              If *this\root\canvas\container
                PB(ResizeGadget)( Splitter_FirstGadget_( *this ),
                                  *bar\button[#__split_1]\x,
                                  *bar\button[#__split_1]\y,
                                  *bar\button[#__split_1]\width, *bar\button[#__split_1]\height )
              Else
                PB(ResizeGadget)( Splitter_FirstGadget_( *this ),
                                  *bar\button[#__split_1]\x + GadgetX( *this\root\canvas\gadget ), 
                                  *bar\button[#__split_1]\y + GadgetY( *this\root\canvas\gadget ),
                                  *bar\button[#__split_1]\width, *bar\button[#__split_1]\height )
                
; ;                   gtk_window_move_( GadgetID(Splitter_FirstGadget_( *this )),
; ;                                   *bar\button[#__split_1]\x + GadgetX( *this\root\canvas\gadget ), 
; ;                                   *bar\button[#__split_1]\y + GadgetY( *this\root\canvas\gadget ) )
;             
; ;                   gtk_widget_set_size_request_( GadgetID(Splitter_FirstGadget_( *this )),
; ;                                   *bar\button[#__split_1]\width, *bar\button[#__split_1]\height )
;                 
;                 Protected *first = GadgetID(Splitter_FirstGadget_( *this ))
;                 Macro gtk_window( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_window_get_type_ ( ) ) : EndMacro
;      
;                    gtk_window_set_geometry_hints_ ( GTK_WINDOW ( *first ) , *first , #Null , #GDK_HINT_USER_SIZE | #GDK_HINT_USER_POS ) ;
;                    gtk_widget_set_size_request_ ( *first ,  *bar\button[#__split_1]\width, *bar\button[#__split_1]\height ) ; 
	            EndIf
            Else
              If Splitter_FirstGadget_( *this )\x <> *bar\button[#__split_1]\x Or
                 Splitter_FirstGadget_( *this )\y <> *bar\button[#__split_1]\y Or
                 Splitter_FirstGadget_( *this )\width <> *bar\button[#__split_1]\width Or
                 Splitter_FirstGadget_( *this )\height <> *bar\button[#__split_1]\height
                ; Debug "splitter_1_resize " + Splitter_FirstGadget_( *this )
                
                If Splitter_FirstGadget_( *this )\type = #__type_window
                  Resize( Splitter_FirstGadget_( *this ),
                          *bar\button[#__split_1]\x - *this\x[#__c_frame],
                          *bar\button[#__split_1]\y - *this\y[#__c_frame], 
                          *bar\button[#__split_1]\width - #__window_frame_size*2, *bar\button[#__split_1]\height - #__window_frame_size*2 - #__window_caption_height)
                Else
                  Resize( Splitter_FirstGadget_( *this ),
                          *bar\button[#__split_1]\x - *this\x[#__c_frame],
                          *bar\button[#__split_1]\y - *this\y[#__c_frame], 
                          *bar\button[#__split_1]\width, *bar\button[#__split_1]\height )
                EndIf
                
              EndIf
            EndIf
          EndIf
          
          If Splitter_SecondGadget_( *this )
            If Splitter_IsSecondGadget_( *this )
              If *this\root\canvas\container 
                PB(ResizeGadget)( Splitter_SecondGadget_( *this ),
                                  *bar\button[#__split_2]\x, 
                                  *bar\button[#__split_2]\y,
                                  *bar\button[#__split_2]\width, *bar\button[#__split_2]\height )
              Else
                PB(ResizeGadget)( Splitter_SecondGadget_( *this ), 
                                  *bar\button[#__split_2]\x + GadgetX( *this\root\canvas\gadget ),
                                  *bar\button[#__split_2]\y + GadgetY( *this\root\canvas\gadget ),
                                  *bar\button[#__split_2]\width, *bar\button[#__split_2]\height )
              EndIf
            Else
              If Splitter_SecondGadget_( *this )\x <> *bar\button[#__split_2]\x Or 
                 Splitter_SecondGadget_( *this )\y <> *bar\button[#__split_2]\y Or
                 Splitter_SecondGadget_( *this )\width <> *bar\button[#__split_2]\width Or
                 Splitter_SecondGadget_( *this )\height <> *bar\button[#__split_2]\height 
                ; Debug "splitter_2_resize " + Splitter_SecondGadget_( *this )
                
                If Splitter_SecondGadget_( *this )\type = #__type_window
                  Resize( Splitter_SecondGadget_( *this ), 
                          *bar\button[#__split_2]\x - *this\x[#__c_frame], 
                          *bar\button[#__split_2]\y - *this\y[#__c_frame], 
                          *bar\button[#__split_2]\width - #__window_frame_size*2, *bar\button[#__split_2]\height - #__window_frame_size*2 - #__window_caption_height )
                Else
                  Resize( Splitter_SecondGadget_( *this ), 
                          *bar\button[#__split_2]\x - *this\x[#__c_frame], 
                          *bar\button[#__split_2]\y - *this\y[#__c_frame], 
                          *bar\button[#__split_2]\width, *bar\button[#__split_2]\height )
                EndIf
                
              EndIf
            EndIf   
          EndIf      
          
          result = Bool( *this\resize & #__resize_change )
        EndIf
        
        
        
        ;
        If *bar\page\change <> 0
          If *this\root\canvas\gadget <> PB(EventGadget)( ) And PB(IsGadget)( PB(EventGadget)( )) 
            Debug "bar redraw - "+*this\root\canvas\gadget +" "+ PB(EventGadget)( ) +" "+ EventGadget( )
            ;ReDraw( *this\root ) 
          EndIf
          
          *bar\page\change = 0
        EndIf 
        
        ; 
        If *bar\thumb\change <> 0
          If *this\root\canvas\gadget = PB(EventGadget)( ) 
            result = *bar\thumb\change
          EndIf
          
          *bar\thumb\change = 0
        EndIf  
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b Change( *this._S_widget, ScrollPos.f )
      If *this\bar
        Protected *bar._S_BAR = *this\bar
        ;Debug ""+ScrollPos +" "+ *bar\page\end
      
        If ScrollPos < *bar\min 
          If *bar\max > *bar\page\len 
            ScrollPos = *bar\min 
          Else
            ScrollPos = *bar\page\end + ScrollPos
          EndIf
        EndIf 
        If ScrollPos > *bar\page\end 
          If *bar\page\end
            ScrollPos = *bar\page\end 
          Else
            ScrollPos = bar_page_pos_( *bar, *bar\area\end ) - ScrollPos
          EndIf
        EndIf
        
        If *bar\page\pos <> ScrollPos 
          If *bar\page\pos > ScrollPos
            *bar\direction =- ScrollPos
          Else
            *bar\direction = ScrollPos
          EndIf
          
          *bar\page\change = *bar\page\pos - ScrollPos
          *bar\page\pos = ScrollPos
          
          DoEvents( *this, #PB_EventType_Change, EnteredButton( ), *bar\page\change )
          
          ProcedureReturn #True
        EndIf
      EndIf
    EndProcedure
    
    Procedure.b SetThumbPos( *this._S_widget, ThumbPos.i )
      Protected ScrollPos.f, *bar._S_BAR = *this\bar 
      
      If ThumbPos < *bar\area\pos : ThumbPos = *bar\area\pos : EndIf
      If ThumbPos > *bar\area\end : ThumbPos = *bar\area\end : EndIf
      
      If *bar\thumb\pos <> ThumbPos 
        ScrollPos = bar_page_pos_( *bar, ThumbPos )
        ScrollPos = bar_invert_page_pos_( *bar, ScrollPos )
        
        ;
        If *this\scroll\increment > 1
          ScrollPos - Mod( ScrollPos, *this\scroll\increment )
        EndIf
        
        If *bar\thumb\change <> *bar\thumb\pos - ThumbPos 
          *bar\thumb\change = *bar\thumb\pos - ThumbPos 
          *bar\thumb\pos = ThumbPos
          If Change( *this, ScrollPos )
          EndIf
          ProcedureReturn Update( *this, - 1 )
        EndIf
      EndIf
    EndProcedure
    
    Procedure.b SetState( *this._S_widget, state.f )
      If *this\bar
        If Change( *this, state ) 
          ProcedureReturn Update( *this ) 
        EndIf
      EndIf
    EndProcedure
    
    Procedure.i SetAttribute( *this._S_widget, Attribute.l, *value )
      Protected result.l
      
      If *this\bar
        If *this\type = #__type_Splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize
              *this\bar\min[1] = *value 
              result = Bool( *this\bar\max )
              
            Case #PB_Splitter_SecondMinimumSize
              *this\bar\min[2] = *value
              result = Bool( *this\bar\max )
              
            Case #PB_Splitter_FirstGadget
              Splitter_FirstGadget_( *this ) = *value
              Splitter_IsFirstGadget_( *this ) = Bool( PB(IsGadget)( *value ))
              result =- 1
              
            Case #PB_Splitter_SecondGadget
              Splitter_SecondGadget_( *this ) = *value
              Splitter_IsSecondGadget_( *this ) = Bool( PB(IsGadget)( *value ))
              result =- 1
              
          EndSelect
          
          
          If result 
            Update( *this ) 
            
            If result =- 1
              SetParent(*value, *this)
            EndIf
          EndIf
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   bar_Events( *this._S_widget, eventtype.l, mouse_x.l, mouse_y.l, _wheel_x_.b = 0, _wheel_y_.b = 0 )
      Protected Repaint
      
      If eventtype = #PB_EventType_LeftButtonDown
        If FocusedButton( ) <> EnteredButton( ) 
          FocusedButton( ) = EnteredButton( )
        EndIf
        ; change the color state of non-disabled buttons
        
        If EnteredButton( ) And 
           EnteredButton( )\color\state <> #__S_3 And 
           EnteredButton( )\state\disable = #False
          EnteredButton( )\state\press = #True
          
          If Not ( *this\type = #__type_TrackBar Or 
                   ( *this\type = #__type_Splitter And 
                     EnteredButton( ) <> BB3( ) ))
            EnteredButton( )\color\state = #__S_2
          EndIf
          
          If BB3( )\state\press
            Repaint = #True
          EndIf
        EndIf
        
      EndIf
      
      If eventtype = #PB_EventType_LeftButtonUp
        If FocusedButton( ) And
           FocusedButton( )\state\press = #True  
          FocusedButton( )\state\press = #False 
          
          If FocusedButton( )\color\state <> #__S_3 And 
             FocusedButton( )\state\disable = #False 
            
            ; change color state
            If FocusedButton( )\color\state = #__S_2 And
               Not ( *this\type = #__type_TrackBar Or 
                     ( *this\type = #__type_Splitter And 
                       FocusedButton( ) <> BB3( ) ))
              
              If FocusedButton( )\state\enter
                FocusedButton( )\color\state = #__S_1
              Else
                ; for the splitter thumb
                If BB3( ) = FocusedButton( ) And 
                   BB2( )\size <> $ffffff
                  ; _cursor_remove_( *this )
                EndIf
                
                FocusedButton( )\color\state = #__S_0 
              EndIf
            EndIf
            
            Repaint = 1
          EndIf
        EndIf
        
      EndIf
      
      If eventtype = #PB_EventType_MouseMove
        If *this\state\press And FocusedButton( ) = BB3( )
          If *this\vertical
            Repaint | SetThumbPos( *this, ( mouse_y - Mouse( )\delta\y ))
          Else
            Repaint | SetThumbPos( *this, ( mouse_x - Mouse( )\delta\x ))
          EndIf
          SetWindowTitle( EventWindow( ), Str( *this\bar\page\pos )  + " " +  Str( *this\bar\thumb\pos - *this\bar\area\pos ))
        EndIf
      EndIf
      
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    Procedure.l x( *this._S_widget, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * *this\x[mode] )
    EndProcedure
    
    Procedure.l Y( *this._S_widget, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * *this\y[mode] )
    EndProcedure
    
    Procedure.l Width( *this._S_widget, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * *this\width[mode] )
    EndProcedure
    
    Procedure.l Height( *this._S_widget, mode.l = #__c_frame )
      ProcedureReturn ( Bool( Not *this\hide ) * *this\height[mode] )
    EndProcedure
    
    Procedure  ClipPut( *this._S_widget, x, y, width, height )
      Protected clip_x, clip_y, clip_w, clip_h
      
      ; clip inner coordinate
      If *this\x[#__c_clip] < x
        clip_x = x
      Else
        clip_x = *this\x[#__c_clip]
      EndIf
      
      If *this\y[#__c_clip] < y
        clip_y = y
      Else
        clip_y = *this\y[#__c_clip]
      EndIf
      
      If *this\width[#__c_clip] > width
        clip_w = width
      Else
        clip_w = *this\width[#__c_clip]
      EndIf
      
      If *this\height[#__c_clip] > height
        clip_h = height
      Else
        clip_h = *this\height[#__c_clip]
      EndIf
      
      ClipOutput( clip_x, clip_y, clip_w, clip_h )
    EndProcedure
    
    Procedure   Reclip( *this._S_widget )
      Macro _clip_caption_( _this_ )
        ClipPut( _this_, _this_\caption\x[#__c_inner], _this_\caption\y[#__c_inner], _this_\caption\width[#__c_inner], _this_\caption\height[#__c_inner] )
        
        ;ClipPut( _this_, _this_\x[#__c_frame] + _this_\bs, _this_\y[#__c_frame] + _this_\fs, _this_\width[#__c_frame] - _this_\bs*2, _this_\fs[2] - _this_\fs*2 )
      EndMacro
      
      Macro _clip_width_( _address_, _parent_, _x_width_, _parent_ix_iwidth_, _mode_ = )
        If _parent_ And 
           (_parent_\x#_mode_ + _parent_\width#_mode_) > 0 And
           (_parent_\x#_mode_ + _parent_\width#_mode_) < (_x_width_) And 
           (_parent_ix_iwidth_) > (_parent_\x#_mode_ + _parent_\width#_mode_)  
          
          _address_\width#_mode_ = (_parent_\x#_mode_ + _parent_\width#_mode_)  - _address_\x#_mode_
        ElseIf _parent_ And (_parent_ix_iwidth_) > 0 And (_parent_ix_iwidth_) < (_x_width_)
          
          _address_\width#_mode_ = (_parent_ix_iwidth_) - _address_\x#_mode_
        Else
          _address_\width#_mode_ = (_x_width_) - _address_\x#_mode_
        EndIf
        
        If _address_\width#_mode_ < 0
          _address_\width#_mode_ = 0
        EndIf
      EndMacro
      
      Macro _clip_height_( _address_, _parent_, _y_height_, _parent_iy_iheight_, _mode_ = )
        If _parent_ And 
           (_parent_\y#_mode_ + _parent_\height#_mode_) > 0 And 
           (_parent_\y#_mode_ + _parent_\height#_mode_) < (_y_height_) And
           (_parent_iy_iheight_) > (_parent_\y#_mode_ + _parent_\height#_mode_) 
          
          _address_\height#_mode_ = (_parent_\y#_mode_ + _parent_\height#_mode_) - _address_\y#_mode_
        ElseIf _parent_ And (_parent_iy_iheight_) > 0 And (_parent_iy_iheight_) < (_y_height_)
          
          _address_\height#_mode_ = (_parent_iy_iheight_) - _address_\y#_mode_
        Else
          _address_\height#_mode_ = (_y_height_) - _address_\y#_mode_
        EndIf
        
        If _address_\height#_mode_ < 0
          _address_\height#_mode_ = 0
        EndIf
      EndMacro
      
      ; then move and size parent set clip coordinate
      Protected _p_x2_ 
      Protected _p_y2_
      Protected *parent._S_widget 
      
      If *this\attach 
        *parent = *this\attach\parent( )
      Else
        *parent = *this\parent( )
      EndIf
      
      _p_x2_ = *parent\x[#__c_inner] + *parent\width[#__c_inner]
      _p_y2_ = *parent\y[#__c_inner] + *parent\height[#__c_inner]
      
      ; for the splitter childrens
      If *parent\type = #__type_Splitter
        If Splitter_FirstGadget_( *parent ) = *this
          _p_x2_ = BB( *parent\bar, #__split_1 )\x + BB( *parent\bar, #__split_1 )\width
          _p_y2_ = BB( *parent\bar, #__split_1 )\y + BB( *parent\bar, #__split_1 )\height
        EndIf
        If Splitter_SecondGadget_( *parent ) = *this
          _p_x2_ = BB( *parent\bar, #__split_2 )\x + BB( *parent\bar, #__split_2 )\width
          _p_y2_ = BB( *parent\bar, #__split_2 )\y + BB( *parent\bar, #__split_2 )\height
        EndIf
      EndIf
      
      
      ; then move and size parent set clip coordinate
      ; x&y - clip screen coordinate  
      If *parent And                                  ;Not is_integral_( *this ) And  
         *parent\x[#__c_inner] > *this\x[#__c_screen] And
         *parent\x[#__c_inner] > *parent\x[#__c_clip]
        *this\x[#__c_clip] = *parent\x[#__c_inner]
      ElseIf *parent And *parent\x[#__c_clip] > *this\x[#__c_screen] 
        *this\x[#__c_clip] = *parent\x[#__c_clip]
      Else
        *this\x[#__c_clip] = *this\x[#__c_screen]
      EndIf
      If *parent And                                  ;Not is_integral_( *this ) And 
         *parent\y[#__c_inner] > *this\y[#__c_screen] And 
         *parent\y[#__c_inner] > *parent\y[#__c_clip]
        *this\y[#__c_clip] = *parent\y[#__c_inner]
      ElseIf *parent And *parent\y[#__c_clip] > *this\y[#__c_screen] 
        *this\y[#__c_clip] = *parent\y[#__c_clip]
      Else
        *this\y[#__c_clip] = *this\y[#__c_screen]
      EndIf
      If *this\x[#__c_clip] < 0 : *this\x[#__c_clip] = 0 : EndIf
      If *this\y[#__c_clip] < 0 : *this\y[#__c_clip] = 0 : EndIf
      
      ; x&y - clip inner coordinate
      If *this\x[#__c_clip] < *this\x[#__c_inner] 
        *this\x[#__c_clip2] = *this\x[#__c_inner] 
      Else
        *this\x[#__c_clip2] = *this\x[#__c_clip]
      EndIf
      If *this\y[#__c_clip] < *this\y[#__c_inner] 
        *this\y[#__c_clip2] = *this\y[#__c_inner] 
      Else
        *this\y[#__c_clip2] = *this\y[#__c_clip]
      EndIf
      
      ; width&height - clip coordinate
      _clip_width_( *this, *parent, *this\x[#__c_screen] + *this\width[#__c_screen], _p_x2_, [#__c_clip] )
      _clip_height_( *this, *parent, *this\y[#__c_screen] + *this\height[#__c_screen], _p_y2_, [#__c_clip] )
      
      ; width&height - clip inner coordinate
      If scroll_width_( *this ) And scroll_width_( *this ) < *this\width[#__c_inner]  
        _clip_width_( *this, *parent, *this\x[#__c_inner] + scroll_width_( *this ), _p_x2_, [#__c_clip2] )
      Else
        _clip_width_( *this, *parent, *this\x[#__c_inner] + *this\width[#__c_inner], _p_x2_, [#__c_clip2] )
      EndIf
      If scroll_height_( *this ) And scroll_height_( *this ) < *this\height[#__c_inner]
        _clip_height_( *this, *parent, *this\y[#__c_inner] + scroll_height_( *this ), _p_y2_, [#__c_clip2] )
      Else
        _clip_height_( *this, *parent, *this\y[#__c_inner] + *this\height[#__c_inner], _p_y2_, [#__c_clip2] )
      EndIf
      
      ;       
      ; clip child bar
      
      ProcedureReturn Bool( *this\width[#__c_clip] > 0 And *this\height[#__c_clip] > 0 )
    EndProcedure
    
    Procedure.b Resize( *this._S_widget, x.l,y.l,width.l,height.l )
      Protected.b result
      Protected.l ix,iy,iwidth,iheight,  Change_x, Change_y, Change_width, Change_height
      
      ; 
      If *this\_a_\transform = 0
        If *this\bs < *this\fs 
          *this\bs = *this\fs 
        EndIf
      EndIf
      
      If *this\type <> #__type_spin 
        If *this\fs[1] <> *this\barWidth 
          *this\fs[1] = *this\barWidth
        EndIf
        
        If *this\fs[2] <> *this\barHeight + *this\MenuBarHeight + *this\ToolBarHeight
          *this\fs[2] = *this\barHeight + *this\MenuBarHeight + *this\ToolBarHeight
        EndIf
      EndIf
      
      
      ;
      If x = #PB_Ignore 
        x = *this\x[#__c_container]
      Else
        If *this\parent( ) 
          If Not is_integral_( *this )
            x + scroll_x_( *this\parent( ) ) 
          EndIf 
          *this\x[#__c_container] = x
        EndIf 
      EndIf  
      
      If y = #PB_Ignore 
        y = *this\y[#__c_container] 
      Else
        If *this\parent( ) 
          If Not is_integral_( *this )
            y + scroll_y_( *this\parent( ) ) 
          EndIf 
          *this\y[#__c_container] = y
        EndIf 
      EndIf  
      
      If width = #PB_Ignore 
        If *this\type = #__type_window And Not *this\_a_\transform
          width = *this\width[#__c_container] + *this\fs*2 + ( *this\fs[1] + *this\fs[3] )
        Else
          width = *this\width[#__c_frame] 
        EndIf
      Else
        If *this\type = #__type_window And Not *this\_a_\transform
          width + *this\fs*2 + ( *this\fs[1] + *this\fs[3] )
        EndIf
      EndIf  
      If width < 0 
        width = 0 
      EndIf
      
      If height = #PB_Ignore 
        If *this\type = #__type_window And Not *this\_a_\transform 
          height = *this\height[#__c_container] + *this\fs*2 + ( *this\fs[2] + *this\fs[4] )
        Else
          height = *this\height[#__c_frame]
        EndIf
      Else
        If *this\type = #__type_window And Not *this\_a_\transform 
          height + *this\fs*2 + ( *this\fs[2] + *this\fs[4] )
        EndIf
      EndIf
      If Height < 0 
        Height = 0 
      EndIf
      
      ;
      If *this\parent( )                        
        ;           If *this\attach 
        ;             x + *this\parent( )\x[#__c_frame]
        ;             y + *this\parent( )\y[#__c_frame]
        ;           Else
        If Not ( *this\attach And *this\attach\mode = 2 )
          x + *this\parent( )\x[#__c_inner]
        EndIf
        If Not ( *this\attach And *this\attach\mode = 1 )
          y + *this\parent( )\y[#__c_inner]
        EndIf
        ;           EndIf
      EndIf
      
      ; inner x&y position
      ix = ( x + *this\fs + *this\fs[1] )
      iy = ( y + *this\fs + *this\fs[2] )
      iwidth = width - *this\fs*2 - ( *this\fs[1] + *this\fs[3] )
      iheight = height - *this\fs*2 - ( *this\fs[2] + *this\fs[4] )
      
      ; 
      If *this\x[#__c_frame] <> x : Change_x = x - *this\x[#__c_frame] : EndIf
      If *this\y[#__c_frame] <> y : Change_y = y - *this\y[#__c_frame] : EndIf 
      If *this\x[#__c_inner] <> ix : Change_x = ix - *this\x[#__c_inner] : EndIf
      If *this\y[#__c_inner] <> iy : Change_y = iy - *this\y[#__c_inner] : EndIf 
      If *this\width[#__c_frame] <> width : Change_width = width - *this\width[#__c_frame] : EndIf 
      If *this\height[#__c_frame] <> height : Change_height = height - *this\height[#__c_frame] : EndIf 
      If *this\width[#__c_container] <> iwidth : Change_width = iwidth - *this\width[#__c_container] : EndIf 
      If *this\height[#__c_container] <> iheight : Change_height = iheight - *this\height[#__c_container] : EndIf 
      
      ;
      If Change_x
        *this\resize | #__resize_x | #__resize_change
        
        *this\x[#__c_frame] = x 
        *this\x[#__c_inner] = ix 
        *this\x[#__c_screen] = x - ( *this\bs - *this\fs ) 
        If *this\window
          *this\x[#__c_window] = x - *this\window\x[#__c_inner]
        EndIf
      EndIf 
      If Change_y
        *this\resize | #__resize_y | #__resize_change
        
        *this\y[#__c_frame] = y 
        *this\y[#__c_inner] = iy
        *this\y[#__c_screen] = y - ( *this\bs - *this\fs )
        If *this\window
          *this\y[#__c_window] = y - *this\window\y[#__c_inner]
        EndIf
      EndIf
      If Change_width
        *this\resize | #__resize_width | #__resize_change
        
        *this\width[#__c_frame] = width 
        *this\width[#__c_container] = iwidth
        *this\width[#__c_screen] = width + ( *this\bs*2 - *this\fs*2 ) 
        If *this\width[#__c_container] < 0 
          *this\width[#__c_container] = 0 
        EndIf
        *this\width[#__c_inner] = *this\width[#__c_container]
      EndIf
      If Change_height
        *this\resize | #__resize_height | #__resize_change
        
        *this\height[#__c_frame] = height 
        *this\height[#__c_container] = iheight
        *this\height[#__c_screen] = height + ( *this\bs*2 - *this\fs*2 )
        If *this\height[#__c_container] < 0 
          *this\height[#__c_container] = 0 
        EndIf
        *this\height[#__c_inner] = *this\height[#__c_container]
      EndIf
      
      ; 
      If ( Change_x Or Change_y Or Change_width Or Change_height )
        ;
        If *this\type = #__type_Splitter
          Update( *this, Bool( Change_width Or Change_height ) )
        EndIf
        
        ProcedureReturn 1
      EndIf
    EndProcedure
    
    
    ;- 
    Procedure.i OpenList( *this._S_widget, item.l = 0 )
      Protected result.i = OpenedWidget( )
      
      If *this = OpenedWidget( )
        ProcedureReturn result
      EndIf
      
      If *this
        ;Debug "open - "+*this\index;text\string
        If *this\parent( ) <> OpenedWidget( )
          LastOpenedWidget( *this ) = OpenedWidget( )
          ;  Debug ""
        EndIf
        
        If *this\root <> Root( )
          If OpenedWidget( )\root
            OpenedWidget( )\root\after\root = *this\root
          EndIf
          *this\root\before\root = OpenedWidget( )\root
          
          If *this = *this\root 
            ChangeCurrentRoot(*this\root\canvas\address )
          EndIf
        EndIf
        
        OpenedWidget( ) = *this
      EndIf
      
      ProcedureReturn result
    EndProcedure
    Procedure.i CloseList( )
      Protected *open._s_WIDGET
      ; Debug "close - "+OpenedWidget( )\index;text\string
      
      If OpenedWidget( ) And 
         OpenedWidget( )\parent( ) And
         OpenedWidget( )\root\canvas\gadget = Root( )\canvas\gadget 
        
        If LastOpenedWidget( OpenedWidget( ) ) 
          *open = LastOpenedWidget( OpenedWidget( ) )
          LastOpenedWidget( OpenedWidget( ) ) = #Null
        Else
          If OpenedWidget( )\parent( )\type = #__type_MDI
            *open = OpenedWidget( )\parent( )\parent( ) 
          Else
            If OpenedWidget( ) = OpenedWidget( )\root
              *open = OpenedWidget( )\root\before\root 
            Else
              *open = OpenedWidget( )\parent( )
            EndIf
          EndIf
        EndIf
      Else
        *open = Root( ) 
      EndIf
      
      If OpenedWidget( ) <> *open 
        OpenedWidget( ) = *open
        OpenList( OpenedWidget( ) )
      EndIf
    EndProcedure
    
    
    ;- 
    Procedure.i GetGadget( *this._S_widget = #Null )
      If *this = #Null : *this = Root( ) : EndIf
      
      If is_root_(*this )
        ProcedureReturn *this\root\canvas\gadget ; Returns canvas gadget
      Else
        ProcedureReturn *this\gadget ; Returns active gadget
      EndIf
    EndProcedure
    
    Procedure.i GetWindow( *this._S_widget )
      If is_root_(*this )
        ProcedureReturn *this\root\canvas\window ; Returns canvas window
      Else
        ProcedureReturn *this\window ; Returns element window
      EndIf
    EndProcedure
    
    Procedure.i GetParent( *this._S_widget )
      ProcedureReturn *this\parent( )
    EndProcedure
    
    Procedure  GetLast( *this._S_widget, tabindex.l )
      Protected result, *after._S_widget, *parent._S_widget
      
      If *this\last\widget
        If *this\count\childrens
          LastElement( thisW( ) )
          result = thisW( )\last\widget
          
          ; get after widget
          If *this\after\widget
            *after = *this\after\widget
          Else
            *parent = *this
            Repeat
              *parent = *parent\parent( )
              If *parent\after\widget
                *after = *parent\after\widget 
                Break
              EndIf
            Until *parent = *parent\root
          EndIf
          
          If *after
            PushListPosition( thisW( ) )
            ChangeCurrentElement( thisW( ), *after\address )
            While PreviousElement( thisW( ) )
              If ParentTabIndex( thisW( ) ) = tabindex ;Or thisW( ) = *this 
                Break
              EndIf
            Wend
            result = thisW( )\last\widget
            PopListPosition( thisW( ) )
          EndIf
          
        Else
          result = *this\last\widget
        EndIf
        
        ProcedureReturn result
      EndIf
    EndProcedure
    
    
    Procedure.i GetAttribute( *this._S_widget, Attribute.l )
      Protected result.i
      
      If *this\bar
        If *this\type = #__type_Splitter
          Select Attribute 
            Case #PB_Splitter_FirstGadget       : result = Splitter_FirstGadget_( *this )
            Case #PB_Splitter_SecondGadget      : result = Splitter_SecondGadget_( *this )
            Case #PB_Splitter_FirstMinimumSize  : result = *this\bar\min[1]
            Case #PB_Splitter_SecondMinimumSize : result = *this\bar\min[2]
          EndSelect
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.f GetState( *this._S_widget )
      If *this\bar
        ProcedureReturn *this\bar\page\pos
      EndIf
    EndProcedure
    
    
    
    ;- 
    Procedure   SetCursor( *this._S_widget, *cursor )
      *this\cursor = *cursor
    EndProcedure
    
    
    Procedure   SetParent( *this._S_widget, *parent._S_widget, tabindex.l = 0 )
      Protected ReParent.b, x,y, *last._S_widget, *lastParent._S_widget, NewList *D._S_widget( ), NewList *C._S_widget( )
      
      If *parent
        ;TODO
        If tabindex < 0 
          tabindex = 0
          
        ElseIf tabindex
          If *parent\type = #__type_Splitter
            If tabindex%2
              Splitter_FirstGadget_( *parent ) = *this
              Splitter_IsFirstGadget_( *parent ) = Bool( PB(IsGadget)( *this ))
              Update( *parent )
              If Splitter_IsFirstGadget_( *parent )
                ProcedureReturn 0
              EndIf
            Else
              Splitter_SecondGadget_( *parent ) = *this
              Splitter_IsSecondGadget_( *parent ) = Bool( PB(IsGadget)( *this ))
              Update( *parent )
              If Splitter_IsSecondGadget_( *parent )
                ProcedureReturn 0
              EndIf
            EndIf    
          EndIf    
        EndIf
        
        ParentTabIndex( *this ) = tabindex
        
        ; set hide state 
        If *parent\hide
          *this\hide = #True
        EndIf
        
        If *parent\last\widget
          *last = GetLast( *parent, tabindex )
          
        EndIf
        
        If *this And 
           *this\parent( )
          If *this\parent( ) = *parent
            ProcedureReturn #False
          EndIf
          
          If *this\address
            *lastParent = *this\parent( )
            *lastParent\count\childrens - 1
            
            ChangeCurrentElement( thisW( ), *this\address )
            AddElement( *D( ) ) : *D( ) = thisW( )
            
            If *this\count\childrens
              PushListPosition( thisW( ) )
              While NextElement( thisW( ) )
                If Not IsChild( thisW( ), *this ) 
                  Break
                EndIf
                
                AddElement( *D( ) )
                *D( ) = thisW( )
                *D( )\window = *parent\window
                *D( )\root = *parent\root
                ;; Debug " children - "+ *D( )\data +" - "+ *this\data
                
              Wend 
              PopListPosition( thisW( ) )
            EndIf
            
            ; move with a parent and his children
            If *this\root = *parent\root
              ; move inside the list
              LastElement( *D( ) )
              Repeat
                ChangeCurrentElement( thisW( ), *D( )\address )
                MoveElement( thisW( ), #PB_List_After, *last\address )
              Until PreviousElement( *D( ) ) = #False
            Else
              ForEach *D( )
                ChangeCurrentElement( thisW( ), *D( )\address )
                ; go to the end of the list to split the list
                MoveElement( thisW( ), #PB_List_Last ) 
              Next
              
              ; now we split the list and transfer it to another list
              ChangeCurrentElement( thisW( ), *this\address )
              SplitList( thisW( ), *D( ) )
              
              ; move between lists
              ChangeCurrentElement( WidgetList( *parent\root ), *last\address )
              MergeLists( *D( ), WidgetList( *parent\root ), #PB_List_After )
            EndIf
            
            ReParent = #True 
          EndIf
          
          ; position in list
          If *this\after\widget
            *this\after\widget\before\widget = *this\before\widget
          EndIf
          If *this\before\widget
            *this\before\widget\after\widget = *this\after\widget
          EndIf
          If *this\parent( )\first\widget = *this
            ;             If *this\after\widget
            *this\parent( )\first\widget = *this\after\widget
            ;             Else
            ;               *this\parent( )\first\widget = *this\parent( ) ; if last type
            ;             EndIf
          EndIf 
          If *this\parent( )\last\widget = *this
            If *this\before\widget
              *this\parent( )\last\widget = *this\before\widget
            Else
              *this\parent( )\last\widget = *this\parent( ) ; if last type
            EndIf
          EndIf 
        Else
          If *parent\root
            If *last
              ChangeCurrentElement( WidgetList( *parent\root ), *last\address )
            Else
              LastElement( WidgetList( *parent\root ) )
            EndIf
            
            AddElement( WidgetList( *parent\root ) ) 
            WidgetList( *parent\root ) = *this
            *this\index = ListIndex( WidgetList( *parent\root ) ) 
            *this\address = @WidgetList( *parent\root )
          EndIf
          
          *this\last\widget = *this ; if last type
        EndIf
        
        If *parent\last\widget = *parent
          *parent\first\widget = *this
          *parent\last\widget = *this
          *this\before\widget = #Null
          *this\after\widget = #Null
        Else
          ; if the parent had the last item
          ; then we make it "previous" instead of "present"
          ; and "present" becomes "subsequent" instead of "previous"
          If *this\parent( )
            *this\before\widget = *last
            ; for the panel element
            If ParentTabIndex( *last ) = ParentTabIndex( *this )
              *this\after\widget = *last\after\widget
            EndIf
          Else
            ; for the panel element
            If ParentTabIndex( *parent\last\widget ) = ParentTabIndex( *this )
              *this\before\widget = *parent\last\widget
            EndIf
            *parent\last\widget = *this
            *this\after\widget = #Null
          EndIf
          If *this\before\widget
            *this\before\widget\after\widget = *this
          EndIf
        EndIf
        
        
        ;           
        *this\root = *parent\root
        If is_window_( *parent ) 
          *this\window = *parent
        Else
          *this\window = *parent\window
        EndIf
        *this\parent( ) = *parent
        *this\level = *parent\level + 1
        *this\parent( )\count\childrens + 1
        *this\count\parents = *parent\count\parents + 1
        
        ; TODO
        If *this\window
          Static NewMap typecount.l( )
          
          *this\count\index = typecount( Hex( *this\window + *this\type ))
          typecount( Hex( *this\window + *this\type )) + 1
          
          If *parent\_a_\transform
            *this\count\type = typecount( Hex( *parent ) + "_" + Hex( *this\type ))
            typecount( Hex( *parent ) + "_" + Hex( *this\type )) + 1
          EndIf
        EndIf
        ; set transformation for the child
        If Not *this\_a_\transform And *parent\_a_\transform 
        EndIf
        
        ;
        If ReParent
          ; resize
          x = *this\x[#__c_container]
          y = *this\y[#__c_container]
          
          ; for the scrollarea container childrens
          ; if new parent - scrollarea container
          If *parent\scroll And *parent\scroll\v And *parent\scroll\h
            x - *parent\scroll\h\bar\page\pos
            y - *parent\scroll\v\bar\page\pos
          EndIf
          ; if last parent - scrollarea container
          If *LastParent\scroll And *LastParent\scroll\v And *LastParent\scroll\h
            x + *LastParent\scroll\h\bar\page\pos
            y + *LastParent\scroll\v\bar\page\pos
          EndIf
          
          Resize( *this, x - scroll_x_( *parent ), y - scroll_y_( *parent ), #PB_Ignore, #PB_Ignore )
          
          PostEventRepaint( *parent )
          PostEventRepaint( *lastParent )
        EndIf
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    
    
    ;- 
    ;-  CREATEs
    Procedure.i Create( *parent._S_widget, class.s, type.l, x.l,y.l,width.l,height.l, Text.s = #Null$, flag.i = #Null, *param_1 = #Null, *param_2 = #Null, *param_3 = #Null, size.l = 0, round.l = 7, ScrollStep.f = 1.0 )
      Protected color, image
      Protected ScrollBars, *this.allocate( Widget )
      
      If *parent
        SetParent( *this, *parent, #PB_Default )
      EndIf
      
      With *this
        *this\flag = Flag
        
        *this\x[#__c_inner] =- 2147483648
        *this\y[#__c_inner] =- 2147483648
        *this\type = type
        *this\round = round
        *this\class = class
        *this\color = _get_colors_( )
        
        ; - Create Bars
        If *this\type = #__type_Splitter
          
          *this\bar.allocate( BAR )
          *this\bar\widget = *this ; 
          
          *this\scroll\increment = ScrollStep
          
          ; - Create Splitter
          If *this\type = #__type_Splitter
            *this\color\back =- 1
            
            ;         BB1( )\color = _get_colors_( )
            ;         BB2( )\color = _get_colors_( )
            ;         BB3( )\color = _get_colors_( )
            
            ;;Debug ""+*param_1 +" "+ PB(IsGadget)( *param_1 )
            
            ;*this\container =- *this\type 
            Splitter_FirstGadget_( *this ) = *param_1
            Splitter_SecondGadget_( *this ) = *param_2
            Splitter_IsFirstGadget_( *this ) = Bool( PB(IsGadget)( Splitter_FirstGadget_( *this ) ))
            Splitter_IsSecondGadget_( *this ) = Bool( PB(IsGadget)( Splitter_SecondGadget_( *this ) ))
            
            *this\bar\invert = Bool( Flag & #__bar_invert = #__bar_invert )
            
            ;             If flag & #PB_Splitter_Separator = #PB_Splitter_Separator
            ;               *this\bar\widget\flag | #PB_Splitter_Separator
            ;             EndIf
            
            If ( Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical Or Flag & #__bar_vertical = #__bar_vertical )
              *this\cursor = #PB_Cursor_LeftRight
            Else
              *this\vertical = #True
              *this\cursor = #PB_Cursor_UpDown
            EndIf
            
            If Flag & #PB_Splitter_FirstFixed = #PB_Splitter_FirstFixed
              *this\bar\fixed = #__split_1 
            ElseIf Flag & #PB_Splitter_SecondFixed = #PB_Splitter_SecondFixed
              *this\bar\fixed = #__split_2 
            EndIf
            ;             
            BB3( )\size = #__splitter_buttonsize
            BB3( )\interact = #True
            BB3( )\round = 2
            
          EndIf
        EndIf
        
        ;
        If Splitter_FirstGadget_( *this ) And Not Splitter_IsFirstGadget_( *this )
          SetParent( Splitter_FirstGadget_( *this ), *this )
        EndIf
        
        If Splitter_SecondGadget_( *this ) And Not Splitter_IsSecondGadget_( *this )
          SetParent( Splitter_SecondGadget_( *this ), *this )
        EndIf
        
        ;
        Resize( *this, x,y,width,height )
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Splitter( x.l,y.l,width.l,height.l, First.i,Second.i, Flag.i = 0 )
      ProcedureReturn Create( OpenedWidget( ), #PB_Compiler_Procedure, #__type_Splitter, x,y,width,height, #Null$, flag, First,Second,0, 0,0,1 )
    EndProcedure
    
    Procedure ToolTip( *this._S_widget, Text.s, item =- 1 )
      
      *this\_tt\text\string = Text 
    EndProcedure
    
    ;- 
    ;- 
    ;-  DRAWINGs
    Procedure.b Draw( *this._S_widget )
      Protected arrow_right
      
      With *this
        ; draw belowe drawing
        If Not *this\hide And Reclip( *this )
          Select *this\type
            Case #__type_Splitter       : bar_splitter_draw( *this )
          EndSelect
        EndIf
        
        
        ;
        If Not *this\hide
          ; reset values
          If *this\change <> 0
            *this\change = 0
          EndIf
          If *this\text\change <> 0
            *this\text\change = 0
          EndIf
          If *this\image\change <> 0
            *this\image\change = 0
          EndIf
          If *this\resize & #__resize_change
            *this\resize &~ #__resize_change
          EndIf
        EndIf
        
      EndWith
    EndProcedure
    
    Procedure   ReDraw( *this._S_widget )
      If Drawing( ) = 0
        Drawing( ) = StartDrawing( CanvasOutput( *this\root\canvas\gadget ))
      EndIf
      
      If Drawing( )
        CompilerIf #PB_Compiler_OS = #PB_OS_Linux Or 
                   #PB_Compiler_OS = #PB_OS_Windows
          ; difference in system behavior
          If *this\root\canvas\fontID
            DrawingFont( *this\root\canvas\fontID ) 
          EndIf
        CompilerEndIf
        
        ;
        If is_root_(*this )
          ;If *this\root\canvas\repaint = #True
          CompilerIf  #PB_Compiler_OS = #PB_OS_MacOS
            ; good transparent canvas
            FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ))
          CompilerElse
            FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), $f0 )
          CompilerEndIf
          ; EndIf
          
          ;
          Reclip( *this\root )
          *this\root\width[#__c_clip] = *this\root\width
          *this\root\height[#__c_clip] = *this\root\height
          
          PushListPosition( enumWidget( ))
          ForEach enumWidget( )
            If enumWidget( )\root\canvas\gadget = *this\root\canvas\gadget
              
              ; begin draw all widgets
              Draw( enumWidget( ))
              
            EndIf
          Next
          
          ;
          Unclip( )
          
          drawing_mode_( #PB_2DDrawing_Outlined )
          ForEach enumWidget( )
            If enumWidget( )\root\canvas\gadget = *this\root\canvas\gadget And 
               Not ( enumWidget( )\hide = 0 And enumWidget( )\width[#__c_clip] > 0 And enumWidget( )\height[#__c_clip] > 0 )
              
              
              ; draw group transform widgets frame
              ;If enumWidget( )\_a_\transform = 2
              ; draw_box_( enumWidget( )\x[#__c_frame], enumWidget( )\y[#__c_frame], enumWidget( )\width[#__c_frame], enumWidget( )\height[#__c_frame], $ffff00ff )
              ;EndIf
              ;Else
              ; draw clip out transform widgets frame
              ;If enumWidget( )\_a_\transform 
              If is_parent_( enumWidget( ), enumParent( ) ) And Not enumParent( )\hide 
                draw_box_( enumWidget( )\x[#__c_inner], enumWidget( )\y[#__c_inner], enumWidget( )\width[#__c_inner], enumWidget( )\height[#__c_inner], $ff00ffff )
              EndIf
              ;EndIf
            EndIf
          Next
          PopListPosition( enumWidget( ))
          
        Else
          Draw( *this )
        EndIf
        
        ; draw current popup-widget
        If PopupWidget( ) And PopupWidget( )\root = *this\root
          Draw( PopupWidget( ) )
          ;Tree_Draw( PopupWidget( ), VisibleRowList( PopupWidget( ) ))
          
        EndIf
        
        
        ; reset
        If *this\root\canvas\postevent <> #False
          *this\root\canvas\postevent = #False
        EndIf
        
        ; ; Post( *this\root, #PB_EventType_Repaint ) 
        
        Drawing( ) = 0
        StopDrawing( )
      EndIf
    EndProcedure
    
    ;- 
    Procedure DoEvent_BarButtons( *this._S_widget, eventtype.l, mouse_x.l = -1, mouse_y.l = -1 )
      Protected repaint, *button._S_buttons
      
      
      ;
      ; get at-point-tab address
      If *this\bar
        ;
        ; get at-point-button address
        If  *this\state\enter
          If Not ( EnteredButton( ) And 
                   EnteredButton( )\hide = 0 And 
                   is_at_point_( EnteredButton( ), mouse_x, mouse_y ))
            
            ; search entered button
            If BB1( )\interact And 
               is_at_point_( BB1( ), Mouse( )\x, Mouse( )\y )
              
              *button = BB1( )
            ElseIf BB2( )\interact And
                   is_at_point_( BB2( ), Mouse( )\x, Mouse( )\y )
              
              *button = BB2( )
            ElseIf BB3( )\interact And
                   is_at_point_( BB3( ), Mouse( )\x, Mouse( )\y, )
              
              *button = BB3( )
            EndIf
          EndIf
        Else
          *button = EnteredButton( )
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonDown
          PressedButton( ) = *button
          
          If PressedButton( ) And
             PressedButton( )\state\disable = #False And 
             PressedButton( )\state\press = #False
            
            PressedButton( )\state\press = #True
            PressedButton( )\color\state = #__S_2
            PressedButton( )\color\back[PressedButton( )\color\state] = $FF2C70F5
            
            ;
            If     ( BB2( )\state\press And *this\bar\invert ) Or
                   ( BB1( )\state\press And Not *this\bar\invert )
              DoEvents( *this, #PB_EventType_Up, *this\bar, *this\bar\page\pos - *this\scroll\increment )
            ElseIf ( BB1( )\state\press And *this\bar\invert ) Or
                   ( BB2( )\state\press And Not *this\bar\invert )
              DoEvents( *this, #PB_EventType_Down, *this\bar, *this\bar\page\pos + *this\scroll\increment )
            EndIf
            
            *this\state\repaint = #True
          EndIf
        EndIf
        
        ;
        If eventtype = #PB_EventType_LeftButtonUp
          If PressedButton( )
            If PressedButton( )\state\press = #True
              PressedButton( )\state\press = #False
              
              If PressedButton( )\state\disable = #False
                If PressedButton( )\state\enter
                  PressedButton( )\color\state = #__S_1
                Else
                  PressedButton( )\color\state = #__S_0
                EndIf
                
                *this\state\repaint = #True
              EndIf 
            EndIf
          EndIf
        EndIf
        
        ; do buttons events entered & leaved 
        If EnteredButton( ) <> *button ;And *button
          If EnteredButton( )
            If EnteredButton( )\state\enter = #True
              EnteredButton( )\state\enter = #False
              
              If EnteredButton( )\color\state = #__S_1
                EnteredButton( )\color\state = #__S_0
              EndIf
            EndIf
          EndIf
          
          ; Debug ""+*button+" "+EnteredButton( )
          EnteredButton( ) = *button
          
          If EnteredButton( )
            If *this\state\enter
              If EnteredButton( )\state\enter = #False
                EnteredButton( )\state\enter = #True
                
                If EnteredButton( )\color\state = #__S_0
                  EnteredButton( )\color\state = #__S_1
                EndIf
              EndIf
            EndIf
          EndIf
          
          *this\state\repaint = #True
        EndIf
        
      EndIf
      
      If PressedButton( )
        ;Debug PressedButton( )\color\state
      EndIf
      
      ProcedureReturn repaint
    EndProcedure
    
    Procedure DoEvents( *this._S_widget, eventtype.l, *button = #PB_All, *data = #Null )
      ; ; ;       If Not *this
      ; ; ;         Debug ""+PressedWidget( ) +" - "+ 999999999999
      ; ; ;         ProcedureReturn 
      ; ; ;       EndIf
      
      ;       If Not ( eventtype = #PB_EventType_Focus And FocusedWidget( ) <> *this ) And eventtype <> #PB_EventType_MouseMove
      ;         AddElement( EventList( *this\root ) )
      ;         *this\root\canvas\events.allocate( eventdata, ( ) )
      ;         EventList( *this\root )\id = *this
      ;         EventList( *this\root )\type = eventtype
      ;         EventList( *this\root )\item = *button
      ;         EventList( *this\root )\data = *data
      ;       EndIf
      
      ;       Select eventtype
      ;         Case #PB_EventType_MouseLeave 
      ;           ; Debug ""+*this\index +" "+ *this\class +" #PB_EventType_MouseLeave "
      ;           *this\color\state = #__S_0 
      ;           PostEventRepaint( *this\root )
      ;         Case #PB_EventType_MouseEnter    
      ;           ; Debug ""+*this\index +" "+ *this\class +" #PB_EventType_MouseEnter "
      ;           *this\color\state = #__S_1
      ;           PostEventRepaint( *this\root )
      ;       EndSelect
      
      ; detect events
      CompilerIf #PB_Compiler_IsMainFile = 0
        Select EventType
            
          Case #PB_EventType_DragStart
            Debug ""+*this\index +" "+ *this\class +" #PB_EventType_DragStart " 
          Case #PB_EventType_Drop
            Debug ""+*this\index +" "+ *this\class +" #PB_EventType_Drop " 
          Case #PB_EventType_Focus
            Debug ""+*this\index +" "+ *this\class +" #PB_EventType_Focus " 
          Case #PB_EventType_LostFocus
            Debug ""+*this\index +" "+ *this\class +" #PB_EventType_LostFocus " 
          Case #PB_EventType_LeftButtonDown
            Debug ""
            Debug ""+*this\index +" "+ *this\class +" #PB_EventType_LeftButtonDown " 
          Case #PB_EventType_LeftButtonUp
            Debug ""+*this\index +" "+ *this\class +" #PB_EventType_LeftButtonUp " 
          Case #PB_EventType_LeftClick
            Debug ""+*this\index +" "+ *this\class +" #PB_EventType_LeftClick " 
          Case #PB_EventType_LeftDoubleClick
            Debug ""+*this\index +" "+ *this\class +" #PB_EventType_LeftDoubleClick " 
          Case #PB_EventType_MouseEnter
            Debug ""+*this\index +" "+ *this\class +" #PB_EventType_MouseEnter " 
          Case #PB_EventType_MouseLeave
            Debug ""+*this\index +" "+ *this\class +" #PB_EventType_MouseLeave " 
          Case #PB_EventType_MouseMove
            ; Debug ""+*this\index +" "+ *this\class +" #PB_EventType_MouseMove " 
            
        EndSelect
        
      CompilerEndIf
      
      ; color state
      CompilerIf #PB_Compiler_IsMainFile
        If Not *this\row
          If *this\state\enter
            *this\color\state = #__S_1
          Else
            *this\color\state = #__S_0 
          EndIf
        EndIf
        
        If *this\state\focus
          *this\color\state = #__S_2
        ElseIf Not *this\state\enter 
          *this\color\state = #__S_0 
        EndIf
        If *this\state\press
          *this\color\state = #__S_3
        EndIf
      CompilerEndIf
      
      ; repaint state 
      Select eventtype
        Case #PB_EventType_MouseMove
          If *this\bar And *this\state\drag
            *this\state\repaint = #True
          EndIf
          
        Case #PB_EventType_StatusChange
          *this\state\repaint = #True
          
        Case #PB_EventType_MouseEnter,
             #PB_EventType_MouseLeave,
             #PB_EventType_LeftButtonDown,
             #PB_EventType_LeftButtonUp,
             #PB_EventType_KeyDown,
             #PB_EventType_KeyUp,
             #PB_EventType_Focus,
             #PB_EventType_LostFocus,
             #PB_EventType_ScrollChange,
             ;           ;; #PB_EventType_Repaint,
             ;              #PB_EventType_Create,
             ;              #PB_EventType_DragStart,
             ;              #PB_EventType_Resize,
          #PB_EventType_Drop
          
          *this\state\repaint = #True
      EndSelect
      
      ;
      If Not *this\state\disable 
        ; items events
        Select eventtype
          Case #PB_EventType_MouseEnter,
               #PB_EventType_MouseLeave, 
               #PB_EventType_MouseMove,
               #PB_EventType_Focus, 
               #PB_EventType_LostFocus,
               #PB_EventType_LeftButtonDown, 
               #PB_EventType_LeftButtonUp 
            
            Protected mouse_x, mouse_y
            
            If *this\bar 
              mouse_x = Mouse( )\x - BB3( )\x
              mouse_y = Mouse( )\y - BB3( )\y
              DoEvent_BarButtons( *this, eventtype, mouse_x, mouse_y )
            EndIf
            
        EndSelect
        
        ; widgets events
        Select *this\type
          Case #__type_Splitter
            
            Protected  _wheel_x_.b = 0, _wheel_y_.b = 0
            If Bar_Events( *this, eventtype, Mouse( )\x, Mouse( )\y, _wheel_x_, _wheel_y_ )
              *this\state\repaint = #True
            EndIf
        EndSelect
      EndIf
      
      
      ; 
      If *this\state\repaint = #True
        *this\state\repaint = #False
        PostEventRepaint( *this\root )
      EndIf
      
      ;_DoEvents( *this, eventtype, *button, *data )
    EndProcedure
    
    Procedure GetAtPoint( *root._S_ROOT, mouse_x, mouse_y )
      Protected i, Repaint, *widget._S_WIDGET
      Static *leave._s_widget
      
      ; get at point address
      If *root\count\childrens
        LastElement( WidgetList( *root )) 
        Repeat   
          If WidgetList( *root )\address And Not WidgetList( *root )\hide And 
             WidgetList( *root )\root\canvas\gadget = *root\canvas\gadget And
             is_at_point_( WidgetList( *root ), mouse_x, mouse_y, [#__c_frame] ) And 
             is_at_point_( WidgetList( *root ), mouse_x, mouse_y, [#__c_clip] ) 
            
            ;                   ; enter-widget mouse pos
            ;                   If is_at_point_( WidgetList( *root ), mouse_x, mouse_y, [#__c_inner] )
            ;                     ; get alpha
            ;                     If WidgetList( *root )\image[#__img_background]\id And
            ;                        WidgetList( *root )\image[#__img_background]\depth > 31 And 
            ;                        StartDrawing( ImageOutput( WidgetList( *root )\image[#__img_background]\img ) )
            ;                       
            ;                       drawing_mode_( #PB_2DDrawing_AlphaChannel )
            ;                       
            ;                       If Not Alpha( Point( ( Mouse( )\x - WidgetList( *root )\x[#__c_inner] ) - 1, ( Mouse( )\y - WidgetList( *root )\y[#__c_inner] ) - 1 ) )
            ;                         StopDrawing( )
            ;                         Continue
            ;                       EndIf
            ;                       
            ;                       StopDrawing( )
            ;                     EndIf
            ;                   EndIf
            
            ;
            If PopupWidget( ) And 
               is_at_point_( PopupWidget( ), mouse_x, mouse_y, [#__c_frame] ) And 
               is_at_point_( PopupWidget( ), mouse_x, mouse_y, [#__c_clip] ) 
              *widget = PopupWidget( )
            Else
              *widget = WidgetList( *root )
            EndIf
            
            ; is integral scroll bars
            If *widget\scroll
              If *widget\scroll\v And Not *widget\scroll\v\hide And *widget\scroll\v\type And 
                 is_at_point_( *widget\scroll\v, mouse_x, mouse_y, [#__c_frame] ) And
                 is_at_point_( *widget\scroll\v, mouse_x, mouse_y, [#__c_clip] ) 
                *widget = *widget\scroll\v
              EndIf
              If *widget\scroll\h And Not *widget\scroll\h\hide And *widget\scroll\h\type And
                 is_at_point_( *widget\scroll\h, mouse_x, mouse_y, [#__c_frame] ) And 
                 is_at_point_( *widget\scroll\h, mouse_x, mouse_y, [#__c_clip] ) 
                *widget = *widget\scroll\h
              EndIf
            EndIf
            
            
            Break
          EndIf
        Until PreviousElement( WidgetList( *root )) = #False 
        
        
        ; do events entered & leaved 
        If *leave <> *widget
          EnteredWidget( ) = *widget
          ;
          If *leave And *leave\state\enter <> #False And Not IsChild( *widget, *leave ) ;;And Not ( *widget\attach And *widget\attach\parent( ) <> *leave )
            
            ;
            *leave\state\enter = #False
            repaint | DoEvents( *leave, #PB_EventType_MouseLeave )
            
            If *leave\address
              ChangeCurrentElement( enumWidget( ), *leave\address )
              Repeat                 
                If enumWidget( )\count\childrens And enumWidget( )\state\enter <> #False 
                  If is_at_point_( enumWidget( ), mouse_x, mouse_y, [#__c_clip] ) 
                    If Not ( *widget And *widget\index > enumWidget( )\index )
                      Break
                    EndIf
                  EndIf
                  
                  ;
                  If IsChild( *leave, enumWidget( )) And Not IsChild( *widget, enumWidget( ))
                    enumWidget( )\state\enter = #False
                    DoEvents( enumWidget( ), #PB_EventType_MouseLeave )
                  EndIf
                EndIf
              Until PreviousElement( enumWidget( )) = #False 
            EndIf
          EndIf
          
          ;
          If *widget And *widget\state\enter = #False
            ; first entered all parents
            If *widget\address And Not *widget\attach 
              ForEach enumWidget( ) 
                If enumWidget( ) = *widget
                  Break
                EndIf
                
                If enumWidget( )\count\childrens And
                   enumWidget( )\state\enter <> #True
                  ;
                  If IsChild( *widget, enumWidget( ))
                    enumWidget( )\state\enter = #True
                    DoEvents( enumWidget( ), #PB_EventType_MouseEnter )
                  EndIf
                EndIf
              Next
            EndIf
            
            ; 
            *widget\state\enter = #True
            repaint | DoEvents( *widget, #PB_EventType_MouseEnter )
          EndIf
          
          *leave = *widget
        EndIf  
        ; Debug ""+*leave +" "+ *widget
        
      EndIf
    EndProcedure
    
    Procedure EventHandler( Canvas =- 1, EventType =- 1 )
      Protected Repaint, mouse_x , mouse_y 
      
      If eventtype = #PB_EventType_MouseEnter
        If IsGadget( Canvas )
          ChangeCurrentRoot( GadgetID( Canvas ) )
        EndIf
      EndIf
      
      If Root( )
        ;
        Select eventtype
          Case #PB_EventType_MouseEnter,
               #PB_EventType_MouseLeave,
               #PB_EventType_MouseMove
            
            mouse_x = CanvasMouseX( Root( )\canvas\gadget )
            mouse_y = CanvasMouseY( Root( )\canvas\gadget )
            
            If eventtype = #PB_EventType_MouseEnter
              Mouse( )\change = 1<<0
              Mouse( )\x = mouse_x
              Mouse( )\y = mouse_y
            EndIf
            If eventtype = #PB_EventType_MouseLeave
              Mouse( )\change =- 1
              Mouse( )\x = mouse_x
              Mouse( )\y = mouse_y
            EndIf
            If eventtype = #PB_EventType_MouseMove
              If Mouse( )\x <> mouse_x
                Mouse( )\x = mouse_x
                Mouse( )\change | 1<<1
              EndIf
              If Mouse( )\y <> mouse_y
                Mouse( )\y = mouse_y
                Mouse( )\change | 1<<2
              EndIf
            EndIf
            
          Case #PB_EventType_LeftButtonDown,
               #PB_EventType_RightButtonDown,
               #PB_EventType_MiddleButtonDown
            
            Mouse( )\change = 1<<3
            
            If eventtype = #PB_EventType_LeftButtonDown
              Mouse( )\buttons | #PB_Canvas_LeftButton
            EndIf 
            If eventtype = #PB_EventType_RightButtonDown
              Mouse( )\buttons | #PB_Canvas_RightButton
            EndIf  
            If eventtype = #PB_EventType_MiddleButtonDown
              Mouse( )\buttons | #PB_Canvas_MiddleButton
            EndIf 
            
          Case #PB_EventType_LeftButtonUp, 
               #PB_EventType_RightButtonUp,
               #PB_EventType_MiddleButtonUp
            
            Mouse( )\interact = 1
            Mouse( )\change = 1<<4
            
          Case #PB_EventType_Repaint
            If EventData( ) <> #PB_Ignore
              PushMapPosition( Root( ) )
              ChangeCurrentRoot( GadgetID(Canvas) )
              ;+ ChangeCurrentRoot(GadgetID(PB(EventGadget)( )) )
              ;+ Canvas.i = Root( )\canvas\gadget
              ; 
              Protected result
              
              ;               Static repaint_count
              ;               Debug ""+repaint_count+" ----------- canvas "+ Canvas +" -------------- "
              ;               repaint_count + 1
              
              ForEach enumWidget( )
                If enumWidget( )\root\canvas\gadget = Canvas 
                  PushListPosition( enumWidget( ) )
                  
                  Select EventData( )
                    Case #PB_EventType_Create 
                      enumWidget( )\state\create = 1
                      
                      If enumWidget( )\event
                        If ListSize( enumWidget( )\event\call( ))
                          WidgetEvent( )\back = enumWidget( )\event\call( )\back
                        EndIf
                        
                        ;                         If ListSize( enumWidget( )\event\queue( ))
                        ;                           ForEach enumWidget( )\event\queue( )
                        ;                             ForEach enumWidget( )\event\call( )
                        ;                               If enumWidget( )\event\call( )\type = #PB_All Or  
                        ;                                  enumWidget( )\event\call( )\type = enumWidget( )\event\queue( )\type
                        ;                                 
                        ;                                 EventWidget( ) = enumWidget( )
                        ;                                 WidgetEvent( )\type = enumWidget( )\event\queue( )\type
                        ;                                 WidgetEvent( )\item = enumWidget( )\event\queue( )\item
                        ;                                 WidgetEvent( )\data = enumWidget( )\event\queue( )\data
                        ;                                 WidgetEvent( )\back = enumWidget( )\event\call( )\back
                        ;                                 
                        ;                                 result = WidgetEvent( )\back( )
                        ;                                 
                        ;                                 EventWidget( ) = #Null
                        ;                                 WidgetEvent( )\type = #PB_All
                        ;                                 WidgetEvent( )\item = #PB_All
                        ;                                 WidgetEvent( )\data = #Null
                        ;                                 
                        ;                                 If result
                        ;                                   Break 
                        ;                                 EndIf
                        ;                               EndIf
                        ;                             Next
                        ;                           Next
                        ;                           
                        ;                           ClearList( enumWidget( )\event\queue( ))
                        ;                         EndIf
                      EndIf
                      
                      ;                       ; DoEvents( enumWidget( ), #PB_EventType_Create )
                      ;                       If enumWidget( )\state\focus
                      ;                         enumWidget( )\state\focus = #False
                      ;                         SetActive( enumWidget( ) ) 
                      ;                       EndIf
                      
                  EndSelect
                  
                  enumWidget( )\state\repaint = #False
                  ; DoEvents( enumWidget( ), eventtype )
                  PopListPosition( enumWidget( ) )
                Else
                  Debug "repaint error enumWidget( )"
                EndIf
              Next
              
              ;Root( )\canvas\repaint = #True
              ;;; Debug " ReDraw - " + Canvas +" "+ Root( ) +" #PB_EventType_Repaint"
              ; DoEvents( Root( ), #PB_EventType_Repaint )
              If Drawing( )
                Drawing( ) = 0
                StopDrawing( )
              EndIf
              
              ReDraw( Root( ) )
              PopMapPosition( Root( ) )
            EndIf
            
          Case #PB_EventType_Resize ;;;: PB(ResizeGadget)( Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
            
            Protected Width = PB(GadgetWidth)( Canvas )
            Protected Height = PB(GadgetHeight)( Canvas )
            Repaint = Resize( Root( ), #PB_Ignore, #PB_Ignore, width, height )  
            ReDraw( Root( ) ) 
            Repaint = 1
            
        EndSelect
        
        
        ; get enter&leave widget address
        If Mouse( )\change
          If Mouse( )\interact
            If eventtype = #PB_EventType_MouseLeave
              mouse_x =- 1
              mouse_y =- 1
            Else 
              mouse_x = Mouse( )\x
              mouse_y = Mouse( )\y
            EndIf
            
            ; enter&leave mouse events
            GetAtPoint( Root( ), mouse_x, mouse_y )
            
            ;             If eventtype = #PB_EventType_MouseEnter 
            ;               Debug "e " + Root( )\text\string +" "+ EnteredWidget( )
            ;             EndIf
            ;             
            ;             If eventtype = #PB_EventType_MouseLeave
            ;               Debug "l " + Root( )\text\string +" "+ EnteredWidget( )
            ;             EndIf
            
          EndIf
        EndIf
        
        
        ; do events all
        If eventtype = #PB_EventType_Focus
          ;           If FocusedWidget( )                          And Not FocusedWidget( )\_a_\transform 
          ;             Repaint | SetActive( FocusedWidget( ) ) 
          ;           Else
          ;             If GetActive( ) 
          ;               If GetActive( )\gadget                 And Not GetActive( )\gadget\_a_\transform 
          ;                 Repaint | SetActive( GetActive( )\gadget ) 
          ;               ElseIf                                     Not GetActive( )\_a_\transform 
          ;                 Repaint | SetActive( GetActive( ) ) 
          ;               EndIf
          ;             Else
          ;               If EnteredWidget( )                      And Not EnteredWidget( )\_a_\transform
          ;                 Repaint = SetActive( EnteredWidget( )) 
          ;               EndIf
          ;             EndIf
          ;           EndIf
          ;           
        ElseIf eventtype = #PB_EventType_LostFocus
          ;           Repaint = SetActive( 0 ) 
          
        ElseIf eventtype = #PB_EventType_MouseMove 
          If Mouse( )\change > 1
            ; mouse entered-widget move event
            If EnteredWidget( ) And EnteredWidget( )\state\enter
              Repaint | DoEvents( EnteredWidget( ), #PB_EventType_MouseMove )
            EndIf
            
            If PressedWidget( )
              If PressedWidget( )\state\press And 
                 PressedWidget( )\root <> Root( )
                Mouse( )\x = CanvasMouseX( PressedWidget( )\root\canvas\gadget )
                Mouse( )\y = CanvasMouseY( PressedWidget( )\root\canvas\gadget )
              EndIf
              
              ; mouse drag start
              If PressedWidget( ) And
                 PressedWidget( )\state\press = #True And
                 PressedWidget( )\state\drag = #False 
                PressedWidget( )\state\drag = #True
                
                DoEvents( PressedWidget( ), #PB_EventType_DragStart);, PressedItem( ) )
              EndIf
              
              ; mouse pressed-widget move event
              If EnteredWidget( ) <> PressedWidget( )  
                If PressedWidget( ) And PressedWidget( )\state\drag
                  Repaint | DoEvents( PressedWidget( ), #PB_EventType_MouseMove )
                EndIf
              EndIf
            EndIf
            
            Mouse( )\change = 0
          EndIf
          
        ElseIf eventtype = #PB_EventType_LeftButtonDown Or
               eventtype = #PB_EventType_MiddleButtonDown Or
               eventtype = #PB_EventType_RightButtonDown
          
          ;
          If EnteredWidget( )
            PressedWidget( ) = EnteredWidget( )
            ;PressedRow( EnteredWidget( ) ) = EnteredRow( EnteredWidget( ) )
            
            EnteredWidget( )\state\press = #True
            ;If Not EnteredWidget( )\time_down
            ;EndIf
            ; Debug ""+ EnteredWidget( )\class +" "+ EventGadget( ) + " #PB_EventType_LeftButtonDown" 
            
            If ( eventtype = #PB_EventType_LeftButtonDown Or
                 eventtype = #PB_EventType_RightButtonDown ) 
              
              
              ; disabled mouse behavior
              If EnteredWidget( )\_a_\transform Or EnteredButton( ) > 0
                Mouse( )\interact = #False
              EndIf
              
              If Not EnteredWidget( )\_a_\transform 
                If EnteredButton( ) > 0 And EnteredWidget( )\bar
                  ; bar mouse delta pos
                  ;; Debug "   bar delta pos >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" )"
                  ;If EnteredButton( ) = BB( EnteredWidget( )\bar, #__b_3 ) ; EnteredButton( )\index = #__b_3
                  Mouse( )\delta\x = Mouse( )\x - EnteredWidget( )\bar\thumb\pos
                  Mouse( )\delta\y = Mouse( )\y - EnteredWidget( )\bar\thumb\pos
                  ;EndIf
                Else
                  ;; Debug "  widget delta pos >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" )"
                  Mouse( )\delta\x = Mouse( )\x - EnteredWidget( )\x[#__c_container]
                  Mouse( )\delta\y = Mouse( )\y - EnteredWidget( )\y[#__c_container]
                  
                  If Not is_integral_( EnteredWidget( ))
                    Mouse( )\delta\x - scroll_x_( EnteredWidget( )\parent( ) )
                    Mouse( )\delta\y - scroll_y_( EnteredWidget( )\parent( ) )
                  EndIf
                EndIf
              EndIf
            EndIf
            
            
            Repaint | DoEvents( EnteredWidget( ), eventtype )
            
          EndIf
          
          
        ElseIf eventtype = #PB_EventType_LeftButtonUp Or 
               eventtype = #PB_EventType_MiddleButtonUp Or
               eventtype = #PB_EventType_RightButtonUp
          
          If PressedWidget( ) 
            ; do drop events
            If EnteredWidget( ) And
               PressedWidget( )\state\drag <> #False
              ; PressedWidget( )\state\drag = #False
              
              DoEvents( EnteredWidget( ), #PB_EventType_Drop)
            EndIf
            
            ; do up events
            Repaint | DoEvents( PressedWidget( ), #PB_EventType_LeftButtonUp )
          EndIf
          
          ; reset mouse buttons
          If Mouse( )\buttons
            If eventtype = #PB_EventType_LeftButtonUp
              Mouse( )\buttons &~ #PB_Canvas_LeftButton
            ElseIf eventtype = #PB_EventType_RightButtonUp
              Mouse( )\buttons &~ #PB_Canvas_RightButton
            ElseIf eventtype = #PB_EventType_MiddleButtonUp
              Mouse( )\buttons &~ #PB_Canvas_MiddleButton
            EndIf
            
            Mouse( )\delta\x = 0
            Mouse( )\delta\y = 0
          EndIf
          
          If PressedWidget( ) 
            PressedWidget( )\state\press = #False 
            PressedWidget( )\state\drag = #False
          EndIf  
          
        ElseIf eventtype = #PB_EventType_Input Or
               eventtype = #PB_EventType_KeyDown Or
               eventtype = #PB_EventType_KeyUp
          
          If FocusedWidget( )
            Keyboard( )\key[1] = GetGadgetAttribute( FocusedWidget( )\root\canvas\gadget, #PB_Canvas_Modifiers )
            
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              If Keyboard( )\key[1] & #PB_Canvas_Command
                Keyboard( )\key[1] &~ #PB_Canvas_Command
                Keyboard( )\key[1] | #PB_Canvas_Control
              EndIf
            CompilerEndIf
            
            If eventtype = #PB_EventType_Input 
              Keyboard( )\input = GetGadgetAttribute( FocusedWidget( )\root\canvas\gadget, #PB_Canvas_Input )
            ElseIf ( eventtype = #PB_EventType_KeyDown Or
                     eventtype = #PB_EventType_KeyUp )
              Keyboard( )\Key = GetGadgetAttribute( FocusedWidget( )\root\canvas\gadget, #PB_Canvas_Key )
            EndIf
            
            ; keyboard events
            Repaint | DoEvents( FocusedWidget( ), eventtype )
            
            ; change keyboard focus-widget
            
          EndIf
          
        ElseIf eventtype = #PB_EventType_MouseWheel
          If EnteredWidget( )
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              Protected app, ev
              app = CocoaMessage(0,0,"NSApplication sharedApplication")
              If app
                ev = CocoaMessage(0,app,"currentEvent")
                If ev
                  Mouse( )\wheel\x = CocoaMessage(0,ev,"scrollingDeltaX")
                EndIf
              EndIf
            CompilerEndIf
            
            Mouse( )\wheel\y = GetGadgetAttribute( Root( )\canvas\gadget, #PB_Canvas_WheelDelta )
            
            ; mouse wheel events
            If Mouse( )\wheel\y
              Repaint | DoEvents( EnteredWidget( ), #PB_EventType_MouseWheelY )
              Mouse( )\wheel\y = 0
            ElseIf Mouse( )\wheel\x
              Repaint | DoEvents( EnteredWidget( ), #PB_EventType_MouseWheelX )
              Mouse( )\wheel\x = 0
            EndIf
          EndIf
          
        ElseIf eventtype = #PB_EventType_LeftClick 
          If EnteredWidget( ) And 
             EnteredWidget( ) = PressedWidget( )
            Repaint | DoEvents( PressedWidget( ), eventtype )
          EndIf      
          
        ElseIf eventtype = #PB_EventType_LeftDoubleClick 
          If PressedWidget( )
            Repaint | DoEvents( PressedWidget( ), eventtype )
          EndIf
          
        ElseIf eventtype = #PB_EventType_Drop
          ;           If EnteredWidget( )
          ;             Repaint | DoEvents( EnteredWidget( ), eventtype )
          ;           EndIf
          
        ElseIf eventtype = #PB_EventType_MouseEnter 
        ElseIf eventtype = #PB_EventType_MouseLeave 
        ElseIf eventtype = #PB_EventType_RightClick 
        ElseIf eventtype = #PB_EventType_DragStart 
        ElseIf eventtype = #PB_EventType_RightDoubleClick 
        ElseIf eventtype = #PB_EventType_Change 
        ElseIf eventtype = #PB_EventType_Resize 
        ElseIf eventtype = #PB_EventType_Repaint 
        Else        
          If eventtype <> #PB_EventType_MouseMove
            Mouse( )\change | 1<<0|1<<1
          EndIf
          Debug  #PB_Compiler_Procedure + " - else eventtype - "+eventtype
          
          If EnteredWidget( ) And Mouse( )\change
            Repaint | DoEvents( EnteredWidget( ), eventtype )
          EndIf
          If FocusedWidget( ) And EnteredWidget( ) <> FocusedWidget( ) And FocusedWidget( )\state\press And Mouse( )\change 
            Repaint | DoEvents( FocusedWidget( ), eventtype )
          EndIf
        EndIf
        
        
        ; reset
        If Mouse( )\change <> #False
          Mouse( )\change = #False
        EndIf
        
        If ListSize( EventList( Root( ) ) )
          ; Debug ListSize( EventList( Root( ) ) )
          ForEach EventList( Root( ) )
            ;If EventList( Root( ) )\type = #PB_EventType_LeftClick 
            ; Debug 333
            If EventList( Root( ) )\type <> #PB_EventType_MouseMove
              ; Debug "" +EventList( Root( ) )\type +" "+ EventList( Root( ) )\id +" "+ ClassFromEvent( EventList( Root( ) )\type )
            EndIf
            
            ;_DoEvents( EventList( Root( ) )\id, EventList( Root( ) )\type, EventList( Root( ) )\item, EventList( Root( ) )\data )
            ; Post( EventList( Root( ) )\id, EventList( Root( ) )\type, EventList( Root( ) )\item, EventList( Root( ) )\data )
            ;EndIf
          Next
          
          ; Debug ""
          ClearList( EventList( Root( ) ) )
        EndIf
        
        ProcedureReturn Repaint
      EndIf
    EndProcedure
    
    Procedure EventResize( )
      Protected canvas = GetWindowData( EventWindow( ))
      ; Protected *this._S_widget = GetGadgetData( Canvas )
      ;PostEventCanvas( *this\root ) 
      PB(ResizeGadget)( canvas, #PB_Ignore, #PB_Ignore, WindowWidth( EventWindow( )) - GadgetX( canvas )*2, WindowHeight( EventWindow( )) - GadgetY( canvas )*2 )
    EndProcedure
    
    
    
    ;-
    Procedure   Open( Window, x.l = 0,y.l = 0,width.l = #PB_Ignore,height.l = #PB_Ignore, title$ = #Null$, flag.i = #Null, *CallBack = #Null, Canvas = #PB_Any )
      Protected w, g, UseGadgetList, result
      
      If width = #PB_Ignore And
         height = #PB_Ignore
        flag | #PB_Canvas_Container
      EndIf
      
      If PB(IsWindow)(Window) 
        w = WindowID( Window )
      Else
        If Not MapSize( Root( ))
          w = OpenWindow( Window, x,y,width,height, title$, flag ) : If Window =- 1 : Window = w : w = WindowID( Window ) : EndIf
          x = 0
          y = 0
        Else
          Window = GetWindow( Root( ))
          If Not ( IsWindow( Window ) And WidgetList( Root( ) ) = Root( )\canvas\container )
            Window = OpenWindow( #PB_Any, WidgetList( Root( ) )\x, WidgetList( Root( ) )\y, WidgetList( Root( ) )\width, WidgetList( Root( ) )\height, "", #PB_Window_BorderLess )
          EndIf
        EndIf
      EndIf
      
      If width = #PB_Ignore
        width = WindowWidth( Window, #PB_Window_InnerCoordinate )
        If x <> #PB_Ignore
          width - x*2
        EndIf
      EndIf
      
      If height = #PB_Ignore
        height = WindowHeight( Window, #PB_Window_InnerCoordinate )
        If y <> #PB_Ignore
          height - y*2
        EndIf
      EndIf
      
      ; get a handle from the previous usage list
      If w
        UseGadgetList = UseGadgetList( w )
      EndIf
      
      ;
      If PB(IsGadget)(Canvas)
        g = GadgetID( Canvas )
        If MapSize( Root( ) )
          Root( )\container = Canvas
        EndIf
      Else
        If MapSize( Root( ) )
          Root( )\container = #__type_root
        EndIf
        g = CanvasGadget( Canvas, x, y, width, height, Flag | #PB_Canvas_Keyboard ) 
        If Canvas =- 1 : Canvas = g : g = GadgetID( Canvas ) : EndIf
      EndIf
      
      ; 
      If UseGadgetList
        UseGadgetList( UseGadgetList )
      EndIf
      
      ;
      If Not ChangeCurrentRoot(g) 
        result = AddMapElement( Root( ), Str( g ) )
        Root( ) = AllocateStructure( _S_root )
        Root( )\type = #PB_GadgetType_Container
        Root( )\container = #PB_GadgetType_Container
        
        Root( )\class = "Root"
        Root( )\root = Root( )
        Root( )\window = Root( )
        
        Root( )\fs = Bool( flag & #__flag_BorderLess = 0 )
        Root( )\bs = Root( )\fs
        
        Root( )\color = _get_colors_( )
        Root( )\text\fontID = PB_( GetGadgetFont )( #PB_Default )
        
        
        ; check the elements under the mouse
        Mouse( )\interact = #True
        
        Root( )\canvas\window = Window
        Root( )\canvas\gadget = Canvas
        Root( )\canvas\address = g
        
        SetParent( Root( ), Root( ), #PB_Default )
        
        If flag & #PB_Window_NoGadgets = #False
          If OpenedWidget( )
            OpenedWidget( )\after\root = Root( )
          EndIf
          Root( )\before\root = OpenedWidget( ) 
          
          OpenedWidget( ) = Root( )
          ; OpenList( Root( ))
        EndIf
        
        If flag & #PB_Window_NoActivate = #False
          ; Root( )\state\focus = #True
          FocusedWidget( ) = Root( )
          ; SetActive( Root( ))
        EndIf 
        
        Resize( Root( ), #PB_Ignore,#PB_Ignore,width,height ) ;??
        
        ; post repaint canvas event
        PostEvent( #PB_Event_Gadget, Window, Canvas, #PB_EventType_Repaint, #PB_EventType_Create )
        ; BindGadgetEvent( Canvas, @EventCanvas( ))
      EndIf
      
      If g
        SetGadgetData( Canvas, result ) ;@*canvas\_root( ))
        SetWindowData( Window, Canvas )
        
        If flag & #PB_Canvas_Container = #PB_Canvas_Container
          BindEvent( #PB_Event_SizeWindow, @EventResize( ), Window );, Canvas )
        EndIf
        
        ; z - order
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          SetWindowLongPtr_( g, #GWL_STYLE, GetWindowLongPtr_( g, #GWL_STYLE ) | #WS_CLIPSIBLINGS )
          SetWindowPos_( g, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE | #SWP_NOSIZE )
        CompilerEndIf
      EndIf
      
      ;       CompilerIf #PB_Compiler_OS = #PB_OS_Linux Or 
      ;                  #PB_Compiler_OS = #PB_OS_Windows
      If Drawing( )
        StopDrawing( )
      EndIf
      
      Drawing( ) = StartDrawing( CanvasOutput( Root( )\canvas\gadget ))
      
      If Drawing( )
        ; difference in system behavior
        If Root( )\canvas\fontID
          DrawingFont( Root( )\canvas\fontID ) 
        EndIf
        
        
        ; StopDrawing()
      EndIf
      ;       CompilerEndIf
      
      ProcedureReturn Root( )
    EndProcedure
    
    Procedure   WaitClose( *this._S_widget = #PB_Any, waittime.l = 0 )
      Protected result 
      Protected *window._S_widget = *this;\window
      Protected PBWindow = PB(EventWindow)( )
      
      If Root( )
        ; ReDraw( Root( ))
        If ListSize( EventList( Root( ) ) )
          ClearList( EventList( Root( ) ) )
        EndIf
        
        Repeat 
          Select events::WaitEvent( @EventHandler( ), PB(WaitWindowEvent)( waittime ) )
              ;             Case #PB_Event_Message
              ;             Case #PB_Event_Gadget
            Case #PB_Event_CloseWindow
              If *window = #PB_Any 
                If EventWidget( )
                  Debug " - close - " + EventWidget( ) ; +" "+ GetWindow( *window )
                  If EventWidget( )\container = #__type_window
                    ;Else
                    
                    ForEach Root( )
                      Debug Root( )
                      ; free( Root( ))
                      ;               ForEach enumWidget( )
                      ;                 Debug ""+ enumWidget( )\root +" "+ is_root_( enumWidget( ))
                      ;               Next
                    Next
                    Break
                  EndIf
                Else
                  Debug " - close0 - " + PBWindow ; +" "+ GetWindow( *window )
                  Break
                EndIf
                
              ElseIf PB(EventGadget)( ) = *window
                Debug " - close1 - " + PBWindow ; +" "+ GetWindow( *window )
                                                ; Free( *window )
                ReDraw( Root() )
                Break
                
              ElseIf PBWindow = *window 
                ;                 If ; Post( *window, #PB_EventType_Free )
                ;                   Debug " - close2 - " + PBWindow ; +" "+ GetWindow( *window )
                ;                   Break
                ;                 EndIf
                ;                 ;               Else
                ;                 ;                Debug 555
                ;                 ;                Free( *window )
                ;                 ;                 
                ;                 ;                 Break
              EndIf
              
          EndSelect
        ForEver
        
        ;         ; ReDraw( Root( ))
        ;         
        ;         If IsWindow( PBWindow)
        ;           Debug " - end - "
        ;           PB(CloseWindow)( PBWindow)
        ;           End 
        ;         EndIf
      EndIf  
      
    EndProcedure
  EndModule
  ;- <<< 
CompilerEndIf



;- 
Macro UseLIB( _name_ )
  UseModule _name_
  UseModule constants
  UseModule structures
EndMacro


; CompilerIf #PB_Compiler_IsMainFile
;   Uselib(widget)
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
;       Splitter_4 = widget::Splitter(430-GadgetX(GetGadget(Root())), 10-GadgetY(GetGadget(Root())), 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
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
  Uselib(widget)
  EnableExplicit
  #__Text_Border = #PB_Text_Border
  
  Procedure.l GetIndex( *this._S_widget )
    ;  ProcedureReturn *this\index - 1
  EndProcedure
  
  Global window_ide, canvas_ide, fixed=1, state=1, minsize=1
  Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
  Global s_desi, s_tbar, s_view, s_help, s_list,s_insp
  
  Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget  
  widget::Open(OpenWindow(#PB_Any, 100,100,800,600, "ide", flag))
  window_ide = widget::GetWindow(root())
  canvas_ide = widget::GetGadget(root())
  
  s_tbar = TextGadget(#PB_Any, 0,0,0,0,"", #__Text_Border)
  s_desi = TextGadget(#PB_Any, 0,0,0,0,"", #__Text_Border)
  s_view = TextGadget(#PB_Any, 0,0,0,0,"", #__Text_Border)
  s_list = TextGadget(#PB_Any, 0,0,0,0,"", #__Text_Border)
  s_insp = TextGadget(#PB_Any, 0,0,0,0,"", #__Text_Border)
  s_help  = TextGadget(#PB_Any, 0,0,0,0,"", #__Text_Border)
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4, Splitter_5
  Button_0 = 0;ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
  Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  
  Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
  Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
  Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
  Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
  
  Splitter_0 = widget::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
  Splitter_1 = widget::Splitter(0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
  widget::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
  widget::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
  Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, Button_5)
  Splitter_3 = widget::Splitter(0, 0, 0, 0, Button_2, Splitter_2)
  Splitter_4 = widget::Splitter(0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
  Splitter_5 = widget::Splitter(0, 0, 0, 0, s_desi, Splitter_4, #PB_Splitter_Vertical)
  
  Splitter_design = widget::Splitter(0,0,0,0, s_tbar,Splitter_5, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  Splitter_inspector = widget::Splitter(0,0,0,0, s_list,s_insp, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  splitter_debug = widget::Splitter(0,0,0,0, Splitter_design,s_view, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  splitter_help = widget::Splitter(0,0,0,0, Splitter_inspector,s_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  Splitter_ide = widget::Splitter(0,0,800,600, splitter_debug,splitter_help, #PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
  
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
    widget::SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
    widget::SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
    widget::SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
    ; widget::SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 300)
    widget::SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
    widget::SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
    widget::SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
    widget::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 200)
    ;widget::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
  EndIf
  
  If state
    ; set splitters dafault positions
    ;widget::SetState(Splitter_ide, -130)
    widget::SetState(Splitter_ide, widget::width(Splitter_ide)-220)
    widget::SetState(splitter_help, widget::height(splitter_help)-80)
    widget::SetState(splitter_debug, widget::height(splitter_debug)-150)
    widget::SetState(Splitter_inspector, 200)
    widget::SetState(Splitter_design, 30)
    widget::SetState(Splitter_5, 120)
    
    widget::SetState(Splitter_1, 20)
  EndIf
  
  ;widget::Resize(Splitter_ide, 0,0,820,620)
  
  SetGadgetText(s_tbar, "size: ("+Str(GadgetWidth(s_tbar))+"x"+Str(GadgetHeight(s_tbar))+") - " + Str(GetIndex( widget::GetParent( s_tbar ))) )
  SetGadgetText(s_desi, "size: ("+Str(GadgetWidth(s_desi))+"x"+Str(GadgetHeight(s_desi))+") - " + Str(GetIndex( widget::GetParent( s_desi ))))
  SetGadgetText(s_view, "size: ("+Str(GadgetWidth(s_view))+"x"+Str(GadgetHeight(s_view))+") - " + Str(GetIndex( widget::GetParent( s_view ))))
  SetGadgetText(s_list, "size: ("+Str(GadgetWidth(s_list))+"x"+Str(GadgetHeight(s_list))+") - " + Str(GetIndex( widget::GetParent( s_list ))))
  SetGadgetText(s_insp, "size: ("+Str(GadgetWidth(s_insp))+"x"+Str(GadgetHeight(s_insp))+") - " + Str(GetIndex( widget::GetParent( s_insp ))))
  SetGadgetText(s_help, "size: ("+Str(GadgetWidth(s_help))+"x"+Str(GadgetHeight(s_help))+") - " + Str(GetIndex( widget::GetParent( s_help ))))
  
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --------------------------------------------------------------------------------------------------------
; EnableXP