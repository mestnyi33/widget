
CompilerIf #PB_Compiler_IsMainFile
  Define Flags = #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered 
  OpenWindow(10, 0, 0, 630, 400, "demo set gadget new parent", Flags )
  ButtonGadget(-1,30,90,150,30,"move to Window")
  PanelGadget(1,10,150,200,160) :AddGadgetItem(1,-1,"Panel") :ButtonGadget(-1,30,90,150,30,"move to Panel") :AddGadgetItem(1,-1,"Second") :AddGadgetItem(1,-1,"Third") :CloseGadgetList()
  ContainerGadget(2,215,150,200,160,#PB_Container_Flat) :ButtonGadget(-1,30,90,150,30,"move to Container")  :CloseGadgetList() ; ContainerGadget
  ScrollAreaGadget(3,420,150,200,160,200,160,10,#PB_ScrollArea_Flat) :ButtonGadget(-1,30,90,150,30,"move to ScrollArea") :CloseGadgetList()
  
  ButtonGadget(4,50,320,100,30,"move to Desktop") 
  ButtonGadget(5,150,320,100,30,"move to Window") 
  ButtonGadget(6,250,320,100,30,"move to Panel") 
  ButtonGadget(7,350,320,100,30,"move to Container") 
  ButtonGadget(8,450,320,100,30,"move to Scroll") 
  
  ButtonGadget(9,100,350,400,30,"back") 
  
  Flags = #PB_Window_Invisible | #PB_Window_TitleBar
  OpenWindow(20, WindowX( 10 )+20+WindowWidth( 10 ), WindowY( 10 ), 200, 400, "old parent", Flags, WindowID(10))
  
  ButtonGadget(20,30,10,150,70,"ButtonGadget") 
  
  ComboBoxGadget( 21,30,90,150,30 ) 
  AddGadgetItem( 21, -1, "Selected gadget to move")
  AddGadgetItem( 21, -1, "ButtonGadget")
  AddGadgetItem( 21, -1, "StringGadget")
  AddGadgetItem( 21, -1, "TextGadget")
  AddGadgetItem( 21, -1, "CheckBoxGadget")
  AddGadgetItem( 21, -1, "OptionGadget")
  AddGadgetItem( 21, -1, "ListViewGadget")
  AddGadgetItem( 21, -1, "FrameGadget")
  AddGadgetItem( 21, -1, "ComboBoxGadget")
  AddGadgetItem( 21, -1, "ImageGadget")
  AddGadgetItem( 21, -1, "HyperLinkGadget")
  AddGadgetItem( 21, -1, "ContainerGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "ListIconGadget")
  AddGadgetItem( 21, -1, "IPAddressGadget")
  AddGadgetItem( 21, -1, "ProgressBarGadget")
  AddGadgetItem( 21, -1, "ScrollBarGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "ScrollAreaGadget"); Win = Ok
  AddGadgetItem( 21, -1, "TrackBarGadget")
  AddGadgetItem( 21, -1, "WebGadget")
  AddGadgetItem( 21, -1, "ButtonImageGadget")
  AddGadgetItem( 21, -1, "CalendarGadget")
  AddGadgetItem( 21, -1, "DateGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "EditorGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "ExplorerListGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "ExplorerTreeGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "ExplorerComboGadget"); Win = Ok
  AddGadgetItem( 21, -1, "SpinGadget")         ; Win = Ok
  AddGadgetItem( 21, -1, "TreeGadget")         ; Ok
  AddGadgetItem( 21, -1, "PanelGadget")        ; Ok
  AddGadgetItem( 21, -1, "SplitterGadget")     ; Win = Ok
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    AddGadgetItem( 21, -1, "MDIGadget") ; Ok
  CompilerEndIf
  AddGadgetItem( 21, -1, "ScintillaGadget") ; Ok
  AddGadgetItem( 21, -1, "ShortcutGadget")  ; Ok
  AddGadgetItem( 21, -1, "CanvasGadget")    ;Ok
  
  SetGadgetState( 21, #PB_GadgetType_Button) : PostEvent(#PB_Event_Gadget, 20, 21, #PB_EventType_Change)
  
  HideWindow(10,0)
  HideWindow(20,0)
  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux
      ImportC ""
        gtk_widget_get_window(*widget.GtkWidget)
        gdk_device_get_window_at_position ( *device.GdkDevice ,
                                            *win_x,
                                            *win_y)
      EndImport
  CompilerEndSelect
  
  Procedure EnterGadget( )
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        Define GadgetID,X1,Y1,mask
        Define WindowID, X,Y, *Widget.GtkWidget = gdk_window_at_pointer_(0,0);@x,@y)
        
        
        
        If *Widget 
          Debug gdk_window_get_window_type_ (*Widget)
          ;Debug gdk_device_get_window_at_position(gdk_display_get_default_(),0,0)
          ;Debug  g_list_nth_data_(gtk_container_get_children_(gtk_bin_get_child_(*Widget\name)), 0)
          ;Debug gtk_widget_get_ancestor_ (*Widget\parent, gtk_widget_get_type_ ())
          ; Debug PeekS( gtk_widget_get_name_( gtk_widget_get_ancestor_ (*Widget, gtk_widget_get_type_ ()) ), -1, #PB_UTF8 )
          ;            If *Widget\object And *Widget\name 
          ;              ;Debug gtk_widget_get_pointer_(*Widget\name,@X1,@Y1)
          ;              ;Debug gdk_window_get_pointer_(*Widget\object,@X1,@Y1,@mask)
          ; ;              Debug gdk_window_get_children_(*Widget\object);,@X1,@Y1,@mask)
          ;              Debug ID::Gadget(gtk_widget_get_ancestor_ (*Widget, gtk_widget_get_type_ ()))
          ;           ; Debug gtk_frame_get_label_widget_(*Widget\name )
          ; ;             If GtkGadgteID(*Widget\name)
          ; ;                 ProcedureReturn ID::Gadget( GtkGadgteID(*Widget\name) )
          ; ;               Else
          ; ;                 ; для ползунка 
          ; ; ;                 ThumbID (*Widget\name)
          ; ;               EndIf
          ;           EndIf
          ;         Else
          ;           Debug "За окном"
        EndIf
        
    CompilerEndSelect
  EndProcedure    
  
  Repeat
    Define Event=WaitWindowEvent()
    
    CompilerSelect #PB_Compiler_OS
        ;- Linux
      CompilerCase #PB_OS_Linux
        Define.i MouseEvent,X,Y, mask, *Window.GTKWindow = WindowID( EventWindow() ) 
        gdk_window_get_pointer_(gdk_get_default_root_window_(), @x, @y, @mask)
        ;gdk_window_get_pointer_(gtk_widget_get_window(gtk_widget_get_ancestor_ (WindowID( EventWindow() ) , gtk_widget_get_type_ ())), @x, @y, @mask)
        If      (mask & #GDK_BUTTON1_MASK) :MouseEvent = #PB_EventType_LeftButtonDown
        ElseIf  (mask & #GDK_BUTTON3_MASK) :MouseEvent = #PB_EventType_RightButtonDown
        ElseIf  (mask & #GDK_BUTTON2_MASK) :MouseEvent = #PB_EventType_MiddleButtonDown
        Else
          MouseEvent = #False
        EndIf
        
        If MouseEvent
          Debug EnterGadget( )
        EndIf
    CompilerEndSelect
    
    If Event=#PB_Event_Gadget 
      Select EventType()
        Case #PB_EventType_LeftClick, #PB_EventType_Change
          Select EventGadget()
            Case 21
              Select EventType()
                Case #PB_EventType_Change
                  ;Define ParentID = Get( GadgetID(20) )
                  
                  Select GetGadgetState( 21 )
                    Case 1 :ButtonGadget(20,30,20,150,30,"ButtonGadget") 
                    Case 2 :StringGadget(20,30,20,150,30,"StringGadget") 
                    Case 3 :TextGadget(20,30,20,150,30,"TextGadget", #PB_Text_Border) 
                    Case 4 :OptionGadget(20,30,20,150,30,"OptionGadget") 
                    Case 5 :CheckBoxGadget(20,30,20,150,30,"CheckBoxGadget") 
                    Case 6 :ListViewGadget(20,30,20,150,30) 
                    Case 7 :FrameGadget(20,30,20,150,30,"FrameGadget") 
                    Case 8 :ComboBoxGadget(20,30,20,150,30) :AddGadgetItem(20,-1,"ComboBoxGadget") :SetGadgetState(20,0)
                    Case 9 :ImageGadget(20,30,20,150,30,0,#PB_Image_Border) 
                    Case 10 :HyperLinkGadget(20,30,20,150,30,"HyperLinkGadget",0) 
                    Case 11 :ContainerGadget(20,30,20,150,30,#PB_Container_Flat)   :ButtonGadget(-1,0,0,80,20,"ButtonGadget") :CloseGadgetList() ; ContainerGadget
                    Case 12 :ListIconGadget(20,30,20,150,30,"",88) 
                    Case 13 :IPAddressGadget(20,30,20,150,30) 
                    Case 14 :ProgressBarGadget(20,30,20,150,30,0,5)
                    Case 15 :ScrollBarGadget(20,30,20,150,30,5,335,9)
                    Case 16 :ScrollAreaGadget(20,30,20,150,30,305,305,9,#PB_ScrollArea_Flat) :ButtonGadget(-1,0,0,80,20,"ButtonGadget") :CloseGadgetList()
                    Case 17 :TrackBarGadget(20,30,20,150,30,0,5)
                    Case 18 :WebGadget(20,30,20,150,30,"") ; bug 531 linux
                    Case 19 :ButtonImageGadget(20,30,20,150,30,0)
                    Case 20 :CalendarGadget(20,30,20,150,30) 
                    Case  21 :DateGadget(20,30,20,150,30)
                    Case 22 :EditorGadget(20,30,20,150,30)  : AddGadgetItem(20,-1,"EditorGadget")
                    Case 23 :ExplorerListGadget(20,30,20,150,30,"")
                    Case 24 :ExplorerTreeGadget(20,30,20,150,30,"")
                    Case 25 :ExplorerComboGadget(20,30,20,150,30,"")
                    Case 26 :SpinGadget(20,30,20,150,30,0,5,#PB_Spin_Numeric)
                    Case 27 :TreeGadget(20,30,20,150,30) : AddGadgetItem(20,-1,"TreeGadget") : AddGadgetItem(20,-1,"SubLavel",0,1)
                    Case 28 :PanelGadget(20,30,20,150,30) :AddGadgetItem(20,-1,"PanelGadget") :CloseGadgetList()
                    Case 29 
                      ButtonGadget(201,0,0,30,30,"1")
                      ButtonGadget(202,0,0,30,30,"2")
                      SplitterGadget(20,30,20,150,30,201,202)
                  EndSelect
                  
                  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                    Select GetGadgetState( 21 )
                      Case 30 :MDIGadget(20,30,10,150,70,0,0)
                      Case 31 :InitScintilla() :ScintillaGadget(20,30,10,150,70,0)
                      Case 32 :ShortcutGadget(20,30,10,150,70,0)
                      Case 33 :CanvasGadget(20,30,10,150,70) 
                    EndSelect
                  CompilerElse
                    Select GetGadgetState( 21 )
                      Case 30 :InitScintilla() :ScintillaGadget(20,30,10,150,70,0)
                      Case 31 :ShortcutGadget(20,30,10,150,70,0)
                      Case 32 :CanvasGadget(20,30,10,150,70) 
                    EndSelect
                  CompilerEndIf
                  
                  ResizeGadget(20,30,10,150,70)
                  
;                   Set(20, ParentID) ; GadgetID(3));
                  
              EndSelect
          EndSelect
          
;           If (EventGadget()<>20)
;             Define Parent=Parent(20)
;             If IsGadget(Parent)
;               Debug "get parent "+Parent
;             Else
;               Debug "get parent "+Window(20)
;             EndIf
;             
;             If IsGadget(201)
;               Debug Str(Parent(201))+" "+GadgetX(201)+" "+GadgetY(201)+" "+GadgetWidth(201)+" "+GadgetHeight(201)
;             EndIf
;           EndIf
      EndSelect
    EndIf  
  Until Event=#PB_Event_CloseWindow
  
CompilerEndIf


; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -v-
; EnableXP