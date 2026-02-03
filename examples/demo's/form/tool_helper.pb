EnableExplicit

XIncludeFile "../../../widgets.pbi"

EnableExplicit
UseWidgets( )

;
Global Font = LoadFont(#PB_Any, "Arial", 16)

;
Global Tool_Container_Mode,
       Tool_Alignment_Mode,
       Tool_Align_To_Grid,
       Tool_Align_To_Line,
       Tool_Grid_Container,
       Tool_Grid_Frame,
       Tool_Grid_Show,
       Tool_Grid_Snap,
       Tool_Grid_Size_Info,
       Tool_Grid_Size,
       Tool_Line_Container,
       Tool_Line_Frame,
       Tool_Line_Show,
       Tool_Line_Snap,
       Tool_Line_Size_Info,
       Tool_Line_Size

;
Procedure Tool_Gadget_Event( )
   Select EventWidget( )
      Case Tool_Align_To_Grid, Tool_Align_To_Line
         Select WidgetEvent( )
            Case #__Event_Change
               Debug 8888
               Protected State1 = Bool(GetState(Tool_Align_To_Line) = #PB_Checkbox_Checked)
               Protected State2 = Bool(GetState(Tool_Align_To_Grid) = #PB_Checkbox_Checked)
               
               Disable(Tool_Grid_Show,State1)
               Disable(Tool_Grid_Snap,State1)
               Disable(Tool_Grid_Size,State1)
               ;Disable(Tool_Grid_Frame,State1)
               Disable(Tool_Grid_Container,State1)
               
               Disable(Tool_Line_Show,State2)
               Disable(Tool_Line_Snap,State2)
               Disable(Tool_Line_Size,State2)
               ;Disable(Tool_Line_Frame,State2)
               Disable(Tool_Line_Container,State2)  
               
;                ;\\
;                SetColor(Tool_Align_To_Grid, #PB_Gadget_FrontColor, State1 * $757B7B)
;                SetColor(Tool_Align_To_Line, #PB_Gadget_FrontColor, State2 * $757B7B)
         EndSelect
         
      Case Tool_Grid_Show
         Select WidgetEvent( )
            Case #__Event_LeftClick
               If GetState(Tool_Grid_Show) = #PB_Checkbox_Checked
                  
               Else
                  
               EndIf
         EndSelect
   EndSelect
EndProcedure

Procedure Tool_Gadget( Window, Width, Height )
   Tool_Container_Mode = Container(5, 5, Width-10, Height-10)
   
   If Font
      SetFont(Frame(10, 10, 333, 170, "Параметры выравнивания"),FontID(Font))
   EndIf
   
   Container(10+3, 10+35, 327, 132)
   Tool_Alignment_Mode = Frame(5, 4, 317, 124, "Режим выравнивания", #__flag_BorderLess|#__flag_Transparent)
   
   Tool_Grid_Container = Container(10, 25, 152, 101)
   ;Tool_Grid_Frame = Frame(1, 4, 150, 93, "")
   Tool_Grid_Show = CheckBox(6, 24, 126, 16, "Показать сетку", #__flag_BorderLess|#__flag_Transparent)
   Tool_Grid_Snap = CheckBox(6, 44, 136, 16, "Привязать к сетке", #__flag_BorderLess|#__flag_Transparent)
   Tool_Grid_Size_Info = Text(65, 72, 126, 16, "Размер сетки", #__flag_BorderLess|#__flag_Transparent)
   Tool_Grid_Size = Spin(6, 69, 55, 23,0,20,#__spin_Plus)
   CloseList( )
   Tool_Line_Container = Container(165, 25, 152, 101)
   ;Tool_Line_Frame = Frame(1, 4, 150, 93, "")
   Tool_Line_Show = CheckBox(6, 24, 126, 16, "Показать линию", #__flag_BorderLess|#__flag_Transparent)
   Tool_Line_Snap = CheckBox(6, 44, 136, 16, "Привязать к линии", #__flag_BorderLess|#__flag_Transparent)
   Tool_Line_Size_Info = Text(65, 72, 126, 16, "Размер линии", #__flag_BorderLess|#__flag_Transparent)
   Tool_Line_Size = Spin(6, 69, 55, 23,0,20,#__spin_Plus)
   ;SetColor( Tool_Line_Frame, #pb_gadget_backcolor, GetColor(Tool_Line_Size_Info, #pb_gadget_backcolor))
   CloseList( )
   
   Tool_Align_To_Grid = Option(X(Tool_Grid_Container, 3)+6, Y(Tool_Grid_Container, 3)+2, 152-12, 16, "Выровнять по сетке", #__flag_BorderLess|#__flag_Transparent)
   Tool_Align_To_Line = Option(X(Tool_Line_Container, 3)+6, Y(Tool_Line_Container, 3)+2, 152-12, 16, "Выровнять по линии", #__flag_BorderLess|#__flag_Transparent)
   CloseList( )
   CloseList( )
   
   ;
    SetState( Tool_Align_To_Grid, 1) ; 
;    Disable(Tool_Line_Show,1)
;    Disable(Tool_Line_Snap,1)
;    Disable(Tool_Line_Size,1)
;    ;Disable(Tool_Line_Frame,1)
;    Disable(Tool_Line_Container,1)
;    SetColor(Tool_Align_To_Line, #PB_Gadget_FrontColor, $757B7B)
   
   Bind(Root( ), @Tool_Gadget_Event( ))
EndProcedure

;
CompilerIf #PB_Compiler_IsMainFile
   Define Event
   Open( 1, 245, 144, 555, 555, "Tool", #PB_Window_SystemMenu )
   Define Window = GetCanvasWindow(Root( ))
   Tool_Gadget( Window, 555, 555 )
   
   While IsWindow( Window )
      Event = WaitWindowEvent( )
   Wend
   
   End
CompilerEndIf

DisableExplicit
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 71
; FirstLine = 67
; Folding = --
; EnableXP
; DPIAware