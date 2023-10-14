; https://www.purebasic.fr/english/viewtopic.php?p=550297&hilit=move+items#p550297
Structure Level2
  a.s
  b.s
EndStructure

Structure Level1
  a.s
  List c.Level2()
EndStructure

Structure Level0
  a.s
  List b.Level1()
EndStructure


Global Root.Level0

AddElement(Root\b())
Root\b()\a = "item1"
AddElement(Root\b()\c())
Root\b()\c()\a = "subitem1"
AddElement(Root\b())
Root\b()\a = "item2"
AddElement(Root\b()\c())
Root\b()\c()\a = "subitem2"
AddElement(Root\b())
Root\b()\a = "item1"
AddElement(Root\b()\c())
Root\b()\c()\a = "subitem3"
AddElement(Root\b())
Root\b()\a = "item1"
AddElement(Root\b()\c())
Root\b()\c()\a = "subitem4"

Procedure display_list()
  Debug "--------------"
  Debug "Root: a = " + root\a
  Debug " b()"
  ForEach root\b()
    Debug "  a = " + root\b()\a
    Debug "  c()"  
    ForEach root\b()\c()
      Debug "     a = " + root\b()\c()\a
      Debug "     b = " + root\b()\c()\b
      Debug "     -----"
    Next
    Debug "  -----"  
  Next
EndProcedure

display_list()

; Merge duplicate sublists
If ListSize(Root\b()) > 1
  
  Debug "Initial Size: "+Str(ListSize(Root\b()))
  Define *FirstMatch.Level1
  ForEach Root\b()
    Name.s = LCase(Root\b()\a)
    
    PushListPosition(Root\b())
    *FirstMatch = Root\b()
    While NextElement(root\b())
      If LCase(Root\b()\a) = Name
;         MergeLists(Root\b()\c(), *FirstMatch\c(), #PB_List_After ) ; <-- add all sublist items of duplicate item to "original" item before we delete it
;         NextElement(*FirstMatch\c()) ;move to end of merged list
        ;\\
        MergeLists(Root\b()\c(), *FirstMatch\c() ) ; #PB_List_After removed for original ordering
        ; NextElement(*FirstMatch\c())                      ; we don't need that anymore (?) at least work fine without that lineDeleteElement(Root\b())
      EndIf
    Wend
    PopListPosition(Root\b())
    
  Next
  
EndIf

Debug "Final Size:   "+Str(ListSize(Root\b()))+#CRLF$

display_list()

; expected result:
;
; Initial Size: 4
; Final Size:   2
;
; item1
; subitem1
; subitem3
; subitem4
; item2
; subitem2
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP