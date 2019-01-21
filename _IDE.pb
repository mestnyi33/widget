;-
XIncludeFile "/Users/as/Documents/GitHub/Widget/widgets.pbi"
; Declare CFE_Helper_Image(Parent =- 1, *Image.Integer=0, *Puth.String=0, WindowID = #False, Flag.q = #_Flag_ScreenCentered)
; XIncludeFile "CFE_Helper_Image.pbi"

Structure Copyies
  Widget.i
  Parent$
  Window$
  
  FontID$
  IageID$
  
  Type$
  Class$
  X$
  Y$
  Width$
  Height$
  Caption$
  Param1$
  Param2$
  Param3$
  Flag$
EndStructure

Global NewMap Copyies.Copyies()


Procedure UpdateWidgetFlag(Panel, pWidget)
  Protected i, j, Buffer$, Parent, Widget
  ; Каковы возможные флаги для выбранного гаджета?
  ;Buffer$=MGadget(Gadgets(GetGadgetData(IDGadget))\IdModel)\Flag$
  ClearGadgetItems(pWidget)
  For i=1 To CountString(Buffer$,",")+1
    If Trim(StringField(Buffer$,i,","))<>""
      AddGadgetItem(pWidget, -1, StringField(Buffer$,i,","))
    EndIf
  Next
  
  While Enumerate(@Parent, Panel, 0)
    Buffer$ +"Global "+ GetWidgetEvents(Parent)+"=-1"
    
    While Enumerate(@Widget, WidgetID(Parent))
      If Buffer$ : Buffer$+", " : EndIf : Buffer$ +GetWidgetEvents(Widget)+"=-1"
    Wend
    
    Buffer$ +#CRLF$
  Wend
  
  ; Какие флаги будут использоваться для выбранного гаджета?
  ;Buffer$=Gadgets(GetGadgetData(IDGadget))\Flag$
  For i=1 To CountString(Buffer$,"|")+1
    For j=0 To CountGadgetItems(pWidget)-1
      If GetGadgetItemText(pWidget,j)=StringField(Buffer$,i,"|")
        SetGadgetItemState(pWidget, j, #PB_ListIcon_Checked)
      EndIf
    Next
  Next
EndProcedure

Declare NewWidgetEvents(Event.q, EventWidget)

Procedure.S IsFindFunctions(ReadString$) ; Ok
  Protected Finds.S, Type.S
  Restore Types
  Read$ Type.S
  
  While Type.S 
    If FindString(ReadString$, Type.S+"(") 
      Finds.S = "Find >> "+ReadString$
    EndIf
    
    If Finds.S
      Break
    EndIf
    Read$ Type.S
  Wend
  
  ProcedureReturn Finds.S
  
  DataSection
    Types: 
    Data$ "OpenWindow"
    Data$ "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget",
          "OptionGadget","ListViewGadget","FrameGadget","ComboBoxGadget",
          "ImageGadget","HyperLinkGadget","ContainerGadget","ListIconGadget",
          "IPAddressGadget","ProgressBarGadget","ScrollBarGadget","ScrollAreaGadget",
          "TrackBarGadget","WebGadget","ButtonImageGadget","CalendarGadget",
          "DateGadget","EditorGadget","ExplorerListGadget","ExplorerTreeGadget",
          "ExplorerComboGadget","SpinGadget","TreeGadget","PanelGadget",
          "SplitterGadget","MDIGadget","ScintillaGadget","ShortcutGadget","CanvasGadget"
    Data$ ""
  EndDataSection
EndProcedure




Procedure LoadGadgetImage(Gadget, Directory$)
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
                  
                  If FindString(LCase(PackEntryName.S), "cursor")
                    
                    ;SetGadgetAttribute(Gadget, #PB_Button_Image, Image)
                    AddGadgetWidgetItem(Gadget, 0, PackEntryName.S, Image)
                  Else
                    AddGadgetWidgetItem(Gadget, -1, PackEntryName.S, Image)
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

;-
; Рисунок фона окна
Procedure GetIcon(Icon$, Remove$="") 
  Protected ButtonID =- 1
  UsePNGImageDecoder()
  
  Protected Directory$ = GetCurrentDirectory()+"images/" ; "";
  Protected ZipFile$ = Directory$ + "images.zip"
  
  If FileSize(ZipFile$) < 1
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ZipFile$ = #PB_Compiler_Home+"images\images.zip"
    CompilerElse
      ZipFile$ = #PB_Compiler_Home+"images/images.zip"
    CompilerEndIf
    If FileSize(ZipFile$) < 1
      MessageRequester("Designer Error", "images\images.zip Not found in the current directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error|#PB_MessageRequester_Ok)
      End
    EndIf
  EndIf
  
  If FileSize(ZipFile$) > 0
    UsePNGImageDecoder()
    
    CompilerIf #PB_Compiler_Version > 522
      UseZipPacker()
    CompilerEndIf
    
    Protected PackEntryName.s, ImageSize, *Image, ZipFile;, Image
    ZipFile = OpenPack(#PB_Any, ZipFile$, #PB_PackerPlugin_Zip)
    
    If ZipFile  
      If ExaminePack(ZipFile)
        While NextPackEntry(ZipFile)
          
          PackEntryName.S = PackEntryName(ZipFile)
          
          PackEntryName.S = ReplaceString(PackEntryName.S,".png","")
          
          Select PackEntryType(ZipFile)
            Case #PB_Packer_File
              
              Protected Left.S = UCase(Left(PackEntryName.S,1))
              Protected Right.S = Right(PackEntryName.S,Len(PackEntryName.S)-1)
              PackEntryName.S = " "+Left.S+Right.S
              
              If FindString(LCase(PackEntryName.S), Icon$) And FindString(LCase(PackEntryName.S), Remove$) = 0
                ImageSize = PackEntrySize(ZipFile)
                *Image = AllocateMemory(ImageSize)
                UncompressPackMemory(ZipFile, *Image, ImageSize)
                ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                FreeMemory(*Image)
                Break
              EndIf
              
              
          EndSelect
          
        Wend  
      EndIf
      
      ClosePack(ZipFile)
    EndIf
  EndIf
  
  ProcedureReturn ButtonID 
EndProcedure

Procedure Mosaic(Steps, InnerX=0,InnerY=0,InnerWidth=100,InnerHeight=100)
  Protected Img_X, Img_Y, Image =- 1 : Steps - 1
  Image = CreateImage(#PB_Any,InnerWidth-1,InnerHeight-1,32,#PB_2DDrawing_Transparent)
  
  If IsImage(Image) And StartDrawing(ImageOutput(Image))
    DrawingMode(#PB_2DDrawing_AllChannels)
    Box(0,0,OutputWidth(),OutputHeight(),RGBA(0,0,0,0)) ; Прозрачный фон
    
    For Img_X = (InnerX) To (InnerX + InnerWidth)-Steps
      For Img_Y = (InnerY) To (InnerY + InnerHeight)-Steps
        
        Plot(Img_X,Img_Y,RGBA(0,0,0,255))
        
        Img_Y+Steps
      Next
      
      Img_X+Steps
    Next 
    
    StopDrawing()
  EndIf
  
  ProcedureReturn Image
EndProcedure

Procedure.S Help(Class.S)
  Protected Result.S
  
  Select Type(Class.S)
    Case 0
      Result.S = "Элемент не выбран"
      
    Case #_Type_Date
      Result.S = "Первая строка"+#CRLF$+
                 "Вторая строка"
      
    Case #_Type_Window
      Result.S = "Это окно (Window)"
      
    Case #_Type_Button
      Result.S = "Это кнопка (Button)"
      
    Case #_Type_ButtonImage
      Result.S = "Это кнопка картинка (ButtonImage)"
      
      ;     Case #_Type_Calendar
      ;       Result.S = "Это календарь (Calendar)"
      
      ;     Case #_Type_Canvas
      ;       Result.S = "Это холст для рисования (Canvas)"
      
    Case #_Type_CheckBox
      Result.S = "Это переключатель (CheckBox)"
      
    Case #_Type_Container
      Result.S = "Это контейнер для других элементов (Container)"
      
    Case #_Type_ComboBox
      Result.S = "Это выподающий список (ComboBox)"
      
    Case #_Type_Editor
      Result.S = "1строка 2строка 3строка 4строка 5строка 6строка 7строка 8строка 9строка 10строка 11строка 12строка 13строка 14строка 15строка 16строка 17строка 18строка 19строка 20строка 21строка"
      
    Default
      Result.S = "Еще не реализованно еееееееееееееееееееееееееееееее"
      
  EndSelect
  
  ProcedureReturn Result.S
EndProcedure


;-
;- PROGRAMMS
Define i

;- ENUMERATIONS
#Title$ = "IDE"

Enumeration FormMenuItem 1
  #IDE_MenuItem_New
  #IDE_MenuItem_Save
  #IDE_MenuItem_Open
  #IDE_MenuItem_Form_Code
  
  #IDE_MenuItem_Undo
  #IDE_MenuItem_Redo
  
  #IDE_MenuItem_Cut
  #IDE_MenuItem_Copy
  #IDE_MenuItem_Paste
  #IDE_MenuItem_Delete
  
  #IDE_MenuItem_First
  #IDE_MenuItem_Prev
  #IDE_MenuItem_Next
  #IDE_MenuItem_Last
  
  #IDE_MenuItem_Preferences
  #IDE_MenuItem_Quit
EndEnumeration


;- GLOBALS
Global IDE_Scintilla_Gadget=-1
Global DragWidgetType=0, IDE_PopupMenu=-1, IDE_EditPopupMenu=-1

Global IDE=-1, IDE_Menu_0=-1, IDE_Toolbar_0=-1, IDE_cp=-1, IDE_pp=-1
Global IDE_Splitter_0=-1, IDE_Splitter_4=-1, IDE_List_0=-1, IDE_Scintilla_0=-1, IDE_Canvas_0

Global IDE_sProperty=-1, IDE_Property=-1, IDE_iProperty=-1
Global IDE_sWidgets=-1, IDE_Widgets=-1, IDE_iWidgets=-1
Global IDE_sEvents=-1, IDE_Events=-1, IDE_iEvents=-1

Global Property_Widget=-1, Property_ID=-1,
       Property_AlignText=-1, Property_AlignImage=-1, Property_AlignWidget=-1,
       Property_Caption=-1, Property_ToolTip=-1, Property_IsEnum=-1,
       Property_X=-1, Property_Y=-1, Property_Width=-1, Property_Height=-1,
       Property_Hide=-1, Property_Enable=-1, Property_Sticky=-1,
       Property_Flag=-1, Property_Image=-1, Property_ImageBg=-1,
       Property_Data=-1, Property_State=-1,
       Property_BackColor=-1, Property_FontColor=-1, Property_Font=-1

Global Events_Bind=-1, Events_LeftClick=-1, Events_RightClick=-1, Events_LeftDown=-1, Events_LeftUp=-1

Global img_point = Mosaic(Steps, 0,0,800,600)



;-
Procedure.S CreateType_PB(Type)
  Protected Result.S
  
  Select Type
    Case #_Type_Window : Result = "OpenWindow"
    Case #_Type_Button : Result = "ButtonGadget"
    Case #_Type_ButtonImage : Result = "ButtonImageGadget"
  EndSelect
  
  ProcedureReturn Result
EndProcedure

Macro NextChild(Widget);, *ID.Integer)
  *CreateWidget\This() : If (IsChildWidget(*CreateWidget\This()\Widget, Widget) = 0 Or *CreateWidget\This()\Widget = Widget) : Continue : EndIf
EndMacro

Procedure GeneratePBCode(*Panel.Widget_S)
  Protected Type
  Protected Count
  Protected Image
  Protected Parent.Widget_S
  Protected Widget.Widget_S
  Protected ParentClass$, Class$,Code$, FormWindow$, FormGadget$, Gadgets$, Windows$, Events$, Functions$
  Static JPEGPlugin$, JPEG2000Plugin$, PNGPlugin$, TGAPlugin$, TIFFPlugin$
  
  With *Panel
    ; is Widget
    If ListSize(\Childrens()) ;  IsWidgetChildrens(Panel, 0)
      Code$ + "EnableExplicit" +#CRLF$+#CRLF$
      
      While Enumerate(@Widget, *Panel, 0)
        Image = GetImage(Widget)
        
        ;UseIMAGEDecoder
        If IsImage(Image)
          Select ImageFormat(Image)
            Case #PB_ImagePlugin_JPEG
              If JPEGPlugin$ <> "UseJPEGImageDecoder()"
                JPEGPlugin$ = "UseJPEGImageDecoder()"
                Code$ +"UseJPEGImageDecoder()"+ #CRLF$
              EndIf
            Case #PB_ImagePlugin_JPEG2000
              If JPEG2000Plugin$ <> "UseJPEG2000ImageDecoder()"
                JPEG2000Plugin$ = "UseJPEG2000ImageDecoder()"
                Code$ +"UseJPEG2000ImageDecoder()"+ #CRLF$
              EndIf
            Case #PB_ImagePlugin_PNG
              If PNGPlugin$ <> "UsePNGImageDecoder()"
                PNGPlugin$ = "UsePNGImageDecoder()"
                Code$ +"UsePNGImageDecoder()"+ #CRLF$
              EndIf
            Case #PB_ImagePlugin_TGA
              If TGAPlugin$ <> "UseTGAImageDecoder()"
                TGAPlugin$ = "UseTGAImageDecoder()"
                Code$ +"UseTGAImageDecoder()"+ #CRLF$
              EndIf
            Case #PB_ImagePlugin_TIFF
              If TIFFPlugin$ <> "UseTIFFImageDecoder()"
                TIFFPlugin$ = "UseTIFFImageDecoder()"
                Code$ +"UseTIFFImageDecoder()"+ #CRLF$
              EndIf
            Case #PB_ImagePlugin_BMP
              
            Case #PB_ImagePlugin_ICON
              
          EndSelect
          
          ;Code$ +"LoadImage("+Image+", "+#DQUOTE$+\ImagePuch(Str(Image))+#DQUOTE$+")"+#CRLF$
        EndIf
        
      Wend
      
      Code$ + "Define Event" + #CRLF$+#CRLF$
      
      ; global var enumeration
      While Enumerate(@Parent, *Panel, 0)
        Class$ = GetClass(Parent)
        If Trim(Class$, "#") = Class$
          Code$ +"Global "+ Class$+"=-1"+#CRLF$
        Else
          FormWindow$ +Class$+ #CRLF$
        EndIf
      Wend
      
      If FormWindow$
        Code$ +"Enumeration FormWindow"+ #CRLF$
        Code$ +"  "+ FormWindow$
        Code$ +"EndEnumeration"+ #CRLF$
      EndIf
      
      Code$ +#CRLF$
      
      While Enumerate(@Parent, *Panel, 0)
        While Enumerate(@Widget, Parent)
          Class$ = GetClass(Widget)
          If Trim(Class$, "#") = Class$
            Code$ +"Global "+ GetClass(Widget)+"=-1"+#CRLF$
          Else
            FormGadget$ +Class$+ #CRLF$
          EndIf
        Wend
      Wend
      
      If FormGadget$
        Code$ +"Enumeration FormGadget"+ #CRLF$
        Code$ +"  "+ FormGadget$
        Code$ +"EndEnumeration"+ #CRLF$
      EndIf
      
      Code$ +#CRLF$
      
      While Enumerate(@Parent, *Panel, 0)
        While Enumerate(@Widget, Parent)
          Class$ = Trim(GetClass(Widget), "#")
          Events$ = GetEvents(Widget)
          If Events$
            Code$ + Code::Code_Event_Procedure(0, Class$+"_", "#PB_Event_Gadget", "") 
          EndIf
          ;           If Trim(Class$, "#") = Class$
          ;             Code$ +"Global "+ GetClass(Widget)+"=-1"+#CRLF$
          ;           Else
          ;             FormGadget$ +Class$+ #CRLF$
          ;           EndIf
        Wend
      Wend
      
      While Enumerate(@Widget, *Panel, 0)
        Events$ = GetEvents(Widget)
          If Events$
          Code$ + Code::Code_Event_Procedure(0, GetClass(Widget)+"_", Events$, "") 
        EndIf
      Wend
      
      
      PushListPosition()
      ForEach \Childrens()
        If \p = *Panel And \i = 0
          Widget = \Childrens()
          ParentClass$ = Trim(\Class$, "#")
          
          Code$ +"Procedure Open_"+ ParentClass$+"()"+#CRLF$
          PushListPosition()
          ForEach 
            If IsChildWidget(\Childrens(), Widget)
              Class$ = Trim(\Class$, "#")
              Code$ +"  "
              
              ; Type 
              If \Class$ = Class$
                Code$ + Class$ + " = "
                
                Select \Type 
                  Case #PB_GadgetType_Window
                    Code$ +"Open"+WidgetClass(\Type)+"(#PB_Any, "
                  Default
                    Code$ + WidgetClass(\Type)+"Gadget(#PB_Any, "
                EndSelect
              Else
                Select \Type 
                  Case #PB_GadgetType_Window
                    Code$ +"Open"+WidgetClass(\Type)+"("+\Class$+", "
                  Default
                    Code$ + WidgetClass(\Type)+"Gadget("+\Class$+", "
                EndSelect
              EndIf
              
              ; Coordinate
              Select \Type 
                Case #PB_GadgetType_Window
                  Code$ + Str(\X)+", "+
                          Str(\Y)+", "+
                          Str(\Width[2])+", "+
                          Str(\Height[2])
                  
                Default
                  Code$ + Str(\X[3])+", "+
                          Str(\y[3])+", "+
                          Str(\Width[1])+", "+
                          Str(\Height[1])
              EndSelect
              
              ; Caption
              Select \Type
                Case #PB_GadgetType_Window, #PB_GadgetType_Button, #PB_GadgetType_String, #PB_GadgetType_Text, #PB_GadgetType_CheckBox, #PB_GadgetType_Option, #PB_GadgetType_Frame, 
                     #PB_GadgetType_HyperLink, #PB_GadgetType_ListIcon, #PB_GadgetType_Web, #PB_GadgetType_Date, #PB_GadgetType_ExplorerList, #PB_GadgetType_ExplorerTree, #PB_GadgetType_ExplorerCombo
                  
                  Code$ +", "+Chr('"')+ GetText(\Childrens()) +Chr('"')
              EndSelect
              
              ; Param1
              Select \Type
                ;Case #PB_GadgetType_MDI : Code$ +", "+ \SubMenu
                Case #PB_GadgetType_Spin : Code$ +", "+ \Min
                Case #PB_GadgetType_Splitter : Code$ +", "+ \Splitter\First
                Case #PB_GadgetType_Image, #PB_GadgetType_ButtonImage 
                  If IsImage(\Image\index)
                    Code$ +", ImageID("+ \Image\index+")"
                  Else
                    Code$ +", 0"
                  EndIf
                Case #PB_GadgetType_ListIcon : Code$ +", "+ \FirstColumWidth
                Case #PB_GadgetType_HyperLink : Code$ +", "+ \Color\Back
                Case #PB_GadgetType_ProgressBar : Code$ +", "+ \Min
                Case #PB_GadgetType_ScrollBar : Code$ +", "+ \Min
                Case #PB_GadgetType_ScrollArea : Code$ +", "+ \Min 
                Case #PB_GadgetType_TrackBar : Code$ +", "+ \Min
                Case #PB_GadgetType_Date : Code$ +", "+ \Date
                Case #PB_GadgetType_Calendar : Code$ +", "+ \Date
                Case #PB_GadgetType_Scintilla : Code$ +", "+ \CallBack
                Case #PB_GadgetType_Shortcut : Code$ +", "+ \Shortcut
              EndSelect
              
              ; Param2
              Select \Type
                ;Case #PB_GadgetType_MDI : Code$ +", "+ \FirstMenuItem
                Case #PB_GadgetType_Spin : Code$ +", "+ \Max
                Case #PB_GadgetType_TrackBar : Code$ +", "+ \Max
                Case #PB_GadgetType_ScrollBar : Code$ +", "+ \Max
                Case #PB_GadgetType_ScrollArea : Code$ +", "+ \Max
                Case #PB_GadgetType_ProgressBar : Code$ +", "+ \Max
                Case #PB_GadgetType_Splitter : Code$ +", "+ \Splitter\Second
              EndSelect
              
              ; Param3
              Select \Type
                Case #PB_GadgetType_ScrollBar : Code$ +", "+ \Pade\Len
                Case #PB_GadgetType_ScrollArea : Code$ +", "+ \Step
              EndSelect
              
              ; Flags
              Select \Type
                Case #PB_GadgetType_Panel, #PB_GadgetType_Web, #PB_GadgetType_IPAddress, #PB_GadgetType_Option, #PB_GadgetType_Scintilla, #PB_GadgetType_Shortcut
                Default
                  If Trim(\Flags$, "|")
                    Code$ +", "+ Trim(\Flags$, "|")
                  EndIf
              EndSelect
              
              Code$ +")"+ #CRLF$
              
            EndIf
          Next
          PopListPosition()
          
          If \StickyWindow = Widget
            Code$ +"  StickyWindow("+ParentClass$+", #True)"+#CRLF$
          EndIf
          
          Code$ + #CRLF$
          
          PushListPosition()
          ForEach \Childrens()
            If IsChildWidget(\Childrens(), Widget)
              Class$ = Trim(\Class$, "#")
              
              If \hide[1] 
                Code$ +"  HideGadget("+Class$+", #True)"+#CRLF$
              EndIf
              If \disable[1]
                Code$ +"  DisableGadget("+Class$+", #True)"+#CRLF$
              EndIf
              If \ToolTip\String$
                Code$ +"  GadgetToolTip("+Class$+", "+#DQUOTE$+\ToolTip\String$+#DQUOTE$+")"+#CRLF$
              EndIf
              If \Color\FontState
                Code$ +"  SetGadgetAttribute("+Class$+", #PB_Gadget_FrontColor, $"+Hex(\Color\Font)+")"+#CRLF$
              EndIf
              If \Color\BackState
                Code$ +"  SetGadgetAttribute("+Class$+", #PB_Gadget_Color\Back, $"+Hex(\Color\Back)+")"+#CRLF$
              EndIf
              
;               Events$ = \Events$
;               Gadgets$ + WidgetClass(\Type)
;               
;               If Events$
;                 Code$ +Code::Code_BindGadgetEvent(3, Events$, 0);Gadgets$)
;               EndIf
            EndIf
          Next
          PopListPosition()
          
          Select \Type 
            Case #PB_GadgetType_Window
              If \Events$
                Code$ +Code::Code_BindEvent(3, "#PB_Event_"+\Events$, ParentClass$+"_")
              EndIf
            Default
          EndSelect
          Code$ +"EndProcedure"+#CRLF$+#CRLF$
          
        EndIf
      Next
      PopListPosition()
      
      PushListPosition()
      ForEach \Childrens()
        If \p = *Panel And \i = 0
          Widget = \Childrens()
          
          Code$ +"CompilerIf #PB_Compiler_IsMainFile"+#CRLF$
          Code$ +"  Open_"+ Trim(\Class$, "#")+"()"+#CRLF$+#CRLF$
          
          Code$ +"  While IsWindow("+ GetClass(Widget)+")"+#CRLF$
          Code$ +"    Event = WaitWindowEvent()"+#CRLF$+#CRLF$
          Code$ +"    Select Event"+#CRLF$
          Code$ +"       Case #PB_Event_CloseWindow"+#CRLF$
          Code$ +"         CloseWindow(EventWindow())"+#CRLF$
          Code$ +"    EndSelect"+#CRLF$+#CRLF$
          Code$ +"    Select EventWindow()"+#CRLF$
          
          PushListPosition()
          ForEach \Childrens()
            If \p = *Panel And \i = 0
              Widget = \Childrens()
              Code$ +"      Case "+\Class$+#CRLF$
              ; If Code$ : Code$+", " : EndIf : Code$ +\Class$+"=-1"
            EndIf
          Next
          PopListPosition()
          
          Code$ +"    EndSelect"+#CRLF$
          Code$ +"  Wend"+#CRLF$+#CRLF$
          Code$ +"  End"+#CRLF$
          Code$ +"CompilerEndIf"+#CRLF$
          
        EndIf
      Next
      PopListPosition()
      
      Code$ + #CRLF$ + #CRLF$
      
      ;       SetClipboardText(Code$)
      
      SetText(IDE_Scintilla_0, Code$)
    EndIf
    
  EndWith
  
  
EndProcedure



;-
Procedure CreateNewWidget(Widget) ; Then create new Widget
  Protected Item, State
  
  Item = AddGadgetWidgetItem(Property_Widget, #PB_Any, WidgetClass(WidgetType(Widget))+" ("+GetWidgetClass(Widget)+")") 
  SetItemData(Property_Widget, Item, Widget)
  SetData(Widget, Item)
  
  State = GetWidgetState(IDE_Widgets) : If State = 0 : State = 1 : EndIf
  AddGadgetWidgetItem(IDE_Canvas_0, #PB_Any, "", GetWidgetItemImage(IDE_Widgets, State))
EndProcedure

Procedure ResetNewWidget()
  SetState(IDE_Widgets, 0)
  SetText(IDE_iWidgets, Help(GetWidgetItemText(IDE_Widgets)))
  DragWidgetType = 0
  *CreateWidget\DragWidgetType = 0
  SetCustomCursor()
  
EndProcedure

Procedure DeleteNewWidget(Widget)
  Protected *Widget, Enumerate
  ;   
  
  With *CreateWidget
    If \MultiSelect
      PushListPosition(\This())
      ForEach \This()
        If \This()\EditingMode
          If ((\This()\Flag & #_Flag_Anchors)=#_Flag_Anchors)
            
            RemoveWidget(\This()\Widget)
            
          EndIf
        EndIf
      Next
      PopListPosition(\This())
      
    Else
      FreeWidget(Widget)
      ;RemoveWidget(Widget)
    EndIf
  EndWith
  
  ;   ClearWidgetItems(Property_Widget)
  ;   While Enumerate(@Enumerate, IDE_cp, 0)
  ;     AddGadgetWidgetItem(Property_Widget, #PB_Any, WidgetClass(WidgetType(Enumerate))+" ("+Str(Enumerate)+")")
  ;   Wend
EndProcedure

Procedure AddNewWidget(Type, Parent, Item, Reset.b)
  Protected Widget =- 1, X = #PB_Ignore, Y = #PB_Ignore, Width, Height
  
  If Type
    If Parent = EventWidget()
      If Not IsContainerWidget(Parent)
        Parent = GetWidgetParent(Parent)
      EndIf
      
      X = WidgetMouseX(Parent)-4
      Y = WidgetMouseY(Parent)-4
    EndIf
    
    CompilerIf #PB_Compiler_IsIncludeFile
      X = 10
      Y = 10
    CompilerEndIf
    
    SetAnchors(#PB_Default) ; Reset anchors
    If IsWidget(Parent) : OpenWidgetList(Parent, Item) : EndIf
    
    Select Type 
      Case #_Type_Container, #_Type_ScrollArea, #_Type_Panel, 
           #_Type_Splitter, #_Type_ListView, #_Type_ListIcon, #_Type_Image 
        Width = 220
        Height = 140
        
      Case #_Type_Window
        Width = 350
        Height = 250
        
      Default
        Width = 130
        Height = 25
        
    EndSelect
    
    With *CreateWidget\Selector
      \Color = $E23A2B
      
      If \right>5 And \bottom>5
        X = \left
        Y = \top
        Width = \right+Steps
        Height = \bottom+Steps
      EndIf
      
      \left = 0 : \top = 0 : \right = 0 : \bottom = 0
    EndWith 
    
    Widget = CreateWidget(Type, #PB_Any, X,Y,Width,Height, "", #PB_Default,#PB_Default,#PB_Default, #_Flag_AnchorsGadget)
    ;SetFont(Widget, FontID(LoadFont(#PB_Any, "Anonymous Pro Minus", 19*0.5, #PB_Font_HighQuality)))
        
    Select Type 
      Case #_Type_Container, #_Type_ScrollArea, #_Type_Panel, #_Type_Splitter
        img_point = Mosaic(Steps, 0,0,800,600)
        SetBackGroundImage(Widget, img_point)
        
      Case #_Type_Window
        img_point = Mosaic(Steps, 0,0,800,600)
        SetBackGroundImage(Widget, img_point)
        SetImage(Widget, GetIcon("Widgets", "_"))
        
        BindEventWidget(@NewWidgetEvents(), Widget, #PB_All)
      Default
        
    EndSelect
    
    SetFlags(Widget, GetPBFlags(GetWidgetFlag(Widget)))
    
    If IsContainerWidget(Widget) : CloseList() : EndIf
  EndIf 
  
  If IsWindowWidget(Widget)
    IDE_PopupMenu = CreatePopupMenuWidget()
    
    OpenSubMenuWidget("Z-Order")
      MenuWidgetItem(#IDE_MenuItem_First, "First")
      MenuWidgetItem(#IDE_MenuItem_Prev, "Prev")
      MenuWidgetItem(#IDE_MenuItem_Next, "Next")
      MenuWidgetItem(#IDE_MenuItem_Last, "Last")
    CloseSubMenuWidget()
    
    MenuWidgetBar()
    
    MenuWidgetItem(#IDE_MenuItem_Cut, "Cut", GetButtonIcon(#PB_ToolBarIcon_Cut) )
    MenuWidgetItem(#IDE_MenuItem_Copy, "Copy", GetButtonIcon(#PB_ToolBarIcon_Copy) )
    MenuWidgetItem(#IDE_MenuItem_Paste, "Paste", GetButtonIcon(#PB_ToolBarIcon_Paste) )
    MenuWidgetItem(#IDE_MenuItem_Delete, "Delete", GetButtonIcon(#PB_ToolBarIcon_Delete) )
    
    MenuWidgetBar()
    
    MenuWidgetItem(#IDE_MenuItem_Preferences, "Preferences")
    
  EndIf
  
  
  If Reset 
    ResetNewWidget() 
  EndIf
  ProcedureReturn Widget
EndProcedure


Procedure NewWidgetEvents(Event.q, EventWidget)
  Protected FontColor, BackColor
  Protected WidgetType, Item, X,Y,Width,Height, CheckedWidget = CheckedWidget()
  
  ; then create Widget
  Select Event
    Case #_Event_Create 
      CreateNewWidget(EventWidget)
      
    Case #_Event_Free
      RemoveWidgetItem(Property_Widget, GetWidgetData(EventWidget))
      
    Case #_Event_Close
      CloseWindowWidget(EventWidget)
      
    Case #_Event_MouseEnter ; Move
      If DragWidgetType
        SetCustomCursor(GetWidgetItemImage(IDE_Widgets))
      EndIf
      
  EndSelect
  
  ; Widgets popup menu
  Select Event
    Case #_Event_RightButtonUp ; : DisplayWidget = EventWidget
      DisplayPopupMenuWidget(IDE_PopupMenu, EventWidget)  ; now display the popup-menu
      
    Case #_Event_Menu
      Debug "EventMenuWidget "+EventMenuWidget()
      Select EventMenuWidget()
        Case 0 : SetPosition(CheckedWidget, #_Widget_PositionFirst)
        Case 1 : SetPosition(CheckedWidget, #_Widget_PositionPrev)
        Case 2 : SetPosition(CheckedWidget, #_Widget_PositionNext)
        Case 3 : SetPosition(CheckedWidget, #_Widget_PositionLast)
          
        Case 4 : CutWidget(CheckedWidget) ; Cut
        Case 5 : CopyWidget(CheckedWidget); Copy
        Case 6 : PasteWidget(CheckedWidget) ; Paste
        Case 7 : FreeWidget(CheckedWidget)  ; Delete
          
      EndSelect 
      
  EndSelect
  
  
  Select Event ; then focus or down Widget change Property
    Case #_Event_Create, #_Event_Focus, #_Event_LeftButtonDown
      FontColor = GetWidgetAttribute(EventWidget, #_Attribute_FontColor)
      BackColor = GetWidgetAttribute(EventWidget, #_Attribute_BackColor)
      
      If Trim(GetWidgetClass(EventWidget), "#") = GetWidgetClass(EventWidget)
        SetState(Property_IsEnum, 1)
      Else
        SetState(Property_IsEnum, 0)
      EndIf
      
         
      SetText(Property_Caption, GetWidgetText(EventWidget))
      SetState(Property_Widget, GetWidgetData(EventWidget))
      SetState(Property_Enable, Bool(Not IsDisableWidget(EventWidget)))
      SetText(Property_ID, GetWidgetClass(EventWidget)+" ("+Str(EventWidget)+")")
      
      SetText(Property_FontColor, "$"+Hex(FontColor))      
      SetText(Property_BackColor, "$"+Hex(BackColor))      
      
      If IsWindowWidget(EventWidget)
        DisableWidget(Property_Sticky, #False)
        DisableWidget(Property_ToolTip, #True)
      Else
        DisableWidget(Property_Sticky, #True)
        DisableWidget(Property_ToolTip, #False)
        SetText(Property_ToolTip, GetWidgetToolTip(EventWidget))
      EndIf    
      
      SetPropertyComboBoxText(Property_Flag, ReadPBFlags(WidgetType(EventWidget))); GetWidgetFlagClass(WidgetType(EventWidget)))
      
      Protected i,j, Buffer$
;       For j=0 To CountWidgetItems(Property_Flag)-1
;         Buffer$ +"|"+ GetWidgetItemText(Property_Flag, j)
;       Next
      Buffer$ = GetWidgetFlags(EventWidget)
      For i=1 To CountString(Buffer$,"|")+1
        For j=0 To CountWidgetItems(Property_Flag)-1
          If GetWidgetItemText(Property_Flag, j)=StringField(Buffer$, i, "|")
            SetItemState(Property_Flag, j, #PB_ListIcon_Checked)
          EndIf
        Next
      Next
  EndSelect
  
  Select Event ; then move Widget change Property
    Case #_Event_Create, #_Event_Focus, #_Event_Move, #_Event_LeftButtonDown
      SetState(Property_X, WidgetX(EventWidget))
      SetState(Property_Y, WidgetY(EventWidget))
  EndSelect
  
  Select Event ; then size Widget change Property
    Case #_Event_Create, #_Event_Focus, #_Event_Size, #_Event_LeftButtonDown
      SetState(Property_Width, WidgetWidth(EventWidget))
      SetState(Property_Height, WidgetHeight(EventWidget))
  EndSelect
  
  ; Create drag Widget
  If IsContainerWidget(CheckedWidget)
    Static StartX,StartY,LastX,LastY
    Protected Left, Top, Right, Bottom, Sb = 1 ; 
            
    With *CreateWidget
      Select Event 
        Case #_Event_LeftButtonUp
          If Not DragWidgetType
            PushListPosition(\This())
            ForEach \This()
              If (\This()\Parent\Widget = EventWidget)
                Left = (\This()\ContainerCoordinate\X+(\This()\bSize-\This()\BorderSize))
                Top = (\This()\ContainerCoordinate\Y+(\This()\bSize-\This()\BorderSize))
                Right = (\This()\ContainerCoordinate\X+\This()\FrameCoordinate\Width-\This()\BorderSize*2)
                Bottom = (\This()\ContainerCoordinate\Y+\This()\FrameCoordinate\Height-\This()\BorderSize*2)
                
                If (Right > \Selector\left+Sb) And (Bottom > \Selector\Top+Sb) And
                   Left < ((\Selector\left+\Selector\Right-Sb*2)) And Top < ((\Selector\Top+\Selector\Bottom-Sb*2))
                  
                  \MultiSelect = #True
                  \This()\Flag | #_Flag_Anchors
                  PushListPosition(\This())
                  ChangeCurrentWidget(\This(), WidgetID(\This()\Parent\Widget))
                  \This()\Flag &~ #_Flag_Anchors
                  PopListPosition(\This())
                  
                EndIf
              EndIf
            Next
            PopListPosition(\This())
            
            \Selector\left = 0 
            \Selector\top = 0 
            \Selector\right = 0 
            \Selector\bottom = 0
          EndIf
          
        Case #_Event_LeftButtonDown
          StartX = Steps(\MouseX,Steps)+2
          StartY = Steps(\MouseY,Steps)+2
          
        Case #_Event_MouseMove 
          If \Buttons And \SideDirection = 0
            PushListPosition(\This())
            ChangeCurrentWidget(\This(), WidgetID(EventWidget))
            
            SetCursorWidget(#PB_Cursor_Cross)
            LastX = Steps(\MouseX-StartX,Steps)+1
            LastY = Steps(\MouseY-StartY,Steps)+1
            
            If StartX > (StartX+LastX)
              \Selector\left = (StartX+LastX)-(\This()\InnerCoordinate\X-\This()\BorderSize)
            Else
              \Selector\left = StartX-(\This()\InnerCoordinate\X-\This()\BorderSize) 
            EndIf
            
            If StartY > (StartY+LastY)
              \Selector\top = (StartY+LastY)-(\This()\InnerCoordinate\Y-\This()\BorderSize)
            Else
              \Selector\top = StartY-(\This()\InnerCoordinate\Y-\This()\BorderSize)
            EndIf
            
            \Selector\right = Abs(LastX)
            \Selector\bottom = Abs(LastY)
            
            If BeginDrawing()
              UpdateDrawingContent()
              
              If DragWidgetType
                DrawingMode(#PB_2DDrawing_Outlined)
                Box(StartX,StartY,LastX,LastY, \Selector\Color)
              Else
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter)
                CustomFilterCallback(@DrawFilterCallback()) : Box(StartX,StartY,LastX,LastY, \Selector\Color)
              EndIf
              
              EndDrawing()
            EndIf
            
            PopListPosition(\This())
          EndIf
      EndSelect
    EndWith
  EndIf
  
  Select Event ; Create drag Widget
    Case #_Event_KeyUp
      ResetNewWidget()
      
    Case #_Event_LeftButtonUp
      If DragWidgetType
        AddNewWidget(DragWidgetType, EventWidget, 0, Bool((WidgetEventModifiersKey() & #PB_Canvas_Shift) = 0))
      EndIf
      
    Case #_Event_LeftDoubleClick : Debug "LeftDoubleClick"
      WidgetType = WidgetType(EventWidget)
      
      Select WidgetType 
        Case #_Type_Window
          ;SetText(IDE_Scintilla_0, Code::Code_Event_Procedure(0, WidgetClass(WidgetType)+"_"+Str(EventWidget)+"_", "Create", ""))
        Case #_Type_Button
          Item = AddGadgetWidgetItem(Events_LeftClick, #PB_Any, GetWidgetClass(CheckedWidget)+"_LeftClick_Event")
          SetState(EventWidget, Item)
          
        Default
          ;SetText(IDE_Scintilla_0, Code::Code_Event_Procedure(0, WidgetClass(WidgetType)+"_"+Str(EventWidget)+"_", EventClass(Event), ""))
      EndSelect
      
      SetState(IDE_pp, 1) ; IDE_Events
      SetState(IDE_cp, 1) ; IDE_Code
      
  EndSelect
  
  ProcedureReturn #True
EndProcedure

Procedure.S Parse( ReadString.S ) ;Ok
  Protected I
  Protected Count.I
  Protected String.S
  
  Protected Name.S
  Protected Type.S
  Protected X.S
  Protected Y.S
  Protected Width.S
  Protected Height.S
  Protected Caption.S
  Protected Param1.S
  Protected Param2.S
  Protected Param3.S
  Protected Flag.S
  Protected CountString.I
  ReadString.S = Trim( ReadString.S )
  
  ;
  Type.S = StringField( ReadString.S, (1), Chr('('))
  Type.S = StringField( Type.S, (2), Chr('='))
  
  ;Handle.S = Trim(StringField(Type.S, 1, Chr('='))) ; 
  ;Type.S = Trim(StringField(Type.S, 2, Chr('=')))
  String.S = Trim(StringField( ReadString.S, (2), Chr('(')), Chr(')'))
  
   
  ; Если только одна закрывающая скобка
  X.S = StringField( String.S, 2, ",")
  Y.S = StringField( String.S, 3, ",")
  
  Width.S = StringField( String.S, 4, ",")
  If Width.S = StringField( Width.S, 1, "(")
  Else
    Width.S + ")"
  EndIf
  
  Height.S = StringField( String.S, 5, ",")
  If Height.S = StringField( Height.S, 1, "(")
  Else
    Height.S + ")"
  EndIf
  
  Caption.S = StringField( String.S, 6, ",")
  Flag.S = StringField( String.S, 7, ",")
  
  If CountString(Caption.S, Chr('"')) = 0
    Flag.S = Caption.S
    Caption.S = ""
  EndIf
  
  Static Parent =- 1
  Protected Widget
  
  If Parent =- 1 
    Parent = IDE_cp 
    X.S = "#PB_Ignore"
    Y.S = "#PB_Ignore"
  EndIf
  
  Widget = AddNewWidget(Type(Type), Parent, 0, 0)
  
  If IsContainerWidget(Widget)
    Protected CaptionHeight = GetWidgetAttribute(Widget, #_Attribute_CaptionHeight)
    If CaptionHeight
      Protected b = 2
      Protected x1 = 30
      Protected y1 = 30
    EndIf
    
    Parent = Widget
  EndIf
  
  If Val(Width) >0
    ResizeWidget(Widget, Val(X)-3+x1,Val(Y)-3+y1,Val(Width)+7+b,Val(Height)+7+CaptionHeight+b)
  EndIf
  
  SetText(Widget, Trim(Trim(Caption.S),Chr('"')))
  
  ProcedureReturn Chr(10)+ Type.S + Chr(10)+
                           ; ID.S + Chr(10)+ 
  X.S + Chr(10)+Y.S +Chr(10)+Width.S +Chr(10)+Height.S +Chr(10)+Caption.S +Chr(10)+Param1.S +Chr(10)+Param2.S +Chr(10)+Param3.S +Chr(10)+Flag.S +Chr(10) 
  
EndProcedure


Procedure$ LoadFromFile(File$)
  Protected Count, Text.S, Find.S
  
  If ReadFile(0, File$)
    While Eof(0) = 0 : Count + 1
      Text.S = ReadString(0)
      
      Find.S = IsFindFunctions(Text.S)
      
      Parse(Find.S)
      ;Debug Str(Count) +" "+ 
    Wend
    
    CloseFile(0)
  Else
    MessageRequester("Information","Couldn't open the file!")
  EndIf
EndProcedure 

Procedure GeneratePBForm(Panel)
  ProcedureReturn 
  Protected i, ReadText.S, Find.S, Text.S = GetWidgetText(IDE_Scintilla_0)
  ;   Text.S = "111"+#LF$+ 
  ;            "222"+#LF$+
  ;            "333"+#LF$+
  ;            "444"+#LF$+
  ;            "555"
  
  Protected f=0,ff
  For i=0 To CountString(Text, #LF$)-1
    ;ff+f
    f=FindString(Text, #LF$, f+Len(#LF$))
    ReadText.S = Mid(Text,ff+Len(#LF$),f)
    ff=Len(Left(Text,f))
;     Debug  i
;     Debug ReadText
    ;     Find.S = IsFindFunctions(ReadText.S)
    ;     Parse(Find.S)
  Next
  
EndProcedure
; GeneratePBForm(0)



Procedure IDE_Scintilla_0_Events(Event.q, EventWidget)
  Static Hide = 1
  
  Select Event
    Case #_Event_Size
      Select EventWidget
        Case IDE_Scintilla_0
          If Not Hide
            ResizeGadget(IDE_Scintilla_Gadget, 
                         WidgetX(EventWidget, #_Widget_ScreenCoordinate),
                         WidgetY(EventWidget, #_Widget_ScreenCoordinate),
                         WidgetWidth(EventWidget), WidgetHeight(EventWidget))
          EndIf
      EndSelect
      
    Case #_Event_Change
      Select EventWidget
        Case IDE_cp
          Select GetWidgetState(IDE_cp)
            Case 0,2 : HideGadget(IDE_Scintilla_Gadget, 1) : Hide=1
            Case 1 : HideGadget(IDE_Scintilla_Gadget, 0) : Hide=0
          EndSelect
          
      EndSelect
  EndSelect
  
  ProcedureReturn #True
EndProcedure

;-
Procedure IDE_Property_Events(Event.q, EventWidget)
  Protected Widget, FontColor, BackColor, Item
  Protected CheckedWidget = CheckedWidget()
  
  ; Then resize panels resize splitters
  Select Event 
    Case #_Event_Change, #_Event_Size
      Select EventWidget
        Case IDE_pp
          Widget = GetWidgetItemData(EventWidget, GetWidgetState(EventWidget))
          If Widget
            Resize(Widget, #PB_Ignore, #PB_Ignore, WidgetWidth(EventWidget), WidgetHeight(EventWidget))
          EndIf
      EndSelect
  EndSelect
  
  ; Events
  Select Event
    Case #_Event_LeftDoubleClick ; "При двойном клике на событие будем переходить к коду"
      If IsWidget(CheckedWidget)
        Select EventWidget 
          Case Events_LeftClick,
               Events_RightClick,
               Events_LeftDown,
               Events_LeftUp
            
            Select EventWidget 
              Case Events_LeftClick
                Item = AddGadgetWidgetItem(EventWidget, 0, GetWidgetClass(CheckedWidget)+"_LeftClick_Event")
                SetState(EventWidget, Item)
                
                SetEvents(CheckedWidget, "LeftClick")
                
              Case Events_RightClick
                Item = AddGadgetWidgetItem(EventWidget, 0, GetWidgetClass(CheckedWidget)+"_RightClick_Event")
                SetState(EventWidget, Item)
                
                SetEvents(CheckedWidget, "RightClick")
              
            EndSelect
            
            SetState(IDE_cp, 1)
            Debug "GetWidgetClass "+GetWidgetEvents(CheckedWidget) ; GetWidgetClass(CheckedWidget)
        EndSelect
      EndIf
      
    Case #_Event_LeftClick
      Select EventWidget 
        Case IDE_Widgets 
          DragWidgetType = Type(GetWidgetItemText(IDE_Widgets)) 
          *CreateWidget\DragWidgetType = DragWidgetType
          SetCustomCursor(GetWidgetItemImage(IDE_Widgets))
          
        Case Property_Image
          CFE_Helper_Image(IDE_cp,0,0,0,#_Flag_WindowCentered)
          
        Case Property_ImageBg
          CFE_Helper_Image(IDE_cp,0,0,0,#_Flag_ScreenCentered)
          
        Case Property_FontColor
          FontColor = ColorRequester(GetWidgetAttribute(CheckedWidget, #_Attribute_FontColor))
          SetAttribute(CheckedWidget, #_Attribute_FontColor, BackColor)
          SetText(EventWidget, "$"+Hex(FontColor))      
          
        Case Property_BackColor
          BackColor = ColorRequester(GetWidgetAttribute(CheckedWidget, #_Attribute_BackColor))
          SetAttribute(CheckedWidget, #_Attribute_BackColor, BackColor)
          SetText(EventWidget, "$"+Hex(BackColor))      
          
        Case Property_Font
          FontRequester("Arial", 8, #PB_FontRequester_Effects )
          SetText(EventWidget, "("+SelectedFontSize()+") "+SelectedFontName())      
          SetFont(CheckedWidget, FontID(LoadFont(#PB_Any, SelectedFontName(), SelectedFontSize(), SelectedFontStyle())))
          
      EndSelect
      
    Case #_Event_Change
      Select EventWidget 
        Case IDE_pp
          Select GetWidgetState(IDE_pp)
            Case 0 : SetActive(IDE_Property)
            Case 1 : SetActive(IDE_Events)
            Case 2 : SetActive(IDE_Widgets)
          EndSelect
          
        Case Property_Flag
          Protected j, Buffer$, Flags$
          SetFlags(CheckedWidget, "")
          
          For j=0 To CountWidgetItems(EventWidget)-1
            Buffer$ = GetWidgetItemText(EventWidget,j)
            RemoveWidgetFlag(CheckedWidget, Flag(Buffer$))
            If GetWidgetItemState(EventWidget, j)
              SetFlags(CheckedWidget, Buffer$)
            EndIf
          Next
          
          SetFlag(CheckedWidget, Flag(GetWidgetFlags(CheckedWidget)))
          
        Case Property_IsEnum 
          If GetWidgetState(EventWidget)
            SetClass(CheckedWidget, Trim(GetWidgetClass(CheckedWidget), "#"))
          Else
            SetClass(CheckedWidget, "#"+GetWidgetClass(CheckedWidget))
          EndIf
          
          SetActive(CheckedWidget)
          SetForegroundWindow(CheckedWidget)
          
        Case Property_Hide : Hide(CheckedWidget, Bool(GetWidgetState(EventWidget)=0))
        Case Property_Enable : Disable(CheckedWidget, Bool(GetWidgetState(EventWidget)=0))
        Case Property_Sticky : StickyWindowWidget(CheckedWidget, Bool(GetWidgetState(EventWidget)=0))
        Case Property_ToolTip : SetToolTip(CheckedWidget, GetWidgetText(EventWidget))
        Case Property_Caption : SetText(CheckedWidget, GetWidgetText(EventWidget))
          
        Case Property_Widget 
          CheckedWidget = CheckedWidget(GetWidgetItemData(EventWidget, GetWidgetState(EventWidget)))
          SetAnchors(CheckedWidget)
          SetActive(CheckedWidget)
          SetForegroundWindow(CheckedWidget)
          
        Case Property_X,Property_Y,Property_Width,Property_Height
          SetState(EventWidget, Val(GetWidgetText(EventWidget)))
         
          Resize(CheckedWidget, 
                        GetWidgetState(Property_X),
                        GetWidgetState(Property_Y),
                        GetWidgetState(Property_Width), 
                        GetWidgetState(Property_Height))
;           Resize(CheckedWidget, 
;                         GetWidgetState(Property_X)-3,
;                         GetWidgetState(Property_Y)-3,
;                         GetWidgetState(Property_Width)+6+GetWidgetAttribute(CheckedWidget, #_Attribute_BorderSize)*2, 
;                         GetWidgetState(Property_Height)+6+GetWidgetAttribute(CheckedWidget, #_Attribute_BorderSize)*2+GetWidgetAttribute(CheckedWidget, #_Attribute_CaptionHeight))
          
      EndSelect
      
    Case #_Event_MouseMove
      
      
      Select EventWidget 
        Case IDE_pp
          Static iState, EnterItem =- 1 : iState = GetWidgetState(EventWidget)
          
          If EnterItem<>EventWidgetItem() : EnterItem=EventWidgetItem()
            If EventWidgetItem() =- 1
              SetState(EventWidget, iState)
            Else
              SetState(EventWidget, EventWidgetItem())
            EndIf
          EndIf
          
        Case IDE_Widgets
          SetText(IDE_iWidgets, Help(GetWidgetItemText(IDE_Widgets)))
          
      EndSelect
      
    Case #_Event_MouseLeave
      Select EventWidget 
        Case IDE_Widgets
          SetText(IDE_iWidgets, Help(GetWidgetItemText(IDE_Widgets, GetWidgetState(IDE_Widgets))))
          
      EndSelect
      
    Default
      ;Debug "IDE_Property_Events() "+EventWidget+" "+EventClass(Event)+" "+Str(GetWidgetParent(EventWidget))
      
  EndSelect
  
  ProcedureReturn #True
EndProcedure

Procedure IDE_Menu_Events(Event.q, EventWidget)
  Static RunProgram, CopyWidget
  Protected WidgetCreate, CheckType
  Protected CheckedWidget = CheckedWidget()
  Protected Type = WidgetType(CheckedWidget)
  
  Select Event
    Case #_Event_Menu
      Select EventWidgetItem() 
        Case 1001
          If GetWidgetText(IDE_Scintilla_0)
            SetClipboardText(GetWidgetText(IDE_Scintilla_0))
            SetText(IDE_Scintilla_0,"")
          EndIf
          
        Case 1002
          SetClipboardText(GetWidgetText(IDE_Scintilla_0))
          
        Case 1003
          SetText(IDE_Scintilla_0, GetClipboardText())
          
        Case 1004
          SetText(IDE_Scintilla_0,"")
          
          
        Case #IDE_MenuItem_Form_Code
        Case #IDE_MenuItem_Save
        Case #IDE_MenuItem_Open
          Protected StandardFile$ = "C:\Users\mestnyi\Google Диск\SyncFolder()\Module()\"   ; set initial file+path to display
                                                                                            ; With next string we will set the search patterns ("|" as separator) for file displaying:
                                                                                            ;  1st: "Text (*.txt)" as name, ".txt" and ".bat" as allowed extension
                                                                                            ;  2nd: "PureBasic (*.pb)" as name, ".pb" as allowed extension
                                                                                            ;  3rd: "All files (*.*) as name, "*.*" as allowed extension, valid for all files
          Protected Pattern$ = "PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*"
          Protected Pattern = 0    ; use the first of the three possible patterns as standard
          Protected File$ = OpenFileRequester("Please choose file to load", StandardFile$, Pattern$, Pattern)
          LoadFromFile(File$)
          
        Case #IDE_MenuItem_New    
          AddNewWidget(#_Type_Window, IDE_cp, 0, #True)
          
        Case #IDE_MenuItem_Delete : DeleteNewWidget(CheckedWidget)
        Case #IDE_MenuItem_First  : SetPosition(CheckedWidget, #_Widget_PositionFirst)
        Case #IDE_MenuItem_Prev   : SetPosition(CheckedWidget, #_Widget_PositionPrev)
        Case #IDE_MenuItem_Next   : SetPosition(CheckedWidget, #_Widget_PositionNext)
        Case #IDE_MenuItem_Last   : SetPosition(CheckedWidget, #_Widget_PositionLast)
          
        Case #IDE_MenuItem_Copy
          With *CreateWidget
            If IsWidget(EventWidget)
              PushListPosition(\This())
              ChangeCurrentWidget(\This(), WidgetID(EventWidget))
              ChangeCurrentWidget(\This(), WidgetID(\This()\Linked\Parent))
              
              If \MultiSelect
                PushListPosition(\This())
                ForEach \This()
                  If \This()\EditingMode
                    If ((\This()\Flag & #_Flag_Anchors)=#_Flag_Anchors)
                      Copyies(Str(\This()\Widget))\Class$ = \This()\Class$
                      Copyies(Str(\This()\Widget))\Type$ = Str(\This()\Type)
                      Copyies(Str(\This()\Widget))\Window$ = Str(\This()\Window)
                      Copyies(Str(\This()\Widget))\Parent$ = Str(\This()\Parent\Widget)
                      Copyies(Str(\This()\Widget))\X$ = Str(\This()\ContainerCoordinate\X) 
                      Copyies(Str(\This()\Widget))\Y$ = Str(\This()\ContainerCoordinate\Y) 
                      Copyies(Str(\This()\Widget))\Width$ = Str(\This()\FrameCoordinate\Width) 
                      Copyies(Str(\This()\Widget))\Height$ = Str(\This()\FrameCoordinate\Height)
                      Copyies(Str(\This()\Widget))\Caption$ = \This()\Text\String$
                      
                      Copyies(Str(\This()\Widget))\Param1$ = Str(\This()\Param1)
                      Copyies(Str(\This()\Widget))\Param2$ = Str(\This()\Param2)
                      Copyies(Str(\This()\Widget))\Param3$ = Str(\This()\Param3)
                      
                      Copyies(Str(\This()\Widget))\Flag$ = Str(\This()\Flag)
                      
                      Protected Parent = \This()\Widget
                      If \This()\Childrens
                        PushListPosition(\This())
                        ForEach \This()
                          If \This()\EditingMode And IsChildWidget(\This()\Widget, Parent)
                            
                            Copyies(Str(\This()\Widget))\Class$ = \This()\Class$
                            Copyies(Str(\This()\Widget))\Type$ = Str(\This()\Type)
                            Copyies(Str(\This()\Widget))\Window$ = Str(\This()\Window)
                            Copyies(Str(\This()\Widget))\Parent$ = Str(\This()\Parent\Widget)
                            Copyies(Str(\This()\Widget))\X$ = Str(\This()\ContainerCoordinate\X) 
                            Copyies(Str(\This()\Widget))\Y$ = Str(\This()\ContainerCoordinate\Y) 
                            Copyies(Str(\This()\Widget))\Width$ = Str(\This()\FrameCoordinate\Width) 
                            Copyies(Str(\This()\Widget))\Height$ = Str(\This()\FrameCoordinate\Height)
                            Copyies(Str(\This()\Widget))\Caption$ = \This()\Text\String$
                            
                            Copyies(Str(\This()\Widget))\Param1$ = Str(\This()\Param1)
                            Copyies(Str(\This()\Widget))\Param2$ = Str(\This()\Param2)
                            Copyies(Str(\This()\Widget))\Param3$ = Str(\This()\Param3)
                            
                            Copyies(Str(\This()\Widget))\Flag$ = Str(\This()\Flag)
                            
                          EndIf
                        Next
                        PopListPosition(\This())
                        
                      EndIf
                    EndIf
                  EndIf
                Next
                PopListPosition(\This())
              Else
                Copyies(Str(\This()\Widget))\Class$ = \This()\Class$
                Copyies(Str(\This()\Widget))\Type$ = Str(\This()\Type)
                Copyies(Str(\This()\Widget))\Window$ = Str(\This()\Window)
                Copyies(Str(\This()\Widget))\Parent$ = Str(\This()\Parent\Widget)
                Copyies(Str(\This()\Widget))\X$ = Str(\This()\ContainerCoordinate\X) 
                Copyies(Str(\This()\Widget))\Y$ = Str(\This()\ContainerCoordinate\Y) 
                Copyies(Str(\This()\Widget))\Width$ = Str(\This()\FrameCoordinate\Width) 
                Copyies(Str(\This()\Widget))\Height$ = Str(\This()\FrameCoordinate\Height)
                Copyies(Str(\This()\Widget))\Caption$ = \This()\Text\String$
                
                Copyies(Str(\This()\Widget))\Param1$ = Str(\This()\Param1)
                Copyies(Str(\This()\Widget))\Param2$ = Str(\This()\Param2)
                Copyies(Str(\This()\Widget))\Param3$ = Str(\This()\Param3)
                
                Copyies(Str(\This()\Widget))\Flag$ = Str(\This()\Flag)
              EndIf
              PopListPosition(\This())
            EndIf
          EndWith
          
        Case #IDE_MenuItem_Paste
          With *CreateWidget
            If MapSize(Copyies())
              SetAnchors(EventWidget)
              OpenWidgetList(EventWidget)
              ForEach Copyies()
                CreateWidget(Val(Copyies()\Type$), #PB_Any,
                              Val(Copyies()\X$), 
                              Val(Copyies()\Y$)+Val(Copyies()\Height$), 
                              Val(Copyies()\Width$), 
                              Val(Copyies()\Height$),
                              Copyies()\Caption$, -1,-1,-1,Val(Copyies()\Flag$)|#_Flag_Anchors)
                
              Next
              ;CloseList()
            EndIf
          
          EndWith
  
              
        Case #IDE_MenuItem_Quit   : End
          
      EndSelect
  EndSelect
  
  ProcedureReturn #True
EndProcedure

Procedure IDE_Events(Event.q, EventWidget)
  Static RunProgram
  Protected Widget, WidgetCreate, CheckType
  Protected CheckedWidget = CheckedWidget()
  Protected Type = WidgetType(CheckedWidget)
  
  IDE_Menu_Events(Event, EventWidget)
  
  ; Then resize panels resize splitters
  Select Event 
    Case #_Event_Change, #_Event_Size
      Select EventWidget
        Case IDE
          Resize(IDE_Splitter_4, #PB_Ignore, #PB_Ignore, WidgetWidth(EventWidget), WidgetHeight(EventWidget))
        
        Case IDE_cp
          Widget = GetWidgetItemData(EventWidget, GetWidgetState(EventWidget))
          If Widget
            Resize(Widget, #PB_Ignore, #PB_Ignore, WidgetWidth(EventWidget), WidgetHeight(EventWidget))
          EndIf
      EndSelect
  EndSelect
  
  Select Event
    Case #_Event_RightClick
      Select EventWidget
        Case IDE_Scintilla_0
          DisplayPopupMenuWidget(IDE_EditPopupMenu, EventWidget) 
      EndSelect
      
      ; IDE_Panel
    Case #_Event_Change 
      Select EventWidget
        Case IDE_cp
          If EventWidgetItem() = 0
            Disable(IDE_ToolBar_0, 0)
          Else
            Disable(IDE_ToolBar_0, 1)
          EndIf
          
          Select GetWidgetItemText(EventWidget) 
            Case "Form" : GeneratePBForm(EventWidget)
            Case "Code" : GeneratePBCode(EventWidget)
            Case "V_Code"
              ;AddGadgetWidgetItem(IDE_Canvas_0,-1,"Button",png, #_Flag_Border|#_Flag_Image_Left|#_Flag_Text_Center)
              
          EndSelect
          
;           Select GetWidgetState(EventWidget) ; EventWidgetItem()
;             Case 0 : GeneratePBForm(EventWidget)
;             Case 1 : GeneratePBCode(EventWidget)
; ;             Case 2 
; ;               AddGadgetWidgetItem(IDE_Canvas_0,-1,"Button",png, #_Flag_Border|#_Flag_Image_Left|#_Flag_Text_Center)
;           EndSelect
      EndSelect
      
      ;       ; IDE_Panel
      ;     Case #_Event_LeftButtonUp
      ;       If DragWidgetType 
      ;         Select EventWidget
      ;           Case IDE_cp
      ;             Select GetWidgetItemText(EventWidget());EventWidgetItem() 
      ;               Case "Form"
      ;                 WidgetCreate = AddNewWidget(DragWidgetType, IDE_cp, 0, Bool((WidgetEventModifiersKey() & #PB_Canvas_Shift) = 0))
      ;             EndSelect
      ;             
      ;           Case IDE_Canvas_0
      ;             ;WidgetCreate = AddNewWidget(DragWidgetType, CheckedWidget, 0)
      ;             ;DragWidgetType = 0
      ;             
      ;         EndSelect
      ;       EndIf
      
    Default
      
      ; Debug "IDE_Events() "+EventWidget+" "+EventClass(Event)+" "+Str(GetWidgetParent(EventWidget))
      
  EndSelect
  
  
  ProcedureReturn #True
EndProcedure


;-
CompilerIf #PB_Compiler_IsMainFile
  Define  Time = ElapsedMilliseconds()
  
  Procedure IDE_Menu_Create()
    
    IDE_Menu_0 = CreateMenuWidget(#PB_Any,IDE)
    
    If IDE_Menu_0
      MenuWidgetTitle("File")
      MenuWidgetItem(#IDE_MenuItem_Open,"Open"   +Chr(9)+"  Ctrl+O", GetButtonIcon(#PB_ToolBarIcon_Open))
      MenuWidgetItem(#IDE_MenuItem_Save,"Save"   +Chr(9)+"  Ctrl+S", GetButtonIcon(#PB_ToolBarIcon_Save))
      MenuWidgetBar()
      MenuWidgetItem(#IDE_MenuItem_Quit,"Quit")
      
      MenuWidgetTitle("Edit")
      MenuWidgetTitle("Project")
      MenuWidgetTitle("Form")
      MenuWidgetItem(#IDE_MenuItem_New,"New", GetButtonIcon(#PB_ToolBarIcon_New))
    EndIf
    
    IDE_Toolbar_0 = CreateToolbarWidget(#PB_Any, IDE);, #_Flag_Small)
    
    If IDE_Toolbar_0
      ToolBarWidgetButton( #IDE_MenuItem_New, GetIcon("add_form"), 0, #PB_ToolBarIcon_Add,"New", "Создать новую форму")
      ToolBarWidgetButton( #IDE_MenuItem_Delete, -1, 0, #PB_ToolBarIcon_Delete,"Delete", "Удалить выбраную форму")
      ToolBarWidgetSeparator()
      ToolBarWidgetButton( #IDE_MenuItem_First, GetIcon("move_first"), 0, -1,"First", "Переместить на задний план")
      ToolBarWidgetButton( #IDE_MenuItem_Next, GetIcon("move_next"), 0, -1,"Next", "Переместить на один вперед")
      ToolBarWidgetButton( #IDE_MenuItem_Prev, GetIcon("move_prev"), 0, -1,"Prev", "Переместить на один назад")
      ToolBarWidgetButton( #IDE_MenuItem_Last, GetIcon("move_last"), 0, -1,"Last", "Переместить на передний план")
      ToolBarWidgetSeparator()
    EndIf
    
    IDE_EditPopupMenu = CreatePopupMenuWidget()
    
    If IDE_EditPopupMenu
      MenuWidgetItem(1001, "Cut", GetButtonIcon(#PB_ToolBarIcon_Cut) )
      MenuWidgetItem(1002, "Copy", GetButtonIcon(#PB_ToolBarIcon_Copy) )
      MenuWidgetItem(1003, "Paste", GetButtonIcon(#PB_ToolBarIcon_Paste) )
      MenuWidgetItem(1004, "Delete", GetButtonIcon(#PB_ToolBarIcon_Delete) )
    EndIf
    
  EndProcedure
  
  Procedure IDE_Create(Width,Height)
    IDE = OpenWindow(#PB_Any, 30,30, Width,Height, "Designer", #_Flag_MinimizeGadget|#_Flag_MaximizeGadget|#_Flag_ScreenCentered);|#_Flag_Invisible)
    
    IDE_Menu_Create()
    
    ;{ - (form & code)
    IDE_cp = Panel(#PB_Any,0,0,0,0, #_Flag_Transparent)                                                               ;
    Define ei=AddItem(IDE_cp, #PB_Any, "Form", GetIcon("Widgets", "_"))
    ;   Define e311 = ScrollArea(#PB_Any,0,0,0,0,200,100,1, #_Flag_AlignFull)
    ;Define f=Button(#PB_Any, 30,30, 100,50, "Window_0", #_Flag_AnchorsGadget) 
    ;OpenWindow(#PB_Any, 30,30, 200,100, "Window_0",0,IDE_cp) : CloseList()
    
    ;   CloseList()
    ;   SetItemData(IDE_cp, ei, e311)
    SetItemData(IDE_cp, ei, #PB_Default)
    
    Define ei=AddItem(IDE_cp, #PB_Any, "Code", GetIcon("page_white_code")) 
    IDE_Scintilla_0 = Editor(#PB_Any,0,0,0,0,"Text")   
    SetItemData(IDE_cp, ei, IDE_Scintilla_0)
    
    ;   If InitScintilla()
    ;     IDE_Scintilla_Gadget = ScintillaGadget(#PB_Any,0,0,0,0,0)
    ;     
    ;     BindGadgetWidgetEvent(IDE_cp, @IDE_Scintilla_0_Events(), #_Event_Change)
    ;     BindGadgetWidgetEvent(IDE_Scintilla_0, @IDE_Scintilla_0_Events(), #_Event_Size)
    ;   EndIf
    
    Define ei=AddGadgetWidgetItem(IDE_cp, -1, "V_Code")
    IDE_Canvas_0 = CreateWidget(#_Type_Canvas, #PB_Any,0,0,0,0,"Canvas",-1,-1,-1,#_Flag_BorderLess)   
    SetBackGroundImage(IDE_Canvas_0, img_point)
    SetItemData(IDE_cp, ei, IDE_Canvas_0)
    
    CloseList()
    
    IDE_List_0 = Editor(#PB_Any, 0,0,0,0, "List_0")
    IDE_Splitter_0 = Splitter(#PB_Any, 0,0,0,0, IDE_cp,IDE_List_0, #_Flag_Separator_Circle|#_Flag_SecondFixed)
    ;}
    
    ;{ - (Widgets & Property)
    IDE_pp = Panel(#PB_Any,0,0,0,0, #_Flag_BorderLess|#_Flag_Transparent) 
    ;
    Define ei=AddItem(IDE_pp, #PB_Any, "Property", GetButtonIcon(#PB_ToolBarIcon_Print))
    IDE_Property = Property(#PB_Any,0,0,0,0)            
    Property_IsEnum = AddItem(IDE_Property, #PB_Any, "ComboBox Enumeration True|False")
    Property_Widget = AddItem(IDE_Property, #PB_Any, "ComboBox Widgets")
    Property_ID = AddItem(IDE_Property, #PB_Any, "String ID") : Disable(Property_ID, #True)
    Property_Caption = AddItem(IDE_Property, #PB_Any, "String Caption")
    
    Property_ToolTip = AddItem(IDE_Property, #PB_Any, "String ToolTip")
    
    ;   Property_AlignText = AddItem(IDE_Property, #PB_Any, "ComboBox AlignText None|Center|Right")
    ;   Property_AlignImage = AddItem(IDE_Property, #PB_Any, "ComboBox AlignImage ")
    Property_AlignWidget = AddItem(IDE_Property, #PB_Any, "ComboBox AlignWidget ")
    
    Property_Image = AddItem(IDE_Property, #PB_Any, "Button Image Puch_to_image")
    Property_ImageBg = AddItem(IDE_Property, #PB_Any, "Button BgImage Puch_to_background_Image")
    
    Property_X = AddItem(IDE_Property, #PB_Any, "Spin X 0|100")
    Property_Y = AddItem(IDE_Property, #PB_Any, "Spin Y 0|200")
    Property_Width = AddItem(IDE_Property, #PB_Any, "Spin Width 0|100")
    Property_Height = AddItem(IDE_Property, #PB_Any, "Spin Height 0|200")
    
    Property_Data = AddItem(IDE_Property, #PB_Any, "String Data ")
    Property_Font = AddItem(IDE_Property, #PB_Any, "Button Font ")
    Property_FontColor = AddItem(IDE_Property, #PB_Any, "Button FontColor ")
    Property_BackColor = AddItem(IDE_Property, #PB_Any, "Button BackColor ")
    Property_State = AddItem(IDE_Property, #PB_Any, "ComboBox State Normal|Maximized|Minimized")
    Property_Sticky = AddItem(IDE_Property, #PB_Any, "ComboBox Sticky True|False")
    Property_Hide = AddItem(IDE_Property, #PB_Any, "ComboBox Hide True|False")
    Property_Enable = AddItem(IDE_Property, #PB_Any, "ComboBox Disable True|False")
    Property_Flag = AddItem(IDE_Property, #PB_Any, "ComboBox Flag", -1, #PB_ListIcon_CheckBoxes)
    
    IDE_iProperty = Text(#PB_Any,0,0,0,0,"Text") 
    
    IDE_sProperty = Splitter(#PB_Any, 0,0,0,0, IDE_Property,IDE_iProperty, #_Flag_Separator_Circle|#_Flag_SecondFixed);|#_Flag_AlignFull)
    SetItemData(IDE_pp, ei, IDE_sProperty)
    
    ;
    Define ei=AddItem(IDE_pp, #PB_Any, "Events", GetIcon("lightning"));GetButtonIcon(#PB_ToolBarIcon_Property))
    IDE_Events = Property(#PB_Any,0,0,0,0)            
    Events_Bind = AddItem(IDE_Events, #PB_Any, "ComboBox BindEvent True|False")
    Events_LeftClick = AddItem(IDE_Events, #PB_Any, "ComboBox LeftClick", #PB_Default, #PB_ComboBox_Editable)
    Events_RightClick = AddItem(IDE_Events, #PB_Any, "ComboBox RightClick", #PB_Default, #PB_ComboBox_Editable)
    Events_LeftDown = AddItem(IDE_Events, #PB_Any, "ComboBox LeftDown", #PB_Default, #PB_ComboBox_Editable)
    Events_LeftUp = AddItem(IDE_Events, #PB_Any, "ComboBox LeftUp", #PB_Default, #PB_ComboBox_Editable)
    
    IDE_iEvents = Button(#PB_Any, 0,0,0,0, "72ButtonWidget")
    IDE_sEvents = Splitter(#PB_Any, 0,0,0,0, IDE_Events,IDE_iEvents, #_Flag_Separator_Circle|#_Flag_SecondFixed);|#_Flag_AlignFull)
    
    SetItemData(IDE_pp, ei, IDE_sEvents)
    
    ;
    Define ei=AddItem(IDE_pp, #PB_Any, "Widgets", GetIcon("Widgets"));;LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
    IDE_Widgets = ListView(#PB_Any,0,0,0,0) 
    LoadGadgetImage(IDE_Widgets, GetCurrentDirectory()+"Themes/")
    SetState(IDE_Widgets,0)
    ; WidgetToolTip(IDE_Widgets)
    
    IDE_iWidgets = Text(#PB_Any,0,0,0,0,"Text", #_Flag_Flat)   
    
    IDE_sWidgets = Splitter(#PB_Any, 0,0,0,0, IDE_Widgets,IDE_iWidgets, #_Flag_Separator_Circle|#_Flag_SecondFixed);|#_Flag_AlignFull)
    SetItemData(IDE_pp, ei, IDE_sWidgets)
    
    CloseList()
    
    ; ;   With *CreateWidget
    ; ;     PushListPosition(\This()) 
    ; ;     ChangeCurrentWidget(\This(), WidgetID( IDE_cp ))
    ; ;     ChangeCurrentWidget(\This()\Items(), ItemID( ListSize(\This()\Items())-1 ))
    ; ;     Define IDE_vWidgets = ButtonImageWidget(#PB_Any, \This()\Items()\FrameCoordinate\X+\This()\Items()\FrameCoordinate\Width+5,3,20,20, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
    ; ;     PopListPosition(\This())
    ; ;   EndWith
    
    IDE_Splitter_4 = Splitter(#PB_Any, 0,0,Width,Height, IDE_Splitter_0,IDE_pp, #_Flag_Vertical|#_Flag_Separator_Circle|#_Flag_SecondFixed)
    
    SetAttribute(IDE_sWidgets, #PB_Splitter_FirstMinimumSize, 200)
    SetAttribute(IDE_sWidgets, #PB_Splitter_SecondMinimumSize, 20)
    
    SetAttribute(IDE_sProperty, #PB_Splitter_FirstMinimumSize, 200)
    SetAttribute(IDE_sProperty, #PB_Splitter_SecondMinimumSize, 20)
    
    SetAttribute(IDE_sEvents, #PB_Splitter_FirstMinimumSize, 200)
    SetAttribute(IDE_sEvents, #PB_Splitter_SecondMinimumSize, 20)
    
    SetState(IDE_Splitter_0,WidgetHeight(IDE_Splitter_4)-60)
    SetState(IDE_sWidgets,WidgetHeight(GetWidgetParent(IDE_sWidgets))-60)
    SetState(IDE_sProperty,WidgetHeight(GetWidgetParent(IDE_sProperty))-60)
    SetState(IDE_sEvents,WidgetHeight(GetWidgetParent(IDE_sEvents))-60)
    SetState(IDE_Splitter_4,WidgetWidth(IDE_Splitter_4)-300)
    ;}
    
    If CreateStatusBar(#PB_Any, IDE)
      AddStatusBarWidgetField(190)
      AddStatusBarWidgetField(#PB_Ignore) ; automatically resize this field
      
      StatusBarWidgetText(StatusBar(), 0, "Area normal")
      StatusBarWidgetText(StatusBar(), 1, "StatusBar")
    EndIf
    
    
    AddNewWidget(#_Type_Window, IDE_cp, 0, #True)
    
    ;     Define File$ = "CFE_Read_Test(variab).pb"
    ;     If File$
    ;       Define Load$ = LoadFromFile(File$)
    ; ;       ClearGadgetItems(Editor_0)
    ; ;       AddGadgetItem(Editor_0,-1,Load$)
    ;     EndIf 
    
    BindEventWidget(@IDE_Property_Events(), IDE, #PB_All) 
    BindEventWidget(@IDE_Events(), IDE, #PB_All)
    
    
    ;HideWidget(IDE, #False)
  EndProcedure
  
  IDE_Create(900,600)
  
  Time = (ElapsedMilliseconds() - Time)
  If Time 
    Debug "Time "+Str(Time)
  EndIf
  WaitWindowEventClose(IDE)
  End
  
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --------------------------------
; EnableXP