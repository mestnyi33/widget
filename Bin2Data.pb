; bin2pack_ts.pb
; Copyright (c) 2012 Thomas <ts-soft> Schulz

; Permission is hereby granted, free of charge, to any person obtaining a copy of this
; software and associated documentation files (the "Software"), to deal in the Software
; without restriction, including without limitation the rights to use, copy, modify, merge,
; publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
; whom the Software is furnished to do so, subject to the following conditions:

; The above copyright notice and this permission notice shall be included in all copies or
; substantial portions of the Software.

; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

;==================================================================
;
; Library:           Bin2Data
; Author:            Thomas <ts-soft> Schulz
; Date:              Feb 15, 2012
; Version:           1.1z
; Target OS:         All
; Target Compiler:   PureBasic 4.41 and later
;
;==================================================================

; Historie:
;
; V1.1z 2012/02/19
; version modified by Wilbert.
; - different handling of data generation
; - added control of quads per line
; - added zlib compression option
;
; V1.1, 2012/02/16
; small bugfix with drop folder or empty files
;
; V1.0, 2012/02/15
; Initial release

CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Linux
    #ZLIB_Filename = #PB_Compiler_Home + "purelibraries/linux/libraries/zlib.a"
  CompilerCase #PB_OS_MacOS
    #ZLIB_Filename = "/usr/lib/libz.dylib"
  CompilerCase #PB_OS_Windows
    #ZLIB_Filename = "zlib.lib"
CompilerEndSelect

ImportC #ZLIB_Filename
  compressBound.l(sourceLen)
  compress2(*dest, *destLen, *source, sourceLen, level)
EndImport

UsePNGImageDecoder()
UseJPEGImageDecoder()
UseFLACSoundDecoder()
UseOGGSoundDecoder()

; added 2013-04-27, Jörg Burbach - quadworks.de
UseBriefLZPacker()
UseLZMAPacker()
UseZipPacker()
; Jörg Burbach - quadworks.de

EnableExplicit

Global File.s
Global *Mem
Global SoundAllowed
If InitSound()
  SoundAllowed = #True
EndIf

Enumeration ;fonts
  #font_mono
EndEnumeration
LoadFont(#font_mono, "Courier New", 10)

Enumeration ;sound, movie
  #sndPlay
EndEnumeration

Enumeration ;image
  #imgDrop
  #imgAPP
  #imgMusic
  #imgFile
  #imgTemp
EndEnumeration
CatchImage(#imgDrop, ?droppng_start)
CatchImage(#imgMusic, ?musicpng_start)
CatchImage(#imgAPP, ?drop_small_start)

Enumeration ;windows
  #frmMain
  #frmEdit
EndEnumeration

Enumeration ;gadgets
  #frmMain_Container
  #frmMain_Image
  #frmMain_TxtFile
  #frmMain_BtnPreview
  #frmMain_BtnClipboard
  #frmMain_SpinText
  #frmMain_Spin
  #frmMain_CheckBox 
  #frmEdit_Edit
EndEnumeration

Procedure.s MakeValidName(Name.s)
  Protected tmp.s, *mtmp.Character
 
  Name = ReplaceString(Name, "ä", "ae")
  Name = ReplaceString(Name, "ö", "oe")
  Name = ReplaceString(Name, "ü", "ue")
  Name = ReplaceString(Name, "ß", "ss")
  Name = ReplaceString(Name, "Ä", "Ae")
  Name = ReplaceString(Name, "Ö", "Oe")
  Name = ReplaceString(Name, "Ü", "Ue")
 
  *mtmp = @Name
  While  *mtmp\c <> 0
    Select *mtmp\c
      Case 48 To 57, 65 To 90, 97 To 122, 95
        tmp + Chr(*mtmp\c)
      Case 32, 46
        tmp + "_"
    EndSelect
    *mtmp + SizeOf(Character)
  Wend
  While Left(tmp, 1) >= "0" And Left(tmp, 1) <= "9"
    tmp =Right(tmp, Len(tmp) - 1)
  Wend 
  ProcedureReturn tmp
EndProcedure

Procedure.s MemToData(*mem.ascii, msize, label.s, quads_per_line = 5, packed = #False)
 
  Protected.i *cmpr, *buffer, bpos, bsize, orig_size, reg_b
  Protected.b q_minus_one
  Protected.s result
 
  Protected.i *brieflz, *lzma, *zip, BriefLPackSize, LZMAPackSize, ZipPackSize, PackType ; neu, Jörg Burbach - quadworks.de
  Protected.s PackLabel
 
  EnableASM
   
  If packed
    packed = #False
    If msize
      orig_size = compressBound(msize)
      *cmpr = AllocateMemory(orig_size)
     
      If *cmpr
        If compress2(*cmpr, @orig_size, *mem, msize, 9) = 0 And orig_size < msize
          *mem = *cmpr
          Swap orig_size, msize
          packed = #True
        Else
          FreeMemory(*cmpr)
        EndIf
      EndIf
     
      ; added 2013-04-27, Jörg Burbach - quadworks.de
      ; added ZIP, LZMA and BriefLZ compression to check which one works best
     
      PackType = 0
     
      *lzma = AllocateMemory(orig_size)
      *brieflz = AllocateMemory(orig_size)
      *zip = AllocateMemory(orig_size)
     
      BriefLPackSize = CompressMemory(*mem,orig_size,*brieflz,orig_size,#PB_PackerPlugin_BriefLZ)
      LZMAPackSize = CompressMemory(*mem,orig_size,*lzma,orig_size,#PB_PackerPlugin_Lzma)
      ZipPackSize = CompressMemory(*mem,orig_size,*brieflz,orig_size,#PB_PackerPlugin_Zip)

      If BriefLPackSize < msize And BriefLPackSize < msize And BriefLPackSize > 0   ; BriefLz rocks
        msize = BriefLPackSize
        CopyMemory(*brieflz,*cmpr,msize)
        packed = #True
        PackLabel = "BriefLZ"
        PackType = #PB_PackerPlugin_BriefLZ
      ElseIf LZMAPackSize < msize And LZMAPackSize < BriefLPackSize And LZMAPackSize > 0 ; LZMA won the race
        msize = LZMAPackSize
        CopyMemory(*lzma,*cmpr,msize)
        packed = #True
        PackLabel = "LZMA"
        PackType = #PB_PackerPlugin_Lzma
      ElseIf ZipPackSize <= msize And ZipPackSize < BriefLPackSize And ZipPackSize > 0 ; ZIP has captured the flag
        msize = ZipPackSize
        CopyMemory(*zip,*cmpr,msize)
        packed = #True
        PackLabel = "ZIP"
        PackType = #PB_PackerPlugin_Zip
      ElseIf packed = #True
        PackType = 1
        PackLabel = "ZLIB"       ; ZLib is the best
      EndIf
     
      FreeMemory(*lzma)
      FreeMemory(*brieflz)
      FreeMemory(*zip)
     
      Debug "ZIP: " + Str(ZipPackSize)
      Debug "LZMA: " + Str(LZMAPackSize)     
      Debug "BriefLZ: " + Str(BriefLPackSize)
     
      ; Jörg Burbach - quadworks.de
     
    EndIf
  EndIf
 
  q_minus_one = (quads_per_line - 1) & 15
  quads_per_line = q_minus_one + 1
  bsize = msize / (quads_per_line * 8) + 2
  bsize = bsize * (quads_per_line * 18 + 12) + Len(label) * 4 + 128 ; *4, was *2 - Jörg Burbach - quadworks.de
  *buffer = AllocateMemory(bsize)
  If *mem And *buffer
    bpos = *buffer
    bpos + PokeS(bpos, "DataSection" + Chr(10), -1, #PB_Ascii)
   
    ; added 2013-04-27, Jörg Burbach - quadworks.de
    If packed
      bpos + PokeS(bpos, "  " + label + "_packtype:  Data.i " + Str(PackType)  + " ; Packed with " + PackLabel + Chr(10), -1, #PB_Ascii)
    EndIf
    ; Jörg Burbach - quadworks.de
   
    bpos + PokeS(bpos, "  " + label + "_start: " + Chr(10), -1, #PB_Ascii)
    If packed
      bpos + PokeS(bpos, "    ; compressed size : " + Str(msize) + " bytes" + Chr(10), -1, #PB_Ascii)
      bpos + PokeS(bpos, "    ; original size : " + Str(orig_size) + " bytes" + Chr(10), -1, #PB_Ascii)
    Else
      bpos + PokeS(bpos, "    ; size : " + Str(msize) + " bytes" + Chr(10), -1, #PB_Ascii)
    EndIf
   
    !movdqu xmm0, [md_xm]
    !pshufd xmm2, xmm0, 00000000b
    !pshufd xmm3, xmm0, 01010101b
    !pshufd xmm4, xmm0, 10101010b
    !pshufd xmm5, xmm0, 11111111b
    CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
      mov eax, *mem
      mov edx, bpos
      mov ecx, msize
      !shr ecx, 3
      !jz md_cont2
      !movdqu xmm6, [md_dq]
      mov reg_b, ebx
      mov bh, q_minus_one
      !xor bl, bl
      !md_loop1:
      !sub bl, 1
      !jnc md_no_newline
      !mov bl,bh
      !movdqu [edx], xmm6
      !add edx, 12
      !md_no_newline:
      !movq xmm0, [eax]
    CompilerElse
      mov rax, *mem
      mov rdx, bpos
      mov rcx, msize
      !shr rcx, 3 
      !jz md_cont2
      !mov r8, [md_dq]
      !mov r9, [md_dq + 8]
      mov reg_b, rbx
      mov bh, q_minus_one
      !xor bl, bl
      !md_loop1:
      !sub bl, 1
      !jnc md_no_newline
      !mov bl,bh
      !mov [rdx], r8
      !mov [rdx + 8], r9
      !add rdx, 12
      !md_no_newline:
      !movq xmm0, [rax]
    CompilerEndIf
    !pshuflw xmm0, xmm0, 00011011b
    !movq xmm1, xmm0
    !psrlw xmm0, 4
    !punpcklbw xmm0, xmm1
    !pshuflw xmm0, xmm0, 10110001b
    !pshufhw xmm0, xmm0, 10110001b
    !pand xmm0, xmm2
    !por xmm0, xmm3
    !movdqa xmm1, xmm0
    !pcmpgtb xmm1, xmm4
    !pand xmm1, xmm5
    !paddb xmm0, xmm1
    CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
      !movdqu [edx], xmm0
      !dec ecx
      !jz md_eol
      !and bl, bl
      !jz md_eol
      !mov word [edx + 16], ',$'
      !add edx, 18
      !jmp md_cont1
      !md_eol:
      !mov byte [edx + 16], 10
      !add edx, 17
      !md_cont1:
      !add eax, 8
      !and ecx, ecx
      !jnz md_loop1
      mov ebx, reg_b
      mov bpos, edx
      mov *mem, eax
    CompilerElse
      !movdqu [rdx], xmm0
      !dec rcx
      !jz md_eol
      !and bl, bl
      !jz md_eol
      !mov word [rdx + 16], ',$'
      !add rdx, 18
      !jmp md_cont1
      !md_eol:
      !mov byte [rdx + 16], 10
      !add rdx, 17
      !md_cont1:
      !add rax, 8
      !and rcx, rcx
      !jnz md_loop1
      mov rbx, reg_b
      mov bpos, rdx
      mov *mem, rax
    CompilerEndIf     
    !md_cont2:
   
    msize & 7
    If msize
      bpos + PokeS(bpos, "    Data.b $", -1, #PB_Ascii)
      While msize
        bpos + PokeS(bpos, RSet(Hex(*mem\a), 2, "0") + ",$", -1, #PB_Ascii)
        *mem + 1 : msize - 1 
      Wend
      bpos - 1 : PokeB(bpos - 1, 10)
    EndIf
    bpos + PokeS(bpos, "  " + label + "_end:" + Chr(10), -1, #PB_Ascii)
    PokeS(bpos, "EndDataSection" + Chr(10), -1, #PB_Ascii)
    result = PeekS(*buffer, -1, #PB_Ascii)
    FreeMemory(*buffer)
  EndIf
 
  If packed
    FreeMemory(*cmpr)
  EndIf
 
  DisableASM
  ProcedureReturn result
 
  !md_xm: dd 0x0f0f0f0f, 0x30303030, 0x39393939, 0x07070707
  !md_dq: db '    Data.q $',0,0,0,0 ; len = 12
 
EndProcedure

Procedure LoadFileInMemory()
  Protected FF, size.q
  FF = ReadFile(#PB_Any, File)
  If FF
    size = Lof(FF)
    If size
      If *Mem
        FreeMemory(*Mem)
      EndIf
      *Mem = AllocateMemory(size)
      If *Mem
        ReadData(FF, *Mem, size)
      EndIf
    EndIf
    CloseFile(FF)
  EndIf
EndProcedure

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  Procedure IsTextSelected()
    Protected cr.CHARRANGE
    SendMessage_(GadgetID(#frmEdit_Edit), #EM_EXGETSEL, 0, @cr)
    If cr\cpMin <> cr\cpMax
      ProcedureReturn #True
    EndIf
    ProcedureReturn #False
  EndProcedure
 
  Procedure frmEdit_callback(hWnd, Message, wParam, lParam)
    Select Message
      Case #WM_CONTEXTMENU
        If WindowFromPoint_(DesktopMouseY() << 32 + DesktopMouseX()) = GadgetID(#frmEdit_Edit)
          If IsTextSelected()
            DisableMenuItem(#frmEdit, 1, #False)
            DisableMenuItem(#frmEdit, 2, #False)
          Else
            DisableMenuItem(#frmEdit, 1, #True)
            DisableMenuItem(#frmEdit, 2, #True)       
          EndIf
          If GetClipboardText() <> ""
            DisableMenuItem(#frmEdit, 3, #False)
          Else
            DisableMenuItem(#frmEdit, 3, #True)
          EndIf
          DisplayPopupMenu(#frmEdit, WindowID(#frmEdit))
        EndIf
    EndSelect
    ProcedureReturn #PB_ProcessPureBasicEvents 
  EndProcedure
CompilerEndIf

Procedure ShowPreview()
  OpenWindow(#frmEdit, #PB_Ignore, #PB_Ignore, 850, 560, "Bin2Data Preview  -- working -- please wait --", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_WindowCentered, WindowID(#frmMain))
  DisableGadget(#frmMain_BtnPreview, #True)
  DisableGadget(#frmMain_BtnClipboard, #True)
  DisableWindow(#frmMain, #True)
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      SendMessage_(WindowID(#frmEdit), #WM_SETICON, 0, ImageID(#imgAPP))
      SetWindowCallback(@frmEdit_callback(), #frmEdit)
      If CreatePopupMenu(#frmEdit)
        MenuItem(1, "Cut")
        MenuItem(2, "Copy")
        MenuItem(3, "Paste")
        MenuBar()
        MenuItem(4, "Select All")
      EndIf
    CompilerCase #PB_OS_Linux
      gtk_window_set_icon_(WindowID(#frmEdit), ImageID(#imgAPP))
  CompilerEndSelect
  AddKeyboardShortcut(#frmEdit, #PB_Shortcut_Escape, 100)
  EditorGadget(#frmEdit_Edit, 5, 5, WindowWidth(#frmEdit) - 10, WindowHeight(#frmEdit) - 10, #PB_Editor_ReadOnly)
  SetGadgetFont(#frmEdit_Edit, FontID(#font_mono))
  SetGadgetText(#frmMain_TxtFile, "-- please wait --" + Chr(10) + "working")
  If *Mem
    SetGadgetText(#frmEdit_Edit, MemToData(*Mem, MemorySize(*Mem), MakeValidName(GetFilePart(file)), GetGadgetState(#frmMain_Spin), GetGadgetState(#frmMain_CheckBox)))
  EndIf
  SetWindowTitle(#frmEdit, "Bin2Data Preview")
  SetGadgetText(#frmMain_TxtFile, GetFilePart(File))
  SetGadgetAttribute(#frmEdit_Edit, #PB_Editor_ReadOnly, #False)
EndProcedure

Procedure LoadDroppedFile()
  Protected x, y, f.f
 
  SetGadgetText(#frmMain_TxtFile, "-- please wait --" + Chr(10) + "working")
  LoadFileInMemory()
  SetGadgetText(#frmMain_TxtFile, GetFilePart(File))
  Select UCase(GetExtensionPart(File))
    Case "BMP", "PNG", "JPG"
      If LoadImage(#imgTemp, File)
        x = ImageWidth(#imgTemp)
        y = ImageHeight(#imgTemp)
        If x > y
          f = y / x
          x = 132
          y = x * f
        ElseIf y > x
          f = x / y
          y = 132
          x = y * f
        Else
          x = 132
          y = 132
        EndIf
        If ResizeImage(#imgTemp, x, y)
          SetGadgetState(#frmMain_Image, 0)
          SetGadgetState(#frmMain_Image, ImageID(#imgTemp))
        EndIf
      EndIf
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Case "ICO"
        Define hICO = LoadImage_(0, File, #IMAGE_ICON, 132, 132, #LR_LOADFROMFILE | #LR_LOADTRANSPARENT)
        If hICO
          CreateImage(#imgTemp, 132, 132)
          StartDrawing(ImageOutput(#imgTemp))
          DrawingMode(#PB_2DDrawing_Transparent)
          Box(0, 0, 132, 132, GetSysColor_(#COLOR_BTNFACE))
          DrawImage(hICO, 0, 0)
          StopDrawing()
          SetGadgetState(#frmMain_Image, ImageID(#imgTemp))
          DestroyIcon_(hICO)
        EndIf
      CompilerEndIf
    Case "WAV", "WAVE", "OGG", "FLAC", "MOD", "XM", "IT"
      SetGadgetState(#frmMain_Image, ImageID(#imgMusic))
    Default
      SetGadgetState(#frmMain_Image, ImageID(#imgDrop))
  EndSelect
  If SoundAllowed
    If IsSound(#sndPlay) : FreeSound(#sndPlay) : EndIf
;     If IsModule(#sndPlay) : FreeModule(#sndPlay) : EndIf
  EndIf
  DisableGadget(#frmMain_BtnPreview, #False)
  DisableGadget(#frmMain_BtnClipboard, #False)
EndProcedure

Define playingmusic, Text.s, oldfile.s

File = ProgramParameter(0)

OpenWindow(#frmMain, #PB_Ignore, #PB_Ignore, 200, 290, "Bin2Data")
CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Windows
    SendMessage_(WindowID(#frmMain), #WM_SETICON, 0, ImageID(#imgAPP))
  CompilerCase #PB_OS_Linux
    gtk_window_set_icon_(WindowID(#frmMain), ImageID(#imgAPP))
CompilerEndSelect

ContainerGadget(#frmMain_Container, 10, 10, 180, 185, #PB_Container_Single)
ImageGadget(#frmMain_Image, 24, 10, 132, 132, ImageID(#imgDrop))
TextGadget(#frmMain_TxtFile, 10, 142, 150, 30, "- empty -", #PB_Text_Center)
CloseGadgetList()
ButtonGadget(#frmMain_BtnPreview, 10, 257, 55, 25, "Show")
DisableGadget(#frmMain_BtnPreview, #True)
ButtonGadget(#frmMain_BtnClipboard, 70, 257, 120, 25, "Copy to Clipboard")
DisableGadget(#frmMain_BtnClipboard, #True)
TextGadget(#frmMain_SpinText, 12, 204, 115, 20, "Quads per line ...")
SpinGadget(#frmMain_Spin, 135, 199, 55, 25, 1, 16, #PB_Spin_ReadOnly | #PB_Spin_Numeric)
SetGadgetState(#frmMain_Spin, 5)
CheckBoxGadget(#frmMain_CheckBox, 10, 228, 170, 20, "Try to compress data")
EnableGadgetDrop(#frmMain_Container, #PB_Drop_Files, #PB_Drag_Copy | #PB_Drag_Move)
EnableGadgetDrop(#frmMain_Image, #PB_Drop_Files, #PB_Drag_Copy | #PB_Drag_Move)

If File
  If FileSize(File) > 0
    If FileSize(File) > 200000
      Select MessageRequester("Bin2Data", "The File " + GetFilePart(File) + " is very big" + #LF$ + "are your sure?", #PB_MessageRequester_YesNo)
        Case #PB_MessageRequester_Yes
          LoadDroppedFile()
        Case #PB_MessageRequester_No
          File = ""
      EndSelect
    Else
      LoadDroppedFile()
    EndIf
  Else
    File = ""
  EndIf
EndIf

Repeat
  Select WaitWindowEvent(100)
    Case #PB_Event_CloseWindow
      If EventWindow() = #frmMain
        Break
      Else
        DisableWindow(#frmMain, #False)
        DisableGadget(#frmMain_BtnPreview, #False)
        DisableGadget(#frmMain_BtnClipboard, #False)       
        CloseWindow(EventWindow())
      EndIf
    Case #PB_Event_SizeWindow
      If EventWindow() = #frmEdit
        ResizeGadget(#frmEdit_Edit, #PB_Ignore, #PB_Ignore, WindowWidth(#frmEdit) - 10, WindowHeight(#frmEdit) - 10)
      EndIf
    Case #PB_Event_GadgetDrop
      If EventGadget() = #frmMain_Container Or EventGadget() = #frmMain_Image
        DisableGadget(#frmMain_BtnPreview, #True)
        DisableGadget(#frmMain_BtnClipboard, #True)
        oldfile = File
        File = StringField(EventDropFiles(), 1, #LF$)
       
        ; added 2013-04-27, Jörg Burbach - quadworks.de
        If FileSize(File) = -2
          MessageRequester("Directory dropped","Directory conversion is currently not supported.")
        EndIf
       
        If FileSize(File) > 200000
          Select MessageRequester("Bin2Data", "The File " + GetFilePart(File) + " is very big" + #LF$ + "are your sure?", #PB_MessageRequester_YesNo)
            Case #PB_MessageRequester_Yes
              LoadDroppedFile()
            Case #PB_MessageRequester_No
              File = oldfile
              DisableGadget(#frmMain_BtnPreview, #False)
              DisableGadget(#frmMain_BtnClipboard, #False)
          EndSelect
        ElseIf FileSize(File) > 0
          LoadDroppedFile()
        Else
          File = oldfile
          DisableGadget(#frmMain_BtnPreview, #False)
          DisableGadget(#frmMain_BtnClipboard, #False)         
        EndIf
      EndIf
    Case #PB_Event_Menu
      Select EventMenu()
        Case 100
          DisableWindow(#frmMain, #False)
          DisableGadget(#frmMain_BtnPreview, #False)
          DisableGadget(#frmMain_BtnClipboard, #False)   
          CloseWindow(#frmEdit)
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          Case 1
            SendMessage_(GadgetID(#frmEdit_Edit), #WM_CUT, 0, 0)
          Case 2
            SendMessage_(GadgetID(#frmEdit_Edit), #WM_COPY, 0, 0)
          Case 3
            SendMessage_(GadgetID(#frmEdit_Edit), #WM_PASTE, 0, 0)
          Case 4
            SendMessage_(GadgetID(#frmEdit_Edit), #EM_SETSEL, 0, -1)
        CompilerEndIf
      EndSelect
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #frmMain_BtnPreview
          If SoundAllowed
            If IsSound(#sndPlay) : FreeSound(#sndPlay) : EndIf
;             If IsModule(#sndPlay) : FreeModule(#sndPlay) : EndIf
            playingmusic = #False
          EndIf
          ShowPreview()
        Case #frmMain_BtnClipboard
          Text = ""
          SetGadgetText(#frmMain_TxtFile, "-- please wait --" + Chr(10) + "working")
          DisableGadget(#frmMain_BtnClipboard, #True)
          DisableGadget(#frmMain_BtnPreview, #True)
          If *Mem
            SetClipboardText(MemToData(*Mem, MemorySize(*Mem), MakeValidName(GetFilePart(file)), GetGadgetState(#frmMain_Spin), GetGadgetState(#frmMain_CheckBox)))
          EndIf 
          SetGadgetText(#frmMain_TxtFile, GetFilePart(File))
          DisableGadget(#frmMain_BtnPreview, #False)
          DisableGadget(#frmMain_BtnClipboard, #False) 
        Case #frmMain_Image
          If SoundAllowed
            If playingmusic
              If IsSound(#sndPlay) : FreeSound(#sndPlay) : EndIf
;               If IsModule(#sndPlay) : FreeModule(#sndPlay) : EndIf
              playingmusic = #False           
            Else
              If LoadSound(#sndPlay, file)
                PlaySound(#sndPlay, #PB_Sound_Loop)
                playingmusic = #True
;               ElseIf LoadModule(#sndPlay, file)
;                 PlayModule(#sndPlay)
;                 playingmusic = #True
              EndIf
            EndIf
          EndIf
      EndSelect
  EndSelect
ForEver

DataSection
  droppng_start:
    Data.q $0A1A0A0D474E5089,$524448490D000000,$8400000084000000,$8344510000000608,$59487009000000A7
    Data.q $0B0000130B000073,$0000189C9A000113,$6850504343694401,$20706F68736F746F,$666F727020434349
    Data.q $ADDA780000656C69,$CF461860C34ABD8E,$22E20D1142C50557,$C7171435A0E20E84,$892458D4382287F4
    Data.q $FD23E4DA2D43F353,$5D0A11784DE4E9FC,$0E208A0A83BD151C,$110E0E0E209B825E,$E19EF3A678BA0832
    Data.q $73D4AB5992DC81E5,$BA2A3562548BD0D3,$99E4933DC4FAB8ED,$B36697DFB6F98D65,$DE0FC851C51009B9
    Data.q $52AD662B8F00109F,$46C3CBEBF21EB52F,$F99F762E975EE831,$CA04F80A265F299D,$AC70401841F7D841
    Data.q $54BEDE68067102A4,$105559692D01CE20,$782808FA93A14037,$105C76C48500BFA9,$0072171DB1D680AF
    Data.q $513C2A6806BA979A,$4F676E920E58D500,$BD88337430C365E9,$EBEBD855F41EDF50,$2ADA4E32271F911B
    Data.q $F294DBBA5F74800C,$76C5FF8546ADD420,$E620042DB7B53D5C,$6FA3930FF0CB5946,$B831FB3BEFEEE215
    Data.q $7CEDACABF182D305,$58B6B2C6161570C0,$3E2E5F94B8539984,$0000C7C463A4F656,$00004D5248632000
    Data.q $000083800000257A,$0000D184000025F4,$00006CE800005F6D,$E783581B00008B3C,$4449343100007807
    Data.q $AC697DECDA785441,$E1AED6B7DE55D92D,$F5EF7EBDEFBE778C,$44280C66C20E003C,$1257E448A4511124
    Data.q $9C83140823F120A4,$7E2029180E2B1160,$90C838084206EC10,$B07624E0081DA6D8,$60C6E21E3068180C
    Data.q $5FB77719EDDA769B,$554E7B9C3BBEF9BF,$ABB5DAEF63F2B5ED,$4E76DDBA1BC3B9EE,$7B9DE7BDF6F7C7C9
    Data.q $BEB7D6FAD6AFED4E,$D471638B15548ABD,$620058E2C14E2F07,$58801638B1002C71,$1620058E2C400B1C
    Data.q $C58801638B1002C7,$71620058E2C400B1,$1C58801638B1002C,$C71620058E2C400B,$B1C58801638B1002
    Data.q $2C71620058E2C400,$8B1C58801638B100,$35C9CB07FD8BC903,$198DDAE257F6F93C,$8DFABF81DEABFEFE
    Data.q $9BCF7DD7C25A83EF,$651A583DF2FFBEF0,$F677DF7077B7EA78,$63CFE9E5714A5831,$FD3E3E95BD1D7678
    Data.q $4D3CD8272DAC7DA9,$3827AC1E0A7BECF8,$A0810553948975F5,$55812880C0293004,$5F7F7110040189C1
    Data.q $9194A8A95004C049,$C040016205540CF6,$C822728B002B2820,$80AA056A0994297A,$1696C25C208982AA
    Data.q $EBDD6B10C320A509,$604CEC0A9050028B,$1554095204FDA401,$8A94810C0AD104AA,$5442AD40933D0582
    Data.q $955416180B10AAA1,$86510FAF4C2EC500,$5250B1000BDFB92A,$B08746048242D814,$76455CD982B290A2
    Data.q $BF835DCD596819CF,$3B8803A5F57E8FF5,$D9F5FCAB7A05A871,$7600140040A9CE88,$C0037006D8016C00
    Data.q $B7108832FF7AE2EE,$F416CA7154050405,$1E88037B3CBCCF37,$82AE8102220A66A9,$0433E0073E1049F0
    Data.q $8005241E6BA2033C,$000ECF079ECA0799,$40AA1014CBE04059,$326AF426935FC7BF,$828D80500845FBE6
    Data.q $EA836FA01D680018,$155FD403FDC881B7,$867A2093E80BB444,$01BA5249F1834F80,$B241E540128032E0
    Data.q $0725E2005CA6811F,$BDAF8B2BD7540504,$96283D00ABFE5CFB,$0010041DC1917200,$00363A8520188805
    Data.q $DF0111A620AA0310,$85201A8002B7C50A,$27A00A8444A7DEA2,$927A01A7D0033C01,$EB1747DE7802AE98
    Data.q $0059E47D763F52C1,$4FDD9E490B0CC5E2,$C8E2295E6149AFCC,$80E0A0C0E0801923,$5160453E57088F07
    Data.q $6FFBA81A8F26CFF2,$0289A3603223F725,$919400A415E280AF,$002089264715000F,$D0033E0053E00D3E
    Data.q $9800AE1059E88947,$341EA7EFFA5308FA,$B0007A50EE2005D3,$EFFCE0795E1E562C,$84002620001EE440
    Data.q $FF510CBBC2D1D6B0,$7BE18E39E11C8A2E,$19BBBA829A79A064,$7F5C1983D1F25009,$D201408FA14478A3
    Data.q $80F0AFD6789A4914,$8029F1404F840E78,$4FAAE0269F44463E,$FFA98FF0A73FD641,$F6955EA200BFFF2A
    Data.q $01D2050FA463A6E9,$A5FF94A51FA2269D,$F8BF685AD8D238AA,$0D0771C500288FD1,$405107A1A890E101
    Data.q $9401254FBCDBB7AD,$C1F7FA8CA269647C,$EE285EE05121004C,$6180CC28503FE885,$4F8032FF17E9197C
    Data.q $97408A7840C7C7FA,$CD23EB1A0F15D93C,$842080095FB57FCC,$AA06F4E5F65CDEAC,$0C00AE63617B76E9
    Data.q $F7C35DF23DF7A56D,$83509E6340CE6568,$A210F6822807F1C0,$7C6A9805485BA906,$CC41548235DCB351
    Data.q $01478311A885EDEE,$A3510E520045CF21,$EA8300D79E145F0E,$1584FCD5BDFEC1CF,$639E889CE8032886
    Data.q $EA240650250BBFE5,$830E38AE3D1F07F4,$E8804F8005FC00A7,$7A5122C1AA52BE0B,$82ED080F25E3FCAA
    Data.q $7EDF91F127F2F761,$6EFDA4C14FD69635,$4FD0223E51A5A57A,$851283056AFE79A4,$8BAA0BFC93966DAA
    Data.q $C8A14503B9EA4432,$002330252C586E2D,$509DB9E8AF040F48,$D63560FC1E990216,$A1540738E44F1E09
    Data.q $7140DDF0EE3EA14C,$3DFAD2BC4E221888,$98671546740626B0,$40C249BDF4A19BE5,$22E0021405AA8632
    Data.q $0023E0013E004B80,$078AE8029F408AFE,$2D4856ADC5AFFA8B,$A5141FF63B354840,$A4B109C924534920
    Data.q $7CEF53C29FABBD8A,$AA43927029F1F20D,$BF0F9EF4444F3916,$4C87B922D8FFFBED,$13FD5EFC8EA4E206
    Data.q $000A805483C9DC10,$7CF25840EEC93881,$FB8752A8F8154431,$62B16E3148509D26,$2904C068AE3EA1AE
    Data.q $D580213AA1A14881,$D02D2A41A56EA0C9,$B96FE15D06920035,$FF1F475291E2A37F,$04C08002AA088957
    Data.q $BE93177AAA5DE906,$00AC180AADDF195C,$14F402AE45EE2162,$F3841D6FC0117E88,$8F0FF0DF0FE2024D
    Data.q $75F4FF0F72E6F27C,$47E23FEEBC0FC2EF,$983A60660F07F87E,$D77C9F0A7CAF760A,$EFDAACA3AC1D228F
    Data.q $7B0E935E007A998F,$A38106620FB9693F,$DC4A2031AEBFC94B,$058D6EF8CAD65382,$88056A855102FE2A
    Data.q $57D4B4FEB0A05540,$B8768002072E8FB5,$0E320E6166D3F344,$3697604DCFA24282,$9449DB040264AEA8
    Data.q $364E9AF35425E1B4,$26AA1710AD407F8D,$BB4AAA566044A005,$CCF568F6FE379661,$DC2ECD55EF32ACC5
    Data.q $E8C447C218E82016,$7C35FBEFB3E32D2F,$D3F42ACC9883E364,$FE1BF67097FB3B1C,$E1836BEF96FE1E31
    Data.q $7C863F1DEA7853C2,$D2C0A2EAE9121D7D,$C7DEFE6F83E07B30,$5988EFB4E39C1F39,$C2E2FBBD7DA97F1D
    Data.q $6C08B45EF9E44C6B,$FBA1CE1986626C40,$A851202AA162205E,$75AAE0E9D6381E94,$44A846A26808F002
    Data.q $E4C08D1788AC51C0,$7C76D61BC22894E3,$A428EA403C8B6108,$A07041CDFE6AFA71,$7DA4C09CC188F9FD
    Data.q $92D902937B10F924,$B543C31835E9F2C1,$9F577550871E2F2A,$3EFF4F4B887C987F,$8B0A6ACA10FD9F26
    Data.q $7F69056A157CFD02,$F349AF08994FFBB9,$4B7677CA58577FA5,$0C60631861B01662,$89C1864198619883
    Data.q $0B87501F9AC6AE69,$03096663576BC1D0,$8B45E8A14483C636,$10A2200E548F3FEF,$9A0F10834EB500A9
    Data.q $C251137ABFD967F0,$A3EA77E1A323B1DA,$6BD062D002D69D5D,$368E83A900D63D2B,$8126C198880029C4
    Data.q $26B6B621B24806C9,$0D73599DAC3DC748,$95221DEC95EB7B34,$9202D0F733863BE4,$1F554B568F531CCC
    Data.q $60BB95BD64F7A224,$D31C541F18EFBCD2,$A2CA0AD6028022B6,$8662022AEB004082,$D830C61998681C49
    Data.q $9F7FE5C121881F7F,$2BC81695B132EBEF,$2064C81100105198,$56A54ABEB828C055,$783C42D410D2114A
    Data.q $412C11E04F004AD4,$9661A864087808D7,$D7330E6399C4259E,$724E0437CFF6DCA8,$EC6ED70CA2047C98
    Data.q $E7AAE6CAC236B861,$AF25FB63BA990054,$0ED785F168F3A832,$63635A3670D78387,$90BE3006C09212A2
    Data.q $84568AEE44F45D6F,$CB28B2B282B5B0D6,$29246664B11D620A,$220312606C30C403,$D09B54DCC2461B02
    Data.q $63A53658A4531628,$602913711B48756B,$7CFFDC47F7D84A1C,$A45DC74B6A045B5B,$23D2D8858A858A82
    Data.q $E451412E2DFBFA2B,$C0888C110A1AF2EA,$554637A486690294,$3157A7CB0CC5FB02,$631B70A8E3610F18
    Data.q $096BE552A5785EC3,$1F349A6F1F393BC9,$E27E876E46489912,$E601C81D170066AE,$A811176E5C93E740
    Data.q $20AF4ACC5301E008,$C8109C189828A85A,$9098811306138603,$FBC4B1669707C624,$4C06C410DEB0E21E
    Data.q $57660D75AA0F75EA,$A22457D5BEBF8831,$B79CAD582B60BFCE,$F240758B45770A42,$7749111A1F7EA569
    Data.q $631FD647D670120E,$B5DEAC52F4026B7B,$04410245434B3481,$98C9954201897D6C,$3FDE700FD1F24F1F
    Data.q $74C7C80E3EC2E44B,$9DB94F84E5F01B40,$86C0FEB1FD679606,$48A179586AD785C3,$E14597657758706A
    Data.q $B0C03AD6545566E4,$55772617F35C288B,$A3EA95B18C720C26,$9157DF511571D20A,$64008C23D6A97A40
    Data.q $7D2EB3B89A303600,$F51502230A040A88,$B5056C42C442C611,$11FDE43D360DA436,$2C658DC31D78BF9E
    Data.q $2A35980399832FAD,$AAA14211525E4464,$82F3D9056FA448DF,$0A0D7843BED5AC6A,$2709039269795C4E
    Data.q $3B2651A8760DE5E6,$A84CAA2931CD7E35,$51166985000D35C3,$620B70347C4E12EB,$A91C45FC75550B2B
    Data.q $65C91C137DEE22B4,$D4323B91C8603306,$95D2087AA8A57BE4,$994A4F208B5EDF7F,$B3E72EC305D5DE40
    Data.q $3880222A73D9592B,$D2E9714E207AC985,$20F2D1833F9CAC35,$828450642A5DF5B4,$48AA1018771008DB
    Data.q $92B9FF4924BAF64C,$C4E2412D880A4FDE,$D286576B8253AD33,$B55E32203660CC09,$8514245E786BDF73
    Data.q $5DDBCB687B26B3D2,$CD4D028A0D241EC2,$A926813C9C261926,$8A8C2FC3DC3E04E3,$0959451585AC29FB
    Data.q $E28FF88894D2EB0A,$F079301807218A22,$C87B0573D94DEF44,$9C04A601890AF982,$B260A56601F348E4
    Data.q $15F7E85DDCF5625F,$FEA6EB6D53F02A90,$F840125FF6483835,$E6327AF08877F78C,$89C2F3D54E4B0011
    Data.q $F6106B376F89506F,$895DC9841104785C,$B8C64F7FBBC75F20,$DD4F9752E7C6CD3C,$D24C58D6635B73EB
    Data.q $FA3440FCEA35DDB9,$16DF51FA7518018D,$6A44830171D8E171,$10BD622475434BF1,$D13D6042D8588806
    Data.q $3307D81C31BF99AC,$B2965371C86EB881,$1BD64324A03024E7,$7CB14F260F6B6B63,$0EBB96C29E79056A
    Data.q $DC450CBDCABD1D9C,$CE32F68108044BE3,$A87D656EFE18975E,$A9B17835EEB56596,$C848DC4ED5FDF3D1
    Data.q $0DB69E7D940120A4,$F9B881CF4DB55067,$AD7B00241E21575A,$4156E1E0F1D9FC81,$A5F546358C99407F
    Data.q $1EAB7A135DB5FD5D,$A135501A5D4BA947,$B042EE206A9F520A,$56C088AE09A8175E,$01D5DEDFFF113AAE
    Data.q $348669A4134E0366,$5F5E31D7F3E2E21D,$AD014B24806960C6,$FEC2168AEDA2C89A,$1F7865514BF42AFD
    Data.q $F24C4EBFD33177C0,$5758B5EE903CCC4D,$FAD09FDC50523E02,$8AD6566EBA638DE7,$220CDD456E2D46A5
    Data.q $FDC6599DE44F5A90,$F2440F0F74B68223,$C6B1A8D368BAA157,$6ABABA2B176EA987,$2401F71535E08FB1
    Data.q $33DC3E571D89719C,$745B8122AA81F9E0,$47DE041E4357C4D5,$80C84289053DC4E1,$45CCF0BE0D560F4C
    Data.q $CC08DAF18D3F9C6C,$0C0BA895C0F3A41C,$099821C38BF8F989,$41F58A4EEC333B5B,$78366EFE0B11FB2F
    Data.q $4F6B09B43361F000,$E9DCDC51B9B41D02,$12B8DE4945CDBA4A,$3769746D6ABD1140,$DAC2A2963D3DBCA8
    Data.q $5FD995922969B27A,$BEFD5DE50C5CAEF5,$D5AA3C16F01FFD99,$C53432B523B5E8C9,$C1107BA5B444EFFC
    Data.q $222DF7B8B00C0555,$A63ED2486711ED21,$3B9FAC5D9D8DC133,$6DA977D7158D958D,$1D6EA3E136914A00
    Data.q $42016DF9E973415D,$BC131BF5C62F68E5,$BF3B9D9FFCBC9FEA,$181248EFD8957DFE,$45B46B4F33880932
    Data.q $6A435D0887A83573,$09527F03BDDA8DB7,$3B39E48D8A21011A,$2ABB84DF04855DA1,$C6AEE3F3E2C63435
    Data.q $6D200D02F4E26EC6,$2A2D54DC548D8FBA,$95E03106FC455D3E,$D454A36FD2D12EBD,$012F5EEBB2B51368
    Data.q $1DADAD886F691C9B,$CBC606CCED609250,$BC47CC6744ADAF23,$9946A5095355A9BA,$F2F9101F30EA45BD
    Data.q $F3BFEBF4417CD1DA,$8515ECB386BDCFDB,$66900D930E792465,$8E3927AC281B103D,$AA950155202D8B09
    Data.q $274BE4261B89E3A9,$CE4A0C1E023A8D55,$F1AB40D08DC072A3,$8C0F500D0AB84651,$98663460982973D6
    Data.q $0B2E0A544B48BDE1,$2744325751474B82,$EEAE274D4213CC8A,$26D66CAD6C8AD47B,$B3487A4A15FD721B
    Data.q $4BCB0612F17C2E3E,$1902F41C310D2C18,$72177901D44DD76D,$402DBF7E41466CB5,$0543E55571E1C3A4
    Data.q $0C6A04990211A6CC,$0A6BC83ED5542B44,$F4D81EE603250CA4,$16033C98FB4DE491,$C90FA8B00652A0A9
    Data.q $2025130BD681FF2D,$1FAFD58810BAAF22,$A75AC17123928779,$67069DACD2A5888D,$3AB5FD0A208D2214
    Data.q $C5069742090FB5E8,$DE6BE8D0D03A7D47,$1CAFA89F877F2D7B,$C393182A2EAF7FD8,$8BD9E67865107DE4
    Data.q $69057D79632DAF18,$03B396D0E8181C6A,$4D3CFA29416677BA,$E98F421103BE549A,$1311992894EAAA98
    Data.q $9DCAD80B13494E40,$49B01B0444AE436D,$EC0BE9C493409CC1,$EFB4E0E528659D43,$EAF7E782B9AE2974
    Data.q $448007D70B62027A,$B405F4D689428A24,$A78E847BEF92D925,$9EC644F624347B36,$AA2FA5B50F228D2E
    Data.q $2DA0E8EA9A178AA3,$34891BF52AFB82CF,$48271088B6B4A80C,$B826F7F610C83ED2,$EA7097568C39E572
    Data.q $D61C4D2E948869EC,$91CD11ACCD4ED227,$913819499DE83B98,$864AF8C6A5075198,$880BDABB9BF268C1
    Data.q $5E8CF67D33C29014,$93C49B0326B8C9D8,$0C933E7D4841A73A,$527D1A5097E4B649,$0955A0CEC4252B01
    Data.q $EBC1BF75C4DA8918,$E05196EDA354B501,$E3C02D1A50D2DA20,$A620A7A22DD10E4F,$CC6AC8E0D551354C
    Data.q $C3EB248265D214BA,$3945037ABB5C7D24,$96CDF9ECE1986F43,$799FE75C93828C8B,$9B5927501EAC898D
    Data.q $32971D042336E902,$6F333CD6522827BC,$B1C7838A8351CA7E,$10FB413F909490FE,$DF7685C6402AC6E1
    Data.q $E84C00C3606451C8,$0066241850AB585D,$AD005499FBB115CA,$43E72096D60CD520,$2047D701BD68EAF4
    Data.q $31451F5A4488F989,$4122E5CE91547C57,$5FFBF75C5B0A7521,$1917EB5A29820488,$BB9F678E70007CD2
    Data.q $A9C25B5E3067AC84,$813B260ACB281B33,$DD02028E44DBB54D,$CE7027100C385C56,$2A135ED6DE451206
    Data.q $6A5F27AE47327782,$8E9A84C183472FA9,$FEB4E04AE7679326,$4B6355544B5415BC,$B9A4DE6C75AC1103
    Data.q $156A1999517E30E3,$205ECE403E705AD6,$D92174B602DCD10A,$B2EB479C080702CE,$A01C0B468B431A55
    Data.q $A53E245CD2771710,$719970508B595448,$33C22AA806C9219A,$E7538A7EF20CFD7F,$B04A28A01FDFA34E
    Data.q $7B9A5C40336E0F49,$EF65A6A973C56CE2,$718136E2943699F8,$47C6A0114714C26B,$210A4E14DEC6820C
    Data.q $B926F9143E7A8C06,$C31E275ACB7AAE79,$8F9D7CF6442D7AF9,$D669015542110800,$573E5EEF5FD4E183
    Data.q $DB55D66F51851A82,$12AA405B502AC294,$84FF6D20BBDE16D6,$4ED39DB595DEF848,$2002806B7AD06F0D
    Data.q $26F601F261CD2483,$3C213812FE7F9E25,$AAAD85AD6107B2FC,$073B1252F87C0808,$28B13B6D49022D97
    Data.q $02ADCA3B5CE830F0,$CC6C1D755E6D8F42,$D0951A5B19182A91,$D514069C04CF0247,$861A8B416AEFF5F0
    Data.q $450C8F6F5A65391F,$A144D20A7AAD62A5,$7EEB652EAAB31B76,$24930A5301228187,$43E9263CE045ACBE
    Data.q $7C5EAA239D448B52,$58014883396E09A9,$7EFAA54AF507911B,$D20C617D75494F88,$70F6375B1C98006C
    Data.q $BD97825EF216FAFD,$1A2D1FB7BFB1ABE2,$95A68DD43A40B645,$53448DD9951AD923,$0045F4838791FCCB
    Data.q $1D525DB51BCAC504,$571C51A880C5396B,$73AD3D8B577EF3D3,$2D363D76AF397343,$A0EEB8A90524459F
    Data.q $5FC0FA9CA282A3EC,$0A5F738604E60C6F,$300891656B78471A,$B392D6E63399247D,$429AB612AB408203
    Data.q $93003FE795B002AB,$F3E2E0C5610F9241,$C636BCB1F62B3157,$11CF6764C79FF77D,$DB52DBC42D458D6C
    Data.q $8B3B50A6A90B1060,$912DFFF22844D010,$1E548477B53AE30E,$B962937FAD6A7E67,$BAFE4A1F0BDBCABE
    Data.q $96377B7137C3E197,$850F4531D10B15C6,$A3FBFD48C2AAD793,$19B5760B7D771FEE,$AB5AEB9C089571B1
    Data.q $536D7A9BF3DD950A,$B482F4E319019019,$020FEDF18503660F,$57F7A1B26059412B,$A74C1B3050EF5E56
    Data.q $29CA288BF67B9E05,$D846978C5EE47E1E,$749CBADD721B4C9F,$32029CDFEF060EDE,$C2A145EDE323C03D
    Data.q $75C2012DC61E8DBA,$923C0079D0851B7E,$8709A1F4DAD559C9,$409B52A25440AFAD,$9A3B6F451D1252B5
    Data.q $3D96CF34B448F7BD,$0360CF35C04DDD15,$D502A57DDEB43128,$756F1DD4A19B320A,$EB9D4F86D7298D73
    Data.q $A565D763E690C939,$DCFF3EC4AF20F1C4,$EDF2DF1D73B7B0E7,$D9A28A28B2AA84DF,$E72F3257DED44C8C
    Data.q $3E8927E71356C08B,$1074E8CFE391FC47,$0B442A64E21D69DC,$56637113AE6EAADB,$CDB620836EC4ED69
    Data.q $15D44F8BBA469C51,$BC07DD17C0DD1B6B,$BBA932DBB1EB7199,$D6D4515EA1EFA1AB,$03CDDD52C2574FBE
    Data.q $4551721447C8812B,$9EC5A80262AA19AA,$891884EAFAC422FD,$99C7D9BE856D61C9,$123CA0DA5546EE47
    Data.q $06C38F76EBC0D5A8,$D8655487DD881102,$7218E629A86ADA5F,$1A8CA9E28BD5BABB,$BDF33548E7C64154
    Data.q $A89A3A837514BAC2,$24FD0860BBAABB11,$2AFAACAE6B24523A,$0D463254736C8897,$3A11857C81756D21
    Data.q $DC6C2E537C8E1163,$6CF7C2D174D84BF5,$EEFC488306042A18,$A315177BEE554131,$3211D6A0F4939B0A
    Data.q $FA1AD85AEAB8279D,$8A6C7EC57670653F,$EAEB852EA3D6DA55,$088BCC72101F6E43,$E6D3B3D76A5B9BC4
    Data.q $A28C736E440EBDEA,$44D351B4B62CD5BD,$A775D493E045786C,$B9D4D175511B4FCF,$DEDA8B7ED14D84B5
    Data.q $DC995B74E9859D4E,$C7512467D366AE8E,$A223FB12C797DD8C,$88C65577488079F7,$AAD5D1EFCA91C4D7
    Data.q $C52DFF5EE8FB5484,$79B273B6DDA003D5,$40E38CA48EF4C9FC,$D45479B7B6AF0355,$74A69710B5BAC59E
    Data.q $F35B0F875B514080,$36228F4C4C7636A3,$0114E43A891789F5,$466A21C0EC54E5A6,$F7488068D53FD349
    Data.q $74856F6F326887B4,$C2D234DC28C123FA,$A6A90A41496EEF4E,$1DCC6A403775B36E,$433BF34C5ACE7C34
    Data.q $3B2DC3E3D6FC315A,$55B92C0E6787FCA6,$5DD5601E9FBF047E,$B7696C9AFBF5AE15,$36E1736F99734BEB
    Data.q $432E62A85F2BA2A9,$9DADAB23B8DCE6EF,$F7E18891A475FED8,$B5082F1ADD3D8440,$2FF8766DF7AB02D2
    Data.q $9A1D53855CB8BB45,$944A06610EE229FA,$440F09CCB023482D,$8631C65289DA3873,$02DED59C9EF7E6FE
    Data.q $3AF8A463A61CCD75,$7886094E74F9D422,$0DDDD1536411F4A7,$6B9DA1BE1D33891D,$F5F92DEA2293BB5D
    Data.q $22CF7C2733DB556F,$00BA00A287BABDE4,$C7A2DA30BDA2C1F0,$FBD1A37DA815E1D4,$479D1EEB56C532ED
    Data.q $4CF7F9B59D30CBFD,$F519B77B61595984,$8CE7C7108F2735F0,$62726FDFDD6F9366,$53416F47DE73096D
    Data.q $1B27527973B4B047,$E3A73FD0E20015D4,$EC4049EF1C23B737,$695423666F689055,$6E02692C7D7288D4
    Data.q $2D8582684786B900,$E8850FD8EAE51A7C,$000235B487B368DF,$73C1E87B2B614B6D,$37E0F007AB55C073
    Data.q $02AAD0AA46C886A1,$A7F1E3BC12CF2133,$DF630683FF9FDAF1,$98409DD0B5272BF3,$8A896864A8842BAA
    Data.q $7C692AFF31168E8C,$7AAB94D2E29ADAB0,$1F2D4CC95FDE4102,$AAF23043EA5A1101,$1D9ED04166981EC6
    Data.q $928673BF14025A12,$37821272BA87F16D,$AE7DDEAA37CB6ADE,$13E2C3A24C688F7E,$1A1D0B6ABB030F41
    Data.q $CE7E0711416AB6CF,$7F7FEDBC33F41844,$0E55B9EF0BF63F0C,$BB35399719560271,$E5BEFF8855460957
    Data.q $BEDA9CAD5B94EC85,$AF0530E0AC32284C,$8E57098460F45D15,$2A2B674E9AAF93CE,$ED22C54DD367BB6B
    Data.q $AAAE7378AA35DBF7,$2308EC24AB7EF234,$53A764DB58691274,$7279D66EA2D6B469,$7A3F3BEB78E51E3B
    Data.q $83818E21C3986053,$D5E7121C41D85DF8,$042850612C0B24F2,$A1739A2B9DBD3791,$5379A3865B78CF1D
    Data.q $E9507B4688C6E655,$DECED5F860D2B78E,$EAFEC5A25B9D550C,$0AD214088E7BB3B0,$FDD0266D440719D0
    Data.q $A2EE8E755CF3B17C,$4DB43036D52C2B07,$A4C1F7B7D7155454,$4F9BF8DE0AECF7B8,$ECB76F8FE97E27E0
    Data.q $211AFD6B56B1063C,$55CBDAD1CF646844,$EB6F6198B28AD84B,$9A43D7B48FBCD21A,$3B0245BE553D47BB
    Data.q $96C14C38B4DDBB61,$DDAEA115739B804E,$8FBFAA34E0E19035,$F406D55B979441F9,$E6FF75D1B1D428A0
    Data.q $5CC782443A438DE1,$822648EB26D5CE88,$7EC30CC9DD817EC9,$21EA89152B0B550A,$65F74AC21143BB48
    Data.q $0766921C5A90847D,$5097CBED821DE051,$A9C126C0DE83F6CE,$9DAC75D6DEC01F7B,$4B80D9A978FE8F3D
    Data.q $70C1CB482279F7E4,$6D89BF16A097473B,$EDA0D4A21251DA73,$1E5B62836939A445,$950F1674ED464D3A
    Data.q $68E16BB796723483,$46AFCE76CF5440C8,$486946ABCF1B412C,$1855594337BDB044,$4482D604D2F453F6
    Data.q $7101C9E83CE90E88,$910D65B09514AB0C,$9868303ADEF6ED6C,$B58E59A451104917,$49849E27DCF1E7B3
    Data.q $49261F5ED230C012,$C55FAEF632FD73B0,$8011E07A9C69E6F2,$93C4FD9E0EEEE980,$07F5914B261CB348
    Data.q $33306386C8860DE8,$3B6B10312600DEB2,$2B5889899E474815,$5DAB4D0DA74B440A,$E6610D490F016147
    Data.q $AFC5EA988350E603,$791CFD36D98971A7,$8501956ED5A046ED,$40BF64C0A4DEC558,$2A40D4F206185959
    Data.q $11EA34F226565B0B,$C22944A54976E8E1,$9D9BD537A2713DFF,$D248322049EDEA84,$31E37A29A4C28014
    Data.q $AF2C6386F425C37A,$E2FD7017F3D6C29F,$8DDDCED639649117,$2FB60ACAE18468DE,$F1FDC08DBB6E825F
    Data.q $AC41EC9B30493812,$20F7F3F581B6BC60,$297A6922E6FC8C1F,$70E9110F5BCBCEC4,$A7BB50D4AD21E689
    Data.q $B9DA43CC7A79F730,$255A5A9C75F7235D,$B44A12EA4134700C,$8A4412B366111FD3,$052F4185451412AA
    Data.q $D27C256542B2A2A9,$ABC18B75D27B70A8,$283DAB253BA3396F,$6CEE98965B139FD4,$A738F7738D8B2A43
    Data.q $39F33F2E2D641435,$EF232F1FD197970C,$6CC508E9CD73BD0F,$3E6795C5EFE7B386,$FB0CC5B0AB9DED8F
    Data.q $AF1823E0F3385BDB,$CC5154176E56C3AD,$865EAFB60AF57BB0,$904DDBBD9FAC5349,$19B2AB608FEF2061
    Data.q $52BD440AC05263CF,$F7501F807A317BE8,$6B5B2398E5C9CF83,$54F7E686F1DB9210,$A2944D9EE34180E6
    Data.q $0313C8AC4143B59C,$9BD519E4233C8A36,$6E0F740FF2F5C98A,$6B426FCF31E8438E,$874F5A416A1A4FB3
    Data.q $CD2E02CDEB9227F1,$DD492610E1BD0110,$0DE82693F51FAC53,$2EB619AAA8322086,$7AA144B5183A425F
    Data.q $82BCBFA3EFDA5034,$EB7762D6B01BEDBD,$04BC7F455FAF761A,$3E970D7EBBD8A593,$960000EEEFEC59FF
    Data.q $1976B9D8AA014F37,$9F4E561EF3489552,$FE5C0DC6E4C58885,$ED28697237A2CFEB,$4373D7B4824C61F5
    Data.q $A66982AAB61492CD,$4A2A89623C0E7EFB,$5546036A15F31A4F,$B49B45B30752080F,$7A0C7DF5EAE6BCD6
    Data.q $0A7EA582B5A76E6E,$A2D562781FA514D1,$A2016CAEE2B74B14,$9DDADB755843863A,$2AEE6DAA5A34EAD4
    Data.q $0602DF072BE047DE,$800D38DE58249C04,$22D400A2D8539651,$61DC715A5831F5ED,$3F8BC402DED9315B
    Data.q $E7A8EA0DD4701D62,$7DD31412F80C2219,$F67D5C337B1458A8,$82BCB862A8CD2E0B,$D986049248D3CD95
    Data.q $D9077774C7D9289D,$2EB60501CD348060,$1C37A331D8A6EF3E,$B06A700ACD505541,$AE9791A37A1779B2
    Data.q $8702DF31A4029DB5,$75C4C0788AB691A5,$8F410251BB437D98,$8431229DDAD8AB11,$D348CD86D2CA10D4
    Data.q $54330D90AAAA8169,$C5B7A8A6D28A6555,$C72912B6E0DA44DF,$386EDFFF33E6E63E,$20520D60D1613FA8
    Data.q $98674D5186C1F5ED,$D87B7B145500F64D,$BA62AED77B197ABD,$076766FE965B0BB7,$C4799C21B3F642AF
    Data.q $63EF2C87BCB39639,$ADECB95F6C35DAF7,$4E06F691CF248AF7,$764C0424DF89345F,$183641A930A2A1B6
    Data.q $C0B2D83366A9D784,$B6F63ED9CA06DAD2,$F5EEC19FF3F170B6,$4BCE072734D80EAB,$02DB8DCDA9965D17
    Data.q $932DA11D63A03C88,$4BDEB39322728037,$CEC158853DB1B825,$D6157A1959B314EE,$D8629E418565145A
    Data.q $EE8DBD533EA0C14B,$77A3D8653B44A2E6,$518C5073A31FAB7F,$1AA1A47893B8D39F,$5374B614BDB80186
    Data.q $E1BBBBFB14E9CAE2,$9CB9FC87366926DD,$04BE5C6E12E57DBF,$8060F9196970C115,$8264D980942AF2E1
    Data.q $F5AD409A4C1EDED9,$1BEDFD8955B0B2C0,$5142347F41D9DFD8,$CBC7F415FAEF61ED,$0AF2C1967DC8511D
    Data.q $E5142DF5E51F5EB2,$FA87B20CF33EAE3E,$BF158D1117EA5930,$CE910736812A68F3,$364F8E3C5936D390
    Data.q $5B009C0CDEC6E2A9,$4FD4619DD9D86637,$15B4A2594519CBD1,$A5B58A41A304BD06,$7EEFE3FBBDBFE4DE
    Data.q $370C801CFD3E1FFB,$71A3A8DE9B857B79,$EE74D401DDA34353,$A8A8E57554386FC8,$A7A687E30FBFB945
    Data.q $2C87AF5905543EBD,$FA1F8A80674C51CF,$7188865147EBDD65,$D620B6B64C45F2E3,$91E7F3F58AB2B862
    Data.q $0AAA415A07DFB9A4,$2E1F9554822E24C6,$85BDB7B04FED982A,$3ECB4BFBE80228AA,$3791B36975FBF9E2
    Data.q $D7BB156FBC31F5EB,$8274C50B637261AF,$FC16C76A6614B25E,$D8F3FC61EA83D7F6,$EF2EB47A127C1574
    Data.q $97EFEC06E8504A66,$CFD0F4AFAC0B4E98,$06271A46E9555453,$1BF66CA5D58641A3,$3F9BFD795FF1F7BF
    Data.q $A59DD6ECAE17EBF8,$175A54863D8400DB,$08B386E6EDDA3409,$DEA5AD3F468CFD58,$08A862BABECAA901
    Data.q $9005087F5908C1F2,$53FB661EF348470F,$29BCDC0C1BD16548,$02B35435AD42D2EB,$BBD8B2B61FB9EEA7
    Data.q $993662AE573B157A,$133E9F2C79DCFD60,$84AF7E2AB27AC1D6,$EB7D8165B1694DC2,$3ADAE84604AE0EBC
    Data.q $0E03888A5BE6E5EE,$229D394595234B91,$A8AF48EDEEDD0FEB,$EB26446A44974153,$73A7A15B9BE2A154
    Data.q $C59554152EA825CC,$0CC8078CAC131BA5,$EB0C834B0CFECAE3,$848A66CC03187D4B,$BE9B28EAC13C8319
    Data.q $FADF47B5FC9F77ED,$2003BBB2B85D37A1,$AA898CDE8B09BB85,$6F0C1BD1F1F58805,$3D5757F78E7CCEEC
    Data.q $EAFEC4B999B58803,$46207EF1EAFDDBF6,$80A4930249C0CC55,$5AAD7137B6792BBA,$FAD8A41D3E9CAC22
    Data.q $F68C634BFB117751,$FF5C132628CCC056,$ADAF18468DE873E2,$E98AB2B8611E3FA3,$54103D4295BBAEDE
    Data.q $D3EA9A5DBAA3AF6A,$1B32B536BB803415,$3AED7BB0ACB60130,$8441E55C4984B2AA,$E0DA22D70E545110
    Data.q $BA47D417CF00ADF0,$F85A6F20E79D0A00,$1499302D37B16945,$E71B582B10E61E58,$69E05CE56C0967E8
    Data.q $FA74BDC62965E842,$B6FF3FADEC7C77E6,$8036DEDAF17CDE27,$6B689F2F53A4C01C,$3CBFD6F53F100B78
    Data.q $77C2EFEBEF7F1012,$208E7B71A472E37C,$6141AC1FA9035E7E,$02E175B02B3963AE,$25A5830554099366
    Data.q $E67C2E310C01FD64,$38A69240DF6C98D3,$ECDEC78FE843E0F3,$4292490455B3B4DC,$825A5C31CF34856D
    Data.q $0CEA3EA2A93B9554,$73F1DDDB310D1FD0,$CDB0F3EDE438BC9B,$2D4F80CF1C4A1B34,$9D4F963EBD6418C6
    Data.q $A2AEAD18EBF5EEC2,$0CE67AB155409FD8,$2A112D2949BF5EF2,$7CA0761DAB6953EA,$CE03A0C5E0CEAE0F
    Data.q $F6760951548678B1,$C809A6902FDDD866,$EC59554320D1B047,$29FA8C52F418664C,$FABFCEF2DE29B906
    Data.q $DE5D8F13D8F73FEF,$DA71D26191F75C9A,$773F9FCF78845ADE,$F8C4A2373E1F93E4,$7411A41FD3A9278E
    Data.q $BD812B3F52DC0FC8,$1BB9E5910E1F2CCD,$8813274C6AF7E9D6,$1D7D78C4D8DA58B5,$09FD8A0000CFA7CB
    Data.q $78C2AAAA2CFB3CAE,$8955B0DBDBFB1D7D,$7B7D708D1BD12CAA,$BD8965541DDDD31B,$A69C0972BED85B1B
    Data.q $8E60D1674D982B10,$18917FDB88A07468,$924C2A0847E65924,$8D1BD14B2612AA40,$D07C84C41D75BBB0
    Data.q $4B86C6D1807F52C7,$2006AADD95A12261,$AF5A12A4956C9441,$03F10A2BCDE01DAE,$4A2CF2EDB5056255
    Data.q $89277EC309499D8B,$93BB169650130A07,$17197A329E450402,$7F9F9DFB1F9DF5FF,$0ABFDAD95DB789EC
    Data.q $04BABDCD1F75A337,$01254F39DCB73BAD,$0F7EC416B504C350,$AE0471C515344B06,$963331B5A6E4471D
    Data.q $708A2AA3DF433737,$45349220F83CCF62,$FDFCD7D192B8183E,$80D8DA58312610E1,$C1326CC132628B58
    Data.q $3DBDB3155406C6D2,$291005E2E370AD88,$30DBB1BD1FBDEF36,$051650A8B6028B63,$0564C67E56D61988
    Data.q $D22D621D63796306,$F17EB8F3D9C6C32C,$B3546347F74E50F9,$EEFBF69136369619,$4C55B6883A3EDF1E
    Data.q $0EFEEDD540666951,$5F949EB4BE9F1087,$AA284157CF34BDCB,$BEB04A8A1993BB0A,$4DB85264C32307D4
    Data.q $2C00815FB262D63B,$7796F1497B8C730F,$3C4F63ECFC7FEC7C,$7D48BFD17A7B6D76,$79DBAD6E202EBFA7
    Data.q $C99DAE089DD6B7BC,$76DC003F42CA8DD1,$5187D86596C3334C,$EEFBF7919880CEDF,$9C18C65ADEE6D914
    Data.q $4930FBFB1401E07E,$2CD2251650492482,$B050029FDCA5110F,$2B14D348C78FE831,$CFA5C7DFDCA14EA7
    Data.q $C2EB62AED77B0E7D,$5552655C57960C05,$78C189B1BCB06360,$EA26EAF27A596509,$1F21EEEC50F6774F
    Data.q $7BEB62004EFEDC8D,$12785AE326E1E865,$38690B04D6B4FB99,$F60A9103BC1E8A84,$D753C8559FD867F6
    Data.q $BBBE8F898C25EDED,$96194756130C05FB,$7FF27AEFEBF96906,$776B6C7A1FADE1BD,$7B080449FC5FBCF6
    Data.q $B945610096E191B3,$2A75E6E36A8125BE,$1537BEB8FB5B759A,$EEDFCFDDB372B705,$616A26FA928ACFC0
    Data.q $C3E6A2EBAC810486,$479535EFD640A001,$F7FDD4E21A37A155,$7078D027E24C0001,$B8DC18930F3F9DAC
    Data.q $96CF05B71DD31974,$B0D7D68C55E5A316,$B26CC2AAD819D77A,$833662873DCF6B87,$912D9508D1F22514
    Data.q $6D4889CA4DA289B8,$7218D27669EA18A8,$0C2050F1DAC6F1EA,$4ABB834889B0975E,$A6E5E9FF359D940E
    Data.q $518C259845FDC391,$FBBD8F969060C52F,$C79FFF37E9F8EFE3,$6F95DDC02ECEEC6E,$377D4EE6866203CF
    Data.q $ADAEF0880A4E1D1D,$28865A56A42B1615,$D9A21D797B866E62,$9BD83F266DE4E2B0,$895839B7265F86DD
    Data.q $C583F0AA2206D641,$168E82DB6B0098FC,$815551D2AD312616,$68C6EFBBF59F45CA,$DC58883DDDB31D7D
    Data.q $7B41468DE803D0F5,$590B39B85B056CA8,$8B3D9EAC7DFB8196,$F1BD0B6B64C7D7B4,$D5F3190D11FF9352
    Data.q $E347FBDC58E6334A,$F3BBA20FDE891051,$B6ED42E468993779,$752C84332771BDC0,$B0256C256777D143
    Data.q $EA9B97A198656095,$AFD4FE77A9EF7F37,$4F82E293BB2DE07E,$A8747CCC379EBB0D,$ABE108885F42113A
    Data.q $CB79B3C7AD516141,$466814B7F015E39C,$F483CFD96C53D5F5,$62E666D9B4FC3843,$853D56F6A542AB73
    Data.q $9D5515E4A09B981E,$6692706C6EB37AD3,$448298DACDFD5748,$3DCE2183E7257F0D,$A1C37A3A9F2A30FC
    Data.q $6ED2E45282DC24D7,$853D8D126C488BAA,$77EA339FAEC348CD,$6D66E1E2A73334A8,$7EC51006A7905BA5
    Data.q $48352C8A677B6051,$3CF7ADFCA84B210D,$65BFF795FC9FAEFD,$A1831F8BF79F2D32,$9243630B704180EC
    Data.q $22231CE6F6074613,$581FB42DDB0FDF54,$EBD8CDFD2BFBD62E,$5B74CD442B4A3E2B,$8D6E7F745089868D
    Data.q $76C7463BEFB4F036,$61C75BB48882C362,$221C3E5E5706AC83,$AB8600A16B2685AB,$574A84D28CE54EAB
    Data.q $FEAC8D129C469274,$8BD21AE8DAC9AE12,$2863398C2A136B36,$7637054D9C4FCFC5,$9E4328F2C612C867
    Data.q $FF77A9F47FEDE29A,$5EC2B36BFBDF1BF8,$3947792228E180EC,$F58C421C76060C44,$875801C7AD112237
    Data.q $587B9A982C80227A,$D9759E61FB3957D6,$788BC3745EF3BAD9,$3BDCD4329EA0844E,$E4DAA5B83D5D58E3
    Data.q $5C0D839EEB5F5B4F,$A8251FAC08D6B441,$400E9934C2351661,$21613E1A95EDC344,$F4EF89C05BFDD8D2
    Data.q $08ADB523463A75D7,$0CC3C6330C05A676,$DF27F8F9FFCB8CFD,$2AAA6FBDE97F6FFD,$B86011CEC1A3ECB9
    Data.q $08A06031C91109AD,$DFF54AB51AAD6410,$B82637BBB0182515,$562D4F1366938373,$2E334F9C68D57FC1
    Data.q $947B9C9A9B133BA8,$8B7CDC403E90F6D1,$AB40DDDCACB18F7D,$B86BCE3CEE372751,$56BC76DB54125BC5
    Data.q $37076E741CF3D847,$18332C89AAE2CC17,$9FEEFC5332F433F7,$E9FE2FCDFFF7F67D,$09EEC3078AF4449B
    Data.q $48A392E943CB70C0,$5A088C00353AD464,$2B7E00D2DDC80655,$321ACD4E263B0C3B,$2B59007E0F4E2411
    Data.q $4100D1EA00234465,$FB44478E061AEBC1,$B88C4432779139CE,$EBCC301DF75BA872,$32D467E6CB7E3451
    Data.q $E61A740742DF7AFF,$B5F5A0E5A0BB454F,$17197A09FB8EB4F6,$7FABC1FFCF81FFBF,$C0079AE00CFFF1EE
    Data.q $3108E9DE832309EE,$0871D4585546180F,$9F87F878D1180DF1,$B6B430380DA75B16,$C2F51B49D17E0571
    Data.q $C75C59F0E8229C53,$A8C3C6E5EE3B4262,$BF56CE855E0E7E5E,$96A6A249B15D0406,$E077D68E536DD304
    Data.q $DED067D3D4EFE691,$06109643FB6F369D,$FC4F87F950CC8A79,$CBFE3ECFD5FE7BF5,$E9CB4A8FDF823770
    Data.q $A4A4E1836DC4D521,$93522ACB52123C32,$12284B1FA359AD4A,$36FC581C20626E59,$E91C0EE78D6F6877
    Data.q $5AE3B554991101D6,$166B7F6F9F69683A,$BA26E9C4EBBB9A5D,$FC09ADA20BE04A09,$25E8A734E8F3B775
    Data.q $FF67E1F27F94220C,$B600CBFE3E8F55E8,$009DE835ABA180E7,$418D28FC442349C2,$058610F88F555041
    Data.q $D8311EA528472210,$1DC47ECB7EC1F0D9,$6DD1C2946E89A65C,$DA8FA5BA3380C203,$6BA5348282EC24DD
    Data.q $A53897BD64487D5C,$A38D20889BD39048,$B7ACC135AD639EA9,$EB685BA0EF6D3705,$AA2141354E07F6EE
    Data.q $D0FF1FFCFA3F07E5,$3E7B8E2782FF8FA3,$0C12178A303C4C4D,$64FECA90474100F3,$F5850FBC95954B26
    Data.q $06C2A87C07AD0C3D,$43A6A3CBB73A52F5,$B3B9A6712DA6201A,$81C7D784C3BB871C,$09619DA017C7C56D
    Data.q $A026D120BD7AB761,$73E21C4A1314F1C6,$80441BA568DFF838,$614DD6A3A2132A69,$FDEF8BDFFD0F8B55
    Data.q $7B081E0FFF1F47C1,$10BE835A4650C89D,$9D85675AE959B860,$221284AA5E99DB5E,$9132931B29426932
    Data.q $C727E4776EEA5301,$34563BA28E7D3C6A,$42B7BD5D227B55E2,$4324E21F3C64255A,$6AA2EC0F41A9DA2F
    Data.q $88CD916D2CA77A2F,$5434845A4EA9CC63,$DA671346A1C9E228,$1F16AC04B6E624B3,$8F33F95F7BE2FA7E
    Data.q $5988046EC123EA3F,$7384322A17D93C24,$F60A469DD95BDEDC,$56E714A5980049A0,$9BDDF21B5CD926C7
    Data.q $8D8DFE1E9DF7B3E3,$32BF3D20F1A1ECE5,$299826C9E61A1ECA,$1B3110C6CA69CC35,$7531BE61C270C4E6
    Data.q $2BBE168D04B8DBE4,$96E6E47A641BCD48,$AB16B47553988F2E,$40B44E62115B224D,$A825B1F336A861A4
    Data.q $6BEB4B18F2E18493,$B5D723D2745D4A7E,$FDEF4B89F13C5AB5,$5125510DE4FF47A1,$7B2705AC85588773
    Data.q $101746E66A3860BB,$2303CC8FF185D2F3,$026BE8D35FF3D003,$B4B7DD97FD084920,$DCB53BEF5687F2F9
    Data.q $6D767B3BD2BD3CDF,$66E5EF593CBD55F0,$1B33331130C8986C,$749BA2864280E362,$EBB29CC4F0A23A1F
    Data.q $D690AB070C3C8F69,$988F2A88EA6C7C55,$045395B854E6F853,$B56B2E7CEE5E6088,$FE07FFBCAFA7C8F8
    Data.q $144EC1F9ED3FE3FD,$1814EF690223F61D,$00E922011410176E,$60470E7A34860BA3,$B87A783E9E0EC8E2
    Data.q $47A7BDDAD1E9F772,$C3AB55FC7FBB2F9B,$F52DADAC9078DCFC,$8988998A3172601F,$0E4673BA9881FFDC
    Data.q $BC4B8ED07E871D49,$E6DCDF8E9E37B1BB,$9465A35C3A34AE30,$1933D70C0C7379A9,$330906B6BC612F2E
    Data.q $F4F97F94B1CEE3B2,$8CFEF7D1F2BDF795,$9FDBB20439EDF85F,$8DD10176E26923B8,$83F1F7F1F0B44914
    Data.q $FBE17AF39986010F,$DF86F6ACCFC92F61,$3E35DE0FDDEAF0F0,$7BDEB33CD832B1BF,$72CD4BD3DF9C6D60
    Data.q $A1C090FB816BBE50,$04C7888440E200C7,$5179865ED7AA8675,$BBB7529A06A255A3,$A34CD0203DD6203D
    Data.q $FDE57D3E5FE5AAB2,$134FBD7D3FD1E2FF,$BAACD21E986451DB,$12E5D10156E19C63,$3C8730F3B9716734
    Data.q $00616061CB153B97,$430E7A53EB8C1109,$FBB2FFACE31B300E,$EFBCDA333FEF3657,$5707C39B3DFCF0F4
    Data.q $67933D20F1B9E946,$9D7B4F10F32EAF49,$11749D274DCF6527,$A548DCD9E250E003,$73C970F1EF7857A5
    Data.q $F8BFD80A92FC6908,$ECFE1BE0FC0F95E4,$8F8EC4D3E2754467,$E1834EE4180E930C,$0311BA2818710056
    Data.q $73CE695F11D0301D,$2999CFE47DFF21CD,$8404844322612021,$66FCFC93CFD30084,$9F57DAF199FF7C6F
    Data.q $577B83D3DEFBBA5F,$D2CF7651F5E9E986,$ACCD094ECBAF5D30,$D26C5E1B571F52C8,$4C71A729B5A6A979
    Data.q $9E417EBD4541B449,$5EDDF0845C378C43,$BF55E07CAEA7E1FB,$3875EC9597D7FEF0,$B86020BE42A3B4C3
    Data.q $206DE6E1C61C4055,$5D30009C1544C735,$1468BCD5D27324B0,$294C3122AB9E4257,$661D7FC948442513
    Data.q $8FCDFABC66703E94,$2E6C6F9AB1BBDFAC,$F7E91E0DADCE67A5,$25F8C73D259FBD78,$B40F45717A973AEC
    Data.q $B4E4DA543B035BD2,$630B14A91C962115,$F0FFF7E5D4FE7F08,$376CCFEF4FE0FA7F,$C4D2A178A19CD432
    Data.q $105D1C7A49C4009D,$804704BC61FDF61C,$174CA223A1745E62,$84D24A6192D2072C,$9CA61894CCA42633
    Data.q $4B06A73DCC889480,$D60DADCE56F66F77,$ECA39B43E1EEFABF,$59D946D6D667A0DC,$1D620565451580C3
    Data.q $1535C68B7DD4AC20,$4358DD58CABA8847,$BD9FD2FC7C0F84C2,$197EEEFD7A1F8DE6,$085E18362F7B902B
    Data.q $5D2C156E602CDC40,$399601D36FFBCC50,$18944C2FE5D05021,$4CE509A694C24943,$9737CE52CB270354
    Data.q $FFB99D1F9ED7FED2,$F4F36CA5F5F9D1AE,$679BDE987567B938,$8254907AD6040126,$3612D2D18442044A
    Data.q $27F0BD1F7DE06CCF,$57BDB0DF87D37DAF,$CA2693AF6169F0DC,$149C400A5F0C0B17,$90F9EFEEF264F32C
    Data.q $F871171CEF35D434,$8600622011F39F98,$1B9C259E729E4908,$111EA619EA612CA6,$583D3C1EF4CF5192
    Data.q $765AF776B7B377BB,$BD38CAEF7E5AECFA,$62FF1F6B6B5DDCE7,$BDAF13E3791FE1F5,$C2D449C755AB33BE
    Data.q $60A0BC7A36907DAE,$18730156E201A978,$11C0C0BBEFCE7878,$1F4587B6249BA0A0,$C2592509679C2593
    Data.q $F2E1E9EF72509A69,$17A3F4FE0D2D77FD,$CAFE0BF4FAE17B3F,$0A2F4E09166102EF,$7C56927100DCBE18
    Data.q $6E439A222A63E0F7,$C0C3924547B8238F,$B096426610E60F13,$B88B3E8BF53B0B4C,$45E2E9F506451942
    Data.q $AA266E201257C301,$80CDC9030E65161C,$E20E091E6AEAA385,$D5656E9D563E5465,$00E386058BE84DE9
    Data.q $885B8938FFCBE091,$40BA82921C16004E,$07A768405D200C38,$A5F52EFBC7C8B5D1,$D052710012BF3272
    Data.q $BCCB2226F62C049C,$48E24553C47BA7AA,$78BC400B4E8982F0,$3E04021E8B398960,$5860725E3DE7B5E4
    Data.q $FE2C8722C0D6E200,$54BEB7FC87A30E3C,$E0BB86771002F03F,$BAAAE86627D0BEA5,$1C5BCE6871C5DA58
    Data.q $C400B1C58E2C400B,$B1002C71620058E2,$2C400B1C58801638,$8B1002C71620058E,$E2C400B1C5880163
    Data.q $38B1002C71620058,$8E2C400B1C588016,$638B1002C7162005,$BFFC7B95F1C58801,$1D339E2F855A0001
    Data.q $45490000000092A4
    Data.b $4E,$44,$AE,$42,$60,$82
  droppng_end:
EndDataSection

DataSection
  musicpng_start:
    Data.q $0A1A0A0D474E5089,$524448490D000000,$8400000084000000,$8344510000000608,$59487009000000A7
    Data.q $0B0000130B000073,$0000189C9A000113,$6850504343694F0A,$20706F68736F746F,$666F727020434349
    Data.q $9DDA780000656C69,$F73D16E953546753,$4B9480884B42F4DE,$8B4252200815526F,$1009212A26911480
    Data.q $C15115D9A121884A,$88A0C81B04454511,$2C51158C808E8E03,$A221E407D80A8A0C,$E1FBCA8A88A3838E
    Data.q $CDE6F7BCD66BA37B,$9DF3ACE73ED7B5FE,$48960C08C007CFB3,$1E42A90C80355133,$E4E1C6C4C783E011
    Data.q $100070240A81402E,$0123FD732164B308,$C0222B3C3C7EF800,$080BD3780100BE07,$871C30C09B4DC000
    Data.q $80015C9942EA0FFF,$084B389174C00184,$A6428E7A40001480,$26989D8001464000,$63CB600004A00053
    Data.q $2760002D5000E362,$99F89D8000D3E67F,$011521945B00017B,$44886513200091A0,$8A56CFAC003B6800
    Data.q $4B66140030580045,$4930002DD80039C4,$C000B7B000486657,$000C0800B20B10CE,$7B04002985885130
    Data.q $8400782323C86000,$F13C57F246140099,$7800002AE710AE2B,$81453924B93CB299,$2E575707712D085B
    Data.q $36142B1749CE281E,$79C22E409A610261,$F3E00F3481321999,$E0111591A00000CC,$CEAE0ECE78FDF383
    Data.q $EA2D5F0EB68E36CE,$FEE3626222FF06BF,$E100004070ABCFE5,$1AB32F2CFED17E74,$25A2FE6D80063B80
    Data.q $F775A00B5E6804EE,$A000B5400FB2668B,$3C7EF870F357DAE9,$E5D9D9B990A1453C,$615B42C44AD8E4E4
    Data.q $C05FC267FE7D57CA,$F7FC3C7EF96CFD57,$5D328124E2BEE0F5,$F4CCC2E0F8044781,$62840992CF1CA54C
    Data.q $FF0BB7FC478FE6DC,$B96249C422D31DFC,$8E711251E3142A58,$8922A532F38C9A44,$64FFD225C5299242
    Data.q $35DF3E03FB2CDFE2,$2D917B013E6AB000,$10274BF603635DA8,$F20000F7E2C07458,$80030828D4C16FBB
    Data.q $3FEFFF77CFE18368,$4966800025A047FD,$2E24445E00007192,$000008C73FB3CA54,$F41B41B02A81A044
    Data.q $05C11C06C02C18C1,$42843660FC0BC1DC,$640A421042C2C424,$4282AC2960721C80,$2F602A1DB0CD8628
    Data.q $866851C0341D40D4,$0EB855C22E0E7093,$C19E0861FA0F703D,$08C841040981BC28,$8A620188DA216113
    Data.q $F8859917088E2358,$20248B120448C121,$35914B22511488C9,$485520548A523148,$5C873902723DF21D
    Data.q $823200C83B91BA46,$B281943147BC86FC,$A8B943B50CD43D51,$64D00BA246841A37,$D09BA0168F9A3174
    Data.q $E7A1368C3D1AB472,$433E8FDA0F68ABD0,$C4330718E8C030C7,$38B142C3C62E306C,$AC22B1CB6393092C
    Data.q $03AC56B01AC6AB0C,$0477B1CF63F589BB,$77043609C0458112,$4C5848411E612042,$241C20A848D84E58
    Data.q $8403093709DA1134,$B44BA8932227C251,$326218C4F911BA26,$12D6232C48588731,$C443887B102F138F
    Data.q $B927324389122437,$12D254A4B1490290,$2CE923526ED246D2,$C993231A48349BA9,$2C943907B26B64DA
    Data.q $C3E49DE485C82B20,$5BF221E41BE433E4,$53F8A47140629D0A,$E5194A6ACA5228E2,$32986506E534E510
    Data.q $A1A8DD529AA35541,$A1AD425A8F351154,$3413A88751AF52B6,$4B491683CD399A75,$17681AD395A2ADA5
    Data.q $11BA74E8AF69F768,$D257D0974E1E95DD,$F403E897E847E9CB,$88C78315860D0C77,$671807189B192867
    Data.q $19A64C98AF187719,$31373054C7198BD3,$556F990F99E798EB,$CA91157C2AB62A58,$2A1B9526954A950A
    Data.q $AADEAAA6AAA9542F,$A98F54CB55F3550B,$53335546AE7D535E,$AA55AB96D409A9E3,$A967531B53EB509D
    Data.q $546FA867AA87A83B,$590689FD597EA43F,$A051A4434FC34CC3,$630B20C6BCE35FB1,$AB0D6B212C78B319
    Data.q $CDB126C435817586,$1DFD98BB2A767CD9,$4339A1A9AA3D8BBB,$94F352B357334A33,$9CF87198E3073F66
    Data.q $F397A728E7094E74,$29E229EF14DE8A7E,$5C6531B94C34A61B,$48AB58969796AA6B,$AE36BDEB47AB51AB
    Data.q $59BB45BDA69DA7ED,$5C274AC7410E81FB,$E79D05CE8F674727,$16A70AA7DD53D953,$6BAA2EAEF53A3D4D
    Data.q $6EBF7744BBA11BA5,$9E805EBE9E98EEA7,$FAE7BD79DEA76F4C,$FA6DFD54FD2F7D1C,$0CB306580C47F5A7
    Data.q $C53C18CE0CDB0624,$DBC72F1D3C6F7135,$A54340C35D4351F1,$B99184E197619561,$0F468D46D5A33CD1
    Data.q $6DE324E35CC6698C,$21260626A3C66DC6,$529AEE4DEA4D4B26,$3B4C3BA629A6B94D,$D6CDA2CDCCCDC74C
    Data.q $E732D7313D9B3599,$60B7DF9BD79BE79B,$B8B6A8B62C5A785A,$EE59A65AE4B24965,$A559395A856EBCB6
    Data.q $9DAD46B35D5A5558,$11A7BBADBBD625AD,$D69EAB4E934EB9A7,$A9B6C9B6F1B0C367,$AEDB06D8E5B019B7
    Data.q $176267617DB66DB6,$BD93EEC3AEC5B767,$073DFD8D7DBA7D93,$1D5A1DAB0ED9870D,$3A563A1472B4737E
    Data.q $C57D3FEE9CCE9ADE,$10CF58672FE996F4,$29CB13B6E333D8CF,$6747D39B539D69C4,$8B88F38373B96717
    Data.q $2E3E972ECB824B89,$4AE4BDC8DDC61B9B,$F5D27AE15D71F574,$DBA8EDC29BB39B9D,$DC87EE69EE36EEAF
    Data.q $33599E299F34CC9F,$E551E043C8C3D073,$DF6B30959F0B3FD1,$B567814F434F7EAC,$AD57912F632F23E7
    Data.q $61F7AA77A5B7B0D7,$E39F723EF63E17EF,$59DE32DE373CE33E,$CBB7C8B7C037CC5F,$43DF855F9E6FC34F
    Data.q $D1FF7AFF64FF237F,$890367012580A700,$7AF8FB025B814181,$65DB3A3F8EBF217C,$B9A08C41EDD9B2F6
    Data.q $E582AD828F411541,$AD90ECC86821ADC1,$69CE91CE98E7F721,$07D0D6E87E50850E,$270C7EC38B61E661
    Data.q $708E3F8657858785,$77359731D11A5888,$44FA44DF7343DCD1,$394F31679BDE4496,$2EAA3E2A354A2DAF
    Data.q $3FBA34BA37DA3C6A,$9D58D5CC59662EC6,$2A2E391C4B6C4958,$EDFCDFBE6C6E36AE,$7BE30BE29DE287F3
    Data.q $A179705DC82F9817,$2EA916A785F4C2CE,$4E884C40963A2C12,$16A82A1041F09438,$0A8E257713F2258C
    Data.q $D12F2267C21DC279,$1E2A5C43D888D136,$EC927A4D2A48F24E,$A533C5247935BC91,$BC90A92784B9E52C
    Data.q $169E3A9BDD4C0D4C,$BD3A3D326D20769A,$AA42719091928331,$E667EA67B6934D21,$FEB28565ACCB7666
    Data.q $07951E2FB78B6EC5,$2D5905AC90B36BC9,$285A54E8A642B60A,$66576567B2072AD7,$9EAB9639CA89CDBF
    Data.q $90DBCAB3CCEDCD2B,$C212EDFF9FEF9C37,$574B86A5B692E112,$396AACBDE6581D2D,$15E30ADB79713CB2
    Data.q $B83CAC0656862B05,$EDAB4FD56D2AB68A,$4D7A26BD7EAE9757,$B5C182CAC15E816B,$85E50A550BEB6B01
    Data.q $584F5DEDD7DCEB7D,$9D86FA61B5DF592F,$DB14AE8A89153E1B,$78DC28D87F159717,$DC99BFCA6F871BE5
    Data.q $CF64B9C4ABA9B494,$9E2DDEE6E966D266,$0E97E697AA960E5B,$56DF0DB4DAD90D6E,$972FDB45F6F5EDB4
    Data.q $B943B683BBDB28CD,$C9A765BCB83CBFA3,$F454A4543F3BCDCE,$B5DDD2EE3654FA54,$7B1BEED16EF8D761
    Data.q $BC5BDBD5EC34F6BC,$0155DBBEC93EFDF7,$49FB65D566D54D55,$E9AA89AE3FF7B3FB,$6D4EAD5D6DFB96F8
    Data.q $07FD03D203C7ED71,$1DD5D4B9D7B60E23,$EB2BD68F52543DD2,$EF9DFEBE1FC70E47,$9C8D550D360D2D77
    Data.q $E9E479447023E2C6,$DA3A0D1EF7DF09F7,$1FD307E1AC7B8C76,$9A426A2F1D671D76,$5BFB9A539B469AF2
    Data.q $D6D13ECC4FBA5B62,$0F1FDB47FC7ADEEA,$54F34A79593C349C,$6793D382E9DA69C9,$7E7D9D959D8CCFF2
    Data.q $7BB6A2DB60DCF92E,$EF6F0F6ADFCE63E7,$8BFF45D2E17410BA,$B8F25CCE3BBC3BE7,$B85713E5DBB2F274
    Data.q $74EA6D5F3AAF9A57,$BBC74FD393FE3CEA,$B96B5CB9AE9ABB9C,$E9F7667BB5BD7AEE,$79BDF4DDCE379E1B
    Data.q $3D399ED5D6FF16F1,$F7C5F76F7AF3BDDD,$FD27727EDD16DFF5,$ADEE2777D9BBCBCE,$41ED40F45FBC4FBC
    Data.q $FE5B3FD587DD43D9,$77C06A7FDCEFD8DC,$8506F747DCD1F3A0,$430F8FF591FECF83,$860D86CB8F998F05
    Data.q $3FE239393E389EEB,$64CF43A7FCE9FD72,$CBFEA2FE179E26CF,$EBD5F87E2F1617AE,$F297A1D198D1CED7
    Data.q $EAFDA57C6DBF9397,$C6C2C6DBAF19EBC0,$F45E313378C9BE1E,$1D77DC77C1EDFB56,$207CE44F0FDFA3EF
    Data.q $53F5B1F968FF287F,$FF93931993FBA7D0,$2D3363FCF3980304,$52486320000000DB,$800000257A00004D
    Data.q $800000FFF9000083,$EA000030750000E9,$170000983A000060,$6A000046C55F926F,$ECDA785441444951
    Data.q $37F6D6E75478759D,$40240258A153A850,$664FBBBB8DBB8812,$6B704092109040E2,$5B42A3752D2A9DA9
    Data.q $212426825B8BD42A,$DFDCB5C538BDC138,$9DA8533B27B3CF1F,$EBAE6BF79CF7DE73,$AD66FF66664482B9
    Data.q $BF9F7F300066E97B,$7F3EFE117EFE7B0F,$CFBF881BF9F7F103,$FF1032FE7DFC40DF,$618ED30C30DA3E07
    Data.q $986188798619BB98,$0FA61864F4C30C6E,$0C30C4C30C5130C3,$4930C3224C30CF13,$5FA38986191271BF
    Data.q $7A61866F4C30C51F,$1907986195D30C30,$1F93FF9EFE8BB986,$3DCC30C1DC40EDFF,$C313A6186474C30C
    Data.q $FBF2888DF6FBDD30,$E379EE3DA6D34573,$D3C7C9FC7C47378D,$FB7EDFEBE5F39CBE,$DE7F3B9DCE3F67DD
    Data.q $30D0582FE72BF9FC,$6BCDE7738DFCFE6F,$FC6DE6F3B99E91FA,$E3F8FFDF75BCDE71,$AF9CEE76FBBF6F8A
    Data.q $657B3F4F93E4FABE,$CBD2F8BEA6F7CCE6,$0EEDD8744E2613A5,$13AD85046868685E,$1037F1C7D377BDFD
    Data.q $7D4EFA1EE0564BFF,$8A8B0A7DAED76BA4,$EFFBF15CF73ECFC4,$D9F57D5FD7E4FFBF,$77EBEB6B6ACB6592
    Data.q $0DC6E348F1B0DFAF,$6FABAE7F1A9BEA27,$75D5D5FD5D76B0B8,$8115835EAE563775,$7AB159C8AB351AB3
    Data.q $D66B95835AAC5635,$EB75358DDD6D5562,$635D61775BA9ACAE,$D76BC70DF57599C3,$0FE76AB159AE1FD5
    Data.q $7F1F27D66AB8FE3F,$63D8F63FAFEBDAFC,$F73DFE4E9C38158F,$71F423CC30C613DC,$9BFC40DFE71F43DD
    Data.q $30C31F730C31DA3E,$24912C45D30C330F,$3FF7CCC144F69D4D,$0DF56582FE60B19C,$B1A47CDA6C373B8D
    Data.q $5757F575DA99E369,$74B02B35658359AE,$4D69635754963579,$EBF5BAC5ADAD560D,$81DD6D360B69B4D1
    Data.q $D83DEEC761773BED,$D763B1FB3D2F67B9,$37B65B0BB9DF6C1E,$623435D466D369A3,$4B12B95EA8B59AE5
    Data.q $D5960D5974B06A6B,$5B5D5835AAC560D4,$BAED74E1BEB6A577,$3FB3CD3535D5C3FA,$AE7E5F97C5F0BD9B
    Data.q $1C6C6C7FA732BCB4,$BFF7BADBA99D30C3,$D02D582064FF8E0D,$D3D4FD3E66D5A345,$D5E5CCE1F87C1FA5
    Data.q $61B0396D361B75D5,$5E580DF5B5F396F3,$66BAA357964B02B3,$CDEDE6C06BACD625,$8FDDED762F67B9D8
    Data.q $A83DEEC763F6FB9D,$CE60964B8584DF5F,$9BC53F8F83E2DFD7,$D30B78DED78BBCEF,$A5E06633E982BC67
    Data.q $DBC2DF37F5E1AF19,$D7C33F4FACC4CDEF,$B8D1AACB25877FDF,$EC1D87D9EC761371,$C36EB71B17BBDBCF
    Data.q $F977BFA32C7ABADA,$86BA8B5B5D58958A,$F2FBEED6D72BB386,$6F4BE2F73CD66F9B,$31213E28351C8C55
    Data.q $F3B986190796BA99,$97EA5B47FCFE206F,$A8AB2A8D898E891F,$5CAEAFEBDAFABEF4,$3687EDF6EB6EBAB9
    Data.q $58359AE5657ADD6D,$D751ABAB4B1ABCB2,$A1DF60F7BB1D88D0,$A9AE562F67B1D843,$CF2F8BC4BF2FECC5
    Data.q $643B76CC25655940,$989090B332323932,$214544441898E888,$9085EAF67A37BC3C,$24342084848450D0
    Data.q $7DDEEF42F57B3D14,$487171B10FD51910,$A55287CF8F054949,$78B198D545EDCB82,$635F57C5F1D7D5E5
    Data.q $3D8BDEEF347ABACD,$BB58DDAEDB620F07,$F2C96357964B1EAE,$C6A6FA8B5DAEAC6A,$CE62F81DD6EA6B4B
    Data.q $D79CFA9D1E53559C,$B537B5DAED7733E7,$14FF8D5B27FFF772,$492258817560EE20,$9C7EEFA8EA753C9D
    Data.q $B75BCD2DE6C3773B,$2F161D6EBAB8BF6D,$DEEC66F369BFE627,$B5CAC41E0E7B0077,$3A5A1899DDEB7875
    Data.q $E81919E906B52A1C,$D7410F77BA3FBFD7,$98B889191110DD6E,$152D3D2026252458,$E3C1B2F1E059D9D9
    Data.q $42142841E7CF8365,$E7CF80142843E424,$69690B2B2B2FFE05,$FEE8FF438F8F88A9,$A1BB5D6E83E88888
    Data.q $56418989889E8F47,$46AA2A0306743676,$237D6D423E8FFDE3,$63F7FBDD803FECF6,$C5835D5A588DC6FD
    Data.q $EB0D16B6BAB06BCB,$E6FADEAEAD2DCE9B,$68643C1929CF6FDB,$FFC7460A58E8E8FF,$0C76881B7FE568C4
    Data.q $D993374C30C03CC3,$2E96C7B4DA6C7E22,$9A471D8EDB74BE5B,$5C2C0ACD75416F36,$DF7BB1EB8D750CB6
    Data.q $2C960B007BDEEC7E,$2372E9C38F69D4C6,$DCE8A121210B3323,$39352145FAA233A5,$80C8CCC86969E919
    Data.q $A75E872642842448,$5E07379F0BD78E43,$3F3EB9179F3E1B8F,$3F22E5E5E47EFD72,$CDCBC8B97979172F
    Data.q $C781E3D781EFDF85,$80E5CB81EBD786ED,$C84880A94A81A741,$9152D2D206666647,$73A37BBDBE809098
    Data.q $A1421BDDEF082E97,$E7D9E3FC7CDCFE08,$803BEF76357964B0,$4B01BEB6A3F77B5D,$35D42AE566A35796
    Data.q $CE1FFDDA9AF56234,$A7462311F0EE78FA,$3FF1DA2151A56465,$6191D1026FFC62C9,$84CC7B22B9526E98
    Data.q $BDDAADD6D6D753C9,$AD2C26A6FAA9EF77,$6DB8D8D5E592C1AE,$D6EBB5843C1EF63B,$47E393903319A5E1
    Data.q $F441E07C1E3C5C6C,$D2322C6C7C450D0C,$E1EA32604A9321D3,$F1CDE0BA72E1D870,$D781E3D781CFE7C0
    Data.q $87A0D1876EC381EB,$A34681A34681A356,$4A84A14A82A95A86,$81A35682A55A80A5,$A0D181AF4181A74E
    Data.q $D782EDDB8662D587,$8047CF82EDC786E3,$1930EDD8709CB972,$454F4F48C58890F5,$2E86EB75BA34744C
    Data.q $06031D3D3522BB5D,$0DFA8FBEEF3BC20C,$BCD86C41C0EFB11B,$0ACD596357964B05,$9FFAE35D6237D5D4
    Data.q $E0C9716167317F66,$7DC60A7884F8F88A,$9D30C3377102BFFF,$A6331AAB89F4FAC3,$EEF73B458ACD596A
    Data.q $5B2C960369BEB93D,$176BBCD12B35A58E,$402FE61F88381CF6,$F07885081091C8C5,$49C91DD2121087C1
    Data.q $C09326436765E0C9,$C545172F2F213662,$40326CC0E7F5C885,$E7C841162C41972E,$2F83112C42122243
    Data.q $41122441E7CF81E0,$952641112641162C,$A941932141932642,$4156A34254A54050,$312004D2AD4355A7
    Data.q $35A9D0741830F41A,$D87075EBD0B4E8D0,$8B97979078E5F06D,$A50A09B366078F1C,$D1636362365E7C1C
    Data.q $9501ED08F46773A5,$756960A653498346,$77DB2D843C1EF60D,$41AEAD2C2ACD6960,$34386BACD6037D5D
    Data.q $81FE399C7359C3F3,$FAEE31AB10F43D0F,$1615843DD60805FF,$7B59ECE9F47CE715,$2C16CB71BC381FF7
    Data.q $D6D835D5258E5EAB,$2FECC3EF763B03BC,$898988E1D2D0C0BE,$0A2A2FD11D8EC745,$78F0A4C990C94929
    Data.q $86E3C7842A2A28DC,$225884A54A8068D1,$5206666643C05082,$94D48296969052D3,$891620DD12A46414
    Data.q $D3A02A54A0CB9720,$609932601BD4616B,$5AB36058B56198B1,$B36059B7615AB361,$6118B4619931605A
    Data.q $69D3A0EAD3A01834,$D7A1E837A068D7A1,$601A326018346169,$5AB5619A31601832,$1E172F20A2F1CDE0
    Data.q $C9C9291CB90A1397,$10F43D0F13D5EB08,$DF1E37198C3C79B2,$E6C01EF6BB0F38FD,$55960D7974B1DB6D
    Data.q $A9ACD426A6BAC0AF,$69555F2789FC7E6D,$FCF5A84261860634,$4B74C30C5DC40D3F,$63E2613318CE4A4C
    Data.q $5ECF63BF59ECF7BB,$63178B058D5AACD4,$BE1F77B5D8CDC6FD,$1E8E1D2D0C07FEFB,$89888EC763A17B3D
    Data.q $8566CD8622448689,$6ACD81EBD783EFDF,$4647C04887214281,$1D13111313123A46,$049C9491FDD1FE8D
    Data.q $F8B91162C416765E,$0B16AC13262C1D3A,$2E1C2B366C2B36EC,$3C274E5C174E9C27,$0F1EBC371E3C176E
    Data.q $C720F5E7C72DBC72,$0FAF1C8397DF81E7,$872E13976E1BB71E,$7A1EA32605AB3603,$11A3661E9D460E9D
    Data.q $B31609A326099366,$FC2F1CBE03874E09,$0489106DD9B039B9,$41E0781E37B7D3E8,$5849C4FC62262424
    Data.q $F5803FED76296CB4,$B55865F2D161371B,$C165FC6C371A0D7A,$68656F5E5D2BC5C2,$0C30BA618678F0AF
    Data.q $98686D101AFFFED3,$9DCC3FDCF9F1EE15,$6FAECFC7A3A1F9FB,$B6B2B04B25FCC26A,$AB15B2C5ECF73B0E
    Data.q $70A2A3222C763550,$5211292921773DCF,$0505050D874E14A9,$C990E42A50EC3870,$41898D88F8F010A4
    Data.q $C90A2A2FD1BD3EDF,$65C99078F3E04949,$69D055AAD094A950,$B04C9B30F41830B5,$6DD8702D59B0CC5A
    Data.q $1B441CB9701D3A70,$F3C5C9BAF1C8DDB8,$81CBE7C0E5F7E179,$C72F81CBE7C716FF,$2043930097AF1C8B
    Data.q $1830CC5AB09D3972,$B08C9B3075E9D0F5,$8C58B0CD5AB06DDB,$C385CFCBC8DC7B70,$044454412A5480ED
    Data.q $F1B2B3323F703E3A,$D8F575DAC19E3FE4,$258B59AE562F67B9,$F58680DF5B51ABCB,$11DE97C5E3FC8FEB
    Data.q $A7FF4261867AC488,$C30C768813BFC5B5,$5655C6F7BDCF783C,$BD9AC763B6DC8D55,$5C2C2AC57AA3F6FB
    Data.q $2DC6C36DB79B0CB2,$8409E019E5FD315B,$4A90D13131061860,$039FDF85CBCBC844,$42850B469D03469D
    Data.q $85EAF58444A4E48E,$3647884F88E1E1DE,$0CA9720491521B2F,$AD5A12956A1C850A,$661EA3260EBD7A1A
    Data.q $B36EC18133161193,$02BF9C2053B0E1C2,$7F02FBF001414082,$3721F7E790FBF5CE,$7CFFE05F5CDC8FD7
    Data.q $CDE26B508AC43939,$40B56EC371EDC0F1,$B36EC1D7A0C2D7AF,$22B564B71074E9C2,$12A42F1CFE172F3F
    Data.q $DCF73DC2F57AC211,$827F1F598ECD8B0D,$835359E11077DB2D,$7C06C371A0D6AB55,$095B56F58B8FC3FB
    Data.q $6FF9B6D5D49130C3,$44FB9D30C33DA206,$9D4F13C4FE3F6646,$B09B8DC6F0E6753C,$CD1ABD58AC52F160
    Data.q $1C0C6AB2C961773B,$3BBDD21061860254,$4E5C1F7EFC2162C4,$050A143D06FB5107,$44777BA42347FBA2
    Data.q $2142152D23204645,$7218891210B1221F,$1A8D6A02A52A0C99,$E83260E8251B2D5A,$0858B736609B3261
    Data.q $228016C3870ADDBB,$AFC60C1B0BD82EE0,$F5CDCE7E8F23F080,$E2409FAE43EFD723,$DC171E397169C9CB
    Data.q $2D3A741326CC274E,$5971272E5C33662C,$1EBC721F3EFC0B56,$E823C8FCE85978F0,$55829E4C2633B9DC
    Data.q $562B03BCDAD875B5,$D8D758159AF2C6AF,$FF3EBD9A1AEB9588,$A448D0A4BA5D4ED8,$6D3699ED10237FDD
    Data.q $FB3E8F8AF9B3D242,$ABAE5ECF6733DDF2,$69AEB04B4582C3AD,$7CDFD781D8EDB603,$E906186069A9C913
    Data.q $CDCBC8EC3A70E9E9,$4068CDA226A35683,$222BADD6E8517EFF,$3CF806466643F5FB,$643162240102841E
    Data.q $254A54390A142932,$0D5A102C34252AD4,$068C2D7A0C2D3AF4,$B5297793BFD44C3D,$53701D4F0D1B7614
    Data.q $71EA8848BB71E16B,$81142C381BC72723,$0A7E1FAE5E450413,$B925EBC2F0F58B47,$BD02C5AB05CB970C
    Data.q $1BD7AF0CC5AB075E,$AC59B00585855AB0,$05DF77DDC48A8A88,$DB02FF3ECF8CC99D,$569603436D42EE77
    Data.q $DE6E361D6D5D40AF,$8EF7CF6994CC7A7C,$9BFE3BD655A427EC,$1A9EFB7DBED0E880,$0EAF8AF970B4D1BD
    Data.q $68B0AB559A863B1F,$37EB0DBADA6C32E9,$6DA6D11309B8C26D,$29721413A9D23C5B,$5280AD4A812E0F06
    Data.q $1C7C7C46EBC782A1,$8917EBF411E4791E,$0A10D978F00CCCCC,$30A7204A945C24F8,$A5081455280A9528
    Data.q $3A1A8D1A1A8D1A02,$0A04DB311D3A069D,$A3616B2B63264C03,$B8700338761D3860,$8396C1BC371E1C08
    Data.q $7F121707016E29AB,$640839AB3F7E1FAE,$AD3A058B1613971E,$181CBE391D870E16,$1415142EDDB8464D
    Data.q $230FC3D3A0142440,$1B157E5FD3142434,$5B2C46D363416EB7,$69B0D16B6B6B12B1,$9312778DE57F9E0B
    Data.q $006FFFB457549593,$6ACBD9DE775DC3A2,$3C1C171A1BEADBB7,$BAB4B06A6BCB187C,$B59AC56337B75B06
    Data.q $468E88568973FBF0,$7CF80F1E7C3E4141,$E824C990BC72723E,$B48E1E1DE823C8F4,$CBCF8265656454B4
    Data.q $4C862A4C84245886,$872E4287215C832A,$587B1501528F4142,$B4E86A35682A3438,$C09E83061828181A
    Data.q $D9B761C104B0C141,$14C4D8396A0C6B5A,$472D615B904E470B,$BF0FDF880022851E,$A7ECD062D65C8FDF
    Data.q $AF5E826CC584E9CB,$9305DBB70DC78E43,$76ED387CFC8280C1,$30ED1DDDA1878784,$69A13635D6155472
    Data.q $B535855CAF5426E3,$E8FFDE2361B4D16B,$B47774B2B3334FA3,$0ABFC505DFE3DB6B,$8CA87BED1DCCF688
    Data.q $0F07C5C6FAE34B16,$72BE5835E592C01E,$05FCDE633736B635,$59D9061860952990,$169D3A0832521859
    Data.q $E88805858504A912,$62624174BB5D07DB,$82CECBC132333212,$4CB90A5483DD4848,$852E59F2D64CB90A
    Data.q $394A16B587232E42,$2AD4054AD4394A94,$0E142571156AD425,$408F248D186AC73D,$022DACD867472784
    Data.q $7AC70F0F5A840594,$E460C11AB208E004,$709CB86039F860B2,$CDC86D5A78446DD8,$22F5EFC3D060C1F5
    Data.q $A3B871717117373F,$5CACD47E7D783B5D,$356ABD519B4DA685,$E1361BF58D5AAD56,$5335362CF8BE2FB3
    Data.q $29A1DFFDDB69B4C3,$23BBB4C1DC4015FE,$AAE97CF9A550BFA4,$D5E5D2C41F0F47B9,$C41BE6F9CC30A1A8
    Data.q $62C4481861802425,$793A464644ACAC8C,$D107C1F0789CBA57,$3B2067A6646F6FB7,$10916200A142132B
    Data.q $993214995204A952,$93239692A5156494,$6053972149977F90,$A9A8902D147232E4,$EBD0C0AD55AB50D5
    Data.q $C58464D98A5CAD74,$59D870D6AA89A464,$0B948236E38012D7,$F9F0C68E5C8E0706,$64D5B814D0F4A089
    Data.q $CC2E5E7E47A0D186,$ECEC881C0C945B54,$352A943DB3B8742C,$689B8DA68E5B2C96,$F2603635341ACEE3
    Data.q $C645363DD07D1F1B,$63FF885695D76DB4,$29BEE74C30C76880,$91E5FC5C7E8F9219,$AF960562B3504723
    Data.q $E7D9F03BCD6D835A,$DB6DB45F5477A39F,$2386CA230A952A16,$8B10854545113129,$90989007C1E87845
    Data.q $105978F0348CF480,$290604C44890050A,$59F41C5DFE84830B,$A90C44A902448902,$1A44A90A44A90244
    Data.q $41972942932E4580,$A3440134D4D390A9,$F4186AC72D692926,$89442A068C56E27A,$B76A31014D98B0E5
    Data.q $C8E75A16B95A3813,$C19725AB3268BB71,$F5A425A4AE2D16B5,$D7AF43E8D3703D7A,$AF4070E9C2F5E7C1
    Data.q $3112A42064A4A2D3,$2C42F8F05EF7BDEE,$C563369B4D14B25A,$6C362D7ABB58B5EA,$43C6FDBD2F5184DC
    Data.q $9FFB6EEE9A0251E1,$D2EA1E61861B4400,$F6F47E1F07F25BB5,$2C1ACD7AB02793E9,$97C4EC77DB1AB95B
    Data.q $D7687EA8A8857D5F,$0D874A3D7A0C2DB6,$821D0E863C7C4243,$E909D4EA7444A4E4,$CF808748C8C829A9
    Data.q $2A5717212C415623,$72DC44896C5E8725,$C2458862444862C4,$10458BBFE98891C0,$50B090258890C58B
    Data.q $E9A0A1C85115A949,$E58E0E145437A26B,$30E05AE83060EBD0,$38561BD5856E3919,$D78735651880D66C
    Data.q $0D00B5F9EBD782ED,$7AAA123E16B58306,$5A75E836EC382EDC,$03169D3A2409B8E4,$BDDF71CB90A08B8A
    Data.q $65B2C963122442F7,$45AED66A3369B0D8,$7AE9B8DC6835BAE3,$C75F79DE4F71C8D1,$E2019FF4C5657FC4
    Data.q $A7A9E23FBFEFFBFE,$D6E7D3E9F4EA7A9E,$BCD02BE592C3ADAC,$89F100B7987E276B,$351A342DB6DB6889
    Data.q $CA024262430E9786,$BADD022232219786,$0C29323A46664176,$12932E5DE5A8B112,$2D0BD84A9001400B
    Data.q $4884244882245882,$8470288028508428,$8B11AF92122008F4,$01444B10C4491044,$43DAA321499323AB
    Data.q $1A3437A38A8ADD49,$62B3D520A96ABA12,$B02D58B0FB52D8D4,$AEB0706DD870395A,$9F4F8A82D626E3C4
    Data.q $2416B0B7A584872F,$A70DC78F5BC2417F,$8E4E2C4F41A301D3,$431407031A8D5A17,$5281EF7BBEE2932E
    Data.q $D361B06BD5CAC6A5,$5ABABA835EACD426,$8E70EADC70DA6FAC,$72F4865F43A1D0EC,$EEBBAEE1D101AFFE
    Data.q $0E8761D8CC6635EA,$D52584D4DF53D91F,$5EAE561779BDB1CB,$972061860E5CB90D,$129312387C3650CB
    Data.q $83EDF6FA29787C30,$20BD526664109090,$B445C5A4B67793E0,$02891220800920C0,$087C050802050810
    Data.q $02843E023A0FC3D8,$58900030A13AF93E,$2A5C812A43016C24,$5283214283265C81,$82A94A84A54A8729
    Data.q $CAB6BE125A2B7586,$B9399873448C986B,$41AF360CE885AB0D,$467C9C7D3E2B0635,$A04397CF85AC2DDE
    Data.q $1E3C03461408BB70,$060D5A74172EDC37,$77DDC4244886280E,$686BAC3CDC9C8DDF,$0D7AB9584D86D342
    Data.q $468AC57AA3D5D76A,$84771DC77B9D5AB5,$3688057F14722BFC,$A69A5CB97174C30C,$A581DE696F561B0D
    Data.q $6D3416CB71B02BD5,$8186183E6E7F04D9,$94918321D0C02050,$1B10904B83C1889C,$13332321BADD6E8F
    Data.q $CB018489105959D9,$21014244A9470AC0,$41122442122C402E,$E0F9F3E020061428,$B27226EED3E078F3
    Data.q $005E7CF8756EC9E8,$162C43001F80A114,$65C86DC96E2DDFD1,$8C24E42A50E5C850,$2D7A2A46C2971355
    Data.q $8ACCD426691A82C9,$E6C5C4E8D2885651,$A9F85023FCF0A835,$914B51705DBB70FB,$3662C074E5C0F5E3
    Data.q $6869E9E900B0A8A1,$1B1E37198C3B477F,$B358F5FAFD456CB6,$ECC9F11BEAEB0EB6,$9EA9C8A4A4A4DFD9
    Data.q $DDF703C40D3FF368,$3C3F3399CCE45F77,$FB3DD4964DD0F070,$0618608984FC600E,$7C103C192849C949
    Data.q $D9D9783F7EFC365E,$C0CB516411F9DCE8,$58196A720C2C9486,$850B777903DC409D,$8214F8083C04087C
    Data.q $2B3B216767642CEC,$27A4CAC89959D913,$2CACECF7FA1C832B,$03C2009610936764,$A1CB880870A3C79F
    Data.q $16722B75838585AE,$7272C21B838E6E0E,$FAA14225BE83661B,$D58785B407B0E1C2,$AF0A5A5BCF994116
    Data.q $061D874E13976E17,$C5A9E81CBE790EBD,$DC7F5FBFD0FBF3C8,$B1B78DFD78DDF773,$9AC4686BAC0EFB75
    Data.q $B2D288D86E343ADA,$7F88CEE1D0E8FF11,$6DA3B88167F618B6,$DAAD4EA7932176DB,$A8F5C6FAA1C0E07B
    Data.q $BBC41C0EFB0AB959,$90843F0FC3C5DF33,$54AD42F5E391DDEE,$91E0B56AC356A341,$06589D3D23208F4E
    Data.q $0D20C0E74FB5B0A1,$42057E0830A220C0,$1999033333208516,$0F2DC64748CCC819,$CFE8B3100119FFFB
    Data.q $908EAD41EB5365E0,$84890DEA98B110EA,$58837A383850D036,$8454742D5A740D0C,$97649130C6AC0C9A
    Data.q $DDC6A4B684C816DD,$C9A15C14B208A1AD,$0585851E83461F46,$61C1F5CBC8D468D0,$B1B13104242422B3
    Data.q $8CDEDD6C5CEE61F8,$961D6EB6B16B6BD5,$6A0F34675DB35CAD,$FC4AC67F976DB6D3,$EAECBAD5893A2059
    Data.q $EA89D8EF35566BD5,$58AC1EF773B12B15,$C0C30C14A9621AB5,$9F010FD72F23D060,$61F87A7402C2A287
    Data.q $8BEC0C72072524A4,$88826881640DE6CD,$90C15BF0105E80C7,$1D23232100159595,$8D27234F4869E9E9
    Data.q $952D27A748A9A93D,$D3D3D21A7A7A5BFC,$40CCC940469E9191,$4D0332B2B2066666,$50ADC440B13E02B7
    Data.q $5AC2B7168E0AD1CB,$33AB2844455A950C,$C9408CF939187A0C,$9636E2BA0242E39D,$3A76E1B8F10B5022
    Data.q $0F9F5C8AD98EE348,$A9500545C50AB51A,$7D73784763B07814,$B15BCDC6C0686BA8,$D9E237D69A1D76B6
    Data.q $FD392E2C22F83FB7,$C9DC4033F9B0699F,$767E9ED351B74C30,$43ADD61B6703BEE7,$51823E1E0E23435D
    Data.q $978F01B4DA605555,$C2878F1E0BCF9F0D,$FEFF46F444440282,$82081421B2081031,$125330923CC9324C
    Data.q $D2458A9091221570,$44CCCCC8614D9D05,$0429D3D232064646,$9C9927A14D4D48A9,$FA6494948293E094
    Data.q $A7A454B49804A935,$2E19589D3D2321A7,$1021B2F3E0D9D91C,$55AC1BD507345AF0,$54050A5439525923
    Data.q $27EA83E895C0552A,$971EA886E0C39A66,$78E452C77EB32493,$1A34613A76E1E449,$66C3B0E9C0F5E390
    Data.q $09393921F7E7C2B5,$A06633E988EC740F,$43613637D42ED779,$38549D35D4961D5D,$DFFED428321863BC
    Data.q $6176BE6B04A7440D,$BD515BEDE6A6FADD,$3E8F8C3E1E0E356A,$CED740F47A3D18FE,$A09936615AB3619D
    Data.q $1A1A104B97216BD7,$495265A1A48F1E02,$0BB8804E682B37C0,$20401021575832EA,$218526430B9EFE20
    Data.q $484929C9390A4200,$8949C93D12424A4E,$939392125BFEC39C,$510264948C929C90,$EB53A4B2C04A6A5A
    Data.q $46022CEC8FEAC991,$1889522971696A20,$5AA62F485CFB1932,$468C32E682FA24AD,$D59396C49C9D1103
    Data.q $2DC7DC8272176E15,$7083483A8E1B2645,$B9F91A8D5A1FAE5E,$0DDAEF74464D987E,$760160B7981919E9
    Data.q $D0D80DF5B585DCEC,$0E2EDFD9A5F37F58,$06DFE931B4A52813,$333D56BA61860744,$D6362E077DEEC67D
    Data.q $7DBAD8ADA6D343AF,$E149932560B47C07,$FBF7E1499320B976,$C4A9A9E9043DD211,$4359A3BC24244832
    Data.q $C42E8D82001142A5,$B36448CEC15716E2,$D48690C29D23226E,$4A464E494FAEF254,$C898911292921252
    Data.q $212120262424049E,$47884C4809098901,$98901312123C6262,$25252404C4A48098,$2D4C929093924812
    Data.q $CF48E5A8D20A6A49,$E059297583BAA748,$B104489116225BF3,$721459D494A90444,$32FA43A0D24A5439
    Data.q $B25A1A36621701D4,$8A6B5A3A70A6AC9D,$B71E1BAF5E9910DF,$5E1D874E05B31613,$0E5F7E09B3161B8F
    Data.q $8C7EFFB81E1E7CF8,$86C76DB71B013F1D,$AF543ADD61B05BCD,$11A64D15F5AB3A6B,$CDB29D10177FBB47
    Data.q $B7DB8D75D5E2F16E,$A7F871ABD58AC36D,$C3F0F0B78DED7863,$0D5DA4822232230F,$A1A7A7A4464C983A
    Data.q $C5480245083F747F,$FAC48177A4E52862,$264A71408A95284A,$010200A10BB8B695,$644C86EA8F1E3C1F
    Data.q $E9690D233D23A664,$0A4A4A45494D48A9,$7C7C2E5A10599392,$B88713D9E3E23C42,$10E2E39FB1C438B8
    Data.q $242478F884871F1F,$4A48E588125053C4,$ACD30AC181058022,$92405630D9462A4C,$2292B61030916261
    Data.q $E2D25AA8D6DCED1B,$43A4DA26CC587DD4,$06921B0E836C5892,$4878F4C88E5C8EBB,$0FCF3F203464D495
    Data.q $C38707DFBF074EBD,$84949490BD5EB08E,$43EEF6BB16FDBEAF,$CCC06C35D6235D5D,$FEF1E6C8C82C9F59
    Data.q $1865B44023F8968A,$EEECF0BC2F0BCBA6,$F363D7D5D6CF7B3D,$2E1C1B65B4D8EDD6,$C387214281861817
    Data.q $AC340F24A94A8761,$143112C41E7CF827,$AB540D9A6AD43972,$12B5927548AB56A0,$01F82A8D1122102C
    Data.q $A348A969901010ED,$12024242430B8196,$B8B88717109013E2,$831B171163627258,$3620C4C6C418D8D8
    Data.q $8B8F88B1B1B11636,$8F8F89E8EBF73C43,$11252524013C7C43,$7A414B4D4849C9C9,$95919D5CA211265A
    Data.q $1202A01536765E09,$5543425C9311B2B2,$26A7849C3A495CF2,$706DD85356561193,$B9EBC7349081EC39
    Data.q $0776DE956DC89EA5,$107D72F2256B0EDC,$5E5107A1E878C409,$B6F360B79B0D8151,$EB6B558F575BA8ED
    Data.q $6CC8638EE6E4E44E,$0AA67AFB881CBFEC,$8EE776ACB2587E12,$4FF0E2D756AB9BE6,$D74BA0EF5BE6F0C7
    Data.q $14D1B30615EB08AE,$3636236765E03BE8,$1A1C854A04A95206,$A8D2F88893169AB5,$671A412B58A95055
    Data.q $459D97523B9370D9,$64949486E8E74880,$79027C4788600724,$16263622C6C6C7F7,$310636272DD131B1
    Data.q $22147FBB23A43131,$87846F4FA7D02323,$E8F67A1857AC2187,$0F67B3D1423D1E81,$DBE8DEEF77A27A7A
    Data.q $6C6C428BF5FA0FB7,$829291901313122C,$B23A466666022C8C,$BC240ECECFC032B2,$52241112240142C4
    Data.q $611234940932E409,$C23264C2CE6C9DB3,$64D99A09E8B7316A,$14106E475D82B4BB,$EBD06172256B176E
    Data.q $AC233162C1F7EB90,$D7CE62A5A5A42F47,$5C686803DEF760DF,$F97E4E6E9BEBF58F,$CFFFD897E81EEFED
    Data.q $2A1B3A2011FC79CE,$D6D0FDB2DC680CA6,$F7BB09BF5C684D4D,$81861821614147EE,$AD46836ACD84A94A
    Data.q $19046464436ADD86,$7A068BE0E8CB93A3,$96AD3A16BD7A16AD,$2C143AE22AD40CD4,$84459591015F9210
    Data.q $905352D23A7A7A64,$252424E4948C929A,$F1F1F10121312226,$311A3E17A58B8B88,$346C7FA345C4F4D1
    Data.q $EE86161610A2A2A2,$7AC2087BBDD043DD,$F446442F587840F6,$48091D752C6C5C45,$D11E3E21276E278C
    Data.q $867A3877B7D1FDD1,$D216E8211ECF42F5,$347FA6217BBD611D,$AC8E919190121312,$284C9265656474CC
    Data.q $0A072102C432E48F,$9FCF2D94AA76C929,$83C8EB6366CCCB16,$D450D825636E3AEB,$24E5C0B662C176E3
    Data.q $2F1CFE159B0E14FD,$984E91F9D132B3B2,$A685D8EFB60A753C,$2E9F1EA1B9B15B8D,$59FCF7EAC539BE58
    Data.q $4C30C1DC407BF1B7,$EEF361F47EEF8BC8,$FDEEC7ABADD6573D,$989091738FDDF007,$19B326007C1E0788
    Data.q $B94A01A32615BB36,$6588A850B171B102,$7AF4187A882A05D0,$35681AB5685A74E8,$0B252C81E4256A6A
    Data.q $82059B2F07CF8084,$9C929052D3520FE4,$2226262424A4E48C,$B035C471F11E3E21,$37D9108096262056
    Data.q $DDEED744F67B3D02,$C864A4E4861E1E10,$CE5D38064C1832A4,$FD9F02581B472116,$C2F1C9C8FC72F87E
    Data.q $CBC84156AD40B562,$40F6857A0C747446,$7C40888888A11ECF,$7593A239D3321C42,$50254A957552421F
    Data.q $704AC707D1022850,$CF5E7C25639384F5,$78ED20031926052D,$B97909B36603A74E,$61FAE7E43AF4187E
    Data.q $183023CBB5D1E834,$D9EC76196CBC5874,$78D75AAC46868687,$736CFE17F2B0C065,$9158B25F7101EFEE
    Data.q $B75B6DA6CD62BD5E,$8E3B1C8E037D5D61,$44EF3BCEE3269349,$608F323AF4224262,$9F3E0C929A919936
    Data.q $A0C702BF0D287C4F,$B556A1400BAF5E87,$0C58B10254994B88,$9D91B3B2F041CD21,$22A5A6A540481995
    Data.q $B5C7C45DC5A93925,$4545FA1EE2588758,$8EEF76844F57AC21,$72E18896217D117E,$45C5018F9F9050B9
    Data.q $1422E280C22E2E28,$B74500B0B0A21515,$510A8BEBE485453B,$A3261FBF5C80585C,$27B3D9E829A9A901
    Data.q $A408C8C881ECF47A,$24C932B230132624,$232A43112C428539,$EA1CE69052A55342,$B8902987FA818C3A
    Data.q $12B2B7F096AEFD72,$CC587EB9F901A346,$C88FE98D892B80A6,$67B0378DFD78BEC8,$A6A688D86D3401FF
    Data.q $257B8B99ADF1780D,$407BF1B719FC26A4,$DB8DA0E4FB1CEC3C,$6D360361B4DD1FB6,$B162C3B6DB2D86DD
    Data.q $F4186A3568186180,$C47A0D182AD4683A,$26328322AD43C7C7,$A48D98464C9B8B1A,$2D0356852D64684A
    Data.q $81C588908EAC1B75,$033410B1C79F14A4,$89024264C5429C99,$4446898E8C58A822,$C3BD03D9ECF45F44
    Data.q $42EDCB82CECBC0C3,$90510A8B8A215161,$D1E5E43CBCFC8F9F,$AD38C396EF9F0AD9,$45CDCBC8FD73EFDA
    Data.q $4451F20B0A3E7E41,$2C5C7C4068D18E7F,$107D3EDF42F77BC2,$221716B48C83131B,$C33A4A42AE480A14
    Data.q $06147343445E7495,$AEA284B4B704ED3D,$7DF87EB9B912B1DF,$B366C371EBDFD5A4,$4299113B0E5C1206
    Data.q $88D946773A5D0881,$37B65B15B2DC6C32,$5960B17C7AFAD363,$68DF538738BB9673,$DE37E9F5D102CFF3
    Data.q $1B1BE75DAEFB657B,$C7FEF883BEF763D7,$EF1D03C04C4848B9,$5E8566D58064D983,$2A5A7A452E5285AF
    Data.q $66AD0154B6337119,$123264C1366CD9F2,$2B1351AB42D3A14B,$88B16296320790A1,$C8CA90923C7821E4
    Data.q $8989880971103DB8,$861E1E107D3EDF45,$C828A5C99091517E,$B9B9FC01616143CF,$29D0F6EBC0F1C9C8
    Data.q $BE81396ABC9D3770,$D979664E9EF5B605,$E7E41CBE7C7A47FE,$1BAF5E08A8B8A1E5,$DE81111BE8A9A969
    Data.q $53D224547FA37A7D,$21229D32499D9152,$A4A5C990C54AE2AD,$0B991D3A12B58B53,$A16FB84B54DBD365
    Data.q $A348B97511576E25,$7203068C1E7E416E,$A5D6E874EBD039BC,$865D2F1603060C0B,$3511B1B1A1F7BB9D
    Data.q $8D3E190EE4CEEBB5,$8ED10B69FE37BB21,$EDF37D9F9EEEF3B9,$7EB8D2FF77BB9DA2,$F0BFCF0C74FD0E3D
    Data.q $31B17109D4EE1E02,$2468C9804F4998B0,$B327A0C986224AE2,$B566D12FA06B7694,$91D7A0C0346140B6
    Data.q $B836EA2A0AB56B29,$BAC9511252CD823A,$312026242461120C,$A7DDE871B1711E3E,$3FBFD3102322A20F
    Data.q $CFC87D73723122C4,$48DCDA0674EDC3F5,$78F1E4C8AAD5D1D5,$E99FCE5EBC02AB02,$6E9CF326E3C7866C
    Data.q $070E39F9172EDC17,$B361F30A0A371E3C,$FEE89884929290DB,$C9A9217137BBD3E8,$A523C79F04CCCAC8
    Data.q $AC8623A11F9D097D,$F8958E4C0B0434C0,$4DF40BEFCF84BCAD,$3661FAE5E4464C98,$22B36EC1F1CBE099
    Data.q $FF784949C9022232,$D86C61E0EFB10FFD,$E465FA6C37EB09B8,$E177DB6D309F29C4,$DDDC40ABF9B5D9B4
    Data.q $FB76AABC5F4CA057,$F62B75BCD8CD9DCE,$5DA30783C1883C1D,$0DEA3045091076BB,$48C8CC98B0ADDBB0
    Data.q $826CC581AB56874F,$3DCC0F6ED38366DD,$1193261400B66CD8,$1B710D6A34256A06,$C052B6484B10DA34
    Data.q $65454999996111E7,$449494905393922A,$07DBE888F1F15192,$6A458B8F88915151,$7EFD723326CC2A72
    Data.q $4E1DFBFA0E0DA10A,$0764E2BCDA0E5C07,$2FA4DC78F705C873,$0A2014923D267E92,$D380E9D380E1CB93
    Data.q $A1FAE6E764740F6E,$B8F880989490CB90,$7D51111BD3E9F438,$3CF88A86429C9A91,$3AEB1EFB40A24588
    Data.q $C297B632C996DA74,$00B797B2AD12B1CE,$B30DC78E45E397C2,$2A0EC0809FBF08C9,$1E38584FA1A6A7A7
    Data.q $E68FDDED7638F69B,$BFCF05BCDE6C66E6,$A638C4E8B77541FD,$C1FEE2065FD5C765,$B23B6CB71B3DE355
    Data.q $0D0FBBDEEC16EB75,$A6DB6874EAD04D4D,$66A3340DA75E210D,$2566C03464C26665,$D397085C83975669
    Data.q $AB06DD9B0EC38701,$00D1A308D9B302D5,$854B8886AD075EBD,$58B7168484744142,$9494A98902B2B220
    Data.q $1129252125262414,$42208C8A88111191,$1930999999093933,$165A932D1C3A708D,$C072D89D82EE670B
    Data.q $BAE39274E5C070E9,$EC1B7648083871C5,$B36E3532761C3B76,$4372EDC23395A858,$A9691935352052AD
    Data.q $18787847884C4829,$AC8A9A9A90A32322,$583B183768080CAC,$BD4679AD032952A4,$DB906B1611A36601
    Data.q $6DD86DCEDE86AA08,$7EB9173DA5115236,$6086847A1142C41F,$DEC46D37D6094950,$357C66F369B007FD
    Data.q $B4E469D5A516C177,$880B7E282DFDB5D8,$DDEECC63373EC707,$0E070DBADB6D4EBB,$9191904BC5A2C11D
    Data.q $3025AF43DBED0E81,$C5881AB5683A75E8,$E727D83866CCD842,$D5850B354D43C172,$8464D98662C58566
    Data.q $A54351AD4FBE40DE,$1224423A27264050,$469B23489017C841,$F88C9CB53469691A,$49C907DBEDF418B8
    Data.q $14D4AF05A4CAC889,$BD9934C740824588,$AAD6F712C93507D0,$66C2B566C716FEC5,$B542C33662DF1723
    Data.q $E8662D5806C5110F,$E919A809B2F05A75,$0C6C6C44CCCEC869,$646898E885EAF67A,$30C5A6CBC781A666
    Data.q $A1B701943972E409,$B08E80AF22475E85,$E449CBDF8E3502DB,$6DDBB09D3970BD78,$CF8566CD85CFCFC8
    Data.q $EE9090834E9D0397,$0702B159A8AC5AB0,$5160B6DBED84FC8E,$3983C1C2A603AACD,$88167F3688162EC5
    Data.q $ECF7D387F6F1FE47,$3E1C0EF3477E7BDD,$7EFF46CF67B31C7A,$D3AF420F43D0F1FD,$B0E97AA05D616ED2
    Data.q $C75969EBCFA60359,$5AB56B93102B7643,$A0EAD09588993660,$452C2272E42840A1,$B64B0AC1008A826C
    Data.q $B1717117D1111DCC,$81D9D9597E63A2C8,$86AD56842848B7D2,$18BF36475E83A741,$930D031804D41D39
    Data.q $0326B5F246CC736F,$A3CD03068C3D464C,$ECBC12A52A21E590,$1D2D3D232724A44C,$8199959595D23C59
    Data.q $9485EF0B08BE8888,$43A89064646424E4,$68018C8A87112222,$D5931F40DD426435,$C1BEAF7E24E40E62
    Data.q $8CD58B05CBB70DBA,$FDF8264C9842E2E2,$1433D5E8CC58B039,$0E03F0FEDF0C990A,$5158CDCD1D863D1F
    Data.q $3A24C46437D27F57,$402BFDB44E8ECE41,$EFF64FCBFB399974,$E9F85DCED765783F,$E8F415E578CC49F8
    Data.q $6BD3A1C3BDDE8A11,$4AB50E52A546EF02,$6AD5C7AF01C3870D,$DBAC12B1CDD786F9,$2A1A86DC49711130
    Data.q $0499521CB94A0295,$643CF9F172291112,$323A7A441F49B2F3,$C8C88B1F1710D232,$4D8B4F82A5A5A448
    Data.q $9199922B0159D959,$950254990F80A10E,$D9B4B6D5AF62D38A,$8E2DF3F96FA747B3,$4B4E85AB5E83A75E
    Data.q $22C5880A95295276,$DD2749E3C8B3B2F0,$082CFC78165E3C58,$AF57A22527247C05,$0A6A6A428A8A885E
    Data.q $064A4CA228E9B3B2,$75E82A35684AD487,$CE90240664F4181A,$5CFE97FDC11005BE,$21517146696B273F
    Data.q $59B0FCF3F23366AC,$B3B3B20FB7DBE82D,$38FC723859ACE1F0,$E74DA6868DDAEF76,$F8D7538E7A8F9507
    Data.q $7377D5F59D7440CB,$BD9EF763743C1E0F,$0D3E3DA624FC7A38,$6431B1B109D23C8F,$5A8068C983AF5B4A
    Data.q $84E1CB87A74182AD,$3CE109CBCF82E3D7,$384EDCB82E3C786E,$073304C5AB1606E8,$423A23296B207508
    Data.q $F49040A7CF9F0028,$1022A32206565675,$1404365E6C871F1F,$9F06CBCF8EA5B61A,$8968483C040ADA36
    Data.q $A0C0EA2CCD20A95A,$46810B1A939D490E,$2A34156AB50DA1AB,$A02852AB2AB4D415,$2F3E0058B17A65A4
    Data.q $D165E7C561DA020B,$CF8AD3B404165762,$ECF47A04444442CB,$43A7A7A404C4C489,$50A940952641E028
    Data.q $402D75E833209AB4,$C86CB79615C5DD50,$51193160B8F08165,$BCFC86DD870F9058,$0FD7EBF4566DD85C
    Data.q $F037F5ED78C9C929,$362F7FB038E3B1D3,$6FB1A8F0757EDD6E,$BFDD1032FE7A0670,$DC8E47C3EAC7E1FA
    Data.q $89389D8E00FFBBDC,$91FBC763A2C7E3B1,$326118B437449C9C,$474EDC1326CC2010,$4B409C873F9FF560
    Data.q $86DC41C3A709DB98,$1D4FC248D1B30CC5,$6E24409081640EFB,$FA2222E65B7258C9,$41291122152D2D22
    Data.q $7BD6D8599A49F113,$0B6B425499085889,$808682A86CE9C822,$5014AB56768327A4,$52AD3348AB50952B
    Data.q $9173740F2E528721,$12643112A4E85A43,$F16DC1FF3222A431,$F88458896086D213,$FF7FA084868458F8
    Data.q $82CBCF80A4A6A468,$9D08F9B15C764244,$12B53662C2001B56,$DCBC86005762DC96,$0814CD3D7D280A96
    Data.q $6DD85CDCFC86C3A7,$06363E20C4C6C436,$C09D8E471D38BFCF,$1BAED775B10743A1,$6DD853407DC6AA23
    Data.q $1026FC50B6E23969,$63D1E8EAB05FCEDF,$85389D8E10F07038,$483DEF7BDC4ACA8A,$6CD98064C986494B
    Data.q $C584A95A806F5186,$626C09521D9B8262,$4038BB767E9AB6F1,$592602E9D7A6A150,$162C4091264190AE
    Data.q $EC8D234F83E42042,$547FA3C424242CCC,$443666076767643F,$5A5A09122D91D202,$056FC5CE04FED9FA
    Data.q $A70AD20A9528E701,$AC44321EF969F5FC,$E3A7214990A0CB90,$F33B30234B711284,$5E869E9E90CB9721
    Data.q $4E483E9F4FA17ABD,$043444265656424A,$9E830F7981152955,$553768348E08DB53,$F9F3C88077F44660
    Data.q $FE8F1F1F10DBB760,$4FC19E67E9E1FAFD,$79A13F23A7E14E27,$98FC4EC6239BDECF,$12FEEB5B476AACEE
    Data.q $76386A2D160B2110,$4E9F82391D0E38FC,$3DEF70231188C69C,$09A3661925252377,$B55A11A32619B316
    Data.q $A2BB371E058B560A,$274DC127B4110287,$4A84056A69F8499F,$1025413608F920A9,$2A57BA7C96334040
    Data.q $39721F0102163A2E,$DA1264F94671882D,$659BA0A9439326D6,$35C5B2825D62A3D8,$CC0CAD5A8E50C9A8
    Data.q $D455860604EADE7C,$C7D2507E9CE42885,$54A14A9520891121,$6F4FA7D0F3E7C1CA,$90A9125244F58584
    Data.q $E86A34201682048A,$FAB65C8681127D38,$102C5ED3B8201B79,$F5C8EDD870058545,$EFF4048484998691
    Data.q $1D8E14F53E4F0FD7,$FECF604EC7A3853F,$C30C97D27E331803,$E2565BF9DC30A774,$A6F168BC5D0880B7
    Data.q $E13F63A7E24F2713,$FB8E595E512793A7,$B03049498917BDEE,$0A1AF4E806CCD7DB,$44A86C07F357EB84
    Data.q $8566C24E4938AA36,$D3656C3496B342C5,$D9D9097506BA81D8,$418D8D88790BE059,$14143E42C4024262
    Data.q $82B37290DF9D1108,$E84A55A805C0790A,$DB7D581702E82AD4,$19528400275BFF0B,$8885C4A4CB91EC68
    Data.q $48832152837C8145,$11EAF45F445447C8,$A113A4640484848A,$AE436C342011972B,$65B880ADC48F75B1
    Data.q $AA42A2E288071D6B,$171710DBB760F221,$A7A9EA78FEE8988B,$12753C9C49E4EC71,$BE93F1D8C21E0F7B
    Data.q $D82015FC3A468BA1,$D3C6F168B85D082F,$763863F1E8E34E67,$1E078D1E8F4614EA,$62A83A58D8D888E8
    Data.q $202BFCC5AB7E9808,$5172EDC0F080ADFC,$1029EA5AC96B611D,$51742811AEA0556A,$1FDD1D10F3E7CD1F
    Data.q $D250848A90098989,$B2BD36CD11DB1882,$63A70113794CB430,$15351F8FE1A8D33F,$42871F4B460A6A9D
    Data.q $2EB3EAB683EE232E,$A1022A2A20122C4A,$F4F48F1F1F11423D,$121A100E02850834,$DC0D5670CD370465
    Data.q $B8F5E1944E5C880A,$9B0C545C511A3260,$566CD83CFC828AD5,$CF16363E2344C4C4,$538D3E9C4E1CFB3C
    Data.q $3B1843A1FF624E67,$5DD02BB90C37E27E,$87F368DBB06C7174,$6773C6E17F379880,$E4FC70A793F1C67F
    Data.q $773B9D053A994C69,$C59FED6044646442,$18D820587F240A6C,$F080439FC1F7EFDA,$6DD410293B703C7A
    Data.q $3AD691DA122EC5B0,$D27CAD314D465CB9,$C4242468E8989986,$3AF968A943112243,$9B56F2E5036684A9
    Data.q $A3D14F7770300264,$101ADCFF67A3BDFF,$B472F4831AB05AD6,$4245882AD46ADB34,$48A1A1A117D3E9F4
    Data.q $2E42051A7A478F88,$EA30B4E9D3CA6C0B,$CB446F40B6D7D25B,$03FAE5F080ADC6EC,$4B034184D98B0CF5
    Data.q $AB0F9F9051993660,$2524A448C8A882D5,$67E67538198CFA61,$08783FEC19F3FCFC,$5E986186FF8DC7A3
    Data.q $B4B714B50F795B34,$DDCE3F0FC409BF12,$1A7D3E9C45FCE178,$88BC2FF3C19F4E27,$30AEB75BA27ABD5E
    Data.q $4998B02CDBB0F5E8,$B8990AB437A0C7C2,$4E9C170D225ADADB,$B4EBD080707FA93B,$11211FD032950804
    Data.q $F881750208142109,$122C40C6C4C438B8,$2153FD45AC87FAD3,$BA381490B6420AC9,$E9D7A12724F42020
    Data.q $805BE8A02D75DFE8,$0AAC5AE9D0B569D0,$8686424202B7221B,$E10F3E020AA0BB49,$121227B3D9E861E1
    Data.q $05889106919191E2,$D11BD381A5054542,$EB4F20CDBDE5313A,$60C874398FD914C4,$6AC1E7E7E4060C98
    Data.q $66656470EF4FA335,$E7B3E9C3DE77EDE0,$20E073D873D9F3F1,$E130C32DF7198D46,$608DB96FEF7E0CB4
    Data.q $7EDFD7C7A3E6B820,$F67B384BC5E2FEBB,$37BEEF167CFD4E1C,$DDF77DC3F5FAFD13,$A81ACDAB0F41830B
    Data.q $738216D6FAF4185F,$B0A8D9504D92C2B8,$540EA5D0B40C1A34,$0835CD069CEC653E,$B232202526240285
    Data.q $20B62A541E7C042F,$016543BECC548126,$8DF805B5F8818228,$21858316D7FE9484,$1A100E4B095A2160
    Data.q $043423D1D3D3D235,$1999993D26F4FA7D,$A8D0142950458B10,$ADE34E66E04AADD5,$6AEDCCA355F8E1D3
    Data.q $250D9B0E1D874E19,$2A0E91B36EC00703,$24489061E1E10E83,$22E17B3817F9FD98,$A3F77B5D873B9ECE
    Data.q $4BE986196F98F472,$5DF8DB8DBFEEE9DB,$4BDAF9FE7F674220,$7F38F3F9FCE0AF17,$535235F57CE622E1
    Data.q $734342775DD77053,$9A75E83FC933560F,$E02F9F9D78370940,$6BAD1B566181DC36,$B4683AF5E8464C98
    Data.q $16225A1722E85A6A,$4FAA82693E56CC43,$619BA34F48C8DE9F,$DF3619E19082F414,$0AFC8197AD8B2A40
    Data.q $FFC0C919A045808A,$AD10D53506037EE9,$B49FB326225483AD,$BBDD6E8F1F1099A2,$444A4A48FEFF7FA3
    Data.q $6AAB711264165676,$192CCA903F4831A7,$DC9C869F22060BF7,$3CFCFC84D9B34FD9,$87E79B907AF326F2
    Data.q $F5E870B09F41224C,$5EAE5710B05DCC7A,$4EF36B61CF67CFC3,$08986187391C8F94,$087F1B71C8EEBE9A
    Data.q $1F07E663DE6EB608,$170BCDE2FE7F3B2D,$5D56586B95F2E22E,$43DBEDF689529503,$2766C3366AC3E020
    Data.q $31341C2D3A0C762B,$B02077731174E7E5,$92326CC201C5C36E,$E5C84AC04D5AF36D,$F0108F9262A54832
    Data.q $102322A201426AE9,$88B34C44990F109F,$E0A04C54874CC0F2,$356AB4252AD41CE6,$AD10106D210AEC74
    Data.q $B59402B0402DD552,$05AD8FA0A97B240A,$225749BB1A297606,$8684845F446FA316,$1029A9290E3E3E22
    Data.q $D96EC358E1A4F80A,$972B395AECB60435,$C341035FDE9DAA5B,$61D7AF40F6FE524E,$45E393B43240C970
    Data.q $37D132B2B22E5E5E,$ABA9AC1C9CBE0C3C,$3F33A9C4DCBF2FC3,$2A23A51BE6D371A3,$C100E41F711BA53E
    Data.q $0880B7F2C2568DBA,$FA733BBFB7ADFD7D,$95CAE12F17CBB5CC,$0A0BF21B65B4D86B,$1E213120F73DEF70
    Data.q $CF812D5AB2649A0E,$593D09CFDF4D4E1E,$9504968D75A1E11D,$EADA4D91DA08E889,$E22D89DB236C8164
    Data.q $FBBDDE88949C9109,$0E5CB82E4D9D9780,$048CEC84B24254B9,$F86CAE8D24A92B37,$9FCE15B95B342C18
    Data.q $508B8E6AB4351AB5,$0C2CA828C850A1CA,$94A14194AE50F464,$210525252156AB41,$B81489293719A421
    Data.q $C8C055B4541162C4,$B9A606EBB7477CDD,$56FC87F9B0497682,$51E837A746D22949,$C2A28F4183025252
    Data.q $0A3FDD19C8693802,$7E2763B6D8159515,$D589389D8E26E5F9,$266C3A190CAEEB75,$C4756DC50A61E205
    Data.q $7C5FE7B9FDD1016F,$BB5CAE97A391D0FF,$9F91C0E2AF572B8A,$19D2ED7438FC6E30,$5BB08D98B0212121
    Data.q $E01BD4646153302D,$201C9D86C1B75371,$034823A57ED81B02,$FBAD142B637686AE,$77BDE5A04102852C
    Data.q $2684858D8D88DEEF,$5909222419729482,$F12DA1032EE62429,$14B37A6A41F596B2,$9A86BAAB55100075
    Data.q $34659248E151564D,$210FB9A1B66EC0E7,$65C950E42A55579D,$422FB7DBE8458A90,$A9A91E313123BB43
    Data.q $D0E5C850F8F010A9,$D582AD4DDCA43569,$9B8FB47833DE7AD6,$0E9CB841CA0FCEB2,$3A143A1B0C16ADD8
    Data.q $F5E9300585C506AD,$C9227272408C8C88,$E06E37EB813F1E52,$73F2C970B09FE1E0,$1FA61860CD070345
    Data.q $77971510F7086E43,$0386D102E4FC2ADD,$E27B4DBA61861B44,$E57B38EF35B667C9,$7EA70D7ABB5C55EA
    Data.q $31B1177DDFB7873E,$68D1A07B9EFBB831,$1397246EC859B561,$28DA08CF539EBD06,$3165A823A02201CF
    Data.q $2847CD8E847F4919,$9311492377D19015,$92525216614231CD,$43A5A4644F67A3D1,$7D6CE74B41405721
    Data.q $5A6A1B038869AD81,$5366D2957FC8C4B6,$B23040456DE92DD5,$4205359C33D50C51,$12A52A1091621F01
    Data.q $710902956A049972,$EBF5FA1BADDEE871,$D0254A96B29A2487,$582AD4F41A30D568,$BC16585816DA9A69
    Data.q $CD25CBCEAA902450,$19027AF5E9411CC1,$F3C9122C8FBF5CCA,$486F784FA2912643,$BB9C33FB327C1225
    Data.q $DD8EC75FAFD70978,$CDCC9E3FF7F5F07B,$B96999D10292782B,$40A3F8EF2C2B1C11,$AEBB595D1AACAE74
    Data.q $FAE37197CBA5E4FE,$2E968B157ABA5C35,$91EDF68744A54A83,$48074AC5BB029296,$5ABB70ACD862C4EC
    Data.q $3614810316F7217C,$B99047542D586DD7,$6E1F89B3872D0D0D,$3F5FAFD304DD80CD,$469B2F0101EAF584
    Data.q $AAD010204A6A6426,$0FC85083DF607667,$C12429FAC60662CC,$2C4112224CECBB87,$B9D93A44E8B214E4
    Data.q $812644832E5487CD,$43423A6A5A42A946,$C949C90237D11143,$4A802450854F4B48,$8196840FA0C184A5
    Data.q $290EDC3C274E8695,$1E7E432D67C8658E,$D7AF07E95AF3F20A,$D011F28A8B56BD0D,$5392371E39754DD3
    Data.q $5E397C2FB7D11153,$C4DC6E3706B558AC,$7C66E37EB197CBA5,$8ABDBB5603ECE9F8,$0E8816095A85D102
    Data.q $1865B465D6DC4041,$F9C7FD8E4E6F61E6,$6F371E7F3B9E0F0B,$DB69B0376B8DC4DE,$3D3A478A1D290C76
    Data.q $C2B566C27A3D9E8C,$72E5C0B16AC070E9,$5E9274EDC3D064C1,$84D87657B6CB5F3F,$5A9B3161B75823AB
    Data.q $9C86CCC0EAB4EADA,$1676549C244ADF36,$7858430F0F0E0219,$487214A83C05F02F,$7C05083225483225
    Data.q $14D7607E1E8846B2,$B06EE02841F7B02F,$C9F011958E42396B,$10239692C2C8996D,$2B2390A9471A0208
    Data.q $DEEF40F47A3D0333,$54B4D484949491BD,$EF720A15287CF808,$57A49DBB4B492B2E,$55897A9A0572E3D3
    Data.q $4E05E7E7E437C968,$ACD85DC822050141,$854A950A561F0C56,$5FA23264C3064321,$84DC63C4242428BF
    Data.q $D4E0000F7BB9D809,$AF19875B535167CF,$2052E414204DB1BD,$F7E7BB7E372D31BA,$B986183B885AE080
    Data.q $3F8F83FD3232223F,$71B8DC31E8E474DD,$9E4F471372FCBF03,$0C4C4C425FD30BC2,$B80A15285EF7BBEE
    Data.q $DD78E47A8C980E9C,$CD4C48D0CDC81A30,$2ED06DC70E4939B9,$A836881545DB272A,$FD474152E2B35095
    Data.q $24CACEC8ED95BBC8,$342421857ABD75AD,$E022A52A0F3E7C14,$E5A7D86041028422,$9E8C98B02502B564
    Data.q $2B28BEBA6CB2B2C0,$225CBD8B497BE82B,$5643215284244486,$77BC2087BB420646,$0A9A969112929238
    Data.q $41830E4285079F3E,$66760630542CDE4F,$1638440800BFC5B3,$0A739F20B0A1E7E4,$23E1B3EE4F905850
    Data.q $874B4A1D7A0C444B,$FC8BC72723B761C1,$4546447C04085CBC,$C3DF779DE0142C40,$381DF60001CF9FA9
    Data.q $4794D260968B7980,$65454549D4EA7757,$E32EA3FCEE2020F7,$4DA6D36CEE61860E,$96E361F95E338BD4
    Data.q $1370025D2F17EBE6,$608B85FCC55CAF17,$262377BDDF70E830,$D3861CE930549A26,$823B677A6E8980E9
    Data.q $45D4111D2B680AD9,$A12D58A8BA733165,$84212B110ED60452,$D23A4666402C4F90,$BB5D1C3C3BD15352
    Data.q $054A54124A6A4176,$041162A42122F9F1,$654CF64131DD3E02,$0E5ADFE2DE64EAFE,$22257A8645954DD9
    Data.q $7C4241BD64255A22,$FB7DBE82ED75BA1C,$E06969E909392922,$37D03065CB9078F3,$3EDC000829BE9B85
    Data.q $B8A016151410D6C9,$0B215158F4D5B0A8,$2E5C781CBEFC1E44,$520A351E8C3AF418,$6ACD850D86C314A9
    Data.q $E0A3A2623C424241,$76B855CAF960E7F7,$0D868EBF5FAE26E3,$3C18DDDFD7C5F09B,$31E1B4DA6D97D864
    Data.q $7CD33AB8169BD30C,$440C19612B440B04,$C261860EFCCD4E5B,$D66B95F4E4F13DA6,$F5C00059ECF9FD9E
    Data.q $9D8C2EC765B037EB,$87C1E27AC3BD1630,$0AEDD783A74E821E,$B152ADF41A33D3AC,$D370DB8E1881DC39
    Data.q $A8F20C0895B067EA,$60DB9EB59721C449,$5353523A464642DD,$8CEA748F022237D0,$2E931212207D3EC8
    Data.q $91973671E5028891,$7D6B2C2EC553D9CD,$754D8178641B3832,$565E065C8518F6EC,$49087BA17BC3C216
    Data.q $0D2D2D2324A4A53E,$A34602A54A1F3E7C,$DC8214DD79544C81,$94646093A7C82680,$31406038363030B0
    Data.q $98B9FA40C6280C06,$E10D13E41616128E,$419290C468C981CB,$6C31DA74E079F1C8,$45464472142810C8
    Data.q $34F93F8F153D3D22,$F6733800083BEF76,$CE1FBBC6AB2E162C,$9861897DCFE39D3A,$1FEF7102E6BA9A0C
    Data.q $C30CF688070DA201,$85BCC0643C1928F4,$6E3718743C1C8F8B,$F8F8F3D9D3FC42FC,$FEFFB8C54990D9D3
    Data.q $27AF1C80909090FB,$0074B6310B8809A0,$D1A4B5E81358EE71,$20C825AA4B5EAB46,$5FA12D552926290F
    Data.q $D23227A2D05709A0,$ED090831B1B11409,$545454411E9D4E8E,$8711689BED190C00,$6BA0EB80836B5FFC
    Data.q $99AA0510214D590B,$D6E89191510F1E7C,$909F11C2C2C23BB5,$4064666454D4D480,$366CC252A9421420
    Data.q $003FBDF4D074E5C1,$1400B90A01614141,$1C0E063171606317,$01C0D06206834180,$E28C501C0F3FD0E4
    Data.q $D72F2014161422A2,$931E830607AF1C8F,$1188C42458814EA7,$424A4A482D59B065,$7CE613662C2C4C5C
    Data.q $D80004BC5FCE1DFB,$BC6BF2F93E2F67B1,$9CB2A54ADD95E338,$067F8F440A349861,$243DD23CC30C0E88
    Data.q $DFADD49F59C3F324,$5C00079FCEE705B4,$51188D0DB50D7AB9,$E1E9D0BD9EB08E5E,$A9903AD4101EE44E
    Data.q $8D5AF056E14EF222,$5AA4E5DC394979CB,$A75683AF47907822,$0A144B1D22AD4A85,$0408428426E68489
    Data.q $12326A4A766740BC,$DD6E81191910E312,$1DEF08CEE74BA2BA,$D202048804A4C486,$8997612FAED9C70A
    Data.q $95264368DC16F271,$E10E3E2121E7CF80,$787841090908E1E1,$88989891A2626238,$A34696F74094B4B4
    Data.q $817DFAE508368581,$B8A03A5F3A22C271,$7200E06314070308,$20C949440D064BE1,$304B83C184192E0C
    Data.q $E0C12E0C861064A4,$06830834192825C1,$F273F222E280C00E,$02B2B230EBD3A0F3,$9486371E390DBB0E
    Data.q $344C74422C44820C,$6C04FC7E319353D2,$C5C4DE6F370DBADA,$FDDE357978B1974B,$FDF9663D1C8C63F0
    Data.q $619926186267DFF7,$B8CBAE08057F3E98,$D369B4DA7B986193,$6D557B7E9EA7C9FF,$CDE6E28F4723F9DD
    Data.q $14F27A381379B89B,$1E2932641668F83E,$080FF7FBA223A07A,$41110E5F08C9B345,$9C81100B409DBEBF
    Data.q $060C25E48388AB44,$98115406767A743D,$478282BF24CB9714,$94929152D2D2FEC7,$2046464468D8F888
    Data.q $5D04791E9D143434,$BFD0BD9EAF4576BA,$0D214D4D48A9E93F,$2B236767662C54B2,$484C482929A90D33
    Data.q $24243C92647EFF40,$1C3C3BD142DD2104,$6494E8E923F5FBFD,$F150122842666664,$524BD7876EDD8068
    Data.q $0600100F440585C8,$0834192881C0D062,$86097064304A4B83,$D8630743A18C1E0C,$A60C87433ABF21D0
    Data.q $161422E280C40C50,$F8C261F7E38B13E4,$0A355551B2F3E0F1,$8848C94949019366,$7E5F67C664D5858B
    Data.q $007FDC98A8E7D385,$BDFB7F5E19FA7C1F,$230C336FB9FC739F,$0B7EB7169A261861,$96159B349517DF88
    Data.q $A1C566B4B0505F9F,$0005C2E1713BCDAD,$11A1B6B1572BE5C0,$1E24645FA15746A3,$EEC092A4C821E87E
   
    Data.q $BB8385070DC7AF02,$4B88E7D16DCBD9FF,$2C0B16ADC59483A7,$3492D5A7543096A6,$3681A420FB4552B2
    Data.q $367E0F80BE0A163B,$2252624EE0E83E8D,$968237D510626362,$DCE86EB76BA07BA3,$DD6E82E974BA0BB9
    Data.q $ADD6E8AED76BA2BA,$DA1CF816EB75BA2B,$3C3C207A42421BBD,$3FAFDD11237D110C,$C833618DC9E3E3E2
    Data.q $81AB5685264C9644,$50F9F3ED076E4AD5,$1C0C22A2E28F9050,$60C9440D07030030,$28743A18C190C00A
    Data.q $18A1D2D28A1B0D86,$36514BC3E18A5A5E,$1D2861D29C0E7C9C,$D040A60C8743143A,$0D313F8F1E837389
    Data.q $A8A286C3A518B112,$B131B10F3E7C10B0,$B15329C4C0CCCEC8,$2E26F372FC36EB71,$E331ABCBC58AB95F
    Data.q $F3362FF3CCF0B78D,$E43404618672BC78,$BB8CBAC100CFF3EC,$640F03C0F2E98619,$B6DB4DEAFDF333BC
    Data.q $06FD7EB823E1E0E3,$E24F27A389BCDE6E,$5BA23262C19FD9E3,$369C17ABD5E8CED7,$E45AB4E83EFD722B
    Data.q $B70AD5A7ACC8FAE5,$96C86737706349DB,$A184089589BA55CE,$0B671A52264C3366,$2D94282BA90D1A4F
    Data.q $E7CD85D936D49050,$4E9E9A133A1A66D3,$1F1F111312927B86,$2246454468E89887,$BD1BDDE9F45F4FB2
    Data.q $F0F0861E1E11C3C3,$7DDE9F470F0EF430,$224545445F6FB7D0,$3121C7C7C47F7FBA,$424F76E4A9690931
    Data.q $068D1A14995200A1,$8F1E1D874E099366,$C02C2A2879797907,$0620683418C50180,$D28A1B0C10220C97
    Data.q $C3650C3A56514361,$9446231C3656514B,$51CBCBCA047CBCA1,$8C08C479FC823E51,$969470D959432B28
    Data.q $6608B03251000B0E,$E3D7804E271311A3,$5051AAE8C068C981,$5272478F8848642A,$7BF6FABE0F1E3C12
    Data.q $3DEEF343AC4B399C,$EF5BCAF0F7DDED78,$7DDF77F9B0C864A0,$FA618674986189B7,$04C9D84CFF422053
    Data.q $0C323A9BF40E8859,$1B8D63F466355313,$9ECE0F7BB1DA9C36,$B2DFAC15CAE25AA3,$D232B214FD3C4F15
    Data.q $C22626242753A9D1,$E7E41735F607F3EF,$EDC1B0E1C3D7A8C1,$96FDB0F622AB7D6C,$611A3161D76B474E
    Data.q $81C35E8D1A819036,$7D68268925CF65A2,$112D764E08082441,$DD1D7B783534E8BB,$A0484C4BA76EC756
    Data.q $6E469E9E9052E91B,$6DE5222441E7C700,$CD9B08C1930346AD,$F9072FBF05DBB706,$A0C6280E284479F9
    Data.q $0D86306432188192,$3E1B2861D2D28A1D,$51515E8B9046231C,$C4ACAC8C0ACACA8E,$2A056564672D91A8
    Data.q $7C30CA231C082B2B,$43A18C190E862978,$2969786072E9C286,$D4C0204884AC8E46,$9E9E911832605329
    Data.q $3C52642804C4C48A,$7E176BBED84BE2FB,$5F0170BB9C17E5F9,$5E02F73C4F173F7D,$19EE9D1A23B5ED7A
    Data.q $205024C30C146186,$31397FD236E4337A,$DDE98618FB885AC5,$5F3ECFECD9375BAD,$1874381C21E0FFBB
    Data.q $73389C00015F2F97,$4B83C1845FCDDF16,$433B9DCE81191D10,$020C972F20A21424,$B3B9B1B08DD42D5B
    Data.q $EB8B7DF8CB7E68D5,$CE8E9874C93066E0,$9B66A0AB55A16870,$065232D2C0B2155D,$511380839A905027
    Data.q $8C867903B27B02F0,$A12D199999624596,$5E24DE9CA415BD26,$4E05AB1A8192D5AB,$7EFD720F1E3903A7
    Data.q $80180E0618101414,$9420B1874A156A12,$302A2B231CA2A2A1,$D46256472302B2B2,$A3D1851AAAA891A8
    Data.q $851AAAAE7E9A30AB,$E502B2B230A35551,$CFBF06192BA823E5,$A3E8F63C1292928F,$916371F8C0CCCAC8
    Data.q $529216767647E79B,$11F0F86165E02053,$E3CF17738D5D5C58,$85E678F586DA8026,$F0E8626FEBF2F097
    Data.q $C31F01E0781ECB11,$08CBA9E261866230,$060EBA9C3FA989A7,$C4C30C4E88073DA2,$F7BB9DC5F9349C4F
    Data.q $389C4E30E8703D9C,$1BB5DAE3AED7EB85,$1F7CCF6F1FB3DE68,$6840F47B3D05AB76,$0B0B0A1D7AF42868
    Data.q $EB903A72E1E837A0,$B7B4E9C033AF41F7,$861B04038784AFBA,$D9816AC583613D12,$7AF5E8060D6D8742
    Data.q $522A2ACD21A0A7DA,$EC2BC6E464CB92DC,$724285926B38156D,$39F2169A9B210CDF,$39F6075B7604167F
    Data.q $609D9920AD74E428,$E1B13249172E10EB,$AB108743A1861724,$565472F2F2865650,$E9E1724AC8D46394
    Data.q $198EC6347A331FC5,$A33198CE5B63B183,$44AC8E46146ABA31,$51432D28A81188F9,$27E9E114078A1161
    Data.q $196959462244849F,$26405F31021B0D86,$C1F078F5E1D233CB,$C00011C8F071B327,$C7DEF7CDE28E9FA1
    Data.q $3EDF37D5E1A747C4,$A1A30C30661833A9,$61862898619E22EE,$6EB7170FFAEA68C2,$30C8E88145DC6915
    Data.q $6FEBF1985858544C,$1E8E14EA713DADBE,$6BF5C59CCF9F8E3D,$3436D445FCEE71D7,$262A54829FA789E2
    Data.q $282D5AB0BE889E85,$E9DB85A75E802A2E,$0E0EBD06073FAE44,$87B05AC5A95BBB07,$37D0370DDE8D850B
    Data.q $D7623727A0C03461,$E52C345468D0D469,$C26E4FB0DA0DC66C,$DF5A4891EC4B1242,$564EC4BD6F4E45B4
    Data.q $CE86858B566953B1,$0D3E43EFDF8F8564,$181CC180180C0729,$231CBCA2A1959446,$46AA146A35512B2B
    Data.q $CC6E31A331D8C28F,$8DC7E3163B1F8C18,$F18F184CF4F1F8C3,$5D183198EC62C6E3,$4564624723918555
    Data.q $09494946280E0639,$0C0A14A869E6799E,$9720A355D18C5018,$0CCCEC89919D9048,$3474E2F73C1AF5E8
    Data.q $FCE2AE572B8ADE6D,$3F18F7DDF3988BC5,$1D0C55E330BC51E5,$D4454EA753ACB65E,$6D9369222053245D
    Data.q $8D82060EFE533FD7,$8618DD154DA5EE34,$7B5DF1F4AC3A1E49,$9E4E0CE67D3A9EF6,$95CAE1CF67B3853C
    Data.q $5E2DE634F27638AB,$42CECFC063B1AA8A,$E5C344C4C4374868,$0E9D061F20B0A074,$761EBD4614B1176E
    Data.q $F0DAB574E29CDD0B,$6DD8085741D45812,$3A262C58662CD856,$D26CED03524243DC,$D14A87DAD3503568
    Data.q $E0691007394F4F72,$1556BF6021AD6E46,$82974EC1858A07B4,$025CBCBCA15AE979,$6086430CB1317143
    Data.q $12391C8C0A860078,$C20268CC6246AAA3,$4C78C261316371B8,$84F3E4899C81309C,$C40238FC7E31E309
    Data.q $81A0C728ACA851E8,$7C789E3862365003,$310A8B8A1D3AF41A,$B2F072552838EC7E,$C7255A86CACBC1B2
    Data.q $9C5AD56CB19349F8,$6582FC6FD70E7B39,$309813DA79312B35,$8111FA61799E1A75,$61864630C32CF840
    Data.q $83D73EDA58881478,$A726E1906E9FC403,$F4C30C43CA61A1EE,$1FC7D66ABBBDDEEB,$CF9FCDD2F178BC2F
    Data.q $CCE671A753C9C39E,$1E0EFB197CBA5C59,$86C3A18D7D5FA7C2,$4821A1A1153D3321,$416144E5C7838F88
    Data.q $F2274E5C1D3AF43E,$5DDB2D4C9B30A6A9,$1D38779773710BA8,$1A06BEC08A5907B0,$8DC475685AF4E881
    Data.q $2C08A54A84DCE868,$BADE55FCDF065547,$5F9A40736F4D4EC5,$4D44B481B5810C29,$830C09F20A0A14FB
    Data.q $2395918E50C10606,$6346633185555551,$261C7E309831B8FC,$D26227138980984C,$4F2612693C9849A4
    Data.q $C6E310291349889A,$02B23918D1E8CC62,$7831E8CC62068325,$2A28F51930A9D1EC,$AAD1A0E30984C22C
    Data.q $28E5295291B7A7C1,$E1C3CFDF37C0AF2B,$F371B026F371C763,$1AAF28F3CCF93C56,$97C73376BC66178B
    Data.q $8618F31D8EC76DFB,$7D10734491775251,$6EDD5383B8C7536E,$7EF2C2C1B64D5BF3,$50A2930C33BA7BEA
    Data.q $7ABEEC369A9ACA28,$38A140BF9DCE3AED,$0EF36B63CEE70B83,$80180F142CD1F7BC,$C48A11ECF414B4B4
    Data.q $E7E4140E9CB83884,$3F233166C2326CC1,$A19C6C0EF6503F2F,$52C4ED3A70817060,$4CC29E68D9B06DD8
    Data.q $7419DB3744C9885C,$D6E46FEDA5A628B4,$92303B9267356A48,$6390EFAD531DA0A7,$1AFB029A36601834
    Data.q $91D7DA6E3C274E5C,$0A8B8A1E7E4147EB,$511C8080C0D06831,$D8C48D544DC5BC36,$1C09855A9E31A331
    Data.q $0993C98C9E4CA610,$E3F184C04E271310,$C0ACAC8C18EC6E30,$8C64CA75318321D0,$064301A3461E3F1F
    Data.q $34E9D0D198CC6097,$865C950448976F64,$B12FF3EB30436192,$7B037EBF5C3EEF67,$F86067D373C01DF7
    Data.q $3D1833F4F63C2AC8,$678CFBBD3EA6FC6E,$ABA69F0C30C0C618,$1FE721B928216F13,$8E8E0744AD66BAEE
    Data.q $7B7DBED516129878,$DCF9F8DF53A994D1,$8BC5C0DDAF57F3F9,$753E9C29E4E27117,$CDE6D3459ECF6706
    Data.q $885C5C50F79DE378,$710BD5EEF454F4CC,$D91194C8DBB071F1,$972E1FAE5E45674E,$71762A502E834613
    Data.q $07201AC820118596,$662C58D53687E6BB,$01A306C3432DCD98,$79B40EDDAB460A7A,$3A7BCEF64EBF7037
    Data.q $60580967258CCB6D,$20A3F3E8135D8246,$1E0C00E07030C08F,$88D3049186C3183C,$8C32D451861411F2
    Data.q $85126131E309C4C5,$009932994C64F261,$09889C4D26126931,$1F28D198EC63C613,$ED313C0ACACA8651
    Data.q $C566D5852F0D9431,$34146A355043A1B0,$CB50A5498049355A,$9A3F7782525818E5,$15EAE5703BCD6D85
    Data.q $1DF37D5E13F23A1C,$7809B8E5428C5694,$D7D2A4494E17D9EA,$CE461862E76BB5DA,$FA41A930C3264C30
    Data.q $2B82021FE504F7E1,$8619DD371DA41F2C,$D9D3E38FA7D3EE49,$AED71B89BCDDE7B3,$F8F471170BF9C75D
    Data.q $9CCFA70A7D3A9C09,$6DEB795E13436D46,$7D132B3086280F14,$8C9868E8FF41F4FA,$C3B0E9C3E6151406
    Data.q $15B90E57C2D33664,$83EEC6CAD810D1A2,$666259050B040D6E,$59130BEA9985AD63,$2D674F5E831EC3FB
    Data.q $B2FABBAB5D1CA1D8,$1D3B0EB2EDD8659B,$6E41E39391B8F3A9,$80E060141435CD2E,$52F0F86287222A62
    Data.q $8C0A8ACA8651188C,$262C6E371860451A,$B8B42713898F1F8C,$6891349A4CE4C988,$CA146ABA31E3F187
    Data.q $3A3C04C27130CACA,$70E9C11714062A75,$150F993979455C92,$4A830A951AF1A593,$ADC6C23E0FEDE306
    Data.q $7E3D1C25D2E970DB,$472BC318FACEEF1C,$0BDCFD3C28E57861,$F83D0F37EF5EDCD7,$321D6A3A30C30960
    Data.q $DCBBACA4E1887EA9,$7583AEBB77F6C1A2,$1A9348ECB08E3B44,$1E4E4E48CA4FA9DD,$AEBC1491B7575B5A
    Data.q $4FC8F870E7CFCCE2,$89389F8E04FC7E38,$60EF5BCAF1EB8D35,$D7E8458890C190C8,$1529509191510A2F
    Data.q $D982E3CB87CFC828,$83E7DF80EEC38264,$A84DB02CCC0F69CB,$6ECACFDE87B071EC,$0E416D50B36EC1B7
    Data.q $C0A6A0110E4FD6DB,$D18464C601035D26,$19F93C31B9022C44,$B0B384E0DE8D9B0E,$374445C5C5144683
    Data.q $3744A1D2D28C1E0C,$3B1D8C2AE8E5A1B0,$21E91310082AE026,$6633180984C27242,$68F46631CA2A2A34
    Data.q $428D555414E8FA3C,$605456578B292E6E,$81265FADA42190E8,$61B0C1AB4184A94A,$DCF6705B2D8604A5
    Data.q $F67F1F0C7A3E1C79,$A35188C78EC72A05,$AB2F0E9434EA7131,$6630C3154BB5DAED,$9B7890FD53E0B75A
    Data.q $0BBF0FD1B7BDD484,$DD1B71CDDC6DD704,$77624618658940A8,$0010FFBFDBEDA638,$C69E4E270978B85C
    Data.q $1C71D8E2708703BE,$E6F09BEB7502713F,$8D5A1CA23651F7CC,$44888C8831B1710A,$3662D479A0766676
    Data.q $34D7643D7911D606,$02DDB3906CB5FA1B,$ACAC2B366C42E208,$69670B21E19334F0,$BFE8E9DBA264D998
    Data.q $937C7BD95AB0CC5B,$F21813C2B40AEB9F,$425C186F902AA169,$CA81188F9430C3AD,$1035B2351A8C0ACA
    Data.q $30E33810FD13C7E3,$C49C92565468CC66,$9458DC7E3113C9E4,$85450FBF5C821B0E,$FD73720C663B1885
    Data.q $56129030E8F365E0,$93F0F895151509AB,$F3FCFC36EB79B14F,$F67D6610E077D8CF,$1371E8C04DC6AA05
    Data.q $DAAC8C5414D26630,$2E30C338F5191515,$775364C30CF9242A,$122DDF71770B7711,$CF9556F3B6687F52
    Data.q $C5E8814CED42A8FB,$9575EDF6FB6A4C30,$D4F9F99CCE339515,$F8B399CCE0BF1BF5,$3F0FBBD9EC31E8E9
    Data.q $61A24F27E3863D1D,$63551B359CCC66E3,$19392D22B361C2C7,$CC3C7C4243F5FBFD,$59B360F20B0A1366
    Data.q $8F2009A6E1993660,$074EBD0CC58B05DB,$E18012CDBB08C98B,$96E9D8566DD84056,$656D6ACDA11D7639
    Data.q $8E89BB0317746C41,$B0E46E22724965DD,$47C82FC8B9792D4D,$21841A0C974B4D21,$1F0C50D874A30783
    Data.q $431881ADE5E51C3E,$2AE8CE5B6371CC43,$E761A28D55564E12,$1F20B0A394565478,$A8C70D94463F7EB9
    Data.q $891421AB51A12351,$F5E0A956A1E83460,$F39ECC04E27631B8,$3F33A9C66F6CB60D,$27D67F783DCEDB63
    Data.q $8C9C4DC632713B18,$1E8F2984C34E8F89,$76BB5DA97CCCC8CD,$341910298855D479,$677E5D1744E188BA
    Data.q $55B887EDEFCDA31E,$E2513A482A1EE23E,$4EA753AB36F8D17A,$9F3F07C7FE9FA7AE,$71382BE5D2F6773D
    Data.q $BBED8C3A1E0E24E2,$EC7A3823A1D0E377,$F9BECF8ED96D3638,$7CBC82869B1F530E,$5FA2C6C7C4424488
    Data.q $7DFAE402050828BF,$77814C5AB0BC7AF0,$CD82EDCB81EBD7AB,$F65D9327DE898662,$6B022851B5282EC9
    Data.q $D86B44ECD8803905,$0E8A16EADAC41603,$F3E390C09142BB27,$F90505CF5D27EFC2,$05A4B242222E2A28
    Data.q $1C8C0A8A88163288,$AABA312351AA8955,$4565428F47A4A48A,$2A3555502A2A2A05,$A0C944A8ACAA9090
    Data.q $31716063F5CBC881,$552A5AA8131E8CC6,$A8B0B5BE64F5182A,$582E3F1A7A9ED318,$1389E8E376BB1D88
    Data.q $167F7ADE3369BF58,$893F8FC98A9E4FC6,$9E8F2984C09ED329,$BDDF77DCEF4C9A34,$888C30CA41CE6883
    Data.q $17455BC9D9B81D63,$BDE5C4EDC8617A7F,$30CD181283D9711C,$A717BECEE773A08C,$7FE7F3B9ECECFF4F
    Data.q $DD84FC8F871E7B3E,$DEEC66F6CB61F6FB,$AEF3471D8EC717BB,$FE9B9E0968B798DD,$213464C297874A0A
    Data.q $5A8D1BD77025352D,$E84E5DB87C82C285,$3EFDF80E9D383AF5,$D1B36EC3B0EE3532,$8A0274AA26F4129D
    Data.q $0961ADEC282B410B,$44FB7B09B565232C,$2E9A926BA9925E1A,$2801C0E061DA202C,$5230E94402D81929
    Data.q $151515568A411CB5,$28E1B288C32F2F28,$A2A8D198EC6116A7,$65FCE943A1D28A35,$6565118D198CC62E
    Data.q $9B30848B10A54A90,$18EC3A70B56BD00D,$CB137F5F97815E51,$E870FBFDDEC6AE57,$BEAF16BB58AC11D0
    Data.q $7F1E04FE3F262EF9,$7E4C59FA7B4C19FA,$5DE1FAD58B69DA6C,$639C83754255DD77,$BBA8C9B926256E1D
    Data.q $2B7320DE9FC5D138,$7EA70CB8904F7971,$5DAE974918619E2A,$9C4EAFD5E5795F0B,$7BD853A9C4FE7D3C
    Data.q $9B0D83DEEC7620F0,$E9FE1C0EF36B60B7,$D6D72B0FBBD9EC27,$9349F8C43E0F9DE2,$A4865CB90F905850
    Data.q $312120C746C464A4,$70F9F9051E830601,$CFAF02D97BB45DBB,$99272EDC3F5CDC8B,$29930E164DC362F8
    Data.q $DDC4A4E5BB7BE8D0,$D34FDCB447CD5BD8,$BFA4D3D367C3181B,$E0E8609707B59681,$1B0D8608643618C1
    Data.q $21D0E8608643A18A,$151508449C3E1B28,$8C2AE8D544ACA8A8,$3DB862E280C0ACAC,$15557461E416142E
    Data.q $4083A74E808C47CA,$0C5B30F4C70BA020,$C31F47A4C22A2A28,$60361B75897C5FA7,$7E0F6BB1D84381EF
    Data.q $9E06FABD2F04B45C,$78E985E3FC05EE7C,$CF2789F53017B9F2,$CEF3BCEF4F8E1DD8,$5151861958C30C61
    Data.q $1D638B26186420EB,$F875A8FE4787B9B8,$2141DDC4AD7040A3,$E4B7EA3F624A0F68,$A717C5F8B9D23C8F
    Data.q $8F87B3A1D0E0797F,$FB79B17B3DCEC31D,$1B4D8D1EBF5BAC76,$18743C1C01FF7FB0,$E1E61F9BE1379B8D
    Data.q $6E12B2BCA3A61799,$49298910A11213B7,$74D9127241898D88,$981DC7AF07979057,$2B83A3C85DBAF48B
    Data.q $B36615AB5603A72E,$5A48528CAD131619,$B639AC0886A96A86,$C860674E5D6C0605,$146DD4F9CC76F836
    Data.q $85450F20B0A3E414,$2B0C45C9252C9C85,$AF2CA811B2F2861D,$2297874A39794540,$858503A74E0F2F2F
    Data.q $0F86230A351AA885,$9687CF9F03AF5185,$2395E5C8CDB052F6,$E5D2E1606F6BD2F1,$43EEF67B19ADBCD8
    Data.q $F16FEBFCF80DFAFD,$E2AF19F9E16F1BD2,$6067D3F3C75F57C5,$B35D3BB29E4F13EA,$838C30CA5F6FB43A
    Data.q $758E3230C3351861,$A1F350A0E88B2360,$696FC404BFC9885B,$44AD46112D1C8E89,$63BFBFEEA98ECD34
    Data.q $79ADB59B4D8FA3D1,$8EEB630F077DE9C7,$37D6D61369BF581D,$86DD6F363D6D7560,$A85DCEDB610F0703
    Data.q $1E29FC7C1F06BD59,$E9C295969409E27D,$19293520142C4074,$54838B8848D1B131,$F905851FAE6E4522
    Data.q $8E406500B46CDAB0,$E5E7E43CC2FC8BD7,$370905740572E3C1,$28AC09B96E93D0D9,$A0E24B16E6B6C3A6
    Data.q $0695D9781DC9DACB,$47749E4DA049E974,$186511F2C7FED097,$EFC197862312B235,$B2B29539216AC1F3
    Data.q $0B8B8A2C6E3F18E1,$D5A08A14214A9721,$86171E3D91EB0269,$9F03FD4FE3C52B0C,$F6C7AC35D62DF57F
    Data.q $2D160779A5B0BB9D,$6F6BC6CC9F87C6AD,$BF2F077ADFD78BBF,$7B1E2AF19C5E2EFD,$B69DE58B2613A9E2
    Data.q $6149C618660EDB6D,$8522AEA020EB5390,$33FFDA1DA5BF1646,$B2821B04056F2A7B,$112B537A388D825A
    Data.q $7F21D0E87750A14F,$C70DF5B56BE96958,$2D96C3737DDEEC77,$B1EB6AAB09BEB758,$C761D5D556257AB4
    Data.q $369A3F7FB3D85D8E,$7BFAF0CBA5C2C66D,$E86C30D3A3D2601F,$52D2D3403DE8B830,$C83131FE8B131710
    Data.q $AE6E4068D18748C8,$246C3BB0F9F9051F,$2371EBD36223A4F9,$DF802A2E29C04FCF,$E913D4C8B8240BEF
    Data.q $02D59B5BC1D0B0B1,$E1654B9D3E7B772B,$184501C0C7CFC82B,$0C30E96942DC4A5E,$761C0E7F7E10381A
    Data.q $6C3A5073F9F33C92,$097064A15546AA18,$AF41A5676073162C,$1BAF1E22F240C987,$604FE3CA62864325
    Data.q $D8558AF9609FC7E6,$E5633735B63B6DB8,$E8F88FFDF57C5A9A,$DEF0B387DEF0CFD3,$A5E3EF7BE6F0B387
    Data.q $ED4F13D8F1B8DED7,$88330C302F65C997,$D38D324241141963,$6CA9C83C5BADC308,$DF880A7FFFB8E076
    Data.q $3527A5A2A61E388A,$D8B8D3A56CD43153,$FCEE61F89EE9D5A7,$71B8DAB96CB61BED,$B5EAC56035D4D613
    Data.q $472C960B1AB4B058,$1D85DAEC763D435D,$9FBE137D7EA0F6BB,$1E93133BBEAF10BF,$F9F3E023E5650C7B
    Data.q $292365E7C0AAD5A0,$8D8B8831B1710131,$207D060C26567645,$900D64F12DD2F02A,$C9B992F5E2D4D02E
    Data.q $E2DB405318325CFC,$4C53243A0298A1D9,$715146280E0623E7,$7CFAE7FFC98B8A11,$DBB75199276EAD24
    Data.q $50D86C318A038183,$300180D063979454,$5A87C85CFA64CD9B,$6AD593AC40C186A3,$63874B4A0E4E6E41
    Data.q $631F87CEF027B4CA,$2D88D86E346AB2D1,$2E3F01BEB6A3B75B,$CD9F01FBBEAF8C5A,$7D1F07317E9F1AF9
    Data.q $DE57859C3F331B32,$C7D69389B8F2EB78,$D5206618664EC744,$C10C28CABAFA1A0C,$3534DC16BD046661
    Data.q $FF9F9667FDB43AD7,$B8E10CBD9B8AA25E,$EEC9283374AA388E,$07FEF7BC567B3D5E,$AFD6D42FEBEB6BD5
    Data.q $1562B658B5358AC7,$60968B7986592C16,$F347AE35D46AB2D1,$50BC93BCDED85DCE,$E3C43FF79DE217F3
    Data.q $6030A391F28B3E4F,$3265C8761D3820E0,$3109293922666564,$C4948D1FE988D1B1,$E41A356802050864
    Data.q $0A8A3160603078E4,$EBDE8474DECB910A,$F48DD14B27FD1D92,$4C98060C18060536,$A7CC969D5A47F6E4
    Data.q $62C0C02A2E285DBA,$4BC30C3A5E18BF52,$27AF5E87EB97914B,$A72E42814574FA6D,$EDC0326CC2D2D5F7
    Data.q $95156508A8A0A171,$9F27E1F0E7D9F278,$01BF5FA8E5D2E162,$7E13635D6335B75B,$BE03F77E5F04B45C
    Data.q $CC3CE3F77C7BF6FE,$3E35F39ECC7BF6F9,$FB7F5E57CDF664FA,$E7BDEF7351C8C57C,$3186188A6186729E
    Data.q $AA27010AA3606071,$40F92B2738455D60,$EE67F0EB5DF87690,$B85BA1E2565BFBEC,$D53A6832D3EA388E
    Data.q $CACA8A92FB7DA1D1,$EACD53F4582EE6F7,$CBC58D5CAF97D7B5,$AF2D160D7978B06B,$057AA4B1CBA582C1
    Data.q $6DF6C95127ABACD6,$62964B858F586BA8,$9819F4DCF0CFECD6,$EC0F2F2B2863D8FC,$48F80910D46AD678
    Data.q $62E2226252454F4F,$3131311FDD1311A3,$197456D3264D4948,$F7A1E3D7816ACD98,$9F2EA464D35362DC
    Data.q $979F9072FBE5CC8E,$BA4ADDBB07DF9F0B,$6F7A32E5C81AB4B3,$911621B3B3F034F0,$1EBD061A956A784D
    Data.q $63E7E5E5A8490B56,$D3147D4E26195958,$CB0AFCBFB30D795F,$6E360369BEB06A6A,$BCDDF1EAEB3586D9
    Data.q $CE6CF839B3F8F805,$EE7EF8B987E6F8D7,$EEFABE3E77377C7C,$785ED717D9FC7C07,$61833CC5B35EC669
    Data.q $49D269F8C30C2198,$9CDC0C0E121571CD,$287F92158F547703,$04F20F0440ABF8B2,$489EAE5B2A95D143
    Data.q $4B4C2F29485C0FA5,$59ADEF3BD6F89F4B,$3735E5A2F2FAACB4,$5815EAE2C1AF2F17,$158D5CAF961562BA
    Data.q $5D58558AF962D7AB,$79B0D80DA6868F5B,$6AD566A13635D60B,$31F59BDE2E77377C,$153A9F8C05FE799E
    Data.q $BE04A4A8312A2A23,$1224C802D4CC1F5C,$E37A2EAF723C78F0,$8FEFF74438B8B8D7,$2921C6252468D8B8
    Data.q $4C4E488949491131,$C89293121C625244,$42929A919253C03D,$64E9E91905352FBE,$B50254B904588D7B
    Data.q $FE1D877602B01552,$8AB2881A0C063F5C,$7F4DCF153C9F8C0A,$5FCC3F1B327E1F09,$0B69B4D0EB6B5584
    Data.q $F895CAF5466D369A,$F133BBD6F0AF8BEC,$98E7F66B300FCCD6,$F879C7F6F877CDF3,$5FDCC3F37C7CEE7E
    Data.q $4DC6E3F3B3F4FC3E,$C30CD1CF67B3DC58,$0C304F4351E2A00C,$ABA97D0DD58A026C,$5770F3DB24854AE8
    Data.q $13DF880ABFFD9B70,$33066C1372700F98,$680B231A74E03E86,$C5219B4DA6D39CDC,$F67317E9F6BC0603
    Data.q $15EAE2DAECB2582D,$358B5EAE56205937,$0DB51EB0DB50EBB5,$EAEA6B16B6B9588D,$6037EB0D09B1AEB1
    Data.q $6F8159AD2C06BAED,$CBC6CD660F8B987E,$6303FD4F6989BDAF,$1E28918A88C14E27,$CDCBC88585F90838
    Data.q $5AB5F75B2361CB85,$C67DEC64284AD468,$384842841FBB2D05,$94A8D0E42B934E37,$E5CBA8CC8134EBD0
    Data.q $A0949406216861A4,$13C24E266302A2AC,$1F177CDE578B3CCF,$EA879BCFDF1CFECD,$1B8D01B0DF51AB15
    Data.q $773F7C3AED4D6136,$CCF53C1DEB7F5E3E,$5BDAF117F9EE7873,$17F6609F5983E0EF,$0FCDF0EF9BE73073
    Data.q $AFCBBBE6F9CE6EF3,$2CFD4A9566E6FEBC,$AFA1A1171C790AB5,$126445606F938299,$0B0439C9C9ECC427
    Data.q $5C100AFE1D6C3FC9,$5C1D46C340DC113D,$227D3A781F43113D,$7714C30C4CC4FA42,$3F1389F8E465D2E9
    Data.q $5E5A2D8E1FBBFAFB,$D57AB06B55F2CBF3,$90D6E44D0D10009A,$AC16F371B19B9ADB,$6AB0EB6BD58F586B
    Data.q $6D7561D6D7562D4D,$4BC582C6AE57AA1D,$664FC3E3DF77D5F1,$4E2FB3C1DFB7F5E3,$1E53B1853E4FA3C7
    Data.q $0C6AB23113F1A8C5,$0C10E86831CBCACA,$9A04C54505083418,$A0AF201417E40282,$C62E2C2885850500
    Data.q $8608643250834180,$1AA831E8C544A88F,$A7D4C54D27E3013B,$DF3782BD2F73C69E,$DF37C0BFB359899D
    Data.q $C57CB0CB25C2C5CF,$CAC561D4D678F22A,$FD9E3E0968B798B5,$3A3F262AF1985E39,$30BC7F869D1F530D
    Data.q $777ADE26FEBCAF1D,$C5FA7C53F8F83E26,$BBFAFAF9CF9F9B9C,$BBC078B0AFB07FEF,$0E8E150473BCEE1D
    Data.q $B6060EDCF4B46186,$35F461C6BE962A13,$F34556FCF71546E7,$1430475CADC4055F,$F4B198B360A0710F
    Data.q $EB27D090A071A409,$E276362624A61864,$E773F7EE767D9E3F,$9B0D97F9B8DA6A9F,$586BA80DFADD62B7
    Data.q $66F6CB61371BF58F,$C01FF6FB07BDDCEC,$341EF763B0878381,$5AAC06FABA8CDA6D,$E57AA2D7AB158B5B
    Data.q $2BD5658959AB2C6A,$8C582EE6355978B1,$06FABECF8B9FBE6F,$BDEFDBFB944A7D1F,$7F5E33077EDFD78F
    Data.q $FABE2F137B5FD313,$EAF8BC35F5785E1A,$ADF5781BC6F1981B,$F7EDE1EF3BFAF1B7,$67D661668FCCC03F
    Data.q $7377C3BF6FCBE39F,$64B458C5A2FE61E7,$D5E5E2C1AB2C9629,$959A92CFF44D5258,$C32C970B12B35A58
    Data.q $18FA3EF780FDDF57,$79F67A9E3AFABD2F,$E7D9FA7833F4F13C,$6F1BEAF197F4DCF1,$9FC7C1F0B387E661
    Data.q $511E1DEF3BC6F2FE,$8668C8484879F95E,$A30C30F186184A61,$9392845D4B417AA7,$922241B10CB6086B
    Data.q $E6D50122DFF70DD5,$4A55B88057F0C28F,$219A61EAC2507DBB,$310A083122820D0B,$DAF8DA6D36BAC27D
    Data.q $A26C2C2C243B6DB6,$5EDFD7C5FF9F66C9,$8FDBEF76037EB75E,$6C36EB69B03BCDAD,$3B1D3F107038A165
    Data.q $73D9ECE0CFA7D386,$147A3D1C39ECF9F8,$B19B8DFAC6ED763B,$D16057AB4B0EB6BA,$968B06ACBC58E5D2
    Data.q $68BF98E5D2D160D6,$170BB98C5A2DE629,$1168BB98A5E2DE61,$C62C171F8C582DE6,$CC12D177308B05BC
    Data.q $DCC22C177318BF9B,$582C12D16F318B85,$2582C52F17F30CB2,$ACD72B1CB434694B,$85DCEF3446D36345
    Data.q $A85D8EFB61F77B3D,$D5F1AACBC58F586B,$B5E3664F83E03F77,$53C65FD373C1DEB7,$33117F9F67873CCF
    Data.q $A626F6BF2F037B5E,$A7CE4E4F49D4F13E,$CDA6D3698FBBDD21,$1C34181C4D1A2A50,$20C48617242CD818
    Data.q $4049B7C3E64AD818,$B5C102CFF15761FD,$228E4E088A047F12,$64A01DF4C429A395,$76DC9B4DA6DF4618
    Data.q $F8BFC7C5C595DAED,$1BDAF19E9F1F47FE,$C19F4E271EAEB358,$FB3DAEF36F64D3C9,$4FD3F4FC7EC0FFB0
    Data.q $19F99CCE14F27938,$70572B95C05FCE17,$17057CBA5C55DAF5,$E8E33F33E9C25E2E,$6376BB9D8FAF7231
    Data.q $0D09B8DA6C66F6DB,$EAEA3D61BEA2361B,$06BACE40DF5B511B,$0D11A1AEA237D6D4,$DD6C66D369A2361B
    Data.q $4381C2ED763B1DB6,$F9FCE0CE67800887,$BE5CAE32E974B80B,$9F91D0E3CEE7B38A,$AD0DF5B519B9B5B0
    Data.q $FAF19899DDE37880,$B1E53097C5FE789B,$2D290C14E27A31C7,$DAEDA9D76BA5DADB,$051F1B4DA6D61BB5
    Data.q $E321175C0AB1C0C1,$1BE862181C599684,$EE08606DEBA1858C,$57050C1102B7FA84,$88F2382281C5DC4F
    Data.q $E39F289F469140E4,$DB6DB4B105F41442,$BF2FF4E1417E7076,$B43163D1C8F8E6FA,$FD3F07397C5F1CBC
    Data.q $AB95C0DFAF571474,$F27938CFCCE67057,$E7B3E7E0CFA73914,$0978B85C79DCFE70,$70572BD5C65D2E97
    Data.q $AE8371B8DC75FAE3,$E04BF2FCBF05FA43,$AE7275FAFD73DCEF,$B8EBF5C6F9FC0B5D,$6B8EBF5DAE06E37E
    Data.q $70B8CBA5D2E06FD7,$3FB380BF9FCE22E1,$FF77B1A793C9C39F,$56CB4C1246DE6C01,$B7E5F04B45DCC2AC
    Data.q $C9B8C3DE778DE3DF,$AF2B0C30C8603153,$F8F884D6E5456944,$8C30C019B4DA6DA9,$BE9C82AD82116385
    Data.q $E6F43056E9D26C16,$316EBBA7C9B93154,$F88067F860A7F589,$119A158296B050A3,$0E3C14F270271954
    Data.q $EF3BCEF9860A3214,$5CACD54FF41BD12C,$CDCAE0F3B99BE079,$F18A8BF226464A43,$D95C074B38F9BCC3
    Data.q $0EB532E06FD71B8F,$71E7F385C45C2E17,$D70D76BD5C25D2F5,$26F379B8C16685E8,$DCBF05FCDE6E3F82
    Data.q $AED70D76B84041B8,$C2FE70974BE5C55E,$9DCF670174BF9C45,$05FCFE71E773B9C7,$C55F2F971978BC5C
    Data.q $D8CFCCEA70572B95,$378D5CAF961F77B5,$B8A227E391899DDE,$1799E1C763950CB4,$E16175E8D565425F
    Data.q $614C576BB5DB13E1,$BE90830415410608,$76BE9A32D09C1926,$0C257F81E1964161,$345E8A057F102CFF
    Data.q $6B1C4957934FEA4C,$1D0C6186322175C1,$F9329C9C9018743A,$1B75B0DFA9BEAFCB,$408E96862E71FDBE
    Data.q $2A4347FAA23A6A72,$BCB65849C4E26057,$E3E4BFC05FCF671A,$4E271F1BF396CDE6,$CBDCF14BA5C2C29E
    Data.q $9597060C6A3E5033,$6BCAFE98A9E4CC63,$4FA3EF78C7E1F998,$87A1F73A190C96AE,$6D216DB6DB6AAA1F
    Data.q $22289C94208E0964,$0E7F4E5CD12445D8,$257FDEE19A41210C,$7B8A0F7E200AFF0C,$D27B958D33A3EE39
    Data.q $0B5AC15727144C02,$A6D346186522146E,$3C54BA5D2EBC9B4D,$BA6C6BAD5F13F8F6,$F06ACB4584D8D758
    Data.q $67A074E2C36F9BEA,$5ED08CEE753A1878,$8DCBA7009F1B10BD,$C3CEE6F311785FE7,$7FB9FCEE70DB6DD6
    Data.q $C369A14EA7938F8A,$33C7F8F7FDF77C06,$8458BE0B979BC1CF,$79B044096474F494,$E9F59869D1F93072
    Data.q $0F8FACC1FA410167,$BEEFBBEF77962D19,$1D4116381A385411,$C1175815656E15A4,$F1346C0CF36075EE
    Data.q $E17822008FF86047,$D08F14F362B89B08,$A9CFECD88E0F4BC2,$6CE17D310B6B047F,$7DAB46A960F03C0F
    Data.q $B0DFAA68BFCF93E1,$01BEB6B11B4D7519,$635F398BE3572B35,$F8E8C48BE0C9A4C2,$877DA2DB6D302770
    Data.q $5BADD107C1F0780E,$1636262187878437,$1A3064CA90D9D959,$C8BD7AF0DDBB708D,$EDDB83E7CF81C9C9
    Data.q $46452A5483A75E86,$B0B08FEFF7FA0646,$F43E0F0DD6EB7430,$D779DC2EEBBCEE10,$8E4C91061619E85D
    Data.q $E07FC9ED318341A2,$62DF39CBE3EF99DD,$31B9AEA92C6AD2E1,$9F6363A2CB69B1E5,$630C3086BBAEEBB8
    Data.q $208DC09D5C9184E7,$F5608BAC0AB0B7F8,$9AFA7EE9D24E3742,$C4055FE186AFFDDE,$9D142C1F75C1416F
    Data.q $B06D9066A50C0FA8,$A3C9BB270A670561,$F68EF68C30CA5466,$034555A1A121FDED,$367B4582C3F07E06
    Data.q $BCD0BB1DB6C66B6D,$DB6D87DDEF763773,$3F9DCC1ACD6AB19B,$8C26E31F7CCDEF1F,$211F365646EBCB87
    Data.q $0C301B4DA6D13DA1,$6445EFBB9EE7BBF3,$0A0BF20572641454,$55E338BC04FC6E31,$37F5E578BBF6F1BC
    Data.q $D30BECF197F4DCF1,$E62FD3E36F9BEAF1,$33BBE6F10BF987E0,$EA753B37DAB5A837,$B608BA8F8C30C954
    Data.q $E468A98829CDC520,$521B339F4E98E7D1,$E2742F5709AFA3F6,$3095FFED0CD5C0C0,$1768FB9DB8812BFC
    Data.q $85C829DDB9DB0504,$EFA421815B8B5B04,$37D457DDF77DFD2C,$F3A7D95969726222,$1C2EE77DB1DE2E16
    Data.q $13863A7F87187438,$72B8CBA5C2E0CFA7,$C7A3873D9ECE2AE5,$71B8D87DBEEF618E,$3535158359AED633
    Data.q $D45A2E162974B258,$B08B45A2C42E1672,$EB02B158AC32D96C,$70386DB6DB63D5D6,$C7A38E3F1F8E20E0
    Data.q $5EAD2C2EF36B638E,$34BFCF0CF93F0F89,$FBBC6F0334BFCF03,$6749B1785F67B5FE,$ED71CF67A3D7BC30
    Data.q $D1C351C2A22FB7DB,$05C08B5C080E3207,$A22E39C215A38E21,$ED0C105F7136A70B,$DB881A7FE9E24AFE
    Data.q $8878B585BFB688CD,$8687D9C11CAEC19A,$4C8C162CC939FD56,$E078630C3190C68E,$744F4747FB0A0781
    Data.q $2B27F1F47F6FDCBA,$59ECEA7D38EF35B6,$C15F2F970974BC5C,$5C0DDAFD70376BB5,$7E0096D79FCBFEBF
    Data.q $47197CBE5C17E5F9,$60B05B4D86C09F8F,$373C1CF9FC7C72E9,$4E2C864A03C3E5FD,$E35EAF67B57F4D49
    Data.q $66A2541050E877DA,$F33A850148436021,$BE8BDEE7D2442036,$DC2F58222E395D16,$0177F8FB2FF0CF2A
    Data.q $C16D1C0E9AE6BB71,$8DC71BB466760B5A,$3560C5ACA884E1F4,$A30C30912A270646,$F6FA7D9C3B8EE3BC
    Data.q $565454CF4488172D,$DCECD5DF77CDFA7E,$FCAE57CBE5CF6BB9,$3AFD7EBE7E8360E5,$F9BCEE6E70381EF6
    Data.q $DEAD52D4F13DA7DB,$A47E9FFDFEBF61F0,$22A3AEF534E1E773,$E0CE42042C881591,$A2101CC9EC7D064C
    Data.q $38DD0F71C3EEB0A9,$A6DE770CFDB9EB1B,$9DFED17D5FE6D550,$70D9CF69022EDC40,$36E3D237582DAC17
    Data.q $02FA54AF0A812316,$B9EE699A2D852EB3,$79437EBF54671EE7,$A4F2F4D9B314DE3C,$25ABE7339B3F9349
    Data.q $BBDBEDF7EBF5F5F5,$BC5D2E4793C9E4EB,$E007397E5F97EA74,$70BCDE6F370B8002,$7F3B9FCF9FF5FAFD
    Data.q $3737B70763B1D8FC,$3399BAE562B158EF,$AE4B3A5A5A585FDF,$47B134949498BC50,$170EE3B8EE431E8F
    Data.q $002C2ACD39A92C4D,$8FA54835AC040E02,$A30845AE073E8139,$9DC2B5821EEB95CF,$60B8EFF36F9D69B7
    Data.q $43A3CE6B7E206EFF,$543B060391D22450,$158316A6F5884ECC,$97E6A64E05F4719F,$30C329205E9F070B
    Data.q $4FA7DEDBBEEFBBAA,$810211949494C29F,$68D1AA9F2E5C9C60,$8D1A30FFF5EBD49E,$C3060D67C68D18CF
    Data.q $FD4AB569FEBD7A33,$3D9D9D929B264C84,$3434342CA1212126,$256EA0D6B6DB6DBF,$AC83B8E7CFDDE709
    Data.q $C8D92109C71040DB,$C8E8417022C717A1,$B77688B8E4EE2089,$2E76E2066FFBBB1A,$622FACE6EE2DAB84
    Data.q $9F1584889CCED443,$480389238608D5AC,$909C2E7364BDC70A,$8248F66CEFA222C2,$B3EBBEE7CEF3988E
    Data.q $80167CFE933E1738,$5606A3491040DBE4,$20A1E105811AB22C,$FDB42AD702B58210,$0F7E2049FFA45F77
    Data.q $878C1611A2833B8C,$88E1824EEB93E239,$2DD2757D4F1200E6,$E8FE556B0DDD6140,$880183F17B87BF61
    Data.q $415EC63E87D040E6,$F709FE3A11AB816E,$026FFCE2E27FE6D0,$4CFDC60B93A25BF1,$4991B09DD6234ACB
    Data.q $288C5E97D1CB208F,$24A039624859ABEA,$1D0524B039125850,$1BDFA04BAFD8DFF6,$5AC5DFD3FBF1741F
    Data.q $0D6383D04B1C3E81,$9726C082CEC7D33A,$E4FFCDB1A203F9EE,$82B7B82204DFF9C5,$6F72575C182C9D15
    Data.q $CB1C2ED64360D590,$E6F5AC549E95BAC1,$DC1DF451242C2B44,$FB87B8685941738F,$047E2E7147D7EC7F
    Data.q $8FA5080083BDD9FD,$B5CAC7D08F097585,$B93CF39BB86BAC06,$03CFFE187B823BCB,$836D4C11C3070C11
    Data.q $C2A6C1AB0B7F68C0,$00733A508D852EB9,$A6AE38BD22B20909,$1739BD3ADF980737,$FE843FBBEE7EFD9D
    Data.q $07825AC0771C6EAE,$B846AE05BAE02083,$FF841C7FFFCF16E3,$60985F823F822014,$AD84E6EE4C8DC9F1
    Data.q $713A5AE390795BAC,$12C105BA496B2984,$5CE577A2F8273BFA,$C1E0059F173847F8,$95B84B9077705D20
    Data.q $3FE3F57FE1060C58,$B04635823060880D,$C7DC735615BAE0D5,$3C5CE21E485C2F71,$745D053A75BF302E
    Data.q $6F70370B783CE7F6,$1C106B1B70E82590,$53FFE17A4FFDB435,$35616E6D9D160881,$0B5C7277A21208EE
    Data.q $8E7EE481CBDC82D7,$FB8756E681C8E9BB,$20DEE73FB1F7EC35,$F410E863D057700B,$D115FFF202DDDB18
    Data.q $5F60C0EDC40ADFF8,$D2085B8EE74176C8,$0B0B0415DC90410E,$5DFA2E83BB9D6FCC,$1DE1842DC3BF1741
    Data.q $0E3FFF8FC17C78B7,$B6A6156E2016FF84,$92182402B7BBF209,$3A776E602B739CF6,$8EFFE641F6FEF904
    Data.q $68FFC63D5BEEFCDB,$DC80B3F8809BFE10,$9DEFCC03BFB6940A,$77E37F6D59F9B776,$1FC40EDFF040D7FF
    Data.q $6D68BE0940B7E401,$CE7E07F76F2EF36F,$0BFF8FCAFFEEFD6F,$BF9E8FEBD256FC40,$3FEBFEBBF56FC172
    Data.q $33F96147F101AFFE,$021FFA2ED7FF30C0,$2FDFCF61F7F3EFE2,$7F3EFE206FE7DFC2,$CFBF881BF9F7F103
    Data.q $FFF3E9FE7DFC40DF,$24A4AA19379D0006,$454900000000E272
    Data.b $4E,$44,$AE,$42,$60,$82
  musicpng_end:
EndDataSection
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  DataSection
    drop_small_start:
      Data.q $2020000100010000,$10A8002000010000,$0028000000160000,$0040000000200000,$0000002000010000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000030000000200,$0000070000000400,$0000050000000800,$0000000000000400
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000010000000100,$0000040000000300
      Data.q $00000B0000000700,$02011D0000001200,$15093F0C08032C02,$35166F2F200D551E,$000074422F168D4F
      Data.q $0000050000001600,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000010000000000,$0000010000000200,$0000070000000300,$0000150000000C00,$0E07320604022000
      Data.q $2C155E291D0E4413,$502694583F1E773D,$6E33CA87612EAE6E,$7E38F2AB7837DE9A,$8036FFBB8137FDB4
      Data.q $3B20FFCA954AFFBE,$000016000000884D,$0000000000000400,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0201010000000000,$21103D1F16091104,$462380483419642E,$6D37B87D5C2E9E60
      Data.q $8B46E5AA7F40D293,$984DFEC6944BF7B9,$984CFFCF9A4EFFCC,$9047FFCA944AFFCD,$8740FFC18C43FFC6
      Data.q $7E37FFB9823BFFBD,$A257FFCA984EFFB5,$0000874D3B20FFD2,$0000030000001400,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$1A0C000000000000,$9248F6BB88413826,$9C50FFCC974CFFC6
      Data.q $9F54FFD09E53FFD0,$9E55FFCF9E55FFD0,$9C54FFCB9D55FFCD,$9951FFC99A53FFCA,$944CFFC6964FFFC8
      Data.q $8D46FFC29049FFC4,$833DFFBC8841FFBF,$A65CFFC99A52FFB9,$3C21FFD4A55BFFD4,$000012000000854D
      Data.q $0000000000000300,$0000000000000000,$0000000000000000,$1E0F000000000000,$974FFDC5934B362A
      Data.q $9C55FFC79952FFC6,$A25BFFCC9F58FFC9,$A65FFFCFA45DFFCE,$A65FFFD0A65FFFD0,$A25CFFD0A65FFFD0
      Data.q $9B55FFCCA059FFCE,$934CFFC69651FFC8,$8841FFBF8E47FFC3,$A860FFCC9F57FFBB,$A25CFFD5A960FFD3
      Data.q $0000824C3C22FECD,$0000030000001100,$0000000000000000,$0000000000000000,$2110000000000000
      Data.q $9D56FCC99A512E2C,$A55FFFCCA15AFFCA,$AC66FFD2A963FFCF,$AB65FFD4AB65FFD4,$A55FFFD2A862FFD4
      Data.q $9E57FFC59650FFCF,$9E58FFBF8D47FFCA,$9851FFCB9F59FFCA,$8C46FFC2924CFFC6,$AE66FFCFA35CFFBE
      Data.q $A561FFD3AA64FFD6,$3D23FED1A761FFCD,$00000F000000804C,$0000000000000300,$0000000000000000
      Data.q $3C1F000000000000,$A45EFBCC9F582C4F,$9F59FFD0A761FFCE,$A25CFFC79A54FFCA,$954FFFBE8D47FFCD
      Data.q $8B44FFC2934DFFC4,$833DFFBA8842FFBD,$914BFFB9853FFFB7,$9E58FFC59852FFC1,$904AFFC49751FFC9
      Data.q $B26CFFD1A861FFC0,$A966FFD9B26BFFD9,$AC65FFCEA864FFCF,$0000794D3E25FED4,$0000020000000800
      Data.q $0000000000000000,$8C4A000000000000,$A964FBCAA15C2CB4,$A35EFFD4AE69FFD0,$8F48FFC3954FFFCC
      Data.q $8A43FFBA8942FFBE,$8740FFC99F59FFBA,$914AFFC59953FFB9,$843EFFB6843CFFC0,$A45EFFBF8F49FFB7
      Data.q $944DFFC69B55FFCD,$B771FFD4AC65FFC2,$B670FFDBB670FFDB,$A966FFD2AE6BFFDB,$3D24FDD5AD67FFCC
      Data.q $0000000000005C4B,$0000000000000000,$8E4F000000000000,$AD69FBCDA6612CB6,$9750FFD7B36FFFD3
      Data.q $9E58FFC2964FFFC3,$914BFFBE9049FFC7,$A862FFCDA560FFBF,$B16DFFD0A964FFCE,$A25CFFC9A15BFFD6
      Data.q $A460FFCFA863FFCB,$9650FFC89D58FFCD,$BB76FFD5AF6AFFC3,$BA75FFDDBA75FFDD,$B26EFFDCB973FFDD
      Data.q $7D4BFFD5B06BFFD5,$0000000000009699,$0000000000000000,$9254000000000000,$B16EFBCFA9662CBA
      Data.q $A15BFFD7B571FFD4,$BB78FFCFAB66FFC8,$BC7AFFD8B774FFDB,$C381FFE0C381FFDC,$BC79FFDEBF7CFFE0
      Data.q $B470FFD9B976FFDB,$A662FFD1AD69FFD6,$9853FFC8A05BFFCD,$BD79FFD6B26DFFC4,$BE7AFFDFBD79FFDF
      Data.q $BB76FFDEBC78FFDF,$804EFFD8B571FFDD,$000000000000929B,$0000000000000000,$9857000000000000
      Data.q $B370FBD0AC682CBE,$BE7CFFD8B775FFD5,$C382FFDFC280FFDC,$C685FFE2C685FFE0,$C281FFE0C483FFE1
      Data.q $BC79FFDDBF7EFFDF,$B270FFD8B775FFDB,$A863FFD1AD6AFFD5,$9A54FFC9A15CFFCE,$BF7CFFD7B36FFFC4
      Data.q $BF7BFFDFBF7CFFDF,$BC79FFDFBF7BFFDF,$B26EFFDDBA75FFDE,$00000000000091D4,$0000000000000000
      Data.q $9C5C000000000000,$B471FBD0AD6A2CC0,$BD7BFFD8B876FFD5,$C382FFDDC07FFFDB,$C484FFE0C483FFDE
      Data.q $C281FFDFC383FFE0,$BB79FFDCBF7EFFDE,$B26EFFD7B774FFDA,$A762FFD0AC68FFD3,$9A55FFC8A15CFFCC
      Data.q $C17DFFD7B470FFC4,$C382FFE0C281FFDF,$BE7BFFDFC07CFFE0,$B772FFDBBA77FFDD,$00000000000091D9
      Data.q $0000000000000000,$9E5D000000000000,$B371FBD0AD6A2CC3,$BB7AFFD7B876FFD4,$C180FFDBBE7DFFD9
      Data.q $C281FFDEC281FFDD,$C07FFFDDC281FFDE,$BB7AFFDABD7DFFDC,$B576FFD7B878FFD9,$B172FFD5B375FFD6
      Data.q $AB6BFFD4B070FFD3,$BE7BFFCDAB6DFFD1,$C990FFE1C485FFDC,$BF7CFFE0C384FFE3,$B674FFDCBC79FFDD
      Data.q $00000000000091D8,$0000000000000000,$A060000000000000,$B16EFCCFAC692DC5,$B978FFD5B573FFD2
      Data.q $BE80FFD9BC7DFFD7,$BF82FFDBC082FFDB,$BD80FFDCBE81FFDC,$BA7BFFDBBC7EFFDB,$B573FFDAB877FFDB
      Data.q $B06BFFD8B370FFD9,$A962FFD5AC66FFD7,$A96BFFCFA663FFD3,$CA92FFDCBF81FFCD,$C07FFFE2C88EFFE4
      Data.q $B774FFDBBB78FFDD,$00000000000091D8,$0000000000000000,$9855000000000000,$B172F3CAA56323C1
      Data.q $B475FFD5B374FFD4,$B473FFD6B474FFD6,$B471FFD7B472FFD7,$B46FFFD8B46FFFD8,$B46EFFD9B46EFFD8
      Data.q $B36DFFD9B46DFFD9,$B26DFFD8B36DFFD9,$AF6BFFD7B06CFFD8,$AC6CFFD5AD69FFD6,$C38CFFD2B178FFD4
      Data.q $BF7FFFE2C890FFDD,$B774FFDABB78FFDC,$00000000000091D7,$0000000000000000,$0000000000000000
      Data.q $A9613BA27E460000,$A962FFD0A862D2D2,$AF68FFD2AC64FFD1,$B570FFD6B16CFFD4,$BA78FFDAB874FFD8
      Data.q $BD7DFFDDBB7AFFDC,$BD7FFFDEBD7FFFDE,$B97CFFDDBC7EFFDE,$B476FFDAB77AFFDC,$AC6EFFD6B073FFD8
      Data.q $AB75FFD1A96CFFD3,$C07FFFDABF89FFD0,$B674FFD9B977FFDC,$00000000000091D6,$0000000000000000
      Data.q $0000000000000000,$A154000000000000,$AF6D86CCA15909CB,$B779FFD9B677FBD5,$BC7FFFDABA7CFFDA
      Data.q $BD81FFDDBD81FFDC,$BC81FFDDBD82FFDD,$BA7EFFDCBB80FFDD,$B77AFFDBB97CFFDC,$B274FFD9B577FFDA
      Data.q $AC6BFFD7AF70FFD8,$A25FFFD2A765FFD5,$AE70FFCEA264FFD0,$B572FFD8B977FFD1,$00000000000091D5
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$A55E000000000000,$B679D2D0AB6C39CF
      Data.q $B77CFFD8B67AFFD9,$BA7DFFDAB97DFFD9,$BB7CFFDDBB7EFFDC,$B877FFDEBA7AFFDE,$B36EFFDCB673FFDD
      Data.q $AB64FFD8AF69FFDA,$A158FFD3A65EFFD6,$984EFFCD9C53FFD0,$944FFFC89348FFCB,$B26FFFCBA363FFC7
      Data.q $00000000000091D3,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $935A0A9C7B440000,$B26FFDD9B3718BB5,$B26DFFD9B26EFFD9,$B16AFFD9B26CFFD9,$AE66FFD9B068FFD9
      Data.q $AA61FFD8AC64FFD8,$A55BFFD4A75EFFD6,$9E54FFD1A258FFD3,$964CEFCC9A50FCCF,$8E44BFC79148DAC9
      Data.q $9D5687BF883DA4C4,$0000000000003AC3,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$A75E40CD985C0000,$AB62FFD5AB62D8D2,$AB63FFD6AB63FFD5
      Data.q $A961EFD6AA62FCD6,$A55DC0D4A75FDAD5,$A05783D1A359A4D3,$9A5145CE9C5466D0,$934B14C9974D2ECB
      Data.q $00000000000007C7,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$9A58000000000000,$A65D74CC9A5C12C6
      Data.q $A55E46D3A75E6BD2,$A65D15D3A55F2ED2,$00000000000007D3,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000
      Data.q $0000000000000000,$0000000000000000,$0000000000000000,$0000000000000000,$FFFF000000000000
      Data.q $FFFFFFFFFFFFFFFF,$FFFFFFFFFFFFFFFF,$00FFFF01FFFFFFFF,$00807F000080FF00,$00C01F0000C03F00
      Data.q $00C0070000C00F00,$00C0070000C00300,$00C0070000C00700,$00C0070000C00700,$00C0070000C00700
      Data.q $00F0070000E00700,$00FE070000FC0700,$C0FF7F0080FF0700,$FFFFFFFFFFFFFF7F,$FFFFFFFFFFFFFFFF
      Data.b $F0,$AD,$BA,$BA,$BA,$1F
    drop_smallico_end:
  EndDataSection
CompilerElse
  DataSection
    drop_small_start:
      Data.q $0A1A0A0D474E5089,$524448490D000000,$2000000020000000,$7A7A730000000608,$59487009000000F4
      Data.q $0B0000130B000073,$0000189C9A000113,$6850504343694401,$20706F68736F746F,$666F727020434349
      Data.q $ADDA780000656C69,$CF461860C34ABD8E,$22E20D1142C50557,$C7171435A0E20E84,$892458D4382287F4
      Data.q $FD23E4DA2D43F353,$5D0A11784DE4E9FC,$0E208A0A83BD151C,$110E0E0E209B825E,$E19EF3A678BA0832
      Data.q $73D4AB5992DC81E5,$BA2A3562548BD0D3,$99E4933DC4FAB8ED,$B36697DFB6F98D65,$DE0FC851C51009B9
      Data.q $52AD662B8F00109F,$46C3CBEBF21EB52F,$F99F762E975EE831,$CA04F80A265F299D,$AC70401841F7D841
      Data.q $54BEDE68067102A4,$105559692D01CE20,$782808FA93A14037,$105C76C48500BFA9,$0072171DB1D680AF
      Data.q $513C2A6806BA979A,$4F676E920E58D500,$BD88337430C365E9,$EBEBD855F41EDF50,$2ADA4E32271F911B
      Data.q $F294DBBA5F74800C,$76C5FF8546ADD420,$E620042DB7B53D5C,$6FA3930FF0CB5946,$B831FB3BEFEEE215
      Data.q $7CEDACABF182D305,$58B6B2C6161570C0,$3E2E5F94B8539984,$0000C7C463A4F656,$00004D5248632000
      Data.q $000083800000257A,$0000D184000025F4,$00006CE800005F6D,$E783581B00008B3C,$4449BF0500007807
      Data.q $8BCF97ECDA785441,$FBBCE73FC7155764,$D55DDD5D1FABD5EA,$5C4211FC649E993D,$FF7B8D920C42E038
      Data.q $A204228203FE7704,$31A08E285D404C60,$23321172BA0885C6,$8A0CDC4664C41AB8,$70FCCC7066630428
      Data.q $9EF7BBD75577FA64,$CD4667BA7755E2E3,$A82A970BA973366E,$279EF7EF9CE779F3,$8F5E23CA5CA3CEEE
      Data.q $E4BFAFF840391E01,$F677CC0BF97D3F29,$3B56CAC46BE3EE79,$BF91133206762F84,$B8ED885B905B71B9
      Data.q $2C7678CF71DDDCF9,$16193C273933CC65,$4ED629F66A43B21B,$FEBFCFF9E6313C51,$E7EA5A3B970E007F
      Data.q $01678422E3F0C306,$5DEBBAEFB8C80104,$6BB334FF66E9BB17,$811DCE1AE110DF88,$C71C1073E0BB0E9B
      Data.q $F1FF360664FC71DD,$6560DE5AA64DE647,$226FCFFB70520EBC,$1A5FD7A7B1F7AF69,$D1CE0A6E32FB599C
      Data.q $CC65B3765B702B76,$A2335C1648CB319E,$8BBF7177C6722482,$8DC255F7A73DF785,$004E570B4A173B42
      Data.q $2339B3B897C5FD5C,$E950E773CCF9D6F6,$A9FD3F67DEF7BB32,$411CE787F756BC4F,$0C10444054151144
      Data.q $2C472C25B8CB70DC,$CBE6214EE0D89BB5,$A7D14533CAECB6AA,$7027A0D1DD08FB5A,$CCDC990D07434012
      Data.q $AF5F942D6EFBBFD8,$80882F550D5F2697,$CACF61C8816A8A14,$10A904A5C354A907,$444ED090919168CD
      Data.q $3062928286C58363,$FBB77114E457EAA0,$BE786596BADBD09A,$D9A97397355F0EEA,$1A0354045A19E727
      Data.q $E09021C6CDB9D1C2,$61815982D06038AE,$504C98332F5056B8,$72EE288807E79299,$4FE47A72AF2C2012
      Data.q $28347768DFA5C3D7,$7B9AA391C0111154,$FB7905BBE2E2629B,$0A10CCC9A2C5B459,$032CA13AB0603BA4
      Data.q $7DCA8186F6DA6CCD,$AACAF4888D4ED432,$B404244B42891B53,$1156F115402D5128,$B4E7BDA8B06E0EEE
      Data.q $AC165227207A2F38,$B3075554D71A32E8,$CC07C07EED080884,$5A05AAE222E22232,$F88805A0AA2AA814
      Data.q $C7171D963982F3E1,$9424513147029C10,$B28978D1954C4798,$CDB9E0A7161BB80C,$647364038E90A1EA
      Data.q $A22AA82AAA487681,$C266DA78D07C8A8A,$21A6E4373913C1CC,$F19CF9A434D486C5,$66E44B71428A19C6
      Data.q $8C44333D9B4DCF07,$371F247C5693D2AA,$02C042D222DEB6F0,$228A0B3DB1A44E44,$E398385F51CA42D2
      Data.q $8A199FFEDE69E239,$093A5E1FA5E26311,$370D9E326A4C9A90,$BAD8D71BEFF12DC3,$49BDBA6530789373
      Data.q $232B7022DB83EE9C,$E620351FA655A151,$19CF1DDBB72CCCAD,$2EBD5FDF898C4CF7,$14C412C9EAE37B3F
      Data.q $42A0153C472C1151,$BBB071EFECD3EE9C,$B26965111B676CC3,$EECD6E9D28827AD6,$0CC0A9D084543DD6
      Data.q $BC116C67298D6E72,$CB19608F3E637375,$C844C45919783C39,$4B07A811028B9231,$9A916F6D99B676CC
      Data.q $B7DBAD9CCD484406,$74C9B83AD98EAC18,$AD2CFBF6E9410777,$16D25870087661AD,$620EA46269107660
      Data.q $C75C0F2B9DF6FE6F,$2FE37F5E65C1F95F,$9601F9A4362C25A8,$5084278D192CA122,$4211EDEF980FEBD2
      Data.q $852ECED993737F60,$6A4D753A4386F414,$584A72652C252C1A,$4E66A4A776F6216C,$FDAFA5FCE17F70B7
      Data.q $080C7C757F77ADFA,$39AA0CA1D8DCEF00,$1D3B2810D0CCC5CE,$3D9FAC145A1EBDBA,$B74CCE72672A26DB
      Data.q $D45B9BFB15BB29B7,$822C1F9C422221C3,$94B0C9C86A73C1B6,$BCDF77FE70BF8A09,$6985C4047FDFD6F8
      Data.q $1BCD377B2D8EBC9E,$145222E44A486091,$ED32878E42C827AD,$49578E1994B08F2F,$63A7247391316131
      Data.q $7C5FC9CBC75A69BB,$3CEF7EDF172BCAF5,$6529240E87E407B0,$97555EFDE74FEE9D,$784E6595A1142065
      Data.q $3B6DAB0B41EB7212,$4CE7B4DB9661B2DD,$DC4AA9118985B18E,$BE2EB7CAE4FC6F9D,$01C1FDCEC0FBED7D
      Data.q $333E59504BCD5BC4,$18DD9EAFD4727EE9,$D4FB3BDAB13E4FD7,$B538DEA57D637F7A,$2EB0EACE83478F5A
      Data.q $7233305429504EAB,$93314894C4CA5232,$BA29C6DAC4A52462,$2FB7C3FB5F179ABD,$E0FEF3605DFEBE5C
      Data.q $F17F0B004703AF87,$DFA06A04A0048345,$A3EBAB95EC3ABA09,$D7199F4EAA32636A,$74AF4E3774AFAD4F
      Data.q $4C2F4AC9CB0F1C9F,$6770B5C2ABF48EEA,$3BF5FE5FE5E136B0,$480F701EFF5F2E17,$50D7FE01275A0E0F
      Data.q $AC00B1402314C726,$AF1D1D7A8CAABE80,$D1F1B0FD2BEB3B0E,$7F4BADC36EECFAB5,$3E1F1E4F17CFD7FA
      Data.q $CB59330F80787DE9,$E4F61FDBA4593831,$E018F262FC78050F,$62E78F000CFFAE51,$00000040FEAFB889
      Data.q $6042AE444E454900
      Data.b $BA
    drop_smallpng_end:
  EndDataSection
CompilerEndIf

; IDE Options = PureBasic 5.11 (Windows - x64)
; CursorPosition = 111
; FirstLine = 99
; Folding = ---
; EnableUnicode
; EnableXP
; EnableUser
; HideErrorLog
; CompileSourceDirectory
; IDE Options = PureBasic 5.11 (MacOS X - x64)
; CursorPosition = 576
; FirstLine = 439
; Folding = i+
; EnableXP
; Executable = bin2pack.app
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ------------
; EnableXP