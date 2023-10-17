XIncludeFile "../widgets.pbi" 


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Uselib( WIDGET )
  UsePNGImageDecoder( )
  
  #_DD_widget_new_create = 1<<1
  #_DD_widget_re_parent = 1<<2
  
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
      
      If width < 5
        width = 100
      EndIf
      If height < 5
        height = 100
      EndIf
      
      If class = "scrollarea"
        *param1 = width
        *param2 = height
        *param3 = 5
      EndIf
      
      If a_transform( ) And a_transform( )\grid_size
        x = ( x/a_transform( )\grid_size ) * a_transform( )\grid_size
        y = ( y/a_transform( )\grid_size ) * a_transform( )\grid_size
        width = ( width/a_transform( )\grid_size ) * a_transform( )\grid_size + 1
        height = ( height/a_transform( )\grid_size ) * a_transform( )\grid_size + 1
        
        ;Debug ( a_transform( )\pos + #__window_frame_size )
        
        If class = "window"
          width + ( #__window_frame_size * 2 )%a_transform( )\grid_size
          height + ( #__window_frame_size * 2 + #__window_caption_height )%a_transform( )\grid_size
        EndIf
      EndIf
      
      
      
      ; create elements
      Select class
        Case "window"    
          If Type( *parent ) = #__Type_MDI
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
          
          ;  SetBackgroundImage( *new, Points( a_transform( )\grid_size-1, #__grid_type, $FF000000 ) ) ; $BDC5C6C6 ) )
          EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_widget_new_create|#_DD_widget_re_parent )
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
  
  Procedure   SetPositionItem( *this._S_widget, *currentRow._s_rows, position.l, *rowMoved._S_rows = #Null ) ; Ok
                                                                                                             ;       If *rowMoved = #Null
                                                                                                             ;         Select Position 
                                                                                                             ;           Case #PB_List_First  : *rowMoved = *currentRow\ParentRow( )_row( )\first\row
                                                                                                             ;           Case #PB_List_Before : *rowMoved = *currentRow\before\row
                                                                                                             ;           Case #PB_List_After  : *rowMoved = *currentRow\after\row
                                                                                                             ;           Case #PB_List_Last   : *rowMoved = *currentRow\ParentRow( )_row( )\last\row
                                                                                                             ;         EndSelect
                                                                                                             ;       EndIf
                                                                                                             ;       
                                                                                                             ;       If *rowMoved And *currentRow <> *rowMoved ;And *currentRow\TabIndex( ) = *rowMoved\TabIndex( )
                                                                                                             ;         If Position = #PB_List_First Or Position = #PB_List_Before
                                                                                                             ;           
                                                                                                             ;           PushListPosition(  *this\_rows( ))
                                                                                                             ;           ChangeCurrentElement(  *this\_rows( ), *currentRow\address )
                                                                                                             ;           MoveElement(  *this\_rows( ), #PB_List_Before, *rowMoved\address )
                                                                                                             ;           
                                                                                                             ;           If *currentRow\childrens
                                                                                                             ;             While PreviousElement(  *this\_rows( )) 
                                                                                                             ;               If IsChild(  *this\_rows( ), *currentRow )
                                                                                                             ;                 MoveElement(  *this\_rows( ), #PB_List_After, *rowMoved\address )
                                                                                                             ;               EndIf
                                                                                                             ;             Wend
                                                                                                             ;             
                                                                                                             ;             While NextElement(  *this\_rows( )) 
                                                                                                             ;               If IsChild(  *this\_rows( ), *currentRow )
                                                                                                             ;                 MoveElement(  *this\_rows( ), #PB_List_Before, *rowMoved\address )
                                                                                                             ;               EndIf
                                                                                                             ;             Wend
                                                                                                             ;           EndIf
                                                                                                             ;           PopListPosition(  *this\_rows( ))
                                                                                                             ;         EndIf  
                                                                                                             ;         
                                                                                                             ;         If Position = #PB_List_Last Or Position = #PB_List_After
                                                                                                             ;           Protected *last._S_rows = *rowMoved\last\row ; GetLast( *rowMoved, *rowMoved\TabIndex( )) 
                                                                                                             ;           
                                                                                                             ;           PushListPosition(  *this\_rows( ))
                                                                                                             ;           ChangeCurrentElement(  *this\_rows( ), *currentRow\address )
                                                                                                             ;           MoveElement(  *this\_rows( ), #PB_List_After, *last\currentRow\address )
                                                                                                             ;           
                                                                                                             ;           If *currentRow\childrens
                                                                                                             ;             While NextElement(  *this\_rows( )) 
                                                                                                             ;               If IsChild(  *this\_rows( ), *currentRow )
                                                                                                             ;                 MoveElement(  *this\_rows( ), #PB_List_Before, *last\currentRow\address )
                                                                                                             ;               EndIf
                                                                                                             ;             Wend
                                                                                                             ;             
                                                                                                             ;             While PreviousElement(  *this\_rows( )) 
                                                                                                             ;               If IsChild(  *this\_rows( ), *currentRow )
                                                                                                             ;                 MoveElement(  *this\_rows( ), #PB_List_After, *currentRow\address )
                                                                                                             ;               EndIf
                                                                                                             ;             Wend
                                                                                                             ;           EndIf
                                                                                                             ;           PopListPosition(  *this\_rows( ))
                                                                                                             ;         EndIf
                                                                                                             ;         
                                                                                                             ;         ;
                                                                                                             ;         If *currentRow\before\row
                                                                                                             ;           *currentRow\before\row\after\row = *currentRow\after\row
                                                                                                             ;         EndIf
                                                                                                             ;         If *currentRow\after\row
                                                                                                             ;           *currentRow\after\row\before\row = *currentRow\before\row
                                                                                                             ;         EndIf
                                                                                                             ;         If *currentRow\ParentRow( )_row( )\first\row = *currentRow
                                                                                                             ;           *currentRow\ParentRow( )_row( )\first\row = *currentRow\after\row
                                                                                                             ;         EndIf
                                                                                                             ;         If *currentRow\ParentRow( )_row( )\last\row = *currentRow
                                                                                                             ;           *currentRow\ParentRow( )_row( )\last\row = *currentRow\before\row
                                                                                                             ;         EndIf
                                                                                                             ;         
                                                                                                             ;         ;
                                                                                                             ;         If Position = #PB_List_First Or Position = #PB_List_Before
                                                                                                             ;           
                                                                                                             ;           *currentRow\after\row = *rowMoved
                                                                                                             ;           *currentRow\before\row = *rowMoved\before\row 
                                                                                                             ;           *rowMoved\before\row = *currentRow
                                                                                                             ;           
                                                                                                             ;           If *currentRow\before\row
                                                                                                             ;             *currentRow\before\row\after\row = *currentRow
                                                                                                             ;           Else
                                                                                                             ;             If *currentRow\ParentRow( )_row( )\first\row
                                                                                                             ;               *currentRow\ParentRow( )_row( )\first\row\before\row = *currentRow
                                                                                                             ;             EndIf
                                                                                                             ;             *currentRow\ParentRow( )_row( )\first\row = *currentRow
                                                                                                             ;           EndIf
                                                                                                             ;         EndIf
                                                                                                             ;         
                                                                                                             ;         If Position = #PB_List_Last Or Position = #PB_List_After
                                                                                                             ;           
                                                                                                             ;           *currentRow\before\row = *rowMoved
                                                                                                             ;           *currentRow\after\row = *rowMoved\after\row 
                                                                                                             ;           *rowMoved\after\row = *currentRow
                                                                                                             ;           
                                                                                                             ;           If *currentRow\after\row
                                                                                                             ;             *currentRow\after\row\before\row = *currentRow
                                                                                                             ;           Else
                                                                                                             ;             If *currentRow\ParentRow( )_row( )\last\row
                                                                                                             ;               *currentRow\ParentRow( )_row( )\last\row\after\row = *currentRow
                                                                                                             ;             EndIf
                                                                                                             ;             *currentRow\ParentRow( )_row( )\last\row = *currentRow
                                                                                                             ;           EndIf
                                                                                                             ;         EndIf
                                                                                                             ;         
                                                                                                             ;         ProcedureReturn #True
                                                                                                             ;       EndIf
                                                                                                             ;       
  EndProcedure
  
  Procedure.i Tree_MoveItem( *this._S_widget, position.l, sublevel.i = 0, *rowMoved._S_rows = #Null  )
    Protected *rows._S_rows, last, *last_row._S_rows, *parent_row._S_rows
     
    ;With *this
    If *this
      ;{ Генерируем идентификатор
        *rows = SelectElement( *this\_rows( ), position )
       ;sublevel = *this\_rows( )\sublevel
     
;         ; for the tree( )
;         If sublevel > *this\_rows( )\sublevel
;           PushListPosition( *this\_rows( ))
;           If PreviousElement( *this\_rows( ))
;             *this\row\added = *this\_rows( )
;             ;;NextElement( *this\_rows( ))
;           Else
;             last = *this\row\added
;             sublevel = *this\_rows( )\sublevel
;           EndIf
;           PopListPosition( *this\_rows( ))
;         Else
;           last = *this\row\added
;           sublevel = *this\_rows( )\sublevel
;         EndIf
        
        If *rowMoved
          MoveElement( *this\_rows( ), #PB_List_After, *rowMoved)
        EndIf
        ;}
        
      If *rows
        ;*rows\index = ListIndex( *this\_rows( ) )
        
        If sublevel > position
         ; sublevel = position
        EndIf
        
;         If *this\row\added 
;           If sublevel > *this\row\added\sublevel
;             sublevel = *this\row\added\sublevel + 1
;             *parent_row = *this\row\added
;             
;           ElseIf *this\row\added\ParentRow( ) 
;             If sublevel > *this\row\added\ParentRow( )\sublevel 
;               *parent_row = *this\row\added\ParentRow( )
;               
;             ElseIf sublevel < *this\row\added\sublevel 
;               If *this\row\added\ParentRow( )\ParentRow( )
;                 *parent_row = *this\row\added\ParentRow( )\ParentRow( )
;                 
;                 While *parent_row 
;                   If sublevel >= *parent_row\sublevel 
;                     If sublevel = *parent_row\sublevel 
;                       *parent_row = *parent_row\ParentRow( )
;                     EndIf
;                     Break
;                   Else
;                     *parent_row = *parent_row\ParentRow( )
;                   EndIf
;                 Wend
;               EndIf
;               
;               ; for the editor( )
;               If *this\row\added\ParentRow( ) 
;                 If *this\row\added\ParentRow( )\sublevel = sublevel 
;                   ;                     *rows\before = *this\row\added\ParentRow( )
;                   ;                     *this\row\added\ParentRow( )\after = *rows
;                   
;                   If *this\type = #__type_Editor
;                     *parent_row = *this\row\added\ParentRow( )
;                     *parent_row\last = *rows
;                     *this\row\added = *parent_row
;                     last = *parent_row
;                   EndIf
;                   
;                 EndIf
;               EndIf
;             EndIf
;           EndIf
;         EndIf
        
        If *parent_row
          *parent_row\childrens + 1
          *rows\ParentRow( ) = *parent_row
        EndIf
        
        If sublevel
         ; *rows\sublevel = sublevel
        EndIf
        
        If last
          ; *this\row\added = last
        Else
          *this\row\added = *rows
        EndIf
        
        ; for the tree( )
        If *this\row\added\ParentRow( ) And
           *this\row\added\ParentRow( )\sublevel < sublevel
          *this\row\added\ParentRow( )\last = *this\row\added
        EndIf
        
        If *this\row\added\sublevel = 0
          *this\row\last = *this\row\added
        EndIf
        
        If position = 0
          *this\row\first = *rows
        EndIf
        
        If *this\mode\collapsed And *rows\ParentRow( ) And 
           *rows\sublevel > *rows\ParentRow( )\sublevel
          ;*rows\ParentRow( )\collapsebox\___state= 1 
          *rows\state\hide = 1
        EndIf
        
        ; properties
        If *this\flag & #__tree_property
          If *parent_row And Not *parent_row\sublevel And Not *parent_row\text\fontID
            *parent_row\color\back = $FFF9F9F9
            *parent_row\color\back[1] = *parent_row\color\back
            *parent_row\color\back[2] = *parent_row\color\back
            *parent_row\color\frame = *parent_row\color\back
            *parent_row\color\frame[1] = *parent_row\color\back
            *parent_row\color\frame[2] = *parent_row\color\back
            *parent_row\color\front[1] = *parent_row\color\front
            *parent_row\color\front[2] = *parent_row\color\front
            *parent_row\text\fontID = FontID( LoadFont( #PB_Any, "Helvetica", 14, #PB_Font_Bold | #PB_Font_Italic ))
          EndIf
        EndIf
        
        ; add lines
        *rows\color = _get_colors_( )
        *rows\color\state = 0
        *rows\color\back = 0 
        *rows\color\frame = 0
        
        *rows\color\fore[0] = 0 
        *rows\color\fore[1] = 0
        *rows\color\fore[2] = 0
        *rows\color\fore[3] = 0
        
;         If Text
;           *rows\text\change = 1
;           *rows\text\string = StringField( Text.s, 1, #LF$ )
;           *rows\text\edit\string = StringField( Text.s, 2, #LF$ )
;         EndIf
        
;         set_image_( *this, *rows\Image, Image )
        
        If *this\FocusedRow( ) 
          *this\FocusedRow( )\color\state = #__S_0
          
          *this\FocusedRow( ) = *rows 
          *this\FocusedRow( )\state\focus = 1
          *this\FocusedRow( )\color\state = #__S_2 + Bool( *this\state\focus = #False )
          
          ;             PostCanvasRepaint( *this\_root( ) )
        EndIf
        
        If *this\scroll\state = #True
          *this\scroll\state =- 1
        EndIf
        *this\count\items + 1
        *this\change = 1
      EndIf
    EndIf
    ;EndWith
    
    ProcedureReturn *this\count\items - 1
  EndProcedure
  
  Procedure widget_events( )
    Protected *eventWidget._s_widget = EventWidget( )
    Select WidgetEventType( ) 
      Case #PB_EventType_DragStart
        If GetState( id_elements_tree) > 0 
          If IsContainer( *eventWidget )
            DragPrivate( #_DD_widget_new_create, #PB_Drag_Drop )
            SetCursor( *eventWidget, #PB_Cursor_Cross )
          EndIf
        Else
          If a_index( ) = #__a_moved
            DragPrivate( #_DD_widget_re_parent )
            SetCursor( *eventWidget, #PB_Cursor_Arrows )
          EndIf
        EndIf
        
      Case #PB_EventType_Drop
        If IsContainer( *eventWidget )
          If GetState( id_elements_tree) > 0 
            widget_add( *eventWidget, GetText( id_elements_tree ), 
                        EventDropX( ), EventDropY( ), EventDropWidth( ), EventDropHeight( ) )
            
            ; end new create
            SetState( id_elements_tree, 0 )
          Else
            If SetParent( PressedWidget( ), EnteredWidget( ) )
              Debug "re-parent"
              Protected *new = PressedWidget( )
              Protected *parent = EnteredWidget( )
              
              ;               ; get new add position & sublevel
              Protected i, countitems, sublevel, position, sublevel2, position2
              ;               countitems = CountItems( id_inspector_tree )
              ;               For i = 0 To countitems - 1
              ;                 Position = ( i+1 )
              ;                 
              ;                 If *parent = GetItemData( id_inspector_tree, i ) 
              ;                   SubLevel = GetItemAttribute( id_inspector_tree, i, #PB_Tree_SubLevel ) + 1
              ;                   Continue
              ;                 EndIf
              ;                 
              ;                 If SubLevel > GetItemAttribute( id_inspector_tree, i, #PB_Tree_SubLevel )
              ;                   Position = i
              ;                   Break
              ;                 EndIf
              ;               Next 
              ;               
              ;               ; set new widget data
              ;               SetData( *new, position )
              ;               
              ;               ; update new widget data item
              ;               If countitems > position
              ;                 For i = position To countitems - 1
              ;                   SetData( GetItemData( id_inspector_tree, i ), i + 1 )
              ;                 Next 
              ;               EndIf
              
              position = GetData( *new )
              SubLevel = GetItemAttribute( id_inspector_tree, Position, #PB_Tree_SubLevel )
              
              position2 = GetData( *parent )
              SubLevel2 = GetItemAttribute( id_inspector_tree, Position2, #PB_Tree_SubLevel )
              
              SubLevel = SubLevel2 + 1
              
              SetItemAttribute( id_inspector_tree, Position, #PB_Tree_SubLevel, SubLevel )
;               
;               ; position = position2 + 1
              Protected *this._s_widget = id_inspector_tree
              Protected *parent_row._S_rows = SelectElement( *this\_rows( ), position2 )
              Protected *rows._S_rows = SelectElement( *this\_rows( ), position )
              
              *rows\sublevel = SubLevel2 + 1
              If *parent_row
                ;*parent_row\childrens + 1
                If *rows\ParentRow( ) ;And *rows\ParentRow( )\sublevel >= *parent_row\sublevel
                  Debug 7777
                ;  *rows\ParentRow( )\childrens - 1
                EndIf
                *rows\ParentRow( ) = *parent_row
              EndIf
              
              MoveElement( *this\_rows( ), #PB_List_After, *parent_row)
              *this\change = 1
              
;               
;               If IsGadget( id_design_code )
;                 SetGadgetItemAttribute( id_design_code, Position, #PB_Tree_SubLevel, *rows\sublevel )
;               EndIf
              ;;Tree_MoveItem( id_inspector_tree, position, SubLevel2, *parent_row )
            EndIf
          EndIf
        EndIf
        
        
       Case #PB_EventType_StatusChange
        position = GetData( *eventWidget ) 
        ; If position = - 1 : position = 0 : EndIf ; test bug
        Debug "widget status change "+position
        SetState( id_inspector_tree, position )
        If IsGadget( id_design_code )
          SetGadgetState( id_design_code, position )
        EndIf
        ;properties_update( id_inspector_tree, *eventWidget )
        
      Case #PB_EventType_LeftButtonUp
        If ListSize(a_group( ))
          ;\\ reset all selected state
          SetState( id_inspector_tree, - 1 )
          If IsGadget( id_design_code )
            SetGadgetState( id_design_code, - 1 )
          EndIf
          
          ;\\ set selected state
          ForEach a_group( )
            SetItemState( id_inspector_tree, GetData( a_group( )\widget ), #PB_Tree_Selected )
            If IsGadget( id_design_code )
              SetGadgetItemState( id_design_code, GetData( a_group( )\widget ), #PB_Tree_Selected )
            EndIf
          Next
        EndIf
        
    EndSelect
  EndProcedure
  
  
  ;-
  Procedure ide_events( )
    Protected *this._s_widget
    Protected e_type = WidgetEvent( )\type
    Protected e_item = WidgetEvent( )\item
    Protected *eventWidget = EventWidget( )
    
    Select e_type
      Case #PB_EventType_LeftButtonDown
        
      Case #PB_EventType_DragStart
        If *eventWidget = id_elements_tree
          ClearDebugOutput()
          
          Debug "drag - "
          ;         DD_EventDragWidth( ) 
          ;         DD_EventDragHeight( )
          
          a_transform( )\type = 0
          DragPrivate( #_DD_widget_new_create, #PB_Drag_Copy);, ImageID( GetItemData( *eventWidget, GetState( *eventWidget ))))
        EndIf
        
      Case #PB_EventType_Change
        Protected q, startpos, stoppos
        If *eventWidget = id_inspector_tree
          ClearDebugOutput()
          
          *this = GetItemData( *eventWidget, GetState( *eventWidget ) )
          
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
    Define root = widget::Open( 0, x,y,width,height, "ide", flag ) 
    window_ide = widget::GetWindow( root )
    canvas_ide = widget::GetGadget( root )
    
    id_inspector_tree = Tree( 590,10,200,250, #__flag_gridlines )
    id_design_code = ListViewGadget(-1, 590,270,200,250, #PB_ListView_MultiSelect )
    ;id_design_code = TreeGadget(-1, 590,270,200,250, #PB_Tree_AlwaysShowSelection )
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
    widget_add(*window, "button", 50, 20, 120, 30)
    
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
    CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      IncludePath #path + "../ide/include/images"
    CompilerElse
      IncludePath #path + "../ide/include/images"
    CompilerEndIf
    
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
; CursorPosition = 584
; FirstLine = 580
; Folding = --------------
; EnableXP