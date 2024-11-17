CompilerIf #PB_Compiler_IsMainFile 
  XIncludeFile "id.pbi"
CompilerEndIf

DeclareModule Mouse
  Declare.i Window( )
  Declare.i Gadget( WindowID )
  Declare.i State( )
EndDeclareModule

Module Mouse
  ; no good all gadgets
  
  Macro gtk_children( _handle_, _children_ = 0 ) : g_list_nth_data_( gtk_container_get_children_( _handle_ ), _children_ ) : EndMacro
  Macro gtk_bin( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_bin_get_type_ ( ) ) : EndMacro
  Macro gtk_box( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_box_get_type_ ( ) ) : EndMacro
  Macro gtk_FrameWidget( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_frame_get_type_ ( ) ) : EndMacro
  Macro gtk_fixed( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_fixed_get_type_ ( ) ) : EndMacro
  Macro gtk_ContainerWidget( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_container_get_type_ ( ) ) : EndMacro
  Macro gtk_widget( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_widget_get_type_ ( ) ) : EndMacro
  Macro gtk_window( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_window_get_type_ ( ) ) : EndMacro
  Macro gtk_table( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_table_get_type_ ( ) ) : EndMacro
  Macro gtk_hbox( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_hbox_get_type_ ( ) ) : EndMacro
  Macro gtk_vbox( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_hbox_get_type_ ( ) ) : EndMacro
  Macro gtk_vpaned( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_vpaned_get_type_ ( ) ) : EndMacro
  Macro gtk_viewport( _handle_ ) : gtk_widget_get_ancestor_ ( _handle_, gtk_viewport_get_type_ ( ) ) : EndMacro
  
  Procedure.s ClassName( handle.i )
    Protected Result = gtk_widget_get_name_( handle )
    If Result
      ProcedureReturn PeekS( Result, - 1, #PB_UTF8 )
    EndIf
  EndProcedure
  
  Procedure Window( )
    Protected desktop_x, desktop_y, handle, *GdkWindow.GdkWindowObject = gdk_window_at_pointer_( @desktop_x, @desktop_y )
    
    If *GdkWindow
      gdk_window_get_user_data_( *GdkWindow, @handle )
      ProcedureReturn gtk_widget_get_toplevel_( handle )
    EndIf
  EndProcedure
  
  Procedure Gadget( WindowID )
    If WindowID
      Protected handle, desktop_x, desktop_y, *GdkWindow.GdkWindowObject = gdk_window_at_pointer_( @desktop_x, @desktop_y )
      
      If *GdkWindow
        gdk_window_get_user_data_( *GdkWindow, @handle )
        If IsGadget(ID::Gadget(handle))
          ProcedureReturn handle
        Else
          If IsGadget(ID::Gadget(gtk_widget_get_parent_( handle )))
            ProcedureReturn gtk_widget_get_parent_( handle )
          Else
            
            If ClassName(handle) = "GtkButton"
              ; listicon heder
              handle = gtk_widget_get_parent_( handle )
            ElseIf ClassName(handle) = "GtkToggleButton"
              ; combobox
              handle = gtk_widget_get_parent_( handle )
              handle = gtk_widget_get_parent_( handle )
            ElseIf ClassName(handle) = "GtkEventBox"
              ; hyperlink
              handle = gtk_children(handle)
              If ClassName(handle) = "GtkFrame"
                ; text & image
                handle = gtk_children(handle)
              EndIf
            ElseIf ClassName(handle) = "GtkLabel"
              handle = gtk_widget_get_parent_( handle )
              
            ElseIf ClassName(handle) = "GtkLayout"
              handle = gtk_widget_get_parent_( handle )
              handle = gtk_widget_get_parent_( handle )
              ;handle = gtk_children(handle)
              ;Debug "eee "+ClassName(handle)
              ;handle = gtk_children(handle)
              ;ProcedureReturn 0
            Else
;               Debug ""
;               Debug ClassName(handle)
;               handle = gtk_children(handle)
;               Debug ClassName(handle)
;               handle = gtk_children(handle)
;               Debug ClassName(handle)
              
            EndIf
            ;handle = gtk_widget_get_parent_( handle )
            
            ProcedureReturn handle
          EndIf
        EndIf
      EndIf
    EndIf
  EndProcedure
  
  Procedure State( )
    Static press.b
    Protected mask, state.b, *GdkWindow.GdkWindowObject = gdk_window_at_pointer_( 0,0 )
      
      If *GdkWindow
        gdk_window_get_pointer_(*GdkWindow, 0,0, @mask)
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
    If press <> state
      If state
        If state = 1
          Debug "LeftDown - "+state
        ElseIf state = 2
          Debug "RightDown - "+state
        EndIf
      Else
        If press = 1
          Debug "LeftUp - "+press
        ElseIf press = 2
          Debug "RightUp - "+press
        EndIf
      EndIf
      press = state
    EndIf
    
  EndProcedure
EndModule

;-\\ example
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
  
  Procedure scrolled()
    
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
    
    
    Define eventID,  WindowID , gadgetID, gadget
    Repeat
      eventID = WaitWindowEvent( )
      WindowID = Mouse::Window( )
      gadgetID = Mouse::Gadget( WindowID )
      
      If gadgetID
        Mouse::State( )
        If ID::Gadget( gadgetID ) =- 1
          Debug "window - ("+ ID::Window( WindowID ) +") "+ WindowID ;+" "+ GetClassName( WindowID )
        Else
          gadget = ID::Gadget( gadgetID )
          Debug "gadget - ("+ gadget +") "+ gadgetID ;+" "+ GetClassName( gadgetID )
          
          ;           If StartDrawing( WindowOutput( EventWindow() ))
          ;             DrawingMode( #PB_2DDrawing_Outlined )
          ;             Box( GadgetX(gadget),GadgetY(gadget),GadgetWidth(gadget),GadgetHeight(gadget),$ff0000) 
          ;             StopDrawing()
          ;           EndIf
        EndIf
      EndIf
      
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
; CursorPosition = 102
; FirstLine = 40
; Folding = ---8----
; EnableXP