;
; ------------------------------------------------------------
;
;   PureBasic - Window example file
;
;    (c) Fantaisie Software
;
; ------------------------------------------------------------
;

;
; Open a window, and do some stuff with it...
;
Define CaptionHeight = 30, X=100,Y=100, Width = 200, Height = 100, v = 2, h = 4

Procedure Window( X, Y, Width, Height, title.s, flag)
   Static window : window + 1
   OpenWindow(window, X+10, Y+10, Width, Height, title, flag|#PB_Window_NoActivate, WindowID(0))
   SetWindowColor(window , $ff00ff )
   ProcedureReturn window
EndProcedure

If OpenWindow(0, X,Y, (Width+10)*h+10, (Height+40)*v+10, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
  Y + CaptionHeight
  ;\\
  Window(X, Y, Width, Height, "", #PB_Window_BorderLess)
  Window(X+(Width+10)*1, Y, Width, Height, "Tool", #PB_Window_Tool)
  Window(X+(Width+10)*2, Y, Width, Height, "TitleBar", #PB_Window_TitleBar)
  Window(X+(Width+10)*3, Y, Width, Height, "SystemMenu", #PB_Window_SystemMenu)
  
  Y + CaptionHeight
  ;\\
  Define window = Window(X, Y+(Height+10)*1, Width, Height, "", #PB_Window_SystemMenu)
  Define w = WindowID(window)
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
     If CocoaMessage(0, w, "hasShadow") = 0
        CocoaMessage(0, w, "setHasShadow:", 1)
     EndIf
     ; https://www.purebasic.fr/english/viewtopic.php?p=393084#p393084
     CocoaMessage(0, w, "setStyleMask:", CocoaMessage(0, w, "styleMask")&~#NSTitledWindowMask)
  CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
     If GetClassLongPtr_( w, #GCL_STYLE ) & #CS_DROPSHADOW = 0
        SetClassLongPtr_( w, #GCL_STYLE, #CS_DROPSHADOW )
     EndIf
     SetWindowLongPtr_(w,#GWL_STYLE,GetWindowLongPtr_(w,#GWL_STYLE)&~#WS_BORDER) 
     ;SetWindowLongPtr_(w,#GWL_STYLE,GetWindowLongPtr_(w,#GWL_STYLE)&~#WS_CAPTION) 
  CompilerElse
     ;  
  CompilerEndIf
               
  Window(X+(Width+10)*1, Y+(Height+10)*1, Width, Height, "SizeGadget", #PB_Window_SizeGadget)
  Window(X+(Width+10)*2, Y+(Height+10)*1, Width, Height, "Size&TitleBar", #PB_Window_TitleBar|#PB_Window_SizeGadget)
  Window(X+(Width+10)*3, Y+(Height+10)*1, Width, Height, "Size&SystemMenu", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  
  
  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_MacOS
      ;             If CocoaMessage(0, WindowID(window), "hasShadow") = 0
      ;               CocoaMessage(0, WindowID(window), "setHasShadow:", 1)
      ;             EndIf
      ; CocoaMessage(0, WindowID(window), "styleMask") ; get
      CocoaMessage(0, WindowID(window), "setStyleMask:", #NSMiniaturizableWindowMask)
      ResizeWindow(window, #PB_Ignore, WindowY(window)-CaptionHeight, #PB_Ignore, #PB_Ignore)
      
  ;\\    
;       alpha.CGFloat = 0.8
;       ;CocoaMessage(0, CocoaMessage(0, WindowID(window), "animator"), "setAlphaValue:@", @alpha)
;       CocoaMessage(0, WindowID(window), "setAlphaValue:@", @alpha)
      
      ;\\
;       CocoaMessage(0, CocoaMessage(0, WindowID(window), "standardWindowButton:", 1), "setHidden:", #YES) ;Minimize
;       CocoaMessage(0, CocoaMessage(0, WindowID(window), "standardWindowButton:", 2), "setHidden:", #YES) ;Maximize
      
      
  CompilerEndSelect
  
;   NewCollectionBehaviour = CocoaMessage(0, WindowID(0), "collectionBehavior") | $80
; CocoaMessage(0, WindowID(0), "setCollectionBehavior:", NewCollectionBehaviour)
  
  Repeat
    Event = WaitWindowEvent()

    If Event = #PB_Event_CloseWindow  ; If the user has pressed on the close button
      Quit = 1
    EndIf

  Until Quit = 1
  
EndIf

End   ; All the opened windows are closed automatically by PureBasic
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 46
; FirstLine = 21
; Folding = --
; EnableXP