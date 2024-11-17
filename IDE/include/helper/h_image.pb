XIncludeFile "../../../widgets.pbi"
UseWidgets( )

EnableExplicit

Global W_IH=-1, 
       G_IH_ScrollArea_0=-1,
       G_IH_View=-1,
       G_IH_Open=-1,
       G_IH_Save=-1,
       G_IH_Copy=-1,
       G_IH_Cut=-1,
       G_IH_Paste=-1,
       G_IH_Ok=-1,
       G_IH_Cancel=-1

Declare W_IH_Events(Event)

Procedure UseImageDecoder( FullPathName$ )
  Select GetExtensionPart( FullPathName$ )
    Case "gif"  : UseGIFImageDecoder() 
    Case "png"  : UsePNGImageDecoder() 
    Case "tga"  : UseTGAImageDecoder()
    Case "tiff" : UseTIFFImageDecoder() 
    Case "jpeg" : UseJPEGImageDecoder() 
    Case "jpg"  : UseJPEG2000ImageDecoder()
  EndSelect
EndProcedure

Procedure W_IH_CallBack()
  W_IH_Events(Event())
EndProcedure

Procedure W_IH_Open(ParentID.i=0, Flag.i=#PB_Window_TitleBar|#PB_Window_ScreenCentered)
;   If IsWindow(W_IH)
;     SetActiveWindow(W_IH)
;     ProcedureReturn W_IH
;   EndIf
  
  ;W_IH = GetCanvasWindow(Open(OpenWindow(#PB_Any, 398, 133, 386, 201, "ImageHelper", Flag, ParentID)))                                                
  ;W_IH = 
  Window(10, 10, 386, 201, "ImageHelper", Flag, ParentID)                                               
  ;G_IH_ScrollArea_0 = ScrollArea(5, 5, 291, 191, 291-30, 191-30, #PB_ScrollArea_Flat)           
  G_IH_View = Image(5, 5, 291, 191, -1)    
  ;CloseList()
  G_IH_Open = Button(300, 5, 81, 21, "Open")    
  G_IH_Save = Button(300, 30, 81, 21, "Save")    
  G_IH_Copy = Button(300, 65, 81, 21, "Copy")    
  G_IH_Cut = Button(300, 90, 81, 21, "Cut")     
  G_IH_Paste = Button(300, 115, 81, 21, "Paste")   
  G_IH_Ok = Button(300, 150, 81, 21, "Ok")      
  G_IH_Cancel = Button(300, 175, 81, 21, "Cancel")                                                               
  
  ProcedureReturn W_IH
EndProcedure

Procedure W_IH_Events(Event)
  Protected File$
  
  Select Event
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Select EventGadget()
            Case G_IH_Open
              File$ = OpenFileRequester("","","Image (*.png,*.bmp,*.ico,*.tiff)|*.png;*.bmp;*.ico;*.tiff|All files (*.*)|*.*",0)
              If File$
                UseImageDecoder( File$ )
                
                Protected img = LoadImage(#PB_Any, File$)
                If IsImage(img)
                  If ImageWidth(img) > GetGadgetAttribute(G_IH_ScrollArea_0, #PB_ScrollArea_InnerWidth)
                    SetGadgetAttribute(G_IH_ScrollArea_0, #PB_ScrollArea_InnerWidth, ImageWidth(img))
                  EndIf
                  If ImageHeight(img) > GetGadgetAttribute(G_IH_ScrollArea_0, #PB_ScrollArea_InnerHeight)
                    SetGadgetAttribute(G_IH_ScrollArea_0, #PB_ScrollArea_InnerHeight, ImageHeight(img))
                  EndIf
                  SetGadgetState(G_IH_View, ImageID(img))
                EndIf
              EndIf
              
            Case G_IH_Cancel
              ProcedureReturn #PB_Event_CloseWindow
              
          EndSelect
      EndSelect
  EndSelect
  
  ProcedureReturn Event
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  W_IH = GetCanvasWindow(Open(#PB_Any, 398, 133, 886, 601, "ImageHelper", #PB_Window_TitleBar|#PB_Window_ScreenCentered))
  W_IH_Open()
  
  While IsWindow(W_IH)
    Define Event = WaitWindowEvent()
    
    Select EventWindow()
      Case W_IH
        If W_IH_Events( Event ) = #PB_Event_CloseWindow
          
          CloseWindow(EventWindow())
        EndIf
        
    EndSelect
  Wend
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = v--
; EnableXP
; DPIAware