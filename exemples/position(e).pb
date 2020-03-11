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
  Global *current._s_widget
  
  #_First=99
  #PrevOne=100
  #NextOne=101
  #_Last=102
  
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
  
  
  ; Получить первый элемент
  Procedure FirstPosition(*this._s_widget) ; Ok
    ChangeCurrentElement(GetChildrens(*this), *this\parent\adress)
    
    While NextElement(GetChildrens(*this)) 
      If GetChildrens(*this)\hide = #False And 
         GetChildrens(*this)\parent = *this\parent And 
         GetChildrens(*this)\tab\index = *this\parent\tab\index
        ProcedureReturn GetChildrens(*this) 
        Break
      EndIf
    Wend 
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
  
  
  Procedure.i _GetPosition(*this._s_widget, Position.i)
    Protected Result.i
    
    If *this
      ChangeCurrentElement(GetChildrens(*this), *this\adress) 
      
      Select Position
        Case #PB_List_First  
          If *this\parent
            ;ChangeCurrentElement(GetChildrens(*this), *this\parent\adress)
            FirstElement(GetChildrens(*this))
            
            While NextElement(GetChildrens(*this)) 
              If GetChildrens(*this)\hide = #False And 
                 GetChildrens(*this)\parent = *this\parent And 
                 GetChildrens(*this)\tab\index = *this\parent\tab\index
                ProcedureReturn GetChildrens(*this) 
              EndIf
            Wend 
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
  
  Procedure _SetPosition(*this._s_widget, Position, *Widget_2._s_widget =- 1) ; Ok
    Protected Type
    Protected Result =- 1
    
    If *this = *Widget_2
      ProcedureReturn 0
    EndIf
    
    Protected *next._s_widget
    Protected *prev._s_widget
    
    Select Position
      Case #PB_List_First 
        *prev._s_widget = _GetPosition(*this, #PB_List_First)
        
        If *prev
          ChangeCurrentElement(GetChildrens(*this), *this\adress)
          MoveElement(GetChildrens(*this), #PB_List_Before, *prev\adress)
          ;           ChangeCurrentElement(GetChildrens(*this), *this\adress)
          ;           MoveElement(GetChildrens(*this), #PB_List_First)
          
          While NextElement(GetChildrens(*this)) 
            If _is_child(GetChildrens(*this), *this)
              MoveElement(GetChildrens(*this), #PB_List_Before, *this\adress)
            EndIf
          Wend
          
        EndIf
        
        
      Case #PB_List_Before 
        *prev._s_widget = _GetPosition(*this, #PB_List_Before)
        
        If *prev
          ChangeCurrentElement(GetChildrens(*this), *this\adress)
          MoveElement(GetChildrens(*this), #PB_List_Before, *prev\adress)
          
          While NextElement(GetChildrens(*this)) 
            If _is_child(GetChildrens(*this), *this)
              MoveElement(GetChildrens(*this), #PB_List_Before, *prev\adress)
            EndIf
          Wend
        EndIf
        
      Case #PB_List_After 
        *next._s_widget = _GetPosition(*this, #PB_List_After)
        
        If *next
          ChangeCurrentElement(GetChildrens(*this), *this\adress)
          MoveElement(GetChildrens(*this), #PB_List_After, *next\adress)
          
          While PreviousElement(GetChildrens(*this)) 
            If _is_child(GetChildrens(*this), *this)
              MoveElement(GetChildrens(*this), #PB_List_After, *this\adress)
            EndIf
          Wend
        EndIf
        
      Case #PB_List_Last 
        Debug *this\parent\last\index
        LastElement(GetChildrens(*this))
        Debug GetChildrens(*this)\index
        
        If *this\parent\adress
          LastElement(GetChildrens(*this))
          
          While PreviousElement(GetChildrens(*this)) 
            If _is_child(GetChildrens(*this), *this\parent)
              Break
            EndIf
          Wend
          
          MoveElement(GetChildrens(*this), #PB_List_After)
        Else
          
          ChangeCurrentElement(GetChildrens(*this), *this\adress)
          MoveElement(GetChildrens(*this), #PB_List_Last)
        EndIf
        
        While PreviousElement(GetChildrens(*this)) 
          If _is_child(GetChildrens(*this), *this)
            MoveElement(GetChildrens(*this), #PB_List_After, *this\adress)
          EndIf
        Wend
        
        
        
    EndSelect
    
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
    
    redraw(root())
    ProcedureReturn Result
  EndProcedure
  
  
  Procedure Demo()
    Protected   ParentID = OpenWindow(0, 0, 0, 250, 110, "Demo z-order gadget", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
    
    canvas(0, 0, 0, 250, 110)
    
    Container(55, 60, 190, 45)                     ; Gadget(9,   
    Container(3, -3, 175-4, 45+6)   
    Container(3, -3, 160-8, 45+6)   
    CloseList()
    CloseList()
    CloseList()
    
    Button(55, 56, 170, 25, "8",#PB_Button_Right)  ; Gadget(8, 
    Button(55, 52, 150, 25, "7",#PB_Button_Right)  ; Gadget(7, 
    Button(55, 48, 130, 25, "6",#PB_Button_Right)  ; Gadget(6, 
    
    *this = Container(10, 10, 60, 90)              ; Gadget(10, 
    Container(10, 10, 60, 70-4)   
    Container(10, 10, 60, 50-8)   
    CloseList()
    CloseList()
    CloseList()
    *current = Button(55, 44, 110, 25, "5",#PB_Button_Right)  ; Gadget(5, 
    
    Button(55, 40, 90, 25, "4",#PB_Button_Right)  ; Gadget(4, 
    Button(55, 36, 70, 25, "3",#PB_Button_Right)  ; Gadget(3, 
    Button(55, 32, 50, 25, "2",#PB_Button_Right)  ; Gadget(2, 
    
    Container(55, 28, 30, 25)                     ; Gadget(1,
    Container(3, -3, 24-4, 25+6)   
    Container(3, -3, 17-8, 25+6)   
    CloseList()
    CloseList()
    CloseList()
    
    ResizeWindow(0,#PB_Ignore,WindowY(0)-130,#PB_Ignore,#PB_Ignore)
    ; BindEvent(#PB_Event_MoveWindow, @Resize(), 0)
    
    OpenWindow(10, 0, 0, 250, 125, "", #PB_Window_BorderLess|#PB_Window_ScreenCentered, ParentID)
    ButtonGadget(#_Last, 5, 10, 240, 20, "last position gadget №10")
    ButtonGadget(#PrevOne, 5, 40, 240, 20, "prev position gadget №10")
    
    ButtonGadget(#NextOne, 5, 70, 240, 20, "next position gadget №10")
    ButtonGadget(#_First, 5, 100, 240, 20, "first position gadget №10")
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
              Case #_First
                SetPosition(*this, #PB_List_First)
                
              Case #PrevOne
                SetPosition(*this, #PB_List_Before)
                
              Case #NextOne
                SetPosition(*this, #PB_List_After)
                
              Case #_Last
                SetPosition(*this, #PB_List_Last)
                
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
; Folding = -------
; EnableXP