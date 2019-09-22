DeclareModule Order
  EnableExplicit
  
  Declare GetLast(ParentID)
  Declare GetPrev(Gadget)
  Declare GetNext(Gadget)
  Declare GetFirst(ParentID)
  
  Declare SetLast(Gadget)
  Declare SetFirst(Gadget)
  Declare SetPrev(Gadget, NextGadget=-1)
  Declare SetNext(Gadget, PrevGadget=-1)
  
  Declare Clip(Gadget)
  Declare Fix(WindowID)
  Declare Intersect(Gadget_1, *Gadget_2)
EndDeclareModule

Module Order
  Procedure ID( GadgetID )  ; Return the id of the gadget from the gadget handle
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Protected Gadget = GetProp_( GadgetID, "PB_ID" )
      
      If ( IsGadget( Gadget ) And 
           GadgetID( Gadget ) = GadgetID )
        
        ProcedureReturn Gadget
      EndIf
      
      ProcedureReturn - 1
    CompilerEndIf   
  EndProcedure
  
  Procedure GetFirst(ParentID) ; Get last gadget from the parent handle
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ProcedureReturn ID(GetWindow_(FindWindowEx_(ParentID, 0, 0, 0), #GW_HWNDLAST))
    CompilerEndIf   
  EndProcedure
  
  Procedure GetLast(ParentID) ; Get first gadget from the parent handle
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ProcedureReturn ID(GetWindow_(FindWindowEx_(ParentID, 0, 0, 0), #GW_HWNDFIRST))
    CompilerEndIf   
  EndProcedure
  
  Procedure GetNext(Gadget) ;Returns gadget prev gadget
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Protected GadgetID : If IsGadget(Gadget) : GadgetID = GadgetID(Gadget) : EndIf  
      ProcedureReturn ID(GetWindow_(GadgetID, #GW_HWNDPREV))
    CompilerEndIf   
  EndProcedure
  
  Procedure GetPrev(Gadget) ;Returns gadget prev gadget
    Protected GadgetID : If IsGadget(Gadget) : GadgetID = GadgetID(Gadget) : EndIf  
    
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_MacOS
       ; ProcedureReturn CocoaMessage(0, CocoaMessage(0, GadgetID(Gadget), "superview"), "addSubview:", GadgetID(Result), "Gadget:", 1, "relativeTo:", #nil)
        
      CompilerCase #PB_OS_Windows
        ProcedureReturn ID(GetWindow_(GadgetID, #GW_HWNDNEXT))
    CompilerEndSelect 
  EndProcedure
  
  Procedure SetNext(Gadget, PrevGadget=-1) ;Set prev_gadget prev one if gadget then prev gadget ; Previous
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Protected Result
      
      If IsGadget(Gadget)
        If IsGadget(PrevGadget)
          Result = Gadget
          Gadget = GetNext(PrevGadget)
        Else
          Result = GetNext(Gadget)
        EndIf
        
        If IsGadget(Result)
          ProcedureReturn SetWindowPos_(GadgetID(Result), GadgetID(Gadget), 0, 0, 0, 0, #SWP_NOSIZE | #SWP_NOMOVE)
        EndIf  
      EndIf  
      
      ProcedureReturn #PB_Default 
    CompilerEndIf   
  EndProcedure
  
  Procedure SetPrev(Gadget, NextGadget=-1) ;Set next_gadget next one if gadget then next gadget ; Following
    Protected Result
    
    If IsGadget(Gadget)
      
      If IsGadget(NextGadget)
        Result = NextGadget
      Else
        Result = GetPrev(Gadget)
      EndIf
      
      If IsGadget(Result)
        CompilerSelect #PB_Compiler_OS 
          CompilerCase #PB_OS_MacOS
            ProcedureReturn CocoaMessage(0, CocoaMessage(0, GadgetID(Gadget), "superview"), "addSubview:", GadgetID(Gadget), "positioned:", -1, "relativeTo:", Result)
            
          CompilerCase #PB_OS_Windows
            ProcedureReturn SetWindowPos_(GadgetID(Gadget), GadgetID(Result), 0, 0, 0, 0, #SWP_NOSIZE | #SWP_NOMOVE)
            
        CompilerEndSelect 
      Else
        ProcedureReturn #PB_Default 
      EndIf  
    EndIf  
  EndProcedure
  
  Procedure SetFirst(Gadget) ;Returns gadget prev gadget
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_MacOS
          CocoaMessage(0, CocoaMessage(0, GadgetID(Gadget), "superview"), "addSubview:", GadgetID(Gadget), "positioned:", 1, "relativeTo:", #nil)

      CompilerCase #PB_OS_Windows
      Protected Result
      
      If IsGadget(Gadget)
        ProcedureReturn SetWindowPos_(GadgetID(Gadget), #HWND_BOTTOM, 0, 0, 0, 0, #SWP_NOSIZE | #SWP_NOMOVE)
      EndIf  
      
      ProcedureReturn #PB_Default 
    CompilerEndSelect
  EndProcedure
  
  Procedure SetLast(Gadget) ;Returns gadget prev gadget
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_MacOS
          CocoaMessage(0, CocoaMessage(0, GadgetID(Gadget), "superview"), "addSubview:", GadgetID(Gadget), "positioned:", -1, "relativeTo:", #nil)

      CompilerCase #PB_OS_Windows
        Protected Result
        
        If IsGadget(Gadget)
          ProcedureReturn SetWindowPos_(GadgetID(Gadget), #HWND_TOP, 0, 0, 0, 0, #SWP_NOSIZE | #SWP_NOMOVE)
        EndIf  
        
        ProcedureReturn #PB_Default 
    CompilerEndSelect
  EndProcedure
  
  ; Есть ли пересечение между первым и вторим гаджетом?
  Procedure Intersect(Gadget_1, *Gadget_2) ; Returns TRUE if gadget1 rect inter gadget2 rect
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Protected.RECT Intersect, Frame_1, Frame_2, *Frame = *Gadget_2
      
      GetWindowRect_(GadgetID(Gadget_1), @Frame_1)
      
      If IsGadget(*Gadget_2)
        GetWindowRect_(GadgetID(*Gadget_2), @Frame_2)
      ElseIf *Frame
        With *Frame
          If \left > \right : Frame_2\left = \right : Frame_2\right = \left : Else : Frame_2\left = \left : Frame_2\right = \right : EndIf
          If \top > \bottom : Frame_2\top = \bottom : Frame_2\bottom = \top : Else : Frame_2\top = \top : Frame_2\bottom = \bottom : EndIf
        EndWith
      EndIf
      
      ProcedureReturn IntersectRect_(@Intersect, @Frame_1, @Frame_2)
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      Protected.GtkWidget *widget = GadgetID( Gadget_1 )
      Protected.GdkRectangle Intersect, Frame_1, Frame_2, *Frame = *Gadget_2
      
      Frame_1\x = GadgetX(Gadget_1, #PB_Gadget_ScreenCoordinate)
      Frame_1\y = GadgetY(Gadget_1, #PB_Gadget_ScreenCoordinate)
      Frame_1\width =  GadgetWidth(Gadget_1)
      Frame_1\height =  GadgetHeight(Gadget_1)
      
      If IsGadget(*Gadget_2)
        
        Frame_2\x = GadgetX(*Gadget_2, #PB_Gadget_ScreenCoordinate)
        Frame_2\y = GadgetY(*Gadget_2, #PB_Gadget_ScreenCoordinate)
        Frame_2\width =  GadgetWidth(*Gadget_2)
        Frame_2\height =  GadgetHeight(*Gadget_2)
        
      ElseIf *Frame
        With *Frame
          If \x > \width : Frame_2\x = \width : Frame_2\width = \x-\width : Else : Frame_2\x = \x : Frame_2\width = \width-\x : EndIf
          If \y > \height : Frame_2\y = \height : Frame_2\height = \y-\height : Else : Frame_2\y = \y : Frame_2\height = \height-\y : EndIf
        EndWith
      EndIf 
      
      ProcedureReturn gdk_rectangle_intersect_ (@Frame_1, @Frame_2, @Intersect)
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
;       Protected Range.NSRange
;       
;       Range\location = 5
;       Range\length = 10
     ; CocoaMessage(0, GadgetID(Gadget_1), "setSelectedRange:@", @Range)
    CompilerEndIf   
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Procedure FixCallBack( GadgetID, lParam )
      If GadgetID
        Protected Gadget = ID( GadgetID )
        
        If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
          If IsGadget( Gadget ) 
            Select GadgetType( Gadget )
              Case #PB_GadgetType_ComboBox
                Protected Height = GadgetHeight( Gadget )
            EndSelect
          EndIf
          
          SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS )
          If Height : ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height ) : EndIf
          SetWindowPos_( GadgetID, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
        EndIf
        
      EndIf
      
      ProcedureReturn GadgetID
    EndProcedure
  CompilerEndIf
  
  Procedure Clip(Gadget)
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Protected ClipMacroGadgetHeight = GadgetHeight( Gadget )
      SetWindowLongPtr_( GadgetID( Gadget ), #GWL_STYLE, GetWindowLongPtr_( GadgetID( Gadget ), #GWL_STYLE )|#WS_CLIPSIBLINGS )
      If ClipMacroGadgetHeight And GadgetType( Gadget ) = #PB_GadgetType_ComboBox
        ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, ClipMacroGadgetHeight )
      EndIf
      SetWindowPos_( GadgetID( Gadget ), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
    CompilerEndIf
  EndProcedure
  
  Procedure Fix( WindowID )
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      EnumChildWindows_( WindowID, @FixCallBack(), 0 )
    CompilerEndIf
  EndProcedure
EndModule


;--------- Example --------
CompilerIf #PB_Compiler_IsMainFile
  UseModule Order
  Global ParentID
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Import ""
    CompilerElse
      ImportC ""
      CompilerEndIf
      PB_Object_EnumerateStart(Object)
      PB_Object_EnumerateNext(Object,*ID.Integer)
      PB_Object_EnumerateAbort(Object)
      
      PB_Window_Objects.l
      PB_Gadget_Objects.l
    EndImport
    
    Procedure GetIntersectGadget(Window,X,Y,w,h)
      Protected x1,y1
        x1=WindowX(Window, #PB_Window_InnerCoordinate)
        y1=WindowY(Window, #PB_Window_InnerCoordinate)
      
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        Protected Frame.Rect
        Frame\left=x1+X
        Frame\top=y1+Y
        Frame\right=x1+w
        Frame\bottom=y1+h
      CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
        Protected Frame.GdkRectangle
        Frame\x=x1+X
        Frame\y=y1+Y
        Frame\width=x1+w
        Frame\height=y1+h
      CompilerEndIf
      
      Debug ""
      PB_Object_EnumerateStart(PB_Gadget_Objects)
      While PB_Object_EnumerateNext(PB_Gadget_Objects, @Gadget) 
        If Intersect(Gadget, @Frame)
          Debug "intersect gadget "+Gadget
        EndIf  
      Wend
      PB_Object_EnumerateAbort(PB_Gadget_Objects)
    EndProcedure
    
    Procedure InvalidateWindow( Window )
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        InvalidateRect_( WindowID( Window ), #False, #True ) 
        ;UpdateWindow_(WindowID(Window))
      CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
        gtk_widget_queue_draw_ ( gtk_widget_get_ancestor_ (WindowID(Window), gtk_window_get_type_ ()))
;         gtk_widget_queue_draw_ ( g_list_nth_data_( gtk_container_get_children_( gtk_bin_get_child_( WindowID( Window ))), 0))
        ;gdk_window_invalidate_rect_( WindowID( Window ), *Rect, Inv);
      CompilerEndIf
    EndProcedure
    
    Procedure DrawSelector( Window,MouseX,MouseY,State,Pen =3,PenColor =$1081F5 ) 
      Static Stop,lastX, lastY
      Static MoveMouseX, MoveMouseY
      Protected hDC
      
      If State :Stop =1
        ;SetWindowRedraw_(WindowID(Window), #False);
        ;LockWindowUpdate_(WindowID(Window))
        
        hDC = StartDrawing(WindowOutput(Window))
        If hDC
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_XOr) :PenColor = ( ~PenColor ) & $FFFFFF
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            Delay(50)
            DrawingMode(#PB_2DDrawing_Outlined) :SetROP2_(hdc, #R2_NOTXORPEN)
          CompilerEndIf
          
          Box(lastX, lastY, MoveMouseX-lastX, MoveMouseY-lastY,PenColor)
          lastX = MouseX :MoveMouseX = WindowMouseX(Window)
          lastY = MouseY :MoveMouseY = WindowMouseY(Window) 
          Box( lastX, lastY, MoveMouseX-lastX, MoveMouseY-lastY,PenColor)
          
          StopDrawing()
          ProcedureReturn State
        EndIf
      Else
        If Stop :Stop = 0
          ;SetWindowRedraw_(WindowID(Window), #True);
          ;LockWindowUpdate_(0)
          ;GetIntersectGadget(Window,WindowX(Window, #PB_Window_InnerCoordinate)+lastX, WindowY(Window, #PB_Window_InnerCoordinate)+lastY, WindowX(Window, #PB_Window_InnerCoordinate)+MoveMouseX, WindowY(Window, #PB_Window_InnerCoordinate)+MoveMouseY)
          GetIntersectGadget(Window,lastX, lastY, MoveMouseX, MoveMouseY)
          InvalidateWindow( Window )
          lastX = MoveMouseX
          lastY = MoveMouseY
        EndIf
      EndIf
    EndProcedure
    #First=99
    #PrevOne=100
    #NextOne=101
    #Last=102
    
    Procedure Resize()
      ResizeWindow(10,WindowX(0, #PB_Window_InnerCoordinate),WindowY(0)+WindowHeight(0, #PB_Window_FrameCoordinate)-5,#PB_Ignore,#PB_Ignore)
    EndProcedure
    
    Procedure Demo()
      ParentID = OpenWindow(0, 0, 0, 250, 95, "Demo z-order gadget", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
      
      ButtonGadget(10, 10, 25, 50, 46, "10",#PB_Button_Left)
      
      ButtonGadget(9, 35, 46, 205, 20, "9",#PB_Button_Right)
      ButtonGadget(8, 35, 44, 190, 20, "8",#PB_Button_Right)
      ButtonGadget(7, 35, 42, 175, 20, "7",#PB_Button_Right)
      ButtonGadget(6, 35, 40, 160, 20, "6",#PB_Button_Right)
      ButtonGadget(5, 35, 38, 145, 20, "5",#PB_Button_Right)
      ButtonGadget(4, 35, 36, 130, 20, "4",#PB_Button_Right)
      ButtonGadget(3, 35, 34, 115, 20, "3",#PB_Button_Right)
      ButtonGadget(2, 35, 32, 100, 20, "2",#PB_Button_Right)
      ButtonGadget(1, 35, 30, 85, 20, "1",#PB_Button_Right)
      
      ResizeWindow(0,#PB_Ignore,WindowY(0)-120,#PB_Ignore,#PB_Ignore)
      BindEvent(#PB_Event_MoveWindow, @Resize(), 0)
      
      OpenWindow(10, 0, 0, 250, 125, "", #PB_Window_BorderLess|#PB_Window_ScreenCentered, ParentID)
      ButtonGadget(#First, 5, 10, 240, 20, "move to the first position gadget №10")
      ButtonGadget(#PrevOne, 5, 40, 240, 20, "move to the prev position gadget №10")
      
      ButtonGadget(#NextOne, 5, 70, 240, 20, "move to the next position gadget №10")
      ButtonGadget(#Last, 5, 100, 240, 20, "move to the last position gadget №10")
    EndProcedure
    
    Demo()
    Fix(ParentID)
    
    ClearDebugOutput()
    Debug "first "+GetFirst(ParentID)
    Debug "last "+GetLast(ParentID)
    Debug "prev №1 < № "+GetPrev(10)
    Debug "next №1 > № "+GetNext(10)
    Debug ""
    Debug "Intersect 1&10 = "+ Intersect(1, 10)
    Debug "Intersect 99&102 = "+ Intersect(99, 102)
    
    Global Click ,mx,my
    Repeat
      Event = WaitWindowEvent()
      Select Event
        Case #PB_Event_Gadget
          Select EventType()
            Case #PB_EventType_LeftClick
              Select EventGadget()
                Case #First
                  SetFirst(10)
                  ;               SetPrev(10,2)
                  
                Case #PrevOne
                  SetPrev(10)
                  
                Case #NextOne
                  SetNext(10)
                  
                Case #Last
                  SetLast(10)
                  ;              SetNext(10,2)
                  
              EndSelect
              
              ClearDebugOutput()
              Debug "first "+GetFirst(ParentID)
              Debug "last "+GetLast(ParentID)
              Debug "prev №1 < № "+GetPrev(1)
              Debug "next №1 > № "+GetNext(1)
              
          EndSelect
          
        Default
          If IsWindow( EventWindow() )
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows 
              If (GetAsyncKeyState_(#VK_LBUTTON) >> 15 & 1) 
                If Click
                  DrawSelector(EventWindow(), mx, my, Click)
                EndIf
                If Click = 0 : Click = 1
                  mx = WindowMouseX(EventWindow())
                  my = WindowMouseY(EventWindow())
                EndIf
              Else
                If Click : Click = 0
                  DrawSelector(EventWindow(), mx, my, Click)
                EndIf
              EndIf  
              
            CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
              ;               Define.l X,Y,mask,*Window.GTKWindow = WindowID(EventWindow()) 
              ;               gdk_window_get_pointer_(*Window\bin\child\window, @x, @y, @mask)
              Define.l X,Y,mask, *GdkWindow.GdkWindowObject = gdk_window_at_pointer_(0,0)
              If *GdkWindow
                gdk_window_get_pointer_(*GdkWindow\parent, @x, @y, @mask)
              EndIf
              If     (mask & #GDK_BUTTON1_MASK)
                If Click = 0 
                  Click = 1
                  mx = WindowMouseX(EventWindow())
                  my = WindowMouseY(EventWindow())
                EndIf
                If Click
                  DrawSelector(EventWindow(), mx, my, Click)
                  InvalidateWindow( EventWindow() )
                EndIf
              Else
                If Click
                  Click = 0
                  DrawSelector(EventWindow(), mx, my, Click)
                EndIf
              EndIf
            CompilerEndIf
          EndIf
      EndSelect
    Until Event = #PB_Event_CloseWindow
  CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = 8-----+3-----
; EnableXP