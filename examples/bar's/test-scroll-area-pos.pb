XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   Global object 
   Global v_bar, h_bar, gadget, min_size
   Global  w = 420-40, h = 280-40
   
   Procedure events_widgets( )
      Widget( ) = object
      Debug " - "+ClassFromEvent(WidgetEvent())
      Debug ""+Widget( )\bar\percent +" - percent"
      Debug ""+Widget( )\bar\page\pos +" - page\pos"
      Debug ""+Widget( )\bar\page\len +" - page\len"
      Debug ""+Widget( )\bar\page\end +" - page\end"
      Debug ""+Widget( )\bar\area\len +" - area\len"
      Debug ""+Widget( )\bar\area\end +" - area\end"
      Debug ""+Widget( )\bar\thumb\pos +" - thumb\pos"
      Debug ""+Widget( )\bar\thumb\len +" - thumb\len"
      Debug ""+Widget( )\bar\thumb\end +" - thumb\end"
      Debug " - "
   EndProcedure
   
   Procedure create_test( mode = 0, min = 0 )
      Protected w = 180
      Protected h = 120
      
      If h_bar
         w = GetState(h_bar)
      EndIf
      If v_bar
         h = GetState(v_bar)
      EndIf
      
      If gadget
         If mode = 1
            object = SplitterGadget(-1,10, 10, w, h, TextGadget(-1,0,0,0,0,"fixed"), TextGadget(-1,0,0,0,0,""), #PB_Splitter_Separator|#PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
;             SetGadgetColor(GetGadgetAttribute(object, #PB_Splitter_FirstGadget), #PB_Gadget_BackColor, $FFB3FDFF)
;             SetGadgetColor(GetGadgetAttribute(object, #PB_Splitter_SecondGadget), #PB_Gadget_BackColor, $FFB3FDFF)
         ElseIf mode = 2
            object = SplitterGadget(-1,10, 10, w, h, TextGadget(-1,0,0,0,0,""), TextGadget(-1,0,0,0,0,"fixed"), #PB_Splitter_Separator|#PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
         Else
            object = SplitterGadget(-1,10, 10, w, h, TextGadget(-1,0,0,0,0,""), TextGadget(-1,0,0,0,0,""), #PB_Splitter_Separator|#PB_Splitter_Vertical)
         EndIf
         If min
            SetGadgetAttribute(object, #PB_Splitter_FirstMinimumSize, min)
            SetGadgetAttribute(object, #PB_Splitter_SecondMinimumSize, min)
         EndIf
      Else
         Define i,Widget = Tree(0, 0, 0, 0, #__flag_Borderless)
         
         AddItem(Widget, -1, Str(i)+"test item ")
         For i=1 To 20
            If i%2
               AddItem(Widget, -1, Str(i)+"test item test item test item ", -1, 1)
            Else
               AddItem(Widget, -1, Str(i)+"test item test item test item ")
            EndIf
         Next
         Widget = Splitter(0, 0, 0, 0, -1, Widget, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
         
         If mode = 1
            object = Splitter(10, 10, w, h, Text(0,0,0,0,"fixed"), -1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
         ElseIf  mode = 2
            object = Splitter(10, 10, w, h, -1, Text(0,0,0,0,"fixed"), #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
         Else
            object = Splitter(10, 10, w, h, -1, Widget, #PB_Splitter_Vertical)
         EndIf
         ;Resize(object, #PB_Ignore, #PB_Ignore, w,h)
         If min
            min_size = min
            SetAttribute(object, #PB_Splitter_FirstMinimumSize, min)
            SetAttribute(object, #PB_Splitter_SecondMinimumSize, min)
         EndIf
         
          SetState(object, 0)
     
      EndIf
   EndProcedure
   
   Procedure track_v_events( )
      If gadget
         ResizeGadget(object, #PB_Ignore, #PB_Ignore, #PB_Ignore, GetState(EventWidget()))
      Else
         Resize(object, #PB_Ignore, #PB_Ignore, #PB_Ignore, GetState(EventWidget()))
      EndIf
   EndProcedure
   Procedure track_h_events( )
      If gadget
         ResizeGadget(object, #PB_Ignore, #PB_Ignore, GetState(EventWidget()), #PB_Ignore)
      Else
         Resize(object, #PB_Ignore, #PB_Ignore, GetState(EventWidget()), #PB_Ignore)
      EndIf
   EndProcedure
   
   Procedure track_vh_events( )
      If GetState( EventWidget( ) )
         SetState(h_bar, 180)
         SetState(v_bar, 120)
      Else
         SetState(h_bar, w-10)
         SetState(v_bar, h-10)
      EndIf
   EndProcedure
   
   Procedure key_events( )
      Protected Free, Create
      
      If keyboard( )\key = #PB_Shortcut_1
         Free = 1
         Create =- 1
      EndIf
      If keyboard( )\key = #PB_Shortcut_2
         Free = 1
         Create = 1
      EndIf
      If keyboard( )\key = #PB_Shortcut_3
         Free = 1
         Create = 2
      EndIf
      
      If Free
         If gadget
            FreeGadget(object)
         Else
            Free(object)
         EndIf
      EndIf
      
      If Create
         If Create =- 1
            gadget ! 1
         EndIf
         create_test( Create, min_size )
      EndIf
   EndProcedure
   
   If Open(0, 0, 0, 420, 280, "press key_(0-1-2) to replace object", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ;gadget = 1
      create_test( 0, 30 )
      ;v
      ;v_bar=Splitter( w+10,10,20,h, -1, -1, #__flag_Invert)
      v_bar=Track( w+10,10,20,h, 0, h-10, #PB_TrackBar_Vertical|#__flag_Invert)
      SetBackColor(Widget(), $FF80BE8E)
      SetState(Widget(), 120)
      Bind( Widget(), @track_v_events( ), #__event_change )
      ;h
      ;h_bar=Splitter( 10,h+10,w,20, -1, -1 , #PB_Splitter_Vertical)
      h_bar=Track( 10,h+10,w,20, 0, w-10 )
      SetBackColor(Widget(), $FF80BE8E)
      SetState(Widget(), 380)
      Bind( Widget(), @track_h_events( ), #__event_change )
      
      Button(w+10,h+10,20,20,"", #PB_Button_Toggle)
      SetRound( Widget(), 10 )
      Bind( Widget(), @track_vh_events( ), #__event_Down )
      
;       widget() = object
;       Debug  widget()\bar\fixed[1]
      
      SetActive( Root() )
      SetActiveGadget( GetCanvasGadget() )
      Bind( Root(), @key_events( ), #__event_KeyDown )
      
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 145
; FirstLine = 141
; Folding = -----
; EnableXP
; DPIAware