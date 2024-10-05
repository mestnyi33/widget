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
         
         ;*value
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
         ;state.b
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
         front.l[4]
         line.l[4]
         fore.l[4]
         back.l[4]
         frame.l[4]
         _alpha.a
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
      ;--     STATE
      Structure _s_STATE
         round.a
         
         StructureUnion
            toggle.b[3]
            checked.b[3]
         EndStructureUnion
         state.b
         
         hide.b
         StructureUnion
            enter.b
            mouseenter.b
            mouseenterframe.b
            mouseenterinner.b
         EndStructureUnion
         
         StructureUnion
            focus.b
            _focus.b ; 
         EndStructureUnion
         press.b
         disable.b
      EndStructure
      ;--     BOX
      Structure _s_BOX Extends _s_STATE
         y.l[3]
         x.l[3]
         width.l[3]
         height.l[3]
      EndStructure
      ;--     BUTTONS
      Structure _s_BUTTONS Extends _s_BOX
         index.l     ; Index of new list element
         size.l
         noFocus.a
         arrow._s_arrow
         color._s_color[4]
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
      
      ;--     ANCHORS
      Structure _s_SELECTOR Extends _s_COORDINATE
         type.a
         
         dot_ted.a
         dot_line.a
         dot_space.a
         
         backcolor.i
         framecolor.i
      EndStructure
      ;
      Structure _s_A_BUTTONS Extends _s_COORDINATE
         state.b
      EndStructure
      ;
      Structure _s_ANCHORS
         pos.b;w 
         size.a;c
         mode.a;i
         *id._s_A_BUTTONS[constants::#__a_count]
      EndStructure
      ;
      Structure _s_A_GROUP Extends _s_COORDINATE
         *widget._s_WIDGET
      EndStructure
      ;
      Structure _s_TRANSFORMDATA
         List *group._s_A_GROUP( )
         *grab ; grab image handle
         
         *grid_image
         grid_type.l
         *grid_widget
      EndStructure
      ;--     TRANSFORM
      Structure _s_TRANSFORM
         index.a                             ; a_index( )
         *main._s_WIDGET                     ; a_main( )
         *enter._s_WIDGET                    ; a_entered( )
         *focus._s_WIDGET                    ; a_focused( )
         line._s_A_BUTTONS[4]                ; a_line( )
         
         ;
         cursor.a[constants::#__a_count] ;
                                             ;
         *transform._s_TRANSFORMDATA         ;
         
         backcolor.l[3]
         framecolor.l[3]
      EndStructure
      ;--     MOUSE
      Structure _s_MOUSE Extends _s_POINT
         *cursor                 ; current visible cursor
         
         click.a                 ; mouse clicked count
         change.b                ; mouse moved state
         buttons.a               ; mouse clicked button
         dragstart.b
         
         interact.b              ; TEMP determines the behavior of the mouse in a clamped (pushed) state
         
         steps.a
         anchors._s_TRANSFORM    ; a_anchors( )
         selector._s_SELECTOR    ; a_selector( )
         
         *drag._s_DRAG           ;
                                 ;
         wheel._s_POINT          ;
         
         ;StructureUnion
            press.b                 ; mouse buttons state
            *delta._s_POINT         ;
         ;EndStructureUnion
         ;
         entered._s_OBJECTTYPE   ; mouse entered element
         pressed._s_OBJECTTYPE   ; mouse button's pushed element
         
         *widget._s_WIDGET[2]
      EndStructure
      ;;--     margin
      Structure _s_margin Extends _s_coordinate
         color._s_color
         hide.b
      EndStructure
      
      ;--     ITEMS
      Structure _s_ITEMS Extends _s_BOX
         _type.b
         ;*columnaddress
         ;columnindex.i
         
         StructureUnion
            buttonbox._s_BOX; \box[0]\ -> \button\ -> \collapsebox\
            box._s_BOX; \box[0]\ -> \button\ -> \collapsebox\
         EndStructureUnion
         
         change.b
         drawing.b
         
         index.l     ; Index of new list element
         itemindex.l
         
         visible.b
         
         text._s_text
         image._s_image
         color._s_color
         
         OffsetMove.i
         OffsetMoveMin.i
         OffsetMoveMax.i
         
         ;*root._s_WIDGET
         *_parent._s_ROWS
         childrens.w ; Row( )\ ; rows( )\ ; row\
         sublevel.w
         
         *data  ; set/get item data
         *menu._s_WIDGET
      EndStructure
      
      ;--     ROWS
      Structure _s_ROWS Extends _s_ITEMS
         checkbox._s_BOX ; \box[1]\ -> \checkbox\
         
         ;*first._s_rows           ;TEMP first elemnt in the list
         ;*after._s_rows           ;TEMP first elemnt in the list
         ;*before._s_rows          ;TEMP first elemnt in the list
         *_last._s_rows            ; if parent - \last\child ; if child - \parent\last\child
         
         *_option_group_parent._s_rows ; option group row
         
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
         id.i[4]
         
         ; column.a
         ; sublevelcolumn.a
         
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
         
       ;  List lines._s_rows( )
      EndStructure
      
      ;--     TAB
      Structure _s_TAB
         *widget._s_WIDGET
         
         state.c
         index.c
         addindex.c
         
         ; tab
         *entered._s_rows
         *pressed._s_rows
         *focused._s_rows
         
          List *items._s_ITEMS( )
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
         direction.b
         
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
         
         increment.f      ; scrollarea
         *v._s_WIDGET     ; vertical scrollbar
         *h._s_WIDGET     ; horizontal scrollbar
      EndStructure
      
      ;--     caption
      Structure _s_caption
         y.l;[5]
         x.l;[5]
         height.l;[5]
         width.l ;[5]
         
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
      
      
      ;--     COLUMN
      Structure _s_COLUMN Extends _s_COORDINATE
         ;index.i
         
         text._s_TEXT
         image._s_image
         
         
         ;--TEMP---
         drawing.b
         hide.b
         state.b
         
         ;Map string.s( )
         ;List *items._s_rows( )
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
      
      Structure RESIZEINFO Extends _s_COORDINATE
         flag.c
         clip.b
         send.b
         hide.b
         change.b
         nochildren.b
      EndStructure
      
      ;       Structure SIZEINFO Extends _s_SIZE
      ;          change.b
      ;          start.b
      ;          stop.b
      ;          send.b
      ;          ;children.b
      ;       EndStructure
      ;       Structure MOVEINFO Extends _s_POINT
      ;          change.b
      ;          start.b
      ;          stop.b
      ;          send.b
      ;          ;children.b
      ;       EndStructure
      
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
         
         noscale.b
         
         haseventhook.b
;          *eventhook._s_HOOK[constants::#__event_count]
;          ; TEMP
;          hashook.b
;          List *hook._s_HOOK( ) ; hook of events
         
         
         redraw.b
      ;          size.SIZEINFO                 
         ;          move.MOVEINFO                 
         resize.RESIZEINFO                 
         
         _id.i      ; - widget index
         
         y.l[constants::#__c]
         x.l[constants::#__c]
         height.l[constants::#__c]
         width.l[constants::#__c]
         ;
         type.c
         class.s
         ;
         level.c
         ;
         create.b
         change.b
         hidden.b                 ; hide state
                                  ; transporent.b
                                  ; dragged.b              ;
         autosize.b
         container.b              ; is container
                                  ; container > 0          ; if the has children ( Root( 1 ); Window( 2 ); MDI( 3 ); Panel( 3 ); Container( 3 ); ScrollArea( 3 ) )
                                  ; container =- 1         ; if the not has children ( Splitter( ); Frame( ))
                                  ;
         child.b                  ; is the widget composite?
         haschildren.l            ; if the has children
         countitems.l             ; count items
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
         tab._s_TAB               ; 
                                  ;
         *box._s_BOX              ; checkbox; optionbox
         *combobox._s_BUTTONS     ; combobox
                                  ;
         *option_group_parent._s_WIDGET         ; = Option( ) group widget
         *string._s_WIDGET        ; = SpinBar( ) string box
         
         StructureUnion
            *popupBar._s_WIDGET       ; = PopupBar( ) List view box
            *comboBar._s_WIDGET       ; = ComboBox( ) List view box
         EndStructureUnion
         popup.b
         ;
         ;                           
         BarWidth.w               ; bar v size
         BarHeight.w              ; bar h size
         MenuBarHeight.w
         StatusBarHeight.w
         
         StructureUnion
         ToolBarHeight.w
         TabHeight.i
         EndStructureUnion
         index.b[3]
         
         ; placing layout
         first._s_OBJECTTYPE
         after._s_OBJECTTYPE
         before._s_OBJECTTYPE
         last._s_OBJECTTYPE
         ;
         bounds._s_BOUNDS
         scroll._s_SCROLL            ; vertical & horizontal scrollbars
         text._s_TEXT
         ;
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
         
         flag.q
         *data
         *cursor[4] ;
         
         *errors
         notify.l ; оповестить об изменении
         
         mode._s_mode            ; drawing mode
         color._s_color[4]
         
         List *columns._s_column( )
         
         *root._s_ROOT
         *window._s_WIDGET
         *parent._s_WIDGET
         *address                 ; widget( )\ list address
         *contex
         
         ; TEMP
         *parent_menu._s_WIDGET
      EndStructure
      
      ;--     CANVAS
      Structure _s_CANVAS
         post.b
         *gadgetID                ; canvas handle
         window.i                 ; canvas window
         gadget.i                 ; canvas gadget
      EndStructure
      
      ;--     ROOT
      Structure _s_ROOT Extends _s_WIDGET
         repaint.b
         drawmode.b
         canvas._s_canvas
         *menu._s_WIDGET
         
         ; TEMP
         *widget._s_WIDGET
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
         
         Map *roots._s_ROOT( )   
         List *widgets._s_WIDGET( )    ; __widgets( )
         
         ;*drawingIMG
         ;List *intersect._s_WIDGET( )
         
         ;\\ event\
         event._s_EVENTDATA                ; widgetEvent( )\ 
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
; CursorPosition = 813
; FirstLine = 784
; Folding = ----------
; EnableXP