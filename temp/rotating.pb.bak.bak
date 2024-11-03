; https://www.purebasic.fr/english/viewtopic.php?f=12&t=46830&p=356160&hilit=canvas+gadget#p356160
;Rotating cylinders on CanvasGadget
;by einander - PureBasic 4.60 Beta 3
EnableExplicit
;
Structure VXL
  RGBA.I[3]
  Dep.F  ;depth
  Per.F  ;perspective
EndStructure
;
Structure XYZF : X.F :Y.F :Z.F : EndStructure
;
Structure PointD  :  X.D  : Y.D  : EndStructure
Global _VXL.VXL
Global _Canvas,_Drawing
Global _XCenter,_YCenter
Global _LayX=1,_LayY=0,_LayZ=0
Global _Zoom,_Depth,_Perspective           
Global.D _CosX,_CosY,_SinX,_SinY,_CosZ,_SinZ,_Radius=2,_Density=2000
Global.XYZF  Dim _VertIndex(11),_Ang
;
Define Ev,Wi,He,X,Y,FlagDraw,I,Gad 
Define TBZoom,InfoZoom,TBDepth,InfoDepth,TBPerspective,InfoPerspective ; trackBars
Define TBX,InfoTBX,TBY,InfoTBY,TBZ,InfoTBZ
Define ChkBX,ChkBY,ChkBZ  ; checkBoxes
Define BtnReset1,BtnReset2,BtnReset3,Int
Define TbRadius,TbDensity,TbAlpha,Alpha=80 
Define InfoDensity,InfoAlpha,InfoRadius
;
_VXL\RGBA[0]=RGBA($FF,$1E,$22,Alpha)     ; x red
_VXL\RGBA[1]=RGBA(0  ,$Ff,0  ,Alpha)     ; y green
_VXL\RGBA[2]=RGBA($61,$B1,$Ff,Alpha)     ; z blue      
                                         ;
Macro GadgetBottom(Gad)  :  GadgetY(Gad)+GadgetHeight(Gad)  : EndMacro
;
Macro GadgetRight(Gad)  :  GadgetX(Gad)+GadgetWidth(Gad)  : EndMacro
;
Macro GadRGB(Gad,RGB1=#LBLUE,RGB2=#DBLUE)
  SetGadgetColor(Gad,1,RGB1)     
  SetGadgetColor(Gad,2,RGB2)   
EndMacro
;
Macro MMx  :  WindowMouseX(EventWindow())  : EndMacro
;
Macro MMy  :  WindowMouseY(EventWindow())  : EndMacro
;
Macro MMk
  Abs(GetAsyncKeyState_(#VK_LBUTTON) +GetAsyncKeyState_(#VK_RBUTTON)*2+GetAsyncKeyState_(#VK_MBUTTON)*3)/$8000   
EndMacro
;
Procedure VertData()
  With _VXL
    Protected I,A
    Restore VertexData
    ;_VertIndex =Postions for tHe 8 vertex of tHe invisible cube that contains thr cylinders
    For I=0 To 7
      Read.I A: _VertIndex(I)\X=A*\Per
      Read.I A: _VertIndex(I)\Y=A*\Per
      Read.I A: _VertIndex(I)\Z=A*\Per
    Next
  EndWith
EndProcedure
;
Macro SetAlpha(RGBa,Alpha)
  RGBA(Red(RGBa),Green(RGBa),Blue(RGBa),Alpha)
EndMacro
;
Macro GadStates()
  SetGadgetState(TBX,_Ang\X*1000)
  SetGadgetText(InfoTBX,"X "+StrF(_Ang\X,3))
  SetGadgetState(TBY,_Ang\Y*1000)
  SetGadgetText(InfoTBY,"Y "+StrF(_Ang\Y,3))
  SetGadgetState(TBZ,_Ang\Z*1000)
  SetGadgetText(InfoTBZ,"Z "+StrF(_Ang\Z,3))
  SetGadgetState(TBZoom,_Zoom)
  SetGadgetText(InfoZoom,"Zoom "+Str(_Zoom))
  SetGadgetState(TBDepth,_Depth)
  SetGadgetText(InfoDepth,"Depth "+StrF(_VXL\Dep,3))
  SetGadgetState(TBPerspective,_Perspective)
  SetGadgetText(InfoPerspective,"Perspective "+StrF(_VXL\Per,3))
EndMacro
;
Procedure RESET(RESET)
  Select RESET
    Case 1
      _Ang\X=1.5
      _Ang\Y=3.0
      _Ang\Z=1.5
      _Zoom=GadgetWidth(_Canvas)-(GadgetWidth(_Canvas)%12)
      _Depth=500
    Case 2
      _Ang\X=2.0
      _Ang\Y=3.0
      _Ang\Z=0.5
      _Zoom=GadgetWidth(_Canvas)-(GadgetWidth(_Canvas)%12)
      _Depth=500 
    Case 3
      _Ang\X=2.0
      _Ang\Y=3.0
      _Ang\Z=0.5
      _Zoom=96       
      _Depth=150
  EndSelect
  _CosX=Cos(_Ang\X)
  _CosY=Cos(_Ang\Y)
  _CosZ=Cos(_Ang\Z)
  _SinX=Sin(_Ang\X)
  _SinY=Sin(_Ang\Y)
  _SinZ=Sin(_Ang\Z)
  _VXL\Dep=_Depth/100
  _Perspective=100
  _VXL\Per=1
  VertData()   
EndProcedure 
;
Procedure GetVoxPos(X.F,Y.F,Z.F,*PD.PointD)
  ; Calculate voxel Position (From -1.0 to 1.0)
  Protected.F A = X * _CosZ - Y * _SinZ
  Protected.F B = X * _SinZ + Y * _CosZ
  Protected.F C = A * _SinY + Z * _CosY
  Protected.F D = (B * _SinX + C * _CosX)+_VXL\Dep
  *PD\X= _Zoom*(A * _CosY - Z * _SinY)/D
  *PD\Y= _Zoom*(B * _CosX - C * _SinX)/D
EndProcedure
;
Procedure DrawVox(X.F,Y.F,Z.F,RGBA,Rad=6)
  With _VXL
    Protected.PointD Pd
    GetVoxPos(X*\Per,Y*\Per,Z*\Per,@Pd.PointD)
    Circle(_XCenter+Pd\X,_YCenter+Pd\Y,Rad,RGBA)
  EndWith
EndProcedure
;
Procedure DrawCylinders()
  With _VXL
    Protected I,J,A,B,C.F,RGBA,Pd.PointD
    Protected D2.F=_Density/2
    If _Drawing:StopDrawing():EndIf
    _Drawing=StartDrawing(CanvasOutput(_Canvas))
    Box(0,0,GadgetWidth(_Canvas),GadgetHeight(_Canvas),0)
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    For I=0 To _Density-1 ;draw Voxels<<<<<<<<<<
      C=(I-D2)/_Density*2
      If _LayX : DrawVox(Cos(I),C,Sin(I),\RGBA[0],_Radius):EndIf
      If _LayY : DrawVox(C,Cos(I),Sin(I),\RGBA[1],_Radius):EndIf
      If _LayZ : DrawVox(Cos(I),Sin(I),C,\RGBA[2],_Radius):EndIf
    Next
    StopDrawing():_Drawing=0
  EndWith
EndProcedure
;
#White = $FFFFFF
Procedure InfoGad(Gad,Txt$="",FontRGB=#White,BkRGB=0)
  Protected TG=TextGadget(-1,GadgetX(Gad),Gadgetbottom(Gad),GadgetWidth(Gad),16,Txt$)
  GadRGB(Tg,FontRGB,BkRGB)
  ProcedureReturn Tg
EndProcedure
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
OpenWindow(0, 100, 100,700,500 ," Rotating Cylinders",  #PB_Window_ScreenCentered | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget |  #PB_Window_SizeGadget)
Wi=WindowWidth(0)
He=WindowHeight(0)

CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
  SetWindowColor(0,$303030)
CompilerEndIf

_Canvas=CanvasGadget(-1,0,0,He-80,He-80)
_XCenter=GadgetWidth(_Canvas)/2 : _YCenter=_XCenter
X=GadgetRight(_Canvas)+10
With _VXL
  TBZoom=TrackBarGadget(-1,X,50,300,24,10,1600)
  InfoZoom=InfoGad(TBZoom)
  TBDepth=TrackBarGadget(-1,X,GadgetBottom(InfoZoom)+10,300,24,10,1000)
  InfoDepth=InfoGad(TBDepth)
  TBPerspective=TrackBarGadget(-1,X,GadgetBottom(InfoDepth)+10,300,24,0,200)
  InfoPerspective=InfoGad(TBPerspective)
  TBX=TrackBarGadget(-1,X,GadgetBottom(InfoPerspective)+30,300,24,0,8000)
  InfoTBX=InfoGad(TBX)
  TBY=TrackBarGadget(-1,X,GadgetBottom(InfoTBX)+10,300,24,0,8000)
  InfoTBY=InfoGad(TBY)
  TBZ=TrackBarGadget(-1,X,GadgetBottom(InfoTBY)+10,300,24,0,8000)
  InfoTBZ=InfoGad(TBZ)
  BtnReset1=ButtonGadget(-1,X,GadgetBottom(InfoTBZ)+10,60,22,"Reset 1")           
  SetGadgetData(BtnReset1,1)
  BtnReset2=ButtonGadget(-1,GadgetRight(BtnReset1)+10,GadgetY(BtnReset1),60,22,"Reset 2")           
  SetGadgetData(BtnReset2,2)
  BtnReset3=ButtonGadget(-1,GadgetRight(BtnReset2)+10,GadgetY(BtnReset1),60,22,"Reset 3")           
  SetGadgetData(BtnReset3,3)
  ChkBX= CheckBoxGadget(-1, Gadgetright(Tbx)+10,GadgetY(Tbx), 16,16, "")
  ChkBY= CheckBoxGadget(-1, Gadgetright(TbY)+10,GadgetY(TbY), 16,16, "")
  ChkBZ= CheckBoxGadget(-1, Gadgetright(TbZ)+10,GadgetY(TbZ), 16,16, "")
  SetGadgetState(ChkBx,1) 
  TbAlpha=TrackBarGadget(-1,GadgetX(Btnreset1),Gadgetbottom(Btnreset1)+10,130,20,0,127)
  InfoAlpha=InfoGad(TbAlpha,"Alpha")
  TbRadius=TrackBarGadget(-1,GadgetX(TbAlpha),Gadgetbottom(InfoAlpha)+10,130,20,1,10)
  InfoRadius=InfoGad(TbRadius,"Radius")
  TbDensity=TrackBarGadget(-1,GadgetX(TbRadius),Gadgetbottom(InfoRadius)+10,130,20,1,10000)
  InfoDensity=InfoGad(TbDensity,"Density")
  SetGadgetState(TbAlpha,Alpha)
  SetGadgetState(TbRadius,_Radius)
  SetGadgetState(TbDensity,_Density)
  RESET(1)
  gadstates()
  Repeat
    ; If GetAsyncKeyState_(27)&$8000 :  End : EndIf
    Ev=WaitWindowEvent()
    If Ev=#PB_Event_Gadget
      Select EventGadget()
        Case TBX:_Ang\X=GetGadgetState(TBX)/1000: FlagDraw=1
          _CosX=Cos(_Ang\X)
          _SinX=Sin(_Ang\X)
          SetGadgetText(InfoTBX,"X "+StrF(_Ang\X,3))
        Case TBY:_Ang\Y=GetGadgetState(TBY)/1000:FlagDraw=1
          _CosY=Cos(_Ang\Y)
          _SinY=Sin(_Ang\Y)
          SetGadgetText(InfoTBY,"Y "+StrF(_Ang\Y,3))
        Case TBZ:_Ang\Z=GetGadgetState(TBZ)/1000:FlagDraw=1
          _CosZ=Cos(_Ang\Z)
          _SinZ=Sin(_Ang\Z)
          SetGadgetText(InfoTBZ,"Z "+StrF(_Ang\Z,3))
        Case TBZoom:_Zoom=GetGadgetState(TBZoom): FlagDraw=1
          SetGadgetText(InfoZoom,"Zoom "+Str(_Zoom))
        Case TBDepth:_Depth=GetGadgetState(TBDepth):FlagDraw=1
          \Dep=_Depth/100
          SetGadgetState(TBDepth,_Depth)
          SetGadgetText(InfoDepth,"Depth "+StrF(\Dep,3))
        Case TBPerspective:_Perspective=GetGadgetState(TBPerspective):FlagDraw=1
          \Per=_Perspective/100
          SetGadgetText(InfoPerspective,"Perspective "+StrF(\Per,3))
          VertData()     
        Case BtnReset1,BtnReset2,BtnReset3
          RESET(GetGadgetData(EventGadget()))
          GadStates()
          FlagDraw=1           
        Case ChkBx:_Layx=GetGadgetState(ChkBx) :FlagDraw=1
        Case ChkBy:_Layy=GetGadgetState(ChkBy) :FlagDraw=1
        Case ChkBz:_Layz=GetGadgetState(ChkBz) :FlagDraw=1
        Case TbAlpha
          Alpha=GetGadgetState(TbAlpha)
          _VXL\RGBA[0]=RGBA($FF,$1E,$22,Alpha)     ; x red
          _VXL\RGBA[1]=RGBA(0  ,$Ff,0  ,Alpha)     ; y green
          _VXL\RGBA[2]=RGBA($61,$B1,$Ff,Alpha)     ; z blue      
          Flagdraw=1
          SetGadgetText(InfoAlpha,"Alpha "+Str(Alpha))
        Case TbRadius:_Radius=GetGadgetState(TbRadius)  :FlagDraw=1 
          SetGadgetText(InfoRadius,"Radius "+Str(_Radius))   
        Case TbDensity:_Density=GetGadgetState(TbDensity)  :FlagDraw=1 
          SetGadgetText(InfoDensity,"Density "+Str(_Density))   
      EndSelect
    EndIf
    If FlagDraw Or Ev=#PB_Event_Repaint
      DrawCylinders()   
      FlagDraw=0
    EndIf
  Until Ev=#PB_Event_CloseWindow
EndWith
;
DataSection
  VertexData:     
  Data.I -1,-1,-1, 1,-1,-1 
  Data.I  1, 1,-1,-1, 1,-1 
  Data.I -1,-1, 1, 1,-1, 1 
  Data.I  1, 1, 1,-1, 1, 1 
EndDataSection
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -----
; EnableXP