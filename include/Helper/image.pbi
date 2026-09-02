XIncludeFile "../../widgets.pbi" 

EnableExplicit
UseWidgets( )

; test_draw_area = 1

Global IH_W=-1, 
       IH_G_Area=-1,
       IH_G_View=-1,
       IH_G_Open=-1,
       IH_G_Save=-1,
       IH_G_Copy=-1,
       IH_G_Cut=-1,
       IH_G_Paste=-1,
       IH_G_Ok=-1,
       IH_G_Cancel=-1

Declare IH_W_Events( )

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

CompilerIf #PB_Compiler_DPIAware
   ResizeImage(0, DesktopScaledX(ImageWidth(0)), DesktopScaledY(ImageHeight(0)), #PB_Image_Raw )
   ResizeImage(1, DesktopScaledX(ImageWidth(1)), DesktopScaledY(ImageHeight(1)), #PB_Image_Raw )
   ResizeImage(2, DesktopScaledX(ImageWidth(2)), DesktopScaledY(ImageHeight(2)), #PB_Image_Raw )
   ResizeImage(3, DesktopScaledX(ImageWidth(3)), DesktopScaledY(ImageHeight(3)), #PB_Image_Raw )
   ResizeImage(4, DesktopScaledX(ImageWidth(4)), DesktopScaledY(ImageHeight(4)), #PB_Image_Raw )
CompilerEndIf


Procedure IH_W_Open(ParentID.i=0, Flag.i=#PB_Window_TitleBar|#PB_Window_ScreenCentered)
   If IsWindow(IH_W)
      SetActiveWindow(IH_W)
      ProcedureReturn IH_W
   EndIf
   Protected i = 10, ii = 10
   IH_W = GetCanvasWindow(Open(#PB_Any, 398, 133, 376+ii+i*2, 226+i*2, "ImageHelper", Flag, ParentID))                                                  
   ;IH_G_Area = ScrollArea( 5, 5, 291, 191, 291-30, 191-30, #PB_ScrollArea_Flat)           
   IH_G_View = Image(i, i, 271, 225, (0),#__flag_ImageCenter) 
   SetBackgroundColor( IH_G_View, $FFB3FDFF )
   ;CloseList( )
   IH_G_Open = Button(i+271+ii, i, 101, 25, "Open", #__flag_Imageleft )       : SetImage(IH_G_Open, (0))
   IH_G_Save = Button(i+271+ii, i+30, 101, 25, "Save", #__flag_Imageleft )      : SetImage(IH_G_Save, (1))
   IH_G_Copy = Button(i+271+ii, i+70, 101, 25, "Copy", #__flag_Imageleft )      : SetImage(IH_G_Copy, (2))
   IH_G_Cut = Button(i+271+ii, i+100, 101, 25, "Cut", #__flag_Imageleft )        : SetImage(IH_G_Cut, (3))
   IH_G_Paste = Button(i+271+ii, i+130, 101, 25, "Paste", #__flag_Imageleft )   : SetImage(IH_G_Paste, (4)) 
   IH_G_Ok = Button(i+271+ii, i+170, 101, 25, "Ok")         ;: SetImage(IH_G_Ok, (0))
   IH_G_Cancel = Button(i+271+ii, i+200, 101, 25, "Cancel") ;: SetImage(IH_G_Cancel, (0))                                                            
   
   Bind( #PB_All, @IH_W_Events( ))
   ProcedureReturn IH_W
EndProcedure

Procedure IH_W_Events( )
   Protected File$
   
   Select WidgetEvent( )
      Case #__event_LeftClick
         Select EventWidget( )
            Case IH_G_Open
               File$ = OpenFileRequester("","","Image (*.png,*.bmp,*.ico,*.tiff)|*.png;*.bmp;*.ico;*.tiff|All files (*.*)|*.*",0)
               If File$
                  UseImageDecoder( File$ )
                  
                  Protected img = LoadImage(#PB_Any, File$)
                  If IsImage(img)
                     ;                   If ImageWidth(img) > GetGadgetAttribute(IH_G_Area, #PB_ScrollArea_InnerWidth)
                     ;                     SetGadgetAttribute(IH_G_Area, #PB_ScrollArea_InnerWidth, ImageWidth(img))
                     ;                   EndIf
                     ;                   If ImageHeight(img) > GetGadgetAttribute(IH_G_Area, #PB_ScrollArea_InnerHeight)
                     ;                     SetGadgetAttribute(IH_G_Area, #PB_ScrollArea_InnerHeight, ImageHeight(img))
                     ;                   EndIf
                     SetState(IH_G_View, (img))
                  EndIf
               EndIf
               
            Case IH_G_Cancel
               PostEvent( #PB_Event_CloseWindow, IH_W, - 1 )
               
         EndSelect
   EndSelect
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
   IH_W_Open()
   
   Define Event 
   While IsWindow(IH_W)
      Event = WaitWindowEvent()
      
      Select EventWindow()
         Case IH_W
            If Event = #PB_Event_CloseWindow
               CloseWindow(EventWindow())
            EndIf
            
      EndSelect
   Wend
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 126
; FirstLine = 63
; Folding = ----
; EnableXP
; DPIAware