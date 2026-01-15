#ide_path = "../"
;
EnableExplicit
;
;- ENUMs
#_DD_CreateNew = 1<<1
#_DD_reParent = 1<<2
#_DD_Group = 1<<3
#_DD_CreateCopy = 1<<4
;
; properties items
Enumeration Properties
   #_pi_group_COMMON 
   #_pi_ID 
   #_pi_class
   #_pi_text
   #_pi_IMAGE
  #_pi_FLAG
  ;
   #_pi_group_LAYOUT 
   #_pi_align
   #_pi_x
   #_pi_y
   #_pi_width
   #_pi_height
   ;
   #_pi_group_VIEW 
   #_pi_cursor
   #_pi_hide
   #_pi_disable
   ;
   #_pi_FONT
   #_pi_fontsize
   #_pi_fontstyle
   ;
   #_pi_COLOR
   #_pi_colortype
   #_pi_colorstate
   #_pi_coloralpha
   #_pi_colorblue
   #_pi_colorgreen
   #_pi_colorred
  EndEnumeration

; events items
Enumeration Properties
   #_ei_leftdown
   #_ei_leftup
   #_ei_left1Click
   #_ei_left2Click
   #_ei_left3Click
   #_ei_rightdown
   #_ei_rightup
   #_ei_right1Click 
   #_ei_right2Click 
   #_ei_right3Click 
   #_ei_middledown
   #_ei_middleup 
   #_ei_enter
   #_ei_leave 
   #_ei_move   
   #_ei_wheel
   #_ei_change
   #_ei_status
   #_ei_scroll
   #_ei_focus
   #_ei_lostfocus
   #_ei_resize 
   #_ei_free
   #_ei_drop
   #_ei_dragStart     
   #_ei_keydown 
   #_ei_keyup 
   #_ei_keyinput
   #_ei_close 
   #_ei_minimize  
   #_ei_maximize 
   #_ei_restore
EndEnumeration

; bar items
Enumeration 
   #_tb_group_select = 1
   
   #_tb_group_left = 3
   #_tb_group_right
   #_tb_group_top
   #_tb_group_bottom
   #_tb_group_width
   #_tb_group_height
   
   #_tb_align_left
   #_tb_align_right
   #_tb_align_top
   #_tb_align_bottom
   #_tb_align_center
   
   #_tb_widget_paste
   #_tb_widget_delete
   #_tb_widget_copy
   #_tb_widget_cut
   
   #_tb_file_run
   #_tb_file_new
   #_tb_file_open
   #_tb_file_save
   #_tb_file_SAVEAS
   #_tb_QUIT
   
   #_tb_LNG
   #_tb_lng_ENG
   #_tb_lng_RUS
   #_tb_lng_FRENCH
   #_tb_lng_GERMAN
EndEnumeration

;- GLOBALs
Global ide_window, 
       ide_g_inspector_VIEW,
       ide_g_canvas

Global ide_root,
       ide_main_SPLITTER,
       ide_debug_SPLITTER, 
       ide_toolbar_container, 
       ide_toolbar, 
       ide_popup_lenguage,
       ide_menu

Global ide_design_SPLITTER,
       ide_design_PANEL, 
       ide_design_MDI,
       ide_design_CODE, 
       ide_design_HIASM, 
       ide_help_DEBUG 

Global ide_properties_SPLITTER,
       ide_inspector_VIEW, 
       ide_help_SPLITTER, 
       ide_inspector_PANEL,
       ide_design_ELEMENTS,
       ide_inspector_PROPERTIES, 
       ide_inspector_EVENTS,
       ide_help_VIEW

Global group_select
Global group_drag

Global ColorState
Global ColorType 

Global enum_object = 0
Global enum_image = 0
Global enum_font = 0
Global pb_object$ = "";"Gadget"


Global font_properties = LoadFont( #PB_Any, "", 12 )
Global NewMap EventsString.s( )
Global NewMap GetObject.s( )
;

Structure _s_LINE
   type$
   pos.i
   len.i
   String.s
   
   ; id$
   func$
   arg$
EndStructure
Structure _s_PARSER
   List *line._s_LINE( )
EndStructure
Global *parser._s_PARSER = AllocateStructure( _s_PARSER )
;*parser\Line( ) = AllocateStructure( _s_LINE )

;
;- DECLAREs
Declare   Properties_SetItemText( *splitter, item, Text.s )
Declare.s Properties_GetItemText( *splitter, item )
Declare   Properties_Updates( *object, type$ )
;
Declare   new_widget_events( )
Declare   new_widget_create( *parent, type$, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, text$="", Param1=0, Param2=0, Param3=0, Flag.q = 0 )
Declare   new_widget_add( *parent, type$, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, Flag = 0 )
Declare   ide_inspector_VIEW_ADD_ITEMS( *new )
;
Declare.s Generate_Code( *parent )
;
Declare$  FindArguments( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
Declare   MakeCallFunction( str$, arg$, findtext$ )
Declare   GetArgIndex( text$, len, caret, mode.a = 0 )
Declare$  GetWord( text$, len, caret )
;
Declare$  FindFunctions( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
Declare   NumericString( string$ )
Declare   MakeLine( *mdi, string$, findtext$ )
Declare   MakeID( class$, *rootParent )
;
;
Declare   AddFont( key$, name$, size, style )
Declare.s GetFontName( font.i )
Declare.a GetFontSize( font.i )
Declare.q GetFontStyle( font.i )
; Declare   SetFontName( font.i, name.s )
; Declare   SetFontSize( font.i, size.a )
; Declare   SetFontStyle( font.i, style.q )
Declare   ChangeFont( font, name.s, size.a, style.q )
Declare   ChangeFontSize( *this, size )
Declare   ChangeFontStyle( *this, style.q )
;
Declare   AddImages( Image )
Declare   AddImage( key$, file$, flags = 0 )
Declare   ChangeImage( img )
Declare$  GetImageKey( img )
Declare$  GetImageFile( img )
;
;- INCLUDEs
XIncludeFile #ide_path + "widgets.pbi"
; XIncludeFile "C:\Users\user\Downloads\Compressed\widget-edb230c0138ebd33deacbac9440577a00b5affa7\widget-edb230c0138ebd33deacbac9440577a00b5affa7\widgets.pbi"
; Procedure.i GetFontColor( *this.structures::_s_WIDGET )
;    ProcedureReturn widget::GetColor( *this, constants::#__FrontColor )
; EndProcedure
; Procedure   SetFontColor( *this.structures::_s_WIDGET, color.i )
;    ProcedureReturn widget::SetColor( *this, constants::#__FrontColor, color )
; EndProcedure


XIncludeFile #ide_path + "include/newcreate/anchorbox.pbi"
XIncludeFile #ide_path + "IDE/include/helper/imageeditor.pbi"
CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile #ide_path + "IDE/code.pbi"
CompilerEndIf

;
;- USES
UseWidgets( )
UsePNGImageDecoder( )
; test_docursor = 1
; test_changecursor = 1
; test_setcursor = 1
; test_delete = 1
test_focus_draw = 3
; test_canvas_focus_draw = 1
; test_focus_set = 1
; test_changecursor = 1


Global PreviewRunning, PreviewProgramName$

Procedure RunPreview(SourceCode$)
   If SourceCode$ = "" : ProcedureReturn : EndIf
   Protected TempFileName$, hTempFile
   Protected CompilerPath$, CompilPreview, CompilPreviewOutput$
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      CompilerPath$ = #PB_Compiler_Home + "Compilers\pbcompiler.exe"
   CompilerElse
      CompilerPath$ = #PB_Compiler_Home + "pbcompiler"
   CompilerEndIf
   
   If FileSize(CompilerPath$)
      TempFileName$ = "~preview.pb"
      hTempFile = CreateFile(#PB_Any, TempFileName$, #PB_UTF8)
      If hTempFile
         WriteStringFormat(hTempFile, #PB_UTF8)
         WriteStringN(hTempFile, SourceCode$)
         CloseFile(hTempFile)
         ;
         PreviewProgramName$ = GetPathPart(TempFileName$) + GetFilePart(TempFileName$, #PB_FileSystem_NoExtension) + ".exe"
         CompilPreview = RunProgram(CompilerPath$, #DQUOTE$ + TempFileName$ +#DQUOTE$+ " /EXE " +#DQUOTE$+ PreviewProgramName$ +#DQUOTE$ + " /XP /DPIAWARE", "", #PB_Program_Hide | #PB_Program_Open | #PB_Program_Read)
         ;CompilPreview = RunProgram(CompilerPath$, #DQUOTE$ + TempFileName$ +#DQUOTE$+ " -e " +#DQUOTE$+ PreviewProgramName$ +#DQUOTE$ + " /DPIAWARE", "", #PB_Program_Hide | #PB_Program_Open | #PB_Program_Read)
         
         If CompilPreview
            ; WaitProgram(CompilPreview)
            While ProgramRunning(CompilPreview)
               If AvailableProgramOutput(CompilPreview)
                  CompilPreviewOutput$ = ReadProgramString(CompilPreview)
               EndIf
            Wend
            ;
            If ProgramExitCode(CompilPreview)
               KillProgram(CompilPreview)
               CloseProgram(CompilPreview)
               MessageRequester("Preview Error", "Fail to compile:" +#CRLF$+ "PBcompiler " + GetFilePart(TempFileName$) + " -e " + GetFilePart(PreviewProgramName$) + #CRLF$+#CRLF$+ CompilPreviewOutput$, #PB_MessageRequester_Error | #PB_MessageRequester_Ok)
            Else
               KillProgram(CompilPreview)
               CloseProgram(CompilPreview)
               If FileSize(PreviewProgramName$)
                  DeleteFile(TempFileName$)
                  PreviewRunning = RunProgram(PreviewProgramName$, "", "", #PB_Program_Open)
               Else
                  MessageRequester("Preview Error", "Fail to compile:" +#CRLF$+ "PBcompiler " + GetFilePart(TempFileName$) + " -e " + GetFilePart(PreviewProgramName$), #PB_MessageRequester_Error | #PB_MessageRequester_Ok)
               EndIf
            EndIf
         Else
            MessageRequester("Preview Error", "Fail to compile:" +#CRLF$+ "PBcompiler " + GetFilePart(TempFileName$) + " -e " + GetFilePart(PreviewProgramName$), #PB_MessageRequester_Error | #PB_MessageRequester_Ok)
         EndIf
      EndIf
   Else
      MessageRequester("Preview Error", "PBcompiler.exe was not found in Compilers folder", #PB_MessageRequester_Error | #PB_MessageRequester_Ok)
   EndIf
EndProcedure

;
;- PUBLICs
Procedure.s BoolToStr( val )
   If (val) > 0
      ProcedureReturn "True"
   Else ; If (val) = 0
      ProcedureReturn "False"
   EndIf
EndProcedure

Procedure   StrToBool( STR.s )
   If STR = "True"
      ProcedureReturn 1
   ElseIf STR = "False"
      ProcedureReturn 0
   EndIf
EndProcedure

;-
Procedure   is_parent_item( *this._s_WIDGET, item )
   Protected result
   PushItem(*this)
   If SelectItem( *this, item)
      result = *this\__rows( )\childrens 
   EndIf
   PopItem(*this)
   ProcedureReturn result
EndProcedure

;-
Procedure ReplaceText( *this._s_WIDGET, find$, replace$, NbOccurrences.b = 0 )
   Protected code$ = GetText( *this )
   
   If NbOccurrences
      code$ = ReplaceString( code$, find$, replace$, #PB_String_CaseSensitive, FindString( code$, find$ ), NbOccurrences )
   Else
      code$ = ReplaceString( code$, find$, replace$, #PB_String_CaseSensitive )
   EndIf
   
   If code$
      SetText( *this, code$ )
   EndIf
   
   ; Debug *this\class
EndProcedure

Procedure   ReplaceArg( *object._s_WIDGET, argument, replace$ )
   Protected find$, count, caret
   
   Select argument
      Case 0
         SetClass( *object, replace$ )
         
         ;
         Properties_Updates( *object, "Class" )
         
      Case 1                              ; id
         Debug "  ------ id"
         
      Case 2,3,4,5 
         ;
         Select argument
            Case 2 : Resize( *object, Val( replace$ ), #PB_Ignore, #PB_Ignore, #PB_Ignore)
            Case 3 : Resize( *object, #PB_Ignore, Val( replace$ ), #PB_Ignore, #PB_Ignore)
            Case 4 : Resize( *object, #PB_Ignore, #PB_Ignore, Val( replace$ ), #PB_Ignore)
            Case 5 : Resize( *object, #PB_Ignore, #PB_Ignore, #PB_Ignore, Val( replace$ ))
         EndSelect
         
      Case 6 
         replace$ = StringField( replace$, 1, ")" )
         replace$ = Trim( replace$ )
         replace$ = Trim( replace$, Chr('"') )
         ;
         SetText( *object, replace$ ) 
         ;
         Properties_Updates( *object, "Text" )
         
   EndSelect
   
EndProcedure

;-
Procedure   SetFlag( *this._s_WIDGET, flags.q )
   If *this\type = #__type_ComboBox
      ;       If *this\ComboBar( )
      ;          Flag( *this\ComboBar( ), flags, 1 )
      ;       EndIf
      Flag( *this, flags, 1 )
   EndIf
EndProcedure

;-
Declare   Properties_Events( )
Declare   PropertiesButton_Events( )
Declare   Properties_Status( *splitter._s_WIDGET, *this._s_WIDGET, item )

;-
Procedure   PropertiesButton_Free( *this._s_WIDGET )
   If *this
      Unbind( *this, @PropertiesButton_Events( ))
      Free( @*this )
   EndIf
EndProcedure

Procedure   PropertiesButton_Hide( *this._s_WIDGET )
   Protected._s_ROWS *row
   If *this
      *row = *this\parent\RowFocused( ) 
      If *row
         Hide(*this, *row\hide)
      EndIf
   EndIf
EndProcedure

Procedure   PropertiesButton_Resize( *this._s_WIDGET )
   If *this
      Protected *row._s_ROWS
      Protected *second._s_WIDGET = *this\parent
      Debug *second\class
      
      *row = *second\RowFocused( )
      If *row
         Select *row\index
            Case #_pi_FONT, #_pi_COLOR, #_pi_IMAGE
               Resize(*this,
                      (*row\x + *second\inner_width( )) -*this\width + *second\scroll_x( ),
                      *row\y + *second\scroll_y( ), 
                      #PB_Ignore, 
                      *row\height, 0 )
            Default
               Resize(*this,
                      *row\x + *second\scroll_x( ),
                      *row\y + *second\scroll_y( ),
                      *second\inner_width( ),
                      *row\height, 0 )
         EndSelect 
      EndIf
   EndIf
EndProcedure

Procedure   PropertiesButton_Create( *parent._s_WIDGET, item )
   Protected Type = GetItemData( *parent, item )
   Protected min, max, steps, Flag ;= #__flag_NoFocus ;| #__flag_Transparent ;| #__flag_child|#__flag_invert
   Protected *this._s_WIDGET
   
   Select Type
      Case #__type_Spin
         Flag = #__spin_Plus
         steps = 1 
         ;
         Select item
            Case #_pi_fontsize
               min = 1
               max = 50
            Case #_pi_coloralpha, #_pi_colorblue, #_pi_colorgreen, #_pi_colorred
               min = 0
               max = 255
            Default
               ; flag = #__flag_invert ; #__spin_Plus
               min = -2147483648
               max = 2147483647
               steps = 7 
         EndSelect
         
         *this = Create( *parent, "Spin", Type, 0, 0, 0, 0, "", Flag, min, max, 0, #__bar_button_size, 0, steps )
         ;          OpenList( *parent )
         ;          *this = Spin( 0,0,0,0, min,max,flag, 0, steps )
         ;          CloseList( )
         
      Case #__type_String
         *this = Create( *parent, "String", Type, 0, 0, 0, 0, "", Flag, 0, 0, 0, 0, 0, 0 )
         
      Case #__type_CheckBox
         *this = Create( *parent, "CheckBox", Type, 0, 0, 0, 0, "#PB_Any", Flag, 0, 0, 0, 0, 0, 0 )
         
      Case #__type_Button
         Select item
            Case #_pi_align
               *this = AnchorBox::Create( *parent, 0,0,0,20 )
               
            Case #_pi_FONT, #_pi_COLOR, #_pi_IMAGE
               *this = Create( *parent, "Button", Type, 0, 0, #__bar_button_size+1, 0, "...", Flag, 0, 0, 0, 0, 0, 0 )
               
         EndSelect
         
      Case #__type_ComboBox
         *this = Create( *parent, "ComboBox", Type, 0, 0, 0, 0, "", Flag|#PB_ComboBox_Editable, 0, 0, 0, #__bar_button_size, 0, 0 )
         ;
         Select item
            Case #_pi_flag
               SetFlag( *this, #__flag_CheckBoxes|#__flag_optionboxes )
               
            Case #_pi_fontstyle
               AddItem(*this, -1, "None")         
               If *this\ComboBar( )
                  *this\ComboBar( )\mode\Checkboxes = 1
                  *this\ComboBar( )\mode\optionboxes = 1
                  ;    Flag( *this\ComboBar( ), #__flag_CheckBoxes|#__flag_OptionBoxes, 1 )
               EndIf
               AddItem(*this, -1, "Bold")        ; Шрифт будет выделен жирным
               AddItem(*this, -1, "Italic")      ; Шрифт будет набран курсивом
               AddItem(*this, -1, "Underline")   ; Шрифт будет подчеркнут (только для Windows)
               AddItem(*this, -1, "StrikeOut")   ; Шрифт будет зачеркнут (только для Windows)
               AddItem(*this, -1, "HighQuality") ; Шрифт будет в высококачественном режиме (медленнее) (только для Windows)
               
            Case #_pi_colorstate
               AddItem(*this, -1, "Default")
               AddItem(*this, -1, "Entered")
               AddItem(*this, -1, "Selected")
               AddItem(*this, -1, "Disabled")
               ;                ColorState = 0
               ;                Properties_SetItemText( ide_inspector_PROPERTIES, item, GetItemText( *this, 0) )
               
            Case #_pi_colortype
               AddItem(*this, -1, "BackColor")
               AddItem(*this, -1, "FrontColor")
               AddItem(*this, -1, "LineColor")
               AddItem(*this, -1, "FrameColor")
               AddItem(*this, -1, "ForeColor")
               ;                ColorType = MakeValue("#PB_Gadget_" + GetItemText( *this, 0))
               ;                Properties_SetItemText( ide_inspector_PROPERTIES, item, GetItemText( *this, 0) )
               
            Case #_pi_cursor
               AddItem(*this, -1, "Default")
               AddItem(*this, -1, "Arrows")
               AddItem(*this, -1, "Busy")
               AddItem(*this, -1, "Cross")
               AddItem(*this, -1, "Denied")
               AddItem(*this, -1, "Hand")
               AddItem(*this, -1, "IBeam")
               AddItem(*this, -1, "Invisible")
               AddItem(*this, -1, "LeftDownRightUp")
               AddItem(*this, -1, "LeftRight")
               AddItem(*this, -1, "LeftUpRightDown")
               AddItem(*this, -1, "UpDown")
               ;                Properties_SetItemText( ide_inspector_PROPERTIES, item, GetItemText( *this, 0) )
               
            Default
               AddItem(*this, -1, "False")
               AddItem(*this, -1, "True")
               
         EndSelect
         ;
         SetState(*this, 0)
         
   EndSelect
   
   If *this
      SetData( *this, item )
      SetData( *parent, *this )
      Bind( *this, @PropertiesButton_Events( ))
   EndIf
   
   ProcedureReturn *this
EndProcedure

Procedure   PropertiesButton_Events( )
   Protected __item 
   Protected __event = WidgetEvent( )
   Protected._s_WIDGET *g = EventWidget( )
   Protected._s_WIDGET *second = *g\parent
   Protected._s_WIDGET *splitter = *second\parent
   Protected._s_WIDGET *first = GetAttribute( *splitter, #PB_Splitter_FirstGadget )
   
   Select __event
      Case #__event_LostFocus
         __item = GetData(*g) 
         ChangeItemState( *first, __item, 3 )
         ChangeItemState( *second, __item, 3 )
         
      Case #__event_Focus
         __item = GetData(*g) 
         ChangeItemState( *first, __item, 2 )
         ChangeItemState( *second, __item, 2 )
         
      Case #__event_LeftClick
         __item = GetData(*g) 
         Select __item
            Case #_pi_IMAGE
               Protected StandardFile$, Pattern$, File$
               StandardFile$ = "open_example.pb" 
               Pattern$ = "Image (*.*)|*.png;*.bmp;*.ico"
               
               Define img = open_EditorImages( *g\root )
               
               If IsImage( img )
                  SetImage( a_focused( ), img )
                  Debug "a_focused( ) "+ img +""+ GetImageKey( img )
               EndIf
               
               ;                File$ = OpenFileRequester("Пожалуйста выберите файл для загрузки", StandardFile$, Pattern$, 0)
               ;                
               ;                If File$
               ;                   Debug File$ 
               ;                   SetImage( a_focused( ), AddImage( Str(ListSize(images( ))), File$ ))
               ;                   
               ;                EndIf
               Properties_Updates( a_focused( ), "Image" )
               
            Case #_pi_FONT
               Define font = GetFont( a_focused( ) )
               Define FontName$ = GetFontName( font ) ; установить начальный шрифт (также может быть пустым)
               Define FontSize  = GetFontSize( font ) ; установить начальный размер (также может быть 0)
               Define FontStyle = GetFontStyle( font )
               Define FontColor = GetFontColor( a_focused( ) ) & $FFFFFF ;| a_focused( )\color\_alpha << 24
               Define Result = FontRequester( FontName$, FontSize, #PB_FontRequester_Effects, FontColor, FontStyle )
               If Result
                  Define Message$ = "Вы выбрали следующий шрифт:"  + #LF$
                  Message$ + "Имя:  " + SelectedFontName()         + #LF$
                  Message$ + "Цвет: " + Str(SelectedFontColor())   + #LF$
                  Message$ + "Размер:  " + Str(SelectedFontSize()) + #LF$
                  If SelectedFontStyle() & #PB_Font_Bold
                     Message$ + "Полужирный" + #LF$
                  EndIf
                  If SelectedFontStyle() & #PB_Font_StrikeOut
                     Message$ + "Перечёркнутый" + #LF$
                  EndIf
                  If SelectedFontStyle() & #PB_Font_Underline
                     Message$ + "Подчеркнутый" + #LF$
                  EndIf
                  
                  If a_focused( )
                     font = AddFont( Str( MapSize(fonts( ))), 
                                     SelectedFontName( ),
                                     SelectedFontSize( ),
                                     SelectedFontStyle( ))
                     
                     SetFont( a_focused( ), font )
                     
                     Define Color.l = SelectedFontColor( ) & $FFFFFF | a_focused( )\color\_alpha << 24
                     ; SetFontColor( a_focused( ), RGB( Red(Color), Green(Color), Blue(Color) ))
                     SetFontColor( a_focused( ), RGBA( Red(Color), Green(Color), Blue(Color), Alpha(Color) ))
                     
                     Properties_Updates( a_focused( ), "Font" )
                  EndIf
               Else
                  Message$ = "Запрос был отменён."
               EndIf
               ;MessageRequester("Инфо", Message$, #PB_MessageRequester_Ok)
               
            Case #_pi_COLOR
               Define Color.l = ColorRequester( GetColor( a_focused( ), ColorType, ColorState ) & $FFFFFF )
               
               If Color > - 1
                  Message$ = "Вы выбрали следующее значение цвета:"   + #LF$
                  Message$ + "32 Bit value: " + Str(Color)            + #LF$
                  Message$ + "Red значение:    " + Str(Red(Color))    + #LF$
                  Message$ + "Green значение:  " + Str(Green(Color))  + #LF$
                  Message$ + "Blue значение:  " + Str(Blue(Color))  + #LF$
                  Message$ + "Alpha значение:  " + Str(Alpha(Color))
                  
                  SetColor( a_focused( ), ColorType, RGBA( Red(Color), Green(Color), Blue(Color), Alpha(Color) ), ColorState )
                  Properties_Updates( a_focused( ), "Color" )
               Else
                  Message$ = "Запрос был отменён."
               EndIf
               
               ; MessageRequester("Инфо", Message$, 0)
               
         EndSelect
         
      Case #__event_Change
         __item = GetData(*g) 
         Select GetType(*g)
            Case #__type_String
               Select __item 
                  Case #_pi_class  
                     If SetClass( a_focused( ), UCase( GetText(*g)))
                        Properties_Updates( a_focused( ), "Class" ) 
                     EndIf
                     
                  Case #_pi_text   
                     If SetText( a_focused( ), GetText(*g) )  
                        Properties_Updates( a_focused( ), "Text" ) 
                     EndIf
                     
               EndSelect
               
            Case #__type_Spin
               Select __item 
                  Case #_pi_x      : Resize( a_focused( ), GetState(*g), #PB_Ignore, #PB_Ignore, #PB_Ignore ) 
                  Case #_pi_y      : Resize( a_focused( ), #PB_Ignore, GetState(*g), #PB_Ignore, #PB_Ignore )
                  Case #_pi_width  : Resize( a_focused( ), #PB_Ignore, #PB_Ignore, GetState(*g), #PB_Ignore )
                  Case #_pi_height : Resize( a_focused( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, GetState(*g) )
                     
                  Case #_pi_fontsize
                     If ChangeFontSize( a_focused( ), GetState( *g))
                        Properties_Updates( a_focused( ), "Font" )
                     EndIf
                     
                  Case #_pi_coloralpha
                     If SetBackColor( a_focused( ), RGBA( (Val(Properties_GetItemText(ide_inspector_PROPERTIES, #_pi_colorred))),
                                                          (Val(Properties_GetItemText(ide_inspector_PROPERTIES, #_pi_colorgreen))),
                                                          (Val(Properties_GetItemText(ide_inspector_PROPERTIES, #_pi_colorblue))),
                                                          (GetState(*g)) ))
                        Properties_Updates( a_focused( ), "Color" )
                     EndIf
                     
                  Case #_pi_colorblue
                     If SetBackColor( a_focused( ), RGBA( (Val(Properties_GetItemText(ide_inspector_PROPERTIES, #_pi_colorred))),
                                                          (Val(Properties_GetItemText(ide_inspector_PROPERTIES, #_pi_colorgreen))),
                                                          (GetState(*g)),
                                                          (Val(Properties_GetItemText(ide_inspector_PROPERTIES, #_pi_coloralpha))) ))
                        Properties_Updates( a_focused( ), "Color" )
                     EndIf
                     
                  Case #_pi_colorgreen
                     If SetBackColor( a_focused( ), RGBA( (Val(Properties_GetItemText(ide_inspector_PROPERTIES, #_pi_colorred))),
                                                          (GetState(*g)),
                                                          (Val(Properties_GetItemText(ide_inspector_PROPERTIES, #_pi_colorblue))),
                                                          (Val(Properties_GetItemText(ide_inspector_PROPERTIES, #_pi_coloralpha))) ))
                        Properties_Updates( a_focused( ), "Color" )
                     EndIf
                     
                  Case #_pi_colorred
                     If SetBackColor( a_focused( ), RGBA( (GetState(*g)),
                                                          (Val(Properties_GetItemText(ide_inspector_PROPERTIES, #_pi_colorgreen))),
                                                          (Val(Properties_GetItemText(ide_inspector_PROPERTIES, #_pi_colorblue))),
                                                          (Val(Properties_GetItemText(ide_inspector_PROPERTIES, #_pi_coloralpha))) ))
                        Properties_Updates( a_focused( ), "Color" )
                     EndIf
                     
               EndSelect
               
            Case #__type_ComboBox
               Select __item 
                  Case #_pi_cursor
                     Properties_SetItemText( ide_inspector_PROPERTIES, __item, GetItemText( *g, GetState( *g)))
                     
                  Case #_pi_colorstate
                     ColorState = GetState(*g)
                     Properties_SetItemText( ide_inspector_PROPERTIES, __item, GetItemText( *g, GetState( *g)))
                     Properties_Updates( a_focused( ), "Color" ) 
                     
                  Case #_pi_colortype
                     ColorType = MakeValue("#PB_Gadget_" + GetItemText( *g, GetState( *g)))
                     Properties_SetItemText( ide_inspector_PROPERTIES, __item, GetItemText( *g, GetState( *g)))
                     Properties_Updates( a_focused( ), "Color" ) 
                     
                  Case #_pi_FLAG
                     Flag( a_focused( ), MakeValue( GetItemText( *g, GetState( *g))), #True )
                     Properties_Updates( a_focused( ), "Flag" ) 
                     
                  Case #_pi_fontstyle
                     If ChangeFontStyle( a_focused( ), MakeValue( "#PB_Font_"+GetItemText( *g, GetState(*g))))
                        Properties_Updates( a_focused( ), "Font" )
                     EndIf
                     
                  Case #_pi_id
                     If GetState(*g) 
                        If SetClass( a_focused( ), "#"+Trim( GetClass( a_focused( ) ), "#" ))
                           Properties_Updates( a_focused( ), "ID" ) 
                           Properties_Updates( a_focused( ), "Class" ) 
                        EndIf
                     Else
                        If SetClass( a_focused( ), Trim( GetClass( a_focused( ) ), "#" ))
                           Properties_Updates( a_focused( ), "ID" ) 
                           Properties_Updates( a_focused( ), "Class" ) 
                        EndIf
                     EndIf
                     
                  Case #_pi_disable 
                     If Disable( a_focused( ), GetState(*g) )
                        Properties_Updates( a_focused( ), "Disable" ) 
                     EndIf
                     
                  Case #_pi_hide    
                     If Hide( a_focused( ), GetState(*g) )
                        Properties_Updates( a_focused( ), "Hide" ) 
                     EndIf
                     
               EndSelect
               
         EndSelect
         
      Case #__event_MouseWheel
         If MouseDirection( ) > 0
            If GetType(*g) = #__type_Spin
               Debug "PropertiesButton__event_MouseWheel "+*g\class
               SetState(*g, GetState( *g ) - WidgetEventData( ))
            EndIf
         EndIf
         
      Case #__event_CursorChange
         ProcedureReturn 0
         
   EndSelect
   
   ProcedureReturn #PB_Ignore
EndProcedure

;-
Procedure   Properties_AddFlags( *splitter._s_WIDGET, item, Text.s )
   ProcedureReturn 0
   Protected._s_WIDGET *this
   Protected._s_WIDGET *second = GetAttribute( *splitter, #PB_Splitter_SecondGadget )
   ;
   *this = GetData( *second )
   If *this
      Select item
         Case #_pi_flag 
            Static lasttext.s
            
            If lasttext <> Text
               lasttext = Text
               ; Debug "Properties_AddFlags " +Text
               ClearItems(*this)
               
               If Text
                  Protected i, sublevel, String.s, count = CountString(Text,"|")
                  
                  For I = 0 To count
                     String = Trim(StringField(Text,(I+1),"|"))
                     
                     Select LCase(Trim(StringField(String,(3),"_")))
                        Case "left" : sublevel = 1
                        Case "right" : sublevel = 1
                        Case "center" : sublevel = 1
                        Default
                           sublevel = 0
                     EndSelect
                     
                     AddItem(*this, -1, String, -1, sublevel)
                     
                  Next
               EndIf 
            EndIf 
            
      EndSelect
   EndIf
EndProcedure

Procedure   Properties_Change( *splitter._s_WIDGET )
   Protected._s_WIDGET *second = GetAttribute( *splitter, #PB_Splitter_SecondGadget )
   Protected._s_WIDGET *this
   Protected text$
   ;
   *this = GetData( *second )
   If *this
      If *second\RowFocused( )
         text$ = *second\RowFocused( )\text\string
         ;
         Select GetType( *this )
            Case #__type_Spin     
               If GetData( *this ) = #_pi_class
                  *this\text\upper = 1
               Else
                  *this\text\upper = 0
               EndIf
               SetState(*this, Val(text$) )
               
            Case #__type_String   
               SetText(*this, text$ )
               
            Case #__type_ComboBox 
               SetState(*this, StrToBool(text$) )
               
;                Select LCase(text$)
;                   Case "false" : SetState( *this, 0)
;                   Case "true"  : SetState( *this, 1)
;                EndSelect
               
         EndSelect
      EndIf
   EndIf
EndProcedure

Procedure   Properties_Status( *splitter._s_WIDGET, *this._s_WIDGET, item )
   Protected._s_WIDGET *first = GetAttribute( *splitter, #PB_Splitter_FirstGadget )
   Protected._s_WIDGET *second = GetAttribute( *splitter, #PB_Splitter_SecondGadget )
   Protected._s_ROWS *row
   Protected state
   
   ;
   If PushItem( *this )
      If SelectItem( *this, Item)
         *row = *this\__rows( )
      EndIf
      PopItem( *this)
   EndIf
   
   ; чтобы не виделялся
   If MouseDrag( )
      If *this\RowFocused( ) = *row 
         *row\focus = 1
         *row\ColorState( ) = #__s_2
      Else
         *row\focus = 0
         *row\ColorState( ) = #__s_0
      EndIf
      ProcedureReturn
   EndIf
   
   ;
   If *row\data
      Select *this
         Case *first 
            If GetState( *second ) <> *row\index
               ChangeItemState( *second, *row\index, *row\ColorState( ))
            EndIf
         Case *second 
            If GetState( *first ) <> *row\index
               ChangeItemState( *first, *row\index, *row\ColorState( ))
            EndIf   
      EndSelect
      
   Else
      Select *this
         Case *first 
            If *second\RowFocused( )
               item = *second\RowFocused( )\index
               state = *second\RowFocused( )\ColorState( ) 
            EndIf
            
         Case *second 
            If *first\RowFocused( )
               item = *first\RowFocused( )\index
               state = *first\RowFocused( )\ColorState( ) 
            EndIf
      EndSelect
      
      If GetState( *this ) <> item
         ChangeItemState( *this, item, state )
      EndIf
      
      *row\focus = 0
      *row\ColorState( ) = #__s_0
   EndIf
   
EndProcedure

Procedure   Properties_Display( *splitter._s_WIDGET, *this._s_WIDGET, item )
   Protected *first._s_WIDGET = GetAttribute( *splitter, #PB_Splitter_FirstGadget )
   Protected *second._s_WIDGET = GetAttribute( *splitter, #PB_Splitter_SecondGadget )
   
   If *first <> *this
      ChangeItemState( *first, item, 2 )
   EndIf
   If *second <> *this
      ChangeItemState( *second, item, 2 )
   EndIf
   ;
   PropertiesButton_Free( *second\data )  
   *this = PropertiesButton_Create( *second, item )
   PropertiesButton_Resize( *this )
   Properties_Change( *splitter )
   
   ProcedureReturn *this
EndProcedure

Procedure   Properties_HideItem( *splitter._s_WIDGET, item, state )
   HideItem( GetAttribute( *splitter, #PB_Splitter_FirstGadget ), item, state )
   HideItem( GetAttribute( *splitter, #PB_Splitter_SecondGadget ), item, state )
EndProcedure

Procedure.s Properties_GetItemText( *splitter._s_WIDGET, item )
   ProcedureReturn GetItemText( GetAttribute(*splitter, #PB_Splitter_SecondGadget ), item )
EndProcedure

Procedure   Properties_SetItemText( *splitter._s_WIDGET, item, Text.s )
   ProcedureReturn SetItemText( GetAttribute( *splitter, #PB_Splitter_SecondGadget ), item, Text.s )
EndProcedure

Procedure   Properties_AddItem( *splitter._s_WIDGET, item, Text.s, Type=0, mode=0 )
   Protected *first._s_WIDGET = GetAttribute( *splitter, #PB_Splitter_FirstGadget )
   Protected *second._s_WIDGET = GetAttribute( *splitter, #PB_Splitter_SecondGadget )
   Protected *this._s_WIDGET
   Protected._s_ROWS *row
   
   Protected first_text$ = StringField(Text.s, 1, Chr(10))
   Protected second_text$ = StringField(Text.s, 2, Chr(10))
   If Not mode
     ; first_text$ = UCase(first_text$)
   EndIf  
   ;
   *row = AddItem( *first, item, first_text$, -1, mode )
   If *row\parent
      *row\color\back = - 1
      If *row\parent\data
         *row\parent\color\back = $D4C8C8C8
      Else
         If *row\parent\sublevel
            *row\parent\color\back = $D4E4E4E4
         EndIf
      EndIf
   Else
      *row\color\back = $D4C8C8C8
   EndIf
   *row\data = Type  
   ;
   *row = AddItem( *second, item, second_text$, -1, mode )
   If *row\parent
      *row\color\back = - 1
      If *row\parent\data
         *row\parent\color\back = $D4C8C8C8
      Else
         If *row\parent\sublevel
            *row\parent\color\back = $D4E4E4E4
         EndIf
      EndIf
   Else
      *row\color\back = $D4C8C8C8
   EndIf
   *row\data = Type  
   
EndProcedure

Procedure   Properties_Create( X,Y,Width,Height, Flag=0 )
   Protected position = 90
   Protected tflag.q = #PB_Tree_NoLines|#__flag_Transparent|#__flag_BorderLess;|#__flag_gridlines
   Protected *first._s_WIDGET = Tree(0,0,0,0, tflag)
   Protected *second._s_WIDGET = Tree(0,0,0,0, tflag|#PB_Tree_NoButtons)
   ;    *first\padding\x = 10
   ;    *second\padding\x = 10
   Protected *g._s_WIDGET
   ;    *g = *first
   ;    ;*g\padding\x = DPIScaled(20)
   ;     ;*g\fs[1] = DPIScaled(20)
   ;     ;Resize(*g, #PB_Ignore, #PB_Ignore, 100, #PB_Ignore )
   ;     SetColor(*g, #PB_Gadget_BackColor,  $D4C8C8C8)
   ;     
   ;     *g = *second
   ;    ;*g\padding\x = DPIScaled(20)
   ;     ;*g\fs[1] = DPIScaled(20)
   ;     ;Resize(*g, #PB_Ignore, #PB_Ignore, 100, #PB_Ignore )
   ;     SetColor(*g, #PB_Gadget_BackColor,  $D4C8C8C8)
   
   Protected *splitter._s_WIDGET = Splitter(X,Y,Width,Height, *first,*second, Flag|#__flag_Transparent|#PB_Splitter_Vertical );|#PB_Splitter_FirstFixed )
   SetAttribute(*splitter, #PB_Splitter_FirstMinimumSize, position )
   SetAttribute(*splitter, #PB_Splitter_SecondMinimumSize, position )
   ;
   *splitter\bar\button\size = DPIScaled(1)
   *splitter\bar\button\size + Bool( *splitter\bar\button\size % 2 )
   *Splitter\bar\button\round = 0;  DPIScaled(1)
                                 ;*splitter\bar\button\color\back = $D4C8C8C8
   SetState(*splitter, DPIScaled(position) ) ; похоже ошибка DPI
   
   ;
   SetClass(*first\scroll\v, "first_v")
   SetClass(*first\scroll\h, "first_h")
   SetClass(*second\scroll\v, "second_v")
   SetClass(*second\scroll\h, "second_h")
   
   ;
   Hide( *first\scroll\v, 1 )
   Hide( *first\scroll\h, 1 )
   Hide( *second\scroll\h, 1 )
   
   ; CloseList( )
   
   SetColor( *splitter, #PB_Gadget_BackColor, -1, #PB_All )
   SetColor( *first, #PB_Gadget_LineColor, $D4C8C8C8)
   SetColor( *second, #PB_Gadget_LineColor, $D4C8C8C8)
   
   ;
   Bind(*first, @Properties_Events( ))
   Bind(*second, @Properties_Events( ))
   
   ; draw и resize отдельно надо включать пока поэтому вот так
   Bind(*second, @Properties_Events( ), #__event_Resize)
;  Bind(*second, @Properties_Events( ), #__event_Draw)
         
   ProcedureReturn *splitter
EndProcedure

Procedure   Properties_Events( )
   Static *test
   Protected._s_ROWS *row
   Protected._s_WIDGET *g = EventWidget( )
   Protected __event = WidgetEvent( )
   Protected __item = WidgetEventItem( )
   Protected __data = WidgetEventData( )
   
   Protected *first._s_WIDGET = GetAttribute( *g\parent, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute( *g\parent, #PB_Splitter_SecondGadget)
   
   Select WidgetEvent( )
      Case #__event_FOCUS
         If Not IsContainer(*g)
            If Not EnteredButton( )
               *row = WidgetEventData( )
               If *row
                  If SetState( *g, *row\index )
                     If *row\data
                        *test = Properties_Display( *g\parent, *g, *row\index )
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
         
         SetActive( *test)
         
      Case #__event_Change
         If Not MousePress( ) 
            *row = WidgetEventData( )
            If *row
               If Not *row\data
                 If *row\focus
                     Properties_Status( GetParent(*g), *g, WidgetEventItem( ))
                  EndIf
               EndIf
               ;
               If *g\RowFocused( )
                  If *g\RowFocused( )\ColorState( ) = #__s_3
                     *g\RowFocused( )\ColorState( ) = #__s_2
                  EndIf
               EndIf
            EndIf
         EndIf
         
         
      Case #__event_Up
         If Not EnteredButton( )
            If MouseDrag( ) 
               *row = *g\RowEntered( )
               If *row 
                  If *row\data
                     *test = Properties_Display( *g\parent, *g, *row\index )
                     SetActive( *test )
                  EndIf
               EndIf
            EndIf
         EndIf
         
      Case #__event_StatusChange
         If *first = *g
            If WidgetEventData( ) = #PB_Tree_Expanded Or
               WidgetEventData( ) = #PB_Tree_Collapsed
               ;
               If SetItemState( *second, WidgetEventItem( ), WidgetEventData( ))
                  PropertiesButton_Hide( *test )
               EndIf
            EndIf
         EndIf
         ;
         Properties_Status( *g\parent, *g, WidgetEventItem( ))
         
      Case #__event_ScrollChange
         Select *g
            Case *first 
               If GetState( *second\scroll\v ) <> WidgetEventData( )
                  SetState(*second\scroll\v, WidgetEventData( ) )
               EndIf
            Case *second 
               If GetState( *first\scroll\v ) <> WidgetEventData( )
                  SetState(*first\scroll\v, WidgetEventData( ) )
               EndIf
               ;
               PropertiesButton_Resize( *test ) 
         EndSelect
         
      Case #__event_Resize
         If *second = *g
            PropertiesButton_Resize( *test )
         EndIf
         
   EndSelect
   
   ProcedureReturn #PB_Ignore
EndProcedure

Procedure   Properties_Updates( *object._s_WIDGET, type$ )
   Protected find$, replace$, name$, class$, x$, y$, width$, height$
   ; class$ = Properties_GetItemText( ide_inspector_PROPERTIES, #_pi_class )
   
   If ide_inspector_PROPERTIES
      If type$ = "Focus" Or type$ = "Align"
         Properties_HideItem( ide_inspector_PROPERTIES, #_pi_align, Bool( a_focused( )\parent = ide_design_MDI )) 
      EndIf
      If type$ = "Focus" Or type$ = "ID"
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_id, BoolToStr( Bool( GetClass( *object ) <> Trim( GetClass( *object ), "#" ) )))
      EndIf
      If type$ = "Focus" Or type$ = "Hide"
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_hide, BoolToStr( Hide( *object )))
      EndIf
      If type$ = "Focus" Or type$ = "Disable"
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_disable, BoolToStr( Disable( *object )))
      EndIf
      
      If type$ = "Focus" Or type$ = "Class"
         find$ = Properties_GetItemText( ide_inspector_PROPERTIES, #_pi_class )
         replace$ = GetClass( *object )
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_class, replace$ )
      EndIf
      If type$ = "Focus" Or type$ = "Text"
         find$ = Properties_GetItemText( ide_inspector_PROPERTIES, #_pi_text )
         replace$ = GetText( *object )
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_text, replace$ )
      EndIf
      If type$ = "Focus" Or type$ = "Resize"
         ; Debug "---- "+type$
         If is_window_( *object )
            x$ = Str( X( *object, #__c_container ))
            y$ = Str( Y( *object, #__c_container ))
            width$ = Str( Width( *object, #__c_inner ))
            height$ = Str( Height( *object, #__c_inner ))
         Else
            x$ = Str( X( *object ))
            y$ = Str( Y( *object ))
            width$ = Str( Width( *object ))
            height$ = Str( Height( *object ))
         EndIf
         
         find$ = Properties_GetItemText( ide_inspector_PROPERTIES, #_pi_x ) +", "+ 
                 Properties_GetItemText( ide_inspector_PROPERTIES, #_pi_y ) +", "+ 
                 Properties_GetItemText( ide_inspector_PROPERTIES, #_pi_width ) +", "+ 
                 Properties_GetItemText( ide_inspector_PROPERTIES, #_pi_height )
         replace$ = x$ +", "+ y$ +", "+ width$ +", "+ height$
         
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_x,      x$ )
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_y,      y$ )
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_width,  width$ )
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_height, height$ )
         
         ;
         Properties_Change( ide_inspector_PROPERTIES )
      EndIf
      
      If type$ = "Focus" Or type$ = "Flag"
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_FLAG, MakeString( ClassFromType(*object\type), *object\flag ))
      EndIf
      If type$ = "Focus" Or type$ = "Color" 
         Define color.l = GetColor( *object, ColorType, ColorState ) ;& $FFFFFF | *object\color\_alpha << 24
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_COLOR, "$"+Hex(Color, #PB_Long))
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_coloralpha, Str(Alpha(color)) )
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_colorblue, Str(Blue(color)) )
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_colorgreen, Str(Green(color)) )
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_colorred, Str(Red(color)) )
      EndIf
      If type$ = "Focus" Or type$ = "Image"
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_IMAGE, GetImageFile( GetImage( *object )))
      EndIf
      If type$ = "Focus" Or type$ = "Font"
         Define font = GetFont( *object )
         ; Debug ""+font +" "+ GetClass(*object)
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_FONT, GetFontName( font ) )
         ; Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_fontcolor, Str( GetFontColor( font ) ))
         If GetFontName( font )
            Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_fontsize, Str( GetFontSize( font ) ))
         Else
            Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_fontsize, "" )
         EndIf
         Define style$ = RemoveString( MakeString( "Font", GetFontStyle( font ) ), "#PB_Font_")
         If style$ = ""
            style$ = "None"
         EndIf
         Properties_SetItemText( ide_inspector_PROPERTIES, #_pi_fontstyle, style$)
      EndIf 
      
      ;\\
      If type$ = "Focus"
         If a_focused( )
            Properties_AddFlags( ide_inspector_PROPERTIES, #_pi_flag, PBFlagString( GetType( a_focused( ))))
         EndIf
         
      Else
         Protected NbOccurrences
         Protected *this._s_WIDGET = GetActive( )
         
         If find$
            If type$ = "Class"
               If ide_inspector_VIEW
                  SetItemText( ide_inspector_VIEW, GetState(ide_inspector_VIEW), replace$)
               EndIf
               
               If *this = ide_design_CODE Or 
                  *this = ide_help_DEBUG
                  ;
                  Define code$ = GetText( *this )
                  
                  Define caret1 = FindString( code$, replace$ )
                  Define caret2 = GetCaret( *this )
                  
                  ; количество слов для замены до позиции коретки
                  Define count = CountString( Left( code$, caret1), find$ )
                  
                  Debug "caret "+caret1 +" "+ Str(caret2 - Len( find$ ))
                  
                  ; если коретка в конце слова Ok
                  If caret1 = caret2 - Len( find$ )
                     code$ = ReplaceString( code$, replace$, find$, #PB_String_CaseSensitive, caret1, 1 )
                     
                     ;             If Len( replace$ ) > Len( find$ )
                     ;                SetCaret( *this, caret1 - (Len( replace$ ) - Len( find$ )))
                     ;             EndIf
                  Else
                     ; если коретка в начале слова
                     If caret1 = caret2
                        code$ = ReplaceString( code$, replace$, find$, #PB_String_CaseSensitive, caret1, 1 )
                     EndIf
                  EndIf
                  
                  ; caret update
                  If count
                     If  keyboard( )\key
                        If keyboard( )\key = #PB_Shortcut_Back
                           If *this\text\edit[2]\len
                              SetCaret( *this, caret2 - count - (*this\text\edit[2]\len*(count))+2 )
                           Else
                              SetCaret( *this, caret2 - count )
                           EndIf
                        Else
                           SetCaret( *this, caret2 + count - (*this\text\edit[2]\len*count) )
                        EndIf
                     EndIf
                  EndIf
                  
                  ;
                  ; code$ = ReplaceString( code$, " "+find$+" ", " "+replace$+" ", #PB_String_CaseSensitive )
                  code$ = ReplaceString( code$, find$, replace$, #PB_String_CaseSensitive )
                  If code$
                     SetText( *this, code$ )
                  EndIf
               EndIf
               ; Меняем все найденные слова 
               NbOccurrences = 0
            Else
               ; Меняем первое одно найденное слово 
               NbOccurrences = 1
            EndIf
            
            ;
            If *this <> ide_help_DEBUG
               ReplaceText( ide_help_DEBUG, find$, replace$, NbOccurrences )
            EndIf
            If *this <> ide_design_CODE
               If Not Hide( ide_design_CODE )
                  ReplaceText( ide_design_CODE, find$, replace$, NbOccurrences )
               EndIf 
            EndIf
         EndIf
      EndIf
   EndIf
   
EndProcedure


;-
Procedure HideBarButtons( *this._s_WIDGET, state )
   ;    HideItem( *this, #_tb_group_left, state )
   ;    HideItem( *this, #_tb_group_right, state )
   ;    HideItem( *this, #_tb_group_top, state )
   ;    HideItem( *this, #_tb_group_bottom, state )
   ;    HideItem( *this, #_tb_group_height, state )
   ;    HideItem( *this, #_tb_group_width, state )
   
   DisableBarButton( *this, #_tb_group_left, state )
   DisableBarButton( *this, #_tb_group_right, state )
   DisableBarButton( *this, #_tb_group_top, state )
   DisableBarButton( *this, #_tb_group_bottom, state )
   DisableBarButton( *this, #_tb_group_height, state )
   DisableBarButton( *this, #_tb_group_width, state )
EndProcedure


Global NewList *copy._s_WIDGET( )
Global copy_x,copy_y

Procedure  new_widget_copy( )
   copy_x = 0
   copy_y = 0
   ClearList( *copy( ) )
   
   ;    If a_focused( )\anchors
   AddElement( *copy( ) ) 
   *copy.allocate( Widget, ( ) )
   *copy( ) = a_focused( )
   ;    Else
   ;       
   ;       ; CopyList( a_group( ), *copy( ) )
   ;       
   ;    EndIf
   ;    
EndProcedure

Procedure  new_widget_paste( )
   If ListSize( *copy( ) )
      copy_x + mouse( )\steps
      copy_y + mouse( )\steps
      
      ForEach *copy( )
         Debug ""+*copy( )\class +" "+ 
               *copy( )\x[#__c_container] +" "+ 
               *copy( )\y[#__c_container] +" "+  
               *copy( )\width[#__c_frame] +" "+ 
               *copy( )\height[#__c_frame]
         
         
         new_widget_add( *copy( )\parent, 
                         ClassFromType(*copy( )\type), 
                         X(*copy( ), #__c_container)+copy_x,
                         Y(*copy( ), #__c_container)+copy_y, 
                         Width(*copy( ), #__c_frame),
                         Height(*copy( ), #__c_frame), *copy( )\flag )
         
      Next
      
      ; ClearList( *copy( ) )
   EndIf
EndProcedure

Procedure new_widget_delete( *this._s_WIDGET  )
   If *this <> ide_design_MDI
      ; we delete the object itself
      ; and all its children
      Free( @*this )
   EndIf
EndProcedure

Procedure new_widget_add( *parent._s_widget, type$, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, Flag = 0 )
   Protected *new._s_widget
   ; flag.i | #__flag_NoFocus
   
   If *parent 
      ; OpenList( *parent, CountItems( *parent ) - 1 )
      *new = new_widget_create( *parent, type$, X,Y, Width, Height, "", 0,100,0, Flag )
      
      If *new
         If LCase(type$) = "panel"
            AddItem( *new, -1, type$+"_item_0" )
         EndIf
         
         ide_inspector_VIEW_ADD_ITEMS( *new )
         
         If Not Flag & #__flag_NoFocus 
            If IsContainer( *new )
               If is_window_( *new )
                  a_set(*new, #__a_full, (14))
               Else
                  a_set(*new, #__a_full, (10))
               EndIf 
            Else
               a_set(*new, #__a_full)
            EndIf
         EndIf
         ; CloseList( )
      EndIf
   EndIf
   
   ProcedureReturn *new
EndProcedure

Procedure new_widget_create( *parent._s_widget, type$, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, text$="", Param1=0, Param2=0, Param3=0, Flag.q = 0 )
   Protected *new._s_widget
   ; flag.i | #__flag_NoFocus
   Protected newtype$
   
   If *parent > 0 
      OpenList( *parent, CountItems( *parent ) - 1 )
      type$ = LCase( Trim( type$ ) )
      
      ; defaul width&height
      If type$ = "scrollarea" Or
         type$ = "container" Or
         type$ = "panel"
         
         If Width = #PB_Ignore
            Width = 200
         EndIf
         If Height = #PB_Ignore
            Height = 150
         EndIf
         
         If Param3 = 0
            If type$ = "scrollarea"
               Param1 = Width
               Param2 = Height
               Param3 = DPIUnScaled( mouse( )\steps )
            EndIf
         EndIf
         
      Else
         If Width = #PB_Ignore
            Width = 100
         EndIf
         If Height = #PB_Ignore
            Height = 30
         EndIf
      EndIf
      
      ; create elements
      Select type$
         Case "window"   
            If GetType( *parent ) = #__type_MDI
               *new = AddItem( *parent, #PB_Any, text$, - 1, Flag | #PB_Window_NoActivate )
               Resize( *new, X, Y, Width, Height )
            Else
               Flag | #PB_Window_SystemMenu | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget | #PB_Window_NoActivate
               *new = Window( X,Y,Width,Height, text$, Flag, *parent )
            EndIf
            ; SetFrame( *new, 0)
            
         Case "scrollarea"  : *new = ScrollArea( X,Y,Width,Height, Param1, Param2, Param3, Flag ) : CloseList( ) ; 1 
                                                                                                                 ; SetFrame( *new, 30)
            SetBackgroundColor( *new, $74F6FE )
         Case "container"   : *new = Container( X,Y,Width,Height, Flag ) : CloseList( )
         Case "panel"       : *new = Panel( X,Y,Width,Height, Flag ) : CloseList( )
            ; SetFrame( *new, 0)
            
         Case "button"        : *new = Button(       X, Y, Width, Height, text$, Flag ) 
         Case "string"        : *new = String(       X, Y, Width, Height, text$, Flag )
         Case "text"          : *new = Text(         X, Y, Width, Height, text$, Flag )
         Case "checkbox"      : *new = CheckBox(     X, Y, Width, Height, text$, Flag ) 
            ; Case "web"           : *new = Web(          X, Y, Width, Height, text$, flag )
         Case "explorerlist"  : *new = ExplorerList( X, Y, Width, Height, text$, Flag )                                                                           
            ; Case "explorertree"  : *new = ExplorerTree( X, Y, Width, Height, text$, flag )                                                                           
            ; Case "explorercombo" : *new = ExplorerCombo(X, Y, Width, Height, text$, flag )                                                                          
         Case "frame"         : *new = Frame(        X, Y, Width, Height, text$, Flag )                                                                                  
            
            ; Case "date"          : *new = Date(         X, Y, Width, Height, text$, Param1, flag )         ; 2            
         Case "hyperlink"     : *new = HyperLink(    X, Y, Width, Height, text$, Param1, Flag )                                                          
         Case "listicon"      : *new = ListIcon(     X, Y, Width, Height, text$, Param1, Flag )                                                       
            
         Case "scroll"        : *new = Scroll(       X, Y, Width, Height, Param1, Param2, Param3, Flag )  ; bar                                                             
            
         Case "progress"      : *new = Progress(     X, Y, Width, Height, Param1, Param2, Flag )          ; bar                                                           
         Case "track"         : *new = Track(        X, Y, Width, Height, Param1, Param2, Flag )          ; bar                                                                           
         Case "spin"          : *new = Spin(         X, Y, Width, Height, Param1, Param2, Flag )                                                                             
         Case "splitter"      : *new = Splitter(     X, Y, Width, Height, Param1, Param2, Flag )                                                                         
         Case "mdi"           : *new = MDI(          X, Y, Width, Height, Flag )  ;  , Param1, Param2                                                                          
         Case "image"         : *new = Image(        X, Y, Width, Height, Param1, Flag )                                                                                                     
         Case "buttonimage"   : *new = ButtonImage(  X, Y, Width, Height, Param1, Flag )                                                                                                 
            
            ; Case "calendar"      : *new = Calendar(     X, Y, Width, Height, Param1, flag )                 ; 1                                                 
            
         Case "listview"      : *new = ListView(     X, Y, Width, Height, Flag )                                                                                                                       
         Case "combobox"      : *new = ComboBox(     X, Y, Width, Height, Flag ) 
         Case "editor"        : *new = Editor(       X, Y, Width, Height, Flag )                                                                                                                          
         Case "tree"          : *new = Tree(         X, Y, Width, Height, Flag )                                                                                                                            
            ; Case "canvas"        : *new = Canvas(       X, Y, Width, Height, flag )                                                                                                                          
            
         Case "option"        : *new = Option(       X, Y, Width, Height, text$ )
            ; Case "scintilla"     : *new = Scintilla(    X, Y, Width, Height, Param1 )
            ; Case "shortcut"      : *new = Shortcut(     X, Y, Width, Height, Param1 )
         Case "ipaddress"     : *new = IPAddress(    X, Y, Width, Height )
            
      EndSelect
      
      If *new
         ; Debug ""+*parent\class +" "+ *new\class
         ;\\ первый метод формирования названия переменной
         newtype$ = type$+"_"+CountType( *new )
         ;Debug ""+*parent +" "+ newtype$
         ;\\ второй метод формирования названия переменной
         ;          If *parent = ide_design_MDI
         ;             newtype$ = ClassFromType( *new\type )+"_"+CountType( *new , 2 )
         ;          Else
         ;             newtype$ = ClassFromType( *parent\type )+"_"+CountType( *parent, 2 )+"_"+Class( *new )+"_"+CountType( *new , 2 )
         ;          EndIf
         ;\\
         SetClass( *new, UCase(newtype$) )
         SetText( *new, newtype$ )
         
         ;
         If IsContainer( *new )
            EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateNew|#_DD_reParent|#_DD_CreateCopy|#_DD_Group )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateNew )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_reParent )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateCopy )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_Group )
            If is_window_( *new )
               Protected *imagelogo = CatchImage( #PB_Any, ?imagelogo ); group_bottom )
               CompilerIf #PB_Compiler_DPIAware
                  ResizeImage(*imagelogo, DPIScaled(ImageWidth(*imagelogo)), DPIScaled(ImageHeight(*imagelogo)), #PB_Image_Raw)
               CompilerEndIf
               
               ;                If AddImages( *imagelogo )
               ;                   ;images( )\file$ = ReplaceString( #PB_Compiler_Home, "\", "/" ) + "ide/include/images/group/group_bottom.png"
               ;                   images( )\file$ = "ide/include/images/group/group_bottom.png"
               ;                   images( )\id$ = "*imagelogo"
               ;                EndIf
               
               SetImage( *new, *imagelogo )
               
               ;                If Not flag & #__flag_NoFocus 
               ;                   a_set(*new, #__a_full, (14))
               ;                EndIf
               SetBackColor( *new, $FFECECEC )
               ;
               Properties_Updates( *new, "Resize" )
               Bind( *new, @new_widget_events( ) )
            Else
               ;                If Not flag & #__flag_NoFocus 
               ;                   a_set(*new, #__a_full, (10))
               ;                EndIf
               ;                ;SetBackColor( *new, $FFF1F1F1 )
            EndIf 
            
            ; 
            *new\ChangeColor = 0
         Else
            ;             If Not flag & #__flag_NoFocus 
            ;                a_set(*new, #__a_full)
            ;             EndIf
         EndIf
         
         Bind( *new, @new_widget_events( ), #__event_Resize )
      EndIf
      
      CloseList( ) 
   EndIf
   
   ProcedureReturn *new
EndProcedure

Procedure new_widget_events( )
   Protected *new
   Protected __item
   Protected *g._s_WIDGET = EventWidget( )
   Protected __event = WidgetEvent( )
   Static anchors_group_show
   
   Select __event 
         ; disable buttons state
      Case #__event_Close, #__event_Maximize, #__event_Minimize
         ProcedureReturn #False
         ;
      Case #__event_Free
         If Not ( ide_design_MDI = *g )
            ; Debug "  do free "+item
            ; remove items 
            RemoveItem( ide_inspector_VIEW, GetData(*g)) 
            
            ; after remove items 
            If *g = a_focused( )
               Protected i, CountItems
               CountItems = CountItems( ide_inspector_VIEW ) 
               If CountItems 
                  ; update widget data item
                  For i = 0 To CountItems - 1
                     SetData( GetItemData( ide_inspector_VIEW, i ), i )
                  Next 
                  ;
                  ; set anchor focus
                  a_set( GetItemData( ide_inspector_VIEW, GetState( ide_inspector_VIEW ) ) )
               EndIf
            EndIf
            
            ;
            DeleteMapElement( GetObject( ), RemoveString( GetClass(*g), "#"+ClassFromType( GetType(*g))+"_" ))
         EndIf
         ;
      Case #__event_Focus
         __item = GetData(*g)
         If Not ( ide_design_MDI = *g )
            ; Debug  ""+GetFocus(*g)  +" "+ GetClass(*g)
            If a_focused( ) = *g
               If GetState( ide_inspector_VIEW ) = __item
                  ;Debug "FOCUS "+ __item  +" "+ GetClass(*g)
               Else
                  ;Debug "CHANGE "+ __item  +" "+ GetClass(*g)
                  If IsGadget( ide_g_inspector_VIEW )
                     SetGadgetState( ide_g_inspector_VIEW, __item )
                  EndIf
                  SetState( ide_inspector_VIEW, __item )
               EndIf
               
               Properties_Updates( *g, "Focus" )
            EndIf
         EndIf
         ;
      Case #__event_LeftDown
         If ( ide_design_MDI = *g )
            If Not a_focused( )
               If GetState( ide_inspector_VIEW ) > 0
                  Debug "select reset "+*g\class
                  SetState( ide_inspector_VIEW, - 1 )
               EndIf
            EndIf
         EndIf
         ;
         If IsContainer(*g)
            If GetState( ide_design_ELEMENTS ) > 0 
               If mouse( )\selector
                  mouse( )\selector\dotted = 0
               EndIf
            EndIf
         EndIf
         ;
         If *g\anchors
            If Not *g\anchors\group\show
               If anchors_group_show
                  anchors_group_show = #False
                  Debug "group hide"
                  HideBarButtons( ide_toolbar, #True )
                  ;
                  Define i, state
                  For i = 0 To CountItems( ide_inspector_VIEW )
                     If i <> GetData(*g)
                        state = GetItemState( ide_inspector_VIEW, i )
                        If state & #PB_Tree_Selected
                           SetItemState( ide_inspector_VIEW, i, state &~ #PB_Tree_Selected )
                        EndIf
                     EndIf
                  Next
               EndIf
            EndIf
         EndIf
         ;
      Case #__event_LeftUp
         If IsContainer(*g)
            If Not MouseDrag( )
               If GetState( ide_design_ELEMENTS) > 0
                  new_widget_add( *g, GetText( ide_design_ELEMENTS ), GetMouseX(*g), GetMouseY(*g))
               EndIf
            EndIf
         EndIf
         ;
         If a_anchors( )\group\show
            If Not *g\anchors\group\show
               anchors_group_show = 1
               Debug "group show"
               HideBarButtons( ide_toolbar, #False )
               ;
               If StartEnum(*g)
                  If widgets( )\anchors\group\show
                     SetItemState( ide_inspector_VIEW, GetData( widgets( )), #PB_Tree_Selected )
                  EndIf
                  StopEnum( )
               EndIf
            EndIf
         EndIf
         
         ;
         ;
         ;D&D
         ;
      Case #__event_DragStart
         If is_drag_move( )
            If DragDropPrivate( #_DD_reParent )
               ChangeCursor( *g, #PB_Cursor_Arrows )
            EndIf
         Else
            If IsContainer(*g) 
               If MouseEnter(*g)
                  If Not a_index( )
                     If GetState( ide_design_ELEMENTS ) > 0 
                        If DragDropPrivate( #_DD_CreateNew )
                           ChangeCursor( *g, #PB_Cursor_Cross )
                        EndIf
                     Else
                        If DragDropPrivate( #_DD_Group )
                           ChangeCursor( *g, #PB_Cursor_Cross )
                        EndIf
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
         ;
      Case #__event_Drop
         Select DropPrivate( )
            Case #_DD_Group
               Debug " ----- DD_group ----- " + GetClass(*g)
               
               ;             Case #_DD_reParent
               ;                Debug " ----- DD_move ----- " +GetClass(Pressed( )) +" "+ Entered(  )\class
               ;                If SetParent( Pressed( ), Entered(  ) )
               ;                   Protected i = 3 : Debug "re-parent "+ GetClass(Pressed( )\parent) +" "+ Pressed( )\x[i] +" "+ Pressed( )\y[i] +" "+ Pressed( )\width[i] +" "+ Pressed( )\height[i]
               ;                EndIf
               
            Case #_DD_CreateNew 
               Debug " ----- DD_new ----- "+ GetText( ide_design_ELEMENTS ) +" "+ DropX( ) +" "+ DropY( ) +" "+ DropWidth( ) +" "+ DropHeight( )
               new_widget_add( *g, GetText( ide_design_ELEMENTS ), DropX( ), DropY( ), DropWidth( ), DropHeight( ) )
               
            Case #_DD_CreateCopy
               Debug " ----- DD_copy ----- " + GetText( Pressed( ) )
               
               ;            *new = new_widget_add( *g, GetClass( Pressed( ) ), 
               ;                         X( Pressed( ) ), Y( Pressed( ) ), Width( Pressed( ) ), Height( Pressed( ) ) )
               
               *new = new_widget_add( *g, DropText( ), DropX( ), DropY( ), DropWidth( ), DropHeight( ) )
               SetText( *new, "Copy_"+ DropText( ) )
               
         EndSelect
         ;
      Case #__event_MouseMove
         If IsContainer(*g) 
            If MouseEnter(*g)
               If GetState( ide_design_ELEMENTS ) > 0 
                  If MousePress( )
                     ; disable drop 
                     If GetState( ide_design_ELEMENTS ) = 1
                        If *g = ide_design_MDI  
                        Else
                           If MouseDragStart( ) = #PB_Drag_Enter
                              MouseDragStart( ) = #PB_Drag_Leave
                           EndIf
                        EndIf
                     Else
                        If *g = ide_design_MDI  
                           If MouseDragStart( ) = #PB_Drag_Enter
                              MouseDragStart( ) = #PB_Drag_Leave
                           EndIf
                        Else
                        EndIf
                     EndIf
                  Else
                     If GetCursor( ) < 255
                        Debug " mouse enter to change cursor " 
                        ChangeCursor( *g, Cursor::Create( ImageID( GetItemData( ide_design_ELEMENTS, GetState( ide_design_ELEMENTS ) ) ) ))
                        a_set(*g)
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
         ;
      Case #__event_Resize
         ; Debug  ""+GetFocus(*g)  +" "+ GetClass(*g)
         If a_focused( ) = *g
            Properties_Updates( *g, "Resize" )
         EndIf
         ;
      Case #__event_CursorChange
         ; Debug "CURSOR events"
         ProcedureReturn #PB_Cursor_Default
         ;
   EndSelect
   
   
   ;\\
   If __event = #__event_Drop  Or 
      __event = #__event_RightUp Or
      __event = #__event_KeyUp Or
      __event = #__event_LeftUp
      ;
      ; end new create
      If Not keyboard( )\key[1]
         If GetState( ide_design_ELEMENTS ) > 0 
            If GetCursor( ) <> GetCursor(*g) 
               Debug " reset cursor " 
               ChangeCursor( *g, GetCursor(*g))
            EndIf
            SetState( ide_design_ELEMENTS, 0 )
         EndIf
      EndIf
   EndIf
   
   ; отключаем дальнейшую обработку всех событий
   ; а также события кнопок окна (Close, Maximize, Minimize)
   ProcedureReturn #PB_Ignore
EndProcedure

;-
;- LENGUAGE
#lng_NEW$                      = "New"
#lng_OPEN$                     = "Open"
#lng_SAVE$                     = "Save"
#lng_MENU$                     = "Menu"
#lng_QUIT$                     = "Quit"
#lng_SAVEAS$                   = "Save as..."
#lng_RUN$                      = "Run"
#lng_FORM$                     = "Form"
#lng_CODE$                     = "Code"
#lng_ELEMENTS$                 = "Elements"
#lng_PROPERTIES$               = "Properties"
#lng_EVENTS$                   = "Events"
#lng_LENGUAGE$                 = "Lenguage"
#lng_MESSAGE$                  = "Message"
#lng_MESSAGE_EXIT_QUESTION$    = "Are you sure you want to go out?"

LoadLng( "../IDE/lng.ini" )

;
Procedure ide_Lng_change( lng_TYPE=0 )
   If ChangeLng(lng_TYPE)
      ; Debug "  LNG CHANGE "+lng_TYPE
      ;
      SetBarItemText( ide_toolbar, 0, lng(#lng_Menu$))
      SetBarItemText( ide_toolbar, #_tb_file_new, lng(#lng_NEW$))
      SetBarItemText( ide_toolbar, #_tb_file_open, lng(#lng_OPEN$))
      SetBarItemText( ide_toolbar, #_tb_file_save, lng(#lng_SAVE$))
      SetBarItemText( ide_toolbar, #_tb_file_run, "["+UCase(lng(#lng_RUN$))+"]")
      SetBarItemText( ide_toolbar, #_tb_LNG, "["+UCase(lng(#lng_LENGUAGE$))+"]")
      ;
      SetBarItemText( ide_menu, #_tb_file_new, lng(#lng_NEW$)+" (Ctrl+N)")
      SetBarItemText( ide_menu, #_tb_file_open, lng(#lng_OPEN$)+" (Ctrl+O)")
      SetBarItemText( ide_menu, #_tb_file_save, lng(#lng_SAVE$)+" (Ctrl+S)")
      SetBarItemText( ide_menu, #_tb_file_SAVEAS, lng(#lng_SAVEAS$))
      SetBarItemText( ide_menu, #_tb_QUIT, lng(#lng_QUIT$))
      ;
      ; SetItemText( ide_inspector_PANEL, 0, lng(#lng_ELEMENTS$))
      SetItemText( ide_inspector_PANEL, 0, lng(#lng_PROPERTIES$))
      SetItemText( ide_inspector_PANEL, 1, lng(#lng_EVENTS$))
      
      SetItemText( ide_design_PANEL, 0, lng(#lng_FORM$))
      SetItemText( ide_design_PANEL, 1, lng(#lng_CODE$))
      SetItemText( ide_design_PANEL, 2, "V-"+lng(#lng_CODE$))
      
      ;\\
      If lng_TYPE = 0
         DisableBarButton( ide_popup_lenguage, #_tb_lng_ENG, #True )
         DisableBarButton( ide_popup_lenguage, #_tb_lng_RUS, #False )
         DisableBarButton( ide_popup_lenguage, #_tb_lng_GERMAN, #False )
         DisableBarButton( ide_popup_lenguage, #_tb_lng_FRENCH, #False )
      ElseIf lng_TYPE = 1
         DisableBarButton( ide_popup_lenguage, #_tb_lng_RUS, #True )
         DisableBarButton( ide_popup_lenguage, #_tb_lng_ENG, #False )
         DisableBarButton( ide_popup_lenguage, #_tb_lng_GERMAN, #False )
         DisableBarButton( ide_popup_lenguage, #_tb_lng_FRENCH, #False )
      ElseIf lng_TYPE = 2
         DisableBarButton( ide_popup_lenguage, #_tb_lng_FRENCH, #True )
         DisableBarButton( ide_popup_lenguage, #_tb_lng_ENG, #False )
         DisableBarButton( ide_popup_lenguage, #_tb_lng_RUS, #False )
         DisableBarButton( ide_popup_lenguage, #_tb_lng_GERMAN, #False )
      ElseIf lng_TYPE = 3
         DisableBarButton( ide_popup_lenguage, #_tb_lng_GERMAN, #True )
         DisableBarButton( ide_popup_lenguage, #_tb_lng_ENG, #False )
         DisableBarButton( ide_popup_lenguage, #_tb_lng_RUS, #False )
         DisableBarButton( ide_popup_lenguage, #_tb_lng_FRENCH, #False )
      EndIf
      
      Define *root._s_ROOT = ide_root
      PostReDraw( *root )
   EndIf
EndProcedure

;-
Procedure.S ide_help_VIEW_elements(Class.s)
   Protected Result.S
   
   Class = UCase(Class)
   
   Select TypeFromClass(Class)
      Case 0
         Result.S = "[" +Class+ "] - Элемент не выбран"
         
      Case #__type_Date
         Result.S = "Первая строка"+#CRLF$+
         "Вторая строка"
         
      Case #__type_Window
         Result.S = "[" +Class+ "] - Это окно"
         
      Case #__type_Button
         Result.S = "[" +Class+ "] - Это кнопка"
         
      Case #__type_ButtonImage
         Result.S = "[" +Class+ "] - Это кнопка картинка"
         
      Case #__type_CheckBox
         Result.S = "[" +Class+ "] - Это переключатель"
         
      Case #__type_ComboBox
         Result.S = "[" +Class+ "] - Это выподающий список"
         
      Case #__type_Image
         Result.S = "[" +Class+ "] - Это картинка"
         
      Case #__type_Calendar
         Result.S = "[" +Class+ "] - Это календарь"
         
      Case #__type_Canvas
         Result.S = "[" +Class+ "] - Это холст для рисования"
         
      Case #__type_Container
         Result.S = "[" +Class+ "] - Это контейнер для других элементов"
         
      Case #__type_Editor
         Result.S ="[" +Class+ "] - Это многострочное поле ввода"
         
      Default
         Result.S = "[" +Class+ "] - не реализованно"
         
   EndSelect
   
   ProcedureReturn Result.S
EndProcedure

Procedure ide_mdi_clears( )
   ; Очишаем текст
   ClearItems( ide_design_CODE ) 
   ; TEMP
   ClearItems( ide_help_DEBUG ) 
   ;
   ; удаляем всех детей у MDI (то есть освобождаем его)
   Free( ide_design_MDI )
   ;
   ; переключаем на форму 
   SetState( ide_design_PANEL, 0 )
   ;
   ; затем показываем гаджеты для добавления
   SetState( ide_inspector_PANEL, 0 )
EndProcedure

#File = 0
;
Procedure   ide_file_new( )
   ; очищаем MDI
   ide_mdi_clears( )
   ;
   ; затем создаем новое окно
   Define form = new_widget_add( ide_design_MDI, "window", 7, 7, 400, 250 )
   ;    SetPosition( form, #PB_List_After, ide_design_CODE )
   ;    
   ;    Debug "---"
   ;    ForEach widgets( )
   ;       If IsChild(widgets( ), ide_design_PANEL) 
   ;          Debug ""+widgets( )\class +" "+ widgets( )\level +" "+ widgets( )\TabIndex( )
   ;       EndIf
   ;    Next
   ;    Debug "---"
   
EndProcedure

Procedure   ide_file_open(Path$) ; Открытие файла
   Protected Text$, String$
   
   If Path$
      Debug "Открываю файл '"+Path$+"'"
      ClearDebugOutput( )
      ;
      ; очищаем MDI
      ide_mdi_clears( )
      ;
      If ReadFile( #File, Path$ ) ; Если файл можно прочитать, продолжаем...
         Define Text$ = ReadString( #File, #PB_File_IgnoreEOL ) ; чтение целиком содержимого файла
         FileSeek( #File, 0 )                                   ; 
         
         While Eof( #File ) = 0 ; Цикл, пока не будет достигнут конец файла. (Eof = 'Конец файла')
            String$ = ReadString( #File ) ; Построчный просмотр содержимого файла
            String$ = RemoveString( String$, "?" ) ; https://www.purebasic.fr/english/viewtopic.php?t=86467
            
            MakeLine( ide_design_MDI, String$, Text$ )
         Wend
         
         ;          
         ;          ForEach *parser\Line()
         ;             Debug *parser\Line()\func$ +"?"+ *parser\Line()\arg$
         ;          Next
         ;          ;
         ;          ;          ;
         ;          ;          Text$ = ReadString( #File, #PB_File_IgnoreEOL ) ; чтение целиком содержимого файла
         ;          ;
         ;          ; bug hides
         ;          If Not Hide( ide_design_CODE )
         ;             SetText( ide_design_CODE, Generate_Code( ide_design_MDI ) )
         ;          EndIf
         ;
         
         Define code$ = Generate_Code( ide_design_MDI )
         code$ = Mid( code$, FindString( code$, "Procedure Open_" ))
         code$ = Mid( code$, 1, FindString( code$, "EndProcedure" ))+"ndProcedure"
         SetText( ide_help_DEBUG, code$ )
         
         ;
         CloseFile(#File) ; Закрывает ранее открытый файл
         Debug "..успешно"
         ProcedureReturn 1
      Else
         ProcedureReturn 0
      EndIf
   Else
      ProcedureReturn 1
   EndIf 
EndProcedure

Procedure   ide_file_save(Path$) ; Процедура сохранения файла
   Protected Space$, Text$
   Protected len, Length, Position, Object
   
   If Path$
      ClearDebugOutput()
      Debug "Сохраняю файл '"+Path$+"'"
      
      ;
      If #PB_MessageRequester_Yes = Message("Как вы хотите сохранить",
         " Нажмите OK чтобы сохранить PUREBASIC код"+#LF$+
         " Нажмите NO чтобы сохранить WIDGET коде", #PB_MessageRequester_YesNo)
         Text$ = Generate_Code( ide_design_MDI )
      Else
         Text$ = GetText( ide_design_CODE )
      EndIf
      
      ;
      If CreateFile( #File, Path$, #PB_UTF8 )
         ; TruncateFile( #File )
         
         WriteStringFormat( #File, #PB_UTF8 )
         WriteString( #File, Text$, #PB_UTF8 )
         CloseFile( #File )
         
         Debug "..успешно"
         ProcedureReturn 1
      Else
         ProcedureReturn 0
      EndIf
   Else
      ProcedureReturn 1
   EndIf
EndProcedure

;-
Procedure   ide_inspector_VIEW_ADD_ITEMS( *new._s_widget )
   Protected *parent._s_widget, Param1, Param2, Param3, newClass.s = GetClass( *new )
   
   If ide_inspector_VIEW
      If *new
         *parent = GetParent( *new )
         ;
         ; get new add position & sublevel
         Protected i, count, sublevel, position
         count = CountItems( ide_inspector_VIEW )
         position = GetData( *parent ) 
         ;
         For i = 0 To count - 1
            Position = ( i+1 )
            
            If *parent = GetItemData( ide_inspector_VIEW, i ) 
               SubLevel = GetItemAttribute( ide_inspector_VIEW, i, #PB_Tree_SubLevel ) + 1
               Continue
            EndIf
            
            If SubLevel > GetItemAttribute( ide_inspector_VIEW, i, #PB_Tree_SubLevel )
               Position = i
               Break
            EndIf
         Next 
         
         ; set new widget data
         SetData( *new, position )
         
         ; update new widget data item ;????
         If count > position
            For i = position To count - 1
               SetData( GetItemData( ide_inspector_VIEW, i ), i + 1 )
            Next 
         EndIf
         
         
         ; get image associated with class
         Protected img =- 1
         count = CountItems( ide_design_ELEMENTS )
         For i = 0 To count - 1
            If LCase( ClassFromType( GetType(*new))) = LCase( GetItemText( ide_design_ELEMENTS, i ))
               img = GetItemData( ide_design_ELEMENTS, i )
               Break
            EndIf
         Next  
         
         ; add to inspector
         AddItem( ide_inspector_VIEW, position, newClass.s, img, sublevel )
         SetItemData( ide_inspector_VIEW, position, *new )
         ; SetItemState( ide_inspector_VIEW, position, #PB_tree_selected )
         ; SetState( ide_inspector_VIEW, position )
         
         If IsGadget( ide_g_inspector_VIEW )
            AddGadgetItem( ide_g_inspector_VIEW, position, newClass.s, ImageID(img), SubLevel )
            SetGadgetItemData( ide_g_inspector_VIEW, position, *new )
            ; SetGadgetItemState( ide_g_inspector_VIEW, position, #PB_tree_selected )
            SetGadgetState( ide_g_inspector_VIEW, position ) ; Bug
         EndIf
         
         ; Debug  " pos "+position + "   ( Debug >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" ) )"
      EndIf
   EndIf
   
   ProcedureReturn *new
EndProcedure

Procedure.i ide_design_ELEMENTS_ADD_ITEMS( *id, Directory$ )
   Protected ZipFile$ = Directory$ + "SilkTheme.zip"
   
   If FileSize( ZipFile$ ) < 1
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
         ZipFile$ = #PB_Compiler_Home+"themes\SilkTheme.zip"
      CompilerElse
         ZipFile$ = #PB_Compiler_Home+"themes/SilkTheme.zip"
      CompilerEndIf
      If FileSize( ZipFile$ ) < 1
         MessageRequester( "Designer Error", "Themes\SilkTheme.zip Not found in the current directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error | #PB_MessageRequester_Ok )
         End
      EndIf
   EndIf
   ;   Directory$ = GetCurrentDirectory( )+"images/" ; "";
   ;   Protected ZipFile$ = Directory$ + "images.zip"
   
   
   If FileSize( ZipFile$ ) > 0
      ; UsePNGImageDecoder( )
      
      CompilerIf #PB_Compiler_Version > 522
         UseZipPacker( )
      CompilerEndIf
      
      Protected PackEntryName.s, ImageSize, *memory, Image, ZipFile, name$
      ZipFile = OpenPack( #PB_Any, ZipFile$, #PB_PackerPlugin_Zip )
      
      If ZipFile  
         If ExaminePack( ZipFile )
            While NextPackEntry( ZipFile )
               
               PackEntryName.S = PackEntryName( ZipFile )
               ImageSize = PackEntrySize( ZipFile )
               If ImageSize
                  *memory = AllocateMemory( ImageSize )
                  UncompressPackMemory( ZipFile, *memory, ImageSize )
                  PackEntryName.S = ReplaceString( PackEntryName.S,".png","" )
                  
                  If PackEntryName.S="application_form" 
                     PackEntryName.S="vd_windowgadget"
                  EndIf
                  
                  If PackEntryName.S="page_white_edit" 
                     PackEntryName.S="vd_scintillagadget"
                  EndIf
                  
                  Select PackEntryType( ZipFile )
                     Case #PB_Packer_File
                        If FindString( Left( PackEntryName.S, 3 ), "vd_" )
                           PackEntryName.S = ReplaceString( PackEntryName.S,"vd_","" )
                           PackEntryName.S = ReplaceString( PackEntryName.S,"gadget","" )
                           PackEntryName.S = ReplaceString( PackEntryName.S,"bar","" )
                           PackEntryName = LCase( PackEntryName.S )
                           
                           name$ = UCase( Left( PackEntryName.S, 1 ) ) + 
                                   Right( PackEntryName.S, Len( PackEntryName.S )-1 )
                           
                           
                           If FindString( PackEntryName, "cursor" )
                              Image = CatchImage( #PB_Any, *memory, ImageSize )
                              AddItem( *id, 0, name$, Image )
                              SetItemData( *id, 0, Image )
                              Image = #Null
                              
                           ElseIf FindString( PackEntryName, "window" ) Or
                                  FindString( PackEntryName, "panel" ) Or
                                  FindString( PackEntryName, "container" ) Or
                                  FindString( PackEntryName, "scrollarea" ) Or
                                  FindString( PackEntryName, "splitter" )
                              
                              name$ = ReplaceString( name$,"area","Area", #PB_String_NoCase )
                              Image = CatchImage( #PB_Any, *memory, ImageSize )
                              AddItem( *id, -1, name$, Image )
                              SetItemData( *id, CountItems( *id )-1, Image )
                              
                           ElseIf FindString( PackEntryName, "button" ) Or
                                  FindString( PackEntryName, "option" ) Or
                                  FindString( PackEntryName, "checkbox" ) Or
                                  FindString( PackEntryName, "combobox" )
                              
                              name$ = ReplaceString( name$,"image","Image", #PB_String_NoCase )
                              name$ = ReplaceString( name$,"box","Box", #PB_String_NoCase )
                              Image = CatchImage( #PB_Any, *memory, ImageSize )
                              AddItem( *id, -1, name$, Image )
                              SetItemData( *id, CountItems( *id )-1, Image )
                              
                           ElseIf FindString( PackEntryName, "image" )
                              Image = CatchImage( #PB_Any, *memory, ImageSize )
                              AddItem( *id, -1, name$, Image )
                              SetItemData( *id, CountItems( *id )-1, Image )
                              
                           ElseIf FindString( PackEntryName, "string" ) Or
                                  FindString( PackEntryName, "text" )
                              
                              Image = CatchImage( #PB_Any, *memory, ImageSize )
                              AddItem( *id, -1, name$, Image )
                              SetItemData( *id, CountItems( *id )-1, Image )
                              
                           ElseIf FindString( PackEntryName, "progress" ) Or
                                  FindString( PackEntryName, "track" ) Or
                                  FindString( PackEntryName, "spin" )
                              
                              Image = CatchImage( #PB_Any, *memory, ImageSize )
                              AddItem( *id, -1, name$, Image )
                              SetItemData( *id, CountItems( *id )-1, Image )
                              
                           ElseIf FindString( PackEntryName, "tree" ) Or
                                  FindString( PackEntryName, "listview" )
                              
                              Image = CatchImage( #PB_Any, *memory, ImageSize )
                              AddItem( *id, -1, name$, Image )
                              SetItemData( *id, CountItems( *id )-1, Image )
                              
                           Else
                              ;                               Image = CatchImage( #PB_Any, *memory, ImageSize )
                              ;                               AddItem( *id, -1, name$, Image )
                              ;                               SetItemData( *id, CountItems( *id )-1, Image )
                           EndIf
                           
                        EndIf    
                  EndSelect
                  
                  FreeMemory( *memory )
               EndIf
            Wend  
         EndIf
         
         ; select cursor
         SetState( *id, 0 )
         ClosePack( ZipFile )
      EndIf
   EndIf
EndProcedure

;-
Procedure   ide_menu_events(  )
   Protected *g._s_WIDGET = EventWidget( ), BarButton = WidgetEventItem( )
   Protected transform, move_x, move_y
   Static NewList *copy._s_WIDGET( )
   
   ; Debug "ide_menu_events "+BarButton
   
   Select BarButton
      Case #_tb_QUIT
         PostClose( *g\root )
         
      Case #_tb_lng_ENG
         ide_Lng_change( #ENG )
         
      Case #_tb_lng_RUS
         ide_Lng_change( #RUS )
         
      Case #_tb_lng_FRENCH
         ide_Lng_change( #FRENCH )
         
      Case #_tb_lng_GERMAN
         ide_Lng_change( #GERMAN )
         
      Case #_tb_widget_copy
         new_widget_copy( )
         
      Case #_tb_widget_cut
         ; new_widget_copy( )
         Protected *i = a_focused( )
         ;          AddElement( *copy( ) ) 
         ;    *copy.allocate( widget, ( ) )
         ;    CopyStructure( *i, *copy( ), _s_WIDGET)
         ChangeCurrentElement( widgets( ), a_focused( )\address )
         ;CopyList( widgets( ), *copy( ))
         ;MergeLists( widgets( ), *copy( ))
         SplitList( widgets( ), *copy( ))
         Debug ListSize(*copy( ))
         
         ;new_widget_delete( a_focused( ) )
         
      Case #_tb_widget_paste
         new_widget_paste( )
         
      Case #_tb_widget_delete
         new_widget_delete( a_focused( ) )
         
         
      Case #_tb_group_select
         If GetType(*g) = #__type_ToolBar
            If GetItemState( *g, BarButton )  
               ; group
               group_select = *g
               ; SetAtributte( *g, #PB_Button_PressedImage )
            Else
               ; un group
               group_select = 0
            EndIf
         Else
            If GetState(*g)  
               ; group
               group_select = *g
               ; SetAtributte( *g, #PB_Button_PressedImage )
            Else
               ; un group
               group_select = 0
            EndIf
         EndIf
         
      Case #_tb_group_left
         a_align( a_focused( ), 1 )
      Case #_tb_group_right 
         a_align( a_focused( ), 3 )
      Case #_tb_group_top 
         a_align( a_focused( ), 2 )
      Case #_tb_group_bottom
         a_align( a_focused( ), 4 )
      Case #_tb_group_width 
         a_align( a_focused( ), 5 )
      Case #_tb_group_height
         a_align( a_focused( ), 6 )
         
         
         ;  RUN
      Case #_tb_file_run
         Define Code.s = Generate_Code( ide_design_MDI ) ;GetText( ide_design_CODE )
         
         RunPreview( Code )
         
      Case #_tb_file_new
         ide_file_new( )
         
      Case #_tb_file_open
         Protected StandardFile$, Pattern$, File$
         StandardFile$ = "open_example.pb" 
         Pattern$ = "PureBasic (*.pb)|*.pb;*.pbi;*.pbf"
         File$ = OpenFileRequester("Пожалуйста выберите файл для загрузки", StandardFile$, Pattern$, 0)
         
         SetWindowTitle( EventWindow(), File$ )
         
         If Not ide_file_open( File$ )
            Message("Информация", "Не удалось открыть файл.")
         EndIf
         
      Case #_tb_file_save
         StandardFile$ = "save_example.pbf" 
         Pattern$ = "PureBasic (*.pb)|*.pb;*.pbi;*.pbf"
         File$ = SaveFileRequester("Пожалуйста выберите файл для сохранения", StandardFile$, Pattern$, 0)
         
         If Not ide_file_save( File$ )
            Message("Информация","Не удалось сохранить файл.", #PB_MessageRequester_Error)
         EndIf
         
         
   EndSelect
   
EndProcedure

Procedure   ide_events( )
   Protected *this._s_widget
   Protected *g._s_WIDGET = EventWidget( )
   Protected __event = WidgetEvent( )
   Protected __item = WidgetEventItem( )
   Protected __data = WidgetEventData( )
   ; Debug ""+EventString(__event) +" "+ GetClass(*g)
   
   Select __event
      Case #__event_Focus
         If is_root_(*g)
            If PreviewRunning And 
               IsProgram(PreviewRunning) And 
               ProgramRunning(PreviewRunning)
               ;
               KillProgram(PreviewRunning)
               CloseProgram(PreviewRunning)
               Delay(50)
               PreviewRunning = 0
            EndIf
         EndIf
         If Not PreviewProgramName$ = "" And
            FileSize(PreviewProgramName$)
            DeleteFile(PreviewProgramName$)
            PreviewProgramName$ = ""
         EndIf
         
      Case #__event_Free
         Debug "  do free " + *g\class
         ProcedureReturn #True
         
      Case #__event_Close
         If *g = ide_root
            If #PB_MessageRequester_Yes = Message( lng( #lng_MESSAGE$ ), 
                                                   lng( #lng_MESSAGE_EXIT_QUESTION$ ),
                                                   #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
               ProcedureReturn #PB_All
            Else
               ProcedureReturn #False ; no close
            EndIf
         EndIf
         
      Case #__event_DragStart
         If *g = ide_design_ELEMENTS
            If __item >= 0
               SetState( *g, __item)
               
               Debug " ------ drag ide_events() ----- "
               If DragDropPrivate( #_DD_CreateNew )
                  ChangeCursor( *g, Cursor::Create( ImageID( GetItemData( *g, __item ) ) ) )
               EndIf
            EndIf
         EndIf
         
      Case #__event_Change
         If *g = ide_inspector_VIEW
            If a_set( GetItemData( *g, GetState(*g) ))
            EndIf
         EndIf
         
         If *g = ide_design_PANEL
            If __item = 0
               SetActive( ide_design_MDI )
            EndIf
            
            If __item = 1
               AddItem( ide_design_CODE, 0, "" ) ; BUG 
               SetText( ide_design_CODE, Generate_Code( ide_design_MDI ) )
               SetActive( ide_design_CODE )
            EndIf
         EndIf
         
      Case #__event_StatusChange
         If __item = - 1
            SetText( ide_help_VIEW, "help for the inspector" )
         Else
            If __data < 0
               If *g = ide_design_ELEMENTS
                  SetText( ide_help_VIEW, ide_help_VIEW_elements(GetItemText( *g, __item )) )
               EndIf
               If *g = ide_inspector_VIEW
                  SetText( ide_help_VIEW, GetItemText( *g, __item ) )
               EndIf
               If *g = ide_inspector_PROPERTIES
                  SetText( ide_help_VIEW, GetItemText( *g, __item ) )
               EndIf
               If *g = ide_inspector_EVENTS
                  SetText( ide_help_VIEW, GetItemText( *g, __item ) )
               EndIf
            EndIf
         EndIf
         
   EndSelect
   
   
   ; CODE EDIT EVENTS
   If *g = ide_design_CODE                      Or *g = ide_help_DEBUG ; TEMP
      Static argument, object  
      Protected name$, text$, len, caret
      Protected *line._s_ROWS
      
      ;
      If __event = #__event_Down
         If __data
            *line._s_ROWS  = __data
            text$ = *line\text\string
            len = *line\text\len
            caret = *g\text\caret\pos[1] - *line\text\pos
            
            ;
            If text$
               *g\text\numeric = 0 
               *g\text\editable = 0 
               
               name$ = *g\text\caret\word ; GetWord( text$, len, caret ) 
               
               If name$
                  object = MakeID( name$, ide_design_MDI )
                  If Not object
                     If CountString( text$, "=" )
                        name$ = Trim( StringField( text$, 1, "=" ))
                        If CountString( name$, " " )
                           name$ = Trim( StringField( name$, 2, " " ))
                        EndIf
                     EndIf
                     
                     object = MakeID( name$, ide_design_MDI )
                  EndIf
               EndIf
               
               ;
               If object
                  
                  ;argument =  CountString( Left( text$, caret ), "," ) + 1 
                  argument = GetArgIndex( text$, len, caret ) 
                  name$ = *g\text\caret\word
                  If name$ <> GetClass( object )
                     If CountString( text$, "(" )
                        name$ = Trim( StringField( text$, 1, "(" ))
                        name$ = GetWord( name$, Len( name$ ), Len( name$ ) ) 
                     EndIf
                  EndIf
                  If argument
                     If name$ = ClassFromType( GetType( object ))
                        argument + 1
                     EndIf
                     If name$ = GetClass( object )
                        argument - 1
                     EndIf
                  EndIf
                  
                  Debug "?"+ argument +" "+ name$
                  
                  If argument > 1
                     If argument < 6 ; coordinate
                        *g\text\numeric = 1 
                     EndIf
                     *g\text\editable = 1 
                  EndIf
                  
                  If GetClass( object ) = *g\text\caret\word ; GetWord( text$, len, caret )
                     *g\text\editable = 1
                     *g\text\upper = 1 
                  Else
                     *g\text\upper = 0 
                  EndIf
               EndIf
               
               If *g\text\editable
                  *line\color\back[1] = *g\color\back[1]
               Else
                  *line\color\back[1] = $CD9CC3EE
               EndIf
            EndIf
         EndIf
      EndIf
      
      ;
      If __event = #__event_Change
         If object
            ReplaceArg( object, argument, *g\text\caret\word ) 
            ; ReplaceArg( object, argument, GetWord( *line\text\string, *line\text\len, *g\text\caret\pos[1] - *line\text\pos )  )
         EndIf
      EndIf
   EndIf
   
EndProcedure

Procedure   ide_open( X=50,Y=75,Width=1000,Height=700 )
   Define Flag = #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget | #PB_Window_Invisible
   ide_root = Open( 1, X,Y,Width,Height, "ide", Flag ) 
   ide_window = GetCanvasWindow( ide_root )
   ide_g_canvas = GetCanvasGadget( ide_root )
   WindowBounds( ide_window, 800, 500, #PB_Ignore, #PB_Ignore )
   
   ;    Debug "create window - "+WindowID(ide_window)
   ;    Debug "create canvas - "+GadgetID(ide_g_canvas)
   
   ide_toolbar_container = Container( 0,0,0,0, #__flag_BorderFlat ) 
   ide_toolbar = CreateBar( ide_toolbar_container, #PB_ToolBar_Small );|#PB_ToolBar_Large|#PB_ToolBar_Buttons);| #PB_ToolBar_InlineText )
   SetColor(ide_toolbar, #PB_Gadget_BackColor, $fffefefe )
   
   ide_menu = OpenSubBar(lng(#lng_MENU$))
   BarItem( #_tb_file_new, lng(#lng_NEW$)+" (Ctrl+N)")
   BarItem( #_tb_file_open, lng(#lng_OPEN$)+" (Ctrl+O)")
   BarItem( #_tb_file_save, lng(#lng_SAVE$)+" (Ctrl+S)")
   BarItem( #_tb_file_SAVEAS, lng(#lng_SAVEAS$))
   BarSeparator( )
   BarItem( #_tb_QUIT, lng(#lng_QUIT$) );+ Chr(9) + "Ctrl+Q")
   CloseSubBar( )
   ;
   BarSeparator( )
   BarItem( #_tb_file_new, lng(#lng_NEW$) )
   BarItem( #_tb_file_open, lng(#lng_OPEN$) )
   BarItem( #_tb_file_save, lng(#lng_SAVE$) )
   BarSeparator( )
   BarButton( #_tb_widget_copy, CatchImage( #PB_Any,?image_new_widget_copy ) )
   BarButton( #_tb_widget_cut, CatchImage( #PB_Any,?image_new_widget_cut ) )
   BarButton( #_tb_widget_paste, CatchImage( #PB_Any,?image_new_widget_paste ) )
   BarSeparator( )
   BarButton( #_tb_widget_delete, CatchImage( #PB_Any,?image_new_widget_delete ) )
   
   BarSeparator( )
   BarButton( #_tb_group_select, CatchImage( #PB_Any,?image_group ), #PB_ToolBar_Toggle ) 
   ;
   ;    SetItemAttribute( widget( ), #_tb_group_select, #PB_Button_Image, CatchImage( #PB_Any,?image_group_un ) )
   ;    SetItemAttribute( widget( ), #_tb_group_select, #PB_Button_PressedImage, CatchImage( #PB_Any,?image_group ) )
   ;
   BarSeparator( )
   BarButton( #_tb_group_width, CatchImage( #PB_Any,?image_group_width ) )
   BarButton( #_tb_group_height, CatchImage( #PB_Any,?image_group_height ) )
   BarSeparator( )
   BarButton( #_tb_group_left, CatchImage( #PB_Any,?image_group_left ) )
   BarButton( #_tb_group_right, CatchImage( #PB_Any,?image_group_right ) )
   BarSeparator( )
   BarButton( #_tb_group_top, CatchImage( #PB_Any,?image_group_top ) )
   BarButton( #_tb_group_bottom, CatchImage( #PB_Any,?image_group_bottom ) )
   BarSeparator( )
   BarItem( #_tb_file_run, "[RUN]" )
   BarSeparator( )
   ide_popup_lenguage = OpenSubBar("[LENGUAGE]")
   If ide_popup_lenguage
      BarItem(#_tb_lng_ENG, "ENG")
      BarItem(#_tb_lng_RUS, "RUS")
      BarItem(#_tb_lng_FRENCH, "FRENCH")
      BarItem(#_tb_lng_GERMAN, "GERMAN")
   EndIf
   CloseSubBar( )
   BarSeparator( )
   ;
   CloseList( )
   
   DisableBarItem( ide_popup_lenguage, #_tb_lng_ENG, #True )
   ;DisableBarButton( ide_popup_lenguage, #_tb_lng_ENG, #True )
   ;DisableBarButton( ide_toolbar, #_tb_lng_ENG, #True )
   HideBarButtons( ide_toolbar, #True )
   
   ;
   ; gadgets
   ;
   ide_inspector_VIEW = Tree( 0,0,0,0 ) : SetClass(ide_inspector_VIEW, "ide_inspector_VIEW" ) ;, #__flag_gridlines )
   EnableDrop( ide_inspector_VIEW, #PB_Drop_Text, #PB_Drag_Link )
   
   ide_design_ELEMENTS = Tree( 0,0,0,0, #__flag_autosize | #__flag_NoButtons | #__flag_NoLines ) : SetClass(ide_design_ELEMENTS, "ide_design_ELEMENTS" )
   If ide_design_ELEMENTS
      Define *g._s_WIDGET = ide_design_ELEMENTS
      ;*g\padding\x = DPIScaled(4)
      ide_design_ELEMENTS_ADD_ITEMS( ide_design_ELEMENTS, GetCurrentDirectory( )+"Themes/" )
   EndIf
   ide_properties_SPLITTER = Splitter( 0,0,0,0, ide_inspector_VIEW, ide_design_ELEMENTS, #__flag_autosize) : SetClass(ide_properties_SPLITTER, "ide_properties_SPLITTER" )

   ;\\\ 
   ide_design_PANEL = Panel( 0,0,0,0, #__flag_autosize ) : SetClass(ide_design_PANEL, "ide_design_PANEL" ) ; , #__flag_Vertical ) : OpenList( ide_design_PANEL )
   AddItem( ide_design_PANEL, -1, lng(#lng_FORM$) )
   ide_design_MDI = MDI( 0,0,0,0, #__flag_autosize|#__flag_BorderLess ) : SetClass(ide_design_MDI, "ide_design_MDI" ) ;: SetFrame(ide_design_MDI, 10)
   SetColor( ide_design_MDI, #PB_Gadget_BackColor, $FFD3D3D3 )
   a_init( ide_design_MDI);, 0 )
   
   AddItem( ide_design_PANEL, -1, lng(#lng_CODE$) )
   ide_design_CODE = Editor( 0,0,0,0, #__flag_autosize|#__flag_BorderLess ) : SetClass(ide_design_CODE, "ide_design_CODE" ) ; bug then move anchors window
   SetBackColor( ide_design_CODE, $FFDCF9F6)
   AddItem( ide_design_PANEL, -1, "V-"+lng(#lng_CODE$) )
   CloseList( )
   
   ;
   ide_help_DEBUG = Editor( 0,0,0,0, #PB_Editor_ReadOnly ) : SetClass(ide_help_DEBUG, "ide_help_DEBUG" )
   ;ide_help_DEBUG = Editor( 0,0,0,0) : SetClass(ide_help_DEBUG, "ide_help_DEBUG" )
   If Not ide_design_CODE
      ide_design_CODE = ide_help_DEBUG
   EndIf
   
   Define Transparent ;= #__flag_Transparent
   ;\\\ open inspector gadgets 
   ; ide_inspector_PANEL_open
   ide_inspector_PANEL = Panel( 0,0,0,0 ) : SetClass(ide_inspector_PANEL, "ide_inspector_PANEL" )
   
   ; ide_inspector_PANEL_item_1 
   ;AddItem( ide_inspector_PANEL, -1, "elements", 0, 0 ) 
   
   ; ide_inspector_PANEL_item_2
   AddItem( ide_inspector_PANEL, -1, "properties", 0, 0 )  
   ide_inspector_PROPERTIES = Properties_Create( 0,0,0,0, #__flag_autosize ) : SetClass(ide_inspector_PROPERTIES, "ide_inspector_PROPERTIES" )
   If ide_inspector_PROPERTIES
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_group_COMMON, "COMMON" )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_ID,             "#ID",      #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_class,          "Class",    #__type_String, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_text,           "Text",     #__type_String, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_IMAGE,          "Image",    #__type_Button, 1 )
      ;
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_flag,         "Flag",       #__type_ComboBox, 1 )
   ;
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_group_LAYOUT, "LAYOUT" )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_align,          "Align"+Chr(10)+"LEFT|TOP", #__type_Button, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_x,              "X",        #__type_Spin, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_y,              "Y",        #__type_Spin, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_width,          "Width",    #__type_Spin, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_height,         "Height",   #__type_Spin, 1 )
      ;
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_group_VIEW,   "VIEW" )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_cursor,         "Cursor",   #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_hide,           "Hide",     #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_disable,        "Disable",  #__type_ComboBox, 1 )
      ;
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_FONT,         "FONT",       #__type_Button, 0 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_fontsize,       "size",     #__type_Spin, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_fontstyle,      "style",    #__type_ComboBox, 1 )
      ;
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_COLOR,        "COLOR",      #__type_Button, 0 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_colortype,       "type",    #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_colorstate,      "state",   #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_coloralpha,      "alpha",   #__type_Spin, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_colorblue,       "blue",    #__type_Spin, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_colorgreen,      "green",   #__type_Spin, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_colorred,        "red",     #__type_Spin, 1 )
      EndIf
   
   ; ide_inspector_PANEL_item_3 
   AddItem( ide_inspector_PANEL, -1, "events", 0, 0 )  
   ide_inspector_EVENTS = Properties_Create( 0,0,0,0, #__flag_autosize | #__flag_gridlines | #__flag_Borderless ) : SetClass(ide_inspector_PROPERTIES, "ide_inspector_PROPERTIES" )
   If ide_inspector_EVENTS
      Properties_AddItem( ide_inspector_EVENTS, -1,  "LEFT" )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_leftdown,  "Down", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_leftup,  "Up", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_left1Click,  "Click", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_left2Click,  "Click2", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_left3Click,  "Click3", #__type_ComboBox, 1 )
      ;
      Properties_AddItem( ide_inspector_EVENTS, -1,  "RIGHT" )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_rightdown,  "Down", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_rightup,  "Up", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_right1Click,  "Click", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_right2Click,  "Click2", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_right3Click,  "Click3", #__type_ComboBox, 1 )
      ;
      Properties_AddItem( ide_inspector_EVENTS, -1,  "MIDDLE" )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_middledown,  "Down", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_middleup,  "Up", #__type_ComboBox, 1 )
      ;
      Properties_AddItem( ide_inspector_EVENTS, -1,  "MOUSE" )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_enter,  "Enter", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_leave,  "Leave", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_move,  "Move", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_wheel,  "Wheel", #__type_ComboBox, 1 )
      ;
      Properties_AddItem( ide_inspector_EVENTS, #_ei_change,  "CHANGE", #__type_ComboBox )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_status,  "Status", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_scroll,  "Scroll", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_focus,  "Focus", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_lostfocus,  "LostFocus", #__type_ComboBox, 1 )
      ;
      Properties_AddItem( ide_inspector_EVENTS, -1,  "OTHERS" )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_resize,  "Resize", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_free,  "Free", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_drop,  "Drop", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_dragStart,  "DragStart", #__type_ComboBox, 1 )
     ;
      Properties_AddItem( ide_inspector_EVENTS, -1,  "KEY" )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_keydown,  "Down", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_keyup,  "Up", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_keyinput,  "Input", #__type_ComboBox, 1 )
       ;
      Properties_AddItem( ide_inspector_EVENTS, -1,  "WINDOWS" )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_close,  "Close", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_minimize,  "Maximize", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_maximize,  "Minimize", #__type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_EVENTS, #_ei_restore,  "Restore", #__type_ComboBox, 1 )
   EndIf
   
   ; ide_inspector_PANEL_close
   CloseList( )
   ; SetState( ide_inspector_PANEL, 1 )
   ; BarPosition( ide_inspector_PANEL, 4 )
   
   ; ide_inspector_ide_properties_SPLITTER_text
   ide_help_VIEW  = Text( 0,0,0,0, "help for the inspector", #__flag_BorderFlat ) : SetClass(ide_help_VIEW, "ide_help_VIEW" )
   ;\\\ close inspector gadgets 
   
;    ;
;    ;\\\ ide splitters
;    ;
Global ide_SPLITTER =- 1
   ;
   ;\\ main splitter 2 example 
   ide_design_SPLITTER = Splitter( 0,0,0,0, ide_properties_SPLITTER, ide_design_PANEL, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical|Transparent ) : SetClass(ide_design_SPLITTER, "ide_design_SPLITTER" )
   ide_help_SPLITTER = Splitter( 0,0,0,0, ide_help_VIEW, ide_help_DEBUG, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical|Transparent ) : SetClass(ide_help_SPLITTER, "ide_help_SPLITTER" )
   ide_debug_SPLITTER = Splitter( 0,0,0,0, ide_design_SPLITTER, ide_help_SPLITTER, #PB_Splitter_SecondFixed|Transparent ) : SetClass(ide_debug_SPLITTER, "ide_debug_SPLITTER" )
   ide_SPLITTER = Splitter( 0,0,0,0, ide_debug_SPLITTER, ide_inspector_PANEL, #PB_Splitter_SecondFixed | #PB_Splitter_Vertical|Transparent ) : SetClass(ide_debug_SPLITTER, "ide_debug_SPLITTER" )
   ide_main_SPLITTER = Splitter( 0,0,0,0, ide_toolbar_container, ide_SPLITTER,#__flag_autosize | #PB_Splitter_FirstFixed|Transparent ) : SetClass(ide_main_SPLITTER, "ide_main_SPLITTER" )
   
   ; set splitters default minimum size
   SetAttribute( ide_design_SPLITTER, #PB_Splitter_FirstMinimumSize, 80 )
   SetAttribute( ide_design_SPLITTER, #PB_Splitter_SecondMinimumSize, 350 )
   SetAttribute( ide_help_SPLITTER, #PB_Splitter_FirstMinimumSize, 80 )
   SetAttribute( ide_help_SPLITTER, #PB_Splitter_SecondMinimumSize, 350 )
   ;
   SetAttribute( ide_debug_SPLITTER, #PB_Splitter_FirstMinimumSize, 350 )
   SetAttribute( ide_debug_SPLITTER, #PB_Splitter_SecondMinimumSize, 80 )
   SetAttribute( ide_SPLITTER, #PB_Splitter_FirstMinimumSize, 450 )
   SetAttribute( ide_SPLITTER, #PB_Splitter_SecondMinimumSize, 120 )
   ;
   SetAttribute( ide_properties_SPLITTER, #PB_Splitter_FirstMinimumSize, 100 )
   SetAttribute( ide_properties_SPLITTER, #PB_Splitter_SecondMinimumSize, 100 )
   SetAttribute( ide_main_SPLITTER, #PB_Splitter_FirstMinimumSize, 20 )
   SetAttribute( ide_main_SPLITTER, #PB_Splitter_SecondMinimumSize, 350 )
   
   ; set splitters dafault positions
   SetState( ide_main_SPLITTER, Height( ide_toolbar )) 
   SetState( ide_SPLITTER, Width( ide_SPLITTER ) - 250 )
   SetState( ide_debug_SPLITTER, Height( ide_debug_SPLITTER ) - 150 )
   
   ;SetState( ide_properties_SPLITTER, Height(ide_properties_SPLITTER) - 150 )
   SetState( ide_properties_SPLITTER, 150 )
   SetState( ide_design_SPLITTER, 180 )
   SetState( ide_help_SPLITTER, 180 )
   
   ;
   ;-\\ ide binds events
   ;
   If GetType( ide_toolbar ) = #__type_ToolBar
      Bind( ide_menu, @ide_menu_events( ) )
      Bind( ide_toolbar, @ide_menu_events( ) )
      Bind( ide_popup_lenguage, @ide_menu_events( ) )
   EndIf
   Bind( ide_inspector_VIEW, @ide_events( ) )
   ;
   Bind( ide_inspector_PROPERTIES, @ide_events( ), #__event_Change )
   Bind( ide_inspector_PROPERTIES, @ide_events( ), #__event_StatusChange )
   ;
   Bind( ide_inspector_EVENTS, @ide_events( ), #__event_Change )
   Bind( ide_inspector_EVENTS, @ide_events( ), #__event_StatusChange )
   ;
   Bind( ide_design_PANEL, @ide_events( ), #__event_Change )
   Bind( ide_design_PANEL, @ide_events( ), #__event_LeftClick )
   Bind( ide_design_PANEL, @ide_events( ), #__event_Left2Click )
   ;
   Bind( ide_design_CODE, @ide_events( ), #__event_Down )
   Bind( ide_design_CODE, @ide_events( ), #__event_Up )
   Bind( ide_design_CODE, @ide_events( ), #__event_RightClick )
   Bind( ide_design_CODE, @ide_events( ), #__event_Change )
   Bind( ide_design_CODE, @ide_events( ), #__event_StatusChange )
   ; TEMP
   Bind( ide_help_DEBUG, @ide_events( ), #__event_Down )
   Bind( ide_help_DEBUG, @ide_events( ), #__event_Up )
   Bind( ide_help_DEBUG, @ide_events( ), #__event_Change )
   Bind( ide_help_DEBUG, @ide_events( ), #__event_StatusChange )
   ;
   Bind( ide_design_ELEMENTS, @ide_events( ), #__event_Change )
   Bind( ide_design_ELEMENTS, @ide_events( ), #__event_StatusChange )
   Bind( ide_design_ELEMENTS, @ide_events( ), #__event_Left2Click )
   Bind( ide_design_ELEMENTS, @ide_events( ), #__event_LeftClick )
   Bind( ide_design_ELEMENTS, @ide_events( ), #__event_MouseEnter )
   Bind( ide_design_ELEMENTS, @ide_events( ), #__event_MouseLeave )
   Bind( ide_design_ELEMENTS, @ide_events( ), #__event_DragStart )
   ;
   Bind( ide_root, @ide_events( ), #__event_Close )
   ; Bind( ide_root, @ide_events( ), #__event_Free )
   Bind( ide_root, @ide_events( ), #__event_Focus )
   
   ;
   Bind( ide_design_MDI, @new_widget_events( ) )
   EnableDrop( ide_design_MDI, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateNew|#_DD_reParent|#_DD_CreateCopy|#_DD_Group )
   
   ;
   ;Bind( #PB_All, @ide_events( ) )
   ProcedureReturn ide_window
EndProcedure

;-
CompilerIf #PB_Compiler_IsMainFile 
   Define event
   ide_open( )
   
   ;
   ;    ;
   ;    ; ide_test_tree( )
   ;    ;
   ;    OpenWindow( 5, WindowX(ide_window)+WindowWidth(ide_window),WindowY(ide_window),170,WindowHeight(ide_window), "", #PB_Window_SizeGadget, WindowID(ide_window) )
   ;    StickyWindow( 5, 1)
   ;    ide_g_inspector_VIEW = TreeGadget( #PB_Any,1,1,WindowWidth(5),WindowHeight(5)) 
   ;    UseGadgetList(WindowID(ide_window))
   ;  
   
   
   AddFont( Str(GetFont( Root( ) )), "Courier", 9, 0 )
   
   
   
   ;   ;OpenList(ide_design_MDI)
   Define result, btn2, example = 3
   Define *form = new_widget_add( ide_design_MDI, "window", 10, 10, 350, 200 )
   
   If example = 1
      Resize(*form, 30, 30, 400, 250)
      
      new_widget_add(*form, "button", 35, 25, 30, 30)
      new_widget_add(*form, "text", 45, 65, 50, 30)
      new_widget_add(*form, "button", 55, 65+40, 80, 30)
      new_widget_add(*form, "text", 65, 65+40*2, 50, 30)
      
      
   ElseIf example = 2
      Define *cont1 = new_widget_add( *form, "container", 10, 10, 320, 180 )
      SetBackColor( *cont1, $FF9CF9F6)
      new_widget_add( *cont1, "button", 10, 20, 100, 30 )
      Define *cont2 = new_widget_add( *cont1, "container", 130, 20, 90, 140 )
      new_widget_add( *cont2, "button", 10, 20, 30, 30 )
      Define *cont3 = new_widget_add( *cont1, "container", 230, 20, 90, 140 )
      new_widget_add( *cont2, "button", 10, 20, 30, 30 )
      
      ;       ClearItems(ide_inspector_VIEW)
      ; ;       AddItem(ide_inspector_VIEW, -1, "window_0", -1, 0)
      ; ;       AddItem(ide_inspector_VIEW, -1, "button_0", -1, 1)
      ; ;       AddItem(ide_inspector_VIEW, -1, "container_0", -1, 1)
      ; ;       AddItem(ide_inspector_VIEW, -1, "button_1", -1, 2)
      ; ;       
      ;       Define *parent._s_WIDGET = ide_design_MDI
      ;       ;PushListPosition(widgets())
      ;       If StartEnum( *parent ,0)
      ;          Debug "99 "+ GetClass(widget()) +" "+ GetClass(widget()\parent) +" "+ Str(Level(widget()))+" "+Str(Level(*parent));IsChild(widget(), *parent )
      ;          Select CountItems(ide_inspector_VIEW)
      ;             Case 0 
      ;                AddItem(ide_inspector_VIEW, -1, "window_0", -1, Level(widget())-Level(*parent)-1)
      ;             Case 1 
      ;                AddItem(ide_inspector_VIEW, -1, "button_0", -1, Level(widget())-Level(*parent)-1)
      ;             Case 2 
      ;                AddItem(ide_inspector_VIEW, -1, "container_0", -1, Level(widget())-Level(*parent)-1)
      ;             Case 3 
      ;                AddItem(ide_inspector_VIEW, -1, "button_1", -1, Level(widget())-Level(*parent)-1)
      ;          EndSelect
      ;          
      ;          ;   Debug CountItems(ide_inspector_VIEW)-1
      ;          SetData(widget(), CountItems(ide_inspector_VIEW)-1)
      ;          SetItemData(ide_inspector_VIEW, CountItems(ide_inspector_VIEW)-1, widget())
      ;          
      ;          StopEnum()
      ;       EndIf
      ;       ;PopListPosition(widgets())
      
      ;\\ example 2
      ;       Define *container = new_widget_add( *form, "container", 130, 20, 220, 140 )
      ;       new_widget_add( *container, "button", 10, 20, 30, 30 )
      ;       new_widget_add( *form, "button", 10, 20, 100, 30 )
      ;       
      ;       Define item = 1
      ;       SetState( ide_inspector_VIEW, item )
      ;       If IsGadget( ide_g_inspector_VIEW )
      ;          SetGadgetState( ide_g_inspector_VIEW, item )
      ;       EndIf
      ;       Define *container2 = new_widget_add( *container, "container", 60, 10, 220, 140 )
      ;       new_widget_add( *container2, "button", 10, 20, 30, 30 )
      ;       
      ;       SetState( ide_inspector_VIEW, 0 )
      ;       new_widget_add( *form, "button", 10, 130, 100, 30 )
      
   ElseIf example = 3
      ;\\ example 3
      Resize(*form, #PB_Ignore, #PB_Ignore, 500, 250)
      
      Disable(new_widget_add(*form, "button", 15, 25, 50, 30, #PB_Button_MultiLine),1)
      new_widget_add(*form, "text", 25, 65, 50, 30)
      btn2 = new_widget_add(*form, "image", 35, 65+40, 50, 30)
      new_widget_add(*form, "string", 45, 65+40*2, 50, 30)
      ;new_widget_add(*form, "button", 45, 65+40*2, 50, 30)
      
      Define *scrollarea = new_widget_add(*form, "scrollarea", 120, 25, 165, 175, #PB_ScrollArea_Flat )
      new_widget_add(*scrollarea, "button", 15, 25, 30, 30)
      new_widget_add(*scrollarea, "text", 25, 65, 50, 30)
      new_widget_add(*scrollarea, "button", 35, 65+40, 80, 30)
      new_widget_add(*scrollarea, "text", 45, 65+40*2, 50, 30)
      
      Define *panel = new_widget_add(*form, "panel", 320, 25, 165, 175)
      new_widget_add(*panel, "button", 15, 25, 30, 30)
      new_widget_add(*panel, "text", 25, 65, 50, 30)
      new_widget_add(*panel, "button", 35, 65+40, 80, 30)
      new_widget_add(*panel, "text", 45, 65+40*2, 50, 30)
      
      AddItem( *panel, -1, "panel_item_1" )
      ;OpenList( *panel, 1 )
      new_widget_add(*panel, "button", 115, 25, 30, 30)
      new_widget_add(*panel, "text", 125, 65, 50, 30)
      new_widget_add(*panel, "button", 135, 65+40, 80, 30)
      new_widget_add(*panel, "text", 145, 65+40*2, 50, 30)
      ;CloseList( )
      SetState( *panel, 1 )
      
      
      Define *form2 = new_widget_add( ide_design_MDI, "window", 10, 10, 350, 200 )
      Resize(*form2, #PB_Ignore, Y(*form)+Height(*form), 500, 100)
      
      new_widget_add(*form2, "button", 25, 10, 30, 30)
      new_widget_add(*form2, "button", 70, 40, 30, 30)
      new_widget_add(*form2, "button", 110, 75, 30, 30)
      
      ;       ;       ;SetMoveBounds( *scrollarea, -1,-1,-1,-1 )
      ;       ;       ;SetSizeBounds( *scrollarea, -1,-1,-1,-1 )
      ;       ;       ;SetSizeBounds( *scrollarea )
      ;       ;       SetMoveBounds( btn2, -1,-1,-1,-1 )
      ;       SetMoveBounds( *form, -1,-1,-1,-1 )
      ;       ;       ;SetChildrenBounds( ide_design_MDI )
      
   EndIf
   
   
   ;    Define._S_WIDGET *this, *parent
   ;    Debug "--- enumerate all gadgets ---"
   ;    If StartEnum( root( ) )
   ;       Debug "     gadget - "+ widget( )\index +" "+ GetClass(widget( )) +"               ("+ GetClass(widget( )\parent) +") " ;+" - ("+ widget( )\text\string +")"
   ;       StopEnum( )
   ;    EndIf
   ;    
   ;    Debug ""
   ;    *parent = *container
   ;    *this = GetPositionLast( *parent )
   ;    Debug ""+GetClass(*this) +"           ("+ GetClass(*parent) +")" ;  +" - ("+ *this\text\string +")"
   ;    
   ;    
   ;    If StartEnum( *parent )
   ;       Debug "   *parent  gadget - "+ widget( )\index +" "+ GetClass(widget( )) +"               ("+ GetClass(widget( )\parent) +") " ;+" - ("+ widget( )\text\string +")"
   ;       StopEnum( )
   ;    EndIf
   ;    
   
   
   ; SetActive( *form )
   
   ;ReDraw(root())
   Define time = ElapsedMilliseconds( )
   Define code$ = Generate_Code( ide_design_MDI )
   code$ = Mid( code$, FindString( code$, "Procedure Open_" ))
   code$ = Mid( code$, 1, FindString( code$, "EndProcedure" ))+"ndProcedure"
   SetText( ide_help_DEBUG, code$ )
   ;Debug ""+Str(ElapsedMilliseconds( )-time) +" generate code time"
   
   ;ReDraw(root())
   HideWindow( ide_window, #False )
   
   If SetActive( ide_inspector_VIEW )
      SetActiveGadget( ide_g_canvas )
   EndIf
   
   ;\\ 
   WaitClose( )
CompilerEndIf


;\\ include images
DataSection   
   IncludePath #ide_path + "ide/include/images"
   
   image_new_widget_delete:    : IncludeBinary "16/delete.png"
   image_new_widget_paste:     : IncludeBinary "16/paste.png"
   image_new_widget_copy:      : IncludeBinary "16/copy.png"
   image_new_widget_cut:       : IncludeBinary "16/cut.png"
   *imagelogo:       : IncludeBinary "group/group_bottom.png"
   
   image_group:            : IncludeBinary "group/group.png"
   image_group_un:         : IncludeBinary "group/group_un.png"
   image_group_top:        : IncludeBinary "group/group_top.png"
   image_group_left:       : IncludeBinary "group/group_left.png"
   image_group_right:      : IncludeBinary "group/group_right.png"
   image_group_bottom:     : IncludeBinary "group/group_bottom.png"
   image_group_width:      : IncludeBinary "group/group_width.png"
   image_group_height:     : IncludeBinary "group/group_height.png"
EndDataSection
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 503
; FirstLine = 479
; Folding = ---------------------------------------------------------
; EnableXP
; DPIAware