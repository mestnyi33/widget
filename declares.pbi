; ;  ^^
; ; (oo)\__________
; ; (__)\          )\/\  
; ;      ||------w||
; ;      ||       ||
;
; ✔️
; #CheckMark      =     $2713     ; Font: Segoe UI 
; #CheckMark$     = Chr($2713) 
;
; ;        _
; ;       /(|
; ;      (  :
; ;     __\  \  _____
; ;   (____)  `|
; ;  (____)|   |
; ;   (____).__|
; ;    (___)__.|_____
; ;  Mini Thread Control https://www.purebasic.fr/english/viewtopic.php?t=73231
; ;
; ; sudo adduser your_username vboxsf
; ; https://linuxrussia.com/sh-ubuntu.html
; ;
; ;https://github.com/mestnyi33/widget/commits/macos/?after=24cf91f4b5a08e4a496f764416578125334e97ab+1154
; ; 43025500559246
; ; Regex Trim(Arguments)
; ; https://regex101.com/r/zxBLgG/2
; ; ~"((?:(?:\".*?\")|(?:\\(.*?\\))|[^,])+)"
; ; ~"(?:\"(?:.*?)\"|(?:\\w*)\\s*\\((?:(?>[^( )]+|(?R))*)\\)|[\\^\\;\\/\\|\\!\\*\\w\\s\\.\\-\\+\\~\\#\\&\\$\\\\])+"
; ; #Button_0, ReadPreferenceLong("x", WindowWidth(#Window_0)/WindowWidth(#Window_0)+20), 20, WindowWidth(#Window_0)-(390-155), WindowHeight(#Window_0) - 180 * 2, GetWindowTitle(#Window_0) + Space( 1 ) +"("+ "Button" + "_" + Str(1)+")"
; 
; ; Regex Trim(Captions)
; ; https://regex101.com/r/3TwOgS/1
; ; ~"((?:\"(.*?)\"|\\((.*?)\\)|[^+\\s])+)"
; ; ~"(?:(\\w*)\\s*\\(((?>[^( )\"]+|(?R))+)\\))|\"(.*?)\"|[^+\\s]+"
; ; ~"(?:\"(.*?)\"|(\\w*)\\s*\\(((?>[^( )\"]+|(?R))+)\\))|([\\d]+)|(\b[\\w]+)|([\\#\\w]+)|([\\/])|([\\*])|([\\-])|([\\+])"
; ; ~"(?:(?:\"(.*?)\"|(\\w*)\\s*\\(((?>[^( )\"]+|(?R))*)\\))|([\\d]+)|(\b[\\w]+)|([\\#\\w]+)|([\\*\\w]+)|[\\.]([\\w]+)|([\\\\w]+)|([\\/])|([\\*])|([\\-])|([\\+]))"
; ; Str(ListIndex(List( )))+"Число между"+Chr(10)+"это 2!"+
; ; ListIndex(List( )) ; вот так не работает
; 
; ; ; https://regex101.com/r/RFubVd/14
; ; ; #Эта часть нужна для поиска переменных
; ; ; #Например, "Window" в выражении "Window=OpenWindow(#PB_Any...)"
; ; ; (?:(\b[^:\n\s]+)\s*=\s*)?
; ; ;
; ; ; #Эта часть для поиска процедур
; ; ; (?:\".*\"|(\w+)\s*\(((?>(?R)|[^)(])*)\))
; ; ;
; ; ; #После выполнения:
; ; ; # - В группе \1 будет находиться название переменной
; ; ; # - В группе \2 - название процедуры
; ; ; # - В группе \3 - перечень всех аргументов найденной процедуры
; ; ; ~"(?:(\\b[^:\\n\\s]+)\\s*=\\s*)?(?:\".*\"|(\\w+)\\s*\\(((?>(?R)|[^)(])*)\\))"
; #RegEx_Pattern_FindFunction = ~"(?P<Comments>;).*|(?:(?P<Handle>\\b[^:\\n\\s]+)\\s*=\\s*)?(?:\".*\"|(?P<Function>\\w+)\\s*\\((?P<Arguments>(?>(?R)|[^)(])*)\\))" ; "(;).*|\b(?:.*(=)\s*\w*\(.*\)|([A-Za-z0-9_.]*)\b[^:\n\(]*\s*\((?>[^)(]|(?R))*\))"
; 
; ; Найти
; ; https://regex101.com/r/u60Wqt/1
; ; https://regex101.com/r/rQCwws/3
; ; https://regex101.com/r/RFubVd/22
; ; https://regex101.com/r/D4Jxuh/24
; ; https://regex101.com/r/mBkJTA/29
; 
; #RegEx_Pattern_Find = "" +
;                       ; https://regex101.com/r/oIDfrI/2
; "(?P<Comments>;).* |" +
; ; #Эта часть нужна для поиска переменных
; ; #Например, "Window" в выражении "Window=OpenWindow(#PB_Any...)"
; "(?:(?P<Handle>[^:\n\s]+)\s*=\s*)?" +
; "(?P<FuncString>" +
; ~"\".*\" |" +
; ; #Эта часть для поиска функций
; "\b(?P<FuncName>\w+)\s*" +
; ; #Эта часть для поиска аргументов функции
; "(?:\((?P<FuncArguments>(?>(?R)|[^()])*)\))" +
; ") |" +
; ; #Эта часть для поиска процедур
; "(?P<StartPracedure>\bProcedure[.A-Za-z]* \s*" +
; ; #Эта часть для поиска имени процедуры
; "(?P<PracName>\w*) \s*" +
; ; #Эта часть для поиска аргументов процедуры
; "(?:\((?P<ProcArguments>(?>(?R)|[^()])*)\))) |" +
; ; #Эта часть для поиска конец процедуры
; "(?P<StopProcedure>\bEndProcedure\b)"
; ;
; ; #После выполнения:
; ; # - В группе (Comments) будет находиться комментария
; ; # - В группе (Handle) будет находиться название переменной
; ; # - В группе (FuncName) - название Функции
; ; # - В группе (FuncArguments) - перечень всех аргументов найденной Функции
; ; # - В группе (ProcedureName) - название процедуры
; ; # - В группе (ProcArguments) - перечень всех аргументов найденной процедуры

; ; https://www.purebasic.fr/english/viewtopic.php?t=79212
; !macro ppublic name{
; !if name eq _SYS_StaticStringEnd
; !repeat $-_SYS_StaticStringStart
; !load zczc from _SYS_StaticStringStart+%-1
; !store zczc xor 137 at _SYS_StaticStringStart+%-1
; !end repeat
; !end if
; !public name}
; !public fix ppublic
; CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
;    !mov edi,_SYS_StaticStringStart
;    !mov ecx,_SYS_StaticStringEnd-_SYS_StaticStringStart
;    !@@:
;    !xor byte[edi],137
;    !inc edi
;    !dec ecx
; CompilerElse
;    !mov rdi,_SYS_StaticStringStart
;    !mov rcx,_SYS_StaticStringEnd-_SYS_StaticStringStart
;    !@@:
;    !xor byte[rdi],137
;    !inc rdi
;    !dec rcx
; CompilerEndIf
; !jnz @b


; ver: 3.0.0.1 ;
CompilerSelect #PB_Compiler_OS
   CompilerCase #PB_OS_MacOS
      #path = ""
   CompilerCase #PB_OS_Linux
      #path = ""
   CompilerCase #PB_OS_Windows
      #path = "" ; C:\Users\user\Documents\GitHub\widget\"
CompilerEndSelect

IncludePath #path

CompilerIf #PB_Compiler_Version < 520
   #PB_Module = 58 ; mac
   #PB_Compiler_IsMainFile = 1 ; mac
   Macro Defined( _name_, _type_ )
      1
   EndMacro
CompilerEndIf

;
CompilerIf Not Defined( constants, #PB_Module )
   XIncludeFile "constants.pbi"
CompilerEndIf
CompilerIf Not Defined( structures, #PB_Module )
   XIncludeFile "structures.pbi"
CompilerEndIf
;
CompilerIf Not Defined( lng, #PB_Module )
   XIncludeFile "include/lng.pbi"
CompilerEndIf
CompilerIf Not Defined( func, #PB_Module )
   XIncludeFile "include/func.pbi"
CompilerEndIf
CompilerIf Not Defined( colors, #PB_Module )
   XIncludeFile "include/colors.pbi"
CompilerEndIf

;
CompilerIf Not Defined( key, #PB_Module )
   XIncludeFile "include/os/key.pbi"
CompilerEndIf
CompilerIf Not Defined( ID, #PB_Module )
   XIncludeFile "include/os/id.pbi"
CompilerEndIf
CompilerIf Not Defined( mouse, #PB_Module )
   XIncludeFile "include/os/mouse.pbi"
CompilerEndIf
CompilerIf Not Defined( cursor, #PB_Module )
   XIncludeFile "include/os/cursor.pbi"
CompilerEndIf
CompilerIf Not Defined( Image, #PB_Module )
   XIncludeFile "include/os/image.pbi"
CompilerEndIf
CompilerIf Not Defined( font, #PB_Module )
   XIncludeFile "include/os/font.pbi"
CompilerEndIf

;
CompilerSelect #PB_Compiler_OS 
   CompilerCase #PB_OS_MacOS   
      XIncludeFile "include/os/mac/parent.pbi"
      
   CompilerCase #PB_OS_Windows 
      XIncludeFile "include/os/win/parent.pbi"
      
   CompilerCase #PB_OS_Linux   
      XIncludeFile "include/os/lin/parent.pbi"
      
CompilerEndSelect


; fix all pb bug's
CompilerIf Not Defined( fix, #PB_Module )
   XIncludeFile "include/fix.pbi"
CompilerEndIf

;-
CompilerIf Not Defined( widgets, #PB_Module )
   DeclareModule widgets
      CompilerIf Defined( fix, #PB_Module )
         UseModule fix
      CompilerElse
         Macro PB(Function)
            Function
         EndMacro
         
         Macro PB_(Function)
            Function
         EndMacro
      CompilerEndIf
      
      EnableExplicit
      UseModule lng
      UseModule constants
      UseModule structures
      
      
      ;-\\ cursor
      ;       #PB_Cursor_Default         = Cursor::#__cursor_Default
      ;       #PB_Cursor_Cross           = Cursor::#__cursor_Cross
      ;       #PB_Cursor_IBeam           = Cursor::#__cursor_IBeam
      ;       #PB_Cursor_Hand            = Cursor::#__cursor_Hand
      ;       #PB_Cursor_Busy            = Cursor::#__cursor_Busy
      ;       #PB_Cursor_Denied          = Cursor::#__cursor_Denied
      ;       #PB_Cursor_Arrows          = Cursor::#__cursor_Arrows
      
      ;       #PB_Cursor_UpDown          = Cursor::#__cursor_UpDown
      ;       #PB_Cursor_LeftRight       = Cursor::#__cursor_LeftRight
      #PB_cursor_Diagonal1       = Cursor::#__cursor_Diagonal1
      #PB_cursor_Diagonal2       = Cursor::#__cursor_Diagonal2
      
      ;       #PB_Cursor_Invisible       = Cursor::#__cursor_Invisible
      
      #PB_cursor_SplitUp         = Cursor::#__cursor_SplitUp
      #PB_cursor_SplitDown       = Cursor::#__cursor_SplitDown         
      #PB_cursor_SplitLeft       = Cursor::#__cursor_SplitLeft
      #PB_cursor_SplitRight      = Cursor::#__cursor_SplitRight       
      #PB_cursor_SplitUpDown     = Cursor::#__cursor_SplitUpDown  
      #PB_cursor_SplitLeftRight  = Cursor::#__cursor_SplitLeftRight
      
      #PB_cursor_LeftUp          = Cursor::#__cursor_LeftUp
      #PB_cursor_RightUp         = Cursor::#__cursor_RightUp
      #PB_cursor_LeftDown        = Cursor::#__cursor_LeftDown
      #PB_cursor_RightDown       = Cursor::#__cursor_RightDown
      
      #PB_cursor_Drag            = Cursor::#__cursor_Drag
      #PB_cursor_Drop            = Cursor::#__cursor_Drop
      
      #PB_cursor_Grab            = Cursor::#__cursor_Grab      
      #PB_cursor_Grabbing        = Cursor::#__cursor_Grabbing
      #PB_cursor_VIBeam          = Cursor::#__cursor_VIBeam
      ; #PB_cursor_Arrow           = Cursor::#__cursor_Arrow
      
      #PB_cursor_Up              = Cursor::#__cursor_Up
      #PB_cursor_Down            = Cursor::#__cursor_Down      
      #PB_cursor_Left            = Cursor::#__cursor_Left
      #PB_cursor_Right           = Cursor::#__cursor_Right       
      ;       #PB_Cursor_LeftUpRightDown = Cursor::#__cursor_LeftUpRightDown
      ;       #PB_Cursor_LeftDownRightUp = Cursor::#__cursor_LeftDownRightUp
      
      ;-  -----------------
      ;-   GLOBALS
      ;-  -----------------
      Global display_mode_linux = 0
      Global test_align = 0
      Global test_atpoint
      Global test_display
      Global test_edit_text
      Global test_delete
      Global test_resize
      Global test_drag = 0
      
      Global test_focus_set = 0
      Global test_focus_draw = 0
      Global test_snap
      Global test_canvas_focus_draw = 0
      Global test_canvas_events = 0 
      
      Global test_event_repost
      Global test_event_entered
      Global test_event_add = 0
      
      Global test_redraw_items = 1
      Global test_draw_repaint = 0
      Global test_buttons_draw = 0
      Global test_startdrawing = 0
      Global test_clip         = 0
      Global test_iclip         = 0
      
      Global test_resize_area = 0
      Global test_scrollbars_reclip = 0
      
      Global test_draw_area = 0
      Global test_anchors
      Global test_changecursor,test_setcursor
      Global no_resize_mdi_child 
      
      Global window_pos_x.l, window_pos_y.l
      
      Global __GUI._s_GUI
      Global NewMap gadgets.i( )
      Global NewMap fonts._s_FONTS( )
      Global NewList images._s_images( )
      
      ;-  ----------------
      ;-   DECLARE_macros
      ;-  ----------------
      
      Macro allocate( _struct_name_, _struct_type_ = )
         _s_#_struct_name_#_struct_type_ = AllocateStructure( _s_#_struct_name_ )
      EndMacro
      
      Global _macro_call_count_
      Macro Debug_out( _text_ = "" )
         CompilerIf #PB_Compiler_Debugger  ; Only enable assert in debug mode
            Debug " " + _macro_call_count_ + _text_ + "   ( debug >> " + #PB_Compiler_Procedure + " ( " + #PB_Compiler_Line + " ))"
            _macro_call_count_ + 1
         CompilerEndIf
      EndMacro
      Macro Debug_position( _root_, _text_ = "" )
         Debug " " + _text_ + " - "
         ForEach widgets( )
            If widgets( )\root = _root_
               If widgets( )\prev[2] And widgets( )\next[2]
                  Debug " - " + Str(ListIndex( widgets( ))) + " " + widgets( )\index + " ( " + widgets( )\prev[2]\class + " " + widgets( )\class + " " + widgets( )\next[2]\class + " )"
               ElseIf widgets( )\next[2]
                  Debug " - " + Str(ListIndex( widgets( ))) + " " + widgets( )\index + " ( --- " + widgets( )\class + " " + widgets( )\next[2]\class + " )"
               ElseIf widgets( )\prev[2]
                  Debug " - " + Str(ListIndex( widgets( ))) + " " + widgets( )\index + " ( " + widgets( )\prev[2]\class + " " + widgets( )\class + " --- )"
               Else
                  Debug " - " + Str(ListIndex( widgets( ))) + " " + widgets( )\index + " ( --- " + widgets( )\class + " --- ) "
               EndIf
            EndIf
         Next
         Debug ""
      EndMacro
      
      ;-
      Global DPIScaledX.d = 1.0
      Global DPIScaledY.d = 1.0
      
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
         DPIScaledX.d = GetDeviceCaps_(GetDC_(0),#LOGPIXELSX) / 96
         DPIScaledY.d = GetDeviceCaps_(GetDC_(0),#LOGPIXELSY) / 96
      CompilerEndIf
      
      ;- PB_VERSION_546
      CompilerIf #PB_Compiler_Version =< 562 
         Macro DesktopResolutionX( )
            DPIScaledX
         EndMacro
         Macro DesktopResolutionY( )
            DPIScaledY
         EndMacro
         Macro DesktopScaledX( _x_ )
            Round((_x_) * DesktopResolutionX( ), #PB_Round_Up)
         EndMacro
         Macro DesktopScaledY( _y_ )
            Round((_y_) * DesktopResolutionY( ), #PB_Round_Up)
         EndMacro
         Macro DesktopUnscaledX( _x_ )
            Round((_x_) / DesktopResolutionX( ), #PB_Round_Up)
         EndMacro
         Macro DesktopUnscaledY( _y_ )
            Round((_y_) / DesktopResolutionY( ), #PB_Round_Up)
         EndMacro
         ;     
         CompilerIf #PB_Compiler_Version =< 546
            Macro ResizeGadget(_event_gadget_,_x_,_y_,_width_,_height_)
               PB(ResizeGadget)(_event_gadget_,_x_,_y_,_width_,_height_)
               ;
               If PB(GadgetType)(_event_gadget_) = #PB_GadgetType_Canvas
                  widgets::Resize( key::GetData(GadgetID( _event_gadget_ )), 0, 0, _width_, _height_)
               EndIf
            EndMacro
         CompilerEndIf
      CompilerEndIf
      
      ;
      Declare DPIScaled( _value_ )
      ;Macro DPIScaled( _value_ ): DesktopScaledX( _value_ ): EndMacro
      Macro DPIUnScaled( _value_ ): DesktopUnscaledX( _value_ ): EndMacro
      Macro DPIScaledX( _x_ ): DesktopScaledX( _x_ ): EndMacro
      Macro DPIUnscaledX( _x_ ): DesktopUnscaledX( _x_ ): EndMacro
      Macro DPIScaledY( _y_ ): DesktopScaledY( _y_ ): EndMacro
      Macro DPIUnscaledY( _y_ ): DesktopUnscaledY( _y_ ): EndMacro
      Macro DPIResolutionX( ): DesktopResolutionX( ): EndMacro
      Macro DPIResolutionY( ): DesktopResolutionY( ): EndMacro
      Macro DPIResolution( ): DesktopResolutionX( ): EndMacro
      
      ;-
      ;===TEMP====
      Macro AlphaState( ) 
         color\_alpha
      EndMacro
      
      Macro AlphaState24( ) 
         color\_alpha << 24
      EndMacro
      
      
      Macro is_drag_move( )
         widgets::a_index( ) = #__a_moved
      EndMacro
      
      ;-
      Macro GetItemAddress( _this_ )
         _this_\__rows( )
      EndMacro
      Macro GetColors( _address_ )
         _address_\color  ;  \__rows( )
      EndMacro
      
      Macro SetColors( _address_, _colors_ )
         _address_\color = _colors_   ;   \__rows( )
      EndMacro
      
      Macro SetBounds( _this_, _mode_ = #__bounds_Parentsize )
         If _mode_ = #__bounds_Parentsize 
            SetSizeBounds( _this_ )
            SetMoveBounds( _this_ )
         EndIf
         If _mode_ & #__bounds_Children 
            SetChildrenBounds( _this_, 1 )
         EndIf
         If _mode_ & #__bounds_size
            SetSizeBounds( _this_, -1,-1,-1,-1 )
         EndIf
         If _mode_ & #__bounds_move 
            SetMoveBounds( _this_, -1,-1,-1,-1 )
         EndIf
      EndMacro
      
      Macro SetBackColor( _this_, _color_ )
         SetBackgroundColor( _this_, _color_ )
      EndMacro
      
      ;-
      ;       Macro  SetState(widget, State)
      ;          SetText(widget,
      ;                  Str(IPAddressField(State,0))+"."+
      ;                  Str(IPAddressField(State,1))+"."+
      ;                  Str(IPAddressField(State,2))+"."+
      ;                  Str(IPAddressField(State,3)))
      ;       EndMacro
      
      Macro IPAddress( X,Y,Width,Height, Flag=0 )
         String( X,Y,Width,Height, "", #__flag_Textnumeric|#__flag_Center|Flag )
         Widget( )\class = "IPAddress"
      EndMacro
      
      ;-
      Macro PageChange( ): change: EndMacro          ; temp
      Macro TabChange( ): change: EndMacro           ; temp
      Macro TextChange( ): Text\change: EndMacro     ; temp
      Macro ResizeChange( )
         mask & #__mask_resize ; Resize\change
      EndMacro                 ; temp
      Macro WidgetChange( ): change: EndMacro        ; temp
      
      ;-
      Macro ColorState( ): color\state: EndMacro
      Macro MarginLine( ): row\margin: EndMacro ; temp
      
      ;-
      ;Macro __tabs: Tab\_s: EndMacro
      Macro TabEntered( _this_ ): _this_\tab\entered: EndMacro   ; Returns mouse entered tab
      Macro parentTabEntered( _this_ ): _this_\tab\entered: EndMacro   ; Returns mouse entered tab
      
      Macro TabSelected( ): Tab\active: EndMacro   ; Returns mouse focused tab
      Macro parentTabSelected( ): Tab\active: EndMacro   ; Returns mouse focused tab
                                                         ;                                             ;
      Macro TabState( ): tabpage: EndMacro      
      
      ;-
      ;
      ;-\\
      Macro edit_text_1( ): Text\edit[0]: EndMacro
      Macro edit_text_2( ): Text\edit[1]: EndMacro
      Macro edit_text_3( ): Text\edit[2]: EndMacro
      
      ;-
      Macro __columns( ): column\__s( ) : EndMacro    ; row\items( )
      Macro __tabs( ): Tab\__s( ) : EndMacro          ; row\items( )
      Macro __rows( ): row\__s( ) : EndMacro          ; row\items( )
      Macro __lines( ): row\__s( ) : EndMacro         ; row\items( )
      Macro __items( ): row\visible\__s( ): EndMacro
      
      ;-
      Macro LineState( ): row\state: EndMacro     ; *this\ Returns key focused line index   ; 11 count
      Macro LineIndex( ): row\index: EndMacro     ; *this\ Returns mouse pressed line index ; 23 count
      Macro LineEntered( ): row\entered: EndMacro ; Returns mouse entered widget
      
      ;-
      Macro RowEntered( ): row\entered: EndMacro         ; Returns mouse entered item address
      Macro RowPressed( ): row\active[1]: EndMacro       ; Returns mouse press item address
      Macro RowFocused( ): row\active[0]: EndMacro       ; Returns key focus item address
                                                         ;
      Macro RowFirstVisible( ): row\visible\first: EndMacro
      Macro RowLastVisible( ): row\visible\last: EndMacro
      ;
      Macro RowToolTip( ): row\tt: EndMacro
      
      ;-
      Macro mouse( ): widgets::__GUI\mouse: EndMacro
      Macro keyboard( ): widgets::__GUI\keyboard: EndMacro
      Macro widgets( ): __GUI\__widgets( ): EndMacro
      
      ;-
      ; Macro ComboBar( ): menu\parent: EndMacro
      Macro ComboBar( ): combobar: EndMacro
      Macro PopupBar( ): __GUI\popup: EndMacro
      Macro Toggle( ): togglebox: EndMacro
      Macro Combo( ): combobutton: EndMacro
      
      ;-
      Macro split_1( ) : gadget[1] : EndMacro ; temp
      Macro split_2( ) : gadget[2] : EndMacro ; temp
      
      ;-
      Macro Root( ): widgets::__GUI\root: EndMacro
      Macro NextRoot( ): Canvas\next: EndMacro
      Macro PrevRoot( ): Canvas\prev: EndMacro
      Macro Opened( ): widgets::__GUI\opened: EndMacro ; object list opened container
      Macro Closed( ): widgets::__GUI\closed: EndMacro ; object list opened container
      
      ;-
      Macro FirstWidget( ): first: EndMacro
      Macro LastWidget( ): last: EndMacro
   Macro AfterWidget( ): Next[2]: EndMacro
   Macro BeforeWidget( ): prev[2]: EndMacro
   
   ;-
   Macro Leaved( ): mouse( )\widget[0]: EndMacro ; Returns mouse entered widget
   Macro Entered( ): widgets::mouse( )\widget[1]: EndMacro; Returns mouse entered widget
   Macro Pressed( ): widgets::mouse( )\widget[2]: EndMacro; Returns mouse button pushed widget
   Macro Sticked( ): widgets::__GUI\sticky\window: EndMacro
   
   ;-
   Macro EnteredButton( ): mouse( )\button[1]: EndMacro
   Macro PressedButton( ): mouse( )\button[2]: EndMacro
   
   ;-
   Macro Widget( ): widgets::__GUI\widget: EndMacro
   Macro EventWidget( ): widgets::Widget( ): EndMacro
   ;Macro EventWidget( ): widgets::__GUI\event\widget: EndMacro
   Macro WidgetEvent( ): widgets::__GUI\event\type: EndMacro
   Macro WidgetEventType( ): PBEventType( WidgetEvent( ) ): EndMacro
   Macro WidgetEventData( ): widgets::__GUI\event\data: EndMacro
   Macro WidgetEventItem( ): widgets::__GUI\event\item: EndMacro
   
   Macro Events( ): widgets::__GUI\event\type: EndMacro
   Macro GetEvent( ): widgets::__GUI\event\type: EndMacro
   Macro GetEventWidget( ): EventWidget( ): EndMacro
   Macro GetEventType( ): PBEventType( WidgetEvent( ) ): EndMacro
   Macro GetEventData( ): widgets::__GUI\event\data: EndMacro
   Macro GetEventItem( ): widgets::__GUI\event\item: EndMacro
   
   ;-
   Macro GetActive( ): keyboard( )\active: EndMacro         ; Returns actived object
   Macro ActiveWindow( ): keyboard( )\window: EndMacro      ; Returns activeed window
   Macro ActiveGadget( ): ActiveWindow( )\gadget: EndMacro  ; Returns activeed gadget
   Macro ActiveBar( ): ActiveWindow( )\gadget\bar\gadget: EndMacro ; Returns activeed gadget
   
   ;-
   Macro StartNext(_ptr_, _parent_)
      Bool(_parent_\first)
      _ptr_ = _parent_\first
      While _ptr_
      EndMacro
      Macro StopNext(_ptr_, _parent_)
         If _ptr_\next
            _ptr_ = _ptr_\next
         Else
            Break
         EndIf
      Wend
   EndMacro
   ;-
   Global *before_start_enumerate_widget._s_WIDGET
   Macro StartEnum( _parent_, _item_ = #PB_All, _mode_ = 0 )
      Bool( _parent_\haschildren And _parent_\FirstWidget( ) )
      *before_start_enumerate_widget = Widget( )
      PushListPosition( widgets( ))
      ;
      If _parent_\FirstWidget( )\address
         ChangeCurrentElement( widgets( ), _parent_\FirstWidget( )\address )
      Else
         ResetList( widgets( ) )
      EndIf
      ;
      ;\\
      If _item_ > 0
         Repeat
            If widgets( ) = _parent_\next[2] 
               Break
            EndIf
            If widgets( )\root <> _parent_\root
               Break    
            EndIf
            If  widgets( )\level < _parent_\level
               Break
            EndIf
            If widgets( )\parent = _parent_  
               If widgets( )\tabindex = _item_
                  Break
               EndIf
            EndIf
         Until Not NextElement( widgets( ) ) 
      EndIf
      
      ;
      ;\\
      If widgets( )\parent = _parent_
         Repeat
            If widgets( )\parent = _parent_  
               If widgets( )\tabindex <> _item_
                  If _item_ >= 0  
                     Break
                  EndIf
               EndIf
            Else
               If _mode_
                  Continue
               EndIf
            EndIf
            If widgets( ) = _parent_\next[2] 
               Break
            EndIf
            If widgets( )\root <> _parent_\root
               Break    
            EndIf
            If  widgets( )\level < _parent_\level
               Break
            EndIf
            ;
            If Not IsChild( widgets(), _parent_ )
               Break
            EndIf
            ;
            Widget( ) = widgets( )
         EndMacro
         ;             ;
         ;             Macro AbortEnum( )
         ;                Break
         ;             EndMacro
         ;             ;
         Macro StopEnum( )
         Until Not NextElement( widgets( ))
      EndIf
      PopListPosition( widgets( ))
      Widget( ) = *before_start_enumerate_widget
   EndMacro
   
   ;-
   Macro StartDraw( _root_ )
      Bool(widgets::__GUI\DrawingRoot <> _root_)
      ;
      widgets::StopDraw( )
      If Not _root_\drawmode 
         _root_\drawmode | 1<<2
      EndIf
      If _root_\drawmode & 1<<1
         StartVectorDrawing( CanvasVectorOutput( _root_\canvas\gadget ))
         ;             VectorSourceColor($FFF0F0F0)
         ;             FillVectorOutput( )
      EndIf
      If _root_\drawmode & 1<<2
         StartDrawing( CanvasOutput( _root_\canvas\gadget ))
         ;             ; Box( 0,0, OutputWidth( ), OutputHeight( ), _root_\color\back )
         ;             CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
         ;                FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ))
         ;             CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
         ;                If GetWindowColor( _root_\canvas\window ) = - 1
         ;                   FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), GetSysColor_(#COLOR_BTNFACE) )
         ;                Else
         ;                   FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), GetWindowColor( _root_\canvas\window ) )
         ;                EndIf
         ;             CompilerElse
         ;                FillMemory( DrawingBuffer( ), DrawingBufferPitch( ) * OutputHeight( ), $f0 )
         ;             CompilerEndIf
      EndIf
      
      widgets::__GUI\DrawingRoot = _root_
   EndMacro
   Macro StopDraw( )
      If widgets::__GUI\DrawingRoot 
         ;Debug "StopDrawingRoot "+widgets::__GUI\DrawingRoot\class
         If widgets::__GUI\DrawingRoot\drawmode & 1<<2 = 1<<2
            StopDrawing( )
         EndIf
         If widgets::__GUI\DrawingRoot\drawmode & 1<<1 = 1<<1
            StopVectorDrawing( )  
         EndIf
         widgets::__GUI\DrawingRoot = #Null
      EndIf
   EndMacro
   
   ;-
   Macro repaint_set( _address_ )
      _address_\mask | #__mask_redraw ;  Root\Repaint = 0
   EndMacro
   
   Macro Repaint( _address_ = #PB_All )
      ReDraw( _address_ )
   EndMacro
   Macro PostRepaint( _root_ )
      If __GUI\event\loop
         ReDraw( _root_ )
      Else
         If _root_\canvas\repaint = 0
            _root_\canvas\repaint = 1
            PostEvent( #PB_Event_Repaint, _root_\canvas\window, #PB_All, #PB_All, _root_\canvas\gadgetID )
         EndIf
      EndIf
   EndMacro
   Macro PostFree( _this_ )
      AddEvents( _this_, #__event_free ) 
   EndMacro
   Macro PostClose( _this_ )
      AddEvents( _this_, #__event_Close ) 
   EndMacro
   
   ; 
   Macro PostEventsResize( _this_ )
      Post( _this_, #__event_Resize )
   EndMacro
   Macro PostEventsRepaint( _root_ )
      
   EndMacro
   
   
   
   
   ;-
   Macro MidF(_string_, _start_pos_, _length_ = -1)
      func::MidFast(_string_, _start_pos_, _length_)
   EndMacro
   
   Macro ICase( String ) ; sTRinG = StrINg
      func::InvertCase( String )
   EndMacro
   
   Macro ULCase( String ) ; sTRinG = String
      InsertString( UCase( Left( String, 1 )), LCase( Right( String, Len( String ) - 1 )), 2 )
   EndMacro
   
   
   ;-
   Macro TitleText( ): Text: EndMacro
   Macro GetTitle( window ): widgets::GetText( window ): EndMacro
   Macro CloseButton( ): caption\button[#__wb_close]: EndMacro
   Macro MaximizeButton( ): caption\button[#__wb_maxi]: EndMacro
   Macro MinimizeButton( ): caption\button[#__wb_mini]: EndMacro
   Macro HelpButton( ): caption\button[#__wb_help]: EndMacro
   
   ;-
   Macro clip_ix( ): X[#__c_idraw]: EndMacro
   Macro clip_iy( ): Y[#__c_idraw]: EndMacro
   Macro clip_iwidth( ): Width[#__c_idraw]: EndMacro
   Macro clip_iheight( ): Height[#__c_idraw]: EndMacro
   ;-
   Macro clip_x( ): X[#__c_draw]: EndMacro
   Macro clip_y( ): Y[#__c_draw]: EndMacro
   Macro clip_width( ): Width[#__c_draw]: EndMacro
   Macro clip_height( ): Height[#__c_draw]: EndMacro
   
   ;-
   Macro screen_x( ): X[#__c_screen]: EndMacro
   Macro screen_y( ): Y[#__c_screen]: EndMacro
   Macro screen_width( ): Width[#__c_screen]: EndMacro
   Macro screen_height( ): Height[#__c_screen]: EndMacro
   
   ;-
   Macro inner_x( ): X[#__c_inner]: EndMacro
   Macro inner_y( ): Y[#__c_inner]: EndMacro
   Macro inner_width( ): Width[#__c_inner]: EndMacro
   Macro inner_height( ): Height[#__c_inner]: EndMacro
   
   ;-
   Macro frame_x( ): X[#__c_frame]: EndMacro
   Macro frame_y( ): Y[#__c_frame]: EndMacro
   Macro frame_width( ): Width[#__c_frame]: EndMacro
   Macro frame_height( ): Height[#__c_frame]: EndMacro
   
   ;-
   Macro container_x( ): X[#__c_container]: EndMacro
   Macro container_y( ): Y[#__c_container]: EndMacro
   Macro container_width( ): Width[#__c_container]: EndMacro
   Macro container_height( ): Height[#__c_container]: EndMacro
   
   ;-
   Macro scroll_x( ): X[#__c_required]: EndMacro
   Macro scroll_y( ): Y[#__c_required]: EndMacro
   Macro scroll_width( ): Width[#__c_required]: EndMacro
   Macro scroll_height( ): Height[#__c_required]: EndMacro
   
   ;- TEMP
   Macro scroll_inner_width( ): Width[#__c_inner]: EndMacro
   Macro scroll_inner_height( ): Height[#__c_inner]: EndMacro
   
   ;-
   Macro _get_colors_( ) : colors::*this\blue : EndMacro
   
   ;-
   Macro is_menu_( _this_ ) : Bool( _this_\type = constants::#__type_MenuBar Or _this_\type = constants::#__type_PopupBar ) : EndMacro
   Macro is_bar_( _this_ ) : Bool( is_menu_( _this_ ) Or _this_\type = constants::#__type_ToolBar ) : EndMacro
   Macro is_root_(_this_ ) : Bool( _this_ >= 65536 And _this_ = _this_\root ): EndMacro
   Macro is_gadget_( _this_ ) : Bool( Not is_root_( _this_ ) And _this_\type > 0 ) : EndMacro
   Macro is_window_( _this_ ) : Bool( _this_\type = constants::#__type_Window ) : EndMacro
   
   Macro is_level_( _address_1, _address_2 )
      Bool( _address_1 <> _address_2 And _address_1\parent = _address_2\parent And _address_1\tabindex = _address_2\tabindex )
   EndMacro
   
   Macro is_scrollbars_( _this_ )
      Bool( _this_\parent And _this_\parent\scroll And ( _this_\parent\scroll\v = _this_ Or _this_\parent\scroll\h = _this_ ))
   EndMacro
   
   Macro is_integral_( _this_ ) ; It is an integral part
      Bool( _this_\child > 0 And Not is_window_(_this_) )
   EndMacro
   
   Macro is_inside_( _position_, _size_, _mouse_ ) ;
      Bool( _mouse_ > _position_ And _mouse_ <= ( _position_ + _size_ ) And ( _position_ + _size_ ) > 0 )
   EndMacro
   
   ;       Macro is_atbox_( _x_, _y_, _width_, _height_, _mouse_x_, _mouse_y_ )
   ;          Bool( is_inside_( _x_, _width_, _mouse_x_ ) And
   ;                is_inside_( _y_, _height_, _mouse_y_ ) )
   ;       EndMacro
   ;       
   ;       Macro is_atcircle_( _position_x_, _position_y_, _mouse_x_, _mouse_y_, _circle_radius_ )
   ;          Bool( Sqr( Pow((( _position_x_ + _circle_radius_ ) - _mouse_x_ ), 2 ) + Pow((( _position_y_ + _circle_radius_ ) - _mouse_y_ ), 2 )) <= _circle_radius_ )
   ;       EndMacro
   ;       Macro is_atcircle_( _address_, _mouse_x_, _mouse_y_ , _mode_ = )
   ;          Bool( Abs( _mouse_x_ - _address_\x#_mode_ ) < _address_\round And Abs(_mouse_y_ - _address_\y#_mode_) < _address_\round )
   ;       EndMacro
   
   Macro is_atpoint_( _address_, _mouse_x_, _mouse_y_, _mode_ = )
      Bool( is_inside_( _address_\x#_mode_, _address_\width#_mode_, _mouse_x_ ) And
            is_inside_( _address_\y#_mode_, _address_\height#_mode_, _mouse_y_ ) )
   EndMacro
   
   
   Macro is_hover( _address_, _mouse_x_, _mouse_y_, _mode_ = )
      Bool( Not _address_\mask & #__mask_hidden And is_atpoint_( _address_, _mouse_x_, _mouse_y_, _mode_ ))
   EndMacro
   
   
   
   ;       Macro is_interrect_( _address_1_x_, _address_1_y_, _address_1_width_, _address_1_height_,
   ;                            _address_2_x_, _address_2_y_, _address_2_width_, _address_2_height_ )
   ;          
   ;          Bool(( _address_1_x_ + _address_1_width_ ) > _address_2_x_ And _address_1_x_ < ( _address_2_x_ + _address_2_width_ ) And
   ;               ( _address_1_y_ + _address_1_height_ ) > _address_2_y_ And _address_1_y_ < ( _address_2_y_ + _address_2_height_ ))
   ;       EndMacro
   
   Macro is_intersect_( _address_1_, _address_2_, _address_1_mode_ = )
      Bool(( _address_1_\x#_address_1_mode_ + _address_1_\width#_address_1_mode_ ) > _address_2_\x And _address_1_\x#_address_1_mode_ < ( _address_2_\x + _address_2_\width ) And
           ( _address_1_\y#_address_1_mode_ + _address_1_\height#_address_1_mode_ ) > _address_2_\y And _address_1_\y#_address_1_mode_ < ( _address_2_\y + _address_2_\height ))
   EndMacro
   
   ;-
   Macro is_lines_( _this_ )
      Bool( _this_\type = #__type_Editor Or
            _this_\type = #__type_String  Or
            _this_\type = #__type_Hyperlink Or
            _this_\type = #__type_IPAddress Or
            _this_\type = #__type_CheckBox Or
            _this_\type = #__type_Option Or
            _this_\type = #__type_Button Or _this_\type = #__type_Button Or
            _this_\type = #__type_Text Or
            _this_\type = #__type_ComboBox )
   EndMacro
   
   Macro is_items_( _this_ )
      Bool( _this_\type = #__type_Tree Or
            _this_\type = #__type_ListIcon Or
            _this_\type = #__type_ListView Or
            _this_\type = #__type_Properties )
   EndMacro
   
   Macro is_no_select_item_( _list_, _item_ )
      Bool( _item_ < 0 Or _item_ >= ListSize( _list_ ) Or (ListIndex( _list_ ) <> _item_ And Not SelectElement( _list_, _item_ ) ))
   EndMacro
   
   ;-
   Macro MouseButtons( ) 
      mouse( )\buttons
      ; #PB_Canvas_LeftButton
      ; #PB_Canvas_MiddleButton
      ; #PB_Canvas_RightButton
   EndMacro ; Returns mouse button                                                                     
   Macro MousePress( _address_ = #Null )
      Bool((mouse( )\mask & #__mask_press) And ((Pressed( )=_address_) Or _address_=#Null))
   EndMacro ; Returns mouse buttons state
   Macro MouseDirection( )   
      (Bool(MouseMask( ) & #__mask_left) * - 1) + (Bool(MouseMask( ) & #__mask_top) * 1) + (Bool(MouseMask( ) & #__mask_right) * - 2) + (Bool(MouseMask( ) & #__mask_bottom) * 2)
   EndMacro ; Returns mouse [move/wheel] direction                 
   Macro MouseClick( ): mouse( )\click: EndMacro                                               ; Returns mouse click count
   Macro MouseMask( ): mouse( )\mask: EndMacro                                                 ; Returns mouse data
   Macro MouseDrag( ): Bool( MouseMask( ) & #__mask_drag ): EndMacro                           ; Returns mouse data
                                                                                               ; Macro MouseRelease( ): Bool( Not ( MouseButtons( ) And Not MousePress( ))): EndMacro 
   Macro MouseRelease( ): Bool( MouseMask( ) & #__mask_release ): EndMacro 
   Macro MouseEnter( _this_, _mode_ = 2 ): (Bool(_this_\mask & #__mask_hover_in)*2) = _mode_: EndMacro
   Macro MousePressX( ): mouse( )\press\x: EndMacro                                            ; Returns mouse buttons press [x]-coordinate
   Macro MousePressY( ): mouse( )\press\y: EndMacro                                            ; Returns mouse buttons press [y]-coordinate
   Macro MouseMoveX( ): DPIUnscaledX( CanvasMouseX( ) - MousePressX( )): EndMacro              ; Returns mouse x
   Macro MouseMoveY( ): DPIUnscaledY( CanvasMouseY( ) - MousePressY( )): EndMacro              ; Returns mouse y
   Macro GetMouseX( _this_ ): DPIUnscaledX( CanvasMouseX( ) - _this_\x[#__c_inner] ): EndMacro ; Returns mouse x
   Macro GetMouseY( _this_ ): DPIUnscaledY( CanvasMouseY( ) - _this_\y[#__c_inner] ): EndMacro ; Returns mouse y
   
   ;-
   Macro CanvasMouseX( ): widgets::mouse( )\x: EndMacro                                  ; Returns mouse x
   Macro CanvasMouseY( ): widgets::mouse( )\y: EndMacro                                  ; Returns mouse y
                                                                                ;-
                                                                                ;       Macro IsCanvas(_gadget_)
                                                                                ;          FindMapElement( widgets::gadgets( ), Str(_gadget_))
                                                                                ;       EndMacro
   Macro ChangeCurrentCanvas( _canvasID_ )
      If key::GetData(_canvasID_)
         widgets::Root( ) = key::GetData(_canvasID_)
      EndIf
   EndMacro
   
   
   ;-
   ;       ;-
   ;       Macro imageiDWidth( _img_id_ )
   ;          func::Getimagewidth( _img_id_ )
   ;       EndMacro
   ;       
   ;       Macro imageiDHeight( _img_id_ )
   ;          func::Getimageheight( _img_id_ )
   ;       EndMacro
   ;       
   ;       Macro ResizeimageiD( _img_id_, _width_, _height_ )
   ;          func::Setimagewidth( _img_id_, _width_ )
   ;          func::Setimageheight( _img_id_, _height_ )
   ;       EndMacro
   
   
   ;- ANCHORSMACRO
   Macro a_anchors( )
      widgets::mouse( )\anchors
   EndMacro
   Macro a_index( )
      widgets::a_anchors( )\index
   EndMacro
   Macro a_main( )
      widgets::a_anchors( )\main
   EndMacro
   Macro a_entered( )
      widgets::a_anchors( )\entered
   EndMacro
   Macro a_focused( )
      widgets::a_anchors( )\focused
   EndMacro
   ;
   Macro a_getsize( _this_ )
      DPIUnScaled(_this_\anchors\size)
   EndMacro
   Macro a_getpos( _this_ )
      DPIUnScaled(_this_\anchors\pos)
   EndMacro
   Macro a_setsize( _this_, _size_, _update_size_ = 1  )
      If _this_\anchors\size <> DPIScaled(_size_)
         _this_\anchors\size = DPIScaled(_size_)
         ;             _this_\bs - _this_\anchors\pos
         ;             _this_\anchors\pos = _this_\anchors\size / 2
         ;             _this_\bs + _this_\anchors\pos
         ;a_size( _this_\anchors\id, _this_\anchors\size, _this_\anchors\mode )
         If _update_size_
            Resize( _this_, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
         EndIf
      EndIf
   EndMacro
   Macro a_setpos( _this_, _position_, _update_position_ = 1 )
      If _this_\anchors\pos <> DPIScaled(_position_)
         _this_\bs - _this_\anchors\pos
         _this_\anchors\pos = DPIScaled(_position_)
         _this_\bs + _this_\anchors\pos 
         ;a_size( _this_\anchors\id, _this_\anchors\size, _this_\anchors\mode )
         If _update_position_
            Resize( _this_, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
         EndIf
      EndIf
   EndMacro
   
   Macro a_size( _address_, _size_, _mode_=0 )
      If _address_[#__a_left] ; left
         _address_[#__a_left]\width  = _size_
         _address_[#__a_left]\height = _size_
      EndIf
      If _address_[#__a_top] ; top
         _address_[#__a_top]\width  = _size_
         _address_[#__a_top]\height = _size_
      EndIf
      If _address_[#__a_right] ; right
         _address_[#__a_right]\width  = _size_
         _address_[#__a_right]\height = _size_
      EndIf
      If _address_[#__a_bottom] ; bottom
         _address_[#__a_bottom]\width  = _size_
         _address_[#__a_bottom]\height = _size_
      EndIf
      
      If _address_ <> mouse( )\selector
         If _mode_ & #__a_zoom = #__a_zoom
            If _address_[#__a_left_top] ; left&top
               _address_[#__a_left_top]\width  = _size_ * 2
               _address_[#__a_left_top]\height = _size_ * 2
            EndIf
            If _address_[#__a_right_top] ; right&top
               _address_[#__a_right_top]\width  = _size_ * 2
               _address_[#__a_right_top]\height = _size_ * 2
            EndIf
            If _address_[#__a_right_bottom] ; right&bottom
               _address_[#__a_right_bottom]\width  = _size_ * 2
               _address_[#__a_right_bottom]\height = _size_ * 2
            EndIf
            If _address_[#__a_left_bottom] ; left&bottom
               _address_[#__a_left_bottom]\width  = _size_ * 2
               _address_[#__a_left_bottom]\height = _size_ * 2
            EndIf
         Else
            If _address_[#__a_left_top] ; left&top
               _address_[#__a_left_top]\width  = _size_
               _address_[#__a_left_top]\height = _size_
            EndIf
            If _address_[#__a_right_top] ; right&top
               _address_[#__a_right_top]\width  = _size_
               _address_[#__a_right_top]\height = _size_
            EndIf
            If _address_[#__a_right_bottom] ; right&bottom
               _address_[#__a_right_bottom]\width  = _size_
               _address_[#__a_right_bottom]\height = _size_
            EndIf
            If _address_[#__a_left_bottom] ; left&bottom
               _address_[#__a_left_bottom]\width  = _size_
               _address_[#__a_left_bottom]\height = _size_
            EndIf
         EndIf
      EndIf
   EndMacro
   
   Macro a_move( _this_, _address_, _x_, _y_, _width_, _height_ )
      If _address_ And _this_ ; frame
         _address_\x      = _x_ + _this_\anchors\pos
         _address_\y      = _y_ + _this_\anchors\pos
         _address_\width  = _width_ - _this_\anchors\pos * 2
         _address_\height = _height_ - _this_\anchors\pos * 2
      EndIf
      
      If _address_ <> mouse( )\selector
         If _this_
            If _address_[#__a_moved]         ; moved
                                             ;                   If _this_\anchors\mode & #__a_zoom ; _this_\type = #__type_window
                                             ;                      _address_[#__a_moved]\x      = _x_ + _address_[#__a_left]\width
                                             ;                      _address_[#__a_moved]\y      = _y_ + _address_[#__a_top]\height
                                             ;                      _address_[#__a_moved]\width  = _width_ - ( _address_[#__a_left]\width + _address_[#__a_right]\width )
                                             ;                      _address_[#__a_moved]\height = ( _this_\fs + _this_\fs[2] + _this_\fs[4] ) - _address_[#__a_top]\height / 2
                                             ;                   Else
               If _this_\container
                  _address_[#__a_moved]\x      = _x_
                  _address_[#__a_moved]\y      = _y_
                  _address_[#__a_moved]\width  = _this_\anchors\size * 2
                  _address_[#__a_moved]\height = _this_\anchors\size * 2
               EndIf
               ;                   EndIf
            EndIf
         EndIf
         
         If _this_ And _this_\anchors\mode & #__a_zoom = #__a_zoom
            If _address_[#__a_left] ; left
               _address_[#__a_left]\x      = _x_
               _address_[#__a_left]\y      = _y_ + _address_[#__a_left_top]\height
               _address_[#__a_left]\height = _this_\height - ( _address_[#__a_left_top]\height + _address_[#__a_left_bottom]\height )
            EndIf
            If _address_[#__a_top] ; top
               _address_[#__a_top]\x     = _x_ + _address_[#__a_left_top]\width
               _address_[#__a_top]\y     = _y_
               _address_[#__a_top]\width = _this_\width - ( _address_[#__a_left_top]\width + _address_[#__a_right_top]\width )
            EndIf
            If _address_[#__a_right] ; right
               _address_[#__a_right]\x      = _x_ + _width_ - _address_[#__a_right]\width
               _address_[#__a_right]\y      = _y_ + _address_[#__a_right_top]\height
               _address_[#__a_right]\height = _this_\height - ( _address_[#__a_right_top]\height + _address_[#__a_right_bottom]\height )
            EndIf
            If _address_[#__a_bottom] ; bottom
               _address_[#__a_bottom]\x     = _x_ + _address_[#__a_left_bottom]\width
               _address_[#__a_bottom]\y     = _y_ + _height_ - _address_[#__a_bottom]\height
               _address_[#__a_bottom]\width = _this_\width - ( _address_[#__a_left_bottom]\width + _address_[#__a_right_bottom]\width )
            EndIf
         Else
            If _address_[#__a_left] ; left
               _address_[#__a_left]\x = _x_
               _address_[#__a_left]\y = _y_ + ( _height_ - _address_[#__a_left]\height ) / 2
            EndIf
            If _address_[#__a_top] ; top
               _address_[#__a_top]\x = _x_ + ( _width_ - _address_[#__a_top]\width ) / 2
               _address_[#__a_top]\y = _y_
            EndIf
            If _address_[#__a_right] ; right
               _address_[#__a_right]\x = _x_ + ( _width_ - _address_[#__a_right]\width )
               _address_[#__a_right]\y = _y_ + ( _height_ - _address_[#__a_right]\height ) / 2
            EndIf
            If _address_[#__a_bottom] ; bottom
               _address_[#__a_bottom]\x = _x_ + ( _width_ - _address_[#__a_bottom]\width ) / 2
               _address_[#__a_bottom]\y = _y_ + ( _height_ - _address_[#__a_bottom]\height )
            EndIf
         EndIf
         
         If _address_[#__a_left_top] ; left&top
            _address_[#__a_left_top]\x = _x_
            _address_[#__a_left_top]\y = _y_
         EndIf
         If _address_[#__a_right_top] ; right&top
            _address_[#__a_right_top]\x = _x_ + ( _width_ - _address_[#__a_right_top]\width )
            _address_[#__a_right_top]\y = _y_
         EndIf
         If _address_[#__a_left_bottom] ; left&bottom
            _address_[#__a_left_bottom]\x = _x_
            _address_[#__a_left_bottom]\y = _y_ + ( _height_ - _address_[#__a_left_bottom]\height )
         EndIf
         If _address_[#__a_right_bottom] ; right&bottom
            _address_[#__a_right_bottom]\x = _x_ + ( _width_ - _address_[#__a_right_bottom]\width )
            _address_[#__a_right_bottom]\y = _y_ + ( _height_ - _address_[#__a_right_bottom]\height )
         EndIf
      EndIf
      
      If a_focused( )
         a_line( a_focused( ) )
      EndIf
   EndMacro
   
   Macro a_line( _this_ )
      If a_anchors( ) And _this_\parent And 
         a_anchors( )\line[#__a_line_left] And
         a_anchors( )\line[#__a_line_right] And
         a_anchors( )\line[#__a_line_top] And
         a_anchors( )\line[#__a_line_bottom]
         
         ;\\ line default size&pos
         a_anchors( )\line[#__a_line_left]\width  = DPIScaled(1)
         a_anchors( )\line[#__a_line_left]\height = 0
         a_anchors( )\line[#__a_line_left]\x      = _this_\frame_x( )
         a_anchors( )\line[#__a_line_left]\y      = _this_\frame_y( )
         
         a_anchors( )\line[#__a_line_top]\height = a_anchors( )\line[#__a_line_left]\width
         a_anchors( )\line[#__a_line_top]\width  = 0
         a_anchors( )\line[#__a_line_top]\x      = _this_\frame_x( )
         a_anchors( )\line[#__a_line_top]\y      = _this_\frame_y( )
         
         a_anchors( )\line[#__a_line_right]\width  = a_anchors( )\line[#__a_line_left]\width
         a_anchors( )\line[#__a_line_right]\height = 0
         a_anchors( )\line[#__a_line_right]\x      = ( _this_\frame_x( ) + _this_\frame_width( ) ) - a_anchors( )\line[#__a_line_right]\width
         a_anchors( )\line[#__a_line_right]\y      = _this_\frame_y( )
         
         a_anchors( )\line[#__a_line_bottom]\height = a_anchors( )\line[#__a_line_left]\width
         a_anchors( )\line[#__a_line_bottom]\width  = 0
         a_anchors( )\line[#__a_line_bottom]\x      = _this_\frame_x( )
         a_anchors( )\line[#__a_line_bottom]\y      = ( _this_\frame_y( ) + _this_\frame_height( ) ) - a_anchors( )\line[#__a_line_bottom]\height
         
         ;\\
         If StartEnum( _this_\parent )
            ;
            If Widget()\anchors And Not Widget()\mask & #__mask_hidden And Widget() <> _this_ And Widget()\level = _this_\level
               ;\\ left-line
               If _this_\frame_x( ) = Widget()\frame_x( )
                  If a_anchors( )\line[#__a_line_left]\y > Widget()\frame_y( )
                     a_anchors( )\line[#__a_line_left]\y = Widget()\frame_y( )
                  EndIf
                  If _this_\frame_y( ) + _this_\frame_height( ) < Widget()\frame_y( ) + Widget()\frame_height( )
                     If a_anchors( )\line[#__a_line_left]\height < Widget()\frame_y( ) + Widget()\frame_height( ) 
                        a_anchors( )\line[#__a_line_left]\height = Widget()\frame_y( ) + Widget()\frame_height( )
                     EndIf
                  Else
                     If a_anchors( )\line[#__a_line_left]\height < _this_\frame_y( ) + _this_\frame_height( ) 
                        a_anchors( )\line[#__a_line_left]\height = _this_\frame_y( ) + _this_\frame_height( )
                     EndIf
                  EndIf
               EndIf
               ;
               ;\\ top-line
               If _this_\frame_y( ) = Widget()\frame_y( )
                  If a_anchors( )\line[#__a_line_top]\x > Widget()\frame_x( )
                     a_anchors( )\line[#__a_line_top]\x = Widget()\frame_x( )
                  EndIf
                  If _this_\frame_x( ) + _this_\frame_width( ) <= Widget()\frame_x( ) + Widget()\frame_width( ) 
                     If a_anchors( )\line[#__a_line_top]\width < Widget()\frame_x( ) + Widget()\frame_width( ) 
                        a_anchors( )\line[#__a_line_top]\width = Widget()\frame_x( ) + Widget()\frame_width( )
                     EndIf
                  Else
                     If a_anchors( )\line[#__a_line_top]\width < _this_\frame_x( ) + _this_\frame_width( ) 
                        a_anchors( )\line[#__a_line_top]\width = _this_\frame_x( ) + _this_\frame_width( )
                     EndIf
                  EndIf
               EndIf
               ;
               ;\\ right-line
               If _this_\frame_x( ) + _this_\frame_width( ) = Widget()\frame_x( ) + Widget()\frame_width( )
                  If a_anchors( )\line[#__a_line_right]\y > Widget()\frame_y( )
                     a_anchors( )\line[#__a_line_right]\y = Widget()\frame_y( )
                  EndIf
                  If _this_\frame_y( ) + _this_\frame_height( ) < Widget()\frame_y( ) + Widget()\frame_height( )
                     If a_anchors( )\line[#__a_line_right]\height < Widget()\frame_y( ) + Widget()\frame_height( ) 
                        a_anchors( )\line[#__a_line_right]\height = Widget()\frame_y( ) + Widget()\frame_height( )
                     EndIf
                  Else
                     If a_anchors( )\line[#__a_line_right]\height < _this_\frame_y( ) + _this_\frame_height( ) 
                        a_anchors( )\line[#__a_line_right]\height = _this_\frame_y( ) + _this_\frame_height( )
                     EndIf
                  EndIf
               EndIf
               ;
               ;\\ bottom-line
               If _this_\frame_y( ) + _this_\frame_height( ) = Widget()\frame_y( ) + Widget()\frame_height( )
                  If a_anchors( )\line[#__a_line_bottom]\x > Widget()\frame_x( )
                     a_anchors( )\line[#__a_line_bottom]\x = Widget()\frame_x( )
                  EndIf
                  If _this_\frame_x( ) + _this_\frame_width( ) < Widget()\frame_x( ) + Widget()\frame_width( )
                     If a_anchors( )\line[#__a_line_bottom]\width < Widget()\frame_x( ) + Widget()\frame_width( ) 
                        a_anchors( )\line[#__a_line_bottom]\width = Widget()\frame_x( ) + Widget()\frame_width( )
                     EndIf
                  Else
                     If a_anchors( )\line[#__a_line_bottom]\width < _this_\frame_x( ) + _this_\frame_width( ) 
                        a_anchors( )\line[#__a_line_bottom]\width = _this_\frame_x( ) + _this_\frame_width( )
                     EndIf
                  EndIf
               EndIf
            EndIf
            ;
            StopEnum( )
            ;
            If a_anchors( )\line[#__a_line_left]\height > a_anchors( )\line[#__a_line_left]\y
               a_anchors( )\line[#__a_line_left]\height - a_anchors( )\line[#__a_line_left]\y
            EndIf
            If a_anchors( )\line[#__a_line_top]\width > a_anchors( )\line[#__a_line_top]\x
               a_anchors( )\line[#__a_line_top]\width - a_anchors( )\line[#__a_line_top]\x
            EndIf
            If a_anchors( )\line[#__a_line_right]\height > a_anchors( )\line[#__a_line_right]\y
               a_anchors( )\line[#__a_line_right]\height - a_anchors( )\line[#__a_line_right]\y
            EndIf
            If a_anchors( )\line[#__a_line_bottom]\width > a_anchors( )\line[#__a_line_bottom]\x
               a_anchors( )\line[#__a_line_bottom]\width - a_anchors( )\line[#__a_line_bottom]\x
            EndIf
         EndIf
      EndIf
      
   EndMacro
   
   ;-
   ;-  FONT
   Macro GetFontID( _address_ )
      _address_\fontID    
   EndMacro
   Macro SetFontID( _address_, _font_ID_ )
      _address_\fontID = _font_ID_ 
   EndMacro
   Macro CurrentFontID( )
      __GUI\fontID    
   EndMacro
   Macro ChangeFontID( _address_, _font_ID_ )
      Bool( GetFontID( _address_ ) <> _font_ID_ )
      SetFontID( _address_, _font_ID_ )
   EndMacro
   
   ;-
   Macro Clip( _address_, _mode_ = [#__c_draw] )
      CompilerIf Not ( #PB_Compiler_OS = #PB_OS_MacOS And Not Defined( Draw, #PB_Module ))
         ClipOutput( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_ )
      CompilerEndIf
   EndMacro
   
   Macro draw_mode_alpha_( _mode_ )
      widgets::__draw_mode( _mode_ | #PB_2DDrawing_AlphaBlend )
   EndMacro
   
   Macro __draw_mode( _mode_ )
      DrawingMode( _mode_ )
   EndMacro
   
   Macro draw_box_( _x_, _y_, _width_, _height_, _color_ = $ffffffff )
      Box( _x_, _y_, _width_, _height_, _color_ )
   EndMacro
   
   Macro draw_roundbox_( _x_, _y_, _width_, _height_, _round_x_, _round_y_, _color_ = $ffffffff )
      If _round_x_ Or _round_y_
         RoundBox( _x_, _y_, _width_, _height_, _round_x_, _round_y_, _color_ ) ; bug _round_y_ = 0
      Else
         draw_box_( _x_, _y_, _width_, _height_, _color_ )
      EndIf
   EndMacro
   
   Macro draw_image_( _this_, _x_, _y_, _mode_ = )
      ; draw_mode_alpha_( #PB_2DDrawing_Transparent )
      DrawAlphaImage( _this_\picture#_mode_\imageID, _x_ + _this_\picture#_mode_\x + _this_\scroll_x( ), _y_ + _this_\picture#_mode_\y + _this_\scroll_y( ), _this_\color\ialpha )
   EndMacro
   
   Macro draw_font( _address_, _font_id_ = 0, _update_ = 0, draw_font=0 )
      If _font_id_
         If Not GetFontID( _address_ )
            SetFontID( _address_, _font_id_ )
            
            _address_\text\width = 0
            _address_\text\height = 0
         EndIf
      EndIf
      ;
      If draw_font
         CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
            If CurrentFontID( )
               DrawingFont( CurrentFontID( ))
            EndIf
         CompilerEndIf
      EndIf
      
      If GetFontID( _address_ ) And
         CurrentFontID( ) <> GetFontID( _address_ )
         ; Debug " draw current font - " + #PB_Compiler_Procedure + " " +  Str(_address_) + " " + CurrentFontID( ) +" "+ GetFontID( _address_ )
         CurrentFontID( ) = GetFontID( _address_ )
         
         DrawingFont( CurrentFontID( ))
         
         _address_\text\width = 0
         _address_\text\height = 0
      EndIf
      ;
      If Not ( _address_\text\width And _address_\text\height ) Or _update_
         If _address_\text\Str(0)
            ;                CompilerIf #PB_Compiler_OS = #PB_OS_Windows ; BUG
            ;                   _address_\text\width = TextWidth( RemoveString( _address_\text\str(0), #LF$ ))
            ;                CompilerElse
            _address_\text\width = TextWidth( _address_\text\Str(0) )
            ;                CompilerEndIf
         EndIf
         
         _address_\text\height = TextHeight( "A" ) - Bool(#PB_Compiler_OS=#PB_OS_MacOS)
         ;;Debug ""+*this\class +" "+ _address_\index +" "+ _address_\text\height
         ; set rotate text value
         ; _address_\text\rotate = Bool( _address_\text\invert ) * 180 + Bool( _address_\text\vertical ) * 90
         
      EndIf
   EndMacro
   
   ;-
   Macro __draw_up_arrow(_x_, _y_, _size_, _back_color_, _frame_color_)
      ;                                                                                                                                                      ;
      ;                                                                                                                                                      ;
      Line(_x_ + 7, _y_, 2, 1, _frame_color_)                                                                                                                  ; 0,0,0,0,0,0,0,0,0,0
      Plot(_x_ + 6, _y_ + 1, _frame_color_ ) : Line(_x_ + 7, _y_ + 1, 2, 1, _back_color_) : Plot(_x_ + 9, _y_ + 1, _frame_color_ )                             ; 0,0,0,0,1,1,0,0,0,0
      Plot(_x_ + 5, _y_ + 2, _frame_color_ ) : Line(_x_ + 6, _y_ + 2, 4, 1, _back_color_) : Plot(_x_ + 10, _y_ + 2, _frame_color_ )                            ; 0,0,0,1,1,1,1,0,0,0
      Plot(_x_ + 4, _y_ + 3, _frame_color_ ) : Line(_x_ + 5, _y_ + 3, 6, 1, _back_color_) : Plot(_x_ + 11, _y_ + 3, _frame_color_ )                            ; 0,0,1,1,1,1,1,1,0,0
      Line(_x_ + 3, _y_ + 4, _size_ / 3 - 1, 1, _frame_color_) : Line(_x_ + 7, _y_ + 4, 2, 1, _back_color_) : Line(_x_ + _size_ / 2 + 1, _y_ + 4, _size_ / 3 - 1 , 1, _frame_color_) ; 0,0,0,0,1,1,0,0,0,0
      Plot(_x_ + _size_ / 2 - 2, _y_ + 5, _frame_color_ ) : Line(_x_ + 7, _y_ + 5, 2, 1, _back_color_) : Plot(_x_ + _size_ / 2 + 1, _y_ + 5, _frame_color_ )                         ; 0,0,0,0,1,1,0,0,0,0
                                                                                                                                                                                     ;                                                                                                                                                      ;
                                                                                                                                                                                     ;                                                                                                                                                      ;
   EndMacro
   Macro __draw_down_arrow(_x_, _y_, _size_, _back_color_, _frame_color_)
      ;                                                                                                                                                      ;
      ;                                                                                                                                                      ;
      Plot(_x_ + _size_ / 2 - 2, _y_ + 4, _frame_color_ ) : Line(_x_ + 7, _y_ + 4, 2, 1, _back_color_) : Plot(_x_ + _size_ / 2 + 1, _y_ + 4, _frame_color_ )                     ; 0,0,0,0,1,1,0,0,0,0
      Line(_x_ + 3, _y_ + 5, _size_ / 3 - 1, 1, _frame_color_) : Line(_x_ + 7, _y_ + 5, 2, 1, _back_color_) : Line(_x_ + _size_ / 2 + 1, _y_ + 5, _size_ / 3 - 1, 1, _frame_color_)  ; 0,0,0,0,1,1,0,0,0,0
      Plot(_x_ + 4, _y_ + 6, _frame_color_ ) : Line(_x_ + 5, _y_ + 6, 6, 1, _back_color_) : Plot(_x_ + 11, _y_ + 6, _frame_color_ )                                                  ; 0,0,1,1,1,1,1,1,0,0
      Plot(_x_ + 5, _y_ + 7, _frame_color_ ) : Line(_x_ + 6, _y_ + 7, 4, 1, _back_color_) : Plot(_x_ + 10, _y_ + 7, _frame_color_ )                                                  ; 0,0,0,1,1,1,1,0,0,0
      Plot(_x_ + 6, _y_ + 8, _frame_color_ ) : Line(_x_ + 7, _y_ + 8, 2, 1, _back_color_) : Plot(_x_ + 9, _y_ + 8, _frame_color_ )                                                   ; 0,0,0,0,1,1,0,0,0,0
      Line(_x_ + 7, _y_ + 9, 2, 1, _frame_color_)                                                                                                                                    ; 0,0,0,0,0,0,0,0,0,0
                                                                                                                                                                                     ;                                                                                                                                                      ;
                                                                                                                                                                                     ;                                                                                                                                                      ;
   EndMacro
   Macro __draw_left_arrow(_x_, _y_, _size_, _back_color_, _frame_color_)
      ;                                                                                                                                                      ; 0,0,0,0,0,0
      ;                                                                                                                                                      ; 0,0,0,0,0,0
      Line(_x_, _y_ + 7, 1, 2, _frame_color_)                                                                                                                  ; 0,0,1,0,0,0
      Plot(_x_ + 1, _y_ + 6, _frame_color_ ) : Line(_x_ + 1, _y_ + 7, 1, 2, _back_color_) : Plot(_x_ + 1, _y_ + 9, _frame_color_ )                             ; 0,0,1,1,0,0
      Plot(_x_ + 2, _y_ + 5, _frame_color_ ) : Line(_x_ + 2, _y_ + 6, 1, 4, _back_color_) : Plot(_x_ + 2, _y_ + 10, _frame_color_ )                            ; 1,1,1,1,1,0
      Plot(_x_ + 3, _y_ + 4, _frame_color_ ) : Line(_x_ + 3, _y_ + 5, 1, 6, _back_color_) : Plot(_x_ + 3, _y_ + 11, _frame_color_ )                            ; 1,1,1,1,1,0
      Line(_x_ + 4, _y_ + 3, 1, _size_ / 3 - 1, _frame_color_) : Line(_x_ + 4, _y_ + 7, 1, 2, _back_color_) : Line(_x_ + 4, _y_ + _size_ / 2 + 1, 1, _size_ / 3 - 1, _frame_color_)  ; 0,0,1,1,0,0
      Plot(_x_ + 5, _y_ + _size_ / 2 - 2, _frame_color_ ) : Line(_x_ + 5, _y_ + 7, 1, 2, _back_color_) : Plot(_x_ + 5, _y_ + _size_ / 2 + 1, _frame_color_ )                         ; 0,0,1,0,0,0
                                                                                                                                                                                     ;                                                                                                                                                      ; 0,0,0,0,0,0
                                                                                                                                                                                     ;                                                                                                                                                      ; 0,0,0,0,0,0
   EndMacro
   Macro __draw_right_arrow(_x_, _y_, _size_, _back_color_, _frame_color_)
      ;                                                                                                                                                      ; 0,0,0,0,0,0
      ;                                                                                                                                                      ; 0,0,0,0,0,0
      Plot(_x_ + 4, _y_ + _size_ / 2 - 2, _frame_color_ ) : Line(_x_ + 4, _y_ + 7, 1, 2, _back_color_) : Plot(_x_ + 4, _y_ + _size_ / 2 + 1, _frame_color_ )                     ; 0,0,0,1,0,0
      Line(_x_ + 5, _y_ + 3, 1, _size_ / 3 - 1, _frame_color_) : Line(_x_ + 5, _y_ + 7, 1, 2, _back_color_) : Line(_x_ + 5, _y_ + _size_ / 2 + 1, 1, _size_ / 3 - 1, _frame_color_)  ; 0,0,1,1,0,0
      Plot(_x_ + 6, _y_ + 4, _frame_color_ ) : Line(_x_ + 6, _y_ + 5, 1, 6, _back_color_) : Plot(_x_ + 6, _y_ + 11, _frame_color_ )                                                  ; 0,1,1,1,1,1
      Plot(_x_ + 7, _y_ + 5, _frame_color_ ) : Line(_x_ + 7, _y_ + 6, 1, 4, _back_color_) : Plot(_x_ + 7, _y_ + 10, _frame_color_ )                                                  ; 0,1,1,1,1,1
      Plot(_x_ + 8, _y_ + 6, _frame_color_ ) : Line(_x_ + 8, _y_ + 7, 1, 2, _back_color_) : Plot(_x_ + 8, _y_ + 9, _frame_color_ )                                                   ; 0,0,1,1,0,0
      Line(_x_ + 9, _y_ + 7, 1, 2, _frame_color_)                                                                                                                                    ; 0,0,0,1,0,0
                                                                                                                                                                                     ;                                                                                                                                                      ; 0,0,0,0,0,0
                                                                                                                                                                                     ;                                                                                                                                                      ; 0,0,0,0,0,0
   EndMacro
   Macro __draw_arrows( _address_, _direction_ )
      Draw_Arrow( _direction_,
                  _address_\x + ( _address_\width - _address_\arrow\size ) / 2,
                  _address_\y + ( _address_\height - _address_\arrow\size ) / 2, 
                  _address_\arrow\size, _address_\arrow\type, 0,
                  _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
   EndMacro
   
   ;-
   Macro __draw_gradient( _vertical_, _address_, _x_,_y_, _state_, _round_ = 0, _alpha_ = 255, _mode_ = )
      BackColor( _address_\color\fore[_state_] & $FFFFFF | _address_\AlphaState24( ) )
      FrontColor( _address_\color\back[_state_] & $FFFFFF | _address_\AlphaState24( ) )
      
      If _vertical_  ; _address_\vertical
         LinearGradient( (_x_+_address_\x#_mode_), (_y_+_address_\y#_mode_), ( (_x_+_address_\x#_mode_) + _address_\width#_mode_ ), (_y_+_address_\y#_mode_) )
      Else
         LinearGradient( (_x_+_address_\x#_mode_), (_y_+_address_\y#_mode_), (_x_+_address_\x#_mode_), ( (_y_+_address_\y#_mode_) + _address_\height#_mode_ ))
      EndIf
      
      If _round_
         draw_roundbox_( (_x_+_address_\x#_mode_), (_y_+_address_\y#_mode_), _address_\width#_mode_, _address_\height#_mode_, _round_, _round_ )
      Else
         draw_roundbox_( (_x_+_address_\x#_mode_), (_y_+_address_\y#_mode_), _address_\width#_mode_, _address_\height#_mode_, _address_\round, _address_\round )
      EndIf
      
      BackColor( #PB_Default )
      FrontColor( #PB_Default ) ; bug
   EndMacro
   
   Macro __draw_plus( _address_, _plus_, _size_ = DPIScaled( #__draw_plus_size ))
      Line(_address_\x + (_address_\width - _size_) / 2, _address_\y + (_address_\height - 1) / 2, _size_, 1, _address_\color\front[_address_\ColorState( )])
      If _plus_
         Line(_address_\x + (_address_\width - 1) / 2, _address_\y + (_address_\height - _size_) / 2, 1, _size_, _address_\color\front[_address_\ColorState( )])
      EndIf
   EndMacro
   
   Macro __draw_checkbox( _type_, _address_, _x_,_y_,_round_, _color_fore_ = $FFFFFFFF, _color_fore2_ = $FFE9BA81, _color_back_ = $80E2E2E2, _color_back2_ = $FFE89C3D, _color_frame_ = $80C8C8C8, _color_frame2_ = $FFDC9338, _alpha_ = 255, size=4 )
      draw_mode_alpha_( #PB_2DDrawing_Gradient )
      LinearGradient( (_x_+_address_\x), (_y_+_address_\y), (_x_+_address_\x), ( (_y_+_address_\y) + _address_\height ))
      
      If _address_\checked
         BackColor( _color_fore2_ & $FFFFFF | _alpha_ << 24 )
         FrontColor( _color_back2_ & $FFFFFF | _alpha_ << 24 )
      Else
         BackColor( _color_fore_ & $FFFFFF | _alpha_ << 24 )
         FrontColor( _color_back_ & $FFFFFF | _alpha_ << 24 )
      EndIf
      
      draw_roundbox_( (_x_+_address_\x), (_y_+_address_\y), _address_\width, _address_\height, _round_, _round_ )
      
      If _type_ = 4
         FrontColor( $ff000000 & $FFFFFF | _alpha_ << 24 )
         BackColor( $ff000000 & $FFFFFF | _alpha_ << 24 )
         
         Line( (_x_+_address_\x) + 1 + ( _address_\width - 6 ) / 2, (_y_+_address_\y) + ( _address_\height - 6 ) / 2, 6, 6 )
         Line( (_x_+_address_\x) + ( _address_\width - 6 ) / 2, (_y_+_address_\y) + ( _address_\height - 6 ) / 2, 6, 6 )
         
         Line( (_x_+_address_\x) - 1 + 6 + ( _address_\width - 6 ) / 2, (_y_+_address_\y) + ( _address_\height - 6 ) / 2, - 6, 6 )
         Line( (_x_+_address_\x) + 6 + ( _address_\width - 6 ) / 2, (_y_+_address_\y) + ( _address_\height - 6 ) / 2, - 6, 6 )
      Else
         FrontColor( _color_fore_ & $FFFFFF | _alpha_ << 24 )
         BackColor( _color_fore_ & $FFFFFF | _alpha_ << 24 )
         
         If _address_\checked
            If _type_ = 1
               If _address_\width % 2
                  draw_roundbox_( (_x_+_address_\x) + ( _address_\width - DPIScaled(4) ) / 2, (_y_+_address_\y) + ( _address_\height - DPIScaled(4) ) / 2, DPIScaled(5), DPIScaled(5), 4, 4 )
               Else
                  draw_roundbox_( (_x_+_address_\x) + ( _address_\width - DPIScaled(4) ) / 2, (_y_+_address_\y) + ( _address_\height - DPIScaled(4) ) / 2, DPIScaled(4), DPIScaled(4), 4, 4 )
               EndIf
            Else
               If _address_\checked = - 1
                  If _address_\width % 2
                     draw_box_( (_x_+_address_\x) + ( _address_\width - DPIScaled(4) ) / 2, (_y_+_address_\y) + ( _address_\height - DPIScaled(4) ) / 2, DPIScaled(5), DPIScaled(5) )
                  Else
                     draw_box_( (_x_+_address_\x) + ( _address_\width - DPIScaled(4) ) / 2, (_y_+_address_\y) + ( _address_\height - DPIScaled(4) ) / 2, DPIScaled(4), DPIScaled(4) )
                  EndIf
               Else
                  _box_x_ = _address_\width / 2 - 4
                  _box_y_ = _box_x_ + Bool( _address_\width % 2 )
                  
                  LineXY(( (_x_+_address_\x) + 1 + _box_x_ ), ( (_y_+_address_\y) + 4 + _box_y_ ), ( (_x_+_address_\x) + 2 + _box_x_ ), ( (_y_+_address_\y) + 5 + _box_y_ )) ; Левая линия
                  LineXY(( (_x_+_address_\x) + 1 + _box_x_ ), ( (_y_+_address_\y) + 5 + _box_y_ ), ( (_x_+_address_\x) + 2 + _box_x_ ), ( (_y_+_address_\y) + 6 + _box_y_ )) ; Левая линия
                  
                  LineXY(( (_x_+_address_\x) + 6 + _box_x_ ), ( (_y_+_address_\y) + 0 + _box_y_ ), ( (_x_+_address_\x) + 3 + _box_x_ ), ( (_y_+_address_\y) + 6 + _box_y_ )) ; правая линия
                  LineXY(( (_x_+_address_\x) + 7 + _box_x_ ), ( (_y_+_address_\y) + 0 + _box_y_ ), ( (_x_+_address_\x) + 4 + _box_x_ ), ( (_y_+_address_\y) + 6 + _box_y_ )) ; правая линия
               EndIf
            EndIf
         EndIf
         
      EndIf
      
      draw_mode_alpha_( #PB_2DDrawing_Outlined )
      
      If _address_\checked
         FrontColor( _color_frame2_ & $FFFFFF | _alpha_ << 24 )
      Else
         FrontColor( _color_frame_ & $FFFFFF | _alpha_ << 24 )
      EndIf
      
      draw_roundbox_( (_x_+_address_\x), (_y_+_address_\y), _address_\width, _address_\height, _round_, _round_, _color_frame_ & $FFFFFF | _alpha_ << 24 )
   EndMacro
   
   
   ;-
   Macro __draw_rotatedtext( _address_, _x_,_y_, _rotate_, _color_, _under_line_size_ = 0, _i_=0 )
      ; under line
      If _under_line_size_
         Box( _x_ + _address_\text\x, 
              _y_ + _address_\text\y + _address_\text\height - _under_line_size_ - 1, _address_\text\width, _under_line_size_, _color_ )
      EndIf
      
      DrawRotatedText( _x_ + _address_\text\x, 
                       _y_ + _address_\text\y, _address_\text\Str(_i_), _rotate_, _color_ ) 
      
   EndMacro
   
   Macro __draw_box( _address_, _color_type_, _mode_ = )
      draw_roundbox_( _address_\x#_mode_, _address_\y#_mode_, _address_\width#_mode_, _address_\height#_mode_,
                      _address_\round, _address_\round, _address_\_color_type_[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
   EndMacro
   
   Macro __draw_roundbox( _address_, _color_type_ )
      ;__draw_box( _address_, _color_type_)
      If Not _address_\mask & #__mask_hidden
         draw_roundbox_( _address_\x, _address_\y, _address_\width, _address_\height, _address_\round, _address_\round, _address_\_color_type_[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
         draw_roundbox_( _address_\x, _address_\y + 1, _address_\width, _address_\height - 2, _address_\round, _address_\round, _address_\_color_type_[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
         draw_roundbox_( _address_\x + 1, _address_\y, _address_\width - 2, _address_\height, _address_\round, _address_\round, _address_\_color_type_[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
      EndIf
   EndMacro
   
   Macro __draw_close_button( _address_, _size_ )
      ; close button
      If Not _address_\mask & #__mask_hidden
         If _address_\ColorState( )
            Line( _address_\x + 1 + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
            Line( _address_\x + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
            
            Line( _address_\x - 1 + _size_ + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
            Line( _address_\x + _size_ + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
         EndIf
         
         __draw_roundbox( _address_, color\frame )
      EndIf
   EndMacro
   
   Macro __draw_maximize_button( _address_, _size_ )
      If Not _address_\mask & #__mask_hidden
         If _address_\ColorState( )
            Line( _address_\x + 2 + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
            Line( _address_\x + 1 + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
            
            Line( _address_\x + 1 + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
            Line( _address_\x + 2 + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
         EndIf
         
         __draw_roundbox( _address_, color\frame )
      EndIf
   EndMacro
   
   Macro __draw_minimize_button( _address_, _size_ )
      If Not _address_\mask & #__mask_hidden
         If _address_\ColorState( )
            Line( _address_\x + 1 + ( _address_\width ) / 2 - _size_, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
            Line( _address_\x + 0 + ( _address_\width ) / 2 - _size_, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
            
            Line( _address_\x - 1 + ( _address_\width ) / 2 + _size_, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
            Line( _address_\x - 2 + ( _address_\width ) / 2 + _size_, _address_\y + ( _address_\height - _size_ ) / 2, - _size_, _size_, _address_\color\front[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
         EndIf
         
         __draw_roundbox( _address_, color\frame )
      EndIf
   EndMacro
   
   Macro __draw_help_button( _address_, _size_ )
      If Not _address_\mask & #__mask_hidden
         draw_roundbox_( _address_\x, _address_\y, _address_\width, _address_\height,
                         _address_\round, _address_\round, _address_\color\frame[_address_\ColorState( )] & $FFFFFF | _address_\AlphaState24( ) )
      EndIf
   EndMacro
   
   ;-
   Macro __draw_option_button( _address_, _size_, _color_ )
      If _address_\round > 2
         If _address_\width % 2
            draw_roundbox_( _address_\x + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_ + 1, _size_ + 1, _size_ + 1, _size_ + 1, _color_ )
         Else
            draw_roundbox_( _address_\x + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_, _size_, _size_, _size_, _color_ )
         EndIf
      Else
         If _address_\width % 2
            draw_roundbox_( _address_\x + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_ + 1, _size_ + 1, 1, 1, _color_ )
         Else
            draw_roundbox_( _address_\x + ( _address_\width - _size_ ) / 2, _address_\y + ( _address_\height - _size_ ) / 2, _size_ + 1, _size_ + 1, 1, 1, _color_ )
         EndIf
      EndIf
   EndMacro
   
   Macro __draw_check_button( _address_, _size_, _color_ )
      LineXY(( _address_\x + 0 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 4 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 1 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 5 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; Левая линия
      LineXY(( _address_\x + 0 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 5 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 1 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 6 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; Левая линия
      
      LineXY(( _address_\x + 5 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 0 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 2 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 6 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; правая линия
      LineXY(( _address_\x + 6 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 0 + ( _address_\height - _size_ ) / 2 ), ( _address_\x + 3 + ( _address_\width - _size_ ) / 2 ), ( _address_\y + 6 + ( _address_\height - _size_ ) / 2 ), _color_ ) ; правая линия
   EndMacro
   
   Macro __draw_bar_buttons( _this_ )
      ; background buttons draw
      If Not _this_\bar\button[1]\mask & #__mask_hidden
         If _this_\bar\button[1]\color\fore <> - 1
            draw_mode_alpha_( #PB_2DDrawing_Gradient )
            __draw_gradient(_this_\bar\vertical, _this_\bar\button[1], 0,0, _this_\bar\button[1]\ColorState( ))
         Else
            draw_mode_alpha_( #PB_2DDrawing_Default )
            __draw_box(_this_\bar\button[1], color\back)
            ; draw_roundbox_( _this_\bar\button[1]\x, _this_\bar\button[1]\y, _this_\bar\button[1]\width, _this_\bar\button[1]\height, _this_\bar\button[1]\round, _this_\bar\button[1]\round, _this_\bar\button[1]\color\frame[_this_\bar\button[1]\ColorState( )] & $FFFFFF | _this_\bar\button[1]\AlphaState24( ) )
         EndIf
      EndIf
      If Not _this_\bar\button[2]\mask & #__mask_hidden
         If _this_\bar\button[2]\color\fore <> - 1
            draw_mode_alpha_( #PB_2DDrawing_Gradient )
            __draw_gradient(_this_\bar\vertical, _this_\bar\button[2], 0,0, _this_\bar\button[2]\ColorState( ))
         Else
            draw_mode_alpha_( #PB_2DDrawing_Default )
            __draw_box(_this_\bar\button[2], color\back)
            ; draw_roundbox_( _this_\bar\button[2]\x, _this_\bar\button[2]\y, _this_\bar\button[2]\width, _this_\bar\button[2]\height, _this_\bar\button[2]\round, _this_\bar\button[2]\round, _this_\bar\button[2]\color\frame[_this_\bar\button[2]\ColorState( )] & $FFFFFF | _this_\bar\button[2]\AlphaState24( ) )
         EndIf
      EndIf
      
      draw_mode_alpha_( #PB_2DDrawing_Outlined )
      
      ;
      If _this_\type = #__type_Scroll
         If _this_\bar\vertical
            If (_this_\bar\page\len + Bool(_this_\round ) * (_this_\frame_width( ) / 4 )) = _this_\frame_height( )
               Line(_this_\frame_x( ), _this_\frame_y( ), 1, _this_\bar\page\len + 1, _this_\color\front & $FFFFFF | _this_\AlphaState24( ) ) ; $FF000000 ) ;
            Else
               Line(_this_\frame_x( ), _this_\frame_y( ) + _this_\bar\button[1]\round, 1, _this_\frame_height( ) - _this_\bar\button[1]\round - _this_\bar\button[2]\round, _this_\color\front & $FFFFFF | _this_\AlphaState24( ) ) ; $FF000000 ) ;
            EndIf
         Else
            If (_this_\bar\page\len + Bool(_this_\round ) * (_this_\frame_height( ) / 4 )) = _this_\frame_width( )
               Line(_this_\frame_x( ), _this_\frame_y( ), _this_\bar\page\len + 1, 1, _this_\color\front & $FFFFFF | _this_\AlphaState24( ) ) ; $FF0000ff ) ;
            Else
               Line(_this_\frame_x( ) + _this_\bar\button[1]\round, _this_\frame_y( ), _this_\frame_width( ) - _this_\bar\button[1]\round - _this_\bar\button[2]\round, 1, _this_\color\front & $FFFFFF | _this_\AlphaState24( ) ) ; $FF000000 ) ;
            EndIf
         EndIf
      EndIf
      
      ; frame buttons draw
      If Not _this_\bar\button[1]\mask & #__mask_hidden
         If _this_\bar\button[1]\arrow\size
            If _this_\flagmask & #__spin_Plus 
               __draw_plus( _this_\bar\button[1], Bool( _this_\bar\invert ) )
            Else
               __draw_arrows( _this_\bar\button[1], Bool(_this_\bar\vertical ) + (Bool(_this_\type <> #__type_Scroll)*2)+1)
            EndIf
         EndIf
         __draw_box(_this_\bar\button[1], color\frame)
         ; draw_roundbox_( _this_\bar\button[1]\x, _this_\bar\button[1]\y, _this_\bar\button[1]\width, _this_\bar\button[1]\height, _this_\bar\button[1]\round, _this_\bar\button[1]\round, _this_\bar\button[1]\color\frame[_this_\bar\button[1]\ColorState( )] & $FFFFFF | _this_\bar\button[1]\AlphaState24( ) )
      EndIf
      If Not _this_\bar\button[2]\mask & #__mask_hidden
         If _this_\bar\button[2]\arrow\size
            If _this_\flagmask & #__spin_Plus 
               __draw_plus( _this_\bar\button[2], Bool( Not _this_\bar\invert ) )
            Else
               __draw_arrows( _this_\bar\button[2], Bool(_this_\bar\vertical ) + (Bool(_this_\type = #__type_Scroll)*2)+1 )
            EndIf
         EndIf
         __draw_box(_this_\bar\button[2], color\frame)
         ; draw_roundbox_( _this_\bar\button[2]\x, _this_\bar\button[2]\y, _this_\bar\button[2]\width, _this_\bar\button[2]\height, _this_\bar\button[2]\round, _this_\bar\button[2]\round, _this_\bar\button[2]\color\frame[_this_\bar\button[2]\ColorState( )] & $FFFFFF | _this_\bar\button[2]\AlphaState24( ) )
      EndIf
   EndMacro     
   
   ;-  
   ;-\\  DECLARE_globals
   ;-  
   Declare a_grid_image( Steps = 5, line = 0, Color = 0, startx = 0, starty = 0 )
   Declare a_init( *this, grid_size.a = 7, grid_type.b = 0 )
   Declare a_set( *this, mode.i = #PB_Default, size.l = #PB_Default, position.l = #PB_Default )
   Declare a_update( *parent )
   Declare a_align( *this, align )
   Declare a_free( *this )
   Declare a_object( X.l, Y.l, Width.l, Height.l, Text.s, color.i, Flag.q = #Null, framesize = 1 )
   
   ; Declare   make_mdi_size( *this, scroll_x, scroll_y, scroll_width, scroll_height )
   Declare.b bar_update( *this, mode.b = 1 )
   Declare.b bar_PageChange( *this, state.l, mode.b = 1 )
   Declare.b bar_UpdateDraw_TabItems( *this )
   
   Declare   make_mdi_max( *this, X.l, Y.l, Width.l, Height.l )
   Declare   make_area_max( *this, X.l, Y.l, Width.l, Height.l )
   Declare   make_area_size( *this, X.l, Y.l, Width.l, Height.l )
   
   Declare   GetAtPoint( *root._s_ROOT, mouse_x, mouse_y, List *List._s_WIDGET( ), *address = #Null )
   Declare.i Sticky( *window = #PB_Default, state.b = #PB_Default )
   
   Declare$  PBEventString( event.i )
   Declare$  PBFlagString( Type )
   Declare.i PBEventType( event.i )
   ;
   Declare.q ToPBFlag( Type, Flag.q )
   Declare.q FromPBFlag( Type, Flag.q )
   Declare.q GetFlag( *this )
   Declare   SetFlag( *this, Flag.q )
   Declare   RemoveFlag( *this, Flag.q )
   Declare.q Flag( *this, Flag.q = #Null, state.b = #PB_Default )
   
   Declare$  MakeCompiler( string$ )
   Declare$  MakeString( Constant.q, Class$ = "flag" ) 
   Declare.q MakeValue( string$ )
   
   Declare.i TypeFromClass( class.s )
   Declare.s ClassFromType( Type )
   Declare.s EventString( event.i )
   
   Declare.b Draw( *this )
   Declare   ReDraw( *root = 0 )
   Declare.b Draw_Arrow( direction.a, X.l, Y.l, size.a, mode.b = 1, framesize.a = 0, Color.i = $ff000000 )
   Declare   Draw_Button( *this )
   Declare   Draw_Editor( *this )
   Declare.l UpdateDraw_Rows( *this )
   
   ;-
   Declare.l Level( *this )
   Declare.i CountType( *this, mode.b = 0 )
   Declare   IsChild( *this, *parent )
   Declare   IsChildrens( *this )
   Declare.b IsContainer( *this )
   Declare.l Type( *this )
   Declare.i ID( Index )
   Declare.l Index( *this )
   
   Declare.b HideItem( *this, item.l, state.b )
   Declare.b Hide( *this, State.b = #PB_Default, flags.q = 0 )
   Declare.b DisableItem( *this, item.l, state.b )
   Declare.b Disable( *this, State.b = #PB_Default )
   
   Declare.l X( *this, mode.l = #PB_Default )
   Declare.l Y( *this, mode.l = #PB_Default )
   Declare.l Width( *this, mode.l = #PB_Default )
   Declare.l Height( *this, mode.l = #PB_Default )
   
   Declare   ReClip( *this._s_WIDGET )
   Declare   ResizeRootWindow( *this, X.l, Y.l, Width.l, Height.l )
   Declare.b Resize( *this, ix.l, iy.l, iwidth.l, iheight.l, scale.b = 1 )
   ;
   Declare   Alignment( *this, align.q, mode.q = 0 )
   Declare.i SetAlign( *this, mode.q, left.q = 0, top.q = 0, right.q = 0, bottom.q = 0, update.b = 1 )
   Declare.i SetAttach( *this, *parent, mode.a )
   Declare   SetChildrenBounds( *this, state.b )
   Declare   SetMoveBounds( *this, MinimumX.l = #PB_Ignore, MinimumY.l = #PB_Ignore, MaximumX.l = #PB_Ignore, MaximumY.l = #PB_Ignore )
   Declare   SetSizeBounds( *this, MinimumWidth.l = #PB_Ignore, MinimumHeight.l = #PB_Ignore, MaximumWidth.l = #PB_Ignore, MaximumHeight.l = #PB_Ignore )
   
   Declare   ChangeItemState( *this, Item.l, State.b )
   Declare   ChangeStatus( *this, *row )
   Declare.l CountItems( *this )
   Declare.l ClearItems( *this )
   Declare   PushItem( *this )
   Declare   PopItem( *this )
   Declare.i ItemID( *this, Item.l ) 
   Declare.b IsItem( *this, Item.l ) 
   Declare.i SelectItem( *this, Item.l )
   Declare   RemoveItem( *this, Item.l )
   Declare   AddItem( *this, Item.l, Text.s, img.i = -1, Flag.q = 0 )
   Declare   AddColumn( *this, position.l, Text.s, Width.l, img.i = - 1 )
   
   Declare.i GetRoot( *this )
   Declare.i GetWindow( *this )
   Declare.i GetCanvasGadget( *this )
   Declare.i GetCanvasWindow( *this )
   
   Declare.i SetFocus( *this )
   Declare.i SetActive( *this )
   Declare   SetForeground( *window )
   Declare   SetTextXY( *this, X.l, Y.l )
   
   Declare.l GetRound( *this )
   Declare   SetRound( *this, round.l )
   
   Declare.a GetFrame( *this, mode.b = 0 )
   Declare   SetFrame( *this, size.a, mode.b = 0 )
   
   Declare.s GetClass( *this )
   Declare   SetClass( *this, class.s )
   
   Declare   GetCaret( *this, mode.a = 0 )
   Declare   SetCaret( *this, position.i )
   
   Declare.s GetText( *this )
   Declare   SetText( *this, Text.s )
   Declare.s GetItemText( *this, Item.l, Column.l = 0 )
   Declare.l SetItemText( *this, Item.l, Text.s, Column.l = 0 )
   
   Declare.i GetState( *this )
   Declare.b SetState( *this, state.i )
   Declare.l GetItemState( *this, Item.l )
   Declare.b SetItemState( *this, Item.l, State.b )
   
   Declare.i GetData( *this )
   Declare.i SetData( *this, *data )
   Declare.i GetItemData( *this, item.l )
   Declare.i SetItemData( *this, item.l, *data )
   
   Declare.i GetAttribute( *this, Attribute.l )
   Declare.i SetAttribute( *this, Attribute.l, value )
   Declare.i GetItemAttribute( *this, Item.l, Attribute.l, Column.l = 0 )
   Declare.i SetItemAttribute( *this, Item.l, Attribute.l, value, Column.l = 0 )
   
   Declare.i GetCursor( *this = #PB_All, Type.a = 0 )
   Declare   SetCursor( *this, *cursor, Type.a = 0 )
   Declare   ChangeCursor( *this, *cursor )
   ;
   Declare.i GetFont( *this )
   Declare.i SetFont( *this, Font.i )
   Declare.i GetItemFont( *this, Item.l )
   Declare.i SetItemFont( *this, Item.l, Font.i )
   
   Declare.i GetFontColor( *this )
   Declare   SetFontColor( *this, color.i )
   
   Declare   SetBackgroundColor( *this, color.i )
   Declare.i GetColor( *this, ColorType.l, ColorState.a = 0 )
   Declare.l SetColor( *this, ColorType.l, color.i, ColorState.b = 0 )
   Declare.l GetItemColor( *this, Item.l, ColorType.l, Column.l = 0, ColorState.a = 0 )
   Declare.l SetItemColor( *this, Item.l, ColorType.l, color.i, Column.l = 0, ColorState.b = 0 )
   
   Declare   SetBackgroundImage( *this, img )
   Declare   RemoveImage( *this, img )
   Declare.i GetImage( *this )
   Declare   SetImage( *this, img )
   Declare.i GetItemImage( *this, Item.l )
   Declare.i SetItemImage( *this, Item.l, img )
   
   Declare   GetLast( *this, tabindex.l = #PB_Default )
   Declare   GetPosition( *this, position.l, tabindex.l = #PB_Default )
   Declare   SetPosition( *this, position.l, *widget = #Null )
   Declare.i GetParent( *this )
   Declare   SetParent( *this, *parent, tabindex.l = #PB_Default )
   
   ;
   ;-\\ BAR  [menu;popupmenu;toolbar]
   ;Declare.b IsBar( *this._s_widget )
   Macro     BarBar( ): BarSeparator( ): EndMacro
   Declare   BarSeparator( )
   Declare   CreatePopupBar( _flags_ = 0 )
   Declare   CreateBar( *parent, Flag.q = #Null, Type.w = #__type_MenuBar )
   Declare   OpenSubBar( Text.s, img.i = - 1 )
   Declare   CloseSubBar( )
   Declare.i DisplayPopupBar( *this, *display, X.l = #PB_Ignore, Y.l = #PB_Ignore )
   Declare   DisableBarItem( *this, _baritem_, _state_ )
   Declare   DisableBarButton( *this, _barbutton_, _state_ )
   Declare   BarToolTip( *this, _barbutton_, _text_.s )
   Declare   BarPosition( *this, position.i, size.i = #PB_Default )
   Declare   BarTitle( title.s, img = - 1 )
   Declare   BarItem( item, Text.s, img = - 1 )
   Declare   BarButton( Button.i, img.i, mode.i = 0, Text.s = #Null$ )
   Declare.s GetBarTitleText( *this, _title_.s )
   Declare   SetBarTitleText( *this, _titleindex_, _text_.s )
   Declare   SetBarItemText( *this, _baritem_, _text_.s )
   Declare.s GetBarItemText( *this, _baritem_ )
   Declare   SetBarItemState( *this, _baritem_, _state_ )
   Declare   GetBarItemState( *this, _baritem_ )
   Declare   BindBarEvent( *this, _baritem_, *callback )
   Declare   UnbindBarEvent( *this, _baritem_, *callback )
   Declare   UpdateBar( *this )
   
   Declare.i VBar( *this )
   Declare.i HBar( *this )
   
   ;
   Declare.i Create( *parent, class.s, Type.w, X.l, Y.l, Width.l, Height.l, Text.s = #Null$, Flag.q = #Null, *param_1 = #Null, *param_2 = #Null, *param_3 = #Null, size.l = 0, round.l = 0, ScrollStep.d = 1.0 )
   
   ; bar
   Declare.i Spin( X.l, Y.l, Width.l, Height.l, Min.l, Max.l, Flag.q = 0, round.l = 0, increment.d = 1.0 )
   Declare.i Tab( X.l, Y.l, Width.l, Height.l, Flag.q = 0, round.l = 0 )
   Declare.i Scroll( X.l, Y.l, Width.l, Height.l, Min.l, Max.l, PageLength.l, Flag.q = 0, round.l = 0 )
   Declare.i Track( X.l, Y.l, Width.l, Height.l, Min.l, Max.l, Flag.q = 0, scrollstep.d = 1.0  )
   Declare.i Progress( X.l, Y.l, Width.l, Height.l, Min.l, Max.l, Flag.q = 0, round.l = 0 )
   Declare.i Splitter( X.l, Y.l, Width.l, Height.l, First.i, Second.i, Flag.q = 0 )
   
   ; button
   Declare.i Button( X.l, Y.l, Width.l, Height.l, Text.s, Flag.q = 0, round.l = 0 )
   Declare.i Option( X.l, Y.l, Width.l, Height.l, Text.s, Flag.q = 0 )
   Declare.i CheckBox( X.l, Y.l, Width.l, Height.l, Text.s, Flag.q = 0 )
   Declare.i HyperLink( X.l, Y.l, Width.l, Height.l, Text.s, Color.i, Flag.q = 0 )
   Declare.i ComboBox( X.l, Y.l, Width.l, Height.l, Flag.q = 0 )
   Declare.i ButtonImage( X.l, Y.l, Width.l, Height.l, img.i = -1, Flag.q = 0, round.l = 0 )
   
   ; text
   Declare.i Text( X.l, Y.l, Width.l, Height.l, Text.s, Flag.q = 0, round.l = 0 )
   Declare.i String( X.l, Y.l, Width.l, Height.l, Text.s, Flag.q = 0, round.l = 0 )
   Declare.i Editor( X.l, Y.l, Width.l, Height.l, Flag.q = 0, round.i = 0 )
   
   ; list
   Declare.i Tree( X.l, Y.l, Width.l, Height.l, Flag.q = 0 )
   Declare.i ListView( X.l, Y.l, Width.l, Height.l, Flag.q = 0 )
   Declare.i ListIcon( X.l, Y.l, Width.l, Height.l, ColumnTitle.s, ColumnWidth.i, Flag.q = 0 )
   Declare.i ExplorerList( X.l, Y.l, Width.l, Height.l, Directory.s, Flag.q = 0 )
   Declare.i Properties( X.l, Y.l, Width.l, Height.l, Flag.q = 0 )
   
   ; container
   Declare.i Panel( X.l, Y.l, Width.l, Height.l, Flag.q = 0 )
   Declare.i Container( X.l, Y.l, Width.l, Height.l, Flag.q = 0 )
   Declare.i ScrollArea( X.l, Y.l, Width.l, Height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, ScrollStep.l = 1, Flag.q = 0 )
   Declare.i Frame( X.l, Y.l, Width.l, Height.l, Text.s, Flag.q = #__flag_nogadgets )
   Declare.i Image( X.l, Y.l, Width.l, Height.l, img.i, Flag.q = 0 )
   Declare.i MDI( X.l, Y.l, Width.l, Height.l, Flag.q = 0 )
   
   ;
   Declare.i CloseList( )
   Declare.i OpenList( *this, item.l = 0 )
   ;
   ;
   Declare   ResetEvents( *this )
   Declare   AddEvents( *this, event.l, *button = #PB_All, *data = #Null )
   Declare.i Post( *this, event.l, *button = #PB_All, *data = #Null )
   Declare.i Bind( *this, *callback, event.l = #PB_All, item.l = #PB_All, *data = 0 )
   Declare.i Unbind( *this, *callback, event.l = #PB_All, item.l = #PB_All )
   ;
   Declare   Message( Title.s, Text.s, Flag.q = #Null, ParentID = #Null )
   Declare   PostQuit( *root = #Null )
   Declare   WaitQuit( *address = #Null )
   Declare   WaitClose( *callback = #Null )
   ;
   Declare   Open( Window, X.l = 0, Y.l = 0, Width.l = #PB_Ignore, Height.l = #PB_Ignore, title$ = #Null$, Flag.q = #Null, *parentID = #Null, Canvas = #PB_Ignore )
   Declare   Free( *this )
   Declare   Close( *root )
   ;
   Declare   DoEvents( *this, event.l, *button = #PB_All, *data = #Null )
   Declare   EventHandler( Canvas.i = - 1, event.i = - 1, eventdata = 0 )
   ;
   Declare   AddButtons( *this, *g, Flag.q = 0 )
   Declare   UpdateButtons( *this, change.b = 1 )
   ;
   Declare.i Window( X.l, Y.l, Width.l, Height.l, Text.s, Flag.q = 0, *parent = 0 )
   Declare.i Gadget( Type.w, Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s = "", *param1 = #Null, *param2 = #Null, *param3 = #Null, Flag.q = #Null )
EndDeclareModule
CompilerEndIf

CompilerIf Not Defined( DD, #PB_Module )
   XIncludeFile "include/DD.pbi"
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 1717
; FirstLine = 829
; Folding = 9AcgA-PBu----------PMA9------DA5--PAQAAAw-
; EnableXP
; DPIAware