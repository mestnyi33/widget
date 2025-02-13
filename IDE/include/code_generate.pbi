;- Code
EnableExplicit

DeclareModule Code
   EnableExplicit
   
   Declare.S Code_EventType( Indent, Types.S )
   Declare.S Code_EventGadget( Indent, Types.S )
   
   Declare.S Code_BindGadgetEvent( Indent, StringS.S, Mode = 0)
   Declare.S Code_BindGadgetEvent_Procedure( Indent, ProcedureName.S, Gadgets.S, Types.S = "")
   
   Declare.S Code_BindEvent( Indent, Events.S, Windows.S )
   Declare.S Code_Event( Indent, Windows.S, Events.S, Functions.S, WaitWindowEvent.S = "Event" )
   Declare.S Code_Event_Procedure( Indent, Windows.S, Events.S, Functions.S )
   
   Declare.S Code_BindGadgetEventPost( Gadgets.S, Name.S )
EndDeclareModule

Module Code
   
   Procedure.S Code_EventType( Indent, Types.S ) ; Ok
      Protected Includes.S, Include.S, EventType.S, Type.S, II, I, Code.S, CountType = CountString( Types.S, "|" ) + (1)
      
      If Types.S And CountType
         Code.S = Code.S + Space( Indent ) + "Select EventType( )" + #CRLF$
         ;EndIf
         
         For I = (1) To CountType
            Type.S = Trim( StringField( Types.S, I, "|" ))
            
            If Type.S 
               EventType.S = Trim(Mid( Type.S, (1), FindString( Type.S, "=" )-(1)))
               
               If EventType.S 
                  Code.S = Code.S + Space( Indent ) + Space( 2 ) + "Case " + EventType.S + #CRLF$ ;
                  
                  Includes.S = Trim(Mid( Type.S, FindString( Type.S, "=" )+(1)))
                  
                  For II = (1) To CountString( Includes.S, "/" ) + (1)
                     Include.S = Trim( StringField( Includes.S, II, "/" ))
                     If Include.S 
                        Code.S = Code.S + Space( Indent ) + Space( 4 ) + Include.S + #CRLF$
                     EndIf
                  Next
                  
               Else
                  Code.S = Code.S + Space( Indent ) + Space( 2 ) + "Case " + Type.S + #CRLF$ ;
               EndIf
               
               Code.S = Code.S + Space( Indent ) + Space( 4 ) + #CRLF$
            EndIf
         Next
         
         ;If Types.S And CountType
         Code.S = Code.S + Space( Indent ) + "EndSelect" + #CRLF$
      EndIf
      
      ProcedureReturn Code.S
   EndProcedure
   
   Procedure.S Code_EventGadget( Indent, Types.S ) ; Ok
      Protected I, Gadget.S, Type.S, Gadgets.S, Code.S, CountType = CountString( Types.S, "?" ) + (1)
      
      If Types.S And CountType
         ;If Types.S And CountType
         Code.S = Code.S + Space( Indent ) + "Select EventGadget( )" + #CRLF$
         ;EndIf
         
         For I = (1) To CountType
            Gadgets.S = Trim( StringField( Types.S, I, "?" ))
            
            If Gadgets.S 
               Gadget.S = Trim(Mid( Gadgets.S, (1), FindString( Gadgets.S, "\" )-(1)))
               
               If Gadget.S
                  Code.S = Code.S + Space( Indent + ( 2 ) ) + "Case " + Gadget.S + #CRLF$ 
                  
                  Type.S = Trim(Mid( Gadgets.S, FindString( Gadgets.S, "\" )+(1)))
                  Code.S = Code.S + Code_EventType( Indent + ( 4 ), Type.S) + #CRLF$ 
               Else
                  Code.S = Code.S + Space( Indent + ( 2 ) ) + "Case " + Gadgets.S + #CRLF$ 
               EndIf
               
            EndIf
         Next
         
         ;If Types.S And CountType
         Code.S = Code.S + Space( Indent ) + "EndSelect" + #CRLF$
         ;EndIf
      EndIf
      
      ProcedureReturn Code.S
   EndProcedure
   
   Procedure.S Code_BindGadgetEvent( Indent, StringS.S, Mode = 0) ; Ok
      Protected II, String.S, EventType.S, Gadget.S, Type.S, I, Code.S
      If StringS.S
         For I = (1) To CountString( StringS.S, "?" ) + (1)
            String.S = Trim( StringField( StringS.S, I, "?" ))
            
            If String.S 
               Gadget.S = Trim(Mid( String.S, (1), FindString( String.S, "\" )-(1)))
               
               If Gadget.S = ""
                  Code.S = Code.S + Space( Indent ) + "BindGadgetEvent( " + String.S + ", @" + Trim( String.S, "#" ) + "_Event( ) )" + #CRLF$
               Else
                  If Mode
                     For II = (1) To CountString( String.S, "|" ) + (1)
                        EventType.S = Trim( StringField( String.S, II, "|" ))
                        EventType.S = Trim(Mid( EventType.S, (1), FindString( EventType.S, "=" )-(1)))
                        EventType.S = Trim(Mid( EventType.S, FindString( EventType.S, "\" )+(1)))
                        
                        Code.S = Code.S + Space( Indent ) + "BindGadgetEvent( " + Gadget.S + ", @" + Trim( Gadget.S, "#" ) + "_Event" + RemoveString(EventType.S,"#PB_EventType") + "( ), "+EventType.S+" )" + #CRLF$
                     Next
                  Else
                     Type.S = ""
                     For II = (1) To CountString( String.S, "|" ) + (1)
                        EventType.S = Trim( StringField( String.S, II, "|" ))
                        EventType.S = Trim(Mid( EventType.S, (1), FindString( EventType.S, "=" )-(1)))
                        EventType.S = Trim(Mid( EventType.S, FindString( EventType.S, "\" )+(1)))
                        Type.S = Trim( Type.S +"|"+ EventType.S, "|")
                     Next
                     
                     Code.S = Code.S + Space( Indent ) + "BindGadgetEvent( " + Gadget.S + ", @" + Trim( Gadget.S, "#" ) + "_Event( ), "+Type.S+" )" + #CRLF$
                  EndIf
               EndIf
            EndIf
         Next
         
      Else
         
      EndIf
      
      
      ProcedureReturn Code.S
   EndProcedure
   
   Procedure.S Code_BindGadgetEvent_Procedure( Indent, ProcedureName.S, Gadgets.S, Types.S = "") ; Ok
      Protected Code.S
      If ProcedureName.S
         If Not ((Mid(ProcedureName.S, (1), (1)) = ".") Or 
                 (Mid(ProcedureName.S, (1), (1)) = "$"))
            
            If Gadgets.S
               ProcedureName.S = ProcedureName.S + "_Gadget_Event( )"
            ElseIf Types.S
               ProcedureName.S = ProcedureName.S + "_GadgetType_Event( )"
            EndIf
            
            ProcedureName.S = " " + ProcedureName.S
         EndIf
         
         Code.S = Space( Indent ) + "Procedure" + ProcedureName.S + #CRLF$
         Indent = Indent  +  ( 2 )
      EndIf
      
      If Gadgets.S
         Code.S = Code.S + Code_EventGadget( Indent, Gadgets.S )
      Else
         Code.S = Code.S + Code_EventType( Indent, Types.S )
      EndIf
      
      If ProcedureName.S
         Indent = Indent  -  ( 2 )
         Code.S = Code.S + Space( Indent ) + "EndProcedure" + #CRLF$
      EndIf
      
      ProcedureReturn Code.S
   EndProcedure
   
   Procedure.S Code_BindGadgetEventPost( Gadgets.S, Name.S ) ; Gadgets.S =  ; Name.S = "Window name example(CodeForm)"
      Protected Code.S, I, Gadget.S
      For I = (1) To CountString( Gadgets.S, "?" ) + (1)
         Gadget.S = Trim( StringField( Gadgets.S, I, "?" )) 
         ;Debug Gadget.S
         If Gadget.S
            Code.S = Code.S + "BindGadgetEvent( " + Trim(Mid( Gadget.S, (1), FindString( Gadget.S, "\" )-(1))) + ", @" + Name.S + "_GadgetType_Event( ) )" + #CRLF$
         EndIf
      Next
      ProcedureReturn Code.S
   EndProcedure
   
   ;-
   Procedure.S Code_Event( Indent, Windows.S, Events.S, Functions.S, WaitWindowEvent.S = "Event" )
      Protected Window.S, Code.S, Event.S, Space.S = Space( Indent )
      Protected I, II, III, Function.S
      
      Windows.S = Trim(Windows.S, "|")
      Events.S = Trim(Events.S, "|")
      Functions.S = Trim(Functions.S, "|")
      
      
      For I = 1 To CountString( Windows.S, "|") + (1)
         Window.S = Trim( StringField( Windows.S, I, "|" )) 
         
         Code.S = Code.S + Space.S + "Case "+Window.S+#CRLF$
         Code.S = Code.S + Space.S + "  Select " + WaitWindowEvent.S + #CRLF$
         
         For II = 1 To CountString( Events.S, "|") + (1)
            Event.S = Trim( StringField( Events.S, II, "|" ))
            
            Code.S = Code.S + Space.S + "    Case " + Event.S + #CRLF$
            For III = 1 To CountString( Functions.S, "|") + (1)
               If II = III
                  Function.S = Trim( StringField( Functions.S, III, "|" ))
                  
                  If Function.S
                     Code.S = Code.S + Space.S + "      " + Function.S + #CRLF$
                     Code.S = Code.S + Space.S + "      " + #CRLF$
                  EndIf
               EndIf
            Next
            
         Next
         
         Code.S = Code.S + Space.S + "  EndSelect " + #CRLF$
         Code.S = Code.S + Space.S + "  " + #CRLF$
      Next
      
      ProcedureReturn Code.S
   EndProcedure
   
   Procedure.S Code_BindEvent( Indent, Events.S, Windows.S ) ; Events.S = "#PB_Event_ActivateWindow|#PB_Event_DeactivateWindow" ; Windows.S = "Window_0|Window_1"
      Protected Space.S = Space( Indent )
      Protected I, II, Window.S, Code.S, Event.S
      ;Windows.S = "" ; Если нет окон 
      Windows.S = Trim(Windows.S, "|")
      Events.S = Trim(Events.S, "|")
      ;Functions.S = Trim(Functions.S, "|")
      
      
      For I = 1 To CountString( Windows.S, "|") + (1)
         Window.S = Trim( StringField( Windows.S, I, "|" )) 
         
         For II = (1) To CountString( Events.S, "|" ) + (1)
            Event.S = Trim( StringField( Events.S, II, "|" )) 
            
            If Window.S 
               Code.S = Code.S + Space.S + "BindEvent( " + Event.S + ", @" + Trim( Window.S, "#" ) + RemoveString( Event.S, "#PB_Event" ) + "_Event(), " + Window.S + " )"+#CRLF$
            Else
               Code.S = Code.S + Space.S + "BindEvent( " + Event.S + ", @All" + RemoveString( Event.S, "#PB_Event" ) + "_Event() )"+#CRLF$
            EndIf
         Next
      Next
      
      ProcedureReturn Code.S
   EndProcedure
   
   Procedure.S Code_Event_Procedure( Indent, Windows.S, Events.S, Functions.S )
      Protected Window.S, Code.S, Event.S, Space.S = Space( Indent )
      Protected I, II, III, Function.S
      
      Windows.S = Trim(Windows.S, "|")
      Events.S = Trim(Events.S, "|")
      Functions.S = Trim(Functions.S, "|")
      
      For I = 1 To CountString( Windows.S, "|") + (1)
         Window.S = Trim( StringField( Windows.S, I, "|" )) 
         
         For II = 1 To CountString( Events.S, "|") + (1)
            Event.S = Trim( StringField( Events.S, II, "|" ))
            Code.S = Code.S + Space.S + "Procedure " + Trim( Window.S, "#" ) + RemoveString( Event, "#PB_Event" ) + "_Event( )"+#CRLF$
            
            Code.S = Code.S + Space.S + "  Protected Window = EventWindow( )"+#CRLF$
            Select Event.S
               Case "#PB_Event_MoveWindow"
                  Code.S = Code.S + Space.S + "  Protected X = WindowX( Window )"+#CRLF$ 
                  Code.S = Code.S + Space.S + "  Protected Y = WindowY( Window )"+#CRLF$
                  
               Case "#PB_Event_SizeWindow"
                  Code.S = Code.S + Space.S + "  Protected Width = WindowWidth( Window )"+#CRLF$ 
                  Code.S = Code.S + Space.S + "  Protected Height = WindowHeight( Window )"+#CRLF$
                  
               Case "#PB_Event_Gadget"
                  Code.S = Code.S + Space.S + "  Protected Gadget = EventGadget( )"+#CRLF$ 
                  Code.S = Code.S + Space.S + "  Protected Type = EventType( )"+#CRLF$
                  
               Case "#PB_Event_Menu"
                  Code.S = Code.S + Space.S + "  Protected Menu = EventMenu( )"+#CRLF$ 
                  
            EndSelect
            
            For III = 1 To CountString( Functions.S, "|") + (1)
               If II = III
                  Function.S = Trim( StringField( Functions.S, III, "|" ))
                  
                  If Function.S
                     Code.S = Code.S + Space.S + "    " + Function.S + #CRLF$
                     Code.S = Code.S + Space.S + "    " + #CRLF$
                  EndIf
               EndIf
            Next
            
            Code.S = Code.S + Space.S + "  "+#CRLF$
            Code.S = Code.S + Space.S + "EndProcedure "+#CRLF$
            Code.S = Code.S + Space.S + ""+#CRLF$
         Next
      Next
      
      ProcedureReturn Code.S
   EndProcedure
   
EndModule

Procedure.S Add(Events.S, Text.S, Index)
   Protected Code.S
   Protected I
   For I = 1 To CountString( Events.S, "|") + (1)
      If I = Index
         Code.S = Code.S + Text.S + "|"
      Else
         Code.S = Code.S + "|"
      EndIf
      
   Next
   ProcedureReturn Code.S
EndProcedure

Procedure.S Function(Events.S, Texts.S, Type.S)
   Protected I, II, Text.S, Code.S
   
   ;   For I = 1 To CountString( Texts.S, "|") + (1)
   ;   ;  Text.S = Text.S + Trim( StringField( Texts.S, I, "|" )) + #CRLF$
   ;   Next
   Text.S = Texts.S
   For II = 1 To CountString( Events.S, "|") + (1)
      If Trim( StringField( Events.S, II, "|" )) = Trim(Type.S)
         Code.S = Code.S + Text.S + "|"
      Else
         Code.S = Code.S + "|"
      EndIf
   Next
   
   ProcedureReturn Code.S
EndProcedure



CompilerIf #PB_Compiler_IsMainFile
   
   Define Types.S = "#PB_EventType_LeftClick = CloseWindow( #Form_0 ) | "+
                    "#PB_EventType_Change = UpdateList( ) | "+
                    "#PB_EventType_LostFocus = CallFunc1()/CallFunc2()/CallFunc3()"
   
   Define Gadgets.S = "?#Form_0_Button_0\#PB_EventType_LeftClick = CloseWindow( #Form_0 )"+
                      "?#Form_0_String_0\#PB_EventType_Change = UpdateList( ) | #PB_EventType_LostFocus = CallFunc1()/CallFunc2()/CallFunc3()"
   
   ;Debug Code::Code_EventType( Indent, Types.S)
   ;Debug Code::Code_EventGadget( Indent, Gadgets.S)
   ;Debug Code::Code_BindGadgetEvent_Procedure( Indent, "Window", Gadgets.S )
   ;Debug Code::Code_BindGadgetEvent_Procedure( Indent, "#Form_0_Button_0", Types.S )
   
   ;Debug Code::Code_Event_Procedure( Gadgets.S, Types.S )
   
   ;Gadgets.S = "?#Form_0_Button_0\#PB_EventType_LeftClick = CloseWindow( #Form_0 )"
   ;Debug Code::Code_BindGadgetEvent(  0, Gadgets.S )
   
   ;{ -Windows.S
   Define Windows.S = "#Form_0|"+
                      "#Form_1|"+
                      "#Form_2"
   ;}
   
   ;{ -Events.S            
   Define Events.S = "#PB_Event_CloseWindow|"+
                     "#PB_Event_ActivateWindow|"+
                     "#PB_Event_DeactivateWindow|"+
                     "#PB_Event_Repaint|"+
                     "#PB_Event_SizeWindow|"+
                     "#PB_Event_MoveWindow|"+
                     "#PB_Event_LeftClick|"+
                     ;            "#PB_Event_RightClick|"+
                     ;            "#PB_Event_LeftDoubleClick|"+
                     ;            "#PB_Event_MinimizeWindow|"+
                     ;            "#PB_Event_MaximizeWindow|"+
                     ;            "#PB_Event_RestoreWindow|"+
                     ;            "#PB_Event_Timer|"+
                     ;            "#PB_Event_SysTray|"+
                     ;            "#PB_Event_WindowDrop|"+
                     ;            "#PB_Event_Menu|"+
                     ;            "#PB_Event_Gadget|"+ 
   "#PB_Event_GadgetDrop" 
   ;}
   
   ;{ -Function.S
   Define Function.S = "CloseWindow( #Form_0 )|"+
                       "|"+
                       "|"+
                       "|"+
                       "|"+
                       "|"+
                       "CreateMenu( #Form_0 )|"
   ;}
   
   ;Demo
   ;Debug Code::Code_BindEvent(0, Events.S, Windows.S)
   ;Debug Code::Code_Event(0, Windows.S, Events.S, Function.S)
   ;Debug Code::Code_Event_Procedure(0, Windows.S, Events.S, Function.S)
CompilerEndIf


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 401
; FirstLine = 340
; Folding = -------
; EnableXP
; DPIAware