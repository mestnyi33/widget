
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
   
   
   Procedure   SetAlign_( *this._s_WIDGET, mode.q, left.q = 0, top.q = 0, right.q = 0, bottom.q = 0 )
      ;ProcedureReturn SetAlign( *this, mode, left, top, right, bottom )
      Protected Flag.q
      
      ;          ;\\
      ;          If mode & #__align_auto = #__align_auto
      ;             If left > 0 : left = 1 : EndIf
      ;             If top > 0 : top = 1 : EndIf
      ;             If right > 0 : right = 1 : EndIf
      ;             If bottom > 0 : bottom = 1 : EndIf
      ;             
      ;             If left > 0 And top = 0 And right = 0 And bottom = 0 : left = #__align_auto : EndIf
      ;             If top > 0 And left = 0 And right = 0 And bottom = 0 : top = #__align_auto : EndIf
      ;             If right > 0 And top = 0 And left = 0 And bottom = 0 : right = #__align_auto : EndIf
      ;             If bottom > 0 And top = 0 And right = 0 And left = 0 : bottom = #__align_auto : EndIf
      ;             
      ;             right = #__align_auto 
      ;          EndIf
      
      If mode & #__align_auto
         If left>0 : left = #__align_auto :EndIf
         If top>0 : top = #__align_auto :EndIf
         If right>0 : right = #__align_auto :EndIf
         If bottom>0 : bottom = #__align_auto :EndIf
      EndIf
      
      ;\\
      If *this\parent
         If Not *this\parent\align
            *this\parent\align.allocate( ALIGN )
            
            
            ;               ;\\ ?-надо тестировать
            ;                If Not *this\parent\align\width
            *this\parent\align\x     = *this\parent\container_x( )
            *this\parent\align\width = *this\parent\inner_width( )
            ;                EndIf
            ;                If Not *this\parent\align\height
            *this\parent\align\y      = *this\parent\container_y( )
            *this\parent\align\height = *this\parent\inner_height( )
            ;                EndIf
            ;                
            
         EndIf
         
         If Not *this\align
            *this\align.allocate( ALIGN )
         EndIf
         
         ;\\
         If *this\align
            ;\\ horizontal
            If left Or ( Not right And constants::BinaryFlag( Flag, #__align_full ))
               If left = #__align_proportional 
                  *this\align\left = - 1
               Else
                  *this\align\left = 1
               EndIf
            Else
               *this\align\left = 0
            EndIf
            If right Or ( Not left And constants::BinaryFlag( Flag, #__align_full ))
               If right = #__align_proportional
                  *this\align\right = - 1
               Else
                  *this\align\right = 1
               EndIf
            Else
               *this\align\right = 0
            EndIf
            
            ;\\ vertical
            If top Or ( Not bottom And constants::BinaryFlag( Flag, #__align_full )) 
               If top = #__align_proportional
                  *this\align\top = - 1
               Else
                  *this\align\top = 1
               EndIf
            Else
               *this\align\top = 0
            EndIf
            If bottom Or ( Not top And constants::BinaryFlag( Flag, #__align_full ))
               If bottom = #__align_proportional
                  *this\align\bottom = - 1
               Else
                  *this\align\bottom = 1
               EndIf
            Else
               *this\align\bottom = 0
            EndIf
            
            
            ;\\
            ; Debug ""+mode +" - "+ left+" "+top+" "+right+" "+bottom
            If mode = 0
               *this\align\x = *this\container_x( )
               *this\align\y = *this\container_y( )
               ;\\
               If *this\type = #__type_window
                  *this\align\width  = *this\inner_width( )
                  *this\align\height = *this\inner_height( )
               Else
                  *this\align\width  = *this\frame_width( )
                  *this\align\height = *this\frame_height( )
               EndIf
               
            Else
               ;\\ full horizontal
               If *this\align\right And *this\align\left
                  *this\align\x     = 0
                  *this\align\width = (*this\parent\align\width)
                  If *this\type = #__type_window
                     *this\align\width - *this\fs * 2
                  EndIf
               Else
                  *this\align\width = *this\frame_width( )
                  If *this\align\left And Not *this\align\right
                     ; left
                     *this\align\x = 0
                  ElseIf Not *this\align\right And Not *this\align\left
                     ; center
                     *this\align\x = ( *this\parent\align\width - *this\frame_width( ) ) / 2
                  ElseIf *this\align\right And Not *this\align\left
                     ; right
                     If ( mode & #__align_full = #__align_full ) Or
                        ( mode & #__align_auto = #__align_auto )
                        *this\align\x = *this\parent\align\width - *this\frame_width( )
                        If *this\type = #__type_window
                           *this\align\x - *this\fs * 2
                        EndIf
                     EndIf
                  EndIf
               EndIf
               
               ;\\ full vertical
               If *this\align\bottom And *this\align\top
                  *this\align\y      = 0
                  *this\align\height = *this\parent\align\height
                  If *this\type = #__type_window
                     *this\align\height - *this\fs * 2
                  EndIf
               Else
                  *this\align\height = *this\frame_height( )
                  If *this\align\top And Not *this\align\bottom
                     ; top
                     *this\align\y = 0
                  ElseIf Not *this\align\bottom And Not *this\align\top
                     ; center
                     *this\align\y = ( *this\parent\align\height - *this\frame_height( ) ) / 2
                  ElseIf *this\align\bottom And Not *this\align\top
                     ; bottom
                     If ( mode & #__align_full = #__align_full ) Or
                        ( mode & #__align_auto = #__align_auto )
                        *this\align\y = *this\parent\align\height - *this\frame_height( )
                        If *this\type = #__type_window
                           *this\align\y - *this\fs * 2
                        EndIf
                     EndIf
                  EndIf
               EndIf
               
               ;
               ;\\ auto stick change
               If *this\parent\align
                  If left = #__align_auto And *this\parent\align\autodock\x
                     left = - *this\parent\align\autodock\x
                  Else
                     left = DPIScaled(left)
                  EndIf
                  If right = #__align_auto And *this\parent\align\autodock\width
                     right = - *this\parent\align\autodock\width
                  Else
                     right = DPIScaled(right)
                  EndIf
                  If top = #__align_auto And *this\parent\align\autodock\y
                     top = - *this\parent\align\autodock\y
                  Else
                     top = DPIScaled(top)
                  EndIf
                  If bottom = #__align_auto And *this\parent\align\autodock\height
                     bottom = - *this\parent\align\autodock\height
                  Else
                     bottom = DPIScaled(bottom)
                  EndIf
                  ;
                  If left < 0 Or right < 0
                     If left And right
                        *this\align\x - left
                        *this\align\width - *this\align\x + right
                     Else
                        *this\align\x - left + right
                     EndIf
                  EndIf
                  If top < 0 Or bottom < 0
                     If top And bottom
                        *this\align\y - top
                        *this\align\height - *this\align\y + bottom
                     Else
                        *this\align\y - top + bottom
                     EndIf
                  EndIf
                  
                  ;\\ dock auto stick position
                  If *this\align\left And Not *this\align\right 
                     *this\parent\align\autodock\x = *this\align\x + *this\align\width
                     If *this\type = #__type_window
                        *this\parent\align\autodock\x + *this\fs * 2
                     EndIf
                  EndIf
                  If *this\align\top And Not *this\align\bottom
                     *this\parent\align\autodock\y = *this\align\y + *this\align\height
                     If *this\type = #__type_window
                        *this\parent\align\autodock\y + *this\fs * 2
                     EndIf
                  EndIf
                  If *this\align\right And Not *this\align\left
                     *this\parent\align\autodock\width = *this\parent\inner_width( ) - *this\align\x
                  EndIf
                  If *this\align\bottom And Not *this\align\top
                     *this\parent\align\autodock\height = *this\parent\inner_height( ) - *this\align\y
                  EndIf
                  
                  ;\\ dock auto stick position update
                  If constants::BinaryFlag( Flag, #__align_full )
                     If ( *this\parent\align\autodock\x Or
                          *this\parent\align\autodock\y Or
                          *this\parent\align\autodock\width Or
                          *this\parent\align\autodock\height )
                        
                        ; loop enum widgets
                        If StartEnum( *this\parent )
                           If Widget( )\align
                              If Widget( )\align\top And Widget( )\align\bottom
                                 Widget( )\align\y      = Widget( )\parent\align\autodock\y
                                 Widget( )\align\height = Widget( )\parent\inner_height( ) - ( Widget( )\parent\align\autodock\y + Widget( )\parent\align\autodock\height )
                                 
                                 If Widget( )\align\left And Widget( )\align\right
                                    Widget( )\align\x     = Widget( )\parent\align\autodock\x
                                    Widget( )\align\width = (Widget( )\parent\inner_width( )) - ( Widget( )\parent\align\autodock\x + Widget( )\parent\align\autodock\width )
                                    
                                    If Widget( )\type = #__type_window
                                       Widget( )\align\width - Widget( )\fs * 2
                                    EndIf
                                 EndIf
                                 
                                 If Widget( )\type = #__type_window
                                    Widget( )\align\height - Widget( )\fs * 2
                                 EndIf
                              EndIf
                           EndIf
                           ;
                           StopEnum( )
                        EndIf
                     EndIf
                  EndIf
               EndIf
            EndIf
            
            ;                ;\\
            ; update parent children's coordinate
            ;*this\parent\align\update = 1
            Resize( *this\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
            ; PostEventReDraw( *this\root )
         EndIf
      EndIf
   EndProcedure
   
   ;- 
   window = GetCanvasWindow( Open( 5, 70, 70, 200, 200, #PB_Compiler_Procedure+"(auto-alignment)", #PB_Window_SizeGadget ))
   
   Define i, i1, i2, g, b
   For i=0 To 9
      g=Container(0, 0, 20, 20) 
      For i1=0 To 9
         b=Button(0, 0, 20, 20, Str(i1))  
         SetAlign(b, 0, #__align_auto,1,0,0 )   
      Next
      CloseList( )
      SetAlign(g, #__align_full, 0,1,0,0 )   
   Next
   
   
   For i=0 To 9
   Next
   
;    For i=0 To 9
;       Button(0, 0, 20, 20, Str(i))  
;    Next
;    For i1=i To i+9
;       Button(0, 20, 20, 20, Str(i1))  
;    Next
;    
;    For i=0 To 9
;       ; SetAlign_(ID(i), #__align_auto, 1,1,0,0 )   
;       SetAlign(ID(i), 0, #__align_auto,1,0,0 )   
;       ;  SetAlign(ID(i), 0, 0,1,#__align_auto,0 )   
;    Next
;    
;    For i1=i To i+9
;       ; SetAlign_(ID(i1), #__align_auto, 1,0,0,0 )   
;       SetAlign(ID(i1), 0, #__align_auto,1,0,0 )   
;       ;  SetAlign(ID(i1), 0, 0,1,#__align_auto,0 )   
;    Next
;    
;    ;    For i=9 To 0 Step - 1
;    ;      SetAlign_(ID(i), #__align_auto, 0,0,1,0 )   
;    ;    Next
;    ;    For i1=i+9 To 9 Step - 1
;    ;      SetAlign_(ID(i1), #__align_auto, 0,0,1,0 )   
;    ;    Next
   ;    ;               
   
   
   
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 299
; FirstLine = 280
; Folding = ----------
; EnableXP
; DPIAware