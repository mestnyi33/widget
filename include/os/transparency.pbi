CompilerIf #PB_Compiler_OS=#PB_OS_Linux
  ImportC "-gtk"
    gtk_window_set_opacity(*Window.i, Opacity.d);
    gtk_widget_is_composited(*Widget)
  EndImport
  
  Procedure.i SetWindowTransparency(Window, Transparency=255)
    Protected *windowID=WindowID(Window), alpha.d=Transparency/255.0
    If Transparency>=0 And Transparency<=255
      If gtk_widget_is_composited(*windowID)
        gtk_window_set_opacity(*windowID, alpha.d)
        ProcedureReturn #True
      EndIf
    EndIf
  EndProcedure
  
CompilerElseIf #PB_Compiler_OS=#PB_OS_MacOS
  Procedure.i SetWindowTransparency(Window, Transparency=255)
    Protected *windowID=WindowID(Window), alpha.CGFloat=Transparency/255.0
    If Transparency>=0 And Transparency<=255
      CocoaMessage(0, *windowID, "setOpaque:", #NO)
      If CocoaMessage(0, *windowID, "isOpaque")=#NO
        CocoaMessage(0, *windowID, "setAlphaValue:@", @alpha)
        ProcedureReturn #True
      EndIf
    EndIf
  EndProcedure
  
CompilerElseIf #PB_Compiler_OS=#PB_OS_Windows
  Procedure.i SetWindowTransparency(Window, Transparency=255)
    Protected *windowID=WindowID(Window), exStyle=GetWindowLongPtr_(*windowID, #GWL_EXSTYLE)
    If Transparency>=0 And Transparency<=255
      SetWindowLongPtr_(*windowID, #GWL_EXSTYLE, exStyle | #WS_EX_LAYERED)
      SetLayeredWindowAttributes_(*windowID, 0, Transparency, #LWA_ALPHA)
      
      ProcedureReturn #True
    EndIf
  EndProcedure
CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = --
; EnableXP