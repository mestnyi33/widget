CompilerIf Not Defined( constants, #PB_Module )
   DeclareModule constants
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
      type.a
      *hcursor
      windowID.i
   EndStructure
   
   ;Declare   isHiden( )
   ;Declare   Hide( state.b )
   Declare   FreeWidget( *cursor )
   ;Declare   Get( )
   ;Declare   Clip( x.l,y.l,width.l,height.l )
   Declare   Image( type.a = 0 )
   Declare   Set( Gadget.i, *cursor );, x.i = 0, y.i = 0)
   Declare   Change( GadgetID.i, state.b )
   Declare.i Create( ImageID.i, x.l = 0, y.l = 0 )
   
   
   ;\\
   Macro DrawImageUp(x, y, size, bcolor, fcolor)
      Line(x+7, y, 2, 1, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      Plot(x+6, y+1, fcolor ) : Line(x+7, y+1, 2, 1, bcolor) : Plot(x+9, y+1, fcolor )                                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(x+5, y+2, fcolor ) : Line(x+6, y+2, 4, 1, bcolor) : Plot(x+10, y+2, fcolor )                                  ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
      Plot(x+4, y+3, fcolor ) : Line(x+5, y+3, 6, 1, bcolor) : Plot(x+11, y+3, fcolor )                                  ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
      Line(x+4, y+4, 3, 1, fcolor) : Line(x+7, y+4, 2, 1, bcolor) : Line(x+size/2+1, y+4, 3 , 1, fcolor)                 ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(x+size/2-2, y+5, fcolor ) : Line(x+7, y+5, 2, 1, bcolor) : Plot(x+size/2+1, y+5, fcolor )                     ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
   EndMacro
   Macro DrawImageDown(x, y, size, bcolor, fcolor)
      Plot(x+size/2-2, y+4, fcolor ) : Line(x+7, y+4, 2, 1, bcolor) : Plot(x+size/2+1, y+4, fcolor )                     ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Line(x+4, y+5, 3, 1, fcolor) : Line(x+7, y+5, 2, 1, bcolor) : Line(x+size/2+1, y+5, 3, 1, fcolor)                  ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(x+4, y+6, fcolor ) : Line(x+5, y+6, 6, 1, bcolor) : Plot(x+11, y+6, fcolor )                                  ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
      Plot(x+5, y+7, fcolor ) : Line(x+6, y+7, 4, 1, bcolor) : Plot(x+10, y+7, fcolor )                                  ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
      Plot(x+6, y+8, fcolor ) : Line(x+7, y+8, 2, 1, bcolor) : Plot(x+9, y+8, fcolor )                                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Line(x+7, y+9, 2, 1, fcolor)                                                                                       ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   EndMacro
   Macro DrawImageLeft(x, y, width, bcolor, fcolor)
      Line(x, y+7, 1, 2, fcolor)                                                                                          ; 0,0,0,0,0,0,0,0,0
      Plot(x+1, y+6, fcolor ) : Line(x+1, y+7, 1, 2, bcolor) : Plot(x+1, y+9, fcolor )                                    ; 1,0,0,0,0,0,0,0,0
      Plot(x+2, y+5, fcolor ) : Line(x+2, y+6, 1, 4, bcolor) : Plot(x+2, y+10, fcolor )                                   ; 1,0,0,0,0,0,0,0,0
      Plot(x+3, y+4, fcolor ) : Line(x+3, y+5, 1, 6, bcolor) : Plot(x+3, y+11, fcolor )                                   ; 1,0,0,0,0,0,0,0,0
      Line(x+4, y+4, 1, 3, fcolor) : Line(x+4, y+7, 1, 2, bcolor) : Line(x+4, y+width/2+1, 1, 3, fcolor)                  ; 1,0,0,0,0,0,0,0,0
      Plot(x+5, y+width/2-2, fcolor ) : Line(x+5, y+7, 1, 2, bcolor) : Plot(x+5, y+width/2+1, fcolor )                    ; 1,0,0,0,0,1,0,0,0
   EndMacro  
   Macro DrawImageRight(x, y, width, bcolor, fcolor)
      Plot(x+4, y+width/2-2, fcolor ) : Line(x+4, y+7, 1, 2, bcolor) : Plot(x+4, y+width/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Line(x+5, y+4, 1, 3, fcolor) : Line(x+5, y+7, 1, 2, bcolor) : Line(x+5, y+width/2+1, 1, 3, fcolor)                  ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(x+6, y+4, fcolor ) : Line(x+6, y+5, 1, 6, bcolor) : Plot(x+6, y+11, fcolor )                                   ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
      Plot(x+7, y+5, fcolor ) : Line(x+7, y+6, 1, 4, bcolor) : Plot(x+7, y+10, fcolor )                                   ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
      Plot(x+8, y+6, fcolor ) : Line(x+8, y+7, 1, 2, bcolor) : Plot(x+8, y+9, fcolor )                                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Line(x+9, y+7, 1, 2, fcolor)                                                                                        ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   EndMacro
   
   Macro DrawImageCursor2(x, y, width, height, bcolor, fcolor)
      cursor::DrawImageUp(x, y, size, bcolor, fcolor)
      cursor::DrawImageDown(x, y+height-2, size, bcolor, fcolor)
      
      LineXY(x,y+1,x+5,y+6,bcolor)
      LineXY(x+1,y+1,x+5,y+5,bcolor)
      ;     Plot(x+1, y+2, bcolor )
      ;     Plot(x+2, y+1, bcolor )
      ;     
      ;     Plot(x+2, y+3, bcolor )
      ;     Plot(x+3, y+2, bcolor )
      ;     
      ;     Plot(x+3, y+4, bcolor )
      ;     Plot(x+4, y+3, bcolor )
      ;     
      ;     Plot(x+4, y+5, bcolor )
      ;     Plot(x+5, y+4, bcolor )
   EndMacro  
   Macro DrawImageCursor6(x, y, width, bcolor, fcolor)
      ;     Plot(x+4, y+width/2-2, fcolor ) : Line(x+4, y+7, 1, 2, bcolor) : Plot(x+4, y+width/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      ;     Line(x+5, y+3, 1, width/3-1, fcolor) : Line(x+5, y+7, 1, 2, bcolor) : Line(x+5, y+width/2+1, 1, width/3-1, fcolor)  ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      ;     Plot(x+6, y+4, fcolor ) : Line(x+6, y+5, 1, 6, bcolor) : Plot(x+6, y+11, fcolor )                                   ; 0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0
      ;     Plot(x+7, y+5, fcolor ) : Line(x+7, y+6, 1, 4, bcolor) : Plot(x+7, y+10, fcolor )                                   ; 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
      ;     Plot(x+8, y+6, fcolor ) : Line(x+8, y+7, 1, 2, bcolor) : Plot(x+8, y+9, fcolor )                                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      ;     Line(x+9, y+7, 1, 2, fcolor)                                                                                        ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   EndMacro
   
   Macro DrawImageCursorSplitV(x, y, width, height, bcolor, fcolor)
      cursor::DrawImageUp(x, y, width, bcolor, fcolor)
      cursor::DrawImageCursorSplitUp(x,y,width, bcolor, fcolor )
      cursor::DrawImageCursorSplitDown(x,y+height-1,width, bcolor, fcolor )
      cursor::DrawImageDown(x, y+height-1, width, bcolor, fcolor)
   EndMacro
   Macro DrawImageCursorSplitH(x, y, height, width, bcolor, fcolor)
      cursor::DrawImageLeft(x, y, width, bcolor, fcolor)
      cursor::DrawImageCursorSplitLeft(x,y,width, bcolor, fcolor )
      cursor::DrawImageCursorSplitRight(x,y+height-1,width, bcolor, fcolor )
      cursor::DrawImageRight(x, y+height-1, width, bcolor, fcolor)
   EndMacro
   
   Macro DrawImageCursorUp(x, y, width, bcolor, fcolor)
      cursor::DrawImageUp(x, y, width, bcolor, fcolor)
      Plot(x+width/2-2, y+6, fcolor ) : Line(x+7, y+6, 2, 1, bcolor) : Plot(x+width/2+1, y+6, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(x+width/2-2, y+7, fcolor ) : Line(x+7, y+7, 2, 1, bcolor) : Plot(x+width/2+1, y+7, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
   EndMacro
   Macro DrawImageCursorDown(x, y, width, bcolor, fcolor)
      Plot(x+width/2-2, y+2, fcolor ) : Line(x+7, y+2, 2, 1, bcolor) : Plot(x+width/2+1, y+2, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(x+width/2-2, y+3, fcolor ) : Line(x+7, y+3, 2, 1, bcolor) : Plot(x+width/2+1, y+3, fcolor )                   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      cursor::DrawImageDown(x, y, width, bcolor, fcolor)
   EndMacro
   Macro DrawImageCursorLeft(x, y, width, bcolor, fcolor)
      cursor::DrawImageLeft(x, y, width, bcolor, fcolor)
      Plot(x+6, y+width/2-2, fcolor ) : Line(x+6, y+7, 1, 2, bcolor) : Plot(x+6, y+width/2+1, fcolor )                    ; 1,0,0,0,0,1,0,0,0
      Plot(x+7, y+width/2-2, fcolor ) : Line(x+7, y+7, 1, 2, bcolor) : Plot(x+7, y+width/2+1, fcolor )                    ; 1,0,0,0,0,1,0,0,0
   EndMacro  
   Macro DrawImageCursorRight(x, y, width, bcolor, fcolor)
      Plot(x+2, y+width/2-2, fcolor ) : Line(x+2, y+7, 1, 2, bcolor) : Plot(x+2, y+width/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(x+3, y+width/2-2, fcolor ) : Line(x+3, y+7, 1, 2, bcolor) : Plot(x+3, y+width/2+1, fcolor )                    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      cursor::DrawImageRight(x, y, width, bcolor, fcolor)
   EndMacro
   
   Macro DrawImageCursorSplitUp(x, y, width, bcolor, fcolor)
      cursor::DrawImageUp(x, y, width, bcolor, fcolor)
      Line(x, y+6, width/2-1 , 1, fcolor) : Line(x+7, y+6, 2, 1, bcolor) : Line(x+width/2+1, y+6, width/2-1, 1, fcolor)   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      Plot(x, y+7, fcolor ) : Line(x+1, y+7, width-2, 1, bcolor) : Plot(x+width-1, y+7, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
   EndMacro
   Macro DrawImageCursorSplitDown(x, y, width, bcolor, fcolor)
      Plot(x, y+2, fcolor ) : Line(x+1, y+2, width-2, 1, bcolor) : Plot(x+width-1, y+2, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      Line(x, y+3, width/2-1, 1, fcolor) : Line(x+7, y+3, 2, 1, bcolor) : Line(x+width/2+1, y+3, width/2-1 , 1, fcolor)   ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      cursor::DrawImageDown(x, y, width, bcolor, fcolor)
   EndMacro
   Macro DrawImageCursorSplitLeft(x, y, width, bcolor, fcolor)
      cursor::DrawImageLeft(x, y, width, bcolor, fcolor)
      Line(x+6, y , 1, width/2-1, fcolor) : Line(x+6, y+7, 1, 2, bcolor) : Line(x+6, y+width/2+1, 1, width/2-1, fcolor)   ; 1,0,0,0,0,1,1,0,0
      Plot(x+7, y, fcolor ) : Line(x+7, y+1, 1, width-2, bcolor) : Plot(x+7, y+width-1, fcolor )                          ; 1,1,1,1,1,1,1,1,0
   EndMacro  
   Macro DrawImageCursorSplitRight(x, y, width, bcolor, fcolor)
      Plot(x+2, y, fcolor ) : Line(x+2, y+1, 1, width-2, bcolor) : Plot(x+2, y+width-1, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      Line(x+3, y, 1, width/2-1, fcolor) : Line(x+3, y+7, 1, 2, bcolor) : Line(x+3, y+width/2+1, 1, width/2-1, fcolor)    ; 0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0
      cursor::DrawImageRight(x, y, width, bcolor, fcolor)
   EndMacro
   
   Macro DrawImageCursorDiagonal1(x, y, size, bcolor, fcolor)
      LineXY(x+3,y+2,x+13,y+12,bcolor)
      LineXY(x+2,y+2,x+13,y+13,bcolor)
      LineXY(x+2,y+3,x+12,y+13,bcolor)
      
      Plot(x+12,y+10,bcolor)
      Plot(x+10,y+12,bcolor)
      Plot(x+5,y+3,bcolor)
      Plot(x+3,y+5,bcolor)
      
      Line(x+2,y+4,1,3,bcolor)
      Line(x+4,y+2,3,1,bcolor)
      Line(x+9,y+13,3,1,bcolor)
      Line(x+13,y+9,1,3,bcolor)
      
      ;
      LineXY(x+6,y+4,x+11,y+9,fcolor)
      LineXY(x+4,y+6,x+9,y+11,fcolor)
      
      LineXY(x+2,y+7,x+3,y+6,fcolor)
      LineXY(x+7,y+2,x+6,y+3,fcolor)
      LineXY(x+8,y+13,x+9,y+12,fcolor)
      LineXY(x+13,y+8,x+12,y+9,fcolor)
      
      Line(x+1,y+2,1,6,fcolor)
      Line(x+14,y+8,1,6,fcolor)
      Line(x+2,y+1,6,1,fcolor)
      Line(x+8,y+14,6,1,fcolor)
   EndMacro
   Macro DrawImageCursorDiagonal2(x, y, size, bcolor, fcolor)
      LineXY(x+2,y+12,x+12,y+2,bcolor)
      LineXY(x+2,y+13,x+13,y+2,bcolor)
      LineXY(x+3,y+13,x+13,y+3,bcolor)
      
      Plot(x+3,y+10,bcolor)
      Plot(x+10,y+3,bcolor)
      Plot(x+5,y+12,bcolor)
      Plot(x+12,y+5,bcolor)
      
      Line(x+2,y+9,1,3,bcolor)
      Line(x+9,y+2,3,1,bcolor)
      Line(x+4,y+13,3,1,bcolor)
      Line(x+13,y+4,1,3,bcolor)
      
      ;
      LineXY(x+4,y+9,x+9,y+4,fcolor)
      LineXY(x+6,y+11,x+11,y+6,fcolor)
      
      LineXY(x+2,y+8,x+3,y+9,fcolor)
      LineXY(x+8,y+2,x+9,y+3,fcolor)
      LineXY(x+6,y+12,x+7,y+13,fcolor)
      LineXY(x+12,y+6,x+13,y+7,fcolor)
      
      Line(x+1,y+8,1,6,fcolor)
      Line(x+8,y+1,6,1,fcolor)
      Line(x+2,y+14,6,1,fcolor)
      Line(x+14,y+2,1,6,fcolor)
   EndMacro
   
   
EndDeclareModule

;\\
CompilerSelect #PB_Compiler_OS 
   CompilerCase #PB_OS_MacOS   : IncludePath "mac"
   CompilerCase #PB_OS_Windows : IncludePath "win"
   CompilerCase #PB_OS_Linux   : IncludePath "lin"
CompilerEndSelect
XIncludeFile "id.pbi"
XIncludeFile "mouse.pbi"
; XIncludeFile "parent.pbi"

;-\\ MODULE
XIncludeFile "cursor.pbi"

;-\\ example
CompilerIf #PB_Compiler_IsMainFile
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
   
   Procedure   DrawCanvasFrameWidget(Gadget, color)
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
      Protected canvas = 2
      ResizeGadget(canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(canvas)*2, WindowHeight(EventWindow()) - GadgetY(canvas)*2)
   EndProcedure
   
   Procedure Resize_3()
      Protected canvas = 3
      ResizeGadget(canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(canvas)*2, WindowHeight(EventWindow()) - GadgetY(canvas)*2)
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
      Protected dropx, dropy
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
            dropx = GadgetMouseX(eventobject, #PB_Gadget_ScreenCoordinate)
            dropy = GadgetMouseY(eventobject, #PB_Gadget_ScreenCoordinate)
            Debug ""+eventobject + " #PB_EventType_Drop " + "x="+ dropx +" y="+ dropy
            
         Case #PB_EventType_Focus
            Debug ""+eventobject + " #PB_EventType_Focus " 
            DrawCanvasBack(eventobject, $FFA7A4)
            DrawCanvasFrameWidget(eventobject, $2C70F5)
            
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
            DrawCanvasFrameWidget(eventobject, $00A600)
            
         Case #PB_EventType_MouseLeave
            ;Debug ""+eventobject + " #PB_EventType_MouseLeave "
            DrawCanvasFrameWidget(eventobject, 0)
            
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
   
   Procedure OpenWindow_(window, x,y,width,height, title.s, flag=0)
      Protected WindowID
      Protected result = OpenWindow(window, x,y,width,height, title.s, flag|#PB_Window_SizeGadget)
      If window >= 0
         WindowID = WindowID(window)
      Else
         WindowID = result
      EndIf
      ;Debug 77
      ;CocoaMessage(0, WindowID, "disableCursorRects")
      ProcedureReturn result
   EndProcedure
   
   Macro OpenWindow(window, x,y,width,height, title, flag=0)
      OpenWindow_(window, x,y,width,height, title, flag)
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
   Define x,y
   Define fcolor = $FFFFFF
   Define bcolor = $000000
   Define width = 16
   Define height = 7
   
   
   ;-\\
   If StartDrawing(CanvasOutput(Arrows))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-width)/2
      y = (OutputHeight()-width)/2
      
      ; down2                                                 
      Box(x+6,y+6,4,4, fcolor)
      cursor::DrawImageCursorUp(x,y-1,width, bcolor, fcolor )
      cursor::DrawImageCursorDown(x,y+7,width, bcolor, fcolor )
      
      cursor::DrawImageCursorLeft(x-1,y,width, bcolor, fcolor )
      cursor::DrawImageCursorRight(x+7,y,width, bcolor, fcolor )
      Box(x+7,y+7,2,2, bcolor)
      
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(Cross))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      ;       img = CocoaMessage(0, 0, "NSCursor resizeUpCursor")
      ;       ;DrawImage(img, 0,0)
      width = 13
      Line(OutputWidth()/2-1, OutputHeight()/2-width/2, 1, width, fcolor)
      Line(OutputWidth()/2+1, OutputHeight()/2-width/2, 1, width, fcolor)
      
      Line(OutputWidth()/2-width/2, OutputHeight()/2-1, width, 1, fcolor)
      Line(OutputWidth()/2-width/2, OutputHeight()/2+1, width, 1, fcolor)
      
      Line(OutputWidth()/2, OutputHeight()/2-width/2, 1, width, bcolor)
      Line(OutputWidth()/2-width/2, OutputHeight()/2, width, 1, bcolor)
      StopDrawing()
   EndIf
   
   Define width = 16
   Define height = 7
   
   ;-\\ Dioganal1
   If StartDrawing(CanvasOutput(lt))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-width)/2
      y = (OutputHeight()-width)/2
      ;
      cursor::DrawImageCursorDiagonal1(x,y,width, bcolor, fcolor)
      
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(rb))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-width)/2
      y = (OutputHeight()-width)/2
      ;
      cursor::DrawImageCursorDiagonal1(x,y,width, bcolor, fcolor)
      
      StopDrawing()
   EndIf
   
   ;-\\ Dioganal2
   If StartDrawing(CanvasOutput(rt))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-width)/2
      y = (OutputHeight()-width)/2
      ; 
      cursor::DrawImageCursorDiagonal2(x,y,width, bcolor, fcolor)
      
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(lb))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-width)/2
      y = (OutputHeight()-width)/2
      ; 
      cursor::DrawImageCursorDiagonal2(x,y,width, bcolor, fcolor)
      
      StopDrawing()
   EndIf
   
   ;-\\ Vertical
   If StartDrawing(CanvasOutput(up))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-width)/2
      y = (OutputHeight()-height)/2
      
      ; up                                                 
      cursor::DrawImageUp(x, y, width, bcolor, fcolor)
      cursor::DrawImageCursorSplitUp(x,y,width, bcolor, fcolor )
      Plot(x, y+8, fcolor ) : Line(x+1, y+8, width-2, 1, bcolor) : Plot(x+width-1, y+8, fcolor )                          ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      Line(x, y + 9, width , 1, fcolor)                                                                                   ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(up2))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-width)/2
      y = (OutputHeight()-(height*2))/2
      
      ; down2                                                 
      cursor::DrawImageCursorSplitV(x,y,width,height, bcolor, fcolor )
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(up3))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-width)/2
      y = (OutputHeight()-(height*2))/2
      
      cursor::DrawImageCursorUp(x,y-1,width, bcolor, fcolor )
      cursor::DrawImageCursorDown(x,y+height-2,width, bcolor, fcolor )
      StopDrawing()
   EndIf
   
   If StartDrawing(CanvasOutput(down))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-width)/2
      y = (OutputHeight()-height)/2
      
      ; down                                                 
      Line(x, y, width, 1, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      Plot(x, y+1, fcolor ) : Line(x+1, y+1, width-2, 1, bcolor) : Plot(x+width-1, y+1, fcolor )                           ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      cursor::DrawImageCursorSplitDown(x,y,width, bcolor, fcolor )
      cursor::DrawImageDown(x, y, width, bcolor, fcolor)
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(down2))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-width)/2
      y = (OutputHeight()-(height*2))/2
      
      ; down2                                                 
      cursor::DrawImageCursorSplitV(x,y,width,height, bcolor, fcolor )
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(down3))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-width)/2
      y = (OutputHeight()-(height*2))/2
      
      ; down2                                                 
      ; Box(x+6,y+5,4,4, fcolor)
      cursor::DrawImageCursorUp(x,y-1,width, bcolor, fcolor )
      cursor::DrawImageCursorDown(x,y+height-2,width, bcolor, fcolor )
      
      ;     x = (OutputWidth()-(height*2))/2
      ;     y = (OutputHeight()-width)/2
      ;     ;Box(x+6,y+7,2,2, bcolor)
      
      StopDrawing()
   EndIf
   
   ;-\\ Horizontal
   If StartDrawing(CanvasOutput(left))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-height)/2
      y = (OutputHeight()-width)/2
      
      ; left                                                 
      cursor::DrawImageCursorSplitLeft(x,y,width, bcolor, fcolor )
      Plot(x+8, y, fcolor ) : Line(x+8, y+1, 1, width-2, bcolor) : Plot(x+8, y+width-1, fcolor )                        ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      Line(x + 9, y, 1, width, fcolor)                                                                                  ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(left2))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-(height*2))/2
      y = (OutputHeight()-width)/2
      Debug ""+x+" "+y
      ; left2                                                 
      cursor::DrawImageCursorSplitLeft(x,y,width, bcolor, fcolor )
      cursor::DrawImageCursorSplitRight(x+height-1,y,width, bcolor, fcolor )
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(left3))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-(height*2))/2
      y = (OutputHeight()-width)/2
      ; ver-size
      cursor::DrawImageCursorLeft(x-1,y,width, bcolor, fcolor )
      cursor::DrawImageCursorRight(x+height-2,y,width, bcolor, fcolor )
      StopDrawing()
   EndIf
   
   If StartDrawing(CanvasOutput(right))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-height)/2
      y = (OutputHeight()-width)/2
      
      ; right                                                 
      Line(x, y, 1, width, fcolor)                                                                                         ; 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      Plot(x+1, y, fcolor ) : Line(x+1, y+1, 1, width-2, bcolor) : Plot(x+1, y+width-1, fcolor )                           ; 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
      cursor::DrawImageCursorSplitRight(x,y,width, bcolor, fcolor )
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(right2))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      x = (OutputWidth()-(height*2))/2
      y = (OutputHeight()-width)/2
      
      ; right2                                                 
      cursor::DrawImageCursorSplitLeft(x,y,width, bcolor, fcolor )
      cursor::DrawImageCursorSplitRight(x+height-1,y,width, bcolor, fcolor )
      StopDrawing()
   EndIf
   If StartDrawing(CanvasOutput(right3))
      Box(0,0,OutputWidth(),OutputHeight(), $A9B7B6)
      ;     x = (OutputWidth()-width)/2
      ;     y = (OutputHeight()-(height*2))/2
      ;     
      ;     ; down2                                                 
      ;     ;Box(x+6,y+5,4,4, fcolor)
      
      x = (OutputWidth()-(height*2))/2
      y = (OutputHeight()-width)/2
      
      cursor::DrawImageCursorLeft(x-1,y,width, bcolor, fcolor )
      cursor::DrawImageCursorRight(x+height-2,y,width, bcolor, fcolor )
      ;Box(x+6,y+7,2,2, bcolor)
      
      StopDrawing()
   EndIf
   
   ;-
   Repeat 
      event = WaitWindowEvent()
      EnteredGadget = ID::Gadget(Mouse::Gadget(Mouse::Window()))
      
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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 62
; FirstLine = 54
; Folding = -0--0--------
; Optimizer
; EnableXP
; DPIAware