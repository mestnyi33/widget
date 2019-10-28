IncludePath "../"
XIncludeFile "widgets(6).pbi"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Widget
  
  Procedure Events()
    Select *event\type
      Case #PB_EventType_MouseEnter
        Debug "enter - "+*event\widget\index
        *event\widget\color\back = $0000FF
        
      Case #PB_EventType_MouseLeave
        Debug "leave - "+*event\widget\index
        *event\widget\color\back = $FF0000
        
       Case #PB_EventType_Repaint
         DrawingMode(#PB_2DDrawing_Transparent)
         DrawText(2,0, Str(*event\widget\index), 0)
         
    EndSelect
  EndProcedure
  
  Procedure Enumerates(*this._S_widget, *callback)
    With *this
      If *callback
        CallCFunctionFast(*callback, *this)
        
        If \children_count
          ForEach \children_list()
            Enumerates(\children_list(), *callback)
          Next
        EndIf
      EndIf
    EndWith
  EndProcedure
  
;   Procedure Enumerates(*this._S_widget, *callback)
;     With *this
;       If *callback
;         CallCFunctionFast(*callback, *this)
;         
;         If ListSize(\Childrens())
;           ForEach \Childrens()
;             Enumerates(\Childrens(), *callback)
;           Next
;         EndIf
;       EndIf
;     EndWith
;   EndProcedure
  
  Procedure enum(*this._S_widget)
     Bind(@Events(), *this)
  EndProcedure
  
  
  If OpenWindow(0, 100, 100, 220, 220, "Window_0", #PB_Window_SystemMenu);, WindowID(100))
    
    ; 
    Open(0, 0, 0, 220, 220, "", #PB_Flag_BorderLess)
    Container(20, 20, 180, 180)
    
    Container(70, 10, 70, 180, #PB_Flag_NoGadget) ; bug
    
    Container(20, 20, 180, 180)
    Container(20, 20, 180, 180)
    ;  Container(20, 20, 180, 180), 30)
    Container(0, 20, 180, 30, #PB_Flag_NoGadget)
    Container(0, 35, 180, 30, #PB_Flag_NoGadget)
    Container(0, 50, 180, 30, #PB_Flag_NoGadget)
    Container(20, 70, 180, 180, #PB_Flag_NoGadget)
    ;  Container(20, 20, 180, 50), 200)
    CloseList()
    CloseList()
    Container(10, 70, 70, 180, #PB_Flag_NoGadget)
    
    Enumerates(root(), @enum())
    Redraw(Root())
    
    Repeat
      Event = WaitWindowEvent()
      
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP