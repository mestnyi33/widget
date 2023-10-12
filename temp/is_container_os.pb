;-TOP
; https://www.purebasic.fr/english/viewtopic.php?p=583272&sid=104f4c3a0bcdf5820d9e7162f686e944#p583272
; https://developer.apple.com/documentation/appkit/nsview/1483219-isdescendantof

EnableExplicit

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  Import ""
    PB_Object_EnumerateStart(Object)
    PB_Object_EnumerateNext(Object,*ID.Integer)
    PB_Object_EnumerateAbort(Object)
    PB_Object_Count( Objects )
    
    PB_Object_FreeID           (*Object, DynamicOrArrayID)
    PB_Object_GetObject        (*Object, DynamicOrArrayID)
    PB_Object_GetObjectDirect  (*Object, DynamicOrArrayID)
    PB_Object_IsObject         (*Object, DynamicOrArrayID)
    PB_Object_GetOrAllocateID (*Object, ID)
    PB_Gadget_Objects.i
  EndImport
CompilerElse
  Import ""
    PB_Object_EnumerateStart(Object)
    PB_Object_EnumerateNext(Object,*ID.Integer)
    PB_Object_EnumerateAbort(Object)
    PB_Object_Count( Objects )
    
    PB_Object_FreeID           (*Object, DynamicOrArrayID)
    PB_Object_GetObject        (*Object, DynamicOrArrayID)
    PB_Object_GetObjectDirect  (*Object, DynamicOrArrayID)
    PB_Object_IsObject         (*Object, DynamicOrArrayID)
    PB_Object_GetOrAllocateID  (*Object, ID)
    PB_Gadget_Objects.i
  EndImport
CompilerEndIf

CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Windows
    ;- PB Interne Struktur Gadget Windows
    Structure PB_Gadget
      *Gadget
      *vt.GadgetVT
      UserData.i
      OldCallback.i
      Daten.i[4]
    EndStructure
  CompilerCase #PB_OS_Linux
    ;- PB Interne Struktur Gadget Linux
    Structure PB_Gadget
      *Gadget
      *GadgetContainer
      *vt.GadgetVT
      UserData.i
      Daten.i[4]
    EndStructure
  CompilerCase #PB_OS_MacOS
    ; PB Interne Struktur Gadget MacOS
    Structure PB_Gadget
      *Gadget
      *Container
      *Functions
      UserData.i
      WindowID.i
      Type.l
      Flags.l
    EndStructure
CompilerEndSelect

EnableExplicit

Procedure.i GetContainerGadgets(Gadget, List GadgetList.i())
  Protected r1, gadgetID = -1, *Object.PB_Gadget
  Protected count, containerID = GadgetID(Gadget)
  ClearList( GadgetList() )
  
  If PB_Gadget_Objects And containerID
    PB_Object_EnumerateStart(PB_Gadget_Objects)
    While PB_Object_EnumerateNext(PB_Gadget_Objects, @gadgetID)
      If gadgetID <> -1 And IsGadget(gadgetID)
        *Object = PB_Object_GetObject(PB_Gadget_Objects,gadgetID)
        If *Object And *Object\Gadget <> containerID
          r1 = 0
          CompilerSelect #PB_Compiler_OS
            CompilerCase #PB_OS_Windows
              r1 = Bool(GetAncestor_(*Object\Gadget, #GA_PARENT) = containerID)
              
           CompilerCase #PB_OS_MacOS
              r1 = CocoaMessage(0, *Object\Gadget, "isDescendantOf:", containerID)
              
           CompilerCase #PB_OS_Linux
              Protected widget = gtk_widget_get_parent_(*Object\Gadget)
              r1 = Bool(widget = containerID)
              If Not r1
                widget = gtk_widget_get_parent_(widget)
              EndIf
              r1 = Bool(widget = containerID)
              
          CompilerEndSelect
          If r1
            count + 1
            If AddElement(GadgetList())
              GadgetList() = gadgetID
            EndIf
          EndIf
          
        EndIf
      EndIf
      gadgetID = -1
    Wend
    PB_Object_EnumerateAbort(PB_Gadget_Objects)
  EndIf  
  ProcedureReturn count
EndProcedure

; ****

NewList childGadgets.i()

If OpenWindow(0, 0, 0, 322, 250, "ContainerGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ContainerGadget(0, 8, 8, 306, 133, #PB_Container_Single)
  ;CanvasGadget(0, 8, 8, 306, 133, #PB_Canvas_Container)
  ButtonGadget(3, 10, 15, 80, 24, "Button 1")
  ButtonGadget(5, 95, 15, 80, 24, "Button 2")
  ListViewGadget(9, 10,50,286,70)
  CloseGadgetList()
  ListViewGadget(11, 10, 150,302,70)
  
  If GetContainerGadgets(0, childGadgets())
    ForEach childGadgets()
      Debug "Found child gadget: " + childGadgets() ; found gadgets 3, 5, 9
    Next
    Debug "Count child gadget: " + ListSize(childGadgets.i())
  EndIf
  ClearList(childGadgets())
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 51
; FirstLine = 84
; Folding = ---
; EnableXP