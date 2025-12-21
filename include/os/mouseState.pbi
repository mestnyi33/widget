Global w_this, w_flag
;DisableDebugger

Enumeration #PB_EventType_FirstCustomValue
  #PB_eventtype_Left2Click
  #PB_eventtype_Left3Click
EndEnumeration

Procedure SetGadgetState_(gadget, state)
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
		
    SetGadgetState(gadget, state)
  EndProcedure
  
  Procedure DoEvents( EventType )
  
EndProcedure

Procedure MouseState( )
  Static press.b, ClickTime.q, ClickCount
  Protected DoubleClickTime, ElapsedMilliseconds.q, buttons.b
  
  CompilerSelect #PB_Compiler_OS 
    CompilerCase #PB_OS_Linux
      Protected desktop_x, desktop_y, handle, *GdkWindow.GdkWindowObject = gdk_window_at_pointer_( @desktop_x, @desktop_y )
      
      If *GdkWindow
        gdk_window_get_pointer_(*GdkWindow, @desktop_x, @desktop_y, @mask)
      EndIf
      
      If mask & 256; #GDK_BUTTON1_MASK
        buttons = 1
      EndIf
      If mask & 512 ; #GDK_BUTTON3_MASK
        buttons = 3
      EndIf
      If mask & 1024 ; #GDK_BUTTON2_MASK
        buttons = 2
      EndIf
      
    CompilerCase #PB_OS_Windows
      buttons = GetAsyncKeyState_(#VK_LBUTTON) >> 15 & 1 + 
              GetAsyncKeyState_(#VK_RBUTTON) >> 15 & 2 + 
              GetAsyncKeyState_(#VK_MBUTTON) >> 15 & 3 
    CompilerCase #PB_OS_MacOS
       ;EnableDebugger
       buttons = CocoaMessage(0, 0, "NSEvent pressedMouseButtons") ; class var pressedMouseButtons: Int { get }
       ;Debug CocoaMessage(0, 0, "buttonNumber") ; var buttonNumber: Int { get }
       ;Debug CocoaMessage(0, 0, "clickCount") ; var clickCount: Int { get }
  CompilerEndSelect
  
  If press <> buttons
    If buttons
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
        If buttons = 1
          Debug "LeftDown - "
          DoEvents( #PB_EventType_LeftButtonDown )
        ElseIf buttons = 2
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
    press = buttons
  EndIf
  
EndProcedure


OpenWindow(0, 0, 0, 995, 605, "click-events", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
ButtonGadget(#PB_GadgetType_Button, 5, 5, 160,95, "Multiline Button_"+Str(#PB_GadgetType_Button)+" (longer text gets automatically multiline)", #PB_Button_MultiLine ) 
      StringGadget(#PB_GadgetType_String, 5, 105, 160,95, "String_"+Str(#PB_GadgetType_String)+" set"+#LF$+"multi"+#LF$+"line"+#LF$+"text")                                 
      TextGadget(#PB_GadgetType_Text, 5, 205, 160,95, "Text_"+Str(#PB_GadgetType_Text)+#LF$+"set"+#LF$+"multi"+#LF$+"line"+#LF$+"text", #PB_Text_Border)        
      CheckBoxGadget(#PB_GadgetType_CheckBox, 5, 305, 160,95, "CheckBox_"+Str(#PB_GadgetType_CheckBox), #PB_CheckBox_ThreeState) : SetGadgetState(#PB_GadgetType_CheckBox, #PB_Checkbox_Inbetween)
      OptionGadget(#PB_GadgetType_Option, 5, 405, 160,95, "Option_"+Str(#PB_GadgetType_Option) ) : SetGadgetState(#PB_GadgetType_Option, 1)                                                       
      ListViewGadget(#PB_GadgetType_ListView, 5, 505, 160,95) : AddGadgetItem(#PB_GadgetType_ListView, -1, "ListView_"+Str(#PB_GadgetType_ListView)) : For i=1 To 5 : AddGadgetItem(#PB_GadgetType_ListView, i, "item_"+Str(i)) : Next
      FrameGadget(#PB_GadgetType_Frame, 170, 5, 160,95, "Frame_"+Str(#PB_GadgetType_Frame) )
      ComboBoxGadget(#PB_GadgetType_ComboBox, 170, 105, 160,95) : AddGadgetItem(#PB_GadgetType_ComboBox, -1, "ComboBox_"+Str(#PB_GadgetType_ComboBox)) : For i=1 To 5 : AddGadgetItem(#PB_GadgetType_ComboBox, i, "item_"+Str(i)) : Next : SetGadgetState(#PB_GadgetType_ComboBox, 0) 
      ImageGadget(#PB_GadgetType_Image, 170, 205, 160,95, 0, #PB_Image_Border ) 
      HyperLinkGadget(#PB_GadgetType_HyperLink, 170, 305, 160,95,"HyperLink_"+Str(#PB_GadgetType_HyperLink), $00FF00, #PB_HyperLink_Underline ) 
      ContainerGadget(#PB_GadgetType_Container, 170, 405, 160,95, #PB_Container_Flat )
      OptionGadget(101, 10, 10, 110,20, "Container_"+Str(#PB_GadgetType_Container) )  : SetGadgetState(101, 1)  
      OptionGadget(102, 10, 40, 110,20, "Option_widget");, #pb_flag_flat)  
      CloseGadgetList()
      ListIconGadget(#PB_GadgetType_ListIcon,170, 505, 160,95,"ListIcon_"+Str(#PB_GadgetType_ListIcon),120 )                           
      
      IPAddressGadget(#PB_GadgetType_IPAddress, 335, 5, 160,95 ) : SetGadgetState(#PB_GadgetType_IPAddress, MakeIPAddress(1, 2, 3, 4))    
      ProgressBarGadget(#PB_GadgetType_ProgressBar, 335, 105, 160,95,0,100) : SetGadgetState(#PB_GadgetType_ProgressBar, 50)
      ScrollBarGadget(#PB_GadgetType_ScrollBar, 335, 205, 160,95,0,100,0) : SetGadgetState(#PB_GadgetType_ScrollBar, 40)
      ScrollAreaGadget(#PB_GadgetType_ScrollArea, 335, 305, 160,95,180,90,1, #PB_ScrollArea_Flat ) :  ButtonGadget(201, 0, 0, 150,20, "ScrollArea_"+Str(#PB_GadgetType_ScrollArea) ) :  ButtonGadget(202, 180-150, 90-20, 150,20, "Button_"+Str(202) ) : CloseGadgetList()
      TrackBarGadget(#PB_GadgetType_TrackBar, 335, 405, 160,95,0,21, #PB_TrackBar_Ticks) : SetGadgetState(#PB_GadgetType_TrackBar, 11)
      WebGadget(#PB_GadgetType_Web, 335, 505, 160,95,"https://www.purebasic.com" )
      
      ButtonImageGadget(#PB_GadgetType_ButtonImage, 500, 5, 160,95, 0, 1)
      CalendarGadget(#PB_GadgetType_Calendar, 500, 105, 160,95 )
      DateGadget(#PB_GadgetType_Date, 500, 205, 160,95 )
      EditorGadget(#PB_GadgetType_Editor, 500, 305, 160,95 ) : AddGadgetItem(#PB_GadgetType_Editor, -1, "set"+#LF$+"editor"+#LF$+"_"+Str(#PB_GadgetType_Editor) +#LF$+"add"+#LF$+"multi"+#LF$+"line"+#LF$+"text")  
      ExplorerListGadget(#PB_GadgetType_ExplorerList, 500, 405, 160,95,"" )
      ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 505, 160,95,"" )
      
      ExplorerComboGadget(#PB_GadgetType_ExplorerCombo, 665, 5, 160,95,"" )
      SpinGadget(#PB_GadgetType_Spin, 665, 105, 160,95,20,100)
      
      TreeGadget(#PB_GadgetType_Tree, 665, 205, 160, 95 ) 
      AddGadgetItem(#PB_GadgetType_Tree, -1, "Tree_"+Str(#PB_GadgetType_Tree)) 
      For i=1 To 5 : AddGadgetItem(#PB_GadgetType_Tree, i, "item_"+Str(i)) : Next
      ButtonGadget(-1,665+10,205+5,50,35, "444444") 
      
      PanelGadget(#PB_GadgetType_Panel,665, 305, 160,95) 
      AddGadgetItem(#PB_GadgetType_Panel, -1, "Panel_"+Str(#PB_GadgetType_Panel)) 
      ButtonGadget(255, 0, 0, 90,20, "Button_255" ) 
      For i=1 To 5 : AddGadgetItem(#PB_GadgetType_Panel, i, "item_"+Str(i)) : ButtonGadget(-1,10,5,50,35, "butt_"+Str(i)) : Next 
      CloseGadgetList()
      
      OpenGadgetList(#PB_GadgetType_Panel, 1)
      ContainerGadget(-1,10,5,150,55, #PB_Container_Flat) 
      ContainerGadget(-1,10,5,150,55, #PB_Container_Flat) 
      ButtonGadget(-1,10,5,50,35, "butt_1") 
      CloseGadgetList()
      CloseGadgetList()
      CloseGadgetList()
      SetGadgetState( #PB_GadgetType_Panel, 4)
      
      SpinGadget(301, 0, 0, 100,20,0,10)
      SpinGadget(302, 0, 0, 100,20,0,10)                 
      SplitterGadget(#PB_GadgetType_Splitter, 665, 405, 160, 95, 301, 302)
      
      InitScintilla( )
      ScintillaGadget(#PB_GadgetType_Scintilla, 830, 5, 160,95,0 )
      ShortcutGadget(#PB_GadgetType_Shortcut, 830, 105, 160,95 ,-1)
      CanvasGadget(#PB_GadgetType_Canvas, 830, 205, 160,95 )
      CanvasGadget(#PB_GadgetType_Canvas+1, 830, 305, 160,95, #PB_Canvas_Container ):CloseGadgetList()
      
      If IsGadget(315)
         CloseGadgetList()
      EndIf
      ;Define container = ContainerGadget(-1,0,0,0,0, #PB_Container_Flat):CloseGadgetList()
      

Repeat
  Event = WaitWindowEvent()
  MouseState( )
  
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 38
; FirstLine = 3
; Folding = e5--
; EnableXP