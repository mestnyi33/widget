XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   EnableExplicit
   Global Event.i, MyCanvas, *mdi._s_widget, vButton, hButton
   Global X=200,Y=150, Width=320, Height=320 , focus
   
   ;-
   Procedure MDI_ImageEvents( )
      Protected *ew._s_widget = EventWidget( )
      Static DragWidget
      
      Select WidgetEvent( )
            ;       Case #__event_MouseEnter
            ;         SetCursor( *ew, #PB_Cursor_Hand )
            ;         
            ;       Case #__event_MouseLeave
            ;         SetCursor( *ew, #PB_Cursor_Default )
            
         Case #__event_LeftUp 
            DragWidget = #Null
            
         Case #__event_LeftDown
;             ; get alpha
;             If *ew\image[#__image_background]\id And
;                *ew\image[#__image_background]\depth > 31 And 
;                StartDrawing( ImageOutput( *ew\image[#__image_background]\img ) )
;                
;                DrawingMode( #PB_2DDrawing_AlphaChannel )
;                If Alpha( Point( Mouse( )\x - *ew\x[#__c_inner], Mouse( )\y - *ew\y[#__c_inner] ) )
;                   DragWidget = *ew
;                Else
;                   DragWidget = GetAtPoint( Root( ), mouse( )\x, mouse( )\y, widgets( ), *ew\address )
;                EndIf
;                
;                StopDrawing( )
;             Else
;                DragWidget = *ew
;             EndIf
            DragWidget = *ew
            
         Case #__event_MouseMove
            If DragWidget = *ew
               Resize( *ew, MouseMoveX( ), MouseMoveY( ), #PB_Ignore, #PB_Ignore)
            EndIf
            
         Case #__Event_Draw
            
            ; Demo draw line on the element
            UnclipOutput()
            DrawingMode(#PB_2DDrawing_Outlined)
            
            Protected draw_color 
            If *ew\width[#__c_draw] > 0 And
               *ew\height[#__c_draw] > 0
               draw_color = $ff00ff00
            Else
               draw_color = $ff00ffff
            EndIf
            
            If *ew\round
               RoundBox(DpiUnScaled(*ew\x),DpiUnScaled(*ew\y),DpiUnScaled(*ew\width),DpiUnScaled(*ew\height), *ew\round, *ew\round, draw_color)
            Else
               Box(*ew\x,*ew\y,*ew\width,*ew\height, draw_color)
            EndIf
            
            With *ew\parent\scroll
               Box( DpiScaled(X), DpiScaled(Y), DpiScaled(Width), DpiScaled(Height), RGB( 0,255,0 ) )
               Box( \h\x, \v\y, \h\bar\page\len, \v\bar\page\len, RGB( 0,0,255 ) )
               Box( \h\x-\h\bar\page\pos, \v\y - \v\bar\page\pos, \h\bar\max, \v\bar\max, RGB( 255,0,0 ) )
            EndWith
      EndSelect
      
   EndProcedure
   
   Procedure MDI_AddImage( *mdi, X, Y, img, round=0 )
      Protected *this._s_widget, Width, Height
      
      Width = ImageWidth( img )
      Height = ImageHeight( img )
      
      *this = AddItem( *mdi, -1, "", img, #__flag_border_Less|#__flag_Transparent )
      *this\class = "image-"+Str(img)
      *this\cursor = #PB_Cursor_Hand
      *this\round = (round)
      
      Resize(*this, X, Y, Width, Height )
      
      Bind( *this, @MDI_ImageEvents(), #__event_LeftUp )
      Bind( *this, @MDI_ImageEvents(), #__event_LeftDown )
      Bind( *this, @MDI_ImageEvents(), #__event_MouseMove )
      Bind( *this, @MDI_ImageEvents(), #__event_MouseEnter )
      Bind( *this, @MDI_ImageEvents(), #__event_MouseLeave )
      Bind( *this, @MDI_ImageEvents(), #__Event_Draw )
      
      ProcedureReturn *this
   EndProcedure
   
   ;- \\
   Procedure Canvas_resize( )
      ;Protected width = GadgetWidth( EventGadget() )
      Protected Width = WindowWidth( EventWindow() )
      Resize( root(), #PB_Ignore, #PB_Ignore, Width, #PB_Ignore )
      Resize( *mdi, #PB_Ignore, #PB_Ignore, Width-X*2, #PB_Ignore )
   EndProcedure
   
   Procedure Gadgets_Events()
      Select EventGadget()
         Case 2
            If GetGadgetState(2)
                  SetGadgetText(2, "vertical bar")
              SetGadgetState(3, GetAttribute(*mdi\scroll\v, #__bar_invert))
            Else
                SetGadgetText(2, "horizontal bar")
                SetGadgetState(3, GetAttribute(*mdi\scroll\h, #__bar_invert))
            EndIf
            PostReDraw(root())
            
         Case 3
            If GetGadgetState(2)
               SetAttribute(*mdi\scroll\v, #__bar_invert, Bool(GetGadgetState(3)))
               SetWindowTitle(0, Str(GetState(*mdi\scroll\v)))
            Else
               SetAttribute(*mdi\scroll\h, #__bar_invert, Bool(GetGadgetState(3)))
               SetWindowTitle(0, Str(GetState(*mdi\scroll\h)))
            EndIf
            PostReDraw(root())
            
         Case 4
            If GetGadgetState(2)
               SetAttribute(*mdi\scroll\v, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * vButton)
               SetWindowTitle(0, Str(GetState(*mdi\scroll\v)))
            Else
               SetAttribute(*mdi\scroll\h, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * hButton)
               SetWindowTitle(0, Str(GetState(*mdi\scroll\h)))
            EndIf
            PostReDraw(root())
         
         Case 5
            
      EndSelect
   EndProcedure
   
   Define yy = 90
   Define xx = 0
   Define Text.s
   CompilerIf #PB_Compiler_DPIAware
     Text.s = " enable DPIAware"
   CompilerElse
     Text.s = " disable DPIAware"
   CompilerEndIf
   If Not OpenWindow( 0, 0, 0, Width+X*2+20+xx, Height+Y*2+20+yy, "Move/Drag Canvas Image"+Text, #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered ) 
     MessageRequester( "Fatal error", "Program terminated." )
      End
   EndIf
   
   ;BindEvent(#PB_Event_SizeWindow, @Window_Resize(), 0)
   ;
   CheckBoxGadget(5, 10, 10, 80,20, "clipoutput") : SetGadgetState(5, 1)
   CheckBoxGadget(2, 10, 30, 80,20, "vertical bar") : SetGadgetState(2, 1)
   CheckBoxGadget(3, 30, 50, 80,20, "invert")
   CheckBoxGadget(4, 30, 70, 80,20, "noButtons")
   
   If CreateImage(0, 200, 80)
      
      StartDrawing(ImageOutput(0))
      
      FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
      
      DrawingMode(#PB_2DDrawing_Default)
      Box(5, 15, 30, 2, RGB( 0,255,0 ))
      Box(5, 15+25, 30, 2, RGB( 0,0,255 ))
      Box(5, 15+50, 30, 2, RGB( 255,0,0 ))
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(40, 5, "frame - (coordinate color)",0,0)
      DrawText(40, 30, "page - (coordinate color)",0,0)
      DrawText(40, 55, "max - (coordinate color)",0,0)
      
      StopDrawing() ; This is absolutely needed when the drawing operations are finished !!! Never forget it !
      
   EndIf
   ImageGadget(#PB_Any, Width+X*2+20-210,10,200,80, ImageID(0) )
   
   Define round = 50
   Define hole = CreateImage( #PB_Any,100,100,32 )
   If StartDrawing( ImageOutput( hole ) )
      DrawingMode( #PB_2DDrawing_AllChannels )
      ; transporent back 
      Box( 0,0,OutputWidth(),OutputHeight(),RGBA( $00,$00,$00,$00 ) )
      
      Circle( 50,50,round,RGBA( $00,$FF,$FF,$FF ) )
      Circle( 50,50,30,RGBA( $00,$00,$00,$00 ) )
      StopDrawing( )
   EndIf
   
   Define hole2 = CreateImage( #PB_Any,200,60,32 )
   If StartDrawing( ImageOutput( hole2 ) )
      DrawingMode( #PB_2DDrawing_AllChannels )
      ; transporent back 
      Box( 0,0,OutputWidth(),OutputHeight(),RGBA( $00,$00,$00,$00 ) )
      
      DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AllChannels )
      RoundBox( 0,0,OutputWidth(),OutputHeight(),100,100,RGBA(213, 55, 109, 71) )
      DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AllChannels )
      RoundBox( 0,0,OutputWidth(),OutputHeight(),100,100,RGBA(213, 55, 109, 218) )
      
      StopDrawing( )
   EndIf
   
   ;
   MyCanvas = GetCanvasGadget(Open(0, xx+10, yy+10, Width+X*2, Height+Y*2 ) )
   SetColor(root(), #PB_Gadget_BackColor, $ffffffff)
   
   ;BindGadgetEvent(MyCanvas, @Canvas_resize(), #PB_EventType_Resize )
   ;   ;BindEvent(#PB_Event_SizeWindow, @Canvas_resize());, GetCanvasWindow(Root()), MyCanvas, #PB_EventType_Resize )
   
   *mdi = MDI(X,Y,Width,Height);, #__flag_autosize)
                               ;a_init( *mdi )
   SetColor(*mdi, #PB_Gadget_BackColor, $ffffffff)
   ;SetColor(*mdi, #__FrameColor, $ffffffff)
   
   Define b=(19);20        
   *mdi\scroll\v\round = (11)
   *mdi\scroll\v\bar\button[1]\round = *mdi\scroll\v\round
   *mdi\scroll\v\bar\button[2]\round = *mdi\scroll\v\round
   *mdi\scroll\v\bar\button\round = *mdi\scroll\v\round
   SetAttribute(*mdi\scroll\v, #__bar_buttonsize, b)
   
   *mdi\scroll\h\round = (11)
   *mdi\scroll\h\bar\button[1]\round = *mdi\scroll\h\round
   *mdi\scroll\h\bar\button[2]\round = *mdi\scroll\h\round
   *mdi\scroll\h\bar\button\round = *mdi\scroll\h\round
   SetAttribute(*mdi\scroll\h, #__bar_buttonsize, b)
   
   ;Debug *mdi\Scroll\v\round
   vButton = GetAttribute(*mdi\Scroll\v, #__bar_buttonsize);+1
   hButton = GetAttribute(*mdi\Scroll\h, #__bar_buttonsize);+1
   
   MDI_AddImage( *mdi, -80, -20, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp" ) )
   MDI_AddImage( *mdi, 100, 120, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp" ) )
   MDI_AddImage( *mdi, 210, 250, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp" ) )
   
   MDI_AddImage( *mdi,50,150,hole, round )
   MDI_AddImage( *mdi,90,30,hole2, 100 )
   
   BindEvent( #PB_Event_Gadget, @Gadgets_Events() )
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 48
; FirstLine = 23
; Folding = ----
; EnableXP