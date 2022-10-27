; https://www.purebasic.fr/english/viewtopic.php?f=13&t=76913
; create an example XML tree as per OP 
;
xml = CreateXML(#PB_Any) 
mainNode = CreateXMLNode(RootXMLNode(xml), "VersionInfoKeys") 

Restore xmlData
For i = 0 To 5
  Read.s subNodeID$
  Read.s subNodeValue$
  item = CreateXMLNode(mainNode, "VersionInfoKeys") 
  SetXMLAttribute(item, "Name", subNodeID$) 
  SetXMLNodeText(item, subNodeValue$)
Next i

DataSection
xmlData:
  Data.s "CompanyName", "ACME Software Inc."
  Data.s "FileDescription", "ACME TimeCard Import"
  Data.s "InternalName", "ACME_TcImp.dll"
  Data.s "LegalCopyright", "Copyright © 2021 ACME Software Group Inc."
  Data.s "ProductName", "ACME Import Module"
  Data.s "ProductVersion", "2.10.1.1"
EndDataSection


; iterate through the XML tree and extract the values
;
*node = ChildXMLNode(MainXMLNode(xml))
While *node   
  Debug GetXMLAttribute(*node, "Name") + ": " + GetXMLNodeText(*node)
  *node = NextXMLNode(*node)  
Wend 
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP