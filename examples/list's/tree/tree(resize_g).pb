﻿IncludePath "../../../"
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  XIncludeFile "include/os/win/id.pbi"
  XIncludeFile "include/os/win/ClipGadgets.pbi"
CompilerEndIf
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Procedure LoadControls(widget, Directory$)
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
                      
                      If IsGadget(widget)
                        If FindString(LCase(PackEntryName.S), "cursor")
                          
                          ;Debug "add cursor"
                          AddGadgetItem(widget, 0, PackEntryName.S, ImageID(Image))
                          SetGadgetItemData(widget, 0, ImageID(Image))
                          
                        ElseIf FindString(LCase(PackEntryName.S), "window")
                          
                          ;Debug "add gadget window"
                          AddGadgetItem(widget, 1, PackEntryName.S, ImageID(Image))
                          SetGadgetItemData(widget, 1, ImageID(Image))
                          
                        Else
                          AddGadgetItem(widget, -1, PackEntryName.S, ImageID(Image))
                          SetGadgetItemData(widget, CountGadgetItems(widget)-1, ImageID(Image))
                        EndIf
                        
                      Else
                        If FindString(LCase(PackEntryName.S), "cursor")
                          
                          ;Debug "add cursor"
                          AddItem(widget, 0, PackEntryName.S, Image)
                          ;SetItemData(Widget, 0, Image)
                          
                        ElseIf FindString(LCase(PackEntryName.S), "window")
                          
                          Debug "add window"
                          AddItem(widget, 1, PackEntryName.S, Image)
                          ;SetItemData(Widget, 1, Image)
                          
                        Else
                          AddItem(widget, -1, PackEntryName.S, Image)
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
  
  Enumeration 
    #g_tree 
    #w_tree
    #g_splitter
    #g_splitter2
  EndEnumeration
  
  Global g_Canvas
  
  Procedure events_tree_gadget()
    ;Debug " gadget - "+EventGadget()+" "+EventType()
    Protected EventGadget = EventGadget()
    Protected EventType = EventType()
    Protected EventData = EventData()
    Protected EventItem = GetGadgetState(EventGadget)
    
    Select EventType
      ; Case #PB_EventType_ScrollChange : Debug "gadget scroll change data "+ EventData
      Case #PB_EventType_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_DragStart : Debug "gadget dragStart item = " + EventItem +" data "+ EventData
      Case #PB_EventType_Change    : Debug "gadget change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_LeftClick : Debug "gadget click item = " + EventItem +" data "+ EventData
    EndSelect
  EndProcedure
  
  Procedure events_tree_widget()
    ;Debug " widget - "+*event\widget+" "+*event\type
    Protected EventGadget = EventWidget()
    Protected EventType = WidgetEvent()
    Protected EventData = WidgetEventData()
    Protected EventItem = GetState(EventGadget)
    
    Select EventType
      Case #__event_ScrollChange : Debug "widget scroll change data "+ EventData
      Case #__event_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #__event_DragStart : Debug "widget dragStart item = " + EventItem +" data "+ EventData
      Case #__event_Change    : Debug "widget change item = " + EventItem +" data "+ EventData
      Case #__event_LeftClick : Debug "widget click item = " + EventItem +" data "+ EventData
    EndSelect
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(#g_splitter, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-16, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    
    CompilerIf #PB_Compiler_Version =< 546
      PostEvent(#PB_Event_Gadget, EventWindow(), g_Canvas, #PB_EventType_Resize)
    CompilerEndIf
  EndProcedure
  
  Procedure SplitterCallBack()
    PostEvent(#PB_Event_Gadget, EventWindow(), g_Canvas, #PB_EventType_Resize)
  EndProcedure
  
  If OpenWindow(0, 0, 0, 300, 491, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    Define i,a,g
    SetWindowColor(0, $B3FDFF)
    
    TreeGadget(#g_tree, 0,0,0,0, #PB_Tree_AlwaysShowSelection)                                         
    g = #g_tree
    
    ; 3_example
    AddGadgetItem(g, 0, "Tree_0", 0 )
    AddGadgetItem(g, 1, "Tree_1_1", ImageID(0), 1) 
    AddGadgetItem(g, 4, "Tree_1_1_1", 0, 2) 
    AddGadgetItem(g, 5, "Tree_1_1_2", 0, 2) 
    AddGadgetItem(g, 6, "Tree_1_1_2_1", 0, 3) 
    AddGadgetItem(g, 8, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", 0, 4) 
    AddGadgetItem(g, 7, "Tree_1_1_2_2 980980_", 0, 3) 
    AddGadgetItem(g, 2, "Tree_1_2", 0, 1) 
    AddGadgetItem(g, 3, "Tree_1_3", 0, 1) 
    AddGadgetItem(g, 9, "Tree_2" )
    AddGadgetItem(g, 10, "Tree_3", 0 )
    AddGadgetItem(g, 11, "Tree_4" )
    AddGadgetItem(g, 12, "Tree_5", 0 )
    AddGadgetItem(g, 13, "Tree_6", 0 )
    
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    
    ;     Open(0, 0,0,0,0, "", #Null, #Null, #w_tree )
    ;     g = Tree(0,0,0,0, #__flag_autosize)
    Gadget(#__type_Tree, #w_tree, 0, 0, 0, 0)
    g = GetGadgetData(#w_tree)
    If Not g : g = root( ) : EndIf
   ; SetBackgroundColor(g, $FFB3FDFF)
                        
                        
    ;  3_example
    AddItem(g, 0, "Tree_0", -1 )
    AddItem(g, 1, "Tree_1_1", 0, 1) 
    AddItem(g, 4, "Tree_1_1_1", -1, 2) 
    AddItem(g, 5, "Tree_1_1_2", -1, 2) 
    AddItem(g, 6, "Tree_1_1_2_1", -1, 3) 
    AddItem(g, 8, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", -1, 4) 
    AddItem(g, 7, "Tree_1_1_2_2 980980_", -1, 3) 
    AddItem(g, 2, "Tree_1_2", -1, 1) 
    AddItem(g, 3, "Tree_1_3", -1, 1) 
    AddItem(g, 9, "Tree_2",-1 )
    AddItem(g, 10, "Tree_3", -1 )
    AddItem(g, 11, "Tree_4", -1 )
    AddItem(g, 12, "Tree_5", -1 )
    AddItem(g, 13, "Tree_6", -1 )
    
    
    ;SplitterGadget(#g_splitter,8, 8, 306, 491-16, #g_tree, #w_tree)
    SplitterGadget(#g_splitter2, 0,0,0,0, #w_tree, #g_tree)
    SplitterGadget(#g_splitter, 8, 8, 300-16, 491-16, TextGadget(#PB_Any,0,0,0,0,""),#g_splitter2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    SetGadgetState(#g_splitter, 0)
    
    
      ;  SetGadgetColor(#g_splitter, #PB_Gadget_BackColor, $FFB3FDFF)
;     If StartDrawing(CanvasOutput(#w_tree))
;        Box(0, 0, OutputWidth(), OutputHeight(),  RGB(Random(255), Random(255), Random(255)))
;        StopDrawing()
;     EndIf
 
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(#g_splitter, @SplitterCallBack())
    CompilerEndIf
    
    ;PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug no linux
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    ; ClipGadgets(UseGadgetList(0))
    
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
; CursorPosition = 226
; FirstLine = 89
; Folding = 8--0--
; EnableXP