IncludePath "../../"
XIncludeFile "widgets.pbi"
UseLib(widget)

Global Window_3

Global AlignResult, L_Button, T_Button, R_Button, B_Button, LT_Button, RT_Button, LB_Button, RB_Button, C_Button, S_Screen, C_Add, Sha
Global S_Left, S_Top, S_Right, S_Bottom, T_Z, L_Z, R_Z, B_Z, L_L, L_R, L_C, T_T, R_R, B_B, T_B, T_C, R_L, R_C, B_T, B_C

UsePNGImageDecoder()

Procedure  Additinal()
  If WindowWidth(Window_3)< = 120
    ResizeWindow(Window_3,#PB_Ignore,#PB_Ignore,390,#PB_Ignore)
  Else
    ResizeWindow(Window_3,#PB_Ignore,#PB_Ignore,120,#PB_Ignore)
  EndIf  
EndProcedure

Macro ResetStatic()
  L = 0
  T = 0
  R = 0
  B = 0
  LT = 0
  RT = 0
  RB = 0
  LB = 0
  SetState(L_Button,0)
  SetState(T_Button,0)
  SetState(R_Button,0)
  SetState(B_Button,0)
  SetState(LT_Button,0)
  SetState(LB_Button,0)
  SetState(RT_Button,0)
  SetState(RB_Button,0)
EndMacro

Procedure SetAlign(Sha, x,y)
  Static L,LT,T,RT,R,RB,B,LB,C,Result
  
  L = GetState(L_Button)
  T = GetState(T_Button)
  R = GetState(R_Button)
  B = GetState(B_Button)
  
  LT = GetState(LT_Button)
  RT = GetState(RT_Button)
  RB = GetState(RB_Button)
  LB = GetState(LB_Button)
  
  C = GetState(C_Button)
  
  
  If (L = #True And R = #True And T = #True And B = #True)
    Result = 9
    
  ElseIf L = #True And T = #True And R = #True
    Result = 11
  ElseIf L = #True And B = #True And R = #True
    Result = 13
  ElseIf T = #True And R = #True And B = #True
    Result = 12
  ElseIf T = #True And L = #True And B = #True
    Result = 10
    
  ElseIf L = #True And T = #True
    Result = 2
  ElseIf L = #True And B = #True
    Result = 8
  ElseIf R = #True And T = #True
    Result = 4
  ElseIf R = #True And B = #True
    Result = 6
    
  ElseIf L = #True And R = #True
    Result = 14
  ElseIf T = #True And B = #True
    Result = 15
    
  Else
    If     L = #True : Result = 1
    ElseIf T = #True : Result = 3
    ElseIf R = #True : Result = 5
    ElseIf B = #True : Result = 7
    EndIf
  EndIf
  
  If L = #True Or T = #True Or R = #True Or B = #True
    SetState(LT_Button,0)
    SetState(RT_Button,0)
    SetState(RB_Button,0)
    SetState(LB_Button,0)
  EndIf
 
  
  Select Result
    Case 0  : Resize(Sha, 19,19,21,21)
    Case 1  : Resize(Sha, 0,19,21,21)
    Case 3  : Resize(Sha, 19,0,21,21)
    Case 5  : Resize(Sha, 38-1,19,21,21) 
    Case 7  : Resize(Sha, 19,38-1,21,21)
      
    Case 10 : Resize(Sha, 0,0,40,60-2)
    Case 11 : Resize(Sha, 0,0,60-2,40)
    Case 12 : Resize(Sha, 19,0,40,60-2)
    Case 13 : Resize(Sha, 0,19,60-2,40)
    Case 14 : Resize(Sha, 0,19,60-2,21)
    Case 15 : Resize(Sha, 19,0,21,60-2)
      
    Case 2  : Resize(Sha, 0,0,21,21)
    Case 4  : Resize(Sha, 38-1,0,21,21)
    Case 6  : Resize(Sha, 38-1,38-1,21,21)
    Case 8  : Resize(Sha, 0,38-1,21,21)
    Case 9  : Resize(Sha, 0,0,60-2,60-2)
  EndSelect
EndProcedure


Procedure AliginsEvent()
  Protected Ev = *event\widget

  
  Select Ev
    Case LT_Button 
      If LT = #True
        SetAlign(Sha, 0,0)
        
        Result = 2
      Else
        If B And R
          SetAlign(Sha, 1,1)
          
          Result = 9
        EndIf
      EndIf
      
    Case LB_Button 
      If LB = #True
        SetAlign(Sha, 0,2)
        
        Result = 8
      Else
        If T And R
          SetAlign(Sha, 1,1)
          
          Result = 9
        EndIf
      EndIf
      
    Case RT_Button   
      If RT = #True
        SetAlign(Sha, 2,0)
        
        Result = 4
      Else
        If L And B
          
          Result = 9
        EndIf
      EndIf
      
    Case RB_Button     
      If RB = #True
        SetAlign(Sha, 2,2)
        
        Result = 6
      Else
        If L And T
          SetAlign(Sha, 1,1)
          
          Result = 9
        EndIf
      EndIf
      
    Case C_Button
      SetAlign(Sha, 1,1)
      Result = 0
      
    Default
      If L = 0 And T = 0 And R = 0 And B = 0
        SetAlign(Sha, 1,1)
  
        Result = 0
      EndIf
      
  EndSelect 
  
EndProcedure

Procedure AlignWindow(x = 0, y = 0, width = 120, height = 140)
  Window_3  = OpenWindow(#PB_Any, x, y, width, height, "Привязка выбраных гаджетов", #PB_Window_SystemMenu | #PB_Window_Tool | #PB_Window_Invisible)
  Open(Window_3)
  
  L_Button  = Button(10, 30, 15, 60, "", #__button_Toggle|#__button_vertical, -1, 7) ;:ToolTip(L_Button,  "Включить привязку (влево)")
  T_Button  = Button(30, 10, 60, 15, "", #__button_Toggle, -1, 7)                    ;:ToolTip(T_Button,  "Включить привязку (верх)")
  R_Button  = Button(95, 30, 15, 60, "", #__button_Toggle|#__button_vertical|#__button_inverted, -1, 7) ;:ToolTip(R_Button,  "Включить привязку (вправо)")
  B_Button  = Button(30, 95, 60, 15, "", #__button_Toggle|#__button_inverted, -1, 7)                    ;:ToolTip(B_Button,  "Включить привязку (вниз)")
  LT_Button = Button(10, 10, 15, 15, "", #__button_Toggle, -1, 7)                                       ;:ToolTip(LT_Button, "Включить привязку (влево верх)")
  RT_Button = Button(95, 10, 15, 15, "", #__button_Toggle, -1, 7)                                       ;:ToolTip(RT_Button, "Включить привязку (вправо верх)")
  LB_Button = Button(10, 95, 15, 15, "", #__button_Toggle, -1, 7)                                       ;:ToolTip(LB_Button, "Включить привязку (влево вниз)")
  RB_Button = Button(95, 95, 15, 15, "", #__button_Toggle, -1, 7)                                       ;:ToolTip(RB_Button, "Включить привязку (вправо вниз)")
  
  S_Screen = Container(30, 30, 60, 60);, "", #__button_Toggle) :Disable(S_Screen,1)
                                      ;Define *c._s_widget = S_Screen : *c\round = 9
  Sha = Text(0, 0, 21, 21, "", #__text_border) : SetColor(Sha, #__color_back, $ff00f0f0)
  C_Button  = Button(22, 22, 15, 15, "", 0, -1, 7)                    ;:ToolTip(C_Button,  "Включить привязку (вцентре)")
  CloseList()
  
  SetState(L_Button, 1)
  SetState(T_Button, 1)
  SetState(RB_Button, 1)
  
  ;SetState(LT_Button, 1)
  ; Post(#PB_EventType_LeftClick, LT_Button)
  
  C_Add = Button(10, 115, 100, 15, ">", #__button_Toggle)
  ; ToolTip(C_Add, "Дополнительные параметры")
  
  
  
  
  
  
  
  
  
  ; BindGadgetEvent(C_Add,@Additinal())
  Bind(#PB_All, @AliginsEvent());, Window_3)
EndProcedure

Procedure ShowAlignWindow()
  x = DesktopMouseX()+20
  y = DesktopMouseY()-10
  ResizeWindow(Window_3,x, y,#PB_Ignore,#PB_Ignore)
  HideWindow(Window_3,0)
EndProcedure

AlignWindow()
ShowAlignWindow()

Repeat :Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ----
; EnableXP