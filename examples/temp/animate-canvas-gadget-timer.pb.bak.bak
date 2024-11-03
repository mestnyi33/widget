;-TOP by mk-soft, v1.02.1, 24.09.2023

;- Gadget Common

CompilerIf Not #PB_Compiler_Thread
   ; CompilerError "Use Compiler Option ThreadSafe!"
CompilerEndIf

; ----

DeclareModule MyGadgetCommon
   Global position
   Global enterGadget
   
   Declare WindowPB(Object)
   Declare FreeGadgetWithData(Gadget)
   
EndDeclareModule

Module MyGadgetCommon
   
   CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
         Procedure WindowPB(Object)
            Protected r1
            r1 = GetProp_(Object, "PB_WINDOWID")
            If r1 > 0
               ProcedureReturn r1 - 1
            Else
               ProcedureReturn -1
            EndIf
         EndProcedure
         
      CompilerCase #PB_OS_Linux
         Procedure WindowPB(Object)
            ProcedureReturn g_object_get_data_(Object, "pb_id" )
         EndProcedure
         
      CompilerCase #PB_OS_MacOS
         Import ""
            PB_Window_GetID(Object) 
         EndImport
         
         Procedure WindowPB(Object)
            ProcedureReturn PB_Window_GetID(Object)
         EndProcedure
         
   CompilerEndSelect
   
   ; ----
   
   Procedure FreeGadgetWithData(Gadget)
      Protected *This
      
      If IsGadget(Gadget)
         *This = GetGadgetData(Gadget)
         If *This
            FreeStructure(*This)
         EndIf
         FreeGadget(Gadget)
      EndIf
   EndProcedure
   
EndModule

;- MyGadget 1

DeclareModule MyGadget
   
   Declare CreateMyGadget(Gadget, x, y, Width, Height, Text.s, Flags = 0)
   Declare FreeMyGadget(Gadget)
   Declare SetText(Gadget, Text.s)
   Declare.s GetText(Gadget)
   Structure udtMyGadget
      ; Base
      Window.i
      Gadget.i
      EventType.i
      ; Param
      Text.s
      Flags.i
      ; Data Animation
      AnimateValue.i
      AnimateMin.i
      AnimateMax.i
      AnimateDelay.i
      AnimateEnter.i
      AnimateLeave.i
   EndStructure
   Enumeration #PB_EventType_FirstCustomValue
      #MyEventType_AnimateEnter
      #MyEventType_AnimateLeave
   EndEnumeration
   
   
EndDeclareModule

Module MyGadget
   
   UseModule MyGadgetCommon
   
   
   ; ----
   
   Procedure DrawGadget(*This.udtMyGadget)
      Protected dx, dy, dx2, dy2, dy3
      
      With *This
         dx = GadgetWidth(\Gadget)
         dy = GadgetHeight(\Gadget)
         
         If StartDrawing(CanvasOutput(\Gadget))
            ; Draw background
            Box(0, 0, dx, dy, $8B8B00)
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(0, 0, dx, dy, $FF901E)
            ; Draw contents
            DrawingMode(#PB_2DDrawing_Default)
            Box(10, 10, dx-20, dy-20, #Black)
            DrawText(20, 20, \Text, #White, #Black)
            ; Draw animation
            dx2 = dx - 20 - 2
            dy2 = (dy - 20) * (\AnimateMax - \AnimateValue) / \AnimateMax - 2
            Box(11, 11, dx2, dy2, #Gray)
            StopDrawing()
         EndIf
         
      EndWith
   EndProcedure
   
   ; ----
   
   Procedure DoAnimateEnter(*This.udtMyGadget)
      
      With *This
         If Not \AnimateEnter
            \AnimateEnter = #True
            \AnimateLeave = #False
            
            While \AnimateEnter
               \AnimateValue + 1
               PostEvent(#PB_Event_Gadget, \Window, \Gadget, #MyEventType_AnimateEnter, \AnimateValue)
               If \AnimateValue >= \AnimateMax
                  \AnimateEnter = #False
                  Break
               EndIf
               Delay(\AnimateDelay)
            Wend
         EndIf
      EndWith
   EndProcedure
   
   ; ----
   
   Procedure DoAnimateLeave(*This.udtMyGadget)
      
      With *This
         If Not \AnimateLeave
            \AnimateLeave = #True
            \AnimateEnter = #False
            
            While \AnimateLeave
               \AnimateValue - 1
               PostEvent(#PB_Event_Gadget, \Window, \Gadget, #MyEventType_AnimateLeave, \AnimateValue)
               If \AnimateValue <= \AnimateMin
                  \AnimateLeave = #False
                  Break
               EndIf
               Delay(\AnimateDelay)
            Wend
         EndIf
      EndWith
   EndProcedure
   
   ; ----
   
   Procedure DoEvents()
      Protected *this.udtMyGadget = GetGadgetData(EventGadget())
      
      With *this
         If *this
            \EventType = EventType()
            Select \EventType
               Case #PB_EventType_MouseEnter
                  ; Start trigger enter gadget
                  ;CreateThread(@DoAnimateEnter(), *this)
                  position = 1
                  enterGadget = EventGadget()
                  
               Case #PB_EventType_MouseLeave
                  ; Start trigger leave gadget
                  ;CreateThread(@DoAnimateLeave(), *this)
                  enterGadget = EventGadget()
                  position =- 1
                  
               Case #PB_EventType_MouseMove
               Case #PB_EventType_MouseWheel
               Case #PB_EventType_LeftButtonDown
               Case #PB_EventType_LeftButtonUp
               Case #PB_EventType_LeftClick
               Case #PB_EventType_LeftDoubleClick
               Case #PB_EventType_RightButtonDown
               Case #PB_EventType_RightButtonUp
               Case #PB_EventType_RightClick
               Case #PB_EventType_RightDoubleClick
               Case #PB_EventType_MiddleButtonDown
               Case #PB_EventType_MiddleButtonUp
               Case #PB_EventType_Focus
               Case #PB_EventType_LostFocus
               Case #PB_EventType_KeyDown
               Case #PB_EventType_KeyUp
               Case #PB_EventType_Input
               Case #PB_EventType_Resize
                  
               Case #MyEventType_AnimateEnter
                  DrawGadget(*this)
                  
               Case #MyEventType_AnimateLeave
                  DrawGadget(*this)
                  
            EndSelect
         EndIf
      EndWith
   EndProcedure
   
   ; ----
   
   Procedure SetText(Gadget, Text.s)
      Protected *this.udtMyGadget
      
      With *this
         *this = GetGadgetData(Gadget)
         If *this
            \Text = Text
            DrawGadget(*this)
         EndIf
      EndWith
   EndProcedure
   
   ; ----
   
   Procedure.s GetText(Gadget)
      Protected *this.udtMyGadget
      
      With *this
         *this = GetGadgetData(Gadget)
         If *this
            ProcedureReturn \Text
         EndIf
      EndWith
   EndProcedure
   
   ; ----
   
   Procedure CreateMyGadget(Gadget, x, y, Width, Height, Text.s, Flags = 0)
      Protected r1, *this.udtMyGadget
      
      With *this
         ; Create memory for gadget
         *this = AllocateStructure(udtMyGadget)
         If Not *this
            ProcedureReturn 0
         EndIf
         ; Create Gadget
         r1 = CanvasGadget(Gadget, x, y, Width, Height, Flags)
         If r1
            \Window = WindowPB(UseGadgetList(0))
            If Gadget = #PB_Any
               \Gadget = r1
            Else
               \Gadget = Gadget
            EndIf
            ; Store pointers to own data in gadget data
            SetGadgetData(\Gadget, *This)
            ; Parameter
            \Text = Text
            \Flags = Flags
            ; Default values
            \AnimateMin = 0
            \AnimateMax = 5;20
        \AnimateDelay = 200;15 ; ms
                           ; Draw gadget
            DrawGadget(*This)
            ; Bind gadget events
            BindGadgetEvent(\Gadget, @DoEvents())
         Else
            FreeStructure(*this)
         EndIf
         
      EndWith
      ProcedureReturn r1
   EndProcedure
   
   ; ----
   
   Procedure FreeMyGadget(Gadget)
      Protected *This
      
      If IsGadget(Gadget)
         *This = GetGadgetData(Gadget)
         If *This
            FreeStructure(*This)
         EndIf
         FreeGadget(Gadget)
      EndIf
   EndProcedure
   
EndModule

;-Example

;-TOP

#ProgramTitle = "Own Gadget with Animation"
#ProgramVersion = "v1.02.1"

Enumeration Windows 1
   #Main
EndEnumeration

Enumeration MenuBar
   #MainMenu
EndEnumeration

Enumeration MenuItems
   #MainMenuAbout
   #MainMenuExit
EndEnumeration

Enumeration Gadgets
   #MainGadget1
   #MainGadget2
EndEnumeration

Enumeration StatusBar
   #MainStatusBar
EndEnumeration

Procedure UpdateWindow()
   Protected dx, dy
   dx = WindowWidth(#Main)
   dy = WindowHeight(#Main) - StatusBarHeight(#MainStatusBar) - MenuHeight()
   ; Resize gadgets
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
      MyGadget::CreateMyGadget(#MainGadget1, 10, 10, 200, 100, "Hello World!")
      MyGadget::CreateMyGadget(#MainGadget2, 220, 10, 200, 100, "I like PureBasic!")
      
      MyGadget::SetText(#MainGadget1, "Hello User!")
      
      ; Bind Events
      BindEvent(#PB_Event_SizeWindow, @UpdateWindow(), #Main)
      
      ;BindEvent(#PB_Event_Timer, @UpdateWindow(), #Main)
      AddWindowTimer( #Main, 3, 10)
      
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
               
            Case #PB_Event_Timer
               Protected *this.MyGadget::udtMyGadget = GetGadgetData(MyGadgetCommon::enterGadget)
               With *This
                  If MyGadgetCommon::position > 0
                     
                     \AnimateValue + 1
                     PostEvent(#PB_Event_Gadget, \Window, \Gadget, MyGadget::#MyEventType_AnimateEnter, \AnimateValue)
                     If \AnimateValue >= \AnimateMax
                        MyGadgetCommon::position = 0
                     EndIf
                     Delay(\AnimateDelay)
                     ;Debug MyGadgetCommon::position 
                  EndIf
                  
                  If MyGadgetCommon::position < 0
                     
                     \AnimateValue - 1
                     PostEvent(#PB_Event_Gadget, \Window, \Gadget, MyGadget::#MyEventType_AnimateLeave, \AnimateValue)
                     If \AnimateValue <= \AnimateMin
                        MyGadgetCommon::position = 0
                     EndIf
                     Delay(\AnimateDelay)
                     ;Debug MyGadgetCommon::position 
                  EndIf
               EndWith
               
            Case #PB_Event_Gadget
               Select EventGadget()
                     
               EndSelect
               
         EndSelect
      ForEver
      
      MyGadget::FreeMyGadget(#MainGadget1)
      MyGadgetCommon::FreeGadgetWithData(#MainGadget2)
      
   EndIf
   
EndProcedure : Main()

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 382
; FirstLine = 373
; Folding = ---------
; EnableXP