; https://www.purebasic.fr/english/viewtopic.php?p=462631#p462631
EnableExplicit

  #Win          = 0
  #Bar          = 0
  #TabsDistance = 10

  #ColTab = 8421504
  #ColSwp = 255
  #ColBar = 16777215

  Structure TAB
    height.i
    y.i
    OffsetMove   .i
    OffsetMoveMin.i
    OffsetMoveMax.i
    Text         .s
  EndStructure

  Global NewList Tabs.TabBarWidget()
  Global *TabSwap    .TAB
  Define *Tab        .TAB
  Define Event       .i
  Define BarWi       .i
  Define MouseX      .i
  Define MouseY      .i
  Define MouseDownX  .i
  Define MouseDownY  .i
  Define TabsWi      .i

;   ;Add tabs to list
;   AddElement (Tabs()) : Tabs()\height =  40 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\height
;   AddElement (Tabs()) : Tabs()\height = 100 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\height
;   AddElement (Tabs()) : Tabs()\height =  70 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\height
;   AddElement (Tabs()) : Tabs()\height = 140 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\height
;   
;   AddElement (Tabs()) : Tabs()\height = 150 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\height
  ;Add tabs to list
  AddElement (Tabs()) : Tabs()\height =  20 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\height
  AddElement (Tabs()) : Tabs()\height = 20 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\height
  AddElement (Tabs()) : Tabs()\height =  20 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\height
  AddElement (Tabs()) : Tabs()\height = 20 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\height
  
  AddElement (Tabs()) : Tabs()\height = 20 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\height

 ;Calc bar width
;   ForEach Tabs()
;     BarWi + Tabs()\height + #TabsDistance
;   Next
;   BarWi - #TabsDistance

 ;Create window and bar
  OpenWindow   (#Win,  0,  0, 300, 410, "Swap Tabs", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CanvasGadget (#Bar, 10, 10     , 280, 390)

  Procedure DrawBar ()
    Define Y.i
    Define *Tab      .TAB

   ;Calc Y
    If *TabSwap = 0
      ForEach Tabs()
        Tabs()\Y = Y
        Y + Tabs()\height + #TabsDistance
      Next
    EndIf

    StartDrawing (CanvasOutput (#Bar))

     ;Draw background
      DrawingMode (#PB_2DDrawing_Default)
      Box (0, 0, GadgetWidth (#Bar), GadgetHeight (#Bar), #ColBar)

     ;Draw tabs
      ForEach  Tabs() 
        If Tabs() <> *TabSwap
          DrawingMode (#PB_2DDrawing_Default)
          Box      (0, Tabs()\Y + Tabs()\OffsetMove, 280-20, Tabs()\height, #ColTab)
          DrawingMode (#PB_2DDrawing_Transparent)
          DrawText ( 2,Tabs()\Y + Tabs()\OffsetMove + 2, Tabs()\Text)
        EndIf
      Next

     ;Draw swapping tab
      If *TabSwap
        Debug *TabSwap\OffsetMove
    DrawingMode (#PB_2DDrawing_AlphaBlend)
        Box      ( 0,*TabSwap\Y + *TabSwap\OffsetMove, 280-20, *TabSwap\height, $70000000 | #ColSwp)
        DrawingMode (#PB_2DDrawing_Transparent)
        DrawText (2, *TabSwap\Y + *TabSwap\OffsetMove + 2, *TabSwap\Text)
      EndIf

    StopDrawing ()

  EndProcedure

 ;Draw bar
  DrawBar ()

 ;Eventloop
  Repeat

    Event = WaitWindowEvent()
        
    If Event = #PB_Event_Gadget And EventGadget() = #Bar 

      MouseX = GetWidgetAttribute(0, #PB_Canvas_MouseX)
      MouseY = GetWidgetAttribute(0, #PB_Canvas_MouseY)

     ;_________
     ;Left down
     ;?????????

      If EventType() = #PB_EventType_LeftButtonDown

       ;Store MouseDown
        MouseDownX = MouseX
        MouseDownY = MouseY

       ;Find TabSwap
        ForEach Tabs() 
          If MouseY >= Tabs()\Y And 
             MouseY < Tabs()\Y + Tabs()\height
            *TabSwap = @Tabs()
          EndIf
        Next

        If *TabSwap
          ;Align all tabs to bottom (without TabSwap)
          ForEach Tabs() 
            If Tabs() = *TabSwap 
              Break 
            EndIf
            Tabs()\Y + *TabSwap\height + #TabsDistance
          Next

         ;Calc OffsetMoveMin/Max
          ForEach Tabs() 
            If Tabs() <> *TabSwap
              Tabs()\OffsetMoveMin = TabsWi - Tabs()\Y
              Tabs()\OffsetMoveMax = Tabs()\OffsetMoveMin + *TabSwap\height + #TabsDistance
              TabsWi + Tabs()\height + #TabsDistance
            EndIf
          Next

         ;Calc OffsetMoveMin/Max for TabSwap
          *TabSwap\OffsetMoveMin = - *TabSwap\Y
          *TabSwap\OffsetMoveMax = - *TabSwap\Y + TabsWi
          Debug "Min/Max"+*TabSwap\OffsetMoveMin +" "+ *TabSwap\OffsetMoveMax
        EndIf

      EndIf

     ;__________
     ;Mouse move
     ;??????????

      If EventType() = #PB_EventType_MouseMove
        If *TabSwap
          ForEach Tabs() 
            ;Calc OffsetMove
            If Tabs() = *TabSwap
              Tabs()\OffsetMove = MouseY - MouseDownY
            Else
              Tabs()\OffsetMove = Tabs()\Y - *TabSwap\OffsetMove 
              Tabs()\OffsetMove - *TabSwap\Y - (*TabSwap\height + #TabsDistance)
              Tabs()\OffsetMove * (*TabSwap\height + #TabsDistance) / (Tabs()\height + #TabsDistance)
            EndIf

           ;Limit OffsetMove to minimum
            If Tabs()\OffsetMove < Tabs()\OffsetMoveMin
              Tabs()\OffsetMove = Tabs()\OffsetMoveMin
            EndIf

           ;Limit OffsetMove to maximum
            If Tabs()\OffsetMove > Tabs()\OffsetMoveMax
              Tabs()\OffsetMove = Tabs()\OffsetMoveMax
            EndIf
          Next
        EndIf

       ;Draw bar
        DrawBar ()

      EndIf
      
      ;_______
     ;Left up
     ;???????

      If EventType() = #PB_EventType_LeftButtonUp

       ;Sum-up Offsets and sort list
        ForEach Tabs()
          Tabs()\Y + Tabs()\OffsetMove
          ;Debug ""+Tabs()\OffsetMove+" "+Tabs()\Text
          Tabs()\OffsetMove = 0
        Next
        
        SortStructuredList (Tabs(), #PB_Sort_Ascending, OffsetOf (Tab\Y), TypeOf (Tab\Y))

       ;Resets variables
        TabsWi         = 0
        *TabSwap       = 0
        MouseDownX     = 0
        MouseDownY     = 0

       ;Draw bar
        DrawBar ()

      EndIf

     
    EndIf    
    
  Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP
; EnableOnError
; EnableUnicode