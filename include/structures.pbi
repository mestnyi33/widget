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
         Y.l
         X.l
      EndStructure
      ;--     RESIZEINFO
      Structure RESIZEINFO Extends _s_COORDINATE
         flag.c
         clip.b
         Send.b
         change.b
         nochildren.b
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
         
         StructureUnion
            check.b
         EndStructureUnion
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
;       ;--     OBJECTTYPE
;       Structure _s_OBJECTTYPE
;          *root._s_ROOT
;          ;*row._s_ROWS
;          ;*widget._s_WIDGET
;          ;*button._s_BUTTONS
;       EndStructure
      ;--     D&D
      Structure _s_DROP
         format.l
         actions.b
         private.i
         
         *imageID
         
         ;*value
         StructureUnion
            String.s
            files.s
         EndStructureUnion
         
         *value
      EndStructure
      Structure _s_DRAG Extends _s_DROP
         Y.l
         X.l
         Width.l
         Height.l
      EndStructure
      ;--     KEYBOARD
      Structure _s_KEYBOARD ; Ok
         *window._S_WIDGET  ; active window element ; FocusedWindow( )\
         *widget._S_WIDGET  ; keyboard focus element ; GetActive( )\
         change.b
         input.c
         key.l[2]
      EndStructure
      ;--     COLOR
      Structure _s_COLOR
         state.b ; entered; selected; disabled;
         front.i[4]
         line.i[4]
         fore.i[4]
         back.i[4]
         Frame.i[4]
         _alpha.a
         *alpha._s_color
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
      ;--     ARROW
      Structure _s_ARROW
         size.a
         Type.b
         direction.b
      EndStructure
      ;--     STATE
      Structure _s_STATE
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
      ;--     BUTTONS
      Structure _s_BUTTONS Extends _s_BOX
         size.w
         color._s_color
         arrow._s_arrow
      EndStructure
      
      ;--     CARET
      Structure _s_CARET Extends _s_COORDINATE
         mode.i
         
         pos.l[3]
         time.l
         
         change.b
      EndStructure
      
      ;--     edit
      Structure _s_edit Extends _s_COORDINATE
         pos.l
         len.l
         
         String.s
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
      
      ;--     IMAGE
      Structure _s_image Extends _s_COORDINATE
         StructureUnion
            *id  ; - ImageID( )
            *imageID
         EndStructureUnion
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
      
      ;
      Structure _s_A_GROUP Extends _s_COORDINATE
         *widget._s_WIDGET
      EndStructure
      ;--     SELECTOR
      Structure _s_SELECTOR Extends _s_COORDINATE
         List *group._s_A_GROUP( )
         
         dotted.a
         dotline.a
         dotspace.a
         
         backcolor.i
         framecolor.i
         fontcolor.i
      EndStructure
      ;--     ANCHORS
      Structure _s_ANCHORS
         state.b
         pos.b
         size.a
         mode.a
         *id._s_COORDINATE[constants::#__a_count]
      EndStructure
      ;
      Structure _s_TRANSFORMDATA
      EndStructure
      ;--     TRANSFORM
      Structure _s_TRANSFORM
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
         
         drag.b
         *drop._s_DRAG           ;
         
         Data.w                  ; mouse moved state
         steps.a
         press.b                 ; mouse buttons state
         click.a                 ; mouse clicked count
         buttons.a               ; mouse clicked button
         
         anchors._s_TRANSFORM    ; a_anchors( )
         *selector._s_SELECTOR   ; mouse select frame
         
         wheeldata.w
         wheeldirection.b
         
         *delta._s_POINT         ; 
         
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
         separator.b
         
         itemindex.i
         StructureUnion
            position.i
            Index.i
            _index.i
         EndStructureUnion
         change.b
         Drawing.b
         
         
         
         ;*columnaddress
         columnindex.c
         
         Text._s_text
         Image._s_image
         color._s_color
         
         OffsetMove.i
         OffsetMoveMin.i
         OffsetMoveMax.i
         
         *_menubar._s_WIDGET
         *_parent._s_ROWS
         
         childrens.w ; Row( )\ ; rows( )\ ; row\
         sublevel.w
         
         *data  ; set/get item data
      EndStructure
      
      ;--     ROWS
      Structure _s_ROWS Extends _s_ITEMS
         buttonbox._s_BOX ;  buttonbox\
         CheckBox._s_BOX  ;  checkbox\
         
         
         ; если их убрать то при клике в примере tree(demo) в чек бокс происходит збой
         *first._s_rows           ;TEMP first elemnt in the list
         *after._s_rows           ;TEMP first elemnt in the list
         *before._s_rows          ;TEMP first elemnt in the list
         
         *_last._s_rows            ; if parent - \last\child ; if child - \parent\last\child
         
         *_groupbar._s_rows ; option group row
         
         ; edit
         margin._s_edit
         
         ;*data  ; set/get item data
      EndStructure
      
      Structure _s_VISIBLEITEMS
         *first._s_rows           ; first draw-elemnt in the list
         *last._s_rows            ; last draw-elemnt in the list
         List *_s._s_rows( )      ; all draw-elements
      EndStructure
      
      ;--     ROW
      Structure _s_ROW
         ID.i[4]
         sublevelpos.a
         sublevelsize.a
         ;
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
      EndStructure
      
      ;--     TAB
      Structure _s_TAB
         state.c
         Index.c
         
         ; tab
         *entered._s_ITEMS
         *pressed._s_ITEMS
         *focused._s_ITEMS
         List *_s._s_ITEMS( )
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
         change.w
         *gadget._s_WIDGET[3]
         ; \root\gadget[0] - active gadget bar
         ; \gadget[0] - window active child gadget
         ; \gadget[1] - splitter( ) first gadget
         ; \gadget[2] - splitter( ) second gadget
         
         max.l
         min.l[3]   ; fixed min[1&2] bar size
         fixed.l[3] ; fixed bar[1&2] position (splitter)
         
         invert.b
         vertical.b
         direction.b
         
        ;;; orient.b ; Поддерживаемые ориентации
         
         percent.f
         
         page._s_page
         area._s_page
         thumb._s_thumb
         
         *button._s_buttons[3]
         
         ; List *_s._s_ITEMS( )
      EndStructure
      ;--     SCROLL
      Structure _s_SCROLL Extends _s_COORDINATE
         bars.b
         align._s_align
         
         state.b          ; set state status
         
         gadget.i[3]
         increment.f      ; scrollarea
         *v._s_WIDGET     ; vertical scrollbar
         *h._s_WIDGET     ; horizontal scrollbar
      EndStructure
      
      ;--     caption
      Structure _s_caption
         Y.l;[5]
         X.l;[5]
         Height.l;[5]
         Width.l ;[5]
         
         Button._s_buttons[5]
         color._s_color
         
         interact.b
         Hide.b
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
         
         Text._s_text
         Image._s_image
         color._s_color
      EndStructure
      
      ;--     popup
      Structure _s_popup
         gadget.i
         window.i
         
         ; *widget._s_WIDGET
      EndStructure
      
      
      ;--     COLUMN
      Structure _s_COLUMN Extends _s_COORDINATE
         ;index.i
         
         Text._s_TEXT
         Image._s_image
         
         
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
      
      ;--     EVENT
      Structure _s_EVENTDATA
         *widget._s_ROOT   ; eventWidget( )
         *type             ; eventType( )
         *item             ; eventItem( )
         *data             ; eventData( )
      EndStructure
      Structure _s_HOOK Extends _s_EVENTDATA
         *function.EventFunc
         Map *buttons( )
      EndStructure
      
      ;--     WIDGET
      Structure _s_WIDGET Extends _s_STATE
         ;          Map *eventshook._s_HOOK( )
         ;         
         List __lines._s_rows( )
         deffocus.b ; default focus
         
         haseventhook.b
         ;          *eventhook._s_HOOK[constants::#__event_count]
         ;          ; TEMP
         ;          hashook.b
         ;          List *hook._s_HOOK( ) ; hook of events
         
         
         ReDraw.b
         ;          size.SIZEINFO                 
         ;          move.MOVEINFO                 
         Resize.RESIZEINFO                 
         
         
         Index.i         ; index widget
         
         ; placing layout
         ;place\index
         ;placingindex.i  ; z-oreder position
         *afterroot._s_ROOT
         *beforeroot._s_ROOT
         *lastroot._s_ROOT
         
         *firstwidget._s_WIDGET
         *afterwidget._s_WIDGET
         *beforewidget._s_WIDGET
         *lastwidget._s_WIDGET
         
         Y.l[constants::#__c]
         X.l[constants::#__c]
         Height.l[constants::#__c]
         Width.l[constants::#__c]
         ;
         Type.w[2]                
         ; type[0] = createtype
         ; type[1] = grouptype
         ;
         Level.c
         class.s
         ;
         Create.b
         change.b
                                  ; transporent.b
                                  ; dragged.b              ;
         autosize.b
         Container.b              ; is container
                                  ; container > 0          ; if the has children ( Root( 1 ); Window( 2 ); MDI( 3 ); Panel( 3 ); Container( 3 ); ScrollArea( 3 ) )
                                  ; container =- 1         ; if the not has children ( Splitter( ); Frame( ))
                                  ;
         child.b                  ; is the widget composite?
         haschildren.l            ; if the has children
         CountItems.l             ; count items
                                  ;                        ;*Draw.DrawFunc          ; Function to Draw
         caption._s_caption
         ;
         fs.a[5]                  ; frame size; [1] - inner left; [2] - inner top; [3] - inner right; [4] - inner bottom
         bs.a                     ; border size
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
                                  ;
         *tabbar._s_WIDGET
         *menubar._s_WIDGET
         *popupbar._s_WIDGET
         *groupbar._s_WIDGET      ; = Option( ) group widget
         *stringbar._s_WIDGET     ; = SpinBar( ) string box widget
         
        ; StructureUnion
            *togglebox._s_BOX     ; checkbox; optionbox, ToggleButton
            *button._s_BUTTONS    ; combobox button
        ; EndStructureUnion
         
         displaypopup.b
         ;                           
         TitleBarHeight.w
         MenuBarHeight.w
         ToolBarHeight.w
         StatusBarHeight.w
         ;
         
         *contex
         *errors
         notify.l                   ; оповестить об изменении
         
         mode._s_mode               ; drawing mode
         bounds._s_BOUNDS
         List *columns._s_column( )
         
         
         ;
         flag.q
         *root._s_ROOT
         *window._s_WIDGET
         *parent._s_WIDGET
         *address                   ; widget( )\ list address
         *data
         *gadget._s_WIDGET;[3]
                          ; \root\gadget[0] - active gadget
                          ; \gadget[0] - window active child gadget
                          ; \gadget[1] - splitter( ) first gadget
                          ; \gadget[2] - splitter( ) second gadget
                          ;
         *cursor[4]  
         ; \cursor[0]     ; this cursor
         ; \cursor[1]     ; current cursor
         ; \cursor[2]     ; change cursor 1
         ; \cursor[3]     ; change cursor 2
         Image._s_image[4]
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
         *menu._s_WIDGET
         postrepaint.b
         window.i                 ; canvas window
         gadget.i                 ; canvas gadget
         *gadgetID                ; canvas handle
      EndStructure
      
      ;--     ROOT
      Structure _s_ROOT Extends _s_WIDGET
         repaint.b
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
      
      ;--     STRUCT
      Structure _s_STRUCT
         Map *mapfontID( )  
         
         *fontID                       ; current drawing fontID
         *root._s_ROOT                 ; enumerate root
         *drawingroot._s_ROOT
         *opened._s_WIDGET             ; last opened-list element
         *popup._s_WIDGET              
         *widget._s_WIDGET             ; enumerate widget
         
         mouse._s_mouse                ; mouse( )\
         keyboard._s_keyboard          ; keyboard( )\
         sticky._s_STICKY              ; sticky( )\
         
         Map *_roots._s_ROOT( )   
         List *_widgets._s_WIDGET( )    ; __widgets( )
         
         ;*drawingIMG
         ;List *intersect._s_WIDGET( )
         
         ;\\ event\
         event._s_EVENTDATA                ; __event( )\ 
         eventquit.b                       ; quit from main loop
         eventloop.b
         eventexit.b
         
         Map *eventhook._s_HOOk( )
         List *eventqueue._s_EVENTDATA( )  ; __events( )
      EndStructure
      ;}
      
      ;Debug SizeOf(_s_WIDGET) ; 5952 - cursor 5924 - color 3924
   EndDeclareModule
   
   Module Structures
      
   EndModule
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 615
; FirstLine = 597
; Folding = ----------
; Optimizer
; EnableXP