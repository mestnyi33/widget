Procedure WriteLog(Text.s,Close.l=#False)
  ; Name          WriteLog() 
  ; Date          22.8.2007 
  ; Author        ABBKlaus
  ; Description   Enable creating of TailBite_Logfile.txt and save it into TemporaryDirectory
  
  Static Logfile.l,LogfileStart.l
  
  If LogfileStart=0
    LogfileStart    = 1
    TailBiteLogFile = GetTemporaryDirectory()+"TailBite_Logfile.txt"
    If FileSize(TailBiteLogFile)>-1
      DeleteFile(TailBiteLogFile) ; Clear logfile
    EndIf
  EndIf
  If WriteLogfile=1
    If Logfile = 0
      Logfile=OpenFile(#PB_Any,TailBiteLogFile)
    EndIf
    If Logfile
      If Text
        WriteStringN(Logfile,Text)
      EndIf
      If Close=#True
        CloseFile(LogFile)
        Logfile=0
        LogfileStart=0
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure FindNextString(StringToFind$, Seeker, Limit)
  Protected direction.l
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    If StringToFind$ = #CRLF$;make it look for the linux eol instead
      StringToFind$=#LF$
    EndIf
  CompilerEndIf
  
  If Seeker<Limit:direction = 1:Else:direction = 0:EndIf
  If direction
    While PeekS(Seeker, Len(StringToFind$))<>StringToFind$ And Seeker<Limit
      Seeker+1
    Wend
  Else
    While PeekS(Seeker, Len(StringToFind$))<>StringToFind$ And Seeker>Limit
      Seeker-1
    Wend
  EndIf
  ProcedureReturn Seeker
EndProcedure

Procedure.s GetNextString(Seeker, Term$)
  Protected SeekerStart
  
  SeekerStart = Seeker
  While PeekS(Seeker, Len(Term$))<>Term$
    Seeker+1
  Wend
  ProcedureReturn LTrim(RTrim(PeekS(SeekerStart, Seeker-SeekerStart)))
EndProcedure

Procedure GetFileList(DirName$, DirID, ExcludeFolder$)
  Protected Type.l,DName$
  
  If ExamineDirectory(DirID, DirName$, "")
    While NextDirectoryEntry(DirID)
      Type=DirectoryEntryType(DirID)
      If Type=#PB_DirectoryEntry_Directory
        If DirectoryEntryName(DirID)<>"." And DirectoryEntryName(DirID)<>".."And DirectoryEntryName(DirID)<>".svn" And Len(DirectoryEntryName(DirID))>0
          DName$ = DirName$+DirectoryEntryName(DirID)+#DirSeparator
          If LCase(DName$)<>LCase(ExcludeFolder$)
            AddElement(DirList())
            DirList() = DName$
            GetFileList(DirList(), DirID+1, ExcludeFolder$)
          Else
            Debug "Exclude:"+DName$
          EndIf
        EndIf
      ElseIf Type=#PB_DirectoryEntry_File
        If DirectoryEntryName(DirID)<>"." And DirectoryEntryName(DirID)<>".." And Len(DirectoryEntryName(DirID))>0
          AddElement(FileList())
          FileList() = DirName$+DirectoryEntryName(DirID)
        EndIf
      EndIf
    Wend
    FinishDirectory(DirID) ; ABBKlaus 18.12.2007 21:37
  EndIf
EndProcedure

Procedure.s SearchDirectory(Dir$,File$,Mode.l=0)
  Protected Dir,Found$=""
  Debug "Inc_Taibite > SearchDirectory(Dir$="+Dir$+",File$="+File$+")"
  
  Dir=ExamineDirectory(#PB_Any,Dir$,"*.*")
  If Dir
    While NextDirectoryEntry(Dir)
      Debug DirectoryEntryName(Dir)
      If DirectoryEntryType(Dir) = #PB_DirectoryEntry_File
        If Mode & #PB_String_NoCase
          If LCase(DirectoryEntryName(Dir)) = LCase(File$)
            Found$=Dir$+DirectoryEntryName(Dir)
            Break
          EndIf
        Else
          If DirectoryEntryName(Dir) = File$
            Found$=Dir$+DirectoryEntryName(Dir)
            Break
          EndIf
        EndIf
      Else
        If DirectoryEntryName(Dir)<>"." And DirectoryEntryName(Dir)<>".."
          Found$=SearchDirectory(Dir$+DirectoryEntryName(Dir)+#DirSeparator,File$,Mode)
          If Found$<>""
            Break
          EndIf
        EndIf
      EndIf
    Wend
    FinishDirectory(Dir)
  EndIf
  
  ProcedureReturn Found$
EndProcedure
; IDE Options = PureBasic 5.10 (Windows - x86)
; CursorPosition = 90
; FirstLine = 75
; Folding = -