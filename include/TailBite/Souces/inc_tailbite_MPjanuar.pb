If PBnbVersion>524
  
   IndexSeeker = FindNextString("_Procedure", *FileSeeker, FileEnd)+Len("_Procedure")
   FIndex = Val(GetNextString(IndexSeeker, ":")) 
        
Else       
   
   IndexSeeker = FindNextString("macro MP", *FileSeeker, FileEnd)+Len("macro MP")
   FIndex = Val(GetNextString(IndexSeeker, "{"))   
        
EndIf
 
If PBnbVersion>524
  
   IndexSeeker = FindNextString("_Procedure", *FileSeeker, FileEnd)+Len("_Procedure")
   ProcEnd$ = #SystemEOL;+"}"
       
Else       
   
    FileSeeker = FindNextString("macro MP", FileSeeker, FileEnd)+Len("macro MP")
    ProcEnd$ = #SystemEOL+"}"
        
EndIf
 
Zeile 489 
 
"  RET"

;MP Jan 2015
If PBnbVersion>524
  
   While PeekS(*FileSeeker, 5+(2*Len(#SystemEOL)))<>#SystemEOL+"  RET"+#SystemEOL
  
Else   
 
          ;MP Jan 2015
          ;While PeekS(*FileSeeker, 1+(2*Len(#SystemEOL)))<>#SystemEOL+"}"+#SystemEOL
   While PeekS(*FileSeeker, 1+(2*Len(#SystemEOL)))<>#SystemEOL+"}"+#SystemEOL
EndIf
          

#SystemEOL = #LF$ 

Debug "26 ProcEnd = "+PeekS(ProcEnd, 20)+" * * * * *"


FileSeeker = FileStart

"C:\Users\KillerMP\AppData\Local\Temp\TBTemp\"


21 PeekS(FileSeeker, 20) = 2682{
PB_EP_2DSprit * * * * *
22 PeekS(FileSeeker, 20) = PB_EP_2DSpritesDraw: * * * * *
23 PeekS(FileSeeker, 20) = ; EndProcedure
XOr  * * * * *
24 PeekS(FileSeeker, 20) = 
}

21 PeekS(FileSeeker, 20) = P_EntityGetX_all (En * * * * *
22 PeekS(FileSeeker, 20) = PB_MP_EntityGetTrian * * * * *
23 PeekS(FileSeeker, 20) = ; EndProcedure
FLDZ * * * * *
24 PeekS(FileSeeker, 20) = 
FLDZ
_EndProcedur * * * * *



}
; 
; Procedure D3D9_OpenWindowedScreen(Window, x, y, Width, Height, Title.s, WindowFlags = #PB_Window_ScreenCentered | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget | #PB_Window_TitleBar) 
Macro MP556{
  _Procedure556:
  
  
  
 RET    8
; ProcedureDLL MP_TextSetZ(z.f) 
_Procedure720:
  PUSH   ebp
  
  
    Structure LibFunction
    ID.l
    Name$
    ProcedureFullLine$
    PlainName$
    Args$
    nArgs.l
    maxArgs.l
    HelpLine$
    RetValue$
    DLLFunction.l
    Main.l
    DebugFunction.l
    nModifiers.l
    Modifiers$
    FIndex.l
    VarArgs$
    VarArgStr$
    VarHelpStr$
    floatreturnfound.l

  EndStructure

        Debug "27 Filename = "+ DestFolder$+"Functions"+#DirSeparator+FileString$

      ForEach function()
        
        Debug "Start"
        Debug function()\FIndex
        Debug function()\Name$
        Debug function()\ProcedureFullLine$
        Debug function()\RetValue$

      Next
      
        Structure ExternLib
    Name$
    FullPath$
    Type$
    nFunctions.l
    nocompile.l
  EndStructure
  
      ForEach label()
         Debug "Start"
         Debug label()\LabelName.s
         Debug label()\FunctionName.s
      Next
      End
  
      
      ForEach label()
         Debug "Start"
         Debug label()\Name$
         Debug label()\FullPath$
         Debug label()\Type$
         Debug label()\nFunctions
         Debug label()\nocompile
      Next
      
      End
      MP_Createcube
      
      
      l_mp_createcube_cubedata:
      
      
      MP_CreateParticleEmitter_all.asm
      
      MP3D_Library_ll_mp_createparticleemitter_all_binstart:
      
      
      63
      
        If FindString(Function$,LibName$+decoration+"_l_",1)
    Debug "ExternalProc("+Function$+","+Str(Index)+")"
    ;-* bugfix for labels in PB5.10
    ForEach Labels_Define()
      If FindString(Function$,Labels_Define()\LabelName,1)
        Function$=ReplaceString(Function$,Labels_Define()\LabelName,Labels_Define()\FunctionName)
        Break
      EndIf
    Next
    
    Alreadythere=0
    ForEach Label()
      If FindString(Function$,Label()\LabelName,1) And Label()\FunctionName=Function()\Name$ 
        Alreadythere=1
        Break
      EndIf
    Next
    If Alreadythere=0
      include=1
    EndIf
  Else
    If FindString(Function$," ",1) Or FindString(Function$,"[",1) ; Or Function$=Function()\Name$
      include=0
    Else
      include=1
    EndIf
  EndIf
  
  
    Debug "ThisLine$" 
    Debug "!"+ThisLine$ + "! => " + Str(Len(ThisLine$))
    
    If ThisLine$ = "FSTP   dword [rsp-8]"
      Debug " <- Won ->" + PeekS(FileSeeker+1,20)
      PokeS(FileSeeker+1,";;;;;;")
    EndIf
     
    ;  MOVSD  xmm0,[rsp-8]
    
  
  
  
      *delSeeker = FileStart
      *delSeeker = FindNextString("FSTP   qword [rsp-8]", *delSeeker, FileEnd)
      While *delSeeker<FileEnd 
            
        Debug *delSeeker
        CallDebugger
        
        PokeS(*delSeeker,";STP   qword [rsp-8]")
         *delSeeker = FindNextString("FSTP   qword [rsp-8]", *delSeeker, FileEnd)
      Wend
      
      *delSeeker = FileStart
      *delSeeker = FindNextString("MOVSD  xmm0,[rsp-8]", *delSeeker, FileEnd)
      While *delSeeker<FileEnd 
         PokeS(*delSeeker,";OVSD  xmm0,[rsp-8]")
         *delSeeker = FindNextString("MOVSD  xmm0,[rsp-8]", *delSeeker, FileEnd)
      Wend
      ;FSTP   qword [rsp-8]
      ;MOVSD  xmm0,[rsp-8]
      
      
      
      
       *delSeeker = FileStart
      *delSeeker = FindNextString("FSTP   qword [rsp-8]", *delSeeker, FileEnd)
      While *delSeeker<FileEnd 
        
        PokeS(*delSeeker, ";STP   qword [rsp-8]")
            
        Debug PeekS(*delSeeker, 21)
        CallDebugger
 ;       PokeS(*delSeeker,"                    ")
         *delSeeker = FindNextString("FSTP   qword [rsp-8]", *delSeeker+21, FileEnd)
      Wend
; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 223
; FirstLine = 175
; Folding = -
; EnableXP