IncludePath "../../../"
XIncludeFile "widgets.pbi"
UseLib(widget)

Global Window_3, demo

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

Procedure SetAlign(Ev)
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
  
  Select Ev
    Case LT_Button 
      If LT = #True
        ResetStatic()
        SetState(RB_Button,1)
        SetState(L_Button,1)
        SetState(T_Button,1)
        Result = 2
      Else
        If B And R
          SetState(L_Button,1)
          SetState(T_Button,1)
          SetState(LT_Button,0)
          Result = 9
        EndIf
      EndIf
      
    Case LB_Button 
      If LB = #True
        ResetStatic()
        SetState(L_Button,1)
        SetState(B_Button,1)
        SetState(RT_Button,1)
        Result = 8
      Else
        If T And R
          SetState(L_Button,1)
          SetState(B_Button,1)
          SetState(LB_Button,0)
          Result = 9
        EndIf
      EndIf
      
    Case RT_Button   
      If RT = #True
        ResetStatic()
        SetState(T_Button,1)
        SetState(R_Button,1)
        SetState(LB_Button,1)
        Result = 4
      Else
        If L And B
          SetState(R_Button,1)
          SetState(T_Button,1)
          SetState(RT_Button,0)
          Result = 9
        EndIf
      EndIf
      
    Case RB_Button     
      If RB = #True
        ResetStatic()
        SetState(R_Button,1)
        SetState(B_Button,1)
        SetState(LT_Button,1)
        Result = 6
      Else
        If L And T
          SetState(R_Button,1)
          SetState(B_Button,1)
          SetState(RB_Button,0)
          Result = 9
        EndIf
      EndIf
      
    Case C_Button
      ResetStatic()
      Result = 0
      
    Default
      If L = 0 And T = 0 And R = 0 And B = 0
        ResetStatic()
        Result = 0
      EndIf
      
  EndSelect 
  
  
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
  Protected Ev = EventWidget( )
  
  Select WidgetEvent( )
    Case #__event_LeftClick
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
      
      Select Ev
        Case LT_Button 
          If LT = #True
            ResetStatic()
            SetState(RB_Button,1)
            SetState(L_Button,1)
            SetState(T_Button,1)
            Result = 2
          Else
            If B And R
              SetState(L_Button,1)
              SetState(T_Button,1)
              SetState(LT_Button,0)
              Result = 9
            EndIf
          EndIf
          
        Case LB_Button 
          If LB = #True
            ResetStatic()
            SetState(L_Button,1)
            SetState(B_Button,1)
            SetState(RT_Button,1)
            Result = 8
          Else
            If T And R
              SetState(L_Button,1)
              SetState(B_Button,1)
              SetState(LB_Button,0)
              Result = 9
            EndIf
          EndIf
          
        Case RT_Button   
          If RT = #True
            ResetStatic()
            SetState(T_Button,1)
            SetState(R_Button,1)
            SetState(LB_Button,1)
            Result = 4
          Else
            If L And B
              SetState(R_Button,1)
              SetState(T_Button,1)
              SetState(RT_Button,0)
              Result = 9
            EndIf
          EndIf
          
        Case RB_Button     
          If RB = #True
            ResetStatic()
            SetState(R_Button,1)
            SetState(B_Button,1)
            SetState(LT_Button,1)
            Result = 6
          Else
            If L And T
              SetState(R_Button,1)
              SetState(B_Button,1)
              SetState(RB_Button,0)
              Result = 9
            EndIf
          EndIf
          
        Case C_Button
          ResetStatic()
          Result = 0
          
        Default
          If L = 0 And T = 0 And R = 0 And B = 0
            ResetStatic()
            Result = 0
          EndIf
          
      EndSelect 
      
      Protected s3 = 17
      Select Result
        Case 0  : Resize(Sha, 19,19,s3,s3)
        Case 1  : Resize(Sha, 0,19,s3,s3)
        Case 3  : Resize(Sha, 19,0,s3,s3)
        Case 5  : Resize(Sha, 38-1,19,s3,s3) 
        Case 7  : Resize(Sha, 19,38-1,s3,s3)
          
        Case 10 : Resize(Sha, 0,0,40,60-2)
        Case 11 : Resize(Sha, 0,0,60-2,40)
        Case 12 : Resize(Sha, 19,0,40,60-2)
        Case 13 : Resize(Sha, 0,19,60-2,40)
        Case 14 : Resize(Sha, 0,19,60-2,s3)
        Case 15 : Resize(Sha, 19,0,s3,60-2)
          
        Case 2  : Resize(Sha, 0,0,s3,s3)
        Case 4  : Resize(Sha, 38-1,0,s3,s3)
        Case 6  : Resize(Sha, 38-1,38-1,s3,s3)
        Case 8  : Resize(Sha, 0,38-1,s3,s3)
        Case 9  : Resize(Sha, 0,0,60-2,60-2)
      EndSelect
      
      
      
      Debug Result
      AlignResult = Result
  EndSelect
EndProcedure

Procedure AlignWidget(x = 10, y = 10, width = 120, height = 140)
  Protected widget = Container(x, y, width, height)
  Protected butt_size = 15, screen_size = 50, pos = 1
  
  L_Button  = Button(x, y+pos+butt_size, butt_size, screen_size, " ", #__button_Toggle|#__button_vertical, -1, 7)                                              ;:ToolTip(L_Button,  "Включить привязку (влево)")
  T_Button  = Button(x+pos+butt_size, y, screen_size, butt_size, " ", #__button_Toggle, -1, 7)                                                                 ;:ToolTip(T_Button,  "Включить привязку (верх)")
  R_Button  = Button(x+pos+pos+butt_size+screen_size, y+pos+butt_size, butt_size, screen_size, " ", #__button_Toggle|#__button_vertical|#__text_invert, -1, 7) ;:ToolTip(R_Button,  "Включить привязку (вправо)")
  B_Button  = Button(x+pos+butt_size, y+pos+pos+butt_size+screen_size, screen_size, butt_size, " ", #__button_Toggle|#__text_invert, -1, 7)                    ;:ToolTip(B_Button,  "Включить привязку (вниз)")
  LT_Button = Button(x, y, butt_size, butt_size, " ", #__button_Toggle, -1, 7)                                                                                 ;:ToolTip(LT_Button, "Включить привязку (влево верх)")
  RT_Button = Button(x+pos+pos+butt_size+screen_size, y, butt_size, butt_size, " ", #__button_Toggle, -1, 7)                                                   ;:ToolTip(RT_Button, "Включить привязку (вправо верх)")
  LB_Button = Button(x, y+pos+pos+butt_size+screen_size, butt_size, butt_size, " ", #__button_Toggle, -1, 7)                                                   ;:ToolTip(LB_Button, "Включить привязку (влево вниз)")
  RB_Button = Button(x+pos+pos+butt_size+screen_size, y+pos+pos+butt_size+screen_size, butt_size, butt_size, " ", #__button_Toggle, -1, 7)                     ;:ToolTip(RB_Button, "Включить привязку (вправо вниз)")
  
  ;
  S_Screen = Container(x+pos+butt_size, y+pos+butt_size, screen_size, screen_size) ;:Disable(S_Screen,1)
  Sha = Button(0, 0, butt_size+2, butt_size+2, "", #__button_Toggle) 
;   SetState(*this, 1)
;   SetAlignment( *this, 1,1,0,0 )
  CloseList()
  
  C_Button  = Button(x+pos+(screen_size+butt_size)/2, y+pos+(screen_size+butt_size)/2, butt_size, butt_size, "", 0, -1, 7)                                     ;:ToolTip(C_Button,  "Включить привязку (вцентре)")
  
  SetState(L_Button, 1)
  SetState(T_Button, 1)
  SetState(LT_Button, 1)
  
  ;SetState(LT_Button, 1)
  ; Post(#__event_LeftClick, LT_Button)
  
  C_Add = Button(x, y+pos+pos+pos+butt_size+butt_size+screen_size, pos+pos+butt_size+butt_size+screen_size, butt_size, ">", #__button_Toggle, -1, 7)
  ; ToolTip(C_Add, "Дополнительные параметры")
  
 
  
  
  
  
  
  
  ; BindGadgetEvent(C_Add,@Additinal())
  Bind(#PB_All, @AliginsEvent());, Window_3)
  ;bind(-1,-1)
  CloseList()
  ProcedureReturn widget
EndProcedure

Procedure ShowAlignWindow()
  x = DesktopMouseX()+20
  y = DesktopMouseY()-10
  ResizeWindow(Window_3,x, y,#PB_Ignore,#PB_Ignore)
  HideWindow(Window_3,0)
EndProcedure

Window_3  = OpenWindow(#PB_Any, 0, 0, 400, 300, "Привязка выбраных гаджетов", #PB_Window_SystemMenu | #PB_Window_Tool | #PB_Window_Invisible)
Open(Window_3)
Container(0,0,0,0)
SetColor(widget(), #PB_Gadget_BackColor, $4737D53F)
;SetAlignment(widget(), #__align_full,#__align_full,#__align_full,#__align_full)
SetAlignment(widget(), #__align_auto,#__align_auto,#__align_auto,#__align_auto)

demo = Button(120, 130, 60, 20, "demo")  
CloseList()

SetAlignment(AlignWidget( ), 0,0,#__align_auto,0)

Procedure Sha_Events()
  Protected left, right, top, bottom
  
  If EventWidget()\align
    left = EventWidget()\align\left
    top = EventWidget()\align\top
    right = EventWidget()\align\right
    bottom = EventWidget()\align\bottom
  EndIf
  
  Debug ""+left +" "+ right +" "+ top +" "+ bottom
  SetAlignment( demo, left, right, top, bottom )
EndProcedure

Bind(Sha, @Sha_Events( ), #__event_resize)
;SetAlignment(AlignWidget( ), 0,0,#__align_auto,0)

ShowAlignWindow()

Repeat :Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 370
; FirstLine = 365
; Folding = -------
; EnableXP
; DPIAware