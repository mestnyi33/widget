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
   
   Procedure AddImage (List imgs.canvasitem(), img_x, img_y, img, alphatest=0)
      If AddElement(imgs())
         imgs()\img    = img
         imgs()\x          = img_x
         imgs()\y          = img_y
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
   ;AddImage(imgs(),  X+100,Y+200, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp"))
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
   
   ;-
   Macro make_mdi_area_size( _address_ )
      *this\scroll_x( ) = _address_\x 
      *this\scroll_y( ) = _address_\Y
      If *this\scroll_x( ) < 0
         *this\scroll_width( ) = *this\inner_width( ) - *this\scroll_x( )
      Else
         *this\scroll_width( ) = _address_\width
      EndIf
      If *this\scroll_y( ) < 0
         *this\scroll_height( ) = *this\inner_height( ) - *this\scroll_y( ) 
      Else
         *this\scroll_height( ) = _address_\height
      EndIf
         
      PushListPosition(_address_)
      ForEach _address_
         If *this\scroll_x( ) > _address_\x
            *this\scroll_x( ) = _address_\x
         EndIf
         If *this\scroll_y( ) > _address_\Y
            *this\scroll_y( ) = _address_\Y
         EndIf
         If *this\scroll_width( ) < _address_\x + _address_\width
            *this\scroll_width( ) = _address_\x + _address_\width
         EndIf
         If *this\scroll_height( ) < _address_\Y + _address_\height
            *this\scroll_height( ) = _address_\Y + _address_\height
         EndIf
     Next
      PopListPosition(_address_)
   EndMacro
   
   
   Procedure   make_pos_and_max( *this._s_WIDGET, X, Y, Width, Height )
         make_mdi_area_size( imgs() )
         Protected round, result
         
         With *this\scroll
            If Not ( *this\scroll And ( \v Or \h ))
               ProcedureReturn 0
            EndIf
            
            If Not *this\haschildren
               ProcedureReturn 0
            EndIf
            
            ;\\
                        If *this\scroll_x( ) < X
;                            *this\scroll_width( ) - *this\scroll_x( )
;                            If *this\scroll_width( ) < Width
;                               *this\scroll_width( ) = Width
;                            EndIf
                        Else
                           *this\scroll_x( ) = X
                        EndIf
                        If *this\scroll_y( ) < Y 
;                            *this\scroll_height( ) - *this\scroll_y( )
;                            If *this\scroll_height( ) < Height
;                               *this\scroll_height( ) = Height
;                            EndIf
                        Else
                           *this\scroll_y( ) = Y
                        EndIf
                        
            ;\\
            \v\bar\page\pos = - (*this\scroll_y( ) - Y)
            \h\bar\page\pos = - (*this\scroll_x( ) - X)
            
            ;\\
            If \h\bar\Max <> *this\scroll_width( )
               \h\bar\Max = *this\scroll_width( )
               result = 1
            EndIf
            
            If \v\bar\Max <> *this\scroll_height( )
               \v\bar\Max = *this\scroll_height( ) 
               result = 1
            EndIf
            
            ;\\
            If result
               \v\bar\page\len = Height - ( Bool( Not \h\hide[1] And (\h\bar\Max >= Width Or \h\bar\max > \h\bar\page\len) ) * \h\frame_height( ))
               \h\bar\page\len = Width - ( Bool( Not \v\hide[1] And (\v\bar\Max >= Height Or \v\bar\max > \v\bar\page\len) ) * \v\frame_width( ) )
               
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
               
               ProcedureReturn result
            EndIf
         EndWith
      EndProcedure
      Procedure   _make_pos_and_max( *this._s_WIDGET, X.l, Y.l, Width.l, Height.l )
      
      Static v_max, h_max
      Protected round, result
      
      With *this\scroll
         If Not ( *this\scroll And ( \v Or \h ))
            ProcedureReturn 0
         EndIf
         
;          make_mdi_area_size( X, Y, Width -  ( Bool( Not \v\hide[1] And (\v\bar\max > \v\bar\page\len) ) * \v\frame_width( ) ), 
;                                         Height - ( Bool( Not \h\hide[1] And (\h\bar\max > \h\bar\page\len) ) * \h\frame_height( )))
       
         make_mdi_area_size( imgs() )
       
         ;\\
         *this\scroll_width( ) - *this\scroll_x( )
         *this\scroll_height( ) - *this\scroll_y( )
         
         \h\bar\page\pos = - ( *this\scroll_x( ) - X )
         \v\bar\page\pos = - ( *this\scroll_y( ) - Y )
         
         ;\\
         If \v\bar\Max <> *this\scroll_height( )
            \v\bar\Max = *this\scroll_height( )
            result = 1
         EndIf
         
         If \h\bar\Max <> *this\scroll_width( )
            \h\bar\Max = *this\scroll_width( )
            result = 1
         EndIf
         ;Debug \v\bar\page\len
         ;\\
         If result 
;             \v\bar\page\len = Height - ( Bool( Not \h\hide[1] And (*this\scroll_width( ) >= Width Or \h\bar\max > \h\bar\page\len) ) * \h\frame_height( ))
;                \h\bar\page\len = Width - ( Bool( Not \v\hide[1] And (*this\scroll_height( ) >= Height Or \v\bar\max > \v\bar\page\len) ) * \v\frame_width( ) )
; ;                  Height = ( \v\bar\page\len + Bool( Not \h\hide[1] And \h\bar\max > \h\bar\page\len And \v\round And \h\round ) * ( \h\height / 4 ) )
; ;                 Width = ( \h\bar\page\len + Bool( Not \v\hide[1] And \v\bar\max > \v\bar\page\len And \v\round And \h\round ) * ( \v\frame_width( ) / 4 ))
                        
            If *this\scroll_width( ) > Width And
               *this\scroll_height( ) > Height
               round = ( \h\frame_height( ) / 4 )
            Else
               round = 20
               If *this\scroll_width( ) > Width 
                 \v\bar\page\len = Width - 20 
               EndIf
               If *this\scroll_height( ) > Height
                 \h\bar\page\len = Height - 20
               EndIf
            EndIf
            
            If \v\height <> \v\bar\page\len + round
               Resize( \v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\bar\page\len + round, 0 )
            Else
               If v_max <> \v\bar\Max
                  v_max = \v\bar\Max
                  bar_update( \v, 5 )
               EndIf
            EndIf
            
            If \h\frame_width( ) <> \h\bar\page\len + round
               Resize( \h, #PB_Ignore, #PB_Ignore, \h\bar\page\len + round, #PB_Ignore, 0 )
            Else
               If h_max <> \h\bar\Max
                  h_max = \h\bar\Max
                  bar_update( \h, 5 )
               EndIf
            EndIf
            
            ProcedureReturn result
         EndIf
         
      EndWith
   EndProcedure
   
   ;-
   Procedure   _bar_area_resize_( *this._s_WIDGET, X.l, Y.l, Width.l, Height.l )
         Protected.b result, resize_v, resize_h
         Protected.l x1 = #PB_Ignore, y1 = #PB_Ignore, iwidth, iheight, w, h
         
         With *this\scroll
            If Not ( *this\scroll And ( \v Or \h ))
               ProcedureReturn 0
            EndIf
            
            If *this\screen_width( ) = 0 And 
               *this\screen_height( ) = 0
               \v\hide = #True
               \h\hide = #True
              ; ProcedureReturn 0
            EndIf
            
;             Width = *this\container_width( ) 
;             Height =  *this\container_height( )
            
            w = Bool( *this\scroll_width( ) > Width )
            h = Bool( *this\scroll_height( ) > Height )
            
            
            ;   ProcedureReturn 
         \v\bar\page\len = Height - ( Bool( w Or \h\bar\max > \h\bar\page\len ) * \h\frame_height( ))
            \h\bar\page\len = Width - ( Bool( h Or \v\bar\max > \v\bar\page\len ) * \v\frame_width( ))
             
            iheight = Height - ( Bool( Not \h\hide[1] And (w Or \h\bar\max > \h\bar\page\len) ) * \h\frame_height( )) 
            If \v\bar\page\len <> iheight
               \v\bar\page\len = iheight
               If Not \v\bar\max
                 ; bar_max( \v\bar, iheight )
               EndIf
;             Else
;                If \h\bar\area\len And \h\bar\page\end
;                   ;If \v\bar\thumb\len = \v\bar\thumb\end 
;                   ;  bar_update( \v, 10 )
;                   ;EndIf
;                   bar_update( \h, 10 )
;                EndIf
            EndIf
            
            iwidth = Width - ( Bool( Not \v\hide[1] And (h Or \v\bar\max > \v\bar\page\len) ) * \v\frame_width( )) 
            If \h\bar\page\len <> iwidth
               \h\bar\page\len = iwidth
               If Not \h\bar\max
                 ; bar_max( \h\bar, iwidth )
               EndIf
;             Else
;                If \v\bar\area\len And \v\bar\page\end
;                   ; Debug ""+\v\bar\area\len +" "+ \v\bar\thumb\len +" "+ \v\bar\thumb\end 
;                   ;If \h\bar\thumb\len = \h\bar\thumb\end 
;                   ;  bar_update( \h, 11 )
;                   ;EndIf
;                   bar_update( \v, 11 )
;                EndIf
            EndIf
            
        ; no auto size scroll inner size
            If *this\type = #__type_ScrollArea
               If \v\bar\page\len > \v\bar\max
                  \v\bar\page\len = \v\bar\max
               EndIf
               If \h\bar\page\len > \h\bar\max
                  \h\bar\page\len = \h\bar\max
               EndIf
            EndIf
            
            X+\h\bar\page\len + 19
            Y+\v\bar\page\len + 19
            ;             
            If Not \v\hide[1]
               If \v\bar\max > \v\bar\page\len
                  Height = ( \v\bar\page\len + Bool( Not \h\hide[1] And \h\bar\max > \h\bar\page\len And \v\round And \h\round ) * ( \h\height / 4 ) )
                  If \v\frame_height( ) <> Height
                     ;\v\hide = \v\hide[1]
                     resize_v = 1
                  EndIf
                  
                  If \v\frame_x( ) <> *this\inner_x( ) + (*this\container_width( ) - \v\frame_width( )) 
                     resize_v = 1
                     x1 = *this\inner_x( ) + (*this\container_width( ) - \v\frame_width( )) 
                  Else
                     x1 = \v\frame_x( )
                     
                     If \v\frame_y( ) <> *this\inner_y( )
                        resize_v = 1
                     EndIf
                  EndIf
                  
                  If resize_v ; And Not \v\hide
                     If test_resize_area
                        Debug "         v "+\v\frame_x( ) +" "+ x1 ; \v\frame_y( ) +" "+ Str(*this\frame_y( ) + Y)
                     EndIf
                     Resize( \v, X + x1-*this\inner_x( ), #PB_Ignore, #PB_Ignore, Height )
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
;             Else
;                If \v\hide
;                   If \v\frame_height( ) <> *this\container_height( )
;                      Resize( \v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *this\container_height( ))
;                   EndIf
;                EndIf
            EndIf
            
            ;
            If Not \h\hide[1]
               If \h\bar\max > \h\bar\page\len
                  Width = ( \h\bar\page\len + Bool( Not \v\hide[1] And \v\bar\max > \v\bar\page\len And \v\round And \h\round ) * ( \v\frame_width( ) / 4 ))
                  If \h\frame_width( ) <> Width
                     ;\h\hide = \h\hide[1]
                     resize_h    = 1
                  EndIf
                  
                  If \h\frame_y( ) <> *this\inner_y( ) + (*this\container_height( ) - \h\frame_height( ))
                     resize_h = 1
                     y1 = *this\inner_y( ) + (*this\container_height( ) - \h\frame_height( ))
                  Else
                     y1 = \h\frame_y( )
                     If \h\frame_x( ) <> *this\inner_x( )
                        resize_h = 1
                     EndIf
                  EndIf
                  
                  If resize_h ;And Not \h\hide
                     If test_resize_area
                        Debug "         h "+\h\frame_y( ) +" "+ y1
                     EndIf
                     Resize( \h, #PB_Ignore, Y + y1-*this\inner_y( ), Width, #PB_Ignore )
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
;             Else
;                If \h\hide
;                   If \h\frame_width( ) <> *this\container_width( )
;                      Resize( \h, #PB_Ignore, #PB_Ignore, *this\container_width( ), #PB_Ignore)
;                   EndIf
;                EndIf
            EndIf
            
;             ;\\ update scrollbars parent inner coordinate
;             If *this\scroll_inner_width( ) <> \h\bar\page\len
;                *this\scroll_inner_width( ) = \h\bar\page\len
;                result = 1
;             EndIf
;             If *this\scroll_inner_height( ) <> \v\bar\page\len
;                *this\scroll_inner_height( ) = \v\bar\page\len
;                result = 1
;             EndIf
            
            If result
               PostEventsResize( *this )
               ProcedureReturn result
            EndIf
         EndWith
      EndProcedure
      
   Procedure bar_area_resize_( *this._S_widget, X.l, Y.l, Width.l, Height.l )
;       If ( *this\width = 0 And *this\height = 0)
;          If *this\scroll
;             *this\scroll\v\hide = #True
;             *this\scroll\h\hide = #True
;          EndIf
;          ProcedureReturn 0
;       EndIf
       
      
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
                     make_pos_and_max( *this, X, Y, Width, Height)
                  EndIf
               EndIf
            EndIf
            
         Case #PB_EventType_Resize 
            ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
            make_mdi_area_size( imgs() )
            bar_area_resize_( *this, X, Y, Width, Height )
            ;make_pos_and_max( *this, x, y, width, height)
            
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
   Define invert = #__flag_Invert
   *this\scroll\v = Widget::Scroll(X+Width-20, Y, 20, 0, 0, 0, Width-20, #__flag_Vertical|invert, 11)
   *this\scroll\h = Widget::Scroll(X, Y+Height-20, 0,  20, 0, 0, Height-20, invert, 11)
   ; *this\scroll\v\parent = *this
   
   make_pos_and_max( *this, X, Y, Width, Height)
   
   Bind(*this\scroll\v, @events_scrolls())
   Bind(*this\scroll\h, @events_scrolls())
   
   
   Repeat
      Event = WaitWindowEvent()
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 90
; FirstLine = 87
; Folding = --+-----------------
; EnableXP