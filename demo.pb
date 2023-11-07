XIncludeFile "widgets.pbi"
;https://github.com/Hoeppner1867?tab=followers
;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(widget)
  
  UsePNGImageDecoder()
  
  Global img1 = 1
  Global img2 = 2
  Global x,y,i,NewMap Widgets.i(), round = 0
  
  If Not LoadImage(img2, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(img1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Procedure scrolled( )
     SetState( Widgets(Hex(#PB_GadgetType_ProgressBar)), GetState( Widgets(Hex(#PB_GadgetType_ScrollBar))))
  EndProcedure
  
  If Open(0, 0, 0, 995, 605, "demo then draw widgets on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    a_init(root(),0)
    ;
    ;Widgets("Container") = Container(0, 0, 0, 0, #__flag_AutoSize) 
    ;\\ 1
    Widgets(Hex(#PB_GadgetType_Button)) = Button(5, 5, 160,95, "Multiline Button_"+Hex(#PB_GadgetType_Button)+" (longer text gets automatically multiline)", #__button_multiLine, - 1, round ) 
    Widgets(Hex(#PB_GadgetType_String)) = String(5, 105, 160,95, "String_"+Hex(#PB_GadgetType_String)+" set"+#LF$+"multi"+#LF$+"line"+#LF$+"text")                                 
    Widgets(Hex(#PB_GadgetType_Text)) = Text(5, 205, 160,95, "Text_"+Hex(#PB_GadgetType_Text)+#LF$+"set"+#LF$+"multi"+#LF$+"line"+#LF$+"text", #PB_Text_Border)        
    Widgets(Hex(#PB_GadgetType_CheckBox)) = CheckBox(5, 305, 160,95, "CheckBox_"+Hex(#PB_GadgetType_CheckBox), #PB_CheckBox_ThreeState) : SetState(Widgets(Hex(#PB_GadgetType_CheckBox)), #PB_Checkbox_Inbetween)
    Widgets(Hex(#PB_GadgetType_Option)) = Option(5, 405, 160,95, "Option_"+Hex(#PB_GadgetType_Option) ) : SetState(Widgets(Hex(#PB_GadgetType_Option)), 1)                                                       
    Widgets(Hex(#PB_GadgetType_ListView)) = ListView(5, 505, 160,95) : AddItem(Widgets(Hex(#PB_GadgetType_ListView)), -1, "ListView_"+Hex(#PB_GadgetType_ListView)) : For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_ListView)), i, "item_"+Hex(i)) : Next
    
    ;\\ 2
    Widgets(Hex(#PB_GadgetType_Frame)) = Frame(170, 5, 160,95, "Frame_"+Hex(#PB_GadgetType_Frame) )
    Widgets(Hex(#PB_GadgetType_ComboBox)) = ComboBox(170, 105, 160,95, #PB_ComboBox_Editable) : AddItem(Widgets(Hex(#PB_GadgetType_ComboBox)), -1, "ComboBox_"+Hex(#PB_GadgetType_ComboBox)) : For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_ComboBox)), i, "item_"+Hex(i)) : Next : SetState(Widgets(Hex(#PB_GadgetType_ComboBox)), 0) 
    Widgets(Hex(#PB_GadgetType_Image)) = Image(170, 205, 160,95, img2, #PB_Image_Border ) 
    Widgets(Hex(#PB_GadgetType_HyperLink)) = HyperLink(170, 305, 160,95,"HyperLink_"+Hex(#PB_GadgetType_HyperLink), $00FF00, #PB_HyperLink_Underline ) 
    Widgets(Hex(#PB_GadgetType_Container)) = Container(170, 405, 160,95, #PB_Container_Flat )
    Widgets(Hex(101)) = Option(10, 10, 110,20, "Container_"+Hex(#PB_GadgetType_Container) )  : SetState(Widgets(Hex(101)), 1)  
    Widgets(Hex(102)) = Option(10, 40, 110,20, "Option_widget");, #__flag_flat)  
    CloseList()
    Widgets(Hex(#PB_GadgetType_ListIcon)) = ListIcon(170, 505, 160,95,"ListIcon_"+Hex(#PB_GadgetType_ListIcon),120 )                           
    
    ;\\ 3
    ;Widgets(Hex(#PB_GadgetType_IPAddress)) = IPAddress(335, 5, 160,95 ) : SetState(Widgets(Hex(#PB_GadgetType_IPAddress)), MakeIPAddress(1, 2, 3, 4))    
    Widgets(Hex(#PB_GadgetType_ProgressBar)) = Progress(335, 105, 160,95,0,100, 0, round) : SetState(Widgets(Hex(#PB_GadgetType_ProgressBar)), 50)
    Widgets(Hex(#PB_GadgetType_ScrollBar)) = Scroll(335, 205, 160,95,0,120,20) : SetState(Widgets(Hex(#PB_GadgetType_ScrollBar)), 50)
    Widgets(Hex(#PB_GadgetType_ScrollArea)) = ScrollArea(335, 305, 160,95,180,90,1, #PB_ScrollArea_Flat ) : Widgets(Hex(201)) = Button(0, 0, 150,20, "ScrollArea_"+Hex(#PB_GadgetType_ScrollArea) ) : Widgets(Hex(202)) = Button(180-150, 90-20, 150,20, "Button_"+Hex(202) ) : CloseList()
    Widgets(Hex(#PB_GadgetType_TrackBar)) = Track(335, 405, 160,95,0,21, #PB_TrackBar_Ticks ) : SetState(Widgets(Hex(#PB_GadgetType_TrackBar)), 11)
    ;     WebGadget(#PB_GadgetType_Web, 335, 505, 160,95,"" )
    
    ;\\ 4
    Widgets(Hex(#PB_GadgetType_ButtonImage)) = ButtonImage(500, 5, 160,95, img1)
    ;     CalendarGadget(#PB_GadgetType_Calendar, 500, 105, 160,95 )
    ;     DateGadget(#PB_GadgetType_Date, 500, 205, 160,95 )
    Widgets(Hex(#PB_GadgetType_Editor)) = Editor(500, 305, 160,95 ) : AddItem(Widgets(Hex(#PB_GadgetType_Editor)), -1, "editor_"+Hex(#PB_GadgetType_Editor) +#LF$+"add"+#LF$+"multi"+#LF$+"line"+#LF$+"text")  
    ;     Widgets(Hex(#PB_GadgetType_ExplorerList)) = ExplorerList(500, 405, 160,95,"" )
    ;     ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 505, 160,95,"" )
    
    ;\\ 5   
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
    Widgets(Hex(301)) = Spin(0, 0, 100,20,0,10, #__spin_plus)
    Widgets(Hex(302)) = Spin(0, 0, 100,20,0,10) ; Button(0, 0, 100,20,"splitt-button")                 
    Widgets(Hex(#PB_GadgetType_Splitter)) = Splitter(665, 405, 160,95,Widgets(Hex(301)), Widgets(Hex(302)))
    Widgets(Hex(#PB_GadgetType_MDI)) = MDI(665, 505, 160,95)
    Resize(AddItem(Widgets(Hex(#PB_GadgetType_MDI)), -1, "form_0"), 7, 40, 120, 60)
    
    ;\\ 6
    ;     InitScintilla()
    ;     ScintillaGadget(#PB_GadgetType_Scintilla, 830, 5, 160,95,0 )
    ;     ShortcutGadget(#PB_GadgetType_Shortcut, 830, 105, 160,95 ,-1)
    ;     CanvasGadget(#PB_GadgetType_Canvas, 830, 205, 160,95 )
    
    CloseList()
    
    ;\\
    Bind(Widgets(Hex(#PB_GadgetType_ScrollBar)), @scrolled(), #__event_change )
    WaitClose( )
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 84
; FirstLine = 59
; Folding = -
; EnableXP