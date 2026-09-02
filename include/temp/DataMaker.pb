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
Global *mem = AllocateMemory(#MAX_FILE_SIZE * 5)
Global.i Compression, QuadsPerLine = 5, Algorithm.s
Define.i Event, Item, Dropped.s, Name.s, i

Procedure ProcessFile(*File.File)
  Protected *m = *mem
  Protected *out.Character
  Protected Name.s = *File\Name
  Protected.i i, CompressedSize, Size = *File\Size
  Protected.q QuadVal
  Protected LineStr.s
  Protected TextOutput.s = ""
  Protected *c.Character
  Protected FullQuads.i
  Protected Remainder.i
  Protected QuadCount.i
  Protected *readPtr
  
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
      
      If i > 0 And i < Size
        CompressedSize = i
        CopyMemory(*m + #MAX_FILE_SIZE, *m, CompressedSize)
      EndIf 
      
      Name = GetFilePart(Name)
      *c = @Name
      If *c\c >= '0' And *c\c <= '9'
        Name = "_" + Name
        *c = @Name
      EndIf
      
      *out = @Name
      While *c\c
        Select *c\c
          Case '0' To '9', 'A' To 'Z', 'a' To 'z', '_'
            *out\c = *c\c
            *out + SizeOf(Character)
          Case ' ', '.'
            *out\c = '_'
            *out + SizeOf(Character)
        EndSelect
        *c + SizeOf(Character)
      Wend
      *out\c = 0
      
      TextOutput + "  " + Name + "_start:" + #LF$
      
      If CompressedSize
        TextOutput + "    ; compressed size : " + Str(CompressedSize) + " bytes [" + Algorithm + "]" + #LF$
        TextOutput + "    ; original size : " + Str(Size) + " bytes" + #LF$
        Size = CompressedSize
      Else
        TextOutput + "    ; size : " + Str(Size) + " bytes" + #LF$
      EndIf
      
      FullQuads = Size / 8
      Remainder = Size % 8
      QuadCount = 0
      *readPtr = *m
      
      If FullQuads > 0
        LineStr = "    Data.q $"
        For i = 1 To FullQuads
          QuadVal = PeekQ(*readPtr)
          LineStr + RSet(Hex(QuadVal, #PB_Quad), 16, "0")
          QuadCount + 1
          
          If QuadCount = QuadsPerLine Or i = FullQuads
            LineStr + #LF$
            TextOutput + LineStr
            If i < FullQuads
              LineStr = "    Data.q $"
            EndIf
            QuadCount = 0
          Else
            LineStr + ",$"
          EndIf
          *readPtr + 8
        Next
      EndIf
      
      If Remainder > 0
        LineStr = "    Data.b $"
        For i = 1 To Remainder
          LineStr + RSet(Hex(PeekB(*readPtr) & $FF), 2, "0")
          If i < Remainder
            LineStr + ",$"
          EndIf
          *readPtr + 1
        Next
        LineStr + #LF$
        TextOutput + LineStr
      EndIf
      
      TextOutput + "  " + Name + "_end:" + #LF$ + #LF$
      
      *File\Output = TextOutput
      *File\OutputLen = StringByteLength(TextOutput, #PB_Ascii)
    EndIf
    CloseFile(0)  
  EndIf
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
  Protected Output.s = ""
  If ListSize(Files())
    SortStructuredList(Files(), 0, OffsetOf(File\Name), #PB_String)
    ClearGadgetItems(0)
    
    Output + "DataSection" + #LF$ + #LF$
    ForEach Files()
      If ReProcess
        ProcessFile(Files())
      EndIf
      Output + Files()\Output
    Next
    Output + "EndDataSection"
    SetGadgetText(0, Output)
  EndIf
  
  Define Count.i = CountGadgetItems(0)
  If Count
    SetWindowTitle(0, "DataMaker [" + Str(Count) + " lines]")
  Else
    SetWindowTitle(0, "DataMaker")
  EndIf
EndProcedure

; --- Переменные интерфейса (Объявлены строго через Define) ---
Define.i FontID

; --- Запуск интерфейса ---
If *mem And OpenWindow(0, 0, 0, 720, 480, "DataMaker", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
  WindowBounds(0, 400, 250, #PB_Ignore, #PB_Ignore)
  
  EditorGadget(0, 4, 34, WindowWidth(0) - 8, WindowHeight(0) - 38, #PB_Editor_ReadOnly)
  SetGadgetColor(0, #PB_Gadget_BackColor, $f8ffff)
  
  FontID = LoadFont(0, "Courier New", 11)
  If FontID : SetGadgetFont(0, FontID) : EndIf
  
  EnableGadgetDrop(0, #PB_Drop_Files, #PB_Drag_Copy)
  EnableWindowDrop(0, #PB_Drop_Files, #PB_Drag_Copy)
  
  ; Используем стандартный ButtonGadget со встроенными системными эмодзи
  ButtonGadget(1, 4, 4, 38, 28, "➕")
  GadgetToolTip(1, "Add file(s)")
  
  ButtonGadget(2, 42, 4, 38, 28, "❌")
  GadgetToolTip(2, "Clear")
  
  ButtonGadget(3, 80, 4, 38, 28, "📋")
  GadgetToolTip(3, "Copy to clipboard")
  
  ComboBoxGadget(4, WindowWidth(0) - 228, 4, 110, 26)
  ComboBoxGadget(5, WindowWidth(0) - 114, 4, 110, 26)
  AddGadgetItem(4, 0, "Uncompr.")
  AddGadgetItem(4, 1, "BriefLZ")
  AddGadgetItem(4, 2, "LZMA")
  AddGadgetItem(4, 3, "Zip")
  SetGadgetState(4, 0)
  
  AddGadgetItem(5, 0, "4 Quads/line")
  AddGadgetItem(5, 1, "5 Quads/line")
  AddGadgetItem(5, 2, "8 Quads/line")
  AddGadgetItem(5, 3, "10 Quads/line")
  SetGadgetState(5, 1)
  
  Repeat
    Event = WaitWindowEvent()
    Select Event
        
      Case #PB_Event_SizeWindow
        ResizeGadget(0, 4, 34, WindowWidth(0) - 8, WindowHeight(0) - 38)
        ResizeGadget(4, WindowWidth(0) - 228, 4, 110, 26)
        ResizeGadget(5, WindowWidth(0) - 114, 4, 110, 26)
        
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 1
            Define Filter.s = "All files (*.*)|*.*"
            Define FilePath.s = OpenFileRequester("Select file", "", Filter, 0)
            If FilePath
              AddFile(FilePath)
              UpdateResults()
            EndIf
            
          Case 2
            ClearList(Files())
            ClearGadgetItems(0)
            SetWindowTitle(0, "DataMaker")
            
          Case 3
            SetClipboardText(GetGadgetText(0))
            MessageRequester("DataMaker", "Copied to clipboard! 👍")
            
          Case 4
            Compression = GetGadgetState(4)
            Algorithm = GetGadgetItemText(4, Compression)
            UpdateResults(#True)
            
          Case 5
            Select GetGadgetState(5)
              Case 0: QuadsPerLine = 4
              Case 1: QuadsPerLine = 5
              Case 2: QuadsPerLine = 8
              Case 3: QuadsPerLine = 10
            EndSelect
            UpdateResults(#True)
        EndSelect
        
      Case #PB_Event_WindowDrop, #PB_Event_GadgetDrop
        Define DroppedFiles.s = EventDropFiles()
        Define Count = CountString(DroppedFiles, Chr(10)) + 1
        For i = 1 To Count
          AddFile(StringField(DroppedFiles, i, Chr(10)))
        Next
        UpdateResults()
        
      Case #PB_Event_CloseWindow
        Break
    EndSelect
  ForEver
EndIf
FreeMemory(*mem)
End

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 274
; FirstLine = 258
; Folding = -----
; EnableXP
; DPIAware