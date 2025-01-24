
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Define Width=500, Height=400
  
  Procedure Active()
    Debug ""+#PB_Compiler_Procedure +" - "+ EventGadget()
  EndProcedure
  
  Procedure deactive()
    Debug " "+#PB_Compiler_Procedure +" - "+ EventGadget()
  EndProcedure
  
  Procedure TestWindow(win, X,Y,Width,Height, Text.s, flag.q = 0)
     OpenWindow(win, X,Y,Width,Height, Text, flag|#PB_Window_Invisible|#PB_Window_NoActivate, WindowID(0))
     
     CompilerIf #PB_Compiler_OS = #PB_OS_Windows
       SetParent_( WindowID(win), WindowID(0))
     CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      ; CocoaMessage ( 0, CocoaMessage( 0, WindowID(0), "contentView" ), "addSubview:", WindowID(win) ) 
     CompilerEndIf
     
     HideWindow( win, 0, #PB_Window_NoActivate )
  EndProcedure
  
  Procedure WaitClose( )
     Repeat 
     Until WaitWindowEvent( ) = #PB_Event_CloseWindow
  EndProcedure
  
  Procedure Bind( gadget, *callback, eventtype = #PB_All )
    BindEvent( #PB_Event_Gadget, *callback, 0, 1, eventtype )
    BindEvent( #PB_Event_Gadget, *callback, 0, 2, eventtype )
    BindEvent( #PB_Event_Gadget, *callback, 0, 3, eventtype )
    BindEvent( #PB_Event_Gadget, *callback, 0, 4, eventtype )
    BindEvent( #PB_Event_Gadget, *callback, 0, 5, eventtype )
    BindEvent( #PB_Event_Gadget, *callback, 0, 6, eventtype )
  EndProcedure
  
  ;
  If OpenWindow(0, 100, 200, Width, Height, "demo focus widget", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      
     ;     a_init(root())
     
    TestWindow(10, 10, 10, 190, 90, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
    StringGadget(1, 10,10,170,30,"1")
    StringGadget(4, 10,50,170,30,"4") 
    
    TestWindow(20, 110, 30, 190, 90, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
    StringGadget(2, 10,10,170,30,"2")
    StringGadget(5, 10,50,170,30,"5")
    
    TestWindow(30, 220, 50, 190, 90, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
    StringGadget(3, 10,10,170,30,"3") 
    StringGadget(6, 10,50,170,30,"6")
    SetActiveGadget( 6 )
    
    Bind(#PB_All, @active( ), #PB_EventType_Focus)
    Bind(#PB_All, @deactive( ), #PB_EventType_LostFocus)
    
    WaitClose( )
  EndIf
  
  End  
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 20
; FirstLine = 12
; Folding = --
; EnableXP
; DPIAware