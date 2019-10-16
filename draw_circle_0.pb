Procedure AliasedCircle(x, y, Radius, ColorRGB, OutlineWidth=0, Smoothness.f=1)
  Protected Gradient.f
  Protected FillColor
  Protected Thin1px
 
  ;/ Invalid raidus or border
  If Radius =< 0 Or OutlineWidth < 0 Or Smoothness.f < 0
    ProcedureReturn
  EndIf
 
  If OutlineWidth=1 And Smoothness.f=0
    DrawingMode(#PB_2DDrawing_AllChannels|#PB_2DDrawing_Outlined)
    Circle(x,y,Radius-1,ColorRGB|$FF000000)
   
    ProcedureReturn
  EndIf
 
  If Smoothness.f<=0
     Smoothness.f=0.0001
  EndIf
 
  OutlineWidth>>1
 
  If OutlineWidth
    If OutlineWidth=1
      Thin1px=1
    Else
      OutlineWidth-1
    EndIf
  EndIf
 
  If OutlineWidth
    Radius + OutlineWidth >> 1
  EndIf
 
  If Thin1px
    Gradient.f = 1/Radius
  Else
    Gradient.f = 1/(Radius+Smoothness.f)
  EndIf
 
  FillColor = ColorRGB|$FF000000
 
  DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Gradient)
  ResetGradientColors()
  GradientColor(0, FillColor)
  
  If OutlineWidth
    GradientColor(0,ColorRGB)
    GradientColor(Gradient.f*(Radius-OutlineWidth-Smoothness.f), ColorRGB)
    GradientColor(Gradient.f*(Radius-OutlineWidth), FillColor)
  EndIf
 
  GradientColor(Gradient.f*Radius, FillColor)
  GradientColor(1, ColorRGB)
  
;  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
;   BackColor($FFB775&$FFFFFF|255<<24) 
;         FrontColor($F67905&$FFFFFF|255<<24)
  CircularGradient(x,y, Radius)
  
 Circle(x,y, Radius)
EndProcedure

OpenWindow(0,10,10,320,240,"")

Trackbar1=TrackBarGadget(#PB_Any,150,20,150,30,0,20)
SetGadgetState(Trackbar1,10)
TextGadget(#PB_Any,158,55,150,30,"Outline")

Trackbar2=TrackBarGadget(#PB_Any,150,80,150,30,0,100)
SetGadgetState(Trackbar2,50)
TextGadget(#PB_Any,158,115,150,30,"Radius")

Min=0
Max=10000

Trackbar3=TrackBarGadget(#PB_Any,150,140,150,30,0,10000)
SetGadgetState(Trackbar3,0.1*Max)
TextGadget(#PB_Any,158,175,150,30,"Smoothness")

Image=CreateImage(#PB_Any,130,240,32)

Outline=GetGadgetState(Trackbar1)
Radius=GetGadgetState(Trackbar2)
Smoothness.f=0*1.0/Max;GetGadgetState(Trackbar3)*1.0/Max

StartDrawing(ImageOutput(Image))
DrawingMode(#PB_2DDrawing_AlphaChannel)
Box(0,0,320,240,RGBA(0,0,0,0))
DrawingMode(#PB_2DDrawing_AllChannels)
;AliasedCircle(70,50,7,RGB(0,0,255),1,2)
;AliasedCircle(70,50,7,RGB(0,0,255),2,0.333)
AliasedCircle(70,50,3,RGB(0,0,255),20,3)
AliasedCircle(70,50,3,RGB(0,255,0),20,5)

AliasedCircle(70,70,3,RGB(0,255,0),20,3)
AliasedCircle(70,70,7,RGB(0,0,255),2,0.305)

AliasedCircle(70,90,8,RGB(0,255,0),1,2)
AliasedCircle(70,90,8,RGB(0,0,255),1,0)
AliasedCircle(70,90,6,RGB(255,0,0),2,0.66)


        
AliasedCircle(70,110,8,RGB(255,255,255),1,2)
; AliasedCircle(70,110,2,RGB(0,0,255),8,20)
AliasedCircle(70,110,8,RGB(0,0,255),1,0)
AliasedCircle(70,110,3,RGB(255,255,255),1,1.7730000019)
;AliasedCircle(70,110,Radius,RGB(255,0,0),Outline,Smoothness.f)

y=130
Radius = 8
Outline = 4
Smoothness = 1.2
AliasedCircle(70,y,Radius-1,$F67905&$FFFFFF|255<<24,Outline,Smoothness.f)
;AliasedCircle(70,y,8,RGB(0,0,255),1,0)
        AliasedCircle(70,y,Radius-2,RGB(255,255,255),4,Smoothness.f)
        ;AliasedCircle(70,y,Radius-8,RGB(255,255,255),Outline,Smoothness.f)
        
        
        y=150
Radius = 8
Outline = 4
Smoothness = 1.2
AliasedCircle(70,y,Radius-1,$F67905&$FFFFFF|255<<24,Outline,Smoothness.f)
;AliasedCircle(70,y,8,RGB(0,0,255),1,0)
        AliasedCircle(70,y,Radius-3,RGB(255,255,255),6,Smoothness.f)
        ;AliasedCircle(70,y,Radius-8,RGB(255,255,255),Outline,Smoothness.f)
        
        y=170
Radius = 8
Outline = 4
Smoothness = 1.2
AliasedCircle(70,y,Radius-1,$F67905&$FFFFFF|255<<24,Outline,Smoothness.f)
;AliasedCircle(70,y,8,RGB(0,0,255),1,0)
        AliasedCircle(70,y,Radius-2,RGB(255,255,255),6,Smoothness.f)
        ;AliasedCircle(70,y,Radius-8,RGB(255,255,255),Outline,Smoothness.f)

y=190
Radius = 8
Outline = 4
Smoothness = 1.2
AliasedCircle(70,y,Radius-1,$F67905&$FFFFFF|255<<24,Outline,Smoothness.f)
;AliasedCircle(70,y,8,RGB(0,0,255),1,0)
        AliasedCircle(70,y,Radius-2,RGB(255,255,255),8,Smoothness.f)
        ;AliasedCircle(70,y,Radius-8,RGB(255,255,255),Outline,Smoothness.f)

y=210
Radius = 8
Outline = 4
Smoothness = 1.2
AliasedCircle(70,y,Radius-1,$F67905&$FFFFFF|255<<24,Outline,Smoothness.f)
;AliasedCircle(70,y,8,RGB(0,0,255),1,0)
        AliasedCircle(70,y,Radius-3,RGB(255,255,255),10,Smoothness.f)
        ;AliasedCircle(70,y,Radius-8,RGB(255,255,255),Outline,Smoothness.f)



StopDrawing()

GadgetImage=ImageGadget(#PB_Any,0,0,32,32,ImageID(Image))

Repeat
  Event=WaitWindowEvent(1)
   
   Select Event
   Case #PB_Event_Gadget
     Select EventGadget()
       Case Trackbar1, Trackbar2, Trackbar3
       
        Outline=GetGadgetState(Trackbar1)
        Radius=GetGadgetState(Trackbar2)
        Smoothness.f=GetGadgetState(Trackbar3)*1.0/Max*2
        
        SetWindowTitle(0, Str(Radius)+" "+Str(Outline)+" "+StrF(Smoothness))
        
        StartDrawing(ImageOutput(Image))
        DrawingMode(#PB_2DDrawing_AlphaChannel)
        Box(0,0,320,240,RGBA(0,0,0,0))
        DrawingMode(#PB_2DDrawing_AllChannels)
        AliasedCircle(70,70,Radius,RGB(255,0,0),Outline,Smoothness.f)
        AliasedCircle(70,70,Radius-10,RGB(0,255,0),Outline,Smoothness.f)
        AliasedCircle(70,70,Radius-30,RGB(0,0,255),Outline,Smoothness.f)
        StopDrawing()
       
        SetGadgetState(GadgetImage,ImageID(Image))
     EndSelect
   EndSelect
Until Event=#PB_Event_CloseWindow

; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP