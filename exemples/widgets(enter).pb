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
        If GetButtons(*event\widget)
          *event\widget\color\back = $00FF00
        Else
          *event\widget\color\back = $0000FF
        EndIf
        
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
    Open(0, 0, 0, 220, 220)
    ;     Container(1, 20, 20, 180, 180)
    ;     Container(9,70, 10, 70, 180, #PB_Flag_NoGadget) ; bug
    ;     Container(2,20, 20, 180, 180)
    ;     Container(3,20, 20, 180, 180)
    ;     ;     Container(20, 20, 180, 180), 30)
    ;     Container(4,0, 20, 180, 30, #PB_Flag_NoGadget)
    ;     Container(5,0, 35, 180, 30, #PB_Flag_NoGadget)
    ;     Container(6,0, 50, 180, 30, #PB_Flag_NoGadget)
    ;     Container(7,20, 70, 180, 180, #PB_Flag_NoGadget)
    ;     ;  Container(20, 20, 180, 50), 200)
    ;     CloseList()
    ;     CloseList()
    ;     
    ;     Container(8,10, 70, 70, 180)
    ;     Container(10,10, 10, 70, 30, #PB_Flag_NoGadget)
    ;     Container(11,10, 20, 70, 30, #PB_Flag_NoGadget)
    ;     Container(12,10, 30, 70, 30, #PB_Flag_NoGadget)
    ;     CloseList()
    
    SetData(Container(20, 20, 180, 180), 1)
    SetData(Container(70, 10, 70, 180, #PB_Flag_NoGadget), 9) 
    SetData(Container(20, 20, 180, 180), 2)
    SetData(Container(20, 20, 180, 180), 3)
    
    SetData(Container(0, 20, 180, 30, #PB_Flag_NoGadget), 4) 
    SetData(Container(0, 35, 180, 30, #PB_Flag_NoGadget), 5) 
    SetData(Container(0, 50, 180, 30, #PB_Flag_NoGadget), 6) 
    SetData(Container(20, 70, 180, 50, #PB_Flag_NoGadget), 7) 
    
    CloseList()
    CloseList()
    SetData(Container(10, 70, 70, 180), 8) 
    SetData(Container(10, 10, 70, 30, #PB_Flag_NoGadget), 10) 
    SetData(Container(10, 20, 70, 30, #PB_Flag_NoGadget), 11) 
    SetData(Container(10, 30, 70, 30, #PB_Flag_NoGadget), 12) 
    CloseList()
    
;     Define widget
;     While Enumerate(@widget, root())
;       Debug widget
;       Bind(@Events(), widget)
;     Wend
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