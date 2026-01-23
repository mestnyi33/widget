IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   Define size = 18
   
   Global *g, *g1, *g2, *g3, *g4
   
   Procedure change_events( )
      Protected size = GetState( EventWidget( ))
      SetWindowTitle(EventWindow(), Str(size))
      
      Resize( *g1, 10+size, #PB_Ignore, #PB_Ignore, size )
      Resize( *g2, #PB_Ignore, 10+size, size, #PB_Ignore )
      Resize( *g3, 100+10+size, 10+size, size, #PB_Ignore )
      Resize( *g4, 10+size, 100+10+size, #PB_Ignore, size )
   EndProcedure
   
   If Open( 0, 0, 0, 300, 300, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      
      *g1 = Button( 10+size, 10, 100, size, "top button" )
      *g2 = Button( 10, 10+size, size, 100, "left button", #__flag_Vertical)
      *g3 = Button( 100+10+size, 10+size, size, 100, "right button", #__flag_Vertical|#__flag_Invert)
      *g4 = Button( 10+size, 100+10+size, 100, size, "bottom button", #__flag_Invert)
      
      *g = Track( 10, 300-10-20, 280, 20, 0, 50 )
      SetState( *g, size )
      Bind( *g, @change_events( ), #__event_Change )
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 6
; FirstLine = 1
; Folding = -
; EnableXP
; DPIAware