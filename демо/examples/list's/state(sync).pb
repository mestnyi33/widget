
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   test_focus_draw = 1
   ;test_StatusChange  = 1
   
   Global a, CountItems = 20
   Global._s_WIDGET *g, *g1, *g2
   
   ;-
   Procedure   PropertiesItems_StatusChange( *g2._s_WIDGET, item, state )
      Protected._s_ROW *row = ItemID( *g2, item )
      If *row 
         If *row\ColorState( ) 
            *row\ColorState( ) = state
            StatusChange(*g1, *row)
         EndIf
      EndIf
   EndProcedure
   
   Procedure   PropertiesButton_Events( )
      Protected._s_WIDGET *this = EventWidget( )
      
      Select WidgetEvent( )
         Case #__EVENT_Focus : PropertiesItems_StatusChange( *g2, GetData(*this), #__s_2)
            Debug " >>> "+*this\class
         Case #__EVENT_LostFocus : PropertiesItems_StatusChange( *g2, GetData(*this), #__s_3)
            Debug " <<< "+*this\class
            
      EndSelect
      
      ProcedureReturn #PB_Ignore
   EndProcedure
   
   Procedure   PropertiesButton_Resize( *this._s_WIDGET, *row._s_ROW )
      Protected result
      
      If *row
         If *this
            result = Resize( *this,
                             *row\x,
                             *row\y + *g2\scroll_y( ),
                             *g2\inner_width( ),
                             *row\height, 0 )
         EndIf
      EndIf
      
      ProcedureReturn result
   EndProcedure
   
   Procedure   PropertiesButton_Display( *g2._s_WIDGET )
      Protected._s_ROW *row = *g2\RowFocused( ) 
      Protected._s_WIDGET *this = GetData( *g2 )
      Protected result
      
      If *row
         If *this
            Repaint( )
            Hide(*this, Bool(*row\mask & #__MASK_Hidden))
            PropertiesButton_Resize( *this, *row )
         EndIf
      EndIf
      
      ProcedureReturn result
   EndProcedure
   
   Procedure   PropertiesButton_Free(*g2._s_WIDGET)
      Protected._s_WIDGET *this = GetData( *g2 )
      If *this
         Unbind(*this, @PropertiesButton_Events( ))
         Free( @*this )
      EndIf
   EndProcedure
   
   Procedure   PropertiesButton_Create( *g2._s_WIDGET,  *row._s_ROW )
      ; ProcedureReturn
      If *row
         Protected *this._s_WIDGET
         Protected Type = GetItemData( *g2, *row\index )
         Protected X = DesktopUnscaledX(*row\x) + 30
         Protected Y = DesktopUnscaledY(*row\y + *g2\scroll_y( ))
         Protected Width = DesktopUnscaledX(*g2\inner_width( )) - 60
         Protected Height = DesktopUnscaledY(*row\height)
         
         PropertiesButton_Free(*g2)
         OpenList(*g2)
         *this = Button(X,Y,Width,Height, *row\txt(0)\text)
         CloseList()
         If *this
            SetActive(*this)
            SetData( *g2, *this )
            SetData( *this, *row\index )
            Bind( *this, @PropertiesButton_Events( ))
         EndIf
         ProcedureReturn *this
      EndIf
   EndProcedure
   
   ;-
   Procedure PropertiesItems_Events()
      Protected scrollPos
      Protected._s_ROW *t
      Protected._s_BTN *hoverBTN = EnteredButton( )
      Protected._s_ROW *row = WidgetEventData( )
      Protected._s_WIDGET *g = EventWidget( )
      Protected._s_WIDGET *this = GetData( *g2 )
      
      Select WidgetEvent( )
         Case #__EVENT_FOCUS
            If *this
               Debug "F "+*g\class
               SetActive(*this)
            EndIf
            
         Case #__EVENT_MouseWheel
            If WheelDirection( ) > 0
               Select *g
                     ; Case *g2 : SetState(*g1\scroll\v, GetState( *g1\scroll\v ) - WidgetEventData( ) )
                     ;Case *g1 : SetState(*g2\scroll\v, GetState( *g2\scroll\v ) - WidgetEventData( ) )
               EndSelect
               ; SetState(*g1\scroll\v, GetState( *g1\scroll\v ) - WidgetEventData( ) )
            EndIf
            
         Case #__EVENT_ScrollChange
            *row = *g2\RowFocused( )
            scrollPos = WidgetEventData( )
            
            Select *g
               Case *g2 
                  If GetState( *g1\scroll\v ) <> scrollPos
                     If SetState( *g1\scroll\v, scrollPos)
                        PropertiesButton_Resize( *this, *row )
                     EndIf
                  EndIf
               Case *g1 
                  If GetState( *g2\scroll\v ) <> scrollPos
                     If SetState( *g2\scroll\v, scrollPos)
                        PropertiesButton_Resize( *this, *row )
                     EndIf
                  EndIf
            EndSelect
            
            ; Debug "SCROLL ["+GetClass(*g)+"] "+GetState( *g\scroll\v ) +" "+ scrollPos
            
         Case #__EVENT_Resize
            If *g = *g2
               PropertiesButton_Resize( *this,  *g\RowFocused( ))
            EndIf
      EndSelect
      
      If *row
         Select WidgetEvent( )
            Case #__EVENT_Change ;: Debug "             ["+*row\index+"] "+*g\class +" change "
               PropertiesButton_Create(*g2, *row)
               
            Case #__EVENT_Up
               If Not *hoverBTN
                  If Not *row\childrens
                     SetState( *g, *row\index)
                  EndIf
               EndIf
               
            Case #__EVENT_LeftDown
               If  Not *hoverBTN
                  If Not *row\childrens
                     SetState( *g, *row\index)
                  Else 
                     If *row\mask & #__MASK_Press
                        *row\mask &~ #__MASK_Press
                        If ExpandRow( *g, *row)
                           Post(*g, #__EVENT_StatusChange, *row\rindex, *row)
                        EndIf
                     EndIf
                  EndIf
               EndIf
               
            Case #__EVENT_StatusChange
               ;                               If *g\mask & #__MASK_Active
               ;                                  If *g\RowFocused( ) And 
               ;                                     *g\RowFocused( )\ColorState( ) = #__s_3
               ;                                     *g\RowFocused( )\ColorState( ) = #__s_2
               ;                                     ProcedureReturn 0
               ;                                  EndIf
               ;                               EndIf
               
               Debug "             ["+*row\index+"] "+*g\class +" status "+ *row\ColorState( ) +" "+ Bool(*row\mask & #__MASK_Press)
               
               If *row\childrens
                  If *row\mask & #__MASK_Hover
                     If *g\mask & #__MASK_Press
                        If *row\mask & #__MASK_Press
                           If MouseDrag( )
                              *row\mask &~ #__MASK_Press
                              If *row\ColorState( ) = #__s_2 : *row\ColorState( ) = #__s_0 : EndIf
                           EndIf
                        Else
                           If *g\RowPressed( ) = *row 
                              ;\\  Expanded/Collapsed
                              Select *g
                                 Case *g1 : SetItemState(*g2, *row\rindex, GetItemState(*g, *row\rindex))
                                 Case *g2 : SetItemState(*g1, *row\rindex, GetItemState(*g, *row\rindex))
                              EndSelect
                              ;
                              PropertiesButton_Display( *g2)
                           EndIf
                        EndIf
                     EndIf
                     ;
                     SetCursor( *g,  #PB_Cursor_Hand)
                  Else
                     SetCursor( *g,  #PB_Cursor_Default)
                  EndIf
               Else
                  ;                   If *row\mask & #__MASK_Press 
                  ;                      SetState( *g, *row\index)
                  ;                   EndIf
               EndIf
               
               ;\\ status change
               Select *g
                  Case *g1  : StatusChange( *g2, *row )
                  Case *g2  : StatusChange( *g1, *row )
               EndSelect
               
            Case #__EVENT_MouseEnter
               
               ;                If SetState( *g2\scroll\v, 30)
               ;                   Debug "SCROLL ["+GetClass(*g)+"] "+*g\scroll\v\bar\page\pos
               ;                   PropertiesButton_Resize( *this, *g2\RowFocused( ) )
               ;                EndIf
               ;                
               
         EndSelect
      EndIf
      
      ProcedureReturn #PB_Ignore
   EndProcedure
   
   ;-
   Procedure   Properties_Events( )
      Select WidgetEvent( )
         Case #__EVENT_FOCUS
            ;             If *display
            ;                SetActive( *display )
            ;             EndIf
            
      EndSelect
   EndProcedure
   
   Procedure   Properties_AddItem( *splitter._s_WIDGET, item, Text.s, Type=-1, mode=0 )
      Protected *g1._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      Protected *g2._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      
      If mode
         AddItem( *g1, item, StringField(Text.s, 1, Chr(10)), -1, mode )
         AddItem( *g2, item, Text.s, -1, mode )
         ;     AddItem( *g2, item, StringField(Text.s, 2, Chr(10)), -1, mode )
      Else
         AddItem( *g1, item, UCase(StringField(Text.s, 1, Chr(10))), -1 )
         AddItem( *g2, item, "", -1, mode )
      EndIf
      
      item = CountItems( *g1 ) - 1
      If mode = 0
         Define color_properties.q = $FFBF9CC3;$BE80817D
         Define fcolor_properties.q = $CA2E2E2E
         
         
         ;                      SetItemFont( *g1, item, font_properties)
         ;                      SetItemFont( *g2, item, font_properties)
         
         SetItemColor( *g1, item, #PB_Gadget_FrontColor, fcolor_properties, 0, #PB_All )
         SetItemColor( *g2, item, #PB_Gadget_FrontColor, fcolor_properties, 0, #PB_All )
         
         SetItemColor( *g1, item, #__FrameColor,  $FF00FFFF, 0, #PB_All)
         SetItemColor( *g2, item, #__FrameColor,  $FF00FFFF, 0, #PB_All)   
         
         SetItemColor( *g1, item, #PB_Gadget_BackColor,  $FF00FFFF, 0, #PB_All)
         SetItemColor( *g2, item, #PB_Gadget_BackColor,  $FF00FFFF, 0, #PB_All)   
      Else
         SetItemColor( *g1, item, #PB_Gadget_BackColor, $FFFEFEFE)
         SetItemColor( *g2, item, #PB_Gadget_BackColor, $FFFEFEFE )
      EndIf
      
      SetItemData( *g2, item, Type )
   EndProcedure
   
   Procedure   Properties_Create( X,Y,Width,Height, Flag=0 )
      Protected position = Width/2-30
      Protected tflag.q = #__flag_BorderLess|#PB_Tree_NoLines|#__flag_Transparent;|#__flag_gridlines
      Protected *g._s_WIDGET
      
      *g1 = Tree(0,0,0,0, tflag)
      *g2 = Tree(0,0,0,0, tflag|#PB_Tree_NoButtons)
      ;    *g1\padding\x = 10
      ;    *g2\padding\x = 10
      *g = *g1
      ;*g\padding\x = DPIScaled(20)
      ;*g\fs[1] = DPIScaled(20)
      ;Resize(*g, #PB_Ignore, #PB_Ignore, 100, #PB_Ignore )
      
      *g = *g2
      ;*g\padding\x = DPIScaled(20)
      ;*g\fs[1] = DPIScaled(20)
      ;Resize(*g, #PB_Ignore, #PB_Ignore, 100, #PB_Ignore )
      
      Protected *splitter._s_WIDGET = Splitter(X,Y,Width,Height, *g1,*g2, Flag|#__flag_Transparent|#PB_Splitter_Vertical );|#PB_Splitter_firstFixed )
      SetAttribute(*splitter, #PB_Splitter_FirstMinimumSize, position/2+30 )
      SetAttribute(*splitter, #PB_Splitter_SecondMinimumSize, position/2+30 )
      ;
      *splitter\bar\btn\round = 0
      *splitter\bar\btn\size = DPIScaled(5)
      *splitter\bar\btn\size + Bool( *splitter\bar\btn\size % 2 )
      SetState(*splitter, (position) ) 
      
      ;
      SetClass(*g1\scroll\v, "g1_v")
      SetClass(*g1\scroll\h, "g1_h")
      SetClass(*g2\scroll\v, "g2_v")
      SetClass(*g2\scroll\h, "g2_h")
      
      ;
      ; Hide( *g1\scroll\v, 1 )
      Hide( *g1\scroll\h, 1 )
      Hide( *g2\scroll\h, 1 )
      
      ; CloseList( )
      ;  SetColor( *splitter, #PB_Gadget_BackColor, $FF00FFFF)
      ;       SetColor( *splitter, #PB_Gadget_BackColor, -1, #PB_All )
      ;  SetColor( *g1, #PB_Gadget_BackColor, $FF00FFFF)
      ;  SetColor( *g2, #PB_Gadget_BackColor, $FF00FFFF)
      ;       SetColor( *g1, #PB_Gadget_LineColor, $FFBF9CC3)
      ;       SetColor( *g2, #PB_Gadget_LineColor, $FFBF9CC3)
      
      ;
      Bind(*splitter, @Properties_Events( ))
      Bind(*g1, @PropertiesItems_Events( ))
      Bind(*g2, @PropertiesItems_Events( ))
      
      Bind(*g2, @PropertiesItems_Events( ), #__EVENT_Resize)
      ;Bind(*g2, @PropertiesItems_Events( ), #__EVENT_Draw)
      ProcedureReturn *splitter
   EndProcedure
   
   
   ;-
   Procedure all_events()
      Select WidgetEvent( )
         Case #__EVENT_FOCUS
            Debug "FOCUS "+ GetClass(EventWidget())
            
         Case #__EVENT_LOSTFOCUS
            Debug "LOSTFOCUS "+ GetClass(EventWidget())
            ;             If *display
            ;                SetActive( *display )
            ;             EndIf
            
      EndSelect
   EndProcedure
   
   
   Open(1, 100, 50, 400, 330, "demo items status", #PB_Window_SystemMenu)
   Properties_Create( 10, 10, 310, 310 )
   
   For a = 0 To CountItems
      If a % 5 = 0
         AddItem(*g1, a, "--- [ "+*g1\class +" "+ Str(a) +"] ---", -1, 0)
      EndIf
   Next
   For a = 0 To CountItems + 5
      If a % 5
         AddItem(*g1, a, "item "+Str(a), -1, 1)
      EndIf
   Next
   For a = 0 To CountItems
      If a % 5 = 0
         AddItem(*g2, a, "--- [ "+*g2\class +" "+ Str(a) +"] ---", -1, 0)
      EndIf
   Next
   For a = 0 To CountItems + 5
      If a % 5
         AddItem(*g2, a, "item "+Str(a), -1, 1)
      EndIf
   Next
   
   ;    a = 0
   ;    AddItem(*g1, a, "--- [] ---", -1, 0)
   ;    AddItem(*g2, a, "--- [] ---", -1, 0)
   
   
   ;       For a = 0 To CountItems
   ;          AddItem(*g2, -1, "item "+Str(a), -1, 1)
   ;       Next
   ;       For a = 0 To CountItems
   ;          If a % 5 = 0
   ;             AddItem(*g2, a, "--- ["+Str(a) +"] ---", -1, 0)
   ;          EndIf
   ;       Next
   
   ; 
   ;Repaint( )
   
   ;
   ;SetState(*g1, CountItems+4) : SetActive(*g1)
   SetState(*g2, CountItems+4); : SetActive(*g2)
   
   ;       ForEach *g1\row\__s( ) : Define._s_ROW *row = @*g1\row\__s( )
   ;          Debug ""+*row\index +"  " + *row\ColorState( )
   ;          
   ;          If *row\mask & #__MASK_Active
   ;             Debug ""+*row\index +" Active" 
   ;          EndIf
   ;          If *row\mask & #__MASK_Press
   ;             Debug ""+*row\index +" Press" 
   ;          EndIf
   ;       Next
;    
;    Button(330, 10, 60, 30,"multi")
;    Button(330, 50, 60, 30,"click")
;    Button(330, 90, 60, 30,"single")
;    
;    Procedure event_first_item()
;       Debug"---->>>---"
;       SetState( *g1, 0)
;       ;SetActive(*g1)
;       ;Repaint( )
;       Debug"----<<<---"
;    EndProcedure
;    Bind(Button(330, 130, 20, 30,"<"), @event_first_item(), #__EVENT_Down)
;    Procedure event_reset_item()
;       Debug"---->>>---"
;       SetState( *g1,  -1)
;       ;SetActive(*g1)
;       ;Repaint( )
;       Debug"----<<<---"
;    EndProcedure
;    Bind(Button(350, 130, 20, 30,"|"), @event_reset_item(), #__EVENT_Down)
;    Procedure event_last_item()
;       Debug"---->>>---"
;       SetState( *g1, CountItems(*g1))
;       ;SetActive(*g1)
;       ;Repaint( )
;       Debug"----<<<---"
;    EndProcedure
;    Bind(Button(370, 130, 20, 30,">"), @event_last_item(), #__EVENT_Down)
;    
   WaitClose(@all_events())
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 450
; FirstLine = 286
; Folding = -37v47-Ht-
; EnableXP
; DPIAware