;-
   ;-\\ DD
   ;-
   Macro Drag( ): mouse( )\drag: EndMacro                                       ; 
   Procedure   DoDrag( *this._s_WIDGET )
      If Drag( ) And *this And Not *this\mask & #__mask_disabled
        
         If *this\drop 
            
            If Drag( )\enter = 0
               If *this\drop\format = Drag( )\format And
                  *this\drop\actions & Drag( )\actions And
                  ( *this\drop\private = Drag( )\private Or
                    *this\drop\private & Drag( )\private )
                  ;
                  If GetCursor( ) = cursor::#__cursor_Drag
                     ; Debug "drop enter"
                     ChangeCursor( Pressed( ), cursor::#__cursor_Drop )
                  EndIf
                  repaint_set( *this )
                  Drag( )\enter = 1
               Else
                  
                  ; Debug "no drop enter"
                  
               EndIf
            EndIf
            
         Else
            If Drag( )\enter = 1
               Drag( )\enter = 0
               ;
               If GetCursor( ) = cursor::#__cursor_Drop
                  ; Debug "no drop"
                  ChangeCursor( Pressed( ), cursor::#__cursor_Drag )
               EndIf
               repaint_set( *this )
            EndIf
         EndIf
      
         If Drag( )\enter
            *this\mask | #__mask_hover_in
         ElseIf *this\mask & #__mask_hover = 0
            *this\mask &~ #__mask_hover_in
         EndIf
      EndIf
   EndProcedure
   
   Procedure DropDraw( *this._s_WIDGET )
      Protected j = 5, s = j/2
      Protected enter = Bool(*this\mask & #__mask_hover_in) ; MouseEnter( *this, 2 )
      
      If Drag( )
         ;\\ if you drag to the widget-dropped
         If is_scrollbars_( *this )
            *this = *this\parent
         EndIf
         
         If test_drag
            Debug "in-"+Str(Bool(enter) + Bool(*this\mask & #__mask_hover))+" de-"+ Drag( )\enter +" Drop-"+ Bool(*this\drop)
         EndIf
         
         If *this\mask & #__mask_hover
            ;\\ first - draw backgraund color
            draw_mode_alpha_( #PB_2DDrawing_Default )
            If *this\drop
               If Drag( )\enter
                  draw_box_( *this\inner_x( ), *this\inner_y( ), *this\inner_width( ), *this\inner_height( ), $1000ff00 )
                  
                  If *this\row And ListSize(*this\__rows( ))
                     draw_box_( *this\inner_x( )+5, CanvasMouseY( )-s-1, *this\inner_width( )-10, j, $2000ff00 )
                  EndIf
               Else
                  draw_box_( *this\inner_x( ), *this\inner_y( ), *this\inner_width( ), *this\inner_height( ), $10ff0000 )
               EndIf
            ElseIf *this\mask & #__mask_press
               draw_box_( *this\inner_x( ), *this\inner_y( ), *this\inner_width( ), *this\inner_height( ), $10ff00ff )
            ElseIf Pressed( ) And Pressed( )\parent <> *this
               draw_box_( *this\frame_x( ), *this\frame_y( ), *this\frame_width( ), *this\frame_height( ), $100000ff )
            EndIf
            
            ;\\ second - draw frame color
            __draw_mode( #PB_2DDrawing_Outlined )
            If *this\drop
               If Drag( )\enter
                  draw_box_( *this\inner_x( ), *this\inner_y( ), *this\inner_width( ), *this\inner_height( ), $ff00ff00 )
                  
                  If *this\row And ListSize(*this\__rows( ))
                     draw_box_( *this\inner_x( )+5, CanvasMouseY( )-s-1, *this\inner_width( )-10, j, $ff00ff00 )
                  EndIf
               Else
                  draw_box_( *this\inner_x( ), *this\inner_y( ), *this\inner_width( ), *this\inner_height( ), $ffff0000 )
               EndIf
            ElseIf *this\mask & #__mask_press
               draw_box_( *this\inner_x( ), *this\inner_y( ), *this\inner_width( ), *this\inner_height( ), $ffff00ff )
            ElseIf Pressed( ) And Pressed( )\parent <> *this
               draw_box_( *this\frame_x( ), *this\frame_y( ), *this\frame_width( ), *this\frame_height( ), $ff0000ff )
            EndIf
         EndIf
      EndIf
      
   EndProcedure
   
   Procedure.l DropX( )
      ProcedureReturn Drag( )\x
   EndProcedure
   
   Procedure.l DropY( )
      ProcedureReturn Drag( )\y
   EndProcedure
   
   Procedure.l DropWidth( )
      ProcedureReturn Drag( )\width
   EndProcedure
   
   Procedure.l DropHeight( )
      ProcedureReturn Drag( )\height
   EndProcedure
   
   Procedure.i DropType( )
      ; после того, как произошло событие ( event-DROP )
      ; эта функция возвращает формат отброшенных данных.
      ;   или ОС-специфичный ID для произвольного формата 
      ;   (Доп. информацию см. в описании функции DragOSFormats().) 
      ; возвращает одно из следующих значений 
      ; #PB_Drop_Text   : Перетащен текст.  (для получения текста воспользуйтесь функцией EventDropText() )
      ; #PB_Drop_image  : Перетащено изображение.  (для получения изображения воспользуйтесь функцией EventDropimage())
      ; #PB_Drop_Files  : Перетащены имена файлов. (для получения имён воспользуйтесь функцией EventDropFiles())
      ; #PB_Drop_Private: Завершена "внутренняя" операция. (чтобы узнать её тип, воспользуйтесь функцией EventDropPrivate())
      ProcedureReturn Drag( )\format
   EndProcedure
   
   Procedure.i DropAction( )
      ; эта функция возвращает действие, которое следует выполнить с данными.
      ; после того, как произошло событие ( event-DROP )
      ProcedureReturn Drag( )\actions
   EndProcedure
   
   Procedure.i DropPrivate( )
      ; эта функция возвращает 'PrivateType', который был сброшен.
      ; после того, как произошло событие ( event-DROP ) с форматом #PB_Drop_Private (формат можно получить с помощью DropType( ))
      ProcedureReturn Drag( )\private
   EndProcedure
   
   Procedure.s DropFiles( )
      ; эта функция возвращает имена файлов, который был сброшен.
      ; после того, как произошло событие ( event-DROP ) с форматом #PB_Drop_Files (формат можно получить с помощью DropType( ))
      ; ProcedureReturn Drag( )\files\s
   EndProcedure
   
   Procedure.s DropText( )
      ; эта функция возвращает текст, который был сброшен.
      ; после того, как произошло событие ( event-DROP ) с форматом #PB_Drop_Text (формат можно получить с помощью DropType( ))
      ProcedureReturn Drag( )\str$
   EndProcedure
   
   Procedure.i DropImage( img.i = #PB_Any, Depth.i = 24 )
      ; эта функция возвращает изображения, который был сброшен.
      ; после того, как произошло событие ( event-DROP ) с форматом #PB_Drop_image (формат можно получить с помощью DropType( ))
      If Drag( )\imageID
         If img = #PB_Any
            img = CreateImage( #PB_Any, DropWidth( ), DropHeight( ) )
         EndIf
         
         If IsImage( img ) And
            StartDrawing( ImageOutput( img ))
            If Depth = 32
               DrawAlphaImage( Drag( )\imageID, 0, 0 )
            Else
               DrawImage( Drag( )\imageID, 0, 0 )
            EndIf
            StopDrawing( )
            
            ProcedureReturn 1
         EndIf
      EndIf
   EndProcedure
   
   Procedure.i EnableDrop( *this._s_WIDGET, Format.l, Actions.b, PrivateType.i = 0 )
      ;                        ; windows ;    macos   ; linux ;
      ; Формат = Format
      ; #PB_Drop_Text          ; = 1     ; 1413830740 ; -1    ; Accept text on this widget
      ; #PB_Drop_image         ; = 8     ; 1346978644 ; -2    ; Accept images on this widget
      ; #PB_Drop_Files         ; = 15    ; 1751544608 ; -3    ; Accept filenames on this widget
      ; #PB_Drop_Private       ; = 512   ; 1885499492 ; -4    ; Accept a "private" Drag & Drop on this gadgetProtected Result.i
      
      ; Действие & Actions
      ; #PB_Drag_None          ; = 0     ; 0          ; 0     ; The Data format will Not be accepted on the widget
      ; #PB_Drag_Copy          ; = 1     ; 1          ; 2     ; The Data can be copied
      ; #PB_Drag_Move          ; = 2     ; 16         ; 4     ; The Data can be moved
      ; #PB_Drag_Link          ; = 4     ; 2          ; 8     ; The Data can be linked
      
      ; SetDragCallback( )
      ; "Состояние" указывает текущее состояние операции перетаскивания и имеет одно из следующих значений:
      ; #PB_Drag_Enter         ; = 1     ; 1          ; 1     ; Мышь вошла внутр (объекта).
      ; #PB_Drag_Update        ; = 2     ; 2          ; 2     ; Мышь была перемещена внутри (объекта) или изменено предполагаемое действие.
      ; #PB_Drag_Leave         ; = 3     ; 3          ; 3     : Мышь покинула (объект) (Формат, Действие, x, y здесь равны 0)
      ; #PB_Drag_Finish        ; = 4     ; 4          ; 4     : Перетаскивание завершено.
      
      If IsGadget(*this)
         ProcedureReturn PB(EnableGadgetDrop)(*this, Format, Actions, PrivateType )
      EndIf
      
      If Not *this\drop
         ;Debug "Enable dropped - " + *this\class
         *this\drop.allocate( Drop )
      EndIf
      
      *this\drop\format  = Format
      *this\drop\actions = Actions
      *this\drop\private = PrivateType
   EndProcedure
   
   Procedure.i DragDropText( Text.s, Actions.b = #PB_Drag_Copy )
      ;Debug "  drag text - " + Text
      
      If Not Drag( )
         Drag( ).allocate( DROPMOUSE )
      EndIf
      Drag( )\format  = #PB_Drop_Text
      Drag( )\actions = Actions
      Drag( )\str$  = Text
      
      ; SetCursor( #PB_All, cursor::#__cursor_Drag )
      ;mouse( )\cursor = cursor::#__cursor_Drag
      ChangeCursor( Entered( ), cursor::#__cursor_Drag)
      
      ProcedureReturn Drag( )
   EndProcedure
   
   Procedure.i DragDropImage( img.i, Actions.b = #PB_Drag_Copy )
      ;Debug "  drag img - " + img
      
      If Not Drag( )
         Drag( ).allocate( DROPMOUSE )
      EndIf
      Drag( )\format  = #PB_Drop_Image
      Drag( )\actions = Actions
      
      If IsImage( img )
         Drag( )\imageID = ImageID( img )
         Drag( )\width   = ImageWidth( img )
         Drag( )\height  = ImageHeight( img )
      EndIf
      
      ; SetCursor( #PB_All, cursor::#__cursor_Drag )
      ChangeCursor( Entered( ), cursor::#__cursor_Drag)
      ProcedureReturn Drag( )
   EndProcedure
   
   Procedure.i DragDropFiles( Files.s, Actions.b = #PB_Drag_Copy )
      ;         ;Debug "  drag files - " + Files
      ;
      ;         If Not Drag( )
      ;           Drag( ).allocate( DROPMOUSE )
      ;         EndIf
      ;         Drag( )\format  = #PB_Drop_Files
      ;         Drag( )\actions = Actions
      ;         Drag( )\files  = Files
      
      ; SetCursor( #PB_All, cursor::#__cursor_Drag )
      mouse( )\cursor = cursor::#__cursor_Drag
      ProcedureReturn Drag( )
   EndProcedure
   
   Procedure.i DragDropPrivate( PrivateType.i, Actions.b = #PB_Drag_Copy )
      ; Debug "  drag PrivateType - " + PrivateType +" - Actions - "+ Actions
      
      If Not Drag( )
         Drag( ).allocate( DROPMOUSE )
      EndIf
      Drag( )\format  = #PB_Drop_Private
      Drag( )\actions = Actions
      Drag( )\private = PrivateType
      
      ; SetCursor( #PB_All, cursor::#__cursor_Drag )
      mouse( )\cursor = cursor::#__cursor_Drag
      ProcedureReturn Drag( )
   EndProcedure
   
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 47
; FirstLine = 28
; Folding = -v------
; EnableXP
; DPIAware