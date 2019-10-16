Structure Json_2
  value.s
  key.s
EndStructure
 
Structure Json_1
  Array identifiers.Json_2(0)
  timestamp.s
EndStructure
 
Structure Json_3
  value.s
EndStructure
 
Structure Json_4
  format.s
  value.s
EndStructure
 
Structure Json
  deviceSignature.Json_1
  domain.Json_3
  hmac.s
  Array secret.Json_4(0)
  deviceId.s
  subject.Json_4
  grantType.s
  Array scopes.s(0)
EndStructure
 
Define Dev.Json
 
ReDim Dev\deviceSignature\identifiers(2)
FreeArray(Dev\scopes())
 
Dev\deviceId = "idddddddddd"
Dev\deviceSignature\identifiers(0)\key = "sssss"
Dev\deviceSignature\identifiers(0)\value = "dfgdfgdfgdfgdfgd"
Dev\deviceSignature\identifiers(1)\key = "fdfgddfgf"
Dev\deviceSignature\identifiers(1)\value = "34teerer"
Dev\deviceSignature\identifiers(2)\key = "dfgdfgdf"
Dev\deviceSignature\identifiers(2)\value = "dgfdghdfhtytyt"
Dev\deviceSignature\timestamp = "2dfgdfg"
Dev\domain\value = "fgdgffg"
Dev\grantType = "dfgdfgd"
Dev\hmac = "wererwewrwer"
Dev\secret(0)\format = "erer"
Dev\secret(0)\value = "rereres"
Dev\subject\format = "445ryryL"
Dev\subject\value = "rtert4353464364"
 
If CreateJSON(0)
  InsertJSONStructure(JSONValue(0),@Dev,Json)
  Debug ComposeJSON(0, #PB_JSON_PrettyPrint)
EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP