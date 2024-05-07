XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   Uselib(widget)
   
   EnableExplicit
   Global Event.i, MyCanvas, *mdi._s_widget, vButton, hButton
   Global x=200,y=150, width=320, height=320 , focus
   
   Enumeration 1
      #Window
      #Canvas
      #Font
   EndEnumeration
   
   ; Load a font
   LoadFont(#Font, "Arial", 12)
   
  Procedure.i HSVA(Hue.i, Saturation.i, Value.i, Aplha.i=255) ; [0,360], [0,100], [0,255], [0,255]
      Protected H.i = Int(Hue/60)
      Protected f.f = (Hue/60-H)
      Protected p = Value * (1-Saturation/100.0)
      Protected q = Value * (1-Saturation/100.0*f)
      Protected t = Value * (1-Saturation/100.0*(1-f))
      Select H
         Case 1 : ProcedureReturn RGBA(q,Value,p, Aplha)
         Case 2 : ProcedureReturn RGBA(p,Value,t, Aplha)
         Case 3 : ProcedureReturn RGBA(p,q,Value, Aplha)  
         Case 4 : ProcedureReturn RGBA(t,p,Value, Aplha)
         Case 5 : ProcedureReturn RGBA(Value,p,q, Aplha)  
         Default : ProcedureReturn RGBA(Value,t,p, Aplha)
      EndSelect
   EndProcedure
   
    Procedure Button_DrawCallback(*Object._s_widget, Width.i, Height.i, DataValue.i)
      Protected Text.s = GetText(*Object)
      Protected Hue = DataValue
        Protected x, y
       Button_Draw( *Object )
     
   EndProcedure
   
   Procedure MDI_ObjectEvents( )
      Protected *ew._s_widget = EventWidget( )
      Static DragWidget
      
      Select WidgetEventType( )
            ;       Case #__event_MouseEnter
            ;         SetCursor( *ew, #PB_Cursor_Hand )
            ;         
            ;       Case #__event_MouseLeave
            ;         SetCursor( *ew, #PB_Cursor_Default )
            
         Case #__event_LeftButtonUp 
            DragWidget = #Null
            
         Case #__event_LeftButtonDown
            DragWidget = *ew
            
         Case #__event_MouseMove
            If DragWidget = *ew
               Resize( *ew, mouse()\x-mouse()\delta\x, mouse()\y-mouse()\delta\y, #PB_Ignore, #PB_Ignore)
            EndIf
            
         Case #__event_Draw
;             With *ew
; ;                StartVectorDrawing( CanvasVectorOutput( \root\canvas\gadget ))
; ;                TranslateCoordinates(\x[#__c_frame], \y[#__c_frame])
;                Button_DrawCallback(*ew, \width[#__c_frame], \height[#__c_frame], \data)
; ;                StopVectorDrawing( )
;              EndWith
             
;              
;             ; Demo draw line on the element
;             UnclipOutput()
;             DrawingMode(#PB_2DDrawing_Outlined)
;             
;             Protected draw_color 
;             If *ew\width[#__c_draw] > 0 And
;                *ew\height[#__c_draw] > 0
;                draw_color = $ff00ff00
;             Else
;                draw_color = $ff00ffff
;             EndIf
;             
;             If *ew\round
;                RoundBox(*ew\x,*ew\y,*ew\width,*ew\height, *ew\round, *ew\round, draw_color)
;             Else
;                Box(*ew\x,*ew\y,*ew\width,*ew\height, draw_color)
;             EndIf
;             
;             With *ew\parent\scroll
;                Box( x, y, Width, Height, RGB( 0,255,0 ) )
;                Box( \h\x, \v\y, \h\bar\page\len, \v\bar\page\len, RGB( 0,0,255 ) )
;                Box( \h\x-\h\bar\page\pos, \v\y - \v\bar\page\pos, \h\bar\max, \v\bar\max, RGB( 255,0,0 ) )
;             EndWith
      EndSelect
      
   EndProcedure
   
   Procedure MDI_AddObject( *mdi, type, x, y, width, height, text.s, round=0 )
      Protected *Object._s_widget
      
      *Object = AddItem( *mdi, -1, "", -1, #__flag_BorderLess )
      *Object\class = "draw-"+Str(type)
      *Object\cursor = #PB_Cursor_Hand
      *Object\round = round
      
      If type = #PB_GadgetType_Button
        *Object\root\widget = Button(0,0,0,0,text,#__flag_autosize, -1, round)
      EndIf
      
      Resize(*Object, x, y, width, height)
      
      *Object = *Object\root\widget
      Bind( *Object, @MDI_ObjectEvents(), #__event_LeftButtonUp )
      Bind( *Object, @MDI_ObjectEvents(), #__event_LeftButtonDown )
      Bind( *Object, @MDI_ObjectEvents(), #__event_MouseMove )
      Bind( *Object, @MDI_ObjectEvents(), #__event_MouseEnter )
      Bind( *Object, @MDI_ObjectEvents(), #__event_MouseLeave )
      Bind( *Object, @MDI_ObjectEvents(), #__event_Draw )
      Bind( #PB_All, @MDI_ObjectEvents(), #__event_Repaint )
   EndProcedure
   
   ;- \\
   Procedure Canvas_resize( )
      ;Protected width = GadgetWidth( EventGadget() )
      Protected width = WindowWidth( EventWindow() )
      Resize( Root(), #PB_Ignore, #PB_Ignore, width, #PB_Ignore )
      Resize( *mdi, #PB_Ignore, #PB_Ignore, width-x*2, #PB_Ignore )
   EndProcedure
   
   Procedure Gadgets_Events()
      Select EventGadget()
         Case 2
            If GetGadgetState(2)
                  SetGadgetText(2, "vertical bar")
              SetGadgetState(3, GetAttribute(*mdi\scroll\v, #__bar_invert))
            Else
                SetGadgetText(2, "horizontal bar")
                SetGadgetState(3, GetAttribute(*mdi\scroll\h, #__bar_invert))
            EndIf
            
         Case 3
            If GetGadgetState(2)
               SetAttribute(*mdi\scroll\v, #__bar_invert, Bool(GetGadgetState(3)))
               SetWindowTitle(0, Str(GetState(*mdi\scroll\v)))
            Else
               SetAttribute(*mdi\scroll\h, #__bar_invert, Bool(GetGadgetState(3)))
               SetWindowTitle(0, Str(GetState(*mdi\scroll\h)))
            EndIf
            
         Case 4
            If GetGadgetState(2)
               SetAttribute(*mdi\scroll\v, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * vButton)
               SetWindowTitle(0, Str(GetState(*mdi\scroll\v)))
            Else
               SetAttribute(*mdi\scroll\h, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * hButton)
               SetWindowTitle(0, Str(GetState(*mdi\scroll\h)))
            EndIf
            
          Case 5
            
      EndSelect
   EndProcedure
   
   Define yy = 90
   Define xx = 0
   If Not OpenWindow( 0, 0, 0, Width+x*2+20+xx, Height+y*2+20+yy, "Move/Drag Canvas Object", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered ) 
      MessageRequester( "Fatal error", "Program terminated." )
      End
   EndIf
   
   ;BindEvent(#PB_Event_SizeWindow, @Window_Resize(), 0)
   ;
   CheckBoxGadget(5, 10, 10, 80,20, "clipoutput") : SetGadgetState(5, 1)
   CheckBoxGadget(2, 10, 30, 80,20, "vertical bar") : SetGadgetState(2, 1)
   CheckBoxGadget(3, 30, 50, 80,20, "invert")
   CheckBoxGadget(4, 30, 70, 80,20, "noButtons")
   
   If CreateImage(0, 200, 80)
      
      StartDrawing(ImageOutput(0))
      
      FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
      
      DrawingMode(#PB_2DDrawing_Default)
      Box(5, 10, 30, 2, RGB( 0,255,0 ))
      Box(5, 10+25, 30, 2, RGB( 0,0,255 ))
      Box(5, 10+50, 30, 2, RGB( 255,0,0 ))
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(40, 5, "frame - (coordinate color)",0,0)
      DrawText(40, 30, "page - (coordinate color)",0,0)
      DrawText(40, 55, "max - (coordinate color)",0,0)
      
      StopDrawing() ; This is absolutely needed when the drawing operations are finished !!! Never forget it !
      
   EndIf
   ImageGadget(#PB_Any, Width+x*2+20-210,10,200,80, ImageID(0) )
   
   Define round = 50
   
   ;
   MyCanvas = GetGadget(Open(0, xx+10, yy+10, Width+x*2, Height+y*2 ) )
   SetColor(root(), #__color_back, $ffffffff)
   
   ;BindGadgetEvent(MyCanvas, @Canvas_resize(), #PB_EventType_Resize )
   ;   ;BindEvent(#PB_Event_SizeWindow, @Canvas_resize());, GetWindow(Root()), MyCanvas, #PB_EventType_Resize )
   
   *mdi = MDI(x,y,width,height);, #__flag_autosize)
                               ;a_init( *mdi )
   SetColor(*mdi, #__color_back, $ffffffff)
   ;SetColor(*mdi, #__color_frame, $ffffffff)
   
   Define b=19;20        
   *mdi\scroll\v\round = 11
   *mdi\scroll\v\bar\button[1]\round = *mdi\scroll\v\round
   *mdi\scroll\v\bar\button[2]\round = *mdi\scroll\v\round
   *mdi\scroll\v\bar\button\round = *mdi\scroll\v\round
   SetAttribute(*mdi\scroll\v, #__bar_buttonsize, b)
   
   *mdi\scroll\h\round = 11
   *mdi\scroll\h\bar\button[1]\round = *mdi\scroll\h\round
   *mdi\scroll\h\bar\button[2]\round = *mdi\scroll\h\round
   *mdi\scroll\h\bar\button\round = *mdi\scroll\h\round
   SetAttribute(*mdi\scroll\h, #__bar_buttonsize, b)
   
   ;Debug *mdi\Scroll\v\round
   vButton = GetAttribute(*mdi\Scroll\v, #__bar_buttonsize);+1
   hButton = GetAttribute(*mdi\Scroll\h, #__bar_buttonsize);+1
   
   MDI_AddObject( *mdi, #PB_GadgetType_Button, -80, -20, 100,100, "1" )
   MDI_AddObject( *mdi, #PB_GadgetType_Button, 100, 120, 100,100, "1" )
   MDI_AddObject( *mdi, #PB_GadgetType_Button, 210, 250, 100,100, "1" )
   
   MDI_AddObject( *mdi, #PB_GadgetType_Button, -70,240, 100,100, "1", round )
   MDI_AddObject( *mdi, #PB_GadgetType_Button, 90,30, 100,100, "1" , 100)
   
   BindEvent( #PB_Event_Gadget, @Gadgets_Events() )
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 162
; FirstLine = 148
; Folding = --v
; EnableXP