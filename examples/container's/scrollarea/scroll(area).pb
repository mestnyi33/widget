XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   EnableExplicit
   
   Structure canvasitem
      img.i
      X.i
      Y.i
      Width.i
      Height.i
      alphatest.i
   EndStructure
   
   Global MyCanvas, *this.allocate( Widget ) 
   
   Global *current=#False
   Global currentItemXOffset.i, currentItemYOffset.i
   Global Event.i, drag.i, hole.i
   Global X=100,Y=100, Width=420, Height=420 , focus
   
   Global NewList imgs.canvasitem()
   
   Procedure.i HitTest (List imgs.canvasitem(), X, Y)
      Shared currentItemXOffset.i, currentItemYOffset.i
      Protected alpha.i, *current = #False
      Protected scroll_x ; = *this\scroll\h\bar\Page\Pos
      Protected scroll_y ;= *this\scroll\v\bar\Page\Pos
      
      If LastElement(imgs()) ; search for hit, starting from end (z-order)
         Repeat
            If X >= imgs()\x - scroll_x And X < imgs()\x+ imgs()\width - scroll_x 
               If Y >= imgs()\y - scroll_y And Y < imgs()\y + imgs()\height - scroll_y
                  alpha = 255
                  
                  If imgs()\alphatest And ImageDepth(imgs()\img)>31
                     If StartDrawing(ImageOutput(imgs()\img))
                        DrawingMode(#PB_2DDrawing_AlphaChannel)
                        alpha = Alpha(Point(X-imgs()\x - scroll_x, Y-imgs()\y - scroll_y)) ; get alpha
                        StopDrawing()
                     EndIf
                  EndIf
                  
                  If alpha
                     MoveElement(imgs(), #PB_List_Last)
                     *current = @imgs()
                     currentItemXOffset = X - imgs()\x - scroll_x
                     currentItemYOffset = Y - imgs()\y - scroll_y
                     Break
                  EndIf
               EndIf
            EndIf
         Until PreviousElement(imgs()) = 0
      EndIf
      
      ProcedureReturn *current
   EndProcedure
   
   Procedure AddImage (List imgs.canvasitem(), X, Y, img, alphatest=0)
      If AddElement(imgs())
         imgs()\img    = img
         imgs()\x          = X
         imgs()\y          = Y
         imgs()\width  = ImageWidth(img)
         imgs()\height = ImageHeight(img)
         imgs()\alphatest = alphatest
      EndIf
   EndProcedure
   
   AddImage(imgs(),  X-80, Y-20, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp"))
   AddImage(imgs(), X+100,Y+100, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp"))
   ;AddImage(imgs(),  x+221,y+200, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp"))
   ;AddImage(imgs(),  x+210,y+321, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp"))
   ;AddImage(imgs(),  x,y-1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp"))
   AddImage(imgs(),  X+310,Y+350, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp"))
   
   hole = CreateImage(#PB_Any,100,100,32)
   If StartDrawing(ImageOutput(hole))
      DrawingMode(#PB_2DDrawing_AllChannels)
      Box(0,0,100,100,RGBA($00,$00,$00,$00))
      Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
      Circle(50,50,30,RGBA($00,$00,$00,$00))
      StopDrawing()
   EndIf
   AddImage(imgs(),X+170,Y+70,hole,1)
   
   
   Macro area_update( )
      *this\scroll_x( ) = imgs()\x 
      *this\scroll_y( ) = imgs()\Y
      *this\scroll_width( ) = imgs()\width
      *this\scroll_height( ) = imgs()\height
      
      PushListPosition(imgs())
      ForEach imgs()
         If *this\scroll_x( ) > imgs()\x
            *this\scroll_x( ) = imgs()\x
         EndIf
         If *this\scroll_y( ) > imgs()\Y
            *this\scroll_y( ) = imgs()\Y
         EndIf
         If *this\scroll_width( ) < imgs()\x + imgs()\width
            *this\scroll_width( ) = imgs()\x + imgs()\width
         EndIf
         If *this\scroll_height( ) < imgs()\Y + imgs()\height
            *this\scroll_height( ) = imgs()\Y + imgs()\height
         EndIf
      Next
      PopListPosition(imgs())
   EndMacro
   
   
   Procedure   make_mdi_size( *this._s_WIDGET, X.l, Y.l, Width.l, Height.l  )
      Protected scroll_x, scroll_y, scroll_width, scroll_height 
      
     ; ProcedureReturn 
      Protected round, result, sx, sy;, Width.l, Height.l
            With *this\scroll
               
               scroll_x      = *this\scroll_x( )
               scroll_y      = *this\scroll_y( )
               scroll_width  = *this\scroll_width( )
               scroll_height = *this\scroll_height( )
               
;                X=0
;                Y=0
;                
;                Width  = *this\container_width( ) 
;             Height = *this\container_height( )
;             
            ;\\
               If scroll_x > X
;                 sy = ( scroll_y - Y )
;                scroll_height + sy
               scroll_x = X
            Else
               If scroll_width < Width
                  scroll_width = Width
               EndIf
               scroll_width - scroll_x 
            EndIf
            If scroll_y > Y 
;                sx = ( scroll_x - X )
;                scroll_width + sx
               scroll_y = Y
            Else
               If scroll_height < Height
                  scroll_height = Height
               EndIf
               scroll_height - scroll_y
            EndIf
            
            ;\\
            \v\bar\page\pos = - scroll_y
            \h\bar\page\pos = - scroll_x
            
            ;\\
            If \h\bar\Max <> scroll_width
               \h\bar\Max = scroll_width
               result = 1
            EndIf
            
            If \v\bar\Max <> scroll_height
               \v\bar\Max = scroll_height 
               result = 1
            EndIf
            
            ;\\
            If result
               ;
               ; Debug "hide "+ \h\hide +" "+ \v\hide +" area "+ scroll_x +" "+ scroll_y +" "+ scroll_width +" "+ scroll_height
               ;
               ;\\
               *this\scroll_x( )      = scroll_x
               *this\scroll_y( )      = scroll_y
               *this\scroll_width( )  = scroll_width
               *this\scroll_height( ) = scroll_height
               
               \v\bar\page\len = Height - ( Bool( Not \h\hide[1] And (scroll_width >= Width Or \h\bar\max > \h\bar\page\len) ) * \h\frame_height( ))
               \h\bar\page\len = Width - ( Bool( Not \v\hide[1] And (scroll_height >= Height Or \v\bar\max > \v\bar\page\len) ) * \v\frame_width( ) )
               
               ;             
               If Not \v\hide[1]
                  If \v\bar\max > \v\bar\page\len
                     Height = ( \v\bar\page\len + Bool( Not \h\hide[1] And \h\bar\max > \h\bar\page\len And \v\round And \h\round ) * ( \h\height / 4 ) )
                     If \v\frame_height( ) <> Height
                        Resize( \v, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height )
                     Else
                        bar_update( \v, 100 )
                     EndIf
                     
                  Else
                     If \v\hide <> #True
                        \v\hide = #True
                        ;// reset page pos then hide scrollbar
                        If \v\bar\page\pos > \v\bar\min
                           bar_PageChange( \v, \v\bar\min, #False )
                        EndIf
                     EndIf
                  EndIf
               EndIf
               
               ;
               If Not \h\hide[1]
                  If \h\bar\max > \h\bar\page\len
                     Width = ( \h\bar\page\len + Bool( Not \v\hide[1] And \v\bar\max > \v\bar\page\len And \v\round And \h\round ) * ( \v\frame_width( ) / 4 ))
                     If \h\frame_width( ) <> Width
                        Resize( \h, #PB_Ignore, #PB_Ignore, Width, #PB_Ignore )
                     Else
                        bar_update( \h, 100 )
                     EndIf
                     
                  Else
                     If \h\hide <> #True
                        \h\hide = #True
                        ;// reset page pos then hide scrollbar
                        If \h\bar\page\pos > \h\bar\min
                           bar_PageChange( \h, \h\bar\min, #False )
                        EndIf
                     EndIf
                  EndIf
               EndIf
               
               result = 0
               
;                ;\\ update scrollbars parent inner coordinate
;                If *this\scroll_inner_width( ) <> \h\bar\page\len
;                   *this\scroll_inner_width( ) = \h\bar\page\len
;                   result = 1
;                EndIf
;                
;                If *this\scroll_inner_height( ) <> \v\bar\page\len
;                   *this\scroll_inner_height( ) = \v\bar\page\len
;                   result = 1
;                EndIf
            EndIf
            
            If result
;                PostEventsResize( *this )
               ProcedureReturn result
            EndIf
         EndWith
      EndProcedure
      
   Procedure   bar_mdi_resize( *this._s_WIDGET, X.l, Y.l, Width.l, Height.l )
     ;ProcedureReturn make_mdi_size( *this, X, Y, Width, Height )
      
      Static v_max, h_max
         Protected sx, sy, round, result
         Protected scroll_x, scroll_y, scroll_width, scroll_height
         
         With *this\scroll
            If Not ( *this\scroll And ( \v Or \h ))
               ProcedureReturn 0
            EndIf
            
            ;\\
               
            scroll_x      = *this\scroll_x( )
            scroll_y      = *this\scroll_y( )
            scroll_width  = *this\scroll_width( )
            scroll_height = *this\scroll_height( )
            
            scroll_width - *this\scroll_x( )
            scroll_height - *this\scroll_y( )
            
            ;\\ top set state
            If scroll_y > Y
               sy = ( scroll_y - Y )
               scroll_height + sy
               scroll_y = Y
               If \h\bar\page\len <> Width - Bool( scroll_height > Height ) * \v\width
                  \h\bar\page\len = Width - Bool( scroll_height > Height ) * \v\width
               EndIf
            Else
               \h\bar\page\len = Width - \v\width
            EndIf
            
            ;\\ left set state
            If scroll_x > X
               sx = ( scroll_x - X )
               scroll_width + sx
               scroll_x = X
               If \v\bar\page\len <> Height - Bool( scroll_width > Width ) * \h\height
                  \v\bar\page\len = Height - Bool( scroll_width > Width ) * \h\height
               EndIf
            Else
               \v\bar\page\len = Height - \h\height
            EndIf
            
            ;\\
            If scroll_width > \h\bar\page\len - ( scroll_x - X )
               If scroll_width - sx <= Width And scroll_height = \v\bar\page\len - ( scroll_y - Y )
                  ;Debug "w - " + Str( scroll_height - sx )
                  
                  ; if on the h - scroll
                  If \v\bar\max > Height - \h\height
                     \v\bar\page\len = Height - \h\height
                     \h\bar\page\len = Width - \v\width
                     scroll_height   = \v\bar\max
                     
                     If scroll_y <= Y
                        \v\bar\page\pos = - ( scroll_y - Y )
                     EndIf
                     ;  Debug "w - " + \v\bar\max  + " " +  \v\height  + " " +  \v\bar\page\len
                  Else
                     scroll_height = \v\bar\page\len - ( scroll_x - X ) - \h\height
                  EndIf
               EndIf
               
               \v\bar\page\len = Height - \h\height
               If scroll_x <= X
                  \h\bar\page\pos = - ( scroll_x - X )
                  ;h_max           = 0
               EndIf
            Else
               \h\bar\max   = scroll_width
               scroll_width = \h\bar\page\len - ( scroll_x - X )
            EndIf
            
            ;\\
            If scroll_height > \v\bar\page\len - ( scroll_y - Y )
               If scroll_height - sy <= Height And scroll_width = \h\bar\page\len - ( scroll_x - X )
                  ;Debug " h - " + Str( scroll_height - sy )
                  
                  ; if on the v - scroll
                  If \h\bar\max > Width - \v\frame_width( )
                     \h\bar\page\len = Width - \v\frame_width( )
                     \v\bar\page\len = Height - \h\frame_height( )
                     scroll_width    = \h\bar\max
                     
                     If scroll_x <= X
                        \h\bar\page\pos = - ( scroll_x - X )
                     EndIf
                     ;  Debug "h - " + \h\bar\max  + " " +  \h\frame_width( )  + " " +  \h\bar\page\len
                  Else
                     scroll_width = \h\bar\page\len - ( scroll_x - X ) - \v\frame_width( )
                  EndIf
               EndIf
               
               \h\bar\page\len = Width - \v\frame_width( )
               If scroll_y <= Y
                  \v\bar\page\pos = - ( scroll_y - Y )
                  ;v_max           = 0
               EndIf
            Else
               \v\bar\max    = scroll_height
               scroll_height = \v\bar\page\len - ( scroll_y - Y )
            EndIf
            
            ;\\
            If \h\round And
               \v\round And
               \h\bar\page\len < Width And
               \v\bar\page\len < Height
               round = ( \h\frame_height( ) / 4 )
            EndIf
            
            ;Debug ""+*this\scroll_width( ) +" "+ scroll_width
            
            ;\\
            If scroll_height >= \v\bar\page\len
               If \v\bar\Max <> scroll_height
                  \v\bar\Max = scroll_height
                  If scroll_y <= Y
                     \v\bar\page\pos = - ( scroll_y - Y )
                  EndIf
               EndIf
               
               If \v\height <> \v\bar\page\len + round
                  Resize( \v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\bar\page\len + round, 0 )
                  result = 1
               EndIf
            EndIf
            
            ;\\
            If scroll_width >= \h\bar\page\len
               If \h\bar\Max <> scroll_width
                  \h\bar\Max = scroll_width
                  If scroll_x <= X
                     \h\bar\page\pos = - ( scroll_x - X )
                  EndIf
               EndIf
               
               If \h\frame_width( ) <> \h\bar\page\len + round
                  Resize( \h, #PB_Ignore, #PB_Ignore, \h\bar\page\len + round, #PB_Ignore, 0 )
                  result = 1
               EndIf
            EndIf
            
            ;\\
            If test_resize_area
               Debug "  --- mdi_resize " + *this\class + " " + *this\inner_width( ) + " " + *this\inner_height( )
            EndIf
            
            ;\\
            If v_max <> \v\bar\Max
               v_max = \v\bar\Max
               bar_update( \v, 5 )
               result = 1
            EndIf
            
            ;\\
            If h_max <> \h\bar\Max
               h_max = \h\bar\Max
               bar_update( \h, 5 )
               result = 1
            EndIf
            
            ; Debug ""+\h\bar\thumb\len +" "+ \h\bar\page\len +" "+ \h\bar\area\len +" "+ \h\bar\thumb\end +" "+ \h\bar\page\end +" "+ \h\bar\area\end
            
            ;\\
            *this\scroll_x( )      = scroll_x
            *this\scroll_y( )      = scroll_y
            *this\scroll_width( )  = scroll_width
            *this\scroll_height( ) = scroll_height
            
            ;\\ update scrollbars parent inner coordinate
            If *this\scroll_inner_width( ) <> \h\bar\page\len
               *this\scroll_inner_width( ) = \h\bar\page\len
               Post( *this, #__event_Resize )
            EndIf
            If *this\scroll_inner_height( ) <> \v\bar\page\len
               *this\scroll_inner_height( ) = \v\bar\page\len
               Post( *this, #__event_Resize )
            EndIf
            
            ProcedureReturn result
         EndWith
      EndProcedure
      
   Procedure bar_area_resize_( *this._S_widget, X.l, Y.l, Width.l, Height.l )
      If ( *this\width = 0 And *this\height = 0)
         If *this\scroll
            *this\scroll\v\hide = #True
            *this\scroll\h\hide = #True
         EndIf
         ProcedureReturn 0
      EndIf
      
      With *this\scroll
         Protected v1, h1, x1 = #PB_Ignore, y1 = #PB_Ignore, width1 = #PB_Ignore, height1 = #PB_Ignore, iwidth, iheight, w, h
         ;Protected v1, h1, x1 = *this\x[#__c_container], y1 = *this\y[#__c_container], width1 = *this\width[#__c_container], height1 = *this\height[#__c_container], iwidth, iheight, w, h
         If Not \v Or Not \h : ProcedureReturn : EndIf
         
         If X = #PB_Ignore
            X = \h\x[#__c_container]
         EndIf
         If Y = #PB_Ignore
            Y = \v\y[#__c_container]
         EndIf
         If Width = #PB_Ignore
            Width = \v\x[#__c_frame] - \h\x[#__c_frame] + \v\width[#__c_frame]
         EndIf
         If Height = #PB_Ignore
            Height = \h\y[#__c_frame] - \v\y[#__c_frame] + \h\height[#__c_frame]
         EndIf
         
         w = Bool( *this\scroll_width( ) > Width )
         h = Bool( *this\scroll_height( ) > Height )
         
         \v\bar\page\len = Height - ( Bool( w Or \h\bar\max > \h\bar\page\len ) * \h\height )
         \h\bar\page\len = Width - ( Bool( h Or \v\bar\max > \v\bar\page\len ) * \v\width )
         
         iheight = Height - ( Bool( w Or \h\bar\max > \h\bar\page\len ) * \h\height )
         If \v\bar\page\len <> iheight
            ;\v\bar\AreaChange( ) = \v\bar\page\len - iheight
            \v\bar\page\len      = iheight
            
            If Not \v\bar\max
               If \v\bar\min > iheight
                  \v\bar\max = \v\bar\min + 1
               Else
                  \v\bar\max = iheight
               EndIf
            EndIf
         EndIf
         
         iwidth = Width - ( Bool( h Or \v\bar\max > \v\bar\page\len ) * \v\width )
         If \h\bar\page\len <> iwidth
            ;\h\bar\AreaChange( ) = \h\bar\page\len - iwidth
            \h\bar\page\len      = iwidth
            
            If Not \h\bar\max
               If \h\bar\min > iwidth
                  \h\bar\max = \h\bar\min + 1
               Else
                  \h\bar\max = iwidth
               EndIf
            EndIf
         EndIf
         
         Width + X
         Height + Y
         
         If \v\x[#__c_frame] <> Width - \v\width
            v1 = 1
            x1 = Width - \v\width
         EndIf
         
         If \h\y[#__c_frame] <> Height - \h\height
            h1 = 1
            y1 = Height - \h\height
         EndIf
         
         If \v\bar\max > \v\bar\page\len
            v1      = 1
            height1 = ( \v\bar\page\len + Bool( \h\bar\max > \h\bar\page\len And \v\round And \h\round ) * ( \h\height / 4 ) )
            If \v\hide <> #False
               \v\hide = #False
               If \h\hide
                  width1 = \h\bar\page\len
               EndIf
            EndIf
         Else
            If \v\hide <> #True
               \v\hide = #True
               ;*this\resize | #__resize_change
               ; reset page pos then hide scrollbar
               If \v\bar\page\pos > \v\bar\min
                  If bar_PageChange( \v, \v\bar\min )
                     bar_Update( \v, 0 )
                  EndIf
               EndIf
            EndIf
         EndIf
         
         If \h\bar\max > \h\bar\page\len
            h1     = 1
            width1 = ( \h\bar\page\len + Bool( \v\bar\max > \v\bar\page\len And \v\round And \h\round ) * ( \v\width / 4 ))
            If \h\hide <> #False
               \h\hide = #False
               If \v\hide
                  height1 = \v\bar\page\len
               EndIf
            EndIf
         Else
            If \h\hide <> #True
               \h\hide = #True
               ;*this\resize | #__resize_change
               ; reset page pos then hide scrollbar
               If \h\bar\page\pos > \h\bar\min
                  If bar_PageChange( \h, \h\bar\min )
                     bar_Update( \h, 0 )
                  EndIf
               EndIf
            EndIf
         EndIf
         
         If v1
            Resize( \v, x1 , Y, #PB_Ignore, height1 )
         EndIf
         If h1
            Resize( \h, X, y1, width1, #PB_Ignore )
         EndIf
         
         
;          If \v\bar\AreaChange( ) Or
;             \h\bar\AreaChange( )
;             ;           *this\resize | #__resize_change
;             ; Debug ""+*this\width[#__c_inner]  +" "+ \h\bar\page\len
;             ;          ;\\ update inner coordinate
;             ;         *this\width[#__c_inner]  = \h\bar\page\len
;             ;         *this\height[#__c_inner] = \v\bar\page\len
;             ;          
;             ProcedureReturn #True
;          EndIf
      EndWith
   EndProcedure
   
   Procedure Canvas_Draw(Canvas.i, List imgs.canvasitem())
      ;If StartDrawing(CanvasOutput(canvas))
         DrawingMode(#PB_2DDrawing_Default)
         Box(0, 0, OutputWidth(), OutputHeight(), RGB(255,255,255))
         
         ;ClipOutput(*this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\bar\page\len, *this\scroll\v\bar\page\len)
         
         DrawingMode(#PB_2DDrawing_AlphaBlend)
         ForEach imgs()
            DrawImage(ImageID(imgs()\img), imgs()\x, imgs()\y) ; draw all imgs with z-order
         Next
         
         Widget::Draw(*this\scroll\v)
         Widget::Draw(*this\scroll\h)
         
         UnclipOutput()
         DrawingMode(#PB_2DDrawing_Outlined)
         Box(X, Y, Width, Height, RGB(0,255,255))
         Box(*this\scroll_x( ), *this\scroll_y( ), *this\scroll_width( ), *this\scroll_height( ), RGB(255,0,255))
         Box(*this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\bar\page\len, *this\scroll\v\bar\page\len, RGB(255,255,0))
         
      ;   StopDrawing()
      ;EndIf
   EndProcedure
   
   Procedure Canvas_CallBack()
      Static set_cursor 
      Protected cursor
      Protected Repaint
      Protected Event = EventType()
      Protected Canvas = EventGadget()
      Protected MouseX 
      Protected MouseY
      
      Widget::EventHandler( Canvas, Event )
      
      MouseX = Widget::CanvasMouseX( )
      MouseY = Widget::CanvasMouseY( )
      
      Width = GadgetWidth(Canvas) - X*2
      Height = GadgetHeight(Canvas) - Y*2
      
      Select Event
         Case #PB_EventType_LeftButtonUp : Drag = #False
            
         Case #PB_EventType_LeftButtonDown
            If Not EnteredButton( ) ; (EventWidget( ) And EventWidget( )\bar\index > 0)
               Drag = Bool(HitTest(imgs(), Mousex, Mousey))
               If Drag 
                  Repaint = #True 
               EndIf
            EndIf
            
         Case #PB_EventType_MouseMove
            If Drag = #True
               If LastElement(imgs())
                  If imgs()\x <> Mousex - currentItemXOffset
                     imgs()\x = Mousex - currentItemXOffset
                     Repaint = #True
                  EndIf
                  
                  If imgs()\y <> Mousey - currentItemYOffset
                     imgs()\y = Mousey - currentItemYOffset
                     Repaint = #True
                  EndIf
                  
                  If Repaint
                     area_update( )
                     bar_mdi_resize( *this, X, Y, Width, Height)
                  EndIf
               EndIf
            EndIf
            
         Case #PB_EventType_Resize 
            ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
            area_update( )
            bar_area_resize_( *this, X, Y, Width, Height )
            ;bar_mdi_resize( *this, x, y, width, height)
            
            Repaint = #True
            
         Case #PB_EventType_Repaint : Repaint = #True 
      EndSelect
      
      If Repaint 
        ; Canvas_Draw(Canvas, imgs()) 
      EndIf
   EndProcedure
   Procedure events_draw()
     Canvas_Draw(MyCanvas, imgs()) 
   EndProcedure
   
   
   
   Procedure events_scrolls()
      Select WidgetEvent( ) ;   WidgetEvent( ) ; 
         Case #__event_Change
            If EventWidget( )\bar\vertical
               PushListPosition(imgs())
               ForEach imgs()
                  imgs()\Y + WidgetEventData( ) 
               Next
               PopListPosition(imgs())
               
               ;Debug ""+*this\class +" - "+ EventWidget( )\parent\class
               *this\scroll_y( ) =- EventWidget( )\bar\page\pos + EventWidget( )\y
            Else
               
               PushListPosition(imgs())
               ForEach imgs()
                  imgs()\X + WidgetEventData( )
               Next
               PopListPosition(imgs())
               
               *this\scroll_x( ) =- EventWidget( )\bar\page\pos + EventWidget( )\x
            EndIf
      EndSelect
   EndProcedure
   
   If Not OpenWindow(0, 0, 0, Width+X*2+20, Height+Y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
      MessageRequester("Fatal error", "Program terminated.")
      End
   EndIf
   
   MyCanvas = GetCanvasGadget(Open(0, 10, 10)) 
   BindGadgetEvent(MyCanvas, @Canvas_CallBack())
   Bind(Root( ), @events_draw(), #__event_Draw)
   
;    *this\frame_y() = 100
;    *this\inner_y() = 100
  ; Resize(*this, X, Y, Width, Height)
   *this\scroll\v = Widget::Scroll(X+Width-20, Y, 20, 0, 0, 0, Width-20, #__flag_Vertical|#__flag_Invert, 11)
   *this\scroll\h = Widget::Scroll(X, Y+Height-20, 0,  20, 0, 0, Height-20, #__flag_Invert, 11)
  ; *this\scroll\v\parent = *this
   
   area_update( )
   bar_mdi_resize( *this, X, Y, Width, Height)
            
   Bind(*this\scroll\v, @events_scrolls())
   Bind(*this\scroll\h, @events_scrolls())
   
   
   Repeat
      Event = WaitWindowEvent()
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 90
; FirstLine = 35
; Folding = 840-------8----z-8-
; EnableXP