Global w_this, w_flag
DisableDebugger

Enumeration #PB_EventType_FirstCustomValue
  #PB_eventtype_Left2Click
  #PB_eventtype_Left3Click
EndEnumeration

Procedure SetGadGetWidgetState_(gadget, state)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
       ; ExplorerListGadget, ListIconGadget и ListViewGadget — все три построены на одном и том же классе Cocoa (NSTableView).
       ; CocoaMessage(0, GadgetID(gadget), "scrollColumnToVisible:", state)
        If state >= 0
          CocoaMessage(0, GadgetID(gadget), "scrollRowToVisible:", state )
        EndIf
        
      CompilerCase #PB_OS_Windows
				Select GadgetType(gadget)
					Case #PB_GadgetType_ListView
						SendMessage_(GadgetID(gadget), #LB_SETTOPINDEX, CountGadgetItems(gadget) - 1, #Null)
					Case #PB_GadgetType_ListIcon
						SendMessage_(GadgetID(gadget), #LVM_ENSUREVISIBLE, CountGadgetItems(gadget) - 1, #Null)
					Case #PB_GadgetType_Editor
						SendMessage_(GadgetID(gadget), #EM_SCROLLCARET, #SB_BOTTOM, 0)
				EndSelect
				
			CompilerCase #PB_OS_Linux
				Protected *Adjustment.GtkAdjustment
				*Adjustment = gtk_scrolled_window_get_vadjustment_(gtk_widget_get_parent_(GadgetID(gadget)))
				*Adjustment\value = *Adjustment\upper
				gtk_adjustment_value_changed_(*Adjustment)
		CompilerEndSelect 
		
    SetGadGetWidgetState(gadget, state)
  EndProcedure
  
  Procedure DoEvents( EventType )
  Protected result
  
  Select EventType
    Case #PB_EventType_LeftButtonDown : result = 1 : AddGadgetItem(w_flag, -1, " leftdown")
    Case #PB_EventType_LeftButtonUp   : result = 1 : AddGadgetItem(w_flag, -1, "  leftup")
    Case #PB_EventType_LeftClick      : result = 1 : AddGadgetItem(w_flag, -1, "   click") 
    Case #PB_eventtype_Left2Click     : result = 1 : AddGadgetItem(w_flag, -1, "     2_click") 
    Case #PB_eventtype_Left3Click     : result = 1 : AddGadgetItem(w_flag, -1, "       3_click") 
  EndSelect
  
  If result
    SetGadGetWidgetState(w_flag, CountGadgetItems(w_flag) - 1)
  EndIf
EndProcedure

Procedure MouseState( )
  Static press.b, ClickTime.q, ClickCount
  Protected DoubleClickTime, ElapsedMilliseconds.q, state.b
  
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
       ;EnableDebugger
       state = CocoaMessage(0, 0, "NSEvent pressedMouseButtons") ; class var pressedMouseButtons: Int { get }
       ;Debug CocoaMessage(0, 0, "buttonNumber") ; var buttonNumber: Int { get }
       ;Debug CocoaMessage(0, 0, "clickCount") ; var clickCount: Int { get }
  CompilerEndSelect
  
  If press <> state
    If state
      ElapsedMilliseconds.q = ElapsedMilliseconds( ) 
      
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        DoubleClickTime = 10
      CompilerElse
        DoubleClickTime = DoubleClickTime( )
      CompilerEndIf
      
      If DoubleClickTime > ( ElapsedMilliseconds - ClickTime )
        ClickCount + 1
      Else
        ClickCount = 1
      EndIf
      ClickTime = ElapsedMilliseconds
      
      If ClickCount = 1
        If state = 1
          Debug "LeftDown - "
          DoEvents( #PB_EventType_LeftButtonDown )
        ElseIf state = 2
          Debug "RightDown - "
        EndIf
      EndIf
      
    Else
      If ClickCount = 1
        If press = 1
          Debug "LeftUp - "
          DoEvents( #PB_EventType_LeftButtonUp )
        ElseIf press = 2
          Debug "RightUp - "
        EndIf
      EndIf
      
      ;\\ do 3click events
      If ClickCount = 3
        If press = 1
          Debug "   Left3Click - "
          DoEvents( #PB_eventtype_Left3Click )
        ElseIf press = 2
          Debug "   Right3Click - "
        EndIf
        
        ;\\ do 2click events
      ElseIf ClickCount = 2
        If press = 1
          Debug "  Left2Click - "
          DoEvents( #PB_eventtype_Left2Click )
        ElseIf press = 2
          Debug "  Right2Click - "
        EndIf
        
        
        ;\\ do 1click events
      Else
        ;         If Not PressedWidget( )\state\drag
        ;           If PressedWidget( ) = EnteredWidget( )
        If press = 1
          Debug " LeftClick - "
          DoEvents( #PB_EventType_LeftClick )
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


OpenWindow(0, 0, 0, 170, 300, "click-events", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
w_flag = ListViewGadget(-1,10, 10, 150, 200) 
w_this = ButtonGadget(-1,10, 220, 150, 70, "Click me", #PB_Button_MultiLine )


Repeat
  Event = WaitWindowEvent()
  MouseState( )
  
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 83
; FirstLine = 56
; Folding = ----
; EnableXP