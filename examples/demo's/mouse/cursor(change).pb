XIncludeFile "../../../widgets.pbi"
; ;bug когда переходишь с якорья который находится под обЬектом не убираются якорья

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global parent, object
   ; test_changecursor = 1
   
   ;\\
   Procedure CustomEvents( )
      Select WidgetEvent( )
         Case #__event_CursorChange
            ;\\ demo change current cursor
            If EventWidget( ) = object
               Debug "CHANGE CURSOR "+ GetCursor( )
               If a_index( )
                  ProcedureReturn #PB_Cursor_Hand
               Else
                  ProcedureReturn #PB_Cursor_Cross
               EndIf
            EndIf
            
         Case #__event_MouseEnter
            Debug "enter " + EventWidget( )\class +" "+ PeekS(WidgetEventData( ))
           
         Case #__event_MouseLeave
            Debug "leave " + EventWidget( )\class +" "+ PeekS(WidgetEventData( )) ;+" "+ EventWidget( )\enter
            
      EndSelect
   EndProcedure
   
   Procedure GetVScrollBar( *this._s_WIDGET  )
      ProcedureReturn *this\scroll\v 
   EndProcedure
   
   Procedure GetHScrollBar( *this._s_WIDGET )
      ProcedureReturn *this\scroll\h 
   EndProcedure
   
   ;\\
   If Open(0, 0, 0, 600, 600, "Demo bounds", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      a_init(widget( ), 4)
      
      parent = Window(50, 50, 250, 250, "parent", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
      SetColor(parent, #PB_Gadget_BackColor, $FFAC97DB)
      SetFrame(parent, 20 )
      
      Define b1 = Button(10, 10, 80, 50,"01")
      SetCursor( b1, #PB_Cursor_IBeam )
      Define b2 = String(50, 50, 80, 50,"02")
      SetCursor( b2, #PB_Cursor_Default )
      
      object = Splitter(50, 50, 150, 150, b1, b2 )
      ;SetCursor( object, #PB_Cursor_Default )
      
      Define anchor_size = 30
      a_set(parent, #__a_full|#__a_zoom, anchor_size/2)
      a_set(object, #__a_full, anchor_size)
      
      CloseList( )
      
      ;// Ошибка когда вход в скроллбар и выход в скроллареа 
      ; стреляет два события вход и выход скроллареа
      ScrollArea(50, 400, 150, 150, 300,300,1, #__flag_noGadgets) 
      SetFrame( widget( ), 0)
      SetCursor( widget( ), #PB_Cursor_Cross )
      Bind( widget( ), @CustomEvents( ), #__event_MouseEnter )
      Bind( widget( ), @CustomEvents( ), #__event_MouseLeave )
      Bind( GetVScrollBar(widget( )), @CustomEvents( ), #__event_MouseEnter )
      Bind( GetVScrollBar(widget( )), @CustomEvents( ), #__event_MouseLeave )
      Bind( GetHScrollBar(widget( )), @CustomEvents( ), #__event_MouseEnter )
      Bind( GetHScrollBar(widget( )), @CustomEvents( ), #__event_MouseLeave )
      a_set(widget( ), #__a_full, anchor_size)
      
      ScrollArea(400, 400, 150, 150, 300,300,1, #__flag_noGadgets) 
      SetFrame( widget( ), 10)
      SetCursor( widget( ), #PB_Cursor_Cross )
      Bind( widget( ), @CustomEvents( ), #__event_MouseEnter )
      Bind( widget( ), @CustomEvents( ), #__event_MouseLeave )
      Bind( GetVScrollBar(widget( )), @CustomEvents( ), #__event_MouseEnter )
      Bind( GetVScrollBar(widget( )), @CustomEvents( ), #__event_MouseLeave )
      Bind( GetHScrollBar(widget( )), @CustomEvents( ), #__event_MouseEnter )
      Bind( GetHScrollBar(widget( )), @CustomEvents( ), #__event_MouseLeave )
      a_set(widget( ), #__a_full, anchor_size)
      
      ;\\
      Bind( #PB_All, @CustomEvents( ), #__event_CursorChange )
      
      ;\\
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 88
; FirstLine = 54
; Folding = --
; EnableXP
; DPIAware