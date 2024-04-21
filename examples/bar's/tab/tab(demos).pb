XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   #__s_Disable = 3
   #__s_Select = 2
   #__s_Check = 1
   #__event_CloseItem = 300
   
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
      #__tab_SelectedCloseButton  = 1<<12
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
      #__event_Updated      ; Das  hat sich aktualisiert (intern)
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
   
   
   EnableExplicit
   Uselib(widget)
   Global *g_tab1
   
   Enumeration
      #Window
      #Image 
      #Gadget_Canvas
   EndEnumeration
   
   Global *g_Vertical,
          *g_CloseButton,
          *g_SelectedCloseButton,
          *g_EmptyButton,
          *g_MirroredTabs,
          *g_TextCutting,
          *g_NoTabMoving,
          *g_TabRounding,
          *g_MultiLine,
          *g_BottomLine,
          *g_Editable,
          *g_MultiSelect,
          *g_CheckBox,
          *g_ReverseOrdering,
          *g_TabTextAlignment,
          *g_MinTabLength,
          *g_MaxTabLength,
          *g_Item,
          *g_ItemBackColor,
          *g_ItemFrontColor,
          *g_ItemText,
          *g_ItemImage,
          *g_ItemDisabled,
          *g_ItemSelected,
          *g_ItemChecked,
          *g_ItemCloseButton,
          *g_ItemCheckBox,
          *g_Events,
          *g_Container
   
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
   
   Procedure Border(X.i, Y.i, Width.i, Height.i, Text.s)
      Protected Result.i
      Result = Container(X, Y, Width, Height)
      SetData(Result, Frame(0, 0, Width, Height, Text))
      ProcedureReturn Result
   EndProcedure
   
   Procedure GetItemState_()
      Select GetState(*g_Item)
         Case - 1
            ProcedureReturn #__tab_item_None
         Case 0
            ProcedureReturn #__tab_item_NewTab
         Default
            ProcedureReturn GetState(*g_Item) - 1
      EndSelect
   EndProcedure
   
   Procedure UpdateItemAttributes(Position)
      ;;Debug 999;ProcedureReturn 
      If GetText(*g_ItemText) <> GetItemText(*g_tab1, Position)
         SetText(*g_ItemText, GetItemText(*g_tab1, Position))
      EndIf
      
      SetState(*g_ItemDisabled, (GetItemState(*g_tab1, Position)&#__s_Disable))
      SetState(*g_ItemSelected, (GetItemState(*g_tab1, Position)&#__s_Select))
      SetState(*g_ItemChecked, (GetItemState(*g_tab1, Position)&#__s_Check))
      SetState(*g_ItemCloseButton, GetItemAttribute(*g_tab1, Position, #__tab_CloseButton))
      SetState(*g_ItemCheckBox, GetItemAttribute(*g_tab1, Position, #__tab_CheckBox))
   EndProcedure
   
   Procedure UpdateItem(Position)
      Protected Index
      ClearItems(*g_Item)
      AddItem(*g_Item, #PB_Default, "NewTab")
      For Index = 1 To CountItems(*g_tab1)
         AddItem(*g_Item, #PB_Default, "Position "+Str(Index-1))
      Next
      SetState(*g_tab1, Position)
      SetState(*g_Item, Position+1)
      UpdateItemAttributes(GetItemState_())
   EndProcedure
   
   
   
   Define Color.i, FileName.s, Position.i
   
   UsePNGImageDecoder()
   
   Open(#Window, 0, 0, 650, 650, "TabBar", #PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_SizeGadget, #Null, #Gadget_Canvas)
   
   ;Resize( Get( ), 10, 10, 650-20, 30)
   *g_tab1 = Tab(0, 0, WindowWidth(#Window), #__tab_DefaultHeight, #__flag_autosize)
   AddItem(*g_tab1, #PB_Default, "In this")
   AddItem(*g_tab1, #PB_Default, "example")
   AddItem(*g_tab1, #PB_Default, "you can")
   AddItem(*g_tab1, #PB_Default, "feel the")
   AddItem(*g_tab1, #PB_Default, "power of")
   AddItem(*g_tab1, #PB_Default, "Pure Basic")
   AddItem(*g_tab1, #PB_Default, "and the")
   AddItem(*g_tab1, #PB_Default, "TabBar")
   AddItem(*g_tab1, #PB_Default, "include")
   ;Tab_ToolTip(*g_tab1, "%ITEM", "new", "close")
   
   *g_Container = Container( 0, GadgetHeight(#Gadget_Canvas), WindowWidth(#Window), WindowHeight(#Window)-GadgetHeight(#Gadget_Canvas), #PB_Container_Flat)
   If *g_Container
      If Border(5, 5, 170, 370, "Attributes for the bar")
         *g_CloseButton = CheckBox(10, 20, 130, 20, "tab close button")
         *g_SelectedCloseButton = CheckBox(10, 40, 130, 20, "selected tab close button")
         *g_EmptyButton = CheckBox(10, 60, 130, 20, "'new' tab")
         *g_CheckBox = CheckBox(10, 80, 130, 20, "tab check box")
         *g_Vertical = CheckBox(10, 100, 130, 20, "vertical tab bar")
         *g_MirroredTabs = CheckBox(10, 120, 130, 20, "mirror tab bar")
         *g_ReverseOrdering = CheckBox(10, 140, 130, 20, "reverse ordering")
         *g_MultiLine = CheckBox(10, 160, 130, 20, "multiline tab bar")
         *g_TextCutting = CheckBox(10, 180, 130, 20, "text cutting")
         *g_Editable = CheckBox(10, 200, 130, 20, "editable tab text")
         *g_MultiSelect = CheckBox(10, 220, 130, 20, "multi select")
         *g_NoTabMoving = CheckBox(10, 240, 130, 20, "no tab moving")
         *g_BottomLine = CheckBox(10, 260, 130, 20, "bottom line")
         Text(10, 285, 90, 20, "tab text alignment:")
         *g_TabTextAlignment = Spin(100, 280, 60, 20, -1, 1, #PB_Spin_Numeric)
         SetState(*g_TabTextAlignment, GetAttribute(*g_tab1, #__tab_TabTextAlignment))
         Text(10, 305, 90, 20, "tab rounding:")
         *g_TabRounding = Spin(100, 300, 60, 20, 0, 20, #PB_Spin_Numeric)
         SetState(*g_TabRounding, GetAttribute(*g_tab1, #__tab_TabRounding))
         Text(10, 325, 90, 20, "min tab length:")
         *g_MinTabLength = Spin(100, 320, 60, 20, 0, 1000, #PB_Spin_Numeric)
         SetState(*g_MinTabLength, GetAttribute(*g_tab1, #__tab_MinTabLength))
         Text(10, 345, 90, 20, "max tab length:")
         *g_MaxTabLength = Spin(100, 340, 60, 20, 0, 1000, #PB_Spin_Numeric)
         SetState(*g_MaxTabLength, GetAttribute(*g_tab1, #__tab_MaxTabLength))
         CloseList()
      EndIf
      
      If Border(180, 5, 375, 195, "Tabs")
         Text(10, 28, 50, 20, "Position:")
         *g_Item = ComboBox(60, 25, 100, 20)
         *g_ItemBackColor = Button(10, 50, 100, 20, "background color")
         *g_ItemFrontColor = Button(115, 50, 100, 20, "text color")
         Text(10, 78, 30, 20, "Text:")
         *g_ItemText = String(40, 75, 175, 20, GetText(*g_tab1))
         *g_ItemDisabled = CheckBox(10, 100, 100, 20, "disabled")
         *g_ItemSelected = CheckBox(10, 120, 100, 20, "seleced")
         *g_ItemChecked = CheckBox(10, 140, 100, 20, "checked")
         *g_ItemCloseButton = CheckBox(210, 100, 100, 20, "close button")
         *g_ItemCheckBox = CheckBox(210, 120, 100, 20, "check box")
         *g_ItemImage = Button(10, 165, 100, 20, "image or icon", #PB_Button_Toggle)
         CloseList()
      EndIf
      
      If Border(180, 210, 225, 120, "Events")
         *g_Events = Editor(10, 20, 200, 90, #PB_Editor_ReadOnly)
         CloseList()
      EndIf
      
      UpdateItem(0)
      
   EndIf
   
   
   Procedure Window_Resize()
      
      If GetAttribute(*g_tab1, #__tab_Vertical)
         ResizeGadget(#Gadget_Canvas, 10, 10, #PB_Ignore, WindowHeight(#Window)-20)
      Else
         ResizeGadget(#Gadget_Canvas, 10, 10, WindowWidth(#Window)-20, #PB_Ignore)
      EndIf
      
      ReDraw(*g_tab1)
      Resize(*g_Container, 100, 100, WindowWidth(#Window)-150, WindowHeight(#Window)-150)
      
   EndProcedure
   
   BindEvent(#PB_Event_SizeWindow, @Window_Resize())
   Window_Resize()
   
   
   Repeat
      
      Select WaitWindowEvent()
            
         Case #PB_Event_CloseWindow
            
            End
            
         Case #PB_Event_SizeWindow
            
         Case #PB_Event_Gadget
            
            Select Event()
               Case #Gadget_Canvas
                  Select EventType()
                     Case #__event_NewItem
                        AddItem(*g_Events, 0, "NewItem: "+Str(GetItemPosition(*g_tab1, #__tab_item_Event)))
                        Position = AddItem(*g_tab1, #PB_Default, "New tab")
                        UpdateItem(Position)
                     Case #__event_CloseItem
                        AddItem(*g_Events, 0, "CloseItem: "+Str(GetItemPosition(*g_tab1, #__tab_item_Event)))
                        RemoveItem(*g_tab1, #__tab_item_Event)
                     Case #__event_Change
                        AddItem(*g_Events, 0, "Change: "+Str(GetItemPosition(*g_tab1, #__tab_item_Event)))
                     Case #__event_CheckBox
                        AddItem(*g_Events, 0, "CheckBox: "+Str(GetItemPosition(*g_tab1, #__tab_item_Event)))
                     Case #__event_Resize
                        AddItem(*g_Events, 0, "Resize")
                        Window_Resize()
                     Case #__event_EditItem
                        AddItem(*g_Events, 0, "EditItem: "+Str(GetItemPosition(*g_tab1, #__tab_item_Event)))
                     Case #__event_SwapItem
                        AddItem(*g_Events, 0, "SwapItem: "+Str(GetItemPosition(*g_tab1, #__tab_item_Event)))
                  EndSelect
                  
                  UpdateItemAttributes(GetItemState_())
                  
               Case *g_CloseButton
                  SetAttribute(*g_tab1, #__tab_CloseButton, GetState(*g_CloseButton))
               Case *g_SelectedCloseButton
                  SetAttribute(*g_tab1, #__tab_SelectedCloseButton, GetState(*g_SelectedCloseButton))
               Case *g_EmptyButton
                  SetAttribute(*g_tab1, #__tab_NewTab, GetState(*g_EmptyButton))
               Case *g_Vertical
                  SetAttribute(*g_tab1, #__tab_Vertical, GetState(*g_Vertical))
                  Window_Resize()
               Case *g_MirroredTabs
                  SetAttribute(*g_tab1, #__tab_MirroredTabs, GetState(*g_MirroredTabs))
               Case *g_TextCutting
                  SetAttribute(*g_tab1, #__tab_TextCutting, GetState(*g_TextCutting))
               Case *g_NoTabMoving
                  SetAttribute(*g_tab1, #__tab_NoTabMoving, GetState(*g_NoTabMoving))
               Case *g_TabRounding
                  SetAttribute(*g_tab1, #__tab_TabRounding, GetState(*g_TabRounding))
               Case *g_MultiLine
                  SetAttribute(*g_tab1, #__tab_MultiLine, GetState(*g_MultiLine))
               Case *g_BottomLine
                  SetAttribute(*g_tab1, #__tab_BottomLine, GetState(*g_BottomLine))
               Case *g_Editable
                  SetAttribute(*g_tab1, #__tab_Editable, GetState(*g_Editable))
               Case *g_MultiSelect
                  SetAttribute(*g_tab1, #__tab_MultiSelect, GetState(*g_MultiSelect))
               Case *g_CheckBox
                  SetAttribute(*g_tab1, #__tab_CheckBox, GetState(*g_CheckBox))
               Case *g_ReverseOrdering
                  SetAttribute(*g_tab1, #__tab_ReverseOrdering, GetState(*g_ReverseOrdering))
               Case *g_MinTabLength
                  SetAttribute(*g_tab1, #__tab_MinTabLength, GetState(*g_MinTabLength))
               Case *g_MaxTabLength
                  SetAttribute(*g_tab1, #__tab_MaxTabLength, GetState(*g_MaxTabLength))
               Case *g_TabTextAlignment
                  SetAttribute(*g_tab1, #__tab_TabTextAlignment, GetState(*g_TabTextAlignment))
               Case *g_Item
                  ;Debug  "- "+GetItemText(*g_tab1, GetItemState_())
                  SetText(*g_ItemText, GetItemText(*g_tab1, GetItemState_()))
                  UpdateItemAttributes(GetItemState_())
               Case *g_ItemBackColor
                  Color = GetItemColor(*g_tab1, GetState(*g_tab1), #PB_Gadget_BackColor)
                  Color = ColorRequester(Color)
                  If Color > -1
                     SetItemColor(*g_tab1, GetItemState_(), #PB_Gadget_BackColor, Color)
                  EndIf
               Case *g_ItemFrontColor
                  Color = GetItemColor(*g_tab1, GetState(*g_tab1), #PB_Gadget_FrontColor)
                  Color = ColorRequester(Color)
                  If Color > -1
                     SetItemColor(*g_tab1, GetItemState_(), #PB_Gadget_FrontColor, Color)
                  EndIf
               Case *g_ItemText
                  SetItemText(*g_tab1, GetItemState_(), GetText(*g_ItemText))
               Case *g_ItemDisabled
                  SetItemState(*g_tab1, GetItemState_(), GetState(*g_ItemDisabled) * #__s_Disable)
               Case *g_ItemSelected
                  SetItemState(*g_tab1, GetItemState_(), GetState(*g_ItemSelected) * #__s_Select)
               Case *g_ItemChecked
                  SetItemState(*g_tab1, GetItemState_(), GetState(*g_ItemChecked) * #__s_Check)
               Case *g_ItemCloseButton
                  SetItemAttribute(*g_tab1, GetItemState_(), #__tab_CloseButton, GetState(*g_ItemCloseButton))
               Case *g_ItemCheckBox
                  SetItemAttribute(*g_tab1, GetItemState_(), #__tab_CheckBox, GetState(*g_ItemCheckBox))
               Case *g_ItemImage
                  If GetState(*g_ItemImage)
                     FileName = OpenFileRequester("Image", "", "Images (*.bmp;*.png)|*.bmp;*.png", 0)
                     If FileName And LoadImage(#Image, FileName)
                        SetItemImage(*g_tab1, GetItemState_(), ImageID(#Image))
                     EndIf
                  Else
                     SetItemImage(*g_tab1, GetItemState_(), #Null)
                  EndIf
            EndSelect
            
      EndSelect
      
   ForEver
CompilerEndIf


CompilerIf #PB_Compiler_IsMainFile = 99
   #__s_Disable = 3
   #__s_Select = 2
   #__s_Check = 1
   #__event_CloseItem = 300
   
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
      #__tab_SelectedCloseButton  = 1<<12
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
   
   ;ResizeGadget( GetGadget( ), 10, 10, 650-20, 30)
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
; CursorPosition = 182
; FirstLine = 186
; Folding = --------
; EnableXP