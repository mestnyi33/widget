
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
   Procedure   PropertiesButton_Events( )
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
            ; SetActive(*this)
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
      If *row
         Protected *this._s_WIDGET
         Protected Type = GetItemData( *g2, *row\index )
         Protected X = DesktopUnscaledX(*row\x)
         Protected Y = DesktopUnscaledY(*row\y + *g2\scroll_y( ))
         Protected Width = DesktopUnscaledX(*g2\inner_width( ))
         Protected Height = DesktopUnscaledY(*row\height)
         
         PropertiesButton_Free(*g2)
         OpenList(*g2)
         *this = Button(X,Y,Width,Height, *row\txt(0)\text)
         CloseList()
         If *this
            SetData( *g2, *this )
            SetData( *this, *row\index )
            Bind( *this, @PropertiesButton_Events( ))
         EndIf
         ProcedureReturn *this
      EndIf
   EndProcedure
   
   ;    Procedure SetCursorPos( *this._s_WIDGET, X,Y )
   ;        cursor::SetPos( *this\root\canvas\gadget, *g2\inner_x( )  + *g2\scroll_x( ) + X, *g2\inner_y( )  + *g2\scroll_y( ) + Y )
   ;                     
   ;    EndProcedure
   
   ;-
   Procedure all_events()
      Static._s_WIDGET *this
      Protected._s_ROW *t
      Protected._s_BTN *hoverBTN = EnteredButton( )
      Protected._s_ROW *row = WidgetEventData( )
      Protected._s_WIDGET *g = EventWidget( )
      
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
               If *g\RowFocused( ) And 
                  *g\RowFocused( )\ColorState( ) = #__s_3
                  *g\RowFocused( )\ColorState( ) = #__s_2
                  ProcedureReturn 0
               EndIf
               
               ; Debug "             ["+*row\index+"] "+*g\class +" status "
               
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
                     
                     SetCursor( *g,  #PB_Cursor_Hand)
                  Else
                     SetCursor( *g,  #PB_Cursor_Default)
                  EndIf
               Else
                  ;                   If *row\mask & #__MASK_Press 
                  ;                      SetState( *g, *row\index)
                  ;                   EndIf
               EndIf
               
               ;\\
               Select *g
                  Case *g1  : StatusChange( *g2, *row )
                  Case *g2  : StatusChange( *g1, *row )
               EndSelect
               
            Case #__EVENT_MouseEnter
               
               ;                If SetState( *g2\scroll\v, 30)
               ;                   Debug "SCROLL ["+GetClass(*g)+"] "+*g\scroll\v\bar\page\pos
               ;                   PropertiesButton_Resize( GetData( *g2 ), *g2\RowFocused( ) )
               ;                EndIf
               ;                
               
         EndSelect
      EndIf
      
      Select WidgetEvent( )
         Case #__EVENT_ScrollChange
            *this = GetData( *g2 )
            *row = *g2\RowFocused( )
            
            Select *g
               Case *g2 
                  If GetState( *g1\scroll\v ) <> WidgetEventData( )
                     If SetState( *g1\scroll\v, WidgetEventData( ))
                        PropertiesButton_Resize( *this, *row )
                     EndIf
                  EndIf
                  ;
               Case *g1 
                  If GetState( *g2\scroll\v ) <> WidgetEventData( )
                     If SetState( *g2\scroll\v, WidgetEventData( ))
                        PropertiesButton_Resize( *this, *row )
                     EndIf
                  EndIf
            EndSelect
            
            Debug "SCROLL ["+GetClass(*g)+"] "+GetState( *g\scroll\v ) +" "+ WidgetEventData( )
            
         Case #__EVENT_Resize
            If *g = *g2
               PropertiesButton_Resize( GetData( *g2 ),  *g\RowFocused( ))
            EndIf
            
            
      EndSelect
      
   EndProcedure
   
   Open(1, 100, 50, 400, 330, "demo items status", #PB_Window_SystemMenu)
   *g1 = Tree(10, 10, 150, 310, #__flag_nolines ) : SetClass(*g1, "*g1") : Hide( HBar(*g1), #True ) ;: Hide( VBar(*g1), #True )
   *g2 = Tree(170, 10, 150, 310, #__flag_nolines ) : SetClass(*g2, "*g2") : Hide( HBar(*g2), #True )
   Splitter( 10,10, 310, 310, *g1, *g2, #PB_Splitter_Vertical)
   
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
   Repaint( )
   
   ;
   SetState(*g1, CountItems+4) : SetActive(*g1)
   ; SetState(*g2, CountItems+4) : SetActive(*g2)
   
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
   
   Button(330, 10, 60, 30,"multi")
   Button(330, 50, 60, 30,"click")
   Button(330, 90, 60, 30,"single")
   
   Procedure event_first_item()
      Debug"---->>>---"
      SetState( *g1, 0)
      SetActive(*g1)
      Repaint( )
      Debug"----<<<---"
   EndProcedure
   Bind(Button(330, 130, 20, 30,"<"), @event_first_item(), #__EVENT_Down)
   Procedure event_reset_item()
      Debug"---->>>---"
      SetState( *g1,  -1)
      SetActive(*g1)
      Repaint( )
      Debug"----<<<---"
   EndProcedure
   Bind(Button(350, 130, 20, 30,"|"), @event_reset_item(), #__EVENT_Down)
   Procedure event_last_item()
      Debug"---->>>---"
      SetState( *g1, CountItems(*g1))
      SetActive(*g1)
      Repaint( )
      Debug"----<<<---"
   EndProcedure
   Bind(Button(370, 130, 20, 30,">"), @event_last_item(), #__EVENT_Down)
   
   Bind(*g2, @all_events(), #__EVENT_Resize)
   ;
   Bind(*g1, @all_events(), #__EVENT_LeftDown)
   Bind(*g2, @all_events(), #__EVENT_LeftDown)
   Bind(*g1, @all_events(), #__EVENT_Up)
   Bind(*g2, @all_events(), #__EVENT_Up)
   
   Bind(*g1, @all_events(), #__EVENT_ScrollChange)
   Bind(*g2, @all_events(), #__EVENT_ScrollChange)
   
   Bind(*g1, @all_events(), #__EVENT_StatusChange)
   Bind(*g2, @all_events(), #__EVENT_StatusChange)
   
   Bind(*g1, @all_events(), #__EVENT_Change)
   Bind(*g2, @all_events(), #__EVENT_Change)
   
   Bind(*g1, @all_events(), #__EVENT_MouseEnter)
   
   WaitClose()
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 124
; FirstLine = 117
; Folding = ---f----
; EnableXP
; DPIAware