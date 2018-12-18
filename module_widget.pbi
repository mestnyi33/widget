;
; Os              : All
; Module name     : Widget
; Version         : 0.0.0.1
; Author          : mestnyi
; License         : Free
; PB version:     : 5.46 =< 5.62
; Last updated    : 4 oct 2018
; File name       : module_widget.pbi
; Topic           : 
;
; ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC045ZWQqqZ/A0QtEXnbMaPMSgYQeocF1xmZe+99U5IMoSltVwZ3wSuOHdsJEYSLxmMLsFk7EdOV5lgH0ZSeVe+qqz4M3q3lcSzQ8f2l3Dvq/svqW8tGFEYbZ4tbgCSveLZQ3LGTwTqCzeYZELr+2awNC5ykraMCzvgPK2OcclEACkJ0m6E++e+gRuhrMfnf0c4iLmxxSLDmEaCA2XjQKMFjV0uPWu55W7qtHEDZx7f7MXTV6/KlaUcp9+S9bbDWa852vV04GTUM0+YHJwyaB3GLskEwDoWm1nbBGqfVCO+gHao4WStJ0/6pha4MZVL28SXRvYTko7fqfjt5bRkBnaqrP4b6au3PiO3cMr3NTCVPLnRserMjk7UuPWkFUchFL8ODqdt/BD5lzQ4+q+dxXaMYC++q/z6x95Ja+s43wMDZLepG61wGcG2ftbQhxjsETbJTy/cNU6ing07wdkbTckAhz5Gue4OfB+vwlMZi3F35aCeq+FG8UzPOlQH122X9VPuowTJdVWYM5qqmmgrGkkaePvYYarruxMrtsoq8wY4hBs4WWyaq4zvJyUZTBfDzTsv8kWQxuPQ8wKMT4Mpo5H+CZrjCBsFtidu/LJ8FxFxOFcxik9o2tyxscuikYMoEW4sBkKpQeMESz+tXmXcxZwaa/8YEGL10s2uc4iI2ul99w==

XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_scroll.pbi"
XIncludeFile "module_text.pbi"
XIncludeFile "module_button.pbi"
XIncludeFile "module_string.pbi"
; XIncludeFile "module_editor.pbi"
; XIncludeFile "module_tree.pbi"
; XIncludeFile "module_listicon.pbi"


DeclareModule Widget
  
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  Declare.s GetText(Widget.i)
  Declare.i SetText(Widget.i, Text.s)
  Declare.i SetFont(Widget.i, FontID.i)
  Declare.i GetColor(Widget.i, ColorType.i)
  Declare.i SetColor(Widget.i, ColorType.i, Color.i)
  
  Declare.i GetState(Widget.i)
  Declare.i SetState(Widget.i, State.i)
  Declare.i GetAttribute(Widget.i, Attribute.i)
  Declare.i SetAttribute(Widget.i, Attribute.i, Value.i)
  
  Declare.i Text(Widget.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0)
  Declare.i Button(Widget.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0)
  Declare.i ScrollBar(Widget.i, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, Pagelength.i, Flag.i=0)
  Declare.i String(Widget.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0)
  
EndDeclareModule

Module Widget
  ;-
  Procedure.i Draws(*This.Widget_S)
    With *This
      If StartDrawing(CanvasOutput(\Canvas\Gadget))
        Select \Type
          Case #PB_GadgetType_Text   : Text::Draw(*This)
          Case #PB_GadgetType_Button : Button::Draw(*This)
          Case #PB_GadgetType_String : String::Draw(*This)
          Case #PB_GadgetType_ScrollBar : Scroll::Draw(\Scroll\v)
        EndSelect
        
        StopDrawing()
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Resizes(*This.Widget_S, X.i,Y.i,Width.i,Height.i)
    With *This
      
      ;       Select \Type
      ;         Case #PB_GadgetType_ScrollBar
      ;           Scroll::Resize(\Scroll\v, X,Y,Width,Height)
      ;           \Resize = 1
      ;         Default
      If X<>#PB_Ignore 
        \X[0] = X 
        \X[2]=\bSize
        \X[1]=\X[2]-\fSize
        \Resize = 1
      EndIf
      If Y<>#PB_Ignore 
        \Y[0] = Y
        \Y[2]=\bSize
        \Y[1]=\Y[2]-\fSize
        \Resize = 2
      EndIf
      If Width<>#PB_Ignore 
        \Width[0] = Width 
        \Width[2] = \Width-\bSize*2
        \Width[1] = \Width[2]+\fSize*2
        \Resize = 3
      EndIf
      If Height<>#PB_Ignore 
        \Height[0] = Height 
        \Height[2] = \Height-\bSize*2
        \Height[1] = \Height[2]+\fSize*2
        \Resize = 4
      EndIf
      ;       EndSelect
      
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  
  
  ;-
  Procedure.s GetText(Widget.i)
    Protected *This.Widget_S = GetGadgetData(Widget)
    ProcedureReturn *This\Text\String.s
  EndProcedure
  
  Procedure.i SetText(Widget.i, Text.s)
    Protected Result, *This.Widget_S = GetGadgetData(Widget)
    
    If *This\Text\String.s <> Text.s
      *This\Text\String.s = Text.s
      *This\Text\Change = #True
      Result = #True
      Draws(*This)
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetFont(Widget.i, FontID.i)
    Protected Result, *This.Widget_S = GetGadgetData(Widget)
    
    If *This\Text\FontID <> FontID
      *This\Text\FontID = FontID
      Result = #True
      Draws(*This)
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetColor(Widget.i, ColorType.i, Color.i)
    Protected Result, *This.Widget_S = GetGadgetData(Widget)
    
    With *This
      Select ColorType
        Case #PB_Gadget_LineColor
          If \Color\Line <> Color 
            \Color\Line = Color
            Result = #True
          EndIf
          
        Case #PB_Gadget_BackColor
          If \Color\Back <> Color 
            \Color\Back = Color
            Result = #True
          EndIf
          
        Case #PB_Gadget_FrontColor
          If \Color\Front <> Color 
            \Color\Front = Color
            Result = #True
          EndIf
          
        Case #PB_Gadget_FrameColor
          If \Color\Frame <> Color 
            \Color\Frame = Color
            Result = #True
          EndIf
          
      EndSelect
    EndWith
    
    If Result
      Draws(*This)
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetColor(Widget.i, ColorType.i)
    Protected Color.i, *This.Widget_S = GetGadgetData(Widget)
    
    With *This
      Select ColorType
        Case #PB_Gadget_LineColor  : Color = \Color\Line
        Case #PB_Gadget_BackColor  : Color = \Color\Back
        Case #PB_Gadget_FrontColor : Color = \Color\Front
        Case #PB_Gadget_FrameColor : Color = \Color\Frame
      EndSelect
    EndWith
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure.i SetState(Widget.i, State.i)
    Protected Result.b, *This.Widget_S = GetGadgetData(Widget)
    
    With *This
      Select \Type
        Case #PB_GadgetType_Button
          If Button::SetState(*This, State)
            Result = 1
          EndIf
          
        Case #PB_GadgetType_ScrollBar  
          If Scroll::SetState(*This\Scroll\v, State) 
            PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
            Result = 1
          EndIf
      EndSelect
    EndWith
    
    If Result  
      Draws(*This)
    EndIf     
    
  EndProcedure
  
  Procedure.i GetState(Widget.i)
    Protected *This.Widget_S = GetGadgetData(Widget)
    
    With *This
      Select \Type
        Case #PB_GadgetType_ScrollBar  
         ; ProcedureReturn *This\Scroll\v\Page\Pos
      EndSelect
    EndWith
  EndProcedure
  
  Procedure.i SetAttribute(Widget.i, Attribute.i, Value.i)
    Protected *This.Widget_S = GetGadgetData(Widget)
    
    With *This
      Select \Type
        Case #PB_GadgetType_ScrollBar  
          If Scroll::SetAttribute(\Scroll\v, Attribute, Value)
            Draws(*This)
          EndIf
          
      EndSelect
    EndWith
  EndProcedure
  
  Procedure.i GetAttribute(Widget.i, Attribute.i)
    Protected Result, *This.Widget_S = GetGadgetData(Widget)
    
    With *This
      Select \Type
        Case #PB_GadgetType_ScrollBar  
          Select Attribute
;             Case #PB_ScrollBar_Minimum    : Result = \Scroll\v\Min
;             Case #PB_ScrollBar_Maximum    : Result = \Scroll\v\Max
;             Case #PB_ScrollBar_PageLength : Result = \Scroll\v\Page\Length
          EndSelect
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  ;-
  Procedure.i CallBacks()
    Protected Repaint, *This.Widget_S = GetGadgetData(EventGadget())
    
    With *This
      \Canvas\Window = EventWindow()
      \Canvas\Input = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Input)
      \Canvas\Key = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Key)
      \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
      \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
      \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
      \Canvas\Mouse\Buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
      \Canvas\Mouse\at = Bool(\Canvas\Mouse\X>=\x And \Canvas\Mouse\X<\x+\Width And \Canvas\Mouse\Y>=\y And \Canvas\Mouse\Y<\y+\Height)
            
      Select EventType()
        Case #PB_EventType_LostFocus : Repaint = 1
          \Focus = 0
          
        Case #PB_EventType_Repaint : Repaint = 1
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint = Resizes(*This, #PB_Ignore,#PB_Ignore,GadgetWidth(\Canvas\Gadget),GadgetHeight(\Canvas\Gadget))
      EndSelect
      
      Select \Type
        Case #PB_GadgetType_Button
          Repaint | Button::CallBack(*This, EventType())
          
        Case #PB_GadgetType_String
          Repaint | String::CallBack(*This, EventType()) 
          
        Case #PB_GadgetType_ScrollBar  
          Repaint | Scroll::CallBack(\Scroll\v, EventType(), \Canvas\Mouse\X, \Canvas\Mouse\Y);, WheelDelta) 
          
      EndSelect
      
      If Repaint
        Draws(*This)
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i ScrollBar(Widget.i, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, Pagelength.i, Flag.i=0)
    Protected *This.Widget_S=AllocateStructure(Widget_S)
    Protected g = CanvasGadget(Widget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Widget=-1 : Widget=g : EndIf
    
    If *This
      With *This
         \Canvas\Gadget = Widget
         \Canvas\window = GetActiveWindow()
         \Type = #PB_GadgetType_ScrollBar
         
         \Scroll\v = Scroll::Bar(0, 0, Width, Height, Min, Max, Pagelength, Flag)
         
         \Scroll\v\ArrowType[1]=1 : \Scroll\v\ArrowType[2]=1     ; Можно менять вид стрелок 
         \Scroll\v\ArrowSize[1]=6 : \Scroll\v\ArrowSize[2]=6     ; Можно задать размер стрелок
         
        SetGadgetData(Widget, *This)
        BindGadgetEvent(Widget, @CallBacks())
        PostEvent(#PB_Event_Gadget, GetActiveWindow(), Widget, #PB_EventType_Repaint, *This)
      EndIf
    EndWith
    
    ProcedureReturn g
  EndProcedure
  
  Procedure.i Button(Widget.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0)
    Protected *This.Widget_S=AllocateStructure(Widget_S)
    Protected g = CanvasGadget(Widget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Widget=-1 : Widget=g : EndIf
    
    If *This
      With *This
        Button::Widget(*This, Widget, 0, 0, Width, Height, Text.s, Flag);, 29)
        SetGadgetData(Widget, *This)
        BindGadgetEvent(Widget, @CallBacks())
        PostEvent(#PB_Event_Gadget, GetActiveWindow(), Widget, #PB_EventType_Repaint, *This)
      EndIf
    EndWith
    
    ProcedureReturn g
  EndProcedure
  
  Procedure.i String(Widget.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0)
    Protected *This.Widget_S=AllocateStructure(Widget_S)
    Protected g = CanvasGadget(Widget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Widget=-1 : Widget=g : EndIf
    
    If *This
      With *This
        String::Widget(*This, Widget, 0, 0, Width, Height, Text.s, Flag)
        SetGadgetData(Widget, *This)
        BindGadgetEvent(Widget, @CallBacks())
        PostEvent(#PB_Event_Gadget, GetActiveWindow(), Widget, #PB_EventType_Repaint, *This)
      EndIf
    EndWith
    
    ProcedureReturn g
  EndProcedure
  
  Procedure.i Text(Widget.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0)
    Protected *This.Widget_S=AllocateStructure(Widget_S)
    Protected g = CanvasGadget(Widget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Widget=-1 : Widget=g : EndIf
    
    If *This
      With *This
        Text::Widget(*This, Widget, 0, 0, Width, Height, Text.s, Flag)
        SetGadgetData(Widget, *This)
        BindGadgetEvent(Widget, @CallBacks())
        PostEvent(#PB_Event_Gadget, GetActiveWindow(), Widget, #PB_EventType_Repaint, *This)
      EndIf
    EndWith
    
    ProcedureReturn g
  EndProcedure
  
EndModule

UseModule Widget


  
;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  Procedure v_GadgetCallBack()
    SetState(13, GetGadgetState(EventGadget()))
  EndProcedure
  
  Procedure v_CallBack()
    SetGadgetState(3, GetState(EventGadget()))
  EndProcedure
  
  Procedure h_GadgetCallBack()
    ;Debug "gadget - "+GetGadgetState(EventGadget())
    SetState(12, GetGadgetState(EventGadget()))
  EndProcedure
  
  Procedure h_CallBack()
    ;Debug "widget - "+GetState(EventGadget())
    SetGadgetState(2, GetState(EventGadget()))
  EndProcedure
  
  Procedure Events()
    Debug "window "+EventWindow()+" widget "+EventGadget()+" eventtype "+EventType()+" eventdata "+EventData()
  EndProcedure
  
  If OpenWindow(0, 0, 0, 605, 300, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    StringGadget     (-1,  10, 25, 250,  20, "ScrollBar Standard  (start=50, page=30/100)");,#PB_Text_Center)
    ScrollBarGadget  (2,  10, 50, 250,  20, 30, 100, 30)
    SetGadgetState   (2,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  10,115, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ScrollBarGadget  (3, 270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    SetGadgetState   (3, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    ButtonGadget(15, 10, 190, 180,  60, "Button (Horizontal)")
    ButtonGadget(16, 200, 150,  60, 140 ,"Button (Vertical)")
    
    String     (-1,  300+10, 25, 250,  20, "ScrollBar Standard  (start=50, page=30/100)");,#PB_Text_Center)
    ScrollBar  (12,  300+10, 50, 250,  20, 30, 100, 30)
    SetState   (12,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    Text       (-1,  300+10,115, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ScrollBar  (13, 300+270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    SetState   (13, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    Button(17, 300+10, 190, 180,  60, "Button (Horizontal)")
    Button(18, 300+200, 150,  60, 140 ,"Button (Vertical)",#PB_Flag_Vertical)
    
    PostEvent(#PB_Event_Gadget, 0,12,#PB_EventType_Resize)
    
    BindEvent(#PB_Event_Widget, @Events())
    
    BindGadgetEvent(2,@h_GadgetCallBack())
    BindGadgetEvent(3,@v_GadgetCallBack())
    
    BindGadgetEvent(12,@h_CallBack(), #PB_EventType_Change)
    BindGadgetEvent(13,@v_CallBack(), #PB_EventType_Change)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -----------
; EnableXP