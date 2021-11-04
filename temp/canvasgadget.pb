;CanvasGadget v0.82   
;Coding: Erlend 'Preacher' Rovik
;
;- added from top of head code for carbon(MacOSX) so only bare bones and probably filled with bugs...

;Canvas events:
Enumeration
  #Canvas_Paint
  #Canvas_MouseScroll
  #Canvas_MouseMove
  #Canvas_MouseLeave
  #Canvas_MouseEnter
  #Canvas_MouseButtonDown
  #Canvas_MouseButtonUp
  #Canvas_KeyUp         
  #Canvas_KeyDown    
EndEnumeration

;Canvas CallbackProcedure Structure
Structure CanvasStruct
  Canvas.i     ; Handle
  Width.w      ;
  Height.w     ;
  Event.i      
  Callback.i           ; The callback procedure, called when anything happens....
  MouseInsideCanvas.b  ; True if mouse inside/over gadget
  MouseCursor.i        ; Set this to alter mouse cursor...
  MouseX.w
  MouseY.w
  Value.i       ; Can be Wheel / Button / Key depending on event
  ImageBuffer.i ; Create a image and put imagevalue here, it will be automaticly painted when needed...      
  Repaint.b  
EndStructure

Global NewList CanvasList.CanvasStruct()

;
;Here starts the real mess.... hehe...
;
CompilerSelect  #PB_Compiler_OS
  CompilerCase #PB_OS_Linux 
    ;
    ;Linux Canvas Code
    ;
    CompilerIf Defined(GdkEvent,#PB_Structure)=#False
      Structure GdkEvent
        gdktype.i
        StructureUnion
          any.GdkEventAny
          expose.GdkEventExpose    
          no_expose.GdkEventNoExpose    
          visibility.GdkEventVisibility    
          motion.GdkEventMotion
          button.GdkEventButton
          scroll.GdkEventScroll
          key.GdkEventKey
          crossing.GdkEventCrossing
          focus_change.GdkEventFocus            
          configure.GdkEventConfigure        
          property.GdkEventProperty    
          selection.GdkEventSelection    
          proximity.GdkEventProximity
          client.GdkEventClient        
          dnd.GdkEventDND               
          window_state.GdkEventWindowState       
          setting.GdkEventSetting           
        EndStructureUnion
      EndStructure
    CompilerEndIf
    
    ProcedureC.i CustomControlHandler(*widget.GtkWidget,*event.GdkEvent,*Userdata)
      *Canvas.canvasstruct=g_object_get_data_(*Widget,"PBSC")
      
      If *Canvas
        *Canvas\MouseX=-1  
        *Canvas\MouseY=-1  
        *Canvas\Value=-1  
        *Canvas\Canvas=*widget          
        
        Select *event\gdktype
            
          Case #GDK_CONFIGURE
            *gevent.GDKEventConfigure=*event                  
            *Canvas\Width=*gevent\Width
            *Canvas\Height=*gevent\Height
            
          Case #GDK_EXPOSE
            *Canvas\Event=#Canvas_Paint
            If *Canvas\ImageBuffer 
              gdk_draw_pixbuf_(*widget\window,*widget\style\fg_gc,ImageID(*Canvas\ImageBuffer),0,0,0,0,*widget\allocation\width,*widget\allocation\height,0,0,0)
            EndIf
            
          Case #GDK_SCROLL
            *sevent.GdkEventScroll=*event
            *Canvas\Event=#Canvas_MouseScroll
            *Canvas\MouseX=*sevent\x
            *Canvas\MouseY=*sevent\y
            *Canvas\Value=*sevent\direction
            
          Case #GDK_ENTER_NOTIFY
            *cross.gdkeventcrossing=*event
            *Canvas\MouseInsideCanvas=#True
            *Canvas\Event=#Canvas_MouseEnter
            *Canvas\MouseX=*cross\x
            *Canvas\MouseY=*cross\y
            
          Case #GDK_FOCUS_CHANGE
            ;gtk_widget_ungrab_focus_(*widget)
            
          Case #GDK_LEAVE_NOTIFY
            *cross.gdkeventcrossing=*event
            *Canvas\MouseInsideCanvas=#False
            *Canvas\Event=#Canvas_MouseLeave
            *Canvas\MouseX=*cross\x
            *Canvas\MouseY=*cross\y
            
          Case #GDK_MOTION_NOTIFY
            *mevent.GdkEventMotion=*event
            *Canvas\Event=#Canvas_MouseMove
            *Canvas\MouseX=*mevent\x
            *Canvas\MouseY=*mevent\y
            
          Case #GDK_BUTTON_PRESS
            gtk_widget_grab_focus_(*widget)
            *bevent.GdkEventButton=*event
            *Canvas\Event=#Canvas_MouseButtonDown
            *Canvas\Value=*bevent\button
            *Canvas\MouseX=*bevent\x
            *Canvas\MouseY=*bevent\y
            
          Case #GDK_BUTTON_RELEASE
            *bevent.GdkEventButton=*event
            *Canvas\Event=#Canvas_MouseButtonUp
            *Canvas\Value=*bevent\button
            *Canvas\MouseX=*bevent\x
            *Canvas\MouseY=*bevent\y
            
          Case #GDK_KEY_PRESS
            *kevent.GdkEventKey=*event
            *Canvas\Event=#Canvas_KeyDown
            *Canvas\Value=*kevent\keyval
            
          Case #GDK_KEY_RELEASE
            *kevent.GdkEventKey=*event
            *Canvas\Event=#Canvas_KeyUp
            *Canvas\Value=*kevent\keyval
        EndSelect  
        
        *Canvas\Canvas=*widget
        result=CallFunctionFast(*Canvas\Callback,*Canvas)
        If *Canvas\ImageBuffer And *canvas\repaint=#True
          gdk_draw_pixbuf_(*widget\window,*widget\style\fg_gc,ImageID(*Canvas\ImageBuffer),0,0,0,0,*widget\allocation\width,*widget\allocation\height,0,0,0)
        EndIf
      EndIf      
    EndProcedure   
    
    Procedure.i CustomControl(parent,x,y,w,h,callback.i)
      Shared Canvaslist()
      *canvasstructpointer=AddElement(Canvaslist())
      Canvaslist()\callback=callback
      Canvaslist()\width=w
      Canvaslist()\height=h
      *drawarea.gtkwidget=gtk_drawing_area_new_()
      *drawarea\object\flags=*drawarea\object\flags|#GTK_CAN_FOCUS
      g_object_set_data_(*drawarea,"PBSC",*canvasstructpointer)
      gtk_widget_set_size_request_(*drawarea,w,h)
      gtk_widget_set_events_(*drawarea,#GDK_ALL_EVENTS_MASK)
      g_signal_connect_(*drawarea, "event", @CustomControlHandler(), #Null)
      gtk_fixed_put_(parent,*drawarea,x,y)
      gtk_widget_show_all_(*drawarea)
      ProcedureReturn *drawarea
    EndProcedure
    
  CompilerCase #PB_OS_Windows
    ;
    ;Windows Canvas Code
    ;  
    Procedure.i CustomControlHandler(hwnd,msg,wParam,lParam)
      *canvas.canvasstruct=GetProp_(hwnd,"PBSC")
      
      Select msg   
        Case #WM_SIZE
          If *canvas
            *canvas\Width=(lparam & $FFFF)
            *canvas\Height=(lparam >> 16)
          EndIf
          
        Case #WM_ERASEBKGND
          result=#True
          
        Case #WM_PAINT
          *Canvas\Event=#Canvas_Paint     
          result=#False
          
        Case #WM_MOUSEACTIVATE:
          SetFocus_(hwnd)
          result=#MA_ACTIVATE;
          
        Case #WM_MOUSEMOVE 
          If *Canvas\MouseInsideCanvas=#False
            *Canvas\Event=#Canvas_MouseEnter
            *Canvas\MouseInsideCanvas=#True  
          Else
            *Canvas\Event=#Canvas_MouseMove
          EndIf
          *Canvas\MouseX=(lParam & $FFFF)
          *Canvas\MouseY=(lParam >> 16) 
          
        Case #WM_MOUSELEAVE
          *Canvas\MouseInsideCanvas=#False  
          *Canvas\MouseX=(lParam & $FFFF)
          *Canvas\MouseY=(lParam >> 16) 
          
        Case #WM_SETCURSOR 
          If *Canvas\MouseCursor
            SetCursor_(*Canvas\MouseCursor)
          EndIf
          
        Case #WM_MOUSEWHEEL
          *Canvas\MouseX=(lParam & $FFFF)
          *Canvas\MouseY=(lParam >> 16)
          ;zDelta = wParam>>16&$ffff
          ;zDelta / #WHEEL_DELTA
          If zDelta
            *Canvas\Value=zDelta  
          EndIf
          If wParam>0
            *Canvas\Value=0
          Else
            *Canvas\Value=1
          EndIf
          *Canvas\Event=#Canvas_Mousescroll 
          
        Case #WM_LBUTTONDOWN
          SetFocus_(hWnd)
          *Canvas\Value=1
          *Canvas\Event=#canvas_MousebuttonDown
          
        Case #WM_LBUTTONUP 
          *Canvas\Value=1
          *Canvas\Event=#canvas_MousebuttonUp
          
        Case #WM_MBUTTONDOWN 
          *Canvas\Value=2
          *Canvas\Event=#Canvas_MousebuttonDown
          
        Case #WM_MBUTTONUP 
          *Canvas\Value=2
          *Canvas\Event=#Canvas_MousebuttonUp
          
        Case #WM_RBUTTONDOWN 
          *Canvas\Value=3
          *Canvas\Event=#Canvas_MousebuttonDown
          
        Case #WM_RBUTTONUP 
          *Canvas\Value=3
          *Canvas\Event=#Canvas_MousebuttonUp
          
        Case #WM_KEYDOWN
          *Canvas\Value=wParam
          *Canvas\Event=#Canvas_KeyDown
          
        Case #WM_KEYUP
          *Canvas\Value=wParam
          *Canvas\Event=#Canvas_KeyUp      
          
        Case #WM_NCCREATE
          result = #True
          
        Case #WM_CREATE
          result = 0
          
        Case #WM_NCDESTROY
          RemoveProp_(hwnd,"PBSC")
          result = 0
          
        Default
          result = DefWindowProc_(hWnd, msg, wParam, lParam)
      EndSelect
      
      If *Canvas
        *Canvas\Canvas=hWnd
        CallFunctionFast(*Canvas\Callback,*Canvas)
        If *canvas\ImageBuffer
          If msg=#WM_PAINT 
            psPaint.PAINTSTRUCT;
            hdc = BeginPaint_( hwnd, @psPaint );
            hdcin = CreateCompatibleDC_(hdc)
            old=SelectObject_(hdcin,ImageID(*Canvas\ImageBuffer))
            BitBlt_(hdc,0,0,*Canvas\Width,*Canvas\height,hdcin,0,0,#SRCCOPY)
            SelectObject_(hdcin,old)
            DeleteDC_(hdcin) 
            EndPaint_(hwnd, @psPaint); 
          ElseIf *Canvas\Repaint=#True
            hdc=GetDC_(hwnd)
            hdcin = CreateCompatibleDC_(hdc)
            old=SelectObject_(hdcin,ImageID(*Canvas\ImageBuffer))
            BitBlt_(hdc,0,0,*Canvas\Width,*Canvas\height,hdcin,0,0,#SRCCOPY)
            SelectObject_(hdcin,old)
            ReleaseDC_(hwnd,hdcin) 
            ValidateRect_(hwnd,#Null)
          EndIf
        EndIf
      EndIf
      ProcedureReturn result
    EndProcedure
    
    Procedure.i CustomControl(parent,x,y,w,h,callback.i)
      Shared Canvaslist()
      name.s="PBSC"
      wndClass.WNDCLASSEX 
      hInstance = GetModuleHandle_(0)
      If GetClassInfoEx_(hInstance, @"PBSC", @wndClass) = 0
        With wndClass
          \cbSize = SizeOf(WNDCLASSEX)
          \style = #CS_DBLCLKS;|#CS_HREDRAW|#CS_VREDRAW
          \lpfnWndProc = @CustomControlHandler()
          \hInstance = hInstance
          \hCursor = LoadCursor_(0, #IDC_ARROW)
          \hbrBackground = GetStockObject_(#WHITE_BRUSH)
          \lpszClassName = @name
        EndWith
        If RegisterClassEx_(wndClass) = 0
          ProcedureReturn 0
        Else       
          *canvasstructpointer=AddElement(Canvaslist())
          Canvaslist()\callback=callback
          Canvaslist()\width=w
          Canvaslist()\height=h
          drawarea=CreateWindowEx_(#Null,"PBSC","",#WS_CHILD, x, y, w, h, parent, #Null, hInstance, #Null)
          canvaslist()\canvas=drawarea
          SetProp_(drawarea,name,*canvasstructpointer)
          ShowWindow_(drawarea,#SW_SHOW)
          MoveWindow_(drawarea,x,y,w,h,#True)
          ProcedureReturn drawarea
        EndIf
      EndIf
    EndProcedure
    
  CompilerCase #PB_OS_MacOS
    ;https://www.evanjones.ca/software/osx-custom-controls.html
    ;
    ;MacOSX Canvas Code
    ;  
    #kEventClassMouse = 'mous' 
    #kEventClassControl = 'cntl'
    #kEventMouseDown = 1
    #kEventMouseUp = 2
    #kEventMouseMoved = 5
    #kEventMouseDragged = 6
    #kEventControlTrackingAreaEntered = 23
    #kEventControlTrackingAreaExited = 24
    
    
    #EventNotHandledErr = -9874
    #kControlUseJustMask = 64
    #kControlSupportsEmbedding = 1 << 1
    #kDocumentWindowClass = 6
    #kEventClassControl = 'cntl'
    #kEventClassWindow = 'wind'
    #kEventControlDraw = 4
    #kEventParamCGContextRef = 'cntx'
    #kEventParamRgnHandle = 'rgnh'
    #kEventParamWindowRegionCode = 'wshp'
    #kEventWindowClose = 72
    #kEventWindowDrawContent = 2
    #kEventWindowGetRegion = 1002
    #kHIViewWindowContentID = 'cnvw'
    #kMovableModalWindowClass = 4
    #kWindowCloseBoxAttribute = 1 << 0
    #kWindowCompositingAttribute = 1 << 19
    #kWindowIsOpaque = 1 << 14
    #kWindowOpaqueRgn = 35
    #kWindowStandardHandlerAttribute = 1 << 25
    #NoErr = 0
    #teCenter = 1
    #typeCGContextRef = 'cntx'
    #typeQDRgnHandle = 'rgnh'
    #typeWindowRegionCode = 'wshp'
    
    
    #kEventClassHIObject           = 'hiob'
    
    #kEventClassMouse = 'mous'
    #kEventClassKeyboard = 'keyb'
    #kEventClassTextInput = 'text'
    #kEventClassApplication = 'appl'
    #kEventClassAppleEvent = 'eppc'
    #kEventClassMenu = 'menu'
    #kEventClassWindow = 'wind'
    #kEventClassControl = 'cntl'
    #kEventClassCommand = 'cmds'
    #kEventClassTablet = 'tblt'
    #kEventClassVolume = 'vol '
    #kEventClassAppearance = 'appm'
    #kEventClassService = 'serv'
    #kEventClassToolbar = 'tbar'
    #kEventClassToolbarItem = 'tbit'
    #kEventClassAccessibility = 'acce'
    
    #kEventControlTrackingAreaEntered = 23
    
    #kEventControlTrackingAreaExited = 24
    
    #kEventHIObjectConstruct             = 1
    #kEventHIObjectInitialize            = 2
    #kEventHIObjectDestruct              = 3
    #kEventHIObjectIsEqual               = 4
    #kEventHIObjectPrintDebugInfo        = 5
    #kEventHIObjectEncode                = 6
    #kEventHIObjectCreatedFromArchive    = 7
    #kEventHIObjectGetInitParameters     = 8
    #kHIViewClassID = "com.apple.hiview"
    
    ImportC "/System/Library/Frameworks/Carbon.framework/Carbon"
      GetEventClass.i(inEvent.i)
      HIViewNewTrackingArea(inView.i, inShape.i, inID.q, *outRef)
    EndImport
    ImportC ""
      CGContextClearRect_(*CGContextRef, x.F, y.F, Width.F, Height.F)
      CGContextFillRect_(*CGContextRef, x.F, y.F, Width.F, Height.F)
      CGContextSetRGBFillColor_(*CGContextRef, Red.F, Green.F, Blue.F, Alpha.F)
      CreateNewWindow_(WindowClass.i, Attributes.i, *Bounds, *WindowRef)
      CreatePushButtonControl_(*WindowRef, *BoundsRect, CFStringRef.i, *ControlRef)
      CreateStaticTextControl_(*WindowRef, *BoundsRect, CFStringRef.i, *FontStyle, *ControlRef)
      CreateUserPaneControl_(*WindowRef, *BoundsRect, Features.i, *ControlRef)
      GetControlBounds_(*ControlRef, *Bounds)
      GetPort_(*Port)
      GetPortBounds_(Port.i, *Rect)
      GetWindowAttributes_(*WindowRef, *Attributes)
      GetWindowFeatures_(*WindowRef, *Features)
      HIViewFindByID_(StartView.i, HIViewSignature.i, HIViewID, *FoundControl=0)
      HIViewGetBounds_(*HIViewRef, *HIRect)
      HIViewGetRoot_(*HIViewRef)
      ;HIViewFindByID_(inStartView, inID, outControl)
      ;HIViewGetRoot_( parent )
      HIWindowChangeFeatures_(*WindowRef, *AttributesToSet, *AttributesToClear)
      InsetRect_(*Rect, HorizontalDistance.W, VerticalDistance.W)
      PaintRect_(*Rect)
      QDBeginCGContext_(CGrafPtr.i, *CGContextRef)
      QDEndCGContext_(CGrafPtr.i, *CGContextRef)
      QuitApplicationEventLoop_()
      ReshapeCustomWindow_(*WindowRef)
      RGBForeColor_(*RGBColor)
      RunApplicationEventLoop_()
      SetControlFontStyle_(*ControlRef, *ControlFontStyleRec)
      SetEmptyRgn_(RegionHandle.i)
      SetWindowAlpha_(*WindowRef, Alpha.F)
      SetWindowTitleWithCFString_(*WindowRef, CFStringRef.i)
      ShowControl_(*ControlRef)
      
      ;HIViewGetBounds_(*ControlRef, bounds.i )
      CGContextSaveGState_( context )
      CGContextRestoreGState_( context );
      HIObjectRegisterSubclass_(inClassID,
                                inBaseClassID,
                                inOptions,
                                inConstructProc,       ;/* can be NULL */
                                inNumEvents,
                                inEventList,
                                inConstructData,
                                outClassRef)
      
      CGAffineTransformScale_(t, sx.f, sy.f);
      HIObjectCreate_(inClassID,inConstructData, outObject)
      HIViewAddSubview_( contentView, parent );
      HIViewSetVisible_( drawarea, state )
      CGContextSetTextMatrix_(*CGContextRef, CGAffineTransform);
    EndImport
    
    Structure EventTypeSpec
      eventClass.i
      eventKind.i
    EndStructure
    
    CompilerIf Not Defined( CGPoint, #PB_Structure )
      Structure CGPoint
        x.f
        y.f
      EndStructure
    CompilerEndIf
    
    CompilerIf Not Defined( CGSize, #PB_Structure )
      Structure CGSize
        width.f
        height.f
      EndStructure
    CompilerEndIf
    
    CompilerIf Not Defined( CGRect, #PB_Structure )
      Structure CGRect
        origin.CGPoint
        size.CGSize
      EndStructure
    CompilerEndIf
    
    ProcedureDLL CustomControlHandler(*nextHandler, Event, *userdata)
;       *canvas.canvasstruct=*userdata
;       
;       Select GetEventClass(Event)
;           
;         Case #kEventControlDraw
;           context.i;*CGContextRef 
;           
;           result = GetEventParameter_( Event, #kEventParamCGContextRef, typeCGContextRef,#Null, SizeOf( context ),#Null, @context );
;           
;           bounds.i;HIRect;
;           HIViewGetBounds_(*canvas\canvas, @bounds );
;           
;           CGContextSaveGState_( context );
;           *transform = 0; .CGAffineTransform = #CGAffineTransformIdentity;
;           transform = CGAffineTransformScale_(*transform, 1, -1 );
;           CGContextSetTextMatrix_( context,*transform );
;           
;           CGContextRestoreGState_( context );
;           result = noErr                    ;
;           
;         Case #kEventClassMouse
;           If *canvas\MouseInsideCanvas
;             Select GetEventKind_(Event)
;               Case #kEventMouseDown
;                 *canvas\event=#Canvas_MouseButtonDown
;                 ;*canvas\MouseX=
;                 ;*canvas\MouseY=
;                 ;*canvas\Value=
;               Case #kEventMouseMoved, #kEventMouseDragged
;                 *canvas\event=#canvas_mousemove
;                 ;*canvas\MouseX=
;                 ;*canvas\MouseY=
;                 ;*canvas\Value=
;               Case #kEventMouseUp
;                 *canvas\event=#Canvas_MouseButtonUp
;                 ;*canvas\MouseX=
;                 ;*canvas\MouseY=
;                 ;*canvas\Value=
;             EndSelect
;           EndIf
;           
;         Case #kEventClassControl 
;           Select GetEventKind_(Event)
;             Case #kEventControlTrackingAreaEntered
;               *canvas\MouseInsideCanvas=#True
;               *canvas\event=#canvas_mouseenter
;               
;             Case #kEventControlTrackingAreaExited
;               *canvas\MouseInsideCanvas=#False
;               *canvas\event=#canvas_mouseleave
;           EndSelect         
;       EndSelect
;       
;       If *nexthandler : CallNextEventHandler_(*nextHandler, Event) : EndIf
;       
    EndProcedure
    
    Procedure.i CustomControl(parent,x,y,w,h,callback.i)
      *canvasstructpointer=AddElement(Canvaslist())
      Canvaslist()\callback=callback
      
      event_count = 8
      Dim EventList.EventTypeSpec(event_count - 1)
      EventList(0)\eventClass = #kEventClassHIObject
      EventList(0)\eventKind = #kEventHIObjectConstruct
      EventList(1)\eventClass = #kEventClassHIObject
      EventList(1)\eventKind = #kEventHIObjectDestruct
      EventList(2)\eventClass = #kEventClassMouse
      EventList(2)\eventKind = #kEventMouseDown
      EventList(3)\eventClass = #kEventClassMouse
      EventList(3)\eventKind = #kEventMouseMoved
      EventList(4)\eventClass = #kEventClassMouse
      EventList(4)\eventKind = #kEventMouseDragged
      EventList(5)\eventClass = #kEventClassMouse
      EventList(5)\eventKind = #kEventMouseUp
      EventList(6)\eventClass = #kEventClassControl
      EventList(6)\eventKind = #kEventControlTrackingAreaEntered
      EventList(7)\eventClass = #kEventClassControl
      EventList(7)\eventKind = #kEventControlTrackingAreaExited
      
;       ;      ;// Чтобы зарегистрировать новый элемент управления и события, которые он может обрабатывать, вызовите HIObjectRegisterSubclass
;       ;      OSStatus err = HIObjectRegisterSubclass( CFSTR( "someid" ), kHIViewClassID, 0, NewEventHandlerUPP( CustomControlHandler ), SizeOf( CEventList ) / SizeOf( *CEventList ), CEventList, NULL, NULL )
;       drawareaclass = HIObjectRegisterSubclass_( @"Com.BlackSwan.PBSC", #kHIViewClassID,0, NewEventHandlerUPP_(@CustomControlHandler( )), ArraySize(EventList( )), @EventList( ), #Null, #Null );
      
;       ;NewEventHandlerUPP = NewEventHandlerUPP_(@CustomControlHandler( ))
       NewEventHandlerUPP = CocoaMessage(0, 0, "NewEventHandlerUPP:@", @CustomControlHandler( )); get an identity transform
; drawareaclass = HIObjectRegisterSubclass_( @"Com.BlackSwan.PBSC", #kHIViewClassID,0, NewEventHandlerUPP, ArraySize(EventList( )), @EventList( ), #Null, #Null );
      
;       ;Create Class
;       ;       ;// Создаем экземпляр нашего настраиваемого класса
;       ;       *HIViewRef view; 
;       Protected view      
;       ;       OSStatus err = HIObjectCreate( CFSTR( "someid" ), NULL, reinterpret_cast<HIObjectRef*>( &view ) )
;       HIObjectCreate_(@"Com.BlackSwan.PBSC", #Null, @view)
;       ;       assert (err == noErr && view! = Null)    
;       CocoaMessage(@view, 0, "HIObjectCreate:@", @"Com.BlackSwan.PBSC")
;       
;       ;       ;// Получаем ссылку на представление содержимого
;       ;       *HIViewRef contentView = NULL;
;       Protected contentView = #Null
;       ;       err = HIViewFindByID( HIViewGetRoot( window ), kHIViewWindowContentID, &contentView )
;       HIViewFindByID_( HIViewGetRoot_( parent ), #kHIViewWindowContentID, @contentView )
;       ;       assert (err == noErr && contentView! = NULL)                                     
 ;      CocoaMessage(@contentView, CocoaMessage(0, parent, "HIViewGetRoot") , "HIViewFindByID:", #kHIViewWindowContentID)
;
;       ;;       ;// Добавляем наше представление как подвид представления содержимого
;       ;;       err = HIViewAddSubview (contentView, view)
;       ;HIViewAddSubview_( contentView, parent )
;       ;;       assert (err == noErr)                         
;       CocoaMessage(0, contentView, "HIViewAddSubview:@", @parent)
; 
;       ;;       ;// Делаем новый элемент управления видимым
;       ;;       err = HIViewSetVisible (control, true)
;       ;HIViewSetVisible_( view, #True )                                              
;       ;;       assert (err == noErr)                    
;       CocoaMessage(0, view, "HIViewSetVisible:", #True) 
; 
;       HIViewNewTrackingArea(view, #Null, 0, #Null)
;       Canvaslist()\Canvas = view
      
      
      
      ProcedureReturn view
    EndProcedure
    
CompilerEndSelect


;
;Test Code
;

;; XInclude "CanvasGadget.pbi"

Procedure.i LowestOf(a,b)
  If a=b
    ProcedureReturn a
  EndIf
  If a<b
    ProcedureReturn a
  Else
    ProcedureReturn b
  EndIf
EndProcedure
Procedure.i HighestOf(a,b)
  If a=b
    ProcedureReturn a
  EndIf
  If a>b
    ProcedureReturn a
  Else
    ProcedureReturn b
  EndIf
EndProcedure
Procedure colorrange(x,y,x2,y2,direction)
  If direction=0
    steps=x2-x
    For yy=y To y2
      fromrgb=Point(x,yy)
      torgb=Point(x2,yy)
      sr=Red(fromrgb) : sg=Green(fromrgb) : sb=Blue(fromrgb)
      er=Red(torgb) : eg=Green(torgb) : eb=Blue(torgb)
      jr.f=(HighestOf(sr,er)-LowestOf(sr,er))/steps
      jg.f=(HighestOf(sg,eg)-LowestOf(sg,eg))/steps
      jb.f=(HighestOf(sb,eb)-LowestOf(sb,eb))/steps
      If sr>er : jr=-jr : EndIf
      If sg>eg : jg=-jg : EndIf
      If sb>eb : jb=-jb : EndIf
      For xx=1 To steps
        Plot(x+xx,yy,RGB(sr+(jr*xx),sg+(jg*xx),sb+(jb*xx)))
      Next 
    Next 
  ElseIf direction=1
    steps=y2-y
    For xx=x To x2
      fromrgb=Point(xx,y)
      torgb=Point(xx,y2)
      sr=Red(fromrgb) : sg=Green(fromrgb) : sb=Blue(fromrgb)
      er=Red(torgb) : eg=Green(torgb) : eb=Blue(torgb)
      jr.f=(HighestOf(sr,er)-LowestOf(sr,er))/steps
      jg.f=(HighestOf(sg,eg)-LowestOf(sg,eg))/steps
      jb.f=(HighestOf(sb,eb)-LowestOf(sb,eb))/steps
      If sr>er : jr=-jr : EndIf
      If sg>eg : jg=-jg : EndIf
      If sb>eb :  jb=-jb : EndIf
      For yy=1 To steps
        Plot(xx,y+yy,RGB(sr+(jr*yy),sg+(jg*yy),sb+(jb*yy)))
      Next 
    Next 
  EndIf
EndProcedure
Procedure drawcross(mx,my)  
  Static hasdrawn,oldx,oldy
  DrawingMode(#PB_2DDrawing_XOr)  
  If hasdrawn=#True
    LineXY(oldx-3,oldy,oldx+3,oldy)  
    LineXY(oldx,oldy-3,oldx,oldy+3)  
  EndIf
  LineXY(mx-3,my,mx+3,my)  
  LineXY(mx,my-3,mx,my+3)  
  oldx=mx
  oldy=my
  hasdrawn=#True 
EndProcedure
Procedure drawcolors(w,h)
  DrawingMode(#PB_2DDrawing_Default)
  x=0 : y=0
  x2=w-1
  y2=h -1   
  Plot(0,0,RGB(255,0,0))
  Plot(x2,0,RGB(0,255,255))
  Plot(x2,y2,RGB(0,0,255))
  Plot(0,y2,RGB(0,255,0))
  colorrange(x,y,x2,y2,0)
  colorrange(x,y,x2,y2,1)
EndProcedure
Procedure.i ControlCallback(*Canvas.CanvasStruct)
  value=*Canvas\value
  mx=*Canvas\MouseX
  my=*Canvas\MouseY
  eventt.s=""
  *canvas\repaint=#True
  
  Select *Canvas\Event
      
    Case #Canvas_Paint
      *canvas\Repaint=#False
      
    Case #Canvas_MouseScroll
      StartDrawing(ImageOutput(*Canvas\ImageBuffer))
      DrawText(20,180,"Wheel "  + Str(value))   
      StopDrawing()
      
    Case #Canvas_MouseMove
      StartDrawing(ImageOutput(*Canvas\ImageBuffer))
      DrawText(20,180,"Move "  + Str(mx)+" "+Str(my))   
      StopDrawing()
      
    Case #Canvas_MouseLeave
      StartDrawing(ImageOutput(*Canvas\ImageBuffer))
      DrawText(20,20,"Leave "  + Str(mx)+" "+Str(my))   
      StopDrawing()
      
    Case #Canvas_MouseEnter
      StartDrawing(ImageOutput(*Canvas\ImageBuffer))
      DrawText(20,20,"Enter "  + Str(mx)+" "+Str(my))   
      StopDrawing()
      
    Case #Canvas_MouseButtonDown
      StartDrawing(ImageOutput(*Canvas\ImageBuffer))
      drawcross(mx,my)    
      StopDrawing()
      
    Case #Canvas_MouseButtonUp
      If *canvas\value=1
        StartDrawing(ImageOutput(*Canvas\ImageBuffer))
        drawcolors(*canvas\width,*canvas\height)
        StopDrawing()
      EndIf
      
    Case #Canvas_KeyUp
      StartDrawing(ImageOutput(*Canvas\ImageBuffer))
      DrawText(20,20,"KeyUp "  + Str(Value))   
      StopDrawing()
      
    Case #Canvas_KeyDown     
      StartDrawing(ImageOutput(*Canvas\ImageBuffer))
      DrawText(20,20,"KeyDown "  + Str(Value))   
      StopDrawing()
      
  EndSelect
  
  If IsImage(*Canvas\ImageBuffer)    
  Else
    If *canvas\width>1 And *canvas\height>1
      *Canvas\ImageBuffer=CreateImage(#PB_Any,*canvas\width,*canvas\height,24)  
      StartDrawing(ImageOutput(*Canvas\ImageBuffer))
      drawcolors(*canvas\width,*canvas\height)
      StopDrawing()
    EndIf  
  EndIf  
EndProcedure

OpenWindow(0,0,0,400,400,"")
; ContainerGadget(0,0,0,300,300)
; CloseGadgetList()
;CustomControl(GadgetID(0),50,50,200,200,@ControlCallback())
CustomControl(WindowID(0),50,50,200,200, @ControlCallback())

Repeat
  event=WaitWindowEvent()
Until event=#PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = +f+nfT5Hj
; EnableXP