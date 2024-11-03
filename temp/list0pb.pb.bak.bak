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
   Integer.i
EndStructure

Structure Object_String Extends ObjectHead
   String.s
EndStructure

Structure Object_List Extends ObjectHead
   List *Element.ObjectHead()
EndStructure

Structure ObjectAll  ; Object collection for all objects
   StructureUnion
      *Object.ObjectHead
      *ObjectInteger.Object_Integer
      *ObjectString.Object_String
      *ObjectList.Object_List
   EndStructureUnion
EndStructure

; Object creation procedures
 
Procedure.i NewObject_Integer(Integer.i)
   Protected *Object.Object_Integer = AllocateStructure(Object_Integer)
   *Object\Type    = #Object_Integer
   *Object\Integer = Integer
   ProcedureReturn *Object
EndProcedure

Procedure.i NewObject_String(String.s)
   Protected *Object.Object_String = AllocateStructure(Object_String)
   *Object\Type    = #Object_String
   *Object\String  = String
   ProcedureReturn *Object
EndProcedure

Procedure.i NewObject_List()
   Protected *Object.Object_List = AllocateStructure(Object_List)
   *Object\Type    = #Object_List
   ProcedureReturn *Object
EndProcedure

Procedure.i AddObject(*ObjectList.Object_List, *Element.ObjectHead)
   If *ObjectList\Type = #Object_List
      AddElement(*ObjectList\Element())
      *ObjectList\Element() = *Element
   EndIf
   ProcedureReturn *ObjectList
EndProcedure

; Object output procedure
 
Procedure.s GetObject(*Object.ObjectHead)
   Protected ObjectAll.ObjectAll\Object = *Object
   Protected String.s
   
   Select *Object\Type
      Case #Object_Integer
         ProcedureReturn Str(ObjectAll\ObjectInteger\Integer)
         
       Case #Object_String
         ProcedureReturn ~"\"" + ObjectAll\ObjectString\String + ~"\""
         
       Case #Object_List
         ForEach ObjectAll\ObjectList\Element()
            If ListIndex(ObjectAll\ObjectList\Element()) > 0 : String + ", " : EndIf
            String + GetObject(ObjectAll\ObjectList\Element())
         Next
         ProcedureReturn "["+String+"]"
   EndSelect
EndProcedure

; Example

Define *Object, *SubObject

*SubObject = NewObject_List()
AddObject(*SubObject, NewObject_Integer(123))
AddObject(*SubObject, NewObject_String("Hello"))

*Object = NewObject_List()
AddObject(*Object, NewObject_Integer(456))
AddObject(*Object, NewObject_String("World"))
AddObject(*Object, *SubObject)

Debug GetObject(*Object)
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ---
; EnableXP