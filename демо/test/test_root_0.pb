XIncludeFile "../../widgets.pbi" 
CompilerIf #PB_Compiler_IsMainFile ;= 99
   EnableExplicit
   UseWidgets( )
   
   ; test_focus_set = 2
   Global *menu._s_WIDGET
   Procedure all_events( )
      Protected event$
      If WidgetEvent( ) = #__event_MouseMove
         ProcedureReturn 0
      EndIf
      
      event$ = EventString(WidgetEvent( ))
     
      Debug " ["+GetClass(EventWidget( )) +"] "+ event$ +" "+ WidgetEventData( )
   EndProcedure
   
   Define Flag.q = #PB_Canvas_DrawFocus
   
   Procedure TestRoot( Gadget, X,Y,Width,Height, Flag=0 )
      Protected *g
      *g = Open(Gadget, X,Y,Width,Height,"", Flag, 0, Gadget) 
      SetBackColor(*g, RGB( Random(255), Random(255), Random(255) ))
      SetText(*g, Str(Gadget))
      SetClass(*g, Str(Gadget))
      
      ;       *menu = CreatePopupBar( )
      ;       BarItem( 1, "item 1") 
      ;       BarItem( 2, "item 2") 
      ;Bind( *menu, @all_events( ))
      
      *menu = ComboBox(50, 50, 250, 50)
      AddItem(*menu, -1, "ComboBox item 1")
      AddItem(*menu, -1, "ComboBox item 2")
      AddItem(*menu, -1, "ComboBox item 3")
      
      
      ;Bind( *g, @all_events( ))
      Bind( *menu\ComboBar( ), @all_events( ))
      
   EndProcedure
   
   Procedure TestWindow( ID )
      Static X,Y
      OpenWindow( ID, 300+X,150+Y,170,170,"window_"+Str(ID), #PB_Window_BorderLess)
      TestRoot( ID, 10, 0, 160, 170 )
      
      X + 100
      Y + 100
      ProcedureReturn 1
   EndProcedure
   
   If TestWindow( 10 )
      TestWindow( 30 )
      
      ;    If OpenWindow(0, 0, 0, 370, 370, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ;       TestRoot(10, 10, 10, 150, 150,flag) 
      ;       
      ;       TestRoot(20, 210, 10, 150, 150,flag) 
      ;       
      ;       TestRoot(30, 10, 210, 150, 150,flag) 
      ;       
      ;       TestRoot(40, 210, 210, 150, 150,flag) 
      
      
      ;Bind( #PB_All, @all_events( ))
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 13
; FirstLine = 6
; Folding = --
; EnableXP
; DPIAware