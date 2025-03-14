﻿;- GLOBALs
Global line_break1
Global pb_object$ = "";"Gadget"

;
;- INCLUDEs
CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "ide.pb"
CompilerEndIf
XIncludeFile "include/code/parser.pbi"
XIncludeFile "include/code/generate.pbi"

;
;- USES
UseWidgets( )


Global parentlevel 
Global codeindent = 3
;
;- PUBLICs
;
Procedure.s GetClassString( Element )
   
   ProcedureReturn ClassFromType( Type(Element) )
   ;ProcedureReturn StringField( GetClass(Element), 1, "_" )
   ;ProcedureReturn ULCase(StringField( GetClass(Element), 1, "_" ))
   
EndProcedure

Procedure.s GetFlagsString( Element )
   
   ProcedureReturn Trim( FlagsString( Str( Element ) ), "|" )
   
EndProcedure

Procedure SetFlagsString( Element, Flags$ )
   
   If Not FindMapElement( FlagsString( ), Str( Element ) )
      AddMapElement( FlagsString( ), Str( Element ) )
   EndIf
   
   If Flags$
      If Not FindString( FlagsString( ), LCase( Flags$ ), - 1, #PB_String_NoCase )
         FlagsString( ) + "|" + Flags$
      EndIf
   Else
      FlagsString( ) = ""
   EndIf
   
EndProcedure

Procedure.s GetEventsString( Element )
   
   ProcedureReturn Trim( EventsString( Str( Element ) ), "|" )
   
EndProcedure

Procedure SetEventsString( Element, Events$ )
   
   If Not FindMapElement( EventsString( ), Str( Element ) )
      AddMapElement( EventsString( ), Str( Element ) )
   EndIf
   
   If Events$
      If Not FindString( EventsString( ), LCase( Events$ ), - 1, #PB_String_NoCase )
         EventsString( ) + "|" + Events$
      EndIf
   Else
      EventsString( ) = ""
   EndIf
   
EndProcedure

;-
Procedure$  GetLine( text$, len, caret )
   Protected i, chr$, start, stop 
   
   For i = caret To 0 Step - 1
      chr$ = Mid( text$, i, 1 )
      If chr$ = #LF$ 
         start = i + 1
         Break
      EndIf
   Next i
   
   For i = caret + 1 To len 
      chr$ = Mid( text$, i, 1 )
      If chr$ = #LF$
         stop = i - start
         Break
      EndIf
   Next i
   
   If stop = 0
      ProcedureReturn #LF$
   Else
      ; Debug ""+ start +" "+ stop
      ProcedureReturn Mid( text$, start, stop )
   EndIf
EndProcedure

Procedure$  GetQuote( text$, len, caret ) ; Ok
   Protected i, chr$, start, stop 
   
   For i = caret To 0 Step - 1
      chr$ = Mid( text$, i, 1 )
      If chr$ = ~"\"" 
         start = i
         
         For i = caret + 1 To len 
            chr$ = Mid( text$, i, 1 )
            If chr$ = ~"\""
               stop = i - start + 1
               Break 2
            EndIf
         Next i
         
         Break
      EndIf
   Next i
   
   If stop 
      ; Debug #PB_Compiler_Procedure +" ["+ start +" "+ stop +"]"
      ProcedureReturn Mid( text$, start, stop )
   EndIf
EndProcedure

Procedure$  GetWord( text$, len, caret ) ; Ok
   Protected i, chr$, start = 0, stop = len
   
   chr$ = GetQuote( text$, len, caret ) 
   If chr$
      ProcedureReturn chr$
   EndIf
   
   For i = caret To 0 Step - 1
      chr$ = Mid( text$, i, 1 )
      If chr$ = " " Or 
         chr$ = "(" Or 
         chr$ = "[" Or 
         chr$ = "{" Or 
         chr$ = ")" Or 
         chr$ = "]" Or 
         chr$ = "}" Or 
         chr$ = "=" Or 
         chr$ = "'" Or 
         ; chr$ = ~"\"" Or 
         chr$ = "+" Or 
chr$ = "-" Or 
chr$ = "*" Or 
chr$ = "/" Or 
chr$ = "." Or 
chr$ = ","
         start = i + 1
         Break
      EndIf
   Next i
   
   For i = caret + 1 To len 
      chr$ = Mid( text$, i, 1 )
      If chr$ = " " Or 
         chr$ = ")" Or 
         chr$ = "]" Or 
         chr$ = "}" Or 
         chr$ = "(" Or 
         chr$ = "[" Or 
         chr$ = "{" Or 
         chr$ = "=" Or 
         chr$ = "'" Or 
         ; chr$ = ~"\"" Or
         chr$ = "+" Or 
chr$ = "-" Or 
chr$ = "*" Or 
chr$ = "/" Or 
chr$ = "." Or 
chr$ = "," 
         stop = i - start 
         Break
      EndIf
   Next i
   
   If stop
      ; Debug #PB_Compiler_Procedure +" ["+ start +" "+ stop +"]"
      ProcedureReturn Mid( text$, start, stop )
   EndIf
EndProcedure

Procedure$  FindFunctions( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
   Protected i, chr$, start, stop, spacecount
   
   For i = len To 0 Step - 1
      chr$ =  Mid( string$, i, 1 )
      If chr$ = " "
         spacecount + 1
      Else
         Break
      EndIf
   Next i
   
   For i = len - spacecount To 0 Step - 1
      chr$ =  Mid( string$, i, 1 )
      If chr$ = " "
         start = i + 1
         If *start
            *start\i = start
         EndIf
         stop = len - i - spacecount
         If *stop
            *stop\i = stop
         EndIf
         ProcedureReturn Mid( string$, start, stop )
         Break
      EndIf
   Next i
   
EndProcedure

Procedure$  FindArguments( string$, len, *start.Integer = 0, *stop.Integer = 0 ) 
   Protected i, chr$, start, stop 
   
   For i = 0 To len
      chr$ = Mid( string$, i, 1 )
      If chr$ = "(" 
         start = i + 1
         For i = len To start Step - 1
            chr$ = Mid( string$, i, 1 )
            If chr$ = ")" 
               stop = i - start ; + 1
               If *start
                  *start\i = start
               EndIf
               If *stop
                  *stop\i = stop
               EndIf
               If Not stop
                  ProcedureReturn " "
               Else
                  ProcedureReturn Mid( string$, start, stop )
               EndIf
               Break
            EndIf
         Next i
         
         Break
      EndIf
   Next i
EndProcedure

Procedure$  GetArgLine( text$, len, caret, mode.a = 0 ) 
   Protected i, chr$, start = - 1, stop 
   
   For i = caret To 0 Step - 1
      chr$ = Mid( text$, i, 1 )
      If chr$ = "(" 
         start = i
         Break
      EndIf
   Next i
   
   For i = caret + 1 To len 
      chr$ = Mid( text$, i, 1 )
      If chr$ = ")"
         stop = i - start + 1
         Break
      EndIf
   Next i
   
   If mode
      If start = - 1 
         If stop 
            For i = len To 0 Step - 1
               chr$ = Mid( text$, i, 1 )
               If chr$ = "(" 
                  start = i
                  stop - start - 1
                  Break
               EndIf
            Next i
         EndIf
      EndIf  
   EndIf
   
   If start = - 1 Or stop = 0
      ProcedureReturn ""
   Else
      ; Debug #PB_Compiler_Procedure +" ["+ start +" "+ stop +"]"
      ProcedureReturn Mid( text$, start, stop )
   EndIf
EndProcedure

Procedure   GetArgIndex( text$, len, caret, mode.a = 0 ) 
   Protected i, chr$, start = - 1, stop 
   
   For i = caret To 0 Step - 1
      chr$ = Mid( text$, i, 1 )
      If chr$ = "(" 
         start = i
         Break
      EndIf
   Next i
   
   For i = caret + 1 To len 
      chr$ = Mid( text$, i, 1 )
      If chr$ = ")"
         stop = i - start + 1
         Break
      EndIf
   Next i
   
   If mode
      If start = - 1 
         If stop 
            For i = len To 0 Step - 1
               chr$ = Mid( text$, i, 1 )
               If chr$ = "(" 
                  start = i
                  stop - start - 1
                  Break
               EndIf
            Next i
         EndIf
      EndIf  
   EndIf
   
   If start = - 1 Or stop = 0
      ProcedureReturn 0
   Else
      ProcedureReturn CountString( Left( Mid( text$, start, stop ), caret - start ), "," ) + 1
   EndIf
EndProcedure

;-
Procedure NumericString( string$ )
   Select Asc( string$ )
      Case '0' To '9'
         ProcedureReturn #True
   EndSelect
EndProcedure

;-
Procedure$ Code_GenerateStates( *g._s_WIDGET, Space$ )
   Protected result$
   ;ProcedureReturn ""
   
   ;
   If line_break1 = 1
      line_break1 = 0
      If Not is_window_( *g )
         result$ + space$ + #LF$
      EndIf
   EndIf
   
   If pb_object$ = "Gadget" Or 
      pb_object$ = "Window"
      ;
      If is_window_(*g)
         pb_object$ = "Window"
      Else
         pb_object$ = "Gadget"
      EndIf
   EndIf
   ;
   If *g\ChangeFont
      result$ + Space$ + "Set" + pb_object$ + "Font( " + GetClass( *g ) + ", ("+ Str( *g\text\font ) +") )" + #LF$
      line_break1 = 1
   EndIf            
   
   If *g\ChangeColor 
      If is_window_(*g) 
         If pb_object$
            result$ + Space$ + "Set" + pb_object$ + "Color( " + GetClass( *g ) + ", $"+ Hex( *g\color\back & $ffffff ) +" )" + #LF$
         Else
            result$ + Space$ + "SetBackgroundColor( " + GetClass( *g ) + ", $"+ Hex( *g\color\back & $ffffff ) +" )" + #LF$
         EndIf
      Else
         result$ + Space$ + "Set" + pb_object$ + "Color( " + GetClass( *g ) + ", #PB_Gadget_BackColor, $"+ Hex( *g\color\back & $ffffff ) +" )" + #LF$
      EndIf
      line_break1 = 1
   EndIf            
   ;
   If GetState(*g) > 0
      line_break1 = 1
      result$ + Space$ + "Set" + pb_object$ + "State( " + GetClass( *g ) + ", "+ GetState(*g) + " )" + #LF$
   EndIf
   If Disable(*g) > 0
      line_break1 = 1
      result$ + Space$ + "Disable" + pb_object$ + "( " + GetClass( *g ) + ", #True )" + #LF$
   EndIf
   If Hide(*g) > 0
      line_break1 = 1
      result$ + Space$ + "Hide" + pb_object$ + "( " + GetClass( *g ) + ", #True )" + #LF$
   EndIf
   ;
   ProcedureReturn result$
EndProcedure

Procedure$ Code_GeneratePanelItems( *g._s_WIDGET, start, stop, space$ )
   ; Debug " Code_GeneratePanelItems["+start+" "+stop +"]"
   Protected i, result$
   ;
   For i = start To stop
      If i > 0
         result$ + space$ + #LF$
         If line_break1
            line_break1 = 0
         EndIf
      EndIf
      result$ + space$ + "Add" + pb_object$ + "Item( " + GetClass( *g ) + 
                ", - 1" + 
                ", " + Chr( '"' ) + GetItemText( *g, i ) + Chr( '"' ) + 
                " )" + #LF$
   Next
   ;
   ProcedureReturn result$
EndProcedure

Procedure$ Code_GenerateCloseList( *g._s_WIDGET, Space$ )
   Protected result$, Space2$ = Space$ + Space(codeindent)
   
   If IsContainer(*g) > 2
      If *g\tabbar
         If *g\tabbar\countitems
            If *g = *g\LastWidget( )
               result$ + Code_GeneratePanelItems( *g, 0, *g\tabbar\countitems - 1, Space2$ )
            Else
               If *g\LastWidget( )\TabIndex( ) = *g\tabbar\countitems - 1
                  ; result$ + #LF$
               Else
                  result$ + Code_GeneratePanelItems( *g, *g\LastWidget( )\TabIndex( ) + 1, *g\tabbar\countitems - 1, Space2$ )
                  ;  Debug ""+*g\class +" > "+ *g\LastWidget( )\class +" "+ *g\LastWidget( )\TabIndex( ) +" "+ *g\tabbar\countitems
               EndIf
            EndIf
         EndIf
      EndIf
      
      ;
      result$ + Code_GenerateStates( *g, Space2$ )
      
      ;
      result$ + Space$ + "Close" + pb_object$ + "List( ) ; " + GetClass(*g) + #LF$ 
   EndIf
   
   ProcedureReturn result$
EndProcedure


;-
Procedure$  MakeConstantsString( type$, flag.q ) ; 
   Protected result$
   
   Select type$
      Case "Font"
         If flag & #PB_Font_Bold
            result$ + " #PB_Font_Bold |"
         EndIf
         If flag & #PB_Font_Italic
            result$ + " #PB_Font_Italic |"
         EndIf
         If flag & #PB_Font_Underline
            result$ + " #PB_Font_Underline |"
         EndIf
         If flag & #PB_Font_StrikeOut
            result$ + " #PB_Font_StrikeOut |"
         EndIf
         If flag & #PB_Font_HighQuality
            result$ + " #PB_Font_HighQuality |"
         EndIf
         
      Case "Window"
         If flag & #PB_Window_SystemMenu
            flag &~ #PB_Window_SystemMenu
            result$ + " #PB_Window_SystemMenu |"
         EndIf
         If flag & #PB_Window_SizeGadget
            ;flag &~ #PB_Window_SizeGadget
            result$ + " #PB_Window_SizeGadget |"
         EndIf
         If flag & #PB_Window_ScreenCentered
            result$ + " #PB_Window_ScreenCentered |"
         EndIf
         If flag & #PB_Window_Invisible
            result$ + " #PB_Window_Invisible |"
         EndIf
         ;          If flag & #PB_Window_MaximizeGadget
         ;             ;flag &~ #PB_Window_MaximizeGadget
         ;             result$ + " #PB_Window_MaximizeGadget |"
         ;          EndIf
         ;          If flag & #PB_Window_MinimizeGadget
         ;             ;flag &~ #PB_Window_MinimizeGadget
         ;             result$ + " #PB_Window_MinimizeGadget |"
         ;          EndIf
         ;          If flag & #PB_Window_NoActivate = #PB_Window_NoActivate
         ;             result$ + " #PB_Window_NoActivate |"
         ;          EndIf
         If flag & #PB_Window_BorderLess
            result$ + " #PB_Window_BorderLess |"
         EndIf
         If flag & #PB_Window_NoGadgets
            result$ + " #PB_Window_NoGadgets |"
         EndIf
         If flag & #PB_Window_TitleBar = #PB_Window_TitleBar
            result$ + " #PB_Window_TitleBar |"
         EndIf
         If flag & #PB_Window_Tool 
            result$ + " #PB_Window_Tool |"
         EndIf
         If flag & #PB_Window_WindowCentered
            result$ + " #PB_Window_WindowCentered |"
         EndIf
         
      Case "Text"
         If flag & #__Text_Center
            result$ + " #PB_Text_Center |"
         EndIf
         If flag & #__Text_Right
            result$ + " #PB_Button_Right |"
         EndIf
         If flag & #__flag_BorderFlat
            result$ + " #PB_Text_Border |"
         EndIf
         
      Case "Button"
         If flag
            If flag & #PB_Button_Left
               result$ + " #PB_Button_Left |"
            EndIf
            If flag & #PB_Button_Right
               result$ + " #PB_Button_Right |"
            EndIf
            If flag & #PB_Button_MultiLine
               result$ + " #PB_Button_MultiLine |"
            EndIf
            If flag & #PB_Button_Toggle
               result$ + " #PB_Button_Toggle |"
            EndIf
            If flag & #PB_Button_Default
               result$ + " #PB_Button_Default |"
            EndIf
            
            If flag & #__text_Left = #__text_Left
               result$ + " #PB_Button_Left |"
            EndIf
            If flag & #__text_Right = #__text_Right
               result$ + " #PB_Button_Right |"
            EndIf
            If flag & #__flag_TextMultiLine = #__flag_TextMultiLine
               result$ + " #PB_Button_MultiLine |"
            EndIf
            If flag & #__flag_TextWordWrap = #__flag_TextWordWrap
               result$ + " #PB_Button_MultiLine |"
            EndIf
            If flag & #__flag_ButtonToggle = #__flag_ButtonToggle
               result$ + " #PB_Button_Toggle |"
            EndIf
            If flag & #__flag_ButtonDefault = #__flag_ButtonDefault
               result$ + " #PB_Button_Default |"
            EndIf
         EndIf
         
      Case "Container"
         If flag
            If flag & #PB_Container_Flat
               result$ + " #PB_Container_Flat |"
            EndIf
            If flag & #PB_Container_Raised
               result$ + " #PB_Container_Raised |"
            EndIf
            If flag & #PB_Container_Single
               result$ + " #PB_Container_Single |"
            EndIf
            If flag & #PB_Container_BorderLess
               result$ + " #PB_Container_BorderLess |"
            EndIf
            
            If flag & #__flag_BorderFlat = #__flag_BorderFlat
               result$ + " #PB_Container_Flat |"
            EndIf
            If flag & #__flag_BorderRaised = #__flag_BorderRaised
               result$ + " #PB_Container_Raised |"
            EndIf
            If flag & #__flag_BorderSingle = #__flag_BorderSingle
               result$ + " #PB_Container_Single |"
            EndIf
            If flag & #__flag_BorderLess = #__flag_BorderLess
               result$ + " #PB_Container_BorderLess |"
            EndIf
         EndIf
         
      Case "ScrollArea"
         If flag
            If flag & #PB_ScrollArea_Flat
               result$ + " #PB_ScrollArea_Flat |"
            EndIf
            If flag & #PB_ScrollArea_Raised
               result$ + " #PB_ScrollArea_Raised |"
            EndIf
            If flag & #PB_ScrollArea_Single
               result$ + " #PB_ScrollArea_Single |"
            EndIf
            If flag & #PB_ScrollArea_BorderLess
               result$ + " #PB_ScrollArea_BorderLess |"
            EndIf
            If flag & #PB_ScrollArea_Center
               result$ + " #PB_ScrollArea_Center |"
            EndIf
            
            If flag & #__flag_BorderFlat = #__flag_BorderFlat
               result$ + " #PB_ScrollArea_Flat |"
            EndIf
            If flag & #__flag_BorderRaised = #__flag_BorderRaised
               result$ + " #PB_ScrollArea_Raised |"
            EndIf
            If flag & #__flag_BorderSingle = #__flag_BorderSingle
               result$ + " #PB_ScrollArea_Single |"
            EndIf
            If flag & #__flag_BorderLess = #__flag_BorderLess
               result$ + " #PB_ScrollArea_BorderLess |"
            EndIf
            If flag & #__flag_Center = #__flag_Center
               result$ + " #PB_ScrollArea_Center |"
            EndIf
         EndIf
         
      Case "Splitter"
         If flag
            If flag & #PB_Splitter_Vertical
               result$ + " #PB_Splitter_Vertical |"
            EndIf
            If flag & #PB_Splitter_Separator
               result$ + " #PB_Splitter_Separator |"
            EndIf
            If flag & #PB_Splitter_FirstFixed
               result$ + " #PB_Splitter_FirstFixed |"
            EndIf
            If flag & #PB_Splitter_SecondFixed
               result$ + " #PB_Splitter_SecondFixed |"
            EndIf
         EndIf
         
   EndSelect
   
   ProcedureReturn Trim( result$, "|" )
EndProcedure

Procedure.q MakeConstants( string$ )
   Protected i, Flag.q, count, str$
   
   If string$
      count = CountString(string$,"|")
      For I = 0 To count
         str$ = Trim(StringField(string$,(I+1),"|"))
         
         Select str$
            Case "#True"                              : Flag = Flag | #True
            Case "#False"                             : Flag = Flag | #False
            Case "#PB_Gadget_FrontColor"              : Flag = Flag | #PB_Gadget_FrontColor
            Case "#PB_Gadget_BackColor"               : Flag = Flag | #PB_Gadget_BackColor 
            Case "#PB_Gadget_LineColor"               : Flag = Flag | #PB_Gadget_LineColor 
            Case "#PB_Gadget_TitleFrontColor"         : Flag = Flag | #PB_Gadget_TitleFrontColor
            Case "#PB_Gadget_TitleBackColor"          : Flag = Flag | #PB_Gadget_TitleBackColor 
            Case "#PB_Gadget_GrayTextColor"           : Flag = Flag | #PB_Gadget_GrayTextColor 
               ; window
            Case "#PB_Window_BorderLess"              : Flag = Flag | #PB_Window_BorderLess
            Case "#PB_Window_Invisible"               : Flag = Flag | #PB_Window_Invisible
            Case "#PB_Window_Maximize"                : Flag = Flag | #PB_Window_Maximize
            Case "#PB_Window_Minimize"                : Flag = Flag | #PB_Window_Minimize
            Case "#PB_Window_MaximizeGadget"          : Flag = Flag | #PB_Window_MaximizeGadget
            Case "#PB_Window_MinimizeGadget"          : Flag = Flag | #PB_Window_MinimizeGadget
            Case "#PB_Window_NoActivate"              : Flag = Flag | #PB_Window_NoActivate
            Case "#PB_Window_NoGadgets"               : Flag = Flag | #PB_Window_NoGadgets
            Case "#PB_Window_SizeGadget"              : Flag = Flag | #PB_Window_SizeGadget
            Case "#PB_Window_SystemMenu"              : Flag = Flag | #PB_Window_SystemMenu
            Case "#PB_Window_TitleBar"                : Flag = Flag | #PB_Window_TitleBar
            Case "#PB_Window_Tool"                    : Flag = Flag | #PB_Window_Tool
            Case "#PB_Window_ScreenCentered"          : Flag = Flag | #PB_Window_ScreenCentered
            Case "#PB_Window_WindowCentered"          : Flag = Flag | #PB_Window_WindowCentered
               ; buttonimage 
            Case "#PB_Button_Image"                   : Flag = Flag | #PB_Button_Image
            Case "#PB_Button_PressedImage"            : Flag = Flag | #PB_Button_PressedImage
               ; button  
            Case "#PB_Button_Default"                 : Flag = Flag | #PB_Button_Default
            Case "#PB_Button_Left"                    : Flag = Flag | #PB_Button_Left
            Case "#PB_Button_MultiLine"               : Flag = Flag | #PB_Button_MultiLine
            Case "#PB_Button_Right"                   : Flag = Flag | #PB_Button_Right
            Case "#PB_Button_Toggle"                  : Flag = Flag | #PB_Button_Toggle
               ; string
            Case "#PB_String_BorderLess"              : Flag = Flag | #PB_String_BorderLess
            Case "#PB_String_LowerCase"               : Flag = Flag | #PB_String_LowerCase
            Case "#PB_String_MaximumLength"           : Flag = Flag | #PB_String_MaximumLength
            Case "#PB_String_Numeric"                 : Flag = Flag | #PB_String_Numeric
            Case "#PB_String_Password"                : Flag = Flag | #PB_String_Password
            Case "#PB_String_ReadOnly"                : Flag = Flag | #PB_String_ReadOnly
            Case "#PB_String_UpperCase"               : Flag = Flag | #PB_String_UpperCase
               ; text
            Case "#PB_Text_Border"                    : Flag = Flag | #PB_Text_Border
            Case "#PB_Text_Center"                    : Flag = Flag | #PB_Text_Center
            Case "#PB_Text_Right"                     : Flag = Flag | #PB_Text_Right
               ; option
               ; checkbox
            Case "#PB_CheckBox_Center"                : Flag = Flag | #PB_CheckBox_Center
            Case "#PB_CheckBox_Right"                 : Flag = Flag | #PB_CheckBox_Right
            Case "#PB_CheckBox_ThreeState"            : Flag = Flag | #PB_CheckBox_ThreeState
               ; listview
            Case "#PB_ListView_ClickSelect"           : Flag = Flag | #PB_ListView_ClickSelect
            Case "#PB_ListView_MultiSelect"           : Flag = Flag | #PB_ListView_MultiSelect
               ; frame
            Case "#PB_Frame_Double"                   : Flag = Flag | #PB_Frame_Double
            Case "#PB_Frame_Flat"                     : Flag = Flag | #PB_Frame_Flat
            Case "#PB_Frame_Single"                   : Flag = Flag | #PB_Frame_Single
               ; combobox
            Case "#PB_ComboBox_Editable"              : Flag = Flag | #PB_ComboBox_Editable
            Case "#PB_ComboBox_Image"                 : Flag = Flag | #PB_ComboBox_Image
            Case "#PB_ComboBox_LowerCase"             : Flag = Flag | #PB_ComboBox_LowerCase
            Case "#PB_ComboBox_UpperCase"             : Flag = Flag | #PB_ComboBox_UpperCase
               ; image 
            Case "#PB_Image_Border"                   : Flag = Flag | #PB_Image_Border
            Case "#PB_Image_Raised"                   : Flag = Flag | #PB_Image_Raised
               ; hyperlink 
            Case "#PB_HyperLink_Underline"            : Flag = Flag | #PB_HyperLink_Underline
               ; container 
            Case "#PB_Container_BorderLess"           : Flag = Flag | #PB_Container_BorderLess
            Case "#PB_Container_Double"               : Flag = Flag | #PB_Container_Double
            Case "#PB_Container_Flat"                 : Flag = Flag | #PB_Container_Flat
            Case "#PB_Container_Raised"               : Flag = Flag | #PB_Container_Raised
            Case "#PB_Container_Single"               : Flag = Flag | #PB_Container_Single
               ; listicon
            Case "#PB_ListIcon_AlwaysShowSelection"   : Flag = Flag | #PB_ListIcon_AlwaysShowSelection
            Case "#PB_ListIcon_CheckBoxes"            : Flag = Flag | #PB_ListIcon_CheckBoxes
            Case "#PB_ListIcon_ColumnWidth"           : Flag = Flag | #PB_ListIcon_ColumnWidth
            Case "#PB_ListIcon_DisplayMode"           : Flag = Flag | #PB_ListIcon_DisplayMode
            Case "#PB_ListIcon_GridLines"             : Flag = Flag | #PB_ListIcon_GridLines
            Case "#PB_ListIcon_FullRowSelect"         : Flag = Flag | #PB_ListIcon_FullRowSelect
            Case "#PB_ListIcon_HeaderDragDrop"        : Flag = Flag | #PB_ListIcon_HeaderDragDrop
            Case "#PB_ListIcon_LargeIcon"             : Flag = Flag | #PB_ListIcon_LargeIcon
            Case "#PB_ListIcon_List"                  : Flag = Flag | #PB_ListIcon_List
            Case "#PB_ListIcon_MultiSelect"           : Flag = Flag | #PB_ListIcon_MultiSelect
            Case "#PB_ListIcon_Report"                : Flag = Flag | #PB_ListIcon_Report
            Case "#PB_ListIcon_SmallIcon"             : Flag = Flag | #PB_ListIcon_SmallIcon
            Case "#PB_ListIcon_ThreeState"            : Flag = Flag | #PB_ListIcon_ThreeState
               ; ipaddress
               ; progressbar 
            Case "#PB_ProgressBar_Smooth"             : Flag = Flag | #PB_ProgressBar_Smooth
            Case "#PB_ProgressBar_Vertical"           : Flag = Flag | #PB_ProgressBar_Vertical
               ; scrollbar 
            Case "#PB_ScrollBar_Vertical"             : Flag = Flag | #PB_ScrollBar_Vertical
               ; scrollarea 
            Case "#PB_ScrollArea_BorderLess"          : Flag = Flag | #PB_ScrollArea_BorderLess
            Case "#PB_ScrollArea_Center"              : Flag = Flag | #PB_ScrollArea_Center
            Case "#PB_ScrollArea_Flat"                : Flag = Flag | #PB_ScrollArea_Flat
            Case "#PB_ScrollArea_Raised"              : Flag = Flag | #PB_ScrollArea_Raised
            Case "#PB_ScrollArea_Single"              : Flag = Flag | #PB_ScrollArea_Single
               ; trackbar
            Case "#PB_TrackBar_Ticks"                 : Flag = Flag | #PB_TrackBar_Ticks
            Case "#PB_TrackBar_Vertical"              : Flag = Flag | #PB_TrackBar_Vertical
               ; web
               ; calendar
            Case "#PB_Calendar_Borderless"            : Flag = Flag | #PB_Calendar_Borderless
               
               ; date
            Case "#PB_Date_CheckBox"                  : Flag = Flag | #PB_Date_CheckBox
            Case "#PB_Date_UpDown"                    : Flag = Flag | #PB_Date_UpDown
               
               ; editor
            Case "#PB_Editor_ReadOnly"                : Flag = Flag | #PB_Editor_ReadOnly
            Case "#PB_Editor_WordWrap"                : Flag = Flag | #PB_Editor_WordWrap
               
               ; explorerlist
            Case "#PB_Explorer_BorderLess"            : Flag = Flag | #PB_Explorer_BorderLess         
            Case "#PB_Explorer_AlwaysShowSelection"   : Flag = Flag | #PB_Explorer_AlwaysShowSelection
            Case "#PB_Explorer_MultiSelect"           : Flag = Flag | #PB_Explorer_MultiSelect
            Case "#PB_Explorer_GridLines"             : Flag = Flag | #PB_Explorer_GridLines
            Case "#PB_Explorer_HeaderDragDrop"        : Flag = Flag | #PB_Explorer_HeaderDragDrop
            Case "#PB_Explorer_FullRowSelect"         : Flag = Flag | #PB_Explorer_FullRowSelect
            Case "#PB_Explorer_NoFiles"               : Flag = Flag | #PB_Explorer_NoFiles
            Case "#PB_Explorer_NoFolders"             : Flag = Flag | #PB_Explorer_NoFolders
            Case "#PB_Explorer_NoParentFolder"        : Flag = Flag | #PB_Explorer_NoParentFolder 
            Case "#PB_Explorer_NoDirectoryChange"     : Flag = Flag | #PB_Explorer_NoDirectoryChange
            Case "#PB_Explorer_NoDriveRequester"      : Flag = Flag | #PB_Explorer_NoDriveRequester
            Case "#PB_Explorer_NoSort"                : Flag = Flag | #PB_Explorer_NoSort
            Case "#PB_Explorer_AutoSort"              : Flag = Flag | #PB_Explorer_AutoSort
            Case "#PB_Explorer_HiddenFiles"           : Flag = Flag | #PB_Explorer_HiddenFiles
            Case "#PB_Explorer_NoMyDocuments"         : Flag = Flag | #PB_Explorer_NoMyDocuments
               
               ; explorercombo
            Case "#PB_Explorer_DrivesOnly"            : Flag = Flag | #PB_Explorer_DrivesOnly
            Case "#PB_Explorer_Editable"              : Flag = Flag | #PB_Explorer_Editable
               
               ; explorertree
            Case "#PB_Explorer_NoLines"               : Flag = Flag | #PB_Explorer_NoLines
            Case "#PB_Explorer_NoButtons"             : Flag = Flag | #PB_Explorer_NoButtons
               
               ; spin
            Case "#PB_Spin_Numeric"                   : Flag = Flag | #PB_Spin_Numeric
            Case "#PB_Spin_ReadOnly"                  : Flag = Flag | #PB_Spin_ReadOnly
               ; tree
            Case "#PB_Tree_AlwaysShowSelection"       : Flag = Flag | #PB_Tree_AlwaysShowSelection
            Case "#PB_Tree_CheckBoxes"                : Flag = Flag | #PB_Tree_CheckBoxes
            Case "#PB_Tree_NoButtons"                 : Flag = Flag | #PB_Tree_NoButtons
            Case "#PB_Tree_NoLines"                   : Flag = Flag | #PB_Tree_NoLines
            Case "#PB_Tree_ThreeState"                : Flag = Flag | #PB_Tree_ThreeState
               ; panel
               ; splitter
            Case "#PB_Splitter_Separator"             : Flag = Flag | #PB_Splitter_Separator
            Case "#PB_Splitter_Vertical"              : Flag = Flag | #PB_Splitter_Vertical
            Case "#PB_Splitter_FirstFixed"            : Flag = Flag | #PB_Splitter_FirstFixed
            Case "#PB_Splitter_SecondFixed"           : Flag = Flag | #PB_Splitter_SecondFixed
               ; mdi
            Case "#PB_MDI_AutoSize"                   : Flag = Flag | #PB_MDI_AutoSize
            Case "#PB_MDI_BorderLess"                 : Flag = Flag | #PB_MDI_BorderLess
            Case "#PB_MDI_NoScrollBars"               : Flag = Flag | #PB_MDI_NoScrollBars
               ; scintilla
               ; shortcut
               ; canvas
            Case "#PB_Canvas_Border"                  : Flag = Flag | #PB_Canvas_Border
            Case "#PB_Canvas_ClipMouse"               : Flag = Flag | #PB_Canvas_ClipMouse
            Case "#PB_Canvas_Container"               : Flag = Flag | #PB_Canvas_Container
            Case "#PB_Canvas_DrawFocus"               : Flag = Flag | #PB_Canvas_DrawFocus
            Case "#PB_Canvas_Keyboard"                : Flag = Flag | #PB_Canvas_Keyboard
               
            Default
               ;             Select Asc(String$)
               ;               Case '0' To '9'
               Flag = Flag | Val(String$)
               ;             EndSelect
         EndSelect
         
      Next
   EndIf
   
   ProcedureReturn Flag
EndProcedure

Procedure MakeCoordinate( string$ ) ; 
   Protected result
   
   Select Asc( string$ )
      Case '0' To '9'
         result = Val(string$) ; Если строка такого рода "10"
         
      Default
         ;          result = GetVal(string$) ; Если строка такого рода "GadgetX(#Gadget)"
         ;          If result = 0
         ;             result = Val(GetVarValue(string$)) ; Если строка такого рода "x"
         ;          EndIf
         
   EndSelect
   
   ProcedureReturn result
EndProcedure

Procedure   MakeID( class$ )
   If FindMapElement( GetObject( ), class$ )
      class$ = GetObject( )
   EndIf
   
   Protected result, *parent._s_WIDGET = ide_design_panel_MDI
   ;class$ = Trim(class$)
   class$ = UCase(class$)
   
   If StartEnum( *parent )
      ; Debug ""+GetClass( widget( )) +" "+ class$
      If Trim(GetClass( widget( )), "#") = Trim(class$, "#")
         result = widget( )
         Break
      EndIf
      StopEnum( )
   EndIf
   
   
   If result
      a_set( result )
   EndIf      
   ProcedureReturn result
EndProcedure

Procedure$  MakeIDString( string$ )
   ;        Protected result$ ;= UCase( Trim( StringField( string$, 1, "," )))
   ;    ;    ProcedureReturn result$
   ;    
   ;    If FindString( string$, "=" )
   ;       result$ = Trim( StringField( string$, 1, "=" ))
   ;    Else
   ;       result$ = Trim( StringField( string$, 1, "," ))
   ;       
   ;       If result$ = "#PB_Any" 
   ;          result$ = ""
   ;       ElseIf FindString( result$, "-" )
   ;          ;  Если идентификатор просто - 1
   ;          result$ = ""
   ;       ElseIf NumericString( result$ )
   ;          ; Если идентификатор просто цифры
   ;          AddMapElement( GetObject( ), result$ )
   ;          result$ = "#" + \func$ +"_"+ result$
   ;          If Not enumerations
   ;             result$ = Trim( result$, "#" )
   ;          EndIf
   ;          GetObject( ) = UCase(result$)
   ;       Else
   ;          If Not enumerations
   ;             result$ = Trim( result$, "#" )
   ;          EndIf
   ;       EndIf
   ;    EndIf
   ;    
   ;    ProcedureReturn UCase( result$ )
EndProcedure

Procedure$ MakeCloseList( *g._s_WIDGET, *before = 0 )
   Protected result$
   ;
   While Not is_window_(*g) 
      ;; Panel; Container; ScrollArea
      ;If IsContainer( *g ) > 2
      If *g\parent And *g\parent\type = #__type_Splitter
         
      Else
         result$ + Code_GenerateCloseList( *g, Space(((Level(*g) ) - parentlevel) * codeindent) )
      EndIf
      ;EndIf 
      ;
      If *before = *g
         ; result$ + #LF$
         Break
      EndIf
      *g = *g\parent
   Wend
   ;
   ProcedureReturn result$
EndProcedure

;- 
Procedure$  Code_GenerateObject( *g._s_WIDGET, space$ )
   Protected result$, function$, x$, y$, width$, height$, text$, param1$, param2$, param3$, flag$, quotetext$
   Protected type$ = ClassFromType( Type(*g) )
   Protected id$ = GetClass(*g)
   
   ; coordinate
   If is_window_( *g ) 
      x$ = Str( X(*g, #__c_container) )
      y$ = Str( Y(*g, #__c_container) )
      width$ = Str( Width(*g, #__c_inner) )
      height$ = Str( Height(*g, #__c_inner) )
   Else
      x$ = Str( X(*g) )
      y$ = Str( Y(*g) )
      width$ = Str( Width(*g) )
      height$ = Str( Height(*g) )
   EndIf
   
   ; Text
   Select type$
      Case "Window", "Button", "String",
           "CheckBox", "Option", "Frame", "Text",
           "HyperLink", "ListIcon", "Web", "Date",
           "ExplorerList", "ExplorerTree", "ExplorerCombo"
         
         text$ = GetText( *g )
         quotetext$ = Chr('"') + text$ + Chr('"')
   EndSelect
   
   ; Param1
   Select type$
         ; Case "MDI" : param1$ = *g\SubMenu
         ; Case "Date" : param1$ = *g\Date
         ; Case "Calendar" : param1$ = *g\Date
      Case "ListIcon" : param1$ = Str(*g\columns( )\width)
         ; Case "Scintilla" : param1$ = *g\CallBack
         ; Case "Shortcut" : param1$ = *g\Shortcut
      Case "Spin",
           "Track",
           "Scroll",
           "Progress",
           "TrackBar",
           "ScrollBar",
           "ProgressBar": param2$ = Str( *g\bar\min )
      Case "HyperLink" : param1$ = Str( *g\Color\Back )
      Case "ScrollArea" : param1$ = Str( GetAttribute( *g, #PB_ScrollArea_InnerWidth ))
      Case "Splitter" 
         Define first = GetAttribute( *g, #PB_Splitter_FirstGadget )
         If first 
            param1$ = GetClass( first )
         EndIf
      Case "Image", "ButtonImage"
         If IsImage( *g\Img\Image )
            param1$ = "ImageID( " + *g\Img\Image + " )"
         Else
            param1$ = "0"
         EndIf
   EndSelect
   
   ; Param2
   Select type$
         ;Case "MDI" : param2$ = *g\FirstMenuItem
      Case "Spin",
           "Track",
           "Scroll",
           "Progress",
           "TrackBar",
           "ScrollBar",
           "ProgressBar": param2$ = Str( *g\bar\max )
      Case "ScrollArea" : param2$ = Str( GetAttribute( *g, #PB_ScrollArea_InnerHeight ))
      Case "Splitter"  
         Define second = GetAttribute( *g, #PB_Splitter_SecondGadget )
         If second
            param2$ = GetClass( second )
         EndIf
   EndSelect
   
   ; Param3
   Select type$
      Case "Scroll",
           "ScrollBar"  : param3$ = Str( GetAttribute( *g, #PB_ScrollBar_PageLength ))
      Case "ScrollArea" : param3$ = Str( GetAttribute( *g, #PB_ScrollArea_ScrollStep ))
   EndSelect
   
   ; Flags
   Select type$
      Case "Panel", "Web", "IPAddress", "Option", "Scintilla", "Shortcut"
      Default
         Flag$ = MakeConstantsString( type$, *g\flag )
   EndSelect
   
   ;
   ;\\ close list
   If *g\BeforeWidget( )
      ; Panel; Container; ScrollArea
      If IsContainer( *g\BeforeWidget( ) ) > 2
         ;
         PushListPosition( widgets( ))
         If ChangeCurrentElement( widgets( ), *g\address )
            PreviousElement( widgets( ))
            result$ + MakeCloseList( widgets( ), *g\BeforeWidget( ))
         EndIf     
         PopListPosition( widgets( ))
         ;
      EndIf
   EndIf
   
   ;
   ;\\ add panel item
   Static TabParent
   Static TabIndex = - 1
   If *g\parent\tabbar
      If TabParent <> *g\parent
         TabParent = *g\parent
         TabIndex = - 1
      EndIf
      If TabIndex <> *g\TabIndex( ) 
         ;
         If *g\BeforeWidget( )
            If *g\TabIndex( ) = *g\BeforeWidget( )\TabIndex( )
               ; result$ + #LF$
            Else
               result$ + Code_GeneratePanelItems( *g\parent, *g\BeforeWidget( )\TabIndex( ) + 1, *g\TabIndex( ), Space$ )
            EndIf
         Else
            result$ + Code_GeneratePanelItems( *g\parent, 0, *g\TabIndex( ), Space$ )
         EndIf
         ;
         TabIndex = *g\TabIndex( ) 
      EndIf
   EndIf
   
   ;
   ;\\ add splitter children
   If Type(*g) = #__type_Splitter
      Define first = GetAttribute( *g, #PB_Splitter_FirstGadget )
      Define Second = GetAttribute( *g, #PB_Splitter_SecondGadget )
      ; result$ + #LF$
      If first
         result$ + Code_GenerateObject( first, Space$ )
         result$ + Code_GenerateCloseList( first, Space$ )
      EndIf
      If Second
         result$ + Code_GenerateObject( second, Space$ )
         result$ + Code_GenerateCloseList( Second, Space$ )
      EndIf
   EndIf  
   
   ;
   If line_break1 = 1
      line_break1 = - 1
      If Not is_window_( *g )
         result$ + space$ + #LF$
      EndIf
   Else
      If IsContainer( *g ) > 2 And *g\BeforeWidget( ) ;And IsContainer( *g\BeforeWidget( ) ) > 2
         result$ + #LF$
      EndIf  
   EndIf
   
   ;
   ;\\
   result$ + space$
   ;
   ;\\ make function string
   ;
   If Trim( id$, "#" ) <> id$
      If type$ = "Window"
         function$ = "Open" + type$
      Else
         Select type$
            Case "Scroll", "Progress", "Track"
               function$ = type$ + "BarGadget"
            Default
               function$ = type$ + "Gadget"
         EndSelect
      EndIf
      ;
      function$ + "( " + id$ + ", "
   Else
      If type$ = "Window"
         function$ = id$+" = Open" + type$
      Else
         Select type$
            Case "Scroll", "Progress", "Track"
               function$ = id$ + " = " + type$ + "BarGadget"
            Default
               function$ = id$ + " = " + type$ + "Gadget"
         EndSelect
      EndIf
      ;
      function$ + "( #PB_Any, "
   EndIf
   ;
   If pb_object$ = "" 
      function$ = ReplaceString( function$, "Gadget( #PB_Any, ", "( " )
      function$ = ReplaceString( function$, "Window( #PB_Any, ", "( #PB_Any, "  )
   EndIf
   ;
   ;\\ make object string
   ;
   Select type$
      Case "Window"        : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                   
      Case "Button"        : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                                 
      Case "String"        : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                                 
      Case "Text"          : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                                   
      Case "CheckBox"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                               
      Case "Option"        : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$
      Case "Web"           : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$
      Case "ExplorerList"  : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                           
      Case "ExplorerTree"  : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                           
      Case "ExplorerCombo" : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                          
      Case "Frame"         : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$                                                                                  
         
      Case "HyperLink"     : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$+", " + param1$+", " + param2$                                                          
      Case "ListIcon"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$+", " + param1$                                                      
         
      Case "ScrollArea"    : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$    
      Case "Scroll", 
           "ScrollBar"     : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$+", " + param3$                                                               
      Case "Progress",
           "ProgressBar"   : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$                                                                       
      Case "Track", 
           "TrackBar"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$                                                                                      
      Case "Spin"          : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$                                                                             
      Case "Splitter"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$                                                                         
      Case "MDI"           : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$                                                                              
      Case "Image"         : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$                                                                                                     
      Case "Scintilla"     : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$
      Case "Shortcut"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$
      Case "ButtonImage"   : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$                                                                                                 
         
      Case "ListView"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                       
      Case "ComboBox"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                       
      Case "Container"     : result$ + function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                      
      Case "IPAddress"     : result$ + function$ + x$+", " + y$+", " + width$+", " + height$
      Case "Calendar"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$                                                     
      Case "Editor"        : result$ + function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                          
      Case "Date"          : result$ + function$ + x$+", " + y$+", " + width$+", " + height$               
      Case "Tree"          : result$ + function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                            
      Case "Panel"         : result$ + function$ + x$+", " + y$+", " + width$+", " + height$ 
      Case "Canvas"        : result$ + function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                          
   EndSelect
   ;
   Select type$
      Case "ScrollArea"    
         If param3$ : result$ +", " + param3$ : EndIf     
      Case "Calendar"
         If param1$ : result$ +", " + param1$ : EndIf 
      Case "Date"         
         If text$ : result$ +", "+ quotetext$ : EndIf
         If param1$ : result$ +", " + param1$ : EndIf 
   EndSelect
   ;
   If flag$
      Select type$
         Case "Window", 
              "ScrollBar", "TrackBar", "ProgressBar", 
              "Scroll", "Track", "Progress", "Spin", "Web", "OpenGL",
              "Text", "String", "Editor", "Button", "CheckBox", "HyperLink", 
              "Tree", "ListIcon", "ListView", "ComboBox", "Image", "ButtonImage",
              "Date", "Calendar", "ExplorerCombo", "ExplorerList", "ExplorerTree",
              "Container", "ScrollArea", "Splitter", "MDI", "Canvas", "Frame"  
            
            result$ +", " + flag$ 
      EndSelect
   EndIf
   ;
   result$ + " )" + #LF$ 
   ;   
   If Not IsContainer( *g ) Or is_window_(*g)
      result$ + Code_GenerateStates( *g, Space$ + Space(codeindent) )
   EndIf
   ;
   ProcedureReturn result$
EndProcedure

Procedure.s Code_Generate( *mdi._s_WIDGET ) ; 
   Protected Type, Count, Image, Parent
   Protected Space$, id$, Class$, result$, Gadgets$, Windows$, Events$, Functions$
   Protected GlobalWindow$, GlobalGadget$, EnumWindow$, EnumGadget$
   
   Static JPEGPlugin$, JPEG2000Plugin$, PNGPlugin$, TGAPlugin$, TIFFPlugin$
   Protected *g._s_WIDGET
   Protected *w._s_WIDGET
   Protected *mainWindow._s_WIDGET
   
   If *mdi
      parentlevel = Level(*mdi)
   EndIf
   
   ; is *g
   If *mdi
      If codeindent
         Space$ = Space(codeindent)
      EndIf
      
      If pb_object$ = ""
         result$ + ~"XIncludeFile \"C:\\Users\\user\\Documents\\GitHub\\widget\\widgets.pbi\"" + #LF$ 
         result$ + "UseWidgets( )" + #LF$
         result$ + #LF$
      EndIf
      
      result$ + "EnableExplicit" + #LF$
      
      If StartEnum( *mdi )
         *w = widgets( )
         id$ = GetClass( *w )
         Image = GetImage( *w )
         
         ; Debug GetClass( GetParent(*w)) +" "+ GetClass( *w)
         ;
         If Not *mainWindow
            If is_window_( *w )
               *mainWindow = *w
            EndIf
         EndIf
         
         ;
         ;\\
         ;
         If Trim( id$, "#" ) = id$
            If is_window_( *w )
               GlobalWindow$ + "Global " + id$ + " = - 1" + #LF$
            Else
               GlobalGadget$ + "Global " + id$ + " = - 1" + #LF$
            EndIf
         Else
            If is_window_( *w )
               EnumWindow$ + Space$ + id$ + #LF$
            Else
               EnumGadget$ + Space$ + id$ + #LF$
            EndIf
         EndIf
         
         ;
         ;\\ UseIMAGEDecoder
         ;
         If IsImage( Image )
            Select ImageFormat( Image )
               Case #PB_ImagePlugin_JPEG
                  If JPEGPlugin$ <> "UseJPEGImageDecoder( )"
                     JPEGPlugin$ = "UseJPEGImageDecoder( )"
                     result$ + "UseJPEGImageDecoder( )" + #LF$
                  EndIf
               Case #PB_ImagePlugin_JPEG2000
                  If JPEG2000Plugin$ <> "UseJPEG2000ImageDecoder( )"
                     JPEG2000Plugin$ = "UseJPEG2000ImageDecoder( )"
                     result$ + "UseJPEG2000ImageDecoder( )" + #LF$
                  EndIf
               Case #PB_ImagePlugin_PNG
                  If PNGPlugin$ <> "UsePNGImageDecoder( )"
                     PNGPlugin$ = "UsePNGImageDecoder( )"
                     result$ + "UsePNGImageDecoder( )" + #LF$
                  EndIf
               Case #PB_ImagePlugin_TGA
                  If TGAPlugin$ <> "UseTGAImageDecoder( )"
                     TGAPlugin$ = "UseTGAImageDecoder( )"
                     result$ + "UseTGAImageDecoder( )" + #LF$
                  EndIf
               Case #PB_ImagePlugin_TIFF
                  If TIFFPlugin$ <> "UseTIFFImageDecoder( )"
                     TIFFPlugin$ = "UseTIFFImageDecoder( )"
                     result$ + "UseTIFFImageDecoder( )" + #LF$
                  EndIf
               Case #PB_ImagePlugin_BMP
                  
               Case #PB_ImagePlugin_ICON
                  
            EndSelect
            
            result$ + "LoadImage( " + Image + ", " + #DQUOTE$ + ImagePuchString( Str( Image ) ) + #DQUOTE$ + " )" + #LF$
         EndIf
         StopEnum( )
      EndIf
      
      ;
      ;\\ enumeration windows
      ;
      If EnumWindow$
         result$ + #LF$
         result$ + "Enumeration FormWindow" + #LF$
         result$ + EnumWindow$
         result$ + "EndEnumeration" + #LF$
      EndIf
      ; 
      If EnumGadget$
         result$ + #LF$
         result$ + "Enumeration FormGadget" + #LF$
         result$ + EnumGadget$
         result$ + "EndEnumeration" + #LF$
      EndIf
      
      ;
      ;\\ global windows
      ;
      If GlobalWindow$
         result$ + #LF$
         result$ + GlobalWindow$
      EndIf
      ; 
      If GlobalGadget$
         result$ + #LF$
         result$ + GlobalGadget$
      EndIf
      
      result$ + #LF$
      
      ForEach __gui\font( )
         If __gui\font( )\style
            result$ + "LoadFont( " + MapKey(__gui\font( )) + ", " + Chr('"') + __gui\font( )\name + Chr('"') + ", " + __gui\font( )\size + ", " + MakeConstantsString( "Font", __gui\font( )\style) + " )" + #LF$
         Else
            result$ + "LoadFont( " + MapKey(__gui\font( )) + ", " + Chr('"') + __gui\font( )\name + Chr('"') + ", " + __gui\font( )\size + " )" + #LF$
         EndIf
      Next
      
      result$ + ";- " + #LF$
      If StartEnum( *mdi )
         *g = widgets( )
         ;If Not is_window_( *g )
         Events$ = GetEventsString( *g )
         If Events$
            result$ + Code::GenerateBindEventProcedure( 0, Trim( GetClass( *g ), "#" ) , Events$, "" ) 
         EndIf
         ;EndIf
         StopEnum( )
      EndIf
      
      If StartEnum( *mdi )
         *w = widgets( )
         If is_window_( *w )
            
            ;\\
            result$ + "Procedure Open_" + Trim( GetClass( *w ), "#" ) + "( )" + #LF$
            
            ;\\ 
            result$ + Code_GenerateObject( *w, Space(( Level(*w) - parentlevel ) * codeindent ))
            
            If StartEnum( *w )
               *g = widgets( )
               If Type(GetParent(*g)) = #__type_Splitter
               Else
                  result$ + Code_GenerateObject( *g, Space(( Level(*g) - parentlevel ) * codeindent ))
               EndIf
               
               StopEnum( )
            EndIf
            
            ;- CLOSE LIST
            If *g
               result$ + MakeCloseList( *g ) 
            EndIf
            
            ;
            If GetEventsString( *w )
               result$ + #LF$
               result$ + Code::GenerateBindEvent( ( Level(*w) - parentlevel ) * codeindent, GetEventsString( *w ), GetClass( *w ) )
            EndIf
            
            result$ + "EndProcedure" + #LF$
            result$ + #LF$
            
         EndIf
         StopEnum( )
      EndIf
      
      result$ + "CompilerIf #PB_Compiler_IsMainFile" + #LF$
      ; result$ + "  Open_" + Trim( GetClass( *mainWindow ), "#" ) + "( )" + #lf$
      
      Define CountWindow
      If StartEnum( *mdi )
         *w = widgets( )
         If is_window_( *w )
            CountWindow + 1
            result$ + Space$ + "Open_" + Trim( GetClass( *w ), "#" ) + "( )" + #LF$
         EndIf
         StopEnum( )
      EndIf
      
      result$ + #LF$
      
      If pb_object$ = ""
         result$ + Space$ + "WaitClose( )" + #LF$
      Else
         ;result$ + Space$ + ";- MAIN LOOP" + #LF$
         result$ + Space$ + "Define EVENT" + #LF$
         result$ + Space$ + "Define OPENWINDOW = " + Str( CountWindow ) + #LF$
         result$ + Space$ + "While OPENWINDOW" + #LF$
         ; result$ + Space$ + "While IsWindow( " + GetClass( *mainWindow ) + " )" + #LF$
         result$ + Space$ + Space$ + "EVENT = WaitWindowEvent( )" + #LF$
         result$ + Space$ + Space$ + "" + #LF$
         result$ + Space$ + Space$ + "Select EventWindow( )" + #LF$
         If StartEnum( *mdi )
            *w = widgets( )
            If is_window_( *w )
               result$ + Space$ + Space$ + Space$ + "Case " + GetClass( *w ) + #LF$
            EndIf
            StopEnum( )
         EndIf
         result$ + Space$ + Space$ + "EndSelect" + #LF$
         result$ + Space$ + Space$ + "" + #LF$
         result$ + Space$ + Space$ + "Select EVENT" + #LF$
         result$ + Space$ + Space$ + Space$ + "Case #PB_Event_CloseWindow" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + "; If " + GetClass( *mainWindow ) + " = EventWindow( )" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + ";" + Space$ + "If #PB_MessageRequester_Yes = MessageRequester( " + Chr( '"' ) + "Message" + Chr( '"' ) + ", " + #LF$ + 
                   Space$ + Space$ + Space$ + Space$ + ";" + Space$ + Space(Len("If #PB_MessageRequester_Yes = MessageRequester( ")) + Chr( '"' ) +"Are you sure you want To go out?"+ Chr( '"' ) + ", " + #LF$ + 
                   Space$ + Space$ + Space$ + Space$ + ";" + Space$ + Space(Len("If #PB_MessageRequester_Yes = MessageRequester( ")) + "#PB_MessageRequester_YesNo | #PB_MessageRequester_Info )" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + ";" + Space$ + Space$ + "CloseWindow( EventWindow( ) )" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + ";" + Space$ + Space$ + "Break" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + ";" + Space$ + "EndIf" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + "; Else" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + Space$ + "CloseWindow( EventWindow( ) )" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + Space$ + "OPENWINDOW - 1" + #LF$
         result$ + Space$ + Space$ + Space$ + Space$ + "; EndIf" + #LF$
         result$ + Space$ + Space$ + "EndSelect" + #LF$
         result$ + Space$ + "Wend" + #LF$ 
      EndIf
      result$ + Space$ + "End" + #LF$
      result$ + "CompilerEndIf"
   EndIf
   
   ProcedureReturn result$
EndProcedure

;- 
CompilerIf #PB_Compiler_IsMainFile
   DisableExplicit
   Define Width = 350
   
   If Open( 0, 0, 0, Width, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      Define i, *parent._s_Widget
      
      ;       i = 0
      ;       Window( 10 + (i+1)*30, (i+1)*140 - 120, 255, 95 + 2, "Window_" + Trim( Str( i ) ), #PB_Window_SystemMenu | #PB_Window_MaximizeGadget )  
      ;       SetEventsString(widget( ), "#PB_Event_Gadget|#PB_Event_SizeWindow")
      ;       
      ;       Container( 5, 5, 120 + 2, 85 + 2, #PB_Container_Flat )                  
      ;       Button( 10, 10, 100, 30, "Button_" + Trim( Str( i + 10 ) ) )                  
      ;       Button( 10, 45, 100, 30, "Button_" + Trim( Str( i + 20 ) ) )                 
      ;       CloseList( )                               
      ;       Container( 127, 5, 120 + 2, 85 + 2, #PB_Container_Flat )                  
      ;       Button( 10, 10, 100, 30, "Button_" + Trim( Str( i + 10 ) ) )                  
      ;       Button( 10, 45, 100, 30, "Button_" + Trim( Str( i + 20 ) ) )                 
      ;       CloseList( )                               
      ;       
      ;       i = 1 
      ;       Window( 10 + (i+1)*30, (i+1)*140 - 120, 255, 95 + 2, "Window_" + Trim( Str( i ) ), #PB_Window_SystemMenu | #PB_Window_MaximizeGadget )  
      ;       *parent = Panel( 5, 5, 120 + 2, 85 + 2 ) 
      ;       AddItem( *parent, - 1, "item - 1" )
      ;       Button( 10, 10, 100, 30, "Button14" )                  
      ;       Button( 10, 45, 100, 30, "Button15" )                  
      ;       AddItem( *parent, - 1, "item - 2" )
      ;       Button( 10, 10, 100, 30, "Button16" )                  
      ;       Button( 10, 45, 100, 30, "Button17" )                  
      ;       AddItem( *parent, - 1, "item - 3" )
      ;       Button( 10, 10, 100, 30, "Button18" )                  
      ;       Button( 10, 45, 100, 30, "Button19" )                  
      ;       CloseList( )                               
      ;       SetState( *parent, 1 )
      ;       
      ;       *parent = Panel( 127, 5, 120 + 2, 85 + 2 ) 
      ;       AddItem( *parent, - 1, "item - 1" )
      ;       Button( 10, 10, 100, 30, "Button14" )                  
      ;       Button( 10, 45, 100, 30, "Button15" )                  
      ;       AddItem( *parent, - 1, "item - 2" )
      ;       Button( 10, 10, 100, 30, "Button16" )                  
      ;       Button( 10, 45, 100, 30, "Button17" )                  
      ;       AddItem( *parent, - 1, "item - 3" )
      ;       Button( 10, 10, 100, 30, "Button18" )                  
      ;       Button( 10, 45, 100, 30, "Button19" )                  
      ;       CloseList( )                               
      ;       SetState( *parent, 1 )
      ;     
      #font_2 = 2
      
      AddFont(1, "Arial", 19 )
      AddFont(#font_2, "Consolas", 21, #PB_Font_Bold )
      
      WINDOW_1 = Window( 10, 300, Width-30, 253, "window_1" ) : SetClass( widget( ), "WINDOW_1")
      BUTTON_8 = Button( 21, 14, 120, 64, "button_8" )
      SetFont( BUTTON_8, (1))
      SetColor( BUTTON_8, #PB_Gadget_BackColor, (0))
      BUTTON_9 = Button( 21, 91, 120, 71, "button_9" )
      SetFont( BUTTON_9, (2))
      BUTTON_10 = Button( 21, 175, 120, 64, "button_10" )
      SetFont( BUTTON_10, (1))
      
      ;             CONTAINER_0 = Container( 154, 14, 330, 225 )
      ;             BUTTON_11 = Button( 14, 21, 141, 43, "button_11" )
      ;             BUTTON_12 = Button( 14, 77, 141, 71, "button_12" )
      ;             BUTTON_13 = Button( 14, 161, 141, 50, "button_13" )
      ;             
      ;             PANEL_0 = Panel( 168, 21, 148, 183 )
      ;             AddItem( PANEL_0, -1, "tab_0")
      ;             BUTTON_14 = Button( 7, 14, 134, 29, "button_14" )
      ;             AddItem( PANEL_0, -1, "tab_1")
      ;             BUTTON_15 = Button( 7, 56, 134, 71, "button_15" )
      ;             AddItem( PANEL_0, -1, "tab_2")
      ;             BUTTON_16 = Button( 7, 140, 134, 36, "button_16" )
      ;             CloseList( )
      ;             CloseList( )
      ;       
      ;       SCROLLAREA_0 = ScrollArea( 0, 0, 241, 393, 241, 391, 0 )
      ;       CloseList( )
      ;       TREE_0 = Tree( 0, 0, 241, 192 )
      ;       PANEL_0 = Panel( 0, 201, 241, 192 )
      ;       AddItem( PANEL_0, -1, "tab_1")
      ;       AddItem( PANEL_0, -1, "tab_2")
      ;       CloseList( )
      ;       
      ;       ; SPLITTER_0 = Splitter( 250, 0, 241, 393, TREE_0, 0 )
      ;       SPLITTER_0 = Splitter( 250, 0, 241, 393, TREE_0, PANEL_0 )
      ;       SPLITTER_1 = Splitter( 7, 7, Width-30-14, 253-14, SCROLLAREA_0, SPLITTER_0, #PB_Splitter_Vertical )
      ;       
      ;       ;       ;
      ;       ;       R1 = Container(7, 7, 568, 568,  #PB_Container_Single  )
      ;       ;       R1Y1 = Container(7, 7, 274, 274,  #PB_Container_Single  )
      ;       ;       
      ;       ;       R1Y1G1 = Container(7, 7, 127, 127,  #PB_Container_Single  )
      ;       ;       R1Y1G1B1 = Container(7, 7, 50, 50,  #PB_Container_Single  )
      ;       ;       R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
      ;       ;       R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
      ;       ;       R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
      ;       ;       CloseList( )
      ;       ;       R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
      ;       ;       CloseList( )
      ;       ;       CloseList( )
      ;       ;       CloseList( )
      ;       ;       CloseList( )
      ;       ;       CloseList( )
      ;       ;       
      ;       ;       R1Y1G1 = Container(7, 7, 127, 127,  #PB_Container_Single  )
      ;       ;       ;                R1Y1G1B1 = Container(7, 7, 50, 50,  #PB_Container_Single  )
      ;       ;       ;                   R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
      ;       ;       ;                      R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
      ;       ;       ;                         R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
      ;       ;       ;                         CloseList( )
      ;       ;       ;                         R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
      ;       ;       ;                         CloseList( )
      ;       ;       ;                      CloseList( )
      ;       ;       ;                   CloseList( )
      ;       ;       ;                CloseList( )
      ;       ;       CloseList( )
      ;       ;       
      ;       ;       CloseList( )
      ;       ;       CloseList( )
      ;       
      ;       
      ;       ;       If StartEnum( root( ) )
      ;       ;          StopEnum( )
      ;       ;       EndIf
      ;       
   EndIf
   
   Define *root = root( )
   If Open( 1, 0, 0, Width*2, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ResizeWindow( 0, WindowX( 0 ) - WindowWidth( 1 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      ResizeWindow( 1, WindowX( 1 ) + WindowWidth( 0 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      
      Define *g = Editor( 0, 0, 0, 0, #__flag_autosize )
      
      Define code$ = Code_Generate( *root )
      
      SetText( *g, code$ )
      Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
   EndIf
   
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1505
; FirstLine = 1461
; Folding = --------------------------------4-----
; EnableXP
; DPIAware