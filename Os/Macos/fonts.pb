FontManager = CocoaMessage(0, 0, "NSFontManager sharedFontManager")
AvailableFontFamilies = CocoaMessage(0, FontManager, "availableFontFamilies")
FontCount = CocoaMessage(0, AvailableFontFamilies, "count")

i = 0
While i < FontCount
  FontName.s = PeekS(CocoaMessage(0, CocoaMessage(0, AvailableFontFamilies, "objectAtIndex:", i), "UTF8String"), -1, #PB_UTF8)
  Debug FontName
  i + 1
Wend
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; EnableXP