XIncludeFile "widgets.pbi"
;https://github.com/Hoeppner1867?tab=followers
;https://forum.ru-board.com/topic.cgi?forum=33&topic=6087&start=20#6
;https://python-gtk-3-tutorial.readthedocs.io/en/latest/combobox.html

;- EXAMPLE
EnableExplicit
UseWidgets( )


;test_focus_set = 1
test_focus_draw = 1
   
Global i, *test._s_widget

Procedure all_events( )
   Protected event = WidgetEvent( )
   Protected *this._s_widget = EventWidget( )
   
   ;\\
   If event = #__event_MouseEnter
      If *this\parent
         Debug " -enter- "+*this\class +" ("+ *this\enter +") ("+ *this\parent\enter +") " + WidgetEventData( )
      EndIf
   EndIf
   
   ;\\
   If event = #__event_MouseLeave
      If *this\parent
         Debug " -leave- "+*this\class +" ("+ *this\enter +") ("+ *this\parent\enter +") " + WidgetEventData( )
      EndIf
   EndIf
EndProcedure

UsePNGImageDecoder()

Global img1 = 1
Global img2 = 2
Global X,Y,i, round = 0
Global w_1,w_2,w_3,w_4,w_5,w_6,w_7,w_8,w_9,w_10,w_11,w_12,w_13,w_14,w_15,
       w_16,w_17,w_18,w_19,w_20,w_21,w_22,w_23,w_24,w_25,w_26,w_27,w_28,w_29,w_30,
       w_101,w_102,w_201,w_202,w_255,w_301,w_302

CompilerIf #PB_Compiler_DPIAware
  Procedure LoadImage__( _image_, _filename_.s, _flags_=-1 )
    Protected result = PB(LoadImage)( _image_, _filename_, _flags_ )
    ResizeImage(_image_, DPIScaled(ImageWidth(_image_)), DPIScaled(ImageHeight(_image_)))
    ProcedureReturn result
  EndProcedure
  Macro LoadImage( _image_, _filename_, _flags_=-1 )
    LoadImage__( _image_, _filename_, _flags_ )
  EndMacro
CompilerEndIf

If Not LoadImage(img2, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
   End
EndIf
 
If Not LoadImage(img1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
   End
EndIf

Procedure scrolled( )
   SetState( w_15, GetState( w_16))
EndProcedure

If Open(0, 0, 0, 995, 605, "demo then draw id on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   SetBackColor( Root(), $99EBFF)
   Bind(#PB_All, @all_events( ))
   
   ;a_init(root( ), 0)
   ;
   ;id("Container") = Container(0, 0, 0, 0, #__flag_AutoSize) 
   ;\\ 1
   w_1 = Button(5, 5, 160,95, "Multiline Button_"+Hex(#__type_Button)+" (longer text gets automatically multiline)", #__flag_TextWordWrap, round ) 
   w_2 = String(5, 105, 160,95, "String_"+Hex(#__type_String)+" set"+#LF$+"multi"+#LF$+"line"+#LF$+"text")                                 
   w_3 = Text(5, 205, 160,95, "Text_"+Hex(#__type_Text)+#LF$+"set"+#LF$+"multi"+#LF$+"line"+#LF$+"text", #PB_Text_Border)        
   w_4 = CheckBox(5, 305, 160,95, "CheckBox_"+Hex(#__type_CheckBox), #PB_CheckBox_ThreeState) : SetState(Widget(), #PB_Checkbox_Inbetween)
   w_5 = Option(5, 405, 160,95, "Option_"+Hex(#__type_Option) ) : SetState(Widget(), 1)                                                       
   w_6 = ListView(5, 505, 160,95) : AddItem(Widget(), -1, "ListView_"+Hex(#__type_ListView)) : For i=1 To 5 : AddItem(Widget(), i, "item_"+Hex(i)) : Next
   
   ;\\ 2
   w_7 = Frame(170, 5, 160,95, "Frame_"+Hex(#__type_Frame) )
   w_8 = ComboBox(170, 105, 160,45 ) : AddItem(Widget(), -1, "ComboBox_"+Hex(#__type_ComboBox)) : For i=1 To 5 : AddItem(Widget(), i, "item_"+Hex(i)) : Next : SetState(Widget(), 0) 
   w_9 = ComboBox(170, 155, 160,45, #PB_ComboBox_Editable) : AddItem(Widget(), -1, "ComboBox_"+Hex(100+#__type_ComboBox)) : For i=1 To 5 : AddItem(Widget(), i, "item_"+Hex(i)) : Next : SetState(Widget(), 0) 
   w_10 = Image(170, 205, 160,95, img2, #PB_Image_Border ) 
   w_11 = HyperLink(170, 305, 160,95,"HyperLink_"+Hex(#__type_HyperLink), $00FF00, #PB_HyperLink_Underline ) 
   w_12 = Container(170, 405, 160,95, #PB_Container_Flat )
   w_101 = Option(10, 10, 110,20, "Container_"+Hex(#__type_Container) )  : SetState(Widget(), 1)  
   w_102 = Option(10, 40, 110,20, "Option_widget");, #__flag_flat)  
   CloseList()
   w_13 = ListIcon(170, 505, 160,95,"ListIcon_"+Hex(#__type_ListIcon),120 )                           
   
   ;\\ 3
   w_14 = IPAddress(335, 5, 160,95 ) : SetState(Widget(), MakeIPAddress(1, 2, 3, 4))    
   w_15 = Progress(335, 105, 160,95,0,100, 0, round) : SetState(Widget(), 50)
   w_16 = Scroll(335, 205, 160,95,0,120,20) : SetState(Widget(), 50)
   w_17 = ScrollArea(335, 305, 160,95,180,90,1, #PB_ScrollArea_Flat ) : Button(0, 0, 150,20, "ScrollArea_"+Hex(#__type_ScrollArea) ) : Button(180-150, 90-20, 150,20, "Button_"+Hex(202) ) : CloseList()
   w_18 = Track(335, 405, 160,95,0,21, #PB_TrackBar_Ticks ) : SetState(Widget(), 11)
   ;     WebGadget(#__type_Web, 335, 505, 160,95,"" )
   
   ;\\ 4
   w_19 = ButtonImage(500, 5, 160,95, img1)
   ;     CalendarGadget(#__type_Calendar, 500, 105, 160,95 )
   ;     DateGadget(#__type_Date, 500, 205, 160,95 )
   w_22 = Editor(500, 305, 160,95 ) : AddItem(Widget(), -1, "editor_"+Hex(#__type_Editor) +#LF$+"add"+#LF$+"multi"+#LF$+"line"+#LF$+"text")  
   ;     id(Hex(#__type_ExplorerList)) = ExplorerList(500, 405, 160,95,"" )
   ;     ExplorerTreeGadget(#__type_ExplorerTree, 500, 505, 160,95,"" )
   
   ;\\ 5   
   ;     ExplorerComboGadget(#__type_ExplorerCombo, 665, 5, 160,95,"" )
   w_26 = Spin(665, 105, 160,95,20,100)
   w_27 = Tree( 665, 205, 160, 95 ) 
   AddItem(Widget(), -1, "Tree_"+Hex(#__type_Tree)) 
   For i=1 To 5 : AddItem(Widget(), i, "item_"+Hex(i)) : Next
   w_28 = Panel(665, 305, 160,95) 
   AddItem(w_28, -1, "Panel_"+Hex(#__type_Panel)) 
   w_255 = Button(0, 0, 90,20, "Button_255" ) 
   For i=1 To 5 : AddItem(w_28, i, "item_"+Hex(i)) : Button(10,5,50,35, "butt_"+Str(i)) : Next 
   CloseList()
   OpenList(w_28, 1)
   Container(10,5,150,55, #PB_Container_Flat) 
   Container(10,5,150,55, #PB_Container_Flat) 
   Button(10,5,50,35, "butt_1") 
   CloseList()
   CloseList()
   CloseList()
   SetState( w_28, 4)
   w_301 = Spin(0, 0, 100,20,0,10, #__spin_plus)
   w_302 = Spin(0, 0, 100,20,0,10) ; Button(0, 0, 100,20,"splitt-button")                 
   w_29 = Splitter(665, 405, 160,95,w_301, w_302)
   w_30 = MDI(665, 505, 160,95)
   Resize(AddItem(Widget(), -1, "form_0"), 7, 40, 120, 60)
   
   ;\\ 6
   ;     InitScintilla()
   ;     ScintillaGadget(#__type_Scintilla, 830, 5, 160,95,0 )
   ;     ShortcutGadget(#__type_Shortcut, 830, 105, 160,95 ,-1)
   ;     CanvasGadget(#__type_Canvas, 830, 205, 160,95 )
   
   CloseList()
   
   ;\\
   Bind(w_16, @scrolled(), #__event_change )
EndIf   

CompilerIf #PB_Compiler_IsMainFile
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 74
; FirstLine = 57
; Folding = ---
; EnableXP
; DPIAware