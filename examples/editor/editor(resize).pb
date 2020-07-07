; IncludePath "../../" : XIncludeFile "widgets.pbi"
XIncludeFile "../empty5.pb"

Uselib(widget)
  Global *g._S_widget, g_Canvas, NewList *List._S_widget()
  
  
CompilerIf #PB_Compiler_IsMainFile
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Procedure GadgetsClipCallBack( GadgetID, lParam )
      If GadgetID
        Protected Gadget = GetProp_( GadgetID, "PB_ID" )
        
        If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
          SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS|#WS_CLIPCHILDREN )
          
          If IsGadget( Gadget ) 
            Select GadgetType( Gadget )
              Case #PB_GadgetType_ComboBox
                Protected Height = GadgetHeight( Gadget )
                
              Case #PB_GadgetType_Text
                If (GetWindowLongPtr_(GadgetID( Gadget ), #GWL_STYLE) & #SS_NOTIFY) = #False
                  SetWindowLongPtr_(GadgetID( Gadget ), #GWL_STYLE, GetWindowLongPtr_(GadgetID( Gadget ), #GWL_STYLE) | #SS_NOTIFY)
                EndIf
                
              Case #PB_GadgetType_Frame, #PB_GadgetType_Image
                If (GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
                  SetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
                EndIf
                
                ; Для панел гаджета темный фон убирать
              Case #PB_GadgetType_Panel 
                If Not IsGadget( Gadget ) And (GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
                  SetWindowLongPtr_(GadgetID, #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
                EndIf
                
            EndSelect
            
            ;             If (GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
            ;               SetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
            ;             EndIf
          EndIf
          
          
          If Height
            ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height )
          EndIf
          
          SetWindowPos_( GadgetID, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
        EndIf
        
      EndIf
      
      ProcedureReturn GadgetID
    EndProcedure
  CompilerEndIf
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  Procedure events_tree_gadget()
    ;Debug " gadget - "+EventGadget()+" "+EventType()
    Protected EventGadget = EventGadget()
    Protected EventType = EventType()
    Protected EventData = EventData()
    Protected EventItem = GetGadgetState(EventGadget)
    
    Select EventType
      Case #PB_EventType_ScrollChange : Debug "gadget scroll change data "+ EventData
      Case #PB_EventType_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_DragStart : Debug "gadget dragStart item = " + EventItem +" data "+ EventData
      Case #PB_EventType_Change    : Debug "gadget change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_LeftClick : Debug "gadget click item = " + EventItem +" data "+ EventData
    EndSelect
  EndProcedure
  
  Procedure events_tree_widget()
    ;Debug " widget - "+*event\widget+" "+*event\type
    Protected EventGadget = *event\widget
    Protected EventType = *event\type
    Protected EventData = *event\data
    Protected EventItem = GetState(EventGadget)
    
    Select EventType
      Case #PB_EventType_ScrollChange : Debug "widget scroll change data "+ EventData
      Case #PB_EventType_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_DragStart : Debug "widget dragStart item = " + EventItem +" data "+ EventData
      Case #PB_EventType_Change    : Debug "widget change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_LeftClick : Debug "widget click item = " + EventItem +" data "+ EventData
    EndSelect
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(100, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-62, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-30, #PB_Ignore, #PB_Ignore)
    ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    CompilerIf #PB_Compiler_Version =< 546
      PostEvent(#PB_Event_Gadget, EventWindow(), g_Canvas, #PB_EventType_Resize)
    CompilerEndIf
  EndProcedure
  
  Procedure SplitterCallBack()
    PostEvent(#PB_Event_Gadget, EventWindow(), g_Canvas, #PB_EventType_Resize)
  EndProcedure
  
  If OpenWindow(0, 0, 0, 222, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ButtonGadget(100, 490-60,490-30,67,25,"~wrap")
    
    Define i,a,g 
    
    EditorGadget(g, 230, 10, 210, 210)                                         
    For i=0 To 10
      If i = 5
        AddGadgetItem(g, -1, "Line_long_long_long_long_long_"+Str(i))
      Else
        AddGadgetItem(g, -1, "Line_"+Str(i))
      EndIf
    Next
       
    Open(0, 270, 10, 250, 150)
    g_Canvas = GetGadget(Root())
    
    *g=Editor(0, 0, 250, 150, #__Flag_autosize)
    For i=0 To 10
      If i = 5
        AddItem(*g, -1, "Line_long_long_long_long_long_"+Str(i))
      Else
        AddItem(*g, -1, "Line_"+Str(i))
      EndIf
    Next
    
    
    SplitterGadget(10,8, 8, 306, 491-16,g_Canvas, 0)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug no linux
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          CloseWindow(EventWindow()) 
          Break
      EndSelect
    ForEver
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = 0----
; EnableXP