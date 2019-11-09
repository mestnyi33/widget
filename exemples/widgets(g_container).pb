IncludePath "../"
XIncludeFile "widgets().pbi"

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
        
        If \count\childrens
          ForEach \childrens()
            Enumerates(\childrens(), *callback)
          Next
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure enum(*this._S_widget)
     Bind(@Events(), *this)
  EndProcedure
  
  
  If Open(-1, 50, 50, 220, 220, "demo enter & leave", #__Flag_BorderLess)
    Container(35,35,150,150, #PB_Container_Flat) 
    Container(10,5,150,55, #PB_Container_Flat) 
    Container(10,5,150,55, #PB_Container_Flat) 
    Container(10,5,150,55, #PB_Container_Flat) 
    Button(10,5,50,35, "butt") 
    CloseList()
    CloseList()
    CloseList()
    
    Container(10,75,150,55, #PB_Container_Flat) 
    Container(10,5,150,55, #PB_Container_Flat) 
    Container(10,5,150,55, #PB_Container_Flat) 
    Button(10,5,50,35, "butt1") 
    CloseList()
    CloseList()
    CloseList()
    CloseList()
    ; Enumerates(root(), @enum())
    Bind(@Events(), root())
    Redraw(Root())
  
    Repeat
      Event = WaitWindowEvent()
      
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP