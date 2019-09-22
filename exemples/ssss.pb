Structure MINIVARIANT
  vType.L
  StructureUnion
    iVal.I
    qVal.Q
    fVal.F
    dVal.D
  EndStructureUnion
  sVal.S  
EndStructure

Structure MINIVARIANTLIST
  List Columns.MINIVARIANT()
EndStructure

NewList Bucket.MINIVARIANTLIST()

AddElement(Bucket())
AddElement(Bucket()\Columns())

Bucket()\Columns()\vType = #PB_Integer
Bucket()\Columns()\iVal = 256

AddElement(Bucket()\Columns())

Bucket()\Columns()\vType = #PB_Float
Bucket()\Columns()\fVal = #PI

AddElement(Bucket()\Columns())

Bucket()\Columns()\vType = #PB_String
Bucket()\Columns()\sVal = "Demo string."

ForEach Bucket()
  
  ForEach Bucket()\Columns()
    
    Select Bucket()\Columns()\vType
        
      Case #PB_Integer
        Debug Bucket()\Columns()\iVal
        
      Case #PB_Quad
        Debug Bucket()\Columns()\QVal
        
      Case #PB_Float
        Debug Bucket()\Columns()\fVal
        
      Case #PB_Double
        Debug Bucket()\Columns()\dVal
        
      Case #PB_String
        Debug Bucket()\Columns()\sVal
        
    EndSelect
    
  Next Bucket()\Columns()
  
Next Bucket()
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP