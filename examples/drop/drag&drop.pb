XIncludeFile "../../widgets.pbi"
; надо исправить scroll\v draw width

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  EnableExplicit
  ;
  ; ------------------------------------------------------------
  ;
  ;   PureBasic - Drag & Drop
  ;
  ;    (c) Fantaisie Software
  ;
  ; ------------------------------------------------------------
  ;
  
  #Window = 0
  
  Enumeration    ; Images
    #ImageSource
    #ImageTarget
  EndEnumeration
  
  ;Enumeration    ; Gadgets
  Global  SourceText,
    SourceImage,
    SourceFiles,
    SourcePrivate,
    TargetText,
    TargetImage,
    TargetFiles,
    TargetPrivate1,
    TargetPrivate2
  ;EndEnumeration
  
  Procedure events_( )
    Protected Event = Event()
    Protected Text$, Files$, i, Count
    ; DragStart event on the source gadgets, initiate a drag & drop
      ;
      If Event = #PB_Event_Gadget And EventType() = #PB_EventType_DragStart
        Select EventGadget()
            
          Case SourceText
            Text$ = GetGadgetItemText(SourceText, GetGadgetState(SourceText))
            DragText(Text$)
            
          Case SourceImage
            DragImage(ImageID(#ImageSource))
            
          Case SourceFiles
            Files$ = ""       
            For i = 0 To CountGadgetItems(SourceFiles)-1
              If GetGadgetItemState(SourceFiles, i) & #PB_Explorer_Selected
                Files$ + GetGadgetText(SourceFiles) + GetGadgetItemText(SourceFiles, i) + Chr(10)
              EndIf
            Next i 
            If Files$ <> ""
              DragFiles(Files$)
            EndIf
            
            ; "Private" Drags only work within the program, everything else
            ; also works with other applications (Explorer, Word, etc)
            ;
          Case SourcePrivate
            If GetGadgetState(SourcePrivate) = 0
              DragPrivate(1)
            Else
              DragPrivate(2)
            EndIf
            
        EndSelect
        
        ; Drop event on the target gadgets, receive the dropped data
        ;
      ElseIf Event = #PB_Event_GadgetDrop
        Select EventGadget()
            
          Case TargetText
            AddGadgetItem(TargetText, -1, EventDropText())
            
          Case TargetImage
            If EventDropImage(#ImageTarget)
              SetGadgetState(TargetImage, ImageID(#ImageTarget))
            EndIf
            
          Case TargetFiles
            Files$ = EventDropFiles()
            Count  = CountString(Files$, Chr(10)) + 1
            For i = 1 To Count
              AddGadgetItem(TargetFiles, -1, StringField(Files$, i, Chr(10)))
            Next i
            
          Case TargetPrivate1
            AddGadgetItem(TargetPrivate1, -1, "Private type 1 dropped")
            
          Case TargetPrivate2
            AddGadgetItem(TargetPrivate2, -1, "Private type 2 dropped")
            
        EndSelect
        
      EndIf
      
  EndProcedure
  
  Macro ListIcon( x,y,width,height,title,titlewidth,flag=0)
    Tree( x,y,width,height, flag)
  EndMacro
  
  Macro ExplorerList( x,y,width,height,title,titlewidth,flag=0)
    Tree( x,y,width,height, flag)
  EndMacro
  
  Macro EnableDrop( _this_, _format_, _action_, _type_=0)
  EndMacro
  
  Define i, Event
  If OpenWindow(#Window, 0, 0, 760, 310, "Drag & Drop", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
    Open(#Window)
    ; Create some images for the image demonstration
    ; 
    CreateImage(#ImageSource, 136, 136)
    If StartDrawing(ImageOutput(#ImageSource))
      Box(0, 0, 136, 136, $FFFFFF)
      DrawText(5, 5, "Drag this image", $000000, $FFFFFF)        
      For i = 45 To 1 Step -1
        Circle(70, 80, i, Random($FFFFFF))
      Next i        
      
      StopDrawing()
    EndIf  
    
    CreateImage(#ImageTarget, 136, 136)
    If StartDrawing(ImageOutput(#ImageTarget))
      Box(0, 0, 136, 136, $FFFFFF)
      DrawText(5, 5, "Drop images here", $000000, $FFFFFF)
      StopDrawing()
    EndIf  
    
    
    ; Create and fill the source gadgets
    ;
    SourceText = ListIcon(10, 10, 140, 140, "Drag Text here", 130)   
    SourceImage = Image(160, 10, 140, 140, ImageID(#ImageSource), #PB_Image_Border) 
    SourceFiles = ExplorerList(310, 10, 290, 140, GetHomeDirectory(), #PB_Explorer_MultiSelect)
    SourcePrivate = ListIcon(610, 10, 140, 140, "Drag private stuff here", 260)
    
    AddItem(SourceText, -1, "hello world")
    AddItem(SourceText, -1, "The quick brown fox jumped over the lazy dog")
    AddItem(SourceText, -1, "abcdefg")
    AddItem(SourceText, -1, "123456789")
    
    AddItem(SourcePrivate, -1, "Private type 1")
    AddItem(SourcePrivate, -1, "Private type 2")
    
    
    ; Create the target gadgets
    ;
    TargetText = ListIcon(10, 160, 140, 140, "Drop Text here", 130)
    TargetImage = Image(160, 160, 140, 140, ImageID(#ImageTarget), #PB_Image_Border) 
    TargetFiles = ListIcon(310, 160, 140, 140, "Drop Files here", 130)
    TargetPrivate1 = ListIcon(460, 160, 140, 140, "Drop Private Type 1 here", 130)
    TargetPrivate2 = ListIcon(610, 160, 140, 140, "Drop Private Type 2 here", 130)
    
    
    ; Now enable the dropping on the target gadgets
    ;
    EnableDrop(TargetText,     #PB_Drop_Text,    #PB_Drag_Copy)
    EnableDrop(TargetImage,    #PB_Drop_Image,   #PB_Drag_Copy)
    EnableDrop(TargetFiles,    #PB_Drop_Files,   #PB_Drag_Copy)
    EnableDrop(TargetPrivate1, #PB_Drop_Private, #PB_Drag_Copy, 1)
    EnableDrop(TargetPrivate2, #PB_Drop_Private, #PB_Drag_Copy, 2)
    
    BindEvent(#PB_Event_Gadget, @events_())
    BindEvent(#PB_Event_GadgetDrop, @events_())
    
    Repeat
      Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
  
  End
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = 0-6
; EnableXP