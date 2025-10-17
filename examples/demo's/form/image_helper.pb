CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   XIncludeFile "../../../widgets.pbi"
CompilerEndIf


;{ Window  functions
EnableExplicit
UseWidgets( )

Global Window_0=-1, Image_View=-1, Button_Load=-1, Button_Save=-1, Button_Copy=-1, Button_Cut=-1, Button_Paste=-1, Button_Ok=-1, Button_Cancel=-1
Global Window_0_OpenFile$, Window_0_0_Image=-1, Event_=-1, Properties_Image=-1, Properties_ImageBg=-1

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


Procedure CFE_Helper_Buttons_Events( )
   Protected Checked ;= *Create\Checked
   
   Select WidgetEvent( )
      Case #__Event_Close
         ProcedureReturn #True
         
      Case #__Event_Free
         ProcedureReturn #True
         
      Case #__Event_LeftClick
         Select EventWidget( )
            Case Button_Cancel
               Free( GetWindow( Button_Cancel ) )
               
            Case Button_Ok 
               Window_0_0_Image = GetState(Image_View)
               
               If IsImage( Window_0_0_Image )
                  If Checked
                     Select Event_ ; Is(*Create\Checked)
                        Case Properties_ImageBg
                           SetBackgroundImage(Checked, Window_0_0_Image)
                           
                        Case Properties_Image
                           If Width(Checked) <> ImageWidth(Window_0_0_Image) And Not IsContainer(Checked)
                              
                              If MessageRequester("Сообщение","Хотите изменить размер элемента?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
                                 SetText(Checked, "")
                                 Resize(Checked, #PB_Ignore, #PB_Ignore, ImageWidth(Window_0_0_Image)+8+1, ImageHeight(Window_0_0_Image)+8+1)
                              EndIf
                              
                           EndIf
                           
                           SetImage(Checked, Window_0_0_Image)
                     EndSelect
                     
                     SetText(Event_, Window_0_OpenFile$)
                     ;*Create\ImagePuch(Str(Window_0_0_Image)) = Window_0_OpenFile$
                  EndIf
               EndIf
            
               Free( GetWindow( Button_Ok ) )
              
            Case Button_Load
               Protected StandardFile$ = "C:\Users\mestnyi\Google Диск\SyncFolder()\Module()\"  
               Protected Pattern$ = "Image (png;bmp)|*.png;*.gif;*.bmp|All files (*.*)|*.*"
               Protected Pattern = 0    ; use the first of the three possible patterns as standard
               Window_0_OpenFile$ = OpenFileRequester("Please choose file to load", StandardFile$, Pattern$, Pattern)
               Protected img = LoadImage(#PB_Any, Window_0_OpenFile$)
               
               
               UsePNGImageDecoder()
               If img
                  SetState(Image_View, img)
               EndIf
               
         EndSelect
   EndSelect
   
EndProcedure

Procedure CFE_Helper_Image(Parent =- 1, *Image.Integer=0, *Puth.String=0, WindowID = #False, Flag.q = #PB_Window_ScreenCentered)
   Protected i = 10, ii = 10
  Protected X=30,Y=30,Width=392+ii+i*2,Height=226+i*2, View
   Flag.q | #PB_Window_SystemMenu|#PB_Window_SizeGadget
   
   ; = Open(#PB_Any, #PB_Ignore,#PB_Ignore,200,300, "Image editor",Flag, Parent) 
   
   If ((Flag & #PB_Window_ScreenCentered) = #PB_Window_ScreenCentered)
      ;     X = (Width(0)-Width)/2 
      ;     Y = (Height(0)-Height)/2
      
   ElseIf ((Flag & #PB_Window_WindowCentered) = #PB_Window_WindowCentered)
      If Parent
         X = (Width(Parent)-Width)/2 
         Y = (Height(Parent)-Height)/2
      EndIf
   EndIf
   
   Window_0 = Window( X,Y, Width, Height, "Редактор изображения", Flag|#PB_Window_Invisible)
   Sticky(Window_0, #True)
   
  ;Button_ScrollArea_0 = ScrollArea( 5, 5, 291, 191, 291-30, 191-30, #PB_ScrollArea_Flat)           
  image_View = Image(i, i, 271, 225, (0),#__flag_ImageCenter) 
  SetBackColor( image_View, $FFB3FDFF )
  ;CloseList( )
  Button_Load = Button(i+271+ii, i, 121, 25, "Загрузить", #__flag_Imageleft )       : SetImage(Button_Load, (0))
  Button_Save = Button(i+271+ii, i+30, 121, 25, "Сохранить", #__flag_Imageleft )    : SetImage(Button_Save, (1))
  Button_Copy = Button(i+271+ii, i+70, 121, 25, "Копировать", #__flag_Imageleft )   : SetImage(Button_Copy, (2))
  Button_Cut = Button(i+271+ii, i+100, 121, 25, "Вырезать", #__flag_Imageleft )     : SetImage(Button_Cut, (3))
  Button_Paste = Button(i+271+ii, i+130, 121, 25, "Вставить", #__flag_Imageleft )   : SetImage(Button_Paste, (4)) 
  Button_Ok = Button(i+271+ii, i+170, 121, 25, "Применить", #__flag_Imageleft)         ;: SetImage(Button_Ok, (0))
  Button_Cancel = Button(i+271+ii, i+200, 121, 25, "Отмена", #__flag_Imageleft) ;: SetImage(Button_Cancel, (0))                                                            
  
   
   ;
   Bind(Window_0, @CFE_Helper_Buttons_Events())
   ; BindGadgetEvent(e, @ButtonEvent(), #_Event_LeftClick)
   Hide(Window_0, #False)
   CloseList()
   
   ; WaitQuit( )
   
   If *Image
      *Image\i = Window_0_0_Image
   EndIf
   
   
   ProcedureReturn 
EndProcedure

;}

;-
; Window  example
CompilerIf #PB_Compiler_IsMainFile
   Open(#PB_Any, 30,30, 532,284+4*65, "Demo ()") 
   
   Define Window = root( )
   ;a_init(Window)
   ;Define  h = GetAttribute(Window, #_Attribute_CaptionHeight)
   Define gImage 
   CFE_Helper_Image(Window)
   Debug gImage
   
   WaitClose(Window)
CompilerEndIf

; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 109
; FirstLine = 124
; Folding = ----
; Optimizer
; EnableXP
; DPIAware