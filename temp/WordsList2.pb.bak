EnableExplicit

DeclareModule Iterator
  EnableExplicit
  
  Interface Iterator
    current()
    key()
    nxt()
    rewind()
    valid()
    free()
  EndInterface

  Macro Loop(it)
    it\rewind()
    While it\valid()
  EndMacro
  
  Macro EndLoop(it)
    it\nxt()
    Wend
  EndMacro
EndDeclareModule  

Module Iterator
  
EndModule

DeclareModule IntArrayIterator
  EnableExplicit
  
  Declare New(Array arr.i(1))
EndDeclareModule

Module IntArrayIterator
  
  Structure IntArray
    i.i[0]
  EndStructure
  
  Structure This
    *vt
    *arr.IntArray
    size.i
    pos.i
  EndStructure  
  
  Procedure Current(*this.This)
    ProcedureReturn @*this\arr\i[*this\pos]
  EndProcedure
  
  Procedure Key(*this.This)
    ProcedureReturn *this\pos
  EndProcedure  
  
  Procedure Nxt(*this.This)
    *this\pos + 1
  EndProcedure
  
  Procedure Rewind(*this.This)
    *this\pos = 0
  EndProcedure
  
  Procedure Valid(*this.This)
    ProcedureReturn Bool(*this\pos =< *this\size)
  EndProcedure 
  
  Procedure Free(*this.This)
    FreeMemory(*this)
  EndProcedure  
  
  DataSection
    vt:
    Data.i @Current()
    Data.i @Key()
    Data.i @Nxt()
    Data.i @Rewind()
    Data.i @Valid()
    Data.i @Free()
  EndDataSection
  
  Procedure New(Array arr.i(1))
    Protected *this.This
    *this = AllocateMemory(SizeOf(This))
    If *this
      *this\vt = ?vt
      *this\arr = @arr()
      *this\size = ArraySize(arr())
    EndIf  
    ProcedureReturn *this  
  EndProcedure
EndModule

DeclareModule SplitStringIterator
  EnableExplicit
  
  Declare New(*str, delim.s)
EndDeclareModule  

Module SplitStringIterator
  
  Structure This
    *vt
    *s.String
    size.i
    pos.i
    delim.s
    tmp.s
  EndStructure  
  
  Macro SetTmp(this)
    this\tmp = StringField(this\s\s, this\pos + 1, this\delim)
  EndMacro  
  
  Procedure Current(*this.This)
    ProcedureReturn @*this\tmp
  EndProcedure
  
  Procedure Key(*this.This)
    ProcedureReturn *this\pos
  EndProcedure  
  
  Procedure Nxt(*this.This)
    *this\pos + 1
    SetTmp(*this)
  EndProcedure
  
  Procedure Rewind(*this.This)
    *this\pos = 0
  EndProcedure
  
  Procedure Valid(*this.This)
    ProcedureReturn Bool(*this\pos =< *this\size)
  EndProcedure 
  
  Procedure Free(*this.This)
    FreeMemory(*this)
  EndProcedure  
  
  DataSection
    vt:
    Data.i @Current()
    Data.i @Key()
    Data.i @Nxt()
    Data.i @Rewind()
    Data.i @Valid()
    Data.i @Free()
  EndDataSection
  
  Procedure New(*str, delim.s)
    Protected *s.String = @*str
    Protected *this.This
    *this = AllocateMemory(SizeOf(This))
    If *this
      *this\vt = ?vt
      *this\s = *s
      *this\size = CountString(*s\s, delim)
      *this\delim = delim
      SetTmp(*this)
   EndIf  
    ProcedureReturn *this  
  EndProcedure
EndModule
  
UseModule Iterator

Dim arr(1)
arr(0) = 2
arr(1) = 17

Define *it.Iterator = IntArrayIterator::New(arr())

Loop(*it)
  Debug Str(*it\key()) + ":" + Str(PeekI(*it\current()))
EndLoop(*it)
*it\free()

Define s.s = "one;two;three"
*it = SplitStringIterator::New(@s, ";")

Loop(*it)
  Debug PeekS(*it\current())
EndLoop(*it)
*it\free()



; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 187
; FirstLine = 135
; Folding = ------
; EnableXP