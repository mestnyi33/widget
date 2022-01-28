EnableExplicit

CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  ImportC "-gtk"
    g_object_set_data_(*Widget.GtkWidget, strData.p-utf8, *userdata) As "g_object_set_data"
    g_object_get_data_(*Widget.GtkWidget, strData.p-utf8) As "g_object_get_data"
  EndImport
CompilerEndIf


Procedure SetWindowID(Window)  
  If IsWindow(Window)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux   
        ProcedureReturn  g_object_set_data_(WindowID(Window), "PB_WindowID", Window +1)
    CompilerEndSelect  
  EndIf
EndProcedure   

Procedure SetGadgetID(Gadget)  
  If IsGadget(Gadget)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux   
        ProcedureReturn  g_object_set_data_(GadgetID(Gadget), "PB_GadgetID", Gadget +1)
    CompilerEndSelect 
  EndIf
EndProcedure 

ProcedureDLL IDWindow(WindowID) ;Returns ID Window  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux   
      ProcedureReturn  g_object_get_data_(WindowID, "PB_WindowID") -1
  CompilerEndSelect  
EndProcedure   

ProcedureDLL IDGadget(GadgetID) ;Returns ID Gadget  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux   
      ProcedureReturn  g_object_get_data_(GadgetID, "PB_GadgetID") -1
  CompilerEndSelect  
EndProcedure 

ProcedureDLL IsWindowID(WindowID) ;Returns TRUE if is WindowID
  If IsWindow(IDWindow(WindowID)) 
    ProcedureReturn #True
  EndIf
EndProcedure  

ProcedureDLL IsGadgetID(GadgetID);Returns TRUE if is GadgetID
  If IsGadget(IDGadget(GadgetID))
    ProcedureReturn #True
  EndIf  
EndProcedure  


CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  ImportC ""
    gtk_widget_get_window(*widget.GtkWidget)
    gtk_notebook_get_tab_vborder(*Notebook.GtkNotebook)
    gtk_notebook_get_tab_hborder(*Notebook.GtkNotebook)
  EndImport
  
  Procedure GtkFixed( GadgetID )
    If GadgetID              
      Select PeekS(gtk_widget_get_name_(GadgetID),-1,#PB_UTF8)
        Case "GtkWindow",
             "GtkScrolledWindow"
          ProcedureReturn g_list_nth_data_(gtk_container_get_children_(gtk_bin_get_child_(GadgetID)), 0)
        Case "GtkNotebook"
          ProcedureReturn g_list_nth_data_(gtk_container_get_children_((GadgetID)),0)
        Case "GtkFixed"
          ProcedureReturn GadgetID
      EndSelect 
    EndIf
  EndProcedure
  
  Procedure GtkWidget( GadgetID )
    If GadgetID >0
      Static Widget
      While GadgetID 
        Widget = GadgetID
        GadgetID = gtk_widget_get_parent_( GadgetID )
        If PeekS( gtk_widget_get_name_( GadgetID ), -1, #PB_UTF8 ) = "GtkFixed"
          ProcedureReturn Widget
        EndIf
      Wend  
    EndIf
  EndProcedure
  
  Procedure GtkContainer( GadgetID )
    If GadgetID              
      ProcedureReturn gtk_widget_get_parent_(GtkWidget(GadgetID))
    EndIf
  EndProcedure
  
  
  
  Procedure __GadgetX( Gadget, Flags = #PB_Gadget_ContainerCoordinate )
    If IsGadget(Gadget) 
      CompilerIf #PB_Compiler_OS = #PB_OS_Linux 
        Protected X,Y,x1,y1, *Widget.GtkWidget = GadgetID(Gadget) 
        
        If Flags = #PB_Gadget_ContainerCoordinate
          X = *Widget\allocation\x
          Select GadgetType(Gadget)
            Case #PB_GadgetType_Editor,
                 #PB_GadgetType_ListIcon,
                 #PB_GadgetType_ListView
              If X :X-1 :EndIf
              
            Case #PB_GadgetType_Container  
              If X :X-2 :EndIf 
              
            Case #PB_GadgetType_ComboBox,
                 #PB_GadgetType_Panel
              *Widget = *Widget\parent 
              X = *Widget\allocation\x
              
            Case #PB_GadgetType_Image
              *Widget = *Widget\parent 
              *Widget = *Widget\parent 
              X = *Widget\allocation\x
          EndSelect
          If PeekS( gtk_widget_get_name_( gtk_widget_get_parent_(GtkContainer(GadgetID(Gadget)))), -1, #PB_UTF8 ) = "GtkNotebook"
            If PeekS( gtk_widget_get_name_( GtkWidget(GadgetID(Gadget))), -1, #PB_UTF8 ) <> "GtkNotebook"
              X-gtk_Notebook_get_tab_vborder(gtk_widget_get_parent_(GtkContainer(GadgetID(Gadget))))
            EndIf
          EndIf
         EndIf
        ProcedureReturn X
      CompilerElse
        ProcedureReturn GadgetX( Gadget, Flags )
      CompilerEndIf
    EndIf
  EndProcedure
  
  Procedure __GadgetY( Gadget, Flags = #PB_Gadget_ContainerCoordinate)
    If IsGadget(Gadget) 
      CompilerIf #PB_Compiler_OS = #PB_OS_Linux 
        Protected X,Y,x1,y1, *Widget.GtkWidget = GadgetID(Gadget) 
        
        If Flags = #PB_Gadget_ContainerCoordinate
          Y = *Widget\allocation\y
          Select GadgetType(Gadget)
            Case #PB_GadgetType_Editor,
                 #PB_GadgetType_ListIcon,
                 #PB_GadgetType_ListView
              If Y :Y-1 :EndIf
              
            Case #PB_GadgetType_Container  
              If Y :Y-2 :EndIf 
              
            Case #PB_GadgetType_ComboBox,
                 #PB_GadgetType_Panel
              *Widget = *Widget\parent 
              Y = *Widget\allocation\y
              
            Case #PB_GadgetType_Image
              *Widget = *Widget\parent 
              *Widget = *Widget\parent 
              Y = *Widget\allocation\y
          EndSelect
          If PeekS( gtk_widget_get_name_( gtk_widget_get_parent_(GtkContainer(GadgetID(Gadget)))), -1, #PB_UTF8 ) = "GtkNotebook"
            If PeekS( gtk_widget_get_name_( GtkWidget(GadgetID(Gadget))), -1, #PB_UTF8 ) <> "GtkNotebook"
              Y- GetGadgetAttribute(IDGadget(gtk_widget_get_parent_(GtkContainer(GadgetID(Gadget)))), #PB_Panel_TabHeight)
            EndIf
          EndIf
         ProcedureReturn Y
       EndIf
     CompilerElse
        ProcedureReturn GadgetY( Gadget, Flags )
      CompilerEndIf
    EndIf
  EndProcedure
CompilerEndIf

ProcedureDLL SetParent(ChildID,ParentID) ;Set Parent
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    If ParentID
      SetParent_(ChildID, ParentID)
      If GetWindowLongPtr_(ParentID, #GWL_STYLE) & #WS_EX_COMPOSITED = #False 
        SetWindowLongPtr_(ParentID,#GWL_STYLE, GetWindowLongPtr_(ParentID, #GWL_STYLE)|#WS_EX_COMPOSITED)
      EndIf
      If GetWindowLong_(ChildID, #GWL_STYLE) & #WS_CHILD = #False 
        SetWindowLongPtr_(ChildID,#GWL_STYLE, GetWindowLongPtr_(ChildID, #GWL_STYLE)|#WS_CHILD|#WS_POPUP)
      EndIf
    Else
      SetParent_( ChildID,GetDesktopWindow_() )
    EndIf
  CompilerElseIf  #PB_Compiler_OS = #PB_OS_Linux
    If ParentID
      Protected x,y, Gadget,GtkWidget,GtkFixed, *Widget.GtkWidget = ChildID
      Gadget = IDGadget(ChildID)  
      x = __GadgetX(Gadget) 
      y = __GadgetY(Gadget) 
      
      GtkWidget = GtkWidget( ChildID )
      GtkFixed = GtkFixed( ParentID )
      
      If ParentID
        gtk_widget_reparent_( GtkWidget, GtkFixed ) 
        If PeekS( gtk_widget_get_name_( ParentID ), -1, #PB_UTF8 ) = "GtkNotebook"
          x+gtk_notebook_get_tab_vborder(gtk_widget_get_parent_(GtkContainer(ChildID)))
          y+GetGadgetAttribute(IDGadget(gtk_widget_get_parent_(GtkContainer(ChildID))), #PB_Panel_TabHeight)
        EndIf
        gtk_widget_set_uposition_( GtkWidget, x,y )
      EndIf
    Else
      ;{       If ParentID =0;не получается переместить на рабочий стол
      ;         ;gtk_handle_box_set_handle_position_()
      ;         ParentID = gtk_handle_box_new_()
      ;         ;ParentID = gdk_window_lookup_(gdk_x11_get_default_root_xwindow_())
      ;         ParentID = g_list_nth_data_(gtk_container_get_children_(gtk_bin_get_child_( ParentID)), 0)
      ;         
      ;         ;ParentID = g_list_nth_data_(gtk_container_get_children_(gtk_bin_get_child_(gdk_window_lookup_(gdk_x11_get_default_root_xwindow_()) )), 0)
      ;         ;gtk_widget_set_parent_window_(ChildID,ParentID) 
      ;         
      ;         ;gtk_widget_set_parent_(ChildID,ParentID) 
      ;         ProcedureReturn 0
      ;}       EndIf  
    EndIf 
  CompilerEndIf
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
  Define flags = #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_ScreenCentered 
  OpenWindow(10, 0, 0, 600, 400, "Main Form", flags )
  PanelGadget(1,10,100,550,160) :AddGadgetItem(1,-1,"Panel") :CloseGadgetList()
  ;ContainerGadget(1,10,100,550,160,#PB_Container_Flat)  :CloseGadgetList()
  ;ScrollAreaGadget(1,10,100,550,160,5,5,9,#PB_ScrollArea_Flat) :CloseGadgetList()
  
  ButtonGadget(111,100,320,100,30,"move Desktop") 
  ButtonGadget(112,200,320,100,30,"move Window") 
  ButtonGadget(113,300,320,100,30,"move Gadget") 
  ButtonGadget(114,100,350,300,30,"back") 
  
  
  flags = #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget| #PB_Window_SizeGadget 
  OpenWindow(1, 10, 150, 330, 300, "Child Form", flags, WindowID(10))
  ;     ButtonGadget(20,30,20,250,30, "ButtonGadget1" )
  ;     StringGadget(20,30,20,250,30, "StringGadget2")
  ;     TextGadget(20,30,20,250,30, "TextGadget3" )
  ;     CheckBoxGadget(20,30,20,250,30, "CheckBoxGadget4" )
  ;     OptionGadget(20,30,20,250,30, "OptionGadget5" )
  ;     ListViewGadget(20,30,20,250,30 )
  ;     
  ;     FrameGadget(20,30,20,250,30, "FrameGadget7" )
  ;     ComboBoxGadget(20,30,20,250,30 )
  ;     ImageGadget(20,30,20,250,30,0,#PB_Image_Border )
  ;     HyperLinkGadget(20,30,20,250,30,"HyperLinkGadget10",0 )
  ;     ContainerGadget(20,30,20,250,30,#PB_Container_Single ) :CloseGadgetList()
  ;     ListIconGadget(20,30,20,250,30,"ListIconGadget12",60 )
  ;     
  ;     IPAddressGadget(20,30,20,250,30 )
  ;     ProgressBarGadget(20,30,20,250,30,0,0 )
  ;     ScrollBarGadget(20,30,20,250,30,0,0,0 )
  ;     ScrollAreaGadget(20,30,20,250,30,0,0,0,#PB_ScrollArea_Single ) :CloseGadgetList()
  ;     TrackBarGadget(20,30,20,250,30,0,0 )
  ;     ;WebGadget(20,30,20,250,30,"http://www.purebasic.fr/english/" )
  ;     
  ;     ButtonImageGadget(20,30,20,250,30,0 )
  ;     CalendarGadget(20,30,20,250,30 )
  ;     DateGadget(20,30,20,250,30 )
  EditorGadget(20,30,20,250,30 )
  ;      ExplorerListGadget(20,30,20,250,30,"" )
  ;     ExplorerTreeGadget(20,30,20,250,30,"" )
  ;     
  ;     ExplorerComboGadget(20,30,20,250,30,"" )
  ;     SpinGadget(20,30,20,250,30,0,0 )
  ;     TreeGadget(20,30,20,250,30 )
  ;     PanelGadget(20,30,20,250,30 ) :CloseGadgetList()
  ;     
  ;     ButtonGadget(20,30,20,250,30, "" )
  ;     StringGadget(20,30,20,250,30, "")
  ;     SplitterGadget(20,30,20,250,30,291,292 )
  ;     ;MDIGadget(20,30,20,250,30 )
  ;     
  ;     InitScintilla() :ScintillaGadget(20,30,20,250,30,0 )
  ;     ShortcutGadget(20,30,20,250,30 ,-1)
  ;     CanvasGadget(20,30,20,250,30 )
  
  
  ButtonGadget(21,30,60,250,30,"Child Form 21") 
  
  SetWindowID(1)
  SetWindowID(10)
  
  SetGadgetID(1)
  SetGadgetID(20)
  
  
  HideWindow(10,0)
  HideWindow(1,0)
  
  Repeat
    Define Event=WaitWindowEvent()
    If Event=#PB_Event_Gadget 
      If EventGadget()=111
        SetParent(GadgetID(20), 0)
      ElseIf EventGadget()=112
        SetParent(GadgetID(20), WindowID(10))
      ElseIf EventGadget()=113
        SetParent(GadgetID(20), GadgetID(1))
      ElseIf EventGadget()=114
        SetParent(GadgetID(20), WindowID(1))
        
      EndIf 
    EndIf  
  Until Event=#PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---------
; EnableXP