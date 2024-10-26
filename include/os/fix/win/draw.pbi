DeclareModule draw
   Global DrawingDC
   Macro PB(Function)
      Function
   EndMacro
   
   
   Macro FIXME(Function)
      draw::win_#Function
   EndMacro
   
   Macro DrawText(x, y, Text, FrontColor=$ffffff, BackColor=0)
      FIXME(DrawRotatedText)(x, y, Text, 0, FrontColor, BackColor)
   EndMacro
   
   
   Declare.i win_DrawRotatedText(x.i, y.i, Text.s, Angle.i, FrontColor=$ffffff, BackColor=0)
   
EndDeclareModule

Module draw
   Procedure.i win_DrawRotatedText(x.i, y.i, Text.s, Angle.i, FrontColor=$ffffff, BackColor=0)
      If DrawingDC
         Protected trec.RECT
         ;trec\left=x: trec\top=y: trec\right=100: trec\bottom=100
        ; Protected hBrush = CreateSolidBrush_($ff0000)
        ; FillRect_(DrawingDC, trec, hBrush)
         ;DrawText_(DrawingDC,Text,Len(Text),trec,#DT_CENTER|#DT_VCENTER|#DT_SINGLELINE) ; #DT_WORDBREAK
         
         
         ;SelectObject_(DrawingDC, FontID(#drawFont))
         SetBkMode_(DrawingDC, #TRANSPARENT)
         SetTextColor_(DrawingDC, FrontColor & $FFFFFF | 255 << 24)
         TextOut_(DrawingDC, x, y, Text,Len(Text))
      EndIf
   EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile
   UseModule draw
   
   Global x,y
   ; https://www.purebasic.fr/english/viewtopic.php?p=394079#p394079
   ; *** test ***
   Procedure events_gadgets()
      Select EventType()
         Case #PB_EventType_LeftButtonDown,
              #PB_EventType_LeftButtonUp
            
            Debug #PB_Compiler_Procedure +" "+ EventGadget() +" "+ EventType()
      EndSelect
   EndProcedure
   
   Procedure draw_demo(x,y)
      ClipOutput(x, y, 100, 100) ; restrict all drawing to this region
      
      DrawingMode(#PB_2DDrawing_Default)
      Circle( x,  y, 50, $FF0000FF)  
      Circle( x, y+100, 50, $Ff00FF00)  
      Circle(x+100,  y, 50, $FFFF0000)  
      Circle(x+100, y+100, 50, $FF00FFFF)  
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(x-10,y+(100-TextHeight("A"))/2,"error clip text in mac os", $FF000000)  
      
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(x, y, 100, 100, $FF000000)
   EndProcedure
   
   If PB(OpenWindow)(2, 200, 100, 460, 220, "bug clip and set origin then drawing", #PB_Window_SystemMenu)
      PB(CanvasGadget)(2, 10, 10, 440, 200)
      StringGadget(12, 400, 10, 40, 25, "●●●●")
      StringGadget(13, 400, 40, 40, 25, "●●●●", #PB_String_Password)
      Define FontID = PB(GetGadgetFont)( #PB_Default )
      
      If PB(StartDrawing)( PB(CanvasOutput)( 2 ) )
         If FontID
            PB(DrawingFont)( FontID )
         Else
            Debug "no-pb-FontID"
         EndIf
         ; bug 
         x = 50 : y = 50
         PB(ClipOutput)(x, y, 100, 100) ; restrict all drawing to this region
         
         PB(DrawingMode)(#PB_2DDrawing_Default)
         PB(Circle)( x,  y, 50, $FF0000FF)  
         PB(Circle)( x, y+100, 50, $Ff00FF00)  
         PB(Circle)(x+100,  y, 50, $FFFF0000)  
         PB(Circle)(x+100, y+100, 50, $FF00FFFF)  
         
         PB(DrawingMode)(#PB_2DDrawing_Transparent)
         PB(DrawText)(x-10,y+(100-PB(TextHeight)("A"))/2,"error clip text ●●●● in mac os", $FF000000)  
         
         PB(DrawingMode)(#PB_2DDrawing_Outlined)
         PB(Box)(x, y, 100, 100, $FF000000)
         
         PB(SetOrigin)( 20,20 )
         x = 200 : y = 50
         PB(ClipOutput)(x, y, 100, 100) ; restrict all drawing to this region
         
         PB(DrawingMode)(#PB_2DDrawing_Default)
         PB(Circle)( x,  y, 50, $FF0000FF)  
         PB(Circle)( x, y+100, 50, $Ff00FF00)  
         PB(Circle)(x+100,  y, 50, $FFFF0000)  
         PB(Circle)(x+100, y+100, 50, $FF00FFFF)  
         
         PB(DrawingMode)(#PB_2DDrawing_Transparent)
         PB(DrawText)(x-10,y+(100-PB(TextHeight)("A"))/2,"error set origin in mac os", $FF000000, $ffff0000)  
         
         PB(DrawingMode)(#PB_2DDrawing_Outlined)
         PB(Box)(x, y, 100, 100, $FF000000)
         
         PB(StopDrawing)( )
      EndIf
   EndIf
   
   If OpenWindow(1, 350, 250, 460, 220, "fix clip then drawing", #PB_Window_SystemMenu)   ; and set origin
      CanvasGadget(1, 10, 10, 440, 200)
      FontID = GetGadgetFont( #PB_Default )
      draw::DrawingDC = StartDrawing( CanvasOutput( 1 ) )
      
      If draw::DrawingDC ; StartDrawing( CanvasOutput( 1 ) )
         If FontID
            DrawingFont( FontID )
         Else
            Debug "no-FontID"
         EndIf
         ; fix
         x = 50 : y = 50
         ClipOutput(x, y, 100, 100) ; restrict all drawing to this region
         
         DrawingMode(#PB_2DDrawing_Default)
         Circle( x,  y, 50, $FF0000FF)  
         Circle( x, y+100, 50, $Ff00FF00)  
         Circle(x+100,  y, 50, $FFFF0000)  
         Circle(x+100, y+100, 50, $FF00FFFF)  
         
         DrawingMode(#PB_2DDrawing_Transparent)
         DrawText(x-10,y+(100-TextHeight("A"))/2,"error clip text ●●●● in mac os", $FF000000)  
         
         DrawingMode(#PB_2DDrawing_Outlined)
         Box(x, y, 100, 100, $FF000000)
         
         SetOrigin( 20,20 )
         x = 200 : y = 50
         ClipOutput(x, y, 100, 100) ; restrict all drawing to this region
         
         DrawingMode(#PB_2DDrawing_Default)
         Circle( x,  y, 50, $FF0000FF)  
         Circle( x, y+100, 50, $Ff00FF00)  
         Circle(x+100,  y, 50, $FFFF0000)  
         Circle(x+100, y+100, 50, $FF00FFFF)  
         
         DrawingMode(#PB_2DDrawing_Transparent)
         DrawText(x-10,y+(100-TextHeight("A"))/2,"error clip text in mac os", $FF000000, $ffff0000)  
         
         DrawingMode(#PB_2DDrawing_Outlined)
         Box(x, y, 100, 100, $FF000000)
         
         StopDrawing( )
      EndIf
   EndIf
   
   BindEvent( #PB_Event_Gadget, @events_gadgets() )
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 15
; Folding = ---
; EnableXP
; DPIAware