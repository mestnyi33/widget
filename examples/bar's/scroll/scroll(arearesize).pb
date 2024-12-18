XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile = 99
   UseWidgets( )
   Define i, widget
   ;
   If Open(0, 0, 0, 420, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      widget = Tree(0, 0, 0, 0)
      For i=0 To 20
         AddItem(widget, -1, "test item test item test item "+Str(i))
      Next
      ;
      Splitter(0, 0, 180, 120, widget, -1, #PB_Splitter_Vertical)
      WaitClose( )
   EndIf
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile ;= 99
   UseWidgets( )
   
   Global widget, v_bar, h_bar
   Global  w = 420-40, h = 280-40
   
   Procedure track_v_events( )
      Resize(widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, GetState(EventWidget()))
   EndProcedure
   Procedure track_h_events( )
      Resize(widget, #PB_Ignore, #PB_Ignore, GetState(EventWidget()), #PB_Ignore)
   EndProcedure
   
   Procedure track_vh_events( )
      SetState(h_bar, w-10)
      SetState(v_bar, h-10)
   EndProcedure
   
   If Open(0, 0, 0, 420, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Container(0,0, w,h)
      widget = Tree(0, 0, 1, 1)
      Define i
      For i=0 To 20
         AddItem(widget, -1, "test item test item test item "+Str(i))
      Next
      CloseList()
      
;       ;v
;       v_bar=Track( w+10,10,20,h, 0, h-10, #PB_TrackBar_Vertical|#__bar_invert)
;       SetBackgroundColor(widget(), $FF80BE8E)
;       SetState(widget(), 120)
;       Bind( widget(), @track_v_events( ), #__event_change )
;       ;h
;       h_bar=Track( 10,h+10,w,20, 0, w-10 )
;       SetBackgroundColor(widget(), $FF80BE8E)
;       SetState(widget(), 100)
;       Bind( widget(), @track_h_events( ), #__event_change )
;       
      
      ;v
      v_bar=Splitter( w+10,10,20,h, -1, -1, #__bar_invert)
      SetBackgroundColor(widget(), $FF80BE8E)
      SetState(widget(), 120)
      Bind( widget(), @track_v_events( ), #__event_change )
      ;h
      h_bar=Splitter( 10,h+10,w,20, -1, -1 , #PB_Splitter_Vertical)
      SetBackgroundColor(widget(), $FF80BE8E)
      SetState(widget(), 100)
      Bind( widget(), @track_h_events( ), #__event_change )
      
      Button(w+10,h+10,20,20,"")
      SetRound( widget(), 10 )
      Bind( widget(), @track_vh_events( ), #__event_Down )
      
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 36
; FirstLine = 24
; Folding = --
; EnableXP
; DPIAware