XIncludeFile "../../widgets.pbi" 
;- MULTI SELECT WIDGETS
CompilerIf #PB_Compiler_IsMainFile ;= 99  
   UseWidgets( )
   
   Enumeration 
      #_tb_group_select = 1
      
      #_tb_group_left = 3
      #_tb_group_right
      #_tb_group_top
      #_tb_group_bottom
      #_tb_group_width
      #_tb_group_height
      
      #_tb_widget_delete
      #_tb_widget_copy
      #_tb_widget_cut
      #_tb_widget_paste
      
      #_tb_LNG
      #_tb_lng_ENG
      #_tb_lng_RUS
      #_tb_lng_FRENCH
      #_tb_lng_GERMAN
   EndEnumeration
   
   Global ide_toolbar, ide_popup_lenguage, *g1._s_WIDGET, *g2._s_WIDGET
   
   Procedure DisableBarButtons( *this._s_WIDGET, state )
      DisableBarButton( *this, #_tb_group_left, state )
      DisableBarButton( *this, #_tb_group_right, state )
      DisableBarButton( *this, #_tb_group_top, state )
      DisableBarButton( *this, #_tb_group_bottom, state )
      DisableBarButton( *this, #_tb_group_height, state )
      DisableBarButton( *this, #_tb_group_width, state )
   EndProcedure
   
   Procedure Copy( *g._s_WIDGET )
      PushListPosition( widgets( ) )
      SelectElement( widgets( ), 2 )
      AddElement( widgets( ) )
      widgets( )  = @*g
      PopListPosition( widgets( ) )
   EndProcedure
   
   
   
   Procedure ide_toolbar_events( )
      Protected *g._s_WIDGET = EventWidget( )
      
      Select WidgetEventItem( )
         Case #_tb_group_select
            If a_anchors( )\group\show
               a_focused( ) = 0
            EndIf
            
         Case #_tb_group_left
            a_align( a_focused( ), 1 )
         Case #_tb_group_right 
            a_align( a_focused( ), 3 )
         Case #_tb_group_top 
            a_align( a_focused( ), 2 )
         Case #_tb_group_bottom
            a_align( a_focused( ), 4 )
         Case #_tb_group_width 
            a_align( a_focused( ), 5 )
         Case #_tb_group_height
            a_align( a_focused( ), 6 )
            
            
            
         Case #_tb_widget_copy
         Case #_tb_widget_paste
            ;             If StartEnum( *g0 )
            ;                If widgets( )\anchors\group\show 
            ;                   
            ;                   Debug "paste "+widgets( )\class
            ;                   Copy( widgets( ) )
            ;                EndIf
            ;                StopEnum( )
            ;             EndIf
            
         Case #_tb_widget_cut
         Case #_tb_widget_delete
            
      EndSelect
      
   EndProcedure
   
   Procedure ide_events( )
      Protected *g._s_WIDGET = EventWidget( )
      If WidgetEvent( ) = #__event_Up
         If a_anchors( )\group\show
            DisableBarButtons( ide_toolbar, 0 )
         Else
            DisableBarButtons( ide_toolbar, 1 )
         EndIf
      Else
         Debug ""+#PB_Compiler_Procedure +" "+ EventString( WidgetEvent( )) +" "+ *g\class
      EndIf
   EndProcedure
   
   If Open(0, 0, 0, 700, 320, "MDI", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ide_toolbar = CreateBar( Root( ), #PB_ToolBar_Small )
      SetClass( ide_toolbar, "ide_toolbar")
      
      If ide_toolbar
         BarSeparator( )
         BarButton( #_tb_group_select, CatchImage( #PB_Any,?image_group ), #PB_ToolBar_Toggle ) 
         ;
         ;    SetItemAttribute( widget( ), #_tb_group_select, #PB_Button_Image, CatchImage( #PB_Any,?image_group_un ) )
         ;    SetItemAttribute( widget( ), #_tb_group_select, #PB_Button_PressedImage, CatchImage( #PB_Any,?image_group ) )
         ;
         BarSeparator( )
         BarButton( #_tb_group_left, CatchImage( #PB_Any,?image_group_left ) )
         BarButton( #_tb_group_right, CatchImage( #PB_Any,?image_group_right ) )
         BarSeparator( )
         BarButton( #_tb_group_top, CatchImage( #PB_Any,?image_group_top ) )
         BarButton( #_tb_group_bottom, CatchImage( #PB_Any,?image_group_bottom ) )
         BarSeparator( )
         BarButton( #_tb_group_width, CatchImage( #PB_Any,?image_group_width ) )
         BarButton( #_tb_group_height, CatchImage( #PB_Any,?image_group_height ) )
         BarSeparator( )
         BarSeparator( )
         BarButton( #_tb_widget_copy, CatchImage( #PB_Any,?image_new_widget_copy ) )
         BarButton( #_tb_widget_cut, CatchImage( #PB_Any,?image_new_widget_cut ) )
         BarButton( #_tb_widget_paste, CatchImage( #PB_Any,?image_new_widget_paste ) )
         BarSeparator( )
         BarButton( #_tb_widget_delete, CatchImage( #PB_Any,?image_new_widget_delete ) )
         BarSeparator( )
         BarSeparator( )
         
         ide_popup_lenguage = OpenSubBar("[LENGUAGE]")
         If ide_popup_lenguage
            BarItem(#_tb_lng_ENG, "ENG")
            BarItem(#_tb_lng_RUS, "RUS")
            BarItem(#_tb_lng_FRENCH, "FRENCH")
            BarItem(#_tb_lng_GERMAN, "GERMAN")
         EndIf
         CloseSubBar( )
         CloseList( ) 
         
         DisableBarButtons( ide_toolbar, 1 )
         Bind( ide_toolbar, @ide_toolbar_events( ) )
      EndIf
      
      
      Define i,*t1,*t2
      *t1=Tree( 15,15,80,120 )
      For i=0 To 100
         AddItem( *t1, -1, Str(i)+"item")
      Next
      *t2=Tree( 15,140,80,120 )
      For i=0 To 100
         AddItem( *t2, -1, Str(i)+"item")
      Next
      SetState( *t1, 3)
      ;SetItemState( *t1, 3, #PB_Tree_Selected )
      ;SetActive( *t1)
      
      Define MDI = MDI(100, 10, 680, 275) ;, #PB_MDI_AutoSize) ; as they will be sized automatically
      a_init( MDI )                       ;, 0 )
      
      ; FORM_1
      *g1 = AddItem( MDI, -1, "form_0" )
      Button( 15,35,100,20,"button_0" )
      Button( 30,65,100,30,"button_1" )
      Disable(Button( 45,100,100,40,"button_2" ),1)
      
      Button( 175,35,100,20,"button_3" )
      Button( 160,65,100,30,"button_4" )
      Button( 150,100,100,40,"button_5" )
      
      ; FORM2
      *g2 = AddItem( MDI, -1, "form_0" )
      Button( 15,35,100,20,"button_0" )
      Button( 30,65,100,30,"button_1" )
      Disable(Button( 45,100,100,40,"button_2" ),1)
      
      Button( 175,35,100,20,"button_3" )
      Button( 160,65,100,30,"button_4" )
      Button( 150,100,100,40,"button_5" )
      ; Resize( *g2, X(*g1)+Width(*g1), #PB_Ignore, #PB_Ignore, #PB_Ignore) ; BUG
      Resize( *g2, X(*g1, #__c_container)+Width(*g1, #__c_frame), Y(*g1, #__c_container), #PB_Ignore, #PB_Ignore )
      
      ;;test_focus_set = 1
      Debug "-"
      SetActive( MDI )
      a_set(*g2)
      Debug "--"
      
      Bind( Root(), @ide_events( ), #__event_focus )
      Bind( Root(), @ide_events( ), #__event_lostfocus )
      Bind( Root(), @ide_events( ), #__event_Up )
      
      Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
      
      ;\\ include images
      DataSection   
         IncludePath "../../ide/include/images"
         
         image_new_widget_delete:    : IncludeBinary "16/delete.png"
         image_new_widget_paste:     : IncludeBinary "16/paste.png"
         image_new_widget_copy:      : IncludeBinary "16/copy.png"
         image_new_widget_cut:       : IncludeBinary "16/cut.png"
         
         image_group:            : IncludeBinary "group/group.png"
         image_group_un:         : IncludeBinary "group/group_un.png"
         image_group_top:        : IncludeBinary "group/group_top.png"
         image_group_left:       : IncludeBinary "group/group_left.png"
         image_group_right:      : IncludeBinary "group/group_right.png"
         image_group_bottom:     : IncludeBinary "group/group_bottom.png"
         image_group_width:      : IncludeBinary "group/group_width.png"
         image_group_height:     : IncludeBinary "group/group_height.png"
      EndDataSection
   EndIf
   
CompilerEndIf

; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 200
; FirstLine = 198
; Folding = ---
; EnableXP
; DPIAware