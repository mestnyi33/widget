XIncludeFile "constants.pbi"

;-
CompilerIf Not Defined(structures, #PB_Module)
  DeclareModule structures
    Prototype pFunc( )
    
    ;{ 
    ;- - _s_value
    Structure _s_VALUE
      s.s
      i.i
    EndStructure
    
    ;- - _s_point
    Structure _s_POINT
      y.l[5] ; убрать 
      x.l[constants::#__c]
    EndStructure
    
    ;- - _s_coordinate
    Structure _s_coordinate ;Extends _s_point
      y.l
      x.l
      width.l
      height.l
    EndStructure
    
    ;- - _s_padding
    Structure _s_padding
      left.l
      top.l
      right.l
      bottom.l
    EndStructure
    
    ;- - _s_color
    Structure _s_color
      state.b; entered; selected; disabled;
      front.i[4]
      line.i[4]
      fore.i[4]
      back.i[4]
      frame.i[4]
      _alpha.a[2]
      *alpha._s_color
    EndStructure
    
    ;- - _s_align
    Structure _s_align
      delta._s_coordinate
      _left.l
      _top.l
      _right.l
      _bottom.l
      
      left.b
      top.b
      right.b
      bottom.b
      
      ; proportional.b
      autosize.b
      v.b
      h.b
    EndStructure
    
    ;- - _s_arrow
    Structure _s_arrow
      size.a
      type.b
      direction.b
    EndStructure
    
    ;- - _s_page
    Structure _s_page
      pos.l
      len.l
      *end
      change.f
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
      
      *color._s_color
    EndStructure
    
    ;- - _s_syntax
    Structure _s_syntax
      List *word._s_edit( )
    EndStructure
    
    ;- - _s_text
    Structure _s_text Extends _s_edit
      ;     ;     Char.c
      *fontID ; .i[2]
      
      StructureUnion
        pass.b
        lower.b
        upper.b
        numeric.b
      EndStructureUnion
      
      editable.b
      multiline.b
      
      invert.b
      
      ; short._s_edit ; ".."
      edit._s_edit[4]
      caret._s_caret
      syntax._s_syntax
      
      ; short._s_text ; сокращенный текст
      
      rotate.f
      align._s_align
      padding._s_point
    EndStructure
    
    ;- - _s_image
    Structure _s_image Extends _s_coordinate
      *id  ; - ImageID( ) 
      *img ; - Image( )
      
      change.b
      size.w  ; icon small/large
      
      ;;rotate.f
      align._s_align
      padding._s_point
;       
;       
;       *pressed._s_image
;       *released._s_image
;       *background._s_image
    EndStructure
    
;     ;- - _s_anchor
;     Structure _s_anchor Extends _s_coordinate
;       round.a
;       cursor.l
;       color._s_color;[4]
;     EndStructure
    ;- - _s_buttons
    Structure _s_buttons Extends _s_coordinate 
      ;;index.l
      cursor.l ; anchor buttons
      
      size.l ; len >> size.l
      _state.l ; normal; entered; selected; disabled
      state.l ; temp
      
      fixed.l 
      
      hide.b
      round.a
      interact.b
      
      arrow._s_arrow
      color._s_color[4]
    EndStructure
    
;     ;- - _s_button
;     Structure _s_button 
;       pushed.l
;       entered.l
;       id._s_buttons[3]
;     EndStructure
    
    ;- - _s_margin
    Structure _s_margin Extends _s_coordinate
      color._s_color
      hide.b
    EndStructure
    
    ;- - _s_tabs
    Structure _s_tabs ;Extends _s_coordinate
      y.l[constants::#__c]
      x.l[constants::#__c]
      height.l[constants::#__c]
      width.l[constants::#__c]
      
      index.l  ; Index of new list element
      hide.b
      draw.b
      round.a
      
      text._s_text
      image._s_image
      color._s_color
      
      checkbox._s_buttons ; \box[1]\ -> \checkbox\
      
      _state.l
      EndStructure
    
    ;- - _s_rows
    Structure _s_rows Extends _s_tabs
      childrens.b
      
      sublevel.w
      sublevelsize.a
            
      button._s_buttons ; \box[0]\ -> \button\
      ;;checkbox._s_buttons ; \box[1]\ -> \checkbox\
      
      *last._s_rows   ; if parent - \last\child ; if child - \parent\last\child
      *parent._s_rows
      
      *option_group._s_rows
               
      ; edit
      margin._s_edit
      
      *data  ; set/get item data
    EndStructure
    
    ;- - _s_row
    Structure _s_row
      ; list view
      ; drag.b
      sublevel.w
      sublevelsize.a
      
      *_tt._s_tt
      
      *first._s_rows           ; first elemnt in the list 
      *first_visible._s_rows   ; first draw elemnt in the list 
      
      *last._s_rows            ; last elemnt in the list 
      *last_visible._s_rows    ; last draw elemnt in the list 
      *last_add._s_rows        ; last added last element
      
       *selected._s_rows        ; at point pushed item
       *leaved._s_rows         ; pushed last entered item
       *entered._s_rows         ; pushed last entered item
      
      List *draws._s_rows( )
      
      ; edit
      ;caret._s_caret
      ;color._s_color
      margin._s_margin
      
      ;
      count.l
      index.l
      box._s_buttons           ; editor - edit rectangle
      
      List _s._s_rows( )
    EndStructure
    
    ;- - _s_column
    Structure _s_column Extends _s_coordinate
      
    EndStructure
    
    ;- - _s_bar
    Structure _s_bar
      index.l  ; tab opened item index  
      fixed.l ; splitter fixed button index  
      mode.i
      
      ;;*selected._s_buttons
      button._s_buttons[4]
       
      max.l
      min.l[3]
      ;hide.b
      
      change.b ;????
      change_tab_items.b ; tab items to redraw
      percent.f
      ;;increment.f
      ; vertical.b
      inverted.b
      direction.l
      
      page._s_page
      area._s_page
      thumb._s_page  
      
      List *_s._s_tabs( )
      
      ; tab
      *active._s_rows         ; at point element item
      *hover._s_rows
      
               *selected._s_tabs     ;???????????????   ; at point pushed item
      *leaved._s_tabs         ; pushed last entered item
     ; *entered._s_tabs         ; pushed last entered item
      List *draws._s_tabs( )
      
    EndStructure
    
    ;     ;- - _s_tab
    ;     Structure _s_tab
    ;       bar._s_bar
    ;       ;List *_s._s_tabs( )
    ;     EndStructure
    
    ;- - _s_dotted
    Structure _s_dotted
      ;draw.b
      dot.l
      line.l
      space.l
    EndStructure
    
    ;- - _s_grid
    Structure _s_grid
      *WIDGET
      *image
      size.l
      type.l
    EndStructure
    
    ; multi group
    Structure _s_group Extends _s_coordinate
      *WIDGET._s_WIDGET
    EndStructure
    
    ;- - _s_transform
    Structure _s_transform
      *main._s_WIDGET
      *WIDGET._s_WIDGET
      *_a_WIDGET._s_WIDGET
      List *group._s_group( )
      
      *type
      *grab ; grab image handle
      
      pos.l
      size.l
      index.l
      
      grid._s_grid
      dotted._s_dotted
      id._s_buttons[constants::#__a_count+1]
    EndStructure
    
    ;- - _s_mode
    Structure _s_mode
;       SystemMenu.b     ; 13107200   - #PB_Window_SystemMenu      ; Enables the system menu on the Window Title bar (Default).
;       MinimizeGadget.b ; 13238272   - #PB_Window_minimizeGadget  ; Adds the minimize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
;       MaximizeGadget.b ; 13172736   - #PB_Window_maximizeGadget  ; Adds the maximize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
;       SizeGadget.b     ; 12845056   - #PB_Window_SizeGadget      ; Adds the sizeable feature To a Window.
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
    
    ;- - _s_caption
    Structure _s_caption
      y.l[5]
      x.l[5]
      height.l[5]
      width.l[5]
      
      text._s_text
      button._s_buttons[4]
      color._s_color
      
      interact.b
      hide.b
      round.b
      _padding.b
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
    
    ;- - _s_SCROLL
    Structure _s_SCROLL Extends _s_coordinate
      align._s_align
      ;padding.b
      
      increment.f      ; scrollarea
      *v._s_WIDGET     ; vertical scrollbar
      *h._s_WIDGET     ; horizontal scrollbar
    EndStructure
    
    ;- - _s_popup
    Structure _s_popup
      gadget.i
      window.i
      
      ; *Widget._s_widget
    EndStructure
    
    ;- - _s_count
    Structure _s_count
      index.l
      type.l
      items.l
      events.l
      childrens.l
    EndStructure
    
    
;     ;- - _s_items
;     Structure _s_items Extends _s_coordinate
;       index.l
;       *parent._s_items
;       draw.b
;       hide.b
;       
;       image._s_image
;       text._s_text[4]
;       box._s_buttons[2]
;       color._s_color
;       
;       ;state.b
;       round.a
;       
;       sublevel.w
;       childrens.l
;       sublevelsize.l
;       
;       *data      ; set/get item data
;     EndStructure
;     
    ;- - _s_dd
    Structure _S_Drop
      privatetype.i
      format.i
      actions.i
    EndStructure
    
    Structure _S_DD Extends _S_Drop
      y.l
      x.l
      width.l
      height.l
      
      *value
      string.s
    EndStructure
    
    ;- - _s_drag
    Structure _s_DRAG
      start.b
      *address._S_DD
    EndStructure
    
    ;- - _s_OBJECT
    Structure _s_OBJECT
      *widget._s_WIDGET
    EndStructure
    
    ;- - _s_EVENTDATA
    Structure _s_EVENTDATA
      *type ; EventType( )
      *item ; EventItem( )
      *data ; EventData( )
    EndStructure
    
   ;- - _s_FUNC 
    Structure _s_FUNC
      *func.pFunc
    EndStructure
    
    ;- - _s_BIND 
   Structure _s_BIND 
      *eventtype
      List *callback._s_FUNC( )
    EndStructure
    
    ;- - _s_EVENT
    Structure _s_EVENT
      List *bind._s_bind( )
      List *queue._s_EVENTDATA( )
    EndStructure
    
    ;- - _s_TAB_WIDGET
    Structure _s_TAB_WIDGET Extends _s_OBJECT
      index.i ; parent-tab item index
    EndStructure
    
    ;-
    ;- - _s_WIDGET
    Structure _s_WIDGET
      *drop._s_DD
      _a_transform.b ; add anchors on the widget (to size and move)
      *_a_id_._s_buttons[constants::#__a_moved+1]
      
      fs.a[5] ; frame size; [1] - inner left; [2] - inner top; [3] - inner right; [4] - inner bottom
      bs.a ; border size
      _state.w ; #__s_ (entered; selected; disabled; focused; toggled; scrolled)
      __state.w ; #_s_ss_ (font; back; frame; fore; line)
      __draw.b 
      
      BarWidth.w ; bar v size
      BarHeight.w ; bar h size 
      MenuBarHeight.w
      ToolBarHeight.w
      StatusBarHeight.w
      
      y.l[constants::#__c]
      x.l[constants::#__c]
      height.l[constants::#__c]
      width.l[constants::#__c]
      
      ; placing layout
      first._s_OBJECT
      last._s_OBJECT
      after._s_OBJECT
      before._s_OBJECT
      
      tab._s_TAB_WIDGET
      
      *index[3]  
      ; \index[0] - widget index 
      ; \index[1] - panel opened tab index
      ; \index[2] - panel selected item index
      ; \index[1] - tab entered item index
      ; \index[2] - tab selected item index
      
      *address          ; widgets list address
      *container        ; 
      *root._s_ROOT     ; this root
      
      *parent._s_WIDGET; this parent
      *window._s_WIDGET; this parent window       ; root( )\active\window
      
      StructureUnion
        *_owner._s_WIDGET; this window owner parent
        *_group._s_WIDGET; = option( ) groupbar gadget  
      EndStructureUnion
      
      *_tt._s_tt          ; notification = уведомление
      *_popup._s_WIDGET; combobox( ) list-view gadget
      scroll._s_SCROLL  ; vertical & horizontal scrollbars
      
      *gadget._s_WIDGET[3] 
      ; \root\gadget[0] - active gadget
      ; \gadget[0] - window active child gadget 
      ; \gadget[1] - splitter( ) first gadget
      ; \gadget[2] - splitter( ) second gadget
      
      image._s_image[4]       
      ; \image[0] - draw image
      ; \image[1] - released image
      ; \image[2] - pressed image
      ; \image[3] - background image
      
      *flag
      *data
      
      draw_widget.b
      
      child.b ; is the widget composite?
      
      level.l 
      class.s  
      change.l
      vertical.b
      type.b
      hide.b[2] 
      cursor.l[2]
      round.a
      
      repaint.i
      resize.l
      
      *errors
      notify.l ; оповестить об изменении
      interact.i 
      
      mode._s_mode
      count._s_count
      caption._s_caption
      color._s_color[4]
      
      row._s_row
      text._s_text 
      
      *bar._s_bar
      
      ;combo_box._s_buttons
      button._s_buttons ; checkbox; optionbox
      
      *align._s_align
      
      *time_click
      *time_down
      *time
      
      *event._s_EVENT
      
      List *column._s_column( )
    EndStructure
    
    ;- - _s_MOUSE
    Structure _s_MOUSE Extends _s_POINT
      interact.b ; determines the behavior of the mouse in a clamped (pushed) state
      ;*behavior
      *bar_row._s_tabs[3]         ; at point element item
      *row._s_rows[2]         ; at point element item
      *button._s_buttons[3]   ; at point element button
      
      *entered._s_WIDGET      ; mouse enterd element
      *leaved._s_WIDGET       ; mouse leaved element
      *selected._s_WIDGET     ; mouse pushed element
      
      *grid
      buttons.l 
      
      wheel._s_POINT
      delta._s_POINT
      
      *_drag._S_DD
      *_transform._s_transform
    
      change.b
      ;move._s_point
    EndStructure
    
    ;- - _s_KEYBOARD
    Structure _s_KEYBOARD
      *widget._s_WIDGET   ; keyboard focus element
      *window._s_WIDGET   ; active window element ; GetActiveWindow( )\
      
      change.b
      input.c
      key.i[2]
    EndStructure
    
    ;- - _s_CANVAS
    Structure _s_CANVAS
      repaint.b
      *address            ; root list address
      *fontID             ; default drawing fontid
      
      container.i
      window.i            ; canvas window
      gadget.i            ; canvas gadget
      
      postevent.b         ; post evet canvas repaint
      bindevent.b         ; bind canvas event
    EndStructure
    
    ;- - _s_STICKY
    Structure _s_STICKY
      *window._s_WIDGET
      *message._s_WIDGET
      ; *tooltip._s_WIDGET            ; 
    EndStructure
    
    ;- - _s_ROOT
    Structure _s_ROOT Extends _s_WIDGET
      canvas._s_canvas
      *openlist._s_WIDGET   ; opened list element
    EndStructure
    
    ;- - _s_INCLUDE
    Structure _s_INCLUDE 
      mouse._s_mouse                ; mouse( )\
      keyboard._s_keyboard          ; keyboard( )\
      sticky._s_sticky              ; top level
      
      *widget._s_WIDGET             ; EventWidget( )\ 
      event._s_EVENTDATA            ; WidgetEvent( )\ ; \type ; \item ; \data
      
      List *_root._s_ROOT( )        ; 
      List *address._s_WIDGET( ) ; widget( )\
    EndStructure
    
    ;Global *event._s_events = AllocateStructure(_s_events)
    ;}
    
  EndDeclareModule 
  
  Module structures 
    
  EndModule 
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -------v-
; EnableXP