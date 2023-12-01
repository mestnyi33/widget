;- 
#IDE_path = "../"
XIncludeFile #IDE_path + "widgets.pbi"

EnableExplicit

Macro a_trans( )
  anchors 
  ;_a_\transform 
EndMacro

Uselib( WIDGET )
UsePNGImageDecoder( )

#_DD_CreateNew = 1<<1
#_DD_reParent = 1<<2
#_DD_Group = 1<<3
#_DD_CreateCopy = 1<<4

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
   #_tb_group_select = 1
   
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
       id_i_help_text

Global id_design_panel, 
       id_design_form,
       id_design_code

Global id_i_container_panel,
       id_i_view_tree, 
       id_elements_tree,
       id_i_properties_tree, 
       id_i_events_tree

Global group_select,
       group_drag

Global img = LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png" ) 

;-
;- PUBLICs
;-
Macro properties_update_id( _gadget_, _value_ )
   SetItemText( _gadget_, #_pi_id,      GetItemText( _gadget_, #_pi_id )      +Chr( 10 )+Str( _value_ ) )
EndMacro

Macro properties_update_text( _gadget_, _value_ )
   SetItemText( _gadget_, #_pi_text,    GetItemText( _gadget_, #_pi_text )    +Chr( 10 )+GetText( _value_ ) )
EndMacro

Macro properties_update_class( _gadget_, _value_ )
   SetItemText( _gadget_, #_pi_class,   GetItemText( _gadget_, #_pi_class )   +Chr( 10 )+GetClass( _value_ )+"_"+GetCount( _value_ ) )
EndMacro

Macro properties_update_hide( _gadget_, _value_ )
   SetItemText( _gadget_, #_pi_hide,    GetItemText( _gadget_, #_pi_hide )    +Chr( 10 )+Str( Hide( _value_ ) ) )
EndMacro

Macro properties_update_disable( _gadget_, _value_ )
   SetItemText( _gadget_, #_pi_disable, GetItemText( _gadget_, #_pi_disable ) +Chr( 10 )+Str( Disable( _value_ ) ) )
EndMacro

Macro properties_update_coordinate( _gadget_, _value_ )
   SetItemText( _gadget_, #_pi_x,       GetItemText( _gadget_, #_pi_x )       +Chr( 10 )+Str( X( _value_, #__c_container ) ) )
   SetItemText( _gadget_, #_pi_y,       GetItemText( _gadget_, #_pi_y )       +Chr( 10 )+Str( Y( _value_, #__c_container ) ) )
   SetItemText( _gadget_, #_pi_width,   GetItemText( _gadget_, #_pi_width )   +Chr( 10 )+Str( Width( _value_ ) ) )
   SetItemText( _gadget_, #_pi_height,  GetItemText( _gadget_, #_pi_height )  +Chr( 10 )+Str( Height( _value_ ) ) )
EndMacro

Macro properties_updates( _gadget_, _value_ )
   properties_update_id( _gadget_, _value_ )
   properties_update_class( _gadget_, _value_ )
   
   properties_update_text( _gadget_, _value_ )
   properties_update_coordinate( _gadget_, _value_ )
   
   properties_update_disable( _gadget_, _value_ )
   properties_update_hide( _gadget_, _value_ )
EndMacro


;-
Procedure.s FlagFromFlag( Type, flag.i ) ; 
   Protected flags.S
   
   Select type
      Case #__Type_Text
         If flag & #__text_center
            flags + "#PB_Text_Center | "
         EndIf
         If flag & #__text_right
            flags + "#PB_Button_Right | "
         EndIf
         ;         If flag & #__text_border
         ;           flags + "#PB_Text_Border | "
         ;         EndIf
         
      Case #__Type_Button
         If flag & #PB_Button_Left
            flags + "#PB_Button_Left | "
         EndIf
         If flag & #PB_Button_Right
            flags + "#PB_Button_Right | "
         EndIf
         If flag & #PB_Button_MultiLine
            flags + "#PB_Button_MultiLine | "
         EndIf
         If flag & #PB_Button_Toggle
            flags + "#PB_Button_Toggle | "
         EndIf
         If flag & #PB_Button_Default
            flags + "#PB_Button_Default | "
         EndIf
         
      Case #__Type_Container
         If flag & #__flag_borderless
            flags + "#PB_Container_BorderLess | "
         EndIf
         ;         If flag & #__flag_flat
         ;           flags + "#PB_Container_Border | "
         ;         EndIf
         
   EndSelect
   
   ProcedureReturn Trim( flags, "|" )
EndProcedure

Procedure$ add_line( *new._s_widget, Handle$ ) ; Ok
   Protected ID$, Result$, param1$, param2$, param3$, Text$, flag$
   
   flag$ = FlagFromFlag( *new\type, *new\flag )
   
   Select Asc( Handle$ )
      Case '#'        : ID$ = Handle$           : Handle$ = ""
      Case '0' To '9' : ID$ = Chr( Asc( Handle$ ) ) : Handle$ = ""
      Default         : ID$ = "#PB_Any"         : Handle$ + " = "
   EndSelect
   
   Text$ = Chr( 34 )+*new\text\string+Chr( 34 )
   
   If *new\class = "Window"
      Result$ = Handle$ +"Window( "+ *new\x +", "+ *new\y +", "+ *new\width +", "+ *new\height
   Else
      ; type_$ = "Gadget( "+ID$+", "
      Result$ = Handle$ + *new\class +"( "+ *new\x +", "+ *new\y +", "+ *new\width +", "+ *new\height
   EndIf
   
   Select *new\class
      Case "Window" : Result$ +", "+ Text$                                                                          
         If param1$ : Result$ +", "+ param1$ : EndIf 
         
      Case "ScrollArea"    : Result$ +", "+ param1$ +", "+ param2$    
         If param3$ : Result$ +", "+ param3$ : EndIf 
         
      Case "Calendar"      
         If param1$ : Result$ +", "+ param1$ : EndIf 
         If param1$ : Result$ +", "+ param1$ : EndIf 
         
      Case "Button"        : Result$ +", "+ Text$                                                                               
      Case "String"        : Result$ +", "+ Text$                                                                               
      Case "Text"          : Result$ +", "+ Text$                                                                                 
      Case "CheckBox"      : Result$ +", "+ Text$                                                                             
      Case "Option"        : Result$ +", "+ Text$
      Case "Frame"         : Result$ +", "+ Text$                                                                                
      Case "Web"           : Result$ +", "+ Text$
      Case "Date"          : Result$ +", "+ Text$              
      Case "ExplorerList"  : Result$ +", "+ Text$                                                                         
      Case "ExplorerTree"  : Result$ +", "+ Text$                                                                         
      Case "ExplorerCombo" : Result$ +", "+ Text$                                                                        
         
      Case "HyperLink"     : Result$ +", "+ Text$ +", "+ param1$                                                       
      Case "ListIcon"      : Result$ +", "+ Text$ +", "+ param1$                                                        
         
      Case "Image"         : Result$ +", "+ param1$   
      Case "Scintilla"     : Result$ +", "+ param1$
      Case "Shortcut"      : Result$ +", "+ param1$
      Case "ButtonImage"   : Result$ +", "+ param1$                                                                                             
         
      Case "TrackBar"      : Result$ +", "+ param1$ +", "+ param2$                                                                         
      Case "Spin"          : Result$ +", "+ param1$ +", "+ param2$                                                                             
      Case "Splitter"      : Result$ +", "+ param1$ +", "+ param2$                                                                         
      Case "MDI"           : Result$ +", "+ param1$ +", "+ param2$                                                                              
      Case "ProgressBar"   : Result$ +", "+ param1$ +", "+ param2$                                                                      
      Case "ScrollBar"     : Result$ +", "+ param1$ +", "+ param2$ +", "+ param3$                                                 
   EndSelect
   
   If flag$ : Result$ +", "+ flag$ : EndIf 
   
   Result$+" )" 
   
   ProcedureReturn Result$
EndProcedure

Procedure add_code( *new._s_widget, Class.s, Position.i, SubLevel.i )
   Protected code.s 
   
   ;   code = Space( ( *new\level-2 )*4 ) +
   ;          Class +" = "+ 
   ;          *new\class +"( " + 
   ;          *new\x +", "+
   ;          *new\y +", "+ 
   ;          *new\width +", "+ 
   ;          *new\height +", "+ 
   ;          *new\text\string +", "+ 
   ;          FlagFromFlag( *new\type, *new\flag )+
   ;          " )"
   
   code = Space( ( *new\level-2 )*4 ) + add_line( *new._s_widget, Class.s )
   
   ;   ForEach widget( )
   ;     If Child( widget( ), id_design_form )
   ;       Debug widget( )\class
   ;     EndIf
   ;   Next
   
   If IsGadget( listview_debug )
      AddGadgetItem( listview_debug, Position, code )
   Else
      AddItem( listview_debug, Position, code )
   EndIf
EndProcedure


;-
Declare widget_events( )

;-
Macro widget_copy( )
   ClearList( *copy( ) )
   
   If a_focused( )\a_trans( )
      AddElement( *copy( ) ) 
      *copy.allocate( A_GROUP, ( ) )
      *copy( )\widget = a_focused( )
   Else
      ;       ForEach a_group( )
      ;         AddElement( *copy( ) ) 
      ;         *copy.allocate( GROUP, ( ) )
      ;         *copy( )\widget = a_group( )\widget
      ;       Next
      
      CopyList( a_group( ), *copy( ) )
      
   EndIf
   
   a_selector( )\x = a_transform( )\grid_size
   a_selector( )\y = a_transform( )\grid_size
EndMacro

Macro widget_delete( )
   If a_focused( )\a_trans( )
      RemoveItem( id_i_view_tree, GetData( a_focused( ) ) )
      
      Free( a_focused( ) )
      
      a_Set( GetItemData( id_i_view_tree, GetState( id_i_view_tree ) ) )
   Else
      ForEach a_group( )
         RemoveItem( id_i_view_tree, GetData( a_group( )\widget ) )
         Free( a_group( )\widget )
         DeleteElement( a_group( ) )
      Next
      
      ClearList( a_group( ) )
   EndIf
EndMacro

Macro widget_paste( )
   If ListSize( *copy( ) )
      ForEach *copy( )
         widget_add( *copy( )\widget\parent, 
                     *copy( )\widget\class, 
                     *copy( )\widget\x[#__c_container] + ( a_selector( )\x ),; -*copy( )\widget\parent\x[#__c_inner] ),
                     *copy( )\widget\y[#__c_container] + ( a_selector( )\y ),; -*copy( )\widget\parent\y[#__c_inner] ), 
                     *copy( )\widget\width[#__c_frame],
                     *copy( )\widget\height[#__c_frame] )
      Next
      
      a_selector( )\x + a_transform( )\grid_size
      a_selector( )\y + a_transform( )\grid_size
      
      ClearList( a_group( ) )
      CopyList( *copy( ), a_group( ) )
   EndIf
   
   ForEach a_group( )
      Debug " group "+a_group( )\widget
   Next
   
   ;a_update( a_focused( ) )
EndMacro

Procedure widget_add( *parent._s_widget, class.s, x.l,y.l, width.l=#PB_Ignore, height.l=#PB_Ignore )
   Protected *new._s_widget, *param1, *param2, *param3
   Protected flag.i
   
   If *parent 
      OpenList( *parent, GetState( *parent ) ) 
      class.s = LCase( Trim( class ) )
      
      ; defaul width&height
      If class = "scrollarea" Or
         class = "container" Or
         class = "panel"
         
         If width = #PB_Ignore
            width = 200
         EndIf
         If height = #PB_Ignore
            height = 150
         EndIf
         
         If class = "scrollarea"
            *param1 = width
            *param2 = height
            *param3 = 5
         EndIf
         
      Else
         If width = #PB_Ignore
            width = 100
         EndIf
         If height = #PB_Ignore
            height = 30
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
               *new = Window( x,y,width,height, "", flag, *parent )
            EndIf
            
            SetColor( *new, #__color_back, $FFECECEC )
            SetImage( *new, CatchImage( #PB_Any,?group_bottom ) )
            Bind( *new, @widget_events( ) )
            a_set(*new, #__a_full, 14)
            
         Case "container"   
            *new = Container( x,y,width,height, flag ) : CloseList( )
            SetColor( *new, #__color_back, $FFF1F1F1 )
            a_set(*new, #__a_full, 10)
            
         Case "panel"       : *new = Panel( x,y,width,height, flag ) : AddItem( *new, -1, class+"_0" ) : CloseList( )
         Case "scrollarea"  
            *new = ScrollArea( x,y,width,height, *param1, *param2, *param3, flag ) : CloseList( )
            a_set(*new, #__a_full, 10)
         
         Case "splitter"    : *new = Splitter( x,y,width,height, *param1, *param2, flag )
         Case "image"       : *new = Image( x,y,width,height, img, flag )
         Case "buttonimage" : *new = ButtonImage( x,y,width,height, img, flag )
         Case "progress"    : *new = Progress( x,y,width,height, 0,100, flag ) 
         Case "button"      : *new = Button( x,y,width,height, "", flag ) 
         Case "string"      : *new = String( x,y,width,height, "", flag )
         Case "text"        : *new = Text( x,y,width,height, "", flag )
      EndSelect
      
      If *new
         Protected newClass.s
         newClass.s = GetClass( *new )+"_"+GetCount( *new , 0 )
         ;newClass.s = GetClass( *parent )+"_"+GetCount( *parent , 0 )+"_"+GetClass( *new )+"_"+GetCount( *new , 1 )
         
         If *new\container 
            EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateNew|#_DD_reParent|#_DD_CreateCopy|#_DD_Group )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateNew )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_reParent )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateCopy )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_Group )
         EndIf
         
         ;
         SetText( *new, newClass )
         
         ; get new add position & sublevel
         Protected i, countitems, sublevel, position = GetData( *parent ) 
         countitems = CountItems( id_i_view_tree )
         For i = 0 To countitems - 1
            Position = ( i+1 )
            
            If *parent = GetItemData( id_i_view_tree, i ) 
               SubLevel = GetItemAttribute( id_i_view_tree, i, #PB_Tree_SubLevel ) + 1
               Continue
            EndIf
            
            If SubLevel > GetItemAttribute( id_i_view_tree, i, #PB_Tree_SubLevel )
               Position = i
               Break
            EndIf
         Next 
         
         ; set new widget data
         SetData( *new, position )
         
         ; update new widget data item
         If countitems > position
            For i = position To countitems - 1
               SetData( GetItemData( id_i_view_tree, i ), i + 1 )
            Next 
         EndIf
         
         ; get image associated with class
         Protected img =- 1
         countitems = CountItems( id_elements_tree )
         For i = 0 To countitems - 1
            If LCase(StringField( newClass.s, 1, "_" )) = LCase(GetItemText( id_elements_tree, i ))
               img = GetItemData( id_elements_tree, i )
               Break
            EndIf
         Next  
         
         ; add to inspector
         AddItem( id_i_view_tree, position, newClass.s, img, sublevel )
         SetItemData( id_i_view_tree, position, *new )
         ; SetItemState( id_i_view_tree, position, #PB_tree_selected )
         
         ; Debug " "+position
         SetState( id_i_view_tree, position )
         
         If IsGadget( id_design_code )
            AddGadgetItem( id_design_code, position, newClass.s, ImageID(img), SubLevel )
            SetGadgetItemData( id_design_code, position, *new )
            ; SetGadgetItemState( id_design_code, position, #PB_tree_selected )
            SetGadgetState( id_design_code, position ) ; Bug
         EndIf
         
         ; Debug  " pos "+position + "   ( debug >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" ) )"
         add_code( *new, newClass.s, position, sublevel )
         
      EndIf
      
      CloseList( ) 
   EndIf
   
   ProcedureReturn *new
EndProcedure

Procedure widget_events( )
   Protected eventtype = WidgetEvent( )\type 
   Protected *new, *ew._s_widget = WidgetEvent( )\widget
;    Static *beforeWidget
   
   Select eventtype 
      Case #__event_DragStart
         If a_index( ) = #__a_moved
            If DragPrivate( #_DD_reParent )
               ChangeCursor( *ew, #PB_Cursor_Arrows )
            EndIf
         EndIf
         
         If GetState( id_elements_tree) > 0 
            If IsContainer( *ew )
               If DragPrivate( #_DD_CreateNew, #PB_Drag_Drop )
                  ChangeCursor( *ew, #PB_Cursor_Cross )
               EndIf
            EndIf
         EndIf
         
      Case #__event_Drop
         Select EventDropPrivate( )
            Case #_DD_Group
               Debug " ----- DD_group ----- "
               
            Case #_DD_reParent
               Debug " ----- DD_move ----- "
               If SetParent( PressedWidget( ), EnteredWidget( ) )
                  Protected i = 3 : Debug "re-parent "+ PressedWidget( )\parent\class +" "+ PressedWidget( )\x[i] +" "+ PressedWidget( )\y[i] +" "+ PressedWidget( )\width[i] +" "+ PressedWidget( )\height[i]
               EndIf
               
            Case #_DD_CreateNew 
               Debug " ----- DD_new ----- "+ GetText( id_elements_tree ) +" "+ EventDropX( ) +" "+ EventDropY( ) +" "+ EventDropWidth( ) +" "+ EventDropHeight( )
               widget_add( *ew, GetText( id_elements_tree ), 
                           EventDropX( ), EventDropY( ), EventDropWidth( ), EventDropHeight( ) )
               
            Case #_DD_CreateCopy
               Debug " ----- DD_copy ----- " + GetText( PressedWidget( ) )
               
               ;            *new = widget_add( *ew, GetClass( PressedWidget( ) ), 
               ;                         X( PressedWidget( ) ), Y( PressedWidget( ) ), Width( PressedWidget( ) ), Height( PressedWidget( ) ) )
               
               *new = widget_add( *ew, EventDropText( ), 
                                  EventDropX( ), EventDropY( ), EventDropWidth( ), EventDropHeight( ) )
               SetText( *new, "Copy_"+EventDropText( ) )
               
         EndSelect
         
      Case #__event_LeftButtonDown
         If IsContainer( *ew )
            If a_transform( )\type > 0 Or group_select
               If group_select 
                  group_drag = *ew
               EndIf
            EndIf
            
            ;           If a_focused( )\transform <> 1
            ;             ForEach a_group( )
            ;               SetItemState( id_i_view_tree, GetData( a_group( )\widget ), 0 )
            ;             Next
            ;           EndIf
         EndIf
         ;; ProcedureReturn #PB_Ignore
         
      Case #__event_LeftButtonUp
         ; then group select
         If IsContainer( *ew )
            If a_transform( ) And a_focused( ) And a_focused( )\a_trans( ) = - 1
               SetState( id_i_view_tree, - 1 )
               If IsGadget( id_design_code )
                  SetGadgetState( id_design_code, - 1 )
               EndIf
               
               ForEach a_group( )
                  SetItemState( id_i_view_tree, GetData( a_group( )\widget ), #PB_Tree_Selected )
                  If IsGadget( id_design_code )
                     SetGadgetItemState( id_design_code, GetData( a_group( )\widget ), #PB_Tree_Selected )
                  EndIf
               Next
            EndIf
         EndIf
         
      Case #__event_StatusChange
         ;\\ Debug " widget status change "
         If GetData( *ew ) >= 0
            If IsGadget( id_design_code )
               SetGadgetState( id_design_code, GetData( *ew ) )
            EndIf
            SetState( id_i_view_tree, GetData( *ew ) )
         EndIf
         properties_updates( id_i_properties_tree, *ew )
         
      Case #__event_Resize
         properties_update_coordinate( id_i_properties_tree, *ew )
         SetWindowTitle( GetWindow(*ew\root), Str(width(*ew))+"x"+Str(height(*ew) ) )
         
      Case #__event_MouseEnter,
           #__event_MouseLeave,
           #__event_MouseMove
         
         If Not MouseButtons( ) 
            If IsContainer( *ew ) 
               If GetState( id_elements_tree ) > 0 
                  If eventtype = #__event_MouseLeave
                     If GetCursor( ) <> #PB_Cursor_Default
                        ChangeCursor( *ew, #PB_Cursor_Default )
                     EndIf
                  Else
                     If *ew\state\enter = 2 
                        If GetCursor( ) <> #PB_Cursor_Cross
                           ChangeCursor( *ew, #PB_Cursor_Cross )
                        EndIf
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
   EndSelect
   
   ;\\
   If eventtype = #__event_Drop Or 
      eventtype = #__event_LeftButtonUp Or 
      eventtype = #__event_RightButtonUp 
      
      ; end new create
      If GetState( id_elements_tree ) > 0 
         SetState( id_elements_tree, 0 )
         a_transform( )\type = 0
         ChangeCursor( *ew, #PB_Cursor_Default )
      EndIf
   EndIf
EndProcedure



;-
Macro ToolBar( parent, flag = #PB_ToolBar_Small )
   Container( 0,0,0,0 ) 
EndMacro

Macro ToolBarButton( _button_, _image_, _mode_=0, _text_="" )
   ButtonImage(( ( widget( )\x+widget( )\width ) ), 5,30,30,_image_, _mode_ )
   ;widget( )\color = widget( )\parent\color
   widget( )\class = "ToolBar"
   widget( )\data = _button_
   
   Bind( widget( ), @ide_events( ) )
EndMacro

Macro Separator( )
   Text( widget( )\x+widget( )\width, 5,1,30,"" )
   Button( widget( )\x+widget( )\width, 5+3,1,30-6,"" )
   ; SetData( widget( ), - MacroExpandedCount )
   Text( widget( )\x+widget( )\width, 5,1,30,"" )
EndMacro


;-
Procedure.i ide_add_image_list( *id, Directory$ )
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

Procedure ide_events( )
   Protected *this._s_widget
   Protected e_type = WidgetEvent( )\type
   Protected e_item = WidgetEvent( )\item
   Protected *ew._s_widget = WidgetEvent( )\widget
   
   Select e_type
      Case #__event_Close
         If #PB_MessageRequester_Yes = MessageRequester( "Message", "Are you sure you want to go out?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
            ;CloseWindow( EventWindow( ) )
            ProcedureReturn 0
         Else
            ProcedureReturn 1
         EndIf
         
      Case #__event_DragStart
         If *ew = id_elements_tree
            a_transform( )\type = 0
            
            Debug " ------ drag ide_events() ----- "
            If DragPrivate( #_DD_CreateNew, #PB_Drag_Copy )
               ChangeCursor( *ew, Cursor::Create( ImageID( GetItemData( *ew, GetState( *ew ) ) ) ) )
            EndIf
         EndIf
         
      Case #__event_StatusChange
         If *ew = listview_debug
            
            ; Debug Left( *ew\text\string, *ew\text\caret\pos ); GetState( listview_debug )
         EndIf
         
         If e_item = - 1
            ;SetText( id_i_help_text, GetItemText( *ew, GetState( *ew ) ) )
         Else
            If *ew = id_i_view_tree
               SetText( id_i_help_text, GetItemText( *ew, e_item ) )
               
               ;\\ TEMP change visible
               *this._s_widget = *ew
               If *this\FocusedRow( ) 
                  If *this\FocusedRow( )\color\state <> 3
                     *this\FocusedRow( )\color\back[*this\FocusedRow( )\color\state] = *this\color\back[*this\FocusedRow( )\color\state] ; $FFF5702C ; TEMP
                  EndIf
               EndIf
               ;             If *this\EnteredRow( )
               ;               If *this\EnteredRow( )\color\state <> 3
               ;                 *this\EnteredRow( )\color\back[*this\EnteredRow( )\color\state] = $FF70F52C ; TEMP
               ;                 *this\EnteredRow( )\color\front[*this\EnteredRow( )\color\state] = $FFffffff ; TEMP
               ;               EndIf
               ;             EndIf
               
            EndIf
            
            If *ew = id_elements_tree
               SetText( id_i_help_text, GetItemText( *ew, e_item ) )
            EndIf
         EndIf
         
      Case #__event_Change
         If *ew = id_i_view_tree
            *this = GetItemData( *ew, GetState( *ew ) )
            If a_set( *this )
               
             ;;SetActive( a_focused( ) )
            EndIf
         EndIf
         
         If *ew = id_elements_tree
            a_transform( )\type = GetState( *ew )
         EndIf
         
         If *ew = listview_debug
            Protected q, startpos, stoppos
            Protected x = #PB_Ignore, y = #PB_Ignore
            Protected width = #PB_Ignore, height = #PB_Ignore
            
            Protected findstring.s = Left( *ew\text\string, *ew\text\caret\pos )
            Protected countstring = CountString( findstring, "," )
            
            Select countstring
               Case 0, 1, 2, 3, 4
                  For q = *ew\text\edit[1]\len To *ew\text\edit[1]\pos Step - 1
                     If Mid( *ew\text\string, q, 1 ) = "(" Or 
                        Mid( *ew\text\string, q, 1 ) = ~"\"" Or
                        Mid( *ew\text\string, q, 1 ) = ","
                        startpos = q + 1
                        Break
                     EndIf
                  Next q
                  
                  For q = *ew\text\edit[3]\pos To ( *ew\text\edit[3]\pos + *ew\text\edit[3]\len )
                     If Mid( *ew\text\string, q, 1 ) = "," Or
                        Mid( *ew\text\string, q, 1 ) = ~"\"" Or
                        Mid( *ew\text\string, q, 1 ) = ")"
                        stoppos = q
                        Break
                     EndIf
                  Next q
                  
                  If stoppos And stoppos - startpos
                     findstring = Mid( *ew\text\string, startpos, stoppos - startpos )
                     
                     If countstring = 4
                        SetText( a_focused( ), findstring )
                     Else
                        If countstring = 0
                           x = Val( findstring )
                        ElseIf countstring = 1
                           y = Val( findstring )
                        ElseIf countstring = 2
                           width = Val( findstring )
                        ElseIf countstring = 3
                           height = Val( findstring )
                        EndIf
                        
                        Resize( a_focused( ), x, y, width, height)
                     EndIf
                     
                  EndIf
            EndSelect
            
            ; Debug Left( *ew\text\string, *ew\text\caret\pos ); GetState( listview_debug )
         EndIf
         
      Case #__event_LeftClick
         If getclass( *ew ) = "ToolBar"
            Protected transform, move_x, move_y, toolbarbutton = GetData( *ew )
            Static NewList *copy._s_a_group( )
            
            
            Select toolbarbutton
               Case 1
                  If Getstate( *ew )  
                     ; group
                     group_select = *ew
                     ; SetAtributte( *ew, #PB_Button_PressedImage )
                  Else
                     ; un group
                     group_select = 0
                  EndIf
                  
                  ForEach a_group( )
                     Debug a_group( )\widget\x
                     
                  Next
                  
                  
               Case #_tb_widget_copy
                  widget_copy( )
                  
               Case #_tb_widget_cut
                  widget_copy( )
                  widget_delete( )
                  
               Case #_tb_widget_paste
                  widget_paste( )
                  
               Case #_tb_widget_delete
                  widget_delete( )
                  
                  
               Case #_tb_group_left,
                    #_tb_group_right, 
                    #_tb_group_top, 
                    #_tb_group_bottom, 
                    #_tb_group_width, 
                    #_tb_group_height
                  
                  ;\\ toolbar buttons events
                  move_x = a_selector( )\x - a_focused( )\x[#__c_inner]
                  move_y = a_selector( )\y - a_focused( )\y[#__c_inner]
                  
                  ForEach a_group( )
                     Select toolbarbutton
                        Case #_tb_group_left ; left
                                             ;a_selector( )\x = 0
                           a_selector( )\width = 0
                           Resize( a_group( )\widget, move_x, #PB_Ignore, #PB_Ignore, #PB_Ignore )
                           
                        Case #_tb_group_right ; right
                           a_selector( )\x = 0
                           a_selector( )\width = 0
                           Resize( a_group( )\widget, move_x + a_group( )\width, #PB_Ignore, #PB_Ignore, #PB_Ignore )
                           
                        Case #_tb_group_top ; top
                                            ;a_selector( )\y = 0
                           a_selector( )\height = 0
                           Resize( a_group( )\widget, #PB_Ignore, move_y, #PB_Ignore, #PB_Ignore )
                           
                        Case #_tb_group_bottom ; bottom
                           a_selector( )\y = 0
                           a_selector( )\height = 0
                           Resize( a_group( )\widget, #PB_Ignore, move_y + a_group( )\height, #PB_Ignore, #PB_Ignore )
                           
                        Case #_tb_group_width ; stretch horizontal
                           Resize( a_group( )\widget, #PB_Ignore, #PB_Ignore, a_selector( )\width, #PB_Ignore )
                           
                        Case #_tb_group_height ; stretch vertical
                           Resize( a_group( )\widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, a_selector( )\height )
                           
                     EndSelect
                  Next
                  
                  a_update( a_focused( ) )
                  
                  ;Redraw( Root() )
            EndSelect
         EndIf
         
   EndSelect
EndProcedure

Procedure ide_open( x=100,y=100,width=800,height=600 )
   ;     OpenWindow( #PB_Any, 0,0,332,232, "" )
   ;     id_design_code = TreeGadget( -1,1,1,330,230 ) 
   
   Define flag = #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget
   Define root = widget::Open( 1, x,y,width,height, "ide", flag ) 
   window_ide = widget::GetWindow( root )
   canvas_ide = widget::GetGadget( root )
   
;    Debug "create window - "+WindowID(window_ide)
;    Debug "create canvas - "+GadgetID(canvas_ide)
   
   toolbar_design = ToolBar( toolbar_design )
   group_select = ToolBarButton( #_tb_group_select, - 1, #PB_Button_Toggle )
   SetAttribute( widget( ), #PB_Button_Image, CatchImage( #PB_Any,?group_un ) )
   SetAttribute( widget( ), #PB_Button_PressedImage, CatchImage( #PB_Any,?group ) )
   Separator( )
   ToolBarButton( #_tb_group_left, CatchImage( #PB_Any,?group_left ) )
   ToolBarButton( #_tb_group_right, CatchImage( #PB_Any,?group_right ) )
   Separator( )
   ToolBarButton( #_tb_group_top, CatchImage( #PB_Any,?group_top ) )
   ToolBarButton( #_tb_group_bottom, CatchImage( #PB_Any,?group_bottom ) )
   Separator( )
   ToolBarButton( #_tb_group_width, CatchImage( #PB_Any,?group_width ) )
   ToolBarButton( #_tb_group_height, CatchImage( #PB_Any,?group_height ) )
   
   Separator( )
   ToolBarButton( #_tb_widget_copy, CatchImage( #PB_Any,?widget_copy ) )
   ToolBarButton( #_tb_widget_paste, CatchImage( #PB_Any,?widget_paste ) )
   ToolBarButton( #_tb_widget_cut, CatchImage( #PB_Any,?widget_cut ) )
   ToolBarButton( #_tb_widget_delete, CatchImage( #PB_Any,?widget_delete ) )
   Separator( )
   ToolBarButton( #_tb_align_left, CatchImage( #PB_Any,?group_left ) )
   ToolBarButton( #_tb_align_top, CatchImage( #PB_Any,?group_top ) )
   ToolBarButton( #_tb_align_center, CatchImage( #PB_Any,?group_width ) )
   ToolBarButton( #_tb_align_bottom, CatchImage( #PB_Any,?group_bottom ) )
   ToolBarButton( #_tb_align_right, CatchImage( #PB_Any,?group_right ) )
   CloseList( )
   
   ; gadgets
   
   ;\\\ 
   id_design_panel = Panel( 0,0,0,0 ) ; , #__bar_vertical ) : OpenList( id_design_panel )
   AddItem( id_design_panel, -1, "Form" )
   id_design_form = MDI( 0,0,0,0, #__flag_autosize|#__mdi_editable ) 
   ;a_init( id_design_form, 0 )
   
   ;AddItem( id_design_panel, -1, "Code" )
   ;id_design_code = Editor( 0,0,0,0 ) ; bug then move anchors window
   CloseList( )
   
   ;
   listview_debug = Editor( 0,0,0,0 ) ; ListView( 0,0,0,0 ) 
   
   
   ;\\\ open inspector gadgets 
   id_i_view_tree = Tree( 0,0,0,0 ) ;, #__flag_gridlines )
   EnableDrop( id_i_view_tree, #PB_Drop_Text, #PB_Drag_Link )
   
   ; id_inspector_panel_open
   id_i_container_panel = Panel( 0,0,0,0 )
   
   ; id_inspector_panel_item_1
   AddItem( id_i_container_panel, -1, "elements", 0, 0 ) 
   id_elements_tree = Tree( 0,0,0,0, #__flag_autosize | #__flag_NoButtons | #__flag_NoLines | #__flag_borderless )
   If id_elements_tree
      ide_add_image_list( id_elements_tree, GetCurrentDirectory( )+"Themes/" )
   EndIf
   
   ; id_inspector_panel_item_2 
   AddItem( id_i_container_panel, -1, "properties", 0, 0 )  
   id_i_properties_tree = Tree_properties( 0,0,0,0, #__flag_autosize | #__flag_gridlines | #__flag_borderless )
   If id_i_properties_tree
      AddItem( id_i_properties_tree, #_pi_group_0,  "Common" )
      AddItem( id_i_properties_tree, #_pi_id,       "ID"      , #__Type_String, 1 )
      AddItem( id_i_properties_tree, #_pi_class,    "Class"   , #__Type_String, 1 )
      AddItem( id_i_properties_tree, #_pi_text,     "Text"    , #__Type_String, 1 )
      
      AddItem( id_i_properties_tree, #_pi_group_1,  "Layout" )
      AddItem( id_i_properties_tree, #_pi_x,        "x"       , #__Type_Spin, 1 )
      AddItem( id_i_properties_tree, #_pi_y,        "Y"       , #__Type_Spin, 1 )
      AddItem( id_i_properties_tree, #_pi_width,    "Width"   , #__Type_Spin, 1 )
      AddItem( id_i_properties_tree, #_pi_height,   "Height"  , #__Type_Spin, 1 )
      
      AddItem( id_i_properties_tree, #_pi_group_2,  "State" )
      AddItem( id_i_properties_tree, #_pi_disable,  "Disable" , #__Type_ComboBox, 1 )
      AddItem( id_i_properties_tree, #_pi_hide,     "Hide"    , #__Type_ComboBox, 1 )
   EndIf
   
   ; id_inspector_panel_item_3 
   AddItem( id_i_container_panel, -1, "events", 0, 0 )  
   id_i_events_tree = Tree_properties( 0,0,0,0, #__flag_autosize | #__flag_borderless ) 
   If id_i_events_tree
      AddItem( id_i_events_tree, #_ei_leftclick,  "LeftClick" )
      AddItem( id_i_events_tree, #_ei_change,  "Change" )
      AddItem( id_i_events_tree, #_ei_enter,  "Enter" )
      AddItem( id_i_events_tree, #_ei_leave,  "Leave" )
   EndIf
   
   ; id_inspector_panel_close
   CloseList( )
   
   ; id_inspector_help_text
   id_i_help_text  = Text( 0,0,0,0, "help for the inspector", #PB_Text_Border )
   ;\\\ close inspector gadgets 
   
   ;
   ;\\\ ide splitters
   ;
   Splitter_design = widget::Splitter( 0,0,0,0, toolbar_design,id_design_panel, #PB_Splitter_FirstFixed | #PB_Splitter_Separator )
   Splitter_inspector = widget::Splitter( 0,0,0,0, id_i_view_tree,id_i_container_panel, #PB_Splitter_FirstFixed )
   splitter_debug = widget::Splitter( 0,0,0,0, Splitter_design,listview_debug, #PB_Splitter_SecondFixed )
   splitter_help = widget::Splitter( 0,0,0,0, Splitter_inspector,id_i_help_text, #PB_Splitter_SecondFixed )
   Splitter_ide = widget::Splitter( 0,0,0,0, splitter_debug,splitter_help, #__flag_autosize | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed )
   
   ; set splitters default minimum size
   widget::SetAttribute( Splitter_ide, #PB_Splitter_FirstMinimumSize, 500 )
   widget::SetAttribute( Splitter_ide, #PB_Splitter_SecondMinimumSize, 120 )
   widget::SetAttribute( splitter_help, #PB_Splitter_SecondMinimumSize, 30 )
   widget::SetAttribute( splitter_debug, #PB_Splitter_FirstMinimumSize, 300 )
   widget::SetAttribute( splitter_debug, #PB_Splitter_SecondMinimumSize, 100 )
   widget::SetAttribute( Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100 )
   widget::SetAttribute( Splitter_design, #PB_Splitter_FirstMinimumSize, 20 )
   widget::SetAttribute( Splitter_design, #PB_Splitter_SecondMinimumSize, 200 )
   ; widget::SetAttribute( Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff )
   
   ; set splitters dafault positions
   widget::SetState( Splitter_ide, widget::width( Splitter_ide )-220 )
   widget::SetState( splitter_help, widget::height( splitter_help )-80 )
   widget::SetState( splitter_debug, widget::height( splitter_debug )-200 )
   widget::SetState( Splitter_inspector, 230 )
   widget::SetState( Splitter_design, 42 )
   
   ;
   ;\\\ ide events binds
   ;
   Bind( id_i_view_tree, @ide_events( ) )
   
   Bind( listview_debug, @ide_events( ), #__event_Change )
   Bind( listview_debug, @ide_events( ), #__event_StatusChange )
   
   ;Bind( id_elements_tree, @ide_events( ) )
   Bind( id_elements_tree, @ide_events( ), #__event_LeftClick )
   Bind( id_elements_tree, @ide_events( ), #__event_Change )
   Bind( id_elements_tree, @ide_events( ), #__event_StatusChange )
   Bind( id_elements_tree, @ide_events( ), #__event_DragStart )
   
   Bind( id_elements_tree, @ide_events( ), #__event_MouseEnter )
   Bind( id_elements_tree, @ide_events( ), #__event_MouseLeave )
   
   
   Bind( root, @ide_events( ), #__event_Close )
   ProcedureReturn window_ide
EndProcedure

;-
CompilerIf #PB_Compiler_IsMainFile 
   Define event
   ide_open( )
   
   
   ;     ; example 1
   ;     ;   ;OpenList( id_design_form )
   ;     Define *window = widget_add( id_design_form, "window", 10, 10, 350, 200 )
   ;         Define *container = widget_add( *window, "container", 130, 20, 220, 140 )
   ;         widget_add( *container, "button", 10, 20, 30, 30 )
   ;         widget_add( *window, "button", 10, 20, 100, 30 )
   ;         
   ;         Define item = 1
   ;         SetState( id_i_view_tree, item )
   ;         If IsGadget( id_design_code )
   ;           SetGadgetState( id_design_code, item )
   ;         EndIf
   ;         Define *container2 = widget_add( *container, "container", 60, 10, 220, 140 )
   ;         widget_add( *container2, "button", 10, 20, 30, 30 )
   ;         
   ;         SetState( id_i_view_tree, 0 )
   ;         widget_add( *window, "button", 10, 130, 100, 30 )
   ;         
   ; ; ;         ;   Define *window = widget_add( id_design_form, "window", 10, 10 )
   ; ; ;         ;   Define *container = widget_add( *window, "container", 80, 10 )
   ; ; ;         ;   widget_add( *container, "button", -10, 20 )
   ; ; ;         ;   widget_add( *window, "button", 10, 20 )
   ; ; ;         ;   ;CloseList( )
   ; ; ;         
   ;             ; example 2
   ;             ;   ;OpenList( id_design_form )
   ;             SetState( group_select, 1 ) 
   ;             
   ;             Define *window = widget_add( id_design_form, "window", 30, 30, 400, 250 )
   ;             widget_add( *window, "button", 15, 25, 50, 30 )
   ;             widget_add( *window, "text", 25, 65, 50, 30 )
   ;             widget_add( *window, "button", 35, 65+40, 50, 30 )
   ;             widget_add( *window, "text", 45, 65+40*2, 50, 30 )
   ;             
   ;             ;Define *container = widget_add( *window, "container", 100, 25, 265, 170 )
   ;             Define *container = widget_add( *window, "scrollarea", 100, 25, 265, 170 )
   ;             widget_add( *container, "progress", 15, 25, 30, 30 )
   ;             widget_add( *container, "text", 25, 65, 50, 30 )
   ;             widget_add( *container, "button", 35, 65+40, 80, 30 )
   ;             widget_add( *container, "text", 45, 65+40*2, 50, 30 )
   ;             
   ;             Define *container2 = widget_add( *window, "container", 100+140, 25+45, 165, 140 )
   ;             widget_add( *container2, "buttonimage", 75, 25, 30, 30 )
   ;             widget_add( *container2, "text", 45, 65+40*2, 50, 30 )
   ;             widget_add( *container2, "string", 25, 65, 100, 30 )
   ;             widget_add( *container2, "button", 100+15, 65+40, 80, 30 )
   
   
   
   ; example 3
   ;   ;OpenList(id_design_form)
   SetState(group_select, 1) 
   
   Define *window = widget_add(id_design_form, "window", 30, 30, 400, 250)
   widget_add(*window, "button", 15, 25, 50, 30)
   widget_add(*window, "text", 25, 65, 50, 30)
   widget_add(*window, "button", 35, 65+40, 50, 30)
   widget_add(*window, "text", 45, 65+40*2, 50, 30)
   
   ;Define *container = widget_add(*window, "container", 100, 25, 265, 170)
   Define *container = widget_add(*window, "scrollarea", 100, 25, 265, 170)
   ;Define *container = widget_add(*window, "panel", 100, 25, 265, 170) : AddItem(*container,-1,"panel-item-1" )
   widget_add(*container, "button", 15, 25, 30, 30)
   widget_add(*container, "text", 25, 65, 50, 30)
   widget_add(*container, "button", 35, 65+40, 80, 30)
   widget_add(*container, "text", 45, 65+40*2, 50, 30)
   ;     
   ;     Define *container2 = widget_add(*window, "container", 100+140, 25+45, 165, 140)
   ;     widget_add(*container2, "button", 75, 25, 30, 30)
   ;     widget_add(*container2, "text", 25, 65, 50, 30)
   ;     widget_add(*container2, "button", 15, 65+40, 80, 30)
   ;     widget_add(*container2, "text", 45, 65+40*2, 50, 30)
   
   
   
   
   ; ; ; ;   Open( OpenWindow( #PB_Any, 150, 150, 200, 200, "PB ( window_1 )", #PB_Window_SizeGadget | #PB_Window_SystemMenu ) )
   ; ; ; ;   ButtonGadget( #PB_Any, 0,0,80,20,"button" )
   ; ; ; ;   ButtonGadget( #PB_Any, 200-80,200-20,80,20,"button" )
   ; ; ; ;   
   ; ; ; ;   
   ; ; ; ;   
   ; ; ; ;   Open( Window( 200, 200, 200, 200, "window_2", #__Window_SizeGadget | #__Window_SystemMenu ) )
   ; ; ; ;   Debug widget( )\height[#__c_inner2]
   ; ; ; ;   ContainerGadget( #PB_Any, widget( )\x[#__c_inner], widget( )\y[#__c_inner], widget( )\width[#__c_inner2],widget( )\height[#__c_inner2] )
   ; ; ; ;   ButtonGadget( #PB_Any, 0,0,80,20,"button" )
   ; ; ; ;   ButtonGadget( #PB_Any, 200-80,200-20,80,20,"button" )
   ; ; ; ;   CloseGadgetList( )
   
   WaitClose( )
;    ;     Bind( Root(), #PB_Default )
;    Repeat 
;       event = WaitWindowEvent( ) 
;       
;       ;     Select EventWindow( )
;       ;       Case window_ide 
;       ;         ide_window_events( event )
;       ;     EndSelect
;       
;    Until event = #PB_Event_CloseWindow
CompilerEndIf


;\\ include images
DataSection   
   ;IncludePath "include/images"
   IncludePath #IDE_path + "ide/include/images"
   
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
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 783
; FirstLine = 754
; Folding = ---------vf----------
; EnableXP