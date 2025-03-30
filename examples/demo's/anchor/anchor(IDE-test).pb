#IDE_path = "../../../"
XIncludeFile #IDE_path + "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UseWidgets( )
  UsePNGImageDecoder()
  Global id_elements_tree, group_select, id_inspector_tree, toolbar_design
  
  Define *new
  ; toolbar buttons
  Enumeration 
    #_tb_group_left = 3
    #_tb_group_right
    #_tb_group_top
    #_tb_group_bottom
    #_tb_group_width
    #_tb_group_height
    
    #_tb_align_left
    #_tb_align_right
    #_tb_align_top
    #_tb_align_bottom
    #_tb_align_center
    
    #_tb_widget_paste
    #_tb_widget_delete
    #_tb_widget_copy
    #_tb_widget_cut
  EndEnumeration
  
  Macro widget_copy()
    ClearList(*copy())
    
    If a_transform()\widget\_a_transform = 1
      AddElement(*copy()) 
      *copy.allocate(group, ())
      *copy()\widget = a_transform()\widget
    Else
      ;       ForEach a_transform()\group()
      ;         AddElement(*copy()) 
      ;         *copy.allocate(group, ())
      ;         *copy()\widget = a_transform()\group()\widget
      ;       Next
      
      CopyList(a_transform()\group(), *copy())
      
    EndIf
    
    a_transform()\id[0]\x = a_transform()\grid\size
    a_transform()\id[0]\y = a_transform()\grid\size
  EndMacro
  
  Macro widget_delete()
    If a_transform()\widget\_a_transform = 1
      ;  transform = a_transform()\widget\parent
      
      RemoveItem(id_inspector_tree, GetData(a_transform()\widget))
      Free(a_transform()\widget)
    Else
      ;  transform = a_transform()\widget
      
      ForEach a_transform()\group()
        RemoveItem(id_inspector_tree, GetData(a_transform()\group()\widget))
        Free(a_transform()\group()\widget)
        DeleteElement(a_transform()\group())
      Next
      
      ClearList(a_transform()\group())
    EndIf
    
    ; a_set(transform)
  EndMacro
  
  Macro widget_paste()
    If ListSize(*copy())
      ForEach *copy()
        ;         widget_add(*copy()\widget\parent, 
        ;                        *copy()\widget\class, 
        ;                        *copy()\widget\x[#__c_container] + (a_transform()\id[0]\x),; -*copy()\widget\parent\x[#__c_inner]),
        ;                        *copy()\widget\y[#__c_container] + (a_transform()\id[0]\y),; -*copy()\widget\parent\y[#__c_inner]), 
        ;                        *copy()\widget\width[#__c_frame],
        ;                        *copy()\widget\height[#__c_frame])
      Next
      
      a_transform()\id[0]\x + a_transform()\grid\size
      a_transform()\id[0]\y + a_transform()\grid\size
      
      ClearList(a_transform()\group())
      CopyList(*copy(), a_transform()\group())
    EndIf
    
    ForEach a_transform()\group()
      Debug " ggg "+a_transform()\group()\widget
    Next
    
    ;a_update(a_transform()\widget)
  EndMacro
  
  Procedure toolbar_events()
;     Protected *this._s_widget
;     Protected e_type = WidgetEvent( )
;     Protected e_item ;= this()\item
;     Protected e_widget = EventWidget( )
;     
;     Select e_type
;       Case #PB_EventType_LeftClick
;         If e_widget = id_elements_tree
;           Debug "click"
;           ; SetCursor(EventWidget( ), ImageID(GetItemData(id_elements_tree, a_transform()\type)))
;         EndIf
;         
;         If getclass(e_widget) = "Tool"
;           Protected transform, move_x, move_y, BarButton = GetData(e_widget)
;           Static NewList *copy._s_group()
;           
;           
;           Select BarButton
;             Case 1
;               If Getstate(e_widget)  
;                 ; group
;                 group_select = e_widget
;                 ; SetAtributte(e_widget, #PB_Button_PressedImage)
;               Else
;                 ; un group
;                 group_select = 0
;               EndIf
;               
;               ForEach a_transform()\group()
;                 Debug a_transform()\group()\widget\x
;                 
;               Next
;               
;               
;             Case #_tb_widget_copy
;               widget_copy()
;               
;             Case #_tb_widget_cut
;               widget_copy()
;               widget_delete()
;               
;             Case #_tb_widget_paste
;               widget_paste()
;               
;             Case #_tb_widget_delete
;               If a_transform()\widget\_a_transform = 1
;                 transform = a_transform()\widget\parent
;               Else
;                 transform = a_transform()\widget
;               EndIf
;               
;               widget_delete()
;               
;               a_set(transform)
;               
;             Case #_tb_group_left,
;                  #_tb_group_right, 
;                  #_tb_group_top, 
;                  #_tb_group_bottom, 
;                  #_tb_group_width, 
;                  #_tb_group_height
;               
;               move_x = a_transform()\id[0]\x - a_transform()\widget\x[#__c_inner]
;               move_y = a_transform()\id[0]\y - a_transform()\widget\y[#__c_inner]
;               
;               ForEach a_transform()\group()
;                 Select BarButton
;                   Case #_tb_group_left ; left
;                                        ;a_transform()\id[0]\x = 0
;                     a_transform()\id[0]\width = 0
;                     Resize(a_transform()\group()\widget, move_x, #PB_Ignore, #PB_Ignore, #PB_Ignore)
;                     
;                   Case #_tb_group_right ; right
;                     a_transform()\id[0]\x = 0
;                     a_transform()\id[0]\width = 0
;                     Resize(a_transform()\group()\widget, move_x + a_transform()\group()\width, #PB_Ignore, #PB_Ignore, #PB_Ignore)
;                     
;                   Case #_tb_group_top ; top
;                                       ;a_transform()\id[0]\y = 0
;                     a_transform()\id[0]\height = 0
;                     Resize(a_transform()\group()\widget, #PB_Ignore, move_y, #PB_Ignore, #PB_Ignore)
;                     
;                   Case #_tb_group_bottom ; bottom
;                     a_transform()\id[0]\y = 0
;                     a_transform()\id[0]\height = 0
;                     Resize(a_transform()\group()\widget, #PB_Ignore, move_y + a_transform()\group()\height, #PB_Ignore, #PB_Ignore)
;                     
;                   Case #_tb_group_width ; stretch horizontal
;                     Resize(a_transform()\group()\widget, #PB_Ignore, #PB_Ignore, a_transform()\id[0]\width, #PB_Ignore)
;                     
;                   Case #_tb_group_height ; stretch vertical
;                     Resize(a_transform()\group()\widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, a_transform()\id[0]\height)
;                     
;                 EndSelect
;               Next
;               
;               a_update(a_transform()\widget)
;               
;           EndSelect
;         EndIf
;         
;     EndSelect
  EndProcedure
  
  Global barbuttonsize = (24);26+10
  Macro BarButton_(_button_, _image_, _mode_=0, _text_="")
    ; #PB_ToolBar_Normal: the button will act as standard button (Default)
    ; #PB_ToolBar_Toggle: the button will act as toggle button
    
     ;ButtonImage(2 + ((Bool(MacroExpandedCount>1) * 32) * (MacroExpandedCount-1)), 2,barbuttonsize,barbuttonsize,_image_)
;      If IsImage(_image_)
;        Debug IsImage( ResizeImage(_image_,barbuttonsize,barbuttonsize ))
;      EndIf
     
    ButtonImage(2+((X(widget())+Width(widget())) * Bool(MacroExpandedCount - 1)), 2,barbuttonsize,barbuttonsize,_image_, _mode_)
    ;widget()\color = widget()\parent\color
    ;widget()\txt\padding\x = 0
    widget()\class = "Tool"
    widget()\data = _button_
    ;SetData(widget(), _button_)
    Bind(widget(), @toolbar_events())
  EndMacro
  
  Macro Separator_()
    Text(2+(X(widget())+Width(widget())), 2,1,barbuttonsize,"")
    Button((X(widget())+Width(widget())), 2+4,1,barbuttonsize-6,"")
    SetData(widget(), - MacroExpandedCount)
    Text((X(widget())+Width(widget())), 2,1,barbuttonsize,"")
  EndMacro
  
  
  Open(0, 150, 150, 600, 600+barbuttonsize+6, "PB (window_1)", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
  toolbar_design = Container(0,0,600,barbuttonsize+6) 
  ;SetAlignmentFlag(widget(), #__align_top)
  ;ToolBar(toolbar, window, flags)
  
;   group_select = BarButton_(1, - 1, #PB_Button_Toggle)
;   SetAttribute(widget(), #PB_Button_Image, CatchImage(#PB_Any,?group_un))
;   SetAttribute(widget(), #PB_Button_PressedImage, CatchImage(#PB_Any,?group))
;   
;   ;BarButton(2, CatchImage(#PB_Any,?group_un))
   Separator_()
  BarButton_(#_tb_group_left, CatchImage(#PB_Any,?image_16))
  BarButton_(#_tb_group_right, CatchImage(#PB_Any,?image_24))
  BarButton_(#_tb_group_top, CatchImage(#PB_Any,?image_32))
  BarButton_(#_tb_group_top, CatchImage(#PB_Any,?image_40))
  BarButton_(#_tb_group_bottom, CatchImage(#PB_Any,?image_48))
  Separator_()
  BarButton_(#_tb_group_width, CatchImage(#PB_Any,?group_width))
  BarButton_(#_tb_group_height, CatchImage(#PB_Any,?group_height))
  
  Separator_()
  BarButton_(#_tb_widget_copy, CatchImage(#PB_Any,?widget_copy))
  BarButton_(#_tb_widget_paste, CatchImage(#PB_Any,?widget_paste))
  BarButton_(#_tb_widget_cut, CatchImage(#PB_Any,?widget_cut))
  BarButton_(#_tb_widget_delete, CatchImage(#PB_Any,?widget_delete))
  Separator_()
  BarButton_(#_tb_align_left, CatchImage(#PB_Any,?group_left))
  BarButton_(#_tb_align_top, CatchImage(#PB_Any,?group_top))
  BarButton_(#_tb_align_center, CatchImage(#PB_Any,?group_width))
  BarButton_(#_tb_align_bottom, CatchImage(#PB_Any,?group_bottom))
  BarButton_(#_tb_align_right, CatchImage(#PB_Any,?group_right))
  CloseList()
  
  
  ;Container(0,barbuttonsize+6,600,600);, #__flag_autosize) 
  ;SetAlignmentFlag(widget(), #__align_full) 
  
  a_init(MDI(0,barbuttonsize+6,600,600)) 
  
  
  AddItem(widget(), -1, "form_0") : Resize(widget(), 50, 30, 500, 500) : *new = widget()
  SetColor(widget(), #PB_Gadget_BackColor, $C0AED8F2)
  ; *new = Window(50, 30, 500, 500, "window_2", #PB_Window_SizeGadget | #PB_Window_SystemMenu, widget())
  ; ; container(30,30,450-2,450-2)
  ;;ScrollArea(30,30,450-2,450-2, 0,0)
  ScrollArea(30,30,450-2,450-2, 250,750, 1);a_transform()\grid\size)
  SetColor(widget(), #PB_Gadget_BackColor, $C0F2AEDA)
  
  Panel(30,30,400,400)
  SetColor(widget(), #PB_Gadget_BackColor, $C0AEF2D5)
  AddItem(widget(), -1, "item-1")
  ;container(30,30,400,400)
  ComboBox(120,160,115,50)
  AddItem(widget(), -1, "combo1")
  SetState(widget(), 0)
  
  ;Button(120,160,115,50,"butt1")
  AddItem(widget()\parent, -1, "item-2")
  Button(150,180,115,50,"butt2")
  Button(180,200,115,50,"butt3")
  Button(120,240,170,40,"butt4")
  CloseList()
  Spin(120,120,170,40, 0,10);, #__spin_miror | #__spin_text_right )
  CloseList()
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  
  DataSection   
    IncludePath #IDE_path + "ide/include/images"
    
    widget_delete:    : IncludeBinary "delete.png"
    widget_paste:     : IncludeBinary "paste.png"
    widget_copy:      : IncludeBinary "copy.png"
    widget_cut:       : IncludeBinary "cut.png"
    
    group:            : IncludeBinary "group/group.png"
    group_un:         : IncludeBinary "group/group_un.png"
    group_top:        : IncludeBinary "group/group_top.png"
    group_left:       : IncludeBinary "group/group_left.png"
    group_right:      : IncludeBinary "group/group_right.png"
    group_bottom:     : IncludeBinary "group/group_bottom.png"
    group_width:      : IncludeBinary "group/group_width.png"
    group_height:     : IncludeBinary "group/group_height.png"
    
    image_16:         : IncludeBinary "copy_16.png"
    image_24:         : IncludeBinary "copy_24.png"
    image_32:         : IncludeBinary "copy_32.png"
    image_40:         : IncludeBinary "copy_40.png"
    image_48:         : IncludeBinary "copy_48.png"
  EndDataSection
  
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 301
; FirstLine = 288
; Folding = --
; EnableXP
; DPIAware