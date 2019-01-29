IncludePath "../../"
XIncludeFile "widgets.pbi"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Widget
  Global Canvas_0
  Global *g0.Widget_S
  Global *g1.Widget_S
  Global *g2.Widget_S
  Global *g3.Widget_S
  Global *g4.Widget_S
  Global *g5.Widget_S
  Global *g6.Widget_S
  Global *g7.Widget_S
  Global *g8.Widget_S
  Global *g9.Widget_S
  
  Procedure LoadControls(Widget, Directory$)
    Protected ZipFile$ = Directory$ + "SilkTheme.zip"
    
    If FileSize(ZipFile$) < 1
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        ZipFile$ = #PB_Compiler_Home+"themes\SilkTheme.zip"
      CompilerElse
        ZipFile$ = #PB_Compiler_Home+"themes/SilkTheme.zip"
      CompilerEndIf
      If FileSize(ZipFile$) < 1
        MessageRequester("Designer Error", "Themes\SilkTheme.zip Not found in the current directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error|#PB_MessageRequester_Ok)
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
                          SetItemData(Widget, 0, Image)
                          
                        ElseIf FindString(LCase(PackEntryName.S), "window")
                          
                          Debug "add window"
                          AddItem(Widget, 1, PackEntryName.S, Image)
                          SetItemData(Widget, 1, Image)
                          
                        Else
                          AddItem(Widget, -1, PackEntryName.S, Image)
                          SetItemData(Widget, CountItems(Widget)-1, Image)
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
  
  Procedure ReDraw(Canvas)
    If IsGadget(Canvas) And StartDrawing(CanvasOutput(Canvas))
      ;     DrawingMode(#PB_2DDrawing_Default)
      ;     Box(0,0,OutputWidth(),OutputHeight(), winBackColor)
      FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
      
      Draw(*g0)
      Draw(*g1)
      Draw(*g2)
      Draw(*g3)
      Draw(*g4)
      Draw(*g5)
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure CallBacks()
    Protected Result
    Protected Canvas_0 = EventGadget()
    Protected Width = GadgetWidth(Canvas_0)
    Protected Height = GadgetHeight(Canvas_0)
    Protected MouseX = GetGadgetAttribute(Canvas_0, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas_0, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Select EventType()
      Case #PB_EventType_Resize : Result = 1
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(EventGadget())
        EndIf
        
        Result | CallBack(*g0, EventType()) 
        Result | CallBack(*g1, EventType()) 
        Result | CallBack(*g2, EventType()) 
        Result | CallBack(*g3, EventType()) 
        Result | CallBack(*g4, EventType()) 
        Result | CallBack(*g5, EventType()) 
    EndSelect
    
    If Result
      ReDraw(Canvas_0)
    EndIf
    
  EndProcedure
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  
  If OpenWindow(0, 0, 0, 1110, 450, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define i,a,g = 1
    ;{ - gadget
    TreeGadget(g, 10, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes)                                         
    ; 1_example
    AddGadgetItem(g, 0, "Normal Item "+Str(a), 0, 0) 
    AddGadgetItem(g, -1, "Node "+Str(a), ImageID(0), 0)      
    AddGadgetItem(g, -1, "Sub-Item 1", 0, 1)         
    AddGadgetItem(g, -1, "Sub-Item 2", 0, 11)
    AddGadgetItem(g, -1, "Sub-Item 3", 0, 1)
    AddGadgetItem(g, -1, "Sub-Item 4", 0, 1)         
    AddGadgetItem(g, -1, "Sub-Item 5", 0, 11)
    AddGadgetItem(g, -1, "Sub-Item 6", 0, 1)
    AddGadgetItem(g, -1, "File "+Str(a), 0, 0) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; RemoveGadgetItem(g,1)
    SetGadgetItemState(g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
    
    ;SetActiveGadget(g)
    ;SetGadgetState(g, 1)
    ;     Debug "g "+ GetGadgetText(g)
    
    g = 2
    TreeGadget(g, 230, 10, 210, 210, #PB_Tree_AlwaysShowSelection)                                         
    ; 3_example
    AddGadgetItem(g, 0, "Tree_0", 0 )
    AddGadgetItem(g, 1, "Tree_1_1", ImageID(0), 1) 
    AddGadgetItem(g, 4, "Tree_1_1_1", 0, 2) 
    AddGadgetItem(g, 5, "Tree_1_1_2", 0, 2) 
    AddGadgetItem(g, 6, "Tree_1_1_2_1", 0, 3) 
    AddGadgetItem(g, 8, "Tree_1_1_2_1_1", 0, 4) 
    AddGadgetItem(g, 7, "Tree_1_1_2_2", 0, 3) 
    AddGadgetItem(g, 2, "Tree_1_2", 0, 1) 
    AddGadgetItem(g, 3, "Tree_1_3", 0, 1) 
    AddGadgetItem(g, 9, "Tree_2" )
    AddGadgetItem(g, 10, "Tree_3", 0 )
    
    ;     AddGadgetItem(g, 6, "Tree_1_1_2_1", 0, 3) 
    ;     AddGadgetItem(g, 8, "Tree_1_1_2_1_1", 0, 4) 
    ;     AddGadgetItem(g, 7, "Tree_1_1_2_2", 0, 3) 
    ;     AddGadgetItem(g, 2, "Tree_1_2", 0, 1) 
    ;     AddGadgetItem(g, 3, "Tree_1_3", 0, 1) 
    ;     AddGadgetItem(g, 9, "Tree_2" )
    ;     AddGadgetItem(g, 10, "Tree_3", 0 )
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; ClearGadgetItems(g)
    
    g = 3
    TreeGadget(g, 450, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes |#PB_Tree_NoLines|#PB_Tree_NoButtons)  ;                                       
                                                                                                                             ;   ;  2_example
                                                                                                                             ;   AddGadgetItem(g, 0, "Normal Item "+Str(a), 0, 0) 
                                                                                                                             ;   AddGadgetItem(g, 1, "Node "+Str(a), 0, 1)       
                                                                                                                             ;   AddGadgetItem(g, 4, "Sub-Item 1", 0, 2)          
                                                                                                                             ;   AddGadgetItem(g, 2, "Sub-Item 2", 0, 1)
                                                                                                                             ;   AddGadgetItem(g, 3, "Sub-Item 3", 0, 1)
    
    ;  2_example
    AddGadgetItem(g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)",ImageID(0)) 
    For i=1 To 20
      If i=3
        AddGadgetItem(g, 1, "Tree_"+Str(i), 0) 
      ElseIf i=5
        AddGadgetItem(g, 4, "Tree_"+Str(i), 0) 
      ElseIf i=10
        AddGadgetItem(g, 0, "Tree_"+Str(i), 0) 
      Else
        AddGadgetItem(g, -1, "Tree_"+Str(i), ImageID(0)) 
      EndIf
    Next
    LoadControls(g, GetCurrentDirectory()+"Themes/")
    
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 4
    TreeGadget(g, 670, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoLines)                                         
    ; 4_example
    AddGadgetItem(g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", 0 )
    AddGadgetItem(g, 1, "Tree_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2", 0, 2) 
    AddGadgetItem(g, 2, "Tree_2_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_2", 0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 5
    TreeGadget(g, 890, 10, 103, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoButtons)                                         
    ; 5_example
    AddGadgetItem(g, 0, "Tree_0 (NoButtons)", 0 )
    AddGadgetItem(g, 1, "Tree_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2", 0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 6
    TreeGadget(g, 890+106, 10, 103, 210, #PB_Tree_AlwaysShowSelection)                                         
    ;  6_example
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
    
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    ;}
    
    ;{ - widget
    ; Demo draw string on the canvas
    Canvas_0 = CanvasGadget(-1,  0, 220, 1110, 230, #PB_Canvas_Keyboard)
    SetGadgetAttribute(Canvas_0, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    SetGadgetData(Canvas_0, 0)
    BindGadgetEvent(Canvas_0, @CallBacks())
    
    *g0 = Tree(10, 10, 210, 210, #PB_Tree_CheckBoxes|#PB_Flag_FullSelection)                                         
    ; 1_example
    AddItem (*g0, 0, "Normal Item "+Str(a), -1, 0)                                   
    AddItem (*g0, -1, "Node "+Str(a), 0, 0)                                         
    AddItem (*g0, -1, "Sub-Item 1", -1, 1)                                           
    AddItem (*g0, -1, "Sub-Item 2", -1, 11)
    AddItem (*g0, -1, "Sub-Item 3", -1, 1)
    AddItem (*g0, -1, "Sub-Item 4", -1, 1)                                           
    AddItem (*g0, -1, "Sub-Item 5", -1, 11)
    AddItem (*g0, -1, "Sub-Item 6", -1, 1)
    AddItem (*g0, -1, "File "+Str(a), -1, 0)  
    ; For i=0 To CountItems(*g0) : SetItemState(*g0, i, #PB_Tree_Expanded) : Next
    
    ; RemoveItem(*g0,1)
    ;Tree::SetItemState(*g0, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
    ;Tree::SetState(*g0, 1)
    ;Tree::SetState(*g0, -1)
    
    
    *g1 = Tree(230, 10, 210, 210, #PB_Flag_FullSelection)                                         
    ;  3_example
    
    AddItem(*g1, 0, "Tree_0", 0 )
    AddItem(*g1, 1, "Tree_1_1", 0, 1) 
    AddItem(*g1, 4, "Tree_1_1_1", 0, 2) 
    AddItem(*g1, 5, "Tree_1_1_2uuuuuuuuuuuuuuuuu", 0, 2) 
    AddItem(*g1, 6, "Tree_1_1_2_1", 0, 3) 
    AddItem(*g1, 8, "Tree_1_1_2_1_1_4 and scroll end", 0, 4) 
    AddItem(*g1, 7, "Tree_1_1_2_2", 0, 3) 
    AddItem(*g1, 2, "Tree_1_2", 0, 1) 
    AddItem(*g1, 3, "Tree_1_3", 0, 1) 
    AddItem(*g1, 9, "Tree_2 ",0 )
    AddItem(*g1, 10, "Tree_3", 0 )
    
    ;     AddItem(*g1, 6, "Tree_1_1_2_1", -1, 3) 
    ;     AddItem(*g1, 8, "Tree_1_1_2_1_1_8", -1, 4) 
    ;     AddItem(*g1, 7, "Tree_1_1_2_2", -1, 3) 
    ;     AddItem(*g1, 2, "Tree_1_2", -1, 1) 
    ;     AddItem(*g1, 3, "Tree_1_3", -1, 1) 
    ;     AddItem(*g1, 9, "Tree_2",-1 )
    ;     AddItem(*g1, 10, "Tree_3", -1 )
    ;For i=0 To CountItems(*g1) : SetItemState(*g1, i, #PB_Tree_Expanded) : Next
    
    ; ClearItems(*g1)
    
    *g2 = Tree(450, 10, 210, 210, #PB_Flag_FullSelection|#PB_Flag_CheckBoxes |#PB_Flag_NoLines|#PB_Flag_NoButtons )    ;                                
                                                                                                                       ;   ;  2_example
                                                                                                                       ;   AddItem (*g2, 0, "Normal Item "+Str(a), -1, 0)                                    
                                                                                                                       ;   AddItem (*g2, 1, "Node "+Str(a), -1, 1)                                           
                                                                                                                       ;   AddItem (*g2, 4, "Sub-Item 1", -1, 2)                                            
                                                                                                                       ;   AddItem (*g2, 2, "Sub-Item 2", -1, 1)
                                                                                                                       ;   AddItem (*g2, 3, "Sub-Item 3", -1, 1)
    
    ;  2_example
    AddItem (*g2, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)", 0)                                    
    For i=1 To 20
      If i=3
        AddItem(*g2, 1, "Tree_"+Str(i), -1) 
      ElseIf i=5
        AddItem(*g2, 4, "Tree_"+Str(i), -1) 
      ElseIf i=10
        AddItem(*g2, 0, "Tree_"+Str(i), -1) 
      Else
        AddItem(*g2, -1, "Tree_"+Str(i), 0) 
      EndIf
    Next
    LoadControls(*g2, GetCurrentDirectory()+"Themes/")
    ;For i=0 To CountItems(*g2) : SetItemState(*g2, i, #PB_Tree_Expanded) : Next
    
    *g3 = Tree(670, 10, 210, 210, #PB_Tree_NoLines)                                         
    ;  4_example
    AddItem(*g3, 0, "Tree_0 (NoLines|AlwaysShowSelection)", -1 )
    AddItem(*g3, 1, "Tree_1", -1, 1) 
    AddItem(*g3, 2, "Tree_2_2", -1, 2) 
    AddItem(*g3, 2, "Tree_2_1", -1, 1) 
    AddItem(*g3, 3, "Tree_3_1", -1, 1) 
    AddItem(*g3, 3, "Tree_3_2", -1, 2) 
    ; For i=0 To CountItems(*g3) : SetItemState(*g3, i, #PB_Tree_Expanded) : Next
    
    
    *g4 = Tree(890, 10, 103, 210, #PB_Tree_NoButtons)                                         
    ;  5_example
    AddItem(*g4, 0, "Tree_0 (NoButtons)", -1 )
    AddItem(*g4, 1, "Tree_1", -1, 1) 
    AddItem(*g4, 2, "Tree_2_1", -1, 1) 
    AddItem(*g4, 2, "Tree_2_2", -1, 2) 
    ; For i=0 To CountItems(*g4) : SetItemState(*g4, i, #PB_Tree_Expanded) : Next
    
    *g5 = Tree(890+106, 10, 103, 210)                                         
    ;  6_example
    AddItem(*g5, 0, "Tree_1", -1, 1) 
    AddItem(*g5, 0, "Tree_2_1", -1, 2) 
    AddItem(*g5, 0, "Tree_2_2", -1, 3) 
    
    For i = 0 To 24
      If i % 5 = 0
        AddItem(*g5, -1, "Directory" + Str(i), -1, 0)
      Else
        AddItem(*g5, -1, "Item" + Str(i), -1, 1)
      EndIf
    Next i
    
    ;For i=0 To CountItems(*g5) : SetItemState(*g5, i, #PB_Tree_Expanded) : Next
    ;}
    ;Free(*g5)
    
    ReDraw(Canvas_0)
    
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          End 
        Case #PB_Event_Widget
          Select EventGadget()
            Case 12
              Select EventType()
                Case #PB_EventType_ScrollChange : Debug "widget ScrollChange" +" "+ EventData()
                Case #PB_EventType_DragStart : Debug "widget dragStart"
                Case #PB_EventType_Change, #PB_EventType_LeftClick
                  Debug "widget id = " + GetState(GetGadgetData(EventGadget()))
                  
                  If EventType() = #PB_EventType_Change
                    Debug "  widget change"
                  EndIf
              EndSelect
          EndSelect
          
        Case #PB_Event_Gadget
          Select EventGadget()
            Case 3
              Select EventType()
                Case #PB_EventType_ScrollChange : Debug "ScrollChange" +" "+ EventData()
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
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -------
; EnableXP