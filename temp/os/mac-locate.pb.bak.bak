;
; get default user language/locale settings
;
; http://www.purebasic.fr/english/viewtopic.php?f=19&t=50795&start=137
;
;
; The language code is based on the ISO 639-x/IETF BCP 47 standard. ISO 639-1 defines two-character codes, such as “en” And “fr”,
; for the world’s most commonly used languages.
; If a two-letter ISO 639-1 code is not available, then ISO 639-2 three-letter identifiers are accepted as well,
; for example “haw” For Hawaiian. For more details, see http://www.loc.gov/standards/iso639-2/php/English_list.php
;
EnableExplicit

Macro release(object)
    CocoaMessage(0,object,"release")
EndMacro

Macro autorelease(object)
    CocoaMessage(0,object,"autorelease")
EndMacro


Procedure.s GetDefaultLanguage()
    Protected result.s, NSUserDefaults_defs, NSArray_languages, NSString_preferredLang
    
    NSUserDefaults_defs = CocoaMessage(0,0,"NSUserDefaults standardUserDefaults")
    If NSUserDefaults_defs
        NSArray_languages   = CocoaMessage(0,NSUserDefaults_defs,"objectForKey:$",@"AppleLanguages")
        If NSArray_languages
            NSString_preferredLang = CocoaMessage(0,NSArray_languages,"objectAtIndex:",0)
            If NSString_preferredLang
                result = PeekS(CocoaMessage(0, NSString_preferredLang, "UTF8String"), -1, #PB_UTF8)
                autorelease(NSString_preferredLang)
            EndIf
            autorelease(NSArray_languages)
        EndIf
        autorelease(NSUserDefaults_defs)
    EndIf
    ProcedureReturn result
EndProcedure

Procedure.s GetUserLocale()
    Protected result.s, NSUserDefaults_defs, NSString_locale

    NSUserDefaults_defs = CocoaMessage(0,0,"NSUserDefaults standardUserDefaults")
    If NSUserDefaults_defs
        NSString_locale  = CocoaMessage(0,NSUserDefaults_defs,"objectForKey:$",@"AppleLocale")
        If NSString_locale
            result = PeekS(CocoaMessage(0, NSString_locale, "UTF8String"), -1, #PB_UTF8)
            autorelease(NSString_locale)
        EndIf
        autorelease(NSUserDefaults_defs)
    EndIf
    ProcedureReturn result
EndProcedure


Procedure.s GetUserLanguage()
    ;
    ; by Shardik
    ;
    ; http://www.purebasic.fr/english/viewtopic.php?f=3&t=55750&start=3
    ;
    Protected result.s, CurrentLocale, LanguageCode, string
    CurrentLocale = CocoaMessage(0, 0, "NSLocale currentLocale")
    If CurrentLocale
        LanguageCode = CocoaMessage(0, CurrentLocale, "objectForKey:$", @"kCFLocaleLanguageCodeKey")
        If LanguageCode
            string = CocoaMessage(0, CurrentLocale, "displayNameForKey:$", @"kCFLocaleLanguageCodeKey", "value:", LanguageCode)
            If string
                result = PeekS(CocoaMessage(0, string, "UTF8String"), -1, #PB_UTF8)
                autorelease(string)
            EndIf
            autorelease(LanguageCode)
        EndIf
        autorelease(CurrentLocale)
    EndIf
    ProcedureReturn result
EndProcedure


Procedure.s GetUserLanguageIdentifier()
    ;
    ; by Shardik
    ;
    ; http://www.purebasic.fr/english/viewtopic.php?f=3&t=55750&start=3
    ;
    Protected result.s, CurrentLocale, LanguageCode, string
    CurrentLocale = CocoaMessage(0, 0, "NSLocale currentLocale")
    If CurrentLocale
        LanguageCode = CocoaMessage(0, CurrentLocale, "objectForKey:$", @"kCFLocaleIdentifierKey")
        If LanguageCode
            string = CocoaMessage(0, CurrentLocale, "displayNameForKey:$", @"kCFLocaleIdentifierKey", "value:", LanguageCode)
            If string
                result = PeekS(CocoaMessage(0, string, "UTF8String"), -1, #PB_UTF8)
                autorelease(string)
            EndIf
            autorelease(LanguageCode)
        EndIf
        autorelease(CurrentLocale)
    EndIf
    ProcedureReturn result
EndProcedure

Debug "GetDefaultLanguage:        "+GetDefaultLanguage()
Debug "GetUserLocale:             "+GetUserLocale()
Debug "GetUserLanguage:           "+GetUserLanguage()
Debug "GetUserLanguageIdentifier: "+GetUserLanguageIdentifier()
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP