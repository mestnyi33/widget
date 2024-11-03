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
Prototype CBFunc(*Canvas)
;Canvas CallbackProcedure Structure
Structure CanvasStruct
  Canvas.i     ; Handle
  Width.w      ;
  Height.w     ;
  Event.i      
  Callback.CBFunc           ; The callback procedure, called when anything happens....
  MouseInsideCanvas.b  ; True if mouse inside/over gadget
  MouseCursor.i        ; Set this to alter mouse cursor...
  MouseX.w
  MouseY.w
  Value.i       ; Can be Wheel / Button / Key depending on event
  ImageBuffer.i ; Create a image and put imagevalue here, it will be automaticly painted when needed...      
  Repaint.b  
EndStructure

NewList CanvasList.CanvasStruct()

Macro G_TYPE_MAKE_FUNDAMENTAL(x)
  ((x) << 2)
EndMacro
#G_TYPE_BOOLEAN = G_TYPE_MAKE_FUNDAMENTAL(5)
ImportC ""
  g_object_set_data_(*drawarea,name.p-ascii,*canvasstructpointer) As "g_object_set_data"
  g_object_get_data_(*Widget,name.p-ascii) As "g_object_get_data"
  g_signal_connect(*d, ev.p-ascii, *func, u.i, a=0, b=0) As "g_signal_connect_data"
  g_object_set_property_(*widget, name.p-ascii, *val) As "g_object_set_property"
EndImport


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
        gdktype.l
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
    
    ProcedureC.i Canvashandler(*widget.GtkWidget,*event.GdkEvent,*Userdata)
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
            
            value.GValue
            g_value_init_(@value, #G_TYPE_BOOLEAN)
            g_value_set_boolean_(@value, #True)
            g_object_set_property_(*widget, "has_focus", @value)
            
            
          Case #GDK_FOCUS_CHANGE
            ;gtk_widget_ungrab_focus_(*widget)
            
          Case #GDK_LEAVE_NOTIFY
            *cross.gdkeventcrossing=*event
            *Canvas\MouseInsideCanvas=#False
            *Canvas\Event=#Canvas_MouseLeave
            *Canvas\MouseX=*cross\x
            *Canvas\MouseY=*cross\y
            
            value.GValue
            g_value_init_(@value, #G_TYPE_BOOLEAN)
            g_value_set_boolean_(@value, #False)
            g_object_set_property_(*widget, "has_focus", @value)
            
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
        result=*Canvas\Callback(*Canvas)
        If *Canvas\ImageBuffer And *Canvas\repaint=#True
          gdk_draw_pixbuf_(*widget\window,*widget\style\fg_gc,ImageID(*Canvas\ImageBuffer),0,0,0,0,*widget\allocation\width,*widget\allocation\height,0,0,0)
        EndIf
      EndIf      
    EndProcedure   
    
    Procedure.i CanvasGadget_(parent,x,y,w,h,callback.CBFunc)
      Shared Canvaslist()
      *canvasstructpointer=AddElement(Canvaslist())
      Canvaslist()\callback=callback
      Canvaslist()\width=w
      Canvaslist()\height=h
      *drawarea.gtkwidget=gtk_drawing_area_new_()
      *drawarea\object\flags=*drawarea\object\flags|#GTK_CAN_FOCUS
      g_object_set_data_(*drawarea,"PBSC",*canvasstructpointer)
      gtk_widget_set_size_request_(*drawarea,w,h)
      gtk_widget_set_events_(*drawarea,#GDK_ALL_EVENTS_MASK  )
      
      g_signal_connect(*drawarea, "event", @Canvashandler(), #Null)
      gtk_fixed_put_(parent,*drawarea,x,y)
      
      value.GValue
      #G_TYPE_BOOLEAN = G_TYPE_MAKE_FUNDAMENTAL(5)
      g_value_init_(@value, #G_TYPE_BOOLEAN)
      g_value_set_boolean_(@value, #True)
      g_object_set_property_(*drawarea, "can_focus", @value)
      
      gtk_widget_show_all_(*drawarea)
      ProcedureReturn *drawarea
    EndProcedure
    
  CompilerCase #PB_OS_Windows
    ;
    ;Windows Canvas Code
    ;  
    Procedure.i CanvasHandler(hwnd,msg,wParam,lParam)
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
    
    Procedure.i CanvasGadget_(parent,x,y,w,h,callback.i)
      Shared Canvaslist()
      name.s="PBSC"
      wndClass.WNDCLASSEX 
      hInstance = GetModuleHandle_(0)
      If GetClassInfoEx_(hInstance, @"PBSC", @wndClass) = 0
        With wndClass
          \cbSize = SizeOf(WNDCLASSEX)
          \style = #CS_DBLCLKS;|#CS_HREDRAW|#CS_VREDRAW
          \lpfnWndProc = @CanvasHandler()
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
    
    
    ImportC "/System/Library/Frameworks/Carbon.framework/Carbon"
      GetEventClass.i(inEvent.l)
      HIViewNewTrackingArea(inView.l, inShape.l, inID.q, *outRef)
    EndImport
    
    Structure EventTypeSpec
      eventClass.l
      eventKind.l
    EndStructure
    
    ProcedureDLL CanvasHandler(*nextHandler, Event, *userdata)
      *canvas.canvasstruct=*userdata
      
      Select GetEventClass(Event)
          
        Case #kEventControlDraw
          context.CGContextRef 
          
          result = GetEventParameter_( Event, #kEventParamCGContextRef, typeCGContextRef,#Null, SizeOf( context ),#Null, @context );
          
          bounds.HIRect;
          HIViewGetBounds_(*canvas\canvas, @bounds );
          
          CGContextSaveGState_( context );
          *transform.CGAffineTransform = #CGAffineTransformIdentity;
          transform = CGAffineTransformScale_(*transform, 1, -1 );
          CGContextSetTextMatrix_( context,*transform );
          
          CGContextRestoreGState_( context );
          result = noErr;
          
        Case #kEventClassMouse
          If *canvas\MouseInsideCanvas
            Select GetEventKind_(Event)
              Case #kEventMouseDown
                *canvas\event=#canvas_mousedown
                ;*canvas\MouseX=
                ;*canvas\MouseY=
                ;*canvas\Value=
              Case #kEventMouseMoved, #kEventMouseDragged
                *canvas\event=#canvas_mousemove
                ;*canvas\MouseX=
                ;*canvas\MouseY=
                ;*canvas\Value=
              Case #kEventMouseUp
                *canvas\event=#canvas_mouseup
                ;*canvas\MouseX=
                ;*canvas\MouseY=
                ;*canvas\Value=
            EndSelect
          EndIf
          
        Case #kEventClassControl 
          Select GetEventKind_(Event)
            Case #kEventControlTrackingAreaEntered
              *canvas\MouseInsideCanvas=#True
              *canvas\event=#canvas_mouseenter
            Case #kEventControlTrackingAreaExited
              *canvas\MouseInsideCanvas=#False
              *canvas\event=#canvas_mouseleave
          EndSelect         
      EndSelect
      
      If *nexthandler : CallNextEventHandler_(*nextHandler, Event) : EndIf
    EndProcedure
    Procedure.i CanvasGadget_(parent,x,y,w,h,callback.i)
      *canvasstructpointer=AddElement(Canvaslist())
      Canvaslist()\callback=callback
      
      event_count = 8
      Dim eventtypes.EventTypeSpec(Events_Count - 1)
      eventTypes(0)\eventClass = #kEventClassHIObject
      eventtypes(0)\eventKind = #kEventHIObjectConstruct
      eventTypes(1)\eventClass = #kEventClassHIObject
      eventtypes(1)\eventKind = #kEventHIObjectDestruct
      eventTypes(2)\eventClass = #kEventClassMouse
      eventtypes(2)\eventKind = #kEventMouseDown
      eventTypes(3)\eventClass = #kEventClassMouse
      eventtypes(3)\eventKind = #kEventMouseMoved
      eventTypes(4)\eventClass = #kEventClassMouse
      eventtypes(4)\eventKind = #kEventMouseDragged
      eventTypes(5)\eventClass = #kEventClassMouse
      eventtypes(5)\eventKind = #kEventMouseUp
      eventTypes(6)\eventClass = #kEventClassControl
      eventtypes(6)\eventKind = #kEventControlTrackingAreaEntered
      eventTypes(7)\eventClass = #kEventClassControl
      eventtypes(7)\eventKind = #kEventControlTrackingAreaExited
      drawareaclass = HIObjectRegisterSubclass_( @"Com.BlackSwan.PBSC", #kHIViewClassID,0, NewEventHandlerUPP_(@canvashandler( )),ArraySize(eventtypes()),@eventtypes(),#Null, #Null );
      
      ;Create Class
      drawarea.HIViewRef 
      HIObjectCreate_(@"Com.BlackSwan.PBSC", #Null, @drawarea);
      ;Ref to content view
      contentView.HIViewRef = #Null;
      HIViewFindByID_( HIViewGetRoot_( parent ), #kHIViewWindowContentID, @contentView );
      HIViewAddSubview_( contentView, parent );
      HIViewSetVisible_( drawarea, #True );
      HIViewNewTrackingArea(drawarea, #Null, 0, #Null)
      Canvaslist()\Canvas=drawarea
      ProcedureReturn drawarea
    EndProcedure
    
CompilerEndSelect
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = rn-8--
; EnableXP