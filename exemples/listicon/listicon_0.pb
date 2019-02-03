IncludePath "../../"
XIncludeFile "widgets.pbi"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule widget
  
  Global *w_0.Widget_S, *w_1.Widget_S, *w_2.Widget_S
  LN=1500 ; количесвто итемов 
  
  Procedure ReDraw(Canvas)
    If IsGadget(Canvas) And StartDrawing(CanvasOutput(Canvas))
      ;       DrawingMode(#PB_2DDrawing_Default)
      ;       Box(0,0,OutputWidth(),OutputHeight(), winBackColor)
      FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
      
      Draw(*w_0)
      Draw(*w_1)
      Draw(*w_2)
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Canvas_CallBack()
    Protected Canvas.i=EventGadget()
    Protected EventType.i = EventType()
    Protected Repaint, iWidth, iHeight
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected mouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected mouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    
    Select EventType
      Case #PB_EventType_Repaint : Repaint = 1 
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Resize(*w_0, #PB_Ignore, #PB_Ignore, Width, Height)  
        Resize(*w_1, #PB_Ignore, #PB_Ignore, Width, Height)  
        Resize(*w_2, #PB_Ignore, #PB_Ignore, Width, Height)  
        Repaint = 1 
    EndSelect
    
    Repaint | CallBack(*w_0, EventType, mouseX,mouseY)
    Repaint | CallBack(*w_1, EventType, mouseX,mouseY)
    Repaint | CallBack(*w_2, EventType, mouseX,mouseY)
    
    If Repaint
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Procedure Events()
    If EventType() = #PB_EventType_LeftClick
      ;       If GadgetType(EventGadget()) = #PB_GadgetType_ListIcon
      ;         Debug GetGadgetText(EventGadget())
      ;         Debug GetGadgetState(EventGadget())
      ;         Debug GetGadgetItemState(EventGadget(), GetGadgetState(EventGadget()))
      ;       Else
      ;         Debug ListIcon::GetText(EventGadget())
      ;         Debug ListIcon::GetState(EventGadget())
      ;         Debug ListIcon::GetItemState(EventGadget(), ListIcon::GetState(EventGadget()))
      ;       EndIf
    EndIf
  EndProcedure
  
  UsePNGImageDecoder()
  ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  Define a,i
  
  If OpenWindow(0, 0, 0, 800, 450, "ListiconGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    SetActiveWindow(0)
    
    Define Count = 500
    Debug "Create items count - "+Str(Count)
    
    ;{ - gadget 
    Define t=ElapsedMilliseconds()
    Define g = 1
    ListIconGadget(g, 10, 10, 165, 210,"Column_1",90)                                         
    For i=1 To 2 : AddGadgetColumn(g, i,"Column_"+Str(i+1),90) : Next
    For i=0 To 7
      AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", ImageID(0))                                           
    Next
    
    g = 2
    ListIconGadget(g, 180, 10, 165, 210,"Column_1",90)                                         
    For i=1 To 2 : AddGadgetColumn(g, i,"Column_"+Str(i+1),90) : Next
    For i=0 To Count
      AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                           
    Next
    
    g = 3
    ListIconGadget(g, 350, 10, 440, 210,"Column_1",90, #PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines|#PB_ListIcon_CheckBoxes)                                         
    
    ;HideGadget(g,1)
    For i=1 To 2
      AddGadgetColumn(g, i,"Column_"+Str(i+1),90)
    Next
    ; 1_example
    For i=0 To 15
      AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", ImageID(0))                                           
    Next
    ;HideGadget(g,0)
    
    Debug " time create gadget (listicon) - "+Str(ElapsedMilliseconds()-t)
    ;}
    
    
    ;{ - widget
    ; Demo draw string on the canvas
    CanvasGadget(100, 10, 230, 780, 210, #PB_Canvas_Keyboard )
    BindGadgetEvent(100, @Canvas_CallBack())
    Use(0, 100)
    g = 100
    
    t=ElapsedMilliseconds()
    
    
    ;g = 11
    *w_0 = ListIcon(0, 0, 165, 210,"Column_1",90)                                      
    For i=1 To 2 : AddColumn(*w_0, i,"Column_"+Str(i+1),90) : Next
    ; 1_example
    For i=0 To 7
      AddItem(*w_0, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                           
    Next
    
    ;g = 12
    *w_1 = ListIcon(170, 0, 165, 210,"Column_1",90, #PB_Flag_FullSelection)                                         
    For i=1 To 2 : AddColumn(*w_1, i,"Column_"+Str(i+1),90) : Next
    ; 1_example
    For i=0 To Count
      AddItem(*w_1, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", -1)                                           
    Next
    
    ;g = 13
    *w_2 = ListIcon(340, 0, 440, 210,"Column_1",90, #PB_Flag_FullSelection|#PB_Flag_GridLines|#PB_Flag_CheckBoxes)                                     
    
    ;HideGadget(g,1)
    For i=1 To 2
      AddColumn(*w_2, i,"Column_"+Str(i+1),90)
    Next
    ; 1_example
    For i=0 To 15
      AddItem(*w_2, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                           
    Next
    ;HideGadget(g,0)
    
    Debug " time create canvas (listicon) - "+Str(ElapsedMilliseconds()-t)
    ;}
    
    ;   Define *This.Gadget = GetGadgetData(g)
    ;   
    ;   With *This\Columns()
    ;     Debug "Scroll_Height "+*This\Scroll\Height
    ;   EndWith
    ReDraw(100)
    
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          End 
        Case #PB_Event_Widget
          Select EventGadget()
            Case 13
              Select EventType()
                Case #PB_EventType_ScrollChange : Debug "widget ScrollChange" +" "+ EventData()
                Case #PB_EventType_DragStart : Debug "widget dragStart"
                Case #PB_EventType_Change, #PB_EventType_LeftClick
                  Debug "widget id = " + GetState(EventGadget())
                  
                  If EventType() = #PB_EventType_Change
                    Debug "  widget change"
                  EndIf
              EndSelect
          EndSelect
          
        Case #PB_Event_Gadget
          Select EventGadget()
            Case 3
              Select EventType()
                Case #PB_EventType_ScrollChange : Debug "ScrollChange" +" "+ EventData()
                Case #PB_EventType_DragStart : Debug "gadget dragStart"
                Case #PB_EventType_Change, #PB_EventType_LeftClick
                  Debug "gadget id = " + GetGadgetState(EventGadget())
                  
                  If EventType() = #PB_EventType_Change
                    Debug "  gadget change"
                  EndIf
              EndSelect
          EndSelect
      EndSelect
    ForEver
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ----
; EnableXP