CompilerIf Not Defined( constants, #PB_Module )
   DeclareModule constants
      CompilerIf #PB_Compiler_Version =< 546
      #PB_MessageRequester_Error = 1<<5
      #PB_EventType_Resize = 6
      CompilerEndIf
      Enumeration #PB_EventType_FirstCustomValue
         #PB_EventType_Drop
         #PB_EventType_CursorChange
         #PB_EventType_MouseWheelX
         #PB_EventType_MouseWheelY
      EndEnumeration
   EndDeclareModule
   Module constants
   EndModule
CompilerEndIf

;-\\ DECLARE
DeclareModule Cursor
   EnableExplicit
   UsePNGImageDecoder()
   #test_cursor = 0
   
   Enumeration 
      #__cursor_Default         ; = 0 
      #__cursor_Cross           ; = 1 
      #__cursor_IBeam           ; = 2 
      #__cursor_Hand            ; = 3  
      #__cursor_Busy            ; = 4  
      #__cursor_Denied          ; = 5  
      #__cursor_Arrows          ; = 6  
      
      #__cursor_UpDown          ; = 7 
      #__cursor_LeftRight       ; = 8 
      #__cursor_Diagonal1       ; = 9
      #__cursor_Diagonal2       ; = 10
      
      #__cursor_Invisible       ; = 11
      
      #__cursor_SplitUp 
      #__cursor_SplitDown           
      #__cursor_SplitLeft  
      #__cursor_SplitRight           
      #__cursor_SplitUpDown      
      #__cursor_SplitLeftRight  
      
      #__cursor_LeftUp
      #__cursor_RightUp
      #__cursor_LeftDown
      #__cursor_RightDown
      
      #__cursor_Drag
      #__cursor_Drop
      
      #__cursor_Grab            
      #__cursor_Grabbing
      #__cursor_VIBeam
      ;#__cursor_Arrow 
      
      CompilerIf #PB_Compiler_OS = #PB_OS_Linux
         #__cursor_Up 
         #__cursor_Down           
         #__cursor_Left  
         #__cursor_Right           
      CompilerEndIf
   EndEnumeration
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or 
              #PB_Compiler_OS = #PB_OS_MacOS
      #__cursor_Up    = #__cursor_UpDown
      #__cursor_Down  = #__cursor_UpDown       
      #__cursor_Left  = #__cursor_LeftRight
      #__cursor_Right = #__cursor_LeftRight        
   CompilerEndIf
   
   #__cursor_LeftUpRightDown = #__cursor_Diagonal1
   #__cursor_LeftDownRightUp = #__cursor_Diagonal2
   
   Structure _s_cursor
      Type.a
      *hcursor
      windowID.i
   EndStructure
   
   ;Declare   isHiden( )
   ;Declare   Hide( state.b )
   Declare   Free( *cursor )
   ;Declare   Get( )
   ;Declare   Clip( x.l,y.l,width.l,height.l )
   Declare   Image( Type.a = 0 )
   Declare   Set( Gadget.i, *cursor );, x.i = 0, y.i = 0)
   Declare   Change( GadgetID.i, state.b )
   Declare.i Create( ImageID.i, X.l = 0, Y.l = 0 )
   
   
   ;\\
   Macro DrawImageUp(X, Y, size, bcolor, fcolor)
                                            Line(X+size/2-1, Y  , 2, 1, fcolor)                                                                                       ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      Plot(X+size/2-2, Y+1, fcolor )      : Line(X+size/2-1, Y+1, 2, 1, bcolor) : Plot(X+size/2+1, Y+1, fcolor )                ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X+size/2-3, Y+2, fcolor )      : Line(X+size/2-2, Y+2, 4, 1, bcolor) : Plot(X+size/2+2, Y+2, fcolor )                ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
      Plot(X+size/2-4, Y+3, fcolor )      : Line(X+size/2-3, Y+3, 6, 1, bcolor) : Plot(X+size/2+3, Y+3, fcolor )                ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
      Line(X+size/2-4, Y+4, 3, 1, fcolor) : Line(X+size/2-1, Y+4, 2, 1, bcolor) : Line(X+size/2+1, Y+4, 3 , 1, fcolor)          ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X+size/2-2, Y+5, fcolor )      : Line(X+size/2-1, Y+5, 2, 1, bcolor) : Plot(X+size/2+1, Y+5, fcolor )                ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
   EndMacro
   Macro DrawImageDown(X, Y, size, bcolor, fcolor)
      Plot(X+size/2-2, Y+4, fcolor )      : Line(X+size/2-1, Y+4, 2, 1, bcolor) : Plot(X+size/2+1, Y+4, fcolor )                     ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Line(X+size/2-4, Y+5, 3, 1, fcolor) : Line(X+size/2-1, Y+5, 2, 1, bcolor) : Line(X+size/2+1, Y+5, 3, 1, fcolor)                  ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X+size/2-4, Y+6, fcolor )      : Line(X+size/2-3, Y+6, 6, 1, bcolor) : Plot(X+size/2+3, Y+6, fcolor )                                  ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
      Plot(X+size/2-3, Y+7, fcolor )      : Line(X+size/2-2, Y+7, 4, 1, bcolor) : Plot(X+size/2+2, Y+7, fcolor )                                  ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
      Plot(X+size/2-2, Y+8, fcolor )      : Line(X+size/2-1, Y+8, 2, 1, bcolor) : Plot(X+size/2+1, Y+8, fcolor )                                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
                                            Line(X+size/2-1, Y+9, 2, 1, fcolor)                                                                                       ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   EndMacro
   Macro DrawImageLeft(X, Y, size, bcolor, fcolor)
                                            Line(X  , Y+size/2-1, 1, 2, fcolor)                                                                                          ; 0,0,0,0,0,0,0,0,0
      Plot(X+1, Y+size/2-2, fcolor )      : Line(X+1, Y+size/2-1, 1, 2, bcolor) : Plot(X+1, Y+size/2+1, fcolor )                                    ; 1,0,0,0,0,0,0,0,0
      Plot(X+2, Y+size/2-3, fcolor )      : Line(X+2, Y+size/2-2, 1, 4, bcolor) : Plot(X+2, Y+size/2+2, fcolor )                                   ; 1,0,0,0,0,0,0,0,0
      Plot(X+3, Y+size/2-4, fcolor )      : Line(X+3, Y+size/2-3, 1, 6, bcolor) : Plot(X+3, Y+size/2+3, fcolor )                                   ; 1,0,0,0,0,0,0,0,0
      Line(X+4, Y+size/2-4, 1, 3, fcolor) : Line(X+4, Y+size/2-1, 1, 2, bcolor) : Line(X+4, Y+size/2+1, 1, 3, fcolor)                  ; 1,0,0,0,0,0,0,0,0
      Plot(X+5, Y+size/2-2, fcolor )      : Line(X+5, Y+size/2-1, 1, 2, bcolor) : Plot(X+5, Y+size/2+1, fcolor )                    ; 1,0,0,0,0,1,0,0,0
   EndMacro  
   Macro DrawImageRight(X, Y, size, bcolor, fcolor)
      Plot(X+4, Y+size/2-2, fcolor )      : Line(X+4, Y+size/2-1, 1, 2, bcolor) : Plot(X+4, Y+size/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Line(X+5, Y+size/2-4, 1, 3, fcolor) : Line(X+5, Y+size/2-1, 1, 2, bcolor) : Line(X+5, Y+size/2+1, 1, 3, fcolor)                  ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X+6, Y+size/2-4, fcolor )      : Line(X+6, Y+size/2-3, 1, 6, bcolor) : Plot(X+6, Y+size/2+3, fcolor )                                   ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
      Plot(X+7, Y+size/2-3, fcolor )      : Line(X+7, Y+size/2-2, 1, 4, bcolor) : Plot(X+7, Y+size/2+2, fcolor )                                   ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
      Plot(X+8, Y+size/2-2, fcolor )      : Line(X+8, Y+size/2-1, 1, 2, bcolor) : Plot(X+8, Y+size/2+1, fcolor )                                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
                                            Line(X+9, Y+size/2-1, 1, 2, fcolor)                                                                                        ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   EndMacro
   
   ;-
   Macro DrawImageCursorUp(X, Y, size, bcolor, fcolor)
      cursor::DrawImageUp(X, Y, size, bcolor, fcolor)
      Plot(X+size/2-2, Y+6, fcolor ) : Line(X+7, Y+6, 2, 1, bcolor) : Plot(X+size/2+1, Y+6, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X+size/2-2, Y+7, fcolor ) : Line(X+7, Y+7, 2, 1, bcolor) : Plot(X+size/2+1, Y+7, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
   EndMacro
   Macro DrawImageCursorDown(X, Y, size, bcolor, fcolor)
      Plot(X+size/2-2, Y+2, fcolor ) : Line(X+7, Y+2, 2, 1, bcolor) : Plot(X+size/2+1, Y+2, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X+size/2-2, Y+3, fcolor ) : Line(X+7, Y+3, 2, 1, bcolor) : Plot(X+size/2+1, Y+3, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      cursor::DrawImageDown(X, Y, size, bcolor, fcolor)
   EndMacro
   Macro DrawImageCursorLeft(X, Y, size, bcolor, fcolor)
      cursor::DrawImageLeft(X, Y, size, bcolor, fcolor)
      Plot(X+6, Y+size/2-2, fcolor ) : Line(X+6, Y+7, 1, 2, bcolor) : Plot(X+6, Y+size/2+1, fcolor )                    ; 1,0,0,0,0,1,0,0,0
      Plot(X+7, Y+size/2-2, fcolor ) : Line(X+7, Y+7, 1, 2, bcolor) : Plot(X+7, Y+size/2+1, fcolor )                    ; 1,0,0,0,0,1,0,0,0
   EndMacro  
   Macro DrawImageCursorRight(X, Y, size, bcolor, fcolor)
      Plot(X+2, Y+size/2-2, fcolor ) : Line(X+2, Y+7, 1, 2, bcolor) : Plot(X+2, Y+size/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X+3, Y+size/2-2, fcolor ) : Line(X+3, Y+7, 1, 2, bcolor) : Plot(X+3, Y+size/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      cursor::DrawImageRight(X, Y, size, bcolor, fcolor)
   EndMacro
   
   ;-
   Macro DrawImageCursorSplitUp(X, Y, size, bcolor, fcolor)
      cursor::DrawImageUp(X, Y, size, bcolor, fcolor)
      Line(X, Y+6, size/2-1 , 1, fcolor) : Line(X+size/2-1, Y+6, 2, 1, bcolor) : Line(X+size/2+1, Y+6, size/2-1, 1, fcolor)   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(X, Y+7, fcolor ) : Line(X+1, Y+7, size-2, 1, bcolor) : Plot(X+size-1, Y+7, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
   EndMacro
   Macro DrawImageCursorSplitDown(X, Y, size, bcolor, fcolor)
      Plot(X, Y+2, fcolor ) : Line(X+1, Y+2, size-2, 1, bcolor) : Plot(X+size-1, Y+2, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      Line(X, Y+3, size/2-1, 1, fcolor) : Line(X+size/2-1, Y+3, 2, 1, bcolor) : Line(X+size/2+1, Y+3, size/2-1 , 1, fcolor)   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      cursor::DrawImageDown(X, Y, size, bcolor, fcolor)
   EndMacro
   Macro DrawImageCursorSplitLeft(X, Y, size, bcolor, fcolor)
      cursor::DrawImageLeft(X, Y, size, bcolor, fcolor)
      Line(X+6, Y , 1, size/2-1, fcolor) : Line(X+6, Y+size/2-1, 1, 2, bcolor) : Line(X+6, Y+size/2+1, 1, size/2-1, fcolor)   ; 1,0,0,0,0,1,1,0,0
      Plot(X+7, Y, fcolor ) : Line(X+7, Y+1, 1, size-2, bcolor) : Plot(X+7, Y+size-1, fcolor )                          ; 1,1,1,1,1,1,1,1,0
   EndMacro  
   Macro DrawImageCursorSplitRight(X, Y, size, bcolor, fcolor)
      Plot(X+2, Y, fcolor ) : Line(X+2, Y+1, 1, size-2, bcolor) : Plot(X+2, Y+size-1, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      Line(X+3, Y, 1, size/2-1, fcolor) : Line(X+3, Y+size/2-1, 1, 2, bcolor) : Line(X+3, Y+size/2+1, 1, size/2-1, fcolor)    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      cursor::DrawImageRight(X, Y, size, bcolor, fcolor)
   EndMacro
   
   ;-
   Macro DrawImageCursorSplitV(X, Y, Width, Height, bcolor, fcolor)
      cursor::DrawImageUp(X, Y, Width, bcolor, fcolor)
      cursor::DrawImageCursorSplitUp(X,Y,Width, bcolor, fcolor )
      cursor::DrawImageCursorSplitDown(X,Y+Height-1,Width, bcolor, fcolor )
      cursor::DrawImageDown(X, Y+Height-1, Width, bcolor, fcolor)
   EndMacro
   Macro DrawImageCursorSplitH(X, Y, Height, Width, bcolor, fcolor)
      cursor::DrawImageLeft(X, Y, Width, bcolor, fcolor)
      cursor::DrawImageCursorSplitLeft(X,Y,Width, bcolor, fcolor )
      cursor::DrawImageCursorSplitRight(X,Y+Height-1,Width, bcolor, fcolor )
      cursor::DrawImageRight(X, Y+Height-1, Width, bcolor, fcolor)
   EndMacro
   
   Macro DrawImageCursorDiagonal1(X, Y, size, bcolor, fcolor)
      LineXY(X+3,Y+2,X+13,Y+12,bcolor)
      LineXY(X+2,Y+2,X+13,Y+13,bcolor)
      LineXY(X+2,Y+3,X+12,Y+13,bcolor)
      
      Plot(X+12,Y+10,bcolor)
      Plot(X+10,Y+12,bcolor)
      Plot(X+5,Y+3,bcolor)
      Plot(X+3,Y+5,bcolor)
      
      Line(X+2,Y+4,1,3,bcolor)
      Line(X+4,Y+2,3,1,bcolor)
      Line(X+9,Y+13,3,1,bcolor)
      Line(X+13,Y+9,1,3,bcolor)
      
      ;
      LineXY(X+6,Y+4,X+11,Y+9,fcolor)
      LineXY(X+4,Y+6,X+9,Y+11,fcolor)
      
      LineXY(X+2,Y+7,X+3,Y+6,fcolor)
      LineXY(X+7,Y+2,X+6,Y+3,fcolor)
      LineXY(X+8,Y+13,X+9,Y+12,fcolor)
      LineXY(X+13,Y+8,X+12,Y+9,fcolor)
      
      Line(X+1,Y+2,1,6,fcolor)
      Line(X+14,Y+8,1,6,fcolor)
      Line(X+2,Y+1,6,1,fcolor)
      Line(X+8,Y+14,6,1,fcolor)
   EndMacro
   Macro DrawImageCursorDiagonal2(X, Y, size, bcolor, fcolor)
      LineXY(X+2,Y+12,X+12,Y+2,bcolor)
      LineXY(X+2,Y+13,X+13,Y+2,bcolor)
      LineXY(X+3,Y+13,X+13,Y+3,bcolor)
      
      Plot(X+3,Y+10,bcolor)
      Plot(X+10,Y+3,bcolor)
      Plot(X+5,Y+12,bcolor)
      Plot(X+12,Y+5,bcolor)
      
      Line(X+2,Y+9,1,3,bcolor)
      Line(X+9,Y+2,3,1,bcolor)
      Line(X+4,Y+13,3,1,bcolor)
      Line(X+13,Y+4,1,3,bcolor)
      
      ;
      LineXY(X+4,Y+9,X+9,Y+4,fcolor)
      LineXY(X+6,Y+11,X+11,Y+6,fcolor)
      
      LineXY(X+2,Y+8,X+3,Y+9,fcolor)
      LineXY(X+8,Y+2,X+9,Y+3,fcolor)
      LineXY(X+6,Y+12,X+7,Y+13,fcolor)
      LineXY(X+12,Y+6,X+13,Y+7,fcolor)
      
      Line(X+1,Y+8,1,6,fcolor)
      Line(X+8,Y+1,6,1,fcolor)
      Line(X+2,Y+14,6,1,fcolor)
      Line(X+14,Y+2,1,6,fcolor)
   EndMacro
   
   
EndDeclareModule

CompilerIf #PB_Compiler_IsMainFile
;-\\ example
   CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_MacOS   : IncludePath "mac"
      CompilerCase #PB_OS_Windows : IncludePath "win"
      CompilerCase #PB_OS_Linux   : IncludePath "lin"
   CompilerEndSelect
   
   XIncludeFile "id.pbi"
   XIncludeFile "mouse.pbi"
   XIncludeFile "cursor.pbi"
   
   EnableExplicit
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      XIncludeFile "ClipGadgets.pbi"
   CompilerEndIf
   
   UseModule constants
   ;UseModule events
   
   Define event
   Define g1,g2
   
   Procedure   DrawCanvasBack(Gadget, color)
      If GadgetType(Gadget) = #PB_GadgetType_Canvas
         StartDrawing(CanvasOutput(Gadget))
         DrawingMode(#PB_2DDrawing_Default)
         Box(0,0,OutputWidth(), OutputHeight(), color)
         StopDrawing()
      EndIf
   EndProcedure
   
   Procedure   DrawCanvasFrame(Gadget, color)
      If GadgetType(Gadget) = #PB_GadgetType_Canvas
         StartDrawing(CanvasOutput(Gadget))
         If GetGadgetState(Gadget)
            DrawImage(0,0, GetGadgetState(Gadget))
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
   
   Macro GadgetMouseX(_canvas_, _mode_ = #PB_Gadget_ScreenCoordinate)
      ; GetGadgetAttribute(_canvas_, #PB_Canvas_MouseX)
      DesktopMouseX() - GadgetX(_canvas_, _mode_)
      ; WindowMouseX(ID::Window(ID::GetWindowID(GadgetID(_canvas_)))) - GadgetX(_canvas_, #PB_Gadget_WindowCoordinate)  
   EndMacro
   Macro GadgetMouseY(_canvas_, _mode_ = #PB_Gadget_ScreenCoordinate)
      ; GetGadgetAttribute(_canvas_, #PB_Canvas_MouseY)
      DesktopMouseY() - GadgetY(_canvas_, _mode_)
      ; WindowMouseY(ID::Window(ID::GetWindowID(GadgetID(_canvas_)))) - GadgetY(_canvas_, #PB_Gadget_WindowCoordinate)
   EndMacro
   
   Procedure EventHandler(eventobject, eventtype, eventdata)
      Protected window = EventWindow()
      Protected DropX, DropY
      Static deltax, deltay
      
      Select eventtype
         Case #PB_EventType_MouseWheelX
            Debug ""+eventobject + " #PB_EventType_MouseWheelX " +eventdata
            
         Case #PB_EventType_MouseWheelY
            Debug ""+eventobject + " #PB_EventType_MouseWheelY " +eventdata
            
         Case #PB_EventType_DragStart
            deltax = GadgetMouseX(eventobject, #PB_Gadget_WindowCoordinate)
            deltay = GadgetMouseY(eventobject, #PB_Gadget_WindowCoordinate)
            Debug ""+eventobject + " #PB_EventType_DragStart " + "x="+ deltax +" y="+ deltay
            
         Case #PB_EventType_Drop
            DropX = GadgetMouseX(eventobject, #PB_Gadget_ScreenCoordinate)
            DropY = GadgetMouseY(eventobject, #PB_Gadget_ScreenCoordinate)
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
            ;         If DraggedGadget() = 1
            ;           Debug ""+eventobject + " #PB_EventType_MouseMove " 
            ;           ResizeGadget(DraggedGadget(), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
            ;         EndIf
            ;         ;         If DraggedGadget() = 0
            ;         ;           ResizeGadget(DraggedGadget(), DesktopMouseX()-deltax, DesktopMouseY()-deltay, #PB_Ignore, #PB_Ignore)
            ;         ;         EndIf
            
      EndSelect
   EndProcedure
   
   Procedure OpenWindow_(window, X,Y,Width,Height, title.s, Flag=0)
      Protected WindowID
      Protected result = OpenWindow(window, X,Y,Width,Height, title.s, Flag|#PB_Window_SizeGadget)
      If window >= 0
         WindowID = WindowID(window)
      Else
         WindowID = result
      EndIf
      ;Debug 77
      ;CocoaMessage(0, WindowID, "disableCursorRects")
      ProcedureReturn result
   EndProcedure
   
   Macro OpenWindow(window, X,Y,Width,Height, title, Flag=0)
      OpenWindow_(window, X,Y,Width,Height, title, Flag)
   EndMacro
   
   ;events::SetCallback(@EventHandler())
   ;/// first
   OpenWindow(1, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
   CanvasGadget(0, 240, 10, 60, 60, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
   CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
   CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
   ButtonGadget(100, 60,240,60,60,"")
   g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
   g2=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
   SplitterGadget(111,10,240,60,60, g1,g2)
   
   ; If Set((111),#__cursor_SplitUpDown)
   ;   Debug "updown"           
   ; EndIf       
   
   If cursor::Set((100),cursor::#__cursor_Hand)
      Debug "setCursorHand"           
   EndIf       
   
   If cursor::Set((g1),cursor::#__cursor_IBeam)
      Debug "setCursorIBeam"           
   EndIf       
   
   If cursor::Set((g2),cursor::#__cursor_IBeam)
      Debug "setCursorIBeam"           
   EndIf       
   
   If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png") = 0
      MessageRequester("Error",
                       "Loading of image World.png failed!",
                       #PB_MessageRequester_Error)
      End
   EndIf
   If cursor::set((0), cursor::Create(ImageID(0)))
      Debug "setCursorImage"           
   EndIf       
   
   If cursor::Set((1),cursor::#__cursor_Hand)
      Debug "setCursorHand - " ;+CocoaMessage(0, 0, "NSCursor currentCursor")
   EndIf       
   
   If cursor::Set((11),cursor::#__cursor_Cross)
      Debug "setCursorCross"           
   EndIf       
   
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ClipGadgets(UseGadgetList(0))
   CompilerEndIf
   ;/// second
   OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
   Define g1=StringGadget(-1,0,0,0,0,"StringGadget")
   Define g2=HyperLinkGadget(-1,0,0,0,0,"HyperLinkGadget", 0)
   SplitterGadget(2, 10, 10, 200, 200, g1,g2)
   BindEvent(#PB_Event_SizeWindow, @Resize_2(), 2)
   
   ;   If cursor::Set((g1),cursor::#__cursor_IBeam)
   ;     Debug "setCursorIBeam"           
   ;   EndIf       
   ;   
   ;   If cursor::Set((g2),cursor::#__cursor_Hand)
   ;     Debug "setCursorHand"           
   ;   EndIf       
   ;   
   ;   If cursor::Set((2),cursor::#__cursor_SplitUpDown)
   ;     Debug "setCursorHand"           
   ;   EndIf       
   
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ClipGadgets(UseGadgetList(0))
   CompilerEndIf
   ;/// third
   OpenWindow(3, 450+50, 200+50, 220, 220, "window_3", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
   g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
   g2=StringGadget(-1,0,0,0,0,"StringGadget")
   SplitterGadget(3,10, 10, 200, 200, g1,g2)
   BindEvent(#PB_Event_SizeWindow, @Resize_3(), 3)
   
   If cursor::Set((g1),cursor::#__cursor_IBeam)
      Debug "setCursorIBeam"           
   EndIf       
   
   ;   If cursor::Set((g2),cursor::#__cursor_IBeam)
   ;     Debug "setCursorIBeam"           
   ;   EndIf       
   
   
   ;Debug "currentCursor - "+CocoaMessage(0, 0, "NSCursor currentCursor") ; CocoaMessage(0, 0, "NSCursor systemCursor") +" "+ 
   ;;events::SetCallback(@EventHandler())
   
   ;-\\ OPENWINDOW
   OpenWindow(4, 550, 300, 328, 328, "window_4", #PB_Window_SystemMenu)
   Define Invisible = CanvasGadget(#PB_Any, 8, 8, 86, 86) : GadgetToolTip( Invisible, "#__cursor_Invisible")
   Define Denied = CanvasGadget(#PB_Any, 8, 264, 56, 56) : GadgetToolTip( Denied, "#__cursor_Denied")
   Define Cross = CanvasGadget(#PB_Any, 264, 8, 56, 56) : GadgetToolTip( Cross, "#__cursor_Cross")
   Define Busy = CanvasGadget(#PB_Any, 264, 264, 56, 56) : GadgetToolTip( Busy, "#__cursor_Busy")
   
   ;   Canvas_4 = CanvasGadget(#PB_Any, 72, 8, 56, 56)
   Define lt = CanvasGadget(#PB_Any, 72, 72, 56, 56) : GadgetToolTip( lt, "#__cursor_LeftUp")
   Define lb = CanvasGadget(#PB_Any, 72, 200, 56, 56) : GadgetToolTip( lb, "#__cursor_LeftDown")
   ;   Canvas_72 = CanvasGadget(#PB_Any, 72, 264, 56, 56)
   
   Define up = CanvasGadget(#PB_Any, 136, 8, 56, 24) : GadgetToolTip( up, "#__cursor_Up")
   Define up2 = CanvasGadget(#PB_Any, 136, 8+24+8, 56, 24) : GadgetToolTip( up2, "#__cursor_SplitUpDown")
   Define up3 = CanvasGadget(#PB_Any, 136, 72, 56, 56) : GadgetToolTip( up3, "#__cursor_UpDown")
   
   Define left = CanvasGadget(#PB_Any, 8, 136, 24, 56) : GadgetToolTip( left, "#__cursor_Left")
   Define left2 = CanvasGadget(#PB_Any, 8+24+8, 136, 24, 56) : GadgetToolTip( left2, "#__cursor_SplitLeftRight")
   Define left3 = CanvasGadget(#PB_Any, 72, 136, 56, 56) : GadgetToolTip( left3, "#__cursor_LeftRight")
   
   Define Arrows = CanvasGadget(#PB_Any, 136, 136, 56, 56) : GadgetToolTip( Arrows, "#__cursor_Arrows")
   
   Define right = CanvasGadget(#PB_Any, 264+8+24, 136, 24, 56) : GadgetToolTip( right, "#__cursor_Right")
   Define right2 = CanvasGadget(#PB_Any, 264, 136, 24, 56) : GadgetToolTip( right2, "#__cursor_SplitLeftRight")
   Define right3 = CanvasGadget(#PB_Any, 200, 136, 56, 56) : GadgetToolTip( right3, "#__cursor_LeftRight")
   
   Define down3 = CanvasGadget(#PB_Any, 136, 200, 56, 56) : GadgetToolTip( down3, "#__cursor_UpDown")
   Define down2 = CanvasGadget(#PB_Any, 136, 264, 56, 24) : GadgetToolTip( down2, "#__cursor_SplitUpDown")
   Define down = CanvasGadget(#PB_Any, 136, 264+8+24, 56, 24) : GadgetToolTip( down, "#__cursor_Down")
   
   ;   Canvas_12 = CanvasGadget(#PB_Any, 200, 8, 56, 56)
   Define rt = CanvasGadget(#PB_Any, 200, 72, 56, 56) : GadgetToolTip( rt, "#__cursor_RightUp")
   Define rb = CanvasGadget(#PB_Any, 200, 200, 56, 56) : GadgetToolTip( rb, "#__cursor_RightDown")
   ;   Canvas_152 = CanvasGadget(#PB_Any, 200, 264, 56, 56)
   
   ;;Canvas_1 = CanvasGadget(#PB_Any, 8, 72, 56, 56)
   
   ;;Canvas_3 = CanvasGadget(#PB_Any, 8, 200, 56, 56)
   ;;Canvas_17 = CanvasGadget(#PB_Any, 264, 72, 56, 56)
   ;;Canvas_19 = CanvasGadget(#PB_Any, 264, 200, 56, 56)
   
   
   Cursor::Set((lt), Cursor::#__cursor_LeftUp ) 
   Cursor::Set((rt), Cursor::#__cursor_RightUp ) 
   Cursor::Set((lb), Cursor::#__cursor_LeftDown ) 
   Cursor::Set((rb), Cursor::#__cursor_RightDown ) 
   
   Cursor::Set((up), Cursor::#__cursor_SplitUp ) 
   Cursor::Set((down), Cursor::#__cursor_SplitDown ) 
   Cursor::Set((left), Cursor::#__cursor_SplitLeft ) 
   Cursor::Set((right), Cursor::#__cursor_SplitRight ) 
   
   Cursor::Set((up2), Cursor::#__cursor_SplitUpDown ) 
   Cursor::Set((down2), Cursor::#__cursor_SplitUpDown ) 
   Cursor::Set((left2), Cursor::#__cursor_SplitLeftRight ) 
   Cursor::Set((right2), Cursor::#__cursor_SplitLeftRight ) 
   
   Cursor::Set((up3), Cursor::#__cursor_Up ) 
   Cursor::Set((down3), Cursor::#__cursor_Down ) 
   Cursor::Set((left3), Cursor::#__cursor_Left ) 
   Cursor::Set((right3), Cursor::#__cursor_Right ) 
   
   Cursor::Set((Cross), Cursor::#__cursor_Cross ) 
   Cursor::Set((Arrows), Cursor::#__cursor_Arrows ) 
   Cursor::Set((Invisible), Cursor::#__cursor_Invisible ) 
   Cursor::Set((Denied), Cursor::#__cursor_Denied ) 
   Cursor::Set((Busy), Cursor::#__cursor_Busy ) 
   
   
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ClipGadgets(UseGadgetList(0))
   CompilerEndIf
   
   
   ;-
   
   
   
   Define EnteredGadget =- 1
   Define LeavedGadget =- 1 
   Define buttons = 0
   Define X,Y
   Define fcolor = $FFFFFF
   Define bcolor = $000000
   Define Width = 16
   Define Height = 7
   
   
   ;-\\
   If StartDrawing(CanvasOutput(Arrows))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-Width)/2
      
      ; down2                                                 
      Box(X+6,Y+6,4,4, fcolor)
      cursor::DrawImageCursorUp(X,Y-1,Width, bcolor, fcolor )
      cursor::DrawImageCursorDown(X,Y+7,Width, bcolor, fcolor )
      
      cursor::DrawImageCursorLeft(X-1,Y,Width, bcolor, fcolor )
      cursor::DrawImageCursorRight(X+7,Y,Width, bcolor, fcolor )
      Box(X+7,Y+7,2,2, bcolor)
      
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(Cross))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      ;       img = CocoaMessage(0, 0, "NSCursor resizeUpCursor")
      ;       ;DrawImage(img, 0,0)
      Width = 13
      Line(OutputWidth()/2-1, OutputHeight()/2-Width/2, 1, Width, fcolor)
      Line(OutputWidth()/2+1, OutputHeight()/2-Width/2, 1, Width, fcolor)
      
      Line(OutputWidth()/2-Width/2, OutputHeight()/2-1, Width, 1, fcolor)
      Line(OutputWidth()/2-Width/2, OutputHeight()/2+1, Width, 1, fcolor)
      
      Line(OutputWidth()/2, OutputHeight()/2-Width/2, 1, Width, bcolor)
      Line(OutputWidth()/2-Width/2, OutputHeight()/2, Width, 1, bcolor)
      StopDrawing()
   EndIf
   
   Define Width = 16
   Define Height = 7
   
   ;-\\ Dioganal1
   If StartDrawing(CanvasOutput(lt))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-Width)/2
      ;
      cursor::DrawImageCursorDiagonal1(X,Y,Width, bcolor, fcolor)
      
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(rb))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-Width)/2
      ;
      cursor::DrawImageCursorDiagonal1(X,Y,Width, bcolor, fcolor)
      
      StopDrawing()
   EndIf
   
   ;-\\ Dioganal2
   If StartDrawing(CanvasOutput(rt))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-Width)/2
      ; 
      cursor::DrawImageCursorDiagonal2(X,Y,Width, bcolor, fcolor)
      
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(lb))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-Width)/2
      ; 
      cursor::DrawImageCursorDiagonal2(X,Y,Width, bcolor, fcolor)
      
      StopDrawing()
   EndIf
   
   ;-\\ Vertical
   If StartDrawing(CanvasOutput(up))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-Height)/2
      
      ; up                                                 
      cursor::DrawImageUp(X, Y, Width, bcolor, fcolor)
      cursor::DrawImageCursorSplitUp(X,Y,Width, bcolor, fcolor )
      Plot(X, Y+8, fcolor ) : Line(X+1, Y+8, Width-2, 1, bcolor) : Plot(X+Width-1, Y+8, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      Line(X, Y + 9, Width , 1, fcolor)                                                                                   ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(up2))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-(Height*2))/2
      
      ; down2                                                 
      cursor::DrawImageCursorSplitV(X,Y,Width,Height, bcolor, fcolor )
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(up3))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-(Height*2))/2
      
      cursor::DrawImageCursorUp(X,Y-1,Width, bcolor, fcolor )
      cursor::DrawImageCursorDown(X,Y+Height-2,Width, bcolor, fcolor )
      StopDrawing()
   EndIf
   
   If StartDrawing(CanvasOutput(down))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-Height)/2
      
      ; down                                                 
      Line(X, Y, Width, 1, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      Plot(X, Y+1, fcolor ) : Line(X+1, Y+1, Width-2, 1, bcolor) : Plot(X+Width-1, Y+1, fcolor )                           ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      cursor::DrawImageCursorSplitDown(X,Y,Width, bcolor, fcolor )
      cursor::DrawImageDown(X, Y, Width, bcolor, fcolor)
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(down2))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-(Height*2))/2
      
      ; down2                                                 
      cursor::DrawImageCursorSplitV(X,Y,Width,Height, bcolor, fcolor )
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(down3))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Width)/2
      Y = (OutputHeight()-(Height*2))/2
      
      ; down2                                                 
      ; Box(x+6,y+5,4,4, fcolor)
      cursor::DrawImageCursorUp(X,Y-1,Width, bcolor, fcolor )
      cursor::DrawImageCursorDown(X,Y+Height-2,Width, bcolor, fcolor )
      
      ;     x = (OutputWidth()-(height*2))/2
      ;     y = (OutputHeight()-width)/2
      ;     ;Box(x+6,y+7,2,2, bcolor)
      
      StopDrawing()
   EndIf
   
   ;-\\ Horizontal
   If StartDrawing(CanvasOutput(left))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Height)/2
      Y = (OutputHeight()-Width)/2
      
      ; left                                                 
      cursor::DrawImageCursorSplitLeft(X,Y,Width, bcolor, fcolor )
      Plot(X+8, Y, fcolor ) : Line(X+8, Y+1, 1, Width-2, bcolor) : Plot(X+8, Y+Width-1, fcolor )                        ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      Line(X + 9, Y, 1, Width, fcolor)                                                                                  ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(left2))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-(Height*2))/2
      Y = (OutputHeight()-Width)/2
      Debug ""+X+" "+Y
      ; left2                                                 
      cursor::DrawImageCursorSplitLeft(X,Y,Width, bcolor, fcolor )
      cursor::DrawImageCursorSplitRight(X+Height-1,Y,Width, bcolor, fcolor )
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(left3))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-(Height*2))/2
      Y = (OutputHeight()-Width)/2
      ; ver-size
      cursor::DrawImageCursorLeft(X-1,Y,Width, bcolor, fcolor )
      cursor::DrawImageCursorRight(X+Height-2,Y,Width, bcolor, fcolor )
      StopDrawing()
   EndIf
   
   If StartDrawing(CanvasOutput(right))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-Height)/2
      Y = (OutputHeight()-Width)/2
      
      ; right                                                 
      Line(X, Y, 1, Width, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      Plot(X+1, Y, fcolor ) : Line(X+1, Y+1, 1, Width-2, bcolor) : Plot(X+1, Y+Width-1, fcolor )                           ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      cursor::DrawImageCursorSplitRight(X,Y,Width, bcolor, fcolor )
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(right2))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      X = (OutputWidth()-(Height*2))/2
      Y = (OutputHeight()-Width)/2
      
      ; right2                                                 
      cursor::DrawImageCursorSplitLeft(X,Y,Width, bcolor, fcolor )
      cursor::DrawImageCursorSplitRight(X+Height-1,Y,Width, bcolor, fcolor )
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(right3))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      ;     x = (OutputWidth()-width)/2
      ;     y = (OutputHeight()-(height*2))/2
      ;     
      ;     ; down2                                                 
      ;     ;Box(x+6,y+5,4,4, fcolor)
      
      X = (OutputWidth()-(Height*2))/2
      Y = (OutputHeight()-Width)/2
      
      cursor::DrawImageCursorLeft(X-1,Y,Width, bcolor, fcolor )
      cursor::DrawImageCursorRight(X+Height-2,Y,Width, bcolor, fcolor )
      ;Box(x+6,y+7,2,2, bcolor)
      
      StopDrawing()
   EndIf
   
   ;-
   Repeat 
      event = WaitWindowEvent()
      EnteredGadget = ID::Gadget(mouse::Gadget(mouse::Window()))
      
      If LeavedGadget <> EnteredGadget And buttons = 0
         ; Debug  CocoaMessage(0, CocoaMessage(0,0,"NSApplication sharedApplication"), "NSEvent")
         
         If LeavedGadget >= 0
            ; Debug GetGadgetAttribute(LeavedGadget, #PB_Canvas_Buttons)
            EventHandler(LeavedGadget, #PB_EventType_MouseLeave, 0)
            ;Cursor::Change(GadgetID(LeavedGadget), 0 )
            CompilerSelect #PB_Compiler_OS 
               CompilerCase #PB_OS_Windows
                  PostEvent(#PB_Event_Gadget, EventWindow( ), LeavedGadget, #PB_EventType_CursorChange, 0)
               CompilerCase #PB_OS_Linux
                  PostEvent(#PB_Event_Gadget, EventWindow( ), LeavedGadget, #PB_EventType_CursorChange, 0)
            CompilerEndSelect
         EndIf
         
         If EnteredGadget >= 0
            ; Debug GetGadgetAttribute(EnteredGadget, #PB_Canvas_Buttons)
            EventHandler(EnteredGadget, #PB_EventType_MouseEnter, 1)
            ;Cursor::Change(GadgetID(EnteredGadget), 1 )
            CompilerSelect #PB_Compiler_OS 
               CompilerCase #PB_OS_Windows
                  PostEvent(#PB_Event_Gadget, EventWindow( ), EnteredGadget, #PB_EventType_CursorChange, 1)
               CompilerCase #PB_OS_Linux  
                  PostEvent(#PB_Event_Gadget, EventWindow( ), EnteredGadget, #PB_EventType_CursorChange, 1)
            CompilerEndSelect
         EndIf
         LeavedGadget = EnteredGadget
      EndIf
      
      If event = #PB_Event_Gadget
         Select EventType( )
            Case #PB_EventType_CursorChange
               Cursor::Change(GadgetID(EventGadget( )), EventData( ) )
               
            Case #PB_EventType_LeftButtonDown
               buttons = 1
               
            Case #PB_EventType_LeftButtonUp
               buttons = 0
         EndSelect
      EndIf
      
   Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.46 LTS (MacOS X - x64)
; CursorPosition = 258
; FirstLine = 19
; Folding = v------------
; EnableXP
; Optimizer
; DPIAware