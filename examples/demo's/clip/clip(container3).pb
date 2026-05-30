  IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure EventsHandler( )
      Protected event = WidgetEvent( ) 
      Protected g = EventWidget( )
   EndProcedure
   
   ;-\\ OPENROOT1
   Global._s_PARENT *c, *p
   Open(0, 0, 0, 500, 500, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   
   
   *c = Panel(5, 5, 210, 100, #__Panel_Right)
   AddItem(*c, -1, "item-0")
   *p = Panel(10, 5, 150, 65)
   AddItem(*p, -1, "1")
   Container(10, 5, 150, 55, #PB_Container_Flat)
   Container(10, 5, 150, 55, #PB_Container_Flat)
   Button(10, 5, 50, 25, "butt1")
   CloseList( )
   CloseList( )
   
   AddItem(*p, -1, "2")
   Container(10, 5, 150, 55, #PB_Container_Flat)
   Container(10, 5, 150, 55, #PB_Container_Flat)
   Button(10, 5, 50, 25, "butt2")
   CloseList( )
   CloseList( )
   
   CloseList( ) ; *p
   CloseList( ) ; *c
   
   String( 5, 145, 150, 22, "str")
   

   
   
   ; SetState( *panel, 2 )
        Debug "----------next------------"
      Define *root._s_ROOT = Root( )
      Define *e._s_WIDGET = *root\first
      While *e
         Debug "  "+*e\class +" "+ *e\text\Str(0)
         *e = *e\next[0]
      Wend
      Debug "----------prev------------"
      Define._s_WIDGET *e = GetLast(*root) ; BUTTON_2
      While *e
         Debug "  "+*e\class +" "+ *e\text\Str(0)
         *e = *e\prev[0]
      Wend
      Debug "----------end-------------"
      
      WaitClose( @EventsHandler( ))
 CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 15
; FirstLine = 12
; Folding = -
; EnableXP
; DPIAware