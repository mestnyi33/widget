;IncludePath "/Users/as/Documents/GitHub/Widget/"
;XIncludeFile "_module_listicon_3_0.pb"
XIncludeFile "_module_list_1_0.pb"

UseModule ListIcon
Global g_Canvas, NewMap *List._S_widget()

Procedure _ReDraw(Canvas)
  If StartDrawing(CanvasOutput(Canvas))
    FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F6)
    
    ; PushListPosition(*List())
    ForEach *List()
      If Not *List()\hide
        Draw(*List())
      EndIf
    Next
    ; PopListPosition(*List())
    
    StopDrawing()
  EndIf
EndProcedure

Procedure.i Canvas_Events()
  Protected Canvas.i = EventGadget()
  Protected EventType.i = EventType()
  Protected Repaint
  Protected Width = GadgetWidth(Canvas)
  Protected Height = GadgetHeight(Canvas)
  Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
  Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
  ;      MouseX = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
  ;      MouseY = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
  Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
  Protected *callback = GetGadgetData(Canvas)
  ;     Protected *this._S_bar = GetGadgetData(Canvas)
  
  Select EventType
    Case #PB_EventType_Resize ; : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                              ;          ForEach *List()
                              ;            Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
                              ;          Next
      Repaint = 1
      
    Case #PB_EventType_LeftButtonDown
      SetActiveGadget(Canvas)
      
  EndSelect
  
  ForEach *List()
    *List()\canvas\gadget = EventGadget()
    *List()\canvas\window = EventWindow()
    
    Repaint | CallBack(*List(), EventType);, MouseX, MouseY)
  Next
  
  If Repaint 
    _ReDraw(Canvas)
  EndIf
EndProcedure


; Shows possible flags of ListIconGadget in action...
If OpenWindow(0, 0, 0, 1030, 800, "ListIconGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ; Here we change the ListIcon display to large icons and show an image
  UsePNGImageDecoder()
  LoadImage(0, #PB_Compiler_Home+"examples/sources/Data/ToolBar/Paste.png")     ; change path/filename to your own 32x32 pixel image
  
  ;{ gadgets
  Define x = 10
  ; left column
  TextGadget(#PB_Any,   5,  10, 330, 20, "ListIcon Standard", #PB_Text_Center)
  ListIconGadget(0,    10,  20, 330, 100, "Column 1", 100)
  TextGadget(#PB_Any,  10, 125, 330, 20, "ListIcon with Checkbox", #PB_Text_Center)
  ListIconGadget(1,    10, 140, 330, 100, "Column 1", 100, #PB_ListIcon_CheckBoxes)  ; ListIcon with checkbox
  TextGadget(#PB_Any,  10, 235, 330, 20, "ListIcon with Multi-Selection", #PB_Text_Center)
  ListIconGadget(2,    10, 260, 330, 100, "Column 1", 100, #PB_ListIcon_MultiSelect) ; ListIcon with multi-selection
  
  x = 350
  ; center column
  TextGadget(#PB_Any, x,  5,  330, 20, "ListIcon with separator lines and not items",#PB_Text_Center)
  ListIconGadget(3,   x,  20, 330, 100, "Column 1", 100, #PB_ListIcon_GridLines)
  TextGadget(#PB_Any, x, 125, 330, 20, "ListIcon with Checkbox and Image",#PB_Text_Center)
  ListIconGadget(4,   x, 140, 330, 100, "Column 1", 100, #PB_ListIcon_CheckBoxes)
  TextGadget(#PB_Any, x, 235, 330, 20, "ListIcon with List",#PB_Text_Center)
  ListIconGadget(5,   x, 260, 330, 100, "", 200,#PB_ListIcon_List)
  
  x = 690
  ; right column
  TextGadget(#PB_Any, x,  5,  330, 20, "ListIcon with separator lines",#PB_Text_Center)
  ListIconGadget(6,   x,  20, 330, 100, "Column 1", 100, #PB_ListIcon_GridLines)
  TextGadget(#PB_Any, x, 125, 330, 20, "ListIcon with Report",#PB_Text_Center)
  ListIconGadget(7,   x, 140, 330, 100, "Column 1", 100, #PB_ListIcon_Report)
  TextGadget(#PB_Any, x, 235, 330, 20, "ListIcon Standard with large icons",#PB_Text_Center)
  ListIconGadget(8,   x, 260, 330, 100, "", 200)
  ;CocoaMessage (0, GadgetID (8), "setHeaderView:", 0)
  
  For a = 0 To 8
    If a<>3 And a<>8
      For b = 2 To 4          ; add 3 more columns to each listicon
        AddGadgetColumn(a, b, "Column " + Str(b), 65)
      Next
      For b = 0 To 12          ; add 4 items to each line of the listicons
        AddGadgetItem(a, b, "Item 1"+Chr(10)+"Item 2"+Chr(10)+"Item 3"+Chr(10)+"Item 4", Bool(a=5 Or a=4 Or a=7) * ImageID(0))
      Next
    EndIf
  Next
  
  SetGadgetAttribute(8, #PB_ListIcon_DisplayMode, #PB_ListIcon_LargeIcon)
  AddGadgetItem(8, 1, "Picture 1", ImageID(0))
  AddGadgetItem(8, 2, "Picture 2", ImageID(0))
  ;}
  
  g_Canvas = CanvasGadget(-1, 0, 380, 1030, 420, #PB_Canvas_Container)
  BindGadgetEvent(g_Canvas, @Canvas_Events())
  PostEvent(#PB_Event_Gadget, 0,g_Canvas, #PB_EventType_Resize)
  
  x = 10
  ; left column
  TextGadget    (#PB_Any,  10,  5,  330, 14, "ListIcon Standard", #PB_Text_Center)
  *List(Hex(0)) = widget(  10,  20, 330, 100, "Column 1", 100)
  TextGadget    (#PB_Any,  10, 125, 330, 14, "ListIcon with Checkbox", #PB_Text_Center)
  *List(Hex(1)) = widget(  10, 140, 330, 100, "Column 1", 100, #PB_Flag_CheckBoxes)  ; ListIcon with checkbox
  TextGadget    (#PB_Any,  10, 245, 330, 14, "ListIcon with Multi-Selection", #PB_Text_Center)
  *List(Hex(2)) = widget(  10, 260, 330, 100, "Column 1", 100, #PB_Flag_MultiSelect) ; ListIcon with multi-selection
  
  x = 350
  ; center column
  TextGadget   (#PB_Any, x,  5,  330, 14, "ListIcon with separator lines and not items",#PB_Text_Center)
  *List(Hex(3)) = widget(x,  20, 330, 100, "Column 1", 100, #PB_Flag_GridLines)
  TextGadget   (#PB_Any, x, 125, 330, 14, "ListIcon with Checkbox and Image",#PB_Text_Center)
  *List(Hex(4)) = widget(x, 140, 330, 100, "Column 1", 100, #PB_Flag_CheckBoxes)
  TextGadget   (#PB_Any, x, 245, 330, 14, "ListIcon Standard with icons",#PB_Text_Center)
  *List(Hex(5)) = widget(x, 260, 330, 100, "", 200,#PB_Flag_GridLines)
  
  x = 690
  ; right column
  TextGadget   (#PB_Any, x,  5,  330, 14, "ListIcon with separator lines",#PB_Text_Center)
  *List(Hex(6)) = widget(x,  20, 330, 100, "Column 1", 100, #PB_Flag_GridLines)
  TextGadget   (#PB_Any, x, 125, 330, 14, "ListIcon with FullRowSelect and AlwaysShowSelection",#PB_Text_Center)
  *List(Hex(7)) = widget(x, 140, 330, 100, "Column 1", 100, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
  TextGadget   (#PB_Any, x, 245, 330, 14, "ListIcon Standard with large icons",#PB_Text_Center)
  *List(Hex(8)) = widget(x, 260, 330, 100, "", 200)
  
  For a = 0 To 8
    If a<>3 And a<>8
      For b = 2 To 4          ; add 3 more columns to each listicon
        AddColumn(*List(Hex(a)), b, "Column " + Str(b), 65)
      Next
      For b = 0 To 2          ; add 4 items to each line of the listicons
        AddItem(*List(Hex(a)), b, "Item 1"+Chr(10)+"Item 2"+Chr(10)+"Item 3"+Chr(10)+"Item 4", Bool(a<>5 And a<>4 And a<>7) * (-1))
      Next
    EndIf
  Next
  
  ;SetAttribute(*List(Hex(8)), #PB_ListIcon_DisplayMode, #PB_ListIcon_LargeIcon)
  AddItem(*List(Hex(8)), 1, "Picture 1", (0))
  AddItem(*List(Hex(8)), 2, "Picture 2", (0))
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP