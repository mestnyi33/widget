XIncludeFile "../widgets.pbi"
XIncludeFile "include/code_generate.pbi"

UseWidgets( )


Global NewMap FlagsString.s( )
Global NewMap EventsString.s( )
Global NewMap ImagePuchString.s( )
Global NewMap ClassString.s( )
Global NewList ParseObject( )

Procedure AddParseObject( *this._s_WIDGET )
   LastElement( ParseObject( ) )
   AddElement( ParseObject( ) )
   ParseObject( ) = *this
EndProcedure


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

Procedure$  MakeFunctionName( id$, type$ )
   Protected result$
   
   If Trim( id$, "#" ) <> id$
      If type$ = "Window"
         result$ = "Open" + type$
      Else
         Select type$
            Case "Scroll", "Progress", "Track"
               result$ = type$ + "BarGadget"
            Default
               result$ = type$ + "Gadget"
         EndSelect
      EndIf
      result$ + "( " + id$ + ", "
   Else
      If type$ = "Window"
         result$ = id$+" = Open" + type$
      Else
         Select type$
            Case "Scroll", "Progress", "Track"
               result$ = id$ + " = " + type$ + "BarGadget"
            Default
               result$ = id$ + " = " + type$ + "Gadget"
         EndSelect
      EndIf
      result$ + "( #PB_Any, "
   EndIf
   
   ProcedureReturn result$
EndProcedure

Procedure$  MakeFunctionString( type$, function$, x$, y$, width$, height$, caption$, param1$, param2$, param3$, flag$ ) ; Ok
   Protected result$
   
   Select type$
      Case "Window"        : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ Chr('"') + caption$+Chr('"')                                                                   
      Case "Button"        : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ Chr('"') + caption$+Chr('"')                                                                                 
      Case "String"        : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ Chr('"') + caption$+Chr('"')                                                                                 
      Case "Text"          : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ Chr('"') + caption$+Chr('"')                                                                                   
      Case "CheckBox"      : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ Chr('"') + caption$+Chr('"')                                                                               
      Case "Option"        : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ Chr('"') + caption$+Chr('"')
      Case "Web"           : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ Chr('"') + caption$+Chr('"')
      Case "ExplorerList"  : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ Chr('"') + caption$+Chr('"')                                                                           
      Case "ExplorerTree"  : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ Chr('"') + caption$+Chr('"')                                                                           
      Case "ExplorerCombo" : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ Chr('"') + caption$+Chr('"')                                                                          
      Case "Frame"         : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ Chr('"') + caption$+Chr('"')                                                                                  
         
      Case "HyperLink"     : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ Chr('"') + caption$+Chr('"')+", " + param1$+", " + param2$                                                          
      Case "ListIcon"      : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ Chr('"') + caption$+Chr('"')+", " + param1$+", " + param2$                                                       
         
      Case "ScrollArea"    : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$    
      Case "Scroll", 
           "ScrollBar"     : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$+", " + param3$                                                               
      Case "Progress",
           "ProgressBar"   : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$                                                                       
      Case "Track", 
           "TrackBar"      : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$                                                                                      
      Case "Spin"          : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$                                                                             
      Case "Splitter"      : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$                                                                         
      Case "MDI"           : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$+", " + param2$                                                                              
      Case "Image"         : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$                                                                                                     
      Case "Scintilla"     : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$
      Case "Shortcut"      : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$
      Case "ButtonImage"   : result$ = function$ + x$+", " + y$+", " + width$+", " + height$+", "+ param1$                                                                                                 
         
      Case "ListView"      : result$ = function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                       
      Case "ComboBox"      : result$ = function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                       
      Case "Container"     : result$ = function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                      
      Case "IPAddress"     : result$ = function$ + x$+", " + y$+", " + width$+", " + height$
      Case "Calendar"      : result$ = function$ + x$+", " + y$+", " + width$+", " + height$                                                     
      Case "Editor"        : result$ = function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                          
      Case "Date"          : result$ = function$ + x$+", " + y$+", " + width$+", " + height$               
      Case "Tree"          : result$ = function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                            
      Case "Panel"         : result$ = function$ + x$+", " + y$+", " + width$+", " + height$ 
      Case "Canvas"        : result$ = function$ + x$+", " + y$+", " + width$+", " + height$                                                                                                                          
   EndSelect
   
   Select type$
      Case "ScrollArea"    
         If param3$ : result$ +", " + param3$ : EndIf     
      Case "Calendar"
         If param1$ : result$ +", " + param1$ : EndIf 
      Case "Date"         
         If caption$ : result$ +", "+ Chr('"') + caption$+Chr('"') : EndIf
         If param1$ : result$ +", " + param1$ : EndIf 
   EndSelect
   
   If flag$
      Select type$
         Case "Window", 
              "Scroll", "Track", "Progress", "Spin", "Web", "OpenGL",
              "Text", "String", "Editor", "Button", "CheckBox", "HyperLink", 
              "Tree", "ListIcon", "ListView", "ComboBox", "Image", "ButtonImage",
              "Date", "Calendar", "ExplorerCombo", "ExplorerList", "ExplorerTree",
              "Container", "ScrollArea", "Splitter", "MDI", "Canvas", "Frame"  
            
            result$ +", " + flag$ 
      EndSelect
   EndIf
   
   result$ + " )" 
   
   ProcedureReturn result$
EndProcedure


Procedure$  MakeObjectString( *g._s_WIDGET, space$ )
   Protected result$, x$, y$, width$, height$, caption$, param1$, param2$, param3$, flag$
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
         
         caption$ = GetText( *g )
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
      Case "Scroll"     : param3$ = Str( GetAttribute( *g, #PB_ScrollBar_PageLength ))
      Case "ScrollArea" : param3$ = Str( GetAttribute( *g, #PB_ScrollArea_ScrollStep ))
   EndSelect
   
   ; Flags
   Select type$
      Case "Panel", "Web", "IPAddress", "Option", "Scintilla", "Shortcut"
      Default
         Flag$ = MakeFlagString( type$, *g\flag )
   EndSelect
   
   ; close list
   If *g\BeforeWidget( )
      If IsContainer( *g\BeforeWidget( ) ) > 0 
         If Not is_window_( *g\BeforeWidget( ) )
            If *g\BeforeWidget( )\LastWidget( )
               If IsContainer( *g\BeforeWidget( )\LastWidget( ) ) > 0 
                  If Not is_window_( *g\BeforeWidget( )\LastWidget( ) )
                     ; Debug ""+*g\BeforeWidget( )\LastWidget( )\class +" "+ *g\class
                     If *g\BeforeWidget( )\LastWidget( )\parent <> *g\parent
                        result$ + space$ +"   "+ "CloseGadgetList" + "( )" + #CRLF$ 
                     EndIf
                  EndIf
               EndIf 
            EndIf
            
            result$ + space$ + "CloseGadgetList" + "( )" + #CRLF$ 
            result$ + space$ + #CRLF$
         EndIf
      Else
         ;\\
         If IsContainer(*g) > 0 
            If Not is_window_( *g )
               result$ + space$ + #CRLF$
            EndIf
         EndIf 
      EndIf
   EndIf
   
   result$ + space$ + MakeFunctionString( type$, MakeFunctionName( id$, type$ ), x$, y$, width$, height$, caption$, param1$,param2$,param3$, flag$ )
   
   ProcedureReturn result$
EndProcedure

;- 
Procedure.s GenerateCODE( *this._s_WIDGET, FUNCTION$, Space$ = "" )
   Protected Result$, ID$, param1$, param2$, param3$, Text$, flag$, Class$, Name$
   Static TabIndex =- 1
   If Not *this
      ProcedureReturn ""
   EndIf
   
   If Not *this\parent
      ProcedureReturn ""
   EndIf
   
   If FUNCTION$ = "CloseGadgetList"
      If IsContainer( *this ) > 0 
         If Not is_window_( *this )
            Result$ + Space$ + FUNCTION$ + "( )" + #CRLF$
         EndIf
      EndIf 
   EndIf
   
   If FUNCTION$ = "AddGadgetItem"
      If *this\parent\tabbar
         If TabIndex <> *this\TabIndex( ) 
            TabIndex = *this\TabIndex( ) 
            
            Result$ + FUNCTION$ + "( " + GetClass( *this\parent ) + 
                      ", - 1" + 
                      ", " + Chr( '"' ) + GetItemText( *this\parent, TabIndex ) + Chr( '"' ) + 
                      " )  " + #CRLF$
            
            Result$ + Space$
         EndIf
      EndIf
      If *this\tabbar
         If TabIndex <> *this\TabIndex( ) 
            TabIndex = *this\TabIndex( ) 
            
            Result$ + FUNCTION$ + "( " + GetClass( *this ) + 
                      ", - 1" + 
                      ", " + Chr( '"' ) + GetItemText( *this, TabIndex ) + Chr( '"' ) + 
                      " )  " + #CRLF$
            
            Result$ + Space$
         EndIf
      EndIf
   EndIf
   
   
   If FUNCTION$ = "STATE"
      Name$ = GetClass( *this )
      ;
      If Hide( *this)
         Result$ + Space$ + "HideGadget( " + Name$ + ", #True )" + #CRLF$
      EndIf
      If Disable( *this)
         Result$ + Space$ + "DisableGadget( " + Name$ + ", #True )" + #CRLF$
      EndIf
      If GetState( *this) > 0
         Result$ + Space$ + "SetGadgetState( " + Name$ + ", "+ GetState( *this) + " )" + #CRLF$
      Else
         ; Это для тех кто гаджетов которые принимают [0]
         Select *this\Type 
            Case #__type_Panel
               If GetState( *this) = 0
                  Result$ + Space$ + "SetGadgetState( " + Name$ + ", "+ GetState( *this) + " )" + #CRLF$
               EndIf
         EndSelect
      EndIf
   EndIf
   
   If FUNCTION$ = "FUNCTION"
      ;flag$ = FlagFromFlag( *this\type, *this\flag )
      Class$ = GetClassString( *this )
      Name$ = GetClass( *this )
      Result$ + Space$
      
      ; Debug "--- "+Name$
      ;    Select Asc( Class$ )
      ;       Case '#'        : ID$ = Class$              
      ;       Case '0' To '9' : ID$ = Chr( Asc( Class$ ) ) 
      ;       Default         : ID$ = "#PB_Any"             
      ;    EndSelect
      ;    
      
      ;\\ close last list
      If *this\BeforeWidget( )
         Result$ + GenerateCODE( *this\BeforeWidget( ), "CloseGadgetList" )
;          If IsContainer( *this\BeforeWidget( ) ) > 0 
;             If Not is_window_( *this\BeforeWidget( ) )
;                Result$ + Space$ + "CloseGadgetList" + "( )" + #CRLF$
;             EndIf
;          EndIf 
         ;\\
         If IsContainer(*this) > 0 
            If Not is_window_( *this )
               Result$ + Space$ + #CRLF$
               Result$ + Space$ 
            EndIf
         EndIf
      EndIf
      
      ;\\ add parent item
      Result$ + GenerateCODE( *this, "AddGadgetItem", Space$ ) 
   EndIf
   
   ProcedureReturn Result$
EndProcedure

Procedure.s GeneratePBCode( *parent._s_WIDGET, Space = 3 )
   Protected Type
   Protected Count
   Protected Image
   Protected Parent
   Protected Space$ = Space(space)
   Protected Name$, Class$, Code$, FormWindow$, FormGadget$, Gadgets$, Windows$, Events$, Functions$
   Static JPEGPlugin$, JPEG2000Plugin$, PNGPlugin$, TGAPlugin$, TIFFPlugin$
   Protected *g._s_WIDGET
   Protected *w._s_WIDGET
   Protected *mainWindow._s_WIDGET
   
   ; is *g
   If ListSize( ParseObject( )) 
      Code$ + "EnableExplicit" + #CRLF$ + #CRLF$
      
      ForEach ParseObject( )
         Image = GetImage( ParseObject( ) )
         
         ;UseIMAGEDecoder
         If IsImage( Image )
            Select ImageFormat( Image )
               Case #PB_ImagePlugin_JPEG
                  If JPEGPlugin$ <> "UseJPEGImageDecoder( )"
                     JPEGPlugin$ = "UseJPEGImageDecoder( )"
                     Code$ + "UseJPEGImageDecoder( )" + #CRLF$
                  EndIf
               Case #PB_ImagePlugin_JPEG2000
                  If JPEG2000Plugin$ <> "UseJPEG2000ImageDecoder( )"
                     JPEG2000Plugin$ = "UseJPEG2000ImageDecoder( )"
                     Code$ + "UseJPEG2000ImageDecoder( )" + #CRLF$
                  EndIf
               Case #PB_ImagePlugin_PNG
                  If PNGPlugin$ <> "UsePNGImageDecoder( )"
                     PNGPlugin$ = "UsePNGImageDecoder( )"
                     Code$ + "UsePNGImageDecoder( )" + #CRLF$
                  EndIf
               Case #PB_ImagePlugin_TGA
                  If TGAPlugin$ <> "UseTGAImageDecoder( )"
                     TGAPlugin$ = "UseTGAImageDecoder( )"
                     Code$ + "UseTGAImageDecoder( )" + #CRLF$
                  EndIf
               Case #PB_ImagePlugin_TIFF
                  If TIFFPlugin$ <> "UseTIFFImageDecoder( )"
                     TIFFPlugin$ = "UseTIFFImageDecoder( )"
                     Code$ + "UseTIFFImageDecoder( )" + #CRLF$
                  EndIf
               Case #PB_ImagePlugin_BMP
                  
               Case #PB_ImagePlugin_ICON
                  
            EndSelect
            
            Code$ + "LoadImage( " + Image + ", " + #DQUOTE$ + ImagePuchString( Str( Image ) ) + #DQUOTE$ + " )" + #CRLF$
         EndIf
      Next
      
      ; global var windows
      ForEach ParseObject( )
         *w = ParseObject( )
         If is_window_( *w )
            Name$ = GetClass( *w )
            If Trim( Name$, "#" ) = Name$
               Code$ + "Global " + Name$ + " = - 1" + #CRLF$
            Else
               FormWindow$ + Name$ + #CRLF$
            EndIf
         EndIf
      Next
      
      ; enumeration windows
      If FormWindow$
         Code$ + "Enumeration FormWindow" + #CRLF$
         Code$ + Space$ + FormWindow$
         Code$ + "EndEnumeration" + #CRLF$
      EndIf
      
      Code$ + #CRLF$
      
      ; global var gadgets
      ForEach ParseObject( )
         *g = ParseObject( )
         If Not is_window_(*g )
            Name$ = GetClass( *g )
            If Trim( Name$, "#" ) = Name$
               Code$ + "Global " + Name$ + " = - 1" + #CRLF$
            Else
               FormGadget$ + Name$ + #CRLF$
            EndIf
         EndIf
      Next
      
      ; enumeration gadgets
      If FormGadget$
         Code$ + "Enumeration FormGadget" + #CRLF$
         Code$ + Space$ + FormGadget$
         Code$ + "EndEnumeration" + #CRLF$
      EndIf
      
      Code$ + #CRLF$
      
      ForEach ParseObject( )
         *g = ParseObject( )
         ;If Not is_window_( *g )
         Events$ = GetEventsString( *g )
         If Events$
            Code$ + Code::GenerateBindEventProcedure( 0, Trim( GetClass( *g ), "#" ) , Events$, "" ) 
         EndIf
         ;EndIf
      Next
      
      ForEach ParseObject( )
         *w = ParseObject( )
         If is_window_( *w )
            If Not *mainWindow
               *mainWindow = *w
            EndIf
            
            ;\\
            Code$ + "Procedure Open_" + Trim( GetClass( *w ), "#" ) + "( )" + #CRLF$
            
            ;\\ 
            ; Code$ + GenerateCODE( *w, "FUNCTION", Space( ( Level(*w) - Level(*parent) ) * space) ) + #CRLF$
            Code$ + MakeObjectString( *w, Space( ( Level(*w) - Level(*parent) ) * space )) + #CRLF$
            
            PushListPosition( ParseObject( ))
            ForEach ParseObject( )
               *g = ParseObject( )
               If IsChild( *g, *w )
                  ; Code$ + GenerateCODE( *g, "FUNCTION", Space( ( Level(*g) - Level(*parent) ) * space) ) + #CRLF$
                  Code$ + MakeObjectString( *g, Space( ( Level(*g) - Level(*parent) ) * space )) + #CRLF$
               EndIf
            Next
            PopListPosition( ParseObject( ))
            
            ;\\
;             If *parent\LastWidget( ) And 
;                *parent\LastWidget( )\LastWidget( )
;                Debug *parent\LastWidget( )\LastWidget( )\class
;                Code$ + GenerateCODE( *parent\LastWidget( )\LastWidget( ), "CloseGadgetList", Space( ( Level(*parent\LastWidget( )\LastWidget( )) - Level(*parent) ) * space) )
;             EndIf
            If *w\LastWidget( ) And 
               *w\LastWidget( )\LastWidget( )
               ; Debug *w\LastWidget( )\LastWidget( )\class
               Code$ + GenerateCODE( *w\LastWidget( )\LastWidget( ), "CloseGadgetList", Space( ( Level(*w\LastWidget( )\LastWidget( )) - Level(*parent) ) * space) )
               Code$ + GenerateCODE( *w\LastWidget( ), "CloseGadgetList", Space( ( Level(*w\LastWidget( )) - Level(*parent) ) * space) )
            EndIf
            
            ;\\
            PushListPosition( ParseObject( ))
            ForEach ParseObject( )
               *g = ParseObject( )
               If IsChild( *g, *w )
                  If GenerateCODE( *g, "STATE" )
                     Code$ + Space$ + #CRLF$
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
                  Code$ + GenerateCODE( *g, "STATE", Space$ + Space( ( Level(*g) - Level(*parent) ) * space) )
                  
                  
                  ;        ;     Events$ = GetEventsString( *g )
                  ;        ;     Gadgets$ + GetClassString( *g )
                  ;        ;     
                  ;        ;     If Events$
                  ;        ;       Code$ + Code::GenerateBindGadgetEvent( 3, Events$, 0 );Gadgets$ )
                  ;        ;     EndIf
               EndIf
            Next
            PopListPosition( ParseObject( ))
            
            Select *w\Type 
               Case #__type_Window
                  If GetEventsString( *w )
                     Code$ + #CRLF$
                     Code$ + Code::GenerateBindEvent( ( Level(*w) - Level(*parent) ) * space, GetEventsString( *w ), GetClass( *w ) )
                  EndIf
               Default
            EndSelect
            
            Code$ + "EndProcedure" + #CRLF$
            Code$ + #CRLF$
            
         EndIf
      Next
      
      Code$ + "CompilerIf #PB_Compiler_IsMainFile" + #CRLF$
      ; Code$ + "  Open_" + Trim( GetClass( *mainWindow ), "#" ) + "( )" + #CRLF$
      
      ForEach ParseObject( )
         *w = ParseObject( )
         If is_window_( *w )
            Code$ + Space$ + "Open_" + Trim( GetClass( *w ), "#" ) + "( )" + #CRLF$
         EndIf
      Next
      
      Code$ + #CRLF$
      
      Code$ + Space$ + "Define event" + #CRLF$
      
      Code$ + Space$ + "While IsWindow( " + GetClass( *mainWindow ) + " )" + #CRLF$
      Code$ + Space$ + Space$ + "event = WaitWindowEvent( )" + #CRLF$
      Code$ + Space$ + Space$ + "" + #CRLF$
      Code$ + Space$ + Space$ + "Select EventWindow( )" + #CRLF$
      ForEach ParseObject( )
         *w = ParseObject( )
         If is_window_( *w )
            Code$ + Space$ + Space$ + Space$ + "Case " + GetClass( *w ) + #CRLF$
         EndIf
      Next
      Code$ + Space$ + Space$ + "EndSelect" + #CRLF$
      Code$ + Space$ + Space$ + "" + #CRLF$
      Code$ + Space$ + Space$ + "Select event" + #CRLF$
      Code$ + Space$ + Space$ + Space$ + "Case #PB_Event_CloseWindow" + #CRLF$
      Code$ + Space$ + Space$ + Space$ + Space$ + "If " + GetClass( *mainWindow ) + " = EventWindow( )" + #CRLF$
      Code$ + Space$ + Space$ + Space$ + Space$ + Space$ + "If #PB_MessageRequester_Yes = MessageRequester( " + Chr( '"' ) + "Message" + Chr( '"' ) + ", " + #CRLF$ + 
              Space$ + Space$ + Space$ + Space$ + Space$ + Space(Len("If #PB_MessageRequester_Yes = MessageRequester( ")) + Chr( '"' ) +"Are you sure you want To go out?"+ Chr( '"' ) + ", " + #CRLF$ + 
              Space$ + Space$ + Space$ + Space$ + Space$ + Space(Len("If #PB_MessageRequester_Yes = MessageRequester( ")) + "#PB_MessageRequester_YesNo | #PB_MessageRequester_Info )" + #CRLF$
      Code$ + Space$ + Space$ + Space$ + Space$ + Space$ + Space$ + "CloseWindow( EventWindow( ) )" + #CRLF$
      Code$ + Space$ + Space$ + Space$ + Space$ + Space$ + "EndIf" + #CRLF$
      Code$ + Space$ + Space$ + Space$ + Space$ + "Else" + #CRLF$
      Code$ + Space$ + Space$ + Space$ + Space$ + Space$ + "CloseWindow( EventWindow( ) )" + #CRLF$
      Code$ + Space$ + Space$ + Space$ + Space$ + "EndIf" + #CRLF$
      Code$ + Space$ + Space$ + "EndSelect" + #CRLF$
      Code$ + Space$ + "Wend" + #CRLF$ 
      Code$ + Space$ + "End" + #CRLF$
      Code$ + "CompilerEndIf" + #CRLF$
      
      
      Code$ + #CRLF$ + #CRLF$
      
      ;   ;   SetClipboardText( Code$ )
      ;   
      ;   If IsGadget( IDE_Scintilla_Gadget )
      ;   ScintillaSendMessage( IDE_Scintilla_Gadget, #SCI_SETTEXT, 0, UTF8( Code$ ) )
      ;   Else
      ;   SetElementText( IDE_Scintilla_0, Code$ )
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
   
   ProcedureReturn code$
EndProcedure

;- 
CompilerIf #PB_Compiler_IsMainFile
   DisableExplicit
   
   If Open( 0, 0, 0, 322, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
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
      
      WINDOW_1 = Window( -70, 300, 498, 253, "window_1" ) : SetClass( widget( ), "WINDOW_1")
      BUTTON_8 = Button( 21, 14, 120, 64, "button_8" )
      BUTTON_9 = Button( 21, 91, 120, 71, "button_9" )
      BUTTON_10 = Button( 21, 175, 120, 64, "button_10" )
      
      CONTAINER_0 = Container( 154, 14, 330, 225 )
      BUTTON_11 = Button( 14, 21, 141, 43, "button_11" )
      BUTTON_12 = Button( 14, 77, 141, 71, "button_12" )
      BUTTON_13 = Button( 14, 161, 141, 50, "button_13" )
      
      CONTAINER_1 = Container( 168, 21, 148, 183 )
      BUTTON_14 = Button( 7, 14, 134, 29, "button_14" )
      BUTTON_15 = Button( 7, 56, 134, 71, "button_15" )
      BUTTON_16 = Button( 7, 140, 134, 36, "button_16" )
      CloseList( )
      CloseList( )
      
      
      If StartEnum( root( ) )
         AddParseObject( widget( ))
         StopEnum( )
      EndIf
      
      
      
      ;   Debug " - - - enumerate all widgets - - - "
      ;   If StartEnum( root( ) )
      ;    If is_window_( widget( ) )
      ;     Debug "   window " + Index( widget( ) )
      ;    Else
      ;     Debug "   gadget - " + Index( widget( ) )
      ;    EndIf
      ;    StopEnum( )
      ;   EndIf
      ;   
      ;   Debug " - - - enumerate all gadgets - - - "
      ;   If StartEnum( root( ) )
      ;    If Not is_window_( widget( ) )
      ;     Debug "   gadget - " + Index( widget( ) )
      ;    EndIf
      ;    StopEnum( )
      ;   EndIf
      ;   
      ;   Debug " - - - enumerate all windows - - - "
      ;   If StartEnum( root( ) )
      ;    If is_window_( widget( ) )
      ;     Debug "   window " + Index( widget( ) )
      ;    EndIf
      ;    StopEnum( )
      ;   EndIf
      ;   
      ;   Define Index = 12
      ;   *parent = ID( Index )
      ;   
      ;   Debug " - - - enumerate all ( window=" + Str( Index ) + " ) gadgets - - - "
      ;   If StartEnum( *parent )
      ;    Debug "   gadget - " + Index( widget( ) )
      ;    StopEnum( )
      ;   EndIf
      ;   
      ;   Index = 13
      ;   *parent = ID( Index )
      ;   Define item = 1
      ;   
      ;   Debug " - - - enumerate all ( gadget=" + Str( Index ) + " ) ( item=" + Str( item ) + " ) gadgets - - - "
      ;   If StartEnum( *parent, item )
      ;    Debug "   gadget - " + Index( widget( ) )
      ;    StopEnum( )
      ;   EndIf
      
   EndIf
   
   Define *root = root( )
   If Open( 1, 0, 0, 322, 600, "enumeration widgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      ResizeWindow( 0, WindowX( 0 ) - WindowWidth( 0 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      ResizeWindow( 1, WindowX( 1 ) + WindowWidth( 1 )/2, #PB_Ignore, #PB_Ignore, #PB_Ignore )
      
      Define *g = Editor( 0, 0, 0, 0, #__flag_autosize )
      
      Define code$ = GeneratePBCode( *root )
      
      SetText( *g, code$ )
      Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
   EndIf
   
   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 671
; FirstLine = 601
; Folding = ----------0-f------8-----
; EnableXP
; DPIAware