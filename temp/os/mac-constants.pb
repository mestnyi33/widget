; CheckBoxGadget(
;  Flags To modify the gadget behavior. It can be a combination of the following constants:
;  2 = #PB_CheckBox_Center     : Centers the text.
;  1 = #PB_CheckBox_Right      : Aligns the text To right.
;  4 = #PB_CheckBox_ThreeState : Create a checkbox that can have a third "in between" state.
;                           : The #PB_CheckBox_ThreeState flag can be used For a checkbox that represents the state of multiple items. 
;                           : The "in between" state can then be used To indicate that the setting is Not the same For all items. 
;                           : By clicking on the checkbox, the user can bring it back To either the "on" Or "off" state To apply this To all the items.
;                           : Therefore the "in between" state can only be set by the program via SetGadgetState() And Not by the user by clicking on the checkbox.

; SetGadgetState(#Gadget, State)
;  Change the state of the checkbox. The following values are possible:
;  1 = #PB_Checkbox_Checked  : The check mark is set.
;  0 = #PB_Checkbox_Unchecked: The check mark is Not set.
; -1 = #PB_Checkbox_Inbetween: The "in between" state is set. (Only For #PB_CheckBox_ThreeState checkboxes)

; IDE Options = PureBasic 5.72 (MacOS X - x64)
; EnableXP