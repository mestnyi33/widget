
IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   test_StatusChange  = 1
      
   Global a, CountItems = 10
   Global._s_WIDGET *g, *g1, *g2
   
   Procedure   PropertiesButton_Events( )
   EndProcedure
   
   Procedure   PropertiesButton_Resize( *g2._s_WIDGET )
      Protected._s_ROW *row = *g2\RowFocused( )
      Protected._s_WIDGET *this = GetData( *g2 )
      Protected result
      
      If *row
         If *this
            Debug 777
            result = Resize( *this,
                             *row\x,
                             *row\y + *g2\scroll_y( ),
                             *g2\inner_width( ),
                             *row\height, 0 )
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
   
   
   Procedure all_events()
      Static._s_WIDGET *this
      Protected._s_ROW *row
      *g = EventWidget( )
      *row = WidgetEventData( )
      
      If *row
         Select WidgetEvent( )
            Case #__event_LeftDown
               If SetState( *g, *row\index)
                  DoEvents( *g, #__event_StatusChange, *row\index, *row )
               EndIf
               
            Case #__event_Change
               Debug "             ["+*row\index+"] "+*g\class +" change "
              ; *this = PropertiesButton_Create(*g2, *row)
              ; Repaint()
               
            Case #__event_StatusChange
               Select *g
                  Case *g1  : StatusChange( *g2, *row )
                  Case *g2  : StatusChange( *g1, *row )
               EndSelect
               Debug "             ["+*row\index+"] "+*g\class +" status "
               
         EndSelect
      EndIf
   EndProcedure
   
   If Open(1, 100, 50, 330, 330, "demo items status", #PB_Window_SystemMenu)
      *g1 = Tree(10, 10, 150, 310, #__flag_nolines ) : SetClass(*g1, "*g1")
      *g2 = Tree(170, 10, 150, 310, #__flag_nolines ) : SetClass(*g2, "*g2")
      
      For a = 0 To CountItems
         AddItem(*g1, -1, "item "+Str(a), -1, 0)
      Next
      For a = 0 To CountItems
         AddItem(*g2, -1, "item "+Str(a), -1, 0)
      Next
      
      ;  
     SetState(*g1, CountItems) : SetActive(*g1)
     ;   SetState(*g2, CountItems): SetActive(*g2)
      
      ;
      Bind(*g1, @all_events(), #__event_LeftDown)
      Bind(*g2, @all_events(), #__event_LeftDown)
      
      Bind(*g1, @all_events(), #__event_StatusChange)
      Bind(*g2, @all_events(), #__event_StatusChange)
      
      Bind(*g1, @all_events(), #__event_Change)
      Bind(*g2, @all_events(), #__event_Change)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 90
; FirstLine = 72
; Folding = ---
; EnableXP
; DPIAware