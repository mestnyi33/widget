;- 
#IDE_path = "../"
XIncludeFile #IDE_path + "widgets.pbi"
;
EnableExplicit
;
Uselib( WIDGET )
UsePNGImageDecoder( )
;
;- ENUMs
#_DD_CreateNew = 1<<1
#_DD_reParent = 1<<2
#_DD_Group = 1<<3
#_DD_CreateCopy = 1<<4
;
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

; bar items
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
   
   #_tb_file_open
   #_tb_file_save
   #_tb_file_save_as
   #_tb_file_quit
   
   #_tb_menu 
EndEnumeration

;- GLOBALs
Global g_ide_design_code,
       ide_window, 
       ide_canvas

Global w_ide_root,
       w_ide_splitter,
       w_ide_toolbar_container, 
       w_ide_toolbar
        
Global w_ide_design_splitter, 
       w_ide_design_panel, 
       w_ide_design_MDI,
       w_ide_design_code

Global w_ide_debug_splitter, 
       w_ide_debug_view 

Global w_ide_inspector_splitter, 
       w_ide_inspector_view, 
       w_ide_inspector_panel,
       w_ide_inspector_elements,
       w_ide_inspector_properties, 
       w_ide_inspector_events

Global w_ide_help_splitter,
       w_ide_help_view

Global group_select
Global group_drag

;Macro ChangeCursor( a,b ) : EndMacro

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
   SetItemText( _gadget_, #_pi_class,   GetItemText( _gadget_, #_pi_class )   +Chr( 10 )+GetClass( _value_ )+"_"+GetTypeCount( _value_ ) )
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
   ;     If Child( widget( ), w_ide_design_MDI )
   ;       Debug widget( )\class
   ;     EndIf
   ;   Next
   
   If IsGadget( g_ide_design_code )
      AddGadgetItem( g_ide_design_code, Position, code )
   Else
      AddItem( w_ide_design_code, Position, code )
   EndIf
EndProcedure


;-
Declare widget_events( )

;-
Macro widget_copy( )
   ClearList( *copy( ) )
   
   If a_focused( )\anchors
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
   
   a_selector( )\x = mouse( )\steps
   a_selector( )\y = mouse( )\steps
EndMacro

Macro widget_delete( )
   If a_focused( )\anchors
      RemoveItem( w_ide_inspector_view, GetData( a_focused( ) ) )
      
      Free( a_focused( ) )
      
      a_Set( GetItemData( w_ide_inspector_view, GetState( w_ide_inspector_view ) ) )
   Else
      ForEach a_group( )
         RemoveItem( w_ide_inspector_view, GetData( a_group( )\widget ) )
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
      
      a_selector( )\x + mouse( )\steps
      a_selector( )\y + mouse( )\steps
      
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
   Protected is_window.b, flag.i 
   
   If *parent 
      OpenList( *parent, CountItems( *parent ) - 1 )
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
            is_window = #True
            If __type( *parent ) = #__Type_MDI
               *new = AddItem( *parent, #PB_Any, "", - 1, flag )
               Resize( *new, #PB_Ignore, #PB_Ignore, width,height )
            Else
               flag | #__window_systemmenu | #__window_maximizegadget | #__window_minimizegadget
               *new = Window( x,y,width,height, "", flag, *parent )
            EndIf
            
            SetColor( *new, #__color_back, $FFECECEC )
            SetImage( *new, CatchImage( #PB_Any,?group_bottom ) )
            Bind( *new, @widget_events( ) )
            
         Case "container"   
            *new = Container( x,y,width,height, flag ) : CloseList( )
            SetColor( *new, #__color_back, $FFF1F1F1 )
            
         Case "panel"       
            *new = Panel( x,y,width,height, flag ) : AddItem( *new, -1, class+"_item_0" ) : CloseList( )
            SetColor( *new, #__color_back, $FFF1F1F1 )
            
         Case "scrollarea"  
            *new = ScrollArea( x,y,width,height, *param1, *param2, *param3, flag ) : CloseList( )
            SetColor( *new, #__color_back, $FFF1F1F1 )
            
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
         newClass.s = GetClass( *new )+"_"+GetTypeCount( *new )
         ; newClass.s = GetClass( *parent )+"_"+GetTypeCount( *parent )+"_"+GetClass( *new )+"_"+GetTypeCount( *new , 1 )
         ;
         If IsContainer( *new )
            EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateNew|#_DD_reParent|#_DD_CreateCopy|#_DD_Group )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateNew )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_reParent )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_CreateCopy )
            ;           EnableDrop( *new, #PB_Drop_Private, #PB_Drag_Copy, #_DD_Group )
            If is_window
               a_set(*new, #__a_full, 14)
            Else
               a_set(*new, #__a_full, 10)
            EndIf  
         Else
            a_set(*new, #__a_full)
         EndIf
         ;
         SetText( *new, newClass )
         ;
         ; get new add position & sublevel
         Protected i, countitems, sublevel, position = GetData( *parent ) 
         countitems = CountItems( w_ide_inspector_view )
         For i = 0 To countitems - 1
            Position = ( i+1 )
            
            If *parent = GetItemData( w_ide_inspector_view, i ) 
               SubLevel = GetItemAttribute( w_ide_inspector_view, i, #PB_Tree_SubLevel ) + 1
               Continue
            EndIf
            
            If SubLevel > GetItemAttribute( w_ide_inspector_view, i, #PB_Tree_SubLevel )
               Position = i
               Break
            EndIf
         Next 
         
         ; set new widget data
         SetData( *new, position )
         
         ; update new widget data item
         If countitems > position
            For i = position To countitems - 1
               SetData( GetItemData( w_ide_inspector_view, i ), i + 1 )
            Next 
         EndIf
         
         ; get image associated with class
         Protected img =- 1
         countitems = CountItems( w_ide_inspector_elements )
         For i = 0 To countitems - 1
            If LCase(StringField( newClass.s, 1, "_" )) = LCase(GetItemText( w_ide_inspector_elements, i ))
               img = GetItemData( w_ide_inspector_elements, i )
               Break
            EndIf
         Next  
         
         ; add to inspector
         AddItem( w_ide_inspector_view, position, newClass.s, img, sublevel )
         SetItemData( w_ide_inspector_view, position, *new )
         ; SetItemState( w_ide_inspector_view, position, #PB_tree_selected )
         
         ; Debug " "+position
         SetState( w_ide_inspector_view, position )
         
         If IsGadget( g_ide_design_code )
            AddGadgetItem( g_ide_design_code, position, newClass.s, ImageID(img), SubLevel )
            SetGadgetItemData( g_ide_design_code, position, *new )
            ; SetGadgetItemState( g_ide_design_code, position, #PB_tree_selected )
            SetGadgetState( g_ide_design_code, position ) ; Bug
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
   Protected *new, *e_widget._s_widget = WidgetEvent( )\widget
   ;    Static *beforeWidget
   
   Select eventtype 
      Case #__event_RightButtonDown
         Debug "right"
         
         ; disable window-toolbar-buttons events
      Case #__event_Close ;, #__event_Minimize, #__event_Maximize
         ProcedureReturn 1
         
      Case #__event_Focus
         If a_focused( ) = *e_widget
            If GetData( *e_widget ) >= 0
               ;Debug GetData( *e_widget )
               If IsGadget( g_ide_design_code )
                  SetGadgetState( g_ide_design_code, GetData( *e_widget ) )
               EndIf
               SetState( w_ide_inspector_view, GetData( *e_widget ) )
            EndIf
            
            properties_updates( w_ide_inspector_properties, *e_widget )
            
            ;Debug "Focus "+*e_widget\class +" ("+*e_widget\text\string+")"
            
            If GetActive( ) <> w_ide_inspector_view 
               ; Debug "reFocus (w_ide_inspector_view)"   
               SetActive( w_ide_inspector_view )
            EndIf
            
            ;Debug "focus " + GetActive( )\RowFocused( )\color\state
          EndIf
         
      Case #__event_DragStart
         If is_drag_move( )
            If DragDropPrivate( #_DD_reParent )
              ; ChangeCursor( *e_widget, #PB_Cursor_Arrows )
            EndIf
         Else
            If IsContainer( *e_widget ) 
               If MouseEnter( *e_widget )
                  If Not a_index( )
                     If GetState( w_ide_inspector_elements) > 0 
                        If DragDropPrivate( #_DD_CreateNew )
                           ChangeCursor( *e_widget, #PB_Cursor_Cross )
                        EndIf
                     Else
                        If DragDropPrivate( #_DD_Group )
                           ChangeCursor( *e_widget, #PB_Cursor_Cross )
                        EndIf
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
         
      Case #__event_Drop
         Select DropPrivate( )
            Case #_DD_Group
              Debug " ----- DD_group ----- " + *e_widget\class
             
            Case #_DD_reParent
               Debug " ----- DD_move ----- " +PressedWidget( )\class +" "+ EnteredWidget( )\class
               If SetParent( PressedWidget( ), EnteredWidget( ) )
                  Protected i = 3 : Debug "re-parent "+ PressedWidget( )\parent\class +" "+ PressedWidget( )\x[i] +" "+ PressedWidget( )\y[i] +" "+ PressedWidget( )\width[i] +" "+ PressedWidget( )\height[i]
               EndIf
               
            Case #_DD_CreateNew 
               Debug " ----- DD_new ----- "+ GetText( w_ide_inspector_elements ) +" "+ DropX( ) +" "+ DropY( ) +" "+ DropWidth( ) +" "+ DropHeight( )
               widget_add( *e_widget, GetText( w_ide_inspector_elements ), DropX( ), DropY( ), DropWidth( ), DropHeight( ) )
   
            Case #_DD_CreateCopy
               Debug " ----- DD_copy ----- " + GetText( PressedWidget( ) )
               
               ;            *new = widget_add( *e_widget, GetClass( PressedWidget( ) ), 
               ;                         X( PressedWidget( ) ), Y( PressedWidget( ) ), Width( PressedWidget( ) ), Height( PressedWidget( ) ) )
               
               *new = widget_add( *e_widget, DropText( ), DropX( ), DropY( ), DropWidth( ), DropHeight( ) )
               SetText( *new, "Copy_"+DropText( ) )
               
         EndSelect
         
      Case #__event_LeftButtonDown
         If IsContainer( *e_widget )
            If a_selector( )\type > 0 Or group_select
               If group_select 
                  group_drag = *e_widget
               EndIf
            EndIf
            
            ;           If a_focused( )\transform <> 1
            ;             ForEach a_group( )
            ;               SetItemState( w_ide_inspector_view, GetData( a_group( )\widget ), 0 )
            ;             Next
            ;           EndIf
         EndIf
         
      Case #__event_LeftButtonUp
         ; then group select
         If IsContainer( *e_widget )
            If a_transform( ) And a_focused( ) And a_focused( )\anchors = - 1
               SetState( w_ide_inspector_view, - 1 )
               If IsGadget( g_ide_design_code )
                  SetGadgetState( g_ide_design_code, - 1 )
               EndIf
               
               ForEach a_group( )
                  SetItemState( w_ide_inspector_view, GetData( a_group( )\widget ), #PB_Tree_Selected )
                  If IsGadget( g_ide_design_code )
                     SetGadgetItemState( g_ide_design_code, GetData( a_group( )\widget ), #PB_Tree_Selected )
                  EndIf
               Next
            EndIf
         EndIf
         
      Case #__event_Resize
         properties_update_coordinate( w_ide_inspector_properties, *e_widget )
         SetWindowTitle( GetWindow(*e_widget\root), Str(width(*e_widget))+"x"+Str(height(*e_widget) ) )
         
      Case #__event_MouseEnter,
           #__event_MouseLeave,
           #__event_MouseMove
         
         If Not MouseButtons( ) 
            If IsContainer( *e_widget ) 
               If GetState( w_ide_inspector_elements ) > 0 
                  If eventtype = #__event_MouseLeave
                     If CurrentCursor( ) <> #PB_Cursor_Default
                        ChangeCursor( *e_widget, #PB_Cursor_Default )
                     EndIf
                     
                  ElseIf *e_widget\enter = 2
                     If CurrentCursor( ) <> #PB_Cursor_Cross
                        ChangeCursor( *e_widget, #PB_Cursor_Cross )
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
      If GetState( w_ide_inspector_elements ) > 0 
         SetState( w_ide_inspector_elements, 0 )
         ChangeCursor( *e_widget, #PB_Cursor_Default )
         a_selector( )\type = 0
      EndIf
   EndIf
EndProcedure


Global w_ide_design_form ; TEMP
Declare ide_events( )


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

Procedure ide_menu_events( *e_widget._s_WIDGET, toolbarbutton )
   Protected transform, move_x, move_y
   Static NewList *copy._s_a_group( )
   
   Debug "ide_menu_events "+toolbarbutton
   
   Select toolbarbutton
      Case 1
         If __type( *e_widget ) = #__type_ToolBar
            If GetItemState( *e_widget, toolbarbutton )  
               ; group
               group_select = *e_widget
               ; SetAtributte( *e_widget, #PB_Button_PressedImage )
            Else
               ; un group
               group_select = 0
            EndIf
         Else
            If Getstate( *e_widget )  
               ; group
               group_select = *e_widget
               ; SetAtributte( *e_widget, #PB_Button_PressedImage )
            Else
               ; un group
               group_select = 0
            EndIf
         EndIf
         
         ForEach a_group( )
            Debug a_group( )\widget\x
            
         Next
         
         
      Case #_tb_file_open
         Debug "#_tb_file_open"
         Close( w_ide_design_form )
;          ClearItems( w_ide_inspector_view )
         
         
      Case #_tb_file_save
         Debug "#_tb_file_save"
         
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
         
;       Case #_tb_menu
;          DisplayPopupMenuBar( *e_widget )
         
   EndSelect
   
EndProcedure

Procedure ide_events( )
   Protected *this._s_widget
   Protected e_type = WidgetEvent( )\type
   Protected e_item = WidgetEvent( )\item
   Protected *e_widget._s_widget = WidgetEvent( )\widget
   
   Select e_type
      Case #__event_Close
         If *e_widget = w_ide_root
            ; bug при отмене выбора закрыть
            If #PB_MessageRequester_Yes = Message( "Message", 
                                                   "Are you sure you want to go out?",
                                                   #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
               ProcedureReturn 0
            Else
               ProcedureReturn 1
            EndIf
         EndIf
         
      Case #__event_DragStart
         If *e_widget = w_ide_inspector_elements
            a_selector( )\type = 0
            
            Debug " ------ drag ide_events() ----- "
            If DragDropPrivate( #_DD_CreateNew )
               ChangeCursor( *e_widget, Cursor::Create( ImageID( GetItemData( *e_widget, GetState( *e_widget ) ) ) ) )
            EndIf
         EndIf
         
      Case #__event_StatusChange
         If *e_widget = w_ide_design_code
            ; Debug Left( *e_widget\text\string, *e_widget\text\caret\pos ); GetState( w_ide_design_code )
         EndIf
         
         If e_item = - 1
            ;SetText( w_ide_help_view, GetItemText( *e_widget, GetState( *e_widget ) ) )
         Else
            If *e_widget = w_ide_inspector_view
               SetText( w_ide_help_view, GetItemText( *e_widget, e_item ) )
               
;                ;\\ TEMP change visible
;                *this._s_widget = *e_widget
;                If *this\RowFocused( ) 
;                   If *this\RowFocused( )\color\state <> 3
;                      *this\RowFocused( )\color\back[*this\RowFocused( )\color\state] = *this\color\back[*this\RowFocused( )\color\state] ; $FFF5702C ; TEMP
;                   EndIf
;                EndIf
;                ;             If *this\EnteredRow( )
;                ;               If *this\EnteredRow( )\color\state <> 3
;                ;                 *this\EnteredRow( )\color\back[*this\EnteredRow( )\color\state] = $FF70F52C ; TEMP
;                ;                 *this\EnteredRow( )\color\front[*this\EnteredRow( )\color\state] = $FFffffff ; TEMP
;                ;               EndIf
;                ;             EndIf
               
            EndIf
            
            If *e_widget = w_ide_inspector_elements
               SetText( w_ide_help_view, GetItemText( *e_widget, e_item ) )
            EndIf
         EndIf
         
      Case #__event_Change
         If *e_widget = w_ide_inspector_view
            ;Debug GetState(*e_widget)
            a_set( GetItemData(*e_widget, GetState(*e_widget)), #__a_full )
         EndIf
         
         If *e_widget = w_ide_inspector_elements
            a_selector( )\type = GetState( *e_widget )
         EndIf
         
         If *e_widget = w_ide_design_code
            Protected q, startpos, stoppos
            Protected x = #PB_Ignore, y = #PB_Ignore
            Protected width = #PB_Ignore, height = #PB_Ignore
            
            Protected findstring.s = Left( *e_widget\text\string, *e_widget\text\caret\pos )
            Protected countstring = CountString( findstring, "," )
            
            Select countstring
               Case 0, 1, 2, 3, 4
                  For q = *e_widget\text\edit[1]\len To *e_widget\text\edit[1]\pos Step - 1
                     If Mid( *e_widget\text\string, q, 1 ) = "(" Or 
                        Mid( *e_widget\text\string, q, 1 ) = ~"\"" Or
                        Mid( *e_widget\text\string, q, 1 ) = ","
                        startpos = q + 1
                        Break
                     EndIf
                  Next q
                  
                  For q = *e_widget\text\edit[3]\pos To ( *e_widget\text\edit[3]\pos + *e_widget\text\edit[3]\len )
                     If Mid( *e_widget\text\string, q, 1 ) = "," Or
                        Mid( *e_widget\text\string, q, 1 ) = ~"\"" Or
                        Mid( *e_widget\text\string, q, 1 ) = ")"
                        stoppos = q
                        Break
                     EndIf
                  Next q
                  
                  If stoppos And stoppos - startpos
                     findstring = Mid( *e_widget\text\string, startpos, stoppos - startpos )
                     
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
            
            ; Debug Left( *e_widget\text\string, *e_widget\text\caret\pos ); GetState( w_ide_design_code )
         EndIf
         
      Case #__event_LeftClick
         ide_menu_events( *e_widget, WidgetEventItem( ) )
         
;          If __type( *e_widget ) = #__type_ToolBar
;             If *e_widget\EnteredTab( )
;                ide_menu_events( *e_widget, *e_widget\EnteredTab( )\itemindex )
;             EndIf
;          Else
;             If getclass( *e_widget ) = "ToolBar"
;                ide_menu_events( *e_widget, GetData( *e_widget ) )
;             EndIf
;          EndIf
         
   EndSelect
EndProcedure

Procedure ide_open( x=100,y=100,width=850,height=600 )
   ;     OpenWindow( #PB_Any, 0,0,332,232, "" )
   ;     g_ide_design_code = TreeGadget( -1,1,1,330,230 ) 
   
   Define flag = #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget
   w_ide_root = Open( 1, x,y,width,height, "ide", flag ) 
   ide_window = GetWindow( w_ide_root )
   ide_canvas = GetGadget( w_ide_root )
   
   ;    Debug "create window - "+WindowID(ide_window)
   ;    Debug "create canvas - "+GadgetID(ide_canvas)
;    CreatePopupMenuBar( )
;    BarItem(#_tb_file_open, "Open")
;    BarItem(#_tb_file_save, "Save")
;    BarItem(#_tb_file_save_as, "Save as...")
;    BarSeparator( )
;    BarItem(#_tb_file_quit, "Quit")

   w_ide_toolbar_container = Container( 0,0,0,0, #__flag_BorderFlat ) 
   w_ide_toolbar = ToolBar( w_ide_toolbar_container, #PB_ToolBar_Buttons );|#PB_ToolBar_Large);| #PB_ToolBar_InlineText )
   
   ;    ;BarTitle("Menu")
   OpenBar("Menu")
   BarItem(#_tb_file_open, "Open")
   BarItem(#_tb_file_save, "Save")
   BarItem(#_tb_file_save_as, "Save as...")
   BarSeparator( )
   BarItem(#_tb_file_quit, "Quit")
   CloseBar( )
; ;    OpenBar("Menu1")
; ;    BarItem(#_tb_file_open, "Open")
; ;    BarItem(#_tb_file_save, "Save")
; ;    BarItem(#_tb_file_save_as, "Save as...")
; ;    BarSeparator( )
; ;    BarItem(#_tb_file_quit, "Quit")
; ;    CloseBar( )
   
;    BarButton( #_tb_file_open, -1, 0, "Open" )
;    BarButton( #_tb_file_save, -1, 0, "Save" )
   
   BarSeparator( )
   BarButton( #_tb_group_select, CatchImage( #PB_Any,?group ), #PB_ToolBar_Toggle ) 
   ;    ; TEMP
   ;    If __type(widget( )) = #__type_Button
   ;       SetState(widget( ), 1) 
   ;       SetAttribute( widget( ), #PB_Button_Image, CatchImage( #PB_Any,?group_un ) )
   ;       SetAttribute( widget( ), #PB_Button_PressedImage, CatchImage( #PB_Any,?group ) )
   ;    EndIf
   ;
   BarSeparator( )
   BarButton( #_tb_group_left, CatchImage( #PB_Any,?group_left ) )
   BarButton( #_tb_group_right, CatchImage( #PB_Any,?group_right ) )
   BarSeparator( )
   BarButton( #_tb_group_top, CatchImage( #PB_Any,?group_top ) )
   BarButton( #_tb_group_bottom, CatchImage( #PB_Any,?group_bottom ) )
   BarSeparator( )
   BarButton( #_tb_group_width, CatchImage( #PB_Any,?group_width ) )
   BarButton( #_tb_group_height, CatchImage( #PB_Any,?group_height ) )
   
;    BarSeparator( )
;    OpenBar("ComboBox")
;    BarItem(55, "item1")
;    BarItem(56, "item2")
;    BarItem(57, "item3")
;    CloseBar( )
   
   BarSeparator( )
   BarButton( #_tb_widget_copy, CatchImage( #PB_Any,?widget_copy ) )
   BarButton( #_tb_widget_paste, CatchImage( #PB_Any,?widget_paste ) )
   BarButton( #_tb_widget_cut, CatchImage( #PB_Any,?widget_cut ) )
   BarButton( #_tb_widget_delete, CatchImage( #PB_Any,?widget_delete ) )
   BarSeparator( )
   BarButton( #_tb_align_left, CatchImage( #PB_Any,?group_left ) )
   BarButton( #_tb_align_top, CatchImage( #PB_Any,?group_top ) )
   BarButton( #_tb_align_center, CatchImage( #PB_Any,?group_width ) )
   BarButton( #_tb_align_bottom, CatchImage( #PB_Any,?group_bottom ) )
   BarButton( #_tb_align_right, CatchImage( #PB_Any,?group_right ) )
   CloseList( )
   
   ; gadgets
   
   ;\\\ 
   w_ide_design_panel = Panel( 0,0,0,0 ) : SetClass(w_ide_design_panel, "w_ide_design_panel" ) ; , #__bar_vertical ) : OpenList( w_ide_design_panel )
   AddItem( w_ide_design_panel, -1, "Form" )
   w_ide_design_MDI = MDI( 0,0,0,0, #__flag_autosize|#__mdi_editable ) : SetClass(w_ide_design_MDI, "w_ide_design_MDI" ) ;: SetFrame(w_ide_design_MDI, 10)
   SetColor( w_ide_design_MDI, #__color_back, RGBA(195, 156, 191, 255) )
   a_init( w_ide_design_MDI);, 0 )
   
   ;AddItem( w_ide_design_panel, -1, "Code" )
   ;w_ide_design_code = Editor( 0,0,0,0 ) : SetClass(w_ide_design_code, "w_ide_design_code" ) ; bug then move anchors window
   CloseList( )
   
   ;
   w_ide_debug_view = Editor( 0,0,0,0 ) : SetClass(w_ide_debug_view, "w_ide_debug_view" ) ; ListView( 0,0,0,0 ) 
   If Not w_ide_design_code
      w_ide_design_code = w_ide_debug_view
   EndIf
   
   ;\\\ open inspector gadgets 
   w_ide_inspector_view = Tree( 0,0,0,0 ) : SetClass(w_ide_inspector_view, "w_ide_inspector_view" ) ;, #__flag_gridlines )
   EnableDrop( w_ide_inspector_view, #PB_Drop_Text, #PB_Drag_Link )
   
   ; w_ide_inspector_splitter_panel_open
   w_ide_inspector_panel = Panel( 0,0,0,0 ) : SetClass(w_ide_inspector_panel, "w_ide_inspector_panel" )
   
   ; w_ide_inspector_splitter_panel_item_1
   AddItem( w_ide_inspector_panel, -1, "elements", 0, 0 ) 
   w_ide_inspector_elements = Tree( 0,0,0,0, #__flag_autosize | #__flag_NoButtons | #__flag_NoLines | #__flag_borderless ) : SetClass(w_ide_inspector_elements, "w_ide_inspector_elements" )
   If w_ide_inspector_elements
      ide_add_image_list( w_ide_inspector_elements, GetCurrentDirectory( )+"Themes/" )
   EndIf
   
   ; w_ide_inspector_splitter_panel_item_2 
   AddItem( w_ide_inspector_panel, -1, "properties", 0, 0 )  
   w_ide_inspector_properties = Tree_properties( 0,0,0,0, #__flag_autosize | #__flag_gridlines | #__flag_borderless ) : SetClass(w_ide_inspector_properties, "w_ide_inspector_properties" )
   If w_ide_inspector_properties
      AddItem( w_ide_inspector_properties, #_pi_group_0,  "Common" )
      AddItem( w_ide_inspector_properties, #_pi_id,       "ID"      , #__Type_String, 1 )
      AddItem( w_ide_inspector_properties, #_pi_class,    "Class"   , #__Type_String, 1 )
      AddItem( w_ide_inspector_properties, #_pi_text,     "Text"    , #__Type_String, 1 )
      
      AddItem( w_ide_inspector_properties, #_pi_group_1,  "Layout" )
      AddItem( w_ide_inspector_properties, #_pi_x,        "x"       , #__Type_Spin, 1 )
      AddItem( w_ide_inspector_properties, #_pi_y,        "Y"       , #__Type_Spin, 1 )
      AddItem( w_ide_inspector_properties, #_pi_width,    "Width"   , #__Type_Spin, 1 )
      AddItem( w_ide_inspector_properties, #_pi_height,   "Height"  , #__Type_Spin, 1 )
      
      AddItem( w_ide_inspector_properties, #_pi_group_2,  "State" )
      AddItem( w_ide_inspector_properties, #_pi_disable,  "Disable" , #__Type_ComboBox, 1 )
      AddItem( w_ide_inspector_properties, #_pi_hide,     "Hide"    , #__Type_ComboBox, 1 )
   EndIf
   
   ; w_ide_inspector_splitter_panel_item_3 
   AddItem( w_ide_inspector_panel, -1, "events", 0, 0 )  
   w_ide_inspector_events = Tree_properties( 0,0,0,0, #__flag_autosize | #__flag_borderless ) : SetClass(w_ide_inspector_events, "w_ide_inspector_events" ) 
   If w_ide_inspector_events
      AddItem( w_ide_inspector_events, #_ei_leftclick,  "LeftClick" )
      AddItem( w_ide_inspector_events, #_ei_change,  "Change" )
      AddItem( w_ide_inspector_events, #_ei_enter,  "Enter" )
      AddItem( w_ide_inspector_events, #_ei_leave,  "Leave" )
   EndIf
   
   ; w_ide_inspector_splitter_panel_close
   CloseList( )
   
   ; w_ide_inspector_w_ide_help_splitter_text
   w_ide_help_view  = Text( 0,0,0,0, "help for the inspector", #PB_Text_Border ) : SetClass(w_ide_help_view, "w_ide_help_view" )
   ;\\\ close inspector gadgets 
   
   ;
   ;\\\ ide splitters
;    ;
;    ; main splitter 1 example
;    w_ide_design_splitter = Splitter( 0,0,0,0, w_ide_toolbar_container,w_ide_design_panel, #PB_Splitter_FirstFixed | #PB_Splitter_Separator ) : SetClass(w_ide_design_splitter, "w_ide_design_splitter" )
;    w_ide_inspector_splitter = Splitter( 0,0,0,0, w_ide_inspector_view,w_ide_inspector_panel, #PB_Splitter_FirstFixed ) : SetClass(w_ide_inspector_splitter, "w_ide_inspector_splitter" )
;    w_ide_debug_splitter = Splitter( 0,0,0,0, w_ide_design_splitter,w_ide_debug_view, #PB_Splitter_SecondFixed ) : SetClass(w_ide_debug_splitter, "w_ide_debug_splitter" )
;    w_ide_help_splitter = Splitter( 0,0,0,0, w_ide_inspector_splitter,w_ide_help_view, #PB_Splitter_SecondFixed ) : SetClass(w_ide_help_splitter, "w_ide_help_splitter" )
;    w_ide_splitter = Splitter( 0,0,0,0, w_ide_debug_splitter,w_ide_help_splitter, #__flag_autosize | #PB_Splitter_Vertical | #PB_Splitter_SecondFixed ) : SetClass(w_ide_splitter, "w_ide_splitter" )
;    
;    ; set splitters default minimum size
;    SetAttribute( w_ide_splitter, #PB_Splitter_FirstMinimumSize, 500 )
;    SetAttribute( w_ide_splitter, #PB_Splitter_SecondMinimumSize, 120 )
;    SetAttribute( w_ide_help_splitter, #PB_Splitter_FirstMinimumSize, 230 )
;    SetAttribute( w_ide_help_splitter, #PB_Splitter_SecondMinimumSize, 30 )
;    SetAttribute( w_ide_debug_splitter, #PB_Splitter_FirstMinimumSize, 300 )
;    SetAttribute( w_ide_debug_splitter, #PB_Splitter_SecondMinimumSize, 100 )
;    SetAttribute( w_ide_inspector_splitter, #PB_Splitter_FirstMinimumSize, 100 )
;    SetAttribute( w_ide_inspector_splitter, #PB_Splitter_SecondMinimumSize, 130 )
;    SetAttribute( w_ide_design_splitter, #PB_Splitter_FirstMinimumSize, 20 )
;    SetAttribute( w_ide_design_splitter, #PB_Splitter_SecondMinimumSize, 200 )
;    ; SetAttribute( w_ide_design_splitter, #PB_Splitter_SecondMinimumSize, $ffffff )
;    
;    ; set splitters dafault positions
;    SetState( w_ide_splitter, width( w_ide_splitter )-200 )
;    SetState( w_ide_help_splitter, height( w_ide_help_splitter )-80 )
;    SetState( w_ide_debug_splitter, height( w_ide_debug_splitter )-150 )
;    SetState( w_ide_inspector_splitter, 200 )
;    SetState( w_ide_design_splitter, Height( w_ide_toolbar ) - 1 + 2 )
   
   ;
   ;\\ main splitter 2 example 
   w_ide_inspector_splitter = Splitter( 0,0,0,0, w_ide_inspector_view,w_ide_inspector_panel, #PB_Splitter_FirstFixed ) : SetClass(w_ide_inspector_splitter, "w_ide_inspector_splitter" )
   w_ide_debug_splitter = Splitter( 0,0,0,0, w_ide_design_panel,w_ide_debug_view, #PB_Splitter_SecondFixed ) : SetClass(w_ide_debug_splitter, "w_ide_debug_splitter" )
   w_ide_help_splitter = Splitter( 0,0,0,0, w_ide_inspector_splitter,w_ide_help_view, #PB_Splitter_SecondFixed ) : SetClass(w_ide_help_splitter, "w_ide_help_splitter" )
   w_ide_design_splitter = Splitter( 0,0,0,0, w_ide_help_splitter, w_ide_debug_splitter, #PB_Splitter_FirstFixed | #PB_Splitter_Vertical | #PB_Splitter_Separator ) : SetClass(w_ide_design_splitter, "w_ide_design_splitter" )
   w_ide_splitter = Splitter( 0,0,0,0, w_ide_toolbar_container, w_ide_design_splitter,#__flag_autosize | #PB_Splitter_FirstFixed ) : SetClass(w_ide_splitter, "w_ide_splitter" )
   
   ; set splitters default minimum size
   SetAttribute( w_ide_splitter, #PB_Splitter_FirstMinimumSize, 20 )
   SetAttribute( w_ide_splitter, #PB_Splitter_SecondMinimumSize, 500 )
   SetAttribute( w_ide_design_splitter, #PB_Splitter_FirstMinimumSize, 120 )
   SetAttribute( w_ide_design_splitter, #PB_Splitter_SecondMinimumSize, 500 )
   SetAttribute( w_ide_help_splitter, #PB_Splitter_FirstMinimumSize, 230 )
   SetAttribute( w_ide_help_splitter, #PB_Splitter_SecondMinimumSize, 30 )
   SetAttribute( w_ide_debug_splitter, #PB_Splitter_FirstMinimumSize, 300 )
   SetAttribute( w_ide_debug_splitter, #PB_Splitter_SecondMinimumSize, 100 )
   SetAttribute( w_ide_inspector_splitter, #PB_Splitter_FirstMinimumSize, 100 )
   SetAttribute( w_ide_inspector_splitter, #PB_Splitter_SecondMinimumSize, 130 )
   
   ; set splitters dafault positions
   SetState( w_ide_splitter, height( w_ide_toolbar ) - 1 + 2 )
   SetState( w_ide_design_splitter, 200 )
   SetState( w_ide_help_splitter, height( w_ide_help_splitter )-80 )
   SetState( w_ide_debug_splitter, height( w_ide_debug_splitter )-200 )
   SetState( w_ide_inspector_splitter, 230 )
   
   
   ;
   ;\\\ ide events binds
   ;
   If __type( w_ide_toolbar ) = #__type_ToolBar
      Bind( w_ide_toolbar, @ide_events( ), #__event_LeftClick )
   EndIf
   Bind( w_ide_inspector_view, @ide_events( ) )
   ;
   Bind( w_ide_design_code, @ide_events( ), #__event_Change )
   Bind( w_ide_design_code, @ide_events( ), #__event_StatusChange )
   ;
   Bind( w_ide_inspector_elements, @ide_events( ), #__event_Change )
   Bind( w_ide_inspector_elements, @ide_events( ), #__event_StatusChange )
   Bind( w_ide_inspector_elements, @ide_events( ), #__event_LeftClick )
   Bind( w_ide_inspector_elements, @ide_events( ), #__event_MouseEnter )
   Bind( w_ide_inspector_elements, @ide_events( ), #__event_MouseLeave )
   Bind( w_ide_inspector_elements, @ide_events( ), #__event_DragStart )
   ;
   ;
   Bind( w_ide_root, @ide_events( ), #__event_Close )
   ProcedureReturn ide_window
EndProcedure

;-
CompilerIf #PB_Compiler_IsMainFile 
   Define event
   ide_open( )
   
   ;   ;OpenList(w_ide_design_MDI)
   Define result, example = 3
   
  
   If example = 1
      ;\\ example 1
      w_ide_design_form = widget_add( w_ide_design_MDI, "window", 10, 10, 350, 200 )
      
   ElseIf example = 2
      ;\\ example 2
      w_ide_design_form = widget_add( w_ide_design_MDI, "window", 10, 10, 350, 200 )
      Define *container = widget_add( w_ide_design_form, "container", 130, 20, 220, 140 )
      widget_add( *container, "button", 10, 20, 30, 30 )
      widget_add( w_ide_design_form, "button", 10, 20, 100, 30 )
      
      Define item = 1
      SetState( w_ide_inspector_view, item )
      If IsGadget( g_ide_design_code )
         SetGadgetState( g_ide_design_code, item )
      EndIf
      Define *container2 = widget_add( *container, "container", 60, 10, 220, 140 )
      widget_add( *container2, "button", 10, 20, 30, 30 )
      
      SetState( w_ide_inspector_view, 0 )
      widget_add( w_ide_design_form, "button", 10, 130, 100, 30 )
      
   ElseIf example = 3
      ;\\ example 3
      w_ide_design_form = widget_add(w_ide_design_MDI, "window", 30, 30, 500, 250)
      widget_add(w_ide_design_form, "button", 15, 25, 50, 30)
      widget_add(w_ide_design_form, "text", 25, 65, 50, 30)
      widget_add(w_ide_design_form, "button", 35, 65+40, 50, 30)
      widget_add(w_ide_design_form, "text", 45, 65+40*2, 50, 30)
      
      Define *scrollarea = widget_add(w_ide_design_form, "scrollarea", 120, 25, 165, 175)
      widget_add(*scrollarea, "button", 15, 25, 30, 30)
      widget_add(*scrollarea, "text", 25, 65, 50, 30)
      widget_add(*scrollarea, "button", 35, 65+40, 80, 30)
      widget_add(*scrollarea, "text", 45, 65+40*2, 50, 30)
      
      Define *panel = widget_add(w_ide_design_form, "panel", 320, 25, 165, 175)
      widget_add(*panel, "button", 15, 25, 30, 30)
      widget_add(*panel, "text", 25, 65, 50, 30)
      widget_add(*panel, "button", 35, 65+40, 80, 30)
      widget_add(*panel, "text", 45, 65+40*2, 50, 30)
      
      AddItem( *panel, -1, "pane_item_1" )
      ;OpenList( *panel, 1 )
      widget_add(*panel, "button", 115, 25, 30, 30)
      widget_add(*panel, "text", 125, 65, 50, 30)
      widget_add(*panel, "button", 135, 65+40, 80, 30)
      widget_add(*panel, "text", 145, 65+40*2, 50, 30)
      ;CloseList( )
      SetState( *panel, 1 )
      
   ElseIf example = 4
      ;\\ example 3
      w_ide_design_form = widget_add(w_ide_design_MDI, "window", 30, 30, 400, 250)
      Define q=widget_add(w_ide_design_form, "button", 15, 25, 50, 30)
      widget_add(w_ide_design_form, "text", 25, 65, 50, 30)
      widget_add(w_ide_design_form, "button", 285, 25, 50, 30)
      widget_add(w_ide_design_form, "text", 45, 65+40*2, 50, 30)
      
      Define *container = widget_add(w_ide_design_form, "scrollarea", 100, 25, 165, 170)
      widget_add(*container, "button", 15, 25, 30, 30)
      widget_add(*container, "text", 25, 65, 50, 30)
      widget_add(*container, "button", 35, 65+40, 80, 30)
      widget_add(*container, "text", 45, 65+40*2, 50, 30)
      SetActive( q )
      
   ElseIf example = 5
      ;\\ example 3
      w_ide_design_form = widget_add(w_ide_design_MDI, "window", 30, 30, 400, 250)
      Define q=widget_add(w_ide_design_form, "button", 280, 25, 50, 30)
      widget_add(w_ide_design_form, "text", 25, 65, 50, 30)
      widget_add(w_ide_design_form, "button", 340, 25, 50, 30)
      widget_add(w_ide_design_form, "text", 45, 65+40*2, 50, 30)
      
      Define *container = widget_add(w_ide_design_form, "scrollarea", 100, 25, 155, 170)
      widget_add(*container, "button", 15, 25, 30, 30)
      widget_add(*container, "text", 25, 65, 50, 30)
      widget_add(*container, "button", 35, 65+40, 80, 30)
      widget_add(*container, "text", 45, 65+40*2, 50, 30)
      SetActive( q )
   EndIf
   
    
;    Define._S_WIDGET *this, *parent
;    Debug "--- enumerate all gadgets ---"
;    If StartEnumerate( root( ) )
;       Debug "     gadget - "+ enumWidget()\index +" "+ enumWidget()\class +"               ("+ enumWidget()\parent\class +") " ;+" - ("+ enumWidget()\text\string +")"
;       StopEnumerate( )
;    EndIf
;    
;    Debug ""
;    *parent = *container
;    *this = GetPositionLast( *parent )
;    Debug ""+*this\class +"           ("+ *parent\class +")" ;  +" - ("+ *this\text\string +")"
;    
;    
;    If StartEnumerate( *parent )
;       Debug "   *parent  gadget - "+ enumWidget()\index +" "+ enumWidget()\class +"               ("+ enumWidget()\parent\class +") " ;+" - ("+ enumWidget()\text\string +")"
;       StopEnumerate( )
;    EndIf
;    
   If SetActive( w_ide_inspector_view )
      SetActiveGadget( ide_canvas )
   EndIf
   
   ;\\ 
   WaitClose( )
CompilerEndIf


;\\ include images
DataSection   
   IncludePath #IDE_path + "ide/include/images"
   
   file_open:        : IncludeBinary "delete1.png"
   file_save:        : IncludeBinary "paste.png"
   
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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 953
; FirstLine = 926
; Folding = ----------------------
; EnableXP
; DPIAware