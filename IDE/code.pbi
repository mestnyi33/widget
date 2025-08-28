;- GLOBALs
Global line_break1

Declare$  Generate_CodeCloseList( *g, Space$ )

;
;- INCLUDEs
CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "ide.pb"
CompilerEndIf
XIncludeFile "include/code/parser.pbi"
XIncludeFile "include/code/generate.pbi"

;
;- USES
UseWidgets( )


Global parentlevel 
Global codeindent = 3
;
;- PUBLICs
;
;-
Procedure   AddFont( key$, name$, size, style )
   Protected font$, id$
   ; Debug "AddFont key ["+key$+"]"
   ;
   If key$ = "-1" 
      font$ = "-1"
      key$ = "-1"
   Else
      Protected font = LoadFont( #PB_Any, name$, size, style )
      
      If IsFont( font )
         key$ = Trim( key$ )
         
         Define style$ = MakeConstantsString( "Font", style )
         style$ = RemoveString( style$, "#PB_Font_" )
         style$ = ReplaceString( style$, " | ", "_" )
         If style$
            id$ = UCase("Font_"+ReplaceString(name$, " ", "_" )+"_"+size+"_"+style$)
         Else
            id$ = UCase("Font_"+ReplaceString(name$, " ", "_" )+"_"+size)
         EndIf
         If enum_font
            id$ = "#" + id$
         EndIf
      EndIf
      font$ = Str(font)
   EndIf
   ;
   If AddMapElement( fonts( ), font$ )
      fonts( )\key$ = key$ 
      fonts( )\font = font 
      fonts( )\id$ = id$
      fonts( )\name = name$
      fonts( )\size = size
      fonts( )\style = style
   EndIf
   ;
   ProcedureReturn font
EndProcedure

Procedure.s GetFontKey( font )
   If IsFont( font )
      If FindMapElement( fonts( ), Str(font) )
         If fonts( )\key$
            ProcedureReturn fonts( )\id$
         EndIf
      EndIf
   EndIf
EndProcedure

Procedure   GetFontFromKey( key$ )
   key$ = Trim( key$ )
   key$ = Trim( key$, "(" )
   key$ = Trim( key$, ")" )
   key$ = Trim( key$ )
      
   ForEach fonts( )
      If LCase(fonts( )\key$) = LCase(key$)
         ProcedureReturn fonts( )\font
      EndIf
   Next
EndProcedure

Procedure   SetFontName( font.i, name.s )
   ProcedureReturn ChangeFont( font, name, GetFontSize( font ), GetFontStyle( font ) )
EndProcedure

Procedure   SetFontSize( font.i, size.a )
   ProcedureReturn ChangeFont( font, GetFontName( font ), size, GetFontStyle( font ) )
EndProcedure

Procedure   SetFontStyle( font.i, style.q )
   ProcedureReturn ChangeFont( font, GetFontName( font ), GetFontSize( font ), style )
EndProcedure

Procedure.s GetFontName( font.i )
   If FindMapElement( fonts( ), Str(font) )
      ProcedureReturn fonts( )\name
   EndIf
EndProcedure

Procedure.a GetFontSize( font.i )
   If FindMapElement( fonts( ), Str(font) )
      ProcedureReturn fonts( )\size
   EndIf
EndProcedure

Procedure.q GetFontStyle( font.i )
   If FindMapElement( fonts( ), Str(font) )
      ProcedureReturn fonts( )\style
   EndIf
EndProcedure

Procedure   ChangeFont( font, name.s, size.a, style.q )
   Protected key$
   If IsFont( font )
      If FindMapElement( fonts( ), Str(font))
         StopDraw( )
         FreeFont( font )
         key$ = fonts( )\key$
         DeleteMapElement( fonts( ), Str(font))
         StartDraw( root( ))
      EndIf
   EndIf
   If key$
      ProcedureReturn AddFont( key$, name, size, style )
   EndIf
EndProcedure  

Procedure   ChangeFontSize( *this._s_WIDGET, size )
   Protected font = GetFont( *this )
   If IsFont( font )
      ProcedureReturn SetFont( *this, ChangeFont( font, GetFontName( font ), size, GetFontStyle( font ) ) )
   EndIf
EndProcedure

Procedure   ChangeFontStyle( *this._s_WIDGET, style.q )
   Protected font = GetFont( *this )
   If IsFont( font )
      ProcedureReturn SetFont( *this, ChangeFont( font, GetFontName( font ), GetFontSize( font ), style ) )
   EndIf
EndProcedure

;-
Procedure   AddImages( Image )
   Protected result = IsImage( Image )
   If result
      If AddElement( images( ) )
         images( )\image = Image 
      EndIf
   EndIf
   ProcedureReturn result
EndProcedure

Procedure   AddImage( key$, file$, flags=0 )
   Protected Image
   If CountString(file$, "+" )
      Protected load$ = file$
      file$ = RemoveString( file$, " " )
      file$ = RemoveString( file$, Chr('"') )
      file$ = MakeStringConstants( StringField( file$, 1, "+" )) + StringField( file$, 2, "+" )
      ;     file$ = MakeStringConstants( StringField( file$, 1, "+" )) + Trim( Trim( StringField( file$, 2, "+" )), Chr('"') )
      Image = LoadImage( #PB_Any, file$ )
      file$ = load$ + Chr('"')
   Else
      Image = LoadImage( #PB_Any, file$ )
      file$ = Chr('"') + file$ + Chr('"')
   EndIf
   
;    If FindString( file$, "#PB_Compiler_Home" )
;       file$ = Trim( Trim( StringField( file$, 2, "+" )), Chr('"') )
;       Image = LoadImage( #PB_Any, #PB_Compiler_Home + file$ )
;       file$ = "#PB_Compiler_Home + " + Chr('"') + file$ + Chr('"')
;    Else
;       Image = LoadImage( #PB_Any, file$ )
;       file$ = Chr('"') + file$ + Chr('"')
;    EndIf
   ;
   If IsImage( Image )
;       CompilerIf #PB_Compiler_DPIAware
;          If ImageWidth(Image) = 16
;             ResizeImage(Image, DesktopScaledX(ImageWidth(Image)), DesktopScaledY(ImageHeight(Image)), #PB_Image_Raw )
;          EndIf
;       CompilerEndIf
      
      key$ = Trim( key$ )
      key$ = Trim( key$, "(" )
      key$ = Trim( key$, ")" )
      key$ = Trim( key$ )
      ; Debug "AddImageKey "+ key$
      
      ;Define id$ = UCase( GetFilePart( file$, #PB_FileSystem_NoExtension ))+"_IMAGE"
      Define id$ = "IMAGE_"+UCase( GetFilePart( file$, #PB_FileSystem_NoExtension )+"_"+GetExtensionPart( file$ ))
      If key$ = ""
         key$ = id$ ; Str(Image) ; 
         ;Debug key$
      EndIf
      If enum_image
         id$ = "#" + id$
      EndIf
      ;
      If AddImages( Image )
         images( )\id$ = id$ 
         images( )\key$ = key$ 
         images( )\file$ = file$
      EndIf
   EndIf
   ;
   ProcedureReturn Image
EndProcedure

Procedure   ChangeImage( img )
   If IsImage( img )
      ForEach images( )
         If images( )\key$
            If images( )\image = img
               img = CopyImage( img, #PB_Any )
               images( )\image = img
               ProcedureReturn img
            EndIf
         EndIf
      Next
   EndIf
EndProcedure

Procedure$  GetImageKey( img )
   If IsImage( img )
      ForEach images( )
         If images( )\key$
            If images( )\image = img
               ProcedureReturn images( )\id$
            EndIf
         EndIf
      Next
   EndIf
EndProcedure

Procedure$  GetImageFile( img )
   If IsImage( img )
      ForEach images( )
         If images( )\key$
            If images( )\image = img
               ProcedureReturn images( )\file$
            EndIf
         EndIf
      Next
   EndIf
EndProcedure

Procedure   GetImageFromKey( key$ )
   key$ = Trim( key$ )
   key$ = Trim( key$, "(" )
   key$ = Trim( key$, ")" )
   key$ = Trim( key$ )
   ; Debug "GetImageKey "+ key$
   ForEach images( )
      If LCase(images( )\key$) = LCase(key$)
         ProcedureReturn images( )\image
      EndIf
   Next
EndProcedure

;-
Procedure.s GetEventsString( Element )
   
   ProcedureReturn Trim( EventsString( Str( Element ) ), "|" )
   
EndProcedure

Procedure SetEventsString( Element, Events$ )
   
   If Not FindMapElement( EventsString( ), Str( Element ) )
      AddMapElement( EventsString( ), Str( Element ) )
   EndIf
   
   If Events$
      If Not FindString( EventsString( ), LCase( Events$ ), - 1, #PB_String_NoCase )
         EventsString( ) + "|" + Events$
      EndIf
   Else
      EventsString( ) = ""
   EndIf
   
EndProcedure

;-
Procedure$  GetLine( text$, len, caret )
   Protected i, chr$, start, stop 
   
   For i = caret To 0 Step - 1
      chr$ = Mid( text$, i, 1 )
      If chr$ = #LF$ 
         start = i + 1
         Break
      EndIf
   Next i
   
   For i = caret + 1 To len 
      chr$ = Mid( text$, i, 1 )
      If chr$ = #LF$
         stop = i - start
         Break
      EndIf
   Next i
   
   If stop = 0
      ProcedureReturn #LF$
   Else
      ; Debug ""+ start +" "+ stop
      ProcedureReturn Mid( text$, start, stop )
   EndIf
EndProcedure

Procedure$  GetQuote( text$, len, caret ) ; Ok
   Protected i, chr$, start, stop 
   
   For i = caret To 0 Step - 1
      chr$ = Mid( text$, i, 1 )
      If chr$ = ~"\"" 
         start = i
         
         For i = caret + 1 To len 
            chr$ = Mid( text$, i, 1 )
            If chr$ = ~"\""
               stop = i - start + 1
               Break 2
            EndIf
         Next i
         
         Break
      EndIf
   Next i
   
   If stop 
      ; Debug #PB_Compiler_Procedure +" ["+ start +" "+ stop +"]"
      ProcedureReturn Mid( text$, start, stop )
   EndIf
EndProcedure

Procedure$  GetWord( text$, len, caret ) ; Ok
   Protected i, chr$, start = 0, stop = len
   
   chr$ = GetQuote( text$, len, caret ) 
   If chr$
      ProcedureReturn chr$
   EndIf
   
   For i = caret To 0 Step - 1
      chr$ = Mid( text$, i, 1 )
      If chr$ = " " Or 
         chr$ = "(" Or 
         chr$ = "[" Or 
         chr$ = "{" Or 
         chr$ = ")" Or 
         chr$ = "]" Or 
         chr$ = "}" Or 
         chr$ = "=" Or 
         chr$ = "'" Or ; chr$ = ~"\"" Or 
         chr$ = "+" Or 
chr$ = "-" Or 
chr$ = "*" Or 
chr$ = "/" Or 
chr$ = "." Or 
chr$ = ","
         start = i + 1
         Break
      EndIf
   Next i
   
   For i = caret + 1 To len 
      chr$ = Mid( text$, i, 1 )
      If chr$ = " " Or 
         chr$ = ")" Or 
         chr$ = "]" Or 
         chr$ = "}" Or 
         chr$ = "(" Or 
         chr$ = "[" Or 
         chr$ = "{" Or 
         chr$ = "=" Or 
         chr$ = "'" Or ; chr$ = ~"\"" Or
         chr$ = "+" Or 
chr$ = "-" Or 
chr$ = "*" Or 
chr$ = "/" Or 
chr$ = "." Or 
chr$ = "," 
         stop = i - start 
         Break
      EndIf
   Next i
   
   If stop
      ; Debug #PB_Compiler_Procedure +" ["+ start +" "+ stop +"]"
      ProcedureReturn Mid( text$, start, stop )
   EndIf
EndProcedure

Procedure$  FindFunctions( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
   Protected i, chr$, start, stop, spacecount
   
   For i = len To 0 Step - 1
      chr$ =  Mid( string$, i, 1 )
      If chr$ = " "
         spacecount + 1
      Else
         Break
      EndIf
   Next i
   
   For i = len - spacecount To 0 Step - 1
      chr$ =  Mid( string$, i, 1 )
      If chr$ = " "
         start = i + 1
         If *start
            *start\i = start
         EndIf
         stop = len - i - spacecount
         If *stop
            *stop\i = stop
         EndIf
         ProcedureReturn Mid( string$, start, stop )
         Break
      EndIf
   Next i
   
EndProcedure

Procedure$  FindArguments( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
   Protected i, chr$, start, stop 
   
   For i = 0 To len
      chr$ = Mid( string$, i, 1 )
      If chr$ = "(" 
         start = i + 1
         For i = len To start Step - 1
            chr$ = Mid( string$, i, 1 )
            If chr$ = ")" 
               stop = i - start ; + 1
               If *start
                  *start\i = start
               EndIf
               If *stop
                  *stop\i = stop
               EndIf
               If Not stop
                  ProcedureReturn " "
               Else
                  ProcedureReturn Mid( string$, start, stop )
               EndIf
               Break
            EndIf
         Next i
         
         Break
      EndIf
   Next i
EndProcedure

Procedure$  GetArgLine( text$, len, caret, mode.a = 0 ) 
   Protected i, chr$, start = - 1, stop 
   
   For i = caret To 0 Step - 1
      chr$ = Mid( text$, i, 1 )
      If chr$ = "(" 
         start = i
         Break
      EndIf
   Next i
   
   For i = caret + 1 To len 
      chr$ = Mid( text$, i, 1 )
      If chr$ = ")"
         stop = i - start + 1
         Break
      EndIf
   Next i
   
   If mode
      If start = - 1 
         If stop 
            For i = len To 0 Step - 1
               chr$ = Mid( text$, i, 1 )
               If chr$ = "(" 
                  start = i
                  stop - start - 1
                  Break
               EndIf
            Next i
         EndIf
      EndIf  
   EndIf
   
   If start = - 1 Or stop = 0
      ProcedureReturn ""
   Else
      ; Debug #PB_Compiler_Procedure +" ["+ start +" "+ stop +"]"
      ProcedureReturn Mid( text$, start, stop )
   EndIf
EndProcedure

Procedure   GetArgIndex( text$, len, caret, mode.a = 0 ) 
   Protected i, chr$, start = - 1, stop 
   
   For i = caret To 0 Step - 1
      chr$ = Mid( text$, i, 1 )
      If chr$ = "(" 
         start = i
         Break
      EndIf
   Next i
   
   For i = caret + 1 To len 
      chr$ = Mid( text$, i, 1 )
      If chr$ = ")"
         stop = i - start + 1
         Break
      EndIf
   Next i
   
   If mode
      If start = - 1 
         If stop 
            For i = len To 0 Step - 1
               chr$ = Mid( text$, i, 1 )
               If chr$ = "(" 
                  start = i
                  stop - start - 1
                  Break
               EndIf
            Next i
         EndIf
      EndIf  
   EndIf
   
   If start = - 1 Or stop = 0
      ProcedureReturn 0
   Else
      ProcedureReturn CountString( Left( Mid( text$, start, stop ), caret - start ), "," ) + 1
   EndIf
EndProcedure

;-
Procedure NumericString( string$ )
   Select Asc( string$ )
      Case '0' To '9'
         ProcedureReturn #True
   EndSelect
EndProcedure

;-
Procedure   MakeID( class$, *rootParent._s_WIDGET )
   If FindMapElement( GetObject( ), class$ )
      class$ = GetObject( )
   EndIf
   
   Protected result
   
   If StartEnum( *rootParent )
      If Trim(UCase(GetClass( widget( ))), "#") = Trim(UCase(class$), "#")
         result = widget( )
         Break
      EndIf
      StopEnum( )
   EndIf
   
   
   If result
      a_set( result )
   EndIf      
   ProcedureReturn result
EndProcedure

Procedure$  MakeCloseList( *g._s_WIDGET, *before = 0 )
   Protected result$
   ;
   While Not is_window_(*g) 
      ;; Panel; Container; ScrollArea
      ;If IsContainer( *g ) > 2
      If *g\parent And *g\parent\type = #__type_Splitter
         
      Else
         result$ + Generate_CodeCloseList( *g, Space(((Level(*g) ) - parentlevel) * codeindent) )
      EndIf
      ;EndIf 
      ;
      If *before = *g
         ; result$ + #LF$
         Break
      EndIf
      *g = *g\parent
   Wend
   ;
   ProcedureReturn result$
EndProcedure

;-
Procedure$ MakeCoordinate( str$, findtext$ )
   Define val, i, count = CountString( str$, "+" )
   If count
      For i = 0 To count
         val + Val( StringField( str$, i+1, "+" ))
      Next
      str$ = Str(val)
   Else
      count = CountString( str$, "-" )
      If count
         For i = 0 To count
            If val
               val - Val( StringField( str$, i+1, "-" ))
            Else
               val = Val( StringField( str$, i+1, "-" ))
            EndIf
         Next
         str$ = Str(val)
      Else
         If Not NumericString( str$ )  
            str$ = StringField( StringField( Mid( findtext$, FindString( findtext$, str$ ) ), 1, "," ), 2, "=" )
         EndIf
      EndIf
   EndIf
   ProcedureReturn str$
EndProcedure

Procedure$  MakeArgString( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
   Protected i, ch, chr$, start, stop 
   Static ii
   
   For i = 0 To len
      chr$ = Mid( string$, i, 1 )
      If chr$ = "(" 
         start = i + 1
         
         For i = len To start Step - 1
            chr$ = Mid( string$, i, 1 )
            
            If ch
               If chr$ = Chr('"')
                  ch = 0
               EndIf
               Continue
            ElseIf chr$ = Chr('"')
               ch = 1
            EndIf
            
            If chr$ = ")" 
               stop = i - start
               
               For i = start To len
                  chr$ = Mid( Mid( string$, start, stop ), i, 1 )
                  
                  If ch
                     If chr$ = Chr('"')
                        ch = 0
                     EndIf
                     Continue
                  ElseIf chr$ = Chr('"')
                     ch = 1
                  EndIf
                  
                  If chr$ = ")" 
                     stop = i - Bool(FindString( string$, ":" ))
                     Break 
                  EndIf
               Next i
               
               If *start
                  *start\i = start
               EndIf
               If *stop
                  *stop\i = stop
               EndIf
               If Not stop
                  ProcedureReturn " "
               Else
                  ; Debug Mid( string$, start, stop )
                  ProcedureReturn Mid( string$, start, stop )
               EndIf 
               Break
            EndIf
            
         Next i
         
         Break
      EndIf
   Next i
EndProcedure

Procedure$  MakeFuncString( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
   Protected i, result$
   Protected func$ = StringField( string$, 1, "(" )
   Protected pos = FindString( func$, "=" )
   
   len = Len(func$) - pos 
   pos + 1
   
   ; Debug "---- "+pos+" "+len
   
   result$ = Trim( Mid( string$, pos, len ))
   For i = len To 1 Step - 1
      If Mid( result$, i, 1 ) = " " 
         result$ = Mid( result$, i, len )
         Break
      EndIf
   Next i
   result$ = Trim(result$)
   If *start
      *start\i = FindString( string$, result$ ) 
   EndIf
   If *stop
      *stop\i = Len(result$)
   EndIf
   
   ProcedureReturn result$
EndProcedure

Procedure$  MakeIDString( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
   Protected i, result$, pos = FindString( string$, "=" )
   
   If pos
      len = FindString( string$, "(" )
      If len > pos
         len = pos - 1
      EndIf
      pos = 1
      If CountString( Trim(String$), " " )
         For i = 0 To len
            If Mid( String$, i, 1 ) = " " 
               pos = i
               len - i
               Break
            EndIf
         Next i
      EndIf
      If *start
         *start\i = pos
      EndIf
      If *stop
         *stop\i = len
      EndIf
      result$ = Mid( string$, pos, len )
   Else
      If FindString( string$, "Gadget" ) Or 
         FindString( string$, "OpenWindow" ) Or 
         FindString( string$, "Open" )
         ;
         pos = FindString( string$, "," )
         If pos
            len = pos
            pos = FindString( string$, "(" ) + 1
            len - pos
            If *start
               *start\i = pos
            EndIf
            If *stop
               *stop\i = len
            EndIf
            result$ = Mid( string$, pos, len )
         EndIf
      EndIf
   EndIf
   
   ProcedureReturn result$
EndProcedure

Procedure MakeVal( string$ )
   Protected result, len = Len( string$ ) 
   
   String$ = Trim( String$ )
   
   Define arg$ = MakeArgString( string$, len )
   Define func$ = MakeFuncString( string$, len )
   Debug "[MakeVal]"+func$ 
   
   Select Trim( func$ )
      Case "RGB"
         result = RGB( Val(Trim(StringField( arg$, 1, ","))), 
                       Val(Trim(StringField( arg$, 2, ","))),
                       Val(Trim(StringField( arg$, 3, ","))) )
      Case "RGBA"
         result = RGBA( Val(Trim(StringField( arg$, 1, ","))), 
                        Val(Trim(StringField( arg$, 2, ","))),
                        Val(Trim(StringField( arg$, 3, ","))),
                        Val(Trim(StringField( arg$, 4, ","))) )
      Default ; (1...9)
         String$ = Trim( String$, "(" )
         String$ = Trim( String$, ")" )
         result = Val( String$ )
         
   EndSelect
   
   ProcedureReturn result
EndProcedure

Procedure MakeFunc( string$, Index )
   Protected result, result$
   result$ = StringField(StringField(string$, 1, "("), Index, ",") +"("+ StringField(string$, 2, "(")
   Debug "[MakeFunc]"+result$
   result = MakeVal( result$ )
   
   ProcedureReturn result
EndProcedure


Procedure   MakeLine( *mdi, string$, findtext$ )
   Static *parent, *parentWindow
   Protected result
   Protected text$, flag$, type$, id$, x$, y$, width$, height$, param1$, param2$, param3$, param4$
   Protected param1, param2, param3, flags.q
   Protected *g._s_WIDGET
   
   
   Define string_len = Len( String$ )
   Define arg_start, arg_stop, arg$ = MakeArgString( string$, string_len, @arg_start, @arg_stop ) 
   If arg$
      ; Debug arg$ +" "+ arg_start
      Define str$ = Mid( String$, 1, arg_start - 1 ) ; - 1  исключаем открывающую скобку '('
      
      If FindString( str$, ";" )
         ProcedureReturn 0
      EndIf
      
      LastElement( *parser\Line( ))
      If AddElement( *parser\Line( ))
         *parser\Line( ) = AllocateStructure( _s_LINE )
         
         With *parser\Line( )
            \arg$ = arg$
            \string = string$
            \func$ = MakeFuncString( string$, string_len )
            ;\func$ = MakeFuncString( str$, Len(str$) )
            
            
            ;
            \pos = FindString( str$, "Declare" )
            If \pos
               \type$ = "Declare"
               ProcedureReturn 
            EndIf
            
            \pos = FindString( str$, "Procedure" )
            If \pos
               \type$ = "Procedure"
               ProcedureReturn 
            EndIf
            
            \pos = FindString( str$, "Select" )
            If \pos
               \type$ = "Select"
               ProcedureReturn 
            EndIf
            
            \pos = FindString( str$, "While" )
            If \pos
               \type$ = "While"
               ProcedureReturn 
            EndIf
            
            \pos = FindString( str$, "Repeat" )
            If \pos
               \type$ = "Repeat"
               ProcedureReturn 
            EndIf
            
            \pos = FindString( str$, "If" )
            If \pos
               \type$ = "If"
            EndIf
            
            ;\\
            If FindString( \func$, "OpenWindow" )
               \func$ = ReplaceString( \func$, "OpenWindow", "Window")
               *parent = *mdi
            ElseIf \func$ = "Open"
               \func$ = ReplaceString( \func$, "Open", "Window")
               *parent = *mdi
               id$ = "WINDOW_MAIN"
            ElseIf FindString( \func$, "Gadget" )
               \func$ = ReplaceString( \func$, "Gadget", "")
;             ElseIf FindString( \func$, "Window" )
;                \func$ = ReplaceString( \func$, "Window", "")
            Else
               Select \func$
                  Case "Window"
                     ;\func$ = "Form"
                     arg$ = ", " + arg$ 
                     
                  Case "Button","String","Text","CheckBox",
                       "Option","ListView","Frame","ComboBox",
                       "Image","HyperLink","Container","ListIcon",
                       "IPAddress","ProgressBar","ScrollBar","ScrollArea",
                       "TrackBar","Web","ButtonImage","Calendar",
                       "Date","Editor","ExplorerList","ExplorerTree",
                       "ExplorerCombo","Spin","Tree","Panel",
                       "Splitter","MDI","Scintilla","Shortcut","Canvas"
                     ;
                     arg$ = ", " + arg$ 
               EndSelect
            EndIf
            
;                         Debug "func[" + \func$ +"]" 
;                         Debug " arg["+ arg$ +"]"
            
            ;\\
            Select \func$
               Case "Window",
                    "Button","String","Text","CheckBox",
                    "Option","ListView","Frame","ComboBox",
                    "Image","HyperLink","Container","ListIcon",
                    "IPAddress","ProgressBar","ScrollBar","ScrollArea",
                    "TrackBar","Web","ButtonImage","Calendar",
                    "Date","Editor","ExplorerList","ExplorerTree",
                    "ExplorerCombo","Spin","Tree","Panel",
                    "Splitter","MDI","Scintilla","Shortcut","Canvas"
                  
                  ; identifiers
                  If FindString( str$, "=" )
                     id$ = Trim( StringField( str$, 1, "=" ))
                     If CountString( id$, " " )
                        id$ = Trim( StringField( str$, 2, " " ))
                     EndIf
                  EndIf
                  ;
                  id$ = Trim( id$, "#" )
                  If enum_object
                     id$ = "#" + id$
                     pb_object$ = "PB"
                  EndIf
                  id$ = UCase( id$ )
                  
                  ; coordinate
                  x$      = MakeCoordinate( Trim(StringField( arg$, 2, ",")), findtext$ )
                  y$      = MakeCoordinate( Trim(StringField( arg$, 3, ",")), findtext$ )
                  width$  = MakeCoordinate( Trim(StringField( arg$, 4, ",")), findtext$ )
                  height$ = MakeCoordinate( Trim(StringField( arg$, 5, ",")), findtext$ )
                  
                  ;
                  param1$ = Trim(StringField( arg$, 6, ","))
                  param2$ = Trim(StringField( arg$, 7, ","))
                  param3$ = Trim(StringField( arg$, 8, ",")) 
                  param4$ = Trim(StringField( arg$, 9, ","))
                  
                  ; text
                  Select \func$
                     Case "Window",
                          "Web", "Frame",
                          "Text", "String", "Button", "CheckBox",
                          "Option", "HyperLink", "ListIcon", "Date",
                          "ExplorerList", "ExplorerTree", "ExplorerCombo"
                        Debug arg$
                        If FindString( param1$, Chr('"'))
                           text$ = Trim( param1$, Chr('"'))
                        Else
                           text$ = Trim(StringField( StringField( Mid( findtext$, FindString( findtext$, param1$ ) ), 1, ")" ), 2, "=" ))
                        EndIf
                        If text$
                           ;If FindString( text$, Chr('"'))
                           text$ = Trim( text$, Chr('"'))
                           ;EndIf
                        EndIf
                        
                  EndSelect
                  
                  ; param1
                  Select \func$
                     Case "Track", "Progress", "Scroll", "ScrollArea",
                          "TrackBar","ProgressBar", "ScrollBar"
                        param1 = Val( param1$ )
                        
                     Case "Splitter" 
                        param1 = MakeID( UCase(Param1$), *mdi )
                        
                     Case "ListIcon"
                        param1 = Val( param2$ ) ; *this\columns( )\width
                        
                     Case "Image"
                        param1 = GetImageFromKey( param1$ )
                        
                  EndSelect
                  
                  ; param2
                  Select \func$
                     Case "Track", "Progress", "Scroll", "TrackBar", 
                          "ProgressBar", "ScrollBar", "ScrollArea"
                        param2 = Val( param2$ )
                        
                     Case "Splitter" 
                        param2 = MakeID( UCase(Param2$), *mdi )
                        
                  EndSelect
                  
                  ; param3
                  Select \func$
                     Case "Scroll", "ScrollBar", "ScrollArea"
                        param3 = Val( param3$ )
                  EndSelect
                  
                  ; param4
                  Select \func$
                     Case "Date", "Calendar", "Container", 
                          "Tree", "ListView", "ComboBox", "Editor"
                        flag$ = param1$
                     Case "Window",
                          "Web", "Frame",
                          "Text", "String", "Button", "CheckBox", 
                          "ExplorerCombo", "ExplorerList", "ExplorerTree", "Image", "ButtonImage"
                        flag$ = param2$
                        
                     Case "Track", "Progress", "TrackBar", "ProgressBar", 
                          "Spin", "OpenGL", "Splitter", "MDI", "Canvas"
                        flag$ = param3$
                        
                     Case "Scroll", "ScrollBar", "ScrollArea", "HyperLink", "ListIcon"  
                        flag$ = param4$
                        
                  EndSelect
                  
                  ; flag
                  If flag$
                     flags = MakeConstants(Flag$)
                  EndIf
                  
                  ; window parent ID
                  If \func$ = "Window" 
                     If param3$
                        *Parent = MakeID( param3$, *mdi )
                     EndIf
                     
                     If *parentWindow
                        x$ = Str(Val(x$) + X(*parentWindow, #__c_container) + ( X(*parentWindow, #__c_inner) - X(*parentWindow, #__c_frame)))
                        y$ = Str(Val(y$) + Y(*parentWindow, #__c_container) + ( Y(*parentWindow, #__c_inner) - Y(*parentWindow, #__c_frame)))
                        *Parent = *parentWindow
                     Else
                        If x$ = "0"
                           x$ = Str(10)
                        EndIf
                        If y$ = "0"
                           y$ = Str(10)
                        EndIf
                     EndIf
                  EndIf
                  
                  ;Debug "[Make]"+\func$ +" "+ Bool(\func$ = "Window") +" "+ *parent ;arg$
                  *g = new_widget_create( *parent, \func$, Val(x$), Val(y$), Val(width$), Val(height$), text$, param1, param2, param3, flags )
                 
                  If *g
                     If id$ = "WINDOW_MAIN"
                        *parentWindow = *g
                     EndIf
                     If id$
                        SetClass( *g, id$ )
                     EndIf
                     
                     SetText( *g, text$ )
                     ; 
                     new_widget_line_add( *g )
                     ;
                     If IsContainer( *g ) > 0
                        *Parent = *g
                     EndIf
                     result = 1
                  EndIf
                  
               Default
                  ; identifiers
                  If FindString( str$, "=" )
                     id$ = Trim( StringField( str$, 1, "=" ))
                     If CountString( id$, " " )
                        id$ = Trim( StringField( str$, 2, " " ))
                     EndIf
                  Else
                     id$ = Trim( StringField( arg$, 1, "," ))
                  EndIf
                  
                  ;
                  param1$ = Trim( StringField( arg$, 2, "," ))
                  param2$ = Trim( StringField( arg$, 3, "," ))
                  param3$ = Trim( StringField( arg$, 4, "," ))
                  param4$ = Trim( StringField( arg$, 5, "," ))
                  
                  ;\\
                  Select \func$
                     Case "CloseList"
                        If *parent
                           *Parent = GetParent( *Parent )
                        EndIf
                        
                     Case "LoadFont"
                        text$ = Trim( param1$, Chr('"'))
                        param2 = Val( param2$ )
                        param3 = MakeConstants( param3$ )
                        
                        AddFont( id$, text$, param2, param3 )
                        
                     Case "SetFont"
                        *g = MakeID( id$, *mdi ) 
                        If *g
                           SetFont( *g, GetFontFromKey( param1$ ))
                        EndIf
                        
                     Case "LoadImage"
                        text$ = Trim( param1$, Chr('"'))
                        param2 = Val( param2$ )
                        
                        AddImage( id$, text$, param2 )
                        
                     Case "SetImage"
                        *g = MakeID( id$, *mdi ) 
                        If *g
                           SetImage( *g, GetImageFromKey( param1$ ))
                        EndIf
                        
                     Case "SetColor"
                        *g = MakeID( id$, *mdi ) 
                        If *g
                           *g\ChangeColor = 1
                           SetColor( *g, MakeConstants( param1$ ), MakeFunc( arg$, 3 ))
                        EndIf
                        
                     Case "SetWindowColor"
                        *g = MakeID( id$, *mdi ) 
                        If *g
                           *g\ChangeColor = 1
                           SetBackgroundColor( *g, MakeFunc( arg$, 2 ))
                        EndIf
                        
                     Case "AddItem"
                        *g = MakeID( id$, *mdi ) 
                        If *g
                           If FindString( param1$, "-" )
                              param1 = #PB_Default
                           ElseIf NumericString( param1$ )
                              param1 = Val( param1$ )
                           Else
                              Debug "ERORR AddItem( position = " + param1$ + ")"
                           EndIf
                           text$ = Trim( param2$, Chr('"'))
                           param3 = Val( param3$ )
                           flags = MakeConstants( param4$ )
                           ;
                           AddItem( *g, param1, text$, param3, flags )
                           If IsContainer( *g ) > 0
                              *parent = *g 
                           EndIf
                        EndIf
                        
                  EndSelect
            EndSelect
         EndWith
      EndIf
      
      ; Mid( String$, arg_start+arg_stop + 1 )
      ; если строка такого ввида "containergadget() : closegadgetlist()" 
      Define lines$ = Trim( Mid( String$, arg_start+arg_stop + 1 ), ":" )
      If lines$
         MakeLine( ide_design_panel_MDI, lines$, findtext$ )
      EndIf
      
      ProcedureReturn result
      ; Debug "["+start +" "+ stop +"] " + Mid( str$, start, stop ) ;+" "+ str$ ; arg$
   EndIf
   
EndProcedure


;- 
Procedure$ Generate_CodeStates( *g._s_WIDGET, Space$ )
   Protected result$, name$
   ;ProcedureReturn ""
   
   ;
   If line_break1 = 1
      line_break1 = 0
      If Not is_window_( *g )
         result$ + space$ + #LF$
      EndIf
   EndIf
   
   ;
   If pb_object$
      If is_window_(*g)
         pb_object$ = "Window"
      Else
         pb_object$ = "Gadget"
      EndIf
   EndIf
   
   ;
   If *g\ChangeColor 
      line_break1 = 1
      If is_window_(*g) 
         If pb_object$
            result$ + Space$ + "Set" + pb_object$ + "Color( " + GetClass( *g ) + ", $"+ Hex( *g\color\back & $ffffff, #PB_Long ) +" )" + #LF$
         Else
            result$ + Space$ + "SetBackgroundColor( " + GetClass( *g ) + ", $"+ Hex( *g\color\back & $ffffff, #PB_Long ) +" )" + #LF$
         EndIf
      Else
         result$ + Space$ + "Set" + pb_object$ + "Color( " + GetClass( *g ) + ", #PB_Gadget_BackColor, $"+ Hex( *g\color\back & $ffffff, #PB_Long ) +" )" + #LF$
      EndIf
   EndIf            
   ;
   name$ = GetFontKey( GetFont( *g ) )
   If name$
      line_break1 = 1
      result$ + Space$ + "Set" + pb_object$ + "Font( " + GetClass( *g ) + ", "+ name$ +" )" + #LF$
   EndIf
   ;
   If *g\type = #__type_image
   Else
      name$ = GetImageKey( GetImage( *g ) )
      If name$
         line_break1 = 1
         result$ + Space$ + "Set" + pb_object$ + "Image( " + GetClass( *g ) + ", "+ name$ +" )" + #LF$
      EndIf
   EndIf
   
   ;
   If GetState(*g) > 0
      line_break1 = 1
      result$ + Space$ + "Set" + pb_object$ + "State( " + GetClass( *g ) + ", "+ GetState(*g) + " )" + #LF$
   EndIf
   If Disable(*g) > 0
      line_break1 = 1
      result$ + Space$ + "Disable" + pb_object$ + "( " + GetClass( *g ) + ", #True )" + #LF$
   EndIf
   If Hide(*g) > 0
      line_break1 = 1
      result$ + Space$ + "Hide" + pb_object$ + "( " + GetClass( *g ) + ", #True )" + #LF$
   EndIf
   ;
   ProcedureReturn result$
EndProcedure

Procedure$ Generate_CodePanelItems( *g._s_WIDGET, start, stop, space$ )
   ; Debug " Generate_CodePanelItems["+start+" "+stop +"]"
   Protected i, result$
   ;
   For i = start To stop
      If i > 0
         result$ + space$ + #LF$
         If line_break1
            line_break1 = 0
         EndIf
      EndIf
      result$ + space$ + "Add" + pb_object$ + "Item( " + GetClass( *g ) + 
                ", - 1" + 
                ", " + Chr( '"' ) + GetItemText( *g, i ) + Chr( '"' ) + 
                " )" + #LF$
   Next
   ;
   ProcedureReturn result$
EndProcedure

Procedure$ Generate_CodeCloseList( *g._s_WIDGET, Space$ )
   Protected result$, Space2$ = Space$ + Space(codeindent)
   
   If IsContainer(*g) > 2
      If *g\tabbar
         If *g\tabbar\countitems
            If *g = *g\LastWidget( )
               result$ + Generate_CodePanelItems( *g, 0, *g\tabbar\countitems - 1, Space2$ )
            Else
               If *g\LastWidget( )\TabIndex( ) = *g\tabbar\countitems - 1
                  ; result$ + #LF$
               Else
                  result$ + Generate_CodePanelItems( *g, *g\LastWidget( )\TabIndex( ) + 1, *g\tabbar\countitems - 1, Space2$ )
                  ;  Debug ""+*g\class +" > "+ *g\LastWidget( )\class +" "+ *g\LastWidget( )\TabIndex( ) +" "+ *g\tabbar\countitems
               EndIf
            EndIf
         EndIf
      EndIf
      
      ;
      result$ + Generate_CodeStates( *g, Space2$ )
      
      ;
      result$ + Space$ + "Close" + pb_object$ + "List( ) ; " + GetClass(*g) + #LF$ 
   EndIf
   
   ProcedureReturn result$
EndProcedure

Procedure$  Generate_CodeObject( *mdi, *g._s_WIDGET, space$ )
   Protected result$, function$, x$, y$, width$, height$, text$, param1$, param2$, param3$, flag$, quotetext$
   Protected type$ = ClassFromType( Type(*g) )
   Protected id$ = GetClass(*g)
   
   ; coordinate
   If is_window_( *g ) 
      x$ = Str( X(*g, #__c_container) )
      y$ = Str( Y(*g, #__c_container) )
      width$ = Str( Width(*g, #__c_inner) )
      height$ = Str( Height(*g, #__c_inner) )
   Else
      x$ = Str( X(*g) )
      y$ = Str( Y(*g) )
      width$ = Str( Width(*g) )
      height$ = Str( Height(*g) )
   EndIf
   
   ; Text
   Select type$
      Case "Window", "Button", "String",
           "CheckBox", "Option", "Frame", "Text",
           "HyperLink", "ListIcon", "Web", "Date",
           "ExplorerList", "ExplorerTree", "ExplorerCombo"
         
         text$ = GetText( *g )
         quotetext$ = Chr('"') + text$ + Chr('"')
   EndSelect
   
   ; Param1
   Select type$
         ; Case "MDI" : param1$ = *g\SubMenu
         ; Case "Date" : param1$ = *g\Date
         ; Case "Calendar" : param1$ = *g\Date
      Case "ListIcon" : param1$ = Str(*g\columns( )\width)
         ; Case "Scintilla" : param1$ = *g\CallBack
         ; Case "Shortcut" : param1$ = *g\Shortcut
      Case "Spin",
           "Track",
           "Scroll",
           "Progress",
           "TrackBar",
           "ScrollBar",
           "ProgressBar": param2$ = Str( *g\bar\min )
      Case "HyperLink" : param1$ = Str( *g\Color\Back )
      Case "ScrollArea" : param1$ = Str( GetAttribute( *g, #PB_ScrollArea_InnerWidth ))
      Case "Splitter" 
         Define first = GetAttribute( *g, #PB_Splitter_FirstGadget )
         If first
            param1$ = GetClass( first )
         Else
            param1$ = "- 1"
         EndIf
      Case "Image", "ButtonImage"
         If IsImage( GetImage( *g ) )
            If pb_object$
               param1$ = "ImageID( " + GetImage( *g ) + " )"
            Else
               param1$ = GetImageKey( GetImage( *g ) ) 
            EndIf
         Else
            If pb_object$
               param1$ = "0"
            Else
               param1$ = "-1"
            EndIf
         EndIf
   EndSelect
   
   ; Param2
   Select type$
         ;Case "MDI" : param2$ = *g\FirstMenuItem
      Case "Spin",
           "Track",
           "Scroll",
           "Progress",
           "TrackBar",
           "ScrollBar",
           "ProgressBar": param2$ = Str( *g\bar\max )
      Case "ScrollArea" : param2$ = Str( GetAttribute( *g, #PB_ScrollArea_InnerHeight ))
      Case "Splitter"  
         Define second = GetAttribute( *g, #PB_Splitter_SecondGadget )
         If second
            param2$ = GetClass( second )
         Else
            param2$ = "- 1"
         EndIf
   EndSelect
   
   ; Param3
   Select type$
      Case "Scroll",
           "ScrollBar"  : param3$ = Str( GetAttribute( *g, #PB_ScrollBar_PageLength ))
      Case "ScrollArea" : param3$ = Str( GetAttribute( *g, #PB_ScrollArea_ScrollStep ))
   EndSelect
   
   ; Flags
   Select type$
      Case "Panel", "Web", "IPAddress", "Option", "Scintilla", "Shortcut"
      Default
         Flag$ = MakeConstantsString( type$, *g\flag )
         ; Debug type$ +" "+ Flag$ +" "+ *g\flag
   EndSelect
   
   ;
   ;\\ close list
   If *g\BeforeWidget( )
      ; Panel; Container; ScrollArea
      If IsContainer( *g\BeforeWidget( ) ) > 2
         ;
         PushListPosition( widgets( ))
         If ChangeCurrentElement( widgets( ), *g\address )
            PreviousElement( widgets( ))
            result$ + MakeCloseList( widgets( ), *g\BeforeWidget( ))
         EndIf     
         PopListPosition( widgets( ))
         ;
      EndIf
   EndIf
   
   ;
   ;\\ add panel item
   Static TabParent
   Static TabIndex = - 1
   If *g\parent\tabbar
      If TabParent <> *g\parent
         TabParent = *g\parent
         TabIndex = - 1
      EndIf
      If TabIndex <> *g\TabIndex( ) 
         ;
         If *g\BeforeWidget( )
            If *g\TabIndex( ) = *g\BeforeWidget( )\TabIndex( )
               ; result$ + #LF$
            Else
               result$ + Generate_CodePanelItems( *g\parent, *g\BeforeWidget( )\TabIndex( ) + 1, *g\TabIndex( ), Space$ )
            EndIf
         Else
            result$ + Generate_CodePanelItems( *g\parent, 0, *g\TabIndex( ), Space$ )
         EndIf
         ;
         TabIndex = *g\TabIndex( ) 
      EndIf
   EndIf
   
   ;
   ;\\ add splitter children
   If Type(*g) = #__type_Splitter
      Define first = GetAttribute( *g, #PB_Splitter_FirstGadget )
      Define Second = GetAttribute( *g, #PB_Splitter_SecondGadget )
      ; result$ + #LF$
      If first
         result$ + Generate_CodeObject( *mdi, first, Space$ )
         result$ + Generate_CodeCloseList( first, Space$ )
      EndIf
      If Second
         result$ + Generate_CodeObject( *mdi, second, Space$ )
         result$ + Generate_CodeCloseList( Second, Space$ )
      EndIf
   EndIf  
   
   ;
   If line_break1 = 1
      line_break1 = - 1
      If Not is_window_( *g )
         result$ + space$ + #LF$
      EndIf
   Else
      If IsContainer( *g ) > 2 And *g\BeforeWidget( ) ;And IsContainer( *g\BeforeWidget( ) ) > 2
         result$ + #LF$
      EndIf  
   EndIf
   
   ;
   ;\\
   result$ + space$
   ;
   ;\\ make function string
   ;
   If Trim( id$, "#" ) <> id$
      If type$ = "Window"
         function$ = "Open" + type$
      Else
         Select type$
            Case "Scroll", "Progress", "Track"
               function$ = type$ + "BarGadget"
            Default
               function$ = type$ + "Gadget"
         EndSelect
      EndIf
      ;
      function$ + "( " + id$ + ", "
   Else
      If type$ = "Window"
         If *g\parent = *mdi
            function$ = id$+" = OpenWindow( #PB_Any, "
         Else
            function$ = id$+" = Window( "
         EndIf
      Else
         Select type$
            Case "Scroll", "Progress", "Track"
               function$ = id$ + " = " + type$ + "BarGadget( #PB_Any, "
            Default
               function$ = id$ + " = " + type$ + "Gadget( #PB_Any, "
         EndSelect
      EndIf
   EndIf
   ;
   If pb_object$ = "" 
      function$ = ReplaceString( function$, "Gadget( #PB_Any, ", "( " )
      function$ = ReplaceString( function$, "OpenWindow(", "Open("  )
   EndIf
   ;
   ;\\ make object string
   ;
   Select type$
      Case "Window"        : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                   
      Case "Button"        : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                                 
      Case "String"        : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                                 
      Case "Text"          : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                                   
      Case "CheckBox"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                               
      Case "Option"        : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$
      Case "Web"           : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$
      Case "ExplorerList"  : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                           
      Case "ExplorerTree"  : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                           
      Case "ExplorerCombo" : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                          
      Case "Frame"         : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                                  
         
      Case "HyperLink"     : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$+", " + param1$+", " + param2$                                                          
      Case "ListIcon"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$+", " + param1$                                                      
         
      Case "ScrollArea"    : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$    
      Case "Scroll", 
           "ScrollBar"     : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$+", " + param3$                                                               
      Case "Progress",
           "ProgressBar"   : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$                                                                       
      Case "Track", 
           "TrackBar"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$                                                                                      
      Case "Spin"          : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$                                                                             
      Case "Splitter"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$                                                                         
      Case "MDI"           : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$                                                                              
      Case "Image"         : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$                                                                                                     
      Case "Scintilla"     : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$
      Case "Shortcut"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$
      Case "ButtonImage"   : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$                                                                                                 
         
      Case "ListView"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                       
      Case "ComboBox"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                       
      Case "Container"     : result$ + function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                      
      Case "IPAddress"     : result$ + function$ + x$+", " + y$+", " + width$+", " + height$
      Case "Calendar"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$                                                     
      Case "Editor"        : result$ + function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                          
      Case "Date"          : result$ + function$ + x$+", " + y$+", " + width$+", " + height$               
      Case "Tree"          : result$ + function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                            
      Case "Panel"         : result$ + function$ + x$+", " + y$+", " + width$+", " + height$ 
      Case "Canvas"        : result$ + function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                          
   EndSelect
   ;
   Select type$
      Case "ScrollArea"    
         If param3$ : result$ +", " + param3$ : EndIf     
      Case "Calendar"
         If param1$ : result$ +", " + param1$ : EndIf 
      Case "Date"         
         If text$ : result$ +", "+ quotetext$ : EndIf
         If param1$ : result$ +", " + param1$ : EndIf 
   EndSelect
   ;
   If flag$
      Select type$
         Case "Window",
              "ScrollBar", "TrackBar", "ProgressBar", 
              "Scroll", "Track", "Progress", "Spin", "Web", "OpenGL",
              "Text", "String", "Editor", "Button", "CheckBox", "HyperLink", 
              "Tree", "ListIcon", "ListView", "ComboBox", "Image", "ButtonImage",
              "Date", "Calendar", "ExplorerCombo", "ExplorerList", "ExplorerTree",
              "Container", "ScrollArea", "Splitter", "MDI", "Canvas", "Frame"  
            
            result$ +", " + flag$ 
      EndSelect
   EndIf
   ;
   result$ + " )" + #LF$ 
   ;   
   If Not IsContainer( *g ) Or is_window_(*g)
      result$ + Generate_CodeStates( *g, Space$ + Space(codeindent) )
   EndIf
   ;
   ProcedureReturn result$
EndProcedure

Procedure.s Generate_Code( *mdi._s_WIDGET ) ; 
   Protected Type, Count, Image, Parent
   Protected imageScale$
   Protected Space$, id$, Class$, result$, Gadgets$, Windows$, Events$, Functions$
   Protected JPEGPlugin$, JPEG2000Plugin$, PNGPlugin$, TGAPlugin$, TIFFPlugin$
   Protected GlobalWindow$, EnumWindow$,
             GlobalGadget$, EnumGadget$,
             GloballoadFont$, EnumFont$, Enumloadfont$,
             GloballoadImage$, EnumImage$, EnumloadImage$
   
   Protected *g._s_WIDGET
   Protected *w._s_WIDGET
   Protected *mainWindow._s_WIDGET
   
   If *mdi
      parentlevel = Level(*mdi)
   EndIf
   
   ; is *g
   If *mdi
      If codeindent
         Space$ = Space(codeindent)
      EndIf
      
      result$ + "EnableExplicit" + #LF$
      If pb_object$ = ""
         result$ + #LF$
         result$ + "CompilerIf #PB_Compiler_IsMainFile" + #LF$
         result$ + Space$ + ~"XIncludeFile \"C:\\Users\\user\\Documents\\GitHub\\widget\\widgets.pbi\"" + #LF$ 
         result$ + "CompilerEndIf" + #LF$
         result$ + #LF$
         result$ + "UseWidgets( )" + #LF$
      EndIf
      
      If StartEnum( *mdi )
         *w = widgets( )
         id$ = GetClass( *w )
         Image = GetImage( *w )
         
         ; Debug GetClass( GetParent(*w)) +" "+ GetClass( *w) +" "+ Image
         ;
         If Not *mainWindow
            If is_window_( *w )
               *mainWindow = *w
            EndIf
         EndIf
         
         ;
         ;\\
         ;
         If Trim( id$, "#" ) = id$
            If is_window_( *w )
               GlobalWindow$ + "Global " + id$ + " = - 1" + #LF$
            Else
               GlobalGadget$ + "Global " + id$ + " = - 1" + #LF$
            EndIf
         Else
            If is_window_( *w )
               EnumWindow$ + Space$ + id$ + #LF$
            Else
               EnumGadget$ + Space$ + id$ + #LF$
            EndIf
         EndIf
         
         ;
         ;\\ UseIMAGEDecoder
         ;
         If IsImage( Image )
            Select ImageFormat( Image )
               Case #PB_ImagePlugin_JPEG
                  If JPEGPlugin$ <> "UseJPEGImageDecoder( )"
                     JPEGPlugin$ = "UseJPEGImageDecoder( )"
                     result$ + "UseJPEGImageDecoder( )" + #LF$
                  EndIf
               Case #PB_ImagePlugin_JPEG2000
                  If JPEG2000Plugin$ <> "UseJPEG2000ImageDecoder( )"
                     JPEG2000Plugin$ = "UseJPEG2000ImageDecoder( )"
                     result$ + "UseJPEG2000ImageDecoder( )" + #LF$
                  EndIf
               Case #PB_ImagePlugin_PNG
                  If PNGPlugin$ <> "UsePNGImageDecoder( )"
                     PNGPlugin$ = "UsePNGImageDecoder( )"
                     result$ + "UsePNGImageDecoder( )" + #LF$
                  EndIf
               Case #PB_ImagePlugin_TGA
                  If TGAPlugin$ <> "UseTGAImageDecoder( )"
                     TGAPlugin$ = "UseTGAImageDecoder( )"
                     result$ + "UseTGAImageDecoder( )" + #LF$
                  EndIf
               Case #PB_ImagePlugin_TIFF
                  If TIFFPlugin$ <> "UseTIFFImageDecoder( )"
                     TIFFPlugin$ = "UseTIFFImageDecoder( )"
                     result$ + "UseTIFFImageDecoder( )" + #LF$
                  EndIf
               Case #PB_ImagePlugin_BMP
                  
               Case #PB_ImagePlugin_ICON
                  
            EndSelect
         EndIf
         StopEnum( )
      EndIf
      
      result$ + #LF$
      
      ; load images
      If ListSize(images( ))
         ForEach images( )
            id$ = images( )\id$
            If id$ 
               If images( )\key$
                  If Trim( id$, "#") = id$
                     Globalloadimage$ + "Global " + id$ + " = " + "Loadimage( " + "#PB_Any" + ", " + images( )\file$ + " )" + #LF$
                  Else
                     Enumimage$ + Space$ + id$ + #LF$
                     ;
                     Enumloadimage$ + "Loadimage( " + id$ + ", " + images( )\file$ + " )" + #LF$
                  EndIf
               Else
                  ; Globalloadimage$ + "Global " + id$ + " = " + "CatchImage( " + "#PB_Any" + ", ?" + ReplaceString(images( )\id$, "*", "" ) + " )" + #LF$
               EndIf 
               
               CompilerIf #PB_Compiler_DPIAware
                  imageScale$ + Space$ + "ResizeImage( "+id$+", DesktopScaledX( ImageWidth( "+id$+" )), DesktopScaledY( ImageHeight( "+id$+" )), #PB_Image_Raw )"+ #LF$
               CompilerEndIf
            EndIf
         Next
      EndIf
      
      ; load fonts
      If MapSize(fonts( ))
         ForEach fonts( )
            ;id$ = fonts( )\key$
            id$ = fonts( )\id$
            
            If id$ ; Not NumericString( id$ )
               If Trim( id$, "#") = id$
                  If fonts( )\style
                     GloballoadFont$ + "Global " + id$ + " = " + "LoadFont( " + "#PB_Any" + ", " + Chr('"') + fonts( )\name + Chr('"') + ", " + fonts( )\size + ", " + MakeConstantsString( "Font", fonts( )\style) + " )" + #LF$
                  Else
                     GloballoadFont$ + "Global " + id$ + " = " + "LoadFont( " + "#PB_Any" + ", " + Chr('"') + fonts( )\name + Chr('"') + ", " + fonts( )\size + " )" + #LF$
                  EndIf
               Else
                  EnumFont$ + Space$ + id$ + #LF$
                  ;
                  If fonts( )\style
                     Enumloadfont$ + "LoadFont( " + id$ + ", " + Chr('"') + fonts( )\name + Chr('"') + ", " + fonts( )\size + ", " + MakeConstantsString( "Font", fonts( )\style) + " )" + #LF$
                  Else
                     Enumloadfont$ + "LoadFont( " + id$ + ", " + Chr('"') + fonts( )\name + Chr('"') + ", " + fonts( )\size + " )" + #LF$
                  EndIf
               EndIf
            EndIf
         Next
      EndIf
      
      ;
      ;\\ enumeration windows
      ;
      If EnumWindow$
         result$ + "Enumeration FormWindow" + #LF$
         result$ + EnumWindow$
         result$ + "EndEnumeration" + #LF$
         result$ + #LF$
      EndIf
      ; 
      If EnumGadget$
         result$ + "Enumeration FormGadget" + #LF$
         result$ + EnumGadget$
         result$ + "EndEnumeration" + #LF$
         result$ + #LF$
      EndIf
      ;
      If EnumFont$
         result$ + "Enumeration FormFont" + #LF$
         result$ + EnumFont$
         result$ + "EndEnumeration" + #LF$
         result$ + #LF$
      EndIf
      ;
      If EnumImage$
         result$ + "Enumeration FormImage" + #LF$
         result$ + EnumImage$
         result$ + "EndEnumeration" + #LF$
         result$ + #LF$
      EndIf
      ;
      ;\\ global windows
      ;
      If GlobalWindow$
         result$ + GlobalWindow$
         result$ + #LF$
      EndIf
      ; 
      If GlobalGadget$
         result$ + GlobalGadget$
         result$ + #LF$
      EndIf
      ;
      If Globalloadfont$
         result$ + Globalloadfont$
         result$ + #LF$
      EndIf
      ; 
      If Globalloadimage$
         result$ + Globalloadimage$
         result$ + #LF$
      EndIf
      
      If Enumloadfont$
         result$ + Enumloadfont$
         result$ + #LF$
      EndIf
      
      If EnumloadImage$
         result$ + EnumloadImage$
         result$ + #LF$
      EndIf
      
      If imageScale$
         result$ + "CompilerIf #PB_Compiler_DPIAware" + #LF$
         result$ + imageScale$
         result$ + "CompilerEndIf" + #LF$
         result$ + #LF$
      EndIf
      
      ;result$ + ";- " + #LF$
      If StartEnum( *mdi )
         *g = widgets( )
         ;If Not is_window_( *g )
         Events$ = GetEventsString( *g )
         If Events$
            result$ + Generate::CodeBindEventProcedure( 0, Trim( GetClass( *g ), "#" ) , Events$, "" ) 
         EndIf
         ;EndIf
         StopEnum( )
      EndIf
      
      If StartEnum( *mdi )
         *w = widgets( )
         If *w\parent = *mdi
            Continue
         EndIf
         If is_window_( *w )
            ;\\
            result$ + "Procedure Open_" + Trim( GetClass( *w ), "#" ) + "( )" + #LF$
            
            ;\\ 
            result$ + Generate_CodeObject( *mdi, *w, Space(( Level(*w) - parentlevel ) * codeindent ))
            
            If StartEnum( *w )
               *g = widgets( )
               If Type(GetParent(*g)) = #__type_Splitter
               Else
                  result$ + Generate_CodeObject( *mdi, *g, Space(( Level(*g) - parentlevel ) * codeindent ))
               EndIf
               
               StopEnum( )
            EndIf
            
            ; CLOSE LIST
            If *g
               result$ + MakeCloseList( *g ) 
            EndIf
            
            ;
            If GetEventsString( *w )
               result$ + #LF$
               result$ + Generate::CodeBindEvent( ( Level(*w) - parentlevel ) * codeindent, GetEventsString( *w ), GetClass( *w ) )
            EndIf
            
            result$ + "EndProcedure" + #LF$
            result$ + #LF$
            
         EndIf
         StopEnum( )
      EndIf
      
      Protected win
      If StartEnum( *mdi )
         *w = widgets( )
         If *w\parent <> *mdi
            Continue
         EndIf
         If is_window_( *w )
            ;\\
               result$ + "Procedure Open_" + Trim( GetClass( *w ), "#" ) + "( )" + #LF$
               result$ + Generate_CodeObject( *mdi, *w, Space(( Level(*w) - parentlevel ) * codeindent ))
               
               ;
               If StartEnum( *w )
                  *g = widgets( )
                  If is_window_( *g )
                     win = *g
                     result$ + Space$ + "Open_" + Trim( GetClass( *g ), "#" ) + "( )" + #LF$
                  Else
                     If Not win
                        If Type(GetParent(*g)) = #__type_Splitter
                        Else
                           result$ + Generate_CodeObject( *mdi, *g, Space(( Level(*g) - parentlevel ) * codeindent ))
                        EndIf
                     EndIf
                  EndIf
                  
                  StopEnum( )
               EndIf
               
               If Not win
                  ; CLOSE LIST
                  If *g
                     result$ + MakeCloseList( *g ) 
                  EndIf
                  
                  ;
                  If GetEventsString( *w )
                     result$ + #LF$
                     result$ + Generate::CodeBindEvent( ( Level(*w) - parentlevel ) * codeindent, GetEventsString( *w ), GetClass( *w ) )
                  EndIf
               EndIf
            
               result$ + "EndProcedure" + #LF$
               result$ + #LF$
         EndIf
         StopEnum( )
      EndIf
      
      
      result$ + "CompilerIf #PB_Compiler_IsMainFile" + #LF$
      ; result$ + "  Open_" + Trim( GetClass( *mainWindow ), "#" ) + "( )" + #lf$
      
      Define CountWindow
      If StartEnum( *mdi )
         *w = widgets( )
         If is_window_( *w )
            CountWindow + 1
            If *w\parent = *mdi
               result$ + Space$ + "Open_" + Trim( GetClass( *w ), "#" ) + "( )" + #LF$
            EndIf
         EndIf
         StopEnum( )
      EndIf
      
      result$ + #LF$
      
      If pb_object$ = ""
         result$ + Space$ + "WaitClose( )" + #LF$
      Else
         ;result$ + Space$ + ";- MAIN LOOP" + #LF$
         result$ + Space$ + "Define EVENT" + #LF$
         result$ + Space$ + "Define OPENWINDOW = " + Str( CountWindow ) + #LF$
         result$ + Space$ + "While OPENWINDOW" + #LF$
         ; result$ + Space$ + "While IsWindow( " + GetClass( *mainWindow ) + " )" + #LF$
         result$ + Space$ + Space$ + "EVENT = WaitWindowEvent( )" + #LF$
         result$ + Space$ + Space$ + "" + #LF$
         result$ + Space$ + Space$ + "Select EventWindow( )" + #LF$
         If StartEnum( *mdi )
            *w = widgets( )
            If is_window_( *w )
               result$ + Space$ + Space$ + Space$ + "Case " + GetClass( *w ) + #LF$
            EndIf
            StopEnum( )
         EndIf
         result$ + Space$ + Space$ + "EndSelect" + #LF$
         result$ + Space$ + Space$ + "" + #LF$
         result$ + Space$ + Space$ + "Select EVENT" + #LF$
         result$ + Space$ + Space$ + Space$ + "Case #PB_Event_CloseWindow" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + "; If " + GetClass( *mainWindow ) + " = EventWindow( )" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + ";" + Space$ + "If #PB_MessageRequester_Yes = MessageRequester( " + Chr( '"' ) + "Message" + Chr( '"' ) + ", " + #LF$ + 
                   Space$ + Space$ + Space$ + Space$ + ";" + Space$ + Space(Len("If #PB_MessageRequester_Yes = MessageRequester( ")) + Chr( '"' ) +"Are you sure you want To go out?"+ Chr( '"' ) + ", " + #LF$ + 
                   Space$ + Space$ + Space$ + Space$ + ";" + Space$ + Space(Len("If #PB_MessageRequester_Yes = MessageRequester( ")) + "#PB_MessageRequester_YesNo | #PB_MessageRequester_Info )" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + ";" + Space$ + Space$ + "CloseWindow( EventWindow( ) )" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + ";" + Space$ + Space$ + "Break" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + ";" + Space$ + "EndIf" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + "; Else" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + Space$ + "CloseWindow( EventWindow( ) )" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + Space$ + "OPENWINDOW - 1" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + "; EndIf" + #LF$
         result$ + Space$ + Space$ + "EndSelect" + #LF$
         result$ + Space$ + "Wend" + #LF$ 
      EndIf
      result$ + Space$ + "End" + #LF$
      result$ + "CompilerEndIf"
      
      ;       If ListSize(images( ))
      ;          ForEach images( )
      ;             id$ = images( )\id$
      ;             If id$ 
      ;                If images( )\id$ = ""
      ;                   result$ + #LF$
      ;                   result$ + #LF$
      ;                   result$ + "DataSection" + #LF$
      ;                   result$ + Space$ + images( )\id$ +~": : IncludeBinary " + Chr('"') + images( )\file$ + Chr('"') + #LF$
      ;                   result$ + "EndDataSection" + #LF$
      ;                EndIf
      ;             EndIf
      ;          Next
      ;       EndIf
      
   EndIf
   
   ProcedureReturn result$
EndProcedure

;- 
CompilerIf #PB_Compiler_IsMainFile
   DisableExplicit
   
   ; XIncludeFile "test\code\AddFont.pb"
   ; XIncludeFile "test\code\addimage.pb"
   ;    XIncludeFile "test\code\additem1.pb"
   ;    XIncludeFile "test\code\additem2.pb"
   ;    XIncludeFile "test\code\additem3.pb"
   ;    XIncludeFile "test\code\additem4.pb"
   ;    XIncludeFile "test\code\additem5.pb"
   ;    XIncludeFile "test\code\global&enum.pb"
   ;    XIncludeFile "test\code\closelist.pb"
   ;    XIncludeFile "test\code\windows.pb"
   
   If Open(0, 0, 0, 400, 400, "read", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      SetClass(root(), "read")
      ;Path$ = "test\code\AddFont.pb"
      ;Path$ = "test\code\AddFont2.pb"
      ;Path$ = "test\code\addimage.pb"
      ;Path$ = "test\open\image.pb"
      ;Path$ = "test\save_example.pb"
      
     ; Path$ = "test\open\splitter.pb"
      
      ; Path$ = "test\code\windows.pb"
       Path$ = "test\open\windows.pb"
      ; Path$ = "test\open\variable.pb"
      
      If ReadFile( #File, Path$ ) ; Если файл можно прочитать, продолжаем...
         Define Text$ = ReadString( #File, #PB_File_IgnoreEOL ) ; чтение целиком содержимого файла
         FileSeek( #File, 0 )                                   ; 
         
         While Eof( #File ) = 0 ; Цикл, пока не будет достигнут конец файла. (Eof = 'Конец файла')
            String$ = ReadString( #File ) ; Построчный просмотр содержимого файла
            String$ = RemoveString( String$, "?" ) ; https://www.purebasic.fr/english/viewtopic.php?t=86467
            
            MakeLine( root( ), String$, Text$ )
         Wend
         
         ;          
         ;          ForEach *parser\Line()
         ;             Debug *parser\Line()\func$ +"?"+ *parser\Line()\arg$
         ;          Next
         
         ;
         CloseFile(#File) ; Закрывает ранее открытый файл
         Debug "..успешно"
      Else
         Debug "Нет такого файла"
      EndIf
   EndIf
   
   ;
   Define *root = root( )
   If *root
      Define Width = Width( *root )
      Define TEST = GetCanvasWindow( *root )
      
      If Open( 1, 0, 0, Width*2, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
         ResizeWindow( TEST, WindowX( TEST ) - WindowWidth( 1 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
         ResizeWindow( 1, WindowX( 1 ) + WindowWidth( TEST )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
         
         Define *g = Editor( 0, 0, 0, 0, #__flag_autosize )
         
         Define code$ = Generate_Code( *root )
         
         SetText( *g, code$ )
         Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
      EndIf
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 1058
; FirstLine = 991
; Folding = -f-----f------------------f9-4-----4r3f----b-ePA5--0--
; EnableXP
; DPIAware