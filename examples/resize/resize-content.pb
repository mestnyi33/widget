XIncludeFile "../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_draw_area = 1
   
   Global img = 1
   If Not LoadImage(img, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
      End
   EndIf
   If DPIResolutionX() > 1
      ResizeImage(img, DPIScaledX(ImageWidth(img)),DPIScaledY(ImageHeight(img)))
   EndIf
   
   Global h = 80
   Global._s_widget *g1, *g2, *g3, *g4, *g5, *g6
   Global word$ = "-"
    ;word$ = #LF$ ; BUG
   
   Procedure TestAlign( X,Y,Width,Height, txt$, flags.q=0 )
      Protected._s_WIDGET *g  
      Protected img = 1
      
      If flags & #__flag_Center
         flags &~ #__flag_Center
         flags | #__align_image ;| #__flag_Left
      EndIf
      
      If word$ = #LF$
        ; txt$+#LF$+"line"
       ;  flags|#__flag_TextMultiLine
      EndIf
      
      ;txt$ = ""
      ;img =- 1
      
      *g = CheckBox( X,Y,Width,Height, txt$, flags) : SetImage( *g, img ) 
      ;*g = Button( X,Y,Width,Height, txt$, flags|(Bool(flags&#__align_image)*#__flag_Left)) : SetImage( *g, img ) 
      ;*g = ComboBox( X,Y,Width,Height, flags|(Bool(flags&#__align_image)*#__flag_Left)) :AddItem(*g, -1, txt$, img ) : SetState(*g,0)
      ;*g = Editor( X,Y,Width,Height, flags|#__flag_Center) : SetText( *g, txt$ ) ;: SetImage( *g, img ) 
      ;*g = Text( X,Y,Width,Height, txt$, #__flag_BorderFlat|flags) : SetImage( *g, img )
      
      ;*g = ButtonImage( X,Y,Width,Height, img, flags|(Bool(flags&#__align_image)*#__flag_Left)) : SetText( *g, txt$ )
      ;*g = Image( X,Y,Width,Height, img, #__flag_BorderFlat|flags) : SetText( *g, txt$ )
      
     ; Alignment( *g, #__align_left|#__align_right)
     ; Bind(*g, @Test_Events( ), #__event_LeftClick)
      ProcedureReturn *g
   EndProcedure
   
   
   If Open(#PB_Any, 0, 0, 680, 60+h, "content position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      *g1 = TestAlign(    30, 30, 200, h, "butt" + word$ + "left", #__flag_Left)
      *g2 = TestAlign(30+210, 30, 200, h, "butt" + word$ + "center" + word$ + "multi", #__flag_Center)
      *g3 = TestAlign(30+420, 30, 200, h, "right" + word$ + "butt", #__flag_Right)
      
      *g4 = Splitter(0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
      *g5 = Splitter(30,30,620,h, *g4,*g3, #PB_Splitter_Vertical)
      *g6 = Splitter(30,30,620,h, *g5, -1)
      
      SetState(*g4, 200)
      SetState(*g5, 200*2)
      SetState(*g6, h)
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 37
; FirstLine = 28
; Folding = --
; EnableXP