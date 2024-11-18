XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UseWidgets( )
  
  UsePNGImageDecoder()
  
  Global img = 2
;   CatchImage(0, ?Logo);?maximize, 204)
; ;   DataSection
; ;       maximize:
; ;       Data.b $89,$50,$4E,$47,$0D,$0A,$1A,$0A,$00,$00,$00,$0D,$49,$48,$44,$52,$00,$00,$00,$10
; ;       Data.b $00,$00,$00,$10,$08,$06,$00,$00,$00,$1F,$F3,$FF,$61,$00,$00,$00,$93,$49,$44,$41
; ;       Data.b $54,$78,$DA,$CD,$D2,$B1,$0E,$82,$40,$10,$84,$61,$59,$A0,$80,$82,$80,$86,$D8,$28
; ;       Data.b $14,$14,$24,$14,$60,$7C,$FF,$52,$E3,$23,$F8,$38,$E7,$5F,$6C,$61,$36,$7B,$39,$13
; ;       Data.b $1B,$36,$F9,$AA,$99,$0C,$14,$77,$D8,$E5,$65,$90,$04,$3A,$FE,$BD,$11,$12,$9E,$A8
; ;       Data.b $91,$7B,$5F,$0E,$3F,$BA,$A0,$B6,$03,$A2,$E1,$82,$1B,$36,$AC,$C6,$5D,$3B,$33,$DA
; ;       Data.b $D8,$C0,$84,$11,$3D,$8E,$46,$FF,$D5,$E9,$62,$03,$23,$4E,$28,$21,$46,$09,$ED,$C4
; ;       Data.b $FF,$60,$D0,$50,$10,$ED,$EC,$7F,$A0,$43,$01,$31,$8A,$D4,$C0,$03,$21,$E1,$85,$2B
; ;       Data.b $1A,$EF,$21,$55,$38,$6B,$61,$F0,$68,$46,$87,$AE,$73,$B9,$06,$0D,$5A,$8F,$66,$95
; ;       Data.b $76,$FF,$BF,$0F,$21,$2E,$31,$D6,$FF,$2F,$53,$8C,$00,$00,$00,$00,$49,$45,$4E,$44
; ;       Data.b $AE,$42,$60,$82
; ;       maximizeend:
; ;     EndDataSection
;     
;     DataSection
;     Logo: 
;       IncludeBinary #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png";"Logo.bmp"
;   EndDataSection
      
  If Not LoadImage(2, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Global X,Y,i,NewMap Widgets.i()
  
  Procedure scrolled( )
    ; If EventGadget() = #PB_GadgetType_ScrollBar
      SetWidgetState( Widgets(Hex(#PB_GadgetType_ProgressBar)), GetWidgetState( Widgets(Hex(#PB_GadgetType_ScrollBar))))
    ; EndIf 
  EndProcedure
  
  If OpenWindow(#PB_Any, 0, 0, 995, 605, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    OpenRoot(GetActiveWidgetWindow())
;     ;
;     ;Widgets("Container") = ContainerWidget(0, 0, 995, 455);, #__flag_AutoSize) 
;     
; ;     Widgets(Hex(#PB_GadgetType_Button)) = ButtonWidget(5, 5, 160,95, "Button_"+Hex(#PB_GadgetType_Button)+" text clip clip clip clip text" ) 
  ;  Widgets(Hex(#PB_GadgetType_String)) = StringWidget(5, 105, 160,95, "String_"+Hex(#PB_GadgetType_String)+" text clip clip clip clip text")                                 
; ;     Widgets(Hex(#PB_GadgetType_Text)) = TextWidget(5, 205, 160,95, "Text_"+Hex(#PB_GadgetType_Text)+#LF$+" text clip clip clip clip text", #PB_Text_Border)        
; ;     Widgets(Hex(#PB_GadgetType_CheckBox)) = CheckBoxWidget(5, 305, 160,95, "CheckBox_"+Hex(#PB_GadgetType_CheckBox)+" text clip clip clip clip text", #PB_CheckBox_ThreeState) : SetWidgetState(Widgets(Hex(#PB_GadgetType_CheckBox)), #PB_Checkbox_Inbetween)
; ;     Widgets(Hex(#PB_GadgetType_Option)) = OptionWidget(5, 405, 160,95, "Option_"+Hex(#PB_GadgetType_Option)+" text clip clip clip clip text" ) : SetWidgetState(Widgets(Hex(#PB_GadgetType_Option)), 1)                                                       
;     Widgets(Hex(#PB_GadgetType_ListView)) = ListViewWidget(5, 505, 160,95) : AddItem(Widgets(Hex(#PB_GadgetType_ListView)), -1, "ListView_"+Hex(#PB_GadgetType_ListView)+" text clip clip clip clip text") : For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_ListView)), i, "item_"+Hex(i)+" text clip clip clip clip text") : Next
    
; ;     Widgets(Hex(#PB_GadgetType_Frame)) = FrameWidget(170, 5, 160,95, "Frame_"+Hex(#PB_GadgetType_Frame)+" text clip clip clip clip text" )
     Widgets(Hex(#PB_GadgetType_ComboBox)) = ComboBoxWidget(170, 105, 160,95) : AddItem(Widgets(Hex(#PB_GadgetType_ComboBox)), -1, "ComboBox_"+Hex(#PB_GadgetType_ComboBox)+" text clip clip clip clip text") : For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_ComboBox)), i, "item_"+Hex(i)+" text clip clip clip clip text") : Next : SetWidgetState(Widgets(Hex(#PB_GadgetType_ComboBox)), 0) 
     Widgets(Hex(#PB_GadgetType_Image)) = ComboBoxWidget(370, 205, 160,95, #PB_ComboBox_Editable) : AddItem(Widgets(Hex(#PB_GadgetType_Image)), -1, "ComboBox_"+Hex(#PB_GadgetType_Image)+" text clip clip clip clip text") : For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_Image)), i, "item_"+Hex(i)+" text clip clip clip clip text") : Next : SetWidgetState(Widgets(Hex(#PB_GadgetType_Image)), 0) 
; ;     Widgets(Hex(#PB_GadgetType_Image)) = ImageWidget(170, 205, 160,95, img, #PB_Image_Border ) 
; ;     Widgets(Hex(#PB_GadgetType_HyperLink)) = HyperLinkWidget(170, 305, 160,95,"HyperLink_"+Hex(#PB_GadgetType_HyperLink)+" text clip clip clip clip text", $00FF00, #PB_HyperLink_Underline ) 
; ;     Widgets(Hex(#PB_GadgetType_Container)) = ContainerWidget(170, 405, 160,95, #PB_Container_Flat )
; ;     Widgets(Hex(101)) = OptionWidget(10, 10, 110,20, "Container_"+Hex(#PB_GadgetType_Container)+" text clip clip clip clip text" )  : SetWidgetState(Widgets(Hex(101)), 1)  
; ;     Widgets(Hex(102)) = OptionWidget(10, 40, 110,20, "Option_widget"+" text clip clip clip clip text");, #__flag_flat)  
; ;     CloseWidgetList()
;     Widgets(Hex(#PB_GadgetType_ListIcon)) = ListIconWidget(170, 505, 160,95,"ListIcon_"+Hex(#PB_GadgetType_ListIcon)+" text clip clip clip clip text",120 )                           
    
; ;     ;Widgets(Hex(#PB_GadgetType_IPAddress)) = IPAddress(335, 5, 160,95 ) : SetWidgetState(Widgets(Hex(#PB_GadgetType_IPAddress)), MakeIPAddress(1, 2, 3, 4))    
; ;     Widgets(Hex(#PB_GadgetType_ProgressBar)) = ProgressBarWidget(335, 105, 160,95,0,100, 0, 50) : SetWidgetState(Widgets(Hex(#PB_GadgetType_ProgressBar)), 50)
; ;     Widgets(Hex(#PB_GadgetType_ScrollBar)) = ScrollBarWidget(335, 205, 160,95,0,120,20) : SetWidgetState(Widgets(Hex(#PB_GadgetType_ScrollBar)), 50)
; ;     Widgets(Hex(#PB_GadgetType_ScrollArea)) = ScrollAreaWidget(335, 305, 160,95,180,90,1, #PB_ScrollArea_Flat ) : Widgets(Hex(201)) = ButtonWidget(0, 0, 150,20, "ScrollArea_"+Hex(#PB_GadgetType_ScrollArea)+" text clip clip clip clip text" ) : Widgets(Hex(202)) = ButtonWidget(180-150, 90-20, 150,20, "Button_"+Hex(202)+" text clip clip clip clip text" ) : CloseWidgetList()
; ;     Widgets(Hex(#PB_GadgetType_TrackBar)) = TrackBarWidget(335, 405, 160,95,0,21, #PB_TrackBar_Ticks ) : SetWidgetState(Widgets(Hex(#PB_GadgetType_TrackBar)), 11)
; ;     ;     WebGadget(#PB_GadgetType_Web, 335, 505, 160,95,"" )
; ;     
; ;     Widgets(Hex(#PB_GadgetType_ButtonImage)) = ButtonImageWidget(500, 5, 160,95, 1)
; ;     ;     CalendarGadget(#PB_GadgetType_Calendar, 500, 105, 160,95 )
; ;     ;     DateGadget(#PB_GadgetType_Date, 500, 205, 160,95 )
 ;   Widgets(Hex(#PB_GadgetType_Editor)) = EditorWidget(500, 305, 160,95 ) : AddItem(Widgets(Hex(#PB_GadgetType_Editor)), -1, "editor_"+Hex(#PB_GadgetType_Editor)+" text clip clip clip clip text")  
;     ;     Widgets(Hex(#PB_GadgetType_ExplorerList)) = ExplorerListWidget(500, 405, 160,95,"" )
;     ;     ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 505, 160,95,"" )
;     ;     
;     ;     ExplorerComboGadget(#PB_GadgetType_ExplorerCombo, 665, 5, 160,95,"" )
;     Widgets(Hex(#PB_GadgetType_Spin)) = SpinWidget(665, 105, 160,95,20,1000000000)
    
;     Widgets(Hex(#PB_GadgetType_Tree)) = TreeWidget( 665, 205, 160, 95 ) 
;     AddItem(Widgets(Hex(#PB_GadgetType_Tree)), -1, "Tree_"+Hex(#PB_GadgetType_Tree)+" text clip clip clip clip text") 
;     For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_Tree)), i, "item_"+Hex(i)+" text clip clip clip clip text") : Next
;     
; ;     Widgets(Hex(#PB_GadgetType_Panel)) = PanelWidget(665, 305, 160,95) 
; ;     AddItem(Widgets(Hex(#PB_GadgetType_Panel)), -1, "Panel_"+Hex(#PB_GadgetType_Panel)+" text clip clip clip clip text") 
; ;     Widgets(Hex(255)) = ButtonWidget(0, 0, 90,20, "Button_255"+" text clip clip clip clip text" ) 
; ;     For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_Panel)), i, "item_"+Hex(i)+" text clip clip clip clip text") : ButtonWidget(10,5,50,35, "butt_"+Str(i)+" text clip clip clip clip text") : Next 
; ;     CloseWidgetList()
; ;     
; ;     OpenWidgetList(Widgets(Hex(#PB_GadgetType_Panel)), 1)
; ;     ContainerWidget(10,5,150,55, #PB_Container_Flat) 
; ;     ContainerWidget(10,5,150,55, #PB_Container_Flat) 
; ;     ButtonWidget(10,5,50,35, "butt_1"+" text clip clip clip clip text") 
; ;     CloseWidgetList()
; ;     CloseWidgetList()
; ;     CloseWidgetList()
; ;     SetWidgetState( Widgets(Hex(#PB_GadgetType_Panel)), 4)
    
;     Widgets(Hex(301)) = SpinWidget(0, 0, 100,20,0,1000000000000000000, #__spin_plus)
;     Widgets(Hex(302)) = SpinWidget(0, 0, 100,20,0,1000000000000000000) : SetWidgetState(Widgets(Hex(302)), 100000000000 )               
;     Widgets(Hex(#PB_GadgetType_Splitter)) = SplitterWidget(665, 405, 160,95,Widgets(Hex(301)), Widgets(Hex(302)))
;     
;     Widgets(Hex(#PB_GadgetType_MDI)) = MDIWidget(665, 505, 160,95); ,#__flag_AutoSize)
;     Define *g = AddItem(Widgets(Hex(#PB_GadgetType_MDI)), -1, "form_0"+" text clip clip clip clip text")
;     ResizeWidget(*g, 7, 40, 120, 60)
;     
; ;     CloseWidgetList()
; ; ;     OpenWidgetList(Root())
; ;      ButtonWidget(10,5,50,35, "butt_1") 
;     
;     ;     CompilerEndIf
;     ;     InitScintilla()
;     ;     ScintillaGadget(#PB_GadgetType_Scintilla, 830, 5, 160,95,0 )
;     ;     ShortcutGadget(#PB_GadgetType_Shortcut, 830, 105, 160,95 ,-1)
;     ;     CanvasGadget(#PB_GadgetType_Canvas, 830, 205, 160,95 )
    
    CloseWidgetList()
    
    
    BindWidgetEvent(Widgets(Hex(#PB_GadgetType_ScrollBar)), @scrolled() )
    
    WaitCloseRoot( )
; ;     Repeat
; ;       Define  Event = WaitWindowEvent()
; ;     Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 67
; FirstLine = 53
; Folding = -
; EnableXP