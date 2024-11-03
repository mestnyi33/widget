; https://www.purebasic.fr/english/viewtopic.php?p=409987#p409987
EnableExplicit

#MAX_FILE_SIZE = 1048576

UsePNGImageDecoder()
UseBriefLZPacker()
UseLZMAPacker()
UseZipPacker()

Structure File
  Name.s
  Size.i
  Output.s
  OutputLen.i
EndStructure

Global NewList Files.File()
Global *mem = AllocateMemory(#MAX_FILE_SIZE << 2)
Global.i Compression, QuadsPerLine = 5, Algorithm.s
Define.i i, field, Event, Item, Dropped.s, Name.s

Procedure ProcessFile(*File.File)
  Protected *m.Ascii = *mem
  Protected.Character *c, *out
  Protected Name.s = *File\Name
  Protected.i i, reg_b, CompressedSize, Size = *File\Size
  If ReadFile(0, Name)
    If ReadData(0, *m, Size) = Size
      i = 0
      CompressedSize = 0
      Select Compression
        Case 1:
          i = CompressMemory(*m, Size, *m + #MAX_FILE_SIZE, #MAX_FILE_SIZE, #PB_PackerPlugin_BriefLZ)
        Case 2:
          i = CompressMemory(*m, Size, *m + #MAX_FILE_SIZE, #MAX_FILE_SIZE, #PB_PackerPlugin_Lzma)
        Case 3:
          i = CompressMemory(*m, Size, *m + #MAX_FILE_SIZE, #MAX_FILE_SIZE, #PB_PackerPlugin_Zip)
      EndSelect          
      If i < Size
        CompressedSize = i
        CopyMemory(*m + #MAX_FILE_SIZE, *m, CompressedSize)
      EndIf 
      Name = GetFilePart(Name)
      *c = @Name
      If *c\c >= 48 And *c\c <= 57
        Name = "_" + Name
        *c = @Name
      EndIf
      *out = *c
      While *c\c
        Select *c\c
          Case 48 To 57, 65 To 90, 97 To 122, 95
            *out\c = *c\c
            *out + SizeOf(Character)
          Case 32, 46
            *out\c = 95
            *out + SizeOf(Character)
        EndSelect
        *c + SizeOf(Character)
      Wend
      *out\c = 0
      
      ; generate data
      
      i = QuadsPerLine - 1
      *out = *m + #MAX_FILE_SIZE
      *out + PokeS(*out, "  " + Name + "_start:" + Chr(10), -1, #PB_Ascii)
      If CompressedSize
        *out + PokeS(*out, "    ; compressed size : " + Str(CompressedSize) + " bytes [" + Algorithm + "]" + Chr(10), -1, #PB_Ascii)
        *out + PokeS(*out, "    ; original size : " + Str(Size) + " bytes" + Chr(10), -1, #PB_Ascii)
        Size = CompressedSize
      Else
        *out + PokeS(*out, "    ; size : " + Str(Size) + " bytes" + Chr(10), -1, #PB_Ascii)
      EndIf
      
      !movdqu xmm0, [md_xm]
      !pshufd xmm2, xmm0, 00000000b
      !pshufd xmm3, xmm0, 01010101b
      !pshufd xmm4, xmm0, 10101010b
      !pshufd xmm5, xmm0, 11111111b
      CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
        !mov eax, [p.p_m]
        !mov edx, [p.p_out]
        !mov ecx, [p.v_Size]
        !shr ecx, 3
        !jz md_cont2
        !movdqu xmm6, [md_dq]
        !mov [p.v_reg_b], ebx
        !mov bh, [p.v_i]
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
        !mov rax, [p.p_m]
        !mov rdx, [p.p_out]
        !mov rcx, [p.v_Size]
        !shr rcx, 3  
        !jz md_cont2
        !mov r8, [md_dq]
        !mov r9, [md_dq + 8]
        !mov [p.v_reg_b], rbx
        !mov bh, [p.v_i]
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
        !mov ebx, [p.v_reg_b]
        !mov [p.p_out], edx
        !mov [p.p_m], eax
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
        !mov rbx, [p.v_reg_b]
        !mov [p.p_out], rdx
        !mov [p.p_m], rax
      CompilerEndIf      
      !md_cont2:
      
      Size & 7
      If Size
        *out + PokeS(*out, "    Data.b $", -1, #PB_Ascii)
        While Size
          *out + PokeS(*out, RSet(Hex(*m\a), 2, "0") + ",$", -1, #PB_Ascii)
          *m + 1 : Size - 1  
        Wend
        *out - 1 : PokeB(*out - 1, 10)
      EndIf
      *out + PokeS(*out, "  " + Name + "_end:" + Chr(10) + Chr(10), -1, #PB_Ascii)
      
      *File\Output = PeekS(*mem + #MAX_FILE_SIZE, -1, #PB_Ascii)
      *File\OutputLen = *out - *mem - #MAX_FILE_SIZE
    EndIf
    CloseFile(0)  
  EndIf
  ProcedureReturn
  !md_xm: dd 0x0f0f0f0f, 0x30303030, 0x39393939, 0x07070707
  !md_dq: db '    Data.q $',0,0,0,0 ; len = 12  
EndProcedure

Procedure AddFile(Name.s)
  Protected.i Duplicate, Size = FileSize(Name)
  If Size > 0 And Size <= #MAX_FILE_SIZE
    Duplicate = #False
    ForEach Files()
      If Files()\Name = Name
        Duplicate = #True
        Break
      EndIf
    Next
    If Duplicate = #False            
      AddElement(Files())
      Files()\Name = Name
    EndIf
    Files()\Size = Size
    ProcessFile(Files())
  EndIf
EndProcedure

Procedure UpdateResults(ReProcess = #False)
  Protected Count.i = 27, *Output, Output.s
  If ListSize(Files())
    SortStructuredList(Files(), 0, OffsetOf(File\Name), #PB_String)
    ClearGadgetItems(0)
    ForEach Files()
      If ReProcess
        ProcessFile(Files())
      EndIf
      Count + Files()\OutputLen
    Next
    Output = Space(Count)
    *Output = @Output
    CopyMemoryString("DataSection" + Chr(10) + Chr(10), @*Output)
    ForEach Files()
      CopyMemoryString(Files()\Output)
    Next
    CopyMemoryString("EndDataSection")
    SetGadgetText(0, Output)
  EndIf
  Count = CountGadgetItems(0)
  If Count
    SetWindowTitle(0, "DataMaker [" + Str(Count) + " lines]")
  Else
    SetWindowTitle(0, "DataMaker")
  EndIf
EndProcedure

If *mem And OpenWindow(0, 0, 0, 720, 480, "DataMaker", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
  WindowBounds(0, 400, 250, #PB_Ignore, #PB_Ignore)
  EditorGadget(0, 4, 34, WindowWidth(0) - 8, WindowHeight(0) - 38, #PB_Editor_ReadOnly)
  SetGadgetColor(0, #PB_Gadget_BackColor, $f8ffff)
  LoadFont(0, "Courier New", 11)
  SetGadgetFont(0, FontID(0))
  EnableGadgetDrop(0, #PB_Drop_Files, #PB_Drag_Copy)
  EnableWindowDrop(0, #PB_Drop_Files, #PB_Drag_Copy)
  
  CatchImage(1, ?icon_add_png_start)
  ButtonImageGadget(1, 4, 4, 32, 26, ImageID(1))
  GadgetToolTip(1, "Add file(s)")
  
  CatchImage(2, ?icon_clear_png_start)
  ButtonImageGadget(2, 40, 4, 32, 26, ImageID(2))
  GadgetToolTip(2, "Clear")
  
  CatchImage(3, ?icon_clipboard_png_start)
  ButtonImageGadget(3, 76, 4, 32, 26, ImageID(3))
  GadgetToolTip(3, "Copy to clipboard")
  
  ComboBoxGadget(4, WindowWidth(0) - 228, 4, 110, 26)
  ComboBoxGadget(5, WindowWidth(0) - 114, 4, 110, 26)
  AddGadgetItem(4, 0, "Uncompr.")
  AddGadgetItem(4, 1, "BriefLZ")
  AddGadgetItem(4, 2, "LZMA")
  AddGadgetItem(4, 3, "Zip")
  SetGadgetState(4, 0)
  AddGadgetItem(5, 0, "4 Quads per line")
  AddGadgetItem(5, 1, "5 Quads per line")
  AddGadgetItem(5, 2, "8 Quads per line")
  AddGadgetItem(5, 3, "10 Quads per line")
  SetGadgetState(5, 1)
  
  Repeat
    Event = WaitWindowEvent()
    Select Event
        
      Case #PB_Event_SizeWindow
        ResizeGadget(0, 4, 34, WindowWidth(0) - 8, WindowHeight(0) - 38)
        ResizeGadget(4, WindowWidth(0) - 228, 4, 110, 26)
        ResizeGadget(5, WindowWidth(0) - 114, 4, 110, 26)
        
      Case #PB_Event_Menu
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          If EventMenu() = #PB_Menu_Quit
            Break
          EndIf
        CompilerEndIf
        
      Case #PB_Event_GadgetDrop, #PB_Event_WindowDrop
        Dropped = EventDropFiles()
        i = CountString(Dropped, Chr(10)) + 1
        field = 1
        While i
          AddFile(StringField(Dropped, field, Chr(10)))
          field + 1
          i - 1
        Wend
        UpdateResults()
        
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 1
            Name = OpenFileRequester("Select file(s) to add", "", "", 0, #PB_Requester_MultiSelection)
            While Name
              AddFile(Name)
              Name = NextSelectedFileName()
            Wend
            UpdateResults()
          Case 2
            ClearList(Files())
            ClearGadgetItems(0)
          Case 3
            SetClipboardText(GetGadgetText(0))
          Case 4
            Compression = GetGadgetState(4)
            Algorithm = GetGadgetText(4)
            UpdateResults(#True)
          Case 5
            QuadsPerLine = Val(Left(GetGadgetText(5), 2))
            UpdateResults(#True)
        EndSelect
        
    EndSelect
    
  Until Event = #PB_Event_CloseWindow
  
EndIf

DataSection

  icon_add_png_start:
    ; size : 188 bytes
    Data.q $0A1A0A0D474E5089,$524448490D000000,$1000000010000000,$0F2D280000000308,$5845741900000053
    Data.q $72617774666F5374,$2065626F64410065,$6165526567616D49,$00003C65C9717964,$FFFF45544C500C00
    Data.q $FF333333666666FF,$000088EC58AFFFFF,$FFFF534E52740400,$0000F4A92A4000FF,$DA78544144493600
    Data.q $9192100C03466062,$0809805901918989,$0C8C0087990017C8,$C05A4005044C0268,$3AC4024800892A00
    Data.q $00C020004873DD0C,$3B502B6507023620,$444E454900000000
    Data.b $AE,$42,$60,$82
  icon_add_png_end:

  icon_clear_png_start:
    ; size : 215 bytes
    Data.q $0A1A0A0D474E5089,$524448490D000000,$1000000010000000,$0F2D280000000308,$5845741900000053
    Data.q $72617774666F5374,$2065626F64410065,$6165526567616D49,$00003C65C9717964,$FFFF45544C500F00
    Data.q $33666666CCCCCCFF,$41719AFFFFFF3333,$4E5274050000003C,$B6FB00FFFFFFFF53,$44494D000000530E
    Data.q $0E498F6CDA785441,$6FFFF50B03082000,$2D49805E86A0CD96,$C55CA8800309F588,$FADE940E2A82921A
    Data.q $1EC4D1D29471C54C,$86E2DA0199622806,$E7DAE3A18C457B5C,$DABDCFC65519B8B0,$FC9402F963000C02
    Data.q $4900000000C7FECA
    Data.b $45,$4E,$44,$AE,$42,$60,$82
  icon_clear_png_end:

  icon_clipboard_png_start:
    ; size : 218 bytes
    Data.q $0A1A0A0D474E5089,$524448490D000000,$1000000010000000,$0F2D280000000308,$5845741900000053
    Data.q $72617774666F5374,$2065626F64410065,$6165526567616D49,$00003C65C9717964,$FFFF45544C500F00
    Data.q $33666666CCCCCCFF,$41719AFFFFFF3333,$4E5274050000003C,$B6FB00FFFFFFFF53,$444950000000530E
    Data.q $0DC18F94DA785441,$33FECC6D030830C0,$A07BD48AFA8A0717,$FB20508348040170,$E0E480BF515A0239
    Data.q $008D4655396212AA,$BC3DC26E6A158861,$1E4E3433FAA19C56,$B997A1A6EC2F7A2B,$103500C023E64BE5
    Data.q $00006CF1F6E41E02,$42AE444E45490000
    Data.b $60,$82
  icon_clipboard_png_end:

EndDataSection
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -----
; EnableXP
; DPIAware