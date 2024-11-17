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
Define CaptionHeight = 30, x=100,y=100, width = 200, height = 100, v = 2, h = 4

Procedure WindowWidget( x, y, width, height, title.s, flag)
  Protected window = OpenWindow(#PB_Any, x+10, y+10, width, height, title, flag|#PB_Window_NoActivate, WindowID(0))
  SetWindowColor(window , $ff00ff )
  ProcedureReturn window
EndProcedure

If OpenWindow(0, x,y, (width+10)*h+10, (height+40)*v+10, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  
  y + CaptionHeight
  ;\\
  WindowWidget(x, y, width, height, "", #PB_Window_BorderLess)
  WindowWidget(x+(width+10)*1, y, width, height, "Tool", #PB_Window_Tool)
  WindowWidget(x+(width+10)*2, y, width, height, "SystemMenu", #PB_Window_SystemMenu)
  WindowWidget(x+(width+10)*3, y, width, height, "TitleBar", #PB_Window_TitleBar)
  
  y + CaptionHeight
  ;\\
  Define window = WindowWidget(x, y+(height+10)*1, width, height, "", #PB_Window_SystemMenu)
  
  WindowWidget(x+(width+10)*1, y+(height+10)*1, width, height, "SizeGadget", #PB_Window_SizeGadget)
  WindowWidget(x+(width+10)*2, y+(height+10)*1, width, height, "Size&SystemMenu", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
  WindowWidget(x+(width+10)*3, y+(height+10)*1, width, height, "Size&TitleBar", #PB_Window_TitleBar|#PB_Window_SizeGadget)

  
  
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
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP