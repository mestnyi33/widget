XIncludeFile "../../../widgets.pbi"
Uselib(widget)

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  ;- 
  Enumeration 
    #_pi_group_0 
    #_pi_id
    #_pi_class
    #_pi_text
    
    #_pi_group_1 
    #_pi_x
    #_pi_y
    #_pi_width
    #_pi_height
    
    #_pi_group_2 
    #_pi_disable
    #_pi_hide
  EndEnumeration
  
  
  Macro GetItem( _this_ )
     _this_\EnteredRow( )\index  
  EndMacro
  
  Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *w, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  Procedure Property_Events( )
     Protected *splitter._s_WIDGET = EventWidget( )\parent
     Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
     Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
     
     Select WidgetEventType( )
        Case #__event_Down
           SetItemState(*second, GetItem( *first ) , GetItemState(*first, GetItem( *first )  ) )
           
        Case #__event_StatusChange
           If *first\EnteredRow( )
              SetItemState(*second, GetItem( *first ) , GetItemState(*first, GetItem( *first )  ) )
           EndIf
           
     EndSelect
  EndProcedure
  
  Procedure AddItem_( *this._s_WIDGET, item, text.s, image=-1, mode=0 )
     Protected *splitter._s_WIDGET = GetData(*this)
     Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
     Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
     
     AddItem( *first, item, StringField(text.s, 1, Chr(10)), image, mode )
     AddItem( *second, item, StringField(text.s, 2, Chr(10)), image, mode )
     
     
  EndProcedure
  
  Procedure property( x,y,width,height, flag=0 )
     Protected *this._s_WIDGET = Container(x,y,width,height) 
     Protected *first._s_WIDGET = Tree(0,0,0,0, #__flag_autosize)
     Protected *second._s_WIDGET = Tree(0,0,0,0, #PB_Tree_NoButtons|#PB_Tree_NoLines|#__flag_autosize)
     
     Protected *splitter._s_WIDGET = Splitter(0,0,0,0, *first,*second, #PB_Splitter_Vertical |#PB_Splitter_FirstFixed| #__flag_autosize )
     SetAttribute(*splitter, #PB_Splitter_SecondMinimumSize, 50 )
     SetState(*splitter, 50 )
     SetData(*this, *splitter)
     
     Closelist( )
     
     
     SetData(*second, *first)
     SetData(*first, *second)
     
     Bind(*first, @Property_Events( ))
     ProcedureReturn *this
  EndProcedure
  
  If Open(0, 0, 0, 605+30, 140+200+140+140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define *Tree = property(10, 10, 250, 200);, #__flag_gridlines);|#__tree_nolines);, #__flag_autosize) 
    Define Value = *Tree
    AddItem_(*Tree, #_pi_group_0, "common")
    AddItem_(*Tree, #_pi_id, "id:"+Chr(10)+Str(Value), #PB_GadgetType_String, 1)
    AddItem_(*Tree, #_pi_class, "class:"+Chr(10)+GetClass(Value)+"_"+GetCount(Value), #PB_GadgetType_String, 1)
    AddItem_(*Tree, #_pi_text, "text:"+Chr(10)+GetText(Value), #PB_GadgetType_String, 1)
    
    AddItem_(*Tree, #_pi_group_1, "layout")
    AddItem_(*Tree, #_pi_x, "x:"+Chr(10)+Str(X(Value)), #PB_GadgetType_Spin, 1)
    AddItem_(*Tree, #_pi_y, "y:"+Chr(10)+Str(Y(Value)), #PB_GadgetType_Spin, 1)
    AddItem_(*Tree, #_pi_width, "width:"+Chr(10)+Str(Width(Value)), #PB_GadgetType_Spin, 1)
    AddItem_(*Tree, #_pi_height, "height:"+Chr(10)+Str(Height(Value)), #PB_GadgetType_Spin, 1)
    
    AddItem_(*Tree, #_pi_group_2, "state")
    AddItem_(*Tree, #_pi_disable, "disable:"+Chr(10)+"", #PB_GadgetType_ComboBox, 1);Str(Disable(Value)))
    AddItem_(*Tree, #_pi_hide, "hide:"+Chr(10)+Str(Hide(Value)), #PB_GadgetType_ComboBox, 1)
    
    Define *Tree1 = property(10, 10, 250, 200, #__flag_gridlines);|#__tree_nolines);, #__flag_autosize) 
    Define Value = *Tree1
    AddItem_(*Tree1, #_pi_group_0, "common")
    AddItem_(*Tree1, #_pi_id, "id:"+Chr(10)+Str(Value), #PB_GadgetType_String, 1)
    AddItem_(*Tree1, #_pi_class, "class:"+Chr(10)+GetClass(Value)+"_"+GetCount(Value), #PB_GadgetType_String, 1)
    AddItem_(*Tree1, #_pi_text, "text:"+Chr(10)+GetText(Value), #PB_GadgetType_String, 1)
    
    AddItem_(*Tree1, #_pi_group_1, "layout")
    AddItem_(*Tree1, #_pi_x, "x:"+Chr(10)+Str(X(Value)), #PB_GadgetType_Spin, 1)
    AddItem_(*Tree1, #_pi_y, "y:"+Chr(10)+Str(Y(Value)), #PB_GadgetType_Spin, 1)
    AddItem_(*Tree1, #_pi_width, "width:"+Chr(10)+Str(Width(Value)), #PB_GadgetType_Spin, 1)
    AddItem_(*Tree1, #_pi_height, "height:"+Chr(10)+Str(Height(Value)), #PB_GadgetType_Spin, 1)
    
    AddItem_(*Tree1, #_pi_group_2, "state")
    AddItem_(*Tree1, #_pi_disable, "disable:"+Chr(10)+"", #PB_GadgetType_ComboBox, 1);Str(Disable(Value)))
    AddItem_(*Tree1, #_pi_hide, "hide:"+Chr(10)+Str(Hide(Value)), #PB_GadgetType_ComboBox, 1)
    
    Splitter_0 = Splitter(0, 0, 300, 300, Button_1, *Tree)
    Splitter_1 = Splitter(30, 30, 300, 300, Splitter_0, *Tree1, #PB_Splitter_Vertical)
    
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 42
; FirstLine = 14
; Folding = --
; EnableXP