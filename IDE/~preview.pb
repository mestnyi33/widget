EnableExplicit

CompilerIf #PB_Compiler_IsMainFile
   XIncludeFile "C:\Users\user\Documents\GitHub\widget\widgets.pbi"
CompilerEndIf

UseWidgets( )

Global WINDOW_0 = - 1

Global BUTTON_0 = - 1
Global TEXT_0 = - 1
Global BUTTON_1 = - 1
Global STRING_0 = - 1
Global SCROLLAREA_0 = - 1
Global BUTTON_2 = - 1
Global TEXT_1 = - 1
Global BUTTON_3 = - 1
Global TEXT_2 = - 1
Global PANEL_0 = - 1
Global BUTTON_4 = - 1
Global TEXT_3 = - 1
Global BUTTON_5 = - 1
Global TEXT_4 = - 1
Global BUTTON_6 = - 1
Global TEXT_5 = - 1
Global BUTTON_7 = - 1
Global TEXT_6 = - 1

Procedure Open_WINDOW_0( )
   WINDOW_0 = Open( #PB_Any, 7, 7, 498, 253, "window_0", #PB_Window_SystemMenu | #PB_Window_SizeGadget  )
      BUTTON_0 = Button( 14, 28, 50, 29, "button_0", #__flag_text_MultiLine  )
         Disable( BUTTON_0, #True )
      
      TEXT_0 = Text( 28, 63, 50, 29, "text_0" )
      BUTTON_1 = Button( 35, 105, 50, 29, "button_1" )
      STRING_0 = String( 42, 147, 50, 29, "string_0" )

      SCROLLAREA_0 = ScrollArea( 119, 28, 169, 176, 165, 175, 5, #PB_ScrollArea_Flat  )
         BUTTON_2 = Button( 14, 28, 29, 29, "button_2" )
         TEXT_1 = Text( 28, 63, 50, 29, "text_1" )
         BUTTON_3 = Button( 35, 105, 78, 29, "button_3" )
         TEXT_2 = Text( 42, 147, 50, 29, "text_2" )
      CloseList( ) ; SCROLLAREA_0

      PANEL_0 = Panel( 322, 28, 169, 176 )
         AddItem( PANEL_0, - 1, "panel_item_0" )
         BUTTON_4 = Button( 14, 28, 29, 29, "button_4" )
         TEXT_3 = Text( 28, 63, 50, 29, "text_3" )
         BUTTON_5 = Button( 35, 105, 78, 29, "button_5" )
         TEXT_4 = Text( 42, 147, 50, 29, "text_4" )
         
         AddItem( PANEL_0, - 1, "panel_item_1" )
         BUTTON_6 = Button( 112, 28, 29, 29, "button_6" )
         TEXT_5 = Text( 126, 63, 50, 29, "text_5" )
         BUTTON_7 = Button( 133, 105, 78, 29, "button_7" )
         TEXT_6 = Text( 147, 147, 50, 29, "text_6" )
         SetState( PANEL_0, 1 )
      CloseList( ) ; PANEL_0
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
   Open_WINDOW_0( )

   WaitClose( )
   End
CompilerEndIf
