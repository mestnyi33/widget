
;-
;-
;-
XIncludeFile "widgets.pbi" 
Uselib(widget)
UsePNGImageDecoder()

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
  
  If Transform()\widget\transform = 1
    AddElement(*copy()) 
    *copy.allocate(group, ())
    *copy()\widget = Transform()\widget
  Else
    ;       ForEach Transform()\group()
    ;         AddElement(*copy()) 
    ;         *copy.allocate(group, ())
    ;         *copy()\widget = Transform()\group()\widget
    ;       Next
    
    CopyList(Transform()\group(), *copy())
    
  EndIf
  
  Transform()\id[0]\x = Transform()\grid\size
  Transform()\id[0]\y = Transform()\grid\size
EndMacro

Macro widget_delete()
  If Transform()\widget\transform = 1
    ;  transform = Transform()\widget\parent
    
    RemoveItem(id_inspector_tree, GetData(Transform()\widget))
    Free(Transform()\widget)
  Else
    ;  transform = Transform()\widget
    
    ForEach Transform()\group()
      RemoveItem(id_inspector_tree, GetData(Transform()\group()\widget))
      Free(Transform()\group()\widget)
      DeleteElement(Transform()\group())
    Next
    
    ClearList(Transform()\group())
  EndIf
  
  ; a_set(transform)
EndMacro

Macro widget_paste()
  If ListSize(*copy())
    ForEach *copy()
      ;         widget_add(*copy()\widget\parent, 
      ;                        *copy()\widget\class, 
      ;                        *copy()\widget\x[#__c_container] + (Transform()\id[0]\x),; -*copy()\widget\parent\x[#__c_inner]),
      ;                        *copy()\widget\y[#__c_container] + (Transform()\id[0]\y),; -*copy()\widget\parent\y[#__c_inner]), 
      ;                        *copy()\widget\width[#__c_frame],
      ;                        *copy()\widget\height[#__c_frame])
    Next
    
    Transform()\id[0]\x + Transform()\grid\size
    Transform()\id[0]\y + Transform()\grid\size
    
    ClearList(Transform()\group())
    CopyList(*copy(), Transform()\group())
  EndIf
  
  ForEach Transform()\group()
    Debug " ggg "+Transform()\group()\widget
  Next
  
  ;a_update(Transform()\widget)
EndMacro

Procedure toolbar_events()
  Protected *this._s_widget
  Protected e_type = this()\event
  Protected e_item = this()\item
  Protected e_widget = this()\widget
  
  Select e_type
    Case #PB_EventType_LeftClick
      If e_widget = id_elements_tree
        Debug "click"
        ; SetCursor(this()\widget, ImageID(GetItemData(id_elements_tree, Transform()\type)))
      EndIf
      
      If getclass(e_widget) = "ToolBar"
        Protected transform, move_x, move_y, toolbarbutton = GetData(e_widget)
        Static NewList *copy._s_group()
        
        
        Select toolbarbutton
          Case 1
            If Getstate(e_widget)  
              ; group
              group_select = e_widget
              ; SetAtributte(e_widget, #PB_Button_PressedImage)
            Else
              ; un group
              group_select = 0
            EndIf
            
            ForEach Transform()\group()
              Debug Transform()\group()\widget\x
              
            Next
            
            
          Case #_tb_widget_copy
            widget_copy()
            
          Case #_tb_widget_cut
            widget_copy()
            widget_delete()
            
          Case #_tb_widget_paste
            widget_paste()
            
          Case #_tb_widget_delete
            If Transform()\widget\transform = 1
              transform = Transform()\widget\parent
            Else
              transform = Transform()\widget
            EndIf
            
            widget_delete()
            
            a_set(transform)
            
          Case #_tb_group_left,
               #_tb_group_right, 
               #_tb_group_top, 
               #_tb_group_bottom, 
               #_tb_group_width, 
               #_tb_group_height
            
            move_x = Transform()\id[0]\x - Transform()\widget\x[#__c_inner]
            move_y = Transform()\id[0]\y - Transform()\widget\y[#__c_inner]
            
            ForEach Transform()\group()
              Select toolbarbutton
                Case #_tb_group_left ; left
                                     ;Transform()\id[0]\x = 0
                  Transform()\id[0]\width = 0
                  Resize(Transform()\group()\widget, move_x, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                  
                Case #_tb_group_right ; right
                  Transform()\id[0]\x = 0
                  Transform()\id[0]\width = 0
                  Resize(Transform()\group()\widget, move_x + Transform()\group()\width, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                  
                Case #_tb_group_top ; top
                                    ;Transform()\id[0]\y = 0
                  Transform()\id[0]\height = 0
                  Resize(Transform()\group()\widget, #PB_Ignore, move_y, #PB_Ignore, #PB_Ignore)
                  
                Case #_tb_group_bottom ; bottom
                  Transform()\id[0]\y = 0
                  Transform()\id[0]\height = 0
                  Resize(Transform()\group()\widget, #PB_Ignore, move_y + Transform()\group()\height, #PB_Ignore, #PB_Ignore)
                  
                Case #_tb_group_width ; stretch horizontal
                  Resize(Transform()\group()\widget, #PB_Ignore, #PB_Ignore, Transform()\id[0]\width, #PB_Ignore)
                  
                Case #_tb_group_height ; stretch vertical
                  Resize(Transform()\group()\widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Transform()\id[0]\height)
                  
              EndSelect
            Next
            
            a_update(Transform()\widget)
            
            ;Redraw(root())
        EndSelect
      EndIf
      
  EndSelect
EndProcedure

Macro ToolBarButton(_button_, _image_, _mode_=0, _text_="")
  ; #PB_ToolBar_Normal: the button will act as standard button (Default)
  ; #PB_ToolBar_Toggle: the button will act as toggle button
  
  ;ButtonImage(2 + ((Bool(MacroExpandedCount>1) * 32) * (MacroExpandedCount-1)), 2,30,30,_image_)
  ButtonImage(2+((widget()\x+widget()\width) * Bool(MacroExpandedCount - 1)), 2,30,30,_image_, _mode_)
  ;widget()\color = widget()\parent\color
  ;widget()\text\padding\x = 0
  widget()\class = "ToolBar"
  widget()\data = _button_
  ;SetData(widget(), _button_)
  Bind(widget(), @toolbar_events())
EndMacro

Macro Separator()
  Text(2+widget()\x+widget()\width, 2,1,30,"")
  Button(widget()\x+widget()\width, 2+4,1,24,"")
  SetData(widget(), - MacroExpandedCount)
  Text(widget()\x+widget()\width, 2,1,30,"")
EndMacro


Open(OpenWindow(#PB_Any, 150, 150, 600, 600+40, "PB (window_1)", #__Window_SizeGadget | #__Window_SystemMenu))
toolbar_design = Container(0,0,600,40) 
;SetAlignment(widget(), #__align_top)
;ToolBar(toolbar, window, flags)

group_select = ToolBarButton(1, - 1, #__button_Toggle)
SetAttribute(widget(), #PB_Button_Image, CatchImage(#PB_Any,?group_un))
SetAttribute(widget(), #PB_Button_PressedImage, CatchImage(#PB_Any,?group))

;ToolBarButton(2, CatchImage(#PB_Any,?group_un))
Separator()
ToolBarButton(#_tb_group_left, CatchImage(#PB_Any,?group_left))
ToolBarButton(#_tb_group_right, CatchImage(#PB_Any,?group_right))
Separator()
ToolBarButton(#_tb_group_top, CatchImage(#PB_Any,?group_top))
ToolBarButton(#_tb_group_bottom, CatchImage(#PB_Any,?group_bottom))
Separator()
ToolBarButton(#_tb_group_width, CatchImage(#PB_Any,?group_width))
ToolBarButton(#_tb_group_height, CatchImage(#PB_Any,?group_height))

Separator()
ToolBarButton(#_tb_widget_copy, CatchImage(#PB_Any,?widget_copy))
ToolBarButton(#_tb_widget_paste, CatchImage(#PB_Any,?widget_paste))
ToolBarButton(#_tb_widget_cut, CatchImage(#PB_Any,?widget_cut))
ToolBarButton(#_tb_widget_delete, CatchImage(#PB_Any,?widget_delete))
Separator()
ToolBarButton(#_tb_align_left, CatchImage(#PB_Any,?group_left))
ToolBarButton(#_tb_align_top, CatchImage(#PB_Any,?group_top))
ToolBarButton(#_tb_align_center, CatchImage(#PB_Any,?group_width))
ToolBarButton(#_tb_align_bottom, CatchImage(#PB_Any,?group_bottom))
ToolBarButton(#_tb_align_right, CatchImage(#PB_Any,?group_right))
CloseList()


Container(0,40,600,600);, #__flag_autosize) 
                       ;SetAlignment(widget(), #__align_full)
a_init(widget()) 

; mdi(0,0,0,0, #__flag_autosize)
; additem(widget(), -1, "form_0")
; resize(widget(), 50, 30, 500, 500)
*new = Window(50, 30, 500, 470, "window_2", #__Window_SizeGadget | #__Window_SystemMenu, widget())
; ; container(30,30,450-2,450-2)
;;ScrollArea(30,30,450-2,450-2, 0,0)
ScrollArea(30,30,450-2,450-2, 750,750)

container(30,30,400,400)
Button(120,120,170,40,"butt0")
Button(120,160,115,50,"butt1")
Button(150,180,115,50,"butt2")
Button(180,200,115,50,"butt2")
Button(120,240,170,40,"butt4")
closelist()
closelist()

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow

DataSection   
  ; include images
  IncludePath #path + "ide/include/images"
  
  widget_delete:    : IncludeBinary "delete1.png"
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
EndDataSection
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ---
; EnableXP