
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
     OpenWindow(win, X,Y,Width,Height, Text, flag|#PB_Window_Invisible|#PB_Window_NoActivate);, WindowID(0))
     
     CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ; SetParent_( WindowID(win), WindowID(0))
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
    BindEvent( #PB_Event_Gadget, *callback, 10, 1, eventtype )
    BindEvent( #PB_Event_Gadget, *callback, 10, 2, eventtype )
    BindEvent( #PB_Event_Gadget, *callback, 20, 3, eventtype )
    BindEvent( #PB_Event_Gadget, *callback, 20, 4, eventtype )
    BindEvent( #PB_Event_Gadget, *callback, 30, 5, eventtype )
    BindEvent( #PB_Event_Gadget, *callback, 30, 6, eventtype )
  EndProcedure
  
  ;
  ; If OpenWindow(0, 100, 200, Width, Height, "demo focus widget", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
      
    ;     a_init(root())
     
    TestWindow(10, 10, 10, 190, 150, "10", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
    StringGadget(1, 10,10,170,60,"string_1")
    StringGadget(4, 10,80,170,60,"string_4") 
    
    TestWindow(20, 110, 30, 190, 150, "20", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
    StringGadget(2, 10,10,170,60,"string_2")
    StringGadget(5, 10,80,170,60,"string_5")
    
    TestWindow(30, 220, 50, 190, 150, "30", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
    StringGadget(3, 10,10,170,60,"string_3") 
    StringGadget(6, 10,80,170,60,"string_6")
    
    SetActiveGadget( 6 )
    Delay(38)
    SetActiveWindow( 30 )
    
    Bind(#PB_All, @active( ), #PB_EventType_Focus)
    Bind(#PB_All, @deactive( ), #PB_EventType_LostFocus)
    
    WaitClose( )
  ; EndIf
  
  End  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 55
; FirstLine = 31
; Folding = --
; EnableXP
; DPIAware