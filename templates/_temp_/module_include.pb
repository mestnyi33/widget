DeclareModule struct
  Structure struct
    x.l
    y.l
    *parent.struct
  EndStructure
  
EndDeclareModule

Module struct
EndModule

DeclareModule a
  Structure struct Extends struct::struct : EndStructure
  
  Declare move(*this, x,y)
  Declare create(*parent.struct)
EndDeclareModule

Module a
  
  Procedure move(*this.struct, x,y)
    *this\x = x
    *this\y = y
  EndProcedure
  
  Procedure create(*parent.struct)
    Protected *this.struct = AllocateStructure(struct)
    move(*this, 10, 10)
    
    ProcedureReturn *this
  EndProcedure
  
EndModule

DeclareModule b
  ;UseModule struct
  Structure struct Extends struct::struct : EndStructure
  
  Declare move(*this, x,y)
  Declare create(*parent.struct)
EndDeclareModule

Define *this.struct::struct = a::create(0)
Debug *this\x

Module b
  
  Procedure move(*this.struct, x,y)
    If *this\parent
      *this\x = *this\parent\x + x
      *this\y = *this\parent\y + y
    Else
      *this\x = x
      *this\y = y
    EndIf
  EndProcedure
  
  Procedure create(*parent.struct)
    Protected *this.struct = a::create(0)
    *this\parent = *parent
    move(*this, 20, 20)
    
    ProcedureReturn *this
  EndProcedure
  
EndModule

Define *this.struct::struct = b::create(*this)
Debug *this\x


; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ---
; EnableXP