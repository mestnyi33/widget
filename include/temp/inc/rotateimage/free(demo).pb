; TEST - RotateImageFree

EnableExplicit

IncludeFile "../rotateimage.pbi"

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
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP