
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(widget)
  Declare CallBack( )
  
  Procedure CallBack( )
    Select WidgetEvent( )
      Case #__event_close
        Debug "close - event " + EventWidget( )\class +" --- "+ EventWidget( )\index
        
        If EventWidget( )\root\canvas\window = 2
           If #PB_MessageRequester_Yes = Message( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
            ProcedureReturn #PB_All
          Else
            ProcedureReturn 1
          EndIf
       EndIf
       
      Case #__event_free
        Debug "free - event " + EventWidget( )\class 
        
        ;             ;\\ to send not free
        ;                      ProcedureReturn 1
        
    EndSelect
  EndProcedure
  
  ;\\
  Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                      #PB_Window_SizeGadget |
                                      #PB_Window_MinimizeGadget |
                                      #PB_Window_MaximizeGadget )
  
  SetClass(Root( ), "window_0_root" )
  Button(10,10,200,50,"Button_0")
  SetClass(widget( ), "Button_0" )
  
  ;\\
  Open(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                          #PB_Window_SizeGadget |
                                          #PB_Window_MinimizeGadget |
                                          #PB_Window_MaximizeGadget )
  
  SetClass(Root( ), "window_1_root" )
  Button(10,10,200,50,"Button_1")
  SetClass(widget( ), "Button_1" )
  
  ;\\
  Open(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu |
                                          #PB_Window_SizeGadget |
                                          #PB_Window_MinimizeGadget |
                                          #PB_Window_MaximizeGadget )
  
  SetClass(Root( ), "window_2_root" )
  Button(10,10,200,50,"Button_2")
  SetClass(widget( ), "Button_2" )
  
  
  
  ;\\
  ForEach enumRoot( )
    Debug enumRoot( )\class
  Next
  
;   Debug ""
;   Define canvas, window
;   ForEach enumRoot( )
;      Debug enumRoot( )\class
;      canvas = enumRoot( )\canvas\gadget
;      window = enumRoot( )\canvas\window
;      
;      DeleteMapElement(enumRoot( ))
;      FreeGadget( canvas )
;      CloseWindow( window )
;      
;      ResetMap(enumRoot( ))
;   Next
;   
;   If Not MapSize(enumRoot( ))
;     Debug "0"
;     End
;   EndIf
;   
;   ; Close( #PB_All )
  
  Bind( #PB_All, @CallBack( ) )
  
  ;\\
  WaitClose( Root( ) )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 11
; FirstLine = 7
; Folding = -
; EnableXP