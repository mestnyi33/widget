
 IncludePath "../../../" : XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  UseWidgets( )
  EnableExplicit
  
  Define a,i, *g._s_widget
  Define g, Text.s
  ; Define m.s=#CRLF$
  Define m.s=#LF$
  
  Text.s = "This is a long line" + m.s +
           "Who should show," + m.s +
           "I have to write the text in the box or not." + m.s +
           "The string must be very long" + m.s +
           "Otherwise it will not work."
  
  Procedure ResizeCallBack()
    ResizeGadget(100, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-62, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-30, #PB_Ignore, #PB_Ignore)
    ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    CompilerIf #PB_Compiler_Version =< 546
      PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
    CompilerEndIf
  EndProcedure
  
  Procedure SplitterCallBack()
    PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 16)
  CompilerElse
    LoadFont(0, "Arial", 11)
  CompilerEndIf 
  
  
  Text.s = "This is a long line." + m.s +
           "Who should show." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "I have to write the text in the box or not." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work." ;+ m.s +
  
  If OpenWindow(0, 0, 0, 422, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ButtonGadget(100, 490-60,490-30,67,25,"~wrap")
    
    EditorGadget(0, 8, 8, 306, 133, #PB_Editor_WordWrap) 
    SetGadgetTextWidget(0, Text.s) 
    For a = 0 To 2
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    AddGadgetItem(0, 7+a, "_")
    For a = 4 To 6
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    ;SetGadgetFont(0, FontID(0))
    
    
    OpenRootWidget(0, 270, 10, 250, 680)
    ;Define *w = EditorWidget(0, 0, 0, 0, #__flag_autosize) 
    *g = EditorWidget(0, 0, 250, 680, #__flag_autosize) 
    g=GetCanvasGadget(root())
    
    ;     Gadget(g, 8, 133+5+8, 306, 133, #PB_Flag_GridLines|#PB_Flag_Numeric);#PB_Text_WordWrap|#PB_Flag_GridLines) 
    ;     *g._s_widget=GetGadgetData(g)
    
    SetTextWidget(*g, Text.s) 
    For a = 0 To 2
      AddItem(*g, a, "Line "+Str(a))
    Next
    AddItem(*g, 7+a, "_")
    For a = 4 To 6
      AddItem(*g, a, "Line "+Str(a))
    Next
    ;SetFont(*g, FontID(0))
    ;\\Close( )
    
    SplitterGadget(10,8, 8, 306, 491-16, 0,g)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    Debug ""+GadgetHeight(0) +" "+ GadgetHeight(g)
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_Gadget
          If EventGadget() = 100
            Select EventType()
              Case #PB_EventType_LeftClick
                Define *E._s_widget = GetGadgetData(g)
                
                *E\Text\MultiLine !- 1
                If  *E\Text\MultiLine = 1
                  SetGadgetTextWidget(100,"~wrap")
                Else
                  SetGadgetTextWidget(100,"wrap")
                EndIf
                
                CompilerSelect #PB_Compiler_OS
                  CompilerCase #PB_OS_Linux
                    If  *E\Text\MultiLine = 1
                      gtk_text_view_set_wrap_mode_(GadgetID(0), #GTK_WRAP_WORD)
                    Else
                      gtk_text_view_set_wrap_mode_(GadgetID(0), #GTK_WRAP_NONE)
                    EndIf
                    
                  CompilerCase #PB_OS_MacOS
                    
                    If  *E\Text\MultiLine = 1
                      EditorGadget(0, 8, 8, 306, 133, #PB_Editor_WordWrap)
                    Else
                      EditorGadget(0, 8, 8, 306, 133) 
                    EndIf
                    
                    SetGadgetTextWidget(0, Text.s) 
                    For a = 0 To 5
                      AddGadgetItem(0, a, "Line "+Str(a))
                    Next
                    SetGadgetFont(0, FontID(0))
                    
                    SplitterGadget(10,8, 8, 306, 276, 0,g)
                    
                    CompilerIf #PB_Compiler_Version =< 546
                      BindGadgetEvent(10, @SplitterCallBack())
                    CompilerEndIf
                    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
                    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
                    
                    ; ;                     ImportC ""
                    ; ;                       GetControlProperty(Control, PropertyCreator, PropertyTag, BufferSize, *ActualSize, *PropertyBuffer)
                    ; ;                       TXNSetTXNObjectControls(TXNObject, ClearAll, ControlCount, ControlTags, ControlData)
                    ; ;                     EndImport
                    ; ;                     
                    ; ;                     Define TXNObject.i
                    ; ;                     Dim ControlTag.i(0)
                    ; ;                     Dim ControlData.i(0)
                    ; ;                     
                    ; ;                     ControlTag(0) = 'wwrs' ; kTXNWordWrapStateTag
                    ; ;                     ControlData(0) = 0     ; kTXNAutoWrap
                    ; ;                     
                    ; ;                     If GetControlProperty(GadgetID(0), 'PURE', 'TXOB', 4, 0, @TXNObject) = 0
                    ; ;                       TXNSetTXNObjectControls(TXNObject, #False, 1, @ControlTag(0), @ControlData(0))
                    ; ;                     EndIf
                  CompilerCase #PB_OS_Windows
                    SendMessage_(GadgetID(0), #EM_SETTARGETDEVICE, 0, 0)
                CompilerEndSelect
                
                
            EndSelect
          EndIf
          
        Case #PB_Event_LeftClick  
          SetActiveGadget(0)
        Case #PB_Event_RightClick 
          SetActiveGadget(10)
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -------------------0f-f----------------------------
; EnableXP
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 76
; FirstLine = 73
; Folding = ---
; EnableXP