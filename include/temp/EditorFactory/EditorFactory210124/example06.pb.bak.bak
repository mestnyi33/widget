; Example_ScrollArea_Gadget.pb

; Includes the program file
XIncludeFile "EditorFactory.pbi"

; Initializes the Module
UseModule EditorFactory

UsePNGImageDecoder()

EnableExplicit

; --------- Example ---------

; Program constants
Enumeration 1
  #Window
  #Canvas
EndEnumeration

; Object constants starting from 1
Enumeration 1
  #Object1
  #Object2
  #Object3
  #Object4
EndEnumeration

; Gadget constants starting from 100
Enumeration 100
  #FakeScrollArea
  #Gadget1
  #Gadget2
  #Gadget3
  #Gadget4
EndEnumeration

#MinSize = 6

Global ImageEdit.i = CatchImage(#PB_Any, ?edit_png)
Global ImageCancel.i = CatchImage(#PB_Any, ?cancel_png)

Macro _FreeCaptureGadget_(Gadget)   ; Free Image to Capture Image without Resizing
  If IsImage(GetGadgetData(Gadget))   
    FreeImage(GetGadgetData(Gadget)) : SetGadgetData(Gadget, #Null)
  EndIf
EndMacro

Procedure.i ScrollAreaBarWidth(Gadget.i)
  Protected Result.i
  If (GetWindowLong_(GadgetID(Gadget), #GWL_STYLE) & #WS_VSCROLL)
    ProcedureReturn GetSystemMetrics_(#SM_CXVSCROLL)                     ; 17
  EndIf
EndProcedure

Procedure.i ScrollAreaBorderWidth(Gadget.i)
  Protected Result.i
  If (GetWindowLong_(GadgetID(Gadget), #GWL_EXSTYLE) & $200)         ;no Flag or #PB_ScrollArea_Center
    ProcedureReturn GetSystemMetrics_(#SM_CXEDGE)                    ; 2
  ElseIf (GetWindowLong_(GadgetID(Gadget), #GWL_STYLE) & $800000)    ;#PB_ScrollArea_Flat
    ProcedureReturn GetSystemMetrics_(#SM_CXBORDER)                  ;1
  ElseIf (GetWindowLong_(GadgetID(Gadget), #GWL_STYLE) & $400000)    ;#PB_ScrollArea_Raised
    ProcedureReturn GetSystemMetrics_(#SM_CXFIXEDFRAME)              ;3
  ElseIf (GetWindowLong_(GadgetID(Gadget), #GWL_EXSTYLE) & $20000)   ;#PB_ScrollArea_Single
    ProcedureReturn GetSystemMetrics_(#SM_CXBORDER)                  ;1
  EndIf
EndProcedure

Procedure.i ScrollAreaVisibleWidth(Gadget.i)
  ; https://www.purebasic.fr/english/viewtopic.php?p=503690#p503690
  Protected Result.i = GadgetWidth(Gadget)
  CompilerIf (#PB_Compiler_OS = #PB_OS_Windows)
    CompilerIf (#False) ; srod's simple version
      Protected r.RECT
      GetClientRect_(GadgetID(Gadget), @r)
      Result = r\right - r\left
    CompilerElse
      Result - 2 * ScrollAreaBorderWidth(Gadget)
      Result - ScrollAreaBarWidth(Gadget)
    CompilerEndIf
  CompilerElse
    Result - 2 * 2
  CompilerEndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.i ScrollAreaBarHeight(Gadget.i)
  Protected Result.i
  If (GetWindowLong_(GadgetID(Gadget), #GWL_STYLE) & #WS_HSCROLL)
    ProcedureReturn GetSystemMetrics_(#SM_CYHSCROLL)                     ; 17
  EndIf
EndProcedure

Procedure.i ScrollAreaBorderHeight(Gadget.i)
  Protected Result.i
  If (GetWindowLong_(GadgetID(Gadget), #GWL_EXSTYLE) & $200)             ;no Flag or #PB_ScrollArea_Center
    ProcedureReturn GetSystemMetrics_(#SM_CYEDGE)                        ; 2
  ElseIf (GetWindowLong_(GadgetID(Gadget), #GWL_STYLE) & $800000)        ;#PB_ScrollArea_Flat
    ProcedureReturn GetSystemMetrics_(#SM_CYBORDER)                      ;1
  ElseIf (GetWindowLong_(GadgetID(Gadget), #GWL_STYLE) & $400000)        ;#PB_ScrollArea_Raised
    ProcedureReturn GetSystemMetrics_(#SM_CYFIXEDFRAME)                  ;3
  ElseIf (GetWindowLong_(GadgetID(Gadget), #GWL_EXSTYLE) & $20000)       ;#PB_ScrollArea_Single
    ProcedureReturn GetSystemMetrics_(#SM_CYBORDER)                      ;1
  EndIf
EndProcedure

Procedure.i ScrollAreaVisibleHeight(Gadget.i)
  ; https://www.purebasic.fr/english/viewtopic.php?p=503690#p503690
  Protected Result.i = GadgetHeight(Gadget)
  CompilerIf (#PB_Compiler_OS = #PB_OS_Windows)
    CompilerIf (#True) ; srod's simple version
      Protected r.RECT
      GetClientRect_(GadgetID(Gadget), @r)
      Result = r\bottom - r\top
    CompilerElse
      Result - 2 * ScrollAreaBorderHeight(Gadget)
      Result - ScrollAreaBarHeight(Gadget)
    CompilerEndIf
  CompilerElse
    Result - 2 * 2
  CompilerEndIf
  ProcedureReturn (Result)
EndProcedure

;- ----------------
;{ ----------------------------------------------
; CaptureGadget: The message WM_PRINT is sent to a Gadget to request it to be drawn in a picture
; Need some Specific for: SpinGadget (Part1), ComboBoxGadget, EditorGadget, ExplorerComboGadget, SpinGadget (Part2) - (See IceDesign CaptureGadget procedure)
;}
Procedure CaptureGadget(Gadget.i)
  Protected Image.i, hDC.i
  If GadgetWidth(Gadget) > 0 And GadgetHeight(Gadget) > 0
    Image = CreateImage(#PB_Any,GadgetWidth(Gadget),GadgetHeight(Gadget))
    If IsGadget(Gadget)
      hDC =  StartDrawing(ImageOutput(Image))
      If hDC
        DrawingMode(#PB_2DDrawing_Default)
        Box(0, 0, OutputWidth(), OutputHeight(), $FFFFFF)   ; Gadget_BackColor
        SendMessage_(GadgetID(Gadget),#WM_PRINT,hDC, #PRF_CHILDREN|#PRF_CLIENT|#PRF_NONCLIENT|#PRF_OWNED|#PRF_ERASEBKGND)
        StopDrawing()
      EndIf
    EndIf
  EndIf
  ProcedureReturn Image
EndProcedure

;{ ----------------------------------------------
; Callback procedure to draw on the object
;   Object.i is the number of the object, you can use it to get properties of the currently drawn object
;   Width.i is the current width of the object
;   Height.i is the current height of the object
;   iData.i is a custom data value set in SetObjectDrawingCallback, here it is used as the color
; This procedure will automatically called during the draw of the Object
;}
Procedure ObjectDrawing(Object.i, Width.i, Height.i, iData.i)   ; Draw Captured Image + Border
  Protected Image.i, Resize.b, OffSetX.i, OffSetY.i, DeFlickerFakeScrollArea.b
  ;Debug "ObjectDrawing(" + Str(Object) + ", " + Str(Width) + ", " + Str(Height) + ", " + Str(iData) + ")"
  AddPathBox(0.5, 0.5, Width-1, Height-1)
  If IsGadget(iData)
    If GadgetType(iData) = #PB_GadgetType_ScrollArea
      If IsWindowVisible_(GadgetID(#FakeScrollArea))
        DeFlickerFakeScrollArea = #True
        SendMessage_(WindowID(#Window), #WM_SETREDRAW, #False, 0)
      EndIf
      If GadgetX(iData) <> GetObjectX(Object) Or GadgetY(iData) <> GetObjectY(Object) Or GadgetWidth(iData) <> Width Or GadgetHeight(iData) <> Height
        ResizeGadget(#FakeScrollArea, GetObjectX(Object), GetObjectY(Object), Width, Height)
      EndIf
    EndIf
    If GadgetWidth(iData) <> Width Or GadgetHeight(iData) <> Height
      ResizeGadget(iData, #PB_Ignore, #PB_Ignore, Width, Height)
      Resize = #True
    EndIf
    If IsImage(GetGadgetData(iData))
      If Resize
        FreeImage(GetGadgetData(iData))
        Image = CaptureGadget(iData)
        SetGadgetData(iData, Image)
      Else
        Image = GetGadgetData(iData)
      EndIf
    Else
      Image = CaptureGadget(iData)
      SetGadgetData(iData, Image)
    EndIf
    ;DrawVectorImage(ImageID(Image))
    VectorSourceImage(ImageID(Image), 230, Width, Height) : FillPath(#PB_Path_Preserve)
  Else
    VectorSourceColor($804080C0)
    FillPath(#PB_Path_Preserve)
  EndIf
  If ObjectState(Object) = #State_Selected
    VectorSourceColor($A80000FF)
  Else
    VectorSourceColor($80FF0000)
  EndIf
  StrokePath(1)
  If  DeFlickerFakeScrollArea = #True
    SendMessage_(WindowID(#Window), #WM_SETREDRAW, #True, 0)
    ;RedrawWindow_(WindowID(#Window), #Null, #Null, #RDW_INVALIDATE)
  EndIf
EndProcedure

Procedure BindScrollArea()
  Protected Gadget.i, Object.i
  Object = GetGadgetData(EventGadget())
  Gadget = GetObjectData(Object)
  SetGadgetAttribute(Gadget, #PB_ScrollArea_X, GetGadgetAttribute(#FakeScrollArea, #PB_ScrollArea_X)) : SetGadgetAttribute(Gadget, #PB_ScrollArea_Y, GetGadgetAttribute(#FakeScrollArea, #PB_ScrollArea_Y))
  _FreeCaptureGadget_(Gadget)
  SetObjectFrameOffset(Object, -GetGadgetAttribute(Gadget, #PB_ScrollArea_X)+ScrollAreaBorderWidth(Gadget), -GetGadgetAttribute(Gadget, #PB_ScrollArea_Y)+ScrollAreaBorderHeight(Gadget))
EndProcedure

;{ ----------------------------------------------
; Create and Set Object
; Gadget is the GadgetID
; Object is the number of the object
; ParentObject is the number of the Parent Object
; FrameIndex An index of the frame (starting with 1) in which the object should attached (optional)
;
; Set Properties: ObjectData (Gadget), ObjectBoundaries (#Boundary_ParentSize, MinWidth 6, MinHeight 6), ObjectDrawingCallback (iData=Gadget),
; AddObjectHandle (#Handle_Size|#Handle_Position), SetObjectCursor (#PB_Cursor_Hand), ObjectHandleDisplayMode (#Handle_ShowIfSelected)
;}
Procedure CreateSetObject(Gadget.i, Object.i, ParentObject.i=#PB_Default, FrameIndex.i=#PB_Default)
  Protected Parent.i
  CreateObject(#Canvas, Object, GadgetX(Gadget), GadgetY(Gadget), GadgetWidth(Gadget), GadgetHeight(Gadget), ParentObject, FrameIndex)
  SetObjectData(Object, Gadget)
  If GadgetType(Gadget) = #PB_GadgetType_ScrollArea
    AddObjectHandle(Object, #Handle_Custom1, ImageEdit, #Alignment_Bottom | #Alignment_Right, -16, 4)
    SetObjectFrameOffset(Object, ScrollAreaBorderWidth(Gadget), ScrollAreaBorderHeight(Gadget))
    SetObjectFrameClipping(Object, #True, 0, 0, ScrollAreaBarWidth(Gadget) + ScrollAreaBorderWidth(Gadget), ScrollAreaBarHeight(Gadget) + ScrollAreaBorderHeight(Gadget))   ; 2*ScrollAreaBorder - ScrollAreaBorder
  EndIf
  If ParentObject <> #PB_Default And IsGadget(GetObjectData(ParentObject))
    Parent = GetObjectData(ParentObject)
    If GadgetType(Parent) = #PB_GadgetType_ScrollArea
      SetObjectBoundaries(Object, 0, 0, GetGadgetAttribute(Parent, #PB_ScrollArea_InnerWidth)-ScrollAreaBorderWidth(Gadget), GetGadgetAttribute(Parent, #PB_ScrollArea_InnerHeight)-ScrollAreaBorderHeight(Gadget), #MinSize, #MinSize)   ; Set the Boundaries MaxX MaxY to the parent contained scrollable area
    EndIf
  EndIf
  ;AddObjectHandle(Object, #Handle_Size | #Handle_Position)
  ;ObjectHandleDisplayMode(Object, #Handle_ShowIfSelected)
  SetObjectDrawingCallback(Object, @ObjectDrawing(), Gadget)
  SetObjectCursor(Object, #PB_Cursor_Hand)
EndProcedure

;- ----- Main -----
Define Gadget.i

; Create a window
OpenWindow(#Window, 0, 0, 680, 500, "Example Captured ScrollArea Gadget Objects", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)

; The Fake ScrollArea must be created before the canvas. It is used when editing the ScrollArea with Operational ScrollBar
ScrollAreaGadget(#FakeScrollArea, 0, 0, 0, 0, 0, 0)
CloseGadgetList()
HideGadget(#FakeScrollArea, #True)
BindGadgetEvent(#FakeScrollArea, @BindScrollArea())

; Create a canvas gadget
CanvasGadget(#Canvas, 0, 0, WindowWidth(#Window), WindowHeight(#Window), #PB_Canvas_Keyboard)

; Initializes the object management for the canvas gadget
If Not InitializeCanvasObjects(#Canvas, #Window)
  Debug "Unable to initialize the object manager !"
EndIf

SetCursorSelectionStyle(#Canvas, #SelectionStyle_Solid|#SelectionStyle_Partially, RGBA(0, 128, 255, 255), 1, RGBA(0, 128, 255, 25))
SetObjectSelectionStyle(#Object_Default, #SelectionStyle_Dashed, $A80000FF, 1, #SelectionStyle_Ignore)
SetObjectBoundaries(#Object_Default, 0, 0, #Boundary_ParentSize, #Boundary_ParentSize, #MinSize, #MinSize)   ; Set the boundaries to the parent size by default
AddObjectHandle(#Object_Default, #Handle_Size | #Handle_Position)
ObjectHandleDisplayMode(#Object_Default, #Handle_ShowIfSelected)
;SetObjectDrawingCallback(#Object_Default, @ObjectDrawing(), Gadget)
;SetObjectCursor(#Object_Default, #PB_Cursor_Hand)

ScrollAreaGadget(#Gadget1, 120, 100, 440, 300, 620, 450, 10)
CloseGadgetList()
HideGadget(#Gadget1, #True)
CreateSetObject(#Gadget1, #Object1)

ButtonGadget(#Gadget2, 40, 40, 200, 60, "Button_1") : HideGadget(#Gadget2, #True)
CreateSetObject(#Gadget2, #Object2, #Object1, 1)

ButtonGadget(#Gadget3, 360, 160, 200, 60, "Button_2") : HideGadget(#Gadget3, #True)
CreateSetObject(#Gadget3, #Object3, #Object1, 1)

; The window's event loop
Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow                   ; Exit the program.
      Break
     
    Case #PB_Event_Gadget                        ;-> Event Gadget
  EndSelect
 
  ; Event loop of the objects in the canvas gadget
  Repeat
    Select CanvasObjectsEvent(#Canvas)           ; Something happened in the canvas.
      Case #Event_Handle                         ;-> Event Handle
        Select CanvasObjectsEventType(#Canvas)   ; What type of Events happened on the Handle ?
          Case #EventType_LeftMouseClick
            Select EventHandle(#Canvas)
              Case #Handle_Custom1
                If IsWindowVisible_(GadgetID(#FakeScrollArea))   ; Or With SetGadgetData(#FakeScrollArea, 0|1) -> If GetGadgetData(#FakeScrollArea)
                  AddObjectHandle(EventObject(#Canvas), #Handle_Custom1, ImageEdit, #Alignment_Bottom | #Alignment_Right, -16, 4)
                  HideGadget(#FakeScrollArea, #True)
                Else
                  Gadget = GetObjectData(EventObject(#Canvas))
                  ResizeGadget(#FakeScrollArea, GadgetX(Gadget), GadgetY(Gadget), GadgetWidth(Gadget), GadgetHeight(Gadget))
                  SetGadgetAttribute(#FakeScrollArea, #PB_ScrollArea_InnerWidth, GetGadgetAttribute(Gadget, #PB_ScrollArea_InnerWidth))
                  SetGadgetAttribute(#FakeScrollArea, #PB_ScrollArea_InnerHeight, GetGadgetAttribute(Gadget, #PB_ScrollArea_InnerHeight))
                  SetGadgetAttribute(#FakeScrollArea, #PB_ScrollArea_ScrollStep, GetGadgetAttribute(Gadget, #PB_ScrollArea_ScrollStep))
                  AddObjectHandle(EventObject(#Canvas), #Handle_Custom1, ImageCancel, #Alignment_Bottom | #Alignment_Right, -16, 4)
                  HideGadget(#FakeScrollArea, #False)
                EndIf
            EndSelect
        EndSelect
       
      Case #Event_Object                         ;-> Event Object
        Select CanvasObjectsEventType(#Canvas)   ; What type of events happened on the object?
          Case #EventType_Selected
            ;Debug "Object " + EventObject(#Canvas) + " has been Selected. Put Object on Top."
            SetObjectLayer(EventObject(#Canvas), -1, #PB_Absolute)   ; Push to the last layer (-1), on Top
            If GadgetType(GetObjectData(EventObject(#Canvas))) = #PB_GadgetType_ScrollArea
              SetGadgetData(#FakeScrollArea, EventObject(#Canvas))
            EndIf
           
          Case #EventType_Unselected
            If GadgetType(GetObjectData(EventObject(#Canvas))) = #PB_GadgetType_ScrollArea
              AddObjectHandle(EventObject(#Canvas), #Handle_Custom1, ImageEdit, #Alignment_Bottom | #Alignment_Right, -16, 4)
              HideGadget(#FakeScrollArea, #True)
            EndIf
           
          Case #EventType_Moved,  #EventType_Resized
            Gadget = GetObjectData(EventObject(#Canvas))
            Debug "Gadget " + Gadget + " (" +
                  GetObjectX(EventObject(#Canvas), #Object_LocalPosition) + ", " + GetObjectY(EventObject(#Canvas), #Object_LocalPosition)  + ", " +
                  GetObjectWidth(EventObject(#Canvas)) + ", " + GetObjectHeight(EventObject(#Canvas)) + ") Moved or Resized"
            ResizeGadget(Gadget, GetObjectX(EventObject(#Canvas), #Object_LocalPosition), GetObjectY(EventObject(#Canvas), #Object_LocalPosition), GetObjectWidth(EventObject(#Canvas)), GetObjectHeight(EventObject(#Canvas)))
           
        EndSelect                                ; CanvasObjectsEventType(#Canvas)
       
      Case #Event_None                           ; No Events.
        Break
    EndSelect                                    ; CanvasObjectsEvent(#Canvas)
  ForEver
 
ForEver

End

; Data section for the icon licensed under a Creative Commons Attribution 3.0 License. https://github.com/gammasoft/fatcow
DataSection
  edit_png:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1000000010000000,$FFF31F0000000608,$5845741900000061
  Data.q $72617774666F5374,$2065626F64410065,$6165526567616D49,$00003C65C9717964,$DA78544144495202
  Data.q $FE145114485D539C,$A8B70DB75D1DCCEE,$2221F1FA53458B74,$ED8B20882087DAB0,$A22B220894A7CA47
  Data.q $487CB10C11628A87,$2822494C082A7C62,$A4AD07C36B685C89,$D5B6C20A8B5F0B45,$99FDB775A5D9B6C5
  Data.q $C88C0B66759DEE99,$B9CE77CE7381FDC3,$549506AEB8873DDF,$9223FF1D34E67556,$E38394E3112F6040
  Data.q $EA795E7118B17B1D,$470C217D93E666A4,$1ABDDEF7100FF200,$61A6A58E03DC7DB8,$E87995B4D5D04238
  Data.q $E0DF0E1484282D7C,$254C103A7FA3A584,$5F2EE0897F348553,$6A02446A858A9D02,$037C1B686D6B7AFA
  Data.q $82D436FDFD4B1491,$AF8471F2C7819500,$8F7982ACA25A473D,$400B024B21CB5DAE,$33408D391D9E550C
  Data.q $F7AF818D996184A0,$C51C26604F9B20C8,$FB633E601617C8A7,$380A8CA43E86048B,$204EE638A5C6D0E8
  Data.q $295288244E859D1C,$B87399ECE18E5F46,$4A1C0B6C4F0BD033,$8B39FBF1FD64D414,$7EC49A3DB5B2C244
  Data.q $F66542F3EC3437FB,$B90C94F971AB17B7,$FA0C10DBF53C3EEF,$B187E450841D5721,$E862C2B3E465BECF
  Data.q $09CF189681027D60,$7CA2D787ED87585D,$07F2182BD69A3CF2,$18AE4CD283DDDDD0,$EB378D41C2A2E4C0
  Data.q $03697E303A8D0482,$4A02CEBE02A91C76,$2DE03C6803FCAF02,$FF13F78018B55440,$6219DD8D06D39746
  Data.q $202E8D3C3340B2C7,$95D7CDC19F7C0D3C,$656D365C88FFED68,$0F7C157EB9A0FAB5,$EAA61942F3B60DC7
  Data.q $C45F58C76CA3815A,$8BD2DD50B90ADC64,$3629AF71A8678127,$C6350D9D2E0A1F12,$E7A45625475EE536
  Data.q $E2562777039367B0,$F8548A0705BBFF74,$69AD3B1C94FC8C1E,$37D3ED1DA967E564,$B27700EA5A2CB540
  Data.q $106335100FFCB613,$51C972CB839A5BCC,$F12716160F96BE9E,$05D20DBF000C025F,$00000000F62B0208
  Data.q $826042AE444E4549
  cancel_png:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1000000010000000,$FFF31F0000000608,$4752730100000061
  Data.q $0000E91CCEAE0042,$0000414D41670400,$00000561FC0B8FB1,$0000735948700900,$C701C30E0000C30E
  Data.q $490F02000064A86F,$5F937D4F38544144,$36F73FC71C515348,$11A82D0F42682A2B,$7A2D920F91AD7161
  Data.q $B8F66B88587A8228,$97A0A87A40920E5A,$05293CFED27A2C12,$75356C087A4A30CD,$2411512F65723482
  Data.q $CAB9CB12DA843D45,$A63DDB9EEDD8FEC6,$3E7F7F73970BEB6E,$B9FA28E7B9CE7BDF,$FD78AF2392863A13
  Data.q $55161136BECF1A79,$D729D9D7DB0CF064,$D24206733058CCAA,$629FE656B7B3CF64,$F94CABD1600B2ABB
  Data.q $13D042C90A4CBADC,$161450D2337032B2,$517E7D35BB1E55B3,$B834706F42243648,$A2F7CF2B9662C28A
  Data.q $2CD129051091170A,$F58CCBAEA07052A0,$CA56E100D8AA0A25,$FCD3CBBFAC1C3164,$50D9974806976334
  Data.q $44D45A27BAB0B6B1,$7DCCC09C68EEC248,$98F9DB944C156D94,$4FCD0F6628186EFE,$0B99C244D8B8E652
  Data.q $927E3C1075B4B4ED,$5F7249A3926EFBD0,$E633779E9E2D5027,$A258BBC44D2DA728,$3A37257F59C03FBD
  Data.q $C7DF3441DAAEA9BB,$722852C0CC66A756,$86318362859AC16C,$B7C6A0AE9F897AF6,$927378714F2FD591
  Data.q $2CB1AF5B5A5EE107,$F11C90EA506BFB93,$4EF5DD89BFACA43D,$DBE1E2290A349F18,$2CECFA7D9A0F6B78
  Data.q $FB9347E129E3B16A,$BEA60258C075E9D9,$C81F5BC696BC3ED0,$27858B0D47E6D365,$6B49F1EF6B47C251
  Data.q $AE860BF6F83A9A84,$9E89DFD381DCF1D2,$5C16F5CF0E19E149,$CD621CB4EE0F7926,$72BAE8AB5C071716
  Data.q $3048F60B4B230D9D,$6428A89BCD8481A6,$3BF6C65C4E682B6D,$3CB22F3FF5835F8B,$F11302A681BE83FF
  Data.q $AFFE8CDD8F193717,$49CF07F04F38D617,$0000FD8D1F2B242A,$42AE444E45490000
EndDataSection
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --------
; EnableXP