Procedure.s WrapEnableDir(text.s, width);force long dir/file names to wrap by adding spaces after the \ or / for the last 2 / or \
  Protected processed.s = ""
  Protected numDirSeps, i
  If StartDrawing(WindowOutput(#TBW))
    If TextWidth(text) > (width-10)
      numDirSeps = CountString(text, #DirSeparator)
      For i = 1 To numDirSeps + 1
        If i = (numDirSeps+1)
          processed + StringField(text, i, #DirSeparator)
        Else 
          processed + StringField(text, i, #DirSeparator)+#DirSeparator
          If i >= (numDirSeps-2)
            processed+" "
          EndIf
        EndIf 
      Next i
    Else
      processed = text
    EndIf 
    StopDrawing()
    Debug text
    Debug processed
    ProcedureReturn processed
  Else 
    ProcedureReturn text 
  EndIf
EndProcedure

Procedure SetExtrastatustext()
  Protected extrastatustext.s,homedir$
  extrastatustext = ReplaceString(Language("TBManager", "PBFolder"), "PureBasic", "PB")+" "+WrapEnableDir(PBFolder$, GadgetWidth(#extra_status))+#SystemEOL+Language("TailBite", "PBVersion")+" "
  If PBVersionX64
    extrastatustext + Left(PBVersion$, 5)+" x64"
  Else
    extrastatustext + Left(PBVersion$, 5)+" x86"
  EndIf
  extrastatustext + #SystemEOL+"TB Prefs: "
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    If FindString(TBPrefsFile$, GetEnvironmentVariable("APPDATA"), 1)
      extrastatustext+"AppData\Tailbite"+#DirSeparator+GetFilePart(TBPrefsFile$)
  CompilerElse
    homedir$ = GetEnvironmentVariable("HOME")
    If Right(homedir$, 1) <> "/" : homedir$+"/" : EndIf 
    If FindString(TBPrefsFile$, homedir$+".tailbite", 1)
      extrastatustext+"~/.tailbite"+#DirSeparator+GetFilePart(TBPrefsFile$)
  CompilerEndIf
  Else
    extrastatustext+WrapEnableDir(TBPrefsFile$, GadgetWidth(#extra_status))
  EndIf
  extrastatustext+#SystemEOL+"ThreadSafe: "+Str(UseThreadOption)+" Unicode: "+Str(UseUnicodeOption)+#SystemEOL
  extrastatustext+"Subsystem: "+PBSubsystem$+#SystemEOL
  extrastatustext+Language("TailBite", "SourceFile")+" "+WrapEnableDir(PBSourceFile$, GadgetWidth(#extra_status))
  SetGadgetText(#extra_status,extrastatustext)
EndProcedure

Procedure ExternalProc(Function$,Index.l,decoration.s)
  Protected include.l=0,Label.l=0,Alreadythere.l=0
  
   Debug "ExternalProc("+Function$+","+Str(Index)+")"
  ;CallDebugger
  
  ; bugfix decoration missing in labelname ABBKlaus 18.02.2011 18:00
   If FindString(Function$,LibName$+decoration+"_l_",1) Or FindString(Function$,LibName$+decoration+"_ll_",1)
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
  
  If include
    AddElement(external())
    If Index=0
      external() = Function$
    ElseIf Index=1 ; do not extrn label
      external() = StringField(Function$, 1, " ")
    ElseIf Index=2 ; aligngosub
      ; bugfix aligngosub (found by lexvictory) ABBKlaus 11.1.2009 15:04
      external() = Function$
    EndIf
    
    ;Debug "Extrn -> "+external()
  EndIf
EndProcedure

Procedure.s ModifierProc(Text.s)
  ;ABBKlaus 21.4.2008
  ;Detect if modifiers are present and capitalize them correctly
  ;i.e. _thread = _THREAD
  
  Protected Pos.l,Max.l,Us.l,i.l,modifier$
  
  Max=FindString(Text,"(",1)
  If Max=0
    Us=CountString(Text,"_")
    Max=Len(Text)
  Else
    Us=CountString(StringField(Text,1,"("),"_")
    Max-1
  EndIf
  
  If Us
    Pos=0
    For i=1 To Us
      Pos=FindString(Text,"_",Pos)+1
    Next
    Pos-1
    Restore Modifiers
    Read i
    While i>0
      Read.s modifier$
      If LCase(Mid(Text,Pos+1,Max-Pos))=modifier$
        Text=Left(Text,Pos)+UCase(modifier$)+Right(Text,Len(Text)-Pos-Len(modifier$))
        Break
      EndIf
      i-1
    Wend
  EndIf
  
  ProcedureReturn Text
EndProcedure

Procedure IsImportFunc(Function$)
  Function$ = Trim(RemoveString(RemoveString(Function$, "call"), "extrn"))
  ForEach ImportFunction()
    If LCase(ImportFunction()\Name$) = Function$
      ProcedureReturn 1
    EndIf
  Next
  ProcedureReturn 0
EndProcedure
 
Procedure CreateFunctionList(FileStart, FileEnd)
  Protected *FileSeeker.SK,ModifiersPresent.l,*PathSK,*PathStart,*PathEnd,Found.l,DLLName$,AlreadyThere.l
  Protected comment.l,ThisLine$,cpos.l,hpos.l,rv$,ipos.l,NextSeeker.l,IndexSeeker.l,FIndex.l,DLLFunction.l
  Protected RetValue$,Args$,FunctionNameStart.l,Name$,ArgStart.l,QuitBrackers.l,ArgString$,i.l,NewArg$
  Protected ArgPart$,nArgs.l,HelpLine$,PlainNameNM$,PlainNameND$,VarArgsPresent.l,PlainName$,LnNum.l,NumbNum.l
  Protected FNIndex.l,FArgs.l,ArgStr$,ArgsPart$,ShortPlainName$,count.l,newVarHelpStr$,temp$,BetweenBrackets$
  Protected AfterBrackets$,newHelpLine$,NVars.l,LastArgs.l,lpos.l,p.l,LeftPart$,rpos.l,MidPart$,RightPart$,FName$
  Protected ThisMod$,NewMod$,InitExists.l,*StartOfLine,ProcedureFullLine$,PBSourceStream,FoundQuickHelp,PBSourceStreamLine$,PBSourceStringFormat
  
  
  
  Debug "Inc_Taibite > CreateFunctionList()"
  WriteLog("Inc_Taibite > CreateFunctionList()")
  
  *FileSeeker = FileStart
  ModifiersPresent = 0
  ClearList(function())
  While *FileSeeker<FileEnd
    If (UCase(PeekS(*FileSeeker, 9))="; IMPORT " Or UCase(PeekS(*FileSeeker, 10))="; IMPORTC ") 
      AddElement(ImportLib())
      If UCase(PeekS(*FileSeeker, 10))="; IMPORTC "
        ImportLib()\Type$ = "CDecl"
        *PathSK = *FileSeeker+10
      Else
        ImportLib()\Type$ = "StdCall"
        *PathSK = *FileSeeker+9
      EndIf
      *PathStart=FindNextString(#DQUOTE$,*PathSK,FileEnd)+1
      *PathEnd=FindNextString(#DQUOTE$,*PathStart,FileEnd)
      If (*PathEnd-*PathStart)<256
        ImportLib()\FullPath$ = PeekS(*PathStart,*PathEnd-*PathStart)
        ;if lib is present in current path ABBKlaus 9.6.2007 01:25
        If GetPathPart(ImportLib()\FullPath$)="" And FileSize(GetPathPart(PBSourceFile$)+ImportLib()\FullPath$)<>-1
          ImportLib()\FullPath$=GetPathPart(PBSourceFile$)+ImportLib()\FullPath$
        EndIf
      EndIf
      If *PathEnd-*PathStart = 0;is an Import "" used to get at pb internals - lexvictory 22/02/09
        ImportLib()\nocompile = 1
      EndIf
      ImportLib()\Name$ = GetFilePart(ImportLib()\FullPath$)
      If ImportLib()\FullPath$=ImportLib()\Name$
        ImportLib()\FullPath$ = GetCurrentDirectory()
        If Right(ImportLib()\FullPath$, 1)<>#DirSeparator:ImportLib()\FullPath$+#DirSeparator:EndIf
        ImportLib()\FullPath$+ImportLib()\Name$
        ;Bugfix ImportLib not found ABBKlaus 15.4.2007 22:59
        If FileSize(ImportLib()\FullPath$)<0
          NewList LibDirs.s()
          AddElement(LibDirs())
          CompilerIf #PB_Compiler_OS = #PB_OS_Windows
            LibDirs()=PBFolder$+"PureLibraries\Windows\Libraries"+#DirSeparator
          CompilerElse
            CompilerIf #PB_Compiler_OS = #PB_OS_Linux
              LibDirs()=PBFolder$+"purelibraries/linux/libraries/"
            CompilerElse
              LibDirs()=PBFolder$+"purelibraries/macos/libraries/"
            CompilerEndIf
          CompilerEndIf
          ;LibDirs()=PBFolder$+"Compilers"+#DirSeparator
          Found=0
          ForEach LibDirs()
            If FileSize(LibDirs()+ImportLib()\Name$)>0
              ;PBLib found
              ;add to DLLList()
              DLLName$=RemoveString(UCase(ImportLib()\Name$),".LIB")+".DLL"
              AlreadyThere = 0
              ForEach DLLList()
                If UCase(DLLList())=UCase(DLLName$)
                  AlreadyThere = 1
                  Break
                EndIf
              Next
              If AlreadyThere = 0
                AddElement(DLLList())
                DLLList()=DLLName$
              EndIf
              ImportLib()\FullPath$=LibDirs()+ImportLib()\Name$
              ImportLib()\nocompile=1 ; to avoid Polib warning remove all PB libs
              Break
            EndIf
          Next
          If Found=0 ; Bugfix for internal libs like 'window.lib' ABBKlaus 18.12.2007 1:05
            ImportLib()\nocompile=1
          EndIf
        EndIf
      EndIf
      *FileSeeker = FindNextString(#SystemEOL, *PathSK, FileEnd)+Len(#SystemEOL)
      While *FileSeeker<FileEnd And UCase(PeekS(*FileSeeker, 11))<>"; ENDIMPORT"
        comment = 0
        ThisLine$ = GetNextString(*FileSeeker, #SystemEOL)
        cpos = FindString(ThisLine$, ";", 2)
        If cpos
          If Trim(Mid(ThisLine$, 2, cpos-1))=""
            comment = 1
          EndIf
        EndIf
        If comment=0
          AddElement(ImportFunction())
          ImportFunction()\LibPath$ = ImportLib()\FullPath$
          ImportFunction()\Type$ = ImportLib()\Type$
          If cpos
            ImportFunction()\HelpLine$ = Right(ThisLine$, Len(ThisLine$)-cpos)
          Else
            cpos = Len(ThisLine$)
          EndIf
          hpos = FindString(ThisLine$, "(", 1)
          If hpos
            ImportFunction()\NewName$ = StringField(Trim(Mid(ThisLine$, 2, hpos-2)), 1, ".")
            rv$ = StringField(Trim(Mid(ThisLine$, 2, hpos-2)), 2, ".")
            If Len(rv$)>0
              Select rv$
                Case "b":
                  ImportFunction()\RetValue$ = "Byte"
                Case "w":
                  ImportFunction()\RetValue$ = "Word"
                Case "l":
                  ImportFunction()\RetValue$ = "Long"
                ;Case "i":
                ;  ImportFunction()\RetValue$ = "Integer"
                Case "f":
                  ImportFunction()\RetValue$ = "Float"
                Case "q":
                  ImportFunction()\RetValue$ = "Quad"
                Case "d":
                  ImportFunction()\RetValue$ = "Double"
                Case "s":
                  ImportFunction()\RetValue$ = "String"
                Default
                  ;If PBnbVersion>=430
                  ;  ImportFunction()\RetValue$ = "Integer"
                  ;Else
                    ImportFunction()\RetValue$ = "Long"
                  ;EndIf
              EndSelect
            Else
              ;If PBnbVersion>=430
              ;  ImportFunction()\RetValue$ = "Integer"
              ;Else
                ImportFunction()\RetValue$ = "Long"
              ;EndIf
            EndIf
            ipos = FindString(ThisLine$, ")", hpos)
            If ipos
              ImportFunction()\Args$ = Trim(Mid(ThisLine$, hpos, ipos-hpos))
              hpos = FindString(ThisLine$, " As ", ipos)
              If hpos
                ImportFunction()\Name$ = RemoveString(Trim(Mid(ThisLine$, hpos+4, cpos-(hpos+4))), #DQUOTE$)
              Else
                ImportFunction()\Name$ = ImportFunction()\NewName$
              EndIf
              ImportLib()\nFunctions+1
            Else
              DeleteElement(ImportFunction())
            EndIf
          Else
            DeleteElement(ImportFunction())
          EndIf
        ElseIf UCase(PeekS(*FileSeeker, 11))="; ENDIMPORT"
          *FileSeeker = FindNextString(#SystemEOL, *FileSeeker, FileEnd)+Len(#SystemEOL)
          Break
        EndIf
        *FileSeeker = FindNextString(#SystemEOL, *FileSeeker, FileEnd)+Len(#SystemEOL)
      Wend
    EndIf
    NextSeeker = FindNextString(#SystemEOL, *FileSeeker, FileEnd)
    If UCase(PeekS(*FileSeeker, 11))="; PROCEDURE" And PeekS(*FileSeeker-Len(#SystemEOL), Len(#SystemEOL))=#SystemEOL And PeekB(NextSeeker+Len(#SystemEOL))<>';' And *FileSeeker<FileEnd
      *StartOfLine = *FileSeeker
      CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
        
        ;-MP Jan 2015
        If PBnbVersion>=531
          
            Debug "-start"
            Debug "FIndex PeekS(*FileSeeker, 40) = "+PeekS(*FileSeeker, 40)+" * * * * *"
            IndexSeeker = FindNextString(Chr(10)+"_Procedure", *FileSeeker, FileEnd)+Len(Chr(10)+"_Procedure")
            FIndex = Val(GetNextString(IndexSeeker, ":")) 
            
            
            Debug "FIndex PeekS(IndexSeeker, 40) = "+PeekS(IndexSeeker, 40)+" * * * * *"
            
            
            
        Else       
   
            IndexSeeker = FindNextString("macro MP", *FileSeeker, FileEnd)+Len("macro MP")
            FIndex = Val(GetNextString(IndexSeeker, "{"))   
        
        EndIf
        ;-MP Jan 2015
        ; IndexSeeker = FindNextString("macro MP", *FileSeeker, FileEnd)+Len("macro MP")
        ; FIndex = Val(GetNextString(IndexSeeker, "{"))   
        ;        
      CompilerElse 
        
        IndexSeeker = FindNextString("%macro MP", *FileSeeker, FileEnd)+Len("%macro MP")
        FIndex = Val(GetNextString(IndexSeeker, " 0"+#SystemEOL))
        
      CompilerEndIf
      
      *FileSeeker = FindNextString("; Procedure", IndexSeeker, FileStart)
      
      Debug "*FileSeeker = "+Str(*FileSeeker)+" * * *"
      Debug "01 PeekS(*FileSeeker, 20) = "+PeekS(*FileSeeker, 20)+" * * * * *"
      *FileSeeker+11
      Debug "02 PeekS(*FileSeeker, 20) = "+PeekS(*FileSeeker, 20)+" * * * * *"
      
      DLLFunction = 0
      ;CallDebugger
      If UCase(PeekS(*FileSeeker, 3))="DLL"
        *FileSeeker+3
        DLLFunction = 1
      ElseIf UCase(PeekS(*FileSeeker, 4))="CDLL"
        *FileSeeker+4
        DLLFunction = 1
      EndIf
      If *FileSeeker\b='.'
        *FileSeeker+1
        Select *FileSeeker\b;-dll func return type examine
          Case 'b'
            RetValue$ = "Byte"
          Case 'w'
            RetValue$ = "Word"
          Case 'l'
            RetValue$ = "Long"
          ;Case 'i'
          ;  RetValue$ = "Integer"
          Case 'f'
            RetValue$ = "Float"
          Case 'q'
            RetValue$ = "Quad"
          Case 'd'
            RetValue$ = "Double"
          Case 's'
            RetValue$ = "String"
          Default
            ;If PBnbVersion>=430
            ;  RetValue$ = "Integer"
            ;Else
              RetValue$ = "Long"
            ;EndIf
        EndSelect
        *FileSeeker+1
      ElseIf *FileSeeker\b=' '
        RetValue$ = "None"
      ElseIf *FileSeeker\b='$'
        RetValue$ = "String"
        *FileSeeker+1
      Else
        RetValue$ = ""
      EndIf
      
      Debug "03 PeekS(*FileSeeker, 20) = "+PeekS(*FileSeeker, 20)+" * * * * *"
      
      If RetValue$<>""
        Args$ = ""
        While *FileSeeker\b=' '
          *FileSeeker+1
          If *FileSeeker>=FileEnd
            TBError(Language("TailBite","FileEndErr1"), 1, TBTempPath$)
            CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
          EndIf
        Wend
        FunctionNameStart = *FileSeeker
        While *FileSeeker\b<>'('
          *FileSeeker+1
          If *FileSeeker>=FileEnd
            TBError(Language("TailBite","FileEndErr2"), 1, TBTempPath$)
            CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
          EndIf
        Wend
        Name$ = RTrim(PeekS(FunctionNameStart, *FileSeeker-FunctionNameStart))
        *FileSeeker+1
        ArgStart = *FileSeeker
        ; Fix detection of a linked list Progi1984 03/19/08 17:25
        QuitBrackers = 0
        While *FileSeeker\b<>')' Or QuitBrackers<>0
          If *FileSeeker\b = '('  : QuitBrackers + 1 : EndIf
          If *FileSeeker\b = ')'  : QuitBrackers - 1 : EndIf
          *FileSeeker+1
          If *FileSeeker>=FileEnd
            TBError(Language("TailBite","FileEndErr3"), 1, TBTempPath$)
            CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
          EndIf
        Wend
        ArgString$ = Trim(PeekS(ArgStart, *FileSeeker-ArgStart))
        If ArgString$<>""
          i = 1
          While Trim(StringField(ArgString$, i, ","))<>""
            NewArg$=""
            ArgPart$ = Trim(StringField(Trim(StringField(ArgString$, i, ",")), 1, "="))
            Select Trim(StringField(ArgPart$, 2, "."))
              Case "b"
                NewArg$ = ", Byte"
              Case "w"
                NewArg$ = ", Word"
              Case "l"
                NewArg$ = ", Long"
              ;Case "i"
              ;  NewArg$ = ", Integer"
              Case "f"
                NewArg$ = ", Float"
              Case "q"
                NewArg$ = ", Quad"
              Case "d"
                NewArg$ = ", Double"
              Case "s"
                NewArg$ = ", String"
              Default
                If Right(ArgPart$, 1)="$"
                  NewArg$ = ", String"
                  ;ElseIf Right(ArgPart$, 2)="()"
                  ;  NewArg$ = ", LinkedList"
                ElseIf LCase(Left(ArgPart$,6))="array "
                  ;NewArg$ = ", Array" ; <- PB bug when Array is put into *.desc 'PUSH   dword [a_teste]'
                  NewArg$ = ", Long" ; <- for now its easier to handle, just hold the pointer to the array in a variable and put @varname in the call to the procedure
                ElseIf LCase(Left(ArgPart$,5))="list "
                  NewArg$ = ", LinkedList"
                ElseIf LCase(Left(ArgPart$,4))="map "
                  NewArg$ = ", Map"
                Else
                  ;If PBnbVersion>=430
                  ;  NewArg$ = ", Integer"
                  ;Else
                    NewArg$ = ", Long"
                  ;EndIf
                EndIf
            EndSelect
            ;If Right(Trim(StringField(ArgPart$, 2, ".")), 2) = "()"
            ;  NewArg$ = ", LinkedList"
            ;EndIf
            Args$ + NewArg$
            i+1
          Wend
          nArgs = i-1
        Else
          nArgs = 0
        EndIf
        *FileSeeker+1
        ProcedureFullLine$ = Trim(Mid(PeekS(*StartOfLine,  *FileSeeker - *StartOfLine),2))
        HelpLine$ = "("+ArgString$+")"
        While PeekS(*FileSeeker, Len(#SystemEOL))<>#SystemEOL
          If *FileSeeker\b=';'
            HelpLine$+" - "+GetNextString(*FileSeeker+1, #SystemEOL)
            *FileSeeker = FindNextString(#SystemEOL, *FileSeeker, FileEnd)
          Else
            *FileSeeker+1
          EndIf
        Wend
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
          While PeekS(*FileSeeker, 9+(2*Len(#SystemEOL)))<>#SystemEOL+"%endmacro"+#SystemEOL
                     If PeekS(*FileSeeker, 18)="; ProcedureReturn " And RetValue$="None"
            ;If PBnbVersion>=430
            ;  RetValue$="Integer"
            ;Else
              RetValue$="Long"
            ;EndIf
          EndIf
          *FileSeeker+1
          If *FileSeeker>=FileEnd
            TBError(Language("TailBite","FileEndErr4"), 1, TBTempPath$)
            CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
          EndIf
          
          Wend
        CompilerElse
          
          ;MP Jan 2015
          If PBnbVersion>=531
            
             *FileSeeker = FindNextString("RET", *FileSeeker, FileEnd)
             *FileSeeker = FindNextString(#SystemEOL, *FileSeeker, FileEnd)
             
             If RetValue$="None"
             ;  RetValue$="Integer"
                RetValue$="Long"
             EndIf  
               
             If *FileSeeker>=FileEnd
                TBError(Language("TailBite","FileEndErr4"), 1, TBTempPath$)
                CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
             EndIf
               
  
          Else  
          
          While PeekS(*FileSeeker, 1+(2*Len(#SystemEOL)))<>#SystemEOL+"}"+#SystemEOL
            
           If PeekS(*FileSeeker, 18)="; ProcedureReturn " And RetValue$="None"
             
            ;If PBnbVersion>=430
            ;  RetValue$="Integer"
            ;Else
              RetValue$="Long"
           ; EndIf
            
          EndIf
          ;-MP Jan 2015

           *FileSeeker+1
          If *FileSeeker>=FileEnd
            TBError(Language("TailBite","FileEndErr4"), 1, TBTempPath$)
            CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
          EndIf
        Wend
        
        ;MP Jan 2015
        EndIf
        
        CompilerEndIf
        

        
        AddElement(function())
        function()\ID=ListIndex(function())
        function()\Name$ = Name$
        function()\ProcedureFullLine$ = ProcedureFullLine$
        function()\Args$ = Args$
        function()\nArgs = nArgs
        function()\maxArgs = nArgs
        function()\HelpLine$ = HelpLine$
        function()\RetValue$ = RetValue$
        function()\DLLFunction = DLLFunction
        function()\FIndex = FIndex
        
        Debug "04 function()\ID = "+Str(function()\ID)+" * * * * *"
        Debug "05 function()\Name$ = "+function()\Name$+" * * * * *"
        Debug "06 function()\ProcedureFullLine$ = "+function()\ProcedureFullLine$+" * * * * *"
        Debug "07 function()\Args$ = "+function()\Args$+" * * * * *"
        Debug "08 function()\nArgs = "+Str(function()\nArgs)+" * * * * *"
        Debug "09 function()\maxArgs = "+Str(function()\maxArgs)+" * * * * *"
        Debug "10 function()\HelpLine$ = "+function()\HelpLine$+" * * * * *"
        Debug "11 function()\RetValue$ = "+function()\RetValue$+" * * * * *"
        Debug "12 function()\DLLFunction = "+Str(function()\DLLFunction)+" * * * * *"
        Debug "13 function()\FIndex = "+Str(function()\FIndex)+" * * * * *"
        
        
        
        If function()\DLLFunction
          PlainNameNM$ = ""
          If UCase(Right(function()\Name$, 6))="_DEBUG"
            function()\Modifiers$ = " | DEBUG"
            function()\DebugFunction = 1
            function()\nModifiers+1
            PlainNameND$ = Left(function()\Name$, Len(function()\Name$)-6)
          Else
            PlainNameND$ = function()\Name$
            If UCase(Right(PlainNameND$, 8))="_UNICODE"
              function()\Modifiers$+" | UNICODE"
              function()\nModifiers+1
              PlainNameNM$ = Left(PlainNameND$, Len(PlainNameND$)-8)
            Else
              PlainNameND$ = function()\Name$
              If UCase(Right(PlainNameND$, 7))="_THREAD"
                function()\Modifiers$+" | THREAD"
                function()\nModifiers+1
                PlainNameNM$ = Left(PlainNameND$, Len(PlainNameND$)-7)
              Else
                PlainNameND$ = function()\Name$
                If UCase(Right(PlainNameND$, 6))="_3DNOW"
                  function()\Modifiers$+" | 3DNOW"
                  function()\nModifiers+1
                  PlainNameNM$ = Left(PlainNameND$, Len(PlainNameND$)-6)
                Else
                  Select UCase(Right(PlainNameND$, 4))
                    Case "_MMX"
                      function()\Modifiers$+" | MMX"
                      function()\nModifiers+1
                      PlainNameNM$ = Left(PlainNameND$, Len(PlainNameND$)-4)
                    Case "_SSE"
                      function()\Modifiers$+" | SSE"
                      function()\nModifiers+1
                      PlainNameNM$ = Left(PlainNameND$, Len(PlainNameND$)-4)
                    Case "SSE2"
                      If UCase(Right(PlainNameND$, 5))="_SSE2"
                        function()\Modifiers$+" | SSE2"
                        function()\nModifiers+1
                        PlainNameNM$ = Left(PlainNameND$, Len(PlainNameND$)-5)
                      EndIf
                  EndSelect
                EndIf
              EndIf
            EndIf
          EndIf
          If PlainNameNM$=""
            PlainNameNM$ = PlainNameND$
          EndIf
          function()\PlainName$ = PlainNameNM$
          If function()\nModifiers=0
            function()\Main = 1
          Else
            ModifiersPresent = 1
          EndIf
          ; Removed RetValue$="None" ABBKlaus 30.8.2007 20:02
          If function()\nArgs=0 ; function()\RetValue$="None"
            If Right(function()\PlainName$, 5)="_Init"
              function()\RetValue$="InitFunction"
            ElseIf Right(function()\PlainName$, 4)="_End"
              function()\RetValue$="EndFunction"
            EndIf
          EndIf
        EndIf
      EndIf
      Debug "14 PeekS(*FileSeeker, 20) = "+PeekS(*FileSeeker, 20)+" * * * * *"

      *FileSeeker - 3
      
      
    EndIf
    *FileSeeker = FindNextString(#SystemEOL, *FileSeeker, FileEnd)+Len(#SystemEOL)
  Wend
  
;      ForEach function()
;        
;        Debug "Start"
;        Debug function()\ID
;        Debug function()\FIndex
;        Debug function()\Name$
;        Debug function()\ProcedureFullLine$
;        Debug function()\RetValue$

;      Next
  
  
  Debug "15 ListSize(function()) = "+Str(ListSize(function()))+" * * * * *"
  If ListSize(function())
    VarArgsPresent = 0
    ;Sort function list ABBKlaus 11.7.2007 21:04
    CompilerIf #PB_Compiler_Version>=510
      SortStructuredList(function(),0,OffsetOf(LibFunction\Name$),#PB_String)
    CompilerElse
      SortStructuredList(function(),0,OffsetOf(LibFunction\Name$),#PB_Sort_String)
    CompilerEndIf
    If IsPB510 ;- gnozal/ABBKlaus : PB5.10 missing helpline fix
      PBSourceStream = ReadFile(#PB_Any,PBSourceFile$)
      If PBSourceStream
        PBSourceStringFormat = ReadStringFormat(PBSourceStream)
        Select PBSourceStringFormat
          Case #PB_Ascii,#PB_UTF8
            While Eof(PBSourceStream)=0
              PBSourceStreamLine$ = Trim(ReadString(PBSourceStream,PBSourceStringFormat))
              ;If FindString(PBSourceStreamLine$,"Procedure",1,#PB_String_NoCase) ; not in PB4.61 available
              If LCase(Left(PBSourceStreamLine$,9))="procedure"
                ForEach function()
                  If Right(function()\HelpLine$, 1) = ")"
                    If FindString(PBSourceStreamLine$, function()\ProcedureFullLine$, 1)
                      FoundQuickHelp = FindString(PBSourceStreamLine$, ";", Len(function()\ProcedureFullLine$))
                      If FoundQuickHelp
                        function()\HelpLine$ + " - " + Trim(Mid(PBSourceStreamLine$, FoundQuickHelp + 1))
                        WriteLog("Found Helpline in PBSource : "+function()\HelpLine$)
                      EndIf
                    EndIf
                  EndIf
                Next
              EndIf
            Wend
        EndSelect
        CloseFile(PBSourceStream)
      EndIf
    EndIf
    
    
    
    
    ForEach function()
      If function()\Main
        PlainName$ = function()\PlainName$
        LnNum = Len(PlainName$)
        NumbNum = LnNum
        While Asc(Mid(PlainName$, LnNum, 1))=>'0' And Asc(Mid(PlainName$, LnNum, 1))<='9' And LnNum>0
          LnNum-1
        Wend
        If LnNum<NumbNum
          FNIndex = Val(Right(PlainName$, NumbNum-LnNum))
          If FNIndex>1
            FIndex = ListIndex(function())
            FArgs = function()\nArgs
            ArgStr$ = RTrim(function()\Args$)
            HelpLine$ = LTrim(function()\HelpLine$)
            ArgsPart$ = GetNextString(@HelpLine$+1, ")")
            ShortPlainName$ = Left(PlainName$, LnNum)
            ForEach function()
              ; Bugfix for the new sorting of functions ABBKlaus 22.8.2007 00:18
              If function()\PlainName$=ShortPlainName$ And function()\Main ; And function()\nArgs<FArgs And function()\maxArgs<FArgs
                VarArgsPresent = 1
                If function()\maxArgs<FArgs ; Check for more argmuments
                  function()\maxArgs = FArgs
                EndIf
                function()\VarArgs$+"|"+Str(FArgs)
                If Len(function()\VarArgStr$)<Len(ArgStr$)
                  function()\VarArgStr$ = ArgStr$+", "
                EndIf
                If Len(function()\VarHelpStr$)<Len(ArgsPart$)
                  function()\VarHelpStr$ = ArgsPart$
                EndIf
                SelectElement(function(), FIndex)
                function()\Main = 0
                Break
              EndIf
            Next
            SelectElement(function(), FIndex)
          EndIf
        EndIf
      EndIf
    Next
    ;bugfix: Quickhelp bug (reFormat VarHelpStr$) ABBKlaus 13.1.2007 00:17/16.4.2007 23:56
    ForEach function() ; iterate through the complete list / if you remove the ForEach function()\VarHelpStr$ is imcomplete
      count=CountString(function()\VarHelpStr$,",")
      If count
        newVarHelpStr$=""
        For i=1 To count+1
          temp$=StringField(function()\VarHelpStr$,i,",")
          If i=(count+1)
            newVarHelpStr$+Trim(temp$)
          Else
            newVarHelpStr$+Trim(temp$)+", "
          EndIf
        Next
        function()\VarHelpStr$=newVarHelpStr$
      EndIf
      ; Fix detection of a linked list Progi1984 03/19/08 17:59
      BetweenBrackets$  = Mid(function()\HelpLine$, 1, Len(function()\HelpLine$) - Len(StringField(function()\HelpLine$,CountString(function()\HelpLine$, ")")+1,")")))
      StringField(function()\HelpLine$,1,")")
      AfterBrackets$    = Right(function()\HelpLine$, Len(function()\HelpLine$) - Len(BetweenBrackets$))
      count             = CountString(BetweenBrackets$,",")
      If count
        BetweenBrackets$  = Mid(BetweenBrackets$, 2, Len(BetweenBrackets$)-2)
        newHelpLine$      = ""
        For i= 1 To count+1
          temp$ = StringField(BetweenBrackets$,i,",")
          If i = (count+1)
            newHelpLine$ + Trim(temp$)
          Else
            newHelpLine$ + Trim(temp$)+", "
          EndIf
        Next
        function()\HelpLine$="("+BetweenBrackets$+")"+AfterBrackets$
      EndIf
      If function()\RetValue$="InitFunction"
        InitExists = 1
        ;Break
        ;- this break should be commented since i moved it into another foreach loop, yes? - lexvictory
      EndIf
    Next
    If VarArgsPresent
      ForEach function()
        If function()\Main And function()\VarArgs$
          NVars = 0
          cpos = 1
          While FindString(function()\VarArgs$, "|", cpos)
            cpos = FindString(function()\VarArgs$, "|", cpos)+1
            NVars+1
          Wend
          function()\VarArgs$ = Right(function()\VarArgs$, Len(function()\VarArgs$)-1)
          Dim VarargPlaces(NVars)
          For i=1 To NVars
            VarargPlaces(i) = Val(StringField(function()\VarArgs$, i, "|"))
          Next i
          SortArray(VarargPlaces(), 0)
          LastArgs = function()\nArgs
          function()\VarHelpStr$ = ", "+function()\VarHelpStr$+", "
          For i=1 To NVars
            FArgs = VarargPlaces(i)
            lpos = 1
            For p=1 To LastArgs+1
              lpos = FindString(function()\VarArgStr$, ", ", lpos)+1
            Next p
            LeftPart$ = Left(function()\VarArgStr$, lpos)
            rpos = lpos
            For p=LastArgs+1 To FArgs
              rpos = FindString(function()\VarArgStr$, ", ", rpos)+1
            Next p
            MidPart$ = Mid(function()\VarArgStr$, lpos+1, rpos-lpos-2)
            RightPart$ = Right(function()\VarArgStr$, Len(function()\VarArgStr$)-Len(LeftPart$)-Len(MidPart$))
            function()\VarArgStr$ = LeftPart$+"["+MidPart$+"]"+RightPart$
            lpos = 1
            For p=1 To LastArgs+1
              lpos = FindString(function()\VarHelpStr$, ", ", lpos)+1
            Next p
            LeftPart$ = Left(function()\VarHelpStr$, lpos)
            RightPart$ = Right(function()\VarHelpStr$, Len(function()\VarHelpStr$)-Len(LeftPart$))
            ;bugfix: Quickhelp bug ABBKlaus 12.1.2007 23:06
            If RightPart$ 
              function()\VarHelpStr$ = LeftPart$+"["+Left(RightPart$, Len(RightPart$)-2)+"], "
            EndIf
            ;endbugfix
            LastArgs = FArgs
          Next i
          function()\Args$ = Left(function()\VarArgStr$, Len(function()\VarArgStr$)-1)
          lpos = FindString(function()\HelpLine$, " - ", 1)
          ;bugfix: Quickhelp bug (remove first char ',') ABBKlaus 12.1.2007 23:06
          function()\VarHelpStr$=Trim(Mid(function()\VarHelpStr$,2,Len(function()\VarHelpStr$)))
          ;endbugfix
          If lpos
            function()\HelpLine$ = Right(function()\HelpLine$, Len(function()\HelpLine$)-lpos+1)
          Else
            function()\HelpLine$ = ""
          EndIf
          function()\VarHelpStr$ = ReplaceString(function()\VarHelpStr$, ", [", " [, ")
          ;bugfix: Quickhelp bug (compose help line) ABBKlaus 12.1.2007 23:06
          function()\VarHelpStr$=Left(function()\VarHelpStr$,Len(function()\VarHelpStr$)-1)
          function()\HelpLine$="("+function()\VarHelpStr$+")"+function()\HelpLine$
          ;endbugfix
        EndIf
      Next
    EndIf
    If ModifiersPresent
      ForEach function()
        If function()\Main
          FName$ = function()\Name$
          FIndex = ListIndex(function())
          ThisMod$ = ""
          ForEach function()
            If function()\Main=0 And function()\DLLFunction And function()\PlainName$=FName$ And function()\Modifiers$
              ThisMod$+function()\Modifiers$
            EndIf
          Next
          SelectElement(function(), FIndex)
          NewMod$ = ""
          If FindString(ThisMod$, "DEBUG", 1)
            NewMod$+" | DebuggerCheck"
          EndIf
          If FindString(ThisMod$, "UNICODE", 1)
            NewMod$+" | Unicode"
          EndIf
          If FindString(ThisMod$, "THREAD", 1)
            NewMod$+" | Thread"
          EndIf
          If FindString(ThisMod$, "MMX", 1)
            NewMod$+" | MMX"
          EndIf
          If FindString(ThisMod$, "3DNOW", 1)
            NewMod$+" | 3DNOW"
          EndIf
          If FindString(ThisMod$, "SSE", 1)
            NewMod$+" | SSE"
          EndIf
          If FindString(ThisMod$, "SSE2", 1)
            NewMod$+" | SSE2"
          EndIf
          function()\Modifiers$ = NewMod$
        EndIf
      Next
    EndIf
    ;ForEach function();speed improvements
      ;If function()\RetValue$="InitFunction"
        ;InitExists = 1
        ;Break
      ;EndIf
    ;Next
    ;sort list on ID ABBKlaus 11.7.2007 23:06
    CompilerIf #PB_Compiler_Version>=510
      SortStructuredList(function(),0,OffsetOf(LibFunction\ID),#PB_Long)
    CompilerElse
      SortStructuredList(function(),0,OffsetOf(LibFunction\ID),#PB_Sort_Long)
    CompilerEndIf
    If InitExists=0
      AddElement(function())
      function()\ID=ListIndex(function())
      function()\RetValue$ = "InitFunction"
      function()\Name$ = LibName$+"_Init"
      function()\PlainName$ = function()\Name$
      function()\Args$ = ""
      function()\nArgs = 0
      function()\Main = 1
      function()\maxArgs = 0
      function()\HelpLine$ = ""
      function()\DLLFunction = 1
      function()\FIndex = -1
      function()\Modifiers$ = ""
      function()\DebugFunction = 0
      function()\nModifiers = 0
      function()\VarArgs$ = ""
      function()\VarArgStr$ = ""
      function()\VarHelpStr$ = ""
    EndIf
    
    ForEach function()
      WriteLog("- Function index "+Str(ListIndex(function())))
      WriteLog("function()\ID="+Str(function()\ID))
      WriteLog("function()\RetValue$="+function()\RetValue$)
      WriteLog("function()\Name$="+function()\Name$)
      WriteLog("function()\PlainName$="+function()\PlainName$)
      WriteLog("function()\Args$="+function()\Args$)
      WriteLog("function()\nArgs="+Str(function()\nArgs))
      WriteLog("function()\Main="+Str(function()\Main))
      WriteLog("function()\maxArgs="+Str(function()\maxArgs))
      WriteLog("function()\HelpLine$="+function()\HelpLine$)
      WriteLog("function()\DLLFunction="+Str(function()\DLLFunction))
      WriteLog("function()\FIndex="+Str(function()\FIndex))
      WriteLog("function()\Modifiers$="+function()\Modifiers$)
      WriteLog("function()\DebugFunction="+Str(function()\DebugFunction))
      WriteLog("function()\nModifiers="+Str(function()\nModifiers))
      WriteLog("function()\VarArgs$="+function()\VarArgs$)
      WriteLog("function()\VarArgStr$="+function()\VarArgStr$)
      WriteLog("function()\VarHelpStr$="+function()\VarHelpStr$)
    Next
    
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure SplitFunctions(FileStart, FileEnd, DestFolder$, FinalDestFolder$, mID, decoration.s="")
  Protected FileSeeker.l,AsmHeader$,HeaderEnd$,FunctionType.l,PBLibName$,AlreadyThere.l,Included$,IPluginAdded.l
  Protected GadgetAdded.l,NewPBAsmSize.l,*NewPBAsm,*NewPBAsmEnd,*NewPBAsmSeeker,pIndex.l,PreviousLine$
  Protected ThisLine$,Whp.l,ptIndex.l,ptArgs.l,PWhp.l,PFIndex.l,PrNRepl$,nd$,SFunc.l,nAlias.l,i.l,va$,vPos.l
  Protected fqPos.l,nov.l,ch$,rem.l,THS$,File2.l,File3.l,Searching.l,BackSeeker.l,ProcEnd$,ProcStart.l,ProcEnd.l
  Protected ProcSeeker.l,FileString$,File0.l,EndProcOffset.l,CallFunc.l,FnStr$,ChP$,ChEnd$,pos.l,PBIncludeLib$
  Protected Dir0.l,LabelStart.l,File4.l,DataSectionString$,firstdata.l,CheckLine$,BssSectionString$,PBDataSectionString$
  Protected TempSharedSize.l,*TempShared,found.l,RETX4.l, Symbol$
  
  ;FileStart = FindNextString("; Procedure", FileStart, FileEnd)
  ;Debug "Filestart = "+PeekS(FileStart,80000)+" * * * * *"
  ;End
  
  Debug "Inc_Taibite > SplitFunctions() "+decoration
  WriteLog("Inc_Taibite > SplitFunctions() "+decoration)
  
  FileSeeker = FileStart
  AsmHeader$ = "The header must remain intact for Re-Assembly"+#SystemEOL+"; "+#SystemEOL
  FileSeeker = FindNextString(AsmHeader$, FileSeeker, FileEnd)+Len(AsmHeader$)
  CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
    If PBVersionX64
      HeaderEnd$ = "; "+#SystemEOL+"format "+#Asm_Formatx64
    Else
      HeaderEnd$ = "; "+#SystemEOL+"format "+#Asm_Format
    EndIf
  CompilerElse
    HeaderEnd$ = "; "+#LF$+"; "+#LF$ ;best guess
  CompilerEndIf
  FunctionType=0
  
  Debug "15 Parsing * * * * *"
  ; Begin parsing the PureBasic ASM Header
  While PeekS(FileSeeker, Len(HeaderEnd$))<>HeaderEnd$ And FileSeeker<FileEnd
    PBLibName$ = RemoveString(GetNextString(FileSeeker, #SystemEOL), "; ")
    Debug "16 PBLibName$ = "+PBLibName$+" * * * * *"
    If Left(PBLibName$,1)=":" ; :System :Import :DLL
      Select PBLibName$
        Case ":System" ; bugfix: :System ABBKlaus 11.11.2006 00:33
          FunctionType=1
        Case ":Import" ; bugfix: skip :Import section ABBKlaus 17.10.2007 19:55
          FunctionType=2
        Case ":DLL"
          FunctionType=3
      EndSelect
    Else
      If FunctionType=1
        AlreadyThere = 0
        ForEach DLLList()
          If DLLList()=PBLibName$+".DLL"
            AlreadyThere = 1
            Break
          EndIf
        Next
        If AlreadyThere = 0
          AddElement(DLLList())
          DLLList()=PBLibName$+".DLL"
          WriteLog("System function found : "+PBLibName$)
        EndIf
      ElseIf FunctionType=2
        WriteLog("Import function found (will be ignored) : "+PBLibName$)
      ElseIf FunctionType=3
        WriteLog("DLL function found (will be ignored) : "+PBLibName$)
      Else
        If Left(PBLibName$, Len("TB_Include"))="TB_Include"
          Included$ = Right(PBLibName$, Len(PBLibName$)-Len("TB_Include"))
          AlreadyThere = 0
          ForEach PBLib()
            If PBLib() = Included$
              AlreadyThere = 1
              Break
            EndIf
          Next
          If AlreadyThere = 0
            AddElement(PBLib())
            PBLib() = Included$
          EndIf
        Else
          Select PBLibName$
            Case "ImagePlugin"
              If IPluginAdded = 0
                AddElement(PBLib())
                PBLib() = "ImagePlugin"
                IPluginAdded = 1
              EndIf
            Case "TB_ImagePlugin"
              If IPluginAdded = 0
                AddElement(PBLib())
                PBLib() = "ImagePlugin"
                IPluginAdded = 1
                AddTB_ImagePlugin = 1
              EndIf
            Case "Gadget"
              If GadgetAdded = 0
                AddElement(PBLib())
                PBLib() = "Gadget"
                GadgetAdded = 1
              EndIf
            Case "TB_GadgetExtension"
              If GadgetAdded = 0
                AddElement(PBLib())
                PBLib() = "Gadget"
                GadgetAdded = 1
                AddTB_GadgetExtension = 1
              EndIf
            Case "TB_Debugger"
              AddTB_Debugger = 1
            Default
              AlreadyThere = 0
              ForEach PBLib()
                If PBLib() = PBLibName$
                  AlreadyThere = 1
                  Break
                EndIf
              Next
              If AlreadyThere = 0
                AddElement(PBLib())
                PBLib() = PBLibName$
              EndIf
          EndSelect
        EndIf
      EndIf
    EndIf
    FileSeeker = FindNextString(#SystemEOL, FileSeeker, FileEnd)+Len(#SystemEOL)
  Wend
  
  EndInclude = 0
  NewPBAsmSize = (FileEnd-FileStart)*2
  *NewPBAsm = AllocateMemory(NewPBAsmSize)
  *NewPBAsmEnd = *NewPBAsm+NewPBAsmSize
  *NewPBAsmSeeker = *NewPBAsm
  CopyMemoryString(@"", @*NewPBAsmSeeker)
  pIndex = 0
  PreviousLine$ = ""
  While FileSeeker<FileEnd
    ThisLine$ = LTrim(GetNextString(FileSeeker, #SystemEOL))
    FileSeeker = FindNextString(#SystemEOL, FileSeeker, FileEnd)+Len(#SystemEOL)
    Whp = FindString(ThisLine$, "_Procedure", 1)
    If Whp
      If Left(ThisLine$, 10)="_Procedure" And Right(ThisLine$, 1)=":"
        Debug "17 ThisLine$ = "+ThisLine$+" * * * * *"
        pIndex = Val(Mid(ThisLine$, 11, Len(ThisLine$)-11))
        ForEach function()
          If function()\FIndex=pIndex
            ptIndex = ListIndex(function())
            ptArgs = Function()\nArgs
            Break
          EndIf
        Next
      EndIf
      Whp+10
      PWhp = Whp
      While Asc(Mid(ThisLine$, Whp, 1))=>'0' And Asc(Mid(ThisLine$, Whp, 1))<='9' And WhP<=Len(ThisLine$)
        Whp+1
      Wend
      PFIndex = Val(Mid(ThisLine$, PWhp, Whp-PWhp))
      PrNRepl$ = "_Procedure"+Str(PFIndex)
      Debug "17.4 PFIndex = "+Str(PFIndex)
      
      ForEach function()
        If function()\FIndex=PFIndex
          Break
        EndIf
      Next

      If function()\DLLFunction=0
        ;-* decoration
        If decoration<>""
          ;workaround for function()\Name$ already has Libname+Functionname inside ABBKlaus 1.2.2009 18:46
          ThisLine$ = ReplaceString(ThisLine$, PrNRepl$, function()\Name$+decoration, #PB_String_NoCase)
        Else
          ThisLine$ = ReplaceString(ThisLine$, PrNRepl$, LibName$+"_"+function()\Name$+decoration, #PB_String_NoCase)
        EndIf
        Debug "17.5 ThisLine$ = "+ThisLine$ 
  
      Else
        If FindString(ThisLine$, PrNRepl$, 1)
          ;-* decoration
          ;CallDebugger
          If decoration<>""
            If function()\DebugFunction
              If PBVersionX64
                ThisLine$ = ReplaceString(ThisLine$, PrNRepl$, "PB_"+RemoveString(function()\Name$,"_DEBUG")+decoration+"_DEBUG", #PB_String_NoCase)
              Else
                CompilerIf #PB_Compiler_OS <> #PB_OS_Linux
                  ThisLine$ = ReplaceString(ThisLine$, PrNRepl$, "_PB_"+RemoveString(function()\Name$,"_DEBUG")+decoration+"_DEBUG", #PB_String_NoCase)
                CompilerElse
                  ThisLine$ = ReplaceString(ThisLine$, PrNRepl$, "PB_"+RemoveString(function()\Name$,"_DEBUG")+decoration+"_DEBUG", #PB_String_NoCase)
                CompilerEndIf
              EndIf
            Else
              ThisLine$ = ReplaceString(ThisLine$, PrNRepl$, "PB_"+function()\Name$+decoration, #PB_String_NoCase)
            EndIf
          Else
            If function()\DebugFunction
              If PBVersionX64
                ThisLine$ = ReplaceString(ThisLine$, PrNRepl$, "PB_"+function()\Name$, #PB_String_NoCase)
              Else
                CompilerIf #PB_Compiler_OS <> #PB_OS_Linux
                  ThisLine$ = ReplaceString(ThisLine$, PrNRepl$, "_PB_"+function()\Name$, #PB_String_NoCase)
                CompilerElse
                  ThisLine$ = ReplaceString(ThisLine$, PrNRepl$, "PB_"+function()\Name$, #PB_String_NoCase)
                CompilerEndIf
              EndIf
            Else
              ThisLine$ = ReplaceString(ThisLine$, PrNRepl$, "PB_"+function()\Name$, #PB_String_NoCase)
            EndIf
          EndIf
        EndIf
        If function()\nModifiers
          ThisLine$=ModifierProc(ThisLine$)
        EndIf
      Debug "17.5 ThisLine$ = "+ThisLine$ 
  
      EndIf
    Else
      ThisLine$ = ReplaceString(ThisLine$, "; proceduredll", "; ProcedureDLL", #PB_String_NoCase)
      ThisLine$ = ReplaceString(ThisLine$, "; procedurecdll", "; ProcedureCDLL", #PB_String_NoCase)
      ThisLine$ = ReplaceString(ThisLine$, "; procedurereturn", "; ProcedureReturn", #PB_String_NoCase)
      If FindString(ThisLine$, "; ProcedureDLL", 1) Or FindString(ThisLine$, "; ProcedureCDLL", 1)
        ThisLine$=ModifierProc(ThisLine$)
      ElseIf FindString(ThisLine$, "PB_DataPointer", 1)
        ThisLine$ = ReplaceString(ThisLine$, "PB_DataPointer", LibName$+"_PB_DataPointer", #PB_String_NoCase)
      ElseIf FindString(ThisLine$, "_PB_EOP_NoValue", 1)
        ThisLine$ = ReplaceString(ThisLine$, "_PB_EOP_NoValue", LibName$+"__PB_EOP_NoValue", #PB_String_NoCase)
        EndInclude = 1
      ElseIf FindString(ThisLine$,"_PB_EOP",1)
        ;bugfix endfunctions for X64 ABBKlaus 14.1.2009 19:49
        ThisLine$ = ReplaceString(ThisLine$, "_PB_EOP", LibName$+"__PB_EOP", #PB_String_NoCase)
        EndInclude = 1
      ElseIf FindString(ThisLine$,"define ",1) ;-* bugfix for labels in PB5.10
        Repeat
          ForEach Labels_Define()
            If Labels_Define()\LabelName=StringField(ThisLine$,2," ")
              Break 2 ; if already in the list skip it
            EndIf
          Next
          AddElement(Labels_Define())
          Labels_Define()\LabelName=StringField(ThisLine$,2," ")
          Labels_Define()\FunctionName=StringField(ThisLine$,3," ")
          WriteLog("define added "+Labels_Define()\LabelName+" = "+Labels_Define()\FunctionName)
          Break
        ForEver
      Else
        SFunc = FindString(ThisLine$, "@", 1)
        CheckASM:
        If Left(ThisLine$, 1)<>";"
          ;-* VarAlias
          Restore VarAlias
          Read.l nAlias
          For i=1 To nAlias
            Read.s va$
            vPos = 1
            While vPos
              fqPos = FindString(ThisLine$, #DQUOTE$, vPos)
              vPos = FindString(ThisLine$, va$, vPos)
              If fqPos:If vPos>fqPos:vPos = 0:EndIf:EndIf
              If vPos>0
                nov = 0
                If Mid(ThisLine$, 7, Len("_SYS_StringEqual"))<>"_SYS_StringEqual" And Mid(ThisLine$, 7, Len("_SYS_StringInferior"))<>"_SYS_StringInferior" And Mid(ThisLine$, 7, Len("_SYS_StringSuperior"))<>"_SYS_StringSuperior"
                  If Len(va$)=1
                    If Asc(Mid(ThisLine$, vPos+1, 1))<'0' Or Asc(Mid(ThisLine$, vPos+1, 1))>'9'
                      nov = 1
                      vPos+1
                    EndIf
                  EndIf
                  If nov=0
                    If SFunc=0 Or Left(UCase(ThisLine$), 5)<>"CALL "
                      If vPos=1
                        Select LCase(Left(ThisLine$, 3))
                          Case "db "
                          Case "dw "
                          Case "dd "
                          Case "dq "
                          Default
                            If LTrim(LCase(Left(ThisLine$, 5)))<>"file "
                              ;-* decoration (symbols)
                              ThisLine$ = LibName$+decoration+"_"+ThisLine$
                            EndIf
                        EndSelect
                      Else
                        If LTrim(LCase(Left(ThisLine$, 5)))<>"file "
                          ch$ = Mid(ThisLine$, vPos-1, 1)
                          If ch$=" " Or ch$="," Or ch$="[" Or ch$="+" Or ch$="-"
                            CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                              If IsImportFunc(LCase(ThisLine$))  Or (LTrim(LCase(Left(ThisLine$,6)))="extrn " And  FindString(LCase(ThisLine$),"_sys",7));x64 import fix lexvictory 20-1-11
                            CompilerElse
                              ;If LTrim(LCase(Left(ThisLine$,7)))="extern " And FindString(LCase(ThisLine$),"_sys",8)
                              If FindString(LCase(ThisLine$),"_sys_",5)
                            CompilerEndIf
                              ;do not rename PB functions like _sys* ABBKlaus 8.2.2008 16:50
                              ;Debug ThisLine$
                            Else
                              ;If FindString(LCase(thisline$), "_sys",1) : Debug "bad: "+thisline$ : EndIf
                              rem=FindString(ThisLine$,";",1)
                              If rem=0
                                rem=Len(ThisLine$)+1
                              EndIf
                              THS$ = Left(ThisLine$, vPos-1)
                              ;-* decoration (symbols)
                              THS$+LibName$+decoration+"_"+Right(ThisLine$, Len(ThisLine$)-vPos+1)
                              ThisLine$ = THS$
                              ;-* bugfix for labels in PB5.10
                              ForEach Labels_Define()
                                If FindString(ThisLine$,Labels_Define()\LabelName,1)
                                  ThisLine$=ReplaceString(ThisLine$,Labels_Define()\LabelName,Labels_Define()\FunctionName)
                                  Break
                                EndIf
                              Next
                              vPos+Len(LibName$+decoration+"_")
                            EndIf
                          EndIf
                        EndIf
                      EndIf
                      vPos+1
                    Else
                      vPos = 0
                    EndIf
                  EndIf
                Else
                  vPos = 0
                EndIf
              EndIf
            Wend
          Next i
          ;Debug "18 Next * * * * *"
          If i=nAlias+1
            THS$ = ThisLine$
            ;debug "got to pb_tb_replaces"
           If FindString(ThisLine$, "PB_TB_", 1)
;             ThisLine$ = ReplaceString(ThisLine$, "PB_TB_SetGadget", LibName$+"_TB_SetGadget", #PB_String_NoCase);old
            ThisLine$ = ReplaceString(ThisLine$, "PB_TB_hInstance", LibName$+"_TB_hInstance", #PB_String_NoCase);old
;             ThisLine$ = ReplaceString(ThisLine$, "PB_TB_UsedWindow", LibName$+"_TB_UsedWindow", #PB_String_NoCase);old
            ThisLine$ = ReplaceString(ThisLine$, "PB_TB_GetGadgetParent", LibName$+"_TB_GetGadgetParent", #PB_String_NoCase)
            ThisLine$ = ReplaceString(ThisLine$, "PB_TB_RegisterGadget", LibName$+"_TB_RegisterGadget", #PB_String_NoCase)
            If function()\DebugFunction ;Or FindString(function()\Name$, "_DEBUG", 1)
              ;- * decoration (TB_Debug)
              ;If function()\Name$ = "MyProcedure_DEBUG"
                ;CallDebugger
              ;EndIf
              ThisLine$ = ReplaceString(ThisLine$, "PB_TB_DebugError", LibName$+"_TB_DebugError_DEBUG", #PB_String_NoCase);TB_DebugError can handle unicode and ascii 
              ThisLine$ = ReplaceString(ThisLine$, "PB_TB_DebugWarning", LibName$+"_TB_DebugWarning_DEBUG", #PB_String_NoCase);TB_DebugWarning can handle unicode and ascii
              ThisLine$ = ReplaceString(ThisLine$, "PB_TB_DebugCheckUnicode", LibName$+"_TB_DebugCheckUnicode_DEBUG", #PB_String_NoCase)
              ThisLine$ = ReplaceString(ThisLine$, "PB_TB_DebugCheckLabel", LibName$+"_TB_DebugCheckLabel_DEBUG", #PB_String_NoCase)
              ThisLine$ = ReplaceString(ThisLine$, "PB_TB_DebugFileExists", LibName$+"_TB_DebugFileExists_DEBUG", #PB_String_NoCase)
              ThisLine$ = ReplaceString(ThisLine$, "PB_TB_DebugCheckProcedure", LibName$+"_TB_DebugCheckProcedure_DEBUG", #PB_String_NoCase)
            Else
              ;Debug "non debug func: "+function()\Name$
              ThisLine$ = ReplaceString(ThisLine$, "PB_TB_DebugError", LibName$+"_TB_DebugError", #PB_String_NoCase)
              ThisLine$ = ReplaceString(ThisLine$, "PB_TB_DebugWarning", LibName$+"_TB_DebugWarning", #PB_String_NoCase)
              ThisLine$ = ReplaceString(ThisLine$, "PB_TB_DebugCheckUnicode", LibName$+"_TB_DebugCheckUnicode", #PB_String_NoCase)
              ThisLine$ = ReplaceString(ThisLine$, "PB_TB_DebugCheckLabel", LibName$+"_TB_DebugCheckLabel", #PB_String_NoCase)
              ThisLine$ = ReplaceString(ThisLine$, "PB_TB_DebugFileExists", LibName$+"_TB_DebugFileExists", #PB_String_NoCase)
              ThisLine$ = ReplaceString(ThisLine$, "PB_TB_DebugCheckProcedure", LibName$+"_TB_DebugCheckProcedure", #PB_String_NoCase)
            EndIf
            ThisLine$ = ReplaceString(ThisLine$, "PB_TB_RegisterImageEncoder", LibName$+"_TB_RegisterImageEncoder", #PB_String_NoCase)
            ThisLine$ = ReplaceString(ThisLine$, "PB_TB_RegisterImageDecoder", LibName$+"_TB_RegisterImageDecoder", #PB_String_NoCase)
           EndIf;findstring pb_tb_
          EndIf
          If Left(ThisLine$,10)="aligngosub"
            ; bugfix aligngosub (found by lexvictory) ABBKlaus 11.1.2009 15:04
            ThisLine$=Mid(ThisLine$,1,10)+"_"+LibName$+"_"+Mid(ThisLine$,11)
          EndIf
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            If FindString(ThisLine$, "PStub", 1);-OSX: remove PStub
              ThisLine$ = RemoveString(ThisLine$, "PStub")
              ThisLine$ = ReplaceString(ThisLine$, "CALL dword [", "CALL ")
              ThisLine$ = RemoveString(ThisLine$, "]")
              ;Debug ThisLine$
            EndIf
          CompilerEndIf
          If (LCase(LTrim(Left(ThisLine$, 6)))="extrn ") Or (LCase(LTrim(Left(ThisLine$, 7)))="extern ")
            ; !Extrn bugfix found by mpz
            ; http://www.purebasic.fr/english/viewtopic.php?p=263222#263222
            ; ABBKlaus 14.10.2008 21:45 
            If FindString(LCase(ThisLine$),"_sys",7) Or FindString(LCase(ThisLine$),"pb_debugger_unicode",7);lexvictory fix 4/4/09 for tb_debugger include file.
              ThisLine$ = "; "+ThisLine$
            EndIf
          EndIf
        ; this part of tailbite causes problems with ASM comments (found by eddy) ABBKlaus 8.9.2007 23:40
        ;ElseIf Left(ThisLine$, 3)="; !"            ;   CORREGIR ESTO PARA CUANDO HAYA ASM COMENTADO: ; !mov [v_R],... (Rings)
        ;  If Right(ThisLine$, 1)<>":"
        ;    cpos = FindString(ThisLine$, ";", 2)
        ;    If cpos
        ;      THS$ = RTrim(Left(ThisLine$, cpos))
        ;    Else
        ;      THS$ = RTrim(ThisLine$)
        ;    EndIf
        ;    THS$ = Trim(RemoveString(THS$, "; !"))
        ;    ThisLine$+#CRLF$
        ;    CopyMemoryString(@ThisLine$)
        ;    FileSeeker = FindNextString(#CRLF$, FileSeeker, FileEnd)+Len(#CRLF$)
        ;    ThisLine$ = THS$
        ;    Goto CheckASM
        ;  EndIf
        ElseIf Left(ThisLine$, Len(";--TB_ADD_PBLIB_")) = ";--TB_ADD_PBLIB_";tailbite directive to include special PBLib
          AddElement(PBLib())
          PBLib() = Trim(RemoveString(ThisLine$, ";--TB_ADD_PBLIB_"))
        EndIf
      EndIf
    EndIf
    PreviousLine$ = ThisLine$
    ThisLine$+#SystemEOL
    CopyMemoryString(@ThisLine$)
  Wend
  
  Debug "19 Next * * * * *"
  FreeMemory(mID)
  If decoration=""
    ;should only be iterated once
    ForEach function()
      If function()\DLLFunction=0
        function()\Name$ = LibName$+"_"+function()\Name$
      ElseIf function()\nModifiers
        function()\Name$ = ModifierProc(function()\Name$)
      EndIf
    Next
  EndIf
  
  Debug "20 Next "+LibName$+"_"+function()\Name$+"* * * * *"
  *NewPBAsmEnd = *NewPBAsmSeeker
  FileEnd = *NewPBAsmSeeker
  FileStart = *NewPBAsm
  FileSeeker = FileStart
  NewPBAsmSize = FileEnd-FileSeeker
  ClearList(label())
  File2=OpenFile(#PB_Any, DestFolder$+LibName$+"ObjFiles.txt")
  Debug "20 "+DestFolder$+LibName$+"ObjFiles.txt"+"* * * * *"
  If File2
    FileSeek(File2, Lof(File2))
    If KeepSrcFiles = 0
      WriteBatch = 0
    EndIf
    If WriteBatch
      WriteLog("WriteBatch")
      File3=OpenFile(#PB_Any, DestFolder$+LibName$+"build"+#SystemBatchExt)
      If File3
        FileSeek(File3, Lof(File3))
        WriteLog("OpenFile "+#DQUOTE$+DestFolder$+LibName$+"build"+#SystemBatchExt+#DQUOTE$+" successfull")
      Else
        WriteBatch=0
        WriteLog("OpenFile "+#DQUOTE$+DestFolder$+LibName$+"build"+#SystemBatchExt+#DQUOTE$+" failed !")
      EndIf
    EndIf
    If decoration=""
      If WriteBatch
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          WriteString(File3, "@echo OFF"+#CRLF$+#CRLF$)
        CompilerElse
          WriteString(File3, "#!/bin/bash"+#LF$+#LF$)
        CompilerEndIf
      EndIf
    EndIf
    ResetList(function())
    While NextElement(function()) And FileSeeker<FileEnd
      If function()\FIndex<>-1
        ;
        ;
        RETX4 = #False ;- gnozal PB4.20 fix
        ;
        ;
        Searching = 1
        While Searching And FileSeeker<FileEnd
          If function()\DLLFunction
            FileSeeker = FindNextString(function()\Name$, FileSeeker, FileEnd)
          Else
            FileSeeker = FindNextString(RemoveString(function()\Name$, LibName$+"_"), FileSeeker, FileEnd)
          EndIf
          BackSeeker = FindNextString(#SystemEOL, FileSeeker, FileStart)
          If UCase(PeekS(BackSeeker+Len(#SystemEOL), 11))="; PROCEDURE"
            Searching = 0
          EndIf
          FileSeeker+1
        Wend
        
        CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
          
          ;-MP Jan 2015
          If PBnbVersion>=531
            
            
            ;FileSeeker = FindNextString("; Procedure", FileSeeker, FileEnd)
            Debug "xx PeekS(FileSeeker, 120) = "+PeekS(FileSeeker, 120)+" * * * * *"+Str(FileSeeker)
            
            ;FileSeeker = FindNextString(#SystemEOL, FileSeeker, FileEnd)+Len(#SystemEOL)
            ;FileSeeker = FindNextString("_Procedure", FileSeeker, FileEnd)+Len("_Procedure")
            ProcEnd$ = #SystemEOL ; +"}"
       
          Else       
            
            Debug "xx PeekS(FileSeeker, 120) = "+PeekS(FileSeeker, 120)+" * * * * *"+Str(FileSeeker)
   
            FileSeeker = FindNextString("macro MP", FileSeeker, FileEnd)+Len("macro MP")
            ProcEnd$ = #SystemEOL+"}"
        
          EndIf
         ;-MP Jan 2015
         
          Debug "21 PeekS(FileSeeker, 20) = "+PeekS(FileSeeker, 20)+" * * * * *"

          
          ;-MP Jan 2015
          ; FileSeeker = FindNextString("macro MP", FileSeeker, FileEnd)+Len("macro MP")
          ; ProcEnd$ = #SystemEOL+"}"

          
        CompilerElse
          FileSeeker = FindNextString("%macro MP", FileSeeker, FileEnd)+Len("%macro MP")
          ProcEnd$ = #SystemEOL+"%endmacro"
        CompilerEndIf
        
        
        FileSeeker = FindNextString(#SystemEOL, FileSeeker, FileEnd)+Len(#SystemEOL)
        Debug "22 PeekS(FileSeeker, 20) = "+PeekS(FileSeeker, 20)+" * * * * *"+Str(FileSeeker)
        
        
        ProcStart = FileSeeker
        FileSeeker = FindNextString("; EndProcedure", FileSeeker, FileEnd)
        Debug "23 PeekS(FileSeeker, 20) = "+PeekS(FileSeeker, 20)+" * * * * *"
        
        FileSeeker = FindNextString(ProcEnd$, FileSeeker, FileEnd)
        
        Debug "24 PeekS(FileSeeker, 20) = "+PeekS(FileSeeker, 20)+" * * * * *"
        
        ;-MP Jan 2015
        If PBnbVersion>=531
            
;            FileSeeker = FindNextString(Chr(10)+"  RET", FileSeeker, FileEnd)
            FileSeeker = FindNextString("RET", FileSeeker, FileEnd)
            Debug "25 RET = "+PeekS(FileSeeker, 20)+" * * * * *"
            FileSeeker = FindNextString(#SystemEOL, FileSeeker, FileEnd)
            ProcEnd = FileSeeker  
  
        Else  
        
             ProcEnd = FileSeeker
        
        EndIf
        ;-MP Jan 2015
                
        Debug "26 ProcEnd = "+PeekS(ProcEnd, 20)+" * * * * *"
        
        ProcSeeker = ProcStart
        
        If function()\DLLFunction
          ;-* decoration
          If function()\DebugFunction
            FileString$ = RemoveString(function()\Name$,"_DEBUG")+decoration+"_DEBUG.asm";this serves just to separate the code; in multilib mode only the ascii debug function is called (even in unicode mode)!!!
          Else
            FileString$ = function()\Name$+decoration+".asm"
          EndIf
        Else
          ;-* decoration
          FileString$ = "Shared"+#DirSeparator+RemoveString(function()\Name$+decoration+".asm", LibName$+"_")
        EndIf
        
        File0=CreateFile(#PB_Any, DestFolder$+"Functions"+#DirSeparator+FileString$)
        Debug "27 Filename = "+ DestFolder$+"Functions"+#DirSeparator+FileString$
        
        
        If File0
          WriteString(File2, #DQUOTE$+"Functions"+#DirSeparator+ReplaceString(FileString$, ".asm", ".obj")+#DQUOTE$+#SystemEOL)
          If WriteBatch
            WriteString(File3, GetASMCompilerCommand(1)+" "+ASMCompileParams("Functions"+#DirSeparator+FileString$,"Functions"+#DirSeparator+ReplaceString(FileString$, ".asm", ".obj"),1)+#SystemEOL)
          EndIf
          ClearList(external())
          CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS;OS X does not use format line
            If PBVersionX64
              WriteString(File0, "format "+#Asm_Formatx64+#SystemEOL+#SystemEOL)
            Else
              WriteString(File0, "format "+#Asm_Format+#SystemEOL+#SystemEOL)
            EndIf
          CompilerElse;however we define a macro here because fasm uses extrn whereas nasm uses extern - much easier than adding compilerif's everywhere
            WriteString(File0, "%macro extrn 1"+#SystemEOL+"extern %1"+#SystemEOL+"%endmacro"+#SystemEOL)
            WriteString(File0, "%macro Extrn 1"+#SystemEOL+"extern %1"+#SystemEOL+"%endmacro"+#SystemEOL);case sensitivity
            WriteString(File0, "%macro Public 1"+#SystemEOL+"global %1"+#SystemEOL+"%endmacro"+#SystemEOL);do the same for Public --> global
          CompilerEndIf
          If function()\RetValue$="InitFunction"
            If PBVersionX64
              WriteString(File0, "extrn SYS_InitString"+#SystemEOL+#SystemEOL)
            Else
              CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                WriteString(File0, "extrn _SYS_InitString@0"+#SystemEOL+#SystemEOL)
              CompilerElse
                CompilerIf #PB_Compiler_OS = #PB_OS_Linux
                  WriteString(File0, "extrn SYS_InitString"+#SystemEOL+#SystemEOL)
                CompilerElse
                  WriteString(File0, "extrn _SYS_InitString"+#SystemEOL+#SystemEOL)
                CompilerEndIf
              CompilerEndIf
            EndIf
          EndIf
          If function()\DLLFunction
            ;-* decoration
            If function()\DebugFunction
              If FindString(function()\Name$,"_DEBUG",1)
                If PBVersionX64
                  WriteString(File0, "Public PB_"+RemoveString(function()\Name$,"_DEBUG")+decoration+"_DEBUG"+#SystemEOL+#SystemEOL)
                Else
                  CompilerIf #PB_Compiler_OS <> #PB_OS_Linux 
                    WriteString(File0, "Public _PB_"+RemoveString(function()\Name$,"_DEBUG")+decoration+"_DEBUG"+#SystemEOL+#SystemEOL)
                  CompilerElse 
                    WriteString(File0, "Public PB_"+RemoveString(function()\Name$,"_DEBUG")+decoration+"_DEBUG"+#SystemEOL+#SystemEOL)
                  CompilerEndIf
                EndIf
              Else
                If PBVersionX64
                  WriteString(File0, "Public PB_"+function()\Name$+decoration+#SystemEOL+#SystemEOL)
                Else
                  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                    WriteString(File0, "Public _PB_"+function()\Name$+decoration+#SystemEOL+#SystemEOL)
                  CompilerElse
                    WriteString(File0, "Public PB_"+function()\Name$+decoration+#SystemEOL+#SystemEOL)
                  CompilerEndIf
                EndIf
              EndIf
            Else
              CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                WriteString(File0, "Public PB_"+function()\Name$+decoration+#SystemEOL+#SystemEOL)
              CompilerElse
                WriteString(File0, "global PB_"+function()\Name$+decoration+#SystemEOL+#SystemEOL)
              CompilerEndIf
            EndIf
          Else
            ;-* decoration
            CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
              WriteString(File0, "Public "+function()\Name$+decoration+#SystemEOL+#SystemEOL)
            CompilerElse
              WriteString(File0, "global "+function()\Name$+decoration+#SystemEOL+#SystemEOL)
            CompilerEndIf
          EndIf
          While ProcSeeker<ProcEnd
            ThisLine$ = GetNextString(ProcSeeker, #SystemEOL)
            ;-* bugfix decoration missing in labelname ABBKlaus 18.02.2011 18:04
            If Left(ThisLine$, Len(LibName$)+Len(decoration)+3)=LibName$+decoration+"_l_" Or Left(ThisLine$, Len(LibName$)+Len(decoration)+4)=LibName$+decoration+"_ll_"
              
              ;Debug ThisLine$
              ;CallDebugger
              
              If FindString(ThisLine$, ";", 1)
                ThisLine$ = RTrim(GetNextString(ProcSeeker, ";"))
                If FindString(ThisLine$, q, 1)
                  ThisLine$ = GetNextString(ProcSeeker, #SystemEOL)
                EndIf
              EndIf
              AddElement(label())
              label()\LabelName = RemoveString(ThisLine$, ":")
              label()\FunctionName = function()\Name$
             
              WriteLog("LabelName->"+label()\LabelName)
              WriteLog("LabelFunction->"+label()\FunctionName)
              ;Debug "LabelName->"+label()\LabelName
              ;Debug "LabelFunction->"+label()\FunctionName
            Else
              ; bugfix aligngosub (found by lexvictory) ABBKlaus 11.1.2009 15:04
              If Left(ThisLine$,10)="aligngosub"
                ;-* ExternalProc 2
                ExternalProc(ThisLine$,2,decoration)
              EndIf
            EndIf
            ProcSeeker = FindNextString(#SystemEOL, ProcSeeker, ProcEnd)+Len(#SystemEOL) ; bugfix ABBKlaus 13.12.2007 20:30
          Wend
          ProcSeeker = ProcStart
          EndProcOffset = 0
          While ProcSeeker<ProcEnd
            AlreadyThere = 0
            ThisLine$ = ""
            ThisLine$ = GetNextString(ProcSeeker, #SystemEOL)
            If function()\RetValue$="String"
              If Left(ThisLine$, 13)="_EndProcedure" And EndProcOffset=0
                EndProcOffset = ProcSeeker+Len(ThisLine$)
                EndProcOffset = FindNextString(#SystemEOL+"RET", EndProcOffset, ProcEnd)+Len(#SystemEOL)
                ;
                ;
                If function()\DLLFunction ; ONLY IF EXPORTED FUNCTION !!!
                  CompilerIf #PB_Compiler_OS = #PB_OS_Windows;only used on windows!
                    If IsPB420
                      RETX4 = #True ;- gnozal PB4.20 fix
                    EndIf
                  CompilerEndIf
                EndIf
                ;
                ;
              EndIf
            EndIf
            CallFunc = 0
            If Left(ThisLine$, 5)="CALL "
              FnStr$ = RTrim(LTrim(RemoveString(ThisLine$, "CALL ")))
              CallFunc = 1
            ElseIf Left(ThisLine$, 4)="JMP "
              FnStr$ = RTrim(LTrim(RemoveString(ThisLine$, "JMP ")))
              If Left(FnStr$, Len(LibName$+"__PB_"))=LibName$+"__PB_"
                CallFunc = 1
              EndIf
            ; Bugfix for Extrn of Imported functions (found by Gnozal) ABBKlaus 13.7.2011 23:39
            ElseIf Left(ThisLine$, Len(#Asm_MOV_EAX_EXTERNAL)+1)=#Asm_MOV_EAX_EXTERNAL+"_"
              FnStr$ = Trim(RemoveString(ThisLine$,#Asm_MOV_EAX_EXTERNAL))
              CallFunc = 1
            EndIf
            Select FnStr$;- merge TB_* userlibs into Libname$ userlib
              Case "PB_TB_GetGadgetParent"
                AddTB_GadgetExtension = 1
                FnStr$ = LibName$+"_TB_GetGadgetParent"
              Case "PB_TB_RegisterGadget"
                AddTB_GadgetExtension = 1
                FnStr$ = LibName$+"_TB_RegisterGadget"
;               Case "PB_TB_SetGadget"
;                 AddTB_GadgetExtension = 1
;                 FnStr$ = LibName$+"_TB_SetGadget"
;               Case "PB_TB_UsedWindow"
;                 AddTB_GadgetExtension = 1
;                 FnStr$ = LibName$+"_TB_UsedWindow"
              Case "PB_TB_hInstance"
                AddTB_GadgetExtension = 1
                FnStr$ = LibName$+"_TB_hInstance"
              Case "PB_TB_DebugError"
                AddTB_Debugger = 1
                If function()\DebugFunction
                  ;CallDebugger
                  FnStr$ = LibName$+"_TB_DebugError_DEBUG"
                Else
                  FnStr$ = LibName$+"_TB_DebugError"
                EndIf
              Case "PB_TB_DebugWarning"
                AddTB_Debugger = 1
                ;CallDebugger
                If function()\DebugFunction
                  ;CallDebugger
                  FnStr$ = LibName$+"_TB_DebugWarning_DEBUG"
                Else
                  FnStr$ = LibName$+"_TB_DebugWarning"
                  ;CallDebugger
                EndIf
              Case "PB_TB_DebugCheckUnicode"
                AddTB_Debugger = 1
                If function()\DebugFunction
                  ;CallDebugger
                  FnStr$ = LibName$+"_TB_DebugCheckUnicode_DEBUG"
                Else
                  FnStr$ = LibName$+"_TB_DebugCheckUnicode"
                EndIf
              Case "PB_TB_DebugCheckLabel"
                AddTB_Debugger = 1
                If function()\DebugFunction
                  ;CallDebugger
                  FnStr$ = LibName$+"_TB_DebugCheckLabel_DEBUG"
                Else
                  FnStr$ = LibName$+"_TB_DebugCheckLabel"
                EndIf
              Case "PB_TB_DebugFileExists"
                AddTB_Debugger = 1
                If function()\DebugFunction
                  ;CallDebugger
                  FnStr$ = LibName$+"_TB_DebugFileExists_DEBUG"
                Else
                  FnStr$ = LibName$+"_TB_DebugFileExists"
                EndIf
              Case "PB_TB_DebugCheckProcedure"
                AddTB_Debugger = 1
                If function()\DebugFunction
                  ;CallDebugger
                  FnStr$ = LibName$+"_TB_DebugCheckProcedure_DEBUG"
                Else
                  FnStr$ = LibName$+"_TB_DebugCheckProcedure"
                EndIf
              Case "_PB_TB_DebugError"+decoration+"_DEBUG"
                AddTB_Debugger = 1
                ;- * decoration
                If decoration<>""
                  FnStr$ = LibName$+"_TB_DebugError"+decoration+"_DEBUG"
                Else
                  FnStr$ = LibName$+"_TB_DebugError_DEBUG"
                EndIf
              Case "PB_TB_RegisterImageEncoder"
                AddTB_ImagePlugin = 1
                FnStr$ = LibName$+"_TB_RegisterImageEncoder"
              Case "PB_TB_RegisterImageDecoder"
                AddTB_ImagePlugin = 1
                FnStr$ = LibName$+"_TB_RegisterImageDecoder"
              Default 
                If function()\Name$ = "MyProcedure_DEBUG"
                  ;Debug FnStr$
                EndIf
            EndSelect
            If CallFunc
            ;CallDebugger
              If Left(FnStr$, 5)="dword" Or Left(FnStr$, 5)="qword"
                FnStr$ = RemoveString(FnStr$, "dword")
                FnStr$ = RemoveString(FnStr$, "qword")
                FnStr$ = RemoveString(FnStr$, "[")
                FnStr$ = LTrim(RTrim(RemoveString(FnStr$, "]")))
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  ;FnStr$ = RemoveString(FnStr$, "PStub");-remove pstub (for extern list) for imported funcs (OSX)
                CompilerEndIf
              EndIf
              AlreadyThere = 0
              ForEach external()
                If FnStr$=external()
                  AlreadyThere = 1
                  Break
                EndIf
              Next
              If AlreadyThere=0
                If RemoveString(FnStr$, ":")="PB_"+function()\Name$
                  AlreadyThere = 1
                ;ElseIf Trim(LCase(FnStr$))="esp" Or Trim(LCase(Left(FnStr$, 4)))="esp+"
                  ;AlreadyThere = 1
                ;ElseIf Trim(LCase(FnStr$))="eax" Or Trim(LCase(Left(FnStr$, 4)))="eax+" or Trim(LCase(FnStr$))="rax" Or Trim(LCase(Left(FnStr$, 4)))="rax+"
                  ;AlreadyThere = 1
                ;ElseIf Trim(LCase(FnStr$))="ebx" Or Trim(LCase(Left(FnStr$, 4)))="ebx+"
                  ;AlreadyThere = 1
                ;ElseIf Trim(LCase(FnStr$))="ecx" Or Trim(LCase(Left(FnStr$, 4)))="ecx+"
                  ;AlreadyThere = 1
                ;ElseIf Trim(LCase(FnStr$))="edx" Or Trim(LCase(Left(FnStr$, 4)))="edx+"
                  ;AlreadyThere = 1
                ;ElseIf Trim(LCase(FnStr$))="ebp" Or Trim(LCase(Left(FnStr$, 4)))="ebp+"
                  ;AlreadyThere = 1
                Else
                  ForEach label()
                    If RemoveString(FnStr$, ":")=label()\LabelName
                      AlreadyThere = 1
                      Break
                    EndIf
                  Next
                EndIf
                Select Trim(LCase(FnStr$)); x64 fix lexvictory 20-1-11
                  Case "eax", "ebx", "ecx", "edx", "ebp", "esp", "esi", "edi", "rax", "rbx", "rcx", "rdx", "rbp", "rsp", "rsi", "rdi", "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15"
                    AlreadyThere = 1
                  Default
                    Select Trim(LCase(Left(FnStr$, 4)))
                      Case "eax+", "ebx+", "ecx+", "edx+", "ebp+", "esp+", "esi+", "edi+", "rax+", "rbx+", "rcx+", "rdx+", "rbp+", "rsp+", "rsi+", "rdi+", "r8+", "r9+", "r10+", "r11+", "r12+", "r13+", "r14+", "r15+"
                        AlreadyThere = 1
                    EndSelect
                EndSelect
                If AlreadyThere=0
                  If FindString(FnStr$, "@", 1) And Left(FnStr$, 3)<>"PB_" And Left(FnStr$, 4)<>"_PB_" And Left(FnStr$, 5)<>"_SYS_"
                    AlreadyThere = 0
                    ForEach ApiFunction()
                      If FnStr$=ApiFunction()
                        AlreadyThere = 1
                        Break
                      EndIf
                    Next
                    If AlreadyThere=0
                      AddElement(ApiFunction())
                      ApiFunction() = FnStr$
                    EndIf
                  EndIf
                  ;bugfig: Extrn Bug ABBKlaus 12.4.2007 22:43 / 11.12.2007 bugfix: do not 'Extrn label'
                  ;-* ExternalProc 0
                  ExternalProc(FnStr$,0,decoration)
                EndIf
              EndIf
            EndIf
            ProcSeeker = FindNextString(#SystemEOL, ProcSeeker, ProcEnd)+Len(#SystemEOL)
          Wend
          WriteString(File0, #SystemEOL)
          ;bugfig: Extrn Bug ABBKlaus 12.4.2007 22:43
          ProcSeeker = ProcStart
          While ProcSeeker<ProcEnd
            ThisLine$ = GetNextString(ProcSeeker, #SystemEOL)
            If FindString(ThisLine$, ";", 1)
              ThisLine$ = RTrim(GetNextString(ProcSeeker, ";"))
              If FindString(ThisLine$, #DQUOTE$, 1)
                ThisLine$ = GetNextString(ProcSeeker, #SystemEOL)
              EndIf
            EndIf
            If Len(ThisLine$)>0
              WhP = FindString(ThisLine$, LibName$+"_", 1)
              If WhP=0:WhP = FindString(ThisLine$, "_PB_", 1):EndIf
              If WhP=0:WhP = FindString(ThisLine$, "PB_", 1):EndIf
              If WhP>1 And Left(ThisLine$, 5)<>"CALL " And UCase(Left(ThisLine$, 4))<>"JMP "
                ChP$ = Mid(ThisLine$, WhP-1, 1)
                If ChP$="[" Or ChP$="," Or ChP$=" "
                  If ChP$="["
                    ChEnd$ = "]"
                  Else
                    ChEnd$ = #SystemEOL
                  EndIf
                  AlreadyThere = 0
                  FnStr$ = GetNextString(ProcSeeker+WhP-1, ChEnd$)
                  If FindString(FnStr$, ";", 1)
                    FnStr$ = RTrim(GetNextString(@FnStr$, ";"))
                    If FindString(FnStr$, #DQUOTE$, 1)
                      FnStr$ = GetNextString(ProcSeeker+WhP-1, ChEnd$)
                    EndIf
                  EndIf
                  If FindString(FnStr$, "+", 1)
                    FnStr$ = GetNextString(@FnStr$, "+")
                  EndIf
                  If FindString(FnStr$, "-", 1)
                    FnStr$ = GetNextString(@FnStr$, "-")
                  EndIf
                  If Left(FnStr$, 4)="_PB_"
                    pos = FindString(FnStr$, "_", 5)
                    If pos
                      PBIncludeLib$ = Mid(FnStr$, 5, pos-5)
                      Dir0=ExamineDirectory(#PB_Any, PBFolder$+"purelibraries"+#DirSeparator, "")
                      If Dir0
                        While NextDirectoryEntry(Dir0)
                          If DirectoryEntryName(Dir0)=PBIncludeLib$
                            ForEach PBLib()
                              If PBLib()=PBIncludeLib$
                                AlreadyThere = 1
                                Break
                              EndIf
                            Next
                            If AlreadyThere=0
                              AddElement(PBLib())
                              PBLib() = PBIncludeLib$
                            EndIf
                            Break
                          EndIf
                        Wend
                        FinishDirectory(Dir0)
                      EndIf
                    EndIf
                  EndIf
                  AlreadyThere = 0
                  ForEach external()
                    If FnStr$=external()
                      AlreadyThere = 1
                      Break
                    EndIf
                  Next
                  If AlreadyThere=0
                    ForEach label()
                      If FnStr$=label()\LabelName
                        AlreadyThere = 1
                        Break
                      EndIf
                    Next
                    ;-* decoration
                    If StringField(FnStr$, 1, " ")="PB_"+Function()\Name$+decoration
                      AlreadyThere=1
                    EndIf
                    ;bugfig: 12.12.2007 15:42 bugfix: do not 'Extrn label'
                    If AlreadyThere=0
                      ;-* ExternalProc 1
                      ExternalProc(FnStr$,1,decoration)
                    EndIf
                  EndIf
                EndIf
              EndIf
            EndIf
            ProcSeeker = FindNextString(#SystemEOL, ProcSeeker, ProcEnd)+Len(#SystemEOL)
          Wend
                    
          ClearList(label())
          ForEach external()
            ; bugfix aligngosub (found by lexvictory) ABBKlaus 11.1.2009 15:04
            If Left(external(),10)="aligngosub"
              CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                WriteString(File0, "define "+external()+#SystemEOL)
              CompilerElse
                WriteString(File0, "%define "+external()+#SystemEOL)
              CompilerEndIf
            Else
              ;bugfix do not extrn symbol that is already public ABBKlaus 14.1.2009 18:39
              ;-* decoration
              If function()\DLLFunction=0
                If function()\Name$+decoration=external()
                  ;do not extern symbol
                Else
                  WriteString(File0, "Extrn "+external()+#SystemEOL)
                EndIf
              Else
                If "PB_"+function()\Name$+decoration=external()
                  ;do not extern symbol
                Else
                  WriteString(File0, "Extrn "+external()+#SystemEOL)
                EndIf
              EndIf
            EndIf
          Next
          ClearList(external())
          WriteString(File0, #SystemEOL+#SystemEOL+#Asm_TextSection+#SystemEOL+#SystemEOL)
          If function()\RetValue$="InitFunction"
            LabelStart = FindNextString(":", ProcStart, ProcEnd)+Len(#SystemEOL)
            LabelStart = FindNextString(":", LabelStart, ProcEnd)+Len(#SystemEOL)
            If PBVersionX64
              WriteString(File0, "call SYS_InitString"+#SystemEOL)
            Else
              CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                WriteString(File0, "call _SYS_InitString@0"+#SystemEOL)
              CompilerElse
                CompilerIf #PB_Compiler_OS = #PB_OS_Linux
                  WriteString(File0, "call SYS_InitString"+#SystemEOL)
                CompilerElse
                  WriteString(File0, "call _SYS_InitString"+#SystemEOL)
                CompilerEndIf
              CompilerEndIf
            EndIf
            WriteData(File0, ProcStart, LabelStart-ProcStart)
            ProcStart = LabelStart
          EndIf
          If (ProcEnd-ProcStart)>0
            WriteData(File0, ProcStart, ProcEnd-ProcStart)
          EndIf
          ;
          ;
          CompilerIf #PB_Compiler_OS = #PB_OS_Windows;extra safeguard
            If RETX4 ;- gnozal PB4.20 fix [Thanks Fred!]
              If PBVersionX64
                ;WriteString(File0, " + 8")
              Else
                WriteString(File0, " + 4")
              EndIf
            EndIf
          CompilerEndIf
          ;
          ;
          CloseFile(File0)
        EndIf
      EndIf
    Wend
    ForEach function()
      If function()\RetValue$="InitFunction" And function()\FIndex=-1
        File0=CreateFile(#PB_Any, DestFolder$+"Functions"+#DirSeparator+LibName$+"_Init"+decoration+".asm")
        If File0
          If PBVersionX64
            WriteString(File0, "format "+#Asm_Formatx64+#SystemEOL+#SystemEOL+"extrn SYS_InitString"+#SystemEOL+#SystemEOL)
          Else
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
              WriteString(File0, "format "+#Asm_Format+#SystemEOL+#SystemEOL+"extrn _SYS_InitString@0"+#SystemEOL+#SystemEOL)
            CompilerElse
              CompilerIf #PB_Compiler_OS = #PB_OS_Linux
                WriteString(File0, "format "+#Asm_Format+#SystemEOL+#SystemEOL+"extrn SYS_InitString"+#SystemEOL+#SystemEOL)
              CompilerElse
                WriteString(File0, #SystemEOL+"extern _SYS_InitString"+#SystemEOL+#SystemEOL)
;                 WriteString(File0, #SystemEOL+"extern "+LibName$+"_PB_ArgV"+#SystemEOL)
;                 WriteString(File0, "extern "+Libname$+"_PB_InitialStackValue"+#SystemEOL)
;                 WriteString(File0, #SystemEOL+"extern "+Libname$+"_PB_ArgC"+#SystemEOL)
              CompilerEndIf
            CompilerEndIf
          EndIf
          CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
            WriteString(File0, "Public PB_"+LibName$+"_Init"+decoration+#SystemEOL+#SystemEOL+#Asm_TextSection+#SystemEOL+#SystemEOL)
          CompilerElse
            WriteString(File0, "global PB_"+LibName$+"_Init"+decoration+#SystemEOL+#SystemEOL+#Asm_TextSection+#SystemEOL+#SystemEOL)
          CompilerEndIf
          WriteString(File0, "PB_"+LibName$+"_Init"+decoration+":"+#SystemEOL)
          If PBVersionX64
            WriteString(File0, "call SYS_InitString"+#SystemEOL+#SystemEOL)
          Else
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
              WriteString(File0, "call _SYS_InitString@0"+#SystemEOL+#SystemEOL)
            CompilerElse
              CompilerIf #PB_Compiler_OS = #PB_OS_Linux
                WriteString(File0, "call SYS_InitString"+#SystemEOL+#SystemEOL)
              CompilerElse
;                 WriteString(File0, "MOV eax, [esp+4]"+#SystemEOL)
;                 WriteString(File0, "MOV ["+LibName$+"_PB_ArgC], eax"+#SystemEOL)
;                 WriteString(File0, "MOV eax, [esp+8]"+#SystemEOL)
;                 WriteString(File0, "MOV ["+LibName$+"_PB_ArgV], eax"+#SystemEOL)
;                 ;WriteString(File0, "SUB esp,12"+#SystemEOL)
;                 WriteString(File0, "MOV ["+LibName$+"_PB_InitialStackValue],esp"+#SystemEOL)
                WriteString(File0, "call _SYS_InitString"+#SystemEOL+#SystemEOL)
              CompilerEndIf
            CompilerEndIf
          EndIf
          WriteString(File0, "RET"+#SystemEOL)
          CloseFile(File0)
          WriteString(File2, #DQUOTE$+"Functions"+#DirSeparator+LibName$+"_Init"+decoration+".obj"+#DQUOTE$+#SystemEOL)
          If WriteBatch
            WriteString(File3, GetASMCompilerCommand(1)+" "+ASMCompileParams("Functions"+#DirSeparator+LibName$+"_Init"+decoration+".asm","Functions"+#DirSeparator+LibName$+"_Init"+decoration+".obj",1)+#SystemEOL)
          EndIf
        EndIf
        Break
      EndIf
    Next
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows;needed since linux has x64 now!
      If PBVersionX64;no point looping if isnt even x64
        ForEach function();for some reason it doesn't work as an elseif in the loop above for floatAndDouble.pb - purepdf seems to work fine!
          If function()\DLLFunction And (function()\RetValue$ = "Float" Or function()\RetValue$ = "Double");-float fix attempt 2
            Debug "float func to scan: "+function()\Name$
            Protected floatFixFile = OpenFile(#PB_Any, DestFolder$+"Functions"+#DirSeparator+function()\Name$+decoration+".asm")
            Protected floatFixTemp = CreateFile(#PB_Any, DestFolder$+"Functions"+#DirSeparator+function()\Name$+decoration+"_temp.asm")
            If floatFixFile And floatFixTemp
              ;Debug "files loaded"
              While Eof(floatFixFile) = 0
                ThisLine$ = ReadString(floatFixFile)
                If Len(ThisLine$)
                  If function()\floatreturnfound
                    If UCase(Left(ThisLine$, 4)) = "FLD ";used procedurereturn variable
                      Debug "fld found"
                      function()\floatreturnfound = 0;in case there are more procedure returns!
                      ;ThisLine$ + #SystemEOL+"FSTP dword [edx]"+#SystemEOL
                      If function()\RetValue$ = "Float"
                        ThisLine$ = "MOVD xmm0, "+Right(ThisLine$, Len(ThisLine$)-4)+#SystemEOL
                      Else;double
                        ThisLine$ = "MOVSD xmm0, "+Right(ThisLine$, Len(ThisLine$)-4)+#SystemEOL
                      EndIf
                      ;ThisLine$ + "movaps xmm0, [edx]";"MOVSXD rax,eax"+#SystemEOL+
                    ElseIf UCase(Left(ThisLine$, 4)) = "RET";used ProcedureReturn anotherProcedure() so PB thinks FSTP will be done in calling program.
                      Debug "RET found, ProcedureReturn'ed a procedure"
                      If function()\RetValue$ = "Float"
                        ThisLine$ = "FSTP dword ["+function()\Name$+"_floatfix]"+#SystemEOL+"MOVD xmm0, dword ["+function()\Name$+"_floatfix]"+#SystemEOL+"RET"+#SystemEOL
                        ThisLine$ + "section '.data' readable writeable"+#SystemEOL+function()\Name$+"_floatfix: dw 4";pop the float into our variable, and shift it into the right place. using registers causes memory errors!
                      Else;double
                        ThisLine$ = "FSTP qword ["+function()\Name$+"_floatfix]"+#SystemEOL+"MOVSD xmm0, qword ["+function()\Name$+"_floatfix]"+#SystemEOL+"RET"+#SystemEOL
                        ThisLine$ + "section '.data' readable writeable"+#SystemEOL+function()\Name$+"_floatfix: dq 8";pop the double into our variable, and shift it into the right place.
                      EndIf
                    EndIf
                  ElseIf FindString(ThisLine$, "; ProcedureReturn", 1)
                    function()\floatreturnfound = 1
                    Debug "float return found"
                  EndIf
                EndIf
                WriteStringN(floatFixTemp, ThisLine$)
              Wend
              ;close and replace the files.
              CloseFile(floatFixFile)
              CloseFile(floatFixTemp)
              DeleteFile(DestFolder$+"Functions"+#DirSeparator+function()\Name$+decoration+".asm")
              RenameFile(DestFolder$+"Functions"+#DirSeparator+function()\Name$+decoration+"_temp.asm", DestFolder$+"Functions"+#DirSeparator+function()\Name$+decoration+".asm")
            Else
              Debug "a File FAILED to load"
              If IsFile(floatFixFile) : CloseFile(floatFixFile) : EndIf 
              If IsFile(floatFixTemp) : CloseFile(floatFixTemp) : EndIf 
            EndIf
          EndIf
        Next 
      EndIf 
    CompilerEndIf

    File0=CreateFile(#PB_Any, DestFolder$+"Functions"+#DirSeparator+LibName$+"Shared"+decoration+".asm");-shared asm
    File4=CreateFile(#PB_Any, DestFolder$+"Functions"+#DirSeparator+LibName$+"SharedTemp"+decoration+".asm")
    If File0 And File4
      WriteString(File2, #DQUOTE$+"Functions"+#DirSeparator+LibName$+"Shared"+decoration+".obj"+#DQUOTE$+#SystemEOL)
      If WriteBatch
        WriteString(File3, GetASMCompilerCommand(1)+" "+ASMCompileParams("Functions"+#DirSeparator+LibName$+"Shared"+decoration+".asm","Functions"+#DirSeparator+LibName$+"Shared"+decoration+".obj",1)+#SystemEOL)
      EndIf
      CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS  
        If PBVersionX64
          WriteString(File0, "format "+#Asm_Formatx64+#SystemEOL+#SystemEOL)
        Else
          WriteString(File0, "format "+#Asm_Format+#SystemEOL+#SystemEOL)
        EndIf
        WriteString(File0, "macro pb_public symbol"+#SystemEOL)
        WriteString(File0, "{"+#SystemEOL)
        WriteString(File0, " public  _#symbol"+#SystemEOL)
        WriteString(File0, " public symbol"+#SystemEOL)
        WriteString(File0, "_#symbol:"+#SystemEOL)
        WriteString(File0, "symbol:"+#SystemEOL)
        WriteString(File0, "}"+#SystemEOL+#SystemEOL)
      CompilerElse
        WriteString(File0, "%macro pb_public 1"+#SystemEOL)
        WriteString(File0, "  global _%1"+#SystemEOL)
        WriteString(File0, " global %1"+#SystemEOL)
        WriteString(File0, "_%1:"+#SystemEOL)
        WriteString(File0, "%1:"+#SystemEOL)
        WriteString(File0, "%EndMacro"+#SystemEOL)
        WriteString(File0, "%macro Public 1"+#SystemEOL);to deal with fasm formatted commands
        WriteString(File0, "global %1"+#SystemEOL)
        WriteString(File0, "%EndMacro"+#SystemEOL)
        WriteString(File0, "%macro public 1"+#SystemEOL)
        WriteString(File0, "global %1"+#SystemEOL)
        WriteString(File0, "%EndMacro"+#SystemEOL+#SystemEOL)
      CompilerEndIf
;       CompilerIf #PB_Compiler_OS = #PB_OS_Linux
;         WriteString(File0, "Public DBL"+decoration+#SystemEOL+#SystemEOL+#Asm_TextSection+#SystemEOL+#SystemEOL)
;         WriteString(File0, "DBL"+decoration+":"+#SystemEOL)
;         WriteString(File0, "PUSHAD"+#SystemEOL)
;         WriteString(File0, "PUSHFD"+#SystemEOL)
;         WriteString(File0, "PUSH   esp"+#SystemEOL)
;         WriteString(File0, "PUSH   dword [esp+44]"+#SystemEOL)
;         WriteString(File0, "CALL   PB_DEBUGGER_Check"+#SystemEOL)
;         WriteString(File0, "ADD    esp,8"+#SystemEOL)
;         WriteString(File0, "Or     eax,eax"+#SystemEOL)
;         WriteString(File0, "JZ    .End"+#SystemEOL)
;         WriteString(File0, "JMP   _PB_EOP"+#SystemEOL)
;         WriteString(File0, ".End:"+#SystemEOL)
;         WriteString(File0, "POPFD"+#SystemEOL)
;         WriteString(File0, "POPAD"+#SystemEOL)
;         WriteString(File0, "RET    4"+#SystemEOL)
;       CompilerEndIf
      CompilerSelect  #PB_Compiler_OS
        CompilerCase #PB_OS_Windows
          DataSectionString$ = "section '.data' data readable writeable"+#SystemEOL+";"+#SystemEOL+"_PB_DataSection:"
        CompilerCase #PB_OS_MacOS
          DataSectionString$ = "section .data"+#SystemEOL+"pb_public PB_DEBUGGER_LineNumber"
        CompilerCase #PB_OS_Linux
          DataSectionString$ = "section '.data' writeable"+#SystemEOL+"pb_public PB_DEBUGGER_LineNumber"
      CompilerEndSelect
      
      ;MP Jan 2015
      If PBnbVersion>524
         FileSeeker = FileStart
      
      EndIf
      ;MP Jan 2015
      
      FileSeeker = FindNextString(DataSectionString$, FileSeeker, FileEnd)+Len(DataSectionString$)+Len(#SystemEOL)
      searching = 1
      firstdata = 1
      While FileSeeker<FileEnd And searching
        
        Debug "28 DataSectionString$ = "+PeekS(FileSeeker, 200)+" * * * * *"
        
        ThisLine$ = GetNextString(FileSeeker, #SystemEOL)
        FileSeeker = FindNextString(#SystemEOL, FileSeeker, FileEnd)+Len(#SystemEOL)
        If ThisLine$<>";"
          If Left(ThisLine$, 3)<>"_PB" And Left(ThisLine$, 3)<>"PB_"
            ;Debug #DQUOTE$+ThisLine$+#DQUOTE$
            If firstdata
              CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                  WriteString(File4, "section '.data' data readable writeable"+#SystemEOL)
                  WriteString(File4, "macro " + pb_align$ + " Value { rb (Value-1) - ($-"+LibName$+"_PB_DataSection + Value-1) mod Value }"+#SystemEOL) ;gnozal 24/05/2007 fix for PB410
                CompilerElse
                  WriteString(File4, "section '.data' writeable"+#SystemEOL)
                CompilerEndIf
                WriteString(File4, LibName$+"_PB_DataSection:"+#SystemEOL)
                WriteString(File0, "Public "+LibName$+"_PB_DataSection"+#SystemEOL)
                ;WriteString(File0, "Public "+LibName$+"_IsMultiLib"+#SystemEOL)
                ;WriteString(File4, LibName$+"_IsMultiLib:  dw "+Str(MultiLib)+#SystemEOL)
              CompilerElse
                WriteString(File4, "section .data"+#SystemEOL)
                WriteString(File4, LibName$+"_PB_DataSection"+decoration+":"+#SystemEOL)
                WriteString(File0, "global "+LibName$+"_PB_DataSection"+#SystemEOL)
                ;WriteString(File4, "pb_public PB_DEBUGGER_LineNumber"+#SystemEOL)
              CompilerEndIf
              firstdata = 0
            EndIf
            If FindString(ThisLine$, ":", 1)
              CheckLine$ = GetNextString(@ThisLine$, ":")
            Else
              CheckLine$ = Trim(StringField(ThisLine$, 1, " "))
            EndIf
            If CheckLine$<>"align" And CheckLine$<>pb_align$ And CheckLine$<>"dd" And CheckLine$<>"db" And CheckLine$<>"dw" And CheckLine$<>"dq" ;gnozal 24/05/2007 fix for PB410
              If CheckLine$<>"public" And CheckLine$<>"pb_public" And CheckLine$<>"global"
                ;-* decoration not needed !
                CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                  WriteString(File0, "Public "+CheckLine$+#SystemEOL)
                CompilerElse
                  WriteString(File0, "global "+CheckLine$+#SystemEOL)
;                   If Left(CheckLine$, 5) = "PStub"
;                     WriteString(File0, "extern "+RemoveString(CheckLine$, "PStub")+#SystemEOL);pb internal functions (usually debug)
;                   EndIf
                CompilerEndIf
              EndIf
            EndIf
            If Left(ThisLine$, Len("public "))<>"public " And  Left(ThisLine$, Len("pb_public "))<>"pb_public " And Left(ThisLine$, Len("global "))<>"global " And Left(ThisLine$, 7) <> "dd _PB_";dd _PB_ is for OSX.
              ;-* decoration not needed !
              WriteString(File4, ThisLine$+#SystemEOL)
            EndIf
          EndIf
        Else
          searching = 0
        EndIf
      Wend
      
      ;CallDebugger
      WriteString(File0, #SystemEOL)
      WriteString(File4, #SystemEOL)
      CompilerIf #PB_Compiler_OS =#PB_OS_Windows
        BssSectionString$ = "section '.bss' readable writeable"+#SystemEOL+"_PB_BSSSection:"
      CompilerElse
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            BssSectionString$ = "section .bss"+#SystemEOL+"_PB_BSSSection:"
          CompilerElse
            BssSectionString$ = "_PB_BSSSection:"+#LF$
          CompilerEndIf
      CompilerEndIf
      FileSeeker = FindNextString(BssSectionString$, FileSeeker, FileEnd)
      ;Debug PeekS(FileSeeker, 15)
      ;FileSeeker = FindNextString(";"+#CRLF$+pb_bssalign$+" 4", FileSeeker, FileEnd)+1+Len(#CRLF$) ;gnozal 24/05/2007 fix for PB410
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Windows
          FileSeeker = FindNextString(";"+#SystemEOL, FileSeeker, FileEnd)+Len(#SystemEOL)+1 ; ABBKlaus 25.9.2008 00:43 fix for the fix for PB4.30B2
        CompilerCase #PB_OS_MacOS;- osx: check this still works - will probably need an extra one.
          FileSeeker = FindNextString(";"+#SystemEOL, FileSeeker, FileEnd)+Len(#SystemEOL)+1 ; 
        CompilerCase #PB_OS_Linux ;linux has a space after the ;
          FileSeeker = FindNextString(";"+#SystemEOL, FileSeeker, FileEnd)+Len(#SystemEOL)+1 ; 
      CompilerEndSelect
      ;Debug PeekS(FileSeeker, 15)
      searching = 1
      firstdata = 1
      While FileSeeker<FileEnd And searching
        ThisLine$ = GetNextString(FileSeeker, #SystemEOL)
        FileSeeker = FindNextString(#SystemEOL, FileSeeker, FileEnd)+Len(#SystemEOL)
        If ThisLine$<>"I_BSSEnd:"
          If Mid(ThisLine$, 2, 1)="_" Or Left(ThisLine$, 3)="PB_"
            ThisLine$ = LibName$+"_"+ThisLine$
          EndIf
          If Left(ThisLine$, 7) = "_PB_Arg";OS X
            ThisLine$ = LibName$+ThisLine$
          ElseIf FindString(ThisLine$, "I_BSSStart", 1)
            ThisLine$ = ReplaceString(ThisLine$, "I_BSSStart", "I_BSSStart"+decoration)
            ;Debug ThisLine$
          EndIf
          If firstdata
            CompilerSelect #PB_Compiler_OS 
              CompilerCase #PB_OS_Windows
                WriteString(File4, "section '.bss' readable writeable"+#SystemEOL)
                WriteString(File4, "macro " + pb_bssalign$ + " Value { rb (Value-1) - ($-"+LibName$+"_PB_BSSSection"+decoration+" + Value-1) mod Value }"+#SystemEOL) ;gnozal 24/05/2007 fix for PB410
              CompilerCase #PB_OS_Linux
                ;WriteString(File4, "section '.bss'"+#SystemEOL)
              CompilerCase #PB_OS_MacOS
                WriteString(File4, "section .bss"+#SystemEOL)
            CompilerEndSelect
            WriteString(File4, LibName$+"_PB_BSSSection"+decoration+":"+#SystemEOL)
            WriteString(File0, "Public "+LibName$+"_PB_BSSSection"+decoration+#SystemEOL)
            firstdata = 0
          EndIf
          If FindString(ThisLine$, ":", 1)
            If decoration="" Or FindString(ThisLine$,decoration,1)
              WriteString(File0,"Public "+GetNextString(@ThisLine$, ":")+#SystemEOL)
            Else
              ;-* decoration
              WriteString(File0,"Public "+GetNextString(@ThisLine$, ":")+decoration+#SystemEOL)
            EndIf
          ElseIf FindString(ThisLine$, " r", 1)
            If decoration="" Or FindString(ThisLine$,decoration,1)
              WriteString(File0, "Public "+GetNextString(@ThisLine$, " ")+#SystemEOL)
            Else
              ;-* decoration
              WriteString(File0, "Public "+GetNextString(@ThisLine$, " ")+decoration+#SystemEOL)
            EndIf
          EndIf
          If decoration <> "" And FindString(ThisLine$, ":", 1)
            If FindString(ThisLine$,decoration,1)
              WriteString(File4, ReplaceString(ThisLine$, GetNextString(@ThisLine$, ":"), GetNextString(@ThisLine$, ":"))+#CRLF$)
            Else
              ;-* decoration
              WriteString(File4, ReplaceString(ThisLine$, GetNextString(@ThisLine$, ":"), GetNextString(@ThisLine$, ":")+decoration)+#CRLF$)
            EndIf
          ElseIf decoration <> "" And FindString(ThisLine$, " r", 1);PB_DataPointer doesnt have a :
            If FindString(ThisLine$,decoration,1)
              WriteString(File4, ReplaceString(ThisLine$, GetNextString(@ThisLine$, " "), GetNextString(@ThisLine$, " "))+#CRLF$)
            Else
              ;-* decoration
              WriteString(File4, ReplaceString(ThisLine$, GetNextString(@ThisLine$, " "), GetNextString(@ThisLine$, " ")+decoration)+#CRLF$)
            EndIf
          Else 
            WriteString(File4, ThisLine$+#CRLF$)
          EndIf
        Else
          searching = 0
        EndIf
      Wend
      WriteString(File0, #SystemEOL)
      WriteString(File4, #SystemEOL)
      CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
        PBDataSectionString$ = "section '.data' data readable writeable"
      CompilerElse
        PBDataSectionString$ = "section .data"
      CompilerEndIf
      FileSeeker = FindNextString(PBDataSectionString$, FileSeeker, FileEnd)+Len(PBDataSectionString$)+Len(#SystemEOL)
      searching = 1
      firstdata = 1
      While FileSeeker<FileEnd And searching
        ThisLine$ = GetNextString(FileSeeker, #SystemEOL)
        FileSeeker = FindNextString(#SystemEOL, FileSeeker, FileEnd)+Len(#SystemEOL)
        If ThisLine$<>"SYS_EndDataSection:"
          If firstdata
            CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
              WriteString(File4, "section '.data' data readable writeable"+#SystemEOL)
            CompilerElse
              WriteString(File4, "section .data"+#SystemEOL)
            CompilerEndIf
            firstdata = 0
          EndIf
          If Left(ThisLine$, Len("PB_DataSectionStart"))="PB_DataSectionStart"
            ThisLine$ = LibName$+"_"+ThisLine$
          EndIf
          If FindString(ThisLine$, ":", 1) And Left(ThisLine$, 5)<>"file "
            WriteString(File0, "Public "+GetNextString(@ThisLine$, ":")+#SystemEOL)
          EndIf
          ; bugfix for missing Extrn symbol found by Maxus ABBKlaus 26.2.2009 20:47
          If Left(ThisLine$,2)="dd"
            Symbol$=Trim(Mid(ThisLine$,3))
            found = #False
            ForEach function()
              If function()\Name$+decoration = Symbol$
                found = #True
                Break
              EndIf
            Next
            If found = #True
              WriteLog("Symbol Extrn'ed in shared asm proc : "+Symbol$)
              WriteString(File4, "Extrn "+Symbol$+#SystemEOL)
            EndIf
          EndIf
          WriteString(File4, ThisLine$+#SystemEOL)
        Else
          searching = 0
          WriteString(File0, "Public "+LibName$+"_SYS_EndDataSection"+decoration+#SystemEOL)
          WriteString(File4, LibName$+"_SYS_EndDataSection"+decoration+":"+#SystemEOL)
        EndIf
      Wend
      WriteString(File0, #SystemEOL)
      CloseFile(File4)
      File4=OpenFile(#PB_Any, DestFolder$+"Functions"+#DirSeparator+LibName$+"SharedTemp"+decoration+".asm")
      If File4
        TempSharedSize = Lof(File4)
        *TempShared = AllocateMemory(TempSharedSize)
        ReadData(File4, *TempShared, TempSharedSize)
        CloseFile(File4)
        WriteData(File0, *TempShared, TempSharedSize)
        FreeMemory(*TempShared)
      EndIf
      DeleteFile(DestFolder$+"Functions"+#DirSeparator+LibName$+"SharedTemp"+decoration+".asm")
      CloseFile(File0)
    Else
      If File0 And IsFile(File0)
        CloseFile(File0)
      EndIf
      If File4 And IsFile(File4)
        CloseFile(File4)
      EndIf
    EndIf
    ;CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
      If EndInclude
    ;CompilerElse
    ;  EndInclude = 0
    ;  If 0
    ;CompilerEndIf
      File0=CreateFile(#PB_Any, DestFolder$+"Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_End"+decoration+".asm")
      If File0
        found = 0
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          ForEach DLLList()
            If UCase(DLLList())="KERNEL32.DLL"
              found = 1
              Break
            EndIf
          Next
          If found = 0
            AddElement(DLLList())
            DLLList() = "KERNEL32.DLL"
          EndIf
        CompilerEndIf
        
        If PBVersionX64
          ;bugfix endfunctions for X64 ABBKlaus 14.1.2009 19:49
          WriteString(File0, "format "+#Asm_Formatx64+#SystemEOL+#SystemEOL)
          WriteString(File0, "Public "+LibName$+"__PB_EOP"+decoration+#SystemEOL+#SystemEOL)
          WriteString(File0, "Extrn HeapDestroy"+#SystemEOL)
          WriteString(File0, "Extrn ExitProcess"+#SystemEOL+#SystemEOL)
          WriteString(File0, "Extrn PB_EndFunctions"+#SystemEOL+#SystemEOL)
          WriteString(File0, "Extrn PB_MemoryBase"+#SystemEOL+#SystemEOL)
          WriteString(File0, #Asm_TextSection+#SystemEOL)
          WriteString(File0, LibName$+"__PB_EOP"+decoration+":"+#SystemEOL)
          WriteString(File0, "CALL   PB_EndFunctions"+#SystemEOL)
          WriteString(File0, "MOV   rcx,[PB_MemoryBase]"+#SystemEOL)
          WriteString(File0, "CALL  HeapDestroy"+#SystemEOL)
          WriteString(File0, "MOV   rcx,1"+#SystemEOL)
          WriteString(File0, "CALL  ExitProcess"+#SystemEOL)
          WriteString(File0, "JMP   PB_EndFunctions"+#SystemEOL)
        Else
          CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
            WriteString(File0, "format "+#Asm_Format+#SystemEOL+#SystemEOL)
            WriteString(File0, "Public "+LibName$+"__PB_EOP_NoValue"+decoration+#SystemEOL+#SystemEOL)
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
              WriteString(File0, "Extrn _HeapDestroy@4"+#SystemEOL)
              WriteString(File0, "Extrn _ExitProcess@4"+#SystemEOL+#SystemEOL)
            CompilerElse
              ;not sure if anything is needed for linux - lexvictory
              WriteString(File0, "extrn exit"+#SystemEOL+#SystemEOL)
            CompilerEndIf
            WriteString(File0, "Extrn _PB_EndFunctions"+#SystemEOL+#SystemEOL)
            WriteString(File0, "Extrn PB_MemoryBase"+#SystemEOL+#SystemEOL)
            WriteString(File0, #Asm_TextSection+#SystemEOL)
            WriteString(File0, LibName$+"__PB_EOP_NoValue"+decoration+":"+#SystemEOL)
            WriteString(File0, "PUSH   dword 0"+#SystemEOL)
            WriteString(File0, "_PB_EOP:"+#SystemEOL)
            WriteString(File0, "CALL  _PB_EndFunctions"+#SystemEOL)
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
              WriteString(File0, "PUSH   dword [PB_MemoryBase]"+#SystemEOL);this is for the call heapdestroy, yes? - lexvictory
              WriteString(File0, "CALL  _HeapDestroy@4"+#SystemEOL)
              WriteString(File0, "CALL  _ExitProcess@4"+#SystemEOL)
            CompilerElse
              ;again, not sure if/what needed for linux - lexvictory
              ;WriteString(File0, "PUSH   dword [PB_ExitCode]"+#SystemEOL+#SystemEOL)
              WriteString(File0, "CALL   exit"+#SystemEOL+#SystemEOL)
            CompilerEndIf
            WriteString(File0, "JMP  _PB_EndFunctions"+#SystemEOL)
          CompilerElse;OS X
            WriteString(File0, "global "+LibName$+"__PB_EOP_NoValue"+decoration+#SystemEOL+#SystemEOL)
            WriteString(File0, "extern _PB_EndFunctions"+#SystemEOL)
            WriteString(File0, "extern PB_InitialStackValue"+#SystemEOL)
            WriteString(File0, "extern PB_ExitCode"+#SystemEOL)
            WriteString(File0, "extern exit"+#SystemEOL)
            WriteString(File0, LibName$+"__PB_EOP_NoValue:"+#SystemEOL)
            WriteString(File0, "_PB_EOP:"+#SystemEOL)
            WriteString(File0, "CALL _PB_EndFunctions"+#SystemEOL)
            WriteString(File0, "MOV esp,[PB_InitialStackValue]"+#SystemEOL)
            WriteString(File0, "ADD esp,12"+#SystemEOL)
            WriteString(File0, "MOV eax,[PB_ExitCode]"+#SystemEOL)
            WriteString(File0, "PUSH eax"+#SystemEOL)
            WriteString(File0, "CALL exit"+#SystemEOL)
            ;WriteString(File0, "JMP  _PB_EndFunctions"+#SystemEOL)
            WriteString(File0, "RET"+#SystemEOL)
          CompilerEndIf
        EndIf
        CloseFile(File0)
        WriteString(File2, #DQUOTE$+"Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_End"+decoration+".obj"+#DQUOTE$+#SystemEOL)
        If WriteBatch
          WriteString(File3, GetASMCompilerCommand(1)+" "+ASMCompileParams("Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_End"+decoration+".asm","Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_End"+decoration+".obj",1)+#SystemEOL)
        EndIf
      EndIf
    EndIf
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows 
    If AddTB_GadgetExtension;-gadgetextention
      File0=CreateFile(#PB_Any, DestFolder$+"Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_GadgetExtension.asm")
      If File0
        found = 0
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          ForEach DLLList()
            If UCase(DLLList())="USER32.DLL"
              found = 1
              Break
            EndIf
          Next
          If found = 0
            AddElement(DLLList())
            DLLList() = "USER32.DLL"
          EndIf
        CompilerEndIf
        
        If PBVersionX64
          GadgetExtension$ = PeekS(?GadgetExtensionx64, ?GadgetExtensionx64End-?GadgetExtensionx64)
        Else
          GadgetExtension$ = PeekS(?GadgetExtension, ?GadgetExtensionEnd-?GadgetExtension)
        EndIf
        CallDebugger
        WriteString(File0, ReplaceString(GadgetExtension$, "TailBiteLibrary", LibName$))
        CloseFile(File0)
        WriteString(File2, #DQUOTE$+"Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_GadgetExtension.obj"+#DQUOTE$+#SystemEOL)
        If WriteBatch
          WriteString(File3, GetASMCompilerCommand(1)+" "+ASMCompileParams("Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_GadgetExtension.asm","Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_GadgetExtension.obj",1)+#SystemEOL)
        EndIf
      EndIf
    EndIf
    CompilerEndIf
    If AddTB_Debugger;-TB_DEBUGGER
      File0=CreateFile(#PB_Any, DestFolder$+"Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_Debugger.asm")
      If File0
        found = 0
        If PBVersionX64
          WriteString(File0, "format "+#Asm_Formatx64+#SystemEOL+#SystemEOL)
        Else
          WriteString(File0, "format "+#Asm_Format+#SystemEOL+#SystemEOL)
        EndIf
        WriteString(File0, "Public "+LibName$+"_TB_DebugError"+#SystemEOL+#SystemEOL)
        WriteString(File0, "Public "+LibName$+"_TB_DebugWarning"+#SystemEOL+#SystemEOL)
        WriteString(File0, "Public "+LibName$+"_TB_DebugCheckUnicode"+#SystemEOL+#SystemEOL)
        WriteString(File0, "Public "+LibName$+"_TB_DebugCheckLabel"+#SystemEOL+#SystemEOL)
        WriteString(File0, "Public "+LibName$+"_TB_DebugFileExists"+#SystemEOL+#SystemEOL)
        WriteString(File0, "Public "+LibName$+"_TB_DebugCheckProcedure"+#SystemEOL+#SystemEOL)
        WriteString(File0, #Asm_TextSection+#SystemEOL)
        WriteString(File0, LibName$+"_TB_DebugError:"+#SystemEOL)
        WriteString(File0, "    ret"+#SystemEOL)
        WriteString(File0, LibName$+"_TB_DebugWarning:"+#SystemEOL)
        WriteString(File0, "    ret"+#SystemEOL)
        WriteString(File0, LibName$+"_TB_DebugCheckUnicode:"+#SystemEOL)
        WriteString(File0, "    ret"+#SystemEOL)
        WriteString(File0, LibName$+"_TB_DebugCheckLabel:"+#SystemEOL)
        WriteString(File0, "    ret"+#SystemEOL)
        WriteString(File0, LibName$+"_TB_DebugFileExists:"+#SystemEOL)
        WriteString(File0, "    ret"+#SystemEOL)
        WriteString(File0, LibName$+"_TB_DebugCheckProcedure:"+#SystemEOL)
        WriteString(File0, "    ret"+#SystemEOL)
        CloseFile(File0)
        WriteString(File2, #DQUOTE$+"Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_Debugger.obj"+#DQUOTE$+#SystemEOL)
        If WriteBatch
          WriteString(File3, GetASMCompilerCommand(1)+" "+ASMCompileParams("Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_Debugger.asm", "Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_Debugger.obj",1)+#SystemEOL)
        EndIf
      EndIf
      File0=CreateFile(#PB_Any, DestFolder$+"Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_Debugger_DEBUG.asm")
      If File0
        found = 0
        If PBVersionX64
          TBDebugger$ = PeekS(?TB_Debuggerx64, ?TB_Debuggerx64End-?TB_Debuggerx64)
          TBDebugger$ = ReplaceString(TBDebugger$, "TailBiteLibrary", LibName$)
          WriteString(File0, TBDebugger$)
        Else
          WriteString(File0, "format "+#Asm_Format+#SystemEOL+#SystemEOL)
          WriteString(File0, "Public "+LibName$+"_TB_DebugError_DEBUG"+#SystemEOL+#SystemEOL)
          WriteString(File0, "Extrn _PB_DEBUGGER_SendError@4"+#SystemEOL)
          WriteString(File0, "macro sc proc,[arg]"+#SystemEOL)
          WriteString(File0, "{ reverse push dword arg"+#SystemEOL)
          WriteString(File0, "  common call proc }"+#SystemEOL+#SystemEOL)
          WriteString(File0, #Asm_TextSection+#SystemEOL)
          WriteString(File0, LibName$+"_TB_DebugError_DEBUG:"+#SystemEOL)
          WriteString(File0, "    test eax, eax"+#SystemEOL)
          WriteString(File0, "    jz .end"+#SystemEOL)
          WriteString(File0, "    sc _PB_DEBUGGER_SendError@4,eax"+#SystemEOL)
          WriteString(File0, "  .end:"+#SystemEOL)
          WriteString(File0, "    ret"+#SystemEOL)
        EndIf
        CloseFile(File0)
        WriteString(File2, #DQUOTE$+"Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_Debugger_DEBUG.obj"+#DQUOTE$+#SystemEOL)
        If WriteBatch
          WriteString(File3, GetASMCompilerCommand(1)+" "+ASMCompileParams("Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_Debugger_DEBUG.asm","Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_Debugger_DEBUG.obj",1)+#SystemEOL)
        EndIf
      EndIf
    EndIf
    If AddTB_ImagePlugin
      File0=CreateFile(#PB_Any, DestFolder$+"Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_ImagePlugin.asm")
      If File0
        If PBVersionX64
          WriteString(File0, "format "+#Asm_Formatx64+#SystemEOL+#SystemEOL)
        Else
          WriteString(File0, "format "+#Asm_Format+#SystemEOL+#SystemEOL)
        EndIf
        WriteString(File0, "Public "+LibName$+"_TB_RegisterImageEncoder"+#SystemEOL+#SystemEOL)
        WriteString(File0, "Public "+LibName$+"_TB_RegisterImageDecoder"+#SystemEOL+#SystemEOL)
        WriteString(File0, "Extrn _PB_ImageEncoder_Register@4"+#SystemEOL+#SystemEOL)
        WriteString(File0, "Extrn _PB_ImageDecoder_Register@4"+#SystemEOL+#SystemEOL)
        WriteString(File0, "macro sc proc,[arg]"+#SystemEOL)
        WriteString(File0, "{ reverse push dword arg"+#SystemEOL)
        WriteString(File0, "  common call proc }"+#SystemEOL+#SystemEOL)
        WriteString(File0, #Asm_TextSection+#SystemEOL)
        WriteString(File0, LibName$+"_TB_RegisterImageEncoder:"+#SystemEOL)
        WriteString(File0, "  fild qword [esp+4]"+#SystemEOL)
        WriteString(File0, "  fistp qword [ImageEncoder]"+#SystemEOL)
        WriteString(File0, "  sc _PB_ImageEncoder_Register@4, ImageEncoder"+#SystemEOL)
        WriteString(File0, "  mov eax, ImageEncoder"+#SystemEOL)
        WriteString(File0, "  ret 8"+#SystemEOL+#SystemEOL)
        WriteString(File0, LibName$+"_TB_RegisterImageDecoder:"+#SystemEOL)
        WriteString(File0, "  fild qword [esp+4]"+#SystemEOL)
        WriteString(File0, "  fistp qword [ImageDecoder]"+#SystemEOL)
        WriteString(File0, "  fild qword [esp+12]"+#SystemEOL)
        WriteString(File0, "  fistp qword [ImageDecoder+8]"+#SystemEOL)
        WriteString(File0, "  sc _PB_ImageDecoder_Register@4, ImageDecoder"+#SystemEOL)
        WriteString(File0, "  mov eax, ImageDecoder"+#SystemEOL)
        WriteString(File0, "  ret 16"+#SystemEOL+#SystemEOL)
        WriteString(File0, "section '.bss' readable writeable"+#SystemEOL)
        WriteString(File0, "ImageEncoder:"+#SystemEOL)
        WriteString(File0, "  .ID rd 1"+#SystemEOL)
        WriteString(File0, "  .Encode rd 1"+#SystemEOL)
        WriteString(File0, "ImageDecoder:"+#SystemEOL)
        WriteString(File0, "  .Check rd 1"+#SystemEOL)
        WriteString(File0, "  .Decode rd 1"+#SystemEOL)
        WriteString(File0, "  .GetWidth rd 1"+#SystemEOL)
        WriteString(File0, "  .GetHeight rd 1"+#SystemEOL)
        CloseFile(File0)
        WriteString(File2, #DQUOTE$+"Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_ImagePlugin.obj"+#DQUOTE$+#SystemEOL)
        If WriteBatch
          WriteString(File3, GetASMCompilerCommand(1)+" "+ASMCompileParams("Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_ImagePlugin.asm","Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_ImagePlugin.obj",1)+#SystemEOL)
        EndIf
      EndIf
    EndIf
    If File2 And IsFile(File2)
      CloseFile(File2)
    EndIf
    If File3 And IsFile(File3)
      CloseFile(File3)
    EndIf
  EndIf
  FreeMemory(*NewPBAsm)
EndProcedure


Procedure MakeIt(FirstFolder$)
  Protected File0.l,File1.l,File2.l,WriteFinalObjFilesTxt.l,cs$,Dir1.l
  
  Debug "Inc_Taibite > MakeIt()"
  WriteLog("Inc_Taibite > MakeIt()")
  
  If FirstFolder$
    If Right(FirstFolder$, 1)<>""+#DirSeparator:FirstFolder$+""+#DirSeparator:EndIf
    File0=CreateFile(#PB_Any, FirstFolder$+LibName$+"ObjFilesTemp.txt")
    If File0
      File2=CreateFile(File2, FirstFolder$+LibName$+"ObjFiles.txt")
      If File2
        WriteFinalObjFilesTxt = 1
      EndIf
      If WriteBatch
        File1=CreateFile(#PB_Any, FirstFolder$+LibName$+"build"+#SystemBatchExt)
        If File1
          WriteStringN(File1, "@echo OFF"+#SystemEOL)
          WriteLog("CreateFile "+#DQUOTE$+FirstFolder$+LibName$+"build"+#SystemBatchExt+#DQUOTE$+" successfull")
        Else
          WriteBatch = 0
          WriteLog("CreateFile "+#DQUOTE$+FirstFolder$+LibName$+"build"+#SystemBatchExt+#DQUOTE$+" failed !")
        EndIf
      EndIf
      ForEach FileList()
        If GetExtensionPart(FileList())="asm"
          CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
            cs$ = ExecuteProgram(#DQUOTE$+PBCompilerFolder$+"fasm"+#SystemExeExt+#DQUOTE$, #DQUOTE$+FileList()+#DQUOTE$+" "+#DQUOTE$+ReplaceString(FileList(), ".asm", ".obj")+#DQUOTE$, FirstFolder$, FirstFolder$)
            If FindString(cs$,FasmOk$,1)=0
              If WriteBatch
                CloseFile(File1)
              EndIf
              CloseFile(File0)
              CloseFile(File2)
              TBError("FAsm: "+GetFilePart(FileList())+NL$+NL$+cs$, 1, TBTempPath$)
              CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
            EndIf
          CompilerElse;os x
            cs$ = ExecuteProgram("nasm", "-f macho -o "+#DQUOTE$+ReplaceString(FileList(), ".asm", ".obj")+#DQUOTE$+" "+#DQUOTE$+FileList()+#DQUOTE$, FirstFolder$, FirstFolder$)
            If Len(cs$) > 0;nasm outputs nothing if compiled correctly
              If WriteBatch
                CloseFile(File1)
              EndIf
              CloseFile(File0)
              CloseFile(File2)
              TBError("nasm: "+GetFilePart(FileList())+NL$+NL$+cs$, 1, TBTempPath$)
              CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
            EndIf
          CompilerEndIf
          WriteStringN(File0, #DQUOTE$+ReplaceString(FileList(), ".asm", ".obj")+#DQUOTE$)
          If WriteBatch
            WriteString(File1, GetASMCompilerCommand(1)+" "+ASMCompileParams(FileList(),ReplaceString(FileList(), ".asm", ".obj"),1)+#SystemEOL)
          EndIf
          If WriteFinalObjFilesTxt
            WriteStringN(File2, #DQUOTE$+ReplaceString(FileList(), ".asm", ".obj")+#DQUOTE$)
          EndIf
          DeleteFile(FileList())
        EndIf
      Next
      CloseFile(File0)
      CloseFile(File2)
      If PBVersionX64
        cs$ = ExecuteProgram(#DQUOTE$+Libexe$+#DQUOTE$, "/MACHINE:X64 /out:"+#DQUOTE$+LibName$+".lib"+#DQUOTE$+" @"+#DQUOTE$+LibName$+"ObjFilesTemp.txt"+#DQUOTE$, FirstFolder$, FirstFolder$)
      Else
        cs$ = ExecuteProgram(#DQUOTE$+Libexe$+#DQUOTE$, "/out:"+#DQUOTE$+LibName$+".lib"+#DQUOTE$+" @"+#DQUOTE$+LibName$+"ObjFilesTemp.txt"+#DQUOTE$, FirstFolder$, FirstFolder$)
      EndIf
      If cs$
        If WriteBatch
          CloseFile(File1)
        EndIf
        TBError(LibexeBaseName$+":"+NL$+cs$, 1, TBTempPath$)
        CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
      EndIf
      ForEach DirList()
        Dir1=ExamineDirectory(#PB_Any, DirList(), "*.obj")
        If Dir1
          While NextDirectoryEntry(Dir1)
            DeleteFile(DirList()+DirectoryEntryName(Dir1))
          Wend
          FinishDirectory(Dir1)
        EndIf
      Next
      If WriteBatch
        If PBVersionX64
          WriteString(File1, #SystemEOL+#DQUOTE$+Libexe$+#DQUOTE$+" /MACHINE:X64 /out:"+#DQUOTE$+LibName$+".lib"+#DQUOTE$+" @"+#DQUOTE$+LibName$+"ObjFiles.txt"+#DQUOTE$+#SystemEOL)
        Else
          WriteString(File1, #SystemEOL+#DQUOTE$+Libexe$+#DQUOTE$+" /out:"+#DQUOTE$+LibName$+".lib"+#DQUOTE$+" @"+#DQUOTE$+LibName$+"ObjFiles.txt"+#DQUOTE$+#SystemEOL)
        EndIf
        ForEach DirList()
          WriteString(File1, "Del "+#DQUOTE$+RemoveString(DirList(), FirstFolder$)+"*.obj"+#DQUOTE$+#SystemEOL)
        Next
      EndIf
      If TBOutputpath$<>""
        cs$ = ExecuteProgram(#DQUOTE$+LibraryMaker$+#DQUOTE$, #DQUOTE$+FirstFolder$+LibName$+".Desc"+#DQUOTE$+" /TO "+#DQUOTE$+TBOutputpath$+#DQUOTE$+LibraryMakerOptions$, FirstFolder$, FirstFolder$)
      Else
        cs$ = ExecuteProgram(#DQUOTE$+LibraryMaker$+#DQUOTE$, #DQUOTE$+FirstFolder$+LibName$+".Desc"+#DQUOTE$+" /TO "+#DQUOTE$+PBFolder$+PBUserLibraryFolder$+#DQUOTE$+LibraryMakerOptions$, FirstFolder$, FirstFolder$)
      EndIf
      If cs$
        If WriteBatch
          CloseFile(File1)
        EndIf
        TBError("Library Maker: "+NL$+cs$, 1, TBTempPath$)
        CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
      EndIf
      If WriteBatch
        If TBOutputpath$<>""
          WriteString(File1, #DQUOTE$+LibraryMaker$+#DQUOTE$+" "+#DQUOTE$+LibName$+".Desc"+#DQUOTE$+" /TO "+#DQUOTE$+TBOutputpath$+#DQUOTE$+LibraryMakerOptions$+#SystemEOL)
        Else
          WriteString(File1, #DQUOTE$+LibraryMaker$+#DQUOTE$+" "+#DQUOTE$+LibName$+".Desc"+#DQUOTE$+" /TO "+#DQUOTE$+PBFolder$+PBUserLibraryFolder$+#DQUOTE$+LibraryMakerOptions$+#SystemEOL)
        EndIf
        WriteString(File1, "REM Del "+#DQUOTE$+LibName$+".lib"+#DQUOTE$+#SystemEOL)
        WriteString(File1, "ECHO Done"+#SystemEOL)
        CloseFile(File1)
      EndIf
      DeleteFile(FirstFolder$+LibName$+"ObjFilesTemp.txt")
    EndIf
  EndIf
EndProcedure

Procedure MainProc(*File)
  Global recover,oldlibfile$,tmplibfile$
  Protected Checkdir$,File$,Text$,Res.l,File,DestFolder$,FileOps$,Format.l,Length,olddir$,PBSourceFileSize
  Protected *PBSourceFile,FSize,CancelTB.l,DeletePrevious.l,CheckPrevious.l,NewLibName$,FileString$,cs$,Error.l
  Protected ErrMsg$,HelpExt$,ChmFile$,NewChmFile$,NewHelpDir$,LibWrapper.l,ObjFiles$
  Protected ArgScheme$,idx.l,part$,ResFile$,OverWrite.l,Cancel.l,DescFileSize.l,*DescFile,*DescFileEnd
  Protected Dir0,File0,File10,File11,File12
  Protected *DescFileSeeker,DescPart.l,ThisLine$,nl.l,i.l,*ThisSeek,ThisFunc$,FirstInclude.l,*AsmFileSeekerAnchor
  Protected AsmFileSize.l,*AsmFile,*AsmFileSeeker,*AsmFileEnd,qt.s,*NewAsmFile,*NewAsmFileSeeker,ThisInclude$
  Protected IncludeFolder$
  Protected *PBSourceFile_multilib,PBSourceFileSize_multilib,File_multilib
  Protected Tapifunction1.s,found,Tapifunction2.s,DLLIndex,AlreadyThere,ApiNotFound$,batchfile
  
  Debug "Inc_Taibite > MainProc()"
  WriteLog("Inc_Taibite > MainProc()")
  
  PBSourceFile$=PeekS(*File)
  
  If TBLibname$ <> ""
    OrigLibName$ = TBLibname$ ; force the libname /LIBN:libname
  Else
    OrigLibName$ = Left(GetFilePart(PBSourceFile$), Len(GetFilePart(PBSourceFile$))-Len(GetExtensionPart(PBSourceFile$))-1)
  EndIf
  LibName$ = ReplaceString(OrigLibName$, " ", "_")
  If Left(LibName$, 3)="PB_"
    LibName$ = "TBTemp_"+Right(LibName$, Len(LibName$)-3)
  EndIf
  ReplaceString(LibName$, "(", "_", #PB_String_InPlace)
  ReplaceString(LibName$, ")", "_", #PB_String_InPlace)
  ReplaceString(LibName$, "-", "_", #PB_String_InPlace)
  If Left(LibName$, 5)="Temp_"
    LibName$ = "TB_TempLib"
  EndIf
  WriteLog("LibName$="+LibName$)
  
  ;check for Subsystem
  
  ;workaround for Invalid name : same as an external command ABBKlaus 2.6.2007 3:36
  ;when compiling for Subsystem TailBite checks if the lib already exists in the PureLibraries\UserLibraries folder
  ;and moves it from PureLibraries\UserLibraries to the windows TEMP folder and renames it to TB_LIBNAME_12345678 (random number is added)
  recover = #False
  If UCase(PBUserLibraryFolder$)<>UCase(Userlibdir$)
    ; first check the PBUserLibraryFolder$ : SubSystems\UserLibUnicodeThreadSafe\PureLibraries\UserLibraries\
    Checkdir$=PBFolder$+StringField(PBUserLibraryFolder$,1,""+#DirSeparator)+""+#DirSeparator+StringField(PBUserLibraryFolder$,2,""+#DirSeparator)+""+#DirSeparator
    Repeat
      File$=SearchDirectory(Checkdir$,OrigLibName$)
      If File$<>""
        Text$=Language("TailBite","LibExist2")
        Text$=ReplaceString(Text$,"%libname%",File$)
        If AskDelete
          Res=MessageRequester(Language("TailBite","Error"),Text$,#PB_MessageRequester_YesNo)
          If Res=#PB_MessageRequester_Yes
            DeleteFile(File$)
          Else
            CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerElse : quit = 1 : If ThID : PauseThread(ThID) : EndIf : CompilerEndIf
          EndIf
        Else
          Debug "delete "+File$
          Res = DeleteFile(File$)
          Debug res
        EndIf
      EndIf
    Until File$=""
  EndIf;lexvictory moved 4/4/09 linux bugfix
  
  If Not MultiLib
    ;-* Backup lib from PureLibraries\UserLibraries\
    oldlibfile$=PBFolder$+Userlibdir$+LCase(OrigLibName$);linux userlibs are forced to lowercase filename (pblibrarymaker?)
    Debug oldlibfile$
    If FileSize(oldlibfile$)>0
      tmplibfile$=GetTemporaryDirectory()+"TB_"+OrigLibName$+"_"+Hex(Random(#MAXLONG))
      ;Read Helpname from userlib
      File=ReadFile(#PB_Any,oldlibfile$)
      If File
        FileSeek(File,20) ; ABBKlaus 18.12.2007 21:36
        ReadString(File)
        ReadWord(File)
        While ReadByte(File)<>$02:Wend
        HelpName$ = ReadString(File)
        CloseFile(File)
        WriteLog("HelpName$(read from old userlib)="+HelpName$)
      Else
        HelpName$ = LibName$+".chm"
      EndIf
      
      If CopyFile(oldlibfile$,tmplibfile$)
        WriteLog("CopyFile ok :"+oldlibfile$+" -> "+tmplibfile$)
      Else
        WriteLog("CopyFile failed :"+oldlibfile$+" -> "+tmplibfile$)
        CallDebugger
      EndIf
      If DeleteFile(oldlibfile$)
        WriteLog("DeleteFile ok: "+oldlibfile$)
        Debug "DeleteFile ok: "+oldlibfile$
        ;CallDebugger
      Else
        WriteLog("DeleteFile failed: "+oldlibfile$)
        Debug "DeleteFile failed: "+oldlibfile$
      EndIf
      recover=1
    EndIf
  EndIf
  
  WriteLog("recover="+Str(recover))
  
  DestFolder$ = LibSourceFolder$+LibName$+""+#DirSeparator
  TBDestFolder$ = TBTempPath$ ; TBFolder$+"TBTemp"+#DirSeparator
  If FileSize(TBDestFolder$)<>-2
    CreateDirectory(TBDestFolder$)
  Else
    DeleteDirectory(TBDestFolder$, "", #PB_FileSystem_Recursive)
    CreateDirectory(TBDestFolder$)
  EndIf
  If FileSize(PBFolder$+PBUserLibraryFolder$+LibName$)<>-1
    CopyFile(PBFolder$+PBUserLibraryFolder$+LibName$, TBDestFolder$+LibName$)
    DeleteFile(PBFolder$+PBUserLibraryFolder$+LibName$)
  EndIf
  If FileSize(PBFolder$+PBUserLibraryFolder$+OrigLibName$)<>-1
    CopyFile(PBFolder$+PBUserLibraryFolder$+OrigLibName$, TBDestFolder$+OrigLibName$)
    DeleteFile(PBFolder$+PBUserLibraryFolder$+OrigLibName$)
  EndIf
  If LCase(GetExtensionPart(PBSourceFile$))<>"desc"
    If QuietMode=0
      SetGadgetText(#Text1,ReplaceString(Language("TailBite","OpeningPB"),"%version%",PBVersion$))
    EndIf
    WriteLog(ReplaceString(Language("TailBite","OpeningPB"),"%version%",PBVersion$))
    FileOps$ = " "+#Switch_Commented
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      FileOps$ + " "+#Switch_Debugger
    CompilerEndIf
    ;added to stop pbcompiler running the exe after commented asm output lexvictory 28.1.2009 2:55
    FileOps$ + " "+#Switch_Executable+" "+#DQUOTE$+TBTempPath$+"PureBasic"+#SystemExeExt+#DQUOTE$
    File=OpenFile(#PB_Any, PBSourceFile$)
    If File
      Format=ReadStringFormat(File)
      Select Format
          Case #PB_Ascii,#PB_UTF8,#PB_Unicode
        Default
          TBError(Language("TailBite","FileFormatError"),1,TBTempPath$)
          CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
      EndSelect
      Length=Lof(File)
      If Length>(114+#MAX_PATH)
        FileSeek(File, Length-(114+#MAX_PATH))
      EndIf
      
      If PBnbVersion<520
        While Eof(File)=0
          If Left(ReadString(File,Format), 11)="; EnableAsm"
            FileOps$ + " "+#Switch_InlineASM
          EndIf
        Wend
      EndIf
      
      CloseFile(File)
    EndIf
    
    ; Write to temp folder ABBKlaus 8.6.2007 20:27
    If PBnbVersion > 402
      olddir$=GetCurrentDirectory()
      SetCurrentDirectory(TBTempPath$)
      If Not PBCompile(PBSourceFile$, "", FileOps$, 0, "", 0)
        ; fixed tempdir was not cleaned while it was in use ABBKlaus 12.1.2009 21:34
        SetCurrentDirectory(olddir$)
        DeleteDirectory(TBTempPath$, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
        Quit=1
        CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerElse : If ThID : PauseThread(ThID) : EndIf : CompilerEndIf
      EndIf
      Delay(250)
      DeleteFile(TBTempPath$+"PureBasic"+#SystemExeExt)
      SetCurrentDirectory(olddir$)
    Else
      If Not PBCompile(PBSourceFile$, "", FileOps$, 0, "", 0)
        ; fixed tempdir was not cleaned while it was in use ABBKlaus 12.1.2009 21:34
        DeleteFile(PBCompilerFolder$+"purebasic.asm")
        DeleteFile(PBCompilerFolder$+"PureBasic"+#SystemExeExt)
        DeleteDirectory(TBTempPath$, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
        Quit=1
        CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerElse : If ThID : PauseThread(ThID) : EndIf : CompilerEndIf
      EndIf
      Delay(250)
      CopyFile(PBCompilerFolder$+"purebasic.asm",TBTempPath$+"purebasic.asm")
      ;CopyFile(GetCurrentDirectory()+"PureBasic.exe",TBTempPath$+"PureBasic.exe")
      DeleteFile(PBCompilerFolder$+"purebasic.asm")
      DeleteFile(PBCompilerFolder$+"PureBasic"+#SystemExeExt)
    EndIf
    
    If FileSize(TBDestFolder$+LibName$)<>-1
      CopyFile(TBDestFolder$+LibName$, PBFolder$+PBUserLibraryFolder$+LibName$)
      DeleteFile(TBDestFolder$+LibName$)
    EndIf
    ;gnozal 24/05/2007 : TBTempPath$ for PB4 version compatibility
    File=ReadFile(#PB_Any, TBTempPath$+"purebasic.asm")
    If File
      PBSourceFileSize = Lof(File)
      *PBSourceFile = AllocateMemory(PBSourceFileSize)
      ReadData(File, *PBSourceFile, PBSourceFileSize)
      CloseFile(File)
    Else
      TBError(Language("TailBite","CannotfindPBAsm")+" "+TBTempPath$, 1, TBTempPath$)
      CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
    EndIf
    If QuietMode=0
      SetGadgetText(#Text1,Language("TailBite","CreateFuncList"))
    EndIf
    WriteLog(Language("TailBite","CreateFuncList"))
    ResidentFile = 0
    ;-* CheckPrevious
    CheckPrevious:
    If CreateFunctionList(*PBSourceFile, *PBSourceFile+PBSourceFileSize);{ parsing asm source for functions
      If TBOutputpath$<>""
        FSize=FileSize(TBOutputpath$+LibName$)
      Else
        FSize=FileSize(PBFolder$+PBUserLibraryFolder$+LibName$)
      EndIf
      If FSize<>-1
        CancelTB = 0
        DeletePrevious = 1
        If AskDelete
          Text$=Language("TailBite","LibExist")
          Text$=ReplaceString(Text$,"%libname%",LibName$)
          Res=MessageRequester("TailBite", Text$, #PB_MessageRequester_YesNoCancel)
          CheckPrevious=0
          Select Res
            Case #PB_MessageRequester_Cancel
              DeletePrevious = 0
              CancelTB = 1
            Case #PB_MessageRequester_Yes
              DeletePrevious = 1
            Case #PB_MessageRequester_No
              NewLibName$ = InputRequester("TailBite",Language("TailBite","NewName"), LibName$)
              If NewLibName$ = "" Or NewLibName$ = LibName$
                DeletePrevious = 0
                CancelTB = 1
              Else
                LibName$ = NewLibName$
                CheckPrevious=1
              EndIf
          EndSelect
          If CheckPrevious ; bugfix ABBKlaus 3.1.2008 22:48
            Goto CheckPrevious
          EndIf
        EndIf
        WriteLog("DeletePrevious="+Str(DeletePrevious))
        If DeletePrevious
          If TBOutputpath$<>""
            File=ReadFile(#PB_Any, TBOutputpath$+LibName$)
          Else
            File=ReadFile(#PB_Any, PBFolder$+PBUserLibraryFolder$+LibName$)
          EndIf
          If File
            FileSeek(File,20) ; ABBKlaus 18.12.2007 21:36
            ReadString(File)
            ReadWord(File)
            While ReadByte(File)<>$02:Wend
            HelpName$ = ReadString(File)
            CloseFile(File)
            WriteLog("HelpName$(read from old userlib)="+HelpName$)
          Else
            HelpName$ = LibName$+#SystemHelpExt
          EndIf
          If TBOutputpath$<>""
            DeleteFile(TBOutputpath$+LibName$)
          Else
            DeleteFile(PBFolder$+PBUserLibraryFolder$+LibName$)
          EndIf
        EndIf
      Else
        ; ChooseHelp
        If QuietMode=0 And recover=0 ; ABBKlaus 31.1.2008 01:04
          If SetChmName=0
            HelpName$ = InputRequester("TailBite", Language("TAILBITE","CHOOSEHELP"), LibName$+#SystemHelpExt)
            WriteLog("HelpName$(Choosehelp)="+HelpName$)
          Else
            HelpName$ = ChmName$+#SystemHelpExt
          EndIf
        EndIf
        If HelpName$=""
          If SetChmName=0
            HelpName$ = LibName$+#SystemHelpExt
          Else
            HelpName$ = ChmName$+#SystemHelpExt
          EndIf
        EndIf
      EndIf
      WriteLog("HelpName$="+HelpName$)
      If CancelTB
        Quit=1
        CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerElse : If ThID : PauseThread(ThID) : EndIf : CompilerEndIf
      EndIf
      TBDestFolder$ = TBTempPath$
      CreatePath(TBDestFolder$+"Functions"+#DirSeparator+"Shared"+#DirSeparator)
      If QuietMode=0
        SetGadgetText(#Text1, Language("TailBite","Splitting"))
      EndIf
      WriteLog(Language("TailBite","Splitting"))
      SplitFunctions(*PBSourceFile, *PBSourceFile+PBSourceFileSize, TBDestFolder$, DestFolder$, *PBSourceFile)
    
    If MultiLib
      ;- multilib UNICODE
      UseUnicodeOption=1:UseThreadOption=0
      If QuietMode=0
        SetGadgetText(#Text1, Language("TailBite","CompileUcod"))
        SetExtrastatustext()
      EndIf
      ; Write to temp folder ABBKlaus 8.6.2007 20:27
      If PBnbVersion > 402
        olddir$=GetCurrentDirectory()
        SetCurrentDirectory(TBTempPath$)
        If Not PBCompile(PBSourceFile$, "", FileOps$, 0, "", 0)
          ; fixed tempdir was not cleaned while it was in use ABBKlaus 12.1.2009 21:34
          SetCurrentDirectory(olddir$)
          DeleteDirectory(TBTempPath$, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
          Quit=1
          CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerElse : If ThID : PauseThread(ThID) : EndIf : CompilerEndIf
        EndIf
        Delay(250)
        DeleteFile(TBTempPath$+"PureBasic"+#SystemExeExt)
        SetCurrentDirectory(olddir$)
      Else
        If Not PBCompile(PBSourceFile$, "", FileOps$, 0, "", 0)
          ; fixed tempdir was not cleaned while it was in use ABBKlaus 12.1.2009 21:34
          DeleteFile(PBCompilerFolder$+"purebasic.asm")
          DeleteFile(PBCompilerFolder$+"PureBasic"+#SystemExeExt)
          DeleteDirectory(TBTempPath$, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
          Quit=1
          CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerElse : If ThID : PauseThread(ThID) : EndIf : CompilerEndIf
        EndIf
        Delay(250)
        CopyFile(PBCompilerFolder$+"purebasic.asm",TBTempPath$+"purebasic.asm")
        DeleteFile(PBCompilerFolder$+"purebasic.asm")
        DeleteFile(PBCompilerFolder$+"PureBasic"+#SystemExeExt)
      EndIf
      Debug "reading unicode purebasic.asm"
      File_multilib=ReadFile(#PB_Any, TBTempPath$+"purebasic.asm")
      If File_multilib 
        PBSourceFileSize_multilib = Lof(File_multilib)
        *PBSourceFile_multilib = AllocateMemory(PBSourceFileSize_multilib)
        ReadData(File_multilib, *PBSourceFile_multilib, PBSourceFileSize_multilib)
        CloseFile(File_multilib)
      Else
        TBError(Language("TailBite","CannotfindPBAsm")+" "+TBTempPath$, 1, TBTempPath$)
        CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerElse : If ThID : PauseThread(ThID) : EndIf : CompilerEndIf
      EndIf
      SplitFunctions(*PBSourceFile_multilib, *PBSourceFile_multilib+PBSourceFileSize_multilib, TBDestFolder$, DestFolder$, *PBSourceFile_multilib, "_UNICODE")
      ;SetGadgetText(#Text1, "Fixing Unicode ASM")
      ;MultiLibFixStaticStrings("_UNICODE")
      
      ;- multilib THREADSAFE
      UseUnicodeOption=0:UseThreadOption=1
      If QuietMode=0
        SetGadgetText(#Text1, Language("TailBite","CompileThrd"))
        SetExtrastatustext()
      EndIf
      ; Write to temp folder ABBKlaus 8.6.2007 20:27
      If PBnbVersion > 402
        olddir$=GetCurrentDirectory()
        SetCurrentDirectory(TBTempPath$)
        If Not PBCompile(PBSourceFile$, "", FileOps$, 0, "", 0)
          ; fixed tempdir was not cleaned while it was in use ABBKlaus 12.1.2009 21:34
          SetCurrentDirectory(olddir$)
          DeleteDirectory(TBTempPath$, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
          Quit=1
          CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerElse : If ThID : PauseThread(ThID) : EndIf : CompilerEndIf
        EndIf
        Delay(250)
        DeleteFile(TBTempPath$+"PureBasic"+#SystemExeExt)
        SetCurrentDirectory(olddir$)
      Else
        If Not PBCompile(PBSourceFile$, "", FileOps$, 0, "", 0)
          ; fixed tempdir was not cleaned while it was in use ABBKlaus 12.1.2009 21:34
          DeleteFile(PBCompilerFolder$+"purebasic.asm")
          DeleteFile(PBCompilerFolder$+"PureBasic"+#SystemExeExt)
          DeleteDirectory(TBTempPath$, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
          Quit=1
          CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerElse : If ThID : PauseThread(ThID) : EndIf : CompilerEndIf
        EndIf
        Delay(250)
        CopyFile(PBCompilerFolder$+"purebasic.asm",TBTempPath$+"purebasic.asm")
        DeleteFile(PBCompilerFolder$+"purebasic.asm")
        DeleteFile(PBCompilerFolder$+"PureBasic"+#SystemExeExt)
      EndIf
      Debug "reading threadsafe purebasic.asm"
      File_multilib=ReadFile(#PB_Any, TBTempPath$+"purebasic.asm")
      If File_multilib 
        PBSourceFileSize_multilib = Lof(File_multilib)
        *PBSourceFile_multilib = AllocateMemory(PBSourceFileSize_multilib)
        ReadData(File_multilib, *PBSourceFile_multilib, PBSourceFileSize_multilib)
        CloseFile(File_multilib)
      Else
        TBError(Language("TailBite","CannotfindPBAsm")+" "+TBTempPath$, 1, TBTempPath$)
        CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
      EndIf
      SplitFunctions(*PBSourceFile_multilib, *PBSourceFile_multilib+PBSourceFileSize_multilib, TBDestFolder$, DestFolder$, *PBSourceFile_multilib, "_THREAD")
      ;SetGadgetText(#Text1, "Fixing Threadsafe ASM")
      ;MultiLibFixStaticStrings("_THREAD")
      
      ;- multilib UNICODETHREADSAFE
      UseUnicodeOption=1:UseThreadOption=1
      If QuietMode=0
        SetGadgetText(#Text1, Language("TailBite","CompileThrdUcod"))
        SetExtrastatustext()
      EndIf
      ; Write to temp folder ABBKlaus 8.6.2007 20:27
      If PBnbVersion > 402
        olddir$=GetCurrentDirectory()
        SetCurrentDirectory(TBTempPath$)
        If Not PBCompile(PBSourceFile$, "", FileOps$, 0, "", 0)
          ; fixed tempdir was not cleaned while it was in use ABBKlaus 12.1.2009 21:34
          SetCurrentDirectory(olddir$)
          DeleteDirectory(TBTempPath$, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
          Quit=1
          CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerElse : If ThID : PauseThread(ThID) : EndIf : CompilerEndIf
        EndIf
        Delay(250)
        DeleteFile(TBTempPath$+"PureBasic"+#SystemExeExt)
        SetCurrentDirectory(olddir$)
      Else
        If Not PBCompile(PBSourceFile$, "", FileOps$, 0, "", 0)
          ; fixed tempdir was not cleaned while it was in use ABBKlaus 12.1.2009 21:34
          DeleteFile(PBCompilerFolder$+"purebasic.asm")
          DeleteFile(PBCompilerFolder$+"PureBasic"+#SystemExeExt)
          DeleteDirectory(TBTempPath$, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
          Quit=1
          CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerElse : If ThID : PauseThread(ThID) : EndIf : CompilerEndIf
        EndIf
        Delay(250)
        CopyFile(PBCompilerFolder$+"purebasic.asm",TBTempPath$+"purebasic.asm")
        DeleteFile(PBCompilerFolder$+"purebasic.asm")
        DeleteFile(PBCompilerFolder$+"PureBasic"+#SystemExeExt)
      EndIf
      Debug "reading unicodethreadsafe purebasic.asm"
      File_multilib=ReadFile(#PB_Any, TBTempPath$+"purebasic.asm")
      If File_multilib 
        PBSourceFileSize_multilib = Lof(File_multilib)
        *PBSourceFile_multilib = AllocateMemory(PBSourceFileSize_multilib)
        ReadData(File_multilib, *PBSourceFile_multilib, PBSourceFileSize_multilib)
        CloseFile(File_multilib)
      Else
        TBError(Language("TailBite","CannotfindPBAsm")+" "+TBTempPath$, 1, TBTempPath$)
        CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
      EndIf
      SplitFunctions(*PBSourceFile_multilib, *PBSourceFile_multilib+PBSourceFileSize_multilib, TBDestFolder$, DestFolder$, *PBSourceFile_multilib, "_THREAD_UNICODE")
      ;SetGadgetText(#Text1, "Fixing UnicodeThreadsafe ASM")
      ;MultiLibFixStaticStrings("_THREAD_UNICODE")
    EndIf
      
      ;-make desc
      File0=CreateFile(#PB_Any, TBDestFolder$+LibName$+".Desc")
      If File0;{ Create *.desc file
        WriteString(File0, "ASM"+#SystemEOL+";"+#SystemEOL)
        If ListSize(ApiFunction())
          If QuietMode=0
            SetGadgetText(#Text1,Language("TailBite","BuildAPIList"))
          EndIf
          WriteLog(Language("TailBite","BuildAPIList"))
          BuildApiList()
          ForEach ApiFunction()
            ;bugfix 9.12.2008 13:54 ABBKlaus (Mistrel)
            Tapifunction1 = ApiFunction()
            If FindString(Tapifunction1,"@",1)
              Tapifunction1 = StringField(Tapifunction1,1,"@")
            EndIf
            ; load API-List from Linkedlist
            Found=0
            ForEach ApilistAPI()
              Tapifunction2 = StringField(ApilistAPI(),1," ")
              If FindString(Tapifunction2,"@",1)
                Tapifunction2 = StringField(Tapifunction2,1,"@")
              EndIf
              If Tapifunction1 = Tapifunction2
                DLLIndex=Val(StringField(ApilistAPI(),3," "))
                ;Debug DLLIndex
                If ListSize(ApilistDLL())>(DLLIndex+1)
                  SelectElement(ApilistDLL(),DLLIndex)
                  ForEach DLLList()
                    If ApilistDLL()=DLLList()
                      AlreadyThere = 1
                    EndIf
                  Next
                  If AlreadyThere=0
                    AddElement(DLLList())
                    DLLList() = ApilistDLL()
                  EndIf
                  Found=1
                  ;Debug DLLList()
                  ;Debug ApilistAPI()
                  Break
                EndIf
              EndIf
            Next
            If Found=0
              ApiNotFound$+ApiFunction()+#SystemEOL
            EndIf
          Next
          ClearList(ApiFunction())
          If Len(ApiNotFound$)>0
            ForEach ImportFunction()
              If FindString(ApiNotFound$, ImportFunction()\Name$+#SystemEOL, 1)
                ApiNotFound$ = RemoveString(ApiNotFound$, ImportFunction()\Name$+#SystemEOL)
              EndIf
            Next
            If Len(ApiNotFound$)>0
              MessageRequester(Language("TailBite","Warning"),Language("TailBite","UnknownFunction")+NL$+ApiNotFound$)
            EndIf
          EndIf
        EndIf
        WriteString(File0, Str(ListSize(DLLList()))+#SystemEOL)
        ForEach DLLList()
          WriteString(File0, RemoveString(DLLList(), ".DLL", 1)+#SystemEOL)
        Next
        ClearList(DLLList())
        WriteString(File0, ";"+#SystemEOL+"LIB"+#SystemEOL+";"+#SystemEOL+Str(ListSize(PBLib()))+#SystemEOL)
        ForEach PBLib()
          WriteString(File0, PBLib()+#SystemEOL)
        Next
        ClearList(PBLib())
        WriteString(File0, ";"+#SystemEOL+HelpName$+#SystemEOL+";"+#SystemEOL)
        ForEach function()
          If function()\DLLFunction And function()\Main
            ;Debug function()\Name$+function()\Args$+" "+function()\HelpLine$
            WriteString(File0, function()\Name$+function()\Args$+" "+function()\HelpLine$+#SystemEOL)
            If MultiLib
              WriteString(File0, function()\RetValue$+" | StdCall | UNICODE | THREAD"+function()\Modifiers$+#SystemEOL+";"+#SystemEOL)
            Else
              WriteString(File0, function()\RetValue$+" | StdCall"+function()\Modifiers$+#SystemEOL+";"+#SystemEOL)
            EndIf
          EndIf
        Next
        CloseFile(File0)
    
        ; write contents of the *.desc file into the logfile
        WriteLog("==============="+DestFolder$+LibName$+".Desc===============")
        File0=ReadFile(#PB_Any,DestFolder$+LibName$+".Desc")
        If File0
          While Eof(File0)=0
            WriteLog(ReadString(File0))
          Wend
          CloseFile(File0)
        EndIf
        WriteLog("==============="+RSet("",Len(DestFolder$+LibName$+".Desc"),"=")+"===============")
        ;}
      EndIf
      
      ;- finish off batch file
      If WriteBatch
        Debug "finishing batch file"
        batchfile=OpenFile(#PB_Any, TBDestFolder$+LibName$+"build"+#SystemBatchExt)
        If Not IsFile(batchfile)
          TBError("Could not reopen batch file", 1, TBTempPath$)
        EndIf 
        ;Debug  DestFolder$+LibName$+"build"+#SystemBatchExt
       ; Debug Lof(batchfile)
        FileSeek(batchfile, Lof(batchfile))
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          If PBVersionX64
            WriteString(batchfile, #SystemEOL+#DQUOTE$+Libexe$+#DQUOTE$+" /MACHINE:X64 /out:"+#DQUOTE$+LibName$+".lib"+#DQUOTE$+" @"+#DQUOTE$+LibName$+"ObjFiles.txt"+#DQUOTE$+#SystemEOL)
          Else
            WriteString(batchfile, #SystemEOL+#DQUOTE$+Libexe$+#DQUOTE$+" /out:"+#DQUOTE$+LibName$+".lib"+#DQUOTE$+" @"+#DQUOTE$+LibName$+"ObjFiles.txt"+#DQUOTE$+#SystemEOL)
          EndIf
          WriteString(batchfile, "Del "+#DQUOTE$+"Functions\*.obj"+#DQUOTE$+#SystemEOL)
          WriteString(batchfile, "Del "+#DQUOTE$+"Functions"+#DirSeparator+"Shared"+#DirSeparator+"*.obj"+#DQUOTE$+#SystemEOL)
        CompilerElse
          WriteString(batchfile, "ar rvs "+LibName$+".a Functions/*.obj Functions/Shared/*.obj"+#SystemEOL)
          WriteString(batchfile, "rm "+"Functions/*.obj"+#SystemEOL)
          WriteString(batchfile, "rm "+"Functions"+#DirSeparator+"Shared"+#DirSeparator+"*.obj"+#SystemEOL)
        CompilerEndIf
        If TBOutputpath$<>""
          WriteString(batchfile, #DQUOTE$+LibraryMaker$+#DQUOTE$+" "+#DQUOTE$+LibName$+".Desc"+#DQUOTE$+" /TO "+#DQUOTE$+TBOutputpath$+#DQUOTE$+LibraryMakerOptions$+#SystemEOL)
        Else
          WriteString(batchfile, #DQUOTE$+LibraryMaker$+#DQUOTE$+" "+#DQUOTE$+LibName$+".Desc"+#DQUOTE$+" /TO "+#DQUOTE$+PBFolder$+PBUserLibraryFolder$+#DQUOTE$+LibraryMakerOptions$+#SystemEOL)
        EndIf
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          WriteString(batchfile, "REM Del "+#DQUOTE$+LibName$+".lib"+#DQUOTE$+#SystemEOL)
        CompilerElse
          WriteString(batchfile, "# rm "+#DQUOTE$+LibName$+".a"+#DQUOTE$+#SystemEOL)
        CompilerEndIf
        WriteString(batchfile, "echo Done"+#SystemEOL)
        CloseFile(batchfile)
        CompilerIf #PB_Compiler_OS = #PB_OS_Linux
          RunProgram("chmod", "755 "+#DQUOTE$+TBDestFolder$+LibName$+"build"+#SystemBatchExt+#DQUOTE$, "", #PB_Program_Wait|#PB_Program_Hide)
        CompilerEndIf
      EndIf
      
      
    MakeLibrary:
      ;-ImportLib -> ObjFiles.txt
      File0=OpenFile(#PB_Any, TBDestFolder$+LibName$+"ObjFiles.txt")
      If File0
        Error=0
        ErrMsg$=""
        FileSeek(File0,Lof(File0))
        ForEach ImportLib()
          WriteLog("- Importlib index "+Str(ListIndex(ImportLib())))
          WriteLog("ImportLib()\Name$="+ImportLib()\Name$)
          WriteLog("ImportLib()\FullPath$="+ImportLib()\FullPath$)
          WriteLog("ImportLib()\Type$="+ImportLib()\Type$)
          WriteLog("ImportLib()\nFunctions="+Str(ImportLib()\nFunctions))
          WriteLog("ImportLib()\nocompile="+Str(ImportLib()\nocompile))
          If ImportLib()\nocompile=0
            If CopyFile(ImportLib()\FullPath$, TBDestFolder$+"Functions\TB_Imported_Lib_"+Str(ListIndex(ImportLib()))+".lib")
              WriteString(File0,#DQUOTE$+"Functions\TB_Imported_Lib_"+Str(ListIndex(ImportLib()))+".lib"+#DQUOTE$+#SystemEOL)
              WriteLog("CopyFile("+ImportLib()\FullPath$+","+TBDestFolder$+"Functions\TB_Imported_Lib_"+Str(ListIndex(ImportLib()))+".lib)")
            Else
              Error+1
              ErrMsg$+ImportLib()\Name$+" -> "+ImportLib()\FullPath$+#CR$
              WriteLog("CopyFile failed : "+ImportLib()\FullPath$+" -> "+TBDestFolder$+"Functions\TB_Imported_Lib_"+Str(ListIndex(ImportLib()))+".lib)")
            EndIf
          EndIf
        Next
        CloseFile(File0)
        If Error
          TBError(ErrMsg$+#CR$, 1, TBTempPath$)
          CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
        EndIf
      EndIf
     
      
      If DontMakeLib=0
        If QuietMode=0
          SetGadgetText(#Text1, Language("TailBite","CompilingAsm"))
        EndIf
        WriteLog(Language("TailBite","CompilingAsm"))
        ;MeasureIntervalStart()
        CompilerIf Defined(TB_Enable_Progress, #PB_Constant)
        CompilerIf #TB_Enable_Progress = 1
          ProgressBarSetIndeterminate(#progress, 0)
          ProgressBarSetPercent(#progress, 0)
        CompilerEndIf
        CompilerEndIf
        ForEach function()
          If function()\DLLFunction
            FileString$ = function()\Name$+".asm"
          Else
            FileString$ = "Shared"+#DirSeparator+RemoveString(function()\Name$, LibName$+"_")+".asm"
          EndIf
          cs$ = CompileAsm("Functions"+#DirSeparator+FileString$, "Functions"+#DirSeparator+ReplaceString(FileString$, ".asm", ".obj"))
          HandleASMCompileFailure(cs$, FileString$)
          If MultiLib
            If function()\DLLFunction
              If function()\Debugfunction
                FileString$ = RemoveString(function()\Name$,"_DEBUG")+"_UNICODE_DEBUG.asm"
              Else
                FileString$ = function()\Name$+"_UNICODE.asm"
              EndIf
            Else
              FileString$ = "Shared"+#DirSeparator+RemoveString(function()\Name$, LibName$+"_")+"_UNICODE.asm"
            EndIf
            cs$ = CompileAsm("Functions"+#DirSeparator+FileString$,"Functions"+#DirSeparator+ReplaceString(FileString$, ".asm", ".obj"))
            HandleASMCompileFailure(cs$, FileString$)
            If function()\DLLFunction
              If function()\Debugfunction
                FileString$ = RemoveString(function()\Name$,"_DEBUG")+"_THREAD_DEBUG.asm"
              Else
                FileString$ = function()\Name$+"_THREAD.asm"
              EndIf
            Else
              FileString$ = "Shared"+#DirSeparator+RemoveString(function()\Name$, LibName$+"_")+"_THREAD.asm"
            EndIf
            cs$ = CompileAsm("Functions"+#DirSeparator+FileString$,"Functions"+#DirSeparator+ReplaceString(FileString$, ".asm", ".obj"))
            HandleASMCompileFailure(cs$, FileString$)
            If function()\DLLFunction
              If function()\Debugfunction
                FileString$ = RemoveString(function()\Name$,"_DEBUG")+"_THREAD_UNICODE_DEBUG.asm"
              Else
                FileString$ = function()\Name$+"_THREAD_UNICODE.asm"
              EndIf
            Else
              FileString$ = "Shared"+#DirSeparator+RemoveString(function()\Name$, LibName$+"_")+"_THREAD_UNICODE.asm"
            EndIf
            cs$ = CompileAsm("Functions"+#DirSeparator+FileString$,"Functions"+#DirSeparator+ReplaceString(FileString$, ".asm", ".obj"))
            HandleASMCompileFailure(cs$, FileString$)
          EndIf
          CompilerIf Defined(TB_Enable_Progress, #PB_Constant)
          CompilerIf #TB_Enable_Progress = 1
            Protected percent.f = ListIndex(function())/ListSize(function())*100
            ProgressBarSetPercent(#progress, percent)
          CompilerEndIf
          CompilerEndIf
        Next
        ClearList(function())
        If FileSize(TBDestFolder$+"Functions"+#DirSeparator+LibName$+"Shared.asm")
          cs$ = CompileAsm("Functions"+#DirSeparator+LibName$+"Shared.asm","Functions"+#DirSeparator+LibName$+"Shared.obj")
          HandleASMCompileFailure(cs$, LibName$+"Shared.asm")
        EndIf
        If MultiLib
          If FileSize(TBDestFolder$+"Functions"+#DirSeparator+LibName$+"Shared_UNICODE.asm")
            cs$ = CompileAsm("Functions"+#DirSeparator+LibName$+"Shared_UNICODE.asm","Functions"+#DirSeparator+LibName$+"Shared_UNICODE.obj")
            HandleASMCompileFailure(cs$, LibName$+"Shared_UNICODE.asm")
          EndIf
          If FileSize(TBDestFolder$+"Functions"+#DirSeparator+LibName$+"Shared_THREAD.asm")
            cs$ = CompileAsm("Functions"+#DirSeparator+LibName$+"Shared_THREAD.asm","Functions"+#DirSeparator+LibName$+"Shared_THREAD.obj")
            HandleASMCompileFailure(cs$, LibName$+"Shared_THREAD.asm")
          EndIf
          If FileSize(TBDestFolder$+"Functions"+#DirSeparator+LibName$+"Shared_THREAD_UNICODE.asm")
            cs$ = CompileAsm("Functions"+#DirSeparator+LibName$+"Shared_THREAD_UNICODE.asm","Functions"+#DirSeparator+LibName$+"Shared_THREAD_UNICODE.obj")
            HandleASMCompileFailure(cs$, LibName$+"Shared_THREAD_UNICODE.asm")
          EndIf
        EndIf
        If EndInclude
          cs$ = CompileAsm("Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_End.asm","Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_End.obj")
          HandleASMCompileFailure(cs$, "Shared"+#DirSeparator+LibName$+"_End.asm")
          If MultiLib
            cs$ = CompileAsm("Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_End_UNICODE.asm","Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_End_UNICODE.obj")
            HandleASMCompileFailure(cs$, LibName$+"_End_UNICODE.asm")
            cs$ = CompileAsm("Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_End_THREAD.asm","Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_End_THREAD.obj")
            HandleASMCompileFailure(cs$, LibName$+"_End_THREAD.asm")
            cs$ = CompileAsm("Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_End_THREAD_UNICODE.asm","Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_End_THREAD_UNICODE.obj")
            HandleASMCompileFailure(cs$, LibName$+"_End_THREAD_UNICODE.asm")
          EndIf
        EndIf
        CompilerIf Defined(FasmStandby, #PB_Procedure);for when tb is compiled in x64 mode
          If fasmHandle And ProgramRunning(fasmHandle)
            WriteProgramStringN(fasmHandle, "end")
          EndIf 
        CompilerEndIf
        ;debug MeasureIntervalStop()
        ;If AddTB_GadgetExtension
          ;cs$ = ExecuteProgram(GetASMCompilerCommand(0), ASMCompileParams("Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_GadgetExtension.asm","Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_GadgetExtension.obj",0), TBDestFolder$, TBDestFolder$)
          ;HandleASMCompileFailure(cs$, LibName$+"_TB_GadgetExtension.asm")
        ;EndIf
        ;If AddTB_Debugger
          ;cs$ = ExecuteProgram(GetASMCompilerCommand(0), ASMCompileParams("Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_Debugger.asm","Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_Debugger.obj",0), TBDestFolder$, TBDestFolder$)
          ;HandleASMCompileFailure(cs$, LibName$+"_TB_Debugger.asm")
          ;cs$ = ExecuteProgram(GetASMCompilerCommand(0), ASMCompileParams("Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_Debugger_DEBUG.asm","Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_Debugger_DEBUG.obj",0), TBDestFolder$, TBDestFolder$)
          ;HandleASMCompileFailure(cs$, LibName$+"_TB_Debugger_DEBUG.asm")
        ;EndIf
        ;If AddTB_ImagePlugin
          ;cs$ = ExecuteProgram(GetASMCompilerCommand(0), ASMCompileParams("Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_ImagePlugin.asm","Functions"+#DirSeparator+"Shared"+#DirSeparator+LibName$+"_TB_ImagePlugin.obj",0), TBDestFolder$, TBDestFolder$)
          ;HandleASMCompileFailure(cs$, LibName$+"_TB_ImagePlugin.asm")
        ;EndIf
        If QuietMode=0
          SetGadgetText(#Text1, Language("TailBite","CompilingLib"))
        EndIf
        WriteLog(Language("TailBite","CompilingLib"))
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          If PBVersionX64
            cs$ = ExecuteProgram(#DQUOTE$+Libexe$+#DQUOTE$, "/MACHINE:X64 /out:"+LibName$+".lib @"+LibName$+"ObjFiles.txt", TBDestFolder$, TBDestFolder$)
          Else
            cs$ = ExecuteProgram(#DQUOTE$+Libexe$+#DQUOTE$, "/out:"+LibName$+".lib @"+LibName$+"ObjFiles.txt", TBDestFolder$, TBDestFolder$)
          EndIf
          ;only a warning of polib won´t quit tailbite ABBKlaus 20.5.2007 01:33
          ;POLIB: warning: '__NULL_IMPORT_DESCRIPTOR' already defined in
          If FindString(cs$,"POLIB: warning: ",1)
            WriteLog("Skipping -> POLIB: warning: '__NULL_IMPORT_DESCRIPTOR' already defined in")
          Else
            If cs$
              TBError(Libexe$+Chr(13)+LibexeBaseName$+":"+NL$+cs$, 1, TBTempPath$)
              CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
            EndIf
          EndIf
        CompilerElse;NOTE: no error checking is possible like this (that I know of) The only way to do it with ExecuteProgram is to do ExamineDirectory and add all the filenames manually...
          ;perhaps I will get around to doing the examinedirectory method one day...
          olddir$ = GetCurrentDirectory()
          SetCurrentDirectory(TBDestFolder$)
          system_("ar rvs "+LibName$+".a Functions/*.obj Functions/Shared/*.obj")
          SetCurrentDirectory(olddir$)
        CompilerEndIf
        
        If QuietMode=0
          SetGadgetText(#Text1, Language("TailBite","MakingLib"))
        EndIf
        WriteLog(Language("TailBite","MakingLib"))
        Dir0=ExamineDirectory(#PB_Any, TBDestFolder$+"Functions"+#DirSeparator, "*.obj")
        If Dir0
          While NextDirectoryEntry(Dir0)
            If FileSize(TBDestFolder$+"Functions"+#DirSeparator+DirectoryEntryName(Dir0))>0
              DeleteFile(TBDestFolder$+"Functions"+#DirSeparator+DirectoryEntryName(Dir0))
            EndIf
          Wend
          FinishDirectory(Dir0)
        EndIf
        Dir0=ExamineDirectory(#PB_Any, TBDestFolder$+"Functions"+#DirSeparator+"Shared"+#DirSeparator, "*.obj")
        If Dir0
          While NextDirectoryEntry(Dir0)
            If FileSize(TBDestFolder$+"Functions"+#DirSeparator+"Shared"+#DirSeparator+DirectoryEntryName(Dir0))>0
              DeleteFile(TBDestFolder$+"Functions"+#DirSeparator+"Shared"+#DirSeparator+DirectoryEntryName(Dir0))
            EndIf
          Wend
          FinishDirectory(Dir0)
        EndIf
        If TBOutputpath$<>""
          ;-parameter change has been added, as OS X mandates that the .Desc parameter is at the end; linux/Windows don't seem to care
          cs$ = ExecuteProgram(#DQUOTE$+LibraryMaker$+#DQUOTE$, "/TO "+#DQUOTE$+TBOutputpath$+#DQUOTE$+LibraryMakerOptions$+" "+#DQUOTE$+TBDestFolder$+LibName$+".Desc"+#DQUOTE$, TBDestFolder$, TBDestFolder$)
        Else
          ;-parameter change has been added, as OS X mandates that the .Desc parameter is at the end; linux/Windows don't seem to care
          cs$ = ExecuteProgram(#DQUOTE$+LibraryMaker$+#DQUOTE$, " /TO "+#DQUOTE$+PBFolder$+PBUserLibraryFolder$+#DQUOTE$+LibraryMakerOptions$+" "+#DQUOTE$+TBDestFolder$+LibName$+".Desc"+#DQUOTE$, TBDestFolder$, TBDestFolder$)
        EndIf
        ;messagerequester("libmaker", #DQUOTE$+TBDestFolder$+LibName$+".Desc"+#DQUOTE$+" /TO "+#DQUOTE$+PBFolder$+PBUserLibraryFolder$+#DQUOTE$+LibraryMakerOptions$)
        If cs$
          TBError("Library Maker:"+NL$+cs$, 1, TBTempPath$)
          CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
        EndIf
        recover = 0;needed because on OSX renameFile seems to overwrite file if it already exists!!
        GetFileList(TBDestFolder$, 0, "")
        HelpExt$ = LCase(GetExtensionPart(HelpName$))
        If HelpName$ And HelpExt$<>"chm"
          If FileSize(PBFolder$+"Help"+#DirSeparator+HelpName$)<>-2
            CreateDirectory(PBFolder$+"Help"+#DirSeparator+HelpName$)
          EndIf
        EndIf
        ForEach FileList()
          If HelpExt$="chm"
            If LCase(GetExtensionPart(FileList()))="hhp"
              HelpCompile(FileList())
              ChmFile$ = Left(FileList(), Len(FileList())-4)+".chm"
              If FileSize(ChmFile$)<>-1
                If HelpName$=""
                  If SetChmName=0
                    NewChmFile$ = PBFolder$+"Help"+#DirSeparator+LibName$+".chm"
                  Else
                    NewChmFile$ = PBFolder$+"Help"+#DirSeparator+ChmName$+".chm"
                  EndIf
                Else
                  NewChmFile$ = PBFolder$+"Help"+#DirSeparator+HelpName$
                EndIf
                If FileSize(NewChmFile$)<>-1
                  DeleteFile(NewChmFile$)
                EndIf
                CopyFile(ChmFile$, NewChmFile$)
              EndIf
              Break
            EndIf
          Else
            If HelpName$
              NewHelpDir$ = PBFolder$+"Help"+#DirSeparator+HelpName$+#DirSeparator
            Else
              NewHelpDir$ = PBFolder$+"Help"+#DirSeparator+LibName$+#DirSeparator
            EndIf
            CopyFile(FileList(), NewHelpDir$+GetFilePart(FileList()))
          EndIf
        Next
      EndIf
    CopySrcFiles:
      If KeepSrcFiles
        WriteLog("KeepSrcFiles")
        If QuietMode=0
          SetGadgetText(#Text1, Language("TailBite","CopySourceFiles"))
        EndIf
        If FileSize(LibSourceFolder$)<>-2
          If CreateDirectory(LibSourceFolder$)
            WriteLog("CreateDirectory "+#DQUOTE$+LibSourceFolder$+#DQUOTE$+" successfull")
          Else
            WriteLog("CreateDirectory "+#DQUOTE$+LibSourceFolder$+#DQUOTE$+" failed !")
          EndIf
        EndIf
        If FileSize(DestFolder$)=-2
          DeleteDirectory(DestFolder$, "", #PB_FileSystem_Recursive)
          Delay(100)
        EndIf
        If CopyDirectory(TBDestFolder$, DestFolder$, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
          WriteLog("CopyDirectory "+#DQUOTE$+TBDestFolder$+#DQUOTE$+" "+#DQUOTE$+DestFolder$+#DQUOTE$+" successfull")
        Else
          WriteLog("CopyDirectory "+#DQUOTE$+TBDestFolder$+#DQUOTE$+" "+#DQUOTE$+DestFolder$+#DQUOTE$+" failed !")
        EndIf
        ;Rename purebasic.asm to LibName.asm ABBKlaus 8.1.2007 20:33
        If FileSize(DestFolder$+"purebasic.asm")<>-1
          RenameFile(DestFolder$+"purebasic.asm",DestFolder$+LibName$+".asm")
        EndIf
        ; Copy logfile into source directory
        WriteLog("",#True)
        CopyFile(TailBiteLogFile, DestFolder$+GetFilePart(TailBiteLogFile))
      EndIf
      DeleteDirectory(TBDestFolder$, "", #PB_FileSystem_Recursive)
    ;}
    Else ; no functions found
      If ListSize(ImportFunction())>0;{ Wrapping static lib to PB lib...
        LibWrapper = 1
        SetGadgetText(#Text1, Language("TailBite","Wrapping"))
        WriteLog(Language("TailBite","Wrapping"))
        TBDestFolder$ = TBTempPath$;TBFolder$+"TBTemp"+#DirSeparator
        If FileSize(TBDestFolder$)=-2
          DeleteDirectory(TBDestFolder$, "", #PB_FileSystem_Recursive)
        EndIf
        CreateDirectory(TBDestFolder$)
        CreateDirectory(TBDestFolder$+"Functions"+#DirSeparator)
        ObjFiles$ = ""
        ForEach ImportLib()
          If ImportLib()\nocompile=0
            CopyFile(ImportLib()\FullPath$, TBDestFolder$+"Functions"+#DirSeparator+"TB_Imported_Lib_"+Str(ListIndex(ImportLib()))+".lib")
            ObjFiles$+#DQUOTE$+"Functions\TB_Imported_Lib_"+Str(ListIndex(ImportLib()))+".lib"+#DQUOTE$+#SystemEOL
          EndIf
        Next
        File12=OpenFile(#PB_Any, TBDestFolder$+LibName$+".Desc")
        If File12
          WriteString(File12, "ASM"+#SystemEOL)
          WriteString(File12, ";"+#SystemEOL)
          WriteString(File12, "0"+#SystemEOL)
          WriteString(File12, ";"+#SystemEOL)
          WriteString(File12, "LIB"+#SystemEOL)
          WriteString(File12, ";"+#SystemEOL)
          WriteString(File12, "0"+#SystemEOL)
          WriteString(File12, ";"+#SystemEOL)
          ;WriteString(File12, LibName$+".chm"+#SystemEOL)
          WriteString(File12, HelpName$+".chm"+#SystemEOL);-* Helpname$
          WriteString(File12, ";"+#SystemEOL)
          ForEach ImportFunction()
            WriteLog("- ImportFunction Index "+Str(ListIndex(ImportFunction())))
            WriteLog("ImportFunction()\Name$="+ImportFunction()\Name$)
            WriteLog("ImportFunction()\NewName$="+ImportFunction()\NewName$)
            WriteLog("ImportFunction()\LibPath$="+ImportFunction()\LibPath$)
            WriteLog("ImportFunction()\RetValue$="+ImportFunction()\RetValue$)
            WriteLog("ImportFunction()\HelpLine$="+ImportFunction()\HelpLine$)
            WriteLog("ImportFunction()\Args$="+ImportFunction()\Args$)
            WriteLog("ImportFunction()\Type$="+ImportFunction()\Type$)
            FileString$ = TBDestFolder$+"Functions"+#DirSeparator+ImportFunction()\NewName$+".asm"
            File10=OpenFile(#PB_Any, FileString$)
            If File10
              If PBVersionX64
                WriteString(File10, "format MS64 COFF"+#SystemEOL+#SystemEOL)
              Else
                WriteString(File10, "format MS COFF"+#SystemEOL+#SystemEOL)
              EndIf
              WriteString(File10, "Public PB_"+ImportFunction()\NewName$+#SystemEOL+#SystemEOL)
              WriteString(File10, "extrn "+ImportFunction()\Name$+#SystemEOL+#SystemEOL)
              WriteString(File10, "PB_"+ImportFunction()\NewName$+":"+#SystemEOL)
              WriteString(File10, "  JMP "+ImportFunction()\Name$+#SystemEOL)
              CloseFile(File10)
              cs$ = ExecuteProgram(#DQUOTE$+PBCompilerFolder$+"fasm"+#SystemExeExt+#DQUOTE$, #DQUOTE$+FileString$+#DQUOTE$+" "+#DQUOTE$+ReplaceString(FileString$, ".asm", ".obj")+#DQUOTE$, TBDestFolder$, TBDestFolder$)
              If FindString(cs$,FasmOk$,1)=0
                TBError("FAsm: "+ImportFunction()\NewName$+".asm"+NL$+NL$+cs$, 1, TBTempPath$)
                CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
              EndIf
              ObjFiles$+#DQUOTE$+"Functions"+#DirSeparator+ImportFunction()\NewName$+".obj"+#DQUOTE$+#SystemEOL
              ArgScheme$ = Trim(RemoveString(ImportFunction()\Args$, "("))
              ArgScheme$ = Trim(RemoveString(ArgScheme$, ")"))
              ClearList(Arg())
              idx = 1
              part$ = Trim(StringField(ArgScheme$, idx, ",")) ;bugfix: changed 1 witdh idx ABBKlaus 19.5.2007 12:56
              While part$
                If FindString(part$, "=", 1)
                  part$ = StringField(part$, 1, "=")
                EndIf
                AddElement(Arg())
                Select StringField(part$, 2, ".")
                  Case ".b":
                    Arg() = "Byte"
                  Case ".w":
                    Arg() = "Word"
                  Case ".l":
                    Arg() = "Long"
                  Case ".f":
                    Arg() = "Float"
                  ;Case ".i":
                  ;  Arg() = "Integer"
                  Case ".d":
                    Arg() = "Double"
                  Case ".q":
                    Arg() = "Quad"
                  Case ".s":
                    Arg() = "String"
                  Default
                    ;If PBnbVersion>=430
                    ;  Arg() = "Integer"
                    ;Else
                      Arg() = "Long"
                    ;EndIf
                EndSelect
                idx + 1 ;bugfix: idx+1 added ABBKlaus 19.5.2007 12:56
                part$ = Trim(StringField(ArgScheme$, idx, ",")) ;bugfix: changed 1 witdh idx ABBKlaus 19.5.2007 12:56
              Wend
              ArgScheme$ = ", "
              ForEach Arg()
                ArgScheme$+Arg()+", "
              Next
              WriteString(File12, ImportFunction()\NewName$+ArgScheme$+"() - "+ImportFunction()\HelpLine$+#SystemEOL)
              WriteString(File12, ImportFunction()\RetValue$+" | "+ImportFunction()\Type$+#SystemEOL)
              WriteString(File12, ";"+#SystemEOL)
            Else
              TBError(Language("TailBite","Warning2")+NL$+FileString$, 0, "")
            EndIf
          Next
          CloseFile(File12)
        EndIf
        If Len(ObjFiles$)>0
          File11=OpenFile(#PB_Any, TBDestFolder$+LibName$+"ObjFiles.txt")
          If File11
            WriteString(File11, ObjFiles$)
            CloseFile(File11)
            If PBVersionX64
              cs$ = ExecuteProgram(#DQUOTE$+Libexe$+#DQUOTE$, "/MACHINE:X64 /out:"+LibName$+".lib @"+LibName$+"ObjFiles.txt", TBDestFolder$, TBDestFolder$)
            Else
              cs$ = ExecuteProgram(#DQUOTE$+Libexe$+#DQUOTE$, "/out:"+LibName$+".lib @"+LibName$+"ObjFiles.txt", TBDestFolder$, TBDestFolder$)
            EndIf
            If cs$
              TBError(LibexeBaseName$+":"+NL$+cs$, 1, TBTempPath$)
              CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
            EndIf
            If TBOutputpath$<>""
              cs$ = ExecuteProgram(#DQUOTE$+LibraryMaker$+#DQUOTE$, #DQUOTE$+TBDestFolder$+LibName$+".Desc"+#DQUOTE$+" /TO "+#DQUOTE$+TBOutputpath$+#DQUOTE$+LibraryMakerOptions$, TBDestFolder$, TBDestFolder$) 
            Else
              cs$ = ExecuteProgram(#DQUOTE$+LibraryMaker$+#DQUOTE$, #DQUOTE$+TBDestFolder$+LibName$+".Desc"+#DQUOTE$+" /TO "+#DQUOTE$+PBFolder$+PBUserLibraryFolder$+#DQUOTE$+LibraryMakerOptions$, TBDestFolder$, TBDestFolder$)
            EndIf
            If cs$
              TBError("Library Maker:"+NL$+cs$, 1, TBTempPath$)
              CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
            EndIf
          EndIf
        EndIf
      ;}
      Else;{ Build *.res file
        ResidentFile = 1
        SetGadgetText(#Text1, Language("TailBite","CreateRes"))
        ResFile$ = PBFolder$+"Residents"+#DirSeparator+Left(GetFilePart(PBSourceFile$), Len(GetFilePart(PBSourceFile$))-3)+".res"
        OverWrite = 1
        Cancel = 0
        If FileSize(ResFile$)<>-1
          If AskDelete
            Select MessageRequester("TailBite", ResFile$+" "+Language("TailBite","ResExist"), #PB_MessageRequester_YesNoCancel)
              Case #PB_MessageRequester_Yes
                OverWrite = 1
              Case #PB_MessageRequester_No
                OverWrite = 0
              Case #PB_MessageRequester_Cancel
                OverWrite = 0
                Cancel = 1
            EndSelect
          Else
            CopyFile(ResFile$, TBDestFolder$+GetFilePart(ResFile$))
            DeleteFile(ResFile$)
          EndIf
        EndIf
        If Cancel=0 And OverWrite
          PBCompile("", "", " "+#Switch_Resident+" "+#DQUOTE$+PBFolder$+"residents"+#DirSeparator+Left(GetFilePart(PBSourceFile$), Len(GetFilePart(PBSourceFile$))-3)+".res"+#DQUOTE$+" "+#DQUOTE$+PBSourceFile$+#DQUOTE$, 0, "", 0)
        EndIf
      ;}
      EndIf
    EndIf
  Else;{ Parsing *.desc file
    If QuietMode=0
      SetGadgetText(#Text1, Language("TailBite","MakingLib"))
    EndIf
    ClearList(function())
    File0=ReadFile(#PB_Any, PBSourceFile$)
    If File0
      DescFileSize = Lof(File0)
      *DescFile = AllocateMemory(DescFileSize)
      ReadData(File0, *DescFile, DescFileSize)
      CloseFile(File0)
      *DescFileEnd = *DescFile+DescFileSize
      *DescFileSeeker = *DescFile
      DescPart = 1
      While *DescFileSeeker<*DescFileEnd
        ThisLine$=";"
        While Left(LTrim(ThisLine$), 1)=";"
          ThisLine$ = GetNextString(*DescFileSeeker, #SystemEOL)
          *DescFileSeeker = FindNextString(#SystemEOL, *DescFileSeeker, *DescFileEnd)+2
        Wend
        Select DescPart
          Case 1
            If Left(LTrim(ThisLine$), 3)<>"ASM"
              TBError(Language("TailBite","NoAsmFile"), 1, TBTempPath$)
              CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
            EndIf
          Case 2
            nl = Val(ThisLine$)
            For i=1 To nl
              *DescFileSeeker = FindNextString(#SystemEOL, *DescFileSeeker, *DescFileEnd)+2
            Next i
          Case 3
            *ThisSeek = 0
            If Left(LTrim(ThisLine$), 3)<>"LIB"
              *ThisSeek = FindNextString(#SystemEOL, *DescFileSeeker-3, *DescFile)+2
              While PeekB(*ThisSeek)=' '
                *ThisSeek+1
              Wend
              PokeB(*ThisSeek, 'L')
              PokeB(*ThisSeek+1, 'I')
              PokeB(*ThisSeek+2, 'B')
            EndIf
          Case 4
            nl = Val(ThisLine$)
            For i=1 To nl
              *DescFileSeeker = FindNextString(#SystemEOL, *DescFileSeeker, *DescFileEnd)+2
            Next i
          Case 5
            *DescFileSeeker = FindNextString(#SystemEOL, *DescFileSeeker, *DescFileEnd)+2
          Case 6
            If FindString(ThisLine$, ",", 1)
              ThisFunc$ = GetNextString(@ThisLine$, ",")
            ElseIf FindString(ThisLine$, " ", 1)
              ThisFunc$ = GetNextString(@ThisLine$, " ")
            Else
              ThisFunc$ = GetNextString(@ThisLine$, #SystemEOL)
            EndIf
            AddElement(function())
            function()\ID=ListIndex(function())
            function()\Name$ = ThisFunc$
            function()\DLLFunction = 1
            *DescFileSeeker = FindNextString(#SystemEOL, *DescFileSeeker, *DescFileEnd)+2
            *DescFileSeeker = FindNextString(#SystemEOL, *DescFileSeeker, *DescFileEnd)+2
            Break
          Default
            Break
        EndSelect
        DescPart+1
      Wend
      If *ThisSeek
        File0=OpenFile(#PB_Any, PBSourceFile$)
        If File0
          WriteData(File0, *DescFile, DescFileSize)
          CloseFile(File0)
        EndIf
      EndIf
      FreeMemory(*DescFile)
      TBDestFolder$ = TBTempPath$ ; TBFolder$+"TBTemp"+#DirSeparator
      If FileSize(TBDestFolder$)=-2
        DeleteDirectory(TBDestFolder$, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
      EndIf
      CopyDirectory(GetPathPart(PBSourceFile$), TBDestFolder$, "*.*", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
      If KeepSrcFiles
        WriteLog("KeepSrcFiles")
        If Right(LibSourceFolder$, 1)<>#DirSeparator:LibSourceFolder$+#DirSeparator:EndIf
        If FileSize(LibSourceFolder$)=-2
          DeleteDirectory(LibSourceFolder$+LibName$, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
        EndIf
        If CopyDirectory(GetPathPart(PBSourceFile$), LibSourceFolder$+LibName$, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
          WriteLog("CopyDirectory "+#DQUOTE$+GetPathPart(PBSourceFile$)+#DQUOTE$+" "+#DQUOTE$+LibSourceFolder$+LibName$+#DQUOTE$+" successfull")
        Else
          WriteLog("CopyDirectory "+#DQUOTE$+GetPathPart(PBSourceFile$)+#DQUOTE$+" "+#DQUOTE$+LibSourceFolder$+LibName$+#DQUOTE$+" failed !")
        EndIf
      EndIf
      If Right(TBDestFolder$, 1)<>#DirSeparator:TBDestFolder$+#DirSeparator:EndIf
      GetFileList(TBDestFolder$, 0, "")
      ForEach FileList()
        If LCase(GetExtensionPart(FileList()))="asm"
          If OpenFile(0, FileList())
            FirstInclude = 1
            *AsmFileSeekerAnchor = 0
            AsmFileSize = Lof(0)
            *AsmFile = AllocateMemory(AsmFileSize)
            ReadData(0, *AsmFile, AsmFileSize)
            CloseFile(0)
            *AsmFileSeeker = *AsmFile
            *AsmFileEnd = *AsmFile+AsmFileSize
            While *AsmFileSeeker<*AsmFileEnd
              *AsmFileSeeker = FindNextString("include ", *AsmFileSeeker, *AsmFileEnd)
              If *AsmFileSeeker<*AsmFileEnd
                *AsmFileSeeker+7
                While PeekB(*AsmFileSeeker)=' '
                  *AsmFileSeeker+1
                Wend
                qt.s = Chr(PeekB(*AsmFileSeeker))
                If FirstInclude
                  *NewAsmFile = AllocateMemory(AsmFileSize*2)
                  CopyMemory(*AsmFile, *NewAsmFile, *AsmFileSeeker-*AsmFile+1)
                  *NewAsmFileSeeker = *NewAsmFile+(*AsmFileSeeker-*AsmFile)+1
                  FirstInclude = 0
                Else
                  CopyMemory(*AsmFileSeekerAnchor, *NewAsmFileSeeker, *AsmFileSeeker-*AsmFileSeekerAnchor+1)
                  *NewAsmFileSeeker+(*AsmFileSeeker-*AsmFileSeekerAnchor)+1
                EndIf
                ThisInclude$ = GetNextString(*AsmFileSeeker+1, qt)
                *AsmFileSeeker = FindNextString(#SystemEOL, *AsmFileSeeker, *AsmFileEnd)
                *AsmFileSeekerAnchor = *AsmFileSeeker
                ThisInclude$ = RemoveString(ThisInclude$, qt)
                IncludeFolder$ = RemoveString(GetPathPart(FileList()), TBFolder$)
                If Right(IncludeFolder$, 1)<>#DirSeparator:IncludeFolder$+#DirSeparator:EndIf
                While FindString(ThisInclude$, "."+#DirSeparator, 1)
                  IncludeFolder$ = GetPathPart(Left(IncludeFolder$, Len(IncludeFolder$)-1))
                  ThisInclude$ = Right(ThisInclude$, Len(ThisInclude$)-2)
                Wend
                ThisInclude$ = IncludeFolder$+ThisInclude$
                CopyMemory(@ThisInclude$, *NewAsmFileSeeker, Len(ThisInclude$))
                *NewAsmFileSeeker+Len(ThisInclude$)
                PokeB(*NewAsmFileSeeker, Asc(qt))
                *NewAsmFileSeeker+1
              EndIf
            Wend
            If *NewAsmFile
              CopyMemory(*AsmFileSeekerAnchor, *NewAsmFileSeeker, *AsmFileSeeker-*AsmFileSeekerAnchor)
              *NewAsmFileSeeker+(*AsmFileSeeker-*AsmFileSeekerAnchor)
              If OpenFile(0, FileList())
                WriteData(0, *NewAsmFile, *NewAsmFileSeeker-*NewAsmFile)
                CloseFile(0)
              EndIf
            EndIf
            FreeMemory(*AsmFile)
            If *NewAsmFile
              FreeMemory(*NewAsmFile)
              *NewAsmFile = 0
            EndIf
          EndIf
        ElseIf LCase(GetExtensionPart(FileList()))="hhp"
          HelpCompile(FileList())
          ChmFile$ = Left(FileList(), Len(FileList())-4)+".chm"
          If FileSize(ChmFile$)<>-1
            NewChmFile$ = PBFolder$+"Help"+#DirSeparator+LibName$+".chm"
            If FileSize(NewChmFile$)<>-1
              DeleteFile(NewChmFile$)
            EndIf
            CopyFile(ChmFile$, NewChmFile$)
          EndIf
        EndIf
        ;shorten path of filelist ABBKlaus 8.6.2007 23:26
        If FindString(FileList(),"Functions"+#DirSeparator+"Shared"+#DirSeparator,1)
          ; Shared asm
          FileList()="Functions"+#DirSeparator+"Shared"+#DirSeparator+GetFilePart(FileList())
        Else
          FileList()="Functions"+#DirSeparator+GetFilePart(FileList())
        EndIf
      Next
      MakeIt(TBDestFolder$)
      If LibName$<>OrigLibName$
        If TBOutputpath$<>""
          RenameFile(TBOutputpath$+LibName$, TBOutputpath$+OrigLibName$)
        Else
          RenameFile(PBFolder$+PBUserLibraryFolder$+LibName$, PBFolder$+PBUserLibraryFolder$+OrigLibName$)
        EndIf
      EndIf
      If KeepSrcFiles
        WriteLog("KeepSrcFiles")
        If QuietMode=0
          SetGadgetText(#Text1, Language("TailBite","CopySourceFiles"))
        EndIf
        If FileSize(LibSourceFolder$)<>-2
          If CreateDirectory(LibSourceFolder$)
            WriteLog("CreateDirectory "+#DQUOTE$+LibSourceFolder$+#DQUOTE$+" successfull")
          Else
            WriteLog("CreateDirectory "+#DQUOTE$+LibSourceFolder$+#DQUOTE$+" failed !")
          EndIf
        EndIf
        If FileSize(DestFolder$)=-2
          DeleteDirectory(DestFolder$, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
        EndIf
        If CopyDirectory(TBDestFolder$, DestFolder$, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
          WriteLog("CopyDirectory "+#DQUOTE$+TBDestFolder$+#DQUOTE$+" "+#DQUOTE$+DestFolder$+#DQUOTE$+" successfull")
        Else
          WriteLog("CopyDirectory "+#DQUOTE$+TBDestFolder$+#DQUOTE$+" "+#DQUOTE$+DestFolder$+#DQUOTE$+" failed !")
        EndIf
        ; Copy logfile into source directory
        WriteLog("",#True)
        CopyFile(TailBiteLogFile, DestFolder$+GetFilePart(TailBiteLogFile))
      EndIf
      DeleteDirectory(TBDestFolder$, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
    EndIf
  ;}
  EndIf
  
  ;copy back saved lib
  If recover
    Debug "recovering"
    RenameFile(tmplibfile$,oldlibfile$)
  EndIf
  ;
  If QuietMode=0
    DisableGadget(#Button1,1)
    ;SetGadgetText(#Text1, Language("TailBite","RestartCompiler"))
  EndIf
  
  Delay(500)
  CompilerIf Defined(TB_Building_DLL, #PB_Constant)
    tb_result=1
  CompilerEndIf
  Quit = 1
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 241
; FirstLine = 187
; Folding = ---
; Markers = 522
; EnableXP
; UseMainFile = TailBite.pb