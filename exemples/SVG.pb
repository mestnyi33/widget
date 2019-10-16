

DeclareModule VectorGraphic
	
	Declare.i LoadVectorGraphic(VectorGraphic.i, FileName.s)
	Declare.i ParseVectorGraphic(VectorGraphic.i, Input.s)
	Declare   DrawVectorGraphic(VectorGraphic.i, Alpha.d=255, Width.d=0.0, Height.d=0.0)
	
EndDeclareModule



Module VectorGraphic


EnableExplicit


Structure Style
	Opacity.d
	Fill.i
	FillRule.i
	FillOpacity.d
	Stroke.i
	StrokeWidth.d
	StrokeOpacity.d
	StrokeLineCap.i
	StrokeLineJoin.i
	Array StrokeDashArray.d(0)
	StrokeDashOffset.d
EndStructure


Structure StyleSheet_Class
	Style.s
EndStructure

Structure StyleSheet_Element
	Map Class.StyleSheet_Class()
EndStructure

Structure StyleSheet
	Map Element.StyleSheet_Element()
EndStructure

Structure VectorGraphic
	XML.i
	StyleSheet.StyleSheet
EndStructure

Structure VectorGraphicInclude
	
	List  VectorGraphic.VectorGraphic()
	Array *VectorGraphicID.VectorGraphic(0)
	
	*CurrentVectorGraphic.VectorGraphic
	
	CurrentStyle.Style
	InitialStyle.Style
	ResX.d
	ResY.d
	
EndStructure


Global VectorGraphicInclude.VectorGraphicInclude

Global NewMap X11Color.i()
X11Color("aliceblue")            = $FFF8F0
X11Color("antiquewhite")         = $D7EBFA
X11Color("aqua")                 = $FFFF00
X11Color("aquamarine")           = $D4FF7F
X11Color("azure")                = $FFFFF0
X11Color("beige")                = $DCF5F5
X11Color("bisque")               = $C4E4FF
X11Color("black")                = $000000
X11Color("blanchedalmond")       = $CDEBFF
X11Color("blue")                 = $FF0000
X11Color("blueviolet")           = $E22B8A
X11Color("brown")                = $2A2AA5
X11Color("burlywood")            = $87B8DE
X11Color("cadetblue")            = $A09E5F
X11Color("chartreuse")           = $00FF7F
X11Color("chocolate")            = $1E69D2
X11Color("coral")                = $507FFF
X11Color("cornflowerblue")       = $ED9564
X11Color("cornsilk")             = $DCF8FF
X11Color("crimson")              = $3C14DC
X11Color("cyan")                 = $FFFF00
X11Color("darkblue")             = $8B0000
X11Color("darkcyan")             = $8B8B00
X11Color("darkgoldenrod")        = $0B86B8
X11Color("darkgray")             = $A9A9A9
X11Color("darkgreen")            = $006400
X11Color("darkgrey")             = $A9A9A9
X11Color("darkkhaki")            = $6BB7BD
X11Color("darkmagenta")          = $8B008B
X11Color("darkolivegreen")       = $2F6B55
X11Color("darkorange")           = $008CFF
X11Color("darkorchid")           = $CC3299
X11Color("darkred")              = $00008B
X11Color("darksalmon")           = $7A96E9
X11Color("darkseagreen")         = $8FBC8F
X11Color("darkslateblue")        = $8B3D48
X11Color("darkslategray")        = $4F4F2F
X11Color("darkslategrey")        = $4F4F2F
X11Color("darkturquoise")        = $D1CE00
X11Color("darkviolet")           = $D30094
X11Color("deeppink")             = $9314FF
X11Color("deepskyblue")          = $FFBF00
X11Color("dimgray")              = $696969
X11Color("dimgrey")              = $696969
X11Color("dodgerblue")           = $FF901E
X11Color("firebrick")            = $2222B2
X11Color("floralwhite")          = $F0FAFF
X11Color("forestgreen")          = $228B22
X11Color("fuchsia")              = $FF00FF
X11Color("gainsboro")            = $DCDCDC
X11Color("ghostwhite")           = $FFF8F8
X11Color("gold")                 = $00D7FF
X11Color("goldenrod")            = $20A5DA
X11Color("gray")                 = $808080
X11Color("green")                = $008000
X11Color("greenyellow")          = $2FFFAD
X11Color("grey")                 = $808080
X11Color("honeydew")             = $F0FFF0
X11Color("hotpink")              = $B469FF
X11Color("indianred")            = $5C5CCD
X11Color("indigo")               = $82004B
X11Color("ivory")                = $F0FFFF
X11Color("khaki")                = $8CE6F0
X11Color("lavender")             = $FAE6E6
X11Color("lavenderblush")        = $F5F0FF
X11Color("lawngreen")            = $00FC7C
X11Color("lemonchiffon")         = $CDFAFF
X11Color("lightblue")            = $E6D8AD
X11Color("lightcoral")           = $8080F0
X11Color("lightcyan")            = $FFFFE0
X11Color("lightgoldenrodyellow") = $D2FAFA
X11Color("lightgray")            = $D3D3D3
X11Color("lightgreen")           = $90EE90
X11Color("lightgrey")            = $D3D3D3
X11Color("lightpink")            = $C1B6FF
X11Color("lightsalmon")          = $7AA0FF
X11Color("lightseagreen")        = $AAB220
X11Color("lightskyblue")         = $FACE87
X11Color("lightslategray")       = $998877
X11Color("lightslategrey")       = $998877
X11Color("lightsteelblue")       = $DEC4B0
X11Color("lightyellow")          = $E0FFFF
X11Color("lime")                 = $00FF00
X11Color("limegreen")            = $32CD32
X11Color("linen")                = $E6F0FA
X11Color("magenta")              = $FF00FF
X11Color("maroon")               = $000080
X11Color("mediumaquamarine")     = $AACD66
X11Color("mediumblue")           = $CD0000
X11Color("mediumorchid")         = $D355BA
X11Color("mediumpurple")         = $DB7093
X11Color("mediumseagreen")       = $71B33C
X11Color("mediumslateblue")      = $EE687B
X11Color("mediumspringgreen")    = $9AFA00
X11Color("mediumturquoise")      = $CCD148
X11Color("mediumvioletred")      = $8515C7
X11Color("midnightblue")         = $701919
X11Color("mintcream")            = $FAFFF5
X11Color("mistyrose")            = $E1E4FF
X11Color("moccasin")             = $B5E4FF
X11Color("navajowhite")          = $ADDEFF
X11Color("navy")                 = $800000
X11Color("oldlace")              = $E6F5FD
X11Color("olive")                = $008080
X11Color("olivedrab")            = $238E6B
X11Color("orange")               = $00A5FF
X11Color("orangered")            = $0045FF
X11Color("orchid")               = $D670DA
X11Color("palegoldenrod")        = $AAE8EE
X11Color("palegreen")            = $98FB98
X11Color("paleturquoise")        = $EEEEAF
X11Color("palevioletred")        = $9370DB
X11Color("papayawhip")           = $D5EFFF
X11Color("peachpuff")            = $B9DAFF
X11Color("peru")                 = $3F85CD
X11Color("pink")                 = $CBC0FF
X11Color("plum")                 = $DDA0DD
X11Color("powderblue")           = $E6E0B0
X11Color("purple")               = $800080
X11Color("red")                  = $0000FF
X11Color("rosybrown")            = $8F8FBC
X11Color("royalblue")            = $E16941
X11Color("saddlebrown")          = $13458B
X11Color("salmon")               = $7280FA
X11Color("sandybrown")           = $60A4F4
X11Color("seagreen")             = $578B2E
X11Color("seashell")             = $EEF5FF
X11Color("sienna")               = $2D52A0
X11Color("silver")               = $C0C0C0
X11Color("skyblue")              = $EBCE87
X11Color("slateblue")            = $CD5A6A
X11Color("slategray")            = $908070
X11Color("slategrey")            = $908070
X11Color("snow")                 = $FAFAFF
X11Color("springgreen")          = $7FFF00
X11Color("steelblue")            = $B48246
X11Color("tan")                  = $8CB4D2
X11Color("teal")                 = $808000
X11Color("thistle")              = $D8BFD8
X11Color("tomato")               = $4763FF
X11Color("turquoise")            = $D0E040
X11Color("violet")               = $EE82EE
X11Color("wheat")                = $B3DEF5
X11Color("white")                = $FFFFFF
X11Color("whitesmoke")           = $F5F5F5
X11Color("yellow")               = $00FFFF
X11Color("yellowgreen")          = $32CD9A



Declare   TransformCoordinates(A.d, B.d, C.d, D.d, E.d, F.d, System.i=#PB_Coordinate_User)
Declare.i Parse_Attribute_Color(String.s)
Declare.d Parse_Attribute_Value(*Node, String.s="")
Declare   Parse_Attribute_Style(String.s, *Style.Style=#Null)
Declare.s Parse_Attribute_String(*Node, String.s="")
Declare   Parse_Attribute_Transform(String.s)
Declare.i Parse_Attribute_Presentation(*Node)
Declare   Draw_Group(*Node, Indent.i=0)
Declare   Draw_Circle(*Node)
Declare   Draw_Ellipse(*Node)
Declare   Draw_Rectangle(*Node)
Declare   Draw_Line(*Node)
Declare   Draw_Path(*Node)
Declare   Draw(*Node, Indent.i=0)
Declare.i VectorGraphicID(VectorGraphic)
Declare.i LoadVectorGraphic(VectorGraphic.i, FileName.s)
Declare DrawVectorGraphic(VectorGraphic.i, Alpha.d=255, Width.d=0.0, Height.d=0.0)




Procedure   TransformCoordinates(A.d, B.d, C.d, D.d, E.d, F.d, System.i=#PB_Coordinate_User)
	
	; Single matrices:
	;   Translation: {{1, 0, Tx}, {0, 1, Ty}, {0, 0, 1}}
	;   Rotation:    {{Cos[Phi], -Sin[Phi], 0}, {Sin[Phi], Cos[Phi], 0}, {0, 0, 1}}
	;   Skew:        {{1+Tan[ThetaX]*Tan[ThetaY], Tan[ThetaX], 0}, {Tan[ThetaY], 1, 0}, {0, 0, 1}}
	;   Scale:       {{Sx, 0, 0}, {0, Sy, 0}, {0, 0, 1}}
	; Transformation = Translation * Rotation * Skew * Scale
	
	; Transformation(A,B,C,D,E,F) -> Translation(Tx,Ty) * Rotation(Phi) * Skew(ThetaX,ThetaY) * Scale(Sx,Sy)
	;   Simplification: ThetaY = 0, because ThetaY can be represented with ThetaX together with Scale and Rotation
	
	Protected Tx.d, Ty.d, Phi.d, ThetaX.d, Sx.d, Sy.d
	Protected Column.d = 1.0 / Sqr( A*A + B*B ) 
	
	Tx       = E
	Ty       = F
	Sx       = A*A*Column + B*B*Column
	Sy       = A*D*Column - B*C*Column
	Phi.d    = Degree(ATan2(A*Column, B*Column))
	ThetaX.d = Degree(ATan((-A*C-B*D)/(B*C-A*D)))
	
	TranslateCoordinates(Tx, Ty, System)
	RotateCoordinates(0.0, 0.0, Phi, System)
	SkewCoordinates(ThetaX, 0.0, System)
	ScaleCoordinates(Sx, Sy, System)
	
EndProcedure

;- Parsing

Procedure.i Parse_Attribute_Color(String.s)
	
	; http://www.w3.org/TR/2008/REC-SVGTiny12-20081222/painting.html#colorSyntax
	
	Static RegEx_Color.i
	Protected Color.s
	
	If RegEx_Color = #Null
		RegEx_Color = CreateRegularExpression(#PB_Any, "((?<=\#)[0-9A-Fa-f]{3}\b) | ((?<=\#)[0-9A-Fa-f]{6}\b) | (rgb\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)) | (rgb\(\s*(\d+\.?\d*)%\s*,\s*(\d+\.?\d*)%\s*,\s*(\d+\.?\d*)%\s*\))", #PB_RegularExpression_Extended)
	EndIf
	
	If ExamineRegularExpression(RegEx_Color, String) And NextRegularExpressionMatch(RegEx_Color)
		If RegularExpressionGroup(RegEx_Color, 1) ; Three digit hex - #rgb
			Color.s = RegularExpressionGroup(RegEx_Color, 1)
			ProcedureReturn RGB(Val("$"+Mid(Color,1,1))*17, Val("$"+Mid(Color,2,1))*17, Val("$"+Mid(Color,3,1))*17)
		EndIf
		If RegularExpressionGroup(RegEx_Color, 2) ; Six digit hex - #rrggbb
			Color.s = RegularExpressionGroup(RegEx_Color, 2)
			ProcedureReturn RGB(Val("$"+Mid(Color,1,2)), Val("$"+Mid(Color,3,2)), Val("$"+Mid(Color,5,2)))
		EndIf
		If RegularExpressionGroup(RegEx_Color, 3) ; Integer functional - rgb(rrr, ggg, bbb)
			ProcedureReturn RGB(Val(RegularExpressionGroup(RegEx_Color, 4)), Val(RegularExpressionGroup(RegEx_Color, 5)), Val(RegularExpressionGroup(RegEx_Color, 6)))
		EndIf
		If RegularExpressionGroup(RegEx_Color, 7) ; Integer functional - rgb(rrr, ggg, bbb)
			ProcedureReturn RGB(2.55*ValD(RegularExpressionGroup(RegEx_Color, 8)), 2.55*ValD(RegularExpressionGroup(RegEx_Color, 9)), 2.55*ValD(RegularExpressionGroup(RegEx_Color, 10)))
		EndIf
	EndIf
	
	If FindMapElement(X11Color(), String)
		ProcedureReturn X11Color()
	Else
		ProcedureReturn -1
	EndIf
	
EndProcedure

Procedure   Parse_Attribute_Transform(String.s)
	
	; http://www.w3.org/TR/2008/REC-SVGTiny12-20081222/coords.html#TransformAttribute
	
	Static RegEx_Command.i, RegEx_Value.i
	Protected X.d, Y.d, Angle.d
	Protected A.d, B.d, C.d, D.d, E.d, F.f
	
	If RegEx_Command = #Null
		RegEx_Command = CreateRegularExpression(#PB_Any, "(\w+)\(([^\)]*)\)")
	EndIf
	If RegEx_Value = #Null
		RegEx_Value = CreateRegularExpression(#PB_Any, "\-?\d+\.?\d*|\-?\.\d+")
	EndIf
	
	If ExamineRegularExpression(RegEx_Command, String)
		While NextRegularExpressionMatch(RegEx_Command)
			Select LCase(RegularExpressionGroup(RegEx_Command, 1))
				
				Case "matrix"
					If ExamineRegularExpression(RegEx_Value, RegularExpressionGroup(RegEx_Command, 2))
						A = 0.0 : B = 0.0 : C = 0.0 : D = 0.0 : E = 0.0 : F = 0.0
						If NextRegularExpressionMatch(RegEx_Value) : A = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						If NextRegularExpressionMatch(RegEx_Value) : B = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						If NextRegularExpressionMatch(RegEx_Value) : C = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						If NextRegularExpressionMatch(RegEx_Value) : D = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						If NextRegularExpressionMatch(RegEx_Value) : E = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						If NextRegularExpressionMatch(RegEx_Value) : F = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						TransformCoordinates(A, B, C, D, E, F) ;: Debug "matrix("+StrD(A)+", "+StrD(B)+", "+StrD(C)+", "+StrD(D)+", "+StrD(E)+", "+StrD(F)+")"
					EndIf
					
				Case "translate"
					If ExamineRegularExpression(RegEx_Value, RegularExpressionGroup(RegEx_Command, 2))
						X = 0.0 : Y = 0.0
						If NextRegularExpressionMatch(RegEx_Value) : X = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						If NextRegularExpressionMatch(RegEx_Value) : Y = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						TranslateCoordinates(X, Y) ;: Debug "translate("+StrD(X)+", "+StrD(Y)+")"
					EndIf
					
				Case "scale"
					If ExamineRegularExpression(RegEx_Value, RegularExpressionGroup(RegEx_Command, 2))
						X = 0.0 : Y = 0.0
						If NextRegularExpressionMatch(RegEx_Value) : X = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						If NextRegularExpressionMatch(RegEx_Value) : Y = ValD(RegularExpressionMatchString(RegEx_Value)) : Else : Y = X : EndIf
						ScaleCoordinates(X, Y) ;: Debug "scale("+StrD(X)+", "+StrD(Y)+")"
					EndIf
				
				Case "rotate"
					If ExamineRegularExpression(RegEx_Value, RegularExpressionGroup(RegEx_Command, 2))
						X = 0.0 : Y = 0.0 : Angle = 0.0
						If NextRegularExpressionMatch(RegEx_Value) : Angle = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						If NextRegularExpressionMatch(RegEx_Value) : X = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						If NextRegularExpressionMatch(RegEx_Value) : Y = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						RotateCoordinates(X, Y, Angle) ;: Debug "rotate("+StrD(Angle)+", "+StrD(X)+", "+StrD(Y)+")"
					EndIf
					
				Case "skewx"
					If ExamineRegularExpression(RegEx_Value, RegularExpressionGroup(RegEx_Command, 2))
						Angle = 0.0
						If NextRegularExpressionMatch(RegEx_Value) : Angle = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						SkewCoordinates(Angle, 0) ;: Debug "skewX("+StrD(Angle)+")"
					EndIf
					
				Case "skewy"
					If ExamineRegularExpression(RegEx_Value, RegularExpressionGroup(RegEx_Command, 2))
						Angle = 0.0
						If NextRegularExpressionMatch(RegEx_Value) : Angle = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						SkewCoordinates(0, Angle) ;: Debug "skewY("+StrD(Angle)+")"
					EndIf
				
			EndSelect
		Wend
	EndIf
	
	ProcedureReturn ValD(String)
	
EndProcedure

Procedure   Parse_Attribute_Style(String.s, *Style.Style=#Null)
	
	Static RegEx_Style.i
	
	If RegEx_Style = #Null
		RegEx_Style = CreateRegularExpression(#PB_Any, "([\w\-]+)\s*\:\s*([^;]*);?")
	EndIf
	
	If *Style = #Null
		*Style = VectorGraphicInclude\CurrentStyle
	EndIf
	
	With *Style
		If ExamineRegularExpression(RegEx_Style, String)
			While NextRegularExpressionMatch(RegEx_Style)
				Select LCase(RegularExpressionGroup(RegEx_Style, 1))
					Case "opacity"
						\Opacity     = Parse_Attribute_Value(#Null, RegularExpressionGroup(RegEx_Style, 2))
					Case "fill"
						\Fill        = Parse_Attribute_Color(RegularExpressionGroup(RegEx_Style, 2))
					Case "fill-rule"
						Select LCase(Trim(RegularExpressionGroup(RegEx_Style, 2)))
							Case "nonzero"
								\FillRule = #PB_Path_Winding
							Case "evenodd"
								\FillRule = #PB_Path_Default
						EndSelect
					Case "fill-opacity"
						\FillOpacity = Parse_Attribute_Value(#Null, RegularExpressionGroup(RegEx_Style, 2))
					Case "stroke"
						\Stroke      = Parse_Attribute_Color(RegularExpressionGroup(RegEx_Style, 2))
					Case "stroke-opacity"
						\StrokeOpacity = Parse_Attribute_Value(#Null, RegularExpressionGroup(RegEx_Style, 2))
					Case "stroke-width"
						\StrokeWidth = Parse_Attribute_Value(#Null, RegularExpressionGroup(RegEx_Style, 2))
					Case "stroke-linecap"
						Select LCase(Trim(RegularExpressionGroup(RegEx_Style, 2)))
							Case "butt"
								\StrokeLineCap = #PB_Path_Default
							Case "round"
								\StrokeLineCap = #PB_Path_RoundEnd
							Case "square"
								\StrokeLineCap = #PB_Path_SquareEnd
						EndSelect
					Case "stroke-linejoin"
						Select LCase(Trim(RegularExpressionGroup(RegEx_Style, 2)))
							Case "miter"
								\StrokeLineJoin = #PB_Path_Default
							Case "round"
								\StrokeLineJoin = #PB_Path_RoundCorner
							Case "bevel"
								\StrokeLineJoin = #PB_Path_DiagonalCorner
						EndSelect
				EndSelect
			Wend
		EndIf
	EndWith
	
EndProcedure

Procedure.d Parse_Attribute_Value(*Node, String.s="")
	
	If String = ""
		String = XMLAttributeValue(*Node)
	EndIf
	
	ProcedureReturn ValD(String)
	
EndProcedure

Procedure.d Parse_Attribute_Length(String.s, Reference.d=0.0)
	
	Static RegEx_Length.i
	Protected Value.d
	
	If RegEx_Length = #Null
		RegEx_Length = CreateRegularExpression(#PB_Any, "(\d+\.?\d*|\.\d+)\s*(px|in|cm|mm|pt|\%)?", #PB_RegularExpression_NoCase)
	EndIf
	
	If ExamineRegularExpression(RegEx_Length, String) And NextRegularExpressionMatch(RegEx_Length)
		Value = ValD(RegularExpressionGroup(RegEx_Length, 1))
		Select LCase(RegularExpressionGroup(RegEx_Length, 2))
			Case "px"
				ProcedureReturn Value
			Case "in"
				ProcedureReturn Value * VectorGraphicInclude\ResX
			Case "cm"
				ProcedureReturn Value * VectorGraphicInclude\ResX / 2.54
			Case "mm"
				ProcedureReturn Value * VectorGraphicInclude\ResX / 25.4
			Case "pt"
				ProcedureReturn Value * VectorGraphicInclude\ResX / 72.0
			Case "%"
				ProcedureReturn Reference * Value / 100.0
		EndSelect
	EndIf
	
	ProcedureReturn Value
	
EndProcedure

Procedure.s Parse_Attribute_String(*Node, String.s="")
	
	If String = ""
		String = XMLAttributeValue(*Node)
	EndIf
	
	ProcedureReturn String
	
EndProcedure

Procedure.i Parse_Attribute_Presentation(*Node)
	
	Static RegEx_Value.i
	
	If RegEx_Value = #Null
		RegEx_Value = CreateRegularExpression(#PB_Any, "\-?\d+\.?\d*|\-?\.\d+")
	EndIf
	
	With VectorGraphicInclude\CurrentStyle
		Select LCase(XMLAttributeName(*Node))
			Case "transform"
				Parse_Attribute_Transform(XMLAttributeValue(*Node))
			Case "style"
				Parse_Attribute_Style(XMLAttributeValue(*Node))
			Case "opacity"
				\Opacity = Parse_Attribute_Value(*Node)
			Case "stroke"
				\Stroke      = Parse_Attribute_Color(XMLAttributeValue(*Node))
			Case "stroke-opacity"
				\StrokeOpacity = Parse_Attribute_Value(*Node)
			Case "stroke-width"
				\StrokeWidth = Parse_Attribute_Value(*Node)
			Case "stroke-linecap"
				Select LCase(Trim(XMLAttributeValue(*Node)))
					Case "butt"
						\StrokeLineCap = #PB_Path_Default
					Case "round"
						\StrokeLineCap = #PB_Path_RoundEnd
					Case "square"
						\StrokeLineCap = #PB_Path_SquareEnd
				EndSelect
			Case "stroke-linejoin"
				Select LCase(Trim(XMLAttributeValue(*Node)))
					Case "miter"
						\StrokeLineJoin = #PB_Path_Default
					Case "round"
						\StrokeLineJoin = #PB_Path_RoundCorner
					Case "bevel"
						\StrokeLineJoin = #PB_Path_DiagonalCorner
				EndSelect
			Case "stroke-dashoffset"
				\StrokeDashOffset = Parse_Attribute_Value(*Node)
			Case "stroke-dasharray"
				If ExamineRegularExpression(RegEx_Value, XMLAttributeValue(*Node))
					While NextRegularExpressionMatch(RegEx_Value)
						If ArraySize(\StrokeDashArray()) = -1
							Dim \StrokeDashArray(0)
						Else
							ReDim \StrokeDashArray(ArraySize(\StrokeDashArray())+1)
						EndIf
						\StrokeDashArray(ArraySize(\StrokeDashArray())) = ValD(RegularExpressionMatchString(RegEx_Value))
					Wend
				EndIf
			Case "fill"
				\Fill        = Parse_Attribute_Color(XMLAttributeValue(*Node))
			Case "fill-opacity"
				\FillOpacity = Parse_Attribute_Value(*Node)
			Case "fill-rule"
				Select LCase(Trim(XMLAttributeValue(*Node)))
					Case "nonzero"
						\FillRule = #PB_Path_Winding
					Case "evenodd"
						\FillRule = #PB_Path_Default
				EndSelect
		EndSelect
	EndWith
	
EndProcedure

;- Drawing

Procedure   StyleSheets(Element.s="", Class.s="")
	
	With VectorGraphicInclude\CurrentStyle
		
		If Element And FindMapElement(VectorGraphicInclude\CurrentVectorGraphic\StyleSheet\Element(), Element) 
			If FindMapElement(VectorGraphicInclude\CurrentVectorGraphic\StyleSheet\Element()\Class(), "")
				Parse_Attribute_Style(VectorGraphicInclude\CurrentVectorGraphic\StyleSheet\Element()\Class()\Style)
			EndIf
			If Class And FindMapElement(VectorGraphicInclude\CurrentVectorGraphic\StyleSheet\Element()\Class(), Class)
				Parse_Attribute_Style(VectorGraphicInclude\CurrentVectorGraphic\StyleSheet\Element()\Class()\Style)
			EndIf
		EndIf
		If Class And FindMapElement(VectorGraphicInclude\CurrentVectorGraphic\StyleSheet\Element(), "") And FindMapElement(VectorGraphicInclude\CurrentVectorGraphic\StyleSheet\Element()\Class(), Class)
			Parse_Attribute_Style(VectorGraphicInclude\CurrentVectorGraphic\StyleSheet\Element()\Class()\Style)
		EndIf
		
	EndWith
	
EndProcedure

Procedure   Rendering()
	
	With VectorGraphicInclude\CurrentStyle
		
		If \Opacity = 1.0
			If \Fill <> -1
				VectorSourceColor(\Fill | Int(255*\FillOpacity)<<24)
				FillPath(\FillRule|#PB_Path_Preserve)
			EndIf
			If \Stroke <> -1
				VectorSourceColor(\Stroke | Int(255*\StrokeOpacity)<<24)
				If ArraySize(\StrokeDashArray()) <> -1
					CustomDashPath(\StrokeWidth, \StrokeDashArray(), \StrokeLineCap|\StrokeLineJoin|#PB_Path_Preserve, \StrokeDashOffset)
				Else
					StrokePath(\StrokeWidth, \StrokeLineCap|\StrokeLineJoin|#PB_Path_Preserve)
				EndIf
			EndIf
		ElseIf \Opacity > 0.0
			BeginVectorLayer(255*\Opacity)
			If \Fill <> -1
				VectorSourceColor(\Fill | Int(255*\FillOpacity)<<24)
				FillPath(\FillRule|#PB_Path_Preserve)
			EndIf
			If \Stroke <> -1
				VectorSourceColor(\Stroke | Int(255*\StrokeOpacity)<<24)
				If ArraySize(\StrokeDashArray()) <> -1
					CustomDashPath(\StrokeWidth, \StrokeDashArray(), \StrokeLineCap|\StrokeLineJoin|#PB_Path_Preserve, \StrokeDashOffset)
				Else
					StrokePath(\StrokeWidth, \StrokeLineCap|\StrokeLineJoin|#PB_Path_Preserve)
				EndIf
			EndIf
			EndVectorLayer()
		EndIf
		
		ResetPath()
	EndWith
	
EndProcedure

Procedure   Draw_Group(*Node, Indent.i=0)
	
	Protected *ChildNode
	Protected PushedStyle.Style
	
	PushedStyle.Style = VectorGraphicInclude\CurrentStyle
	BeginVectorLayer()
	
	If ExamineXMLAttributes(*Node)
		While NextXMLAttribute(*Node)
			Select LCase(XMLAttributeName(*Node))
				Case "transform"
					Parse_Attribute_Transform(XMLAttributeValue(*Node))
				Default
					Parse_Attribute_Presentation(*Node)
			EndSelect
		Wend
	EndIf
	
	*ChildNode = ChildXMLNode(*Node)
	While *ChildNode
		Draw(*ChildNode, Indent+1)
		*ChildNode = NextXMLNode(*ChildNode)
	Wend
	
	EndVectorLayer()
	VectorGraphicInclude\CurrentStyle = PushedStyle
	
EndProcedure

Procedure   Draw_Circle(*Node)
	
	Protected CX.d, CY.d, R.d
	Protected PushedStyle.Style
	
	PushedStyle.Style = VectorGraphicInclude\CurrentStyle
	SaveVectorState()
	
	StyleSheets("circle", Trim(LCase(GetXMLAttribute(*Node, "class"))))
	
	If ExamineXMLAttributes(*Node)
		While NextXMLAttribute(*Node)
			Select LCase(XMLAttributeName(*Node))
				Case "cx"
					CX = Parse_Attribute_Value(*Node)
				Case "cy"
					CY = Parse_Attribute_Value(*Node)
				Case "r"
					R = Parse_Attribute_Value(*Node)
				Default
					Parse_Attribute_Presentation(*Node)
			EndSelect
		Wend
	EndIf
	
	AddPathCircle(CX, CY, R)
	
	Rendering()
	
	RestoreVectorState()
	VectorGraphicInclude\CurrentStyle = PushedStyle
	
EndProcedure

Procedure   Draw_Ellipse(*Node)
	
	Protected CX.d, CY.d, RX.d, RY.d
	Protected PushedStyle.Style
	
	PushedStyle.Style = VectorGraphicInclude\CurrentStyle
	SaveVectorState()
	
	StyleSheets("ellipse", Trim(LCase(GetXMLAttribute(*Node, "class"))))
	
	If ExamineXMLAttributes(*Node)
		While NextXMLAttribute(*Node)
			Select LCase(XMLAttributeName(*Node))
				Case "cx"
					CX = Parse_Attribute_Value(*Node)
				Case "cy"
					CY = Parse_Attribute_Value(*Node)
				Case "rx"
					RX = Parse_Attribute_Value(*Node)
				Case "ry"
					RY = Parse_Attribute_Value(*Node)
				Default
					Parse_Attribute_Presentation(*Node)
			EndSelect
		Wend
	EndIf
	
	AddPathEllipse(CX, CY, RX, RY)
	
	Rendering()
	
	RestoreVectorState()
	VectorGraphicInclude\CurrentStyle = PushedStyle
	
EndProcedure

Procedure   Draw_Rectangle(*Node)
	
	Protected Width.d, Height.d, X.d=0.0, Y.d=0.0, RX.d=0.0, RY.d=0.0
	Protected PushedStyle.Style
	
	PushedStyle.Style = VectorGraphicInclude\CurrentStyle
	SaveVectorState()
	
	StyleSheets("rect", Trim(LCase(GetXMLAttribute(*Node, "class"))))
	
	If ExamineXMLAttributes(*Node)
		While NextXMLAttribute(*Node)
			Select LCase(XMLAttributeName(*Node))
				Case "x"
					X = Parse_Attribute_Value(*Node)
				Case "y"
					Y = Parse_Attribute_Value(*Node)
				Case "width"
					Width = Parse_Attribute_Value(*Node)
				Case "height"
					Height = Parse_Attribute_Value(*Node)
				Case "rx"
					RX = Parse_Attribute_Value(*Node)
				Case "ry"
					RY = Parse_Attribute_Value(*Node)
				Default
					Parse_Attribute_Presentation(*Node)
			EndSelect
		Wend
	EndIf
	
	If RX = 0.0 And RY = 0.0
		AddPathBox(X, Y, Width, Height)
	Else
		If RX = 0.0 : RX = RY : EndIf
		If RY = 0.0 : RY = RX : EndIf
		If RX > Width/2 : RX = Width/2 : EndIf
		If RY > Height/2 : RY = Height/2 : EndIf
		If Width < 0 :  X + Width : Width = -Width : EndIf
		If Height < 0 : Y + Height : Height = -Height : EndIf
		MovePathCursor(X, Y+RY)
		AddPathEllipse(RX, 0, RX, RY, 180, 270, #PB_Path_Relative)
		AddPathEllipse(Width-2*RX, RY, RX, RY, 270, 360, #PB_Path_Relative|#PB_Path_Connected)
		AddPathEllipse(-RX, Height-2*RY, RX, RY, 0, 90, #PB_Path_Relative|#PB_Path_Connected)
		AddPathEllipse(-Width+2*RX, -RY, RX, RY, 90, 180, #PB_Path_Relative|#PB_Path_Connected)
		ClosePath()
	EndIf
	
	Rendering()
	
	RestoreVectorState()
	VectorGraphicInclude\CurrentStyle = PushedStyle
	
EndProcedure

Procedure   Draw_Line(*Node)
	
	Protected X1.d, Y1.d, X2.d, Y2.d
	Protected PushedStyle.Style
	
	PushedStyle.Style = VectorGraphicInclude\CurrentStyle
	SaveVectorState()
	
	StyleSheets("line", Trim(LCase(GetXMLAttribute(*Node, "class"))))
	
	If ExamineXMLAttributes(*Node)
		While NextXMLAttribute(*Node)
			Select LCase(XMLAttributeName(*Node))
				Case "x1"
					X1 = Parse_Attribute_Value(*Node)
				Case "y1"
					Y1 = Parse_Attribute_Value(*Node)
				Case "x2"
					X2 = Parse_Attribute_Value(*Node)
				Case "y2"
					Y2 = Parse_Attribute_Value(*Node)
				Default
					Parse_Attribute_Presentation(*Node)
			EndSelect
		Wend
	EndIf
	
	MovePathCursor(X1, Y1)
	AddPathLine(X2, Y2)
	
	Rendering()
	
	RestoreVectorState()
	VectorGraphicInclude\CurrentStyle = PushedStyle
	
EndProcedure

Procedure   Draw_Text(*Node)
	
	Protected X.d, Y.d, Text.s
	Protected PushedStyle.Style
	
	PushedStyle.Style = VectorGraphicInclude\CurrentStyle
	SaveVectorState()
	
	StyleSheets("text", Trim(LCase(GetXMLAttribute(*Node, "class"))))
	
	Text = GetXMLNodeText(*Node)
	
	If ExamineXMLAttributes(*Node)
		While NextXMLAttribute(*Node)
			Select LCase(XMLAttributeName(*Node))
				Case "x"
					X = Parse_Attribute_Value(*Node)
				Case "y"
					Y = Parse_Attribute_Value(*Node)
				Default
					Parse_Attribute_Presentation(*Node)
			EndSelect
		Wend
	EndIf
	
	MovePathCursor(X, Y)
	AddPathText(Text)
	
	Rendering()
	
	RestoreVectorState()
	VectorGraphicInclude\CurrentStyle = PushedStyle
	
EndProcedure

Procedure   Draw_Polyline(*Node)
	
	Static RegEx_Points.i
	Protected Points.s, X.d, Y.d
	Protected PushedStyle.Style
	
	PushedStyle.Style = VectorGraphicInclude\CurrentStyle
	SaveVectorState()
	
	StyleSheets("polyline", Trim(LCase(GetXMLAttribute(*Node, "class"))))
	
	If RegEx_Points = #Null
		RegEx_Points = CreateRegularExpression(#PB_Any, "\-?\d+\.?\d*|\.\d+")
	EndIf
	
	If ExamineXMLAttributes(*Node)
		While NextXMLAttribute(*Node)
			Select LCase(XMLAttributeName(*Node))
				Case "points"
					Points = Parse_Attribute_String(*Node)
				Default
					Parse_Attribute_Presentation(*Node)
			EndSelect
		Wend
	EndIf
	
	If ExamineRegularExpression(RegEx_Points, Points)
		If NextRegularExpressionMatch(RegEx_Points) : X = ValD(RegularExpressionMatchString(RegEx_Points)) : EndIf
		If NextRegularExpressionMatch(RegEx_Points) : Y = ValD(RegularExpressionMatchString(RegEx_Points)) : EndIf
		MovePathCursor(X, Y)
		Repeat
			If NextRegularExpressionMatch(RegEx_Points) : X = ValD(RegularExpressionMatchString(RegEx_Points)) : Else : Break : EndIf
			If NextRegularExpressionMatch(RegEx_Points) : Y = ValD(RegularExpressionMatchString(RegEx_Points)) : Else : Break : EndIf
			AddPathLine(X, Y)
		ForEver
	EndIf
	
	Rendering()
	
	RestoreVectorState()
	VectorGraphicInclude\CurrentStyle = PushedStyle
	
EndProcedure

Procedure   Draw_Polygon(*Node)
	
	Static RegEx_Points.i
	Protected Points.s, X.d, Y.d
	Protected PushedStyle.Style
	
	PushedStyle.Style = VectorGraphicInclude\CurrentStyle
	SaveVectorState()
	
	StyleSheets("polygon", Trim(LCase(GetXMLAttribute(*Node, "class"))))
	
	If RegEx_Points = #Null
		RegEx_Points = CreateRegularExpression(#PB_Any, "\-?\d+\.?\d*")
	EndIf
	
	If ExamineXMLAttributes(*Node)
		While NextXMLAttribute(*Node)
			Select LCase(XMLAttributeName(*Node))
				Case "points"
					Points = Parse_Attribute_String(*Node)
				Default
					Parse_Attribute_Presentation(*Node)
			EndSelect
		Wend
	EndIf
	
	If ExamineRegularExpression(RegEx_Points, Points)
		If NextRegularExpressionMatch(RegEx_Points) : X = ValD(RegularExpressionMatchString(RegEx_Points)) : EndIf
		If NextRegularExpressionMatch(RegEx_Points) : Y = ValD(RegularExpressionMatchString(RegEx_Points)) : EndIf
		MovePathCursor(X, Y)
		Repeat
			If NextRegularExpressionMatch(RegEx_Points) : X = ValD(RegularExpressionMatchString(RegEx_Points)) : Else : Break : EndIf
			If NextRegularExpressionMatch(RegEx_Points) : Y = ValD(RegularExpressionMatchString(RegEx_Points)) : Else : Break : EndIf
			AddPathLine(X, Y)
		ForEver
		ClosePath()
	EndIf
	
	Rendering()
	
	RestoreVectorState()
	VectorGraphicInclude\CurrentStyle = PushedStyle
	
EndProcedure

Procedure   Draw_Path(*Node)
	
	Protected Path.s
	Protected PushedStyle.Style
	
	PushedStyle.Style = VectorGraphicInclude\CurrentStyle
	SaveVectorState()
	
	StyleSheets("path", Trim(LCase(GetXMLAttribute(*Node, "class"))))
	
	If ExamineXMLAttributes(*Node)
		While NextXMLAttribute(*Node)
			Select LCase(XMLAttributeName(*Node))
				Case "d"
					Path = Parse_Attribute_String(*Node)
				Default
					Parse_Attribute_Presentation(*Node)
			EndSelect
		Wend
	EndIf
	
	AddPathSegments(Path)
	
	Rendering()
	
	RestoreVectorState()
	VectorGraphicInclude\CurrentStyle = PushedStyle
	
EndProcedure

Procedure   Draw_Definition(*Node)
	
	Protected *ChildNode
	
	*ChildNode = ChildXMLNode(*Node)
	While *ChildNode
		Draw(*ChildNode)
		*ChildNode = NextXMLNode(*ChildNode)
	Wend
	
EndProcedure

Procedure   Draw_Style(*Node)
	
	Static RegEx_Definition.i
	Protected StyleSheet.s
	Protected Element.s, Class.s, Style.s
	
	If RegEx_Definition = #Null
		RegEx_Definition = CreateRegularExpression(#PB_Any, "(\w*)(?:\.(\w+))?\s*\{([^\}]*)\}")
	EndIf
	
	If ChildXMLNode(*Node)
		StyleSheet = GetXMLNodeText(ChildXMLNode(*Node))
	Else
		StyleSheet = GetXMLNodeText(*Node)
	EndIf
	
	If ExamineRegularExpression(RegEx_Definition, StyleSheet)
		While NextRegularExpressionMatch(RegEx_Definition)
			Element = LCase(RegularExpressionGroup(RegEx_Definition, 1))
			Class   = LCase(RegularExpressionGroup(RegEx_Definition, 2))
			Style   = RegularExpressionGroup(RegEx_Definition, 3)
			VectorGraphicInclude\CurrentVectorGraphic\StyleSheet\Element(Element)\Class(Class)\Style = Style
		Wend
	EndIf
	
EndProcedure

Procedure   Draw(*Node, Indent.i=0)
	
	Protected *ChildNode
	
	If XMLNodeType(*Node) = #PB_XML_Normal
		
		Select LCase(GetXMLNodeName(*Node))
			Case "circle"
				Draw_Circle(*Node)
			Case "ellipse"
				Draw_Ellipse(*Node)
			Case "rect"
				Draw_Rectangle(*Node)
			Case "line"
				Draw_Line(*Node)
			Case "polyline"
				Draw_Polyline(*Node)
			Case "polygon"
				Draw_Polygon(*Node)
			Case "path"
				Draw_Path(*Node)
			Case "text"
				Draw_Text(*Node)
			Case "g"
				Draw_Group(*Node, Indent)
			Case "defs"
				Draw_Definition(*Node)
			Case "style"
				Draw_Style(*Node)
			Default
				*ChildNode = ChildXMLNode(*Node)
				While *ChildNode
					Draw(*ChildNode, Indent+1)
					*ChildNode = NextXMLNode(*ChildNode)
				Wend
		EndSelect
		
	EndIf
	
EndProcedure


;- Public procedures


Procedure.i VectorGraphicID(VectorGraphic)
	
	If VectorGraphic <= ArraySize(VectorGraphicInclude\VectorGraphicID())
		ProcedureReturn VectorGraphicInclude\VectorGraphicID(VectorGraphic)
	Else
		ProcedureReturn VectorGraphic
	EndIf
	
EndProcedure


Procedure.i LoadVectorGraphic(VectorGraphic.i, FileName.s)
	
	Protected *VectorGraphic.VectorGraphic
	Protected XML = LoadXML(#PB_Any, FileName)
	Protected *MainNode
	
	If XML = #False
		DebuggerWarning("LoadVectorGraphic - File not found: "+FileName)
		ProcedureReturn #False
	EndIf
	If XMLStatus(XML) <> #PB_XML_Success
		DebuggerWarning("LoadVectorGraphic - XML Error: "+XMLError(XML))
		ProcedureReturn #False
	EndIf
	
	*VectorGraphic = AddElement(VectorGraphicInclude\VectorGraphic())
	If VectorGraphic = #PB_Any
		VectorGraphic = *VectorGraphic
	Else
		If ArraySize(VectorGraphicInclude\VectorGraphicID()) < VectorGraphic 
			ReDim VectorGraphicInclude\VectorGraphicID(VectorGraphic)
		ElseIf VectorGraphicInclude\VectorGraphicID(VectorGraphic)
			
		EndIf
		VectorGraphicInclude\VectorGraphicID(VectorGraphic) = *VectorGraphic
	EndIf
	
	*VectorGraphic\XML = XML
	
	ProcedureReturn *VectorGraphic
	
EndProcedure


Procedure.i ParseVectorGraphic(VectorGraphic.i, Input.s)
	
	Protected *VectorGraphic.VectorGraphic
	Protected XML = ParseXML(#PB_Any, Input)
	Protected *MainNode
	
	If XMLStatus(XML) <> #PB_XML_Success
		DebuggerWarning("ParseVectorGraphic - XML Error: "+XMLError(XML))
		ProcedureReturn #False
	EndIf
	
	*VectorGraphic = AddElement(VectorGraphicInclude\VectorGraphic())
	If VectorGraphic = #PB_Any
		VectorGraphic = *VectorGraphic
	Else
		If ArraySize(VectorGraphicInclude\VectorGraphicID()) < VectorGraphic 
			ReDim VectorGraphicInclude\VectorGraphicID(VectorGraphic)
		ElseIf VectorGraphicInclude\VectorGraphicID(VectorGraphic)
			
		EndIf
		VectorGraphicInclude\VectorGraphicID(VectorGraphic) = *VectorGraphic
	EndIf
	
	*VectorGraphic\XML = XML
	
	ProcedureReturn *VectorGraphic
	
EndProcedure


Procedure DrawVectorGraphic(VectorGraphic.i, Alpha.d=255, Width.d=0.0, Height.d=0.0)
	
	Static RegEx_Value.i
	Protected *VectorGraphic.VectorGraphic = VectorGraphicID(VectorGraphic)
	Protected *MainNode
	Protected ViewX.d, ViewY.d, ViewWidth.d, ViewHeight.d, ViewBox.i
	
	If RegEx_Value = #Null
		RegEx_Value = CreateRegularExpression(#PB_Any, "\-?\d+\.?\d*|\-?\.\d+")
	EndIf
	
	With VectorGraphicInclude\InitialStyle
		\Opacity          = 1.0
		\Fill             = $000000
		\FillRule         = #PB_Path_Winding
		\FillOpacity      = 1.0
		\Stroke           = -1
		\StrokeWidth      = 1.0
		\StrokeLineCap    = #PB_Path_Default
		\StrokeLineJoin   = #PB_Path_Default
		FreeArray(\StrokeDashArray())
		\StrokeDashOffset = 0.0
		\StrokeOpacity    = 1.0
	EndWith
	
	VectorGraphicInclude\CurrentStyle = VectorGraphicInclude\InitialStyle
	VectorGraphicInclude\CurrentVectorGraphic = *VectorGraphic
	VectorGraphicInclude\ResX = VectorResolutionX()
	VectorGraphicInclude\ResY = VectorResolutionY()
	
	BeginVectorLayer()
	
	*MainNode = MainXMLNode(*VectorGraphic\XML)
	If ExamineXMLAttributes(*MainNode)
		While NextXMLAttribute(*MainNode)
			Select LCase(XMLAttributeName(*MainNode))
				Case "viewbox"
					If ExamineRegularExpression(RegEx_Value, XMLAttributeValue(*MainNode))
						If NextRegularExpressionMatch(RegEx_Value) : ViewX = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						If NextRegularExpressionMatch(RegEx_Value) : ViewY = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						If NextRegularExpressionMatch(RegEx_Value) : ViewWidth = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						If NextRegularExpressionMatch(RegEx_Value) : ViewHeight = ValD(RegularExpressionMatchString(RegEx_Value)) : EndIf
						ViewBox = #True
					EndIf
			EndSelect
		Wend
	EndIf
	
	*MainNode = MainXMLNode(*VectorGraphic\XML)
	If ExamineXMLAttributes(*MainNode)
		While NextXMLAttribute(*MainNode)
			Select LCase(XMLAttributeName(*MainNode))
				Case "width"
					Width = Parse_Attribute_Length(XMLAttributeValue(*MainNode), ViewWidth)
				Case "height"
					Height = Parse_Attribute_Length(XMLAttributeValue(*MainNode), ViewHeight)
			EndSelect
		Wend
	EndIf
	
	If ViewBox
		ScaleCoordinates(Width/ViewWidth, Height/ViewHeight)
		TranslateCoordinates(-ViewX, -ViewY)
		AddPathBox(ViewX, ViewY, ViewWidth, ViewHeight)
		ClipPath()
	EndIf
	
	*MainNode = MainXMLNode(*VectorGraphic\XML)
	If ExamineXMLAttributes(*MainNode)
		While NextXMLAttribute(*MainNode)
			Select LCase(XMLAttributeName(*MainNode))
			EndSelect
		Wend
	EndIf
	
	Draw(*MainNode)
	
	EndVectorLayer()
	
EndProcedure



EndModule







;- Example


UseModule VectorGraphic

Enumeration
	#Window
	#Gadget
	#Gadget_Editor
	#Font
	#VectorGraphic
EndEnumeration

Procedure Update()
	
	Protected Result.i
	Protected Time.i
	
	Result = ParseVectorGraphic(#VectorGraphic, GetGadgetText(#Gadget_Editor))
	
	If StartVectorDrawing(CanvasVectorOutput(#Gadget))
		
		VectorSourceColor($FFFFFFFF)
		FillVectorOutput()
		VectorFont(GetGadgetFont(#PB_Default))
		
		If Result
			Time = ElapsedMilliseconds()
			DrawVectorGraphic(#VectorGraphic)
			Time = ElapsedMilliseconds() - Time
		EndIf
		
		StopVectorDrawing()
	EndIf
	
	SetWindowTitle(#Window, "DrawVectorGraphic - Render time: "+Str(Time)+" ms")
	
EndProcedure

InitNetwork()

LoadFont(#Font, "Arial", 32)
OpenWindow(#Window, 0, 0, 1200, 600, "DrawVectorGraphic", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
CanvasGadget(#Gadget, 600, 0, 600, 600)
EditorGadget(#Gadget_Editor, 0, 0, 600, 600)

;SetGadgetText(#Gadget_Editor, PeekS(ReceiveHTTPMemory("http://svg.tutorial.aptico.de/grafik_svg/kap10_1.svg"), -1, #PB_Ascii))
SetGadgetText(#Gadget_Editor, PeekS(ReceiveHTTPMemory("https://upload.wikimedia.org/wikipedia/commons/0/02/SVG_logo.svg"), -1, #PB_Ascii))
;SetGadgetText(#Gadget_Editor, PeekS(ReceiveHTTPMemory("https://upload.wikimedia.org/wikipedia/commons/e/e9/SVG-Grundelemente.svg"), -1, #PB_Ascii))
Update()

Repeat
	
	Select WaitWindowEvent()
			
		Case #PB_Event_CloseWindow
			End
			
		Case #PB_Event_Gadget
			Select EventGadget()
				Case #Gadget_Editor
					If EventType() =  #PB_EventType_Change
						Update()
					EndIf
			EndSelect
			
	EndSelect
	
ForEver

; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; CursorPosition = 1236
; FirstLine = 1226
; Folding = ----------
; EnableXP
; DisableDebugger
; EnableCompileCount = 635
; EnableBuildCount = 0
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ----------------------------
; EnableXP