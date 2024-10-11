;///////////////////////////////////////////////////
; Project:      Curve Designer
; Author:       Lloyd Gallant (netmaestro)
; Contributors: Idle (Linux cursor creation)
;               wombats (MacOS cursor creation)
; Date:         May 14,2020
; Target OS:    Windows
; Compiler:     PureBasic 5.72 x86
; License:      Unrestricted, do as you like
; What it is:   WSIWYG Vector curve designer
;               (RAD tool for quick drawing)
; Version:      1.0
;////////////////////////////////////////////////////
; https://www.purebasic.fr/english/viewtopic.php?f=12&t=75326

EnableExplicit

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  
  CompilerIf Defined(ICONINFO, #PB_Structure)=0
    Structure ICONINFO
      fIcon.l
      xHotspot.l
      yHotspot.l
      hbmMask.i
      hbmColor.i
    EndStructure
  CompilerEndIf
  
  Import "user32.lib"
    CreateIconIndirect(*lptICONINFO)
  EndImport
  
CompilerEndIf

Declare NewImageButtonHandler()
Declare CanvasHandler()
Declare CreateCursor()
Declare UpdateCanvas()
Declare RedrawCurves()
Declare OptionHandler()
Declare StringHandler()
Declare New()
Declare CommitHandler()
Declare CopyHandler()
Declare LogCurves()
Declare ResizeHandler()
Declare ConvertCurvesToOutput()
Declare ConvertCurvesFromOutput()
Declare InitializeCanvas()
Declare UndoHandler()
Declare RedoHandler()

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  
  Declare InsertHandler()
  
CompilerEndIf

Declare ZoomHandler()
Declare ScrollHandler()

Structure pointd
  x.d
  y.d
EndStructure

Structure curve
  moverequired.i
  startpoint.pointd
  firstpoint.pointd
  secondpoint.pointd
  endpoint.pointd
EndStructure

; Control points
Global.pointd startpoint,firstpoint,secondpoint,endpoint,oldstartpoint,oldfirstpoint,oldsecondpoint,oldendpoint

; Dimensions
Global.d width_viewport,height_viewport,oldwidth_viewport,oldheight_viewport,oldcx,oldcy,outputcx,outputcy
Global.d max_viewport,max_zoom=1800,width_zoom,height_zoom,szIcon
Global Dim cx.d(1)
Global Dim cy.d(1)
Global Dim cxborder.d(1)
Global Dim cyborder.d(1)

; Images
Global.i imgCursor=CreateCursor(),imgOriginalBackground,imgOutput,imgZoomed,imgZoomNormal,imgZoomViewport,imgUndo,imgRedo
Global Dim imgBackgrounds.i(1)
Global Dim imgLayers.i(1)

; Gadgets
Global.i gadget_output,option1,option2,option3,option4,option5,option6,option7,gadget_cx, gadget_cy,label_cx,label_cy,canvas
Global.i testcanvas,ccontainer,button_commit,button_newimage,button_copy,gadget_undo,gadget_redo,button_insert
Global.i gadget_zoom,gadget_zoom_viewport

; Logic Flow variables
Global.i moveinprogress,curveactive,newcurve,on1,on2,on3,on4,zoomlevel=0

; Fonts
Define.i output_font

Global NewList codelines.s()
Global NewList curves.curve()
Global NewList displaycurves.curve()
Global NewList trashcurves.curve()
Global NewList trashdisplaycurves.curve()

OpenWindow(0,0,0,1024,710,"Vector Curve Designer Version 1.0",#PB_Window_ScreenCentered |
                                                           #PB_Window_SystemMenu        |
                                                           #PB_Window_SizeGadget        |
                                                           #PB_Window_MinimizeGadget    |
                                                           #PB_Window_MaximizeGadget)
; StickyWindow(0,1)
WindowBounds(0,780,470,#PB_Default,#PB_Default)
width_viewport=WindowHeight(0)-10
height_viewport=width_viewport
BindEvent(#PB_Event_SizeWindow, @ResizeHandler())

; Left side control panel
szIcon=24
imgUndo=CreateImage(#PB_Any,szIcon,szIcon,32,#PB_Image_Transparent)
imgRedo=CreateImage(#PB_Any, szIcon,szIcon,32,#PB_Image_Transparent)
StartVectorDrawing(ImageVectorOutput(imgUndo))
  VectorSourceColor(RGBA(255,255,255,255))
  FillVectorOutput()
  VectorSourceColor(RGBA(0,0,0,255))
  AddPathCircle(0.5000*szIcon,0.6000*szIcon,0.2100*szIcon,40,240,#PB_Path_CounterClockwise)
  SaveVectorState()     
    RotateCoordinates(0.5000*szIcon,0.5000*szIcon, PathPointAngle(PathLength()))
    AddPathLine(0.0000*szIcon,-0.1000*szIcon, #PB_Path_Relative)
    AddPathLine(0.1333*szIcon,0.0667*szIcon, #PB_Path_Relative)
    AddPathLine(-0.1333*szIcon,0.1000*szIcon, #PB_Path_Relative)
    AddPathLine(0.0000*szIcon,-0.1000*szIcon,#PB_Path_Relative)
  RestoreVectorState()   
  StrokePath(0.0933*szIcon)
StopVectorDrawing()

StartVectorDrawing(ImageVectorOutput(imgRedo))
  FlipCoordinatesX(0.5000*szIcon)
  MovePathCursor(0,0)
  DrawVectorImage(ImageID(imgUndo))
StopVectorDrawing()

imgZoomNormal=CreateImage(#PB_Any,szIcon,szIcon,24,#White)
StartVectorDrawing(ImageVectorOutput(imgZoomNormal))
  AddPathCircle(0.4667*szIcon,0.4667*szIcon,0.3000*szIcon)
  StrokePath(0.0800*szIcon)
  MovePathCursor(0.7167*szIcon,0.7167*szIcon)
  AddPathLine(0.8667*szIcon,0.8667*szIcon)
  VectorSourceColor(RGBA(0,0,0,255))
  StrokePath(0.2000*szIcon,#PB_Path_RoundCorner|#PB_Path_RoundEnd)
  MovePathCursor(0.4667*szIcon,0.3333*szIcon)
  AddPathLine(0.4667*szIcon,0.6000*szIcon)
  MovePathCursor(0.3333*szIcon,0.4667*szIcon)
  AddPathLine(0.6000*szIcon,0.4667*szIcon)
  StrokePath(0.0800*szIcon,#PB_Path_RoundCorner|#PB_Path_RoundEnd)
StopVectorDrawing()

imgZoomed=CreateImage(#PB_Any,szIcon,szIcon,24,#White)
StartVectorDrawing(ImageVectorOutput(imgZoomed))
  VectorSourceColor(RGBA(255,0,0,255))
  AddPathCircle(0.4667*szIcon,0.4667*szIcon,0.3000*szIcon)
  StrokePath(0.0800*szIcon)
  MovePathCursor(0.7167*szIcon,0.7167*szIcon)
  AddPathLine(0.8667*szIcon,0.8667*szIcon)
  StrokePath(0.2000*szIcon,#PB_Path_RoundCorner|#PB_Path_RoundEnd)
  MovePathCursor(0.4667*szIcon,0.3333*szIcon)
  AddPathLine(0.4667*szIcon,0.6000*szIcon)
  MovePathCursor(0.3333*szIcon,0.4667*szIcon)
  AddPathLine(0.6000*szIcon,0.4667*szIcon)
  StrokePath(0.0800*szIcon,#PB_Path_RoundCorner|#PB_Path_RoundEnd)
StopVectorDrawing()

FrameGadget(#PB_Any,10,10,270,36,"",#PB_Frame_Flat)
gadget_undo=ButtonImageGadget(#PB_Any, 12,12,32,32,ImageID(imgUndo))
gadget_redo=ButtonImageGadget(#PB_Any, 44,12,32,32,ImageID(imgRedo))
gadget_zoom=ButtonImageGadget(#PB_Any, 78,12,32,32,ImageID(imgZoomNormal),#PB_Button_Toggle)
BindGadgetEvent(gadget_undo, @UndoHandler())
BindGadgetEvent(gadget_redo, @RedoHandler())
BindGadgetEvent(gadget_zoom, @ZoomHandler())

button_newimage=ButtonGadget(#PB_Any, 10,50,270,20,"Load Image")
BindGadgetEvent(button_newimage, @NewImageButtonHandler())
FrameGadget(#PB_Any, 10,85,270,80,"Output Type")
option1=OptionGadget(#PB_Any,40,110,90,20,"Fixed size")
option2=OptionGadget(#PB_Any,40,130,90,20,"proportional")
SetGadgetState(option1,1)
BindGadgetEvent(option1,@OptionHandler())
BindGadgetEvent(option2,@OptionHandler())
label_cx=TextGadget(#PB_Any, 140,112,15,20,"W:")
gadget_cx=StringGadget(#PB_Any,158,110,35,20,"")
label_cy=TextGadget(#PB_Any, 204,112,15,20,"H:")
gadget_cy=StringGadget(#PB_Any,220,110,35,20,"")
DisableGadget(gadget_cx, 0)
DisableGadget(gadget_cy, 0)
DisableGadget(label_cx, 0)
DisableGadget(label_cy, 0)
BindGadgetEvent(gadget_cx, @StringHandler())
BindGadgetEvent(gadget_cy, @StringHandler())
FrameGadget(#PB_Any, 10,180,270,90,"View")
option3=OptionGadget(#PB_Any,40,200,90,20,"Design View")
option4=OptionGadget(#PB_Any,40,220,90,20,"Code View")
option5=OptionGadget(#PB_Any,40,240,90,20,"Test View")
BindGadgetEvent(option3, @OptionHandler())
BindGadgetEvent(option4, @OptionHandler())
BindGadgetEvent(option5, @OptionHandler())
SetGadgetState(option3, 1)
FrameGadget(#PB_Any, 10,290,270,80,"Curve Type")
option6=OptionGadget(#PB_Any,40,310,190,20,"Independent curve")
option7=OptionGadget(#PB_Any,40,330,190,20,"Continuation of last curve")
BindGadgetEvent(option6, @OptionHandler())
BindGadgetEvent(option7, @OptionHandler())
SetGadgetState(option6,1)
button_commit=ButtonGadget(#PB_Any, 10,380,270,20,"Commit This Curve")
DisableGadget(button_commit, 1)
BindGadgetEvent(button_commit, @CommitHandler())
button_copy=ButtonGadget(#PB_Any, 10,410,270,20,"Copy Code To Clipboard")
BindGadgetEvent(button_copy, @CopyHandler())

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  
  button_insert=ButtonGadget(#PB_Any, 10,440,270,20,"Insert Code To IDE")
  BindGadgetEvent(button_insert, @InsertHandler())
  
CompilerEndIf

gadget_zoom_viewport = ImageGadget(#PB_Any,60,480,0,0,0,#PB_Image_Raised)
HideGadget(gadget_zoom_viewport, 1)

; Edit window
ccontainer=ScrollAreaGadget(#PB_Any,315,0,702,702,700,700,10,#PB_ScrollArea_Flat)
BindGadgetEvent(ccontainer, @ScrollHandler())
canvas=CanvasGadget(#PB_Any,0,0,700,700,#PB_Canvas_Keyboard|#PB_Canvas_ClipMouse)
CloseGadgetList()
BindGadgetEvent(canvas, @CanvasHandler())
testcanvas=CanvasGadget(#PB_Any,321,1,WindowHeight(0)-2,WindowHeight(0)-2)
output_font=LoadFont(#PB_Any, "consolas", 11)
gadget_output = EditorGadget(#PB_Any, 316,1,700,700)
SetGadgetFont(gadget_output, FontID(output_font))
HideGadget(gadget_output,1)
HideGadget(testcanvas,1)
imgOriginalBackground=CreateImage(#PB_Any, WindowHeight(0)-2,WindowHeight(0)-2,24)
InitializeCanvas()

SetActiveGadget(canvas)

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow

;===============================================
;              PROCEDURE SECTION
;===============================================

Procedure ScrollHandler()
  Protected.d cxsmall,cysmall,x,y
  Protected.i imgZoomViewportOutput
  If Not IsImage(imgZoomViewport)
    imgZoomViewport=CreateImage(#PB_Any, ImageWidth(imgBackgrounds(0))*0.2,ImageHeight(imgBackgrounds(0))*0.2)
    StartVectorDrawing(ImageVectorOutput(imgZoomViewport))
      MovePathCursor(0,0)
      DrawVectorImage(ImageID(imgBackgrounds(0)),255,ImageWidth(imgZoomViewport),ImageHeight(imgZoomViewport))
    StopVectorDrawing()
    ResizeGadget(gadget_zoom_viewport,#PB_Ignore,#PB_Ignore,ImageWidth(imgZoomViewport),ImageHeight(imgZoomViewport))
    SetGadgetState(gadget_zoom_viewport, ImageID(imgZoomViewport))
  EndIf
  
  cxsmall.d = ImageWidth(imgZoomViewport)
  cysmall.d = ImageHeight(imgZoomViewport)
  x.d = GetGadgetAttribute(ccontainer, #PB_ScrollArea_X)
  y.d = GetGadgetAttribute(ccontainer, #PB_ScrollArea_Y)
  imgZoomViewportOutput = CopyImage(imgZoomViewport, #PB_Any)
  StartVectorDrawing(ImageVectorOutput(imgZoomViewportOutput))
    MovePathCursor(0,0)
    DrawVectorImage(ImageID(imgLayers(1)),255,cxsmall,cysmall)   
    AddPathBox(x/ImageWidth(imgBackgrounds(1))*cxsmall+1,
               y/ImageHeight(imgBackgrounds(1))*cysmall+1,
               width_viewport/ImageWidth(imgBackgrounds(1))*cxsmall,
               height_viewport/ImageHeight(imgBackgrounds(1))*cysmall)
    VectorSourceColor(RGBA(255,0,0,255))
    StrokePath(1)
  StopVectorDrawing()
  SetGadgetState(gadget_zoom_viewport, ImageID(imgZoomViewportOutput))
  
EndProcedure

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  
  Procedure InsertHandler()
    Protected.i scintilla
    Protected *textBuffer
    scintilla = Val(GetEnvironmentVariable("PB_Tool_Scintilla"))
    If Not IsWindowVisible_(scintilla)
      MessageRequester("Notice","You can only add the generated code"+#CRLF$             +
                                "to the file you launched the tool from."+#CRLF$+#CRLF$  +
                                "To deposit the code elsewhere, use the"+#CRLF$          +
                                "copy button and paste the code manually")
    Else
      If scintilla
        *textBuffer = UTF8(#CRLF$+"; Code inserted by Vector Curve Designer" +
                           #CRLF$+GetGadgetText(gadget_output)+#CRLF$ +
                           "; End of Curve Designer Code"+#CRLF$)
        SendMessage_(scintilla, #EM_REPLACESEL, 0, *textBuffer)
        Delay(10)
        FreeMemory(*textBuffer)
      Else
        MessageRequester("Notice:","Scintilla editor not found!"+#CRLF$+#CRLF$ +
                                   "Invoke Curve Designer tool from the PureBasic IDE for this feature.")
      EndIf
    EndIf
  EndProcedure
  
CompilerEndIf

Procedure UpdateTestCanvas()
  StartVectorDrawing(CanvasVectorOutput(testcanvas))
    VectorSourceColor(RGBA(255,255,255,255))
    FillVectorOutput()
    ForEach displaycurves()
      With displaycurves()
        If \moverequired
          MovePathCursor(\startpoint\x, \startpoint\y)
        EndIf
        AddPathCurve(\firstpoint\x,\firstpoint\y,\secondpoint\x,\secondpoint\y,\endpoint\x,\endpoint\y)
      EndWith
    Next
    VectorSourceColor(RGBA(0,0,0,255))
    StrokePath(3,#PB_Path_RoundCorner|#PB_Path_RoundEnd)
  StopVectorDrawing()
EndProcedure

Procedure UndoHandler()
  If curveactive Or (startpoint\x<>0 And startpoint\y<>0 And endpoint\x=0 And endpoint\y=0)
    ClearStructure(startpoint, pointd)
    ClearStructure(firstpoint, pointd)
    ClearStructure(secondpoint, pointd)
    ClearStructure(endpoint, pointd)
    curveactive=0
    RedrawCurves()
  Else
    If ListSize(curves())
      LastElement(curves())
      If curves()\moverequired
        New()
      Else
        moveinprogress=0
        newcurve=0
        SetGadgetState(option7,1)
      EndIf
      AddElement(trashcurves())
      trashcurves()=curves()
      DeleteElement(curves())
      RedrawCurves()
    EndIf
  EndIf
  curveactive=0
  DisableGadget(button_commit, 1)
  ConvertCurvesToOutput()
  LogCurves()
  UpdateTestCanvas()
  SetActiveGadget(canvas)
  If ListSize(curves())=0
    New()
  EndIf
  ConvertCurvesFromOutput()
  RedrawCurves()
EndProcedure

Procedure RedoHandler()
  If ListSize(trashcurves())
    LastElement(trashcurves())
    LastElement(curves())
    AddElement(curves())
    curves()=trashcurves()
    DeleteElement(trashcurves())
    curveactive=0
    DisableGadget(button_commit, 1)
  EndIf
  ConvertCurvesToOutput()
  LogCurves()
  UpdateTestCanvas()
  SetActiveGadget(canvas)
  If ListSize(curves())=0
    New()
  EndIf
  curveactive=0
  newcurve=0
  SetGadgetState(option7,1)
  DisableGadget(button_commit,1)
  ConvertCurvesFromOutput()
  RedrawCurves()
EndProcedure

Procedure InitializeCanvas()
  Protected max_viewport.d,w.d,h.d
  ClearList(curves())
  ClearList(displaycurves())
  ClearList(trashcurves())
  ClearList(codelines())
  ClearGadgetItems(gadget_output)
  ClearStructure(startpoint, pointd)
  ClearStructure(firstpoint, pointd)
  ClearStructure(secondpoint, pointd)
  ClearStructure(endpoint, pointd)
  
  
  StartVectorDrawing(CanvasVectorOutput(testcanvas))
    VectorSourceColor(RGBA(255,255,255,255))
  StopVectorDrawing()
  New()
  SetGadgetState(option1,1)
  HideGadget(gadget_output,1)
  HideGadget(testcanvas,1)
  HideGadget(ccontainer,0)
  SetGadgetState(option3,1)
  SetGadgetState(option6,1)
  w.d = ImageWidth(imgOriginalBackground)
  h.d = ImageHeight(imgOriginalBackground)
  If h>w
    height_zoom.d=max_zoom
    width_zoom.d=w/h*max_zoom
  Else
    width_zoom.d=max_zoom
    height_zoom.d=h/w*max_zoom   
  EndIf
  cxborder(1)=width_zoom*0.2
  cyborder(1)=height_zoom*0.2
  cx(1)=0.6*width_zoom
  cy(1)=0.6*height_zoom 
  outputcx=w
  outputcy=h
  ResizeGadget(testcanvas,316,1,outputcx,outputcy)
  SetGadgetText(gadget_cx, Str(outputcx))
  SetGadgetText(gadget_cy, Str(outputcy))
  max_viewport=WindowHeight(0)-10
  If h>w
    height_viewport.d=max_viewport
    width_viewport.d=w/h*max_viewport
  Else
    width_viewport.d=max_viewport
    height_viewport.d=h/w*max_viewport   
  EndIf
  oldwidth_viewport=width_viewport
  oldheight_viewport=height_viewport
  cxborder(0)=width_viewport*0.2
  cyborder(0)=height_viewport*0.2
  cx(0)=0.6*width_viewport
  cy(0)=0.6*height_viewport
  oldcx=cx(0)
  oldcy=cy(0)
  If IsImage(imgBackgrounds(0)) : FreeImage(imgBackgrounds(0)) : EndIf
  imgBackgrounds(0) = CreateImage(#PB_Any,width_viewport,height_viewport,24,#White)
  StartVectorDrawing(ImageVectorOutput(imgBackgrounds(0)))
    VectorSourceColor(RGBA(255,255,255,255))
    FillVectorOutput()
    MovePathCursor(cxborder(0),cyborder(0))
    DrawVectorImage(ImageID(imgOriginalBackground),80,cx(0),cy(0))
    AddPathBox(cxborder(0),cyborder(0),cx(0),cy(0))
    VectorSourceColor(RGBA(100,100,255,255))
    DashPath(1,4)
  StopVectorDrawing()
  If IsImage(imgBackgrounds(1)) : FreeImage(imgBackgrounds(1)) : EndIf
  imgBackgrounds(1) = CreateImage(#PB_Any,width_zoom,height_zoom,24,#White)
  StartVectorDrawing(ImageVectorOutput(imgBackgrounds(1)))
    MovePathCursor(0,0)
    DrawVectorImage(ImageID(imgBackgrounds(0)),255,ImageWidth(imgBackgrounds(1)),ImageHeight(imgBackgrounds(1)))
  StopVectorDrawing()
  If IsImage(imgLayers(0)) : FreeImage(imgLayers(0)) : EndIf
  imgLayers(0) = CreateImage(#PB_Any, width_viewport,height_viewport,32,#PB_Image_Transparent)
  If IsImage(imgLayers(1)) : FreeImage(imgLayers(1)) : EndIf
  imgLayers(1) = CreateImage(#PB_Any,ImageWidth(imgBackgrounds(1)),ImageHeight(imgBackgrounds(1)),32,#PB_Image_Transparent)
  ResizeGadget(canvas, #PB_Ignore,#PB_Ignore,width_viewport,height_viewport)
  SetGadgetAttribute(canvas, #PB_Canvas_Image, ImageID(imgBackgrounds(0)))
  SetGadgetAttribute(canvas, #PB_Canvas_CustomCursor, imgCursor)
  
EndProcedure

Procedure ConvertCurvesToOutput()
  ClearList(displaycurves()) 
  ForEach curves()
    AddElement(displaycurves())
    With displaycurves()
      \moverequired  = curves()\moverequired
      \startpoint\x  = (curves()\startpoint\x-cxborder(zoomlevel))/cx(zoomlevel)*outputcx
      \startpoint\y  = (curves()\startpoint\y-cyborder(zoomlevel))/cy(zoomlevel)*outputcy
      \firstpoint\x  = (curves()\firstpoint\x-cxborder(zoomlevel))/cx(zoomlevel)*outputcx
      \firstpoint\y  = (curves()\firstpoint\y-cyborder(zoomlevel))/cy(zoomlevel)*outputcy
      \secondpoint\x = (curves()\secondpoint\x-cxborder(zoomlevel))/cx(zoomlevel)*outputcx
      \secondpoint\y = (curves()\secondpoint\y-cyborder(zoomlevel))/cy(zoomlevel)*outputcy
      \endpoint\x    = (curves()\endpoint\x-cxborder(zoomlevel))/cx(zoomlevel)*outputcx
      \endpoint\y    = (curves()\endpoint\y-cyborder(zoomlevel))/cy(zoomlevel)*outputcy     
    EndWith
  Next
  ClearList(trashdisplaycurves()) 
  ForEach trashcurves()
    AddElement(trashdisplaycurves())
    With trashdisplaycurves()
      \moverequired  = trashcurves()\moverequired
      \startpoint\x  = (trashcurves()\startpoint\x-cxborder(zoomlevel))/cx(zoomlevel)*outputcx
      \startpoint\y  = (trashcurves()\startpoint\y-cyborder(zoomlevel))/cy(zoomlevel)*outputcy
      \firstpoint\x  = (trashcurves()\firstpoint\x-cxborder(zoomlevel))/cx(zoomlevel)*outputcx
      \firstpoint\y  = (trashcurves()\firstpoint\y-cyborder(zoomlevel))/cy(zoomlevel)*outputcy
      \secondpoint\x = (trashcurves()\secondpoint\x-cxborder(zoomlevel))/cx(zoomlevel)*outputcx
      \secondpoint\y = (trashcurves()\secondpoint\y-cyborder(zoomlevel))/cy(zoomlevel)*outputcy
      \endpoint\x    = (trashcurves()\endpoint\x-cxborder(zoomlevel))/cx(zoomlevel)*outputcx
      \endpoint\y    = (trashcurves()\endpoint\y-cyborder(zoomlevel))/cy(zoomlevel)*outputcy     
    EndWith
  Next
EndProcedure

Procedure ConvertCurvesFromOutput()
  ClearList(curves())
  ForEach displaycurves()
    AddElement(curves())
    With curves()
      \moverequired  = displaycurves()\moverequired
      \startpoint\x  = displaycurves()\startpoint\x*cx(zoomlevel)/outputcx+cxborder(zoomlevel)
      \startpoint\y  = displaycurves()\startpoint\y*cy(zoomlevel)/outputcy+cyborder(zoomlevel)
      \firstpoint\x  = displaycurves()\firstpoint\x*cx(zoomlevel)/outputcx+cxborder(zoomlevel)
      \firstpoint\y  = displaycurves()\firstpoint\y*cy(zoomlevel)/outputcy+cyborder(zoomlevel)
      \secondpoint\x = displaycurves()\secondpoint\x*cx(zoomlevel)/outputcx+cxborder(zoomlevel)
      \secondpoint\y = displaycurves()\secondpoint\y*cy(zoomlevel)/outputcy+cyborder(zoomlevel)
      \endpoint\x    = displaycurves()\endpoint\x*cx(zoomlevel)/outputcx+cxborder(zoomlevel)
      \endpoint\y    = displaycurves()\endpoint\y*cy(zoomlevel)/outputcy+cyborder(zoomlevel)   
    EndWith
  Next
  ClearList(trashcurves())
  ForEach trashdisplaycurves()
    AddElement(trashcurves())
    With trashcurves()
      \moverequired  = trashdisplaycurves()\moverequired
      \startpoint\x  = trashdisplaycurves()\startpoint\x*cx(zoomlevel)/outputcx+cxborder(zoomlevel)
      \startpoint\y  = trashdisplaycurves()\startpoint\y*cy(zoomlevel)/outputcy+cyborder(zoomlevel)
      \firstpoint\x  = trashdisplaycurves()\firstpoint\x*cx(zoomlevel)/outputcx+cxborder(zoomlevel)
      \firstpoint\y  = trashdisplaycurves()\firstpoint\y*cy(zoomlevel)/outputcy+cyborder(zoomlevel)
      \secondpoint\x = trashdisplaycurves()\secondpoint\x*cx(zoomlevel)/outputcx+cxborder(zoomlevel)
      \secondpoint\y = trashdisplaycurves()\secondpoint\y*cy(zoomlevel)/outputcy+cyborder(zoomlevel)
      \endpoint\x    = trashdisplaycurves()\endpoint\x*cx(zoomlevel)/outputcx+cxborder(zoomlevel)
      \endpoint\y    = trashdisplaycurves()\endpoint\y*cy(zoomlevel)/outputcy+cyborder(zoomlevel)   
    EndWith
  Next
EndProcedure

Procedure ResizeHandler()
  Protected.d w,h,max_viewport
  
  ConvertCurvesToOutput()
  w=ImageWidth(imgOriginalBackground)
  h=ImageHeight(imgOriginalBackground)
  max_viewport=WindowHeight(0)-10
  If h>w
    height_viewport.d=max_viewport
    width_viewport.d=w/h*max_viewport
  Else
    width_viewport.d=max_viewport
    height_viewport.d=h/w*max_viewport   
  EndIf
  cxborder(0)=width_viewport*0.2
  cyborder(0)=height_viewport*0.2
  cx(0)=0.6*width_viewport
  cy(0)=0.6*height_viewport
  
  If zoomlevel=0 
    If curveactive
      startpoint\x  = (oldstartpoint\x/oldwidth_viewport)*width_viewport
      startpoint\y  = (oldstartpoint\y/oldheight_viewport)*height_viewport
      endpoint\x    = (oldendpoint\x/oldwidth_viewport)*width_viewport
      endpoint\y    = (oldendpoint\y/oldheight_viewport)*height_viewport
      firstpoint\x  = (oldfirstpoint\x/oldwidth_viewport)*width_viewport
      firstpoint\y  = (oldfirstpoint\y/oldheight_viewport)*height_viewport
      secondpoint\x = (oldsecondpoint\x/oldwidth_viewport)*width_viewport
      secondpoint\y = (oldsecondpoint\y/oldheight_viewport)*height_viewport
    EndIf
  EndIf
  
  If IsImage(imgBackgrounds(0)) : FreeImage(imgBackgrounds(0)) : EndIf
  imgBackgrounds(0) = CreateImage(#PB_Any,width_viewport,height_viewport,24,#White)
  StartVectorDrawing(ImageVectorOutput(imgBackgrounds(0)))
    VectorSourceColor(RGBA(255,255,255,255))
    FillVectorOutput()
    MovePathCursor(cxborder(0),cyborder(0))
    DrawVectorImage(ImageID(imgOriginalBackground),80,cx(0),cy(0))
    AddPathBox(cxborder(0),cyborder(0),cx(0),cy(0))
    VectorSourceColor(RGBA(100,100,255,255))
    DashPath(1,4)
  StopVectorDrawing()
  ResizeGadget(canvas, 1,1,ImageWidth(imgBackgrounds(zoomlevel)),ImageHeight(imgBackgrounds(zoomlevel)))
  SetGadgetAttribute(canvas,#PB_Canvas_Image,ImageID(imgBackgrounds(zoomlevel))) 
  ResizeGadget(ccontainer, 316,1,width_viewport+2,height_viewport+2)
  SetGadgetAttribute(ccontainer, #PB_ScrollArea_InnerWidth, ImageWidth(imgBackgrounds(zoomlevel)))
  SetGadgetAttribute(ccontainer, #PB_ScrollArea_InnerHeight, ImageHeight(imgBackgrounds(zoomlevel)))
  If IsImage(imgLayers(0)) : FreeImage(imgLayers(0)) : EndIf
  imgLayers(0) = CreateImage(#PB_Any, width_viewport,height_viewport,32,#PB_Image_Transparent)

  If curveactive
    oldstartpoint=startpoint
    oldfirstpoint=firstpoint
    oldsecondpoint=secondpoint
    oldendpoint=endpoint
  EndIf   
  oldwidth_viewport=width_viewport
  oldheight_viewport=height_viewport
  oldcx=cx(0)
  oldcy=cy(0)
  SetActiveGadget(canvas)
  ConvertCurvesFromOutput()
  RedrawCurves()
  
EndProcedure

Procedure CopyHandler()
  Protected.s code
  code = "; Code inserted by Vector Curve Designer"+#CRLF$ +
         GetGadgetText(gadget_output)+#CRLF$               +
         "; End of Vector Curve Designer code"
  If GetGadgetText(gadget_output)<>""
    SetClipboardText(code+#CRLF$)
    MessageRequester("Notice:", "Code is on the clipboard")
  Else
    MessageRequester("Notice:", "Nothing to copy!")
  EndIf
  SetActiveGadget(canvas)
  
EndProcedure

Procedure LogCurves() ; Build list of codeline strings from Curves() list and display them
  Protected currentcodestring.s,saved_zoomlevel.i
  Protected.s s1,s2,p1,p2,p3,p4,p5,p6
  ConvertCurvesToOutput()
  saved_zoomlevel=zoomlevel
  zoomlevel=0
  ConvertCurvesFromOutput()
  zoomlevel=saved_zoomlevel
  ClearList(codelines())
  ForEach curves()
    If GetGadgetState(option1)
      If curves()\moverequired
        s1.s=StrD((curves()\startpoint\x-cxborder(0))/cx(0)*outputcx,2)
        s2.s=StrD((curves()\startpoint\y-cyborder(0))/cy(0)*outputcy,2)
        currentcodestring="MovePathCursor("+s1+","+s2+")"+#CRLF$
      Else
        currentcodestring=""
      EndIf
      p1.s=StrD((curves()\firstpoint\x-cxborder(0))/cx(0)*outputcx,2)+","
      p2.s=StrD((curves()\firstpoint\y-cyborder(0))/cy(0)*outputcy,2)+","
      p3.s=StrD((curves()\secondpoint\x-cxborder(0))/cx(0)*outputcx,2)+","
      p4.s=StrD((curves()\secondpoint\y-cyborder(0))/cy(0)*outputcy,2)+","
      p5.s=StrD((curves()\endpoint\x-cxborder(0))/cx(0)*outputcx,2)+","
      p6.s=StrD((curves()\endpoint\y-cyborder(0))/cy(0)*outputcy,2)
      currentcodestring+"AddPathCurve("+p1+p2+p3+p4+p5+p6+")"
      AddElement(codelines())
      codelines()=currentcodestring
    Else
      If ListSize(codelines())=0
        currentcodestring="cx.d="+Str(outputcx)+" : "+"cy.d="+Str(outputcy)+#CRLF$
      Else
        currentcodestring=""
      EndIf
      s1.s=StrD(Round((curves()\startpoint\x-cxborder(0))/cx(0)*outputcx,#PB_Round_Nearest)/outputcx,4)+"*cx"
      s2.s=StrD(Round((curves()\startpoint\y-cyborder(0))/cy(0)*outputcy,#PB_Round_Nearest)/outputcy,4)+"*cy"
      If curves()\moverequired
        currentcodestring+"MovePathCursor("+s1+","+s2+")"+#CRLF$
      EndIf
      p1.s=StrD(Round((curves()\firstpoint\x-cxborder(0))/cx(0)*outputcx,#PB_Round_Nearest)/outputcx,4)+"*cx"+","
      p2.s=StrD(Round((curves()\firstpoint\y-cyborder(0))/cy(0)*outputcy,#PB_Round_Nearest)/outputcx,4)+"*cy"+","
      p3.s=StrD(Round((curves()\secondpoint\x-cxborder(0))/cx(0)*outputcx,#PB_Round_Nearest)/outputcx,4)+"*cx"+","
      p4.s=StrD(Round((curves()\secondpoint\y-cyborder(0))/cy(0)*outputcy,#PB_Round_Nearest)/outputcx,4)+"*cy"+","
      p5.s=StrD(Round((curves()\endpoint\x-cxborder(0))/cx(0)*outputcx,#PB_Round_Nearest)/outputcx,4)+"*cx"+","
      p6.s=StrD(Round((curves()\endpoint\y-cyborder(0))/cy(0)*outputcy,#PB_Round_Nearest)/outputcx,4)+"*cy"
      currentcodestring+"AddPathCurve("+p1+p2+p3+p4+p5+p6+")"
      AddElement(codelines())
      codelines()=currentcodestring
    EndIf
  Next
  ClearGadgetItems(gadget_output)
  ForEach codelines()
    AddGadgetItem(gadget_output, -1, codelines())
  Next
EndProcedure

Procedure CommitHandler()
  ClearList(trashcurves())
  SetGadgetState(option7, 1)
  DisableGadget(button_commit, 1)
  If Not newcurve
    LastElement(curves())
    curves()\endpoint\x=startpoint\x
    curves()\endpoint\y=startpoint\y
  EndIf
  AddElement(curves())
  With curves()
    If newcurve
      \moverequired=1
    Else
      \moverequired=0
    EndIf
    \startpoint\x=startpoint\x
    \startpoint\y=startpoint\y
    \firstpoint\x=firstpoint\x
    \firstpoint\y=firstpoint\y
    \secondpoint\x=secondpoint\x
    \secondpoint\y=secondpoint\y
    \endpoint\x=endpoint\x
    \endpoint\y=endpoint\y
  EndWith
  ConvertCurvesToOutput()
  LogCurves()
  startpoint\x=0:startpoint\y=0:endpoint\x=0:endpoint\y=0
  ClearStructure(firstpoint,pointd)
  ClearStructure(secondpoint,pointd)
  curveactive=0
  ConvertCurvesFromOutput()
  RedrawCurves()
  newcurve=0
  SetActiveGadget(canvas)
  
EndProcedure

Procedure New()
  curveactive=0
  newcurve=1
  DisableGadget(button_commit, 1)
  SetGadgetState(option6,1)
EndProcedure

Procedure StringHandler()
  outputcx = Val(GetGadgetText(gadget_cx))
  outputcy = Val(GetGadgetText(gadget_cy))
  SetActiveGadget(canvas)
  
EndProcedure

Procedure OptionHandler()
  Select EventGadget()
    Case option1
      DisableGadget(gadget_cx, 0)
      DisableGadget(gadget_cy, 0)
      DisableGadget(label_cx, 0)
      DisableGadget(label_cy, 0)
      LogCurves()
    Case option2
      DisableGadget(gadget_cx, 1)
      DisableGadget(gadget_cy, 1)
      DisableGadget(label_cx, 1)
      DisableGadget(label_cy, 1)
      LogCurves()
    Case option3
      HideGadget(ccontainer, 0)
      HideGadget(gadget_output, 1)
      HideGadget(testcanvas,1)
    Case option4
      HideGadget(gadget_output, 0)
      HideGadget(ccontainer, 1)
      HideGadget(testcanvas,1)
    Case option5
      UpdateTestCanvas()
      HideGadget(testcanvas,0)
      HideGadget(gadget_output, 1)
      HideGadget(ccontainer, 1)
    Case option6
      New()
    Case option7
      If ListSize(curves())=0
        MessageRequester("Notice:", "No curves to continue!")
        SetGadgetState(option6, 1)
      Else
        newcurve=0
      EndIf
  EndSelect
  SetActiveGadget(canvas)
  
EndProcedure

Procedure RedrawCurves()
  StartDrawing(ImageOutput(imgLayers(zoomlevel)))
    DrawingMode(#PB_2DDrawing_AllChannels)
    Box(0,0,ImageWidth(imgLayers(zoomlevel)),ImageHeight(imgLayers(zoomlevel)),RGBA(0,0,0,0))
  StopDrawing()
  StartVectorDrawing(ImageVectorOutput(imgLayers(zoomlevel)))
    ForEach curves()
      With curves()
        MovePathCursor(\startpoint\x,\startpoint\y)
        AddPathCurve(\firstpoint\x,\firstpoint\y,\secondpoint\x,\secondpoint\y,\endpoint\x,\endpoint\y)
        VectorSourceColor(RGBA(255,0,0,255))
        If zoomlevel
          StrokePath(6,#PB_Path_RoundCorner|#PB_Path_RoundEnd)
        Else
          StrokePath(2)
        EndIf
      EndWith
    Next
    If curveactive
      MovePathCursor(startpoint\x,startpoint\y)
      AddPathCurve(firstpoint\x,firstpoint\y,secondpoint\x,secondpoint\y,endpoint\x,endpoint\y)
      VectorSourceColor(RGBA(255,0,0,255))
      DashPath(1,2)
      AddPathCircle(startpoint\x,startpoint\y,4)
      VectorSourceColor(RGBA(250,0,0,255))
      FillPath()
      AddPathCircle(firstpoint\x,firstpoint\y,4)
      VectorSourceColor(RGBA(248,0,0,255))
      FillPath()         
      AddPathCircle(secondpoint\x,secondpoint\y,4)
      VectorSourceColor(RGBA(246,0,0,255))
      FillPath()         
      AddPathCircle(endpoint\x,endpoint\y,4)
      VectorSourceColor(RGBA(244,0,0,255))
      FillPath()         
    EndIf
  StopVectorDrawing()
  UpdateCanvas()
EndProcedure

Procedure ZoomHandler()
  Protected.i imgZoomViewportOutput
  Protected.d cxsmall,cysmall,x,y
  ConvertCurvesToOutput()
  If GetGadgetAttribute(gadget_zoom, #PB_Button_Image) = ImageID(imgZoomed)
    SetGadgetAttribute(gadget_zoom, #PB_Button_Image, ImageID(imgZoomNormal))
    zoomlevel=0
  Else
    SetGadgetAttribute(gadget_zoom, #PB_Button_Image, ImageID(imgZoomed))
    zoomlevel=1
  EndIf
  Select zoomlevel
    Case 0
      ResizeGadget(canvas,#PB_Ignore,#PB_Ignore, width_viewport, height_viewport)
    Case 1
      ResizeGadget(canvas,#PB_Ignore,#PB_Ignore, ImageWidth(imgBackgrounds(1)),ImageHeight(imgBackgrounds(1)))
  EndSelect
  SetGadgetAttribute(ccontainer,#PB_ScrollArea_InnerWidth,GadgetWidth(canvas))
  SetGadgetAttribute(ccontainer,#PB_ScrollArea_InnerHeight,GadgetHeight(canvas))
  SetGadgetAttribute(canvas, #PB_Canvas_Image, ImageID(imgBackgrounds(zoomlevel)))
  SetGadgetAttribute(canvas, #PB_Canvas_CustomCursor, imgCursor)
  
  If IsImage(imgZoomViewport):FreeImage(imgZoomViewport):EndIf
  imgZoomViewport=CreateImage(#PB_Any, ImageWidth(imgBackgrounds(0))*0.2,ImageHeight(imgBackgrounds(0))*0.2)
  StartVectorDrawing(ImageVectorOutput(imgZoomViewport))
    MovePathCursor(0,0)
    DrawVectorImage(ImageID(imgBackgrounds(0)),255,ImageWidth(imgZoomViewport),ImageHeight(imgZoomViewport))
  StopVectorDrawing()
  ResizeGadget(gadget_zoom_viewport,#PB_Ignore,#PB_Ignore,ImageWidth(imgZoomViewport),ImageHeight(imgZoomViewport))
  SetGadgetState(gadget_zoom_viewport, ImageID(imgZoomViewport))
  RedrawCurves()
  cxsmall.d = ImageWidth(imgZoomViewport)
  cysmall.d = ImageHeight(imgZoomViewport)
  x.d = GetGadgetAttribute(ccontainer, #PB_ScrollArea_X)
  y.d = GetGadgetAttribute(ccontainer, #PB_ScrollArea_Y)
  imgZoomViewportOutput = CopyImage(imgZoomViewport, #PB_Any)
  StartVectorDrawing(ImageVectorOutput(imgZoomViewportOutput))
    MovePathCursor(0,0)
    DrawVectorImage(ImageID(imgLayers(1)),255,cxsmall,cysmall)   
    AddPathBox(x/ImageWidth(imgBackgrounds(1))*cxsmall+1,
               y/ImageHeight(imgBackgrounds(1))*cysmall+1,
               width_viewport/ImageWidth(imgBackgrounds(1))*cxsmall,
               height_viewport/ImageHeight(imgBackgrounds(1))*cysmall)
    VectorSourceColor(RGBA(255,0,0,255))
    StrokePath(1)
  StopVectorDrawing()
  SetGadgetState(gadget_zoom_viewport, ImageID(imgZoomViewportOutput))
  
  If zoomlevel
    HideGadget(gadget_zoom_viewport, 0)
    If curveactive
      startpoint\x  = startpoint\x/ImageWidth(imgBackgrounds(0))*ImageWidth(imgBackgrounds(1))
      startpoint\y  = startpoint\y/ImageHeight(imgBackgrounds(0))*ImageHeight(imgBackgrounds(1))
      firstpoint\x  = firstpoint\x/ImageWidth(imgBackgrounds(0))*ImageWidth(imgBackgrounds(1))
      firstpoint\y  = firstpoint\y/ImageHeight(imgBackgrounds(0))*ImageHeight(imgBackgrounds(1))
      secondpoint\x = secondpoint\x/ImageWidth(imgBackgrounds(0))*ImageWidth(imgBackgrounds(1))
      secondpoint\y = secondpoint\y/ImageHeight(imgBackgrounds(0))*ImageHeight(imgBackgrounds(1))
      endpoint\x    = endpoint\x/ImageWidth(imgBackgrounds(0))*ImageWidth(imgBackgrounds(1))
      endpoint\y    = endpoint\y/ImageHeight(imgBackgrounds(0))*ImageHeight(imgBackgrounds(1))
      oldstartpoint=startpoint
      oldfirstpoint=firstpoint
      oldsecondpoint=secondpoint
      oldendpoint=endpoint
    EndIf
  Else
    HideGadget(gadget_zoom_viewport, 1)
    If curveactive
      startpoint\x  = startpoint\x/ImageWidth(imgBackgrounds(1))*ImageWidth(imgBackgrounds(0))
      startpoint\y  = startpoint\y/ImageHeight(imgBackgrounds(1))*ImageHeight(imgBackgrounds(0))
      firstpoint\x  = firstpoint\x/ImageWidth(imgBackgrounds(1))*ImageWidth(imgBackgrounds(0))
      firstpoint\y  = firstpoint\y/ImageHeight(imgBackgrounds(1))*ImageHeight(imgBackgrounds(0))
      secondpoint\x = secondpoint\x/ImageWidth(imgBackgrounds(1))*ImageWidth(imgBackgrounds(0))
      secondpoint\y = secondpoint\y/ImageHeight(imgBackgrounds(1))*ImageHeight(imgBackgrounds(0))
      endpoint\x    = endpoint\x/ImageWidth(imgBackgrounds(1))*ImageWidth(imgBackgrounds(0))
      endpoint\y    = endpoint\y/ImageHeight(imgBackgrounds(1))*ImageHeight(imgBackgrounds(0))
      oldstartpoint=startpoint
      oldfirstpoint=firstpoint
      oldsecondpoint=secondpoint
      oldendpoint=endpoint
    EndIf
  EndIf
  ConvertCurvesFromOutput()
  RedrawCurves()
  
EndProcedure

Procedure CanvasHandler()
  Protected.i cursorx,cursory
  
  Select EventType()
      
    Case #PB_EventType_LeftButtonDown
      If IsImage(imgLayers(zoomlevel)) And IsImage(imgBackgrounds(zoomlevel))
        If Not curveactive
          If startpoint\x=0 And startpoint\y=0
            If newcurve
              startpoint\x = GetGadgetAttribute(canvas, #PB_Canvas_MouseX)
              startpoint\y = GetGadgetAttribute(canvas, #PB_Canvas_MouseY)
              oldstartpoint\x=startpoint\x
              oldstartpoint\y=startpoint\y
              StartVectorDrawing(ImageVectorOutput(imgLayers(zoomlevel)))
                VectorSourceColor(RGBA(250,0,0,255))
                AddPathCircle(startpoint\x,startpoint\y,4)
                FillPath()
              StopVectorDrawing()
              UpdateCanvas()
            Else
              If ListSize(curves())
                LastElement(curves())
                startpoint\x=curves()\endpoint\x
                startpoint\y=curves()\endpoint\y
                oldstartpoint\x=startpoint\x
                oldstartpoint\y=startpoint\y
              EndIf
              endpoint\x = GetGadgetAttribute(canvas, #PB_Canvas_MouseX)
              endpoint\y = GetGadgetAttribute(canvas, #PB_Canvas_MouseY)
              oldendpoint\x=endpoint\x
              oldendpoint\y=endpoint\y
              With firstpoint
                \x=startpoint\x + (endpoint\x-startpoint\x)/3
                \y=startpoint\y + (endpoint\y-startpoint\y)/3
              EndWith
              With secondpoint
                \x=startpoint\x + ((endpoint\x-startpoint\x)/3)*2
                \y=startpoint\y + ((endpoint\y-startpoint\y)/3)*2
              EndWith
              oldfirstpoint=firstpoint
              oldsecondpoint=secondpoint
              curveactive=1
              RedrawCurves()
              DisableGadget(button_commit, 0)
            EndIf
          ElseIf endpoint\x=0 And endpoint\y=0
            endpoint\x = GetGadgetAttribute(canvas, #PB_Canvas_MouseX)
            endpoint\y = GetGadgetAttribute(canvas, #PB_Canvas_MouseY)
            oldendpoint\x=endpoint\x
            oldendpoint\y=endpoint\y
            With firstpoint
              \x=startpoint\x + (endpoint\x-startpoint\x)/3
              \y=startpoint\y + (endpoint\y-startpoint\y)/3
            EndWith
            With secondpoint
              \x=startpoint\x + ((endpoint\x-startpoint\x)/3)*2
              \y=startpoint\y + ((endpoint\y-startpoint\y)/3)*2
            EndWith
            oldfirstpoint=firstpoint
            oldsecondpoint=secondpoint
            curveactive=1
            RedrawCurves()
            DisableGadget(button_commit, 0)
          EndIf
        EndIf
      EndIf
      
    Case #PB_EventType_LeftButtonUp
      moveinprogress=0
      on1=0 : on2=0 : on3=0 : on4=0
      
    Case #PB_EventType_MouseMove
      If IsImage(imgLayers(zoomlevel)) And IsImage(imgBackgrounds(zoomlevel))
        cursorx = GetGadgetAttribute(canvas, #PB_Canvas_MouseX)
        cursory = GetGadgetAttribute(canvas, #PB_Canvas_MouseY)
        If Not moveinprogress
          StartDrawing(ImageOutput(imgLayers(zoomlevel)))
            Select Point(cursorx, cursory)
              Case RGB(250,0,0)
                on1=1 : on2=0 : on3=0 : on4=0
              Case RGB(248,0,0)
                on2=1 : on1=0 : on3=0 : on4=0
              Case RGB(246,0,0)
                on3=1 : on1=0 : on2=0 : on4=0
              Case RGB(244,0,0)
                on4=1 : on1=0 : on2=0 : on3=0
              Default
                on1=0 : on2=0 : on3=0 : on4=0
            EndSelect
          StopDrawing()
        EndIf
        
        If GetGadgetAttribute(EventGadget(),#PB_Canvas_Buttons) & #PB_Canvas_LeftButton
          If curveactive
            moveinprogress=1
            If on1
              startpoint\x=cursorx : startpoint\y=cursory
              oldstartpoint=startpoint
              RedrawCurves()
            ElseIf on2
              firstpoint\x=cursorx : firstpoint\y=cursory
              oldfirstpoint=firstpoint
              RedrawCurves()
            ElseIf on3
              secondpoint\x=cursorx : secondpoint\y=cursory
              oldsecondpoint=secondpoint
              RedrawCurves()
            ElseIf on4
              endpoint\x=cursorx : endpoint\y=cursory
              oldendpoint=endpoint
              RedrawCurves()
            EndIf
          EndIf
        Else
          moveinprogress=0
        EndIf
      EndIf
  EndSelect
  
EndProcedure

Procedure NewImageButtonHandler()
  Protected file$, ext$
  file$ = OpenFileRequester("Select an image","", "Image |*.jpg;*.png;*.bmp",0)
  If file$
    ext$ = GetExtensionPart(file$)
    Select LCase(ext$)
      Case "png"
        UsePNGImageDecoder()
      Case "jpg"
        UseJPEGImageDecoder()
    EndSelect
    FreeImage(imgOriginalBackground)
    imgOriginalBackground = LoadImage(#PB_Any,file$)
    If IsImage(imgOriginalBackground) = 0
      imgOriginalBackground=CreateImage(#PB_Any, max_viewport,max_viewport,24)
    EndIf
  EndIf
  InitializeCanvas()
  SetGadgetState(gadget_zoom,0)
  If GetGadgetAttribute(gadget_zoom, #PB_Button_Image) = ImageID(imgZoomed)
    SetGadgetAttribute(gadget_zoom, #PB_Button_Image, ImageID(imgZoomNormal))
  EndIf
  zoomlevel=0
  HideGadget(gadget_zoom_viewport, 1)
  SetGadgetAttribute(ccontainer,#PB_ScrollArea_InnerWidth,GadgetWidth(canvas))
  SetGadgetAttribute(ccontainer,#PB_ScrollArea_InnerHeight,GadgetHeight(canvas))
  
  SetActiveGadget(canvas)
EndProcedure

Procedure CreateCursor()
  Protected.i color,mask
  color = CreateImage(#PB_Any, 32,32,32,#PB_Image_Transparent)
  
  StartVectorDrawing(ImageVectorOutput(color))
      AddPathCircle(15.5,15.5,2)
      AddPathCircle(15.5,15.5,15)
      MovePathCursor(15.5,13.5)
      AddPathLine(15.5,1.5)
      MovePathCursor(15.5,17.5)
      AddPathLine(15.5,30.5)
      MovePathCursor(13.5,15.5)
      AddPathLine(1.5,15.5)
      MovePathCursor(17.5,15.5)
      AddPathLine(30.5,15.5)
      VectorSourceColor(RGBA(255,0,0,255))
      StrokePath(1)
    StopVectorDrawing()
    
    
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Protected icoInf.ICONINFO
    
    mask  = CreateImage(#PB_Any, 32,32,32,#PB_Image_Transparent)
    
    StartVectorDrawing(ImageVectorOutput(mask))
      AddPathCircle(15.5,15.5,2)
      AddPathCircle(15.5,15.5,15)
      MovePathCursor(15.5,13.5)
      AddPathLine(15.5,1.5)
      MovePathCursor(15.5,17.5)
      AddPathLine(15.5,30.5)
      MovePathCursor(13.5,15.5)
      AddPathLine(1.5,15.5)
      MovePathCursor(17.5,15.5)
      AddPathLine(30.5,15.5)
      VectorSourceColor(RGBA(255,255,255,255))
      StrokePath(1)
    StopVectorDrawing()
    
    With icoInf.ICONINFO
      \fIcon = #False
      \xHotspot = 15
      \yHotspot = 15
      \hbmMask = ImageID(mask)
      \hbmColor = ImageID(color)
    EndWith
    
    ProcedureReturn CreateIconIndirect(icoInf)
    
  CompilerElseIf  #PB_Compiler_OS = #PB_OS_Linux
    
    Define *cursor.GdkCursor = gdk_cursor_new_from_pixbuf_(gdk_display_get_default_(), ImageID(color), 16, 16)
    
    ProcedureReturn *cursor
    
  CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
    
    Define hotSpot.NSPoint
    hotSpot\x = 16
    hotSpot\y = 16
    Define *cursor = CocoaMessage(0, 0, "NSCursor alloc")
    CocoaMessage(0, *cursor, "initWithImage:", ImageID(color), "hotSpot:@", @hotSpot)
    
    ProcedureReturn *cursor   
    
  CompilerEndIf
  
EndProcedure

Procedure UpdateCanvas()
  If IsImage(imgOutput)
    FreeImage(imgOutput)
  EndIf
  imgOutput = CopyImage(imgBackgrounds(zoomlevel),#PB_Any)
  StartVectorDrawing(ImageVectorOutput(imgOutput))
    MovePathCursor(0,0)
    DrawVectorImage(ImageID(imgLayers(zoomlevel)))
  StopVectorDrawing()
  SetGadgetAttribute(canvas, #PB_Canvas_Image, ImageID(imgOutput))
EndProcedure
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---------------
; EnableXP