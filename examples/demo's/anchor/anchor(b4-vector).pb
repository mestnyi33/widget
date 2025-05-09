﻿XIncludeFile "../../../widgets.pbi" 

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
       
      ReDraw( root() )
   EndIf
   
EndProcedure

Procedure right_events()
   ; #EventType_RightMouseClick
   CurrentObject = a_entered( )
   DisplayPopupMenu(#Menu, WindowID(EventWindow())) ; The context menu is displayed.
EndProcedure

Procedure MyDrawingObject( ) ; Runtime 
   Protected Object = EventWidget( )
   Protected Width.i=EventWidget( )\Width[#__c_frame]
   Protected Height.i=EventWidget( )\Height[#__c_frame]
   Protected iData.i=WidgetEventData( ) ;EventWidget( )\color\back & $FFFFFF ;| 0 << 24 
   
   ;AddPathBox(DesktopScaledX(0.5), DesktopScaledY(0.5), Width-DesktopScaledX(1), Height-DesktopScaledY(1))
	AddPathBox((0.5), (0.5), Width-(1), Height-(1))
	VectorSourceColor(iData|$C0000000)
	FillPath(#PB_Path_Preserve)
	VectorSourceColor(iData|$FF000000)
	;StrokePath(DesktopScaledX(1))
	StrokePath((1))
	MovePathCursor(DesktopScaledX(10), DesktopScaledY(10))
	VectorSourceColor($FF000000)
	VectorFont(FontID(#Font))
	DrawVectorText("vector Layer = "+Str(EventWidget( )\layer+1))
	
	ProcedureReturn #PB_Ignore
EndProcedure

Procedure SetDrawCallBack( *this._s_WIDGET, *callback, *data, vector.b = #True )
   *this\type = 0 
   ; 2DDrawing 
   *this\root\drawmode | 1<<2
   
   If vector
      ; VectorDrawing
      *this\root\drawmode | 1<<1
   EndIf
   
   Bind( *this, *callback, #__event_Draw, #PB_All, *data )
   ; Bind( *this, *callback, #__event_Draw, #PB_All, *this\color\back & $FFFFFF )
EndProcedure

If Open(0, 0, 0, 800, 450, "vector Example 4: Changing the order of the objects (context menu via right click)", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   ; Creation of the context menu to change the layer position of the selected object.
   CreatePopupMenu(#Menu)
   MenuItem(#MenuItem_ZOrder_Top, "Push to top most layer")
   MenuItem(#MenuItem_ZOrder_Up, "Push one layer up")
   MenuItem(#MenuItem_ZOrder_Down, "Push one layer down")
   MenuItem(#MenuItem_ZOrder_Bottom, "Push to the deepest layer")
   
   SetFont( root(), #Font)
   ; Container(0, 0, 800, 450) 
   a_init(widget() , 0);6)
   SetColor(widget(), #pb_gadget_backcolor, RGB(255, 255, 255))
   
   
   a_object(20, 20, 200, 100, "Layer = 1", RGB(64, 128, 192))   : SetDrawCallBack( widget( ), @MyDrawingObject( ), RGB(64, 128, 192))
   a_object(50, 50, 200, 100, "Layer = 2", RGB(192, 64, 128))   : SetDrawCallBack( widget( ), @MyDrawingObject( ), RGB(192, 64, 128))
   a_object(80, 80, 200, 100, "Layer = 3", RGB(128, 192, 64))   : SetDrawCallBack( widget( ), @MyDrawingObject( ), RGB(128, 192, 64))
   a_object(110, 110, 200, 100, "Layer = 4", RGB(192, 128, 64)) : SetDrawCallBack( widget( ), @MyDrawingObject( ), RGB(192, 128, 64))
   a_object(140, 140, 200, 100, "Layer = 5", RGB(128, 64, 192)) : SetDrawCallBack( widget( ), @MyDrawingObject( ), RGB(128, 64, 192))
   
   
   BindEvent( #PB_Event_Gadget, @right_events(), GetCanvasWindow(root()), GetCanvasGadget(root()), #PB_EventType_RightButtonUp )
   BindEvent( #PB_Event_Menu, @menu_events())
   WaitClose( )
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 93
; FirstLine = 76
; Folding = --
; EnableXP