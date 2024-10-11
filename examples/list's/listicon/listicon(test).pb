XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(Widget)
  
  Define a, b
  
  If OpenWindow(0, 0, 0, 800, 600, "ListIconGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ;\\ left column
    ListIconGadget(0,  10,  25, 380, 70, "Column 1", 100)
    ListIconGadget(1,  10, 120, 380, 70, "Column 1", 100, #PB_ListIcon_CheckBoxes)  ; ListIcon with checkbox
    ListIconGadget(2,  10, 215, 380, 70, "Column 1", 100, #PB_ListIcon_MultiSelect) ; ListIcon with multi-selection
                                                                                    ;\\ right column
    ListIconGadget(3, 410,  25, 380, 70, "Column 1", 100, #PB_ListIcon_GridLines)
    ListIconGadget(4, 410, 120, 380, 70, "Column 1", 100, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
    ListIconGadget(5, 410, 220, 380, 65, "", 200,#PB_ListIcon_GridLines)
    
    ;\\
    TextGadget    (6,  10,  10, 380, 20, "ListIcon Standard", #PB_Text_Center)
    TextGadget    (7,  10, 105, 380, 20, "ListIcon with Checkbox", #PB_Text_Center)
    TextGadget    (8,  10, 200, 380, 20, "ListIcon with Multi-Selection", #PB_Text_Center)
    TextGadget    (9, 410,  10, 380, 20, "ListIcon with separator lines",#PB_Text_Center)
    TextGadget   (10, 410, 105, 380, 20, "ListIcon with FullRowSelect and AlwaysShowSelection",#PB_Text_Center)
    TextGadget   (11, 410, 200, 380, 20, "ListIcon Standard with large icons",#PB_Text_Center)
    
    ;\\
    For a = 0 To 4            ; add columns to each of the first 5 listicons
      For b = 2 To 4          ; add 3 more columns to each listicon
        AddGadgetColumn(a, b, "Column " + Str(b), 65)
      Next
      For b = 0 To 2          ; add 4 items to each line of the listicons
        AddGadgetItem(a, b, "Item 1"+Chr(10)+"Item 2"+Chr(10)+"Item 3"+Chr(10)+"Item 4")
      Next
    Next
    
    ;\\ Here we change the ListIcon display to large icons and show an image
    If LoadImage(0, #PB_Compiler_Home+"Examples\Sources\Data\File.bmp")     ; change path/filename to your own 32x32 pixel image
      SetGadgetAttribute(5, #PB_ListIcon_DisplayMode, #PB_ListIcon_LargeIcon)
      AddGadgetItem(5, 1, "Picture 1", ImageID(0))
      AddGadgetItem(5, 2, "Picture 2", ImageID(0))
    EndIf
    
    
    ;\\ Shows possible flags of ListIcon in action...
    If Open(0, 0, 300, 800, 300, "ListIcons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ;\\ left column
      ListIcon(10,  25, 380, 70, "Column 1", 100)
      ListIcon(10, 120, 380, 70, "Column 1", 100, #PB_ListIcon_CheckBoxes)  ; ListIcon with checkbox
      ListIcon(10, 215, 380, 70, "Column 1", 100, #PB_ListIcon_MultiSelect) ; ListIcon with multi-selection
                                                                            ;\\ right column                                                                                ; right column
      ListIcon(410,  25, 380, 70, "Column 1", 100, #PB_ListIcon_GridLines)
      ListIcon(410, 120, 380, 70, "Column 1", 100, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
      ListIcon(410, 220, 380, 65, "", 200,#PB_ListIcon_GridLines)
      
      ;\\
      Text    (10,  10, 380, 20, "ListIcon Standard", #PB_Text_Center)
      Text    (10, 105, 380, 20, "ListIcon with Checkbox", #PB_Text_Center)
      Text    (10, 200, 380, 20, "ListIcon with Multi-Selection", #PB_Text_Center)
      Text    (410,  10, 380, 20, "ListIcon with separator lines",#PB_Text_Center)
      Text    (410, 105, 380, 20, "ListIcon with FullRowSelect and AlwaysShowSelection",#PB_Text_Center)
      Text    (410, 200, 380, 20, "ListIcon Standard with large icons",#PB_Text_Center)
      
      ;\\
      For a = 0 To 4            ; add columns to each of the first 5 listicons
        For b = 2 To 4          ; add 3 more columns to each listicon
          AddColumn(WidgetID(a), b, "Column " + Str(b), 65)
        Next
        For b = 0 To 2          ; add 4 items to each line of the listicons
          AddItem(WidgetID(a), b, "Item 1"+Chr(10)+"Item 2"+Chr(10)+"Item 3"+Chr(10)+"Item 4")
        Next
      Next
      
      ; Here we change the ListIcon display to large icons and show an image
      If LoadImage(0, #PB_Compiler_Home+"Examples/Sources/Data/File.bmp")     ; change path/filename to your own 32x32 pixel image
        SetAttribute(WidgetID(5), #PB_ListIcon_DisplayMode, #PB_ListIcon_LargeIcon)
        AddItem(WidgetID(5), 1, "Picture 1", ImageID(0))
        AddItem(WidgetID(5), 2, "Picture 2", ImageID(0))
      EndIf
      
      Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
    EndIf
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 77
; FirstLine = 46
; Folding = -
; EnableXP
; DPIAware