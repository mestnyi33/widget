;- Top
; -----------------------------------------------------------------------------
;           Name:
;    Description:
;         Author:
;           Date: 2025-03-07
;        Version:
;     PB-Version:
;             OS:
;         Credit:
;          Forum:
;     Created by: IceDesign
; -----------------------------------------------------------------------------

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
CompilerEndIf

;- Enumerations
Enumeration Window
  #Window_0
EndEnumeration

Enumeration Gadgets
  #Btn_1
  #Btn_2
  #Btn_3
  #Btn_4
  #Btn_5
  #Btn_6
  #Panel_1
  #ScrlArea_1
  #String_1
  #Txt_1
  #Txt_2
  #Txt_3
  #Txt_4
  #Txt_5
EndEnumeration

;- Declare
Declare Resize_Window_0()
Declare Open_Window_0(X = 0, Y = 0, Width = 1170, Height = 560)

Procedure Resize_Window_0()
EndProcedure

Procedure Open_Window_0(X = 0, Y = 0, Width = 1170, Height = 560)
  If OpenWindow(#Window_0, X, Y, Width, Height, "Title", #PB_Window_SystemMenu)
;     ButtonGadget(#Btn_1, 50, 10, 140, 50, "Button_1")
;     ScrollAreaGadget(#ScrlArea_1, 330, 20, 330, 320, 1200, 800, 10, #PB_ScrollArea_Raised)
; ;       ButtonGadget(#Btn_3, 30, 20, 100, 40, "Button_3")
;       TextGadget(#Txt_2, 50, 70, 100, 38, "Text_2")
; ;       ButtonGadget(#Btn_4, 80, 140, 100, 40, "Button_4")
; ;       TextGadget(#Txt_3, 100, 230, 100, 38, "Text_3")
;     CloseGadgetList()   ; #ScrlArea_1
    PanelGadget(#Panel_1, 320, 50, 360, 290)
      AddGadgetItem(#Panel_1, -1, "Tab_0")
      ButtonGadget(#Btn_5, 20, 20, 100, 40, "Button_5")
;       TextGadget(#Txt_4, 40, 80, 100, 38, "Text_4")
;       ButtonGadget(#Btn_6, 70, 150, 100, 40, "Button_6")
;       TextGadget(#Txt_5, 90, 200, 100, 27, "Text_5")
      ;AddGadgetItem(#Panel_1, -1, "Tab_1")
    CloseGadgetList()   ; #Panel_1
;     TextGadget(#Txt_1, 80, 80, 150, 50, "Text_1")
;     ButtonGadget(#Btn_2, 110, 160, 170, 40, "Button_2")
;     StringGadget(#String_1, 120, 230, 190, 60, "String_1")

;     BindEvent(#PB_Event_SizeWindow, @Resize_Window_0(), #Window_0)
;     PostEvent(#PB_Event_SizeWindow, #Window_0, 0)
    ProcedureReturn #True
  EndIf
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
;- Main Program
If Open_Window_0()

  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 56
; FirstLine = 38
; Folding = --
; EnableXP
; DPIAware