Define text.s = "H"

Macro PB(Function)
  Function
EndMacro

CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
  Macro LoadFont( _font_, _name_, _height_, _style_ = 0 )
    PB(LoadFont)( _font_, _name_, _height_ - 7, _style_ )
  EndMacro
CompilerEndIf

CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_MacOS
    Procedure.i mac_TextWidth( Text.s, fontID )
      Protected NSString, Attributes, NSSize.NSSize
      NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
      Attributes = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", fontID, "forKey:$", @"NSFont")
      ;Attributes = CocoaMessage(0, 0, "NSMutableDictionary dictionaryWithObject:", fontID, "forKey:$", @"NSFont")
      CocoaMessage(@NSSize, NSString, "sizeWithAttributes:", Attributes)
      ProcedureReturn NSSize\width
    EndProcedure
CompilerEndSelect

Define FontID = LoadFont( 5, "Arial", 29) ; 29/7 ; 19/5 ; 10/2

If OpenWindow(0, 0, 0, 250, 250, "mac", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CreateImage(0, 200, 200) 
  ImageGadget(0, 0, 0, 200, 200, ImageID(0))
  
  If StartDrawing(ImageOutput(0))
    DrawingFont(FontID)
    Define color = RGB(Random(255), Random(255), Random(255))
    Define width 
    Define height = TextHeight( " " )
    
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_MacOS
        width = mac_TextWidth(text, FontID )
      CompilerDefault
        width = TextWidth( text )
    CompilerEndSelect
    
    DrawingMode(#PB_2DDrawing_Transparent)
    Box(0, 0, 200, 200, RGB(255, 255, 255))
    
    DrawText( 20, 20, text, color )
    DrawText( 20+width, 20, "- "+Str(width) +"x"+ Str(height), color )
    
    DrawingMode(#PB_2DDrawing_Outlined)
    Box( 20, 20 ,width, height, color )
    
    ;
    SetGadgetFont( -1, FontID )
    ButtonGadget(1, 6,60,150, 50, text+"- "+Str(width) +"x"+ Str(height) )
    FontID = GetGadgetFont( - 1 )
    
    DrawingFont(FontID)
    DrawingMode(#PB_2DDrawing_Transparent)
    DrawText( 20, 110, text, color )
    DrawText( 20+width, 110, "- "+Str(width) +"x"+ Str(height), color )
    StopDrawing() 
  EndIf
  
  CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
    SetGadgetState( 0, ImageID(0))
  CompilerEndIf
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP