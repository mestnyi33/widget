IncludePath "../"
XIncludeFile "widgets().pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  UseModule Widget
  EnableExplicit
  
  Global *w._S_widget, *combo
  Global *window_1._S_widget, *window_2._S_widget, *panel._S_widget, *container._S_widget, *scrollarea._S_widget
  Global *w_0, *d_0, *b_0, *b_1, *p_0, *p_1, *p_2, *c_0, *s_0
    
  
  Procedure Widgets_CallBack()
    Protected EventWidget.i = *event\widget,
              EventType.i = *event\type,
              EventItem.i = *event\item, 
              EventData.i = *event\data
    
    ; Debug ""+EventType() +" "+ WidgetEventType() +" "+ EventWidget() +" "+ EventGadget() +" "+ EventData()
    ; Protected EventWidget = EventWidget()
    
    Select EventType
      Case #PB_EventType_LeftClick, #PB_EventType_Change
        
        Select EventWidget
          Case *d_0 : SetParent(*w, GetRoot(EventWidget))
            
          Case *w_0 : SetParent(*w, *window_1)
          Case *p_0 : SetParent(*w, *panel, 0)
          Case *p_1 : SetParent(*w, *panel, 1)
          Case *p_2 : SetParent(*w, *panel, 2)
          Case *c_0 : SetParent(*w, *container)
          Case *s_0 : SetParent(*w, *scrollarea)
          Case *b_0, *b_1 : SetParent(*w, *window_2)
            
          Case *combo
            Select EventType
              Case #PB_EventType_Change  ; : Debug "Combo change " + GetState( *combo )
                Define i, ParentID = GetParent( *w )
                
                ; If GetState( *combo ) >- 1
                  Free(*w)  
                ; EndIf
                
                Select GetState( *combo )
                  Case 1  : *w = Button(30,20,160,30,"Button") 
                  Case 2  : *w = String(30,20,160,30,"String") 
                  Case 3  : *w = Text(30,20,160,30,"Text", #PB_Text_Border) 
                  Case 4  : *w = Option(30,20,160,30,"Option") 
                  Case 5  : *w = CheckBox(30,20,160,30,"CheckBox") 
                  Case 6  : *w = ListView(30,20,160,30) : For i=0 To 10 : AddItem(*w,-1,"ListView_"+Str(i)) : Next : SetState(*w,5)
                  Case 7  : *w = Frame(30,20,160,30,"Frame") 
                  Case 8  : *w = ComboBox(30,20,160,30) : For i=0 To 10 : AddItem(*w,-1,"ComboBox_"+Str(i)) : Next : SetState(*w,0)
                  Case 9  : *w = Image(30,20,160,30,0,#PB_Image_Border) 
                  Case 10 : *w = HyperLink(30,20,160,30,"HyperLink", $FF00FF, #PB_HyperLink_Underline) 
                  Case 11 : *w = Container(30,20,160,30,#PB_Container_Flat) : Button(0,0,80,20,"Button") : CloseList() ; Container
                  Case 12 : *w = ListIcon(30,20,160,30,"ListIcon",88) 
                  Case 13 : *w = IPAddress(30,20,160,30) 
                  Case 14 : *w = Progress(30,20,160,30,0,5)
                  Case 15 : *w = Scroll(30,20,160,30,5,335,9)
                  Case 16 : *w = ScrollArea(30,20,160,30,305,305,9,#PB_ScrollArea_Flat) : Button(0,0,80,20,"Button") : CloseList()
                  Case 17 : *w = Track(30,20,160,30,0,5)
                    ; Case 18 : *w = Web(30,20,160,30,"") 
                  Case 19 : *w = Button(30,20,160,30, "", 0, 0)
                    ;Case 20 : *w = Calendar(30,20,160,30) 
                    ;Case 21 : *w = Date(30,20,160,30)
                    ;Case 22 : *w = Editor(30,20,160,30) : AddItem(20,-1,"Editor")
                  Case 23 : *w = ExplorerList(30,20,160,30,"")
                    ;                     Case 24 : *w = ExplorerTree(30,20,160,30,"")
                    ;                     Case 25 : *w = ExplorerCombo(30,20,160,30,"")
                  Case 26 : *w = Spin(30,20,160,30,0,5,#PB_Spin_Numeric)
                  Case 27 : *w = Tree(30,20,160,30) : For i=0 To 10 : AddItem(*w,-1,"Tree_"+Str(i), -1, Bool(i=1 Or i=3 Or i=5 Or i=7 Or i=9)) : Next
                  Case 28 : *w = Panel(30,20,160,30) : For i=0 To 10 : AddItem(*w,-1,"Panel_"+Str(i)) : Next : CloseList()
                  Case 29 : *w = Splitter(30,20,160,30, Button(0,0,0,0,"1"), Button(0,0,0,0,"2"))
                EndSelect
                
                ;                   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                ;                     Select GetState( *combo )
                ;                       Case 30 : MDI(30,10,160,70,0,0)
                ;                       Case 31 : InitScintilla() :Scintilla(30,10,160,70,0)
                ;                       Case 32 : Shortcut(30,10,160,70,0)
                ;                       Case 33 : Canvas(30,10,160,70) 
                ;                     EndSelect
                ;                   CompilerElse
                ;                     Select GetState( *combo )
                ;                       Case 30 : InitScintilla() :Scintilla(30,10,160,70,0)
                ;                       Case 31 : Shortcut(30,10,160,70,0)
                ;                       Case 32 : Canvas(30,10,160,70) 
                ;                     EndSelect
                ;                   CompilerEndIf
                
                Resize(*w,30,10,160,70)
                SetParent(*w, ParentID)
                
            EndSelect
        EndSelect
        
        If (EventWidget<>*w)
          SetText(*window_1, Class(GetType(GetParent(*w))) +" - parent class & parent item ("+Str(GetParentItem(*w))+")")
        EndIf
    EndSelect
    
  EndProcedure
  
  
  Define X,Y,Flags = #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered ;| #PB_Window_BorderLess
  OpenWindow(10, 0, 0, 833, 346, "demo set  new parent", Flags )
  
  ; Create desktop for the widgets
  Open(10, 0, 0, 833, 346)
  *d_0 = Button(30,90,160,30,"Button >>(Desktop)") 
  
  *window_1 = Form(202, 0, 630, 319, "demo set  new parent", Flags )
  
  *w_0 = Button(30,90,160,30,"Button >>(Window)")
  *panel=Panel(10,150,200,160) : AddItem(*panel,-1,"Panel") : *p_0=Button(30,90,160,30,"Button >>(Panel (0))") : AddItem(*panel,-1,"Second") : *p_1=Button(35,90,160,30,"Button >>(Panel (1))") : AddItem(*panel,-1,"Third") : *p_2=Button(40,90,160,30,"Button >>(Panel (2))") : CloseList()
  *container = Container(215,150,200,160,#PB_Container_Flat) : *c_0=Button(30,90,160,30,"Button >>(Container)") : CloseList() ; Container
  *scrollarea = ScrollArea(420,150,200,160,200,160,10,#PB_ScrollArea_Flat) : *s_0=Button(30,90,160,30,"Button >>(ScrollArea)") : CloseList()
  
  *b_0 = Button(450,90,160,30,"Button >>(Back)") 
  
  Bind(@Widgets_CallBack(), Root())
  
  ResizeWindow(10, WindowX( 10 )-100, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  Flags = #PB_Window_Invisible | #PB_Window_TitleBar ;| #PB_Window_BorderLess
  X = WindowX( 10 )+5+WindowWidth( 10 )
  Y = WindowY( 10 )
  
  *window_2 = Open(20, X, Y, 200, 346, "", Flags, WindowID(GetWindow(GetRoot(*window_1))))
  SetWindowTitle(GetWindow(Root()), "old parent") 
  *w = Button(30,10,160,70,"Button") 
  
  
  *combo = ComboBox( 30,90,160,30 ) 
  Bind(@Widgets_CallBack(), *combo)
  
  AddItem( *combo, -1, "Selected  to move")
  AddItem( *combo, -1, "Button")
  AddItem( *combo, -1, "String")
  AddItem( *combo, -1, "Text")
  AddItem( *combo, -1, "CheckBox")
  AddItem( *combo, -1, "Option")
  AddItem( *combo, -1, "ListView")
  AddItem( *combo, -1, "Frame")
  AddItem( *combo, -1, "ComboBox")
  AddItem( *combo, -1, "Image")
  AddItem( *combo, -1, "HyperLink")
  AddItem( *combo, -1, "Container") ; Win = Ok
  AddItem( *combo, -1, "ListIcon")
  AddItem( *combo, -1, "IPAddress")
  AddItem( *combo, -1, "ProgressBar")
  AddItem( *combo, -1, "ScrollBar") ; Win = Ok
  AddItem( *combo, -1, "ScrollArea"); Win = Ok
  AddItem( *combo, -1, "TrackBar")
  AddItem( *combo, -1, "Web")
  AddItem( *combo, -1, "ButtonImage")
  AddItem( *combo, -1, "Calendar")
  AddItem( *combo, -1, "Date") ; Win = Ok
  AddItem( *combo, -1, "Editor") ; Win = Ok
  AddItem( *combo, -1, "ExplorerList") ; Win = Ok
  AddItem( *combo, -1, "ExplorerTree") ; Win = Ok
  AddItem( *combo, -1, "ExplorerCombo"); Win = Ok
  AddItem( *combo, -1, "Spin")         ; Win = Ok
  AddItem( *combo, -1, "Tree")         ; Ok
  AddItem( *combo, -1, "Panel")        ; Ok
  AddItem( *combo, -1, "Splitter")     ; Win = Ok
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    AddItem( *combo, -1, "MDI") ; Ok
  CompilerEndIf
  AddItem( *combo, -1, "Scintilla") ; Ok
  AddItem( *combo, -1, "Shortcut")  ; Ok
  AddItem( *combo, -1, "Canvas")    ;Ok
  
  SetState( *combo, #PB_GadgetType_Button) ; : PostEvent(#PB_Event_Widget, 20, *combo, #PB_EventType_Change)
  
  ReDraw(GetRoot(*window_1))
  ReDraw(GetRoot(*window_2))
  
  HideWindow(GetWindow(GetRoot(*window_1)),0)
  HideWindow(GetWindow(GetRoot(*window_2)),0)
  
  Repeat
    Define Event=WaitWindowEvent()
  Until Event=#PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = 8-
; EnableXP