XIncludeFile "../../../-widgets.pbi" 


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
  Global *this._s_widget
  Global *button._s_widget
  Global *current._s_widget
  
  #first=99
  #before=100
  #after=101
  #last=102
  #return = 103
  
  Global after
  Global before
  
  Procedure Demo()
    Protected y = 10
    Protected x = 30
    Protected h = 26+20
    Protected s = 24
    Protected font = LoadFont(#PB_Any, "arial", 40)
    Protected   ParentID = OpenWindow(0, 0, 0, 270, 145+s*9, "Demo z-order gadget", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
    
    Open(0, 0, 0, 270, 271+s*9)
    
    ;    Button(x, y+56+s*9, 215, h, "1",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget())) ; Gadget(8, 
    ;{ first container
    Container(x, y+56+s*9, 215, h)                     ; Gadget(9,   
    SetClass(widget(), "first_0")
    SEtColor(widget(), #PB_Gadget_BackColor, $00ffff)
    
    Container(4, 0, 215-6, h-4-2) 
    SetClass(widget(), "first_1")
    SEtColor(widget(), #PB_Gadget_BackColor, $00ffff)
    
    Container(4, 0, 215-6-6, h-4-2-6) 
    SetClass(widget(), "first_2")
    SEtColor(widget(), #PB_Gadget_BackColor, $00ffff)
    
    Button(4, 0, 215-12, h-8-4-4, "1", #__Button_Right|#__text_top) 
    SetClass(widget(), GetText(widget())) 
    CloseList()
    CloseList()
    CloseList()
    ;}
    
    
    Button(x, y+51+s*8, 195, h, "2",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget())) ; Gadget(8, 
    *current = Button(x, y+47+s*7, 175, h, "3",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget())) ; Gadget(7, 
    Button(x, y+43+s*6, 155, h, "4",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget())) ; Gadget(6, 
    
    ;;*this = Button(10, y, 250, 80+h+s*9, "6 < 5 > 4", #__Button_Right|#__text_top) : SetClass(widget(), GetText(widget())) : *current = *this
    ;;SetFont(widget(), FontID(font))
    
    ;{ current container
    *this = Container(10, y, 250, 80+h+s*9)              ; Gadget(10, 
    SEtColor(widget(), #PB_Gadget_BackColor, $ffff00)
    SetClass(widget(), "this_0")
    
    Container(250-200-2, 4, 200, (80+h+s*9)-8-2)   
    SEtColor(widget(), #PB_Gadget_BackColor, $ffff00)
    SetClass(widget(), "this_1")
    
    *button = Button(4, 4, 200-4, (80+h+s*9)-16-4, "6 < 5 > 4", #__Button_Right|#__text_top) 
    SetClass(widget(), "this_2") 
    CloseList()
    CloseList()
    ;}
    
    Button(x, y+35+s*4, 115, h, "6",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget()))  ; Gadget(4, 
    Button(x, y+31+s*3, 95, h, "7",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget()))   ; Gadget(3, 
    Button(x, y+27+s*2, 75, h, "8",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget()))   ; Gadget(2, 
    
    ;; Button(x, y+23+s*1, 55, h, "9",#__Button_Right|#__text_top) : SetClass(widget(), GetText(widget()))  ; Gadget(2, 
    ;{ last container
    Container(x, y+23+s*1, 55, h)                     ; Gadget(1,
    SetClass(widget(), "last_0")
    SEtColor(widget(), #PB_Gadget_BackColor, $ff00ff)
    
    Container(4, 0, 49, h-4-2)   
    SetClass(widget(), "last_1")
    SEtColor(widget(), #PB_Gadget_BackColor, $ff00ff)
    
    Button(4, 0, 43, h-8-4, "9", #__Button_right|#__text_top) 
    SetClass(widget(), GetText(widget())) 
    CloseList()
    CloseList()
    ;}
    
    
    SetPosition(*this, #PB_List_Before, *current)
    ;SetPosition(*this, #PB_List_After, *current)
    
    ResizeWindow(0,WindowX(0)-200,#PB_Ignore,#PB_Ignore,#PB_Ignore)
    
    OpenWindow(10, 0, 0, 130, 180, "", #PB_Window_TitleBar|#PB_Window_ScreenCentered, ParentID)
    ButtonGadget(#last, 5, 10, 120, 30, "last (top)")
    ButtonGadget(#before, 5, 40, 120, 30, "before (prev)")
    ButtonGadget(#after, 5, 70, 120, 30, "after (next)")
    ButtonGadget(#first, 5, 100, 120, 30, "first (bottom)") 
    
    ButtonGadget(#return, 5, 145, 120, 30, "return")
    DisableGadget(#return, 1)
  EndProcedure
  
  Demo()
  
    
  Define gEvent, gQuit, text.s, repaint 
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_Gadget
        Select EventType()
          Case #PB_EventType_LeftClick
            Select EventGadget()
              Case #first 
                DisableGadget(#return, 0)
                before = GetPosition(*this, #PB_List_Before)
                
                If SetPosition(*this, #PB_List_First)
                  repaint = 1
                EndIf
                
              Case #before 
                If SetPosition(*this, #PB_List_Before) 
                  repaint = 1
                EndIf
                
              Case #after 
                If SetPosition(*this, #PB_List_After)
                  repaint = 1
                EndIf
                
              Case #last 
                DisableGadget(#return, 0)
                after = GetPosition(*this, #PB_List_After)
                
                If SetPosition(*this, #PB_List_Last)
                  repaint = 1
                EndIf
                
              Case #return
                DisableGadget(#return, 1) 
                If after
                  ;Debug GetClass(after)+"  - after"
                  If SetPosition(*this, #PB_List_Before, after)
                    repaint = 1
                  EndIf
                EndIf
                
                If before
                  ;Debug GetClass(before)+"  - before"
                  If SetPosition(*this, #PB_List_After, before) 
                    repaint = 1
                  EndIf
                EndIf
            EndSelect
            
            If repaint
              text = ""
              Debug ""+ *this +" "+ GetPosition(*this, #PB_List_After) +" "+ GetPosition(*this, #PB_List_Before)
              
              If GetPosition(*this, #PB_List_After)
                If GetType(GetPosition(*this, #PB_List_After)) = #PB_GadgetType_Container
                  If GetPosition(*this, #PB_List_Before)
                    text + "9"
                  Else
                    text + "1"
                  EndIf
                Else
                  text + GetClass(GetPosition(*this, #PB_List_After))
                EndIf
              EndIf
              
              text + " < 5 > "
              
              If GetPosition(*this, #PB_List_Before)
                If GetType(GetPosition(*this, #PB_List_Before)) = #PB_GadgetType_Container
                  If GetPosition(*this, #PB_List_After)
                    text + "1"
                  Else
                    text + "9"
                  EndIf
                Else
                  text + GetClass(GetPosition(*this, #PB_List_Before))
                EndIf
              EndIf
              
              SetText(*button, text)
              
              Redraw(Root())
              
              ;             ClearDebugOutput()
              ;             ForEach widget()
              ;               Debug ""+widget()\class +" "+ widget()\parent\first\class +" "+ widget()\parent\last\class
              ;             Next
              ;             
              ;             ;               Debug "first "+GetFirst(ParentID)
              ;             ;               Debug "last "+GetLast(ParentID)
              ;             ;               Debug "prev №1 < № "+GetPrev(1)
              ;             ;               Debug "next №1 > № "+GetNext(1)
            EndIf
            
        EndSelect
        
      Case #PB_Event_CloseWindow
        gQuit= #True
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -Tq-
; EnableXP