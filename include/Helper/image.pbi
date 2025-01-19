XIncludeFile "../../widgets.pbi" 

EnableExplicit
UseWidgets( )

; test_draw_area = 1
   
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

Declare W_IH_Events( )

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

If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
   End
EndIf

If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png")
   End
EndIf

If Not LoadImage(2, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png")
   End
EndIf

If Not LoadImage(3, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png")
   End
EndIf

If Not LoadImage(4, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
   End
EndIf

; If Not LoadImage(5, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cancel.png")
;    End
; EndIf
  
  
Procedure W_IH_Open(ParentID.i=0, Flag.i=#PB_Window_TitleBar|#PB_Window_ScreenCentered)
  If IsWindow(W_IH)
    SetActiveWindow(W_IH)
    ProcedureReturn W_IH
  EndIf
  Protected i = 10, ii = 10
  W_IH = GetCanvasWindow(Open(#PB_Any, 398, 133, 376+ii+i*2, 226+i*2, "ImageHelper", Flag, ParentID))                                                  
  ;G_IH_ScrollArea_0 = ScrollArea( 5, 5, 291, 191, 291-30, 191-30, #PB_ScrollArea_Flat)           
  G_IH_View = Image(i, i, 271, 225, (0),#__image_Center) 
  SetBackgroundColor( G_IH_View, $FFB3FDFF )
  ;CloseList( )
  G_IH_Open = Button(i+271+ii, i, 101, 25, "Open", #__image_left )       : SetImage(G_IH_Open, (0))
  G_IH_Save = Button(i+271+ii, i+30, 101, 25, "Save", #__image_left )      : SetImage(G_IH_Save, (1))
  G_IH_Copy = Button(i+271+ii, i+70, 101, 25, "Copy", #__image_left )      : SetImage(G_IH_Copy, (2))
  G_IH_Cut = Button(i+271+ii, i+100, 101, 25, "Cut", #__image_left )        : SetImage(G_IH_Cut, (3))
  G_IH_Paste = Button(i+271+ii, i+130, 101, 25, "Paste", #__image_left )   : SetImage(G_IH_Paste, (4)) 
  G_IH_Ok = Button(i+271+ii, i+170, 101, 25, "Ok")         ;: SetImage(G_IH_Ok, (0))
  G_IH_Cancel = Button(i+271+ii, i+200, 101, 25, "Cancel") ;: SetImage(G_IH_Cancel, (0))                                                            
  
  Bind( #PB_All, @W_IH_Events( ) )
  ProcedureReturn W_IH
EndProcedure

Procedure W_IH_Events( )
  Protected File$
  
  Select WidgetEvent( )
     Case #__event_LeftClick
        Select EventWidget( )
           Case G_IH_Open
              File$ = OpenFileRequester("","","Image (*.png,*.bmp,*.ico,*.tiff)|*.png;*.bmp;*.ico;*.tiff|All files (*.*)|*.*",0)
              If File$
                 UseImageDecoder( File$ )
                 
                 Protected img = LoadImage(#PB_Any, File$)
                 If IsImage(img)
                    ;                   If ImageWidth(img) > GetGadgetAttribute(G_IH_ScrollArea_0, #PB_ScrollArea_InnerWidth)
                    ;                     SetGadgetAttribute(G_IH_ScrollArea_0, #PB_ScrollArea_InnerWidth, ImageWidth(img))
                    ;                   EndIf
                    ;                   If ImageHeight(img) > GetGadgetAttribute(G_IH_ScrollArea_0, #PB_ScrollArea_InnerHeight)
                    ;                     SetGadgetAttribute(G_IH_ScrollArea_0, #PB_ScrollArea_InnerHeight, ImageHeight(img))
                    ;                   EndIf
                    SetState(G_IH_View, (img))
                 EndIf
              EndIf
              
           Case G_IH_Cancel
              PostEvent( #PB_Event_CloseWindow, W_IH, - 1 )
              
        EndSelect
  EndSelect
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
   Define Event 
   W_IH_Open()
  
  While IsWindow(W_IH)
    Event = WaitWindowEvent()
    
    Select EventWindow()
      Case W_IH
        If Event = #PB_Event_CloseWindow
          CloseWindow(EventWindow())
        EndIf
        
    EndSelect
  Wend
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 62
; FirstLine = 46
; Folding = ---
; EnableXP
; DPIAware