Structure mypoint
   x.i
   y.i
EndStructure

Structure myobject
   *point.mypoint
EndStructure

*myobject.myobject = AllocateStructure(myobject)
*myobject\point.mypoint = AllocateStructure(mypoint)

*myobject\point\x = 10
*myobject\point\y = 20

*pointer.myobject
*pointer = *myobject
CopyStructure(@*myobject, @*pointer, myobject)

;*myobject = 0
;ClearStructure( *myobject, myobject )
;ClearStructure( *myobject\point, mypoint )
; FreeStructure(*myobject\point)
 FreeStructure(*myobject)

;*mypoint.mypoint = AllocateStructure(mypoint)

*myobject = *pointer

Debug ""+*myobject\point\x +" "+ *myobject\point\y


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 14
; FirstLine = 2
; Folding = -
; EnableXP
; DPIAware