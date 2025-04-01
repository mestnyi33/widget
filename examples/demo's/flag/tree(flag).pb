IncludePath "../../../"
XIncludeFile "widgets.pbi"


; CompilerSelect #PB_Compiler_OS
; 			CompilerCase #PB_OS_Windows
; 				Select GadgetType(GadgetID)
; 					Case #PB_GadgetType_ListView
; 						SendMessage_(GadgetID(GadgetID), #LB_SETTOPINDEX, CountGadgetItems(GadgetID) - 1, #Null)
; 					Case #PB_GadgetType_ListIcon
; 						SendMessage_(GadgetID(GadgetID), #LVM_ENSUREVISIBLE, CountGadgetItems(GadgetID) - 1, #False)
; 					Case #PB_GadgetType_Editor
; 						SendMessage_(GadgetID(GadgetID), #EM_SCROLLCARET, #SB_BOTTOM, 0)
; 				EndSelect
; 			CompilerCase #PB_OS_Linux
; 				Protected *Adjustment.GtkAdjustment
; 				*Adjustment = gtk_scrolled_window_get_vadjustment_(gtk_widget_get_parent_(GadgetID(Gadget)))
; 				*Adjustment\value = *Adjustment\upper
; 				gtk_adjustment_value_changed_(*Adjustment)
; 		CompilerEndSelect 
		
		
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  Define cr.s = #LF$, Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *this._s_widget, gadget, Button_type, nolines, nobuttons, checkboxes, optionboxes, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  Global threestate, Button_5, Button_6, gridlines, Button_8, Button_9
  Define vert=100, horiz=100, Width=450, Height=400
  
  Procedure events_widgets()
    Protected flag, EventWidget = EventWidget( )
    
    Select WidgetEvent( )
      Case #__event_Change
        Debug  "change"
        
        Select EventWidget
          Case Button_type 
            
          Case nolines : flag = #__tree_nolines
          Case nobuttons : flag = #__tree_nobuttons
          Case checkboxes : flag = #__tree_checkboxes
          Case optionboxes : flag = #__flag_optionboxes
          Case threestate : flag = #__tree_threestate
          ;Case Button_5 : flag = #__flag_collapsedd
          ;Case Button_6 : flag = #__tree_expanded
          Case gridlines : flag = #__flag_gridlines
        EndSelect
        
        If flag
           Flag(*this, flag, GetState(EventWidget)!Bool(EventWidget=nobuttons Or EventWidget=nolines ))
        EndIf
        
;         If EventWidget = optionboxes
;            If GetState( EventWidget )
;               SetState( checkboxes, 1 ) 
;            EndIf
;         EndIf
               
  EndSelect
    
  EndProcedure
  
  If Open(0, 0, 0, Width+180, Height+55, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    gadget = ButtonGadget(#PB_Any, 100, 100, 250, 200, Text, #PB_Button_MultiLine) 
    HideGadget(gadget,1)
    
    Define img = 0
    widget::Container(10,10,Width, Height)
    *this = widget::Tree(100, 100, 250, 200, #PB_Tree_NoLines | #PB_Tree_NoButtons|#__flag_checkBoxes|#__flag_optionBoxes | #__flag_GridLines)
    CloseList()
    ;Debug *this\mode\check
    ;*this\mode\checkBoxes = 1
    ;\\
    ; optionbox
    ;   checkbox and child
    widget::AddItem (*this, -1, "SizeGadget",     -1, 0)                                    
    
    widget::AddItem (*this, -1, "Tool",           -1, 1)                                    
    widget::AddItem (*this, -1, "TitleBar",       -1, 1)                                    
    widget::AddItem (*this, -1, "BorderLess",     -1, 1)                                    
    widget::AddItem (*this, -1, "SistemMenu",     -1, 1)                                    
    
    widget::AddItem (*this, -1, "MaximizeGadget", -1, 0)                                    
    widget::AddItem (*this, -1, "MinimizeGadget", -1, 0)                                    
    widget::AddItem (*this, -1, "CloseGadget",    -1, 0)                                    
    
    ; optionbox
    widget::AddItem (*this, -1, "Normal",         -1,1)                                    
    widget::AddItem (*this, -1, "Maximize",       -1,1)                                    
    widget::AddItem (*this, -1, "Minimize",       -1,1)                                    
    widget::AddItem (*this, -1, "Invizible",      -1,1)                                    
    
    ; checkbox
    widget::AddItem (*this, -1, "NoGadgets",       -1, 0)                                    
    widget::AddItem (*this, -1, "NoActive",       -1, 0)                                    
    
    ; optionbox
    widget::AddItem (*this, -1, "WindowCenter",   -1,1)                                    
    widget::AddItem (*this, -1, "ScreenCenter",   -1,1)                                    
   ; *this\mode\checkboxes = 0
    
    ;\\
    Define Y = 10
    
    ;\\ flag
    Button_type = widget::Button(Width+45,   Y, 100, 26, "gadget", #PB_Button_Toggle) 
    nolines = widget::Button(Width+45, Y+30*1, 100, 26, "nolines", #PB_Button_Toggle) 
    nobuttons = widget::Button(Width+45, Y+30*2, 100, 26, "nobuttons", #PB_Button_Toggle) 
    checkboxes = widget::Button(Width+45, Y+30*3, 100, 26, "checkboxes", #PB_Button_Toggle) 
    optionboxes = widget::Button(Width+45, Y+30*4, 100, 26, "optionboxes", #PB_Button_Toggle) 
    threestate = widget::Button(Width+45, Y+30*5, 100, 26, "threestate", #PB_Button_Toggle) 
    ;Button_5 = widget::Button(width+45, y+30*6, 100, 26, "collapsed", #PB_Button_Toggle) 
    ;Button_6 = widget::Button(width+45, y+30*7, 100, 26, "expanded", #PB_Button_Toggle) 
    gridlines = widget::Button(Width+45, Y+30*8, 100, 26, "gridlines", #PB_Button_Toggle) 
    
    ;\\ set button toggled state
    widget::SetState(nolines, Flag(*this, #__tree_nolines))
    widget::SetState(nobuttons, Flag(*this, #__tree_nobuttons))
    widget::SetState(checkboxes, Flag(*this, #__tree_checkboxes))
    widget::SetState(optionboxes, Flag(*this, #__flag_optionboxes))
    widget::SetState(threestate, Flag(*this, #__tree_threestate))
    ;widget::SetState(Button_5, Flag(*this, #__flag_collapsedd))
    ;widget::SetState(Button_6, Flag(*this, #__tree_expanded))
    widget::SetState(gridlines, Flag(*this, #__flag_GridLines))
    
    If Button_type
       widget::Hide(Button_type, 1)
    EndIf

    widget::Button(10, Height+20, 60, 24,"remove")
    widget::Button(75, Height+20, 100, 24,"add")
    widget::Button(180, Height+20, 30, 24,"1")
    widget::Button(180+30+4, Height+20, 30, 24,"2")
    widget::Button(180+60+8, Height+20, 30, 24,"3")
    widget::Button(285, Height+20, 60, 24,"clear")
    
    Splitter_0 = widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
    Splitter_1 = widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed|#PB_Splitter_Vertical)
    Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
    Splitter_3 = widget::Splitter(10, 10, Width, Height, Splitter_2, #Null, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
    
    Define pos = 30
    widget::SetState(Splitter_0, pos)
    widget::SetState(Splitter_1, pos)
    widget::SetState(Splitter_3, Width-pos-#__bar_splitter_size)
    widget::SetState(Splitter_2, Height-pos-#__bar_splitter_size)
    
    widget::Bind(root( ), @events_widgets())
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 134
; FirstLine = 122
; Folding = --
; EnableXP
; DPIAware