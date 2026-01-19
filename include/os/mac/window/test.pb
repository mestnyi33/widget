Procedure.s ObjectInheritance( Object ) ; temp
   
   Protected.i Result
   Protected.i MutableArray = CocoaMessage( 0, 0, "NSMutableArray arrayWithCapacity:", 10 )
   
   Repeat
      CocoaMessage( 0, MutableArray, "addObject:", CocoaMessage( 0, Object, "className" ) )
      CocoaMessage( @Object, Object, "superclass" )
   Until Object = 0
   
   CocoaMessage( @Result, MutableArray, "componentsJoinedByString:$", @"  -->  " )
   CocoaMessage( @Result, Result, "UTF8String" )
   
   ProcedureReturn PeekS( Result, -1, #PB_UTF8 )
   
EndProcedure

Procedure.s ClassName( handle.i )
   Protected Result
   CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
   If Result
      ProcedureReturn PeekS( Result, -1, #PB_UTF8 )
   EndIf
EndProcedure

Procedure IsChildWindow( child, parent )
   If CocoaMessage( 0, child, "parentWindow" ) = parent
      ProcedureReturn 1
   EndIf
;    Protected.i childArray = CocoaMessage( 0, parent, "childWindows" )
;    
;    If ClassName( child ) <> "__NSArray0"
;       ProcedureReturn 1
;    EndIf
EndProcedure

If OpenWindow(1, 100, 200, 195, 260, "1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
   
   OpenWindow(2, 300, 300, 195, 260, "2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget, WindowID(1))
   
   handle = WindowID(2)
   ;handle = WindowID(1)
   handle = CocoaMessage( 0, handle, "parentWindow" )
   
   ;CocoaMessage( @handle, handle, "superclass" )
   ;CocoaMessage( @handle, handle, "superclass" )
   ;CocoaMessage( @handle, handle, "superclass" )
   
;    handle = CocoaMessage( 0, handle, "contentView" ) 
;    handle = CocoaMessage( 0, handle, "superview" ) 
   
   ;CocoaMessage( @handle, handle, "superclass" )
   ;CocoaMessage( @handle, handle, "superclass" )
   ;CocoaMessage( @handle, handle, "superclass" )
   ;CocoaMessage( @handle, handle, "superclass" )
   
   
  ; handle = CocoaMessage(  0, handle, "window")
   ;Debug ObjectInheritance(handle)
   Debug ""+handle +" "+ ClassName(handle) +" "+ IsChildWindow(WindowID(2), WindowID(1))
   
   Repeat
      Event = WaitWindowEvent()
      
      If Event = #PB_Event_CloseWindow  ; If the user has pressed on the close button
         Quit = 1
      EndIf
      
   Until Quit = 1
   
EndIf

End   ; All the opened windows are closed automatically by PureBasic
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 32
; FirstLine = 20
; Folding = --
; EnableXP
; DPIAware