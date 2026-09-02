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

Global SH_W_MouseX, 
       SH_W_MouseY
Global SH_W_Object =-1,
       SH_W_Parent =-1


Global SH_W=-1, 
       SH_G_Text_G1=-1, 
       SH_G_Text_G2=-1, 
       SH_G_ComboBox_G1=-1, 
       SH_G_ComboBox_G2=-1, 
       SH_G_ListIcon_Flag=-1, 
       SH_G_Container_Line=-1, 
       SH_G_Button_Cancel=-1, 
       SH_G_Button_Ok=-1

Global *Result, LanguageFile.s

Declare SH_W_Events(Event)

Procedure SH_W_SetLanguage(LanguageFile.s)
  If OpenPreferences(LanguageFile)
    PreferenceGroup("Form")
    SetWindowTitle(SH_W, ReadPreferenceString("HelperSplitterTitle", GetWindowTitle(SH_W)))
    SetGadgetText(SH_G_Button_Ok, ReadPreferenceString("Ok", GetGadgetText(SH_G_Button_Ok)))
    SetGadgetText(SH_G_Button_Cancel, ReadPreferenceString("Cancel", GetGadgetText(SH_G_Button_Cancel)))
    SetGadgetText(SH_G_Text_G1, ReadPreferenceString("FirstGadget", GetGadgetText(SH_G_Text_G1)))
    SetGadgetText(SH_G_Text_G2, ReadPreferenceString("SecondGadget", GetGadgetText(SH_G_Text_G2)))
    SetGadgetItemText(SH_G_ListIcon_Flag, -1, ReadPreferenceString("Flags", GetGadgetItemText(SH_G_ListIcon_Flag, -1, 0)))
    
    ClosePreferences()
  EndIf
EndProcedure

Procedure SH_W_Load(Array GadgetArray.s(1))
  Protected i, b=1, a = ArraySize(GadgetArray())
  
  For i=0 To a
    If GadgetArray(i)
      AddItem(SH_G_ComboBox_G1,-1,GadgetArray(i))
      AddItem(SH_G_ComboBox_G2,-1,GadgetArray(i))
    EndIf
  Next
  
  If ArraySize(GadgetArray())>0
    b=0
  EndIf
  
  For i = a+b To a+33
    AddItem(SH_G_ComboBox_G1,-1,GadgetName(i-a))
    AddItem(SH_G_ComboBox_G2,-1,GadgetName(i-a))
  Next
EndProcedure

Procedure SH_W_Return(*Gadget1.String=0, *Gadget2.String=0, *Flag.String=0 )
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

Procedure SH_W_CallBack()
  SH_W_Events(Event())
EndProcedure

Procedure SH_W_Open(ParentID.i=0, Flag.i=#PB_Window_TitleBar|#PB_Window_SizeGadget|#PB_Window_ScreenCentered)
  If IsWindow(SH_W)
    SetActiveWindow(SH_W)
    ProcedureReturn SH_W
  EndIf
  Protected s = 0;20
  Protected ss = 0;5
  SH_W = GetCanvasWindow(Open(#PB_Any, 570, 320, 286, 206, "SplitterHelper", Flag, ParentID))
  WindowBounds(SH_W, 185,WindowHeight(SH_W),700,WindowHeight(SH_W))
  SH_G_Text_G1 = Text(10, 10+ss, 81-s, 21-ss, "Gadget_1:", #PB_Text_Right)                                                                                                                                                                                                                                                                                   
  SH_G_Text_G2 = Text(10, 35+ss, 81-s, 21-ss, "Gadget_2:", #PB_Text_Right)                                                                                                                                                                                                                                                                                   
  SH_G_ComboBox_G1 = ComboBox(95-s, 10, 261+s, 21)
  SH_G_ComboBox_G2 = ComboBox(95-s, 35, 261+s, 21)
  SH_G_ListIcon_Flag = ListIcon(10, 65, 366, 101, "Flags", 362, #PB_ListIcon_CheckBoxes)               
  AddItem(SH_G_ListIcon_Flag, #PB_Any, "#PB_Splitter_Vertical" )
  AddItem(SH_G_ListIcon_Flag, #PB_Any, "#PB_Splitter_Separator" )
  AddItem(SH_G_ListIcon_Flag, #PB_Any, "#PB_Splitter_FirstFixed" )
  AddItem(SH_G_ListIcon_Flag, #PB_Any, "#PB_Splitter_SecondFixed" )
  SH_G_Container_Line = Container(10, 170, 366, 1, #PB_Container_Flat)  
  CloseList()
  SH_G_Button_Cancel = Button(10, 175, 81, 21, "Cancel")   
  SH_G_Button_Ok = Button(295, 175, 81, 21, "Ok")      
  Disable(SH_G_Button_Ok, #True)
  
  PostEvent(#PB_Event_SizeWindow, SH_W, #PB_Ignore)
  BindEvent(#PB_Event_SizeWindow, @SH_W_CallBack(), SH_W)
  
;   CompilerSelect #PB_Compiler_OS
;     CompilerCase #PB_OS_Windows
;       SendMessage_(GadgetID(SH_G_ComboBox_G1), #CB_SETMINVISIBLE, 10, 0)
;       SendMessage_(GadgetID(SH_G_ComboBox_G2), #CB_SETMINVISIBLE, 8, 0)
;   CompilerEndSelect
  
  SH_W_SetLanguage(LanguageFile)
  ProcedureReturn SH_W
EndProcedure

Procedure SH_W_Events(Event)
  Protected i,Result,Result$
  
  Select Event
    Case #PB_Event_SizeWindow
      Resize(SH_G_Button_Ok, WindowWidth(EventWindow())-Width(SH_G_Button_Ok)-10, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      Resize(SH_G_ComboBox_G1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow())-X(SH_G_ComboBox_G1)-10, #PB_Ignore)
      Resize(SH_G_ComboBox_G2, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow())-X(SH_G_ComboBox_G2)-10, #PB_Ignore)
      Resize(SH_G_ListIcon_Flag, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow())-X(SH_G_ListIcon_Flag)-10, #PB_Ignore)
      Resize(SH_G_Container_Line, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow())-X(SH_G_Container_Line)-10, #PB_Ignore)
      SetItemAttribute(SH_G_ListIcon_Flag, 0, #PB_ListIcon_ColumnWidth, Width(SH_G_ListIcon_Flag)-4)
      
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_Change
          Select EventGadget()
            Case SH_G_ComboBox_G1, SH_G_ComboBox_G2
              
              If GetText(SH_G_ComboBox_G1) And GetText(SH_G_ComboBox_G2)
                Disable(SH_G_Button_Ok, #False)
              Else
                Disable(SH_G_Button_Ok, #True)
              EndIf
              
          EndSelect
          
        Case #PB_EventType_LeftClick
          Select EventGadget()
            Case SH_G_Button_Cancel
              ProcedureReturn #PB_Event_CloseWindow
              ;CloseWindow(EventWindow())
              
            Case SH_G_Button_Ok
              Result$ = GetText(SH_G_ComboBox_G1)+"|"+GetText(SH_G_ComboBox_G2)+"&"
              
              For i=0 To CountItems(SH_G_ListIcon_Flag)-1
                If GetItemState(SH_G_ListIcon_Flag, i) & #PB_ListIcon_Checked  
                  Result$ + GetItemText(SH_G_ListIcon_Flag, i) + "|"
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
  SH_W_Open()
  Dim GadgetList.s(1)
  GadgetList.s(0) = "Window_0_Button_0"
  GadgetList.s(1) = "Window_0_Button_1"
  SH_W_Load(GadgetList()) 
  
  While IsWindow(SH_W)
    Define Event = WaitWindowEvent()
    
    Select EventWindow()
      Case SH_W
        If SH_W_Events( Event ) = #PB_Event_CloseWindow
          Define Gadget1.String, Gadget2.String, Flag.String
          If SH_W_Return(@Gadget1, @Gadget2, @Flag)
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
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 52
; FirstLine = 23
; Folding = +----
; EnableXP