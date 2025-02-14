IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global *this._s_widget, i, w_type, w_flag
  Define vert=100, horiz=100, Width=400, Height=400
  Define cr.s = #LF$, Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  
  
  Procedure GadgetTypeFromClass(Class.s) ;Returns gadget type from gadget name
    
    ;   ElseIf     FindString(Class.S, LCase("Desktop")       ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Desktop
    ;   ElseIf FindString(Class.S, LCase("PopupMenu")     ,-1,#PB_String_NoCase) :ProcedureReturn #__type_PopupBar
    ;   ElseIf FindString(Class.S, LCase("Toolbar")       ,-1,#PB_String_NoCase) :ProcedureReturn #__type_ToolBar
    ;   ElseIf FindString(Class.S, LCase("Menu")          ,-1,#PB_String_NoCase) :ProcedureReturn #__type_MenuBar
    ;   ElseIf FindString(Class.S, LCase("Status")        ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_StatusBar
    If FindString(Class.S, LCase("Window")        ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Window
    ElseIf FindString(Class.S, LCase("ButtonImage")   ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ButtonImage
    ElseIf FindString(Class.S, LCase("String")        ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_String
    ElseIf FindString(Class.S, LCase("Text")          ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Text
    ElseIf FindString(Class.S, LCase("CheckBox")      ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_CheckBox
    ElseIf FindString(Class.S, LCase("Option")        ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Option
    ElseIf FindString(Class.S, LCase("ListView")      ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ListView
    ElseIf FindString(Class.S, LCase("Frame")         ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Frame  
    ElseIf FindString(Class.S, LCase("ComboBox")      ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ComboBox
    ElseIf FindString(Class.S, LCase("Image")         ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Image
    ElseIf FindString(Class.S, LCase("HyperLink")     ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_HyperLink
    ElseIf FindString(Class.S, LCase("Container")     ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Container
    ElseIf FindString(Class.S, LCase("ListIcon")      ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ListIcon
    ElseIf FindString(Class.S, LCase("IPAddress")     ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_IPAddress
    ElseIf FindString(Class.S, LCase("ProgressBar")   ,-1,#PB_String_NoCase) :ProcedureReturn #__type_Progress
    ElseIf FindString(Class.S, LCase("ScrollBar")     ,-1,#PB_String_NoCase) :ProcedureReturn #__type_Scroll
    ElseIf FindString(Class.S, LCase("ScrollArea")    ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ScrollArea
    ElseIf FindString(Class.S, LCase("TrackBar")      ,-1,#PB_String_NoCase) :ProcedureReturn #__type_Track
    ElseIf FindString(Class.S, LCase("Web")           ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Web
    ElseIf FindString(Class.S, LCase("Button")        ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Button
    ElseIf FindString(Class.S, LCase("Calendar")      ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Calendar
    ElseIf FindString(Class.S, LCase("Date")          ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Date
    ElseIf FindString(Class.S, LCase("Editor")        ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Editor
    ElseIf FindString(Class.S, LCase("ExplorerList")  ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ExplorerList
    ElseIf FindString(Class.S, LCase("ExplorerTree")  ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ExplorerTree
    ElseIf FindString(Class.S, LCase("ExplorerCombo") ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ExplorerCombo
    ElseIf FindString(Class.S, LCase("Spin")          ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Spin
    ElseIf FindString(Class.S, LCase("Tree")          ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Tree
    ElseIf FindString(Class.S, LCase("Panel")         ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Panel
    ElseIf FindString(Class.S, LCase("Splitter")      ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Splitter
    ElseIf FindString(Class.S, LCase("MDI")           ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_MDI
    ElseIf FindString(Class.S, LCase("Scintilla")     ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Scintilla
    ;ElseIf FindString(Class.S, LCase("Shortcut")      ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Shortcut
    ;ElseIf FindString(Class.S, LCase("Canvas")        ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Canvas
    EndIf
    
    ProcedureReturn #False
  EndProcedure
  
  Procedure.s FlagFromType( Type ) ; 
    Protected Flags.S
    
    Select Type
      Case #__Type_Window        
        ;{- Ok
        Flags.S = "#PB_Window_TitleBar|"+
                  "#PB_Window_BorderLess|"+
                  "#PB_Window_SystemMenu|"+
                  "#PB_Window_MaximizeGadget|"+
                  "#PB_Window_MinimizeGadget|"+
                  "#PB_Window_ScreenCentered|"+
                  "#PB_Window_SizeGadget|"+
                  "#PB_Window_WindowCentered|"+
                  "#PB_Window_Tool|"+
                  "#PB_Window_Normal|"+
                  "#PB_Window_Minimize|"+
                  "#PB_Window_Maximize|"+
                  "#PB_Window_Invisible|"+
                  "#PB_Window_NoActivate|"+
                  "#PB_Window_NoGadgets|"
        ;}
        
      Case #__Type_Button         
        ;{- Ok
        Flags.S = "#PB_Button_Default|"+
                  "#__flag_ButtonToggle|"+
                  "#PB_Button_Left|"+
                  "#PB_Button_Center|"+
                  "#PB_Button_Right|"+
                  "#PB_Button_MultiLine"
        
        ;}
        
      Case #__Type_String         
        ;{- Ok
        Flags.S = "#PB_String_BorderLess|"+
                  "#PB_String_Numeric|"+
                  "#PB_String_Password|"+
                  "#PB_String_ReadOnly|"+
                  "#PB_String_LowerCase|"+
                  "#PB_String_UpperCase"
        
        ;}
        
      Case #__Type_Text           
        ;{- Ok
        Flags.S = "#PB_Text_Left|"+
                  "#PB_Text_Center|"+
                  "#PB_Text_Right|"+
                  "#PB_Text_Border"
        ;}
        
      Case #__Type_CheckBox       
        ;{- Ok
        Flags.S = "#PB_CheckBox_Right|"+
                  "#PB_CheckBox_Center|"+
                  "#PB_CheckBox_ThreeState"
        ;}
        
      Case #__Type_Option         
        Flags.S = ""
        
      Case #__Type_ListView       
        ;{- Ok
        Flags.S = "#PB_ListView_Multiselect|"+
                  "#PB_ListView_ClickSelect"
        ;}
        
      Case #__Type_Frame          
        ;{- Ok
        Flags.S = "#PB_Frame_Single|"+
                  "#PB_Frame_Double|"+
                  "#PB_Frame_Flat"
        ;}
        
      Case #__Type_ComboBox       
        ;{- Ok
        Flags.S = "#PB_ComboBox_Editable|"+
                  "#PB_ComboBox_LowerCase|"+
                  "#PB_ComboBox_UpperCase|"+
                  "#PB_ComboBox_Image"
        ;}
        
      Case #__Type_Image          
        ;{- Ok
        Flags.S = "#PB_Image_Border|"+
                  "#PB_Image_Raised"
        ;}
        
      Case #__Type_HyperLink      
        ;{- Ok
        Flags.S = "#PB_Hyperlink_Underline"
        ;}
        
      Case #__Type_Container      
        ;{- Ok
        Flags.S = "#PB_Container_BorderLess|"+
                  "#PB_Container_Flat|"+
                  "#PB_Container_Raised|"+
                  "#PB_Container_Single|"+
                  "#PB_Container_Double"
        ;}
        
      Case #__Type_ListIcon       
        ;{- Ok
        Flags.S = "#PB_ListIcon_CheckBoxes|"+
                  "#PB_ListIcon_ThreeState|"+
                  "#PB_ListIcon_MultiSelect|"+
                  "#PB_ListIcon_GridLines|"+
                  "#PB_ListIcon_FullRowSelect|"+
                  "#PB_ListIcon_HeaderDragDrop|"+
                  "#PB_ListIcon_AlwaysShowSelection"
        ;}
        
      Case #__Type_IPAddress      
        Flags.S = ""
        
      Case #__type_Progress    
        ;{- Ok
        Flags.S = "#PB_ProgressBar_Smooth|"+
                  "#PB_ProgressBar_Vertical"
        ;}
        
      Case #__type_Scroll      
        ;{- Ok
        Flags.S = "#PB_ScrollBar_Vertical"
        ;}
        
      Case #__Type_ScrollArea     
        ;{- Ok
        Flags.S = "#PB_ScrollArea_Flat|"+
                  "#PB_ScrollArea_Raised|"+
                  "#PB_ScrollArea_Single|"+
                  "#PB_ScrollArea_BorderLess|"+
                  "#PB_ScrollArea_Center"
        ;}
        
      Case #__type_Track       
        ;{- Ok
        Flags.S = "#PB_TrackBar_Ticks|"+
                  "#PB_TrackBar_Vertical"
        ;}
        
      Case #__Type_Web            
        Flags.S = ""
        
      Case #__Type_ButtonImage    
        ;{- Ok
        Flags.S = "#__flag_ButtonToggle"
        ;}
        
      Case #__Type_Calendar       
        ;{- Ok
        Flags.S = "#PB_Calendar_Borderless"
        ;}
        
      Case #__Type_Date           
        ;{- Ok
        Flags.S = "#PB_Date_UpDown"
        ;}
        
      Case #__Type_Editor         
        ;{- Ok
        Flags.S = "#PB_Editor_ReadOnly|"+
                  "#PB_Editor_WordWrap"
        ;}
        
      Case #__Type_ExplorerList   
        ;{- Ok
        Flags.S = "#PB_Explorer_BorderLess|"+
                  "#PB_Explorer_AlwaysShowSelection|"+
                  "#PB_Explorer_MultiSelect|"+
                  "#PB_Explorer_GridLines|"+
                  "#PB_Explorer_HeaderDragDrop|"+
                  "#PB_Explorer_FullRowSelect|"+
                  "#PB_Explorer_NoFiles|"+
                  "#PB_Explorer_NoFolders|"+
                  "#PB_Explorer_NoParentFolder|"+
                  "#PB_Explorer_NoDirectoryChange|"+
                  "#PB_Explorer_NoDriveRequester|"+
                  "#PB_Explorer_NoSort|"+
                  "#PB_Explorer_NoMyDocuments|"+
                  "#PB_Explorer_AutoSort|"+
                  "#PB_Explorer_HiddenFiles"
        ;}
        
      Case #__Type_ExplorerTree   
        Flags.S = ""
        
      Case #__Type_ExplorerCombo  
        Flags.S = ""
        
      Case #__Type_Spin           
        Flags.S = ""
        
      Case #__Type_Tree           
        ;{- Ok
        Flags.S = "#PB_Tree_AlwaysShowSelection|"+
                  "#PB_Tree_NoLines|"+
                  "#PB_Tree_NoButtons|"+
                  "#PB_Tree_CheckBoxes|"+
                  "#PB_Tree_ThreeState"
        ;}
        
      Case #__Type_Panel          
        Flags.S = ""
        
      Case #__Type_Splitter       
        ;{- Ok
        Flags.S = "#PB_Splitter_Vertical|"+
                  "#PB_Splitter_Separator|"+
                  "#PB_Splitter_FirstFixed|"+
                  "#PB_Splitter_SecondFixed" 
        ;}
        
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        Case #__Type_MDI           
          Flags.S = ""
        CompilerEndIf
        
      Case #__Type_Scintilla      
        Flags.S = ""
        
;       Case #__Type_Shortcut       
;         Flags.S = ""
;         
;       Case #__Type_Canvas 
;         ;{- Ok
;         Flags.S = "#PB_Canvas_Border|"+
;                   "#PB_Canvas_Container|"+
;                   "#PB_Canvas_ClipMouse|"+
;                   "#PB_Canvas_Keyboard|"+
;                   "#PB_Canvas_DrawFocus"
        ;}
        
    EndSelect
    
    ProcedureReturn Flags.S
  EndProcedure
  
  Procedure.s FlagFromFlag( Type, flag.i ) ; 
    Protected flags.S
    
    Select Type
      Case #PB_GadgetType_Text
        If flag & #__text_Center
          flags + "#PB_Text_Center|"
        EndIf
        If flag & #__text_Right
          flags + "#PB_Button_Right|"
        EndIf
        If flag & #__flag_borderflat
          flags + "#PB_Text_Border|"
        EndIf
        
      Case #PB_GadgetType_Button
        If flag & #__text_left
          flags + "#PB_Button_Left|"
        EndIf
        If flag & #__text_Right
          flags + "#PB_Button_Right|"
        EndIf
        If flag & #__flag_Textmultiline
          flags + "#PB_Button_MultiLine|"
        EndIf
        If flag & #__flag_ButtonToggle
          flags + "#__flag_ButtonToggle|"
        EndIf
        If flag & #__flag_ButtonDefault
          flags + "#PB_Button_Default|"
        EndIf
        
        
    EndSelect
    
    ProcedureReturn Trim(flags, "|")
  EndProcedure
  
  Procedure Add(Text.s)
    If Text
      Protected i, sublevel, String.s, count = CountString(Text,"|")
      
      ClearItems(w_flag)
      
      For I = 0 To count
        String = Trim(StringField(Text,(I+1),"|"))
        
        Select LCase(Trim(StringField(String,(3),"_")))
          Case "left" : sublevel = 1
          Case "right" : sublevel = 1
          Case "center" : sublevel = 1
          Default
            sublevel = 0
        EndSelect
        
        AddItem(w_flag, -1, String, -1, sublevel)
        
      Next
    EndIf 
  EndProcedure
  
  Procedure$ GetCheckedText(Gadget)
    Protected i, Result$, CountItems = CountItems(Gadget)
    
    For i = 0 To CountItems - 1
      If GetItemState(Gadget, i) & #PB_Tree_Checked  
        Result$ + GetItemText(Gadget, i)+"|"
      EndIf
    Next
    
    ProcedureReturn Trim(Result$, "|")
  EndProcedure
  
  Procedure SetCheckedText(Gadget, Text$)
    Protected i,ii
    Protected CountItems = CountItems(Gadget)
    Protected CountString = CountString(Text$, "|")
    
    For i = 0 To CountString
      For ii = 0 To CountItems - 1
        If GetItemText(Gadget, ii) = Trim( StringField( Text$, (i + (1)), "|"))
          SetItemState(Gadget, ii, #PB_Tree_Checked) 
        EndIf
      Next
    Next
    
  EndProcedure
  
  Procedure.q GetFlag(Flags$)
    Protected i, Flag.q
    
    If Flags$
      For I = 0 To CountString(Flags$,"|")
        
        Select Trim(StringField(Flags$,(I+1),"|"))
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
          Case "#PB_Button_Default"                 : Flag = Flag | #__flag_ButtonDefault
          Case "#PB_Button_Left"                    : Flag = Flag | #__text_left
          Case "#PB_Button_MultiLine"               : Flag = Flag | #__flag_Textmultiline
          Case "#PB_Button_Right"                   : Flag = Flag | #__text_Right
          Case "#PB_Button_Center"                  : Flag = Flag | #__text_Center
          Case "#__flag_ButtonToggle"                  : Flag = Flag | #__flag_ButtonToggle
            ; string
          Case "#PB_String_BorderLess"              : Flag = Flag | #PB_String_BorderLess
          Case "#PB_String_LowerCase"               : Flag = Flag | #PB_String_LowerCase
          Case "#PB_String_MaximumLength"           : Flag = Flag | #PB_String_MaximumLength
          Case "#PB_String_Numeric"                 : Flag = Flag | #PB_String_Numeric
          Case "#PB_String_Password"                : Flag = Flag | #PB_String_Password
          Case "#PB_String_ReadOnly"                : Flag = Flag | #PB_String_ReadOnly
          Case "#PB_String_UpperCase"               : Flag = Flag | #PB_String_UpperCase
            ; text
          Case "#PB_Text_Left"                      : Flag = Flag | #__text_left
          Case "#PB_Text_Border"                    : Flag = Flag | #__flag_borderflat
          Case "#PB_Text_Center"                    : Flag = Flag | #__text_Center
          Case "#PB_Text_Right"                     : Flag = Flag | #__text_Right
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
          Case "#PB_Explorer_BorderLess"            : Flag = Flag | #PB_Explorer_BorderLess          ; Создать гаджет без границ.
          Case "#PB_Explorer_AlwaysShowSelection"   : Flag = Flag | #PB_Explorer_AlwaysShowSelection ; Выделение отображается даже если гаджет не активирован.
          Case "#PB_Explorer_MultiSelect"           : Flag = Flag | #PB_Explorer_MultiSelect         ; Разрешить множественное выделение элементов в гаджете.
          Case "#PB_Explorer_GridLines"             : Flag = Flag | #PB_Explorer_GridLines           ; Отображать разделительные линии между строками и колонками.
          Case "#PB_Explorer_HeaderDragDrop"        : Flag = Flag | #PB_Explorer_HeaderDragDrop      ; В режиме таблицы заголовки можно перетаскивать (Drag'n'Drop).
          Case "#PB_Explorer_FullRowSelect"         : Flag = Flag | #PB_Explorer_FullRowSelect       ; Выделение охватывает всю строку, а не первую колонку.
          Case "#PB_Explorer_NoFiles"               : Flag = Flag | #PB_Explorer_NoFiles             ; Не показывать файлы.
          Case "#PB_Explorer_NoFolders"             : Flag = Flag | #PB_Explorer_NoFolders           ; Не показывать каталоги.
          Case "#PB_Explorer_NoParentFolder"        : Flag = Flag | #PB_Explorer_NoParentFolder      ; Не показывать ссылку на родительский каталог [..].
          Case "#PB_Explorer_NoDirectoryChange"     : Flag = Flag | #PB_Explorer_NoDirectoryChange   ; Пользователь не может сменить директорию.
          Case "#PB_Explorer_NoDriveRequester"      : Flag = Flag | #PB_Explorer_NoDriveRequester    ; Не показывать запрос 'пожалуйста, вставьте диск X:'.
          Case "#PB_Explorer_NoSort"                : Flag = Flag | #PB_Explorer_NoSort              ; Пользователь не может сортировать содержимое по клику на заголовке колонки.
          Case "#PB_Explorer_AutoSort"              : Flag = Flag | #PB_Explorer_AutoSort            ; Содержимое автоматически упорядочивается по имени.
          Case "#PB_Explorer_HiddenFiles"           : Flag = Flag | #PB_Explorer_HiddenFiles         ; Будет отображать скрытые файлы (поддерживается только в Linux и OS X).
          Case "#PB_Explorer_NoMyDocuments"         : Flag = Flag | #PB_Explorer_NoMyDocuments       ; Не показывать каталог 'Мои документы' в виде отдельного элемента.
            
            ; explorercombo
          Case "#PB_Explorer_DrivesOnly"            : Flag = Flag | #PB_Explorer_DrivesOnly          ; Гаджет будет отображать только диски, которые вы можете выбрать.
          Case "#PB_Explorer_Editable"              : Flag = Flag | #PB_Explorer_Editable            ; Гаджет будет доступен для редактирования с функцией автозаполнения.  			      С этим флагом он действует точно так же, как тот что в Windows Explorer.
            
            ; explorertree
          Case "#PB_Explorer_NoLines"               : Flag = Flag | #PB_Explorer_NoLines             ; Скрыть линии, соединяющие узлы дерева.
          Case "#PB_Explorer_NoButtons"             : Flag = Flag | #PB_Explorer_NoButtons           ; Скрыть кнопки разворачивания узлов в виде символов '+'.
            
            ; spin
          Case "#PB_Explorer_Type"                  : Flag = Flag | #PB_Spin_Numeric
          Case "#PB_Explorer_Type"                  : Flag = Flag | #PB_Spin_ReadOnly
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
        EndSelect
        
      Next
    EndIf
    
    ProcedureReturn Flag
  EndProcedure
  
  Procedure SetFlag(Gadget, Object)
    Protected i, Flag
    i = GetState(Gadget)
    Flag = GetFlag(GetItemText(Gadget, i))
    
    Flag(Object, Flag, Bool(GetItemState(Gadget, i) & #PB_Tree_Checked))
  EndProcedure
  
  
  Procedure events_widgets()
    Protected flag
    
    Select WidgetEvent( )
      Case #__event_Change
        Select EventWidget( )
          Case w_type 
            flag = Flag(*this)
            Add(FlagFromType(GetState(w_type)))
            ;Debug FlagFromFlag(Type(*this), flag)
            SetCheckedText(w_flag, FlagFromFlag(Type(*this), flag))
            
          Case w_flag
            ;  Debug GetCheckedText(w_flag)
        EndSelect
        
      Case #__event_LeftClick
        Select EventWidget( )
          Case w_flag
            SetFlag(w_flag, *this)
            
        EndSelect
        
        If flag
          Flag(*this, flag, GetState(EventWidget( )))
        EndIf
    EndSelect
    
  EndProcedure
  
  If Open(0, 0, 0, Width+205, Height+30, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    *this = widget::Button(100, 100, 250, 200, Text, #__flag_ButtonToggle|#__flag_Textmultiline) 
    
    
    w_type = widget::ListView(Width+45, 10, 150, 200) 
    For i=0 To 33
      AddItem(w_type, -1, ClassFromType(i))
    Next
    
    w_flag = widget::Tree(Width+45, 220, 150, 200, #__tree_nobuttons|#__tree_nolines|#__flag_optionboxes) 
    
    Bind(#PB_All, @events_widgets())
    
    
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 12
; FirstLine = 9
; Folding = f------70-
; EnableXP
; DPIAware