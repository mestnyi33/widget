EnableExplicit

#Win          = 0
#Bar          = 0
#TabsDistance = 12

#ColTab = 8421504
#ColSwp = 255
#ColBar = 16777215

Structure _s_swapped 
  stop.l
  pos.l
  min.l
  max.l
EndStructure

Structure TAB
  x    .l
  width.l
  swapped._s_swapped
  Text         .s
EndStructure

Global NewList Tabs.TAB()
Global *TabSwap    .TAB
Define *Tab        .TAB
Define Event       .i
Define Barwidth       .i
Define MouseX      .i
Define MouseY      .i
Define MouseDownX  .i
Define MouseDownY  .i
Define Tabswidth      .i

;Add tabs to list
AddElement (Tabs()) : Tabs()\width =  40 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\width
AddElement (Tabs()) : Tabs()\width = 140 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\width
AddElement (Tabs()) : Tabs()\width =  70 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\width
AddElement (Tabs()) : Tabs()\width = 130 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\width

;Calc bar width
ForEach Tabs()
  Barwidth + Tabs()\width + #TabsDistance
Next
Barwidth - #TabsDistance

;Create window and bar
OpenWindow   (#Win,  0,  0, Barwidth + 20, 40, "Swap Tabs", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CanvasGadget (#Bar, 10, 10, Barwidth     , 20)

  
Procedure draw_tab(*this.tab, color.l)
  If Alpha(color)
    DrawingMode (#PB_2DDrawing_AlphaBlend)
  Else
    DrawingMode (#PB_2DDrawing_Default)
  EndIf
  Box      (*this\x + *this\swapped\pos, 0, *this\width, 20, color)
  
  DrawingMode (#PB_2DDrawing_Transparent)
  DrawText (*this\x + *this\swapped\pos + 2, 2, *this\Text)
EndProcedure

Procedure DrawBar (*selected.tab)
  Define x.i
  Define *Tab      .TAB
  
  ;Calc x
  If *selected = 0
    ForEach Tabs() 
      *Tab = @Tabs()
      *Tab\x = x
      x + *Tab\width + #TabsDistance
    Next
  EndIf
  
  StartDrawing (CanvasOutput (#Bar))
  
  ;Draw background
  DrawingMode (#PB_2DDrawing_Default)
  Box (0, 0, GadgetWidth (#Bar), GadgetHeight (#Bar), #ColBar)
  
  ;Draw tabs
  ForEach Tabs() 
    *Tab = @Tabs()
    
    If *Tab <> *selected
      draw_tab(*Tab, #ColTab)
    EndIf
  Next
  
  ;Draw swapping tab
  If *selected
    draw_tab(*selected, $70000000 | #ColSwp)
  EndIf
  
  StopDrawing ()
  
EndProcedure

;Draw bar
DrawBar (0)

;Eventloop
Repeat
  
  Event = WaitWindowEvent()
  
  If Event = #PB_Event_Gadget And EventGadget() = #Bar 
    
    MouseX = GetGadgetAttribute(0, #PB_Canvas_MouseX)
    MouseY = GetGadgetAttribute(0, #PB_Canvas_MouseY)
    
    ;_________
    ;Left down
    ;¯¯¯¯¯¯¯¯¯
    
    If EventType() = #PB_EventType_LeftButtonDown
      
      ;Store MouseDown
      MouseDownX = MouseX
      MouseDownY = MouseY
      
      ;Find TabSwap
      ForEach Tabs() 
        *Tab = @Tabs()
        
        If MouseX >= *Tab\x And
           MouseX < *Tab\x + *Tab\width
          *TabSwap = *Tab
        EndIf
      Next
      
      If *TabSwap
        
        ;Align all tabs to right (without TabSwap)
        ForEach Tabs() 
          *Tab = @Tabs()
          
          If *Tab = *TabSwap 
            Break 
          EndIf
          
          *Tab\x + *TabSwap\width + #TabsDistance
        Next
        
        ;Calc _swap_min/Max
        ForEach Tabs() 
          *Tab = @Tabs()
          
          If *Tab <> *TabSwap
            *Tab\swapped\min = Tabswidth - *Tab\x
            *Tab\swapped\max = Tabswidth - *Tab\x + *TabSwap\width + #TabsDistance
            
            
            If (*TabSwap\x + *TabSwap\width) > *Tab\x
              ; Debug  ""+*Tab\x +" "+ *Tab\swapped\min +" "+ *Tab\swapped\max +" "+ ListIndex(Tabs())
              *Tab\swapped\pos = *Tab\swapped\min
            EndIf
            
; ;             ;Calc position
; ;             *Tab\swapped\pos = (*Tab\x - *TabSwap\swapped\pos)
; ;             *Tab\swapped\pos - (*TabSwap\x + *TabSwap\width)
; ;             *Tab\swapped\pos * (*TabSwap\width + #TabsDistance) / (*Tab\width)
; ;             
; ;             ;Limit position to minimum
; ;             If *Tab\swapped\pos < *Tab\swapped\min
; ;               *Tab\swapped\pos = *Tab\swapped\min
; ;             EndIf
; ;             
; ;             ;Limit position to maximum
; ;             If *Tab\swapped\pos > *Tab\swapped\max
; ;               *Tab\swapped\pos = *Tab\swapped\max
; ;             EndIf  
            
            Tabswidth + *Tab\width + #TabsDistance
         EndIf
        Next
        
        ;Calc _swap_min/Max for TabSwap
        *TabSwap\swapped\min =- *TabSwap\x
        *TabSwap\swapped\max =- *TabSwap\x + Tabswidth
        
        
;         ForEach Tabs() 
;           *Tab = @Tabs()
;           Debug  ""+*Tab\x +" "+ *Tab\swapped\min +" "+ *Tab\swapped\max
;         Next
        
        DrawBar (*TabSwap)
      EndIf
      
    EndIf
    
    ;_______
    ;Left up
    ;¯¯¯¯¯¯¯
    
    If EventType() = #PB_EventType_LeftButtonUp
      
      ;Sum-up Offsets and sort list
      ForEach Tabs()
        If Tabs()\swapped\pos
          Tabs()\x + Tabs()\swapped\pos
          Tabs()\swapped\pos = 0
        EndIf
      Next
      
      SortStructuredList (Tabs(), #PB_Sort_Ascending, OffsetOf (Tab\x), TypeOf (Tab\x))
        
      ;Resets variables
      *TabSwap       = 0
      Tabswidth      = 0
      MouseDownX     = 0
      MouseDownY     = 0
      
      ;Draw bar
      DrawBar (0)
      
    EndIf
    
    ;__________
    ;Mouse move
    ;¯¯¯¯¯¯¯¯¯¯
    
    If EventType() = #PB_EventType_MouseMove
      If *TabSwap
        ForEach Tabs() 
          *Tab = @Tabs()
          
          ;Calc position
          If *Tab = *TabSwap
            *Tab\swapped\pos = MouseX - MouseDownX ; + #TabsDistance
          Else
            *Tab\swapped\pos = (*Tab\x - *TabSwap\swapped\pos)
            *Tab\swapped\pos - (*TabSwap\x + *TabSwap\width)
            *Tab\swapped\pos * (*TabSwap\width + #TabsDistance*2) / (*Tab\width)
          EndIf
          
          ;Debug  ""+*Tab\swapped\min +" "+ *Tab\swapped\max
        
          ;Limit position to minimum
          If *Tab\swapped\pos < *Tab\swapped\min
            *Tab\swapped\pos = *Tab\swapped\min
          EndIf
          
          ;Limit position to maximum
          If *Tab\swapped\pos > *Tab\swapped\max
            *Tab\swapped\pos = *Tab\swapped\max
          EndIf
        Next
        
        ;Debug  *TabSwap\swapped\pos
        If *TabSwap\swapped\stop <> *TabSwap\swapped\pos
          *TabSwap\swapped\stop = *TabSwap\swapped\pos
          ;Draw bar
          DrawBar (*TabSwap)
        EndIf
      EndIf
      
    EndIf
    
  EndIf    
  
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ----
; EnableXP