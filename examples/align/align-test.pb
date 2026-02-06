IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   EnableExplicit
   
   Define cont, butt
   Define gEvent, gQuit
   Define state, direction = 1
   Define Width, Height
   
   Procedure GetAlign( *this._s_WIDGET )
      Protected result = 0
      
      If *this\align
         If *this\align\left
            result | #__align_Left
         EndIf
         If *this\align\top
            result | #__align_Top
         EndIf
         If *this\align\right
            result | #__align_Right
         EndIf
         If *this\align\bottom
            result | #__align_Bottom
         EndIf
         If Not result
            result = #__align_Center
         EndIf
      EndIf
      
      ProcedureReturn result
   EndProcedure
   
   Procedure.s GetAlignString( *this._s_WIDGET )
      Protected result.s
      
      If *this\align
         If *this\align\left
            result + "#__align_Left|"
         EndIf
         If *this\align\top
            result + "#__align_Top|"
         EndIf
         If *this\align\right
            result + "#__align_Right|"
         EndIf
         If *this\align\bottom
            result + "#__align_Bottom|"
         EndIf
         If result = ""
            result = "#__align_Center"
         Else
            result = Trim( result, "|" )
         EndIf
      EndIf
      
      ProcedureReturn result
   EndProcedure
   
   Open(0, 0, 0, 600, 600, "Demo alignment widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
   cont = Container(50, 50, 280, 200)
   butt = Button(0, 0, 100, 100, "press", #__flag_TextMultiline)    
   CloseList()
   
    SetAlign(butt, #__align_Full|#__align_Right)
   ; SetAlign(butt, #__align_auto|#__align_Right) ; bug без флага #__align_Center выравнивает на середину по вертикали
   ;SetAlign(butt, #__align_auto|#__align_Right|#__align_Top) 
   
   ;SetText(butt, Str(GetAlign(butt)))
   SetText(butt, ReplaceString(GetAlignString(butt), "|", #LF$))
   Repeat
      gEvent= WaitWindowEvent()
      
      Select gEvent
         Case #PB_Event_CloseWindow
            gQuit= #True
            
         Case #PB_Event_Timer
            If Width = 300
               direction = 1
            ElseIf Width = 400
               direction =- 1
            EndIf
            ;         
            Width + direction
            Height + direction
            
            If Resize(cont, #PB_Ignore, #PB_Ignore, Width, Height)
               SetText(butt, Str(Width) +"x"+ Str(Height) )
               
               ; Repaint( Root( )) ; с ним не происходить вход выход мыши под курсором
               PostRepaint( Root( ))
            EndIf
            
         Case #PB_Event_Gadget
            Select EventType( )
               Case #PB_EventType_LeftButtonDown
                  Width = Width(cont)
                  Height = Height(cont)
                  
                  If state = 0
                     state = 1
                     AddWindowTimer(0, 1, 10)
                  Else
                     state = 0
                     RemoveWindowTimer(0, 1)
                  EndIf
            EndSelect
            
      EndSelect
      
   Until gQuit
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 94
; FirstLine = 74
; Folding = ----
; EnableXP