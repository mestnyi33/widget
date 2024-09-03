CompilerIf #PB_Compiler_OS=#PB_OS_Linux
   ImportC "-gtk"
      gtk_widget_is_composited( *widget )
      gtk_window_set_opacity( *window, Opacity.d )
   EndImport
CompilerEndIf

Procedure.i SetWindowTransparency( Window, Transparency.a = 255 )
   Protected windowID = WindowID( Window )
   
   CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
         Protected alpha.d = Transparency / 255.0
         If Transparency >= 0 And Transparency <= 255
            If gtk_widget_is_composited( windowID )
               gtk_window_set_opacity( windowID, alpha.d )
               ProcedureReturn #True
            EndIf
         EndIf
         
      CompilerCase #PB_OS_MacOS
         Protected alpha.CGFloat = Transparency / 255.0
         If Transparency >= 0 And Transparency <= 255
            CocoaMessage(0, windowID, "setOpaque:", #NO)
            If CocoaMessage(0, windowID, "isOpaque") = #NO
               CocoaMessage(0, windowID, "setAlphaValue:@", @alpha)
               ProcedureReturn #True
            EndIf
         EndIf
         
      CompilerCase #PB_OS_Windows
         If Transparency >= 0 And Transparency <= 255
            SetWindowLongPtr_( windowID, #GWL_EXSTYLE, GetWindowLongPtr_( windowID, #GWL_EXSTYLE ) | #WS_EX_LAYERED )
            SetLayeredWindowAttributes_( windowID, 0, Transparency, #LWA_ALPHA )
            
;             ;\\
            SetWindowColor(Window,#Blue)
            SetWindowLong_(windowID, #GWL_EXSTYLE, #WS_EX_LAYERED | #WS_EX_TOPMOST)
            SetLayeredWindowAttributes_(windowID,#Blue,255,#LWA_COLORKEY|#LWA_ALPHA)

            ProcedureReturn #True
         EndIf
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

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 30
; FirstLine = 27
; Folding = --
; EnableXP