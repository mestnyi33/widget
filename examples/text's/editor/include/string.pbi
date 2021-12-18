;-TOP

; Comment : FastString
; Author  : mk-soft
; Version : v1.08.0
; Create  : 20.07.2020
; Update  : 25.07.2020
; https://www.purebasic.fr/english/viewtopic.php?f=12&t=75758&sid=6369038a55c3383da819db0c73c8135d
; *********************

; Description

; The String is always a Pointer to a Memory.
;
; Info:
; The function ClearString, AddString, ConcatString and InsertStringFast returns a new pointer
; to the string and the pointer from the first parameter '*String' is then invalid.
; The same as with ReAllocateMemory from Purebasic.

CompilerIf Defined(PB_MessageRequester_Error, #PB_Constant) = 0
  #PB_MessageRequester_Error = 0
CompilerEndIf

EnableExplicit

Structure udtFastString
  Len.i
  Char.c[0]
EndStructure

; ----

Procedure AllocateString(String.s = "") ; Result String Pointer
  Protected len, *String.udtFastString, *pointer
  len = StringByteLength(String)
  *String = AllocateMemory(len + SizeOf(Integer) + SizeOf(Character))
  
  If *String
    *Pointer = @*String\Char
    CopyMemoryString(@String, @*pointer)
    *String\Len = len
  Else
    MessageRequester("Fatal Error", "Out Of Memory - Stop", #PB_MessageRequester_Error)
    End
  EndIf
  
  ProcedureReturn *String
EndProcedure

; ----
Macro FreeString(String)
  FreeMemory(String)
EndMacro

Procedure ClearString(*String.udtFastString) ; Result New String Pointer
  *String = ReAllocateMemory(*String, SizeOf(Integer) + SizeOf(Character))
  *String\Len = 0
  *String\Char[0] = 0
  
  ProcedureReturn *String
EndProcedure

; ----

Procedure LenString(*String.udtFastString)
  ProcedureReturn *String\Len / SizeOf(Character)
EndProcedure

Procedure.s GetString(*String.udtFastString)
  ProcedureReturn PeekS(@*String\Char, *String\Len / SizeOf(Character))
EndProcedure

; ----

Procedure AddString(*String.udtFastString, String.s) ; Result New String Pointer
  Protected len, len_new, *pointer
  len = StringByteLength(String)
  len_new = *String\Len + len
  *String = ReAllocateMemory(*String, len_new + SizeOf(Integer) + SizeOf(Character), #PB_Memory_NoClear)
  
  If *String
    *pointer = @*String\Char + *String\Len
    CopyMemoryString(@String, @*pointer)
    *String\Len = len_new
  Else
    MessageRequester("Fatal Error", "Out Of Memory - Stop", #PB_MessageRequester_Error)
    End
  EndIf
  
  ProcedureReturn *String
EndProcedure

Procedure ConcatString(*String.udtFastString, *Add.udtFastString) ; Result New String Pointer
  Protected len_new, *pointer
  len_new = *String\Len + *Add\len
  *String = ReAllocateMemory(*String, len_new + SizeOf(Integer) + SizeOf(Character), #PB_Memory_NoClear)
  If *String
    *pointer = @*String\Char + *String\Len
    CopyMemory(@*Add\Char, *pointer, *Add\len + SizeOf(Character))
    *String\Len = len_new
  Else
    MessageRequester("Fatal Error", "Out Of Memory - Stop", #PB_MessageRequester_Error)
    End
  EndIf
  ProcedureReturn *String
EndProcedure

Procedure InsertStringFast(*String.udtFastString, *Insert.udtFastString, Position) ; Result New String Pointer
  Protected len_new, *pointer
  
  If *Insert\Len = 0
    ProcedureReturn *String
  EndIf
  
  Position - 1
  Position * SizeOf(Character)
  
  If Position > *String\Len
    Position = *String\Len
  EndIf
  
  len_new = *String\Len + *Insert\len
  *String = ReAllocateMemory(*String, len_new + SizeOf(Integer) + SizeOf(Character), #PB_Memory_NoClear)
  
  If *String
    *pointer = @*String\Char + Position
    MoveMemory(*pointer, *pointer + *Insert\Len, *String\Len - Position + SizeOf(Character))
    CopyMemory(@*Insert\Char, *pointer, *Insert\Len)
    *String\Len = len_new
  Else
    MessageRequester("Fatal Error", "Out Of Memory - Stop", #PB_MessageRequester_Error)
    End
  EndIf
  
  ProcedureReturn *String
EndProcedure

; ----

Procedure LeftString(*String.udtFastString, Length)
  Protected len, *NewString.udtFastString
  Length * SizeOf(Character)
  If Length <= *String\Len
    len = Length
  Else
    len = *String\Len
  EndIf
  *NewString = AllocateMemory(len + SizeOf(Integer) + SizeOf(Character))
  If *NewString
    CopyMemory(@*String\Char, @*NewString\Char, len)
    *NewString\Len = len
  Else
    MessageRequester("Fatal Error", "Out Of Memory - Stop", #PB_MessageRequester_Error)
    End
  EndIf
  ProcedureReturn *NewString
EndProcedure

Procedure RightString(*String.udtFastString, Length)
  Protected len, *NewString.udtFastString
  Length * SizeOf(Character)
  If Length <= *String\Len
    len = Length
  Else
    len = *String\Len
  EndIf
  *NewString = AllocateMemory(len + SizeOf(Integer) + SizeOf(Character))
  If *NewString
    CopyMemory(@*String\Char + *String\Len - len, @*NewString\Char, len)
    *NewString\Len = len
  Else
    MessageRequester("Fatal Error", "Out Of Memory - Stop", #PB_MessageRequester_Error)
    End
  EndIf
  ProcedureReturn *NewString
EndProcedure

Procedure MidString(*String.udtFastString, Position, Length = #PB_Ignore)
  Protected len, *NewString.udtFastString
  Position - 1
  Position * SizeOf(Character)
  If Position => *String\Len Or Position < 0
    *NewString = AllocateMemory(SizeOf(Integer) + SizeOf(Character))
    If *NewString
      ProcedureReturn *NewString
    Else
      MessageRequester("Fatal Error", "Out Of Memory - Stop", #PB_MessageRequester_Error)
      End
    EndIf
  EndIf
 
  If Length = #PB_Ignore
    Length = *String\Len - Position
  Else
    Length * SizeOf(Character)
  EndIf
 
  If Length + Position <= *String\Len
    len = Length
  Else
    len = *String\Len - Position
  EndIf
  *NewString = AllocateMemory(len + SizeOf(Integer) + SizeOf(Character))
  If *NewString
    CopyMemory(@*String\Char + Position, @*NewString\Char, len)
    *NewString\Len = len
  Else
    MessageRequester("Fatal Error", "Out Of Memory - Stop", #PB_MessageRequester_Error)
    End
  EndIf
  ProcedureReturn *NewString
EndProcedure

; ----

Procedure LSetString(*String.udtFastString, Length, Character = ' ')
  Protected len, cnt, *NewString.udtFastString, *Position
  Length * SizeOf(Character)
  If *String\Len <= Length
    len = *String\Len
  Else
    len = Length
  EndIf
  *NewString = AllocateMemory(Length + SizeOf(Integer) + SizeOf(Character))
  If *NewString
    *Position = @*NewString\Char
    CopyMemory(@*String\Char, *Position, len)
    If len < Length
      *Position + len
      cnt = Length - len
      FillMemory(*Position, cnt, Character, #PB_Character)
    EndIf
    *NewString\Len = Length
  Else
    MessageRequester("Fatal Error", "Out Of Memory - Stop", #PB_MessageRequester_Error)
    End
  EndIf
  ProcedureReturn *NewString
EndProcedure

Procedure RSetString(*String.udtFastString, Length, Character = ' ')
  Protected len, cnt, *NewString.udtFastString, *Position
  Length * SizeOf(Character)
  If *String\Len <= Length
    len = *String\Len
  Else
    len = Length
  EndIf
  *NewString = AllocateMemory(Length + SizeOf(Integer) + SizeOf(Character))
  If *NewString
    *Position = @*NewString\Char
    If len < Length
      cnt = Length - len
      FillMemory(*Position, cnt, Character, #PB_Character)
      *Position + cnt
    EndIf
    CopyMemory(@*String\Char, *Position, len)
    *NewString\Len = Length
  Else
    MessageRequester("Fatal Error", "Out Of Memory - Stop", #PB_MessageRequester_Error)
    End
  EndIf
  ProcedureReturn *NewString
EndProcedure

; ----

Procedure LCaseString(*String.udtFastString, Flags = 0)
  Protected len, index, *NewString.udtFastString
 
  If Flags = #PB_String_InPlace
    *NewString = *String
  Else
    *NewString = AllocateMemory(MemorySize(*String))
    If *NewString
      CopyMemory(*String, *NewString, MemorySize(*String))
    EndIf
  EndIf
 
  If *NewString
    len = *NewString\Len / SizeOf(Character)
    len - 1
    For index = 0 To len
      Select *NewString\Char[index]
        Case 65 To 90
          *NewString\Char[index] = *NewString\Char[index] + 32
        Case 192 To 222
          If *String\Char[index] = 208 Or *NewString\Char[index] = 215
            ; Do Nothing
          Else
            *NewString\Char[index] = *NewString\Char[index] + 32
          EndIf
      EndSelect
    Next
  Else
    MessageRequester("Fatal Error", "Out Of Memory - Stop", #PB_MessageRequester_Error)
    End
  EndIf
  ProcedureReturn *NewString
EndProcedure

Procedure UCaseString(*String.udtFastString, Flags = 0)
  Protected len, index, *NewString.udtFastString
 
  If Flags = #PB_String_InPlace
    *NewString = *String
  Else
    *NewString = AllocateMemory(MemorySize(*String))
    If *NewString
      CopyMemory(*String, *NewString, MemorySize(*String))
    EndIf
  EndIf
 
  If *NewString
    len = *String\Len / SizeOf(Character)
    len - 1
    For index = 0 To len
      Select *String\Char[index]
        Case 97 To 122
          *NewString\Char[index] = *String\Char[index] - 32
        Case 224 To 254
          If *String\Char[index] = 240 Or *String\Char[index] = 247
            ; Do Nothing
          Else
            *NewString\Char[index] = *String\Char[index] - 32
          EndIf
      EndSelect
    Next
  Else
    MessageRequester("Fatal Error", "Out Of Memory - Stop", #PB_MessageRequester_Error)
    End
  EndIf
  ProcedureReturn *NewString
EndProcedure

; ********

;- Examples

CompilerIf #PB_Compiler_IsMainFile
 
  Define *sVal1.udtFastString
  Define *sVal2.udtFastString
  Define *sVal3.udtFastString
 
  Define time, i, r1
 
  *sVal1 = AllocateString("* Hello String *")
  *sVal2 = AllocateString("[ * I like Purebasic * ]")
 
  Debug "ConcatString"
  *sVal1 = ConcatString(*sVal1, *sVal2)
  Debug "StringByteLen = " + *sVal1\len
  Debug GetString(*sVal1)
  Debug ""
 
  Debug "AddString * 100000"
  DisableDebugger
  time = ElapsedMilliseconds()
  For i = 1 To 100000
    *sVal1 = AddString(*sVal1, "x")
  Next
  r1 = ElapsedMilliseconds() -time
  EnableDebugger
  Debug "Time = " + r1 + " ms"
  Debug "Len = " + LenString(*sVal1)
  Debug ""
 
  *sVal1 = AddString(*sVal1, " End")
 
  Debug "InsertStringFast"
  *sVal1 = InsertStringFast(*sVal1, *sVal2, LenString(*sVal1) - 9)
  Debug "Len = " + LenString(*sVal1)
  Debug ""
 
  Debug "LeftString"
  *sVal3 = LeftString(*sVal1, 40)
  Debug GetString(*sVal3)
  Debug "Len = " + LenString(*sVal3)
  FreeString(*sVal3)
  Debug ""
 
  Debug "RightString"
  *sVal3 = RightString(*sVal1, 40)
  Debug GetString(*sVal3)
  Debug "Len = " + LenString(*sVal3)
  FreeString(*sVal3)
  Debug ""
 
  Debug "MidString"
  *sVal3 = MidString(*sVal1, 3, 5)
  Debug GetString(*sVal3)
  Debug "Len = " + LenString(*sVal3)
  FreeString(*sVal3)
  Debug ""
 
  Debug "LCaseString"
  FreeString(*sVal1)
  *sVal1 = AllocateString("Hello ÄÖÜ Á É Ó Ý")
  *sVal3 = LCaseString(*sVal1)
  Debug GetString(*sVal3)
  Debug "UCaseString in Place"
  UCaseString(*sVal3, #PB_String_InPlace)
  Debug GetString(*sVal3)
  FreeString(*sVal3)
  Debug ""
 
  Debug "LSetString"
  FreeString(*sVal1)
  *sVal1 = AllocateString("Hello World!")
  *sVal3 = LSetString(*sVal1, 40, 'x')
  Debug GetString(*sVal3)
  Debug "Len = " + LenString(*sVal3)
  FreeString(*sVal3)
  Debug ""
 
  Debug "RSetString"
  FreeString(*sVal1)
  *sVal1 = AllocateString("Hello World!")
  *sVal3 = RSetString(*sVal1, 40, 'x')
  Debug GetString(*sVal3)
  Debug "Len = " + LenString(*sVal3)
  FreeString(*sVal3)
  Debug ""
 
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ---------
; EnableXP