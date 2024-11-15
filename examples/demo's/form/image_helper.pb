CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  XIncludeFile "../../../widgets.pbi"
CompilerEndIf


;{ Window  functions
EnableExplicit
   UseWidgets( )
   
Global Window_0=-1, Image_View=-1, Button_Load=-1, Button_Ok=-1, Button_Cancel=-1
Global Window_0_OpenFile$, Window_0_0_Image=-1, Event_=-1, Properties_Image=-1, Properties_ImageBg=-1

Procedure CFE_Helper_Buttons_Events( )
  Protected Checked ;= *Create\Checked
  
  Select WidgetEvent( )
    Case #__Event_Close
      Close( EventWidget( ) )
      
    Case #__Event_LeftClick
      Select EventWidget( )
        Case Button_Cancel
          Close( GetWindow( Button_Cancel ) )
          
        Case Button_Ok 
          Window_0_0_Image = GetState(Image_View)
          
          Select Event_ ; Is(*Create\Checked)
            Case Properties_ImageBg
              SetBackGroundImage(Checked, Window_0_0_Image)
              
            Case Properties_Image
              If WidgetWidth(Checked) <> ImageWidth(Window_0_0_Image) And Not IsContainer(Checked)
                
                If MessageRequester("Сообщение","Хотите изменить размер элемента?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
                  SetText(Checked, "")
                  Resize(Checked, #PB_Ignore, #PB_Ignore, ImageWidth(Window_0_0_Image)+8+1, ImageHeight(Window_0_0_Image)+8+1)
                EndIf
                
              EndIf
              
              SetImage(Checked, Window_0_0_Image)
          EndSelect
          
          SetText(Event_, Window_0_OpenFile$)
          ;*Create\ImagePuch(Str(Window_0_0_Image)) = Window_0_OpenFile$
          
          Close(Button_Ok)
          
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
  Protected X,Y,Width=346,Height=176, View
  Flag.q | #PB_Window_SystemMenu|#PB_Window_SizeGadget
  
  ; = Open(#PB_Any, #PB_Ignore,#PB_Ignore,200,300, "Image editor",Flag, Parent) 
  
  If ((Flag & #PB_Window_ScreenCentered) = #PB_Window_ScreenCentered)
;     X = (WidgetWidth(0)-Width)/2 
;     Y = (WidgetHeight(0)-Height)/2
    
  ElseIf ((Flag & #PB_Window_WindowCentered) = #PB_Window_WindowCentered)
    If Parent
      X = (WidgetWidth(Parent)-Width)/2 
      Y = (WidgetHeight(Parent)-Height)/2
    EndIf
  EndIf
  
  Window_0 = Window( X,Y, Width, Height, "Редактор изображения", Flag|#PB_Window_Invisible)
  Sticky(Window_0, #True)
  
  Image_View = Image(5, 5, 231, 166, 0);, #_Flag_Image_Center)
  ;
  Button_Load = Button(240, 5, 101, 21, "Загрузить")
  Button_Ok = Button(240, 125, 101, 21, "Применить")
  Button_Cancel = Button(240, 150, 101, 21, "Отмена")
  ;
  Bind(Window_0, @CFE_Helper_Buttons_Events())
  ; BindGadgetEvent(e, @ButtonEvent(), #_Event_LeftClick)
  HideWidget(Window_0, #False)
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
  Open(#PB_Any, 0,0, 432,284+4*65, "Demo ()") 
  
  Define Window = root( )
  ;a_init(Window)
  ;Define  h = GetAttribute(Window, #_Attribute_CaptionHeight)
  Define gImage 
  CFE_Helper_Image(Window)
  Debug gImage
  
  WaitClose(Window)
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 97
; FirstLine = 93
; Folding = ---
; Optimizer
; EnableXP
; DPIAware