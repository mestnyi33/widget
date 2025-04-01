IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global *this._s_widget, i, w_type, w_flag
   Define vert=100, horiz=100, Width=400, Height=400
   Define cr.s = #LF$, Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
   
   Procedure Add(Text.s)
      ClearItems(w_flag)
      If Text
         Protected i, sublevel, String.s, count = CountString(Text,"|")
         
         
         For I = 0 To count
            String = Trim(StringField(Text,(I+1),"|"))
            
            Select LCase(Trim(StringField(String,(3),"_")))
               Case "left" : sublevel = 1
               Case "right" : sublevel = 1
               Case "center" : sublevel = 1
               Default
                  sublevel = 0
            EndSelect
            
            AddItem(w_flag, -1, String, -1, sublevel)
            
         Next
      EndIf 
   EndProcedure
   
   Procedure Set(Gadget, Object)
      Protected i, state, flag.q
      i = GetState(Gadget)
      flag = MakeConstants( GetItemText( Gadget, i ))
      state = Bool( GetItemState( Gadget, i) & #PB_Tree_Checked )
      
      Flag(Object, flag, state )
   EndProcedure
   
   Procedure$ GetCheckedText(Gadget)
      Protected i, Result$, CountItems = CountItems(Gadget)
      
      For i = 0 To CountItems - 1
         If GetItemState(Gadget, i) & #PB_Tree_Checked  
            Result$ + GetItemText(Gadget, i)+"|"
         EndIf
      Next
      
      ProcedureReturn Trim(Result$, "|")
   EndProcedure
   
   Procedure SetCheckedText(Gadget, Text$)
      Protected i,ii
      Protected CountItems = CountItems(Gadget)
      Protected CountString = CountString(Text$, "|")
      
      For i = 0 To CountString
         For ii = 0 To CountItems - 1
            If GetItemText(Gadget, ii) = Trim( StringField( Text$, (i + (1)), "|"))
               SetItemState(Gadget, ii, #PB_Tree_Checked) 
            EndIf
         Next
      Next
      
   EndProcedure
   
   
   Procedure events_widgets()
      Protected flag, Type, flag$
      
      Select WidgetEvent( )
         Case #__event_Change
            Select EventWidget( )
               Case w_type 
                  flag = Flag(*this)
                  Type = Type(*this)
                  
                  Add( MakeFlagsString( GetState(w_type)))
                  
                  flag$ = MakeConstantsString( ClassFromType(Type), flag)
                  Debug "flag["+Flag$+"]"
                  SetCheckedText(w_flag, flag$ )
                  
               Case w_flag
                  Debug "checked["+GetCheckedText(w_flag)+"]"
            EndSelect
            
         Case #__event_LeftClick
            Select EventWidget( )
               Case w_flag
                  Set(w_flag, *this)
                  
            EndSelect
            
            If flag
               Flag(*this, flag, GetState(EventWidget( )))
            EndIf
      EndSelect
      
   EndProcedure
   
   If Open(0, 0, 0, Width+205, Height+30, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      *this = widget::Button(100, 100, 250, 200, Text, #PB_Button_Toggle|#__flag_text_multiline) 
      
      
      w_type = widget::ListView(Width+45, 10, 150, 200) 
      For i=0 To 33
         AddItem(w_type, -1, ClassFromType(i))
      Next
      SetState(w_type, 1)
      
      w_flag = widget::Tree(Width+45, 220, 150, 200, #__tree_CheckBoxes|#__flag_optionboxes|#__tree_nobuttons|#__tree_nolines) 
      
      
      Bind(#PB_All, @events_widgets())
      
      
      ; WaitClose( )
      Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 10
; Folding = ---
; EnableXP
; DPIAware