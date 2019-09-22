CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElse
  IncludePath "../"
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_draw.pbi"
  
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_bar.pbi"
  XIncludeFile "module_text.pbi"
  XIncludeFile "module_button.pbi"
  XIncludeFile "module_editor.pbi"
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
CompilerEndIf


DeclareModule ScrollArea
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
;   ;- STRUCTURE
;   Structure Coordinate
;     y.l[3]
;     x.l[3]
;     Height.l[3]
;     Width.l[3]
;   EndStructure
;   
;   Structure Mouse
;     X.l
;     Y.l
;     Buttons.l
;   EndStructure
;   
;   Structure Canvas
;     Mouse.Mouse
;     Gadget.l[3]
;     Window.l
;     
;     Input.c
;     Key.l[2]
;     
;   EndStructure
;   
;   Structure Gadget Extends Coordinate
;     FontID.l
;     Canvas.Canvas
;     
;     Pos.l[2] ; 0 = Pos ; 1 = PosFixed
;     CaretPos.l[2] ; 0 = Pos ; 1 = PosFixed
;     CaretLength.l
;     
;     ImageID.l[3]
;     Color.l[3]
;     
;     Image.Coordinate
;     
;     fSize.l
;     bSize.l
;     Hide.b[2]
;     Disable.b[2]
;     
;     Scroll.Coordinate
;     vScroll.Scroll::Struct
;     hScroll.Scroll::Struct
;     
;     Type.l
;     InnerCoordinate.Coordinate
;     
;     Repaint.l
;     
;     List Items.Widget_S()
;     List Columns.Widget_S()
;   EndStructure
;   
  
  ;- DECLARE
  Declare CloseList()
  Declare OpenList(Gadget.l)
  Declare SetColor(Gadget.l, ColorType.l, Color.l)
  Declare GetAttribute(Gadget.l, Attribute.l)
  Declare SetAttribute(Gadget.l, Attribute.l, Value.l)
  Declare Gadget(Gadget, X.l, Y.l, Width.l, Height.l, Min.l, Max.l, Pagelength.l, Flag.l=0)
  
EndDeclareModule

Module ScrollArea
  
  ;- PROCEDURE
  
  Procedure Re(*This.Widget_S)
    With *This
      ResizeGadget(\Canvas\Gadget[1], #PB_Ignore,#PB_Ignore,Scroll::X(\Scroll\v)-*This\fSize, Scroll::Y(\Scroll\h)-*This\fSize)
      ResizeGadget(\Canvas\Gadget[2],\Scroll\X+*This\fSize, \Scroll\Y+*This\fSize, #PB_Ignore,#PB_Ignore)
    EndWith   
  EndProcedure
  
  Procedure Draw(*This.Widget_S)
    With *This
      If StartDrawing(CanvasOutput(\Canvas\Gadget))
        ; DrawingFont(GetGadgetFont(#PB_Default))
        
        If \fSize
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\X[1],\Y[1],\Width[1],\Height[1],\Color\Frame[\Color\State])
        EndIf
        
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X[2],\Y[2],\Width[2],\Height[2], $FFFFFF)
        
        Scroll::Draw(*This\Scroll\v)
        Scroll::Draw(*This\Scroll\h)
        
        StopDrawing()
      EndIf
      
      If GadgetType(\Canvas\Gadget[2]) = #PB_GadgetType_Canvas And StartDrawing(CanvasOutput(\Canvas\Gadget[1]))
        DrawingMode(#PB_2DDrawing_Default)
        Box(1,1,OutputWidth(), OutputHeight(),\Color\Back[\Color\State])
        StopDrawing()
      EndIf
      
      If GadgetType(\Canvas\Gadget[2]) = #PB_GadgetType_Canvas And StartDrawing(CanvasOutput(\Canvas\Gadget[2]))
        DrawingMode(#PB_2DDrawing_Default)
        Box(2,2,OutputWidth(), OutputHeight(),\Color\Back[\Color\State])
        StopDrawing()
      EndIf
      
    EndWith  
  EndProcedure
  
  Procedure ReDraw(*This.Widget_S)
    Re(*This)
    Draw(*This)
  EndProcedure
  
  Procedure CallBack()
    Protected Repaint, *This.Widget_S = GetGadgetData(EventGadget())
    
    With *This
      \Canvas\Window = EventWindow()
      \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
      \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
      \Canvas\Mouse\Buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
      
      Select EventType()
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          \Width = GadgetWidth(\Canvas\Gadget)
          \Height = GadgetHeight(\Canvas\Gadget)
          
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
          
          Scroll::Resizes(*This\Scroll, *This\x[2]+1,*This\Y[2]+1,*This\Width[2]-2,*This\Height[2]-2)
          ReDraw(*This)
      EndSelect   
      
      Repaint = Scroll::CallBack(*This\Scroll\v, EventType(), \Canvas\Mouse\X, \Canvas\Mouse\Y)
      If Repaint 
        ReDraw(*This)
        If \Canvas\Mouse\Buttons
          PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
        EndIf
      EndIf
      
      Repaint = Scroll::CallBack(*This\Scroll\h, EventType(), \Canvas\Mouse\X, \Canvas\Mouse\Y)
      If Repaint
        ReDraw(*This) 
        If \Canvas\Mouse\Buttons 
          PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
        EndIf
      EndIf
    EndWith
    
  EndProcedure
  
  ;- PUBLIC
  Procedure SetAttribute(Gadget.l, Attribute.l, Value.l)
    Protected Repaint
    Protected *This.Widget_S = GetGadgetData(Gadget)
    
    With *This
      Select Attribute
        Case #PB_ScrollArea_InnerWidth    
          ResizeGadget(\Canvas\Gadget[2], #PB_Ignore, #PB_Ignore, Value, #PB_Ignore)
          If Scroll::SetAttribute(*This\Scroll\h, #PB_ScrollBar_Maximum, Value)
            Repaint = #True
          EndIf
          
        Case #PB_ScrollArea_InnerHeight   
          ResizeGadget(\Canvas\Gadget[2], #PB_Ignore, #PB_Ignore, #PB_Ignore, Value)
          If Scroll::SetAttribute(*This\Scroll\v, #PB_ScrollBar_Maximum, Value)
            Repaint = #True
          EndIf
          
      EndSelect
      
      If Repaint
        Draw(*This)
      EndIf    
      
    EndWith
  EndProcedure
  
  Procedure GetAttribute(Gadget.l, Attribute.l)
    Protected Result, *This.Widget_S = GetGadgetData(Gadget)
    
    With *This
      Select Attribute
        Case #PB_ScrollArea_X             : Result =- GadgetX(\Canvas\Gadget[2])-1
        Case #PB_ScrollArea_Y             : Result =- GadgetY(\Canvas\Gadget[2])-1
        Case #PB_ScrollArea_InnerWidth    : Result = GadgetWidth(\Canvas\Gadget[2])
        Case #PB_ScrollArea_InnerHeight   : Result = GadgetHeight(\Canvas\Gadget[2])
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure Gadget(Gadget, X.l, Y.l, Width.l, Height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, ScrollStep.l, Flag.l=0)
    Protected *This.Widget_S=AllocateStructure(Widget_S)
    Protected Min.l, Max.l, PageLength.l, fs = 1
    
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Container|#PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf 
    Protected Gadget1 = ContainerGadget(#PB_Any, fs, fs, Width, Height) ; CanvasGadget(#PB_Any, fs, fs, Width, Height, #PB_Canvas_Container) 
    Protected Gadget2 = ContainerGadget(#PB_Any, 0, 0, ScrollAreaWidth, ScrollAreaHeight) ; CanvasGadget(#PB_Any, 0, 0, ScrollAreaWidth, ScrollAreaHeight, #PB_Canvas_Container)
    CloseGadgetList()
    CloseGadgetList()
    CloseGadgetList()
    
   ; SetGadgetColor(Gadget1, #PB_Gadget_BackColor, $FF0000)
    
    If *This
      With *This
        \Canvas\Gadget = Gadget
        \Canvas\Gadget[1] = Gadget1 
        \Canvas\Gadget[2] = Gadget2 
        
        \Type = #PB_GadgetType_ScrollArea
        \Text\FontID = GetGadgetFont(#PB_Default)
        ;\Text\FontID = GetGadgetFont(Gadget)
        
        \fSize = fs
        \bSize = \fSize
        
        \Width = Width
        \Height = Height
        
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
        
        \Color = Colors
        
        Scroll::Widget(*This\Scroll, *This\Width[2]-17, *This\Y[2], 17, *This\Height[2], 0,ScrollAreaHeight,Height, #PB_ScrollBar_Vertical)
        Scroll::Widget(*This\Scroll, *This\x[2], *This\Height[2]-17, *This\Width[2], 17, 0,ScrollAreaWidth,Width, 0)
        
        ReDraw(*This)
        SetGadgetData(Gadget, *This)
        PostEvent(#PB_Event_Gadget, GetActiveWindow(), Gadget, #PB_EventType_Resize)
        BindGadgetEvent(Gadget, @CallBack())
      EndIf
    EndWith
    
    
    OpenGadgetList(Gadget2)
    ProcedureReturn Gadget
  EndProcedure
  
  Procedure CloseList()
    CloseGadgetList()
  EndProcedure
  
  Procedure OpenList(Gadget.l)
    Protected Result, *This.Widget_S = GetGadgetData(Gadget)
    
    With *This
      OpenGadgetList(\Canvas\Gadget[2])
    EndWith
  EndProcedure
  
  Procedure SetColor(Gadget.l, ColorType.l, Color.l)
    Protected Result, *This.Widget_S = GetGadgetData(Gadget)
    
    With *This
      
      Select ColorType
        Case #PB_Gadget_BackColor
           \Color\Back[\Color\State] = Color
      EndSelect
      
    EndWith
  EndProcedure
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  Global g,a,i
  
  Procedure BindScrollAreaGadgetDatas()
    SetWindowTitle(0, "ScrollAreaGadget " +
                      "(" +
                      GetGadgetAttribute(0, #PB_ScrollArea_X) +
                      "," +                      
                      GetGadgetAttribute(0, #PB_ScrollArea_Y) +
                      ")" )
  EndProcedure
  
  Procedure BindScrollAreaDatas()
    SetWindowTitle(0, "ScrollArea " +
                      "(" +
                      ScrollArea::GetAttribute(g, #PB_ScrollArea_X) +
                      "," +                      
                      ScrollArea::GetAttribute(g, #PB_ScrollArea_Y) +
                      ")" )
  EndProcedure
  
  Procedure ResizeCallBack()
    If IsGadget(15)
      ResizeGadget(15, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-16, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    EndIf
  EndProcedure
  
  If OpenWindow(0, 0, 0, 522, 490, "ScrollAreaGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ScrollAreaGadget(0, 10, 10, 390,220, 575, 555, 30)
    ButtonGadget  (1, 10, 10, 230, 30,"Button 1")
    ButtonGadget  (2, 50, 50, 230, 30,"Button 2")
    ButtonGadget  (3, 90, 90, 230, 30,"Button 3")
    TextGadget    (#PB_Any,130,130, 230, 20,"This is the content of a ScrollAreaGadget!",#PB_Text_Right)
    CloseGadgetList()
    
    
    g=10
    ScrollArea::Gadget(g, 10, 250, 390,220, 575, 555, 30)
    Button::Gadget  (5, 10, 10, 230, 30,"Button 5")
    ButtonGadget  (6, 50, 50, 230, 30,"Button 6")
    Button::Gadget  (7, 90, 90, 230, 30,"Button 7")
    Text::Gadget    (#PB_Any,130,130, 230, 20,"This is the content of a ScrollAreaGadget!",#PB_Text_Right)
    ScrollArea::CloseList()
    
    ; example open parent list
    OpenGadgetList(0)
    ButtonGadget  (4, 575-230, 555-30, 230, 30,"OpenList( Button 4 )")
    CloseGadgetList()
    
    ScrollArea::OpenList(g)
    ButtonGadget  (8, 575-230, 555-30, 230, 30,"OpenList( Button 8 )")
    ScrollArea::CloseList()
    
    ; example set color
    SetGadgetColor(0, #PB_Gadget_BackColor, $47CECC)
    ScrollArea::SetColor(g, #PB_Gadget_BackColor, $47CECC)
    
    SplitterGadget(15,8, 8, 306, 276, 0,g)
    
    BindGadgetEvent(0, @BindScrollAreaGadgetDatas())
    BindGadgetEvent(g, @BindScrollAreaDatas(), #PB_EventType_Change)
    
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    Repeat
      Select WaitWindowEvent()
        Case  #PB_Event_CloseWindow
          End
        Case  #PB_Event_Gadget
          Select EventGadget()
            Case 0
              Select EventType()
                Case #PB_EventType_LeftClick
                  Debug "A Scroll has been used ! (" +
                        Str(GetGadgetAttribute(g, #PB_ScrollArea_X)) +
                        "," +                      
                        Str(GetGadgetAttribute(g, #PB_ScrollArea_Y)) +
                        ")"
              EndSelect
            Case g
              Select EventType()
                Case #PB_EventType_LeftClick
                  Debug ":: A Scroll has been used ! (" +
                        Str(ScrollArea::GetAttribute(g, #PB_ScrollArea_X)) +
                        "," +                      
                        Str(ScrollArea::GetAttribute(g, #PB_ScrollArea_Y)) +
                        ")"
              EndSelect
            Case 1,2,3,4,5,6,7,8
              Select EventType()
                Case #PB_EventType_LeftClick
                  MessageRequester("Info","Button "+Str(EventGadget())+" was pressed!",#PB_MessageRequester_Ok)
              EndSelect
              
          EndSelect
      EndSelect
    ForEver
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS beta 4 (Windows - x64)
; CursorPosition = 12
; FirstLine = 8
; Folding = --------
; EnableXP