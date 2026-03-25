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
      Structure _s_ANIMATION
         Min.i
         Max.i
         Value.i
         Delay.i
         Enter.i
         Leave.i
      EndStructure
      ;--     MODE
      Structure _s_mode
         optionboxes.b
         checkboxes.b
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
      ;--     SIZE
      Structure _s_SIZE
         Width.l
         Height.l
      EndStructure
      ;--     POINT
      Structure _s_POINT
         Y.l
         X.l
      EndStructure
      ;--     COORDINATE
      Structure _s_COORDINATE Extends _s_SIZE
         X.l
         Y.l
      EndStructure
      ;--     RESIZEINFO
      Structure _s_RESIZEINFO Extends _s_COORDINATE
         change.b
         minimize.b
         maximize.b
      EndStructure
      ;--     D&D
      Structure _s_DROP
         format.l
         private.i
         *imageID
         StructureUnion
            str$
            files.s
         EndStructureUnion
         actions.b
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
         front.l[4]
         fore.l[4]
         back.l[4]
         Frame.l[4]
         state.b ; default=0; entered=1; selected=2; disabled=3;
         StructureUnion
            ialpha.a
            _alpha.a
         EndStructureUnion
      EndStructure
      ;--     ALIGN
      Structure _s_ALIGN Extends _s_COORDINATE
         autodock._s_COORDINATE
         update.b
         left.b
         top.b
         right.b
         bottom.b
      EndStructure
      ;--     STATE
      Structure _s_ROWSTATE
         font.i
         fontID.i
         
          press.b
          visible.b
          checked.b
         
         StructureUnion
            _enter.b 
            enter.b  
         EndStructureUnion
         StructureUnion
            _focus.b  
            focus.b
         EndStructureUnion
         
         Hide.b[2]
         Disable.b[2]
         round.a
      EndStructure
      
      ;--     BOX
      Structure _s_BOX Extends _s_ROWSTATE
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
         color._s_color
         arrow._s_arrow
         size.w
      EndStructure
      ;--     CAPTION
      Structure _s_caption Extends _s_COORDINATE
         Button._s_buttons[5]
         color._s_color
         
         interact.b
         Hide.b
         round.b
         _padding.b
      EndStructure
      ;--     CARET
      Structure _s_CARET Extends _s_COORDINATE
         pos.i[3]
         word.s ; слово под кареткой
         
         ; mode.i
         ; time.l
         ; change.b
      EndStructure
      ;--     TEXT
      Structure _s_TEXTINFO Extends _s_COORDINATE
         pos.i
         len.i
         ;String.s
         Array str.s(0) 
      EndStructure
      Structure _s_EDIT Extends _s_TEXTINFO
         caret._s_caret
      EndStructure
      Structure _s_TEXTITEM Extends _s_TEXTINFO
         edit._s_EDIT[3]
         change.b
      EndStructure
    
      Structure _s_TEXT Extends _s_TEXTITEM
         mode.a    
         
         multiline.b
         invert.b
         vertical.b
         rotate.d
         
         align._s_align
         
         string$ 
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
         key$
         id$
         name.s
         size.a
         font.i
         style.q
      EndStructure
      
      ;--     IMAGES
      Structure _s_IMAGEs
         key$
         id$
         file$
         *data
         *image
      EndStructure
      
      ;--     PICTURE
      Structure _s_PICTURE Extends _s_COORDINATE
         align._s_align
         *image
         *imageID
         change.b 
         rotate.d
      EndStructure
      
      ;--     SELECTOR
      Structure _s_SELECTOR Extends _s_COORDINATE
         backcolor.i
         framecolor.i
         fontcolor.i
         dotted.a
         dotline.a
         dotspace.a
      EndStructure
      ;--     ANCHORS
      Structure _s_ANCHORSGROUP Extends _s_COORDINATE
         show.b
      EndStructure
      Structure _s_ANCHORS
         *id._s_COORDINATE[constants::#__a_count]
         group._s_ANCHORSGROUP
         
         state.b
         pos.b
         size.a
         mode.a
      EndStructure
      ;
      ;--     TRANSFORM
      Structure _s_TRANSFORM 
         Index.a                             ; a_index( )
         cursor.a[constants::#__a_count] ;
         grid_type.l
         backcolor.i[3]
         framecolor.i[3]
         *grid_image
         *main._s_WIDGET                     ; a_main( )
         *entered._s_WIDGET                  ; a_entered( )
         *focused._s_WIDGET                  ; a_focused( )
         line._s_COORDINATE[4]               ; a_line( )
         group._s_ANCHORSGROUP
      EndStructure
      ;--     MOUSE
      Structure _s_MOUSE Extends _s_POINT
         mask.q 
         click.a                 ; mouse clicked count
         buttons.a               ; canvas mouse clicked button
         wheeldirection.b
         steps.a
         
         press._s_POINT
         anchors._s_TRANSFORM    ; a_anchors( )
         
         *drag                   ;
         *cursor                 ; current visible cursor
         
         *selector._s_SELECTOR   ; mouse select frame
         *drop._s_DROPMOUSE           ;
         *button._s_BUTTONS[3]   
         *widget._s_WIDGET[3]    
         ; widget[0] = Leaved( ) - Returns mouse leaved widget
         ; widget[1] = Entered( ) - Returns mouse entered widget
         ; widget[2] = Pressed( ) - Returns mouse button pushed widget
      EndStructure
      ;;--     margin
      Structure _s_margin Extends _s_COORDINATE
         color._s_color
         Hide.b
      EndStructure
      
      ;--     ITEMS
      Structure _s_ITEMS Extends _s_BOX
         StructureUnion
            Index.i
            lindex.i ; line
            rindex.i ; row
            tindex.i ; tab
         EndStructureUnion
         OffsetMove.i
         OffsetMoveMin.i
         OffsetMoveMax.i
         
         
         selector.a  ; selected lines last selector size
         ;separator.b
         
         change.b
         Drawing.b
         
         ;*columnaddress
         columnindex.u
         childrens.w ; Row( )\ ; rows( )\ ; row\
         sublevel.w
         
         Text._s_TEXTITEM
         picture._s_PICTURE
         color._s_color
         
         *popupbar._s_WIDGET
         StructureUnion
            *_parent._s_ROWS
            *parent._s_ROWS
         EndStructureUnion
         
         *data  ; set/get item data
      EndStructure
      
      ;--     ROWS
      Structure _s_ROWS Extends _s_ITEMS
         *buttonbox._s_BOX ;  buttonbox\
         *checkBox._s_BOX  ;  checkbox\
         
         ; edit
         margin._s_EDIT
         
         StructureUnion
            *_last._s_rows            
            *last._s_rows             ; if parent - \last\child ; if child - \parent\last\child
         EndStructureUnion
         
         *_groupbar._s_rows ; option group row
      EndStructure
      
      ;--     COLUMN
      Structure _s_COLUMN Extends _s_COORDINATE
         ;X.l : Width.l 
         ;title.s
         Hide.b
         Text._s_TEXT
         picture._s_PICTURE
       ;  List items._s_rows( )
      EndStructure
      
      Structure _s_COLUMNs
         List columns._s_COLUMN( )
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
         ;
         List items._s_rows( )
         List *eItems._s_rows()   ; Развернутый рулон (указатели)
      EndStructure
      
      ;--     TAB
      Structure _s_TAB
         state.i
         Index.l ; add #pb_ignore tab
         
         ; tab
         *entered._s_ITEMS
         *pressed._s_ITEMS
         *focused._s_ITEMS
         
         List *_s._s_ITEMS( )
      EndStructure
      
      ;--     PAGE
      Structure _s_PAGE
         pos.l
         len.l
         End.l
      EndStructure
      ;--     BAR
      Structure _s_BAR
         max.l
         min.l[3]   ; fixed min[1&2] bar size
         fixed.l[3] ; fixed bar[1&2] position (splitter)
         
         change.w
         
         invert.b
         vertical.b
         direction.b
         
         mirror.b 
         ;;; orient.b ; Поддерживаемые ориентации
         
         percent.f
         
         page._s_page
         area._s_page
         thumb._s_page
         
         *button._s_buttons[3]
      EndStructure
      ;--     SCROLL
      Structure _s_SCROLL Extends _s_COORDINATE
         gadget.i[3]
         bars.b
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
         display.b
         *parent._s_WIDGET
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
      Structure _s_WIDGET 
         ColumnsHeight.i : RowHeight.i : ScrollSize.i
         ScrollV.i : ScrollH.i : State.i
         
         ; Окошко видимости (Указатели)
         *FirstVisibleItem._s_ITEM
         *LastVisibleItem._s_ITEM
         
         ; Наведение
         *HoverItem._s_ITEM
         *HoverColumn._s_COLUMN
         
         ChangeColor.b
         StructureUnion
            change.b
            textchange.b
         EndStructureUnion
         deffocus.b ; button default focus
         enter.b  
         focus.b
         autosize.b
         Hide.b[2]
         Disable.b[2]
         ;
         child.b                  ; is the widget composite?
         Container.b              
         ; container > 0          ; if the has children ( Root( 1 ); Window( 2 ); MDI( 3 ); Panel( 3 ); Container( 3 ); ScrollArea( 3 ) )
         ; container =- 1         ; if the not has children ( Splitter( ); Frame( ))
         
         
         ; border size
         bs.a                     
         fs.a[5]                  
         ; [0] - frame size
         ; [1] - inner left
         ; [2] - inner top
         ; [3] - inner right
         ; [4] - inner bottom
         round.a
         
         ;
         Level.u
         Class.s
         
         ;                           
         TitleBarHeight.w
         MenuBarHeight.w
         ToolBarHeight.w
         StatusBarHeight.w
         picturesize.w        ; icon small/large
         Type.w                
         ;
         
         notify.l                   ; оповестить об изменении
         lineColor.l
         haschildren.l            ; if the has children
         CountItems.l             ; count items
         Y.l[constants::#__c]
         X.l[constants::#__c]
         Height.l[constants::#__c]
         Width.l[constants::#__c]
         ;                        ;*Draw.DrawFunc          ; Function to Draw
         
         font.i
         fontID.i
         ; placing layout
         StructureUnion
            Index.i
            createindex.i         ; index widget
         EndStructureUnion
         layer.i               ; z-oreder position
         
         mask.q 
         flagmask.q
         eventmask.q
         
         tt._s_tt                 ; notification = уведомление
         Tab._s_TAB               ; 
         menu._s_POPUP
         mode._s_mode               ; drawing mode
         bounds._s_BOUNDS
         area_align._s_align
         Text._s_TEXT
         Scroll._s_SCROLL            ; vertical & horizontal scrollbars
         Resize._s_RESIZEINFO                 
         color._s_COLOR[4]
         padding._s_POINT
         caption._s_caption
         picture._s_PICTURE[4]
         ; \image[0] - draw image
         ; \image[1] - released image
         ; \image[2] - pressed image
         ; \image[3] - background image
         
         ;                        ;
         *bar._s_BAR
         *row._s_ROW              ; multi-text; buttons; lists; - gadgets
         *column._s_COLUMNs             ; multi-text; buttons; lists; - gadgets
         *drop._s_DROP
         *align._s_ALIGN
         *anchors._s_ANCHORS
         *togglebox._s_BOX        ; checkbox; optionbox, ToggleButton
         *combobutton._s_BUTTONS  ; combobox button
         
         *root._s_ROOT
         *afterroot._s_ROOT
         *beforeroot._s_ROOT
         *lastroot._s_ROOT
         
         *tabbar._s_WIDGET
         *menubar._s_WIDGET
         *combobar._s_WIDGET      ; = ComboBox( ) popup list view widget
         *groupbar._s_WIDGET      ; = Option( ) group widget
         *stringbar._s_WIDGET     ; = Spin( ) string box widget
         *firstwidget._s_WIDGET
         *afterwidget._s_WIDGET
         *beforewidget._s_WIDGET
         *lastwidget._s_WIDGET
         *window._s_WIDGET
         *parent._s_WIDGET
         ;
         *gadget._s_WIDGET[3]
         ; \root\gadget[0] - active gadget
         ; \gadget[0]     ; window active child gadget
         ; \gadget[1]     ; splitter( ) first gadget
         ; \gadget[2]     ; splitter( ) second gadget
         ;
         *data
         *address         ; widget( )\ list address
         *cursor[4]  
         ; \cursor[0]     ; this cursor
         ; \cursor[1]     ; current cursor
         ; \cursor[2]     ; change cursor 1
         ; \cursor[3]     ; change cursor 2
         
       
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
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 295
; FirstLine = 279
; Folding = ---0--4---
; Optimizer
; EnableXP