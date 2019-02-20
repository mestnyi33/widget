IncludePath "../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  UseModule Widget
  EnableExplicit
  
  Global *w.widget_S, *combo
  Global *window_1.widget_S, *window_2.widget_S, *panel.widget_S, *container.widget_S, *scrollarea.widget_S
  Global *w_0, *d_0, *b_0, *b_1, *p_0, *p_1, *p_2, *c_0, *s_0
    
  
  Procedure Widgets_CallBack(EventWidget.i, EventType.i, EventItem.i, EventData.i)
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
              Case #PB_EventType_Change
                Define ParentID = GetParent( *w )
                
                Select GetState( *combo )
                  Case 1 :Button(30,20,150,30,"Button") 
                  Case 2 :String(30,20,150,30,"String") 
                  Case 3 :Text(30,20,150,30,"Text", #PB_Text_Border) 
                  Case 4 :Option(30,20,150,30,"Option") 
                  Case 5 :CheckBox(30,20,150,30,"CheckBox") 
                  Case 6 :ListView(30,20,150,30) 
                  Case 7 :Frame(30,20,150,30,"Frame") 
                  Case 8 :ComboBox(30,20,150,30) :AddItem(20,-1,"ComboBox") :SetState(20,0)
                  Case 9 :Image(30,20,150,30,0,#PB_Image_Border) 
                  Case 10 :HyperLink(30,20,150,30,"HyperLink",0) 
                  Case 11 :Container(30,20,150,30,#PB_Container_Flat)   :Button(0,0,80,20,"Button") :CloseList() ; Container
                                                                                                                 ;Case 12 :ListIcon(30,20,150,30,"",88) 
                                                                                                                 ;Case 13 :IPAddress(30,20,150,30) 
                  Case 14 :Progress(30,20,150,30,0,5)
                  Case 15 :Scroll(30,20,150,30,5,335,9)
                  Case 16 :ScrollArea(30,20,150,30,305,305,9,#PB_ScrollArea_Flat) :Button(0,0,80,20,"Button") :CloseList()
                  Case 17 :Track(30,20,150,30,0,5)
                    ;Case 18 :Web(30,20,150,30,"") ; bug 531 linux
                    ;                     Case 19 :ButtonImage(30,20,150,30,0)
                    ;Case 20 :Calendar(30,20,150,30) 
                    ;Case 21 :Date(30,20,150,30)
                    ;Case 22 :Editor(30,20,150,30)  : AddItem(20,-1,"Editor")
                    ;                     Case 23 :ExplorerList(30,20,150,30,"")
                    ;                     Case 24 :ExplorerTree(30,20,150,30,"")
                    ;                     Case 25 :ExplorerCombo(30,20,150,30,"")
                    ;                     Case 26 :Spin(30,20,150,30,0,5,#PB_Spin_Numeric)
                  Case 27 :Tree(30,20,150,30) : AddItem(20,-1,"Tree") : AddItem(20,-1,"SubLavel",0,1)
                  Case 28 :Panel(30,20,150,30) :AddItem(20,-1,"Panel") :CloseList()
                  Case 29 
                    Button(0,0,30,30,"1")
                    Button(0,0,30,30,"2")
                    Splitter(30,20,150,30,201,202)
                EndSelect
                
                ;                   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                ;                     Select GetState( *combo )
                ;                       Case 30 :MDI(30,10,150,70,0,0)
                ;                       Case 31 :InitScintilla() :Scintilla(30,10,150,70,0)
                ;                       Case 32 :Shortcut(30,10,150,70,0)
                ;                       Case 33 :Canvas(30,10,150,70) 
                ;                     EndSelect
                ;                   CompilerElse
                ;                     Select GetState( *combo )
                ;                       Case 30 :InitScintilla() :Scintilla(30,10,150,70,0)
                ;                       Case 31 :Shortcut(30,10,150,70,0)
                ;                       Case 32 :Canvas(30,10,150,70) 
                ;                     EndSelect
                ;                   CompilerEndIf
                
                ;Resize(*w,30,10,150,70)
                
                Debug 765555
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
  *d_0 = Button(30,90,150,30,"Button >>(Desktop)") 
  
  *window_1 = Window(202, 0, 630, 319, "demo set  new parent", Flags )
  
  *w_0 = Button(30,90,150,30,"Button >>(Window)")
  *panel=Panel(10,150,200,160) : AddItem(*panel,-1,"Panel") : *p_0=Button(30,90,150,30,"Button >>(Panel (0))") : AddItem(*panel,-1,"Second") : *p_1=Button(35,90,150,30,"Button >>(Panel (1))") : AddItem(*panel,-1,"Third") : *p_2=Button(40,90,150,30,"Button >>(Panel (2))") : CloseList()
  *container = Container(215,150,200,160,#PB_Container_Flat) : *c_0=Button(30,90,150,30,"Button >>(Container)") : CloseList() ; Container
  *scrollarea = ScrollArea(420,150,200,160,200,160,10,#PB_ScrollArea_Flat) : *s_0=Button(30,90,150,30,"Button >>(ScrollArea)") : CloseList()
  
  *b_0 = Button(450,90,150,30,"Button >>(Back)") 
  
  Bind(@Widgets_CallBack(), Root())
  ;ReDraw(Root())
  
  ResizeWindow(10, WindowX( 10 )-100, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  Flags = #PB_Window_Invisible | #PB_Window_TitleBar | #PB_Window_BorderLess
  X = WindowX( 10 )+5+WindowWidth( 10 )
  Y = WindowY( 10 )
  *window_2 = Open(20, X, Y, 200, 346+22, "old parent", Flags, WindowID(GetRootWindow(*window_1)))
  *w = Button(30,10,150,70,"Button") 
  
  
  *combo = ComboBox( 30,90,150,30 ) 
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
  
  HideWindow(GetRootWindow(*window_1),0)
  HideWindow(GetRootWindow(*window_2),0)
  
  Repeat
    Define Event=WaitWindowEvent()
  Until Event=#PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = v-
; EnableXP