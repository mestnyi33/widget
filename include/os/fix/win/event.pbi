;-\\ WINDOWS OS
XIncludeFile "../events.pbi"

Module Events
   Procedure.w HIWORD(Value.L)
      ProcedureReturn (((Value) >> 16) & $FFFF)
   EndProcedure
   
   Procedure.w LOWORD(Value)
      ProcedureReturn ((Value) & $FFFF)
   EndProcedure
   
   Procedure CallbackHandler(hWnd, uMsg, wParam, lParam) 
      Protected gadget = GetProp_( hWnd, "PB_ID" )
      Protected sysProc = GetProp_(hWnd, "sysProc")
      Protected *callBack = GetProp_(hWnd, "sysProc"+Str(GetProp_(hWnd, "sysProcType")))
      Static focus.i, enter.b, move.b 
      
      Select uMsg
         Case #WM_NCDESTROY 
            SetWindowLongPtr_(hwnd, #GWLP_USERDATA, sysProc)
            RemoveProp_(hwnd, sysProc)
;             
;          Case #WM_LBUTTONDOWN : move = 0
;          Case #WM_LBUTTONUP : move = 0
;          Case #WM_MOUSEFIRST
;             Protected Track.TRACKMOUSEEVENT
;             Track\cbSize = SizeOf(Track)
;             Track\dwFlags = #TME_HOVER|#TME_LEAVE
;             Track\hwndTrack = hWnd
;             Track\dwHoverTime = 1
;             TrackMouseEvent_(@TRACK)
;             
;             ; Case #WM_MOUSEMOVE
;             If move
;                CallFunctionFast( *callBack,  gadget, #PB_EventType_MouseMove )
;                ProcedureReturn 0
;             Else
;                move = 1
;             EndIf
;             
         Case #WM_MOUSEHWHEEL 
            CallFunctionFast( *callBack,  gadget, constants::#PB_EventType_MouseWheelX, - HIWORD(wparam) );( delta * step / #WHEEL_DELTA )) )
            ProcedureReturn 0
            
         Case #WM_MOUSEWHEEL 
            CallFunctionFast( *callBack,  gadget, constants::#PB_EventType_MouseWheelY , HIWORD(wparam) );( delta * step / #WHEEL_DELTA ))
            ProcedureReturn 0
            
;          Case #WM_KEYUP
;             If wParam = 9
;                ProcedureReturn 0
;             EndIf
            
         Case #WM_KEYDOWN
           If wParam = 9
             Debug ""+wParam +" "+ lParam +" "
            EndIf
      EndSelect
      
      ProcedureReturn CallWindowProc_(sysProc, hWnd, uMsg, wParam, lParam)
   EndProcedure 
   
   Procedure BindGadget( gadget, *callBack, eventtype = #PB_All )
      Protected hWnd = GadgetID( gadget )
      Protected sysProc = SetWindowLongPtr_(hWnd, #GWL_WNDPROC, @CallbackHandler())
      SetProp_(hWnd, "sysProc", sysProc)
      SetProp_(hWnd, "sysProcType", eventtype)
      SetProp_(hWnd, "sysProc"+Str(eventtype), *callBack)
   EndProcedure
   
   ;    Procedure.i WaitEvent( event.i, second.i = 0 )
   ;       ProcedureReturn event
   ;    EndProcedure
   
   Procedure   SetCallBack(*callback)
      
   EndProcedure
EndModule
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 52
; FirstLine = 33
; Folding = --
; EnableXP