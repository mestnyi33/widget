EnableExplicit

#DHT = $C4FF
#DAC = $CCFF

#APP0 = $E0FF
#APP1 = $E1FF

#RST0 = $D0FF
#RST1 = $D1FF
#RST2 = $D2FF
#RST3 = $D3FF
#RST4 = $D4FF
#RST5 = $D5FF
#RST6 = $D6FF
#RST7 = $D7FF
#SOI = $D8FF
#EOI = $D9FF
#SOS = $DAFF
#DQT = $DBFF
#DRI = $DDFF

#Intel = 1
#Motorola = 2

#EXIF_OrientationTag = $0112



IncludeFile "../rotateimage.pbi"


Define.i File, Ptr, Orientation, OrientationPtr, Marker, Img, ImgOk
Define Filename$
Define *Buffer


Filename$ = OpenFileRequester("Choose a jpg file", "", "JPG|*.jpg", 0)
If Filename$
  File = ReadFile(#PB_Any, Filename$)
  If File
    *Buffer = AllocateMemory(Lof(File), #PB_Memory_NoClear)
    If *Buffer
      If ReadData(File, *Buffer, MemorySize(*Buffer)) = MemorySize(*Buffer)
        If PeekU(*Buffer + Ptr) = #SOI
          ;Debug "Ok"
          Ptr + 2
          Repeat
            Marker = PeekU(*Buffer + Ptr)
            ;Debug Hex(Marker)
            Ptr + 2
            Select Marker
              Case #APP1
                Break
              Case #DRI
                Ptr + 4
              Case #RST0, #RST1, #RST2, #RST3, #RST4, #RST5, #RST6, #RST7
              Default
                ;Debug Hex(PeekA(*Buffer + Ptr) << 8 | PeekA(*Buffer + Ptr + 1))
                Ptr + (PeekA(*Buffer + Ptr) << 8 | PeekA(*Buffer + Ptr + 1))
            EndSelect
            
          Until Ptr >= MemorySize(*Buffer) Or Marker = #SOS
          
          If Marker = #APP1
            ;Debug PeekS(*Buffer + Ptr + 2, 4, #PB_Ascii)
            If PeekS(*Buffer + Ptr + 2, 4, #PB_Ascii) = "Exif"
              ;Debug "Exif found"
              
              
              Ptr + 8
              
              ;ShowMemoryViewer(*Buffer + Ptr, 200)
              
              If PeekU(*Buffer + Ptr) = $4949
                
                Repeat
                  If CompareMemory(?Intel, *Buffer + Ptr + 4 + OrientationPtr, 8)
                    Orientation = PeekA(*Buffer + Ptr + 4 + OrientationPtr + 8)
                    Break
                  Else
                    OrientationPtr + 1
                  EndIf
                Until Orientation = 1024
                
              ElseIf PeekU(*Buffer + Ptr) = $4D4D
                
                Repeat
                  If CompareMemory(?Motorola, *Buffer + Ptr + 4 + OrientationPtr, 8)
                    Orientation = PeekA(*Buffer + Ptr + 4 + OrientationPtr + 8 + 1)
                    Break
                  Else
                    OrientationPtr + 1
                  EndIf
                Until OrientationPtr = 1024
                
              EndIf
              
            EndIf
            
            Debug Orientation
            
          EndIf
          
        Else
          Debug "No Exif found"
        EndIf
        
      EndIf
    EndIf
    FreeMemory(*Buffer)
  EndIf
  
  CloseFile(File)
  
  
  UseJPEGImageDecoder()
  
  Img = LoadImage(#PB_Any, Filename$)
  If Img
    
    Select Orientation
      Case 0, 1
        ImgOk = Img
      Case 2
        ImgOk = MirrorImage(Img)
        FreeImage(Img)
      Case 3
        ImgOk = RotateImage(Img, 180)
        FreeImage(Img)
      Case 4
        ImgOk = FlipImage(Img)
        FreeImage(Img)
      Case 5
        ImgOk = MirrorImage(Img)
        FreeImage(Img)
        Img = ImgOk
        ImgOk = RotateImage(Img, 90)
        FreeImage(Img)
      Case 6
        ImgOk = RotateImage(Img, -90)
        FreeImage(Img)
      Case 7
        ImgOk = MirrorImage(Img)
        FreeImage(Img)
        Img = ImgOk
        ImgOk = RotateImage(Img, -90)
        FreeImage(Img)
      Case 8
        ImgOk = RotateImage(Img, 90)
        FreeImage(Img)
    EndSelect
    
        
    OpenWindow(0, 0, 0, 800, 600, "JPGViewer", #PB_Window_SystemMenu)
    
    ScrollAreaGadget(0, 0, 0, 800, 600, ImageWidth(ImgOk), ImageHeight(ImgOk))
    
    ImageGadget(1, 0, 0, 0, 0, ImageID(ImgOk))
    
    Repeat
    Until WaitWindowEvent() = #PB_Event_CloseWindow
    
    FreeImage(ImgOk)
    
    
  EndIf
EndIf

DataSection
  Intel:
  Data.a $12, $01, $03, $00, $01, $00, $00, $00
  Motorola:
  Data.a $01, $12, $00, $03, $00, $00, $00, $01
EndDataSection

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP