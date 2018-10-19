CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_text.pbi"
CompilerEndIf

;-
DeclareModule Button
  
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  ;- - DECLAREs MACROs
;   Macro Draw(_adress_, _canvas_=-1) : Text::Draw(_adress_, _canvas_) : EndMacro
  Macro Parent(_adress_, _canvas_) : Bool(_adress_\Canvas\Gadget = _canvas_) : EndMacro
  
  Macro GetText(_adress_) : Text::GetText(_adress_) : EndMacro
  Macro SetText(_adress_, _text_) : Text::SetText(_adress_, _text_) : EndMacro
  Macro SetFont(_adress_, _font_id_) : Text::SetFont(_adress_, _font_id_) : EndMacro
  Macro GetColor(_adress_, _color_type_, _state_=0) : Text::GetColor(_adress_, _color_type_, _state_) : EndMacro
  Macro SetColor(_adress_, _color_type_, _color_, _state_=1) : Text::SetColor(_adress_, _color_type_, _color_, _state_) : EndMacro
  Macro Resize(_adress_, _x_,_y_,_width_,_height_, _canvas_=-1) : Text::Resize(_adress_, _x_,_y_,_width_,_height_, _canvas_) : EndMacro
  
  ;- - DECLAREs PRACEDUREs
  Declare.i Draw(*This.Widget_S, Canvas.i=-1)
  
  Declare.i GetState(*This.Widget_S)
  Declare.i SetState(*This.Widget_S, Value.i)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Image.i=-1, Flag.i=0, Radius.i=0)
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1) ; .i CallBack(*This.Widget_S, Canvas.i, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0)
  Declare.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0, Image.i=-1)
  
EndDeclareModule

Module Button
  ;-
  ;- - MACROS
  ;- - PROCEDUREs
  Procedure.i GetState(*This.Widget_S)
    ProcedureReturn *This\Toggle
  EndProcedure
  
  Procedure.i SetState(*This.Widget_S, Value.i)
    Protected Result
    
    If *This\Toggle <> Bool(Value)
      *This\Toggle = Bool(Value)
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Draw(*This.Widget_S, Canvas.i=-1)
    Protected String.s, StringWidth
    Protected IT,Text_Y,Text_X,Width,Height
    
    If Not *This\Hide
      With *This
        If Canvas=-1 
          Canvas = EventGadget()
        EndIf
        If Canvas <> \Canvas\Gadget
          ProcedureReturn
        EndIf
        
        If \Text\FontID 
          DrawingFont(\Text\FontID) 
        EndIf
        
        CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
          ClipOutput(\X[2],\Y[2],\Width[2],\Height[2]) ; Bug in Mac os
        CompilerEndIf
        
        DrawingMode(\DrawingMode)
        BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color\Fore,\Color\Back,\Radius)
        
        
        ; Make output text
        If \Text\String.s
          If \Text\Change
            \Text\Height = TextHeight("A")
            \Text\Width = TextWidth(\Text\String.s)
          EndIf
          
          If (\Text\Change Or \Resize)
            If \Text\Vertical
              Width = \Height[1]-\Text\X*2-(\Image\Width+\Image\Width/2)
              Height = \Width[1]-\Text\y*2
            Else
              Width = \Width[1]-\Text\X*2-(\Image\Width+\Image\Width/2)
              Height = \Height[1]-\Text\y*2
            EndIf
            
            If \Text\MultiLine
              \Text\String.s[2] = Text::Wrap(\Text\String.s, Width, -1)
              \Text\CountString = CountString(\Text\String.s[2], #LF$)
            ElseIf \Text\WordWrap
              \Text\String.s[2] = Text::Wrap(\Text\String.s, Width, 1)
              \Text\CountString = CountString(\Text\String.s[2], #LF$)
            Else
              ;  \Text\String.s[1] = Text::Wrap(\Text\String.s, Width, 0)
              \Text\String.s[2] = \Text\String.s
              \Text\CountString = 1
            EndIf
            
            If \Text\CountString
              ClearList(\Items())
              
              If \Text\Align\Bottom
                Text_Y=(Height-(\Text\Height*\Text\CountString)-Text_Y) 
              ElseIf \Text\Align\Vertical
                Text_Y=((Height-(\Text\Height*\Text\CountString))/2)
              EndIf
              
              DrawingMode(#PB_2DDrawing_Transparent)
              If \Text\Vertical
                For IT = \Text\CountString To 1 Step - 1
                  If \Text\Y+Text_Y < \bSize : Text_Y+\Text\Height : Continue : EndIf
                  
                  String = StringField(\Text\String.s[2], IT, #LF$)
                  StringWidth = TextWidth(RTrim(String))
                  
                  If \Text\Align\Right
                    Text_X=(Width-StringWidth) 
                  ElseIf \Text\Align\Horisontal
                    Text_X=(Width-StringWidth)/2 
                  EndIf
                  
                  AddElement(\Items())
                  \Items()\Text\Editable = \Text\Editable 
                  \Items()\Text\Vertical = \Text\Vertical
                  If \Text\Rotate = 270
                    \Items()\Text\x = \Image\Width+\X[1]+\Text\Y+Text_Y+\Text\Height+\Text\X
                    \Items()\Text\y = \Y[1]+\Text\X+Text_X
                  Else
                    \Items()\Text\x = \Image\Width+\X[1]+\Text\Y+Text_Y
                    \Items()\Text\y = \Y[1]+\Text\X+Text_X+StringWidth
                  EndIf
                  \Items()\Text\Width = StringWidth
                  \Items()\Text\Height = \Text\Height
                  \Items()\Text\String.s = String.s
                  \Items()\Text\Len = Len(String.s)
                  
                  
                  ;DrawRotatedText(\X[1]+\Text\Y+Text_Y, \Y[1]+\Text\X+Text_X+StringWidth, String.s, 90, \Color\Front)
                  ;DrawRotatedText(\X[1]+\Text\Y+Text_Y+\Text\Height, \Y[1]+\Text\X+Text_X, String.s, 270, \Color\Front)
                  Text_Y+\Text\Height : If Text_Y > (Width) : Break : EndIf
                Next
              Else
                For IT = 1 To \Text\CountString
                  If \Text\Y+Text_Y < \bSize : Text_Y+\Text\Height : Continue : EndIf
                  
                  String = StringField(\Text\String.s[2], IT, #LF$)
                  StringWidth = TextWidth(RTrim(String))
                  
                  If \Text\Align\Right
                    Text_X=(Width-StringWidth) 
                  ElseIf \Text\Align\Horisontal
                    Text_X=(Width-StringWidth)/2 
                  EndIf
                  
                  AddElement(\Items())
;                   \Items()\Text\Caret = \Text\Caret 
;                   \Items()\Text\Caret[1] = \Text\Caret[1] 
                  \Items()\Text\Editable = \Text\Editable 
                  \Items()\Text\x = (\Image\Width+\Image\Width/2)+\X[1]+\Text\X+Text_X
                  \Items()\Text\y = \Y[1]+\Text\Y+Text_Y
                  \Items()\Text\Width = StringWidth
                  \Items()\Text\Height = \Text\Height
                  \Items()\Text\String.s = String.s
                  \Items()\Text\Len = Len(String.s)
                  
                  \Image\X = \Items()\Text\x-(\Image\Width+\Image\Width/2)
                  \Image\Y = \Y[1]+\Text\Y +(Height-\Image\Height)/2
                  
                  ;DrawText(\X[1]+\Text\X+Text_X, \Y[1]+\Text\Y+Text_Y, String.s, \Color\Front)
                  Text_Y+\Text\Height : If Text_Y > (Height-\Text\Height) : Break : EndIf
                Next
              EndIf
            EndIf
          EndIf
          
          If \Text\Change
            \Text\Change = 0
          EndIf
          
          If \Resize
            \Resize = 0
          EndIf
        EndIf
        
      EndWith 
      
      ; Draw items text
      If ListSize(*This\Items())
        With *This\Items()
          PushListPosition(*This\Items())
          ForEach *This\Items()
            ; Draw image
            If \Image\handle
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
            EndIf
            
            ; Draw string
            If \Text\String.s
              If \Text\FontID 
                DrawingFont(\Text\FontID) 
              EndIf
              
              If \Text[1]\Change : \Text[1]\Change = #False
                \Text[1]\Width = TextWidth(\Text[1]\String.s) 
              EndIf 
              
              If \Text[2]\Change : \Text[2]\Change = #False 
                \Text[2]\X = \Text[0]\X+\Text[1]\Width
                \Text[2]\Width = TextWidth(\Text[2]\String.s) ; bug in mac os
                \Text[3]\X = \Text[2]\X+\Text[2]\Width
              EndIf 
              
              If \Text[3]\Change : \Text[3]\Change = #False 
                \Text[3]\Width = TextWidth(Left(\Text\String.s, \Text\Caret))
              EndIf 
              
              CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
                ClipOutput(*This\X[2]+*This\Text[0]\X-1,*This\Y[2],*This\Width[2]-*This\Text[0]\X*2+2,*This\Height[2]) ; Bug in Mac os
              CompilerEndIf
              
              If *This\Focus = *This 
                Protected Left,Right
                Left =- \Text[3]\Width 
                Right = (*This\Width[2]-*This\Text\X*2)-\Text[3]\Width
                
                If *This\Scroll\X < Left
                  *This\Scroll\X = Left
                ElseIf *This\Scroll\X > Right
                  *This\Scroll\X = Right
                EndIf
                
;                 If \Text[2]\String.s[1] And *This\Scroll\X < 0
;                   *This\Scroll\X + TextWidth(\Text[2]\String.s[1]) 
;                   \Text[2]\String.s[1] = ""
;                 EndIf
              EndIf
            
              If \Text[2]\Len And #PB_Compiler_OS <> #PB_OS_MacOS
                If \Text[1]\String.s
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText((\Text[0]\X+*This\Scroll\X), \Text[0]\Y, \Text[1]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                EndIf
                If \Text[2]\String.s
                  DrawingMode(#PB_2DDrawing_Default)
;                   If \Text[0]\String.s = \Text[1]\String.s+\Text[2]\String.s
;                     Box((\Text[2]\X+*This\Scroll\X), \Text[0]\Y,*This\width[2]-\Text[2]\X, \Text[0]\Height, $DE9541)
;                   Else
                    Box((\Text[2]\X+*This\Scroll\X), \Text[0]\Y, \Text[2]\Width, \Text[0]\Height+1, $DE9541)
;                   EndIf
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText((\Text[2]\X+*This\Scroll\X), \Text[0]\Y, \Text[2]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, $FFFFFF)
                EndIf
                If \Text[3]\String.s
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText((\Text[3]\X+*This\Scroll\X), \Text[0]\Y, \Text[3]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                EndIf
              Else
                If \Text[2]\Len
                  DrawingMode(#PB_2DDrawing_Default)
                  Box((\Text[2]\X+*This\Scroll\X), \Text[0]\Y, \Text[2]\Width, \Text[0]\Height+1, $FADBB3);$DE9541)
                EndIf
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawRotatedText((\Text[0]\X+*This\Scroll\X), \Text[0]\Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
              EndIf
            EndIf
            
          Next
          PopListPosition(*This\Items()) ; 
          
          If *This\Focus = *This 
            ; Debug ""+ \Text[0]\Caret +" "+ \Text[0]\Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If *This\Text\Editable And \Text\Caret = \Text\Caret[1] 
              DrawingMode(#PB_2DDrawing_XOr)             
              Line(((\Text[0]\X+*This\Scroll\X) + \Text[1]\Width) - Bool(*This\Scroll\X = Right), \Text[0]\Y, 1, \Text[0]\Height, $FFFFFF)
            EndIf
          EndIf
        EndWith  
      EndIf
      
      ; Draw frames
      With *This
        CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
          ClipOutput(\X[1]-2,\Y[1]-2,\Width[1]+4,\Height[1]+4) ; Bug in Mac os
        CompilerEndIf
        
        ; Draw image
        If \Image\handle
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
        EndIf
        
        ; Draw frames
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If \Default
          RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[3])
;           If \Radius ; Сглаживание краев)))
;             RoundBox(\X[1]+2,\Y[1]+3,\Width[1]-4,\Height[1]-6,\Radius,\Radius,\Color\Frame[3]) ; $D5A719)
;           EndIf
;           RoundBox(\X[1]+3,\Y[1]+3,\Width[1]-6,\Height[1]-6,\Radius,\Radius,\Color\Frame[3])
        EndIf
        
        If \Focus = *This ;  Debug "\Focus "+\Focus
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[3])
          If \Radius ; Сглаживание краев))) ; RoundBox(\X[1],\Y[1],\Width[1]+1,\Height[1]+1,\Radius,\Radius,\Color\Frame[3])
            RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,\Color\Frame[3]) ; $D5A719)
          EndIf
          RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,\Color\Frame[3])
        Else
          If \fSize
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame)
          EndIf
        EndIf
      EndWith
    EndIf
    
  EndProcedure
  Procedure.i Events(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Static Text$, DoubleClickCaret =- 1
    Protected Repaint, StartDrawing, Update_Text_Selected
    
    Protected Buttons, Widget.i
    Static *Focus.Widget_S, *Last.Widget_S, *Widget.Widget_S, LastX, LastY, Last, Drag
    
    ; widget_events_type
    If *This
      With *This
        If Canvas=-1 
          Widget = *This
          Canvas = EventGadget()
        Else
          Widget = Canvas
        EndIf
        If Canvas <> \Canvas\Gadget Or 
           \Type <> #PB_GadgetType_Button
          ProcedureReturn
        EndIf
        
        ; Get at point widget
        \Canvas\Mouse\From = From(*This)
        
        Select EventType 
          Case #PB_EventType_LeftButtonUp 
            If *Last = *This
              If *Widget <> *Focus
                ProcedureReturn 0 
              EndIf
            EndIf
            
          Case #PB_EventType_LeftClick 
            ; Debug ""+\Canvas\Mouse\Buttons+" Last - "+*Last +" Widget - "+*Widget +" Focus - "+*Focus +" This - "+*This
            If *Last = *This : *Last = *Widget
              If *Widget <> *Focus
                ProcedureReturn 0 
              EndIf
            EndIf
            
            If Not *This\Canvas\Mouse\From 
              ProcedureReturn 0
            EndIf
        EndSelect
        
        If Not \Hide And Not \Disable And \Interact And Widget <> Canvas And CanvasModifiers 
          Select EventType 
            Case #PB_EventType_Focus : ProcedureReturn 0 ; Bug in mac os because it is sent after the mouse left down
            Case #PB_EventType_MouseMove, #PB_EventType_LeftButtonUp
              If Not \Canvas\Mouse\Buttons 
                If \Canvas\Mouse\From
                  If *Last <> *This 
                    If *Last
                      If (*Last\Index > *This\Index)
                        ProcedureReturn 0
                      Else
                        ; Если с нижнего виджета перешли на верхный, 
                        ; то посылаем событие выход для нижнего
                        Events(*Last, #PB_EventType_MouseLeave, Canvas, 0)
                        *Last = *This
                      EndIf
                    Else
                      *Last = *This
                    EndIf
                    
                    EventType = #PB_EventType_MouseEnter
                    *Widget = *Last
                  EndIf
                  
                ElseIf (*Last = *This)
                  If EventType = #PB_EventType_LeftButtonUp 
                    Events(*Widget, #PB_EventType_LeftButtonUp, Canvas, 0)
                  EndIf
                  
                  EventType = #PB_EventType_MouseLeave
                  *Last = *Widget
                  *Widget = 0
                EndIf
              EndIf
              
            Case #PB_EventType_LeftButtonDown
              If (*Last = *This)
                PushListPosition(List())
                ForEach List()
                  If List()\Widget\Focus = List()\Widget And List()\Widget <> *This 
                    
                    List()\Widget\Focus = 0
                    *Last = List()\Widget
                    Events(List()\Widget, #PB_EventType_LostFocus, List()\Widget\Canvas\Gadget, 0)
                    *Last = *Widget 
                    
                    PostEvent(#PB_Event_Gadget, List()\Widget\Canvas\Window, List()\Widget\Canvas\Gadget, #PB_EventType_Repaint)
                    Break 
                  EndIf
                Next
                PopListPosition(List())
                
                If *This <> \Focus : \Focus = *This : *Focus = *This
                  Events(*This, #PB_EventType_Focus, Canvas, 0)
                EndIf
              EndIf
              
          EndSelect
        EndIf
        
        If (*Last = *This) 
          Select EventType
            Case #PB_EventType_MouseLeave
              If CanvasModifiers 
                ; Если перешли на другой виджет
                PushListPosition(List())
                ForEach List()
                  If List()\Widget\Canvas\Gadget = Canvas And List()\Widget\Focus <> List()\Widget And List()\Widget <> *This
                    List()\Widget\Canvas\Mouse\From = From(List()\Widget)
                    
                    If List()\Widget\Canvas\Mouse\From
                      If *Last
                        Events(*Last, #PB_EventType_MouseLeave, Canvas, 0)
                      EndIf     
                      
                      *Last = List()\Widget
                      *Widget = List()\Widget
                      ProcedureReturn Events(*Last, #PB_EventType_MouseEnter, Canvas, 0)
                    EndIf
                  EndIf
                Next
                PopListPosition(List())
              EndIf
              
              If \Cursor[1] <> GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
                SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor[1])
                \Cursor[1] = 0
              EndIf
              
            Case #PB_EventType_MouseEnter    
              If Not \Cursor[1] 
                \Cursor[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
              EndIf
              SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor)
              
          EndSelect
        EndIf 
        
      EndWith
    EndIf
    
    ;     If (*Last = *This)
    ;       Select EventType
    ;         Case #PB_EventType_Focus          : Debug "  "+Bool((*Last = *This))+" Focus"          +" "+ *This\Text\String.s
    ;         Case #PB_EventType_LostFocus      : Debug "  "+Bool((*Last = *This))+" LostFocus"      +" "+ *This\Text\String.s
    ;         Case #PB_EventType_MouseEnter     : Debug "  "+Bool((*Last = *This))+" MouseEnter"     +" "+ *This\Text\String.s ;+" Last - "+*Last +" Widget - "+*Widget +" Focus - "+*Focus +" This - "+*This
    ;         Case #PB_EventType_MouseLeave     : Debug "  "+Bool((*Last = *This))+" MouseLeave"     +" "+ *This\Text\String.s
    ;         Case #PB_EventType_LeftButtonDown : Debug "  "+Bool((*Last = *This))+" LeftButtonDown" +" "+ *This\Text\String.s ;+" Last - "+*Last +" Widget - "+*Widget +" Focus - "+*Focus +" This - "+*This
    ;         Case #PB_EventType_LeftButtonUp   : Debug "  "+Bool((*Last = *This))+" LeftButtonUp"   +" "+ *This\Text\String.s
    ;         Case #PB_EventType_LeftClick      : Debug "  "+Bool((*Last = *This))+" LeftClick"      +" "+ *This\Text\String.s
    ;       EndSelect
    ;     EndIf
    
    If (*Last = *This) ;And ListSize(*This\items())
      With *This       ;\items()
        Select EventType
          Case #PB_EventType_MouseEnter    
            \Buttons = \Canvas\Mouse\From
            If Not \Checked : Buttons = \Buttons : EndIf
            
          Case #PB_EventType_LeftButtonDown : Drag = 1 : LastX = \Canvas\Mouse\X : LastY = \Canvas\Mouse\Y
            If \Buttons
              Buttons = \Buttons
              If \Toggle 
                \Checked[1] = \Checked
                \Checked ! 1
              EndIf
            EndIf
            
          Case #PB_EventType_LeftButtonUp : Drag = 0
            If \Toggle 
              If Not \Checked And Not CanvasModifiers
                Buttons = \Buttons
              EndIf
            Else
              Buttons = \Buttons
            EndIf
            ;Debug "LeftButtonUp"
            
          Case #PB_EventType_LeftClick ; Bug in mac os afte move mouse dont post event click
                                       ;Debug "LeftClick"
            PostEvent(#PB_Event_Widget, \Canvas\Window, Widget, #PB_EventType_LeftClick)
            
          Case #PB_EventType_MouseLeave
            If \Drag 
              \Checked = \Checked[1]
            EndIf
            
          Case #PB_EventType_MouseMove
            If Drag And \Drag=0 And (Abs((\Canvas\Mouse\X-LastX)+(\Canvas\Mouse\Y-LastY)) >= 6) : \Drag=1 : EndIf
            
        EndSelect
        
        Select EventType
          Case #PB_EventType_MouseEnter, #PB_EventType_LeftButtonUp, #PB_EventType_LeftButtonDown
            If Buttons 
              Buttons = 0
              \Color[Buttons]\Fore = \Color[Buttons]\Fore[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
              \Color[Buttons]\Back = \Color[Buttons]\Back[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
              \Color[Buttons]\Frame = \Color[Buttons]\Frame[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
              \Color[Buttons]\Line = \Color[Buttons]\Line[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
              Repaint = #True
            EndIf
            
          Case #PB_EventType_MouseLeave
            If Not \Checked
              ResetColor(*This)
            EndIf
            
            Repaint = #True
        EndSelect 
        
        Select EventType
          Case #PB_EventType_Focus : Repaint = #True
          Case #PB_EventType_LostFocus : Repaint = #True
        EndSelect
        
        
        
      EndWith
    EndIf
    
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0, Image.i=-1)
    If *This
      With *This
        \Type = #PB_GadgetType_Button
        \Cursor = #PB_Cursor_Default
        \DrawingMode = #PB_2DDrawing_Gradient
        \Canvas\Gadget = Canvas
        \Radius = Radius
        \Text\Rotate = 270 ; 90;
        \Alpha = 255
        \Interact = 1
        
        ; Set the default widget flag
        Flag|#PB_Text_ReadOnly
        
        If Bool(Flag&#PB_Text_Left)
          Flag&~#PB_Text_Center
        Else
          Flag|#PB_Text_Center
        EndIf
        
        If Bool(Flag&#PB_Text_Top)
          Flag&~#PB_Text_Middle
        Else
          Flag|#PB_Text_Middle
        EndIf
        
        If Bool(Flag&#PB_Text_WordWrap)
          Flag&~#PB_Text_MultiLine
        EndIf
        
        If Bool(Flag&#PB_Text_MultiLine)
          Flag&~#PB_Text_WordWrap
        EndIf
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fSize = Bool(Not Flag&#PB_Widget_BorderLess)
        \bSize = \fSize
        
        If IsImage(Image)
          \Image\handle[1] = Image
          \Image\handle = ImageID(Image)
          \Image\width = ImageWidth(Image)
          \Image\height = ImageHeight(Image)
        EndIf
        
        If Resize(*This, X,Y,Width,Height, Canvas)
          \Default = Bool(Flag&#PB_Widget_Default)
          \Toggle = Bool(Flag&#PB_Widget_Toggle)
          
          \Text\Vertical = Bool(Flag&#PB_Text_Vertical)
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          \Text\WordWrap = Bool(Flag&#PB_Text_WordWrap)
          \Text\MultiLine = Bool(Flag&#PB_Text_MultiLine)
          
          \Text\Align\Horisontal = Bool(Flag&#PB_Text_Center)
          \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          \Text\Align\Right = Bool(Flag&#PB_Text_Right)
          \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+10
            Else
              \Text\X = \fSize+10
              \Text\y = \fSize
            EndIf
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+2
            Else
              \Text\X = \fSize+2
              \Text\y = \fSize
            EndIf
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+6
            Else
              \Text\X = \fSize+6
              \Text\y = \fSize
            EndIf
          CompilerEndIf 
          
          
          \Text\String.s = Text.s
          \Text\Change = #True
          
          \Color[0]\Fore[1] = $F6F6F6 
          \Color[0]\Back[1] = $E2E2E2  
          \Color[0]\Frame[1] = $BABABA 
          
          ; Цвет если мышь на виджете
          \Color[0]\Fore[2] = $EAEAEA
          \Color[0]\Back[2] = $CECECE
          \Color[0]\Frame[2] = $8F8F8F
          
          ; Цвет если нажали на виджет
          \Color[0]\Fore[3] = $E2E2E2
          \Color[0]\Back[3] = $B4B4B4
          \Color[0]\Frame[3] = $6F6F6F
          
          ; Устанавливаем цвет по умолчанию первый
          ResetColor(*This)
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Image.i=-1, Flag.i=0, Radius.i=0)
    Protected *Widget, *This.Widget_S = AllocateStructure(Widget_S)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius, Image)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
EndModule

;-
CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  UseModule Button
  Global *B_0, *B_1, *B_2, *B_3, *B_4, *B_5
  
  Global *Button_0.Widget_S = AllocateStructure(Widget_S)
  Global *Button_1.Widget_S = AllocateStructure(Widget_S)
  
  UsePNGImageDecoder()
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  If Not LoadImage(10, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
    End
  EndIf
  
  Procedure CallBacks()
    Protected Result
    Protected Canvas = EventGadget()
    Protected Window = EventWindow()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Select EventType()
      Case #PB_EventType_Resize
        Resize(*Button_0, Width-70, #PB_Ignore, #PB_Ignore, Height-20)
        Resize(*Button_1, #PB_Ignore, #PB_Ignore, Width-90, #PB_Ignore)
        
        Result = 1
      Default
        ;         ; First window
        ;         Result | CallBack(*B_0, EventType()) 
        ;         Result | CallBack(*B_1, EventType()) 
        ;         Result | CallBack(*B_2, EventType()) 
        ;         Result | CallBack(*B_3, EventType()) 
        ;         Result | CallBack(*B_4, EventType()) 
        ;         
        ;         ; Second window
        ;         Result | CallBack(*Button_0, EventType()) 
        ;         Result | CallBack(*Button_1, EventType()) 
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(EventGadget())
        EndIf
        
        ForEach List()
          ; If List()\Widget\Canvas\Gadget = GetActiveGadget()
          Result | CallBack(List()\Widget, EventType()) 
          ; EndIf
        Next
        
    EndSelect
    
    If Result Or EventType() = #PB_EventType_Repaint
      If StartDrawing(CanvasOutput(Canvas))
        Box(0,0,Width,Height, $F0F0F0)
        
        ForEach List()
          Draw(List()\Widget)
        Next
        
        StopDrawing()
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure Events()
    Debug "window "+EventWindow()+" widget "+EventGadget()+" eventtype "+EventType()+" eventdata "+EventData()
  EndProcedure
  
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 18)
  ;  SetGadgetFont(#PB_Default, FontID(LoadFont(#PB_Any, "", 12)))
  CompilerElse
    LoadFont(0, "Arial", 16)
   ; SetGadgetFont(#PB_Default, FontID(LoadFont(#PB_Any, "", 9)))
  CompilerEndIf 
  
  If OpenWindow(0, 0, 0, 222+222, 205, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    ButtonGadget(0, 10, 10, 200, 20, "Standard Button")
    ButtonGadget(1, 10, 40, 200, 20, "Left Button", #PB_Button_Left)
    ButtonGadget(2, 10, 70, 200, 20, "Right Button", #PB_Button_Right)
    ButtonGadget(3, 10,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)", #PB_Button_MultiLine|#PB_Button_Default)
    ButtonGadget(5, 10,170, 200, 25, "Toggle Button", #PB_Button_Toggle)
    
    CanvasGadget(10,  222, 0, 222, 205+70, #PB_Canvas_Keyboard)
    BindGadgetEvent(10, @CallBacks())
    
    *B_0 = Create(10, -1, 10, 10, 200, 20, "Standard Button", 0,8)
    *B_1 = Create(10, -1, 10, 40, 200, 20, "Left Button", #PB_Text_Left)
    *B_2 = Create(10, -1, 10, 70, 200, 20, "Right Button", #PB_Text_Right)
    *B_3 = Create(10, -1, 10,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)", #PB_Text_WordWrap|#PB_Widget_Default, 4)
    *B_4 = Create(10, -1, 10,170, 200, 25, "Toggle Button", #PB_Widget_Toggle,0, 10)
    
     ;SetFont(*B_3, FontID(1))
    
    BindEvent(#PB_Event_Widget, @Events())
    PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
  EndIf
  
  
  Procedure ResizeCallBack()
    ResizeGadget(11, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate), WindowHeight(EventWindow(), #PB_Window_InnerCoordinate))
  EndProcedure
  
  If OpenWindow(11, 0, 0, 150, 515, "ImageButton", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      WindowBounds(11,150,515,#PB_Ignore,515)
      
      CanvasGadget(11,  0, 0, 150, 515, #PB_Canvas_Keyboard)
      BindGadgetEvent(11, @CallBacks())
      
      Create(11,#PB_Any, 10,10,130,25,"image_left",10, #PB_Text_Left)
      Create(11,#PB_Any, 10,40,130,25,"image_right",10,#PB_Text_Right)
      Create(11,#PB_Any, 10,70,130,75,"image_top",10,#PB_Text_Top);,32,32)
      Create(11,#PB_Any, 10,150,130,75,"image_bottom",10,#PB_Text_Bottom);,32,32)
      
      ;Create(11,#PB_Any, 10,230,130,75,"",10)
      
      Create(11,#PB_Any, 10,310,130,35,"text_center",0)
      Create(11,#PB_Any, 10,350,130,35,"text_left",0,#PB_Text_Left)
      Create(11,#PB_Any, 10,390,130,35,"text_right",0,#PB_Text_Right)
      Create(11,#PB_Any, 10,430,130,35,"text_top",0,#PB_Text_Top)
      Create(11,#PB_Any, 10,470,130,35,"text_bottom",0,#PB_Text_Bottom)
      
      
    ResizeWindow(11, #PB_Ignore, WindowY(0)+WindowHeight(0, #PB_Window_FrameCoordinate)+10, #PB_Ignore, #PB_Ignore)
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 11)
    PostEvent(#PB_Event_SizeWindow, 11, #PB_Ignore)
    
    BindGadgetEvent(g, @CallBacks())
    PostEvent(#PB_Event_Gadget, 11,11, #PB_EventType_Resize)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf

; IDE Options = PureBasic 5.62 (MacOS X - x64)
; CursorPosition = 435
; FirstLine = 427
; Folding = ------------
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ---v-f--7------------
; EnableXP
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ---0------------------
; EnableXP