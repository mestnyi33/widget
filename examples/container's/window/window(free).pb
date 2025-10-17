; ver: 3.0.0.0 ; 
; sudo adduser your_username vboxsf
; https://linuxrussia.com/sh-ubuntu.html
; http://forums.purebasic.com/english/viewtopic.php?p=577957

XIncludeFile "../../../widgets.pbi" 


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   UsePNGImageDecoder()
   Declare CreateNewWindow( )
   Global *window, *buttonOpen, *buttonClose, *buttonTest
   
   ; disable window buttons events (MAXIMIZE|MINIMIZE|CLOSE)
   Procedure events_buttons()
      Select WidgetEvent( ) 
         Case #__event_Free
            Debug " do free " + EventWidget( )\class
            ProcedureReturn #True
      
         Case #__event_Maximize
            Debug "[disable] - max button state"
            ProcedureReturn #False
            
         Case #__event_Minimize
            Debug "[disable] - min button state"
            ProcedureReturn #False
            
         Case #__event_Close
            Debug "[disable] - close button state"
            ProcedureReturn #False
            
      EndSelect
   EndProcedure
   
   Procedure events_gadgets()
      Select EventType( ) 
         Case #PB_EventType_LeftClick
            Select EventGadget()
               Case *buttonOpen
                  If Not *window
                     *window = CreateNewWindow( )
                     ;Bind( *window, @events_gadgets() )
                     
                     HideGadget( *buttonTest, 0 )
                     HideGadget( *buttonClose, 0 )
                  EndIf
                  
               Case *buttonClose
                  HideGadget( *buttonTest, 1 )
                  HideGadget( *buttonClose, 1 )
                  
                  ;If *window
                  Free( @*window )
                  
                  ;ReDraw( root())
                  Debug "click "+*window
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
   
   Procedure CreateNewWindow( )
      Protected *window = Window(100,100,200,200,"window", #PB_Window_SystemMenu|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget)
      Define *g1=Button(10, 10, 90,30,"button")
      Define *g2=Button(10, 50, 90,30,"button")
      
      Splitter( 10,90,100,100,*g1,*g2 )
      
      Debug "" + root( )\haschildren
                  
      Bind( *window, @events_buttons( ) )
      ProcedureReturn *window
   EndProcedure
   
   Open(0, 150, 150, 500, 400, "demo close", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
   
   *window = CreateNewWindow( )
   
   *buttonTest = ButtonGadget(#PB_Any, 500-100, 400-120, 90,30,"test")
   *buttonClose = ButtonGadget(#PB_Any, 500-100, 400-80, 90,30,"close")
   *buttonOpen = ButtonGadget(#PB_Any, 500-100, 400-40, 90,30,"open")
   
   BindGadgetEvent( *buttonTest, @events_gadgets() )
   BindGadgetEvent( *buttonOpen, @events_gadgets() )
   BindGadgetEvent( *buttonClose, @events_gadgets() )
   
   ;
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 32
; FirstLine = 33
; Folding = --
; EnableXP
; DPIAware