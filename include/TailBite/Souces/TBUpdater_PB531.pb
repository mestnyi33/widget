EnableExplicit

;Windows
Enumeration
  #TBU
EndEnumeration
;Gadget
Enumeration
  #Text1
  #Button1
EndEnumeration

#lh = 24
#gap = 4
#WWidth = 256
#WHeight = (#lh*2)+#gap

Global hInet, hInetCon, PackedFileName$, DataBufferLength, Version$, Version1$, Version2$, Version3$, Fopened
Global NewList url.s()

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

Procedure ClearThings()
  If hInet
    InternetCloseHandle_(hInet)
  EndIf
  If hInetCon
    InternetCloseHandle_(hInetCon)
  EndIf
  If Fopened
    CloseFile(0)
  EndIf
  If FileSize(PackedFileName$)<>-1
    DeleteFile(PackedFileName$)
  EndIf
EndProcedure

Procedure TBInternetError(message$)
  Protected wError.l,*ErrorBuffer,dwError.l,ErrorBufferSize.l,*MBErrorBuffer
  
  wError = GetLastError_()
  If wError
    *ErrorBuffer = AllocateMemory(1024)
    FormatMessage_(#FORMAT_MESSAGE_FROM_SYSTEM, 0, wError, 0, *ErrorBuffer, 1024, 0)
    message$+NL$+PeekS(*ErrorBuffer)
    FreeMemory(*ErrorBuffer)
  EndIf
  If wError=#ERROR_INTERNET_EXTENDED_ERROR
    ErrorBufferSize = 2048
    *ErrorBuffer = AllocateMemory(ErrorBufferSize)
    ErrorBufferSize/2
    If InternetGetLastResponseInfo_(@dwError, *ErrorBuffer, @ErrorBufferSize)
      *MBErrorBuffer = AllocateMemory(ErrorBufferSize+1)
      WideCharToMultiByte_(#CP_ACP, 0, *ErrorBuffer, ErrorBufferSize+1, *MBErrorBuffer, ErrorBufferSize+1, 0, 0)
      message$+NL$+NL$+PeekS(*MBErrorBuffer)
      FreeMemory(*MBErrorBuffer)
    EndIf
    FreeMemory(*ErrorBuffer)
  EndIf
  ClearThings()
  MessageRequester(Language("TBUpdater","Error"), message$)
  CompilerIf #PB_Compiler_Debugger=0
    RunProgram("TBManager.exe")
  CompilerEndIf
  End
EndProcedure

Procedure GetPageFileSize()
  Protected sinf.SYSTEM_INFO
  
  GetSystemInfo_(sinf)
  DataBufferLength = sinf\dwPageSize
  If DataBufferLength<=0
    DataBufferLength = 4096
  EndIf
EndProcedure

Procedure.s GetQueryInfo(hHttpRequest, iInfoLevel)
  Protected *sBuffer,QI$
  
  *sBuffer = AllocateMemory(DataBufferLength)
  If HttpQueryInfo_(hHttpRequest, iInfoLevel, *sBuffer, @DataBufferLength, 0)=0
    TBInternetError(Language("TBUpdater","HttpQueryError"))
  EndIf
  QI$ = PeekS(*sBuffer, DataBufferLength)
  FreeMemory(*sBuffer)
  ProcedureReturn QI$
EndProcedure

Procedure PackDownload()
  Protected Bytes.l,hURL.l,ErrorMessage$,Domain$,hHttpOpenRequest.l,iretval.l,TmpDBL.l,QI.s,myMax.l,Size$,fBytes.l
  Protected TempFolder$,FirstPacket.l,DoInstall.l,*DataBuffer,WholeNewVersion$,NewVersion$,CheckV.l,OlderV.l,SameV.l
  Protected Text$,FSeeker.l,nURLs.l,i.l,nFiles.l,CurF.l,*Unpacked,FName$,Pos.l,DateCreated.l,DateAccessed.l,DateModified.l
  Protected File1.l,HLibDir$,Dir0.l,Mode.l,Size.l,FileSize.q
  
  SetGadgetText(#Text1, Language("TBUpdater","Buffer"))
  GetPageFileSize()
  SetGadgetText(#Text1, Language("TBUpdater","Connect"))
  ;hInet = InternetOpen_("TBUpdater", #INTERNET_OPEN_TYPE_DIRECT, #Null, #Null, 0)
  ;-bugfix when in firewalled mode (i.e. ABB-Proxy) ABBKlaus 18.4.2007 10:47
  hInet = InternetOpen_("TBUpdater", #INTERNET_OPEN_TYPE_PRECONFIG, #Null, #Null, 0)
  If hInet=0
    TBInternetError(Language("TBUpdater","NoConnection"))
  EndIf
  FirstElement(url())
TryURLs:
  SetGadgetText(#Text1, Language("TBUpdater","Checking")+NL$+url())
  hURL = InternetOpenUrl_(hInet, url(), #Null, 0, #INTERNET_FLAG_RELOAD, 0)
  If hURL=0
    If NextElement(url())
      Goto TryURLs
    Else
      ErrorMessage$ = Language("TBUpdater","NoUpdates")+NL$+NL$
      ForEach url():ErrorMessage$+NL$+url():Next
      TBInternetError(ErrorMessage$)
    EndIf
  EndIf
  SetGadgetText(#Text1, Language("TBUpdater","DownloadingFrom")+":"+NL$+url())
  Domain$ = RemoveString(Left(url(), FindString(url(), "/", 8)-1), "http://")
  hInetCon = InternetConnect_(hInet, Domain$, #INTERNET_DEFAULT_HTTP_PORT, #Null, #Null, #INTERNET_SERVICE_HTTP, 0, 0)
  If hInetCon=0
    TBInternetError(Language("TBUpdater","UnableError")+" "+Domain$)
  EndIf
  hHttpOpenRequest = HttpOpenRequest_(hInetCon, "HEAD", RemoveString(url(), "http://"+Domain$+"/"), "http/1.0", #Null, 0, #INTERNET_FLAG_RELOAD, 0)
  If hHttpOpenRequest=0
    TBInternetError(Language("TBUpdater","HttpOpen")+" "+Domain$+" "+Language("TBUpdater","Failed"))
  EndIf
  iretval = HttpSendRequest_(hHttpOpenRequest, #Null, 0, 0, 0)
  If iretval=0
    TBInternetError(Language("TBUpdater","HttpSend")+" "+Domain$+" "+Language("TBUpdater","Failed"))
  EndIf
  TmpDBL = DataBufferLength
  QI.s = GetQueryInfo(hHttpOpenRequest, #HTTP_QUERY_STATUS_CODE)
  DataBufferLength = TmpDBL
  If Val(Trim(QI))<>#HTTP_STATUS_OK
    TBInternetError(ReplaceString(Language("TBUpdater","StatusError"),"%error%",QI))
  EndIf
  QI = GetQueryInfo(hHttpOpenRequest, #HTTP_QUERY_CONTENT_LENGTH)
  DataBufferLength = TmpDBL
  myMax = Val(Trim(QI))
  If myMax
    Size$ = Str(myMax)+" bytes"
  Else
    Size$ = "unknown"
  EndIf
  Bytes = 0
  fBytes = 0
  SetGadgetText(#Text1, Language("TBUpdater","CheckPack"))
  ;TempFolder$ = TBFolder$
  TempFolder$ = GetTemporaryDirectory()
  If Right(TempFolder$, 1)<>"\"
    TempFolder$+"\"
  EndIf
  PackedFileName$ = TempFolder$+"TailBite.pack"
  If CreateFile(0, PackedFileName$)=0
    TBInternetError(Language("TBUpdater","TempError"))
  EndIf
  Fopened = 1
  FirstPacket = 1
  DoInstall = 1
  *DataBuffer = AllocateMemory(DataBufferLength)
  If *DataBuffer=0
    TBInternetError("Not enough memory.")
  EndIf
  Repeat
    If InternetReadFile_(hURL, *DataBuffer, DataBufferLength, @Bytes)=0:TBInternetError(Language("TBUpdater","UpdateError")):EndIf
    If FirstPacket
      WholeNewVersion$ = PeekS(*DataBuffer)
      NewVersion$ = StringField(WholeNewVersion$, 1, " ")
      If Len(Version1$)
        CheckV = 0
        OlderV = 0
        If ValF(Version1$)=ValF(NewVersion$)
          Select StringField(WholeNewVersion$, 2, " ")
            Case "Alpha"
              If Version2$="Alpha"
                CheckV = 1
              Else
                OlderV = 1
              EndIf
            Case "Beta"
              Select Version2$
                Case "Alpha"
                Case "Beta"
                  CheckV = 1
                Default
                  OlderV = 1
              EndSelect
            Case "PR"
              Select Version2$
                Case "Alpha"
                Case "Beta"
                Case "PR"
                  CheckV = 1
                Default
                  OlderV = 1
              EndSelect
            Case "FR"
              If Version2$="FR"
                CheckV = 1
              EndIf
          EndSelect
          If CheckV
            If ValF(StringField(WholeNewVersion$, 3, " "))<ValF(Version3$)
              OlderV = 1
            ElseIf ValF(StringField(WholeNewVersion$, 3, " "))=ValF(Version3$)
              SameV = 1
            EndIf
          EndIf
        ElseIf ValF(Version1$)>ValF(NewVersion$)
          OlderV = 1
        EndIf
        If OlderV
          If NextElement(url())
            CloseFile(0)
            Fopened = 0
            InternetCloseHandle_(hURL)
            hURL = 0
            Goto TryURLs
          EndIf
        EndIf
      EndIf
      If SameV
        Text$=Language("TBUpdater","SameVersion") ; same
      ElseIf OlderV
        Text$=Language("TBUpdater","OlderVersion") ; older
      Else
        Text$=Language("TBUpdater","NewVersion") ; newer
      EndIf
      Text$=ReplaceString(Text$,"%version1%",Version$)
      Text$=ReplaceString(Text$,"%version2%",WholeNewVersion$)
      If MessageRequester(Language("TBUpdater","Warning"),Text$,#PB_MessageRequester_YesNo|#MB_ICONWARNING)=6
        DoInstall = 1
      Else
        DoInstall = 0
      EndIf
      If DoInstall
        FSeeker = *DataBuffer+Len(PeekS(*DataBuffer))+1
        nURLs = Val(PeekS(FSeeker))
        For i=0 To nURLs
          FSeeker+Len(PeekS(FSeeker))+1
        Next i
        nFiles = Val(PeekS(FSeeker))
        FSeeker+Len(Str(nFiles))+1
        Bytes-(FSeeker-*DataBuffer)
      EndIf
    EndIf
    If Bytes And DoInstall
      fBytes+Bytes
      Text$=Language("TBUpdater","Downloading")
      Text$=ReplaceString(Text$,"%version%",WholeNewVersion$)
      Text$=ReplaceString(Text$,"%bytes%",Str(fBytes))
      Text$=ReplaceString(Text$,"%size%",Size$)
      SetGadgetText(#Text1,Text$)
      If FirstPacket=0
        FSeeker = *DataBuffer
      Else
        FirstPacket = 0
      EndIf
      WriteData(0, FSeeker, Bytes)
    EndIf
  Until Bytes=0 Or DoInstall=0
  CloseFile(0)
  Fopened = 0
  InternetCloseHandle_(hURL)
  hURL = 0
  InternetCloseHandle_(hInet)
  hInet = 0
  FreeMemory(*DataBuffer)
  Version1$ = NewVersion$
  If DoInstall=0
    DeleteFile(PackedFileName$)
    MessageRequester("TBUpdater",Language("TBUpdater","InstAbort"))
    CompilerIf #PB_Compiler_Debugger=0
      RunProgram("TBManager.exe")
    CompilerEndIf
    End
  EndIf
PackInstall:
  SetGadgetText(#Text1, Language("TBUpdater","Unpackfiles"))
  If OpenPack(0,PackedFileName$)=0
    TBInternetError(Language("TBUpdater","InvalidPack"))
  EndIf
  CurF = 1
  Mode=0
  Repeat
    *Unpacked = NextPackEntry(0)
    If *Unpacked
      If Mode=0
        If PeekS(*Unpacked,3,#PB_Ascii)="DIR"
          Mode=#PB_Ascii
          Size=1
        Else
          Mode=#PB_Unicode
          Size=2
        EndIf
      EndIf
      FName$ = PeekS(*Unpacked,-1,Mode)
      If FName$="DIR"
        FName$ = PeekS(*Unpacked+(4*Size),-1,Mode)
        If FileSize(TBFolder$+FName$)<>-2
          CreateDirectory(TBFolder$+FName$)
        EndIf
      Else
        Pos=(Len(FName$)+1)*Size
        DateCreated=PeekL(*Unpacked+Pos):Pos+4
        DateAccessed=PeekL(*Unpacked+Pos):Pos+4
        DateModified=PeekL(*Unpacked+Pos):Pos+4
        FileSize=PeekQ(*Unpacked+Pos):Pos+8
        Text$=Language("TBUpdater","Unpackfiles2")
        Text$=ReplaceString(Text$,"%filename%",FName$)
        Text$=ReplaceString(Text$,"%filenr%",Str(CurF))
        Text$=ReplaceString(Text$,"%maxfiles%",Str(nFiles))
        SetGadgetText(#Text1,Text$)
        Delay(100)
        If FileSize
          *Unpacked = NextPackEntry(0)
          If *Unpacked
            File1=CreateFile(#PB_Any, TBFolder$+FName$)
            If File1
              WriteData(File1, *Unpacked, PackEntrySize(0))
              CloseFile(File1)
              CurF+1
            EndIf
          EndIf
        Else
          File1=CreateFile(#PB_Any, TBFolder$+FName$)
          If File1
            CloseFile(File1)
          EndIf
          CurF+1
        EndIf
        SetFileDate(TBFolder$+FName$,#PB_Date_Created,DateCreated)
        SetFileDate(TBFolder$+FName$,#PB_Date_Accessed,DateAccessed)
        SetFileDate(TBFolder$+FName$,#PB_Date_Modified,DateModified)
      EndIf
    EndIf
  Until *Unpacked=0
  ClosePack(0)
  DeleteFile(PackedFileName$)
  If PBVersionX64
    HLibDir$ = TBFolder$+"Helper Libraries X64\"
  Else
    HLibDir$ = TBFolder$+"Helper Libraries\"
  EndIf
  ;Dir0=ExamineDirectory(#PB_Any, HLibDir$, "")
  If 0;Dir0
    While NextDirectoryEntry(Dir0)
      If DirectoryEntryType(Dir0)=#PB_DirectoryEntry_File
        LibName$ = DirectoryEntryName(Dir0)
        If LibName$
          If GetExtensionPart(LibName$)<>"res"
            If FileSize(PBFolder$+"PureLibraries\UserLibraries\"+LibName$)<>-1
              DeleteFile(PBFolder$+"PureLibraries\UserLibraries\"+LibName$)
            EndIf
            CopyFile(HLibDir$+LibName$, PBFolder$+"PureLibraries\UserLibraries\"+LibName$)
          Else
            If FileSize(PBFolder$+"Residents\"+LibName$)<>-1
              DeleteFile(PBFolder$+"Residents\"+LibName$)
            EndIf
            CopyFile(HLibDir$+LibName$, PBFolder$+"Residents\"+LibName$)
          EndIf
          ;DeleteFile(HLibDir$+LibName$)
        EndIf
      EndIf
    Wend
    FinishDirectory(Dir0)
    ;DeleteDirectory(HLibDir$, "", #PB_FileSystem_Recursive)
  EndIf
  
  Text$=Language("TBUpdater","Success")
  Text$=ReplaceString(Text$,"%maxfiles%",Str(CurF-1))
  SetGadgetText(#Text1, Text$)
  SetGadgetText(#Button1, Language("TBUpdater","Ok"))
EndProcedure

Procedure MaxValue(a, b)
  If a>b
    ProcedureReturn a
  Else
    ProcedureReturn b
  EndIf
EndProcedure

Define nURLdata.l,HttpDownloadSeeker.l,i.l,CancelText$,CancelWidth.l,TextWidth.l,EventID.l,DownloadThread.l

TBLoadPreferences()

AddElement(Process())
Process() = "TailBite"
AddElement(Process())
Process() = "TailBite Manager"
RunOne("TBUpdater")

nURLdata = Val(GetNextString(?HttpDownload, #CRLF$))
HttpDownloadSeeker = FindNextString(#CRLF$, ?HttpDownload, ?HttpDownloadEnd)+2
For i=1 To nURLdata
  AddElement(url())
  url() = GetNextString(HttpDownloadSeeker, #CRLF$)
  HttpDownloadSeeker = FindNextString(#CRLF$, HttpDownloadSeeker, ?HttpDownloadEnd)+2
Next i

;Get Version of TailBite
Version$=PeekS(?Version1,?Version2-?Version1,#PB_Ascii)
Version$=RemoveString(Trim(StringField(Version$,2,"=")),#CRLF$)
Version1$=StringField(Version$, 1, " ")
Version2$=StringField(Version$, 2, " ")
Version3$=StringField(Version$, 3, " ")

If Version1$=""
  Version1$ = "1.0"
EndIf

If PBFolder$=""
  PBFolder$ = PathRequester(Language("TBUpdater","SelectPBFolder"), "")
  If PBFolder$=""
    MessageRequester("TBUpdater", Language("TBUpdater","PBError"))
    CompilerIf #PB_Compiler_Debugger
      RunProgram("TBManager.exe")
    CompilerEndIf
    End
  EndIf
EndIf
If Right(PBFolder$, 1)<>"\"
  PBFolder$+"\"
EndIf

ProcessWindow:
CancelText$ = " "+Language("TBUpdater","Cancel")+" "
If OpenWindow(#TBU, 0, 0, #WWidth, #WHeight, "TBUpdater", #PB_Window_Invisible|#PB_Window_ScreenCentered)=0
  TBInternetError(Language("TBUpdater","WindowError"))
EndIf
If StartDrawing(WindowOutput(#TBU))
  CancelWidth = TextWidth(CancelText$)
  ForEach url()
    TextWidth = MaxValue(TextWidth(url()), TextWidth)
  Next
  StopDrawing()
EndIf
ResizeWindow(#TBU, WindowX(#TBU), WindowY(#TBU), (#gap*3)+TextWidth+CancelWidth, #WHeight)
;If CreateGadgetList(WindowID(#TBU))=0
;  TBInternetError(Language("TBUpdater","GadgetError"))
;EndIf
TextGadget(#Text1, #gap, #gap, TextWidth, #lh*2, Language("TBUpdater","Starting"))
ButtonGadget(#Button1, (#gap*2)+TextWidth, #gap, CancelWidth, #lh+#gap, CancelText$)
ResizeWindow(#TBU, (GetSystemMetrics_(#SM_CXSCREEN)-WindowWidth(#TBU))/2, WindowX(#TBU), WindowWidth(#TBU), WindowHeight(#TBU))
HideWindow(#TBU, #False)
CompilerIf #PB_Compiler_Debugger
  PackDownload()
CompilerElse
  DownloadThread = CreateThread(@PackDownload(), 0)
CompilerEndIf
Repeat
  EventID = WaitWindowEvent()
  If EventID=#PB_Event_Gadget And EventGadget()=#Button1
    If GetGadgetText(#Button1)=CancelText$
      SetGadgetText(#Text1, Language("TBUpdater","Cancel2"))
      If DownloadThread And IsThread(DownloadThread)
        KillThread(DownloadThread)
        ClearThings()
      EndIf
    EndIf
    CompilerIf #PB_Compiler_Debugger=0
      RunProgram("TBManager.exe")
    CompilerEndIf
    Quit = 1
  EndIf
Until Quit
End

DataSection
HttpDownload:
  Data$ "1"
  Data.b #CR , #LF
  Data$ "http://www.tailbite.com/downloads/TailBite.pack"
  Data.b #CR , #LF
  ;Data$ "http://www.purebasicpower.de/downloads/TailBite.pack"
  ;Data.b #CR , #LF
  ;Data$ "http://tailbite.sopapop.com/TailBite.pack"
  ;Data.b #CR , #LF
  ;Data$ "http://inicia.es/de/elchoni/TailBite/TailBite.pack"
  ;Data.b #CR , #LF
HttpDownloadEnd:
EndDataSection

; IDE Options = PureBasic 5.11 (Windows - x86)
; CursorPosition = 349
; FirstLine = 324
; Folding = e-
; EnableAdmin
; EnableOnError
; UseIcon = TB_icon_0.2.ico