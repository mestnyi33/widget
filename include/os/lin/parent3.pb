; #include <gtk/gtk.h>
; #include <glib.h>
; 
; void
; button1_clicked_cb (GtkWidget * widget, GtkWindow * window)
; {
;     GdkWindow *root;
;     gint width, height, rwidth, rheight;
; 
;     gtk_window_get_size (window, &width, &height);
;     root = gtk_widget_get_root_window (GTK_WIDGET (window));
;     gdk_window_get_geometry (root, NULL, NULL, &rwidth,
;                              &rheight);
; 
;     gtk_window_move (window, (rwidth - width) / 2,
;                      (rheight - height) / 2);
; }
; 
; void
; button2_clicked_cb (GtkWidget * widget, GtkWindow * window)
; {
;     gtk_widget_hide (GTK_WIDGET (window));
;     gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
;     gtk_widget_show_all (GTK_WIDGET (window));
; }
; 
; int
; main (int argc, char *argv[])
; {
;     GtkWidget *window;
;     GtkWidget *box;
;     GtkWidget *button1;
;     GtkWidget *button2;
; 
;     gtk_init (&argc, &argv);
; 
;     window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
; 
;     button1 = gtk_button_new_with_label ("approach 1");
;     button2 = gtk_button_new_with_label ("approach 2");
; 
;     box = gtk_box_new (GTK_ORIENTATION_VERTICAL, 10);
;     gtk_box_pack_start (GTK_BOX (box), button1, TRUE, TRUE,
;                         10);
;     gtk_box_pack_start (GTK_BOX (box), button2, TRUE, TRUE,
;                         10);
; 
;     gtk_container_add (GTK_CONTAINER (window), box);
;     gtk_widget_show_all (window);
; 
;     g_signal_connect (window, "destroy",
;                       G_CALLBACK (gtk_main_quit), NULL);
;     g_signal_connect (button1, "clicked",
;                       G_CALLBACK (button1_clicked_cb),
;                       window);
;     g_signal_connect (button2, "clicked",
;                       G_CALLBACK (button2_clicked_cb),
;                       window);
; 
;     gtk_main ();
; 
;     Return 0;
; }


EnableExplicit

ImportC ""
  PB_Gadget_Objects.i
  PB_Window_Objects.i
  
  PB_Object_EnumerateStart( PB_Objects )
  PB_Object_EnumerateNext( PB_Objects, *ID.Integer )
  PB_Object_EnumerateAbort( PB_Objects )
EndImport

;
Procedure IDGadget( GadgetID )
  Protected Gadget = -1
  PB_Object_EnumerateStart( PB_Gadget_Objects )
  
  If PB_Gadget_Objects
    While PB_Object_EnumerateNext( PB_Gadget_Objects, @Gadget )
      If GadgetID = GadgetID( Gadget )
        Break
      Else
        Gadget = -1
      EndIf
    Wend
    
    PB_Object_EnumerateAbort( PB_Gadget_Objects )
  EndIf  
  
  ProcedureReturn Gadget
EndProcedure

;
Procedure IDWindow( WindowID )
  Protected Window = -1
  PB_Object_EnumerateStart( PB_Window_Objects )
  
  If PB_Window_Objects
    While PB_Object_EnumerateNext( PB_Window_Objects, @Window )
      If WindowID = WindowID( Window )
        Break
      Else
        Window = -1
      EndIf
    Wend
    
    PB_Object_EnumerateAbort( PB_Window_Objects )
  EndIf  
  
  ProcedureReturn Window
EndProcedure


Procedure GadgetWindowID( Gadget )
  Protected GadgetWindowID, GadgetID
  
  If IsGadget( Gadget )
    GadgetID = GadgetID( Gadget )
    
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_MacOS
        CompilerError #PB_Compiler_Procedure
      CompilerCase #PB_OS_Linux 
        GadgetWindowID = gtk_widget_get_toplevel_ ( GadgetID )
      CompilerCase #PB_OS_Windows
        While GadgetID 
          GadgetWindowID = GadgetID :GadgetID = GetParent_( GadgetID )
        Wend 
    CompilerEndSelect
    
    ProcedureReturn GadgetWindowID
  EndIf
EndProcedure

Procedure GadgetParentID( Gadget, ParentID = #PB_Ignore ) ; 
  Protected GadgetID
  
  If IsGadget( Gadget )
    GadgetID = ParentID
    ParentID = GadgetID( Gadget )
    
    While ParentID
      CompilerSelect #PB_Compiler_OS 
        CompilerCase #PB_OS_MacOS
          CompilerError #PB_Compiler_Procedure
        CompilerCase #PB_OS_Linux 
          ParentID = gtk_widget_get_parent_( ParentID )
        CompilerCase #PB_OS_Windows
          ParentID = GetParent_( ParentID )
      CompilerEndSelect
      
      If GadgetID = #PB_Ignore
        If IsWindow( IDWindow( ParentID ) )
          ProcedureReturn ParentID 
        ElseIf IsGadget( IDGadget( ParentID ))
          ProcedureReturn ParentID 
        EndIf
      Else
        If GadgetID = ParentID
          ProcedureReturn GadgetID
        EndIf
      EndIf
    Wend  
  EndIf
EndProcedure

; Возвращает тип родителя (Window; Container; ScrollArea; Panel)
Procedure ParentType( Gadget ) ; Returns the type of the specified parent
  Protected ParentID = -1
  If IsGadget( Gadget )
    ParentID = GadgetParentID( Gadget )
    
    #PB_ParentType_Window = #PB_Any
    #PB_ParentType_Panel = #PB_GadgetType_Panel
    #PB_ParentType_Container = #PB_GadgetType_Container
    #PB_ParentType_ScrollArea = #PB_GadgetType_ScrollArea
    
    If IsGadget( IDGadget( ParentID ) )
      ProcedureReturn GadgetType( IDGadget( ParentID ) )
    ElseIf IsWindow( IDWindow( ParentID ) )
      ProcedureReturn #PB_ParentType_Window
    EndIf
  EndIf  
EndProcedure


Procedure GtkFixed( GadgetID )
  If GadgetID              
    Select PeekS(gtk_widget_get_name_(GadgetID),-1,#PB_UTF8)
      Case "GtkWindow",
           "GtkScrolledWindow"
        ProcedureReturn g_list_nth_data_(gtk_container_get_children_(gtk_bin_get_child_(GadgetID)), 0)
      Case "GtkNotebook"
        ProcedureReturn gtk_notebook_get_nth_page_(GadgetID, gtk_notebook_get_current_page_( GadgetID )) 
        ;ProcedureReturn g_list_nth_data_(gtk_container_get_children_((GadgetID)),0)
      Case "GtkFixed"
        ProcedureReturn GadgetID
    EndSelect 
  EndIf
EndProcedure

Procedure GtkWidget( GadgetID )
  If GadgetID 
    Static Widget
    Protected GadgetWindowID = gtk_widget_get_toplevel_ ( GadgetID )
    
    While GadgetID 
      Widget = GadgetID
      GadgetID = gtk_widget_get_parent_( GadgetID )
      
      If GadgetWindowID = GadgetID
        Break
      EndIf
      
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

Procedure GtkChildren( GadgetID, Children = 0 )
  If GadgetID              
    ProcedureReturn g_list_nth_data_(gtk_container_get_children_((GadgetID)), Children)
  EndIf
EndProcedure


ImportC ""
  gtk_widget_get_window(*widget.GtkWidget)
  gtk_notebook_get_tab_vborder(*Notebook.GtkNotebook)
  gtk_notebook_get_tab_hborder(*Notebook.GtkNotebook)
EndImport

; Возвращает идентификатор родителя
Procedure GadgetParent( Gadget, ParentID = #PB_Ignore ) ; Returns gadget parent id
  If IsGadget( Gadget )
    If ParentID = #PB_Ignore
      ParentID =  GadgetParentID( Gadget )
      
      If IsGadget( IDGadget( ParentID ) )
        ProcedureReturn IDGadget( ParentID )
      ElseIf IsWindow( IDWindow( ParentID ) )
        ProcedureReturn IDWindow( ParentID )
      EndIf  
      
      ProcedureReturn - (1)
    Else
      Protected *GtkWidget.GtkWidget, GadgetX, GadgetY, GtkFixed, GadgetID = GadgetID( Gadget )
      GadgetX = GadgetX( Gadget, #PB_Gadget_ContainerCoordinate) 
      GadgetY = GadgetY( Gadget, #PB_Gadget_ContainerCoordinate)
      GtkFixed = GtkFixed( ParentID )
      *GtkWidget.GtkWidget = GtkWidget( GadgetID )
      Protected GtkWidget,GtkWidget1
      
      If IsGadget( Gadget ) And GadgetType( Gadget ) = #PB_GadgetType_ScrollBar
        Debug "#PB_GadgetType_ScrollBar"
        Debug PeekS( gtk_widget_get_name_( ( *GtkWidget\parent\parent\parent ) ), -1, #PB_UTF8 )
        Debug PeekS( gtk_widget_get_name_( ( *GtkWidget\parent\parent ) ), -1, #PB_UTF8 )
        Debug PeekS( gtk_widget_get_name_( ( *GtkWidget\parent ) ), -1, #PB_UTF8 )
        Debug PeekS( gtk_widget_get_name_( ( *GtkWidget ) ), -1, #PB_UTF8 )
        Debug PeekS( gtk_widget_get_name_( GtkChildren( *GtkWidget ) ), -1, #PB_UTF8 )
        
        GtkWidget = ( ( ( ( *GtkWidget ) ) ) )
        GtkWidget1 = GtkChildren( ( ( ( *GtkWidget ) ) ) )
        gtk_widget_reparent_( GtkWidget, GtkFixed )
        ;gtk_widget_reparent_( GtkWidget1, GtkWidget )
        
      ElseIf IsGadget( Gadget ) And GadgetType( Gadget ) = #PB_GadgetType_ScrollArea
        Debug "#PB_GadgetType_ScrollArea"
        Debug PeekS( gtk_widget_get_name_( ( *GtkWidget\parent\parent\parent ) ), -1, #PB_UTF8 )
        Debug PeekS( gtk_widget_get_name_( ( *GtkWidget\parent\parent ) ), -1, #PB_UTF8 )
        Debug PeekS( gtk_widget_get_name_( ( *GtkWidget\parent ) ), -1, #PB_UTF8 )
        Debug PeekS( gtk_widget_get_name_( ( *GtkWidget ) ), -1, #PB_UTF8 )
        Debug PeekS( gtk_widget_get_name_( GtkChildren( *GtkWidget ) ), -1, #PB_UTF8 )
        Debug PeekS( gtk_widget_get_name_( GtkChildren( GtkChildren( *GtkWidget ) ) ), -1, #PB_UTF8 )
        
      ElseIf IsGadget( Gadget ) And GadgetType( Gadget ) = #PB_GadgetType_ExplorerList
        Debug "#PB_GadgetType_ExplorerList"
        Debug PeekS( gtk_widget_get_name_( ( *GtkWidget\parent\parent\parent ) ), -1, #PB_UTF8 )
        Debug PeekS( gtk_widget_get_name_( ( *GtkWidget\parent\parent ) ), -1, #PB_UTF8 )
        Debug PeekS( gtk_widget_get_name_( ( *GtkWidget\parent ) ), -1, #PB_UTF8 )
        Debug PeekS( gtk_widget_get_name_( ( ( *GtkWidget ) ) ), -1, #PB_UTF8 )
        Debug PeekS( gtk_widget_get_name_( GtkChildren( ( *GtkWidget ) ) ), -1, #PB_UTF8 )
        
        gtk_widget_reparent_( GtkChildren( ( *GtkWidget ) ), GtkFixed )
      ElseIf IsGadget( Gadget ) And GadgetType( Gadget ) = #PB_GadgetType_ExplorerTree
        Debug "#PB_GadgetType_ExplorerTree"
        ;         Debug PeekS( gtk_widget_get_name_( ( *GtkWidget\parent\parent\parent ) ), -1, #PB_UTF8 )
        ;         Debug PeekS( gtk_widget_get_name_( ( *GtkWidget\parent\parent ) ), -1, #PB_UTF8 )
        ;         Debug PeekS( gtk_widget_get_name_( ( *GtkWidget\parent ) ), -1, #PB_UTF8 )
        ;         Debug PeekS( gtk_widget_get_name_( ( ( *GtkWidget ) ) ), -1, #PB_UTF8 )
        ;         Debug PeekS( gtk_widget_get_name_( GtkChildren( ( *GtkWidget ) ) ), -1, #PB_UTF8 )
        
        gtk_widget_reparent_( GtkChildren( ( *GtkWidget ) ), GtkFixed )
      Else
        ;         Debug "#PB_GadgetType_*"
        ;         Debug PeekS( gtk_widget_get_name_( ( *GtkWidget\parent\parent\parent ) ), -1, #PB_UTF8 )
        ;         Debug PeekS( gtk_widget_get_name_( ( *GtkWidget\parent\parent ) ), -1, #PB_UTF8 )
        ;         Debug PeekS( gtk_widget_get_name_( ( *GtkWidget\parent ) ), -1, #PB_UTF8 )
        ;         Debug PeekS( gtk_widget_get_name_( ( *GtkWidget ) ), -1, #PB_UTF8 )
        ;         Debug PeekS( gtk_widget_get_name_( GtkChildren( *GtkWidget ) ), -1, #PB_UTF8 )
        
        gtk_widget_reparent_( *GtkWidget, GtkFixed ) 
        ResizeGadget( Gadget, GadgetX, GadgetY, #PB_Ignore, #PB_Ignore )
        If PeekS( gtk_widget_get_name_( ParentID ), -1, #PB_UTF8 ) = "GtkNotebook" ; #PB_GadgetType_Panel
          GadgetX = GadgetX + *GtkWidget\parent\allocation\x
          GadgetY = GadgetY + *GtkWidget\parent\allocation\y 
        EndIf
        gtk_widget_set_uposition_( *GtkWidget, GadgetX, GadgetY )
      EndIf
      
      ProcedureReturn ParentID
    EndIf
  EndIf
EndProcedure

DisableExplicit

CompilerIf #PB_Compiler_IsMainFile
  Procedure.S ParentTypeS( Gadget )
    Select ParentType( (Gadget) )
      Case #PB_ParentType_Window
        ProcedureReturn "ParentType = Window "+GadgetParent(Gadget)
      Case #PB_ParentType_Container
        ProcedureReturn "ParentType = ContainerGadget "+GadgetParent(Gadget)
      Case #PB_ParentType_Panel
        ProcedureReturn "ParentType = PanelGadget "+GadgetParent(Gadget)
      Case #PB_ParentType_ScrollArea
        ProcedureReturn "ParentType = ScrollAreaGadget "+GadgetParent(Gadget)
      Default
        ProcedureReturn "ParentType = Desktop "+GadgetParent(Gadget)
    EndSelect
  EndProcedure
  
  
  Define Flags = #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_ScreenCentered 
  OpenWindow(1, 0, 0, 630, 400, "Form_0", Flags )
  ButtonGadget(-1,30,100,150,30,"move to Window")
  PanelGadget(1,10,140,200,170) :AddGadgetItem(1,-1,"Panel") :ButtonGadget(-1,30,100,150,30,"move to Panel") :AddGadgetItem(1,-1,"Second") :AddGadgetItem(1,-1,"Third") :CloseGadgetList()
  ContainerGadget(2,215,140,200,170,#PB_Container_Flat) :ButtonGadget(-1,30,100,150,30,"move to Container")  :CloseGadgetList() ; ContainerGadget
  ScrollAreaGadget(3,420,140,200,170,200,180,10,#PB_ScrollArea_Flat) :ButtonGadget(-1,30,100,150,30,"move to ScrollArea") :CloseGadgetList()
  
  ButtonGadget(4,50,320,100,30,"move to Desktop") 
  ButtonGadget(5,150,320,100,30,"move to Window") 
  ButtonGadget(6,250,320,100,30,"move to Panel") 
  ButtonGadget(7,350,320,100,30,"move to Container") 
  ButtonGadget(8,450,320,100,30,"move to Scroll") 
  
  ButtonGadget(9,100,350,400,30,"back") 
  
  Define Desktop = ExamineDesktops() - 1
  Flags = #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget| #PB_Window_SizeGadget 
  OpenWindow(2, WindowX( 1 )+20+WindowWidth( 1 ), WindowY( 1 ), 200, 400, "Form_1", Flags, WindowID(1))
  ComboBoxGadget( 21,30,100,150,30 ) 
  ;{ - 
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
                                            ;}
  SetGadgetState( 21, #PB_GadgetType_ScrollArea) :PostEvent(#PB_Event_Gadget, 2, 21)
  
  HideWindow(1,0)
  HideWindow(2,0)
  
  Repeat
    Define Event=WaitWindowEvent()
    If Event=#PB_Event_Gadget 
      If EventGadget()=4
        GadgetParent((20), 0)
      ElseIf EventGadget()=5
        GadgetParent((20), WindowID(1))
      ElseIf EventGadget()=6
        GadgetParent((20), GadgetID(1))
      ElseIf EventGadget()=7
        GadgetParent((20), GadgetID(2))
      ElseIf EventGadget()=8
        GadgetParent((20), GadgetID(3))
      ElseIf EventGadget()=9
        GadgetParent((20), WindowID(2))
        
        
      ElseIf EventGadget()=21
        Define OldParentID = GadgetParentID((20))
        
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
          Case 15 :ScrollBarGadget(20,30,20,150,30,5,5,9)
          Case 16 :ScrollAreaGadget(20,30,20,150,30,305,305,9,#PB_ScrollArea_Flat) :ButtonGadget(-1,0,0,80,20,"ButtonGadget") :CloseGadgetList()
          Case 17 :TrackBarGadget(20,30,20,150,30,0,5)
          Case 18 :WebGadget(20,30,20,150,30,"") ; bug 531 linux
          Case 19 :ButtonImageGadget(20,30,20,150,30,0)
          Case 20 :CalendarGadget(20,30,20,150,30) 
          Case  21 :DateGadget(20,30,20,150,30)
          Case 22 :EditorGadget(20,30,20,150,30) 
          Case 23 :ExplorerListGadget(20,30,20,150,30,"")
          Case 24 :ExplorerTreeGadget(20,30,20,150,30,"")
          Case 25 :ExplorerComboGadget(20,30,20,150,30,"")
          Case 26 :SpinGadget(20,30,20,150,30,0,5,#PB_Spin_Numeric)
          Case 27 :TreeGadget(20,30,20,150,30)
          Case 28 :PanelGadget(20,30,20,150,30) :AddGadgetItem(20,-1,"PanelGadget") :CloseGadgetList()
          Case 29 :SplitterGadget(20,30,20,150,30,ButtonGadget(-1,0,0,30,30,"1"),ButtonGadget(-1,0,0,30,30,"2"))
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
            Case 30 :MDIGadget(20,30,20,150,30,0,0)
            Case 31 :InitScintilla() :ScintillaGadget(20,30,20,150,30,0)
            Case 32 :ShortcutGadget(20,30,20,150,30,0)
            Case 33 :CanvasGadget(20,30,20,150,30) 
            CompilerElse
            Case 30 :InitScintilla() :ScintillaGadget(20,30,20,150,30,0)
            Case 31 :ShortcutGadget(20,30,20,150,30,0)
            Case 32 :CanvasGadget(20,30,20,150,30) 
            CompilerEndIf
            
        EndSelect
        
        ResizeGadget(20,30,20,150,70)
        
        If OldParentID
          GadgetParent((20), OldParentID)
        EndIf
      EndIf 
      
      If IsGadget(20)
        SetWindowTitle(1, ParentTypeS(20))
      EndIf
    EndIf  
  Until Event=#PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (Linux - x64)
; CursorPosition = 14
; Folding = --------
; EnableXP