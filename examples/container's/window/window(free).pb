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
  
  Procedure events_()
    Select WidgetEvent( ) 
      Case #__event_Maximize
        Debug "maximize"
        ProcedureReturn #PB_Ignore
        
      Case #__event_Minimize
        Debug "minimize"
        ProcedureReturn #PB_Ignore
        
      Case #__event_Close
        Debug "close"
        ;Message("","",#PB_MessageRequester_Ok)
        *window = 0
        
        ProcedureReturn #PB_Ignore
    EndSelect
  EndProcedure
  
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
  *buttonTest = ButtonGadget(#PB_Any, 500-100, 400-120, 90,30,"test")
  *buttonClose = ButtonGadget(#PB_Any, 500-100, 400-80, 90,30,"close")
  *buttonOpen = ButtonGadget(#PB_Any, 500-100, 400-40, 90,30,"open")
  
  *window = Window(100,100,200,200,"window", #__window_systemmenu|#__window_maximizegadget|#__window_minimizegadget)
  Button(10, 10, 90,30,"button")
  Button(10, 50, 90,30,"button")
  ;*window = Button(10, 10, 90,30,"button")

  ;Bind( *window, @events_() )
  BindGadgetEvent( *buttonTest, @events_gadgets() )
  BindGadgetEvent( *buttonOpen, @events_gadgets() )
  BindGadgetEvent( *buttonClose, @events_gadgets() )
  
  WaitClose()
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 49
; FirstLine = 32
; Folding = --
; EnableXP
; DPIAware