﻿; ver: 3.0.0.0 ; 
; sudo adduser your_username vboxsf
; https://linuxrussia.com/sh-ubuntu.html
; http://forums.purebasic.com/english/viewtopic.php?p=577957

XIncludeFile "../../../widgets.pbi" 


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   UsePNGImageDecoder()
   
   Global *window, *buttonOpen, *buttonClose, *buttonTest
   
   Procedure events_gadgets()
      Select EventType( ) 
         Case #PB_EventType_LeftClick
            Select EventGadget()
               Case *buttonOpen
                  If Not *window
                     *window = Window(100,100,200,200,"window", #PB_Window_SystemMenu|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget)
                     Button(10, 10, 90,30,"button")
                     Button(10, 50, 90,30,"button")
                     ;*window = Button(Random(100,10), 10, 90,30,"button")
                     Bind( *window, @events_gadgets() )
                     
                     HideGadget( *buttonTest, 0 )
                     HideGadget( *buttonClose, 0 )
                  EndIf
                  
               Case *buttonClose
                  HideGadget( *buttonTest, 1 )
                  HideGadget( *buttonClose, 1 )
                  
                  ;If *window
                  Free( @*window )
                  
                  ;ReDraw( root())
                  ;Debug *window
                  *window = 0
                  
                  ;EndIf
                  
               Case *buttonTest
                  ForEach widgets( )
                     Debug widgets( )\class
                  Next
            EndSelect
      EndSelect
      
      ProcedureReturn #PB_Ignore
   EndProcedure
   
   Open(0, 150, 150, 500, 400, "demo close", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
   
   *window = Window(100,100,200,200,"window", #PB_Window_SystemMenu|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget)
   Button(10, 10, 90,30,"button")
   Button(10, 50, 90,30,"button")
   
   *buttonTest = ButtonGadget(#PB_Any, 500-100, 400-120, 90,30,"test")
   *buttonClose = ButtonGadget(#PB_Any, 500-100, 400-80, 90,30,"close")
   *buttonOpen = ButtonGadget(#PB_Any, 500-100, 400-40, 90,30,"open")
   
   BindGadgetEvent( *buttonTest, @events_gadgets() )
   BindGadgetEvent( *buttonOpen, @events_gadgets() )
   BindGadgetEvent( *buttonClose, @events_gadgets() )
   
   
   ; disable window buttons events (MAXIMIZE|MINIMIZE|CLOSE)
   Procedure events_buttons()
      Select WidgetEvent( ) 
         Case #__event_Free
            Debug "FREE " + EventWidget( )\class
            
         Case #__event_Maximize
            Debug "disable maximize button state"
            ProcedureReturn #False
            
         Case #__event_Minimize
            Debug "disable minimize button state"
            ProcedureReturn #False
            
         Case #__event_Close
            Debug "disable close button state"
            ProcedureReturn #False
            
      EndSelect
      
      ProcedureReturn #True
   EndProcedure
   Bind( *window, @events_buttons( ) )
   
   ;
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 95
; FirstLine = 54
; Folding = --
; EnableXP
; DPIAware