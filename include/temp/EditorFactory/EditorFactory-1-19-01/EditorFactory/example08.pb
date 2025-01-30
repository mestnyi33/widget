; Рисовать на объектах с различными режимами, используя временный холст.
; В этом довольно сложном примере мы сможем рисовать на наших объектах, используя временный холст.
; Дважды щелкните объект, чтобы отобразить временный холст, нарисуйте его в нужном режиме, затем щелкните вне, чтобы подтвердить чертеж.

; Рисование на объектах с различными режимами с использованием временного холста.
; В этом довольно сложном примере мы собираемся рисовать на наших объектах, используя временный холст.
; Дважды щелкните объект, чтобы создать временный холст, нарисуйте его в нужном режиме, затем щелкните снаружи, чтобы подтвердить чертеж.
 
; Создано: 12.01.2025 г. Диппедаллем Дэвидом по прозвищу Тень.
; Создано: 12/01/2025 Дьеппедалем Дэвидом по псевдониму тень.

; Включает файл программы.
XIncludeFile "EditorFactory.pbi"

; Инициализирует модуль, чтобы иметь возможность его использовать.
UseModule EditorFactory

; ---------------------------------------------- Exemple: ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; Constantes du programme.
Enumeration 100
  #Window  ; La Fenêtre.
  #Canevas ; Le Canevas.
  #CanevasTemporaire ; Canevas temporaire qui servira à déssiner sur un Objets.
  #BoutonDessinMode1 ; Bouton gadget pour le mode de déssin rond.
  #BoutonDessinMode2 ; Bouton gadget pour le mode de déssin carré plein.
  #BoutonDessinMode3 ; Bouton gadget pour le mode de déssin carré vide avec bordure.
  #ImageCanevasTemporaire ; Image temporaire ou on va déssiner dessus.
EndEnumeration

; La numérotation des Objets commence à partir de 1 jusqu'à 65535.
Enumeration 1
  #Objet1 ; Objet n°1.
  #Objet2 ; Objet n°2.
  #Objet3 ; Objet n°3.
  #Objet4 ; Objet n°4.
EndEnumeration

; Numérotation des Images additionnel des Objets.
Enumeration 1
  #ImageObjet1 ; Images Objet n°1.
  #ImageObjet2 ; Images Objet n°2.
  #ImageObjet3 ; Images Objet n°3.
  #ImageObjet4 ; Images Objet n°4.
EndEnumeration

; Variable Global.

; Variable qui sert à savoir si le Canevas est actif ou non, si on est en train de déssiner sur un Objets.
Global CanevasTemporaireActif.b = #False

; Le numéro de l'Objet en train d'être déssiné.
Global ActiveObject.i = 0

; Le numéro du canevas ou s'est passé un évènement.
Global Canevas.i = 0

; Режим рисования, применяемый при рисовании объекта.
;- Режим 1: рисует произвольно окрашенные круги;
; - режим 2: рисует сплошной квадрат, произвольно окрашенный;
; - режим 3: рисует пустой квадрат со случайно окрашенными границами.

; Режим рисования, применяемый при рисовании объекта.
;- Режим 1: нарисуйте круги случайного цвета;
; - режим 2: Нарисуйте полный квадрат случайного цвета ;
; - режим 3: нарисуйте пустой квадрат с рамками случайного цвета.
Global ModeDessin.i = 1

; Прозрачность очерченных форм.
; Прозрачность форм, лишенных формы.
Global TransparenceRondPleins.i = 100
Global TransparenceCarrePleins.i = 125
Global TransparenceBordureCarreVide.i = 75

; Запоминает положение мыши, когда происходит щелчок левой кнопкой мыши, золото режима выбора > 1
Global MouseClickX.i
Global MouseClickY.i

; Запоминает положение мыши при ее перемещении по холсту.
Global MouseMoveX.i
Global MouseMoveY.i

; Если объект содержит допустимое изображение в своих данных, то возвращает его, в противном случае возвращает 0.
Procedure.i IsObjectImage(Object.i)
  
  ; Если у объекта есть дополнительное изображение, то оно должно соответствовать значению Data.
  ObjectData.i = GetObjectData(Object.i)
  
  If ObjectData.i <> 0 And IsImage(ObjectData.i)
    ProcedureReturn GetObjectData(Object.i)
    
  Else
    ProcedureReturn 0
    
  EndIf
  
EndProcedure

; Quand un Objet est double cliqué.
Procedure WhenDoubleClickedObject()
  
  ; Activer le canevas temporaire.
  CanevasTemporaireActif.b = #True
  
  ; Отменяет выбор всех объектов на холсте, кроме выбранного, должен быть выбран только один объект, и это тот, который мы редактируем в процессе редактирования изображения, в противном случае возникает ошибка, потому что выбрано несколько объектов.
 
 ; { Отменяет выбор указанного объекта или всех объектов на указанном холсте.
 ; iObject: номер объекта, следующие константы могут использоваться вместо номера объекта.
 ;- #Object_All: отменяет выбор всех объектов по порядку.
 ;- #Object_Selected: отменяет выбор всех выбранных объектов по порядку.
 ; iCanvasGadget: номер холста, чтобы ограничить отмену выбора только этим холстом, или #PB_Ignore, чтобы разрешить отмену выбора для всех объектов, которые могут иметь значение, где бы они ни находились.
 ; bPostEvent: по умолчанию (#False) событие не запускается. Используйте #True для запуска типа события #EventType_Unselected.
;}
  UnselectObject(#Object_Selected, Canevas.i)
  
	; { Выбирает указанный объект или все объекты на указанном холсте.
 ; iObject: номер объекта или одна из следующих констант:
 ;- #Object_All: перебирает все объекты по порядку.
 ; iCanvasGadget: номер холста гаджета, чтобы ограничить #Object_All указанным гаджетом, или #PB_Ignore, чтобы разрешить все гаджеты.
 ; bPostEvent: по умолчанию (#False) событие не запускается. Используйте #True для запуска типа события #EventType_Selected.
 ;}
; Выбирает объект в кратком виде для редактирования.
  SelectObject(EventObject(Canevas.i), Canevas.i)
  
  ; Redimensionner et positionner le canevas temporaire pour correspondre à l'objet.
  ResizeGadget(#CanevasTemporaire, GetObjectX(EventObject(Canevas.i)) - 2, GetObjectY(EventObject(Canevas.i)) - 2, GetObjectWidth(EventObject(Canevas.i)) + 4, GetObjectHeight(EventObject(Canevas.i)) + 4)
  
  ; Vérifie si l'objet a une image associée comme Data.
  ImageObjetAdditionnelle.i = IsObjectImage(EventObject(Canevas.i))
  
  If ImageObjetAdditionnelle.i <> 0
    
    ; Récupérer les dimensions de l'objet.
    Largeur.i = ImageWidth(ImageObjetAdditionnelle.i)
    Hauteur.i = ImageHeight(ImageObjetAdditionnelle.i)
    
    ; Vérifie si une image temporaire existe déjà, sinon la recréer.
    If IsImage(#ImageCanevasTemporaire)
      
      ; Redimensionner l'image temporaire si nécessaire.
      If ImageWidth(#ImageCanevasTemporaire) <> Largeur.i Or ImageHeight(#ImageCanevasTemporaire) <> Hauteur.i
        FreeImage(#ImageCanevasTemporaire) ; Efface l'image temporaire car il faut la refaire car elle est trop petite !
        
        ; Création de l'image temporaire de la taille de l'Objet.
        If CreateImage(#ImageCanevasTemporaire, Largeur.i, Hauteur.i, 32, #PB_Image_Transparent)
          ; Debug "Image temporaire recréée avec les nouvelles dimensions."
          
        Else
          Debug "Erreur : Impossible de recréer l'image temporaire."
          ProcedureReturn 0
          
        EndIf
        
      EndIf
      
    Else
      
      ; Créer une nouvelle image temporaire si elle n'existe pas.
      If CreateImage(#ImageCanevasTemporaire, Largeur.i, Hauteur.i, 32, #PB_Image_Transparent)
        ; Debug "Image temporaire créée."
        
      Else
        Debug "Erreur : Impossible de créer l'image temporaire."
        ProcedureReturn 0
        
      EndIf
      
    EndIf
    
    ; Copier l'image de l'objet dans l'image temporaire.
    If StartDrawing(ImageOutput(#ImageCanevasTemporaire))
      DrawingMode(#PB_2DDrawing_AllChannels)
      Box(0, 0, Largeur.i, Hauteur.i, RGBA(255, 255, 255, 0)) ; Effacer avec transparence
      DrawImage(ImageID(ImageObjetAdditionnelle.i), 0, 0)     ; Dessiner l'image sans décalage
      StopDrawing()
      
      ; Debug "Image de l'objet n°" + Str(EventObject(Canevas.i)) + " copiée dans l'image temporaire."
      
    Else
      Debug "Erreur : Impossible de dessiner dans l'image temporaire."
      
    EndIf
    
    ; Mettre à jour le canevas temporaire avec l'image temporaire.
    SetGadgetAttribute(#CanevasTemporaire, #PB_Canvas_Image, ImageID(#ImageCanevasTemporaire))
    ; Debug "Image temporaire affichée dans le canevas."
    
    ; Mémorise l'Objets en court d'édition.
    ActiveObject.i = EventObject(Canevas.i)
    
    ; Cache l'Objets en court d'édition.
    HideObject(ActiveObject.i, #Canevas)
    
  Else
    Debug "Aucune image associée à l'objet n°" + Str(EventObject(Canevas.i))
    
  EndIf
  
EndProcedure

; Quand un Objet est en train d'être déssiné grace au canevas temporaire.
Procedure WhenDrawObject()
  
  ; Il faut que le Canevas Temporaire soit activé.
  If CanevasTemporaireActif.b = #True
    
    ; Création d'une image temporaire pour dessiner
    Largeur.i = GadgetWidth(#CanevasTemporaire)
    Hauteur.i = GadgetHeight(#CanevasTemporaire)
    
    ; Vérifier si une image temporaire principale existe déjà, sinon la créer
    If Not IsImage(#ImageCanevasTemporaire)
      If CreateImage(#ImageCanevasTemporaire, Largeur.i, Hauteur.i, 32, #PB_Image_Transparent)
        ; Debug "Image temporaire principale créée."
      Else
        Debug "Erreur : Impossible de créer l'image temporaire principale."
      EndIf
    EndIf
    
    ; Si l'image temporaire est bien initialisée
    If IsImage(#ImageCanevasTemporaire)
      
      ; Quand le bouton gauche de la souris est cliqué
      If EventType() = #PB_EventType_LeftButtonDown
        ; Sauvegarde la position de la souris cliquée
        MouseClickX.i = GetGadgetAttribute(#CanevasTemporaire, #PB_Canvas_MouseX)
        MouseClickY.i = GetGadgetAttribute(#CanevasTemporaire, #PB_Canvas_MouseY)
        MouseMoveX.i = MouseClickX.i
        MouseMoveY.i = MouseClickY.i
        
        ; Quand la souris est en mouvement avec le bouton gauche enfoncé
      ElseIf EventType() = #PB_EventType_MouseMove And GetGadgetAttribute(#CanevasTemporaire, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton
        
        MouseMoveX.i = GetGadgetAttribute(#CanevasTemporaire, #PB_Canvas_MouseX)
        MouseMoveY.i = GetGadgetAttribute(#CanevasTemporaire, #PB_Canvas_MouseY)
        
        If ModeDessin.i = 1
          
          ; Mode 1 : Dessiner des points directement sur l'image temporaire
          If StartDrawing(ImageOutput(#ImageCanevasTemporaire))
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            Circle(MouseMoveX.i, MouseMoveY.i, 3, RGBA(Random(255), Random(255), Random(255), TransparenceRondPleins.i)) ; Dessiner un cercle de couleur aléatoire
            StopDrawing()
            
            ; Mettre à jour le canevas avec l'image temporaire
            If StartDrawing(CanvasOutput(#CanevasTemporaire))
              DrawingMode(#PB_2DDrawing_AllChannels)
              Box(0, 0, Largeur.i, Hauteur.i, RGBA(255, 255, 255, 255)) ; Effacer le canevas
              DrawingMode(#PB_2DDrawing_AlphaBlend)
              DrawImage(ImageID(#ImageCanevasTemporaire), 0, 0)
              StopDrawing()
            EndIf
            
          Else
            Debug "Erreur : Impossible de dessiner des points sur l'image temporaire."
            
          EndIf
          
        ElseIf ModeDessin.i = 2
          
          ; Mode 2 : Dessiner temporairement un carré plein sur le canevas
          If StartDrawing(CanvasOutput(#CanevasTemporaire))
            DrawingMode(#PB_2DDrawing_AllChannels)
            Box(0, 0, Largeur.i, Hauteur.i, RGBA(255, 255, 255, 255)) ; Effacer le canevas
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            DrawImage(ImageID(#ImageCanevasTemporaire), 0, 0)         ; Réappliquer l'image temporaire
            Box(MouseClickX.i, MouseClickY.i, MouseMoveX.i - MouseClickX.i, MouseMoveY.i - MouseClickY.i, RGBA(Random(255), Random(255), Random(255), TransparenceCarrePleins.i)) ; Dessiner un carré plein
            StopDrawing()
            
          Else
            Debug "Erreur : Impossible de dessiner temporairement sur le canevas."
            
          EndIf
          
        ElseIf ModeDessin.i = 3
          
          ; Mode 3 : Dessiner temporairement un carré vide (encadrement seulement) sur le canevas
          If StartDrawing(CanvasOutput(#CanevasTemporaire))
            DrawingMode(#PB_2DDrawing_AllChannels)
            Box(0, 0, Largeur.i, Hauteur.i, RGBA(255, 255, 255, 255)) ; Effacer le canevas
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            DrawImage(ImageID(#ImageCanevasTemporaire), 0, 0)         ; Réappliquer l'image temporaire
            
            ; Dessiner le carré vide (encadrement seulement)
            LineXY(MouseClickX.i, MouseClickY.i, MouseMoveX.i, MouseClickY.i, RGBA(Random(255), Random(255), Random(255), TransparenceBordureCarreVide.i)) ; Ligne du haut
            LineXY(MouseMoveX.i, MouseClickY.i, MouseMoveX.i, MouseMoveY.i, RGBA(Random(255), Random(255), Random(255), TransparenceBordureCarreVide.i))   ; Ligne de droite
            LineXY(MouseMoveX.i, MouseMoveY.i, MouseClickX.i, MouseMoveY.i, RGBA(Random(255), Random(255), Random(255), TransparenceBordureCarreVide.i))   ; Ligne du bas
            LineXY(MouseClickX.i, MouseMoveY.i, MouseClickX.i, MouseClickY.i, RGBA(Random(255), Random(255), Random(255), TransparenceBordureCarreVide.i)) ; Ligne de gauche
            StopDrawing()
            
          Else
            Debug "Erreur : Impossible de dessiner temporairement sur le canevas."
            
          EndIf
          
        EndIf
        
        ; Quand le bouton gauche de la souris est relâché
      ElseIf EventType() = #PB_EventType_LeftButtonUp
        
        If ModeDessin.i = 2 Or ModeDessin.i = 3
          
          ; Finaliser le dessin (plein ou vide) dans l'image temporaire
          If StartDrawing(ImageOutput(#ImageCanevasTemporaire))
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            
            If ModeDessin.i = 2
              ; Dessiner le carré plein
              Box(MouseClickX.i, MouseClickY.i, MouseMoveX.i - MouseClickX.i, MouseMoveY.i - MouseClickY.i, RGBA(Random(255), Random(255), Random(255), TransparenceCarrePleins.i))
              
            ElseIf ModeDessin.i = 3
              ; Dessiner le carré vide (encadrement seulement)
              LineXY(MouseClickX.i, MouseClickY.i, MouseMoveX.i, MouseClickY.i, RGBA(Random(255), Random(255), Random(255), TransparenceBordureCarreVide.i)) ; Ligne du haut
              LineXY(MouseMoveX.i, MouseClickY.i, MouseMoveX.i, MouseMoveY.i, RGBA(Random(255), Random(255), Random(255), TransparenceBordureCarreVide.i))   ; Ligne de droite
              LineXY(MouseMoveX.i, MouseMoveY.i, MouseClickX.i, MouseMoveY.i, RGBA(Random(255), Random(255), Random(255), TransparenceBordureCarreVide.i))   ; Ligne du bas
              LineXY(MouseClickX.i, MouseMoveY.i, MouseClickX.i, MouseClickY.i, RGBA(Random(255), Random(255), Random(255), TransparenceBordureCarreVide.i)) ; Ligne de gauche
            EndIf
            
            StopDrawing()
            
          Else
            Debug "Erreur : Impossible de finaliser le dessin dans l'image temporaire."
            
          EndIf
          
          ; Mettre à jour le canevas avec l'image temporaire mise à jour
          If StartDrawing(CanvasOutput(#CanevasTemporaire))
            DrawingMode(#PB_2DDrawing_AllChannels)
            Box(0, 0, Largeur.i, Hauteur.i, RGBA(255, 255, 255, 255)) ; Effacer le canevas
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            DrawImage(ImageID(#ImageCanevasTemporaire), 0, 0)         ; Réappliquer l'image temporaire
            StopDrawing()
            
          Else
            Debug "Erreur : Impossible de mettre à jour le canevas."
          EndIf
          
        EndIf
        
      EndIf
      
    Else
      Debug "Image temporaire non initialisée."
      
    EndIf
    
    ; Vous pouvez utiliser aussi ceci:
    
    ;                 Select EventType()
    ;                     
    ;                   Case #PB_EventType_MouseEnter
    ;                     Debug "La souris est entrée sur le CanevasTemporaire"
    ;                     
    ;                   Case #PB_EventType_MouseLeave
    ;                     Debug "La souris est sortie du CanevasTemporaire"
    ;                     
    ;                   Case #PB_EventType_LeftButtonDown
    ;                     Debug "Le bouton gauche de la souris a été appuyé sur le CanevasTemporaire"
    ;                     
    ;                   Case #PB_EventType_LeftButtonUp
    ;                     Debug "Le bouton gauche de la souris a été relâché sur le CanevasTemporaire"
    ;                     
    ;                   Case #PB_EventType_LeftClick
    ;                     Debug "Un clique gauche de la souris a eu lieu sur le CanevasTemporaire"
    ;                     
    ;                   Case #PB_EventType_LeftDoubleClick
    ;                     Debug "Un double clique gauche de la souris a eu lieu sur le CanevasTemporaire"
    ;                     
    ;                   Case #PB_EventType_MiddleButtonDown
    ;                     Debug "Le bouton du milieux de la souris a été appuyé sur le CanevasTemporaire"
    ;                     
    ;                   Case #PB_EventType_MiddleButtonUp
    ;                     Debug "Le bouton du milieux de la souris a été relâché sur le CanevasTemporaire"
    ;                     
    ;                   Case #PB_EventType_RightButtonDown
    ;                     Debug "Le bouton droit de la souris a été appuyé sur le CanevasTemporaire"
    ;                     
    ;                   Case #PB_EventType_RightButtonUp
    ;                     Debug "Le bouton droit de la souris a été relâché sur le CanevasTemporaire"
    ;                     
    ;                   Case #PB_EventType_RightClick
    ;                     Debug "Un clique droit de la souris a eu lieu sur le CanevasTemporaire"
    ;                     
    ;                   Case #PB_EventType_RightDoubleClick
    ;                     Debug "Un double clique droit de la souris a eu lieu sur le CanevasTemporaire"
    ;                     
    ;                   Case #PB_EventType_KeyDown
    ;                     Debug "La touche du clavier " + Chr(GetGadgetAttribute(#CanevasTemporaire, #PB_Canvas_Key)) + " a été enfoncée sur le CanevasTemporaire" ; Voir la Table Ascii.
    ;                     
    ;                   Case #PB_EventType_KeyUp
    ;                     Debug "La touche du clavier " + Chr(GetGadgetAttribute(#CanevasTemporaire, #PB_Canvas_Key)) + " a été relâché sur le CanevasTemporaire" ; Voir la Table Ascii.
    ;                     
    ;                   Case #PB_EventType_MouseWheel
    ;                     
    ;                     If GetGadgetAttribute(#CanevasTemporaire, #PB_Canvas_WheelDelta) > 0
    ;                       Debug "La molette de la souris a été tournée vers le haut sur le CanevasTemporaire"
    ;                     Else
    ;                       Debug "La molette de la souris a été tournée vers le bas sur le CanevasTemporaire"
    ;                     EndIf
    ;                     
    ;                 EndSelect
    
  EndIf
  
EndProcedure

; Quand un Objet est désélectionné.
Procedure WhenUnselectObject()
  
  If CanevasTemporaireActif.b = #True
    
    ; Récupère le numéro de l'objet.
    Object.i = EventObject(Canevas.i)
    
    ; L'objet a-t-il une image en tant que Data ? Si oui, la retourne, sinon retourne 0.
    ImageObjetAdditionnelle.i = IsObjectImage(Object.i)
    
    If ImageObjetAdditionnelle.i <> 0
      
      ; Vérifier si l'image temporaire du canevas existe
      If IsImage(#ImageCanevasTemporaire)
        
        ; Met à jour l'image additionnelle de l'objet avec le contenu du canevas temporaire.
        If StartDrawing(ImageOutput(ImageObjetAdditionnelle.i))
          DrawingMode(#PB_2DDrawing_AllChannels)
          
          ; Efface l'image additionnelle en transparent pour éviter les dessins superposés.
          Box(0, 0, ImageWidth(ImageObjetAdditionnelle.i), ImageHeight(ImageObjetAdditionnelle.i), RGBA(255, 255, 255, 0))
          
          ; Dessiner le contenu de l'image temporaire sur l'image additionnelle.
          DrawImage(ImageID(#ImageCanevasTemporaire), 0, 0)
          StopDrawing()
          
          ; Debug "Image Objet (" + Str(Object.i) + ") mise à jour avec succès : " + Str(ImageObjetAdditionnelle.i)
          
        Else
          Debug "Erreur : Impossible de dessiner sur l'image additionnelle de l'objet n°" + Str(Object.i)
          
        EndIf
        
      Else
        Debug "Erreur : Aucune image temporaire disponible pour mettre à jour l'objet."
        
      EndIf
      
    Else
      Debug "Aucune image associée à l'objet n°" + Str(Object.i)
      
    EndIf
    
    ; Désactive le canevas temporaire et le redimensionne pour le cacher.
    CanevasTemporaireActif.b = #False
    ResizeGadget(#CanevasTemporaire, -1, -1, 1, 1)
    
    ; Si un Objets est Actif.
    If ActiveObject.i > 0
      
      ; Cache l'Objets en court d'édition.
      ShowObject(ActiveObject.i, #Canevas)
      
    EndIf
    
  EndIf
  
EndProcedure

; Quand un Objet est redimentionné.
Procedure WhenResizeObject()
  
  ; Récupère le numéro de l'Objet.
  Object.i = EventObject(Canevas.i)
  
  ; L'Objet a-t-il une image en tant que Data ? Si oui, la retourne sinon retourne 0.
  ImageObjetAdditionnelle.i = IsObjectImage(Object.i)
  
  If ImageObjetAdditionnelle.i <> 0
    
    ; Obtenir les dimensions actuelles de l'image.
    LargeurActuelle.i = ImageWidth(ImageObjetAdditionnelle.i)
    HauteurActuelle.i = ImageHeight(ImageObjetAdditionnelle.i)
    
    ; Obtenir les nouvelles dimensions de l'objet.
    NouvelleLargeur.i = GetObjectWidth(Object.i)
    NouvelleHauteur.i = GetObjectHeight(Object.i)
    
    ; Vérifier si l'image doit être redimensionnée.
    If NouvelleLargeur.i > LargeurActuelle.i Or NouvelleHauteur.i > HauteurActuelle.i
      
      ; Créer une nouvelle image temporaire avec les dimensions nécessaires.
      TempImage.i = CreateImage(#PB_Any, NouvelleLargeur.i, NouvelleHauteur.i, 32, #PB_Image_Transparent)
      
      If TempImage.i
        
        ; Dessiner l'image actuelle centrée sur l'image temporaire.
        StartDrawing(ImageOutput(TempImage.i))
        DrawingMode(#PB_2DDrawing_AlphaBlend)
        Box(0, 0, NouvelleLargeur.i, NouvelleHauteur.i, RGBA(255, 255, 255, 0)) ; Effacer avec la transparence
        XOffset.i = (NouvelleLargeur.i - LargeurActuelle.i) / 2
        YOffset.i = (NouvelleHauteur.i - HauteurActuelle.i) / 2
        DrawImage(ImageID(ImageObjetAdditionnelle.i), XOffset.i, YOffset.i)
        StopDrawing()
        
        ; Redimensionner l'image additionnelle à la taille de l'image temporaire.
        ResizeImage(ImageObjetAdditionnelle.i, NouvelleLargeur.i, NouvelleHauteur.i)
        
        ; Effacer l'image additionnelle avec une couleur transparente.
        StartDrawing(ImageOutput(ImageObjetAdditionnelle.i))
        DrawingMode(#PB_2DDrawing_AllChannels)
        Box(0, 0, NouvelleLargeur.i, NouvelleHauteur.i, RGBA(255, 255, 255, 0))
        StopDrawing()
        
        ; Copier l'image temporaire sur l'image additionnelle.
        StartDrawing(ImageOutput(ImageObjetAdditionnelle.i))
        DrawingMode(#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(ImageID(TempImage.i), 0, 0, 255)
        StopDrawing()
        
        ; Effacer l'image temporaire.
        FreeImage(TempImage.i)
        
        ; Debug "Image Objet (" + Str(Object.i) + ") a été agrandie à " + Str(NouvelleLargeur.i) + "x" + Str(NouvelleHauteur.i)
        
      Else
        Debug "Erreur : Impossible de créer une image temporaire pour l'objet n°" + Str(Object.i)
        
      EndIf
      
    Else
      ; Debug "L'image de l'objet n°" + Str(Object.i) + " est plus petite ou égale à la taille actuelle. Aucun changement."
      
    EndIf
    
  Else
    Debug "Aucune image associée à l'objet n°" + Str(Object.i)
    
  EndIf
  
EndProcedure

; ----------------------------------------------

; { Процедура обратного вызова для рисования изображения на объекте на холсте, потому что когда он создается, на нем ничего нет (серый).
; MyDrawingObject = пользовательское имя процедуры для рисования чего-либо на желаемом объекте, дайте ей любое имя, которое вы хотите, но у нее обязательно должны быть следующие аргументы: Object. i, Width. i, Height.i
; параметры: (Object.i, Width. i, Height. i) будут автоматически использоваться в процедуре MyDrawingObject ().
; Object.i-это номер объекта, эта переменная не отображается в процедуре, но является обязательной.
; Width.i-ширина объекта.
; Height.i-высота объекта.
; iData.i-это пользовательские данные, здесь цифра (цвет) не обязательна, даже в параметрах процедуры MyDrawingObject (Object.i, Width.i, Height.i) тоже работает.
;}
; эта процедура автоматически нарисует или перерисует содержимое этой выполняйте процедуру с объектом всякий раз, когда это будет необходимо.
Runtime Procedure MyDrawingObject(Object.i, Width.i, Height.i, iData.i)
  
  ; Graphique de base.
  AddPathBox(0.5, 0.5, Width - 1, Height - 1)
  VectorSourceColor(RGBA(255, 255, 255, 255))
  FillPath()
  AddPathBox(0.5, 0.5, Width-1, Height-1)
  VectorSourceColor(iData|$80000000)
  FillPath(#PB_Path_Preserve)
  VectorSourceColor(iData|$FF000000)
  StrokePath(1)
  
  ; L'Objet a t-il une image en tans que Data ?, si oui la retourne sinon retourne 0
  ImageObjetAdditionnelle.i = IsObjectImage(Object.i)
  
  If ImageObjetAdditionnelle.i <> 0
    ; Debug "Image Objet (" + Str(Object.i) + ") ok et déssiné dans MyDrawingObject: " + Str(ImageObjetAdditionnelle.i)
    ; déssine cette image par dessus les graphique de l'Objet, cette nouvelle image sera centré sur l'Objet.
    MovePathCursor(((Width.i - ImageWidth(ImageObjetAdditionnelle.i)) / 2), (Height.i - ImageHeight(ImageObjetAdditionnelle.i)) / 2)
    DrawVectorImage(ImageID(ImageObjetAdditionnelle.i), 255, ImageWidth(ImageObjetAdditionnelle.i), ImageHeight(ImageObjetAdditionnelle.i))
  EndIf
  
EndProcedure

; ----------------------------------------------

; Création d'une fenêtre.
OpenWindow(#Window, 0, 0, 800, 450, "Déssiner sur des Objets avec diverses Mode avec la souris grace a un Canevas Temporaire", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)

; Création d'un Canevas gadget.
CanvasGadget(#Canevas, 0, 0, WindowWidth(#Window) - 50, WindowHeight(#Window), #PB_Canvas_Keyboard | #PB_Canvas_Container)

; Création d'un canevas temporaire qui servira à déssiner sur un Objets.
CanvasGadget(#CanevasTemporaire, -1, -1, 1, 1, #PB_Canvas_Border)

CloseGadgetList()

; Bouton mode de déssin 1 = Rond.
ButtonGadget(#BoutonDessinMode1, WindowWidth(#Window) - 40, 10, 32, 32, "1", #PB_Button_Toggle)

; Bouton mode de déssin 2 = Carré pleins.
ButtonGadget(#BoutonDessinMode2, WindowWidth(#Window) - 40, 45, 32, 32, "2", #PB_Button_Toggle)

; Bouton mode de déssin 3 = Carrré vide avec bordures.
ButtonGadget(#BoutonDessinMode3, WindowWidth(#Window) - 40, 80, 32, 32, "3", #PB_Button_Toggle)

; Active le bouton 1.
SetGadgetState(#BoutonDessinMode1, #True)

; { Инициализирует диспетчер объектов для указанного холста-гаджета в указанном окне, это необходимо сделать для каждого холста-гаджета.
; iCanvasGadget: PB номер холста гаджета.
; iWindow: номер окна PB.
; Результат: возвращает #True, если инициализация прошла успешно, в противном случае #False.
;}
; инициализирует обработку для холста-гаджета.
InitializeCanvasObjects(#Canevas, #Window)

; { Создает и добавляет объект на указанный холст. Предупреждение: перед добавлением объектов на этот холст необходимо вызвать функцию InitializeCanvasObjects ().
; iCanvasGadget: PB номер гаджета на холсте.
; iObject: номер самостоятельно определенного объекта или #PB_Any для генерации уникального номера. Самоустановленное число должно находиться в диапазоне от 1 до 65535.
; iX, iY: положение объекта на холсте.
; iWidth, iHeight: размер объекта на холсте.
; iParentObject: действительный номер объекта, к которому объект должен быть присоединен (необязательно). По умолчанию объект будет помещен в рамку холста.
; iFrameIndex: индекс фрейма (начинающийся с 0) или одна из следующих констант, к которым должен быть присоединен объект (необязательно).
;- #Frame_NoFrame: объект будет прикреплен к стандартному неиндексированному фрейму (фрейм для вложений).
;- #Frame_ViewedFrame: объект будет прикреплен к кадру
CreateObject(#Canevas, #Objet1, 20, 20, 120, 80)
CreateObject(#Canevas, #Objet2, 150, 20, 120, 80)
CreateObject(#Canevas, #Objet3, 20, 110, 120, 80)
CreateObject(#Canevas, #Objet4, 150, 110, 120, 80)

; { Создание полностью прозрачных изображений, которые будут удалены поверх базовой графики объектов, это пример, удалите из них то, что вы хотите, или ничего.
If CreateImage(#ImageObjet1, GetObjectWidth(#Objet1), GetObjectHeight(#Objet1), 32, #PB_Image_Transparent)
  
  If StartVectorDrawing(ImageVectorOutput(#ImageObjet1))
    
    Largeur.i = 90
    Hauteur.i = 60
    
    VectorSourceColor(RGBA(255, 0, 0, 255))
    
    ; Créer un carré rouge.
    AddPathBox((ImageWidth(#ImageObjet1) - Largeur.i) / 2, (ImageHeight(#ImageObjet1) - Hauteur.i) / 2, Largeur.i, Hauteur.i)
    
    ; créer un carré transparent.
    AddPathBox(((ImageWidth(#ImageObjet1) - Largeur.i) / 2) + 1, ((ImageHeight(#ImageObjet1) - Hauteur.i) / 2) + 1, Largeur.i - 2, Hauteur.i - 2)
    
    FillPath() ; Remplie que le carré rouge.
    
    StopVectorDrawing()
    
  EndIf
  
  SetObjectData(#Objet1, #ImageObjet1)
  
Else
  Debug "Ne peu pas créer l'image de l'Objets n°1"
  
EndIf

If CreateImage(#ImageObjet2, GetObjectWidth(#Objet2), GetObjectHeight(#Objet2), 32, #PB_Image_Transparent)
  
  If StartVectorDrawing(ImageVectorOutput(#ImageObjet2))
    
    Largeur.i = 90
    Hauteur.i = 60
    
    VectorSourceColor(RGBA(0, 150, 0, 255))
    
    ; Créer un carré vert.
    AddPathBox((ImageWidth(#ImageObjet2) - Largeur.i) / 2, (ImageHeight(#ImageObjet2) - Hauteur.i) / 2, Largeur.i, Hauteur.i)
    
    ; créer un carré transparent.
    AddPathBox(((ImageWidth(#ImageObjet2) - Largeur.i) / 2) + 1, ((ImageHeight(#ImageObjet2) - Hauteur.i) / 2) + 1, Largeur.i - 2, Hauteur.i - 2)
    
    FillPath() ; Remplie que le carré rouge.
    
    StopVectorDrawing()
    
  EndIf
  
  SetObjectData(#Objet2, #ImageObjet2)
  
Else
  Debug "Ne peu pas créer l'image de l'Objets n°2"
  
EndIf

If CreateImage(#ImageObjet3, GetObjectWidth(#Objet3), GetObjectHeight(#Objet3), 32, #PB_Image_Transparent)
  
  If StartVectorDrawing(ImageVectorOutput(#ImageObjet3))
    
    Largeur.i = 90
    Hauteur.i = 60
    
    VectorSourceColor(RGBA(0, 0, 255, 255))
    
    ; Créer un carré bleu.
    AddPathBox((ImageWidth(#ImageObjet3) - Largeur.i) / 2, (ImageHeight(#ImageObjet3) - Hauteur.i) / 2, Largeur.i, Hauteur.i)
    
    ; créer un carré transparent.
    AddPathBox(((ImageWidth(#ImageObjet3) - Largeur.i) / 2) + 1, ((ImageHeight(#ImageObjet3) - Hauteur.i) / 2) + 1, Largeur.i - 2, Hauteur.i - 2)
    
    FillPath() ; Remplie que le carré rouge.
    
    StopVectorDrawing()
    
  EndIf
  
  SetObjectData(#Objet3, #ImageObjet3)
  
Else
  Debug "Ne peu pas créer l'image de l'Objets n°3"
  
EndIf

If CreateImage(#ImageObjet4, GetObjectWidth(#Objet4), GetObjectHeight(#Objet4), 32, #PB_Image_Transparent)
  
  If StartVectorDrawing(ImageVectorOutput(#ImageObjet4))
    
    Largeur.i = 90
    Hauteur.i = 60
    
    VectorSourceColor(RGBA(255, 200, 0, 255))
    
    ; Créer un carré jaune.
    AddPathBox((ImageWidth(#ImageObjet4) - Largeur.i) / 2, (ImageHeight(#ImageObjet4) - Hauteur.i) / 2, Largeur.i, Hauteur.i)
    
    ; créer un carré transparent.
    AddPathBox(((ImageWidth(#ImageObjet4) - Largeur.i) / 2) + 1, ((ImageHeight(#ImageObjet4) - Hauteur.i) / 2) + 1, Largeur.i - 2, Hauteur.i - 2)
    
    FillPath() ; Remplie que le carré rouge.
    
    StopVectorDrawing()
    
  EndIf
  
  SetObjectData(#Objet4, #ImageObjet4)
  
Else
  Debug "Ne peu pas créer l'image de l'Objets n°4"
  
EndIf
;}

; Ici chaque objet aurra la même procédure de déssins avec juste une couleur comme paramètre.
; Il est tout à fait possible d'utiliser une procédure de déssins propre à chaque Objets !
; Pour cella, il suffie de créé une procédure pour chaque Objets !

;{  Définit une procédure de dessin personnalisée pour l'Objet spécifié.
;  iObject:               Le numéro de l'Objet, les constantes suivantes peuvent être utilisées à la place du numéro de l'objet.
;                          - #Object_Default: Définie l'image par defaut de tous les nouveaux objets créé.
;                          - #Object_All: Définie l'image de tous les objets.
;                          - #Object_Selected: Définie l'image de tous les objets sélectionnés.
;  sCallbackName:         Une chaîne vide ou un nom de procédure d'exécution valide vers une procédure avec les arguments suivants: Callback(iObject.i, iWidth.i, iHeight.i, iData.i)
;                          - iObject contient le numéro de l'Objet.
;                          - iWidth contient la largeur actuelle.
;                          - iHeight contient la hauteur actuelle.
;                          - iData contient une donnée utilisateur personnalisée (Nombre) individuelle qui sera également envoyée à la fonction.
;  Résultat:              Renvoie #True si le callback a été défini avec succet à l'Objet ou #False si l'Objet n'existe pas.
;}
; Dessine un carré remplie ainsi qu'une bordure avec la procedure MyDrawing().
SetObjectDrawingCallback(#Objet1, "MyDrawingObject()", RGB(242, 186, 40))  ; Jaune
SetObjectDrawingCallback(#Objet2, "MyDrawingObject()", RGB(241, 64, 33))   ; Rouge
SetObjectDrawingCallback(#Objet3, "MyDrawingObject()", RGB(130, 222, 29))  ; Vert
SetObjectDrawingCallback(#Objet4, "MyDrawingObject()", RGB(42, 53, 255))   ; Bleu

;{ Ajoute une ou plusieurs poignée standard ou personnalisée à l'Objet spécifié. Les poignées personnalisées peuvent avoir un alignement et un décalage de position.
;  iObject:          Le numéro de l'Objet, les constantes suivantes peuvent être utilisées à la place du numéro de l'objet.
;                     - #Object_Default: Définie les poignées par defaut de tous les nouveaux objets créé.
;                     - #Object_All: Définie les poignées de tous les objets.
;                     - #Object_Selected: Définie les poignées de tous les objets sélectionnés.
;  eType:            Une combinaison de tous les types de poignées qu'il faut ajouter. *
;  iImage:           Un numéro d'image pour la poignée. Par défaut (#PB_Default) l'image par défaut de la poignée est utilisée.
;  eAlignment:       L'alignement de la poignée personnalisée. Par défaut c'est #Alignment_Default = #Alignment_Center **
;  iX, iY:           Position décalée de la poignée par rapport à l'alignement et à l'Objet.
;  Resulta:          Renvoie #True, si l'ajout de la poignée a réussi, sinon #False.
;                  
;                  * Les types de poignées suivantes peuvent être utilisés et combinés:
;                    #Handle_Position:  Une poignée pour déplacer l'Objet.
;                    #Handle_Rotation:  Une poignée pour faire tourner l'Objet. (NON UTILISÉ).
;                    #Handle_BottomLeft, #Handle_Bottom, #Handle_BottomRight, #Handle_Left, #Handle_Right, #Handle_TopLeft, #Handle_Top, #Handle_TopRight:  Une poignée Pour redimensionner l'Objet dans cette direction.
;                    #Handle_Custom1 ... #Handle_Custom8: Une poignée personnalisée:
;                    
;                    En outre, les constantes suivantes sont des combinaisons prédéfinies:
;                    #Handle_Width  = #Handle_Left | #Handle_Right.
;                    #Handle_Height = #Handle_Top | #Handle_Bottom.
;                    #Handle_Edge   = #Handle_Width | #Handle_Height.
;                    #Handle_Corner = #Handle_BottomLeft | #Handle_BottomRight | #Handle_TopLeft | #Handle_TopRight.
;                    #Handle_Size   = #Handle_Edge | #Handle_Corner.
;                 
;                 ** Les types d'alignement suivants peuvent être utilisés et combinés:
;                    #Alignment_Top:     Aligne le centre de la poignée sur le bord supérieur de l'Objet.
;                    #Alignment_Bottom:  Aligne le centre de la poignée sur le bord inférieur de l'Objet.
;                    #Alignment_Left:    Aligne le centre de la poignée sur le bord gauche de l'Objet.
;                    #Alignment_Right:   Aligne le centre de la poignée sur le bord droit de l'Objet.
;                    #Alignment_Center:  Aligne le centre de la poignée sur le centre (x et/ou y) de l'Objet.
;}
; Quelques exemples non exhaustifs de poignées d'Objets.
AddObjectHandle(#Object_All, #Handle_Size | #Handle_Position) ; Redimentionnable dans toutes les direction et déplaçable.

;{ Définit le style du cadre de sélection du curseur de la souris.
;  iCanvasGadget.i        Le numéro du Canevas gadget.
;  eType :                Un des types de style suivants:
;                          - #SelectionStyle_None: Masque le cadre de sélection.
;                          - #SelectionStyle_Solid: ligne de cadre solide.
;                          - #SelectionStyle_Dotted: Ligne de cadre en pointillés.
;                          - #SelectionStyle_Dashed:  Dahsed frame line.
;                          - #SelectionStyle_Ignore:  Ignorer ce paramètre.
;                          - #SelectionStyle_Partially: Vous pouvez combiner cette constante (|) avec le type de style pour permettre la sélection par partiel.
;  iColor:                Couleur RGBA du cadre ou #SelectionStyle_Ignore pour ignorer ce paramètre.
;  dThickness :           Epaisseur de la ligne du cadre ou #SelectionStyle_Ignore pour ignorer ce paramètre.
;  iBackgroundColor.i     La couleur à l’intérieur de la sélection ou #SelectionStyle_Ignore pour ignorer ce paramètre.
;}
; Active et personnalise la sélection du curseur de la souris pour sélectionné les Objets sur le Canevas gadget.
; Ajoutez #SelectionStyle_Partially pour sélectionner les Objets si la sélection touche l'Objets avec |, par défaut, la sélection dois entourer complètement l'objet pour le sélectionner.
SetCursorSelectionStyle(#Canevas, #SelectionStyle_Dotted, RGBA(0, 0, 0, 255), 1, 0) 

;{ Définit le style du cadre de sélection de l'Objet spécifié.
;  iObject:               Le numéro de l'Objet, les constantes suivantes peuvent être utilisées à la place du numéro de l'objet.
;                          - #Object_Default: Définie le style de selection par defaut de tous les nouveaux objets créé.
;                          - #Object_All: Définie le style de selection de tous les objets.
;                          - #Object_Selected: Définie le style de selection de tous les objets sélectionnés.
;  eType:                 Un des types de style suivants:
;                          - #SelectionStyle_Default: Utilise le style par défaut.
;                          - #SelectionStyle_None: Masque le cadre de sélection.
;                          - #SelectionStyle_Solid: ligne en continue.
;                          - #SelectionStyle_Dotted: ligne en Pointillés.
;                          - #SelectionStyle_Dashed: ligne tiret.
;  iColor:                Couleur RGBA du cadre ou #SelectionStyle_Ignore pour ignorer ce paramètre. Non utilisé si eType est #SelectionStyle_Default ou #SelectionStyle_None.
;  dThickness:            Epaisseur de la ligne de cadre ou #SelectionStyle_Ignore pour ignorer ce paramètre. Non utilisé si eType est #SelectionStyle_Default ou #SelectionStyle_None.
;  dDistance:             Distance de la ligne du cadre à la bordure de l'objet ou #SelectionStyle_Ignore pour ignorer ce paramètre.
;  Résultat:              #True si l'état du cadre sélectionné a été défini ou #False si l'objet n'existe pas.
;}
; Seléction avec des tirets.
SetObjectSelectionStyle(#Object_All, #SelectionStyle_Dashed, RGBA(0, 0, 0, 255), 1, 0)

;{ Définit la taille et la position limite de l'Objet spécifié.
;  iObject:               Le numéro de l'Objet, les constantes suivantes peuvent être utilisées à la place du numéro de l'objet.
;                          - #Object_Default: Définie les limites pour tous les nouveaux objets créé.
;                          - #Object_All: Définie les limites de tous les objets éxistant.
;                          - #Object_Selected: Définie les limites de tous les objets sélectionnés.
;  iMinX, iMinY:          Valeurs minimales pour la position de l'objet (en haut à gauche). *
;  iMaxX, iMaxY:          Valeurs maximales pour la position de l'objet (coin inférieur droit). *
;  iMinWidth, iMinHeight: Valeurs minimales pour la taille de l'objet. *
;  iMaxWidth, iMaxHeight: Valeurs maximales pour la taille de l'objet. *
;  Résultat:              #True si les limites ont été fixées ou #False si l'objet n'existe pas.
;                         * Pour les valeurs de taille et de position, les constantes suivantes peuvent également être utilisées:
;                           #Boundary_Ignore:      Ignorer ce paramètre et laisser la valeur limite inchangée.
;                           #Boundary_None:        Supprime la valeur limite de ce paramètre.
;                           #Boundary_ParentSize:  Ajoutez cette constante à une valeur de limite (#Boundary_ParentSize ± Valeur) pour rendre la limite relative à la taille du cadre parent (ou du canevas gadget).
;                           #Boundary_Default:     Régler la valeur limite à la valeur par défaut.
;}
; Limite la position ainsi que la taille, minimale et maximale des Objets.
SetObjectBoundaries(#Object_All, 0, 0, GadgetWidth(#Canevas), GadgetHeight(#Canevas))

;{ Définit le curseur de la souris affiché quand la souris passe sur l'objet spécifié.
; Cette fonction est à utiliser pour les fonctions suivante: SetObjectHandleCursor() et SetCanvasCursor(), pour le paramètre hCursorHandle.
; iObject:               Le numéro de l'Objet, les constantes suivantes peuvent être utilisées à la place du numéro de l'objet.
;                          - #Object_Default: Définie le curseur de la souris par defaut de tous les nouveaux objets créé.
;                          - #Object_All: Définie le curseur de la souris de tous les objets.
;                          - #Object_Selected: Définie le curseur de la souris de tous les objets sélectionnés.
;  eCursor:               Une constante #PB_Cursor_* valide:
;                         #PB_Cursor_Default            : Flèche du curseur par défaut 
;                         #PB_Cursor_Cross              : Curseur en forme de croix 
;                         #PB_Cursor_IBeam              : Barre d'insertion 'I' utilisée pour la sélection de texte  
;                         #PB_Cursor_Hand               : Curseur main 
;                         #PB_Cursor_Busy               : Curseur sablier ou une montre 
;                         #PB_Cursor_Denied             : Curseur cercle barré ou curseur X 
;                         #PB_Cursor_Arrows             : Flèches dans toutes les directions (non disponible sur OS X) 
;                         #PB_Cursor_LeftRight          : Flèches gauche et droite 
;                         #PB_Cursor_UpDown             : Flèches haut et bas 
;                         #PB_Cursor_LeftUpRightDown    : Flèches diagonales (Windows uniquement) 
;                         #PB_Cursor_LeftDownRightUp    : Flèches diagonales (Windows uniquement)  
;                         #PB_Cursor_Invisible          : Cache le curseur
;                         #PB_Cursor_Custom             : Un Curseur personnalisé
;  hCursorHandle:        Une image personnalisé pour le curseur, a condition que eCursor soit #PB_Cursor_Custom.
;  Résultat:             Renvoie #True si le curseur a été placé ou #False si l'objet n'existe pas.
;}
; Curseur Personnalisé.
SetObjectCursor(#Object_All, #PB_Cursor_Hand)


; La boucle événementielle de la fenêtre et les gadgets.
Repeat
  
  WindowEvent = WaitWindowEvent(1) ; Cette ligne attend pendent (Minuteur) qu'un évènement soit recus par la fenêtre
  WindowID = EventWindow()         ; La fenêtre où l'évènement c'est produit
  GadgetID = EventGadget()         ; Pour savoir sur quel gadget c'est produis l'évènement
  MenuID = EventMenu()             ; Pour savoir sur quel menue c'est produis l'évènement
  EventType = EventType()          ; Le type d'évènement qui c'est produis sur le gadget
  
  Select WindowID
      
    Case #Window
      
      Select WindowEvent 
          
        Case #PB_Event_Gadget
          
          Select GadgetID
              
            Case #Canevas
              
              Select EventType()
                  
                Case #PB_EventType_MouseEnter
                  Debug "Мышь вошла на холст"
                  
                Case #PB_EventType_MouseLeave
                  Debug "Мышь исчезла с холста"
                  
                Case #PB_EventType_LeftButtonDown
                  Debug "Левая кнопка мыши была нажата на холсте"
                  
                Case #PB_EventType_LeftButtonUp
                  Debug "Левая кнопка мыши была отпущена на холст"
                  
                Case #PB_EventType_LeftClick
                  Debug "Произошел щелчок левой кнопкой мыши по холсту"
                  
                Case #PB_EventType_LeftDoubleClick
                  Debug "Произошел двойной щелчок левой кнопкой мыши по холсту"
                  
                Case #PB_EventType_MiddleButtonDown
                  Debug "Кнопка фона мыши была нажата на холсте"
                  
                Case #PB_EventType_MiddleButtonUp
                  Debug "Кнопка фона мыши была отпущена на холст"
                  
                Case #PB_EventType_RightButtonDown
                  Debug "Правая кнопка мыши была нажата на холсте"
                  
                Case #PB_EventType_RightButtonUp
                  Debug "Правая кнопка мыши была отпущена на холст"
                  
                Case #PB_EventType_RightClick
                  Debug "Произошел щелчок правой кнопкой мыши по холсту"
                  
                Case #PB_EventType_RightDoubleClick
                  Debug "Произошел двойной щелчок правой кнопкой мыши по холсту"
                  
                Case #PB_EventType_KeyDown
                  Debug "Клавиша на клавиатуре " + Chr(GetGadgetAttribute(#Canevas, #PB_Canvas_Key)) + " была нажата на холсте" ; Посмотреть таблицу Ascii.
                  
                Case #PB_EventType_KeyUp
                  Debug "Клавиша на клавиатуре " + Chr(GetGadgetAttribute(#Canevas, #PB_Canvas_Key)) + " был выпущен на холст" ; Посмотреть таблицу Ascii.
                  
                Case #PB_EventType_MouseWheel
                  
                  If GetGadgetAttribute(#Canevas, #PB_Canvas_WheelDelta) > 0
                    Debug "Колесо мыши было повернуто вверх на холсте"
                  Else
                    Debug "Колесо мыши было повернуто вниз на холсте"
                  EndIf
                  
              EndSelect
              
            Case #CanevasTemporaire
              ; Когда мы занимаемся расчисткой объекта.
              WhenDrawObject()
              
            Case #BoutonDessinMode1
              
              If GetGadgetState(#BoutonDessinMode1) = #False
                SetGadgetState(#BoutonDessinMode1, #True)
              EndIf
              
              SetGadgetState(#BoutonDessinMode2, #False)
              SetGadgetState(#BoutonDessinMode2, #False)
              
              ModeDessin.i = 1
              
            Case #BoutonDessinMode2
              
              If GetGadgetState(#BoutonDessinMode2) = #False
                SetGadgetState(#BoutonDessinMode2, #True)
              EndIf
              
              SetGadgetState(#BoutonDessinMode1, #False)
              SetGadgetState(#BoutonDessinMode3, #False)
              
              ModeDessin.i = 2
              
            Case #BoutonDessinMode3
              
              If GetGadgetState(#BoutonDessinMode3) = #False
                SetGadgetState(#BoutonDessinMode3, #True)
              EndIf
              
              SetGadgetState(#BoutonDessinMode1, #False)
              SetGadgetState(#BoutonDessinMode2, #False)
              
              ModeDessin.i = 3
              
          EndSelect
          
        Case #PB_Event_Menu
          
          Select MenuID
              
            Case 0
              
          EndSelect
          
        Case #PB_Event_CloseWindow  
          End
          
      EndSelect
      
  EndSelect
  
  ; Цикл обработки событий объектов на холсте.
  Repeat
    
    Select CanvasObjectsEvent() ; Что-то произошло на холсте.
        
      Case #Event_Object ; Это событие типа объектов.
        
        Canevas.i = CanvasObjectsEventGadget() ; На каком холсте произошло событие ?
        
        Select CanvasObjectsEventType(Canevas.i) ; Какие события произошли на объекте холста ?
            
          Case #EventType_MouseEnter
            Debug "Мышь вошла в объект n°" + EventObject(Canevas.i)
            
          Case #EventType_MouseLeave
            Debug "Мышь вышла из объекта n°" + EventObject(Canevas.i)
            
          Case #EventType_LeftMouseBottonDown
            Debug "Левая кнопка мыши была нажата на объекте n°" + EventObject(Canevas.i)
            
          Case #EventType_LeftMouseBottonUp
            Debug "Левая кнопка мыши была отпущена на объект n°" + EventObject(Canevas.i)
            
          Case #EventType_LeftMouseClick
            Debug "Произошел щелчок левой кнопкой мыши по объекту n°" + EventObject(Canevas.i)
            
          Case #EventType_LeftMouseDoubleClick
            Debug "Произошел двойной щелчок левой кнопкой мыши по объекту n°" + EventObject(Canevas.i)
            ; При двойном щелчке по объекту активируется временный холст, а затем отображается изображение объекта в нем для редактирования.
            WhenDoubleClickedObject()
            
          Case #EventType_MiddleMouseBottonDown
            Debug "Кнопка фона мыши была нажата на объекте n°" + EventObject(Canevas.i)
            
          Case #EventType_MiddleMouseBottonUp
            Debug "Кнопка фона мыши была отпущена на объект n°" + EventObject(Canevas.i)
            
          Case #EventType_MiddleMouseClick
            Debug "На объекте произошел щелчок мышью по центру n°" + EventObject(Canevas.i)
            
          Case #EventType_MiddleMouseDoubleClick
            Debug "На объекте произошел двойной щелчок мышью по центру n°" + EventObject(Canevas.i)
            
          Case #EventType_RightMouseBottonDown
            Debug "Правая кнопка мыши была нажата на объекте n°" + EventObject(Canevas.i)
            
          Case #EventType_RightMouseBottonUp
            Debug "Правая кнопка мыши была отпущена на объект n°" + EventObject(Canevas.i)
            
          Case #EventType_RightMouseClick
            Debug "Произошел щелчок правой кнопкой мыши по объектуn°" + EventObject(Canevas.i)
            
          Case #EventType_RightMouseDoubleClick
            Debug "Произошел двойной щелчок правой кнопкой мыши по объекту n°" + EventObject(Canevas.i)
            
          Case #EventType_MouseWheel
            
            If CanvasObjectsEventData(Canevas.i) > 0
              Debug "Колесо мыши было повернуто на объекте вверх n°" + EventObject(Canevas.i)
            Else
              Debug "Колесо мыши было повернуто на объекте вниз" + EventObject(Canevas.i)
            EndIf
            
          Case #EventType_KeyUp
            Debug "Клавиша на клавиатуре " + Chr(CanvasObjectsEventData(Canevas.i)) + " была нажата на объекте n°" + EventObject(Canevas.i) ; Смотрите таблицу Ascii.
            
          Case #EventType_KeyDown
            Debug "Клавиша на клавиатуре " + Chr(CanvasObjectsEventData(Canevas.i)) + " был выпущен на объект n°" + EventObject(Canevas.i) ; Смотрите таблицу Ascii.
            
          Case #EventType_Selected
            Debug "объект n°" + EventObject(Canevas.i) + " был выбран."
            
          Case #EventType_Unselected ; Если объект был отменен, скройте временный холст, если он активен.
            Debug "объект n°" + EventObject(Canevas.i) + " был отменен выбор."
            ; Когда мы щелкаем за пределами временного холста, чтобы зафиксировать изменения, изображение объекта затем обновляется.
            WhenUnselectObject()
            
          Case #EventType_Resized
            Debug "объект n°" + EventObject(Canevas.i) + " был изменен размер."
            ; При изменении размера объекта увеличьте изображение объекта, если оно меньше, в противном случае ничего не делайте.
            WhenResizeObject()
            
            ; Тонкость здесь с этой функцией !
            ShowObject(EventObject(Canevas.i)) ; Запускает перерисовку объекта на холсте.
            
          Case #EventType_Selection
            X.i = CanvasObjectsEventData(Canevas.i, #EventTypeData_MinX)
            Y.i = CanvasObjectsEventData(Canevas.i, #EventTypeData_MinY)
            Largeur.i = CanvasObjectsEventData(Canevas.i, #EventTypeData_MaxX) - X.i
            Hauteur.i = CanvasObjectsEventData(Canevas.i, #EventTypeData_MaxY) - Y.i
            Debug "Выбор был отменен: ({X: " + Str(X.i) + ", Y: " + Str(Y.i) + "}, {Ширина: " + Str(Largeur.i) + ", Высота: " + Str(Hauteur.i) + "})"
            
        EndSelect
        
      Case #Event_None ; Никаких событий.
        Break          ; Никогда не опускайте его, иначе программа будет зацикливаться !
        
    EndSelect
    
  ForEver
  
ForEver
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 628
; FirstLine = 613
; Folding = ----------+
; EnableXP