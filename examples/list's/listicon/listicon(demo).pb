; Debug #PB_ListIcon_CheckBoxes           ; = 1           ; = 2
; Debug #PB_ListIcon_ThreeState           ; = 4           ; = 8
; Debug #PB_ListIcon_MultiSelect          ; = 4           ; = 1
; Debug #PB_ListIcon_AlwaysShowSelection  ; = 8           ; = 0
; Debug #PB_ListIcon_GridLines            ; = 65536       ; = 16
; Debug #PB_ListIcon_HeaderDragDrop       ; = 268435456   ; = 32
; Debug #PB_ListIcon_FullRowSelect        ; = 1073741824  ; = 0
; 
; ; GetGadgetAttribute
; Debug #PB_ListIcon_ColumnCount          ; = 3           ; = 3
; ; SetGadgetAttribute & GetGadgetAttribute
; Debug #PB_ListIcon_DisplayMode          ; = 2           ; = 2
;   Debug #PB_ListIcon_LargeIcon          ; = 0           ; = 0
;   Debug #PB_ListIcon_SmallIcon          ; = 1           ; = 1
;   Debug #PB_ListIcon_List               ; = 2           ; = 2
;   Debug #PB_ListIcon_Report             ; = 3           ; = 3
;   
;   ; SetGadgetItemAttribute & GetGadgetItemAttribute
; Debug #PB_ListIcon_ColumnWidth          ; = 1           ; = 1
; 
; Debug #PB_ListIcon_Selected             ; = 1           ; = 1
; Debug #PB_ListIcon_Checked              ; = 2           ; = 2
; Debug #PB_ListIcon_Inbetween            ; = 4           ; = 4
; 
; ;ListIconGadget(

;- 
;- example list-icon
;-
; CocoaMessage(0, GadgetID(0), "setHeaderView:", 0)
        
XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  UsePNGImageDecoder()
  ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  Define a,i
  
  If Open(0, 0, 0, 800, 450, "ListiconGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    SetActiveWindow(0)
    
    Define Count = 500
    Debug "Create items count - "+Str(Count)
    
    ;{ - gadget 
    Define t=ElapsedMilliseconds()
    Define g = 1
    ListIconGadget(g, 10, 10, 165, 210,"Column_1",90)                                         
    For i=1 To 2 : AddGadgetColumn(g, i,"Column_"+Str(i+1),90) : Next
    For i=0 To 7
      AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", ImageID(0))                                           
    Next
    
    g = 2
    ListIconGadget(g, 180, 10, 165, 210,"Column_1",90)                                         
    For i=1 To 2 : AddGadgetColumn(g, i,"Column_"+Str(i+1),90) : Next
    For i=0 To Count
      AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                           
    Next
    
    g = 3
    ListIconGadget(g, 350, 10, 430, 210,"Column_1",90, #PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines|#PB_ListIcon_CheckBoxes)                                         
    
    ;HideListIcon(g,1)
    For i=1 To 2
      AddGadgetColumn(g, i,"Column_"+Str(i+1),90)
    Next
    ; 1_example
    AddGadgetItem(g, -1, Chr(10)+"ListIcon_"+Str(i)) 
    For i=1 To 15
      AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", ImageID(0))                                           
    Next
    ;HideListIcon(g,0)
    
    Debug " time create gadget (listicon) - "+Str(ElapsedMilliseconds()-t)
    ;}
    
    
    ;{ - widget
    t=ElapsedMilliseconds()
    g = 11
    *g = ListIcon(10, 230, 165, 210, "Column_1",90) ;: *g = GetGadgetData(g)                                        
    For i=1 To 2 : AddColumn(*g, i,"Column_"+Str(i+1),90) : Next
    ; 1_example
    For i=0 To 7
      AddItem(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                          
    Next
    
    g = 12
    *g = ListIcon(180, 230, 165, 210, "Column_1",90, #__Flag_FullSelection) ;: *g = GetGadgetData(g)                                          
    For i=1 To 2 : AddColumn(*g, i,"Column_"+Str(i+1),90) : Next
    ; 1_example
    For i=0 To Count
      AddItem(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", -1)                                          
    Next
    
    g = 13
    *g = ListIcon(350, 230, 430, 210, "Column_1",90, #__Flag_GridLines|#__Flag_CheckBoxes) ;#__Flag_FullSelection|: *g = GetGadgetData(g)                                          
    
    ;HideListIcon(g,1)
    For i=1 To 2
      AddColumn(*g, i,"Column_"+Str(i+1),90)
    Next
    ; 1_example
    AddItem(*g, -1, Chr(10)+"ListIcon_"+Str(i)) 
    For i=1 To 15
      AddItem(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                         
    Next
    ;HideListIcon(g,0)
    
    Debug " time create canvas (listicon) - "+Str(ElapsedMilliseconds()-t)
    ;}
    
    ;   Define *This.Gadget = GetGadgetData(g)
    ;   
    ;   With *This\Columns()
    ;     Debug "Scroll_Height "+*This\Scroll\Height
    ;   EndWith
    
    WaitClose( )
    
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          End 
          ;         Case #PB_Event_Widget
          ;           Select EventGadget()
          ;             Case 13
          ;               Select EventType()
          ;                 Case #__event_ScrollChange : Debug "widget ScrollChange" +" "+ EventData()
          ;                 Case #__event_DragStart : Debug "widget dragStart"
          ;                 Case #__event_Change, #__event_LeftClick
          ;                   Debug "widget id = " + GetState(EventGadget())
          ;                   
          ;                   If EventType() = #__event_Change
          ;                     Debug "  widget change"
          ;                   EndIf
          ;               EndSelect
          ;           EndSelect
          
        Case #PB_Event_Gadget
          Select EventGadget()
            Case 3
              Select EventType()
                Case #PB_EventType_DragStart : Debug "gadget dragStart"
                Case #PB_EventType_Change, #PB_EventType_LeftClick
                  Debug "gadget id = " + GetGadgetState(EventGadget())
                  
                  If EventType() = #PB_EventType_Change
                    Debug "  gadget change"
                  EndIf
              EndSelect
          EndSelect
      EndSelect
    ForEver
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 8
; Folding = --
; EnableXP