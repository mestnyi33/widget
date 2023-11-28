EnableExplicit
CompilerIf #PB_Compiler_OS=#PB_OS_Linux
   ImportC "-gtk"
      gtk_window_set_opacity(*Window.i, Opacity.d);
      gtk_widget_is_composited(*Widget)
   EndImport
   
   Procedure.i SetWindowTransparency(Window, Transparency=255)
      Protected *windowID=WindowID(Window), alpha.d=Transparency/255.0
      If Transparency>=0 And Transparency<=255
         If gtk_widget_is_composited(*windowID)
            gtk_window_set_opacity(*windowID, alpha.d)
            ProcedureReturn #True
         EndIf
      EndIf
   EndProcedure
CompilerElseIf #PB_Compiler_OS=#PB_OS_MacOS
   Procedure.i SetWindowTransparency(Window, Transparency=255)
      Protected *windowID=WindowID(Window), alpha.CGFloat=Transparency/255.0
      If Transparency>=0 And Transparency<=255
         CocoaMessage(0, *windowID, "setOpaque:", #NO)
         If CocoaMessage(0, *windowID, "isOpaque")=#NO
            CocoaMessage(0, *windowID, "setAlphaValue:@", @alpha)
            ProcedureReturn #True
         EndIf
      EndIf
   EndProcedure
CompilerElseIf #PB_Compiler_OS=#PB_OS_Windows
   Procedure.i SetWindowTransparency(Window, Transparency=255)
      Protected *windowID=WindowID(Window), exStyle=GetWindowLongPtr_(*windowID, #GWL_EXSTYLE)
      If Transparency>=0 And Transparency<=255
         SetWindowLongPtr_(*windowID, #GWL_EXSTYLE, exStyle | #WS_EX_LAYERED)
         SetLayeredWindowAttributes_(*windowID, 0, Transparency, #LWA_ALPHA)
         
         ProcedureReturn #True
      EndIf
   EndProcedure
CompilerEndIf

Structure DRAG_PREVIEW
   Hidden.i
   Window.i
   Image.i
   ImageNoDrop.i
   ImageGadget.i
   OffsetX.i
   OffsetY.i
   Transparency.i
EndStructure
Global DragPreview.DRAG_PREVIEW
Enumeration
   #DragPreview_Normal
   #DragPreview_NoDrop
EndEnumeration
Procedure.i DragImagePreview(PreviewMode=#DragPreview_Normal, PreviewImage=#PB_Ignore, OffsetX=#PB_Ignore, OffsetY=#PB_Ignore, Transparency=#PB_Ignore)
   With DragPreview
      ; change offset if necessary
      If OffsetX<>#PB_Ignore : \OffsetX=OffsetX : EndIf
      If OffsetY<>#PB_Ignore : \OffsetY=OffsetY : EndIf
      
      ; create preview window
      If Not \Window
         \Hidden=OpenWindow(#PB_Any, 0, 0, 0, 0, "", #PB_Window_Invisible)
         StickyWindow(\Hidden, #True)
         \Window=OpenWindow(#PB_Any, 0, 0, ImageWidth(PreviewImage), ImageHeight(PreviewImage), "Dragged Window",
                            #PB_Window_BorderLess|
                            #PB_Window_Invisible,
                            WindowID(\Hidden))
         \Image=#PB_Ignore
         \ImageGadget=ImageGadget(#PB_Any, 0, 0, WindowWidth(\Window), WindowHeight(\Window), #Null)
         DisableWindow(\Window, #True)
         SmartWindowRefresh(\Window, #True)
      EndIf
      If Not \Window
         ProcedureReturn #Null
      EndIf
      
      ; change preview transparency
      If Transparency<>#PB_Ignore
         \Transparency=Transparency
         SetWindowTransparency(\Window, \Transparency)
      EndIf
      
      If PreviewImage<>#PB_Ignore And PreviewImage<>\Image
         \Image=PreviewImage
         \ImageNoDrop=CopyImage(\Image, #PB_Any)
         ; redraw preview alternate image if necessary
         StartDrawing(ImageOutput(\ImageNoDrop))
         DrawingMode(#PB_2DDrawing_AlphaBlend)
         Box(0, 0, WindowWidth(\Window), WindowHeight(\Window), RGBA(100, 100, 100, 100))
         StopDrawing()
         ; resize preview if necessary
         ResizeWindow(\Window, #PB_Ignore, #PB_Ignore, ImageWidth(\Image), ImageHeight(\Image))
         ResizeGadget(\ImageGadget, 0, 0, WindowWidth(\Window), WindowHeight(\Window))
         
      EndIf
      
      ; select preview image
      Select PreviewMode
         Case #DragPreview_Normal : SetGadgetState(\ImageGadget, ImageID(\Image))
         Case #DragPreview_NoDrop : SetGadgetState(\ImageGadget, ImageID(\ImageNoDrop))
      EndSelect
      
      ; follow mouse position
      Protected x=DesktopMouseX()+\OffsetX
      Protected y=DesktopMouseY()+\OffsetY
      ResizeWindow(\Window, x, y, #PB_Ignore, #PB_Ignore)      
      
      ProcedureReturn \Window
   EndWith
EndProcedure
Procedure DropWindowCallback(TargetHandle, State, Format, Action, x, y)
   
   If State=#PB_Drag_Update
      Protected allowDrop=Bool(Action<>#PB_Drag_None)
      If allowDrop
         DragImagePreview()
      Else
         DragImagePreview(#DragPreview_NoDrop)
      EndIf
      If DragPreview\Window
         HideWindow(DragPreview\Window, #False)
      EndIf
      ProcedureReturn allowDrop
      
    ElseIf State=#PB_Drag_Enter
      
   ElseIf State=#PB_Drag_Leave
      If DragPreview\Window
         HideWindow(DragPreview\Window, #True)
      EndIf
      
   ElseIf State=#PB_Drag_Finish
      If DragPreview\Window
         HideWindow(DragPreview\Window, #True)
      EndIf
   EndIf
   
   ProcedureReturn #True
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   ; ************************************
   ; DRAG'N DROP WITH IMAGE PREVIEW
   ; ************************************
   DisableExplicit
   SetDropCallback(@DropWindowCallback())
   
   Procedure AlternateColors(Expression, c1, c2)
      ProcedureReturn Bool(Expression)*c1+Bool(Not expression)*c2
   EndProcedure
   
   Enumeration
      #Window = 0
      
      ; Images
      #ImageSource=0
      #ImageTarget
      
      ; Gadgets
      #SourceImage=0
      #TargetImage
      
      ; Custom Private Drop types
      #PrivateType_CustomLayer=123
   EndEnumeration
   
   If OpenWindow(#Window, 0, 0, 400, 310, "Drag & Drop Link of custom private type", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
      StickyWindow(#Window, 1) 
      ; Create some images for the image demonstration
      CreateImage(#ImageSource, 136, 136, 24, $FFFFFF)
      If StartDrawing(ImageOutput(#ImageSource))
         DrawText(5, 5, "Drag image layer", $000000, $FFFFFF)
         For i = 45 To 1 Step -9
            Circle(70, 80, i, AlternateColors(i % 2, $FF48F591, $FFA2D26B))
         Next
         StopDrawing()
      EndIf
      CreateImage(#ImageTarget, 136, 136, 24, $FFFFFF)
      If StartDrawing(ImageOutput(#ImageTarget))
         DrawText(5, 5, "Drop layer here", $000000, $FFFFFF)
         StopDrawing()
      EndIf
      
      ; Create gadgets
      ImageGadget(#SourceImage, 10, 10, 140, 140, ImageID(#ImageSource), #PB_Image_Border)
      ImageGadget(#TargetImage, 10, 160, 140, 140, ImageID(#ImageTarget), #PB_Image_Border)
      ; Allow common drag-drop actions on Windows
      EnableWindowDrop(#Window, #PB_Drop_Files, #PB_Drag_Copy|#PB_Drag_Link|#PB_Drag_Move)
      EnableWindowDrop(#Window, #PB_Drop_Image, #PB_Drag_Copy|#PB_Drag_Link|#PB_Drag_Move)
      EnableWindowDrop(#Window, #PB_Drop_Text, #PB_Drag_Copy|#PB_Drag_Link|#PB_Drag_Move)
      ; Allow custom drag-drop actions on Gadgets
      EnableGadgetDrop(#TargetImage, #PB_Drop_Private, #PB_Drag_Copy|#PB_Drag_Link, #PrivateType_CustomLayer)
      
      Repeat
         Event = WaitWindowEvent()
         
         ; DragStart event on the source gadgets, initiate a drag & drop (LINK MODE)
         If Event = #PB_Event_Gadget And EventType()= #PB_EventType_DragStart
            Select EventGadget()
               Case #SourceImage
                  DragImagePreview(#DragPreview_Normal, #ImageSource, 10, 10, 200)
                  DragPrivate(#PrivateType_CustomLayer, #PB_Drag_Link)
            EndSelect
         EndIf
         
         ; Drop event on the target gadgets, receive the dropped data
         If Event = #PB_Event_GadgetDrop
            Select EventGadget()
               Case #TargetImage
                  If EventDropPrivate()=#PrivateType_CustomLayer
                     SetGadgetState(#TargetImage, ImageID(#SourceImage))
                     If EventDropAction()=#PB_Drag_Link
                        ;
                        ; YOUR CODE HERE : CREATE LINK...
                        ;
                     EndIf
                  EndIf
            EndSelect
         EndIf
         
      Until Event = #PB_Event_CloseWindow
   EndIf
   End
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = +-----
; EnableXP