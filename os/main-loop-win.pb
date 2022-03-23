CompilerIf #PB_Compiler_IsMainFile
  Global win
  Debug #WM_QUIT
  Debug #WM_DESTROY
  Debug #WM_CLOSE
  
  
  Procedure Close_()
    CloseWindow( EventWindow() )
  EndProcedure
  
;   Procedure  WindowProc_(hWnd, *message, wParam, lParam)
;     Debug *message
;     Select *message
;         
;       Case #WM_DESTROY:
;         PostQuitMessage_(0);
;         ProcedureReturn  0 ;
;     EndSelect
;     
;     ProcedureReturn DefWindowProc_( hWnd, *message, wParam, lParam );
;   EndProcedure 
;   
  win = OpenWindow( #PB_Any, 150, 150, 500, 400, "window_0" )
  ;BindEvent( #PB_Event_CloseWindow, @Close_(), win )
  ;CloseWindow( win )
  
  ;PostQuitMessage_(0);
  
  CompilerSelect #PB_Compiler_OS 
    CompilerCase #PB_OS_Windows
      Define msg.MSG
      
      While GetMessage_( @msg, 0, 0, 0 )
        TranslateMessage_(msg);
        DispatchMessage_(msg) ;
        
        Debug ""+msg\message +" "+ msg\hwnd +" "+ msg\lParam +" "+ msg\wParam
        
        Select msg\message
          Case #WM_QUIT
            Debug 7777
            Break
        EndSelect
      Wend
      
      
      Debug 666666666
    CompilerCase #PB_OS_MacOS
      
  CompilerEndSelect
CompilerEndIf
; IDE Options = PureBasic 5.72 (Windows - x64)
; CursorPosition = 25
; FirstLine = 15
; Folding = -
; EnableXP