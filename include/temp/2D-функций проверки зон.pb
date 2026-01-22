;2d Zone checks against point with structured pointers to avoid parameter hell
;Written by miso 2026.01.19, with 6.30 beta 6 WinX64, [crossplatform]
;Policy: 777, do what you please, no credit required
;Upgrades/additions/extensions/fixes are welcomed in PB forum
; https://www.purebasic.fr/english/viewtopic.php?t=88210&sid=886bbf5973987b5680fc6bf78ca0fa2a

EnableExplicit
;================================
;-STRUCTURES
;================================

Structure point2dstructure
  X.f
  Y.f
EndStructure

Structure triangle2dstructure
  a.point2dstructure
  b.point2dstructure
  c.point2dstructure
EndStructure

Structure quad2dstructure
  a.point2dstructure
  b.point2dstructure
  c.point2dstructure
  d.point2dstructure
EndStructure

Structure circle2dstructure
  a.point2dstructure     ;CenterPoint A
  r.f                    ;Radius
EndStructure

Structure box2dstructure
  min.point2dstructure   ;TOP LEFT
  max.point2dstructure   ;BOTTOM RIGHT
EndStructure

;================================
;-PROCEDURES
;================================


;-================================
;-Angle, will be used for shape triangulation later
;-================================
Procedure.f Angle2dAtP1(*tri.triangle2dstructure)
  Protected.f v1X, v1Y, V2X, v2Y, dot, lenV1, lenV2, cosTheta.f, theta.f
  ; 1. Vectors from triangle point A
  With *tri
    v1X.f = \B\X - \A\X : v1Y.f = \B\Y - \A\Y : v2X.f = \C\X - \A\X : v2Y.f = \C\Y - \A\Y
  EndWith
  ; 2. Scalar
  dot.f = v1X * v2X + v1Y * v2Y
  ; 3. Vector lengths
  lenV1.f = Sqr(v1X*v1X + v1Y*v1Y) : lenV2.f = Sqr(v2X*v2X + v2Y*v2Y)
  ; 4. Computing cos
  If lenV1 = 0 Or lenV2 = 0 : ProcedureReturn 0 : EndIf ; Avoid division zero
  cosTheta.f = dot / (lenV1 * lenV2)
  ; 5. Safety
  If cosTheta > 1.0 : cosTheta = 1.0 : ElseIf cosTheta < -1.0 : cosTheta = -1.0 : EndIf
  ; 6. Computing angle and convert from radian
  theta.f = ACos(cosTheta) * (180.0 / #PI)
  ProcedureReturn theta
EndProcedure

;-================================
;-Point Against a Triangle
;-================================
Procedure.i Point2dInTriangle(*p.point2dstructure, *tri.triangle2dstructure)
  Protected d1.f, d2.f, d3.f, has_neg.i, has_pos.i
  ; Cross products
  d1.f = (*p\x - *tri\B\x)*(*tri\a\y - *tri\B\y) - (*tri\A\X - *tri\B\x)*(*p\y - *tri\B\y)
  d2.f = (*p\x - *tri\C\x)*(*tri\B\Y - *tri\C\Y) - (*tri\B\X - *tri\C\x)*(*p\y - *tri\C\Y)
  d3.f = (*p\x - *tri\a\x)*(*tri\C\Y - *tri\A\Y) - (*tri\C\X - *tri\A\X)*(*p\y - *tri\A\Y)
  ; Logic variables
  has_neg.i = 0 : has_pos.i = 0
  If d1 < 0.0 Or d2 < 0.0 Or d3 < 0.0 : has_neg = 1 : EndIf
  If d1 > 0.0 Or d2 > 0.0 Or d3 > 0.0 : has_pos = 1 : EndIf
  ;Result
  If has_neg And has_pos : ProcedureReturn #False : EndIf ; Point is outside
  ProcedureReturn #True                                   ; Point is inside or on line
EndProcedure

;-================================
;-Point against a Circle
;-================================
Procedure.i Point2dInCircle(*p.point2dstructure, *c.circle2dstructure)
  Protected dx.f, dy.f, dist2.f, radius2.f
  dx.f = *p\x - *c\a\x    : dy.f = *p\y - *c\a\y
  dist2.f = dx*dx + dy*dy : radius2.f = *c\r * *c\r
  If dist2 <= radius2 : ProcedureReturn #True : EndIf  ; Point is inside or on edge of circle
  ProcedureReturn #False                               ; Point outside
EndProcedure

;-================================
;-Point against an aligned Box
;-================================
Procedure.i Point2dInBox(*p.point2dstructure, *b.box2dstructure)
  If *p\x >= *b\min\X And *p\x <= *b\max\X And *p\y >= *b\min\Y And *p\y <= *b\max\Y : ProcedureReturn #True : EndIf
  ProcedureReturn #False
EndProcedure

;-================================
;-Point against custom quad
;-================================
Procedure.i Point2dInQuad(*p.point2dstructure, *q.quad2dstructure)
Protected d1.f, d2.f, d3.f, d4.f, has_neg.i, has_pos.i
  d1.f = (*p\X - *q\A\X)*(*q\B\Y - *q\A\Y) - (*q\B\X - *q\A\X) * (*p\Y - *q\A\Y)
  d2.f = (*p\X - *q\B\X)*(*q\C\Y - *q\B\Y) - (*q\C\X - *q\B\X) * (*p\Y - *q\B\Y)
  d3.f = (*p\X - *q\C\X)*(*q\D\Y - *q\C\Y) - (*q\D\X - *q\C\X) * (*p\Y - *q\C\Y)
  d4.f = (*p\X - *q\D\X)*(*q\A\Y - *q\D\Y) - (*q\A\X - *q\D\X) * (*p\Y - *q\D\Y)
  If d1 < 0.0 Or d2 < 0.0 Or d3 < 0.0 Or d4 < 0.0 : has_neg = 1 : EndIf
  If d1 > 0.0 Or d2 > 0.0 Or d3 > 0.0 Or d4 > 0.0 : has_pos = 1 : EndIf
  If has_neg And has_pos :ProcedureReturn #False : EndIf
  ProcedureReturn #True  ; 
EndProcedure

;-================================
;-EXAMPLE USAGE
;-================================


;A Triangle
Define t.triangle2dstructure
t\a\x=100 : t\a\y=100
t\b\x=500 : t\b\y=100
t\c\x=200 : t\c\y=200

;A circle
Define c.circle2dstructure
c\a\x = 800
c\a\y = 400
c\r   = 150

;A box
Define b.box2dstructure
b\min\x = 400
b\min\y = 200
b\max\x = 780
b\max\y = 280

;A quad
Define q.quad2dstructure
q\A\X = 500
q\A\Y = 500
q\B\X = 750
q\B\Y = 505
q\C\X = 600
q\C\Y = 550
q\D\X = 500
q\D\Y = 545

;Text display module
DeclareModule petskii
EnableExplicit
;=======================================================================
;system font
;=======================================================================
  Declare LoadSyStemFont()
  Declare Text(X,Y,Text.s,color.i,intensity.i=255)
  Declare centertext(X,Y,Text.s,color.i,intensity.i=255)
  Declare FreeSyStemFont()
EndDeclareModule

;--MODULES, AUXILIARY
Module petskii
;======================================================
;System fonts  for displaying system messages on screen
;======================================================
  #USED_CHARACTERS="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+[{]};:',<.>/?"+Chr(34)
  Global Dim font(370):Global Dim fontimport.i(370)
  
  Procedure LoadSyStemFont()
    Protected X.i,i.i,j.i,sprline.a
    For i = 1 To Len(#USED_CHARACTERS):fontImport(Asc(Mid(#USED_CHARACTERS,i,1)))=1 : Next i 
    Restore sysfont
      For X= 1 To 370
        If fontimport(X)=1
          font(X)=CreateSprite(-1,8,12,#PB_Sprite_AlphaBlending)
          StartDrawing(SpriteOutput(font(X)))
          DrawingMode(#PB_2DDrawing_AllChannels)
          For j=0 To 11  
            Read.a sprline 
            For i=0 To 7
              If sprline&%1 :Plot(i,j,RGBA(255,255,255,255)): Else : Plot(i,j,RGBA(0,0,0,0)) : EndIf
              sprline>>1 
            Next i
          Next j
          StopDrawing()
          ZoomSprite(font(X),16,24)
        EndIf
      Next X
  EndProcedure
   
  Procedure Text(X,Y,Text.s,color.i,intensity.i=255) : Protected.i textlength,i,character
    textlength.i = Len(Text.s)
    For i = 1 To textlength.i
      character.i = Asc(Mid(Text.s,i,1))
      If character.i>ArraySize(font()) : ProcedureReturn #Null : EndIf
      If IsSprite(font(character))
        DisplayTransparentSprite(font(character),(X+((i-1) * 16)),(Y),intensity,color.i)
      EndIf
    Next i
  EndProcedure
  
  Procedure centertext(X,Y,Text.s,color.i,intensity=255)
    Protected textlength.i
    textlength.i = Len(Text.s)
    X=X-(textlength*8) : Y=Y-8
    Text(X,Y,Text.s,color,intensity)
  EndProcedure
  
 
  Procedure FreeSyStemFont()
    Protected i.i
    For i = 1 To Len(#USED_CHARACTERS)
      If IsSprite(font(i)) : FreeSprite(font(i)) : EndIf
    Next i
  EndProcedure
 DataSection
    sysfont:
    Data.q $3838383838380000,$EEEE000000003800,$00000000000000EE,$FFEEFFEEEEEE0000,$383800000000EEEE,$0000387EE07C0EFC,$1C3870EECECE0000,$7C7C00000000E6EE,$0000FCEEEE3C7CEE
    Data.q $00003870E0E00000,$7070000000000000,$000070381C1C1C38,$707070381C1C0000,$0000000000001C38,$000000EE7CFF7CEE,$38FE383800000000,$0000000000000038,$001C383800000000
    Data.q $00FE000000000000,$0000000000000000,$0000383800000000,$3870E0C000000000,$7C7C000000000E1C,$00007CEEEEFEFEEE,$38383C3838380000,$7C7C00000000FE38,$0000FE0E1C70E0EE
    Data.q $E078E0EE7C7C0000,$E0E0000000007CEE,$0000E0E0FEEEF8F0,$E0E07E0EFEFE0000,$7C7C000000007CEE,$00007CEEEE7E0EEE,$383870EEFEFE0000,$7C7C000000003838,$00007CEEEE7CEEEE
    Data.q $E0FCEEEE7C7C0000,$3838000000007CEE,$0000383800000038,$0000003838380000,$F0F00000001C3838,$0000F0381C0E1C38,$FE00FE0000000000,$1E1E000000000000,$00001E3870E07038
    Data.q $3870E0EE7C7C0000,$7C7C000000003800,$00007CCE0EFEFEEE,$EEFEEE7C38380000,$7E7E00000000EEEE,$00007EEEEE7EEEEE,$0E0E0EEE7C7C0000,$3E3E000000007CEE,$00003E7EEEEEEE7E
    Data.q $0E3E0E0EFEFE0000,$FEFE00000000FE0E,$00000E0E0E3E0E0E,$EEFE0EEE7C7C0000,$EEEE000000007CEE,$0000EEEEEEFEEEEE,$383838387C7C0000,$F8F8000000007C38,$00003C7E70707070
    Data.q $3E1E3E7EEEEE0000,$0E0E00000000EE7E,$0000FE0E0E0E0E0E,$CEFEFEFECECE0000,$EEEE00000000CECE,$0000EEEEFEFEFEFE,$EEEEEEEE7C7C0000,$7E7E000000007CEE,$00000E0E0E7EEEEE
    Data.q $EEEEEEEE7C7C0000,$7E7E00000000F07C,$0000EE7E3E7EEEEE,$E07C0EEE7C7C0000,$FEFE000000007CEE,$0000383838383838,$EEEEEEEEEEEE0000,$EEEE000000007CEE,$0000387CEEEEEEEE
    Data.q $FEFECECECECE0000,$EEEE00000000CEFE,$0000EEEE7C387CEE,$387CEEEEEEEE0000,$FEFE000000003838,$0000FE0E1C3870E0,$1C1C1C1C7C7C0000,$7C7C000000007C1C,$00007C7070707070
    Data.q $3838FE7C38380000,$0000000000003838,$0000FF0000000000,$FCE07C0000000000,$000000000000FCEE,$00007EEEEE7E0E0E,$0E0E7C0000000000,$0000000000007C0E,$0000FCEEEEFCE0E0
    Data.q $FEEE7C0000000000,$0000000000007C0E,$0000383838FC38F0,$EEEEFC0000000000,$0E0E0000007EE0FC,$0000EEEEEEEE7E0E,$38383C0038380000,$0000000000007C38,$003C707070700070
    Data.q $3E7E0E0E0E0E0000,$3C3C00000000EE7E,$00007C3838383838,$FEFEEE0000000000,$000000000000CEFE,$0000EEEEEEEE7E00,$EEEE7C0000000000,$0000000000007CEE,$000E0E7EEEEE7E00
    Data.q $EEEEFC0000000000,$0000000000E0E0FC,$00000E0E0EEE7E00,$7C0EFC0000000000,$0000000000007EE0,$0000F0383838FE38,$EEEEEE0000000000,$000000000000FCEE,$0000387CEEEEEE00
    Data.q $FEFECE0000000000,$000000000000FCFC,$0000EE7C387CEE00,$EEEEEE0000000000,$00000000003E70FC,$0000FE1C3870FE00,$381E3838F0F00000,$1E1E00000000F038,$00001E3838F03838
  EndDataSection
EndModule 

;-EXAMPLE BEGINS
Global screenspr.i, mousesprite.i
InitSprite():InitKeyboard():InitMouse()

ExamineDesktops()
OpenWindow(0, 0,0, DesktopWidth(0)*0.98,DesktopHeight(0)*0.98, "Test",#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0), 0, 0, WindowWidth(0), WindowHeight(0), 0, 0, 0)
petskii::LoadSyStemFont()

screenspr = CreateSprite(#PB_Any,ScreenWidth(),ScreenHeight(),#PB_Sprite_AlphaBlending)

StartDrawing(SpriteOutput(screenspr))
;draw triangle
LineXY(t\a\x,t\a\y, t\b\x,t\b\y)
LineXY(t\c\x,t\c\y, t\b\x,t\b\y)
LineXY(t\a\x,t\a\y, t\c\x,t\c\y)
;draw box
LineXY(b\min\x,b\min\y, b\max\x,b\min\y)
LineXY(b\min\x,b\max\y, b\max\x,b\max\y)
LineXY(b\min\x,b\min\y, b\min\x,b\max\y)
LineXY(b\max\x,b\min\y, b\max\x,b\max\y)

;draw circle
DrawingMode(#PB_2DDrawing_Outlined)
Circle(c\a\x,c\a\y,c\r)

;draw quad
LineXY(q\a\x,q\a\y, q\b\x,q\b\y)
LineXY(q\c\x,q\c\y, q\b\x,q\b\y)
LineXY(q\d\x,q\d\y, q\c\x,q\c\y)
LineXY(q\d\x,q\d\y, q\a\x,q\a\y)
StopDrawing()

mousesprite =  CreateSprite(#PB_Any,3,3,#PB_Sprite_AlphaBlending)
StartDrawing(SpriteOutput(mousesprite))
Box(0,0,3,3)
StopDrawing()

Global  mouseposition.point2dstructure

Repeat
  While WindowEvent():Wend
  ClearScreen(0)
	ExamineKeyboard()
	ExamineMouse()
	MouseDeltaX()
	mouseposition\x = MouseX()
	mouseposition\y = MouseY()
	
	DisplayTransparentSprite(screenspr,0,0)
	DisplayTransparentSprite(mousesprite,mouseposition\x,mouseposition\y)
	
	If Point2dInBox(@mouseposition,@b)
	  petskii::Text(mouseposition\x,mouseposition\y,"Mouse Inside the Box",$00AA00)
  EndIf
	
	If Point2dIntriangle(@mouseposition,@t)
	  petskii::Text(mouseposition\x,mouseposition\y+30,"Mouse Inside the triangle",$00AA00)
  EndIf

	If Point2dIncircle(@mouseposition,@c)
	  petskii::Text(mouseposition\x,mouseposition\y+60,"Mouse Inside the circle",$00AA00)
	EndIf
	
  If Point2dInQuad(@mouseposition,@q)
	  petskii::Text(mouseposition\x,mouseposition\y+90,"Mouse Inside the quad",$00AA00)
  EndIf
	
	FlipBuffers() : Delay(0)
Until KeyboardReleased(#PB_Key_Escape) Or MouseButton(3)
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 5
; Folding = -------
; EnableXP
; DPIAware