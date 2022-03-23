XIncludeFile "../../../widgets.pbi"

; Attribute für das TabBar
Enumeration
  #__tab_None                 = 0<<0
  #__tab_CloseButton          = 1<<0
  #__tab_NewTab               = 1<<1
  #__tab_TextCutting          = 1<<2
  #__tab_MirroredTabs         = 1<<3
  #__tab_Vertical             = 1<<4
  #__tab_NoTabMoving          = 1<<5
  #__tab_MultiLine            = 1<<6
  #__tab_BottomLine           = 1<<7
  #__tab_PopupButton          = 1<<8
  #__tab_Editable             = 1<<9
  #__tab_MultiSelect          = 1<<10
  #__tab_CheckBox             = 1<<11
  #__tab_SelectedCloseButton    = 1<<12
  #__tab_ReverseOrdering      = 1<<13
  #__tab_ImageSize            = 1<<23
  #__tab_TabTextAlignment     = 1<<24
  #__tab_ScrollPosition       = 1<<25
  #__tab_NormalTabLength      = 1<<26 ; für Später
  #__tab_MaxTabLength         = 1<<27
  #__tab_MinTabLength         = 1<<28
  #__tab_TabRounding          = 1<<29
  #__tab_PreviousArrow        = 1<<30
  #__tab_NextArrow            = 1<<31
EndEnumeration

; Ereignisse von TabBarEvent
Enumeration #PB_EventType_FirstCustomValue
  #__event_Pushed 
  #__event_Updated      ; Das Gadget hat sich aktualisiert (intern)
  ;;;#__event_Change       ; Der aktive Tab wurde geändert
  ;;;#__event_Resize       ; Die größe der Leiste hat sich geändert
  #__event_NewItem      ; ein neuer Tab wird angefordert
  ;;;#__event_CloseItem    ; ein Tab soll geschlossen werden
  #__event_SwapItem     ; der aktive Tab wurde verschoben
  #__event_EditItem     ; der Text einer Karte wurde geändert
  #__event_CheckBox     ; der Status der Checkbox hat sich geändert
  #__event_PopupButton  ; der Popup-Button wurde gedrückt
EndEnumeration




; Positions-Konstanten für "Item"-Befehle
Enumeration
  #__tab_item_None        = -1
  #__tab_item_NewTab      = -2
  #__tab_item_Selected    = -3
  #__tab_item_Event       = -4
EndEnumeration

; Interne Konstanten
#__tab_color_state_Normal  = 0
#__tab_color_state_Hover   = 1
#__tab_color_state_Selected  = 2
#__tab_color_state_Disable = 3
#__tab_color_state_Move    = 4


; Status-Konstanten
Enumeration
  #__tab_update_Directly  = 0
  #__tab_update_PostEvent = 1
EndEnumeration

#__tab_DefaultHeight     = 30


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  Global *tab1
  
Enumeration
  #Window
  #Image
  #Gadget_TabBar
  #Gadget_Vertical
  #Gadget_CloseButton
  #Gadget_SelectedCloseButton
  #Gadget_EmptyButton
  #Gadget_MirroredTabs
  #Gadget_TextCutting
  #Gadget_NoTabMoving
  #Gadget_TabRounding
  #Gadget_MultiLine
  #Gadget_BottomLine
  #Gadget_Editable
  #Gadget_MultiSelect
  #Gadget_CheckBox
  #Gadget_ReverseOrdering
  #Gadget_TabTextAlignment
  #Gadget_MinTabLength
  #Gadget_MaxTabLength
  #Gadget_Item
  #Gadget_ItemBackColor
  #Gadget_ItemFrontColor
  #Gadget_ItemText
  #Gadget_ItemImage
  #Gadget_ItemDisabled
  #Gadget_ItemSelected
  #Gadget_ItemChecked
  #Gadget_ItemCloseButton
  #Gadget_ItemCheckBox
  #Gadget_Events
  #Gadget_Container
EndEnumeration

Procedure SetItemPosition(*this._s_widget, Tab.i, Position.i) ; Code OK, Hilfe OK
  
  
;   Protected *NewItem._s_rows = ItemID(*this, Position)
;   Protected *Item._s_rows = ItemID(*this, Tab)
;   
;   If *Item And *Item <> *this\NewTabItem
;     If *NewItem And *NewItem <> *this\NewTabItem
;       If Position > Tab
;         MoveElement(*this\Item(), #PB_List_After, *NewItem)
;       Else
;         MoveElement(*this\Item(), #PB_List_Before, *NewItem)
;       EndIf
;     Else
;       MoveElement(*this\Item(), #PB_List_Last)
;     EndIf
;     PostUpdate(*this)
;   EndIf
  
EndProcedure



; Gibt die Position der angegebenen Registerkarte zurück.
Procedure GetItemPosition(*this._s_widget, Tab.i) ; Code OK, Hilfe OK
  
  
  
;   With *this
;     
;     Select Tab
;       Case #__tab_item_Event
;         ProcedureReturn \EventTab
;         
;       Case #__tab_item_Selected
;         If \SelectedItem
;           ChangeCurrentElement(\Item(), \SelectedItem)
;           ProcedureReturn ListIndex(\Item())
;         Else
;           ProcedureReturn #__tab_item_None
;         EndIf
;       Case #__tab_item_NewTab, #__tab_item_None
;         ProcedureReturn Tab
;         
;       Default 
;         If Tab >= 0 And Tab < ListSize(\Item())
;           ProcedureReturn Tab
;         ElseIf Tab >= ListSize(\Item())
;           ForEach \Item()
;             If @\Item() = Tab
;               ProcedureReturn ListIndex(\Item())
;             EndIf
;           Next
;           ProcedureReturn #__tab_item_None
;         EndIf
;     EndSelect
;     
;   EndWith
  
EndProcedure

Procedure BorderGadget(ID.i, X.i, Y.i, Width.i, Height.i, Text.s)
  Protected Result.i
  If ID = #PB_Any
    Result = ContainerGadget(ID, X, Y, Width, Height)
    SetGadgetData(Result, FrameGadget(#PB_Any, 0, 0, Width, Height, Text))
  Else
    Result = ContainerGadget(ID, X, Y, Width, Height)
    SetGadgetData(ID, FrameGadget(#PB_Any, 0, 0, Width, Height, Text))
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure GetItemGadgetState()
  Select GetGadgetState(#Gadget_Item)
    Case - 1
      ProcedureReturn #__tab_item_None
    Case 0
      ProcedureReturn #__tab_item_NewTab
    Default
      ProcedureReturn GetGadgetState(#Gadget_Item) - 1
  EndSelect
EndProcedure

Procedure UpdateItemAttributes(Position)
  ;;Debug 999;ProcedureReturn 
  If GetGadgetText(#Gadget_ItemText) <> GetItemText(*tab1, Position)
    SetGadgetText(#Gadget_ItemText, GetItemText(*tab1, Position))
  EndIf
  
  SetGadgetState(#Gadget_ItemDisabled, (GetItemState(*tab1, Position)&#__s_Disable))
  SetGadgetState(#Gadget_ItemSelected, (GetItemState(*tab1, Position)&#__s_Select))
  SetGadgetState(#Gadget_ItemChecked, (GetItemState(*tab1, Position)&#__s_Check))
  SetGadgetState(#Gadget_ItemCloseButton, GetItemAttribute(*tab1, Position, #__tab_CloseButton))
  SetGadgetState(#Gadget_ItemCheckBox, GetItemAttribute(*tab1, Position, #__tab_CheckBox))
EndProcedure

Procedure UpdateItemGadget(Position)
  Protected Index
  ClearGadgetItems(#Gadget_Item)
  AddGadgetItem(#Gadget_Item, #PB_Default, "NewTab")
  For Index = 1 To CountItems(*tab1)
    AddGadgetItem(#Gadget_Item, #PB_Default, "Position "+Str(Index-1))
  Next
  SetState(*tab1, Position)
  SetGadgetState(#Gadget_Item, Position+1)
  UpdateItemAttributes(GetItemGadgetState())
EndProcedure



Define Color.i, FileName.s, Position.i

UsePNGImageDecoder()

Open(#Window, 0, 0, 650, 650, "TabBar", #PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_SizeGadget, #Null, #Gadget_TabBar)

ResizeGadget( GetGadget( ), 10, 10, 650-20, 30)
*tab1 = Tab(0, 0, WindowWidth(#Window), #__tab_DefaultHeight, #__flag_autosize)
AddItem(*tab1, #PB_Default, "In this")
AddItem(*tab1, #PB_Default, "example")
AddItem(*tab1, #PB_Default, "you can")
AddItem(*tab1, #PB_Default, "feel the")
AddItem(*tab1, #PB_Default, "power of")
AddItem(*tab1, #PB_Default, "Pure Basic")
AddItem(*tab1, #PB_Default, "and the")
AddItem(*tab1, #PB_Default, "TabBar")
AddItem(*tab1, #PB_Default, "include")
;Tab_ToolTip(*tab1, "%ITEM", "new", "close")

If ContainerGadget(#Gadget_Container, 0, GadgetHeight(#Gadget_TabBar), WindowWidth(#Window), WindowHeight(#Window)-GadgetHeight(#Gadget_TabBar), #PB_Container_Flat)
  
  If BorderGadget(#PB_Any, 5, 5, 170, 370, "Attributes for the bar")
    CheckBoxGadget(#Gadget_CloseButton, 10, 20, 130, 20, "tab close button")
    CheckBoxGadget(#Gadget_SelectedCloseButton, 10, 40, 130, 20, "selected tab close button")
    CheckBoxGadget(#Gadget_EmptyButton, 10, 60, 130, 20, "'new' tab")
    CheckBoxGadget(#Gadget_CheckBox, 10, 80, 130, 20, "tab check box")
    CheckBoxGadget(#Gadget_Vertical, 10, 100, 130, 20, "vertical tab bar")
    CheckBoxGadget(#Gadget_MirroredTabs, 10, 120, 130, 20, "mirror tab bar")
    CheckBoxGadget(#Gadget_ReverseOrdering, 10, 140, 130, 20, "reverse ordering")
    CheckBoxGadget(#Gadget_MultiLine, 10, 160, 130, 20, "multiline tab bar")
    CheckBoxGadget(#Gadget_TextCutting, 10, 180, 130, 20, "text cutting")
    CheckBoxGadget(#Gadget_Editable, 10, 200, 130, 20, "editable tab text")
    CheckBoxGadget(#Gadget_MultiSelect, 10, 220, 130, 20, "multi select")
    CheckBoxGadget(#Gadget_NoTabMoving, 10, 240, 130, 20, "no tab moving")
    CheckBoxGadget(#Gadget_BottomLine, 10, 260, 130, 20, "bottom line")
    TextGadget(#PB_Any, 10, 285, 90, 20, "tab text alignment:")
    SpinGadget(#Gadget_TabTextAlignment, 100, 280, 60, 20, -1, 1, #PB_Spin_Numeric)
    SetGadgetState(#Gadget_TabTextAlignment, GetAttribute(*tab1, #__tab_TabTextAlignment))
    TextGadget(#PB_Any, 10, 305, 90, 20, "tab rounding:")
    SpinGadget(#Gadget_TabRounding, 100, 300, 60, 20, 0, 20, #PB_Spin_Numeric)
    SetGadgetState(#Gadget_TabRounding, GetAttribute(*tab1, #__tab_TabRounding))
    TextGadget(#PB_Any, 10, 325, 90, 20, "min tab length:")
    SpinGadget(#Gadget_MinTabLength, 100, 320, 60, 20, 0, 1000, #PB_Spin_Numeric)
    SetGadgetState(#Gadget_MinTabLength, GetAttribute(*tab1, #__tab_MinTabLength))
    TextGadget(#PB_Any, 10, 345, 90, 20, "max tab length:")
    SpinGadget(#Gadget_MaxTabLength, 100, 340, 60, 20, 0, 1000, #PB_Spin_Numeric)
    SetGadgetState(#Gadget_MaxTabLength, GetAttribute(*tab1, #__tab_MaxTabLength))
    CloseGadgetList()
  EndIf
  
  If BorderGadget(#PB_Any, 180, 5, 375, 195, "Tabs")
    TextGadget(#PB_Any, 10, 28, 50, 20, "Position:")
    ComboBoxGadget(#Gadget_Item, 60, 25, 100, 20)
    ButtonGadget(#Gadget_ItemBackColor, 10, 50, 100, 20, "background color")
    ButtonGadget(#Gadget_ItemFrontColor, 115, 50, 100, 20, "text color")
    TextGadget(#PB_Any, 10, 78, 30, 20, "Text:")
    StringGadget(#Gadget_ItemText, 40, 75, 175, 20, GetText(*tab1))
    CheckBoxGadget(#Gadget_ItemDisabled, 10, 100, 100, 20, "disabled")
    CheckBoxGadget(#Gadget_ItemSelected, 10, 120, 100, 20, "seleced")
    CheckBoxGadget(#Gadget_ItemChecked, 10, 140, 100, 20, "checked")
    CheckBoxGadget(#Gadget_ItemCloseButton, 210, 100, 100, 20, "close button")
    CheckBoxGadget(#Gadget_ItemCheckBox, 210, 120, 100, 20, "check box")
    ButtonGadget(#Gadget_ItemImage, 10, 165, 100, 20, "image or icon", #PB_Button_Toggle)
    CloseGadgetList()
  EndIf
  
  If BorderGadget(#PB_Any, 180, 210, 225, 120, "Events")
    EditorGadget(#Gadget_Events, 10, 20, 200, 90, #PB_Editor_ReadOnly)
    CloseGadgetList()
  EndIf
  
  UpdateItemGadget(0)
  
EndIf


Procedure Window_Resize()
  
  If GetAttribute(*tab1, #__tab_Vertical)
    ResizeGadget(#Gadget_TabBar, 10, 10, #PB_Ignore, WindowHeight(#Window)-20)
  Else
    ResizeGadget(#Gadget_TabBar, 10, 10, WindowWidth(#Window)-20, #PB_Ignore)
  EndIf
  
  ReDraw(*tab1)
     ResizeGadget(#Gadget_Container, 100, 100, WindowWidth(#Window)-150, WindowHeight(#Window)-150)
 
EndProcedure

BindEvent(#PB_Event_SizeWindow, @Window_Resize())
Window_Resize()


Repeat
  
  Select WaitWindowEvent()
      
    Case #PB_Event_CloseWindow
      
      End
      
    Case #PB_Event_SizeWindow
      
    Case #PB_Event_Gadget
      
      Select EventGadget()
        Case #Gadget_TabBar
          Select EventType()
            Case #__event_NewItem
              AddGadgetItem(#Gadget_Events, 0, "NewItem: "+Str(GetItemPosition(*tab1, #__tab_item_Event)))
              Position = AddItem(*tab1, #PB_Default, "New tab")
              UpdateItemGadget(Position)
            Case #__event_CloseItem
              AddGadgetItem(#Gadget_Events, 0, "CloseItem: "+Str(GetItemPosition(*tab1, #__tab_item_Event)))
              RemoveItem(*tab1, #__tab_item_Event)
            Case #__event_Change
              AddGadgetItem(#Gadget_Events, 0, "Change: "+Str(GetItemPosition(*tab1, #__tab_item_Event)))
            Case #__event_CheckBox
              AddGadgetItem(#Gadget_Events, 0, "CheckBox: "+Str(GetItemPosition(*tab1, #__tab_item_Event)))
            Case #__event_Resize
              AddGadgetItem(#Gadget_Events, 0, "Resize")
              Window_Resize()
            Case #__event_EditItem
              AddGadgetItem(#Gadget_Events, 0, "EditItem: "+Str(GetItemPosition(*tab1, #__tab_item_Event)))
            Case #__event_SwapItem
              AddGadgetItem(#Gadget_Events, 0, "SwapItem: "+Str(GetItemPosition(*tab1, #__tab_item_Event)))
          EndSelect
          
          UpdateItemAttributes(GetItemGadgetState())
          
        Case #Gadget_CloseButton
          SetAttribute(*tab1, #__tab_CloseButton, GetGadgetState(#Gadget_CloseButton))
        Case #Gadget_SelectedCloseButton
          SetAttribute(*tab1, #__tab_SelectedCloseButton, GetGadgetState(#Gadget_SelectedCloseButton))
        Case #Gadget_EmptyButton
          SetAttribute(*tab1, #__tab_NewTab, GetGadgetState(#Gadget_EmptyButton))
        Case #Gadget_Vertical
          SetAttribute(*tab1, #__tab_Vertical, GetGadgetState(#Gadget_Vertical))
          Window_Resize()
        Case #Gadget_MirroredTabs
          SetAttribute(*tab1, #__tab_MirroredTabs, GetGadgetState(#Gadget_MirroredTabs))
        Case #Gadget_TextCutting
          SetAttribute(*tab1, #__tab_TextCutting, GetGadgetState(#Gadget_TextCutting))
        Case #Gadget_NoTabMoving
          SetAttribute(*tab1, #__tab_NoTabMoving, GetGadgetState(#Gadget_NoTabMoving))
        Case #Gadget_TabRounding
          SetAttribute(*tab1, #__tab_TabRounding, GetGadgetState(#Gadget_TabRounding))
        Case #Gadget_MultiLine
          SetAttribute(*tab1, #__tab_MultiLine, GetGadgetState(#Gadget_MultiLine))
        Case #Gadget_BottomLine
          SetAttribute(*tab1, #__tab_BottomLine, GetGadgetState(#Gadget_BottomLine))
        Case #Gadget_Editable
          SetAttribute(*tab1, #__tab_Editable, GetGadgetState(#Gadget_Editable))
        Case #Gadget_MultiSelect
          SetAttribute(*tab1, #__tab_MultiSelect, GetGadgetState(#Gadget_MultiSelect))
        Case #Gadget_CheckBox
          SetAttribute(*tab1, #__tab_CheckBox, GetGadgetState(#Gadget_CheckBox))
        Case #Gadget_ReverseOrdering
          SetAttribute(*tab1, #__tab_ReverseOrdering, GetGadgetState(#Gadget_ReverseOrdering))
        Case #Gadget_MinTabLength
          SetAttribute(*tab1, #__tab_MinTabLength, GetGadgetState(#Gadget_MinTabLength))
        Case #Gadget_MaxTabLength
          SetAttribute(*tab1, #__tab_MaxTabLength, GetGadgetState(#Gadget_MaxTabLength))
        Case #Gadget_TabTextAlignment
          SetAttribute(*tab1, #__tab_TabTextAlignment, GetGadgetState(#Gadget_TabTextAlignment))
        Case #Gadget_Item
          ;Debug  "- "+GetItemText(*tab1, GetItemGadgetState())
          SetGadgetText(#Gadget_ItemText, GetItemText(*tab1, GetItemGadgetState()))
          UpdateItemAttributes(GetItemGadgetState())
        Case #Gadget_ItemBackColor
          Color = GetItemColor(*tab1, GetState(*tab1), #PB_Gadget_BackColor)
          Color = ColorRequester(Color)
          If Color > -1
            SetItemColor(*tab1, GetItemGadgetState(), #PB_Gadget_BackColor, Color)
          EndIf
        Case #Gadget_ItemFrontColor
          Color = GetItemColor(*tab1, GetState(*tab1), #PB_Gadget_FrontColor)
          Color = ColorRequester(Color)
          If Color > -1
            SetItemColor(*tab1, GetItemGadgetState(), #PB_Gadget_FrontColor, Color)
          EndIf
        Case #Gadget_ItemText
          SetItemText(*tab1, GetItemGadgetState(), GetGadgetText(#Gadget_ItemText))
        Case #Gadget_ItemDisabled
          SetItemState(*tab1, GetItemGadgetState(), GetGadgetState(#Gadget_ItemDisabled) * #__s_Disable)
        Case #Gadget_ItemSelected
          SetItemState(*tab1, GetItemGadgetState(), GetGadgetState(#Gadget_ItemSelected) * #__s_Select)
        Case #Gadget_ItemChecked
          SetItemState(*tab1, GetItemGadgetState(), GetGadgetState(#Gadget_ItemChecked) * #__s_Check)
        Case #Gadget_ItemCloseButton
          SetItemAttribute(*tab1, GetItemGadgetState(), #__tab_CloseButton, GetGadgetState(#Gadget_ItemCloseButton))
        Case #Gadget_ItemCheckBox
          SetItemAttribute(*tab1, GetItemGadgetState(), #__tab_CheckBox, GetGadgetState(#Gadget_ItemCheckBox))
        Case #Gadget_ItemImage
          If GetGadgetState(#Gadget_ItemImage)
            FileName = OpenFileRequester("Image", "", "Images (*.bmp;*.png)|*.bmp;*.png", 0)
            If FileName And LoadImage(#Image, FileName)
              SetItemImage(*tab1, GetItemGadgetState(), ImageID(#Image))
            EndIf
          Else
            SetItemImage(*tab1, GetItemGadgetState(), #Null)
          EndIf
      EndSelect
      
  EndSelect
  
ForEver
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ----
; EnableXP