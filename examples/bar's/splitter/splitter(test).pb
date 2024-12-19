XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile = 99
   UseWidgets( )
   
   Global Splitter_1, Splitter_2
  
   Procedure events_widgets( )
      widget( ) = Splitter_1
      Debug " - "+classfromevent(WidgetEvent())
      Debug ""+widget( )\bar\page\pos +" - page\pos"
      Debug ""+widget( )\bar\page\len +" - page\len"
      Debug ""+widget( )\bar\page\end +" - page\end"
      Debug ""+widget( )\bar\page\change +" - page\change"
      Debug ""+widget( )\bar\percent +" - percent"
      Debug ""+widget( )\bar\area\len +" - area\len"
      Debug ""+widget( )\bar\area\end +" - area\end"
      Debug ""+widget( )\bar\thumb\pos +" - thumb\pos"
      Debug ""+widget( )\bar\thumb\len +" - thumb\len"
      Debug ""+widget( )\bar\thumb\end +" - thumb\end"
      Debug ""+widget( )\bar\thumb\change +" - thumb\change"
      Debug " - "
   EndProcedure
   
   Procedure track_v_events( )
      Resize(Splitter_1, #PB_Ignore, #PB_Ignore, #PB_Ignore, GetState(EventWidget()))
   EndProcedure
   Procedure track_h_events( )
      Resize(Splitter_1, #PB_Ignore, #PB_Ignore, GetState(EventWidget()), #PB_Ignore)
   EndProcedure
   
   If Open(0, 0, 0, 420, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
     ; a_init(root())
      
      Splitter_1 = Splitter(10, 10, 180, 120, -1, -1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
      SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 60)
      SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 60)
      Splitter_2 = Splitter(10, 10, 180, 120, Splitter_1, -1)
      
      widget( ) = Splitter_1
      Debug widget( )\bar\page\pos
      
      Bind( #PB_All, @events_widgets( ), #__event_down )
      Bind( #PB_All, @events_widgets( ), #__event_up )
      WaitClose( )
   EndIf
   
CompilerEndIf

; good
CompilerIf #PB_Compiler_IsMainFile
   
   CompilerIf Not Defined(Splitter, #PB_Module)
      DeclareModule Splitter
         EnableExplicit
         UseModule constants
         UseModule structures
         
         
         ;- DECLARE
         Declare GetState(Gadget.i)
         Declare SetState(Gadget.i, State.i)
         Declare GetAttribute(Gadget.i, Attribute.i)
         Declare SetAttribute(Gadget.i, Attribute.i, Value.i)
         Declare Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, First.i, Second.i, Flag.i=0)
         Declare Bind(Gadget.i, *callBack, eventtype.i)
      EndDeclareModule
      
      Module Splitter
         widget::test_draw_repaint = 1
         
         ;- PUBLIC
         Procedure GetState(Gadget.i)
            If widget::ChangeCurrentCanvas( GadgetID(gadget) )
               ProcedureReturn widget::GetState( widget::root( ) )
            EndIf
         EndProcedure
         
         Procedure GetAttribute(Gadget.i, Attribute.i)
            If widget::ChangeCurrentCanvas( GadgetID(gadget) )
               ProcedureReturn widget::GetAttribute( widget::root( ), Attribute )
            EndIf
         EndProcedure
         
         Procedure SetState(Gadget.i, State.i)
            If widget::ChangeCurrentCanvas( GadgetID(gadget) )
               If widget::SetState( widget::root( ), State) 
                  widget::PostEventRepaint( widget::root( ) )
               EndIf
            EndIf
         EndProcedure
         
         Procedure SetAttribute(Gadget.i, Attribute.i, Value.i)
            If widget::ChangeCurrentCanvas( GadgetID(gadget) )
               If widget::SetAttribute( widget::root( ), Attribute, Value)
                  widget::PostEventRepaint( widget::root( ) )
               EndIf
            EndIf
         EndProcedure
         
         Procedure Bind(Gadget.i, *callBack, eventtype.i)
            If widget::ChangeCurrentCanvas( GadgetID(gadget) )
               If widget::Bind( widget::root( ), *callBack, eventtype)
                  widget::PostEventRepaint( widget::root( ) )
               EndIf
            EndIf
         EndProcedure
         
         Procedure Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, First.i, Second.i, Flag.i=0)
            ProcedureReturn widget::Gadget(#PB_GadgetType_Splitter, Gadget, X, Y, Width, Height, "", First, Second, #Null, Flag)
         EndProcedure
      EndModule
   CompilerEndIf
   
   Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
   
   Procedure event_resize()
      ; Debug 88
   EndProcedure
   
   If OpenWindow(0, 0, 0, 850, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
      Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
      
      Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
      Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
      Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
      Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
      
      Splitter_0 = SplitterGadget(#PB_Any, 10, 10, 410, 210, Button_0, Button_1, #PB_Splitter_Separator|#PB_Splitter_FirstFixed)
      Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
      SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
      SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
      Splitter_2 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
      Splitter_3 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
      Splitter_4 = SplitterGadget(#PB_Any, 10, 10, 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
      
      ; bug purebasic
      SetGadgetState(Splitter_0, GadgetWidth(Splitter_0)/2-5)
      SetGadgetState(Splitter_1, GadgetWidth(Splitter_1)/2-5)
      
      SetGadgetState(Splitter_1, 20)
      
      TextGadget(#PB_Any, 110, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
      
      Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
      Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
      
      Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
      Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
      Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
      Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
      
      Splitter_0 = Splitter::Gadget(0, 0, 0, 40, 210, Button_0, Button_1, #PB_Splitter_FirstFixed)
      Splitter_1 = Splitter::Gadget(1, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
      Splitter_1 = 1
      ;     Splitter::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
      ;     Splitter::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
      Splitter_2 = Splitter::Gadget(2, 0, 0, 0, 0, Splitter_1, Button_5)
      Splitter_2 = 2
      Splitter_3 = Splitter::Gadget(3, 0, 0, 0, 0, Button_2, Splitter_2)
      Splitter_3 = 3
      Splitter_0 = 0
      Splitter_4 = Splitter::Gadget(4, 430, 10, 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
      Splitter_4 = 4
      Splitter::SetState(Splitter_1, 20)
      
      TextGadget(#PB_Any, 530, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
      
      Splitter::Bind(Splitter_3, @event_resize( ), #PB_EventType_Resize )
      
      Define *this.structures::_S_WIDGET = GetGadgetData(0)
      Debug ""+*this\width[constants::#__c_Draw] +" "+ *this\root\width +" "+ GadgetWidth(0)
      ;ResizeGadget(0, #PB_Ignore, #PB_Ignore, 30, #PB_Ignore)
      
      Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
      ; Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
   EndIf
   
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 173
; FirstLine = 104
; Folding = +----
; Optimizer
; EnableXP
; DPIAware