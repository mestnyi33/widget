;- >>> [DECLARE] <<<
DeclareModule ID
   Declare.i Window( WindowID.i )
   Declare.i Gadget( GadgetID.i )
   Declare.i IsWindowID( handle.i )
   Declare.i GetWindowID( handle.i )
   Declare.s ClassName( handle.i )
EndDeclareModule

;- >>> [MACOS] <<<
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
   Module ID
      ; XIncludeFile "../import.pbi"
      Import ""
         PB_Window_GetID( WindowID.i ) 
      EndImport
      
      Procedure.s ClassName( handle.i )
         Protected Result
         CocoaMessage( @Result, CocoaMessage( 0, handle, "className" ), "UTF8String" )
         
         If Result
            ProcedureReturn PeekS( Result, - 1, #PB_UTF8 )
         EndIf
      EndProcedure
      
      Procedure.i GetWindowID( handle.i ) ; Return the handle of the parent window from the handle
         ProcedureReturn CocoaMessage( 0, handle, "window" )
      EndProcedure
      
      Procedure.i IsWindowID( handle.i )
         If ClassName( handle ) = "PBWindow"
            ProcedureReturn 1
         EndIf
      EndProcedure
      
      Procedure.i Window( WindowID.i ) ; Return the id of the window from the window handle
         If WindowID
            Protected Window = PB_Window_GetID( WindowID )
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
            Protected Gadget = CocoaMessage(0, GadgetID, "tag")
            If IsGadget( Gadget ) And GadgetID( Gadget ) = GadgetID
               ProcedureReturn Gadget
            EndIf
            ProcedureReturn - 1
         Else
            ProcedureReturn - 1
         EndIf
      EndProcedure
   EndModule
CompilerEndIf

;- >>> [WINDOWS] <<<
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
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
CompilerEndIf

;- >>> [LINUX] <<<
CompilerIf #PB_Compiler_OS = #PB_OS_Linux
   Module ID
      Procedure.s ClassName( handle.i )
         Protected Result = gtk_widget_get_name_( handle )
         If Result
            ProcedureReturn PeekS( Result, - 1, #PB_UTF8 )
         EndIf
      EndProcedure
      
      Procedure.i GetWindowID( handle.i ) ; Return the handle of the parent window from the handle
         If handle
            ProcedureReturn gtk_widget_get_toplevel_( handle )
         EndIf
      EndProcedure
      
      Procedure.i IsWindowID( handle.i )
         If handle And ClassName( handle ) = "PBWindow"
            ProcedureReturn 1
         EndIf
      EndProcedure
      
      Procedure.i Window( WindowID.i ) ; Return the id of the window from the window handle
         If WindowID 
            Protected Window = g_object_get_data_( WindowID, "pb_id" )
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
            Protected Gadget = g_object_get_data_( GadgetID, "pb_id" ) - 1 
            If IsGadget( Gadget ) And GadgetID( Gadget ) = GadgetID
               ProcedureReturn Gadget
            EndIf
            ProcedureReturn - 1
         Else
            ProcedureReturn - 1
         EndIf
      EndProcedure
   EndModule
CompilerEndIf

;- >>> [EXAMPLE] <<<
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
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 1
; Folding = 9-8-4-f-
; EnableXP
; DPIAware