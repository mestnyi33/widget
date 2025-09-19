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
Enumeration 
   #_pi_group_COMMON 
   #_pi_ID 
   #_pi_class
   #_pi_text
   #_pi_IMAGE
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
   #_pi_FLAG
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
Enumeration 
   #_ei_leftclick
   #_ei_change
   #_ei_enter
   #_ei_leave
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
   
   #_tb_new_widget_paste
   #_tb_new_widget_delete
   #_tb_new_widget_copy
   #_tb_new_widget_cut
   
   #_tb_file_run
   #_tb_file_new
   #_tb_file_open
   #_tb_file_save
   #_tb_file_SAVEAS
   #_tb_file_quit
   
   #_tb_LNG
   #_tb_lng_ENG
   #_tb_lng_RUS
   #_tb_lng_FRENCH
   #_tb_lng_GERMAN
EndEnumeration

;- GLOBALs
Global ide_window, 
       ide_g_code,
       ide_g_canvas

Global ide_root,
       ide_splitter,
       ide_toolbar_container, 
       ide_toolbar, 
       ide_popup_lenguage,
       ide_menu

Global ide_design_splitter, 
       ide_design_PANEL_splitter,
       ide_design_PANEL, 
       ide_design_panel_MDI,
       ide_design_panel_CODE, 
       ide_design_PANEL_HIASM, 
       ide_design_DEBUG 
Global ide_design_FORM 

Global ide_inspector_view_splitter, 
       ide_inspector_view, 
       ide_inspector_panel_splitter,
       ide_inspector_PANEL,
       ide_inspector_elements,
       ide_inspector_properties, 
       ide_inspector_events,
       ide_inspector_HELP

Global group_select
Global group_drag

Global ColorState
Global ColorType 
                        
Global enum_object = 0
Global enum_image = 0
Global enum_font = 0
Global pb_object$ = "";"Gadget"


Global font_properties = LoadFont( #PB_Any, "", 12 )


; test_docursor = 1
; test_changecursor = 1
; test_setcursor = 1
; test_delete = 1
; test_focus_show = 1
; test_focus_set = 1
; test_changecursor = 1

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
Declare   new_widget_create( *parent, type$, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, text$="", Param1=0, Param2=0, Param3=0, flag.q = 0 )
Declare   new_widget_add( *parent, type$, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, flag = 0 )
Declare   new_widget_line_add( *new )
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
XIncludeFile #ide_path + "include\lng.pbi"
; XIncludeFile "C:\Users\user\Downloads\Compressed\widget-edb230c0138ebd33deacbac9440577a00b5affa7\widget-edb230c0138ebd33deacbac9440577a00b5affa7\widgets.pbi"
; Procedure.i GetFontColor( *this.structures::_s_WIDGET )
;    ProcedureReturn widget::GetColor( *this, constants::#__Color_Front )
; EndProcedure
; Procedure   SetFontColor( *this.structures::_s_WIDGET, color.i )
;    ProcedureReturn widget::SetColor( *this, constants::#__Color_Front, color )
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
;-
Procedure Properties_ButtonGetItem( *inspector._s_WIDGET, item )
   Protected *second._s_WIDGET = GetAttribute(*inspector, #PB_Splitter_SecondGadget)
   ;
   If *second 
      ProcedureReturn GetItemData( *second, item )
   EndIf
EndProcedure

Procedure Properties_ButtonAddItems( *inspector._s_WIDGET, item, Text.s )
   Protected *second._s_WIDGET = GetAttribute(*inspector, #PB_Splitter_SecondGadget)
   ;
   If *second 
      Protected *this._s_WIDGET = GetItemData( *second, item )
      
      If *this
         Select Type( *this )
            Case #__type_ComboBox 
               Static lasttext.s
               
               If lasttext <> Text
                  lasttext = Text
                  ; Debug "Properties_ButtonAddItems " +Text
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
   EndIf
EndProcedure

Procedure   Properties_ButtonHide( *second._s_WIDGET, state )
   Protected *this._s_WIDGET
   Protected *row._s_ROWS
   
   *row = *second\RowFocused( )
   If *row
      *this = *row\data
      ;
      If *this
         Hide( *this, state )
      EndIf
   EndIf
EndProcedure

Procedure   Properties_ButtonChange( *inspector._s_WIDGET )
   Protected *second._s_WIDGET = GetAttribute(*inspector, #PB_Splitter_SecondGadget)
   ;
   If *second And *second\RowFocused( )
      Protected *this._s_WIDGET = *second\RowFocused( )\data
      
      If *this
         Select Type( *this )
            Case #__type_Spin     : SetState(*this, Val(*second\RowFocused( )\text\string) )
            Case #__type_String   : SetText(*this, *second\RowFocused( )\text\string )
            Case #__type_ComboBox : SetState(*this, StrToBool(*second\RowFocused( )\text\string) )
         EndSelect
      EndIf
   EndIf
EndProcedure

Procedure   Properties_ButtonResize( *second._s_WIDGET )
   Protected *this._s_WIDGET
   Protected *row._s_ROWS
   
   *row = *second\RowFocused( )
   If *row
      *this = *row\data
      ;
      If *this
         If *row\hide
            If Not Hide( *this )
               Hide( *this, #True )
            EndIf
         Else
            If Hide( *this )
               Hide( *this, #False )
            EndIf
            ;
            ;Debug *this\WIdgetChange(  ) = 1
            Select *row\index
               Case #_pi_FONT, #_pi_COLOR, #_pi_IMAGE
                  Resize(*this,
                         *row\x + (*second\inner_width( )-*this\width), ; + *second\scroll_x( )
                         *row\y, ; + *second\scroll_y( ), 
                         #PB_Ignore, 
                         *row\height, 0 )
               Default
                  Resize(*this,
                         *row\x,
                         *row\y,
                         *second\inner_width( ), ; *row\width,
                         *row\height, 0 )
            EndSelect 
            ;             ;*this\WIdgetChange( ) = 1
            ;             *this\TextChange( ) = 1
         EndIf
      EndIf
   EndIf
EndProcedure

Procedure   Properties_ButtonDisplay( *second._s_WIDGET )
   Protected *this._s_WIDGET
   Protected *row._s_ROWS
   Static *last._s_WIDGET
   
   *row = *second\RowFocused( )
   If *row
      *this = *row\data
      
      If *last 
         If *last = *this
            Hide( *this, #False )
         Else
            Hide( *last, #True )
         EndIf
      EndIf
      
      ;  
      If *this 
         If *last <> *this
            *last = *this
            
            ;
            Select Type( *this )
               Case #__type_String
                  If GetData( *this ) = #_pi_class
                     *this\text\upper = 1
                  Else
                     *this\text\upper = 0
                  EndIf
                  SetText( *this, *row\text\string )
                  
               Case #__type_Spin
                  SetState( *this, Val(*row\text\string) )
                  
               Case #__type_ComboBox
                  Select LCase(*row\text\string)
                     Case "false" : SetState( *this, 0)
                     Case "true"  : SetState( *this, 1)
                  EndSelect
                  
            EndSelect
            
            ;
            Properties_ButtonResize( *second )
            ;SetActive( *this )
         EndIf
      EndIf
   EndIf
   
   ProcedureReturn *last
EndProcedure

Procedure   Properties_ButtonEvents( )
   Protected *g._s_WIDGET = EventWidget( )
   Protected __event = WidgetEvent( )
   Protected __item = WidgetEventItem( )
   Protected __data = WidgetEventData( )
   ; Debug ""+widget::ClassFromEvent(__event) +" "+ widget::GetClass( *g)
   
   Select __event
      Case #__event_Down
         GetActive( )\gadget = *g
         
      Case #__event_LeftClick
         Select GetData(*g)
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
         Select Type(*g)
            Case #__type_String
               Select GetData(*g) 
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
               Select GetData(*g) 
                  Case #_pi_x      : Resize( a_focused( ), GetState(*g), #PB_Ignore, #PB_Ignore, #PB_Ignore ) 
                  Case #_pi_y      : Resize( a_focused( ), #PB_Ignore, GetState(*g), #PB_Ignore, #PB_Ignore )
                  Case #_pi_width  : Resize( a_focused( ), #PB_Ignore, #PB_Ignore, GetState(*g), #PB_Ignore )
                  Case #_pi_height : Resize( a_focused( ), #PB_Ignore, #PB_Ignore, #PB_Ignore, GetState(*g) )
                     
                  Case #_pi_fontsize
                     If ChangeFontSize( a_focused( ), GetState( *g))
                        Properties_Updates( a_focused( ), "Font" )
                     EndIf
                     
                  Case #_pi_coloralpha
                     If SetBackColor( a_focused( ), RGBA( (Val(Properties_GetItemText(ide_inspector_properties, #_pi_colorred))),
                                                             (Val(Properties_GetItemText(ide_inspector_properties, #_pi_colorgreen))),
                                                             (Val(Properties_GetItemText(ide_inspector_properties, #_pi_colorblue))),
                                                             (GetState(*g)) ))
                     Properties_Updates( a_focused( ), "Color" )
                  EndIf
                  
                  Case #_pi_colorblue
                     If SetBackColor( a_focused( ), RGBA( (Val(Properties_GetItemText(ide_inspector_properties, #_pi_colorred))),
                                                             (Val(Properties_GetItemText(ide_inspector_properties, #_pi_colorgreen))),
                                                             (GetState(*g)),
                                                             (Val(Properties_GetItemText(ide_inspector_properties, #_pi_coloralpha))) ))
                        Properties_Updates( a_focused( ), "Color" )
                     EndIf
                     
                  Case #_pi_colorgreen
                     If SetBackColor( a_focused( ), RGBA( (Val(Properties_GetItemText(ide_inspector_properties, #_pi_colorred))),
                                                             (GetState(*g)),
                                                             (Val(Properties_GetItemText(ide_inspector_properties, #_pi_colorblue))),
                                                             (Val(Properties_GetItemText(ide_inspector_properties, #_pi_coloralpha))) ))
                        Properties_Updates( a_focused( ), "Color" )
                     EndIf
                     
                  Case #_pi_colorred
                     If SetBackColor( a_focused( ), RGBA( (GetState(*g)),
                                                             (Val(Properties_GetItemText(ide_inspector_properties, #_pi_colorgreen))),
                                                             (Val(Properties_GetItemText(ide_inspector_properties, #_pi_colorblue))),
                                                             (Val(Properties_GetItemText(ide_inspector_properties, #_pi_coloralpha))) ))
                        Properties_Updates( a_focused( ), "Color" )
                     EndIf
                     
               EndSelect
               
            Case #__type_ComboBox
               Select GetData(*g) 
                  Case #_pi_cursor
                     Properties_SetItemText( ide_inspector_properties, GetData(*g), GetItemText( *g, GetState( *g)))
               
                  Case #_pi_colorstate
                     ColorState = GetState(*g)
                     Properties_SetItemText( ide_inspector_properties, GetData(*g), GetItemText( *g, GetState( *g)))
                     Properties_Updates( a_focused( ), "Color" ) 
                     
                  Case #_pi_colortype
                     ColorType = MakeConstants("#PB_Gadget_" + GetItemText( *g, GetState( *g)))
                     Properties_SetItemText( ide_inspector_properties, GetData(*g), GetItemText( *g, GetState( *g)))
                     Properties_Updates( a_focused( ), "Color" ) 
                     
                  Case #_pi_FLAG
                     Flag( a_focused( ), MakeConstants( GetItemText( *g, GetState( *g))), #True )
                     Properties_Updates( a_focused( ), "Flag" ) 
                     
                  Case #_pi_fontstyle
                     If ChangeFontStyle( a_focused( ), MakeConstants( "#PB_Font_"+GetItemText( *g, GetState(*g))))
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
         If __item > 0
            SetState(*g\scroll\v, GetState( *g\scroll\v ) - __data )
         EndIf
         
      Case #__event_Cursor
         ProcedureReturn 0
         
   EndSelect
   
   ProcedureReturn #PB_Ignore
EndProcedure

Procedure   Properties_ButtonCreate( Type, *parent._s_WIDGET, item )
   Protected *this._s_WIDGET
   Protected min, max, steps, flag ;= #__flag_NoFocus ;| #__flag_Transparent ;| #__flag_child|#__flag_invert
   
   Select Type
      Case #__type_Spin
         flag = #__spin_Plus
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
         
         *this = Create( *parent, "Spin", Type, 0, 0, 0, 0, "", flag, min, max, 0, #__bar_button_size, 0, steps )
         
      Case #__type_String
         *this = Create( *parent, "String", Type, 0, 0, 0, 0, "", flag, 0, 0, 0, 0, 0, 0 )
         
      Case #__type_CheckBox
         *this = Create( *parent, "CheckBox", Type, 0, 0, 0, 0, "#PB_Any", flag, 0, 0, 0, 0, 0, 0 )
         
      Case #__type_Button
         Select item
            Case #_pi_align
               *this = AnchorBox::Create( *parent, 0,0,0,20 )
               
            Case #_pi_FONT, #_pi_COLOR, #_pi_IMAGE
               *this = Create( *parent, "Button", Type, 0, 0, #__bar_button_size+1, 0, "...", flag, 0, 0, 0, 0, 0, 0 )
               
         EndSelect
         
      Case #__type_ComboBox
         *this = Create( *parent, "ComboBox", Type, 0, 0, 0, 0, "", flag|#PB_ComboBox_Editable, 0, 0, 0, #__bar_button_size, 0, 0 )
         ;
         Select item
            Case #_pi_flag
               
            Case #_pi_fontstyle
               AddItem(*this, -1, "None")         
               If *this\popupbar
                  *this\popupbar\mode\Checkboxes = 1
                  *this\popupbar\mode\optionboxes = 1
               ;    Flag( *this\popupbar, #__flag_CheckBoxes|#__flag_OptionBoxes, 1 )
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
;                Properties_SetItemText( ide_inspector_properties, item, GetItemText( *this, 0) )
      
            Case #_pi_colortype
               AddItem(*this, -1, "BackColor")
               AddItem(*this, -1, "FrontColor")
               AddItem(*this, -1, "LineColor")
               AddItem(*this, -1, "FrameColor")
               AddItem(*this, -1, "ForeColor")
;                ColorType = MakeConstants("#PB_Gadget_" + GetItemText( *this, 0))
;                Properties_SetItemText( ide_inspector_properties, item, GetItemText( *this, 0) )
                     
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
;                Properties_SetItemText( ide_inspector_properties, item, GetItemText( *this, 0) )
               
            Default
               AddItem(*this, -1, "False")
               AddItem(*this, -1, "True")
               
         EndSelect
         ;
         SetState(*this, 0)
         
   EndSelect
   
   If *this
      ; SetActive( *this )
      SetData(*this, item)
      Bind(*this, @Properties_ButtonEvents( ))
   EndIf
   
   ProcedureReturn *this
EndProcedure

;-
Procedure   Properties_StatusChange( *this._s_WIDGET, item )
   Protected *g._s_WIDGET = EventWidget( )
   
   If GetState( *this ) = item
      ProcedureReturn 0
   EndIf 
   
   ;    If GetState(*g) = item
   ;       ProcedureReturn 0
   ;    EndIf 
   
   PushListPosition(*g\__rows( ))
   SelectElement( *g\__rows( ), item )
   ;
   If *g\__rows( ) 
      PushListPosition( *this\__rows( ) )
      SelectElement( *this\__rows( ), *g\__rows( )\index)
      ;*this\__rows( )\color = *g\__rows( )\color
      *this\__rows( )\colorState( ) = *g\__rows( )\colorState( )
      
      If *this\__rows( )\colorState( ) = #__s_2
         If *this\RowFocused( )
            *this\RowFocused( )\focus = 0
         EndIf
         *this\RowFocused( ) = *this\__rows( )
         *this\RowFocused( )\focus = 1
      EndIf
      
      PopListPosition( *this\__rows( ) )
   EndIf
   PopListPosition(*g\__rows( ))
   
   ;    If __data = 3
   ;       If GetActive( ) <> *g
   ;          Debug "set active "+GetClass(*g)
   ;          SetActive( *g)
   ;       EndIf
   ;    EndIf
   
EndProcedure

Procedure.s Properties_GetItemText( *splitter._s_WIDGET, item )
   ProcedureReturn GetItemText( GetAttribute(*splitter, #PB_Splitter_SecondGadget), item )
EndProcedure

Procedure   Properties_SetItemText( *splitter._s_WIDGET, item, Text.s )
   ProcedureReturn SetItemText( GetAttribute(*splitter, #PB_Splitter_SecondGadget), item, Text.s )
EndProcedure

Procedure   Properties_HideItem( *splitter._s_WIDGET, item, state )
   HideItem( GetAttribute(*splitter, #PB_Splitter_FirstGadget), item, state )
   HideItem( GetAttribute(*splitter, #PB_Splitter_SecondGadget), item, state )
EndProcedure

Procedure   Properties_AddItem( *splitter._s_WIDGET, item, Text.s, Type=-1, mode=0 )
   Protected *this._s_WIDGET
   Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
   
   If mode
      AddItem( *first, item, StringField(Text.s, 1, Chr(10)), -1, mode )
   Else
      AddItem( *first, item, UCase(StringField(Text.s, 1, Chr(10))), -1 )
   EndIf
   AddItem( *second, item, StringField(Text.s, 2, Chr(10)), -1, mode )
   
   item = CountItems( *first ) - 1
   If mode = 0
      Define color_properties.q = $FFBF9CC3;$BE80817D
      Define fcolor_properties.q = $CA2E2E2E
      
      ;       ;       If Type > 0
      ;       ;          SetItemColor( *first, item, #PB_Gadget_BackColor, $FFFEFEFE)
      ;       ;          SetItemColor( *second, item, #PB_Gadget_BackColor, $FFFEFEFE )
      ;       ;       Else
      ;       ;          ;SetItemFont( *first, item, font_properties)
      ;       ;          ;SetItemFont( *second, item, font_properties)
      ;       
      ;       SetItemColor( *first, item, #PB_Gadget_BackColor, color_properties, 0, #PB_All )
      ;       SetItemColor( *second, item, #PB_Gadget_BackColor, color_properties, 0, #PB_All )
      ;       ; SetItemColor( *first, item, #PB_Gadget_BackColor, -1, 0, #PB_All )
      ;       ;       SetItemColor( *second, item, #PB_Gadget_BackColor, -1, 0, #PB_All )
      ;       
      ;       SetItemColor( *first, item, #PB_Gadget_FrontColor, fcolor_properties, 0, #PB_All )
      ;       SetItemColor( *second, item, #PB_Gadget_FrontColor, fcolor_properties, 0, #PB_All )
      ;       ;       EndIf
   Else
      SetItemColor( *first, item, #PB_Gadget_BackColor, $FFFEFEFE)
      SetItemColor( *second, item, #PB_Gadget_BackColor, $FFFEFEFE )
   EndIf
   *this = Properties_ButtonCreate( Type, *second, item )
   
   ; SetItemData(*first, item, *this)
   SetItemData(*second, item, *this)
EndProcedure

Procedure   Properties_Events( )
   Protected *g._s_WIDGET = EventWidget( )
   Protected __event = WidgetEvent( )
   Protected __item = WidgetEventItem( )
   Protected __data = WidgetEventData( )
   
   Protected *first._s_WIDGET = GetAttribute( *g\parent, #PB_Splitter_FirstGadget)
   Protected *second._s_WIDGET = GetAttribute( *g\parent, #PB_Splitter_SecondGadget)
   ;  
   Select __event
      Case #__event_Draw
         UnclipOutput( )
         DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend )
         ;          Define Image = GrabDrawingImage( #PB_Any, *g\parent\bar\button\x-*g\parent\bar\button\width,*g\parent\bar\button\y, *g\parent\bar\button\width, *g\scroll_height( ) + *g\mode\GridLines )
         ;          DrawImage( ImageID(Image), *g\parent\bar\button\x, *g\parent\bar\button\y )
         Box( *g\parent\bar\button\x+(*g\parent\bar\button\width-*g\mode\GridLines)/2, *g\parent\bar\button\y, *g\mode\GridLines, *g\scroll_height( ) + *g\mode\GridLines, $FFBF9CC3 )
         
      Case #__event_Down
         If is_parent_item( *g, __item )
            ; Properties_ButtonHide( *second, #True)
         EndIf
         If Not EnteredButton( )
            SetState( *g, __item)
         EndIf
         
      Case #__event_Change
         Select *g
            Case *first : SetState(*second, GetState(*g))
            Case *second : SetState(*first, GetState(*g))
         EndSelect
         
         ; create PropertiesButton
         Properties_ButtonDisplay( *second )
         
      Case #__event_StatusChange
         If *g = *first
            If __data = #PB_Tree_Expanded Or
               __data = #PB_Tree_Collapsed
               ;
               SetItemState( *second, __item, __data)
            EndIf
         EndIf
         
         Select*g
            Case *first : Properties_StatusChange( *second, __item )
            Case *second : Properties_StatusChange( *first, __item )
         EndSelect
         
      Case #__event_ScrollChange
         If *g = *first 
            If GetState( *second\scroll\v ) <> __data
               SetState(*second\scroll\v, __data )
            EndIf
         EndIf   
         
         If *g = *second
            If GetState( *first\scroll\v ) <> __data
               SetState(*first\scroll\v, __data )
            EndIf
            
            Properties_ButtonResize( *second )
         EndIf
         
      Case #__event_resize
         If *g = *second
            Properties_ButtonResize( *second )
         EndIf
         
      Case #__event_Cursor
         ProcedureReturn 0
         
   EndSelect
   
   ProcedureReturn #PB_Ignore
EndProcedure

Procedure   Properties_Create( X,Y,Width,Height, flag=0 )
   Protected position = 90
   Protected *first._s_WIDGET = Tree(0,0,0,0, #PB_Tree_NoLines|#__flag_gridlines|#__flag_Transparent|#__flag_border_Less)
   Protected *second._s_WIDGET = Tree(0,0,0,0, #PB_Tree_NoButtons|#PB_Tree_NoLines|#__flag_gridlines|#__flag_Transparent|#__flag_border_Less)
   ;    *first\padding\x = 10
   ;    *second\padding\x = 10
   
   Protected *splitter._s_WIDGET = Splitter(X,Y,Width,Height, *first,*second, flag|#PB_Splitter_Vertical );|#PB_Splitter_FirstFixed )
   SetAttribute(*splitter, #PB_Splitter_FirstMinimumSize, position )
   SetAttribute(*splitter, #PB_Splitter_SecondMinimumSize, position )
   ;
   *splitter\bar\button\size = DPIScaled(1)
   *splitter\bar\button\size + Bool( *splitter\bar\button\size % 2 )
   *Splitter\bar\button\round = 0;  DPIScaled(1)
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
   
   ;CloseList( )
   
   SetColor( *splitter, #PB_Gadget_BackColor, -1, #PB_All )
   SetColor( *first, #PB_Gadget_LineColor, $FFBF9CC3)
   SetColor( *second, #PB_Gadget_LineColor, $FFBF9CC3)
   
   ;
   Bind(*first, @Properties_Events( ))
   Bind(*second, @Properties_Events( ))
   
   ; draw и resize отдельно надо включать пока поэтому вот так
   Bind(*second, @Properties_Events( ), #__event_Resize)
   Bind(*second, @Properties_Events( ), #__event_Draw)
   ProcedureReturn *splitter
EndProcedure

Procedure   Properties_Updates( *object._s_WIDGET, type$ )
   Protected find$, replace$, name$, class$, x$, y$, width$, height$
   ; class$ = Properties_GetItemText( ide_inspector_properties, #_pi_class )
   
   If ide_inspector_properties
      If type$ = "Focus" Or type$ = "Align"
         Properties_HideItem( ide_inspector_properties, #_pi_align, Bool( a_focused( )\parent = ide_design_panel_MDI )) 
      EndIf
      If type$ = "Focus" Or type$ = "ID"
         Properties_SetItemText( ide_inspector_properties, #_pi_id, BoolToStr( Bool( GetClass( *object ) <> Trim( GetClass( *object ), "#" ) )))
      EndIf
      If type$ = "Focus" Or type$ = "Hide"
         Properties_SetItemText( ide_inspector_properties, #_pi_hide, BoolToStr( Hide( *object )))
      EndIf
      If type$ = "Focus" Or type$ = "Disable"
         Properties_SetItemText( ide_inspector_properties, #_pi_disable, BoolToStr( Disable( *object )))
      EndIf
      
      If type$ = "Focus" Or type$ = "Class"
         find$ = Properties_GetItemText( ide_inspector_properties, #_pi_class )
         replace$ = GetClass( *object )
         Properties_SetItemText( ide_inspector_properties, #_pi_class, replace$ )
      EndIf
      If type$ = "Focus" Or type$ = "Text"
         find$ = Properties_GetItemText( ide_inspector_properties, #_pi_text )
         replace$ = GetText( *object )
         Properties_SetItemText( ide_inspector_properties, #_pi_text, replace$ )
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
         
         find$ = Properties_GetItemText( ide_inspector_properties, #_pi_x ) +", "+ 
                 Properties_GetItemText( ide_inspector_properties, #_pi_y ) +", "+ 
                 Properties_GetItemText( ide_inspector_properties, #_pi_width ) +", "+ 
                 Properties_GetItemText( ide_inspector_properties, #_pi_height )
         replace$ = x$ +", "+ y$ +", "+ width$ +", "+ height$
         
         Properties_SetItemText( ide_inspector_properties, #_pi_x,      x$ )
         Properties_SetItemText( ide_inspector_properties, #_pi_y,      y$ )
         Properties_SetItemText( ide_inspector_properties, #_pi_width,  width$ )
         Properties_SetItemText( ide_inspector_properties, #_pi_height, height$ )
         
         ;
         Properties_ButtonChange( ide_inspector_properties )
      EndIf
      
      If type$ = "Focus" Or type$ = "Flag"
         Properties_SetItemText( ide_inspector_properties, #_pi_FLAG, MakeConstantsString( ClassFromType(*object\type), *object\flag ))
      EndIf
      If type$ = "Focus" Or type$ = "Color" 
         Define color.l = GetColor( *object, ColorType, ColorState ) ;& $FFFFFF | *object\color\_alpha << 24
         Properties_SetItemText( ide_inspector_properties, #_pi_COLOR, "$"+Hex(Color, #PB_Long))
         Properties_SetItemText( ide_inspector_properties, #_pi_coloralpha, Str(Alpha(color)) )
         Properties_SetItemText( ide_inspector_properties, #_pi_colorblue, Str(Blue(color)) )
         Properties_SetItemText( ide_inspector_properties, #_pi_colorgreen, Str(Green(color)) )
         Properties_SetItemText( ide_inspector_properties, #_pi_colorred, Str(Red(color)) )
      EndIf
      If type$ = "Focus" Or type$ = "Image"
         Properties_SetItemText( ide_inspector_properties, #_pi_IMAGE, GetImageFile( GetImage( *object )))
      EndIf
      If type$ = "Focus" Or type$ = "Font"
         Define font = GetFont( *object )
         ; Debug ""+font +" "+ GetClass(*object)
         Properties_SetItemText( ide_inspector_properties, #_pi_FONT, GetFontName( font ) )
         ; Properties_SetItemText( ide_inspector_properties, #_pi_fontcolor, Str( GetFontColor( font ) ))
         If GetFontName( font )
            Properties_SetItemText( ide_inspector_properties, #_pi_fontsize, Str( GetFontSize( font ) ))
         Else
            Properties_SetItemText( ide_inspector_properties, #_pi_fontsize, "" )
         EndIf
         Define style$ = RemoveString( MakeConstantsString( "Font", GetFontStyle( font ) ), "#PB_Font_")
         If style$ = ""
            style$ = "None"
         EndIf
         Properties_SetItemText( ide_inspector_properties, #_pi_fontstyle, style$)
      EndIf 
      
      ;\\
      If type$ = "Focus"
         If a_focused( )
            Properties_ButtonAddItems( ide_inspector_properties, #_pi_flag, MakeFlagsString( Type( a_focused( ))))
         EndIf
         
      Else
         Protected NbOccurrences
         Protected *this._s_WIDGET = GetActive( )
         
         If find$
            If type$ = "Class"
               If *this = ide_design_panel_CODE Or 
                  *this = ide_design_DEBUG
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
            If *this <> ide_design_DEBUG
               ReplaceText( ide_design_DEBUG, find$, replace$, NbOccurrences )
            EndIf
            If *this <> ide_design_panel_CODE
               If Not Hide( ide_design_panel_CODE )
                  ReplaceText( ide_design_panel_CODE, find$, replace$, NbOccurrences )
               EndIf 
            EndIf
         EndIf
      EndIf
   EndIf
   
EndProcedure


;-
;-
Macro new_widget_copy( )
   ClearList( *copy( ) )
   
   If a_focused( )\anchors
      AddElement( *copy( ) ) 
      *copy.allocate( A_GROUP, ( ) )
      *copy( )\widget = a_focused( )
   Else
      ;       ForEach a_group( )
      ;         AddElement( *copy( ) ) 
      ;         *copy.allocate( GROUP, ( ) )
      ;         *copy( )\widget = a_group( )\widget
      ;       Next
      
      CopyList( a_group( ), *copy( ) )
      
   EndIf
   
   mouse( )\selector\x = mouse( )\steps
   mouse( )\selector\y = mouse( )\steps
EndMacro

Macro new_widget_paste( )
   If ListSize( *copy( ) )
      ForEach *copy( )
         new_widget_add( *copy( )\widget\parent, 
                     *copy( )\widget\class, 
                     *copy( )\widget\x[#__c_container] + ( mouse( )\selector\x ),; -*copy( )\widget\parent\x[#__c_inner] ),
                     *copy( )\widget\y[#__c_container] + ( mouse( )\selector\y ),; -*copy( )\widget\parent\y[#__c_inner] ), 
                     *copy( )\widget\width[#__c_frame],
                     *copy( )\widget\height[#__c_frame] )
      Next
      
      mouse( )\selector\x + mouse( )\steps
      mouse( )\selector\y + mouse( )\steps
      
      ClearList( a_group( ) )
      CopyList( *copy( ), a_group( ) )
   EndIf
   
   ;
   ForEach a_group( )
      Debug " group "+a_group( )\widget
   Next
   
   ;
   ;a_update( a_focused( ) )
EndMacro

Procedure new_widget_line_add( *new._s_widget )
   Protected *parent._s_widget, Param1, Param2, Param3, newClass.s = GetClass( *new )
   
   If ide_inspector_view
      If *new
         *parent = GetParent( *new )
         ;
         ; get new add position & sublevel
         Protected i, count, sublevel, position
         count = CountItems( ide_inspector_view )
         position = GetData( *parent ) 
         ;
         For i = 0 To count - 1
            Position = ( i+1 )
            
            If *parent = GetItemData( ide_inspector_view, i ) 
               SubLevel = GetItemAttribute( ide_inspector_view, i, #PB_Tree_SubLevel ) + 1
               Continue
            EndIf
            
            If SubLevel > GetItemAttribute( ide_inspector_view, i, #PB_Tree_SubLevel )
               Position = i
               Break
            EndIf
         Next 
         
         ; set new widget data
         SetData( *new, position )
         
         ; update new widget data item ;????
         If count > position
            For i = position To count - 1
               SetData( GetItemData( ide_inspector_view, i ), i + 1 )
            Next 
         EndIf
         
         
         ; get image associated with class
         Protected img =- 1
         count = CountItems( ide_inspector_elements )
         For i = 0 To count - 1
            If LCase(ClassFromType(Type(*new))) = LCase(GetItemText( ide_inspector_elements, i ))
               img = GetItemData( ide_inspector_elements, i )
               Break
            EndIf
         Next  
         
         ; add to inspector
         AddItem( ide_inspector_view, position, newClass.s, img, sublevel )
         SetItemData( ide_inspector_view, position, *new )
         ; SetItemState( ide_inspector_view, position, #PB_tree_selected )
         
         ; Debug " "+position
         SetState( ide_inspector_view, position )
         
         If IsGadget( ide_g_code )
            AddGadgetItem( ide_g_code, position, newClass.s, ImageID(img), SubLevel )
            SetGadgetItemData( ide_g_code, position, *new )
            ; SetGadgetItemState( ide_g_code, position, #PB_tree_selected )
            SetGadgetState( ide_g_code, position ) ; Bug
         EndIf
         
         ; Debug  " pos "+position + "   ( Debug >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" ) )"
      EndIf
   EndIf
   
   ProcedureReturn *new
EndProcedure

Procedure new_widget_delete( *this._s_WIDGET  )
   Protected item
   Protected i 
   Protected CountItems
   
   ;    If ListSize( a_group( ))
   ;       ForEach a_group( )
   ;          RemoveItem( ide_inspector_view, GetData( a_group( )\widget ) )
   ;          Free( a_group( )\widget )
   ;          DeleteElement( a_group( ) )
   ;       Next
   ;       
   ;       ClearList( a_group( ) )
   ;    Else
   
   If *this <> ide_design_panel_MDI
      item = GetData( *this )
      
      If item 
         Free( *this )
         
         RemoveItem( ide_inspector_view, item )
         ;
         ; after remove item 
         CountItems = CountItems( ide_inspector_view ) 
         If CountItems 
            ; update widget data item
            For i = 0 To CountItems - 1
               SetData( GetItemData( ide_inspector_view, i ), i )
            Next 
            ;
            ; set anchor focus
            If a_set( GetItemData( ide_inspector_view, GetState( ide_inspector_view ) ) )
               ; Это не нужен так как a_set( ) мы получаем фокус выджета 
               ; Properties_Updates( a_focused( ), "Delete" )
            EndIf
         EndIf
      EndIf
   EndIf
EndProcedure

Procedure new_widget_add( *parent._s_widget, type$, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, flag = 0 )
   Protected *new._s_widget
   ; flag.i | #__flag_NoFocus
   
   If *parent 
      ; OpenList( *parent, CountItems( *parent ) - 1 )
      *new = new_widget_create( *parent, type$, X,Y, Width, Height, "", 0,100,0, flag )
      
      If *new
         If LCase(type$) = "panel"
            AddItem( *new, -1, type$+"_item_0" )
         EndIf
         
         new_widget_line_add( *new )
      EndIf
      ; CloseList( )
   EndIf
   
   ProcedureReturn *new
EndProcedure

Procedure new_widget_create( *parent._s_widget, type$, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, text$="", Param1=0, Param2=0, Param3=0, flag.q = 0 )
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
               Param3 = 5
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
            If Type( *parent ) = #__Type_MDI
               *new = AddItem( *parent, #PB_Any, text$, - 1, flag | #PB_Window_NoActivate )
               Resize( *new, X, Y, Width, Height )
            Else
               flag | #PB_Window_SystemMenu | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget | #PB_Window_NoActivate
               *new = Window( X,Y,Width,Height, text$, flag, *parent )
            EndIf
            SetFrame( *new, 0)
            
         Case "scrollarea"  : *new = ScrollArea( X,Y,Width,Height, Param1, Param2, Param3, flag ) : CloseList( ) ; 1 
            SetFrame( *new, 30)
            SetBackgroundColor( *new, $74F6FE )
         Case "container"   : *new = Container( X,Y,Width,Height, flag ) : CloseList( )
         Case "panel"       : *new = Panel( X,Y,Width,Height, flag ) : CloseList( )
            SetFrame( *new, 0)
            
         Case "button"        : *new = Button(       X, Y, Width, Height, text$, flag ) 
         Case "string"        : *new = String(       X, Y, Width, Height, text$, flag )
         Case "text"          : *new = Text(         X, Y, Width, Height, text$, flag )
         Case "checkbox"      : *new = CheckBox(     X, Y, Width, Height, text$, flag ) 
            ; Case "web"           : *new = Web(          X, Y, Width, Height, text$, flag )
         Case "explorerlist"  : *new = ExplorerList( X, Y, Width, Height, text$, flag )                                                                           
            ; Case "explorertree"  : *new = ExplorerTree( X, Y, Width, Height, text$, flag )                                                                           
            ; Case "explorercombo" : *new = ExplorerCombo(X, Y, Width, Height, text$, flag )                                                                          
         Case "frame"         : *new = Frame(        X, Y, Width, Height, text$, flag )                                                                                  
            
            ; Case "date"          : *new = Date(         X, Y, Width, Height, text$, Param1, flag )         ; 2            
         Case "hyperlink"     : *new = HyperLink(    X, Y, Width, Height, text$, Param1, flag )                                                          
         Case "listicon"      : *new = ListIcon(     X, Y, Width, Height, text$, Param1, flag )                                                       
            
         Case "scroll"        : *new = Scroll(       X, Y, Width, Height, Param1, Param2, Param3, flag )  ; bar                                                             
            
         Case "progress"      : *new = Progress(     X, Y, Width, Height, Param1, Param2, flag )          ; bar                                                           
         Case "track"         : *new = Track(        X, Y, Width, Height, Param1, Param2, flag )          ; bar                                                                           
         Case "spin"          : *new = Spin(         X, Y, Width, Height, Param1, Param2, flag )                                                                             
         Case "splitter"      : *new = Splitter(     X, Y, Width, Height, Param1, Param2, flag )                                                                         
         Case "mdi"           : *new = MDI(          X, Y, Width, Height, flag )  ;  , Param1, Param2                                                                          
         Case "image"         : *new = Image(        X, Y, Width, Height, Param1, flag )                                                                                                     
         Case "buttonimage"   : *new = ButtonImage(  X, Y, Width, Height, Param1, flag )                                                                                                 
            
            ; Case "calendar"      : *new = Calendar(     X, Y, Width, Height, Param1, flag )                 ; 1                                                 
            
         Case "listview"      : *new = ListView(     X, Y, Width, Height, flag )                                                                                                                       
         Case "combobox"      : *new = ComboBox(     X, Y, Width, Height, flag ) 
         Case "editor"        : *new = Editor(       X, Y, Width, Height, flag )                                                                                                                          
         Case "tree"          : *new = Tree(         X, Y, Width, Height, flag )                                                                                                                            
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
         ;          If *parent = ide_design_panel_MDI
         ;             newtype$ = Class( *new )+"_"+CountType( *new , 2 )
         ;          Else
         ;             newtype$ = Class( *parent )+"_"+CountType( *parent, 2 )+"_"+Class( *new )+"_"+CountType( *new , 2 )
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
               
               If Not flag & #__flag_NoFocus 
                  a_set(*new, #__a_full, (14))
               EndIf
               SetBackColor( *new, $FFECECEC )
               ;
               Properties_Updates( *new, "Resize" )
               Bind( *new, @new_widget_events( ) )
            Else
               If Not flag & #__flag_NoFocus 
                  a_set(*new, #__a_full, (10))
               EndIf
               ;SetBackColor( *new, $FFF1F1F1 )
            EndIf 
            
            ; 
            *new\ChangeColor = 0
         Else
            If Not flag & #__flag_NoFocus 
               a_set(*new, #__a_full)
            EndIf
         EndIf
         
         Bind( *new, @new_widget_events( ), #__event_Resize )
      EndIf
      
      CloseList( ) 
   EndIf
   
   ProcedureReturn *new
EndProcedure

Procedure new_widget_events( )
   Protected *new
   Protected *g._s_WIDGET = EventWidget( )
   Protected __event = WidgetEvent( )
   Protected __item = WidgetEventItem( )
   Protected __data = WidgetEventData( )
   
   Select __event 
      Case #__event_Free
         Protected item = GetData(*g) 
         RemoveItem( ide_inspector_view, item ) 
         
         ;
         DeleteMapElement( GetObject( ), RemoveString( GetClass(*g), "#"+ClassFromType(Type(*g))+"_" ))
         
         ; Debug "free "+item
         ; ProcedureReturn 0
         
      Case #__event_RightDown
         Debug "right"
         
      Case #__event_Down
         If a_focused( ) = *g
            If GetActive( ) <> ide_inspector_view 
               SetActive( ide_inspector_view )
              ; Debug "------------- active "+GetClass(GetActive( ))
            EndIf
         EndIf
         
      Case #__event_LostFocus
         If a_focused( ) = *g
            ; Debug "LOSTFOCUS "+GetClass(*g)
            SetState( ide_inspector_view, - 1 )
         EndIf
         
      Case #__event_Focus
         If a_focused( ) = *g
            ; Debug "FOCUS "+GetClass(*g)
            
            If GetData(*g) >= 0
               If IsGadget( ide_g_code )
                  SetGadgetState( ide_g_code, GetData(*g) )
               EndIf
               SetState( ide_inspector_view, GetData(*g) )
            EndIf
            
            Properties_Updates( a_focused( ), "Focus" )
         EndIf
         
      Case #__event_Resize
         If a_focused( ) = *g
            Properties_Updates( a_focused( ), "Resize" )
         EndIf
         
      Case #__event_DragStart
         If is_drag_move( )
            If DragDropPrivate( #_DD_reParent )
               ChangeCursor( *g, #PB_Cursor_Arrows )
            EndIf
         Else
            If IsContainer(*g) 
               If MouseEnter(*g)
                  If Not a_index( )
                     If GetState( ide_inspector_elements) > 0 
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
               Debug " ----- DD_new ----- "+ GetText( ide_inspector_elements ) +" "+ DropX( ) +" "+ DropY( ) +" "+ DropWidth( ) +" "+ DropHeight( )
               new_widget_add( *g, GetText( ide_inspector_elements ), DropX( ), DropY( ), DropWidth( ), DropHeight( ) )
               
            Case #_DD_CreateCopy
               Debug " ----- DD_copy ----- " + GetText( Pressed( ) )
               
               ;            *new = new_widget_add( *g, GetClass( Pressed( ) ), 
               ;                         X( Pressed( ) ), Y( Pressed( ) ), Width( Pressed( ) ), Height( Pressed( ) ) )
               
               *new = new_widget_add( *g, DropText( ), DropX( ), DropY( ), DropWidth( ), DropHeight( ) )
               SetText( *new, "Copy_"+ DropText( ) )
               
         EndSelect
         
      Case #__event_LeftDown
         If IsContainer(*g)
            If mouse( )\selector
               If GetState( ide_inspector_elements) > 0 
                  mouse( )\selector\dotted = 0
               EndIf
            EndIf
         EndIf
         
      Case #__event_LeftUp
         ; then group select
         If IsContainer(*g)
            If mouse( )\selector And ListSize( a_group( ) )
               SetState( ide_inspector_view, - 1 ) 
               If IsGadget( ide_g_code )
                  SetGadgetState( ide_g_code, - 1 )
               EndIf
               
               ForEach a_group( )
                  SetItemState( ide_inspector_view, GetData( a_group( )\widget ), #PB_Tree_Selected )
                  If IsGadget( ide_g_code )
                     SetGadgetItemState( ide_g_code, GetData( a_group( )\widget ), #PB_Tree_Selected )
                  EndIf
               Next
            EndIf
         EndIf
         
      Case #__event_MouseMove
         If IsContainer(*g) 
            If MouseEnter( *g )
               If Not MouseButtonPress( )
                  If GetState( ide_inspector_elements ) > 0 
                     If GetCursor( ) < 255 ; <> #__Cursor_Arrows
                        Debug " mouse enter to change cursor " 
                        ; ChangeCursor( *g, #__Cursor_Arrows )
                        ChangeCursor( *g, Cursor::Create( ImageID( GetItemData( ide_inspector_elements, GetState( ide_inspector_elements ) ) ) ))
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
         
      Case #__event_Cursor
         ; Debug "CURSOR events"
         ProcedureReturn #PB_Cursor_Default
         
   EndSelect
   
   ;
   If  __event = #__event_LeftUp
      If IsContainer(*g)
         If GetState( ide_inspector_elements) > 0
            new_widget_add( *g, GetText( ide_inspector_elements ), GetMouseX( *g ), GetMouseY( *g ))
         EndIf
      EndIf
      
      If keyboard( )\key[1]
         ProcedureReturn #PB_Ignore
      EndIf
   EndIf
   
   ;\\
   If __event = #__event_Drop  Or 
      __event = #__event_RightUp Or
      __event = #__event_LeftUp
      
      ; end new create
      If GetState( ide_inspector_elements ) > 0 
         SetState( ide_inspector_elements, 0 )
      EndIf
   EndIf
   
   ; отключаем дальнейшую обработку всех событий
   ; а также события кнопок окна (Close, Maximize, Minimize)
   ProcedureReturn #PB_Ignore
EndProcedure

;-
;- LENGUAGE
Enumeration lng
   #lng_YES
   #lng_NO
   #lng_CANCEL
   #lng_NEW
   #lng_OPEN
   #lng_SAVE
   #lng_MENU
   #lng_QUIT
   #lng_SAVEAS
   #lng_RUN
   #lng_FORM
   #lng_CODE
   #lng_ELEMENTS
   #lng_PROPERTIES
   #lng_EVENTS
   #lng_LENGUAGE
EndEnumeration

;                        ;eng = 0    ;rus = 1          ; french = 2         ; german = 3
AddLng( #lng_NEW,        "New        |Новый            |Nouveau             |Neu" )
AddLng( #lng_OPEN,       "Open       |Открыть          |Ouvrir              |Öffnen" )
AddLng( #lng_SAVE,       "Save       |Сохранить        |Sauvegarder         |Speichern" )
AddLng( #lng_YES,        "Yes        |Да               |Oui                 |Ja" )
AddLng( #lng_NO,         "No         |Нет              |Non                 |Nein" )
AddLng( #lng_CANCEL,     "Cancel     |Отмена           |Annuler             |Abbrechen" )
AddLng( #lng_MENU,       "Menu       |Меню             |Menu                |Menü" )
AddLng( #lng_QUIT,       "Quit       |Выход            |Quitter             |Beenden" )
AddLng( #lng_SAVEAS,     "Save as... |Сохранить как... |Enregistrer sous... |Speichern unter..." )
AddLng( #lng_RUN,        "Run        |Запуск           |Exécuter            |Ausführen" )
AddLng( #lng_FORM,       "Form       |Форма            |Forme               |Formular" )
AddLng( #lng_CODE,       "Code       |Код              |Code                |Code" )
AddLng( #lng_ELEMENTS,   "Elements   |Элементы         |Éléments            |Elemente" )
AddLng( #lng_PROPERTIES, "Properties |Свойства         |Propriétés          |Eigenschaften" )
AddLng( #lng_EVENTS,     "Events     |События          |Événements          |Ereignisse" )
AddLng( #lng_LENGUAGE,   "Lenguage   |Язык             |Langage             |Sprache" )

;
Procedure ide_Lng_change( lng_TYPE=0 )
   Debug "  LNG CHANGE "+lng_TYPE
   ;
   SetBarItemText( ide_toolbar, 0, lng(lng_TYPE, #lng_Menu))
   SetBarItemText( ide_toolbar, #_tb_file_new, lng(lng_TYPE, #lng_NEW))
   SetBarItemText( ide_toolbar, #_tb_file_open, lng(lng_TYPE, #lng_OPEN))
   SetBarItemText( ide_toolbar, #_tb_file_save, lng(lng_TYPE, #lng_SAVE))
   SetBarItemText( ide_toolbar, #_tb_file_run, "["+UCase(lng(lng_TYPE, #lng_RUN))+"]")
   SetBarItemText( ide_toolbar, #_tb_LNG, "["+UCase(lng(lng_TYPE, #lng_LENGUAGE))+"]")
   ;
   SetBarItemText( ide_menu, #_tb_file_new, lng(lng_TYPE, #lng_NEW)+" (Ctrl+N)")
   SetBarItemText( ide_menu, #_tb_file_open, lng(lng_TYPE, #lng_OPEN)+" (Ctrl+O)")
   SetBarItemText( ide_menu, #_tb_file_save, lng(lng_TYPE, #lng_SAVE)+" (Ctrl+S)")
   SetBarItemText( ide_menu, #_tb_file_SAVEAS, lng(lng_TYPE, #lng_SAVEAS))
   SetBarItemText( ide_menu, #_tb_file_quit, lng(lng_TYPE, #lng_QUIT))
   ;
   SetItemText( ide_inspector_PANEL, 0, lng(lng_TYPE, #lng_ELEMENTS))
   SetItemText( ide_inspector_PANEL, 1, lng(lng_TYPE, #lng_PROPERTIES))
   SetItemText( ide_inspector_PANEL, 2, lng(lng_TYPE, #lng_EVENTS))
   
   SetItemText( ide_design_PANEL, 0, lng(lng_TYPE, #lng_FORM))
   SetItemText( ide_design_PANEL, 1, lng(lng_TYPE, #lng_CODE))
   
   If lng_TYPE = 0
      DisableBarButton( ide_toolbar, #_tb_lng_RUS, #False )
      DisableBarButton( ide_toolbar, #_tb_lng_ENG, #True )
   ElseIf lng_TYPE = 1
      DisableBarButton( ide_toolbar, #_tb_lng_ENG, #False )
      DisableBarButton( ide_toolbar, #_tb_lng_RUS, #True )
   EndIf
   
   Define *root._s_ROOT = ide_root
   PostReDraw( *root )
EndProcedure

;-
Procedure.S ide_help_elements(Class.s)
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

#File = 0
Procedure   ide_file_new( )
   ; Очишаем текст
   ClearItems( ide_design_DEBUG ) 
   ; удаляем всех детей у MDI 
   ; (то есть освобождаем MDI)
   ClearWidgets( ide_design_panel_MDI )
   ; Free( ide_design_panel_MDI, 1 )
   ; затем создаем новое окно
   ide_design_FORM = new_widget_add( ide_design_panel_MDI, "window", 7, 7, 400, 250 )
   
   ; и показываем гаджеты для добавления
   SetState( ide_design_PANEL, 0 )
   SetState( ide_inspector_PANEL, 0 )
   
   If Not Hide( ide_design_panel_CODE )
      SetText( ide_design_panel_CODE, Generate_Code( ide_design_panel_MDI ) )
      ;                SetActive( ide_design_panel_CODE )
   EndIf
   ; SetText( ide_design_DEBUG, Generate_Code( ide_design_panel_MDI ) )
   
EndProcedure

Procedure   ide_file_open(Path$) ; Открытие файла
   Protected Text$, String$
   
   If Path$
      ClearDebugOutput( )
      ClearItems( ide_design_DEBUG )
      Debug "Открываю файл '"+Path$+"'"
      ;
      SetState( ide_design_PANEL, 0 )
      SetState( ide_inspector_PANEL, 0 )
      ;
      ClearWidgets( ide_design_panel_MDI )
      
      If ReadFile( #File, Path$ ) ; Если файл можно прочитать, продолжаем...
         Define Text$ = ReadString( #File, #PB_File_IgnoreEOL ) ; чтение целиком содержимого файла
         FileSeek( #File, 0 )                                   ; 
         
         While Eof( #File ) = 0 ; Цикл, пока не будет достигнут конец файла. (Eof = 'Конец файла')
            String$ = ReadString( #File ) ; Построчный просмотр содержимого файла
            String$ = RemoveString( String$, "?" ) ; https://www.purebasic.fr/english/viewtopic.php?t=86467
            
            MakeLine( ide_design_panel_MDI, String$, Text$ )
         Wend
         
         ;          
         ;          ForEach *parser\Line()
         ;             Debug *parser\Line()\func$ +"?"+ *parser\Line()\arg$
         ;          Next
         
         ;          ;          ;
         ;          ;          Text$ = ReadString( #File, #PB_File_IgnoreEOL ) ; чтение целиком содержимого файла
         ;          
         ;          ; bug hides
         ;          If Not Hide( ide_design_panel_CODE )
         ;             SetText( ide_design_panel_CODE, Generate_Code( ide_design_panel_MDI ) )
         ;             ;                SetActive( ide_design_panel_CODE )
         ;          EndIf
         
         
         Define code$ = Generate_Code( ide_design_panel_MDI )
         code$ = Mid( code$, FindString( code$, "Procedure Open_" ))
         code$ = Mid( code$, 1, FindString( code$, "EndProcedure" ))+"ndProcedure"
         SetText( ide_design_DEBUG, code$ )
         
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
         Text$ = Generate_Code( ide_design_panel_MDI )
      Else
         Text$ = GetText( ide_design_panel_CODE )
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


Procedure.i ide_list_images_add( *id, Directory$ )
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
Procedure ide_menu_events( *g._s_WIDGET, BarButton )
   Protected transform, move_x, move_y
   Static NewList *copy._s_a_group( )
   
   ; Debug "ide_menu_events "+BarButton
   
   Select BarButton
      Case #_tb_LNG
         If Hide( ide_popup_lenguage )
            DisplayPopupBar( ide_popup_lenguage, *g )
         Else
            HideWindow( GetCanvasWindow(GetRoot(ide_popup_lenguage)), 1 )
            Hide( ide_popup_lenguage, 1 )
         EndIf
         
      Case #_tb_lng_ENG
         ide_Lng_change( 0 )
         
      Case #_tb_lng_RUS
         ide_Lng_change( 1 )
         
      Case #_tb_lng_FRENCH
         ide_Lng_change( 2 )
         
      Case #_tb_lng_GERMAN
         ide_Lng_change( 3 )
         
      Case #_tb_group_select
         If Type(*g) = #__type_ToolBar
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
         
         ForEach a_group( )
            Debug a_group( )\widget\x
            
         Next
         
         ;  RUN
      Case #_tb_file_run
         Define Code.s = Generate_Code( ide_design_panel_MDI ) ;GetText( ide_design_panel_CODE )
         
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
         
      Case #_tb_new_widget_copy
         new_widget_copy( )
         
      Case #_tb_new_widget_cut
         new_widget_copy( )
         new_widget_delete( a_focused( ) )
         
      Case #_tb_new_widget_paste
         new_widget_paste( )
         
      Case #_tb_new_widget_delete
         new_widget_delete( a_focused( ) )
         
         
      Case #_tb_group_left,
           #_tb_group_right, 
           #_tb_group_top, 
           #_tb_group_bottom, 
           #_tb_group_width, 
           #_tb_group_height
         
         ;\\ toolbar buttons events
         If mouse( )\selector
            move_x = mouse( )\selector\x - a_focused( )\x[#__c_inner]
            move_y = mouse( )\selector\y - a_focused( )\y[#__c_inner]
            
            ForEach a_group( )
               Select BarButton
                  Case #_tb_group_left ; left
                                       ;mouse( )\selector\x = 0
                     mouse( )\selector\width = 0
                     Resize( a_group( )\widget, move_x, #PB_Ignore, #PB_Ignore, #PB_Ignore )
                     
                  Case #_tb_group_right ; right
                     mouse( )\selector\x = 0
                     mouse( )\selector\width = 0
                     Resize( a_group( )\widget, move_x + a_group( )\width, #PB_Ignore, #PB_Ignore, #PB_Ignore )
                     
                  Case #_tb_group_top ; top
                                      ;mouse( )\selector\y = 0
                     mouse( )\selector\height = 0
                     Resize( a_group( )\widget, #PB_Ignore, move_y, #PB_Ignore, #PB_Ignore )
                     
                  Case #_tb_group_bottom ; bottom
                     mouse( )\selector\y = 0
                     mouse( )\selector\height = 0
                     Resize( a_group( )\widget, #PB_Ignore, move_y + a_group( )\height, #PB_Ignore, #PB_Ignore )
                     
                  Case #_tb_group_width ; stretch horizontal
                     Resize( a_group( )\widget, #PB_Ignore, #PB_Ignore, mouse( )\selector\width, #PB_Ignore )
                     
                  Case #_tb_group_height ; stretch vertical
                     Resize( a_group( )\widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, mouse( )\selector\height )
                     
               EndSelect
            Next
            
            a_update( a_focused( ) )
         EndIf
         
         ;       Case #_tb_menu
         ;          DisplayPopupBar(*g)
         
   EndSelect
   
EndProcedure

Procedure ide_events( )
   Protected *this._s_widget
   Protected *g._s_WIDGET = EventWidget( )
   Protected __event = WidgetEvent( )
   Protected __item = WidgetEventItem( )
   Protected __data = WidgetEventData( )
   ; Debug ""+ClassFromEvent(__event) +" "+ GetClass(*g)
   
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
         
      Case #__event_Close
         If *g = ide_root
            If #PB_MessageRequester_Yes = Message( "Message", 
                                                   "Are you sure you want to go out?",
                                                   #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
               ProcedureReturn #PB_All
            Else
               ProcedureReturn #False ; no close
            EndIf
         EndIf
         
      Case #__event_DragStart
         If *g = ide_inspector_elements
            If __item >= 0
               SetState( *g, __item)
               
               Debug " ------ drag ide_events() ----- "
               If DragDropPrivate( #_DD_CreateNew )
                  ChangeCursor( *g, Cursor::Create( ImageID( GetItemData( *g, __item ) ) ) )
               EndIf
            EndIf
         EndIf
         
      Case #__event_StatusChange
         If __item = - 1
            SetText( ide_inspector_HELP, "help for the inspector" )
         Else
            If __data < 0
               If *g = ide_inspector_view
                  ; Debug ""+__data+" i "+__item
                  SetText( ide_inspector_HELP, GetItemText( *g, __item ) )
               EndIf
               If *g = ide_inspector_elements
                  SetText( ide_inspector_HELP, ide_help_elements(GetItemText( *g, __item )) )
               EndIf
               If *g = ide_inspector_properties
                  SetText( ide_inspector_HELP, GetItemText( *g, __item ) )
               EndIf
               If *g = ide_inspector_events
                  SetText( ide_inspector_HELP, GetItemText( *g, __item ) )
               EndIf
            EndIf
         EndIf
         
      Case #__event_Change
         If *g = ide_inspector_view
            a_set( GetItemData( *g, GetState(*g) ))
         EndIf
         
         If *g = ide_design_PANEL
            If __item = 1
               AddItem( ide_design_panel_CODE, 0, "" ) ; BUG 
               SetText( ide_design_panel_CODE, Generate_Code( ide_design_panel_MDI ) )
               SetActive( ide_design_panel_CODE )
            EndIf
         EndIf
         
      Case #__event_Left2Click
         If *g = ide_design_PANEL
            Debug #__event_Left2Click
         EndIf
         
         ; Debug "2click"
         If a_focused( )
            If IsContainer(a_focused( ))
               If GetState( ide_inspector_elements) > 0
                  Static _x_, _y_
                  new_widget_add( a_focused( ), GetText( ide_inspector_elements ), _x_ + mouse( )\steps, _y_ + mouse( )\steps, #PB_Ignore, #PB_Ignore, #__flag_NoFocus )
                  ; a_set( a_focused( )\parent )
                  _x_ + mouse( )\steps
                  _y_ + mouse( )\steps
                  SetState( ide_inspector_elements, 0 )
               EndIf
            EndIf  
         EndIf  
         
      Case #__event_LeftClick 
         If *g = ide_design_PANEL
            Debug #__event_LeftClick
             SetClipboardText( GetText(ide_design_panel_CODE) )
         EndIf
         
         ; ide_menu_events( *g, __item )
         
         ; Debug *g\TabEntered( )
         
         If *g\TabEntered( )
            ide_menu_events( *g, *g\TabEntered( )\index )
         Else
            If Type(*g) = #__type_toolbar
               ide_menu_events( *g, GetData(*g) )
            EndIf
         EndIf
         
   EndSelect
   
   ; CODE EDIT EVENTS
   If *g = ide_design_panel_CODE                      Or *g = ide_design_DEBUG ; TEMP
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
                  object = MakeID( name$, ide_design_panel_MDI )
                  If Not object
                     If CountString( text$, "=" )
                        name$ = Trim( StringField( text$, 1, "=" ))
                        If CountString( name$, " " )
                           name$ = Trim( StringField( name$, 2, " " ))
                        EndIf
                     EndIf
                     
                     object = MakeID( name$, ide_design_panel_MDI )
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
                     If name$ = ClassFromType( Type( object ))
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

Procedure ide_open( X=50,Y=75,Width=900,Height=700 )
   ;     OpenWindow( #PB_Any, 0,0,332,232, "" )
   ;     ide_g_code = TreeGadget( -1,1,1,330,230 ) 
   
   Define flag = #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget | #PB_Window_Invisible
   ide_root = Open( 1, X,Y,Width,Height, "ide", flag ) 
   ide_window = GetCanvasWindow( ide_root )
   ide_g_canvas = GetCanvasGadget( ide_root )
   
   ;    Debug "create window - "+WindowID(ide_window)
   ;    Debug "create canvas - "+GadgetID(ide_g_canvas)
   
   ide_toolbar_container = Container( 0,0,0,0, #__flag_border_Flat ) 
   ide_toolbar = CreateBar( ide_toolbar_container, #PB_ToolBar_Small );|#PB_ToolBar_Large|#PB_ToolBar_Buttons);| #PB_ToolBar_InlineText )
   SetColor(ide_toolbar, #PB_Gadget_BackColor, $fffefefe )
   
   ide_menu = OpenSubBar("Menu")
;    BarItem( #_tb_file_new, "New" + Space(9) + Chr(9) + "Ctrl+O")
   BarItem( #_tb_file_new, "New (Ctrl+N)")
   BarItem( #_tb_file_open, "Open (Ctrl+O)")
   BarItem( #_tb_file_save, "Save (Ctrl+S)")
   BarItem( #_tb_file_SAVEAS, "Save as...")
;    BarSeparator( )
;    OpenSubBar("Lng")
;    BarItem( #_tb_lng_ENG, "ENG")
;    BarItem( #_tb_lng_RUS, "RUS")
;    CloseSubBar( )
   BarSeparator( )
   BarItem( #_tb_file_quit, "Quit" );+ Chr(9) + "Ctrl+Q")
   CloseSubBar( )
   ;
   BarSeparator( )
   BarItem( #_tb_file_new, "New" )
   BarItem( #_tb_file_open, "Open" )
   BarItem( #_tb_file_save, "Save" )
   BarSeparator( )
   BarButton( #_tb_new_widget_copy, CatchImage( #PB_Any,?image_new_widget_copy ) )
   BarButton( #_tb_new_widget_paste, CatchImage( #PB_Any,?image_new_widget_paste ) )
   BarButton( #_tb_new_widget_cut, CatchImage( #PB_Any,?image_new_widget_cut ) )
   BarButton( #_tb_new_widget_delete, CatchImage( #PB_Any,?image_new_widget_delete ) )
   BarSeparator( )
   BarItem( #_tb_file_run, "[RUN]" )
   BarItem( #_tb_lng_ENG, "[ENG]" )
   BarItem( #_tb_lng_RUS, "[RUS]" )
   BarSeparator( )
   BarButton( #_tb_group_select, CatchImage( #PB_Any,?image_group ), #PB_ToolBar_Toggle ) 
   ;
   ;    SetItemAttribute( widget( ), #_tb_group_select, #PB_Button_Image, CatchImage( #PB_Any,?image_group_un ) )
   ;    SetItemAttribute( widget( ), #_tb_group_select, #PB_Button_PressedImage, CatchImage( #PB_Any,?image_group ) )
   ;
   BarSeparator( )
   BarButton( #_tb_group_left, CatchImage( #PB_Any,?image_group_left ) )
   BarButton( #_tb_group_right, CatchImage( #PB_Any,?image_group_right ) )
   BarSeparator( )
   BarButton( #_tb_group_top, CatchImage( #PB_Any,?image_group_top ) )
   BarButton( #_tb_group_bottom, CatchImage( #PB_Any,?image_group_bottom ) )
   BarSeparator( )
   BarButton( #_tb_group_width, CatchImage( #PB_Any,?image_group_width ) )
   BarButton( #_tb_group_height, CatchImage( #PB_Any,?image_group_height ) )
   
   ;    BarSeparator( )
   ;    OpenSubBar("ComboBox")
   ;    BarItem(55, "item1")
   ;    BarItem(56, "item2")
   ;    BarItem(57, "item3")
   ;    CloseSubBar( )
   
   BarSeparator( )
   ;    BarButton( #_tb_align_left, CatchImage( #PB_Any,?image_group_left ) )
   ;    BarButton( #_tb_align_top, CatchImage( #PB_Any,?image_group_top ) )
   ;    BarButton( #_tb_align_center, CatchImage( #PB_Any,?image_group_width ) )
   ;    BarButton( #_tb_align_bottom, CatchImage( #PB_Any,?image_group_bottom ) )
   ;    BarButton( #_tb_align_right, CatchImage( #PB_Any,?image_group_right ) )
   BarItem( #_tb_LNG, "[LENGUAGE]" )
   
   ide_popup_lenguage = CreatePopupBar( )
   If ide_popup_lenguage
      BarItem(#_tb_lng_ENG, "ENG")
      BarItem(#_tb_lng_RUS, "RUS")
      BarItem(#_tb_lng_FRENCH, "FRENCH")
      BarItem(#_tb_lng_GERMAN, "GERMAN")
    EndIf
   CloseList( )
   
   DisableBarButton( ide_toolbar, #_tb_lng_ENG, #True )
   
   ;
   ; gadgets
   ;
   ;\\\ 
   Define ide_root2 ;= Open(1) : Define ide_design_g_canvas =  GetCanvasGadget(ide_root2)
   
   ide_design_PANEL = Panel( 0,0,0,0, #__flag_autosize ) : SetClass(ide_design_PANEL, "ide_design_PANEL" ) ; , #__flag_Vertical ) : OpenList( ide_design_PANEL )
   AddItem( ide_design_PANEL, -1, "Form" )
   ide_design_panel_MDI = MDI( 0,0,0,0, #__flag_autosize ) : SetClass(ide_design_panel_MDI, "ide_design_panel_MDI" ) ;: SetFrame(ide_design_panel_MDI, 10)
   SetColor( ide_design_panel_MDI, #PB_Gadget_BackColor, $FFBF9CC3 )
   a_init( ide_design_panel_MDI);, 0 )
   
   AddItem( ide_design_PANEL, -1, "Code" )
   ide_design_panel_CODE = Editor( 0,0,0,0, #__flag_autosize ) : SetClass(ide_design_panel_CODE, "ide_design_panel_CODE" ) ; bug then move anchors window
   SetBackColor( ide_design_panel_CODE, $FFDCF9F6)
   AddItem( ide_design_PANEL, -1, "Hiasm" )
   CloseList( )
   
   If ide_root2
      CloseGadgetList( )
      UseGadgetList( GadgetID(ide_g_canvas))
      OpenList(ide_root)
   Else
      Define ide_design_g_canvas = ide_design_PANEL
   EndIf
   
   ;
   ;ide_design_DEBUG = Editor( 0,0,0,0, #PB_Editor_ReadOnly ) : SetClass(ide_design_DEBUG, "ide_design_DEBUG" ) ; ListView( 0,0,0,0 ) 
   ide_design_DEBUG = Editor( 0,0,0,0 ) : SetClass(ide_design_DEBUG, "ide_design_DEBUG" ) ; ListView( 0,0,0,0 ) 
   If Not ide_design_panel_CODE
      ide_design_panel_CODE = ide_design_DEBUG
   EndIf
   
   ;\\\ open inspector gadgets 
   ide_inspector_view = Tree( 0,0,0,0 ) : SetClass(ide_inspector_view, "ide_inspector_view" ) ;, #__flag_gridlines )
   EnableDrop( ide_inspector_view, #PB_Drop_Text, #PB_Drag_Link )
   
   ; ide_inspector_view_splitter_panel_open
   ide_inspector_PANEL = Panel( 0,0,0,0 ) : SetClass(ide_inspector_PANEL, "ide_inspector_PANEL" )
   
   ; ide_inspector_panel_item_1 
   AddItem( ide_inspector_PANEL, -1, "elements", 0, 0 ) 
   ide_inspector_elements = Tree( 0,0,0,0, #__flag_autosize | #__flag_NoButtons | #__flag_NoLines | #__flag_border_less ) : SetClass(ide_inspector_elements, "ide_inspector_elements" )
   If ide_inspector_elements
      ide_list_images_add( ide_inspector_elements, GetCurrentDirectory( )+"Themes/" )
   EndIf
   
   ; ide_inspector_panel_item_2
   AddItem( ide_inspector_PANEL, -1, "properties", 0, 0 )  
   ide_inspector_properties = Properties_Create( 0,0,0,0, #__flag_autosize | #__flag_gridlines | #__flag_border_less ) : SetClass(ide_inspector_properties, "ide_inspector_properties" )
   If ide_inspector_properties
      Properties_AddItem( ide_inspector_properties, #_pi_group_COMMON, "COMMON" )
      Properties_AddItem( ide_inspector_properties, #_pi_ID,             "#ID",      #__Type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_class,          "Class",    #__Type_String, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_text,           "Text",     #__Type_String, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_IMAGE,          "Image",    #__Type_Button, 1 )
      ;
      Properties_AddItem( ide_inspector_properties, #_pi_group_LAYOUT, "LAYOUT" )
      Properties_AddItem( ide_inspector_properties, #_pi_align,          "Align"+Chr(10)+"LEFT|TOP", #__Type_Button, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_x,              "X",        #__Type_Spin, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_y,              "Y",        #__Type_Spin, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_width,          "Width",    #__Type_Spin, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_height,         "Height",   #__Type_Spin, 1 )
      ;
      Properties_AddItem( ide_inspector_properties, #_pi_group_VIEW,   "VIEW" )
      Properties_AddItem( ide_inspector_properties, #_pi_cursor,         "Cursor",   #__Type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_hide,           "Hide",     #__Type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_disable,        "Disable",  #__Type_ComboBox, 1 )
      ;
      Properties_AddItem( ide_inspector_properties, #_pi_flag,          "Flag",      #__Type_ComboBox, 1 )
      ;
      Properties_AddItem( ide_inspector_properties, #_pi_FONT,           "Font",     #__Type_Button, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_fontsize,       "size",     #__Type_Spin, 2 )
      Properties_AddItem( ide_inspector_properties, #_pi_fontstyle,      "style",    #__Type_ComboBox, 2 )
      ;
      Properties_AddItem( ide_inspector_properties, #_pi_COLOR,           "Color",   #__Type_Button, 1 )
      Properties_AddItem( ide_inspector_properties, #_pi_colortype,       "type",    #__Type_ComboBox, 2 )
      Properties_AddItem( ide_inspector_properties, #_pi_colorstate,      "state",    #__Type_ComboBox, 2 )
      Properties_AddItem( ide_inspector_properties, #_pi_coloralpha,      "alpha",   #__Type_Spin, 2 )
      Properties_AddItem( ide_inspector_properties, #_pi_colorblue,       "blue",    #__Type_Spin, 2 )
      Properties_AddItem( ide_inspector_properties, #_pi_colorgreen,      "green",   #__Type_Spin, 2 )
      Properties_AddItem( ide_inspector_properties, #_pi_colorred,        "red",     #__Type_Spin, 2 )
   EndIf
   
   ; ide_inspector_panel_item_3 
   AddItem( ide_inspector_PANEL, -1, "events", 0, 0 )  
   ;ide_inspector_events = Tree( 0,0,0,0, #__flag_autosize | #__flag_border_less ) : SetClass(ide_inspector_events, "ide_inspector_events" ) 
   ide_inspector_events = Properties_Create( 0,0,0,0, #__flag_autosize | #__flag_gridlines | #__flag_border_less ) : SetClass(ide_inspector_properties, "ide_inspector_properties" )
   If ide_inspector_events
      Properties_AddItem( ide_inspector_events, #_ei_leftclick,  "LeftClick", #__Type_ComboBox )
      Properties_AddItem( ide_inspector_events, #_ei_change,  "Change", #__Type_ComboBox )
      Properties_AddItem( ide_inspector_events, #_ei_enter,  "Enter", #__Type_ComboBox )
      Properties_AddItem( ide_inspector_events, #_ei_leave,  "Leave", #__Type_ComboBox )
   EndIf
   
   ; ide_inspector_view_splitter_panel_close
   CloseList( )
   
   ; ide_inspector_ide_inspector_panel_splitter_text
   ide_inspector_HELP  = Text( 0,0,0,0, "help for the inspector", #PB_Text_Border ) : SetClass(ide_inspector_HELP, "ide_inspector_HELP" )
   ;\\\ close inspector gadgets 
   
   ;
   ;\\\ ide splitters
   ;       ;
   ;       ; main splitter 1 example
   ;       ide_design_splitter = Splitter( 0,0,0,0, ide_toolbar_container,ide_design_g_canvas, #PB_Splitter_FirstFixed | #PB_Splitter_Separator ) : SetClass(ide_design_splitter, "ide_design_splitter" )
   ;       ide_inspector_view_splitter = Splitter( 0,0,0,0, ide_inspector_view,ide_inspector_PANEL, #PB_Splitter_FirstFixed ) : SetClass(ide_inspector_view_splitter, "ide_inspector_view_splitter" )
   ;       ide_design_PANEL_splitter = Splitter( 0,0,0,0, ide_design_splitter,ide_design_DEBUG, #PB_Splitter_SecondFixed ) : SetClass(ide_design_PANEL_splitter, "ide_design_PANEL_splitter" )
   ;       ide_inspector_panel_splitter = Splitter( 0,0,0,0, ide_inspector_view_splitter,ide_inspector_HELP, #PB_Splitter_SecondFixed ) : SetClass(ide_inspector_panel_splitter, "ide_inspector_panel_splitter" )
   ;       ide_splitter = Splitter( 0,0,0,0, ide_design_PANEL_splitter,ide_inspector_panel_splitter, #__flag_autosize | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed ) : SetClass(ide_splitter, "ide_splitter" )
   ;       
   ;       ; set splitters default minimum size
   ;       SetAttribute( ide_splitter, #PB_Splitter_FirstMinimumSize, 500 )
   ;       SetAttribute( ide_splitter, #PB_Splitter_SecondMinimumSize, 120 )
   ;       SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_FirstMinimumSize, 230 )
   ;       SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_SecondMinimumSize, 30 )
   ;       SetAttribute( ide_design_PANEL_splitter, #PB_Splitter_FirstMinimumSize, 300 )
   ;       SetAttribute( ide_design_PANEL_splitter, #PB_Splitter_SecondMinimumSize, 100 )
   ;       SetAttribute( ide_inspector_view_splitter, #PB_Splitter_FirstMinimumSize, 100 )
   ;       SetAttribute( ide_inspector_view_splitter, #PB_Splitter_SecondMinimumSize, 130 )
   ;       SetAttribute( ide_design_splitter, #PB_Splitter_FirstMinimumSize, 20 )
   ;       SetAttribute( ide_design_splitter, #PB_Splitter_SecondMinimumSize, 200 )
   ;       ; SetAttribute( ide_design_splitter, #PB_Splitter_SecondMinimumSize, $ffffff )
   ;       
   ;       ; set splitters dafault positions
   ;       SetState( ide_splitter, Width( ide_splitter )-200 )
   ;       SetState( ide_inspector_panel_splitter, Height( ide_inspector_panel_splitter )-80 )
   ;       SetState( ide_design_PANEL_splitter, Height( ide_design_PANEL_splitter )-150 )
   ;       SetState( ide_inspector_view_splitter, 200 )
   ;       SetState( ide_design_splitter, Height( ide_toolbar ) - 1 + 2 )
   ;    
   ;    ;
   ;    ;\\ main splitter 2 example 
   ;    ide_inspector_view_splitter = Splitter( 0,0,0,0, ide_inspector_view,ide_inspector_PANEL, #PB_Splitter_FirstFixed ) : SetClass(ide_inspector_view_splitter, "ide_inspector_view_splitter" )
   ;    ide_design_PANEL_splitter = Splitter( 0,0,0,0, ide_design_g_canvas,ide_design_DEBUG, #PB_Splitter_SecondFixed ) : SetClass(ide_design_PANEL_splitter, "ide_design_PANEL_splitter" )
   ;    ide_inspector_panel_splitter = Splitter( 0,0,0,0, ide_inspector_view_splitter,ide_inspector_HELP, #PB_Splitter_SecondFixed ) : SetClass(ide_inspector_panel_splitter, "ide_inspector_panel_splitter" )
   ;    ide_design_splitter = Splitter( 0,0,0,0, ide_inspector_panel_splitter, ide_design_PANEL_splitter, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical | #PB_Splitter_Separator ) : SetClass(ide_design_splitter, "ide_design_splitter" )
   ;    ide_splitter = Splitter( 0,0,0,0, ide_toolbar_container, ide_design_splitter,#__flag_autosize | #PB_Splitter_FirstFixed ) : SetClass(ide_splitter, "ide_splitter" )
   ;    
   ;    ; set splitters default minimum size
   ;    SetAttribute( ide_splitter, #PB_Splitter_FirstMinimumSize, 20 )
   ;    SetAttribute( ide_splitter, #PB_Splitter_SecondMinimumSize, 500 )
   ;    SetAttribute( ide_design_splitter, #PB_Splitter_FirstMinimumSize, 120 )
   ;    SetAttribute( ide_design_splitter, #PB_Splitter_SecondMinimumSize, 540 )
   ;    SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_FirstMinimumSize, 230 )
   ;    SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_SecondMinimumSize, 30 )
   ;    SetAttribute( ide_design_PANEL_splitter, #PB_Splitter_FirstMinimumSize, 300 )
   ;    SetAttribute( ide_design_PANEL_splitter, #PB_Splitter_SecondMinimumSize, 100 )
   ;    SetAttribute( ide_inspector_view_splitter, #PB_Splitter_FirstMinimumSize, 100 )
   ;    SetAttribute( ide_inspector_view_splitter, #PB_Splitter_SecondMinimumSize, 130 )
   ;    
   ;    ; set splitters dafault positions
   ;    SetState( ide_splitter, Height( ide_toolbar ) )
   ;    SetState( ide_design_splitter, 200 )
   ;    SetState( ide_inspector_panel_splitter, Height( ide_inspector_panel_splitter )-80 )
   ;    SetState( ide_design_PANEL_splitter, Height( ide_design_PANEL_splitter )-200 )
   ;    SetState( ide_inspector_view_splitter, 230 )
   ;    
   
   ;
   ;\\ main splitter 2 example 
   ide_inspector_panel_splitter = Splitter( 0,0,0,0, ide_inspector_PANEL, ide_inspector_HELP, #PB_Splitter_SecondFixed ) : SetClass(ide_inspector_panel_splitter, "ide_inspector_view_splitter" )
   ide_inspector_view_splitter = Splitter( 0,0,0,0, ide_inspector_view, ide_inspector_panel_splitter) : SetClass(ide_inspector_view_splitter, "ide_inspector_panel_splitter" )
   ide_design_PANEL_splitter = Splitter( 0,0,0,0, ide_design_g_canvas, ide_design_DEBUG, #PB_Splitter_SecondFixed ) : SetClass(ide_design_PANEL_splitter, "ide_design_PANEL_splitter" )
   ide_design_splitter = Splitter( 0,0,0,0, ide_inspector_view_splitter, ide_design_PANEL_splitter, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical | #PB_Splitter_Separator ) : SetClass(ide_design_splitter, "ide_design_splitter" )
   ide_splitter = Splitter( 0,0,0,0, ide_toolbar_container, ide_design_splitter,#__flag_autosize | #PB_Splitter_FirstFixed ) : SetClass(ide_splitter, "ide_splitter" )
   
   ; set splitters default minimum size
   SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_FirstMinimumSize, 100 )
   SetAttribute( ide_inspector_panel_splitter, #PB_Splitter_SecondMinimumSize, 30 )
   SetAttribute( ide_inspector_view_splitter, #PB_Splitter_FirstMinimumSize, 100 )
   SetAttribute( ide_inspector_view_splitter, #PB_Splitter_SecondMinimumSize, 200 )
   SetAttribute( ide_design_PANEL_splitter, #PB_Splitter_FirstMinimumSize, 300 )
   SetAttribute( ide_design_PANEL_splitter, #PB_Splitter_SecondMinimumSize, 100 )
   SetAttribute( ide_design_splitter, #PB_Splitter_FirstMinimumSize, 120 )
   SetAttribute( ide_design_splitter, #PB_Splitter_SecondMinimumSize, 540 )
   SetAttribute( ide_splitter, #PB_Splitter_FirstMinimumSize, 20 )
   SetAttribute( ide_splitter, #PB_Splitter_SecondMinimumSize, 500 )
   
   ; set splitters dafault positions
   SetState( ide_splitter, Height( ide_toolbar ))
   ; SetState( ide_design_splitter, 200 )
   SetState( ide_design_splitter, 250 )
   SetState( ide_design_PANEL_splitter, Height( ide_design_PANEL_splitter )-180 )
   ;SetState( ide_inspector_panel_splitter, 250 )
   ;SetState( ide_inspector_view_splitter, 200 )
   SetState( ide_inspector_view_splitter, 100 )
   
   ;
   ; ide_Lng_change( )
   ;
   
   ;
   ;-\\ ide binds events
   ;
   If Type( ide_toolbar ) = #__type_ToolBar
      Bind( ide_toolbar, @ide_events( ), #__event_LeftClick )
      Bind( ide_menu, @ide_events( ), #__event_LeftClick )
      Bind( ide_popup_lenguage, @ide_events( ), #__event_LeftClick )
   EndIf
   Bind( ide_inspector_view, @ide_events( ) )
   ;
   Bind( ide_design_PANEL, @ide_events( ), #__event_Change )
   Bind( ide_design_PANEL, @ide_events( ), #__event_LeftClick )
   Bind( ide_design_PANEL, @ide_events( ), #__event_Left2Click )
   ;
   Bind( ide_design_panel_CODE, @ide_events( ), #__event_Down )
   Bind( ide_design_panel_CODE, @ide_events( ), #__event_Up )
   Bind( ide_design_panel_CODE, @ide_events( ), #__event_Change )
   Bind( ide_design_panel_CODE, @ide_events( ), #__event_StatusChange )
   ; TEMP
   Bind( ide_design_DEBUG, @ide_events( ), #__event_Down )
   Bind( ide_design_DEBUG, @ide_events( ), #__event_Up )
   Bind( ide_design_DEBUG, @ide_events( ), #__event_Change )
   Bind( ide_design_DEBUG, @ide_events( ), #__event_StatusChange )
   ;
   Bind( ide_inspector_events, @ide_events( ), #__event_Change )
   Bind( ide_inspector_events, @ide_events( ), #__event_StatusChange )
   ;
   Bind( ide_inspector_properties, @ide_events( ), #__event_Change )
   Bind( ide_inspector_properties, @ide_events( ), #__event_StatusChange )
   ;
   Bind( ide_inspector_elements, @ide_events( ), #__event_Change )
   Bind( ide_inspector_elements, @ide_events( ), #__event_StatusChange )
   Bind( ide_inspector_elements, @ide_events( ), #__event_Left2Click )
   Bind( ide_inspector_elements, @ide_events( ), #__event_LeftClick )
   Bind( ide_inspector_elements, @ide_events( ), #__event_MouseEnter )
   Bind( ide_inspector_elements, @ide_events( ), #__event_MouseLeave )
   Bind( ide_inspector_elements, @ide_events( ), #__event_DragStart )
   ;
   ;
   Bind( ide_root, @ide_events( ), #__event_Close )
   Bind( ide_root, @ide_events( ), #__event_Focus )
   
   ;Bind( #PB_All, @ide_events( ) )
   ProcedureReturn ide_window
EndProcedure

;-
CompilerIf #PB_Compiler_IsMainFile 
   Define event
   ide_open( )
   
   AddFont( Str(GetFont( root( ) )), "Courier", 9, 0 )
   
   
   SetState( ide_inspector_PANEL, 1 )
   
   ;   ;OpenList(ide_design_panel_MDI)
   Define result, btn2, example = 3
   
   
   ide_design_FORM = new_widget_add( ide_design_panel_MDI, "window", 10, 10, 350, 200 )
   
   If example = 2
      Define cont1 = new_widget_add( ide_design_FORM, "container", 10, 10, 320, 180 )
      SetBackColor( cont1, $FF9CF9F6)
      new_widget_add( cont1, "button", 10, 20, 100, 30 )
      Define cont2 = new_widget_add( cont1, "container", 130, 20, 90, 140 )
      new_widget_add( cont2, "button", 10, 20, 30, 30 )
      Define cont3 = new_widget_add( cont1, "container", 230, 20, 90, 140 )
      new_widget_add( cont2, "button", 10, 20, 30, 30 )
      
      ;       ClearItems(ide_inspector_view)
      ; ;       AddItem(ide_inspector_view, -1, "window_0", -1, 0)
      ; ;       AddItem(ide_inspector_view, -1, "button_0", -1, 1)
      ; ;       AddItem(ide_inspector_view, -1, "container_0", -1, 1)
      ; ;       AddItem(ide_inspector_view, -1, "button_1", -1, 2)
      ; ;       
      ;       Define *parent._s_WIDGET = ide_design_panel_MDI
      ;       ;PushListPosition(widgets())
      ;       If StartEnum( *parent ,0)
      ;          Debug "99 "+ GetClass(widget()) +" "+ GetClass(widget()\parent) +" "+ Str(Level(widget()))+" "+Str(Level(*parent));IsChild(widget(), *parent )
      ;          Select CountItems(ide_inspector_view)
      ;             Case 0 
      ;                AddItem(ide_inspector_view, -1, "window_0", -1, Level(widget())-Level(*parent)-1)
      ;             Case 1 
      ;                AddItem(ide_inspector_view, -1, "button_0", -1, Level(widget())-Level(*parent)-1)
      ;             Case 2 
      ;                AddItem(ide_inspector_view, -1, "container_0", -1, Level(widget())-Level(*parent)-1)
      ;             Case 3 
      ;                AddItem(ide_inspector_view, -1, "button_1", -1, Level(widget())-Level(*parent)-1)
      ;          EndSelect
      ;          
      ;          ;   Debug CountItems(ide_inspector_view)-1
      ;          SetData(widget(), CountItems(ide_inspector_view)-1)
      ;          SetItemData(ide_inspector_view, CountItems(ide_inspector_view)-1, widget())
      ;          
      ;          StopEnum()
      ;       EndIf
      ;       ;PopListPosition(widgets())
      
      ;\\ example 2
      ;       Define *container = new_widget_add( ide_design_FORM, "container", 130, 20, 220, 140 )
      ;       new_widget_add( *container, "button", 10, 20, 30, 30 )
      ;       new_widget_add( ide_design_FORM, "button", 10, 20, 100, 30 )
      ;       
      ;       Define item = 1
      ;       SetState( ide_inspector_view, item )
      ;       If IsGadget( ide_g_code )
      ;          SetGadgetState( ide_g_code, item )
      ;       EndIf
      ;       Define *container2 = new_widget_add( *container, "container", 60, 10, 220, 140 )
      ;       new_widget_add( *container2, "button", 10, 20, 30, 30 )
      ;       
      ;       SetState( ide_inspector_view, 0 )
      ;       new_widget_add( ide_design_FORM, "button", 10, 130, 100, 30 )
      
   ElseIf example = 3
      ;\\ example 3
      Resize(ide_design_FORM, #PB_Ignore, #PB_Ignore, 500, 250)
      
      Disable(new_widget_add(ide_design_FORM, "button", 15, 25, 50, 30, #PB_Button_MultiLine),1)
      new_widget_add(ide_design_FORM, "text", 25, 65, 50, 30)
      btn2 = new_widget_add(ide_design_FORM, "button", 35, 65+40, 50, 30)
      new_widget_add(ide_design_FORM, "string", 45, 65+40*2, 50, 30)
      ;new_widget_add(ide_design_FORM, "button", 45, 65+40*2, 50, 30)
      
      Define *scrollarea = new_widget_add(ide_design_FORM, "scrollarea", 120, 25, 165, 175, #PB_ScrollArea_Flat )
      new_widget_add(*scrollarea, "button", 15, 25, 30, 30)
      new_widget_add(*scrollarea, "text", 25, 65, 50, 30)
      new_widget_add(*scrollarea, "button", 35, 65+40, 80, 30)
      new_widget_add(*scrollarea, "text", 45, 65+40*2, 50, 30)
      
      Define *panel = new_widget_add(ide_design_FORM, "panel", 320, 25, 165, 175)
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
      
      ;       ;SetMoveBounds( *scrollarea, -1,-1,-1,-1 )
      ;       ;SetSizeBounds( *scrollarea, -1,-1,-1,-1 )
      ;       ;SetSizeBounds( *scrollarea )
      ;       SetMoveBounds( btn2, -1,-1,-1,-1 )
      SetMoveBounds( ide_design_FORM, -1,-1,-1,-1 )
      ;       ;SetChildrenBounds( ide_design_panel_MDI )
      
   ElseIf example = 4
      ;\\ example 3
      Resize(ide_design_FORM, 30, 30, 400, 250)
      
      Define q=new_widget_add(ide_design_FORM, "button", 15, 25, 50, 30)
      new_widget_add(ide_design_FORM, "text", 25, 65, 50, 30)
      new_widget_add(ide_design_FORM, "button", 285, 25, 50, 30)
      new_widget_add(ide_design_FORM, "text", 45, 65+40*2, 50, 30)
      
      Define *container = new_widget_add(ide_design_FORM, "scrollarea", 100, 25, 165, 170)
      new_widget_add(*container, "button", 15, 25, 30, 30)
      new_widget_add(*container, "text", 25, 65, 50, 30)
      new_widget_add(*container, "button", 35, 65+40, 80, 30)
      new_widget_add(*container, "text", 45, 65+40*2, 50, 30)
      SetActive( q )
      
   ElseIf example = 5
      ;\\ example 3
      Resize(ide_design_FORM, 30, 30, 400, 250)
      
      Define q=new_widget_add(ide_design_FORM, "button", 280, 25, 50, 30)
      new_widget_add(ide_design_FORM, "text", 25, 65, 50, 30)
      new_widget_add(ide_design_FORM, "button", 340, 25, 50, 30)
      new_widget_add(ide_design_FORM, "text", 45, 65+40*2, 50, 30)
      
      Define *container = new_widget_add(ide_design_FORM, "scrollarea", 100, 25, 155, 170)
      new_widget_add(*container, "button", 15, 25, 30, 30)
      new_widget_add(*container, "text", 25, 65, 50, 30)
      new_widget_add(*container, "button", 35, 65+40, 80, 30)
      new_widget_add(*container, "text", 45, 65+40*2, 50, 30)
      SetActive( q )
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
   
   
   a_set( ide_design_FORM )
     
   ;ReDraw(root())
   Define time = ElapsedMilliseconds( )
   Define code$ = Generate_Code( ide_design_panel_MDI )
   code$ = Mid( code$, FindString( code$, "Procedure Open_" ))
   code$ = Mid( code$, 1, FindString( code$, "EndProcedure" ))+"ndProcedure"
   SetText( ide_design_DEBUG, code$ )
   ;Debug ""+Str(ElapsedMilliseconds( )-time) +" generate code time"
   
   ;ReDraw(root())
   HideWindow( ide_window, #False )
   
   If SetActive( ide_inspector_view )
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
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 2170
; FirstLine = 1829
; Folding = ---------f+T-------Pg----------4-n0--8d---f-4--0-----
; Optimizer
; EnableAsm
; EnableXP
; DPIAware
; Executable = C:\Users\user\Downloads\Compressed\FormDesignerWindows4.70b2\ide.exe