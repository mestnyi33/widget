IncludePath "../../"
XIncludeFile "widgets.pbi"
UseLib(widget)

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Global NewMap Widgets.i()
  Global.i Window_0, Canvas_0, gEvent, gQuit, x=10,y=10
  Global *this._s_widget
  
  Procedure example_0()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 0, 0, 190, 200, "Demo alignment widgets", #PB_Window_ScreenCentered | #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    Widgets(Hex(2)) = Button(55, 5, 80, 20, "center")   ; center \2     align_proportional_horizontal
    Widgets(Hex(3)) = Button(55, 25, 80, 20, "right")   ; right         #right
    Widgets(Hex(4)) = Container(55, 45, 80, 20)         ; stretch       #stretch 
    Widgets(Hex(44)) = Button(0, 5, 80, 20, "parent stretch")
    CloseList()
    
    Widgets(Hex(5)) = Button(55, 65, 80, 20, ">>|<<")    ; proportional  #proportion
    
    Widgets(Hex(6)) = Button(10, 90, 80, 20, ">>|", #__Button_Right) ; proportional
    Widgets(Hex(7)) = Button(100, 90, 80, 20, "|<<", #__Button_Left) ; proportional
    
    Widgets(Hex(8)) = Button(10, 115, 50, 20, ">>|", #__Button_Right) ; proportional
    Widgets(Hex(9)) = Button(60, 115, 20, 20, "|")                    ; proportional
    Widgets(Hex(10)) = Button(80, 115, 30, 20, "<<>>")                ; proportional
    Widgets(Hex(11)) = Button(110, 115, 20, 20, "|")                  ; proportional
    Widgets(Hex(12)) = Button(130, 115, 50, 20, "|<<", #__Button_Left); proportional
    
    
    SetAlignment(Widgets(Hex(2)), #__align_center|#__align_top|#__align_proportional|#__align_vertical)
    SetAlignment(Widgets(Hex(3)), #__align_center|#__align_right)
    SetAlignment(Widgets(Hex(4)), #__align_full|#__align_proportional|#__align_vertical)
    SetAlignment(Widgets(Hex(44)), #__align_center|#__align_top)
    
    SetAlignment(Widgets(Hex(5)), #__align_left|#__align_right|#__align_proportional|#__align_bottom)
    
    SetAlignment(Widgets(Hex(6)), #__align_left|#__align_proportional|#__align_bottom)
    SetAlignment(Widgets(Hex(7)), #__align_right|#__align_proportional|#__align_bottom)
    
    SetAlignment(Widgets(Hex(8)), #__align_bottom)
    SetAlignment(Widgets(Hex(9)), #__align_bottom)
    SetAlignment(Widgets(Hex(10)), #__align_left|#__align_right|#__align_bottom)
    SetAlignment(Widgets(Hex(11)), #__align_right|#__align_bottom)
    SetAlignment(Widgets(Hex(12)), #__align_right|#__align_bottom)
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 260,260)
  EndProcedure
  
  Procedure example_1()
    Define i
    CreateImage(0,200,60) 
    StartDrawing(ImageOutput(0))
    For i=0 To 200
      Circle(100, 30, 200-i, (i+50)*$010101)
    Next
    StopDrawing()
    
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 0, 0, 512, 200, "Resize gadget", #PB_Window_ScreenCentered | #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    Widgets(Hex(1)) = Text(10,  10, 200, 50, "Resize the window, the gadgets will be automatically resized", #__Text_Center)
    ; Widgets(Hex(3)) = ButtonImageGadget(3, 10, 70, 200, 60, ImageID(0))
    Widgets(Hex(2)) = Editor(10, 140, 200, 20) : SetText(Widgets(Hex(2)),"Editor")
    Widgets(Hex(4)) = Button(10, 170, 490, 20, "Button / toggle", #__Button_Toggle)
    Widgets(Hex(5)) = Text(220,10,190,20,"Text", #__Text_Center) : SetColor(Widgets(Hex(5)), #PB_Gadget_BackColor, $00FFFF)
    Widgets(Hex(6)) = Container(220, 30, 190, 100, #PB_Container_Single) : SetColor(Widgets(Hex(6)), #PB_Gadget_BackColor, $cccccc) 
    Widgets(Hex(7)) = Editor(10,  10, 170, 50) : SetText(Widgets(Hex(7)),"Editor")
    Widgets(Hex(8)) = Button(10, 70, 80, 20, "Button") 
    Widgets(Hex(9)) = Button(100, 70, 80, 20, "Button") 
    CloseList() 
    Widgets(Hex(10)) = String(220,  140, 190, 20, "String")
    Widgets(Hex(11)) = Button(420,  10, 80, 80, "Bouton")
    Widgets(Hex(12)) = CheckBox(420,  90, 200, 20, "CheckBox")
    Widgets(Hex(13)) = CheckBox(420,  110, 200, 20, "CheckBox")
    Widgets(Hex(14)) = CheckBox(420,  130, 200, 20, "CheckBox")
    Widgets(Hex(15)) = CheckBox(420,  150, 200, 20, "CheckBox")
    
    SetAlignment(Widgets(Hex(2)),#__align_top|#__align_bottom) 
    ;SetAlignment(Widgets(Hex(3)),#__align_center|#__align_right)              
    SetAlignment(Widgets(Hex(4)),#__align_left|#__align_right|#__align_bottom)      
    
    SetAlignment(Widgets(Hex(5)),#__align_left|#__align_right)
    
    SetAlignment(Widgets(Hex(6)),#__align_full) 
    SetAlignment(Widgets(Hex(7)),#__align_full)
    
    SetAlignment(Widgets(Hex(8)),#__align_bottom|#__align_left|#__align_proportional) 
    SetAlignment(Widgets(Hex(9)),#__align_bottom|#__align_right|#__align_proportional) 
    SetAlignment(Widgets(Hex(10)),#__align_left|#__align_right|#__align_bottom) 
    SetAlignment(Widgets(Hex(11)),#__align_right|#__align_bottom|#__align_top) 
    SetAlignment(Widgets(Hex(12)),#__align_right|#__align_bottom)
    SetAlignment(Widgets(Hex(13)),#__align_right|#__align_bottom)
    SetAlignment(Widgets(Hex(14)),#__align_right|#__align_bottom)
    SetAlignment(Widgets(Hex(15)),#__align_right|#__align_bottom)
    
  EndProcedure
  
  Procedure example_2()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 0, 0, 190, 200, "Resize gadget", #PB_Window_ScreenCentered | #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    Widgets(Hex(1)) = Button(10, 85, 80, 20, "left")   ; center \2     align_proportional_horizontal
    Widgets(Hex(2)) = Button(55, 10, 80, 20, "top")    ; center \2     align_proportional_horizontal
    Widgets(Hex(3)) = Button(100, 85, 80, 20, "right") ; right         #right
    Widgets(Hex(4)) = Button(55, 170, 80, 20, "bottom"); right         #right
    
    Widgets(Hex(5)) = Button(55, 85, 80, 20, "center")   ; center \2     align_proportional_horizontal
    
    Widgets(Hex(6)) = Button(10, 10, 80, 20, "left&top")    ; right         #right
    Widgets(Hex(7)) = Button(100, 10, 80, 20, "right&top")  ; right         #right
    Widgets(Hex(8)) = Button(100, 170, 80, 20, "right&bottom")    ; right         #right
    Widgets(Hex(9)) = Button(10, 170, 80, 20, "left&bottom")      ; right         #right
    
    SetAlignment(Widgets(Hex(1)),#__align_center|#__align_Left) 
    SetAlignment(Widgets(Hex(2)),#__align_center|#__align_top) 
    SetAlignment(Widgets(Hex(3)),#__align_center|#__align_right)              
    SetAlignment(Widgets(Hex(4)),#__align_center|#__align_Bottom)      
    
    SetAlignment(Widgets(Hex(5)),#__align_Center)
    
    ;SetAlignment(Widgets(Hex(6)),#__align_none) 
    SetAlignment(Widgets(Hex(7)),#__align_right)
    SetAlignment(Widgets(Hex(8)),#__align_right|#__align_bottom) 
    SetAlignment(Widgets(Hex(9)),#__align_bottom) 
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 260,200)
  EndProcedure
  
  Procedure example_3()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 0, 0, 190, 200, "Resize gadget", #PB_Window_ScreenCentered | #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    Widgets(Hex(1)) = Button(0, 20, 80, 160, "left")  
    Widgets(Hex(2)) = Button(0, 0, 190, 20, "top")   
    Widgets(Hex(3)) = Button(110, 20, 80, 160, "right")    
    Widgets(Hex(4)) = Button(0, 180, 190, 20, "bottom")   
    
    Widgets(Hex(5)) = Button(80, 20, 30, 160, "center")   
    
    ;       Widgets(Hex(1)) = Button(0, 0, 80, 20, "left")  
    ;       Widgets(Hex(2)) = Button(0, 0, 80, 20, "top")   
    ;       Widgets(Hex(3)) = Button(0, 0, 80, 20, "right")    
    ;       Widgets(Hex(4)) = Button(0, 0, 80, 20, "bottom")   
    ;       
    ;       Widgets(Hex(5)) = Button(0, 0, 80, 20, "center")   
    
    SetAlignment(Widgets(Hex(1)),#__align_full|#__align_Left) 
    SetAlignment(Widgets(Hex(2)),#__align_full|#__align_top) 
    SetAlignment(Widgets(Hex(3)),#__align_full|#__align_right)              
    SetAlignment(Widgets(Hex(4)),#__align_full|#__align_Bottom)      
    
    SetAlignment(Widgets(Hex(5)),#__align_full)
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 260,260)
  EndProcedure
  
  example_0()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --
; EnableXP