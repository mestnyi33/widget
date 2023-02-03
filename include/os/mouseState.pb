Procedure MouseState( )
  Static press.b, ClickTime.q, ClickCount
  Protected DoubleClickTime, state.b
  
  CompilerSelect #PB_Compiler_OS 
    CompilerCase #PB_OS_Linux
      Protected desktop_x, desktop_y, handle, *GdkWindow.GdkWindowObject = gdk_window_at_pointer_( @desktop_x, @desktop_y )
      
      If *GdkWindow
        gdk_window_get_pointer_(*GdkWindow, @desktop_x, @desktop_y, @mask)
      EndIf
      
      If mask & 256; #GDK_BUTTON1_MASK
        state = 1
      EndIf
      If mask & 512 ; #GDK_BUTTON3_MASK
        state = 3
      EndIf
      If mask & 1024 ; #GDK_BUTTON2_MASK
        state = 2
      EndIf
      
    CompilerCase #PB_OS_Windows
      state = GetAsyncKeyState_(#VK_LBUTTON) >> 15 & 1 + 
              GetAsyncKeyState_(#VK_RBUTTON) >> 15 & 2 + 
              GetAsyncKeyState_(#VK_MBUTTON) >> 15 & 3 
    CompilerCase #PB_OS_MacOS
      state = CocoaMessage(0, 0, "NSEvent pressedMouseButtons")
  CompilerEndSelect
  
  If press <> state
    If state
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        DoubleClickTime = 10
      CompilerElse
        DoubleClickTime = DoubleClickTime( )
      CompilerEndIf
      
      If ClickTime And
         DoubleClickTime > ( ElapsedMilliseconds( ) - ClickTime )
        ClickCount + 1
      Else
        ClickCount = 1
      EndIf
      ClickTime = ElapsedMilliseconds( )
      
      If ClickCount = 1
        If state = 1
          Debug "LeftDown - "
        ElseIf state = 2
          Debug "RightDown - "
        EndIf
      EndIf
      
    Else
      If ClickCount = 1
        If press = 1
          Debug "LeftUp - "
        ElseIf press = 2
          Debug "RightUp - "
        EndIf
      EndIf
      
      ;\\ do 3click events
      If ClickCount = 3
        If press = 1
          Debug "   Left3Click - "
        ElseIf press = 2
          Debug "   Right3Click - "
        EndIf
        
        ;\\ do 2click events
      ElseIf ClickCount = 2
        If press = 1
          Debug "  Left2Click - "
        ElseIf press = 2
          Debug "  Right2Click - "
        EndIf
        
        
        ;\\ do 1click events
      Else
        ;         If Not PressedWidget( )\state\drag
        ;           If PressedWidget( ) = EnteredWidget( )
        If press = 1
          Debug " LeftClick - "
        ElseIf press = 2
          Debug " RightClick - "
        EndIf
        
        ;           EndIf
        ;         EndIf
      EndIf
      
    EndIf
    press = state
  EndIf
  
EndProcedure


OpenWindow(0, 0, 0, 220, 160, "Press ESC to end", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)  


Repeat
  Event = WaitWindowEvent()
  MouseState( )
  
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (Linux - x64)
; CursorPosition = 92
; FirstLine = 82
; Folding = ---
; EnableXP