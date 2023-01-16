; https://www.purebasic.fr/english/viewtopic.php?p=130779

; From glib-2.0/gobject/gsignal.h:239
; #define g_signal_connect(instance, detailed_signal, c_handler, Data) \
;     g_signal_connect_data ((instance), (detailed_signal), (c_handler), (Data), NULL, (GConnectFlags) 0)
; Procedure g_signal_connect(*object, name$, *func, *func_data)
;   g_signal_connect_data_(*object, @name$, *func, *func_data, 0, 0)
; EndProcedure

ImportC ""
  g_signal_connect(instance,signal.p-ascii,*fn,*vdata,destroy=0,flags=0) As "g_signal_connect_data"
  
EndImport

ProcedureCDLL BEventCallback(*Widget, *Event.GdkEventButton, user_data)
  Select user_data
    Case 3 : Debug "button enter event"
    Case 4 : Debug "button leave event"
  EndSelect
EndProcedure
ProcedureCDLL CEventCallback(*Widget, *Event.GdkEventMotion, user_data)
  ;ProcedureCDLL CEventCallback(*Widget, *Event.GdkEventAny, user_data)
  ;Debug Str(*Event\type) + " user_data: " + Str(user_data)
  Protected *eventtype.GdkEventButton = *Event
  
  Select *Event\type
    Case #GDK_DELETE
      Debug "Event: GDK_DELETE: 0 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_DESTROY
      Debug "Event: GDK_DESTROY: 1 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_EXPOSE ; огда перерисовываем наше окно
      Debug "Event: GDK_EXPOSE: 2 " + Str(*Event\type) + " user_data: " + Str(user_data)
      ; ;     Case #GDK_BUTTON_MOTION_MASK
      ; ;         Debug "Event: GDK_MOTION_NOTIFY: 3 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_MOTION_NOTIFY
     ; Debug "Event: GDK_MOTION_NOTIFY: 3 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_BUTTON_PRESS
      Debug "Event: GDK_BUTTON_PRESS: 4 " + Str(*eventtype\button) + " user_data: " + Str(user_data)
    Case #GDK_2BUTTON_PRESS
      Debug "Event: GDK_2BUTTON_PRESS: 5 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_3BUTTON_PRESS
      Debug "Event: GDK_3BUTTON_PRESS: 6 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_BUTTON_RELEASE
      Debug "Event: GDK_BUTTON_RELEASE: 7 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_KEY_PRESS
      Debug "Event: GDK_KEY_PRESS: 8 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_KEY_RELEASE
      Debug "Event: GDK_KEY_RELEASE: 9 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_ENTER_NOTIFY
      Debug "Event: GDK_ENTER_NOTIFY: 10 " + *Widget +" "+ Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_LEAVE_NOTIFY
      Debug "Event: GDK_LEAVE_NOTIFY: 11 " + *Widget +" "+ Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_FOCUS_CHANGE
      Debug "Event: GDK_FOCUS_CHANGE: 12 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_CONFIGURE
      Debug "Event: GDK_CONFIGURE: 13 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_MAP
      Debug "Event: GDK_MAP: 14 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_UNMAP
      Debug "Event: GDK_UNMAP: 15 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_PROPERTY_NOTIFY
      Debug "Event: GDK_PROPERTY_NOTIFY: 16 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_SELECTION_CLEAR
      Debug "Event: GDK_SELECTION_CLEAR: 17 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_SELECTION_REQUEST
      Debug "Event: GDK_SELECTION_REQUEST: 18 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_SELECTION_NOTIFY
      Debug "Event: GDK_SELECTION_NOTIFY: 19 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_PROXIMITY_IN
      Debug "Event: GDK_PROXIMITY_IN: 20 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_PROXIMITY_OUT
      Debug "Event: GDK_PROXIMITY_OUT: 21 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_DRAG_ENTER
      Debug "Event: GDK_DRAG_ENTER: 22 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_DRAG_LEAVE
      Debug "Event: GDK_DRAG_LEAVE: 23 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_DRAG_MOTION
      Debug "Event: GDK_DRAG_MOTION: 24 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_DRAG_STATUS
      Debug "Event: GDK_DRAG_STATUS: 25 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_DROP_START
      Debug "Event: GDK_DROP_START: 26 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_DROP_FINISHED
      Debug "Event: GDK_DROP_FINISHED: 27 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_CLIENT_EVENT
      Debug "Event: GDK_CLIENT_EVENT: 28 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_VISIBILITY_NOTIFY
      Debug "Event: GDK_VISIBILITY_NOTIFY: 29 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_NO_EXPOSE
      Debug "Event: GDK_NO_EXPOSE: 30 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_SCROLL
      Debug "Event: GDK_SCROLL: 31 " + Str(*Event\type) + " user_data: " + Str(user_data)
    Case #GDK_WINDOW_STATE
      Debug "Event: GDK_WINDOW_STATE: 32 " + Str(*Event\type) + " user_data: " + Str(user_data)
  EndSelect
EndProcedure


CompilerIf #PB_Compiler_IsMainFile 
  EnableExplicit
  UsePNGImageDecoder( )
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Global x,y,i
  
  Macro gtk_container( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_container_get_type_ ( ) ) : EndMacro
  Macro gtk_box( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_box_get_type_ ( ) ) : EndMacro
  
  Procedure SetCallBack( Gadget.i, *data = 0 )
    If IsGadget( Gadget )  ;gdk_event_handler_set()
                           ;\\
                           ; gtk_widget_add_events_(GadgetID(Gadget), #GDK_ALL_EVENTS_MASK)
                           ;   gtk_widget_add_events_(GadgetID(Gadget), #GDK_MOUSE)
                           ;   gtk_widget_add_events_(GadgetID(Gadget), #GDK_POINTER_MOTION_MASK)
                           ;  gtk_widget_add_events_(GadgetID(Gadget), #GDK_BUTTON_MOTION_MASK)
                           ;   gtk_widget_add_events_(GadgetID(Gadget), #GDK_ENTER_NOTIFY_MASK|
                           ;                                                  #GDK_LEAVE_NOTIFY_MASK|
                           ;                                                  #GDK_BUTTON_PRESS_MASK|
                           ;                                                  #GDK_BUTTON_RELEASE_MASK)
                            
                            If GadgetType( Gadget ) = #PB_GadgetType_Text
                              Protected window = UseGadgetList(0)
                              Protected *event_box.GtkWidget = gtk_event_box_new_ ();
                              gtk_container_add_ (gtk_container ( window), *event_box);
                              gtk_widget_show_ (*event_box)   
                              
                              Protected label = gtk_box(GadgetID(Gadget))
                              gtk_container_add_ (gtk_container ( *event_box ), label);
                              gtk_widget_show_ (label)                              ;
                              
                              gtk_widget_set_events_ (*event_box, #GDK_BUTTON_PRESS_MASK);
                             ;gtk_widget_add_events_(*event_box, #GDK_ALL_EVENTS_MASK)
                            g_signal_connect(*event_box, "event", @CEventCallback(), *data )  
                            
                            ;gtk_container_set_border_width_ (gtk_widget_get_ancestor_ ( UseGadgetList(0), gtk_container_get_type_ ( ) ), 30);
                            ;gtk_container_set_border_width_ (UseGadgetList(0), 30);
    
                            ;gtk_widget_realize_ (*event_box);
                            ;gdk_window_set_cursor_ (*event_box\window, gdk_cursor_new_ (#GDK_HAND1));
                            ;
                            
                            gtk_widget_show_ (window);
                            EndIf
                            
      ;\\ connect the signals...
      ;g_signal_connect(GadgetID(Gadget), "event", @CEventCallback(), *data )  
      
      ;   g_signal_connect(GadgetID(Gadget), "enter-notify-event", @BEventCallback(), 3)
      ;   g_signal_connect(GadgetID(Gadget), "leave-notify-event", @BEventCallback(), 4)
    EndIf
    
  EndProcedure
  
  
  If OpenWindow(#PB_Any, 0, 0, 995, 605, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ;SetWindowColor(ID::Window(UseGadgetList(0)), $83BFEC) ; bug
    
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
    ;     WebGadget(#PB_GadgetType_Web, 335, 505, 160,95,"https://www.purebasic.com" ) ; bug
    
    ButtonImageGadget(#PB_GadgetType_ButtonImage, 500, 5, 160,95, ImageID(0), 1)
    CalendarGadget(#PB_GadgetType_Calendar, 500, 105, 160,95 )
    DateGadget(#PB_GadgetType_Date, 500, 205, 160,95 )
    EditorGadget(#PB_GadgetType_Editor, 500, 305, 160,95 ) : AddGadgetItem(#PB_GadgetType_Editor, -1, "set"+#LF$+"editor"+#LF$+"_"+Str(#PB_GadgetType_Editor) +#LF$+"add"+#LF$+"multi"+#LF$+"line"+#LF$+"text")  
    ExplorerListGadget(#PB_GadgetType_ExplorerList, 500, 405, 160,95,"" )
    ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 505, 160,95,"" )
    
    ; ExplorerComboGadget(#PB_GadgetType_ExplorerCombo, 665, 5, 160,95,"" )
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
    
    ;\\
    For i = 1 To 3;#PB_GadgetType_Canvas
      SetCallBack( i, i )
    Next
    
    Define eventID,  WindowID , gadgetID, gadget
    Repeat
      eventID = WaitWindowEvent( )
      Select eventID 
        Case #PB_Event_Gadget
          If EventGadget( ) = #PB_GadgetType_ScrollBar
            SetGadgetState( #PB_GadgetType_ProgressBar, GetGadgetState( #PB_GadgetType_ScrollBar ) )
          EndIf
      EndSelect
    Until eventID = #PB_Event_CloseWindow
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Linux - x64)
; CursorPosition = 131
; FirstLine = 125
; Folding = ---
; EnableXP
; DPIAware