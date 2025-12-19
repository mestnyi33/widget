IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   EnableExplicit
   
   Global.i gEvent, gQuit
   Global *Image, *Button, *ComboBox
   
   UsePNGImageDecoder()
   
   Procedure NewImage( Image, Width, Height )
      ;
      ; Create some images for the image demonstration
      ; 
      Define i, font ;= LoadFont( 0, "Aria", (13) )
      CreateImage( Image, Width, Height )
      If StartDrawing( ImageOutput( Image ) )
         ;DrawingFont( font )
         
         Box( 0, 0, Width, Height, $FFFFFF )
         ;DrawText( 5, 5, "Drag this image", $000000, $FFFFFF )        
         For i = 45 To 1 Step -1
            Circle( 70, 80, i, Random( $FFFFFF ) )
         Next i        
         
         StopDrawing( )
      EndIf  
   EndProcedure

   If Not LoadImage(10, #PB_Compiler_Home + "examples/sources/Data/Background.bmp") 
      End
   EndIf
   
   ;NewImage( 1, 32, 32 )
   
   If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   
;    If DesktopResolutionX() > 1
;       ResizeImage(1, DesktopScaledX(ImageWidth(1)),DesktopScaledY(ImageHeight(1)))
;       
;       ResizeImage(10, DesktopScaledX(ImageWidth(10)),DesktopScaledY(ImageHeight(10)))
;    EndIf
   
   
   Procedure Window_0_events( )
      Select EventWidget( )
         Case *Button
            If GetState( *Button )
               SetImage( *Image, (10) )
            Else
               SetImage( *Image, (1) )
            EndIf
            
         Case *ComboBox
            If SetAttribute( *Image, #__DisplayMode, GetState( *ComboBox ) )
            EndIf 
            PostRepaint( )
            
      EndSelect
   EndProcedure
   
   Procedure Window_0( )
      If Open(0, 0, 0, 225+100, 310, "Demo show&hide scrollbar buttons", #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered );| #PB_Window_SizeGadget)
         *Image = Image(10, 10, 200, 200, (1))
         ;*Image = ButtonImage(10, 10, 230,  225, (1))
         *ComboBox = ListView( 215, 10, 100, 200) ; Container(5, 230, 240,  75) ; 
         *Button = Button( 10, 215, 305, 25, "change image", #PB_Button_Toggle)
         
         CloseList( )
         
         SetBackColor( *Image, $FFB3FDFF )
         ;
         ;SetAlign(*Image, 0, 1,1,1,1 )
         ;SetAlign(*Button, 0, 1,0,1,1 )
         ;SetAlign(*ComboBox, 0, 1,0,1,1 )
         
         ;
         AddItem(*ComboBox, 0, "Default")
         AddItem(*ComboBox, 1, "Center")
         AddItem(*ComboBox, 2, "Mosaic")
         AddItem(*ComboBox, 3, "Stretch")
         AddItem(*ComboBox, 4, "Proportionally")
         SetState(*ComboBox, 0)
         
         ;
         Bind( *Button, @Window_0_events( ), #__event_LeftClick )
         Bind( *ComboBox, @Window_0_events( ), #__event_Change )
         
         HideWindow(0,0)
         ResizeWindow(0, #PB_Ignore, #PB_Ignore, #PB_Ignore, 250)
      EndIf
   EndProcedure
   
   Window_0()
   
   Repeat
      gEvent= WaitWindowEvent()
      
      Select gEvent
         Case #PB_Event_CloseWindow
            gQuit= #True
      EndSelect
      
   Until gQuit
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 62
; FirstLine = 40
; Folding = ---
; EnableXP
; DPIAware