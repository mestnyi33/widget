XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  EnableExplicit
  Global Event.i, MyCanvas, *mdi
  Global x=100,y=100, width=320, height=320 , focus
  
;   Procedure Canvas_HitTest( *this._s_WIDGET, mouse_x, mouse_y )
;     Protected Alpha = 0
;     
;     If *this\image[#__img_background]\depth > 31
;       StartDrawing( ImageOutput( *this\image[#__img_background]\img ) )
;       DrawingMode( #PB_2DDrawing_AlphaChannel )
;       
;       If mouse()\x-*this\x[#__c_inner] < *this\width[#__c_inner] And mouse()\y-*this\y[#__c_inner] < *this\height[#__c_inner]
;         ;Debug ""+ Str(mouse()\x-*this\x[#__c_inner]) +" "+ Str( mouse()\y-*this\y[#__c_inner] )
;         Alpha = Alpha( Point( mouse()\x-*this\x[#__c_inner], mouse()\y-*this\y[#__c_inner] ) ) ; get alpha
;       EndIf
;       StopDrawing()
;     Else
;       Alpha = 255
;     EndIf
;       
;     ; ReDraw( *this\root )
;     ProcedureReturn Alpha
;   EndProcedure
  
;   Procedure Canvas_SetCursor( mouse_x, mouse_y, cur = #PB_Cursor_Default )
; ;     Static set_cursor 
; ;     Protected cursor
; ;     
; ;     If cur <> #PB_Cursor_Default
; ;       cursor = cur
; ;     Else
; ;       If Not Mouse( )\buttons
; ;         If Bool( Canvas_HitTest( EventWidget( ), mouse_x, mouse_y ) ) 
; ;           cursor = #PB_Cursor_Hand
; ;         Else 
; ;           cursor = #PB_Cursor_Default
; ;         EndIf
; ;       EndIf
; ;     EndIf
; ;     
; ;     If set_cursor <> cursor
; ;       set_cursor = cursor
; ;       SetGadgetAttribute( MyCanvas, #PB_Canvas_Cursor, cursor )
; ;     EndIf
;   EndProcedure
  
  Procedure CustomEvents( )
    Static Drag
    
    Select WidgetEventType( )
      Case #PB_EventType_LeftButtonUp : Drag = #False
        ; Canvas_SetCursor( mouse()\x, mouse()\y  )
        
      Case #PB_EventType_LeftButtonDown
        Drag = 1;Bool( Canvas_HitTest( EventWidget( ), mouse()\x, mouse()\y ) )
;         If Drag 
;          ; Canvas_SetCursor( mouse()\x, mouse()\y , #PB_Cursor_Arrows )
;         EndIf
        
      Case #PB_EventType_MouseMove, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
        If Drag = #True
          If Resize( EventWidget( ), mouse()\x-mouse()\delta\x, mouse()\y-mouse()\delta\y, #PB_Ignore, #PB_Ignore)
            ProcedureReturn #PB_EventType_Repaint
          EndIf
;         Else 
;          ; Canvas_SetCursor( mouse()\x, mouse()\y  )
        EndIf
        
    EndSelect
    
;     Select WidgetEventType( )
;       Case #PB_EventType_MouseEnter
;         ; SetCursor( EventWidget( ), #PB_Cursor_Hand )
;         
;       Case #PB_EventType_MouseLeave
;        ; SetCursor( EventWidget( ), #PB_Cursor_Default )
;     EndSelect
    
    
  EndProcedure
  
  Procedure Canvas_AddImage( *mdi, x, y, img, alphatest=0 )
    Protected *this._s_widget = AddItem( *mdi, -1, "", img, #__flag_BorderLess )
    Resize(*this, x, y, ImageWidth( img ), ImageHeight( img ))
    
    If alphatest
      ;*this\image[#__img_background]\transparent = 1
      ; SetColor( *this, #__color_back, #PB_Image_Transparent )
      ;; *this\transporent = 1
      EndIf
    ;_this_\image[#__img_background]
    SetCursor( *this, #PB_Cursor_Hand )
    
    Bind( *this, @CustomEvents(), #PB_EventType_LeftButtonUp )
    Bind( *this, @CustomEvents(), #PB_EventType_LeftButtonDown )
    
    Bind( *this, @CustomEvents(), #PB_EventType_MouseMove )
;     Bind( *this, @CustomEvents(), #PB_EventType_MouseEnter )
;     Bind( *this, @CustomEvents(), #PB_EventType_MouseLeave )
    
    ;Bind( *mdi, @CustomEvents(), #PB_EventType_MouseMove )
    ;Bind( *mdi, @CustomEvents(), #PB_EventType_MouseEnter )
    ;Bind( *mdi, @CustomEvents(), #PB_EventType_MouseLeave )
  EndProcedure
  
  Procedure Canvas_resize( )
    ;Protected width = GadgetWidth( EventGadget() )
    Protected width = WindowWidth( EventWindow() )
    Resize( Root(), #PB_Ignore, #PB_Ignore, width, #PB_Ignore )
    Resize( *mdi, #PB_Ignore, #PB_Ignore, width-x*2, #PB_Ignore )
    ReDraw(Root())
  EndProcedure
  
  If Not OpenWindow(0, 0, 0, width+x*2+20, height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  ;BindGadgetEvent(MyCanvas, @Canvas_resize(), #PB_EventType_Resize )
  ;BindEvent(#PB_Event_SizeWindow, @Canvas_resize());, GetWindow(Root()), MyCanvas, #PB_EventType_Resize )
  
  *mdi = MDI(x,y,width,height);, #__flag_autosize)
                                     ;a_init( *mdi )
  
  Canvas_AddImage( *mdi, -80, -20, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp" ) )
  Canvas_AddImage( *mdi, 100, 100, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp" ) )
  Canvas_AddImage( *mdi, 210, 250, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp" ) )
  
  Define hole = CreateImage( #PB_Any,100,100,32 )
  If StartDrawing( ImageOutput( hole ) )
    DrawingMode( #PB_2DDrawing_AllChannels )
    ;Debug RGBA( $00,$00,$00,$00 )
    Box( 0,0,OutputWidth(),OutputHeight(),RGBA( $00,$00,$00,$00 ) )
    Circle( 50,50,48,RGBA( $00,$FF,$FF,$FF ) )
    Circle( 50,50,30,RGBA( $00,$00,$00,$00 ) )
    StopDrawing( )
  EndIf
  Canvas_AddImage( *mdi,180,180,hole, #True )
  
  
  WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP