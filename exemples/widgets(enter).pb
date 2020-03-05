IncludePath "../"
XIncludeFile "widgets().pbi"
;XIncludeFile "w_window.pb"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Widget
  UseModule constants
  
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
        DrawingMode(#PB_2DDrawing_Default)
        Box(2,0,10,10,$FF000000)
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(2,0, Str(*event\widget\index), $FFFFFFFF)
        
        Debug " repaint"
        
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
    Debug  ""+*this\index +" "+ *this\type 
    Bind(@Events(), *this)
  EndProcedure
  
  If Open(0, 0, 0, 220, 220, "demo mouse position", #PB_Window_SystemMenu)
    SetData(Container(20, 20, 180, 180), 1)
    SetData(Container(70, 10, 70, 180, #__Flag_NoGadget), 9) 
    SetData(Container(20, 20, 180, 180), 2)
    SetData(Container(20, 20, 180, 180), 3)
    
    SetData(Container(0, 20, 180, 30, #__Flag_NoGadget), 4) 
    SetData(Container(0, 35, 180, 30, #__Flag_NoGadget), 5) 
    SetData(Container(0, 50, 180, 30, #__Flag_NoGadget), 6) 
    SetData(Splitter(20, 70, 180, 50, Container(0,0,0,0, #__Flag_NoGadget), Container(0,0,0,0, #__Flag_NoGadget), #PB_Splitter_Vertical), 7) 
    
    CloseList()
    CloseList()
    SetData(Container(10, 70, 70, 180), 8) 
    SetData(Container(10, 10, 70, 30, #__Flag_NoGadget), 10) 
    SetData(Container(10, 20, 70, 30, #__Flag_NoGadget), 11) 
    SetData(Container(10, 30, 70, 30, #__Flag_NoGadget), 12) 
    CloseList()
    
    
    
    ;     Define widget._s_widget
    ;     While Enumerate(@widget, root())
    ;       Debug widget\index
    ;       ;Bind(@Events(), widget)
    ;     Wend
    
    Enumerates(root(), @enum())
    
    Redraw(Root())
    
    Repeat
      Event = WaitWindowEvent()
      
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --
; EnableXP