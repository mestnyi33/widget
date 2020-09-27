IncludePath "../../"
XIncludeFile "widgets.pbi"

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
    Protected EventWidget.i = this()\widget,
              EventType.i = this()\event,
              EventItem.i = this()\item, 
              EventData.i = this()\data
    
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
            
        EndSelect
        
        Debug " re - "
    ForEach widget( ) 
      If widget( )\before And widget( )\after
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" "+ widget( )\before\class +" "+ widget( )\class +" "+ widget( )\after\class
      ElseIf widget( )\after
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" none "+ widget( )\class +" "+ widget( )\after\class
      ElseIf widget( )\before
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" "+ widget( )\before\class +" "+ widget( )\class +" none"
      Else
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" none "+ widget( )\class + " none " 
      EndIf
    Next
    Debug ""
    
    
    EndSelect
    
  EndProcedure
  
  Define X,Y,Flags = #PB_Window_SystemMenu | #PB_Window_ScreenCentered ;| #PB_Window_BorderLess
  OpenWindow(10, 0, 0, 425, 315, "demo set  new parent", Flags )
  
  ; Create desktop for the widgets
  If Open(10)
    *window_1 = Root()
    *w_0 = Button(pos_x,90,160,30,">>(Window)") : SetClass(widget(), GetText(widget()))
    
    *container = Container(215,10,200,130,#PB_Container_Flat) : SetClass(widget(), "container") 
    *c_0 = Button(pos_x,90,160,30,">>(Container)") : SetClass(widget(), GetText(widget())) 
    CloseList()
    
    *panel = Panel(10,145,200,160) 
    AddItem(*panel, -1, "item (0)") : *p_0 = Button(pos_x,90,160,30,">>(Panel (0))") : SetClass(widget(), GetText(widget()))
    AddItem(*panel, -1, "item (1)") : *p_1 = Button(pos_x+5,90,160,30,">>(Panel (1))") : SetClass(widget(), GetText(widget())) 
    AddItem(*panel, -1, "item (2)") : *p_2 = Button(pos_x+10,90,160,30,">>(Panel (2))") : SetClass(widget(), GetText(widget())) 
    CloseList()
    
    *scrollarea = ScrollArea(215,145,200,160,200,160,10,#PB_ScrollArea_Flat) : SetClass(widget(), "scrollarea") 
    *s_0 = Button(pos_x,90,160,30,">>(ScrollArea)") : SetClass(widget(), GetText(widget())) 
    *w = Button(pos_x,10,160,70,"*this") : SetClass(widget(), GetText(widget())) 
    CloseList()
    
    Debug " - "
    ForEach widget( ) 
      If widget( )\before And widget( )\after
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" "+ widget( )\before\class +" "+ widget( )\class +" "+ widget( )\after\class
      ElseIf widget( )\after
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" none "+ widget( )\class +" "+ widget( )\after\class
      ElseIf widget( )\before
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" "+ widget( )\before\class +" "+ widget( )\class +" none"
      Else
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" none "+ widget( )\class + " none " 
      EndIf
    Next
    Debug ""
    
    SetParent(*w, *container, 0)
    
    Debug " container - "
    ForEach widget( ) 
      If widget( )\before And widget( )\after
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" "+ widget( )\before\class +" "+ widget( )\class +" "+ widget( )\after\class
      ElseIf widget( )\after
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" none "+ widget( )\class +" "+ widget( )\after\class
      ElseIf widget( )\before
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" "+ widget( )\before\class +" "+ widget( )\class +" none"
      Else
        Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" none "+ widget( )\class + " none " 
      EndIf
    Next
    Debug ""
    
;     SetParent(*w, *scrollarea, 0)
;     
;     Debug " scrollarea - "
;     ForEach widget( ) 
;       If widget( )\before And widget( )\after
;         Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" "+ widget( )\before\class +" "+ widget( )\class +" "+ widget( )\after\class
;       ElseIf widget( )\after
;         Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" none "+ widget( )\class +" "+ widget( )\after\class
;       ElseIf widget( )\before
;         Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" "+ widget( )\before\class +" "+ widget( )\class +" none"
;       Else
;         Debug " - "+ Str(ListIndex(widget())) +" "+ widget( )\index +" none "+ widget( )\class + " none " 
;       EndIf
;     Next
;     Debug ""
    
    Bind(Root(), @Widgets_CallBack())
  EndIf
  
  
  WaitClose()
  
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP