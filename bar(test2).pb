IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "bar().pbi"
;XIncludeFile "_module_bar.pb"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  ; IncludePath "C:\Users\as\Documents\GitHub\"
  ; XIncludeFile "module_scroll.pbi"
  
  EnableExplicit
  UseModule Bar
  Enumeration
    #MyCanvas = 111   ; just to test whether a number different from 0 works now
  EndEnumeration
  
  Global isCurrentItem=#False
  Global currentItemXOffset.i, currentItemYOffset.i
  Global Event.i, x.i, y.i, drag.i, hole.i, Width, Height
  Global *scroll._S_scroll=AllocateStructure(_S_scroll)
  
  Procedure ReDraw (canvas.i)
    With *scroll
      If StartDrawing(CanvasOutput(canvas))
        ; ClipOutput(\h\x, \v\y, \h\bar\page\len, \v\bar\page\len)
        
        FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
        
        Draw(\v)
        Draw(\h)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(\h\x, \v\y, \h\bar\page\len, \v\bar\page\len, $0000FF)
        
        
        StopDrawing()
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Canvas_CallBack() ; Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint
    Protected Canvas = EventGadget()
    Protected EventType = EventType()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected ScrollX, ScrollY, ScrollWidth, ScrollHeight
    
    With *scroll
      If CallBack(\v, EventType, MouseX, MouseY, WheelDelta) 
        Repaint = #True 
      EndIf
      If CallBack(\h, EventType, MouseX, MouseY, WheelDelta) 
        Repaint = #True 
      EndIf
      
      
      If Not (\h\from=-1 And \v\from=-1)
        If \v\change
          SetWindowTitle(EventWindow(), Str(\v\bar\page\pos))
          \v\change = 0
        EndIf
        If \h\change
          SetWindowTitle(EventWindow(), Str(\h\bar\page\pos))
          \h\change = 0
        EndIf
      EndIf 
      
      Select EventType
          Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
            Resizes(*scroll, 0, 0, Width, Height)
            Repaint = #True
           
        EndSelect
      
      If Repaint 
        ReDraw(#MyCanvas) 
      EndIf
    EndWith
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(#MyCanvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20-100)
  EndProcedure
  
  
  If Not OpenWindow(0, 0, 0, 420, 420+110, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  ;
  ComboBoxGadget(1, 110, 10, 180,20) 
  AddGadgetItem(1, -1, "Scroll")
  AddGadgetItem(1, -1, "Spin")
  AddGadgetItem(1, -1, "Track")
  AddGadgetItem(1, -1, "Splitter")
  AddGadgetItem(1, -1, "Progress")
  SetGadgetState(1, 1)
  
  CheckBoxGadget(2, 10, 10, 80,20, "vertical") : SetGadgetState(2, 1)
  CheckBoxGadget(3, 10, 30, 80,20, "invert")
  CheckBoxGadget(4, 10, 50, 80,20, "noButtons")
  CheckBoxGadget(5, 10, 70, 80,20, "Pos&len")
  TrackBarGadget(6, 10, 95, 400,20, 0, 400, #PB_TrackBar_Ticks)
  SetGadgetState(5,1)
  
  CanvasGadget(#MyCanvas, 10, 120, 400, 400)
  
  *Scroll\v = Scroll(360, 0,  40, 360, 0, 500, 360, #PB_ScrollBar_Vertical, 9)
  *Scroll\h = Scroll(0, 360, 360,  40, 0, 500, 360, 0, 9)
  
  SetState(*Scroll\h, 30)
  
  If GetGadgetState(2)
    SetGadgetState(3, GetAttribute(*Scroll\v, #Bar_Inverted))
  Else
    SetGadgetState(3, GetAttribute(*Scroll\h, #Bar_Inverted))
  EndIf
  
  Define vButton = GetAttribute(*Scroll\v, #Bar_ButtonSize)
  Define hButton = GetAttribute(*Scroll\h, #Bar_ButtonSize)
  
  PostEvent(#PB_Event_Gadget, 0,#MyCanvas, #PB_EventType_Resize)
  BindGadgetEvent(#MyCanvas, @Canvas_CallBack())
  BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
  
  ;Resize(*Scroll\v, #PB_Ignore, 30, #PB_Ignore, (*scroll\v\bar\page\len + Bool(*scroll\v\round And *scroll\h\round)*(*scroll\h\height/4))-30)
              
  Repeat
    Event = WaitWindowEvent()
    
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 6
            If GetGadgetState(5)
              If GetGadgetState(2)
                Resize(*Scroll\v, #PB_Ignore, GetGadgetState(6), #PB_Ignore, (*scroll\v\bar\page\len + Bool(*scroll\v\round And *scroll\h\round)*(*scroll\h\height/4))-GetGadgetState(6))
              Else
                Resize(*Scroll\h, GetGadgetState(6), #PB_Ignore, (*scroll\h\bar\page\len + Bool(*scroll\v\round And *scroll\h\round)*(*scroll\v\width/4))-GetGadgetState(6), #PB_Ignore)
              EndIf
            Else
              If GetGadgetState(2)
                Resizes(*Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 400-GetGadgetState(6))
              Else
                Resizes(*Scroll, #PB_Ignore, #PB_Ignore, 400-GetGadgetState(6), #PB_Ignore)
              EndIf
            EndIf
            ReDraw(#MyCanvas) 
            
          Case 1 
            Select GetGadgetText(1)
              Case "Spin"
                If GetGadgetState(2)
                  *Scroll\v = Spin(360, 0,  40, 360, 0, 500, 0, 9)
                Else
                  *Scroll\h = Spin(0, 360, 360, 40, 0, 500, #Bar_Vertical, 9)
                EndIf
                
              Case "Scroll"
                If GetGadgetState(2)
                  *Scroll\v = Scroll(360, 0,  40, 360, 0, 500, 360, #Bar_Vertical, 9)
                Else
                  *Scroll\h = Scroll(0, 360, 360,  40, 0, 500, 360, 0, 9)
                EndIf
            
              Case "Progress"
                If GetGadgetState(2)
                  *Scroll\v = Progress(360, 0,  40, 360, 0, 500, #Bar_Vertical, 9)
                Else
                  *Scroll\h = Progress(0, 360, 360,  40, 0, 500, 0, 9)
                EndIf
            
              Case "Track"
                If GetGadgetState(2)
                  *Scroll\v = Track(360, 0,  40, 360, 0, 500, #Bar_Vertical, 9)
                Else
                  *Scroll\h = Track(0, 360, 360,  40, 0, 500, 0, 9)
                EndIf
            
              Case "Splitter"
                If GetGadgetState(2)
                  *Scroll\v = Splitter(360, 0,  40, 360, 0, 500, #Bar_Vertical, 9)
                Else
                  *Scroll\h = Splitter(0, 360, 360,  40, 0, 500, 0, 9)
                EndIf
            
            EndSelect
            
            *Scroll\v\bar\button[1]\len = 10
            *Scroll\v\bar\button[2]\len = 10
            update(*Scroll\v)
            ReDraw(#MyCanvas) 
            
          Case 2 
            If GetGadgetState(2)
              SetGadgetState(3, GetAttribute(*Scroll\v, #Bar_Inverted))
            Else
              SetGadgetState(3, GetAttribute(*Scroll\h, #Bar_Inverted))
            EndIf
            
          Case 3
            If GetGadgetState(2)
              SetAttribute(*Scroll\v, #Bar_Inverted, Bool(GetGadgetState(3)))
              SetWindowTitle(0, Str(GetState(*Scroll\v)))
            Else
              SetAttribute(*Scroll\h, #Bar_Inverted, Bool(GetGadgetState(3)))
              SetWindowTitle(0, Str(GetState(*Scroll\h)))
            EndIf
            ReDraw(#MyCanvas) 
            
          Case 4
            If GetGadgetState(2)
              SetAttribute(*Scroll\v, #Bar_ButtonSize, Bool( Not GetGadgetState(4)) * vButton) 
              SetWindowTitle(0, Str(GetState(*Scroll\v)))
            Else
              SetAttribute(*Scroll\h, #Bar_ButtonSize, Bool( Not GetGadgetState(4)) * hButton)
              SetWindowTitle(0, Str(GetState(*Scroll\h)))
            EndIf
            ReDraw(#MyCanvas) 
            
        EndSelect
    EndSelect
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -----
; EnableXP