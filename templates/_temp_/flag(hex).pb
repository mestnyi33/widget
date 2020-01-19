EnableExplicit

Enumeration tagMyTest $F0010000 Step $10000
 #ValA
 #ValB
EndEnumeration
#ValC = $F0010000

Define.l ThsLng

                            ; X86           X64
Debug Hex(#ValA, #PB_Long)  ; F0010000   #  F0010000
Debug Hex(#ValB, #PB_Long)  ; F0020000   #  F0020000
Debug Hex(#ValC, #PB_Long)  ; F0010000   #  F0010000
Debug #ValA                 ; 4026597376 #  4026597376
Debug #ValB                 ; 4026662912 #  4026662912
Debug #ValC                 ; 4026597376 #  4026597376

ThsLng = #ValA

If ((ThsLng & ~ #ValA) = #Null)
 Debug "Equal"              ; Equal      #  Equal
Else
 Debug "Unequal"
EndIf

If (ThsLng = #ValA)
 Debug "Equal"              ; Equal      #  Unequal
Else
 Debug "Unequal"
EndIf

; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP