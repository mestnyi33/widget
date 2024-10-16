﻿EnableExplicit

;-
DeclareModule String
   EnableExplicit
   
   ;- STRUCTURE
   Structure Coordinate
      y.l[3]
      x.l[3]
      Height.l[3]
      Width.l[3]
   EndStructure
   
   Structure Mouse
      X.l
      Y.l
      Buttons.l
   EndStructure
   
   Structure Canvas
      Mouse.Mouse
      Gadget.l
      Window.l
      
      Input.c
      Key.l[2]
      
   EndStructure
   
   Structure Text Extends Coordinate
      ;     Char.c
      Len.l
      String.s[2]
      Change.b
      
      Lower.b
      Upper.b
      Pass.b
      Editable.b
      Numeric.b
      Wrap.b
      MultiLine.b
      
      CaretPos.l[2] ; [0] = Pos ; [1] = PosFixed
      
      Mode.l
   EndStructure
   
   Structure Gadget Extends Coordinate
      FontID.i
      Canvas.Canvas
      
      Text.Text[4]
      Color.l[3]
      
      
      fSize.l
      bSize.l
      Hide.b[2]
      Disable.b[2]
      
      Type.l
      InnerCoordinate.Coordinate
      
      Repaint.l
      
      List Items.Gadget()
      List Columns.Gadget()
   EndStructure
   
   
   ;- DECLARE
   Declare.s GetText(Gadget.l)
   Declare Gadget(Gadget, X.l, Y.l, Width.l, Height.l, Text.s, Flag.l=0)
   
   Declare SetFont(Gadget, FontID.i)
EndDeclareModule

Module String
   
   ;- PROCEDURE
   
   Procedure Caret(*This.Gadget, Reset=0)
      Protected Position.l =- 1, i.l, CaretPos.l, CursorX.i, Distance.f, MinDistance.f = Infinity()
      
      With *This
         If StartDrawing(CanvasOutput(\Canvas\Gadget)) 
            If \FontID : DrawingFont(\FontID) : EndIf
            
            ; get caret position
            For i=0 To \Text\Len
               CursorX = \Text\x + TextWidth(Left(\Text\String.s, i))
               Distance = (\Canvas\Mouse\X-CursorX)*(\Canvas\Mouse\X-CursorX)
               
               If MinDistance > Distance : MinDistance = Distance : Position = i : EndIf
            Next
            
            \Text\CaretPos = Position
            If Reset 
               \Text[2]\Len = 0
               \Text\CaretPos[1] = \Text\CaretPos 
            EndIf
            
            ; Если выделяем с право на лево
            If \Text\CaretPos[1] > \Text\CaretPos 
               CaretPos = \Text\CaretPos
               \Text[2]\Len = (\Text\CaretPos[1]-\Text\CaretPos)
            Else 
               CaretPos = \Text\CaretPos[1]
               \Text[2]\Len = \Text\CaretPos-\Text\CaretPos[1]
            EndIf
            
            \Text[1]\String.s = Left(\Text\String.s, CaretPos)
            
            If \Text[2]\Len
               \Text[2]\String.s = Mid(\Text\String.s, 1 + CaretPos, \Text[2]\Len)
               \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(CaretPos + \Text[2]\Len))
            Else
               \Text[2]\String.s = ""
            EndIf
            
            \Text[1]\Width = TextWidth(\Text[1]\String.s) 
            
            
            If \Text\CaretPos >= \Text\CaretPos[1] 
             \Text[2]\X = \Text\X+\Text[1]\Width
              \Text[2]\Width = TextWidth(\Text[2]\String.s)
               \Text[3]\X = TextWidth(\Text[1]\String.s + \Text[2]\String.s) ; \Text\X+\Text[1]\Width+\Text[2]\Width
            Else
              \Text[2]\X = \Text\X+\Text[1]\Width
             \Text[2]\Width = TextWidth(\Text[1]\String.s + \Text[2]\String.s + \Text[3]\String.s) - TextWidth(\Text[1]\String.s) - TextWidth(\Text[3]\String.s); \Text[3]\X - \Text[2]\X
            EndIf
         
            StopDrawing()
         EndIf
      EndWith
      
      ProcedureReturn #True
   EndProcedure
   
   Procedure Draw(*This.Gadget)
      With *This
         If StartDrawing(CanvasOutput(\Canvas\Gadget))
            If \FontID : DrawingFont(\FontID) : EndIf
            Box(\X[1],\Y[1],\Width[1],\Height[1],\Color[0])
            
            \Text\Height = TextHeight("A")
            \Text[0]\Width = TextWidth(\Text\String.s)
            
            \Text\X = 3 
            \Text\Y = 3
            
            If \Text\String.s
               If \Text[2]\Len
                  
                  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                     If \text\string.s
                        DrawingMode( #PB_2DDrawing_Transparent )
                        DrawText( \Text\X, \Text\Y, \Text\string.s, $0B0B0B )
                     EndIf
                     
                     If \Text[2]\width
                        DrawingMode( #PB_2DDrawing_Default )
                        Box( \Text[2]\X, \Text\Y, \Text[2]\Width, \Text\Height, $D77800 )
                     EndIf
                     
                     DrawingMode( #PB_2DDrawing_Transparent )
                     
                     ; to right select
                     If ( \Text\CaretPos > \Text\CaretPos[1] )
                        
                        If \Text[2]\string.s
                           DrawText( \Text[2]\X, \Text\Y, \Text[2]\string.s, $FFFFFF )
                        EndIf
                        
                        ; to left select
                     Else
                        If \Text[2]\string.s
                           DrawText( \Text\X, \Text\Y, \Text[1]\string.s + \Text[2]\string.s, $FFFFFF )
                        EndIf
                        
                        If \Text[1]\width
                           DrawingMode( #PB_2DDrawing_Default )
                           Box( \Text\X, \Text\Y, \Text[1]\Width, \Text\Height, $FFFFFF )
                        EndIf
                        
                        DrawingMode( #PB_2DDrawing_Transparent )
                        If \Text[1]\string.s
                           DrawText( \Text\X, \Text\Y, \Text[1]\string.s, $0B0B0B )
                        EndIf
                     EndIf
                     
                  CompilerElse
                     If \Text[1]\String.s
                        DrawingMode(#PB_2DDrawing_Transparent)
                        DrawText(\Text\X, \Text\Y, \Text[1]\String.s, $0B0B0B)
                     EndIf
                     
                     If \Text[2]\String.s
                        DrawingMode(#PB_2DDrawing_Default)
                        DrawText(\Text[2]\X, \Text\Y, \Text[2]\String.s, $FFFFFF, $D77800)
                     EndIf
                     
                     If \Text[3]\String.s
                        DrawingMode(#PB_2DDrawing_Transparent)
                        DrawText(\Text[3]\X, \Text\Y, \Text[3]\String.s, $0B0B0B)
                     EndIf
                  CompilerEndIf
                  
                  
                  
               Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawText(\Text\X, \Text\Y, \Text\String.s, $0B0B0B)
               EndIf
            EndIf
            
            If \Text\CaretPos=\Text\CaretPos[1] 
               DrawingMode(#PB_2DDrawing_XOr)             
               Line(\Text\X + \Text[1]\Width, \Text\Y, 1, \Text\Height, $FFFFFF)
            EndIf
            
            StopDrawing()
         EndIf
      EndWith  
   EndProcedure
   
   Procedure EditableCallBack(*This.Gadget, EventType.l)
      Protected Result
      
      If *This
         With *This
            If Not \Disable
               Select EventType
                  Case #PB_EventType_MouseEnter
                     SetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor, #PB_Cursor_IBeam)
                     
                  Case #PB_EventType_LeftButtonDown
                     Result = Caret(*This, 1)
                     
                  Case #PB_EventType_MouseMove
                     If \Canvas\Mouse\Buttons & #PB_Canvas_LeftButton
                        Result = Caret(*This)
                     EndIf
                     
               EndSelect
               
            EndIf
         EndWith
      EndIf
      
      ProcedureReturn Result
   EndProcedure
   
   Procedure CallBack()
      Protected *This.Gadget = GetGadgetData(EventGadget())
      
      With *This
         \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
         \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
         \Canvas\Mouse\Buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
         
         If EditableCallBack(*This, EventType()) : Draw(*This) : EndIf
      EndWith
   EndProcedure
   
   ;- PUBLIC
   Procedure.s GetText(Gadget.l)
      Protected ScrollPos, *This.Gadget = GetGadgetData(Gadget)
      
      With *This
         If \Text\Pass
            ProcedureReturn \Text\String.s[1]
         Else
            ProcedureReturn \Text\String
         EndIf
      EndWith
   EndProcedure
   
   Procedure SetFont(Gadget, FontID.i)
      Protected *This.Gadget = GetGadgetData(Gadget)
      
      With *This
         \FontID = FontID
         Draw(*This)
      EndWith
   EndProcedure
   
   Procedure Gadget(Gadget, X.l, Y.l, Width.l, Height.l, Text.s, Flag.l=0)
      Protected *This.Gadget=AllocateStructure(Gadget)
      Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
      
      If *This
         With *This
            \Canvas\Gadget = Gadget
            \Width = Width
            \Height = Height
            \Type = #PB_GadgetType_String
            \FontID = GetGadgetFont(#PB_Default)
            
            ; Inner coordinae
            \X[2]=\bSize
            \Y[2]=\bSize
            \Width[2] = \Width-\bSize*2
            \Height[2] = \Height-\bSize*2
            
            ; Frame coordinae
            \X[1]=\X[2]-\fSize
            \Y[1]=\Y[2]-\fSize
            \Width[1] = \Width[2]+\fSize*2
            \Height[1] = \Height[2]+\fSize*2
            
            \Color[1] = $C0C0C0
            \Color[2] = $F0F0F0
            \Color[0] = $FFFFFF
            
            \Text\String.s[1] = Text.s
            
            \Text\String.s = Text.s
            
            \Text\CaretPos[1] =- 1
            \Text\Len = Len(\Text\String.s)
            
            SetGadgetData(Gadget, *This)
            BindGadgetEvent(Gadget, @CallBack())
            Draw(*This)
         EndIf
      EndWith
      
      ProcedureReturn Gadget
   EndProcedure
EndModule


;- EXAMPLE


LoadFont(0, "Courier", 20)
Define Event, Text.s = "Vertical and Horizontal" + #CRLF$ + "Centered Text in" + #CRLF$ + "Multiline StringGadget"

If OpenWindow(0, 0, 0, 605, 235, "StringGadget Flags", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   StringGadget(0, 8,  10, 290, 20, "Normal StringGadget...  ggggggggggggg dddddddddddd wwwwwwwwwww aaaaaaaaaaaaaa")
   
   String::Gadget(10, 300+8,  10, 290, 20, "Normal StringGadget...  ggggggggggggg dddddddddddd wwwwwwwwwww aaaaaaaaaaaaaa")
   
   Repeat 
      Event = WaitWindowEvent()
      
      Select Event
         Case #PB_Event_LeftClick  
            SetActiveGadget(0)
         Case #PB_Event_RightClick 
            SetActiveGadget(10)
      EndSelect
   Until Event = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 176
; FirstLine = 168
; Folding = --------
; EnableXP