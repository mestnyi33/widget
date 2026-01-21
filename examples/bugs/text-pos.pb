
IncludePath "../../"
XIncludeFile "widgets.pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   EnableExplicit
   
   Global window, i, i1, i2
   
   window = GetCanvasWindow( Open( 5, 70, 70, 200, 200, #PB_Compiler_Procedure+"(auto-alignment)", #PB_Window_SizeGadget ))
   
   For i=0 To 9
      Button(0, 0, 20, 20, Str(i))  
   Next
   For i1=i To i+9
      Button(0, 20, 20, 20, Str(i1))  
   Next
   
   For i=0 To 9
      SetAlign(ID(i), 0, #__align_auto,1,0,0 )   
   Next
   
   For i1=i To i+9
      SetAlign(ID(i1), 0, #__align_auto,1,0,0 )   
   Next
   
   Repaint( )
   ResizeWindow(window, #PB_Ignore, #PB_Ignore, 600,#PB_Ignore) ;460,360)
   
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 31
; FirstLine = 8
; Folding = -
; EnableXP
; DPIAware