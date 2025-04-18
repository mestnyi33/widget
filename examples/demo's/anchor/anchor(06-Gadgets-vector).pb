﻿XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   ; --------- Example ---------
   
   
   EnumerationBinary
      #State_Hidden
      #State_Disabled
      #State_Hovered
      #State_Selected
      #State_LeftMousePushed
      #State_RightMousePushed
      #State_MiddleMousePushed
   EndEnumeration
   #State_Normal = 0
   
   ; Program constants
   Enumeration 1
      #Window
      #Canvas
      #Font
   EndEnumeration
   
   Procedure.s GetObjectDictionary( iObject.i, sName.s ) 
      If sName = "Text"
         ProcedureReturn GetText( iObject )
      EndIf
      If sName = "State"
         ProcedureReturn Str(GetState( iObject ))
      EndIf
   EndProcedure
   
   Procedure.i ObjectState(*Object._s_WIDGET)
      
      Protected eState.i
      
      If *Object\disable : eState | #State_Disabled : EndIf
      If *Object\hide    : eState | #State_Hidden   : EndIf
      
      If Not a_index( )
         If *Object\enter    
            eState | #State_Hovered 
         EndIf
         
         If *Object\press   
            eState | #State_Selected 
            If MouseButtonPress( ) = #PB_MouseButton_Left
               eState | #State_LeftMousePushed
            EndIf
            If MouseButtonPress( ) = #PB_MouseButton_Right
               eState | #State_RightMousePushed
            EndIf
            If MouseButtonPress( ) = #PB_MouseButton_Middle
               eState | #State_MiddleMousePushed
            EndIf
         EndIf
      EndIf
      
      ProcedureReturn eState
      
   EndProcedure
   
   Procedure.i HSVA(Hue.i, Saturation.i, Value.i, Aplha.i=255) ; [0,360], [0,100], [0,255], [0,255]
      Protected H.i = Int(Hue/60)
      Protected f.f = (Hue/60-H)
      Protected p = Value * (1-Saturation/100.0)
      Protected q = Value * (1-Saturation/100.0*f)
      Protected t = Value * (1-Saturation/100.0*(1-f))
      Select H
         Case 1 : ProcedureReturn RGBA(q,Value,p, Aplha)
         Case 2 : ProcedureReturn RGBA(p,Value,t, Aplha)
         Case 3 : ProcedureReturn RGBA(p,q,Value, Aplha)  
         Case 4 : ProcedureReturn RGBA(t,p,Value, Aplha)
         Case 5 : ProcedureReturn RGBA(Value,p,q, Aplha)  
         Default : ProcedureReturn RGBA(Value,t,p, Aplha)
      EndSelect
   EndProcedure
   
   
   ;    Procedure Canvas_DrawCallback(Gadget.i, DataValue.i)
   ;       VectorSourceColor($FFF0F0F0)
   ;       FillVectorOutput( )
   ;    EndProcedure
   
   ;-\\
   Procedure Button_DrawCallback(*Object._s_widget, X.d,Y.d,Width.d,Height.d, DataValue.i)
      Protected Text.s = GetText(*Object)
      Protected Hue = DataValue
      
      Protected enter = Bool(*object\enter > 0)
      Protected press = Bool(*object\press > 0 And enter)
      
      If a_index( )
         enter = 0
         press = 0
      EndIf
      
      ;       SaveVectorState()
      ;       TranslateCoordinates( X,Y )
      
      ; Box background
      AddPathBox(0.0, 0.0, Width, Height)
      VectorSourceLinearGradient(0.0, 0.0, 0.0, Height)
      If press And Not *object\disable
         VectorSourceGradientColor(HSVA(Hue, 10, $FF), 0.00)
         VectorSourceGradientColor(HSVA(Hue, 20, $F8), 0.45)
         VectorSourceGradientColor(HSVA(Hue, 30, $F0), 0.50)
         VectorSourceGradientColor(HSVA(Hue, 40, $E8), 1.00)
      ElseIf enter And Not *object\disable
         VectorSourceGradientColor(HSVA(Hue, 5, $FF), 0.00)
         VectorSourceGradientColor(HSVA(Hue, 10, $F8), 0.45)
         VectorSourceGradientColor(HSVA(Hue, 15, $F0), 0.50)
         VectorSourceGradientColor(HSVA(Hue, 20, $E8), 1.00)
      Else
         VectorSourceGradientColor(HSVA(0, 0, $F8), 0.00)
         VectorSourceGradientColor(HSVA(0, 0, $F0), 0.45)
         VectorSourceGradientColor(HSVA(0, 0, $E8), 0.50)
         VectorSourceGradientColor(HSVA(0, 0, $D8), 1.00)
      EndIf
      FillPath( )
      
      
      ; Box frame
      If *object\disable
         AddPathBox(0.5, 0.5, Width-1, Height-1)
         VectorSourceColor(HSVA(0, 0, $D0))
         StrokePath(1)
         AddPathBox(1.5, 1.5, Width-3, Height-3)
         VectorSourceColor(HSVA(0, 0, $F0))
         StrokePath(1)
      ElseIf press
         AddPathBox(0.5, 0.5, Width-1, Height-1)
         VectorSourceColor(HSVA(Hue, 100, $80))
         StrokePath(1)
         AddPathBox(1.5, 1.5, Width-3, Height-3)
         VectorSourceColor(HSVA(Hue, 50, $FF))
         StrokePath(1)
      ElseIf enter
         AddPathBox(0.5, 0.5, Width-1, Height-1)
         VectorSourceColor(HSVA(0, 0, $A0))
         StrokePath(1)
         AddPathBox(1.5, 1.5, Width-3, Height-3)
         VectorSourceColor(HSVA(Hue, 10, $FF))
         StrokePath(1)
      Else
         AddPathBox(0.5, 0.5, Width-1, Height-1)
         VectorSourceColor(HSVA(0, 0, $A0))
         StrokePath(1)
         AddPathBox(1.5, 1.5, Width-3, Height-3)
         VectorSourceColor(HSVA(0, 0, $FF))
         StrokePath(1)
      EndIf
      
      ; Text
      Protected text_x.d = 30
      Width - text_x*2
      ;Height - 10
      
      If Height > 0 And Width > 0
         VectorFont(FontID(#Font))
         AddPathBox(text_x, 0, Width, Height)
         If *object\disable
            VectorSourceColor($40000000)
         Else
            VectorSourceColor($FF000000)
         EndIf
         ClipPath( )
         MovePathCursor(text_x, (Height-VectorParagraphHeight(Text, Width, Height))/2-press)
         DrawVectorParagraph(Text, Width, Height, #PB_VectorParagraph_Center)
      EndIf
   EndProcedure
   
   Procedure Button_Events( )
      Protected *ew._s_widget = EventWidget( )
      
      Select WidgetEvent( ) 
         Case #__event_LeftClick
            If Not a_index( )
               Debug "Button '" + GetText(*ew) + "' was clicked."
            EndIf
            
         Case #__event_Draw
            Button_DrawCallback(*ew, *ew\x[#__c_frame], *ew\y[#__c_frame], *ew\width[#__c_frame], *ew\height[#__c_frame], *ew\data)
            
      EndSelect
   EndProcedure
   
   ; Custom procedure to create a button object
   Procedure Button_Add(X.i, Y.i, Width.i, Height.i, Text.s, HighlightColorHue.i=205)
      Protected *Object._s_widget
      
      *Object = a_object( X, Y, Width, Height, Text, 0)
      *Object\type = 0
      *Object\class = "Button"
      *Object\container = 0
      *Object\data = HighlightColorHue
      ;SetText(*Object, Text)                                 ; Set the button text as a dictionary entry
      Bind(*Object, @Button_Events( ), #__event_Draw )        ; Set the drawing callback with the specified highlighting color
      Bind(*Object, @Button_Events( ), #__event_LeftClick ) 
      ;a_set(*Object, #__a_size|#__a_position)        ; Add handles if you want to edit the buttons.
      
      ProcedureReturn *Object
   EndProcedure
   
   ;
   ;-\\ 
   ;
   Procedure CheckBox_DrawCallback( ) 
      Protected Object.i = EventWidget( )
      Protected Width.i=EventWidget( )\Width[#__c_frame]
      Protected Height.i=EventWidget( )\Height[#__c_frame]
      Protected DataValue.i=WidgetEventData( ) ;EventWidget( )\color\back & $FFFFFF ;| 0 << 24 
      
      Protected Text.s = GetObjectDictionary(Object, "Text")
      Protected State.i = Val(GetObjectDictionary(Object, "State"))
      Protected Y.i = Int((Height-19)/2)
      Protected Hue = 205
      Protected ObjectState = ObjectState(Object)
      
      ; Box background
      AddPathBox(0, Y, 19, 19)
      VectorSourceLinearGradient(0.0, Y, 0.0, Y+19)
      If ObjectState & (#State_LeftMousePushed|#State_Hovered) = (#State_LeftMousePushed|#State_Hovered)
         VectorSourceGradientColor(HSVA(Hue, 40, $E8), 0.00)
         VectorSourceGradientColor(HSVA(Hue, 10, $FF), 1.00)
      ElseIf ObjectState & #State_Hovered And MouseButtons( ) & #PB_Canvas_LeftButton = 0
         VectorSourceGradientColor(HSVA(Hue, 20, $E8), 0.00)
         VectorSourceGradientColor(HSVA(Hue, 5, $FF), 1.00)
      Else
         VectorSourceGradientColor(HSVA(0, 0, $D8), 0.00)
         VectorSourceGradientColor(HSVA(0, 0, $F8), 1.00)
      EndIf
      FillPath()
      
      ; Box frame
      If ObjectState & #State_Disabled
         AddPathBox(0.5, Y+0.5, 18, 18)
         VectorSourceColor(HSVA(0, 0, $D0))
         StrokePath(1)
         AddPathBox(1.5, Y+1.5, 16, 16)
         VectorSourceColor(HSVA(0, 0, $F0))
         StrokePath(1)
      ElseIf ObjectState & (#State_LeftMousePushed|#State_Hovered) = (#State_LeftMousePushed|#State_Hovered)
         AddPathBox(0.5, Y+0.5, 18, 18)
         VectorSourceColor(HSVA(Hue, 100, $80))
         StrokePath(1)
         AddPathBox(1.5, Y+1.5, 16, 16)
         VectorSourceColor(HSVA(Hue, 50, $FF))
         StrokePath(1)
      ElseIf ObjectState & #State_Hovered And MouseButtons( ) & #PB_Canvas_LeftButton = 0
         AddPathBox(0.5, Y+0.5, 18, 18)
         VectorSourceColor(HSVA(0, 0, $A0))
         StrokePath(1)
         AddPathBox(1.5, Y+1.5, 16, 16)
         VectorSourceColor(HSVA(Hue, 10, $FF))
         StrokePath(1)
      Else
         AddPathBox(0.5, Y+0.5, 18, 18)
         VectorSourceColor(HSVA(0, 0, $A0))
         StrokePath(1)
         AddPathBox(1.5, Y+1.5, 16, 16)
         VectorSourceColor(HSVA(0, 0, $FF))
         StrokePath(1)
      EndIf
      
      ; Check
      If State
         MovePathCursor(9.5, Y+10.5+Bool(ObjectState & (#State_LeftMousePushed|#State_Hovered) = (#State_LeftMousePushed|#State_Hovered)))
         AddPathLine(10.5, -10.5, #PB_Path_Relative)
         AddPathLine(2.5, 2.5, #PB_Path_Relative)
         AddPathLine(-13, 13, #PB_Path_Relative)
         AddPathLine(-5, -5, #PB_Path_Relative)
         AddPathLine(2.5, -2.5, #PB_Path_Relative)
         ClosePath()
         If ObjectState & #State_Disabled
            VectorSourceColor(HSVA(Hue, 0, $C0))
         Else
            VectorSourceColor(HSVA(Hue, 100, $C0))
         EndIf
         FillPath()
      EndIf
      
      ; Text
      AddPathBox(25, 0, Width-25, Height)
      ClipPath()
      VectorFont(FontID(#Font))
      If ObjectState & #State_Disabled
         VectorSourceColor($40000000)
      Else
         VectorSourceColor($FF000000)
      EndIf
      If Height > 0 And Width - 25 > 0
         If ObjectState & (#State_LeftMousePushed|#State_Hovered) = (#State_LeftMousePushed|#State_Hovered)
            MovePathCursor(25, (Height-VectorParagraphHeight(Text, Width-25, Height))/2)
         Else
            MovePathCursor(25, (Height-VectorParagraphHeight(Text, Width-25, Height))/2-1)
         EndIf
         DrawVectorParagraph(Text, Width-25, Height, #PB_VectorParagraph_Left)
      EndIf
      
   EndProcedure
     
   Procedure CheckBox_Events( )
      Protected *ew._s_widget = EventWidget( )
      
      Select WidgetEvent( ) 
         Case #__event_LeftClick
            If Not a_index( )
               SetState(*ew, 1 - GetState(*ew))
               Debug "checkbox '" + GetText(*ew) + "' was changed."
            EndIf
      EndSelect

      ProcedureReturn #PB_Ignore
   EndProcedure
   
   ; Custom procedure to create a button object
   Procedure CheckBox_Add(X.i, Y.i, Width.i, Height.i, Text.s)
      Protected *Object._s_widget
      
      *Object = a_object( X, Y, Width, Height, Text, 0)
      *Object\type = 0
      *Object\container = 0
      
      Static Index
      *Object\class = "CheckBox_"+Index
      Index + 1
      
      ; SetText(*Object, Text)                                      ; Set the button text as a dictionary entry
      ; a_set(*Object, #__a_size|#__a_position)                     ; Add handles if you want to edit the buttons.
      
      Bind(*Object, @CheckBox_DrawCallback( ), #__event_Draw)       ; Set the drawing callback with the specified highlighting color
      Bind(*Object, @CheckBox_Events( ), #__event_LeftClick)        ; 
      
      ProcedureReturn *Object
   EndProcedure
   
   ; ----------------------------------------------
   
   
   
   ; Object constants starting from 1
   Global *Object_Button1,
          *Object_Button2,
          *Object_Button3,
          *Object_CheckBox1,
          *Object_CheckBox2,
          *Object_CheckBox3
   
   
   ; Load a font
   LoadFont(#Font, "Arial", 12)
   
   ; Create a window
   OpenWindow(#Window, 0, 0, 800, 450, "Example 1: Creation of a basic objects.", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
   
   ; Create a canvas gadget and initializes the object management for the canvas gadget
   If Not Open( #Window );, #Canvas )
      Debug "Unable to initialize the object manager !"    
   EndIf
   SetColor(root( ), #PB_Gadget_BackColor, $FFF0F0F0 )
   a_init(root( ), 0)
   
   ; 2DDrawing 
   
   root( )\drawmode | 1<<2
   ; VectorDrawing
   root( )\drawmode | 1<<1
   
   ; Creates some customized buttons
   *Object_Button1 = Button_Add(50, 50, 200, 30, "Normal button")
   *Object_Button2 = Button_Add(50, 100, 200, 30, "Disabled Button")
   *Object_Button3 = Button_Add(50, 150, 200, 70, "Another button with a very long text", 20)
   
   ; Creates some customized check boxes
   *Object_CheckBox1 = CheckBox_Add(300, 50, 200, 30, "Check Box")
   *Object_CheckBox2 = CheckBox_Add(300, 100, 200, 30, "Disabled Check Box")
   *Object_CheckBox3 = CheckBox_Add(300, 150, 200, 50, "Another Check Box with longer text")
   
   Disable(*Object_Button2, 1)
   Disable(*Object_CheckBox2, 1)
   SetState(*Object_CheckBox2, 1)
   SetState(*Object_CheckBox3, 1)
   
   ; The window's event loop
   Repeat
      
      Select WaitWindowEvent( )
         Case #PB_Event_CloseWindow ; Exit the program.
            Break
      EndSelect
      
      ; Event loop of the objects in the canvas gadget
      ;     Repeat
      ;       Select CanvasObjectsEvent(#Canvas) ;  Something happened in the canvas.
      ;         Case #Event_Object               ; It is an object event
      ;           Select CanvasObjectsEventType(#Canvas) ; What type of events happened on the object?
      ;             Case #EventType_LeftMouseClick
      ;               Debug "Button '" + GetObjectDictionary(EventObject(#Canvas), "Text") + "' was clicked."
      ;               Select EventObject(#Canvas)
      ;                 Case *Object_CheckBox1 To *Object_CheckBox3
      ;                   SetObjectDictionary(EventObject(#Canvas), "State", Str(1-Val(GetObjectDictionary(EventObject(#Canvas), "State"))))
      ;               EndSelect
      ;           EndSelect
      ;         Case #Event_None ; No Events.
      ;           Break
      ;       EndSelect
      ;     ForEver
      
   ForEver
   
   End
   
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 43
; FirstLine = 35
; Folding = -------
; EnableXP