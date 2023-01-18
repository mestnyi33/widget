CompilerSelect #PB_Compiler_OS 
  CompilerCase #PB_OS_MacOS   : IncludePath "mac"
  CompilerCase #PB_OS_Windows : IncludePath "win"
  CompilerCase #PB_OS_Linux   : IncludePath "lin"
CompilerEndSelect

XIncludeFile "id.pbi"
XIncludeFile "mouse.pbi"
XIncludeFile "parent.pbi"
XIncludeFile "cursor.pbi"

CompilerIf #PB_Compiler_IsMainFile 
  EnableExplicit
  Global eventID
  
  OpenWindow(1, 0, 0, 200, 100, "window", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ButtonGadget(1, 10, 10, 180,80, "button" ) 
  
  Debug "gadget - "+GadgetID(1) +" >> "+ ID::Gadget( GadgetID(1) )
  Debug "window - "+WindowID(1) +" >> "+ ID::Window( WindowID(1) )
  
  Repeat
    eventID = WaitWindowEvent( )
  Until eventID = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP