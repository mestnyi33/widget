XIncludeFile "constants.pbi"

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
      press.b
      enter.b
      drag.b
      focus.b
      ;active.b
      repaint.b
      click.b
      
      create.b
    EndStructure
    ;--     objecttype
    Structure _S_objecttype
      *root._S_root
      *row._S_rowS
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
      
      button._S_buttons ; \box[0]\ -> \button\
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
      *active._S_rows ; _get_bar_active_item_
      *hover._S_rows  ; _get_bar_active_item_
      
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
      id._S_buttons[constants::#__a_count+1]
    EndStructure
    
    Structure _S_a
      pos.l
      size.l
      
      index.b
      transform.b
      mode.i
      *id._S_buttons[constants::#__a_moved+1]
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
      *_a_id_._S_buttons[constants::#__a_moved+1]
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
      event._S_eventdata   ; 
      List *events._S_eventdata( )    ; 
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
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ----------
; EnableXP