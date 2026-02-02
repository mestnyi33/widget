IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  UsePNGImageDecoder()
  test_draw_area = 1
   
  
  If Not LoadImage(0,  #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png")   
    End
  EndIf
  
  If Not LoadImage(#PB_Button_Image,  #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png")   
    End
  EndIf
  
  If Not LoadImage(#PB_Button_PressedImage,  #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")  
    End
  EndIf
  
  Procedure OpenCanvas( ID, X,Y,Width,Height, Flag.q=0 )
     Protected window, gadget
     ;
     If IsGadget(ID) And 
        GadgetType(ID) = #PB_GadgetType_Canvas
        window = parent::window(ID)
        gadget = ID
     Else
        ;window = ID::Window(UseGadgetList(0))
        gadget = #PB_Any
        If ID = #PB_Any
           
        EndIf
        window = ID
     EndIf
     
     Open( window, X,Y,Width,Height, "", Flag, 0, gadget ) 
  EndProcedure
  
  
  Procedure Canvas( gadget, X,Y,Width,Height, int, Flag.q=0 )
     Protected._S_WIDGET *g
    ; Protected window = ID::Window(UseGadgetList(0))
;      Protected g = CanvasGadget( gadget, X,Y,Width,Height ) : If IsGadget(g) : gadget = g : EndIf
;      Open( window, #PB_Ignore,#PB_Ignore,#PB_Ignore,#PB_Ignore, "", 0, 0, gadget )  
     
     Open( #PB_Any, X,Y,Width,Height, "", Flag, 0, gadget ) 
     ;*g = ButtonImage(0, 0, 0, 0, int, #__flag_autosize)
     ;*g = Button(0, 0, Width,Height, ""):SetImage(*g, int)
     *g = ButtonImage(0, 0, Width,Height, int)
     ;*g = Image(0, 0, Width,Height, int)
     gadget = *g\root\canvas\gadget
     SetGadgetData( gadget, *g)
     ; CloseGadgetList( )
     ProcedureReturn gadget
  EndProcedure
  
  
  If OpenWindow(0, 0, 0, 200, 110, "Image Button Gadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ButtonImageGadget(0, 10, 10, 180, 40, ImageID(0))
    
    ; SetGadgetAttribute(0, #PB_Button_Image, ImageID(#PB_Button_Image))
    SetGadgetAttribute(0, #PB_Button_PressedImage, ImageID(#PB_Button_PressedImage))
    
    ;Open( 0, 10, 60, 180, 40 ) : ButtonImage(0, 0, 0, 0, (0), #__flag_autosize)
    Define gadget = Canvas( -1, 10, 60, 180, 40, (0) )
    ;Debug widget()\width
    ; SetAttribute( GetGadgetData( gadget ), #PB_Button_Image, (#PB_Button_Image))
    SetAttribute( GetGadgetData( gadget ), #PB_Button_PressedImage, (#PB_Button_PressedImage))
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 50
; FirstLine = 28
; Folding = --
; EnableXP
; DPIAware