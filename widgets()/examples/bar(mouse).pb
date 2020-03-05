IncludePath "../"
XIncludeFile "bar.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseModule Bar
  UseModule Constants
  UseModule Structures
  
  Macro OpenWindow(Window, x,y,width,height, Title, Flag=0, ParentID=0)
    bar::Open_Window(Window, x,y,width,height, Title, Flag, ParentID)
  EndMacro
  
;   Macro Container(x,y,w,h,f=0)
;     ScrollArea(x,y,w,h, 450, 450, 1, f) 
;   EndMacro
  Macro SetData(w,d)
    w
  EndMacro
  
  If OpenWindow(0, 100, 110, 250, 250, "enter", #PB_Window_SystemMenu); | #PB_Window_ScreenCentered)
    SetData(Container(20, 20, 180, 180), 1)
    SetData(Container(70, 10, 70, 180, #__Flag_NoGadget), 2) 
    SetData(Container(40, 20, 180, 180), 3)
    SetData(Container(20, 20, 180, 180), 4)
    
    SetData(Container(5, 30, 180, 30, #__Flag_NoGadget), 5) 
    SetData(Container(5, 45, 180, 30, #__Flag_NoGadget), 6) 
    SetData(Container(5, 60, 180, 30, #__Flag_NoGadget), 7) 
    SetData(Splitter(5, 80, 180, 50, Container(0,0,0,0, #__Flag_NoGadget), Container(0,0,0,0, #__Flag_NoGadget), #PB_Splitter_Vertical), 8) 
    
    CloseList()
    CloseList()
    SetData(Container(10, 45, 70, 180), 11) 
    SetData(Container(10, 10, 70, 30, #__Flag_NoGadget), 12) 
    SetData(Container(10, 20, 70, 30, #__Flag_NoGadget), 13) 
    SetData(Container(10, 30, 170, 130, #__Flag_NoGadget), 14) 
    SetData(Container(10, 45, 70, 180), 11) 
    SetData(Container(10, 5, 70, 180), 11) 
    SetData(Container(10, 5, 70, 180), 11) 
    SetData(Container(10, 10, 70, 30, #__Flag_NoGadget), 12) 
    CloseList()
    CloseList()
    CloseList()
    CloseList()
    CloseList()
  EndIf
  
  If OpenWindow(10, 400, 110, 350, 350, "enter", #PB_Window_SystemMenu); | #PB_Window_ScreenCentered)
    c_0 = Container(0,0,50,50)
    ;c_0_1 = Container(10, 10, 30, 30, #__Flag_NoGadget)
    CloseList()
    
    c_1 = Container(100,0,50,50)
    c_2 = Container(10,15,150,150)
    c_1_1 = Button(10, 10, 130, 130, "Button")
    CloseList()
    
    c_1_2 = Container(10, 175, 130, 130, #__Flag_NoGadget)
    CloseList()
    
    s_0 = Splitter(10, 10, 330, 330, c_0, c_1, #PB_Splitter_Vertical)
    
    ;     Define *this._s_widget
    ;     *this = c_1_1
    ;     
    ;     Debug c_0
    ;     Debug c_1
    ;     Debug c_1_1
    ;     Debug s_0
    ;     
    ;     ;Resize(*this, -100, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    ;     Debug "  "+*this\parent
    ;     Debug  ""+*this\x+" "+*this\y[4]+" "+*this\width[4]+" "+*this\height[4]
    ;     
    ; ;     ; Enumerates(root(), @enum())
    ; ;     Bind(@*event, root())
    ; ;     Redraw(Root())
    
  EndIf
  
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
 CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP