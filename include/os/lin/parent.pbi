XIncludeFile "id.pbi"

DeclareModule Parent
  EnableExplicit
  Declare WindowWidget( gadget.i )
  Declare Gadget( gadget.i )
  Declare Get( handle.i )
  Declare Set( gadget.i, ParentID.i, Item.l = #PB_Default )
EndDeclareModule

Module Parent
  ImportC ""
    gtk_widget_get_window( *widget.GtkWidget )
    gtk_notebook_get_tab_vborder( *Notebook.GtkNotebook )
    gtk_notebook_get_tab_hborder( *Notebook.GtkNotebook )
  EndImport
  
  ImportC ""
    gdk_window_get_effective_toplevel ( *window )
    gdk_screen_get_active_window ( *Screen.GdkScreen )
  EndImport
  
  Macro gtk_children( _handle_, _children_ = 0 ) : g_list_nth_data_( gtk_container_get_children_( _handle_ ), _children_ ) : EndMacro
  Macro gtk_bin( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_bin_get_type_ ( ) ) : EndMacro
  Macro gtk_box( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_box_get_type_ ( ) ) : EndMacro
  Macro gtk_FrameWidget( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_frame_get_type_ ( ) ) : EndMacro
  Macro gtk_fixed( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_fixed_get_type_ ( ) ) : EndMacro
  Macro gtk_Container( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_container_get_type_ ( ) ) : EndMacro
  Macro gtk_widget( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_widget_get_type_ ( ) ) : EndMacro
  Macro gtk_window( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_window_get_type_ ( ) ) : EndMacro
  Macro gtk_table( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_table_get_type_ ( ) ) : EndMacro
  Macro gtk_hbox( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_hbox_get_type_ ( ) ) : EndMacro
  Macro gtk_vbox( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_hbox_get_type_ ( ) ) : EndMacro
  Macro gtk_vpaned( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_vpaned_get_type_ ( ) ) : EndMacro
  Macro gtk_viewport( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_viewport_get_type_ ( ) ) : EndMacro
  
  ;-
  Procedure.s ClassName( handle.i )
    Protected Result = gtk_widget_get_name_( handle )
    If Result
      ProcedureReturn PeekS( Result, -1, #PB_UTF8 )
    EndIf
  EndProcedure
  
  
  Procedure pb_parent( handle, Item=-1 )
    CompilerIf #PB_Compiler_Version <562
      handle = gtk_widget( handle )
    CompilerEndIf
    
    If handle              
      Select ClassName( handle )
        Case "GtkWindow"
          handle = g_list_nth_data_( gtk_container_get_children_( gtk_bin_get_child_( handle ) ), 0 )
          CompilerIf #PB_Compiler_Version > 531 And #PB_Compiler_Version < 560 ; ?????
            handle = g_list_nth_data_( gtk_container_get_children_( gtk_bin_get_child_( handle ) ), 0 )
          CompilerEndIf
          ProcedureReturn handle
          
        Case "GtkScrolledWindow"
          ProcedureReturn g_list_nth_data_( gtk_container_get_children_( gtk_bin_get_child_( handle ) ), 0 )
          
        Case "GtkNotebook"
          If Item =- 1 
            Item = gtk_notebook_get_current_page_( handle ) 
          EndIf
          ProcedureReturn gtk_notebook_get_nth_page_( handle, Item ) 
          
        Case "GtkFixed"
          ProcedureReturn handle
          
        Case "GtkLayout"
          CompilerIf Subsystem("gtk2")
            ProcedureReturn g_list_nth_data_( gtk_container_get_children_( handle ), 0 )
          CompilerElse
            ProcedureReturn handle
          CompilerEndIf 
          
      EndSelect 
    EndIf
  EndProcedure
  
  Procedure pb_widget( handle )
    ;     GtkComboBox
    ;     GtkImage
    
    If handle 
      If gtk_fixed( handle ) = gtk_Container( handle )
        ProcedureReturn gtk_widget( handle )
      Else
        ProcedureReturn gtk_container ( handle )
      EndIf
    EndIf
  EndProcedure
  
  Procedure GTKView( handle )
    
    
    Select ClassName( handle )
      Case "GtkImage"
        If gtk_Container( handle ) = gtk_FrameWidget( handle ) ; gtk_widget_get_parent_( handle ) = gtk_FrameWidget( handle )
          handle = gtk_widget_get_parent_( gtk_FrameWidget( handle ) ) ; GtkEventBox
        Else
          handle = gtk_widget_get_parent_( handle ) ; GtkEventBox
        EndIf
        
      Case "GtkNotebook", "GtkHScrollbar", "Scintilla"
        handle = gtk_widget_get_parent_( handle ) ; GtkEventBox
        
      Case "GtkTextView", "GtkTreeView"
        handle = gtk_bin( handle ) ; "GtkScrolledWindow"
        
      Case "GtkVPaned"
        handle = gtk_Container( handle ) ; GtkContainer
        
      Case "GtkLayout"
        handle = gtk_FrameWidget( handle ) ; "GtkFrame"
        
      Case "GtkEntry"
        If ClassName( gtk_widget_get_parent_( handle ) ) <> "GtkLayout"
          handle = gtk_box( handle ) 
        EndIf
        
      Case "GtkLabel", "GtkBox"
        If gtk_box( handle ) = gtk_Container( handle ) Or
           gtk_box( handle ) = gtk_vbox( handle )
          handle = gtk_box( handle ) ; Spin ; Text ; "GtkBox"
        Else
          handle = gtk_bin( handle ) ; HyperLink
        EndIf
        
      Case "GtkComboBox"
        If ClassName( gtk_widget_get_parent_( handle ) ) = "GtkEventBox"
          handle = gtk_widget_get_parent_( handle ) ; ; ComboBox
        Else
          handle = gtk_bin( handle ) ; ExplorerCombo ; "GtkLayout"
        EndIf
        
    EndSelect
    ProcedureReturn handle
  EndProcedure
  
  
  ;-
  Procedure IDWindow( handle.i )
    ProcedureReturn g_object_get_data_( handle, "pb_id" )
  EndProcedure
  
  Procedure IDGadget( handle.i )
    ProcedureReturn g_object_get_data_( handle, "pb_id" ) - 1 
  EndProcedure
  
  Procedure GetWindowID( handle.i ) ; Return the handle of the parent window from the gadget handle
    ProcedureReturn gtk_widget_get_toplevel_( handle )
  EndProcedure
  
  Procedure WindowWidget( gadget.i ) ; Return the handle of the parent window from the gadget ident
    ProcedureReturn IDWindow( GetWindowID( GadgetID( gadget.i ) ) )
  EndProcedure
  
  Procedure Gadget( gadget.i ) ; Return the handle of the parent gadget from the gadget ident
    ProcedureReturn IDGadget( Get( GadgetID( gadget.i ) ) )
  EndProcedure
  
  Procedure Get( handle.i ) ; Return the handle of the parent from the handle
    Protected a
    While handle
      a = handle
      handle = gtk_widget_get_parent_( handle )
      
      If handle
        ;         ; ok
        ;         If IsWindow( IDWindow( handle ) ) Or 
        ;            IsGadget( IDgadget( handle ) )
        ;           ProcedureReturn handle
        ;         EndIf
        
        Select ClassName( handle ) 
          Case "GtkWindow", "GtkScrolledWindow", "GtkNotebook" 
            ProcedureReturn handle
          Case "GtkFrame"
            ProcedureReturn a
          Default
            If ClassName( gtk_widget_get_parent_( handle ) ) = "GtkLayout"
              ProcedureReturn handle
            EndIf
        EndSelect
      EndIf
    Wend
  EndProcedure
  
  Procedure Set( gadget.i, ParentID.i, Item.l = #PB_Default ) ; Set a new parent for the gadget
    If IsGadget( Gadget )
      Protected GtkWidget,GtkWidget1
      Protected *GtkWidget.GtkWidget, GadgetX, GadgetY, GtkFixed, handle = GadgetID( Gadget )
      
      GtkFixed = pb_parent( ParentID, Item )
      GadgetX = GadgetX( Gadget, #PB_Gadget_ContainerCoordinate ) 
      GadgetY = GadgetY( Gadget, #PB_Gadget_ContainerCoordinate )
      
      
      Select GadgetType( Gadget )
        Case #PB_GadgetType_Web;, #PB_GadgetType_ExplorerCombo
          Debug ""+ClassName( handle ) +" "+ ClassName(gtk_widget_get_parent_( handle ))
          ;           Debug ClassName(gtk_widget_get_parent_(g_list_nth_data_( gtk_container_get_children_( ( handle ) ), 1 ))) ;pb_parent( handle, -1 )
          ;           ;handle = g_list_nth_data_( gtk_container_get_children_( ( handle ) ), 1 )
          ;           gtk_widget_reparent_( g_list_nth_data_( gtk_container_get_children_( ( handle ) ), 1 ), GtkFixed )
          ;           ;gtk_widget_reparent_( g_list_nth_data_( gtk_container_get_children_( ( handle ) ), 0 ), GtkFixed )
          gtk_widget_reparent_( gtk_bin( handle ), GtkFixed )
          ;           gtk_widget_reparent_( g_list_nth_data_( gtk_container_get_children_( ( handle ) ), 1 ), handle )
          ResizeGadget( Gadget, GadgetX, GadgetY, #PB_Ignore, #PB_Ignore )
          
        Default
          
          If GtkFixed
            gtk_widget_reparent_( GTKView( handle ), GtkFixed ) 
            ResizeGadget( Gadget, GadgetX, GadgetY, #PB_Ignore, #PB_Ignore )
            
            CompilerIf #PB_Compiler_Version =< 531
              *GtkWidget = pb_widget( handle )
              
              If ClassName( ParentID ) = "GtkNotebook" ; #PB_GadgetType_Panel
                If *GtkWidget\parent
                  GadgetX = GadgetX + *GtkWidget\parent\allocation\x
                  GadgetY = GadgetY + *GtkWidget\parent\allocation\y 
                EndIf
              EndIf
              
              gtk_widget_set_uposition_( *GtkWidget\object, GadgetX, GadgetY )
            CompilerEndIf
          Else
            Debug "Desktop"
            Protected wscreen = gdk_screen_get_default_( ) ; экран по умолчанию
            Protected screen = gtk_widget_get_screen_( handle )
            
            Protected display = gdk_display_get_default_( )
            Protected wdisplay = gtk_widget_get_display_( handle )
            Protected sdisplay = gdk_screen_get_display_ ( wscreen )
            
            Debug gdk_screen_get_number_ ( wscreen )
            
            Debug IDWindow( gdk_screen_get_active_window ( wscreen ) )
            
            Debug IDWindow( gdk_get_default_root_window_( ) )
            Debug IDWindow( gdk_screen_get_root_window_ ( wscreen ) )
            Debug IDWindow( gtk_widget_get_root_window_( handle ) ) ; устарел gdk_screen_get_root_window_ ( gtk_widget_get_screen_( handle ) )
            
            Debug gdk_screen_get_active_window ( wscreen )
            
            Debug gdk_get_default_root_window_( )
            Debug gdk_screen_get_root_window_ ( wscreen )
            Debug gtk_widget_get_root_window_( handle ) ; устарел gdk_screen_get_root_window_ ( gtk_widget_get_screen_( handle ) )
            
            ;gdk_screen_get_toplevel_windows ( )
            Debug wscreen
            Debug screen
            
            Debug display
            Debug wdisplay
            
            Debug "gdk_window_get_toplevel_ "+gdk_window_get_toplevel_( gtk_widget_get_window( handle ) )
            Debug "gdk_window_get_effective_toplevel "+gdk_window_get_effective_toplevel( gtk_widget_get_window( handle ) )
            Debug "gtk_widget_get_window "+gtk_widget_get_window( handle )
            Debug "gtk_widget_get_parent_window_ "+gtk_widget_get_parent_window_( handle )
            Debug "WindowID( 1 ) "+WindowID( 10 )
            Debug "WindowID( 20 ) "+WindowID( 20 )
            
            Protected X,Y
            ;           Protected *Parent.GtkWidget = gdk_get_default_root_window_( )
            ;           gtk_widget_reparent_( *GtkWidget\object, *Parent\name ) 
            Protected Win = gdk_window_get_toplevel_( gtk_widget_get_window( handle ) )
            ;gdk_window_reparent_ ( gdk_window_get_toplevel_( gtk_widget_get_window( handle ) ), gtk_widget_get_window( WindowID( 1 ) ), x, y )
            
            ;gdk_window_reparent_ ( ( gtk_widget_get_window( handle ) ), gdk_get_default_root_window_( ), x, y )
            Protected *container.GtkContainer = gdk_get_default_root_window_( )
            ;gtk_widget_reparent_ ( ( ( handle ) ), *container\widget )
            Debug gtk_widget_get_ancestor_ ( *GtkWidget, gtk_box_get_type_ ( ) );#GTK_TYPE_Box )
                                                                                ;gtk_widget_set_parent_window_ ( *GtkWidget,gtk_widget_get_parent_window_( handle( 5 ) ) );
          EndIf
      EndSelect
      
      ProcedureReturn ParentID
    EndIf
  EndProcedure
EndModule

;-\\ example
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Parent
  
  Procedure GadgetIDType(  GadgetID )
    If GadgetID
      CompilerSelect #PB_Compiler_OS 
        CompilerCase #PB_OS_Linux
          Protected *notebook.GtkNotebook = GadgetID
          If *notebook\children
            If *notebook\first_tab = *notebook\children
              ProcedureReturn #PB_GadgetType_Panel
            ElseIf *notebook\packed_flags
              ProcedureReturn - 1
            Else
              ProcedureReturn #PB_GadgetType_ScrollArea
            EndIf
          Else
            ProcedureReturn #PB_GadgetType_Container
          EndIf
      CompilerEndSelect
    EndIf
  EndProcedure 
  
  Enumeration 21
    #CANVAS
    #PANEL
    #CONTAINER
    #SCROLLAREA
    #CHILD
    #RETURN
    #COMBO
    #DESKTOP
    #PANEL0
    #PANEL1
    #PANEL2
  EndEnumeration
  
  Define ParentID
  Define Flags = #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered 
  OpenWindow( 10, 0, 0, 425, 350, "demo set gadget new Parent", Flags )
  
  ButtonGadget( 6, 30,90,160,25,"Button >>( Window )" )
  
  ButtonGadget( #PANEL0, 30,120,160,20,"Button >>( Panel ( 0 ) )" ) 
  ButtonGadget( #PANEL1, 30,140,160,20,"Button >>( Panel ( 1 ) )" ) 
  ButtonGadget( #PANEL2, 30,160,160,20,"Button >>( Panel ( 2 ) )" ) 
  
  PanelGadget( #PANEL, 10,180,200,160 ) 
  AddGadgetItem( #PANEL,-1,"Panel" ) 
  ButtonGadget( 60, 30,90,160,30,"Button >>( Panel ( 0 ) )" ) 
  AddGadgetItem( #PANEL,-1,"First" ) 
  ButtonGadget( 61, 35,90,160,30,"Button >>( Panel ( 1 ) )" ) 
  AddGadgetItem( #PANEL,-1,"Second" ) 
  ButtonGadget( 62, 40,90,160,30,"Button >>( Panel ( 2 ) )" ) 
  CloseGadgetList( )
  
  ContainerGadget( #CONTAINER, 215,10,200,160,#PB_Container_Flat ) 
  ButtonGadget( 7, 30,90,160,30,"Button >>( Container )" ) 
  CloseGadgetList( )
  
  ScrollAreaGadget( #SCROLLAREA, 215,180,200,160,200,160,10,#PB_ScrollArea_Flat ) 
  ButtonGadget( 8, 30,90,160,30,"Button >>( ScrollArea )" ) 
  CloseGadgetList( )
  
  
  ;
  Flags = #PB_Window_Invisible | #PB_Window_TitleBar | #PB_Window_ScreenCentered 
  OpenWindow( 20, 0, 0, 240, 350, "old Parent", Flags, WindowID( 10 ) )
  
  ButtonGadget( #CHILD,30,10,160,70,"Buttongadget" ) 
  ButtonGadget( #RETURN, 30,90,160,25,"Button <<( Return )" ) 
  
  ComboBoxGadget( #COMBO,30,120,160,25 ) 
  AddGadgetItem( #COMBO, -1, "Selected gadget to move" )
  AddGadgetItem( #COMBO, -1, "Buttongadget" )
  AddGadgetItem( #COMBO, -1, "Stringgadget" )
  AddGadgetItem( #COMBO, -1, "Textgadget" )
  AddGadgetItem( #COMBO, -1, "CheckBoxgadget" )
  AddGadgetItem( #COMBO, -1, "Optiongadget" )
  AddGadgetItem( #COMBO, -1, "ListViewgadget" )
  AddGadgetItem( #COMBO, -1, "Framegadget" )
  AddGadgetItem( #COMBO, -1, "ComboBoxgadget" )
  AddGadgetItem( #COMBO, -1, "Imagegadget" )
  AddGadgetItem( #COMBO, -1, "HyperLinkgadget" )
  AddGadgetItem( #COMBO, -1, "Containergadget" )
  AddGadgetItem( #COMBO, -1, "ListIcongadget" )
  AddGadgetItem( #COMBO, -1, "IPAddressgadget" )
  AddGadgetItem( #COMBO, -1, "ProgressBargadget" )
  AddGadgetItem( #COMBO, -1, "ScrollBargadget" )
  AddGadgetItem( #COMBO, -1, "ScrollAreagadget" )
  AddGadgetItem( #COMBO, -1, "TrackBargadget" )
  AddGadgetItem( #COMBO, -1, "Webgadget" )
  AddGadgetItem( #COMBO, -1, "ButtonImagegadget" )
  AddGadgetItem( #COMBO, -1, "Calendargadget" )
  AddGadgetItem( #COMBO, -1, "Dategadget" )
  AddGadgetItem( #COMBO, -1, "Editorgadget" )
  AddGadgetItem( #COMBO, -1, "ExplorerListgadget" )
  AddGadgetItem( #COMBO, -1, "ExplorerTreegadget" )
  AddGadgetItem( #COMBO, -1, "ExplorerCombogadget" )
  AddGadgetItem( #COMBO, -1, "Spingadget" )        
  AddGadgetItem( #COMBO, -1, "Treegadget" )         
  AddGadgetItem( #COMBO, -1, "Panelgadget" )        
  AddGadgetItem( #COMBO, -1, "Splittergadget" )    
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    AddGadgetItem( #COMBO, -1, "MDIgadget" ) 
  CompilerEndIf
  AddGadgetItem( #COMBO, -1, "Scintillagadget" ) 
  AddGadgetItem( #COMBO, -1, "Shortcutgadget" )  
  AddGadgetItem( #COMBO, -1, "Canvasgadget" )    
  
  SetGadGetWidgetState( #COMBO, #PB_GadgetType_Button );:  PostEvent( #PB_Event_gadget, #CHILD, #COMBO, #PB_EventType_Change )
  
  ButtonGadget( #DESKTOP, 30,150,160,20,"Button >>( Desktop )" ) 
  CompilerIf #PB_Compiler_Version > 546
    CanvasGadget( #CANVAS, 30,180,200,160,#PB_Canvas_Container ) 
    ButtonGadget( 11, 30,90,160,30,"Button >>( Canvas )" ) 
    CloseGadgetList( )
  CompilerEndIf
  
  
  ResizeWindow( 20, WindowX( 20 )-WindowWidth( 20 ), #PB_Ignore, #PB_Ignore, #PB_Ignore )
  ResizeWindow( 10, WindowX( 10 )+WindowWidth( 20 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
  ;
  HideWindow( 10,0 )
  HideWindow( 20,0 )
  
  Repeat
    Define Event = WaitWindowEvent( )
    
    If Event = #PB_Event_Gadget 
      Select EventType( )
        Case #PB_EventType_LeftClick, #PB_EventType_Change
          Select EventGadget( )
            Case  #DESKTOP:  Parent::Set( #CHILD, 0 )
            Case  6:  Parent::Set( #CHILD, WindowID( 10 ) )
            Case 60, #PANEL0:  Parent::Set( #CHILD, GadgetID( #PANEL ), 0 )
            Case 61, #PANEL1:  Parent::Set( #CHILD, GadgetID( #PANEL ), 1 )
            Case 62, #PANEL2:  Parent::Set( #CHILD, GadgetID( #PANEL ), 2 )
            Case  7:  Parent::Set( #CHILD, GadgetID( #CONTAINER ) )
            Case  8:  Parent::Set( #CHILD, GadgetID( #SCROLLAREA ) )
            Case 11:  Parent::Set( #CHILD, GadgetID( #CANVAS ) )
            Case  #RETURN:  Parent::Set( #CHILD, WindowID( 20 ) )
              
            Case #COMBO
              Select EventType( )
                Case #PB_EventType_Change
                  Define ParentID = Parent::Get( GadgetID( #CHILD ) )
                  
                  Select GetGadGetWidgetState( #COMBO )
                    Case  1: ButtonGadget( #CHILD,30,20,150,30,"Buttongadget" ) 
                    Case  2: StringGadget( #CHILD,30,20,150,30,"Stringgadget" ) 
                    Case  3: TextGadget( #CHILD,30,20,150,30,"Textgadget", #PB_Text_Border ) 
                    Case  5: OptionGadget( #CHILD,30,20,150,30,"Optiongadget" ) 
                    Case  4: CheckBoxGadget( #CHILD,30,20,150,30,"CheckBoxgadget" ) 
                    Case  6: ListViewGadget( #CHILD,30,20,150,30 ) 
                    Case  7: FrameGadget( #CHILD,30,20,150,30,"Framegadget" ) 
                    Case  8: ComboBoxGadget( #CHILD,30,20,150,30 ): AddGadgetItem( #CHILD,-1,"ComboBoxgadget" ): SetGadGetWidgetState( #CHILD,0 )
                    Case  9: ImageGadget( #CHILD,30,20,150,30,0,#PB_Image_Border ) 
                    Case 10: HyperLinkGadget( #CHILD,30,20,150,30,"HyperLinkgadget",0 ) 
                    Case 11: ContainerGadget( #CHILD,30,20,150,30,#PB_Container_Flat ): ButtonGadget( -1,0,0,80,20,"Buttongadget" ): CloseGadgetList( ) ; Containergadget
                    Case 12: ListIconGadget( #CHILD,30,20,150,30,"",88 ) 
                    Case 13: IPAddressGadget( #CHILD,30,20,150,30 ) 
                    Case 14: ProgressBarGadget( #CHILD,30,20,150,30,0,5 )
                    Case 15: ScrollBarGadget( #CHILD,30,20,150,30,5,335,9 )
                    Case 16: ScrollAreaGadget( #CHILD,30,20,150,30,305,305,9,#PB_ScrollArea_Flat ): ButtonGadget( -1,0,0,80,20,"Buttongadget" ): CloseGadgetList( )
                    Case 17: TrackBarGadget( #CHILD,30,20,150,30,0,5 )
                    ;Case 18: WebGadget( #CHILD,30,20,150,30,"" ) ; bug 531 linux
                    Case 19: ButtonImageGadget( #CHILD,30,20,150,30,0 )
                    Case 20: CalendarGadget( #CHILD,30,20,150,30 ) 
                    Case 21: DateGadget( #CHILD,30,20,150,30 )
                    Case 22: EditorGadget( #CHILD,30,20,150,30 ):  AddGadgetItem( #CHILD,-1,"Editorgadget" )
                    Case 23: ExplorerListGadget( #CHILD,30,20,150,30,"" )
                    Case 24: ExplorerTreeGadget( #CHILD,30,20,150,30,"" )
                    Case 25: ExplorerComboGadget( #CHILD,30,20,150,30,"" )
                    Case 26: SpinGadget( #CHILD,30,20,150,30,0,5,#PB_Spin_Numeric )
                    Case 27: TreeGadget( #CHILD,30,20,150,30 ):  AddGadgetItem( #CHILD,-1,"Treegadget" ):  AddGadgetItem( #CHILD,-1,"SubLavel",0,1 )
                    Case 28: PanelGadget( #CHILD,30,20,150,30 ): AddGadgetItem( #CHILD,-1,"Panelgadget" ): CloseGadgetList( )
                    Case 29 
                      ButtonGadget( 201,0,0,30,30,"1" )
                      ButtonGadget( 202,0,0,30,30,"2" )
                      SplitterGadget( #CHILD,30,20,150,30,201,202 )
                  EndSelect
                  
                  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                    Select GetGadGetWidgetState( #COMBO )
                      Case 30: MDIGadget( #CHILD,30,10,150,70,0,0 )
                      Case 31: InitScintilla( ): ScintillaGadget( #CHILD,30,10,150,70,0 )
                      Case 32: ShortcutGadget( #CHILD,30,10,150,70,0 )
                      Case 33: CanvasGadget( #CHILD,30,10,150,70 ) 
                    EndSelect
                  CompilerElse
                    Select GetGadGetWidgetState( #COMBO )
                      Case 30: InitScintilla( ): ScintillaGadget( #CHILD,30,10,150,70,0 )
                      Case 31: ShortcutGadget( #CHILD,30,10,150,70,0 )
                      Case 32: CanvasGadget( #CHILD,30,10,150,70 ) 
                    EndSelect
                  CompilerEndIf
                  
                  ResizeGadget( #CHILD,30,10,150,70 )
                  Parent::Set( #CHILD, ParentID ) 
                  
              EndSelect
          EndSelect
          
          If EventType( ) = #PB_EventType_LeftClick
            If ( EventGadget( ) <> #CHILD )
              Define Parent = Parent::Gadget( #CHILD )
              
              If IsGadget( Parent )
                Debug "Parent - gadget ( " + Parent + " )"
              Else
                Debug "Parent - window ( " + Parent::Window( #CHILD ) + " )"
              EndIf
            EndIf
          EndIf
      EndSelect
    EndIf  
  Until Event = #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Linux - x64)
; CursorPosition = 441
; FirstLine = 428
; Folding = ------------
; EnableXP