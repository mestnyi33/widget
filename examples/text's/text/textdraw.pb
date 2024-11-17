CompilerSelect #PB_Compiler_OS 
    CompilerCase #PB_OS_Linux
      
      #G_TYPE_INT = 24
      #G_TYPE_STRING = 64
      
      ImportC ""
        gtk_widget_get_visible(*widget.GtkWidget)
        gtk_widget_get_sensitive (*widget.GtkWidget)
         g_object_get_property(*widget.GtkWidget, prop.p-utf8, *gval)
         g_object_set_property(obj.i, prop.p-utf8, v.i)
        ; gtk_font_chooser_get_font_family_(*fontchooser.GtkFontChooser)
   EndImport
      
  CompilerEndSelect
  
Procedure.S FontName( FontID )
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Windows 
        Protected sysFont.LOGFONT
        GetObject_(FontID, SizeOf(LOGFONT), @sysFont)
        ProcedureReturn PeekS(@sysFont\lfFaceName[0])
        
      CompilerCase #PB_OS_Linux
        Protected gVal.GValue
        Protected.s StdFnt
        g_value_init_( @gval, #G_TYPE_STRING ) ; gtk-theme-name
        g_object_get_property( gtk_settings_get_default_(), "gtk-font-name", @gval )
        StdFnt = PeekS( g_value_get_string_( @gval ), -1, #PB_UTF8 )
        g_value_unset_( @gval )
        ProcedureReturn StringField((StdFnt), 1, " ") ; StdFnt ; PeekS( gtk_font_chooser_get_font_family_(FontID), -1, #PB_UTF8 ) ;  
        
    CompilerCase #PB_OS_MacOS ; fontName displayName familyName
       ProcedureReturn PeekS(CocoaMessage(0,  CocoaMessage(0, fontID, "displayName"), "UTF8String"), -1, #PB_UTF8)
        
      CompilerEndSelect
  EndProcedure
  
  Procedure FontSize( FontID )
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Windows 
        Protected sysFont.LOGFONT
        GetObject_(FontID, SizeOf(LOGFONT), @sysFont)
        ProcedureReturn MulDiv_(-sysFont\lfHeight, 72, GetDeviceCaps_(GetDC_(#NUL), #LOGPIXELSY))
        ;ProcedureReturn Int(Round((-sysFont\lfHeight * 72 / GetDeviceCaps_(GetDC_(0),#LOGPIXELSY)),0))

      CompilerCase #PB_OS_Linux
        Protected   gVal.GValue
        Protected.s StdFnt
        g_value_init_(@gval, #G_TYPE_STRING)
        g_object_get_property( gtk_settings_get_default_(), "gtk-font-name", @gval)
        StdFnt= PeekS(g_value_get_string_(@gval), -1, #PB_UTF8)
        g_value_unset_(@gval)
        ProcedureReturn Val(StringField((StdFnt), 2, " "))
        
      CompilerCase #PB_OS_MacOS
        Protected FontSize.CGFloat
        CocoaMessage(@FontSize, fontID, "pointSize")
        ProcedureReturn FontSize      
        
    CompilerEndSelect
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Procedure _GetGadgetFont(gadget)
      If gadget =- 1
        Protected fs.CGFloat 
        CocoaMessage(@fs,0,"NSFont systemFontSize") : fs - 1 ; ??? - 1 
        ProcedureReturn CocoaMessage(0, 0, "NSFont systemFontOfSize:@", @fs) 
      Else
        ProcedureReturn GetGadgetFont(gadget)
      EndIf
    EndProcedure
    
    Macro GetGadgetFont(gadget)
      _GetGadgetFont(gadget)
    EndMacro
  CompilerEndIf
  
  Define m.s = #LF$, text.s = "Standard"+ m.s +"Button Button"+ m.s +"(horizontal)"

fontsize = 18-Bool(#PB_Compiler_OS=#PB_OS_Windows)*4-Bool(#PB_Compiler_OS=#PB_OS_Linux)*5

;LoadFont(0, "Courier", fontsize) ; in windows bed

LoadFont(0, "MS Shell Dlg", fontsize) ; xp - default
;;LoadFont(0, "Menta", fontsize)
;LoadFont(0, "Arial", fontsize)
;LoadFont(0, "Cantarell", fontsize) ; linux - default
;LoadFont(0, "Helvetica", fontsize)
;LoadFont(0, "Helvetica Neue", fontsize)
;LoadFont(0, "Bernard MT Condensed", fontsize)
;LoadFont(0, "FreeSerif", fontsize)

;LoadFont(0, "Arial Unicode MS", fontsize)
;LoadFont(0, "Charter", fontsize)
;LoadFont(0, "Tahoma", fontsize)
FontID = FontID(0)
;FontID = GetGadgetFont(#PB_Default)

Debug ""+FontSize(FontID)+" - "+FontName(FontID)

Procedure draw_TextWidget(x, y, text.s, align=0, rotate=0)
  Static width,height
  Protected i, count = CountString(text, #LF$)
    
  For i = 0 To count 
    string.s = StringField(text, i+1, #LF$) 
    text_width = TextWidth(string)
    text_height = TextHeight(string)
    
    If align = 2
      text_x = x + (240-text_width)
    ElseIf align = 1
      text_x = x + (240-text_width)/2
    Else
      text_x = x
    EndIf
    
    text_y = y+(text_height+1)*i 
    
    DrawingMode(#PB_2DDrawing_Transparent)
    DrawRotatedText(text_x, text_y-1, string, rotate,  $ff000000)
    
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(text_x, text_y, text_width, text_height, $ffff0000)
    Box(x, y, width, height, $ffff0000)
  Next
EndProcedure


If OpenWindow(0, 0, 0, 450, 300, "2DDrawing Example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    If CreateImage(0, 450, 300) And StartDrawing(ImageOutput(0))
      DrawingFont(FontID)
      
      DrawingMode(#PB_2DDrawing_Transparent)
      Box(0, 0, 450, 300, RGB(230, 230, 230))
      
      draw_TextWidget(30,30,text,0,0)
      draw_TextWidget(100,30,text, 1,0)
      draw_TextWidget(170,30,text, 2,0)
      
      StopDrawing() 
      ImageGadget(0, 0, 0, 200, 200, ImageID(0))
    EndIf
    
    Repeat
      Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -+
; EnableXP