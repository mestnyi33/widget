Enumeration
   #Object_Integer
   #Object_String
   #Object_List
EndEnumeration

Structure ObjectHead ; Object head for all objects
   Type.i
EndStructure

; Object types With their Structure
 
Structure Object_Integer Extends ObjectHead
   i.i
EndStructure

Structure Object_String Extends ObjectHead
   s.s
EndStructure

Structure Object_List Extends ObjectHead
   List *Element.ObjectHead()
EndStructure

Structure ObjectAll  ; Object collection for all objects
   StructureUnion
      *Object.ObjectHead
      *integer.Object_Integer
      *string.Object_String
      *list.Object_List
   EndStructureUnion
EndStructure

; Object creation procedures
 
Procedure.i NewObject_Integer(Integer.i)
   Protected *Object.Object_Integer = AllocateStructure(Object_Integer)
   *Object\Type    = #Object_Integer
   *Object\i = Integer
   ProcedureReturn *Object
EndProcedure

Procedure.i NewObject_String(String.s)
   Protected *Object.Object_String = AllocateStructure(Object_String)
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
         ProcedureReturn Str(ObjectAll\integer\i)
         
       Case #Object_String
         ProcedureReturn ~"\"" + ObjectAll\string\s + ~"\""
         
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

Define *Object.ObjectAll\Object, *SubObject

*SubObject = NewObject_List()
AddObject(*SubObject, NewObject_Integer(123))
AddObject(*SubObject, NewObject_String("Hello"))

*Object = NewObject_List()
AddObject(*Object, NewObject_Integer(456))
AddObject(*Object, NewObject_String("World"))
AddObject(*Object, *SubObject)


; ForEach *Object\list\Element()
;   Debug *Object\list\Element()
; Next

Debug GetObject(*Object)
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ---
; EnableXP