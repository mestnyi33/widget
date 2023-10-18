; https://www.purebasic.fr/english/viewtopic.php?p=462631#p462631
; http://forums.purebasic.com/english/viewtopic.php?p=462631&hilit=swap+tabs&sid=354dadea542b23efb68a54fa13ceb495#p462631
EnableExplicit

  #Win          = 0
  #Bar          = 0
  #TabsDistance = 2

  #ColTab = 8421504
  #ColSwp = 255
  #ColBar = 16777215

  Structure TAB
    Wi           .i
    OffsetItem   .i
    OffsetMove   .i
    OffsetMoveMin.i
    OffsetMoveMax.i
    Text         .s
  EndStructure

  Global NewList Tabs.TAB()
  Global *TabSwap    .TAB
  Define *Tab        .TAB
  Define Event       .i
  Define BarWi       .i
  Define MouseX      .i
  Define MouseY      .i
  Define MouseDownX  .i
  Define MouseDownY  .i
  Define TabsWi      .i

 ;Add tabs to list
  AddElement (Tabs()) : Tabs()\Wi =  40 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\Wi
  AddElement (Tabs()) : Tabs()\Wi = 140 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\Wi
  AddElement (Tabs()) : Tabs()\Wi =  70 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\Wi
  AddElement (Tabs()) : Tabs()\Wi = 130 : Tabs()\Text = "" + ListIndex (Tabs()) + " - " + Tabs()\Wi

 ;Calc bar width
  ForEach Tabs()
    BarWi + Tabs()\Wi + #TabsDistance
  Next
  BarWi - #TabsDistance

 ;Create window and bar
  OpenWindow   (#Win,  0,  0, BarWi + 20, 40, "Swap Tabs", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CanvasGadget (#Bar, 10, 10, BarWi     , 20)

  Procedure DrawBar ()
    Define OffsetItem.i
    Define *Tab      .TAB

   ;Calc OffsetItem
    If *TabSwap = 0
      ForEach Tabs() : *Tab = @Tabs()
        *Tab\OffsetItem = OffsetItem
        OffsetItem + *Tab\Wi + #TabsDistance
      Next
    EndIf

    StartDrawing (CanvasOutput (#Bar))

     ;Draw background
      DrawingMode (#PB_2DDrawing_Default)
      Box (0, 0, GadgetWidth (#Bar), GadgetHeight (#Bar), #ColBar)

     ;Draw tabs
      ForEach  Tabs() : *Tab = @Tabs()
        If *Tab <> *TabSwap
          DrawingMode (#PB_2DDrawing_Default)
          Box      (*Tab\OffsetItem + *Tab\OffsetMove, 0, *Tab\Wi, 20, #ColTab)
          DrawingMode (#PB_2DDrawing_Transparent)
          DrawText (*Tab\OffsetItem + *Tab\OffsetMove + 2, 2, *Tab\Text)
        EndIf
      Next

     ;Draw swapping tab
      If *TabSwap
        DrawingMode (#PB_2DDrawing_AlphaBlend)
        Box      (*TabSwap\OffsetItem + *TabSwap\OffsetMove, 0, *TabSwap\Wi, 20, $70000000 | #ColSwp)
        DrawingMode (#PB_2DDrawing_Transparent)
        DrawText (*TabSwap\OffsetItem + *TabSwap\OffsetMove + 2, 2, *TabSwap\Text)
      EndIf

    StopDrawing ()

  EndProcedure

 ;Draw bar
  DrawBar ()

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
        ForEach Tabs() : *Tab = @Tabs()
          If MouseX >= *Tab\OffsetItem And MouseX < *Tab\OffsetItem + *Tab\Wi
            *TabSwap = *Tab
          EndIf
        Next

        If *TabSwap

         ;Align all tabs to right (without TabSwap)
          ForEach Tabs() : *Tab = @Tabs()
            If *Tab = *TabSwap : Break : EndIf
            *Tab\OffsetItem + *TabSwap\Wi + #TabsDistance
          Next

         ;Calc OffsetMoveMin/Max
          ForEach Tabs() : *Tab = @Tabs()
            If *Tab <> *TabSwap
              *Tab\OffsetMoveMin = TabsWi - *Tab\OffsetItem
              *Tab\OffsetMoveMax = TabsWi - *Tab\OffsetItem + *TabSwap\Wi + #TabsDistance
              TabsWi + *Tab\Wi + #TabsDistance
            EndIf
          Next

         ;Calc OffsetMoveMin/Max for TabSwap
          *TabSwap\OffsetMoveMin = - *TabSwap\OffsetItem
          *TabSwap\OffsetMoveMax = - *TabSwap\OffsetItem + TabsWi

        EndIf

      EndIf

     ;__________
     ;Mouse move
     ;¯¯¯¯¯¯¯¯¯¯

      If EventType() = #PB_EventType_MouseMove
        If *TabSwap
          ForEach Tabs() : *Tab = @Tabs()

           ;Calc OffsetMove
            If *Tab = *TabSwap
              *Tab\OffsetMove = MouseX - MouseDownX
            Else
              *Tab\OffsetMove = *Tab\OffsetItem - *TabSwap\OffsetItem - *TabSwap\OffsetMove
              *Tab\OffsetMove - (*TabSwap\Wi + #TabsDistance)
              *Tab\OffsetMove * (*TabSwap\Wi + #TabsDistance) / (*Tab\Wi + #TabsDistance)
            EndIf

           ;Limit OffsetMove to minimum
            If *Tab\OffsetMove < *Tab\OffsetMoveMin
              *Tab\OffsetMove = *Tab\OffsetMoveMin
            EndIf

           ;Limit OffsetMove to maximum
            If *Tab\OffsetMove > *Tab\OffsetMoveMax
              *Tab\OffsetMove = *Tab\OffsetMoveMax
            EndIf

          Next
        EndIf

       ;Draw bar
        DrawBar ()

      EndIf
      
      ;_______
      ;Left up
      ;¯¯¯¯¯¯¯
      
      If EventType() = #PB_EventType_LeftButtonUp
        
        ;Sum-up Offsets and sort list
        ForEach Tabs()
          Debug ""+Tabs()\OffsetItem +" "+ Tabs()\OffsetMove +" ("+ Tabs()\Text+")"
          Tabs()\OffsetItem + Tabs()\OffsetMove
          Tabs()\OffsetMove = 0
        Next
        SortStructuredList (Tabs(), #PB_Sort_Ascending, OffsetOf (Tab\OffsetItem), TypeOf (Tab\OffsetItem))
        
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