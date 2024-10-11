XIncludeFile "Tailbite_Res.pb"
XIncludeFile "Inc_Language.pb"  ; No WinAPI
XIncludeFile "Inc_OS_Linux.pb"
XIncludeFile "Inc_Parameter.pb" ; No WinAPI
XIncludeFile "Inc_Misc.pb"      ; No WinAPI
XIncludeFile "Inc_Prefs.pb"     ; No WinAPI
XIncludeFile "Inc_Compiler.pb"  ; No WinAPI

TBLoadPreferences()

OutPath.s = PathRequester("Where shall I put the finished tar.bz2?", GetEnvironmentVariable("HOME"))
If Right(OutPath, 1) <> "/" : OutPath+"/" : EndIf

version.s = RemoveString(ReplaceString(RemoveString(PeekS(?Version1, ?Version2-?Version1, #PB_Ascii), "Version = "), " ", "_"), #CRLF$)
;Debug version
currdir.s = GetPathPart(#PB_Compiler_File)
If Right(currdir, 1) <> "/" : currdir+"/" : EndIf

;Debug PBCompilerFolder$+"pbcompiler"+#SystemExeExt : End

CreateDirectory(OutPath+"tailbite")

PBCompile(currdir+"TBManager.pb", OutPath+"tailbite/TBManager", " ", 1, "", 1)
PBCompile(currdir+"TailBite.pb", OutPath+"tailbite/TailBite", " -l", 1, "", 1)
If FileSize(OutPath+"tailbite/Catalogs")<>-2
  CreateDirectory(OutPath+"tailbite/Catalogs/")
EndIf
If FileSize(OutPath+"tailbite/Catalogs")=-2
  CopyDirectory(currdir+"Catalogs/",OutPath+"tailbite/Catalogs/","*.*",#PB_FileSystem_Force)
EndIf

CopyDirectory(currdir+"Help/English/", OutPath+"tailbite/Help/", "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)

FinalLibsDir$ = OutPath+"tailbite/Helper Libraries/"
HelperLibsSrc$ = currdir+"Addons/"
CreatePath(FinalLibsDir$)
  
;-copy the IncludeFile helper libs
If FileSize(FinalLibsDir$)<>-2
  CreateDirectory(FinalLibsDir$)
EndIf
Dir0=ExamineDirectory(#PB_Any, HelperLibsSrc$, "*.*")
If Dir0
  While NextDirectoryEntry(Dir0)
    If DirectoryEntryName(Dir0)<>"." And DirectoryEntryName(Dir0)<>".." And DirectoryEntryName(Dir0)<>".svn" And DirectoryEntryName(Dir0)<>".DS_Store";.DS_Store is OS X crapola.
      HelperLibName$ = DirectoryEntryName(Dir0)
      If FileSize(HelperLibsSrc$+HelperLibName$+"/dontcompileme")>-1
        ;CreatePath(FinalLibsDir$+HelperLibName$+"/")
        CopyFile(HelperLibsSrc$+HelperLibName$+"/"+HelperLibName$+".pb", FinalLibsDir$+HelperLibName$+".pb")
      EndIf
    EndIf
  Wend
  FinishDirectory(Dir0)
EndIf

;- ensure files are fresh. (saves remembering To copy .pb files that were updated in svn)
FinalSamplesDir$ = OutPath+"tailbite/Samples/"
CreatePath(FinalSamplesDir$+"MyDebugErrorPlugin")
CreatePath(FinalSamplesDir$+"MyPaintBoxGadget")
CreatePath(FinalSamplesDir$+"TestLibs")
CreatePath(FinalSamplesDir$+"ImageDecoderFake")
CreatePath(FinalSamplesDir$+"FakeImageEncoder")

SamplesSrc$ = currdir+"Samples/"
CopyFile(SamplesSrc$+"MyDebugErrorPlugin/MyDebugErrorPlugin.pb", FinalSamplesDir$+"MyDebugErrorPlugin/MyDebugErrorPlugin.pb")
CopyFile(SamplesSrc$+"MyPaintBoxGadget/MyPaintBoxGadget.pb", FinalSamplesDir$+"MyPaintBoxGadget/MyPaintBoxGadget.pb")
CopyFile(SamplesSrc$+"MyPaintBoxGadget/MyPaintBoxGadgetTest.pb", FinalSamplesDir$+"MyPaintBoxGadget/MyPaintBoxGadgetTest.pb")
CopyFile(SamplesSrc$+"TestLibs/sample_00.pb", FinalSamplesDir$+"TestLibs/sample_00.pb")
CopyFile(SamplesSrc$+"ImageDecoderFake/ImageDecoderFake.pb", FinalSamplesDir$+"ImageDecoderFake/ImageDecoderFake.pb")
CopyFile(SamplesSrc$+"ImageDecoderFake/TestFakeImageDecoder.pb", FinalSamplesDir$+"ImageDecoderFake/TestFakeImageDecoder.pb")
CopyFile(SamplesSrc$+"FakeImageEncoder/FakeImageEncoder.pb", FinalSamplesDir$+"FakeImageEncoder/FakeImageEncoder.pb")
CopyFile(SamplesSrc$+"FakeImageEncoder/test.pb", FinalSamplesDir$+"FakeImageEncoder/test.pb")

CopyFile(currdir+"LICENSE.TXT", OutPath+"tailbite/LICENSE.TXT")

RunProgram("tar", "cjf tailbite_"+version+".tar.bz2 tailbite/", OutPath, #PB_Program_Wait)
; IDE Options = PureBasic 4.30 (Linux - x86)
; CursorPosition = 73
; FirstLine = 40
; Folding = -
; EnableXP