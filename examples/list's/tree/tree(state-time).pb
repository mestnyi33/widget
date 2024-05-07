XIncludeFile "../../../widgets.pbi"
DisableExplicit

UseLib(widget)

LN=1000; количесвто итемов 
Global *w._S_widget

; CompilerCase #PB_OS_MacOS
;   Protected Range.NSRange\location = Len(GetGadgetText(DialogGadget(#Dialog_Main, "log")))
;   CocoaMessage(0, GadgetID(DialogGadget(#Dialog_Main, "log")), "scrollRangeToVisible:@", @Range)
; CompilerEndSelect

Procedure ListViewGadget_(gadget, x,y,width,height,flag=0)
  Protected g = ListViewGadget(gadget, x,y,width,height,flag)
  If gadget =- 1 : gadget = g : EndIf
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Define RowHeight.CGFloat = 20
    ; CocoaMessage(@RowHeight, GadgetID(0), "rowHeight")
    CocoaMessage(0, GadgetID(gadget), "setRowHeight:@", @RowHeight)
  CompilerElse
  CompilerEndIf
  
  ProcedureReturn gadget
EndProcedure

Procedure TreeGadget_(gadget, x,y,width,height,flag=0)
  Protected g = PB(TreeGadget)(gadget, x,y,width,height,flag)
  If gadget =- 1 : gadget = g : EndIf
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Define RowHeight.CGFloat = 20
    ; CocoaMessage(@RowHeight, GadgetID(0), "rowHeight")
    CocoaMessage(0, GadgetID(gadget), "setRowHeight:@", @RowHeight)
  CompilerElse
  CompilerEndIf
  
  ProcedureReturn gadget
EndProcedure

If OpenWindow(0, 100, 50, 530, 700, "ListViewGadget", #PB_Window_SystemMenu)
  TreeGadget_(0, 10, 10, 250, 150, #PB_Tree_NoButtons|#PB_Tree_NoLines)
  ;ListViewGadget_(0, 10, 10, 250, 150)    ;, #PB_ListView_MultiSelect
  
  
  Open(0, 270, 10, 250, 150)
  *w=Tree(0, 0, 250, 150, #__Flag_NoButtons|#__Flag_NoLines)  ; |#__Flag_GridLines|#PB_Flag_MultiSelect
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddItem (*w, -1, "Item "+Str(a), 0)
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - widget add items time count - " + CountItems(*w)
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    SetState(*w, a-1) ; set (beginning with 0) the tenth item as the active one
  Next
  Debug "  "+Str(ElapsedMilliseconds()-time) + " - widget set items state time"
    ;SetState(*w, ln-111) ; set (beginning with 0) the tenth item as the active one
  
  
  ; HideGadget(0, 1)
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0)
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - gadget add items time count - " + CountGadgetItems(0)
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    SetGadgetState(0, a-1) ; set (beginning with 0) the tenth item as the active one
  Next
  Debug "  "+Str(ElapsedMilliseconds()-time) + " - gadget set items state time"
  ; HideGadget(0, 0)
  
  
  Debug " -------- "
  
  ;ListViewGadget_(10, 10, 170, 250, 520, #PB_ListView_MultiSelect)
  TreeGadget_(10, 10, 170, 250, 520);, #PB_Tree_NoButtons|#PB_Tree_NoLines)
  
  Open(0, 270, 170, 250, 520);, "", #__flag_borderless)
  *w=Tree(0, 0, 250, 520, #__Flag_GridLines|#__tree_collapse);|#__Tree_NoButtons|#__Tree_NoLines)  ; |#PB_Flag_MultiSelect
                                            ;
                                            ;-
                                            ;
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    ;; AddItem (*w, -1, "Item "+Str(a), 0)
    If a%5 ;Or i%3=0
      AddItem(*w, -1, "Tree_"+Str(a), -1, 1) 
    Else
      AddItem(*w, -1, "Tree_"+Str(a), -1, 0) 
    EndIf
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - widget add items time count - " + CountItems(*w)
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    SetItemState(*w, a, #PB_Tree_Expanded) ; set (beginning with 0) the tenth item as the active one
    SetItemState(*w, a, #PB_Tree_Selected) ; set (beginning with 0) the tenth item as the active one
  Next
  Debug "  "+Str(ElapsedMilliseconds()-time) + " - widget set items state time"
  
  
  ; HideGadget(0, 1)
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    If a%5 
      AddGadgetItem (10, -1, "Item "+Str(a), 0,1)
    Else
      AddGadgetItem (10, -1, "Item "+Str(a), 0,0)
    EndIf
  Next
  Debug " "+Str(ElapsedMilliseconds()-time) + " - gadget add items time count - " + CountGadgetItems(10)
  
  a=0
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    SetGadgetItemState(10, a, #PB_Tree_Expanded) ; set (beginning with 0) the tenth item as the active one
    SetGadgetItemState(10, a, #PB_Tree_Selected) ; set (beginning with 0) the tenth item as the active one
  Next
  Debug "  "+Str(ElapsedMilliseconds()-time) + " - gadget set items state time"
  ; HideGadget(0, 0)
  
  Debug " -------- "
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 55
; FirstLine = 52
; Folding = --
; EnableXP