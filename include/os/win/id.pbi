DeclareModule ID
  Declare.i Window( WindowID.i )
  Declare.i Gadget( GadgetID.i )
  Declare.i IsWindowID( handle.i )
  Declare.i GetWindowID( handle.i )
  Declare.s ClassName( handle.i )
EndDeclareModule

Module ID
  Procedure.s GetTitle(Handle)
      Protected Name.s
      Name.s = Space(1024)
      GetWindowText_(Handle, @Name, Len(Name))
      ProcedureReturn Left(Name, Len(Name))
  EndProcedure
    
  Procedure.s ClassName( handle.i )
    Protected Class$ = Space( 16 )
    GetClassName_( handle, @Class$, Len( Class$ ) )
    ProcedureReturn Class$
  EndProcedure
  
  Procedure.i GetWindowID( handle.i ) ; Return the handle of the parent window from the handle
    ProcedureReturn GetAncestor_( handle, #GA_ROOT )
  EndProcedure
  
  Procedure.i IsWindowID( handle.i )
    If Left(ClassName( handle ), 11) = "WindowClass"
      ProcedureReturn 1
    EndIf
  EndProcedure
  
  Procedure.i Window( WindowID.i ) ; Return the id of the window from the window handle
    If WindowID
      Protected Window = GetProp_( WindowID, "PB_WindowID" ) - 1
      If IsWindow( Window ) And WindowID( Window ) = WindowID
        ProcedureReturn Window
      EndIf
      ProcedureReturn - 1
    Else
      ProcedureReturn - 1
    EndIf
  EndProcedure
  
  Procedure.i Gadget( GadgetID.i )  ; Return the id of the gadget from the gadget handle
    If GadgetID
      Protected Gadget = GetProp_( GadgetID, "PB_ID" )
      If IsGadget( Gadget ) And GadgetID( Gadget ) = GadgetID
        ProcedureReturn Gadget
      EndIf
      ProcedureReturn - 1
    Else
      ProcedureReturn - 1
    EndIf
  EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile 
  EnableExplicit
  Global eventID
  
  OpenWindow(1, 0, 0, 200, 100, "window", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ButtonGadget(1, 10, 10, 180,80, "button" ) 
  
  Debug "gadget - "+GadgetID(1) +" >> "+ ID::Gadget(GadgetID(1))
  Debug "window - "+WindowID(1) +" >> "+ ID::Window(WindowID(1))
  
  Debug "is windowID - "+GadgetID(1) +" >> " + ID::IsWindowID( GadgetID(1) )
  Debug "is windowID - "+WindowID(1) +" >> " + ID::IsWindowID( WindowID(1) )
  
  Repeat
    eventID = WaitWindowEvent( )
  Until eventID = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 32
; FirstLine = 1
; Folding = ---
; EnableXP