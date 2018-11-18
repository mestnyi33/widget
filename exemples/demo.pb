CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElse
  IncludePath "../"
CompilerEndIf

XIncludeFile "module_draw.pbi"
XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_scroll.pbi"
XIncludeFile "module_text.pbi"
XIncludeFile "module_button.pbi"
XIncludeFile "module_string.pbi"
XIncludeFile "module_editor.pbi"
XIncludeFile "module_listview.pbi"
XIncludeFile "module_widget.pbi"


Procedure CallBack(*This.Widget_S, EventType.i)
  Protected Repaint
  
  With *This
    Select \Type 
      Case #PB_GadgetType_Button : Repaint | Button::CallBack(*This, EventType)
      Case #PB_GadgetType_String : Repaint | String::CallBack(*This, EventType)
      Case #PB_GadgetType_Editor : Repaint | Editor::CallBack(*This, EventType)
      Case #PB_GadgetType_ListView : Repaint | ListView::CallBack(*This, EventType)
    EndSelect
  EndWith
  
  ProcedureReturn Repaint
EndProcedure
  

CompilerIf #PB_Compiler_IsMainFile
  ;-
  Procedure CallBacks()
    Protected Result
    Protected Canvas = EventGadget()
    Protected Window = EventWindow()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Select EventType()
      Case #PB_EventType_Repaint : Result = 1
      Case #PB_EventType_Resize : Result = 1
      Default
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(EventGadget())
        EndIf
        
        ForEach List()
          ; If List()\Widget\Canvas\Gadget = GetActiveGadget()
          If Canvas = List()\Widget\Canvas\Gadget
            Result | CallBack(List()\Widget, EventType()) 
          EndIf
        Next
        
    EndSelect
    
    If Result
      Text::ReDraw(0, Canvas)
    EndIf
  EndProcedure
  
  Procedure Events()
    Debug "window "+EventWindow()+" widget "+EventGadget()+" eventtype "+EventType()+" eventdata "+EventData()
  EndProcedure
  
  Define Flags = #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered 
  OpenWindow(20, 0, 0, 630, 400, "demo set gadget new parent", Flags )
  
  ; Demo draw widgets on the canvas
  CanvasGadget(20,  0, 0, WindowWidth( 20 ), WindowHeight( 20 ), #PB_Canvas_Keyboard)
  SetGadgetAttribute(20, #PB_Canvas_Cursor, #PB_Cursor_Cross)
  SetGadgetData(20,20)
  BindGadgetEvent(20, @CallBacks())
  
    
  
;   SetActiveWindow(20)
;   PostEvent(#PB_Event_ActivateWindow, 20, #PB_Ignore)
;   While WindowEvent() : Wend
;    Debug GetActiveWindow()
  
  ; Button::Create(20,-1,30,10,150,70,"ButtonGadget") 
  ;Widget::Button(20,30,10,150,70,"ButtonGadget") 
  

  Flags = #PB_Window_Invisible | #PB_Window_TitleBar
  OpenWindow(10, WindowX( 20 )+20+WindowWidth( 20 ), WindowY( 20 ), 200, 400, "old parent", Flags, WindowID(20))
  
  ComboBoxGadget( 21,10,10,180,30 ) 
  AddGadgetItem( 21, -1, "Selected gadget to move")
  AddGadgetItem( 21, -1, "ButtonGadget")
  AddGadgetItem( 21, -1, "StringGadget")
  AddGadgetItem( 21, -1, "TextGadget")
  AddGadgetItem( 21, -1, "(No) - "+"CheckBoxGadget")
  AddGadgetItem( 21, -1, "(No) - "+"OptionGadget")
  AddGadgetItem( 21, -1, "ListViewGadget")
  AddGadgetItem( 21, -1, "(No) - "+"FrameGadget")
  AddGadgetItem( 21, -1, "(No) - "+"ComboBoxGadget")
  AddGadgetItem( 21, -1, "(No) - "+"ImageGadget")
  AddGadgetItem( 21, -1, "(No) - "+"HyperLinkGadget")
  AddGadgetItem( 21, -1, "(No) - "+"ContainerGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "ListIconGadget")
  AddGadgetItem( 21, -1, "IPAddressGadget")
  AddGadgetItem( 21, -1, "(No) - "+"ProgressBarGadget")
  AddGadgetItem( 21, -1, "(No) - "+"ScrollBarGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "(No) - "+"ScrollAreaGadget"); Win = Ok
  AddGadgetItem( 21, -1, "(No) - "+"TrackBarGadget")
  AddGadgetItem( 21, -1, "(No) - "+"WebGadget")
  AddGadgetItem( 21, -1, "ButtonImageGadget")
  AddGadgetItem( 21, -1, "(No) - "+"CalendarGadget")
  AddGadgetItem( 21, -1, "(No) - "+"DateGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "EditorGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "(No) - "+"ExplorerListGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "(No) - "+"ExplorerTreeGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "(No) - "+"ExplorerComboGadget"); Win = Ok
  AddGadgetItem( 21, -1, "SpinGadget")         ; Win = Ok
  AddGadgetItem( 21, -1, "TreeGadget")         ; Ok
  AddGadgetItem( 21, -1, "(No) - "+"PanelGadget")        ; Ok
  AddGadgetItem( 21, -1, "(No) - "+"SplitterGadget")     ; Win = Ok
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    AddGadgetItem( 21, -1, "(No) - "+"MDIGadget") ; Ok
  CompilerEndIf
  AddGadgetItem( 21, -1, "(No) - "+"ScintillaGadget") ; Ok
  AddGadgetItem( 21, -1, "(No) - "+"ShortcutGadget")  ; Ok
  AddGadgetItem( 21, -1, "(No) - "+"CanvasGadget")    ;Ok
  
  SetGadgetState( 21, #PB_GadgetType_Button) : PostEvent(#PB_Event_Gadget, 20, 21, #PB_EventType_Change)
  
  HideWindow(10,0)
  HideWindow(20,0)
  
  Repeat
    Define Event=WaitWindowEvent()
    
     If Event=#PB_Event_Gadget 
      Select EventType()
        Case #PB_EventType_LeftClick, #PB_EventType_Change
          Select EventGadget()
            Case 21
              Select EventType()
                Case #PB_EventType_Change
                  ;Define ParentID = Get( GadgetID(20) )
                  w=590
                  h=360
                  
                  Select GetGadgetState( 21 )
                    Case 1 : Button::Create(20,-1,20,20,w,h,"Button") 
                    Case 2 : String::Create(20,-1,20,20,w,h,"String") 
                    Case 3 : Text::Create(20,-1,20,20,w,h,"Text", #PB_Text_Border) 
;                     Case 4 :Option(20,20,20,w,h,"Option") 
;                     Case 5 :CheckBox(20,20,20,w,h,"CheckBox") 
                    Case 6 : *w=ListView::Create(20,-1,20,20,w,h, "") : ListView::AddItem(*w,-1, "ListView")
;                     Case 7 :Frame(20,20,20,w,h,"Frame") 
;                     Case 8 :ComboBox(20,20,20,w,h) :AddItem(20,-1,"ComboBox") :SetState(20,0)
;                     Case 9 :Image(20,20,20,w,h,0,#PB_Image_Border) 
;                     Case 10 :HyperLink(20,20,20,w,h,"HyperLink",0) 
;                     Case 11 :Container(20,20,20,w,h,#PB_Container_Flat)   :Button(-1,0,0,80,20,"Button") :CloseList() ; Container
;                     Case 12 :ListIcon(20,20,20,w,h,"",88) 
;                     Case 13 :IPAddress(20,20,20,w,h) 
;                     Case 14 :ProgressBar(20,20,20,w,h,0,5)
;                     Case 15 :ScrollBar(20,20,20,w,h,5,335,9)
;                     Case 16 :ScrollArea(20,20,20,w,h,205,305,9,#PB_ScrollArea_Flat) :Button(-1,0,0,80,20,"Button") :CloseList()
;                     Case 17 :TrackBar(20,20,20,w,h,0,5)
;                     Case 18 :Web(20,20,20,w,h,"") ; bug 531 linux
;                     Case 19 :ButtonImage(20,20,20,w,h,0)
;                     Case 20 :Calendar(20,20,20,w,h) 
;                     Case  21 :Date(20,20,20,w,h)
                    Case 22 : *w=Editor::Create(20,-1, 20,20,w,h, "") : Editor::AddItem(*w,-1,"Editor")
;                     Case 23 :ExplorerList(20,20,20,w,h,"")
;                     Case 24 :ExplorerTree(20,20,20,w,h,"")
;                     Case 25 :ExplorerCombo(20,20,20,w,h,"")
;                     Case 26 :Spin(20,20,20,w,h,0,5,#PB_Spin_Numeric)
;                     Case 27 :Tree(20,20,20,w,h) : AddItem(20,-1,"Tree") : AddItem(20,-1,"SubLavel",0,1)
;                     Case 28 :Panel(20,20,20,w,h) :AddItem(20,-1,"Panel") :CloseList()
;                     Case 29 
;                       Button(201,0,0,20,h,"1")
;                       Button(202,0,0,20,h,"2")
;                       Splitter(20,20,20,w,h,201,202)
;                       Case 30 :MDI(20,20,10,w,70,0,0)
;                       Case 31 :InitScintilla() :Scintilla(20,20,10,w,70,0)
;                       Case 32 :Shortcut(20,20,10,w,70,0)
;                       Case 33 :Canvas(20,20,10,w,70) 
                    Default
                      Debug " пока еще нет"
                  EndSelect
                  
                  ;Resize(20,30,10,150,70)
                  
;                   Set(20, ParentID) ; GadgetID(3));
                  
              EndSelect
          EndSelect
          
;           If (EventGadget()<>20)
;             Define Parent=Parent(20)
;             If IsGadget(Parent)
;               Debug "get parent "+Parent
;             Else
;               Debug "get parent "+Window(20)
;             EndIf
;             
;             If IsGadget(201)
;               Debug Str(Parent(201))+" "+GadgetX(201)+" "+GadgetY(201)+" "+GadgetWidth(201)+" "+GadgetHeight(201)
;             EndIf
;           EndIf
      EndSelect
    EndIf  
  Until Event=#PB_Event_CloseWindow
  
CompilerEndIf


; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -4-
; EnableXP