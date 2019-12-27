IncludePath "../"
XIncludeFile "widgets().pbi"
;XIncludeFile "widgets(_align_0_0_0).pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UseModule Widget
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
    End
  EndIf
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Global x,y,i,NewMap Widgets.i()
  
  
  If Open(#PB_Any, 0, 0, 995, 605, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ;
    ;Widgets("Container") = Container(0, 0, 995, 455);, #__flag_AutoSize) 
    
    Widgets(Hex(#PB_GadgetType_Button)) = Button(5, 5, 160,95, " Multiline Button_"+Hex(#PB_GadgetType_Button)+" (longer text gets automatically multiline)", #__button_MultiLine ) ; ok
    Widgets(Hex(#PB_GadgetType_String)) = String(5, 105, 160,95, "String_"+Hex(#PB_GadgetType_String)); ok
    Widgets(Hex(#PB_GadgetType_Text)) = Text(5, 205, 160,95, "Text_"+Hex(#PB_GadgetType_Text))        ; ok
    Widgets(Hex(#PB_GadgetType_CheckBox)) = CheckBox(5, 305, 160,95, "CheckBox_"+Hex(#PB_GadgetType_CheckBox), #PB_CheckBox_ThreeState) : SetState(Widgets(Hex(#PB_GadgetType_CheckBox)), #PB_Checkbox_Inbetween); ok
    Widgets(Hex(#PB_GadgetType_Option)) = Option(5, 405, 160,95, "Option_"+Hex(#PB_GadgetType_Option) ) : SetState(Widgets(Hex(#PB_GadgetType_Option)), 1)                                                       ; ok
    Widgets(Hex(#PB_GadgetType_ListView)) = ListView(5, 505, 160,95) : AddItem(Widgets(Hex(#PB_GadgetType_ListView)), -1, "ListView_"+Hex(#PB_GadgetType_ListView)) : For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_ListView)), i, "item_"+Hex(i)) : Next
    
    Widgets(Hex(#PB_GadgetType_Frame)) = Frame(170, 5, 160,95, "Frame_"+Hex(#PB_GadgetType_Frame) )
    ;Widgets(Hex(#PB_GadgetType_ComboBox)) = ComboBox(170, 105, 160,95) : AddItem(Widgets(Hex(#PB_GadgetType_ComboBox)), -1, "ComboBox_"+Hex(#PB_GadgetType_ComboBox)) : For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_ComboBox)), i, "item_"+Hex(i)) : Next : SetState(Widgets(Hex(#PB_GadgetType_ComboBox)), 0) 
    Widgets(Hex(#PB_GadgetType_Image)) = Image(170, 205, 160,95, 0, #PB_Image_Border ) ; ok
    Widgets(Hex(#PB_GadgetType_HyperLink)) = HyperLink(170, 305, 160,95,"HyperLink_"+Hex(#PB_GadgetType_HyperLink), $00FF00, #PB_HyperLink_Underline ) ; ok
    Widgets(Hex(#PB_GadgetType_Container)) = Container(170, 405, 160,95, #PB_Container_Flat )
    Widgets(Hex(101)) = Option(10, 10, 110,20, "Container_"+Hex(#PB_GadgetType_Container) )  : SetState(Widgets(Hex(101)), 1)  
    Widgets(Hex(102)) = Option(10, 40, 110,20, "Option_widget" )  
    CloseList()
    Widgets(Hex(#PB_GadgetType_ListIcon)) = ListIcon(170, 505, 160,95,"ListIcon_"+Hex(#PB_GadgetType_ListIcon),120 )                           ; ok
    
    Widgets(Hex(#PB_GadgetType_IPAddress)) = IPAddress(335, 5, 160,95 ) : SetState(Widgets(Hex(#PB_GadgetType_IPAddress)), MakeIPAddress(1, 2, 3, 4))    ; ok
    Widgets(Hex(#PB_GadgetType_ProgressBar)) = Progress(335, 105, 160,95,0,100) : SetState(Widgets(Hex(#PB_GadgetType_ProgressBar)), 50)
    Widgets(Hex(#PB_GadgetType_ScrollBar)) = Scroll(335, 205, 160,95,0,100,20) : SetState(Widgets(Hex(#PB_GadgetType_ScrollBar)), 40)
    Widgets(Hex(#PB_GadgetType_ScrollArea)) = ScrollArea(335, 305, 160,95,180,90,1, #PB_ScrollArea_Flat ) : Widgets(Hex(201)) = Button(0, 0, 150,20, "ScrollArea_"+Hex(#PB_GadgetType_ScrollArea) ) : Widgets(Hex(202)) = Button(180-150, 90-20, 150,20, "Button_"+Hex(202) ) : CloseList()
    Widgets(Hex(#PB_GadgetType_TrackBar)) = Track(335, 405, 160,95,0,100, #PB_TrackBar_Ticks) : SetState(Widgets(Hex(#PB_GadgetType_TrackBar)), 50)
    ;     WebGadget(#PB_GadgetType_Web, 335, 505, 160,95,"" )
    
    Widgets(Hex(#PB_GadgetType_ButtonImage)) = Button(500, 5, 160,95, "", 0, 1)
    ;     CalendarGadget(#PB_GadgetType_Calendar, 500, 105, 160,95 )
    ;     DateGadget(#PB_GadgetType_Date, 500, 205, 160,95 )
    Widgets(Hex(#PB_GadgetType_Editor)) = Editor(500, 305, 160,95 ) : AddItem(Widgets(Hex(#PB_GadgetType_Editor)), -1, "Editor_"+Hex(#PB_GadgetType_Editor))  
    Widgets(Hex(#PB_GadgetType_ExplorerList)) = ExplorerList(500, 405, 160,95,"" )
    ;     ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 505, 160,95,"" )
    ;     
    ;     ExplorerComboGadget(#PB_GadgetType_ExplorerCombo, 665, 5, 160,95,"" )
    Widgets(Hex(#PB_GadgetType_Spin)) = Spin(665, 105, 160,95,20,100)
    Widgets(Hex(#PB_GadgetType_Tree)) = Tree( 665, 205, 160, 95 ) : AddItem(Widgets(Hex(#PB_GadgetType_Tree)), -1, "Tree_"+Hex(#PB_GadgetType_Tree)) : For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_Tree)), i, "item_"+Hex(i)) : Next
    Widgets(Hex(#PB_GadgetType_Panel)) = Panel(665, 305, 160,95) : AddItem(Widgets(Hex(#PB_GadgetType_Panel)), -1, "Panel_"+Hex(#PB_GadgetType_Panel)) : Widgets(Hex(255)) = Button(0, 0, 90,20, "Button_255" ) : For i=1 To 15 : AddItem(Widgets(Hex(#PB_GadgetType_Panel)), i, "item_"+Hex(i)) : Next : CloseList()
    
    OpenList(Widgets(Hex(#PB_GadgetType_Panel)), 1)
    Container(10,5,150,55, #PB_Container_Flat) 
    Container(10,5,150,55, #PB_Container_Flat) 
    Button(10,5,50,35, "butt") 
    CloseList()
    CloseList()
    CloseList()
    ;SetState( Widgets(Hex(#PB_GadgetType_Panel)), 12)
    
    Widgets(Hex(301)) = Spin(0, 0, 100,20,0,10, #__flag_Vertical);, "Button_1")
    Widgets(Hex(302)) = Spin(0, 0, 100,20,0,10)              ;, "Button_2")
    Widgets(Hex(#PB_GadgetType_Splitter)) = Splitter(665, 405, 160,95,Widgets(Hex(301)), Widgets(Hex(302)));, #PB_Splitter_Vertical);, Button(0, 0, 100,20, "ButtonGadget"), Button(0, 0, 0,20, "StringGadget")) 
                                                                                                           ;     CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                                                                                                           ;       MDIGadget(#PB_GadgetType_MDI, 665, 505, 160,95,1, 2);, #PB_MDI_AutoSize)
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
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP