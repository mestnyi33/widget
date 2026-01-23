IncludePath "../../../" 
XIncludeFile "widgets.pbi"



CompilerIf #PB_Compiler_IsMainFile
   UsePNGImageDecoder()
   UseWidgets( )
   
   Global *g._S_widget, g_Canvas, WordWrap, NewList *List._S_widget()

   If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
      End
   EndIf
   
   Procedure ResizeCallBack()
      ResizeGadget(100, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-67, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-33, #PB_Ignore, #PB_Ignore)
      ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-80, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
      CompilerIf #PB_Compiler_Version =< 546
         PostEvent(#PB_Event_Gadget, EventWindow(), g_Canvas, #PB_EventType_Resize)
      CompilerEndIf
   EndProcedure
   
   Procedure SplitterCallBack()
      PostEvent(#PB_Event_Gadget, EventWindow(), g_Canvas, #PB_EventType_Resize)
   EndProcedure
   
   If OpenWindow(0, 0, 0, 222, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
      ButtonGadget(100, 0,0,60,25,"~wrap")
      
      Define i,a,g 
      
      EditorGadget(g, 230, 10, 210, 210)                                         
      For i=0 To 10
         If i = 5
            AddGadgetItem(g, -1, "Line_long_long_long_long_long_"+Str(i))
         Else
            AddGadgetItem(g, -1, "Line_"+Str(i))
         EndIf
      Next
      
      SetGadgetFont(#PB_All, GetGadgetFont(g))
      
      Open(0, 270, 10, 250, 150)
      g_Canvas = GetCanvasGadget(Root())
      
      *g=Editor(0, 0, 250, 150, #__Flag_autosize)
      For i=0 To 10
         If i = 5
            AddItem(*g, -1, "Line_long_long_long_long_long_"+Str(i))
         Else
            AddItem(*g, -1, "Line_"+Str(i))
         EndIf
      Next
      
      ;
      SplitterGadget(10,8, 8, 306, 491-16,g_Canvas, 0)
      CompilerIf #PB_Compiler_Version =< 546
         BindGadgetEvent(10, @SplitterCallBack())
      CompilerEndIf
      PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug no linux
      BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
      
      Repeat
         Select WaitWindowEvent()   
            Case #PB_Event_Gadget
               If EventGadget() = 100
                  WordWrap ! 1
                  SetGadgetAttribute(g, #PB_Editor_WordWrap, WordWrap)
                  If SetAttribute(*g, #PB_Editor_WordWrap, WordWrap)
                     Repaint( )
                  EndIf
                  
                  Debug ""+GetGadgetAttribute(g, #PB_Editor_WordWrap) +" "+
                        GetAttribute(*g, #PB_Editor_WordWrap)
               EndIf
               
            Case #PB_Event_CloseWindow
               CloseWindow(EventWindow()) 
               Break
         EndSelect
      ForEver
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 74
; FirstLine = 54
; Folding = ---
; EnableXP
; DPIAware