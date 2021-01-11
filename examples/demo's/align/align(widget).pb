
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
    
    Widgets(Hex(1)) = Text(10,  10, 200, 50, "Resize the window, the gadgets will be automatically resized", #__text_center)
    ; Widgets(Hex(3)) = ButtonImageGadget(3, 10, 70, 200, 60, ImageID(0))
    Widgets(Hex(2)) = Editor(10, 140, 200, 20) : SetText(Widgets(Hex(2)),"Editor")
    Widgets(Hex(4)) = Button(10, 170, 490, 20, "Button / toggle", #__button_toggle)
    Widgets(Hex(5)) = Text(220,10,190,20,"Text", #__text_center) : SetColor(Widgets(Hex(5)), #PB_Gadget_BackColor, $00FFFF)
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
    SetAlignment(Widgets(Hex(10)),#__align_bottom|#__align_left|#__align_right) 
    SetAlignment(Widgets(Hex(11)),#__align_bottom|#__align_top|#__align_right) 
    SetAlignment(Widgets(Hex(12)),#__align_bottom|#__align_right)
    SetAlignment(Widgets(Hex(13)),#__align_bottom|#__align_right)
    SetAlignment(Widgets(Hex(14)),#__align_bottom|#__align_right)
    SetAlignment(Widgets(Hex(15)),#__align_bottom|#__align_right)
    
  EndProcedure
  
  ; proportional
  Procedure example_1()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 0, 0, 190, 200, "proportional", #PB_Window_ScreenCentered | #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    Widgets(Hex(2)) = Button(55, 5, 80, 20, "center")   ; center \2     align_proportional_horizontal
    Widgets(Hex(3)) = Button(55, 25, 80, 20, "right")   ; right         #right
    Widgets(Hex(4)) = Container(55, 45, 80, 20)         ; stretch       #stretch 
    Widgets(Hex(44)) = Button(0, 5, 80, 20, "parent stretch")
    CloseList()
    
    Widgets(Hex(5)) = Button(55, 65, 80, 20, ">>|<<")    ; proportional  #proportion
    
    Widgets(Hex(6)) = Button(10, 90, 80, 20, ">>|", #__button_right) ; proportional
    Widgets(Hex(7)) = Button(100, 90, 80, 20, "|<<", #__button_left) ; proportional
    
    Widgets(Hex(8)) = Button(10, 115, 50, 20, ">>|", #__button_right) ; proportional
    Widgets(Hex(9)) = Button(60, 115, 20, 20, "|")                    ; proportional
    Widgets(Hex(10)) = Button(80, 115, 30, 20, "<<>>")                ; proportional
    Widgets(Hex(11)) = Button(110, 115, 20, 20, "|")                  ; proportional
    Widgets(Hex(12)) = Button(130, 115, 50, 20, "|<<", #__button_left); proportional
    
    
    SetAlignment(Widgets(Hex(2)), #__align_vertical |#__align_center|#__align_top|#__align_proportional)    
    SetAlignment(Widgets(Hex(3)), #__align_center|#__align_right)
    SetAlignment(Widgets(Hex(4)), #__align_vertical |#__align_full|#__align_proportional) ; stretch proportional
    SetAlignment(Widgets(Hex(44)), #__align_center|#__align_top)
    
    SetAlignment(Widgets(Hex(5)), #__align_bottom |#__align_left|#__align_right|#__align_proportional)
    
    SetAlignment(Widgets(Hex(6)), #__align_bottom |#__align_left|#__align_proportional)
    SetAlignment(Widgets(Hex(7)), #__align_bottom |#__align_right|#__align_proportional)
    
    SetAlignment(Widgets(Hex(8)), #__align_bottom)
    SetAlignment(Widgets(Hex(9)), #__align_bottom)
    SetAlignment(Widgets(Hex(10)), #__align_bottom |#__align_left|#__align_right)
    SetAlignment(Widgets(Hex(11)), #__align_bottom |#__align_right)
    SetAlignment(Widgets(Hex(12)), #__align_bottom |#__align_right)
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 260,260)
  EndProcedure
  
  ; auto alignment
  Procedure example_2()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 100, 100, 190, 200, "alignment", #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    Widgets(Hex(1)) = Button(0, 0, 80, 40, "left")        ; center \2     align_proportional_horizontal
    Widgets(Hex(2)) = Button(0, 0, 80, 40, "top")         ; center \2     align_proportional_horizontal
    Widgets(Hex(3)) = Button(0, 0, 80, 40, "right")       ; right         #right
    Widgets(Hex(4)) = Button(0, 0, 80, 40, "bottom")      ; right         #right
    
    Widgets(Hex(5)) = Button(0, 0, 80, 40, "center")      ; center \2     align_proportional_horizontal
    
    Widgets(Hex(6)) = Button(0, 0, 80, 40, "left&top")    ; right         #right
    Widgets(Hex(7)) = Button(0, 0, 80, 40, "right&top")   ; right         #right
    Widgets(Hex(8)) = Button(0, 0, 80, 40, "right&bottom"); right         #right
    Widgets(Hex(9)) = Button(0, 0, 80, 40, "left&bottom") ; right         #right
    
    SetAlignment(Widgets(Hex(1)),#__align_auto|#__align_center|#__align_left) 
    SetAlignment(Widgets(Hex(2)),#__align_auto|#__align_center|#__align_top) 
    SetAlignment(Widgets(Hex(3)),#__align_auto|#__align_center|#__align_right)              
    SetAlignment(Widgets(Hex(4)),#__align_auto|#__align_center|#__align_bottom)      
    
    SetAlignment(Widgets(Hex(5)),#__align_auto|#__align_center)
    
    SetAlignment(Widgets(Hex(6)),#__align_auto|#__align_none) 
    SetAlignment(Widgets(Hex(7)),#__align_auto|#__align_right)
    SetAlignment(Widgets(Hex(8)),#__align_auto|#__align_bottom|#__align_right) 
    SetAlignment(Widgets(Hex(9)),#__align_auto|#__align_bottom) 
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 300,260)
  EndProcedure
  
  ; auto docking
  Procedure example_3()
    Define *w._S_widget = Open( OpenWindow( #PB_Any, 500, 200, 390, 200, "docking", #PB_Window_SizeGadget))
    Canvas_0 = GetGadget(*w)
    Window_0 = GetWindow(*w)
    
    Widgets(Hex(1)) = Button(0, 0, 60, 20, "left")  
    Widgets(Hex(2)) = Button(0, 0, 80, 40, "top")   
    Widgets(Hex(3)) = Button(0, 0, 60, 20, "right")    
    Widgets(Hex(4)) = Button(0, 0, 80, 20, "bottom")   
    
    Widgets(Hex(11)) = Button(0, 0, 40, 20, "left2")   
    Widgets(Hex(33)) = Button(0, 0, 40, 40, "right2")   
    Widgets(Hex(22)) = Button(0, 0, 80, 20, "top2")   
    Widgets(Hex(44)) = Button(0, 0, 80, 40, "bottom2")   
    
    Widgets(Hex(5)) = Container(0, 0, 80, 20)   
    Widgets(Hex(51)) = Button(0, 0, 60, 20, "left")  
    Widgets(Hex(52)) = Button(0, 0, 80, 40, "top")   
    Widgets(Hex(53)) = Button(0, 0, 60, 20, "right")    
    Widgets(Hex(54)) = Button(0, 0, 80, 20, "bottom")   
    
    Widgets(Hex(55)) = Button(0, 0, 80, 20, "center")   
    
    CloseList()
    
    SetAlignment(Widgets(Hex(1)), #__align_full|#__align_auto|#__align_left) 
    SetAlignment(Widgets(Hex(2)), #__align_full|#__align_auto|#__align_top) 
    SetAlignment(Widgets(Hex(3)), #__align_full|#__align_auto|#__align_right)              
    SetAlignment(Widgets(Hex(4)), #__align_full|#__align_auto|#__align_bottom)      
    
    SetAlignment(Widgets(Hex(11)),#__align_full|#__align_auto|#__align_left) 
    SetAlignment(Widgets(Hex(33)),#__align_full|#__align_auto|#__align_right)              
    SetAlignment(Widgets(Hex(22)),#__align_full|#__align_auto|#__align_top) 
    SetAlignment(Widgets(Hex(44)),#__align_full|#__align_auto|#__align_bottom)      
    
    SetAlignment(Widgets(Hex(5)), #__align_full|#__align_auto)
    
    SetAlignment(Widgets(Hex(51)),#__align_full|#__align_auto|#__align_left) 
    SetAlignment(Widgets(Hex(52)),#__align_full|#__align_auto|#__align_top) 
    SetAlignment(Widgets(Hex(53)),#__align_full|#__align_auto|#__align_right)              
    SetAlignment(Widgets(Hex(54)),#__align_full|#__align_auto|#__align_bottom)      
    
    SetAlignment(Widgets(Hex(55)),#__align_auto|#__align_full)
    
    ResizeWindow(Window_0, #PB_Ignore, #PB_Ignore, 460,360)
  EndProcedure
  
  ; example_1()
  example_2()
  example_3()
  example_1()
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = l-
; EnableXP