;/=====================================================================================================================
;|  AdvancedButton.pb -- Example 
;|
;|  + Add Events for Focus, LostFocus and RightClick to a Standard Button 
;|  + Using Subclass procedures instead of SetWindowLongPtr() 
;|
;|  + HINT: Works on Windows Only 
;|
;|  License: Free, unrestricted, no warranty 
;|
;|  Copyright (c) by Axolotl -- All Rights reserved. 
;|
;\---

CompilerIf #PB_Compiler_IsMainFile ; 
EnableExplicit 
CompilerEndIf 

CompilerIf #PB_Compiler_OS = #PB_OS_Windows ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Windows Only Part <<<

Import "Comctl32.lib" ;{·} ... SubClass .....
  CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
    SetWindowSubclass_(hWnd, *fnSubclass, uIdSubclass, dwRefData)  As "SetWindowSubclass" 
    GetWindowSubclass_(hWnd, *fnSubclass, uIdSubclass, *dwRefData) As "GetWindowSubclass"
    RemoveWindowSubclass_(hWnd, *fnSubclass, uIdSubclass)          As "RemoveWindowSubclass"
    DefSubclassProc_(hWnd, uMsg, wParam, lParam)                   As "DefSubclassProc"
  CompilerElse
    SetWindowSubclass_(hWnd, *fnSubclass, uIdSubclass, dwRefData)  As "_SetWindowSubclass@16" 
    GetWindowSubclass_(hWnd, *fnSubclass, uIdSubclass, *dwRefData) As "_GetWindowSubclass@16"
    RemoveWindowSubclass_(hWnd, *fnSubclass, uIdSubclass)          As "_RemoveWindowSubclass@12"
    DefSubclassProc_(hWnd, uMsg, wParam, lParam)                   As "_DefSubclassProc@16" 
  CompilerEndIf
EndImport ;} End of Import "Comctl32.lib" 

; ---------------------------------------------------------------------------------------------------------------------

Procedure AdvancedButtonSubClassProc(hWnd, uMsg, wParam, lParam, uIdSubclass, dwRefData) 
  ;
  ; HINT: use the parameter to forward the PB-Numbers of Parent Window and Gadget 
  ;   dwRefData   ==> parent window 
  ;   uIdSubClass ==> gadget button 
  ;
  Select uMsg 
    Case #WM_NCDESTROY 
      RemoveWindowSubclass_(hWnd, @AdvancedButtonSubClassProc(), uIdSubclass)  

    Case #WM_RBUTTONDOWN 
      PostEvent(#PB_Event_Gadget, dwRefData, uIdSubClass, #PB_EventType_RightClick) 

    Case #WM_SETFOCUS 
      PostEvent(#PB_Event_Gadget, dwRefData, uIdSubClass, #PB_EventType_Focus) 

    Case #WM_KILLFOCUS 
      PostEvent(#PB_Event_Gadget, dwRefData, uIdSubClass, #PB_EventType_LostFocus) 
  EndSelect 
  ProcedureReturn DefSubclassProc_(hWnd, uMsg, wParam, lParam) 
EndProcedure

; ---------------------------------------------------------------------------------------------------------------------

Procedure AdvancedButtonGadget(Gadget, X, Y, Width, Height, Text.s, Flags=0) 
  Protected result, hGad, parentwindow 

  result = ButtonGadget(Gadget, X, Y, Width, Height, Text, Flags) ; Standard Button 
  If Gadget = #PB_Any 
    Gadget = result               ; Gadget is the PB Gadget Number 
  EndIf 
  hGad = GadgetID(Gadget)         ; hGad is the window handle of the Gadget 

  ; get the window number from handle to the ancestor of the specified gadget (the real window) 
  ;
  parentwindow = GetProp_(GetAncestor_(hGad, #GA_ROOT), "pb_windowid") - 1  ; for advanced programmers only :) 

  SetWindowSubclass_(hGad, @AdvancedButtonSubClassProc(), Gadget, parentwindow) 

  ProcedureReturn result ; return PB-Number or handle (depends on Parameter Gadget) 
EndProcedure 

CompilerElse ;{·} #PB_Compiler_OS = #PB_OS_Windows ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Else Windows Only Part <<<

Debug "■ "
Debug "■ HINT: This Feature is available on windows only." 
Debug "■       The Procedure AdvancedButtonGadget() is replaced with the standard ButtonGadget() Procedure." 

Macro AdvancedButtonGadget(Gadget, X, Y, Width, Height, Text.s, Flags=0) 
  ButtonGadget(Gadget, X, Y, Width, Height, Text.s, Flags) 
EndMacro 

CompilerEndIf ;} #PB_Compiler_OS = #PB_OS_Windows ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< EndIf Windows Only Part <<<

; =====================================================================================================================

CompilerIf #PB_Compiler_IsMainFile ; >>>>>>> Test the code from above >>>>>>> 
Enumeration EWindow 1 
  #WND_Main 
EndEnumeration 
Enumeration EGagdet 1 
  #GDT_lblInfoText            ; some info about the usage ..... 
  #GDT_btnAdvanced 
  #GDT_btnStandard 
  #GDT_strFocusHelper   
  #GDT_cntDisturber           ; use ContainerGadgets for nesting 
  #GDT_cntTroubleMaker        ; -"- 
EndEnumeration 

Procedure Main() 

  If OpenWindow(#WND_Main, 0, 0, 456, 160, "Advanced ButtonGadget Example.....", #PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
    ContainerGadget(#GDT_cntDisturber, 0, 0, 456, 160) 
      ContainerGadget(#GDT_cntTroubleMaker, 0, 0, 456, 160) 
        TextGadget(#GDT_lblInfoText,           8,   8, 440, 24, "Use the TAB Key to de/activate the ButtonGadgets ....... ") 
        ButtonGadget(#GDT_btnStandard,         8,  40, 440, 24, "Standard Button") 
        AdvancedButtonGadget(#GDT_btnAdvanced, 8,  72, 440, 24, "Adanced Button with (Lost)Focus and RightClick Events") 
        StringGadget(#GDT_strFocusHelper,      8, 104, 440, 20, "String for focus ..... Test") 
      CloseGadgetList() 
    CloseGadgetList() 

    SetActiveGadget(#GDT_strFocusHelper)  

    Repeat 
      Select WaitWindowEvent()
        Case #PB_Event_CloseWindow
          Break ; say good bye.  

        Case #PB_Event_Gadget
          Select EventGadget() 
            Case #GDT_btnStandard 
              Select EventType() 
                Case #PB_EventType_Focus      : Debug "btnStandard: Focus"                    ; not possible !! 
                Case #PB_EventType_LostFocus  : Debug "btnStandard: Lost Focus"               ; not possible !! 
                Case #PB_EventType_LeftClick  : Debug "btnStandard: Left  Mouse Button Click" 
                Case #PB_EventType_RightClick : Debug "btnStandard: Right Mouse Button Click" ; not possible !! 
              EndSelect 

            Case #GDT_btnAdvanced 
              Select EventType() 
                Case #PB_EventType_Focus      : Debug "btnAdvanced: Focus"
                Case #PB_EventType_LostFocus  : Debug "btnAdvanced: Lost Focus"
                Case #PB_EventType_LeftClick  : Debug "btnAdvanced: Left  Mouse Button Click" 
                Case #PB_EventType_RightClick : Debug "btnAdvanced: Right Mouse Button Click -- Win = " + EventWindow() + ", Gad = " + EventGadget() 
              EndSelect 

            Case #GDT_strFocusHelper 
              Select EventType() 
                Case #PB_EventType_Change     : Debug "strFocusHelper: Change"              
                Case #PB_EventType_Focus      : Debug "strFocusHelper: Focus"
                Case #PB_EventType_LostFocus  : Debug "strFocusHelper: Lost Focus"
              EndSelect  
          EndSelect  
      EndSelect 
    ForEver 
  EndIf 
  ProcedureReturn 0 
EndProcedure 

;- Call Main() Procedure ..... 
End Main() 

CompilerEndIf ; #PB_Compiler_IsMainFile <<<<<<<< 

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 73
; FirstLine = 21
; Folding = ----
; EnableXP
; DPIAware