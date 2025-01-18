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
   
   Global MyCanvas, *this.allocate( widget ) 
   
   Global *current=#False
   Global currentItemXOffset.i, currentItemYOffset.i
   Global Event.i, drag.i, hole.i
   Global X=100,Y=100, Width=420, Height=420 , focus
   
   Global NewList Images.canvasitem()
   
   
   Procedure.i HitTest (List Images.canvasitem(), X, Y)
      Shared currentItemXOffset.i, currentItemYOffset.i
      Protected alpha.i, *current = #False
      Protected scroll_x ; = *this\scroll\h\bar\Page\Pos
      Protected scroll_y ;= *this\scroll\v\bar\Page\Pos
      
      If LastElement(Images()) ; search for hit, starting from end (z-order)
         Repeat
            If X >= Images()\x - scroll_x And X < Images()\x+ Images()\width - scroll_x 
               If Y >= Images()\y - scroll_y And Y < Images()\y + Images()\height - scroll_y
                  alpha = 255
                  
                  If Images()\alphatest And ImageDepth(Images()\img)>31
                     If StartDrawing(ImageOutput(Images()\img))
                        DrawingMode(#PB_2DDrawing_AlphaChannel)
                        alpha = Alpha(Point(X-Images()\x - scroll_x, Y-Images()\y - scroll_y)) ; get alpha
                        StopDrawing()
                     EndIf
                  EndIf
                  
                  If alpha
                     MoveElement(Images(), #PB_List_Last)
                     *current = @Images()
                     currentItemXOffset = X - Images()\x - scroll_x
                     currentItemYOffset = Y - Images()\y - scroll_y
                     Break
                  EndIf
               EndIf
            EndIf
         Until PreviousElement(Images()) = 0
      EndIf
      
      ProcedureReturn *current
   EndProcedure
   
   Procedure AddImage (List Images.canvasitem(), X, Y, img, alphatest=0)
      If AddElement(Images())
         Images()\img    = img
         Images()\x          = X
         Images()\y          = Y
         Images()\width  = ImageWidth(img)
         Images()\height = ImageHeight(img)
         Images()\alphatest = alphatest
      EndIf
   EndProcedure
   
   AddImage(Images(),  X-80, Y-20, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp"))
   AddImage(Images(), X+100,Y+100, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp"))
   ;AddImage(Images(),  x+221,y+200, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp"))
   ;AddImage(Images(),  x+210,y+321, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp"))
   ;AddImage(Images(),  x,y-1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp"))
   AddImage(Images(),  X+310,Y+350, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp"))
   
   hole = CreateImage(#PB_Any,100,100,32)
   If StartDrawing(ImageOutput(hole))
      DrawingMode(#PB_2DDrawing_AllChannels)
      Box(0,0,100,100,RGBA($00,$00,$00,$00))
      Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
      Circle(50,50,30,RGBA($00,$00,$00,$00))
      StopDrawing()
   EndIf
   AddImage(Images(),X+170,Y+70,hole,1)
   
   
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
            \v\bar\AreaChange( ) = \v\bar\page\len - iheight
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
            \h\bar\AreaChange( ) = \h\bar\page\len - iwidth
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
         
         
         If \v\bar\AreaChange( ) Or
            \h\bar\AreaChange( )
            ;           *this\resize | #__resize_change
            ; Debug ""+*this\width[#__c_inner]  +" "+ \h\bar\page\len
            ;          ;\\ update inner coordinate
            ;         *this\width[#__c_inner]  = \h\bar\page\len
            ;         *this\height[#__c_inner] = \v\bar\page\len
            ;          
            ProcedureReturn #True
         EndIf
      EndWith
   EndProcedure
   
   Macro area_update( )
      *this\x[#__c_required] = Images()\x 
      *this\y[#__c_required] = Images()\Y
      *this\width[#__c_required] = Images()\x+Images()\width - *this\x[#__c_required]
      *this\height[#__c_required] = Images()\Y+Images()\height - *this\y[#__c_required]
      
      PushListPosition(Images())
      ForEach Images()
         If *this\x[#__c_required] > Images()\x : *this\x[#__c_required] = Images()\x : EndIf
         If *this\y[#__c_required] > Images()\y : *this\y[#__c_required] = Images()\y : EndIf
      Next
      ForEach Images()
         If *this\width[#__c_required] < Images()\x+Images()\width - *this\x[#__c_required] : *this\width[#__c_required] = Images()\x+Images()\width - *this\x[#__c_required] : EndIf
         If *this\height[#__c_required] < Images()\Y+Images()\height - *this\y[#__c_required] : *this\height[#__c_required] = Images()\Y+Images()\height - *this\y[#__c_required] : EndIf
      Next
      PopListPosition(Images())
   EndMacro
   
   Procedure Canvas_Draw(Canvas.i, List Images.canvasitem())
      ;If StartDrawing(CanvasOutput(canvas))
         DrawingMode(#PB_2DDrawing_Default)
         Box(0, 0, OutputWidth(), OutputHeight(), RGB(255,255,255))
         
         ;ClipOutput(*this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\bar\page\len, *this\scroll\v\bar\page\len)
         
         DrawingMode(#PB_2DDrawing_AlphaBlend)
         ForEach Images()
            DrawImage(ImageID(Images()\img), Images()\x, Images()\y) ; draw all images with z-order
         Next
         
         widget::Draw(*this\scroll\v)
         widget::Draw(*this\scroll\h)
         
         UnclipOutput()
         DrawingMode(#PB_2DDrawing_Outlined)
         Box(X, Y, Width, Height, RGB(0,255,255))
         Box(*this\x[#__c_required], *this\y[#__c_required], *this\width[#__c_required], *this\height[#__c_required], RGB(255,0,255))
         Box(*this\x[#__c_required], *this\y[#__c_required], *this\scroll\h\bar\max, *this\scroll\v\bar\max, RGB(255,0,0))
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
      
      widget::EventHandler( Canvas, Event )
      
      MouseX = widget::mouse( )\x
      MouseY = widget::mouse( )\y
      
      Width = GadgetWidth(Canvas) - X*2
      Height = GadgetHeight(Canvas) - Y*2
      
      Select Event
         Case #PB_EventType_LeftButtonUp : Drag = #False
            
         Case #PB_EventType_LeftButtonDown
            If Not EnteredButton( ) ; (EventWidget( ) And EventWidget( )\bar\index > 0)
               Drag = Bool(HitTest(Images(), Mousex, Mousey))
               If Drag 
                  Repaint = #True 
               EndIf
            EndIf
            
         Case #PB_EventType_MouseMove
            If Drag = #True
               If LastElement(Images())
                  If Images()\x <> Mousex - currentItemXOffset
                     Images()\x = Mousex - currentItemXOffset
                     Repaint = #True
                  EndIf
                  
                  If Images()\y <> Mousey - currentItemYOffset
                     Images()\y = Mousey - currentItemYOffset
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
        ; Canvas_Draw(Canvas, Images()) 
      EndIf
   EndProcedure
   Procedure events_draw()
     Canvas_Draw(MyCanvas, Images()) 
   EndProcedure
   
   
   
   Procedure events_scrolls()
      Select WidgetEvent( ) ;   WidgetEvent( ) ; 
         Case #__event_Change
            If EventWidget( )\bar\vertical
               PushListPosition(Images())
               ForEach Images()
                  Images()\Y + EventWidget( )\bar\page\change 
               Next
               PopListPosition(Images())
               
               *this\y[#__c_required] =- EventWidget( )\bar\page\pos + EventWidget( )\y
            Else
               
               PushListPosition(Images())
               ForEach Images()
                  Images()\X + EventWidget( )\bar\page\change
               Next
               PopListPosition(Images())
               
               *this\x[#__c_required] =- EventWidget( )\bar\page\pos + EventWidget( )\x
            EndIf
      EndSelect
   EndProcedure
   
   If Not OpenWindow(0, 0, 0, Width+X*2+20, Height+Y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
      MessageRequester("Fatal error", "Program terminated.")
      End
   EndIf
   
   MyCanvas = GetCanvasGadget(Open(0, 10, 10)) 
   BindGadgetEvent(MyCanvas, @Canvas_CallBack())
   Bind(root( ), @events_draw(), #__event_Draw)
   
   *this\scroll\v = widget::Scroll(X+Width-20, Y, 20, 0, 0, 0, Width-20, #__flag_Vertical|#__flag_Invert, 11)
   *this\scroll\h = widget::Scroll(X, Y+Height-20, 0,  20, 0, 0, Height-20, #__flag_Invert, 11)
   
   bar_mdi_resize( *this, X, Y, Width, Height)
            
   Bind(*this\scroll\v, @events_scrolls())
   Bind(*this\scroll\h, @events_scrolls())
   
   
   Repeat
      Event = WaitWindowEvent()
   Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 375
; FirstLine = 174
; Folding = 8-+----0---
; EnableXP