

; Based on code by TS-Soft and Hallodri
;-Planned usage in UserLibs:
; IncludeFile #pb_compiler_home+"/TailBite/Addons/TB_GadgetExtension.pb" (naturally user will change to location of their TB install)

; Prototype.i PB_Object_GetOrAllocateID(Objects.i,ID.i)
; Prototype.i PB_Gadget_RegisterGadget(ID.i,*Gadget.i,hwnd.i,*GadgetVT.l)
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  Import "";thanks to freak for pointing this out
CompilerElse
  ImportC ""
CompilerEndIf
  PB_Object_GetOrAllocateID(Objects.i,ID.i)
  PB_Gadget_RegisterGadget(ID.i,*Gadget,hwnd.i,*GadgetVT)
  PB_Object_GetThreadMemory(MemoryID)
  PB_Gadget_Globals.i
  PB_Gadget_Objects.i
EndImport

Enumeration
  #PB_GadgetType_Unknown
  #PB_GadgetType_Button
  #PB_GadgetType_String
  #PB_GadgetType_Text
  #PB_GadgetType_CheckBox
  #PB_GadgetType_Option
  #PB_GadgetType_ListView
  #PB_GadgetType_Frame3D
  #PB_GadgetType_ComboBox
  #PB_GadgetType_Image
  #PB_GadgetType_HyperLink
  #PB_GadgetType_Container
  #PB_GadgetType_ListIcon
  #PB_GadgetType_IPAddress
  #PB_GadgetType_ProgressBar
  #PB_GadgetType_ScrollBar
  #PB_GadgetType_ScrollArea
  #PB_GadgetType_TrackBar
  #PB_GadgetType_Web
  #PB_GadgetType_ButtonImage
  #PB_GadgetType_Calendar
  #PB_GadgetType_Date
  #PB_GadgetType_Editor
  #PB_GadgetType_ExplorerList
  #PB_GadgetType_ExplorerTree
  #PB_GadgetType_ExplorerCombo
  #PB_GadgetType_Spin
  #PB_GadgetType_Tree
  #PB_GadgetType_Panel
  #PB_GadgetType_Splitter
  #PB_GadgetType_MDI
  #PB_GadgetType_Scintilla
  #PB_GadgetType_LastEnum
EndEnumeration

Structure PB_GadgetVT
  GadgetType.l   
  SizeOf.l       
  GadgetCallback.i
  FreeGadget.i
  GetGadgetState.i
  SetGadgetState.i
  GetGadgetText.i
  SetGadgetText.i
  AddGadgetItem2.i
  AddGadgetItem3.i
  RemoveGadgetItem.i
  ClearGadgetItemList.i
  ResizeGadget.i
  CountGadgetItems.i
  GetGadgetItemState.i
  SetGadgetItemState.i
  GetGadgetItemText.i
  SetGadgetItemText.i
  OpenGadgetList2.i
  GadgetX.i
  GadgetY.i
  GadgetWidth.i
  GadgetHeight.i
  HideGadget.i
  AddGadgetColumn.i
  RemoveGadgetColumn.i
  GetGadgetAttribute.i
  SetGadgetAttribute.i
  GetGadgetItemAttribute2.i
  SetGadgetItemAttribute2.i
  SetGadgetColor.i
  GetGadgetColor.i
  SetGadgetItemColor2.i
  GetGadgetItemColor2.i
  SetGadgetItemData.i
  GetGadgetItemData.i
EndStructure

CompilerIf Defined(PB_Gadget, #PB_Structure) = #False
Structure PB_Gadget
  Gadget.i
  *VT.PB_GadgetVT
  UserData.i
  OldCallback.i
  Daten.l[4]
EndStructure
CompilerEndIf

;GetGadgetParent                                                   
;                                                                   
;                  returns : Parent Handle                       
; 
Procedure TB_GetGadgetParent();Get the parent hwnd that your gadget must be a child to (eg the window, a panelgadget, etc)
  *Globals = PB_Object_GetThreadMemory(PB_Gadget_Globals)
  ProcedureReturn PeekI(*Globals)
EndProcedure

;TailBite Directive:
;--TB_ADD_PBLIB_Window

;RegisterGadget                                                     
;                hwnd.l              ; Handle des Controls         
;                ID.l                ; PB_ID                       
;                DestroyProc.l=0     ; OPTIONAL Proc zum aufraeumen
;                *vt.PB_GadgetVT = 0 ; OPTIONAL Gadget VT           
;                                                                   
;                Rueckgabe  :  wenn ID = -1 / PB_Any =  PB_ID       
;                              snst Handle des Controls             
Procedure TB_RegisterGadget(ID.i, hwnd.i, *vttemp.PB_GadgetVT);Register a gadget under the PB gadgets system
  ;Protected PB_Object_GetOrAllocateID.PB_Object_GetOrAllocateID
  ;Protected PB_Gadget_RegisterGadget.PB_Gadget_RegisterGadget
  ;Protected PB_Gadget_Objects.i
  Protected *Gadget.PB_Gadget;, *Gadget_Info.Gadget_Info
  Protected OldCallback.i
  Protected *vt.PB_GadgetVT
 
  If ((hwnd = 0) Or (id < #PB_Any))
    ProcedureReturn 0
  EndIf
 
  *vt = AllocateMemory(SizeOf(PB_GadgetVT))
  If *vttemp <> 0
    CopyMemory(*vttemp,*vt,SizeOf(PB_GadgetVT))
  EndIf
 
  *Gadget = PB_Object_GetOrAllocateID(PB_Gadget_Objects, ID)
  hwnd    = PB_Gadget_RegisterGadget(ID, *Gadget,hwnd,*vt)
   
 
  ProcedureReturn hwnd
EndProcedure


; IDE Options = PureBasic 4.30 (Windows - x64)
; CursorPosition = 115
; FirstLine = 95
; Folding = -
; EnableUnicode
; EnableXP