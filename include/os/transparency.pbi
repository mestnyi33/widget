CompilerIf #PB_Compiler_OS = #PB_OS_Linux
   ImportC "-gtk"
      gtk_widget_is_composited( *widget )
      gtk_window_set_opacity( *window, Opacity.d )
   EndImport
CompilerEndIf

Procedure.i SetWindowTransparency( Window, Transparency.a = 255 )
   Protected WindowID = WindowID( Window )
   ;
   If Transparency < 0 : Transparency = 0 : EndIf
   If Transparency > 255 : Transparency = 255 : EndIf
   ;
   CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
         Protected alpha.d = Transparency / 255.0
         If gtk_widget_is_composited( WindowID )
            gtk_window_set_opacity( WindowID, alpha.d )
            ProcedureReturn #True
         EndIf
         
      CompilerCase #PB_OS_MacOS
         Protected alpha.CGFloat = Transparency / 255.0
         CocoaMessage(0, WindowID, "setOpaque:", #NO )
         If CocoaMessage(0, WindowID, "isOpaque") = #NO
            CocoaMessage(0, WindowID, "setAlphaValue:@", @alpha)
            ProcedureReturn #True
         EndIf
         
      CompilerCase #PB_OS_Windows
         SetWindowLongPtr_( WindowID, #GWL_EXSTYLE, GetWindowLongPtr_( WindowID, #GWL_EXSTYLE ) | #WS_EX_LAYERED )
         SetLayeredWindowAttributes_( WindowID, 0, Transparency, #LWA_ALPHA )
         
         ;
         SetWindowColor(Window, #Blue)
         SetWindowLong_(WindowID, #GWL_EXSTYLE, #WS_EX_LAYERED | #WS_EX_TOPMOST)
         SetLayeredWindowAttributes_(WindowID, #Blue, 255, #LWA_COLORKEY|#LWA_ALPHA)
         
         ProcedureReturn #True
   CompilerEndSelect  
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   OpenWindow(0, 0, 0, 640, 480, "", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)
   SetWindowTransparency( 0, 155 )
   
   Define EventID
   Repeat
      EventID = WaitWindowEvent()
      Select EventID
         Case #PB_Event_Repaint
      EndSelect
   Until EventID = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; Folding = --
; EnableXP