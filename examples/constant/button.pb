
EnumerationBinary 
  #__text_left
  #__text_top
  #__text_right
  #__text_bottom
  #__text_center
EndEnumeration


#__button_toggle       = 1<<1
#__toolBar_toggle      = 1<<1

#__button_default      = 1<<1
#__checkbox_threestate = 1<<1

#__button_multiLine    = 1<<1

#__button_left         = #__text_left
#__checkBox_left       = #__text_left

#__button_right        = #__text_right
#__checkBox_right      = #__text_right

#__button_center       = #__text_center
#__checkBox_center     = #__text_center

;                              ; m       ; l       ; w
Debug  #PB_ToolBar_Normal      ; 0       ; 0       ; 0
Debug  #PB_ToolBar_Toggle      ; 1       ; 1       ; 1
Debug ""
Debug  #PB_Button_Image        ; 1       ; 1       ; 1
Debug  #PB_Button_PressedImage ; 2       ; 2       ; 2
Debug ""
Debug  #PB_Button_Right        ; 1       ; 1       ; 512
Debug  #PB_Button_Left         ; 2       ; 2       ; 256
Debug  #PB_Button_Toggle       ; 4       ; 4       ; 4099
Debug  #PB_Button_Default      ; 8       ; 8       ; 1
Debug  #PB_Button_MultiLine    ; 16      ; 16      ; 8192
Debug ""
Debug  #PB_CheckBox_Right      ; 1                 ; 512
Debug  #PB_CheckBox_Center     ; 2                 ; 768
Debug  #PB_CheckBox_ThreeState ; 4                 ; 5
Debug ""
Debug  #PB_Tree_ThreeState     ; 8                 ; 65536
Debug  #PB_ListIcon_ThreeState ; 8                 ; 64

; UseGUIelement()

; ButtonGadget(
; Flags (optional)	A combination (using the bitwise Or operator '|') of the following constants:
;   #PB_Button_Right     : Aligns the button text at the right. (Not supported on Mac OSX)
;   #PB_Button_Left      : Aligns the button text at the left. (Not supported on Mac OSX)
;   #PB_Button_Default   : Makes the button look As If it is the Default button in the window (on OS X, the height of the button needs To be 25).
;   #PB_Button_MultiLine : If the text is too long, it will be displayed on several lines. (Not supported on OSX)
;   #PB_Button_Toggle    : Creates a toggle button: one click pushes it, another will release it.


; Remarks
; 
; A 'mini help' can be added To this gadget using GadgetToolTip(). 
; 
; The following functions can be used To control the gadget: 
; 
; - SetGadgetText(): Changes the text of the ButtonGadget. 
; - GetGadgetText(): Returns the text of the ButtonGadget. 
; - SetGadgetState() 
;      #PB_Button_Toggle : Used with buttons to set the actual state (1 = toggled, 0 = normal).
; - GetGadgetState() 
;      #PB_Button_Toggle : Used with buttons to get the actual state of the button (1 = toggled, 0 = normal).

; ButtonImageGadget(
; Flags (optional)	This parameter can be 
;   #PB_Button_Toggle To create a toggle-button (one which has an on/off state). A push-button is created by Default.



; Remarks
; 
; A 'mini help' can be added To this gadget using GadgetToolTip(). 
; 
; The following functions can be used To control the gadget: 
; 
; - SetGadgetImage(): Changes the image of the ButtonImageGadget. 
; - GetGadgetImage(): Returns the image of the ButtonImageGadget. 
; - GetGadgetState()  
;      #PB_Button_Toggle : can be used to get the toggle state of the gadget. 
; - SetGadgetState() 
;      #PB_Button_Toggle : can be used to set the toggle state of the gadget. 
; - GetGadgetAttribute() : with the following values
;      #PB_Button_Image       : Get the displayed image ID, e.g. ImageID(#MyImage).
;      #PB_Button_PressedImage: Get the displayed image ID when the button is pressed, e.g. ImageID(#MyImagePressed).
; - SetGadgetAttribute() : with the following values
;      #PB_Button_Image       : Set the displayed image.
;      #PB_Button_PressedImage: Set the image displayed when the button is pressed.

; CheckBoxGadget(
; Flags (optional)	Flags To modify the gadget behavior. It can be a combination of the following constants:
;   #PB_CheckBox_Right      : Aligns the text To right.
;   #PB_CheckBox_Center     : Centers the text.
;   #PB_CheckBox_ThreeState : Create a checkbox that can have a third "in between" state.
;                           : The flag can be used For a checkbox that represents the state of multiple items.
;                           : The "in between" state can then be used To indicate that the setting is Not the same For all items. 
;                           : By clicking on the checkbox, the user can bring it back To either the "on" Or "off" state To apply this To all the items.
;                           : Therefore the "in between" state can only be set by the program via SetGadgetState() And Not by the user by clicking on the checkbox.; A 'mini help' can be added To this gadget using GadgetToolTip(). 
; 
; A 'mini help' can be added To this gadget using GadgetToolTip(). 
; 
; - GetGadgetState() can be used To get the current gadget state. 
; - SetGadgetState() can be used To change the gadget state. 

; IDE Options = PureBasic 5.72 (Windows - x64)
; CursorPosition = 49
; FirstLine = 27
; EnableXP