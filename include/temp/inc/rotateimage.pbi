﻿; https://www.purebasic.fr/english/viewtopic.php?f=12&t=75889&sid=8c6e11ec74d83ffab9dc183cb655f4cf
; https://www.purebasic.fr/english/viewtopic.php?f=12&t=38975
;******************************************************************************
;*
;* Image Rotation routines for 24/32 bit with optional AA
;* by Luis, http://luis.no-ip.net
;* v1.10 for PB 5.30
;*
;* Tested under Windows 32/64 bit and Linux 32 bit with PB 4.40 B2
;*
;* These routines can deal with both 24/32 bit images and with the alpha channel.
;* The output of the routines will be an image with the same number of BPP
;* as the one passed in input to them. The source image is not freed.
;*
;* Inspired by a simpler Visual Basic code from Robert Rayment. Thank you.
;* http://www.planet-source-code.com/vb/scripts/ShowCode.asp?txtCodeId=23476&lngWId=1
;*
;* ----------------------------------------------------------------------------
;*
;* RotateImageFree (nSrcImage, fDegRot.f, flgAntiAliasing, FillColor)
;*
;*  nSrcImage           The 24/32 bit PureBasic's image to rotate
;*  fDegRot             Float angle in degrees (+/-) 0.0 -> 360.0
;*  flgAntiAliasing     0 for simpler rotation, 1 for antialiased rotation
;*  FillColor           Used to fill the new areas of the resulting image
;*
;*  Return              a 24/32 bit image rotated by fDegRot
;*
;* NOTES :
;*  FillColor is not used with 32 bit images, the new areas are always transparent.
;*
;*  FillColor can be set to a unique color with 24 bit images if you want to
;*  draw the resulting image with masking using GDI functions under Windows,
;*  for example. Or maybe to simply match a certain background color.
;*
;*  The anti aliasing use 4 pixels to do the AA, this is useful especially
;*  when text is present on the image to be rotated to obtain a good quality
;*  at the expense of speed. A free-angle rotation really need AA !
;*
;* ----------------------------------------------------------------------------
;*
;* RotateImage (nSrcImage, DegRot)
;*
;*  nSrcImage           The 24/32 bit PureBasic's image to rotate
;*  DegRot              Integer angle in degrees (+/-) 90/180/270
;*
;*  Return              a 24/32 bit image rotated by DegRot
;*
;* NOTES :
;*   Use this procedure to rotate by multiples of 90 degrees instead of RotateImageFree().
;*   It's faster and it's not subject to rounding errors.
;*
;* ----------------------------------------------------------------------------
;*
;* FlipImage (nSrcImage)
;*
;*  nSrcImage           The 24/32 bit PureBasic's image to flip
;*
;*  Return              a 24/32 bit image flipped vertically
;*
;* ----------------------------------------------------------------------------
;*
;* MirrorImage (nSrcImage)
;*
;*  nSrcImage           The 24/32 bit PureBasic's image to mirror
;*
;*  Return              a 24/32 bit image mirrored horizontally
;*
;******************************************************************************


#EXC_ALLOC_ERR = 1

CompilerIf Defined(Macro_TRY, #PB_Constant) = 0
  #Macro_TRY = 1
  
  Global EXCEPTION
  
  Macro TRY (exp, exc = 0)
    ; [DESC]
    ; Evaluate the expression and jump to the corresponding CATCH if it's false.
    ;
    ; [INPUT]
    ; exp : The expression to test.
    ; exc : An optional numeric code to identify the exception type for the CATCH.
    ;
    ; [NOTES]
    ; This is inspired to real exception handling but it isn't.
    ; The purpose of this TRY/CATCH pair is to avoid messy, deep error checking in structured code
    ; and to wrap the use of GOTO inside something more convenient to read/follow.
    ; You can write the main body of the code under the assumption nothing is going wrong,
    ; and concentrate the cleanup / recovery in a single place, keeping single entry and exit points.
    ;
    ; Example:
    ;
    ; Procedure.i MyProc()
    ;
    ;  TRY (ProcA(), 1)
    ;  ...
    ;  TRY (ProcB(), 2)
    ;  ...
    ;  TRY (ProcC(), 3)
    ;  ...
    ;
    ;  ProcedureReturn 1 ; success
    ; 
    ;  CATCH
    ; 
    ;  Select EXCEPTION
    ;   Case 1 : ; specific cleanup
    ;   Case 2 : ; specific cleanup
    ;   Case 3 : ; specific cleanup
    ;   Default : ; fallback
    ;  EndSelect
    ;
    ;  ProcedureReturn 0 ; failure
    ; EndProcedure
    ;
    
    If Not (exp)
      EXCEPTION = exc
      Goto label_catch_exception
    Else
      EXCEPTION = 0
    EndIf
  EndMacro
  
  Macro RAISE (exc = 0)
    ; [DESC]
    ; Unconditionally jump to the corresponding CATCH.
    ;
    ; [INPUT]
    ; exc : An optional numeric code to identify the exception type for the CATCH.
    
    EXCEPTION = exc
    Goto label_catch_exception
  EndMacro
  
  Macro CATCH()
    ; [DESC]
    ; Receive the control from the program when the TRY expression is false.
    ;
    ; [NOTES]
    ; See the command TRY
    
    label_catch_exception:
  EndMacro
  
CompilerEndIf

Structure T_RGBA
  B.a
  G.a
  R.a
  A.a
EndStructure

Macro RGB_B(color)
  ((color & $FF0000) >> 16)
EndMacro

Macro RGB_G(color)
  ((color & $FF00) >> 8)
EndMacro

Macro RGB_R(color)
  (color & $FF)
EndMacro

Macro RGB_Mix (r, g, b)
  ((((b) << 8 + (g)) << 8) + (r))
EndMacro

Macro CopyPixel32 (Xs, Ys, Xd, Yd, BufferPitchSrc, BufferPitchDest, ptRGBAs, ptRGBAd, pMemSrc, pMemDest)
  ptRGBAs = pMemSrc  + (Ys) * BufferPitchSrc + (Xs) << 2
  ptRGBAd = pMemDest + (Yd) * BufferPitchDest + (Xd) << 2       
  ptRGBAd\R = ptRGBAs\R
  ptRGBAd\G = ptRGBAs\G
  ptRGBAd\B = ptRGBAs\B       
  ptRGBAd\A = ptRGBAs\A
EndMacro

Macro CopyPixel24 (Xs, Ys, Xd, Yd, BufferPitchSrc, BufferPitchDest, ptRGBAs, ptRGBAd, pMemSrc, pMemDest)
  ptRGBAs = pMemSrc  + (Ys) * BufferPitchSrc + (Xs) * 3
  ptRGBAd = pMemDest + (Yd) * BufferPitchDest + (Xd) * 3
  ptRGBAd\R = ptRGBAs\R
  ptRGBAd\G = ptRGBAs\G
  ptRGBAd\B = ptRGBAs\B       
EndMacro

Macro ReadPixel32 (X, Y, BufferPitchSrc, ptRGBA, pMemSrc)
  ptRGBA = pMemSrc + (Y) * BufferPitchSrc + (X) << 2
EndMacro

Macro ReadPixel24 (X, Y, BufferPitchSrc, ptRGBA, pMemSrc)
  ptRGBA = pMemSrc + (Y) * BufferPitchSrc + (X) * 3
EndMacro

Macro WritePixel32 (tPixel, X, Y, BufferPitchDest, ptRGBA, pMemDest)
  ptRGBA = pMemDest + (Y) * BufferPitchDest + (X) << 2                       
  ptRGBA\R = tPixel\R
  ptRGBA\G = tPixel\G
  ptRGBA\B = tPixel\B
  ptRGBA\A = tPixel\A
EndMacro

Macro WritePixel24 (tPixel, X, Y, BufferPitchDest, ptRGBA, pMemDest)
  ptRGBA = pMemDest + (Y) * BufferPitchDest + (X) * 3
  ptRGBA\R = tPixel\R
  ptRGBA\G = tPixel\G
  ptRGBA\B = tPixel\B
EndMacro

Procedure.i AllocateImageData (nImage, *BufferPitch.Integer, FillColor = -1)
  Protected *ImageMem, *AllocMem, BufferPitch
  
  StartDrawing(ImageOutput(nImage))
  
  *ImageMem = DrawingBuffer()
  BufferPitch = DrawingBufferPitch()
  
  If FillColor <> -1
    Select ImageDepth(nImage)
      Case 24
        Box(0, 0, ImageWidth(nImage), ImageHeight(nImage), FillColor)
      Case 32
        DrawingMode(#PB_2DDrawing_AlphaChannel)   
        Box(0, 0, ImageWidth(nImage), ImageHeight(nImage), $00) ; full transparent
    EndSelect
  EndIf
  
  *AllocMem = AllocateMemory(BufferPitch * ImageHeight(nImage))
  
  If *AllocMem
    CopyMemory(*ImageMem, *AllocMem, MemorySize(*AllocMem))
    *BufferPitch\i = BufferPitch
  Else
    *BufferPitch\i = 0
  EndIf
  
  StopDrawing()
  
  ProcedureReturn *AllocMem
EndProcedure

Procedure CopyImageData (nImage, *DestMem)
  StartDrawing(ImageOutput(nImage))
  CopyMemory(*DestMem, DrawingBuffer(), MemorySize(*DestMem))
  StopDrawing()
EndProcedure

Procedure.i RotateImage (nSrcImage, DegRot)
  
  ; Rotate 24 bit images at (+/-) 90/180/270 degrees
  
  ; Rotate 32 bit images at (+/-) 90/180/270 degrees preserving the alpha-channel
  
  Protected *tRGBAs.T_RGBA, *tRGBAd.T_RGBA, tPixel.T_RGBA, RotType
  Protected *SrcMem, *DestMem, BufferPitchSrc, BufferPitchDest
  Protected SrcWidth, SrcHeight, DestWidth, DestHeight, nDestImage
  Protected X, Y, Xs, Ys
  Protected BitPlanes
  
  ; sanity checks
  
  If IsImage(nSrcImage) = 0
    ProcedureReturn 0
  EndIf
  
  BitPlanes = ImageDepth(nSrcImage)
  
  If BitPlanes <> 24 And BitPlanes <> 32
    ProcedureReturn 0
  EndIf
  
  If DegRot % 90
    ProcedureReturn 0
  EndIf
  
  DegRot % 360
  
  If DegRot = 0
    ProcedureReturn CopyImage(nSrcImage, #PB_Any)
  EndIf
  
  CompilerIf (#PB_Compiler_OS = #PB_OS_Linux)
    DegRot = -DegRot
  CompilerEndIf
  
  SrcWidth = ImageWidth(nSrcImage)
  SrcHeight = ImageHeight(nSrcImage)
  
  Select DegRot           
    Case 90, -270
      DestWidth = SrcHeight
      DestHeight = SrcWidth
      RotType = 1
    Case 180, -180
      RotType = 2
      DestWidth = SrcWidth
      DestHeight = SrcHeight
    Case 270, -90
      RotType = 3
      DestWidth = SrcHeight
      DestHeight = SrcWidth
  EndSelect
  
  ; create 24/32 bit destination image
  nDestImage = CreateImage(#PB_Any, DestWidth, DestHeight, BitPlanes)
  TRY (nDestImage)
  
  ; copy src image to allocated memory
  *SrcMem = AllocateImageData(nSrcImage, @BufferPitchSrc)
  TRY (*SrcMem, #EXC_ALLOC_ERR)
  
  ; copy dest image to allocated memory
  *DestMem = AllocateImageData(nDestImage, @BufferPitchDest)
  TRY (*DestMem, #EXC_ALLOC_ERR)
  
  Select BitPlanes
    Case 24
      For Y = 0 To DestHeight - 1
        For X = 0 To DestWidth - 1
          
          Select RotType
            Case 1
              Ys = SrcHeight - X - 1
              Xs = Y
            Case 2
              Ys = SrcHeight - Y - 1
              Xs = SrcWidth - X - 1   
            Case 3
              Ys = X
              Xs = SrcWidth - Y - 1
          EndSelect
          
          CopyPixel24 (Xs, Ys, X, Y, BufferPitchSrc, BufferPitchDest, *tRGBAs, *tRGBAd, *SrcMem, *DestMem)
          
        Next
      Next   
    Case 32
      For Y = 0 To DestHeight - 1
        For X = 0 To DestWidth - 1
          
          Select RotType
            Case 1
              Ys = SrcHeight - X - 1
              Xs = Y
            Case 2
              Ys = SrcHeight - Y - 1
              Xs = SrcWidth - X - 1   
            Case 3
              Ys = X
              Xs = SrcWidth - Y - 1
          EndSelect
          
          CopyPixel32 (Xs, Ys, X, Y, BufferPitchSrc, BufferPitchDest, *tRGBAs, *tRGBAd, *SrcMem, *DestMem)                   
          
        Next
      Next   
  EndSelect
  
  CopyImageData(nDestImage, *DestMem)
  
  FreeMemory(*SrcMem)
  FreeMemory(*DestMem)
  
  ProcedureReturn nDestImage
  
  CATCH()
  
  If EXCEPTION = #EXC_ALLOC_ERR
    If *SrcMem <> 0 : FreeMemory(*SrcMem) : EndIf
    If *DestMem <> 0 : FreeMemory(*DestMem) : EndIf   
    FreeImage(nDestImage)
  EndIf
  
  ProcedureReturn 0
EndProcedure


Procedure.i RotateImageFree (nSrcImage, fDegRot.f, flgAntiAliasing, FillColor = $ffffff)
  ; Rotates 24 bit images at any angle optionally with anti-aliasing filling the new area of the resulting image with the specified color.
  
  ; Rotates 32 bit images at any angle optionally with anti-aliasing preserving the alpha-channel.
  
  Protected *tRGBAs.T_RGBA, *tRGBAd.T_RGBA, tPixel.T_RGBA
  Protected *SrcMem, *DestMem, BufferPitchSrc, BufferPitchDest
  Protected fzCos.f, fzSin.f
  Protected SrcWidth, SrcHeight, DestWidth, DestHeight, BitPlanes, nDestImage
  Protected X, Y, Xs, Ys, Xc1, Yc1, Xc2, Yc2, iColor
  Protected XRoundFix, YRoundFix
  
  ; sanity checks
  If IsImage(nSrcImage) = 0
    ProcedureReturn 0
  EndIf
  
  BitPlanes = ImageDepth(nSrcImage)
  
  If BitPlanes <> 24 And BitPlanes <> 32
    ProcedureReturn 0
  EndIf
  
  If fDegRot >= 360.0 ; wrap it
    fDegRot = 360.0 * (fDegRot / 360.0 - Int(fDegRot / 360.0))
  EndIf
  
  If fDegRot = 0.0 Or fDegRot = 90.0 Or fDegRot = 180.0 Or fDegRot = 270.0
    ProcedureReturn RotateImage(nSrcImage, fDegRot)
  EndIf
  
  If fDegRot > 270.0
    XRoundFix = -1
    YRoundFix = 0   
  ElseIf fDegRot > 180.0
    XRoundFix = -1
    YRoundFix = -1
  Else
    XRoundFix = 0
    YRoundFix = -1
  EndIf
  
  CompilerIf (#PB_Compiler_OS = #PB_OS_Linux)
    fDegRot = -fDegRot
  CompilerEndIf
  
  fzCos = Cos(Radian(fDegRot))
  fzSin = Sin(Radian(fDegRot))
  
  SrcWidth = ImageWidth(nSrcImage)
  SrcHeight = ImageHeight(nSrcImage)
  
  DestWidth = Round(SrcWidth * Abs(fzCos) + SrcHeight * Abs(fzSin) + 1.0, #PB_Round_Up)
  DestHeight = Round(SrcHeight * Abs(fzCos) + SrcWidth * Abs(fzSin) + 1.0, #PB_Round_Up)
  
  Xc1 = SrcWidth / 2
  Yc1 = SrcHeight / 2
  Xc2 = DestWidth / 2
  Yc2 = DestHeight / 2
  
  ; create 24/32 bit destination image
  nDestImage = CreateImage(#PB_Any, DestWidth, DestHeight, BitPlanes)
  TRY (nDestImage)
  
  ; copy src image to allocated memory
  *SrcMem = AllocateImageData (nSrcImage, @BufferPitchSrc)
  TRY (*SrcMem, #EXC_ALLOC_ERR)
  
  ; copy dest image to allocated memory and fill with backcolor
  *DestMem = AllocateImageData(nDestImage, @BufferPitchDest, FillColor)
  TRY (*DestMem, #EXC_ALLOC_ERR)
  
  Select flgAntiAliasing
      
    Case #False   
      
      Select BitPlanes
        Case 24
          
          For Y = 0 To DestHeight - 1
            For X = 0 To DestWidth - 1
              
              ; For each nDestImage point find rotated nSrcImage source point
              Xs = Xc1 + (X - Xc2) * fzCos + (Y - Yc2) * fzSin + XRoundFix
              Ys = Yc1 + (Y - Yc2) * fzCos - (X - Xc2) * fzSin + YRoundFix
              
              If Xs >= 0 And Xs < SrcWidth  And Ys >= 0 And Ys < SrcHeight
                ; Move valid rotated nSrcImage source points to nDestImage                   
                CopyPixel24 (Xs, Ys, X, Y, BufferPitchSrc, BufferPitchDest, *tRGBAs, *tRGBAd, *SrcMem, *DestMem)
              EndIf
              
            Next
          Next   
          
        Case 32
          
          For Y = 0 To DestHeight - 1
            For X = 0 To DestWidth - 1
              ; For each nDestImage point find rotated nSrcImage source point
              Xs = Xc1 + (X - Xc2) * fzCos + (Y - Yc2) * fzSin + XRoundFix
              Ys = Yc1 + (Y - Yc2) * fzCos - (X - Xc2) * fzSin + YRoundFix
              
              If Xs >= 0 And Xs < SrcWidth  And Ys >= 0 And Ys < SrcHeight
                ; Move valid rotated nSrcImage source points to nDestImage                   
                CopyPixel32 (Xs, Ys, X, Y, BufferPitchSrc, BufferPitchDest, *tRGBAs, *tRGBAd, *SrcMem, *DestMem)
              EndIf
              
            Next
          Next   
          
      EndSelect
      
    Case #True
      
      Protected Xs0, Ys0, icr, icg, icb, icr0, icg0, icb0, icr1, icg1, icb1
      Protected fXs.f, fYs.f, fXfs1.f, fYfs1.f
      Protected fXfs1less.f, fYfs1less.f
      
      Select BitPlanes
          
        Case 24
          
          For Y = 0 To DestHeight - 1
            For X = 0 To DestWidth - 1
              
              ; For each nDestImage point find rotated nSrcImage source point
              fXs = Xc1 + (X - Xc2) * fzCos + (Y - Yc2) * fzSin + XRoundFix
              fYs = Yc1 + (Y - Yc2) * fzCos - (X - Xc2) * fzSin + YRoundFix
              
              ; Bottom left coords of bounding floating point rectangle on nSrcImage
              Xs0 = Int(fXs)   
              Ys0 = Int(fYs)
              
              If Xs0 >= 0 And Xs0 <= SrcWidth -1 And Ys0 >= 0 And Ys0 <= SrcHeight - 1                       
                fXfs1 = fXs - Int(fXs)
                fYfs1 = fYs - Int(fYs)
                
                fXfs1less = 1 - fXfs1 - 0.000005 : If fXfs1less < 0 : fXfs1less = 0 : EndIf
                fYfs1less = 1 - fYfs1 - 0.000005 : If fYfs1less < 0 : fYfs1less = 0 : EndIf
                
                ReadPixel24 (Xs0, Ys0, BufferPitchSrc, *tRGBAs, *SrcMem)                                                                                                                               
                icr = *tRGBAs\R * fXfs1less
                icg = *tRGBAs\G * fXfs1less
                icb = *tRGBAs\B * fXfs1less
                
                ReadPixel24 (Xs0 + 1, Ys0, BufferPitchSrc, *tRGBAs, *SrcMem)
                icr0 = *tRGBAs\R * fXfs1 + icr
                icg0 = *tRGBAs\G * fXfs1 + icg
                icb0 = *tRGBAs\B * fXfs1 + icb
                
                ReadPixel24 (Xs0, Ys0 + 1, BufferPitchSrc, *tRGBAs, *SrcMem)
                icr = *tRGBAs\R * fXfs1less
                icg = *tRGBAs\G * fXfs1less
                icb = *tRGBAs\B * fXfs1less
                
                ReadPixel24 (Xs0 + 1, Ys0 + 1, BufferPitchSrc, *tRGBAs, *SrcMem)
                icr1 = *tRGBAs\R * fXfs1 + icr
                icg1 = *tRGBAs\G * fXfs1 + icg
                icb1 = *tRGBAs\B * fXfs1 + icb
                
                ; Weight along axis Y
                tPixel\R = fYfs1less * icr0 + fYfs1 * icr1
                tPixel\G = fYfs1less * icg0 + fYfs1 * icg1
                tPixel\B = fYfs1less * icb0 + fYfs1 * icb1                           
                
                WritePixel24 (tPixel, X, Y, BufferPitchDest, *tRGBAd, *DestMem)                               
              EndIf           
            Next
          Next           
          
        Case 32
          
          Protected ica, ica0, ica1
          
          For Y = 0 To DestHeight - 1
            For X = 0 To DestWidth - 1
              
              ; For each nDestImage point find rotated nSrcImage source point
              fXs = Xc1 + (X - Xc2) * fzCos + (Y - Yc2) * fzSin + XRoundFix
              fYs = Yc1 + (Y - Yc2) * fzCos - (X - Xc2) * fzSin + YRoundFix
              
              ; Bottom left coords of bounding floating point rectangle on nSrcImage
              Xs0 = Int(fXs)   
              Ys0 = Int(fYs)                       
              
              If Xs0 >= 0 And Xs0 <= SrcWidth - 1 And Ys0 >= 0 And Ys0 < SrcHeight - 1
                
                fXfs1 = fXs - Int(fXs)
                fYfs1 = fYs - Int(fYs)
                
                fXfs1less = 1 - fXfs1 - 0.000005 : If fXfs1less < 0 : fXfs1less = 0 : EndIf
                fYfs1less = 1 - fYfs1 - 0.000005 : If fYfs1less < 0 : fYfs1less = 0 : EndIf
                
                ReadPixel32 (Xs0, Ys0, BufferPitchSrc, *tRGBAs, *SrcMem)                                                                                                                                                       
                icr = *tRGBAs\R * fXfs1less
                icg = *tRGBAs\G * fXfs1less
                icb = *tRGBAs\B * fXfs1less
                ica = *tRGBAs\A * fXfs1less
                
                ReadPixel32 (Xs0 + 1, Ys0, BufferPitchSrc, *tRGBAs, *SrcMem)
                icr0 = *tRGBAs\R * fXfs1 + icr
                icg0 = *tRGBAs\G * fXfs1 + icg
                icb0 = *tRGBAs\B * fXfs1 + icb
                ica0 = *tRGBAs\A * fXfs1 + ica
                
                ReadPixel32 (Xs0, Ys0 + 1, BufferPitchSrc, *tRGBAs, *SrcMem)
                icr = *tRGBAs\R * fXfs1less
                icg = *tRGBAs\G * fXfs1less
                icb = *tRGBAs\B * fXfs1less
                ica = *tRGBAs\A * fXfs1less
                
                ReadPixel32 (Xs0 + 1, Ys0 + 1, BufferPitchSrc, *tRGBAs, *SrcMem)
                icr1 = *tRGBAs\R * fXfs1 + icr
                icg1 = *tRGBAs\G * fXfs1 + icg
                icb1 = *tRGBAs\B * fXfs1 + icb
                ica1 = *tRGBAs\A * fXfs1 + ica
                
                ; Weight along axis Y
                tPixel\R = fYfs1less * icr0 + fYfs1 * icr1
                tPixel\G = fYfs1less * icg0 + fYfs1 * icg1
                tPixel\B = fYfs1less * icb0 + fYfs1 * icb1
                tPixel\A = fYfs1less * ica0 + fYfs1 * ica1                           
                
                WritePixel32 (tPixel, X, Y, BufferPitchDest, *tRGBAd, *DestMem)
              EndIf           
            Next
          Next           
          
      EndSelect
  EndSelect
  
  CopyImageData(nDestImage, *DestMem)
  
  FreeMemory(*SrcMem)
  FreeMemory(*DestMem)
  
  ProcedureReturn nDestImage
  
  CATCH()
  
  If EXCEPTION = #EXC_ALLOC_ERR
    If *SrcMem <> 0 : FreeMemory(*SrcMem) : EndIf
    If *DestMem <> 0 : FreeMemory(*DestMem) : EndIf
    FreeImage(nDestImage)
  EndIf
  
  ProcedureReturn 0
EndProcedure


Procedure.i FlipImage (nSrcImage)
  
  ; Flip vertically a 24/32 bit image preserving the alpha-channel
  
  Protected *tRGBAs.T_RGBA, *tRGBAd.T_RGBA, tPixel.T_RGBA, RotType
  Protected *SrcMem, *DestMem, BufferPitchSrc, BufferPitchDest
  Protected SrcWidth, SrcHeight, DestWidth, DestHeight, nDestImage
  Protected X, Y
  Protected BitPlanes
  
  ; sanity checks
  If IsImage(nSrcImage) = 0
    ProcedureReturn 0
  EndIf
  
  BitPlanes = ImageDepth(nSrcImage)
  
  If BitPlanes <> 24 And BitPlanes <> 32
    ProcedureReturn 0
  EndIf
  
  SrcWidth = ImageWidth(nSrcImage)
  SrcHeight = ImageHeight(nSrcImage)
  
  DestWidth = SrcWidth
  DestHeight = SrcHeight
  
  ; create 24/32 bit destination image
  nDestImage = CreateImage(#PB_Any, DestWidth, DestHeight, BitPlanes)
  TRY (nDestImage)
  
  ; copy src image to allocated memory
  *SrcMem = AllocateImageData(nSrcImage, @BufferPitchSrc)
  TRY (*SrcMem, #EXC_ALLOC_ERR)
  
  ; copy dest image to allocated memory
  *DestMem = AllocateImageData(nDestImage, @BufferPitchDest)
  TRY (*DestMem, #EXC_ALLOC_ERR)
  
  Select BitPlanes
    Case 24
      For Y = 0 To DestHeight - 1
        For X = 0 To DestWidth - 1           
          CopyPixel24 (X, SrcHeight - Y - 1, X, Y, BufferPitchSrc, BufferPitchDest, *tRGBAs, *tRGBAd, *SrcMem, *DestMem)
        Next
      Next       
    Case 32
      For Y = 0 To DestHeight - 1
        For X = 0 To DestWidth - 1           
          CopyPixel32 (X, SrcHeight - Y - 1, X, Y, BufferPitchSrc, BufferPitchDest, *tRGBAs, *tRGBAd, *SrcMem, *DestMem)
        Next
      Next   
  EndSelect
  
  CopyImageData(nDestImage, *DestMem)
  
  FreeMemory(*SrcMem)
  FreeMemory(*DestMem)
  
  ProcedureReturn nDestImage
  
  CATCH()
  
  If EXCEPTION = #EXC_ALLOC_ERR
    If *SrcMem <> 0 : FreeMemory(*SrcMem) : EndIf
    If *DestMem <> 0 : FreeMemory(*DestMem) : EndIf   
    FreeImage(nDestImage)
  EndIf
  
  ProcedureReturn 0
EndProcedure

Procedure.i MirrorImage (nSrcImage)
  
  ; Mirror horizontally a 24/32 bit image preserving the alpha-channel
  
  Protected *tRGBAs.T_RGBA, *tRGBAd.T_RGBA, tPixel.T_RGBA, RotType
  Protected *SrcMem, *DestMem, BufferPitchSrc, BufferPitchDest, BitPlanes
  Protected SrcWidth, SrcHeight, DestWidth, DestHeight, nDestImage
  Protected X, Y
  
  ; sanity checks
  If IsImage(nSrcImage) = 0
    ProcedureReturn 0
  EndIf
  
  BitPlanes = ImageDepth(nSrcImage)
  
  If BitPlanes <> 24 And BitPlanes <> 32
    ProcedureReturn 0
  EndIf
  
  SrcWidth = ImageWidth(nSrcImage)
  SrcHeight = ImageHeight(nSrcImage)
  
  DestWidth = SrcWidth
  DestHeight = SrcHeight
  
  ; create 24/32 bit destination image
  nDestImage = CreateImage(#PB_Any, DestWidth, DestHeight, BitPlanes)
  TRY (nDestImage)
  
  ; copy src image to allocated memory
  *SrcMem = AllocateImageData(nSrcImage, @BufferPitchSrc)
  TRY (*SrcMem, #EXC_ALLOC_ERR)
  
  ; copy dest image to allocated memory
  *DestMem = AllocateImageData(nDestImage, @BufferPitchDest)
  TRY (*DestMem, #EXC_ALLOC_ERR)
  
  Select BitPlanes
    Case 24
      For Y = 0 To DestHeight - 1
        For X = 0 To DestWidth - 1
          CopyPixel24 (SrcWidth - X - 1, Y, X, Y, BufferPitchSrc, BufferPitchDest, *tRGBAs, *tRGBAd, *SrcMem, *DestMem)     
        Next
      Next   
    Case 32
      For Y = 0 To DestHeight - 1
        For X = 0 To DestWidth - 1
          CopyPixel32 (SrcWidth - X - 1, Y, X, Y, BufferPitchSrc, BufferPitchDest, *tRGBAs, *tRGBAd, *SrcMem, *DestMem)     
        Next
      Next   
  EndSelect
  
  CopyImageData(nDestImage, *DestMem)
  
  FreeMemory(*SrcMem)
  FreeMemory(*DestMem)
  
  ProcedureReturn nDestImage
  
  CATCH()
  
  If EXCEPTION = #EXC_ALLOC_ERR   
    If *SrcMem <> 0 : FreeMemory(*SrcMem) : EndIf
    If *DestMem <> 0 : FreeMemory(*DestMem) : EndIf       
    FreeImage(nDestImage)
  EndIf
  
  ProcedureReturn 0
EndProcedure

; example 1
CompilerIf #PB_Compiler_IsMainFile = 5
  ; TEST - RotateImageFree

EnableExplicit

;IncludeFile "..\RotateImage.pb"

Procedure.i CreateCheckers (Width, Height)
 Protected x, y
 Protected nImage, Size = 12
   
 nImage = CreateImage(#PB_Any, Width, Height, 24)
   
 If nImage
    StartDrawing(ImageOutput(nImage))
      
     Box(0, 0, Width, Height, $FFFFFF)
      
     While y < Height + Size
         While x < Width + Size
            Box(x, y, Size, Size, $C0C0C0)
            Box(x + Size, y + Size, Size, Size, $C0C0C0)
            x + Size * 2
         Wend
         x = 0
         y + Size * 2
     Wend
      
    StopDrawing()
 EndIf
   
 ProcedureReturn nImage
EndProcedure

Procedure.i MergeImages (nImgCheck, nImgOut)
 Protected nImage
   
 nImage = CreateImage(#PB_Any, ImageWidth(nImgCheck), ImageHeight(nImgCheck), 24)
   
 If nImage
    StartDrawing(ImageOutput(nImage))
      
     DrawImage(ImageID(nImgCheck), 0, 0)
     DrawAlphaImage(ImageID(nImgOut), 0, 0)
      
    StopDrawing()
 EndIf
   
 ProcedureReturn nImage   
EndProcedure


#WIN = 1
#IMG = 1

#IW = 640
#IH = 480

Define Event, Time1, k
Define nImgSrc, nImgOut, nFont
Define nImgCheck, nImgDisp


; ****************************************************************
; try to change these vars to check out the various combinations *
; ****************************************************************

Define BitPlanes = 32                   ; try 24 or 32 bpp image
Define flgAntiAlias = 1                 ; try antialias (1) or simpler rotation (0)
Define fRot = 33                        ; angle used for rotation
Define FillColor = RGB(255,255,255)     ; useful for transparent masking using GDI or simply to fill the background

nFont = LoadFont(#PB_Any, "Arial", 12, #PB_Font_Bold)

nImgSrc = CreateImage(#PB_Any, #IW, #IH, BitPlanes)

StartDrawing(ImageOutput(nImgSrc))

For k = 0 To 100 Step 20
   Box(0 + k, 0 + k, #IW - k * 2, #IH - k * 2, RGB(k + 50, k + 100, k + 150))
Next

DrawingMode(#PB_2DDrawing_Transparent)
DrawingFont(FontID(nFont))

For k = 0 To #IH Step #IH / 10
   DrawText(20, k + 10, "TEXT - " + Str(BitPlanes) + " BPP IMAGE - TEXT", RGB(k/3, k/2, k/2))
Next

If BitPlanes = 24
   DrawingMode(#PB_2DDrawing_Default)
   Circle(#IW - 200, 100, 50, RGB(128,0,0))
   Circle(#IW - 200, #IH - 100, 50, RGB(0,128,0))   
   Circle(#IW - 80, #IH/2, 50, RGB(0,0,128))
Else
   FillColor = 0
   
   ; make 3 holes
   DrawingMode(#PB_2DDrawing_AlphaChannel)
   Circle(#IW - 200, 100, 50,  $00)
   Circle(#IW - 200, #IH - 100, 50, $00)
   Circle(#IW - 80, #IH/2, 50, $00)
   
   ; fill them with semi-transparent circles
   DrawingMode(#PB_2DDrawing_AlphaBlend)
   Circle(#IW - 200, 100, 50, RGBA(128,0,0,100))
   Circle(#IW - 200, #IH - 100, 50, RGBA(0,128,0,100))
   Circle(#IW - 80, #IH/2, 50, RGBA(0,0,128,100))
EndIf

StopDrawing()

If OpenWindow(#WIN, 0, 0, 800, 800, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)   
   Time1 = ElapsedMilliseconds()
   
   nImgOut = RotateImageFree(nImgSrc, fRot, flgAntiAlias, FillColor)
   
   Time1 = ElapsedMilliseconds() - Time1
   
   SetWindowTitle(#WIN, "Test " + Str(BitPlanes) + " bit, AA = " + Str(flgAntiAlias) + ", msec = " + Str(Time1) + ", deg = " + StrF(fRot,1))
   
   nImgCheck = CreateCheckers(ImageWidth(nImgOut), ImageHeight(nImgOut))
   nImgDisp = MergeImages(nImgCheck, nImgOut)
      
   FreeImage(nImgOut)
   FreeImage(nImgCheck)
      
  
   ImageGadget(#IMG, 0, 0, 0, 0, ImageID(nImgDisp))
   
   FreeImage(nImgDisp)
   
   While Event <> #PB_Event_CloseWindow           
      Event = WaitWindowEvent()
   Wend
      
   FreeImage(nImgSrc)
   FreeFont(nFont)
EndIf

CompilerEndIf

; example 2
CompilerIf #PB_Compiler_IsMainFile = 6
; TEST - RotateImage

EnableExplicit

;IncludeFile "..\RotateImage.pb"

Procedure.i CreateCheckers (Width, Height)
 Protected x, y
 Protected nImage, Size = 12
 
 nImage = CreateImage(#PB_Any, Width, Height, 24)
 
 If nImage
    StartDrawing(ImageOutput(nImage))
    
     Box(0, 0, Width, Height, $FFFFFF)
     
     While y < Height + Size
        While x < Width + Size
            Box(x, y, Size, Size, $C0C0C0)
            Box(x + Size, y + Size, Size, Size, $C0C0C0)
            x + Size * 2
        Wend
        x = 0
        y + Size * 2
     Wend
     
    StopDrawing()
 EndIf
 
 ProcedureReturn nImage 
EndProcedure

Procedure.i MergeImages (nImgCheck, nImgOut)
 Protected nImage
 
 nImage = CreateImage(#PB_Any, ImageWidth(nImgCheck), ImageHeight(nImgCheck), 24)

 If nImage
    StartDrawing(ImageOutput(nImage))
    
     DrawImage(ImageID(nImgCheck), 0, 0)
     DrawAlphaImage(ImageID(nImgOut), 0, 0)
          
    StopDrawing()
 EndIf
 
 ProcedureReturn nImage 

EndProcedure


#WIN = 1
#IMG = 1

#IW = 640
#IH = 480

Define Event, Time1, k
Define nImgSrc, nImgOut, nFont
Define nImgCheck, nImgDisp


; ****************************************************************
; try to change these vars to check out the various combinations *
; ****************************************************************

Define BitPlanes = 32          ; test 24 or 32 bpp image
Define Rot = 90                ; angle used for rotation (+/-) 90, 180, 270


nFont = LoadFont(#PB_Any, "Arial", 14, #PB_Font_Bold)

nImgSrc = CreateImage(#PB_Any, #IW, #IH, BitPlanes)
       
StartDrawing(ImageOutput(nImgSrc))
 
 For k = 0 To 100 Step 20
    Box(0 + k, 0 + k, #IW - k * 2, #IH - k * 2, RGB(k + 50, k + 100, k + 150)) 
 Next

 DrawingMode(#PB_2DDrawing_Transparent)
 DrawingFont(FontID(nFont))
 
 For k = 0 To #IH Step #IH / 10
    DrawText(20, k + 8, "Text - " + Str(BitPlanes) + " BPP image - Text", RGB(k/3, k/2, k/2))
 Next

 If BitPlanes = 24        
    DrawingMode(#PB_2DDrawing_Default)                
    Circle(#IW - 200, 100, 50, RGB(128,0,0))
    Circle(#IW - 200, #IH - 100, 50, RGB(0,128,0))    
    Circle(#IW - 80, #IH/2, 50, RGB(0,0,128))        
 Else
    ; make 3 holes
    DrawingMode(#PB_2DDrawing_AlphaChannel)    
    Circle(#IW - 80, #IH/2, 50, $00)
    Circle(#IW - 200, 100, 50,  $00)
    Circle(#IW - 200, #IH - 100, 50, $00)
    
    ; fill them with semi-transparent circles
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    Circle(#IW - 200, 100, 50, RGBA(128,0,0,100))
    Circle(#IW - 200, #IH - 100, 50, RGBA(0,128,0,100))
    Circle(#IW - 80, #IH/2, 50, RGBA(0,0,128,100))        
 EndIf
  
StopDrawing() 

    
; UsePNGImageDecoder()
; nImgSrc = LoadImage(#PB_Any, "test32.png")


If OpenWindow(#WIN, 0, 0, 600, 700, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
            
    Time1 = ElapsedMilliseconds()          
    nImgOut = RotateImage (nImgSrc, Rot)
    Time1 = ElapsedMilliseconds() - Time1
    
    If nImgOut = 0 : MessageRequester("Test", "Invalid angle ? (" + Str(Rot) + ")") :End: EndIf
    
    SetWindowTitle(#WIN, "Test " + Str(BitPlanes) + " bit, msec = " + Str(Time1) + ", deg = " + Str(Rot))

    nImgCheck = CreateCheckers(ImageWidth(nImgOut), ImageHeight(nImgOut))
    nImgDisp = MergeImages(nImgCheck, nImgOut)
        
    FreeImage(nImgOut)
    FreeImage(nImgCheck)
        
    ImageGadget(#IMG, 0, 0, 0, 0, ImageID(nImgDisp), #PB_Image_Border)
    
    While Event <> #PB_Event_CloseWindow            
        Event = WaitWindowEvent()
    Wend
                
    FreeImage(nImgDisp)
    FreeImage(nImgSrc)
    FreeFont(nFont)
EndIf
CompilerEndIf

; example 3
CompilerIf #PB_Compiler_IsMainFile 
; TEST - Flip and Mirror

EnableExplicit

;IncludeFile "..\RotateImage.pb"

Procedure.i CreateCheckers3 (Width, Height)
 Protected x, y
 Protected nImage, Size = 12
 
 nImage = CreateImage(#PB_Any, Width, Height, 24)
 
 If nImage
    StartDrawing(ImageOutput(nImage))
    
     Box(0, 0, Width, Height, $FFFFFF)
     
     While y < Height + Size
        While x < Width + Size
            Box(x, y, Size, Size, $C0C0C0)
            Box(x + Size, y + Size, Size, Size, $C0C0C0)
            x + Size*2           
        Wend
        x = 0
        y + Size*2
     Wend
     
    StopDrawing()
 EndIf
 
 ProcedureReturn nImage 
EndProcedure

Procedure.i MergeImages3 (nImgCheck, nImgOut)
 Protected nImage
 
 nImage = CreateImage(#PB_Any, ImageWidth(nImgCheck), ImageHeight(nImgCheck), 24)

 If nImage
    StartDrawing(ImageOutput(nImage))
    
     DrawImage(ImageID(nImgCheck), 0, 0)
     DrawAlphaImage(ImageID(nImgOut), 0, 0)
          
    StopDrawing()
 EndIf
 
 ProcedureReturn nImage 

EndProcedure


#WIN   = 1
#IMG_1 = 1
#IMG_2 = 2

#IW = 512
#IH = 360

Define Event, Time1, k, Title$
Define nImgSrc, nImgOut, nFont
Define nImgCheck, nImgDisp1, nImgDisp2


; ****************************************************************
; try to change these vars to check out the various combinations *
; ****************************************************************

Define BitPlanes = 32          ; test 24 or 32 bpp image
Define flgFlipOrMirror = 0     ; 1 = FlipImage(),  0 = MirrorImage()


nFont = LoadFont(#PB_Any, "Arial", 12, #PB_Font_Bold)

nImgSrc = CreateImage(#PB_Any, #IW, #IH, BitPlanes)
       
StartDrawing(ImageOutput(nImgSrc))
 
 For k = 0 To 100 Step 20
    Box(0 + k, 0 + k, #IW - k * 2, #IH - k * 2, RGB(k + 50, k + 100, k + 150)) 
 Next

 DrawingMode(#PB_2DDrawing_Transparent)
 DrawingFont(FontID(nFont))
 
 For k = 0 To #IH Step #IH / 10
    DrawText(20, k + 8, "Text - " + Str(BitPlanes) + " BPP image - Text", RGB(k/3, k/2, k/2))
 Next

 If BitPlanes = 24
    DrawingMode(#PB_2DDrawing_Default)                
    Circle(#IW - 180, 100, 50, RGB(128,0,0))
    Circle(#IW - 180, #IH - 100, 50, RGB(0,128,0))    
    Circle(#IW - 80, #IH/2, 50, RGB(0,0,128))        
 Else
    ; make 3 holes
    DrawingMode(#PB_2DDrawing_AlphaChannel)        
    Circle(#IW - 180, 100, 50,  $00)
    Circle(#IW - 180, #IH - 100, 50, $00)
    Circle(#IW - 80, #IH/2, 50, $00)
    
    ; fill them with semi-transparent circles
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    Circle(#IW - 180, 100, 50, RGBA(128,0,0,100))
    Circle(#IW - 180, #IH - 100, 50, RGBA(0,128,0,100))
    Circle(#IW - 80, #IH/2, 50, RGBA(0,0,128,100))        
 EndIf
  
StopDrawing() 

    
;;UsePNGImageDecoder()    
;;nImgSrc = LoadImage(#PB_Any, "test24.bmp")
;;nImgSrc = LoadImage(#PB_Any, "test32.png")


If OpenWindow(#WIN, 0, 0, 600, 800, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
            
    Time1 = ElapsedMilliseconds()          

    If flgFlipOrMirror = 1        
        nImgOut = FlipImage(nImgSrc)
    Else
        nImgOut = MirrorImage(nImgSrc)
    EndIf   
    
    Time1 = ElapsedMilliseconds() - Time1
    
    If flgFlipOrMirror = 1
        Title$ = "Test FlipImage(), " 
    Else
        Title$ = "Test MirrorImage(), " 
    EndIf   
                       
    SetWindowTitle(#WIN, Title$ + Str(BitPlanes) + " bit, msec = " + Str(Time1))

    nImgCheck = CreateCheckers3(ImageWidth(nImgOut), ImageHeight(nImgOut))
    
    nImgDisp1 = MergeImages3(nImgCheck, nImgSrc)
        
    nImgDisp2 = MergeImages3(nImgCheck, nImgOut)
        
        
    FreeImage(nImgOut)
    FreeImage(nImgCheck)
    
    ImageGadget(#IMG_1, 0, 0, 0, 0, ImageID(nImgDisp1), #PB_Image_Border)    
    ImageGadget(#IMG_2, 0, 400, 0, 0, ImageID(nImgDisp2), #PB_Image_Border)
    
    While Event <> #PB_Event_CloseWindow            
        Event = WaitWindowEvent()
    Wend
    
    FreeImage(nImgDisp1)            
    FreeImage(nImgDisp2)
    FreeImage(nImgSrc)
    FreeFont(nFont)
EndIf

CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -----4---+084-+-
; EnableXP