XIncludeFile "../../../widgets.pbi"
;XIncludeFile "../empty.pb"
UseLib(widget)

Define gLN=5000;0      ;0; количесвто итемов 
Define LN=5000;0;0
Global *w._S_widget

Procedure TreeGadget_(gadget, x,y,width,height,flag=0)
  Protected g = PB(TreeGadget)(gadget, x,y,width,height,flag)
  If gadget =- 1 : gadget = g : EndIf
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Define RowHeight.CGFloat = 19
    ; CocoaMessage(@RowHeight, GadgetID(0), "rowHeight")
    CocoaMessage(0, GadgetID(gadget), "setRowHeight:@", @RowHeight)
  CompilerElse
  CompilerEndIf
  
  ProcedureReturn gadget
EndProcedure

If OpenWindow(0, 100, 50, 530, 700, "TreeGadget", #PB_Window_SystemMenu)
  Open(0, 270, 10, 250, 680);, "", #__flag_borderless)
  *w=Tree(0, 0, 250, 680, #__Flag_GridLines|#__Flag_NoButtons|#__Flag_NoLines)  ; |#PB_Flag_MultiSelect
  
  TreeGadget_(0, 10, 10, 250, 680, #PB_Tree_NoButtons|#PB_Tree_NoLines)    ;, #PB_ListView_MultiSelect
  
  
  Define a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN : AddItem (*w, -1, "Item_"+Str(a), 0) : Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - widget add items time count - " + CountItems(*w)
  
  ; HideGadget(0, 1)
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To gLN : AddGadgetItem (0, -1, "Item_"+Str(a), 0) : Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - gadget add items time count - " + CountGadgetItems(0)
  
  SetGadgetState(0, 2)
  SetState(*w, 2)
  
;   Debug ""
;   a=0
;   Define time = ElapsedMilliseconds()
;   For a = 0 To LN : SetItemData(*w, a,a) : Next
;   For a = 0 To LN : SetItemText(*w, a,Str(a)) : Next
;   Debug " "+Str(ElapsedMilliseconds()-time) + " - widget set items time - " + CountItems(*w)
;   
;   a=0
;   Define time = ElapsedMilliseconds()
;   For a = 0 To gLN : SetGadgetItemData(0, a,a) : Next
;   For a = 0 To gLN : SetGadgetItemText(0, a,Str(a)) : Next
;   Debug " "+Str(ElapsedMilliseconds()-time) + " - gadget set items time - " + CountGadgetItems(0)
  
  
  Debug ""
  Define time = ElapsedMilliseconds()
  Define count = CountItems(*w) : For a = 0 To count : RemoveItem(*w, a) : Next : Debug Str(ElapsedMilliseconds()-time) + " - remove widget items time count - " + CountItems(*w)
  
  Define time = ElapsedMilliseconds()
  count = CountGadgetItems(0) : For a = 0 To count : RemoveGadgetItem(0, a) : Next : Debug Str(ElapsedMilliseconds()-time) + " - remove gadget items time count - " + CountGadgetItems(0)
  
;   Debug ""
;   Define item = 3
;   Debug ""+GetItemData(*w, item) +" "+ GetItemText(*w, item) + " - get widget item 3"
;   Debug ""+GetGadgetItemData(0, item) +" "+ GetGadgetItemText(0, item) +" - get gadget item 3"
;   
;   item = 7
;   SetItemData(*w, item, 555)
;   SetGadgetItemData(0, item, 555)
;   
;   Debug ""+GetItemData(*w, item) +" "+ GetItemText(*w, item) + " - get widget item 7"
;   Debug ""+GetGadgetItemData(0, item) +" "+ GetGadgetItemText(0, item) +" - get gadget item 7"
;   
; ;   Debug ""
; ;   Define time = ElapsedMilliseconds()
; ;   Define count = CountItems(*w) : For a = count To 0 Step - 1 : RemoveItem(*w, a) : Next : Debug Str(ElapsedMilliseconds()-time) + " - remove widget items time count - " + CountItems(*w)
; ;   
; ;   Define time = ElapsedMilliseconds()
; ;   count = CountGadgetItems(0) : For a = count To 0 Step - 1 : RemoveGadgetItem(0, a) : Next : Debug Str(ElapsedMilliseconds()-time) + " - remove gadget items time count - " + CountGadgetItems(0)
  
  
  ;Redraw(root())
  Repeat : Define Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP