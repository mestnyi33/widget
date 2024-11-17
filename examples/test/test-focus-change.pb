XIncludeFile "../../widgets.pbi" 

EnableExplicit
UseWidgets( )

; IMPORTANT: Dates must be in French format (DD/MM/YY or DD/MM/YYYY)
#REGEX_DATE=0
#DEFREGEX_DATEFORMAT="^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$"
CreateRegularExpression(#REGEX_DATE,#DEFREGEX_DATEFORMAT)
;
Procedure   Pc_DateTypingControl()
  Protected.i Test
  Protected.i NoGadget=EventWidget(),NoEvenmt=ToPBEventType(WidgetEvent())
  Static.a StartDateError,EndDateError
  Static.s AncStartDate,AncEndDate,Date
  
  Select NoEvenmt
    Case #PB_EventType_Change
      ; [...]
    Case #PB_EventType_Focus ; Get the content of the gadget if no previous error
      Select NoGadget
          Case WidgetID(0):If Not StartDateError:AncStartDate=GetText(NoGadget):EndIf
          Case WidgetID(1):If Not EndDateError:AncEndDate=GetText(NoGadget):EndIf
      EndSelect
    Case #PB_EventType_LostFocus
       Debug NoGadget
       Date=GetText(NoGadget)
      Test=Bool(MatchRegularExpression(#REGEX_DATE,Date))!1
      Select NoGadget
        Case 0:StartDateError=Test
        Case 1:EndDateError=Test
      EndSelect
      If Test
        SetActive(NoGadget)
      EndIf
  EndSelect
EndProcedure
;
If Open(0,0,0,120,65,"Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  String(10,10,100,20,"32/12/2024")
  String(10,35,100,20,"31/12/2024")
  Bind( WidgetID(0),@Pc_DateTypingControl())
  Bind( WidgetID(1),@Pc_DateTypingControl())
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 42
; FirstLine = 14
; Folding = --
; EnableXP
; DPIAware