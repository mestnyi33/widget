; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Keyboard
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; https://www.purebasic.fr/english/viewtopic.php?t=71412

CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Windows
    Enumeration
      #pure_keycode_down    = 40
      #pure_keycode_up      = 38
      #pure_keycode_left    = 37
      #pure_keycode_right   = 39
      #pure_keycode_enter   = 13
      #pure_keycode_delete  =  8
      #pure_keycode_space   = 32
      #pure_keycode_escape  = 27
      #pure_keycode_p_down  = 34
      #pure_keycode_p_up    = 33
      #pure_keycode_pos     = 36
      #pure_keycode_end     = 35
      #pure_keycode_shifted = 16
      #pure_keycode_tabbed  =  9
      #pure_keycode_remove = 127
    EndEnumeration
  CompilerCase #PB_OS_MacOS
    Enumeration
      #pure_keycode_down    = 31
      #pure_keycode_up      = 30
      #pure_keycode_left    = 28
      #pure_keycode_right   = 29
      #pure_keycode_enter   = 13
      #pure_keycode_delete  =  8
      #pure_keycode_space   = 32
      #pure_keycode_escape  = 27
      #pure_keycode_p_down  = 22
      #pure_keycode_p_up    = 11
      #pure_keycode_pos     =  1
      #pure_keycode_end     =  4
      #pure_keycode_shifted = 16 ; ???? 16
      #pure_keycode_tabbed  =  9
      #pure_keycode_remove = 127
    EndEnumeration
  CompilerCase #PB_OS_Linux
    Enumeration
      #pure_keycode_down    = 65364
      #pure_keycode_up      = 65362
      #pure_keycode_left    = 65361
      #pure_keycode_right   = 65363
      #pure_keycode_enter   = 65293
      #pure_keycode_delete  = 65535
      #pure_keycode_space   = 32
      #pure_keycode_escape  = 65307
      #pure_keycode_p_down  = 65365
      #pure_keycode_p_up    = 65366
      #pure_keycode_pos     = 65360
      #pure_keycode_end     = 65367
      #pure_keycode_shifted = 65505
      #pure_keycode_tabbed  = 9
      #pure_keycode_remove  = 65288
    EndEnumeration
CompilerEndSelect

Enumeration
  #fenster = 10
  #feld
  #hintergrund ; Hintergrundabbild
  #eingabe ; Aktuelle Eingabe
EndEnumeration

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Wie groß ist ein Integer?
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  #intsize = 8
CompilerElse
  #intsize = 4
CompilerEndIf

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Türkisch LCase
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure.s TLCase( value.s )
  ProcedureReturn LCase(value)
EndProcedure

Procedure.s TUCase( value.s )
  ProcedureReturn UCase(value)
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Der editor_dataset-Objekt wird verwendet, um String-Arrays zu realisieren
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Interface editor_dataset
  add( value.s, intvalue.i = 0 )
  set( index.i, value.s )
  get.s( index.i )
  length.i()
  find.a( value.s, casesens.a = #False, index.i = -1 )
  count.i( value.s, casesens.a = #False, index.i = -1 )
  lines.i()
  remove( index.i )
  clear()
  cursor.w( index.i, value.w = -1 )
  fold.a( index.i, value.a = 200 )
  locked.a( index.i, value.a = 200 )
  attr.l( index.i, value.i = -2147483648 )
  insert( index.i, value.s, intvalue.i = 0 )
EndInterface

Structure editor_dataset_body
  met.i
  cnt.i
  *ram
  *atr
EndStructure

Procedure   editor_dataset__add( *this.editor_dataset_body, value.s, intvalue.i = 0 )
  Protected p.i, *mem
  ; ***
  If *this\ram = 0
    *this\ram = AllocateMemory( #intsize )
    *this\atr = AllocateMemory( 4 )
  Else
    *this\ram = ReAllocateMemory( *this\ram, MemorySize(*this\ram) + #intsize )
    *this\atr = ReAllocateMemory( *this\atr, MemorySize(*this\atr) + 4 )
  EndIf
  ; ***
  p = MemorySize(*this\ram) - #intsize
  ; ***
  *mem = AllocateMemory( (Len(value)*2) + 2 )
  ; ***
  PokeS( *mem, value, (Len(value)*2) + 2, #PB_Unicode )
  ; ***
  PokeI( *this\ram + p, *mem )
  ; ***
  p = MemorySize(*this\atr) - 4
  ; ***
  PokeL( *this\atr + p, intvalue )
  ; ***
  *this\cnt + 1
EndProcedure

Procedure   editor_dataset__set( *this.editor_dataset_body, index.i, value.s )
  Protected p.i, *mem
  ; ***
  If *this\ram And index >= 0 And index < *this\cnt And *this\cnt
    p = #intsize * index
    ; ***
    *mem = PeekI( *this\ram + p )
    ; ***
    *mem = ReAllocateMemory( *mem, (Len(value)*2) + 2 )
    ; ***
    PokeS( *mem, value, (Len(value)*2) + 2, #PB_Unicode )
    ; ***
    PokeI( *this\ram + p, *mem )
  EndIf
EndProcedure

Procedure.s editor_dataset__get( *this.editor_dataset_body, index.i )
  Protected p.i, *mem
  ; ***
  If *this\ram And index >= 0 And index < *this\cnt And *this\cnt
    p = #intsize * index
    ; ***
    *mem = PeekI( *this\ram + p )
    ; ***
    ProcedureReturn PeekS( *mem, -1, #PB_Unicode )
  EndIf
EndProcedure

Procedure.i editor_dataset__length( *this.editor_dataset_body )
  ; - wegen dem chr(13)
  If *this\cnt
    If *this\ram
      ProcedureReturn MemorySize( *this\ram ) - *this\cnt
    EndIf
  EndIf
EndProcedure

Procedure.a editor_dataset__find( *this.editor_dataset_body, value.s, casesens.a = #False, index.i = -1 )
  Protected p.i, i.i = 0, l.i, sz.i, s.s = "", c.i = 0, f.i = 0
  ; ***
  Protected *tmp = AllocateMemory( 2048 )
  ; ***
  If *this\ram And *this\cnt
    For p = 0 To MemorySize(*this\ram) - 1
      If PeekA( *this\ram + p ) = 13
        s = PeekS( *tmp, -1, #PB_Unicode )
        ; ***
        If casesens = #False
          s = TLCase(s)
        EndIf
        ; ***
        If index = -1
          If FindString( s, value )
            f = 1
            Break
          EndIf
        Else
          If i = index
            If FindString( s, value )
              f = 1
            EndIf
            ; ***
            Break
          EndIf
        EndIf
        ; ***
        sz + ( Len(s) * 2 ) + 1
        l = p + 1
        i + 1
        ; ***
        s = ""
        ; ***
        c = 0
        ; ***
        FreeMemory( *tmp )
        *tmp = AllocateMemory( 2048 )
      Else
        PokeA( *tmp + c, PeekA( *this\ram + p ) )
        c + 1
      EndIf
    Next
  EndIf
  ; ***
  FreeMemory( *tmp )
  ; ***
  ProcedureReturn f
EndProcedure

Procedure.i editor_dataset__count( *this.editor_dataset_body, value.s, casesens.a = #False, index.i = -1 )
  Protected p.i, i.i = 0, l.i, sz.i, s.s = "", c.i = 0, f.i = 0
  ; ***
  Protected *tmp = AllocateMemory( 2048 )
  ; ***
  If *this\ram And *this\cnt
    For p = 0 To MemorySize(*this\ram) - 1
      If PeekA( *this\ram + p ) = 13
        s = PeekS( *tmp, -1, #PB_Unicode )
        ; ***
        If casesens = #False
          s = TLCase(s)
        EndIf
        ; ***
        If index = -1
          f + CountString( s, value )
        Else
          If i = index
            f + CountString( s, value )
            ; ***
            Break
          EndIf
        EndIf
        ; ***
        sz + ( Len(s) * 2 ) + 1
        l = p + 1
        i + 1
        ; ***
        s = ""
        ; ***
        c = 0
        ; ***
        FreeMemory( *tmp )
        *tmp = AllocateMemory( 2048 )
      Else
        PokeA( *tmp + c, PeekA( *this\ram + p ) )
        c + 1
      EndIf
    Next
  EndIf
  ; ***
  FreeMemory( *tmp )
  ; ***
  ProcedureReturn f
EndProcedure

Procedure.i editor_dataset__lines( *this.editor_dataset_body )
  ProcedureReturn *this\cnt
EndProcedure

Procedure   editor_dataset__remove( *this.editor_dataset_body, index.i )
  Protected p.i, n.i = -1, *mem
  Protected Dim *lst(*this\cnt)
  Protected Dim atr.l(*this\cnt)
  ; ***
  If *this\ram
    For p = 0 To *this\cnt - 1
      If p <> index
        n + 1
        ; ***
        *lst(n) = PeekI( *this\ram + (p * #intsize) )
        ; ***
        atr(n) = PeekL( *this\atr + (p * 4) )
      EndIf
    Next
    ; ***
    FreeMemory( *this\ram )
    FreeMemory( *this\atr )
    ; ***
    *this\cnt - 1
    ; ***
    If *this\cnt
      *this\ram = AllocateMemory( *this\cnt * #intsize )
      *this\atr = AllocateMemory( *this\cnt * 4 )
      ; ***
      For p = 0 To *this\cnt - 1
        If *lst(p)
          PokeI( *this\ram + (p * #intsize), *lst(p) )
          ; ***
          PokeL( *this\atr + (p * 4), atr(p) )
        EndIf
      Next
    EndIf
  EndIf
EndProcedure

Procedure   editor_dataset__clear( *this.editor_dataset_body )
  Protected p.i, *mem
  ; ***
  If *this\ram
    For p = 0 To *this\cnt - 1
      *mem = PeekI( *this\ram + (p * #intsize) )
      FreeMemory( *mem )
    Next
    ; ***
    FreeMemory( *this\ram )
    FreeMemory( *this\atr )
    ; ***
    *this\atr = 0
    *this\ram = 0
    *this\cnt = 0
  EndIf
EndProcedure

Procedure.w editor_dataset__cursor( *this.editor_dataset_body, index.i, value.w = -1 )
  Protected p.i
  ; ***
  If *this\ram And index >= 0 And index < *this\cnt And *this\cnt
    p = 4 * index
    ; ***
    If value <= -1
      ProcedureReturn PeekW( *this\atr + p )
    Else
      PokeW( *this\atr + p, value )
    EndIf
  EndIf
EndProcedure

Procedure.a editor_dataset__fold( *this.editor_dataset_body, index.i, value.a = 200 )
  Protected p.i
  ; ***
  If *this\ram And index >= 0 And index < *this\cnt And *this\cnt
    p = 4 * index
    ; ***
    If value = 200
      ProcedureReturn PeekA( *this\atr + p + 1 )
    Else
      If value = #True Or value = #False
        PokeA( *this\atr + p + 1, value )
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure.a editor_dataset__locked( *this.editor_dataset_body, index.i, value.a = 200 )
  Protected p.i
  ; ***
  If *this\ram And index >= 0 And index < *this\cnt And *this\cnt
    p = 4 * index
    ; ***
    If value = 200
      ProcedureReturn PeekA( *this\atr + p + 2 )
    Else
      If value = #True Or value = #False
        PokeA( *this\atr + p + 2, value )
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure.l editor_dataset__attr( *this.editor_dataset_body, index.i, value.i = -2147483648 )
  Protected p.i
  ; ***
  If *this\ram And index >= 0 And index < *this\cnt And *this\cnt
    p = 4 * index
    ; ***
    If value = -2147483648
      ProcedureReturn PeekL( *this\atr + p )
    Else
      PokeL( *this\atr + p, value )
    EndIf
  EndIf
EndProcedure

Procedure   editor_dataset__insert( *this.editor_dataset_body, index.i, value.s, intvalue.i = 0 )
  Protected n.i, g.i = 0, p.i, p1.i, p2.i, *adr, *ram, *atr
  ; ***
  If *this\ram
    editor_dataset__add(*this,"")
    ; ***
    If *this\cnt And index < *this\cnt - 1
      p = *this\cnt -1
      ; ***
      p1 = MemorySize(*this\ram)
      p2 = MemorySize(*this\atr)
      ; ***
      *adr = PeekI( *this\ram + p1 - #intsize )
      ; ***
      *ram = AllocateMemory(p1)
      *atr = AllocateMemory(p2)
      ; ***
      For n = 0 To p
        If g = index
          g + 1
        EndIf
        ; ***
        PokeI( *ram + (g * #intsize), PeekI( *this\ram + (n * #intsize) ) )
        PokeL( *atr + (g * 4), PeekL( *this\atr + (n * 4) ) )
        ; ***
        g + 1
      Next
      ; ***
      PokeI( *ram + (index * #intsize), *adr )
      PokeL( *atr + (index * 4), intvalue )
      ; ***
      FreeMemory(*this\ram) : *this\ram = *ram
      FreeMemory(*this\atr) : *this\atr = *atr
    EndIf
  EndIf
EndProcedure

Procedure   editor_dataset()

  Protected *this.editor_dataset_body

  *this = AllocateMemory(SizeOf(editor_dataset_body))

  If *this
    InitializeStructure(*this, editor_dataset_body)
    ; ***
    *this\ram = *ram
    ; ***
    *this\Met.i = ?_editor_dataset_
  EndIf

  ProcedureReturn *this

EndProcedure

DataSection
  _editor_dataset_:
  Data.i @editor_dataset__add()
  Data.i @editor_dataset__set()
  Data.i @editor_dataset__get()
  Data.i @editor_dataset__length()
  Data.i @editor_dataset__find()
  Data.i @editor_dataset__count()
  Data.i @editor_dataset__lines()
  Data.i @editor_dataset__remove()
  Data.i @editor_dataset__clear()
  Data.i @editor_dataset__cursor()
  Data.i @editor_dataset__fold()
  Data.i @editor_dataset__locked()
  Data.i @editor_dataset__attr()
  Data.i @editor_dataset__insert()
EndDataSection

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Daten des Editors
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Structure struct_intellisence
  scantext.s ; Der Textstrom, dessen Erkennung den Intellisence-Box ladet
  img.i
EndStructure

Structure struct_current_line_char
  char.s
  color.l
  pos.w
EndStructure

Structure struct_pure_multiline_code_editor
  justdraw.a ; Aktueller Zeichnen-Status
  id.i ; CanvasGadet
  intellisence.struct_intellisence
  content.editor_dataset
  ; Syntax-Highlighting für die Schlüsselwörter
  *keywords.editor_dataset
  ; Groß- und Kleinschreibung beachten für Keywords?
  casesens.a
  ; Kommentarzeichen
  comment_char.s
  ; Stringketten-Zeichen
  string_char.s
  ; Double-Trenner für Zahlen
  double_separator.s
  ; Farben
  color_comment.l
  color_string.l
  color_number.l
  color_operator.l
  color_bkg.l
  color_selbkg.l
  color_errorbkg.l
  color_number_block_txt.l
  color_number_block_bkg.l
  ; Zeilennummer anzeigen
  linenumbers.a
  ; Temporärer Abbild
  tempor.i
  ; Visible Background:
  ; Das ist der aktuelle Hintergrund, der alle sichtbaren 
  ; Code-Zeilen wiedergibt
  visbkg.i
  ; Temporary Background:
  ; Dieses Bild wird bei up/down gentzt, um eine Kopie 
  ; des visbkg zu nehmen und es um eine Zeile nach oben
  ; oder nach unten zu reduzieren und die neu dazu kommende
  ; Zeile anzuhängen
  tmpbkg.i
  ; Current Line Inkey
  inkey.s
  ; Current Line:
  ; Das Abbild der aktuellen Zeile wird beim up/down oder
  ; Mausklick aus dem Background-Bereich herauskopiert oder
  ; beim JIT-Eingabe automatisch realisiert, jedoch nur ab dem
  ; Part, der gerade bearbeitet wird
  curlin.i
  ; Aktuelles Start-Zeichen der aktuellen Zeile, ab dem
  ; neugezeichnet wird
  curpos.i
  ; Zeichencursor
  cursor.i
  ; Aktuelle Länge der Eingabe
  length.w
  ; Aktuelle Zeilenindex
  index.i
  ; Zeichenstrom der aktuellen Zeile
  strom.struct_current_line_char[20000]
  ; Temporärer Token
  tmptok.s
  ; Letzte Tokenstart
  lastpo.w
  ; Top-Limit
  toplimit.i
  ; Vis-Limit
  vislimit.u
  ; Cursor-Row-Position
  position.i
  ; Hintergrund-Update
  update_bkg.a
  ; Nummernblock-Abstand
  nwid.u
  ; Text-Height
  theight.u
  ; Cursor-Display
  cursorDisplay.a
EndStructure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Funktionen
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure.s pick( index.l, char.s, value.s )
  Protected n.l, s.s, idx.l = 0
  ; ***
  For n = 1 To Len( value )
    Select Mid( value, n, 1 )
      Case char
        If idx = index
          Break
        Else
          idx + 1
          ; ***
          s = ""
        EndIf
      Default
        s + Mid( value, n, 1 )
    EndSelect
  Next
  ; ***
  If idx > index
    s = ""
  EndIf
  ; ***
  If index < 0
    s = ""
  EndIf
  ; ***
  If index > CountString( value, char )
    s = ""
  EndIf
  ; ***
  ProcedureReturn s
EndProcedure

Procedure.i opaque( value.i, transparency.u = 255 )
  ProcedureReturn RGBA( Red(value), Green(value), Blue(value), transparency )
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Zeichnen
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

LoadFont(100,"Anonymous Pro",20)

; Thread-Zugang zum gesamten Instanz-Datenstruktur
Global *threadbased_current_mem.struct_pure_multiline_code_editor

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Ermittelt die Zeichen des aktuell angesteuerten Zeile
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure update_current_line(*daten.struct_pure_multiline_code_editor)
  If IsGadget(#feld)
    Protected w.i, h.i, p.i, n.i, c.i, g.i = 0, t.s, s.s, b.s, com.a = 0, stg.a = 0, ps.i, ls.i, spa.a = 0
    ; ***
    w = GadgetWidth(#feld)
    h = GadgetHeight(#feld)
    ; ***
    ls = *daten\length
    ; ***
    ps = 0
    ; ***
    For p = ps To ls
      *daten\strom[p]\color = 0
      ; ***
      If com = 1 And stg = 0
        *daten\strom[p]\color = *daten\color_comment
      ElseIf stg = 1 And com = 0
        *daten\strom[p]\color = *daten\color_string
      EndIf
      ; ***
      Select *daten\strom[p]\char
        Case *daten\comment_char
          If stg = 0
            com = 1
            ; ***
            *daten\strom[p]\color = *daten\color_comment
          EndIf
        Case *daten\string_char
          If com = 0
            Select stg
              Case 0 : stg = 1
              Case 1 : spa = 1
            EndSelect
            ; ***
            *daten\strom[p]\color = *daten\color_string
          EndIf
        Case " ", ".", "(", ")", "{", "}", "[", "]", "/", "\", "%", "+", "-", "&", "'",
             "*", ":", ";", ",", "<", ">", "|", "#", "=", "!", "|", "^", "°", Chr(10), Chr(13)
          If com = 0 And stg = 1
            *daten\strom[p]\color = *daten\color_string
          ElseIf com = 1 And stg = 0
            *daten\strom[p]\color = *daten\color_comment
          ElseIf com = 0 And stg = 0
            *daten\strom[p]\color = *daten\color_operator
            ; ***
            g = p - Len(t)
            ; ***
            For c = 0 To Len(b) - 1
              *daten\strom[g + c]\color = 0
            Next
            ; ***
            If *daten\keywords
              For n = 0 To *daten\keywords\lines() -1
                If TLCase(*daten\keywords\get(n)) = TLCase(t)
                  t = *daten\keywords\get(n)
                  ; ***
                  g = p - Len(*daten\keywords\get(n))
                  ; ***
                  For c = 0 To Len(*daten\keywords\get(n)) - 1
                    *daten\strom[c + g]\color = *daten\keywords\attr(n)
                    *daten\strom[c + g]\char = Mid( t, c + 1, 1 )
                  Next
                  ; ***
                  Break
                EndIf
              Next
            EndIf
          EndIf
          ; ***
          t = ""
          ; ***
          If spa = 1
            spa = 0
            stg = 0
          EndIf
        Default
          t + *daten\strom[p]\char
      EndSelect
    Next
    ; ***
    If spa = 1
      spa = 0
      stg = 0
    EndIf
    ; ***
    If t
      p = ls
      ; ***
      If com = 0 And stg = 0
        *daten\strom[p]\color = *daten\color_operator
        ; ***
        g = p - Len(t)
        ; ***
        For c = 0 To Len(b) - 1
          *daten\strom[g + c]\color = 0
        Next
        ; ***
        If *daten\keywords
          For n = 0 To *daten\keywords\lines() -1
            If TLCase(*daten\keywords\get(n)) = TLCase(t)
              t = *daten\keywords\get(n)
              ; ***
              g = p - Len(*daten\keywords\get(n))
              ; ***
              For c = 0 To Len(*daten\keywords\get(n)) - 1
                *daten\strom[c + g]\color = *daten\keywords\attr(n)
                *daten\strom[c + g]\char = Mid( t, c + 1, 1 )
              Next
              ; ***
              Break
            EndIf
          Next
        EndIf
      EndIf
    EndIf
  EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Ermittelt die aktuell angesteuerte Zeile
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure allocate_current_line(*daten.struct_pure_multiline_code_editor)
  Protected p.i, s.s
  ; ***
  If *daten\content\lines()
    If *daten\index >= 0 And *daten\index < *daten\content\lines()
      s = *daten\content\get(*daten\index)
      ; ***
      *daten\length = 19999
      ; ***
      For p = 1 To *daten\length + 2
        If p >= 19999
          Break
        EndIf
        ; ***
        If p <= Len(s)
          *daten\strom[p-1]\char = Mid( s, p, 1 )
        Else
          *daten\strom[p-1]\char = ""
        EndIf
        ; ***
        *daten\strom[p-1]\color = 0
        *daten\strom[p-1]\pos = 0
        ; ***
        If p >= Len(s)
          If *daten\strom[p-1]\char = ""
            Break
          EndIf
        EndIf
      Next
      ; ***
      *daten\cursor = Len(s)
      *daten\length = Len(s)
      ; ***
      update_current_line( *daten )
    EndIf
  EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Geht zu einer Zeile
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure goto_current_line(*daten.struct_pure_multiline_code_editor,w.i,h.i,currentUpdate.a=#False)
  Protected ww.d, hh.i
  ; ***
  If *daten\index >= 0
    If *daten\index < *daten\content\lines()
      *daten\position = *daten\index - *daten\toplimit
      ; ***
;Debug Str(*daten\position) + ":" + Str(*daten\index) + " > " + *daten\content\get(*daten\index)
      allocate_current_line( *daten )
      ; ***
      If IsImage( *daten\visbkg ) > 0
        CopyImage( *daten\visbkg, *daten\tmpbkg )
      EndIf
      ; ***
      If *daten\justdraw = 0
        *daten\justdraw = 1
        ; ***
        If CreateImage( *daten\visbkg, w, h, 32, #PB_Image_Transparent ) And 
           StartDrawing( ImageOutput( *daten\visbkg ) )
          ; ***
          DrawingMode( #PB_2DDrawing_AlphaBlend )
          ; ***
          If IsFont(100):DrawingFont(FontID(100)):EndIf
          ; ***
          If IsImage( *daten\tmpbkg )
            DrawAlphaImage( ImageID( *daten\tmpbkg ), 0, 0 )
          EndIf
          ; ***
          DrawingMode( #PB_2DDrawing_AlphaChannel )
          ; ***
          Box( 0, TextHeight("A") * *daten\position, w, TextHeight("A"), RGBA(0,0,0,0) )
          ; ***
          StopDrawing()
          ; ***
          CopyImage( *daten\visbkg, *daten\tmpbkg )
          ; ***
          If currentUpdate
            ww = 0
            ; ***
            If CreateImage( *daten\curlin, w, 100, 32, #PB_Image_Transparent ) And 
               StartDrawing( ImageOutput( *daten\curlin ) )
              If IsFont(100):DrawingFont(FontID(100)):EndIf
              ; ***
              hh = TextHeight("A")
              ; ***
              StopDrawing()
            EndIf
            ; ***
            If CreateImage( *daten\curlin, w, hh, 32, #PB_Image_Transparent ) And 
               StartDrawing( ImageOutput( *daten\curlin ) )
              DrawingMode( #PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend )
              ; ***
              If IsFont(100):DrawingFont(FontID(100)):EndIf
              ; ***
              For p = 0 To *daten\length ;- 1
                DrawText( ww, 0, *daten\strom[p]\char, opaque(*daten\strom[p]\color) )
                ; ***
                *daten\strom[p]\pos = ww : ww + TextWidth(*daten\strom[p]\char)
              Next
              ; ***
              StopDrawing()
            EndIf
          EndIf
          ; ***
          *daten\justdraw = 0
        EndIf
      EndIf
    EndIf
  EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Threadfunktion. Überprüft die Syntax der aktuellen Zeilen
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure check_syntax( parameter.i )
  update_current_line( *threadbased_current_mem )
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Realisiert den Syntax-Editor, samt Eingabe und Maus-Events
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure update(*daten.struct_pure_multiline_code_editor,id.i,evt.i,key.i,inp.i,mx.i,my.i)
  If IsGadget(id)
    Protected w.i, h.i, th.d, tp.i, ww.d, hh.i, p.i, n.i, c.i, t.s, a.a = 0, mmx.d, mmy.d
    Protected tx.s, ti.i
    ; ***
    Protected Dim chh.s(0)
    Protected Dim chc.l(0)
    ; ***
    w = GadgetWidth(id)
    h = GadgetHeight(id)
    ; ***
    ;{ Events
    Select evt
      Case #PB_EventType_MouseWheel
 
      Case #PB_EventType_Input
        ;{
        If *daten\cursor = *daten\length
          *daten\strom[*daten\cursor]\char = Chr(inp)
        Else
          For c = *daten\cursor To *daten\length
            n = ArraySize(chh())
            ReDim chh(n+1)
            chh(n) = *daten\strom[c]\char
            ; ***
            n = ArraySize(chc())
            ReDim chc(n+1)
            chc(n) = *daten\strom[c]\color
          Next
          ; ***
          *daten\strom[*daten\cursor]\char = Chr(inp)
          ; ***
          If ArraySize(chh())
            For c = 0 To ArraySize(chh()) -1
              *daten\strom[*daten\cursor + c + 1]\char  = chh(c)
              *daten\strom[*daten\cursor + c + 1]\color = chc(c)
            Next
          EndIf
        EndIf
        ; ***
        If *daten\cursor = *daten\length
          *daten\inkey + Chr(inp)
        ElseIf *daten\cursor = 0
          *daten\inkey = Chr(inp) + *daten\inkey
        Else
          *daten\inkey = Mid( *daten\inkey, 1, *daten\cursor ) + Chr(inp) + 
                         Mid( *daten\inkey, *daten\cursor + 1 )
        EndIf
;        For ti = 0 To *daten\length
;          tx + *daten\strom[ti]\char
;        Next
        ; ***
        *daten\content\set( *daten\index, *daten\inkey )
        ; ***
        *daten\cursor + 1
        *daten\length + 1
        ; ***
        CreateThread( @check_syntax(), 100 )
        ;}
      Case #PB_EventType_KeyDown
        ;{
        Select key
          Case #pure_keycode_enter
            For p = 0 To *daten\length - 1
              t + *daten\strom[p]\char
              ; ***
              If a = 0
                If *daten\strom[p]\char = " "
                  c + 1
                  *daten\strom[p]\char = " "
                Else
                  a = 1
                  ; ***
                  *daten\strom[p]\char = ""
                EndIf
              Else
                *daten\strom[p]\char = ""
              EndIf
              ; ***
              *daten\strom[p]\color = 0
            Next
            ; ***
            *daten\inkey = ""
            ; ***
;            *daten\content\add( t )
            ; ***
            t = ""
            ; ***
            *daten\position + 1
            ; ***
            *daten\index = *daten\position + *daten\toplimit
            ; ***
            *daten\cursor = c
            *daten\length = c
            ; ***
            *daten\content\insert( *daten\position, "" )
            ; ***
            If *daten\position > *daten\vislimit - 1
              *daten\toplimit + 1
              *daten\position - 1
              ; ***
              *daten\index = *daten\position + *daten\toplimit
              ; ***
              If IsImage( *daten\visbkg )
                CopyImage( *daten\visbkg, *daten\tmpbkg )
              EndIf
              ; ***
              If *daten\justdraw = 0
                *daten\justdraw = 1
                ; ***
                If CreateImage( *daten\visbkg, w, h, 32, #PB_Image_Transparent ) And 
                   StartDrawing( ImageOutput( *daten\visbkg ) )
                  ; ***
                  DrawingMode( #PB_2DDrawing_AlphaBlend )
                  ; ***
                  If IsFont(100):DrawingFont(FontID(100)):EndIf
                  ; ***
                  If IsImage( *daten\tmpbkg )
                    DrawAlphaImage( ImageID( *daten\tmpbkg ), 0, - TextHeight("A") )
                  EndIf
                  ; ***
                  StopDrawing()
                  ; ***
                  CopyImage( *daten\visbkg, *daten\tmpbkg )
                EndIf
                ; ***
                *daten\justdraw = 0
              EndIf
              ; ***
              goto_current_line( *daten, w, h )
            Else
              goto_current_line( *daten, w, h )
            EndIf
            ; ***
            *daten\update_bkg = #True
          Case #pure_keycode_delete ; Von Links
            If *daten\cursor = *daten\length
              ;{
              If *daten\cursor > 0
Debug "Remove Last"
                *daten\strom[*daten\cursor - 1]\char = ""
                *daten\strom[*daten\cursor]\char = ""
                ; ***
                *daten\cursor -1
                *daten\length -1
                ; ***
                t = ""
                ; ***
                For p = 0 To *daten\length
                  If p < 19999
                    t + *daten\strom[p]\char
                  EndIf
                Next
                ; ***
                *daten\content\set( *daten\toplimit + *daten\position - 1, *daten\content\get( *daten\toplimit + *daten\position - 1 ) + t )
              EndIf
              ;}
            ElseIf *daten\cursor = 0
              ; Zur vorherigen Zeile ...
              If *daten\position > 0 And *daten\toplimit >= 0
Debug "Remove First"
                For p = 0 To *daten\length - 1
                  t + *daten\strom[p]\char
                Next
                ; ***
                *daten\content\set( *daten\toplimit + *daten\position - 1, *daten\content\get( *daten\toplimit + *daten\position - 1 ) + t )
                ; ***
                *daten\content\remove( *daten\toplimit + *daten\position )
              EndIf
            Else
              ;{
Debug "Remove Within"
              For p = *daten\cursor - 1 To *daten\length
                If p < 19999
                  *daten\strom[p]\char = *daten\strom[p + 1]\char
                EndIf
              Next
              ; ***
              p = *daten\cursor
              ; ***
              Repeat
                Select *daten\strom[p]\char
                  Case " ", ".", "(", ")", "{", "}", "[", "]", "/", "\", "%", "+", "-",
                       "*", ":", ";", ",", "<", ">", "|", "#", Chr(10), Chr(13)
                    *daten\lastpo = p
                    ; ***
                    Break
                  Default
                    p - 1
                EndSelect
              Until p = 0
              ; ***
              For n = p To *daten\length
                Select *daten\strom[p]\char
                  Case " ", ".", "(", ")", "{", "}", "[", "]", "/", "\", "%", "+", "-",
                       "*", ":", ";", ",", "<", ">", "|", "#", Chr(10), Chr(13)
                    Break
                  Default
                    t + *daten\strom[p]\char
                EndSelect
              Next
              ; ***
              If t
                If *daten\keywords
                  For p = 0 To *daten\keywords\lines() -1
                    If TLCase(*daten\keywords\get(p)) = TLCase(*daten\tmptok)
                      t = *daten\keywords\get(p)
                      ; ***
                      n = *daten\cursor - Len(*daten\keywords\get(p)) - 1
                      ; ***
                      For c = 0 To Len(*daten\keywords\get(p)) - 1
                        *daten\strom[c + n]\color = *daten\keywords\attr(p)
                        *daten\strom[c + n]\char = Mid( t, c + 1, 1 )
                      Next
                      ; ***
                      a = 1
                      ; ***
                      Break
                    EndIf
                  Next
                EndIf
              EndIf
              ; ***
              If a = 0
                For p = *daten\lastpo To Len(t)
                  *daten\strom[p]\color = 0
                Next
              EndIf
              ; ***
              *daten\cursor -1
              *daten\length -1
              ;}
            EndIf
            ; ***
            ;{
            If *daten\cursor < 0
              *daten\cursor = 0
            EndIf
            ; ***
            If *daten\length < 0
              *daten\length = 0
            EndIf
            ;}
          Case #pure_keycode_remove ; Von Rechts
            If *daten\cursor = *daten\length
;              Debug "END-2"
            ElseIf *daten\cursor = 0
;              Debug "POS-2"
            Else
;              Debug "MID-2"
            EndIf
          Case #pure_keycode_left
            *daten\cursor -1
            ; ***
            If *daten\cursor < 0
              *daten\cursor = 0
            EndIf
          Case #pure_keycode_right
            *daten\cursor +1
            ; ***
            If *daten\cursor > *daten\length
              *daten\cursor = *daten\length
            EndIf
          Case #pure_keycode_up
            *daten\inkey = ""
            ; ***
            *daten\position - 1
            ; ***
            *daten\index = *daten\position + *daten\toplimit
            ; ***
            *daten\inkey = *daten\content\get(*daten\index)
            ; ***
            If *daten\position < 0
              *daten\toplimit - 1
              ; ***
              If *daten\toplimit < 0
                *daten\toplimit = 0
              EndIf
              ; ***
              *daten\position = 0
              ; ***
              *daten\index = *daten\position + *daten\toplimit
              ; ***
              *daten\inkey = *daten\content\get(*daten\index)
              ; ***
              goto_current_line( *daten, w, h )
              ; ***
              If IsImage( *daten\visbkg )
                CopyImage( *daten\visbkg, *daten\tmpbkg )
              EndIf
              ; ***
              If CreateImage( *daten\visbkg, w, h, 32, #PB_Image_Transparent ) And 
                 StartDrawing( ImageOutput( *daten\visbkg ) )
                ; ***
                DrawingMode( #PB_2DDrawing_AlphaBlend )
                ; ***
                If IsFont(100):DrawingFont(FontID(100)):EndIf
                ; ***
                If IsImage( *daten\tmpbkg )
                  DrawAlphaImage( ImageID( *daten\tmpbkg ), 0, TextHeight("A") )
                EndIf
                ; ***
                StopDrawing()
                ; ***
                CopyImage( *daten\visbkg, *daten\tmpbkg )
              EndIf
              ; ***
              goto_current_line( *daten, w, h )
            Else
              goto_current_line( *daten, w, h )
            EndIf
          Case #pure_keycode_down
            *daten\position + 1
            ; ***
            *daten\index = *daten\position + *daten\toplimit
            ; ***
            *daten\inkey = *daten\content\get(*daten\index)
            ; ***
            If *daten\position > *daten\vislimit - 1
              *daten\toplimit + 1
              *daten\position - 1
              ; ***
              *daten\index = *daten\position + *daten\toplimit
              ; ***
              If *daten\index > *daten\content\lines() - 1
                *daten\index = *daten\content\lines() - 1
                *daten\position = *daten\index - *daten\toplimit
              EndIf
              ; ***
              *daten\inkey = *daten\content\get(*daten\index)
              ; ***
              goto_current_line( *daten, w, h )
              ; ***
              ;*daten\content\add( "" )
              ; ***
              If IsImage( *daten\visbkg )
                CopyImage( *daten\visbkg, *daten\tmpbkg )
              EndIf
              ; ***
              If CreateImage( *daten\visbkg, w, h, 32, #PB_Image_Transparent ) And 
                 StartDrawing( ImageOutput( *daten\visbkg ) )
                ; ***
                DrawingMode( #PB_2DDrawing_AlphaBlend )
                ; ***
                If IsFont(100):DrawingFont(FontID(100)):EndIf
                ; ***
                If IsImage( *daten\tmpbkg )
                  DrawAlphaImage( ImageID( *daten\tmpbkg ), 0, - TextHeight("A") )
                EndIf
                ; ***
                StopDrawing()
                ; ***
                CopyImage( *daten\visbkg, *daten\tmpbkg )
              EndIf
              ; ***
              goto_current_line( *daten, w, h )
            Else
              goto_current_line( *daten, w, h )
            EndIf
        EndSelect
        ;}
      Case #PB_EventType_LeftButtonDown, #PB_EventType_RightButtonDown
        ;{
        mmy = 0
        ; ***
        For p = 0 To *daten\theight * (*daten\vislimit + 1)
          If my >= (*daten\theight * p) And my <= (*daten\theight * (p + 1))
            *daten\index = *daten\toplimit + p : Break
          EndIf
        Next
        ; ***
        *daten\inkey = *daten\content\get(*daten\index)
        ; ***
        *daten\position = *daten\index - *daten\toplimit
        ; ***
        goto_current_line( *daten, w, h, #True )
        ;}
      Case #PB_EventType_LeftButtonUp
        
      Case #PB_EventType_MouseMove

    EndSelect
    ;}
    ; ***
    ww = 0
    ; ***
    If *daten\update_bkg = #True
      *daten\update_bkg = #False
      ; ***
      If CreateImage( *daten\visbkg, w, h, 32, #PB_Image_Transparent ) And 
         StartDrawing( ImageOutput( *daten\visbkg ) )
        ;Box( 0, 0, w, h, $FFFFFF )
        ; ***
        DrawingMode( #PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend )
        ; ***
        If IsFont(100):DrawingFont(FontID(100)):EndIf
        ; ***
        tp = (*daten\position -1) * TextHeight("A")
        th = 0;TextHeight("A") / 2
        ; ***
        If IsImage( *daten\tmpbkg )
          DrawAlphaImage( ImageID( *daten\tmpbkg ), 0, 0 )
        EndIf
        ; ***
        If IsImage( *daten\curlin )
          ;Box( 0, tp + th, w, TextHeight("A"), $FFFFFF )
          ; ***
          DrawAlphaImage( ImageID( *daten\curlin ), 0, tp + th )
        EndIf
        ; ***
        StopDrawing()
        ; ***
        CopyImage( *daten\visbkg, *daten\tmpbkg )
        ; ***
        If evt = #PB_EventType_KeyDown And key = #pure_keycode_enter
          ; nix
        Else
          For p = 0 To *daten\length
            *daten\strom[p]\char = ""
            *daten\strom[p]\color = 0
          Next
          ; ***
          *daten\cursor = 0
          *daten\length = 0
        EndIf
      EndIf
    EndIf
    ; ***
    ww = 0
    ; ***
    If CreateImage( *daten\curlin, w, 100, 32, #PB_Image_Transparent ) And 
       StartDrawing( ImageOutput( *daten\curlin ) )
      If IsFont(100):DrawingFont(FontID(100)):EndIf
      ; ***
      hh = TextHeight("A")
      ; ***
      StopDrawing()
    EndIf
    ; ***
    If CreateImage( *daten\curlin, w, hh, 32, #PB_Image_Transparent ) And 
       StartDrawing( ImageOutput( *daten\curlin ) )
      DrawingMode( #PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend )
      ; ***
      If IsFont(100):DrawingFont(FontID(100)):EndIf
      ; ***
      For p = 0 To *daten\length ;- 1
        DrawText( ww, 0, *daten\strom[p]\char, opaque(*daten\strom[p]\color) )
        ; ***
        *daten\strom[p]\pos = ww : ww + TextWidth(*daten\strom[p]\char)
      Next
      ; ***
      StopDrawing()
    EndIf
    ; ***
    If StartDrawing(CanvasOutput(id))
      If IsFont(100):DrawingFont(FontID(100)):EndIf
      ; ***
      tp = *daten\position * TextHeight("A")
      th = 0;TextHeight("A") / 2
      ; ***
      *daten\theight = TextHeight("A")
      ; ***
      *daten\vislimit = (h / TextHeight("A"))
      ; ***
      Box( 0, 0, w, h, $FFFFFF )
      ; ***
      *daten\nwid = TextWidth("100") + 30
      ; ***
      If TextWidth(Str(*daten\content\lines())) + 30 > TextWidth("100") + 30
        *daten\nwid = TextWidth(Str(*daten\content\lines())) + 30
      EndIf
      ; ***
      Box( 0, 0, *daten\nwid - 2, h, *daten\color_number_block_bkg )
      ; ***
      DrawingMode( #PB_2DDrawing_Transparent )
      ; ***
      For p = 0 To *daten\vislimit
        t = Str(p + *daten\toplimit + 1)
        ; ***
        DrawText( *daten\nwid - 11 - TextWidth(t), TextHeight("A") * p, t, *daten\color_number_block_txt )
      Next
      ; ***
      Box( *daten\nwid, tp + th, w, TextHeight("A"), opaque(RGB( 238, 238, 238 )) )
      ; ***
      If IsImage( *daten\visbkg )
        DrawAlphaImage( ImageID( *daten\visbkg ), *daten\nwid, 0 )
      EndIf
      ; ***
      If IsImage( *daten\curlin )
        DrawAlphaImage( ImageID( *daten\curlin ), *daten\nwid, tp + th )
      EndIf
      ; ***
      If *daten\cursorDisplay
        Box( *daten\nwid + *daten\strom[*daten\cursor]\pos, tp + th, 2, TextHeight("A"), opaque(0) )
      EndIf
      ; ***
      StopDrawing()
    EndIf
  EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Test
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

ExamineDesktops()
OpenWindow(#fenster,0,0,700,700,"Eingabe",
           #PB_Window_SystemMenu|#PB_Window_Invisible)
CanvasGadget(#feld,0,0,700,700,#PB_Canvas_Keyboard)
SetActiveGadget(#feld)
ResizeWindow(#fenster,DesktopWidth(0)-700,
             DesktopHeight(0)-800,700,700)
StickyWindow(#fenster,1)
HideWindow(#fenster,0)
AddWindowTimer(#fenster,#fenster,500)

keyw.editor_dataset = editor_dataset()
mich.struct_pure_multiline_code_editor
test.editor_dataset = editor_dataset()

mich\content = editor_dataset()
For vi = 0 To 99
  mich\content\add( "" )
Next

mich\color_comment = RGB( 147, 133, 148 )
mich\color_string = RGB( 106, 144, 166 )
mich\color_number = RGB( 204, 51, 153 )
mich\color_operator = RGB( 170, 148, 84 );RGB( 153, 51, 255 );RGB( 118, 92, 163 )
mich\color_bkg = RGB( 255, 255, 255 )
mich\color_selbkg = RGB( 238, 238, 238 )
mich\color_errorbkg = RGB( 239, 207, 203 )
mich\color_number_block_bkg = RGB( 238, 238, 238 );RGB( 154, 149, 166 );RGB( 137, 121, 158 );RGB( 98, 62, 133 )
mich\color_number_block_txt = RGB( 154, 149, 166 );RGB(255,255,255)

*threadbased_current_mem = mich

c = RGB( 51, 153, 204 );RGB( 36, 134, 255 )
keyw\add( "Define", c )
keyw\add( "Protected", c )
keyw\add( "Global", c )
keyw\add( "Shared", c )
keyw\add( "Threaded", c )
keyw\add( "Procedure", c )
keyw\add( "EndProcedure", c )
keyw\add( "If", c )
keyw\add( "ElseIf", c )
keyw\add( "Else", c )
keyw\add( "EndIf", c )
keyw\add( "Not", c )
keyw\add( "And", c )
keyw\add( "Or", c )
keyw\add( "Dim", c )
keyw\add( "ReDim", c )
keyw\add( "Debug", c )
keyw\add( "Select", c )
keyw\add( "Case", c )
keyw\add( "Default", c )
keyw\add( "EndSelect", c )
keyw\add( "For", c )
keyw\add( "To", c )
keyw\add( "Step", c )
keyw\add( "Next", c )
keyw\add( "Break", c )
keyw\add( "While", c )
keyw\add( "Wend", c )
keyw\add( "Repeat", c )
keyw\add( "Forever", c )
keyw\add( "Until", c )
keyw\add( "Import", c )
keyw\add( "EndImport", c )
keyw\add( "Macro", c )
keyw\add( "EndMacro", c )
keyw\add( "Enumeration", c )
keyw\add( "EndEnumeration", c )
keyw\add( "Structure", c )
keyw\add( "EndStructure", c )
keyw\add( "Interface", c )
keyw\add( "EndInterface", c )
keyw\add( "Data", c )
keyw\add( "DataSection", c )
keyw\add( "EndDataSection", c )
keyw\add( "Goto", c )
keyw\add( "GoSub", c )
keyw\add( "ForEach", c )
keyw\add( "ProcedureReturn", c )
keyw\add( "Return", c )
keyw\add( "Continue", c )
keyw\add( "EndWith", c )
keyw\add( "With", c )
keyw\add( "End", c )
keyw\add( "Module", c )
keyw\add( "EndModule", c )
keyw\add( "NewList", c )
keyw\add( "NewMap", c )
keyw\add( "Static", c )
keyw\add( "Declare", c )
keyw\add( "Prototype", c )
keyw\add( "DeclareModule", c )
keyw\add( "EndDeclareModule", c )
keyw\add( "CompilerIf", c )
keyw\add( "CompilerElseIf", c )
keyw\add( "CompilerElse", c )
keyw\add( "CompilerEndif", c )
keyw\add( "CompilerSelect", c )
keyw\add( "CompilerCase", c )
keyw\add( "CompilerDefault", c )
keyw\add( "CompilerEndSelect", c )
; ***
; --- ---- --- Vordefinierte Funktionen --- ---- --- ;
c = RGB( 102, 102, 153 )
keyw\add( "RunProgram", c )
keyw\add( "Date", c )
keyw\add( "Day", c )
keyw\add( "DayOfWeek", c )
keyw\add( "Month", c )
keyw\add( "Hour", c )
keyw\add( "Second", c )
keyw\add( "Minute", c )
keyw\add( "Milliseconds", c )
keyw\add( "FormatDate", c )
keyw\add( "Left", c )
keyw\add( "Mid", c )
keyw\add( "Right", c )
keyw\add( "Len", c )
keyw\add( "Trim", c )
keyw\add( "LTrim", c )
keyw\add( "RTrim", c )
keyw\add( "Chr", c ) ; Clipboard
keyw\add( "Asc", c )
keyw\add( "Val", c )
keyw\add( "ValD", c )
keyw\add( "Str", c )
keyw\add( "StrD", c )
keyw\add( "FreeMemory", c )
keyw\add( "AllocateMemory", c )
keyw\add( "ReAllocateMemory", c )
keyw\add( "PeekA", c )
keyw\add( "PeekB", c )
keyw\add( "PeekC", c )
keyw\add( "PeekD", c )
keyw\add( "PeekF", c )
keyw\add( "PeekI", c )
keyw\add( "PeekL", c )
keyw\add( "PeekQ", c )
keyw\add( "PeekS", c )
keyw\add( "PeekU", c )
keyw\add( "PeekW", c )
keyw\add( "PokeA", c )
keyw\add( "PokeB", c )
keyw\add( "PokeC", c )
keyw\add( "PokeD", c )
keyw\add( "PokeF", c )
keyw\add( "PokeI", c )
keyw\add( "PokeL", c )
keyw\add( "PokeQ", c )
keyw\add( "PokeS", c )
keyw\add( "PokeU", c )
keyw\add( "PokeW", c )

mich\comment_char = ";"
mich\string_char = Chr(34)
mich\double_separator = "."
mich\keywords = keyw
mich\visbkg = 10
mich\tmpbkg = 11
mich\curlin = 12
mich\tempor = 13

If ReadFile(90,ProgramParameter(0))
  While Eof(90) = 0
    test\add( ReadString(90) )
  Wend
  CloseFile(90)
EndIf

update(mich,#feld,0,0,0,0,0)

Repeat
  ev.i = WaitWindowEvent()
  ; ***
  If ev = #PB_Event_CloseWindow
    ;For r = 0 To mich\content\lines() -1
      ;Debug Str(r) + ":" + Str(r+1) + " >> " + mich\content\get(r)
    ;Next
  EndIf
  ; ***
  If ev = #PB_Event_Timer And EventTimer() = #fenster
    Select mich\cursorDisplay
      Case 0 : mich\cursorDisplay = 1
      Case 1 : mich\cursorDisplay = 0
    EndSelect
    ; ***
    update(mich,#feld,0,0,0,0,0)
  EndIf
  ; ***
  If ev = #PB_Event_Gadget And EventGadget() = #feld
    Select EventType()
      Case #PB_EventType_Input, #PB_EventType_KeyDown,
           #PB_EventType_LeftButtonDown,
           #PB_EventType_RightButtonUp, #PB_EventType_MouseMove,
           #PB_EventType_MouseWheel
        update(mich,#feld,EventType(),
               GetGadgetAttribute(#feld,#PB_Canvas_Key),
               GetGadgetAttribute(#feld,#PB_Canvas_Input),
               GetGadgetAttribute(#feld,#PB_Canvas_MouseX),
               GetGadgetAttribute(#feld,#PB_Canvas_MouseY))
    EndSelect
  EndIf
Until ev = #PB_Event_CloseWindow

End

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ------------------------------
; EnableThread
; EnableXP