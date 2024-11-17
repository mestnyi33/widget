XIncludeFile "../../../widgets.pbi"
 UseWidgets( )

LN=300;0; количесвто итемов 
Global *w._S_widget

If OpenWindow(0, 100, 50, 530, 700, "ListView", #PB_Window_SystemMenu)
  EditorGadget(0, 10, 10, 250, 680)    ;, #PB_ListView_MultiSelect
  
  Open(0, 270, 10, 250, 680);, "", #__flag_borderless)
  *w=EditorWidget(0, 0, 250, 680, #__Flag_GridLines)  ; |#PB_Flag_MultiSelect
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN : AddItem (*w, -1, "Item_"+Str(a), 0) : Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - widget add items time count - " + CountItems(*w)
  
  ; HideGadget(0, 1)
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN : AddGadgetItem (0, -1, "Item_"+Str(a), 0) : Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - gadget add items time count - " + CountGadgetItems(0)
  
  
  
;   Debug ""
;   a=0
;   Define time = ElapsedMilliseconds()
;   For a = 0 To LN : SetItemData(*w, a,a) : Next
;   For a = 0 To LN : SetItemTextWidget(*w, a,Str(a)) : Next
;   Debug " "+Str(ElapsedMilliseconds()-time) + " - widget set items time - " + CountItems(*w)
;   
;   a=0
;   Define time = ElapsedMilliseconds()
;   For a = 0 To LN : SetGadgetItemData(0, a,a) : Next
;   For a = 0 To LN : SetGadgetItemTextWidget(0, a,Str(a)) : Next
;   Debug " "+Str(ElapsedMilliseconds()-time) + " - gadget set items time - " + CountGadgetItems(0)
  
  
  Debug ""
  Define time = ElapsedMilliseconds()
  count = CountItems(*w) : For a = 0 To count : RemoveItem(*w, a) : Next : Debug Str(ElapsedMilliseconds()-time) + " - remove widget items time count - " + CountItems(*w)
  
  Define time = ElapsedMilliseconds()
  count = CountGadgetItems(0) : For a = 0 To count : RemoveGadgetItem(0, a) : Next : Debug Str(ElapsedMilliseconds()-time) + " - remove gadget items time count - " + CountGadgetItems(0)
  
;   Debug ""
;   Define item = 3
;   Debug ""+GetItemData(*w, item) +" "+ GetItemTextWidget(*w, item) + " - get widget item 3"
;   Debug ""+GetGadgetItemData(0, item) +" "+ GetGadgetItemTextWidget(0, item) +" - get gadget item 3"
;   
;   item = 7
;   SetItemData(*w, item, 555)
;   SetGadgetItemData(0, item, 555)
;   
;   Debug ""+GetItemData(*w, item) +" "+ GetItemTextWidget(*w, item) + " - get widget item 7"
;   Debug ""+GetGadgetItemData(0, item) +" "+ GetGadgetItemTextWidget(0, item) +" - get gadget item 7"
;   
; ;   Debug ""
; ;   Define time = ElapsedMilliseconds()
; ;   count = CountItems(*w) : For a = count To 0 Step - 1 : RemoveItem(*w, a) : Next : Debug Str(ElapsedMilliseconds()-time) + " - remove widget items time count - " + CountItems(*w)
; ;   
; ;   Define time = ElapsedMilliseconds()
; ;   count = CountGadgetItems(0) : For a = count To 0 Step - 1 : RemoveGadgetItem(0, a) : Next : Debug Str(ElapsedMilliseconds()-time) + " - remove gadget items time count - " + CountGadgetItems(0)
;   
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 47
; FirstLine = 45
; Folding = -
; EnableXP