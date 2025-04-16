; https://www.purebasic.fr/english/viewtopic.php?t=86707
; ***************************
; :: Blue April 2025 ::
; ***************************
; change this value to choose the gadget used to display the test data
  #liste = 0            ;-  0=EditorGadget,  1=ListViewGadget  

EnableExplicit
Enumeration             ;- gadget constants 
  #zz_nLines_LABEL
  #zz_nLines
  #zz_TXT_gadgetType
  #zz_CMD_Go
  #zz_Display
  #zz_TXT_infos
EndEnumeration

Procedure DisplayText()
  Static test
  test + 1 
  Protected maxLines, prevTestValue, line$
  Protected gadget$
  If #liste 
    gadget$ = "ListViewGadget "
  Else
    gadget$ = "EditorGadget "
  EndIf
  
  DisableGadget(#zz_CMD_Go,1)
  SetGadgetText(#zz_CMD_Go,"..")
  
  #zz_TIME_ms$ = "[ms]> "
  
  maxLines = Val(GetGadgetText(#zz_nLines))
  If 0 = CountGadgetItems(#zz_Display)
    SetGadgetText(#zz_TXT_infos, #zz_TIME_ms$ )
    Debug "; "+maxLines + " lines in " +gadget$ +" :"
  Else
    prevTestValue = CountGadgetItems(#zz_Display)
    ClearGadgetItems(#zz_Display)
    If maxLines <> prevTestValue
      Debug ""
      Debug "; "+maxLines + " lines in " +gadget$ +" :"
      test = 1
      SetGadgetText(#zz_TXT_infos, #zz_TIME_ms$)
    EndIf
  EndIf

  Protected line, count, lapsed
  SetActiveGadget(#zz_Display)
  lapsed = ElapsedMilliseconds()            ; start tracking time 
  While line < maxLines
    line + 1
    line$ = "Line " + line +" of " + maxLines 
    AddGadgetItem (#zz_Display, -1, "Test #" +test +" : " + line$)
    count + 1
    If count % 24 = 0
      SetGadgetText(#zz_CMD_Go,Str(line))
      While WindowEvent() : Wend ; Flush the events
    EndIf
  Wend
  lapsed = ElapsedMilliseconds() - lapsed   ; stop  tracking time
  SetGadgetState(#zz_Display, line-1) ; go to the last line
  
  If test > 5
    test = 1
    SetGadgetText(#zz_TXT_infos, #zz_TIME_ms$ )
  EndIf
  SetGadgetText(#zz_TXT_infos, GetGadgetText(#zz_TXT_infos) + "[" +lapsed +"]  ")
  Debug "; time " + GetGadgetText(#zz_TXT_infos)

  DisableGadget(#zz_CMD_Go,0)
  SetGadgetText(#zz_CMD_Go,"Again")
EndProcedure
Procedure CreerDialogue()
  #winW = 400
  #winH = 600
  #winType = #PB_Window_SystemMenu | #PB_Window_ScreenCentered

  If 0 = OpenWindow(0, 0, 0, #winW, #winH, "TESTing listing gadgets", #winType)
    MessageRequester("ERROR", "Couldn't open a window...")
    End
  EndIf

  #marge = 10
  Protected gi, gX,gY, gW,gH

  gi = #zz_nLines_LABEL
    gH = 20
    gW = 48
    gY = #marge
    gX = #marge
    TextGadget(gi,gX,gY,gW,gH,"Display")

  gi = #zz_nLines
    gX + gW
    gW = 56
    ComboBoxGadget(gi,gX,gY,gW,gH)  ;- ..test values
      Protected i
      AddGadgetItem(gi, -1,"16")
      For i = 0 To 8
        AddGadgetItem(gi, -1,Str(128*Pow(2,i)))
      Next
      SetGadgetState(gi,6)    ; default : 1024 lines

  gi = #zz_TXT_gadgetType
    gX + gW + 6
    gW = #winW - #marge - gX
    TextGadget(gi,gX,gY,gW,gH,"")
    If #liste 
      SetGadgetText(gi,"lines in a ListViewGadget" )
    Else
      SetGadgetText(gi,"lines in an EditorGadget" )
    EndIf

  gi = #zz_CMD_Go
    gY + gH + 2
    gW = 70
    gX = #winW -#marge -gW 
    ButtonGadget(gi,gX,gY,gW,gH,"Start")

  gi = #zz_TXT_infos
    gW = gX -#marge -4
    gX = #marge 
    TextGadget(gi,gX,gY,gW,gH,"The time [in ms] for each run will be shown here.")
    SetGadgetColor(gi,#PB_Gadget_BackColor,#Yellow)

  gi = #zz_Display
    gY + gH +4
    gW = #winW -#marge*2
    gH = #winH -#marge -gY -8
    If #liste ; beaucoup plus rapide
      ListViewGadget(gi,gX,gY,gW,gH)                     ;- ..ListViewGadget
    Else
      EditorGadget(gi,gX,gY,gW,gH,#PB_Editor_ReadOnly)   ;- ..EditorGadget
    EndIf
EndProcedure

  Debug "; - - - - - - - - - - - - - - - - - - - - - - - -"
  CreerDialogue()
  Define event
  Repeat                          ;- Events Loop
    event = WaitWindowEvent(1)
    Select event
      Case #PB_Event_CloseWindow : Break
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #zz_CMD_Go : DisplayText()
        EndSelect
    EndSelect  
  ForEver
  Debug "; - - - - - - - - - - - - - - - - - - - - - - - -"
  Debug ""
  Debug ""
  End

; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 1
; Folding = ---
; EnableXP
; DPIAware