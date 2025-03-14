;- Code
EnableExplicit

DeclareModule Code
   EnableExplicit
   
   Declare.S GenerateEventType( Indent, Types.S )
   Declare.S GenerateEventGadget( Indent, Types.S )
   Declare.S GenerateBindGadgetEvent( Indent, StringS.S, Mode = 1)
   Declare.S GenerateBindGadgetEventProcedure( Indent, ProcedureName.S, Gadgets.S, Types.S = "")
   
   Declare.S GenerateEvent( Indent, Names$, Events$, Functions$, WaitWindowEvent$ = "Event" )
   Declare.S GenerateBindEvent( Indent, Events$, Names$ )
   Declare.S GenerateBindEventProcedure( Indent, Names$, Events$, Functions$ )
   
EndDeclareModule

Module Code
   
   Procedure.S GenerateEvent( Indent, Names$, Events$, Functions$, WaitWindowEvent$ = "Event" )
      Protected Name$, Result$, Event$, Space$ = Space( Indent )
      Protected I, II, III, Function$
      
      Names$ = Trim(Names$, "|")
      Events$ = Trim(Events$, "|")
      Functions$ = Trim(Functions$, "|")
      
      
      For I = 1 To CountString( Names$, "|") + (1)
         Name$ = Trim( StringField( Names$, I, "|" )) 
         
         Result$ + Space$ + "Case "+Name$+#CRLF$
         Result$ + Space$ + "  Select " + WaitWindowEvent$ + #CRLF$
         
         For II = 1 To CountString( Events$, "|") + (1)
            Event$ = Trim( StringField( Events$, II, "|" ))
            
            Result$ + Space$ + "    Case " + Event$ + #CRLF$
            For III = 1 To CountString( Functions$, "|") + (1)
               If II = III
                  Function$ = Trim( StringField( Functions$, III, "|" ))
                  
                  If Function$
                     Result$ + Space$ + "      " + Function$ + #CRLF$
                     Result$ + Space$ + "      " + #CRLF$
                  EndIf
               EndIf
            Next
            
         Next
         
         Result$ + Space$ + "  EndSelect " + #CRLF$
         Result$ + Space$ + "  " + #CRLF$
      Next
      
      ProcedureReturn Result$
   EndProcedure
   
   Procedure.S GenerateEventType( Indent, Types.S ) ; Ok
      Protected Includes.S, Include.S, EventType.S, Type.S, II, I, Result$, CountType = CountString( Types.S, "|" ) + (1)
      
      If Types.S And CountType
         Result$ + Space( Indent ) + "Select EventType( )" + #CRLF$
         ;EndIf
         
         For I = (1) To CountType
            Type.S = Trim( StringField( Types.S, I, "|" ))
            
            If Type.S 
               EventType.S = Trim(Mid( Type.S, (1), FindString( Type.S, "=" )-(1)))
               
               If EventType.S 
                  Result$ + Space( Indent ) + Space( 2 ) + "Case " + EventType.S + #CRLF$ ;
                  
                  Includes.S = Trim(Mid( Type.S, FindString( Type.S, "=" )+(1)))
                  
                  For II = (1) To CountString( Includes.S, "/" ) + (1)
                     Include.S = Trim( StringField( Includes.S, II, "/" ))
                     If Include.S 
                        Result$ + Space( Indent ) + Space( 4 ) + Include.S + #CRLF$
                     EndIf
                  Next
                  
               Else
                  Result$ + Space( Indent ) + Space( 2 ) + "Case " + Type.S + #CRLF$ ;
               EndIf
               
               Result$ + Space( Indent ) + Space( 4 ) + #CRLF$
            EndIf
         Next
         
         ;If Types.S And CountType
         Result$ + Space( Indent ) + "EndSelect" + #CRLF$
      EndIf
      
      ProcedureReturn Result$
   EndProcedure
   
   Procedure.S GenerateEventGadget( Indent, Types.S ) ; Ok
      Protected I, Gadget.S, Type.S, Gadgets.S, Result$, CountType = CountString( Types.S, "?" ) + (1)
      
      If Types.S And CountType
         ;If Types.S And CountType
         Result$ + Space( Indent ) + "Select EventGadget( )" + #CRLF$
         ;EndIf
         
         For I = (1) To CountType
            Gadgets.S = Trim( StringField( Types.S, I, "?" ))
            
            If Gadgets.S 
               Gadget.S = Trim(Mid( Gadgets.S, (1), FindString( Gadgets.S, "\" )-(1)))
               
               If Gadget.S
                  Result$ + Space( Indent + ( 2 ) ) + "Case " + Gadget.S + #CRLF$ 
                  
                  Type.S = Trim(Mid( Gadgets.S, FindString( Gadgets.S, "\" )+(1)))
                  Result$ + GenerateEventType( Indent + ( 4 ), Type.S) + #CRLF$ 
               Else
                  Result$ + Space( Indent + ( 2 ) ) + "Case " + Gadgets.S + #CRLF$ 
               EndIf
               
            EndIf
         Next
         
         ;If Types.S And CountType
         Result$ + Space( Indent ) + "EndSelect" + #CRLF$
         ;EndIf
      EndIf
      
      ProcedureReturn Result$
   EndProcedure
   
   
   ;-
   Procedure.S GenerateBindEvent( Indent, Events$, Names$ ) 
      ; Name$ = "Window_0|Window_1"
      ; Events$ = "#PB_Event_ActivateWindow|#PB_Event_DeactivateWindow"  
      ; Names$ = "" ; проверка если нет окон 
      Protected Space$ = Space( Indent )
      Protected I, II, Name.S, Result$, Event$, CountNames, CountEvents
      ;
      Names$ = Trim(Names$, "|")
      Events$ = Trim(Events$, "|")
      CountNames = CountString( Names$, "|" ) + (1)
      CountEvents = CountString( Events$, "|" ) + (1)
      ;
      For I = (1) To CountNames
         Name = Trim( StringField( Names$, I, "|" )) 
         ;
         For II = (1) To CountEvents
            Event$ = Trim( StringField( Events$, II, "|" )) 
            
            If Name
               Result$ + Space$ + "BindEvent( " + Event$ + ", @" + Trim( Name, "#" ) + RemoveString( Event$, "#PB_Event" ) + "_Event( ), " + Name + " )"+#CRLF$
            Else
               Result$ + Space$ + "BindEvent( " + Event$ + ", @ALL" + RemoveString( Event$, "#PB_Event" ) + "_Event( ))"+#CRLF$
            EndIf
         Next
      Next
      ;
      ProcedureReturn Result$
   EndProcedure
   
   Procedure.S GenerateBindEventProcedure( Indent, Names$, Events$, Functions$ )
      Protected Name$, Result$, Event$, Space$ = Space( Indent )
      Protected I, II, III, Function$
      
      Names$ = Trim(Names$, "|")
      Events$ = Trim(Events$, "|")
      Functions$ = Trim(Functions$, "|")
      
      For I = 1 To CountString( Names$, "|") + (1)
         Name$ = Trim( StringField( Names$, I, "|" )) 
         
         For II = 1 To CountString( Events$, "|") + (1)
            Event$ = Trim( StringField( Events$, II, "|" ))
            Result$ + Space$ + "Procedure " + Trim( Name$, "#" ) + RemoveString( Event$, "#PB_Event" ) + "_Event( )"+#CRLF$
            
            Result$ + Space$ + "  Protected Window = EventWindow( )"+#CRLF$
            Select Event$
               Case "#PB_Event_MoveWindow"
                  Result$ + Space$ + "  Protected X = WindowX( Window )"+#CRLF$ 
                  Result$ + Space$ + "  Protected Y = WindowY( Window )"+#CRLF$
                  
               Case "#PB_Event_SizeWindow"
                  Result$ + Space$ + "  Protected Width = WindowWidth( Window )"+#CRLF$ 
                  Result$ + Space$ + "  Protected Height = WindowHeight( Window )"+#CRLF$
                  
               Case "#PB_Event_Gadget"
                  Result$ + Space$ + "  Protected Gadget = EventGadget( )"+#CRLF$ 
                  Result$ + Space$ + "  Protected Type = EventType( )"+#CRLF$
                  
               Case "#PB_Event_Menu"
                  Result$ + Space$ + "  Protected Menu = EventMenu( )"+#CRLF$ 
                  
            EndSelect
            
            For III = 1 To CountString( Functions$, "|") + (1)
               If II = III
                  Function$ = Trim( StringField( Functions$, III, "|" ))
                  
                  If Function$
                     Result$ + Space$ + "    " + Function$ + #CRLF$
                     Result$ + Space$ + "    " + #CRLF$
                  EndIf
               EndIf
            Next
            
            Result$ + Space$ + "  "+#CRLF$
            Result$ + Space$ + "EndProcedure "+#CRLF$
            Result$ + Space$ + ""+#CRLF$
         Next
      Next
      
      ProcedureReturn Result$
   EndProcedure
   ;-
   Procedure.S GenerateBindGadgetEvent( Indent, StringS.S, Mode = 1) ; Ok
      Protected II, String.S, EventType.S, Gadget.S, Type.S, I, Result$
      If StringS.S
         For I = (1) To CountString( StringS.S, "?" ) + (1)
            String.S = Trim( StringField( StringS.S, I, "?" ))
            
            If String.S 
               Gadget.S = Trim(Mid( String.S, (1), FindString( String.S, "\" )-(1)))
               
               If Gadget.S = ""
                  Result$ + Space( Indent ) + "BindGadgetEvent( " + String.S + ", @" + Trim( String.S, "#" ) + "_Event( ) )" + #CRLF$
               Else
                  If Mode
                     For II = (1) To CountString( String.S, "|" ) + (1)
                        EventType.S = Trim( StringField( String.S, II, "|" ))
                        EventType.S = Trim(Mid( EventType.S, (1), FindString( EventType.S, "=" )-(1)))
                        EventType.S = Trim(Mid( EventType.S, FindString( EventType.S, "\" )+(1)))
                        
                        Result$ + Space( Indent ) + "BindGadgetEvent( " + Gadget.S + ", @" + Trim( Gadget.S, "#" ) + "_Event" + RemoveString(EventType.S,"#PB_EventType") + "( ), "+EventType.S+" )" + #CRLF$
                     Next
                  Else
                     Type.S = ""
                     For II = (1) To CountString( String.S, "|" ) + (1)
                        EventType.S = Trim( StringField( String.S, II, "|" ))
                        EventType.S = Trim(Mid( EventType.S, (1), FindString( EventType.S, "=" )-(1)))
                        EventType.S = Trim(Mid( EventType.S, FindString( EventType.S, "\" )+(1)))
                        Type.S = Trim( Type.S +"|"+ EventType.S, "|")
                     Next
                     
                     Result$ + Space( Indent ) + "BindGadgetEvent( " + Gadget.S + ", @" + Trim( Gadget.S, "#" ) + "_Event( ), "+Type.S+" )" + #CRLF$
                  EndIf
               EndIf
            EndIf
         Next
         
      Else
         
      EndIf
      
      
      ProcedureReturn Result$
   EndProcedure
   
   Procedure.S GenerateBindGadgetEventProcedure( Indent, ProcedureName.S, Gadgets.S, Types.S = "") ; Ok
      Protected Result$
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
         
         Result$ = Space( Indent ) + "Procedure" + ProcedureName.S + #CRLF$
         Indent = Indent  +  ( 2 )
      EndIf
      
      If Gadgets.S
         Result$ + GenerateEventGadget( Indent, Gadgets.S )
      Else
         Result$ + GenerateEventType( Indent, Types.S )
      EndIf
      
      If ProcedureName.S
         Indent = Indent  -  ( 2 )
         Result$ + Space( Indent ) + "EndProcedure" + #CRLF$
      EndIf
      
      ProcedureReturn Result$
   EndProcedure
   
EndModule


;-
Procedure.S Add(Events$, Text.S, Index)
   Protected Result$
   Protected I
   For I = 1 To CountString( Events$, "|") + (1)
      If I = Index
         Result$ + Text.S + "|"
      Else
         Result$ + "|"
      EndIf
      
   Next
   ProcedureReturn Result$
EndProcedure

Procedure.S Function(Events$, Texts.S, Type.S)
   Protected I, II, Text.S, Result$
   
   ;   For I = 1 To CountString( Texts.S, "|") + (1)
   ;   ;  Text.S = Text.S + Trim( StringField( Texts.S, I, "|" )) + #CRLF$
   ;   Next
   Text.S = Texts.S
   For II = 1 To CountString( Events$, "|") + (1)
      If Trim( StringField( Events$, II, "|" )) = Trim(Type.S)
         Result$ + Text.S + "|"
      Else
         Result$ + "|"
      EndIf
   Next
   
   ProcedureReturn Result$
EndProcedure



CompilerIf #PB_Compiler_IsMainFile
   Define Indent = 0
   
   Define Types.S = "#PB_EventType_LeftClick = CloseWindow( #Form_0 ) | "+
                    "#PB_EventType_Change = UpdateList( ) | "+
                    "#PB_EventType_LostFocus = CallFunc1()/CallFunc2()/CallFunc3()"
   ; demo
   ;Debug Code::GenerateEventType( Indent, Types.S)
   ;Debug Code::GenerateBindGadgetEventProcedure( Indent, "#Form_0_Button_0", Types.S )
   
   Define Mask$ = "?#Form_0_Button_0\#PB_EventType_LeftClick = CloseWindow( #Form_0 )"+
                  "?#Form_0_String_0\#PB_EventType_Change = UpdateList( ) | #PB_EventType_LostFocus = CallFunc1()/CallFunc2()/CallFunc3()"
   
   ; demo
   ;Debug Code::GenerateEventGadget( Indent, Mask$)
   Debug Code::GenerateBindGadgetEvent(  0, Mask$ )
   ;Debug Code::GenerateBindGadgetEventProcedure( Indent, "WINDOW", Mask$ )
   
   ;{ -Names$
   Define Names$ = "#Form_0|"+
                   "#Form_1|"+
                   "#Form_2"
   ;}
   
   ;{ -Events$            
   Define Events$ = "#PB_Event_CloseWindow|"+
                    "#PB_Event_ActivateWindow|"+
                    "#PB_Event_DeactivateWindow|"+
                    ;"#PB_Event_Repaint|"+
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
   
   ;{ -Functions$
   Define Functions$ = "CloseWindow( #Form_0 )|"+
                       "|"+
                       "|"+
                       "|"+
                       "|"+
                       "|"+
                       "CreateMenu( #Form_0 )|"
   ;}
   
   ;Demo
   ;Debug Code::GenerateBindEvent(0, Events$, Names$)
   ;Debug Code::GenerateEvent(0, Names$, Events$, Functions$)
   ;Debug Code::GenerateBindEventProcedure(0, Names$, Events$, Functions$)
CompilerEndIf


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 288
; FirstLine = 283
; Folding = -------
; EnableXP
; DPIAware