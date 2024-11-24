XIncludeFile "../../../widgets.pbi"
UseWidgets( )

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   ;- 
   Enumeration 
      #_pi_group_0 
      #_pi_id
      #_pi_class
      #_pi_text
      
      #_pi_group_1 
      #_pi_x
      #_pi_y
      #_pi_width
      #_pi_height
      
      #_pi_group_2 
      #_pi_disable
      #_pi_hide
   EndEnumeration
   
   
   Macro GetItem( _address_ )
      _address_\RowEntered( )  
   EndMacro
   
   Define cr.s = #LF$, Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
   Global *w, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
   
   Procedure PropertiesEvents( )
      Protected *splitter._s_WIDGET = EventWidget( )\parent
      Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      
      Select WidgetEvent( )
         Case #__event_Focus
            
         Case #__event_LostFocus
         Case #__event_Down
            ; Debug 99
         Case #__event_Change
            Protected *this._s_WIDGET
            *this = GetItemData(*second, WidgetEventItem( ))
            Debug 333
            If *this And *second\RowEntered( )
               SelectElement(*second\__rows( ), *second\RowEntered( )\index)
               *this\noscale = 1
               ;Resize(*this, *second\x+*second\__rows( )\x, *second\y+*second\__rows( )\y, *second\__rows( )\width, *second\__rows( )\height )
               Resize(*this, *second\__rows( )\x, *second\__rows( )\y, *second\__rows( )\width, *second\__rows( )\height )
            EndIf
               
         Case #__event_ScrollChange
            Select EventWidget( )
               Case *first 
                  If GetState( *second\scroll\v ) <> GetState( EventWidget( )\scroll\v )
                     SetState(*second\scroll\v, GetState( EventWidget( )\scroll\v ) )
                  EndIf
               Case *second
                  If GetState( *first\scroll\v ) <> GetState( EventWidget( )\scroll\v )
                     SetState(*first\scroll\v, GetState( EventWidget( )\scroll\v ) )
                  EndIf
            EndSelect
            
         Case #__event_StatusChange
            Select EventWidget( )
               Case *first
                  If *first\RowLeaved( )
                     SelectElement(*second\__rows( ), *first\RowLeaved( )\index)
                     *second\__rows( )\color = *first\RowLeaved( )\color
                  EndIf
                  If *first\RowEntered( )
                     SelectElement(*second\__rows( ), *first\RowEntered( )\index)
                     *second\__rows( )\color = *first\RowEntered( )\color
                     
                     ;\\
                     If *second\__rows( )\RowButtonState( ) <> *first\RowEntered( )\RowButtonState( )
                        If *first\RowEntered( )\RowButtonState( )
                           SetItemState( *second, *first\RowEntered( )\index, #PB_Tree_Collapsed )
                        Else
                           SetItemState( *second, *first\RowEntered( )\index, #PB_Tree_Expanded )
                        EndIf
                        
                        ReDraw( *second )
                        ;Repaint( *second\root )
                        ;Resize( *second, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
                     EndIf
                     
                     ; CopyStructure( *first\__rows( )\color, *second\__rows( )\color, _s_COLOR )
                     ;SetItemState(*second, GetItem( *first ) , GetItemState(*first, GetItem( *first )  ) )
                  EndIf
                  
               Case *second
                  If *second\RowLeaved( )
                     SelectElement(*first\__rows( ), *second\RowLeaved( )\index)
                     *first\__rows( )\color = *second\RowLeaved( )\color
                  EndIf
                  If *second\RowEntered( )
                     SelectElement(*first\__rows( ), *second\RowEntered( )\index)
                     *first\__rows( )\color = *second\RowEntered( )\color
                  EndIf
            EndSelect
      EndSelect
   EndProcedure
   
   Procedure AddItemProperties( *splitter._s_WIDGET, item, Text.s, Type=0, mode=0 )
      Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      
      AddItem( *first, item, StringField(Text.s, 1, Chr(10)), -1, mode )
      AddItem( *second, item, StringField(Text.s, 2, Chr(10)), -1, mode )
      
      Protected *this._s_WIDGET
      
      item = CountItems( *first ) - 1
      Protected flag ;= #__flag_child
      
      Select Type
         Case #__type_Spin
           ; *this = Spin(0,0,0,0,0,100)
            *this = Create( *second, #PB_Compiler_Procedure, #__type_Spin, 0, 0, 0, 0, #Null$, flag, 0, 1000, 0, #__buttonsize, 0, 1 )
            SetState( *this, Val(StringField(Text.s, 2, Chr(10))))
      Case #__type_String
           ; *this = String(0,0,0,0,"")
            *this = Create( *second, #PB_Compiler_Procedure, #__type_String, 0, 0, 0, 0, StringField(Text.s, 2, Chr(10)), flag, 0, 0, 0, 0, 0, 0 )
      Case #__type_ComboBox
           ; *this = ComboBox(0,0,0,0)
         *this = Create( *second, #PB_Compiler_Procedure, #__type_ComboBox, 0, 0, 0, 0, "", flag, 0, 0, 0, 0, 0, 0 )
         AddItem(*this, -1, "True")
         AddItem(*this, -1, "False")
         SetState(*this, 1)
   EndSelect
      
     ; SetItemData(*first, item, *this)
      SetItemData(*second, item, *this)
   EndProcedure
   
   Procedure CreateProperties( X,Y,Width,Height, flag=0 )
      Protected position = 70
      Protected *first._s_WIDGET = Tree(0,0,0,0)
      Protected *second._s_WIDGET = Tree(0,0,0,0, #PB_Tree_NoButtons|#PB_Tree_NoLines)
      
      Protected *splitter._s_WIDGET = Splitter(X,Y,Width,Height, *first,*second, flag|#PB_Splitter_Vertical |#PB_Splitter_FirstFixed )
      SetAttribute(*splitter, #PB_Splitter_SecondMinimumSize, position )
      SetState(*splitter, Width-position )
      
      *splitter\bar\button\size = DPIScaled(5)
      *splitter\bar\button\round = DPIScaled(1)
      
      SetClass(*first\scroll\v, "first_v")
      SetClass(*first\scroll\h, "first_h")
      
      SetClass(*second\scroll\v, "second_v")
      SetClass(*second\scroll\h, "second_h")
      
      Hide( *first\scroll\v, 1 )
      Hide( *first\scroll\h, 1 )
      ;Hide( *second\scroll\v, 1 )
      Hide( *second\scroll\h, 1 )
      CloseList( )
      
      SetData(*second, *first)
      SetData(*first, *second)
      
      Bind(*first, @PropertiesEvents( ))
      Bind(*second, @PropertiesEvents( ))
      ProcedureReturn *splitter
   EndProcedure
   
   Procedure.s GetItemTextProperties( *splitter._s_WIDGET, item )
      Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      ProcedureReturn GetItemText( *first, item )
   EndProcedure
   
   Procedure SetItemTextProperties( *splitter._s_WIDGET, item, Text.s )
      Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      
      SetItemText( *first, item, StringField(Text.s, 1, Chr(10)) )
      SetItemText( *second, item, StringField(Text.s, 2, Chr(10)) )
   EndProcedure
   
   
   If Open(0, 0, 0, 605+30, 140+200+140+140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ;Define *panel = Panel(10, 10, 250, 200)
      Define *Tree = CreateProperties(10, 10, 250, 200);, #__flag_autosize);, #__flag_gridlines);|#__tree_nolines);, #__flag_autosize) 
      Define Value = *Tree
      AddItemProperties(*Tree, #_pi_group_0, "common")
      AddItemProperties(*Tree, #_pi_id, "id:"+Chr(10)+Str(Value),                                    #__type_String, 1)
      AddItemProperties(*Tree, #_pi_class, "class:"+Chr(10)+GetClass(Value)+"_"+CountType(Value), #__type_String, 1)
      AddItemProperties(*Tree, #_pi_text, "text:"+Chr(10)+GetText(Value),                            #__type_String, 1)
      
      AddItemProperties(*Tree, #_pi_group_1, "layout")
      AddItemProperties(*Tree, #_pi_x, "x:"+Chr(10)+Str(X(Value)),                             #__type_Spin, 1)
      AddItemProperties(*Tree, #_pi_y, "y:"+Chr(10)+Str(Y(Value)),                             #__type_Spin, 1)
      AddItemProperties(*Tree, #_pi_width, "width:"+Chr(10)+Str(Width(Value)),                 #__type_Spin, 1)
      AddItemProperties(*Tree, #_pi_height, "height:"+Chr(10)+Str(Height(Value)),              #__type_Spin, 1)
      
      AddItemProperties(*Tree, #_pi_group_2, "state")
      AddItemProperties(*Tree, #_pi_disable, "disable:"+Chr(10)+"",                                  #__type_ComboBox, 1);Str(Disable(Value)))
      AddItemProperties(*Tree, #_pi_hide, "hide:"+Chr(10)+Str(Hide(Value)),                          #__type_ComboBox, 1)
      
      Define *Tree1 = CreateProperties(10, 10, 250, 200, #__flag_gridlines);|#__tree_nolines);, #__flag_autosize) 
      Define Value = *Tree1
      AddItemProperties(*Tree1, #_pi_group_0, "common")
      AddItemProperties(*Tree1, #_pi_id, "id:"+Chr(10)+Str(Value),                                    #__type_String, 1)
      AddItemProperties(*Tree1, #_pi_class, "class:"+Chr(10)+GetClass(Value)+"_"+CountType(Value), #__type_String, 1)
      AddItemProperties(*Tree1, #_pi_text, "text:"+Chr(10)+GetText(Value),                            #__type_String, 1)
      
      AddItemProperties(*Tree1, #_pi_group_1, "layout")
      AddItemProperties(*Tree1, #_pi_x, "x:"+Chr(10)+Str( X(Value)),                             #__type_Spin, 1)
      AddItemProperties(*Tree1, #_pi_y, "y:"+Chr(10)+Str( Y(Value)),                             #__type_Spin, 1)
      AddItemProperties(*Tree1, #_pi_width, "width:"+Chr(10)+Str( Width(Value)),                 #__type_Spin, 1)
      AddItemProperties(*Tree1, #_pi_height, "height:"+Chr(10)+Str( Height(Value)),              #__type_Spin, 1)
      
      AddItemProperties(*Tree1, #_pi_group_2, "state")
      AddItemProperties(*Tree1, #_pi_disable, "disable:"+Chr(10)+"",                                  #__type_ComboBox, 1);Str(Disable(Value)))
      AddItemProperties(*Tree1, #_pi_hide, "hide:"+Chr(10)+Str(Hide(Value)),                          #__type_ComboBox, 1)
      
      Splitter_0 = Splitter(0, 0, 300, 300, Button_1, *Tree)
      Splitter_1 = Splitter(30, 30, 300, 300, Splitter_0, *Tree1, #PB_Splitter_Vertical)
      
      ;     Define *splitter._s_WIDGET = GetData(*Tree1)
      ;      Define *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      ;      Define *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      ;      ;*first\scroll\h\hide = 1
      ;      Repaint( *splitter\root )
      ;      Debug *first\scroll\h\hide
      
      Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 101
; FirstLine = 71
; Folding = ----
; Optimizer
; EnableXP
; DPIAware