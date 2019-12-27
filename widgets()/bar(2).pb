CompilerIf Not Defined(Constants, #PB_Module)
  DeclareModule Constants
    #VectorDrawing = 0
    
    ;CompilerIf #VectorDrawing
    ;  UseModule Draw
    ;CompilerEndIf
    
    Enumeration #PB_Event_FirstCustomValue
      #PB_Event_Widget
    EndEnumeration
    
    
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
    
    EnumerationBinary
      #___text
      #___image
      
      #___center
      #___right
      #___left
      #___top
      #___bottom
      #___vertical 
      #___horizontal
    EndEnumeration
    
    EnumerationBinary WidgetFlags
      #__flag_left
      #__flag_top
      #__flag_right
      #__flag_bottom
      #__flag_horizontal
      
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
      #__flag_vertical 
      #__flag_autoSize
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
    #__flag_center = #__flag_vertical|#__flag_horizontal
    #__flag_full = #__flag_left|#__flag_right|#__flag_top|#__flag_bottom
    
    #__flag_default = #__flag_nolines|#__flag_nobuttons|#__flag_checkboxes
    #__flag_alwaysselection = #__flag_lowercase|#__flag_uppercase
    
    ; window
    #__window_nogadget = #__flag_nobuttons
    #__window_borderless = #__flag_borderless
    #__window_systemmenu = #__flag_systemmenu
    #__window_sizegadget = #__flag_sizegadget
    #__window_screencentered = #__flag_center
    
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
    
    ; text
    #__text_left = #__flag_left
    #__text_top = #__flag_top
    #__text_center = #__flag_center
    #__text_right = #__flag_right
    #__text_bottom = #__flag_bottom
    #__text_vertical = #__flag_vertical
    
    #__text_multiline = #__flag_multiline
    #__text_numeric = #__flag_numeric
    #__text_password = #__flag_password
    #__text_readonly = #__flag_readonly
    #__text_lowercase = #__flag_lowercase
    #__text_uppercase = #__flag_uppercase
    #__text_wordwrap = #__flag_wordwrap
    #__text_invert = #__flag_inverted
    
    ; editor
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
      Debug "???????? ????? ? x32 ("+Str(#__flag_limit>>1)+")"
    EndIf
    
    
    
    ;   ; Set/Get Attribute
    #__DisplayMode = 1<<13
    ;   #PB_Image = 1<<13
    ;   #PB_text = 1<<14
    ;   #PB_flag = 1<<15
    ;   #PB_State = 1<<16
    
    
    EnumerationBinary 
      #__Splitter_Vertical    ; The gadget is split vertically (instead of horizontally which is the Default).
      #__Splitter_Separator   ; A 3D-looking separator is drawn in the splitter.
      #__Splitter_FirstFixed  ; When the splitter gadget is resized, the first gadget will keep its size
      #__Splitter_SecondFixed ; When the splitter gadget is resized, the second gadget will keep its size
    EndEnumeration
    
    Enumeration 
      #__Splitter_FirstMinimumSize  ; Sets/Gets the minimum size (in pixels) than the first gadget can have.
      #__Splitter_SecondMinimumSize ; Sets/Gets the minimum size (in pixels) than the second gadget can have.
      #__Splitter_FirstGadget       ; Replaces/Gets the gadget number of the first gadget.
      #__Splitter_SecondGadget      ; Replaces/Gets the gadget number of the second gadget.
    EndEnumeration
    ;}
    
  EndDeclareModule 
  
  Module Constants
    
  EndModule 
  
  ;UseModule Constants
CompilerEndIf

;-
CompilerIf Not Defined(Structures, #PB_Module)
  DeclareModule Structures
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      ; PB Interne Struktur Gadget MacOS
      Structure sdkGadget
        *gadget
        *container
        *vt
        UserData.i
        Window.i
        Type.i
        Flags.i
      EndStructure
    CompilerEndIf
    #__anchors =9+4
    ;{ 
    Prototype pFunc()
    
    ;- - _s_page
    Structure _s_page
      pos.l
      len.l
      *end
    EndStructure
    
    ;- - _s_point
    Structure _s_point
      y.l[4] ; убрать 
      x.l[4]
    EndStructure
    
    ;- - _s_coordinate
    Structure _s_coordinate Extends _s_point
      width.l
      height.l
    EndStructure
    
    ;- - _s_color
    Structure _s_color
      state.b ; entered; selected; disabled;
      front.i[4]
      line.i[4]
      fore.i[4]
      back.i[4]
      frame.i[4]
      alpha.a[2]
    EndStructure
    
    ;- - _s_mouse
    Structure _s_mouse Extends _s_point
      drag.b[2]
      change.b
      buttons.l 
      wheel._s_point
      delta._s_point
    EndStructure
    
    ;- - _s_keyboard
    Structure _s_keyboard
      change.b
      input.c
      key.i[2]
    EndStructure
    
    ;- - _s_align
    Structure _s_align
      width.l
      height.l
      
      left.b
      top.b
      right.b
      bottom.b
      vertical.b
      horizontal.b
      autosize.b
    EndStructure
    
    ;- - _s_arrow
    Structure _s_arrow
      size.a
      type.b
      direction.b
    EndStructure
    
    ;- - _s_button
    Structure _s_button Extends _s_coordinate
      len.l
      hide.b
      round.a
      ; switched.b
      interact.b
      arrow._s_arrow
      color._s_color
    EndStructure
    
    ;- - _s_box
    Structure _s_box Extends _s_button
      checked.b
    EndStructure
    
    ;- - _s_caption
    Structure _s_caption Extends _s_button
      button._s_button[3]
    EndStructure
    
    ;- - _s_transform
    Structure _s_transform Extends _s_coordinate
      hide.b
      cursor.l
      color._s_color[4]
    EndStructure
    
    ;- - _s_anchor
    Structure _s_anchor
      pos.l
      size.l
      index.l
      cursor.l
      delta._s_point
      *widget._s_widget
      id._s_transform[#__anchors+1]
    EndStructure
    
    ;- - _s_windowFlag
    Structure _s_windowFlag
      SystemMenu.b     ; 13107200   - #PB_Window_SystemMenu      ; Enables the system menu on the Window Title bar (Default).
      MinimizeGadget.b ; 13238272   - #PB_Window_minimizeGadget  ; Adds the minimize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
      MaximizeGadget.b ; 13172736   - #PB_Window_maximizeGadget  ; Adds the maximize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
      SizeGadget.b     ; 12845056   - #PB_Window_SizeGadget      ; Adds the sizeable feature To a Window.
      Invisible.b      ; 268435456  - #PB_Window_invisible       ; creates the Window but don't display.
      TitleBar.b       ; 12582912   - #PB_Window_titleBar        ; creates a Window With a titlebar.
      Tool.b           ; 4          - #PB_Window_tool            ; creates a Window With a smaller titlebar And no taskbar entry. 
      Borderless.b     ; 2147483648 - #PB_Window_borderless      ; creates a Window without any borders.
      ScreenCentered.b ; 1          - #PB_Window_ScreenCentered  ; Centers the Window in the middle of the screen. X,Y parameters are ignored.
      WindowCentered.b ; 2          - #PB_Window_windowCentered  ; Centers the Window in the middle of the Parent Window ('ParentWindowID' must be specified).
                       ;                X,Y parameters are ignored.
      Maximize.b       ; 16777216   - #PB_Window_maximize        ; Opens the Window maximized. (Note  ; on Linux, Not all Windowmanagers support this)
      Minimize.b       ; 536870912  - #PB_Window_minimize        ; Opens the Window minimized.
      NoGadgets.b      ; 8          - #PB_Window_noGadgets       ; Prevents the creation of a GadgetList. UseGadgetList() can be used To do this later.
      NoActivate.b     ; 33554432   - #PB_Window_noActivate      ; Don't activate the window after opening.
    EndStructure
    
    ;- - _s_flag
    Structure _s_flag
      Window._s_windowFlag
      inline.b
      lines.b
      buttons.b
      gridlines.b
      checkboxes.b
      fullselection.b
      alwaysselection.b
      multiselect.b
      clickselect.b
      
      collapse.b
      option_group.b
      threestate.b
      iconsize.b
      transform.b
    EndStructure
    
    ;- - _s_caret
    Structure _s_caret Extends _s_coordinate
      pos.l[3]
      time.l
    EndStructure
    
    ;- - _s_edit
    Structure _s_edit Extends _s_coordinate
      pos.l
      len.l
      
      string.s
      change.b
    EndStructure
    
    ;- - _s_text
    Structure _s_text Extends _s_edit
      ;     ;     Char.c
      fontID.i
      count.l
      
      pass.b
      lower.b
      upper.b
      numeric.b
      editable.b
      multiline.b
      
      rotate.f
      padding.l
      
      edit._s_edit[4]
      caret._s_caret
      align._s_align
    EndStructure
    
    ;- - _s_bar
    Structure _s_bar
      max.l
      min.l
      mode.i
      
      hide.b
      change.l
      vertical.b
      inverted.b
      direction.l
      
      increment.f
      scrollstep.f
      
      page._s_page
      area._s_page
      thumb._s_page  
      button._s_button[4]
    EndStructure
    
    ;- - _s_image
    Structure _s_image
      y.l[3]
      x.l[3]
      height.l
      width.l
      
      index.l
      handle.i[2] ; - editor
      change.b
      padding.l
      
      align._s_align
    EndStructure
    
    ;- - _s_line_
    Structure _s_line_
      v._s_coordinate
      h._s_coordinate
    EndStructure
    
    ;- - _s_tt
    Structure _s_tt Extends _s_coordinate
      window.i
      gadget.i
      
      visible.b
      
      text._s_text
      image._s_image
      color._s_color
    EndStructure
    
    ;- - _s_splitter
    Structure _s_splitter
      *first._s_widget
      *second._s_widget
      
      fixed.l[3]
      
      g_first.b
      g_second.b
    EndStructure
    
    ;- - _s_scroll
    Structure _s_scroll Extends _s_coordinate
      *v._s_widget
      *h._s_widget
    EndStructure
    
    ;- - _s_popup
    Structure _s_popup
      gadget.i
      window.i
      
      ; *Widget._s_widget
    EndStructure
    
    ;- - _s_count
    Structure _s_count
      items.l
      
      childrens.l
    EndStructure
    
    ;- - _s_margin
    Structure _s_margin Extends _s_coordinate
      color._s_color
      hide.b
    EndStructure
    
    ;- - _s_items
    Structure _s_items Extends _s_coordinate
      index.l
      *parent._s_items
      draw.b
      hide.b
      
      image._s_image
      text._s_text[4]
      box._s_box[2]
      color._s_color
      
      ;state.b
      round.a
      
      sublevel.l
      childrens.l
      sublevellen.l
      
      *data      ; set/get item data
    EndStructure
    
    ;- - _s_rows
    Structure _s_rows Extends _s_coordinate 
      ; list view
      sublevel.l
      sublevellen.l
      
      len.l ; ?????? ?????? ??????? ?????
      fontID.i
      childrens.l
      
      l._s_line_ ; 
      *last._s_rows
      *first._s_rows
      *parent._s_rows
      box._s_box[2]
      *option_group._s_rows
      
      ; edit
      margin._s_edit
      
      ;
      index.l  ; Index of new list element
      hide.b
      draw.b
      round.a
      text._s_text
      image._s_image
      color._s_color
      *data  ; set/get item data
    EndStructure
    
    ;- - _s_row
    Structure _s_row
      ; list view
      drag.b
      FontID.i
      scrolled.b
      sublevel.l
      sublevellen.l
      
      *tt._s_tt
      *first._s_rows
      List *draws._s_rows()
      
      ; edit
      ;caret._s_caret
      ;color._s_color
      margin._s_margin
      
      ;
      count.l
      index.l
      box._s_box          ; editor - edit rectangle
      *selected._s_rows
      List _s._s_rows()
    EndStructure
    
    ;- - _s_tabs
    Structure _s_tabs Extends _s_coordinate
      index.l  ; Index of new list element
      hide.b
      draw.b
      round.a
      text._s_text
      image._s_image
      color._s_color
    EndStructure
    
    ;- - _s_tab
    Structure _s_tab
      index.l ; [3] ; index[0]-parent tab  ; inex[1]-entered tab ; index[2]-selected tab
      count.l ; count tab items
      opened.l; parent open list item id
      scrolled.l    ; panel set state tab
      bar._s_bar
      
      List _s._s_tabs()
    EndStructure
    
    ;- - _s_widget
    Structure _s_widget 
      type.b ;[3] ; [2] for splitter
      
      y.l[5]
      x.l[5]
      height.l[5]
      width.l[5]
      
      *root._s_root     ; adress root
      *parent._s_widget ; adress parent
      *gadget._s_widget ; this\canvas\gadget ; root\active\gadget
      *window._s_widget ; this\canvas\window ; root\active\window
      
      *scroll._s_scroll 
      *splitter._s_splitter
      
      bar._s_bar
      caption._s_caption
      color._s_color[4]
      row._s_row
      tab._s_tab
      
      errors.b
      state.b     ; mouse current state(#normal=0;#entered=1;#selected=2;#disabled=3)
      index.i[3]  ; Index[#normal=0] of new list element ; inex[#entered=1] ; index[#selected=2]
      adress.i
      round.a
      from.l
      
      ;mode.l  ; track bar
      change.l[2]
      cursor.l[2]
      hide.b[2]
      vertical.b
      
      
      fs.i 
      bs.i
      grid.i
      enumerate.i
      __height.i ; 
      drawing.i
      container.i
      
      countitems.i[2]
      
      interact.i 
      attribute.i
      
      repaint.i
      resize.b
      
      
      *Popup._s_widget
      
      combo_box._s_box
      check_box._s_box
      option_box._s_box
      *option_group._s_widget
      
      
      class.s ; 
      type_index.l
      type_count.l
      
      level.l ; ??????????? ???????
      count._s_count
      List *childrens._s_widget()
      
      List *items._s_items()
      List *columns._s_widget()
      
      flag._s_flag
      text._s_text 
      image._s_image[2]
      *align._s_align
      
      *selector._s_transform[#__anchors+1]
      *event._s_event_
      *data
    EndStructure
    
    ;- - _s_event_
    Structure _s_event_ 
      type.l
      item.l
      *data
      
      *root._s_root
      *callback.pFunc
      *widget._s_widget
      *active._s_widget ; active window
      
      colors._s_color
    ;draw.b
    EndStructure
    
    ;- - _s_root
    Structure _s_root Extends _s_widget
      canvas.i
      *anchor._s_anchor
      
      *opened._s_widget    ; open list element
      *entered._s_widget   ; at point element
      *selected._s_widget  ; pushed at point element
      
      mouse._s_mouse
      keyboard._s_keyboard
      
      event_count.b
      List *event_list._s_event_()
    EndStructure
    ;}
  EndDeclareModule 
  
  Module Structures 
    
  EndModule 
  
  ;UseModule Structures
CompilerEndIf

XIncludeFile "../colors.pbi"

DeclareModule bar
  UseModule Constants
  UseModule Structures
  
  Structure _struct_ Extends _s_widget : EndStructure
  
  Macro Root()
    *event\root
  EndMacro
  
  Macro Widget()
    *event\widget
  EndMacro
  
  ;   ;- GLOBALs
  Global *event._s_event_ = AllocateStructure(_s_event_)
  *event\colors = colors::colors 
  
  Declare.b Draw(*this)
  
  Declare.b SetState(*this, ScrollPos.f)
  Declare.l SetAttribute(*this, Attribute.l, Value.l)
  
  Declare.i Track(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=7)
  Declare.i Progress(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0)
  Declare.i Spin(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0, increment.f=1.0)
  Declare.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
  Declare.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.i=0)
  
  Declare.i Bar(type.l, size.l, min.l, max.l, pagelength.l, flag.i=0, round.l=7, parent.i=0, scrollstep.f=1.0)
  ;Declare.i Bar(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l=0, round.l=0)
  Declare.b events(*this, EventType.l, mouse_x.l, mouse_y.l, wheel_x.b=0, wheel_y.b=0)
  
  Declare.b Resize(*this, iX.l,iY.l,iWidth.l,iHeight.l)
  Declare.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l)
EndDeclareModule

Module bar
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ < (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ < (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
  Macro _box_gradient_(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _round_=0, _alpha_=255)
    BackColor(_color_1_&$FFFFFF|_alpha_<<24)
    FrontColor(_color_2_&$FFFFFF|_alpha_<<24)
    If _type_
      LinearGradient(_x_,_y_, (_x_+_width_), _y_)
    Else
      LinearGradient(_x_,_y_, _x_, (_y_+_height_))
    EndIf
    RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
  EndMacro
  
  Procedure.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
    Protected I
    
    If Not Length
      Style =- 1
    EndIf
    Length = (Size+2)/2
    
    
    If Direction = 1 ; top
      If Style > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size 
          LineXY((X+1+i)+Size,(Y+i-1)-(Style),(X+1+i)+Size,(Y+i-1)+(Style),Color)         ; Левая линия
          LineXY(((X+1+(Size))-i),(Y+i-1)-(Style),((X+1+(Size))-i),(Y+i-1)+(Style),Color) ; правая линия
        Next
      Else : x-1 : y-1
        For i = 1 To Length 
          If Style =- 1
            LineXY(x+i, (Size+y), x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y), x+Length, y, Color)
          Else
            LineXY(x+i, (Size+y)-i/2, x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y)-i/2, x+Length, y, Color)
          EndIf
        Next 
        i = Bool(Style =- 1) 
        LineXY(x, (Size+y)+Bool(i=0), x+Length, y+1, Color) 
        LineXY(x+Length*2, (Size+y)+Bool(i=0), x+Length, y+1, Color) ; bug
      EndIf
    ElseIf Direction = 3 ; bottom
      If Style > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size
          LineXY((X+1+i),(Y+i)-(Style),(X+1+i),(Y+i)+(Style),Color) ; Левая линия
          LineXY(((X+1+(Size*2))-i),(Y+i)-(Style),((X+1+(Size*2))-i),(Y+i)+(Style),Color) ; правая линия
        Next
      Else : x-1 : y+1
        For i = 0 To Length 
          If Style =- 1
            LineXY(x+i, y, x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y, x+Length, (Size+y), Color)
          Else
            LineXY(x+i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
          EndIf
        Next
      EndIf
    ElseIf Direction = 0 ; в лево
      If Style > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в лево
          LineXY(((X+1)+i)-(Style),(((Y+1)+(Size))-i),((X+1)+i)+(Style),(((Y+1)+(Size))-i),Color) ; правая линия
          LineXY(((X+1)+i)-(Style),((Y+1)+i)+Size,((X+1)+i)+(Style),((Y+1)+i)+Size,Color)         ; Левая линия
        Next  
      Else : x-1 : y-1
        For i = 1 To Length
          If Style =- 1
            LineXY((Size+x), y+i, x, y+Length, Color)
            LineXY((Size+x), y+Length*2-i, x, y+Length, Color)
          Else
            LineXY((Size+x)-i/2, y+i, x, y+Length, Color)
            LineXY((Size+x)-i/2, y+Length*2-i, x, y+Length, Color)
          EndIf
        Next 
        i = Bool(Style =- 1) 
        LineXY((Size+x)+Bool(i=0), y, x+1, y+Length, Color) 
        LineXY((Size+x)+Bool(i=0), y+Length*2, x+1, y+Length, Color)
      EndIf
    ElseIf Direction = 2 ; в право
      If Style > 0 : y-1 : x + 1
        Size / 2
        For i = 0 To Size 
          ; в право
          LineXY(((X+1)+i)-(Style),((Y+1)+i),((X+1)+i)+(Style),((Y+1)+i),Color) ; Левая линия
          LineXY(((X+1)+i)-(Style),(((Y+1)+(Size*2))-i),((X+1)+i)+(Style),(((Y+1)+(Size*2))-i),Color) ; правая линия
        Next
      Else : y-1 : x+1
        For i = 0 To Length 
          If Style =- 1
            LineXY(x, y+i, Size+x, y+Length, Color)
            LineXY(x, y+Length*2-i, Size+x, y+Length, Color)
          Else
            LineXY(x+i/2-Bool(i=0), y+i, Size+x, y+Length, Color)
            LineXY(x+i/2-Bool(i=0), y+Length*2-i, Size+x, y+Length, Color)
          EndIf
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  ;-
  ; SCROLLBAR
  Macro _childrens_move_(_this_, _change_x_, _change_y_)
    ;Debug  Str(_this_\x-_this_\bs) +" "+ _this_\x[2]
    
    If ListSize(_this_\childrens())
      ForEach _this_\childrens()
        Resize(_this_\childrens(), 
               (_this_\childrens()\x-_this_\x-_this_\bs) + _change_x_,
               (_this_\childrens()\y-_this_\y-_this_\bs-_this_\__height) + _change_y_, 
               #PB_Ignore, #PB_Ignore)
      Next
    EndIf
  EndMacro
  
  Procedure.b splitter_size(*this._struct_)
    If *this\splitter
      If *this\splitter\first
        If *this\splitter\g_first
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\bar\vertical
            ResizeGadget(*this\splitter\first, *this\bar\button[#__b_1]\x-*this\x, ((*this\bar\button[#__b_2]\height+*this\bar\thumb\len)-*this\bar\button[#__b_1]\y)-*this\y, *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
          Else
            ResizeGadget(*this\splitter\first, *this\bar\button[#__b_1]\x-*this\x, *this\bar\button[#__b_1]\y-*this\y, *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
          EndIf
        Else
          Resize(*this\splitter\first, *this\bar\button[#__b_1]\x-*this\x, *this\bar\button[#__b_1]\y-*this\y, *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
        EndIf
      EndIf
      
      If *this\splitter\second
        If *this\splitter\g_second
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\bar\vertical
            ResizeGadget(*this\splitter\second, *this\bar\button[#__b_2]\x-*this\x, ((*this\bar\button[#__b_1]\height+*this\bar\thumb\len)-*this\bar\button[#__b_2]\y)-*this\y, *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
          Else
            ResizeGadget(*this\splitter\second, *this\bar\button[#__b_2]\x-*this\x, *this\bar\button[#__b_2]\y-*this\y, *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
          EndIf
        Else
          Resize(*this\splitter\second, *this\bar\button[#__b_2]\x-*this\x, *this\bar\button[#__b_2]\y-*this\y, *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
        EndIf   
      EndIf   
    EndIf
  EndProcedure
  
  Macro _splitter_size_(_this_)
    If _this_\splitter
      If _this_\splitter\first
        If _this_\splitter\g_first
          If (#PB_Compiler_OS = #PB_OS_MacOS) And _this_\bar\vertical
            ResizeGadget(_this_\splitter\first, _this_\bar\button[#__b_1]\x, (_this_\bar\button[#__b_2]\height+_this_\bar\thumb\len)-_this_\bar\button[#__b_1]\y, _this_\bar\button[#__b_1]\width, _this_\bar\button[#__b_1]\height)
          Else
            ResizeGadget(_this_\splitter\first, _this_\bar\button[#__b_1]\x, _this_\bar\button[#__b_1]\y, _this_\bar\button[#__b_1]\width, _this_\bar\button[#__b_1]\height)
          EndIf
        Else
          Resize(_this_\splitter\first, _this_\bar\button[#__b_1]\x, _this_\bar\button[#__b_1]\y, _this_\bar\button[#__b_1]\width, _this_\bar\button[#__b_1]\height)
        EndIf
      EndIf
      
      If _this_\splitter\second
        If _this_\splitter\g_second
          If (#PB_Compiler_OS = #PB_OS_MacOS) And _this_\bar\vertical
            ResizeGadget(_this_\splitter\second, _this_\bar\button[#__b_2]\x, (_this_\bar\button[#__b_1]\height+_this_\bar\thumb\len)-_this_\bar\button[#__b_2]\y, _this_\bar\button[#__b_2]\width, _this_\bar\button[#__b_2]\height)
          Else
            ResizeGadget(_this_\splitter\second, _this_\bar\button[#__b_2]\x, _this_\bar\button[#__b_2]\y, _this_\bar\button[#__b_2]\width, _this_\bar\button[#__b_2]\height)
          EndIf
        Else
          Resize(_this_\splitter\second, _this_\bar\button[#__b_2]\x, _this_\bar\button[#__b_2]\y, _this_\bar\button[#__b_2]\width, _this_\bar\button[#__b_2]\height)
        EndIf   
      EndIf   
    EndIf
  EndMacro
  ;   Macro _splitter_size_(_this_)
  ;     ;     If _this_\bar\Vertical
  ;     ;       Resize(_this_\splitter\first, 0, 0, _this_\width, _this_\bar\thumb\pos-_this_\y)
  ;     ;       Resize(_this_\splitter\second, 0, (_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\y, _this_\width, _this_\height-((_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\y))
  ;     ;     Else
  ;     ;       Resize(_this_\splitter\first, 0, 0, _this_\bar\thumb\pos-_this_\x, _this_\height)
  ;     ;       Resize(_this_\splitter\second, (_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\x, 0, _this_\width-((_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\x), _this_\height)
  ;     ;     EndIf
  ;     
  ;     Resize(_this_\splitter\first, _this_\bar\button[#__b_1]\x-_this_\x, _this_\bar\button[#__b_1]\y-_this_\y, _this_\bar\button[#__b_1]\width, _this_\bar\button[#__b_1]\height)
  ;     Resize(_this_\splitter\second, _this_\bar\button[#__b_2]\x-_this_\x, _this_\bar\button[#__b_2]\y-_this_\y, _this_\bar\button[#__b_2]\width, _this_\bar\button[#__b_2]\height)
  ;     
  ;   EndMacro
  
  Macro _text_change_(_this_, _x_, _y_, _width_, _height_)
    ;If _this_\text\vertical
    If _this_\text\rotate = 90
      If _this_\y<>_y_
        _this_\text\x = _x_ + _this_\y
      Else
        _this_\text\x = _x_ + (_width_-_this_\text\height)/2
      EndIf
      
      If _this_\text\align\right
        _this_\text\y = _y_ +_this_\text\align\height+ _this_\text\padding+_this_\text\width
      ElseIf _this_\text\align\horizontal
        _this_\text\y = _y_ + (_height_+_this_\text\align\height+_this_\text\width)/2
      Else
        _this_\text\y = _y_ + _height_-_this_\text\padding
      EndIf
      
    ElseIf _this_\text\rotate = 270
      _this_\text\x = _x_ + (_width_-_this_\y)
      
      If _this_\text\align\right
        _this_\text\y = _y_ + (_height_-_this_\text\width-_this_\text\padding) 
      ElseIf _this_\text\align\horizontal
        _this_\text\y = _y_ + (_height_-_this_\text\width)/2 
      Else
        _this_\text\y = _y_ + _this_\text\padding 
      EndIf
      
    EndIf
    
    ;Else
    If _this_\text\rotate = 0
      If _this_\x<>_x_
        _this_\text\y = _y_ + _this_\y
      Else
        _this_\text\y = _y_ + (_height_-_this_\text\height)/2
      EndIf
      
      If _this_\text\align\right
        _this_\text\x = _x_ + (_width_-_this_\text\align\width-_this_\text\width-_this_\text\padding) 
      ElseIf _this_\text\align\horizontal
        _this_\text\x = _x_ + (_width_-_this_\text\align\width-_this_\text\width)/2
      Else
        _this_\text\x = _x_ + _this_\text\padding
      EndIf
      
    ElseIf _this_\text\rotate = 180
      _this_\text\y = _y_ + (_height_-_this_\y)
      
      If _this_\text\align\right
        _this_\text\x = _x_ + _this_\text\padding+_this_\text\width
      ElseIf _this_\text\align\horizontal
        _this_\text\x = _x_ + (_width_+_this_\text\width)/2 
      Else
        _this_\text\x = _x_ + _width_-_this_\text\padding 
      EndIf
      
    EndIf
    ;EndIf
  EndMacro
  
  
  Macro _thumb_pos_(_bar_, _scroll_pos_)
    (_bar_\area\pos + Round((_scroll_pos_-_bar_\min) * _bar_\increment, #PB_Round_Nearest)) 
    ; (_bar_\area\pos + Round((_scroll_pos_-_bar_\min) * (_bar_\area\len / (_bar_\max-_bar_\min)), #PB_round_nearest)) 
  EndMacro
  
  Macro _thumb_len_(_bar_)
    Round(_bar_\area\len - (_bar_\area\len / (_bar_\max-_bar_\min)) * ((_bar_\max-_bar_\min) - _bar_\page\len), #PB_Round_Nearest)
  EndMacro
  
  Macro _scrolled_(_this_, _pos_, _len_)
    Bool(Bool(((_pos_)-_this_\bar\page\pos) < 0 And SetState(_this_, (_pos_))) Or
         Bool(((_pos_)-_this_\bar\page\pos) > (_this_\bar\page\len-(_len_)) And SetState(_this_, (_pos_)-(_this_\bar\page\len-(_len_)))))
  EndMacro
  
  ; Then scroll bar start position
  Macro _in_start_(_bar_) : Bool(_bar_\page\pos =< _bar_\min) : EndMacro
  
  ; Then scroll bar end position
  Macro _in_stop_(_bar_) : Bool(_bar_\page\pos >= (_bar_\max-_bar_\page\len)) : EndMacro
  
  ; Inverted scroll bar position
  Macro _invert_(_bar_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_bar_\min + (_bar_\max - _bar_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  Macro _area_pos_(_this_)
    If _this_\bar\vertical
      _this_\bar\area\pos = _this_\y + _this_\bar\button[#__b_1]\len
      _this_\bar\area\len = _this_\height - (_this_\bar\button[#__b_1]\len + _this_\bar\button[#__b_2]\len)
    Else
      _this_\bar\area\len = _this_\width - (_this_\bar\button[#__b_1]\len + _this_\bar\button[#__b_2]\len)
      _this_\bar\area\pos = _this_\x + _this_\bar\button[#__b_1]\len
    EndIf
    
    _this_\bar\area\end = _this_\bar\area\pos + (_this_\bar\area\len - _this_\bar\thumb\len)
    _this_\bar\increment = (_this_\bar\area\len / (_this_\bar\max - _this_\bar\min))
  EndMacro
  
  Macro _pos_(_this_, _scroll_pos_)
    _thumb_pos_(_this_\bar, _scroll_pos_)
    
    If _this_\bar\thumb\pos < _this_\bar\area\pos 
      _this_\bar\thumb\pos = _this_\bar\area\pos 
    EndIf 
    
    If _this_\bar\thumb\pos > _this_\bar\area\end
      _this_\bar\thumb\pos = _this_\bar\area\end
    EndIf
    
    If _this_\type=#PB_GadgetType_Spin
      If _this_\bar\vertical 
        _this_\bar\button\x = _this_\X + _this_\width - #__spin_buttonsize2
        _this_\bar\button\width = #__spin_buttonsize2
      Else 
        _this_\bar\button\y = _this_\Y + _this_\Height - #__spin_buttonsize2
        _this_\bar\button\height = #__spin_buttonsize2 
      EndIf
    Else
      If _this_\bar\vertical 
        _this_\bar\button\x = _this_\X + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
        _this_\bar\button\width = _this_\width - Bool(_this_\type=#PB_GadgetType_ScrollBar) 
        _this_\bar\button\y = _this_\bar\area\pos
        _this_\bar\button\height = _this_\bar\area\len               
      Else 
        _this_\bar\button\y = _this_\Y + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
        _this_\bar\button\height = _this_\Height - Bool(_this_\type=#PB_GadgetType_ScrollBar)  
        _this_\bar\button\x = _this_\bar\area\pos
        _this_\bar\button\width = _this_\bar\area\len
      EndIf
    EndIf
    
    ; _start_
    If _this_\bar\button[#__b_1]\len 
      If _scroll_pos_ = _this_\bar\min
        _this_\bar\button[#__b_1]\color\state = #__s_3
        _this_\bar\button[#__b_1]\interact = 0
      Else
        If _this_\bar\button[#__b_1]\color\state <> #__s_2
          _this_\bar\button[#__b_1]\color\state = #__s_0
        EndIf
        _this_\bar\button[#__b_1]\interact = 1
      EndIf 
    EndIf
    
    If _this_\type=#PB_GadgetType_ScrollBar Or 
       _this_\type=#PB_GadgetType_Spin
      
      If _this_\bar\vertical 
        ; Top button coordinate on vertical scroll bar
        _this_\bar\button[#__b_1]\x = _this_\bar\button\x
        _this_\bar\button[#__b_1]\y = _this_\Y 
        _this_\bar\button[#__b_1]\width = _this_\bar\button\width
        _this_\bar\button[#__b_1]\height = _this_\bar\button[#__b_1]\len                   
      Else 
        ; Left button coordinate on horizontal scroll bar
        _this_\bar\button[#__b_1]\x = _this_\X 
        _this_\bar\button[#__b_1]\y = _this_\bar\button\y
        _this_\bar\button[#__b_1]\width = _this_\bar\button[#__b_1]\len 
        _this_\bar\button[#__b_1]\height = _this_\bar\button\height 
      EndIf
      
    ElseIf _this_\type = #PB_GadgetType_TrackBar
    Else
      _this_\bar\button[#__b_1]\x = _this_\X
      _this_\bar\button[#__b_1]\y = _this_\Y
      
      If _this_\bar\vertical
        _this_\bar\button[#__b_1]\width = _this_\width
        _this_\bar\button[#__b_1]\height = _this_\bar\thumb\pos-_this_\y 
      Else
        _this_\bar\button[#__b_1]\width = _this_\bar\thumb\pos-_this_\x 
        _this_\bar\button[#__b_1]\height = _this_\height
      EndIf
    EndIf
    
    ; _stop_
    If _this_\bar\button[#__b_2]\len
      ; Debug ""+ Bool(_this_\bar\thumb\pos = _this_\bar\area\end) +" "+ Bool(_scroll_pos_ = _this_\bar\page\end)
      If _scroll_pos_ = _this_\bar\page\end
        _this_\bar\button[#__b_2]\color\state = #__s_3
        _this_\bar\button[#__b_2]\interact = 0
      Else
        If _this_\bar\button[#__b_2]\color\state <> #__s_2
          _this_\bar\button[#__b_2]\color\state = #__s_0
        EndIf
        _this_\bar\button[#__b_2]\interact = 1
      EndIf 
    EndIf
    
    If _this_\type = #PB_GadgetType_ScrollBar Or 
       _this_\type = #PB_GadgetType_Spin
      If _this_\bar\vertical 
        ; Botom button coordinate on vertical scroll bar
        _this_\bar\button[#__b_2]\x = _this_\bar\button\x
        _this_\bar\button[#__b_2]\width = _this_\bar\button\width
        _this_\bar\button[#__b_2]\height = _this_\bar\button[#__b_2]\len 
        _this_\bar\button[#__b_2]\y = _this_\Y+_this_\Height-_this_\bar\button[#__b_2]\height
      Else 
        ; Right button coordinate on horizontal scroll bar
        _this_\bar\button[#__b_2]\y = _this_\bar\button\y
        _this_\bar\button[#__b_2]\height = _this_\bar\button\height
        _this_\bar\button[#__b_2]\width = _this_\bar\button[#__b_2]\len 
        _this_\bar\button[#__b_2]\x = _this_\X+_this_\width-_this_\bar\button[#__b_2]\width 
      EndIf
      
    ElseIf _this_\type = #PB_GadgetType_TrackBar
    Else
      If _this_\bar\vertical
        _this_\bar\button[#__b_2]\x = _this_\x
        _this_\bar\button[#__b_2]\y = _this_\bar\thumb\pos+_this_\bar\thumb\len
        _this_\bar\button[#__b_2]\width = _this_\width
        _this_\bar\button[#__b_2]\height = _this_\height-(_this_\bar\thumb\pos+_this_\bar\thumb\len-_this_\y)
      Else
        _this_\bar\button[#__b_2]\x = _this_\bar\thumb\pos+_this_\bar\thumb\len
        _this_\bar\button[#__b_2]\y = _this_\Y
        _this_\bar\button[#__b_2]\width = _this_\width-(_this_\bar\thumb\pos+_this_\bar\thumb\len-_this_\x)
        _this_\bar\button[#__b_2]\height = _this_\height
      EndIf
    EndIf
    
    ; Thumb coordinate on scroll bar
    If _this_\bar\thumb\len
      ;       If _this_\bar\button[#__b_3]\len <> _this_\bar\thumb\len
      ;         _this_\bar\button[#__b_3]\len = _this_\bar\thumb\len
      ;       EndIf
      
      If _this_\bar\vertical
        _this_\bar\button[#__b_3]\x = _this_\bar\button\x 
        _this_\bar\button[#__b_3]\width = _this_\bar\button\width 
        _this_\bar\button[#__b_3]\y = _this_\bar\thumb\pos
        _this_\bar\button[#__b_3]\height = _this_\bar\thumb\len                              
      Else
        _this_\bar\button[#__b_3]\y = _this_\bar\button\y 
        _this_\bar\button[#__b_3]\height = _this_\bar\button\height
        _this_\bar\button[#__b_3]\x = _this_\bar\thumb\pos 
        _this_\bar\button[#__b_3]\width = _this_\bar\thumb\len                                  
      EndIf
      
    Else
      If _this_\type = #PB_GadgetType_Spin Or 
         _this_\type = #PB_GadgetType_ScrollBar
        ; ????? ???? ???????
        If _this_\bar\vertical
          _this_\bar\button[#__b_2]\Height = _this_\Height/2 
          _this_\bar\button[#__b_2]\y = _this_\y+_this_\bar\button[#__b_2]\Height+Bool(_this_\Height%2) 
          
          _this_\bar\button[#__b_1]\y = _this_\y 
          _this_\bar\button[#__b_1]\Height = _this_\Height/2
          
        Else
          _this_\bar\button[#__b_2]\width = _this_\width/2 
          _this_\bar\button[#__b_2]\x = _this_\x+_this_\bar\button[#__b_2]\width+Bool(_this_\width%2) 
          
          _this_\bar\button[#__b_1]\x = _this_\x 
          _this_\bar\button[#__b_1]\width = _this_\width/2
        EndIf
      EndIf
    EndIf
    
    If _this_\type = #PB_GadgetType_Spin
      If _this_\bar\vertical      
        ; Top button coordinate
        _this_\bar\button[#__b_2]\y = _this_\y+_this_\height/2 + Bool(_this_\height%2) 
        _this_\bar\button[#__b_2]\height = _this_\height/2 
        _this_\bar\button[#__b_2]\width = _this_\bar\button\len 
        _this_\bar\button[#__b_2]\x = _this_\x+_this_\width-_this_\bar\button\len
        
        ; Bottom button coordinate
        _this_\bar\button[#__b_1]\y = _this_\y 
        _this_\bar\button[#__b_1]\height = _this_\height/2 
        _this_\bar\button[#__b_1]\width = _this_\bar\button\len 
        _this_\bar\button[#__b_1]\x = _this_\x+_this_\width-_this_\bar\button\len                                 
      Else    
        ; Left button coordinate
        _this_\bar\button[#__b_1]\y = _this_\y 
        _this_\bar\button[#__b_1]\height = _this_\height 
        _this_\bar\button[#__b_1]\width = _this_\bar\button\len/2 
        _this_\bar\button[#__b_1]\x = _this_\x+_this_\width-_this_\bar\button\len    
        
        ; Right button coordinate
        _this_\bar\button[#__b_2]\y = _this_\y 
        _this_\bar\button[#__b_2]\height = _this_\height 
        _this_\bar\button[#__b_2]\width = _this_\bar\button\len/2 
        _this_\bar\button[#__b_2]\x = _this_\x+_this_\width-_this_\bar\button\len/2                               
      EndIf
    EndIf
    
    ; draw track bar coordinate
    If _this_\type = #PB_GadgetType_TrackBar
      If _this_\bar\vertical
        _this_\bar\button[#__b_1]\width = 4
        _this_\bar\button[#__b_2]\width = 4
        _this_\bar\button[#__b_3]\width = _this_\bar\button[#__b_3]\len+(Bool(_this_\bar\button[#__b_3]\len<10)*_this_\bar\button[#__b_3]\len)
        
        _this_\bar\button[#__b_1]\y = _this_\Y
        _this_\bar\button[#__b_1]\height = _this_\bar\thumb\pos-_this_\y + _this_\bar\thumb\len/2
        
        _this_\bar\button[#__b_2]\y = _this_\bar\thumb\pos+_this_\bar\thumb\len/2
        _this_\bar\button[#__b_2]\height = _this_\height-(_this_\bar\thumb\pos+_this_\bar\thumb\len/2-_this_\y)
        
        If _this_\bar\inverted
          _this_\bar\button[#__b_1]\x = _this_\x+6
          _this_\bar\button[#__b_2]\x = _this_\x+6
          _this_\bar\button[#__b_3]\x = _this_\bar\button[#__b_1]\x-_this_\bar\button[#__b_3]\width/4-1- Bool(_this_\bar\button[#__b_3]\len>10)
        Else
          _this_\bar\button[#__b_1]\x = _this_\x+_this_\width-_this_\bar\button[#__b_1]\width-6
          _this_\bar\button[#__b_2]\x = _this_\x+_this_\width-_this_\bar\button[#__b_2]\width-6 
          _this_\bar\button[#__b_3]\x = _this_\bar\button[#__b_1]\x-_this_\bar\button[#__b_3]\width/2 + Bool(_this_\bar\button[#__b_3]\len>10)
        EndIf
      Else
        _this_\bar\button[#__b_1]\height = 4
        _this_\bar\button[#__b_2]\height = 4
        _this_\bar\button[#__b_3]\height = _this_\bar\button[#__b_3]\len+(Bool(_this_\bar\button[#__b_3]\len<10)*_this_\bar\button[#__b_3]\len)
        
        _this_\bar\button[#__b_1]\x = _this_\X
        _this_\bar\button[#__b_1]\width = _this_\bar\thumb\pos-_this_\x + _this_\bar\thumb\len/2
        
        _this_\bar\button[#__b_2]\x = _this_\bar\thumb\pos+_this_\bar\thumb\len/2
        _this_\bar\button[#__b_2]\width = _this_\width-(_this_\bar\thumb\pos+_this_\bar\thumb\len/2-_this_\x)
        
        If _this_\bar\inverted
          _this_\bar\button[#__b_1]\y = _this_\y+_this_\height-_this_\bar\button[#__b_1]\height-6
          _this_\bar\button[#__b_2]\y = _this_\y+_this_\height-_this_\bar\button[#__b_2]\height-6 
          _this_\bar\button[#__b_3]\y = _this_\bar\button[#__b_1]\y-_this_\bar\button[#__b_3]\height/2 + Bool(_this_\bar\button[#__b_3]\len>10)
        Else
          _this_\bar\button[#__b_1]\y = _this_\y+6
          _this_\bar\button[#__b_2]\y = _this_\y+6
          _this_\bar\button[#__b_3]\y = _this_\bar\button[#__b_1]\y-_this_\bar\button[#__b_3]\height/4-1- Bool(_this_\bar\button[#__b_3]\len>10)
        EndIf
      EndIf
    EndIf
    
    ;     If _this_\Scroll And _this_\Scroll\v And _this_\Scroll\h
    ;       _this_\Scroll\x = _this_\Scroll\h\x-_this_\Scroll\h\bar\page\pos
    ;       _this_\Scroll\y = _this_\Scroll\v\y-_this_\Scroll\v\bar\page\pos
    ;       _this_\Scroll\width = _this_\Scroll\h\bar\max
    ;       _this_\Scroll\height = _this_\Scroll\v\bar\max
    ;     EndIf
    
    If _this_\Splitter 
      ; Splitter childrens auto resize       
      _splitter_size_(_this_)
    EndIf
    
    If _this_\bar\change
      If _this_\text
        _this_\text\change = 1
        _this_\text\string = "%"+Str(_this_\bar\page\Pos)
      EndIf
      
      
      ; ScrollArea childrens auto resize 
      If _this_\parent\scroll
        _this_\parent\change =- 1
        
        If _this_\bar\vertical
          _this_\parent\scroll\y = - _this_\bar\page\pos ; _this_\y 
                                                         ;_this_\parent\scroll\height = _this_\bar\max
          _childrens_move_(_this_\parent, 0, _this_\bar\change)
        Else
          _this_\parent\scroll\x = - _this_\bar\page\pos ; _this_\x 
                                                         ;_this_\parent\scroll\width = _this_\bar\max
          _childrens_move_(_this_\parent, _this_\bar\change, 0)
        EndIf
      EndIf
      
      ;       ; bar change
      ;       Post(#PB_EventType_StatusChange, _this_, _this_\from, _this_\bar\direction)
      ;     Else
      ;       If _this_\parent\scroll
      ;         If _this_\bar\vertical
      ;           _this_\parent\scroll\y = _this_\y
      ;         Else
      ;           _this_\parent\scroll\x = _this_\x
      ;         EndIf
      ;       EndIf
    EndIf
    
  EndMacro
  
  Procedure.i changePos(*bar._s_bar, ScrollPos.f)
    With *bar
      If ScrollPos < \min : ScrollPos = \min : EndIf
      
      If \max And ScrollPos > \max-\page\len
        If \max > \page\len 
          ScrollPos = \max-\page\len
        Else
          ScrollPos = \min 
        EndIf
      EndIf
      
      If \page\pos <> ScrollPos
        \change = \page\pos - ScrollPos
        
        If \page\pos > ScrollPos
          \direction =- ScrollPos
          
          If ScrollPos = \min Or \mode = #__bar_ticks 
            \button[#__b_3]\arrow\direction = Bool(Not \vertical) + Bool(\vertical = \inverted) * 2
          Else
            \button[#__b_3]\arrow\direction = Bool(\vertical) + Bool(\inverted) * 2
          EndIf
        Else
          \direction = ScrollPos
          
          If ScrollPos = \page\end Or \mode = #__bar_ticks
            \button[#__b_3]\arrow\direction = Bool(Not \vertical) + Bool(\vertical = \inverted) * 2
          Else
            \button[#__b_3]\arrow\direction = Bool(\vertical) + Bool(Not \inverted ) * 2
          EndIf
        EndIf
        
        \page\pos = ScrollPos
        ProcedureReturn #True
      EndIf
    EndWith
  EndProcedure
  
  Procedure.b update(*this._struct_)
    With *this
      If (\bar\max-\bar\min) >= \bar\page\len
        ; Get area screen coordinate 
        ; pos (x&y) And Len (width&height)
        _area_pos_(*this)
        
        ;
        If Not \bar\max And \width And \height And (\splitter Or \bar\page\pos) 
          \bar\max = \bar\area\len-\bar\button[#__b_3]\len
          
          If Not \bar\page\pos
            \bar\page\pos = (\bar\max)/2 - Bool(  (\splitter And \splitter\fixed=#__b_1))
          EndIf
          
          ;           ; if splitter fixed set splitter pos to center
          ;           If \splitter And \splitter\fixed = #__b_1
          ;             \splitter\fixed[\splitter\fixed] = \bar\page\pos
          ;           EndIf
          ;           If \splitter And \splitter\fixed = #__b_2
          ;             \splitter\fixed[\splitter\fixed] = \bar\area\len-\bar\page\pos-\bar\button[#__b_3]\len  + 1
          ;           EndIf
        EndIf
        
        If \splitter 
          If \splitter\fixed
            If \bar\area\len - \bar\button[#__b_3]\len > \splitter\fixed[\splitter\fixed] 
              \bar\page\pos = Bool(\splitter\fixed = 2) * \bar\max
              
              If \splitter\fixed[\splitter\fixed] > \bar\button[#__b_3]\len
                \bar\area\pos + \splitter\fixed[1]
                \bar\area\len - \splitter\fixed[2]
              EndIf
            Else
              \splitter\fixed[\splitter\fixed] = \bar\area\len - \bar\button[#__b_3]\len
              \bar\page\pos = Bool(\splitter\fixed = 1) * \bar\max
            EndIf
          EndIf
          
          ; Debug ""+\bar\area\len +" "+ Str(\bar\button[#__b_1]\len + \bar\button[#__b_2]\len)
          
          If \bar\area\len =< \bar\button[#__b_3]\len
            \bar\page\pos = \bar\max/2
            
            If \bar\vertical
              \bar\area\pos = \Y 
              \bar\area\len = \Height
            Else
              \bar\area\pos = \X
              \bar\area\len = \width 
            EndIf
          EndIf
          
        EndIf
        
        If \bar\area\len > \bar\button[#__b_3]\len
          \bar\thumb\len = _thumb_len_(\bar)
          
          If \bar\thumb\len > \bar\area\len 
            \bar\thumb\len = \bar\area\len 
          EndIf 
          
          If \bar\thumb\len > \bar\button[#__b_3]\len
            \bar\area\end = \bar\area\pos + (\bar\area\len-\bar\thumb\len)
          Else
            \bar\area\len = \bar\area\len - (\bar\button[#__b_3]\len-\bar\thumb\len)
            \bar\area\end = \bar\area\pos + (\bar\area\len-\bar\thumb\len)                              
            \bar\thumb\len = \bar\button[#__b_3]\len
          EndIf
          
        Else
          If \splitter
            \bar\thumb\len = \width
          Else
            \bar\thumb\len = 0
          EndIf
          
          If \bar\vertical
            \bar\area\pos = \Y
            \bar\area\len = \Height
          Else
            \bar\area\pos = \X
            \bar\area\len = \width 
          EndIf
          
          \bar\area\end = \bar\area\pos + (\bar\area\len - \bar\thumb\len)
        EndIf
        
        If \bar\area\len 
          \bar\page\end = \bar\max - \bar\page\len
          \bar\increment = (\bar\area\len / (\bar\max - \bar\min))
          \bar\thumb\pos = _pos_(*this, _invert_(*this\bar, \bar\page\pos, \bar\inverted))
          
          If #PB_GadgetType_ScrollBar = \type And \bar\thumb\pos = \bar\area\end And \bar\page\pos <> \bar\page\end And _in_stop_(\bar)
            ;    Debug " line-" + #PB_compiler_line +" "+  \bar\max 
            ;             If \bar\inverted
            ;              SetState(*this, _invert_(*this\bar, \bar\max, \bar\inverted))
            ;             Else
            SetState(*this, \bar\page\end)
            ;             EndIf
          EndIf
        EndIf
      EndIf
      
      If \type = #PB_GadgetType_ScrollBar
        \bar\hide = Bool(Not ((\bar\max-\bar\min) > \bar\page\len))
      EndIf
      
      ProcedureReturn \bar\hide
    EndWith
  EndProcedure
  
  Procedure.i SetPos(*this._struct_, ThumbPos.i)
    Protected ScrollPos.f, Result.i
    
    With *this
      If \splitter And \splitter\fixed
        _area_pos_(*this)
      EndIf
      
      If ThumbPos < \bar\area\pos : ThumbPos = \bar\area\pos : EndIf
      If ThumbPos > \bar\area\end : ThumbPos = \bar\area\end : EndIf
      
      If \bar\thumb\end <> ThumbPos 
        \bar\thumb\end = ThumbPos
        
        ; from thumb pos get scroll pos 
        If \bar\area\end <> ThumbPos
          ScrollPos = \bar\min + Round((ThumbPos - \bar\area\pos) / (\bar\area\len / (\bar\max-\bar\min)), #PB_Round_Nearest)
        Else
          ScrollPos = \bar\page\end
        EndIf
        
        Result = SetState(*this, _invert_(*this\bar, ScrollPos, \bar\inverted))
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetState(*this._struct_, ScrollPos.f)
    Protected Result.b
    
    With *this
      If changePos(*this\bar, ScrollPos)
        \bar\thumb\pos = _pos_(*this, _invert_(*this\bar, \bar\page\pos, \bar\inverted))
        
        If \splitter And \splitter\fixed = #__b_1
          \splitter\fixed[\splitter\fixed] = \bar\thumb\pos - \bar\area\pos
          \bar\page\pos = 0
        EndIf
        If \splitter And \splitter\fixed = #__b_2
          \splitter\fixed[\splitter\fixed] = \bar\area\len - ((\bar\thumb\pos+\bar\thumb\len)-\bar\area\pos)
          \bar\page\pos = \bar\max
        EndIf
        
        \bar\change = #False
        \change = #True
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetAttribute(*this._struct_, Attribute.l, Value.l)
    Protected Result.l
    
    With *this
      If \splitter
        Select Attribute
          Case #PB_Splitter_FirstMinimumSize
            \bar\button[#__b_1]\len = Value
            Result = Bool(\bar\max)
            
          Case #PB_Splitter_SecondMinimumSize
            \bar\button[#__b_2]\len = Value
            Result = Bool(\bar\max)
            
            
        EndSelect
      Else
        Select Attribute
          Case #__bar_minimum
            If \bar\min <> Value
              \bar\min = Value
              \bar\page\pos = Value
              Result = #True
            EndIf
            
          Case #__bar_maximum
            If \bar\max <> Value
              If \bar\min > Value
                \bar\max = \bar\min + 1
              Else
                \bar\max = Value
              EndIf
              
              If \bar\max = 0
                \bar\page\pos = 0
              EndIf
              
              Result = #True
            EndIf
            
          Case #__bar_pageLength
            If \bar\page\len <> Value
              \bar\page\len = Value
              
              If Not \bar\max
                If \bar\min > Value
                  \bar\max = \bar\min + 1
                Else
                  \bar\max = Value
                EndIf
              EndIf
              
              ;               If Value > (\bar\max-\bar\min) 
              ;                 ;\bar\max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает
              ; ;                 If \bar\max = 0 
              ; ;                   \bar\max = Value 
              ; ;                 EndIf
              ; ;                 ; 14 ноябрь 2019г исправленно
              ; ;                 If \bar\max < Value
              ; ;                   \bar\max = Value 
              ; ;                 EndIf
              ;                  \bar\page\len = (\bar\max-\bar\min)
              ;               Else
              ;                 \bar\page\len = Value
              ;               EndIf
              
              Result = #True
            EndIf
            
          Case #__bar_ScrollStep 
            \bar\scrollstep = Value
            
          Case #__bar_buttonSize
            If \bar\button[#__b_3]\len <> Value
              \bar\button[#__b_3]\len = Value
              
              If \type = #PB_GadgetType_ScrollBar
                \bar\button[#__b_1]\len = Value
                \bar\button[#__b_2]\len = Value
              EndIf
              Result = #True
            EndIf
            
          Case #__bar_inverted
            If \bar\inverted <> Bool(Value)
              \bar\inverted = Bool(Value)
              ; \bar\thumb\pos = _bar_pos_(*this, _bar_invert_(*this, \bar\page\pos, \bar\inverted))
              ;  \bar\thumb\pos = _bar_pos_(*this, \bar\page\pos)
              ;  Result = 1
            EndIf
            
        EndSelect
      EndIf
      
      If Result ; And \width And \height ; есть проблемы с imagegadget и scrollareagadget
        \hide = Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bar_update(*this)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l _SetAttribute(*this._struct_, Attribute.l, Value.l)
    Protected Result.l
    
    With *this
      If \splitter
        Select Attribute
          Case #PB_Splitter_FirstMinimumSize
            \bar\button[#__b_1]\len = Value
            Result = Bool(\bar\max)
            
          Case #PB_Splitter_SecondMinimumSize
            \bar\button[#__b_2]\len = Value
            Result = Bool(\bar\max)
            
            
        EndSelect
      Else
        Select Attribute
          Case #__bar_minimum
            If \bar\min <> Value
              \bar\min = Value
              \bar\page\pos = Value
              Result = #True
            EndIf
            
          Case #__bar_maximum
            If \bar\max <> Value
              If \bar\min > Value
                \bar\max = \bar\min + 1
              Else
                \bar\max = Value
              EndIf
              
              If \bar\max = 0
                \bar\page\pos = 0
              EndIf
              
              Result = #True
            EndIf
            
          Case #__bar_pageLength
            If \bar\page\len <> Value
              \bar\page\len = Value
              
              If Not \bar\max
                If \bar\min > Value
                  \bar\max = \bar\min + 1
                Else
                  \bar\max = Value
                EndIf
              EndIf
              
              ;               If Value > (\bar\max-\bar\min) 
              ;                 ;\bar\max = Value ; ???? ????? page_length ??????? ?????? maximum ?? ?? ????????? ????????
              ; ;                 If \bar\max = 0 
              ; ;                   \bar\max = Value 
              ; ;                 EndIf
              ; ;                 ; 14 ?????? 2019? ???????????
              ; ;                 If \bar\max < Value
              ; ;                   \bar\max = Value 
              ; ;                 EndIf
              ;                  \bar\page\len = (\bar\max-\bar\min)
              ;               Else
              ;                 \bar\page\len = Value
              ;               EndIf
              
              Result = #True
            EndIf
            
          Case #__bar_scrollstep 
            \bar\scrollstep = Value
            
          Case #__bar_buttonsize
            If \bar\button[#__b_3]\len <> Value
              \bar\button[#__b_3]\len = Value
              
              If \type = #PB_GadgetType_ScrollBar
                \bar\button[#__b_1]\len = Value
                \bar\button[#__b_2]\len = Value
              EndIf
              Result = #True
            EndIf
            
          Case #__bar_inverted
            If \bar\inverted <> Bool(Value)
              \bar\inverted = Bool(Value)
              \bar\thumb\pos = _pos_(*this, _invert_(*this\bar, \bar\page\pos, \bar\inverted))
              ;  \bar\thumb\pos = _pos_(*this, \bar\page\pos)
              ;  Result = 1
            EndIf
            
        EndSelect
      EndIf
      
      If Result ; And \width And \height ; ???? ???????? ? imagegadget ? scrollareagadget
        \hide = update(*this)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b resize(*this._struct_, X.l,Y.l,Width.l,Height.l)
    With *this
      If X <> #PB_Ignore : \x = X : EndIf 
      If Y <> #PB_Ignore : \y = Y : EndIf 
      If Width <> #PB_Ignore : \width = Width : EndIf 
      If Height <> #PB_Ignore : \height = height : EndIf
      
      ProcedureReturn update(*this)
    EndWith
  EndProcedure
  
  Procedure.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l )
    ;     If Not (*scroll\v And *scroll\h)
    ;       ProcedureReturn
    ;     EndIf
    
    With *scroll
      Protected iHeight, iWidth
      
      If y=#PB_Ignore : y = \v\y : EndIf
      If x=#PB_Ignore : x = \h\x : EndIf
      If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\bar\page\len<>iHeight : SetAttribute(\v, #__Bar_PageLength, iHeight) : EndIf
      If \h\height And \h\bar\page\len<>iWidth : SetAttribute(\h, #__Bar_PageLength, iWidth) : EndIf
      
      \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\bar\page\len)
      \h\hide = Resize(\h, x, Height+y-\h\height, \h\bar\page\len, #PB_Ignore)
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\bar\page\len<>iHeight : SetAttribute(\v, #__Bar_PageLength, iHeight) : EndIf
      If \h\bar\page\len<>iWidth : SetAttribute(\h, #__Bar_PageLength, iWidth) : EndIf
      
      If \v\bar\page\len <> \v\height : \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\bar\page\len) : EndIf
      If \h\bar\page\len <> \h\width : \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\bar\page\len, #PB_Ignore) : EndIf
      
      If Not \v\hide And \v\width 
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x) + Bool(\v\round And \h\round)*(\v\width/4), #PB_Ignore)
      EndIf
      If Not \h\hide And \h\height
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y) + Bool(\v\round And \h\round)*(\h\height/4))
      EndIf
      
      ProcedureReturn #True
    EndWith
  EndProcedure
  
  Procedure.b _Resizes(*scroll._s_scroll, X.l,Y.l,Width.l,Height.l )
    With *scroll
      Protected iHeight, iWidth
      
      If Not *scroll\v Or Not *scroll\h
        ProcedureReturn
      EndIf
      
      If y=#PB_Ignore : y = \v\y : EndIf
      If x=#PB_Ignore : x = \h\x : EndIf
      If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\bar\page\len<>iHeight : SetAttribute(\v, #__bar_pageLength, iHeight) : EndIf
      If \h\bar\page\len<>iWidth : SetAttribute(\h, #__bar_pageLength, iWidth) : EndIf
      
      \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\bar\page\len)
      \h\hide = Resize(\h, x, Height+y-\h\height, \h\bar\page\len, #PB_Ignore)
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\bar\page\len<>iHeight : SetAttribute(\v, #__bar_pageLength, iHeight) : EndIf
      If \h\bar\page\len<>iWidth : SetAttribute(\h, #__bar_pageLength, iWidth) : EndIf
      
      If \v\bar\page\len <> \v\height : \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\bar\page\len) : EndIf
      If \h\bar\page\len <> \h\width : \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\bar\page\len, #PB_Ignore) : EndIf
      
      If Not \v\hide And \v\width 
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x) + Bool(\v\round And \h\round)*(\v\width/4), #PB_Ignore)
      EndIf
      If Not \h\hide And \h\height
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y) + Bool(\v\round And \h\round)*(\h\height/4))
      EndIf
      
      ProcedureReturn #True
    EndWith
  EndProcedure
  
  ;-
  Procedure.b Post(eventtype.l, *this._s_widget, item.l=#PB_All, *data=0)
    If *this\event And 
       (*this\event\type = #PB_All Or 
        *this\event\type = eventtype)
      
      *event\widget = *this
      *event\type = eventtype
      *event\data = *data
      *event\item = item
      
      ;If *this\event\callback
      *this\event\callback()
      ;EndIf
    EndIf
  EndProcedure
  
  Procedure.b Bind(*callBack, *this._s_widget, eventtype.l=#PB_All)
    *this\event = AllocateStructure(_s_event_)
    *this\event\type = eventtype
    *this\event\callback = *callBack
  EndProcedure
  
  Procedure.b events(*this._s_widget, EventType.l, mouse_x.l, mouse_y.l, Wheel_X.b=0, Wheel_Y.b=0)
    Protected Result, from =- 1 
    Static cursor_change, LastX, LastY, Last, *leave._s_widget, Down
    
    Macro _callback_(_this_, _type_)
      Select _type_
        Case #PB_EventType_MouseLeave ; : Debug ""+#PB_Compiler_Line +" Мышь находится снаружи итема " + _this_ +" "+ _this_\from
          _this_\bar\button[_this_\from]\color\state = #__s_0 
          
          If _this_\cursor And cursor_change
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default) ; cursor_change - 1)
            cursor_change = 0
          EndIf
          
        Case #PB_EventType_MouseEnter ; : Debug ""+#PB_Compiler_Line +" Мышь находится внутри итема " + _this_ +" "+ _this_\from
          _this_\bar\button[_this_\from]\color\state = #__s_1 
          
          ; Set splitter cursor
          If _this_\from = #__b_3 And _this_\type = #PB_GadgetType_Splitter And _this_\cursor
            cursor_change = 1;GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor) + 1
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, _this_\cursor)
          EndIf
          
        Case #PB_EventType_LeftButtonUp ; : Debug ""+#PB_Compiler_Line +" отпустили " + _this_ +" "+ _this_\from
          _this_\bar\button[_this_\from]\color\state = #__s_1 
          
      EndSelect
    EndMacro
    
    With *this
      ; from the very beginning we'll process 
      ; the splitter children’s widget
      If \splitter And \from <> #__b_3
        If \splitter\first And Not \splitter\g_first
          If events(\splitter\first, EventType, mouse_x, mouse_y)
            ProcedureReturn 1
          EndIf
        EndIf
        If \splitter\second And Not \splitter\g_second
          If events(\splitter\second, EventType, mouse_x, mouse_y)
            ProcedureReturn 1
          EndIf
        EndIf
      EndIf
      
      ; get at point buttons
      If Not \hide And (_from_point_(mouse_x, mouse_y, *this) Or Down)
        If \bar\button 
          If \bar\button[#__b_3]\len And _from_point_(mouse_x, mouse_y, \bar\button[#__b_3])
            from = #__b_3
          ElseIf \bar\button[#__b_2]\len And _from_point_(mouse_x, mouse_y, \bar\button[#__b_2])
            from = #__b_2
          ElseIf \bar\button[#__b_1]\len And _from_point_(mouse_x, mouse_y, \bar\button[#__b_1])
            from = #__b_1
          ElseIf _from_point_(mouse_x, mouse_y, \bar\button[0])
            from = 0
          EndIf
          
          If \type = #PB_GadgetType_TrackBar ;Or \type = #PB_GadgetType_ProgressBar
            Select from
              Case #__b_1, #__b_2
                from = 0
                
            EndSelect
            ; ElseIf \type = #PB_GadgetType_ProgressBar
            ;  
          EndIf
        Else
          from =- 1; 0
        EndIf 
        
        If \from <> from And Not Down
          If *leave > 0 And *leave\from >= 0 And *leave\bar\button[*leave\from]\interact And 
             Not _from_point_(mouse_x, mouse_y, *leave\bar\button[*leave\from])
            
            _callback_(*leave, #PB_EventType_MouseLeave)
            *leave\from =- 1; 0
            
            Result = #True
          EndIf
          
          ; If from > 0
          \from = from
          *leave = *this
          ; EndIf
          
          If \from >= 0 And \bar\button[\from]\interact
            _callback_(*this, #PB_EventType_MouseEnter)
            
            Result = #True
          EndIf
        EndIf
        
      Else
        If \from >= 0 And \bar\button[\from]\interact
          If EventType = #PB_EventType_LeftButtonUp
            ; Debug ""+#PB_Compiler_Line +" Мышь up"
            _callback_(*this, #PB_EventType_LeftButtonUp)
          EndIf
          
          ; Debug ""+#PB_Compiler_Line +" Мышь покинул итем"
          _callback_(*this, #PB_EventType_MouseLeave)
          
          Result = #True
        EndIf 
        
        \from =- 1
        
        If *leave = *this
          *leave = 0
        EndIf
      EndIf
      
      ; get
      Select EventType
        Case #PB_EventType_MouseWheel
          If *This = *event\active
            If \bar\vertical
              Result = SetState(*This, (\bar\page\pos + Wheel_Y))
            Else
              Result = SetState(*This, (\bar\page\pos + Wheel_X))
            EndIf
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If Not Down : \from =- 1 : from =- 1 : LastX = 0 : LastY = 0 : EndIf
          
        Case #PB_EventType_LeftButtonUp : Down = 0 : LastX = 0 : LastY = 0
          
          If \from >= 0 And \bar\button[\from]\interact
            _callback_(*this, #PB_EventType_LeftButtonUp)
            
            If from =- 1
              _callback_(*this, #PB_EventType_MouseLeave)
              \from =- 1
            EndIf
            
            Result = #True
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          Macro _set_active_(_this_)
            If *event\active <> _this_
              If *event\active 
                ;                 If *event\active\row\selected 
                ;                   *event\active\row\selected\color\state = 3
                ;                 EndIf
                
                *event\active\color\state = 0
              EndIf
              
              ;               If _this_\row\selected And _this_\row\selected\color\state = 3
              ;                 _this_\row\selected\color\state = 2
              ;               EndIf
              
              _this_\color\state = 2
              *event\active = _this_
              Result = #True
            EndIf
          EndMacro
          
          If *leave = *this
            _set_active_(*this)
          EndIf
          
          If from = 0 And \bar\button[#__b_3]\interact 
            If \bar\vertical
              Result = SetPos(*this, (mouse_y-\bar\thumb\len/2))
            Else
              Result = SetPos(*this, (mouse_x-\bar\thumb\len/2))
            EndIf
            
            from = 3
          EndIf
          
          If from >= 0 And *this = *leave
            Down = *this
            \from = from 
            Debug *this
            
            If \bar\button[from]\interact
              \bar\button[\from]\color\state = #__s_2
              
              Select \from
                Case #__b_1 
                  If \bar\inverted
                    Result = SetState(*this, _invert_(*this\bar, (\bar\page\pos + \bar\scrollstep), Bool(\type <> #PB_GadgetType_Spin And \bar\inverted)))
                  Else
                    Result = SetState(*this, _invert_(*this\bar, (\bar\page\pos - \bar\scrollstep), \bar\inverted))
                  EndIf
                  
                Case #__b_2 
                  If \bar\inverted
                    Result = SetState(*this, _invert_(*this\bar, (\bar\page\pos - \bar\scrollstep), Bool(\type <> #PB_GadgetType_Spin And \bar\inverted)))
                  Else
                    Result = SetState(*this, _invert_(*this\bar, (\bar\page\pos + \bar\scrollstep), \bar\inverted))
                  EndIf
                  
                Case #__b_3 
                  LastX = mouse_x - \bar\thumb\pos 
                  LastY = mouse_y - \bar\thumb\pos
                  Result = #True
                  
              EndSelect
              
            Else
              Result = #True
            EndIf
          EndIf
          
        Case #PB_EventType_MouseMove
          If Down And *leave = *this And Bool(LastX|LastY) 
            If \bar\vertical
              Result = SetPos(*this, (mouse_y-LastY))
            Else
              Result = SetPos(*this, (mouse_x-LastX))
            EndIf
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  
  Macro _set_last_parameters_(_this_, _type_, _flag_, _parent_)
    ;     *event\widget = _this_
    ;     _this_\type = _type_
    ;     _this_\class = #PB_Compiler_Procedure
    ;     
    ;     ; Set parent
    ;     SetParent(_this_, _parent_, _parent_\tab\opened)
    ;     
    _this_\parent = _this_
    
    ;     ; _set_auto_size_
    ;     If Bool(_flag_ & #__flag_autoSize=#__flag_autoSize) : x=0 : y=0
    ;       _this_\align = AllocateStructure(_s_align)
    ;       _this_\align\autoSize = 1
    ;       _this_\align\left = 1
    ;       _this_\align\top = 1
    ;       _this_\align\right = 1
    ;       _this_\align\bottom = 1
    ;     EndIf
    ;     
    ;     If Bool(_flag_ & #__flag_anchorsGadget=#__flag_anchorsGadget)
    ;       
    ;       a_add(_this_)
    ;       a_Set(_this_)
    ;       
    ;     EndIf
    ;     
  EndMacro
  
  Procedure.b Draw_Scroll(*this._struct_)
    With *this
      
      If Not \hide And \color\alpha
        If \color\back <> - 1
          ; Draw scroll bar background
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox(\X,\Y,\width,\height,\round,\round,\Color\Back&$FFFFFF|\color\alpha<<24)
        EndIf
        
        If \type = #PB_GadgetType_ScrollBar
          If \bar\vertical
            If (\bar\page\len+Bool(\round)*(\width/4)) = \height
              Line( \x, \y, 1, \bar\page\len+1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
            Else
              Line( \x, \y, 1, \height, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
            EndIf
          Else
            If (\bar\page\len+Bool(\round)*(\height/4)) = \width
              Line( \x, \y, \bar\page\len+1, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
            Else
              Line( \x, \y, \width, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
            EndIf
          EndIf
        EndIf
        
        If (\bar\vertical And \bar\button[#__b_1]\height) Or (Not \bar\vertical And \bar\button[#__b_1]\width) ;\bar\button[#__b_1]\len
                                                                                                               ; Draw buttons
          If \bar\button[#__b_1]\color\fore <> - 1
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            _box_gradient_(\bar\vertical,\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,
                           \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], \bar\button[#__b_1]\round, \bar\button[#__b_1]\color\alpha)
          Else
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
          EndIf
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
          
          ; Draw arrows
          If \bar\button[#__b_1]\arrow\size
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Arrow(\bar\button[#__b_1]\x+(\bar\button[#__b_1]\width-\bar\button[#__b_1]\arrow\size)/2,\bar\button[#__b_1]\y+(\bar\button[#__b_1]\height-\bar\button[#__b_1]\arrow\size)/2, 
                  \bar\button[#__b_1]\arrow\size, Bool(\bar\vertical), \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24, \bar\button[#__b_1]\arrow\type)
          EndIf
        EndIf
        
        If (\bar\vertical And \bar\button[#__b_2]\height) Or (Not \bar\vertical And \bar\button[#__b_2]\width)
          ; Draw buttons
          If \bar\button[#__b_2]\color\fore <> - 1
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            _box_gradient_(\bar\vertical,\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,
                           \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], \bar\button[#__b_2]\round, \bar\button[#__b_2]\color\alpha)
          Else
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
          EndIf
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
          
          ; Draw arrows
          If \bar\button[#__b_2]\arrow\size
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Arrow(\bar\button[#__b_2]\x+(\bar\button[#__b_2]\width-\bar\button[#__b_2]\arrow\size)/2,\bar\button[#__b_2]\y+(\bar\button[#__b_2]\height-\bar\button[#__b_2]\arrow\size)/2, 
                  \bar\button[#__b_2]\arrow\size, Bool(\bar\vertical)+2, \bar\button[#__b_2]\color\front[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24, \bar\button[#__b_2]\arrow\type)
          EndIf
        EndIf
        
        If \bar\thumb\len And \type <> #PB_GadgetType_ProgressBar
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\bar\vertical,\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height,
                         \bar\button[#__b_3]\color\fore[\bar\button[#__b_3]\color\state],\bar\button[#__b_3]\color\Back[\bar\button[#__b_3]\color\state], \bar\button[#__b_3]\round, \bar\button[#__b_3]\color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height,\bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\frame[\bar\button[#__b_3]\color\state]&$FFFFFF|\bar\button[#__b_3]\color\alpha<<24)
          
          If \bar\button[#__b_3]\arrow\type ; \type = #PB_GadgetType_ScrollBar
            If \bar\button[#__b_3]\arrow\size
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Arrow(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2, 
                    \bar\button[#__b_3]\arrow\size, \bar\button[#__b_3]\arrow\direction, \bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\bar\button[#__b_3]\color\alpha<<24, \bar\button[#__b_3]\arrow\type)
            EndIf
          Else
            ; Draw thumb lines
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            If \bar\vertical
              Line(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2-3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              Line(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              Line(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2+3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
            Else
              Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2-3,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2+3,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
            EndIf
            
          EndIf
        EndIf
        
        If \type = #PB_GadgetType_TrackBar And \bar\thumb\len
          Protected i, _thumb_ = (\bar\button[3]\len/2)
          DrawingMode(#PB_2DDrawing_XOr)
          
          ;\mode = #__bar_ticks
          
          If \bar\vertical
            If \bar\mode = #__bar_ticks
              For i=0 To \bar\page\end-\bar\min
                Line(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3+4)-2, 
                     (\bar\area\pos + _thumb_ + Round(i * \bar\increment, #PB_Round_Nearest)),3, 1,\bar\button[#__b_1]\color\frame)
              Next
            EndIf
            
            Line(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3-2)+1,\bar\area\pos + _thumb_,3, 1,\bar\button[#__b_3]\color\Frame)
            Line(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3-2)+1,\bar\area\pos + \bar\area\len + _thumb_,3, 1,\bar\button[#__b_3]\color\Frame)
            
          Else
            If \bar\mode = #__bar_ticks
              For i=0 To \bar\page\end-\bar\min
                Line((\bar\area\pos + _thumb_ + Round(i * \bar\increment, #PB_Round_Nearest)), 
                     \bar\button[3]\y+Bool(Not \bar\inverted)*(\bar\button[3]\height-3+4)-2,1,3,\bar\button[#__b_3]\color\Frame)
              Next
            EndIf
            
            Line(\bar\area\pos + _thumb_, \bar\button[3]\y+Bool(Not \bar\inverted)*(\bar\button[3]\height-3-2)+1,1,3,\bar\button[#__b_3]\color\Frame)
            Line(\bar\area\pos + \bar\area\len + _thumb_, \bar\button[3]\y+Bool(Not \bar\inverted)*(\bar\button[3]\height-3-2)+1,1,3,\bar\button[#__b_3]\color\Frame)
          EndIf
          
          ;           If \bar\button[#__b_3]\len
          ;             If \bar\vertical
          ;               DrawingMode(#PB_2DDrawing_Default)
          ;               Box(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\height,\bar\button[#__b_3]\color\back[_state_3_])
          ;               
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,1,\bar\button[#__b_3]\height,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width/2,1,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height-1,\bar\button[#__b_3]\width/2,1,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\height/2+1,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height-1,\bar\button[#__b_3]\width/2,-\bar\button[#__b_3]\height/2-1,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               
          ;             Else
          ;               DrawingMode(#PB_2DDrawing_Default)
          ;               Box(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\color\back[_state_3_])
          ;               
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,1,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,1,\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width-1,\bar\button[#__b_3]\y,1,\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\width/2+1,\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width-1,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2,-\bar\button[#__b_3]\width/2-1,\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\color\frame[_state_3_])
          ;             EndIf
          ;           EndIf
          
        EndIf
        
        If \type = #PB_GadgetType_ProgressBar 
          
          ;           DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_alphaBlend)
          ;           RoundBox(\bar\thumb\pos-1-\bar\button[#__b_2]\round,\bar\button[#__b_1]\y,1+\bar\button[#__b_2]\round,\bar\button[#__b_1]\height,
          ;                    \bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
          ;           RoundBox(\bar\thumb\pos+\bar\button[#__b_2]\round,\bar\button[#__b_1]\y,1+\bar\button[#__b_2]\round,\bar\button[#__b_1]\height,
          ;                    \bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\back[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
          
          If \bar\button[#__b_1]\round
            If \bar\vertical
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Line(\bar\button[#__b_1]\x, \bar\thumb\pos-\bar\button[#__b_1]\round, 1,\bar\button[#__b_1]\round, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              Line(\bar\button[#__b_1]\x+\bar\button[#__b_1]\width-1, \bar\thumb\pos-\bar\button[#__b_1]\round, 1,\bar\button[#__b_1]\round, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              
              Line(\bar\button[#__b_2]\x, \bar\thumb\pos, 1,\bar\button[#__b_2]\round, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
              Line(\bar\button[#__b_2]\x+\bar\button[#__b_2]\width-1, \bar\thumb\pos, 1,\bar\button[#__b_2]\round, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Line(\bar\thumb\pos-\bar\button[#__b_1]\round,\bar\button[#__b_1]\y, \bar\button[#__b_1]\round, 1, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              Line(\bar\thumb\pos-\bar\button[#__b_1]\round,\bar\button[#__b_1]\y+\bar\button[#__b_1]\height-1, \bar\button[#__b_1]\round, 1, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              
              Line(\bar\thumb\pos,\bar\button[#__b_2]\y, \bar\button[#__b_2]\round, 1, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
              Line(\bar\thumb\pos,\bar\button[#__b_2]\y+\bar\button[#__b_2]\height-1, \bar\button[#__b_2]\round, 1, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
            EndIf
          EndIf
          
          If \bar\page\pos > \bar\min
            If \bar\vertical
              If \bar\button[#__b_1]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\button[#__b_1]\x+1,\bar\thumb\pos-1-\bar\button[#__b_2]\round,\bar\button[#__b_1]\width-2,1+\bar\button[#__b_2]\round,
                               \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], 0, \bar\button[#__b_1]\color\alpha)
                
              EndIf
              
              ; Draw buttons
              If \bar\button[#__b_2]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\button[#__b_2]\x+1,\bar\thumb\pos,\bar\button[#__b_2]\width-2,1+\bar\button[#__b_2]\round,
                               \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], 0, \bar\button[#__b_2]\color\alpha)
              EndIf
            Else
              If \bar\button[#__b_1]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\thumb\pos-1-\bar\button[#__b_2]\round,\bar\button[#__b_1]\y+1,1+\bar\button[#__b_2]\round,\bar\button[#__b_1]\height-2,
                               \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], 0, \bar\button[#__b_1]\color\alpha)
                
              EndIf
              
              ; Draw buttons
              If \bar\button[#__b_2]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\thumb\pos,\bar\button[#__b_2]\y+1,1+\bar\button[#__b_2]\round,\bar\button[#__b_2]\height-2,
                               \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], 0, \bar\button[#__b_2]\color\alpha)
              EndIf
            EndIf
          EndIf
          
        EndIf
        
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.b Draw_progress(*this._struct_)
    *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
    *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
    
    Draw_Scroll(*this)
    
    ; Draw string
    If *this\text And *this\text\string
      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
      DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\bar\button[#__b_3]\color\frame[*this\bar\button[#__b_3]\color\state])
    EndIf
  EndProcedure
  
  Procedure.b Draw_track(*this._struct_)
    *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
    *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
    *this\bar\button[#__b_3]\color\state = 2
    
    Draw_Scroll(*this)
  EndProcedure
  
  Procedure.i Draw_Spin(*this._struct_) 
    Draw_Scroll(*this)
    
    ; Draw string
    If *this\text And *this\text\string
      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
      DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\color\front[*this\color\state])
    EndIf
  EndProcedure
  
  Procedure.b Draw_Splitter(*this._struct_)
    Protected Pos, Size, round.d = 2
    
    With *this
      If *this > 0
        DrawingMode(#PB_2DDrawing_Outlined)
        If \bar\mode
          Protected *first._struct_ = \splitter\first
          Protected *second._struct_ = \splitter\second
          
          If Not \splitter\g_first And (Not *first Or (*first And Not *first\splitter))
            Box(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button\color\frame[\bar\button[#__b_1]\Color\state])
          EndIf
          If Not \splitter\g_second And (Not *second Or (*second And Not *second\splitter))
            Box(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button\color\frame[\bar\button[#__b_2]\Color\state])
          EndIf
        EndIf
        
        If \bar\mode = #PB_Splitter_Separator
          ; ??????? ????????? 
          Size = \bar\thumb\len/2
          Pos = \bar\thumb\Pos+Size
          
          If \bar\vertical ; horisontal
            Circle(\bar\button\X+((\bar\button\Width-round)/2-((round*2+2)*2+2)), Pos,round,\bar\button\Color\Frame[#__s_2])
            Circle(\bar\button\X+((\bar\button\Width-round)/2-(round*2+2)),       Pos,round,\bar\button\Color\Frame[#__s_2])
            Circle(\bar\button\X+((\bar\button\Width-round)/2),                    Pos,round,\bar\button\Color\Frame[#__s_2])
            Circle(\bar\button\X+((\bar\button\Width-round)/2+(round*2+2)),       Pos,round,\bar\button\Color\Frame[#__s_2])
            Circle(\bar\button\X+((\bar\button\Width-round)/2+((round*2+2)*2+2)), Pos,round,\bar\button\Color\Frame[#__s_2])
          Else
            Circle(Pos,\bar\button\Y+((\bar\button\Height-round)/2-((round*2+2)*2+2)),round,\bar\button\Color\Frame[#__s_2])
            Circle(Pos,\bar\button\Y+((\bar\button\Height-round)/2-(round*2+2)),      round,\bar\button\Color\Frame[#__s_2])
            Circle(Pos,\bar\button\Y+((\bar\button\Height-round)/2),                   round,\bar\button\Color\Frame[#__s_2])
            Circle(Pos,\bar\button\Y+((\bar\button\Height-round)/2+(round*2+2)),      round,\bar\button\Color\Frame[#__s_2])
            Circle(Pos,\bar\button\Y+((\bar\button\Height-round)/2+((round*2+2)*2+2)),round,\bar\button\Color\Frame[#__s_2])
          EndIf
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.b draw(*this._struct_)
    With *this
      If \text 
        If \text\fontID 
          DrawingFont(\text\fontID)
        EndIf
        
        If \text\change
          
          If \type = #PB_GadgetType_Spin
            Protected i
            
            ;*this\bar\scrollstep = 1.19
            For i=0 To 3
              If *this\bar\scrollstep = ValF(StrF(*this\bar\scrollstep, i))
                *this\text\string = StrF(*this\bar\page\Pos, i)
                Break
              EndIf
            Next
          EndIf
          
          *this\text\height = TextHeight("A")
          *this\text\width = TextWidth(*this\text\string)
          
          _text_change_(*this, *this\x, *this\y, *this\width, *this\height)
        EndIf
      EndIf
      
      Select \type
        Case #PB_GadgetType_Spin        : Draw_Spin(*this)
        Case #PB_GadgetType_TrackBar    : Draw_Track(*this)
        Case #PB_GadgetType_ScrollBar   : Draw_Scroll(*this)
        Case #PB_GadgetType_Splitter    : Draw_Splitter(*this)
        Case #PB_GadgetType_ProgressBar : Draw_Progress(*this)
      EndSelect
      
      If \text\change
        \text\change = 0
      EndIf
      
    EndWith
  EndProcedure
  
  
  ;-
  Procedure.i Bar(type.l, size.l, min.l, max.l, pagelength.l, flag.i=0, round.l=7, parent.i=0, scrollstep.f=1.0)
    Protected *this._struct_ = AllocateStructure(_struct_)
    
    With *this
      *event\widget = *this
      \x =- 1
      \y =- 1
      
      ;\hide = Bool(Not pagelength)  ; add
      
      \type = Type
      
      \parent = parent
      If \parent
        \root = \parent\root
        \window = \parent\window
      EndIf
      
      \round = round
      \bar\mode = Bool(Flag&#__bar_ticks=#__bar_ticks)*#__bar_ticks
      \bar\scrollstep = scrollstep
      
      ; ???? ???? ???????
      \color\alpha = 255
      \color\alpha[1] = 0
      \color\state = 0
      \color\back = $FFF9F9F9
      \color\frame = \color\back
      \color\line = $FFFFFFFF
      \color\front = $FFFFFFFF
      
      \bar\button[#__b_1]\color = *event\colors
      \bar\button[#__b_2]\color = *event\colors
      \bar\button[#__b_3]\color = *event\colors
      
      If Not Bool(Flag&#__bar_nobuttons)
        If \bar\vertical
          \width = Size
        Else
          \height = Size
        EndIf
        
        If Size < 21
          Size - 1
        Else
          size = 17
        EndIf
      EndIf
      
      ; min thumb size
      \bar\button[#__b_3]\len = size
      
      If Type = #PB_GadgetType_ScrollBar
        \bar\vertical = Bool(Flag & #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical)
        \bar\inverted = Bool(Flag & #__bar_inverted = #__bar_inverted)
      
        \bar\button[#__b_1]\interact = #True
        \bar\button[#__b_2]\interact = #True
        \bar\button[#__b_3]\interact = #True
        
        \bar\button[#__b_1]\len = size
        \bar\button[#__b_2]\len = size
        
        \bar\button[#__b_1]\arrow\size = 4
        \bar\button[#__b_2]\arrow\size = 4
        \bar\button[#__b_3]\arrow\size = 3
        
        \bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
        \bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
        
        \bar\button[#__b_1]\round = \round
        \bar\button[#__b_2]\round = \round
        \bar\button[#__b_3]\round = \round
      EndIf
      
      If Type = #PB_GadgetType_ProgressBar
        \bar\vertical = Bool(Flag & #PB_ProgressBar_Vertical = #PB_ProgressBar_Vertical)
        \bar\inverted = \bar\vertical
        
        ; \text = AllocateStructure(_s_text)
        \text\change = 1
        
        \text\align\vertical = 1
        \text\align\horizontal = 1
        \text\rotate = \bar\vertical * 90 ; 270
        
        \bar\button[#__b_1]\interact = #False
        \bar\button[#__b_2]\interact = #False
        
        \bar\button[#__b_1]\round = \round
        \bar\button[#__b_2]\round = \round
      EndIf
      
      If Type = #PB_GadgetType_TrackBar
        \bar\vertical = Bool(Flag & #PB_TrackBar_Vertical = #PB_TrackBar_Vertical)
        \bar\inverted = \bar\vertical
        
        \bar\button[#__b_1]\interact = #False
        \bar\button[#__b_2]\interact = #False
        \bar\button[#__b_3]\interact = #True
        
        
    
        \bar\button[#__b_1]\len = 1
        \bar\button[#__b_2]\len = 1
        
        \bar\button[#__b_3]\arrow\size = 4
        \bar\button[#__b_3]\arrow\type = #__arrow_type
        
        \bar\button[#__b_1]\round = 2
        \bar\button[#__b_2]\round = 2
        \bar\button[#__b_3]\round = \round
        
        If \round < 7
          \bar\button[#__b_3]\len = 9
        EndIf
        
        \bar\mode = Bool(flag & #__bar_ticks) * #__bar_ticks
      EndIf
      
      If Type = #PB_GadgetType_Spin
        \bar\vertical = Bool(Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical)
        \bar\inverted = \bar\vertical
        
        ; \text = AllocateStructure(_s_text)
        \text\change = 1
        \text\editable = 1
        \text\align\Vertical = 1
        \text\padding = #__spin_padding_text
        
        ; ???? ???? ???????
        \color = *event\colors
        \color\alpha = 255
        \color\back = $FFFFFFFF
        
        \bar\button\len = #__spin_buttonsize
        
        \bar\button[#__b_3]\len = 0
        \bar\button[#__b_1]\len = Size
        \bar\button[#__b_2]\len = Size
        
        \bar\button[#__b_1]\arrow\size = 4
        \bar\button[#__b_2]\arrow\size = 4
        
        \bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
        \bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
      EndIf
      
      If Type = #PB_GadgetType_Splitter
        \container = #PB_GadgetType_Splitter
        \bar\vertical = Bool(Not Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical)
        
        \bar\button[#__b_1]\interact = #False
        \bar\button[#__b_2]\interact = #False
        \bar\button[#__b_3]\interact = #True
        
        \bar\button\len = 7
        \bar\thumb\len = 7
        \bar\mode = #PB_Splitter_Separator
        
      EndIf
      
      If \bar\min <> Min : SetAttribute(*this, #__bar_minimum, Min) : EndIf
      If \bar\max <> Max : SetAttribute(*this, #__bar_maximum, Max) : EndIf
      If \bar\page\len <> Pagelength : SetAttribute(*this, #__bar_pageLength, Pagelength) : EndIf
      If \bar\inverted : SetAttribute(*this, #__bar_inverted, #True) : EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Track(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=7)
    Protected *this._struct_ = Bar(#PB_GadgetType_TrackBar, 15, Min, Max, 0, Flag|#__bar_nobuttons, round)
    _set_last_parameters_(*this, *this\type, Flag, Root()\opened)
    Resize(*this, X,Y,Width,Height)
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Progress(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0)
    Protected *this._struct_ = Bar(#PB_GadgetType_ProgressBar, 0, Min, Max, 0, Flag|#__bar_nobuttons, round)
    _set_last_parameters_(*this, *this\type, Flag, Root()\opened) 
    Resize(*this, X,Y,Width,Height)
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Spin(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0, Increment.f=1.0)
    Protected *this._struct_
    If Flag&#__bar_vertical
      Flag&~#__bar_vertical
      ;Flag|#__bar_inverted
    Else
      Flag|#__bar_vertical
      Flag|#__bar_inverted
    EndIf
    
    If Flag&#__bar_reverse
      Flag|#__bar_inverted
    EndIf
    
    *this = Bar(#PB_GadgetType_Spin, 16, Min, Max, 0, Flag, round, 0, Increment)
    _set_last_parameters_(*this, *this\type, Flag, Root()\opened) 
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
    Protected *this._struct_
    
    If Bool(Flag&#__bar_vertical)
      *this = Bar(#PB_GadgetType_ScrollBar, width, Min, Max, PageLength, Flag, round)
    Else
      *this = Bar(#PB_GadgetType_ScrollBar, height, Min, Max, PageLength, Flag, round)
    EndIf
    
    _set_last_parameters_(*this, *this\type, Flag, Root()\opened) 
    Resize(*this, X,Y,Width,Height)
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.i=0)
    Protected *this._s_widget 
    
    If Bool(Not Flag&#PB_Splitter_Vertical)
      *this = Bar(#PB_GadgetType_Splitter, 7, 0, Height, 0, Flag|#__bar_nobuttons, 0)
    Else
      *this = Bar(#PB_GadgetType_Splitter, 7, 0, Width, 0, Flag|#__bar_nobuttons, 0)
    EndIf
    
    _set_last_parameters_(*this, *this\type, Flag, Root()\opened) 
    
    With *this
      *this\index[#__s_1] =- 1
      *this\index[#__s_2] = 0
      
      \splitter = AllocateStructure(_s_splitter)
      \splitter\first = First
      \splitter\second = Second
      
      If Flag&#PB_Splitter_SecondFixed
        \splitter\fixed = 2
      EndIf
      If Flag&#PB_Splitter_FirstFixed
        \splitter\fixed = 1
      EndIf
      
      Resize(*this, X,Y,Width,Height)
      
      If \bar\vertical
        \cursor = #PB_Cursor_UpDown
        SetState(*this, \height/2-1)
      Else
        \cursor = #PB_Cursor_LeftRight
        SetState(*this, \width/2-1)
      EndIf
      
      \splitter\first\parent = *this
      \splitter\second\parent = *this
      ;       SetParent(\splitter\first, *this)
      ;       SetParent(\splitter\second, *this)
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  
EndModule

;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Bar
  UseModule Constants
  UseModule Structures
  
  Global g_Canvas, NewList *List._s_widget()
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Procedure GetCurrentEvent()
      Protected app = CocoaMessage(0,0,"NSApplication sharedApplication")
      If app
        ProcedureReturn CocoaMessage(0,app,"currentEvent")
      EndIf
    EndProcedure
    
    Procedure.CGFloat GetWheelDeltaX()
      Protected wheelDeltaX.CGFloat = 0.0
      Protected currentEvent = GetCurrentEvent()
      If currentEvent
        CocoaMessage(@wheelDeltaX,currentEvent,"scrollingDeltaX")
      EndIf
      ProcedureReturn wheelDeltaX
    EndProcedure
    
    Procedure.CGFloat GetWheelDeltaY()
      Protected wheelDeltaY.CGFloat = 0.0
      Protected currentEvent = GetCurrentEvent()
      If currentEvent
        CocoaMessage(@wheelDeltaY,currentEvent,"scrollingDeltaY")
      EndIf
      ProcedureReturn wheelDeltaY
    EndProcedure
  CompilerEndIf
  
  Procedure ReDraw(Canvas)
    If StartDrawing(CanvasOutput(Canvas))
      FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F6)
      
      ; PushListPosition(*List())
      ForEach *List()
        If Not *List()\hide
          Draw(*List())
        EndIf
      Next
      ; PopListPosition(*List())
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure v_GadgetCallBack()
    Protected Repaint.b, state = GetGadgetState(EventGadget())
    
    
    ForEach *List()
      If *List()\bar\vertical And *List()\type = GadgetType(EventGadget())
        Repaint | SetState(*List(), state)
      EndIf
    Next
    
    If Repaint
      SetWindowTitle(EventWindow(), Str(state))
      ReDraw(g_Canvas)
    EndIf
  EndProcedure
  
  Procedure h_GadgetCallBack()
    Protected Repaint.b, state = GetGadgetState(EventGadget())
    
    ForEach *List()
      If Not *List()\bar\vertical And *List()\type = GadgetType(EventGadget())
        Repaint | SetState(*List(), state)
      EndIf
    Next
    
    If Repaint
      SetWindowTitle(EventWindow(), Str(state))
      ReDraw(g_Canvas)
    EndIf
  EndProcedure
  
  Procedure v_CallBack(GetState, type)
    Select type
      Case #PB_GadgetType_ScrollBar
        SetGadgetState(2, GetState)
      Case #PB_GadgetType_TrackBar
        SetGadgetState(12, GetState)
      Case #PB_GadgetType_ProgressBar
        SetGadgetState(22, GetState)
      Case #PB_GadgetType_Splitter
        ; SetGadgetState(Splitter_4, GetState)
    EndSelect
    
    SetWindowTitle(EventWindow(), Str(GetState))
  EndProcedure
  
  Procedure h_CallBack(GetState, type)
    Select type
      Case #PB_GadgetType_ScrollBar
        SetGadgetState(1, GetState)
      Case #PB_GadgetType_TrackBar
        SetGadgetState(11, GetState)
      Case #PB_GadgetType_ProgressBar
        SetGadgetState(21, GetState)
      Case #PB_GadgetType_Splitter
        ; SetGadgetState(Splitter_3, GetState)
    EndSelect
    
    SetWindowTitle(EventWindow(), Str(GetState))
  EndProcedure
  
  Procedure.i Canvas_Events()
    Protected Canvas.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Repaint
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    ;      MouseX = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
    ;      MouseY = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
    Protected WheelDelta ; = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *callback = GetGadgetData(Canvas)
    ;     Protected *this._s_widget = GetGadgetData(Canvas)
    
    If EventType = #PB_EventType_MouseWheel
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        Protected wheel_X.CGFloat = GetWheelDeltaX()
        Protected wheel_Y.CGFloat = GetWheelDeltaY()
      CompilerElse
        Protected wheel_X
        Protected wheel_Y
      CompilerEndIf
    EndIf
    
    Select EventType
      Case #PB_EventType_Resize ; : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                                ;          ForEach *List()
                                ;            Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
                                ;          Next
        Repaint = 1
        
      Case #PB_EventType_LeftButtonDown
        SetActiveGadget(Canvas)
        
    EndSelect
    
    ForEach *List()
      Repaint | events(*List(), EventType, MouseX, MouseY, wheel_X, wheel_Y)
      
      If *List()\bar\change
        
        If *List()\bar\vertical
          v_CallBack(*List()\bar\page\pos, *List()\type)
        Else
          h_CallBack(*List()\bar\page\pos, *List()\type)
        EndIf
        
        *List()\bar\change = 0
      EndIf
    Next
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Procedure ev()
    ;Debug ""+Widget() +" "+ Type() +" "+ Item() +" "+ Data()     ;  EventWindow() +" "+ EventGadget() +" "+ 
  EndProcedure
  
  Procedure ev2()
    ;Debug "  "+Widget() +" "+ Type() +" "+ Item() +" "+ Data()   ;  EventWindow() +" "+ EventGadget() +" "+ 
  EndProcedure
  
  
  If OpenWindow(0, 0, 0, 605, 140+200+140+140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    g_Canvas = CanvasGadget(-1, 0, 0, 605, 140+200+140+140, #PB_Canvas_Container)
    BindGadgetEvent(g_Canvas, @Canvas_Events())
    PostEvent(#PB_Event_Gadget, 0,g_Canvas, #PB_EventType_Resize)
    
    TextGadget       (-1,  10, 15, 250,  20, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    ScrollBarGadget  (1,  10, 42, 250,  20, 30, 100, 30)
    SetGadgetState   (1,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  10,110, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ScrollBarGadget  (2, 270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    ;ScrollBarGadget  (2, 270, 10,  25, 100 ,0, 521, 96, #PB_ScrollBar_Vertical)
    SetGadgetState   (2, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    TextGadget       (-1,  300+10, 15, 250,  20, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    AddElement(*List()) : *List() = Spin  (300+10, 72, 250,  21, 0, 10, 0)
    SetState   (Widget(),  5)   ; set 1st scrollbar (ID = 0) to 50 of 100
    AddElement(*List()) : *List() = Scroll  (300+10, 42, 250,  20, 30, 100, 30, 0)
    SetState   (Widget(),  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    
    TextGadget       (-1,  300+10,110, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    AddElement(*List()) : *List() = Scroll  (300+270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical);|#__bar_inverted)
                                                                                                ;AddElement(*List()) : *List() = Scroll  (300+270, 10,  25, 100 ,0, 521, 96, #PB_ScrollVertical)
    SetState   (Widget(), 100)                                                                  ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    BindGadgetEvent(1,@h_GadgetCallBack())
    BindGadgetEvent(2,@v_GadgetCallBack())
    ;Bind(@ev(), Widget())
    
    
    ; example_2
    TextGadget    (-1, 10,  140+10, 250, 20,"TrackBar Standard", #PB_Text_Center)
    TrackBarGadget(10, 10,  140+40, 250, 20, 0, 10000)
    SetGadgetState(10, 5000)
    TextGadget    (-1, 10, 140+90, 250, 20, "TrackBar Ticks", #PB_Text_Center)
    ;     TrackBarGadget(11, 10, 140+120, 250, 20, 0, 30, #PB_TrackTicks)
    TrackBarGadget(11, 10, 140+120, 250, 20, 30, 60, #PB_TrackBar_Ticks)
    SetGadgetState(11, 60)
    TextGadget    (-1,  60, 140+160, 200, 20, "TrackBar Vertical", #PB_Text_Right)
    TrackBarGadget(12, 270, 140+10, 25, 170, 0, 10000, #PB_TrackBar_Vertical)
    SetGadgetState(12, 8000)
    
    
    TextGadget    (-1, 300+10,  140+10, 250, 20,"TrackBar Standard", #PB_Text_Center)
    AddElement(*List()) : *List() = Track(300+10,  140+40, 250, 20, 0, 10000, 0)
    SetState(Widget(), 5000)
    TextGadget    (-1, 300+10, 140+90, 250, 20, "TrackBar Ticks", #PB_Text_Center)
    ;     AddElement(*List()) : *List() = Track(300+10, 140+120, 250, 20, 0, 30, #__bar_ticks)
    AddElement(*List()) : *List() = Track(300+10, 140+120, 250, 20, 30, 60, #PB_TrackBar_Ticks)
    SetState(Widget(), 60)
    TextGadget    (-1,  300+60, 140+160, 200, 20, "TrackBar Vertical", #PB_Text_Right)
    AddElement(*List()) : *List() = Track(300+270, 140+10, 25, 170, 0, 10000, #PB_TrackBar_Vertical)
    SetState(Widget(), 8000)
    
    BindGadgetEvent(11,@h_GadgetCallBack())
    BindGadgetEvent(12,@v_GadgetCallBack())
    
    ;
    ; example_3
    TextGadget       (-1,  10, 140+200+10, 250,  20, "ProgressBar Standard  (start=65, page=30/100)",#PB_Text_Center)
    ProgressBarGadget  (21,  10, 140+200+42, 250,  20, 30, 100)
    SetGadgetState   (21,  65)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  10,140+200+100, 250,  20, "ProgressBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ProgressBarGadget  (22, 270, 140+200,  25, 120 ,0, 300, #PB_ProgressBar_Vertical)
    SetGadgetState   (22, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    
    TextGadget       (-1,  300+10, 140+200+10, 250,  20, "ProgressBar Standard  (start=65, page=30/100)",#PB_Text_Center)
    AddElement(*List()) : *List() = Progress  (300+10, 140+200+42, 250,  20, 30, 100, 0)
    SetState   (Widget(),  65)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  300+10,140+200+100, 250,  20, "ProgressBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    AddElement(*List()) : *List() = Progress  (300+270, 140+200,  25, 120 ,0, 300, #PB_ProgressBar_Vertical)
    SetState   (Widget(), 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    BindGadgetEvent(21,@h_GadgetCallBack())
    BindGadgetEvent(22,@v_GadgetCallBack())
    
    
    ; example_4
    ;     TextGadget       (-1,  10, 140+200+140+10, 230,  20, "SplitterBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    ;     ScrollBarGadget(100, 0, 0, 0, 0, 30,71, 0) ; No need to specify size or coordinates
    ;     ProgressBarGadget(200, 0, 0, 0, 0, 30,100) ; as they will be sized automatically
    ;     SetGadgetState   (100, 30)
    ;     SetGadgetState   (200, 50)
    ;     SplitterGadget  (31,  10, 140+200+140+42, 230,  60, 100, 200, #PB_Splitter_Vertical)
    ;     SetGadgetState   (31,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    ;     TextGadget       (-1,  10,140+200+140+110, 230,  20, "SplitterBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ;     TrackBarGadget(300, 0, 0, 250,  20, 30, 100) ; No need to specify size or coordinates
    ;     ProgressBarGadget(400, 0, 0, 0, 0, 30,100)   ; as they will be sized automatically
    ;     SetGadgetState   (300, 30)
    ;     SetGadgetState   (400, 50)
    ;     SplitterGadget  (32, 250, 140+200+140+10,  45, 120 ,300, 400, 0)
    ;     SetGadgetState   (32, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    ;     TextGadget       (-1,  300+10, 140+200+140+10, 230,  20, "SplitterBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    ;     *b1 = Splitter  (0, 0, 0, 0, 0, 0, #PB_Splitter_Vertical|#PB_Splitter_Separator);|#PB_Splitter_FirstFixed)
    ;     *b2 = Progress  (0, 0, 0, 0, 30, 100, 0)
    ;     ;SetState   (*b1, 30) 
    ;     SetState   (*b2, 50) 
    ;     AddElement(*List()) : *List() = *b1
    ;     AddElement(*List()) : *List() = *b2
    ;     
    ;     AddElement(*List()) : *List() = Splitter  (300+10, 140+200+140+42, 230,  60, *b1, *b2, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    ;     SetState   (Widget(),  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    ;     SetAttribute(Widget(), #__FirstMinimumSize, 20)
    ;     SetAttribute(Widget(), #__SecondMinimumSize, 20)
    ;     TextGadget       (-1,  300+10,140+200+140+110, 230,  20, "SplitterBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ;     
    ;     *b3 = Track  (0, 0, 0, 0, 30, 60)
    ;     *b4 = Progress  (0, 0, 0, 0, 30, 100)
    ;     SetState   (*b3, 30) 
    ;     SetState   (*b4, 50) 
    ;     AddElement(*List()) : *List() = *b3
    ;     AddElement(*List()) : *List() = *b4
    ;     
    ;     AddElement(*List()) : *List() = Splitter  (300+250, 140+200+140+10,  45, 120 ,*b3, *b4, #PB_Splitter_Separator)
    ;     ;SetState   (*List(), 40)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    ;     
    ;     BindGadgetEvent(31,@h_GadgetCallBack())
    ;     BindGadgetEvent(32,@v_GadgetCallBack())
    ;     
    ;     Post(333, Widget())
    ;     Bind(@ev2(), Widget(), #PB_EventType_StatusChange)
    
    
    
    Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
    Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
    
    Button_2 = SpinGadget(#PB_Any, 0, 0, 0, 0, 0,20) ; No need to specify size or coordinates
    Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
    Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
    Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
    
    Splitter_0 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
    SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
    ;     ;SetGadgetState(Splitter_1, 20)
    Splitter_2 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = SplitterGadget(#PB_Any, 10, 140+200+130, 285, 140, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    
    
    Button_0 = Bar::Progress(0, 0, 0, 0, 0,100) ; No need to specify size or coordinates
    Button_1 = Bar::Progress(0, 0, 0, 0, 10, 100); No need to specify size or coordinates
    Button_2 = Bar::Spin(0, 0, 0, 0, 0,20)       ; as they will be sized automatically
    Button_3 = Bar::Scroll(0, 0, 0, 0, 0, 100, 30, #__bar_vertical|#__bar_inverted) ; as they will be sized automatically
    
    Button_4 = Bar::Progress(0, 0, 0, 0, 40,100) ; as they will be sized automatically
    Button_5 = Bar::Spin(0, 0, 0, 0, 50,100, #__bar_vertical) ; as they will be sized automatically
    
    Splitter_0 = Bar::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = Bar::Splitter(0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
    SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
    ;SetState(Splitter_1, 410/2-20)
    Splitter_2 = Bar::Splitter(0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = Bar::Splitter(0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = Bar::Splitter(300+10, 140+200+130, 285, 140, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    
    SetState(Button_2, 5)
    SetState(Button_5, 65)
    
    ;     Widget() = Button_3
    ;     Widget()\height = 30
    ;     Widget()\width = 30
    ;     Widget()\bar\button[#__b_3]\len = 30
    ;     Resize(Widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    
    AddElement(*List()) : *List() = Button_0
    AddElement(*List()) : *List() = Button_1
    AddElement(*List()) : *List() = Button_2
    AddElement(*List()) : *List() = Button_3
    AddElement(*List()) : *List() = Button_4
    AddElement(*List()) : *List() = Button_5
    
    AddElement(*List()) : *List() = Splitter_0
    ; *List()\focus = 10
    AddElement(*List()) : *List() = Splitter_1
    ; *List()\focus = 11
    AddElement(*List()) : *List() = Splitter_2
    AddElement(*List()) : *List() = Splitter_3
    AddElement(*List()) : *List() = Splitter_4
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -------------------------------------------------------
; EnableXP