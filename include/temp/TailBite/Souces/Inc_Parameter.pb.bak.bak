Procedure Init_Parameter()
  Protected nPars = CountProgramParameters(), prefFile.s
  
  ;{ Enable the LogFile writing
  CompilerIf #PB_Compiler_Debugger = #True
    WriteLogfile  = #True
  CompilerEndIf
  ;}
  
  CompilerIf Defined(TB_Testmode,#PB_Constant)
    AddElement(Parameter()) : Parameter()=#TB_TestFile$
    AddElement(Parameter()) : Parameter()="/KEEP"
    AddElement(Parameter()) : Parameter()="/WRIT"
    ;AddElement(Parameter()) : Parameter()="/HELP"
    ;AddElement(Parameter()) : Parameter()="/ASKD"
    CompilerIf Defined(TB_TestSubsystem$,#PB_Constant)=1
      AddElement(Parameter()) : Parameter()="/SUBS:"+#TB_TestSubsystem$
    CompilerEndIf
    CompilerIf Defined(TB_TestTHRD,#PB_Constant)=1
      AddElement(Parameter()) : Parameter()="/THRD"
    CompilerEndIf
    CompilerIf Defined(TB_TestUCOD,#PB_Constant)=1
      AddElement(Parameter()) : Parameter()="/UCOD"
    CompilerEndIf
    CompilerIf Defined(TB_TestMULT,#PB_Constant)=1
      AddElement(Parameter()) : Parameter()="/MULT"
    CompilerEndIf
    CompilerIf Defined(TB_TestDONT, #PB_Constant)=1
      AddElement(Parameter()) : Parameter()="/DONT"
    CompilerEndIf
    CompilerIf Defined(TB_TestCHM, #PB_Constant)=1
      AddElement(Parameter()) : Parameter()="/CHM:"+#TB_TestCHM
    CompilerEndIf
    ;AddElement(Parameter())  : Parameter()="/LIBN:test"
    ;AddElement(Parameter())  : Parameter()="/OUTP"
    ;AddElement(Parameter())  : Parameter()="C:\"
    ;AddElement(Parameter())  : Parameter()="/LOGF"
    CompilerIf Defined(TB_TestPref, #PB_Constant)
      UseUserPrefsFile = 1
      TBPrefsFile$ = #TB_TestPref
    CompilerEndIf
    Debug #TB_TestFile$
  CompilerEndIf
  
  While nPars>0
    AddElement(Parameter())
    Parameter() = ProgramParameter()
    ; enable logfile if /LOGFile or /KEEPsources is found
    If UCase(Left(Parameter(), 5))="/LOGF" Or UCase(Left(Parameter(), 5))="/KEEP"
      WriteLogfile=1 ; create logfile ABBKlaus 23.8.2007 20:30
    ElseIf UCase(Left(Parameter(), 5))="/PREF"
      prefFile = ProgramParameter();-if Pref filename parameter is not a (valid) filename, it is discarded. i.e. "/PREF /UCOD" : /UCOD will be discarded (unless it counts as a valid path)
      If GetPathPart(prefFile);if its not a valid filename, no point in setting it.
        UseUserPrefsFile = 1
        TBPrefsFile$ = prefFile
      EndIf
    EndIf
    nPars-1
  Wend
  
  ; Save all parameters to logfile
  ForEach Parameter()
    WriteLog("Parameter() :"+Parameter())
  Next
  
  SourceExists = 0
  If ListSize(Parameter())>0
    SelectElement(Parameter(), 0)
    If Parameter()=""
      If ListSize(Parameter())>1
        SelectElement(Parameter(), 1)
      EndIf
    EndIf
    ;MessageRequester("Source", Parameter())
    ;lexvictory removed 06/02/2009 - does not work with linux paths
    ;If Left(Parameter(), 1)<>#DirSeparator
      If FileSize(Parameter())<>-1
        SourceExists = 1
      EndIf
    ;EndIf
  EndIf
  
EndProcedure
; IDE Options = PureBasic 5.24 LTS (Windows - x86)
; CursorPosition = 9
; Folding = --