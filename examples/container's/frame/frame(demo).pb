﻿IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  If Open(0, 0, 0, 320+310, 250, "FrameGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    FrameGadget(0, 10,  10, 300, 50, "FrameGadget Standard")
    FrameGadget(1, 10,  70, 300, 50, "FrameGadget_Single", #PB_Frame_Single)
    FrameGadget(2, 10, 130, 300, 50, "FrameGadget_Double", #PB_Frame_Double)
    FrameGadget(3, 10, 190, 300, 50, "FrameGadget_Flat", #PB_Frame_Flat)
    
    Frame(310+10,  10, 300, 50, "FrameGadget Standard")
    Frame(310+10,  70, 300, 50, "FrameGadget_Single", #PB_Frame_Single)
    Frame(310+10, 130, 300, 50, "FrameGadget_Double", #PB_Frame_Double)
    Frame(310+10, 190, 300, 50, "FrameGadget_Flat", #PB_Frame_Flat)
    
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = -
; EnableXP