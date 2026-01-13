#IDE_path = "../../../../"
XIncludeFile #IDE_path + "widgets.pbi" 


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  UseWidgets( )
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
  
  Procedure AddGadgetItem_(gadget, position, Text.s, imageID=0, flags=0)
    AddGadgetItem(gadget, position, Text, imageID, flags)
    
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
  
  Procedure widget_add( *parent._s_widget, Class.s, X.l,Y.l, Width.l=0, Height.l=0 )
    Protected *new._s_widget, *param1, *param2, *param3
    Protected Flag.i
    
    If *parent 
      Class.s = LCase( Trim( Class ) )
      OpenList( *parent, GetState( *parent ) ) 
      
      If Width < 5
        Width = 100
      EndIf
      If Height < 5
        Height = 100
      EndIf
      
      If Class = "scrollarea"
        *param1 = Width
        *param2 = Height
        *param3 = 5
      EndIf
      
      If  mouse( )\steps
        X = ( X/mouse( )\steps ) * mouse( )\steps
        Y = ( Y/mouse( )\steps ) * mouse( )\steps
        Width = ( Width/mouse( )\steps ) * mouse( )\steps + 1
        Height = ( Height/mouse( )\steps ) * mouse( )\steps + 1
        
        ;Debug ( a_transform( )\pos + #__window_FrameSize )
        
        If Class = "window"
          Width + ( #__window_FrameSize * 2 )%mouse( )\steps
          Height + ( #__window_FrameSize * 2 + #__window_CaptionHeight )%mouse( )\steps
        EndIf
      EndIf
      
      
      
      ; create elements
      Select Class
         Case "window"    
            *new = AddItem( *parent, #PB_Any, "", - 1, Flag )
            Resize( *new, #PB_Ignore, #PB_Ignore, Width,Height )
            SetColor( *new, #PB_Gadget_BackColor, $FFECECEC )
            SetImage( *new, CatchImage( #PB_Any,?group_bottom ) )
            Bind( *new, @widget_events( ) )
            
         Case "container"   
            *new = Container( X,Y,Width,Height, Flag )                             : CloseList( )
            SetColor( *new, #PB_Gadget_BackColor, $FFF1F1F1 )
            
         Case "button"      
            *new = Button( X,Y,Width,Height, "", Flag ) 
            
      EndSelect
      
      If *new
        If *new\container 
          EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_widget_new_create|#_DD_widget_re_parent )
        EndIf
        
        Class.s = "Form_"+GetClass( *new )
        SetText( *new, Class )
        
        
        ; get new add position & sublevel
        Protected i, sublevel, CountItems, position ;= GetData( *parent ) 
        CountItems = CountItems( id_inspector_tree )
        For i=0 To CountItems - 1
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
        If CountItems > position
          For i = position To CountItems - 1
            SetData( GetItemData( id_inspector_tree, i ), i + 1 )
          Next 
        EndIf
        
        ; get image
        Protected img =- 1
        CountItems = CountItems( id_elements_tree )
        For i = 0 To CountItems - 1
          If LCase(StringField( Class, 2, "_" )) = LCase(GetItemText( id_elements_tree, i ))
            img = GetItemData( id_elements_tree, i )
            Break
          EndIf
        Next  
        
        ; add to inspector
        AddItem( id_inspector_tree, position, Class.s, img, sublevel )
        SetItemData( id_inspector_tree, position, *new )
        ; SetItemState( id_inspector_tree, position, #PB_tree_selected )
        SetState( id_inspector_tree, position )
        If IsImage(img)
          Protected ImageID = ImageID(img)
        EndIf
        
        If IsGadget( id_design_code ) 
          AddGadgetItem_( id_design_code, position, Class.s, ImageID, SubLevel )
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
                                                                                                             ;           Case #PB_List_First  : *rowMoved = *currentRow\parent_row( )\first\row
                                                                                                             ;           Case #PB_List_Before : *rowMoved = *currentRow\before\row
                                                                                                             ;           Case #PB_List_After  : *rowMoved = *currentRow\after\row
                                                                                                             ;           Case #PB_List_Last   : *rowMoved = *currentRow\parent_row( )\_last\row
                                                                                                             ;         EndSelect
                                                                                                             ;       EndIf
                                                                                                             ;       
                                                                                                             ;       If *rowMoved And *currentRow <> *rowMoved ;And *currentRow\TabIndex( ) = *rowMoved\TabIndex( )
                                                                                                             ;         If Position = #PB_List_First Or Position = #PB_List_Before
                                                                                                             ;           
                                                                                                             ;           PushListPosition(  *this\__rows( ))
                                                                                                             ;           ChangeCurrentElement(  *this\__rows( ), *currentRow\address )
                                                                                                             ;           MoveElement(  *this\__rows( ), #PB_List_Before, *rowMoved\address )
                                                                                                             ;           
                                                                                                             ;           If *currentRow\count\childrens
                                                                                                             ;             While PreviousElement(  *this\__rows( )) 
                                                                                                             ;               If IsChild(  *this\__rows( ), *currentRow )
                                                                                                             ;                 MoveElement(  *this\__rows( ), #PB_List_After, *rowMoved\address )
                                                                                                             ;               EndIf
                                                                                                             ;             Wend
                                                                                                             ;             
                                                                                                             ;             While NextElement(  *this\__rows( )) 
                                                                                                             ;               If IsChild(  *this\__rows( ), *currentRow )
                                                                                                             ;                 MoveElement(  *this\__rows( ), #PB_List_Before, *rowMoved\address )
                                                                                                             ;               EndIf
                                                                                                             ;             Wend
                                                                                                             ;           EndIf
                                                                                                             ;           PopListPosition(  *this\__rows( ))
                                                                                                             ;         EndIf  
                                                                                                             ;         
                                                                                                             ;         If Position = #PB_List_Last Or Position = #PB_List_After
                                                                                                             ;           Protected *last._S_rows = *rowMoved\_last\row ; GetLast( *rowMoved, *rowMoved\TabIndex( )) 
                                                                                                             ;           
                                                                                                             ;           PushListPosition(  *this\__rows( ))
                                                                                                             ;           ChangeCurrentElement(  *this\__rows( ), *currentRow\address )
                                                                                                             ;           MoveElement(  *this\__rows( ), #PB_List_After, *last\currentRow\address )
                                                                                                             ;           
                                                                                                             ;           If *currentRow\count\childrens
                                                                                                             ;             While NextElement(  *this\__rows( )) 
                                                                                                             ;               If IsChild(  *this\__rows( ), *currentRow )
                                                                                                             ;                 MoveElement(  *this\__rows( ), #PB_List_Before, *last\currentRow\address )
                                                                                                             ;               EndIf
                                                                                                             ;             Wend
                                                                                                             ;             
                                                                                                             ;             While PreviousElement(  *this\__rows( )) 
                                                                                                             ;               If IsChild(  *this\__rows( ), *currentRow )
                                                                                                             ;                 MoveElement(  *this\__rows( ), #PB_List_After, *currentRow\address )
                                                                                                             ;               EndIf
                                                                                                             ;             Wend
                                                                                                             ;           EndIf
                                                                                                             ;           PopListPosition(  *this\__rows( ))
                                                                                                             ;         EndIf
                                                                                                             ;         
                                                                                                             ;         ;
                                                                                                             ;         If *currentRow\before\row
                                                                                                             ;           *currentRow\before\row\after\row = *currentRow\after\row
                                                                                                             ;         EndIf
                                                                                                             ;         If *currentRow\after\row
                                                                                                             ;           *currentRow\after\row\before\row = *currentRow\before\row
                                                                                                             ;         EndIf
                                                                                                             ;         If *currentRow\parent_row( )\first\row = *currentRow
                                                                                                             ;           *currentRow\parent_row( )\first\row = *currentRow\after\row
                                                                                                             ;         EndIf
                                                                                                             ;         If *currentRow\parent_row( )\_last\row = *currentRow
                                                                                                             ;           *currentRow\parent_row( )\_last\row = *currentRow\before\row
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
                                                                                                             ;             If *currentRow\parent_row( )\first\row
                                                                                                             ;               *currentRow\parent_row( )\first\row\before\row = *currentRow
                                                                                                             ;             EndIf
                                                                                                             ;             *currentRow\parent_row( )\first\row = *currentRow
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
                                                                                                             ;             If *currentRow\parent_row( )\_last\row
                                                                                                             ;               *currentRow\parent_row( )\_last\row\after\row = *currentRow
                                                                                                             ;             EndIf
                                                                                                             ;             *currentRow\parent_row( )\_last\row = *currentRow
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
        *rows = SelectElement( *this\__rows( ), position )
       ;sublevel = *this\__rows( )\sublevel
     
;         ; for the tree( )
;         If sublevel > *this\__rows( )\sublevel
;           PushListPosition( *this\__rows( ))
;           If PreviousElement( *this\__rows( ))
;             *this\row\new = *this\__rows( )
;             ;;NextElement( *this\__rows( ))
;           Else
;             last = *this\row\new
;             sublevel = *this\__rows( )\sublevel
;           EndIf
;           PopListPosition( *this\__rows( ))
;         Else
;           last = *this\row\new
;           sublevel = *this\__rows( )\sublevel
;         EndIf
        
        If *rowMoved
          MoveElement( *this\__rows( ), #PB_List_After, *rowMoved)
        EndIf
        ;}
        
      If *rows
        ;*rows\index = ListIndex( *this\__rows( ) )
        
        If sublevel > position
         ; sublevel = position
        EndIf
        
;         If *this\row\new 
;           If sublevel > *this\row\new\sublevel
;             sublevel = *this\row\new\sublevel + 1
;             *parent_row = *this\row\new
;             
;           ElseIf *this\row\new\RowParent( ) 
;             If sublevel > *this\row\new\RowParent( )\sublevel 
;               *parent_row = *this\row\new\RowParent( )
;               
;             ElseIf sublevel < *this\row\new\sublevel 
;               If *this\row\new\RowParent( )\RowParent( )
;                 *parent_row = *this\row\new\RowParent( )\RowParent( )
;                 
;                 While *parent_row 
;                   If sublevel >= *parent_row\sublevel 
;                     If sublevel = *parent_row\sublevel 
;                       *parent_row = *parent_row\RowParent( )
;                     EndIf
;                     Break
;                   Else
;                     *parent_row = *parent_row\RowParent( )
;                   EndIf
;                 Wend
;               EndIf
;               
;               ; for the editor( )
;               If *this\row\new\RowParent( ) 
;                 If *this\row\new\RowParent( )\sublevel = sublevel 
;                   ;                     *rows\before = *this\row\new\RowParent( )
;                   ;                     *this\row\new\RowParent( )\after = *rows
;                   
;                   If *this\type = #__type_Editor
;                     *parent_row = *this\row\new\RowParent( )
;                     *parent_row\_last = *rows
;                     *this\row\new = *parent_row
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
          *rows\RowParent( ) = *parent_row
        EndIf
        
        If sublevel
         ; *rows\sublevel = sublevel
        EndIf
        
        If last
          ; *this\row\new = last
        Else
          *this\row\new = *rows
        EndIf
        
        ; for the tree( )
        If *this\row\new\RowParent( ) And
           *this\row\new\RowParent( )\sublevel < sublevel
          *this\row\new\RowParent( )\_last = *this\row\new
        EndIf
        
        If *this\row\new\sublevel = 0
          *this\row\last = *this\row\new
        EndIf
        
        If position = 0
          *this\row\first = *rows
        EndIf
        
        If *this\mode\collapsed And *rows\RowParent( ) And 
           *rows\sublevel > *rows\RowParent( )\sublevel
          ;*rows\RowParent( )\collapsebox\___state= 1 
          *rows\hide = 1
        EndIf
        
;         ; properties
;         If *this\flag & #__flag_property
;           If *parent_row And Not *parent_row\sublevel And Not *parent_row\text\fontID
;             *parent_row\color\back = $FFF9F9F9
;             *parent_row\color\back[1] = *parent_row\color\back
;             *parent_row\color\back[2] = *parent_row\color\back
;             *parent_row\color\frame = *parent_row\color\back
;             *parent_row\color\frame[1] = *parent_row\color\back
;             *parent_row\color\frame[2] = *parent_row\color\back
;             *parent_row\color\front[1] = *parent_row\color\front
;             *parent_row\color\front[2] = *parent_row\color\front
;             *parent_row\text\fontID = FontID( LoadFont( #PB_Any, "Helvetica", 14, #PB_Font_Bold | #PB_Font_Italic ))
;           EndIf
;         EndIf
;         
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
        
        If *this\RowFocused( ) 
          *this\RowFocused( )\color\state = #__S_0
          
          *this\RowFocused( ) = *rows 
          *this\RowFocused( )\focus = 1
          *this\RowFocused( )\color\state = #__S_2 + Bool( *this\focus = #False )
          
          ;             PostCanvasRepaint( *this\_root( ) )
        EndIf
        
        If *this\row\autoscroll = #True
          *this\row\autoscroll =- 1
        EndIf
        *this\countitems + 1
        *this\change = 1
      EndIf
    EndIf
    ;EndWith
    
    ProcedureReturn *this\countitems - 1
  EndProcedure
  
  Procedure widget_events( )
    Protected EventWidget = EventWidget( )
    Select WidgetEvent( ) 
      Case #__event_DragStart
        If GetState( id_elements_tree) > 0 
          If IsContainer( EventWidget )
            DragPrivate( #_DD_widget_new_create, #PB_Drag_Copy )
          EndIf
        Else
          DragPrivate( #_DD_widget_re_parent, #PB_Drag_Copy )
        EndIf
        SetCursor(EventWidget, #PB_Cursor_Default)
        
      Case #__event_Drop
        If IsContainer( EventWidget )
          If GetState( id_elements_tree) > 0 
            widget_add( EventWidget, GetText( id_elements_tree ), 
                        DropX( ), DropY( ), DropWidth( ), DropHeight( ) )
            
            ; end new create
            SetState( id_elements_tree, 0 )
          Else
            If SetParent( Pressed( ), Entered( ) )
              Debug "re-parent"
              Protected *new = Pressed( )
              Protected *parent = Entered( )
              
              ;               ; get new add position & sublevel
              Protected i, CountItems, sublevel, position, sublevel2, position2
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
              Protected *parent_row._S_rows = SelectElement( *this\__rows( ), position2 )
              Protected *rows._S_rows = SelectElement( *this\__rows( ), position )
              
              *rows\sublevel = SubLevel2 + 1
              If *parent_row
                ; *parent_row\childrens + 1
                If *rows\RowParent( ) ;And *rows\RowParent( )\sublevel >= *parent_row\sublevel
                  Debug 7777
                  *rows\RowParent( )\childrens - 1
                EndIf
                *rows\RowParent( ) = *parent_row
              EndIf
              
              MoveElement( *this\__rows( ), #PB_List_After, *parent_row)
              *this\change = 1
              
;               
;               If IsGadget( id_design_code )
;                 SetGadgetItemAttribute( id_design_code, Position, #PB_Tree_SubLevel, *rows\sublevel )
;               EndIf
              ;;Tree_MoveItem( id_inspector_tree, position, SubLevel2, *parent_row )
            EndIf
          EndIf
        EndIf
        
        
        ;       Case #__event_LeftUp
        ;         If GetState( id_elements_tree) <> 0 
        ;           Debug ""+CanvasMouseX( )+" "+mouse( )\delta\x
        ;           widget_add( EventWidget( ), GetText( id_elements_tree ), mouse( )\delta\x-X(EventWidget( ), #PB_Gadget_ContainerCoordinate), mouse( )\delta\y-Y(EventWidget( ), #PB_Gadget_ContainerCoordinate) )
        ;            SetState( id_elements_tree, 0 )
        ;         EndIf
        
    EndSelect
  EndProcedure
  
  
  ;-
  Procedure ide_events( )
    Protected *this._s_widget
    Protected e_type = WidgetEvent( )
    Protected e_item = WidgetEventItem( )
    Protected EventWidget = EventWidget( )
    
    Select e_type
      Case #__event_LeftDown
        
      Case #__event_DragStart
        If EventWidget = id_elements_tree
          ClearDebugOutput()
          
          Debug "drag - "
          ;         DD_EventDragWidth( ) 
          ;         DD_EventDragHeight( )
          
         ; a_transform( )\type = 0
         ; DragCursor( ImageID( GetItemData( EventWidget, GetState( EventWidget ))))
          DragPrivate( #_DD_widget_new_create, #PB_Drag_Copy )
        EndIf
        
      Case #__event_Change
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
  
  Procedure ide_open( X=100,Y=100,Width=800,Height=530 )
    Define Flag = #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget
    Define Root = Widget::Open( 0, X,Y,Width,Height, "ide", Flag ) 
    window_ide = Widget::GetCanvasWindow( Root )
    canvas_ide = Widget::GetCanvasGadget( Root )
    
    id_design_form = MDI( 10,10,410,510 ) : a_init( id_design_form )
    id_elements_tree = Tree( 430,10,150,510, #__flag_NoButtons | #__flag_NoLines | #__flag_gridlines | #__flag_Borderless )
    id_inspector_tree = Tree( 590,10,200,250, #__flag_gridlines )
    id_design_code = TreeGadget(#PB_Any, 590,270,200,250 )
    
    
    :
    Bind( id_inspector_tree, @ide_events( ) )
    Bind( id_elements_tree, @ide_events( ), #__event_DragStart )
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
    IncludePath #IDE_path + "/ide/include/images"
    
    widget_delete:    : IncludeBinary "16/delete.png"
    widget_paste:     : IncludeBinary "16/paste.png"
    widget_copy:      : IncludeBinary "16/copy.png"
    widget_cut:       : IncludeBinary "16/cut.png"
    
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
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 568
; FirstLine = 525
; Folding = ------------
; EnableXP
; DPIAware