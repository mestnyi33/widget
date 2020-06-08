; comment uncomment to see
XIncludeFile "gadgets.pbi" : UseModule gadget

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Global x,y,i
  
  
  If OpenWindow(#PB_Any, 0, 0, 995, 605, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;     Open(GetActiveWindow())
;     ;
;     ;Widgets("Container") = Container(0, 0, 995, 455);, #pb_flag_AutoSize) 
;     
     ButtonGadget(#PB_GadgetType_Button, 5, 5, 160,95, "Multiline Button_"+Str(#PB_GadgetType_Button)+" (longer text gets automatically multiline)", #PB_Button_MultiLine ) 
;     Widgets(Str(#PB_GadgetType_String)) = String(5, 105, 160,95, "String_"+Str(#PB_GadgetType_String)+" set"+#LF$+"multi"+#LF$+"line"+#LF$+"text")                                 
     TextGadget(#PB_GadgetType_Text, 5, 205, 160,95, "Text_"+Str(#PB_GadgetType_Text)+#LF$+"set"+#LF$+"multi"+#LF$+"line"+#LF$+"text", #PB_Text_Border)        
 CheckBoxGadget(#PB_GadgetType_CheckBox, 5, 305, 160,95, "CheckBox_"+Str(#PB_GadgetType_CheckBox), #PB_CheckBox_ThreeState) : SetGadgetState(#PB_GadgetType_CheckBox, #PB_Checkbox_Inbetween)
 OptionGadget(#PB_GadgetType_Option, 5, 405, 160,95, "Option_"+Str(#PB_GadgetType_Option) ) : SetGadgetState(#PB_GadgetType_Option, 1)                                                       
;     Widgets(Str(#PB_GadgetType_ListView)) = ListView(5, 505, 160,95) : AddItem(Widgets(Str(#PB_GadgetType_ListView)), -1, "ListView_"+Str(#PB_GadgetType_ListView)) : For i=1 To 5 : AddItem(Widgets(Str(#PB_GadgetType_ListView)), i, "item_"+Str(i)) : Next
;     
;     Widgets(Str(#PB_GadgetType_Frame)) = Frame(170, 5, 160,95, "Frame_"+Str(#PB_GadgetType_Frame) )
;     ;Widgets(Str(#PB_GadgetType_ComboBox)) = ComboBox(170, 105, 160,95) : AddItem(Widgets(Str(#PB_GadgetType_ComboBox)), -1, "ComboBox_"+Str(#PB_GadgetType_ComboBox)) : For i=1 To 5 : AddItem(Widgets(Str(#PB_GadgetType_ComboBox)), i, "item_"+Str(i)) : Next : SetState(Widgets(Str(#PB_GadgetType_ComboBox)), 0) 
;     Widgets(Str(#PB_GadgetType_Image)) = Image(170, 205, 160,95, 0, #PB_Image_Border ) 
HyperLinkGadget(#PB_GadgetType_HyperLink, 170, 305, 160,95,"HyperLink_"+Str(#PB_GadgetType_HyperLink), $00FF00, #PB_HyperLink_Underline ) 
;     Widgets(Str(#PB_GadgetType_Container)) = Container(170, 405, 160,95, #PB_Container_Flat )
;     Widgets(Str(101)) = Option(10, 10, 110,20, "Container_"+Str(#PB_GadgetType_Container) )  : SetState(Widgets(Str(101)), 1)  
;     Widgets(Str(102)) = Option(10, 40, 110,20, "Option_widget");, #pb_flag_flat)  
;     CloseList()
;     ;Widgets(Str(#PB_GadgetType_ListIcon)) = ListIcon(170, 505, 160,95,"ListIcon_"+Str(#PB_GadgetType_ListIcon),120 )                           
;     
;     ;Widgets(Str(#PB_GadgetType_IPAddress)) = IPAddress(335, 5, 160,95 ) : SetState(Widgets(Str(#PB_GadgetType_IPAddress)), MakeIPAddress(1, 2, 3, 4))    
;     Widgets(Str(#PB_GadgetType_ProgressBar)) = Progress(335, 105, 160,95,0,100) : SetState(Widgets(Str(#PB_GadgetType_ProgressBar)), 50)
;     Widgets(Str(#PB_GadgetType_ScrollBar)) = Scroll(335, 205, 160,95,0,100,20) : SetState(Widgets(Str(#PB_GadgetType_ScrollBar)), 40)
;     Widgets(Str(#PB_GadgetType_ScrollArea)) = ScrollArea(335, 305, 160,95,180,90,1, #PB_ScrollArea_Flat ) : Widgets(Str(201)) = Button(0, 0, 150,20, "ScrollArea_"+Str(#PB_GadgetType_ScrollArea) ) : Widgets(Str(202)) = Button(180-150, 90-20, 150,20, "Button_"+Str(202) ) : CloseList()
;     Widgets(Str(#PB_GadgetType_TrackBar)) = Track(335, 405, 160,95,0,21, #pb_Bar_Ticks) : SetState(Widgets(Str(#PB_GadgetType_TrackBar)), 11)
;     ;     WebGadget(#PB_GadgetType_Web, 335, 505, 160,95,"" )
;     
;     ;Widgets(Str(#PB_GadgetType_ButtonImage)) = Button(500, 5, 160,95, "", 0, 1)
;     ;     CalendarGadget(#PB_GadgetType_Calendar, 500, 105, 160,95 )
;     ;     DateGadget(#PB_GadgetType_Date, 500, 205, 160,95 )
;     Widgets(Str(#PB_GadgetType_Editor)) = Editor(500, 305, 160,95 ) : AddItem(Widgets(Str(#PB_GadgetType_Editor)), -1, "set"+#LF$+"editor"+#LF$+"_"+Str(#PB_GadgetType_Editor) +#LF$+"add"+#LF$+"multi"+#LF$+"line"+#LF$+"text")  
;     ;     Widgets(Str(#PB_GadgetType_ExplorerList)) = ExplorerList(500, 405, 160,95,"" )
;     ;     ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 505, 160,95,"" )
;     ;     
;     ;     ExplorerComboGadget(#PB_GadgetType_ExplorerCombo, 665, 5, 160,95,"" )
;     Widgets(Str(#PB_GadgetType_Spin)) = Spin(665, 105, 160,95,20,100)
;     
;     Widgets(Str(#PB_GadgetType_Tree)) = Tree( 665, 205, 160, 95 ) 
;     AddItem(Widgets(Str(#PB_GadgetType_Tree)), -1, "Tree_"+Str(#PB_GadgetType_Tree)) 
;     For i=1 To 5 : AddItem(Widgets(Str(#PB_GadgetType_Tree)), i, "item_"+Str(i)) : Next
;     
;     Widgets(Str(#PB_GadgetType_Panel)) = Panel(665, 305, 160,95) 
;     AddItem(Widgets(Str(#PB_GadgetType_Panel)), -1, "Panel_"+Str(#PB_GadgetType_Panel)) 
;     Widgets(Str(255)) = Button(0, 0, 90,20, "Button_255" ) 
;     For i=1 To 5 : AddItem(Widgets(Str(#PB_GadgetType_Panel)), i, "item_"+Str(i)) : Button(10,5,50,35, "butt_"+Str(i)) : Next 
;     CloseList()
;     
;     OpenList(Widgets(Str(#PB_GadgetType_Panel)), 1)
;     Container(10,5,150,55, #PB_Container_Flat) 
;     Container(10,5,150,55, #PB_Container_Flat) 
;     Button(10,5,50,35, "butt_1") 
;     CloseList()
;     CloseList()
;     CloseList()
;     SetState( Widgets(Str(#PB_GadgetType_Panel)), 4)
;     
;     Widgets(Str(301)) = Spin(0, 0, 100,20,0,10, #pb_bar_Vertical)
;     Widgets(Str(302)) = Spin(0, 0, 100,20,0,10)                 
;SplitterGadget(#PB_GadgetType_Splitter, 665, 405, 160, 95, ButtonGadget(-1, 0,0,0,0, "butt1"), ButtonGadget(-1, 0,0,0,0, "butt2"))
;     
;     Widgets(Str(#PB_GadgetType_MDI)) = MDI(665, 505, 160,95); ,#pb_flag_AutoSize)
;     Define *g = AddItem(Widgets(Str(#PB_GadgetType_MDI)), -1, "form_0")
;     Resize(*g, #PB_Ignore, 40, 120, 60)
;     
; ;     CloseList()
; ; ;     OpenList(Root())
; ;      Button(10,5,50,35, "butt_1") 
;     
;     ;     CompilerEndIf
;     ;     InitScintilla()
;     ;     ScintillaGadget(#PB_GadgetType_Scintilla, 830, 5, 160,95,0 )
;     ;     ShortcutGadget(#PB_GadgetType_Shortcut, 830, 105, 160,95 ,-1)
;     ;     CanvasGadget(#PB_GadgetType_Canvas, 830, 205, 160,95 )
;     
;     CloseList()
;     
;     ReDraw(Root())
    
    Repeat
      Define  Event = WaitWindowEvent()
    Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP