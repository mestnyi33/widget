XIncludeFile "constants.pbi"

;-
CompilerIf Not Defined(Structures, #PB_Module)
  DeclareModule Structures
    Prototype pFunc( )
    
    ;{ 
    ;--     POINT
    Structure _s_POINT
      y.l
      x.l
    EndStructure
    ;--     SIZE
    Structure _s_SIZE
      width.l
      height.l
    EndStructure
    ;--     COORDINATE
    Structure _s_COORDINATE Extends _s_SIZE
      y.l
      x.l
    EndStructure
    ;--     POSITION
    Structure _s_POSITION
      *left
      *top
      *right
      *bottom
    EndStructure
    ;--     STATE
    Structure _s_STATE
      *flag           ; & normal; entered; selected; disabled
      hide.b          ; panel childrens real hide state
      disable.b
      
      enter.b
      press.b
      focus.b
      drag.b
      
      change.b
      move.b
      size.b
      
      repaint.b
      click.b
      
      create.b
    EndStructure
    ;--     COUNT
    Structure _s_COUNT
      index.l
      type.l
      items.l
      events.l
      parents.l
      childrens.l
    EndStructure
    ;--     OBJECTTYPE
    Structure _s_OBJECTTYPE
      *root._s_ROOT
      *row._s_ROWS
      *widget._s_WIDGET
      *button._s_BUTTONS
    EndStructure
    ;--     D&D
    Structure _s_DD Extends _s_COORDINATE
      format.i
      actions.i
      privatetype.i
      
      *value
      string.s
    EndStructure
    ;--     MOUSE
    Structure _s_MOUSE ; Extends _s_POINT
      y.l[3]
      x.l[3]
      
      change.b                   ; if moved mouse this value #true
      buttons.l                  ; 
      
      wheel._s_POINT
      delta._s_POINT
      
      entered._s_OBJECTTYPE      ; mouse entered element
      pressed._s_OBJECTTYPE      ; mouse button's pushed element
      leaved._s_OBJECTTYPE       ; mouse leaved element
      
      *drag._s_DD
      *_transform._s_transform
      
      
      cursor.l                   ; ????????????
      ;area._s_COORDINATE         ; cursor tracking area - область отслеживания курсора
      interact.b                 ; TEMP determines the behavior of the mouse in a clamped (pushed) state
    EndStructure
    ;--     KEYBOARD
    Structure _s_KEYBOARD ; Ok
      *window._s_WIDGET          ; active window element ; GetActive( )\
      focused._s_OBJECTTYPE      ; keyboard focus element
      change.b
      input.c
      key.i[2]
    EndStructure
    ;--     COLOR
    Structure _s_COLOR
      state.b ; entered; selected; disabled;
      front.i[4]
      line.i[4]
      fore.i[4]
      back.i[4]
      frame.i[4]
      _alpha.a[2]
      *alpha._s_color
    EndStructure
    
    ;--     align
    Structure _s_align 
      width.l
      height.l
      delta._s_coordinate             
      anchor._s_position ; align the anchor to the left;right;top;bottom
      auto._s_position
      indent._s_position
    EndStructure
    
    ;--     arrow
    Structure _s_ARROW
      size.a
      type.b
      direction.b
    EndStructure
    
    ;--     page
    Structure _s_page
      pos.l
      len.l
      *end
      change.w
    EndStructure
    
    ;--     caret
    Structure _s_caret Extends _s_coordinate
      direction.b
      
      pos.l[4]
      time.l
      
      
      line.l[2]
      change.b
    EndStructure
    
    ;--     edit
    Structure _s_edit Extends _s_coordinate
      pos.l
      len.l
      
      string.s
      change.b
      
      *color._s_color
    EndStructure
    
    ;--     syntax
    Structure _s_syntax
      List *word._s_edit( )
    EndStructure
    
    ;--     text
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
    
    ;--     image
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
    
    ;     ;--     anchor
    ;     structure _s_anchor extends _s_coordinate
    ;       round.a
    ;       *cursor
    ;       color._s_color;[4]
    ;     Endstructure
    ;--     buttons
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
    
    ;     ;--     button
    ;     structure _s_button 
    ;       pushed.l
    ;       entered.l
    ;       id._s_buttons[3]
    ;     Endstructure
    
    ;--     margin
    Structure _s_margin Extends _s_coordinate
      color._s_color
      hide.b
    EndStructure
    
    ;--     tabs
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
    
    ;--     rows
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
    ;--     row
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
      box._s_buttons           ; editor - edit rectangle
      
    EndStructure
    
    ;--     column
    Structure _s_column Extends _s_coordinate
      
    EndStructure
    
    ;--     bar
    Structure _s_bar
      *widget._s_WIDGET
      
      fixed.l ; splitter fixed button index  
              ;;mode.i ;;; temp
      
      max.l
      min.l[3]
      
      percent.f
      invert.b
      direction.l
      
      page._s_page
      area._s_page
      thumb._s_page  
      *button._s_buttons[4]
      
      List *_s._s_tabs( )
      List *draws._s_tabs( )
    EndStructure
    
    ;--     dotted
    Structure _s_dotted
      ;draw.b
      dot.l
      line.l
      space.l
    EndStructure
    
    ;--     grid
    Structure _s_grid
      *widget
      *image
      size.l
      type.l
    EndStructure
    ; multi group
    Structure _s_group Extends _s_coordinate
      *widget._s_WIDGET
    EndStructure
    ;--     anchors
    Structure _s_transform
      *main._s_WIDGET
      *widget._s_WIDGET
      *_a_widget._s_WIDGET
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
    
    ;--     mode
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
    
    ;--     caption
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
    
    ;--     line_
    Structure _s_line_
      v._s_coordinate
      h._s_coordinate
    EndStructure
    
    ;--     tt
    Structure _s_tt Extends _s_coordinate
      window.i
      gadget.i
      
      visible.b
      
      text._s_text
      image._s_image
      color._s_color
    EndStructure
    
    ;--     scroll
    Structure _s_scroll Extends _s_coordinate
      align._s_align
      ;padding.b
      
      state.b    ; set state status
     
      increment.f      ; scrollarea
      *v._s_WIDGET     ; vertical scrollbar
      *h._s_WIDGET     ; horizontal scrollbar
    EndStructure
    
    ;--     popup
    Structure _s_popup
      gadget.i
      window.i
      
      ; *widget._s_WIDGET
    EndStructure
    
    
    ;     ;--     items
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
    ;--     eventdata
    Structure _s_eventdata
      *back.pFunc ; temp
      
      *id
      
      *pFunc.pFunc
      ; *widget._s_WIDGET
      *type ; eventType( )
      *item ; eventItem( )
      *data ; eventdata( )
    EndStructure
    
    ;--     BIND 
    Structure _s_eventbind 
      *func.pFunc
      List *type( )
    EndStructure
    
    ;--     event
    Structure _s_event ; extends _s_eventdata
      List *call._s_eventdata( )
      List *queue._s_eventdata( )
      
      List *post._s_eventdata( ) ; TEMP
      List *_call._s_eventbind( ) ; TEMP
    EndStructure
    
    ;--     TAB
    Structure _s_TAB
      index.i 
      *widget._s_WIDGET
      
      ; tab
      *pressed._s_rows ; _get_bar_active_item_
      *active._s_rows ; _get_bar_active_item_
      *entered._s_rows  ; _get_bar_active_item_
      
      change.b
    EndStructure
    
    ;--     PARENT
    Structure _s_PARENT
      ;*row._s_rowS
      
      *root._s_ROOT     ; this parent root
      *window._s_WIDGET ; this parent window 
      *widget._s_WIDGET
      
    EndStructure
    
    ;--     BOUNDS
    Structure _s_BOUNDMOVE
      min._s_POINT
      max._s_POINT
    EndStructure
    Structure _s_BOUNDSIZE
      min._s_SIZE
      max._s_SIZE
    EndStructure
    Structure _s_BOUNDS
      *move._s_BOUNDMOVE
      *size._s_BOUNDSIZE
    EndStructure
    ;--     attach
    Structure _s_attach Extends _s_coordinate
      mode.a
      parent._s_objecttype
    EndStructure
    
    ;--     WIDGET
    Structure _s_WIDGET
      autosize.b
      *root._s_ROOT     ; TEMP
      *window._s_WIDGET ; TEMP
      
      tab._s_TAB        
      
      *mouse._s_mouse
      state._s_state
      
      *drop._s_dd
      *attach._s_attach
      bounds._s_boundS
      
      _a_mode.i
      _a_transform.b ; add anchors on the widget (to size and move)
      *_a_id_._s_buttons[constants::#__a_moved+1]
      _a_._s_a
      transform.b
      
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
      
      parent._s_PARENT
      *bar._s_bar
      
      ; 
      *position ; ;#PB_List_First; #PB_List_Last
      
      
      *index[3]  
      ; \index[0] - widget index 
      ; \index[1] - panel opened tab index
      ; \index[2] - panel selected item index
      ; \index[1] - tab entered item index
      ; \index[2] - tab selected item index
      
      *address          ; widgets list address
      
      
      *container        ; 
      count._s_count
      
      ;StructureUnion
        *_owner._s_WIDGET; this window owner parent
        *_group._s_WIDGET; = option( ) groupbar gadget  
      ;EndStructureUnion
      
      *_tt._s_tt          ; notification = уведомление
      *_popup._s_WIDGET   ; combobox( ) list-view gadget
      scroll._s_scroll    ; vertical & horizontal scrollbars
      
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
      
      *row._s_row ; multi-text; buttons; lists; - gadgets
      *_box_._s_buttons ; checkbox; optionbox
      
      *combo_list._s_WIDGET
      
      *align._s_align
      
      *time_click
      *time_down
      *time
      
      *event._s_event
      events._s_eventdata ;?????????
      
      List *column._s_column( )
    EndStructure
    ;--     CANVAS
    Structure _s_CANVAS
      *ResizeBeginWidget._s_WIDGET
      *ResizeEndWidget._s_WIDGET
      
      *cursor             ; current visible cursor
      *fontID             ; current drawing fontid
      *address            ; root list address
      
      window.i            ; canvas window
      gadget.i            ; canvas gadget
      container.i         ; 
      
      repaint.b
      postevent.b         ; post evet canvas repaint
      bindevent.b         ; bind canvas event
      
      List *child._s_WIDGET( )    ; widget( )\
      event._s_eventdata   ; 
      List *events._s_eventdata( )    ; 
    EndStructure
    
    ;--     sticky
    Structure _s_sticky
      *widget._s_WIDGET  ; popup gadget element
      *window._s_WIDGET  ; top level window element
      *message._s_WIDGET ; message window element
      *tooltip._s_WIDGET ; tool tip element
    EndStructure
    
    ;--     ROOT
    Structure _s_ROOT Extends _s_WIDGET
      canvas._s_canvas
    EndStructure
    
    ;--     struct
    Structure _s_struct 
      *drawing
      *action_widget._s_WIDGET
      action_type.s
       
      *opened._s_WIDGET             ; last list opened element
      *closed._s_WIDGET             ; last list opened element
       
      *root._s_ROOT       ; 
      Map *roots._s_ROOT( )         ; 
      mouse._s_mouse                ; mouse( )\
      keyboard._s_keyboard          ; keyboard( )\
      sticky._s_sticky              ; sticky( )\
      
      *widget._s_WIDGET             ; eventwidget( )\ 
      event._s_eventdata            ; widgetevent( )\ ; \type ; \item ; \data
      
      
      ; для совместимости
      List *_root._s_ROOT( )        ; 
      List *_address._s_WIDGET( )   ; widget( )\
    EndStructure
    
    ;Global *event._s_events = Allocatestructure(_s_events)
    ;}
    
  EndDeclareModule 
  
  Module Structures 
    
  EndModule 
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --------8-
; EnableXP