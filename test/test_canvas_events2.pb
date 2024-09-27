IncludePath "../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(Widget)
   test_canvas_events = 1
   
   
   Procedure _Open( window, x.l = 0, y.l = 0, width.l = #PB_Ignore, height.l = #PB_Ignore, title$ = #Null$, flag.q = #Null, *parentID = #Null, Canvas = #PB_Any )
         Protected result, w, g, canvasflag = #PB_Canvas_Keyboard, UseGadgetList, *root._s_ROOT 
         
         ; init
         If Not MapSize( __roots( ) )
            events::SetCallback( @EventHandler( ) )
         EndIf
         
         If PB(IsWindow)( Window )
            w = WindowID( Window )
            ;
            ;             If flag & #PB_Window_NoGadgets
            ;                flag &~ #PB_Window_NoGadgets
            ;             EndIf
            If flag & #PB_Canvas_Container
               flag &~ #PB_Canvas_Container
               canvasflag | #PB_Canvas_Container
            EndIf
            If width = #PB_Ignore And 
               height = #PB_Ignore
               canvasflag | #PB_Canvas_Container
            EndIf
         Else
            If flag & #PB_Window_NoGadgets
               flag &~ #PB_Window_NoGadgets
            Else
               canvasflag | #PB_Canvas_Container
            EndIf
            ;
            ; then bug in windows
            If Window = #PB_Any
               Window = 300 + MapSize( __roots( ) )
            EndIf
            ;
            w = OpenWindow( Window, x, y, width, height, title$, flag, *parentID )
            If Window = #PB_Any 
               Window = w 
               w = WindowID( Window ) 
            EndIf
            ;
            If flag & #PB_Window_BorderLess = #PB_Window_BorderLess
               CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If CocoaMessage(0, w, "hasShadow") = 0
                     CocoaMessage(0, w, "setHasShadow:", 1)
                  EndIf
               CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
                  If GetClassLongPtr_( w, #GCL_STYLE ) & #CS_DROPSHADOW = 0
                     SetClassLongPtr_( w, #GCL_STYLE, #CS_DROPSHADOW )
                  EndIf
                  SetWindowLongPtr_(w,#GWL_STYLE,GetWindowLongPtr_(w,#GWL_STYLE)&~#WS_CAPTION) 
                  SetWindowLongPtr_(w,#GWL_EXSTYLE,GetWindowLongPtr_(w,#GWL_EXSTYLE)|#WS_EX_NOPARENTNOTIFY) 
               CompilerElse
                  ;  
               CompilerEndIf
            EndIf
            ;
            x = 0
            y = 0
         EndIf
         
         ;\\ get a handle from the previous usage list
         If w
            UseGadgetList = UseGadgetList( w )
         EndIf
         ;
         If x = #PB_Ignore : x = 0 : EndIf
         If y = #PB_Ignore : y = 0 : EndIf
         ;
         If width = #PB_Ignore
            width = WindowWidth( Window, #PB_Window_InnerCoordinate )
            If x <> #PB_Ignore
               If x > 0 And x < 50 
                  width - x * 2
               EndIf
            EndIf
         EndIf
         ;
         If height = #PB_Ignore
            height = WindowHeight( Window, #PB_Window_InnerCoordinate )
            If y <> #PB_Ignore
               If y > 0 And y < 50 
                  height - y * 2
               EndIf
            EndIf
         EndIf
         ;
         If PB(IsGadget)(Canvas)
            g = GadgetID( Canvas )
         Else
            g = CanvasGadget( Canvas, x, y, width, height, canvasflag )
            If Canvas = - 1 : Canvas = g : g = PB(GadgetID)(Canvas) : EndIf
         EndIf
         ;
         If UseGadgetList And w <> UseGadgetList
            UseGadgetList( UseGadgetList )
         EndIf
         
         ;
         If Not FindMapElement( __roots( ), Str( g ) ) ; ChangeCurrentCanvas(g)
            result     = AddMapElement( __roots( ), Str( g ) )
            __roots( ) = AllocateStructure( _s_root )
            Root( )    = __roots( )
            *root      = __roots( )
            
            
            ;
            *root\root      = *root
            
            *root\container = 1
            *root\address   = result
            *root\type      = #__type_Container
            
            *root\class     = "Root"
            ;*root\window   = *root
            ;*root\parent   = Opened( )
            
            ;
            *root\color       = _get_colors_( )
            SetFontID( *root, PB_( GetGadgetFont )( #PB_Default ))
            
            ;
            *root\canvas\GadgetID = g
            *root\canvas\window   = Window
            *root\canvas\gadget   = Canvas
            
            ;\\
            Post( *root, #__event_create )
            
            ;\\
            If width Or height
               Resize( *root, #PB_Ignore, #PB_Ignore, width, height )
            EndIf
            
            ;\\
            If flag & #PB_Window_NoGadgets = #False
               If Opened( )
                  Opened( )\AfterRoot( ) = *root
               EndIf
               *root\BeforeRoot( ) = Opened( )
               
               Opened( ) = *root
               ; OpenList( *root)
            EndIf
            
            ;\\
            If flag & #PB_Window_NoActivate
               *root\focus =- 1
            Else
               SetActive( *root )
            EndIf
         EndIf
         
         If g
            SetWindowData( Window, Canvas )
            
            ;\\
            BindGadgetEvent( Canvas, @CanvasEvents( ))
            ;BindEvent( #PB_Event_Gadget, @CanvasEvents( ), Window, Canvas )
            BindEvent( #PB_Event_Repaint, @EventRepaint( ), Window )
            BindEvent( #PB_Event_ActivateWindow, @EventActivate( ), Window )
            BindEvent( #PB_Event_DeactivateWindow, @EventDeactivate( ), Window )
            If canvasflag & #PB_Canvas_Container = #PB_Canvas_Container
               BindEvent( #PB_Event_SizeWindow, @EventResize( ), Window )
            EndIf
            
            ;\\ z - order
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
               SetWindowLongPtr_( g, #GWL_STYLE, GetWindowLongPtr_( g, #GWL_STYLE ) | #WS_CLIPSIBLINGS )
               SetWindowPos_( g, #GW_HWNDFIRST, 0, 0, 0, 0, #SWP_NOMOVE | #SWP_NOSIZE )
               
               ; RedrawWindow_(WindowID(a), 0, 0, #RDW_ERASE | #RDW_FRAME | #RDW_INVALIDATE | #RDW_ALLCHILDREN)
               
               RemoveKeyboardShortcut( Window, #PB_Shortcut_Tab )
            CompilerEndIf
            
            ;\\
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
               ; CocoaMessage(0, g, "setBoxType:", #NSBoxCustom)
               ; CocoaMessage(0, g, "setBorderType:", #NSLineBorder)
               ; CocoaMessage(0, g, "setBorderType:", #NSGrooveBorder)
               ; CocoaMessage(0, g, "setBorderType:", #NSBezelBorder)
               ; CocoaMessage(0, g, "setBorderType:", #NSNoBorder)
               
               ;;;CocoaMessage(0, w, "makeFirstResponder:", g)
               
               ; CocoaMessage(0, GadgetID(0), "setFillColor:", CocoaMessage(0, 0, "NSColor colorWithPatternImage:", ImageID(0)))
               ; CocoaMessage(0, WindowID(w), "setBackgroundColor:", CocoaMessage(0, 0, "NSColor colorWithPatternImage:", ImageID(0)))
               ; CocoaMessage(0, g,"setFocusRingType:",1)
            CompilerEndIf
         EndIf
         
         widget( ) = *root
         PostEventRepaint( *root )
         ProcedureReturn *root
      EndProcedure
      
  
   Procedure OpenTest( id, flag=0 )
      Static x,y
      OpenWindow( id, x,y,200,200,"window_"+Str(id), #PB_Window_SystemMenu|flag)
      Open( id, 40,40,200-80,55) : SetClass(root( ), Str(id))
      Open( id, 40,110,200-80,55) : SetClass(root( ), "1"+Str(id))
      x + 100
      y + 100
   EndProcedure
   
   
   OpenTest(1, #PB_Window_NoActivate)
   OpenTest(2, #PB_Window_NoActivate)
   OpenTest(3, #PB_Window_NoActivate)
   
   OpenWindow( 4, 330,300,200,100,"popup", #PB_Window_BorderLess, WindowID(3))
   Open(4, 10,10,100,100)
   
   WaitClose( )
   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 222
; FirstLine = 190
; Folding = ------
; EnableXP