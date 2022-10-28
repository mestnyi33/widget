DeclareModule ID
  Declare.i Window( WindowID.i )
  Declare.i Gadget( GadgetID.i )
  Declare.i IsWindowID( handle.i )
  Declare.i GetWindowID( handle.i )
  Declare.s ClassName( handle.i )
EndDeclareModule

Module ID
  Procedure.s ClassName( handle.i )
    Protected Result = gtk_widget_get_name_( handle )
    If Result
      ProcedureReturn PeekS( Result, - 1, #PB_UTF8 )
    EndIf
  EndProcedure
  
  Procedure.i GetWindowID( handle.i ) ; Return the handle of the parent window from the handle
    ProcedureReturn gtk_widget_get_toplevel_( handle )
  EndProcedure
  
  Procedure.i IsWindowID( handle.i )
    If ClassName( handle ) = "PBWindow"
      ProcedureReturn 1
    EndIf
  EndProcedure
  
  Procedure.i Window( WindowID.i ) ; Return the id of the window from the window handle
    ProcedureReturn g_object_get_data_( handle, "pb_id" )
  EndProcedure
  
  Procedure.i Gadget( GadgetID.i )  ; Return the id of the gadget from the gadget handle
    ProcedureReturn g_object_get_data_( handle, "pb_id" ) - 1 
  EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile 
  EnableExplicit
  Global eventID
  
  OpenWindow(1, 0, 0, 200, 100, "window", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ButtonGadget(1, 10, 10, 180,80, "button" ) 
  
  Debug "gadget - "+GadgetID(1) +" >> "+ ID::Gadget(GadgetID(1))
  Debug "window - "+WindowID(1) +" >> "+ ID::Window(WindowID(1))
  
  Repeat
    eventID = WaitWindowEvent( )
  Until eventID = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP