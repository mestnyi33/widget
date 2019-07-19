;**************************************************************
; Program:           PicPak
; Author:            netmaestro
; Date:              April 15, 2006
; Updated:           February 9, 2013
; Target OS:         Microsoft Windows All
; Target Compiler:   PureBasic 5.10 and later
; License:           Free, unrestricted, credit appreciated
;                    but not required
;**************************************************************
; *** Mac version ***
UseZipPacker()
#Red=$0000FF
#White=$FFFFFF

Global clip$

line$=Chr(10)
line$+ "Written in PureBasic by netmaestro, April 2006"+Chr(10)+Chr(10)
line$+ "Updated February 2013 to generate quads with PB 5.10 Line continuations"+Chr(10)+Chr(10)
line$+ "100% free to use, distribute, reverse-engineer,"+Chr(10)
line$+ "repackage and say you wrote it, anything you want"+Chr(10)
line$+ "to do with it is A-OK with me"+Chr(10)

use$=""+Chr(10)
use$ + Space(3) + "1. Drop an image file on the window"+Chr(13)+Chr(10)+Chr(10)
use$ + Space(3) + "2. Select a label name"+Chr(13)+Chr(10)+Chr(10)
use$ + Space(3) + "3. Paste generated code into your source"+Chr(13)+Chr(10)+Chr(10)
use$ + Space(3) + "4. The #image img0 will be ready to use!"+Chr(13)+Chr(10)+Chr(10)

Procedure CreateDataSection(picin.s)
  Pattern$ = "BMP (*.bmp)|*.bmp|JPEG (*.jpg)|*.jpg|PNG (*.png)|*.png|TIFF (*.tif)|*.tif"
  
  If picin = ""
    picin.s = OpenFileRequester("Choose an image file", "", pattern$, 0)
  EndIf
  
  ext.s = GetExtensionPart(picin)
  
  If ReadFile(0,picin)
    FileLength = Lof(0)
    *original = AllocateMemory(FileLength)
    *compressed = AllocateMemory(FileLength)
    
    If FileLength And *original And *compressed
      ReadData(0, *original, FileLength)
      CompressedLength = CompressMemory(*original, MemorySize(*original), *compressed, FileLength)
      
      If CompressedLength>0 And CompressedLength<FileLength
        *compressed = ReAllocateMemory(*compressed, CompressedLength)
        DecompressedLength = UncompressMemory(*compressed, MemorySize(*compressed), *original, MemorySize(*original))
        
        If DecompressedLength = FileLength
          StickyWindow(0,#False)
          MessageRequester("Info", "Compression succeeded:"+Chr(10)+Chr(10)+"Old size: "+Str(FileLength)+Chr(10)+"New size: "+Str(CompressedLength))
          StickyWindow(0,#True)
          FreeMemory(*original)
          *original = AllocateMemory(compressedLength)
          CopyMemory(*compressed,*original,compressedlength)         
        EndIf   
        
      Else 
        compressedlength=filelength
        StickyWindow(0,#False)
        MessageRequester("Info", "Compression not needed")
        StickyWindow(0,#True)
      EndIf
      
      StickyWindow(0,#False)
      label.s = InputRequester("Label Input","Enter a label For the DataSection: ","PicPak:")
      
      If Trim(label)=""
        label="picpak"
      EndIf
      label="  "+label
      StickyWindow(0,#True)
      label=RemoveString(label,":")
      endlabel.s = label+"end:"
      label+":"
      clip$=Chr(10)
      
      Select ext
        Case "jpg"
          clip$+"UseJPEGImageDecoder()"+Chr(10)
        Case "png"
          clip$+"UsePNGImageDecoder()"+Chr(10)
        Case "tif"
          clip$+"UseTIFFImageDecoder()"+Chr(10)
      EndSelect
      
      If compressedlength<>filelength
        clip$+"UseZipPacker()"+Chr(10)
        clip$+"*unpacked = AllocateMemory("+Str(Filelength)+")"+Chr(10)
        clip$+"Uncompressmemory(?"+Trim(RemoveString(label,":"))+", "+CompressedLength+", *unpacked, "+FileLength+")"+Chr(10)
        clip$+"img0 = CatchImage(#PB_Any, *unpacked, "+Str(Filelength)+")"+Chr(10)
      Else
        clip$+"img0 = CatchImage(#PB_Any, ?" + Trim(RemoveString(label,":")) + ", "+Str(Filelength)+")"+Chr(10)
      EndIf
      
      clip$+Chr(10)
      clip$ + "Datasection" + Chr(10)
      clip$ + label + Chr(10)
      clip$ + "  Data.q " 
      quads = CompressedLength/8
      bytes = compressedlength%8
 
      For i = 0 To quads-1 
        clip$ + "$"+RSet(Hex(PeekQ(*original+(i*8)),#PB_Quad),16,"0")+","
        If (i+1)%6=0
          If i<>quads-1
            clip$ + Chr(10)+Space(9)
          EndIf
        EndIf
      Next
      
      clip$=Left(clip$, Len(clip$)-1)+Chr(10)
      
      If bytes
        *bytestart = *original+(quads*8)
        clip$ + Space(2) + "Data.b "
        For i=0 To bytes-1
          clip$ + "$"+RSet(Hex(PeekA(*bytestart+i),#PB_Ascii),2,"0")+","
        Next
        clip$=Left(clip$, Len(clip$)-1)+Chr(10)
      EndIf 
      
      clip$ + endlabel + Chr(10)
      clip$ + "EndDatasection" + Chr(10)
      
      SetClipboardText(clip$)
      FreeMemory(*original)
      FreeMemory(*compressed)
      CloseFile(0)
      MessageRequester("Success!","Datasection is on the clipboard")
    EndIf
  Else
    MessageRequester("Problem","Could not open input file")
  EndIf
EndProcedure

CreateImage(0, 512,512,32)
StartDrawing(ImageOutput(0))
  Box(0,0,512,512,#White)
  Circle(256,256,256,#Red)
  Circle(256,256,200,#White)
  Circle(256,256,145,#Red)
  Circle(256,256,80,#White)
  Circle(256,256,40,#Red)
StopDrawing()
ResizeImage(0,120,120)

OpenWindow(0,0,0,150,170,"PicPak",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
ImageGadget(0,15,15,0,0,ImageID(0))
DisableGadget(0,1)
StickyWindow(0,#True)

If CreateMenu(0, WindowID(0))
  MenuTitle("Menu")
  MenuItem( 1, "Usage")
  MenuItem( 2, "About...")
  MenuBar()
  MenuItem(3,"Load pict")
EndIf

source.s=OpenFileRequester("Choose an image file", "", "BMP (*.bmp)|*.bmp|JPEG (*.jpg)|*.jpg|PNG (*.png)|*.png|TIFF (*.tif)|*.tif",0)
  If Len(source) : CreateDataSection(source) : EndIf

Repeat
  ev=WaitWindowEvent()
  Select ev
    Case #PB_Event_Menu
      Select EventMenu()
        Case 1
          StickyWindow(0,#False)
          MessageRequester("How to use PicPak",use$,$C0)
          StickyWindow(0,#True)
        Case 2
          StickyWindow(0,#False)
          MessageRequester("About PicPak",line$, $C0)
          StickyWindow(0,#True)
        Case 3 ; load
          source.s=OpenFileRequester("Load picture...","Test.jpg","BMP (*.bmp)|*.bmp|JPEG (*.jpg)|*.jpg|PNG (*.png)|*.png|TIFF (*.tif)|*.tif",0)
          If Len(source) : CreateDataSection(source) : EndIf
      EndSelect
  EndSelect
Until ev=#PB_Event_CloseWindow
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---
; EnableXP