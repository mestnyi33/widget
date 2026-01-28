IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_focus_draw = 1
   
   Global testbutton
   Global._s_WIDGET *first, *second, *focus
   
   Procedure   TestEvents( )
      Protected item 
      
      If WidgetEvent( ) = #__event_Focus  
         Debug ""
         Debug "focus "+EventWidget( )\class
         item = GetData( EventWidget( ))
         ChangeItemState( *first, item, 2 )
         ChangeItemState( *second, item, 2 )
      EndIf
      If WidgetEvent( ) = #__event_LostFocus  
         Debug "lostfocus "+EventWidget( )\class
         item = GetData( EventWidget( ))
         ChangeItemState( *first, item, 3 )
         ChangeItemState( *second, item, 3 )
      EndIf
      
      ProcedureReturn #PB_Ignore
   EndProcedure
   
   Procedure   TestCreate( Text$, item )
      If testbutton
         Unbind( testbutton, @TestEvents( ))
         Free( @testbutton )
      EndIf
      
      testbutton = Button(10,10,140,40,"["+Text$+"] "+Str(Item) ) 
      SetClass(testbutton, GetText(testbutton) )
      
      SetData( testbutton, item )
      Bind( testbutton, @TestEvents( ) )
   EndProcedure
   
   Procedure CallBack( )
      Protected._s_ROWS *row
      Protected._s_WIDGET *g
      
      *g = EventWidget( )
      If *g = *focus
         ProcedureReturn
      EndIf
      
      If WidgetEvent( ) = #__event_Focus  
         ; Debug "all focus "+EventWidget( )\class
      EndIf
      If WidgetEvent( ) = #__event_LostFocus  
         *row = WidgetEventData( )
         
         Debug "   all lostfocus "+*g\class +" "+ *row\ColorState( )
      EndIf
      
      If WidgetEvent( ) = #__event_Down 
         ; Debug "all down "+EventWidget( )\class
         If Not EnteredButton( )
            If SetState( *g, WidgetEventItem( ))
               TestCreate( *g\class, WidgetEventItem( ))
               
               If *first = *g
                  SetState(*second, WidgetEventItem( ))
               Else
                  SetState(*first, WidgetEventItem( ))
               EndIf
            EndIf
            
            ;
            If SetActive( testbutton) 
               Debug "  after [SetActive()]"
            EndIf
         EndIf
      EndIf
      
      If WidgetEvent( ) = #__event_Change
         Debug "all change "+*g\class
         ;          Select *g
         ;             Case *first : SetState(*second, GetState(*g))
         ;             Case *second : SetState(*first, GetState(*g))
         ;          EndSelect
      EndIf
   EndProcedure
   
   ;\\
   Open(0, 0, 0, 310, 210, "window_0", #PB_Window_SystemMenu | ;#PB_Window_NoActivate |
                                       #PB_Window_ScreenCentered |
                                       #PB_Window_MinimizeGadget |
                                       #PB_Window_MaximizeGadget )
   
   SetClass(Root( ), "window_0_root" )
   ;Container( 10,10,240,140 ) : SetClass(Widget( ), "window_0_root_container" )
   *focus = Button( 160, 10, 140, 40, "reset focus") 
   *first = Tree( 10,60,140,140 )
   *second = Tree( 160,60,140,140 )
   
   Define i
   For i=0 To 5
      AddItem(*first, -1, "["+Str(i)+"]item")
      AddItem(*second, -1, "["+Str(i)+"]item")
   Next
   
   Bind( #PB_All, @CallBack( ))
   
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 99
; FirstLine = 38
; Folding = ---
; EnableXP