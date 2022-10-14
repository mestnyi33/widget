XIncludeFile "../../../widget-events.pbi" 


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Uselib( WIDGET )
  UsePNGImageDecoder( )
  
  #_drag_private_type = 1
  
  ;- ENUMs
  ; properties items
  Enumeration 
    #_pi_group_0 
    #_pi_id
    #_pi_class
    #_pi_text
    
    #_pi_group_1 
    #_pi_x
    #_pi_y
    #_pi_width
    #_pi_height
    
    #_pi_group_2 
    #_pi_disable
    #_pi_hide
  EndEnumeration
  
  ; events items
  Enumeration 
    #_ei_leftclick
    #_ei_change
    #_ei_enter
    #_ei_leave
  EndEnumeration
  
  ; toolbar buttons
  Enumeration 
    #_tb_group_left = 3
    #_tb_group_right
    #_tb_group_top
    #_tb_group_bottom
    #_tb_group_width
    #_tb_group_height
    
    #_tb_align_left
    #_tb_align_right
    #_tb_align_top
    #_tb_align_bottom
    #_tb_align_center
    
    #_tb_widget_paste
    #_tb_widget_delete
    #_tb_widget_copy
    #_tb_widget_cut
  EndEnumeration
  
  ;- GLOBALs
  Global window_ide, 
         canvas_ide
  
  Global Splitter_ide, 
         Splitter_design, 
         splitter_debug, 
         Splitter_inspector, 
         splitter_help
  
  Global toolbar_design, 
         listview_debug, 
         id_help_text
  
  Global id_design_panel, 
         id_design_form,
         id_design_code
  
  Global id_inspector_panel,
         id_inspector_tree, 
         id_elements_tree,
         id_properties_tree, 
         id_events_tree
  
  Global group_select,
         group_drag
  
  UsePNGImageDecoder( )
  
  Global img = LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png" ) 
  
  ;-
  ;- PUBLICs
  ;-
  Declare widget_events( )
  
  Procedure SetGadgetState_(gadget, state)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
        ; CocoaMessage(0, GadgetID(gadget), "scrollColumnToVisible:", state)
        If state >= 0
          CocoaMessage(0, GadgetID(gadget), "scrollRowToVisible:", state )
        EndIf
    CompilerEndSelect
    
    SetGadgetState(gadget, state)
  EndProcedure
  
  Procedure AddGadgetItem_(gadget, position, text.s, imageID=0, flags=0)
    AddGadgetItem(gadget, position, text, imageID, flags)
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_MacOS
        If GetGadgetState(gadget) >= 0
          SetGadgetState_(gadget, CountGadgetItems(gadget) - 1)
        EndIf
    CompilerEndSelect
  EndProcedure
  
  Procedure.i widget_images( *id, Directory$ )
    Protected ZipFile$ = Directory$ + "SilkTheme.zip"
    
    If FileSize( ZipFile$ ) < 1
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        ZipFile$ = #PB_Compiler_Home+"themes\SilkTheme.zip"
      CompilerElse
        ZipFile$ = #PB_Compiler_Home+"themes/SilkTheme.zip"
      CompilerEndIf
      If FileSize( ZipFile$ ) < 1
        MessageRequester( "Designer Error", "Themes\SilkTheme.zip Not found in the current directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error | #PB_MessageRequester_Ok )
        End
      EndIf
    EndIf
    ;   Directory$ = GetCurrentDirectory( )+"images/" ; "";
    ;   Protected ZipFile$ = Directory$ + "images.zip"
    
    
    If FileSize( ZipFile$ ) > 0
      ; UsePNGImageDecoder( )
      
      CompilerIf #PB_Compiler_Version > 522
        UseZipPacker( )
      CompilerEndIf
      
      Protected PackEntryName.s, ImageSize, *memory, Image, ZipFile
      ZipFile = OpenPack( #PB_Any, ZipFile$, #PB_PackerPlugin_Zip )
      
      If ZipFile  
        If ExaminePack( ZipFile )
          While NextPackEntry( ZipFile )
            
            PackEntryName.S = PackEntryName( ZipFile )
            ImageSize = PackEntrySize( ZipFile )
            If ImageSize
              *memory = AllocateMemory( ImageSize )
              UncompressPackMemory( ZipFile, *memory, ImageSize )
              PackEntryName.S = ReplaceString( PackEntryName.S,".png","" )
              
              If PackEntryName.S="application_form" 
                PackEntryName.S="vd_windowgadget"
              EndIf
              
              If PackEntryName.S="page_white_edit" 
                PackEntryName.S="vd_scintillagadget"
              EndIf
              
              Select PackEntryType( ZipFile )
                Case #PB_Packer_File
                  If FindString( Left( PackEntryName.S, 3 ), "vd_" )
                    PackEntryName.S = ReplaceString( PackEntryName.S,"vd_","" )
                    PackEntryName.S = ReplaceString( PackEntryName.S,"gadget","" )
                    PackEntryName.S = ReplaceString( PackEntryName.S,"bar","" )
                    PackEntryName = LCase( PackEntryName.S )
                    
                    If FindString( PackEntryName, "cursor" )
                      PackEntryName.S = UCase( Left( PackEntryName.S, 1 ) ) + 
                                        Right( PackEntryName.S, Len( PackEntryName.S )-1 )
                      
                      Image = CatchImage( #PB_Any, *memory, ImageSize )
                      AddItem( *id, 0, PackEntryName.S, Image )
                      SetItemData( *id, 0, Image )
                      Image = #Null
                      
                    ElseIf FindString( PackEntryName, "window" )
                      Image = #PB_Any
                    ElseIf FindString( PackEntryName, "image" )
                      Image = #PB_Any
                    ElseIf FindString( PackEntryName, "button" )
                      Image = #PB_Any
                    ElseIf FindString( PackEntryName, "string" )
                      Image = #PB_Any
                    ElseIf FindString( PackEntryName, "text" )
                      Image = #PB_Any
                    ElseIf FindString( PackEntryName, "progress" )
                      Image = #PB_Any
                    ElseIf FindString( PackEntryName, "container" )
                      Image = #PB_Any
                    ElseIf FindString( PackEntryName, "scrollarea" )
                      Image = #PB_Any
                    ElseIf FindString( PackEntryName, "splitter" )
                      Image = #PB_Any
                    ElseIf FindString( PackEntryName, "panel" )
                      Image = #PB_Any
                    Else
                      ; Image = #PB_Any
                    EndIf
                    
                    If Image
                      PackEntryName.S = UCase( Left( PackEntryName.S, 1 ) ) + 
                                        Right( PackEntryName.S, Len( PackEntryName.S )-1 )
                      
                      Image = CatchImage( #PB_Any, *memory, ImageSize )
                      AddItem( *id, -1, PackEntryName.S, Image )
                      SetItemData( *id, CountItems( *id )-1, Image )
                      Image = #Null
                    EndIf
                  EndIf    
              EndSelect
              
              FreeMemory( *memory )
            EndIf
          Wend  
        EndIf
        
        ; select cursor
        SetState( *id, 0 )
        ClosePack( ZipFile )
      EndIf
    EndIf
  EndProcedure
  
  Procedure widget_add( *parent._s_widget, class.s, x.l,y.l, width.l=0, height.l=0 )
    Protected *new._s_widget, *param1, *param2, *param3
    Protected flag.i
    
    If *parent 
      class.s = LCase( Trim( class ) )
      OpenList( *parent, GetState( *parent ) ) 
      
      If class = "scrollarea"
        *param1 = width
        *param2 = height
        *param3 = 5
      EndIf
      
      If a_transform( ) And a_transform( )\grid\size
        x = ( x/a_transform( )\grid\size ) * a_transform( )\grid\size
        y = ( y/a_transform( )\grid\size ) * a_transform( )\grid\size
        width = ( width/a_transform( )\grid\size ) * a_transform( )\grid\size + 1
        height = ( height/a_transform( )\grid\size ) * a_transform( )\grid\size + 1
        
        ;Debug ( a_transform( )\pos + #__window_frame_size )
        
        If class = "window"
          width + ( #__window_frame_size * 2 )%a_transform( )\grid\size
          height + ( #__window_frame_size * 2 + #__window_caption_height )%a_transform( )\grid\size
        EndIf
      EndIf
      
      If Not width Or width = 1
        width = 100
      EndIf
      If Not height Or height = 1
        height = 30
      EndIf
      
      
      ; create elements
      Select class
        Case "window"    
          If GetType( *parent ) = #PB_GadgetType_MDI
            *new = AddItem( *parent, #PB_Any, "", - 1, flag )
            Resize( *new, #PB_Ignore, #PB_Ignore, width,height )
          Else
            flag | #__window_systemmenu | #__window_maximizegadget | #__window_minimizegadget
            a_init(*parent)
            ;;a_set(*parent)
            *new = Window( x,y,width,height, "", flag, *parent )
          EndIf
          
          SetColor( *new, #__color_back, $FFECECEC )
          Bind( *new, @widget_events( ) )
          
        Case "container"   : *new = Container( x,y,width,height, flag )                             : CloseList( )
          SetColor( *new, #__color_back, $FFF1F1F1 )
          
        Case "button"      : *new = Button( x,y,width,height, "", flag ) 
          
      EndSelect
      
      If *new
        If *new\container ;> 0
          If *new\container = #__type_window
            SetImage( *new, CatchImage( #PB_Any,?group_bottom ) )
          EndIf
          
          ;  SetBackgroundImage( *new, Points( a_transform( )\grid\size-1, #__grid_type, $FF000000 ) ) ; $BDC5C6C6 ) )
          EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_drag_private_type )
        EndIf
        
        Class.s = "Form_"+GetClass( *new )+"_"+GetCount( *new )
        SetText( *new, class )
        
        
        ; get new add position & sublevel
        Protected i, sublevel, countitems, position ;= GetData( *parent ) 
        countitems = CountItems( id_inspector_tree )
        For i=0 To countitems - 1
          Position = (i+1)
          
          If *parent = GetItemData(id_inspector_tree, i) 
            SubLevel = GetItemAttribute(id_inspector_tree, i, #PB_Tree_SubLevel) + 1
            Continue
          EndIf
          
          If SubLevel > GetItemAttribute(id_inspector_tree, i, #PB_Tree_SubLevel)
            Position = i
            Break
          EndIf
        Next 
      
        ; set new widget data
        SetData( *new, position )
        
        ; update new widget data item
        If countitems > position
          For i = position To countitems - 1
            SetData( GetItemData( id_inspector_tree, i ), i + 1 )
          Next 
        EndIf
        
        ; get image
        Protected img =- 1
        countitems = CountItems( id_elements_tree )
        For i = 0 To countitems - 1
          If LCase(StringField( Class, 2, "_" )) = LCase(GetItemText( id_elements_tree, i ))
            img = GetItemData( id_elements_tree, i )
            Break
          EndIf
        Next  
        
        ; add to inspector
        AddItem( id_inspector_tree, position, class.s, img, sublevel )
        SetItemData( id_inspector_tree, position, *new )
        ; SetItemState( id_inspector_tree, position, #PB_tree_selected )
        SetState( id_inspector_tree, position )
        
        If IsGadget( id_design_code )
          AddGadgetItem_( id_design_code, position, Class.s, ImageID(img), SubLevel )
          SetGadgetItemData( id_design_code, position, *new )
          ; SetGadgetItemState( id_design_code, position, #PB_tree_selected )
          SetGadgetState_( id_design_code, position ) ; Bug
        EndIf
        
      EndIf
      
      CloseList( ) 
    EndIf
    
    ProcedureReturn *new
  EndProcedure
  
  Procedure widget_events( )
    Protected EventWidget = EventWidget( )
    Select WidgetEventType( ) 
      Case #PB_EventType_DragStart
        If IsContainer( EventWidget )
          DragPrivate( #_drag_private_type )
          SetCursor( EventWidget, #PB_Cursor_Cross )
          ClearDebugOutput()
        EndIf
        
      Case #PB_EventType_Drop
        If IsContainer( EventWidget )
           ;Debug "DROP "+EventWidget( )\class  +" "+ WidgetEventType( ) 
          If GetState( id_elements_tree) <> 0 
            Debug "create - drop"
            widget_add( EventWidget, GetText( id_elements_tree ), 
                        EventDropX( ), EventDropY( ), EventDropWidth( ), EventDropHeight( ) )
            
            ; end new create 
            SetState( id_elements_tree, 0 )
          EndIf
        EndIf
        
;       Case #PB_EventType_LeftButtonUp
;         If GetState( id_elements_tree) <> 0 
;           Debug ""+mouse( )\x+" "+mouse( )\delta\x
;           widget_add( EventWidget( ), GetText( id_elements_tree ), mouse( )\delta\x-X(EventWidget( ), #PB_Gadget_ContainerCoordinate), mouse( )\delta\y-Y(EventWidget( ), #PB_Gadget_ContainerCoordinate) )
;            SetState( id_elements_tree, 0 )
;         EndIf
    
    EndSelect
  EndProcedure
  
  
  ;-
  Procedure ide_events( )
    Protected *this._s_widget
    Protected e_type = WidgetEvent( )\type
    Protected e_item = WidgetEvent( )\item
    Protected EventWidget = EventWidget( )
    
    Select e_type
      Case #PB_EventType_LeftButtonDown
          
      Case #PB_EventType_DragStart
        If EventWidget = id_elements_tree
          ClearDebugOutput()
          
          Debug "drag - "
          ;         DD_EventDragWidth( ) 
          ;         DD_EventDragHeight( )
          
          a_transform( )\type = 0
          DragPrivate( #_drag_private_type )
          SetCursor( EventWidget( ), ImageID( GetItemData( EventWidget, GetState( EventWidget ))))
        EndIf
        
      Case #PB_EventType_Change
        Protected q, startpos, stoppos
        If EventWidget = id_inspector_tree
          ClearDebugOutput()
          
          *this = GetItemData( EventWidget, GetState( EventWidget ) )
          
          If a_set( *this )
          EndIf
          
          ;;SetActive( *this )
        EndIf
        
        
    EndSelect
  EndProcedure
  
  Procedure ide_open( x=100,y=100,width=800,height=530 )
    ;     OpenWindow( #PB_Any, 0,0,332,232, "" )
    ;     id_design_code = TreeGadget( -1,1,1,330,230 ) 
    
    Define flag = #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget
    Define root = widget::Open( OpenWindow( #PB_Any, x,y,width,height, "ide", flag ) )
    window_ide = widget::GetWindow( root )
    canvas_ide = widget::GetGadget( root )
    
    id_inspector_tree = Tree( 590,10,200,250, #__flag_gridlines )
    id_design_code = TreeGadget(-1, 590,270,200,250 )
    id_elements_tree = Tree( 430,10,150,510, #__flag_NoButtons | #__flag_NoLines | #__flag_gridlines | #__flag_borderless )
    id_design_form = MDI( 10,10,410,510, #__mdi_editable ) 
    
    
; ;     ; gadgets
; ;     id_inspector_tree = Tree( 0,0,0,0, #__flag_gridlines )
; ;     ;EnableDrop( id_inspector_tree, #PB_Drop_Text, #PB_Drag_Link )
; ;     
; ;     
; ;     ;id_design_form = Container( 0,0,0,0, #__mdi_editable ) : CloseList( )
; ;     id_design_form = MDI( 0,0,0,0, #__mdi_editable ) 
; ;     ;id_design_form = MDI(10,10, width( widget( ), #__c_inner )-20, height( widget( ), #__c_inner )-20);, #__flag_autosize)
; ;     id_design_panel = id_design_form
; ;     ;id_design_code = listview_debug
; ;     
; ; ;     id_inspector_panel = Panel( 0,0,0,0 )
; ; ;     
; ; ;     ; id_inspector_panel 1 item
; ; ;     AddItem( id_inspector_panel, -1, "elements", 0, 0 ) 
; ;     id_elements_tree = Tree( 0,0,0,0, #__flag_autosize | #__flag_NoButtons | #__flag_NoLines | #__flag_gridlines | #__flag_borderless )
; ;     id_inspector_panel = id_elements_tree
; ; ;     ; id_inspector_panel 2 item
; ; ;     AddItem( id_inspector_panel, -1, "properties", 0, 0 )  
; ; ;     
; ; ;     ; id_inspector_panel 3 item
; ; ;     AddItem( id_inspector_panel, -1, "events", 0, 0 )  
; ; ;     
; ; ;     ; id_inspector_panel closes
; ; ;     CloseList( )
; ;     
; ;     
; ;     Splitter_inspector = widget::Splitter( 0,0,0,0, id_inspector_tree,id_inspector_panel, #PB_Splitter_FirstFixed )
; ;     ;splitter_debug = widget::Splitter( 0,0,0,0, id_design_panel,listview_debug, #PB_Splitter_SecondFixed )
; ;     splitter_debug = id_design_panel
; ;     Splitter_ide = widget::Splitter( 0,0,0,0, splitter_debug,Splitter_inspector, #__flag_autosize | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed )
 
    Bind( id_inspector_tree, @ide_events( ) )
    Bind( id_elements_tree, @ide_events( ), #PB_EventType_DragStart )
    ProcedureReturn window_ide
  EndProcedure
  
  ;-
  CompilerIf #PB_Compiler_IsMainFile 
    Define event
    ide_open( )
    
    If id_elements_tree
      widget_images( id_elements_tree, GetCurrentDirectory( )+"Themes/" )
    EndIf
    
    Define *window = widget_add(id_design_form, "window", 30, 30, 350, 250)
    widget_add(*window, "button", 15, 15, 120, 30)
  
    Define *container = widget_add(*window, "container", 15, 50, 165, 170)
    Define *container = widget_add(*window, "container", 185, 50, 165, 170)
    
    Repeat 
      event = WaitWindowEvent( ) 
      
      ;     Select EventWindow( )
      ;       Case window_ide 
      ;         ide_window_events( event )
      ;     EndSelect
      
    Until event = #PB_Event_CloseWindow
  CompilerEndIf
  
  
  DataSection   
    ; include images
    IncludePath #path + "/ide/include/images"
    
    widget_delete:    : IncludeBinary "delete1.png"
    widget_paste:     : IncludeBinary "paste.png"
    widget_copy:      : IncludeBinary "copy.png"
    widget_cut:       : IncludeBinary "cut.png"
    
    group:            : IncludeBinary "group/group.png"
    group_un:         : IncludeBinary "group/group_un.png"
    group_top:        : IncludeBinary "group/group_top.png"
    group_left:       : IncludeBinary "group/group_left.png"
    group_right:      : IncludeBinary "group/group_right.png"
    group_bottom:     : IncludeBinary "group/group_bottom.png"
    group_width:      : IncludeBinary "group/group_width.png"
    group_height:     : IncludeBinary "group/group_height.png"
  EndDataSection
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = f--------
; EnableXP