;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../widget-events.pbi" 
;Uselib(widget)
;Macro widget( ) : enumwidget( ) : EndMacro
;XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib( Widget )
  Global canvas_1
  Global canvas_2
  Global canvas_1_win
  Global canvas_2_win
  Global *root_1._s_root
  Global *root_2._s_root
  
  UsePNGImageDecoder()
  
  CreateImage(1,16,16)
  StartDrawing(ImageOutput(1))
  Box(0,0,16,16,RGB(255,0,0))
  DrawingMode(#PB_2DDrawing_Transparent)
  PB(DrawText)(4,0,"1",RGB(255,255,255))
  StopDrawing()
  
  CreateImage(2,16,16)
  StartDrawing(ImageOutput(2))
  Box(0,0,16,16,RGB(255,0,0))
  DrawingMode(#PB_2DDrawing_Transparent)
  PB(DrawText)(4,0,"2",RGB(255,255,255))
  StopDrawing()
  
  CreateImage(3,16,16)
  StartDrawing(ImageOutput(3))
  Box(0,0,16,16,RGB(255,0,0))
  DrawingMode(#PB_2DDrawing_Transparent)
  PB(DrawText)(4,0,"=",RGB(255,255,255))
  StopDrawing()
  
  Procedure resize_event( )
    ;     Protected *root_1._s_root = GetGadgetData( canvas_1 )
    ;     Protected *root_2._s_root = GetGadgetData( canvas_2 )
    
    ; PostEventCanvas( *root_1 )
    Debug "resize - " + WidgetEventItem( ) +" "+ WidgetEventData( )
    
  EndProcedure
  
  Procedure active_event( )
    Debug "active - "+EventWindow() +" "+ GetActiveWindow() +" "+ GetActiveGadget()
    
  EndProcedure
  Procedure deactive_event( )
    Debug "deactive - "+EventWindow() +" "+ GetActiveWindow() +" "+ GetActiveGadget()
    
  EndProcedure
  
  
  If Open( OpenWindow( #PB_Any, 300, 150, 380, 200, "form1", #PB_Window_SystemMenu ) )
    canvas_1 = GetGadget( Root( ) )
    canvas_1_win = GetWindow( Root( ) )
    ;BindEventCanvas( )
    a_init(root())
    *root_1 = Root( )
    
    String( 100, 20, 250,  60, "String ( root - 1 )" )
    Bind( widget( ), @resize_event( ), #PB_EventType_Resize )
    Button( 100, 100, 250,  60, "Button ( root - 1 )", #__button_multiline,-1 )
    Bind( widget( ), @resize_event( ), #PB_EventType_Resize )
  EndIf
  
  If Open( OpenWindow( #PB_Any, 300, 400, 380, 200, "form2", #PB_Window_SystemMenu | #PB_Window_SizeGadget ) )
    canvas_2 = GetGadget( Root( ) )
    canvas_2_win = GetWindow( Root( ) )
    ;BindEventCanvas( ) 
    a_init(root())
    *root_2 = Root( )
    
    Button( 20, 20, 250,  60, "Button ( root - 2 )", #__button_multiline,-1 )
    Bind( widget( ), @resize_event( ), #PB_EventType_Resize )
    String( 20, 100, 250,  60, "String ( root - 2 )" )
    Bind( widget( ), @resize_event( ), #PB_EventType_Resize )
  EndIf
  
  Debug "canvas_1 - "+canvas_1 +" - "+ *root_1
  Debug "canvas_2 - "+canvas_2 +" - "+ *root_2
  
  AddSysTrayIcon( 3, WindowID(canvas_1_win), ImageID(3))
  AddSysTrayIcon( 2, WindowID(canvas_2_win), ImageID(2))
  AddSysTrayIcon( 1, WindowID(canvas_1_win), ImageID(1))
  
  BindEvent( #PB_Event_ActivateWindow, @active_event() )
  BindEvent( #PB_Event_DeactivateWindow, @deactive_event() )
  
  SetWindowTitle( canvas_1_win, "form1 - "+Str( canvas_1_win ) +" canvas1 - "+ Str( canvas_1 ))
  SetWindowTitle( canvas_2_win, "form2 - "+Str( canvas_2_win ) +" canvas2 - "+ Str( canvas_2 ))
  
  Repeat
    Select WaitWindowEvent( )   
      Case #PB_Event_SysTray
        If EventType() = #PB_EventType_LeftClick
          Select EventGadget()
            Case 1
              ;               SetActive( *root_1 )
              ;               SetActiveGadget( canvas_1 )
              SetActiveWindow( canvas_1_win )
            Case 2
              ;               SetActive( *root_2 )
              ;               SetActiveGadget( canvas_2 )
              SetActiveWindow( canvas_2_win )
              
            Case 3
              Debug " "+GetActiveWindow() +" "+ GetActiveGadget()
          EndSelect
        EndIf
        
      Case #PB_Event_CloseWindow
        CloseWindow( EventWindow( ) ) 
        Break
    EndSelect
  ForEver
  ;WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP