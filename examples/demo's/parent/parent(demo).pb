﻿IncludePath "../../../"
XIncludeFile "-widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  EnableExplicit
  UseLib(widget)
  
  Global  pos_x = 10
  Global *w._S_widget, *combo
  Global *window_1._S_widget, *window_2._S_widget, *panel._S_widget, *container._S_widget, *scrollarea._S_widget
  Global *w_0, *d_0, *b_0, *b_1, *p_0, *p_1, *p_2, *c_0, *s_0
  Global *pb_0, *pb_1, *pb_2, *pb_3
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  
  Procedure Widgets_CallBack()
    Protected EventWidget.i = EventWidget(),
              EventType.i = WidgetEventType(),
              EventItem.i = WidgetEventItem(), 
              EventData.i = WidgetEventData()
    
    Select EventType
      Case #PB_EventType_MouseEnter
        ; bug in mac os
        If GetActiveGadget() <> EventGadget()
          SetActiveGadget(EventGadget())
          Debug 555
        EndIf
        
      Case #PB_EventType_LeftClick, #PB_EventType_Change
        
        Select EventWidget
          Case *d_0, *pb_3 : SetParent(*w, GetRoot(EventWidget))
            
          Case *w_0        : SetParent(*w, *window_1)
          Case *p_0, *pb_0 : SetParent(*w, *panel, 0)
          Case *p_1, *pb_1 : SetParent(*w, *panel, 1)
          Case *p_2, *pb_2 : SetParent(*w, *panel, 2)
          Case *c_0        : SetParent(*w, *container)
          Case *s_0        : SetParent(*w, *scrollarea)
          Case *b_0, *b_1  : SetParent(*w, *window_2)
            
          Case *combo
            Select EventType
              Case #PB_EventType_Change   : Debug "Combo change " + GetState( *combo )
                Define i, ParentID = GetParent( *w )
                
                ; If GetState( *combo ) >- 1
                Free(*w)  
                ; EndIf
                
                Select GetState( *combo )
                  Case 1  : *w = Button(0,0,0,0, "Button") 
                  Case 2  : *w = String(0,0,0,0, "String") 
                  Case 3  : *w = Text(0,0,0,0, "Text", #__Text_Border) 
                  Case 4  : *w = Option(0,0,0,0, "Option") 
                  Case 5  : *w = CheckBox(0,0,0,0, "CheckBox") 
                  Case 6  
                    *w = ListView(0,0,0,0) 
                    For i = 0 To 10 
                      AddItem(*w, -1,"ListView_"+Str(i)) 
                    Next 
                    SetState(*w,5)
                    
                  Case 7  : *w = Frame(0,0,0,0, "Frame") 
                    ;                   Case 8  : *w = ComboBox(0,0,0,0) : For i = 0 To 10 : AddItem(*w,-1,"ComboBox_"+Str(i)) : Next : SetState(*w,0)
                  Case 9  : *w = Image(0,0,0,0, 0,#PB_Image_Border) 
                  Case 10 : *w = HyperLink(0,0,0,0, "HyperLink", $FF00FF, #PB_HyperLink_Underline) 
                  Case 11 
                    *w = Container(0,0,0,0,  #PB_Container_Flat) 
                    Button(0,0,80,20,"Button") 
                    CloseList() ; Container
                                                                                                                          ;                   Case 13 : *w = IPAddress(0,0,0,0) 
                  Case 14 : *w = Progress(0,0,0,0, 0,5)
                  Case 15 : *w = Scroll(0,0,0,0, 5,335,9)
                  Case 16 
                    *w = ScrollArea(0,0,0,0, 305,305,9,#PB_ScrollArea_Flat) 
                    Button(0,0,80,20,"Button") 
                    CloseList()
                    
                  Case 17 : *w = Track(0,0,0,0, 0,5)
                    ;                     ; Case 18 : *w = Web(0,0,0,0, "") 
                  Case 19 : *w = Button(0,0,0,0,  "", 0, 0)
                    ;                     ;Case 20 : *w = Calendar(0,0,0,0) 
                    ;                     ;Case 21 : *w = Date(0,0,0,0)
                  Case 22 : *w = Editor(0,0,0,0) : AddItem(20,-1,"Editor")
                    ;                   Case 23 : *w = ExplorerList(0,0,0,0, "")
                    ;                     ;                     Case 24 : *w = ExplorerTree(0,0,0,0, "")
                    ;                     ;                     Case 25 : *w = ExplorerCombo(0,0,0,0, "")
                  Case 26 : *w = Spin(0,0,0,0, 0,5,#PB_Spin_Numeric)
                  Case 27 
                    *w = Tree(0,0,0,0) 
                    For i = 0 To 10 
                      AddItem(*w,-1,"Tree_"+Str(i), -1, Bool(i = 1 Or i = 3 Or i = 5 Or i = 7 Or i = 9)) 
                    Next
                    
                  Case 28 
                    *w = Panel(0,0,0,0) 
                    For i = 0 To 10 
                      AddItem(*w,-1,"Panel_"+Str(i)) 
                    Next 
                    CloseList()
                    
                  Case 29 : *w = Splitter(0,0,0,0,  Button(0,0,0,0, "1"), Button(0,0,0,0, "2"))
                EndSelect
                
                ;                   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                ;                     Select GetState( *combo )
                ;                       Case 30 : MDI(pos_x,10,160,70,0,0)
                ;                       Case 31 : InitScintilla() :Scintilla(pos_x,10,160,70,0)
                ;                       Case 32 : Shortcut(pos_x,10,160,70,0)
                ;                       Case 33 : Canvas(pos_x,10,160,70) 
                ;                     EndSelect
                ;                   CompilerElse
                ;                     Select GetState( *combo )
                ;                       Case 30 : InitScintilla() :Scintilla(pos_x,10,160,70,0)
                ;                       Case 31 : Shortcut(pos_x,10,160,70,0)
                ;                       Case 32 : Canvas(pos_x,10,160,70) 
                ;                     EndSelect
                ;                   CompilerEndIf
                
                
                Resize(*w,pos_x,10,160,70)
                SetParent(*w, ParentID)
                
            EndSelect
            
        EndSelect
        
        Debug " add - "
        ForEach widget( ) 
          If widget( )\before\widget And widget( )\after\widget
            Debug " add - "+ widget( )\before\widget\class +" "+ widget( )\class +" "+ widget( )\after\widget\class
          ElseIf widget( )\after\widget
            Debug " add - none "+ widget( )\class +" "+ widget( )\after\widget\class
          ElseIf widget( )\before\widget
            Debug " add - "+ widget( )\before\widget\class +" "+ widget( )\class +" none"
          Else
            Debug " add - none "+ widget( )\class  +" none"
          EndIf
        Next
        Debug ""
        
        If GetParent(*w) = GetParent(*b_0)
          Disable(*b_0, 1)
        Else
          Disable(*b_0, 0)
        EndIf
        
        If GetParent(*w) = GetParent(*pb_0) 
          Disable(*pb_0, 0)
        Else
          Disable(*pb_0, 1)
        EndIf
        ;         If (EventWidget<>*w)
        ;           SetText(*window_1, Class(GetType(GetParent(*w))) +" - parent class & parent item ("+Str(GetParentItem(*w))+")")
        ;         EndIf
    EndSelect
    
  EndProcedure
  
  Define X,Y,Flags = #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered ;| #PB_Window_BorderLess
  OpenWindow(10, 0, 0, 633, 342, "demo set  new parent", Flags )
  
  ; Create desktop for the widgets
  If Open(10): bind(-1,-1)
    Root()\class = "root_0"
    *d_0 = Button(pos_x,90,160,30,">>(Desktop)") : SetClass(widget(), GetText(widget())) 
    *pb_0 = Button(10,90+40,180,20,">>(Panel to hide item (0))") : SetClass(widget(), GetText(widget())) : Disable(*pb_0, 1)
    *pb_1 = Button(10,90+65,180,20,">>(Panel to hide item (1))") : SetClass(widget(), GetText(widget())) 
    *pb_2 = Button(10,90+90,180,20,">>(Panel to hide item (2))") : SetClass(widget(), GetText(widget())) 
    
    
    *window_1 = Window(202, 0, 430, 314, "demo set  new parent", Flags )          ;   +(#__border_size + #__caption_height)
    *w_0 = Button(pos_x,90,160,30,">>(Window)") : SetClass(widget(), GetText(widget()))
    
    *container = Container(215,10,200,130,#PB_Container_Flat) 
    *c_0 = Button(pos_x,90,160,30,">>(Container)") : SetClass(widget(), GetText(widget()))
    CloseList()
    
    *panel = Panel(10,145,200,160) 
    AddItem(*panel, -1, "item (0)") : *p_0 = Button(pos_x,90,160,30,">>(Panel (0))") : SetClass(widget(), GetText(widget()))
    AddItem(*panel, -1, "item (1)") : *p_1 = Button(pos_x+5,90,160,30,">>(Panel (1))") : SetClass(widget(), GetText(widget())) 
    AddItem(*panel, -1, "item (2)") : *p_2 = Button(pos_x+10,90,160,30,">>(Panel (2))") : SetClass(widget(), GetText(widget())) 
    CloseList()
    
    *scrollarea = ScrollArea(215,145,200,160,200,160,10,#PB_ScrollArea_Flat) 
    ;Debug ""+widget()\x[#__c_draw]+" "+widget()\x[#__c_container]+" "+widget()\x[#__c_required]
    *s_0 = Button(pos_x,90,160,30,">>(ScrollArea)") : SetClass(widget(), GetText(widget())) 
    CloseList()
    
    Bind(Root(), @Widgets_CallBack())
  EndIf

  ResizeWindow(10, WindowX( 10 )-100, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  Flags = #PB_Window_Invisible | #PB_Window_TitleBar | #PB_Window_BorderLess
  X = WindowX( 10 )+5+WindowWidth( 10 )
  Y = WindowY( 10 )
  
  OpenWindow(20, X, Y, 185, 346, "old parent", Flags, WindowID(GetWindow(GetRoot(*window_1))))   ;     +(#__caption_height)
  *window_2 = Open(20): bind(-1,-1)
  Root()\class = "root_1"
  
  *window_2 = Window(0,0,0,0,  "", #__flag_autosize|Flags)
  
  
;   *w = ScrollArea(pos_x,10,160,70, 305,305,9,#PB_ScrollArea_Flat) 
;   SetClass(widget(), "scrollarea_0")
;   Button(0,0,80,20,"disable")
;   Disable(widget(), 1) 
;   SetClass(widget(), "scrollarea_0_butt_"+GetText(widget()))
;   
;   SetClass(Button(30,30,80,20,"Button2"), "scrollarea_0_butt_2") 
;   
;   ScrollArea(50,5,160,70, 305,305,9,#PB_ScrollArea_Flat) 
;   SetClass(widget(), "scrollarea_1")
;   Button(0,0,80,20,"hide")
;   Hide(widget(), 1) 
;   SetClass(widget(), "scrollarea_1_butt_"+GetText(widget()))
;   
;   SetClass(Button(30,30,80,20,"Button4"), "scrollarea_1_butt_4") 
;   CloseList()
;   CloseList()
;   
  
;   *w = MDI(pos_x,10,160,70);, #__flag_autosize)
;   
;   Define *g0 = AddItem(*w, -1, "form_0")
;   Button(10,10,80,80,"button_0")
;   
;   Define *g1 = AddItem(*w, -1, "form_1")
;   Button(10,10,80,80,"button_1")
;   
;   Define *g2 = AddItem(*w, -1, "form_2")
;   Button(10,10,80,80,"button_2")
;   
;   ; use window list
;   OpenList(*window_2)
;   ;CloseList()
  
  *w = Button(pos_x,10,160,70,"current") : SetClass(widget(), GetText(widget())) 
  *b_0 = Button(10,90,160,30,">>(Back)") : SetClass(widget(), GetText(widget())) : Disable(*b_0, 1)
  Bind(*b_0, @Widgets_CallBack())
  
  ;
  *combo = ListView( 10,90+40,160,230 - 30 ) 
  If *combo
    AddItem( *combo, -1, "Selected  to move")
    AddItem( *combo, -1, "Button")
    AddItem( *combo, -1, "String")
    AddItem( *combo, -1, "Text")
    AddItem( *combo, -1, "Option")
    AddItem( *combo, -1, "CheckBox")
    AddItem( *combo, -1, "ListView")
    AddItem( *combo, -1, "Frame")
    AddItem( *combo, -1, "ComboBox")
    AddItem( *combo, -1, "Image")
    AddItem( *combo, -1, "HyperLink")
    AddItem( *combo, -1, "Container")
    AddItem( *combo, -1, "ListIcon")
    AddItem( *combo, -1, "IPAddress")
    AddItem( *combo, -1, "ProgressBar")
    AddItem( *combo, -1, "ScrollBar")
    AddItem( *combo, -1, "ScrollArea")
    AddItem( *combo, -1, "TrackBar")
    AddItem( *combo, -1, "Web")
    AddItem( *combo, -1, "ButtonImage")
    AddItem( *combo, -1, "Calendar")
    AddItem( *combo, -1, "Date")       
    AddItem( *combo, -1, "Editor")
    AddItem( *combo, -1, "ExplorerList")
    AddItem( *combo, -1, "ExplorerTree")
    AddItem( *combo, -1, "ExplorerCombo")
    AddItem( *combo, -1, "Spin")        
    AddItem( *combo, -1, "Tree")         
    AddItem( *combo, -1, "Panel")        
    AddItem( *combo, -1, "Splitter")    
    AddItem( *combo, -1, "MDI") 
    AddItem( *combo, -1, "Scintilla") 
    AddItem( *combo, -1, "Shortcut")  
    AddItem( *combo, -1, "Canvas")   
    
    SetState( *combo, #PB_GadgetType_Button)
    Bind(*combo, @Widgets_CallBack())
  EndIf
  
  HideWindow(GetWindow(GetRoot(*window_1)),0)
  HideWindow(GetWindow(GetRoot(*window_2)),0)
  
  ReDraw(GetRoot(*window_1))
  ReDraw(GetRoot(*window_2))
  
  
  Repeat
    Define Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -6-
; EnableXP