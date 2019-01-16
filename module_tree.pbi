CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  ;  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
  ;  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
  ;  IncludePath "/Users/a/Documents/GitHub/Widget/"
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_draw.pbi"
  
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_bar.pbi"
  XIncludeFile "module_text.pbi"
  XIncludeFile "module_editor.pbi"
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
CompilerEndIf

DeclareModule Tree
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  ;- - DECLAREs MACROs
  Macro GetText(_this_) : Text::GetText(_this_) : EndMacro
  Macro CountItems(_this_) : Editor::CountItems(_this_) : EndMacro
  Macro ClearItems(_this_) : Editor::ClearItems(_this_) : EndMacro
  Macro SetText(_this_, _text_) : Editor::SetText(_this_,_text_,0) : EndMacro
  Macro RemoveItem(_this_, _item_) : Editor::RemoveItem(_this_, _item_) : EndMacro
  Macro SetFont(_this_, _font_id_) : Editor::SetFont(_this_, _font_id_) : EndMacro
  Macro Resize(_adress_, _x_,_y_,_width_,_height_) : Text::Resize(_adress_, _x_,_y_,_width_,_height_) : EndMacro
  Macro AddItem(_this_, _item_,_text_,_image_=-1,_flag_=0) : Text::AddItem(_this_,_item_,_text_,_image_,_flag_) : EndMacro
  
  ;- DECLAREs PROCEDUREs
  Declare.i GetState(*This.Widget_S)
  Declare.i SetState(*This.Widget_S, State.i)
  ; Declare.i GetItemState(*This.Widget_S, Item.i)
  Declare.i SetItemState(*This.Widget_S, Item.i, State.i)
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
EndDeclareModule

Module Tree
  ;-
  ;- PROCEDUREs
  ;-
  Procedure ToolTip(*This.Text_S=0, ColorFont=0, ColorBack=0, ColorFrame=$FF)
    Protected Gadget
    Static Window
    Protected Color.Color_S = Colors
    With *This
      If *This
        ; Debug "show tooltip "+\string
        ;         If Not Window
        Window = OpenWindow(#PB_Any, \x[1]-3,\y[1],\width+8,\height[1], "", #PB_Window_BorderLess|#PB_Window_NoActivate|(Bool(#PB_Compiler_OS<>#PB_OS_Windows)*#PB_Window_Tool), WindowID(EventWindow())) ;|#PB_Window_NoGadgets
        Gadget = CanvasGadget(#PB_Any,0,0,\width+8,\height[1])
        If StartDrawing(CanvasOutput(Gadget))
          If \FontID : DrawingFont(\FontID) : EndIf 
          DrawingMode(#PB_2DDrawing_Default)
          Box(1,1,\width-2+8,\height[1]-2, Color\Back[1])
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawText(3, (\height[1]-\height)/2, \String, Color\Front[1])
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(0,0,\width+8,\height[1], Color\Frame[1])
          StopDrawing()
        EndIf
        
        ; ;         Window = OpenWindow(#PB_Any, \x[1]-3,\y[1],\width+8,\height[1], "", #PB_Window_BorderLess|#PB_Window_NoActivate|#PB_Window_Tool) ;|#PB_Window_NoGadgets
        ; ;         SetGadgetColor(ContainerGadget(#PB_Any,1,1,\width-2+8,\height[1]-2), #PB_Gadget_BackColor, Color\Back[1])
        ; ;         Gadget = StringGadget(#PB_Any,0,(\height[1]-\height)/2-1,\width-2+8,\height[1]-2, \string, #PB_String_BorderLess)
        ; ;         SetGadgetColor(Gadget, #PB_Gadget_BackColor, Color\Back[1])
        ; ;         SetWindowColor(Window, Color\Frame[1])
        ; ;         SetGadgetFont(Gadget, \FontID)
        ; ;         CloseGadgetList()
        
        
        SetWindowData(Window, Gadget)
        ;         Else
        ;           ResizeWindow(Window, \x[1],\y[1],\width,\height[1])
        ;           SetGadgetText(GetWindowData(Window), \string)
        ;           HideWindow(Window, 0, #PB_Window_NoActivate)
        ;         EndIf
      ElseIf IsWindow(Window)
        ;         HideWindow(Window, 1, #PB_Window_NoActivate)
        CloseWindow(Window)
        ;  Debug "hide tooltip "
      EndIf
    EndWith              
  EndProcedure
  
  Procedure item_from(*This.Widget_S, MouseX=-1, MouseY=-1, focus=0)
    Protected adress.i
    Protected lostfocus.i=-1, collapsed.i, sublevel.i
    Protected Buttons
    
    With *This
      PushListPosition(\Items()) 
      ForEach \Items()
        If \Items()\Index[1] = \Items()\Index 
          \Items()\Index[1] =- 1
          adress = @\Items()
          Break
        EndIf
      Next
      
      ForEach \Items()
        If \Items()\Index = \Items()\focus
          If Bool(MouseX=-1 And MouseY=-1 And focus=1)
            \Items()\lostfocus = \Items()\focus
            *This\focus = 0
            
            ; then lost focus widget
            \Items()\Color\State = 0
            
          EndIf
          adress = @\Items()
          Break
        EndIf
      Next
      
      If Not Bool(MouseX=-1 And MouseY=-1)
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If (MouseY > (\Items()\Y) And MouseY =< ((\Items()\Y+\Items()\Height))) And 
             ((MouseX > \Items()\X) And (MouseX =< (\Items()\X+\Items()\Width)))
            
            If focus
              If (MouseY > (\Items()\box\y[1]) And MouseY =< ((\Items()\box\y[1]+\Items()\box\height[1]))) And 
                 ((MouseX > \Items()\box\x[1]) And (MouseX =< (\Items()\box\x[1]+\Items()\box\width[1])))
                
                \Items()\checked ! 1
                *This\Change = 1
              EndIf
              
              If (\flag\buttons And \Items()\childrens) And
                 (MouseY > (\Items()\box\y[0]) And MouseY =< ((\Items()\box\y[0]+\Items()\box\height[0]))) And 
                 ((MouseX > \Items()\box\x[0]) And (MouseX =< (\Items()\box\x[0]+\Items()\box\width[0])))
                
                sublevel = \Items()\sublevel
                \Items()\collapsed ! 1
                Protected Height = \Items()\Y+\Items()\Height, Y=Height
                
                PushListPosition(\Items())
                While NextElement(\Items())
                  If \Items()\sublevel > sublevel 
                    If \Items()\handle
                      PushListPosition(\Items())
                      ChangeCurrentElement(\Items(), \Items()\handle)
                      collapsed = \Items()\collapsed
                      collapsed | \Items()\hide
                      PopListPosition(\Items())
                    EndIf
                    \Items()\hide = collapsed
                    
                    If \Items()\hide
                      \Scroll\Height - \Items()\Height
                    Else
                      Height = \Items()\Y+\Items()\Height
                      If Not \Items()\Height
                        \Items()\Height = \Text\Height
                        \Items()\Text\Height = \Text\Height[1]
                      EndIf
                      \Items()\Y = Y
                      \Items()\Text\Y = \Items()\Y + (\Items()\Height-\Items()\Text\Height)/2
                      \Items()\Image\Y = \Items()\Y + (\Items()\Height-\Items()\Image\Height)/2
                      Y + \Items()\Height
                      \Scroll\Height + \Items()\Height
                    EndIf
                  Else
                    PushListPosition(\Items())
                    Repeat
                      If Not \Items()\hide
                        \Items()\Y = Height
                        \Items()\Text\Y = \Items()\Y + (\Items()\Height-\Items()\Text\Height)/2
                        \Items()\Image\Y = \Items()\Y + (\Items()\Height-\Items()\Image\Height)/2
                        Height + \Items()\Height
                      EndIf
                    Until Not NextElement(\Items())
                    PopListPosition(\Items())
                    \Scroll\Width = 0
                    \Scroll\Height = Height
                    PushListPosition(\Items())
                    ForEach \Items()
                      If Not \Items()\hide And \Scroll\Width<\Items()\Text\x+\Items()\Text\Width
                        \Scroll\Width=\Items()\Text\x+\Items()\Text\Width
                      EndIf
                    Next
                    PopListPosition(\Items())
                    
                    Break
                  EndIf
                Wend
                PopListPosition(\Items())
                
              Else
                ; Get entered item only on image and text 
                If Not *This\Flag\FullSelection And
                   ((MouseX < \Items()\text\x-*This\Image\width) Or (MouseX > \Items()\text\x+\Items()\text\width))
                  Break
                EndIf
                
                If adress 
                  PushListPosition(\Items()) 
                  ChangeCurrentElement(\Items(), adress)
                  If \Items()\focus = \Items()\Index
                    lostfocus = \Items()\focus 
                    \Items()\Color\State = 1
                    \Items()\lostfocus =- 1
                    \Items()\focus =- 1
                  EndIf
                  PopListPosition(\Items()) 
                  If lostfocus <> \Items()\Index
                    \Items()\lostfocus = lostfocus
                    *This\Index = \Items()\Index
                    *This\Change = 1
                  EndIf
                EndIf
                
                \Items()\focus = \Items()\Index
              EndIf
            EndIf
            
            If \Items()\Index[1] <> \Items()\Index 
              \Items()\Index[1] = \Items()\Index
              *This\Index[1] = \Items()\Index[1]
              
              ; надо учитивать высоту текста шрифт текста и т.д.
              ;*This\Text = \Items()\text 
              ;CopyStructure(\Items()\text, *This\Text, Text_S)
              
              
              If \Items()\lostfocus <> \Items()\Index
                \Items()\Color\State = 1+Bool(\Items()\Index=\Items()\focus)
              EndIf
              
            EndIf
            
            adress = @\Items()
            
            Break
          EndIf
        Next
      EndIf
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn adress
  EndProcedure
  
  Procedure get_from(*This.Widget_S, MouseX=-1, MouseY=-1, focus=0)
    Protected adress.i
    Protected lostfocus.i=-1, collapsed.i, sublevel.i
    Protected Buttons, Line.i =- 1
    
    With *This
      MouseX-\Scroll\X
      MouseY-\Scroll\Y
      
      PushListPosition(\Items()) 
      ForEach \Items()
        If \Items()\Index[1] = \Items()\Index 
          \Items()\Index[1] =- 1
          adress = @\Items()
          Line = \Items()\Index 
          Break
        EndIf
      Next
      
      ForEach \Items()
        If \Items()\Index = \Items()\focus
          If Bool(MouseX=-1 And MouseY=-1 And focus=1)
            \Items()\lostfocus = \Items()\focus
            *This\focus = 0
            
            ; then lost focus widget
            \Items()\Color\State = 0
            
          EndIf
          
          adress = @\Items()
          Line = \Items()\Index 
          Break
        EndIf
      Next
      
      If Not Bool(MouseX=-1 And MouseY=-1)
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If (MouseY > (\Items()\Y) And MouseY =< ((\Items()\Y+\Items()\Height))) And 
             ((MouseX > \Items()\X) And (MouseX =< (\Items()\X+\Items()\Width)))
            
            If focus
              If (MouseY > (\Items()\box\y[1]) And MouseY =< ((\Items()\box\y[1]+\Items()\box\height[1]))) And 
                 ((MouseX > \Items()\box\x[1]) And (MouseX =< (\Items()\box\x[1]+\Items()\box\width[1])))
                
                \Items()\checked ! 1
                *This\Change = 1
              EndIf
              
              If (\flag\buttons And \Items()\childrens) And
                 (MouseY > (\Items()\box\y[0]) And MouseY =< ((\Items()\box\y[0]+\Items()\box\height[0]))) And 
                 ((MouseX > \Items()\box\x[0]) And (MouseX =< (\Items()\box\x[0]+\Items()\box\width[0])))
                
                sublevel = \Items()\sublevel
                \Items()\collapsed ! 1
                Protected Height = \Items()\Y+\Items()\Height, Y=Height
                
                PushListPosition(\Items())
                While NextElement(\Items())
                  If \Items()\sublevel > sublevel 
                    If \Items()\handle
                      PushListPosition(\Items())
                      ChangeCurrentElement(\Items(), \Items()\handle)
                      collapsed = \Items()\collapsed
                      collapsed | \Items()\hide
                      PopListPosition(\Items())
                    EndIf
                    \Items()\hide = collapsed
                    
                    If \Items()\hide
                      \Scroll\Height - \Items()\Height
                    Else
                      Height = \Items()\Y+\Items()\Height
                      If Not \Items()\Height
                        \Items()\Height = \Text\Height
                        \Items()\Text\Height = \Text\Height[1]
                      EndIf
                      \Items()\Y = Y
                      \Items()\Text\Y = \Items()\Y + (\Items()\Height-\Items()\Text\Height)/2
                      \Items()\Image\Y = \Items()\Y + (\Items()\Height-\Items()\Image\Height)/2
                      Y + \Items()\Height
                      \Scroll\Height + \Items()\Height
                    EndIf
                  Else
                    PushListPosition(\Items())
                    Repeat
                      If Not \Items()\hide
                        \Items()\Y = Height
                        \Items()\Text\Y = \Items()\Y + (\Items()\Height-\Items()\Text\Height)/2
                        \Items()\Image\Y = \Items()\Y + (\Items()\Height-\Items()\Image\Height)/2
                        Height + \Items()\Height
                      EndIf
                    Until Not NextElement(\Items())
                    PopListPosition(\Items())
                    \Scroll\Width = 0
                    \Scroll\Height = Height
                    PushListPosition(\Items())
                    ForEach \Items()
                      _set_scroll_width_(*This)
                    Next
                    PopListPosition(\Items())
                    
                    Break
                  EndIf
                Wend
                PopListPosition(\Items())
                
              Else
                ; Get entered item only on image and text 
                If Not *This\Flag\FullSelection And
                   ((MouseX < \Items()\text\x-*This\Image\width) Or (MouseX > \Items()\text\x+\Items()\text\width))
                  Break
                EndIf
                
                If adress 
                  PushListPosition(\Items()) 
                  ChangeCurrentElement(\Items(), adress)
                  If \Items()\focus = \Items()\Index
                    lostfocus = \Items()\focus 
                    \Items()\Color\State = 1
                    \Items()\lostfocus =- 1
                    \Items()\focus =- 1
                  EndIf
                  PopListPosition(\Items()) 
                EndIf
                
                If lostfocus <> \Items()\Index
                  \Items()\lostfocus = lostfocus
                  *This\Index = \Items()\Index
                  *This\Change = 1
                EndIf
                
                \Items()\Color\State = 2
                \Items()\focus = \Items()\Index
              EndIf
            EndIf
            
            
            adress = @\Items()
            Line = \Items()\Index 
            Break
          EndIf
        Next
      EndIf
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn Line
  EndProcedure
  
  Procedure ReDraw(*This.Widget_S)
    If StartDrawing(CanvasOutput(*This\Canvas\Gadget))
      Text::Draw(*This)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure.i SetItemState(*This.Widget_S, Item.i, State.i)
    Protected Result, sublevel
    
    With *This
      ; If (\Flag\MultiSelect Or \Flag\ClickSelect)
      PushListPosition(\Items())
      Result = SelectElement(\Items(), Item) 
      If Result 
        If State&#PB_Attribute_Selected
          \Items()\Index[1] = \Items()\Index
          \Items()\Color\State = Bool(State)+1
        EndIf
        
        If State&#PB_Attribute_Collapsed Or State&#PB_Attribute_Expanded
          \Items()\collapsed = Bool(State&#PB_Attribute_Collapsed)
          
          sublevel = \Items()\sublevel
          
          PushListPosition(\Items())
          While NextElement(\Items())
            If sublevel = \Items()\sublevel
              Break
            ElseIf sublevel < \Items()\sublevel 
              If State&#PB_Attribute_Collapsed
                \Items()\hide = 1
              ElseIf State&#PB_Attribute_Expanded
                \Items()\hide = 0
              EndIf
            EndIf
          Wend
        EndIf
        
      EndIf
      PopListPosition(\Items())
      ; EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(*This.Widget_S, State.i)
    With *This
      Text::Redraw(*This, \Canvas\Gadget)
      
      PushListPosition(\Items())
      SelectElement(\Items(), State) : \Items()\Focus = State : \Items()\Index[1] = \Items()\Index : \Items()\Color\State = 2
      Bar::SetState(\Scroll\v, ((State*\Text\Height)-\Scroll\v\Height) + \Text\Height) : \Scroll\Y =- \Scroll\v\page\Pos ; в конце
                                                                                                                         ; Bar::SetState(\Scroll\v, (State*\Text\Height)) : \Scroll\Y =- \Scroll\v\page\Pos ; в начале 
      PopListPosition(\Items())
    EndWith
  EndProcedure
  
  Procedure.i GetState(*This.Widget_S)
    Protected Result
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If \Items()\Focus = \Items()\Index
          Result = \Items()\Index
        EndIf
      Next
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Events(*This.Widget_S, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      Repaint | Bar::CallBack(\Scroll\v, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
      Repaint | Bar::CallBack(\Scroll\h, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
    EndWith
    
    If *This And (Not *This\Scroll\v\at And Not *This\Scroll\h\at)
      If ListSize(*This\Items())
        With *This
          If Not \Hide And Not \Disable And \Interact
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
            CompilerElse
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
            CompilerEndIf
            
            Select EventType 
              Case #PB_EventType_LostFocus 
                ; \Focus =- 1
                ;                 \Index[1] =- 1
                ; \Items()\Focus =- 1
                ;                 \Items()\Index[1] = \Items()\Index
                Debug "    "+\Index[2]+" "+\Items()\Text\String 
                itemSelect(\Index[2], \Items())
                \Items()\Color\State = 0
                Repaint = #True
                PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
                
              Case #PB_EventType_Focus 
                Repaint = #True 
                
              Case #PB_EventType_LeftClick 
                If \change : \change = 0 
                  PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change) 
                EndIf
                PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_LeftClick)
                
              Case #PB_EventType_RightClick : PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_RightClick)
              Case #PB_EventType_LeftDoubleClick : PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_LeftDoubleClick)
                
              Case #PB_EventType_MouseLeave
                If \ToolTip 
                  ; Debug ""+DesktopMouseY()+" "+Str(\ToolTip\Y+\ToolTip\Height)
                  If Bool(DesktopMouseY() > (\ToolTip\Y[1]) And DesktopMouseY() =< ((\ToolTip\Y[1]+\ToolTip\Height[1]))) And 
                     ((DesktopMouseX() > \ToolTip\X[1]) And (DesktopMouseX() =< (\ToolTip\X[1]+\ToolTip\Width)))
                    
                  Else
                    ;Debug 77777
                    ToolTip(0)
                    \Index[1] =- 1
                  EndIf
                Else
                  \Index[1] =- 1
                EndIf
                
              Case #PB_EventType_LeftButtonUp : \Drag[1] = 0
                Repaint = 1
                
              Case #PB_EventType_LeftButtonDown
                \Index[1] = get_from(*This, \Canvas\Mouse\X, \Canvas\Mouse\Y, 1) : \Index[2] = \Index[1]
                Repaint = 1
                
              Case #PB_EventType_MouseMove  
                Protected from = \Index[1]
                Protected Line = get_from(*This, \Canvas\Mouse\X, \Canvas\Mouse\Y)
                
                If \Index[1]<>Line : \Index[1]=Line
                  If \Scroll\h\hide And from <> \Index[1]
                    itemSelect(\Index[1], \Items())
                    If (\Items()\text\x+\Items()\text\width)>\Items()\X+\Items()\width
                      If \ToolTip : ToolTip(0) : EndIf
                      \ToolTip = \Items()\text
                      \tooltip\x[1]=\Items()\text\x+GadgetX(\canvas\gadget, #PB_Gadget_ScreenCoordinate)+*This\Scroll\X
                      \tooltip\y[1]=\Items()\y+GadgetY(\canvas\gadget, #PB_Gadget_ScreenCoordinate)+*This\Scroll\Y
                      \tooltip\width[1]=\Items()\width
                      \tooltip\height[1]=\Items()\height
                      ToolTip(\ToolTip)
                    ElseIf \ToolTip : \ToolTip = 0
                      ToolTip(0)
                    EndIf
                    from = \Index[1]
                  EndIf
                  
                  If \Drag And \Drag[1] = 0 : \Drag[1] = 1
                    If \change : \change = 0 
                      PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change) 
                    EndIf
                    PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_DragStart)
                  EndIf
                  
                  Repaint = 1
                  
                  ; ;                 If StartDrawing(CanvasOutput(\Canvas\Gadget))
                  ; ;                   ; Text::Draw(*This)
                  ; ;                   If \Text\FontID 
                  ; ;                     DrawingFont(\Text\FontID) 
                  ; ;                   EndIf
                  ; ;                   
                  ; ;                   ; Draw selections
                  ; ;                   If from>=0 And SelectElement(\Items(), from)
                  ; ;                       DrawingMode(#PB_2DDrawing_Default)
                  ; ;                       RoundBox(*This\x[2],\Items()\Y,\Items()\width,\Items()\height,\Items()\Radius,\Items()\Radius, \Color\Back[0])
                  ; ;                       
                  ; ;                     
                  ; ;                     If \Color\State = 2
                  ; ;                       DrawingMode(#PB_2DDrawing_Transparent)
                  ; ;                       DrawRotatedText(\Items()\Text[0]\X, \Items()\Text[0]\Y, \Items()\Text[0]\String.s, Bool(\Items()\Text\Vertical)**This\Text\Rotate, \Items()\Color\Front[\Color\State])
                  ; ;                     Else
                  ; ;                       DrawingMode(#PB_2DDrawing_Transparent)
                  ; ;                       DrawRotatedText(\Items()\Text[0]\X, \Items()\Text[0]\Y, \Items()\Text[0]\String.s, Bool(\Items()\Text\Vertical)**This\Text\Rotate, *This\Color\Front[*This\Color\State])
                  ; ;                     EndIf
                  ; ;                   EndIf
                  ; ;                   
                  ; ;                   If Line>=0 And SelectElement(\Items(), Line)
                  ; ;                   ;If (\Items()\Index=*This\Index[1] Or \Items()\Index=\Items()\focus Or \Items()\Index=\Items()\Index[1]) ; \Color\State;
                  ; ;                     If \Items()\Color\Fore[\Color\State]
                  ; ;                       DrawingMode(#PB_2DDrawing_Gradient);|#PB_2DDrawing_AlphaBlend)
                  ; ;                       BoxGradient(\Vertical,*This\X[2],\Items()\Y,\Items()\width,\Items()\Height,\Items()\Color\Fore[\Color\State],\Items()\Color\Back[\Color\State],\Items()\Radius)
                  ; ;                     Else
                  ; ;                       DrawingMode(#PB_2DDrawing_Default);|#PB_2DDrawing_AlphaBlend)
                  ; ;                       RoundBox(*This\X[2],\Items()\Y,\Items()\width,\Items()\Height,\Items()\Radius,\Items()\Radius,\Items()\Color\Back[\Color\State])
                  ; ;                     EndIf
                  ; ;                     
                  ; ;                     DrawingMode(#PB_2DDrawing_Outlined);|#PB_2DDrawing_AlphaBlend)
                  ; ;                     RoundBox(*This\x[2],\Items()\Y,\Items()\width,\Items()\height,\Items()\Radius,\Items()\Radius, \Items()\Color\Frame[\Color\State])
                  ; ;                     
                  ; ;                     DrawingMode(#PB_2DDrawing_Transparent)
                  ; ;                       DrawRotatedText(\Items()\Text[0]\X, \Items()\Text[0]\Y, \Items()\Text[0]\String.s, Bool(\Items()\Text\Vertical)**This\Text\Rotate, *This\Color\Front[*This\Color\State])
                  ; ;                     EndIf
                  ; ;                   
                  ; ;                   StopDrawing()
                  ; ;                 EndIf
                  
                EndIf
                
              Default
                itemSelect(\Index[2], \Items())
            EndSelect
          EndIf
        EndWith    
        
        With *This\Items()
          If *Focus = *This
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
            CompilerElse
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
            CompilerEndIf
            
            Select EventType
              Case #PB_EventType_KeyUp
              Case #PB_EventType_KeyDown
                Select *This\Canvas\Key
                  Case #PB_Shortcut_V
                EndSelect 
                
            EndSelect
          EndIf
          
          
        EndWith
      EndIf
    Else
      *This\Index[1] =- 1
    EndIf
    
    ;     If Repaint
    ;       Debug Repaint
    ;     EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Tree
        \Cursor = #PB_Cursor_Default
        ;\DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        If Not \Canvas\Window
          \Canvas\Window = GetActiveWindow() ; GetGadgetData(Canvas)
        EndIf
        \Radius = Radius
        \sublevellen = 18
        \Interact = 1
        \Text\Caret[1] =- 1
        \Index[1] =- 1
        \X =- 1
        \Y =- 1
        
        ; Set the Default widget flag
        If Bool(Flag&#PB_Text_WordWrap)
          Flag&~#PB_Text_MultiLine
        EndIf
        
        If Bool(Flag&#PB_Text_MultiLine)
          Flag&~#PB_Text_WordWrap
        EndIf
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fSize = Bool(Not Flag&#PB_Flag_BorderLess)*2
        \bSize = \fSize
        
        \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
        \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
        \Flag\FullSelection = Bool(flag&#PB_Flag_FullSelection)
        \Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
        \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
        
        \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
        \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
        \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12; Это еще будет размер чек бокса
        
        \Text\Vertical = Bool(Flag&#PB_Flag_Vertical)
        \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
        
        If Bool(Flag&#PB_Text_WordWrap)
          \Text\MultiLine = 1
        ElseIf Bool(Flag&#PB_Text_MultiLine)
          \Text\MultiLine = 2
        Else
          \Text\MultiLine =- 1
        EndIf
        
        \Text\Numeric = Bool(Flag&#PB_Text_Numeric)
        \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
        \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
        \Text\Pass = Bool(Flag&#PB_Text_Password)
        
        
        \Text\X = \fSize+2
        \Text\y = \fSize
        \Text\Change = 1
        
        \Color = Colors
        \color\alpha = 255
        \color\alpha[1] = 0
        \Color\Fore[0] = 0
        
        \Row\color\alpha = 255
        \Row\Color = Colors
        \Row\color\alpha = 255
        \Row\color\alpha[1] = 0
        \Row\Color\Fore[0] = 0
        \Row\Color\Fore[1] = 0
        \Row\Color\Fore[2] = 0
        
        \Row\Color\Frame[2] = \Row\Color\Back[2]
        
        If \Text\Editable
          \Text\Editable = 0
          \Color\Back[0] = $FFFFFFFF 
        Else
          \Color\Back[0] = $FFF0F0F0  
        EndIf
        
        ; create scrollbars
        Bar::Bars(\Scroll, 16, 7, Bool(Not Bool(Not \flag\buttons And Not \flag\Lines)))
        
        Resize(*This, X,Y,Width,Height)
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    Protected *Widget, *This.Widget_S = AllocateStructure(Widget_S)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius)
      PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create, *This\Canvas\Gadget)
      PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint, *This)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Canvas_CallBack()
    Protected Repaint, *This.Widget_S = GetGadgetData(EventGadget())
    
    With *This
      Select EventType()
        Case #PB_EventType_Repaint : Repaint = 1
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint | Resize(*This, #PB_Ignore, #PB_Ignore, GadgetWidth(\Canvas\Gadget), GadgetHeight(\Canvas\Gadget))
      EndSelect
      
      Repaint | CallBack(*This, EventType())
      
      If Repaint 
        ReDraw(*This)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        Widget(*This, Gadget, 0, 0, Width, Height, "", Flag)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
  
EndModule


;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Tree
  
  Procedure CallBacks()
    Protected Result
    Protected Canvas = EventGadget()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Select EventType()
      Case #PB_EventType_KeyDown ; Debug  " key "+GetGadgetAttribute(Canvas, #PB_Canvas_Key)
        Select GetGadgetAttribute(Canvas, #PB_Canvas_Key)
          Case #PB_Shortcut_Tab
            ForEach List()
              If List()\Widget = List()\Widget\Focus
                Result | CallBack(List()\Widget, #PB_EventType_LostFocus);, Canvas) 
                NextElement(List())
                ;Debug List()\Widget
                Result | CallBack(List()\Widget, #PB_EventType_Focus);, Canvas) 
                Break
              EndIf
            Next
        EndSelect
    EndSelect
    
    Select EventType()
      Case #PB_EventType_Repaint : Text::ReDraw(EventData(), Canvas, $FFF0F0F0)
      Case #PB_EventType_Resize : Result = 1
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(EventGadget())
        EndIf
        
        ForEach List()
          If Canvas = List()\Widget\Canvas\Gadget
            Result | CallBack(List()\Widget, EventType()) 
          EndIf
        Next
    EndSelect
    
    If Result
      Text::ReDraw(0, Canvas, $FFF0F0F0)
    EndIf
    
  EndProcedure
  
  Procedure Events()
    If EventType() = #PB_EventType_LeftClick
      ;       If GadgetType(EventGadget()) = #PB_GadgetType_ListIcon
      ;         Debug GetGadgetText(EventGadget())
      ;         Debug GetGadgetState(EventGadget())
      ;         Debug GetGadgetItemState(EventGadget(), GetGadgetState(EventGadget()))
      ;       Else
      ;         Debug ListIcon::GetText(EventGadget())
      ;         Debug ListIcon::GetState(EventGadget())
      ;         Debug ListIcon::GetItemState(EventGadget(), ListIcon::GetState(EventGadget()))
      ;       EndIf
    EndIf
  EndProcedure
  
  
  UsePNGImageDecoder()
  ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  
  If OpenWindow(0, 0, 0, 1110, 450, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define i,a,g = 1
    ;{ - gadget
    TreeGadget(g, 10, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes)                                         
    ; 1_example
    AddGadgetItem(g, 0, "Normal Item "+Str(a), 0, 0) 
    AddGadgetItem(g, -1, "Node "+Str(a), ImageID(0), 0)      
    AddGadgetItem(g, -1, "Sub-Item 1", 0, 1)         
    AddGadgetItem(g, -1, "Sub-Item 2", 0, 11)
    AddGadgetItem(g, -1, "Sub-Item 3", 0, 1)
    AddGadgetItem(g, -1, "Sub-Item 4", 0, 1)         
    AddGadgetItem(g, -1, "Sub-Item 5", 0, 11)
    AddGadgetItem(g, -1, "Sub-Item 6", 0, 1)
    AddGadgetItem(g, -1, "File "+Str(a), 0, 0) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; RemoveGadgetItem(g,1)
    SetGadgetItemState(g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
    BindGadgetEvent(g, @Events())
    
    ;SetActiveGadget(g)
    ;SetGadgetState(g, 1)
    ;     Debug "g "+ GetGadgetText(g)
    
    g = 2
    TreeGadget(g, 230, 10, 210, 210, #PB_Tree_AlwaysShowSelection)                                         
    ; 3_example
    AddGadgetItem(g, 0, "Tree_0", 0 )
    AddGadgetItem(g, 1, "Tree_1_1", ImageID(0), 1) 
    AddGadgetItem(g, 4, "Tree_1_1_1", 0, 2) 
    AddGadgetItem(g, 5, "Tree_1_1_2", 0, 2) 
    AddGadgetItem(g, 6, "Tree_1_1_2_1", 0, 3) 
    AddGadgetItem(g, 8, "Tree_1_1_2_1_1", 0, 4) 
    AddGadgetItem(g, 7, "Tree_1_1_2_2", 0, 3) 
    AddGadgetItem(g, 2, "Tree_1_2", 0, 1) 
    AddGadgetItem(g, 3, "Tree_1_3", 0, 1) 
    AddGadgetItem(g, 9, "Tree_2" )
    AddGadgetItem(g, 10, "Tree_3", 0 )
    
    ;     AddGadgetItem(g, 6, "Tree_1_1_2_1", 0, 3) 
    ;     AddGadgetItem(g, 8, "Tree_1_1_2_1_1", 0, 4) 
    ;     AddGadgetItem(g, 7, "Tree_1_1_2_2", 0, 3) 
    ;     AddGadgetItem(g, 2, "Tree_1_2", 0, 1) 
    ;     AddGadgetItem(g, 3, "Tree_1_3", 0, 1) 
    ;     AddGadgetItem(g, 9, "Tree_2" )
    ;     AddGadgetItem(g, 10, "Tree_3", 0 )
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; ClearGadgetItems(g)
    
    g = 3
    TreeGadget(g, 450, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes |#PB_Tree_NoLines|#PB_Tree_NoButtons)  ;                                       
                                                                                                                             ;   ;  2_example
                                                                                                                             ;   AddGadgetItem(g, 0, "Normal Item "+Str(a), 0, 0) 
                                                                                                                             ;   AddGadgetItem(g, 1, "Node "+Str(a), 0, 1)       
                                                                                                                             ;   AddGadgetItem(g, 4, "Sub-Item 1", 0, 2)          
                                                                                                                             ;   AddGadgetItem(g, 2, "Sub-Item 2", 0, 1)
                                                                                                                             ;   AddGadgetItem(g, 3, "Sub-Item 3", 0, 1)
    
    ;  2_example
    AddGadgetItem(g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)",ImageID(0)) 
    For i=1 To 20
      If i=5
        AddGadgetItem(g, -1, "Tree_"+Str(i), 0) 
      Else
        AddGadgetItem(g, -1, "Tree_"+Str(i), ImageID(0)) 
      EndIf
    Next
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 4
    TreeGadget(g, 670, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoLines)                                         
    ; 4_example
    AddGadgetItem(g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", 0 )
    AddGadgetItem(g, 1, "Tree_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2", 0, 2) 
    AddGadgetItem(g, 2, "Tree_2_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_2", 0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 5
    TreeGadget(g, 890, 10, 103, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoButtons)                                         
    ; 5_example
    AddGadgetItem(g, 0, "Tree_0 (NoButtons)", 0 )
    AddGadgetItem(g, 1, "Tree_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2", 0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 6
    TreeGadget(g, 890+106, 10, 103, 210, #PB_Tree_AlwaysShowSelection)                                         
    ;  6_example
    AddGadgetItem(g, 0, "Tree_1", 0, 1) 
    AddGadgetItem(g, 0, "Tree_2_1", 0, 2) 
    AddGadgetItem(g, 0, "Tree_2_2", 0, 3) 
    
    For i = 0 To 24
      If i % 5 = 0
        AddGadgetItem(g, -1, "Directory" + Str(i), 0, 0)
      Else
        AddGadgetItem(g, -1, "Item" + Str(i), 0, 1)
      EndIf
    Next i
    
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    ;}
    
    ;{ - widget
    ; Demo draw string on the canvas
    g = 10
    CanvasGadget(g,  0, 220, 1110, 230, #PB_Canvas_Keyboard)
    SetGadgetAttribute(g, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    SetGadgetData(g, 0)
    BindGadgetEvent(g, @CallBacks())
    
    *g = Create(g, -1, 10, 10, 210, 210, "", #PB_Flag_AlwaysSelection|#PB_Tree_CheckBoxes|#PB_Flag_FullSelection)                                         
    ; 1_example
    AddItem (*g, 0, "Normal Item "+Str(a), -1, 0)                                   
    AddItem (*g, -1, "Node "+Str(a), 0, 0)                                         
    AddItem (*g, -1, "Sub-Item 1", -1, 1)                                           
    AddItem (*g, -1, "Sub-Item 2", -1, 11)
    AddItem (*g, -1, "Sub-Item 3", -1, 1)
    AddItem (*g, -1, "Sub-Item 4", -1, 1)                                           
    AddItem (*g, -1, "Sub-Item 5", -1, 11)
    AddItem (*g, -1, "Sub-Item 6", -1, 1)
    AddItem (*g, -1, "File "+Str(a), -1, 0)  
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    ; RemoveItem(*g,1)
    Tree::SetItemState(*g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
    BindGadgetEvent(g, @Events())
    ;Tree::SetState(*g, 1)
    ;Tree::SetState(*g, -1)
    
    
    *g = Create(g, -1, 230, 10, 210, 210, "", #PB_Flag_AlwaysSelection|#PB_Flag_FullSelection)                                         
    ;  3_example
    
    AddItem(*g, 0, "Tree_0", 0 )
    AddItem(*g, 1, "Tree_1_1", 0, 1) 
    AddItem(*g, 4, "Tree_1_1_1", 0, 2) 
    AddItem(*g, 5, "Tree_1_1_2uuuuuuuuuuuuuuuuu", 0, 2) 
    AddItem(*g, 6, "Tree_1_1_2_1", 0, 3) 
    AddItem(*g, 8, "Tree_1_1_2_1_1_4 and scroll end", 0, 4) 
    AddItem(*g, 7, "Tree_1_1_2_2", 0, 3) 
    AddItem(*g, 2, "Tree_1_2", 0, 1) 
    AddItem(*g, 3, "Tree_1_3", 0, 1) 
    AddItem(*g, 9, "Tree_2 ",0 )
    AddItem(*g, 10, "Tree_3", 0 )
    
    ;     AddItem(*g, 6, "Tree_1_1_2_1", -1, 3) 
    ;     AddItem(*g, 8, "Tree_1_1_2_1_1_8", -1, 4) 
    ;     AddItem(*g, 7, "Tree_1_1_2_2", -1, 3) 
    ;     AddItem(*g, 2, "Tree_1_2", -1, 1) 
    ;     AddItem(*g, 3, "Tree_1_3", -1, 1) 
    ;     AddItem(*g, 9, "Tree_2",-1 )
    ;     AddItem(*g, 10, "Tree_3", -1 )
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    ; ClearItems(*g)
    
    *g = Create(g, -1, 450, 10, 210, 210, "", #PB_Flag_AlwaysSelection|#PB_Flag_FullSelection|#PB_Flag_CheckBoxes |#PB_Flag_NoLines|#PB_Flag_NoButtons )    ;                                
                                                                                                                                                            ;   ;  2_example
                                                                                                                                                            ;   AddItem (*g, 0, "Normal Item "+Str(a), -1, 0)                                    
                                                                                                                                                            ;   AddItem (*g, 1, "Node "+Str(a), -1, 1)                                           
                                                                                                                                                            ;   AddItem (*g, 4, "Sub-Item 1", -1, 2)                                            
                                                                                                                                                            ;   AddItem (*g, 2, "Sub-Item 2", -1, 1)
                                                                                                                                                            ;   AddItem (*g, 3, "Sub-Item 3", -1, 1)
    
    ;  2_example
    AddItem (*g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)", 0)                                    
    For i=1 To 20
      If i=5
        AddItem(*g, -1, "Tree_"+Str(i), -1) 
      Else
        AddItem(*g, -1, "Tree_"+Str(i), 0) 
      EndIf
    Next
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    *g = Create(g, -1, 670, 10, 210, 210, "", #PB_Flag_AlwaysSelection|#PB_Tree_NoLines)                                         
    ;  4_example
    AddItem(*g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", -1 )
    AddItem(*g, 1, "Tree_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_2", -1, 2) 
    AddItem(*g, 2, "Tree_2_1", -1, 1) 
    AddItem(*g, 3, "Tree_3_1", -1, 1) 
    AddItem(*g, 3, "Tree_3_2", -1, 2) 
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    
    *g = Create(g, -1, 890, 10, 103, 210, "", #PB_Flag_AlwaysSelection|#PB_Tree_NoButtons)                                         
    ;  5_example
    AddItem(*g, 0, "Tree_0 (NoButtons)", -1 )
    AddItem(*g, 1, "Tree_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_2", -1, 2) 
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    *g = Create(g, -1, 890+106, 10, 103, 210, "", #PB_Flag_AlwaysSelection|#PB_Flag_BorderLess)                                         
    ;  6_example
    AddItem(*g, 0, "Tree_1", -1, 1) 
    AddItem(*g, 0, "Tree_2_1", -1, 2) 
    AddItem(*g, 0, "Tree_2_2", -1, 3) 
    
    For i = 0 To 24
      If i % 5 = 0
        AddItem(*g, -1, "Directory" + Str(i), -1, 0)
      Else
        AddItem(*g, -1, "Item" + Str(i), -1, 1)
      EndIf
    Next i
    
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    ;}
    ;Free(*g)
    
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          End 
        Case #PB_Event_Widget
          Select EventGadget()
            Case 12
              Select EventType()
                Case #PB_EventType_ScrollChange : Debug "widget ScrollChange" +" "+ EventData()
                Case #PB_EventType_DragStart : Debug "widget dragStart"
                Case #PB_EventType_Change, #PB_EventType_LeftClick
                  Debug "widget id = " + GetState(GetGadgetData(EventGadget()))
                  
                  If EventType() = #PB_EventType_Change
                    Debug "  widget change"
                  EndIf
              EndSelect
          EndSelect
          
        Case #PB_Event_Gadget
          Select EventGadget()
            Case 3
              Select EventType()
                Case #PB_EventType_ScrollChange : Debug "ScrollChange" +" "+ EventData()
                Case #PB_EventType_DragStart : Debug "gadget dragStart"
                Case #PB_EventType_Change, #PB_EventType_LeftClick
                  Debug "gadget id = " + GetGadgetState(EventGadget())
                  
                  If EventType() = #PB_EventType_Change
                    Debug "  gadget change"
                  EndIf
              EndSelect
          EndSelect
      EndSelect
    ForEver
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -8--------------------
; EnableXP