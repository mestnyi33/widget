XIncludeFile "constants.pbi"

;-
CompilerIf Not Defined(Structures, #PB_Module)
  DeclareModule Structures
    Prototype pFunc( )
    
    ;{ 
    ;--     POINT
    Structure _s_POINT
      y.l[3]
      x.l[3]
    EndStructure
    ;--     SIZE
    Structure _s_SIZE
      width.l
      height.l
    EndStructure
    ;--     COORDINATE
    Structure _s_coordinate 
      y.l
      x.l
      width.l
      height.l
    EndStructure
    ;--     POSITION
    Structure _s_position
      *left
      *top
      *right
      *bottom
    EndStructure
    ;--     STATE
    Structure _s_STATE
      *flag           ;& normal; entered; selected; disabled
      hide.b      ; panel childrens real hide state
      
      disable.b
      
      enter.b
      press.b
      focus.b
      drag.b
      ;;;;drop.b ; enable drop
      
      change.b
      move.b
      size.b
      
      ;active.b
      repaint.b
      click.b
      
      create.b
    EndStructure
    ;--     OBJECTTYPE
    Structure _s_OBJECTTYPE
      *root._s_root
      *row._s_rowS
      *last._s_widget
      *widget._s_widget
      *button._s_BUTTONS
    EndStructure
    ;--     MOUSE
    Structure _s_mouse Extends _s_POINT
      cursor.l
       area._s_coordinate         ; cursor tracking area - область отслеживания курсора
      
      buttons.l                  ; 
      
      entered._s_objecttype      ; mouse entered element
      pressed._s_objecttype      ; mouse button's pushed element
      leaved._s_objecttype       ; mouse leaved element
      
      wheel._s_point
      delta._s_point
      
      *_drag._s_dd
      *_transform._s_transform
      
      *grid
      change.b                   ; if moved mouse this value #true
      interact.b                 ; determines the behavior of the mouse in a clamped (pushed) state
    EndStructure
    ;--     KEYBOARD
    Structure _s_KEYBOARD ; Ok
      *window._s_widget          ; active window element ; GetActive( )\
      focused._s_objecttype      ; keyboard focus element
      change.b
      input.c
      key.i[2]
    EndStructure
    ;- - _s_color
    Structure _s_color
      state.b ; entered; selected; disabled;
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
      width.l
      height.l
      delta._s_coordinate             
      anchor._s_position ; align the anchor to the left;right;top;bottom
      auto._s_position
      indent._s_position
    EndStructure
    
    ;- - _s_arrow
    Structure _s_ARROW
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
      direction.b
      
      pos.l[4]
      time.l
      
      
      line.l[2]
      change.b
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
      
      ;;*output;transparent.b
      depth.a
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
    ;     structure _s_anchor extends _s_coordinate
    ;       round.a
    ;       *cursor
    ;       color._s_color;[4]
    ;     Endstructure
    ;- - _s_buttons
    Structure _s_BUTTONS Extends _s_coordinate 
      state._s_state
       index.l ; - anchors
      *cursor ; anchor buttons
      
      size.l 
      ___state.l  ; temp
      
      fixed.l 
      
      hide.b
      round.a
      interact.b
      
      arrow._s_arrow
      color._s_color[4]
    EndStructure
    
    ;     ;- - _s_button
    ;     structure _s_button 
    ;       pushed.l
    ;       entered.l
    ;       id._s_buttons[3]
    ;     Endstructure
    
    ;- - _s_margin
    Structure _s_margin Extends _s_coordinate
      color._s_color
      hide.b
    EndStructure
    
    ;- - _s_tabs
    Structure _s_TABS ;extends _s_coordinate
      state._s_state
      
      y.l[constants::#__c]
      x.l[constants::#__c]
      height.l[constants::#__c]
      width.l[constants::#__c]
      ; transporent.b
      
      index.l  ; Index of new list element
      hide.b
      visible.b
      round.a
      
      text._s_text
      image._s_image
      color._s_color
      
      checkbox._s_buttons ; \box[1]\ -> \checkbox\
    EndStructure
    
    ;- - _s_count
    Structure _s_count
      index.l
      type.l
      items.l
      events.l
      parents.b
      childrens.l
    EndStructure
    
    ;- - _s_rows
    Structure _s_rowS Extends _s_TABS
      ;;state._s_state
      count._s_count
      
      sublevel.w
      sublevelsize.a
      
          button._s_buttons ;temp \box[0]\ -> \button\
      collapsebox._s_buttons ; \box[0]\ -> \button\ -> \collapsebox\
                        ;;checkbox._s_buttons ; \box[1]\ -> \checkbox\
      
      *last._s_rows   ; if parent - \last\child ; if child - \parent\last\child
      *_parent._s_rows
      parent._s_objecttype
      
      *option_group._s_rows
      
      ; edit
      margin._s_edit
      
      *data  ; set/get item data
      
      
    EndStructure
    Structure _s_VISIBLEITEMS
      *first._s_rows           ; first draw-elemnt in the list 
      *last._s_rows            ; last draw-elemnt in the list 
      List *_s._s_rows( )      ; all draw-elements
    EndStructure
    ;- - _s_row
    Structure _s_row
      sublevel.w
      sublevelsize.a
      
      *_tt._s_tt
      
      List _s._s_rows( )
      
      *first._s_rows           ; first elemnt in the list 
      *last._s_rows            ; last elemnt in the list 
      *last_add._s_rows        ; last added last element
      
      *active._s_rows          ; focused item
      *pressed._s_rows         ; pushed item
      *entered._s_rows         ; entered item
      *leaved._s_rows          ; leaved item
      
      visible._s_VISIBLEITEMS
      
      margin._s_margin
      
      count.l
      ;index.l
      box._s_buttons           ; editor - edit rectangle
      
    EndStructure
    
    ;- - _s_column
    Structure _s_column Extends _s_coordinate
      
    EndStructure
    
    ;- - _s_bar
    Structure _s_bar
      *widget._s_widget
      
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
      
      page._s_page
      area._s_page
      thumb._s_page  
      *button._s_buttons[4]
      
      ; tab
      *pressed._s_rows ; _get_bar_active_item_
      *active._s_rows ; _get_bar_active_item_
      *hover._s_rows  ; _get_bar_active_item_
      
      change_tab_items.b ; tab items to redraw
      
      ;;*selected._s_tabs     ;???????????????   ; at point pushed item
      ; *leaved._s_tabs         ; pushed last entered item
      ; *entered._s_tabs         ; pushed last entered item
      
      List *_s._s_tabs( )
      List *draws._s_tabs( )
      
      
      index.i
    EndStructure
    
    ;     ;- - _s_tab
    ;     structure _s_tab
    ;       bar._s_bar
    ;       ;List *_s._s_tabs( )
    ;     Endstructure
    
    ;- - _s_dotted
    Structure _s_dotted
      ;draw.b
      dot.l
      line.l
      space.l
    EndStructure
    
    ;- - _s_grid
    Structure _s_grid
      *widget
      *image
      size.l
      type.l
    EndStructure
    
    ; multi group
    Structure _s_group Extends _s_coordinate
      *widget._s_widget
    EndStructure
    
    ;- - _s_anchors
    Structure _s_transform
      *main._s_widget
      *widget._s_widget
      *_a_widget._s_widget
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
    
    Structure _s_a
      pos.l
      size.l
      
      index.b
      transform.b
      mode.i
      *id._s_buttons[constants::#__a_moved+1]
    EndStructure
    
    ;- - _s_mode
    Structure _s_mode
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
    
    ;- - _s_caption
    Structure _s_caption
      y.l[5]
      x.l[5]
      height.l[5]
      width.l[5]
      ; transporent.b
      
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
    
    ;- - _s_scroll
    Structure _s_scroll Extends _s_coordinate
      align._s_align
      ;padding.b
      
      state.b    ; set state status
     
      increment.f      ; scrollarea
      *v._s_widget     ; vertical scrollbar
      *h._s_widget     ; horizontal scrollbar
    EndStructure
    
    ;- - _s_popup
    Structure _s_popup
      gadget.i
      window.i
      
      ; *widget._s_widget
    EndStructure
    
    
    ;     ;- - _s_items
    ;     structure _s_items extends _s_coordinate
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
    ;     Endstructure
    ;     
    ;- - _s_dd
    Structure _s_Drop
      privatetype.i
      format.i
      actions.i
    EndStructure
    
    Structure _s_dd Extends _s_Drop
      y.l
      x.l
      width.l
      height.l
      
      *value
      string.s
    EndStructure
    
    ;- - _s_drag
    Structure _s_drag
      start.b
      *address._s_dd
    EndStructure
    
    ;- - _s_eventdata
    Structure _s_eventdata
      *back.pFunc ; temp
      
      *id
      
      *pFunc.pFunc
      ; *widget._s_widget
      *type ; eventType( )
      *item ; eventItem( )
      *data ; eventdata( )
    EndStructure
    
    ;- - _s_BIND 
    Structure _s_eventbind 
      *func.pFunc
      List *type( )
    EndStructure
    
    ;- - _s_event
    Structure _s_event ; extends _s_eventdata
      List *post._s_eventdata( )
      
      List *call._s_eventdata( )
      List *_call._s_eventbind( )
      List *queue._s_eventdata( )
    EndStructure
    
    ;- - _s_TAB_widget
    Structure _s_objecttype_ex Extends _s_objecttype
      index.i ; parent-tab item index
    EndStructure
    
    ;--      bound
    Structure _s_boundvalue
      min.i
      max.i
    EndStructure
    Structure _s_boundmove
      x._s_boundvalue
      y._s_boundvalue
    EndStructure
    Structure _s_boundsize
      width._s_boundvalue
      height._s_boundvalue
    EndStructure
    Structure _s_bounds
      *move._s_boundmove
      *size._s_boundsize
    EndStructure
    ;- - _s_attach
    Structure _s_attach Extends _s_coordinate
      mode.a
      parent._s_objecttype
    EndStructure
    
    ;- - _s_widget
    Structure _s_widget
      *mouse._s_mouse
      state._s_state
      
      *drop._s_dd
      *attach._s_attach
      bounds._s_boundS
      
      _a_mode.i
      _a_transform.b ; add anchors on the widget (to size and move)
      *_a_id_._s_buttons[constants::#__a_moved+1]
      _a_._s_a
      
      
      fs.a[5] ; frame size; [1] - inner left; [2] - inner top; [3] - inner right; [4] - inner bottom
      bs.a    ; border size
      
      __state.w ; #_s_ss_ (font; back; frame; fore; line)
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
      first._s_objecttype
      last._s_objecttype
      after._s_objecttype
      before._s_objecttype
      
      parent._s_objecttype_ex
      tab._s_objecttype_ex
      
      ; 
      *position ; ;#PB_List_First; #PB_List_Last
      
      
      *index[3]  
      ; \index[0] - widget index 
      ; \index[1] - panel opened tab index
      ; \index[2] - panel selected item index
      ; \index[1] - tab entered item index
      ; \index[2] - tab selected item index
      
      *address          ; widgets list address
      *root._s_root     ; this root
      *window._s_widget ; this parent window       ; root( )\active\window
      
      
      *container        ; 
      count._s_count
      
      ;StructureUnion
        *_owner._s_widget; this window owner parent
        *_group._s_widget; = option( ) groupbar gadget  
      ;EndStructureUnion
      
      *_tt._s_tt          ; notification = уведомление
      *_popup._s_widget   ; combobox( ) list-view gadget
      scroll._s_scroll    ; vertical & horizontal scrollbars
      
      *gadget._s_widget[3] 
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
      
      mode._s_mode
      caption._s_caption
      color._s_color[4]
      
      text._s_text 
      
      *bar._s_bar
      *row._s_row ; multi-text; buttons; lists; - gadgets
      *_box_._s_buttons ; checkbox; optionbox
      
      *combo_list._s_widget
      
      *align._s_align
      
      *time_click
      *time_down
      *time
      
      *event._s_event
      events._s_eventdata ;?????????
      
      List *column._s_column( )
    EndStructure
    ;- - _s_canvas
    Structure _s_canvas
      *cursor             ; current visible cursor
      *fontID             ; current drawing fontid
      *address            ; root list address
      
      window.i            ; canvas window
      gadget.i            ; canvas gadget
      container.i         ; 
      
      repaint.b
      postevent.b         ; post evet canvas repaint
      bindevent.b         ; bind canvas event
      
      List *child._s_widget( )    ; widget( )\
      event._s_eventdata   ; 
      List *events._s_eventdata( )    ; 
    EndStructure
    
    ;- - _s_sticky
    Structure _s_sticky
      *widget._s_widget  ; popup gadget element
      *window._s_widget  ; top level window element
      *message._s_widget ; message window element
      *tooltip._s_widget ; tool tip element
    EndStructure
    
    ;- - _s_root
    Structure _s_root Extends _s_widget
      canvas._s_canvas
    EndStructure
    
    ;--      struct
    Structure _s_struct 
      *drawing
      *action_widget._s_widget
      action_type.s
       
      *opened._s_widget             ; last list opened element
      *closed._s_widget             ; last list opened element
       
      *root._s_root       ; 
      Map *roots._s_root( )         ; 
      mouse._s_mouse                ; mouse( )\
      keyboard._s_keyboard          ; keyboard( )\
      sticky._s_sticky              ; sticky( )\
      
      *widget._s_widget             ; eventwidget( )\ 
      event._s_eventdata            ; widgetevent( )\ ; \type ; \item ; \data
      
      
      ; для совместимости
      List *_root._s_root( )        ; 
      List *_address._s_widget( )   ; widget( )\
    EndStructure
    
    ;Global *event._s_events = Allocatestructure(_s_events)
    ;}
    
  EndDeclareModule 
  
  Module Structures 
    
  EndModule 
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --------v-
; EnableXP