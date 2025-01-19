XIncludeFile "../../widgets.pbi" 

EnableExplicit
UseWidgets( )
 
Procedure$ GadgetName( Type )
  Protected Result$
  
  Select Type
    Case #PB_GadgetType_Unknown        : ProcedureReturn ">>> - Create new gadget"
    Case #PB_GadgetType_Button         : Result$ = "Button"
    Case #PB_GadgetType_String         : Result$ = "String"
    Case #PB_GadgetType_Text           : Result$ = "Text"
    Case #PB_GadgetType_CheckBox       : Result$ = "CheckBox"
    Case #PB_GadgetType_Option         : Result$ = "Option"
    Case #PB_GadgetType_ListView       : Result$ = "ListView"
    Case #PB_GadgetType_Frame          : Result$ = "Frame"
    Case #PB_GadgetType_ComboBox       : Result$ = "ComboBox"
    Case #PB_GadgetType_Image          : Result$ = "Image"
    Case #PB_GadgetType_HyperLink      : Result$ = "HyperLink"
    Case #PB_GadgetType_Container      : Result$ = "Container"
    Case #PB_GadgetType_ListIcon       : Result$ = "ListIcon"
    Case #PB_GadgetType_IPAddress      : Result$ = "IPAddress"
    Case #PB_GadgetType_ProgressBar    : Result$ = "ProgressBar"
    Case #PB_GadgetType_ScrollBar      : Result$ = "ScrollBar"
    Case #PB_GadgetType_ScrollArea     : Result$ = "ScrollArea"
    Case #PB_GadgetType_TrackBar       : Result$ = "TrackBar"
    Case #PB_GadgetType_Web            : Result$ = "Web"
    Case #PB_GadgetType_ButtonImage    : Result$ = "ButtonImage"
    Case #PB_GadgetType_Calendar       : Result$ = "Calendar"
    Case #PB_GadgetType_Date           : Result$ = "Date"
    Case #PB_GadgetType_Editor         : Result$ = "Editor"
    Case #PB_GadgetType_ExplorerList   : Result$ = "ExplorerList"
    Case #PB_GadgetType_ExplorerTree   : Result$ = "ExplorerTree"
    Case #PB_GadgetType_ExplorerCombo  : Result$ = "ExplorerCombo"
    Case #PB_GadgetType_Spin           : Result$ = "Spin"
    Case #PB_GadgetType_Tree           : Result$ = "Tree"
    Case #PB_GadgetType_Panel          : Result$ = "Panel"
    Case #PB_GadgetType_Splitter       : Result$ = "Splitter"
    Case #PB_GadgetType_MDI           
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        Result$ = "MDI"
      CompilerEndIf
    Case #PB_GadgetType_Scintilla      : Result$ = "Scintilla"
    Case #PB_GadgetType_Shortcut       : Result$ = "Shortcut"
    Case #PB_GadgetType_Canvas         : Result$ = "Canvas"
  EndSelect
  
  ProcedureReturn Result$
EndProcedure

Global W_SH_MouseX, W_SH_MouseY
Global W_SH_Object =-1,
       W_SH_Parent =-1


Global W_SH=-1, 
       G_SH_Text_G1=-1, 
       G_SH_Text_G2=-1, 
       G_SH_ComboBox_G1=-1, 
       G_SH_ComboBox_G2=-1, 
       G_SH_ListIcon_Flag=-1, 
       G_SH_Container_Line=-1, 
       G_SH_Button_Cancel=-1, 
       G_SH_Button_Ok=-1

Global *Result, LanguageFile.s

Declare W_SH_Events(Event)

Procedure W_SH_SetLanguage(LanguageFile.s)
  If OpenPreferences(LanguageFile)
    PreferenceGroup("Form")
    SetWindowTitle(W_SH, ReadPreferenceString("HelperSplitterTitle", GetWindowTitle(W_SH)))
    SetGadgetText(G_SH_Button_Ok, ReadPreferenceString("Ok", GetGadgetText(G_SH_Button_Ok)))
    SetGadgetText(G_SH_Button_Cancel, ReadPreferenceString("Cancel", GetGadgetText(G_SH_Button_Cancel)))
    SetGadgetText(G_SH_Text_G1, ReadPreferenceString("FirstGadget", GetGadgetText(G_SH_Text_G1)))
    SetGadgetText(G_SH_Text_G2, ReadPreferenceString("SecondGadget", GetGadgetText(G_SH_Text_G2)))
    SetGadgetItemText(G_SH_ListIcon_Flag, -1, ReadPreferenceString("Flags", GetGadgetItemText(G_SH_ListIcon_Flag, -1, 0)))
    
    ClosePreferences()
  EndIf
EndProcedure

Procedure W_SH_Load(Array GadgetArray.s(1))
  Protected i, b=1, a = ArraySize(GadgetArray())
  
  For i=0 To a
    If GadgetArray(i)
      AddItem(G_SH_ComboBox_G1,-1,GadgetArray(i))
      AddItem(G_SH_ComboBox_G2,-1,GadgetArray(i))
    EndIf
  Next
  
  If ArraySize(GadgetArray())>0
    b=0
  EndIf
  
  For i = a+b To a+33
    AddItem(G_SH_ComboBox_G1,-1,GadgetName(i-a))
    AddItem(G_SH_ComboBox_G2,-1,GadgetName(i-a))
  Next
EndProcedure

Procedure W_SH_Return(*Gadget1.String=0, *Gadget2.String=0, *Flag.String=0 )
  Protected Result$, Gadget1$, Gadget2$, Flag$
  
  If *Result
    Result$ = StringField(PeekS(*Result, #PB_All, #PB_UTF8),1, "&")
    Flag$ = StringField(PeekS(*Result, #PB_All, #PB_UTF8),2, "&")
    Gadget1$ = ReplaceString((StringField(Result$,1, "|")), "_Create", "")
    Gadget2$ = ReplaceString((StringField(Result$,2, "|")), "_Create", "")
    
    If *Gadget1 : *Gadget1\s = Gadget1$ : EndIf
    If *Gadget2 : *Gadget2\s = Gadget2$ : EndIf
    If *Flag : *Flag\s = Flag$ : EndIf
    
    If Bool(Gadget1$ And Gadget2$)
      ProcedureReturn #True
    EndIf
  EndIf
  
EndProcedure

Procedure W_SH_CallBack()
  W_SH_Events(Event())
EndProcedure

Procedure W_SH_Open(ParentID.i=0, Flag.i=#PB_Window_TitleBar|#PB_Window_SizeGadget|#PB_Window_ScreenCentered)
  If IsWindow(W_SH)
    SetActiveWindow(W_SH)
    ProcedureReturn W_SH
  EndIf
  
  W_SH = GetCanvasWindow(Open(#PB_Any, 570, 320, 286, 206, "SplitterHelper", Flag, ParentID))
  WindowBounds(W_SH, 185,WindowHeight(W_SH),700,WindowHeight(W_SH))
  G_SH_Text_G1 = Text(10, 15, 61, 16, "Gadget_1:", #PB_Text_Right)                                                                                                                                                                                                                                                                                   
  G_SH_Text_G2 = Text(10, 40, 61, 16, "Gadget_2:", #PB_Text_Right)                                                                                                                                                                                                                                                                                   
  G_SH_ComboBox_G1 = ComboBox(75, 10, 281, 21)
  G_SH_ComboBox_G2 = ComboBox(75, 35, 281, 21)
  G_SH_ListIcon_Flag = ListIcon(10, 65, 366, 101, "Flags", 362, #PB_ListIcon_CheckBoxes)               
  AddItem(G_SH_ListIcon_Flag, #PB_Any, "#PB_Splitter_Vertical" )
  AddItem(G_SH_ListIcon_Flag, #PB_Any, "#PB_Splitter_Separator" )
  AddItem(G_SH_ListIcon_Flag, #PB_Any, "#PB_Splitter_FirstFixed" )
  AddItem(G_SH_ListIcon_Flag, #PB_Any, "#PB_Splitter_SecondFixed" )
  G_SH_Container_Line = Container(10, 170, 366, 1, #PB_Container_Flat)  
  CloseList()
  G_SH_Button_Cancel = Button(10, 175, 81, 21, "Cancel")   
  G_SH_Button_Ok = Button(295, 175, 81, 21, "Ok")      
  Disable(G_SH_Button_Ok, #True)
  
  PostEvent(#PB_Event_SizeWindow, W_SH, #PB_Ignore)
  BindEvent(#PB_Event_SizeWindow, @W_SH_CallBack(), W_SH)
  
;   CompilerSelect #PB_Compiler_OS
;     CompilerCase #PB_OS_Windows
;       SendMessage_(GadgetID(G_SH_ComboBox_G1), #CB_SETMINVISIBLE, 10, 0)
;       SendMessage_(GadgetID(G_SH_ComboBox_G2), #CB_SETMINVISIBLE, 8, 0)
;   CompilerEndSelect
  
  W_SH_SetLanguage(LanguageFile)
  ProcedureReturn W_SH
EndProcedure

Procedure W_SH_Events(Event)
  Protected i,Result,Result$
  
  Select Event
    Case #PB_Event_SizeWindow
      Resize(G_SH_Button_Ok, WindowWidth(EventWindow())-Width(G_SH_Button_Ok)-10, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      Resize(G_SH_ComboBox_G1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow())-X(G_SH_ComboBox_G1)-10, #PB_Ignore)
      Resize(G_SH_ComboBox_G2, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow())-X(G_SH_ComboBox_G2)-10, #PB_Ignore)
      Resize(G_SH_ListIcon_Flag, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow())-X(G_SH_ListIcon_Flag)-10, #PB_Ignore)
      Resize(G_SH_Container_Line, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow())-X(G_SH_Container_Line)-10, #PB_Ignore)
      SetItemAttribute(G_SH_ListIcon_Flag, 0, #PB_ListIcon_ColumnWidth, Width(G_SH_ListIcon_Flag)-4)
      
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_Change
          Select EventGadget()
            Case G_SH_ComboBox_G1, G_SH_ComboBox_G2
              
              If GetText(G_SH_ComboBox_G1) And GetText(G_SH_ComboBox_G2)
                Disable(G_SH_Button_Ok, #False)
              Else
                Disable(G_SH_Button_Ok, #True)
              EndIf
              
          EndSelect
          
        Case #PB_EventType_LeftClick
          Select EventGadget()
            Case G_SH_Button_Cancel
              ProcedureReturn #PB_Event_CloseWindow
              ;CloseWindow(EventWindow())
              
            Case G_SH_Button_Ok
              Result$ = GetText(G_SH_ComboBox_G1)+"|"+GetText(G_SH_ComboBox_G2)+"&"
              
              For i=0 To CountItems(G_SH_ListIcon_Flag)-1
                If GetItemState(G_SH_ListIcon_Flag, i) & #PB_ListIcon_Checked  
                  Result$ + GetItemText(G_SH_ListIcon_Flag, i) + "|"
                EndIf
              Next
              
              Result$ = Trim(Result$, "|")
              
              *Result = AllocateMemory(StringByteLength(Result$)) 
              PokeS(*Result, Result$, #PB_All, #PB_UTF8) 
              ProcedureReturn #PB_Event_CloseWindow
              
          EndSelect
      EndSelect
  EndSelect
  
  ProcedureReturn Event
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  LanguageFile = "../../Catalogs/Russian/Editor.catalog"
  W_SH_Open()
  Dim GadgetList.s(1)
  GadgetList.s(0) = "Window_0_Button_0"
  GadgetList.s(1) = "Window_0_Button_1"
  W_SH_Load(GadgetList()) 
  
  While IsWindow(W_SH)
    Define Event = WaitWindowEvent()
    
    Select EventWindow()
      Case W_SH
        If W_SH_Events( Event ) = #PB_Event_CloseWindow
          Define Gadget1.String, Gadget2.String, Flag.String
          If W_SH_Return(@Gadget1, @Gadget2, @Flag)
            Debug "Gadget1 "+Gadget1\s
            Debug "Gadget2 "+Gadget2\s
            ;           Debug PeekS(Result, #PB_All, #PB_UTF8)
            ;           Debug StringField(PeekS(Result, #PB_All, #PB_UTF8),2, "&")
          EndIf
          CloseWindow(EventWindow())
        EndIf
        
    EndSelect
  Wend
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 158
; FirstLine = 138
; Folding = -----
; EnableXP