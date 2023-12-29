XIncludeFile "constants.pbi"

; StructureUnion
;   a.a[0]    ; ASCII   : 8 Bit unsigned  [0..255]
;   b.b[0]    ; BYTE    : 8 Bit signed    [-128..127]
;   c.c[0]    ; CAHR    : 2 Byte unsigned [0..65535]
;   w.w[0]    ; WORD    : 2 Byte signed   [-32768..32767]
;   u.u[0]    ; UNICODE : 2 Byte unsigned [0..65535]
;   l.l[0]    ; LONG    : 4 Byte signed   [-2147483648..2147483647]
;   f.f[0]    ; FLOAT   : 4 Byte
;   q.q[0]    ; QUAD    : 8 Byte signed   [-9223372036854775808..9223372036854775807]
;   d.d[0]    ; DOUBLE  : 8 Byte float
;   i.i[0]    ; INTEGER : 4 or 8 Byte INT, depending on System
;   *p.TUPtr[0] ; Pointer for TUPtr (it's possible and it's done in PB-IDE Source) This can be used as a PointerPointer like the C **Pointer
; EndStructureUnion

;-
CompilerIf Not Defined(Structures, #PB_Module)
   DeclareModule Structures
      ;-- PROTOTIPEs
      ; Prototype DrawFunc(*this)
      Prototype EventFunc( ) ;*this=#Null, *event=#PB_All, *item=#PB_Any, *data=#NUL )
      
      ;{
      ;-- STRUCTUREs
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
      ;--     STATE
      Structure _s_STATE
         transform.b
         
         enter.b
         press.b
         hide.b
         focus.b
         disable.b
         ;interact.b
         
         ; check pressed - галочка нажата
         ; check push - проверка нажатия
         ; check create - проверить создание
         ; check redraw - проверка перерисовки     ; redraw state - состояние перерисовки
         ; check drag - проверить перетаскивание
         ; check focus - проверить фокус           ; focus state - состояние фокуса
         ; check state - проверить состояние
         ; check change - проверить изменение
         ; check hided - проверить скрыто
         ; check hidden -  проверить скрытое        ; state hidden - состояние скрыто
         ; check disabled - проверка отключена
         ; check repaint - проверить перекраску
         ; state enter - состояние входа
      EndStructure
      ;--     MODE
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
         check.b
         
         lines.b
         buttons.b
         gridlines.b
         fullselection.b
         collapsed.b
         threestate.b
      EndStructure
      ;--     COUNT
      Structure _s_COUNT
         index.l
         type.l
         items.l
      EndStructure
      Structure _s_ANIMATION
         Value.i
         Min.i
         Max.i
         Delay.i
         Enter.i
         Leave.i
      EndStructure
      ;--     OBJECTTYPE
      Structure _s_OBJECTTYPE
         *root._s_ROOT
         *row._s_ROWS
         *widget._s_WIDGET
         *button._s_BUTTONS
      EndStructure
      ;--     D&D
      Structure _s_DROP
         format.l
         actions.b
         private.i
         
         *imageID
         
         StructureUnion
            string.s
            files.s
         EndStructureUnion
      EndStructure
      Structure _s_DRAG Extends _s_DROP
         y.l
         x.l
         width.l
         height.l
         state.b
         *cursor
      EndStructure
      ;--     MOUSE
      Structure _s_MOUSE Extends _s_POINT
         *cursor                 ; current visible cursor
         press.b                 ;
         interact.b              ; TEMP determines the behavior of the mouse in a clamped (pushed) state
         change.b                ; mouse moved state
         click.a                 ; mouse clicked count
         buttons.a               ; mouse clicked button
         wheel._s_POINT          ;
         delta._s_POINT          ;
         *drag._s_DRAG           ;
         *transform._s_TRANSFORM ;
         entered._s_OBJECTTYPE   ; mouse entered element
         pressed._s_OBJECTTYPE   ; mouse button's pushed element
         leaved._s_OBJECTTYPE    ; mouse leaved element
      EndStructure
      ;--     KEYBOARD
      Structure _s_KEYBOARD ; Ok
         *window._S_WIDGET  ; active window element ; GetActive( )\
         *widget._S_WIDGET  ; keyboard focus element ; FocusedWidget( )\
         change.b
         input.c
         key.l[2]
      EndStructure
      ;--     COLOR
      Structure _s_COLOR
         state.b ; entered; selected; disabled;
         front.l[4]
         line.l[4]
         fore.l[4]
         back.l[4]
         frame.l[4]
         _alpha.a[2]
         *alpha._s_color
      EndStructure
      
      ;--     ALIGN
      Structure _s_ALIGN Extends _s_COORDINATE
         left.b
         top.b
         right.b
         bottom.b
         autodock._s_COORDINATE
      EndStructure
      
      ;--     ARROW
      Structure _s_ARROW
         size.a
         type.b
         direction.b
      EndStructure
      
      ;--     BUTTONS
      Structure _s_BUTTONS Extends _s_COORDINATE
         noFocus.a
         checkstate.b
         
         size.l
         round.a
         
         state._s_state
         arrow._s_arrow
         color._s_color[4]
      EndStructure
      
      ;--     CARET
      Structure _s_CARET Extends _s_COORDINATE
         mode.i
         ;direction.b
         
         pos.l[3]
         time.l
         
         change.b
      EndStructure
      
      ;--     edit
      Structure _s_edit Extends _s_COORDINATE
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
      
      ;--     TEXT
      Structure _s_TEXT Extends _s_edit
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
         
         edit._s_edit[4]
         caret._s_caret
         syntax._s_syntax
         
         ; short._s_edit ; ".."
         ; short._s_text ; сокращенный текст
         
         rotate.f
         align._s_align
         padding._s_point
      EndStructure
      
      ;--     image
      Structure _s_image Extends _s_COORDINATE
         *id  ; - ImageID( )
         *img ; - Image( )
         
         ;;*output;transparent.b
         change.b
         depth.a
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
      
      ;--     TRANSFORM
      Structure _s_A_BUTTONS Extends _s_COORDINATE
         color._s_color[4]
      EndStructure
      Structure _s_A_GROUP Extends _s_COORDINATE
         *widget._s_WIDGET
      EndStructure
      Structure _s_TRANSFORM
         index.b
         *widget._s_WIDGET[3] ; a_main[0] ; a_entered[1] ; a_focused[2]
         
         List *group._s_A_GROUP( )
         
         *type
         *grab ; grab image handle
         
         *grid_image
         grid_size.l
         grid_type.l
         *grid_widget
         
         dot_ted.l
         dot_line.l
         dot_space.l
         
         cursor.i[constants::#__a_count + 1]
         id._s_A_BUTTONS[constants::#__a_count + 1]
      EndStructure
      ;--     ANCHORS
      Structure _s_ANCHORS
         index.b
         pos.l
         size.l
         mode.i
         *id._s_A_BUTTONS[constants::#__a_moved + 1]
      EndStructure
      
      ;;--     margin
      Structure _s_margin Extends _s_coordinate
         color._s_color
         hide.b
      EndStructure
      
      ;--     TAB
      Structure _s_TAB
         *widget._s_WIDGET
         index.i
         change.b
         
         ; tab
         *entered._s_rows
         *pressed._s_rows
         *focused._s_rows
      EndStructure
      
      ;--     TABS
      Structure _s_TABS Extends _s_coordinate
         index.l  ; Index of new list element
         
         
         visible.b
         round.a ; ?-
         
         ;hide.b
         state._s_state
         text._s_text
         image._s_image
         color._s_color
         
         OffsetMove.i
         OffsetMoveMin.i
         OffsetMoveMax.i
         
      EndStructure
      
      ;--     ROWS
      Structure _s_ROWS Extends _s_TABS
         childrens.w ; Row( )\ ; rows( )\ ; row\
         
         checkbox._s_buttons ; \box[1]\ -> \checkbox\
         buttonbox._s_buttons ; \box[0]\ -> \button\ -> \collapsebox\
         
         
         *parent._s_rows
         
         *first._s_rows           ;TEMP first elemnt in the list
         *after._s_rows           ;TEMP first elemnt in the list
         *before._s_rows          ;TEMP first elemnt in the list
         *last._s_rows            ; if parent - \last\child ; if child - \parent\last\child
         
         *OptionGroupRow._s_rows ; option group row
         
         ; edit
         margin._s_edit
         
         *data  ; set/get item data
         sublevel.w
      EndStructure
      
      Structure _s_VISIBLEITEMS
         *first._s_rows           ; first draw-elemnt in the list
         *last._s_rows            ; last draw-elemnt in the list
         List *_s._s_rows( )      ; all draw-elements
      EndStructure
      
      ;--     ROW
      Structure _s_ROW
         index.i
         
         column.a
         sublevelcolumn.a
         sublevelpos.a
         sublevelsize.a
         
         clickselect.b
         multiselect.b
         
         *focused._s_rows         ; focused item
         *pressed._s_rows         ; pushed item
         *entered._s_rows         ; entered item
         *leaved._s_rows          ; leaved item
         
         *first._s_rows           ; first elemnt in the list
         *last._s_rows            ; last elemnt in the list
         *added._s_rows           ; last added last element
         
         visible._s_VISIBLEITEMS
         
         margin._s_margin
         
         *tt._s_tt
         
         ;box._s_buttons
         ;List _s._s_rows( )
         
      EndStructure
      
      ;--     BAR
      Structure _s_PAGE
         pos.l
         len.l
         *end
         change.w
      EndStructure
      Structure _S_THUMB Extends _s_BUTTONS
         pos.l
         len.l
         *end
         change.w
      EndStructure
      Structure _s_BAR
         max.l
         min.l[3]   ; fixed min[1&2] bar size
         fixed.l[3] ; fixed bar[1&2] position (splitter)
         
         invert.b
         vertical.b
         
         percent.f
         direction.l
         
         page._s_page
         area._s_page
         thumb._s_thumb
         
         *button._s_buttons[3]
         
         List *_s._s_tabs( )
         List *draws._s_tabs( )
      EndStructure
      
      ;--     SCROLL
      Structure _s_SCROLL Extends _s_COORDINATE
         bars.b
         align._s_align
         ;padding.b
         
         state.b    ; set state status
         
         increment.f      ; scrollarea
         *v._s_WIDGET     ; vertical scrollbar
         *h._s_WIDGET     ; horizontal scrollbar
      EndStructure
      
      ;--     caption
      Structure _s_caption
         y.l[5]
         x.l[5]
         height.l[5]
         width.l[5]
         
         button._s_buttons[5]
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
      
      ;--     COLUMN
      Structure _s_COLUMN Extends _s_COORDINATE
         index.i
         
         text._s_TEXT
         image._s_image
         
         List items._s_rows( )
      EndStructure
      
      ;--     BOUNDS
      Structure _s_BOUNDATTACH
         mode.a
         *parent._s_WIDGET
      EndStructure
      Structure _s_BOUNDMOVE
         min._s_POINT
         max._s_POINT
      EndStructure
      Structure _s_BOUNDSIZE
         min._s_SIZE
         max._s_SIZE
      EndStructure
      Structure _s_BOUNDS
         children.b
         *move._s_BOUNDMOVE
         *size._s_BOUNDSIZE
         *attach._s_BOUNDATTACH
      EndStructure
      
      ;--     EVENT
      Structure _s_EVENTDATA
         *widget._s_ROOT   ; eventWidget( )
         *type             ; eventType( )
         *item             ; eventItem( )
         *data             ; eventData( )
      EndStructure
      Structure _s_EVENT Extends _s_EVENTDATA
         *function.EventFunc
      EndStructure
      
      ;--     WIDGET
      Structure _s_WIDGET
         *anchors._s_ANCHORS
         
         ;
         type.b
         round.a                ; drawing round
         container.b            ; is container
         ; container = 1        ; if the has children ( Window( ); MDI( ); Panel( ); Container( ); ScrollArea( ) )
         ; container = - 1      ; if the not has children ( Splitter( ); Frame( ))
         haschildren.l          ; if the has children
         child.b                ; is the widget composite?
         
         ;
         state._s_STATE
         create.b
         hide.b                 ;
         hidden.b               ; hide state
         dragstart.b
         checkstate.b
         autosize.b
         
         change.l
         resize.i                 ; state
         
         ;*Draw.DrawFunc          ; Function to Draw
         caption._s_caption
         
         
         fs.a[5]                  ; frame size; [1] - inner left; [2] - inner top; [3] - inner right; [4] - inner bottom
         bs.a                     ; border size
         
         tt._s_tt                 ; notification = уведомление
         *drop._s_DROP
         *align._s_ALIGN
         
         *bar._s_BAR
         *row._s_ROW              ; multi-text; buttons; lists; - gadgets
         
         tab._s_TAB
         
         
         *statebox._s_BUTTONS     ; checkbox; optionbox
         *buttonbox._s_BUTTONS    ; combobox
         
         *popupbox._s_WIDGET      ; = ComboBox( ) list view box
         *groupbox._s_WIDGET      ; = Option( ) group widget
         *stringbox._s_WIDGET     ; = SpinBar( ) string box
                                     
         
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
         first._s_OBJECTTYPE
         after._s_OBJECTTYPE
         before._s_OBJECTTYPE
         last._s_OBJECTTYPE
         
         bounds._s_BOUNDS
         scroll._s_SCROLL            ; vertical & horizontal scrollbars
         
         
         text._s_TEXT
         count._s_COUNT
         
         
         *gadget._s_WIDGET[3]
         ; \root\gadget[0] - active gadget
         ; \gadget[0] - window active child gadget
         ; \gadget[1] - splitter( ) first gadget
         ; \gadget[2] - splitter( ) second gadget
         
         *index[4]
         ; \index[0] - widget index
         ;
         ; \index[1] - panel opened tab index     - OpenedTabIndex( )
         ; \index[2] - panel selected item index  - FocusedTabIndex( )
         ;
         ; \index[1] - splitter is first gadget   - splitter_is_gadget_1( )
         ; \index[2] - splitter is second gadget  - splitter_is_gadget_2( )
         ;
         ; \index[1] - edit entered line index    - EnteredLineIndex( )
         ; \index[2] - edit focused line index    - FocusedLineIndex( )
         ; \index[3] - edit pressed line index    - PressedLineIndex( )
         
         image._s_image[4]
         ; \image[0] - draw image
         ; \image[1] - released image
         ; \image[2] - pressed image
         ; \image[3] - background image
         
         flag.q
         *data
         *cursor[4]
         
         level.l
         class.s
         
         
         *errors
         notify.l ; оповестить об изменении
         
         mode._s_mode            ; drawing mode
         color._s_color[4]
         
         List columns._s_column( )
         List *events._s_EVENT( )
         event.b
         eventmask.q
         
         *root._s_ROOT
         *window._s_WIDGET
         *parent._s_WIDGET
         *address                 ; widget( )\ list address
         main.b                   ; is root
      EndStructure
      
      ;--     CANVAS
      Structure _s_CANVAS
         drawing.q                 ;
         repaint.b
         *fontID                  ; current drawing fontID
         *gadgetID                ; canvas handle
         window.i                 ; canvas window
         gadget.i                 ; canvas gadget
      EndStructure
      
      ;--     ROOT
      Structure _s_ROOT Extends _s_WIDGET
         repaint.b
         *widget._s_WIDGET
         canvas._s_canvas
         List *children._s_WIDGET( ) ; widget( )\
      EndStructure
      
      ;--     STICKY
      Structure _s_STICKY
         *box._s_ROOT                  ; popup root element
         *message._s_WIDGET            ; message window element
         *tooltip._s_WIDGET            ; tool tip element
         *window._s_ROOT               ; top level window element
      EndStructure
      
      ;--     STRUCT
      Structure _s_STRUCT
         repaint.b
         drawing.b                      ;
         
         *drawingIMG
         
         *opened._s_WIDGET             ; last-list opened element
         
         *widget._s_WIDGET             ; enumerate widget
         *root._s_ROOT                 ; enumerate root
         
         mouse._s_mouse                ; mouse( )\
         keyboard._s_keyboard          ; keyboard( )\
         sticky._s_STICKY              ; sticky( )\
         event._s_EVENTDATA            ; widgetEvent( )\ 
         
         List *children._s_WIDGET( )  ; post events list
         List *events._s_EVENTDATA( )  ; post events list
         Map *roots._s_ROOT( )   
         
         ;\\ event\
         quit.b ; quit from main loop
         loop.b
         repost.b
         
         ;;*main._s_ROOT 
      EndStructure
      
      ;Global *event._s_events = Allocatestructure(_s_events)
      ;}
      
      ;Debug SizeOf(_s_WIDGET) ; 5952 - cursor 5924 - color 3924
   EndDeclareModule
   
   Module Structures
      
   EndModule
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 739
; FirstLine = 623
; Folding = ---PP7X+--
; EnableXP