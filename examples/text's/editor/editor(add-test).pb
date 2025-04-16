; https://www.purebasic.fr/english/viewtopic.php?t=86707
XIncludeFile "../../../widgets.pbi"
UseWidgets( )

; ***************************
; :: Blue April 2025 ::
; ***************************
; change this value to choose the  used to display the test data
#liste = 0            ;-  0=Editor,  1=ListView  

EnableExplicit
;-  constants 
Global zz_nLines_LABEL
Global zz_nLines
Global zz_TXT_Type
Global zz_CMD_Go
Global zz_Display
Global zz_TXT_infos


Procedure DisplayText()
   Static test
   test + 1 
   Protected maxLines, prevTestValue, line$
   Protected gadget$
   If #liste 
      gadget$ = "ListView "
   Else
      gadget$ = "Editor "
   EndIf
   
   Disable(zz_CMD_Go,1)
   SetText(zz_CMD_Go,"..")
   
   #zz_TIME_ms$ = "[ms]> "
   
   maxLines = Val(GetText(zz_nLines))
   If 0 = CountItems(zz_Display)
      SetText(zz_TXT_infos, #zz_TIME_ms$ )
      Debug "; "+maxLines + " lines in " +gadget$ +" :"
   Else
      prevTestValue = CountItems(zz_Display)
      ClearItems(zz_Display)
      If maxLines <> prevTestValue
         Debug ""
         Debug "; "+maxLines + " lines in " +gadget$ +" :"
         test = 1
         SetText(zz_TXT_infos, #zz_TIME_ms$)
      EndIf
   EndIf
   
   Protected line, count, lapsed
   SetActive(zz_Display)
   lapsed = ElapsedMilliseconds()            ; start tracking time 
   While line < maxLines
      line + 1
      line$ = "Line " + line +" of " + maxLines 
      AddItem (zz_Display, -1, "Test #" +test +" : " + line$)
      count + 1
      If count % 24 = 0
         SetText(zz_CMD_Go,Str(line))
         ; While WindowEvent() : Wend ; Flush the events
      EndIf
   Wend
   lapsed = ElapsedMilliseconds() - lapsed   ; stop  tracking time
   SetState(zz_Display, line-1)              ; go to the last line
   
   If test > 5
      test = 1
      SetText(zz_TXT_infos, #zz_TIME_ms$ )
   EndIf
   SetText(zz_TXT_infos, GetText(zz_TXT_infos) + "[" +lapsed +"]  ")
   Debug "; time " + GetText(zz_TXT_infos)
   
   Disable(zz_CMD_Go,0)
   SetText(zz_CMD_Go,"Again")
EndProcedure

Procedure zz_CMD_Go( )
   DisplayText()
EndProcedure

Procedure CreerDialogue()
   #winW = 400
   #winH = 600
   #winType = #PB_Window_SystemMenu | #PB_Window_ScreenCentered
   
   If 0 = Open(0, 0, 0, #winW, #winH, "TESTing listing s", #winType)
      MessageRequester("ERROR", "Couldn't open a window...")
      End
   EndIf
   
   #marge = 10
   Protected gi, gX,gY, gW,gH
   
   gH = 20
   gW = 48
   gY = #marge
   gX = #marge
   zz_nLines_LABEL = Text(gX,gY,gW,gH,"Display")
   
   gX + gW
   gW = 56
   zz_nLines = ComboBox(gX,gY,gW,gH)  ;- ..test values
   Protected i
   AddItem(zz_nLines, -1,"16")
   For i = 0 To 8
      AddItem(zz_nLines, -1,Str(128*Pow(2,i)))
   Next
   SetState(zz_nLines,6)    ; default : 1024 lines
   
   gX + gW + 6
   gW = #winW - #marge - gX
   zz_TXT_Type = Text(gX,gY,gW,gH,"")
   If #liste 
      SetText(zz_TXT_Type,"lines in a ListView" )
   Else
      SetText(zz_TXT_Type,"lines in an Editor" )
   EndIf
   
   gY + gH + 2
   gW = 70
   gX = #winW -#marge -gW 
   zz_CMD_Go = Button(gX,gY,gW,gH,"Start")
   
   gW = gX -#marge -4
   gX = #marge 
   zz_TXT_infos = Text(gX,gY,gW,gH,"The time [in ms] for each run will be shown here.")
   SetColor(zz_TXT_infos,#PB_Gadget_BackColor,#Yellow)
   
   gY + gH +4
   gW = #winW -#marge*2
   gH = #winH -#marge -gY -8
   If #liste ; beaucoup plus rapide
      zz_Display = ListView(gX,gY,gW,gH)                     ;- ..ListView
   Else
      zz_Display = Editor(gX,gY,gW,gH,#PB_Editor_ReadOnly)   ;- ..Editor
   EndIf
   
   Bind(zz_CMD_Go, @zz_CMD_Go(), #__event_leftclick)
EndProcedure

Debug "; - - - - - - - - - - - - - - - - - - - - - - - -"
CreerDialogue()
Define event
Repeat                          ;- Events Loop
   event = WaitWindowEvent(1)
   Select event
      Case #PB_Event_CloseWindow : Break
   EndSelect  
ForEver
Debug "; - - - - - - - - - - - - - - - - - - - - - - - -"
Debug ""
Debug ""
End

; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 8
; Folding = ---
; EnableXP
; DPIAware