IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   UseLib(widget)
   EnableExplicit
   
   Global NewMap Widgets.i()
   Global.i Canvas_0, gEvent, gQuit, x=10,y=10
   
   Procedure Window_0()
      Define i,*w._S_widget = Open(0, 0, 0, 600, 600, "Demo alignment widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      If *w
         Widgets(Hex(0)) = Container(50, 50, 280, 200)
         Widgets(Hex(1)) = Button(0, 0, 80, 40, "Button")    
         ; Widgets(Hex(1)) = Tab(0, 0, 80, 40) : For i=0 To 3 : AddItem(widget( ), -1, "tab_"+Str(i)) : Next  
         CloseList()
         
         SetAlignment(Widgets(Hex(1)), #__align_Full|#__align_Top)
         
         ;Resize(Widgets(Hex(0)), 51, #PB_Ignore, #PB_Ignore,#PB_Ignore)
      EndIf
   EndProcedure
   
   
   Window_0()
   
   Define direction = 1
   Define Width, Height
   Define state
   
   Repeat
      gEvent= WaitWindowEvent()
      
      Select gEvent
         Case #PB_Event_CloseWindow
            gQuit= #True
            
         Case #PB_Event_Timer
            If Width = 480
               direction = 1
            ElseIf Width = Width(Root())-100
               direction =- 1
            EndIf
            ;         
            Width + direction
            Height + direction
            
            Resize(Widgets(Hex(0)), #PB_Ignore, #PB_Ignore, Width, Height)
            
            
         Case #PB_Event_Gadget
            
            Select EventType( )
               Case #PB_EventType_LeftButtonDown
                  Define *th._s_widget = Widgets(Str(0))
                  Width = Width(*th)
                  Height = Height(*th)
                  
                  If state
                     state = 0
                     AddWindowTimer(0, 1, 200)
                  Else
                     state = 1
                     RemoveWindowTimer(0, 1)
                  EndIf
            EndSelect
            
      EndSelect
      
   Until gQuit
CompilerEndIf
; IDE Options = PureBasic 6.04 LTS - C Backend (MacOS X - x64)
; CursorPosition = 19
; FirstLine = 4
; Folding = --
; EnableXP