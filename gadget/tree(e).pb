XIncludeFile "../../widgets.pbi"

EnableExplicit
Uselib(widget)
;XIncludeFile "gadgets.pbi" : UseModule Gadget
;-
;- EXAMPLE
;-
CompilerIf #PB_Compiler_IsMainFile
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
  
  
  
  Global Canvas_0
  Global *g._s_widget
  Global *g0._s_widget
  Global *g1._s_widget
  Global *g2._s_widget
  Global *g3._s_widget
  Global *g4._s_widget
  Global *g5._s_widget
  Global *g6._s_widget
  Global *g7._s_widget
  Global *g8._s_widget
  Global *g9._s_widget
  
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
  
  Global g_Canvas, NewList *List._s_widget()
  
  Procedure _ReDraw(Canvas)
    If StartDrawing(CanvasOutput(Canvas))
      FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F6)
      
      ; PushListPosition(*List())
      ForEach *List()
        If Not *List()\hide
          Draw(*List())
        EndIf
      Next
      ; PopListPosition(*List())
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure.i Canvas_Events()
    Protected Canvas.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Repaint
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    ;      MouseX = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
    ;      MouseY = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *callback = GetGadgetData(Canvas)
    Protected *this._s_widget ; = GetGadgetData(Canvas)
    
    Select EventType
      Case #__Event_Repaint
        *this = EventData()
        
        If *this And *this\handle
          *this\row\count = *this\countitems
          Events(*this, EventType, MouseX, MouseY)
          
          If StartDrawing(CanvasOutput(*this\root\canvas\gadget))
            If *event\_draw = 0
              *event\_draw = 1
              FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F6)
            EndIf
            
            Draw(*this)
            StopDrawing()
          EndIf
          
          ;ReDraw(*this, $F6)
          ProcedureReturn
        Else
          Repaint = 1
        EndIf
        
      Case #__Event_Resize ; : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                           ;          ForEach *List()
                           ;            Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
                           ;          Next
        Repaint = 1
        
      Case #__Event_LeftButtonDown
        SetActiveGadget(Canvas)
        
    EndSelect
    
    ForEach *List()
      If Not *List()\handle
        DeleteElement(*List())
      EndIf
      
      *List()\root\canvas\gadget = EventGadget()
      *List()\root\window = EventWindow()
      
      Repaint | Events(*List(), EventType, MouseX, MouseY)
    Next
    
    If Repaint 
      _ReDraw(Canvas)
    EndIf
  EndProcedure
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  Procedure events_tree_gadget()
    ;Debug " gadget - "+EventGadget()+" "+EventType()
    Protected EventGadget = EventGadget()
    Protected EventType = EventType()
    Protected EventData = EventData()
    Protected EventItem = GetGadgetState(EventGadget)
    
    Select EventType
      Case #__Event_ScrollChange : Debug "gadget scroll change data "+ EventData
      Case #__Event_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #__Event_DragStart : Debug "gadget dragStart item = " + EventItem +" data "+ EventData
      Case #__Event_Change    : Debug "gadget change item = " + EventItem +" data "+ EventData
      Case #__Event_LeftClick : Debug "gadget click item = " + EventItem +" data "+ EventData
    EndSelect
  EndProcedure
  
  Procedure events_tree_widget()
    ;Debug " widget - "+*event\widget+" "+*event\type
    Protected EventGadget = *event\widget
    Protected EventType = *event\type
    Protected EventData = *event\data
    Protected EventItem = GetState(EventGadget)
    
    Select EventType
      Case #__Event_ScrollChange : Debug "widget scroll change data "+ EventData
      Case #__Event_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #__Event_DragStart : Debug "widget dragStart item = " + EventItem +" data "+ EventData
      Case #__Event_Change    : Debug "widget change item = " + EventItem +" data "+ EventData
      Case #__Event_LeftClick : Debug "widget click item = " + EventItem +" data "+ EventData
    EndSelect
  EndProcedure
  
  If OpenWindow(0, 0, 0, 1110, 650, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define i,a,g = 1
    TreeGadget(g, 10, 10, 210, 210, #__tree_AlwaysSelection|#__tree_CheckBoxes)                                         
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
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #__tree_Expanded) : Next
    
    ; RemoveGadgetItem(g,1)
    SetGadgetItemState(g, 1, #__tree_Selected|#__tree_Collapsed|#__tree_Checked)
    ;BindGadgetEvent(g, @Events())
    
    ;SetActiveGadget(g)
    ;SetGadgetState(g, 1)
    ;     Debug "g "+ GetGadgetText(g)
    
    g = 2
    TreeGadget(g, 230, 10, 210, 210, #__tree_AlwaysSelection)                                         
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
    AddGadgetItem(g, 11, "Tree_4" )
    AddGadgetItem(g, 12, "Tree_5", 0 )
    AddGadgetItem(g, 13, "Tree_6", 0 )
    
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #__tree_Expanded) : Next
    
    
    g = 3
    TreeGadget(g, 450, 10, 210, 210, #__tree_AlwaysSelection|#__tree_CheckBoxes |#__tree_NoLines|#__tree_NoButtons | #__tree_ThreeState)                                      
    ;  2_example
    AddGadgetItem(g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)",ImageID(0)) 
    For i=1 To 20
      If i=5
        AddGadgetItem(g, -1, "Tree_"+Str(i), 0) 
      Else
        AddGadgetItem(g, -1, "Tree_"+Str(i), ImageID(0)) 
      EndIf
    Next
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #__tree_Expanded) : Next
    
    SetGadgetItemState(g, 0, #__tree_Selected|#__tree_Checked)
    SetGadgetItemState(g, 5, #__tree_Selected|#__tree_Inbetween)
    BindGadgetEvent(g, @events_tree_gadget())
    
    
    g = 4
    TreeGadget(g, 670, 10, 210, 210, #__tree_AlwaysSelection|#__tree_NoLines)                                         
    ; 4_example
    AddGadgetItem(g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", 0 )
    AddGadgetItem(g, 1, "Tree_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2", 0, 2) 
    AddGadgetItem(g, 2, "Tree_2_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_2", 0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #__tree_Expanded) : Next
    
    g = 5
    TreeGadget(g, 890, 10, 103, 210, #__tree_AlwaysSelection|#__tree_NoButtons)                                         
    ; 5_example
    AddGadgetItem(g, 0, "Tree_0",0 )
    AddGadgetItem(g, 1, "Tree_1",0, 0) 
    AddGadgetItem(g, 2, "Tree_2",0, 0) 
    AddGadgetItem(g, 3, "Tree_3",0, 0) 
    AddGadgetItem(g, 0, "Tree_0 (NoButtons)",0 )
    AddGadgetItem(g, 1, "Tree_1",0, 1) 
    AddGadgetItem(g, 2, "Tree_2_1",0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2",0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #__tree_Expanded) : Next
    SetGadgetItemImage(g, 0, ImageID(0))
    
    g = 6
    TreeGadget(g, 890+106, 10, 103, 210, #__tree_AlwaysSelection)                                         
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
    
    ;For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #__tree_Expanded) : Next
    
    Define widget = 1
    g_Canvas = GetGadget(Open(0, 0, 225, 1110, 425, #PB_Canvas_Container));,  @Canvas_Events()))
    
    g = 10
    
    If widget
      *g = Tree(10, 100, 210, 210, #__tree_CheckBoxes)                                         
      *g\root\canvas\gadget = g_Canvas
      AddElement(*List()) : *List() = *g
    Else
      Gadget(#PB_GadgetType_Tree, g, 10, 100, 210, 210, #__tree_CheckBoxes|#__tree_MultiSelect)
      *g = GetGadgetData(g)
    EndIf
    
    ; 1_example
    AddItem (*g, 0, "Normal Item "+Str(a), -1, 0)                                   
    AddItem (*g, -1, "Node "+Str(a), 0, 0)                                         
    AddItem (*g, -1, "Sub-Item 1", -1, 1)                                           
    AddItem (*g, -1, "Sub-Item 2", -1, 11)
    AddItem (*g, -1, "Sub-Item 3", -1, 1)
    AddItem (*g, -1, "Sub-Item 4", -1, 1)                                           
    AddItem (*g, -1, "Sub-Item 5", -1, 11)
    AddItem (*g, -1, "Sub-Item 6", -1, 1)
    AddItem (*g, -1, "File "+Str(a), -1, 0)  
    ;For i=0 To CountItems(*g) : SetItemState(*g, i, #__tree_expanded) : Next
    
    ; RemoveItem(*g,1)
    SetItemState(*g, 1, #__tree_Selected|#__tree_Collapsed|#__tree_Checked)
    ;BindGadgetEvent(g, @Events())
    ;     SetState(*g, 3)
    ;     SetState(*g, -1)
    ;Debug " - "+GetText(*g)
    LoadFont(3, "Arial", 18)
    SetFont(*g, 3)
    
    g = 11
    If widget
      *g = Tree(230, 100, 210, 210, #__tree_AlwaysSelection);|#__tree_Collapsed)                                         
      *g\root\canvas\gadget = g_Canvas
      AddElement(*List()) : *List() = *g
    Else
      Gadget(#PB_GadgetType_Tree, g, 160, 120, 210, 210, #__tree_AlwaysSelection)
      *g = GetGadgetData(g)
    EndIf
    
    ;  3_example
    AddItem(*g, 0, "Tree_0", -1 )
    AddItem(*g, 1, "Tree_1_1", 0, 1) 
    AddItem(*g, 4, "Tree_1_1_1", -1, 2) 
    AddItem(*g, 5, "Tree_1_1_2", -1, 2) 
    AddItem(*g, 6, "Tree_1_1_2_1", -1, 3) 
    AddItem(*g, 8, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", -1, 4) 
    AddItem(*g, 7, "Tree_1_1_2_2 980980_", -1, 3) 
    AddItem(*g, 2, "Tree_1_2", -1, 1) 
    AddItem(*g, 3, "Tree_1_3", -1, 1) 
    AddItem(*g, 9, "Tree_2",-1 )
    AddItem(*g, 10, "Tree_3", -1 )
    AddItem(*g, 11, "Tree_4", -1 )
    AddItem(*g, 12, "Tree_5", -1 )
    AddItem(*g, 13, "Tree_6", -1 )
    
    g = 12
    *g = Tree(450, 100, 210, 210, #__tree_CheckBoxes|#__tree_NoLines|#__tree_NoButtons|#__tree_GridLines | #__tree_ThreeState | #__tree_OptionBoxes)                            
    *g\root = AllocateStructure(_s_root)
    *g\root\canvas\gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    
    ;  2_example
    AddItem (*g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)", 0)                                    
    For i=1 To 20
      If i=5 ;Or i%3=0
        AddItem(*g, -1, "Tree_"+Str(i), -1, 0) 
      Else
        AddItem(*g, -1, "Tree_"+Str(i), 0, -1) 
      EndIf
    Next
    ;For i=0 To CountItems(*g) : SetItemState(*g, i, #__tree_Expanded) : Next
    SetItemState(*g, 0, #__tree_Selected|#__tree_Checked)
    SetItemState(*g, 5, #__tree_Selected|#__tree_Inbetween)
    
    LoadFont(5, "Arial", 16)
    SetItemFont(*g, 3, 5)
    SetItemText(*g, 3, "16_font and text change")
    SetItemColor(*g, 5, #__color_front, $FFFFFF00)
    SetItemColor(*g, 5, #__color_back, $FFFF00FF)
    SetItemText(*g, 5, "backcolor and text change")
    
    LoadFont(6, "Arial", 25)
    SetItemFont(*g, 4, 6)
    SetItemText(*g, 4, "25_font and text change")
    SetItemFont(*g, 14, 6)
    SetItemText(*g, 14, "25_font and text change")
    ;;Bind(*g, @events_tree_widget())
    
    g = 13
    *g = Tree(600+70, 100, 210, 210, #__tree_OptionBoxes|#__tree_NoButtons|#__tree_NoLines|#__tree_ClickSelect) ;                                        
    *g\root = AllocateStructure(_s_root)
    *g\root\canvas\gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    ;  4_example
    ; ;     AddItem(*g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", -1 )
    ; ;     AddItem(*g, 1, "Tree_1", -1, 1) 
    ; ;     AddItem(*g, 2, "Tree_2_2", -1, 2) 
    ; ;     AddItem(*g, 2, "Tree_2_1", -1, 1) 
    ; ;     AddItem(*g, 3, "Tree_3_1", -1, 1) 
    ; ;     AddItem(*g, 3, "Tree_3_2", -1, 2) 
    ; ;     For i=0 To CountItems(*g) : SetItemState(*g, i, #__tree_Expanded) : Next
    AddItem (*g, -1, "#PB_Window_MinimizeGadget", -1) ; Adds the minimize gadget To the window title bar. AddItem (*g, -1, "#PB_Window_SystemMenu is automatically added.
    AddItem (*g, -1, "#PB_Window_MaximizeGadget", -1) ; Adds the maximize gadget To the window title bar. AddItem (*g, -1, "#PB_Window_SystemMenu is automatically added.
                                                      ;                              (MacOS only", -1) ; AddItem (*g, -1, "#PB_Window_SizeGadget", -1) ; will be also automatically added", -1).
    AddItem (*g, -1, "#PB_Window_SizeGadget    ", -1) ; Adds the sizeable feature To a window.
    AddItem (*g, -1, "#PB_Window_Invisible     ", -1) ; Creates the window but don't display.
    AddItem (*g, -1, "#PB_Window_SystemMenu    ", -1) ; Enables the system menu on the window title bar (Default", -1).
    AddItem (*g, -1, "#PB_Window_TitleBar      ", -1,1) ; Creates a window With a titlebar.
    AddItem (*g, -1, "#PB_Window_Tool          ", -1,1) ; Creates a window With a smaller titlebar And no taskbar entry. 
    AddItem (*g, -1, "#PB_Window_BorderLess    ", -1,1) ; Creates a window without any borders.
    AddItem (*g, -1, "#PB_Window_ScreenCentered", -1)   ; Centers the window in the middle of the screen. x,y parameters are ignored.
    AddItem (*g, -1, "#PB_Window_WindowCentered", -1)   ; Centers the window in the middle of the parent window ('ParentWindowID' must be specified", -1). x,y parameters are ignored.
    AddItem (*g, -1, "#PB_Window_Maximize      ", -1, 1); Opens the window maximized. (Note", -1) ; on Linux, Not all Windowmanagers support this", -1)
    AddItem (*g, -1, "#PB_Window_Minimize      ", -1, 1); Opens the window minimized.
    AddItem (*g, -1, "#PB_Window_NoGadgets     ", -1)   ; Prevents the creation of a GadgetList. UseGadgetList(", -1) can be used To do this later.
    AddItem (*g, -1, "#PB_Window_NoActivate    ", -1)   ; Don't activate the window after opening.
    
    
    
    g = 14
    *g = Tree(750+135, 100, 103, 210, #__tree_NoButtons)                                         
    *g\root = AllocateStructure(_s_root)
    *g\root\canvas\gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    ;  5_example
    AddItem(*g, 0, "Tree_0", -1 )
    AddItem(*g, 1, "Tree_1", -1, 0) 
    AddItem(*g, 2, "Tree_2", -1, 0) 
    AddItem(*g, 3, "Tree_3", -1, 0) 
    AddItem(*g, 0, "Tree_0 (NoButtons)", -1 )
    AddItem(*g, 1, "Tree_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_2", -1, 2) 
    For i=0 To CountItems(*g) : SetItemState(*g, i, #__tree_Expanded) : Next
    SetItemImage(*g, 0, 0)
    
    g = 15
    *g = Tree(890+106, 100, 103, 210, #__tree_BorderLess|#__tree_Collapse)                                         
    *g\root = AllocateStructure(_s_root)
    *g\root\canvas\gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    ;  6_example
    AddItem(*g, 0, "Tree_1", -1, 1) 
    AddItem(*g, 0, "Tree_2_1", -1, 2) 
    AddItem(*g, 0, "Tree_2_2", -1, 3) 
    
    For i = 0 To 24
      If i % 5 = 0
        AddItem(*g, -1, "Directory" + Str(i), -1, 0)
      Else
        AddItem(*g, -1, "Item" + Str(i), -1, 1)
      EndIf
    Next i
    
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

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  ;   EnableExplicit
  ;   
  ;   CompilerIf Defined(DD, #PB_Module)
  ;     ;UseModule DD
  ;   CompilerEndIf
  ;   ;
  ;   ; ------------------------------------------------------------
  ;   ;
  ;   ;   PureBasic - Drag & Drop
  ;   ;
  ;   ;    (c) Fantaisie Software
  ;   ;
  ;   ; ------------------------------------------------------------
  ;   ;
  ;   
  ;   #Window = 0
  ;   
  ;   Enumeration    ; Images
  ;     #ImageSource
  ;     #ImageTarget
  ;   EndEnumeration
  ;   
  ;   Global SourceText,
  ;          SourceImage,
  ;          SourceFiles,
  ;          SourcePrivate,
  ;          TargetText,
  ;          TargetImage,
  ;          TargetFiles,
  ;          TargetPrivate1,
  ;          TargetPrivate2
  ;   
  ;   Global g_Canvas, *g._s_widget, NewList *List._s_widget()
  ;   
  ;   UsePNGImageDecoder()
  ;   
  ;   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
  ;     End
  ;   EndIf
  ;   
  ;   Procedure _Events()
  ;     Protected EventGadget.i, EventType.i, EventItem.i, EventData.i
  ;     
  ;     EventGadget = *event\widget ; Widget()
  ;     EventType = *event\type     ; Type()
  ;     EventItem = *event\item     ; Item()
  ;     EventData = *event\data     ; Data()
  ;     
  ;     Protected i, Text$, Files$, Count
  ;     ;Debug "     "+EventType
  ;     ; DragStart event on the source s, initiate a drag & drop
  ;     ;
  ;     Select EventType
  ;       Case #__Event_DragStart
  ;         Select EventGadget
  ;             
  ;           Case SourceText
  ;             Text$ = GetItemText(SourceText, GetState(SourceText))
  ;             DD::DragText(Text$)
  ;             
  ;             ;           Case SourceImage
  ;             ;             DragImage((#ImageSource))
  ;             ;             
  ;             ;           Case SourceFiles
  ;             ;             Files$ = ""       
  ;             ;             For i = 0 To CountItems(SourceFiles)-1
  ;             ;               If GetItemState(SourceFiles, i) & #PB_Explorer_Selected
  ;             ;                 Files$ + GetText(SourceFiles) + GetItemText(SourceFiles, i) + Chr(10)
  ;             ;               EndIf
  ;             ;             Next i 
  ;             ;             If Files$ <> ""
  ;             ;               DragFiles(Files$)
  ;             ;             EndIf
  ;             ;             
  ;             ;             ; "Private" Drags only work within the program, everything else
  ;             ;             ; also works with other applications (Explorer, Word, etc)
  ;             ;             ;
  ;             ;           Case SourcePrivate
  ;             ;             If GetState(SourcePrivate) = 0
  ;             ;               DragPrivate(1)
  ;             ;             Else
  ;             ;               DragPrivate(2)
  ;             ;             EndIf
  ;             
  ;         EndSelect
  ;         
  ;         ; Drop event on the target gadgets, receive the dropped data
  ;         ;
  ;       Case #__Event_Drop
  ;         
  ;         Select EventGadget
  ;             
  ;           Case TargetText
  ;             AddItem(TargetText, -1, DD::EventDropText())
  ;             
  ;             ;           Case TargetImage
  ;             ;             If DropImage(#ImageTarget)
  ;             ;               SetState(TargetImage, (#ImageTarget))
  ;             ;             EndIf
  ;             ;             
  ;             ;           Case TargetFiles
  ;             ;             Files$ = EventDropFiles()
  ;             ;             Count  = CountString(Files$, Chr(10)) + 1
  ;             ;             For i = 1 To Count
  ;             ;               AddItem(TargetFiles, -1, StringField(Files$, i, Chr(10)))
  ;             ;             Next i
  ;             ;             
  ;             ;           Case TargetPrivate1
  ;             ;             AddItem(TargetPrivate1, -1, "Private type 1 dropped")
  ;             ;             
  ;             ;           Case TargetPrivate2
  ;             ;             AddItem(TargetPrivate2, -1, "Private type 2 dropped")
  ;             
  ;         EndSelect
  ;         
  ;     EndSelect
  ;     
  ;   EndProcedure
  ;   
  ;   If OpenWindow(#Window, 0, 0, 760, 310, "Drag & Drop", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  ;     
  ;     g_Canvas = CanvasGadget(0, 0, 0, 760, 310, #PB_Canvas_Keyboard|#PB_Canvas_Container);, @Canvas_Events())
  ;     BindGadgetEvent(g_Canvas, @Canvas_Events())
  ;     
  ;     ; create some images for the image demonstration
  ;     ; 
  ;     Define i, Event
  ;     CreateImage(#ImageSource, 136, 136)
  ;     If StartDrawing(ImageOutput(#ImageSource))
  ;       Box(0, 0, 136, 136, $FFFFFF)
  ;       DrawText(5, 5, "Drag this image", $000000, $FFFFFF)        
  ;       For i = 45 To 1 Step -1
  ;         Circle(70, 80, i, Random($FFFFFF))
  ;       Next i        
  ;       
  ;       StopDrawing()
  ;     EndIf  
  ;     
  ;     CreateImage(#ImageTarget, 136, 136)
  ;     If StartDrawing(ImageOutput(#ImageTarget))
  ;       Box(0, 0, 136, 136, $FFFFFF)
  ;       DrawText(5, 5, "Drop images here", $000000, $FFFFFF)
  ;       StopDrawing()
  ;     EndIf  
  ;     
  ;     
  ;     ; create and fill the source s
  ;     ;
  ;     SourceText = Tree(10, 10, 140, 140);, "Drag Text here", 130)   
  ;     *g = SourceText
  ;     *g\root\canvas\gadget = g_Canvas
  ;     AddElement(*List()) : *List() = *g
  ;     ;SourceImage = Image(160, 10, 140, 140, (#ImageSource), #PB_Image_Border) 
  ;     ;SourceFiles = ExplorerList(310, 10, 290, 140, GetHomeDirectory(), #PB_Explorer_MultiSelect)
  ;     ;SourcePrivate = ListIcon(610, 10, 140, 140, "Drag private stuff here", 260)
  ;     
  ;     AddItem(SourceText, -1, "hello world")
  ;     AddItem(SourceText, -1, "The quick brown fox jumped over the lazy dog")
  ;     AddItem(SourceText, -1, "abcdefg")
  ;     AddItem(SourceText, -1, "123456789")
  ;     
  ;     ;     AddItem(SourcePrivate, -1, "Private type 1")
  ;     ;     AddItem(SourcePrivate, -1, "Private type 2")
  ;     
  ;     
  ;     ; create the target s
  ;     ;
  ;     TargetText = Tree(10, 160, 140, 140);, "Drop Text here", 130)
  ;     *g = TargetText
  ;     *g\root\canvas\gadget = g_Canvas
  ;     AddElement(*List()) : *List() = *g
  ;     
  ;     TargetImage = Tree(160, 160, 140, 140);, (#ImageTarget), #PB_Image_Border) 
  ;     *g = TargetImage
  ;     *g\root\canvas\gadget = g_Canvas
  ;     AddElement(*List()) : *List() = *g
  ;     
  ;     ;     TargetFiles = ListIcon(310, 160, 140, 140, "Drop Files here", 130)
  ;     ;     TargetPrivate1 = ListIcon(460, 160, 140, 140, "Drop Private Type 1 here", 130)
  ;     ;     TargetPrivate2 = ListIcon(610, 160, 140, 140, "Drop Private Type 2 here", 130)
  ;     
  ;     
  ;     ; Now enable the dropping on the target s
  ;     ;
  ;     CompilerIf Defined(DD, #PB_Module)
  ;       DD::EnableDrop(TargetText,     #PB_Drop_Text,    #PB_Drag_Copy)
  ;       ;     DD::EnableDrop(TargetImage,    #PB_Drop_Image,   #PB_Drag_Copy)
  ;       ;     DD::EnableDrop(TargetFiles,    #PB_Drop_Files,   #PB_Drag_Copy)
  ;       ;     DD::EnableDrop(TargetPrivate1, #PB_Drop_Private, #PB_Drag_Copy, 1)
  ;       ;     DD::EnableDrop(TargetPrivate2, #PB_Drop_Private, #PB_Drag_Copy, 2)
  ;     CompilerEndIf
  ;     
  ;     Bind(SourceText, @_Events(), #__Event_DragStart)
  ;     Bind(TargetText, @_Events(), #__Event_Drop)
  ;     
  ;     ;     Bind(@_Events())
  ;     ;     ReDraw(Root())
  ;     
  ;     Repeat
  ;       Event = WaitWindowEvent()
  ;     Until Event = #PB_Event_CloseWindow
  ;   EndIf
  ;   
  ;   End
CompilerEndIf
; IDE Options = PureBasic 5.62 (Windows - x86)
; CursorPosition = 482
; FirstLine = 303
; Folding = ----------
; EnableXP