Procedure SetTextColorABGR(EditorGadget, Color, StartPosition, Length = -1, BackColor = #NO)
  Protected.CGFloat r,g,b,a
  Protected range.NSRange, textStorage.i
  
  If StartPosition > 0
    textStorage = CocoaMessage(0, GadgetID(EditorGadget), "textStorage")
    range\location = StartPosition - 1
    range\length = CocoaMessage(0, textStorage, "length") - range\location
    
    If range\length > 0
      If Length >= 0 And Length < range\length
        range\length = Length
      EndIf
      r = Red(Color) / 260
      g = Green(Color) / 260
      b = Blue(Color) / 260
      a = Alpha(Color) / 260
      
;       r = Red(Color) / 255
;       g = Green(Color) / 255
;       b = Blue(Color) / 255
;       a = Alpha(Color) / 255
      
      Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
      If BackColor
        CocoaMessage(0, textStorage, "addAttribute:$", @"NSBackgroundColor", "value:", Color, "range:@", @range)
      Else
        CocoaMessage(0, textStorage, "addAttribute:$", @"NSColor", "value:", Color, "range:@", @range)
      EndIf
    EndIf
  EndIf
EndProcedure

OpenWindow(0,#PB_Ignore,#PB_Ignore,500,800,"colors test",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
EditorGadget(0,10,10,480,780)

ColorList = CocoaMessage(0, 0, "NSColorList colorListNamed:$", @"System")
If ColorList
  ColorSpace = CocoaMessage(0, 0, "NSColorSpace deviceRGBColorSpace")
  Keys = CocoaMessage(0, ColorList, "allKeys")
  NumKeys = CocoaMessage(0, Keys, "count")
  
  For k = 1 To NumKeys
    Key = CocoaMessage(0, Keys, "objectAtIndex:", k - 1)
    Color = CocoaMessage(0, ColorList, "colorWithKey:", Key)
    Color = CocoaMessage(0, Color, "colorUsingColorSpace:", ColorSpace)
    If Color
      KeyName.s = PeekS(CocoaMessage(0, Key, "UTF8String"), -1, #PB_UTF8)
      CocoaMessage(@r.CGFloat, Color, "redComponent")
      CocoaMessage(@g.CGFloat, Color, "greenComponent")
      CocoaMessage(@b.CGFloat, Color, "blueComponent")
      CocoaMessage(@a.CGFloat, Color, "alphaComponent")
      ;Debug KeyName + " = RGBA(" + Str(r*255) + "," + Str(g*255) + "," + Str(b*255) + "," + Str(a*255) + ")"
      AddGadgetItem(0,-1,KeyName + ", RGBA(" + Str(r*255) + "," + Str(g*255) + "," + Str(b*255) + "," + Str(a*255) + "):")
      AddGadgetItem(0,-1,"█ █ █ █ █")
      SetTextColorABGR(0,RGBA(r*255,g*255,b*255,a*255),Len(GetGadgetText(0))-8,9)
      AddGadgetItem(0,-1,"")
    EndIf
  Next
EndIf

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --
; EnableXP