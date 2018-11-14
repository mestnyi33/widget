CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
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
  XIncludeFile "module_scroll.pbi"
  XIncludeFile "module_text.pbi"
  XIncludeFile "module_editor.pbi"
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
CompilerEndIf

DeclareModule ListView
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  
  ;- - DECLAREs MACROs
  Macro ClearItems(_gadget_)
    Editor::ClearItems(_gadget_)
  EndMacro
  
  Macro CountItems(_gadget_)
    Editor::CountItems(_gadget_)
  EndMacro
  
  Macro RemoveItem(_gadget_, _item_)
    Editor::RemoveItem(_gadget_, _item_)
  EndMacro
  
  Macro AddItem(_gadget_,_item_,_text_,_image_=-1,_flag_=0)
    Editor::AddItem(_gadget_,_item_,_text_,_image_,_flag_)
  EndMacro
  
  Macro SetText(_gadget_,_text_)
    Editor::SetText(_gadget_,_text_,0)
  EndMacro
  
  Macro SetFont(_gadget_, _font_id_)
    Editor::SetFont(_gadget_, _font_id_)
  EndMacro
  
  Macro GetText(_gadget_)
    Text::GetText(GetGadgetData(_gadget_))
  EndMacro
  
  ;- DECLAREs PROCEDUREs
  Declare.i SetState(Gadget.i, State.i)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
  Declare.i SetItemState(Gadget.i, Item.i, State.i)
EndDeclareModule

Module ListView
  ;-
  ;- PROCEDUREs
  ;-
  Procedure.i SetItemState(Gadget.i, Item.i, State.i)
    Protected Result, *This.Widget_S = GetGadgetData(Gadget)
    
    With *This
      If (\Flag\MultiSelect Or \Flag\ClickSelect)
        PushListPosition(\Items())
        Result = SelectElement(\Items(), Item) 
        If Result 
          \Items()\Color\State = Bool(State)+1
          \Items()\Line = \Items()\Item
          PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
        EndIf
        PopListPosition(\Items())
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(Gadget.i, State.i)
    Protected *This.Widget_S = GetGadgetData(Gadget)
    
    With *This
      Text::Redraw(*This, \Canvas\Gadget)
      
      PushListPosition(\Items())
      ChangeCurrentElement(\Items(), SetItemState(Gadget, State, 2)) : \Items()\Focus = State
      Scroll::SetState(\vScroll, (State*\Text\Height)-\vScroll\Height + \Text\Height) : \Scroll\Y =- \vScroll\Page\Pos
      PopListPosition(\Items())
    EndWith
  EndProcedure
  
;   Procedure.i SetState(Gadget.i, State.i)
;     Protected *This.Widget_S = GetGadgetData(Gadget)
;     
;     With *This
;       Text::Redraw(*This, \Canvas\Gadget)
;       
;       PushListPosition(\Items())
;       SelectElement(\Items(), State) : \Items()\Focus = State : \Items()\Color\State = 2
;       Scroll::SetState(\vScroll, (State*\Text\Height)-\vScroll\Height + \Text\Height) : \Scroll\Y =- \vScroll\Page\Pos
;       PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
;       PopListPosition(\Items())
;     EndWith
;   EndProcedure
  
  Procedure GetState(Gadget.i)
    Protected Result, *This.Widget_S = GetGadgetData(Gadget)
    
    With *This
;       PushListPosition(\Items())
;       SelectElement(\Items(), State) 
;       Result = \Items()\Color\State 
;       PopListPosition(\Items())
    EndWith
    
   ProcedureReturn Result
 EndProcedure
  
  Procedure.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
    With *This
      If Text::Resize(*This, X,Y,Width,Height)
        Scroll::Resizes(\vScroll, \hScroll, \x[2],\Y[2],\Width[2],\Height[2])
      EndIf
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  Procedure.i Events(*This.Widget_S, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      Repaint | Scroll::CallBack(\vScroll, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y,0, 0, \hScroll, \Canvas\Window, \Canvas\Gadget)
      If Repaint
        \Scroll\Y =- \vScroll\Page\Pos
      EndIf
      Repaint | Scroll::CallBack(\hScroll, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y,0, 0, \vScroll, \Canvas\Window, \Canvas\Gadget)
      If Repaint
        \Scroll\X =- \hScroll\Page\Pos
      EndIf
    EndWith
    
    If *This And (Not *This\vScroll\Buttons And Not *This\hScroll\Buttons)
      If ListSize(*This\items())
        With *This
          If Not \Hide And Not \Disable And \Interact
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
            CompilerElse
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
            CompilerEndIf
            
            Select EventType 
              Case #PB_EventType_LeftClick : PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_LeftClick)
              Case #PB_EventType_RightClick : PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_RightClick)
              Case #PB_EventType_LeftDoubleClick : PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_LeftDoubleClick)
                
              Case #PB_EventType_MouseLeave
                \Line =- 1
                
              Case #PB_EventType_LeftButtonDown
                PushListPosition(\Items()) 
                ForEach \Items()
                  If \Line = \Items()\Item 
                    \Line[1] = \Line
                    
                    If \Flag\ClickSelect
                      \Items()\Color\State ! 2
                    Else
                       \Items()\Line = \Items()\Item
                       \Items()\Color\State = 2
                    EndIf
                    
                    ; \Items()\Focus = \Items()\Item 
                  ElseIf ((Not \Flag\ClickSelect And \Items()\Focus = \Items()\Item) Or \Flag\MultiSelect) And Not Control
                    \Items()\Line =- 1
                    \Items()\Color\State = 1
                    \Items()\Focus =- 1
                  EndIf
                Next
                PopListPosition(\Items()) 
                Repaint = 1
                 
              Case #PB_EventType_LeftButtonUp
                PushListPosition(\Items()) 
                ForEach \Items()
                  If \Line = \Items()\Item 
                    \Items()\Focus = \Items()\Item 
                  Else
                    If (Not \Flag\MultiSelect And Not \Flag\ClickSelect)
                      \items()\Color\State = 1
                    EndIf
                  EndIf
                Next
                PopListPosition(\Items()) 
                Repaint = 1
                
              Case #PB_EventType_MouseMove  
                If \Canvas\Mouse\Y < \Y Or \Canvas\Mouse\X > Scroll::X(\vScroll)
                  Item.i =- 1
                ElseIf \Text\Height
                  Item.i = ((\Canvas\Mouse\Y-\Y-\Text\Y-\Scroll\Y) / \Text\Height)
                EndIf
                
                If \Line <> Item And Item =< ListSize(\Items())
                  If isItem(\Line, \Items()) 
                    If \Line <> ListIndex(\Items())
                      SelectElement(\Items(), \Line) 
                    EndIf
                    
                    If \Canvas\Mouse\Buttons & #PB_Canvas_LeftButton 
                      If (\Flag\MultiSelect And Not Control)
                       \items()\Color\State = 2
                      ElseIf Not \Flag\ClickSelect
                        \items()\Color\State = 1
                      EndIf
                    EndIf
                  EndIf
                  
                  If \Canvas\Mouse\Buttons & #PB_Canvas_LeftButton And itemSelect(Item, \Items())
                    If Not \Flag\ClickSelect And (\Flag\MultiSelect And Not Control)
                       \Items()\Line = \Items()\Item
                       \items()\Color\State = 2
                    EndIf
                  EndIf
                  
                  \Line = Item
                   Repaint = #True
                EndIf
                
                If \Canvas\Mouse\Buttons & #PB_Canvas_LeftButton
                  If (\Flag\MultiSelect And Not Control)
                    PushListPosition(\Items()) 
                    ForEach \Items()
                      If  Not \Items()\Hide
                        If ((\Line[1] =< \Line And \Line[1] =< \Items()\Item And \Line >= \Items()\Item) Or
                            (\Line[1] >= \Line And \Line[1] >= \Items()\Item And \Line =< \Items()\Item)) 
                          If \Items()\Line <> \Items()\Item
                            \Items()\Line = \Items()\Item
                            \items()\Color\State = 2
                          EndIf
                        Else
                          \Items()\Line =- 1
                          \Items()\Color\State = 1
                          \Items()\Focus =- 1
                        EndIf
                      EndIf
                    Next
                    PopListPosition(\Items()) 
                  EndIf
                
; ; ;                   If \Line[1] =< \Line
; ; ;                     PushListPosition(\Items()) 
; ; ;                     While PreviousElement(\Items()) And \Line[1] < \Items()\Item And Not \Items()\Hide
; ; ;                       If \Items()\Line <> \Items()\Item
; ; ;                         \Items()\Line = \Items()\Item
; ; ;                         \items()\Color\State = 2
; ; ;                       EndIf
; ; ;                     Wend
; ; ;                     PopListPosition(\Items()) 
; ; ;                     PushListPosition(\Items()) 
; ; ;                     While NextElement(\Items()) And \Items()\Line = \Items()\Item And Not \Items()\Hide
; ; ;                       \Items()\Line =- 1
; ; ;                       \Items()\Color\State = 1
; ; ;                       \Items()\Focus =- 1
; ; ;                     Wend
; ; ;                     PopListPosition(\Items()) 
; ; ;                     PushListPosition(\Items()) 
; ; ;                     If \Line[1] = \Line And PreviousElement(\Items()) And \Items()\Line = \Items()\Item And Not \Items()\Hide
; ; ;                       \Items()\Line =- 1
; ; ;                       \Items()\Color\State = 1
; ; ;                       \Items()\Focus =- 1
; ; ;                     EndIf
; ; ;                     PopListPosition(\Items()) 
; ; ;                   ElseIf \Line[1] > \Line
; ; ;                     PushListPosition(\Items()) 
; ; ;                     While NextElement(\Items()) And \Line[1] > \Items()\Item And Not \Items()\Hide
; ; ;                       If \Items()\Line <> \Items()\Item
; ; ;                         \Items()\Line = \Items()\Item
; ; ;                         \items()\Color\State = 2
; ; ;                       EndIf
; ; ;                     Wend
; ; ;                     PopListPosition(\Items()) 
; ; ;                     PushListPosition(\Items()) 
; ; ;                     While PreviousElement(\Items()) And \Items()\Line = \Items()\Item And Not \Items()\Hide
; ; ;                       \Items()\Line =- 1
; ; ;                       \Items()\Color\State = 1
; ; ;                       \Items()\Focus =- 1
; ; ;                     Wend
; ; ;                     PopListPosition(\Items()) 
; ; ;                   EndIf
                EndIf
                
              Default
                itemSelect(\Line[1], \Items())
            EndSelect
          EndIf
        EndWith    
        
        With *This\items()
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
      *This\Line =- 1
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_ListView
        \Cursor = #PB_Cursor_Default
        \DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        \Canvas\Window = GetActiveWindow()
        \Radius = Radius
        \Alpha = 255
        \Interact = 1
        \Caret[1] =- 1
        \Line =- 1
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
        
        \fSize = Bool(Not Flag&#PB_Flag_BorderLess)+1
        \bSize = \fSize
        
        If Text::Resize(*This, X,Y,Width,Height, Canvas)
          \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
          \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
          \Flag\NoButtons = Bool(flag&#PB_Flag_NoButtons)
          \Flag\NoLines = Bool(flag&#PB_Flag_NoLines)
          \Flag\FullSelection = Bool(flag&#PB_Flag_FullSelection)
          \Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
          \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)
          \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
          
          \Text\Vertical = Bool(Flag&#PB_Text_Vertical)
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
          
          \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
          \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          \Text\Align\Right = Bool(Flag&#PB_Text_Right)
          \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+5
            Else
              \Text\X = \fSize+5
              \Text\y = \fSize
            EndIf
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+1
            Else
              \Text\X = \fSize+1
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
          
          \Text\Change = 1
          \Color = Colors
          \Color\Fore[0] = 0
          
          If \Text\Editable
            \Text\Editable = 0
            \Color[0]\Back[0] = $FFFFFFFF 
          Else
            \Color[0]\Back[0] = $FFF0F0F0  
          EndIf
          
        EndIf
        
        Scroll::Widget(\vScroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 7)
        Scroll::Resizes(\vScroll, \hScroll, \x[2],\Y[2],\Width[2],\Height[2])
        \Resize = 0
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
        Text::ReDraw(*This)
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

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile

If OpenWindow(0, 100, 50, 530, 700, "ListViewGadget", #PB_Window_SystemMenu)
  ListViewGadget(0, 10, 10, 250, 680, #PB_ListView_MultiSelect)
  ListView::Gadget(1, 270, 10, 250, 680, #PB_Flag_FullSelection|#PB_Flag_GridLines|#PB_Flag_MultiSelect)
  LN = 150
  
  For a = 0 To LN
    ListView::AddItem (1, -1, "Item "+Str(a), 0,1)
  Next
;   Define time = ElapsedMilliseconds()
;   For a = 0 To LN
;     ListView::SetItemState(1, a, 1) ; set (beginning with 0) the tenth item as the active one
;     If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
;     EndIf
;     If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
;       Debug a
;     EndIf
;   Next
;   Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + Editor::CountItems(1)
  
  Text::Redraw(GetGadgetData(1), 1)
  
  ; HideGadget(0, 1)
  For a = 0 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0, Random(5)+1)
  Next
;   Define time = ElapsedMilliseconds()
;   For a = 0 To LN
;     SetGadgetItemState(0, a, 1) ; set (beginning with 0) the tenth item as the active one
;     If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
;     EndIf
;     If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
;       Debug a
;     EndIf
;   Next
;   Debug Str(ElapsedMilliseconds()-time) + " - add gadget items time count - " + CountGadgetItems(0)
  ; HideGadget(0, 0)
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf

  
  Define a,i
  Define g, Text.s
  ; Define m.s=#CRLF$
  Define m.s;=#LF$
  
  Text.s = "This is a long line" + m.s +
           "Who should show," + m.s +
           "I have to write the text in the box or not." + m.s +
           "The string must be very long" + m.s +
           "Otherwise it will not work."
  
  Procedure ResizeCallBack()
    ;ResizeGadget(100, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-62, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-30, #PB_Ignore, #PB_Ignore)
    ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    CompilerIf #PB_Compiler_Version =< 546
      PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
    CompilerEndIf
  EndProcedure
  
  Procedure SplitterCallBack()
    PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 16)
  CompilerElse
    LoadFont(0, "Arial", 11)
  CompilerEndIf 
  
  If OpenWindow(0, 0, 0, 422, 491, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ;ButtonGadget(100, 490-60,490-30,67,25,"~wrap")
    
    ListViewGadget(0, 8, 8, 306, 233) ;: SetGadgetText(0, Text.s) 
    For a = 0 To 2
      AddGadgetItem(0, a, "Line "+Str(a)+ " of the Listview")
    Next
    AddGadgetItem(0, a, Text)
    For a = 4 To 16
      AddGadgetItem(0, a, "Line "+Str(a)+ " of the Listview")
    Next
    SetGadgetFont(0, FontID(0))
    
    
    g=16
    ListView::Gadget(g, 8, 133+5+8, 306, 233, #PB_Flag_GridLines) ;: ListView::SetText(g, Text.s) 
    For a = 0 To 2
      ListView::AddItem(g, a, "Line "+Str(a)+ " of the Listview")
    Next
    ListView::AddItem(g, a, Text)
    For a = 4 To 16
      ListView::AddItem(g, a, "Line "+Str(a)+ " of the Listview")
    Next
    ListView::SetFont(g, FontID(0))
    
    SplitterGadget(10,8, 8, 306, 491-16, 0,g)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    ; Debug "высота "+GadgetHeight(0) +" "+ GadgetHeight(g)
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_Gadget
          If EventGadget() = 100
            Select EventType()
              Case #PB_EventType_LeftClick
                Define *E.Widget_S = GetGadgetData(g)
                
            EndSelect
          EndIf
          
        Case #PB_Event_LeftClick  
          SetActiveGadget(0)
        Case #PB_Event_RightClick 
          SetActiveGadget(10)
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -------------------0f-f----------------------------
; EnableXP
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ---------80fz-
; EnableXP