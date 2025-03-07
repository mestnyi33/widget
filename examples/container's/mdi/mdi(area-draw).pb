XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   EnableExplicit
   Global Event.i, MyCanvas, *mdi._s_widget, vButton, hButton
   Global X=200,Y=150, Width=320, Height=320 , focus
   
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
        Protected X, Y
       Draw_Button( *Object )
     
   EndProcedure
   
   Procedure MDI_ObjectEvents( )
      Protected *ew._s_widget = EventWidget( )
      Static DragWidget
      
      Select WidgetEvent( )
            ;       Case #__event_MouseEnter
            ;         SetCursor( *ew, #PB_Cursor_Hand )
            ;         
            ;       Case #__event_MouseLeave
            ;         SetCursor( *ew, #PB_Cursor_Default )
            
         Case #__event_LeftUp 
            DragWidget = #Null
            
         Case #__event_LeftDown
            DragWidget = *ew
            
         Case #__event_MouseMove
            If DragWidget = *ew
              Resize( *ew\parent, mouse()\x-mouse()\delta\x, mouse()\y-mouse()\delta\y, #PB_Ignore, #PB_Ignore, 0)
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
   
   Procedure MDI_AddObject( *mdi, Type, X, Y, Width, Height, Text.s, round=0 )
      Protected *Object._s_widget
      
      *Object = AddItem( *mdi, -1, "", -1, #__flag_BorderLess )
      *Object\class = "draw-"+Str(Type)
      *Object\cursor = #PB_Cursor_Hand
      *Object\round = DPIScaled(round)
      
      If Type = #PB_GadgetType_Button
         ;*Object\root\widget =
         Define *this = Button(0,0,0,0,Text,#__flag_autosize, round)
        ; Define *this = Image(0,0,0,0,-1,#__flag_autosize) : SetRound( *this, round )
        ; a_set( *this )
      EndIf
      
      Resize(*Object, X, Y, Width, Height)
      
      *Object = *this ; *Object\root\widget
      Bind( *Object, @MDI_ObjectEvents(), #__event_LeftUp )
      Bind( *Object, @MDI_ObjectEvents(), #__event_LeftDown )
      Bind( *Object, @MDI_ObjectEvents(), #__event_MouseMove )
      Bind( *Object, @MDI_ObjectEvents(), #__event_MouseEnter )
      Bind( *Object, @MDI_ObjectEvents(), #__event_MouseLeave )
      Bind( *Object, @MDI_ObjectEvents(), #__event_Draw )
   EndProcedure
   
   ;- \\
   Procedure Canvas_resize( )
      ;Protected width = GadgetWidth( EventGadget() )
      Protected Width = WindowWidth( EventWindow() )
      Resize( root(), #PB_Ignore, #PB_Ignore, Width, #PB_Ignore )
      Resize( *mdi, #PB_Ignore, #PB_Ignore, Width-X*2, #PB_Ignore )
   EndProcedure
   
   Procedure Gadgets_Events()
      Select EventGadget()
         Case 2
            If GetGadgetState(2)
                  SetGadgetText(2, "vertical bar")
              SetGadgetState(3, GetAttribute(*mdi\scroll\v, #__flag_Invert))
            Else
                SetGadgetText(2, "horizontal bar")
                SetGadgetState(3, GetAttribute(*mdi\scroll\h, #__flag_Invert))
            EndIf
            
         Case 3
            If GetGadgetState(2)
               SetAttribute(*mdi\scroll\v, #__flag_Invert, Bool(GetGadgetState(3)))
               SetWindowTitle(0, Str(GetState(*mdi\scroll\v)))
            Else
               SetAttribute(*mdi\scroll\h, #__flag_Invert, Bool(GetGadgetState(3)))
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
   If Not OpenWindow( 0, 0, 0, Width+X*2+20+xx, Height+Y*2+20+yy, "Move/Drag Canvas Object", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered ) 
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
   ImageGadget(#PB_Any, Width+X*2+20-210,10,200,80, ImageID(0) )
   
   Define round = 50
   
   ;
   MyCanvas = GetCanvasGadget(Open(0, xx+10, yy+10, Width+X*2, Height+Y*2 ) )
   SetColor(root(), #PB_Gadget_BackColor, $ffffffff)
   
   ;BindGadgetEvent(MyCanvas, @Canvas_resize(), #PB_EventType_Resize )
   ;   ;BindEvent(#PB_Event_SizeWindow, @Canvas_resize());, GetCanvasWindow(Root()), MyCanvas, #PB_EventType_Resize )
   
   *mdi = MDI(X,Y,Width,Height);, #__flag_autosize)
   mouse( )\steps = 35
   a_init( *mdi )
   ;SetColor(*mdi, #pb_gadget_backcolor, $ffffffff)
   SetColor(*mdi, #__FrameColor, $ffffffff)
   
   Define b=DPIScaled(19);20        
   *mdi\scroll\v\round = DPIScaled(11)
   *mdi\scroll\v\bar\button[1]\round = *mdi\scroll\v\round
   *mdi\scroll\v\bar\button[2]\round = *mdi\scroll\v\round
   *mdi\scroll\v\bar\button\round = *mdi\scroll\v\round
   SetAttribute(*mdi\scroll\v, #__bar_buttonsize, b)
   
   *mdi\scroll\h\round = DPIScaled(11)
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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 216
; FirstLine = 207
; Folding = ---
; EnableXP
; DPIAware