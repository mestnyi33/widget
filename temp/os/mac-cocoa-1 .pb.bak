;-TOP

; Comment : MacOS SetGadgetCallback and SetGadgetNotification (Base by Shardik)
; Author  : mk-soft
; Version : v1.02.0
; Create  : 28.02.2021
; Update  : 06.03.2021

; Link Base of Shardik: https://www.purebasic.fr/english/viewtopic.php?f=19&t=65891&p=492568#p492568s

EnableExplicit

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
  
  ImportC ""
    sel_registerName(str.p-utf8)
    class_addMethod(class, selector, imp, types.p-utf8)
    class_getInstanceMethod(class, selector)
  EndImport
  
  ; *** Required variables ***
  
  Global notificationCenter = CocoaMessage(0, 0, "NSNotificationCenter defaultCenter")
  Global appDelegate = CocoaMessage(0, CocoaMessage(0, 0, "NSApplication sharedApplication"), "delegate")
  Global delegateClass = CocoaMessage(0, appDelegate, "class")
  
  Structure udtGadgetCallback
    Window.i
    Gadget.i
    refCount.i
  EndStructure  
  
  Structure udtWindowNotification
    Window.i
    refCount.i
  EndStructure  
  
  Structure udtGadgetNotification
    Window.i
    Gadget.i
    refCount.i
  EndStructure  
  
  Global NewMap mapGadgetCallback.udtGadgetCallback()
  Global NewMap mapWindowNotification.udtWindowNotification()
  Global NewMap mapGadgetNotification.udtGadgetNotification()
  
  ; *** Callback ***
  
  Procedure SetGadgetCallback(Window, Gadget, *Callback, Method.s, PlaceholderList.s = "")
    Protected key.s, selector
    ; Add gadget to map gadget callback
    key = Str(GadgetID(Gadget))
    If Not FindMapElement(mapGadgetCallback(), key) 
      AddMapElement(mapGadgetCallback(), key)
      mapGadgetCallback()\Window = Window
      mapGadgetCallback()\Gadget = Gadget
    EndIf
    mapGadgetCallback()\refCount + 1
    ; Add method to delegateClass
    If Not Bool(PlaceholderList)
      PlaceholderList = "v@:" + LSet("@", CountString(Method, ":"), "@")
    EndIf
    selector = sel_registerName_(Method)
    If Not class_getInstanceMethod(delegateClass, selector)
      class_addMethod_(delegateClass, selector, *Callback, PlaceholderList)
    EndIf
    ; Add gadget to appDelegate
    CocoaMessage(0, GadgetID(Gadget), "setDelegate:", appDelegate)
  EndProcedure
  
  ; *** Notification ***
  
  Procedure SetWindowNotification(Window, *Callback, Notification.s)
    Protected selector, key.s
    ; Add Window to map Window notification
    key = Str(WindowID(Window))
    If Not FindMapElement(mapWindowNotification(), key) 
      AddMapElement(mapWindowNotification(), key)
      mapWindowNotification()\Window = Window
      mapWindowNotification()\Window = Window
    EndIf
    mapWindowNotification()\refCount + 1
    ; Add new callback method to delegateClass
    selector = sel_registerName("windowNotificationCB_" + Str(*Callback))
    If Not class_getInstanceMethod(delegateClass, selector)
      class_addMethod(delegateClass, selector, *Callback, "v@:@")
    EndIf
    ; Add Window to notification center
    CocoaMessage(0, notificationCenter,
                 "addObserver:", appDelegate, 
                 "selector:", selector,
                 "name:$", @Notification,
                 "object:", WindowID(Window))
  
  EndProcedure
  
  ; ----
  
  Procedure RemoveWindowNotification(Window, *Callback, Notification.s)
    If FindMapElement(mapWindowNotification(), Str(WindowID(Window)))
      CocoaMessage(0, notificationCenter,
                   "removeObserver:", appDelegate,
                   "name:$", @Notification,
                   "object:", WindowID(Window))
      mapWindowNotification()\refCount - 1
      If mapWindowNotification()\refCount <= 0
        DeleteMapElement(mapWindowNotification())
      EndIf
    EndIf
    
  EndProcedure
  
  ; ----
  
  Procedure SetGadgetNotification(Window, Gadget, *Callback, Notification.s)
    Protected selector, key.s
    ; Add gadget to map gadget notification
    key = Str(GadgetID(Gadget))
    If Not FindMapElement(mapGadgetNotification(), key) 
      AddMapElement(mapGadgetNotification(), key)
      mapGadgetNotification()\Window = Window
      mapGadgetNotification()\Gadget = Gadget
    EndIf
    mapGadgetNotification()\refCount + 1
    ; Add new callback method to delegateClass
    selector = sel_registerName("gadgetNotificationCB_" + Str(*Callback))
    If Not class_getInstanceMethod(delegateClass, selector)
      class_addMethod(delegateClass, selector, *Callback, "v@:@")
    EndIf
    ; Add gadget to notification center
    CocoaMessage(0, notificationCenter,
                 "addObserver:", appDelegate, 
                 "selector:", selector,
                 "name:$", @Notification,
                 "object:", GadgetID(Gadget))
  
  EndProcedure
  
  ; ----
  
  Procedure RemoveGadgetNotification(Window, Gadget, *Callback, Notification.s)
    If FindMapElement(mapGadgetNotification(), Str(GadgetID(Gadget)))
      CocoaMessage(0, notificationCenter,
                   "removeObserver:", appDelegate,
                   "name:$", @Notification,
                   "object:", GadgetID(Gadget))
      mapGadgetNotification()\refCount - 1
      If mapGadgetNotification()\refCount <= 0
        DeleteMapElement(mapGadgetNotification())
      EndIf
    EndIf
    
  EndProcedure
  
  ; *** Cocoa String Helper ***
  
  Macro CocoaString(NSString)
    PeekS(CocoaMessage(0, NSString, "UTF8String"), -1, #PB_UTF8)
  EndMacro

CompilerEndIf

; ********


;-TOP

; Comment : MacOS SetGadgetCallback and SetGadgetNotification (Base by Shardik)

; EnableExplicit
; 
; ;IncludeFile "OSX_GadgetCallback.pb"
; 
; ; ********
; 
; ;- Example
; 
; CompilerIf #PB_Compiler_IsMainFile
;   
;   ProcedureC ColumnHeaderClickCallback(Object.I, Selector.I, TableView.I, TableColumn.I)
;     Protected ClickedHeaderColumn.I
;     
;     ;Debug "Tag = " + CocoaMessage(0, TableView, "tag")
;     
;     If Not FindMapElement(mapGadgetCallback(), Str(TableView))
;       ProcedureReturn 0
;     EndIf
;     
;     ClickedHeaderColumn = Val(CocoaString(CocoaMessage(0, TableColumn, "identifier")))
;     PostEvent(#PB_Event_Gadget,
;               mapGadgetCallback()\Window,
;               mapGadgetCallback()\Gadget,
;               #PB_EventType_TitleChange,
;               ClickedHeaderColumn + 1)
;   EndProcedure
;   
;   ProcedureC SelectionDidChangeCallback(Object.I, Selector.I, Notification.I)
;     Protected Notify.s, GadgetID, Window, Gadget
;     
;     GadgetID = CocoaMessage(0, Notification, "object")
;     
;     ;Debug "Tag = " + CocoaMessage(0, GadgetID, "tag")
;     
;     Notify.s = CocoaString(CocoaMessage(0, Notification, "name"))
;     
;     If FindMapElement(mapGadgetNotification(), Str(GadgetID))
;       Window = mapGadgetNotification()\Window
;       Gadget = mapGadgetNotification()\Gadget
;       
;       Select Notify
;         Case "NSTableViewSelectionDidChangeNotification"
;           PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_Change)
;           
;       EndSelect
;     EndIf
;     
;   EndProcedure
;   
;   ; ----
;   
;   Enumeration
;     #zero
;     #windows_nb
;     #list1_nb
;     #list2_nb
;   EndEnumeration
;   
;   #Title_column1$ = "Name"
;   #Title_column2$ = "Address"
;   
;   Define GadgetID.I
;   
;   OpenWindow(#windows_nb, 0, 0, 870, 110, "Detect left click on header cell",
;              #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;   
;   ListIconGadget(#list1_nb, 10, 10, 420, WindowHeight(#windows_nb) - 20,
;                  #Title_column1$, 110, #PB_ListIcon_FullRowSelect)
;   AddGadgetColumn(#list1_nb, 1, #Title_column2$, 300)
;   AddGadgetItem(#list1_nb, -1, "Harry Rannit" + #LF$ +
;                                "12 Parliament Way, Battle Street, By the Bay")
;   AddGadgetItem(#list1_nb, -1, "Ginger Brokeit"+ #LF$ +
;                                "130 PureBasic Road, BigTown, CodeCity")
;   AddGadgetItem(#list1_nb, -1, "Didi Foundit"+ #LF$ +
;                                "321 Logo Drive, Mouse House, Downtown")
;   
;   ListIconGadget(#list2_nb, 440, 10, 420, WindowHeight(#windows_nb) - 20,
;                  #Title_column1$, 110, #PB_ListIcon_FullRowSelect)
;   AddGadgetColumn(#list2_nb, 1, #Title_column2$, 300)
;   AddGadgetItem(#list2_nb, -1, "Harry Rannit" + #LF$ +
;                                "12 Parliament Way, Battle Street, By the Bay")
;   AddGadgetItem(#list2_nb, -1, "Ginger Brokeit"+ #LF$ +
;                                "130 PureBasic Road, BigTown, CodeCity")
;   AddGadgetItem(#list2_nb, -1, "Didi Foundit"+ #LF$ +
;                                "321 Logo Drive, Mouse House, Downtown")
;   
;   SetGadgetCallback(#windows_nb, #list1_nb, @ColumnHeaderClickCallback(), "tableView:didClickTableColumn:")
;   SetGadgetCallback(#windows_nb, #list2_nb, @ColumnHeaderClickCallback(), "tableView:didClickTableColumn:")
;   SetGadgetNotification(#windows_nb, #list1_nb, @SelectionDidChangeCallback(), "NSTableViewSelectionDidChangeNotification")
;   SetGadgetNotification(#windows_nb, #list2_nb, @SelectionDidChangeCallback(), "NSTableViewSelectionDidChangeNotification")
;   
;   Repeat
;     Select WaitWindowEvent()
;       Case #PB_Event_CloseWindow
;         Break
;       Case #PB_Event_Gadget
;         GadgetID = EventGadget()
;         
;         Select GadgetID
;           Case #list1_nb, #list2_nb
;             Select EventType()
;               Case #PB_EventType_LeftClick
;                 ; Debug "Left click on row " + Str(GetGadgetState(GadgetID)) + ", Gadget " + Str(GadgetID)
;                 
;               Case #PB_EventType_TitleChange
;                   Debug "Left click on header of column " + Str(EventData() - 1) + ", Gadget " + Str(GadgetID)
;                 
;               Case #PB_EventType_Change
;                 Debug "Selected row changed:" + Str(GetGadgetState(GadgetID)) + ", Gadget " + Str(GadgetID)
;                 
;             EndSelect
;         EndSelect
;     EndSelect
;   ForEver
;   
; CompilerEndIf
; 

;-TOP

;IncludeFile "OSX_GadgetCallback.pb"

; ********

#wndid=1 : #gadget1=1

Procedure UpdateGadgetInfo()
  Static cnt
  cnt + 1
  AddGadgetItem(#gadget1,-1,"Update line " + cnt)
EndProcedure

; *** Window Callback ***

ProcedureC WindowNotificationCB(Object, Selector, Notification)
  Protected Notify.s, WindowID, Window
      
    WindowID = CocoaMessage(0, Notification, "object")
    
    If FindMapElement(mapWindowNotification(), Str(WindowID))
      Window = mapWindowNotification()\Window
      If Window = #wndid
        Notify.s = CocoaString(CocoaMessage(0, Notification, "name"))
        Select Notify
          Case "NSWindowDidResizeNotification"
            ResizeGadget(#gadget1, 10, 10, WindowWidth(#wndid) - 20, WindowHeight(#wndid) - 20)
          Case "NSWindowDidEndLiveResizeNotification"
            UpdateGadgetInfo()
        EndSelect
      EndIf
    EndIf
    
EndProcedure

; ----

If OpenWindow(#wndid, 100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_SizeGadget)
  ListViewGadget(#gadget1,10,10,175,240)
  UpdateGadgetInfo()
  
  SetWindowNotification(#wndid, @WindowNotificationCB(), "NSWindowDidResizeNotification")
  SetWindowNotification(#wndid, @WindowNotificationCB(), "NSWindowDidEndLiveResizeNotification")
  
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        Break
      Case #PB_Event_SizeWindow
        ;Debug "Size"
    EndSelect
  ForEver
  
  RemoveWindowNotification(#wndid, @WindowNotificationCB(), "NSWindowDidResizeNotification")
  RemoveWindowNotification(#wndid, @WindowNotificationCB(), "NSWindowDidEndLiveResizeNotification")
  
EndIf


; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -----
; EnableXP