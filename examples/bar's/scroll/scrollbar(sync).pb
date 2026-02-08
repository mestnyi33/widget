; 
; demo state

IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ;test_focus_draw = 1
   ;test_focus_set = 1
   
   Global a, CountItems = 20
   Global._s_WIDGET *demo, *this
   
   Procedure widget_events()
      
      Select WidgetEvent( )
         Case #__event_ScrollChange
            Select EventWidget( )
               Case *demo 
                  If GetState( *this\scroll\v ) <> WidgetEventData( )
                     SetState(*this\scroll\v, WidgetEventData( ))
                  EndIf
               Case *this 
                  If GetState( *demo\scroll\v ) <> WidgetEventData( )
                     SetState(*demo\scroll\v, WidgetEventData( ))
                  EndIf
            EndSelect
      EndSelect
       
   EndProcedure
   
   If Open(1, 100, 50, 330, 330, "demo ListView state", #PB_Window_SystemMenu)
      *demo = Tree(10, 10, 150, 310, #__flag_nolines ) : SetClass(*demo, "demo")
      *this = Tree(170, 10, 150, 310, #__flag_nolines ) : SetClass(*this, "this")
      
      For a = 0 To CountItems
         AddItem(*demo, -1, "item "+Str(a), -1, 0)
      Next
      For a = 0 To CountItems
         AddItem(*this, -1, "item "+Str(a), -1, 0)
      Next
      
      Bind(*demo, @widget_events(), #__event_ScrollChange)
      Bind(*this, @widget_events(), #__event_ScrollChange)
      
      WaitClose()
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 26
; FirstLine = 13
; Folding = --
; EnableXP
; DPIAware