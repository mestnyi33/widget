XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UseLib(widget)
  
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
  
  Global x,y,i,NewMap Widgets.i()
  
  
  If OpenWindow(#PB_Any, 0, 0, 995, 605, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Open(GetActiveWindow())
    ;
    ;Widgets("Container") = Container(0, 0, 995, 455);, #__flag_AutoSize) 
    
    Widgets(Hex(#PB_GadgetType_Button)) = Button(5, 5, 160,95, "Multiline Button_"+Hex(#PB_GadgetType_Button)+" (longer text gets automatically multiline)", #__button_multiLine ) 
    Widgets(Hex(#PB_GadgetType_String)) = String(5, 105, 160,95, "String_"+Hex(#PB_GadgetType_String)+" set"+#LF$+"multi"+#LF$+"line"+#LF$+"text")                                 
    Widgets(Hex(#PB_GadgetType_Text)) = Text(5, 205, 160,95, "Text_"+Hex(#PB_GadgetType_Text)+#LF$+"set"+#LF$+"multi"+#LF$+"line"+#LF$+"text", #__text_border)        
    Widgets(Hex(#PB_GadgetType_CheckBox)) = CheckBox(5, 305, 160,95, "CheckBox_"+Hex(#PB_GadgetType_CheckBox), #PB_CheckBox_ThreeState) : SetState(Widgets(Hex(#PB_GadgetType_CheckBox)), #PB_Checkbox_Inbetween)
    Widgets(Hex(#PB_GadgetType_Option)) = Option(5, 405, 160,95, "Option_"+Hex(#PB_GadgetType_Option) ) : SetState(Widgets(Hex(#PB_GadgetType_Option)), 1)                                                       
    Widgets(Hex(#PB_GadgetType_ListView)) = ListView(5, 505, 160,95) : AddItem(Widgets(Hex(#PB_GadgetType_ListView)), -1, "ListView_"+Hex(#PB_GadgetType_ListView)) : For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_ListView)), i, "item_"+Hex(i)) : Next
    
    Widgets(Hex(#PB_GadgetType_Frame)) = Frame(170, 5, 160,95, "Frame_"+Hex(#PB_GadgetType_Frame) )
    ;Widgets(Hex(#PB_GadgetType_ComboBox)) = ComboBox(170, 105, 160,95) : AddItem(Widgets(Hex(#PB_GadgetType_ComboBox)), -1, "ComboBox_"+Hex(#PB_GadgetType_ComboBox)) : For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_ComboBox)), i, "item_"+Hex(i)) : Next : SetState(Widgets(Hex(#PB_GadgetType_ComboBox)), 0) 
    Widgets(Hex(#PB_GadgetType_Image)) = Image(170, 205, 160,95, img, #PB_Image_Border ) 
    Widgets(Hex(#PB_GadgetType_HyperLink)) = HyperLink(170, 305, 160,95,"HyperLink_"+Hex(#PB_GadgetType_HyperLink), $00FF00, #PB_HyperLink_Underline ) 
    Widgets(Hex(#PB_GadgetType_Container)) = Container(170, 405, 160,95, #PB_Container_Flat )
    Widgets(Hex(101)) = Option(10, 10, 110,20, "Container_"+Hex(#PB_GadgetType_Container) )  : SetState(Widgets(Hex(101)), 1)  
    Widgets(Hex(102)) = Option(10, 40, 110,20, "Option_widget");, #__flag_flat)  
    CloseList()
    ;Widgets(Hex(#PB_GadgetType_ListIcon)) = ListIcon(170, 505, 160,95,"ListIcon_"+Hex(#PB_GadgetType_ListIcon),120 )                           
    
    ;Widgets(Hex(#PB_GadgetType_IPAddress)) = IPAddress(335, 5, 160,95 ) : SetState(Widgets(Hex(#PB_GadgetType_IPAddress)), MakeIPAddress(1, 2, 3, 4))    
    Widgets(Hex(#PB_GadgetType_ProgressBar)) = Progress(335, 105, 160,95,0,100) : SetState(Widgets(Hex(#PB_GadgetType_ProgressBar)), 50)
    Widgets(Hex(#PB_GadgetType_ScrollBar)) = Scroll(335, 205, 160,95,0,100,20) : SetState(Widgets(Hex(#PB_GadgetType_ScrollBar)), 40)
    Widgets(Hex(#PB_GadgetType_ScrollArea)) = ScrollArea(335, 305, 160,95,180,90,1, #PB_ScrollArea_Flat ) : Widgets(Hex(201)) = Button(0, 0, 150,20, "ScrollArea_"+Hex(#PB_GadgetType_ScrollArea) ) : Widgets(Hex(202)) = Button(180-150, 90-20, 150,20, "Button_"+Hex(202) ) : CloseList()
    Widgets(Hex(#PB_GadgetType_TrackBar)) = Track(335, 405, 160,95,0,21, #__Bar_Ticks) : SetState(Widgets(Hex(#PB_GadgetType_TrackBar)), 11)
    ;     WebGadget(#PB_GadgetType_Web, 335, 505, 160,95,"" )
    
    Widgets(Hex(#PB_GadgetType_ButtonImage)) = ButtonImage(500, 5, 160,95, 1)
    ;     CalendarGadget(#PB_GadgetType_Calendar, 500, 105, 160,95 )
    ;     DateGadget(#PB_GadgetType_Date, 500, 205, 160,95 )
    Widgets(Hex(#PB_GadgetType_Editor)) = Editor(500, 305, 160,95 ) : AddItem(Widgets(Hex(#PB_GadgetType_Editor)), -1, "set"+#LF$+"editor"+#LF$+"_"+Hex(#PB_GadgetType_Editor) +#LF$+"add"+#LF$+"multi"+#LF$+"line"+#LF$+"text")  
    ;     Widgets(Hex(#PB_GadgetType_ExplorerList)) = ExplorerList(500, 405, 160,95,"" )
    ;     ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 505, 160,95,"" )
    ;     
    ;     ExplorerComboGadget(#PB_GadgetType_ExplorerCombo, 665, 5, 160,95,"" )
    Widgets(Hex(#PB_GadgetType_Spin)) = Spin(665, 105, 160,95,20,100)
    
    Widgets(Hex(#PB_GadgetType_Tree)) = Tree( 665, 205, 160, 95 ) 
    AddItem(Widgets(Hex(#PB_GadgetType_Tree)), -1, "Tree_"+Hex(#PB_GadgetType_Tree)) 
    For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_Tree)), i, "item_"+Hex(i)) : Next
    
    Widgets(Hex(#PB_GadgetType_Panel)) = Panel(665, 305, 160,95) 
    AddItem(Widgets(Hex(#PB_GadgetType_Panel)), -1, "Panel_"+Hex(#PB_GadgetType_Panel)) 
    Widgets(Hex(255)) = Button(0, 0, 90,20, "Button_255" ) 
    For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_Panel)), i, "item_"+Hex(i)) : Button(10,5,50,35, "butt_"+Str(i)) : Next 
    CloseList()
    
    OpenList(Widgets(Hex(#PB_GadgetType_Panel)), 1)
    Container(10,5,150,55, #PB_Container_Flat) 
    Container(10,5,150,55, #PB_Container_Flat) 
    Button(10,5,50,35, "butt_1") 
    CloseList()
    CloseList()
    CloseList()
    SetState( Widgets(Hex(#PB_GadgetType_Panel)), 4)
    
    Widgets(Hex(301)) = Spin(0, 0, 100,20,0,10, #__bar_Vertical)
    Widgets(Hex(302)) = Spin(0, 0, 100,20,0,10)                 
    Widgets(Hex(#PB_GadgetType_Splitter)) = Splitter(665, 405, 160,95,Widgets(Hex(301)), Widgets(Hex(302)))
    
    Widgets(Hex(#PB_GadgetType_MDI)) = MDI(665, 505, 160,95); ,#__flag_AutoSize)
    Define *g = AddItem(Widgets(Hex(#PB_GadgetType_MDI)), -1, "form_0")
    Resize(*g, #PB_Ignore, 40, 120, 60)
    
;     CloseList()
; ;     OpenList(Root())
;      Button(10,5,50,35, "butt_1") 
    
    ;     CompilerEndIf
    ;     InitScintilla()
    ;     ScintillaGadget(#PB_GadgetType_Scintilla, 830, 5, 160,95,0 )
    ;     ShortcutGadget(#PB_GadgetType_Shortcut, 830, 105, 160,95 ,-1)
    ;     CanvasGadget(#PB_GadgetType_Canvas, 830, 205, 160,95 )
    
    CloseList()
    
    ReDraw(Root())
    
    Repeat
      Define  Event = WaitWindowEvent()
    Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP