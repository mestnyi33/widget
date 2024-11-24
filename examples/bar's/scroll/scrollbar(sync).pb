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
   
   Procedure Property_Events( )
      Protected *splitter._s_WIDGET = EventWidget( )\parent
      Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      
      Select WidgetEvent( )
         Case #__event_ScrollChange
            Select EventWidget( )
               Case *first 
                  If GetState( *second\scroll\v ) <> WidgetEventData( )
                     SetState(*second\scroll\v, WidgetEventData( ) )
                  EndIf
                  
               Case *second
                  If GetState( *first\scroll\v ) <> WidgetEventData( )
                     SetState(*first\scroll\v, WidgetEventData( ) )
                  EndIf
            EndSelect
            
         Case #__event_Focus, #__event_LostFocus
            If EventWidget( ) = *first
               If *first\RowFocused( ) 
                  SelectElement(*second\__rows( ), *first\RowFocused( )\index)
                  *second\__rows( )\color = *first\RowFocused( )\color
               EndIf
            EndIf
            
            If EventWidget( ) = *second
               If *second\RowFocused( )
                  SelectElement(*first\__rows( ), *second\RowFocused( )\index)
                  *first\__rows( )\color = *second\RowFocused( )\color
               EndIf
            EndIf
            
         Case #__event_StatusChange
            If EventWidget( ) = *first
               If WidgetEventData( ) = #PB_Tree_Expanded Or
                  WidgetEventData( ) = #PB_Tree_Collapsed
                  If SetItemState( *second, WidgetEventItem( ), WidgetEventData( ) )
                     ReDraw( *second )
                  EndIf
               EndIf
            EndIf   
            
            ;\\
            Select EventWidget( )
               Case *first
                  If *first\RowLeaved( )
                     SelectElement(*second\__rows( ), *first\RowLeaved( )\index)
                     *second\__rows( )\color = *first\RowLeaved( )\color
                  EndIf
                  If *first\RowEntered( )
                     SelectElement(*second\__rows( ), *first\RowEntered( )\index)
                     *second\__rows( )\color = *first\RowEntered( )\color
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
   
   Procedure AddItem_( *this._s_WIDGET, item, Text.s, Image=-1, mode=0 )
      Protected *splitter._s_WIDGET = GetData(*this)
      Protected *first._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_FirstGadget)
      Protected *second._s_WIDGET = GetAttribute(*splitter, #PB_Splitter_SecondGadget)
      
      AddItem( *first, item, StringField(Text.s, 1, Chr(10)), Image, mode )
      AddItem( *second, item, StringField(Text.s, 2, Chr(10)), Image, mode )
   EndProcedure
   
   Procedure Properties_( X,Y,Width,Height, flag=0 )
      Protected position = 70
      Protected *this._s_WIDGET = Container(X,Y,Width,Height) 
      Protected *first._s_WIDGET = Tree(0,0,0,0, #__flag_autosize)
      Protected *second._s_WIDGET = Tree(0,0,0,0, #PB_Tree_NoButtons|#PB_Tree_NoLines|#__flag_autosize)
      
      Protected *splitter._s_WIDGET = Splitter(0,0,0,0, *first,*second, #PB_Splitter_Vertical |#PB_Splitter_FirstFixed| #__flag_autosize )
      SetAttribute(*splitter, #PB_Splitter_SecondMinimumSize, position )
      SetState(*splitter, Width-position )
      SetData(*this, *splitter)
      
      *splitter\bar\button\size = 5
      *splitter\bar\button\round = 0
      
      Hide( *first\scroll\v, 1 )
      Hide( *first\scroll\h, 1 )
      ;Hide( *second\scroll\v, 1 )
      Hide( *second\scroll\h, 1 )
      CloseList( )
      
      
      SetData(*second, *first)
      SetData(*first, *second)
      
      Bind(*first, @Property_Events( ))
      Bind(*second, @Property_Events( ))
      ProcedureReturn *this
   EndProcedure
   
   If Open(0, 0, 0, 605+30, 140+200+140+140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      Define *Tree = Properties_(10, 10, 250, 200);, #__flag_gridlines);|#__tree_nolines);, #__flag_autosize) 
      Define Value = *Tree
      AddItem_(*Tree, #_pi_group_0, "common")
      AddItem_(*Tree, #_pi_id, "id:"+Chr(10)+Str(Value), #__type_String, 1)
      AddItem_(*Tree, #_pi_class, "class:"+Chr(10)+GetClass(Value)+"_"+CountType(Value), #__type_String, 1)
      AddItem_(*Tree, #_pi_text, "text:"+Chr(10)+GetText(Value), #__type_String, 1)
      
      AddItem_(*Tree, #_pi_group_1, "layout")
      AddItem_(*Tree, #_pi_x, "x:"+Chr(10)+Str(X(Value)), #__type_Spin, 1)
      AddItem_(*Tree, #_pi_y, "y:"+Chr(10)+Str(Y(Value)), #__type_Spin, 1)
      AddItem_(*Tree, #_pi_width, "width:"+Chr(10)+Str(Width(Value)), #__type_Spin, 1)
      AddItem_(*Tree, #_pi_height, "height:"+Chr(10)+Str(Height(Value)), #__type_Spin, 1)
      
      AddItem_(*Tree, #_pi_group_2, "state")
      AddItem_(*Tree, #_pi_disable, "disable:"+Chr(10)+"", #__type_ComboBox, 1);Str(Disable(Value)))
      AddItem_(*Tree, #_pi_hide, "hide:"+Chr(10)+Str(Hide(Value)), #__type_ComboBox, 1)
      
      Define *Tree1 = Properties_(10, 10, 250, 200, #__flag_gridlines);|#__tree_nolines);, #__flag_autosize) 
      Define Value = *Tree1
      AddItem_(*Tree1, #_pi_group_0, "common")
      AddItem_(*Tree1, #_pi_id, "id:"+Chr(10)+Str(Value), #__type_String, 1)
      AddItem_(*Tree1, #_pi_class, "class:"+Chr(10)+GetClass(Value)+"_"+CountType(Value), #__type_String, 1)
      AddItem_(*Tree1, #_pi_text, "text:"+Chr(10)+GetText(Value), #__type_String, 1)
      
      AddItem_(*Tree1, #_pi_group_1, "layout")
      AddItem_(*Tree1, #_pi_x, "x:"+Chr(10)+Str(X(Value)), #__type_Spin, 1)
      AddItem_(*Tree1, #_pi_y, "y:"+Chr(10)+Str(Y(Value)), #__type_Spin, 1)
      AddItem_(*Tree1, #_pi_width, "width:"+Chr(10)+Str(Width(Value)), #__type_Spin, 1)
      AddItem_(*Tree1, #_pi_height, "height:"+Chr(10)+Str(Height(Value)), #__type_Spin, 1)
      
      AddItem_(*Tree1, #_pi_group_2, "state")
      AddItem_(*Tree1, #_pi_disable, "disable:"+Chr(10)+"", #__type_ComboBox, 1);Str(Disable(Value)))
      AddItem_(*Tree1, #_pi_hide, "hide:"+Chr(10)+Str(Hide(Value)), #__type_ComboBox, 1)
      
      Splitter_0 = Splitter(0, 0, 300, 300, *Tree1, *Tree)
      Splitter_1 = Splitter(30, 30, 300, 300, -1, Splitter_0, #PB_Splitter_Vertical)
      
      ;
      SetBackgroundColor(Splitter_0, $FFAC86DB)
      SetBackgroundColor(Splitter_1, $FFACCBDB)
      
      ;SetFrame(Splitter_1, 50)
      
      
      ;     
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
; CursorPosition = 55
; FirstLine = 51
; Folding = ----
; EnableXP
; DPIAware