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
  Macro Parent(_adress_, _canvas_) : Bool(_adress_\Canvas\Gadget = _canvas_) : EndMacro
  ;   Macro Draw(_adress_, _canvas_=-1) : Text::Draw(_adress_, _canvas_) : EndMacro
  
  Macro GetText(_adress_) : Text::GetText(_adress_) : EndMacro
  Macro SetText(_adress_, _text_) : Text::SetText(_adress_, _text_) : EndMacro
  Macro SetFont(_adress_, _font_id_) : Text::SetFont(_adress_, _font_id_) : EndMacro
  Macro GetColor(_adress_, _color_type_, _state_=0) : Text::GetColor(_adress_, _color_type_, _state_) : EndMacro
  Macro SetColor(_adress_, _color_type_, _color_, _state_=1) : Text::SetColor(_adress_, _color_type_, _color_, _state_) : EndMacro
  Macro Resize(_adress_, _x_,_y_,_width_,_height_, _canvas_=-1) : Text::Resize(_adress_, _x_,_y_,_width_,_height_, _canvas_) : EndMacro
  
  Macro From(_this_, _buttons_=0)
    Bool(_this_\Canvas\Mouse\X>=_this_\x[_buttons_] And _this_\Canvas\Mouse\X<_this_\x[_buttons_]+_this_\Width[_buttons_] And 
         _this_\Canvas\Mouse\Y>=_this_\y[_buttons_] And _this_\Canvas\Mouse\Y<_this_\y[_buttons_]+_this_\Height[_buttons_])
  EndMacro
  
  ;- - DECLAREs PRACEDUREs
  Declare.i Draw(*This.Widget, Canvas.i=-1)
  
  Declare.i GetState(*This.Widget)
  Declare.i SetState(*This.Widget, Value.i)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0, Image.i=-1)
  Declare.i CallBack(*This.Widget, Canvas.i, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0)
  Declare.i Widget(*This.Widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0, Image.i=-1)
  
EndDeclareModule

Module Button
  ;-
  ;- - MACROS
  ;- - PROCEDUREs
  Procedure.i Draw(*This.Widget, Canvas.i=-1)
    ProcedureReturn Text::Draw(*This, Canvas)
    
  EndProcedure
  
  Procedure.i GetState(*This.Widget)
    ProcedureReturn *This\Toggle
  EndProcedure
  
  Procedure.i SetState(*This.Widget, Value.i)
    Protected Result
    
    If *This\Toggle <> Bool(Value)
      *This\Toggle = Bool(Value)
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Events(*This.Widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Static Text$, DoubleClickCaret =- 1
    Protected Repaint, StartDrawing, Update_Text_Selected
    
    Protected Buttons, Widget.i
    Static *Focus.Widget, *Last.Widget, *Widget.Widget, LastX, LastY, Last, Drag
    
    
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
        
        If Not \Hide And Not \Disable And \Interact And Not \Canvas\Mouse\Buttons
          If EventType = #PB_EventType_LeftClick
            If Not *This\Canvas\Mouse\From
              If *Last = *This 
                *Last = 0
              EndIf
              ProcedureReturn 0
            EndIf
          Else
            If EventType <> #PB_EventType_MouseLeave And EventType <> #PB_EventType_MouseEnter
              If \Canvas\Mouse\From
                If EventType = #PB_EventType_MouseMove
                  
                  If *Last <> *This And CanvasModifiers=-1  
                    If *Last
                      If (*Last\Index > *This\Index)
                        ProcedureReturn 
                      Else
                        ; Если с нижнего виджета перешли на верхный, 
                        ; то посылаем событие выход для нижнего
                        *Widget = *Last
                        If *Widget And \Cursor[1] <> GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
                          SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor[1])
                        EndIf
                        Events(*Widget, #PB_EventType_MouseLeave, Canvas, 0)
                        *Last = *This
                      EndIf
                    Else
                      *Last = *This
                    EndIf
                    
                    EventType = #PB_EventType_MouseEnter
                    *Widget = *Last
                  EndIf
                EndIf
              ElseIf *Last = *This And CanvasModifiers=-1
                If EventType = #PB_EventType_LeftButtonUp 
                  Events(*Widget, #PB_EventType_LeftButtonUp, Canvas, 0)
                EndIf
                
                EventType = #PB_EventType_MouseLeave
                *Last = *Widget
                *Widget = 0
              EndIf
            EndIf
          EndIf
        EndIf
        
        
        ; 
        If *Last = *This And Widget <> Canvas And CanvasModifiers
          Select EventType 
            Case #PB_EventType_Focus : ProcedureReturn 0 ; Bug in mac os because it is sent after the mouse left down
            Case #PB_EventType_MouseLeave
              PushListPosition(List())
              ForEach List()
                If *This <> List()\Widget And List()\Widget <> List()\Widget\Focus And From(List()\Widget)
                  If *Last : Events(*Last, #PB_EventType_MouseLeave, Canvas, 0) : EndIf : *Last = List()\Widget 
                  Events(List()\Widget, #PB_EventType_MouseEnter, Canvas, 0) : *Widget = List()\Widget
                  Break
                EndIf
              Next
              PopListPosition(List())
              
            Case #PB_EventType_LeftButtonDown
              PushListPosition(List())
              ForEach List()
                If *This <> List()\Widget And List()\Widget = List()\Widget\Focus 
                  List()\Widget\Focus = 0 
                  *Last = List()\Widget 
                  Events(List()\Widget, #PB_EventType_LostFocus, Canvas, 0) 
                  *Last = *Widget 
                EndIf
              Next
              PopListPosition(List())
              
              If *This <> \Focus : \Focus = *This : *Focus = *This
                Events(*This, #PB_EventType_Focus, Canvas, 0)
              EndIf
          EndSelect
        EndIf
      EndWith
      
    EndIf
  
  
    If (*Last = *This)
      Select EventType
        Case #PB_EventType_Focus          : Debug "  "+Bool((*Last = *This))+" Focus"          +" "+ *This\Text\String.s
        Case #PB_EventType_LostFocus      : Debug "  "+Bool((*Last = *This))+" LostFocus"      +" "+ *This\Text\String.s
        Case #PB_EventType_MouseEnter     : Debug "  "+Bool((*Last = *This))+" MouseEnter"     +" "+ *This\Text\String.s
        Case #PB_EventType_MouseLeave     : Debug "  "+Bool((*Last = *This))+" MouseLeave"     +" "+ *This\Text\String.s
        Case #PB_EventType_LeftButtonDown : Debug "  "+Bool((*Last = *This))+" LeftButtonDown" +" "+ *This\Text\String.s ;+" Last - "+*Last +" Widget - "+*Widget +" Focus - "+*Focus +" This - "+*This
        Case #PB_EventType_LeftButtonUp   : Debug "  "+Bool((*Last = *This))+" LeftButtonUp"   +" "+ *This\Text\String.s
        Case #PB_EventType_LeftClick      : Debug "  "+Bool((*Last = *This))+" LeftClick"      +" "+ *This\Text\String.s
      EndSelect
    EndIf
    
    
    
    If (*Last = *This) ;Or (*Widget = *This) ;And ListSize(*This\items())
      With *This       ;\items()
        Select EventType
          Case #PB_EventType_MouseEnter    
            \Buttons = \Canvas\Mouse\From
            If Not \Checked : Buttons = \Buttons : EndIf
            If Not \Cursor[1] 
              \Cursor[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
            EndIf
            SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor)
            
          Case #PB_EventType_MouseLeave     
            If \Cursor[1] <> GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
              SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor[1])
              \Cursor[1] = 0
            EndIf
            
        EndSelect
    
        Select EventType
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
  
  
  Procedure canvas_events_bug_fix(*This.Widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Protected Result.b
    Static MouseLeave.b, LeftClick.b
    Protected EventGadget.i = EventGadget()
    
    If Canvas =- 1
      With *This
        Select EventType
          Case #PB_EventType_Input 
            \Canvas\Input = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Input)
          Case #PB_EventType_KeyDown
            \Canvas\Key = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Key)
            \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
            \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
            \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
               #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
               #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
            \Canvas\Mouse\Buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
        EndSelect
      EndWith
    EndIf
      
    ; Это из за ошибки в мак ос
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons)
        If EventType = #PB_EventType_MouseLeave 
          EventType = #PB_EventType_MouseMove
          MouseLeave = 1
        EndIf
      EndIf
      
      If EventType = #PB_EventType_LeftButtonUp
        If MouseLeave
          Result | Events(*This, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
          EventType = #PB_EventType_MouseLeave
          MouseLeave = 0
        Else
          Result | Events(*This, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
          EventType = #PB_EventType_LeftClick
          LeftClick = 1
        EndIf
      EndIf
      
      ; Родное убираем оставляем искуственное
      If EventType = #PB_EventType_LeftClick
        If LeftClick 
          LeftClick = 0 
        Else
          ProcedureReturn 0
        EndIf
      EndIf
      
      If EventType = #PB_EventType_LeftButtonDown
        If GetActiveGadget()<>EventGadget
          SetActiveGadget(EventGadget)
        EndIf
      EndIf
    CompilerEndIf
    
    Result | Events(*This, EventType, Canvas, CanvasModifiers)
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i CallBack(*This.Widget, Canvas.i, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0)
    ProcedureReturn canvas_events_bug_fix(*This, EventType, Canvas)
    
    Protected Result, Buttons, Widget.i
    Static *Last.Widget, *Widget.Widget, LastX, LastY, Last, Drag
    
    If Canvas=-1 
      Widget = *This
      Canvas = EventGadget()
    Else
      Widget = Canvas
    EndIf
    If Canvas <> *This\Canvas\Gadget
      ProcedureReturn
    EndIf
    
    If EventType = #PB_EventType_LeftClick
      ;     EventType =- 1 ; #PB_EventType_LeftButtonUp
    EndIf
    
    If *This\Type = #PB_GadgetType_Button
      With *This
        \Canvas\Mouse\X = MouseX
        \Canvas\Mouse\Y = MouseY
        
        If Not \Hide And Not Drag And \Interact
          If EventType <> #PB_EventType_MouseLeave And 
             (Mousex>=\x And Mousex<\x+\Width And Mousey>\y And Mousey=<\y+\Height) 
            
            If *Last <> *This  
              
              If *Last
                If *Last > *This
                  ProcedureReturn
                Else
                  *Widget = *Last
                  CallBack(*Widget, #PB_EventType_MouseLeave, 0, 0, 0)
                  *Last = *This
                EndIf
              Else
                *Last = *This
              EndIf
              
              \Buttons = 1
              If Not \Checked
                Buttons = \Buttons
              EndIf
              EventType = #PB_EventType_MouseEnter
              \Cursor[1] = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
              SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \Cursor)
              *Widget = *Last
              ; Debug "enter "+*Last\text\string+" "+EventType
            EndIf
            
          ElseIf *Last = *This
            ; Debug "leave "+*Last\text\string+" "+EventType+" "+*Widget
            If \Cursor[1] <> GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
              SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \Cursor[1])
              \Cursor[1] = 0
            EndIf
            EventType = #PB_EventType_MouseLeave
            *Last = 0
          EndIf
          
        ElseIf *Widget = *This
          If EventType = #PB_EventType_LeftButtonUp And *Last = *Widget And (MouseX<>#PB_Ignore And MouseY<>#PB_Ignore) 
            If Not (Mousex>=\x And Mousex<\x+\Width And Mousey>\y And Mousey=<\y+\Height) 
              CallBack(*Widget, Canvas, #PB_EventType_LeftButtonUp, #PB_Ignore, #PB_Ignore)
              EventType = #PB_EventType_MouseLeave
            Else
              CallBack(*Widget, Canvas, #PB_EventType_LeftButtonUp, #PB_Ignore, #PB_Ignore)
              EventType = #PB_EventType_LeftClick
            EndIf
            
            *Last = 0  
          EndIf
          
        EndIf
      EndWith
      
      
      If *Widget = *This
        
        ; Если канвас как родитель
        If Widget <> Canvas
          ; Будем сбрасывать все остальные виджети
          With List()\Widget
            If EventType = #PB_EventType_LeftButtonDown
              PushListPosition(List())
              ForEach List()
                If *Widget <> List()\Widget
                  \Focus = 0
                  \Items()\Text[2]\Len = 0
                EndIf
              Next
              PopListPosition(List())
            EndIf
          EndWith
        EndIf
        
        With *Widget
          If Not \Hide
            Select EventType
              Case #PB_EventType_LeftButtonDown : Drag = 1 : LastX = MouseX : LastY = MouseY
                *Widget\Focus = *Widget
                *Widget\Canvas\Mouse\Buttons = #PB_Canvas_LeftButton
                
                If \Buttons
                  Buttons = \Buttons
                  If \Toggle 
                    \Checked[1] = \Checked
                    \Checked ! 1
                  EndIf
                EndIf
                
              Case #PB_EventType_LeftButtonUp : Drag = 0
                *Widget\Canvas\Mouse\Buttons = 0
                
                If \Toggle 
                  If Not \Checked And Not (MouseX=#PB_Ignore And MouseY=#PB_Ignore)
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
                If Drag And \Drag=0 And (Abs((MouseX-LastX)+(MouseY-LastY)) >= 6) : \Drag=1 : EndIf
                
            EndSelect
            
            Select EventType
              Case #PB_EventType_MouseEnter, #PB_EventType_LeftButtonUp, #PB_EventType_LeftButtonDown
                If Buttons 
                  Buttons = 0
                  \Color[Buttons]\Fore = \Color[Buttons]\Fore[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
                  \Color[Buttons]\Back = \Color[Buttons]\Back[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
                  \Color[Buttons]\Frame = \Color[Buttons]\Frame[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
                  \Color[Buttons]\Line = \Color[Buttons]\Line[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
                  Result = #True
                EndIf
                
              Case #PB_EventType_MouseLeave
                If Not \Checked
                  ResetColor(*Widget)
                EndIf
                *Widget = 0
                
                Result = #True
            EndSelect 
            
            Select EventType
              Case #PB_EventType_Focus
                \Focus = *Widget
                Result = #True
                
              Case #PB_EventType_LostFocus
                \Focus = 0
                Result = #True
            EndSelect
          EndIf
        EndWith
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure Widget(*This.Widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0, Image.i=-1)
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
          
          If \Text\Vertical
            \Text\X = \fSize 
            \Text\y = \fSize+12 ; 2,6,1
          Else
            \Text\X = \fSize+12 ; 2,6,12 
            \Text\y = \fSize
          EndIf
          
          
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
  
  Procedure Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0, Image.i=-1)
    Protected *Widget, *This.Widget=AllocateStructure(Widget)
    
    If *This
      
      ;{ Генерируем идентификатор
      If Widget =- 1 Or Widget > ListSize(List()) - 1
        LastElement(List())
        AddElement(List()) 
        Widget = ListIndex(List())
        *Widget = @List()
      Else
        SelectElement(List(), Widget)
        *Widget = @List()
        InsertElement(List())
        
        PushListPosition(List())
        While NextElement(List())
          List()\Widget\Index = ListIndex(List())
        Wend
        PopListPosition(List())
      EndIf
      ;}
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius, Image)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
EndModule

;-
CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  UseModule Button
  Global *B_0.Widget = AllocateStructure(Widget)
  Global *B_1.Widget = AllocateStructure(Widget)
  Global *B_2.Widget = AllocateStructure(Widget)
  Global *B_3.Widget = AllocateStructure(Widget)
  Global *B_4.Widget = AllocateStructure(Widget)
  
  Global *Button_0.Widget = AllocateStructure(Widget)
  Global *Button_1.Widget = AllocateStructure(Widget)
  
  UsePNGImageDecoder()
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
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
        Resize(*Button_1, #PB_Ignore, #PB_Ignore, Width-50, #PB_Ignore)
        
        Result = 1
      Default
        ; First window
        Result | CallBack(*B_0, -1, EventType(), MouseX, MouseY) 
        Result | CallBack(*B_1, -1, EventType(), MouseX, MouseY) 
        Result | CallBack(*B_2, -1, EventType(), MouseX, MouseY) 
        Result | CallBack(*B_3, -1, EventType(), MouseX, MouseY) 
        Result | CallBack(*B_4, -1, EventType(), MouseX, MouseY) 
        
        ; Second window
        Result | CallBack(*Button_0, -1, EventType(), MouseX, MouseY) 
        Result | CallBack(*Button_1, -1, EventType(), MouseX, MouseY) 
        
    EndSelect
    
    If Result
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
  
  LoadFont(0, "Arial", 18)
  
  If OpenWindow(0, 0, 0, 222+222, 200, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ButtonGadget(0, 10, 10, 200, 20, "Standard Button")
    ButtonGadget(1, 10, 40, 200, 20, "Left Button", #PB_Button_Left)
    ButtonGadget(2, 10, 70, 200, 20, "Right Button", #PB_Button_Right)
    ButtonGadget(3, 10,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)", #PB_Button_MultiLine|#PB_Button_Default)
    ButtonGadget(4, 10,170, 200, 20, "Toggle Button", #PB_Button_Toggle)
    
    CanvasGadget(10,  222, 0, 222, 200, #PB_Canvas_Keyboard)
    BindGadgetEvent(10, @CallBacks())
    
    *B_0 = Create(10, -1, 10, 10, 200, 20, "Standard Button", 0,8)
    *B_1 = Create(10, -1, 10, 40, 200, 20, "Left Button", #PB_Text_Left)
    *B_2 = Create(10, -1, 10, 70, 200, 20, "Right Button", #PB_Text_Right)
    *B_3 = Create(10, -1, 10,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)", #PB_Text_MultiLine|#PB_Widget_Default, 4)
    *B_4 = Create(10, -1, 10,170, 200, 20, "Toggle Button", #PB_Widget_Toggle)
    
    BindEvent(#PB_Event_Widget, @Events())
    PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
  EndIf
  
  
  Procedure ResizeCallBack()
    ResizeGadget(11, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
  EndProcedure
  
  If OpenWindow(11, 0, 0, 325+80, 160, "Button on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    g=11
    CanvasGadget(g,  10,10,305,140, #PB_Canvas_Keyboard)
    SetGadgetAttribute(g, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    
    With *Button_0
      *Button_0 = Create(g, -1, 270, 10,  60, 120, "Button (Vertical)", #PB_Text_MultiLine | #PB_Text_Vertical)
      ;       SetColor(*Button_0, #PB_Gadget_BackColor, $CCBFB4)
      SetColor(*Button_0, #PB_Gadget_FrontColor, $D56F1A)
      SetFont(*Button_0, FontID(0))
    EndWith
    
    With *Button_1
      ResizeImage(0, 32,32)
      *Button_1 = Create(g, -1, 10, 42, 250,  60, "Button (Horisontal)", #PB_Text_MultiLine,0,0)
      ;       SetColor(*Button_1, #PB_Gadget_BackColor, $D58119)
      \Cursor = #PB_Cursor_Hand
        SetColor(*Button_1, #PB_Gadget_FrontColor, $4919D5)
      SetFont(*Button_1, FontID(0))
    EndWith
    
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
; Folding = --f7---X-------------
; EnableXP