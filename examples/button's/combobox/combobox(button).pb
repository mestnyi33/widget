IncludePath "../../../" 
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  EnableExplicit
  test_clip = 1
  ;test_draw_area = 1
  
  Define a,i, Height=60
  
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
    CocoaMessage(0, ImageID(4), "setSize:@", @ImageSize)
  CompilerElse
    ResizeImage(4, 16, 16)
  CompilerEndIf

 
  Procedure events_widgets()
    
    If WidgetEvent( ) = #__event_LeftClick
      Debug " clk "+ GetText(EventWidget( ))
    EndIf
    
  EndProcedure
  
  
  Procedure TestButton( X,Y,Width,Height, text$, flag=0)
     Protected *g._s_WIDGET
     *g = ComboBox(X,Y,Width,Height, flag)
     SetText( *g, text$)
     ProcedureReturn *g
  EndProcedure
  
  If Open(0, 0, 0, 270, 190, "Combo buttons demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    TestButton(10, 10, 250, 50, "ComboBox1", #PB_ComboBox_Editable|#PB_ComboBox_UpperCase)
    SetImage( widget(), 0)
    
    TestButton(10, 70, 250, 50, "ComboBox2", #PB_ComboBox_LowerCase)
    SetImage( widget(), 1)
    
    TestButton(10, 130, 250, 50, "ComboBox3")
    SetImage( widget(), 2)
    
    
    For i = 0 To 2
      Bind(ID(i), @events_widgets())
    Next
    
    WaitClose( ) 
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 39
; FirstLine = 26
; Folding = --
; EnableXP
; DPIAware