; https://www.purebasic.fr/english/viewtopic.php?p=462626#p462626
; https://www.purebasic.fr/english/viewtopic.php?f=12&t=36345&hilit=CircleAA
ProcedureDLL.l ColorBlending(Couleur1.l, Couleur2.l, Echelle.f) ; Mélanger 2 couleurs 
  Protected Rouge, Vert, Bleu, Rouge2, Vert2, Bleu2 
  
  Rouge = Couleur1 & $FF 
  Vert = Couleur1 >> 8 & $FF 
  Bleu = Couleur1 >> 16 
  Rouge2 = Couleur2 & $FF 
  Vert2 = Couleur2 >> 8 & $FF 
  Bleu2 = Couleur2 >> 16 
  
  Rouge = Rouge * Echelle + Rouge2 * (1-Echelle) 
  Vert = Vert * Echelle + Vert2 * (1-Echelle) 
  Bleu = Bleu * Echelle + Bleu2 * (1-Echelle) 
  
  ProcedureReturn (Rouge | Vert <<8 | Bleu << 16) 
EndProcedure
; Auteur : Le Soldat Inconnu
; Version de PB : 4.3
;
; Explication du programme :
; Dessin avec lissage

Procedure CircleAA(X, Y, Radius, Color, Thickness = 1, Mode = #PB_2DDrawing_Default)
  Protected n, nn, Distance.f, Application.f, Couleur_Fond.l
  If Mode & #PB_2DDrawing_Outlined ; Cercle vide
    ; on dessine 1/4 du cercle et on duplique pour le reste
    For n = 0 To Radius
      For nn = 0 To Radius
        Distance.f = Sqr(n * n + nn * nn)
        If Distance <= Radius And Distance > Radius - 1
          Application.f = Abs(Radius - 1 - Distance)
          Couleur_Fond = Point(X + n, Y + nn)
          Plot(X + n, Y + nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X - n, Y + nn)
          Plot(X - n, Y + nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X + n, Y - nn)
          Plot(X + n, Y - nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X - n, Y - nn)
          Plot(X - n, Y - nn, ColorBlending(Couleur_Fond, Color, Application))
        ElseIf Distance <= Radius - Thickness And Distance > Radius - Thickness - 1
          Application.f = Abs(Radius - Thickness - Distance)
          Couleur_Fond = Point(X + n, Y + nn)
          Plot(X + n, Y + nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X - n, Y + nn)
          Plot(X - n, Y + nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X + n, Y - nn)
          Plot(X + n, Y - nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X - n, Y - nn)
          Plot(X - n, Y - nn, ColorBlending(Couleur_Fond, Color, Application))
        ElseIf Distance <= Radius - 1 And Distance > Radius - Thickness
          Plot(X + n, Y + nn, Color)
          Plot(X - n, Y + nn, Color)
          Plot(X + n, Y - nn, Color)
          Plot(X - n, Y - nn, Color)
        EndIf
      Next
    Next
  Else ; Cercle plein
    ; on dessine 1/4 du cercle et on duplique pour le reste
    For n = 0 To Radius
      For nn = 0 To Radius
        Distance.f = Sqr(n * n + nn * nn)
        If Distance <= Radius And Distance > Radius - 1
          Application.f = 1 - (Radius - Distance)
          Couleur_Fond = Point(X + n, Y + nn)
          Plot(X + n, Y + nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X - n, Y + nn)
          Plot(X - n, Y + nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X + n, Y - nn)
          Plot(X + n, Y - nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X - n, Y - nn)
          Plot(X - n, Y - nn, ColorBlending(Couleur_Fond, Color, Application))
        ElseIf Distance <= Radius - 1
          Plot(X + n, Y + nn, Color)
          Plot(X - n, Y + nn, Color)
          Plot(X + n, Y - nn, Color)
          Plot(X - n, Y - nn, Color)
        EndIf
      Next
    Next
  EndIf
EndProcedure

Procedure EllipseAA(X, Y, RadiusX, RadiusY, Color, Thickness = 1, Mode = #PB_2DDrawing_Default)
  Protected n, nn, Distance.f, Application.f, Couleur_Fond.l, Ellispse_Rayon.f, Ellipse_E.f
  ; Précacul de l'équation de l'ellipse
  If RadiusX > RadiusY
    Ellipse_E = Sqr(RadiusX * RadiusX - RadiusY * RadiusY) / RadiusX
  Else
    Ellipse_E = Sqr(RadiusY * RadiusY - RadiusX * RadiusX) / RadiusY
  EndIf
  Ellipse_E * Ellipse_E
  If Mode & #PB_2DDrawing_Outlined ; ellipse vide
    ; on dessine 1/4 de l'ellipse et on duplique pour le reste
    For n = 0 To RadiusX
      For nn = 0 To RadiusY 
        Distance.f = Sqr(n * n + nn * nn)
        If RadiusX > RadiusY
          If n
            Ellipse_CosAngle.f = n / Distance
            Ellispse_Rayon = Sqr(RadiusY * RadiusY / (1 - Ellipse_E * Ellipse_CosAngle * Ellipse_CosAngle))
          Else
            Ellispse_Rayon = RadiusY
          EndIf
        Else
          If nn
            Ellipse_CosAngle.f = nn / Distance
            Ellispse_Rayon = Sqr(RadiusX * RadiusX / (1 - Ellipse_E * Ellipse_CosAngle * Ellipse_CosAngle))
          Else
            Ellispse_Rayon = RadiusX
          EndIf
        EndIf
        If Distance <= Ellispse_Rayon And Distance > Ellispse_Rayon - 1
          Application.f = Abs(Ellispse_Rayon - 1 - Distance)
          Couleur_Fond = Point(X + n, Y + nn)
          Plot(X + n, Y + nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X - n, Y + nn)
          Plot(X - n, Y + nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X + n, Y - nn)
          Plot(X + n, Y - nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X - n, Y - nn)
          Plot(X - n, Y - nn, ColorBlending(Couleur_Fond, Color, Application))
        ElseIf Distance <= Ellispse_Rayon - Thickness And Distance > Ellispse_Rayon - Thickness - 1
          Application.f = Abs(Ellispse_Rayon - Thickness - Distance)
          Couleur_Fond = Point(X + n, Y + nn)
          Plot(X + n, Y + nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X - n, Y + nn)
          Plot(X - n, Y + nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X + n, Y - nn)
          Plot(X + n, Y - nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X - n, Y - nn)
          Plot(X - n, Y - nn, ColorBlending(Couleur_Fond, Color, Application))
        ElseIf Distance <= Ellispse_Rayon - 1 And Distance > Ellispse_Rayon - Thickness
          Plot(X + n, Y + nn, Color)
          Plot(X - n, Y + nn, Color)
          Plot(X + n, Y - nn, Color)
          Plot(X - n, Y - nn, Color)
        EndIf
      Next
    Next
  Else ; ellipse pleine
    ; on dessine 1/4 de l'ellipse et on duplique pour le reste
    For n = 0 To RadiusX
      For nn = 0 To RadiusY
        Distance.f = Sqr(n * n + nn * nn)
        If RadiusX > RadiusY
          If n
            Ellipse_CosAngle.f = n / Distance
            Ellispse_Rayon = Sqr(RadiusY * RadiusY / (1 - Ellipse_E * Ellipse_CosAngle * Ellipse_CosAngle))
          Else
            Ellispse_Rayon = RadiusY
          EndIf
        Else
          If nn
            Ellipse_CosAngle.f = nn / Distance
            Ellispse_Rayon = Sqr(RadiusX * RadiusX / (1 - Ellipse_E * Ellipse_CosAngle * Ellipse_CosAngle))
          Else
            Ellispse_Rayon = RadiusX
          EndIf
        EndIf
        If Distance <= Ellispse_Rayon And Distance > Ellispse_Rayon - 1
          Application.f = 1 - (Ellispse_Rayon - Distance)
          Couleur_Fond = Point(X + n, Y + nn)
          Plot(X + n, Y + nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X - n, Y + nn)
          Plot(X - n, Y + nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X + n, Y - nn)
          Plot(X + n, Y - nn, ColorBlending(Couleur_Fond, Color, Application))
          Couleur_Fond = Point(X - n, Y - nn)
          Plot(X - n, Y - nn, ColorBlending(Couleur_Fond, Color, Application))
        ElseIf Distance <= Ellispse_Rayon - 1
          Plot(X + n, Y + nn, Color)
          Plot(X - n, Y + nn, Color)
          Plot(X + n, Y - nn, Color)
          Plot(X - n, Y - nn, Color)
        EndIf
      Next
    Next
  EndIf
EndProcedure

Procedure LineAA(X, Y, Width, Hight, Color, Thickness = 1)
  Protected SensX, SensY, n, nn, Epaisseur.f, x2.f, y2.f, Couleur_Fond.l, Application.f, Distance.f
  ; On mets la droite toujours dans le même sens pour l'analyse
  ; La sauvegarde du sens permettra de dessiner la droite ensuite dans le bon sens
  If Width >= 0
    SensX = 1
  Else
    SensX = -1
    Width = - Width
  EndIf
  If Hight >= 0
    SensY = 1
  Else
    SensY = -1
    Hight = - Hight
  EndIf
  
  
  ; Demi épaisseur de la ligne
  Epaisseur.f = Thickness / 2
  
  ; calcul pour le changement de repère qui permet de connaitre l'épaisseur du trait et de gérer l'AA
  Distance.f = Sqr(Width * Width + Hight * Hight)
  CosAngle.f = Width / Distance
  ;SinAngle.f = -Sin(ACos(CosAngle))
  SinAngle.f= -Sqr(-CosAngle*CosAngle+1)
  
  ; Dessin de la ligne
  For n = -Thickness To Width + Thickness
    For nn = -Thickness To Hight + Thickness
      
      ; changement de base
      ; les y représentent l'épaisseur de la ligne
      x2 = n * CosAngle - nn * SinAngle
      y2 = Abs(n * SinAngle + nn * CosAngle)
      
      If y2 <= Epaisseur + 0.5
        Application =  0.5 + Epaisseur - y2
        If Application > 1
          Application = 1
        EndIf
        If x2 > -1 And x2 < Distance + 1
          If x2 < 0
            Application * (1 + x2)
          ElseIf x2 > Distance
            Application * (1 - x2 + Distance)
          EndIf
        Else
          Application = 0
        EndIf
        If Application > 0
          If Application < 1
            Couleur_Fond = Point(X + n * SensX, Y + nn * SensY)
            Plot(X + n * SensX, Y + nn * SensY, ColorBlending(Color, Couleur_Fond, Application))
          Else
            Plot(X + n * SensX, Y + nn * SensY, Color)
          EndIf
        EndIf
      EndIf
      
    Next
  Next
  
EndProcedure


Procedure TriangleAA(x1, y1, x2, y2, x3, y3, Color, Thickness = 1, Mode = #PB_2DDrawing_Default)
  Protected Epaisseur.f, Zone_G, Zone_D, Zone_H, Zone_B, Couleur_Fond, Application.f
  Protected Width12.l, Hight12.l, Distance12.f, CosAngle12.f, SinAngle12.f, Sens12.l, y1_r2.f, Application1.f, Interieur1
  Protected Width23.l, Hight23.l, Distance23.f, CosAngle23.f, SinAngle23.f, Sens23.l, y2_r2.f, Application2.f, Interieur2
  Protected Width31.l, Hight31.l, Distance31.f, CosAngle31.f, SinAngle31.f, Sens31.l, y3_r2.f, Application3.f, Interieur3
  
  ; Demi épaisseur de la ligne
  Epaisseur.f = Thickness / 2
  
  ; calcul pour le changement de repère qui permet de connaitre l'épaisseur du trait et de gérer l'AA
  ; Pour la ligne 12
  ; Le point de départ du repère est le point x1, y1
  Width12.l = x2 - x1
  Hight12.l = y2 - y1
  Distance12.f = Sqr(Width12 * Width12 + Hight12 * Hight12)
  CosAngle12.f = Width12 / Distance12
  ; SinAngle12.f = Sin(ACos(CosAngle12))
  SinAngle12.f=Sqr(-CosAngle12*CosAngle12+1)
  
  If Hight12 > 0
    SinAngle12 = -SinAngle12
  EndIf
  ; changement de base
  y3_r2 = (x3 - x1) * SinAngle12 + (y3 - y1) * CosAngle12
  ; on regarde de quel coté de la ligne se trouve le triangle en regardant la position du point 3
  If y3_r2 > 0
    Sens12 = 1
  Else
    Sens12 = -1
  EndIf
  ; Pour la ligne 23
  ; Le point de départ du repère est le point x2, y2
  Width23.l = x3 - x2
  Hight23.l = y3 - y2
  Distance23.f = Sqr(Width23 * Width23 + Hight23 * Hight23)
  CosAngle23.f = Width23 / Distance23
  ;SinAngle23.f = Sin(ACos(CosAngle23))
  SinAngle23.f=Sqr(-CosAngle23*CosAngle23+1)
  
  If Hight23 > 0
    SinAngle23 = -SinAngle23
  EndIf
  ; changement de base
  y1_r2 = (x1 - x2) * SinAngle23 + (y1 - y2) * CosAngle23
  ; on regarde de quel coté de la ligne se trouve le triangle en regardant la position du point 3
  If y1_r2 > 0
    Sens23 = 1
  Else
    Sens23 = -1
  EndIf
  ; Pour la ligne 31
  ; Le point de départ du repère est le point x3, y3
  Width31.l = x1 - x3
  Hight31.l = y1 - y3
  Distance31.f = Sqr(Width31 * Width31 + Hight31 * Hight31)
  CosAngle31.f = Width31 / Distance31
  ;SinAngle31.f = Sin(ACos(CosAngle31))
  SinAngle31.f = Sqr(-SinAngle31*SinAngle31+1)
  
  If Hight31 > 0
    SinAngle31 = -SinAngle31
  EndIf
  ; changement de base
  y2_r2 = (x2 - x3) * SinAngle31 + (y2 - y3) * CosAngle31
  ; on regarde de quel coté de la ligne se trouve le triangle en regardant la position du point 3
  If y2_r2 > 0
    Sens31 = 1
  Else
    Sens31 = -1
  EndIf
  
  ; Détermination de la zone de dessin
  Zone_G = x1
  Zone_D = x1
  Zone_B = y1
  Zone_H = y1
  If x2 < Zone_G
    Zone_G = x2
  EndIf
  If x3 < Zone_G
    Zone_G = x3
  EndIf
  If x2 > Zone_D
    Zone_D = x2
  EndIf
  If x3 > Zone_D
    Zone_D = x3
  EndIf
  If y2 < Zone_B
    Zone_B = y2
  EndIf
  If y3 < Zone_B
    Zone_B = y3
  EndIf
  If y2 > Zone_H
    Zone_H = y2
  EndIf
  If y3 > Zone_H
    Zone_H = y3
  EndIf
  Zone_B - Thickness
  Zone_H + Thickness
  Zone_G - Thickness
  Zone_D + Thickness
  
  ; Dessin du triangle
  If Mode & #PB_2DDrawing_Outlined ; Triangle vide
    For n = Zone_G To Zone_D
      For nn = Zone_B To Zone_H
        
        y1_r2 = (n - x1) * SinAngle12 + (nn - y1) * CosAngle12
        y1_r2 * Sens12
        If y1_r2 >= -0.5 - Epaisseur
          
          Application1.f = 0.5 + Epaisseur + y1_r2
          If Application1 > 1
            Application1 =  1 + 0.5 + Epaisseur - Application1
            If Application1 < 0
              Application1 = 0
            EndIf
            Interieur1 = 1
          Else
            Interieur1 = 0
          EndIf
          
          y2_r2 = (n - x2) * SinAngle23 + (nn - y2) * CosAngle23
          y2_r2 * Sens23
          If y2_r2 >= -0.5 - Epaisseur
            
            Application2.f = 0.5 + Epaisseur + y2_r2
            If Application2 > 1
              Application2 = 1 + 0.5 + Epaisseur - Application2
              If Application2 < 0
                Application2 = 0
              EndIf
              Interieur2 = 1
            Else 
              Interieur2 = 0
            EndIf
            
            y3_r2 = (n - x3) * SinAngle31 + (nn - y3) * CosAngle31
            y3_r2 * Sens31
            If y3_r2 >= -0.5 - Epaisseur
              
              Application3.f = 0.5 + Epaisseur + y3_r2
              If Application3 > 1
                Application3 = 1 + 0.5 + Epaisseur - Application3
                If Application3 < 0
                  Application3 = 0
                EndIf
                Interieur3 = 1
              Else
                Interieur3 = 0
              EndIf
              
              
              If Interieur1 And Interieur2 And Interieur3
                Application = Application1 + Application2 + Application3
              Else
                Application = 1
                If Interieur1 = 0
                  Application * Application1
                EndIf
                If Interieur2 = 0
                  Application * Application2
                EndIf
                If Interieur3 = 0
                  Application * Application3
                EndIf
              EndIf
              If Application > 0
                If Application < 1
                  Couleur_Fond = Point(n, nn)
                  Plot(n, nn, ColorBlending(Color, Couleur_Fond, Application))
                Else
                  Plot(n, nn, Color)
                EndIf
              EndIf
            
            EndIf
          EndIf
        EndIf
        
      Next
    Next
  Else ; Triangle plein
    For n = Zone_G To Zone_D
      For nn = Zone_B To Zone_H
        
        y1_r2 = (n - x1) * SinAngle12 + (nn - y1) * CosAngle12
        y1_r2 * Sens12
        If y1_r2 >= -0.5 - Epaisseur
          
          Application1.f = 0.5 + Epaisseur + y1_r2
          If Application1 > 1
            Application1 = 1
          EndIf
          
          y2_r2 = (n - x2) * SinAngle23 + (nn - y2) * CosAngle23
          y2_r2 * Sens23
          If y2_r2 >= -0.5 - Epaisseur
            
            Application2.f = 0.5 + Epaisseur + y2_r2
            If Application2 > 1
              Application2 = 1
            EndIf
            
            y3_r2 = (n - x3) * SinAngle31 + (nn - y3) * CosAngle31
            y3_r2 * Sens31
            If y3_r2 >= -0.5 - Epaisseur
              
              Application3.f = 0.5 + Epaisseur + y3_r2
              If Application3 > 1
                Application3 = 1
              EndIf
              
              Application = Application1 * Application2 * Application3
              If Application < 1
                Couleur_Fond = Point(n, nn)
                Plot(n, nn, ColorBlending(Color, Couleur_Fond, Application))
              Else
                Plot(n, nn, Color)
              EndIf
              
            EndIf
          EndIf
        EndIf
        
      Next
    Next
  EndIf
  
EndProcedure





;/ Test des fonctions de dessin avec Anti-Aliazing ( AA )
; Création de la fenêtre et de la GadgetList
If OpenWindow(0, 0, 0, 500, 500, "Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget) = 0 
  End
EndIf

CreateImage(0, 500, 500)
StartDrawing(ImageOutput(0))
  ; Un joli fond
  #Carreau = 25
  For n = 0 To 500 Step #Carreau
    For nn = 0 To 500 Step #Carreau
      If ((n + nn) / #Carreau) & %1 = %1
        Box(n, nn, #Carreau, #Carreau, $FFFFFF)
      Else
        Box(n, nn, #Carreau, #Carreau, $0000FF)
      EndIf
    Next
  Next
  
  ; Dessin de Cercle
  CircleAA(100, 100, 70, $000000)
  CircleAA(250, 100, 50, $000000, 1, #PB_2DDrawing_Outlined)
  CircleAA(250, 100, 70, $000000, 3, #PB_2DDrawing_Outlined)
  
  ; Dessin d'une ellipse
  EllipseAA(400, 100, 40, 60, $000000, 2, #PB_2DDrawing_Outlined)
  EllipseAA(400, 100, 50, 70, $000000, 1, #PB_2DDrawing_Outlined)
  EllipseAA(400, 100, 30, 20, $000000)
  
  
  
  ; Dessin de ligne
  For n = 0 To 150 Step 30
    LineAA(20, 200, 150, n, $000000)
  Next
  For n = 0 To 120 Step 30
    LineAA(20, 200, n, 150, $000000)
  Next
  Epaisseur = 2
  For n = 0 To 150 Step 30
    LineAA(200, 200, 150, n, $000000, Epaisseur)
    Epaisseur + 1
  Next
  Epaisseur = 2
  For n = 0 To 120 Step 30
    LineAA(200, 200, n, 150, $000000, Epaisseur)
    Epaisseur + 1
  Next
  
  ; dessin de triangles
  TriangleAA(420, 200, 480, 250, 370, 350, $000000)
  Epaisseur = 1
  For n = 0 To 30 Step 10
    TriangleAA(490 - n, 260 + n, 390 + n, 350, 460, 400 - n, $000000, Epaisseur, #PB_2DDrawing_Outlined)
    Epaisseur + 1
  Next
  
StopDrawing()

ImageGadget(0, 0, 0, 300, 300, ImageID(0))

Repeat
  Event = WaitWindowEvent()
  
  Select Event
    Case #PB_Event_Menu
      Select EventMenu() ; Menus
          
      EndSelect
      
    Case #PB_Event_Gadget
      Select EventGadget() ; Gadgets
          
      EndSelect
  EndSelect
  
Until Event = #PB_Event_CloseWindow

End
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 489
; FirstLine = 485
; Folding = ------------
; EnableXP