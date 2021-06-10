EnableExplicit

Procedure CreateXmlExample()
	Protected xml
	Protected node, i, item
	Protected subNodeID.s, subNodeValue.s
	; create an example XML tree as per OP
	; 
	xml = CreateXML(#PB_Any)
	node = CreateXMLNode(RootXMLNode(xml), "Project")
	node = CreateXMLNode(node, "ProjectExtensions")
	node = CreateXMLNode(node, "BorlandProject")
	node = CreateXMLNode(node, "Delphi.Personality")
	node = CreateXMLNode(node, "VersionInfoKeys")
	
	Restore xmlData
	For i = 0 To 5
		Read.s subNodeID
		Read.s subNodeValue
		item = CreateXMLNode(node, "VersionInfoKeys")
		SetXMLAttribute(item, "Name", subNodeID)
		SetXMLNodeText(item, subNodeValue)
	Next i
	
	ProcedureReturn xml
EndProcedure

Procedure XMLNodeFromPathWithAttribute(ParentNode, Path.s, AttributeName.s, AttributeValue.s)
	Protected nthIndex, nthNode, nthPath.s
	Protected nodeResult
	
	Repeat
		nthIndex + 1
		nthPath = path + "[" + Str(nthIndex) + "]"
		nthNode = XMLNodeFromPath(ParentNode, nthPath)
		If Not nthNode : Break : EndIf
		If GetXMLAttribute(nthNode, AttributeName) = AttributeValue
			nodeResult = nthNode
			Break
		EndIf
	ForEver
		
	ProcedureReturn nodeResult
EndProcedure


Define xmlExample, i, infoNode, subNodeID.s, subNodeValue.s
Define VersionKeys

xmlExample = CreateXmlExample()

Debug "First Test"
Restore xmlData
For i = 0 To 5
	Read.s subNodeID
	Read.s subNodeValue
	infoNode = XMLNodeFromPathWithAttribute(RootXMLNode(xmlExample),
	                                        "Project/ProjectExtensions/BorlandProject/Delphi.Personality/VersionInfoKeys/VersionInfoKeys",
	                                        "Name", subNodeID)
	Debug LSet(subNodeID + " ", 20, ".") + " " + GetXMLNodeText(infoNode)
Next i

Debug ""
Debug "Second Test"
VersionKeys = XMLNodeFromPath(RootXMLNode(xmlExample), 
                              "/Project/ProjectExtensions/BorlandProject/Delphi.Personality/VersionInfoKeys")
If VersionKeys
	Restore xmlData
	For i = 0 To 5
		Read.s subNodeID
		Read.s subNodeValue
		infoNode = XMLNodeFromPathWithAttribute(VersionKeys, "VersionInfoKeys", "Name", subNodeID)
		Debug LSet(subNodeID + " ", 20, ".") + " " + GetXMLNodeText(infoNode)
	Next i
EndIf

DataSection
	xmlData:
	Data.s "CompanyName", "ACME Software Inc."
	Data.s "FileDescription", "ACME TimeCard Import"
	Data.s "InternalName", "ACME_TcImp.dll"
	Data.s "LegalCopyright", "Copyright © 2021 ACME Software Group Inc."
	Data.s "ProductName", "ACME Import Module"
	Data.s "ProductVersion", "2.10.1.1"
EndDataSection
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP