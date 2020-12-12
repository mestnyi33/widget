Enumeration
  #Object_Integer
  #Object_String
  #Object_List
EndEnumeration

Structure ObjectHead ; Object head for all objects
  Type.i
EndStructure

; Object types With their Structure

Structure Object Extends ObjectHead
  i.i
  s.s
EndStructure

Structure Object_List Extends ObjectHead
  List *Element.ObjectHead()
EndStructure

Structure ObjectAll  ; Object collection for all objects
  StructureUnion
    *Object.ObjectHead
    *val.Object
    *list.Object_List
  EndStructureUnion
EndStructure

; Object creation procedures

Procedure.i NewObject_Integer(Integer.i)
  Protected *Object.Object = AllocateStructure(Object)
  *Object\Type    = #Object_Integer
  *Object\i = Integer
  ProcedureReturn *Object
EndProcedure

Procedure.i NewObject_String(String.s)
  Protected *Object.Object = AllocateStructure(Object)
  *Object\Type    = #Object_String
  *Object\s  = String
  ProcedureReturn *Object
EndProcedure

Procedure.i NewObject_List()
  Protected *Object.Object_List = AllocateStructure(Object_List)
  *Object\Type    = #Object_List
  ProcedureReturn *Object
EndProcedure

Procedure.i AddObject(*list.Object_List, *Element.ObjectHead)
  If *list\Type = #Object_List
    AddElement(*list\Element())
    *list\Element() = *Element
  EndIf
  ProcedureReturn *list
EndProcedure

; Object output procedure

Procedure.s GetObject(*Object.ObjectHead)
  Protected ObjectAll.ObjectAll\Object = *Object
  Protected String.s
  
  Select *Object\Type
    Case #Object_Integer
      ProcedureReturn Str(ObjectAll\val\i)
      
    Case #Object_String
      ProcedureReturn ~"\"" + ObjectAll\val\s + ~"\""
      
    Case #Object_List
      ForEach ObjectAll\list\Element()
        If ListIndex(ObjectAll\list\Element()) > 0 : String + ", " : EndIf
        
        String + GetObject(ObjectAll\list\Element())
        ; Debug ObjectAll\list\Element()\string\String
      Next
      ProcedureReturn "["+String+"]"
  EndSelect
EndProcedure

; Example

Define *Object.ObjectAll, *Object2.ObjectAll, *SubObject

*Object = NewObject_List()
AddObject(*Object, NewObject_Integer(456))
AddObject(*Object, NewObject_String("World"))

*SubObject = NewObject_List()
AddObject(*SubObject, NewObject_Integer(123))
AddObject(*SubObject, NewObject_String("Hello"))
AddObject(*Object, *SubObject)

*SubObject = NewObject_List()
AddObject(*SubObject, NewObject_Integer(223))
AddObject(*SubObject, NewObject_String("Hello2"))
AddObject(*Object, *SubObject)

*Object\Object = *Object
;*Object2 = *Object
ForEach *Object\list\Element()
  If *Object\list\Element()\Type = 2
    Debug ""+*Object\list\Element()
    
    *Object2 =  *Object;\list\Element()
    
    ForEach *Object2\list\Element()
      If *Object2\list\Element()\Type = 2
        
        Debug "  "+*Object2\list\Element()
        
      EndIf
    Next
    
  EndIf
Next

;Debug GetObject(*Object)
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ---
; EnableXP