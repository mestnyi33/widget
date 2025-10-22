
XIncludeFile "widgets.pbi"

; example 2
CompilerIf #PB_Compiler_IsMainFile 
   EnableExplicit
   UseWidgets( )
   Global ide_design_MDI
   Global ide_design_PANEL
   
   Global i = 0
   Global._s_widget *PANEL_1, *PANEL_2
   
   If Open( 3, 0, 0, 400, 300, "Panel add childrens hide state", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      
      *PANEL_1 = Panel( 30, 30, 340, 240 )
      
      i = 0
      AddItem( *PANEL_1, i, "item_"+Str(i) )
      ide_design_MDI = Container(0,0,0,0, #__flag_autosize)
      CloseList()
      
      i = 1
      AddItem( *PANEL_1, i, "item_"+Str(i) )
      Editor(0,0,0,0, #__flag_autosize)
      
      CloseList()
      
      ide_design_PANEL = *PANEL_1
      Debug "items count "+CountItems( *PANEL_1 )
      
      ; Free(ide_design_MDI)
      Debug "-1-"
      ForEach widgets( )
         If IsChild(widgets( ), ide_design_PANEL) 
            Debug ""+widgets( )\class +" "+ widgets( )\level +" "+ widgets( )\TabIndex( )
         EndIf
      Next
      
      OpenList(ide_design_MDI)
      Button(30,30,60,30, "test")
      CloseList()
      
      Debug "-2-"
      ForEach widgets( )
         If IsChild(widgets( ), ide_design_PANEL) 
            Debug ""+widgets( )\class +" "+ widgets( )\level +" "+ widgets( )\TabIndex( )
         EndIf
      Next
      Debug "---"
      
      Free(ide_design_MDI)
      
      Debug "-3-"
      ForEach widgets( )
         If IsChild(widgets( ), ide_design_PANEL) 
            Debug ""+widgets( )\class +" "+ widgets( )\level +" "+ widgets( )\TabIndex( )
         EndIf
      Next
      
      OpenList(ide_design_MDI)
      Button(30,30,60,30, "test")
      CloseList()
      
      Debug "-4-"
      ForEach widgets( )
         If IsChild(widgets( ), ide_design_PANEL) 
            Debug ""+widgets( )\class +" "+ widgets( )\level +" "+ widgets( )\TabIndex( )
         EndIf
      Next
      Debug "---"
      
      
      
      WaitClose( )
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 31
; FirstLine = 36
; Folding = --
; EnableXP
; DPIAware