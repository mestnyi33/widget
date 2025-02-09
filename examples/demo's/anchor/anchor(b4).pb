XIncludeFile "../../../widgets.pbi" 

EnableExplicit
UseWidgets( )
Global alpha = 192

#Font = 0
LoadFont(#Font, "Arial", 14)

; Constants for the context menu.
Enumeration 1
   #Menu
   #MenuItem_ZOrder_Top
   #MenuItem_ZOrder_Up
   #MenuItem_ZOrder_Down
   #MenuItem_ZOrder_Bottom
EndEnumeration

Global CurrentObject

Procedure menu_events()
   ;Case #PB_Event_Menu
   
   If CurrentObject
      Select EventMenu()
         Case #MenuItem_ZOrder_Top
            SetPosition(CurrentObject, #PB_List_Last) 
         Case #MenuItem_ZOrder_Up
            SetPosition(CurrentObject, #PB_List_After) 
         Case #MenuItem_ZOrder_Down
            SetPosition(CurrentObject, #PB_List_Before) 
         Case #MenuItem_ZOrder_Bottom
            SetPosition(CurrentObject, #PB_List_First) 
      EndSelect
      
;       If StartEnum( root( ) )
;          SetText( widget( ), "Layer = "+Str(widget( )\layer+1))
;          StopEnum( )
;       EndIf
      
      ReDraw( root() )
   EndIf
   
EndProcedure

Procedure right_events()
   ; #EventType_RightMouseClick
   CurrentObject = a_entered( )
   DisplayPopupMenu(#Menu, WindowID(EventWindow())) ; The context menu is displayed.
EndProcedure

Procedure MyDrawingObject(*Object._s_WIDGET, Width.i, Height.i, iData.i) ; Runtime 
   AddPathBox(0.5, 0.5, Width-1, Height-1)
	VectorSourceColor(iData|$C0000000)
	FillPath(#PB_Path_Preserve)
	VectorSourceColor(iData|$FF000000)
	StrokePath(1)
	MovePathCursor(10, 10)
	VectorSourceColor($FF000000)
	VectorFont(FontID(#Font))
	DrawVectorText("vector Layer = "+Str(*Object\layer+1))
EndProcedure

Procedure myDraw( )
   MyDrawingObject(EventWidget( ), EventWidget( )\Width[#__c_frame], EventWidget( )\Height[#__c_frame], EventWidget( )\color\back)
   ProcedureReturn #PB_Ignore
EndProcedure

Procedure SetTextXY( *this._s_WIDGET, X, Y )
   *this\text\x = DesktopScaledX(X)
   *this\text\y = DesktopScaledX(Y)
   
   ; 2DDrawing 
   *this\root\drawmode | 1<<2
   
   ; VectorDrawing
   *this\root\drawmode | 1<<1
   *this\type = 0 
   Bind( *this, @MyDraw( ), #__event_Draw )
   
   ; 
   ; *this\container = 0
EndProcedure

If Open(0, 0, 0, 800, 450, "Example 4: Changing the order of the objects (context menu via right click)", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   ; Creation of the context menu to change the layer position of the selected object.
   CreatePopupMenu(#Menu)
   MenuItem(#MenuItem_ZOrder_Top, "Push to top most layer")
   MenuItem(#MenuItem_ZOrder_Up, "Push one layer up")
   MenuItem(#MenuItem_ZOrder_Down, "Push one layer down")
   MenuItem(#MenuItem_ZOrder_Bottom, "Push to the deepest layer")
   
   SetFont( root(), #Font)
   ; Container(0, 0, 800, 450) 
   a_init(widget() , 0);6)
   SetColor(widget(), #__color_back, RGBA(255, 255, 255, alpha))
   
   
   a_object(20, 20, 200, 100, "Layer = 1", RGBA(64, 128, 192, alpha)) : SetTextXY( widget( ), 9,9)
   a_object(50, 50, 200, 100, "Layer = 2", RGBA(192, 64, 128, alpha)) : SetTextXY( widget( ), 9,9)
   a_object(80, 80, 200, 100, "Layer = 3", RGBA(128, 192, 64, alpha)) : SetTextXY( widget( ), 9,9)
   a_object(110, 110, 200, 100, "Layer = 4", RGBA(192, 128, 64, alpha)) : SetTextXY( widget( ), 9,9)
   a_object(140, 140, 200, 100, "Layer = 5", RGBA(128, 64, 192, alpha)) : SetTextXY( widget( ), 9,9)
   
   
   BindEvent( #PB_Event_Gadget, @right_events(), GetCanvasWindow(root()), GetCanvasGadget(root()), #PB_EventType_RightButtonUp )
   BindEvent( #PB_Event_Menu, @menu_events())
   WaitClose( )
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 79
; FirstLine = 59
; Folding = --
; EnableXP
; DPIAware