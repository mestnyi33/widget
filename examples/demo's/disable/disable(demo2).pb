XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
   EnableExplicit
   UseWidgets( )
   Global *enable, *disable, *panel, *item1, *item2, *item3
   Global event =#__event_LeftDown ; #__event_LeftClick ; 
   
   Procedure Events( )
      Select EventWidget( ) 
         Case *item1
            SetState( *panel, 0)
         Case *item2
            SetState( *panel, 1)
         Case *item3
            SetState( *panel, 2)
            
         Case *enable
            Debug "enable"
            Disable( *panel, 0 )
            Disable( *enable, 1 )
            If Disable( *disable )
               Disable( *disable, 0 )
            EndIf
            
         Case *disable
            Debug "disable"
            Disable( *panel, 1 )
            Disable( *disable, 1 )
            If Disable( *enable )
               Disable( *enable, 0 )
            EndIf
            
      EndSelect
   EndProcedure
   
   If Open(0, 0, 0, 300, 195, "Disable-demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      *panel = Panel(10,10,280,145)
         Disable(*panel, 1)
         AddItem(*panel, -1, "item-1")
         Button( 10, 10, 70, 25, "enable-[0]") 
         Button( 10, 40, 70, 25, "disable-[1]") 
         Disable( widget( ), 1 )
         AddItem(*panel, -1, "item-2")
         Button( 10, 10, 70, 25, "disable-[2]") 
         Disable( widget( ), 1 )
         AddItem(*panel, -1, "item-3")
         Button( 10, 10, 70, 25, "enable-[3]") 
      CloseList( )
      
      *item1 = Button( 10, 160, 50, 25, "item-1") : SetClass( *item1, "button-item-1" )
      *item2 = Button( 60, 160, 50, 25, "item-2") : SetClass( *item2, "button-item-2" )
      *item3 = Button( 110, 160, 50, 25, "item-3") : SetClass( *item3, "button-item-3" )
      Bind( *item1, @events( ), event )
      Bind( *item2, @events( ), event )
      Bind( *item3, @events( ), event )
      
      *disable = Button( 180, 160, 50, 25, "disable") : SetClass( *disable, "button-disable" )
      *enable = Button( 240, 160, 50, 25, "enable") : SetClass( *enable, "button-enable" )
      
      Disable(*disable, 1)
      
      Bind( *enable, @events( ), event )
      Bind( *disable, @events( ), event )
      
      WaitClose( )
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 61
; FirstLine = 33
; Folding = --
; EnableXP
; DPIAware