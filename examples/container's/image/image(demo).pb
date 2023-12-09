IncludePath "../../../"
XIncludeFile "widgets.pbi"

UseLib(widget)

; ; LN=1000; количесвто итемов 
; ; Global *w._S_widget
; ; 
; ; If Open(OpenWindow(#PB_Any, 100, 50, 400, 500, "ListViewGadget", #PB_Window_SystemMenu))
; ;   If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
; ;   EndIf
; ;   
; ;   Image(10, 10, 380, 380, (0)) 
; ;   
; ;   Button(10,390, 95, 25, "")
; ;   WaitClose()
; ; EndIf

; ImageSize.NSSize
; ImageSize\width = 64
; ImageSize\height = 64
; CocoaMessage(0, ImageID(1), "setSize:@", @ImageSize)

; IncludePath "../"
; XIncludeFile "widgets().pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   Global.i gEvent, gQuit
   Global *Image, *Button, *ComboBox
   
   UsePNGImageDecoder()
   
   If Not LoadImage(10, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")  ;  "/Users/as/Desktop/Снимок экрана 2018-12-29 в 21.35.28.png") ; 
      End
   EndIf
   
   If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   
   Procedure Window_0_widget_events( )
      Select EventWidget( )
         Case *Button
            SetState( *Image, GetState( *Button ) )
            
         Case *ComboBox
            SetAttribute( *Image, #__DisplayMode, GetState( *ComboBox ) )
            
      EndSelect
   EndProcedure
   
   Procedure Window_0_Resize( )
      Protected width = WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)
      Protected height = WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)
      
      Resize(*Image, #PB_Ignore, #PB_Ignore, width-20, height-85)
      Resize(*Button, #PB_Ignore, height-65, width-10, #PB_Ignore)
      Resize(*ComboBox, #PB_Ignore, height-35, width-10, #PB_Ignore)
   EndProcedure
   
   Procedure Window_0( )
      If Open(0, 0, 0, 250, 310, "Demo show&hide scrollbar buttons", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
         *Image = Image(10, 10, 230,  225, 10)
         
         *Button = Button( 5,   245, 240,  25, "change image", #PB_Button_Toggle)
         *ComboBox = ComboBox( 5,   245+30, 240,  30)
         AddItem(*ComboBox, -1, "Default")
         AddItem(*ComboBox, -1, "Center")
         AddItem(*ComboBox, -1, "Mosaic")
         AddItem(*ComboBox, -1, "Stretch")
         AddItem(*ComboBox, -1, "Proportionally")
         SetState(*ComboBox, 0)
         
         Bind( *Button, @Window_0_widget_events( ), #__event_LeftClick )
         Bind( *ComboBox, @Window_0_widget_events( ), #__event_Change )
         
         SetAlignment(*Image, 0, 1,1,1,1 )
         SetAlignment(*Button, 0, 1,0,1,1 )
         SetAlignment(*ComboBox, 0, 1,0,1,1 )
         
         ; Resize( root(), 0, 0, 450, 610)
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
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 65
; FirstLine = 60
; Folding = --
; EnableXP