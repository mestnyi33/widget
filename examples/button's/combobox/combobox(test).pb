
 IncludePath "../../../"
; ;XIncludeFile "widgets.pbi"
 XIncludeFile "widget-events.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(Widget)
  
  UsePNGImageDecoder()
  LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png")
  LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp")
  LoadImage(2, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp")
  CopyImage(1,3)
  CopyImage(2,4)
  ResizeImage(3, 32, 32)
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Define ImageSize.NSSize
    ImageSize\width = 16
    ImageSize\height = 16
;     CocoaMessage(@Width, ImageID(4), "pixelsWide")
;     CocoaMessage(@Height, ImageID(4), "pixelsHigh")
    
    CocoaMessage(0, ImageID(4), "setSize:@", @ImageSize)
  CompilerElse
    ResizeImage(4, 16, 16)
  CompilerEndIf

  Global  *combo1, *combo2, *combo3, a,x,h = 50
  
  If Open(0, 0, 0, 530, 350, "ComboBoxGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ComboBoxGadget(0, 10, 10, 250, h, #PB_ComboBox_Editable)
    AddGadgetItem(0, -1, "ComboBox editable...")
    For a = 1 To 15
      AddGadgetItem(0, -1,"ComboBox item " + Str(a))
    Next
    
    ComboBoxGadget(1, 10, 20+h*1, 250, h, #PB_ComboBox_Image)
    For a = 0 To 4
      AddGadgetItem(1, -1,"ComboBox item with image " + Str(a), ImageID(a))
    Next
    
    ComboBoxGadget(2, 10, 30+h*2, 250, h)
    For a = 0 To 5
      AddGadgetItem(2, -1,"ComboBox item " + Str(a))
    Next
    
    SetGadgetState(0, 0)
    SetGadgetState(1, 0)
    SetGadgetState(2, 3)    ; set (beginning with 0) the third item as active one
    
    x = 260
    ;\\
    *combo1 = ComboBox(10+x, 10, 250, h, #PB_ComboBox_Editable)
    AddItem(widget( ), -1, "ComboBox editable...")
    For a = 1 To 15
      AddItem(widget( ), -1,"ComboBox item " + Str(a))
    Next
    
    *combo2 = ComboBox(10+x, 20+h*1, 250, h, #PB_ComboBox_Image)
    For a = 0 To 4
      AddItem(widget( ), -1,"ComboBox item with image" + Str(a), a)
    Next
    
    *combo3 = ComboBox( 10+x, 30+h*2, 250, h)
    For a = 0 To 5
      AddItem(widget( ), -1,"ComboBox item " + Str(a))
    Next
    
    SetState(*combo1, 0)
    SetState(*combo2, 0)
    SetState(*combo3, 3)    ; set (beginning with 0) the third item as active one
    
    ;\\
    Define s1combo = ComboBoxGadget(#PB_Any, 0,0,0,0)
    For a = 0 To 5
      AddGadgetItem(s1combo, -1,"ComboBox item " + Str(a))
    Next
    
    Define *s1combo = ComboBox( 0,0,0,0 )
    For a = 0 To 5
      AddItem(*s1combo, -1,"ComboBox item " + Str(a))
    Next
    
    Splitter( 10, 40+h*3, 250, h*3, s1combo, *s1combo )
    
    ;\\
    Define s2combo = ComboBoxGadget(#PB_Any, 0,0,0,0)
    For a = 0 To 5
      AddGadgetItem(s2combo, -1,"ComboBox item " + Str(a))
    Next
    
    Define *s2combo = ComboBox( 0,0,0,0 )
    For a = 0 To 5
      AddItem(*s2combo, -1,"ComboBox item " + Str(a))
    Next
    
    Splitter( 10+x, 40+h*3, 250, h*3, s2combo, *s2combo , #PB_Splitter_Vertical)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = 5
; EnableXP