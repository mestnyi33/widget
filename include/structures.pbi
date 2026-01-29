XIncludeFile "constants.pbi"

; StructureUnion
;   b.b[0]    ; BYTE    : 8 Bit signed    [-128..127]
;   a.a[0]    ; ASCII   : 8 Bit unsigned  [0..255]
;
;   w.w[0]    ; WORD    : 2 Byte signed   [-32768..32767]
;   c.c[0]    ; CAHR    : 2 Byte unsigned [0..65535]
;   u.u[0]    ; UNICODE : 2 Byte unsigned [0..65535]
;
;   l.l[0]    ; LONG    : 4 Byte signed   [-2147483648..2147483647]
;   q.q[0]    ; QUAD    : 8 Byte signed   [-9223372036854775808..9223372036854775807]
;
;   f.f[0]    ; FLOAT   : 4 Byte
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
         Y.l
         X.l
      EndStructure
      ;--     SIZE
      Structure _s_SIZE
         Width.l
         Height.l
      EndStructure
      ;--     COORDINATE
      Structure _s_COORDINATE Extends _s_SIZE
         X.l
         Y.l
      EndStructure
;       ;--     FRAME
;       Structure _s_FRAME Extends _s_COORDINATE
;          size.c                   ; 2 Byte unsigned [0..65535]
;          border.c                 ; 2 Byte unsigned [0..65535]
;                                   ;
;          left.a
;          top.a
;          right.a
;          bottom.a
;       EndStructure
      ;--     RESIZEINFO
      Structure _s_RESIZEINFO Extends _s_COORDINATE
         change.b
         minimize.b
         maximize.b
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
         optionboxes.b
         checkboxes.b
         
;          StructureUnion
;             check.b
;          EndStructureUnion
         AlwaysSelection.b
         
         
         lines.b
         buttons.b
         gridLines.b
         fullSelection.b
         clickSelect.b
         multiSelect.b
         collapsed.b
         threeState.b
      EndStructure
      Structure _s_ANIMATION
         Value.i
         Min.i
         Max.i
         Delay.i
         Enter.i
         Leave.i
      EndStructure
      ;--     D&D
      Structure _s_DROP
         format.l
         actions.b
         private.i
         
         *imageID
         
         StructureUnion
            String.s
            files.s
         EndStructureUnion
         
         *value
      EndStructure
      Structure _s_DROPMOUSE Extends _s_DROP
         Y.l
         X.l
         Width.l
         Height.l
      EndStructure
      ;--     KEYBOARD
      Structure _s_KEYBOARD  ; Ok
         *window._S_WIDGET   ; active window element ; FocusedWindow( )\
         *widget._S_WIDGET   
         
         *active._S_WIDGET ; keyboard focus element ; GetActive( )\
         *deactive._S_WIDGET ;
         
         change.b
         input.c
         key.l[2]
      EndStructure
      ;--     COLOR
      Structure _s_COLOR
         state.b ; default=0; entered=1; selected=2; disabled=3;
         front.l[4]
         fore.l[4]
         back.l[4]
         Frame.l[4]
         StructureUnion
            ialpha.a
            _alpha.a
         EndStructureUnion
      EndStructure
      ;--     ALIGN
      Structure _s_ALIGN Extends _s_COORDINATE
         update.b
         left.b
         top.b
         right.b
         bottom.b
         autodock._s_COORDINATE
      EndStructure
      ;--     STATE
      Structure _s_STATE
         font.i
         fontID.i
         
         visible.b
         
         StructureUnion
            checked.b
         EndStructureUnion
         
         StructureUnion
            _enter.b 
            enter.b  
         EndStructureUnion
         StructureUnion
            _focus.b  
            focus.b
         EndStructureUnion
         press.b
         
         round.a
         Hide.b[2]
         Disable.b[2]
      EndStructure
      ;--     BOX
      Structure _s_BOX Extends _s_STATE
         X.l
         Y.l
         Width.l
         Height.l
      EndStructure
      ;--     ARROW
      Structure _s_ARROW
         size.a
         Type.b
         direction.b
      EndStructure
      ;--     BUTTONS
      Structure _s_BUTTONS Extends _s_BOX
         size.w
         color._s_color
         arrow._s_arrow
      EndStructure
      ;--     CAPTION
      Structure _s_caption
         Y.l
         X.l
         Height.l
         Width.l
         
         Button._s_buttons[5]
         color._s_color
         
         interact.b
         Hide.b
         round.b
         _padding.b
      EndStructure
      ;--     CARET
      Structure _s_CARET Extends _s_COORDINATE
         word.s ; слово под кареткой
         pos.i[3]
         
         ; mode.i
         ; time.l
         ; change.b
      EndStructure
      ;--     TEXT
      Structure _s_TEXTINFO Extends _s_COORDINATE
         pos.i
         len.i
         
         String.s
      EndStructure
      Structure _s_EDIT Extends _s_TEXTINFO
         caret._s_caret
      EndStructure
      Structure _s_TEXTITEM Extends _s_TEXTINFO
         change.b
         edit._s_EDIT[3]
      EndStructure
      Structure _s_TEXT Extends _s_TEXTITEM
         editable.b
         ;
         pass$
         pass.b
         
         lower.b
         upper.b
         numeric.b
         multiline.b
         
         invert.b
         vertical.b
         rotate.d
         
         align._s_align
         multistring.s
         
         ; char.c
         ; short._s_EDIT ; ".."
         ; short._s_TEXT ; сокращенный текст
         ;
         ;       ;--     syntax
         ;       Structure _s_syntax
         ;          List *word._s_EDIT( )
         ;       EndStructure
         ; syntax._s_syntax
      EndStructure
      
      ;--     FONTS
      Structure _s_FONTS
         font.i
         key$
         id$
         name.s
         size.a
         style.q
      EndStructure
      
      ;--     IMAGES
      Structure _s_IMAGEs
         *image
         key$
         id$
         file$
         *data
      EndStructure
      
      ;--     PICTURE
      Structure _s_PICTURE Extends _s_COORDINATE
         *image
         *imageID
         change.b 
         rotate.d
         ; vertical.b
         align._s_align
      EndStructure
      
      ;--     SELECTOR
      Structure _s_SELECTOR Extends _s_COORDINATE
         dotted.a
         dotline.a
         dotspace.a
         
         backcolor.i
         framecolor.i
         fontcolor.i
      EndStructure
      ;--     ANCHORS
      Structure _s_ANCHORSGROUP Extends _s_COORDINATE
         show.b
      EndStructure
      Structure _s_ANCHORS
         group._s_ANCHORSGROUP
         
         state.b
         pos.b
         size.a
         mode.a
         *id._s_COORDINATE[constants::#__a_count]
      EndStructure
      ;
      ;--     TRANSFORM
      Structure _s_TRANSFORM 
         group._s_ANCHORSGROUP
         
         Index.a                             ; a_index( )
         *main._s_WIDGET                     ; a_main( )
         *entered._s_WIDGET                  ; a_entered( )
         *focused._s_WIDGET                  ; a_focused( )
         line._s_COORDINATE[4]               ; a_line( )
         
         ;
         cursor.a[constants::#__a_count] ;
                                         ;
         grid_type.l
         *grid_image
         
         backcolor.i[3]
         framecolor.i[3]
      EndStructure
      ;--     MOUSE
      Structure _s_MOUSE Extends _s_POINT
         *cursor                 ; current visible cursor
         
         dragstart.b
         *drop._s_DROPMOUSE           ;
         *drag          ;
         
         Data.w                  ; mouse moved state
         steps.a
         click.a                 ; mouse clicked count
         press.b                 ; mouse buttons state
         press_x.l
         press_y.l
         buttons.a               ; canvas mouse clicked button
         wheeldirection.b
         
         anchors._s_TRANSFORM    ; a_anchors( )
         *selector._s_SELECTOR   ; mouse select frame
         
         
         *button._s_BUTTONS[3]   ;
         *widget._s_WIDGET[3]    ;
      EndStructure
      ;;--     margin
      Structure _s_margin Extends _s_COORDINATE
         color._s_color
         Hide.b
      EndStructure
      
      ;--     ITEMS
      Structure _s_ITEMS Extends _s_BOX
         selector.a  ; selected lines last selector size
         ;separator.b
         
         StructureUnion
            Index.i
            ;_index.i ; row
            lindex.i ; line
            rindex.i ; row
            tindex.i ; tab
            position.i
         EndStructureUnion
         
         change.b
         Drawing.b
         
         ;*columnaddress
         columnindex.u
         
         Text._s_TEXTITEM
         picture._s_PICTURE
         color._s_color
         
         OffsetMove.i
         OffsetMoveMin.i
         OffsetMoveMax.i
         
         *popupbar._s_WIDGET
         StructureUnion
            *_parent._s_ROWS
            *parent._s_ROWS
         EndStructureUnion
         
         childrens.w ; Row( )\ ; rows( )\ ; row\
         sublevel.w
         
         *data  ; set/get item data
      EndStructure
      
      ;--     ROWS
      Structure _s_ROWS Extends _s_ITEMS
         *buttonbox._s_BOX ;  buttonbox\
         *checkBox._s_BOX  ;  checkbox\
         
         ;*_first._s_rows
         ; если их убрать то при клике в примере tree(demo) в чек бокс происходит збой
         ; когда переместил margin._s_EDIT выше *_last._s_rows то снова заработало
         ;          *first._s_rows           ;TEMP first elemnt in the list
         ;          *after._s_rows           ;TEMP first elemnt in the list
         ;          *before._s_rows          ;TEMP first elemnt in the list
         
         ; edit
         margin._s_EDIT
         
         StructureUnion
            *_last._s_rows            ; if parent - \last\child ; if child - \parent\last\child
            *last._s_rows             ; if parent - \last\child ; if child - \parent\last\child
         EndStructureUnion
         
         *_groupbar._s_rows ; option group row
      EndStructure
      
      Structure _s_VISIBLEITEMS
         *first._s_rows           ; first draw-elemnt in the list
         *last._s_rows            ; last draw-elemnt in the list
         List *_s._s_rows( )      ; all draw-elements
      EndStructure
      
      ;--     ROW
      Structure _s_ROW
         state.i
         Index.i
         
         autoscroll.b
         sublevelpos.a
         sublevelsize.a
         
         ;
         *focused._s_rows         ; focused item
         *pressed._s_rows         ; mouse button pushed item
         *entered._s_rows         ; mouse entered item
         *leaved._s_rows          ; mouse leaved item
         
         *first._s_rows           ; first elemnt in the list
         *last._s_rows            ; last elemnt in the list
         *new._s_rows             ; new added last element
         
         visible._s_VISIBLEITEMS
         
         margin._s_margin
         
         *tt._s_tt
      EndStructure
      
      ;--     TAB
      Structure _s_TAB
         state.i;c
         ;Index.u
         Index.l ; add #pb_ignore tab
         
         ; tab
         *entered._s_ITEMS
         *pressed._s_ITEMS
         *focused._s_ITEMS
         
         List *_s._s_ITEMS( )
      EndStructure
      
      ;--     PAGE
      Structure _s_PAGE
        ; change.l
         pos.l
         len.l
         End.l
      EndStructure
      ;--     BAR
      Structure _s_BAR
         change.w;TEMP
         
         max.l
         min.l[3]   ; fixed min[1&2] bar size
         fixed.l[3] ; fixed bar[1&2] position (splitter)
         
         invert.b
         vertical.b
         direction.b
         
         mirror.b 
         ;;; orient.b ; Поддерживаемые ориентации
         
         percent.d
         
         page._s_page
         area._s_page
         thumb._s_page
         
         *button._s_buttons[3]
         
         ; List *_s._s_ITEMS( )
      EndStructure
      ;--     SCROLL
      Structure _s_SCROLL Extends _s_COORDINATE
         bars.b
         
         gadget.i[3]
         increment.d      ; scrollarea
         *v._s_WIDGET     ; vertical scrollbar
         *h._s_WIDGET     ; horizontal scrollbar
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
         
         Text._s_TEXT
         picture._s_PICTURE
         color._s_color
      EndStructure
      
      ;--     POPUP
      Structure _s_POPUP
;          gadget.i
;          window.i
         display.b
         *parent._s_WIDGET
      EndStructure
      
     
      ;--     COLUMN
      Structure _s_COLUMN Extends _s_COORDINATE
         ;index.i
         
         Text._s_TEXT
         picture._s_PICTURE
         
         
         ;--TEMP---
         Drawing.b
         Hide.b
         state.b
         
         ;Map string.s( )
         
         List *items._s_rows( )
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
      
      ;--     WIDGET
      Structure _s_WIDGET Extends _s_STATE
         StructureUnion
            change.b
            textchange.b
         EndStructureUnion
         
         ; transporent.b
         ; dragged.b              ;
         ;
         *errors
         notify.l                   ; оповестить об изменении
         state.l
         lineColor.l
         ChangeColor.b
         deffocus.b ; button default focus
         nofocus.b ; no activate
         
         padding._s_point
         
         
         List *columns._s_column( )
         List __lines._s_rows( )
         ;
         Resize._s_RESIZEINFO                 
         
         bindresize.b
         binddraw.b ; 
         bindcursor.b ; 
         bindclose.b
         
         ; placing layout
         StructureUnion
            Index.i
            createindex.i         ; index widget
         EndStructureUnion
         layer.i               ; z-oreder position
         
         *afterroot._s_ROOT
         *beforeroot._s_ROOT
         *lastroot._s_ROOT
         
         *firstwidget._s_WIDGET
         *afterwidget._s_WIDGET
         *beforewidget._s_WIDGET
         *lastwidget._s_WIDGET
         
         caption._s_caption
         ;
         bs.a                     ; border size
         fs.a[5]                  ; frame size; [1] - inner left; [2] - inner top; [3] - inner right; [4] - inner bottom
         ;frame._s_FRAME
         
         Y.l[constants::#__c]
         X.l[constants::#__c]
         Height.l[constants::#__c]
         Width.l[constants::#__c]
         ;
         Type.w;[2]                
               ; type[0] = createtype
               ; type[1] = grouptype
               ;
         Level.u
         Class.s
         
         autosize.b
         Container.b              ; is container
                                  ; container > 0          ; if the has children ( Root( 1 ); Window( 2 ); MDI( 3 ); Panel( 3 ); Container( 3 ); ScrollArea( 3 ) )
                                  ; container =- 1         ; if the not has children ( Splitter( ); Frame( ))
         
         ;
         child.b                  ; is the widget composite?
         haschildren.l            ; if the has children
         CountItems.l             ; count items
         
         ;                        ;*Draw.DrawFunc          ; Function to Draw
         ;                        ;
         tt._s_tt                 ; notification = уведомление
         *drop._s_DROP
         *align._s_ALIGN
         ;
         *anchors._s_ANCHORS
         ;
         *bar._s_BAR
         *row._s_ROW              ; multi-text; buttons; lists; - gadgets
         Tab._s_TAB               ; 
         
         menu._s_POPUP
         
         ;
         *tabbar._s_WIDGET
         *menubar._s_WIDGET
         *combobar._s_WIDGET      ; = ComboBox( ) popup list view widget
                                  ;
         *groupbar._s_WIDGET      ; = Option( ) group widget
         *stringbar._s_WIDGET     ; = Spin( ) string box widget
         *combobutton._s_BUTTONS  ; combobox button
         *togglebox._s_BOX        ; checkbox; optionbox, ToggleButton
         
         ;                           
         TitleBarHeight.w
         MenuBarHeight.w
         ToolBarHeight.w
         StatusBarHeight.w
         ;
         
         mode._s_mode               ; drawing mode
         bounds._s_BOUNDS
         
         ;
         Flag.q
         *root._s_ROOT
         *window._s_WIDGET
         *parent._s_WIDGET
         *data
         *address         ; widget( )\ list address
         *gadget._s_WIDGET[3]
         ; \root\gadget[0] - active gadget
         ; \gadget[0]     ; window active child gadget
         ; \gadget[1]     ; splitter( ) first gadget
         ; \gadget[2]     ; splitter( ) second gadget
         ;
         *cursor[4]  
         ; \cursor[0]     ; this cursor
         ; \cursor[1]     ; current cursor
         ; \cursor[2]     ; change cursor 1
         ; \cursor[3]     ; change cursor 2
         ;
         picturesize.w        ; icon small/large
         picture._s_PICTURE[4]
         ; \image[0] - draw image
         ; \image[1] - released image
         ; \image[2] - pressed image
         ; \image[3] - background image
         ;
         Text._s_TEXT
         Scroll._s_SCROLL            ; vertical & horizontal scrollbars
         color._s_color[4]
         
      EndStructure
      
      ;--     CANVAS
      Structure _s_CANVAS
         Repaint.b
         bindcursor.b
         enter.b
         window.i                 ; canvas window
         gadget.i                 ; canvas gadget
         *gadgetID                ; canvas handle
      EndStructure
      
      ;--     ROOT
      Structure _s_ROOT Extends _s_WIDGET
         Repaint.b
         drawmode.b
         Canvas._s_canvas
         *active._s_WIDGET
      EndStructure
      
      ;--     STICKY
      Structure _s_STICKY
         *box._s_ROOT                  ; popup root element
         *message._s_WIDGET            ; message window element
         *tooltip._s_WIDGET            ; tool tip element
         *window._s_ROOT               ; top level window element
         *bar._s_ROOT
      EndStructure
      
      ;--     EVENT
      Structure _s_EVENTDATA
         *widget._s_ROOT   ; eventWidget( )
         *type             ; eventType( )
         *item             ; eventItem( )
         *data             ; eventData( )
      EndStructure
      Structure _s_HOOK Extends _s_EVENTDATA
         *function.EventFunc
      EndStructure
      Structure _s_EVENT Extends _s_EVENTDATA
         loop.b
         queuesmask.b
         mask.q
         List *binds._s_HOOk( )
         List *queues._s_EVENTDATA( )  ; __events( )
      EndStructure
      
      ;--     GUI
      Structure _s_GUI
         fontID.i                       ; current drawing fontID
         ;
         *root._s_ROOT                 ; enumerate root
         *drawingroot._s_ROOT
         *opened._s_WIDGET             ; last opened-list element
         *widget._s_WIDGET             ; enumerate widget
         *popup._s_WIDGET
         
         mouse._s_mouse                ; mouse( )\
         keyboard._s_keyboard          ; keyboard( )\
         Sticky._s_STICKY              ; sticky( )\
         event._s_EVENT
         
         Map *__roots._s_ROOT( )   
         List *__widgets._s_WIDGET( )  ; __widgets( )
      EndStructure
      ;}
      
      ;Debug SizeOf(_s_WIDGET) ; 5952 - cursor 5924 - color 3924
   EndDeclareModule
   
   Module Structures
      
   EndModule
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 604
; FirstLine = 458
; Folding = -F59------
; Optimizer
; EnableXP