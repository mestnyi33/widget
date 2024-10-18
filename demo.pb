XIncludeFile "widgets.pbi"
;https://github.com/Hoeppner1867?tab=followers
;https://forum.ru-board.com/topic.cgi?forum=33&topic=6087&start=20#6
;https://python-gtk-3-tutorial.readthedocs.io/en/latest/combobox.html

;- EXAMPLE
EnableExplicit
UseLib(widget)

test_draw_contex = 0

Global i, *test._s_widget

Procedure events( )
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
Global x,y,i,NewMap id.i(), round = 0

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
   SetState( id(Hex(#PB_GadgetType_ProgressBar)), GetState( id(Hex(#PB_GadgetType_ScrollBar))))
EndProcedure

If Open(0, 0, 0, 995, 605, "demo then draw id on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   Bind(#PB_All, @events( ))
   
   ;a_init(root( ), 0)
   ;
   ;id("Container") = Container(0, 0, 0, 0, #__flag_AutoSize) 
   ;\\ 1
   id(Hex(#PB_GadgetType_Button)) = Button(5, 5, 160,95, "Multiline Button_"+Hex(#PB_GadgetType_Button)+" (longer text gets automatically multiline)", #__button_multiLine, - 1, round ) 
   id(Hex(#PB_GadgetType_String)) = String(5, 105, 160,95, "String_"+Hex(#PB_GadgetType_String)+" set"+#LF$+"multi"+#LF$+"line"+#LF$+"text")                                 
   id(Hex(#PB_GadgetType_Text)) = Text(5, 205, 160,95, "Text_"+Hex(#PB_GadgetType_Text)+#LF$+"set"+#LF$+"multi"+#LF$+"line"+#LF$+"text", #PB_Text_Border)        
   id(Hex(#PB_GadgetType_CheckBox)) = CheckBox(5, 305, 160,95, "CheckBox_"+Hex(#PB_GadgetType_CheckBox), #PB_CheckBox_ThreeState) : SetState(id(), #PB_Checkbox_Inbetween)
   id(Hex(#PB_GadgetType_Option)) = Option(5, 405, 160,95, "Option_"+Hex(#PB_GadgetType_Option) ) : SetState(id(), 1)                                                       
   id(Hex(#PB_GadgetType_ListView)) = ListView(5, 505, 160,95) : AddItem(id(), -1, "ListView_"+Hex(#PB_GadgetType_ListView)) : For i=1 To 5 : AddItem(id(), i, "item_"+Hex(i)) : Next
   
   ;\\ 2
   id(Hex(#PB_GadgetType_Frame)) = Frame(170, 5, 160,95, "Frame_"+Hex(#PB_GadgetType_Frame) )
   id(Hex(#PB_GadgetType_ComboBox)) = ComboBox(170, 105, 160,45 ) : AddItem(id(), -1, "ComboBox_"+Hex(#PB_GadgetType_ComboBox)) : For i=1 To 5 : AddItem(id(), i, "item_"+Hex(i)) : Next : SetState(id(), 0) 
   id(Hex(100+#PB_GadgetType_ComboBox)) = ComboBox(170, 155, 160,45, #PB_ComboBox_Editable) : AddItem(id(), -1, "ComboBox_"+Hex(100+#PB_GadgetType_ComboBox)) : For i=1 To 5 : AddItem(id(), i, "item_"+Hex(i)) : Next : SetState(id(), 0) 
   id(Hex(#PB_GadgetType_Image)) = Image(170, 205, 160,95, img2, #PB_Image_Border ) 
   id(Hex(#PB_GadgetType_HyperLink)) = HyperLink(170, 305, 160,95,"HyperLink_"+Hex(#PB_GadgetType_HyperLink), $00FF00, #PB_HyperLink_Underline ) 
   id(Hex(#PB_GadgetType_Container)) = Container(170, 405, 160,95, #PB_Container_Flat )
   id(Hex(101)) = Option(10, 10, 110,20, "Container_"+Hex(#PB_GadgetType_Container) )  : SetState(id(), 1)  
   id(Hex(102)) = Option(10, 40, 110,20, "Option_widget");, #__flag_flat)  
   CloseList()
   id(Hex(#PB_GadgetType_ListIcon)) = ListIcon(170, 505, 160,95,"ListIcon_"+Hex(#PB_GadgetType_ListIcon),120 )                           
   
   ;\\ 3
   id(Hex(#PB_GadgetType_IPAddress)) = IPAddress(335, 5, 160,95 ) : SetState(id(), MakeIPAddress(1, 2, 3, 4))    
   id(Hex(#PB_GadgetType_ProgressBar)) = Progress(335, 105, 160,95,0,100, 0, round) : SetState(id(), 50)
   id(Hex(#PB_GadgetType_ScrollBar)) = Scroll(335, 205, 160,95,0,120,20) : SetState(id(), 50)
   id(Hex(#PB_GadgetType_ScrollArea)) = ScrollArea(335, 305, 160,95,180,90,1, #PB_ScrollArea_Flat ) : id(Hex(201)) = Button(0, 0, 150,20, "ScrollArea_"+Hex(#PB_GadgetType_ScrollArea) ) : id(Hex(202)) = Button(180-150, 90-20, 150,20, "Button_"+Hex(202) ) : CloseList()
   id(Hex(#PB_GadgetType_TrackBar)) = Track(335, 405, 160,95,0,21, #PB_TrackBar_Ticks ) : SetState(id(), 11)
   ;     WebGadget(#PB_GadgetType_Web, 335, 505, 160,95,"" )
   
   ;\\ 4
   id(Hex(#PB_GadgetType_ButtonImage)) = ButtonImage(500, 5, 160,95, img1)
   ;     CalendarGadget(#PB_GadgetType_Calendar, 500, 105, 160,95 )
   ;     DateGadget(#PB_GadgetType_Date, 500, 205, 160,95 )
   id(Hex(#PB_GadgetType_Editor)) = Editor(500, 305, 160,95 ) : AddItem(id(), -1, "editor_"+Hex(#PB_GadgetType_Editor) +#LF$+"add"+#LF$+"multi"+#LF$+"line"+#LF$+"text")  
   ;     id(Hex(#PB_GadgetType_ExplorerList)) = ExplorerList(500, 405, 160,95,"" )
   ;     ExplorerTreeGadget(#PB_GadgetType_ExplorerTree, 500, 505, 160,95,"" )
   
   ;\\ 5   
   ;     ExplorerComboGadget(#PB_GadgetType_ExplorerCombo, 665, 5, 160,95,"" )
   id(Hex(#PB_GadgetType_Spin)) = Spin(665, 105, 160,95,20,100)
   id(Hex(#PB_GadgetType_Tree)) = Tree( 665, 205, 160, 95 ) 
   AddItem(id(), -1, "Tree_"+Hex(#PB_GadgetType_Tree)) 
   For i=1 To 5 : AddItem(id(), i, "item_"+Hex(i)) : Next
   id(Hex(#PB_GadgetType_Panel)) = Panel(665, 305, 160,95) 
   AddItem(id(Hex(#PB_GadgetType_Panel)), -1, "Panel_"+Hex(#PB_GadgetType_Panel)) 
   id(Hex(255)) = Button(0, 0, 90,20, "Button_255" ) 
   For i=1 To 5 : AddItem(id(Hex(#PB_GadgetType_Panel)), i, "item_"+Hex(i)) : Button(10,5,50,35, "butt_"+Str(i)) : Next 
   CloseList()
   OpenList(id(Hex(#PB_GadgetType_Panel)), 1)
   Container(10,5,150,55, #PB_Container_Flat) 
   Container(10,5,150,55, #PB_Container_Flat) 
   Button(10,5,50,35, "butt_1") 
   CloseList()
   CloseList()
   CloseList()
   SetState( id(Hex(#PB_GadgetType_Panel)), 4)
   id(Hex(301)) = Spin(0, 0, 100,20,0,10, #__spin_plus)
   id(Hex(302)) = Spin(0, 0, 100,20,0,10) ; Button(0, 0, 100,20,"splitt-button")                 
   id(Hex(#PB_GadgetType_Splitter)) = Splitter(665, 405, 160,95,id(Hex(301)), id(Hex(302)))
   id(Hex(#PB_GadgetType_MDI)) = MDI(665, 505, 160,95)
   Resize(AddItem(id(Hex(#PB_GadgetType_MDI)), -1, "form_0"), 7, 40, 120, 60)
   
   ;\\ 6
   ;     InitScintilla()
   ;     ScintillaGadget(#PB_GadgetType_Scintilla, 830, 5, 160,95,0 )
   ;     ShortcutGadget(#PB_GadgetType_Shortcut, 830, 105, 160,95 ,-1)
   ;     CanvasGadget(#PB_GadgetType_Canvas, 830, 205, 160,95 )
   
   CloseList()
   
   ;\\
   Bind(id(Hex(#PB_GadgetType_ScrollBar)), @scrolled(), #__event_change )
EndIf   

CompilerIf #PB_Compiler_IsMainFile
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 39
; FirstLine = 36
; Folding = ---
; EnableXP
; DPIAware