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

Global NewList CanvasList.CanvasStruct()

;
;Here starts the real mess.... hehe...
;
CompilerSelect  #PB_Compiler_OS
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
    
    #kEventControlDraw = 4 
    #kEventParamCGContextRef = 'cntx'
    #kEventClassHIObject           = 'hiob'
    #kEventHIObjectConstruct             = 1
    #kEventHIObjectDestruct              = 3
    #kHIViewClassID = "com.apple.hiview"
    #kHIViewWindowContentID = 'cnvw'
    
    Macro CGContextRef
      i
    EndMacro
    Macro HIRect
      CGRect
    EndMacro
    Macro HIViewRef
      i
    EndMacro
    
    
   ImportC "/System/Library/Frameworks/Carbon.framework/Carbon"
       HIViewFindByID_(StartView.i, HIViewSignature.i, HIViewID, *FoundControl=0)
      HIViewGetBounds_(*HIViewRef, *HIRect)
      HIViewGetRoot_(*HIViewRef)
      
      CGContextSaveGState_( context )
      CGContextRestoreGState_( context );
      CGAffineTransformScale_(t, sx.f, sy.f);
      CGContextSetTextMatrix_(*CGContextRef, CGAffineTransform);
      
      HIObjectRegisterSubclass_(inClassID,
                                inBaseClassID,
                                inOptions,
                                inConstructProc,       ;/* can be NULL */
                                inNumEvents,
                                inEventList,
                                inConstructData,
                                outClassRef)
      
      HIObjectCreate_(inClassID,inConstructData, outObject)
      HIViewAddSubview_( contentView, parent );
      HIViewSetVisible_( drawarea, state )
     
 EndImport
 
;           Declaration
;           Static var identity: CGAffineTransform { get }
;           *transform.CGAffineTransform = #CGAffineTransformIdentity;


    ImportC "/System/Library/Frameworks/Carbon.framework/Carbon"
      GetEventClass.i(inEvent.l)
      HIViewNewTrackingArea(inView.l, inShape.l, inID.q, *outRef)
    EndImport
    
    Structure EventTypeSpec
      eventClass.i
      eventKind.i
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
          transform = CGAffineTransformScale_(*transform, 1, -1 )  ;
          CGContextSetTextMatrix_( context,*transform );
          
          CGContextRestoreGState_( context );
          result = noErr;
          
        Case #kEventClassMouse
          If *canvas\MouseInsideCanvas
            Select GetEventKind_(Event)
              Case #kEventMouseDown
                *canvas\event=#Canvas_MouseButtonDown
                ;*canvas\MouseX=
                ;*canvas\MouseY=
                ;*canvas\Value=
              Case #kEventMouseMoved, #kEventMouseDragged
                *canvas\event=#canvas_mousemove
                ;*canvas\MouseX=
                ;*canvas\MouseY=
                ;*canvas\Value=
              Case #kEventMouseUp
                *canvas\event=#Canvas_MouseButtonUp
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
    Procedure.i CustomCanvasGadget(parent,x,y,w,h,callback.i)
      *canvasstructpointer=AddElement(Canvaslist())
      Canvaslist()\callback=callback
      
      event_count = 8
      Dim eventtypes.EventTypeSpec(event_count - 1)
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
      HIViewSetVisible_( drawarea, #True )    ;
      
      HIViewNewTrackingArea(drawarea, #Null, 0, #Null)
      Canvaslist()\Canvas=drawarea
      ProcedureReturn drawarea
    EndProcedure
    
CompilerEndSelect
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -2-
; EnableXP