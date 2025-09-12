Global Dim Lng.s(3, 0)

Enumeration 
   #lng_eng
   #lng_rus
   #lng_french
   #lng
EndEnumeration

Enumeration 
   #lng_YES
   #lng_NO
   #lng_CANCEL
   #lng_ALL
EndEnumeration

ReDim Lng.s(#lng, #lng_ALL)

Lng(#lng_eng, #lng_YES) = "Yes"
Lng(#lng_eng, #lng_NO) = "No"
Lng(#lng_eng, #lng_CANCEL) = "Cancel"

Lng(#lng_rus, #lng_YES) = "Да"
Lng(#lng_rus, #lng_NO) = "Нет"
Lng(#lng_rus, #lng_CANCEL) = "Отмена"

Lng(#lng_french, #lng_YES) = "oui"
Lng(#lng_french, #lng_NO) = "Non"
Lng(#lng_french, #lng_CANCEL) = "Annuler"


Debug Lng(#lng_eng, #lng_NO)
Debug Lng(#lng_rus, #lng_NO)
; IDE Options = PureBasic 6.20 (Windows - x64)
; EnableXP
; DPIAware