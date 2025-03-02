Procedure$  _MakeFuncString( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
   Protected i, chr$, start, stop
   Protected pos = FindString( string$, "=" )
   
   If pos
      string$ = Mid( string$, pos + 1, len - pos )
   EndIf
   
   For i = 1 To len
      chr$ = Mid( string$, i, 1 )
      If chr$ = "(" 
         stop = i - 1
         ;Debug Mid( string$, start, stop )
         If *start
            *start\i = pos + 1 + start
         EndIf
         If *stop
            *stop\i = stop
         EndIf
         If Not stop
            ProcedureReturn " "
         Else
            Define str$ = Mid( string$, start, stop )
            If FindString( str$, " " )
               len = stop
               For i = len To 0 Step - 1
                  chr$ = Mid( string$, i, 1 )
                  If chr$ = " "
                     start = i + 1
                     stop - i
                     If *start
                        *start\i = pos + start
                     EndIf
                     If *stop
                        *stop\i = stop
                     EndIf
                     ProcedureReturn Mid( string$, start, stop )
                     Break
                  EndIf
               Next i
            Else
               ProcedureReturn str$
            EndIf
         EndIf 
         Break
      EndIf
   Next i
   
EndProcedure


Procedure$  MakeFuncString( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
   Protected i, chr$, start, stop
   Protected space, pos = FindString( string$, "=" )
   
   If pos
      If pos > FindString( string$, "(" )
         pos = 0
      Else
         string$ = Mid( string$, pos + 1, len - pos )
      EndIf
   Else
      pos = FindString( string$, ":" )
      If pos
         string$ = StringField( string$, 2, ":" )
      EndIf
   EndIf
   
   For i = 1 To len
      If Mid( string$, i, 1 ) = "(" 
         stop = i - 1
         Define str$ = Mid( string$, start, stop )
         result$ = Trim( str$ )
         space = FindString( str$, result$ )
         
         If space 
            start + space
            stop - space
         EndIf
         
         If *start
            *start\i = pos + start
         EndIf
         If *stop
            *stop\i = stop + 1
         EndIf
         ProcedureReturn result$
         

;          result$ = Mid( string$, start, stop )
         Break
      EndIf
   Next i
   
   ProcedureReturn result$
EndProcedure

text$ = "Window_0=OpenWindow(#PB_Any, 0, 0, 200, 200, "+Chr('"')+"window_1=sds"+Chr('"')+ ")"
text$ = "Window_0= OpenWindow(#PB_Any, 0, 0, 200, 200, "+Chr('"')+"window_1=sds"+Chr('"')+ ")"
text$ = "Window_0=OpenWindow (#PB_Any, 0, 0, 200, 200, "+Chr('"')+"window_1=sds"+Chr('"')+ ")"
text$ = "Window_0= OpenWindow (#PB_Any, 0, 0, 200, 200, "+Chr('"')+"window_1=sds"+Chr('"')+ ")"
text$ = "OpenWindow (#PB_Any, 0, 0, 200, 200, "+Chr('"')+"window_1=sds"+Chr('"')+ ")"
text$ = " OpenWindow(#PB_Any, 0, 0, 200, 200, "+Chr('"')+"window_1=sds"+Chr('"')+ ")"
text$ = " OpenWindow (#PB_Any, 0, 0, 200, 200, "+Chr('"')+"window_1=sds"+Chr('"')+ ")"
text$ = "IMAGE_VIEW = ContainerGadget( #PB_Any, 7, 7, 253, 218, #PB_Container_Flat ) : CloseGadgetList( )"
text$ = " : CloseGadgetList( )"

Define start
Define stop
Debug MakeFuncString( text$, Len(text$), @start,@stop)
Debug "-------"
Debug Mid( text$, start, stop )

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 51
; FirstLine = 11
; Folding = ----
; EnableXP
; DPIAware