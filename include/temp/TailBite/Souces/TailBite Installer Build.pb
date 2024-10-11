EnableExplicit

#TB_TestDontSetTBDirToSourceDir=1
#WM_QUITTHREAD = #WM_USER+10

#g = 4
#lh = 24
Enumeration
  #TVersion
  #Version
  #TailBiteInstaller
  #TailBitePack
  #PBSources
  #HelperLibs
  #Help
  #BuildDir
  #BrowseBuildDir
  #Build
  #Status
EndEnumeration

Structure BuildInfo
  Version$
  DirName$
  BuildDir$
  HelpDirName$
EndStructure

Structure FileVersion
  Name$
  Version$
EndStructure

Global SrcDirName$, LastText$, BuildIt, BTailBiteInstaller, TBTempDirectory$

XIncludeFile "Tailbite_Res.pb"
XIncludeFile "Inc_Language.pb"  ; No WinAPI
CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Windows
    XIncludeFile "Inc_OS_Win.pb" ; WinAPI
  CompilerCase #PB_OS_Linux
    XIncludeFile "Inc_OS_Linux.pb"
CompilerEndSelect
XIncludeFile "Inc_Parameter.pb" ; No WinAPI
XIncludeFile "Inc_Misc.pb"      ; No WinAPI
XIncludeFile "Inc_Prefs.pb"     ; No WinAPI
XIncludeFile "Inc_Compiler.pb"  ; No WinAPI

Procedure MakePack(FileName$, DirName$, IncludeRoot, ExcludeFolder$)
  Protected *mem,Pos.l,DName$,td$,FuName$,Size.q
  
  ClearList(DirList())
  If IncludeRoot
    AddElement(DirList())
    DirList() = DirName$
  EndIf
  ClearList(FileList())
  GetFileList(DirName$, 0, DirName$+ExcludeFolder$)
  If FileSize(FileName$)=>0
    DeleteFile(FileName$)
  EndIf
  If CreatePack(0,FileName$)
    *mem = AllocateMemory(1024)
    ForEach DirList()
      PokeS(*mem, "DIR")
      Pos=4*SizeOf(character)
      DName$ = RemoveString(DirList(), DirName$)
      If DName$
        PokeS(*mem+Pos,DName$)
        Pos+(Len(DName$)+1)*SizeOf(character)
        ;store the date of directory
        td$=DirList()
        If Right(td$,1)=#DirSeparator
          td$=Left(td$,Len(td$)-1)
        EndIf
        PokeL(*mem+Pos,GetFileDate(td$,#PB_Date_Created)):Pos+4
        PokeL(*mem+Pos,GetFileDate(td$,#PB_Date_Accessed)):Pos+4
        PokeL(*mem+Pos,GetFileDate(td$,#PB_Date_Modified)):Pos+4
        AddPackMemory(0,*mem,9, Pos)
      EndIf
    Next
    
    ForEach FileList()
      Size=FileSize(FileList())
      Pos=0
      FuName$=RemoveString(FileList(),DirName$)
      PokeS(*mem+Pos,FuName$)
      Pos+(Len(FuName$)+1)*SizeOf(character)
      PokeL(*mem+Pos,GetFileDate(FileList(),#PB_Date_Created)):Pos+4
      PokeL(*mem+Pos,GetFileDate(FileList(),#PB_Date_Accessed)):Pos+4
      PokeL(*mem+Pos,GetFileDate(FileList(),#PB_Date_Modified)):Pos+4
      PokeQ(*mem+Pos,Size):Pos+8 ; Store the size of the file
      AddPackMemory(*mem,Pos,9)
      If Size ; zero-byte files can't be packed !
        AddPackFile(FileList(),9)
      EndIf
    Next
    FreeMemory(*mem)
    ClosePack()
  Else
    TBError("Can't create pack.", 1, "")
  EndIf
EndProcedure

Procedure TBCompiler()
  Protected FinalLibsDir$,HelperLibsSrc$,Dir0.l,Dir1.l,HelperLibName$,HLibFolder$,File0.l,FasmError.l,LibFunctionsDir$
  Protected FName$,FileString$,cs$,Text$,LibSharedDir$, FinalSamplesDir$, SamplesSrc$
  
  FinalLibsDir$ = TBFolder$+"Helper Libraries\"
  SHCreateDirectory_(#Null, FinalLibsDir$)
  
  If FileSize(PBCompilerFolder$+"polib.exe")=-1
    TBError(Language("TBCompiler","NoCompiler"),0,"")
    ProcedureReturn 0
  Else
    Libexe$ = PBCompilerFolder$+"polib.exe"
    LibexeBaseName$ = "polib"
  EndIf
  
  HelperLibsSrc$ = SrcDirName$+"Addons\"
  
  If FileSize(FinalLibsDir$)<>-2
    CreateDirectory(FinalLibsDir$)
  EndIf
  Dir0=ExamineDirectory(#PB_Any, HelperLibsSrc$, "*.*")
  If Dir0
    While NextDirectoryEntry(Dir0)
      If DirectoryEntryName(Dir0)<>"." And DirectoryEntryName(Dir0)<>".." And DirectoryEntryName(Dir0)<>".svn" And DirectoryEntryName(Dir0)<>".DS_Store";.DS_Store is OS X crapola.
        HelperLibName$ = DirectoryEntryName(Dir0)
        If FileSize(HelperLibsSrc$+HelperLibName$)=-2 And FileSize(HelperLibsSrc$+HelperLibName$+"\dontcompileme") = -1
          HLibFolder$ = HelperLibsSrc$+HelperLibName$+"\"
          File0=CreateFile(#PB_Any, HelperLibsSrc$+HelperLibName$+"ObjFiles.txt");HLibFolder$+HelperLibName$+"ObjFiles.txt")
          If File0
            FasmError = 0
            LibFunctionsDir$ = HLibFolder$+"Functions\"
            Dir1=ExamineDirectory(#PB_Any, LibFunctionsDir$, "*.asm")
            If Dir1
              While NextDirectoryEntry(Dir1)
                FName$ = DirectoryEntryName(Dir1)
                FileString$ = LibFunctionsDir$+FName$
                If FileSize(FileString$)<>-2
                  cs$ = ExecuteProgram(#DQUOTE$+PBCompilerFolder$+"FAsm.exe"+#DQUOTE$, #DQUOTE$+FileString$+#DQUOTE$+" "+#DQUOTE$+ReplaceString(FileString$, ".asm", ".obj")+#DQUOTE$, "")
                  If Right(cs$, Len(FasmOk$))<>FasmOk$
                    Text$=Language("TBCompiler","UnableToCompile")
                    Text$=ReplaceString(Text$,"%helperlibname%",HelperLibName$)
                    Text$=ReplaceString(Text$,"%filestring%",FileString$)
                    Text$=ReplaceString(Text$,"%program%","FAsm:")
                    Text$=ReplaceString(Text$,"%errmsg%",cs$)
                    TBError(Text$, 1, "")
                    FasmError = 1
                  Else
                    WriteString(File0, #DQUOTE$+HelperLibName$+"\Functions\"+Left(FName$, Len(FName$)-4)+".obj"+#DQUOTE$+#CRLF$)
                  EndIf
                EndIf
              Wend
              FinishDirectory(Dir1)
            EndIf
            LibSharedDir$ = LibFunctionsDir$+"Shared\"
            Dir1=ExamineDirectory(#PB_Any, LibSharedDir$, "*.asm")
            If Dir1
              While NextDirectoryEntry(Dir1)
                FName$ = DirectoryEntryName(Dir1)
                FileString$ = LibSharedDir$+DirectoryEntryName(Dir1)
                If FileSize(FileString$)<>-2
                  cs$ = ExecuteProgram(#DQUOTE$+PBCompilerFolder$+"FAsm.exe"+#DQUOTE$, #DQUOTE$+FileString$+#DQUOTE$+" "+#DQUOTE$+ReplaceString(FileString$, ".asm", ".obj")+#DQUOTE$, "")
                  If FindString(cs$,FasmOk$,1)=0
                    Text$=Language("TBCompiler","UnableToCompile")
                    Text$=ReplaceString(Text$,"%helperlibname%",HelperLibName$)
                    Text$=ReplaceString(Text$,"%filestring%",FileString$)
                    Text$=ReplaceString(Text$,"%program%","FAsm:")
                    Text$=ReplaceString(Text$,"%errmsg%",cs$)
                    TBError(Text$, 1, "")
                    FasmError = 1
                  Else
                    WriteString(File0,#DQUOTE$+HelperLibName$+"\Functions\Shared\"+Left(FName$, Len(FName$)-4)+".obj"+#DQUOTE$+#CRLF$)
                  EndIf
                EndIf
              Wend
              FinishDirectory(Dir1)
            EndIf
            CloseFile(File0)
          EndIf
          If FasmError=0
            cs$ = ExecuteProgram(#DQUOTE$+Libexe$+#DQUOTE$, "/out:"+#DQUOTE$+HelperLibName$+"\"+HelperLibName$+".lib"+#DQUOTE$+" @"+#DQUOTE$+HelperLibName$+"ObjFiles.txt"+#DQUOTE$, "",HelperLibsSrc$)
            If cs$
              Text$=Language("TBCompiler","UnableToCompile")
              Text$=ReplaceString(Text$,"%helperlibname%",HelperLibName$)
              Text$=ReplaceString(Text$,"%filestring%","")
              Text$=ReplaceString(Text$,"%program%",LibexeBaseName$)
              Text$=ReplaceString(Text$,"%errmsg%",cs$)
              TBError(Text$, 1, "")
            Else
              DeleteFile(HelperLibsSrc$+HelperLibName$+"ObjFiles.txt")
              cs$ = ExecuteProgram(#DQUOTE$+LibraryMaker$+#DQUOTE$,#DQUOTE$+HLibFolder$+HelperLibName$+".Desc"+#DQUOTE$+" /TO "+#DQUOTE$+FinalLibsDir$+#DQUOTE$+" /COMPRESSED", "")
              If cs$
                Text$=Language("TBCompiler","UnableToCompile")
                Text$=ReplaceString(Text$,"%helperlibname%",HelperLibName$)
                Text$=ReplaceString(Text$,"%filestring%",FileString$)
                Text$=ReplaceString(Text$,"%program%","Library Maker:")
                Text$=ReplaceString(Text$,"%errmsg%",cs$)
                TBError(Text$, 1, "")
              Else
                If FileSize(LibFunctionsDir$)=-2
                  Dir1=ExamineDirectory(#PB_Any, LibFunctionsDir$, "*.obj")
                  If Dir1
                    While NextDirectoryEntry(Dir1)
                      DeleteFile(LibFunctionsDir$+DirectoryEntryName(Dir1))
                    Wend
                    FinishDirectory(Dir1)
                  EndIf
                EndIf
                If FileSize(LibSharedDir$)=-2
                  Dir1=ExamineDirectory(#PB_Any, LibSharedDir$, "*.obj")
                  If Dir1
                    While NextDirectoryEntry(Dir1)
                      DeleteFile(LibSharedDir$+DirectoryEntryName(Dir1))
                    Wend
                    FinishDirectory(Dir1)
                  EndIf
                EndIf
                DeleteFile(HLibFolder$+HelperLibName$+".lib")
              EndIf
            EndIf
          EndIf
          DeleteFile(HelperLibsSrc$+HelperLibName$+"ObjFiles.txt")
          If FileSize(HLibFolder$+HelperLibName$+".res.pb")<>-1
            If FileSize(PBFolder$+"Residents\"+HelperLibName$+".res")<>-1
              DeleteFile(PBFolder$+"Residents\"+HelperLibName$+".res")
            EndIf
            PBCompile("", "", " /RESIDENT "+#DQUOTE$+FinalLibsDir$+HelperLibName$+".res"+#DQUOTE$+" "+#DQUOTE$+HLibFolder$+HelperLibName$+".res.pb"+#DQUOTE$, 0, "", 0)
          EndIf
        ElseIf FileSize(HelperLibsSrc$+HelperLibName$+"\dontcompileme")>-1;-copy the IncludeFile helper libs
          ;SHCreateDirectory_(#Null, FinalLibsDir$+HelperLibName$+"\");like MakeSureDirectoryPathExists - but x64/unicode safe
          CopyFile(HelperLibsSrc$+HelperLibName$+"\"+HelperLibName$+".pb", FinalLibsDir$+HelperLibName$+".pb")
        EndIf
      EndIf
    Wend
    FinishDirectory(Dir0)
  EndIf
  ;-enable build with no TB directory / ensure files are fresh. (saves remembering to copy .pb files that were updated in svn)
  FinalSamplesDir$ = TBFolder$+"Samples\"
  SHCreateDirectory_(#Null, FinalSamplesDir$+"MyDebugErrorPlugin")
  SHCreateDirectory_(#Null, FinalSamplesDir$+"MyPaintBoxGadget")
  SHCreateDirectory_(#Null, FinalSamplesDir$+"TestLibs")
  SHCreateDirectory_(#Null, FinalSamplesDir$+"ImageDecoderFake")
  SHCreateDirectory_(#Null, FinalSamplesDir$+"FakeImageEncoder")
  
  SamplesSrc$ = SrcDirName$+"Samples\"
  CopyFile(SamplesSrc$+"MyDebugErrorPlugin\MyDebugErrorPlugin.pb", FinalSamplesDir$+"MyDebugErrorPlugin\MyDebugErrorPlugin.pb")
  CopyFile(SamplesSrc$+"MyPaintBoxGadget\MyPaintBoxGadget.pb", FinalSamplesDir$+"MyPaintBoxGadget\MyPaintBoxGadget.pb")
  CopyFile(SamplesSrc$+"MyPaintBoxGadget\MyPaintBoxGadgetTest.pb", FinalSamplesDir$+"MyPaintBoxGadget\MyPaintBoxGadgetTest.pb")
  CopyFile(SamplesSrc$+"TestLibs\sample_00.pb", FinalSamplesDir$+"TestLibs\sample_00.pb")
  CopyFile(SamplesSrc$+"ImageDecoderFake\ImageDecoderFake.pb", FinalSamplesDir$+"ImageDecoderFake\ImageDecoderFake.pb")
  CopyFile(SamplesSrc$+"ImageDecoderFake\TestFakeImageDecoder.pb", FinalSamplesDir$+"ImageDecoderFake\TestFakeImageDecoder.pb")
  CopyFile(SamplesSrc$+"FakeImageEncoder\FakeImageEncoder.pb", FinalSamplesDir$+"FakeImageEncoder\FakeImageEncoder.pb")
  CopyFile(SamplesSrc$+"FakeImageEncoder\test.pb", FinalSamplesDir$+"FakeImageEncoder\test.pb")
  
  CopyFile(SrcDirName$+"LICENSE.TXT", TBFolder$+"LICENSE.TXT")
  
  ;CopyFile(SrcDirName$+"fasm.dll", TBFolder$+"fasm.dll")
  CompilerIf #PB_Compiler_Processor = #PB_Processor_x64; this is not needed if TB is compiled in x86 mode, which it mostly always will be (fasm.obj is x86 only)
    CopyFile(SrcDirName$+"fasmstandby.exe", TBFolder$+"fasmstandby.exe")
  CompilerEndIf
  
  ProcedureReturn FasmError!1
EndProcedure

Procedure.s ParentDir(Dir$)
  Dir$ = GetPathPart(Left(Dir$, Len(Dir$)-1))
  If Right(Dir$, 1)<>"\":Dir$+"\":EndIf
  ProcedureReturn Dir$
EndProcedure

Procedure HtmlProcess(DirName$, DirID, OldTag$, NewTag$)
  Protected Type.l,FuName$,File1.l,HtmlFileSize.l,*HtmlFile,*NewHtmlFile,FSeeker.l,FEnd.l,Agreement$,File2.l
  Protected *HtmlFileSeeker,*NewHtmlFileSeeker,*HtmlFileEnd,LenVTag.l,LenVer.l,VerFound.l,File3.l
  
  If ExamineDirectory(DirID, DirName$, "")
    While NextDirectoryEntry(DirID)
      Type=DirectoryEntryType(DirID)
      If Type=#PB_DirectoryEntry_Directory
        If DirectoryEntryName(DirID)<>"." And DirectoryEntryName(DirID)<>".." And DirectoryEntryName(DirID)<>".svn"
          HtmlProcess(DirName$+DirectoryEntryName(DirID)+"\", DirID+1, OldTag$, NewTag$)
        EndIf
      ElseIf Type=#PB_DirectoryEntry_File
        FuName$ = DirectoryEntryName(DirID)
        If GetExtensionPart(FuName$)="html"
          File1=OpenFile(#PB_Any, DirName$+FuName$)
          If File1
            HtmlFileSize = Lof(File1)
            *HtmlFile = AllocateMemory(HtmlFileSize)
            *NewHtmlFile = AllocateMemory(HtmlFileSize*2)
            ReadData(File1, *HtmlFile, HtmlFileSize)
            CloseFile(File1)
            If FuName$="termsandconditions.html"
              FSeeker = *HtmlFile
              FEnd = *HtmlFile+HtmlFileSize
              While PeekS(FSeeker, 3)<>"<p>" And FSeeker<FEnd
                FSeeker+1
              Wend
              Agreement$ = "USER AGREEMENT"+NL$+"--------------"+NL$+NL$+PeekS(FSeeker)
              Agreement$ = RemoveString(Agreement$, "</body>")
              Agreement$ = RemoveString(Agreement$, "</html>")
              Agreement$ = RemoveString(Agreement$, "<h3>")
              Agreement$ = RemoveString(Agreement$, "<p>")
              Agreement$ = ReplaceString(Agreement$, "</h3>", NL$+NL$)
              Agreement$ = ReplaceString(Agreement$, "</p>", NL$+NL$)
              If Agreement$
                File2=CreateFile(#PB_Any, ParentDir(SrcDirName$)+"LICENSE.TXT")
                If File2
                  WriteString(File2, Agreement$)
                  CloseFile(File2)
                EndIf
              EndIf
            EndIf
            *HtmlFileSeeker = *HtmlFile
            *NewHtmlFileSeeker = *NewHtmlFile
            *HtmlFileEnd = *HtmlFile+HtmlFileSize
            LenVTag = Len(OldTag$)
            LenVer = Len(NewTag$)
            VerFound = 0
            While *HtmlFileSeeker<*HtmlFileEnd-LenVTag
              If PeekS(*HtmlFileSeeker, LenVTag)=OldTag$
                PokeS(*NewHtmlFileSeeker, NewTag$)
                *HtmlFileSeeker+LenVTag
                *NewHtmlFileSeeker+LenVer
                VerFound = 1
              Else
                PokeB(*NewHtmlFileSeeker, PeekB(*HtmlFileSeeker))
                *HtmlFileSeeker+1
                *NewHtmlFileSeeker+1
              EndIf
            Wend
            FreeMemory(*HtmlFile)
            If VerFound
              File3=CreateFile(#PB_Any, DirName$+FuName$)
              If File3
                WriteData(File3, *NewHtmlFile, *NewHtmlFileSeeker-*NewHtmlFile)
                CloseFile(File3)
              EndIf
            EndIf
            FreeMemory(*NewHtmlFile)
          EndIf
        EndIf
      EndIf
    Wend
    FinishDirectory(DirID)
  EndIf
EndProcedure

Procedure WritePackInfo(ThisFile$, Version$, URLCount, URL$)
  Protected URLEnd.l,ThisLength.l,UpdatePackSize.l,*UpdatePack,i.l
  
  URL$ = Left(URL$, Len(URL$)-1)
  If URLCount
    URLEnd = 1
  Else
    URLEnd = 0
  EndIf
  ThisLength = Len(Version$)+1+Len(Str(URLCount))+1+Len(URL$)+URLEnd+Len(Str(ListSize(FileList())))+1
  If OpenFile(0, ThisFile$)
    UpdatePackSize = Lof(0)+ThisLength
    *UpdatePack = AllocateMemory(UpdatePackSize)
    PokeS(*UpdatePack, Version$)
    PokeS(*UpdatePack+Len(Version$)+1, Str(URLCount))
    PokeS(*UpdatePack+Len(Version$)+1+Len(Str(URLCount))+1, URL$)
    For i=*UpdatePack+Len(Version$)+1+Len(Str(URLCount))+1 To *UpdatePack+ThisLength
      If PeekB(i)=10
        PokeB(i, 0)
      EndIf
    Next i
    PokeS(*UpdatePack+Len(Version$)+1+Len(Str(URLCount))+1+Len(URL$)+URLEnd, Str(ListSize(FileList())))
    ReadData(0, *UpdatePack+ThisLength, UpdatePackSize)
    CloseFile(0)
    If CreateFile(0, ThisFile$)
      WriteData(0, *UpdatePack, UpdatePackSize)
      CloseFile(0)
    EndIf
    FreeMemory(*UpdatePack)
  EndIf
EndProcedure

Procedure MakeBuilds(*bi.BuildInfo)
  Protected DirName$,BuildDir$,HelpDirName$,BTailBitePack.l,BPBSources.l,BHelperLibs.l,BHelp.l,NewVersion$
  Protected i.l,olddir$,ThisDate.l,ThisDate$,Dia.l,ThisDia$,Dir0.l,URLCount.l,U$,URL$,FileName$,nFiles.l
  Protected UpdatePackSize.l,*UpdatePack,fSeeker.l,nURL.l,ThisURL$,nFiles1.l,FirstFile.l,nFiles2.l,*Unpacked
  Protected FName$,ReportDirs$,ReportFiles$,Report$,nServers.l,IndexHtmlLines.l,HtmlLine$,IndexHtml$,hInet.l
  Protected hConnect.l,upload.l,Text$
  
  Version$ = *bi\Version$
  DirName$ = *bi\DirName$
  BuildDir$ = *bi\BuildDir$
  HelpDirName$ = *bi\HelpDirName$
  BTailBiteInstaller = GetGadgetState(#TailBiteInstaller)
  BTailBitePack = GetGadgetState(#TailBitePack)
  If BTailBitePack=0
    BPBSources = GetGadgetState(#PBSources)
    BHelperLibs = GetGadgetState(#HelperLibs)
    BHelp = GetGadgetState(#Help)
  EndIf
  NewVersion$ = GetGadgetText(#Version)
  If NewVersion$<>Version$
    If NewVersion$
      If CreatePreferences(SrcDirName$+"TailBite Installer Build.prefs")
        WritePreferenceString("Version", NewVersion$)
        ClosePreferences()
      EndIf
      Version$ = NewVersion$
    EndIf
  EndIf
  For i=#TVersion To #Build
    DisableGadget(i, #True)
  Next i
  SetGadgetText(#Status, Language("TBInstallerBuild","CopySourcesToTemp"))
  If FileSize(TBTempDirectory$)=-2
    DeleteDirectory(TBTempDirectory$,"",#PB_FileSystem_Recursive|#PB_FileSystem_Force)
    DeleteFile(BuildDir$+"TailBite.pack")
    DeleteFile(BuildDir$+"src.pack")
    DeleteFile(BuildDir$+"TailBite_Installer.exe")
    ;If CreateDirectory(TBTempDirectory$)=0
    ;  TBError(Language("TBInstallerBuild","TempError")+NL$+TBTempDirectory$,0,"")
    ;  End
    ;EndIf
  EndIf
  If CopyDirectory(SrcDirName$,TBTempDirectory$,"",#PB_FileSystem_Recursive|#PB_FileSystem_Force)
    SrcDirName$=TBTempDirectory$
    olddir$=GetCurrentDirectory()
    SetCurrentDirectory(SrcDirName$)
  Else
    TBError(Language("TBInstallerBuild","TempCopySrc"),0,TBTempDirectory$)
    End
  EndIf
  If BTailBiteInstaller|BTailBitePack|BPBSources
    SetGadgetText(#Status, Language("TBInstallerBuild","CompilingSources"))
    ;CopyFile(GetPathPart(Left(DirName$, Len(DirName$)-1))+"HttpDownload.txt", SrcDirName$+"HttpDownload.txt")
    PBCompile(SrcDirName$+"TBUpdater.pb", SrcDirName$+"TBUpdater.exe", " /ADMINISTRATOR /XP /LINENUMBERING", 0, "", 1)
    If CreatePack(SrcDirName$+"TBUpdater.pack")
      AddPackFile(SrcDirName$+"TBUpdater.exe", 9)
      ClosePack()
      DeleteFile(SrcDirName$+"TBUpdater.exe")
    EndIf
    ;DeleteFile(SrcDirName$+"HttpDownload.txt")
    ;Debug DirName$

    PBCompile(SrcDirName$+"TBManager.pb", DirName$+"TBManager.exe", " /ADMINISTRATOR /XP /LINENUMBERING", 1, "", 1)
    DeleteFile(SrcDirName$+"TBUpdater.pack")
    PBCompile(SrcDirName$+"TailBite.pb", DirName$+"TailBite.exe", " /ADMINISTRATOR /XP /LINENUMBERING", 1, "", 1)
    If FileSize(DirName$+"Catalogs\")<>-2
      CreateDirectory(DirName$+"Catalogs\")
    EndIf
    If FileSize(DirName$+"Catalogs\")=-2
      CopyDirectory(SrcDirName$+"Catalogs\",DirName$+"Catalogs\","*.*",#PB_FileSystem_Force)
    EndIf
  EndIf
  If BTailBiteInstaller|BTailBitePack|BHelperLibs
    SetGadgetText(#Status, Language("TBInstallerBuild","CompilingHelpLibs"))
    TBCompiler()
  EndIf
  If BTailBiteInstaller|BTailBitePack|BHelp
    SetGadgetText(#Status, Language("TBInstallerBuild","CompilingHelp"))
    HelpDirName$ = SrcDirName$+"Help"
    If FileSize(HelpDirName$)=-2
      HelpDirName$+"\"
      HtmlProcess(HelpDirName$, 0, "<%version%>", Version$)
      ThisDate = Date()
      Select Month(ThisDate)
        Case 1
          ThisDate$ = "January"
        Case 2
          ThisDate$ = "February"
        Case 3
          ThisDate$ = "March"
        Case 4
          ThisDate$ = "April"
        Case 5
          ThisDate$ = "May"
        Case 6
          ThisDate$ = "June"
        Case 7
          ThisDate$ = "July"
        Case 8
          ThisDate$ = "August"
        Case 9
          ThisDate$ = "September"
        Case 10
          ThisDate$ = "October"
        Case 11
          ThisDate$ = "November"
        Case 12
          ThisDate$ = "December"
      EndSelect
      Dia = Day(ThisDate)
      ThisDia$ = Str(Dia)
      Select Val(Right(ThisDia$, 1))
        Case 1
          ThisDate$+" "+ThisDia$+"st"
        Case 2
          ThisDate$+" "+ThisDia$+"nd"
        Case 3
          ThisDate$+" "+ThisDia$+"rd"
        Default
          ThisDate$+" "+ThisDia$+"th"
      EndSelect
      ThisDate$+" "+Str(Year(ThisDate))
      HtmlProcess(HelpDirName$, 0, "<%date%>", ThisDate$)
      Dir0=ExamineDirectory(#PB_Any, HelpDirName$, "*.*")
      If Dir0
        While NextDirectoryEntry(Dir0)
         If DirectoryEntryType(Dir0)=#PB_DirectoryEntry_Directory
           If DirectoryEntryName(Dir0)<>"." And DirectoryEntryName(Dir0)<>".." And DirectoryEntryName(Dir0)<>".svn"
             If HelpCompile(HelpDirName$+DirectoryEntryName(Dir0)+"\TailBite.hhp")
               If FileSize(DirName$+"TailBite "+DirectoryEntryName(Dir0)+".chm")<>-1
                 DeleteFile(DirName$+"TailBite "+DirectoryEntryName(Dir0)+".chm")
               EndIf
               RenameFile(HelpDirName$+DirectoryEntryName(Dir0)+"\TailBite.chm", DirName$+"TailBite "+DirectoryEntryName(Dir0)+".chm")
             EndIf
           EndIf
         EndIf
        Wend
        FinishDirectory(Dir0)
      EndIf
    EndIf
  EndIf
  If ReadFile(0, GetPathPart(Left(DirName$, Len(DirName$)-1))+"HttpDownload.txt")
    URLCount = Val(ReadString(0))
    For i=1 To URLCount
      U$=ReadString(0)
      URL$+U$+NL$
    Next
  EndIf
  If BTailBiteInstaller|BTailBitePack
    SetGadgetText(#Status, Language("TBInstallerBuild","CreatingPack"))
    FileName$ = BuildDir$+"TailBite.pack"
    MakePack(FileName$, DirName$, 0, "src\")
    WritePackInfo(FileName$, Version$, URLCount, URL$)
    SetGadgetText(#Status, Language("TBInstallerBuild","CreatingSrcPack"))
    FileName$ = BuildDir$+"src.pack"
    MakePack(FileName$, SrcDirName$, 1, "build\")
    WritePackInfo(FileName$, Version$, URLCount, URL$)
  EndIf
  If BTailBiteInstaller|BTailBitePack|BHelp
    SetGadgetText(#Status, Language("TBInstallerBuild","Restoring"))
    HtmlProcess(HelpDirName$, 0, Version$, "<%version%>")
    HtmlProcess(HelpDirName$, 0, ThisDate$, "<%date%>")
  EndIf
; Check TailBite.pack
  If BTailBiteInstaller|BTailBitePack
    SetGadgetText(#Status, Language("TBInstallerBuild","Checking"))
    nFiles = 0
    FileName$ = BuildDir$+"TailBite.pack"
    If OpenFile(0, FileName$)
      UpdatePackSize = Lof(0)
      *UpdatePack = AllocateMemory(UpdatePackSize)
      ReadData(0, *UpdatePack, UpdatePackSize)
      CloseFile(0)
      Version$ = PeekS(*UpdatePack)
      fSeeker = *UpdatePack+Len(Version$)+1
      nURL = Val(PeekS(fSeeker))
      fSeeker+Len(PeekS(fSeeker))+1
      For i=1 To nURL
        ThisURL$ = PeekS(fSeeker)
        fSeeker+Len(ThisURL$)+1
      Next i
      nFiles1 = Val(PeekS(fSeeker))
      fSeeker+Len(Str(nFiles1))+1
      If CreateFile(0, FileName$+".check")
        WriteData(0, fSeeker, UpdatePackSize-(fSeeker-*UpdatePack))
        CloseFile(0)
        If OpenPack(FileName$+".check")
          FirstFile = 1
          nFiles2 = 0
          Repeat
            *Unpacked = NextPackFile()
            If *Unpacked
              FName$ = PeekS(*Unpacked)
              If FName$="DIR"
                FName$ = PeekS(*Unpacked+4)
                ReportDirs$+"  "+FName$+NL$
              Else
                If FirstFile
                  FirstFile = 0
                EndIf
                ReportFiles$+"  "+FName$+NL$
                *Unpacked = NextPackFile()
                nFiles2+1
              EndIf
            EndIf
          Until *Unpacked=0
          ClosePack()
          Report$ = Language("TBInstallerBuild","CheckingReport")
          Report$ = ReplaceString(Report$,"%version%",Version$)
          Report$ = ReplaceString(Report$,"%nfiles1%",Str(nfiles1))
          Report$ = ReplaceString(Report$,"%dirs%",ReportDirs$)
          Report$ = ReplaceString(Report$,"%files%",ReportFiles$)
          Report$ = ReplaceString(Report$,"%nfiles2%",Str(nFiles2))
        Else
          Report$ = Language("TBInstallerBuild","ErrorPack")
        EndIf
        DeleteFile(FileName$+".check")
      EndIf
      FreeMemory(*UpdatePack)
      If BTailBiteInstaller
        SetGadgetText(#Status, Language("TBInstallerBuild","CompilingInstaller"))
        CopyFile(FileName$, SrcDirName$+"TailBite.pack")
        PBCompile(SrcDirName$+"TailBite Installer.pb", BuildDir$+"TailBite_Installer.exe", " /ADMINISTRATOR /XP /LINENUMBERING", 1, "", 1)
        DeleteFile(SrcDirName$+"TailBite.pack")
      EndIf
    EndIf
  EndIf
  ;clear temp directory
  SetCurrentDirectory(olddir$)
  DeleteDirectory(TBTempDirectory$,"",#PB_FileSystem_Recursive|#PB_FileSystem_Force)
  
  Structure ServerData
    ServerName$
    UserName$
    Password$
    Folder$
  EndStructure
  NewList Server.ServerData()
  If ReadFile(0, GetPathPart(Left(DirName$, Len(DirName$)-1))+"FtpUpload.txt")
    Report$+Chr(10)+Chr(10)+"Upload build?"
    nServers = Val(ReadString(0))
    While nServers
      AddElement(Server())
      Server()\ServerName$ = ReadString(0)
      Server()\UserName$ = ReadString(0)
      Server()\Password$ = ReadString(0)
      Server()\Folder$ = ReadString(0)
      nServers-1
    Wend
    nFiles = Val(ReadString(0))
    NewList UploadList.s()
    For i=1 To nFiles
      AddElement(UploadList())
      UploadList() = ReadString(0)
    Next i
    CloseFile(0)
  EndIf
  
  If Report$
    Select MessageRequester("TailBite Installer Build", Report$, #PB_MessageRequester_YesNo)
      Case #PB_MessageRequester_Yes
        If ListSize(Server())
          Read IndexHtmlLines
          For i=1 To IndexHtmlLines
            Read.s HtmlLine$
            IndexHtml$+HtmlLine$
          Next i
          IndexHtml$ = ReplaceString(IndexHtml$, "<%ISize%>", Str(FileSize(BuildDir$+"TailBite_Installer.exe")))
          IndexHtml$ = ReplaceString(IndexHtml$, "<%SSize%>", Str(FileSize(BuildDir$+"src.pack")))
          IndexHtml$ = ReplaceString(IndexHtml$, "<%version%>", Version$)
          IndexHtml$ = ReplaceString(IndexHtml$, "<%date%>", ThisDate$)
          If CreateFile(0, BuildDir$+"index.html")
            WriteString(0, IndexHtml$)
            CloseFile(0)
          EndIf
        EndIf
        If ListSize(Server())
          hInet = InternetOpen_("FTP", #INTERNET_OPEN_TYPE_PRECONFIG, #Null, #Null, 0)
          If hInet=0
            TBError(Language("TBInstallerBuild","InternetOpenError"), 0, "")
          Else
            ForEach Server()
              SetGadgetText(#Status, ReplaceString(Language("TBInstallerBuild","Connecting"),"%server%",Server()\ServerName$))
              hConnect = InternetConnect_(hInet, Server()\ServerName$, #FTP_PORT, Server()\UserName$, Server()\Password$, #INTERNET_SERVICE_FTP, 0, 0)
              If hConnect=0
                TBError(ReplaceString(Language("TBInstallerBuild","ServerError"),"%server%",Server()\ServerName$), 0, "")
              Else
                upload = 1
                If Server()\Folder$
                  SetGadgetText(#Status, ReplaceString(Language("TBInstallerBuild","ServerCHDir"),"%folder%",Server()\ServerName$+Server()\Folder$))
                  If FtpSetCurrentDirectory_(hConnect, Server()\Folder$)=0
                    TBError(ReplaceString(Language("TBInstallerBuild","ServerCHDirErr"),"%server%",Server()\ServerName$), 0, "")
                    upload = 0
                  EndIf
                EndIf
                If upload
                  ForEach UploadList()
                    Text$=Language("TBInstallerBuild","Uploading")
                    Text$=ReplaceString(Text$,"%uploadlist%",UploadList())
                    Text$=ReplaceString(Text$,"%server%",Server()\ServerName$)
                    SetGadgetText(#Status,Text$)
                    If FtpPutFile_(hConnect, BuildDir$+UploadList(), UploadList(), #FTP_TRANSFER_BINARY, 0)=0
                      Text$=Language("TBInstallerBuild","UploadErr")
                      Text$=ReplaceString(Text$,"%uploadlist%",UploadList())
                      Text$=ReplaceString(Text$,"%server%",Server()\ServerName$)
                      TBError(Text$, 0, "")
                    EndIf
                  Next
                EndIf
              EndIf
              If hConnect:InternetCloseHandle_(hConnect):EndIf
            Next
            InternetCloseHandle_(hInet)
            LastText$ = "Uploading done"+NL$
          EndIf
        EndIf
      Default
        ;End
    EndSelect
  Else
    ;End
  EndIf
  BuildIt = 1
EndProcedure

Define DirName$,BuildDir$,BrowseWidth.l,YCr.l,*SHAutoComplete,Event.l,Status.l,i.l,TmpBuildDir$,Building.l
Define PreviousBuildDir$,bi.BuildInfo,HelpDirName$,olddirectory$

TBLoadPreferences()

TBTempDirectory$=GetTemporaryDirectory()+"TailBite Installer Build\"

SrcDirName$ = GetCurrentDirectory()

If Right(SrcDirName$, 1)<>"\"
  SrcDirName$+"\"
EndIf

DirName$ = TBFolder$;GetPathPart(Left(SrcDirName$, Len(SrcDirName$)-1))

If DirName$
  If Right(DirName$, 1)<>"\"
    DirName$+"\"
  EndIf
  If OpenPreferences(SrcDirName$+"TailBite Installer Build.prefs")
    Version$ = ReadPreferenceString("Version", "")
    ClosePreferences()
  EndIf
  BuildDir$ = SrcDirName$+"build\"
  If OpenWindow(0, 0, 0, 480, 260, "TailBite Installer Builder", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_TitleBar|#PB_Window_ScreenCentered)
    If StartDrawing(WindowOutput(0))
      BrowseWidth = TextWidth(" ... ")
      StopDrawing()
    EndIf
    ;If CreateGadgetList(WindowID(0))
      TextGadget(#TVersion, #g, #g*3, 96, #lh+(#g*2), Language("TBInstallerBuild","BuildVersion"))
      StringGadget(#Version, 96+(#g*2), #g, 96, #lh+(#g*2), Version$)
      YCr = #lh+(#g*4)
      CheckBoxGadget(#TailBiteInstaller, #g, YCr, 180, #lh, Language("TBInstallerBuild","BuildExe")):YCr+#lh+#g
      CheckBoxGadget(#TailBitePack, #g, YCr, 180, #lh, Language("TBInstallerBuild","BuildPack")):YCr+#lh+#g
      CheckBoxGadget(#PBSources, #g, YCr, 180, #lh, Language("TBInstallerBuild","BuildSources")):YCr+#lh+#g
      SetGadgetState(#PBSources, #True)
      CheckBoxGadget(#HelperLibs, #g, YCr, 180, #lh, Language("TBInstallerBuild","BuildHelpLibs")):YCr+#lh+#g
      SetGadgetState(#HelperLibs, #True)
      CheckBoxGadget(#Help, #g, YCr, 180, #lh, Language("TBInstallerBuild","BuildHelp")):YCr+#lh+#g
      SetGadgetState(#Help, #True)
      StringGadget(#BuildDir, #g, YCr, WindowWidth(0)-(#g*3)-BrowseWidth, #lh+(#g*2), BuildDir$)
      ButtonGadget(#BrowseBuildDir, WindowWidth(0)-(#g*1)-BrowseWidth, YCr, BrowseWidth, #lh+(#g*2), " ... "):YCr+#lh+#g
      ButtonGadget(#Build, WindowWidth(0)-96-#g, WindowHeight(0)-#lh-(#g*3), 96, #lh+(#g*2), Language("TBInstallerBuild","Build"))
      TextGadget(#Status, #g, YCr+#lh, 370, #lh, "")
      ;Enable autocomplete for Folders
      If OpenLibrary(0, "shlwapi.dll")
        *SHAutoComplete = GetFunction(0, "SHAutoComplete")
        If *SHAutoComplete<>#Null
          CallFunctionFast(*SHAutoComplete, GadgetID(#BuildDir), #SHACF_AUTOAPPEND_FORCE_ON|#SHACF_AUTOSUGGEST_FORCE_ON|#SHACF_FILESYSTEM)
        EndIf
        CloseLibrary(0)
      EndIf
      
      Repeat
        Event = WaitWindowEvent()
        Select Event
          Case #PB_Event_Gadget
            Status = 0
            For i=#TailBiteInstaller To #Help
              Status|GetGadgetState(i)
            Next i
            If Status=0
              DisableGadget(#Build, #True)
            Else
              DisableGadget(#Build, #False)
            EndIf
            Select EventGadget()
              Case #TailBitePack
                If GetGadgetState(#TailBitePack)
                  For i=#PBSources To #Help
                    SetGadgetState(i, #True)
                    DisableGadget(i, #True)
                  Next i
                Else
                  For i=#PBSources To #Help
                    DisableGadget(i, #False)
                  Next i
                EndIf
              Case #BrowseBuildDir
                TmpBuildDir$ = PathRequester(Language("TBInstallerBuild","BuildDir"), GetGadgetText(#BuildDir))
                If TmpBuildDir$
                  BuildDir$ = TmpBuildDir$
                  If Right(BuildDir$, 1)<>"\":BuildDir$+"\":EndIf
                  SetGadgetText(#BuildDir, BuildDir$)
                EndIf
              Case #Build
                If Building=0
                  BuildDir$ = GetGadgetText(#BuildDir)
                  If BuildDir$
                    PreviousBuildDir$ = ""
                    If FileSize(BuildDir$)<>-2
                      CreateDirectory(BuildDir$)
                      PreviousBuildDir$ = BuildDir$
                    EndIf
                    If PreviousBuildDir$
                      BuildDir$ = PathRequester(Language("TBInstallerBuild","BuildPath"), BuildDir$)
                    EndIf
                    If PreviousBuildDir$
                      If Right(PreviousBuildDir$, 1)<>"\":PreviousBuildDir$+"\":EndIf
                      If Right(BuildDir$, 1)<>"\":BuildDir$+"\":EndIf
                      If PreviousBuildDir$<>BuildDir$
                        DeleteDirectory(PreviousBuildDir$, "")
                      EndIf
                    EndIf
                    bi\Version$ = Version$
                    bi\DirName$ = DirName$
                    bi\BuildDir$ = BuildDir$
                    bi\HelpDirName$ = HelpDirName$
                    olddirectory$=GetCurrentDirectory()
                    CompilerIf #PB_Compiler_Debugger
                      MakeBuilds(@bi)
                    CompilerElse
                      CreateThread(@MakeBuilds(), @bi)
                    CompilerEndIf
                    Building = 1
                  Else
                    MessageRequester("TailBite Installer Builder", Language("TBInstallerBuild","PathError"))
                  EndIf
                EndIf
            EndSelect
          Case #PB_Event_CloseWindow
            Break
        EndSelect
      Until BuildIt
    ;EndIf
  EndIf
EndIf

If olddirectory$ And GetCurrentDirectory()<>olddirectory$
  SetCurrentDirectory(olddirectory$)
EndIf
If BuildIt And MessageRequester("TailBite Installer Builder", LastText$+Language("TBInstallerBuild","Install"), #PB_MessageRequester_YesNo)=#PB_MessageRequester_Yes And BTailBiteInstaller
  RunProgram(BuildDir$+"TailBite_Installer.exe")
EndIf

End

DataSection
Data.l 21
Data.s "<!DOCTYPE HTML PUBLIC "+Chr(34)+"-//W3C//DTD HTML 4.0 Transitional//EN"+Chr(34)+">"+Chr(10)
Data.s "<meta http-equiv="+Chr(34)+"Content-Type"+Chr(34)+" content="+Chr(34)+"text/html; charset=iso-8859-1"+Chr(34)+">"+Chr(10)
Data.s "<html>"+Chr(10)
Data.s "<head>"+Chr(10)
Data.s "<title>TailBite download page</title>"+Chr(10)
Data.s "<style type="+Chr(34)+"text/css"+Chr(34)+">"+Chr(10)
Data.s "body, td, div, p, li, a, blockquote, b { font-family: verdana, helvetica, sans-serif }"+Chr(10)
Data.s "</style>"+Chr(10)
Data.s "</head>"+Chr(10)
Data.s "<body>"+Chr(10)
Data.s "<blockquote>"+Chr(10)
Data.s "<h2>TailBite alpha and beta versions download page</h2>"+Chr(10)
Data.s "<p>You can only download alpha and beta versions from this page. Release versions will be available from <a href="+Chr(34)+"http://www.purearea.net"+Chr(34)+">PureArea</a> and <a href="+Chr(34)+"http://www.pureproject.net"+Chr(34)+">PureProject</a>.</p>"+Chr(10)
Data.s "<p><b>Version:</b> <%version%> <b>Date:</b> <%date%></p>"+Chr(10)
Data.s "<li>Installer:</li>"+Chr(10)
Data.s "<p><a href="+Chr(34)+"TailBite_Installer.exe"+Chr(34)+">TailBite_Installer.exe</a> (<%ISize%> bytes)</p>"+Chr(10)
Data.s "<li>Source: (put in TailBite folder and extract from TBManager)</li>"+Chr(10)
Data.s "<p><a href="+Chr(34)+"src.pack"+Chr(34)+">src.pack</a> (<%SSize%> bytes)</p>"+Chr(10)
Data.s "</blockquote>"+Chr(10)
Data.s "</body>"+Chr(10)
Data.s "</html>"+Chr(10)
EndDataSection
; IDE Options = PureBasic 5.11 (Windows - x86)
; CursorPosition = 84
; FirstLine = 67
; Folding = --
; EnableXP
; EnableAdmin
; CompileSourceDirectory