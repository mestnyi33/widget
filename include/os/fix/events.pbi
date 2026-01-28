CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "../../constants.pbi"
   
   ;\\
   XIncludeFile "../id.pbi"
   XIncludeFile "../mouse.pbi"
   XIncludeFile "../cursor.pbi"
   
CompilerEndIf

;-\\ DECLARE
DeclareModule Events
   EnableExplicit
   UseModule constants
    
   ;Declare.i WaitEvent(event.i, second.i=0)
   CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
      Declare BindGadget( gadget, *callBack, eventtype = #PB_All )
   CompilerEndIf
   Declare SetCallBack(*callback)
EndDeclareModule

;-\\ MODULE
CompilerSelect #PB_Compiler_OS 
   CompilerCase #PB_OS_MacOS   
      XIncludeFile "mac/event.pbi"
   CompilerCase #PB_OS_Windows 
      XIncludeFile "win/event.pbi"
   CompilerCase #PB_OS_Linux   
      XIncludeFile "lin/event.pbi"
CompilerEndSelect

;-\\ example
CompilerIf #PB_Compiler_IsMainFile
   UseModule constants
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      XIncludeFile "../../os/win/ClipGadgets.pbi"
   CompilerEndIf
   
   ; UseModule events
   
   Define event
   Global g1,g2, color11
   
   Procedure   DrawCanvasBack(gadget, color)
      If GadgetType(gadget) = #PB_GadgetType_Canvas
         StartDrawing(CanvasOutput(gadget))
         DrawingMode(#PB_2DDrawing_Default)
         Box(0,0,OutputWidth(), OutputHeight(), color)
         StopDrawing()
      EndIf
   EndProcedure
   
   Procedure   DrawCanvasFrame(gadget, color)
      If GadgetType(gadget) = #PB_GadgetType_Canvas
         StartDrawing(CanvasOutput(gadget))
         If GetGadgetState(gadget)
            DrawImage(0,0, GetGadgetState(gadget))
         EndIf
         If Not color
            color = Point(10,10)
         EndIf
         If color 
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(0,0,OutputWidth(), OutputHeight(), color)
         EndIf
         StopDrawing()
      EndIf
   EndProcedure
   
   Procedure Resize_2()
      Protected Canvas = 2
      ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(Canvas)*2, WindowHeight(EventWindow()) - GadgetY(Canvas)*2)
   EndProcedure
   
   Procedure Resize_3()
      Protected Canvas = 3
      ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(Canvas)*2, WindowHeight(EventWindow()) - GadgetY(Canvas)*2)
   EndProcedure
   
   Procedure EventHandler( event, eventobject, eventtype, eventdata )
      Protected window = EventWindow()
      Protected DropX, DropY
      Static deltax, deltay, PressedGadget
      
      Select eventtype
         Case #PB_EventType_MouseWheelX
            Debug ""+eventobject + " #PB_EventType_MouseWheelX " +eventdata
            
         Case #PB_EventType_MouseWheelY
            Debug ""+eventobject + " #PB_EventType_MouseWheelY " +eventdata
            
         Case #PB_EventType_DragStart
            PressedGadget = eventobject
            deltax = mouse::GadgetMouseX(eventobject, #PB_Gadget_WindowCoordinate)
            deltay = mouse::GadgetMouseY(eventobject, #PB_Gadget_WindowCoordinate)
            Debug ""+eventobject + " #PB_EventType_DragStart " + "x="+ deltax +" y="+ deltay
            
         Case #PB_EventType_Drop
            DropX = mouse::GadgetMouseX(eventobject, #PB_Gadget_ScreenCoordinate)
            DropY = mouse::GadgetMouseY(eventobject, #PB_Gadget_ScreenCoordinate)
            Debug ""+eventobject + " #PB_EventType_Drop " + "x="+ DropX +" y="+ DropY
            
         Case #PB_EventType_Focus
            Debug ""+eventobject + " #PB_EventType_Focus " 
            DrawCanvasBack(eventobject, $FFA7A4)
            DrawCanvasFrame(eventobject, $2C70F5)
            
         Case #PB_EventType_LostFocus
            Debug ""+eventobject + " #PB_EventType_LostFocus " 
            DrawCanvasBack(eventobject, $FFFFFF)
            
         Case #PB_EventType_LeftButtonDown
            Debug ""+eventobject + " #PB_EventType_LeftButtonDown " 
            
         Case #PB_EventType_LeftButtonUp
            Debug ""+eventobject + " #PB_EventType_LeftButtonUp " 
            PressedGadget = 0
            
         Case #PB_EventType_LeftClick
            Debug ""+eventobject + " #PB_EventType_LeftClick " 
            
         Case #PB_EventType_LeftDoubleClick
            Debug ""+eventobject + " #PB_EventType_LeftDoubleClick " 
            
         Case #PB_EventType_MouseEnter
            ;Debug ""+eventobject + " #PB_EventType_MouseEnter " ;+ CocoaMessage(0, WindowID(window), "isActive") 
            DrawCanvasFrame(eventobject, $00A600)
            
         Case #PB_EventType_MouseLeave
            ;Debug ""+eventobject + " #PB_EventType_MouseLeave "
            DrawCanvasFrame(eventobject, 0)
            
         Case #PB_EventType_Resize
            Debug ""+eventobject + " #PB_EventType_Resize " 
            
         Case #PB_EventType_MouseMove
            If PressedGadget
               ;Debug ""+eventobject + " #PB_EventType_MouseMove " 
               ResizeGadget(PressedGadget, DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
            EndIf
            ;         If events::DraggedGadget() = 0
            ;           ResizeGadget(events::DraggedGadget(), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
            ;         EndIf
            
      EndSelect
   EndProcedure
   
   Procedure OpenWindow_(window, X,Y,Width,Height, title.s, Flag=0)
      Protected result = OpenWindow(window, X,Y,Width,Height, title.s, Flag)
      If window >= 0
         WindowID = WindowID(window)
      Else
         WindowID = result
      EndIf
      
      ;CocoaMessage(0, WindowID, "disableCursorRects")
      ProcedureReturn result
   EndProcedure
   
   Macro OpenWindow(window, X,Y,Width,Height, title, Flag=0)
      OpenWindow_(window, X,Y,Width,Height, title, Flag)
   EndMacro
   
   ;/// first
   OpenWindow(1, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
   CanvasGadget(0, 240, 10, 60, 60, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
   CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
   CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
   ButtonGadget(100, 60,240,60,60,"")
   g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
   g2=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
   SplitterGadget(111,10,240,60,60, g1,g2)
   
   If cursor::set((111),cursor::#__cursor_UpDown)
      Debug "updown"           
   EndIf       
   
   If cursor::set((100),cursor::#__cursor_Hand)
      Debug "setCursorHand"           
   EndIf       
   
   If cursor::set((g1),cursor::#__cursor_IBeam)
      Debug "setCursorIBeam"           
   EndIf       
   
   If cursor::set((g2),cursor::#__cursor_IBeam)
      Debug "setCursorIBeam"           
   EndIf       
   
   UsePNGImageDecoder()
   
   If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png") = 0
      MessageRequester("Error",
                       "Loading of image World.png failed!",
                       #PB_MessageRequester_Error)
      End
   EndIf
   
   If cursor::set((0), cursor::Create(ImageID(0)))
      Debug "setCursorImage"           
   EndIf       
   
   If cursor::set((1),cursor::#__cursor_Hand)
      ;Debug "setCursorHand - " +CocoaMessage(0, 0, "NSCursor currentCursor")
   EndIf       
   
   If cursor::set((11),cursor::#__cursor_Cross)
      Debug "setCursorCross"           
   EndIf       
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ClipGadgets( UseGadgetList(0) )
   CompilerEndIf
   
   ;/// second
   OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
   g1=StringGadget(-1,0,0,0,0,"StringGadget")
   g2=HyperLinkGadget(-1,0,0,0,0,"HyperLinkGadget", 0)
   SplitterGadget(2, 10, 10, 200, 200, g1,g2)
   BindEvent(#PB_Event_SizeWindow, @Resize_2(), 2)
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ClipGadgets( UseGadgetList(0) )
   CompilerEndIf
   
   ;/// third
   OpenWindow(3, 450+50, 200+50, 220, 220, "window_3", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
   g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
   g2=StringGadget(-1,0,0,0,0,"StringGadget")
   SplitterGadget(3,10, 10, 200, 200, g1,g2)
   BindEvent(#PB_Event_SizeWindow, @Resize_3(), 3)
   
   If cursor::set((g1),cursor::#__cursor_IBeam)
      Debug "setCursorIBeam"           
   EndIf       
   
   DrawCanvasBack(11, $73C7F8)
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ClipGadgets( UseGadgetList(0) )
   CompilerEndIf
   
   ; fixed events
   Events::SetCallBack( 0 )
   
   Repeat 
      event = WaitWindowEvent()
      
      If event = #PB_Event_Gadget
         EventHandler( event, EventGadget(), EventType(), EventData())
      EndIf
      
   Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 1
; Folding = ------
; EnableXP