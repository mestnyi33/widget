
IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global a, CountItems = 10
   Global._s_WIDGET *g, *first, *second
   
   Procedure all_events()
      *g = EventWidget( )
      
      Select WidgetEvent( )
         Case #__event_Change
            Protected._s_WIDGET *g1 = GetAttribute(*g, #PB_Splitter_FirstGadget)
            Protected._s_WIDGET *g2 = GetAttribute(*g, #PB_Splitter_SecondGadget)
            Debug "  [+] change "+*g1\class + *g1\x[#__c_draw] +" "+ *g1\y[#__c_draw] +" "+ *g1\width[#__c_draw] +" "+ *g1\height[#__c_draw]
            Debug "    [+] change "+*g2\class + *g2\x[#__c_draw] +" "+ *g2\y[#__c_draw] +" "+ *g2\width[#__c_draw] +" "+ *g2\height[#__c_draw]
            
      EndSelect
   EndProcedure
   
   Procedure AddCaption( *this._s_PARENT, Width, Height, Text.s, Flag.q = #__align_auto ) 
      Protected *g._s_WIDGET
      *this\fs[2] = Height
      ;SetFrame(*this, 1)
      OpenList(*this,#PB_Ignore)
      *g = Button( 0,0,Width,Height-Bool(*this\fs), Text.s, #__flag_Left )
      CloseList( )
      
      ;*g\index + 2
      ;SetParent(*g, *this);,#PB_Ignore)
      If Flag & #__align_auto
         SetAlign( *g, 0, #__align_auto,1,#__align_auto,0, 0 )              
      EndIf
      ;Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
   EndProcedure
   
   
   Procedure.s hextw( *this._s_WIDGET)
      If *this\next[1]
         ProcedureReturn " - "+*this\next[1]\class
      EndIf
   EndProcedure

   If Open(1, 100, 50, 330, 330, "demo items status", #PB_Window_SystemMenu)
      *first = Tree(10, 10, 150, 310, #__flag_nolines ) : SetClass(*first, "first")
      
      *second = Tree(170, 10, 150, 310, #__flag_nolines ) : SetClass(*second, "second")
      
      AddCaption(*first, 100,30, "caption1")
      AddCaption(*second, 100,30, "caption2")
      Bind(Splitter(10, 10, 310, 310, *first, *second, #PB_Splitter_Vertical), @all_events(), #__event_Change)
      ;Bind(Splitter(10, 10, 310, 310, 0, 0, #PB_Splitter_Vertical), @all_events(), #__event_Change)
;       Define._s_WIDGET *cont = Container(10, 100, 310, 210)
;       SetParent(*first, *cont)
;       SetParent(*second, *cont)
      
;       Resize( *first, #PB_Ignore, #PB_Ignore, 80, #PB_Ignore )
;       Resize( *second, #PB_Ignore, #PB_Ignore, 140, #PB_Ignore )
      
      
;       Debug "--- enumerate all gadgets ---"
;       If StartEnum( Root( ) )
;          If Not is_window_( Widget(  ) )
;             Debug "     gadget - "+ Index( Widget( ) ) +" "+ Level( Widget( ) ) +" "+ Widget( )\class +" "+ hextw(Widget())
;          EndIf
;          StopEnum( )
;       EndIf
      
      For a = 0 To CountItems
         AddItem(*first, -1, "item "+Str(a), -1, 0)
      Next
      For a = 0 To CountItems
         AddItem(*second, -1, "item - "+Str(a), -1, 0)
      Next
      
      ;Repaint( )
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 37
; FirstLine = 35
; Folding = --
; EnableXP
; DPIAware