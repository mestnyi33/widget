;DisableDebugger

Macro PB(Function)
  Function
EndMacro

Global set_text_width.s = "_№qwertyuiopasdfghjklzxcvbnm\QWERTYUIOPASDFGHJKLZXCVBNM йцукенгшщзхъфывапролджэ\ячсмитьбю./ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭ/ЯЧСМИТЬБЮ,][{}|'+-=()*&^%$#@!±§<>`~:?0123456789"+~"\"" 

Global NewMap get_text_width.i()

Procedure SetTextWidth(Text.s, Len.i)
  Protected i, w, Key.s
  
  For i = 0 To Len 
    Key.s = Mid(Text.s, i, 1)
    
    If Not FindMapElement(get_text_width(), Key.s)
      w = PB(TextWidth)(Key)
      
      If w
        get_text_width(Key) = w
      EndIf
    EndIf
  Next
  
EndProcedure

Procedure GetTextWidth(text.s, len)
  Protected i, TextWidth.i
  
  If set_text_width
    SetTextWidth(set_text_width, Len(set_text_width))
    set_text_width = ""
  EndIf
  
  For i=1 To len
    TextWidth + get_text_width(Mid(Text.s, i, 1))
  Next
  
  ProcedureReturn TextWidth + Bool(#PB_Compiler_OS = #PB_OS_MacOS And i>1) * (i/2-1) ;Why on Mac OS should I do this?
EndProcedure

; Define FontSize.CGFloat = 12.0
; Global NSFont = CocoaMessage(0,0, "NSFont fontWithName:$", @"Andale Mono", "size:@", @FontSize)
; Global NSDictionary = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:",  NSFont, "forKey:$", @"NSFontAttributeName")
; 
; Procedure stringWidth(string.s)
; Protected NSSize.NSSize
; 
; NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @string)
; CocoaMessage(NSSize, NSString, "sizeWithAttributes:", NSDictionary)
; 
; ProcedureReturn NSSize\width
; 
; EndProcedure


; comment\uncomment to see resultat
 Macro TextWidth(Text) : GetTextWidth(Text, Len(Text)) : EndMacro
; Macro TextWidth(Text) : stringWidth(Text) : EndMacro

 
Procedure.s Wrap (Text.s, Width.i)
  Protected.i CountString, i, start, ii, found, length
  Protected line$, ret$="", LineRet$="", TextWidth
  
  CountString = CountString(Text.s, #LF$) 
  
  For i = 1 To CountString
    line$ = StringField(Text.s, i, #LF$)
    start = Len(line$)
    length = start
    
    ; Get text len
    While length > 1
       ; Debug ""+TextWidth(RTrim(Left(Line$, length))) +" "+ GetTextWidth(RTrim(Left(Line$, length)), length) +" "+ stringWidth(RTrim(Left(Line$, length)))
      If width > TextWidth(RTrim(Left(Line$, length))) 
        Break
      Else
        length - 1
      EndIf
    Wend 
    
    While start > length 
      start = length
      
      LineRet$ + Left(line$, start) + #LF$
      line$ = LTrim(Mid(line$, start+1))
      start = Len(line$)
      length = start
      
      ; Get text len
      While length > 1
        If width > TextWidth(RTrim(Left(Line$, length)))
          Break
        Else
          length - 1
        EndIf
      Wend 
      
    Wend   
    
    ret$ + LineRet$ + line$ + #CRLF$
    LineRet$=""
  Next
  
  ProcedureReturn ret$
EndProcedure

Global Text.s = "строка_1"+Chr(10)+
"строка__2"+Chr(10)+
"строка___3 эта длинняя строка оказалась ну, очень длинной, поэтому будем его переносить"+Chr(10)+
"строка_4"+#CRLF$+
"строка__5"+#LF$


If OpenWindow(0, 0, 0, 220, 620, "CanvasGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CanvasGadget(0, 10, 10, 200, 600)
  
  If StartDrawing(CanvasOutput(0))
    Box(0,0,OutputWidth(), OutputHeight(), $FFFFFF)
    h=TextHeight("A")
    
    time = ElapsedMilliseconds()
    Text = Wrap(Text.s, 10)
    
;     If (#PB_Compiler_OS = #PB_OS_Windows) ;Or (#PB_Compiler_OS = #PB_OS_Linux)
      count = CountString(Text.s, #LF$)
      For i=1 To count
        String.s = StringField(Text.s, i, #LF$)
        DrawText(10,i*h+10,String.s, $000000, $FFFFFF)
      Next  
;     Else
;       DrawText(10,10,Text.s, $000000, $FFFFFF)
;     EndIf
    time = ElapsedMilliseconds()-time
    
    StopDrawing() 
  EndIf
  MessageRequester( "", Str(time) )
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
EndIf

;   result 
;   75 21
;   21 31
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -+
; EnableXP