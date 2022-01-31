;- MACOS
CompilerIf #PB_Compiler_IsMainFile
  DeclareModule constants
    Enumeration #PB_EventType_FirstCustomValue
      #PB_EventType_Repaint
      #PB_EventType_Drop
    EndEnumeration
  EndDeclareModule
  Module constants
  EndModule
CompilerEndIf

DeclareModule events
  EnableExplicit
  
  ;     Macro PB(Function)
  ;       Function
  ;     EndMacro
  
  Declare.i WaitEvent( *callback, event.i )
EndDeclareModule 

Module events
  UseModule constants
  
  Global EnteredGadget =- 1,
         PressedGadget =- 1,
         DraggedGadget =- 1,
         FocusedGadget =- 1
  
  Procedure.s GetClassName( handle.i )
    Protected Class$ = Space( 16 )
    GetClassName_( handle, @Class$, Len( Class$ ) )
    ProcedureReturn Class$
  EndProcedure
  
  Procedure IDWindow( handle.i ) ; Return the id of the window from the window handle
    Protected Window = GetProp_( handle, "PB_WindowID" ) - 1
    If IsWindow( Window ) And WindowID( Window ) = handle
      ProcedureReturn Window
    EndIf
    ProcedureReturn - 1
  EndProcedure
  
  Procedure IDgadget( handle.i )  ; Return the id of the gadget from the gadget handle
    Protected gadget = GetProp_( handle, "PB_ID" )
    If IsGadget( gadget ) And GadgetID( gadget ) = handle
      ProcedureReturn gadget
    EndIf
    ProcedureReturn - 1
  EndProcedure
  
  
  Procedure GetWindowUnderMouse( )
    Protected Cursorpos.q, handle
    GetCursorPos_( @Cursorpos )
    handle = WindowFromPoint_( Cursorpos )
    ProcedureReturn GetAncestor_( handle, #GA_ROOT )
  EndProcedure
  
  Procedure GetObjectUnderMouse( handle )
    If handle
      Protected Cursorpos.q
      GetCursorPos_( @Cursorpos )
      ScreenToClient_(handle, @Cursorpos) 
      handle = ChildWindowFromPoint_( handle, Cursorpos )
      ;       If Not handle
      ;         GetCursorPos_( @Cursorpos )
      ;         handle = WindowFromPoint_( Cursorpos )
      ;       EndIf
      ProcedureReturn handle
    Else
      ProcedureReturn 0
    EndIf
  EndProcedure
  
  
  Macro CanvasMouseX( _canvas_ )
    ; GetGadgetAttribute( _canvas_, #PB_Canvas_MouseX )
    DesktopMouseX( ) - GadgetX( _canvas_, #PB_Gadget_ScreenCoordinate )
    ; WindowMouseX( window ) - GadgetX( _canvas_, #PB_Gadget_WindowCoordinate )  
  EndMacro
  
  Macro CanvasMouseY( _canvas_ )
    ; GetGadgetAttribute( _canvas_, #PB_Canvas_MouseY )
    DesktopMouseY( ) - GadgetY( _canvas_, #PB_Gadget_ScreenCoordinate )
    ; WindowMouseY( window ) - GadgetY( _canvas_, #PB_Gadget_WindowCoordinate )
  EndMacro
  
  Procedure.i WaitEvent( *callback, event.i )
    If Not *callback
      ProcedureReturn 0
    EndIf
    
    Static LeftClick, ClickTime, MouseDrag, MouseMoveX, MouseMoveY, DeltaX, DeltaY
    Protected MouseMove, MouseX, MouseY, MoveStart
    Protected EnteredID, Canvas =- 1, EventType =- 1
    
    If MouseDrag Or Event( ) = #PB_Event_Gadget
      EventType = EventType( )
      
      If EventType = #PB_EventType_LeftButtonDown
        MouseDrag = 1
      EndIf
      
      If EventType = #PB_EventType_LeftButtonUp
        If EnteredGadget >= 0 
          If MouseDrag > 0 And PressedGadget = DraggedGadget 
            CompilerIf Defined( constants, #PB_Module )
              CallFunctionFast( *callback, EnteredGadget, #PB_EventType_Drop )
            CompilerEndIf
          EndIf
        EndIf
        MouseDrag = 0
      EndIf
      
      If MouseDrag >= 0
        EnteredID = GetObjectUnderMouse( GetWindowUnderMouse( ) )
      EndIf
      
      ;
      If EnteredID
        Canvas = IDGadget( EnteredID )
        
        If Canvas >= 0
          Mousex = CanvasMouseX( Canvas )
          Mousey = CanvasMouseY( Canvas )
        Else
          Mousex =- 1
          Mousey =- 1
        EndIf
      Else
        Mousex =- 1
        Mousey =- 1
      EndIf
      
      ;
      If MouseDrag And
         Mousex =- 1 And Mousey =- 1
        Mousex = CanvasMouseX( PressedGadget )
        Mousey = CanvasMouseY( PressedGadget )
      EndIf
      
      If MouseMoveX <> Mousex
        MouseMoveX = Mousex
        MouseMove = #True
      EndIf
      
      If MouseMoveY <> Mousey
        MouseMoveY = Mousey
        MouseMove = #True
      EndIf
      
      ;
      If MouseMove 
        If MouseDrag >= 0 And 
           EnteredGadget <> Canvas
          If EnteredGadget >= 0
            CallFunctionFast( *callback, EnteredGadget , #PB_EventType_MouseLeave )
          EndIf
          
          EnteredGadget = Canvas
          
          If EnteredGadget >= 0
            CallFunctionFast( *callback, EnteredGadget, #PB_EventType_MouseEnter )
          EndIf
        Else
          ; mouse drag start
          If MouseDrag > 0
            If DraggedGadget <> PressedGadget
              DraggedGadget = PressedGadget
              CallFunctionFast( *callback, PressedGadget, #PB_EventType_DragStart )
              DeltaX = GadgetX( PressedGadget ) 
              DeltaY = GadgetY( PressedGadget )
            EndIf
          EndIf
          
          If EnteredGadget <> PressedGadget And MouseDrag
            CallFunctionFast( *callback, PressedGadget, #PB_EventType_MouseMove )
          EndIf
          
          If EnteredGadget >= 0
            CallFunctionFast( *callback, EnteredGadget, #PB_EventType_MouseMove )
            If MouseDrag > 0 And PressedGadget = EnteredGadget 
              If DeltaX <> GadgetX( PressedGadget ) Or 
                 DeltaY <> GadgetY( PressedGadget )
                MouseDrag =- 1
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
      
      ;
      If EventType = #PB_EventType_LeftButtonDown
        PressedGadget = EnteredGadget ; EventGadget( )
        
        If FocusedGadget =- 1
          FocusedGadget = GetActiveGadget( )
          If GadgetType( FocusedGadget ) = #PB_GadgetType_Canvas
            CallFunctionFast( *callback, FocusedGadget, #PB_EventType_Focus )
          EndIf
        EndIf
        
        If FocusedGadget >= 0 And 
           FocusedGadget <> PressedGadget
          CallFunctionFast( *callback, FocusedGadget, #PB_EventType_LostFocus )
          
          FocusedGadget = PressedGadget
          CallFunctionFast( *callback, FocusedGadget, #PB_EventType_Focus )
        EndIf
        
        If Not ( ClickTime And ElapsedMilliseconds( ) - ClickTime < 160 )
          CallFunctionFast( *callback, PressedGadget, #PB_EventType_LeftButtonDown )
          LeftClick = 1
          ClickTime = 0
        EndIf
      EndIf
      
      ;
      If EventType = #PB_EventType_LeftButtonUp
        If Not ( ClickTime And ElapsedMilliseconds( ) - ClickTime < DoubleClickTime( ) )
          If LeftClick 
            LeftClick = 0
            
            CallFunctionFast( *callback, PressedGadget, #PB_EventType_LeftButtonUp )
            
            If PressedGadget <> DraggedGadget
              If PressedGadget >= 0 And EnteredID = GadgetID( PressedGadget )
                CallFunctionFast( *callback, PressedGadget, #PB_EventType_LeftClick )
              EndIf
            EndIf
          Else
            If PressedGadget <> DraggedGadget
              CallFunctionFast( *callback, PressedGadget, #PB_EventType_LeftDoubleClick )
            EndIf
          EndIf
          
          ClickTime = ElapsedMilliseconds( )
        Else
          If PressedGadget <> DraggedGadget
            CallFunctionFast( *callback, PressedGadget, #PB_EventType_LeftDoubleClick )
          EndIf
          ClickTime = 0
        EndIf
        ;
        DraggedGadget =- 1
      EndIf
      
      
      If EventType = #PB_EventType_Resize
        CallFunctionFast( *callback, EventGadget( ), #PB_EventType_Resize )
      EndIf
      CompilerIf Defined( constants, #PB_Module )
        If EventType = #PB_EventType_Repaint
          CallFunctionFast( *callback, EventGadget( ), #PB_EventType_Repaint )
        EndIf
      CompilerEndIf
    EndIf
    
    ProcedureReturn event
  EndProcedure
  
  Procedure.i _1WaitEvent( *callback, event.i )
    If Not *callback
      ProcedureReturn 0
    EndIf
    
    Static LeftClick, ClickTime, MouseDrag, MouseMoveX, MouseMoveY
    Protected MouseMove, Mousex, Mousey
    Protected EnteredID, Canvas =- 1, EventType =- 1
    
    If Event( ) = #PB_Event_Gadget Or MouseDrag
      ; Debug "event - "+event+" "+Event()
      EventType = EventType( )
      EnteredID = GetObjectUnderMouse( GetWindowUnderMouse( ) )
      
      ;
      If EnteredID  
        Canvas = IDGadget( EnteredID )
        
        If Canvas >= 0
          Mousex = CanvasMouseX( Canvas )
          Mousey = CanvasMouseY( Canvas )
        Else
          Mousex =- 1
          Mousey =- 1
        EndIf
      Else
        Mousex =- 1
        Mousey =- 1
      EndIf
      
      ;
      If MouseDrag And Mousex =- 1 And Mousey =- 1
        Mousex = CanvasMouseX( PressedGadget )
        Mousey = CanvasMouseY( PressedGadget )
      EndIf
      
      If MouseMoveX <> Mousex
        MouseMoveX = Mousex
        MouseMove = #True
      EndIf
      
      If MouseMoveY <> Mousey
        MouseMoveY = Mousey
        MouseMove = #True
      EndIf
      
      ;
      If MouseMove 
        ;Debug "x="+MouseX +" y="+ MouseY
        If EnteredGadget <> Canvas 
          If EnteredGadget >= 0
            CallFunctionFast( *callback, EnteredGadget , #PB_EventType_MouseLeave )
          EndIf
          
          EnteredGadget = Canvas
          
          If EnteredGadget >= 0
            CallFunctionFast( *callback, EnteredGadget, #PB_EventType_MouseEnter )
          EndIf
        Else
          If MouseDrag 
            ; mouse drag start
            If DraggedGadget <> PressedGadget
              DraggedGadget = PressedGadget
              CallFunctionFast( *callback, PressedGadget, #PB_EventType_DragStart )
            EndIf
          EndIf
          
          If EnteredGadget <> PressedGadget And MouseDrag
            CallFunctionFast( *callback, PressedGadget, #PB_EventType_MouseMove )
          EndIf
          
          If EnteredGadget >= 0
            CallFunctionFast( *callback, EnteredGadget, #PB_EventType_MouseMove )
          EndIf
        EndIf
        
      EndIf
      
      ;
      If EventType = #PB_EventType_LeftButtonDown
        MouseDrag = 1
        PressedGadget = EventGadget( )
        
        If FocusedGadget =- 1
          FocusedGadget = GetActiveGadget( )
          If GadgetType( FocusedGadget ) = #PB_GadgetType_Canvas
            CallFunctionFast( *callback, FocusedGadget, #PB_EventType_Focus )
          EndIf
        EndIf
        
        If FocusedGadget >= 0 And 
           FocusedGadget <> PressedGadget
          CallFunctionFast( *callback, FocusedGadget, #PB_EventType_LostFocus )
          
          FocusedGadget = PressedGadget
          CallFunctionFast( *callback, FocusedGadget, #PB_EventType_Focus )
        EndIf
        
        If Not ( ClickTime And ElapsedMilliseconds( ) - ClickTime < 160 )
          CallFunctionFast( *callback, PressedGadget, #PB_EventType_LeftButtonDown )
          LeftClick = 1
          ClickTime = 0
        EndIf
      EndIf
      
      ;
      If EventType = #PB_EventType_LeftButtonUp
        If Not ( ClickTime And ElapsedMilliseconds( ) - ClickTime < DoubleClickTime( ) )
          If LeftClick 
            LeftClick = 0
            
            If PressedGadget = DraggedGadget
              CompilerIf Defined( constants, #PB_Module )
                CallFunctionFast( *callback, EnteredGadget, #PB_EventType_Drop )
              CompilerEndIf
            EndIf
            
            CallFunctionFast( *callback, PressedGadget, #PB_EventType_LeftButtonUp )
            
            If PressedGadget <> DraggedGadget
              If PressedGadget >= 0 And
                 EnteredID = GadgetID( PressedGadget )
                
                CallFunctionFast( *callback, PressedGadget, #PB_EventType_LeftClick )
              EndIf
            Else
              DraggedGadget =- 1
            EndIf
          Else
            If PressedGadget = DraggedGadget
              CompilerIf Defined( constants, #PB_Module )
                CallFunctionFast( *callback, EnteredGadget, #PB_EventType_Drop )
              CompilerEndIf
              DraggedGadget =- 1
            Else
              CallFunctionFast( *callback, PressedGadget, #PB_EventType_LeftDoubleClick )
            EndIf
          EndIf
          
          
          ClickTime = ElapsedMilliseconds( )
        Else
          If PressedGadget = DraggedGadget
            CompilerIf Defined( constants, #PB_Module )
              CallFunctionFast( *callback, EnteredGadget, #PB_EventType_Drop )
            CompilerEndIf
            DraggedGadget =- 1
          Else
            CallFunctionFast( *callback, PressedGadget, #PB_EventType_LeftDoubleClick )
          EndIf
          ClickTime = 0
        EndIf
        
        MouseDrag = 0
      EndIf
      
      
      If EventType = #PB_EventType_Resize
        CallFunctionFast( *callback, EventGadget( ), #PB_EventType_Resize )
      EndIf
      CompilerIf Defined( constants, #PB_Module )
        If EventType = #PB_EventType_Repaint
          CallFunctionFast( *callback, EventGadget( ), #PB_EventType_Repaint )
        EndIf
      CompilerEndIf
    EndIf
    
    ProcedureReturn event
  EndProcedure
  
EndModule 

CompilerIf #PB_Compiler_IsMainFile
  UseModule constants
  UseModule events
  
  Define event
  
  Procedure DrawCanvasBack( gadget, color )
    StartDrawing( CanvasOutput( gadget ) )
    DrawingMode( #PB_2DDrawing_Default )
    Box( 0,0,OutputWidth( ), OutputHeight( ), color )
    StopDrawing( )
  EndProcedure
  
  Procedure DrawCanvasFrame( gadget, color )
    StartDrawing( CanvasOutput( gadget ) )
    If GetGadgetState( gadget )
      DrawImage( 0,0, GetGadgetState( gadget ) )
    EndIf
    If Not color
      color = Point( 10,10 )
    EndIf
    If color 
      DrawingMode( #PB_2DDrawing_Outlined )
      Box( 0,0,OutputWidth( ), OutputHeight( ), color )
    EndIf
    StopDrawing( )
  EndProcedure
  
  Procedure EventHandler( gadget, eventtype )
    Protected window = EventWindow()
    Static dragGadget =- 1, deltax, deltay
    
    Select eventtype
      Case #PB_EventType_DragStart
        dragGadget = gadget
        Debug ""+Gadget + " #PB_EventType_DragStart " 
      Case #PB_EventType_Drop
        Debug ""+Gadget + " #PB_EventType_Drop " 
      Case #PB_EventType_Focus
        Debug ""+Gadget + " #PB_EventType_Focus " 
        DrawCanvasBack( gadget, $FFA7A4)
        DrawCanvasFrame( gadget, $2C70F5)
      Case #PB_EventType_LostFocus
        Debug ""+Gadget + " #PB_EventType_LostFocus " 
        DrawCanvasBack( gadget, $FFFFFF)
      Case #PB_EventType_LeftButtonDown
        deltax = DesktopMouseX()-GadgetX( gadget, #PB_Gadget_WindowCoordinate )
        deltay = DesktopMouseY()-GadgetY( gadget, #PB_Gadget_WindowCoordinate )
        Debug ""+Gadget + " #PB_EventType_LeftButtonDown " 
      Case #PB_EventType_LeftButtonUp
        dragGadget =- 1
        Debug ""+Gadget + " #PB_EventType_LeftButtonUp " 
      Case #PB_EventType_LeftClick
        Debug ""+Gadget + " #PB_EventType_LeftClick " 
      Case #PB_EventType_LeftDoubleClick
        Debug ""+Gadget + " #PB_EventType_LeftDoubleClick " 
      Case #PB_EventType_MouseEnter
        DrawCanvasFrame( gadget, $2C70F5)
        Debug ""+Gadget + " #PB_EventType_MouseEnter " 
        ;PostEvent( #PB_Event_Gadget , window, gadget, #PB_EventType_Resize )
        
      Case #PB_EventType_MouseLeave
        DrawCanvasFrame( gadget, 0 )
        Debug ""+Gadget + " #PB_EventType_MouseLeave " 
        ; PostEvent( #PB_Event_Gadget , window, gadget, #PB_EventType_Resize )
      Case #PB_EventType_MouseMove
        ; Debug ""+Gadget + " #PB_EventType_MouseMove " 
        If dragGadget >=0 And dragGadget = 1
          ResizeGadget( dragGadget, DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
        EndIf
        
    EndSelect
  EndProcedure
  
  OpenWindow(1, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
  CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus )
  CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
  
  OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu)
  CanvasGadget(2, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
                                                        ; EnableGadgetDrop( 2, #PB_Drop_Private, #PB_Drag_Copy, #PB_Drop_Private )
  
  Debug GadgetID(1)
  Debug GadgetID(11)
  Debug GadgetID(2)
  
  Repeat 
    event = WaitEvent( @EventHandler( ), WaitWindowEvent( ) )
    
    If event = #PB_Event_Gadget
      ;       If EventType() = #PB_EventType_Focus
      ;         Debug ""+EventGadget() + " #PB_EventType_Focus "
      ;       EndIf
      ;       If EventType() = #PB_EventType_LostFocus
      ;         Debug "  "+EventGadget() + " #PB_EventType_LostFocus "
      ;       EndIf
      ;       
      ;       If EventType() = #PB_EventType_LeftButtonDown
      ;         Debug ""+EventGadget() + " #PB_EventType_LeftButtonDown "
      ;       EndIf
      ;       If EventType() = #PB_EventType_LeftButtonUp
      ;         Debug "  "+EventGadget() + " #PB_EventType_LeftButtonUp "
      ;       EndIf
      ;       
      ;       If EventType() = #PB_EventType_Change
      ;         Debug ""+EventGadget() + " #PB_EventType_Change " +EventData()
      ;       EndIf
      ;       If EventType() = #PB_EventType_MouseEnter
      ;         Debug ""+EventGadget() + " #PB_EventType_MouseEnter " +EventData() +" "+ GetActiveWindow( )
      ;       EndIf
      ;       If EventType() = #PB_EventType_MouseLeave
      ;         Debug "  "+EventGadget() + " #PB_EventType_MouseLeave "
      ;       EndIf
    EndIf
    
    If event = #PB_Event_GadgetDrop
      Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_GadgetDrop "
    EndIf
    ;     If event = #PB_Event_Repaint
    ;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_Repaint "
    ;     EndIf
    ;     If event = #PB_Event_LeftClick
    ;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_LeftClick "
    ;     EndIf
    ;     If event = #PB_Event_RightClick
    ;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_RightClick "
    ;     EndIf
    ;     If event = #PB_Event_ActivateWindow
    ;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_ActivateWindow "
    ;     EndIf
    ;     If event = #PB_Event_DeactivateWindow
    ;       Debug ""+EventWindow() +" "+EventGadget() + " #PB_Event_DeactivateWindow "
    ;     EndIf
    
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -----------------
; EnableXP