CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget";/widgets()"
  XIncludeFile "fixme(mac).pbi"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  IncludePath "/media/sf_as/Documents/GitHub/Widget/widgets()"
CompilerElse
  IncludePath "Z:/Documents/GitHub/Widget/widgets()"
CompilerEndIf

XIncludeFile "elements.pbi"
;XIncludeFile "w_window.pb"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule bar
  UseModule constants
  UseModule structures
  
  Global *this._s_widget
  
  #Firstg=99
  #PrevOne=100
  #NextOne=101
  #Lastg=102
  
    ; Получить последный элемент у родителя
Procedure ParentLastElement(*Parent._s_widget)
  Protected *LastElement._s_widget =- 1
  
      If _is_widget_(*Parent)
      PushListPosition(GetChildrens(*Parent)) 
      ChangeCurrentElement(GetChildrens(*Parent), *Parent\adress)
;       Debug \This()\Items()\Text\String$
;       Debug ElementID(Parent);
     
      While NextElement(GetChildrens(*Parent)) 
        If _is_child(GetChildrens(*Parent), *Parent)
          *LastElement = GetChildrens(*Parent)
        EndIf
      Wend
      
      If *LastElement =- 1 : *LastElement = *Parent : EndIf
      PopListPosition(GetChildrens(*Parent))
    EndIf
    
    ;Debug *LastElement
  ProcedureReturn *LastElement
EndProcedure

  ; Получить предыдущий элемент
Procedure PrevPosition(*this._s_widget) ; Ok
  ChangeCurrentElement(GetChildrens(*this), *this\adress) 
  
  While PreviousElement(GetChildrens(*this))
    If GetChildrens(*this)\hide = #False And 
       GetChildrens(*this)\parent = *this\parent And 
       GetChildrens(*this)\tab\index = *this\parent\tab\index
      
      If *this\parent = GetChildrens(*this)
        ProcedureReturn *this
      Else
        ProcedureReturn GetChildrens(*this)
      EndIf
    EndIf
  Wend
  
  ProcedureReturn *this
EndProcedure

; Получить следующий элемент
Procedure NextPosition(*this._s_widget) ; Ok
  ChangeCurrentElement(GetChildrens(*this), *this\adress) 
  
  While NextElement(GetChildrens(*this))   
    If GetChildrens(*this)\Hide = #False And
       GetChildrens(*this)\Parent = *this\parent And 
       GetChildrens(*this)\tab\index = *this\parent\tab\index
      ProcedureReturn GetChildrens(*this)
    EndIf
  Wend
  
  ProcedureReturn *this
EndProcedure

; Получить первый элемент
Procedure FirstPosition(*this._s_widget) ; Ok
  Protected Item =- 1
  Protected *Parent._s_widget =- 1
  Protected Result =- 1
  
;     If _is_widget_(*this)
;       PushListPosition(GetChildrens(*this)) 
;       ChangeCurrentElement(GetChildrens(*this), *this\adress) 
;       Item = GetChildrens(*this)\tab\index
;       *parent = GetChildrens(*this)\Parent
;       ChangeCurrentElement(GetChildrens(*this), *parent\adress)
;       
;       While NextElement(GetChildrens(*this)) 
;         If GetChildrens(*this)\Parent = *parent And Item = GetChildrens(*this)\tab\index     And GetChildrens(*this)\Hide = #False ; TODO
;           Result = GetChildrens(*this) 
;           Break
;         EndIf
;       Wend 
;       
;       PopListPosition(GetChildrens(*this))
;     EndIf
  
  ProcedureReturn *this\parent\adress
EndProcedure

; Получить последный элемент
Procedure LastPosition(*this._s_widget) ; Ok
  Protected Item =- 1
  Protected *Parent._s_widget =- 1
  Protected Result =- 1
  
    If _is_widget_(*this)
      PushListPosition(GetChildrens(*this)) 
      ChangeCurrentElement(GetChildrens(*this), *this\adress) 
      Item = GetChildrens(*this)\tab\index
      *parent = GetChildrens(*this)\Parent
      
      ; LastElement
      While NextElement(GetChildrens(*this)) 
        If _is_child(GetChildrens(*this), *parent) = #False And GetChildrens(*this)\Hide = #False
          Break
        EndIf
      Wend
      
      While PreviousElement(GetChildrens(*this)) 
        If GetChildrens(*this)\Parent = *parent And Item = GetChildrens(*this)\tab\index And GetChildrens(*this)\Hide = #False
          Break
        EndIf
      Wend
      
      Result = GetChildrens(*this) 
      PopListPosition(GetChildrens(*this))
    EndIf
  
  ProcedureReturn Result
EndProcedure


Procedure _GetPosition(*this._s_widget, position.l)
    Protected Result.i
    
    If *this
      ChangeCurrentElement(GetChildrens(*this), *this\adress) 
      
      Select position
        Case #PB_List_First  
          If *this\parent
            ChangeCurrentElement(GetChildrens(*this), *this\parent\adress) 
            Result = NextElement(GetChildrens(*this))
          Else
            Result = FirstElement(GetChildrens(*this))
          EndIf
          
        Case #PB_List_Before 
          While PreviousElement(GetChildrens(*this))
            If GetChildrens(*this)\hide = #False And 
               GetChildrens(*this)\parent = *this\parent And 
               GetChildrens(*this)\tab\index = *this\parent\tab\index
              
              If *this\parent = GetChildrens(*this)
                ProcedureReturn *this
              Else
                ProcedureReturn GetChildrens(*this)
              EndIf
            EndIf
          Wend
          
        Case #PB_List_After  
          While NextElement(GetChildrens(*this))   
            If GetChildrens(*this)\Hide = #False And
               GetChildrens(*this)\Parent = *this\parent And 
               GetChildrens(*this)\tab\index = *this\parent\tab\index
              ProcedureReturn GetChildrens(*this)
            EndIf
          Wend
          
          
        Case #PB_List_Last   
          If *this\parent
            LastElement(GetChildrens(*this))
            
            While PreviousElement(GetChildrens(*this)) 
              If _is_child(GetChildrens(*this), *this\parent)
                Result = GetChildrens(*this)
                Break
              EndIf
            Wend
          Else
            Result = LastElement(GetChildrens(*this))
          EndIf
          
      EndSelect
    EndIf
    
    ProcedureReturn Result
  EndProcedure
    

Procedure _SetPosition(*this._s_widget, position.l, *widget_2._s_widget=#Null) ; Ok
      Protected Type
      Protected Result =- 1
      
      If *this = *Widget_2
        ProcedureReturn 0
      EndIf
      
      Select position
        Case #PB_List_First 
          ChangeCurrentElement(GetChildrens(*this), *this\adress)
          
          If *this\parent\adress
            MoveElement(GetChildrens(*this), #PB_List_After, *this\parent\adress)
          Else
            MoveElement(GetChildrens(*this), #PB_List_First)
          EndIf
          
        Case #PB_List_Before 
          If Not *widget_2
            *widget_2 = GetPosition(*this, #PB_List_Before)
          EndIf
        
          If *widget_2
            ChangeCurrentElement(GetChildrens(*this), *this\adress)
            MoveElement(GetChildrens(*this), #PB_List_Before, *widget_2\adress)
            
            While NextElement(GetChildrens(*this)) 
              If _is_child(GetChildrens(*this), *this)
                MoveElement(GetChildrens(*this), #PB_List_Before, *widget_2\adress)
              EndIf
            Wend
          EndIf
          
        Case #PB_List_After 
          If Not *widget_2
            *widget_2 = GetPosition(*this, #PB_List_After)
          EndIf
        
          If *widget_2
            ChangeCurrentElement(GetChildrens(*this), *this\adress)
            MoveElement(GetChildrens(*this), #PB_List_After, *widget_2\adress)
            
            While PreviousElement(GetChildrens(*this)) 
              If _is_child(GetChildrens(*this), *this)
                MoveElement(GetChildrens(*this), #PB_List_After, *this\adress)
              EndIf
            Wend
          EndIf
          
        Case #PB_List_Last 
          If *this\parent\adress
;             LastElement(GetChildrens(*this))
;             
;             While PreviousElement(GetChildrens(*this)) 
;               If _is_child(GetChildrens(*this), *this\parent)
;              MoveElement(GetChildrens(*this), #PB_List_After)
;                Break
;               EndIf
;             Wend
            
          Else
            ChangeCurrentElement(GetChildrens(*this), *this\adress)
            MoveElement(GetChildrens(*this), #PB_List_Last)
          EndIf
          
          
      EndSelect
      
      redraw(root())
      ProcedureReturn Result
    EndProcedure
 Procedure __SetPosition(*this._s_widget, Position, *Widget_2._s_widget =- 1) ; Ok
  Protected Type
  Protected Result =- 1
  
  If *this = *Widget_2
    ProcedureReturn 0
  EndIf
  
    If _is_widget_(*this)
      PushListPosition(GetChildrens(*this)) 
      ChangeCurrentElement(GetChildrens(*this), *this\adress)
      Type = GetChildrens(*this)\Type
      
      If *Widget_2 > 0 And _is_widget_(*Widget_2)
        Select Position
          Case #PB_List_Before 
            MoveElement(GetChildrens(*this), #PB_List_Before, *Widget_2\adress)
            
            While NextElement(GetChildrens(*this)) 
              If _is_child(GetChildrens(*this), *this) ;And _is_child(GetChildrens(*this)\Parent\*this, Parent)
                MoveElement(GetChildrens(*this), #PB_List_Before, *Widget_2\adress)
              EndIf
            Wend
            
          Case #PB_List_After : MoveElement(GetChildrens(*this), #PB_List_After, *Widget_2\adress)
            While PreviousElement(GetChildrens(*this)) 
              If _is_child(GetChildrens(*this), *this) ; And _is_child(GetChildrens(*this)\Parent\*this, Parent) 
                MoveElement(GetChildrens(*this), #PB_List_After, *this\adress)
              EndIf
            Wend
            
        EndSelect
      Else
        Select Position
          Case #PB_List_First 
            ChangeCurrentElement(GetChildrens(*this), *this\adress)
            
            If *this\parent\adress
              MoveElement(GetChildrens(*this), #PB_List_After, *this\parent\adress)
            Else
              MoveElement(GetChildrens(*this), #PB_List_First)
            EndIf
            
          Case #PB_List_Before 
            Protected *PrevElement._s_widget = PrevPosition(*this)
            
            If *this <> *PrevElement
              _SetPosition(*this, #PB_List_Before, *PrevElement)
            EndIf
            
          Case #PB_List_After 
            Protected *NextElement._s_widget = NextPosition(*this) 
            
            If *this\type = #__type_window
              *NextElement = ParentLastElement(*NextElement)
            EndIf
            
            If *this <> *NextElement
              _SetPosition(*this, #PB_List_After, *NextElement)
            EndIf
            
          Case #PB_List_Last 
            If *this\parent\adress
              LastElement(GetChildrens(*this))
              
              While PreviousElement(GetChildrens(*this)) 
                If _is_child(GetChildrens(*this), *this\parent)
                  Break
                EndIf
              Wend
              
              MoveElement(GetChildrens(*this), #PB_List_After)
            Else
              MoveElement(GetChildrens(*this), #PB_List_Last)
            EndIf
          
            
        EndSelect
      EndIf
      
;       If *Widget_2 =- 1
;         
;         If _is_widget_(*CreateElement\StickyWindow)
;           PushListPosition(GetChildrens(*this)) 
;           ChangeCurrentElement(GetChildrens(*this), ElementID(*CreateElement\StickyWindow))
;           MoveElement(GetChildrens(*this), #PB_List_Last)
;           While PreviousElement(GetChildrens(*this))
;             If _is_child(GetChildrens(*this), *CreateElement\StickyWindow) 
;               MoveElement(GetChildrens(*this), #PB_List_After, ElementID(*CreateElement\StickyWindow))
;             EndIf
;           Wend
;           PopListPosition(GetChildrens(*this)) 
;         EndIf
;         
;         If _is_widget_(*CreateElement\Sticky) 
;           PushListPosition(GetChildrens(*this)) 
;           ChangeCurrentElement(GetChildrens(*this), ElementID(*CreateElement\Sticky))
;           
;           ;If GetChildrens(*this)\Hide = 0
;           MoveElement(GetChildrens(*this), #PB_List_Last)
;           While PreviousElement(GetChildrens(*this))
;             If GetChildrens(*this)\Sticky ;;; And GetChildrens(*this)\Hide = 0 And GetChildrens(*this) <> *CreateElement\Sticky
;               MoveElement(GetChildrens(*this), #PB_List_After, ElementID(*CreateElement\Sticky))
;             EndIf
;           Wend
;           PopListPosition(GetChildrens(*this)) 
;           ;EndIf
;         EndIf
;         
;       EndIf
      
      PopListPosition(GetChildrens(*this))
    EndIf
    
    redraw(root())
  ProcedureReturn Result
EndProcedure
   
  Procedure Demo()
    Protected   ParentID = OpenWindow(0, 0, 0, 250, 95, "Demo z-order gadget", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
    
    canvas(0, 0, 0, 250, 95)
    *this = Button(10, 22, 50, 68, "10",#PB_Button_Left)   ; Gadget(10, 
    
    Button(35, 60, 205, 25, "9",#PB_Button_Right)  ; Gadget(9, 
    Button(35, 56, 190, 25, "8",#PB_Button_Right)  ; Gadget(8, 
    Button(35, 52, 175, 25, "7",#PB_Button_Right)  ; Gadget(7, 
    Button(35, 48, 160, 25, "6",#PB_Button_Right)  ; Gadget(6, 
    Button(35, 44, 145, 25, "5",#PB_Button_Right)  ; Gadget(5, 
    Button(35, 40, 130, 25, "4",#PB_Button_Right)  ; Gadget(4, 
    Button(35, 36, 115, 25, "3",#PB_Button_Right)  ; Gadget(3, 
    Button(35, 32, 100, 25, "2",#PB_Button_Right)  ; Gadget(2, 
    Button(35, 28,  85, 25, "1",#PB_Button_Right)  ; Gadget(1, 
    
    ResizeWindow(0,#PB_Ignore,WindowY(0)-120,#PB_Ignore,#PB_Ignore)
    ; BindEvent(#PB_Event_MoveWindow, @Resize(), 0)
    
    OpenWindow(10, 0, 0, 250, 125, "", #PB_Window_BorderLess|#PB_Window_ScreenCentered, ParentID)
    ButtonGadget(#Firstg, 5, 10, 240, 20, "move to the first position gadget №10")
    ButtonGadget(#PrevOne, 5, 40, 240, 20, "move to the prev position gadget №10")
    
    ButtonGadget(#NextOne, 5, 70, 240, 20, "move to the next position gadget №10")
    ButtonGadget(#Lastg, 5, 100, 240, 20, "move to the last position gadget №10")
  EndProcedure
  
  Demo()
  
  Define gEvent, gQuit
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
        Case #PB_Event_Gadget
          Select EventType()
            Case #PB_EventType_LeftClick
              Select EventGadget()
                Case #Firstg
                  _SetPosition(*this, #PB_List_First)
                  ;               SetPrev(10,2)
                 
                Case #PrevOne
                  _SetPosition(*this, #PB_List_Before)
                 
                Case #NextOne
                  _SetPosition(*this, #PB_List_After)
                 
                Case #Lastg
                  _SetPosition(*this, #PB_List_Last)
                  ;              SetNext(10,2)
                 
              EndSelect
             
;               ClearDebugOutput()
;               Debug "first "+GetFirst(ParentID)
;               Debug "last "+GetLast(ParentID)
;               Debug "prev №1 < № "+GetPrev(1)
;               Debug "next №1 > № "+GetNext(1)
             
          EndSelect
          
        Case #PB_Event_CloseWindow
        gQuit= #True
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -3----+---
; EnableXP