
IncludePath "../../"
XIncludeFile "widgets.pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   EnableExplicit
   
   Global tree_view
   Global *this._s_widget
   Global *root._S_widget
   Global NewMap wlist.i()
   Global.i Canvas_0, gEvent, gQuit, X=10,Y=10
   Global state, direction = 1, Width, Height, window, defWidth, defHeight
   
   Global size = 20
   
   Procedure all_events( )
      Protected i,ii, X,Y, Width
      Static w
      
      Width = WindowWidth(EventWidget( )\root\canvas\window) 
      ;Width = Width(EventWidget( ))
      Protected  s = (Width % size)
      
;       If Not s
;          Width + size
;       Debug Width
;       Else
;          Width - s
;       EndIf
      
      ;Width + s;( Width % size )
      Width = (( Width / size ) * size ) + DPIScaled(1)
               
         
      If w<>Width ; Not (Width % size)
         w=Width
        ; Width - size
          Debug "   "+Width
        
         For i=0 To 90
            Resize(wlist(Hex(i)), X, Y*size, #PB_Ignore, #PB_Ignore )  
            X + size
            If X = Width - DPIScaled(1)
               X = 0
               Y + 1
            EndIf
         Next
      EndIf
   EndProcedure
   ;- 
   window = GetCanvasWindow( Open( 5, 70, 70, 200, 200, #PB_Compiler_Procedure+"(auto-alignment)", #PB_Window_SizeGadget ))
   
   Define i, i1, i2
   For i=0 To 90
      wlist(Hex(i)) = Button(0, 0, size, size, Str(i))  
   Next
   
   
   Bind( Root(), @all_events(), #__event_Resize )
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 34
; FirstLine = 20
; Folding = -
; EnableXP
; DPIAware