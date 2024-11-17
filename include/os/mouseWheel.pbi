    Declare update_vertical_scroll_bar_dictionary()
   
   
    Enumeration
    #WINDOW_MAIN
    #PANEL_BOX_DICTIONARY
    #PANEL_BOX_DICTIONARY_VERTICAL_BAR
    EndEnumeration
    
    
Enumeration 1000
  #PB_EventType_MouseWheel_Down = #PB_EventType_FirstCustomValue
  #PB_EventType_MouseWheel_Up
EndEnumeration    
    
    
    #ListIcon=#PANEL_BOX_DICTIONARY
    #Window=#WINDOW_MAIN
   
    Global number_of_words=100
    Global Dim words$(number_of_words-1)
    Global number_of_lines=13
    For f=0 To number_of_words-1
      words$(f)="Word #"+Str(f)
    Next f
    
    
CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Linux ; --------------------------------------------------
    ProcedureC MouseWheelCallback(*Event.GdkEventScroll, *UserData)
      Protected *ListView.GtkWidget = GadgetID(#ListIcon)
     
      If *ListView\window = gdk_window_get_parent_(*Event\window)
        If *Event\type = #GDK_SCROLL
          Select *Event\direction
            Case #GDK_SCROLL_UP
              PostEvent(#PB_Event_Gadget, #Window, #ListIcon,
                #PB_EventType_MouseWheel_Up)
            Case #GDK_SCROLL_DOWN
              PostEvent(#PB_Event_Gadget, #Window, #ListIcon,
                #PB_EventType_MouseWheel_Down)
          EndSelect
        EndIf
      EndIf
     
      gtk_main_do_event_(*Event)
    EndProcedure
  CompilerCase #PB_OS_MacOS ; --------------------------------------------------
    #kCGEventTapOptionListenOnly = 1
    #kCGHeadInsertEventTap = 0
    #NX_SCROLLWHEELMOVED = 22
    #NX_SCROLLWHEELMOVEDMASK = 1 << #NX_SCROLLWHEELMOVED

    ImportC ""
      CGEventTapCreateForPSN(*ProcessSerialNumber, CGEventTapPlacement.I, CGEventTapOptions.I, CGEventMask.Q, CGEventTapCallback.I, *UserData)
      GetCurrentProcess(*ProcessSerialNumber)
    EndImport

    ProcedureC MouseWheelCallback(CGEventTapProxy.I, CGEventType.I, CGEvent.I,  *UserData)
      Protected DeltaY.CGFloat
      Protected NSEvent.I
      Protected Point.NSPoint
     
      NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", CGEvent)
      CocoaMessage(@Point, NSEvent, "locationInWindow")
     
      If CocoaMessage(0, CocoaMessage(0, WindowID(#Window), "contentView"), "hitTest:@", @Point) = GadgetID(#ListIcon)
        CocoaMessage(@DeltaY, NSEvent, "deltaY")
       
        If DeltaY < 0.0
          PostEvent(#PB_Event_Gadget, #Window, #ListIcon,
            #PB_EventType_MouseWheel_Down)
        Else
          PostEvent(#PB_Event_Gadget, #Window, #ListIcon,
            #PB_EventType_MouseWheel_Up)
        EndIf
      EndIf
    EndProcedure
  CompilerCase #PB_OS_Windows ; ------------------------------------------------
    Define DefaultListIconCallback.I

    Procedure CustomListIconCallback(WindowHandle.I, Msg.I, WParam.I, LParam.I)
      Shared DefaultListIconCallback.I

      If Msg = #WM_MOUSEWHEEL
        If (WParam >> 16) & $8000
          PostEvent(#PB_Event_Gadget, #Window, #ListIcon,
            #PB_EventType_MouseWheel_Down)
        Else         
          PostEvent(#PB_Event_Gadget, #Window, #ListIcon,
            #PB_EventType_MouseWheel_Up)
        EndIf
      EndIf

      ProcedureReturn CallWindowProc_(DefaultListIconCallback, WindowHandle, Msg, WParam, LParam)
   EndProcedure
CompilerEndSelect

Define i.I    



    ; Open a Window
    If OpenWindow(#WINDOW_MAIN,0,0,1024,600,"Proofing Tool GUI",#PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)=#False : MessageRequester("Error", "Can't open a window.", 0) : EndIf
   
   
    ; Create the objects in the "Dictionary" tab
    ListIconGadget(#PANEL_BOX_DICTIONARY,4,20-5,15+10+40+40+30+15+600-20+10+5+4+4+4-300-10-5-5-2,300-30+5+40,"#",30+40+10+5,#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection|#PB_ListIcon_CheckBoxes)
    AddGadgetColumn(#PANEL_BOX_DICTIONARY,1,"Words",100+10+20+20+10)
    AddGadgetColumn(#PANEL_BOX_DICTIONARY,2,"Tags",150+5+15+300)
    ScrollBarGadget(#PANEL_BOX_DICTIONARY_VERTICAL_BAR,GadgetX(#PANEL_BOX_DICTIONARY)+GadgetWidth(#PANEL_BOX_DICTIONARY),20-5,25-5-2,300-30+5+40,0,0,number_of_lines,#PB_ScrollBar_Vertical)
   
   
    ; New code to handle the vertical scroll bar
    SetGadgetAttribute(#PANEL_BOX_DICTIONARY_VERTICAL_BAR,#PB_ScrollBar_Maximum,number_of_words-1)
    SetGadgetState(#PANEL_BOX_DICTIONARY_VERTICAL_BAR,0)
    update_vertical_scroll_bar_dictionary()   
   
    
CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Linux
    gdk_event_handler_set_(@MouseWheelCallback(), 0, 0)
  CompilerCase #PB_OS_MacOS
    Define MachPort.I
    Define ProcessSerialNumber.Q

    GetCurrentProcess(@ProcessSerialNumber)
    MachPort = CGEventTapCreateForPSN(@ProcessSerialNumber,
      #kCGHeadInsertEventTap, #kCGEventTapOptionListenOnly,
      #NX_SCROLLWHEELMOVEDMASK, @MouseWheelCallback(), 0)

    If MachPort
      CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"),
      "addPort:", MachPort, "forMode:$", @"kCFRunLoopCommonModes")
    EndIf
  CompilerCase #PB_OS_Windows
    DefaultListIconCallback = GetWindowLongPtr_(GadgetID(#ListIcon), #GWL_WNDPROC)
    SetWindowLongPtr_(GadgetID(#ListIcon), #GWL_WNDPROC, @CustomListIconCallback())
CompilerEndSelect

SetActiveGadget(#ListIcon)    

  BindGadgetEvent(#PANEL_BOX_DICTIONARY_VERTICAL_BAR, @update_vertical_scroll_bar_dictionary()) ; Dictionary

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux
          gdk_event_handler_set_(0, 0, 0)
        CompilerCase #PB_OS_MacOS
          CFRelease_(MachPort)
      CompilerEndSelect
      Break
    Case #PB_Event_Gadget
      If EventGadget() = #ListIcon
        Select EventType()
          Case #PB_EventType_MouseWheel_Down
            Debug "Mouse wheel moved down"
            SetGadgetState(#PANEL_BOX_DICTIONARY_VERTICAL_BAR,GetGadgetState(#PANEL_BOX_DICTIONARY_VERTICAL_BAR)+10)
            update_vertical_scroll_bar_dictionary() 
          Case #PB_EventType_MouseWheel_Up
            Debug "Mouse wheel moved up"
            SetGadgetState(#PANEL_BOX_DICTIONARY_VERTICAL_BAR,GetGadgetState(#PANEL_BOX_DICTIONARY_VERTICAL_BAR)-10)
            update_vertical_scroll_bar_dictionary() 
        EndSelect
      EndIf
  EndSelect
ForEver
End


   
   
  Procedure update_vertical_scroll_bar_dictionary() 
    ClearGadgetItems(#PANEL_BOX_DICTIONARY)
    If number_of_words=0
      SetGadgetAttribute(#PANEL_BOX_DICTIONARY_VERTICAL_BAR,#PB_ScrollBar_Minimum,0)
      SetGadgetAttribute(#PANEL_BOX_DICTIONARY_VERTICAL_BAR,#PB_ScrollBar_Maximum,0)
      ProcedureReturn
    EndIf
    beginloop = GetGadgetState(#PANEL_BOX_DICTIONARY_VERTICAL_BAR)
;     endloop = beginloop + 10
    endloop=beginloop+number_of_lines-1
    If endloop>ArraySize(words$())
      endloop=ArraySize(words$())
    EndIf
    For f=beginloop To endloop     
      AddGadgetItem(#PANEL_BOX_DICTIONARY,-1,Str(f+1)+Chr(10)+words$(f))     
      SetGadGetWidgetItemColor(#PANEL_BOX_DICTIONARY,#PB_All,#PB_Gadget_FrontColor,$999999,0)
;       If words_selected(f)=#True : SetGadgetItemState(#PANEL_BOX_DICTIONARY,f-beginloop,#PB_ListIcon_Checked) : EndIf
    Next f
   
    t=beginloop
    t1=selected_dictionary_word-t
;     If t1>=0 And t1<=10 : SetGadgetState(#PANEL_BOX_DICTIONARY,t1) : EndIf           
    If t1>=0 And t1<=number_of_lines-1 : SetGadgetState(#PANEL_BOX_DICTIONARY,t1) : EndIf    
    
  
  EndProcedure  


; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ----
; EnableXP