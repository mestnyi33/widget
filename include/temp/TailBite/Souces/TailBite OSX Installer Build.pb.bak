;THIS WILL PROBABLY NOT RUN OUTSIDE A PB DEBUGGER ENVIRONMENT

XIncludeFile "Tailbite_Res.pb"
XIncludeFile "Inc_Language.pb"  ; No WinAPI
XIncludeFile "Inc_OS_MacOSX.pb"
XIncludeFile "Inc_Parameter.pb" ; No WinAPI
XIncludeFile "Inc_Misc.pb"      ; No WinAPI
XIncludeFile "Inc_Prefs.pb"     ; No WinAPI
XIncludeFile "Inc_Compiler.pb"  ; No WinAPI

TBLoadPreferences()

OutPath.s = PathRequester("Where shall I put the finished DMG?", GetEnvironmentVariable("HOME"))
If Right(OutPath, 1) <> "/" : OutPath+"/" : EndIf

version.s = RemoveString(ReplaceString(RemoveString(PeekS(?Version1, ?Version2-?Version1, #PB_Ascii), "Version = "), " ", "_"), #CRLF$)
;Debug version
currdir.s = GetPathPart(#PB_Compiler_File)
If Right(currdir, 1) <> "/" : currdir+"/" : EndIf

RunProgram("tar", "xjf "+#DQUOTE$+currdir+"osx-installer/TailBite.dmg.tar.bz2"+#DQUOTE$+" -C "+#DQUOTE$+OutPath+#DQUOTE$, currdir, #PB_Program_Wait)

;Debug PBCompilerFolder$+"pbcompiler"+#SystemExeExt : End

RenameFile(OutPath+"TailBite.dmg", OutPath+"TailBite_"+version+"_uncompressed.dmg")
hdiutil = RunProgram("hdiutil", "attach "+#DQUOTE$+OutPath+"TailBite_"+version+"_uncompressed.dmg"+#DQUOTE$, currdir, #PB_Program_Open|#PB_Program_Read|#PB_Program_Hide)
If hdiutil
  While ProgramRunning(hdiutil)
    If AvailableProgramOutput(hdiutil)
      ;Debug "output available"
      hdiutiloutput.s = ReadProgramString(hdiutil)
      If FindString(hdiutiloutput, "/Volumes/TailBite",0)
        discno.s = StringField(hdiutiloutput, 1, " ")
        Debug discno
        Break;out of the while loop
      EndIf
    Else
      Delay(20)
    EndIf
  Wend
  CloseProgram(hdiutil)
Else
  Debug "could not run hdiutil"
  End
EndIf

;CallDebugger

RunProgram("diskutil", "rename "+discno+" TailBite_"+version, currdir, #PB_Program_Wait)

;CallDebugger

;-start copy/compilation of files

PBCompile(currdir+"TBManager.pb", "/Volumes/TailBite_"+version+"/TailBite/TBManager.app", " ", 1, "", 1)
PBCompile(currdir+"TailBite.pb", "/Volumes/TailBite_"+version+"/TailBite/TailBite.app", " -l", 1, "", 1)
If FileSize("/Volumes/TailBite_"+version+"/TailBite/Catalogs")<>-2
  CreateDirectory("/Volumes/TailBite_"+version+"/TailBite/Catalogs/")
EndIf
If FileSize("/Volumes/TailBite_"+version+"/TailBite/Catalogs")=-2
  CopyDirectory(currdir+"Catalogs/","/Volumes/TailBite_"+version+"/TailBite/Catalogs/","*.*",#PB_FileSystem_Force)
EndIf

CopyDirectory(currdir+"Help/", "/Volumes/TailBite_"+version+"/TailBite/Help/", "", #PB_FileSystem_Recursive)
RenameFile("/Volumes/TailBite_"+version+"/TailBite", "/Volumes/TailBite_"+version+"/tailbite")
; IDE Options = PureBasic 4.51 (MacOS X - x86)
; CursorPosition = 25
; FirstLine = 16
; EnableXP