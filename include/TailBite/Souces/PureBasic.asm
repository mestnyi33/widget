; 
; PureBasic 5.31 (Windows - x86) generated code
; 
; (c) 2014 Fantaisie Software
; 
; The header must remain intact for Re-Assembly
; 
; Requester
; FileSystem
; Date
; Object
; SimpleList
; :System
; KERNEL32
; :Import
; 
format MS COFF
; 
; 
extrn _PB_FreeFileSystem@0
extrn _PB_InitRequester@0
extrn _PB_MessageRequester@8
extrn _ExitProcess@4
extrn _GetModuleHandleA@4
extrn _HeapCreate@12
extrn _HeapDestroy@4
extrn _memset
extrn Mul64
extrn PB_StringBase
extrn _SYS_InitString@0
extrn _SYS_FreeStrings@0
; 
extrn _PB_StringBasePosition
public _PB_Instance
public _PB_ExecutableType
public _PB_OpenGLSubsystem
public _PB_MemoryBase
public PB_Instance
public PB_MemoryBase
public _PB_EndFunctions

macro pb_public symbol
{
  public  _#symbol
  public symbol
_#symbol:
symbol:
}

macro    pb_align value { rb (value-1) - ($-_PB_DataSection + value-1) mod value }
macro pb_bssalign value { rb (value-1) - ($-_PB_BSSSection  + value-1) mod value }

public PureBasicStart
; 
section '.code' code readable executable align 4096
; 
; 
PureBasicStart:
; 
  PUSH   dword I_BSSEnd-I_BSSStart
  PUSH   dword 0
  PUSH   dword I_BSSStart
  CALL  _memset
  ADD    esp,12
  PUSH   dword 0
  CALL  _GetModuleHandleA@4
  MOV    [_PB_Instance],eax
  PUSH   dword 0
  PUSH   dword 4096
  PUSH   dword 0
  CALL  _HeapCreate@12
  MOV    [PB_MemoryBase],eax
  CALL  _SYS_InitString@0
  CALL  _PB_InitRequester@0
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
_PB_EOP_NoValue:
  PUSH   dword 0
_PB_EOP:
  CALL  _PB_EndFunctions
  CALL  _SYS_FreeStrings@0
  PUSH   dword [PB_MemoryBase]
  CALL  _HeapDestroy@4
  CALL  _ExitProcess@4
_PB_EndFunctions:
  CALL  _PB_FreeFileSystem@0
  RET
; 
; 
section '.data' data readable writeable
; 
_PB_DataSection:
_PB_OpenGLSubsystem: db 2
pb_public PB_DEBUGGER_LineNumber
  dd     -1
pb_public PB_DEBUGGER_IncludedFiles
  dd     0
pb_public PB_DEBUGGER_FileName
  db     0
pb_public PB_Compiler_Unicode
  dd     0
pb_public PB_Compiler_Thread
  dd     0
pb_public PB_Compiler_Purifier
  dd     0
pb_public PB_Compiler_Debugger
  dd     0
_PB_ExecutableType: dd 0
public _SYS_StaticStringStart
_SYS_StaticStringStart:
_S2: db "Done!",0
_S1: db "OK",0
pb_public PB_NullString
  db     0
public _SYS_StaticStringEnd
_SYS_StaticStringEnd:
align 4
F1: dd 1135869952
F2: dd -1011613696
F3: dd 1084227584
D1: dd 0,1079574528
align 4
align 4
s_s:
  dd     0
  dd     -1
align 4
; 
section '.bss' readable writeable
_PB_BSSSection:
align 4
; 
I_BSSStart:
_PB_MemoryBase:
PB_MemoryBase: rd 1
_PB_Instance:
PB_Instance: rd 1
; 
align 4
PB_DataPointer rd 1
align 4
align 4
align 4
align 4
I_BSSEnd:
section '.code' code readable executable align 4096
; ProcedureDLL.d double_test(angle.d) 
_Procedure8:
  PS8=12
  XOR    eax,eax
  PUSH   eax
  PUSH   eax
; 
; answer.d = angle * 100
  FLD    qword [esp+PS8+0]
  FMUL   qword [D1]
  FSTP   qword [esp]
; 
; ProcedureReturn answer
  FLD    qword [esp]
  JMP   _EndProcedure9
; 
; EndProcedure
  FLDZ
_EndProcedure9:
  ADD    esp,8
  RET    8
; ProcedureDLL ParameterProc(one) 
_Procedure16:
  PS16=8
  XOR    eax,eax
  PUSH   eax
; 
; ProcedureReturn ParameterProc_all(one, two)
  PUSH   dword [esp]
  PUSH   dword [esp+PS16+4]
  CALL  _Procedure14
  JMP   _EndProcedure17
; 
; EndProcedure
  XOR    eax,eax
_EndProcedure17:
  ADD    esp,4
  RET    4
; ProcedureDLL.q Quad_test(angle.q) 
_Procedure10:
  PUSH   ebx
  PS10=16
  XOR    eax,eax
  PUSH   eax
  PUSH   eax
; 
; answer.q = angle * 1000
  PUSH   dword [esp+PS10+0+4]
  PUSH   dword [esp+PS10+4]
  PUSH   dword 0
  PUSH   dword 1000
  PUSH   dword [esp+12]
  PUSH   dword [esp+12]
  CALL   Mul64
  MOV    [esp],eax
  MOV    [esp+4],edx
  POP    dword [esp+4]
  POP    dword [esp+4]
; 
; ProcedureReturn answer
  LEA    eax,[esp]
  MOV    edx,[eax+4]
  MOV    eax,[eax]
  JMP   _EndProcedure11
; 
; EndProcedure
  XOR    eax,eax
  XOR    edx,edx
_EndProcedure11:
  ADD    esp,8
  POP    ebx
  RET    8
; ProcedureDLL.f float_test(angle.f) 
_Procedure2:
  PS2=8
  XOR    eax,eax
  PUSH   eax
; 
; answer.f = angle * 5
  FLD    dword [esp+PS2+0]
  FMUL   dword [F3]
  FSTP   dword [esp]
; 
; ProcedureReturn answer 
  FLD    dword [esp]
  JMP   _EndProcedure3
; 
; EndProcedure
  FLDZ
_EndProcedure3:
  ADD    esp,4
  RET    4
; ProcedureDLL MemLib_HeapCreate(flOptions.l, dwInitialSize.i, dwMaximumSize.i)
_Procedure20:
  PS20=4
; 
; ProcedureReturn $1234
  MOV    eax,4660
  JMP   _EndProcedure21
; !public _Procedure0 as '_HeapCreate@12'
p.v_dwInitialSize equ esp+PS20+4
p.v_flOptions equ esp+PS20+0
p.v_dwMaximumSize equ esp+PS20+8
public _Procedure0 as '_HeapCreate@12'
; !public __imp__HeapCreate
public __imp__HeapCreate
; !__imp__HeapCreate:
__imp__HeapCreate:
; !dd _Procedure0
dd _Procedure0
; EndProcedure
  XOR    eax,eax
_EndProcedure21:
  RET    12
; ProcedureDLL.f Float_LimitTo360(angle.f) 
_Procedure0:
  PUSH   ebx
  PS0=8
; 
; While angle > 360
_While1:
  FLD    dword [esp+PS0+0]
  FCOMP  dword [F1]
  FNSTSW ax
  TEST   ah,41h
  JNE   _Wend1
; angle - 360
  FLD    dword [esp+PS0+0]
  FADD   dword [F2]
  FSTP   dword [esp+PS0+0]
; Wend
  JMP   _While1
_Wend1:
; 
; While angle < - 360
_While2:
  FLD    dword [esp+PS0+0]
  FCOMP  dword [F2]
  FNSTSW ax
  TEST   ah,1h
  JE    _Wend2
; angle + 360
  FLD    dword [esp+PS0+0]
  FADD   dword [F1]
  FSTP   dword [esp+PS0+0]
; Wend
  JMP   _While2
_Wend2:
; 
; ProcedureReturn angle
  FLD    dword [esp+PS0+0]
  JMP   _EndProcedure1
; 
; EndProcedure
  FLDZ
_EndProcedure1:
  POP    ebx
  RET    4
; ProcedureDLL integer_test(angle) 
_Procedure4:
  PUSH   ebx
  PS4=12
  XOR    eax,eax
  PUSH   eax
; 
; answer = angle *  10
  MOV    ebx,dword [esp+PS4+0]
  IMUL   ebx,10
  MOV    dword [esp],ebx
; ProcedureReturn answer
  MOV    eax,dword [esp]
  JMP   _EndProcedure5
; 
; EndProcedure
  XOR    eax,eax
_EndProcedure5:
  ADD    esp,4
  POP    ebx
  RET    4
; ProcedureDLL.f floatXfloat_test(angle.f) 
_Procedure6:
  PS6=8
  XOR    eax,eax
  PUSH   eax
; 
; answer.f = Float_LimitTo360(angle) *  float_test(angle)
  PUSH   dword [esp+PS6+0]
  CALL  _Procedure0
  PUSH   dword [esp+PS6+0]
  CALL  _Procedure2
  FMULP  st1,st0
  FSTP   dword [esp]
; 
; ProcedureReturn answer
  FLD    dword [esp]
  JMP   _EndProcedure7
; 
; EndProcedure
  FLDZ
_EndProcedure7:
  ADD    esp,4
  RET    4
; Procedure ParameterProc_all(one, two) 
_Procedure14:
  PUSH   ebx
  PS14=12
  XOR    eax,eax
  PUSH   eax
; 
; answer = one + two
  MOV    ebx,dword [esp+PS14+0]
  ADD    ebx,dword [esp+PS14+4]
  MOV    dword [esp],ebx
; ProcedureReturn answer
  MOV    eax,dword [esp]
  JMP   _EndProcedure15
; 
; EndProcedure
  XOR    eax,eax
_EndProcedure15:
  ADD    esp,4
  POP    ebx
  RET    8
; ProcedureDLL TestMe() 
_Procedure12:
  PS12=4
; 
; MessageRequester("OK","Done!")
  PUSH   dword _S2
  PUSH   dword _S1
  CALL  _PB_MessageRequester@8
; 
; EndProcedure
  XOR    eax,eax
_EndProcedure13:
  RET
; ProcedureDLL ParameterProc2(one, two) 
_Procedure18:
  PS18=4
; 
; ProcedureReturn ParameterProc_all(one, two)
  PUSH   dword [esp+PS18+4]
  PUSH   dword [esp+PS18+4]
  CALL  _Procedure14
  JMP   _EndProcedure19
; 
; EndProcedure
  XOR    eax,eax
_EndProcedure19:
  RET    8
section '.data' data readable writeable
SYS_EndDataSection:
