#ide_path = ""
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
Enumeration Properties
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
       ide_SPLITTER, 
       ide_toolbar_container, 
       ide_toolbar, 
       ide_popup_lenguage,
       ide_menu

Global ide_design_SPLITTER,
       ide_design_PANEL, 
       ide_design_MDI,
       ide_design_CODE, 
       ide_design_HIASM, 
       ide_design_DEBUG 

Global ide_inspector_SPLITTER,
       ide_inspector_VIEW, 
       ide_inspector_panel_SPLITTER, 
       ide_inspector_PANEL,
       ide_inspector_ELEMENTS,
       ide_inspector_PROPERTIES, 
       ide_inspector_EVENTS,
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
; ;
; Declare   new_widget_events( )
; Declare   new_widget_create( *parent, type$, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, text$="", Param1=0, Param2=0, Param3=0, flag.q = 0 )
; Declare   new_widget_add( *parent, type$, X.l,Y.l, Width.l=#PB_Ignore, Height.l=#PB_Ignore, flag = 0 )
; Declare   ide_inspector_VIEW_ADD_ITEMS( *new )
; ;
; Declare.s Generate_Code( *parent )
; ;
; Declare$  FindArguments( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
; Declare   MakeCallFunction( str$, arg$, findtext$ )
; Declare   GetArgIndex( text$, len, caret, mode.a = 0 )
; Declare$  GetWord( text$, len, caret )
; ;
; Declare$  FindFunctions( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
; Declare   NumericString( string$ )
; Declare   MakeLine( *mdi, string$, findtext$ )
; Declare   MakeID( class$, *rootParent )
; ;
; ;
; Declare   AddFont( key$, name$, size, style )
; Declare.s GetFontName( font.i )
; Declare.a GetFontSize( font.i )
; Declare.q GetFontStyle( font.i )
; ; Declare   SetFontName( font.i, name.s )
; ; Declare   SetFontSize( font.i, size.a )
; ; Declare   SetFontStyle( font.i, style.q )
; Declare   ChangeFont( font, name.s, size.a, style.q )
; Declare   ChangeFontSize( *this, size )
; Declare   ChangeFontStyle( *this, style.q )
; ;
; Declare   AddImages( Image )
; Declare   AddImage( key$, file$, flags = 0 )
; Declare   ChangeImage( img )
; Declare$  GetImageKey( img )
; Declare$  GetImageFile( img )
; ;
;- INCLUDEs
XIncludeFile #ide_path + "widgets.pbi"
; XIncludeFile "C:\Users\user\Downloads\Compressed\widget-edb230c0138ebd33deacbac9440577a00b5affa7\widget-edb230c0138ebd33deacbac9440577a00b5affa7\widgets.pbi"
; Procedure.i GetFontColor( *this.structures::_s_WIDGET )
;    ProcedureReturn widget::GetColor( *this, constants::#__FrontColor )
; EndProcedure
; Procedure   SetFontColor( *this.structures::_s_WIDGET, color.i )
;    ProcedureReturn widget::SetColor( *this, constants::#__FrontColor, color )
; EndProcedure
; 
; 
; XIncludeFile #ide_path + "include/newcreate/anchorbox.pbi"
; XIncludeFile #ide_path + "IDE/include/helper/imageeditor.pbi"
; CompilerIf #PB_Compiler_IsMainFile
;    XIncludeFile #ide_path + "IDE/code.pbi"
; CompilerEndIf

;
;- USES
UseWidgets( )
UsePNGImageDecoder( )
; test_docursor = 1
; test_changecursor = 1
; test_setcursor = 1
; test_delete = 1
; test_focus_draw = 1
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
                         *row\y,                                        ; + *second\scroll_y( ), 
                         #PB_Ignore, 
                         *row\height, 0 )
               Default
                  Resize(*this,
                         *row\x,
                         *row\y + *second\scroll_y( ),
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
            
            ; SetActive( *this )
            
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
   
   ; Debug ""+widget::ClassFromEvent(__event) +" "+ widget::GetClass( *g) +" "+ GetData(*g)
   
   ;    If __event = #__event_Change
   ;       Debug 4444
   ;       If GetData(*g) = #_ei_leftclick
   ;          Debug 333
   ;       EndIf
   ;    EndIf
   If Not a_focused( )
      ProcedureReturn 0
   EndIf
   
   Select __event
      Case #__event_Down
         GetActive( )\gadget = *g
         
      Case #__event_LeftClick
         Select GetData(*g)
            Case #_pi_IMAGE
               
            Case #_pi_FONT
               
            Case #_pi_COLOR
               
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
               
            Case #__type_ComboBox
               
         EndSelect
         
      Case #__event_MouseWheel
         If MouseDirection( ) > 0
            If *g\scroll\v
               Debug "Properties_Button_event_MouseWheel "+*g\class
               SetState(*g\scroll\v, GetState( *g\scroll\v ) - __data )
            EndIf
         EndIf
         
      Case #__event_CursorChange
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
              ; *this = AnchorBox::Create( *parent, 0,0,0,20 )
               
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
               If *this\PopupCombo( )
                  *this\PopupCombo( )\mode\Checkboxes = 1
                  *this\PopupCombo( )\mode\optionboxes = 1
                  ;    Flag( *this\PopupCombo( ), #__flag_CheckBoxes|#__flag_OptionBoxes, 1 )
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
               ;                ColorType = MakeConstants("#PB_Gadget_" + GetItemText( *this, 0))
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
      
     
;                      SetItemFont( *first, item, font_properties)
;                      SetItemFont( *second, item, font_properties)
      
      SetItemColor( *first, item, #PB_Gadget_FrontColor, fcolor_properties, 0, #PB_All )
      SetItemColor( *second, item, #PB_Gadget_FrontColor, fcolor_properties, 0, #PB_All )
      
      SetItemColor( *first, item, #__FrameColor,  $FF00FFFF, 0, #PB_All)
      SetItemColor( *second, item, #__FrameColor,  $FF00FFFF, 0, #PB_All)   
      
      SetItemColor( *first, item, #PB_Gadget_BackColor,  $FF00FFFF, 0, #PB_All)
      SetItemColor( *second, item, #PB_Gadget_BackColor,  $FF00FFFF, 0, #PB_All)   
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
         
      Case #__event_Up
         ;SetActive( Entered( ) )
         
      Case #__event_CursorChange
         ProcedureReturn 0
         
   EndSelect
   
   ProcedureReturn #PB_Ignore
EndProcedure

Procedure   Properties_Create( X,Y,Width,Height, flag=0 )
   Protected position = 90
   Protected tflag.q = #__flag_BorderLess|#PB_Tree_NoLines|#__flag_Transparent;|#__flag_gridlines
   Protected *first._s_WIDGET = Tree(0,0,0,0, tflag)
   Protected *second._s_WIDGET = Tree(0,0,0,0, tflag|#PB_Tree_NoButtons)
   ;    *first\padding\x = 10
   ;    *second\padding\x = 10
   Protected *g._s_WIDGET
   *g = *first
   ;*g\padding\x = DPIScaled(20)
    *g\fs[1] = DPIScaled(20)
    ;Resize(*g, #PB_Ignore, #PB_Ignore, 100, #PB_Ignore )
    SetColor(*g, #PB_Gadget_BackColor,  $FF00FFFF)
    
    *g = *second
   ;*g\padding\x = DPIScaled(20)
    ;*g\fs[1] = DPIScaled(20)
    ;Resize(*g, #PB_Ignore, #PB_Ignore, 100, #PB_Ignore )
    SetColor(*g, #PB_Gadget_BackColor,  $FF00FFFF)
    
   Protected *splitter._s_WIDGET = Splitter(X,Y,Width,Height, *first,*second, flag|#__flag_Transparent|#PB_Splitter_Vertical );|#PB_Splitter_FirstFixed )
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
   
   ; CloseList( )
   
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
  
EndProcedure


;-
Procedure   ide_open( X=50,Y=75,Width=900,Height=700 )
   Define flag = #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget | #PB_Window_Invisible
   ide_root = Open( 1, X,Y,Width,Height, "ide", flag ) 
   ide_window = GetCanvasWindow( ide_root )
   ide_g_canvas = GetCanvasGadget( ide_root )
   
 
   ide_inspector_PROPERTIES = Properties_Create( 0,0,0,0, #__flag_autosize | #__flag_gridlines | #__flag_Borderless ) : SetClass(ide_inspector_PROPERTIES, "ide_inspector_PROPERTIES" )
   If ide_inspector_PROPERTIES
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_group_COMMON, "COMMON" )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_ID,             "#ID",      #__Type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_class,          "Class",    #__Type_String, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_text,           "Text",     #__Type_String, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_IMAGE,          "Image",    #__Type_Button, 1 )
      ;
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_group_LAYOUT, "LAYOUT" )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_align,          "Align"+Chr(10)+"LEFT|TOP", #__Type_Button, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_x,              "X",        #__Type_Spin, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_y,              "Y",        #__Type_Spin, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_width,          "Width",    #__Type_Spin, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_height,         "Height",   #__Type_Spin, 1 )
      ;
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_group_VIEW,   "VIEW" )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_cursor,         "Cursor",   #__Type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_hide,           "Hide",     #__Type_ComboBox, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_disable,        "Disable",  #__Type_ComboBox, 1 )
      ;
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_flag,          "Flag",      #__Type_ComboBox, 1 )
      ;
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_FONT,           "Font",     #__Type_Button, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_fontsize,       "size",     #__Type_Spin, 2 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_fontstyle,      "style",    #__Type_ComboBox, 2 )
      ;
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_COLOR,           "Color",   #__Type_Button, 1 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_colortype,       "type",    #__Type_ComboBox, 2 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_colorstate,      "state",    #__Type_ComboBox, 2 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_coloralpha,      "alpha",   #__Type_Spin, 2 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_colorblue,       "blue",    #__Type_Spin, 2 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_colorgreen,      "green",   #__Type_Spin, 2 )
      Properties_AddItem( ide_inspector_PROPERTIES, #_pi_colorred,        "red",     #__Type_Spin, 2 )
   EndIf
   
  
   ;Bind( #PB_All, @ide_events( ) )
   ProcedureReturn ide_window
EndProcedure

;-
CompilerIf #PB_Compiler_IsMainFile 
   Define event
   ide_open( )
  
   HideWindow( ide_window, #False )
   
   
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
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 936
; FirstLine = 868
; Folding = -----------4------
; EnableXP
; DPIAware