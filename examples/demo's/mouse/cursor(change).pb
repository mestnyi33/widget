XIncludeFile "../../../widgets.pbi"
; ;bug когда переходишь с якорья который находится под обЬектом не убираются якорья

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global parent, object
   
   ;\\
   Procedure CustomEvents( )
      Select WidgetEvent( )
         Case #__event_CursorChange
            ;\\ demo change current cursor
            If EventWidget( ) = object
               If CurrentCursor( )
                  Debug "CHANGE CURSOR"
                  If a_index( )
                     ProcedureReturn cursor::#__cursor_Hand
                  Else
                     ProcedureReturn cursor::#__cursor_Cross
                  EndIf
               EndIf
            EndIf
      EndSelect
   EndProcedure
   
   ;\\
   If Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      a_init(widget( ), 4)
      
      parent = Window(50, 50, 250, 250, "parent", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
      SetColor(parent, #__color_back, $FFAC97DB)
      SetFrame(parent, 20 )
      
      object = Splitter(50, 50, 150, 150, Button(10, 10, 80, 50,"01"), Button(50, 50, 80, 50,"02") )
      
      Define anchor_size = 30
      a_set(parent, #__a_full|#__a_zoom, anchor_size/2)
      a_set(object, #__a_full, anchor_size)
      
      ;\\
      Bind( #PB_All, @CustomEvents( ), #__event_CursorChange )
      
      ;\\
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 42
; FirstLine = 16
; Folding = --
; EnableXP
; DPIAware