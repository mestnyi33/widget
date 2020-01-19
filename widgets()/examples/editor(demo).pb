IncludePath "../"
XIncludeFile "editor().pbi"
;XIncludeFile "widgets().pbi"

UseModule editor
UseModule constants
UseModule structures

CompilerIf #PB_Compiler_IsMainFile
  
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
    ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-16, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16-25-5-10)
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
           "Otherwise it will not work." ;+ m.s; +
  
  If OpenWindow(0, 0, 0, 422, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ButtonGadget(100, 8,8,67,25,"gettext")
    ButtonGadget(101, 8+70,8,67,25,"~wrap")
    
    g=166
    Editor::Gadget(g, 8+70+70, 5, 422-156, 40, #__flag_GridLines|#__flag_Numeric) 
    *g._s_widget=GetGadgetData(g)
    *g\text\multiLine = 0
    Editor::SetText(*g, Text.s) 
    
    
    EditorGadget(0, 8, 8, 306, 133, #PB_Editor_WordWrap) 
    SetGadgetText(0, Text.s) 
    For a = 0 To 2
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    AddGadgetItem(0, 7+a, "_")
    For a = 4 To 6
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    
    
    g=16
    Editor::Gadget(g, 8, 133+5+8, 306, 133, #__flag_GridLines|#__flag_Numeric|#__text_WordWrap) 
    *g._s_widget=GetGadgetData(g)
    Editor::SetText(*g, Text.s) 
    
    For a = 0 To 2
      Editor::AddItem(*g, a, "Line "+Str(a))
    Next
    Editor::AddItem(*g, 7+a, "_")
    For a = 4 To 6
      Editor::AddItem(*g, a, "Line "+Str(a))
    Next
    
    ;SetGadgetFont(0, FontID(0))
    ;Editor::SetFont(*g, FontID(0))
    
    SplitterGadget(10,8, 8+25+5+10, 306, 491-16-10 , 0,g)
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
          Select EventType()
            Case #PB_EventType_LeftClick
              Define *E._s_widget = GetGadgetData(g)
              
              If EventGadget() = 100
                ClearDebugOutput()
                If *E\text\edit[1]\string
                  Debug "1) -----left------"
                  Debug *E\text\edit[1]\string 
                EndIf
                If *E\text\edit[2]\string
                  Debug "2) -----selected-----"
                  Debug *E\text\edit[2]\string
                EndIf
                If *E\text\edit[3]\string
                  Debug "3) -----right------"
                  Debug *E\text\edit[3]\string
                EndIf
                Debug "------end------"
                
                Debug ""
                Debug "-----lines-----"
                ; Выделение конца строки
                PushListPosition(*E\items()) 
                ForEach *E\items()
                  If *E\items()\text\edit[2]\width
                    Debug ""+*E\items()\index +" - "+ *E\items()\text\edit[2]\string
                  EndIf
                Next
                PopListPosition(*E\items()) 
                Debug "-----endlines-----"
                
              ElseIf EventGadget() = 101
                *E\text\multiLine ! 1
                
                If  *E\text\multiLine <> 0
                  SetGadgetText(100,"~wrap")
                Else
                  SetGadgetText(100,"wrap")
                EndIf
                
                CompilerSelect #PB_Compiler_OS
                  CompilerCase #PB_OS_Linux
                    If  *E\text\multiLine = 1
                      gtk_text_view_set_wrap_mode_(GadgetID(0), #GTK_WRAP_WORD)
                    Else
                      gtk_text_view_set_wrap_mode_(GadgetID(0), #GTK_WRAP_NONE)
                    EndIf
                    
                  CompilerCase #PB_OS_MacOS
                    
                    If  *E\text\multiLine <> 0
                      EditorGadget(0, 8, 8, 306, 133)
                    Else
                      EditorGadget(0, 8, 8, 306, 133, #PB_Editor_WordWrap) 
                    EndIf
                    
                    SetGadgetText(0, Text.s) 
                    For a = 0 To 5
                      AddGadgetItem(0, a, "Line "+Str(a))
                    Next
                    ;SetGadgetFont(0, FontID(0))
                    
                    SplitterGadget(10,8, 8+25+5+10, 306, 491-16-10 , 0,g)
                    
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
                    ; SendMessage_ (GadgetID (0), #EM_SETTARGETDEVICE, #NULL, $FFFFFF); чтобы снова отключить перенос слов (используйте просто огромное значение, 
                CompilerEndSelect
                
              EndIf
              
          EndSelect
          
        Case #PB_Event_LeftClick  
          SetActiveGadget(0)
        Case #PB_Event_RightClick 
          SetActiveGadget(10)
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ----
; EnableXP