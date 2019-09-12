
;IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "_module_tree_12.pb"

DeclareModule Gadget
  
  ;   
  Macro SetGadgetAttribute(_gadget_, _attribute_, _value_)
    SetGadgetAttribute_(_gadget_, _attribute_, _value_)
  EndMacro
  Macro SetGadgetColor(_gadget_, _color_type_, _color_)
    SetGadgetColor_(_gadget_, _color_type_, _color_)
  EndMacro
  ;   Macro SetGadgetData(_gadget_, _value_)
  ;   EndMacro
  Macro SetGadgetFont(_gadget_, _font_id_)
    SetGadgetFont_(_gadget_, _font_id_)
  EndMacro
  Macro SetGadgetItemAttribute(_gadget_, _item_, _attribute_, _value_, _column_=0)
    SetGadgetItemAttribute_(_gadget_, _item_, _attribute_, _value_, _column_)
  EndMacro
  Macro SetGadgetItemColor(_gadget_, _item_, _color_type_, _color_, _column_=0)
    SetGadgetItemColor_(_gadget_, _item_, _color_type_, _color_, _column_)
  EndMacro
  Macro SetGadgetItemData(_gadget_, _item_, _value_)
    SetGadgetItemData_(_gadget_, _item_, _value_)
  EndMacro
  Macro SetGadgetItemImage(_gadget_, _item_, _image_id_)
    SetGadgetItemImage_(_gadget_, _item_, _image_id_)
  EndMacro
  Macro SetGadgetItemState(_gadget_, _position_, _state_)
    SetGadgetItemState_(_gadget_, _position_, _state_)
  EndMacro
  Macro SetGadgetItemText(_gadget_, _position_, _text_)
    SetGadgetItemText_(_gadget_, _position_, _text_)
  EndMacro
  Macro SetGadgetState(_gadget_, _state_)
    SetGadgetState_(_gadget_, _state_)
  EndMacro
  Macro SetGadgetText(_gadget_, _text_)
    SetGadgetText_(_gadget_, _text_)
  EndMacro
  
  Macro GetGadgetAttribute(_gadget_, _attribute_)
    GetGadgetAttribute_(_gadget_, _attribute_)
  EndMacro
  Macro GetGadgetColor(_gadget_)
    GetGadgetColor_(_gadget_)
  EndMacro
  ;   Macro GetGadgetData(_gadget_)
  ;   EndMacro
  ;   Macro GetGadgetFont(_gadget_)
  ;     GetGadgetFont_(_gadget_)
  ;   EndMacro
  Macro GetGadgetItemAttribute(_gadget_, _item_)
    GetGadgetItemAttribute_(_gadget_, _item_)
  EndMacro
  Macro GetGadgetItemColor(_gadget_, _item_)
    GetGadgetItemColor_(_gadget_, _item_)
  EndMacro
  Macro GetGadgetItemData(_gadget_, _item_)
    GetGadgetItemData_(_gadget_, _item_)
  EndMacro
  ;   Macro GetGadgetItemImage(_gadget_, _item_)
  ;   EndMacro
  Macro GetGadgetItemState(_gadget_, _position_)
    GetGadgetItemState_(_gadget_, _position_)
  EndMacro
  Macro GetGadgetItemText(_gadget_, _position_, _column_=0)
    GetGadgetItemText_(_gadget_, _position_, _column_)
  EndMacro
  Macro GetGadgetState(_gadget_)
    GetGadgetState_(_gadget_)
  EndMacro
  Macro GetGadgetText(_gadget_)
    GetGadgetText_(_gadget_)
  EndMacro
  
  Macro AddGadgetColumn(_gadget_, _position_, Title, Width)
    AddGadgetColumn_(_gadget_, _position_, Title, Width)
  EndMacro
  Macro AddGadgetItem(_gadget_, _position_, _text_, _image_id_=0, Flag=0)
    AddGadgetItem_(_gadget_, _position_, _text_, _image_id_, Flag)
  EndMacro
  
  Macro CountGadgetItems(_gadget_)
    CountGadgetItems_(_gadget_)
  EndMacro
  
  Macro ClearGadgetItems(_gadget_)
    ClearGadgetItems_(_gadget_)
  EndMacro
  
  Macro RemoveGadgetItem(_gadget_, _position_)
    RemoveGadgetItem_(_gadget_, _position_)
  EndMacro
  
  ;   Macro ResizeGadget(X,Y,Width,Height)
  ;   EndMacro
  
  Macro EventData() : EventData_() : EndMacro
  Macro EventGadget() : EventGadget_() : EndMacro
  Macro EventType() : EventType_() : EndMacro
  Macro GadgetType(_gadget_) : GadgetType_(_gadget_) : EndMacro


  Macro BindGadgetEvent(_gadget_, _callback_, _eventtype_=#PB_All)
    BindGadgetEvent_(_gadget_, _callback_, _eventtype_)
  EndMacro
  
  Macro TreeGadget(_gadget_, X,Y,Width,Height, Flags=0)
    Tree::Gadget(_gadget_, X,Y,Width,Height, Flags)
  EndMacro
  
  Declare SetGadgetAttribute_(Gadget, Attribute, Value)
  Declare SetGadgetColor_(Gadget, ColorType, Color)
  Declare SetGadgetData_(Gadget, Value)
  Declare SetGadgetFont_(Gadget, FontID)
  Declare SetGadgetItemAttribute_(Gadget, Item, Attribute, Value, Column=0)
  Declare SetGadgetItemColor_(Gadget, Item, ColorType, Color, Column=0)
  Declare SetGadgetItemData_(Gadget, Item, Value)
  Declare SetGadgetItemImage_(Gadget, Item, ImageID)
  Declare SetGadgetItemState_(Gadget, Position, State)
  Declare SetGadgetItemText_(Gadget, Position, Text$, Column=0)
  Declare SetGadgetState_(Gadget, State)
  Declare SetGadgetText_(Gadget, Text$)
  
  Declare GetGadgetAttribute_(Gadget, Attribute)
  Declare GetGadgetColor_(Gadget)
  Declare GetGadgetData_(Gadget)
  Declare GetGadgetFont_(Gadget)
  Declare GetGadgetItemAttribute_(Gadget, Item)
  Declare GetGadgetItemColor_(Gadget, Item)
  Declare GetGadgetItemData_(Gadget, Item)
  Declare GetGadgetItemImage_(Gadget, Item)
  Declare GetGadgetItemState_(Gadget, Position)
  Declare.s GetGadgetItemText_(Gadget, Position, Column=0)
  Declare GetGadgetState_(Gadget)
  Declare.s GetGadgetText_(Gadget)
  
;   Declare AddGadgetColumn_(Gadget, Position, Title$, Width)
  Declare AddGadgetItem_(Gadget, Position, Text$, ImageID=0, Flag=0)
  
  Declare BindGadgetEvent_(Gadget, *Callback, EventType=#PB_All)
;   Declare ResizeGadget_(X,Y,Width,Height)
  Declare CountGadgetItems_(Gadget)
  Declare RemoveGadgetItem_(Gadget, Position)
  Declare ClearGadgetItems_(Gadget)
  Declare GadgetType_(Gadget)
  Declare EventData_()
  Declare EventType_()
  Declare EventGadget_()
EndDeclareModule

Module Gadget
  Macro PB(Function)
    Function
  EndMacro
  
  Procedure EventData_()
    If Tree::*event\data
      ProcedureReturn Tree::*event\data
    Else
      ProcedureReturn PB(EventData)()
    EndIf
  EndProcedure
  
  Procedure EventType_()
    If Tree::*event\type =- 1
      ProcedureReturn PB(EventType)()
    Else
      ProcedureReturn Tree::*event\type
    EndIf
  EndProcedure
  
  Procedure EventGadget_()
    If Tree::*event\widget
      ProcedureReturn Tree::*event\widget
    Else
      ProcedureReturn PB(EventGadget)()
    EndIf
  EndProcedure
  
  Procedure GadgetType_(Gadget)
    Protected *this.Structures::_S_widget
    
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        Protected *data = PB(GetGadgetData)(Gadget)
        If *data
          *this = *data
          ProcedureReturn *this\type
        EndIf
      Else
        ProcedureReturn PB(GadgetType)(Gadget)
      EndIf
    Else
      *this = Gadget
      ProcedureReturn *this\type
    EndIf
  EndProcedure

  Procedure BindGadgetEvent_(Gadget, *Callback, EventType=#PB_All)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::Bind(PB(GetGadgetData)(Gadget), *Callback, EventType)
      Else
        ProcedureReturn PB(BindGadgetEvent)(Gadget, *Callback, EventType)
      EndIf
    Else
      ProcedureReturn Tree::Bind(Gadget, *Callback, EventType)
    EndIf
  EndProcedure
  
  Procedure CountGadgetItems_(Gadget)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::CountItems(PB(GetGadgetData)(Gadget))
      Else
        ProcedureReturn PB(CountGadgetItems)(Gadget)
      EndIf
    Else
      ProcedureReturn Tree::CountItems(Gadget)
    EndIf
  EndProcedure
  
  Procedure ClearGadgetItems_(Gadget)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::ClearItems(PB(GetGadgetData)(Gadget))
      Else
        ProcedureReturn PB(ClearGadgetItems)(Gadget)
      EndIf
    Else
      ProcedureReturn Tree::ClearItems(Gadget)
    EndIf
  EndProcedure
  
  Procedure RemoveGadgetItem_(Gadget, Position)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::RemoveItem(PB(GetGadgetData)(Gadget), Position)
      Else
        ProcedureReturn PB(RemoveGadgetItem)(Gadget, Position)
      EndIf
    Else
      ProcedureReturn Tree::RemoveItem(Gadget, Position)
    EndIf
  EndProcedure
  
  Procedure SetGadgetAttribute_(Gadget, Attribute, Value)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetAttribute(PB(GetGadgetData)(Gadget), Attribute, Value)
      Else
        ProcedureReturn PB(SetGadgetAttribute)(Gadget, Attribute, Value)
      EndIf
    Else
      ProcedureReturn Tree::SetAttribute(Gadget, Attribute, Value)
    EndIf
  EndProcedure
  
  Procedure SetGadgetColor_(Gadget, ColorType, Color)
    ; ProcedureReturn Tree::SetColor(PB(GetGadgetData)(Gadget), ColorType, Color)
  EndProcedure
  Procedure SetGadgetData_(Gadget, Value)
    ; ProcedureReturn Tree::
  EndProcedure
  
  Procedure SetGadgetFont_(Gadget, FontID)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetFont(PB(GetGadgetData)(Gadget), FontID)
      Else
        ProcedureReturn PB(SetGadgetFont)(Gadget, FontID)
      EndIf
    Else
      ProcedureReturn Tree::SetFont(Gadget, FontID)
    EndIf
  EndProcedure
  
  Procedure SetGadgetItemAttribute_(Gadget, Item, Attribute, Value, Column=0)
    ; ProcedureReturn Tree::SetItemAttribute(PB(GetGadgetData)(Gadget), Item, Attribute, Value, Column)
  EndProcedure
  
  Procedure SetGadgetItemColor_(Gadget, Item, ColorType, Color, Column=0)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetItemColor(PB(GetGadgetData)(Gadget), Item, Attribute, Value, Column)
      Else
        ProcedureReturn PB(SetGadgetItemColor)(Gadget, Item, Attribute, Value, Column)
      EndIf
    Else
      ProcedureReturn Tree::SetItemColor(Gadget, Item, Attribute, Value, Column)
    EndIf
  EndProcedure
  
  Procedure SetGadgetItemData_(Gadget, Item, Value)
    ; ProcedureReturn Tree::SetItemData(PB(GetGadgetData)(Gadget), Item, Value)
  EndProcedure
  
  Procedure SetGadgetItemImage_(Gadget, Item, ImageID)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetItemImage(PB(GetGadgetData)(Gadget), Item, ImageID)
      Else
        ProcedureReturn PB(SetGadgetItemImage)(Gadget, Item, ImageID)
      EndIf
    Else
      ProcedureReturn Tree::SetItemImage(Gadget, Item, ImageID)
    EndIf
  EndProcedure
  
  Procedure SetGadgetItemState_(Gadget, Position, State)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetItemState(PB(GetGadgetData)(Gadget), Position, State)
      Else
        ProcedureReturn PB(SetGadgetItemState)(Gadget, Position, State)
      EndIf
    Else
      ProcedureReturn Tree::SetItemState(Gadget, Position, State)
    EndIf
  EndProcedure
  
  Procedure SetGadgetItemText_(Gadget, Position, Text$, Column=0)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetItemText(PB(GetGadgetData)(Gadget), Position, Text$, Column)
      Else
        ProcedureReturn PB(SetGadgetItemText)(Gadget, Position, Text$, Column)
      EndIf
    Else
      ProcedureReturn Tree::SetItemText(Gadget, Position, Text$, Column)
    EndIf
  EndProcedure
  
  Procedure SetGadgetState_(Gadget, State)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetState(PB(GetGadgetData)(Gadget), State)
      Else
        ProcedureReturn PB(SetGadgetState)(Gadget, State)
      EndIf
    Else
      ProcedureReturn Tree::SetState(Gadget, State)
    EndIf
  EndProcedure
  
  Procedure SetGadgetText_(Gadget, Text$)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetText(PB(GetGadgetData)(Gadget), Text$)
      Else
        ProcedureReturn PB(SetGadgetText)(Gadget, Text$)
      EndIf
    Else
      ProcedureReturn Tree::SetText(Gadget, Text$)
    EndIf
  EndProcedure
  
  Procedure GetGadgetAttribute_(Gadget, Attribute)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::GetAttribute(PB(GetGadgetData)(Gadget), Attribute)
      Else
        ProcedureReturn PB(GetGadgetAttribute)(Gadget, Attribute)
      EndIf
    Else
      ProcedureReturn Tree::GetAttribute(Gadget, Attribute)
    EndIf
  EndProcedure
  
  Procedure GetGadgetColor_(Gadget)
    ;     ProcedureReturn Tree::GetColor(PB(GetGadgetData)(Gadget))
  EndProcedure
  Procedure GetGadgetData_(Gadget)
    ;     ProcedureReturn Tree::GetData(PB(GetGadgetData)(Gadget))
  EndProcedure
  
  Procedure GetGadgetFont_(Gadget)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::GetFont(PB(GetGadgetData)(Gadget))
      Else
        ProcedureReturn PB(GetGadgetFont)(Gadget)
      EndIf
    Else
      ProcedureReturn Tree::GetFont(Gadget)
    EndIf
  EndProcedure
  
  Procedure GetGadgetItemAttribute_(Gadget, Item)
    ;     ProcedureReturn Tree::GetItemAttribute(PB(GetGadgetData)(Gadget), Item)
  EndProcedure
  Procedure GetGadgetItemColor_(Gadget, Item)
    ;     ProcedureReturn Tree::GetItemColor(PB(GetGadgetData)(Gadget), Item)
  EndProcedure
  Procedure GetGadgetItemData_(Gadget, Item)
    ;     ProcedureReturn Tree::GetItemData(PB(GetGadgetData)(Gadget), Item)
  EndProcedure
  
  Procedure GetGadgetItemImage_(Gadget, Item)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::GetItemImage(PB(GetGadgetData)(Gadget), Item)
      Else
       ; ProcedureReturn PB(GetGadgetItemImage)(Gadget, Item)
      EndIf
    Else
      ProcedureReturn Tree::GetItemImage(Gadget, Item)
    EndIf
  EndProcedure
  
  Procedure GetGadgetItemState_(Gadget, Position)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::GetItemState(PB(GetGadgetData)(Gadget), Position)
      Else
        ProcedureReturn PB(GetGadgetItemState)(Gadget, Position)
      EndIf
    Else
      ProcedureReturn Tree::GetItemState(Gadget, Position)
    EndIf
  EndProcedure
  
  Procedure.s GetGadgetItemText_(Gadget, Position, Column=0)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::GetItemText(PB(GetGadgetData)(Gadget), Position, Column)
      Else
        ProcedureReturn PB(GetGadgetItemText)(Gadget, Position, Column)
      EndIf
    Else
      ProcedureReturn Tree::GetItemText(Gadget, Position, Column)
    EndIf
  EndProcedure
  
  Procedure GetGadgetState_(Gadget)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::GetState(PB(GetGadgetData)(Gadget))
      Else
        ProcedureReturn PB(GetGadgetState)(Gadget)
      EndIf
    Else
      ProcedureReturn Tree::GetState(Gadget)
    EndIf
  EndProcedure
  
  Procedure.s GetGadgetText_(Gadget)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::GetText(PB(GetGadgetData)(Gadget))
      Else
        ProcedureReturn PB(GetGadgetText)(Gadget)
      EndIf
    Else
      ProcedureReturn Tree::GetText(Gadget)
    EndIf
  EndProcedure
  
  Procedure AddGadgetItem_(Gadget, Position, Text$, ImageID=0, Flag=0)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::AddItem(PB(GetGadgetData)(Gadget), Position, Text$, ImageID, Flag)
      Else
        ProcedureReturn PB(AddGadgetItem)(Gadget, Position, Text$, ImageID, Flag)
      EndIf
    Else
      ProcedureReturn Tree::AddItem(Gadget, Position, Text$, ImageID, Flag)
    EndIf
  EndProcedure
  
;   Procedure AddGadgetColumn_(Gadget, Position, Title$, Width)
;   ;  ProcedureReturn Tree::AddColumn(PB(GetGadgetData)(Gadget), Position, Title$, Width)
;   EndProcedure
  
;   Procedure ResizeGadget_(X,Y,Width,Height)
;   ;  ProcedureReturn Tree::Resize(PB(GetGadgetData)(Gadget),X,Y,Width,Height)
;   EndProcedure
  
EndModule

UseModule Gadget

; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -----v7------------
; EnableXP