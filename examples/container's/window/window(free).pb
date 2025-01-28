; ver: 3.0.0.0 ; 
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
                     *window = Window(100,100,200,200,"window", #__window_systemmenu|#__window_maximizegadget|#__window_minimizegadget)
                     Button(10, 10, 90,30,"button")
                     Button(10, 50, 90,30,"button")
                     ;*window = Button(Random(100,10), 10, 90,30,"button")
                     ;Bind( *window, @events_() )
                  EndIf
                  
               Case *buttonClose
                  Free( *window )
                  ReDraw( root())
                  *window = 0
                  
               Case *buttonTest
                  ForEach widgets( )
                     Debug widgets( )\class
                  Next
            EndSelect
      EndSelect
   EndProcedure
   
   Open(0, 150, 150, 500, 400, "demo close", #__Window_SizeGadget | #__Window_SystemMenu)
   
   *window = Window(100,100,200,200,"window", #__window_systemmenu|#__window_maximizegadget|#__window_minimizegadget)
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
         Case #__event_Maximize
            Debug "disable maximize"
            ProcedureReturn #PB_Ignore
            
         Case #__event_Minimize
            Debug "disable minimize"
            ProcedureReturn #PB_Ignore
            
         Case #__event_Close
            Debug "disable close"
            ProcedureReturn #PB_Ignore
            
      EndSelect
   EndProcedure
   Bind( *window, @events_buttons( ) )
   
   ;
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 64
; FirstLine = 44
; Folding = --
; EnableXP
; DPIAware