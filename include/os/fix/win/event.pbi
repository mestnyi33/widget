﻿;-\\ LINUX OS
XIncludeFile "../events.pbi"


Module events
   Procedure Events( )
   EndProcedure
   
   ; fixed bug mouse enter & leave
   
   ;
   Procedure.w HIWORD(Value.L)
      ProcedureReturn (((Value) >> 16) & $FFFF)
   EndProcedure
   
   Procedure.w LOWORD(Value)
      ProcedureReturn ((Value) & $FFFF)
   EndProcedure
   
   Procedure CallbackHandler(hWnd, uMsg, wParam, lParam) 
      Protected text.s, gadget = GetProp_( hWnd, "PB_ID" )
      Protected sysProc = GetProp_(hWnd, "sysProc")
      Protected *callBack = GetProp_(hWnd, "sysProc"+Str(GetProp_(hWnd, "sysProcType")))
      Static enter.b
      
      Select uMsg
         Case #WM_NCDESTROY 
            SetWindowLongPtr_(hwnd, #GWLP_USERDATA, sysProc)
            RemoveProp_(hwnd, sysProc)
            
         Case #WM_MOUSEFIRST
            Protected TRACK.TRACKMOUSEEVENT
            TRACK\cbSize = SizeOf(TRACK)
            TRACK\dwFlags = #TME_HOVER|#TME_LEAVE
            TRACK\hwndTrack = hWnd
            TRACK\dwHoverTime = 1
            TrackMouseEvent_(@TRACK)
            
         Case #WM_MOUSELEAVE
            enter = 0
            ; text = "leave gadget #" + Str(gadget)
            CallFunctionFast( *callBack,  #PB_Event_Gadget, gadget, #PB_EventType_MouseLeave )
            
         Case #WM_MOUSEHOVER
            If enter = 0
               enter = 1
               ; text = "enter gadget #" + Str(gadget)
               CallFunctionFast( *callBack,  #PB_Event_Gadget, gadget, #PB_EventType_MouseEnter )
            EndIf
            ;CallFunctionFast( *callBack,  #PB_Event_Gadget, gadget, #PB_EventType_MouseMove )
            
         Case #WM_MOUSEHWHEEL 
            CallFunctionFast( *callBack,  #PB_Event_Gadget, gadget, constants::#PB_EventType_MouseWheelX, - HIWORD(wparam) );(delta * step / #WHEEL_DELTA) )
            ProcedureReturn 0
            
         Case #WM_MOUSEWHEEL 
            CallFunctionFast( *callBack,  #PB_Event_Gadget, gadget, constants::#PB_EventType_MouseWheelY , HIWORD(wparam) );(delta * step / #WHEEL_DELTA))
            ProcedureReturn 0
            
            
            ;          Case #WM_SETFOCUS
            ;             ;text = "Focus on gadget #" + Str(gadget)
            ;             CallFunctionFast( *callBack,  #PB_Event_Gadget, gadget, #PB_EventType_Focus )
            ;             
            ;          Case #WM_KILLFOCUS
            ;             ; text = "Lost focus on gadget #" + Str(gadget)
            ;             CallFunctionFast( *callBack,  #PB_Event_Gadget, gadget, #PB_EventType_LostFocus)
            ;           
            ;          Case #WM_LBUTTONDOWN
            ;             ;text = "Left button down on gadget #" + Str(gadget)
            ;             CallFunctionFast( *callBack,  #PB_Event_Gadget, gadget, #PB_EventType_LeftButtonDown )
            ;             
            ;          Case #WM_LBUTTONUP
            ;             ;text = "Left button up on gadget #" + Str(gadget)
            ;             CallFunctionFast( *callBack,  #PB_Event_Gadget, gadget, #PB_EventType_LeftButtonUp )
            ;             
            ;          Case #WM_LBUTTONDBLCLK
            ;             text = "Left button click on gadget #" + Str(gadget)
            ;             
            ;          Case #WM_RBUTTONDOWN
            ;             ;text = "Right button down on gadget #" + Str(gadget)
            ;             CallFunctionFast( *callBack,  #PB_Event_Gadget, gadget, #PB_EventType_RightButtonDown )
            ;             
            ;          Case #WM_RBUTTONUP
            ;             ; text = "Right button up on gadget #" + Str(gadget)
            ;             CallFunctionFast( *callBack,  #PB_Event_Gadget, gadget, #PB_EventType_RightButtonUp )
            ;             
            ;          Case #WM_RBUTTONDBLCLK
            ;             text = "Right button click on gadget #" + Str(gadget)
      EndSelect
      
      If text
         Debug text
      EndIf
      
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
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 51
; FirstLine = 36
; Folding = --
; EnableXP