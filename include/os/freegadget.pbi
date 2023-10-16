;-TOP

; Comment : Module SetFreeGadgetCallback
; Author  : mk-soft
; Version : v1.01.4
; Create  : 14.10.2023
; Update  : 15.10.2023
; Link    : https://www.purebasic.fr/english/viewtopic.php?t=82665

; Description :
; - Callback Procedure MyFreeGadget(Gadget)

DeclareModule FreeGadgetEx
  
  Declare SetFreeGadgetCallback(Gadget, *Callback)
  
EndDeclareModule

Module FreeGadgetEx
  
  EnableExplicit
  
  CompilerIf #PB_Compiler_Version > 603
    CompilerWarning "SDK Gadget.h: Check GadgetStructure and GadgetVT!"  
  CompilerEndIf
  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_MacOS
      Structure PB_MacOS_GadgetStructure
        *gadget
        *container
        *vt
        UserData.i
        Window.i
        Type.i
        Flags.i
      EndStructure
      
    CompilerCase #PB_OS_Linux
      
      Structure PB_Linux_GadgetVT
        Size.l
        Type.l
        *Func[0] ; Index 1: FreeGadgetProg
      EndStructure
      
      CompilerIf #PB_Compiler_Version > 600
        Structure PB_Linux_GadgetStructure ; PB SDK
          Gadget.i
          Container.i
          *VT.PB_Linux_GadgetVT
          RootWindowID.i
          UserData.i
          Data.i[4]
        EndStructure
      CompilerElse
        Structure PB_Linux_GadgetStructure ; PB SDK
          Gadget.i
          Container.i
          *VT.PB_Linux_GadgetVT
          UserData.i
          Data.i[4]
        EndStructure
      CompilerEndIf
      
    CompilerCase #PB_OS_Windows
      Structure PB_Windows_GadgetVT ;PB SDK
        Type.l
        Size.l
        *Func[0] ; Index 1: FreeGadgetProg
      EndStructure
      
      Structure PB_Windows_GadgetStructure ; PB SDK
        Gadget.i
        *VT.PB_Windows_GadgetVT
        UserData.i
        OldCallback.i
        Data.i[4]
      EndStructure
      
  CompilerEndSelect
  
  ; ----
  
  Prototype ProtoFreeGadgetCB(Gadget)
  
  Structure udtFreeGadgetCB
    Invoke.ProtoFreeGadgetCB
  EndStructure
  
  Structure udtGadgetVT
    *FreeGadget
    IsSet.i
  EndStructure
  
  ; ----
  
  Global NewMap MapFreeGadgetCB.udtFreeGadgetCB()
  Global Dim GadgetVT.udtGadgetVT(40)
  
  ; ----
  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_MacOS
      
      ProcedureC MyFreeGadgetMethod(*Object, *Selector)
        Protected GadgetID, *Gadget.PB_MacOS_GadgetStructure, *call
        
        object_getInstanceVariable_(*Object, "GadgetID", @GadgetID)
        object_getInstanceVariable_(*Object, "Gadget", @*Gadget)
        If FindMapElement(MapFreeGadgetCB(), Str(GadgetID))
          MapFreeGadgetCB()\Invoke(GadgetID)
          DeleteMapElement(MapFreeGadgetCB())
        EndIf
        *call = GadgetVT(*Gadget\Type)\FreeGadget
        If *call
          CallCFunctionFast(*call, *Object, *Selector)
        EndIf
        
      EndProcedure
      
      Procedure SetFreeGadgetCallback(Gadget, *Callback)
        Protected *object.PB_MacOS_GadgetStructure, class, selector, imp
        *object = IsGadget(Gadget)
        If *object
          ; Replace method FreeGadget 
          If Not GadgetVT(*object\Type)\IsSet
            class  = object_getclass_(*object\vt)
            selector = sel_registerName_("FreeGadget")
            imp = class_replaceMethod_(class, selector, @MyFreeGadgetMethod(), "v@:")
            GadgetVT(*object\Type)\FreeGadget = imp
            GadgetVT(*object\Type)\IsSet = #True
          EndIf
          ; Add or replace free gadget callback
          If FindMapElement(MapFreeGadgetCB(), Str(Gadget))
            DeleteMapElement(MapFreeGadgetCB())
          EndIf
          If *Callback
            MapFreeGadgetCB(Str(Gadget))\Invoke = *Callback
          EndIf
        EndIf
      EndProcedure
      
    CompilerCase #PB_OS_Linux
      ProcedureC MyFreeGadgetMethod(*Object.PB_Linux_GadgetStructure)
        Protected gadget, *Call
        
        gadget = g_object_get_data_(*Object\gadget, "pb_id") - 1
        If FindMapElement(MapFreeGadgetCB(), Str(gadget))
          MapFreeGadgetCB()\Invoke(gadget)
          DeleteMapElement(MapFreeGadgetCB())
        EndIf
        *call = GadgetVT(*Object\vt\type)\FreeGadget
        If *call
          CallCFunctionFast(*call, *Object)
        EndIf
        
      EndProcedure
      
      Procedure SetFreeGadgetCallback(Gadget, *Callback)
        Protected *object.PB_Linux_GadgetStructure
        *object = IsGadget(Gadget)
        If *object
          ; Replace method FreeGadget 
          If Not GadgetVT(*object\vt\Type)\IsSet
            GadgetVT(*object\vt\Type)\FreeGadget = *object\vt\func[1]
            GadgetVT(*object\vt\Type)\IsSet = #True
            *object\vt\func[1] = @MyFreeGadgetMethod()
          EndIf
          ; Add or replace free gadget callback
          If FindMapElement(MapFreeGadgetCB(), Str(Gadget))
            DeleteMapElement(MapFreeGadgetCB())
          EndIf
          If *Callback
            MapFreeGadgetCB(Str(Gadget))\Invoke = *Callback
          EndIf
        EndIf
      EndProcedure
      
    CompilerCase #PB_OS_Windows
      Procedure MyFreeGadgetMethod(*Object.PB_Windows_GadgetStructure)
        Protected gadget, *Call
        
        gadget = GetProp_(*Object\Gadget, "pb_id")
        If FindMapElement(MapFreeGadgetCB(), Str(gadget))
          MapFreeGadgetCB()\Invoke(gadget)
          DeleteMapElement(MapFreeGadgetCB())
        EndIf
        *call = GadgetVT(*Object\vt\Type)\FreeGadget
        If *call
          CallFunctionFast(*call, *Object)
        EndIf
        
      EndProcedure
      
      Procedure SetFreeGadgetCallback(Gadget, *Callback)
        Protected *object.PB_Windows_GadgetStructure
        *object = IsGadget(Gadget)
        If *object
          ; Replace method FreeGadget
          If Not GadgetVT(*object\vt\Type)\IsSet
            GadgetVT(*object\vt\Type)\FreeGadget = *object\vt\func[1]
            GadgetVT(*object\vt\Type)\IsSet = #True
            *object\vt\func[1] = @MyFreeGadgetMethod()
          EndIf
          ; Add or replace free gadget callback
          If FindMapElement(MapFreeGadgetCB(), Str(Gadget))
            DeleteMapElement(MapFreeGadgetCB())
          EndIf
          If *Callback
            MapFreeGadgetCB(Str(Gadget))\Invoke = *Callback
          EndIf
        EndIf
      EndProcedure
      
  CompilerEndSelect
  
EndModule

; ****

CompilerIf #PB_Compiler_IsMainFile
  
  ;-TOP Example
  
  UseModule FreeGadgetEx
  
  #ProgramTitle = "Main Window"
  #ProgramVersion = "v1.01.2"
  
  Enumeration Windows
    #Main
  EndEnumeration
  
  Enumeration MenuBar
    #MainMenu
  EndEnumeration
  
  Enumeration MenuItems
    #MainMenuAbout
    #MainMenuExit
  EndEnumeration
  
  Enumeration Gadgets 8
    #MainList
    #MainButtonOk
    #MainButtonCancel
  EndEnumeration
  
  Enumeration StatusBar
    #MainStatusBar
  EndEnumeration
  
  ; ----
  
  Procedure MyFreeListGadget(Gadget)
    Protected *MyBigMemory
    Debug "Free ListGadget Number " + Gadget
    *MyBigMemory = GetGadgetData(Gadget)
    If *MyBigMemory
      Debug "Free MyBigMemory Adr: " + *MyBigMemory
      FreeMemory(*MyBigMemory)
    EndIf
  EndProcedure
  
  Procedure MyFreeButtonGadget(Gadget)
    Select Gadget
      Case #MainButtonOk
       Debug "Free Ok Button Number " + Gadget
      Case #MainButtonCancel
       Debug "Free Cancel Button Number " + Gadget
    EndSelect
    Debug "GadgetData = " + GetGadgetData(Gadget)
  EndProcedure
  
  ; ----
  
  Procedure UpdateWindow()
    Protected dx, dy
    dx = WindowWidth(#Main)
    dy = WindowHeight(#Main) - StatusBarHeight(#MainStatusBar) - MenuHeight()
    ; Resize gadgets
    If IsGadget(#MainList)
      ResizeGadget(#MainList, 5, 5, dx - 10, dy - 45)
    EndIf
    ResizeGadget(#MainButtonok, 10, dy - 35, 120, 30)
    ResizeGadget(#MainButtonCancel, dx - 130, dy - 35, 120, 30)
  EndProcedure
  
  Procedure Main()
    Protected dx, dy
    
    #MainStyle = #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget
    
    If OpenWindow(#Main, #PB_Ignore, #PB_Ignore, 800, 600, #ProgramTitle , #MainStyle)
      ; Menu
      CreateMenu(#MainMenu, WindowID(#Main))
      MenuTitle("&File")
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        MenuItem(#PB_Menu_About, "")
      CompilerElse
        MenuItem(#MainMenuAbout, "About")
      CompilerEndIf
      ; Menu File Items
      
      CompilerIf Not #PB_Compiler_OS = #PB_OS_MacOS
        MenuBar()
        MenuItem(#MainMenuExit, "E&xit")
      CompilerEndIf
      
      ; StatusBar
      CreateStatusBar(#MainStatusBar, WindowID(#Main))
      AddStatusBarField(#PB_Ignore)
      
      ; Gadgets
      dx = WindowWidth(#Main)
      dy = WindowHeight(#Main) - StatusBarHeight(#MainStatusBar) - MenuHeight()
      ListIconGadget(#MainList, 5, 5, dx -10, dy - 45, "Column 0", 200)
      AddGadgetColumn(#MainList, 1, "Column 1", 400)
      ButtonGadget(#MainButtonok, 10, dy - 35, 120, 30, "Ok")
      ButtonGadget(#MainButtonCancel, dx - 130, dy - 35, 120, 30, "Abbruch")
      
      ; Bind Events
      BindEvent(#PB_Event_SizeWindow, @UpdateWindow(), #Main)
      
      Define *MyBigMemory = AllocateMemory(100000)
      SetGadgetData(#MainList, *MyBigMemory)
      SetGadgetData(#MainButtonOk, 200)
      SetGadgetData(#MainButtonCancel, 300)
      
      SetFreeGadgetCallback(#MainList, @MyFreeListGadget())
      SetFreeGadgetCallback(#MainButtonOk, @MyFreeButtonGadget())
      SetFreeGadgetCallback(#MainButtonCancel, @MyFreeButtonGadget())
      
      ; Event Loop
      Repeat
        Select WaitWindowEvent()
          Case #PB_Event_CloseWindow
            Select EventWindow()
              Case #Main
                Break
                
            EndSelect
            
          Case #PB_Event_Menu
            Select EventMenu()
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS   
                Case #PB_Menu_About
                  PostEvent(#PB_Event_Menu, #Main, #MainMenuAbout)
                  
                Case #PB_Menu_Preferences
                  
                Case #PB_Menu_Quit
                  PostEvent(#PB_Event_CloseWindow, #Main, #Null)
                  
                CompilerEndIf
                
              Case #MainMenuAbout
                MessageRequester("About", #ProgramTitle + #LF$ + #ProgramVersion, #PB_MessageRequester_Info)
                
              Case #MainMenuExit
                PostEvent(#PB_Event_CloseWindow, #Main, #Null)
                
            EndSelect
            
          Case #PB_Event_Gadget
            Select EventGadget()
              Case #MainList
                Select EventType()
                  Case #PB_EventType_Change
                    ;
                    
                EndSelect
                
              Case #MainButtonOk
                If IsGadget(#MainList)
                  FreeGadget(#MainList)
                EndIf
                
              Case #MainButtonCancel
                ;
                
            EndSelect
            
        EndSelect
      ForEver
      CloseWindow(#Main)
      
    EndIf
    
  EndProcedure : Main()
  
CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 353
; Folding = ----------
; EnableXP