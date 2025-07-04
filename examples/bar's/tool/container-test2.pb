﻿#IDE_path = "../../../"

XIncludeFile #IDE_path + "widgets.pbi" 
; bug scrollstep

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  Enumeration 
    #_tb_group_select = 1
    
    #_tb_group_left = 3
    #_tb_group_right
    #_tb_group_top
    #_tb_group_bottom
    #_tb_group_width
    #_tb_group_height
    
    #_tb_align_left
    #_tb_align_right
    #_tb_align_top
    #_tb_align_bottom
    #_tb_align_center
    
    #_tb_widget_paste
    #_tb_widget_delete
    #_tb_widget_copy
    #_tb_widget_cut
    
    #_tb_file_open
    #_tb_file_save
    #_tb_file_save_as
    
  EndEnumeration
  
  If Open(0, 0, 0, 430, 440, "Container", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    SetColor( widget( ), #pb_gadget_backcolor, $FF95E3F6 )
    
    Container( 100,100,200,100, #__flag_border_Flat ) ; #__flag_border_Single ; #__flag_border_Double
    
    ToolBar( widget( ) );, #PB_ToolBar_Small )
    BarButton( #_tb_file_open, -1, 0, "Open" )
    BarButton( #_tb_file_save, -1, 0, "Save" )
    BarSeparator( )
    BarButton( #_tb_group_select, CatchImage( #PB_Any,?group ), #PB_Button_Toggle ) 
    BarSeparator( )
    BarButton( #_tb_group_left, CatchImage( #PB_Any,?group_left ) )
    BarButton( #_tb_group_right, CatchImage( #PB_Any,?group_right ) )
    BarSeparator( )
    BarButton( #_tb_group_top, CatchImage( #PB_Any,?group_top ) )
    BarButton( #_tb_group_bottom, CatchImage( #PB_Any,?group_bottom ) )
    BarSeparator( )
    BarButton( #_tb_group_width, CatchImage( #PB_Any,?group_width ) )
    BarButton( #_tb_group_height, CatchImage( #PB_Any,?group_height ) )
    
    BarSeparator( )
    BarButton( #_tb_widget_copy, CatchImage( #PB_Any,?widget_copy ) )
    BarButton( #_tb_widget_paste, CatchImage( #PB_Any,?widget_paste ) )
    BarButton( #_tb_widget_cut, CatchImage( #PB_Any,?widget_cut ) )
    BarButton( #_tb_widget_delete, CatchImage( #PB_Any,?widget_delete ) )
    BarSeparator( )
    BarButton( #_tb_align_left, CatchImage( #PB_Any,?group_left ) )
    BarButton( #_tb_align_top, CatchImage( #PB_Any,?group_top ) )
    BarButton( #_tb_align_center, CatchImage( #PB_Any,?group_width ) )
    BarButton( #_tb_align_bottom, CatchImage( #PB_Any,?group_bottom ) )
    BarButton( #_tb_align_right, CatchImage( #PB_Any,?group_right ) )
    
    
    Button( 0,0,80,30,"button")
    CloseList( )
    
    WaitClose( )
  EndIf
CompilerEndIf

DataSection   
  IncludePath #IDE_path + "ide/include/images"
  
  file_open:        : IncludeBinary "delete1.png"
  file_save:        : IncludeBinary "paste.png"
  
  widget_delete:    : IncludeBinary "delete1.png"
  widget_paste:     : IncludeBinary "paste.png"
  widget_copy:      : IncludeBinary "copy.png"
  widget_cut:       : IncludeBinary "cut.png"
  
  group:            : IncludeBinary "group/group.png"
  group_un:         : IncludeBinary "group/group_un.png"
  group_top:        : IncludeBinary "group/group_top.png"
  group_left:       : IncludeBinary "group/group_left.png"
  group_right:      : IncludeBinary "group/group_right.png"
  group_bottom:     : IncludeBinary "group/group_bottom.png"
  group_width:      : IncludeBinary "group/group_width.png"
  group_height:     : IncludeBinary "group/group_height.png"
EndDataSection
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 36
; FirstLine = 32
; Folding = -
; EnableXP