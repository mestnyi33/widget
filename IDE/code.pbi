;- GLOBALs

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
Procedure AddParseObject( *g._s_WIDGET )
   LastElement( ParseObject( ) )
   AddElement( ParseObject( ) )
   ParseObject( ) = *g
EndProcedure

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
Procedure$  MakeFlagString( type$, flag.q ) ; 
   Protected result$
   
   Select type$
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
         
   EndSelect
   
   ProcedureReturn Trim( result$, "|" )
EndProcedure

Procedure.q MakeFlag( Flag_Str.s )
   Protected i, Flag.q, count, String$
   
   If Flag_Str
      count = CountString(Flag_Str,"|")
      For I = 0 To count
         String$ = Trim(StringField(Flag_Str,(I+1),"|"))
         
         Select String$
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

Procedure   MakeObject( class$ )
   If FindMapElement( GetObject( ), class$ )
      class$ = GetObject( )
   EndIf
   
   Protected result, *parent._s_WIDGET = ide_design_panel_MDI
   ;class$ = Trim(class$)
   ;class$ = UCase(class$)
   
   If StartEnum( *parent )
      ; Debug ""+GetClass( widget( )) +" "+ class$
      If GetClass( widget( )) = class$
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

Procedure$  MakeObjectString( *g._s_WIDGET, space$ )
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
         ; Case "ListIcon" : param1$ = *g\FirstColumWidth
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
      Case "Splitter" : param1$ = GetClass( GetAttribute( *g, #PB_Splitter_FirstGadget ))
      Case "ScrollArea" : param1$ = Str( GetAttribute( *g, #PB_ScrollArea_InnerWidth ))
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
      Case "Splitter"   : param2$ = GetClass( GetAttribute( *g, #PB_Splitter_SecondGadget ))
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
         Flag$ = MakeFlagString( type$, *g\flag )
   EndSelect
   
;    ; close list
;    If *g\BeforeWidget( )
;       If IsContainer( *g\BeforeWidget( ) ) > 3 
;          
;          PushListPosition( widgets( ))
;          If ChangeCurrentElement( widgets( ), *g\address )
;             PreviousElement( widgets( ))
;             result$ + GenerateCODE( widgets( ), "CloseGadgetList", *g\BeforeWidget( ) ); ) 
;          EndIf     
;          PopListPosition( widgets( ))
;       
;       Else
;          ;\\
;          If IsContainer(*g) > 3 
;             result$ + space$ + #LF$
;          EndIf 
;       EndIf
;    EndIf
   
   ;
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
      Case "ListIcon"      : result$ + function$ + x$+", " + y$+", " + width$+", " + height$+", "+ quotetext$+", " + param1$+", " + param2$                                                       
         
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
   result$ + " )" 
   ;
   ProcedureReturn result$
EndProcedure

Procedure$ MakeAddItem( *g._s_WIDGET, Space$, item =- 1 )
   Protected result$
   Protected id$ = GetClass( *g )
   Protected i, count = CountItems( *g ) - 1
   
   For i = 0 To count
      result$ + Space$ + "AddGadgetItem( " + id$ + 
                ", - 1" + 
                ", " + Chr( '"' ) + GetItemText( *g, i ) + Chr( '"' ) + 
                " )  " + #LF$
      
      
      If item = i
         Break
      EndIf
   Next
   
   ProcedureReturn result$
EndProcedure

Procedure$ make( *g._s_WIDGET, start )
   Protected i, result$
   If IsContainer(*g) = 3
      If *g\LastWidget( ) And *g\LastWidget( ) <> *g
         result$ + make( *g\LastWidget( ), *g\LastWidget( )\TabIndex( ) )
      EndIf
      
      For i = start To CountItems( *g ) - 1
         If i > 0
            result$ + #LF$
         EndIf
         If codeindent
            result$ + Space(((Level(*g)+1) - parentlevel) * codeindent)
         EndIf
         result$ + "AddGadgetItem( " + GetClass( *g ) + 
                   ", - 1" + 
                   ", " + Chr( '"' ) + GetItemText( *g, i ) + Chr( '"' ) + 
                   " )" + #LF$
      Next
      
      If codeindent
         result$ + Space((Level(*g) - parentlevel) * codeindent)
      EndIf
      result$ + "CloseGadgetList( ) ; " + GetClass(*g) + #LF$ 
   EndIf
   ProcedureReturn result$
EndProcedure

;- 
Procedure.s GenerateCODE( *g._s_WIDGET, type$, *data = 0 )
   Protected result$, ID$, param1$, param2$, param3$, Text$, flag$, Class$, Name$
   Static TabIndex =- 1, tabparent
   
   If ide_design_panel_MDI
      parentlevel = Level(ide_design_panel_MDI)
   EndIf

   If Not *g
      ProcedureReturn ""
   EndIf
   
   If Not *g\parent
      ProcedureReturn ""
   EndIf
   
   If type$ = "CloseGadgetList"
      While Not is_window_(*g )
         If IsContainer( *g ) > 3 
            If codeindent
               result$ + Space((Level(*g) - parentlevel) * codeindent)
            EndIf
            result$ + type$ + "( ) ; " + GetClass(*g) + #LF$ 
         EndIf 
         If *data = *g
            If IsContainer( *g ) > 3 
               result$ + #LF$
            EndIf
            Break
         EndIf
         *g = *g\parent
      Wend
      ProcedureReturn result$
   Else
      If codeindent
         Protected Space$ = Space((Level(*g) - parentlevel) * codeindent)
      EndIf
   EndIf
    
   If type$ = "AddGadgetItem"
;       If *g\parent\tabbar
;          If tabparent<>*g\parent
;             tabparent=*g\parent
;             TabIndex =- 1
;          EndIf
;          If TabIndex <> *g\TabIndex( ) 
;             TabIndex = *g\TabIndex( ) 
;             
;             If TabIndex > 0
;                result$ + Space$ + #LF$
;             EndIf
;             
;             result$ + Space$ + type$ + "( " + GetClass( *g\parent ) + 
;                       ", - 1" + 
;                       ", " + Chr( '"' ) + GetItemText( *g\parent, TabIndex ) + Chr( '"' ) + 
;                       " )  " + #LF$
;             
;          EndIf
;       EndIf
   EndIf
   
   If type$ = "STATE"
      Name$ = GetClass( *g )
      ;
      If Hide( *g) > 0
         result$ + Space$ 
         result$ + "HideGadget( " + Name$ + ", #True )" + #LF$
      EndIf
      If Disable( *g) > 0
         result$ + Space$ 
         result$ + "DisableGadget( " + Name$ + ", #True )" + #LF$
      EndIf
      If GetState( *g) > 0
         result$ + Space$ 
         result$ + "SetGadgetState( " + Name$ + ", "+ GetState( *g) + " )" + #LF$
      Else
;          ; Это для тех кто гаджетов которые принимают [0]
;          Select *g\Type 
;             Case #__type_Panel
;                If GetState( *g) = 0
;                   result$ + Space$ 
;                   result$ + "SetGadgetState( " + Name$ + ", "+ GetState( *g) + " )" + #LF$
;                EndIf
;          EndSelect
      EndIf
   EndIf
   
   If type$ = "object"
      
      ; close list
      If *g\BeforeWidget( )
         If IsContainer( *g\BeforeWidget( ) ) > 3 
            
            PushListPosition( widgets( ))
            If ChangeCurrentElement( widgets( ), *g\address )
               PreviousElement( widgets( ))
               result$ + GenerateCODE( widgets( ), "CloseGadgetList", *g\BeforeWidget( ) ); ) 
            EndIf     
            PopListPosition( widgets( ))
            
         Else
            ;\\
            If IsContainer(*g) > 3 
               result$ + space$ + #LF$
            EndIf 
         EndIf
      EndIf
   
   
      ;\\ add parent item
      ; result$ + GenerateCODE( *g, "AddGadgetItem" ) 
      
      If *g\parent\tabbar
         If tabparent<>*g\parent
            ; result$ + Space$ + "AddGadgetItem" + #LF$
            
            tabparent = *g\parent
            TabIndex = - 1
         EndIf
         If TabIndex <> *g\TabIndex( ) 
            id$ = GetClass( *g\parent )
            Protected i, count = CountItems( *g\parent ) - 1
            
            If *g\BeforeWidget( )
               If *g\BeforeWidget( )\lastWidget( )
                  result$ + make( *g\BeforeWidget( ), *g\BeforeWidget( )\lastWidget( )\TabIndex( ) + 1 )
               Else
                  result$ + make( *g\BeforeWidget( ), *g\BeforeWidget( )\TabIndex( ) + 2 )
               EndIf
               
               If *g\TabIndex( ) = *g\BeforeWidget( )\TabIndex( )
                  ; Debug ""+*g\class +" "+ *g\BeforeWidget( )\class
                  TabIndex = - 1
                  result$ + Space$ + #LF$
               Else
                  TabIndex = *g\BeforeWidget( )\TabIndex( ) + 1 
               EndIf
            Else
               TabIndex = 0;*g\TabIndex( )
            EndIf
            
            If Not TabIndex = - 1
               For i = TabIndex To count
                  If i > 0
                     result$ + Space$ + #LF$
                  EndIf
                  result$ + Space$ + "Add|GadgetItem( " + id$ + 
                            ", - 1" + 
                            ", " + Chr( '"' ) + GetItemText( *g\parent, i ) + Chr( '"' ) + 
                            " )" + #LF$
                  
                  If *g\TabIndex( ) = i
                     Break
                  EndIf
               Next
               
               ; result$ + make( *g\parent, TabIndex )
            EndIf
            
            TabIndex = *g\TabIndex( ) 
         EndIf
      EndIf
       
      result$ + MakeObjectString( *g, Space$ )
      
   EndIf
   
   ProcedureReturn result$
EndProcedure

Procedure.s GeneratePBCode( *mdi._s_WIDGET ) ; 
   Protected Type, Count, Image, Parent
   Protected Space$, Name$, Class$, result$, Gadgets$, Windows$, Events$, Functions$
   Protected GlobalWindow$, GlobalGadget$, EnumWindow$, EnumGadget$
   
   Static JPEGPlugin$, JPEG2000Plugin$, PNGPlugin$, TGAPlugin$, TIFFPlugin$
   Protected *g._s_WIDGET
   Protected *w._s_WIDGET
   Protected *mainWindow._s_WIDGET
   
   ; is *g
   If ListSize( ParseObject( )) 
      If codeindent
         Space$ = Space(codeindent)
      EndIf
      result$ + "EnableExplicit" + #LF$
      
      ForEach ParseObject( )
         *w = ParseObject( )
         Name$ = GetClass( *w )
         Image = GetImage( *w )
         
         ;
         If Not *mainWindow
            If is_window_( *w )
               *mainWindow = *w
            EndIf
         EndIf
         
         ;
         ;\\
         ;
         If Trim( Name$, "#" ) = Name$
            If is_window_( *w )
               GlobalWindow$ + "Global " + Name$ + " = - 1" + #LF$
            Else
               GlobalGadget$ + "Global " + Name$ + " = - 1" + #LF$
            EndIf
         Else
            If is_window_( *w )
               EnumWindow$ + Space$ + Name$ + #LF$
            Else
               EnumGadget$ + Space$ + Name$ + #LF$
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
      Next
      
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
      
      ForEach ParseObject( )
         *g = ParseObject( )
         ;If Not is_window_( *g )
         Events$ = GetEventsString( *g )
         If Events$
            result$ + Code::GenerateBindEventProcedure( 0, Trim( GetClass( *g ), "#" ) , Events$, "" ) 
         EndIf
         ;EndIf
      Next
      
      ForEach ParseObject( )
         *w = ParseObject( )
         If is_window_( *w )
            
            ;\\
            result$ + "Procedure Open_" + Trim( GetClass( *w ), "#" ) + "( )" + #LF$
            
            ;\\ 
            ;result$ + Space(( Level(*w) - Level( *mdi ) ) * codeindent ) 
            result$ + GenerateCODE( *w, "object" ) + #LF$
            
            PushListPosition( ParseObject( ))
            ForEach ParseObject( )
               *g = ParseObject( )
               If IsChild( *g, *w )
                  ;
                  ;result$ + Space((Level(*g) - Level( *mdi )) * codeindent) 
                  result$ + GenerateCODE( *g, "object" ) + #LF$
                  
;                   If ClassFromType( *g\type ) = "Panel"
;                      If Not *g\haschildren
;                         If *g\tabbar
;                            result$ + Space$ + Space( ( Level(*g) - Level( *mdi ) ) * codeindent) + "AddGadgetItem( " + GetClass( *g ) + 
;                                      ", - 1" + 
;                                      ", " + Chr( '"' ) + GetItemText( *g, GetState(*g\tabbar) ) + Chr( '"' ) + 
;                                      " )  " + #LF$
;                            result$ + Space$ + Space( ( Level(*g) - Level( *mdi ) ) * codeindent) + #LF$
;                         EndIf
;                      EndIf
;                   EndIf
                  
               EndIf
            Next
            PopListPosition( ParseObject( ))
            
            
            ;- CLOSE LIST
            ;result$ + Space((Level(*g) - Level( *mdi )) * codeindent)
            result$ + GenerateCODE( *g, "CloseGadgetList" )
            While Not is_window_(*g )
               If IsContainer( *g ) = 3 
                  If codeindent
                     result$ + Space((Level(*g) - parentlevel) * codeindent)
                  EndIf
                  result$ + "CloseGadgetList( ) ; " + GetClass(*g) + #LF$ 
               EndIf 
               *g = *g\parent
            Wend
      
            ;\\
            PushListPosition( ParseObject( ))
            ForEach ParseObject( )
               *g = ParseObject( )
               If IsChild( *g, *w )
                  If GenerateCODE( *g, "STATE" )
                     result$ + Space$ + #LF$
                     Break
                  EndIf
               EndIf
            Next
            PopListPosition( ParseObject( ))
            
            ;\\
            PushListPosition( ParseObject( ))
            ForEach ParseObject( )
               *g = ParseObject( )
               If IsChild( *g, *w )
                  result$ + GenerateCODE( *g, "STATE" )
                  
                  ;        ;     Events$ = GetEventsString( *g )
                  ;        ;     Gadgets$ + GetClassString( *g )
                  ;        ;     
                  ;        ;     If Events$
                  ;        ;       result$ + Code::GenerateBindGadgetEvent( 3, Events$, 0 );Gadgets$ )
                  ;        ;     EndIf
               EndIf
            Next
            PopListPosition( ParseObject( ))
            
            Select *w\Type 
               Case #__type_Window
                  If GetEventsString( *w )
                     result$ + #LF$
                     result$ + Code::GenerateBindEvent( ( Level(*w) - Level( *mdi ) ) * codeindent, GetEventsString( *w ), GetClass( *w ) )
                  EndIf
               Default
            EndSelect
            
            result$ + "EndProcedure" + #LF$
            result$ + #LF$
            
         EndIf
      Next
      
      result$ + "CompilerIf #PB_Compiler_IsMainFile" + #LF$
      ; result$ + "  Open_" + Trim( GetClass( *mainWindow ), "#" ) + "( )" + #lf$
      
      ForEach ParseObject( )
         *w = ParseObject( )
         If is_window_( *w )
            result$ + Space$ + "Open_" + Trim( GetClass( *w ), "#" ) + "( )" + #LF$
         EndIf
      Next
      
      result$ + #LF$
      
      ;result$ + Space$ + ";- MAIN LOOP" + #LF$
      result$ + Space$ + "Define event" + #LF$
      
      result$ + Space$ + "While IsWindow( " + GetClass( *mainWindow ) + " )" + #LF$
      result$ + Space$ + Space$ + "event = WaitWindowEvent( )" + #LF$
      result$ + Space$ + Space$ + "" + #LF$
      result$ + Space$ + Space$ + "Select EventWindow( )" + #LF$
      ForEach ParseObject( )
         *w = ParseObject( )
         If is_window_( *w )
            result$ + Space$ + Space$ + Space$ + "Case " + GetClass( *w ) + #LF$
         EndIf
      Next
      result$ + Space$ + Space$ + "EndSelect" + #LF$
      result$ + Space$ + Space$ + "" + #LF$
      result$ + Space$ + Space$ + "Select event" + #LF$
      result$ + Space$ + Space$ + Space$ + "Case #PB_Event_CloseWindow" + #LF$
      result$ + Space$ + Space$ + Space$ + Space$ + "If " + GetClass( *mainWindow ) + " = EventWindow( )" + #LF$
      result$ + Space$ + Space$ + Space$ + Space$ + Space$ + "If #PB_MessageRequester_Yes = MessageRequester( " + Chr( '"' ) + "Message" + Chr( '"' ) + ", " + #LF$ + 
                Space$ + Space$ + Space$ + Space$ + Space$ + Space(Len("If #PB_MessageRequester_Yes = MessageRequester( ")) + Chr( '"' ) +"Are you sure you want To go out?"+ Chr( '"' ) + ", " + #LF$ + 
                Space$ + Space$ + Space$ + Space$ + Space$ + Space(Len("If #PB_MessageRequester_Yes = MessageRequester( ")) + "#PB_MessageRequester_YesNo | #PB_MessageRequester_Info )" + #LF$
      result$ + Space$ + Space$ + Space$ + Space$ + Space$ + Space$ + "CloseWindow( EventWindow( ) )" + #LF$
      result$ + Space$ + Space$ + Space$ + Space$ + Space$ + "EndIf" + #LF$
      result$ + Space$ + Space$ + Space$ + Space$ + "Else" + #LF$
      result$ + Space$ + Space$ + Space$ + Space$ + Space$ + "CloseWindow( EventWindow( ) )" + #LF$
      result$ + Space$ + Space$ + Space$ + Space$ + "EndIf" + #LF$
      result$ + Space$ + Space$ + "EndSelect" + #LF$
      result$ + Space$ + "Wend" + #LF$ 
      result$ + Space$ + "End" + #LF$
      result$ + "CompilerEndIf"
      
      
      ;   ;   SetClipboardText( result$ )
      ;   
      ;   If IsGadget( IDE_Scintilla_Gadget )
      ;   ScintillaSendMessage( IDE_Scintilla_Gadget, #SCI_SETTEXT, 0, UTF8( result$ ) )
      ;   Else
      ;   SetElementText( IDE_Scintilla_0, result$ )
      ;   EndIf
      ;   
      ; 
      ;   
      ;   
      ; ;   Debug GetCurrentDirectory( )
      ; ;   Protected Name$ = ElementClass( CheckType ) + "_" + Str( CountElementType( CheckType ) )
      ; ;   Debug #PB_Compiler_Home + "Compilers\pbcompiler";Name$  ;     Puth$ = GetCurrentDirectory( ) + "Create_GenerateExample\"
      ; ;                   ;     Debug GetPathPart( Puth$ )
      ; ;                   ;CLI> pbcompiler "C:\Project\Source\DLLSource.pb" /EXEChr( 34 ) + + Chr( 34 )
      ; ;                   ;RunProgram( #PB_Compiler_Home + "/Compilers/pbcompiler", Puth$ + " /QUIET /XP /UNICODE /ADMINISTRATOR /EXE " + ArrayWindow( 0 )\Name$ + ".exe" , GetPathPart( Puth$ ), #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide )
      ; ;   RunProgram( #PB_Compiler_Home + "Compilers\pbcompiler", "/QUIET /XP /ADMINISTRATOR " + "" + Name$ + ".pb /EXE " + Name$ + ".exe", GetCurrentDirectory( ), #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide )
      ; ;   RunProgram( "C:\" + Name$ + ".exe" )
      
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
      
      WINDOW_1 = Window( 10, 300, Width-30, 253, "window_1" ) : SetClass( widget( ), "WINDOW_1")
      ;       BUTTON_8 = Button( 21, 14, 120, 64, "button_8" )
      ;       BUTTON_9 = Button( 21, 91, 120, 71, "button_9" )
      ;       BUTTON_10 = Button( 21, 175, 120, 64, "button_10" )
      ;       
      ;       CONTAINER_0 = Container( 154, 14, 330, 225 )
      ;       BUTTON_11 = Button( 14, 21, 141, 43, "button_11" )
      ;       BUTTON_12 = Button( 14, 77, 141, 71, "button_12" )
      ;       BUTTON_13 = Button( 14, 161, 141, 50, "button_13" )
      ;       
      ;       PANEL_0 = Panel( 168, 21, 148, 183 )
      ;       AddItem( PANEL_0, -1, "tab_0")
      ;       BUTTON_14 = Button( 7, 14, 134, 29, "button_14" )
      ;       AddItem( PANEL_0, -1, "tab_1")
      ;       BUTTON_15 = Button( 7, 56, 134, 71, "button_15" )
      ;       AddItem( PANEL_0, -1, "tab_2")
      ;       BUTTON_16 = Button( 7, 140, 134, 36, "button_16" )
      ;       CloseList( )
      ;       CloseList( )
      
      PANEL_0=Panel(8, 8, 356, 203)
      AddItem(PANEL_0, -1, "Панель 1")
      Button( 10,10,50,30, "1")
      AddItem(PANEL_0, -1, "Панель 2")
      
      PANEL_1=Panel( 5, 30, 340, 166)
      AddItem(PANEL_1, -1, "Под-Панель 1")
      ;Button( 10,10,50,30, "1")
      AddItem(PANEL_1, -1, "Под-Панель 2")
 Button( 10,10,50,30, "2")
     ;       
;       PANEL_2=Panel( 5, 30, 340, 166)
;       AddItem(PANEL_2, -1, "Под-Под-Панель 1")
;       Button( 10,10,50,30, "1")
;       AddItem(PANEL_2, -1, "Под-Под-Панель 2")
;       AddItem(PANEL_2, -1, "Под-Под-Панель 3")
;       AddItem(PANEL_2, -1, "Под-Под-Панель 4")
;       Button( 10,10,50,30, "3")
;       
      AddItem(PANEL_1, -1, "Под-Панель 3")
      AddItem(PANEL_1, -1, "Под-Панель 4")
      ;Button( 10,10,50,30, "3")
      
      AddItem(PANEL_0, -1, "Панель 3")
      AddItem(PANEL_0, -1, "Панель 4")
      Button( 10,10,50,30, "")
      
      
            If PANEL_1
               SetBackgroundColor( PANEL_1, $BA54EDDE )
            EndIf
;       ;
;       R1 = Container(7, 7, 568, 568,  #PB_Container_Single  )
;       R1Y1 = Container(7, 7, 274, 274,  #PB_Container_Single  )
;       
;       R1Y1G1 = Container(7, 7, 127, 127,  #PB_Container_Single  )
;       R1Y1G1B1 = Container(7, 7, 50, 50,  #PB_Container_Single  )
;       R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
;       R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
;       R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
;       CloseList( )
;       R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
;       CloseList( )
;       CloseList( )
;       CloseList( )
;       CloseList( )
;       CloseList( )
;       
;       R1Y1G1 = Container(7, 7, 127, 127,  #PB_Container_Single  )
;       ;                R1Y1G1B1 = Container(7, 7, 50, 50,  #PB_Container_Single  )
;       ;                   R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
;       ;                      R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
;       ;                         R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
;       ;                         CloseList( )
;       ;                         R1Y1G1B1P1 = Container(7, 7, 15, 15,  #PB_Container_Single  )
;       ;                         CloseList( )
;       ;                      CloseList( )
;       ;                   CloseList( )
;       ;                CloseList( )
;       CloseList( )
;       
;       CloseList( )
;       CloseList( )
      
      
      If StartEnum( root( ) )
         AddParseObject( widget( ))
         StopEnum( )
      EndIf
      
   EndIf
   
   Define *root = root( )
   If Open( 1, 0, 0, Width*2, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ResizeWindow( 0, WindowX( 0 ) - WindowWidth( 1 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      ResizeWindow( 1, WindowX( 1 ) + WindowWidth( 0 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      
      Define *g = Editor( 0, 0, 0, 0, #__flag_autosize )
      
      Define code$ = GeneratePBCode( *root )
      
      SetText( *g, code$ )
      Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
   EndIf
   
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1326
; FirstLine = 1187
; Folding = ------------------------+9---3P9---
; EnableXP
; DPIAware