XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UseWidgets( )
  
  UsePNGImageDecoder()
  
  Global img = 2
  
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
    ;
    ;Widgets("Container") = ContainerWidget(0, 0, 995, 455);, #__flag_AutoSize) 
    
    Widgets(Hex(#PB_GadgetType_Button)) = ButtonWidget(5, 5, 160,95, "Multiline Button_"+Hex(#PB_GadgetType_Button)+" (longer text gets automatically multiline)", #__flag_Textmultiline ) 
    Widgets(Hex(#PB_GadgetType_String)) = StringWidget(5, 105, 160,95, "String_"+Hex(#PB_GadgetType_String)+" set"+#LF$+"multi"+#LF$+"line"+#LF$+"text")                                 
    Widgets(Hex(#PB_GadgetType_Text)) = TextWidget(5, 205, 160,95, "Text_"+Hex(#PB_GadgetType_Text)+#LF$+"set"+#LF$+"multi"+#LF$+"line"+#LF$+"text", #PB_Text_Border)        
    Widgets(Hex(#PB_GadgetType_CheckBox)) = CheckBoxWidget(5, 305, 160,95, "CheckBox_"+Hex(#PB_GadgetType_CheckBox), #PB_CheckBox_ThreeState) : SetWidgetState(Widgets(Hex(#PB_GadgetType_CheckBox)), #PB_Checkbox_Inbetween)
    Widgets(Hex(#PB_GadgetType_Option)) = OptionWidget(5, 405, 160,95, "Option_"+Hex(#PB_GadgetType_Option) ) : SetWidgetState(Widgets(Hex(#PB_GadgetType_Option)), 1)                                                       
    Widgets(Hex(#PB_GadgetType_ListView)) = ListViewWidget(5, 505, 160,95) : AddItem(Widgets(Hex(#PB_GadgetType_ListView)), -1, "ListView_"+Hex(#PB_GadgetType_ListView)) : For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_ListView)), i, "item_"+Hex(i)) : Next
    
    Widgets(Hex(#PB_GadgetType_Frame)) = FrameWidget(170, 5, 160,95, "Frame_"+Hex(#PB_GadgetType_Frame) )
    Widgets(Hex(#PB_GadgetType_ComboBox)) = ComboBoxWidget(170, 105, 160,95) : AddItem(Widgets(Hex(#PB_GadgetType_ComboBox)), -1, "ComboBox_"+Hex(#PB_GadgetType_ComboBox)) : For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_ComboBox)), i, "item_"+Hex(i)) : Next : SetWidgetState(Widgets(Hex(#PB_GadgetType_ComboBox)), 0) 
    Widgets(Hex(#PB_GadgetType_Image)) = ImageWidget(170, 205, 160,95, img, #PB_Image_Border ) 
    Widgets(Hex(#PB_GadgetType_HyperLink)) = HyperLinkWidget(170, 305, 160,95,"HyperLink_"+Hex(#PB_GadgetType_HyperLink), $00FF00, #PB_HyperLink_Underline ) 
    Widgets(Hex(#PB_GadgetType_Container)) = ContainerWidget(170, 405, 160,95, #PB_Container_Flat )
    Widgets(Hex(101)) = OptionWidget(10, 10, 110,20, "Container_"+Hex(#PB_GadgetType_Container) )  : SetWidgetState(Widgets(Hex(101)), 1)  
    Widgets(Hex(102)) = OptionWidget(10, 40, 110,20, "Option_widget");, #__flag_flat)  
    CloseWidgetList()
    ;Widgets(Hex(#PB_GadgetType_ListIcon)) = ListIconWidget(170, 505, 160,95,"ListIcon_"+Hex(#PB_GadgetType_ListIcon),120 )                           
    
    ;Widgets(Hex(#PB_GadgetType_IPAddress)) = IPAddress(335, 5, 160,95 ) : SetWidgetState(Widgets(Hex(#PB_GadgetType_IPAddress)), MakeIPAddress(1, 2, 3, 4))    
    Widgets(Hex(#PB_GadgetType_ProgressBar)) = ProgressBarWidget(335, 105, 160,95,0,100, 0, 50) : SetWidgetState(Widgets(Hex(#PB_GadgetType_ProgressBar)), 50)
    Widgets(Hex(#PB_GadgetType_ScrollBar)) = ScrollBarWidget(335, 205, 160,95,0,120,20) : SetWidgetState(Widgets(Hex(#PB_GadgetType_ScrollBar)), 50)
    Widgets(Hex(#PB_GadgetType_ScrollArea)) = ScrollAreaWidget(335, 305, 160,95,180,90,1, #PB_ScrollArea_Flat ) : Widgets(Hex(201)) = ButtonWidget(0, 0, 150,20, "ScrollArea_"+Hex(#PB_GadgetType_ScrollArea) ) : Widgets(Hex(202)) = ButtonWidget(180-150, 90-20, 150,20, "Button_"+Hex(202) ) : CloseWidgetList()
    Widgets(Hex(#PB_GadgetType_TrackBar)) = TrackBarWidget(335, 405, 160,95,0,21, #PB_TrackBar_Ticks ) : SetWidgetState(Widgets(Hex(#PB_GadgetType_TrackBar)), 11)
    ;     WebGadget(#PB_GadgetType_Web, 335, 505, 160,95,"" )
    
    Widgets(Hex(#PB_GadgetType_ButtonImage)) = ButtonImageWidget(500, 5, 160,95, 1)
    ;     CalendarGadget(#PB_GadgetType_Calendar, 500, 105, 160,95 )
    ;     DateGadget(#PB_GadgetType_Date, 500, 205, 160,95 )
    Widgets(Hex(#PB_GadgetType_Editor)) = EditorWidget(500, 305, 160,95 ) : AddItem(Widgets(Hex(#PB_GadgetType_Editor)), -1, "set"+#LF$+"editor"+#LF$+"_"+Hex(#PB_GadgetType_Editor) +#LF$+"add"+#LF$+"multi"+#LF$+"line"+#LF$+"text")  
    ;     Widgets(Hex(#PB_GadgetType_ExplorerList)) = ExplorerListWidget(500, 405, 160,95,"" )
    ;     ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 505, 160,95,"" )
    ;     
    ;     ExplorerComboGadget(#PB_GadgetType_ExplorerCombo, 665, 5, 160,95,"" )
    Widgets(Hex(#PB_GadgetType_Spin)) = SpinWidget(665, 105, 160,95,20,100)
    
    Widgets(Hex(#PB_GadgetType_Tree)) = TreeWidget( 665, 205, 160, 95 ) 
    AddItem(Widgets(Hex(#PB_GadgetType_Tree)), -1, "Tree_"+Hex(#PB_GadgetType_Tree)) 
    For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_Tree)), i, "item_"+Hex(i)) : Next
    
    Widgets(Hex(#PB_GadgetType_Panel)) = PanelWidget(665, 305, 160,95) 
    AddItem(Widgets(Hex(#PB_GadgetType_Panel)), -1, "Panel_"+Hex(#PB_GadgetType_Panel)) 
    Widgets(Hex(255)) = ButtonWidget(0, 0, 90,20, "Button_255" ) 
    For i=1 To 5 : AddItem(Widgets(Hex(#PB_GadgetType_Panel)), i, "item_"+Hex(i)) : ButtonWidget(10,5,50,35, "butt_"+Str(i)) : Next 
    CloseWidgetList()
    
    OpenWidgetList(Widgets(Hex(#PB_GadgetType_Panel)), 1)
    ContainerWidget(10,5,150,55, #PB_Container_Flat) 
    ContainerWidget(10,5,150,55, #PB_Container_Flat) 
    ButtonWidget(10,5,50,35, "butt_1") 
    CloseWidgetList()
    CloseWidgetList()
    CloseWidgetList()
    SetWidgetState( Widgets(Hex(#PB_GadgetType_Panel)), 4)
    
    Widgets(Hex(301)) = SpinWidget(0, 0, 100,20,0,10, #__spin_plus)
    Widgets(Hex(302)) = SpinWidget(0, 0, 100,20,0,10)                 
    Widgets(Hex(#PB_GadgetType_Splitter)) = SplitterWidget(665, 405, 160,95,Widgets(Hex(301)), Widgets(Hex(302)))
    
    Widgets(Hex(#PB_GadgetType_MDI)) = MDIWidget(665, 505, 160,95); ,#__flag_AutoSize)
    Define *g = AddItem(Widgets(Hex(#PB_GadgetType_MDI)), -1, "form_0")
    ResizeWidget(*g, 7, 40, 120, 60)
    
;     CloseWidgetList()
; ;     OpenWidgetList(Root())
;      ButtonWidget(10,5,50,35, "butt_1") 
    
    ;     CompilerEndIf
    ;     InitScintilla()
    ;     ScintillaGadget(#PB_GadgetType_Scintilla, 830, 5, 160,95,0 )
    ;     ShortcutGadget(#PB_GadgetType_Shortcut, 830, 105, 160,95 ,-1)
    ;     CanvasGadget(#PB_GadgetType_Canvas, 830, 205, 160,95 )
    
    CloseWidgetList()
    
    BindWidgetEvent(Widgets(Hex(#PB_GadgetType_ScrollBar)), @scrolled() )
    
    
    Disable(Widgets(Hex(#PB_GadgetType_Button)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_ButtonImage)), 1)
    ;Disable(Widgets(Hex(#PB_GadgetType_Calendar)), 1)
    ;Disable(Widgets(Hex(#PB_GadgetType_Canvas)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_CheckBox)), 1)
    ;Disable(Widgets(Hex(#PB_GadgetType_ComboBox)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_Container)), 1)
    ;Disable(Widgets(Hex(#PB_GadgetType_Date)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_Editor)), 1)
    ;Disable(Widgets(Hex(#PB_GadgetType_ExplorerCombo)), 1)
    ;Disable(Widgets(Hex(#PB_GadgetType_ExplorerList)), 1)
    ;Disable(Widgets(Hex(#PB_GadgetType_ExplorerTree)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_Frame)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_HyperLink)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_Image)), 1)
    ;Disable(Widgets(Hex(#PB_GadgetType_IPAddress)), 1)
    ;Disable(Widgets(Hex(#PB_GadgetType_ListIcon)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_ListView)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_MDI)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_Option)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_Panel)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_ProgressBar)), 1)
    ;Disable(Widgets(Hex(#PB_GadgetType_Scintilla)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_ScrollBar)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_ScrollArea)), 1)
    ;Disable(Widgets(Hex(#PB_GadgetType_Shortcut)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_Spin)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_Splitter)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_String)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_Text)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_TrackBar)), 1)
    Disable(Widgets(Hex(#PB_GadgetType_Tree)), 1)
    ;Disable(Widgets(Hex(#PB_GadgetType_Web)), 1)
    
    WaitCloseRoot( )
;     Repeat
;       Define  Event = WaitWindowEvent()
;     Until Event= #PB_Event_CloseWindow
    
  EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 45
; FirstLine = 32
; Folding = -
; EnableXP