;The following example was put into the public domain by Roger "Rescator" Hågensen in 2003.

EnableExplicit

;code.w is only for testing purposes, remove it if you do not need it.
;Normaly you would always use the constant #LOCALE_USER_DEFAULT.

Procedure.s GetUserLanguage(code.w=#LOCALE_USER_DEFAULT)
	Define result$,dll.i,text$,len.i,*GetLocaleInfo
	dll=OpenLibrary(#PB_Any,"kernel32.dll")
	If dll
		CompilerIf #PB_Compiler_Unicode
			*GetLocaleInfo=GetFunction(dll,"GetLocaleInfoW")
		CompilerElse
			*GetLocaleInfo=GetFunction(dll,"GetLocaleInfoA")
		CompilerEndIf
		If *GetLocaleInfo
			len=CallFunctionFast(*GetLocaleInfo,code,#LOCALE_SENGLANGUAGE,#Null,#Null)
			If len
				text$=Space(len-1)
				If CallFunctionFast(*GetLocaleInfo,code,#LOCALE_SENGLANGUAGE,@text$,len)
					result$=text$
				EndIf
			EndIf
		EndIf
		CloseLibrary(dll)
	EndIf
	ProcedureReturn result$
EndProcedure ;Returns "" if the call fails.

Procedure.s GetUserLanguageLocalized(code.w=#LOCALE_USER_DEFAULT)
	Define result$,dll.i,text$,len.i,*GetLocaleInfo
	dll=OpenLibrary(#PB_Any,"kernel32.dll")
	If dll
		CompilerIf #PB_Compiler_Unicode
			*GetLocaleInfo=GetFunction(dll,"GetLocaleInfoW")
		CompilerElse
			*GetLocaleInfo=GetFunction(dll,"GetLocaleInfoA")
		CompilerEndIf
		If *GetLocaleInfo
			len=CallFunctionFast(*GetLocaleInfo,code,#LOCALE_SNATIVELANGNAME,#Null,#Null)
			If len
				text$=Space(len-1)
				If CallFunctionFast(*GetLocaleInfo,code,#LOCALE_SNATIVELANGNAME,@text$,len)
					result$=text$
				EndIf
			EndIf
		EndIf
		CloseLibrary(dll)
	EndIf
	ProcedureReturn result$
EndProcedure ;Returns "" if the call fails.

#LOCALE_SISO639LANGNAME=$0059
Procedure.s GetUserLanguageISO(code.w=#LOCALE_USER_DEFAULT)
	Define result$,dll.i,text$,len.i,*GetLocaleInfo
	dll=OpenLibrary(#PB_Any,"kernel32.dll")
	If dll
		CompilerIf #PB_Compiler_Unicode
			*GetLocaleInfo=GetFunction(dll,"GetLocaleInfoW")
		CompilerElse
			*GetLocaleInfo=GetFunction(dll,"GetLocaleInfoA")
		CompilerEndIf
		If *GetLocaleInfo
			len=CallFunctionFast(*GetLocaleInfo,code,#LOCALE_SISO639LANGNAME,#Null,#Null)
			If len
				text$=Space(len-1)
				If CallFunctionFast(*GetLocaleInfo,code,#LOCALE_SISO639LANGNAME,@text$,len)
					result$=text$
				EndIf
			EndIf
		EndIf
		CloseLibrary(dll)
	EndIf
	ProcedureReturn result$
EndProcedure ;Returns "" if the call fails.

Procedure.s GetUserLanguageRegion(code.w=#LOCALE_USER_DEFAULT)
	Define result$,dll.i,text$,len.i,*GetLocaleInfo
	dll=OpenLibrary(#PB_Any,"kernel32.dll")
	If dll
		CompilerIf #PB_Compiler_Unicode
			*GetLocaleInfo=GetFunction(dll,"GetLocaleInfoW")
		CompilerElse
			*GetLocaleInfo=GetFunction(dll,"GetLocaleInfoA")
		CompilerEndIf
		If *GetLocaleInfo
			len=CallFunctionFast(*GetLocaleInfo,code,#LOCALE_SLANGUAGE,#Null,#Null)
			If len
				text$=Space(len-1)
				If CallFunctionFast(*GetLocaleInfo,code,#LOCALE_SLANGUAGE,@text$,len)
					result$=text$
				EndIf
			EndIf
		EndIf
		CloseLibrary(dll)
	EndIf
	ProcedureReturn result$
EndProcedure ;Returns "" if the call fails.

;http://msdn.microsoft.com/en-us/library/dd373814%28v=vs.85%29.aspx
;http://en.wikipedia.org/wiki/IETF_language_tag
#LOCALE_SISO639LANGNAME=$0059
#LOCALE_SISO3166CTRYNAME=$005a
#LOCALE_NAME_MAX_LENGTH=85
Procedure.s GetUserLanguageIETF(code.w=#LOCALE_USER_DEFAULT) ;well IETF compatible at least, not sure if "lang-script-country(number)" results will occur or not.
	Define result$,dll.i,text$,text2$,len.i,*GetLocaleInfo,*GetUserDefaultLocaleName
	dll=OpenLibrary(#PB_Any,"kernel32.dll")
	If dll
		CompilerIf #PB_Compiler_Unicode
			If code=#LOCALE_USER_DEFAULT
				*GetUserDefaultLocaleName=GetFunction(dll,"GetUserDefaultLocaleName") ;Vista+
			EndIf
			If *GetUserDefaultLocaleName
				text$=Space(#LOCALE_NAME_MAX_LENGTH-1)
				len=CallFunctionFast(*GetUserDefaultLocaleName,@text$,#LOCALE_NAME_MAX_LENGTH)
				If len
					result$=Left(text$,len-1)
				EndIf
			Else ;GetUserDefaultLocaleName not available use fallback.
				*GetLocaleInfo=GetFunction(dll,"GetLocaleInfoW")
			EndIf
		CompilerElse ;GetUserDefaultLocaleName does not exist for ANSI, use fallback.
			*GetLocaleInfo=GetFunction(dll,"GetLocaleInfoA")
		CompilerEndIf
		If *GetLocaleInfo
			len=CallFunctionFast(*GetLocaleInfo,code,#LOCALE_SISO639LANGNAME,#Null,#Null)
			If len
				text$=Space(len-1)
				If CallFunctionFast(*GetLocaleInfo,code,#LOCALE_SISO639LANGNAME,@text$,len)
					text2$=text$
				EndIf
			EndIf
			If text2$
				len=CallFunctionFast(*GetLocaleInfo,code,#LOCALE_SISO3166CTRYNAME,#Null,#Null)
				If len
					text$=Space(len-1)
					If CallFunctionFast(*GetLocaleInfo,code,#LOCALE_SISO3166CTRYNAME,@text$,len)
						result$=text2$+"-"+text$+""
					EndIf
				EndIf
			EndIf
		EndIf
		CloseLibrary(dll)
	EndIf
	ProcedureReturn result$
EndProcedure ;Returns "" if both the call fails.

Procedure test(code.w=#LOCALE_USER_DEFAULT)
	Debug "GetUserLanguage: "+GetUserLanguage(code)
	Debug "GetUserLanguageISO: "+GetUserLanguageISO(code)
	Debug "GetUserLanguageIETF: "+GetUserLanguageIETF(code)
	Debug "GetUserLanguageLocalized: "+GetUserLanguageLocalized(code)
	Debug "GetUserLanguageRegion: "+GetUserLanguageRegion(code)
	Debug "testcode: $"+RSet(Hex(code),4,"0")
	Debug ""
EndProcedure

;List of language codes.
;http://msdn.microsoft.com/en-us/goglobal/bb896001.aspx

test() ;This/your system right now.

test($0C09) ;Australia (AU)
test($2809) ;Belize (BZ)
test($1009) ;Canada (CA)
test($2409) ;Caribbean (029)
test($4009) ;India (IN)
test($1809) ;Ireland (IE)
test($2009) ;Jamaica (JM)
test($4409) ;Malaysia (MY)
test($1409) ;New Zealand (NZ)
test($3409) ;Philippines (PH)
test($4809) ;Singapore (SG)
test($1c09) ;South Africa (ZA)
test($2C09) ;Trinidad and Tobago (TT)
test($0809) ;United Kingdom (GB)
test($0409) ;United States (US)
test($3009) ;Zimbabwe (ZW)
test($0014) ;Norwegian
test($0414) ;Norwegian Bokmål
test($0814) ;Norwegian Nynorsk
test($103b) ;Norwegian Sami
test($043b) ;Norwegian Sami
test($183b) ;Norwegian Sami
test($0400) ;English
test($1000) ;Unspecified custom locale language
test($0800) ;System default locale language

;The Chinese localized names may not display properly, it depends on the font used.
test($0C04) ;Chinese (Traditional, Hong Kong S.A.R.)
test($1404) ;Chinese (Traditional, Macao S.A.R.)
test($1004) ;Chinese (Simplified, Singapore)
test($0004) ;Chinese (Simplified, PRC)
test($7c04) ;Chinese (Traditional, Hong Kong S.A.R.)

test($0C07) ;German (Austria)
test($0407) ;German (Germany)
test($1407) ;German (Liechtenstein)
test($1007) ;German (Luxembourg)
test($0807) ;German (Switzerland)

test($080c) ;French (Belgium)
test($0c0c) ;French (Canada)

test($040c) ;French (France)
test($140c) ;French (Luxembourg)

test($180c) ;French (Monaco)
test($100c) ;French (Switzerland)

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 7
; FirstLine = 165
; Folding = -------
; EnableXP