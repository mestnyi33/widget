;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile 
   EnableExplicit
   Global *enable, *disable, *panel, *item1, *item2, *item3
   
   Procedure MouseState( )
      Static press.b
      Protected state.b, GadgetID
      
      CompilerSelect #PB_Compiler_OS 
         CompilerCase #PB_OS_Linux
            Protected desktop_x, desktop_y, handle, *GdkWindow.GdkWindowObject = gdk_window_at_pointer_( @desktop_x, @desktop_y )
            
            If *GdkWindow
               gdk_window_get_pointer_(*GdkWindow, @desktop_x, @desktop_y, @mask)
            EndIf
            
            If mask & 256; #GDK_BUTTON1_MASK
               state = 1
            EndIf
            If mask & 512 ; #GDK_BUTTON3_MASK
               state = 3
            EndIf
            If mask & 1024 ; #GDK_BUTTON2_MASK
               state = 2
            EndIf
            
         CompilerCase #PB_OS_Windows
            state = GetAsyncKeyState_(#VK_LBUTTON) >> 15 & 1 + 
                    GetAsyncKeyState_(#VK_RBUTTON) >> 15 & 2 + 
                    GetAsyncKeyState_(#VK_MBUTTON) >> 15 & 3 
            
         CompilerCase #PB_OS_MacOS
            state = CocoaMessage(0, 0, "NSEvent pressedMouseButtons") ; class var pressedMouseButtons: Int { get }
            
            ;Debug CocoaMessage(0, 0, "buttonNumber") ; var buttonNumber: Int { get }
            ;Debug CocoaMessage(0, 0, "clickCount") ; var clickCount: Int { get }
      CompilerEndSelect
      
      If press <> state
         If state
            If state = 1
               Debug "LeftDown - "
               
               CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                  Protected Cursorpos.q
                  GetCursorPos_( @Cursorpos )
                  GadgetID = WindowFromPoint_( Cursorpos )
               CompilerEndIf
               
               Select GadgetID
                  Case GadgetID(*disable)
                     PostEvent( #PB_Event_Gadget, EventWindow(), *disable, #PB_EventType_LeftButtonDown )
                  Case GadgetID(*enable)
                     PostEvent( #PB_Event_Gadget, EventWindow(), *enable, #PB_EventType_LeftButtonDown )
               EndSelect
               
            ElseIf state = 2
               Debug "RightDown - "
            EndIf
            
         Else
            If press = 1
               Debug "LeftUp - "
               ;DoEvents( #PB_EventType_LeftButtonUp )
            ElseIf press = 2
               Debug "RightUp - "
            EndIf
         EndIf
         press = state
      EndIf
      
   EndProcedure
   
   Procedure Disable( Gadget, state = #PB_Default )
      If IsGadget(Gadget) 
         If state >= 0
            DisableGadget( Gadget, state )
            SetGadgetData( Gadget, state )
         EndIf
         
         ProcedureReturn GetGadgetData( Gadget )
      EndIf
   EndProcedure
   
   Procedure Events( )
      Select EventGadget( ) 
         Case *item1
            SetGadgetState( *panel, 0)
         Case *item2
            SetGadgetState( *panel, 1)
         Case *item3
            SetGadgetState( *panel, 2)
            
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
   
   If OpenWindow(0, 0, 0, 300, 195, "Disable-demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      *panel = PanelGadget(#PB_Any, 10,10,280,145)
      DisableGadget(*Panel, 1)
      AddGadgetItem(*panel, -1, "item-1")
      ButtonGadget(#PB_Any,  10, 10, 70, 25, "enable-[0]") 
      DisableGadget( ButtonGadget(#PB_Any,  10, 40, 70, 25, "disable-[1]") , 1 )
      AddGadgetItem(*panel, -1, "item-2")
      
      DisableGadget( ButtonGadget(#PB_Any,  10, 10, 70, 25, "disable-[2]") , 1 )
      AddGadgetItem(*panel, -1, "item-3")
      ButtonGadget(#PB_Any,  10, 10, 70, 25, "enable-[3]") 
      CloseGadgetList( )
      
      *item1 = ButtonGadget( #PB_Any, 10, 160, 50, 25, "item-1") ;: SetClass( *item1, "button-item-1" )
      *item2 = ButtonGadget( #PB_Any, 60, 160, 50, 25, "item-2") ;: SetClass( *item2, "button-item-2" )
      *item3 = ButtonGadget( #PB_Any, 110, 160, 50, 25, "item-3");: SetClass( *item3, "button-item-3" )
      BindGadgetEvent( *item1, @events( ), #PB_EventType_LeftClick )
      BindGadgetEvent( *item2, @events( ), #PB_EventType_LeftClick )
      BindGadgetEvent( *item3, @events( ), #PB_EventType_LeftClick )
      
      *disable = ButtonGadget( #PB_Any, 180, 160, 50, 25, "disable") ;: SetClass( *disable, "button-disable" )
      *enable = ButtonGadget( #PB_Any, 240, 160, 50, 25, "enable")   ;: SetClass( *enable, "button-enable" )
      BindGadgetEvent( *enable, @events( ), #PB_EventType_LeftButtonDown )
      BindGadgetEvent( *disable, @events( ), #PB_EventType_LeftButtonDown )
      
      Define event
      Define Cursorpos.q
      Repeat
         event = WaitWindowEvent()
         MouseState( )
      Until event = #PB_Event_CloseWindow
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 143
; FirstLine = 115
; Folding = ----
; EnableXP
; DPIAware