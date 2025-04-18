﻿XIncludeFile "../../widgets.pbi"

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
      If GetState( EventWidget( ) )
         SetState(h_bar, 120)
         SetState(v_bar, 120)
      Else
         SetState(h_bar, w-10)
         SetState(v_bar, h-10)
      EndIf
   EndProcedure
   
   If Open(0, 0, 0, 420, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      widget()\bs = 0
      widget()\fs = 0
      Container(0,0, w,h, #PB_Container_Double)
      SetBackColor(widget(), $FFB3FDFF)
      widget()\bs = 20
      widget()\fs = 20
      Resize(widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) 
     
      test_resize = 1
     ; test_resize_area = 1
      widget = Tree(0, 0, 0, 0, #__flag_border_less)
      Define i
      AddItem(widget, -1, Str(i)+"test item ")
      For i=1 To 20
         If i%2
            AddItem(widget, -1, Str(i)+"test item test item test item ", -1, 1)
         Else
            AddItem(widget, -1, Str(i)+"test item test item test item ")
         EndIf
      Next
      
      widget()\bs = 0
      widget()\fs = 0
      
      widget()\scroll\v\round = 0
      widget()\scroll\v\bar\button\round = 0
      widget()\scroll\v\bar\button[1]\round = 0
      widget()\scroll\v\bar\button[2]\round = 0
      
      widget()\scroll\h\round = 0
      widget()\scroll\h\bar\button\round = 0
      widget()\scroll\h\bar\button[1]\round = 0
      widget()\scroll\h\bar\button[2]\round = 0
      CloseList()
      
;        Resize(widget(), 0, #PB_Ignore, 0, 120) 
;       widget() = widget
;       Debug widget()\scroll\v\x
   
      ; v
      ;v_bar=Splitter( w+10,10,20,h, -1, -1, #__bar_invert)
       v_bar=Track( w+10,10,20,h, 0, h-10, #PB_TrackBar_Vertical|#__bar_invert)
      SetBackColor(widget(), $FF80BE8E)
      SetState(widget(), 120)
      Bind( widget(), @track_v_events( ), #__event_change )
      ; h
      ;h_bar=Splitter( 10,h+10,w,20, -1, -1 , #PB_Splitter_Vertical)
       h_bar=Track( 10,h+10,w,20, 0, w-10 )
      SetBackColor(widget(), $FF80BE8E)
      SetState(widget(), 120)
      Bind( widget(), @track_h_events( ), #__event_change )
      
      
      Button(w+10,h+10,20,20,"", #PB_Button_Toggle)
      SetRound( widget(), 10 )
      Bind( widget(), @track_vh_events( ), #__event_Down )
;       
      ClearDebugOutput()
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 89
; FirstLine = 52
; Folding = --
; EnableXP
; DPIAware