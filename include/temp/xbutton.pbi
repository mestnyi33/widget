; ====================================
; Name:             xButton Gadget
; Version:          1.5
; Author:           Mohsen
; Update:           28th May 2020
; License:          Free
; Topic:            https://www.purebasic.fr/english/viewtopic.php?f=12&t=71134
;                   https://www.purebasic.fr/english/viewtopic.php?p=555071#p555071
; ====================================

DeclareModule xButton
   Enumeration 1
      ;Text & Icon alignment
      #XBTN_Align_Top_Left
      #XBTN_Align_Top_Center
      #XBTN_Align_Top_Right
      #XBTN_Align_Middle_Left
      #XBTN_Align_Middle_Center
      #XBTN_Align_Middle_Right
      #XBTN_Align_Bottom_Left
      #XBTN_Align_Bottom_Center
      #XBTN_Align_Bottom_Right
      ;
      ;Icon and text relation
      #XBTN_Relation_Overlay
      #XBTN_Relation_Icon_Above_Text
      #XBTN_Relation_Icon_Before_Text
      #XBTN_Relation_Text_Above_Icon
      #XBTN_Relation_Text_Before_Icon
      ;
      ;xButton States
      #XBTN_State_Default
      #XBTN_State_SelectMode
      #XBTN_State_MarkerMode
      #XBTN_State_CombinedMode
      ;
      ;BackgroundColor Procedure States
      #XBTN_BGColor_Normal
      #XBTN_BGColor_OnEnter
      ;
      ;Marker Align
      #XBTN_Marker_Left
      #XBTN_Marker_Top
      #XBTN_Marker_Right
      #XBTN_Marker_Bottom
      ;
      ;Read Order
      #XBTN_ReadOrder_Left   = #PB_VectorParagraph_Left
      #XBTN_ReadOrder_Center = #PB_VectorParagraph_Center
      #XBTN_ReadOrder_Right  = #PB_VectorParagraph_Right   
   EndEnumeration
   
   Declare Create(xbtn_ID, X, Y, Width, Height, Text.s = "", ImageNum = #PB_Ignore)
   Declare Free(xbtn_ID)
   Declare ReDraw(xbtn_ID, RedrawState = #XBTN_BGColor_Normal)
   Declare SetIconTextRelation(xbtn_ID, Relation, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare SetBackgroundColor(xbtn_ID, State, Color, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare SetIconAlign(xbtn_ID, Align, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare SetTextAlign(xbtn_ID, Align, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare SetTextFont(xbtn_ID, fontNum, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare SetTextColor(xbtn_ID, Color, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare SetText(xbtn_ID, Text.s = "", ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare SetTextX(xbtn_ID, X, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare SetTextY(xbtn_ID, Y, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare SetIcon(xbtn_ID, ImageNum, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare SetIconX(xbtn_ID, X, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare SetIconY(xbtn_ID, Y, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare SetState(xbtn_ID, State, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare SetReadOrder(xbtn_ID, ReadOrder, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare SetMarkerSettings(xbtn_ID, Width = #PB_Ignore, Height = #PB_Ignore, Align = #PB_Ignore, Color = 0, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare SetBorder(xbtn_ID, State, Size, Color, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
   Declare GetProperties(xbtn_ID, Property.s)
EndDeclareModule


Module xButton
   
   EnableExplicit
   
   Global xfont
   
   CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      xfont = LoadFont(#PB_Any,"Segoe UI",8,#PB_Font_HighQuality|#PB_Font_Bold)
   CompilerElse
      xfont = LoadFont(#PB_Any,"tahoma",8,#PB_Font_HighQuality|#PB_Font_Bold)
   CompilerEndIf
   
   Enumeration
      #xButton_TextWidth
      #xButton_TextHeight
   EndEnumeration   
   
   Structure xbtn_MarkerOpt
      Width.i
      Height.i
      Color.i
      Align.b
   EndStructure
   
   Structure xbtn_bgColor
      bgColor_Normal.i
      bgColor_OnEnter.i
      bgColor_Temp.i
   EndStructure
   
   Structure xbtn_TextOpt
      _FontNum.i
      _Color.i
      _ReadOrder.b
      _X.i
      _Y.i
      _W.i
      _H.i
      _TextAlign.b
   EndStructure
   
   Structure xbtn_IconOpt
      _X.i
      _Y.i
      _W.i
      _H.i
      _IconAlign.b
   EndStructure
   
   Structure xbtn_BorderOpt
      BorderFlag.b
      BorderSize.i
      BorderColor.i
   EndStructure
   
   Structure _xButton
      ID.i
      Width.i
      Height.i
      Text.s
      ImageNum.i
      State.b
      IaT_relation.b
      TextOptions.xbtn_TextOpt
      IconOptions.xbtn_IconOpt
      MarkerOptions.xbtn_MarkerOpt   
      BorderOptions.xbtn_BorderOpt
      BackgroundColor.xbtn_bgColor
   EndStructure
   
   Macro  Check_Align(ImageAlign,TextAlign,AlignFlag)
      Bool((ImageAlign = AlignFlag) And (TextAlign = AlignFlag))
   EndMacro 
   
   ;-#####################
   ;- Internal Procedures
   ;-#####################
   
   Procedure GetData(xbtn_ID)
      Protected *XButtonData._xButton = #Null
      If GadgetType(xbtn_ID) = #PB_GadgetType_Canvas
         *XButtonData = GetGadgetData(xbtn_ID)
      Else
         DebuggerWarning("Please set a valid gadget number.")
      EndIf
      ProcedureReturn *XButtonData
   EndProcedure
   
   Procedure TextSize(xbtn_ID, FontNum, Text.s, flag)
      Protected result
      If StartVectorDrawing(CanvasVectorOutput(xbtn_ID))
         If IsFont(FontNum)
            VectorFont(FontID(FontNum))
            If flag = #xButton_TextWidth
               result =  VectorTextWidth(Text)+1
            ElseIf flag = #xButton_TextHeight
               result =  VectorTextHeight(Text)+1
            EndIf
         EndIf
         StopVectorDrawing()
      EndIf
      ProcedureReturn result
   EndProcedure
   
   Procedure Relation(xbtn_ID)
      
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      
      If *XButtonData
         
         With *XButtonData
            
            If \IaT_relation = #XBTN_Relation_Icon_Above_Text
               
               If Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Top_Left) |
                  Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Top_Center) |
                  Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Top_Right)
                  
                  \TextOptions\_Y  + (\IconOptions\_H + 2)
                  
               ElseIf Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Middle_Left)  |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Middle_Center) |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Middle_Right)
                  
                  \IconOptions\_Y = (\Height >>1) - ((\TextOptions\_H + \IconOptions\_H) >>1)
                  \TextOptions\_Y  = (\IconOptions\_Y + \IconOptions\_H) + 2
                  
               ElseIf Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Bottom_Left) |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Bottom_Center) |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Bottom_Right)
                  
                  \IconOptions\_Y = (\TextOptions\_Y - \IconOptions\_H) - 2
                  
               EndIf
               
            ElseIf \IaT_relation = #XBTN_Relation_Icon_Before_Text
               
               If Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Top_Left) |
                  Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Middle_Left) |
                  Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Bottom_Left)
                  
                  \TextOptions\_X + (\IconOptions\_W + 2)
                  
               ElseIf Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Top_Center) |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Middle_Center) |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Bottom_Center)
                  
                  \IconOptions\_X = (\Width >>1) - ((\TextOptions\_W + \IconOptions\_W) >>1)
                  \TextOptions\_X  = (\IconOptions\_X + \IconOptions\_W) + 2
                  
               ElseIf Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Top_Right) |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Middle_Right) |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Bottom_Right)
                  
                  \IconOptions\_X = (\TextOptions\_X - \IconOptions\_W) - 2
                  
               EndIf     
               
            ElseIf \IaT_relation = #XBTN_Relation_Text_Above_Icon
               
               If Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Top_Left) |
                  Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Top_Center) |
                  Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Top_Right)
                  
                  \IconOptions\_Y = (\TextOptions\_Y + \TextOptions\_H) + 2
                  
               ElseIf Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Middle_Left) |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Middle_Center) |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Middle_Right)
                  
                  \TextOptions\_Y = (\Height >>1) - ((\TextOptions\_H + \IconOptions\_H) >>1)
                  \IconOptions\_Y = (\TextOptions\_Y + \TextOptions\_H) + 2
                  
               ElseIf Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Bottom_Left) |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Bottom_Center) |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Bottom_Right)
                  
                  \TextOptions\_Y = (\IconOptions\_Y - \TextOptions\_H) - 2
                  
               EndIf
               
            ElseIf \IaT_relation = #XBTN_Relation_Text_Before_Icon
               
               If Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Top_Left) |
                  Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Middle_Left) |
                  Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Bottom_Left)
                  
                  \IconOptions\_X = (\TextOptions\_X + \TextOptions\_W) + 2
                  
               ElseIf Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Top_Center) |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Middle_Center) |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Bottom_Center)
                  
                  
                  \TextOptions\_X  =  (\Width >>1) - ((\TextOptions\_W + \IconOptions\_W) >>1)
                  \IconOptions\_X =  (\TextOptions\_X + \TextOptions\_W) + 2
                  
               ElseIf Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Top_Right) |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Middle_Right) |
                      Check_Align(\IconOptions\_IconAlign,\TextOptions\_TextAlign,#XBTN_Align_Bottom_Right)
                  
                  \TextOptions\_X - (\IconOptions\_W + 2)
                  
               EndIf       
            EndIf
         EndWith
      EndIf
   EndProcedure
   
   Procedure IconAlignment(xbtn_ID)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData
            Select \IconOptions\_IconAlign
               Case #XBTN_Align_Top_Right
                  \IconOptions\_X = (\Width- \IconOptions\_W)-8
                  \IconOptions\_Y = 8
               Case #XBTN_Align_Top_Left
                  \IconOptions\_X = 8
                  \IconOptions\_Y = 8
               Case #XBTN_Align_Top_Center
                  \IconOptions\_X = (\Width >>1)-(\IconOptions\_W >>1)
                  \IconOptions\_Y = 8   
               Case #XBTN_Align_Middle_Right
                  \IconOptions\_X = (\Width- \IconOptions\_W)-8
                  \IconOptions\_Y = (\Height >>1)-(\IconOptions\_H >>1)     
               Case #XBTN_Align_Middle_Left
                  \IconOptions\_X = 8
                  \IconOptions\_Y = (\Height >>1)-(\IconOptions\_H >>1)     
               Case #XBTN_Align_Middle_Center
                  \IconOptions\_X = (\Width >>1)-(\IconOptions\_W >>1)
                  \IconOptions\_Y = (\Height >>1)-(\IconOptions\_H >>1)
               Case #XBTN_Align_Bottom_Right
                  \IconOptions\_X = (\Width-\IconOptions\_W)-8
                  \IconOptions\_Y = (\Height-\IconOptions\_H)-8
               Case #XBTN_Align_Bottom_Left
                  \IconOptions\_X = 8
                  \IconOptions\_Y = (\Height-\IconOptions\_H)-8       
               Case #XBTN_Align_Bottom_Center
                  \IconOptions\_X = (\Width >>1)-(\IconOptions\_W >>1)
                  \IconOptions\_Y = (\Height-\IconOptions\_H)-8     
            EndSelect
         EndWith
      EndIf
   EndProcedure
   
   Procedure TextAlignment(xbtn_ID)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData
            Select \TextOptions\_TextAlign
               Case #XBTN_Align_Top_Right
                  \TextOptions\_X = (\Width-\TextOptions\_W)-10
                  \TextOptions\_Y = 8
               Case #XBTN_Align_Top_Left
                  \TextOptions\_X = 10
                  \TextOptions\_Y = 8
               Case #XBTN_Align_Top_Center
                  \TextOptions\_X = (\Width >>1)-(\TextOptions\_W >>1)
                  \TextOptions\_Y = 8   
               Case #XBTN_Align_Middle_Right
                  \TextOptions\_X = (\Width-\TextOptions\_W)-10
                  \TextOptions\_Y = (\Height >>1)-(\TextOptions\_H >>1)     
               Case #XBTN_Align_Middle_Left
                  \TextOptions\_X = 10
                  \TextOptions\_Y = (\Height >>1)-(\TextOptions\_H >>1)     
               Case #XBTN_Align_Middle_Center
                  \TextOptions\_X = (\Width >>1)-(\TextOptions\_W >>1)
                  \TextOptions\_Y = (\Height >>1)-(\TextOptions\_H >>1)
               Case #XBTN_Align_Bottom_Right
                  \TextOptions\_X = (\Width-\TextOptions\_W)-10
                  \TextOptions\_Y = (\Height-\TextOptions\_H)-8
               Case #XBTN_Align_Bottom_Left
                  \TextOptions\_X = 10
                  \TextOptions\_Y = (\Height-\TextOptions\_H)-8       
               Case #XBTN_Align_Bottom_Center
                  \TextOptions\_X = (\Width >>1)-(\TextOptions\_W >>1)
                  \TextOptions\_Y = (\Height-\TextOptions\_H)-8     
            EndSelect
         EndWith
      EndIf   
   EndProcedure
   
   Procedure Draw(xbtn_ID, color)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData
            TextAlignment(\ID)       
            IconAlignment(\ID)
            If \IaT_relation <> #XBTN_Relation_Overlay
               Relation(\ID)
            EndIf       
            If StartVectorDrawing(CanvasVectorOutput(\ID))
               VectorSourceColor(Color)
               AddPathBox(0,0,\Width,\Height)
               FillPath()
               If Len(\Text)
                  If IsFont(\TextOptions\_FontNum)
                     VectorFont(FontID(\TextOptions\_FontNum))
                     VectorSourceColor(\TextOptions\_Color)
                     MovePathCursor(\TextOptions\_X,\TextOptions\_Y)
                     DrawVectorParagraph(\Text,\TextOptions\_W,\TextOptions\_H,\TextOptions\_ReadOrder)
                  EndIf
               EndIf
               If IsImage(\ImageNum)
                  MovePathCursor(\IconOptions\_X,\IconOptions\_Y)
                  DrawVectorImage(ImageID(\ImageNum))
               EndIf 
               If \State = #XBTN_State_MarkerMode Or \State = #XBTN_State_CombinedMode
                  Protected XBTN_CenterWidth, XBTN_CenterHeight, XMC_Width, XMC_Height ;XMC = XBTN Marker Center
                  XBTN_CenterHeight = \Height  >>1
                  XBTN_CenterWidth  = \Width   >>1
                  XMC_Width   = \MarkerOptions\Width  >>1
                  XMC_Height  = \MarkerOptions\Height >>1
                  VectorSourceColor(\MarkerOptions\Color)
                  If \MarkerOptions\Align = #XBTN_Marker_Left
                     AddPathBox(0,(XBTN_CenterHeight-XMC_Height),\MarkerOptions\Width,\MarkerOptions\Height)
                  ElseIf \MarkerOptions\Align = #XBTN_Marker_Right
                     AddPathBox((\Width-\MarkerOptions\Width),(XBTN_CenterHeight-XMC_Height),\MarkerOptions\Width,\MarkerOptions\Height)
                  ElseIf \MarkerOptions\Align = #XBTN_Marker_Top
                     AddPathBox((XBTN_CenterWidth-XMC_Width),0,\MarkerOptions\Width,\MarkerOptions\Height)
                  ElseIf \MarkerOptions\Align = #XBTN_Marker_Bottom
                     AddPathBox((XBTN_CenterWidth-XMC_Width),(\Height-\MarkerOptions\Height),\MarkerOptions\Width,\MarkerOptions\Height)
                  EndIf
                  FillPath()
               EndIf
               If \BorderOptions\BorderFlag And \State <> #XBTN_State_MarkerMode And \State <> #XBTN_State_CombinedMode
                  AddPathBox(0, 0, \Width, \Height)
                  VectorSourceColor(\BorderOptions\BorderColor)
                  StrokePath(\BorderOptions\BorderSize)
               EndIf
               StopVectorDrawing()
            EndIf
         EndWith
      EndIf
   EndProcedure
   
   Procedure EventManager()
      Protected E_ID,E_Type,*XButtonData._xButton
      E_ID = EventGadget()
      E_Type = EventType()
      *XButtonData._xButton = GetData(E_ID)   
      If *XButtonData
         With *XButtonData
            If E_Type = #PB_EventType_MouseEnter
               Draw(\ID,\BackgroundColor\bgColor_OnEnter)
            ElseIf E_Type = #PB_EventType_MouseLeave       
               Draw(\ID,\BackgroundColor\bgColor_Normal)
            ElseIf E_Type = #PB_EventType_Resize
               \Width  = DesktopScaledX(GadgetWidth(\ID))
               \Height = DesktopScaledY(GadgetHeight(\ID))
            EndIf
         EndWith
      EndIf
   EndProcedure
   
   Procedure INTERNAL_XBTN_REDRAW(*XButtonData._xButton,ReDraw,RedrawState)
      With *XButtonData
         If ReDraw
            If RedrawState = #XBTN_BGColor_Normal
               Draw(\ID,\BackgroundColor\bgColor_Normal)
            ElseIf  RedrawState = #XBTN_BGColor_OnEnter
               Draw(\ID,\BackgroundColor\bgColor_OnEnter)
            EndIf 
         EndIf 
      EndWith
   EndProcedure 
   
   ;-#####################
   ;- External Procedures
   ;-#####################
   
   Procedure Create(xbtn_ID, X, Y, Width, Height, Text.s = "", ImageNum = #PB_Ignore)
      Protected result
      result = CanvasGadget(xbtn_ID, X, Y, Width, Height)
      If result
         If xbtn_ID = #PB_Any
            xbtn_ID = result
         EndIf  
         Protected *XButtonData._xButton = AllocateStructure(_xButton)
         Protected NormalColor = RGBA(70, 130, 180, 255)
         If *XButtonData
            With *XButtonData
               \ID = xbtn_ID
               \Width = DesktopScaledX(Width)
               \Height = DesktopScaledY(Height)
               \Text = Text
               \TextOptions\_FontNum = xfont
               \TextOptions\_Color = RGBA(255,255,255,255)     
               \TextOptions\_W = TextSize(\ID,xfont,\Text,#xButton_TextWidth)
               \TextOptions\_H = TextSize(\ID,xfont,\Text,#xButton_TextHeight)
               If IsImage(ImageNum) 
                  \ImageNum = ImageNum 
                  \IconOptions\_W = ImageWidth(\ImageNum)
                  \IconOptions\_H = ImageHeight(\ImageNum)
               EndIf         
               \IconOptions\_IconAlign = #XBTN_Align_Middle_Left
               \TextOptions\_TextAlign = #XBTN_Align_Middle_Left
               \IaT_relation = #XBTN_Relation_Icon_Before_Text
               \BackgroundColor\bgColor_Normal = NormalColor
               \BackgroundColor\bgColor_OnEnter = RGBA(67, 116, 157, 255)
               \BackgroundColor\bgColor_Temp = NormalColor
            EndWith
         EndIf
         SetGadgetData(xbtn_ID, *XButtonData)
         BindGadgetEvent(xbtn_ID,@EventManager())     
         Draw(xbtn_ID,NormalColor)
      EndIf 
      ProcedureReturn result 
   EndProcedure
   
   Procedure Free(xbtn_ID)
      Protected *XButtonData._xButton = GetData(xbtn_ID)     
      If *XButtonData
         FreeStructure(*XButtonData)
      EndIf   
      UnbindGadgetEvent(xbtn_ID,@EventManager())
      FreeGadget(xbtn_ID)
   EndProcedure
   
   Procedure ReDraw(xbtn_ID, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         INTERNAL_XBTN_REDRAW(*XButtonData,#True,RedrawState)
      EndIf
   EndProcedure
   
   Procedure SetIconTextRelation(xbtn_ID, Relation, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData
            \IaT_relation = Relation
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)
      EndIf
   EndProcedure
   
   Procedure SetBackgroundColor(xbtn_ID, State, Color, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData
            If State = #XBTN_BGColor_Normal
               \BackgroundColor\bgColor_Normal = Color
               \BackgroundColor\bgColor_Temp   = Color
            ElseIf State = #XBTN_BGColor_OnEnter
               \BackgroundColor\bgColor_OnEnter = Color
            EndIf
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)
      EndIf       
   EndProcedure
   
   Procedure SetIconAlign(xbtn_ID, Align, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData
            \IconOptions\_IconAlign = Align
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)
      EndIf
   EndProcedure
   
   Procedure SetTextAlign(xbtn_ID, Align, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData
            \TextOptions\_TextAlign = Align
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)   
      EndIf
   EndProcedure
   
   Procedure SetTextFont(xbtn_ID, fontNum, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData
            If IsFont(fontNum)
               \TextOptions\_FontNum = fontNum
               \TextOptions\_W = TextSize(\ID,\TextOptions\_FontNum,\Text,#xButton_TextWidth)
               \TextOptions\_H = TextSize(\ID,\TextOptions\_FontNum,\Text,#xButton_TextHeight)
            EndIf
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)
      EndIf
   EndProcedure
   
   Procedure SetTextColor(xbtn_ID, Color, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData
            \TextOptions\_Color = Color
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)
      EndIf   
   EndProcedure
   
   Procedure SetText(xbtn_ID, Text.s = "", ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData   
            \Text = Text
            \TextOptions\_W = TextSize(\ID,\TextOptions\_FontNum,\Text,#xButton_TextWidth)
            \TextOptions\_H = TextSize(\ID,\TextOptions\_FontNum,\Text,#xButton_TextHeight)
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)
      EndIf
   EndProcedure
   
   Procedure SetTextX(xbtn_ID, X, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData 
            \TextOptions\_X = X
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)
      EndIf  
   EndProcedure
   
   Procedure SetTextY(xbtn_ID, Y, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData 
            \TextOptions\_Y = Y
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)
      EndIf  
   EndProcedure
   
   Procedure SetIcon(xbtn_ID, ImageNum, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData
            If IsImage(ImageNum)
               \ImageNum = ImageNum
               \IconOptions\_W = ImageWidth(\ImageNum)
               \IconOptions\_H = ImageHeight(\ImageNum)
            EndIf
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)
      EndIf
   EndProcedure
   
   Procedure SetIconX(xbtn_ID, X, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData 
            \IconOptions\_X = X
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)
      EndIf  
   EndProcedure
   
   Procedure SetIconY(xbtn_ID, Y, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData 
            \IconOptions\_Y = Y
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)
      EndIf  
   EndProcedure   
   
   Procedure SetState(xbtn_ID, State, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData
            Select State
               Case #XBTN_State_SelectMode
                  \BackgroundColor\bgColor_Normal = \BackgroundColor\bgColor_OnEnter
                  \State = #XBTN_State_SelectMode
               Case  #XBTN_State_MarkerMode
                  \State = #XBTN_State_MarkerMode
               Case #XBTN_State_Default
                  \BackgroundColor\bgColor_Normal = \BackgroundColor\bgColor_Temp
                  \State = #XBTN_State_Default   
               Case #XBTN_State_CombinedMode  
                  \BackgroundColor\bgColor_Normal = \BackgroundColor\bgColor_OnEnter
                  \State = #XBTN_State_CombinedMode
            EndSelect   
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)
      EndIf   
   EndProcedure
   
   Procedure SetReadOrder(xbtn_ID, ReadOrder, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData
            \TextOptions\_ReadOrder = ReadOrder
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)   
      EndIf   
   EndProcedure
   
   Procedure SetMarkerSettings(xbtn_ID, Width = #PB_Ignore, Height = #PB_Ignore, Align = #PB_Ignore, Color = 0, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData
            If Width <> #PB_Ignore
               \MarkerOptions\Width = DesktopScaledX(Width)
            EndIf        
            If Height <> #PB_Ignore
               \MarkerOptions\Height = DesktopScaledY(Height)
            EndIf     
            If Align <> #PB_Ignore
               \MarkerOptions\Align = Align
            EndIf        
            If Color
               \MarkerOptions\Color = Color
            EndIf
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)   
      EndIf   
   EndProcedure
   
   Procedure GetProperties(xbtn_ID, Property.s)
      Protected result
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData  
            Select Property
               Case "XBTN_Marker_Width"      : result = \MarkerOptions\Width
               Case "XBTN_Marker_Height"     : result = \MarkerOptions\Height
               Case "XBTN_Marker_Color"      : result = \MarkerOptions\Color
               Case "XBTN_Marker_Align"      : result = \MarkerOptions\Align
                  
               Case "XBTN_BGColor_Normal"    : result = \BackgroundColor\bgColor_Normal
               Case "XBTN_BGColor_OnEnter"   : result = \BackgroundColor\bgColor_OnEnter
                  
               Case "XBTN_Text_Color"        : result = \TextOptions\_Color
               Case "XBTN_Text_ReadOrder"    : result = \TextOptions\_ReadOrder 
               Case "XBTN_Text_X"            : result = \TextOptions\_X
               Case "XBTN_Text_Y"            : result = \TextOptions\_Y
               Case "XBTN_Text_Width"        : result = \TextOptions\_W  
               Case "XBTN_Text_Height"       : result = \TextOptions\_H
               Case "XBTN_Text_Align"        : result = \TextOptions\_TextAlign
                  
               Case "XBTN_Icon_X"            : result = \IconOptions\_X
               Case "XBTN_Icon_Y"            : result = \IconOptions\_Y
               Case "XBTN_Icon_Width"        : result = \IconOptions\_W 
               Case "XBTN_Icon_Height"       : result = \IconOptions\_H
               Case "XBTN_Icon_Align"        : result = \IconOptions\_IconAlign          
                  
               Case "XBTN_BorderFlag"        : result = \BorderOptions\BorderFlag
               Case "XBTN_BorderColor"       : result = \BorderOptions\BorderColor
               Case "XBTN_BorderSize"        : result = \BorderOptions\BorderSize
                  
               Case "XBTN_Width"             : result = \Width
               Case "XBTN_Height"            : result = \Height 
               Case "XBTN_Text"              : result = @\Text
               Case "XBTN_State"             : result = \State 
               Case "XBTN_IconTextRelation"  : result = \IaT_relation 
               Case "XBTN_X"                 : result = GadgetX(\ID) 
               Case "XBTN_Y"                 : result = GadgetY(\ID)
            EndSelect
         EndWith  
      EndIf 
      ProcedureReturn result
   EndProcedure
   
   Procedure SetBorder(xbtn_ID, State, Size, Color, ReDraw = #False, RedrawState = #XBTN_BGColor_Normal)
      Protected *XButtonData._xButton = GetData(xbtn_ID)
      If *XButtonData
         With *XButtonData
            \BorderOptions\BorderFlag = State
            \BorderOptions\BorderSize = Size
            \BorderOptions\BorderColor = Color
         EndWith
         INTERNAL_XBTN_REDRAW(*XButtonData,ReDraw,RedrawState)  
      EndIf  
   EndProcedure  
   
   
EndModule


; IncludeFile "xButton.pbi"
CompilerIf #PB_Compiler_IsMainFile
   
   Enumeration
      #MainWindow
      #ResizeWindow
      #Canvas
      #CanvasFont
      #xbtn_Demo1
      #xbtn_Demo2
      #xbtn_Demo3
      
      #Container_Demo1
      #xbtn4
      #xbtn5
      #xbtn6
      #xbtn7
      #xbtn8
      #xbtn9
      #xbtn10
      #xbtn11
      #xbtn12 
      
      #Container_Demo2
      #_MyxButton
      #_ImageAlignCombo
      #_TextAlignCombo
      #_ImageAndTextRelationCombo
      #ReadOrderCombo
      #_SetImageBTN
      #_SetTextBTN
      #_Input
      #_FontBTN
      #_NormalColorBTN
      #_OnEnterColorBTN
      #_resizeBTN
      #Resizexbtn
      
      #Container_Demo3
      #xbtn1
      #xbtn2
      #xbtn3
      #xbtn100
      #xbtn101
      #xbtn102 
      #xbtn200
      #xbtn201
      #xbtn202
      #xbtn203
   EndEnumeration
   
   Structure xbtn_BGC
      normal.l
      onEnter.l
   EndStructure
   
   Title.s = "Start Page"
   Global  Dim TileBGColor.xbtn_BGC(4),fnt.l
   
   TileBGColor(0)\normal = RGBA(30,144,255,255)
   TileBGColor(0)\onEnter = RGBA(14,129,242,255)
   TileBGColor(1)\normal = RGBA(255,20,147,255)
   TileBGColor(1)\onEnter = RGBA(235,12,132,255)
   TileBGColor(2)\normal = RGBA(220,20,60,255)
   TileBGColor(2)\onEnter = RGBA(189,26,59,255)
   TileBGColor(3)\normal = RGBA(255,140,0,255)
   TileBGColor(3)\onEnter = RGBA(218,124,11,255)
   TileBGColor(4)\normal = RGBA(0,128,128,255)
   TileBGColor(4)\onEnter = RGBA(5,109,109,255)
   
   UsePNGImageDecoder()
   UseJPEGImageDecoder()
   UseJPEG2000ImageDecoder()
   UseTGAImageDecoder()
   UseTIFFImageDecoder()
   
   OpenWindow(#MainWindow,0,0,760,480,"xButton",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_MinimizeGadget)
   
   UseModule xButton
   
   If CanvasGadget(#Canvas,0,0,230,480,#PB_Canvas_Container)
      
      LoadFont(#CanvasFont, "Segoe UI", 0,#PB_Font_HighQuality)
      
      StartVectorDrawing(CanvasVectorOutput(#Canvas))
      VectorSourceColor(RGBA(220,20,60,255))
      AddPathBox(0,0,DesktopScaledX(300),DesktopScaledY(480))
      FillPath()
      VectorFont(FontID(#CanvasFont),30)
      VectorSourceColor(RGBA(255, 255, 255, 255))
      MovePathCursor(10, 5)
      DrawVectorParagraph(Title, VectorTextWidth(Title), VectorTextHeight(Title))
      StopVectorDrawing()
      FreeFont(#CanvasFont)
      
      xButton::Create(#xbtn_Demo1,0,60,230,60,"Demo 1")
      xButton::Create(#xbtn_Demo2,0,120,230,60,"Demo 2")
      xButton::Create(#xbtn_Demo3,0,180,230,60,"Demo 3")
      
      For i = #xbtn_Demo1 To #xbtn_Demo3
         xButton::SetBackgroundColor(i,xButton::#XBTN_BGColor_Normal,RGBA(220,20,60,255))
         xButton::SetBackgroundColor(i,xButton::#XBTN_BGColor_OnEnter,RGBA(189,26,59,255),#True)
      Next
      xButton::SetState(#xbtn_Demo1,xButton::#XBTN_State_SelectMode,#True)
      CloseGadgetList()
   EndIf   
   
   ContainerGadget(#Container_Demo1,232,2,524,474,#PB_Container_BorderLess)
   HideGadget(#Container_Demo1, 1)
   SetGadgetColor(#Container_Demo1,#PB_Gadget_BackColor,RGB(51, 57, 118))
   
   xButton::Create(#xbtn4,40,70,110,110,"Tile 1")
   xButton::Create(#xbtn5,155,70,110,110,"Tile 2")
   xButton::Create(#xbtn6,270,70,110,110,"Tile 3")
   xButton::Create(#xbtn7,385,70,110,110,"Tile 4")
   xButton::Create(#xbtn8,40,185,225,225,"Tile 5")   
   xButton::Create(#xbtn9,270,185,110,110,"Tile 6")
   xButton::Create(#xbtn10,385,185,110,110,"Tile 7")
   xButton::Create(#xbtn11,270,300,110,110,"Tile 8")
   xButton::Create(#xbtn12,385,300,110,110,"Tile 9")
   
   g = 0
   For i = #xbtn4 To #xbtn12
      If i <= #xbtn8
         xButton::SetBackgroundColor(i,xButton::#XBTN_BGColor_Normal,TileBGColor(g)\normal)
         xButton::SetBackgroundColor(i,xButton::#XBTN_BGColor_OnEnter,TileBGColor(g)\onEnter)
      EndIf
      xButton::SetTextAlign(i,xButton::#XBTN_Align_Bottom_Left,#True)
      g + 1
   Next
   HideGadget(#Container_Demo1, 0) 
   CloseGadgetList()
   
   ContainerGadget(#Container_Demo2,232,2,524,474,#PB_Container_BorderLess)
   HideGadget(#Container_Demo2, 1)
   xButton::Create(#_MyxButton,150,50,220,150,"Microsoft Visual"+#LF$+"Studio 2017")
   xButton::SetTextAlign(#_MyxButton,xButton::#XBTN_Align_Bottom_Left)
   xButton::SetIconAlign(#_MyxButton,xButton::#XBTN_Align_Middle_Center)
   xButton::SetIconTextRelation(#_MyxButton,xButton::#XBTN_Relation_Overlay)
   xButton::SetBackgroundColor(#_MyxButton,xButton::#XBTN_BGColor_Normal,RGBA(0,128,0,255))
   xButton::SetBackgroundColor(#_MyxButton,xButton::#XBTN_BGColor_OnEnter,RGBA(0,98,0,255),#True)
   
   TextGadget(#PB_Any,20,240,100,20,"Icon Align")
   ComboBoxGadget(#_ImageAlignCombo,20,260,140,30)
   AddGadgetItem(#_ImageAlignCombo,-1,"Icon_Top_Left")
   SetGadgetItemData(#_ImageAlignCombo, 0, xButton::#XBTN_Align_Top_Left)
   AddGadgetItem(#_ImageAlignCombo,-1,"Icon_Top_Center")
   SetGadgetItemData(#_ImageAlignCombo, 1, xButton::#XBTN_Align_Top_Center)
   AddGadgetItem(#_ImageAlignCombo,-1,"Icon_Top_Right")
   SetGadgetItemData(#_ImageAlignCombo, 2, xButton::#XBTN_Align_Top_Right)
   AddGadgetItem(#_ImageAlignCombo,-1,"Icon_Middle_Left")
   SetGadgetItemData(#_ImageAlignCombo, 3, xButton::#XBTN_Align_Middle_Left)
   AddGadgetItem(#_ImageAlignCombo,-1,"Icon_Middle_Center")
   SetGadgetItemData(#_ImageAlignCombo, 4, xButton::#XBTN_Align_Middle_Center)
   AddGadgetItem(#_ImageAlignCombo,-1,"Icon_Middle_Right")
   SetGadgetItemData(#_ImageAlignCombo, 5, xButton::#XBTN_Align_Middle_Right)
   AddGadgetItem(#_ImageAlignCombo,-1,"Icon_Bottom_Left")
   SetGadgetItemData(#_ImageAlignCombo, 6, xButton::#XBTN_Align_Bottom_Left)
   AddGadgetItem(#_ImageAlignCombo,-1,"Icon_Bottom_Center")
   SetGadgetItemData(#_ImageAlignCombo, 7, xButton::#XBTN_Align_Bottom_Center)
   AddGadgetItem(#_ImageAlignCombo,-1,"Icon_Bottom_Right")
   SetGadgetItemData(#_ImageAlignCombo, 8, xButton::#XBTN_Align_Bottom_Right)
   SetGadgetState(#_ImageAlignCombo,4)
   
   TextGadget(#PB_Any,180,240,100,20,"Text Align")
   ComboBoxGadget(#_TextAlignCombo,180,260,140,30)
   AddGadgetItem(#_TextAlignCombo,-1,"Text_Top_Left")
   SetGadgetItemData(#_TextAlignCombo, 0, xButton::#XBTN_Align_Top_Left)
   AddGadgetItem(#_TextAlignCombo,-1,"Text_Top_Center")
   SetGadgetItemData(#_TextAlignCombo, 1, xButton::#XBTN_Align_Top_Center)
   AddGadgetItem(#_TextAlignCombo,-1,"Text_Top_Right")
   SetGadgetItemData(#_TextAlignCombo, 2, xButton::#XBTN_Align_Top_Right)
   AddGadgetItem(#_TextAlignCombo,-1,"Text_Middle_Left")
   SetGadgetItemData(#_TextAlignCombo, 3, xButton::#XBTN_Align_Middle_Left)
   AddGadgetItem(#_TextAlignCombo,-1,"Text_Middle_Center")
   SetGadgetItemData(#_TextAlignCombo, 4, xButton::#XBTN_Align_Middle_Center)
   AddGadgetItem(#_TextAlignCombo,-1,"Text_Middle_Right")
   SetGadgetItemData(#_TextAlignCombo, 5, xButton::#XBTN_Align_Middle_Right)
   AddGadgetItem(#_TextAlignCombo,-1,"Text_Bottom_Left")
   SetGadgetItemData(#_TextAlignCombo, 6, xButton::#XBTN_Align_Bottom_Left)
   AddGadgetItem(#_TextAlignCombo,-1,"Text_Bottom_Center")
   SetGadgetItemData(#_TextAlignCombo, 7, xButton::#XBTN_Align_Bottom_Center)
   AddGadgetItem(#_TextAlignCombo,-1,"Text_Bottom_Right")
   SetGadgetItemData(#_TextAlignCombo, 8, xButton::#XBTN_Align_Bottom_Right)
   SetGadgetState(#_TextAlignCombo,6)   
   
   TextGadget(#PB_Any,340,240,150,20,"Icon And text Relation")
   ComboBoxGadget(#_ImageAndTextRelationCombo,340,260,155,30)
   AddGadgetItem(#_ImageAndTextRelationCombo,-1,"Overlay")
   SetGadgetItemData(#_ImageAndTextRelationCombo, 0, xButton::#XBTN_Relation_Overlay)
   AddGadgetItem(#_ImageAndTextRelationCombo,-1,"Icon_Above_Text")
   SetGadgetItemData(#_ImageAndTextRelationCombo, 1, xButton::#XBTN_Relation_Icon_Above_Text)
   AddGadgetItem(#_ImageAndTextRelationCombo,-1,"Icon_Before_Text")
   SetGadgetItemData(#_ImageAndTextRelationCombo, 2, xButton::#XBTN_Relation_Icon_Before_Text)
   AddGadgetItem(#_ImageAndTextRelationCombo,-1,"Text_Above_Icon")
   SetGadgetItemData(#_ImageAndTextRelationCombo, 3, xButton::#XBTN_Relation_Text_Above_Icon)
   AddGadgetItem(#_ImageAndTextRelationCombo,-1,"Text_Before_Icon")
   SetGadgetItemData(#_ImageAndTextRelationCombo, 4, xButton::#XBTN_Relation_Text_Before_Icon)
   SetGadgetState(#_ImageAndTextRelationCombo,0)   
   
   TextGadget(#PB_Any,20,310,150,20,"Read Order")
   ComboBoxGadget(#ReadOrderCombo,20,330,100,30)
   AddGadgetItem(#ReadOrderCombo,-1,"Left")
   SetGadgetItemData(#ReadOrderCombo, 0, xButton::#XBTN_ReadOrder_Left)
   AddGadgetItem(#ReadOrderCombo,-1,"Center")
   SetGadgetItemData(#ReadOrderCombo, 1, xButton::#XBTN_ReadOrder_Center)
   AddGadgetItem(#ReadOrderCombo,-1,"Right")
   SetGadgetItemData(#ReadOrderCombo, 2, xButton::#XBTN_ReadOrder_Right)
   SetGadgetState(#ReadOrderCombo,0) 
   
   EditorGadget(#_Input,280,385,150,65)
   SetGadgetText(#_Input,"Microsoft Visual"+#LF$+"Studio 2017")
   ButtonGadget(#_SetTextBTN,435,385,60,30,"Set Text")
   ButtonGadget(#_FontBTN,435,420,60,30,"Font")
   ButtonGadget(#_SetImageBTN,20,385,100,30,"Set Icon")
   ButtonGadget(#_NormalColorBTN,130,385,100,30,"Normal Color")
   ButtonGadget(#_OnEnterColorBTN,130,420,100,30,"OnEnter Color")
   ButtonGadget(#_resizeBTN,130,330,365,30,"Resize")
   CloseGadgetList()
   
   
   ContainerGadget(#Container_Demo3,232,2,524,474,#PB_Container_BorderLess)
   HideGadget(#Container_Demo3, 1)
   SetGadgetColor(#Container_Demo3,#PB_Gadget_BackColor,RGB(51, 57, 118))
   
   xButton::Create(#xbtn3,300,30,80,80,"Tab3")
   xButton::Create(#xbtn2,220,30,80,80,"tab2")
   xButton::Create(#xbtn1,140,30,80,80,"tab1")
   
   xButton::SetState(#xbtn1,xButton::#XBTN_State_CombinedMode,#True)
   For i = #xbtn1 To #xbtn3
      xButton::SetTextAlign(i,xButton::#XBTN_Align_Middle_Center)
      xButton::SetMarkerSettings(i,80,5,xButton::#XBTN_Marker_Top,RGBA(100,200,255,180),#True)
   Next
   
   xButton::Create(#xbtn100,301,380,80,80,"Task Btn1")
   xButton::Create(#xbtn101,220,380,80,80,"Task Btn2")
   xButton::Create(#xbtn102,139,380,80,80,"Task Btn3") 
   
   For i = #xbtn100 To #xbtn102
      xButton::SetState(i,xButton::#XBTN_State_MarkerMode)
      xButton::SetTextAlign(i,xButton::#XBTN_Align_Middle_Center)
      xButton::SetMarkerSettings(i,GadgetWidth(i)-10,4,xButton::#XBTN_Marker_Bottom,RGBA(242,242,0,230),#True)
   Next
   
   xButton::Create(#xbtn200,170,150,180,50,"  xbtn 1")
   xButton::Create(#xbtn201,170,200,180,50,"  xbtn 2")
   xButton::Create(#xbtn202,170,250,180,50,"  xbtn 3")   
   xButton::Create(#xbtn203,170,300,180,50,"  xbtn 4")
   
   xButton::SetState(#xbtn200,xButton::#XBTN_State_MarkerMode,#True)
   xButton::SetMarkerSettings(#xbtn200,5,22,xButton::#XBTN_Marker_Left,RGBA(230,200,0,255),#True)
   xButton::SetMarkerSettings(#xbtn201,5,22,xButton::#XBTN_Marker_Left,RGBA(230,200,0,255),#True)
   xButton::SetMarkerSettings(#xbtn202,5,22,xButton::#XBTN_Marker_Right,RGBA(230,200,0,255),#True)
   xButton::SetMarkerSettings(#xbtn203,5,22,xButton::#XBTN_Marker_Right,RGBA(230,200,0,255),#True)
   CloseGadgetList()
   
   
   
   
   Procedure Xbtn_ResizeWindow_Handler()
      ResizeGadget(#Resizexbtn,#PB_Ignore,#PB_Ignore,WindowWidth(EventWindow())-20,WindowHeight(EventWindow())-20)
      xButton::ReDraw(#Resizexbtn)
   EndProcedure
   
   Procedure Xbtn_ResizeWindow()
      OpenWindow(#ResizeWindow,0,0,300,300,"Resize",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget)
      xButton::Create(#Resizexbtn,10,10,280,280,PeekS(xButton::GetProperties(#_MyxButton,"XBTN_Text")))
      xButton::SetTextAlign(#Resizexbtn,xButton::GetProperties(#_MyxButton,"XBTN_Text_Align"))
      xButton::SetIconAlign(#Resizexbtn,xButton::GetProperties(#_MyxButton,"XBTN_Icon_Align"))
      xButton::SetIconTextRelation(#Resizexbtn,xButton::GetProperties(#_MyxButton,"XBTN_IconTextRelation"))
      xButton::SetBackgroundColor(#Resizexbtn,xButton::#XBTN_BGColor_Normal,xButton::GetProperties(#_MyxButton,"XBTN_BGColor_Normal"))
      xButton::SetBackgroundColor(#Resizexbtn,xButton::#XBTN_BGColor_OnEnter,xButton::GetProperties(#_MyxButton,"XBTN_BGColor_OnEnter"))
      xButton::SetTextColor(#Resizexbtn,xButton::GetProperties(#_MyxButton,"XBTN_Text_Color"))
      xButton::SetTextFont(#Resizexbtn,fnt)
      xButton::SetReadOrder(#Resizexbtn,xButton::GetProperties(#_MyxButton,"XBTN_Text_ReadOrder"))
      xButton::SetIcon(#Resizexbtn,689,#True)
      BindEvent(#PB_Event_SizeWindow, @Xbtn_ResizeWindow_Handler())
   EndProcedure 
   exit = 0
   Repeat
      Event = WaitWindowEvent()
      If Event = #PB_Event_Gadget
         E_Type = EventType()
         Select EventGadget()
            Case #xbtn8
               If E_Type = #PB_EventType_MouseEnter
                  xButton::SetBorder(#xbtn8,#True,8,RGBA(255,255,255,160),#True,xButton::#XBTN_BGColor_OnEnter)
               ElseIf E_Type =  #PB_EventType_MouseLeave 
                  xButton::SetBorder(#xbtn8,#False,0,0,#True,xButton::#XBTN_BGColor_Normal)
               EndIf  
            Case #xbtn200
               If E_Type = #PB_EventType_LeftClick
                  xButton::SetState(#xbtn200,xButton::#XBTN_State_MarkerMode,#True,xButton::#XBTN_BGColor_OnEnter)
                  xButton::SetState(#xbtn201,xButton::#XBTN_State_Default,#True)
                  xButton::SetState(#xbtn202,xButton::#XBTN_State_Default,#True) 
                  xButton::SetState(#xbtn203,xButton::#XBTN_State_Default,#True)
               EndIf
            Case #xbtn201
               If E_Type = #PB_EventType_LeftClick
                  xButton::SetState(#xbtn200,xButton::#XBTN_State_Default,#True)
                  xButton::SetState(#xbtn201,xButton::#XBTN_State_MarkerMode,#True,xButton::#XBTN_BGColor_OnEnter)
                  xButton::SetState(#xbtn202,xButton::#XBTN_State_Default,#True) 
                  xButton::SetState(#xbtn203,xButton::#XBTN_State_Default,#True) 
               EndIf
            Case #xbtn202
               If E_Type = #PB_EventType_LeftClick
                  xButton::SetState(#xbtn200,xButton::#XBTN_State_Default,#True)
                  xButton::SetState(#xbtn201,xButton::#XBTN_State_Default,#True)
                  xButton::SetState(#xbtn202,xButton::#XBTN_State_MarkerMode,#True,xButton::#XBTN_BGColor_OnEnter) 
                  xButton::SetState(#xbtn203,xButton::#XBTN_State_Default,#True) 
               EndIf
            Case #xbtn203
               If E_Type = #PB_EventType_LeftClick
                  xButton::SetState(#xbtn200,xButton::#XBTN_State_Default,#True)
                  xButton::SetState(#xbtn201,xButton::#XBTN_State_Default,#True)
                  xButton::SetState(#xbtn202,xButton::#XBTN_State_Default,#True) 
                  xButton::SetState(#xbtn203,xButton::#XBTN_State_MarkerMode,#True,xButton::#XBTN_BGColor_OnEnter) 
               EndIf
            Case #xbtn100
               If E_Type = #PB_EventType_MouseEnter
                  xButton::SetMarkerSettings(#xbtn100,GadgetWidth(#xbtn100),#PB_Ignore,#PB_Ignore,0,#True,xButton::#XBTN_BGColor_OnEnter)
               ElseIf E_Type = #PB_EventType_MouseLeave
                  xButton::SetMarkerSettings(#xbtn100,GadgetWidth(#xbtn100)-10,#PB_Ignore,#PB_Ignore,0,#True)
               EndIf 
            Case #xbtn101
               If E_Type = #PB_EventType_MouseEnter
                  xButton::SetMarkerSettings(#xbtn101,GadgetWidth(#xbtn101),#PB_Ignore,#PB_Ignore,0,#True,xButton::#XBTN_BGColor_OnEnter)
               ElseIf E_Type = #PB_EventType_MouseLeave
                  xButton::SetMarkerSettings(#xbtn101,GadgetWidth(#xbtn101)-10,#PB_Ignore,#PB_Ignore,0,#True)
               EndIf
            Case #xbtn102
               If E_Type = #PB_EventType_MouseEnter
                  xButton::SetMarkerSettings(#xbtn102,80,#PB_Ignore,#PB_Ignore,0,#True,xButton::#XBTN_BGColor_OnEnter)
               ElseIf E_Type = #PB_EventType_MouseLeave
                  xButton::SetMarkerSettings(#xbtn102,70,#PB_Ignore,#PB_Ignore,0,#True)
               EndIf     
            Case #xbtn1
               If E_Type = #PB_EventType_LeftClick
                  xButton::SetState(#xbtn1,xButton::#XBTN_State_CombinedMode,#True,xButton::#XBTN_BGColor_OnEnter)
                  xButton::SetState(#xbtn2,xButton::#XBTN_State_Default,#True)
                  xButton::SetState(#xbtn3,xButton::#XBTN_State_Default,#True)
               EndIf
            Case  #xbtn2
               If E_Type = #PB_EventType_LeftClick
                  xButton::SetState(#xbtn1,xButton::#XBTN_State_Default,#True)
                  xButton::SetState(#xbtn2,xButton::#XBTN_State_CombinedMode,#True,xButton::#XBTN_BGColor_OnEnter)
                  xButton::SetState(#xbtn3,xButton::#XBTN_State_Default,#True)
               EndIf           
            Case  #xbtn3 
               If E_Type = #PB_EventType_LeftClick
                  xButton::SetState(#xbtn1,xButton::#XBTN_State_Default,#True)
                  xButton::SetState(#xbtn2,xButton::#XBTN_State_Default,#True)
                  xButton::SetState(#xbtn3,xButton::#XBTN_State_CombinedMode,#True,xButton::#XBTN_BGColor_OnEnter)
               EndIf           
               ;-------------------------------------------------------------------------------------------         
            Case #xbtn_Demo1 
               If E_Type = #PB_EventType_LeftClick
                  xButton::SetState(#xbtn_Demo1,xButton::#XBTN_State_SelectMode,#True)
                  xButton::SetState(#xbtn_Demo2,xButton::#XBTN_State_Default,#True)
                  xButton::SetState(#xbtn_Demo3,xButton::#XBTN_State_Default,#True)
                  HideGadget(#Container_Demo1, 0)
                  HideGadget(#Container_Demo2, 1)
                  HideGadget(#Container_Demo3, 1)
               EndIf           
            Case #xbtn_Demo2 
               If E_Type = #PB_EventType_LeftClick
                  xButton::SetState(#xbtn_Demo1,xButton::#XBTN_State_Default,#True)
                  xButton::SetState(#xbtn_Demo2,xButton::#XBTN_State_SelectMode,#True)
                  xButton::SetState(#xbtn_Demo3,xButton::#XBTN_State_Default,#True)
                  HideGadget(#Container_Demo2, 0)
                  HideGadget(#Container_Demo1, 1)
                  HideGadget(#Container_Demo3, 1)
               EndIf
            Case #xbtn_Demo3
               If E_Type = #PB_EventType_LeftClick
                  xButton::SetState(#xbtn_Demo1,xButton::#XBTN_State_Default,#True)
                  xButton::SetState(#xbtn_Demo2,xButton::#XBTN_State_Default,#True)
                  xButton::SetState(#xbtn_Demo3,xButton::#XBTN_State_SelectMode,#True)
                  HideGadget(#Container_Demo3, 0)
                  HideGadget(#Container_Demo1, 1)
                  HideGadget(#Container_Demo2, 1)
               EndIf 
               ;-------------------------------------------------------------------------------------------         
            Case #_ImageAlignCombo
               If E_Type = #PB_EventType_Change
                  xButton::SetIconAlign(#_MyxButton,GetGadgetItemData(#_ImageAlignCombo,GetGadgetState(#_ImageAlignCombo)),#True)           
               EndIf     
            Case #_TextAlignCombo
               If E_Type = #PB_EventType_Change
                  xButton::SetTextAlign(#_MyxButton,GetGadgetItemData(#_TextAlignCombo,GetGadgetState(#_TextAlignCombo)),#True)           
               EndIf   
            Case #_ImageAndTextRelationCombo
               If E_Type = #PB_EventType_Change
                  xButton::SetIconTextRelation(#_MyxButton,GetGadgetItemData(#_ImageAndTextRelationCombo,GetGadgetState(#_ImageAndTextRelationCombo)),#True)           
               EndIf   
            Case #ReadOrderCombo
               If E_Type = #PB_EventType_Change
                  xButton::SetReadOrder(#_MyxButton,GetGadgetItemData(#ReadOrderCombo,GetGadgetState(#ReadOrderCombo)),#True)           
               EndIf         
            Case #_SetImageBTN
               If E_Type = #PB_EventType_LeftClick
                  myIcon$ = OpenFileRequester("Please choose file to load", "", "", 0)
                  LoadImage(689,myIcon$)
                  xButton::SetIcon(#_MyxButton,689,#True)
               EndIf
            Case #_SetTextBTN
               If E_Type = #PB_EventType_LeftClick
                  xButton::SetText(#_MyxButton,GetGadgetText(#_Input),#True) 
               EndIf 
            Case #_FontBTN
               If E_Type = #PB_EventType_LeftClick
                  If FontRequester("Segoe UI",18,#PB_FontRequester_Effects)
                     fnt = LoadFont(#PB_Any,SelectedFontName(),SelectedFontSize(),SelectedFontStyle())
                     fnt_color.l = SelectedFontColor()
                     xButton::SetTextColor(#_MyxButton,RGBA(Red(fnt_color),Green(fnt_color),Blue(fnt_color),255))
                     xButton::SetTextFont(#_MyxButton,fnt,#True)
                  EndIf
               EndIf
            Case #_NormalColorBTN
               If E_Type = #PB_EventType_LeftClick
                  _rgba = ColorRequester()
                  If _rgba <> -1
                     xButton::SetBackgroundColor(#_MyxButton,xButton::#XBTN_BGColor_Normal,RGBA(Red(_rgba),Green(_rgba),Blue(_rgba),255),#True)
                  EndIf
               EndIf   
            Case #_OnEnterColorBTN
               If E_Type = #PB_EventType_LeftClick
                  _rgba = ColorRequester()
                  If _rgba <> -1
                     xButton::SetBackgroundColor(#_MyxButton,xButton::#XBTN_BGColor_OnEnter,RGBA(Red(_rgba),Green(_rgba),Blue(_rgba),255),#True)
                  EndIf
               EndIf         
            Case #_resizeBTN
               If E_Type = #PB_EventType_LeftClick
                  Xbtn_ResizeWindow()
               EndIf
         EndSelect   
      ElseIf Event = #PB_Event_CloseWindow
         If EventWindow() = #MainWindow
            exit = 1
         ElseIf EventWindow() = #ResizeWindow
            CloseWindow(#ResizeWindow)
         EndIf   
      EndIf
   Until exit = 1
   
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 7
; Folding = -----------------------
; EnableXP
; DPIAware