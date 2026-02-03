DeclareModule font
   Declare$  GetName( FontID )
   Declare   GetSize( FontID )
EndDeclareModule

Module font
   
   ; default font
   ;    Protected fs.CGFloat 
   ;    CocoaMessage(@fs,0,"NSFont systemFontSize") : fs - 1 ; ??? - 1 
   ;    ProcedureReturn CocoaMessage(0, 0, "NSFont systemFontOfSize:@", @fs) 
   
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
   
   Procedure$  GetName( FontID )
      CompilerSelect #PB_Compiler_OS 
         CompilerCase #PB_OS_Windows 
            Protected sysFont.LOGFONT
            GetObject_(FontID, SizeOf(LOGFONT), @sysFont)
            ProcedureReturn PeekS(@sysFont\lfFaceName[0])
            
            ;             ;    
            ;             ; Create a HDC to get the font info:
            ;             Protected hdc = GetDC_(#Null)
            ;             Protected oldFont = SelectObject_(hdc, FontID)
            ;             ;
            ;             ; Get the real font name:
            ;             FontName$ = Space(#LF_FACESIZE) ; Maximum size for font name.
            ;             GetTextFace_(hdc, #LF_FACESIZE, @FontName$)
            ;             If FontName$ = "" : FontName$ = "Arial" : EndIf
            ;             ;
            ;             ; Clean up:
            ;             SelectObject_(hdc, oldFont)
            ;             ReleaseDC_(#Null, hdc)
            
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
   
   Procedure   GetSize( FontID ) ; returns the font size of FontID
      CompilerSelect #PB_Compiler_OS 
         CompilerCase #PB_OS_Windows 
            Protected sysFont.LOGFONT
            GetObject_(FontID, SizeOf(LOGFONT), @sysFont)
            ProcedureReturn MulDiv_(-sysFont\lfHeight, 72, GetDeviceCaps_(GetDC_(#NUL), #LOGPIXELSY))
            ;ProcedureReturn Int(Round((-sysFont\lfHeight * 72 / GetDeviceCaps_(GetDC_(0),#LOGPIXELSY)),0))
            
            ;             ; Get gadget font height in points (to the nearest integer)
            ;             Protected sysFont.LOGFONT
            ;             Protected hdc = GetDC_(#Null) ; Obtenir le contexte de périphérique
            ;             If GetObject_(FontID, SizeOf(LOGFONT), @sysFont.LOGFONT)
            ;                FpointSize = -sysFont\lfHeight * 72 / GetDeviceCaps_(hdc, #LOGPIXELSY)
            ;             EndIf
            ;             ProcedureReturn FpointSize
            
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
   
EndModule


CompilerIf #PB_Compiler_IsMainFile
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
   
   Define m.s = #LF$, Text.s = "Standard"+ m.s +"Button Button"+ m.s +"(horizontal)"
   
   fontsize = 18-Bool(#PB_Compiler_OS=#PB_OS_Windows)*4-Bool(#PB_Compiler_OS=#PB_OS_Linux)*5
   
   ; bad
   ;LoadFont(0, "MS Shell Dlg", fontsize) ; xp - default
   ;LoadFont(0, "Menta", fontsize)
   ;LoadFont(0, "Cantarell", fontsize) ; linux - default
   ;LoadFont(0, "Bernard MT Condensed", fontsize)
   ;LoadFont(0, "FreeSerif", fontsize)
   
   ; good
   ;LoadFont(0, "Arial", fontsize)
   ;LoadFont(0, "Arial Unicode MS", fontsize)
   ;LoadFont(0, "Helvetica", fontsize)
   ;LoadFont(0, "Helvetica Neue", fontsize)
   ;LoadFont(0, "Charter", fontsize)
   ;LoadFont(0, "Tahoma", fontsize)
   LoadFont(0, "Courier", fontsize) ; in windows bed
   
   FontID = FontID(0)
   ; FontID = GetGadgetFont(#PB_Default)
   
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Define fontsize2.CGFloat = 0.0; boldSystemFontOfSize ; fontWithSize
      ;FontManager = CocoaMessage(0, 0, "NSFontManager sharedFontManager")
      CocoaMessage(@FontSize2,0,"NSFont systemFontSize")
      ;FontID = CocoaMessage(0, 0, "NSFont systemFontOfSize:@", @"") ; 13
      ;FontID = CocoaMessage(0, 0, "NSFont controlContentFontOfSize:@", @"") ; 12
      Debug "systemFontSize "+fontsize2
   CompilerEndIf

   Debug ""+fontsize +" "+ Font::GetSize(FontID)+" - "+Font::GetName(FontID)
   
   Procedure draw_text(X, Y, Text.s, align=0, rotate=0)
      Static Width,Height
      Protected i, count = CountString(Text, #LF$)
      
      For i = 0 To count 
         String.s = StringField(Text, i+1, #LF$) 
         text_width = TextWidth(String)
         text_height = TextHeight(String)
         
         If align = 2
            text_x = X + (240-text_width)
         ElseIf align = 1
            text_x = X + (240-text_width)/2
         Else
            text_x = X
         EndIf
         
         text_y = Y+(text_height+1)*i 
         
         DrawingMode(#PB_2DDrawing_Transparent)
         DrawRotatedText(text_x, text_y-1, String, rotate,  $ff000000)
         
         DrawingMode(#PB_2DDrawing_Outlined)
         Box(text_x, text_y, text_width, text_height, $ffff0000)
         Box(X, Y, Width, Height, $ffff0000)
      Next
   EndProcedure
   
   ;
   If OpenWindow(0, 0, 0, 450, 300, "2DDrawing Example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      If CreateImage(0, 450, 300) And StartDrawing(ImageOutput(0))
         DrawingFont(FontID)
         
         DrawingMode(#PB_2DDrawing_Transparent)
         Box(0, 0, 450, 300, RGB(230, 230, 230))
         
         draw_text(30,30,Text,0,0)
         draw_text(100,30,Text, 1,0)
         draw_text(170,30,Text, 2,0)
         
         StopDrawing() 
         ImageGadget(0, 0, 0, 200, 200, ImageID(0))
      EndIf
      
      Repeat
         Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 142
; FirstLine = 122
; Folding = ---
; EnableXP
; DPIAware