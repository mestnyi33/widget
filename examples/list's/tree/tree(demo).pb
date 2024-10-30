IncludePath "../../../"
XIncludeFile "widgets.pbi"

; #PB_Tree_Selected ; Элемент должен быть выбран.
; #PB_Tree_Expanded ; Элемент должен быть развернут.
; #PB_Tree_Collapsed ; Элемент должен быть свернут. Если не заданы ни #PB_Tree_Expanded, ни #PB_Tree_Collapsed, это состояние изменено не будет.
; #PB_Tree_Checked ; Флажок "Элементы" должен быть установлен.
; #PB_Tree_Inbetween ; Флажок "Элементы" должен находиться в промежуточном состоянии.

CompilerIf #PB_Compiler_IsMainFile
 UseLib(widget)
 
 Procedure TreeGadget_(gadget, x,y,width,height,flag=0)
  Protected g = PB(TreeGadget)(gadget, x,y,width,height,flag)
  If gadget =- 1 : gadget = g : EndIf
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Define RowHeight.CGFloat = 20
    ; CocoaMessage(@RowHeight, GadgetID(0), "rowHeight")
    CocoaMessage(0, GadgetID(gadget), "setRowHeight:@", @RowHeight)
    
    ;CocoaMessage(0, GadgetID(gadget), "sizeLastColumnToFit")
   CocoaMessage(0, GadgetID(gadget), "sizeToFit")
      ;  CocoaMessage(0, GadgetID(gadget), "reloadData")
      
  CompilerElse
  CompilerEndIf
  
  ProcedureReturn gadget
EndProcedure


 CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Procedure GadgetsClipCallBack( GadgetID, lParam )
      If GadgetID
        Protected Gadget = GetProp_( GadgetID, "PB_ID" )
        
        If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
          SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS|#WS_CLIPCHILDREN )
          
          If IsGadget( Gadget ) 
            Select GadgetType( Gadget )
              Case #PB_GadgetType_ComboBox
                Protected Height = GadgetHeight( Gadget )
                
              Case #PB_GadgetType_Text
                If (GetWindowLongPtr_(GadgetID( Gadget ), #GWL_STYLE) & #SS_NOTIFY) = #False
                  SetWindowLongPtr_(GadgetID( Gadget ), #GWL_STYLE, GetWindowLongPtr_(GadgetID( Gadget ), #GWL_STYLE) | #SS_NOTIFY)
                EndIf
                
              Case #PB_GadgetType_Frame, #PB_GadgetType_Image
                If (GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
                  SetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
                EndIf
                
                ; Для панел гаджета темный фон убирать
              Case #PB_GadgetType_Panel 
                If Not IsGadget( Gadget ) And (GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
                  SetWindowLongPtr_(GadgetID, #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
                EndIf
                
            EndSelect
            
            ;             If (GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
            ;               SetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
            ;             EndIf
          EndIf
          
          
          If Height
            ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height )
          EndIf
          
          SetWindowPos_( GadgetID, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
        EndIf
        
      EndIf
      
      ProcedureReturn GadgetID
    EndProcedure
  CompilerEndIf
  
  Procedure ClipGadgets( WindowID )
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      WindowID = GetAncestor_( WindowID, #GA_ROOT )
      If Not (GetWindowLongPtr_(WindowID, #GWL_STYLE)&#WS_CLIPCHILDREN)
        SetWindowLongPtr_( WindowID, #GWL_STYLE, GetWindowLongPtr_( WindowID, #GWL_STYLE )|#WS_CLIPCHILDREN )
      EndIf
      EnumChildWindows_( WindowID, @GadgetsClipCallBack(), 0 )
    CompilerEndIf
  EndProcedure
  
  
  Global Canvas_0, g_Canvas
  Define i, a, g = 1
  Global *g._S_widget
  Global *g0._S_widget
  Global *g1._S_widget
  Global *g2._S_widget
  Global *g3._S_widget
  Global *g4._S_widget
  Global *g5._S_widget
  Global *g6._S_widget
  Global *g7._S_widget
  Global *g8._S_widget
  Global *g9._S_widget
  
  LoadFont(5, "Arial", 16)
    LoadFont(6, "Arial", 25)
    
  Procedure LoadControls(Widget, Directory$)
    Protected ZipFile$ = Directory$ + "SilkTheme.zip"
    
    If FileSize(ZipFile$) < 1
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        ZipFile$ = #PB_Compiler_Home+"themes\silkTheme.zip"
      CompilerElse
        ZipFile$ = #PB_Compiler_Home+"themes/SilkTheme.zip"
      CompilerEndIf
      If FileSize(ZipFile$) < 1
        MessageRequester("Designer Error", "Themes\silkTheme.zip Not found in the current directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error|#PB_MessageRequester_Ok)
        End
      EndIf
    EndIf
    ;   Directory$ = GetCurrentDirectory()+"images/" ; "";
    ;   Protected ZipFile$ = Directory$ + "images.zip"
    
    
    If FileSize(ZipFile$) > 0
      UsePNGImageDecoder()
      
      CompilerIf #PB_Compiler_Version > 522
        UseZipPacker()
      CompilerEndIf
      
      Protected PackEntryName.s, ImageSize, *Image, Image, ZipFile
      ZipFile = OpenPack(#PB_Any, ZipFile$, #PB_PackerPlugin_Zip)
      
      If ZipFile  
        If ExaminePack(ZipFile)
          While NextPackEntry(ZipFile)
            
            PackEntryName.S = PackEntryName(ZipFile)
            ImageSize = PackEntrySize(ZipFile)
            If ImageSize
              *Image = AllocateMemory(ImageSize)
              UncompressPackMemory(ZipFile, *Image, ImageSize)
              Image = CatchImage(#PB_Any, *Image, ImageSize)
              PackEntryName.S = ReplaceString(PackEntryName.S,".png","")
              If PackEntryName.S="application_form" 
                PackEntryName.S="vd_windowgadget"
              EndIf
              
              PackEntryName.S = ReplaceString(PackEntryName.S,"page_white_edit","vd_scintillagadget")   ;vd_scintillagadget.png not found. Use page_white_edit.png instead
              
              Select PackEntryType(ZipFile)
                Case #PB_Packer_File
                  If Image
                    If FindString(Left(PackEntryName.S, 3), "vd_")
                      PackEntryName.S = ReplaceString(PackEntryName.S,"vd_"," ")
                      PackEntryName.S = Trim(ReplaceString(PackEntryName.S,"gadget",""))
                      
                      Protected Left.S = UCase(Left(PackEntryName.S,1))
                      Protected Right.S = Right(PackEntryName.S,Len(PackEntryName.S)-1)
                      PackEntryName.S = " "+Left.S+Right.S
                      
                      If IsGadget(Widget)
                        If FindString(LCase(PackEntryName.S), "cursor")
                          
                          ;Debug "add cursor"
                          AddGadgetItem(Widget, 0, PackEntryName.S, ImageID(Image))
                          SetGadgetItemData(Widget, 0, ImageID(Image))
                          
                        ElseIf FindString(LCase(PackEntryName.S), "window")
                          
                          ;Debug "add gadget window"
                          AddGadgetItem(Widget, 1, PackEntryName.S, ImageID(Image))
                          SetGadgetItemData(Widget, 1, ImageID(Image))
                          
                        Else
                          AddGadgetItem(Widget, -1, PackEntryName.S, ImageID(Image))
                          SetGadgetItemData(Widget, CountGadgetItems(Widget)-1, ImageID(Image))
                        EndIf
                        
                      Else
                        If FindString(LCase(PackEntryName.S), "cursor")
                          
                          ;Debug "add cursor"
                          AddItem(Widget, 0, PackEntryName.S, Image)
                          ;SetItemData(Widget, 0, Image)
                          
                        ElseIf FindString(LCase(PackEntryName.S), "window")
                          
                          Debug "add window"
                          AddItem(Widget, 1, PackEntryName.S, Image)
                          ;SetItemData(Widget, 1, Image)
                          
                        Else
                          AddItem(Widget, -1, PackEntryName.S, Image)
                          ;SetItemData(Widget, CountItems(Widget)-1, Image)
                        EndIf
                      EndIf
                    EndIf
                  EndIf    
              EndSelect
              
              FreeMemory(*Image)
            EndIf
          Wend  
        EndIf
        
        ClosePack(ZipFile)
      EndIf
    EndIf
  EndProcedure
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  Global img = ImageID( 0 )
  
  Procedure events_tree_gadget()
    ;Debug " gadget - "+EventGadget()+" "+EventType()
    Protected EventGadget = EventGadget()
    Protected EventType = EventType()
    Protected EventData = EventData()
    Protected EventItem = GetGadgetState(EventGadget)
    
    Select EventType
      ;Case #PB_EventType_ScrollChange : Debug "gadget scroll change data "+ EventData
      Case #PB_EventType_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_DragStart : Debug "gadget dragStart item = " + EventItem +" data "+ EventData
      Case #PB_EventType_Change    : Debug "gadget change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_LeftClick : Debug "gadget click item = " + EventItem +" data "+ EventData
    EndSelect
  EndProcedure
  
  Procedure events_tree_widget()
    With structures::*event
      ;Debug " widget - "+EventWidget( )+" "+WidgetEvent( )
    Protected EventGadget = EventWidget( )
    Protected EventType = WidgetEvent( )
    Protected EventData = WidgetEventData( )
    Protected EventItem = GetState(EventGadget)
    
    Select EventType
      Case #__event_ScrollChange : Debug "widget scroll change data "+ EventData
      Case #__event_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #__event_DragStart : Debug "widget dragStart item = " + EventItem +" data "+ EventData
        DragText(GetItemText(EventGadget, EventItem))
        
      Case #__event_Drop : Debug "widget drop item = " + EventItem +" data "+ EventData
        Debug EventDropText()
        
      Case #__event_Change    : Debug "widget change item = " + EventItem +" data "+ EventData
      Case #__event_LeftClick : Debug "widget click item = " + EventItem +" data "+ EventData
    EndSelect
    EndWith
  EndProcedure
  
  Define item = 2
  Define sublevel = 2
  
  If OpenWindow(0, 0, 0, 1110, 650, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ;{
; ;     TreeGadget_(g, 10, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes)                                         
; ;     ; 1_example
; ;     AddGadgetItem(g, 0, "Normal Item "+Str(a), 0, 0) 
; ;     AddGadgetItem(g, -1, "Node "+Str(a), ImageID(0), 0)      
; ;     AddGadgetItem(g, -1, "Sub-Item 1", 0, 1)         
; ;     AddGadgetItem(g, -1, "Sub-Item 2", 0, 11)
; ;     AddGadgetItem(g, -1, "Sub-Item 3", 0, 1)
; ;     AddGadgetItem(g, -1, "Sub-Item 4", 0, 1)         
; ;     AddGadgetItem(g, -1, "Sub-Item 5", 0, 11)
; ;     AddGadgetItem(g, -1, "Sub-Item 6", 0, 1)
; ;     AddGadgetItem(g, -1, "File "+Str(a), 0, 0) 
; ;     For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
; ;     
; ;     ; RemoveGadgetItem(g,1)
; ;     SetGadgetItemState(g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
; ;     ;BindGadgetEvent(g, @Events())
; ;     
; ;     ;SetActiveGadget(g)
; ;     ;SetGadgetState(g, 1)
; ;     ;     Debug "g "+ GetGadgetText(g)
    g = 0
    ; 1_example
    TreeGadget_(g, 10, 10, 210, 100)                                         
    AddGadgetItem(g, -1, "Node "+Str(a), img, 0)                                         
    AddGadgetItem(g, -1, "Sub-Item 1", 0, 1)                                           
    AddGadgetItem(g, -1, "Sub-Item 3", 0, 3)
    AddGadgetItem(g, -1, "Sub-Item 2", 0, 2)
    AddGadgetItem(g, -1, "Sub-Item 4", 0, 4)
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
      
    g = 1
    ; 2_example
    TreeGadget_(g, 10, 10+110, 210, 100)                                         
    AddGadgetItem(g, 0, "Node "+Str(a), img, 0)                                         
    AddGadgetItem(g, 1, "Sub-Item 1", 0, 1)                                           
    AddGadgetItem(g, 3, "Sub-Item 3", 0, 3)
    AddGadgetItem(g, 2, "Sub-Item 2", 0, 2)
    AddGadgetItem(g, 4, "Sub-Item 4", 0, 4)
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
;     Define Indentation = 50    
;     ; ----- Read current indentation and set TrackBar to that value
;     ;CocoaMessage(@Indentation, GadgetID(g), "indentationPerLevel")
;     CocoaMessage(0, GadgetID(g), "setIndentationPerLevel:@", @Indentation)
    
    
    g = 2
    ; 2_example
    TreeGadget_(g, 230, 10, 103, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoButtons)                                         
    AddGadgetItem(g, 0, "Tree_0",0 )
    AddGadgetItem(g, 1, "Tree_1",0, 0) 
    AddGadgetItem(g, 2, "Tree_2",0, 0) 
    AddGadgetItem(g, 3, "Tree_3",0, 0) 
    AddGadgetItem(g, 0, "Tree_0 (NoButtons)",0 )
    AddGadgetItem(g, 1, "Tree_1",0, 1) 
    AddGadgetItem(g, 2, "Tree_2_1",0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2",0, 2) 
    For i = 0 To 10
      AddGadgetItem(g, -1, "Normal Item "+Str(i), 0, 0) ; if you want to add an image, use
      AddGadgetItem(g, -1, "Node "+Str(i), 0, 0)        ; ImageID(x) as 4th parameter
      AddGadgetItem(g, -1, "Sub-Item 1", 0, 1)          ; These are on the 1st sublevel
      AddGadgetItem(g, -1, "Sub-Item 2", 0, 1)
      AddGadgetItem(g, -1, "Sub-Item 3", 0, 1)
      AddGadgetItem(g, -1, "Sub-Item 4", 0, 1)
      AddGadgetItem(g, -1, "File "+Str(i), 0, 0) ; sublevel 0 again
    Next
    
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    SetGadgetItemImage(g, 0, ImageID(0))
    
    g = 3
    ;  3_example
    TreeGadget_(g, 230+107, 10, 103, 210, #PB_Tree_AlwaysShowSelection)                                         
    AddGadgetItem(g, 0, "Tree_1", 0, 1) 
    AddGadgetItem(g, 0, "Tree_2_1", 0, 2) 
    AddGadgetItem(g, 0, "Tree_2_2", 0, 3) 
    For i = 0 To 24
      If i % 5 = 0
        AddGadgetItem(g, -1, "Directory" + Str(i), 0, 0)
      Else
        AddGadgetItem(g, -1, "Item" + Str(i), 0, 1)
      EndIf
    Next i
    ;For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    SplitterGadget(#PB_Any, 230, 10, 210, 210, 3,2, #PB_Splitter_Vertical)                                         
    
    g = 4
    ; 4_example
    TreeGadget_(g, 450, 10, 210, 210, #PB_Tree_AlwaysShowSelection)                                         
    AddGadgetItem(g, 0, "Tree_0", 0 )
    AddGadgetItem(g, 1, "Tree_1_1", img, 1) 
    AddGadgetItem(g, 4, "Tree_1_1_1", 0, 2) 
    AddGadgetItem(g, 5, "Tree_1_1_2", 0, 2) 
    AddGadgetItem(g, 6, "Tree_1_1_2_1", 0, 3) 
    AddGadgetItem(g, 8, "Tree_1_1_2_1_1", 0, 4) 
    AddGadgetItem(g, 7, "Tree_1_1_2_2", 0, 3) 
    AddGadgetItem(g, 2, "Tree_1_2", 0, 1) 
    AddGadgetItem(g, 3, "Tree_1_3", 0, 4) 
    AddGadgetItem(g, 9, "Tree_2" )
    AddGadgetItem(g, 10, "Tree_3", 0 )
    AddGadgetItem(g, 11, "Tree_4" )
    AddGadgetItem(g, 12, "Tree_5", 0 )
    AddGadgetItem(g, 13, "Tree_6", 0 )
    AddGadgetItem(g, 14, "Tree_7", 0 )
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 5
    ; 5_example
    TreeGadget_(g, 670, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoLines)                                         
    AddGadgetItem(g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", 0 )
    AddGadgetItem(g, 1, "Tree_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2", 0, 2) 
    AddGadgetItem(g, 2, "Tree_2_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_2", 0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 6
    ;  6_example
    TreeGadget_(g, 890, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes |#PB_Tree_NoLines|#PB_Tree_NoButtons | #PB_Tree_ThreeState)                                      
    AddGadgetItem(g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)",ImageID(0)) 
    For i=1 To 20
      If i=5
        AddGadgetItem(g, -1, "Tree_"+Str(i), 0) 
      Else
        AddGadgetItem(g, -1, "Tree_"+Str(i), ImageID(0)) 
      EndIf
    Next
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    SetGadgetItemState(g, 0, #PB_Tree_Selected|#PB_Tree_Checked)
    SetGadgetItemState(g, 5, #PB_Tree_Selected|#PB_Tree_Inbetween)
    BindGadgetEvent(g, @events_tree_gadget())
    
    ;}
    
    Open(0, 0, 225, 1110, 425)
    g_Canvas = GetGadget(root())
    g = 10
    
; ;     *g = Tree(10, 100, 210, 210, #__tree_CheckBoxes)                                         
; ;     
; ;     
; ;     ; 1_example
; ;     AddItem (*g, 0, "Normal Item "+Str(a), -1, 0)                                   
; ;     AddItem (*g, -1, "Node "+Str(a), 0, 0)                                         
; ;     AddItem (*g, -1, "Sub-Item 1", -1, 1)                                           
; ;     AddItem (*g, -1, "Sub-Item 2", -1, 11)
; ;     AddItem (*g, -1, "Sub-Item 3", -1, 1)
; ;     AddItem (*g, -1, "Sub-Item 4", -1, 1)                                           
; ;     AddItem (*g, -1, "Sub-Item 5", -1, 11)
; ;     AddItem (*g, -1, "Sub-Item 6", -1, 1)
; ;     AddItem (*g, -1, "File "+Str(a), -1, 0)  
; ;     ;For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
; ;     
; ; ; ;     ; RemoveItem(*g,1)
; ; ; ;     SetItemState(*g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
; ; ; ;     ;BindGadgetEvent(g, @Events())
; ; ; ;     ;     SetState(*g, 3)
; ; ; ;     ;     SetState(*g, -1)
; ; ; ;     ;Debug " - "+GetText(*g)
; ; ; ;     LoadFont(3, "Arial", 18)
; ; ; ;     SetFont(*g, 3)
    
    ; 1_example
    *g = Tree(10, 100, 210, 100, #__tree_CheckBoxes)                                         
    AddItem (*g, -1, "Node "+Str(a), 0, 0)                                         
    AddItem (*g, -1, "Sub-Item 1", -1, 1)                                           
    AddItem (*g, -1, "Sub-Item 3", -1, 3)
    AddItem (*g, -1, "Sub-Item 2", -1, 2)
    AddItem (*g, -1, "Sub-Item 4", -1, 4)
    ;;AddItem (*g, item, "Add-Item "+Str(item), -1, sublevel)
    
    ; 2_example
    *g = Tree(10, 100+110, 210, 100, #__tree_CheckBoxes)                                         
    AddItem (*g, 0, "Node "+Str(a), 0, 0)                                         
    AddItem (*g, 1, "Sub-Item 1", -1, 1)                                           
    AddItem (*g, 3, "Sub-Item 3", -1, 3)
    AddItem (*g, 2, "Sub-Item 2", -1, 2)
    AddItem (*g, 4, "Sub-Item 4", -1, 4)
    ;;AddItem (*g, item, "Add-Item "+Str(item), -1, sublevel)
  
    ;{  3_example
    *g5 = Tree(230, 100, 103, 210, #__Tree_NoButtons)                                    
    AddItem(*g5, 0, "Tree_0", -1 )
    AddItem(*g5, 1, "Tree_1", -1, 0) 
    AddItem(*g5, 2, "Tree_2", -1, 0) 
    AddItem(*g5, 3, "Tree_3", -1, 0) 
    AddItem(*g5, 0, "Tree_0 (NoButtons)", 0 )
    AddItem(*g5, 1, "Tree_1", -1, 1) 
    AddItem(*g5, 2, "Tree_2_1", -1, 1) 
    AddItem(*g5, 2, "Tree_2_2", -1, 2) 
    For i = 0 To 10
      AddItem(*g5, -1, "Normal Item "+Str(i), -1, 0) ; if you want to add an image, use
      AddItem(*g5, -1, "Node "+Str(i), -1, 0)        ; ImageID(x) as 4th parameter
      AddItem(*g5, -1, "Sub-Item 1", -1, 1)          ; These are on the 1st sublevel
      AddItem(*g5, -1, "Sub-Item 2", -1, 1)
      AddItem(*g5, -1, "Sub-Item 3", -1, 1)
      AddItem(*g5, -1, "Sub-Item 4", -1, 1)
      AddItem(*g5, -1, "File "+Str(i), -1, 0) ; sublevel 0 again
    Next
    
    ;For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
     ;    SetItemImage(*g, 0, 0)
    ;}
    
    ;{  6_example
    *g6 = Tree(341, 100, 103, 210, #__flag_BorderLess|#__flag_Collapsed)                                         
    
    AddItem(*g6, 0, "Tree_1", -1, 1) 
    AddItem(*g6, 0, "Tree_2_1", -1, 2) 
    AddItem(*g6, 0, "Tree_2_2", -1, 3) 
    
    For i = 0 To 24
      If i % 5 = 0
        AddItem(*g6, -1, "Directory" + Str(i), -1, 0)
      Else
        AddItem(*g6, -1, "Item" + Str(i), -1, 1)
      EndIf
    Next i
    
    ;}
    
    
    splitter(230, 100, 210, 210, *g6,*g5, #PB_Splitter_Vertical)                                         
    
    
       ;  2_example
    *g = Tree(450, 100, 210, 210)                                         
    AddItem(*g, 0, "Tree_0", -1 )
    AddItem(*g, 1, "Tree_1_1", 0, 1) 
    AddItem(*g, 4, "Tree_1_1_1", -1, 2) 
    AddItem(*g, 5, "Tree_1_1_2", -1, 2) 
    AddItem(*g, 6, "Tree_1_1_2_1", -1, 3) 
    AddItem(*g, 8, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", -1, 4) 
    AddItem(*g, 7, "Tree_1_1_2_2 980980_", -1, 3) 
    AddItem(*g, 2, "Tree_1_2", -1, 1) 
    AddItem(*g, 3, "Tree_1_3", -1, 4) 
    AddItem(*g, 9, "Tree_2",-1 )
    AddItem(*g, 10, "Tree_3", -1 )
    AddItem(*g, 11, "Tree_4", -1 )
    AddItem(*g, 12, "Tree_5", -1 )
    AddItem(*g, 13, "Tree_6", -1 )
    AddItem(*g, 14, "Tree_7", -1 )
; ;     ;Bind(*g, @events_tree_widget())
; ;     DD::EnableDrop(*g, #PB_Drop_Text, #PB_Drag_Copy)
    
  ;  For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Collapsed) : Next
    
    
 ;{  4_example
    *g = Tree(670, 100, 210, 210, #__tree_nolines|#__flag_optionboxes);|#__tree_NoButtons) ;                                        
;         AddItem(*g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", -1 )
;         AddItem(*g, 1, "Tree_1", -1, 1) 
;         AddItem(*g, 2, "Tree_2_2", -1, 2) 
;         AddItem(*g, 2, "Tree_2_1", -1, 1) 
;         AddItem(*g, 3, "Tree_3_1", -1, 1) 
;         AddItem(*g, 3, "Tree_3_2", -1, 2) 
;         For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    AddItem (*g, -1, "#PB_Window_SystemMenu    ", -1,1) ; Enables the system menu on the window title bar (Default", -1).
    AddItem (*g, -1, "#PB_Window_TitleBar      ", -1,1) ; Creates a window With a titlebar.
    AddItem (*g, -1, "#PB_Window_BorderLess    ", -1,1) ; Creates a window without any borders.
    AddItem (*g, -1, "#PB_Window_Tool          ", -1,1) ; Creates a window With a smaller titlebar And no taskbar entry. 
    AddItem (*g, -1, "#PB_Window_MinimizeGadget", -1) ; Adds the minimize gadget To the window title bar. AddItem (*g, -1, "#PB_Window_SystemMenu is automatically added.
    AddItem (*g, -1, "#PB_Window_MaximizeGadget", -1) ; Adds the maximize gadget To the window title bar. AddItem (*g, -1, "#PB_Window_SystemMenu is automatically added.
    AddItem (*g, -1, "#PB_Window_SizeGadget    ", -1) ; Adds the sizeable feature To a window.
                                                      ;                              (MacOS only", -1) ; AddItem (*g, -1, "#PB_Window_SizeGadget", -1) ; will be also automatically added", -1).
    AddItem (*g, -1, "#PB_Window_Maximize      ", -1, 1); Opens the window maximized. (Note", -1) ; on Linux, Not all Windowmanagers support this", -1)
    AddItem (*g, -1, "#PB_Window_Minimize      ", -1, 1); Opens the window minimized.
    
    AddItem (*g, -1, "#PB_Window_Invisible     ", -1) ; Creates the window but don't display.
    AddItem (*g, -1, "#PB_Window_NoGadgets     ", -1)   ; Prevents the creation of a GadgetList. UseGadgetList(", -1) can be used To do this later.
    AddItem (*g, -1, "#PB_Window_NoActivate    ", -1)   ; Don't activate the window after opening.
    AddItem (*g, -1, "#PB_Window_ScreenCentered", -1, 1)   ; Centers the window in the middle of the screen. x,y parameters are ignored.
    AddItem (*g, -1, "#PB_Window_WindowCentered", -1, 1)   ; Centers the window in the middle of the parent window ('ParentWindowID' must be specified", -1). x,y parameters are ignored.
    ;}                                                    ;
    
    ;{  3_example
    *g = Tree(890, 100, 210, 210, #__tree_CheckBoxes|#__tree_nolines|#__tree_NoButtons | #__tree_ThreeState | #__flag_optionboxes)   ;  |#__flag_GridLines                       
    AddItem (*g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)", 0)                                    
    For i=1 To 20
      If i=5 Or i=6 Or i=7
        AddItem(*g, -1, "Tree_"+Str(i), -1, 0) 
      Else
        AddItem(*g, -1, "Tree_"+Str(i), 0, -1) 
      EndIf
    Next 
    ;For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    SetItemState(*g, 0, #PB_Tree_Selected|#PB_Tree_Checked)
    SetItemState(*g, 5, #PB_Tree_Selected|#PB_Tree_Inbetween)
    ;LoadFont(5, "Arial", 16)
    SetItemFont(*g, 3, 5)
    SetItemColor(*g, 3, #__Color_Front, $FFFFFF00)
    SetItemColor(*g, 3, #__Color_Back, $FFFF00FF)
    SetItemText(*g, 3, "16_font backcolor text change")
    ;;SetItemText(*g, 3, "16_font and text change")
    ;LoadFont(6, "Arial", 25)
    SetItemFont(*g, 4, 6)
    SetItemText(*g, 4, "25_font and text change")
    SetItemFont(*g, 14, 6)
    SetItemText(*g, 14, "25_font and text change")
    ;Bind(*g, @events_tree_widget())
    ;}
    
    WaitClose( )
    
    ;Define *g5,*g6
    ; Free(*g)
    ;ClipGadgets( UseGadgetList(0) )
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          CloseWindow(EventWindow()) 
          Break
      EndSelect
    ForEver
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = e-b------
; EnableXP
; DPIAware
; Executable = C:\Users\user\Documents\GitHub\1.exe